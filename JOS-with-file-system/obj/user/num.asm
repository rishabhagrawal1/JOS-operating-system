
obj/user/num.debug:     file format elf64-x86-64


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
  80003c:	e8 97 02 00 00       	callq  8002d8 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <num>:
int bol = 1;
int line = 0;

void
num(int f, const char *s)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  800052:	e9 da 00 00 00       	jmpq   800131 <num+0xee>
		if (bol) {
  800057:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  80005e:	00 00 00 
  800061:	8b 00                	mov    (%rax),%eax
  800063:	85 c0                	test   %eax,%eax
  800065:	74 54                	je     8000bb <num+0x78>
			printf("%5d ", ++line);
  800067:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80006e:	00 00 00 
  800071:	8b 00                	mov    (%rax),%eax
  800073:	8d 50 01             	lea    0x1(%rax),%edx
  800076:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80007d:	00 00 00 
  800080:	89 10                	mov    %edx,(%rax)
  800082:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800089:	00 00 00 
  80008c:	8b 00                	mov    (%rax),%eax
  80008e:	89 c6                	mov    %eax,%esi
  800090:	48 bf 40 39 80 00 00 	movabs $0x803940,%rdi
  800097:	00 00 00 
  80009a:	b8 00 00 00 00       	mov    $0x0,%eax
  80009f:	48 ba 87 2d 80 00 00 	movabs $0x802d87,%rdx
  8000a6:	00 00 00 
  8000a9:	ff d2                	callq  *%rdx
			bol = 0;
  8000ab:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8000b2:	00 00 00 
  8000b5:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		}
		if ((r = write(1, &c, 1)) != 1)
  8000bb:	48 8d 45 f3          	lea    -0xd(%rbp),%rax
  8000bf:	ba 01 00 00 00       	mov    $0x1,%edx
  8000c4:	48 89 c6             	mov    %rax,%rsi
  8000c7:	bf 01 00 00 00       	mov    $0x1,%edi
  8000cc:	48 b8 72 23 80 00 00 	movabs $0x802372,%rax
  8000d3:	00 00 00 
  8000d6:	ff d0                	callq  *%rax
  8000d8:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8000db:	83 7d f4 01          	cmpl   $0x1,-0xc(%rbp)
  8000df:	74 38                	je     800119 <num+0xd6>
			panic("write error copying %s: %e", s, r);
  8000e1:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8000e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000e8:	41 89 d0             	mov    %edx,%r8d
  8000eb:	48 89 c1             	mov    %rax,%rcx
  8000ee:	48 ba 45 39 80 00 00 	movabs $0x803945,%rdx
  8000f5:	00 00 00 
  8000f8:	be 13 00 00 00       	mov    $0x13,%esi
  8000fd:	48 bf 60 39 80 00 00 	movabs $0x803960,%rdi
  800104:	00 00 00 
  800107:	b8 00 00 00 00       	mov    $0x0,%eax
  80010c:	49 b9 86 03 80 00 00 	movabs $0x800386,%r9
  800113:	00 00 00 
  800116:	41 ff d1             	callq  *%r9
		if (c == '\n')
  800119:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
  80011d:	3c 0a                	cmp    $0xa,%al
  80011f:	75 10                	jne    800131 <num+0xee>
			bol = 1;
  800121:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800128:	00 00 00 
  80012b:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
{
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  800131:	48 8d 4d f3          	lea    -0xd(%rbp),%rcx
  800135:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800138:	ba 01 00 00 00       	mov    $0x1,%edx
  80013d:	48 89 ce             	mov    %rcx,%rsi
  800140:	89 c7                	mov    %eax,%edi
  800142:	48 b8 28 22 80 00 00 	movabs $0x802228,%rax
  800149:	00 00 00 
  80014c:	ff d0                	callq  *%rax
  80014e:	48 98                	cltq   
  800150:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800154:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  800159:	0f 8f f8 fe ff ff    	jg     800057 <num+0x14>
		if ((r = write(1, &c, 1)) != 1)
			panic("write error copying %s: %e", s, r);
		if (c == '\n')
			bol = 1;
	}
	if (n < 0)
  80015f:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  800164:	79 39                	jns    80019f <num+0x15c>
		panic("error reading %s: %e", s, n);
  800166:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80016a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80016e:	49 89 d0             	mov    %rdx,%r8
  800171:	48 89 c1             	mov    %rax,%rcx
  800174:	48 ba 6b 39 80 00 00 	movabs $0x80396b,%rdx
  80017b:	00 00 00 
  80017e:	be 18 00 00 00       	mov    $0x18,%esi
  800183:	48 bf 60 39 80 00 00 	movabs $0x803960,%rdi
  80018a:	00 00 00 
  80018d:	b8 00 00 00 00       	mov    $0x0,%eax
  800192:	49 b9 86 03 80 00 00 	movabs $0x800386,%r9
  800199:	00 00 00 
  80019c:	41 ff d1             	callq  *%r9
}
  80019f:	c9                   	leaveq 
  8001a0:	c3                   	retq   

00000000008001a1 <umain>:

void
umain(int argc, char **argv)
{
  8001a1:	55                   	push   %rbp
  8001a2:	48 89 e5             	mov    %rsp,%rbp
  8001a5:	53                   	push   %rbx
  8001a6:	48 83 ec 28          	sub    $0x28,%rsp
  8001aa:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8001ad:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int f, i;

	binaryname = "num";
  8001b1:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8001b8:	00 00 00 
  8001bb:	48 bb 80 39 80 00 00 	movabs $0x803980,%rbx
  8001c2:	00 00 00 
  8001c5:	48 89 18             	mov    %rbx,(%rax)
	if (argc == 1)
  8001c8:	83 7d dc 01          	cmpl   $0x1,-0x24(%rbp)
  8001cc:	75 20                	jne    8001ee <umain+0x4d>
		num(0, "<stdin>");
  8001ce:	48 be 84 39 80 00 00 	movabs $0x803984,%rsi
  8001d5:	00 00 00 
  8001d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8001dd:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001e4:	00 00 00 
  8001e7:	ff d0                	callq  *%rax
  8001e9:	e9 d7 00 00 00       	jmpq   8002c5 <umain+0x124>
	else
		for (i = 1; i < argc; i++) {
  8001ee:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%rbp)
  8001f5:	e9 bf 00 00 00       	jmpq   8002b9 <umain+0x118>
			f = open(argv[i], O_RDONLY);
  8001fa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001fd:	48 98                	cltq   
  8001ff:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800206:	00 
  800207:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80020b:	48 01 d0             	add    %rdx,%rax
  80020e:	48 8b 00             	mov    (%rax),%rax
  800211:	be 00 00 00 00       	mov    $0x0,%esi
  800216:	48 89 c7             	mov    %rax,%rdi
  800219:	48 b8 fe 26 80 00 00 	movabs $0x8026fe,%rax
  800220:	00 00 00 
  800223:	ff d0                	callq  *%rax
  800225:	89 45 e8             	mov    %eax,-0x18(%rbp)
			if (f < 0)
  800228:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80022c:	79 4b                	jns    800279 <umain+0xd8>
				panic("can't open %s: %e", argv[i], f);
  80022e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800231:	48 98                	cltq   
  800233:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80023a:	00 
  80023b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80023f:	48 01 d0             	add    %rdx,%rax
  800242:	48 8b 00             	mov    (%rax),%rax
  800245:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800248:	41 89 d0             	mov    %edx,%r8d
  80024b:	48 89 c1             	mov    %rax,%rcx
  80024e:	48 ba 8c 39 80 00 00 	movabs $0x80398c,%rdx
  800255:	00 00 00 
  800258:	be 27 00 00 00       	mov    $0x27,%esi
  80025d:	48 bf 60 39 80 00 00 	movabs $0x803960,%rdi
  800264:	00 00 00 
  800267:	b8 00 00 00 00       	mov    $0x0,%eax
  80026c:	49 b9 86 03 80 00 00 	movabs $0x800386,%r9
  800273:	00 00 00 
  800276:	41 ff d1             	callq  *%r9
			else {
				num(f, argv[i]);
  800279:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80027c:	48 98                	cltq   
  80027e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800285:	00 
  800286:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80028a:	48 01 d0             	add    %rdx,%rax
  80028d:	48 8b 10             	mov    (%rax),%rdx
  800290:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800293:	48 89 d6             	mov    %rdx,%rsi
  800296:	89 c7                	mov    %eax,%edi
  800298:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80029f:	00 00 00 
  8002a2:	ff d0                	callq  *%rax
				close(f);
  8002a4:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8002a7:	89 c7                	mov    %eax,%edi
  8002a9:	48 b8 06 20 80 00 00 	movabs $0x802006,%rax
  8002b0:	00 00 00 
  8002b3:	ff d0                	callq  *%rax

	binaryname = "num";
	if (argc == 1)
		num(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  8002b5:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  8002b9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8002bc:	3b 45 dc             	cmp    -0x24(%rbp),%eax
  8002bf:	0f 8c 35 ff ff ff    	jl     8001fa <umain+0x59>
			else {
				num(f, argv[i]);
				close(f);
			}
		}
	exit();
  8002c5:	48 b8 63 03 80 00 00 	movabs $0x800363,%rax
  8002cc:	00 00 00 
  8002cf:	ff d0                	callq  *%rax
}
  8002d1:	48 83 c4 28          	add    $0x28,%rsp
  8002d5:	5b                   	pop    %rbx
  8002d6:	5d                   	pop    %rbp
  8002d7:	c3                   	retq   

00000000008002d8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002d8:	55                   	push   %rbp
  8002d9:	48 89 e5             	mov    %rsp,%rbp
  8002dc:	48 83 ec 10          	sub    $0x10,%rsp
  8002e0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002e3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8002e7:	48 b8 27 1a 80 00 00 	movabs $0x801a27,%rax
  8002ee:	00 00 00 
  8002f1:	ff d0                	callq  *%rax
  8002f3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002f8:	48 63 d0             	movslq %eax,%rdx
  8002fb:	48 89 d0             	mov    %rdx,%rax
  8002fe:	48 c1 e0 03          	shl    $0x3,%rax
  800302:	48 01 d0             	add    %rdx,%rax
  800305:	48 c1 e0 05          	shl    $0x5,%rax
  800309:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800310:	00 00 00 
  800313:	48 01 c2             	add    %rax,%rdx
  800316:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80031d:	00 00 00 
  800320:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800323:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800327:	7e 14                	jle    80033d <libmain+0x65>
		binaryname = argv[0];
  800329:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80032d:	48 8b 10             	mov    (%rax),%rdx
  800330:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800337:	00 00 00 
  80033a:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80033d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800341:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800344:	48 89 d6             	mov    %rdx,%rsi
  800347:	89 c7                	mov    %eax,%edi
  800349:	48 b8 a1 01 80 00 00 	movabs $0x8001a1,%rax
  800350:	00 00 00 
  800353:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  800355:	48 b8 63 03 80 00 00 	movabs $0x800363,%rax
  80035c:	00 00 00 
  80035f:	ff d0                	callq  *%rax
}
  800361:	c9                   	leaveq 
  800362:	c3                   	retq   

0000000000800363 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800363:	55                   	push   %rbp
  800364:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800367:	48 b8 51 20 80 00 00 	movabs $0x802051,%rax
  80036e:	00 00 00 
  800371:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800373:	bf 00 00 00 00       	mov    $0x0,%edi
  800378:	48 b8 e3 19 80 00 00 	movabs $0x8019e3,%rax
  80037f:	00 00 00 
  800382:	ff d0                	callq  *%rax

}
  800384:	5d                   	pop    %rbp
  800385:	c3                   	retq   

0000000000800386 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800386:	55                   	push   %rbp
  800387:	48 89 e5             	mov    %rsp,%rbp
  80038a:	53                   	push   %rbx
  80038b:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800392:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800399:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80039f:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8003a6:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8003ad:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8003b4:	84 c0                	test   %al,%al
  8003b6:	74 23                	je     8003db <_panic+0x55>
  8003b8:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8003bf:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8003c3:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8003c7:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8003cb:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8003cf:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8003d3:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8003d7:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8003db:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8003e2:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8003e9:	00 00 00 
  8003ec:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8003f3:	00 00 00 
  8003f6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003fa:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800401:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800408:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80040f:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800416:	00 00 00 
  800419:	48 8b 18             	mov    (%rax),%rbx
  80041c:	48 b8 27 1a 80 00 00 	movabs $0x801a27,%rax
  800423:	00 00 00 
  800426:	ff d0                	callq  *%rax
  800428:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80042e:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800435:	41 89 c8             	mov    %ecx,%r8d
  800438:	48 89 d1             	mov    %rdx,%rcx
  80043b:	48 89 da             	mov    %rbx,%rdx
  80043e:	89 c6                	mov    %eax,%esi
  800440:	48 bf a8 39 80 00 00 	movabs $0x8039a8,%rdi
  800447:	00 00 00 
  80044a:	b8 00 00 00 00       	mov    $0x0,%eax
  80044f:	49 b9 bf 05 80 00 00 	movabs $0x8005bf,%r9
  800456:	00 00 00 
  800459:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80045c:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800463:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80046a:	48 89 d6             	mov    %rdx,%rsi
  80046d:	48 89 c7             	mov    %rax,%rdi
  800470:	48 b8 13 05 80 00 00 	movabs $0x800513,%rax
  800477:	00 00 00 
  80047a:	ff d0                	callq  *%rax
	cprintf("\n");
  80047c:	48 bf cb 39 80 00 00 	movabs $0x8039cb,%rdi
  800483:	00 00 00 
  800486:	b8 00 00 00 00       	mov    $0x0,%eax
  80048b:	48 ba bf 05 80 00 00 	movabs $0x8005bf,%rdx
  800492:	00 00 00 
  800495:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800497:	cc                   	int3   
  800498:	eb fd                	jmp    800497 <_panic+0x111>

000000000080049a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80049a:	55                   	push   %rbp
  80049b:	48 89 e5             	mov    %rsp,%rbp
  80049e:	48 83 ec 10          	sub    $0x10,%rsp
  8004a2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004a5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  8004a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004ad:	8b 00                	mov    (%rax),%eax
  8004af:	8d 48 01             	lea    0x1(%rax),%ecx
  8004b2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004b6:	89 0a                	mov    %ecx,(%rdx)
  8004b8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8004bb:	89 d1                	mov    %edx,%ecx
  8004bd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004c1:	48 98                	cltq   
  8004c3:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  8004c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004cb:	8b 00                	mov    (%rax),%eax
  8004cd:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004d2:	75 2c                	jne    800500 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  8004d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004d8:	8b 00                	mov    (%rax),%eax
  8004da:	48 98                	cltq   
  8004dc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004e0:	48 83 c2 08          	add    $0x8,%rdx
  8004e4:	48 89 c6             	mov    %rax,%rsi
  8004e7:	48 89 d7             	mov    %rdx,%rdi
  8004ea:	48 b8 5b 19 80 00 00 	movabs $0x80195b,%rax
  8004f1:	00 00 00 
  8004f4:	ff d0                	callq  *%rax
		b->idx = 0;
  8004f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004fa:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800500:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800504:	8b 40 04             	mov    0x4(%rax),%eax
  800507:	8d 50 01             	lea    0x1(%rax),%edx
  80050a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80050e:	89 50 04             	mov    %edx,0x4(%rax)
}
  800511:	c9                   	leaveq 
  800512:	c3                   	retq   

0000000000800513 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800513:	55                   	push   %rbp
  800514:	48 89 e5             	mov    %rsp,%rbp
  800517:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80051e:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800525:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  80052c:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800533:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80053a:	48 8b 0a             	mov    (%rdx),%rcx
  80053d:	48 89 08             	mov    %rcx,(%rax)
  800540:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800544:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800548:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80054c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  800550:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800557:	00 00 00 
	b.cnt = 0;
  80055a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800561:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  800564:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80056b:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800572:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800579:	48 89 c6             	mov    %rax,%rsi
  80057c:	48 bf 9a 04 80 00 00 	movabs $0x80049a,%rdi
  800583:	00 00 00 
  800586:	48 b8 72 09 80 00 00 	movabs $0x800972,%rax
  80058d:	00 00 00 
  800590:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  800592:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800598:	48 98                	cltq   
  80059a:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8005a1:	48 83 c2 08          	add    $0x8,%rdx
  8005a5:	48 89 c6             	mov    %rax,%rsi
  8005a8:	48 89 d7             	mov    %rdx,%rdi
  8005ab:	48 b8 5b 19 80 00 00 	movabs $0x80195b,%rax
  8005b2:	00 00 00 
  8005b5:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  8005b7:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8005bd:	c9                   	leaveq 
  8005be:	c3                   	retq   

00000000008005bf <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8005bf:	55                   	push   %rbp
  8005c0:	48 89 e5             	mov    %rsp,%rbp
  8005c3:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8005ca:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8005d1:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8005d8:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8005df:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8005e6:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8005ed:	84 c0                	test   %al,%al
  8005ef:	74 20                	je     800611 <cprintf+0x52>
  8005f1:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8005f5:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8005f9:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8005fd:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800601:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800605:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800609:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80060d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800611:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800618:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80061f:	00 00 00 
  800622:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800629:	00 00 00 
  80062c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800630:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800637:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80063e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800645:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80064c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800653:	48 8b 0a             	mov    (%rdx),%rcx
  800656:	48 89 08             	mov    %rcx,(%rax)
  800659:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80065d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800661:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800665:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  800669:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800670:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800677:	48 89 d6             	mov    %rdx,%rsi
  80067a:	48 89 c7             	mov    %rax,%rdi
  80067d:	48 b8 13 05 80 00 00 	movabs $0x800513,%rax
  800684:	00 00 00 
  800687:	ff d0                	callq  *%rax
  800689:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  80068f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800695:	c9                   	leaveq 
  800696:	c3                   	retq   

0000000000800697 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800697:	55                   	push   %rbp
  800698:	48 89 e5             	mov    %rsp,%rbp
  80069b:	53                   	push   %rbx
  80069c:	48 83 ec 38          	sub    $0x38,%rsp
  8006a0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006a4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8006a8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8006ac:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8006af:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8006b3:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006b7:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8006ba:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8006be:	77 3b                	ja     8006fb <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006c0:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8006c3:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8006c7:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8006ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8006ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d3:	48 f7 f3             	div    %rbx
  8006d6:	48 89 c2             	mov    %rax,%rdx
  8006d9:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8006dc:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8006df:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8006e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e7:	41 89 f9             	mov    %edi,%r9d
  8006ea:	48 89 c7             	mov    %rax,%rdi
  8006ed:	48 b8 97 06 80 00 00 	movabs $0x800697,%rax
  8006f4:	00 00 00 
  8006f7:	ff d0                	callq  *%rax
  8006f9:	eb 1e                	jmp    800719 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006fb:	eb 12                	jmp    80070f <printnum+0x78>
			putch(padc, putdat);
  8006fd:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800701:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800704:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800708:	48 89 ce             	mov    %rcx,%rsi
  80070b:	89 d7                	mov    %edx,%edi
  80070d:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80070f:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800713:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800717:	7f e4                	jg     8006fd <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800719:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80071c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800720:	ba 00 00 00 00       	mov    $0x0,%edx
  800725:	48 f7 f1             	div    %rcx
  800728:	48 89 d0             	mov    %rdx,%rax
  80072b:	48 ba a8 3b 80 00 00 	movabs $0x803ba8,%rdx
  800732:	00 00 00 
  800735:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800739:	0f be d0             	movsbl %al,%edx
  80073c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800740:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800744:	48 89 ce             	mov    %rcx,%rsi
  800747:	89 d7                	mov    %edx,%edi
  800749:	ff d0                	callq  *%rax
}
  80074b:	48 83 c4 38          	add    $0x38,%rsp
  80074f:	5b                   	pop    %rbx
  800750:	5d                   	pop    %rbp
  800751:	c3                   	retq   

0000000000800752 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800752:	55                   	push   %rbp
  800753:	48 89 e5             	mov    %rsp,%rbp
  800756:	48 83 ec 1c          	sub    $0x1c,%rsp
  80075a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80075e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800761:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800765:	7e 52                	jle    8007b9 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800767:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80076b:	8b 00                	mov    (%rax),%eax
  80076d:	83 f8 30             	cmp    $0x30,%eax
  800770:	73 24                	jae    800796 <getuint+0x44>
  800772:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800776:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80077a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80077e:	8b 00                	mov    (%rax),%eax
  800780:	89 c0                	mov    %eax,%eax
  800782:	48 01 d0             	add    %rdx,%rax
  800785:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800789:	8b 12                	mov    (%rdx),%edx
  80078b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80078e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800792:	89 0a                	mov    %ecx,(%rdx)
  800794:	eb 17                	jmp    8007ad <getuint+0x5b>
  800796:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80079e:	48 89 d0             	mov    %rdx,%rax
  8007a1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007a5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007a9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007ad:	48 8b 00             	mov    (%rax),%rax
  8007b0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007b4:	e9 a3 00 00 00       	jmpq   80085c <getuint+0x10a>
	else if (lflag)
  8007b9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007bd:	74 4f                	je     80080e <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8007bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c3:	8b 00                	mov    (%rax),%eax
  8007c5:	83 f8 30             	cmp    $0x30,%eax
  8007c8:	73 24                	jae    8007ee <getuint+0x9c>
  8007ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ce:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d6:	8b 00                	mov    (%rax),%eax
  8007d8:	89 c0                	mov    %eax,%eax
  8007da:	48 01 d0             	add    %rdx,%rax
  8007dd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e1:	8b 12                	mov    (%rdx),%edx
  8007e3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ea:	89 0a                	mov    %ecx,(%rdx)
  8007ec:	eb 17                	jmp    800805 <getuint+0xb3>
  8007ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007f6:	48 89 d0             	mov    %rdx,%rax
  8007f9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007fd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800801:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800805:	48 8b 00             	mov    (%rax),%rax
  800808:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80080c:	eb 4e                	jmp    80085c <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80080e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800812:	8b 00                	mov    (%rax),%eax
  800814:	83 f8 30             	cmp    $0x30,%eax
  800817:	73 24                	jae    80083d <getuint+0xeb>
  800819:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800821:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800825:	8b 00                	mov    (%rax),%eax
  800827:	89 c0                	mov    %eax,%eax
  800829:	48 01 d0             	add    %rdx,%rax
  80082c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800830:	8b 12                	mov    (%rdx),%edx
  800832:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800835:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800839:	89 0a                	mov    %ecx,(%rdx)
  80083b:	eb 17                	jmp    800854 <getuint+0x102>
  80083d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800841:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800845:	48 89 d0             	mov    %rdx,%rax
  800848:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80084c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800850:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800854:	8b 00                	mov    (%rax),%eax
  800856:	89 c0                	mov    %eax,%eax
  800858:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80085c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800860:	c9                   	leaveq 
  800861:	c3                   	retq   

0000000000800862 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800862:	55                   	push   %rbp
  800863:	48 89 e5             	mov    %rsp,%rbp
  800866:	48 83 ec 1c          	sub    $0x1c,%rsp
  80086a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80086e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800871:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800875:	7e 52                	jle    8008c9 <getint+0x67>
		x=va_arg(*ap, long long);
  800877:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80087b:	8b 00                	mov    (%rax),%eax
  80087d:	83 f8 30             	cmp    $0x30,%eax
  800880:	73 24                	jae    8008a6 <getint+0x44>
  800882:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800886:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80088a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80088e:	8b 00                	mov    (%rax),%eax
  800890:	89 c0                	mov    %eax,%eax
  800892:	48 01 d0             	add    %rdx,%rax
  800895:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800899:	8b 12                	mov    (%rdx),%edx
  80089b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80089e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008a2:	89 0a                	mov    %ecx,(%rdx)
  8008a4:	eb 17                	jmp    8008bd <getint+0x5b>
  8008a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008aa:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008ae:	48 89 d0             	mov    %rdx,%rax
  8008b1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008b5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008b9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008bd:	48 8b 00             	mov    (%rax),%rax
  8008c0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008c4:	e9 a3 00 00 00       	jmpq   80096c <getint+0x10a>
	else if (lflag)
  8008c9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8008cd:	74 4f                	je     80091e <getint+0xbc>
		x=va_arg(*ap, long);
  8008cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d3:	8b 00                	mov    (%rax),%eax
  8008d5:	83 f8 30             	cmp    $0x30,%eax
  8008d8:	73 24                	jae    8008fe <getint+0x9c>
  8008da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008de:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e6:	8b 00                	mov    (%rax),%eax
  8008e8:	89 c0                	mov    %eax,%eax
  8008ea:	48 01 d0             	add    %rdx,%rax
  8008ed:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008f1:	8b 12                	mov    (%rdx),%edx
  8008f3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008fa:	89 0a                	mov    %ecx,(%rdx)
  8008fc:	eb 17                	jmp    800915 <getint+0xb3>
  8008fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800902:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800906:	48 89 d0             	mov    %rdx,%rax
  800909:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80090d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800911:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800915:	48 8b 00             	mov    (%rax),%rax
  800918:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80091c:	eb 4e                	jmp    80096c <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80091e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800922:	8b 00                	mov    (%rax),%eax
  800924:	83 f8 30             	cmp    $0x30,%eax
  800927:	73 24                	jae    80094d <getint+0xeb>
  800929:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80092d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800931:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800935:	8b 00                	mov    (%rax),%eax
  800937:	89 c0                	mov    %eax,%eax
  800939:	48 01 d0             	add    %rdx,%rax
  80093c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800940:	8b 12                	mov    (%rdx),%edx
  800942:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800945:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800949:	89 0a                	mov    %ecx,(%rdx)
  80094b:	eb 17                	jmp    800964 <getint+0x102>
  80094d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800951:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800955:	48 89 d0             	mov    %rdx,%rax
  800958:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80095c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800960:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800964:	8b 00                	mov    (%rax),%eax
  800966:	48 98                	cltq   
  800968:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80096c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800970:	c9                   	leaveq 
  800971:	c3                   	retq   

0000000000800972 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800972:	55                   	push   %rbp
  800973:	48 89 e5             	mov    %rsp,%rbp
  800976:	41 54                	push   %r12
  800978:	53                   	push   %rbx
  800979:	48 83 ec 60          	sub    $0x60,%rsp
  80097d:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800981:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800985:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800989:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80098d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800991:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800995:	48 8b 0a             	mov    (%rdx),%rcx
  800998:	48 89 08             	mov    %rcx,(%rax)
  80099b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80099f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8009a3:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8009a7:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009ab:	eb 17                	jmp    8009c4 <vprintfmt+0x52>
			if (ch == '\0')
  8009ad:	85 db                	test   %ebx,%ebx
  8009af:	0f 84 cc 04 00 00    	je     800e81 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  8009b5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009b9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009bd:	48 89 d6             	mov    %rdx,%rsi
  8009c0:	89 df                	mov    %ebx,%edi
  8009c2:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009c4:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009c8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8009cc:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009d0:	0f b6 00             	movzbl (%rax),%eax
  8009d3:	0f b6 d8             	movzbl %al,%ebx
  8009d6:	83 fb 25             	cmp    $0x25,%ebx
  8009d9:	75 d2                	jne    8009ad <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009db:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8009df:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8009e6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8009ed:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8009f4:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009fb:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009ff:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a03:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a07:	0f b6 00             	movzbl (%rax),%eax
  800a0a:	0f b6 d8             	movzbl %al,%ebx
  800a0d:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800a10:	83 f8 55             	cmp    $0x55,%eax
  800a13:	0f 87 34 04 00 00    	ja     800e4d <vprintfmt+0x4db>
  800a19:	89 c0                	mov    %eax,%eax
  800a1b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800a22:	00 
  800a23:	48 b8 d0 3b 80 00 00 	movabs $0x803bd0,%rax
  800a2a:	00 00 00 
  800a2d:	48 01 d0             	add    %rdx,%rax
  800a30:	48 8b 00             	mov    (%rax),%rax
  800a33:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a35:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800a39:	eb c0                	jmp    8009fb <vprintfmt+0x89>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a3b:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800a3f:	eb ba                	jmp    8009fb <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a41:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800a48:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800a4b:	89 d0                	mov    %edx,%eax
  800a4d:	c1 e0 02             	shl    $0x2,%eax
  800a50:	01 d0                	add    %edx,%eax
  800a52:	01 c0                	add    %eax,%eax
  800a54:	01 d8                	add    %ebx,%eax
  800a56:	83 e8 30             	sub    $0x30,%eax
  800a59:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800a5c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a60:	0f b6 00             	movzbl (%rax),%eax
  800a63:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a66:	83 fb 2f             	cmp    $0x2f,%ebx
  800a69:	7e 0c                	jle    800a77 <vprintfmt+0x105>
  800a6b:	83 fb 39             	cmp    $0x39,%ebx
  800a6e:	7f 07                	jg     800a77 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a70:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a75:	eb d1                	jmp    800a48 <vprintfmt+0xd6>
			goto process_precision;
  800a77:	eb 58                	jmp    800ad1 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800a79:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a7c:	83 f8 30             	cmp    $0x30,%eax
  800a7f:	73 17                	jae    800a98 <vprintfmt+0x126>
  800a81:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a85:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a88:	89 c0                	mov    %eax,%eax
  800a8a:	48 01 d0             	add    %rdx,%rax
  800a8d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a90:	83 c2 08             	add    $0x8,%edx
  800a93:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a96:	eb 0f                	jmp    800aa7 <vprintfmt+0x135>
  800a98:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a9c:	48 89 d0             	mov    %rdx,%rax
  800a9f:	48 83 c2 08          	add    $0x8,%rdx
  800aa3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800aa7:	8b 00                	mov    (%rax),%eax
  800aa9:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800aac:	eb 23                	jmp    800ad1 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800aae:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ab2:	79 0c                	jns    800ac0 <vprintfmt+0x14e>
				width = 0;
  800ab4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800abb:	e9 3b ff ff ff       	jmpq   8009fb <vprintfmt+0x89>
  800ac0:	e9 36 ff ff ff       	jmpq   8009fb <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800ac5:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800acc:	e9 2a ff ff ff       	jmpq   8009fb <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800ad1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ad5:	79 12                	jns    800ae9 <vprintfmt+0x177>
				width = precision, precision = -1;
  800ad7:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ada:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800add:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800ae4:	e9 12 ff ff ff       	jmpq   8009fb <vprintfmt+0x89>
  800ae9:	e9 0d ff ff ff       	jmpq   8009fb <vprintfmt+0x89>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800aee:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800af2:	e9 04 ff ff ff       	jmpq   8009fb <vprintfmt+0x89>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800af7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800afa:	83 f8 30             	cmp    $0x30,%eax
  800afd:	73 17                	jae    800b16 <vprintfmt+0x1a4>
  800aff:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b03:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b06:	89 c0                	mov    %eax,%eax
  800b08:	48 01 d0             	add    %rdx,%rax
  800b0b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b0e:	83 c2 08             	add    $0x8,%edx
  800b11:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b14:	eb 0f                	jmp    800b25 <vprintfmt+0x1b3>
  800b16:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b1a:	48 89 d0             	mov    %rdx,%rax
  800b1d:	48 83 c2 08          	add    $0x8,%rdx
  800b21:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b25:	8b 10                	mov    (%rax),%edx
  800b27:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b2b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b2f:	48 89 ce             	mov    %rcx,%rsi
  800b32:	89 d7                	mov    %edx,%edi
  800b34:	ff d0                	callq  *%rax
			break;
  800b36:	e9 40 03 00 00       	jmpq   800e7b <vprintfmt+0x509>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800b3b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b3e:	83 f8 30             	cmp    $0x30,%eax
  800b41:	73 17                	jae    800b5a <vprintfmt+0x1e8>
  800b43:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b47:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b4a:	89 c0                	mov    %eax,%eax
  800b4c:	48 01 d0             	add    %rdx,%rax
  800b4f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b52:	83 c2 08             	add    $0x8,%edx
  800b55:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b58:	eb 0f                	jmp    800b69 <vprintfmt+0x1f7>
  800b5a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b5e:	48 89 d0             	mov    %rdx,%rax
  800b61:	48 83 c2 08          	add    $0x8,%rdx
  800b65:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b69:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800b6b:	85 db                	test   %ebx,%ebx
  800b6d:	79 02                	jns    800b71 <vprintfmt+0x1ff>
				err = -err;
  800b6f:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800b71:	83 fb 10             	cmp    $0x10,%ebx
  800b74:	7f 16                	jg     800b8c <vprintfmt+0x21a>
  800b76:	48 b8 20 3b 80 00 00 	movabs $0x803b20,%rax
  800b7d:	00 00 00 
  800b80:	48 63 d3             	movslq %ebx,%rdx
  800b83:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800b87:	4d 85 e4             	test   %r12,%r12
  800b8a:	75 2e                	jne    800bba <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800b8c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b90:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b94:	89 d9                	mov    %ebx,%ecx
  800b96:	48 ba b9 3b 80 00 00 	movabs $0x803bb9,%rdx
  800b9d:	00 00 00 
  800ba0:	48 89 c7             	mov    %rax,%rdi
  800ba3:	b8 00 00 00 00       	mov    $0x0,%eax
  800ba8:	49 b8 8a 0e 80 00 00 	movabs $0x800e8a,%r8
  800baf:	00 00 00 
  800bb2:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800bb5:	e9 c1 02 00 00       	jmpq   800e7b <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800bba:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800bbe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bc2:	4c 89 e1             	mov    %r12,%rcx
  800bc5:	48 ba c2 3b 80 00 00 	movabs $0x803bc2,%rdx
  800bcc:	00 00 00 
  800bcf:	48 89 c7             	mov    %rax,%rdi
  800bd2:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd7:	49 b8 8a 0e 80 00 00 	movabs $0x800e8a,%r8
  800bde:	00 00 00 
  800be1:	41 ff d0             	callq  *%r8
			break;
  800be4:	e9 92 02 00 00       	jmpq   800e7b <vprintfmt+0x509>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800be9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bec:	83 f8 30             	cmp    $0x30,%eax
  800bef:	73 17                	jae    800c08 <vprintfmt+0x296>
  800bf1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bf5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bf8:	89 c0                	mov    %eax,%eax
  800bfa:	48 01 d0             	add    %rdx,%rax
  800bfd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c00:	83 c2 08             	add    $0x8,%edx
  800c03:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c06:	eb 0f                	jmp    800c17 <vprintfmt+0x2a5>
  800c08:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c0c:	48 89 d0             	mov    %rdx,%rax
  800c0f:	48 83 c2 08          	add    $0x8,%rdx
  800c13:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c17:	4c 8b 20             	mov    (%rax),%r12
  800c1a:	4d 85 e4             	test   %r12,%r12
  800c1d:	75 0a                	jne    800c29 <vprintfmt+0x2b7>
				p = "(null)";
  800c1f:	49 bc c5 3b 80 00 00 	movabs $0x803bc5,%r12
  800c26:	00 00 00 
			if (width > 0 && padc != '-')
  800c29:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c2d:	7e 3f                	jle    800c6e <vprintfmt+0x2fc>
  800c2f:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800c33:	74 39                	je     800c6e <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c35:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c38:	48 98                	cltq   
  800c3a:	48 89 c6             	mov    %rax,%rsi
  800c3d:	4c 89 e7             	mov    %r12,%rdi
  800c40:	48 b8 36 11 80 00 00 	movabs $0x801136,%rax
  800c47:	00 00 00 
  800c4a:	ff d0                	callq  *%rax
  800c4c:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800c4f:	eb 17                	jmp    800c68 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800c51:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800c55:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800c59:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c5d:	48 89 ce             	mov    %rcx,%rsi
  800c60:	89 d7                	mov    %edx,%edi
  800c62:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c64:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c68:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c6c:	7f e3                	jg     800c51 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c6e:	eb 37                	jmp    800ca7 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800c70:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800c74:	74 1e                	je     800c94 <vprintfmt+0x322>
  800c76:	83 fb 1f             	cmp    $0x1f,%ebx
  800c79:	7e 05                	jle    800c80 <vprintfmt+0x30e>
  800c7b:	83 fb 7e             	cmp    $0x7e,%ebx
  800c7e:	7e 14                	jle    800c94 <vprintfmt+0x322>
					putch('?', putdat);
  800c80:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c84:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c88:	48 89 d6             	mov    %rdx,%rsi
  800c8b:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800c90:	ff d0                	callq  *%rax
  800c92:	eb 0f                	jmp    800ca3 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800c94:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c98:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c9c:	48 89 d6             	mov    %rdx,%rsi
  800c9f:	89 df                	mov    %ebx,%edi
  800ca1:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ca3:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ca7:	4c 89 e0             	mov    %r12,%rax
  800caa:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800cae:	0f b6 00             	movzbl (%rax),%eax
  800cb1:	0f be d8             	movsbl %al,%ebx
  800cb4:	85 db                	test   %ebx,%ebx
  800cb6:	74 10                	je     800cc8 <vprintfmt+0x356>
  800cb8:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800cbc:	78 b2                	js     800c70 <vprintfmt+0x2fe>
  800cbe:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800cc2:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800cc6:	79 a8                	jns    800c70 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800cc8:	eb 16                	jmp    800ce0 <vprintfmt+0x36e>
				putch(' ', putdat);
  800cca:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cce:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cd2:	48 89 d6             	mov    %rdx,%rsi
  800cd5:	bf 20 00 00 00       	mov    $0x20,%edi
  800cda:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800cdc:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ce0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ce4:	7f e4                	jg     800cca <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800ce6:	e9 90 01 00 00       	jmpq   800e7b <vprintfmt+0x509>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800ceb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cef:	be 03 00 00 00       	mov    $0x3,%esi
  800cf4:	48 89 c7             	mov    %rax,%rdi
  800cf7:	48 b8 62 08 80 00 00 	movabs $0x800862,%rax
  800cfe:	00 00 00 
  800d01:	ff d0                	callq  *%rax
  800d03:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800d07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d0b:	48 85 c0             	test   %rax,%rax
  800d0e:	79 1d                	jns    800d2d <vprintfmt+0x3bb>
				putch('-', putdat);
  800d10:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d14:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d18:	48 89 d6             	mov    %rdx,%rsi
  800d1b:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800d20:	ff d0                	callq  *%rax
				num = -(long long) num;
  800d22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d26:	48 f7 d8             	neg    %rax
  800d29:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800d2d:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d34:	e9 d5 00 00 00       	jmpq   800e0e <vprintfmt+0x49c>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800d39:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d3d:	be 03 00 00 00       	mov    $0x3,%esi
  800d42:	48 89 c7             	mov    %rax,%rdi
  800d45:	48 b8 52 07 80 00 00 	movabs $0x800752,%rax
  800d4c:	00 00 00 
  800d4f:	ff d0                	callq  *%rax
  800d51:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800d55:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d5c:	e9 ad 00 00 00       	jmpq   800e0e <vprintfmt+0x49c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800d61:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800d64:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d68:	89 d6                	mov    %edx,%esi
  800d6a:	48 89 c7             	mov    %rax,%rdi
  800d6d:	48 b8 62 08 80 00 00 	movabs $0x800862,%rax
  800d74:	00 00 00 
  800d77:	ff d0                	callq  *%rax
  800d79:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800d7d:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800d84:	e9 85 00 00 00       	jmpq   800e0e <vprintfmt+0x49c>


		// pointer
		case 'p':
			putch('0', putdat);
  800d89:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d8d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d91:	48 89 d6             	mov    %rdx,%rsi
  800d94:	bf 30 00 00 00       	mov    $0x30,%edi
  800d99:	ff d0                	callq  *%rax
			putch('x', putdat);
  800d9b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d9f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800da3:	48 89 d6             	mov    %rdx,%rsi
  800da6:	bf 78 00 00 00       	mov    $0x78,%edi
  800dab:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800dad:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800db0:	83 f8 30             	cmp    $0x30,%eax
  800db3:	73 17                	jae    800dcc <vprintfmt+0x45a>
  800db5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800db9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800dbc:	89 c0                	mov    %eax,%eax
  800dbe:	48 01 d0             	add    %rdx,%rax
  800dc1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800dc4:	83 c2 08             	add    $0x8,%edx
  800dc7:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800dca:	eb 0f                	jmp    800ddb <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800dcc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800dd0:	48 89 d0             	mov    %rdx,%rax
  800dd3:	48 83 c2 08          	add    $0x8,%rdx
  800dd7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ddb:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800dde:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800de2:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800de9:	eb 23                	jmp    800e0e <vprintfmt+0x49c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800deb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800def:	be 03 00 00 00       	mov    $0x3,%esi
  800df4:	48 89 c7             	mov    %rax,%rdi
  800df7:	48 b8 52 07 80 00 00 	movabs $0x800752,%rax
  800dfe:	00 00 00 
  800e01:	ff d0                	callq  *%rax
  800e03:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800e07:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e0e:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800e13:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800e16:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800e19:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e1d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e21:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e25:	45 89 c1             	mov    %r8d,%r9d
  800e28:	41 89 f8             	mov    %edi,%r8d
  800e2b:	48 89 c7             	mov    %rax,%rdi
  800e2e:	48 b8 97 06 80 00 00 	movabs $0x800697,%rax
  800e35:	00 00 00 
  800e38:	ff d0                	callq  *%rax
			break;
  800e3a:	eb 3f                	jmp    800e7b <vprintfmt+0x509>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e3c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e40:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e44:	48 89 d6             	mov    %rdx,%rsi
  800e47:	89 df                	mov    %ebx,%edi
  800e49:	ff d0                	callq  *%rax
			break;
  800e4b:	eb 2e                	jmp    800e7b <vprintfmt+0x509>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e4d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e51:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e55:	48 89 d6             	mov    %rdx,%rsi
  800e58:	bf 25 00 00 00       	mov    $0x25,%edi
  800e5d:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e5f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e64:	eb 05                	jmp    800e6b <vprintfmt+0x4f9>
  800e66:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e6b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800e6f:	48 83 e8 01          	sub    $0x1,%rax
  800e73:	0f b6 00             	movzbl (%rax),%eax
  800e76:	3c 25                	cmp    $0x25,%al
  800e78:	75 ec                	jne    800e66 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800e7a:	90                   	nop
		}
	}
  800e7b:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e7c:	e9 43 fb ff ff       	jmpq   8009c4 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  800e81:	48 83 c4 60          	add    $0x60,%rsp
  800e85:	5b                   	pop    %rbx
  800e86:	41 5c                	pop    %r12
  800e88:	5d                   	pop    %rbp
  800e89:	c3                   	retq   

0000000000800e8a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e8a:	55                   	push   %rbp
  800e8b:	48 89 e5             	mov    %rsp,%rbp
  800e8e:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800e95:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800e9c:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800ea3:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800eaa:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800eb1:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800eb8:	84 c0                	test   %al,%al
  800eba:	74 20                	je     800edc <printfmt+0x52>
  800ebc:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800ec0:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800ec4:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800ec8:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800ecc:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800ed0:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800ed4:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ed8:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800edc:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800ee3:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800eea:	00 00 00 
  800eed:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800ef4:	00 00 00 
  800ef7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800efb:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800f02:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f09:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800f10:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800f17:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800f1e:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800f25:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800f2c:	48 89 c7             	mov    %rax,%rdi
  800f2f:	48 b8 72 09 80 00 00 	movabs $0x800972,%rax
  800f36:	00 00 00 
  800f39:	ff d0                	callq  *%rax
	va_end(ap);
}
  800f3b:	c9                   	leaveq 
  800f3c:	c3                   	retq   

0000000000800f3d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f3d:	55                   	push   %rbp
  800f3e:	48 89 e5             	mov    %rsp,%rbp
  800f41:	48 83 ec 10          	sub    $0x10,%rsp
  800f45:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800f48:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800f4c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f50:	8b 40 10             	mov    0x10(%rax),%eax
  800f53:	8d 50 01             	lea    0x1(%rax),%edx
  800f56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f5a:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800f5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f61:	48 8b 10             	mov    (%rax),%rdx
  800f64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f68:	48 8b 40 08          	mov    0x8(%rax),%rax
  800f6c:	48 39 c2             	cmp    %rax,%rdx
  800f6f:	73 17                	jae    800f88 <sprintputch+0x4b>
		*b->buf++ = ch;
  800f71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f75:	48 8b 00             	mov    (%rax),%rax
  800f78:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800f7c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800f80:	48 89 0a             	mov    %rcx,(%rdx)
  800f83:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800f86:	88 10                	mov    %dl,(%rax)
}
  800f88:	c9                   	leaveq 
  800f89:	c3                   	retq   

0000000000800f8a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f8a:	55                   	push   %rbp
  800f8b:	48 89 e5             	mov    %rsp,%rbp
  800f8e:	48 83 ec 50          	sub    $0x50,%rsp
  800f92:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800f96:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800f99:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800f9d:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800fa1:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800fa5:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800fa9:	48 8b 0a             	mov    (%rdx),%rcx
  800fac:	48 89 08             	mov    %rcx,(%rax)
  800faf:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fb3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fb7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fbb:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fbf:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800fc3:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800fc7:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800fca:	48 98                	cltq   
  800fcc:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800fd0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800fd4:	48 01 d0             	add    %rdx,%rax
  800fd7:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800fdb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800fe2:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800fe7:	74 06                	je     800fef <vsnprintf+0x65>
  800fe9:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800fed:	7f 07                	jg     800ff6 <vsnprintf+0x6c>
		return -E_INVAL;
  800fef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ff4:	eb 2f                	jmp    801025 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ff6:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800ffa:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800ffe:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801002:	48 89 c6             	mov    %rax,%rsi
  801005:	48 bf 3d 0f 80 00 00 	movabs $0x800f3d,%rdi
  80100c:	00 00 00 
  80100f:	48 b8 72 09 80 00 00 	movabs $0x800972,%rax
  801016:	00 00 00 
  801019:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80101b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80101f:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801022:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801025:	c9                   	leaveq 
  801026:	c3                   	retq   

0000000000801027 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801027:	55                   	push   %rbp
  801028:	48 89 e5             	mov    %rsp,%rbp
  80102b:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801032:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801039:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  80103f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801046:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80104d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801054:	84 c0                	test   %al,%al
  801056:	74 20                	je     801078 <snprintf+0x51>
  801058:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80105c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801060:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801064:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801068:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80106c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801070:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801074:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801078:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80107f:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801086:	00 00 00 
  801089:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801090:	00 00 00 
  801093:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801097:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80109e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8010a5:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8010ac:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8010b3:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8010ba:	48 8b 0a             	mov    (%rdx),%rcx
  8010bd:	48 89 08             	mov    %rcx,(%rax)
  8010c0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8010c4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8010c8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8010cc:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8010d0:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8010d7:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8010de:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8010e4:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8010eb:	48 89 c7             	mov    %rax,%rdi
  8010ee:	48 b8 8a 0f 80 00 00 	movabs $0x800f8a,%rax
  8010f5:	00 00 00 
  8010f8:	ff d0                	callq  *%rax
  8010fa:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801100:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801106:	c9                   	leaveq 
  801107:	c3                   	retq   

0000000000801108 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801108:	55                   	push   %rbp
  801109:	48 89 e5             	mov    %rsp,%rbp
  80110c:	48 83 ec 18          	sub    $0x18,%rsp
  801110:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801114:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80111b:	eb 09                	jmp    801126 <strlen+0x1e>
		n++;
  80111d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801121:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801126:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80112a:	0f b6 00             	movzbl (%rax),%eax
  80112d:	84 c0                	test   %al,%al
  80112f:	75 ec                	jne    80111d <strlen+0x15>
		n++;
	return n;
  801131:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801134:	c9                   	leaveq 
  801135:	c3                   	retq   

0000000000801136 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801136:	55                   	push   %rbp
  801137:	48 89 e5             	mov    %rsp,%rbp
  80113a:	48 83 ec 20          	sub    $0x20,%rsp
  80113e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801142:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801146:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80114d:	eb 0e                	jmp    80115d <strnlen+0x27>
		n++;
  80114f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801153:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801158:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80115d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801162:	74 0b                	je     80116f <strnlen+0x39>
  801164:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801168:	0f b6 00             	movzbl (%rax),%eax
  80116b:	84 c0                	test   %al,%al
  80116d:	75 e0                	jne    80114f <strnlen+0x19>
		n++;
	return n;
  80116f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801172:	c9                   	leaveq 
  801173:	c3                   	retq   

0000000000801174 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801174:	55                   	push   %rbp
  801175:	48 89 e5             	mov    %rsp,%rbp
  801178:	48 83 ec 20          	sub    $0x20,%rsp
  80117c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801180:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801184:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801188:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80118c:	90                   	nop
  80118d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801191:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801195:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801199:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80119d:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8011a1:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8011a5:	0f b6 12             	movzbl (%rdx),%edx
  8011a8:	88 10                	mov    %dl,(%rax)
  8011aa:	0f b6 00             	movzbl (%rax),%eax
  8011ad:	84 c0                	test   %al,%al
  8011af:	75 dc                	jne    80118d <strcpy+0x19>
		/* do nothing */;
	return ret;
  8011b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011b5:	c9                   	leaveq 
  8011b6:	c3                   	retq   

00000000008011b7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8011b7:	55                   	push   %rbp
  8011b8:	48 89 e5             	mov    %rsp,%rbp
  8011bb:	48 83 ec 20          	sub    $0x20,%rsp
  8011bf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011c3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8011c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011cb:	48 89 c7             	mov    %rax,%rdi
  8011ce:	48 b8 08 11 80 00 00 	movabs $0x801108,%rax
  8011d5:	00 00 00 
  8011d8:	ff d0                	callq  *%rax
  8011da:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8011dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011e0:	48 63 d0             	movslq %eax,%rdx
  8011e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011e7:	48 01 c2             	add    %rax,%rdx
  8011ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011ee:	48 89 c6             	mov    %rax,%rsi
  8011f1:	48 89 d7             	mov    %rdx,%rdi
  8011f4:	48 b8 74 11 80 00 00 	movabs $0x801174,%rax
  8011fb:	00 00 00 
  8011fe:	ff d0                	callq  *%rax
	return dst;
  801200:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801204:	c9                   	leaveq 
  801205:	c3                   	retq   

0000000000801206 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801206:	55                   	push   %rbp
  801207:	48 89 e5             	mov    %rsp,%rbp
  80120a:	48 83 ec 28          	sub    $0x28,%rsp
  80120e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801212:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801216:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80121a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80121e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801222:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801229:	00 
  80122a:	eb 2a                	jmp    801256 <strncpy+0x50>
		*dst++ = *src;
  80122c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801230:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801234:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801238:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80123c:	0f b6 12             	movzbl (%rdx),%edx
  80123f:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801241:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801245:	0f b6 00             	movzbl (%rax),%eax
  801248:	84 c0                	test   %al,%al
  80124a:	74 05                	je     801251 <strncpy+0x4b>
			src++;
  80124c:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801251:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801256:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80125a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80125e:	72 cc                	jb     80122c <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801260:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801264:	c9                   	leaveq 
  801265:	c3                   	retq   

0000000000801266 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801266:	55                   	push   %rbp
  801267:	48 89 e5             	mov    %rsp,%rbp
  80126a:	48 83 ec 28          	sub    $0x28,%rsp
  80126e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801272:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801276:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80127a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80127e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801282:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801287:	74 3d                	je     8012c6 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801289:	eb 1d                	jmp    8012a8 <strlcpy+0x42>
			*dst++ = *src++;
  80128b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80128f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801293:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801297:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80129b:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80129f:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8012a3:	0f b6 12             	movzbl (%rdx),%edx
  8012a6:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8012a8:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8012ad:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8012b2:	74 0b                	je     8012bf <strlcpy+0x59>
  8012b4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012b8:	0f b6 00             	movzbl (%rax),%eax
  8012bb:	84 c0                	test   %al,%al
  8012bd:	75 cc                	jne    80128b <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8012bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c3:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8012c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ce:	48 29 c2             	sub    %rax,%rdx
  8012d1:	48 89 d0             	mov    %rdx,%rax
}
  8012d4:	c9                   	leaveq 
  8012d5:	c3                   	retq   

00000000008012d6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8012d6:	55                   	push   %rbp
  8012d7:	48 89 e5             	mov    %rsp,%rbp
  8012da:	48 83 ec 10          	sub    $0x10,%rsp
  8012de:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012e2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8012e6:	eb 0a                	jmp    8012f2 <strcmp+0x1c>
		p++, q++;
  8012e8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012ed:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8012f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f6:	0f b6 00             	movzbl (%rax),%eax
  8012f9:	84 c0                	test   %al,%al
  8012fb:	74 12                	je     80130f <strcmp+0x39>
  8012fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801301:	0f b6 10             	movzbl (%rax),%edx
  801304:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801308:	0f b6 00             	movzbl (%rax),%eax
  80130b:	38 c2                	cmp    %al,%dl
  80130d:	74 d9                	je     8012e8 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80130f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801313:	0f b6 00             	movzbl (%rax),%eax
  801316:	0f b6 d0             	movzbl %al,%edx
  801319:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80131d:	0f b6 00             	movzbl (%rax),%eax
  801320:	0f b6 c0             	movzbl %al,%eax
  801323:	29 c2                	sub    %eax,%edx
  801325:	89 d0                	mov    %edx,%eax
}
  801327:	c9                   	leaveq 
  801328:	c3                   	retq   

0000000000801329 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801329:	55                   	push   %rbp
  80132a:	48 89 e5             	mov    %rsp,%rbp
  80132d:	48 83 ec 18          	sub    $0x18,%rsp
  801331:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801335:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801339:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80133d:	eb 0f                	jmp    80134e <strncmp+0x25>
		n--, p++, q++;
  80133f:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801344:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801349:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80134e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801353:	74 1d                	je     801372 <strncmp+0x49>
  801355:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801359:	0f b6 00             	movzbl (%rax),%eax
  80135c:	84 c0                	test   %al,%al
  80135e:	74 12                	je     801372 <strncmp+0x49>
  801360:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801364:	0f b6 10             	movzbl (%rax),%edx
  801367:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80136b:	0f b6 00             	movzbl (%rax),%eax
  80136e:	38 c2                	cmp    %al,%dl
  801370:	74 cd                	je     80133f <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801372:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801377:	75 07                	jne    801380 <strncmp+0x57>
		return 0;
  801379:	b8 00 00 00 00       	mov    $0x0,%eax
  80137e:	eb 18                	jmp    801398 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801380:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801384:	0f b6 00             	movzbl (%rax),%eax
  801387:	0f b6 d0             	movzbl %al,%edx
  80138a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80138e:	0f b6 00             	movzbl (%rax),%eax
  801391:	0f b6 c0             	movzbl %al,%eax
  801394:	29 c2                	sub    %eax,%edx
  801396:	89 d0                	mov    %edx,%eax
}
  801398:	c9                   	leaveq 
  801399:	c3                   	retq   

000000000080139a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80139a:	55                   	push   %rbp
  80139b:	48 89 e5             	mov    %rsp,%rbp
  80139e:	48 83 ec 0c          	sub    $0xc,%rsp
  8013a2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013a6:	89 f0                	mov    %esi,%eax
  8013a8:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8013ab:	eb 17                	jmp    8013c4 <strchr+0x2a>
		if (*s == c)
  8013ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b1:	0f b6 00             	movzbl (%rax),%eax
  8013b4:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8013b7:	75 06                	jne    8013bf <strchr+0x25>
			return (char *) s;
  8013b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013bd:	eb 15                	jmp    8013d4 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8013bf:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c8:	0f b6 00             	movzbl (%rax),%eax
  8013cb:	84 c0                	test   %al,%al
  8013cd:	75 de                	jne    8013ad <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8013cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013d4:	c9                   	leaveq 
  8013d5:	c3                   	retq   

00000000008013d6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8013d6:	55                   	push   %rbp
  8013d7:	48 89 e5             	mov    %rsp,%rbp
  8013da:	48 83 ec 0c          	sub    $0xc,%rsp
  8013de:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013e2:	89 f0                	mov    %esi,%eax
  8013e4:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8013e7:	eb 13                	jmp    8013fc <strfind+0x26>
		if (*s == c)
  8013e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ed:	0f b6 00             	movzbl (%rax),%eax
  8013f0:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8013f3:	75 02                	jne    8013f7 <strfind+0x21>
			break;
  8013f5:	eb 10                	jmp    801407 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8013f7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801400:	0f b6 00             	movzbl (%rax),%eax
  801403:	84 c0                	test   %al,%al
  801405:	75 e2                	jne    8013e9 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801407:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80140b:	c9                   	leaveq 
  80140c:	c3                   	retq   

000000000080140d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80140d:	55                   	push   %rbp
  80140e:	48 89 e5             	mov    %rsp,%rbp
  801411:	48 83 ec 18          	sub    $0x18,%rsp
  801415:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801419:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80141c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801420:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801425:	75 06                	jne    80142d <memset+0x20>
		return v;
  801427:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80142b:	eb 69                	jmp    801496 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80142d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801431:	83 e0 03             	and    $0x3,%eax
  801434:	48 85 c0             	test   %rax,%rax
  801437:	75 48                	jne    801481 <memset+0x74>
  801439:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80143d:	83 e0 03             	and    $0x3,%eax
  801440:	48 85 c0             	test   %rax,%rax
  801443:	75 3c                	jne    801481 <memset+0x74>
		c &= 0xFF;
  801445:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80144c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80144f:	c1 e0 18             	shl    $0x18,%eax
  801452:	89 c2                	mov    %eax,%edx
  801454:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801457:	c1 e0 10             	shl    $0x10,%eax
  80145a:	09 c2                	or     %eax,%edx
  80145c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80145f:	c1 e0 08             	shl    $0x8,%eax
  801462:	09 d0                	or     %edx,%eax
  801464:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801467:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80146b:	48 c1 e8 02          	shr    $0x2,%rax
  80146f:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801472:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801476:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801479:	48 89 d7             	mov    %rdx,%rdi
  80147c:	fc                   	cld    
  80147d:	f3 ab                	rep stos %eax,%es:(%rdi)
  80147f:	eb 11                	jmp    801492 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801481:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801485:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801488:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80148c:	48 89 d7             	mov    %rdx,%rdi
  80148f:	fc                   	cld    
  801490:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801492:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801496:	c9                   	leaveq 
  801497:	c3                   	retq   

0000000000801498 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801498:	55                   	push   %rbp
  801499:	48 89 e5             	mov    %rsp,%rbp
  80149c:	48 83 ec 28          	sub    $0x28,%rsp
  8014a0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014a4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014a8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8014ac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014b0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8014b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014b8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8014bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c0:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8014c4:	0f 83 88 00 00 00    	jae    801552 <memmove+0xba>
  8014ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ce:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014d2:	48 01 d0             	add    %rdx,%rax
  8014d5:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8014d9:	76 77                	jbe    801552 <memmove+0xba>
		s += n;
  8014db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014df:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8014e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e7:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8014eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ef:	83 e0 03             	and    $0x3,%eax
  8014f2:	48 85 c0             	test   %rax,%rax
  8014f5:	75 3b                	jne    801532 <memmove+0x9a>
  8014f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014fb:	83 e0 03             	and    $0x3,%eax
  8014fe:	48 85 c0             	test   %rax,%rax
  801501:	75 2f                	jne    801532 <memmove+0x9a>
  801503:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801507:	83 e0 03             	and    $0x3,%eax
  80150a:	48 85 c0             	test   %rax,%rax
  80150d:	75 23                	jne    801532 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80150f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801513:	48 83 e8 04          	sub    $0x4,%rax
  801517:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80151b:	48 83 ea 04          	sub    $0x4,%rdx
  80151f:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801523:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801527:	48 89 c7             	mov    %rax,%rdi
  80152a:	48 89 d6             	mov    %rdx,%rsi
  80152d:	fd                   	std    
  80152e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801530:	eb 1d                	jmp    80154f <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801532:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801536:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80153a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80153e:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801542:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801546:	48 89 d7             	mov    %rdx,%rdi
  801549:	48 89 c1             	mov    %rax,%rcx
  80154c:	fd                   	std    
  80154d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80154f:	fc                   	cld    
  801550:	eb 57                	jmp    8015a9 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801552:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801556:	83 e0 03             	and    $0x3,%eax
  801559:	48 85 c0             	test   %rax,%rax
  80155c:	75 36                	jne    801594 <memmove+0xfc>
  80155e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801562:	83 e0 03             	and    $0x3,%eax
  801565:	48 85 c0             	test   %rax,%rax
  801568:	75 2a                	jne    801594 <memmove+0xfc>
  80156a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80156e:	83 e0 03             	and    $0x3,%eax
  801571:	48 85 c0             	test   %rax,%rax
  801574:	75 1e                	jne    801594 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801576:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157a:	48 c1 e8 02          	shr    $0x2,%rax
  80157e:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801581:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801585:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801589:	48 89 c7             	mov    %rax,%rdi
  80158c:	48 89 d6             	mov    %rdx,%rsi
  80158f:	fc                   	cld    
  801590:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801592:	eb 15                	jmp    8015a9 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801594:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801598:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80159c:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015a0:	48 89 c7             	mov    %rax,%rdi
  8015a3:	48 89 d6             	mov    %rdx,%rsi
  8015a6:	fc                   	cld    
  8015a7:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8015a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015ad:	c9                   	leaveq 
  8015ae:	c3                   	retq   

00000000008015af <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8015af:	55                   	push   %rbp
  8015b0:	48 89 e5             	mov    %rsp,%rbp
  8015b3:	48 83 ec 18          	sub    $0x18,%rsp
  8015b7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015bb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8015bf:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8015c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015c7:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8015cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015cf:	48 89 ce             	mov    %rcx,%rsi
  8015d2:	48 89 c7             	mov    %rax,%rdi
  8015d5:	48 b8 98 14 80 00 00 	movabs $0x801498,%rax
  8015dc:	00 00 00 
  8015df:	ff d0                	callq  *%rax
}
  8015e1:	c9                   	leaveq 
  8015e2:	c3                   	retq   

00000000008015e3 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8015e3:	55                   	push   %rbp
  8015e4:	48 89 e5             	mov    %rsp,%rbp
  8015e7:	48 83 ec 28          	sub    $0x28,%rsp
  8015eb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015ef:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8015f3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8015f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015fb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8015ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801603:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801607:	eb 36                	jmp    80163f <memcmp+0x5c>
		if (*s1 != *s2)
  801609:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80160d:	0f b6 10             	movzbl (%rax),%edx
  801610:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801614:	0f b6 00             	movzbl (%rax),%eax
  801617:	38 c2                	cmp    %al,%dl
  801619:	74 1a                	je     801635 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80161b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80161f:	0f b6 00             	movzbl (%rax),%eax
  801622:	0f b6 d0             	movzbl %al,%edx
  801625:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801629:	0f b6 00             	movzbl (%rax),%eax
  80162c:	0f b6 c0             	movzbl %al,%eax
  80162f:	29 c2                	sub    %eax,%edx
  801631:	89 d0                	mov    %edx,%eax
  801633:	eb 20                	jmp    801655 <memcmp+0x72>
		s1++, s2++;
  801635:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80163a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80163f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801643:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801647:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80164b:	48 85 c0             	test   %rax,%rax
  80164e:	75 b9                	jne    801609 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801650:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801655:	c9                   	leaveq 
  801656:	c3                   	retq   

0000000000801657 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801657:	55                   	push   %rbp
  801658:	48 89 e5             	mov    %rsp,%rbp
  80165b:	48 83 ec 28          	sub    $0x28,%rsp
  80165f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801663:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801666:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80166a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801672:	48 01 d0             	add    %rdx,%rax
  801675:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801679:	eb 15                	jmp    801690 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80167b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80167f:	0f b6 10             	movzbl (%rax),%edx
  801682:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801685:	38 c2                	cmp    %al,%dl
  801687:	75 02                	jne    80168b <memfind+0x34>
			break;
  801689:	eb 0f                	jmp    80169a <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80168b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801690:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801694:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801698:	72 e1                	jb     80167b <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80169a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80169e:	c9                   	leaveq 
  80169f:	c3                   	retq   

00000000008016a0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8016a0:	55                   	push   %rbp
  8016a1:	48 89 e5             	mov    %rsp,%rbp
  8016a4:	48 83 ec 34          	sub    $0x34,%rsp
  8016a8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016ac:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8016b0:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8016b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8016ba:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8016c1:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016c2:	eb 05                	jmp    8016c9 <strtol+0x29>
		s++;
  8016c4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016cd:	0f b6 00             	movzbl (%rax),%eax
  8016d0:	3c 20                	cmp    $0x20,%al
  8016d2:	74 f0                	je     8016c4 <strtol+0x24>
  8016d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d8:	0f b6 00             	movzbl (%rax),%eax
  8016db:	3c 09                	cmp    $0x9,%al
  8016dd:	74 e5                	je     8016c4 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8016df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e3:	0f b6 00             	movzbl (%rax),%eax
  8016e6:	3c 2b                	cmp    $0x2b,%al
  8016e8:	75 07                	jne    8016f1 <strtol+0x51>
		s++;
  8016ea:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016ef:	eb 17                	jmp    801708 <strtol+0x68>
	else if (*s == '-')
  8016f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f5:	0f b6 00             	movzbl (%rax),%eax
  8016f8:	3c 2d                	cmp    $0x2d,%al
  8016fa:	75 0c                	jne    801708 <strtol+0x68>
		s++, neg = 1;
  8016fc:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801701:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801708:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80170c:	74 06                	je     801714 <strtol+0x74>
  80170e:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801712:	75 28                	jne    80173c <strtol+0x9c>
  801714:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801718:	0f b6 00             	movzbl (%rax),%eax
  80171b:	3c 30                	cmp    $0x30,%al
  80171d:	75 1d                	jne    80173c <strtol+0x9c>
  80171f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801723:	48 83 c0 01          	add    $0x1,%rax
  801727:	0f b6 00             	movzbl (%rax),%eax
  80172a:	3c 78                	cmp    $0x78,%al
  80172c:	75 0e                	jne    80173c <strtol+0x9c>
		s += 2, base = 16;
  80172e:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801733:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80173a:	eb 2c                	jmp    801768 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80173c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801740:	75 19                	jne    80175b <strtol+0xbb>
  801742:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801746:	0f b6 00             	movzbl (%rax),%eax
  801749:	3c 30                	cmp    $0x30,%al
  80174b:	75 0e                	jne    80175b <strtol+0xbb>
		s++, base = 8;
  80174d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801752:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801759:	eb 0d                	jmp    801768 <strtol+0xc8>
	else if (base == 0)
  80175b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80175f:	75 07                	jne    801768 <strtol+0xc8>
		base = 10;
  801761:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801768:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80176c:	0f b6 00             	movzbl (%rax),%eax
  80176f:	3c 2f                	cmp    $0x2f,%al
  801771:	7e 1d                	jle    801790 <strtol+0xf0>
  801773:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801777:	0f b6 00             	movzbl (%rax),%eax
  80177a:	3c 39                	cmp    $0x39,%al
  80177c:	7f 12                	jg     801790 <strtol+0xf0>
			dig = *s - '0';
  80177e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801782:	0f b6 00             	movzbl (%rax),%eax
  801785:	0f be c0             	movsbl %al,%eax
  801788:	83 e8 30             	sub    $0x30,%eax
  80178b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80178e:	eb 4e                	jmp    8017de <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801790:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801794:	0f b6 00             	movzbl (%rax),%eax
  801797:	3c 60                	cmp    $0x60,%al
  801799:	7e 1d                	jle    8017b8 <strtol+0x118>
  80179b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80179f:	0f b6 00             	movzbl (%rax),%eax
  8017a2:	3c 7a                	cmp    $0x7a,%al
  8017a4:	7f 12                	jg     8017b8 <strtol+0x118>
			dig = *s - 'a' + 10;
  8017a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017aa:	0f b6 00             	movzbl (%rax),%eax
  8017ad:	0f be c0             	movsbl %al,%eax
  8017b0:	83 e8 57             	sub    $0x57,%eax
  8017b3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8017b6:	eb 26                	jmp    8017de <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8017b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017bc:	0f b6 00             	movzbl (%rax),%eax
  8017bf:	3c 40                	cmp    $0x40,%al
  8017c1:	7e 48                	jle    80180b <strtol+0x16b>
  8017c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c7:	0f b6 00             	movzbl (%rax),%eax
  8017ca:	3c 5a                	cmp    $0x5a,%al
  8017cc:	7f 3d                	jg     80180b <strtol+0x16b>
			dig = *s - 'A' + 10;
  8017ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d2:	0f b6 00             	movzbl (%rax),%eax
  8017d5:	0f be c0             	movsbl %al,%eax
  8017d8:	83 e8 37             	sub    $0x37,%eax
  8017db:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8017de:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017e1:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8017e4:	7c 02                	jl     8017e8 <strtol+0x148>
			break;
  8017e6:	eb 23                	jmp    80180b <strtol+0x16b>
		s++, val = (val * base) + dig;
  8017e8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017ed:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8017f0:	48 98                	cltq   
  8017f2:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8017f7:	48 89 c2             	mov    %rax,%rdx
  8017fa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017fd:	48 98                	cltq   
  8017ff:	48 01 d0             	add    %rdx,%rax
  801802:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801806:	e9 5d ff ff ff       	jmpq   801768 <strtol+0xc8>

	if (endptr)
  80180b:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801810:	74 0b                	je     80181d <strtol+0x17d>
		*endptr = (char *) s;
  801812:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801816:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80181a:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80181d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801821:	74 09                	je     80182c <strtol+0x18c>
  801823:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801827:	48 f7 d8             	neg    %rax
  80182a:	eb 04                	jmp    801830 <strtol+0x190>
  80182c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801830:	c9                   	leaveq 
  801831:	c3                   	retq   

0000000000801832 <strstr>:

char * strstr(const char *in, const char *str)
{
  801832:	55                   	push   %rbp
  801833:	48 89 e5             	mov    %rsp,%rbp
  801836:	48 83 ec 30          	sub    $0x30,%rsp
  80183a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80183e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801842:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801846:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80184a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80184e:	0f b6 00             	movzbl (%rax),%eax
  801851:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  801854:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801858:	75 06                	jne    801860 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  80185a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80185e:	eb 6b                	jmp    8018cb <strstr+0x99>

    len = strlen(str);
  801860:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801864:	48 89 c7             	mov    %rax,%rdi
  801867:	48 b8 08 11 80 00 00 	movabs $0x801108,%rax
  80186e:	00 00 00 
  801871:	ff d0                	callq  *%rax
  801873:	48 98                	cltq   
  801875:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801879:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80187d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801881:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801885:	0f b6 00             	movzbl (%rax),%eax
  801888:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  80188b:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80188f:	75 07                	jne    801898 <strstr+0x66>
                return (char *) 0;
  801891:	b8 00 00 00 00       	mov    $0x0,%eax
  801896:	eb 33                	jmp    8018cb <strstr+0x99>
        } while (sc != c);
  801898:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80189c:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80189f:	75 d8                	jne    801879 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  8018a1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018a5:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8018a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018ad:	48 89 ce             	mov    %rcx,%rsi
  8018b0:	48 89 c7             	mov    %rax,%rdi
  8018b3:	48 b8 29 13 80 00 00 	movabs $0x801329,%rax
  8018ba:	00 00 00 
  8018bd:	ff d0                	callq  *%rax
  8018bf:	85 c0                	test   %eax,%eax
  8018c1:	75 b6                	jne    801879 <strstr+0x47>

    return (char *) (in - 1);
  8018c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018c7:	48 83 e8 01          	sub    $0x1,%rax
}
  8018cb:	c9                   	leaveq 
  8018cc:	c3                   	retq   

00000000008018cd <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8018cd:	55                   	push   %rbp
  8018ce:	48 89 e5             	mov    %rsp,%rbp
  8018d1:	53                   	push   %rbx
  8018d2:	48 83 ec 48          	sub    $0x48,%rsp
  8018d6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8018d9:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8018dc:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018e0:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8018e4:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8018e8:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018ec:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018ef:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8018f3:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8018f7:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8018fb:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8018ff:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801903:	4c 89 c3             	mov    %r8,%rbx
  801906:	cd 30                	int    $0x30
  801908:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80190c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801910:	74 3e                	je     801950 <syscall+0x83>
  801912:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801917:	7e 37                	jle    801950 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801919:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80191d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801920:	49 89 d0             	mov    %rdx,%r8
  801923:	89 c1                	mov    %eax,%ecx
  801925:	48 ba 80 3e 80 00 00 	movabs $0x803e80,%rdx
  80192c:	00 00 00 
  80192f:	be 23 00 00 00       	mov    $0x23,%esi
  801934:	48 bf 9d 3e 80 00 00 	movabs $0x803e9d,%rdi
  80193b:	00 00 00 
  80193e:	b8 00 00 00 00       	mov    $0x0,%eax
  801943:	49 b9 86 03 80 00 00 	movabs $0x800386,%r9
  80194a:	00 00 00 
  80194d:	41 ff d1             	callq  *%r9

	return ret;
  801950:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801954:	48 83 c4 48          	add    $0x48,%rsp
  801958:	5b                   	pop    %rbx
  801959:	5d                   	pop    %rbp
  80195a:	c3                   	retq   

000000000080195b <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80195b:	55                   	push   %rbp
  80195c:	48 89 e5             	mov    %rsp,%rbp
  80195f:	48 83 ec 20          	sub    $0x20,%rsp
  801963:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801967:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80196b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80196f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801973:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80197a:	00 
  80197b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801981:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801987:	48 89 d1             	mov    %rdx,%rcx
  80198a:	48 89 c2             	mov    %rax,%rdx
  80198d:	be 00 00 00 00       	mov    $0x0,%esi
  801992:	bf 00 00 00 00       	mov    $0x0,%edi
  801997:	48 b8 cd 18 80 00 00 	movabs $0x8018cd,%rax
  80199e:	00 00 00 
  8019a1:	ff d0                	callq  *%rax
}
  8019a3:	c9                   	leaveq 
  8019a4:	c3                   	retq   

00000000008019a5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8019a5:	55                   	push   %rbp
  8019a6:	48 89 e5             	mov    %rsp,%rbp
  8019a9:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8019ad:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019b4:	00 
  8019b5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019bb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019c1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8019cb:	be 00 00 00 00       	mov    $0x0,%esi
  8019d0:	bf 01 00 00 00       	mov    $0x1,%edi
  8019d5:	48 b8 cd 18 80 00 00 	movabs $0x8018cd,%rax
  8019dc:	00 00 00 
  8019df:	ff d0                	callq  *%rax
}
  8019e1:	c9                   	leaveq 
  8019e2:	c3                   	retq   

00000000008019e3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8019e3:	55                   	push   %rbp
  8019e4:	48 89 e5             	mov    %rsp,%rbp
  8019e7:	48 83 ec 10          	sub    $0x10,%rsp
  8019eb:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8019ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019f1:	48 98                	cltq   
  8019f3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019fa:	00 
  8019fb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a01:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a07:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a0c:	48 89 c2             	mov    %rax,%rdx
  801a0f:	be 01 00 00 00       	mov    $0x1,%esi
  801a14:	bf 03 00 00 00       	mov    $0x3,%edi
  801a19:	48 b8 cd 18 80 00 00 	movabs $0x8018cd,%rax
  801a20:	00 00 00 
  801a23:	ff d0                	callq  *%rax
}
  801a25:	c9                   	leaveq 
  801a26:	c3                   	retq   

0000000000801a27 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801a27:	55                   	push   %rbp
  801a28:	48 89 e5             	mov    %rsp,%rbp
  801a2b:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801a2f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a36:	00 
  801a37:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a3d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a43:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a48:	ba 00 00 00 00       	mov    $0x0,%edx
  801a4d:	be 00 00 00 00       	mov    $0x0,%esi
  801a52:	bf 02 00 00 00       	mov    $0x2,%edi
  801a57:	48 b8 cd 18 80 00 00 	movabs $0x8018cd,%rax
  801a5e:	00 00 00 
  801a61:	ff d0                	callq  *%rax
}
  801a63:	c9                   	leaveq 
  801a64:	c3                   	retq   

0000000000801a65 <sys_yield>:

void
sys_yield(void)
{
  801a65:	55                   	push   %rbp
  801a66:	48 89 e5             	mov    %rsp,%rbp
  801a69:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801a6d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a74:	00 
  801a75:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a7b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a81:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a86:	ba 00 00 00 00       	mov    $0x0,%edx
  801a8b:	be 00 00 00 00       	mov    $0x0,%esi
  801a90:	bf 0b 00 00 00       	mov    $0xb,%edi
  801a95:	48 b8 cd 18 80 00 00 	movabs $0x8018cd,%rax
  801a9c:	00 00 00 
  801a9f:	ff d0                	callq  *%rax
}
  801aa1:	c9                   	leaveq 
  801aa2:	c3                   	retq   

0000000000801aa3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801aa3:	55                   	push   %rbp
  801aa4:	48 89 e5             	mov    %rsp,%rbp
  801aa7:	48 83 ec 20          	sub    $0x20,%rsp
  801aab:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801aae:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ab2:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801ab5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ab8:	48 63 c8             	movslq %eax,%rcx
  801abb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801abf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ac2:	48 98                	cltq   
  801ac4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801acb:	00 
  801acc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ad2:	49 89 c8             	mov    %rcx,%r8
  801ad5:	48 89 d1             	mov    %rdx,%rcx
  801ad8:	48 89 c2             	mov    %rax,%rdx
  801adb:	be 01 00 00 00       	mov    $0x1,%esi
  801ae0:	bf 04 00 00 00       	mov    $0x4,%edi
  801ae5:	48 b8 cd 18 80 00 00 	movabs $0x8018cd,%rax
  801aec:	00 00 00 
  801aef:	ff d0                	callq  *%rax
}
  801af1:	c9                   	leaveq 
  801af2:	c3                   	retq   

0000000000801af3 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801af3:	55                   	push   %rbp
  801af4:	48 89 e5             	mov    %rsp,%rbp
  801af7:	48 83 ec 30          	sub    $0x30,%rsp
  801afb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801afe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b02:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b05:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b09:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801b0d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b10:	48 63 c8             	movslq %eax,%rcx
  801b13:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801b17:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b1a:	48 63 f0             	movslq %eax,%rsi
  801b1d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b24:	48 98                	cltq   
  801b26:	48 89 0c 24          	mov    %rcx,(%rsp)
  801b2a:	49 89 f9             	mov    %rdi,%r9
  801b2d:	49 89 f0             	mov    %rsi,%r8
  801b30:	48 89 d1             	mov    %rdx,%rcx
  801b33:	48 89 c2             	mov    %rax,%rdx
  801b36:	be 01 00 00 00       	mov    $0x1,%esi
  801b3b:	bf 05 00 00 00       	mov    $0x5,%edi
  801b40:	48 b8 cd 18 80 00 00 	movabs $0x8018cd,%rax
  801b47:	00 00 00 
  801b4a:	ff d0                	callq  *%rax
}
  801b4c:	c9                   	leaveq 
  801b4d:	c3                   	retq   

0000000000801b4e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801b4e:	55                   	push   %rbp
  801b4f:	48 89 e5             	mov    %rsp,%rbp
  801b52:	48 83 ec 20          	sub    $0x20,%rsp
  801b56:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b59:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801b5d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b61:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b64:	48 98                	cltq   
  801b66:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b6d:	00 
  801b6e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b74:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b7a:	48 89 d1             	mov    %rdx,%rcx
  801b7d:	48 89 c2             	mov    %rax,%rdx
  801b80:	be 01 00 00 00       	mov    $0x1,%esi
  801b85:	bf 06 00 00 00       	mov    $0x6,%edi
  801b8a:	48 b8 cd 18 80 00 00 	movabs $0x8018cd,%rax
  801b91:	00 00 00 
  801b94:	ff d0                	callq  *%rax
}
  801b96:	c9                   	leaveq 
  801b97:	c3                   	retq   

0000000000801b98 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801b98:	55                   	push   %rbp
  801b99:	48 89 e5             	mov    %rsp,%rbp
  801b9c:	48 83 ec 10          	sub    $0x10,%rsp
  801ba0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ba3:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801ba6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ba9:	48 63 d0             	movslq %eax,%rdx
  801bac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801baf:	48 98                	cltq   
  801bb1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bb8:	00 
  801bb9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bbf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bc5:	48 89 d1             	mov    %rdx,%rcx
  801bc8:	48 89 c2             	mov    %rax,%rdx
  801bcb:	be 01 00 00 00       	mov    $0x1,%esi
  801bd0:	bf 08 00 00 00       	mov    $0x8,%edi
  801bd5:	48 b8 cd 18 80 00 00 	movabs $0x8018cd,%rax
  801bdc:	00 00 00 
  801bdf:	ff d0                	callq  *%rax
}
  801be1:	c9                   	leaveq 
  801be2:	c3                   	retq   

0000000000801be3 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801be3:	55                   	push   %rbp
  801be4:	48 89 e5             	mov    %rsp,%rbp
  801be7:	48 83 ec 20          	sub    $0x20,%rsp
  801beb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bee:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801bf2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bf6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bf9:	48 98                	cltq   
  801bfb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c02:	00 
  801c03:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c09:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c0f:	48 89 d1             	mov    %rdx,%rcx
  801c12:	48 89 c2             	mov    %rax,%rdx
  801c15:	be 01 00 00 00       	mov    $0x1,%esi
  801c1a:	bf 09 00 00 00       	mov    $0x9,%edi
  801c1f:	48 b8 cd 18 80 00 00 	movabs $0x8018cd,%rax
  801c26:	00 00 00 
  801c29:	ff d0                	callq  *%rax
}
  801c2b:	c9                   	leaveq 
  801c2c:	c3                   	retq   

0000000000801c2d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801c2d:	55                   	push   %rbp
  801c2e:	48 89 e5             	mov    %rsp,%rbp
  801c31:	48 83 ec 20          	sub    $0x20,%rsp
  801c35:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c38:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801c3c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c40:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c43:	48 98                	cltq   
  801c45:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c4c:	00 
  801c4d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c53:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c59:	48 89 d1             	mov    %rdx,%rcx
  801c5c:	48 89 c2             	mov    %rax,%rdx
  801c5f:	be 01 00 00 00       	mov    $0x1,%esi
  801c64:	bf 0a 00 00 00       	mov    $0xa,%edi
  801c69:	48 b8 cd 18 80 00 00 	movabs $0x8018cd,%rax
  801c70:	00 00 00 
  801c73:	ff d0                	callq  *%rax
}
  801c75:	c9                   	leaveq 
  801c76:	c3                   	retq   

0000000000801c77 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801c77:	55                   	push   %rbp
  801c78:	48 89 e5             	mov    %rsp,%rbp
  801c7b:	48 83 ec 20          	sub    $0x20,%rsp
  801c7f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c82:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c86:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801c8a:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801c8d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c90:	48 63 f0             	movslq %eax,%rsi
  801c93:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801c97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c9a:	48 98                	cltq   
  801c9c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ca0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ca7:	00 
  801ca8:	49 89 f1             	mov    %rsi,%r9
  801cab:	49 89 c8             	mov    %rcx,%r8
  801cae:	48 89 d1             	mov    %rdx,%rcx
  801cb1:	48 89 c2             	mov    %rax,%rdx
  801cb4:	be 00 00 00 00       	mov    $0x0,%esi
  801cb9:	bf 0c 00 00 00       	mov    $0xc,%edi
  801cbe:	48 b8 cd 18 80 00 00 	movabs $0x8018cd,%rax
  801cc5:	00 00 00 
  801cc8:	ff d0                	callq  *%rax
}
  801cca:	c9                   	leaveq 
  801ccb:	c3                   	retq   

0000000000801ccc <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801ccc:	55                   	push   %rbp
  801ccd:	48 89 e5             	mov    %rsp,%rbp
  801cd0:	48 83 ec 10          	sub    $0x10,%rsp
  801cd4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801cd8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cdc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ce3:	00 
  801ce4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cea:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cf0:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cf5:	48 89 c2             	mov    %rax,%rdx
  801cf8:	be 01 00 00 00       	mov    $0x1,%esi
  801cfd:	bf 0d 00 00 00       	mov    $0xd,%edi
  801d02:	48 b8 cd 18 80 00 00 	movabs $0x8018cd,%rax
  801d09:	00 00 00 
  801d0c:	ff d0                	callq  *%rax
}
  801d0e:	c9                   	leaveq 
  801d0f:	c3                   	retq   

0000000000801d10 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801d10:	55                   	push   %rbp
  801d11:	48 89 e5             	mov    %rsp,%rbp
  801d14:	48 83 ec 08          	sub    $0x8,%rsp
  801d18:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801d1c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d20:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801d27:	ff ff ff 
  801d2a:	48 01 d0             	add    %rdx,%rax
  801d2d:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801d31:	c9                   	leaveq 
  801d32:	c3                   	retq   

0000000000801d33 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801d33:	55                   	push   %rbp
  801d34:	48 89 e5             	mov    %rsp,%rbp
  801d37:	48 83 ec 08          	sub    $0x8,%rsp
  801d3b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801d3f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d43:	48 89 c7             	mov    %rax,%rdi
  801d46:	48 b8 10 1d 80 00 00 	movabs $0x801d10,%rax
  801d4d:	00 00 00 
  801d50:	ff d0                	callq  *%rax
  801d52:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801d58:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801d5c:	c9                   	leaveq 
  801d5d:	c3                   	retq   

0000000000801d5e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801d5e:	55                   	push   %rbp
  801d5f:	48 89 e5             	mov    %rsp,%rbp
  801d62:	48 83 ec 18          	sub    $0x18,%rsp
  801d66:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801d6a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d71:	eb 6b                	jmp    801dde <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801d73:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d76:	48 98                	cltq   
  801d78:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d7e:	48 c1 e0 0c          	shl    $0xc,%rax
  801d82:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801d86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d8a:	48 c1 e8 15          	shr    $0x15,%rax
  801d8e:	48 89 c2             	mov    %rax,%rdx
  801d91:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801d98:	01 00 00 
  801d9b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d9f:	83 e0 01             	and    $0x1,%eax
  801da2:	48 85 c0             	test   %rax,%rax
  801da5:	74 21                	je     801dc8 <fd_alloc+0x6a>
  801da7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dab:	48 c1 e8 0c          	shr    $0xc,%rax
  801daf:	48 89 c2             	mov    %rax,%rdx
  801db2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801db9:	01 00 00 
  801dbc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dc0:	83 e0 01             	and    $0x1,%eax
  801dc3:	48 85 c0             	test   %rax,%rax
  801dc6:	75 12                	jne    801dda <fd_alloc+0x7c>
			*fd_store = fd;
  801dc8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dcc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dd0:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801dd3:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd8:	eb 1a                	jmp    801df4 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801dda:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801dde:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801de2:	7e 8f                	jle    801d73 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801de4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801de8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801def:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801df4:	c9                   	leaveq 
  801df5:	c3                   	retq   

0000000000801df6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801df6:	55                   	push   %rbp
  801df7:	48 89 e5             	mov    %rsp,%rbp
  801dfa:	48 83 ec 20          	sub    $0x20,%rsp
  801dfe:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e01:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801e05:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801e09:	78 06                	js     801e11 <fd_lookup+0x1b>
  801e0b:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801e0f:	7e 07                	jle    801e18 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e11:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e16:	eb 6c                	jmp    801e84 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801e18:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e1b:	48 98                	cltq   
  801e1d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e23:	48 c1 e0 0c          	shl    $0xc,%rax
  801e27:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801e2b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e2f:	48 c1 e8 15          	shr    $0x15,%rax
  801e33:	48 89 c2             	mov    %rax,%rdx
  801e36:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e3d:	01 00 00 
  801e40:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e44:	83 e0 01             	and    $0x1,%eax
  801e47:	48 85 c0             	test   %rax,%rax
  801e4a:	74 21                	je     801e6d <fd_lookup+0x77>
  801e4c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e50:	48 c1 e8 0c          	shr    $0xc,%rax
  801e54:	48 89 c2             	mov    %rax,%rdx
  801e57:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e5e:	01 00 00 
  801e61:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e65:	83 e0 01             	and    $0x1,%eax
  801e68:	48 85 c0             	test   %rax,%rax
  801e6b:	75 07                	jne    801e74 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e6d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e72:	eb 10                	jmp    801e84 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801e74:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e78:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e7c:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801e7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e84:	c9                   	leaveq 
  801e85:	c3                   	retq   

0000000000801e86 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801e86:	55                   	push   %rbp
  801e87:	48 89 e5             	mov    %rsp,%rbp
  801e8a:	48 83 ec 30          	sub    $0x30,%rsp
  801e8e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e92:	89 f0                	mov    %esi,%eax
  801e94:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801e97:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e9b:	48 89 c7             	mov    %rax,%rdi
  801e9e:	48 b8 10 1d 80 00 00 	movabs $0x801d10,%rax
  801ea5:	00 00 00 
  801ea8:	ff d0                	callq  *%rax
  801eaa:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801eae:	48 89 d6             	mov    %rdx,%rsi
  801eb1:	89 c7                	mov    %eax,%edi
  801eb3:	48 b8 f6 1d 80 00 00 	movabs $0x801df6,%rax
  801eba:	00 00 00 
  801ebd:	ff d0                	callq  *%rax
  801ebf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ec2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ec6:	78 0a                	js     801ed2 <fd_close+0x4c>
	    || fd != fd2)
  801ec8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ecc:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801ed0:	74 12                	je     801ee4 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801ed2:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801ed6:	74 05                	je     801edd <fd_close+0x57>
  801ed8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801edb:	eb 05                	jmp    801ee2 <fd_close+0x5c>
  801edd:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee2:	eb 69                	jmp    801f4d <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801ee4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ee8:	8b 00                	mov    (%rax),%eax
  801eea:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801eee:	48 89 d6             	mov    %rdx,%rsi
  801ef1:	89 c7                	mov    %eax,%edi
  801ef3:	48 b8 4f 1f 80 00 00 	movabs $0x801f4f,%rax
  801efa:	00 00 00 
  801efd:	ff d0                	callq  *%rax
  801eff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f02:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f06:	78 2a                	js     801f32 <fd_close+0xac>
		if (dev->dev_close)
  801f08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f0c:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f10:	48 85 c0             	test   %rax,%rax
  801f13:	74 16                	je     801f2b <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801f15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f19:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f1d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801f21:	48 89 d7             	mov    %rdx,%rdi
  801f24:	ff d0                	callq  *%rax
  801f26:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f29:	eb 07                	jmp    801f32 <fd_close+0xac>
		else
			r = 0;
  801f2b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801f32:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f36:	48 89 c6             	mov    %rax,%rsi
  801f39:	bf 00 00 00 00       	mov    $0x0,%edi
  801f3e:	48 b8 4e 1b 80 00 00 	movabs $0x801b4e,%rax
  801f45:	00 00 00 
  801f48:	ff d0                	callq  *%rax
	return r;
  801f4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801f4d:	c9                   	leaveq 
  801f4e:	c3                   	retq   

0000000000801f4f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801f4f:	55                   	push   %rbp
  801f50:	48 89 e5             	mov    %rsp,%rbp
  801f53:	48 83 ec 20          	sub    $0x20,%rsp
  801f57:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f5a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801f5e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f65:	eb 41                	jmp    801fa8 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801f67:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801f6e:	00 00 00 
  801f71:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f74:	48 63 d2             	movslq %edx,%rdx
  801f77:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f7b:	8b 00                	mov    (%rax),%eax
  801f7d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801f80:	75 22                	jne    801fa4 <dev_lookup+0x55>
			*dev = devtab[i];
  801f82:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801f89:	00 00 00 
  801f8c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f8f:	48 63 d2             	movslq %edx,%rdx
  801f92:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801f96:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f9a:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f9d:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa2:	eb 60                	jmp    802004 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801fa4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801fa8:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801faf:	00 00 00 
  801fb2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801fb5:	48 63 d2             	movslq %edx,%rdx
  801fb8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fbc:	48 85 c0             	test   %rax,%rax
  801fbf:	75 a6                	jne    801f67 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801fc1:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801fc8:	00 00 00 
  801fcb:	48 8b 00             	mov    (%rax),%rax
  801fce:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801fd4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801fd7:	89 c6                	mov    %eax,%esi
  801fd9:	48 bf b0 3e 80 00 00 	movabs $0x803eb0,%rdi
  801fe0:	00 00 00 
  801fe3:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe8:	48 b9 bf 05 80 00 00 	movabs $0x8005bf,%rcx
  801fef:	00 00 00 
  801ff2:	ff d1                	callq  *%rcx
	*dev = 0;
  801ff4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ff8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801fff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802004:	c9                   	leaveq 
  802005:	c3                   	retq   

0000000000802006 <close>:

int
close(int fdnum)
{
  802006:	55                   	push   %rbp
  802007:	48 89 e5             	mov    %rsp,%rbp
  80200a:	48 83 ec 20          	sub    $0x20,%rsp
  80200e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802011:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802015:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802018:	48 89 d6             	mov    %rdx,%rsi
  80201b:	89 c7                	mov    %eax,%edi
  80201d:	48 b8 f6 1d 80 00 00 	movabs $0x801df6,%rax
  802024:	00 00 00 
  802027:	ff d0                	callq  *%rax
  802029:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80202c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802030:	79 05                	jns    802037 <close+0x31>
		return r;
  802032:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802035:	eb 18                	jmp    80204f <close+0x49>
	else
		return fd_close(fd, 1);
  802037:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80203b:	be 01 00 00 00       	mov    $0x1,%esi
  802040:	48 89 c7             	mov    %rax,%rdi
  802043:	48 b8 86 1e 80 00 00 	movabs $0x801e86,%rax
  80204a:	00 00 00 
  80204d:	ff d0                	callq  *%rax
}
  80204f:	c9                   	leaveq 
  802050:	c3                   	retq   

0000000000802051 <close_all>:

void
close_all(void)
{
  802051:	55                   	push   %rbp
  802052:	48 89 e5             	mov    %rsp,%rbp
  802055:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802059:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802060:	eb 15                	jmp    802077 <close_all+0x26>
		close(i);
  802062:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802065:	89 c7                	mov    %eax,%edi
  802067:	48 b8 06 20 80 00 00 	movabs $0x802006,%rax
  80206e:	00 00 00 
  802071:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802073:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802077:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80207b:	7e e5                	jle    802062 <close_all+0x11>
		close(i);
}
  80207d:	c9                   	leaveq 
  80207e:	c3                   	retq   

000000000080207f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80207f:	55                   	push   %rbp
  802080:	48 89 e5             	mov    %rsp,%rbp
  802083:	48 83 ec 40          	sub    $0x40,%rsp
  802087:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80208a:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80208d:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802091:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802094:	48 89 d6             	mov    %rdx,%rsi
  802097:	89 c7                	mov    %eax,%edi
  802099:	48 b8 f6 1d 80 00 00 	movabs $0x801df6,%rax
  8020a0:	00 00 00 
  8020a3:	ff d0                	callq  *%rax
  8020a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020ac:	79 08                	jns    8020b6 <dup+0x37>
		return r;
  8020ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020b1:	e9 70 01 00 00       	jmpq   802226 <dup+0x1a7>
	close(newfdnum);
  8020b6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020b9:	89 c7                	mov    %eax,%edi
  8020bb:	48 b8 06 20 80 00 00 	movabs $0x802006,%rax
  8020c2:	00 00 00 
  8020c5:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8020c7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020ca:	48 98                	cltq   
  8020cc:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8020d2:	48 c1 e0 0c          	shl    $0xc,%rax
  8020d6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8020da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020de:	48 89 c7             	mov    %rax,%rdi
  8020e1:	48 b8 33 1d 80 00 00 	movabs $0x801d33,%rax
  8020e8:	00 00 00 
  8020eb:	ff d0                	callq  *%rax
  8020ed:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8020f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020f5:	48 89 c7             	mov    %rax,%rdi
  8020f8:	48 b8 33 1d 80 00 00 	movabs $0x801d33,%rax
  8020ff:	00 00 00 
  802102:	ff d0                	callq  *%rax
  802104:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802108:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80210c:	48 c1 e8 15          	shr    $0x15,%rax
  802110:	48 89 c2             	mov    %rax,%rdx
  802113:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80211a:	01 00 00 
  80211d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802121:	83 e0 01             	and    $0x1,%eax
  802124:	48 85 c0             	test   %rax,%rax
  802127:	74 73                	je     80219c <dup+0x11d>
  802129:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80212d:	48 c1 e8 0c          	shr    $0xc,%rax
  802131:	48 89 c2             	mov    %rax,%rdx
  802134:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80213b:	01 00 00 
  80213e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802142:	83 e0 01             	and    $0x1,%eax
  802145:	48 85 c0             	test   %rax,%rax
  802148:	74 52                	je     80219c <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80214a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80214e:	48 c1 e8 0c          	shr    $0xc,%rax
  802152:	48 89 c2             	mov    %rax,%rdx
  802155:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80215c:	01 00 00 
  80215f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802163:	25 07 0e 00 00       	and    $0xe07,%eax
  802168:	89 c1                	mov    %eax,%ecx
  80216a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80216e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802172:	41 89 c8             	mov    %ecx,%r8d
  802175:	48 89 d1             	mov    %rdx,%rcx
  802178:	ba 00 00 00 00       	mov    $0x0,%edx
  80217d:	48 89 c6             	mov    %rax,%rsi
  802180:	bf 00 00 00 00       	mov    $0x0,%edi
  802185:	48 b8 f3 1a 80 00 00 	movabs $0x801af3,%rax
  80218c:	00 00 00 
  80218f:	ff d0                	callq  *%rax
  802191:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802194:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802198:	79 02                	jns    80219c <dup+0x11d>
			goto err;
  80219a:	eb 57                	jmp    8021f3 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80219c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021a0:	48 c1 e8 0c          	shr    $0xc,%rax
  8021a4:	48 89 c2             	mov    %rax,%rdx
  8021a7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021ae:	01 00 00 
  8021b1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021b5:	25 07 0e 00 00       	and    $0xe07,%eax
  8021ba:	89 c1                	mov    %eax,%ecx
  8021bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021c0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021c4:	41 89 c8             	mov    %ecx,%r8d
  8021c7:	48 89 d1             	mov    %rdx,%rcx
  8021ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8021cf:	48 89 c6             	mov    %rax,%rsi
  8021d2:	bf 00 00 00 00       	mov    $0x0,%edi
  8021d7:	48 b8 f3 1a 80 00 00 	movabs $0x801af3,%rax
  8021de:	00 00 00 
  8021e1:	ff d0                	callq  *%rax
  8021e3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021ea:	79 02                	jns    8021ee <dup+0x16f>
		goto err;
  8021ec:	eb 05                	jmp    8021f3 <dup+0x174>

	return newfdnum;
  8021ee:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8021f1:	eb 33                	jmp    802226 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8021f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021f7:	48 89 c6             	mov    %rax,%rsi
  8021fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8021ff:	48 b8 4e 1b 80 00 00 	movabs $0x801b4e,%rax
  802206:	00 00 00 
  802209:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80220b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80220f:	48 89 c6             	mov    %rax,%rsi
  802212:	bf 00 00 00 00       	mov    $0x0,%edi
  802217:	48 b8 4e 1b 80 00 00 	movabs $0x801b4e,%rax
  80221e:	00 00 00 
  802221:	ff d0                	callq  *%rax
	return r;
  802223:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802226:	c9                   	leaveq 
  802227:	c3                   	retq   

0000000000802228 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802228:	55                   	push   %rbp
  802229:	48 89 e5             	mov    %rsp,%rbp
  80222c:	48 83 ec 40          	sub    $0x40,%rsp
  802230:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802233:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802237:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80223b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80223f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802242:	48 89 d6             	mov    %rdx,%rsi
  802245:	89 c7                	mov    %eax,%edi
  802247:	48 b8 f6 1d 80 00 00 	movabs $0x801df6,%rax
  80224e:	00 00 00 
  802251:	ff d0                	callq  *%rax
  802253:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802256:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80225a:	78 24                	js     802280 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80225c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802260:	8b 00                	mov    (%rax),%eax
  802262:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802266:	48 89 d6             	mov    %rdx,%rsi
  802269:	89 c7                	mov    %eax,%edi
  80226b:	48 b8 4f 1f 80 00 00 	movabs $0x801f4f,%rax
  802272:	00 00 00 
  802275:	ff d0                	callq  *%rax
  802277:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80227a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80227e:	79 05                	jns    802285 <read+0x5d>
		return r;
  802280:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802283:	eb 76                	jmp    8022fb <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802285:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802289:	8b 40 08             	mov    0x8(%rax),%eax
  80228c:	83 e0 03             	and    $0x3,%eax
  80228f:	83 f8 01             	cmp    $0x1,%eax
  802292:	75 3a                	jne    8022ce <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802294:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80229b:	00 00 00 
  80229e:	48 8b 00             	mov    (%rax),%rax
  8022a1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8022a7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8022aa:	89 c6                	mov    %eax,%esi
  8022ac:	48 bf cf 3e 80 00 00 	movabs $0x803ecf,%rdi
  8022b3:	00 00 00 
  8022b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8022bb:	48 b9 bf 05 80 00 00 	movabs $0x8005bf,%rcx
  8022c2:	00 00 00 
  8022c5:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8022c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022cc:	eb 2d                	jmp    8022fb <read+0xd3>
	}
	if (!dev->dev_read)
  8022ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022d2:	48 8b 40 10          	mov    0x10(%rax),%rax
  8022d6:	48 85 c0             	test   %rax,%rax
  8022d9:	75 07                	jne    8022e2 <read+0xba>
		return -E_NOT_SUPP;
  8022db:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8022e0:	eb 19                	jmp    8022fb <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8022e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022e6:	48 8b 40 10          	mov    0x10(%rax),%rax
  8022ea:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8022ee:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8022f2:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8022f6:	48 89 cf             	mov    %rcx,%rdi
  8022f9:	ff d0                	callq  *%rax
}
  8022fb:	c9                   	leaveq 
  8022fc:	c3                   	retq   

00000000008022fd <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8022fd:	55                   	push   %rbp
  8022fe:	48 89 e5             	mov    %rsp,%rbp
  802301:	48 83 ec 30          	sub    $0x30,%rsp
  802305:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802308:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80230c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802310:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802317:	eb 49                	jmp    802362 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802319:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80231c:	48 98                	cltq   
  80231e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802322:	48 29 c2             	sub    %rax,%rdx
  802325:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802328:	48 63 c8             	movslq %eax,%rcx
  80232b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80232f:	48 01 c1             	add    %rax,%rcx
  802332:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802335:	48 89 ce             	mov    %rcx,%rsi
  802338:	89 c7                	mov    %eax,%edi
  80233a:	48 b8 28 22 80 00 00 	movabs $0x802228,%rax
  802341:	00 00 00 
  802344:	ff d0                	callq  *%rax
  802346:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802349:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80234d:	79 05                	jns    802354 <readn+0x57>
			return m;
  80234f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802352:	eb 1c                	jmp    802370 <readn+0x73>
		if (m == 0)
  802354:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802358:	75 02                	jne    80235c <readn+0x5f>
			break;
  80235a:	eb 11                	jmp    80236d <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80235c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80235f:	01 45 fc             	add    %eax,-0x4(%rbp)
  802362:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802365:	48 98                	cltq   
  802367:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80236b:	72 ac                	jb     802319 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80236d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802370:	c9                   	leaveq 
  802371:	c3                   	retq   

0000000000802372 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802372:	55                   	push   %rbp
  802373:	48 89 e5             	mov    %rsp,%rbp
  802376:	48 83 ec 40          	sub    $0x40,%rsp
  80237a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80237d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802381:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802385:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802389:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80238c:	48 89 d6             	mov    %rdx,%rsi
  80238f:	89 c7                	mov    %eax,%edi
  802391:	48 b8 f6 1d 80 00 00 	movabs $0x801df6,%rax
  802398:	00 00 00 
  80239b:	ff d0                	callq  *%rax
  80239d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023a4:	78 24                	js     8023ca <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023aa:	8b 00                	mov    (%rax),%eax
  8023ac:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023b0:	48 89 d6             	mov    %rdx,%rsi
  8023b3:	89 c7                	mov    %eax,%edi
  8023b5:	48 b8 4f 1f 80 00 00 	movabs $0x801f4f,%rax
  8023bc:	00 00 00 
  8023bf:	ff d0                	callq  *%rax
  8023c1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023c8:	79 05                	jns    8023cf <write+0x5d>
		return r;
  8023ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023cd:	eb 75                	jmp    802444 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8023cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023d3:	8b 40 08             	mov    0x8(%rax),%eax
  8023d6:	83 e0 03             	and    $0x3,%eax
  8023d9:	85 c0                	test   %eax,%eax
  8023db:	75 3a                	jne    802417 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8023dd:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8023e4:	00 00 00 
  8023e7:	48 8b 00             	mov    (%rax),%rax
  8023ea:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8023f0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8023f3:	89 c6                	mov    %eax,%esi
  8023f5:	48 bf eb 3e 80 00 00 	movabs $0x803eeb,%rdi
  8023fc:	00 00 00 
  8023ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802404:	48 b9 bf 05 80 00 00 	movabs $0x8005bf,%rcx
  80240b:	00 00 00 
  80240e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802410:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802415:	eb 2d                	jmp    802444 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802417:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80241b:	48 8b 40 18          	mov    0x18(%rax),%rax
  80241f:	48 85 c0             	test   %rax,%rax
  802422:	75 07                	jne    80242b <write+0xb9>
		return -E_NOT_SUPP;
  802424:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802429:	eb 19                	jmp    802444 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80242b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80242f:	48 8b 40 18          	mov    0x18(%rax),%rax
  802433:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802437:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80243b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80243f:	48 89 cf             	mov    %rcx,%rdi
  802442:	ff d0                	callq  *%rax
}
  802444:	c9                   	leaveq 
  802445:	c3                   	retq   

0000000000802446 <seek>:

int
seek(int fdnum, off_t offset)
{
  802446:	55                   	push   %rbp
  802447:	48 89 e5             	mov    %rsp,%rbp
  80244a:	48 83 ec 18          	sub    $0x18,%rsp
  80244e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802451:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802454:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802458:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80245b:	48 89 d6             	mov    %rdx,%rsi
  80245e:	89 c7                	mov    %eax,%edi
  802460:	48 b8 f6 1d 80 00 00 	movabs $0x801df6,%rax
  802467:	00 00 00 
  80246a:	ff d0                	callq  *%rax
  80246c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80246f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802473:	79 05                	jns    80247a <seek+0x34>
		return r;
  802475:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802478:	eb 0f                	jmp    802489 <seek+0x43>
	fd->fd_offset = offset;
  80247a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80247e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802481:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802484:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802489:	c9                   	leaveq 
  80248a:	c3                   	retq   

000000000080248b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80248b:	55                   	push   %rbp
  80248c:	48 89 e5             	mov    %rsp,%rbp
  80248f:	48 83 ec 30          	sub    $0x30,%rsp
  802493:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802496:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802499:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80249d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024a0:	48 89 d6             	mov    %rdx,%rsi
  8024a3:	89 c7                	mov    %eax,%edi
  8024a5:	48 b8 f6 1d 80 00 00 	movabs $0x801df6,%rax
  8024ac:	00 00 00 
  8024af:	ff d0                	callq  *%rax
  8024b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024b8:	78 24                	js     8024de <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024be:	8b 00                	mov    (%rax),%eax
  8024c0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024c4:	48 89 d6             	mov    %rdx,%rsi
  8024c7:	89 c7                	mov    %eax,%edi
  8024c9:	48 b8 4f 1f 80 00 00 	movabs $0x801f4f,%rax
  8024d0:	00 00 00 
  8024d3:	ff d0                	callq  *%rax
  8024d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024dc:	79 05                	jns    8024e3 <ftruncate+0x58>
		return r;
  8024de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024e1:	eb 72                	jmp    802555 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8024e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024e7:	8b 40 08             	mov    0x8(%rax),%eax
  8024ea:	83 e0 03             	and    $0x3,%eax
  8024ed:	85 c0                	test   %eax,%eax
  8024ef:	75 3a                	jne    80252b <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8024f1:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8024f8:	00 00 00 
  8024fb:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8024fe:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802504:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802507:	89 c6                	mov    %eax,%esi
  802509:	48 bf 08 3f 80 00 00 	movabs $0x803f08,%rdi
  802510:	00 00 00 
  802513:	b8 00 00 00 00       	mov    $0x0,%eax
  802518:	48 b9 bf 05 80 00 00 	movabs $0x8005bf,%rcx
  80251f:	00 00 00 
  802522:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802524:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802529:	eb 2a                	jmp    802555 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80252b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80252f:	48 8b 40 30          	mov    0x30(%rax),%rax
  802533:	48 85 c0             	test   %rax,%rax
  802536:	75 07                	jne    80253f <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802538:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80253d:	eb 16                	jmp    802555 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80253f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802543:	48 8b 40 30          	mov    0x30(%rax),%rax
  802547:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80254b:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80254e:	89 ce                	mov    %ecx,%esi
  802550:	48 89 d7             	mov    %rdx,%rdi
  802553:	ff d0                	callq  *%rax
}
  802555:	c9                   	leaveq 
  802556:	c3                   	retq   

0000000000802557 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802557:	55                   	push   %rbp
  802558:	48 89 e5             	mov    %rsp,%rbp
  80255b:	48 83 ec 30          	sub    $0x30,%rsp
  80255f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802562:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802566:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80256a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80256d:	48 89 d6             	mov    %rdx,%rsi
  802570:	89 c7                	mov    %eax,%edi
  802572:	48 b8 f6 1d 80 00 00 	movabs $0x801df6,%rax
  802579:	00 00 00 
  80257c:	ff d0                	callq  *%rax
  80257e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802581:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802585:	78 24                	js     8025ab <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802587:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80258b:	8b 00                	mov    (%rax),%eax
  80258d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802591:	48 89 d6             	mov    %rdx,%rsi
  802594:	89 c7                	mov    %eax,%edi
  802596:	48 b8 4f 1f 80 00 00 	movabs $0x801f4f,%rax
  80259d:	00 00 00 
  8025a0:	ff d0                	callq  *%rax
  8025a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025a9:	79 05                	jns    8025b0 <fstat+0x59>
		return r;
  8025ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025ae:	eb 5e                	jmp    80260e <fstat+0xb7>
	if (!dev->dev_stat)
  8025b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025b4:	48 8b 40 28          	mov    0x28(%rax),%rax
  8025b8:	48 85 c0             	test   %rax,%rax
  8025bb:	75 07                	jne    8025c4 <fstat+0x6d>
		return -E_NOT_SUPP;
  8025bd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025c2:	eb 4a                	jmp    80260e <fstat+0xb7>
	stat->st_name[0] = 0;
  8025c4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025c8:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8025cb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025cf:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8025d6:	00 00 00 
	stat->st_isdir = 0;
  8025d9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025dd:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8025e4:	00 00 00 
	stat->st_dev = dev;
  8025e7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025eb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025ef:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8025f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025fa:	48 8b 40 28          	mov    0x28(%rax),%rax
  8025fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802602:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802606:	48 89 ce             	mov    %rcx,%rsi
  802609:	48 89 d7             	mov    %rdx,%rdi
  80260c:	ff d0                	callq  *%rax
}
  80260e:	c9                   	leaveq 
  80260f:	c3                   	retq   

0000000000802610 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802610:	55                   	push   %rbp
  802611:	48 89 e5             	mov    %rsp,%rbp
  802614:	48 83 ec 20          	sub    $0x20,%rsp
  802618:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80261c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802620:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802624:	be 00 00 00 00       	mov    $0x0,%esi
  802629:	48 89 c7             	mov    %rax,%rdi
  80262c:	48 b8 fe 26 80 00 00 	movabs $0x8026fe,%rax
  802633:	00 00 00 
  802636:	ff d0                	callq  *%rax
  802638:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80263b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80263f:	79 05                	jns    802646 <stat+0x36>
		return fd;
  802641:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802644:	eb 2f                	jmp    802675 <stat+0x65>
	r = fstat(fd, stat);
  802646:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80264a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80264d:	48 89 d6             	mov    %rdx,%rsi
  802650:	89 c7                	mov    %eax,%edi
  802652:	48 b8 57 25 80 00 00 	movabs $0x802557,%rax
  802659:	00 00 00 
  80265c:	ff d0                	callq  *%rax
  80265e:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802661:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802664:	89 c7                	mov    %eax,%edi
  802666:	48 b8 06 20 80 00 00 	movabs $0x802006,%rax
  80266d:	00 00 00 
  802670:	ff d0                	callq  *%rax
	return r;
  802672:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802675:	c9                   	leaveq 
  802676:	c3                   	retq   

0000000000802677 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802677:	55                   	push   %rbp
  802678:	48 89 e5             	mov    %rsp,%rbp
  80267b:	48 83 ec 10          	sub    $0x10,%rsp
  80267f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802682:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802686:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  80268d:	00 00 00 
  802690:	8b 00                	mov    (%rax),%eax
  802692:	85 c0                	test   %eax,%eax
  802694:	75 1d                	jne    8026b3 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802696:	bf 01 00 00 00       	mov    $0x1,%edi
  80269b:	48 b8 21 38 80 00 00 	movabs $0x803821,%rax
  8026a2:	00 00 00 
  8026a5:	ff d0                	callq  *%rax
  8026a7:	48 ba 04 60 80 00 00 	movabs $0x806004,%rdx
  8026ae:	00 00 00 
  8026b1:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8026b3:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  8026ba:	00 00 00 
  8026bd:	8b 00                	mov    (%rax),%eax
  8026bf:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8026c2:	b9 07 00 00 00       	mov    $0x7,%ecx
  8026c7:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8026ce:	00 00 00 
  8026d1:	89 c7                	mov    %eax,%edi
  8026d3:	48 b8 bf 37 80 00 00 	movabs $0x8037bf,%rax
  8026da:	00 00 00 
  8026dd:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8026df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8026e8:	48 89 c6             	mov    %rax,%rsi
  8026eb:	bf 00 00 00 00       	mov    $0x0,%edi
  8026f0:	48 b8 b9 36 80 00 00 	movabs $0x8036b9,%rax
  8026f7:	00 00 00 
  8026fa:	ff d0                	callq  *%rax
}
  8026fc:	c9                   	leaveq 
  8026fd:	c3                   	retq   

00000000008026fe <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8026fe:	55                   	push   %rbp
  8026ff:	48 89 e5             	mov    %rsp,%rbp
  802702:	48 83 ec 30          	sub    $0x30,%rsp
  802706:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80270a:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  80270d:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802714:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  80271b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802722:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802727:	75 08                	jne    802731 <open+0x33>
	{
		return r;
  802729:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80272c:	e9 f2 00 00 00       	jmpq   802823 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802731:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802735:	48 89 c7             	mov    %rax,%rdi
  802738:	48 b8 08 11 80 00 00 	movabs $0x801108,%rax
  80273f:	00 00 00 
  802742:	ff d0                	callq  *%rax
  802744:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802747:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  80274e:	7e 0a                	jle    80275a <open+0x5c>
	{
		return -E_BAD_PATH;
  802750:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802755:	e9 c9 00 00 00       	jmpq   802823 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  80275a:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802761:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802762:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802766:	48 89 c7             	mov    %rax,%rdi
  802769:	48 b8 5e 1d 80 00 00 	movabs $0x801d5e,%rax
  802770:	00 00 00 
  802773:	ff d0                	callq  *%rax
  802775:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802778:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80277c:	78 09                	js     802787 <open+0x89>
  80277e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802782:	48 85 c0             	test   %rax,%rax
  802785:	75 08                	jne    80278f <open+0x91>
		{
			return r;
  802787:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80278a:	e9 94 00 00 00       	jmpq   802823 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  80278f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802793:	ba 00 04 00 00       	mov    $0x400,%edx
  802798:	48 89 c6             	mov    %rax,%rsi
  80279b:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  8027a2:	00 00 00 
  8027a5:	48 b8 06 12 80 00 00 	movabs $0x801206,%rax
  8027ac:	00 00 00 
  8027af:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  8027b1:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027b8:	00 00 00 
  8027bb:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  8027be:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  8027c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027c8:	48 89 c6             	mov    %rax,%rsi
  8027cb:	bf 01 00 00 00       	mov    $0x1,%edi
  8027d0:	48 b8 77 26 80 00 00 	movabs $0x802677,%rax
  8027d7:	00 00 00 
  8027da:	ff d0                	callq  *%rax
  8027dc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027df:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027e3:	79 2b                	jns    802810 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  8027e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027e9:	be 00 00 00 00       	mov    $0x0,%esi
  8027ee:	48 89 c7             	mov    %rax,%rdi
  8027f1:	48 b8 86 1e 80 00 00 	movabs $0x801e86,%rax
  8027f8:	00 00 00 
  8027fb:	ff d0                	callq  *%rax
  8027fd:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802800:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802804:	79 05                	jns    80280b <open+0x10d>
			{
				return d;
  802806:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802809:	eb 18                	jmp    802823 <open+0x125>
			}
			return r;
  80280b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80280e:	eb 13                	jmp    802823 <open+0x125>
		}	
		return fd2num(fd_store);
  802810:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802814:	48 89 c7             	mov    %rax,%rdi
  802817:	48 b8 10 1d 80 00 00 	movabs $0x801d10,%rax
  80281e:	00 00 00 
  802821:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802823:	c9                   	leaveq 
  802824:	c3                   	retq   

0000000000802825 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802825:	55                   	push   %rbp
  802826:	48 89 e5             	mov    %rsp,%rbp
  802829:	48 83 ec 10          	sub    $0x10,%rsp
  80282d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802831:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802835:	8b 50 0c             	mov    0xc(%rax),%edx
  802838:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80283f:	00 00 00 
  802842:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802844:	be 00 00 00 00       	mov    $0x0,%esi
  802849:	bf 06 00 00 00       	mov    $0x6,%edi
  80284e:	48 b8 77 26 80 00 00 	movabs $0x802677,%rax
  802855:	00 00 00 
  802858:	ff d0                	callq  *%rax
}
  80285a:	c9                   	leaveq 
  80285b:	c3                   	retq   

000000000080285c <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80285c:	55                   	push   %rbp
  80285d:	48 89 e5             	mov    %rsp,%rbp
  802860:	48 83 ec 30          	sub    $0x30,%rsp
  802864:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802868:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80286c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802870:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802877:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80287c:	74 07                	je     802885 <devfile_read+0x29>
  80287e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802883:	75 07                	jne    80288c <devfile_read+0x30>
		return -E_INVAL;
  802885:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80288a:	eb 77                	jmp    802903 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80288c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802890:	8b 50 0c             	mov    0xc(%rax),%edx
  802893:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80289a:	00 00 00 
  80289d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80289f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8028a6:	00 00 00 
  8028a9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028ad:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  8028b1:	be 00 00 00 00       	mov    $0x0,%esi
  8028b6:	bf 03 00 00 00       	mov    $0x3,%edi
  8028bb:	48 b8 77 26 80 00 00 	movabs $0x802677,%rax
  8028c2:	00 00 00 
  8028c5:	ff d0                	callq  *%rax
  8028c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028ce:	7f 05                	jg     8028d5 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  8028d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028d3:	eb 2e                	jmp    802903 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  8028d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028d8:	48 63 d0             	movslq %eax,%rdx
  8028db:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028df:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  8028e6:	00 00 00 
  8028e9:	48 89 c7             	mov    %rax,%rdi
  8028ec:	48 b8 98 14 80 00 00 	movabs $0x801498,%rax
  8028f3:	00 00 00 
  8028f6:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  8028f8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028fc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802900:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802903:	c9                   	leaveq 
  802904:	c3                   	retq   

0000000000802905 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802905:	55                   	push   %rbp
  802906:	48 89 e5             	mov    %rsp,%rbp
  802909:	48 83 ec 30          	sub    $0x30,%rsp
  80290d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802911:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802915:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802919:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802920:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802925:	74 07                	je     80292e <devfile_write+0x29>
  802927:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80292c:	75 08                	jne    802936 <devfile_write+0x31>
		return r;
  80292e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802931:	e9 9a 00 00 00       	jmpq   8029d0 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802936:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80293a:	8b 50 0c             	mov    0xc(%rax),%edx
  80293d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802944:	00 00 00 
  802947:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802949:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802950:	00 
  802951:	76 08                	jbe    80295b <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802953:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  80295a:	00 
	}
	fsipcbuf.write.req_n = n;
  80295b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802962:	00 00 00 
  802965:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802969:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  80296d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802971:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802975:	48 89 c6             	mov    %rax,%rsi
  802978:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  80297f:	00 00 00 
  802982:	48 b8 98 14 80 00 00 	movabs $0x801498,%rax
  802989:	00 00 00 
  80298c:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  80298e:	be 00 00 00 00       	mov    $0x0,%esi
  802993:	bf 04 00 00 00       	mov    $0x4,%edi
  802998:	48 b8 77 26 80 00 00 	movabs $0x802677,%rax
  80299f:	00 00 00 
  8029a2:	ff d0                	callq  *%rax
  8029a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029ab:	7f 20                	jg     8029cd <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  8029ad:	48 bf 2e 3f 80 00 00 	movabs $0x803f2e,%rdi
  8029b4:	00 00 00 
  8029b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8029bc:	48 ba bf 05 80 00 00 	movabs $0x8005bf,%rdx
  8029c3:	00 00 00 
  8029c6:	ff d2                	callq  *%rdx
		return r;
  8029c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029cb:	eb 03                	jmp    8029d0 <devfile_write+0xcb>
	}
	return r;
  8029cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  8029d0:	c9                   	leaveq 
  8029d1:	c3                   	retq   

00000000008029d2 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8029d2:	55                   	push   %rbp
  8029d3:	48 89 e5             	mov    %rsp,%rbp
  8029d6:	48 83 ec 20          	sub    $0x20,%rsp
  8029da:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029de:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8029e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029e6:	8b 50 0c             	mov    0xc(%rax),%edx
  8029e9:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8029f0:	00 00 00 
  8029f3:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8029f5:	be 00 00 00 00       	mov    $0x0,%esi
  8029fa:	bf 05 00 00 00       	mov    $0x5,%edi
  8029ff:	48 b8 77 26 80 00 00 	movabs $0x802677,%rax
  802a06:	00 00 00 
  802a09:	ff d0                	callq  *%rax
  802a0b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a0e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a12:	79 05                	jns    802a19 <devfile_stat+0x47>
		return r;
  802a14:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a17:	eb 56                	jmp    802a6f <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802a19:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a1d:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802a24:	00 00 00 
  802a27:	48 89 c7             	mov    %rax,%rdi
  802a2a:	48 b8 74 11 80 00 00 	movabs $0x801174,%rax
  802a31:	00 00 00 
  802a34:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802a36:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a3d:	00 00 00 
  802a40:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802a46:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a4a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802a50:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a57:	00 00 00 
  802a5a:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802a60:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a64:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802a6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a6f:	c9                   	leaveq 
  802a70:	c3                   	retq   

0000000000802a71 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802a71:	55                   	push   %rbp
  802a72:	48 89 e5             	mov    %rsp,%rbp
  802a75:	48 83 ec 10          	sub    $0x10,%rsp
  802a79:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802a7d:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802a80:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a84:	8b 50 0c             	mov    0xc(%rax),%edx
  802a87:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a8e:	00 00 00 
  802a91:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802a93:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a9a:	00 00 00 
  802a9d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802aa0:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802aa3:	be 00 00 00 00       	mov    $0x0,%esi
  802aa8:	bf 02 00 00 00       	mov    $0x2,%edi
  802aad:	48 b8 77 26 80 00 00 	movabs $0x802677,%rax
  802ab4:	00 00 00 
  802ab7:	ff d0                	callq  *%rax
}
  802ab9:	c9                   	leaveq 
  802aba:	c3                   	retq   

0000000000802abb <remove>:

// Delete a file
int
remove(const char *path)
{
  802abb:	55                   	push   %rbp
  802abc:	48 89 e5             	mov    %rsp,%rbp
  802abf:	48 83 ec 10          	sub    $0x10,%rsp
  802ac3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802ac7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802acb:	48 89 c7             	mov    %rax,%rdi
  802ace:	48 b8 08 11 80 00 00 	movabs $0x801108,%rax
  802ad5:	00 00 00 
  802ad8:	ff d0                	callq  *%rax
  802ada:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802adf:	7e 07                	jle    802ae8 <remove+0x2d>
		return -E_BAD_PATH;
  802ae1:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802ae6:	eb 33                	jmp    802b1b <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802ae8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802aec:	48 89 c6             	mov    %rax,%rsi
  802aef:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802af6:	00 00 00 
  802af9:	48 b8 74 11 80 00 00 	movabs $0x801174,%rax
  802b00:	00 00 00 
  802b03:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802b05:	be 00 00 00 00       	mov    $0x0,%esi
  802b0a:	bf 07 00 00 00       	mov    $0x7,%edi
  802b0f:	48 b8 77 26 80 00 00 	movabs $0x802677,%rax
  802b16:	00 00 00 
  802b19:	ff d0                	callq  *%rax
}
  802b1b:	c9                   	leaveq 
  802b1c:	c3                   	retq   

0000000000802b1d <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802b1d:	55                   	push   %rbp
  802b1e:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802b21:	be 00 00 00 00       	mov    $0x0,%esi
  802b26:	bf 08 00 00 00       	mov    $0x8,%edi
  802b2b:	48 b8 77 26 80 00 00 	movabs $0x802677,%rax
  802b32:	00 00 00 
  802b35:	ff d0                	callq  *%rax
}
  802b37:	5d                   	pop    %rbp
  802b38:	c3                   	retq   

0000000000802b39 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  802b39:	55                   	push   %rbp
  802b3a:	48 89 e5             	mov    %rsp,%rbp
  802b3d:	48 83 ec 20          	sub    $0x20,%rsp
  802b41:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  802b45:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b49:	8b 40 0c             	mov    0xc(%rax),%eax
  802b4c:	85 c0                	test   %eax,%eax
  802b4e:	7e 67                	jle    802bb7 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802b50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b54:	8b 40 04             	mov    0x4(%rax),%eax
  802b57:	48 63 d0             	movslq %eax,%rdx
  802b5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b5e:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802b62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b66:	8b 00                	mov    (%rax),%eax
  802b68:	48 89 ce             	mov    %rcx,%rsi
  802b6b:	89 c7                	mov    %eax,%edi
  802b6d:	48 b8 72 23 80 00 00 	movabs $0x802372,%rax
  802b74:	00 00 00 
  802b77:	ff d0                	callq  *%rax
  802b79:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  802b7c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b80:	7e 13                	jle    802b95 <writebuf+0x5c>
			b->result += result;
  802b82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b86:	8b 50 08             	mov    0x8(%rax),%edx
  802b89:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b8c:	01 c2                	add    %eax,%edx
  802b8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b92:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  802b95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b99:	8b 40 04             	mov    0x4(%rax),%eax
  802b9c:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802b9f:	74 16                	je     802bb7 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  802ba1:	b8 00 00 00 00       	mov    $0x0,%eax
  802ba6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802baa:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  802bae:	89 c2                	mov    %eax,%edx
  802bb0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bb4:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  802bb7:	c9                   	leaveq 
  802bb8:	c3                   	retq   

0000000000802bb9 <putch>:

static void
putch(int ch, void *thunk)
{
  802bb9:	55                   	push   %rbp
  802bba:	48 89 e5             	mov    %rsp,%rbp
  802bbd:	48 83 ec 20          	sub    $0x20,%rsp
  802bc1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802bc4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  802bc8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bcc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  802bd0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bd4:	8b 40 04             	mov    0x4(%rax),%eax
  802bd7:	8d 48 01             	lea    0x1(%rax),%ecx
  802bda:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802bde:	89 4a 04             	mov    %ecx,0x4(%rdx)
  802be1:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802be4:	89 d1                	mov    %edx,%ecx
  802be6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802bea:	48 98                	cltq   
  802bec:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  802bf0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bf4:	8b 40 04             	mov    0x4(%rax),%eax
  802bf7:	3d 00 01 00 00       	cmp    $0x100,%eax
  802bfc:	75 1e                	jne    802c1c <putch+0x63>
		writebuf(b);
  802bfe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c02:	48 89 c7             	mov    %rax,%rdi
  802c05:	48 b8 39 2b 80 00 00 	movabs $0x802b39,%rax
  802c0c:	00 00 00 
  802c0f:	ff d0                	callq  *%rax
		b->idx = 0;
  802c11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c15:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  802c1c:	c9                   	leaveq 
  802c1d:	c3                   	retq   

0000000000802c1e <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802c1e:	55                   	push   %rbp
  802c1f:	48 89 e5             	mov    %rsp,%rbp
  802c22:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  802c29:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  802c2f:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  802c36:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  802c3d:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  802c43:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  802c49:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802c50:	00 00 00 
	b.result = 0;
  802c53:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  802c5a:	00 00 00 
	b.error = 1;
  802c5d:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  802c64:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802c67:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  802c6e:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  802c75:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802c7c:	48 89 c6             	mov    %rax,%rsi
  802c7f:	48 bf b9 2b 80 00 00 	movabs $0x802bb9,%rdi
  802c86:	00 00 00 
  802c89:	48 b8 72 09 80 00 00 	movabs $0x800972,%rax
  802c90:	00 00 00 
  802c93:	ff d0                	callq  *%rax
	if (b.idx > 0)
  802c95:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  802c9b:	85 c0                	test   %eax,%eax
  802c9d:	7e 16                	jle    802cb5 <vfprintf+0x97>
		writebuf(&b);
  802c9f:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802ca6:	48 89 c7             	mov    %rax,%rdi
  802ca9:	48 b8 39 2b 80 00 00 	movabs $0x802b39,%rax
  802cb0:	00 00 00 
  802cb3:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  802cb5:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802cbb:	85 c0                	test   %eax,%eax
  802cbd:	74 08                	je     802cc7 <vfprintf+0xa9>
  802cbf:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802cc5:	eb 06                	jmp    802ccd <vfprintf+0xaf>
  802cc7:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  802ccd:	c9                   	leaveq 
  802cce:	c3                   	retq   

0000000000802ccf <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802ccf:	55                   	push   %rbp
  802cd0:	48 89 e5             	mov    %rsp,%rbp
  802cd3:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802cda:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  802ce0:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802ce7:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802cee:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802cf5:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802cfc:	84 c0                	test   %al,%al
  802cfe:	74 20                	je     802d20 <fprintf+0x51>
  802d00:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802d04:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802d08:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802d0c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802d10:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802d14:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802d18:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802d1c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802d20:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802d27:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  802d2e:	00 00 00 
  802d31:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802d38:	00 00 00 
  802d3b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802d3f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802d46:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802d4d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  802d54:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802d5b:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  802d62:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  802d68:	48 89 ce             	mov    %rcx,%rsi
  802d6b:	89 c7                	mov    %eax,%edi
  802d6d:	48 b8 1e 2c 80 00 00 	movabs $0x802c1e,%rax
  802d74:	00 00 00 
  802d77:	ff d0                	callq  *%rax
  802d79:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  802d7f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802d85:	c9                   	leaveq 
  802d86:	c3                   	retq   

0000000000802d87 <printf>:

int
printf(const char *fmt, ...)
{
  802d87:	55                   	push   %rbp
  802d88:	48 89 e5             	mov    %rsp,%rbp
  802d8b:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802d92:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  802d99:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802da0:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802da7:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802dae:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802db5:	84 c0                	test   %al,%al
  802db7:	74 20                	je     802dd9 <printf+0x52>
  802db9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802dbd:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802dc1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802dc5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802dc9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802dcd:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802dd1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802dd5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802dd9:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802de0:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  802de7:	00 00 00 
  802dea:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802df1:	00 00 00 
  802df4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802df8:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802dff:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802e06:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  802e0d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802e14:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  802e1b:	48 89 c6             	mov    %rax,%rsi
  802e1e:	bf 01 00 00 00       	mov    $0x1,%edi
  802e23:	48 b8 1e 2c 80 00 00 	movabs $0x802c1e,%rax
  802e2a:	00 00 00 
  802e2d:	ff d0                	callq  *%rax
  802e2f:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  802e35:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802e3b:	c9                   	leaveq 
  802e3c:	c3                   	retq   

0000000000802e3d <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802e3d:	55                   	push   %rbp
  802e3e:	48 89 e5             	mov    %rsp,%rbp
  802e41:	53                   	push   %rbx
  802e42:	48 83 ec 38          	sub    $0x38,%rsp
  802e46:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802e4a:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802e4e:	48 89 c7             	mov    %rax,%rdi
  802e51:	48 b8 5e 1d 80 00 00 	movabs $0x801d5e,%rax
  802e58:	00 00 00 
  802e5b:	ff d0                	callq  *%rax
  802e5d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802e60:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802e64:	0f 88 bf 01 00 00    	js     803029 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e6a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e6e:	ba 07 04 00 00       	mov    $0x407,%edx
  802e73:	48 89 c6             	mov    %rax,%rsi
  802e76:	bf 00 00 00 00       	mov    $0x0,%edi
  802e7b:	48 b8 a3 1a 80 00 00 	movabs $0x801aa3,%rax
  802e82:	00 00 00 
  802e85:	ff d0                	callq  *%rax
  802e87:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802e8a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802e8e:	0f 88 95 01 00 00    	js     803029 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802e94:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802e98:	48 89 c7             	mov    %rax,%rdi
  802e9b:	48 b8 5e 1d 80 00 00 	movabs $0x801d5e,%rax
  802ea2:	00 00 00 
  802ea5:	ff d0                	callq  *%rax
  802ea7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802eaa:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802eae:	0f 88 5d 01 00 00    	js     803011 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802eb4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802eb8:	ba 07 04 00 00       	mov    $0x407,%edx
  802ebd:	48 89 c6             	mov    %rax,%rsi
  802ec0:	bf 00 00 00 00       	mov    $0x0,%edi
  802ec5:	48 b8 a3 1a 80 00 00 	movabs $0x801aa3,%rax
  802ecc:	00 00 00 
  802ecf:	ff d0                	callq  *%rax
  802ed1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802ed4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802ed8:	0f 88 33 01 00 00    	js     803011 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802ede:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ee2:	48 89 c7             	mov    %rax,%rdi
  802ee5:	48 b8 33 1d 80 00 00 	movabs $0x801d33,%rax
  802eec:	00 00 00 
  802eef:	ff d0                	callq  *%rax
  802ef1:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802ef5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ef9:	ba 07 04 00 00       	mov    $0x407,%edx
  802efe:	48 89 c6             	mov    %rax,%rsi
  802f01:	bf 00 00 00 00       	mov    $0x0,%edi
  802f06:	48 b8 a3 1a 80 00 00 	movabs $0x801aa3,%rax
  802f0d:	00 00 00 
  802f10:	ff d0                	callq  *%rax
  802f12:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802f15:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802f19:	79 05                	jns    802f20 <pipe+0xe3>
		goto err2;
  802f1b:	e9 d9 00 00 00       	jmpq   802ff9 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802f20:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f24:	48 89 c7             	mov    %rax,%rdi
  802f27:	48 b8 33 1d 80 00 00 	movabs $0x801d33,%rax
  802f2e:	00 00 00 
  802f31:	ff d0                	callq  *%rax
  802f33:	48 89 c2             	mov    %rax,%rdx
  802f36:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f3a:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  802f40:	48 89 d1             	mov    %rdx,%rcx
  802f43:	ba 00 00 00 00       	mov    $0x0,%edx
  802f48:	48 89 c6             	mov    %rax,%rsi
  802f4b:	bf 00 00 00 00       	mov    $0x0,%edi
  802f50:	48 b8 f3 1a 80 00 00 	movabs $0x801af3,%rax
  802f57:	00 00 00 
  802f5a:	ff d0                	callq  *%rax
  802f5c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802f5f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802f63:	79 1b                	jns    802f80 <pipe+0x143>
		goto err3;
  802f65:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  802f66:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f6a:	48 89 c6             	mov    %rax,%rsi
  802f6d:	bf 00 00 00 00       	mov    $0x0,%edi
  802f72:	48 b8 4e 1b 80 00 00 	movabs $0x801b4e,%rax
  802f79:	00 00 00 
  802f7c:	ff d0                	callq  *%rax
  802f7e:	eb 79                	jmp    802ff9 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802f80:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f84:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802f8b:	00 00 00 
  802f8e:	8b 12                	mov    (%rdx),%edx
  802f90:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802f92:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f96:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  802f9d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fa1:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802fa8:	00 00 00 
  802fab:	8b 12                	mov    (%rdx),%edx
  802fad:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  802faf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fb3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802fba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fbe:	48 89 c7             	mov    %rax,%rdi
  802fc1:	48 b8 10 1d 80 00 00 	movabs $0x801d10,%rax
  802fc8:	00 00 00 
  802fcb:	ff d0                	callq  *%rax
  802fcd:	89 c2                	mov    %eax,%edx
  802fcf:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802fd3:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  802fd5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802fd9:	48 8d 58 04          	lea    0x4(%rax),%rbx
  802fdd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fe1:	48 89 c7             	mov    %rax,%rdi
  802fe4:	48 b8 10 1d 80 00 00 	movabs $0x801d10,%rax
  802feb:	00 00 00 
  802fee:	ff d0                	callq  *%rax
  802ff0:	89 03                	mov    %eax,(%rbx)
	return 0;
  802ff2:	b8 00 00 00 00       	mov    $0x0,%eax
  802ff7:	eb 33                	jmp    80302c <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  802ff9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ffd:	48 89 c6             	mov    %rax,%rsi
  803000:	bf 00 00 00 00       	mov    $0x0,%edi
  803005:	48 b8 4e 1b 80 00 00 	movabs $0x801b4e,%rax
  80300c:	00 00 00 
  80300f:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  803011:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803015:	48 89 c6             	mov    %rax,%rsi
  803018:	bf 00 00 00 00       	mov    $0x0,%edi
  80301d:	48 b8 4e 1b 80 00 00 	movabs $0x801b4e,%rax
  803024:	00 00 00 
  803027:	ff d0                	callq  *%rax
    err:
	return r;
  803029:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80302c:	48 83 c4 38          	add    $0x38,%rsp
  803030:	5b                   	pop    %rbx
  803031:	5d                   	pop    %rbp
  803032:	c3                   	retq   

0000000000803033 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803033:	55                   	push   %rbp
  803034:	48 89 e5             	mov    %rsp,%rbp
  803037:	53                   	push   %rbx
  803038:	48 83 ec 28          	sub    $0x28,%rsp
  80303c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803040:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803044:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80304b:	00 00 00 
  80304e:	48 8b 00             	mov    (%rax),%rax
  803051:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803057:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80305a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80305e:	48 89 c7             	mov    %rax,%rdi
  803061:	48 b8 a3 38 80 00 00 	movabs $0x8038a3,%rax
  803068:	00 00 00 
  80306b:	ff d0                	callq  *%rax
  80306d:	89 c3                	mov    %eax,%ebx
  80306f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803073:	48 89 c7             	mov    %rax,%rdi
  803076:	48 b8 a3 38 80 00 00 	movabs $0x8038a3,%rax
  80307d:	00 00 00 
  803080:	ff d0                	callq  *%rax
  803082:	39 c3                	cmp    %eax,%ebx
  803084:	0f 94 c0             	sete   %al
  803087:	0f b6 c0             	movzbl %al,%eax
  80308a:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80308d:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803094:	00 00 00 
  803097:	48 8b 00             	mov    (%rax),%rax
  80309a:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8030a0:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8030a3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030a6:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8030a9:	75 05                	jne    8030b0 <_pipeisclosed+0x7d>
			return ret;
  8030ab:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8030ae:	eb 4f                	jmp    8030ff <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8030b0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030b3:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8030b6:	74 42                	je     8030fa <_pipeisclosed+0xc7>
  8030b8:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8030bc:	75 3c                	jne    8030fa <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8030be:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8030c5:	00 00 00 
  8030c8:	48 8b 00             	mov    (%rax),%rax
  8030cb:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8030d1:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8030d4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030d7:	89 c6                	mov    %eax,%esi
  8030d9:	48 bf 4f 3f 80 00 00 	movabs $0x803f4f,%rdi
  8030e0:	00 00 00 
  8030e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8030e8:	49 b8 bf 05 80 00 00 	movabs $0x8005bf,%r8
  8030ef:	00 00 00 
  8030f2:	41 ff d0             	callq  *%r8
	}
  8030f5:	e9 4a ff ff ff       	jmpq   803044 <_pipeisclosed+0x11>
  8030fa:	e9 45 ff ff ff       	jmpq   803044 <_pipeisclosed+0x11>
}
  8030ff:	48 83 c4 28          	add    $0x28,%rsp
  803103:	5b                   	pop    %rbx
  803104:	5d                   	pop    %rbp
  803105:	c3                   	retq   

0000000000803106 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803106:	55                   	push   %rbp
  803107:	48 89 e5             	mov    %rsp,%rbp
  80310a:	48 83 ec 30          	sub    $0x30,%rsp
  80310e:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803111:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803115:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803118:	48 89 d6             	mov    %rdx,%rsi
  80311b:	89 c7                	mov    %eax,%edi
  80311d:	48 b8 f6 1d 80 00 00 	movabs $0x801df6,%rax
  803124:	00 00 00 
  803127:	ff d0                	callq  *%rax
  803129:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80312c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803130:	79 05                	jns    803137 <pipeisclosed+0x31>
		return r;
  803132:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803135:	eb 31                	jmp    803168 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803137:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80313b:	48 89 c7             	mov    %rax,%rdi
  80313e:	48 b8 33 1d 80 00 00 	movabs $0x801d33,%rax
  803145:	00 00 00 
  803148:	ff d0                	callq  *%rax
  80314a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80314e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803152:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803156:	48 89 d6             	mov    %rdx,%rsi
  803159:	48 89 c7             	mov    %rax,%rdi
  80315c:	48 b8 33 30 80 00 00 	movabs $0x803033,%rax
  803163:	00 00 00 
  803166:	ff d0                	callq  *%rax
}
  803168:	c9                   	leaveq 
  803169:	c3                   	retq   

000000000080316a <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80316a:	55                   	push   %rbp
  80316b:	48 89 e5             	mov    %rsp,%rbp
  80316e:	48 83 ec 40          	sub    $0x40,%rsp
  803172:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803176:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80317a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80317e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803182:	48 89 c7             	mov    %rax,%rdi
  803185:	48 b8 33 1d 80 00 00 	movabs $0x801d33,%rax
  80318c:	00 00 00 
  80318f:	ff d0                	callq  *%rax
  803191:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803195:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803199:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80319d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8031a4:	00 
  8031a5:	e9 92 00 00 00       	jmpq   80323c <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8031aa:	eb 41                	jmp    8031ed <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8031ac:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8031b1:	74 09                	je     8031bc <devpipe_read+0x52>
				return i;
  8031b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031b7:	e9 92 00 00 00       	jmpq   80324e <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8031bc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8031c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031c4:	48 89 d6             	mov    %rdx,%rsi
  8031c7:	48 89 c7             	mov    %rax,%rdi
  8031ca:	48 b8 33 30 80 00 00 	movabs $0x803033,%rax
  8031d1:	00 00 00 
  8031d4:	ff d0                	callq  *%rax
  8031d6:	85 c0                	test   %eax,%eax
  8031d8:	74 07                	je     8031e1 <devpipe_read+0x77>
				return 0;
  8031da:	b8 00 00 00 00       	mov    $0x0,%eax
  8031df:	eb 6d                	jmp    80324e <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8031e1:	48 b8 65 1a 80 00 00 	movabs $0x801a65,%rax
  8031e8:	00 00 00 
  8031eb:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8031ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031f1:	8b 10                	mov    (%rax),%edx
  8031f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031f7:	8b 40 04             	mov    0x4(%rax),%eax
  8031fa:	39 c2                	cmp    %eax,%edx
  8031fc:	74 ae                	je     8031ac <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8031fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803202:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803206:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80320a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80320e:	8b 00                	mov    (%rax),%eax
  803210:	99                   	cltd   
  803211:	c1 ea 1b             	shr    $0x1b,%edx
  803214:	01 d0                	add    %edx,%eax
  803216:	83 e0 1f             	and    $0x1f,%eax
  803219:	29 d0                	sub    %edx,%eax
  80321b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80321f:	48 98                	cltq   
  803221:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803226:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803228:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80322c:	8b 00                	mov    (%rax),%eax
  80322e:	8d 50 01             	lea    0x1(%rax),%edx
  803231:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803235:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803237:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80323c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803240:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803244:	0f 82 60 ff ff ff    	jb     8031aa <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80324a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80324e:	c9                   	leaveq 
  80324f:	c3                   	retq   

0000000000803250 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803250:	55                   	push   %rbp
  803251:	48 89 e5             	mov    %rsp,%rbp
  803254:	48 83 ec 40          	sub    $0x40,%rsp
  803258:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80325c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803260:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803264:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803268:	48 89 c7             	mov    %rax,%rdi
  80326b:	48 b8 33 1d 80 00 00 	movabs $0x801d33,%rax
  803272:	00 00 00 
  803275:	ff d0                	callq  *%rax
  803277:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80327b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80327f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803283:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80328a:	00 
  80328b:	e9 8e 00 00 00       	jmpq   80331e <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803290:	eb 31                	jmp    8032c3 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803292:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803296:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80329a:	48 89 d6             	mov    %rdx,%rsi
  80329d:	48 89 c7             	mov    %rax,%rdi
  8032a0:	48 b8 33 30 80 00 00 	movabs $0x803033,%rax
  8032a7:	00 00 00 
  8032aa:	ff d0                	callq  *%rax
  8032ac:	85 c0                	test   %eax,%eax
  8032ae:	74 07                	je     8032b7 <devpipe_write+0x67>
				return 0;
  8032b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8032b5:	eb 79                	jmp    803330 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8032b7:	48 b8 65 1a 80 00 00 	movabs $0x801a65,%rax
  8032be:	00 00 00 
  8032c1:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8032c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032c7:	8b 40 04             	mov    0x4(%rax),%eax
  8032ca:	48 63 d0             	movslq %eax,%rdx
  8032cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032d1:	8b 00                	mov    (%rax),%eax
  8032d3:	48 98                	cltq   
  8032d5:	48 83 c0 20          	add    $0x20,%rax
  8032d9:	48 39 c2             	cmp    %rax,%rdx
  8032dc:	73 b4                	jae    803292 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8032de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032e2:	8b 40 04             	mov    0x4(%rax),%eax
  8032e5:	99                   	cltd   
  8032e6:	c1 ea 1b             	shr    $0x1b,%edx
  8032e9:	01 d0                	add    %edx,%eax
  8032eb:	83 e0 1f             	and    $0x1f,%eax
  8032ee:	29 d0                	sub    %edx,%eax
  8032f0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8032f4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8032f8:	48 01 ca             	add    %rcx,%rdx
  8032fb:	0f b6 0a             	movzbl (%rdx),%ecx
  8032fe:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803302:	48 98                	cltq   
  803304:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803308:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80330c:	8b 40 04             	mov    0x4(%rax),%eax
  80330f:	8d 50 01             	lea    0x1(%rax),%edx
  803312:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803316:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803319:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80331e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803322:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803326:	0f 82 64 ff ff ff    	jb     803290 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80332c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803330:	c9                   	leaveq 
  803331:	c3                   	retq   

0000000000803332 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803332:	55                   	push   %rbp
  803333:	48 89 e5             	mov    %rsp,%rbp
  803336:	48 83 ec 20          	sub    $0x20,%rsp
  80333a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80333e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803342:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803346:	48 89 c7             	mov    %rax,%rdi
  803349:	48 b8 33 1d 80 00 00 	movabs $0x801d33,%rax
  803350:	00 00 00 
  803353:	ff d0                	callq  *%rax
  803355:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803359:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80335d:	48 be 62 3f 80 00 00 	movabs $0x803f62,%rsi
  803364:	00 00 00 
  803367:	48 89 c7             	mov    %rax,%rdi
  80336a:	48 b8 74 11 80 00 00 	movabs $0x801174,%rax
  803371:	00 00 00 
  803374:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803376:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80337a:	8b 50 04             	mov    0x4(%rax),%edx
  80337d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803381:	8b 00                	mov    (%rax),%eax
  803383:	29 c2                	sub    %eax,%edx
  803385:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803389:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80338f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803393:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80339a:	00 00 00 
	stat->st_dev = &devpipe;
  80339d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033a1:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  8033a8:	00 00 00 
  8033ab:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8033b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033b7:	c9                   	leaveq 
  8033b8:	c3                   	retq   

00000000008033b9 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8033b9:	55                   	push   %rbp
  8033ba:	48 89 e5             	mov    %rsp,%rbp
  8033bd:	48 83 ec 10          	sub    $0x10,%rsp
  8033c1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8033c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033c9:	48 89 c6             	mov    %rax,%rsi
  8033cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8033d1:	48 b8 4e 1b 80 00 00 	movabs $0x801b4e,%rax
  8033d8:	00 00 00 
  8033db:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8033dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033e1:	48 89 c7             	mov    %rax,%rdi
  8033e4:	48 b8 33 1d 80 00 00 	movabs $0x801d33,%rax
  8033eb:	00 00 00 
  8033ee:	ff d0                	callq  *%rax
  8033f0:	48 89 c6             	mov    %rax,%rsi
  8033f3:	bf 00 00 00 00       	mov    $0x0,%edi
  8033f8:	48 b8 4e 1b 80 00 00 	movabs $0x801b4e,%rax
  8033ff:	00 00 00 
  803402:	ff d0                	callq  *%rax
}
  803404:	c9                   	leaveq 
  803405:	c3                   	retq   

0000000000803406 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803406:	55                   	push   %rbp
  803407:	48 89 e5             	mov    %rsp,%rbp
  80340a:	48 83 ec 20          	sub    $0x20,%rsp
  80340e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803411:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803414:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803417:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80341b:	be 01 00 00 00       	mov    $0x1,%esi
  803420:	48 89 c7             	mov    %rax,%rdi
  803423:	48 b8 5b 19 80 00 00 	movabs $0x80195b,%rax
  80342a:	00 00 00 
  80342d:	ff d0                	callq  *%rax
}
  80342f:	c9                   	leaveq 
  803430:	c3                   	retq   

0000000000803431 <getchar>:

int
getchar(void)
{
  803431:	55                   	push   %rbp
  803432:	48 89 e5             	mov    %rsp,%rbp
  803435:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803439:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80343d:	ba 01 00 00 00       	mov    $0x1,%edx
  803442:	48 89 c6             	mov    %rax,%rsi
  803445:	bf 00 00 00 00       	mov    $0x0,%edi
  80344a:	48 b8 28 22 80 00 00 	movabs $0x802228,%rax
  803451:	00 00 00 
  803454:	ff d0                	callq  *%rax
  803456:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803459:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80345d:	79 05                	jns    803464 <getchar+0x33>
		return r;
  80345f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803462:	eb 14                	jmp    803478 <getchar+0x47>
	if (r < 1)
  803464:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803468:	7f 07                	jg     803471 <getchar+0x40>
		return -E_EOF;
  80346a:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80346f:	eb 07                	jmp    803478 <getchar+0x47>
	return c;
  803471:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803475:	0f b6 c0             	movzbl %al,%eax
}
  803478:	c9                   	leaveq 
  803479:	c3                   	retq   

000000000080347a <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80347a:	55                   	push   %rbp
  80347b:	48 89 e5             	mov    %rsp,%rbp
  80347e:	48 83 ec 20          	sub    $0x20,%rsp
  803482:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803485:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803489:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80348c:	48 89 d6             	mov    %rdx,%rsi
  80348f:	89 c7                	mov    %eax,%edi
  803491:	48 b8 f6 1d 80 00 00 	movabs $0x801df6,%rax
  803498:	00 00 00 
  80349b:	ff d0                	callq  *%rax
  80349d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034a4:	79 05                	jns    8034ab <iscons+0x31>
		return r;
  8034a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034a9:	eb 1a                	jmp    8034c5 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8034ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034af:	8b 10                	mov    (%rax),%edx
  8034b1:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  8034b8:	00 00 00 
  8034bb:	8b 00                	mov    (%rax),%eax
  8034bd:	39 c2                	cmp    %eax,%edx
  8034bf:	0f 94 c0             	sete   %al
  8034c2:	0f b6 c0             	movzbl %al,%eax
}
  8034c5:	c9                   	leaveq 
  8034c6:	c3                   	retq   

00000000008034c7 <opencons>:

int
opencons(void)
{
  8034c7:	55                   	push   %rbp
  8034c8:	48 89 e5             	mov    %rsp,%rbp
  8034cb:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8034cf:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8034d3:	48 89 c7             	mov    %rax,%rdi
  8034d6:	48 b8 5e 1d 80 00 00 	movabs $0x801d5e,%rax
  8034dd:	00 00 00 
  8034e0:	ff d0                	callq  *%rax
  8034e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034e9:	79 05                	jns    8034f0 <opencons+0x29>
		return r;
  8034eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034ee:	eb 5b                	jmp    80354b <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8034f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034f4:	ba 07 04 00 00       	mov    $0x407,%edx
  8034f9:	48 89 c6             	mov    %rax,%rsi
  8034fc:	bf 00 00 00 00       	mov    $0x0,%edi
  803501:	48 b8 a3 1a 80 00 00 	movabs $0x801aa3,%rax
  803508:	00 00 00 
  80350b:	ff d0                	callq  *%rax
  80350d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803510:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803514:	79 05                	jns    80351b <opencons+0x54>
		return r;
  803516:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803519:	eb 30                	jmp    80354b <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80351b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80351f:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  803526:	00 00 00 
  803529:	8b 12                	mov    (%rdx),%edx
  80352b:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80352d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803531:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803538:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80353c:	48 89 c7             	mov    %rax,%rdi
  80353f:	48 b8 10 1d 80 00 00 	movabs $0x801d10,%rax
  803546:	00 00 00 
  803549:	ff d0                	callq  *%rax
}
  80354b:	c9                   	leaveq 
  80354c:	c3                   	retq   

000000000080354d <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80354d:	55                   	push   %rbp
  80354e:	48 89 e5             	mov    %rsp,%rbp
  803551:	48 83 ec 30          	sub    $0x30,%rsp
  803555:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803559:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80355d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803561:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803566:	75 07                	jne    80356f <devcons_read+0x22>
		return 0;
  803568:	b8 00 00 00 00       	mov    $0x0,%eax
  80356d:	eb 4b                	jmp    8035ba <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  80356f:	eb 0c                	jmp    80357d <devcons_read+0x30>
		sys_yield();
  803571:	48 b8 65 1a 80 00 00 	movabs $0x801a65,%rax
  803578:	00 00 00 
  80357b:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80357d:	48 b8 a5 19 80 00 00 	movabs $0x8019a5,%rax
  803584:	00 00 00 
  803587:	ff d0                	callq  *%rax
  803589:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80358c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803590:	74 df                	je     803571 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803592:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803596:	79 05                	jns    80359d <devcons_read+0x50>
		return c;
  803598:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80359b:	eb 1d                	jmp    8035ba <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80359d:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8035a1:	75 07                	jne    8035aa <devcons_read+0x5d>
		return 0;
  8035a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8035a8:	eb 10                	jmp    8035ba <devcons_read+0x6d>
	*(char*)vbuf = c;
  8035aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035ad:	89 c2                	mov    %eax,%edx
  8035af:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035b3:	88 10                	mov    %dl,(%rax)
	return 1;
  8035b5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8035ba:	c9                   	leaveq 
  8035bb:	c3                   	retq   

00000000008035bc <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8035bc:	55                   	push   %rbp
  8035bd:	48 89 e5             	mov    %rsp,%rbp
  8035c0:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8035c7:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8035ce:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8035d5:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8035dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8035e3:	eb 76                	jmp    80365b <devcons_write+0x9f>
		m = n - tot;
  8035e5:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8035ec:	89 c2                	mov    %eax,%edx
  8035ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035f1:	29 c2                	sub    %eax,%edx
  8035f3:	89 d0                	mov    %edx,%eax
  8035f5:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8035f8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035fb:	83 f8 7f             	cmp    $0x7f,%eax
  8035fe:	76 07                	jbe    803607 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803600:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803607:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80360a:	48 63 d0             	movslq %eax,%rdx
  80360d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803610:	48 63 c8             	movslq %eax,%rcx
  803613:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80361a:	48 01 c1             	add    %rax,%rcx
  80361d:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803624:	48 89 ce             	mov    %rcx,%rsi
  803627:	48 89 c7             	mov    %rax,%rdi
  80362a:	48 b8 98 14 80 00 00 	movabs $0x801498,%rax
  803631:	00 00 00 
  803634:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803636:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803639:	48 63 d0             	movslq %eax,%rdx
  80363c:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803643:	48 89 d6             	mov    %rdx,%rsi
  803646:	48 89 c7             	mov    %rax,%rdi
  803649:	48 b8 5b 19 80 00 00 	movabs $0x80195b,%rax
  803650:	00 00 00 
  803653:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803655:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803658:	01 45 fc             	add    %eax,-0x4(%rbp)
  80365b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80365e:	48 98                	cltq   
  803660:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803667:	0f 82 78 ff ff ff    	jb     8035e5 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80366d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803670:	c9                   	leaveq 
  803671:	c3                   	retq   

0000000000803672 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803672:	55                   	push   %rbp
  803673:	48 89 e5             	mov    %rsp,%rbp
  803676:	48 83 ec 08          	sub    $0x8,%rsp
  80367a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80367e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803683:	c9                   	leaveq 
  803684:	c3                   	retq   

0000000000803685 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803685:	55                   	push   %rbp
  803686:	48 89 e5             	mov    %rsp,%rbp
  803689:	48 83 ec 10          	sub    $0x10,%rsp
  80368d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803691:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803695:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803699:	48 be 6e 3f 80 00 00 	movabs $0x803f6e,%rsi
  8036a0:	00 00 00 
  8036a3:	48 89 c7             	mov    %rax,%rdi
  8036a6:	48 b8 74 11 80 00 00 	movabs $0x801174,%rax
  8036ad:	00 00 00 
  8036b0:	ff d0                	callq  *%rax
	return 0;
  8036b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8036b7:	c9                   	leaveq 
  8036b8:	c3                   	retq   

00000000008036b9 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8036b9:	55                   	push   %rbp
  8036ba:	48 89 e5             	mov    %rsp,%rbp
  8036bd:	48 83 ec 30          	sub    $0x30,%rsp
  8036c1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8036c5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8036c9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  8036cd:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8036d4:	00 00 00 
  8036d7:	48 8b 00             	mov    (%rax),%rax
  8036da:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8036e0:	85 c0                	test   %eax,%eax
  8036e2:	75 3c                	jne    803720 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  8036e4:	48 b8 27 1a 80 00 00 	movabs $0x801a27,%rax
  8036eb:	00 00 00 
  8036ee:	ff d0                	callq  *%rax
  8036f0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8036f5:	48 63 d0             	movslq %eax,%rdx
  8036f8:	48 89 d0             	mov    %rdx,%rax
  8036fb:	48 c1 e0 03          	shl    $0x3,%rax
  8036ff:	48 01 d0             	add    %rdx,%rax
  803702:	48 c1 e0 05          	shl    $0x5,%rax
  803706:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80370d:	00 00 00 
  803710:	48 01 c2             	add    %rax,%rdx
  803713:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80371a:	00 00 00 
  80371d:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803720:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803725:	75 0e                	jne    803735 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  803727:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80372e:	00 00 00 
  803731:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803735:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803739:	48 89 c7             	mov    %rax,%rdi
  80373c:	48 b8 cc 1c 80 00 00 	movabs $0x801ccc,%rax
  803743:	00 00 00 
  803746:	ff d0                	callq  *%rax
  803748:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  80374b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80374f:	79 19                	jns    80376a <ipc_recv+0xb1>
		*from_env_store = 0;
  803751:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803755:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  80375b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80375f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803765:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803768:	eb 53                	jmp    8037bd <ipc_recv+0x104>
	}
	if(from_env_store)
  80376a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80376f:	74 19                	je     80378a <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  803771:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803778:	00 00 00 
  80377b:	48 8b 00             	mov    (%rax),%rax
  80377e:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803784:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803788:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  80378a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80378f:	74 19                	je     8037aa <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  803791:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803798:	00 00 00 
  80379b:	48 8b 00             	mov    (%rax),%rax
  80379e:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8037a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037a8:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  8037aa:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8037b1:	00 00 00 
  8037b4:	48 8b 00             	mov    (%rax),%rax
  8037b7:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  8037bd:	c9                   	leaveq 
  8037be:	c3                   	retq   

00000000008037bf <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8037bf:	55                   	push   %rbp
  8037c0:	48 89 e5             	mov    %rsp,%rbp
  8037c3:	48 83 ec 30          	sub    $0x30,%rsp
  8037c7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8037ca:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8037cd:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8037d1:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  8037d4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8037d9:	75 0e                	jne    8037e9 <ipc_send+0x2a>
		pg = (void*)UTOP;
  8037db:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8037e2:	00 00 00 
  8037e5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  8037e9:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8037ec:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8037ef:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8037f3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037f6:	89 c7                	mov    %eax,%edi
  8037f8:	48 b8 77 1c 80 00 00 	movabs $0x801c77,%rax
  8037ff:	00 00 00 
  803802:	ff d0                	callq  *%rax
  803804:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  803807:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80380b:	75 0c                	jne    803819 <ipc_send+0x5a>
			sys_yield();
  80380d:	48 b8 65 1a 80 00 00 	movabs $0x801a65,%rax
  803814:	00 00 00 
  803817:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  803819:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80381d:	74 ca                	je     8037e9 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  80381f:	c9                   	leaveq 
  803820:	c3                   	retq   

0000000000803821 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803821:	55                   	push   %rbp
  803822:	48 89 e5             	mov    %rsp,%rbp
  803825:	48 83 ec 14          	sub    $0x14,%rsp
  803829:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  80382c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803833:	eb 5e                	jmp    803893 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803835:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80383c:	00 00 00 
  80383f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803842:	48 63 d0             	movslq %eax,%rdx
  803845:	48 89 d0             	mov    %rdx,%rax
  803848:	48 c1 e0 03          	shl    $0x3,%rax
  80384c:	48 01 d0             	add    %rdx,%rax
  80384f:	48 c1 e0 05          	shl    $0x5,%rax
  803853:	48 01 c8             	add    %rcx,%rax
  803856:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80385c:	8b 00                	mov    (%rax),%eax
  80385e:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803861:	75 2c                	jne    80388f <ipc_find_env+0x6e>
			return envs[i].env_id;
  803863:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80386a:	00 00 00 
  80386d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803870:	48 63 d0             	movslq %eax,%rdx
  803873:	48 89 d0             	mov    %rdx,%rax
  803876:	48 c1 e0 03          	shl    $0x3,%rax
  80387a:	48 01 d0             	add    %rdx,%rax
  80387d:	48 c1 e0 05          	shl    $0x5,%rax
  803881:	48 01 c8             	add    %rcx,%rax
  803884:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80388a:	8b 40 08             	mov    0x8(%rax),%eax
  80388d:	eb 12                	jmp    8038a1 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80388f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803893:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80389a:	7e 99                	jle    803835 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  80389c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8038a1:	c9                   	leaveq 
  8038a2:	c3                   	retq   

00000000008038a3 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8038a3:	55                   	push   %rbp
  8038a4:	48 89 e5             	mov    %rsp,%rbp
  8038a7:	48 83 ec 18          	sub    $0x18,%rsp
  8038ab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8038af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038b3:	48 c1 e8 15          	shr    $0x15,%rax
  8038b7:	48 89 c2             	mov    %rax,%rdx
  8038ba:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8038c1:	01 00 00 
  8038c4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8038c8:	83 e0 01             	and    $0x1,%eax
  8038cb:	48 85 c0             	test   %rax,%rax
  8038ce:	75 07                	jne    8038d7 <pageref+0x34>
		return 0;
  8038d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8038d5:	eb 53                	jmp    80392a <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8038d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038db:	48 c1 e8 0c          	shr    $0xc,%rax
  8038df:	48 89 c2             	mov    %rax,%rdx
  8038e2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8038e9:	01 00 00 
  8038ec:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8038f0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8038f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038f8:	83 e0 01             	and    $0x1,%eax
  8038fb:	48 85 c0             	test   %rax,%rax
  8038fe:	75 07                	jne    803907 <pageref+0x64>
		return 0;
  803900:	b8 00 00 00 00       	mov    $0x0,%eax
  803905:	eb 23                	jmp    80392a <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803907:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80390b:	48 c1 e8 0c          	shr    $0xc,%rax
  80390f:	48 89 c2             	mov    %rax,%rdx
  803912:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803919:	00 00 00 
  80391c:	48 c1 e2 04          	shl    $0x4,%rdx
  803920:	48 01 d0             	add    %rdx,%rax
  803923:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803927:	0f b7 c0             	movzwl %ax,%eax
}
  80392a:	c9                   	leaveq 
  80392b:	c3                   	retq   
