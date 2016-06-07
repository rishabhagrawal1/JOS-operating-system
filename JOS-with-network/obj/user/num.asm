
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
  800057:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80005e:	00 00 00 
  800061:	8b 00                	mov    (%rax),%eax
  800063:	85 c0                	test   %eax,%eax
  800065:	74 54                	je     8000bb <num+0x78>
			printf("%5d ", ++line);
  800067:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80006e:	00 00 00 
  800071:	8b 00                	mov    (%rax),%eax
  800073:	8d 50 01             	lea    0x1(%rax),%edx
  800076:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80007d:	00 00 00 
  800080:	89 10                	mov    %edx,(%rax)
  800082:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800089:	00 00 00 
  80008c:	8b 00                	mov    (%rax),%eax
  80008e:	89 c6                	mov    %eax,%esi
  800090:	48 bf e0 43 80 00 00 	movabs $0x8043e0,%rdi
  800097:	00 00 00 
  80009a:	b8 00 00 00 00       	mov    $0x0,%eax
  80009f:	48 ba 2c 30 80 00 00 	movabs $0x80302c,%rdx
  8000a6:	00 00 00 
  8000a9:	ff d2                	callq  *%rdx
			bol = 0;
  8000ab:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8000b2:	00 00 00 
  8000b5:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		}
		if ((r = write(1, &c, 1)) != 1)
  8000bb:	48 8d 45 f3          	lea    -0xd(%rbp),%rax
  8000bf:	ba 01 00 00 00       	mov    $0x1,%edx
  8000c4:	48 89 c6             	mov    %rax,%rsi
  8000c7:	bf 01 00 00 00       	mov    $0x1,%edi
  8000cc:	48 b8 3c 24 80 00 00 	movabs $0x80243c,%rax
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
  8000ee:	48 ba e5 43 80 00 00 	movabs $0x8043e5,%rdx
  8000f5:	00 00 00 
  8000f8:	be 13 00 00 00       	mov    $0x13,%esi
  8000fd:	48 bf 00 44 80 00 00 	movabs $0x804400,%rdi
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
  800121:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
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
  800142:	48 b8 f2 22 80 00 00 	movabs $0x8022f2,%rax
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
  800174:	48 ba 0b 44 80 00 00 	movabs $0x80440b,%rdx
  80017b:	00 00 00 
  80017e:	be 18 00 00 00       	mov    $0x18,%esi
  800183:	48 bf 00 44 80 00 00 	movabs $0x804400,%rdi
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
  8001b1:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8001b8:	00 00 00 
  8001bb:	48 bb 20 44 80 00 00 	movabs $0x804420,%rbx
  8001c2:	00 00 00 
  8001c5:	48 89 18             	mov    %rbx,(%rax)
	if (argc == 1)
  8001c8:	83 7d dc 01          	cmpl   $0x1,-0x24(%rbp)
  8001cc:	75 20                	jne    8001ee <umain+0x4d>
		num(0, "<stdin>");
  8001ce:	48 be 24 44 80 00 00 	movabs $0x804424,%rsi
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
  800219:	48 b8 c8 27 80 00 00 	movabs $0x8027c8,%rax
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
  80024e:	48 ba 2c 44 80 00 00 	movabs $0x80442c,%rdx
  800255:	00 00 00 
  800258:	be 27 00 00 00       	mov    $0x27,%esi
  80025d:	48 bf 00 44 80 00 00 	movabs $0x804400,%rdi
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
  8002a9:	48 b8 d0 20 80 00 00 	movabs $0x8020d0,%rax
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
  800316:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
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
  800330:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
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
  800367:	48 b8 1b 21 80 00 00 	movabs $0x80211b,%rax
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
  80040f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
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
  800440:	48 bf 48 44 80 00 00 	movabs $0x804448,%rdi
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
  80047c:	48 bf 6b 44 80 00 00 	movabs $0x80446b,%rdi
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
  80072b:	48 ba 70 46 80 00 00 	movabs $0x804670,%rdx
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
  800a23:	48 b8 98 46 80 00 00 	movabs $0x804698,%rax
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
  800b71:	83 fb 15             	cmp    $0x15,%ebx
  800b74:	7f 16                	jg     800b8c <vprintfmt+0x21a>
  800b76:	48 b8 c0 45 80 00 00 	movabs $0x8045c0,%rax
  800b7d:	00 00 00 
  800b80:	48 63 d3             	movslq %ebx,%rdx
  800b83:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800b87:	4d 85 e4             	test   %r12,%r12
  800b8a:	75 2e                	jne    800bba <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800b8c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b90:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b94:	89 d9                	mov    %ebx,%ecx
  800b96:	48 ba 81 46 80 00 00 	movabs $0x804681,%rdx
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
  800bc5:	48 ba 8a 46 80 00 00 	movabs $0x80468a,%rdx
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
  800c1f:	49 bc 8d 46 80 00 00 	movabs $0x80468d,%r12
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
  801925:	48 ba 48 49 80 00 00 	movabs $0x804948,%rdx
  80192c:	00 00 00 
  80192f:	be 23 00 00 00       	mov    $0x23,%esi
  801934:	48 bf 65 49 80 00 00 	movabs $0x804965,%rdi
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

0000000000801d10 <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801d10:	55                   	push   %rbp
  801d11:	48 89 e5             	mov    %rsp,%rbp
  801d14:	48 83 ec 20          	sub    $0x20,%rsp
  801d18:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d1c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, (uint64_t)buf, len, 0, 0, 0, 0);
  801d20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d24:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d28:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d2f:	00 
  801d30:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d36:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d3c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d41:	89 c6                	mov    %eax,%esi
  801d43:	bf 0f 00 00 00       	mov    $0xf,%edi
  801d48:	48 b8 cd 18 80 00 00 	movabs $0x8018cd,%rax
  801d4f:	00 00 00 
  801d52:	ff d0                	callq  *%rax
}
  801d54:	c9                   	leaveq 
  801d55:	c3                   	retq   

0000000000801d56 <sys_net_rx>:

int
sys_net_rx(void *buf, size_t len)
{
  801d56:	55                   	push   %rbp
  801d57:	48 89 e5             	mov    %rsp,%rbp
  801d5a:	48 83 ec 20          	sub    $0x20,%rsp
  801d5e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d62:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_rx, (uint64_t)buf, len, 0, 0, 0, 0);
  801d66:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d6a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d6e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d75:	00 
  801d76:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d7c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d82:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d87:	89 c6                	mov    %eax,%esi
  801d89:	bf 10 00 00 00       	mov    $0x10,%edi
  801d8e:	48 b8 cd 18 80 00 00 	movabs $0x8018cd,%rax
  801d95:	00 00 00 
  801d98:	ff d0                	callq  *%rax
}
  801d9a:	c9                   	leaveq 
  801d9b:	c3                   	retq   

0000000000801d9c <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801d9c:	55                   	push   %rbp
  801d9d:	48 89 e5             	mov    %rsp,%rbp
  801da0:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801da4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dab:	00 
  801dac:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801db2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801db8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801dbd:	ba 00 00 00 00       	mov    $0x0,%edx
  801dc2:	be 00 00 00 00       	mov    $0x0,%esi
  801dc7:	bf 0e 00 00 00       	mov    $0xe,%edi
  801dcc:	48 b8 cd 18 80 00 00 	movabs $0x8018cd,%rax
  801dd3:	00 00 00 
  801dd6:	ff d0                	callq  *%rax
}
  801dd8:	c9                   	leaveq 
  801dd9:	c3                   	retq   

0000000000801dda <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801dda:	55                   	push   %rbp
  801ddb:	48 89 e5             	mov    %rsp,%rbp
  801dde:	48 83 ec 08          	sub    $0x8,%rsp
  801de2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801de6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801dea:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801df1:	ff ff ff 
  801df4:	48 01 d0             	add    %rdx,%rax
  801df7:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801dfb:	c9                   	leaveq 
  801dfc:	c3                   	retq   

0000000000801dfd <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801dfd:	55                   	push   %rbp
  801dfe:	48 89 e5             	mov    %rsp,%rbp
  801e01:	48 83 ec 08          	sub    $0x8,%rsp
  801e05:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801e09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e0d:	48 89 c7             	mov    %rax,%rdi
  801e10:	48 b8 da 1d 80 00 00 	movabs $0x801dda,%rax
  801e17:	00 00 00 
  801e1a:	ff d0                	callq  *%rax
  801e1c:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801e22:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801e26:	c9                   	leaveq 
  801e27:	c3                   	retq   

0000000000801e28 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801e28:	55                   	push   %rbp
  801e29:	48 89 e5             	mov    %rsp,%rbp
  801e2c:	48 83 ec 18          	sub    $0x18,%rsp
  801e30:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e34:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e3b:	eb 6b                	jmp    801ea8 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801e3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e40:	48 98                	cltq   
  801e42:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e48:	48 c1 e0 0c          	shl    $0xc,%rax
  801e4c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801e50:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e54:	48 c1 e8 15          	shr    $0x15,%rax
  801e58:	48 89 c2             	mov    %rax,%rdx
  801e5b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e62:	01 00 00 
  801e65:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e69:	83 e0 01             	and    $0x1,%eax
  801e6c:	48 85 c0             	test   %rax,%rax
  801e6f:	74 21                	je     801e92 <fd_alloc+0x6a>
  801e71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e75:	48 c1 e8 0c          	shr    $0xc,%rax
  801e79:	48 89 c2             	mov    %rax,%rdx
  801e7c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e83:	01 00 00 
  801e86:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e8a:	83 e0 01             	and    $0x1,%eax
  801e8d:	48 85 c0             	test   %rax,%rax
  801e90:	75 12                	jne    801ea4 <fd_alloc+0x7c>
			*fd_store = fd;
  801e92:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e96:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e9a:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801e9d:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea2:	eb 1a                	jmp    801ebe <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801ea4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801ea8:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801eac:	7e 8f                	jle    801e3d <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801eae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801eb2:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801eb9:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801ebe:	c9                   	leaveq 
  801ebf:	c3                   	retq   

0000000000801ec0 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801ec0:	55                   	push   %rbp
  801ec1:	48 89 e5             	mov    %rsp,%rbp
  801ec4:	48 83 ec 20          	sub    $0x20,%rsp
  801ec8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801ecb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801ecf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801ed3:	78 06                	js     801edb <fd_lookup+0x1b>
  801ed5:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801ed9:	7e 07                	jle    801ee2 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801edb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ee0:	eb 6c                	jmp    801f4e <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801ee2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ee5:	48 98                	cltq   
  801ee7:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801eed:	48 c1 e0 0c          	shl    $0xc,%rax
  801ef1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801ef5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ef9:	48 c1 e8 15          	shr    $0x15,%rax
  801efd:	48 89 c2             	mov    %rax,%rdx
  801f00:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f07:	01 00 00 
  801f0a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f0e:	83 e0 01             	and    $0x1,%eax
  801f11:	48 85 c0             	test   %rax,%rax
  801f14:	74 21                	je     801f37 <fd_lookup+0x77>
  801f16:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f1a:	48 c1 e8 0c          	shr    $0xc,%rax
  801f1e:	48 89 c2             	mov    %rax,%rdx
  801f21:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f28:	01 00 00 
  801f2b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f2f:	83 e0 01             	and    $0x1,%eax
  801f32:	48 85 c0             	test   %rax,%rax
  801f35:	75 07                	jne    801f3e <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f37:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f3c:	eb 10                	jmp    801f4e <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801f3e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f42:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f46:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801f49:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f4e:	c9                   	leaveq 
  801f4f:	c3                   	retq   

0000000000801f50 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801f50:	55                   	push   %rbp
  801f51:	48 89 e5             	mov    %rsp,%rbp
  801f54:	48 83 ec 30          	sub    $0x30,%rsp
  801f58:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801f5c:	89 f0                	mov    %esi,%eax
  801f5e:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801f61:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f65:	48 89 c7             	mov    %rax,%rdi
  801f68:	48 b8 da 1d 80 00 00 	movabs $0x801dda,%rax
  801f6f:	00 00 00 
  801f72:	ff d0                	callq  *%rax
  801f74:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f78:	48 89 d6             	mov    %rdx,%rsi
  801f7b:	89 c7                	mov    %eax,%edi
  801f7d:	48 b8 c0 1e 80 00 00 	movabs $0x801ec0,%rax
  801f84:	00 00 00 
  801f87:	ff d0                	callq  *%rax
  801f89:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f8c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f90:	78 0a                	js     801f9c <fd_close+0x4c>
	    || fd != fd2)
  801f92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f96:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801f9a:	74 12                	je     801fae <fd_close+0x5e>
		return (must_exist ? r : 0);
  801f9c:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801fa0:	74 05                	je     801fa7 <fd_close+0x57>
  801fa2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fa5:	eb 05                	jmp    801fac <fd_close+0x5c>
  801fa7:	b8 00 00 00 00       	mov    $0x0,%eax
  801fac:	eb 69                	jmp    802017 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801fae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fb2:	8b 00                	mov    (%rax),%eax
  801fb4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801fb8:	48 89 d6             	mov    %rdx,%rsi
  801fbb:	89 c7                	mov    %eax,%edi
  801fbd:	48 b8 19 20 80 00 00 	movabs $0x802019,%rax
  801fc4:	00 00 00 
  801fc7:	ff d0                	callq  *%rax
  801fc9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fcc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fd0:	78 2a                	js     801ffc <fd_close+0xac>
		if (dev->dev_close)
  801fd2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fd6:	48 8b 40 20          	mov    0x20(%rax),%rax
  801fda:	48 85 c0             	test   %rax,%rax
  801fdd:	74 16                	je     801ff5 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801fdf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fe3:	48 8b 40 20          	mov    0x20(%rax),%rax
  801fe7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801feb:	48 89 d7             	mov    %rdx,%rdi
  801fee:	ff d0                	callq  *%rax
  801ff0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ff3:	eb 07                	jmp    801ffc <fd_close+0xac>
		else
			r = 0;
  801ff5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801ffc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802000:	48 89 c6             	mov    %rax,%rsi
  802003:	bf 00 00 00 00       	mov    $0x0,%edi
  802008:	48 b8 4e 1b 80 00 00 	movabs $0x801b4e,%rax
  80200f:	00 00 00 
  802012:	ff d0                	callq  *%rax
	return r;
  802014:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802017:	c9                   	leaveq 
  802018:	c3                   	retq   

0000000000802019 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802019:	55                   	push   %rbp
  80201a:	48 89 e5             	mov    %rsp,%rbp
  80201d:	48 83 ec 20          	sub    $0x20,%rsp
  802021:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802024:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802028:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80202f:	eb 41                	jmp    802072 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802031:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802038:	00 00 00 
  80203b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80203e:	48 63 d2             	movslq %edx,%rdx
  802041:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802045:	8b 00                	mov    (%rax),%eax
  802047:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80204a:	75 22                	jne    80206e <dev_lookup+0x55>
			*dev = devtab[i];
  80204c:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802053:	00 00 00 
  802056:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802059:	48 63 d2             	movslq %edx,%rdx
  80205c:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802060:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802064:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802067:	b8 00 00 00 00       	mov    $0x0,%eax
  80206c:	eb 60                	jmp    8020ce <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80206e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802072:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802079:	00 00 00 
  80207c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80207f:	48 63 d2             	movslq %edx,%rdx
  802082:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802086:	48 85 c0             	test   %rax,%rax
  802089:	75 a6                	jne    802031 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80208b:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  802092:	00 00 00 
  802095:	48 8b 00             	mov    (%rax),%rax
  802098:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80209e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8020a1:	89 c6                	mov    %eax,%esi
  8020a3:	48 bf 78 49 80 00 00 	movabs $0x804978,%rdi
  8020aa:	00 00 00 
  8020ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b2:	48 b9 bf 05 80 00 00 	movabs $0x8005bf,%rcx
  8020b9:	00 00 00 
  8020bc:	ff d1                	callq  *%rcx
	*dev = 0;
  8020be:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020c2:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8020c9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8020ce:	c9                   	leaveq 
  8020cf:	c3                   	retq   

00000000008020d0 <close>:

int
close(int fdnum)
{
  8020d0:	55                   	push   %rbp
  8020d1:	48 89 e5             	mov    %rsp,%rbp
  8020d4:	48 83 ec 20          	sub    $0x20,%rsp
  8020d8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020db:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8020df:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020e2:	48 89 d6             	mov    %rdx,%rsi
  8020e5:	89 c7                	mov    %eax,%edi
  8020e7:	48 b8 c0 1e 80 00 00 	movabs $0x801ec0,%rax
  8020ee:	00 00 00 
  8020f1:	ff d0                	callq  *%rax
  8020f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020fa:	79 05                	jns    802101 <close+0x31>
		return r;
  8020fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020ff:	eb 18                	jmp    802119 <close+0x49>
	else
		return fd_close(fd, 1);
  802101:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802105:	be 01 00 00 00       	mov    $0x1,%esi
  80210a:	48 89 c7             	mov    %rax,%rdi
  80210d:	48 b8 50 1f 80 00 00 	movabs $0x801f50,%rax
  802114:	00 00 00 
  802117:	ff d0                	callq  *%rax
}
  802119:	c9                   	leaveq 
  80211a:	c3                   	retq   

000000000080211b <close_all>:

void
close_all(void)
{
  80211b:	55                   	push   %rbp
  80211c:	48 89 e5             	mov    %rsp,%rbp
  80211f:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802123:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80212a:	eb 15                	jmp    802141 <close_all+0x26>
		close(i);
  80212c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80212f:	89 c7                	mov    %eax,%edi
  802131:	48 b8 d0 20 80 00 00 	movabs $0x8020d0,%rax
  802138:	00 00 00 
  80213b:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80213d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802141:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802145:	7e e5                	jle    80212c <close_all+0x11>
		close(i);
}
  802147:	c9                   	leaveq 
  802148:	c3                   	retq   

0000000000802149 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802149:	55                   	push   %rbp
  80214a:	48 89 e5             	mov    %rsp,%rbp
  80214d:	48 83 ec 40          	sub    $0x40,%rsp
  802151:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802154:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802157:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80215b:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80215e:	48 89 d6             	mov    %rdx,%rsi
  802161:	89 c7                	mov    %eax,%edi
  802163:	48 b8 c0 1e 80 00 00 	movabs $0x801ec0,%rax
  80216a:	00 00 00 
  80216d:	ff d0                	callq  *%rax
  80216f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802172:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802176:	79 08                	jns    802180 <dup+0x37>
		return r;
  802178:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80217b:	e9 70 01 00 00       	jmpq   8022f0 <dup+0x1a7>
	close(newfdnum);
  802180:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802183:	89 c7                	mov    %eax,%edi
  802185:	48 b8 d0 20 80 00 00 	movabs $0x8020d0,%rax
  80218c:	00 00 00 
  80218f:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802191:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802194:	48 98                	cltq   
  802196:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80219c:	48 c1 e0 0c          	shl    $0xc,%rax
  8021a0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8021a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021a8:	48 89 c7             	mov    %rax,%rdi
  8021ab:	48 b8 fd 1d 80 00 00 	movabs $0x801dfd,%rax
  8021b2:	00 00 00 
  8021b5:	ff d0                	callq  *%rax
  8021b7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8021bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021bf:	48 89 c7             	mov    %rax,%rdi
  8021c2:	48 b8 fd 1d 80 00 00 	movabs $0x801dfd,%rax
  8021c9:	00 00 00 
  8021cc:	ff d0                	callq  *%rax
  8021ce:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8021d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021d6:	48 c1 e8 15          	shr    $0x15,%rax
  8021da:	48 89 c2             	mov    %rax,%rdx
  8021dd:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021e4:	01 00 00 
  8021e7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021eb:	83 e0 01             	and    $0x1,%eax
  8021ee:	48 85 c0             	test   %rax,%rax
  8021f1:	74 73                	je     802266 <dup+0x11d>
  8021f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021f7:	48 c1 e8 0c          	shr    $0xc,%rax
  8021fb:	48 89 c2             	mov    %rax,%rdx
  8021fe:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802205:	01 00 00 
  802208:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80220c:	83 e0 01             	and    $0x1,%eax
  80220f:	48 85 c0             	test   %rax,%rax
  802212:	74 52                	je     802266 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802214:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802218:	48 c1 e8 0c          	shr    $0xc,%rax
  80221c:	48 89 c2             	mov    %rax,%rdx
  80221f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802226:	01 00 00 
  802229:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80222d:	25 07 0e 00 00       	and    $0xe07,%eax
  802232:	89 c1                	mov    %eax,%ecx
  802234:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802238:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80223c:	41 89 c8             	mov    %ecx,%r8d
  80223f:	48 89 d1             	mov    %rdx,%rcx
  802242:	ba 00 00 00 00       	mov    $0x0,%edx
  802247:	48 89 c6             	mov    %rax,%rsi
  80224a:	bf 00 00 00 00       	mov    $0x0,%edi
  80224f:	48 b8 f3 1a 80 00 00 	movabs $0x801af3,%rax
  802256:	00 00 00 
  802259:	ff d0                	callq  *%rax
  80225b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80225e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802262:	79 02                	jns    802266 <dup+0x11d>
			goto err;
  802264:	eb 57                	jmp    8022bd <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802266:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80226a:	48 c1 e8 0c          	shr    $0xc,%rax
  80226e:	48 89 c2             	mov    %rax,%rdx
  802271:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802278:	01 00 00 
  80227b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80227f:	25 07 0e 00 00       	and    $0xe07,%eax
  802284:	89 c1                	mov    %eax,%ecx
  802286:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80228a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80228e:	41 89 c8             	mov    %ecx,%r8d
  802291:	48 89 d1             	mov    %rdx,%rcx
  802294:	ba 00 00 00 00       	mov    $0x0,%edx
  802299:	48 89 c6             	mov    %rax,%rsi
  80229c:	bf 00 00 00 00       	mov    $0x0,%edi
  8022a1:	48 b8 f3 1a 80 00 00 	movabs $0x801af3,%rax
  8022a8:	00 00 00 
  8022ab:	ff d0                	callq  *%rax
  8022ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022b4:	79 02                	jns    8022b8 <dup+0x16f>
		goto err;
  8022b6:	eb 05                	jmp    8022bd <dup+0x174>

	return newfdnum;
  8022b8:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8022bb:	eb 33                	jmp    8022f0 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8022bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022c1:	48 89 c6             	mov    %rax,%rsi
  8022c4:	bf 00 00 00 00       	mov    $0x0,%edi
  8022c9:	48 b8 4e 1b 80 00 00 	movabs $0x801b4e,%rax
  8022d0:	00 00 00 
  8022d3:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8022d5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022d9:	48 89 c6             	mov    %rax,%rsi
  8022dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8022e1:	48 b8 4e 1b 80 00 00 	movabs $0x801b4e,%rax
  8022e8:	00 00 00 
  8022eb:	ff d0                	callq  *%rax
	return r;
  8022ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8022f0:	c9                   	leaveq 
  8022f1:	c3                   	retq   

00000000008022f2 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8022f2:	55                   	push   %rbp
  8022f3:	48 89 e5             	mov    %rsp,%rbp
  8022f6:	48 83 ec 40          	sub    $0x40,%rsp
  8022fa:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8022fd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802301:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802305:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802309:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80230c:	48 89 d6             	mov    %rdx,%rsi
  80230f:	89 c7                	mov    %eax,%edi
  802311:	48 b8 c0 1e 80 00 00 	movabs $0x801ec0,%rax
  802318:	00 00 00 
  80231b:	ff d0                	callq  *%rax
  80231d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802320:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802324:	78 24                	js     80234a <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802326:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80232a:	8b 00                	mov    (%rax),%eax
  80232c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802330:	48 89 d6             	mov    %rdx,%rsi
  802333:	89 c7                	mov    %eax,%edi
  802335:	48 b8 19 20 80 00 00 	movabs $0x802019,%rax
  80233c:	00 00 00 
  80233f:	ff d0                	callq  *%rax
  802341:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802344:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802348:	79 05                	jns    80234f <read+0x5d>
		return r;
  80234a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80234d:	eb 76                	jmp    8023c5 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80234f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802353:	8b 40 08             	mov    0x8(%rax),%eax
  802356:	83 e0 03             	and    $0x3,%eax
  802359:	83 f8 01             	cmp    $0x1,%eax
  80235c:	75 3a                	jne    802398 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80235e:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  802365:	00 00 00 
  802368:	48 8b 00             	mov    (%rax),%rax
  80236b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802371:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802374:	89 c6                	mov    %eax,%esi
  802376:	48 bf 97 49 80 00 00 	movabs $0x804997,%rdi
  80237d:	00 00 00 
  802380:	b8 00 00 00 00       	mov    $0x0,%eax
  802385:	48 b9 bf 05 80 00 00 	movabs $0x8005bf,%rcx
  80238c:	00 00 00 
  80238f:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802391:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802396:	eb 2d                	jmp    8023c5 <read+0xd3>
	}
	if (!dev->dev_read)
  802398:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80239c:	48 8b 40 10          	mov    0x10(%rax),%rax
  8023a0:	48 85 c0             	test   %rax,%rax
  8023a3:	75 07                	jne    8023ac <read+0xba>
		return -E_NOT_SUPP;
  8023a5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8023aa:	eb 19                	jmp    8023c5 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8023ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023b0:	48 8b 40 10          	mov    0x10(%rax),%rax
  8023b4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8023b8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8023bc:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8023c0:	48 89 cf             	mov    %rcx,%rdi
  8023c3:	ff d0                	callq  *%rax
}
  8023c5:	c9                   	leaveq 
  8023c6:	c3                   	retq   

00000000008023c7 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8023c7:	55                   	push   %rbp
  8023c8:	48 89 e5             	mov    %rsp,%rbp
  8023cb:	48 83 ec 30          	sub    $0x30,%rsp
  8023cf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023d2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8023d6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8023da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8023e1:	eb 49                	jmp    80242c <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8023e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023e6:	48 98                	cltq   
  8023e8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8023ec:	48 29 c2             	sub    %rax,%rdx
  8023ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023f2:	48 63 c8             	movslq %eax,%rcx
  8023f5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023f9:	48 01 c1             	add    %rax,%rcx
  8023fc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023ff:	48 89 ce             	mov    %rcx,%rsi
  802402:	89 c7                	mov    %eax,%edi
  802404:	48 b8 f2 22 80 00 00 	movabs $0x8022f2,%rax
  80240b:	00 00 00 
  80240e:	ff d0                	callq  *%rax
  802410:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802413:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802417:	79 05                	jns    80241e <readn+0x57>
			return m;
  802419:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80241c:	eb 1c                	jmp    80243a <readn+0x73>
		if (m == 0)
  80241e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802422:	75 02                	jne    802426 <readn+0x5f>
			break;
  802424:	eb 11                	jmp    802437 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802426:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802429:	01 45 fc             	add    %eax,-0x4(%rbp)
  80242c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80242f:	48 98                	cltq   
  802431:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802435:	72 ac                	jb     8023e3 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802437:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80243a:	c9                   	leaveq 
  80243b:	c3                   	retq   

000000000080243c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80243c:	55                   	push   %rbp
  80243d:	48 89 e5             	mov    %rsp,%rbp
  802440:	48 83 ec 40          	sub    $0x40,%rsp
  802444:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802447:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80244b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80244f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802453:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802456:	48 89 d6             	mov    %rdx,%rsi
  802459:	89 c7                	mov    %eax,%edi
  80245b:	48 b8 c0 1e 80 00 00 	movabs $0x801ec0,%rax
  802462:	00 00 00 
  802465:	ff d0                	callq  *%rax
  802467:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80246a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80246e:	78 24                	js     802494 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802470:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802474:	8b 00                	mov    (%rax),%eax
  802476:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80247a:	48 89 d6             	mov    %rdx,%rsi
  80247d:	89 c7                	mov    %eax,%edi
  80247f:	48 b8 19 20 80 00 00 	movabs $0x802019,%rax
  802486:	00 00 00 
  802489:	ff d0                	callq  *%rax
  80248b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80248e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802492:	79 05                	jns    802499 <write+0x5d>
		return r;
  802494:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802497:	eb 75                	jmp    80250e <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802499:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80249d:	8b 40 08             	mov    0x8(%rax),%eax
  8024a0:	83 e0 03             	and    $0x3,%eax
  8024a3:	85 c0                	test   %eax,%eax
  8024a5:	75 3a                	jne    8024e1 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8024a7:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8024ae:	00 00 00 
  8024b1:	48 8b 00             	mov    (%rax),%rax
  8024b4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024ba:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8024bd:	89 c6                	mov    %eax,%esi
  8024bf:	48 bf b3 49 80 00 00 	movabs $0x8049b3,%rdi
  8024c6:	00 00 00 
  8024c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ce:	48 b9 bf 05 80 00 00 	movabs $0x8005bf,%rcx
  8024d5:	00 00 00 
  8024d8:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8024da:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024df:	eb 2d                	jmp    80250e <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  8024e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024e5:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024e9:	48 85 c0             	test   %rax,%rax
  8024ec:	75 07                	jne    8024f5 <write+0xb9>
		return -E_NOT_SUPP;
  8024ee:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024f3:	eb 19                	jmp    80250e <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8024f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024f9:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024fd:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802501:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802505:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802509:	48 89 cf             	mov    %rcx,%rdi
  80250c:	ff d0                	callq  *%rax
}
  80250e:	c9                   	leaveq 
  80250f:	c3                   	retq   

0000000000802510 <seek>:

int
seek(int fdnum, off_t offset)
{
  802510:	55                   	push   %rbp
  802511:	48 89 e5             	mov    %rsp,%rbp
  802514:	48 83 ec 18          	sub    $0x18,%rsp
  802518:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80251b:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80251e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802522:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802525:	48 89 d6             	mov    %rdx,%rsi
  802528:	89 c7                	mov    %eax,%edi
  80252a:	48 b8 c0 1e 80 00 00 	movabs $0x801ec0,%rax
  802531:	00 00 00 
  802534:	ff d0                	callq  *%rax
  802536:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802539:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80253d:	79 05                	jns    802544 <seek+0x34>
		return r;
  80253f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802542:	eb 0f                	jmp    802553 <seek+0x43>
	fd->fd_offset = offset;
  802544:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802548:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80254b:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80254e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802553:	c9                   	leaveq 
  802554:	c3                   	retq   

0000000000802555 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802555:	55                   	push   %rbp
  802556:	48 89 e5             	mov    %rsp,%rbp
  802559:	48 83 ec 30          	sub    $0x30,%rsp
  80255d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802560:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802563:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802567:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80256a:	48 89 d6             	mov    %rdx,%rsi
  80256d:	89 c7                	mov    %eax,%edi
  80256f:	48 b8 c0 1e 80 00 00 	movabs $0x801ec0,%rax
  802576:	00 00 00 
  802579:	ff d0                	callq  *%rax
  80257b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80257e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802582:	78 24                	js     8025a8 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802584:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802588:	8b 00                	mov    (%rax),%eax
  80258a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80258e:	48 89 d6             	mov    %rdx,%rsi
  802591:	89 c7                	mov    %eax,%edi
  802593:	48 b8 19 20 80 00 00 	movabs $0x802019,%rax
  80259a:	00 00 00 
  80259d:	ff d0                	callq  *%rax
  80259f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025a6:	79 05                	jns    8025ad <ftruncate+0x58>
		return r;
  8025a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025ab:	eb 72                	jmp    80261f <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8025ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025b1:	8b 40 08             	mov    0x8(%rax),%eax
  8025b4:	83 e0 03             	and    $0x3,%eax
  8025b7:	85 c0                	test   %eax,%eax
  8025b9:	75 3a                	jne    8025f5 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8025bb:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8025c2:	00 00 00 
  8025c5:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8025c8:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025ce:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8025d1:	89 c6                	mov    %eax,%esi
  8025d3:	48 bf d0 49 80 00 00 	movabs $0x8049d0,%rdi
  8025da:	00 00 00 
  8025dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e2:	48 b9 bf 05 80 00 00 	movabs $0x8005bf,%rcx
  8025e9:	00 00 00 
  8025ec:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8025ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025f3:	eb 2a                	jmp    80261f <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8025f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025f9:	48 8b 40 30          	mov    0x30(%rax),%rax
  8025fd:	48 85 c0             	test   %rax,%rax
  802600:	75 07                	jne    802609 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802602:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802607:	eb 16                	jmp    80261f <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802609:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80260d:	48 8b 40 30          	mov    0x30(%rax),%rax
  802611:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802615:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802618:	89 ce                	mov    %ecx,%esi
  80261a:	48 89 d7             	mov    %rdx,%rdi
  80261d:	ff d0                	callq  *%rax
}
  80261f:	c9                   	leaveq 
  802620:	c3                   	retq   

0000000000802621 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802621:	55                   	push   %rbp
  802622:	48 89 e5             	mov    %rsp,%rbp
  802625:	48 83 ec 30          	sub    $0x30,%rsp
  802629:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80262c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802630:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802634:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802637:	48 89 d6             	mov    %rdx,%rsi
  80263a:	89 c7                	mov    %eax,%edi
  80263c:	48 b8 c0 1e 80 00 00 	movabs $0x801ec0,%rax
  802643:	00 00 00 
  802646:	ff d0                	callq  *%rax
  802648:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80264b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80264f:	78 24                	js     802675 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802651:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802655:	8b 00                	mov    (%rax),%eax
  802657:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80265b:	48 89 d6             	mov    %rdx,%rsi
  80265e:	89 c7                	mov    %eax,%edi
  802660:	48 b8 19 20 80 00 00 	movabs $0x802019,%rax
  802667:	00 00 00 
  80266a:	ff d0                	callq  *%rax
  80266c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80266f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802673:	79 05                	jns    80267a <fstat+0x59>
		return r;
  802675:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802678:	eb 5e                	jmp    8026d8 <fstat+0xb7>
	if (!dev->dev_stat)
  80267a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80267e:	48 8b 40 28          	mov    0x28(%rax),%rax
  802682:	48 85 c0             	test   %rax,%rax
  802685:	75 07                	jne    80268e <fstat+0x6d>
		return -E_NOT_SUPP;
  802687:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80268c:	eb 4a                	jmp    8026d8 <fstat+0xb7>
	stat->st_name[0] = 0;
  80268e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802692:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802695:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802699:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8026a0:	00 00 00 
	stat->st_isdir = 0;
  8026a3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026a7:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8026ae:	00 00 00 
	stat->st_dev = dev;
  8026b1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8026b5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026b9:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8026c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026c4:	48 8b 40 28          	mov    0x28(%rax),%rax
  8026c8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8026cc:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8026d0:	48 89 ce             	mov    %rcx,%rsi
  8026d3:	48 89 d7             	mov    %rdx,%rdi
  8026d6:	ff d0                	callq  *%rax
}
  8026d8:	c9                   	leaveq 
  8026d9:	c3                   	retq   

00000000008026da <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8026da:	55                   	push   %rbp
  8026db:	48 89 e5             	mov    %rsp,%rbp
  8026de:	48 83 ec 20          	sub    $0x20,%rsp
  8026e2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026e6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8026ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026ee:	be 00 00 00 00       	mov    $0x0,%esi
  8026f3:	48 89 c7             	mov    %rax,%rdi
  8026f6:	48 b8 c8 27 80 00 00 	movabs $0x8027c8,%rax
  8026fd:	00 00 00 
  802700:	ff d0                	callq  *%rax
  802702:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802705:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802709:	79 05                	jns    802710 <stat+0x36>
		return fd;
  80270b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80270e:	eb 2f                	jmp    80273f <stat+0x65>
	r = fstat(fd, stat);
  802710:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802714:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802717:	48 89 d6             	mov    %rdx,%rsi
  80271a:	89 c7                	mov    %eax,%edi
  80271c:	48 b8 21 26 80 00 00 	movabs $0x802621,%rax
  802723:	00 00 00 
  802726:	ff d0                	callq  *%rax
  802728:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80272b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80272e:	89 c7                	mov    %eax,%edi
  802730:	48 b8 d0 20 80 00 00 	movabs $0x8020d0,%rax
  802737:	00 00 00 
  80273a:	ff d0                	callq  *%rax
	return r;
  80273c:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80273f:	c9                   	leaveq 
  802740:	c3                   	retq   

0000000000802741 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802741:	55                   	push   %rbp
  802742:	48 89 e5             	mov    %rsp,%rbp
  802745:	48 83 ec 10          	sub    $0x10,%rsp
  802749:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80274c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802750:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802757:	00 00 00 
  80275a:	8b 00                	mov    (%rax),%eax
  80275c:	85 c0                	test   %eax,%eax
  80275e:	75 1d                	jne    80277d <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802760:	bf 01 00 00 00       	mov    $0x1,%edi
  802765:	48 b8 d2 42 80 00 00 	movabs $0x8042d2,%rax
  80276c:	00 00 00 
  80276f:	ff d0                	callq  *%rax
  802771:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  802778:	00 00 00 
  80277b:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80277d:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802784:	00 00 00 
  802787:	8b 00                	mov    (%rax),%eax
  802789:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80278c:	b9 07 00 00 00       	mov    $0x7,%ecx
  802791:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802798:	00 00 00 
  80279b:	89 c7                	mov    %eax,%edi
  80279d:	48 b8 70 42 80 00 00 	movabs $0x804270,%rax
  8027a4:	00 00 00 
  8027a7:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8027a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8027b2:	48 89 c6             	mov    %rax,%rsi
  8027b5:	bf 00 00 00 00       	mov    $0x0,%edi
  8027ba:	48 b8 6a 41 80 00 00 	movabs $0x80416a,%rax
  8027c1:	00 00 00 
  8027c4:	ff d0                	callq  *%rax
}
  8027c6:	c9                   	leaveq 
  8027c7:	c3                   	retq   

00000000008027c8 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8027c8:	55                   	push   %rbp
  8027c9:	48 89 e5             	mov    %rsp,%rbp
  8027cc:	48 83 ec 30          	sub    $0x30,%rsp
  8027d0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8027d4:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  8027d7:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  8027de:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  8027e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  8027ec:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8027f1:	75 08                	jne    8027fb <open+0x33>
	{
		return r;
  8027f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027f6:	e9 f2 00 00 00       	jmpq   8028ed <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  8027fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027ff:	48 89 c7             	mov    %rax,%rdi
  802802:	48 b8 08 11 80 00 00 	movabs $0x801108,%rax
  802809:	00 00 00 
  80280c:	ff d0                	callq  *%rax
  80280e:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802811:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802818:	7e 0a                	jle    802824 <open+0x5c>
	{
		return -E_BAD_PATH;
  80281a:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80281f:	e9 c9 00 00 00       	jmpq   8028ed <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802824:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80282b:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  80282c:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802830:	48 89 c7             	mov    %rax,%rdi
  802833:	48 b8 28 1e 80 00 00 	movabs $0x801e28,%rax
  80283a:	00 00 00 
  80283d:	ff d0                	callq  *%rax
  80283f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802842:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802846:	78 09                	js     802851 <open+0x89>
  802848:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80284c:	48 85 c0             	test   %rax,%rax
  80284f:	75 08                	jne    802859 <open+0x91>
		{
			return r;
  802851:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802854:	e9 94 00 00 00       	jmpq   8028ed <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802859:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80285d:	ba 00 04 00 00       	mov    $0x400,%edx
  802862:	48 89 c6             	mov    %rax,%rsi
  802865:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80286c:	00 00 00 
  80286f:	48 b8 06 12 80 00 00 	movabs $0x801206,%rax
  802876:	00 00 00 
  802879:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  80287b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802882:	00 00 00 
  802885:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802888:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  80288e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802892:	48 89 c6             	mov    %rax,%rsi
  802895:	bf 01 00 00 00       	mov    $0x1,%edi
  80289a:	48 b8 41 27 80 00 00 	movabs $0x802741,%rax
  8028a1:	00 00 00 
  8028a4:	ff d0                	callq  *%rax
  8028a6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028a9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028ad:	79 2b                	jns    8028da <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  8028af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028b3:	be 00 00 00 00       	mov    $0x0,%esi
  8028b8:	48 89 c7             	mov    %rax,%rdi
  8028bb:	48 b8 50 1f 80 00 00 	movabs $0x801f50,%rax
  8028c2:	00 00 00 
  8028c5:	ff d0                	callq  *%rax
  8028c7:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8028ca:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8028ce:	79 05                	jns    8028d5 <open+0x10d>
			{
				return d;
  8028d0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8028d3:	eb 18                	jmp    8028ed <open+0x125>
			}
			return r;
  8028d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028d8:	eb 13                	jmp    8028ed <open+0x125>
		}	
		return fd2num(fd_store);
  8028da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028de:	48 89 c7             	mov    %rax,%rdi
  8028e1:	48 b8 da 1d 80 00 00 	movabs $0x801dda,%rax
  8028e8:	00 00 00 
  8028eb:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  8028ed:	c9                   	leaveq 
  8028ee:	c3                   	retq   

00000000008028ef <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8028ef:	55                   	push   %rbp
  8028f0:	48 89 e5             	mov    %rsp,%rbp
  8028f3:	48 83 ec 10          	sub    $0x10,%rsp
  8028f7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8028fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028ff:	8b 50 0c             	mov    0xc(%rax),%edx
  802902:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802909:	00 00 00 
  80290c:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80290e:	be 00 00 00 00       	mov    $0x0,%esi
  802913:	bf 06 00 00 00       	mov    $0x6,%edi
  802918:	48 b8 41 27 80 00 00 	movabs $0x802741,%rax
  80291f:	00 00 00 
  802922:	ff d0                	callq  *%rax
}
  802924:	c9                   	leaveq 
  802925:	c3                   	retq   

0000000000802926 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802926:	55                   	push   %rbp
  802927:	48 89 e5             	mov    %rsp,%rbp
  80292a:	48 83 ec 30          	sub    $0x30,%rsp
  80292e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802932:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802936:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  80293a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802941:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802946:	74 07                	je     80294f <devfile_read+0x29>
  802948:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80294d:	75 07                	jne    802956 <devfile_read+0x30>
		return -E_INVAL;
  80294f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802954:	eb 77                	jmp    8029cd <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802956:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80295a:	8b 50 0c             	mov    0xc(%rax),%edx
  80295d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802964:	00 00 00 
  802967:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802969:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802970:	00 00 00 
  802973:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802977:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  80297b:	be 00 00 00 00       	mov    $0x0,%esi
  802980:	bf 03 00 00 00       	mov    $0x3,%edi
  802985:	48 b8 41 27 80 00 00 	movabs $0x802741,%rax
  80298c:	00 00 00 
  80298f:	ff d0                	callq  *%rax
  802991:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802994:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802998:	7f 05                	jg     80299f <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  80299a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80299d:	eb 2e                	jmp    8029cd <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  80299f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029a2:	48 63 d0             	movslq %eax,%rdx
  8029a5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029a9:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8029b0:	00 00 00 
  8029b3:	48 89 c7             	mov    %rax,%rdi
  8029b6:	48 b8 98 14 80 00 00 	movabs $0x801498,%rax
  8029bd:	00 00 00 
  8029c0:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  8029c2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029c6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  8029ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8029cd:	c9                   	leaveq 
  8029ce:	c3                   	retq   

00000000008029cf <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8029cf:	55                   	push   %rbp
  8029d0:	48 89 e5             	mov    %rsp,%rbp
  8029d3:	48 83 ec 30          	sub    $0x30,%rsp
  8029d7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029db:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8029df:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  8029e3:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  8029ea:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8029ef:	74 07                	je     8029f8 <devfile_write+0x29>
  8029f1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8029f6:	75 08                	jne    802a00 <devfile_write+0x31>
		return r;
  8029f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029fb:	e9 9a 00 00 00       	jmpq   802a9a <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802a00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a04:	8b 50 0c             	mov    0xc(%rax),%edx
  802a07:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a0e:	00 00 00 
  802a11:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802a13:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802a1a:	00 
  802a1b:	76 08                	jbe    802a25 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802a1d:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802a24:	00 
	}
	fsipcbuf.write.req_n = n;
  802a25:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a2c:	00 00 00 
  802a2f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a33:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802a37:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a3b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a3f:	48 89 c6             	mov    %rax,%rsi
  802a42:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802a49:	00 00 00 
  802a4c:	48 b8 98 14 80 00 00 	movabs $0x801498,%rax
  802a53:	00 00 00 
  802a56:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802a58:	be 00 00 00 00       	mov    $0x0,%esi
  802a5d:	bf 04 00 00 00       	mov    $0x4,%edi
  802a62:	48 b8 41 27 80 00 00 	movabs $0x802741,%rax
  802a69:	00 00 00 
  802a6c:	ff d0                	callq  *%rax
  802a6e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a71:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a75:	7f 20                	jg     802a97 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802a77:	48 bf f6 49 80 00 00 	movabs $0x8049f6,%rdi
  802a7e:	00 00 00 
  802a81:	b8 00 00 00 00       	mov    $0x0,%eax
  802a86:	48 ba bf 05 80 00 00 	movabs $0x8005bf,%rdx
  802a8d:	00 00 00 
  802a90:	ff d2                	callq  *%rdx
		return r;
  802a92:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a95:	eb 03                	jmp    802a9a <devfile_write+0xcb>
	}
	return r;
  802a97:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802a9a:	c9                   	leaveq 
  802a9b:	c3                   	retq   

0000000000802a9c <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802a9c:	55                   	push   %rbp
  802a9d:	48 89 e5             	mov    %rsp,%rbp
  802aa0:	48 83 ec 20          	sub    $0x20,%rsp
  802aa4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802aa8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802aac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ab0:	8b 50 0c             	mov    0xc(%rax),%edx
  802ab3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802aba:	00 00 00 
  802abd:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802abf:	be 00 00 00 00       	mov    $0x0,%esi
  802ac4:	bf 05 00 00 00       	mov    $0x5,%edi
  802ac9:	48 b8 41 27 80 00 00 	movabs $0x802741,%rax
  802ad0:	00 00 00 
  802ad3:	ff d0                	callq  *%rax
  802ad5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ad8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802adc:	79 05                	jns    802ae3 <devfile_stat+0x47>
		return r;
  802ade:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ae1:	eb 56                	jmp    802b39 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802ae3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ae7:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802aee:	00 00 00 
  802af1:	48 89 c7             	mov    %rax,%rdi
  802af4:	48 b8 74 11 80 00 00 	movabs $0x801174,%rax
  802afb:	00 00 00 
  802afe:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802b00:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b07:	00 00 00 
  802b0a:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802b10:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b14:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802b1a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b21:	00 00 00 
  802b24:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802b2a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b2e:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802b34:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b39:	c9                   	leaveq 
  802b3a:	c3                   	retq   

0000000000802b3b <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802b3b:	55                   	push   %rbp
  802b3c:	48 89 e5             	mov    %rsp,%rbp
  802b3f:	48 83 ec 10          	sub    $0x10,%rsp
  802b43:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802b47:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802b4a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b4e:	8b 50 0c             	mov    0xc(%rax),%edx
  802b51:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b58:	00 00 00 
  802b5b:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802b5d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b64:	00 00 00 
  802b67:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802b6a:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802b6d:	be 00 00 00 00       	mov    $0x0,%esi
  802b72:	bf 02 00 00 00       	mov    $0x2,%edi
  802b77:	48 b8 41 27 80 00 00 	movabs $0x802741,%rax
  802b7e:	00 00 00 
  802b81:	ff d0                	callq  *%rax
}
  802b83:	c9                   	leaveq 
  802b84:	c3                   	retq   

0000000000802b85 <remove>:

// Delete a file
int
remove(const char *path)
{
  802b85:	55                   	push   %rbp
  802b86:	48 89 e5             	mov    %rsp,%rbp
  802b89:	48 83 ec 10          	sub    $0x10,%rsp
  802b8d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802b91:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b95:	48 89 c7             	mov    %rax,%rdi
  802b98:	48 b8 08 11 80 00 00 	movabs $0x801108,%rax
  802b9f:	00 00 00 
  802ba2:	ff d0                	callq  *%rax
  802ba4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802ba9:	7e 07                	jle    802bb2 <remove+0x2d>
		return -E_BAD_PATH;
  802bab:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802bb0:	eb 33                	jmp    802be5 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802bb2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bb6:	48 89 c6             	mov    %rax,%rsi
  802bb9:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802bc0:	00 00 00 
  802bc3:	48 b8 74 11 80 00 00 	movabs $0x801174,%rax
  802bca:	00 00 00 
  802bcd:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802bcf:	be 00 00 00 00       	mov    $0x0,%esi
  802bd4:	bf 07 00 00 00       	mov    $0x7,%edi
  802bd9:	48 b8 41 27 80 00 00 	movabs $0x802741,%rax
  802be0:	00 00 00 
  802be3:	ff d0                	callq  *%rax
}
  802be5:	c9                   	leaveq 
  802be6:	c3                   	retq   

0000000000802be7 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802be7:	55                   	push   %rbp
  802be8:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802beb:	be 00 00 00 00       	mov    $0x0,%esi
  802bf0:	bf 08 00 00 00       	mov    $0x8,%edi
  802bf5:	48 b8 41 27 80 00 00 	movabs $0x802741,%rax
  802bfc:	00 00 00 
  802bff:	ff d0                	callq  *%rax
}
  802c01:	5d                   	pop    %rbp
  802c02:	c3                   	retq   

0000000000802c03 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802c03:	55                   	push   %rbp
  802c04:	48 89 e5             	mov    %rsp,%rbp
  802c07:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802c0e:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802c15:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802c1c:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802c23:	be 00 00 00 00       	mov    $0x0,%esi
  802c28:	48 89 c7             	mov    %rax,%rdi
  802c2b:	48 b8 c8 27 80 00 00 	movabs $0x8027c8,%rax
  802c32:	00 00 00 
  802c35:	ff d0                	callq  *%rax
  802c37:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802c3a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c3e:	79 28                	jns    802c68 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802c40:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c43:	89 c6                	mov    %eax,%esi
  802c45:	48 bf 12 4a 80 00 00 	movabs $0x804a12,%rdi
  802c4c:	00 00 00 
  802c4f:	b8 00 00 00 00       	mov    $0x0,%eax
  802c54:	48 ba bf 05 80 00 00 	movabs $0x8005bf,%rdx
  802c5b:	00 00 00 
  802c5e:	ff d2                	callq  *%rdx
		return fd_src;
  802c60:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c63:	e9 74 01 00 00       	jmpq   802ddc <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802c68:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802c6f:	be 01 01 00 00       	mov    $0x101,%esi
  802c74:	48 89 c7             	mov    %rax,%rdi
  802c77:	48 b8 c8 27 80 00 00 	movabs $0x8027c8,%rax
  802c7e:	00 00 00 
  802c81:	ff d0                	callq  *%rax
  802c83:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802c86:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c8a:	79 39                	jns    802cc5 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802c8c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c8f:	89 c6                	mov    %eax,%esi
  802c91:	48 bf 28 4a 80 00 00 	movabs $0x804a28,%rdi
  802c98:	00 00 00 
  802c9b:	b8 00 00 00 00       	mov    $0x0,%eax
  802ca0:	48 ba bf 05 80 00 00 	movabs $0x8005bf,%rdx
  802ca7:	00 00 00 
  802caa:	ff d2                	callq  *%rdx
		close(fd_src);
  802cac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802caf:	89 c7                	mov    %eax,%edi
  802cb1:	48 b8 d0 20 80 00 00 	movabs $0x8020d0,%rax
  802cb8:	00 00 00 
  802cbb:	ff d0                	callq  *%rax
		return fd_dest;
  802cbd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cc0:	e9 17 01 00 00       	jmpq   802ddc <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802cc5:	eb 74                	jmp    802d3b <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802cc7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802cca:	48 63 d0             	movslq %eax,%rdx
  802ccd:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802cd4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cd7:	48 89 ce             	mov    %rcx,%rsi
  802cda:	89 c7                	mov    %eax,%edi
  802cdc:	48 b8 3c 24 80 00 00 	movabs $0x80243c,%rax
  802ce3:	00 00 00 
  802ce6:	ff d0                	callq  *%rax
  802ce8:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802ceb:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802cef:	79 4a                	jns    802d3b <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802cf1:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802cf4:	89 c6                	mov    %eax,%esi
  802cf6:	48 bf 42 4a 80 00 00 	movabs $0x804a42,%rdi
  802cfd:	00 00 00 
  802d00:	b8 00 00 00 00       	mov    $0x0,%eax
  802d05:	48 ba bf 05 80 00 00 	movabs $0x8005bf,%rdx
  802d0c:	00 00 00 
  802d0f:	ff d2                	callq  *%rdx
			close(fd_src);
  802d11:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d14:	89 c7                	mov    %eax,%edi
  802d16:	48 b8 d0 20 80 00 00 	movabs $0x8020d0,%rax
  802d1d:	00 00 00 
  802d20:	ff d0                	callq  *%rax
			close(fd_dest);
  802d22:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d25:	89 c7                	mov    %eax,%edi
  802d27:	48 b8 d0 20 80 00 00 	movabs $0x8020d0,%rax
  802d2e:	00 00 00 
  802d31:	ff d0                	callq  *%rax
			return write_size;
  802d33:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802d36:	e9 a1 00 00 00       	jmpq   802ddc <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802d3b:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802d42:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d45:	ba 00 02 00 00       	mov    $0x200,%edx
  802d4a:	48 89 ce             	mov    %rcx,%rsi
  802d4d:	89 c7                	mov    %eax,%edi
  802d4f:	48 b8 f2 22 80 00 00 	movabs $0x8022f2,%rax
  802d56:	00 00 00 
  802d59:	ff d0                	callq  *%rax
  802d5b:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802d5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802d62:	0f 8f 5f ff ff ff    	jg     802cc7 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802d68:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802d6c:	79 47                	jns    802db5 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802d6e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d71:	89 c6                	mov    %eax,%esi
  802d73:	48 bf 55 4a 80 00 00 	movabs $0x804a55,%rdi
  802d7a:	00 00 00 
  802d7d:	b8 00 00 00 00       	mov    $0x0,%eax
  802d82:	48 ba bf 05 80 00 00 	movabs $0x8005bf,%rdx
  802d89:	00 00 00 
  802d8c:	ff d2                	callq  *%rdx
		close(fd_src);
  802d8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d91:	89 c7                	mov    %eax,%edi
  802d93:	48 b8 d0 20 80 00 00 	movabs $0x8020d0,%rax
  802d9a:	00 00 00 
  802d9d:	ff d0                	callq  *%rax
		close(fd_dest);
  802d9f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802da2:	89 c7                	mov    %eax,%edi
  802da4:	48 b8 d0 20 80 00 00 	movabs $0x8020d0,%rax
  802dab:	00 00 00 
  802dae:	ff d0                	callq  *%rax
		return read_size;
  802db0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802db3:	eb 27                	jmp    802ddc <copy+0x1d9>
	}
	close(fd_src);
  802db5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802db8:	89 c7                	mov    %eax,%edi
  802dba:	48 b8 d0 20 80 00 00 	movabs $0x8020d0,%rax
  802dc1:	00 00 00 
  802dc4:	ff d0                	callq  *%rax
	close(fd_dest);
  802dc6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802dc9:	89 c7                	mov    %eax,%edi
  802dcb:	48 b8 d0 20 80 00 00 	movabs $0x8020d0,%rax
  802dd2:	00 00 00 
  802dd5:	ff d0                	callq  *%rax
	return 0;
  802dd7:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802ddc:	c9                   	leaveq 
  802ddd:	c3                   	retq   

0000000000802dde <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  802dde:	55                   	push   %rbp
  802ddf:	48 89 e5             	mov    %rsp,%rbp
  802de2:	48 83 ec 20          	sub    $0x20,%rsp
  802de6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  802dea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dee:	8b 40 0c             	mov    0xc(%rax),%eax
  802df1:	85 c0                	test   %eax,%eax
  802df3:	7e 67                	jle    802e5c <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802df5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802df9:	8b 40 04             	mov    0x4(%rax),%eax
  802dfc:	48 63 d0             	movslq %eax,%rdx
  802dff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e03:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802e07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e0b:	8b 00                	mov    (%rax),%eax
  802e0d:	48 89 ce             	mov    %rcx,%rsi
  802e10:	89 c7                	mov    %eax,%edi
  802e12:	48 b8 3c 24 80 00 00 	movabs $0x80243c,%rax
  802e19:	00 00 00 
  802e1c:	ff d0                	callq  *%rax
  802e1e:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  802e21:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e25:	7e 13                	jle    802e3a <writebuf+0x5c>
			b->result += result;
  802e27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e2b:	8b 50 08             	mov    0x8(%rax),%edx
  802e2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e31:	01 c2                	add    %eax,%edx
  802e33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e37:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  802e3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e3e:	8b 40 04             	mov    0x4(%rax),%eax
  802e41:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802e44:	74 16                	je     802e5c <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  802e46:	b8 00 00 00 00       	mov    $0x0,%eax
  802e4b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e4f:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  802e53:	89 c2                	mov    %eax,%edx
  802e55:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e59:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  802e5c:	c9                   	leaveq 
  802e5d:	c3                   	retq   

0000000000802e5e <putch>:

static void
putch(int ch, void *thunk)
{
  802e5e:	55                   	push   %rbp
  802e5f:	48 89 e5             	mov    %rsp,%rbp
  802e62:	48 83 ec 20          	sub    $0x20,%rsp
  802e66:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e69:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  802e6d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e71:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  802e75:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e79:	8b 40 04             	mov    0x4(%rax),%eax
  802e7c:	8d 48 01             	lea    0x1(%rax),%ecx
  802e7f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802e83:	89 4a 04             	mov    %ecx,0x4(%rdx)
  802e86:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802e89:	89 d1                	mov    %edx,%ecx
  802e8b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802e8f:	48 98                	cltq   
  802e91:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  802e95:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e99:	8b 40 04             	mov    0x4(%rax),%eax
  802e9c:	3d 00 01 00 00       	cmp    $0x100,%eax
  802ea1:	75 1e                	jne    802ec1 <putch+0x63>
		writebuf(b);
  802ea3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ea7:	48 89 c7             	mov    %rax,%rdi
  802eaa:	48 b8 de 2d 80 00 00 	movabs $0x802dde,%rax
  802eb1:	00 00 00 
  802eb4:	ff d0                	callq  *%rax
		b->idx = 0;
  802eb6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802eba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  802ec1:	c9                   	leaveq 
  802ec2:	c3                   	retq   

0000000000802ec3 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802ec3:	55                   	push   %rbp
  802ec4:	48 89 e5             	mov    %rsp,%rbp
  802ec7:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  802ece:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  802ed4:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  802edb:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  802ee2:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  802ee8:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  802eee:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802ef5:	00 00 00 
	b.result = 0;
  802ef8:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  802eff:	00 00 00 
	b.error = 1;
  802f02:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  802f09:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802f0c:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  802f13:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  802f1a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802f21:	48 89 c6             	mov    %rax,%rsi
  802f24:	48 bf 5e 2e 80 00 00 	movabs $0x802e5e,%rdi
  802f2b:	00 00 00 
  802f2e:	48 b8 72 09 80 00 00 	movabs $0x800972,%rax
  802f35:	00 00 00 
  802f38:	ff d0                	callq  *%rax
	if (b.idx > 0)
  802f3a:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  802f40:	85 c0                	test   %eax,%eax
  802f42:	7e 16                	jle    802f5a <vfprintf+0x97>
		writebuf(&b);
  802f44:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802f4b:	48 89 c7             	mov    %rax,%rdi
  802f4e:	48 b8 de 2d 80 00 00 	movabs $0x802dde,%rax
  802f55:	00 00 00 
  802f58:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  802f5a:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802f60:	85 c0                	test   %eax,%eax
  802f62:	74 08                	je     802f6c <vfprintf+0xa9>
  802f64:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802f6a:	eb 06                	jmp    802f72 <vfprintf+0xaf>
  802f6c:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  802f72:	c9                   	leaveq 
  802f73:	c3                   	retq   

0000000000802f74 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802f74:	55                   	push   %rbp
  802f75:	48 89 e5             	mov    %rsp,%rbp
  802f78:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802f7f:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  802f85:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802f8c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802f93:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802f9a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802fa1:	84 c0                	test   %al,%al
  802fa3:	74 20                	je     802fc5 <fprintf+0x51>
  802fa5:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802fa9:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802fad:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802fb1:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802fb5:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802fb9:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802fbd:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802fc1:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802fc5:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802fcc:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  802fd3:	00 00 00 
  802fd6:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802fdd:	00 00 00 
  802fe0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802fe4:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802feb:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802ff2:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  802ff9:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803000:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  803007:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  80300d:	48 89 ce             	mov    %rcx,%rsi
  803010:	89 c7                	mov    %eax,%edi
  803012:	48 b8 c3 2e 80 00 00 	movabs $0x802ec3,%rax
  803019:	00 00 00 
  80301c:	ff d0                	callq  *%rax
  80301e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  803024:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80302a:	c9                   	leaveq 
  80302b:	c3                   	retq   

000000000080302c <printf>:

int
printf(const char *fmt, ...)
{
  80302c:	55                   	push   %rbp
  80302d:	48 89 e5             	mov    %rsp,%rbp
  803030:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  803037:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80303e:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  803045:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80304c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803053:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80305a:	84 c0                	test   %al,%al
  80305c:	74 20                	je     80307e <printf+0x52>
  80305e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803062:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803066:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80306a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80306e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803072:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803076:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80307a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80307e:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  803085:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80308c:	00 00 00 
  80308f:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803096:	00 00 00 
  803099:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80309d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8030a4:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8030ab:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  8030b2:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8030b9:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8030c0:	48 89 c6             	mov    %rax,%rsi
  8030c3:	bf 01 00 00 00       	mov    $0x1,%edi
  8030c8:	48 b8 c3 2e 80 00 00 	movabs $0x802ec3,%rax
  8030cf:	00 00 00 
  8030d2:	ff d0                	callq  *%rax
  8030d4:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  8030da:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8030e0:	c9                   	leaveq 
  8030e1:	c3                   	retq   

00000000008030e2 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8030e2:	55                   	push   %rbp
  8030e3:	48 89 e5             	mov    %rsp,%rbp
  8030e6:	48 83 ec 20          	sub    $0x20,%rsp
  8030ea:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8030ed:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8030f1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030f4:	48 89 d6             	mov    %rdx,%rsi
  8030f7:	89 c7                	mov    %eax,%edi
  8030f9:	48 b8 c0 1e 80 00 00 	movabs $0x801ec0,%rax
  803100:	00 00 00 
  803103:	ff d0                	callq  *%rax
  803105:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803108:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80310c:	79 05                	jns    803113 <fd2sockid+0x31>
		return r;
  80310e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803111:	eb 24                	jmp    803137 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803113:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803117:	8b 10                	mov    (%rax),%edx
  803119:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  803120:	00 00 00 
  803123:	8b 00                	mov    (%rax),%eax
  803125:	39 c2                	cmp    %eax,%edx
  803127:	74 07                	je     803130 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803129:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80312e:	eb 07                	jmp    803137 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803130:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803134:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803137:	c9                   	leaveq 
  803138:	c3                   	retq   

0000000000803139 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803139:	55                   	push   %rbp
  80313a:	48 89 e5             	mov    %rsp,%rbp
  80313d:	48 83 ec 20          	sub    $0x20,%rsp
  803141:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803144:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803148:	48 89 c7             	mov    %rax,%rdi
  80314b:	48 b8 28 1e 80 00 00 	movabs $0x801e28,%rax
  803152:	00 00 00 
  803155:	ff d0                	callq  *%rax
  803157:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80315a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80315e:	78 26                	js     803186 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803160:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803164:	ba 07 04 00 00       	mov    $0x407,%edx
  803169:	48 89 c6             	mov    %rax,%rsi
  80316c:	bf 00 00 00 00       	mov    $0x0,%edi
  803171:	48 b8 a3 1a 80 00 00 	movabs $0x801aa3,%rax
  803178:	00 00 00 
  80317b:	ff d0                	callq  *%rax
  80317d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803180:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803184:	79 16                	jns    80319c <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803186:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803189:	89 c7                	mov    %eax,%edi
  80318b:	48 b8 46 36 80 00 00 	movabs $0x803646,%rax
  803192:	00 00 00 
  803195:	ff d0                	callq  *%rax
		return r;
  803197:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80319a:	eb 3a                	jmp    8031d6 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  80319c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031a0:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  8031a7:	00 00 00 
  8031aa:	8b 12                	mov    (%rdx),%edx
  8031ac:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8031ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031b2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8031b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031bd:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8031c0:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8031c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031c7:	48 89 c7             	mov    %rax,%rdi
  8031ca:	48 b8 da 1d 80 00 00 	movabs $0x801dda,%rax
  8031d1:	00 00 00 
  8031d4:	ff d0                	callq  *%rax
}
  8031d6:	c9                   	leaveq 
  8031d7:	c3                   	retq   

00000000008031d8 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8031d8:	55                   	push   %rbp
  8031d9:	48 89 e5             	mov    %rsp,%rbp
  8031dc:	48 83 ec 30          	sub    $0x30,%rsp
  8031e0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8031e3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8031e7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8031eb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031ee:	89 c7                	mov    %eax,%edi
  8031f0:	48 b8 e2 30 80 00 00 	movabs $0x8030e2,%rax
  8031f7:	00 00 00 
  8031fa:	ff d0                	callq  *%rax
  8031fc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803203:	79 05                	jns    80320a <accept+0x32>
		return r;
  803205:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803208:	eb 3b                	jmp    803245 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80320a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80320e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803212:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803215:	48 89 ce             	mov    %rcx,%rsi
  803218:	89 c7                	mov    %eax,%edi
  80321a:	48 b8 23 35 80 00 00 	movabs $0x803523,%rax
  803221:	00 00 00 
  803224:	ff d0                	callq  *%rax
  803226:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803229:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80322d:	79 05                	jns    803234 <accept+0x5c>
		return r;
  80322f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803232:	eb 11                	jmp    803245 <accept+0x6d>
	return alloc_sockfd(r);
  803234:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803237:	89 c7                	mov    %eax,%edi
  803239:	48 b8 39 31 80 00 00 	movabs $0x803139,%rax
  803240:	00 00 00 
  803243:	ff d0                	callq  *%rax
}
  803245:	c9                   	leaveq 
  803246:	c3                   	retq   

0000000000803247 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803247:	55                   	push   %rbp
  803248:	48 89 e5             	mov    %rsp,%rbp
  80324b:	48 83 ec 20          	sub    $0x20,%rsp
  80324f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803252:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803256:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803259:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80325c:	89 c7                	mov    %eax,%edi
  80325e:	48 b8 e2 30 80 00 00 	movabs $0x8030e2,%rax
  803265:	00 00 00 
  803268:	ff d0                	callq  *%rax
  80326a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80326d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803271:	79 05                	jns    803278 <bind+0x31>
		return r;
  803273:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803276:	eb 1b                	jmp    803293 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803278:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80327b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80327f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803282:	48 89 ce             	mov    %rcx,%rsi
  803285:	89 c7                	mov    %eax,%edi
  803287:	48 b8 a2 35 80 00 00 	movabs $0x8035a2,%rax
  80328e:	00 00 00 
  803291:	ff d0                	callq  *%rax
}
  803293:	c9                   	leaveq 
  803294:	c3                   	retq   

0000000000803295 <shutdown>:

int
shutdown(int s, int how)
{
  803295:	55                   	push   %rbp
  803296:	48 89 e5             	mov    %rsp,%rbp
  803299:	48 83 ec 20          	sub    $0x20,%rsp
  80329d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8032a0:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8032a3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032a6:	89 c7                	mov    %eax,%edi
  8032a8:	48 b8 e2 30 80 00 00 	movabs $0x8030e2,%rax
  8032af:	00 00 00 
  8032b2:	ff d0                	callq  *%rax
  8032b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032bb:	79 05                	jns    8032c2 <shutdown+0x2d>
		return r;
  8032bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032c0:	eb 16                	jmp    8032d8 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8032c2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8032c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032c8:	89 d6                	mov    %edx,%esi
  8032ca:	89 c7                	mov    %eax,%edi
  8032cc:	48 b8 06 36 80 00 00 	movabs $0x803606,%rax
  8032d3:	00 00 00 
  8032d6:	ff d0                	callq  *%rax
}
  8032d8:	c9                   	leaveq 
  8032d9:	c3                   	retq   

00000000008032da <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8032da:	55                   	push   %rbp
  8032db:	48 89 e5             	mov    %rsp,%rbp
  8032de:	48 83 ec 10          	sub    $0x10,%rsp
  8032e2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8032e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032ea:	48 89 c7             	mov    %rax,%rdi
  8032ed:	48 b8 54 43 80 00 00 	movabs $0x804354,%rax
  8032f4:	00 00 00 
  8032f7:	ff d0                	callq  *%rax
  8032f9:	83 f8 01             	cmp    $0x1,%eax
  8032fc:	75 17                	jne    803315 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8032fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803302:	8b 40 0c             	mov    0xc(%rax),%eax
  803305:	89 c7                	mov    %eax,%edi
  803307:	48 b8 46 36 80 00 00 	movabs $0x803646,%rax
  80330e:	00 00 00 
  803311:	ff d0                	callq  *%rax
  803313:	eb 05                	jmp    80331a <devsock_close+0x40>
	else
		return 0;
  803315:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80331a:	c9                   	leaveq 
  80331b:	c3                   	retq   

000000000080331c <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80331c:	55                   	push   %rbp
  80331d:	48 89 e5             	mov    %rsp,%rbp
  803320:	48 83 ec 20          	sub    $0x20,%rsp
  803324:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803327:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80332b:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80332e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803331:	89 c7                	mov    %eax,%edi
  803333:	48 b8 e2 30 80 00 00 	movabs $0x8030e2,%rax
  80333a:	00 00 00 
  80333d:	ff d0                	callq  *%rax
  80333f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803342:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803346:	79 05                	jns    80334d <connect+0x31>
		return r;
  803348:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80334b:	eb 1b                	jmp    803368 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80334d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803350:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803354:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803357:	48 89 ce             	mov    %rcx,%rsi
  80335a:	89 c7                	mov    %eax,%edi
  80335c:	48 b8 73 36 80 00 00 	movabs $0x803673,%rax
  803363:	00 00 00 
  803366:	ff d0                	callq  *%rax
}
  803368:	c9                   	leaveq 
  803369:	c3                   	retq   

000000000080336a <listen>:

int
listen(int s, int backlog)
{
  80336a:	55                   	push   %rbp
  80336b:	48 89 e5             	mov    %rsp,%rbp
  80336e:	48 83 ec 20          	sub    $0x20,%rsp
  803372:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803375:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803378:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80337b:	89 c7                	mov    %eax,%edi
  80337d:	48 b8 e2 30 80 00 00 	movabs $0x8030e2,%rax
  803384:	00 00 00 
  803387:	ff d0                	callq  *%rax
  803389:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80338c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803390:	79 05                	jns    803397 <listen+0x2d>
		return r;
  803392:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803395:	eb 16                	jmp    8033ad <listen+0x43>
	return nsipc_listen(r, backlog);
  803397:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80339a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80339d:	89 d6                	mov    %edx,%esi
  80339f:	89 c7                	mov    %eax,%edi
  8033a1:	48 b8 d7 36 80 00 00 	movabs $0x8036d7,%rax
  8033a8:	00 00 00 
  8033ab:	ff d0                	callq  *%rax
}
  8033ad:	c9                   	leaveq 
  8033ae:	c3                   	retq   

00000000008033af <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8033af:	55                   	push   %rbp
  8033b0:	48 89 e5             	mov    %rsp,%rbp
  8033b3:	48 83 ec 20          	sub    $0x20,%rsp
  8033b7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8033bb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8033bf:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8033c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033c7:	89 c2                	mov    %eax,%edx
  8033c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033cd:	8b 40 0c             	mov    0xc(%rax),%eax
  8033d0:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8033d4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8033d9:	89 c7                	mov    %eax,%edi
  8033db:	48 b8 17 37 80 00 00 	movabs $0x803717,%rax
  8033e2:	00 00 00 
  8033e5:	ff d0                	callq  *%rax
}
  8033e7:	c9                   	leaveq 
  8033e8:	c3                   	retq   

00000000008033e9 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8033e9:	55                   	push   %rbp
  8033ea:	48 89 e5             	mov    %rsp,%rbp
  8033ed:	48 83 ec 20          	sub    $0x20,%rsp
  8033f1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8033f5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8033f9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8033fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803401:	89 c2                	mov    %eax,%edx
  803403:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803407:	8b 40 0c             	mov    0xc(%rax),%eax
  80340a:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80340e:	b9 00 00 00 00       	mov    $0x0,%ecx
  803413:	89 c7                	mov    %eax,%edi
  803415:	48 b8 e3 37 80 00 00 	movabs $0x8037e3,%rax
  80341c:	00 00 00 
  80341f:	ff d0                	callq  *%rax
}
  803421:	c9                   	leaveq 
  803422:	c3                   	retq   

0000000000803423 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803423:	55                   	push   %rbp
  803424:	48 89 e5             	mov    %rsp,%rbp
  803427:	48 83 ec 10          	sub    $0x10,%rsp
  80342b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80342f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803433:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803437:	48 be 70 4a 80 00 00 	movabs $0x804a70,%rsi
  80343e:	00 00 00 
  803441:	48 89 c7             	mov    %rax,%rdi
  803444:	48 b8 74 11 80 00 00 	movabs $0x801174,%rax
  80344b:	00 00 00 
  80344e:	ff d0                	callq  *%rax
	return 0;
  803450:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803455:	c9                   	leaveq 
  803456:	c3                   	retq   

0000000000803457 <socket>:

int
socket(int domain, int type, int protocol)
{
  803457:	55                   	push   %rbp
  803458:	48 89 e5             	mov    %rsp,%rbp
  80345b:	48 83 ec 20          	sub    $0x20,%rsp
  80345f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803462:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803465:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803468:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80346b:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80346e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803471:	89 ce                	mov    %ecx,%esi
  803473:	89 c7                	mov    %eax,%edi
  803475:	48 b8 9b 38 80 00 00 	movabs $0x80389b,%rax
  80347c:	00 00 00 
  80347f:	ff d0                	callq  *%rax
  803481:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803484:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803488:	79 05                	jns    80348f <socket+0x38>
		return r;
  80348a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80348d:	eb 11                	jmp    8034a0 <socket+0x49>
	return alloc_sockfd(r);
  80348f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803492:	89 c7                	mov    %eax,%edi
  803494:	48 b8 39 31 80 00 00 	movabs $0x803139,%rax
  80349b:	00 00 00 
  80349e:	ff d0                	callq  *%rax
}
  8034a0:	c9                   	leaveq 
  8034a1:	c3                   	retq   

00000000008034a2 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8034a2:	55                   	push   %rbp
  8034a3:	48 89 e5             	mov    %rsp,%rbp
  8034a6:	48 83 ec 10          	sub    $0x10,%rsp
  8034aa:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8034ad:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8034b4:	00 00 00 
  8034b7:	8b 00                	mov    (%rax),%eax
  8034b9:	85 c0                	test   %eax,%eax
  8034bb:	75 1d                	jne    8034da <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8034bd:	bf 02 00 00 00       	mov    $0x2,%edi
  8034c2:	48 b8 d2 42 80 00 00 	movabs $0x8042d2,%rax
  8034c9:	00 00 00 
  8034cc:	ff d0                	callq  *%rax
  8034ce:	48 ba 08 70 80 00 00 	movabs $0x807008,%rdx
  8034d5:	00 00 00 
  8034d8:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8034da:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8034e1:	00 00 00 
  8034e4:	8b 00                	mov    (%rax),%eax
  8034e6:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8034e9:	b9 07 00 00 00       	mov    $0x7,%ecx
  8034ee:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8034f5:	00 00 00 
  8034f8:	89 c7                	mov    %eax,%edi
  8034fa:	48 b8 70 42 80 00 00 	movabs $0x804270,%rax
  803501:	00 00 00 
  803504:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803506:	ba 00 00 00 00       	mov    $0x0,%edx
  80350b:	be 00 00 00 00       	mov    $0x0,%esi
  803510:	bf 00 00 00 00       	mov    $0x0,%edi
  803515:	48 b8 6a 41 80 00 00 	movabs $0x80416a,%rax
  80351c:	00 00 00 
  80351f:	ff d0                	callq  *%rax
}
  803521:	c9                   	leaveq 
  803522:	c3                   	retq   

0000000000803523 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803523:	55                   	push   %rbp
  803524:	48 89 e5             	mov    %rsp,%rbp
  803527:	48 83 ec 30          	sub    $0x30,%rsp
  80352b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80352e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803532:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803536:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80353d:	00 00 00 
  803540:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803543:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803545:	bf 01 00 00 00       	mov    $0x1,%edi
  80354a:	48 b8 a2 34 80 00 00 	movabs $0x8034a2,%rax
  803551:	00 00 00 
  803554:	ff d0                	callq  *%rax
  803556:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803559:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80355d:	78 3e                	js     80359d <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  80355f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803566:	00 00 00 
  803569:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80356d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803571:	8b 40 10             	mov    0x10(%rax),%eax
  803574:	89 c2                	mov    %eax,%edx
  803576:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80357a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80357e:	48 89 ce             	mov    %rcx,%rsi
  803581:	48 89 c7             	mov    %rax,%rdi
  803584:	48 b8 98 14 80 00 00 	movabs $0x801498,%rax
  80358b:	00 00 00 
  80358e:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803590:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803594:	8b 50 10             	mov    0x10(%rax),%edx
  803597:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80359b:	89 10                	mov    %edx,(%rax)
	}
	return r;
  80359d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8035a0:	c9                   	leaveq 
  8035a1:	c3                   	retq   

00000000008035a2 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8035a2:	55                   	push   %rbp
  8035a3:	48 89 e5             	mov    %rsp,%rbp
  8035a6:	48 83 ec 10          	sub    $0x10,%rsp
  8035aa:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8035ad:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8035b1:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8035b4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035bb:	00 00 00 
  8035be:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8035c1:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8035c3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8035c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035ca:	48 89 c6             	mov    %rax,%rsi
  8035cd:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8035d4:	00 00 00 
  8035d7:	48 b8 98 14 80 00 00 	movabs $0x801498,%rax
  8035de:	00 00 00 
  8035e1:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8035e3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035ea:	00 00 00 
  8035ed:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8035f0:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8035f3:	bf 02 00 00 00       	mov    $0x2,%edi
  8035f8:	48 b8 a2 34 80 00 00 	movabs $0x8034a2,%rax
  8035ff:	00 00 00 
  803602:	ff d0                	callq  *%rax
}
  803604:	c9                   	leaveq 
  803605:	c3                   	retq   

0000000000803606 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803606:	55                   	push   %rbp
  803607:	48 89 e5             	mov    %rsp,%rbp
  80360a:	48 83 ec 10          	sub    $0x10,%rsp
  80360e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803611:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803614:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80361b:	00 00 00 
  80361e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803621:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803623:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80362a:	00 00 00 
  80362d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803630:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803633:	bf 03 00 00 00       	mov    $0x3,%edi
  803638:	48 b8 a2 34 80 00 00 	movabs $0x8034a2,%rax
  80363f:	00 00 00 
  803642:	ff d0                	callq  *%rax
}
  803644:	c9                   	leaveq 
  803645:	c3                   	retq   

0000000000803646 <nsipc_close>:

int
nsipc_close(int s)
{
  803646:	55                   	push   %rbp
  803647:	48 89 e5             	mov    %rsp,%rbp
  80364a:	48 83 ec 10          	sub    $0x10,%rsp
  80364e:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803651:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803658:	00 00 00 
  80365b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80365e:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803660:	bf 04 00 00 00       	mov    $0x4,%edi
  803665:	48 b8 a2 34 80 00 00 	movabs $0x8034a2,%rax
  80366c:	00 00 00 
  80366f:	ff d0                	callq  *%rax
}
  803671:	c9                   	leaveq 
  803672:	c3                   	retq   

0000000000803673 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803673:	55                   	push   %rbp
  803674:	48 89 e5             	mov    %rsp,%rbp
  803677:	48 83 ec 10          	sub    $0x10,%rsp
  80367b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80367e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803682:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803685:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80368c:	00 00 00 
  80368f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803692:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803694:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803697:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80369b:	48 89 c6             	mov    %rax,%rsi
  80369e:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8036a5:	00 00 00 
  8036a8:	48 b8 98 14 80 00 00 	movabs $0x801498,%rax
  8036af:	00 00 00 
  8036b2:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8036b4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036bb:	00 00 00 
  8036be:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8036c1:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8036c4:	bf 05 00 00 00       	mov    $0x5,%edi
  8036c9:	48 b8 a2 34 80 00 00 	movabs $0x8034a2,%rax
  8036d0:	00 00 00 
  8036d3:	ff d0                	callq  *%rax
}
  8036d5:	c9                   	leaveq 
  8036d6:	c3                   	retq   

00000000008036d7 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8036d7:	55                   	push   %rbp
  8036d8:	48 89 e5             	mov    %rsp,%rbp
  8036db:	48 83 ec 10          	sub    $0x10,%rsp
  8036df:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8036e2:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8036e5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036ec:	00 00 00 
  8036ef:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8036f2:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8036f4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036fb:	00 00 00 
  8036fe:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803701:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803704:	bf 06 00 00 00       	mov    $0x6,%edi
  803709:	48 b8 a2 34 80 00 00 	movabs $0x8034a2,%rax
  803710:	00 00 00 
  803713:	ff d0                	callq  *%rax
}
  803715:	c9                   	leaveq 
  803716:	c3                   	retq   

0000000000803717 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803717:	55                   	push   %rbp
  803718:	48 89 e5             	mov    %rsp,%rbp
  80371b:	48 83 ec 30          	sub    $0x30,%rsp
  80371f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803722:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803726:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803729:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  80372c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803733:	00 00 00 
  803736:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803739:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  80373b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803742:	00 00 00 
  803745:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803748:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  80374b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803752:	00 00 00 
  803755:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803758:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80375b:	bf 07 00 00 00       	mov    $0x7,%edi
  803760:	48 b8 a2 34 80 00 00 	movabs $0x8034a2,%rax
  803767:	00 00 00 
  80376a:	ff d0                	callq  *%rax
  80376c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80376f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803773:	78 69                	js     8037de <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803775:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  80377c:	7f 08                	jg     803786 <nsipc_recv+0x6f>
  80377e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803781:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803784:	7e 35                	jle    8037bb <nsipc_recv+0xa4>
  803786:	48 b9 77 4a 80 00 00 	movabs $0x804a77,%rcx
  80378d:	00 00 00 
  803790:	48 ba 8c 4a 80 00 00 	movabs $0x804a8c,%rdx
  803797:	00 00 00 
  80379a:	be 61 00 00 00       	mov    $0x61,%esi
  80379f:	48 bf a1 4a 80 00 00 	movabs $0x804aa1,%rdi
  8037a6:	00 00 00 
  8037a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8037ae:	49 b8 86 03 80 00 00 	movabs $0x800386,%r8
  8037b5:	00 00 00 
  8037b8:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8037bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037be:	48 63 d0             	movslq %eax,%rdx
  8037c1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037c5:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8037cc:	00 00 00 
  8037cf:	48 89 c7             	mov    %rax,%rdi
  8037d2:	48 b8 98 14 80 00 00 	movabs $0x801498,%rax
  8037d9:	00 00 00 
  8037dc:	ff d0                	callq  *%rax
	}

	return r;
  8037de:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8037e1:	c9                   	leaveq 
  8037e2:	c3                   	retq   

00000000008037e3 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8037e3:	55                   	push   %rbp
  8037e4:	48 89 e5             	mov    %rsp,%rbp
  8037e7:	48 83 ec 20          	sub    $0x20,%rsp
  8037eb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8037ee:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8037f2:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8037f5:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8037f8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037ff:	00 00 00 
  803802:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803805:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803807:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  80380e:	7e 35                	jle    803845 <nsipc_send+0x62>
  803810:	48 b9 ad 4a 80 00 00 	movabs $0x804aad,%rcx
  803817:	00 00 00 
  80381a:	48 ba 8c 4a 80 00 00 	movabs $0x804a8c,%rdx
  803821:	00 00 00 
  803824:	be 6c 00 00 00       	mov    $0x6c,%esi
  803829:	48 bf a1 4a 80 00 00 	movabs $0x804aa1,%rdi
  803830:	00 00 00 
  803833:	b8 00 00 00 00       	mov    $0x0,%eax
  803838:	49 b8 86 03 80 00 00 	movabs $0x800386,%r8
  80383f:	00 00 00 
  803842:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803845:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803848:	48 63 d0             	movslq %eax,%rdx
  80384b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80384f:	48 89 c6             	mov    %rax,%rsi
  803852:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803859:	00 00 00 
  80385c:	48 b8 98 14 80 00 00 	movabs $0x801498,%rax
  803863:	00 00 00 
  803866:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803868:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80386f:	00 00 00 
  803872:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803875:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803878:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80387f:	00 00 00 
  803882:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803885:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803888:	bf 08 00 00 00       	mov    $0x8,%edi
  80388d:	48 b8 a2 34 80 00 00 	movabs $0x8034a2,%rax
  803894:	00 00 00 
  803897:	ff d0                	callq  *%rax
}
  803899:	c9                   	leaveq 
  80389a:	c3                   	retq   

000000000080389b <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80389b:	55                   	push   %rbp
  80389c:	48 89 e5             	mov    %rsp,%rbp
  80389f:	48 83 ec 10          	sub    $0x10,%rsp
  8038a3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8038a6:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8038a9:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8038ac:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038b3:	00 00 00 
  8038b6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8038b9:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8038bb:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038c2:	00 00 00 
  8038c5:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8038c8:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8038cb:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038d2:	00 00 00 
  8038d5:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8038d8:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8038db:	bf 09 00 00 00       	mov    $0x9,%edi
  8038e0:	48 b8 a2 34 80 00 00 	movabs $0x8034a2,%rax
  8038e7:	00 00 00 
  8038ea:	ff d0                	callq  *%rax
}
  8038ec:	c9                   	leaveq 
  8038ed:	c3                   	retq   

00000000008038ee <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8038ee:	55                   	push   %rbp
  8038ef:	48 89 e5             	mov    %rsp,%rbp
  8038f2:	53                   	push   %rbx
  8038f3:	48 83 ec 38          	sub    $0x38,%rsp
  8038f7:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8038fb:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8038ff:	48 89 c7             	mov    %rax,%rdi
  803902:	48 b8 28 1e 80 00 00 	movabs $0x801e28,%rax
  803909:	00 00 00 
  80390c:	ff d0                	callq  *%rax
  80390e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803911:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803915:	0f 88 bf 01 00 00    	js     803ada <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80391b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80391f:	ba 07 04 00 00       	mov    $0x407,%edx
  803924:	48 89 c6             	mov    %rax,%rsi
  803927:	bf 00 00 00 00       	mov    $0x0,%edi
  80392c:	48 b8 a3 1a 80 00 00 	movabs $0x801aa3,%rax
  803933:	00 00 00 
  803936:	ff d0                	callq  *%rax
  803938:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80393b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80393f:	0f 88 95 01 00 00    	js     803ada <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803945:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803949:	48 89 c7             	mov    %rax,%rdi
  80394c:	48 b8 28 1e 80 00 00 	movabs $0x801e28,%rax
  803953:	00 00 00 
  803956:	ff d0                	callq  *%rax
  803958:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80395b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80395f:	0f 88 5d 01 00 00    	js     803ac2 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803965:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803969:	ba 07 04 00 00       	mov    $0x407,%edx
  80396e:	48 89 c6             	mov    %rax,%rsi
  803971:	bf 00 00 00 00       	mov    $0x0,%edi
  803976:	48 b8 a3 1a 80 00 00 	movabs $0x801aa3,%rax
  80397d:	00 00 00 
  803980:	ff d0                	callq  *%rax
  803982:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803985:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803989:	0f 88 33 01 00 00    	js     803ac2 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80398f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803993:	48 89 c7             	mov    %rax,%rdi
  803996:	48 b8 fd 1d 80 00 00 	movabs $0x801dfd,%rax
  80399d:	00 00 00 
  8039a0:	ff d0                	callq  *%rax
  8039a2:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8039a6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039aa:	ba 07 04 00 00       	mov    $0x407,%edx
  8039af:	48 89 c6             	mov    %rax,%rsi
  8039b2:	bf 00 00 00 00       	mov    $0x0,%edi
  8039b7:	48 b8 a3 1a 80 00 00 	movabs $0x801aa3,%rax
  8039be:	00 00 00 
  8039c1:	ff d0                	callq  *%rax
  8039c3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8039c6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8039ca:	79 05                	jns    8039d1 <pipe+0xe3>
		goto err2;
  8039cc:	e9 d9 00 00 00       	jmpq   803aaa <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8039d1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039d5:	48 89 c7             	mov    %rax,%rdi
  8039d8:	48 b8 fd 1d 80 00 00 	movabs $0x801dfd,%rax
  8039df:	00 00 00 
  8039e2:	ff d0                	callq  *%rax
  8039e4:	48 89 c2             	mov    %rax,%rdx
  8039e7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039eb:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8039f1:	48 89 d1             	mov    %rdx,%rcx
  8039f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8039f9:	48 89 c6             	mov    %rax,%rsi
  8039fc:	bf 00 00 00 00       	mov    $0x0,%edi
  803a01:	48 b8 f3 1a 80 00 00 	movabs $0x801af3,%rax
  803a08:	00 00 00 
  803a0b:	ff d0                	callq  *%rax
  803a0d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a10:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a14:	79 1b                	jns    803a31 <pipe+0x143>
		goto err3;
  803a16:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803a17:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a1b:	48 89 c6             	mov    %rax,%rsi
  803a1e:	bf 00 00 00 00       	mov    $0x0,%edi
  803a23:	48 b8 4e 1b 80 00 00 	movabs $0x801b4e,%rax
  803a2a:	00 00 00 
  803a2d:	ff d0                	callq  *%rax
  803a2f:	eb 79                	jmp    803aaa <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803a31:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a35:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803a3c:	00 00 00 
  803a3f:	8b 12                	mov    (%rdx),%edx
  803a41:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803a43:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a47:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803a4e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a52:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803a59:	00 00 00 
  803a5c:	8b 12                	mov    (%rdx),%edx
  803a5e:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803a60:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a64:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803a6b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a6f:	48 89 c7             	mov    %rax,%rdi
  803a72:	48 b8 da 1d 80 00 00 	movabs $0x801dda,%rax
  803a79:	00 00 00 
  803a7c:	ff d0                	callq  *%rax
  803a7e:	89 c2                	mov    %eax,%edx
  803a80:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803a84:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803a86:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803a8a:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803a8e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a92:	48 89 c7             	mov    %rax,%rdi
  803a95:	48 b8 da 1d 80 00 00 	movabs $0x801dda,%rax
  803a9c:	00 00 00 
  803a9f:	ff d0                	callq  *%rax
  803aa1:	89 03                	mov    %eax,(%rbx)
	return 0;
  803aa3:	b8 00 00 00 00       	mov    $0x0,%eax
  803aa8:	eb 33                	jmp    803add <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803aaa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803aae:	48 89 c6             	mov    %rax,%rsi
  803ab1:	bf 00 00 00 00       	mov    $0x0,%edi
  803ab6:	48 b8 4e 1b 80 00 00 	movabs $0x801b4e,%rax
  803abd:	00 00 00 
  803ac0:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803ac2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ac6:	48 89 c6             	mov    %rax,%rsi
  803ac9:	bf 00 00 00 00       	mov    $0x0,%edi
  803ace:	48 b8 4e 1b 80 00 00 	movabs $0x801b4e,%rax
  803ad5:	00 00 00 
  803ad8:	ff d0                	callq  *%rax
err:
	return r;
  803ada:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803add:	48 83 c4 38          	add    $0x38,%rsp
  803ae1:	5b                   	pop    %rbx
  803ae2:	5d                   	pop    %rbp
  803ae3:	c3                   	retq   

0000000000803ae4 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803ae4:	55                   	push   %rbp
  803ae5:	48 89 e5             	mov    %rsp,%rbp
  803ae8:	53                   	push   %rbx
  803ae9:	48 83 ec 28          	sub    $0x28,%rsp
  803aed:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803af1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803af5:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  803afc:	00 00 00 
  803aff:	48 8b 00             	mov    (%rax),%rax
  803b02:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803b08:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803b0b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b0f:	48 89 c7             	mov    %rax,%rdi
  803b12:	48 b8 54 43 80 00 00 	movabs $0x804354,%rax
  803b19:	00 00 00 
  803b1c:	ff d0                	callq  *%rax
  803b1e:	89 c3                	mov    %eax,%ebx
  803b20:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b24:	48 89 c7             	mov    %rax,%rdi
  803b27:	48 b8 54 43 80 00 00 	movabs $0x804354,%rax
  803b2e:	00 00 00 
  803b31:	ff d0                	callq  *%rax
  803b33:	39 c3                	cmp    %eax,%ebx
  803b35:	0f 94 c0             	sete   %al
  803b38:	0f b6 c0             	movzbl %al,%eax
  803b3b:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803b3e:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  803b45:	00 00 00 
  803b48:	48 8b 00             	mov    (%rax),%rax
  803b4b:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803b51:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803b54:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b57:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803b5a:	75 05                	jne    803b61 <_pipeisclosed+0x7d>
			return ret;
  803b5c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803b5f:	eb 4f                	jmp    803bb0 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803b61:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b64:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803b67:	74 42                	je     803bab <_pipeisclosed+0xc7>
  803b69:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803b6d:	75 3c                	jne    803bab <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803b6f:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  803b76:	00 00 00 
  803b79:	48 8b 00             	mov    (%rax),%rax
  803b7c:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803b82:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803b85:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b88:	89 c6                	mov    %eax,%esi
  803b8a:	48 bf be 4a 80 00 00 	movabs $0x804abe,%rdi
  803b91:	00 00 00 
  803b94:	b8 00 00 00 00       	mov    $0x0,%eax
  803b99:	49 b8 bf 05 80 00 00 	movabs $0x8005bf,%r8
  803ba0:	00 00 00 
  803ba3:	41 ff d0             	callq  *%r8
	}
  803ba6:	e9 4a ff ff ff       	jmpq   803af5 <_pipeisclosed+0x11>
  803bab:	e9 45 ff ff ff       	jmpq   803af5 <_pipeisclosed+0x11>
}
  803bb0:	48 83 c4 28          	add    $0x28,%rsp
  803bb4:	5b                   	pop    %rbx
  803bb5:	5d                   	pop    %rbp
  803bb6:	c3                   	retq   

0000000000803bb7 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803bb7:	55                   	push   %rbp
  803bb8:	48 89 e5             	mov    %rsp,%rbp
  803bbb:	48 83 ec 30          	sub    $0x30,%rsp
  803bbf:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803bc2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803bc6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803bc9:	48 89 d6             	mov    %rdx,%rsi
  803bcc:	89 c7                	mov    %eax,%edi
  803bce:	48 b8 c0 1e 80 00 00 	movabs $0x801ec0,%rax
  803bd5:	00 00 00 
  803bd8:	ff d0                	callq  *%rax
  803bda:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bdd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803be1:	79 05                	jns    803be8 <pipeisclosed+0x31>
		return r;
  803be3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803be6:	eb 31                	jmp    803c19 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803be8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bec:	48 89 c7             	mov    %rax,%rdi
  803bef:	48 b8 fd 1d 80 00 00 	movabs $0x801dfd,%rax
  803bf6:	00 00 00 
  803bf9:	ff d0                	callq  *%rax
  803bfb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803bff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c03:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803c07:	48 89 d6             	mov    %rdx,%rsi
  803c0a:	48 89 c7             	mov    %rax,%rdi
  803c0d:	48 b8 e4 3a 80 00 00 	movabs $0x803ae4,%rax
  803c14:	00 00 00 
  803c17:	ff d0                	callq  *%rax
}
  803c19:	c9                   	leaveq 
  803c1a:	c3                   	retq   

0000000000803c1b <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803c1b:	55                   	push   %rbp
  803c1c:	48 89 e5             	mov    %rsp,%rbp
  803c1f:	48 83 ec 40          	sub    $0x40,%rsp
  803c23:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803c27:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803c2b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803c2f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c33:	48 89 c7             	mov    %rax,%rdi
  803c36:	48 b8 fd 1d 80 00 00 	movabs $0x801dfd,%rax
  803c3d:	00 00 00 
  803c40:	ff d0                	callq  *%rax
  803c42:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803c46:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c4a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803c4e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803c55:	00 
  803c56:	e9 92 00 00 00       	jmpq   803ced <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803c5b:	eb 41                	jmp    803c9e <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803c5d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803c62:	74 09                	je     803c6d <devpipe_read+0x52>
				return i;
  803c64:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c68:	e9 92 00 00 00       	jmpq   803cff <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803c6d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803c71:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c75:	48 89 d6             	mov    %rdx,%rsi
  803c78:	48 89 c7             	mov    %rax,%rdi
  803c7b:	48 b8 e4 3a 80 00 00 	movabs $0x803ae4,%rax
  803c82:	00 00 00 
  803c85:	ff d0                	callq  *%rax
  803c87:	85 c0                	test   %eax,%eax
  803c89:	74 07                	je     803c92 <devpipe_read+0x77>
				return 0;
  803c8b:	b8 00 00 00 00       	mov    $0x0,%eax
  803c90:	eb 6d                	jmp    803cff <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803c92:	48 b8 65 1a 80 00 00 	movabs $0x801a65,%rax
  803c99:	00 00 00 
  803c9c:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803c9e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ca2:	8b 10                	mov    (%rax),%edx
  803ca4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ca8:	8b 40 04             	mov    0x4(%rax),%eax
  803cab:	39 c2                	cmp    %eax,%edx
  803cad:	74 ae                	je     803c5d <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803caf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cb3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803cb7:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803cbb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cbf:	8b 00                	mov    (%rax),%eax
  803cc1:	99                   	cltd   
  803cc2:	c1 ea 1b             	shr    $0x1b,%edx
  803cc5:	01 d0                	add    %edx,%eax
  803cc7:	83 e0 1f             	and    $0x1f,%eax
  803cca:	29 d0                	sub    %edx,%eax
  803ccc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803cd0:	48 98                	cltq   
  803cd2:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803cd7:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803cd9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cdd:	8b 00                	mov    (%rax),%eax
  803cdf:	8d 50 01             	lea    0x1(%rax),%edx
  803ce2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ce6:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803ce8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803ced:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cf1:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803cf5:	0f 82 60 ff ff ff    	jb     803c5b <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803cfb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803cff:	c9                   	leaveq 
  803d00:	c3                   	retq   

0000000000803d01 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803d01:	55                   	push   %rbp
  803d02:	48 89 e5             	mov    %rsp,%rbp
  803d05:	48 83 ec 40          	sub    $0x40,%rsp
  803d09:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803d0d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803d11:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803d15:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d19:	48 89 c7             	mov    %rax,%rdi
  803d1c:	48 b8 fd 1d 80 00 00 	movabs $0x801dfd,%rax
  803d23:	00 00 00 
  803d26:	ff d0                	callq  *%rax
  803d28:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803d2c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d30:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803d34:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803d3b:	00 
  803d3c:	e9 8e 00 00 00       	jmpq   803dcf <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803d41:	eb 31                	jmp    803d74 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803d43:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d47:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d4b:	48 89 d6             	mov    %rdx,%rsi
  803d4e:	48 89 c7             	mov    %rax,%rdi
  803d51:	48 b8 e4 3a 80 00 00 	movabs $0x803ae4,%rax
  803d58:	00 00 00 
  803d5b:	ff d0                	callq  *%rax
  803d5d:	85 c0                	test   %eax,%eax
  803d5f:	74 07                	je     803d68 <devpipe_write+0x67>
				return 0;
  803d61:	b8 00 00 00 00       	mov    $0x0,%eax
  803d66:	eb 79                	jmp    803de1 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803d68:	48 b8 65 1a 80 00 00 	movabs $0x801a65,%rax
  803d6f:	00 00 00 
  803d72:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803d74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d78:	8b 40 04             	mov    0x4(%rax),%eax
  803d7b:	48 63 d0             	movslq %eax,%rdx
  803d7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d82:	8b 00                	mov    (%rax),%eax
  803d84:	48 98                	cltq   
  803d86:	48 83 c0 20          	add    $0x20,%rax
  803d8a:	48 39 c2             	cmp    %rax,%rdx
  803d8d:	73 b4                	jae    803d43 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803d8f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d93:	8b 40 04             	mov    0x4(%rax),%eax
  803d96:	99                   	cltd   
  803d97:	c1 ea 1b             	shr    $0x1b,%edx
  803d9a:	01 d0                	add    %edx,%eax
  803d9c:	83 e0 1f             	and    $0x1f,%eax
  803d9f:	29 d0                	sub    %edx,%eax
  803da1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803da5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803da9:	48 01 ca             	add    %rcx,%rdx
  803dac:	0f b6 0a             	movzbl (%rdx),%ecx
  803daf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803db3:	48 98                	cltq   
  803db5:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803db9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dbd:	8b 40 04             	mov    0x4(%rax),%eax
  803dc0:	8d 50 01             	lea    0x1(%rax),%edx
  803dc3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dc7:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803dca:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803dcf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803dd3:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803dd7:	0f 82 64 ff ff ff    	jb     803d41 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803ddd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803de1:	c9                   	leaveq 
  803de2:	c3                   	retq   

0000000000803de3 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803de3:	55                   	push   %rbp
  803de4:	48 89 e5             	mov    %rsp,%rbp
  803de7:	48 83 ec 20          	sub    $0x20,%rsp
  803deb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803def:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803df3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803df7:	48 89 c7             	mov    %rax,%rdi
  803dfa:	48 b8 fd 1d 80 00 00 	movabs $0x801dfd,%rax
  803e01:	00 00 00 
  803e04:	ff d0                	callq  *%rax
  803e06:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803e0a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e0e:	48 be d1 4a 80 00 00 	movabs $0x804ad1,%rsi
  803e15:	00 00 00 
  803e18:	48 89 c7             	mov    %rax,%rdi
  803e1b:	48 b8 74 11 80 00 00 	movabs $0x801174,%rax
  803e22:	00 00 00 
  803e25:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803e27:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e2b:	8b 50 04             	mov    0x4(%rax),%edx
  803e2e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e32:	8b 00                	mov    (%rax),%eax
  803e34:	29 c2                	sub    %eax,%edx
  803e36:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e3a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803e40:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e44:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803e4b:	00 00 00 
	stat->st_dev = &devpipe;
  803e4e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e52:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803e59:	00 00 00 
  803e5c:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803e63:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e68:	c9                   	leaveq 
  803e69:	c3                   	retq   

0000000000803e6a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803e6a:	55                   	push   %rbp
  803e6b:	48 89 e5             	mov    %rsp,%rbp
  803e6e:	48 83 ec 10          	sub    $0x10,%rsp
  803e72:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803e76:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e7a:	48 89 c6             	mov    %rax,%rsi
  803e7d:	bf 00 00 00 00       	mov    $0x0,%edi
  803e82:	48 b8 4e 1b 80 00 00 	movabs $0x801b4e,%rax
  803e89:	00 00 00 
  803e8c:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803e8e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e92:	48 89 c7             	mov    %rax,%rdi
  803e95:	48 b8 fd 1d 80 00 00 	movabs $0x801dfd,%rax
  803e9c:	00 00 00 
  803e9f:	ff d0                	callq  *%rax
  803ea1:	48 89 c6             	mov    %rax,%rsi
  803ea4:	bf 00 00 00 00       	mov    $0x0,%edi
  803ea9:	48 b8 4e 1b 80 00 00 	movabs $0x801b4e,%rax
  803eb0:	00 00 00 
  803eb3:	ff d0                	callq  *%rax
}
  803eb5:	c9                   	leaveq 
  803eb6:	c3                   	retq   

0000000000803eb7 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803eb7:	55                   	push   %rbp
  803eb8:	48 89 e5             	mov    %rsp,%rbp
  803ebb:	48 83 ec 20          	sub    $0x20,%rsp
  803ebf:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803ec2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ec5:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803ec8:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803ecc:	be 01 00 00 00       	mov    $0x1,%esi
  803ed1:	48 89 c7             	mov    %rax,%rdi
  803ed4:	48 b8 5b 19 80 00 00 	movabs $0x80195b,%rax
  803edb:	00 00 00 
  803ede:	ff d0                	callq  *%rax
}
  803ee0:	c9                   	leaveq 
  803ee1:	c3                   	retq   

0000000000803ee2 <getchar>:

int
getchar(void)
{
  803ee2:	55                   	push   %rbp
  803ee3:	48 89 e5             	mov    %rsp,%rbp
  803ee6:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803eea:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803eee:	ba 01 00 00 00       	mov    $0x1,%edx
  803ef3:	48 89 c6             	mov    %rax,%rsi
  803ef6:	bf 00 00 00 00       	mov    $0x0,%edi
  803efb:	48 b8 f2 22 80 00 00 	movabs $0x8022f2,%rax
  803f02:	00 00 00 
  803f05:	ff d0                	callq  *%rax
  803f07:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803f0a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f0e:	79 05                	jns    803f15 <getchar+0x33>
		return r;
  803f10:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f13:	eb 14                	jmp    803f29 <getchar+0x47>
	if (r < 1)
  803f15:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f19:	7f 07                	jg     803f22 <getchar+0x40>
		return -E_EOF;
  803f1b:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803f20:	eb 07                	jmp    803f29 <getchar+0x47>
	return c;
  803f22:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803f26:	0f b6 c0             	movzbl %al,%eax
}
  803f29:	c9                   	leaveq 
  803f2a:	c3                   	retq   

0000000000803f2b <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803f2b:	55                   	push   %rbp
  803f2c:	48 89 e5             	mov    %rsp,%rbp
  803f2f:	48 83 ec 20          	sub    $0x20,%rsp
  803f33:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803f36:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803f3a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f3d:	48 89 d6             	mov    %rdx,%rsi
  803f40:	89 c7                	mov    %eax,%edi
  803f42:	48 b8 c0 1e 80 00 00 	movabs $0x801ec0,%rax
  803f49:	00 00 00 
  803f4c:	ff d0                	callq  *%rax
  803f4e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f51:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f55:	79 05                	jns    803f5c <iscons+0x31>
		return r;
  803f57:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f5a:	eb 1a                	jmp    803f76 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803f5c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f60:	8b 10                	mov    (%rax),%edx
  803f62:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803f69:	00 00 00 
  803f6c:	8b 00                	mov    (%rax),%eax
  803f6e:	39 c2                	cmp    %eax,%edx
  803f70:	0f 94 c0             	sete   %al
  803f73:	0f b6 c0             	movzbl %al,%eax
}
  803f76:	c9                   	leaveq 
  803f77:	c3                   	retq   

0000000000803f78 <opencons>:

int
opencons(void)
{
  803f78:	55                   	push   %rbp
  803f79:	48 89 e5             	mov    %rsp,%rbp
  803f7c:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803f80:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803f84:	48 89 c7             	mov    %rax,%rdi
  803f87:	48 b8 28 1e 80 00 00 	movabs $0x801e28,%rax
  803f8e:	00 00 00 
  803f91:	ff d0                	callq  *%rax
  803f93:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f96:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f9a:	79 05                	jns    803fa1 <opencons+0x29>
		return r;
  803f9c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f9f:	eb 5b                	jmp    803ffc <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803fa1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fa5:	ba 07 04 00 00       	mov    $0x407,%edx
  803faa:	48 89 c6             	mov    %rax,%rsi
  803fad:	bf 00 00 00 00       	mov    $0x0,%edi
  803fb2:	48 b8 a3 1a 80 00 00 	movabs $0x801aa3,%rax
  803fb9:	00 00 00 
  803fbc:	ff d0                	callq  *%rax
  803fbe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fc1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fc5:	79 05                	jns    803fcc <opencons+0x54>
		return r;
  803fc7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fca:	eb 30                	jmp    803ffc <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803fcc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fd0:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803fd7:	00 00 00 
  803fda:	8b 12                	mov    (%rdx),%edx
  803fdc:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803fde:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fe2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803fe9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fed:	48 89 c7             	mov    %rax,%rdi
  803ff0:	48 b8 da 1d 80 00 00 	movabs $0x801dda,%rax
  803ff7:	00 00 00 
  803ffa:	ff d0                	callq  *%rax
}
  803ffc:	c9                   	leaveq 
  803ffd:	c3                   	retq   

0000000000803ffe <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803ffe:	55                   	push   %rbp
  803fff:	48 89 e5             	mov    %rsp,%rbp
  804002:	48 83 ec 30          	sub    $0x30,%rsp
  804006:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80400a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80400e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804012:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804017:	75 07                	jne    804020 <devcons_read+0x22>
		return 0;
  804019:	b8 00 00 00 00       	mov    $0x0,%eax
  80401e:	eb 4b                	jmp    80406b <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  804020:	eb 0c                	jmp    80402e <devcons_read+0x30>
		sys_yield();
  804022:	48 b8 65 1a 80 00 00 	movabs $0x801a65,%rax
  804029:	00 00 00 
  80402c:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80402e:	48 b8 a5 19 80 00 00 	movabs $0x8019a5,%rax
  804035:	00 00 00 
  804038:	ff d0                	callq  *%rax
  80403a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80403d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804041:	74 df                	je     804022 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  804043:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804047:	79 05                	jns    80404e <devcons_read+0x50>
		return c;
  804049:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80404c:	eb 1d                	jmp    80406b <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80404e:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804052:	75 07                	jne    80405b <devcons_read+0x5d>
		return 0;
  804054:	b8 00 00 00 00       	mov    $0x0,%eax
  804059:	eb 10                	jmp    80406b <devcons_read+0x6d>
	*(char*)vbuf = c;
  80405b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80405e:	89 c2                	mov    %eax,%edx
  804060:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804064:	88 10                	mov    %dl,(%rax)
	return 1;
  804066:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80406b:	c9                   	leaveq 
  80406c:	c3                   	retq   

000000000080406d <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80406d:	55                   	push   %rbp
  80406e:	48 89 e5             	mov    %rsp,%rbp
  804071:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804078:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80407f:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804086:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80408d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804094:	eb 76                	jmp    80410c <devcons_write+0x9f>
		m = n - tot;
  804096:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80409d:	89 c2                	mov    %eax,%edx
  80409f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040a2:	29 c2                	sub    %eax,%edx
  8040a4:	89 d0                	mov    %edx,%eax
  8040a6:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8040a9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8040ac:	83 f8 7f             	cmp    $0x7f,%eax
  8040af:	76 07                	jbe    8040b8 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8040b1:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8040b8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8040bb:	48 63 d0             	movslq %eax,%rdx
  8040be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040c1:	48 63 c8             	movslq %eax,%rcx
  8040c4:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8040cb:	48 01 c1             	add    %rax,%rcx
  8040ce:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8040d5:	48 89 ce             	mov    %rcx,%rsi
  8040d8:	48 89 c7             	mov    %rax,%rdi
  8040db:	48 b8 98 14 80 00 00 	movabs $0x801498,%rax
  8040e2:	00 00 00 
  8040e5:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8040e7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8040ea:	48 63 d0             	movslq %eax,%rdx
  8040ed:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8040f4:	48 89 d6             	mov    %rdx,%rsi
  8040f7:	48 89 c7             	mov    %rax,%rdi
  8040fa:	48 b8 5b 19 80 00 00 	movabs $0x80195b,%rax
  804101:	00 00 00 
  804104:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804106:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804109:	01 45 fc             	add    %eax,-0x4(%rbp)
  80410c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80410f:	48 98                	cltq   
  804111:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804118:	0f 82 78 ff ff ff    	jb     804096 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80411e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804121:	c9                   	leaveq 
  804122:	c3                   	retq   

0000000000804123 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804123:	55                   	push   %rbp
  804124:	48 89 e5             	mov    %rsp,%rbp
  804127:	48 83 ec 08          	sub    $0x8,%rsp
  80412b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80412f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804134:	c9                   	leaveq 
  804135:	c3                   	retq   

0000000000804136 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804136:	55                   	push   %rbp
  804137:	48 89 e5             	mov    %rsp,%rbp
  80413a:	48 83 ec 10          	sub    $0x10,%rsp
  80413e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804142:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804146:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80414a:	48 be dd 4a 80 00 00 	movabs $0x804add,%rsi
  804151:	00 00 00 
  804154:	48 89 c7             	mov    %rax,%rdi
  804157:	48 b8 74 11 80 00 00 	movabs $0x801174,%rax
  80415e:	00 00 00 
  804161:	ff d0                	callq  *%rax
	return 0;
  804163:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804168:	c9                   	leaveq 
  804169:	c3                   	retq   

000000000080416a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80416a:	55                   	push   %rbp
  80416b:	48 89 e5             	mov    %rsp,%rbp
  80416e:	48 83 ec 30          	sub    $0x30,%rsp
  804172:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804176:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80417a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  80417e:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  804185:	00 00 00 
  804188:	48 8b 00             	mov    (%rax),%rax
  80418b:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  804191:	85 c0                	test   %eax,%eax
  804193:	75 3c                	jne    8041d1 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  804195:	48 b8 27 1a 80 00 00 	movabs $0x801a27,%rax
  80419c:	00 00 00 
  80419f:	ff d0                	callq  *%rax
  8041a1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8041a6:	48 63 d0             	movslq %eax,%rdx
  8041a9:	48 89 d0             	mov    %rdx,%rax
  8041ac:	48 c1 e0 03          	shl    $0x3,%rax
  8041b0:	48 01 d0             	add    %rdx,%rax
  8041b3:	48 c1 e0 05          	shl    $0x5,%rax
  8041b7:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8041be:	00 00 00 
  8041c1:	48 01 c2             	add    %rax,%rdx
  8041c4:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8041cb:	00 00 00 
  8041ce:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  8041d1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8041d6:	75 0e                	jne    8041e6 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  8041d8:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8041df:	00 00 00 
  8041e2:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  8041e6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041ea:	48 89 c7             	mov    %rax,%rdi
  8041ed:	48 b8 cc 1c 80 00 00 	movabs $0x801ccc,%rax
  8041f4:	00 00 00 
  8041f7:	ff d0                	callq  *%rax
  8041f9:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  8041fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804200:	79 19                	jns    80421b <ipc_recv+0xb1>
		*from_env_store = 0;
  804202:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804206:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  80420c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804210:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  804216:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804219:	eb 53                	jmp    80426e <ipc_recv+0x104>
	}
	if(from_env_store)
  80421b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804220:	74 19                	je     80423b <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  804222:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  804229:	00 00 00 
  80422c:	48 8b 00             	mov    (%rax),%rax
  80422f:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804235:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804239:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  80423b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804240:	74 19                	je     80425b <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  804242:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  804249:	00 00 00 
  80424c:	48 8b 00             	mov    (%rax),%rax
  80424f:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804255:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804259:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  80425b:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  804262:	00 00 00 
  804265:	48 8b 00             	mov    (%rax),%rax
  804268:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  80426e:	c9                   	leaveq 
  80426f:	c3                   	retq   

0000000000804270 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804270:	55                   	push   %rbp
  804271:	48 89 e5             	mov    %rsp,%rbp
  804274:	48 83 ec 30          	sub    $0x30,%rsp
  804278:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80427b:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80427e:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804282:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  804285:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80428a:	75 0e                	jne    80429a <ipc_send+0x2a>
		pg = (void*)UTOP;
  80428c:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804293:	00 00 00 
  804296:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  80429a:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80429d:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8042a0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8042a4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8042a7:	89 c7                	mov    %eax,%edi
  8042a9:	48 b8 77 1c 80 00 00 	movabs $0x801c77,%rax
  8042b0:	00 00 00 
  8042b3:	ff d0                	callq  *%rax
  8042b5:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  8042b8:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8042bc:	75 0c                	jne    8042ca <ipc_send+0x5a>
			sys_yield();
  8042be:	48 b8 65 1a 80 00 00 	movabs $0x801a65,%rax
  8042c5:	00 00 00 
  8042c8:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  8042ca:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8042ce:	74 ca                	je     80429a <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  8042d0:	c9                   	leaveq 
  8042d1:	c3                   	retq   

00000000008042d2 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8042d2:	55                   	push   %rbp
  8042d3:	48 89 e5             	mov    %rsp,%rbp
  8042d6:	48 83 ec 14          	sub    $0x14,%rsp
  8042da:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8042dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8042e4:	eb 5e                	jmp    804344 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8042e6:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8042ed:	00 00 00 
  8042f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042f3:	48 63 d0             	movslq %eax,%rdx
  8042f6:	48 89 d0             	mov    %rdx,%rax
  8042f9:	48 c1 e0 03          	shl    $0x3,%rax
  8042fd:	48 01 d0             	add    %rdx,%rax
  804300:	48 c1 e0 05          	shl    $0x5,%rax
  804304:	48 01 c8             	add    %rcx,%rax
  804307:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80430d:	8b 00                	mov    (%rax),%eax
  80430f:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804312:	75 2c                	jne    804340 <ipc_find_env+0x6e>
			return envs[i].env_id;
  804314:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80431b:	00 00 00 
  80431e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804321:	48 63 d0             	movslq %eax,%rdx
  804324:	48 89 d0             	mov    %rdx,%rax
  804327:	48 c1 e0 03          	shl    $0x3,%rax
  80432b:	48 01 d0             	add    %rdx,%rax
  80432e:	48 c1 e0 05          	shl    $0x5,%rax
  804332:	48 01 c8             	add    %rcx,%rax
  804335:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80433b:	8b 40 08             	mov    0x8(%rax),%eax
  80433e:	eb 12                	jmp    804352 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804340:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804344:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80434b:	7e 99                	jle    8042e6 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  80434d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804352:	c9                   	leaveq 
  804353:	c3                   	retq   

0000000000804354 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804354:	55                   	push   %rbp
  804355:	48 89 e5             	mov    %rsp,%rbp
  804358:	48 83 ec 18          	sub    $0x18,%rsp
  80435c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804360:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804364:	48 c1 e8 15          	shr    $0x15,%rax
  804368:	48 89 c2             	mov    %rax,%rdx
  80436b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804372:	01 00 00 
  804375:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804379:	83 e0 01             	and    $0x1,%eax
  80437c:	48 85 c0             	test   %rax,%rax
  80437f:	75 07                	jne    804388 <pageref+0x34>
		return 0;
  804381:	b8 00 00 00 00       	mov    $0x0,%eax
  804386:	eb 53                	jmp    8043db <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804388:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80438c:	48 c1 e8 0c          	shr    $0xc,%rax
  804390:	48 89 c2             	mov    %rax,%rdx
  804393:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80439a:	01 00 00 
  80439d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8043a1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8043a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043a9:	83 e0 01             	and    $0x1,%eax
  8043ac:	48 85 c0             	test   %rax,%rax
  8043af:	75 07                	jne    8043b8 <pageref+0x64>
		return 0;
  8043b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8043b6:	eb 23                	jmp    8043db <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8043b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043bc:	48 c1 e8 0c          	shr    $0xc,%rax
  8043c0:	48 89 c2             	mov    %rax,%rdx
  8043c3:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8043ca:	00 00 00 
  8043cd:	48 c1 e2 04          	shl    $0x4,%rdx
  8043d1:	48 01 d0             	add    %rdx,%rax
  8043d4:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8043d8:	0f b7 c0             	movzwl %ax,%eax
}
  8043db:	c9                   	leaveq 
  8043dc:	c3                   	retq   
