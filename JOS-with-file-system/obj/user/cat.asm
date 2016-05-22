
obj/user/cat.debug:     file format elf64-x86-64


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
  80003c:	e8 08 02 00 00       	callq  800249 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <cat>:

char buf[8192];

void
cat(int f, char *s)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  800052:	eb 68                	jmp    8000bc <cat+0x79>
		if ((r = write(1, buf, n)) != n)
  800054:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800058:	48 89 c2             	mov    %rax,%rdx
  80005b:	48 be 20 60 80 00 00 	movabs $0x806020,%rsi
  800062:	00 00 00 
  800065:	bf 01 00 00 00       	mov    $0x1,%edi
  80006a:	48 b8 e3 22 80 00 00 	movabs $0x8022e3,%rax
  800071:	00 00 00 
  800074:	ff d0                	callq  *%rax
  800076:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800079:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80007c:	48 98                	cltq   
  80007e:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  800082:	74 38                	je     8000bc <cat+0x79>
			panic("write error copying %s: %e", s, r);
  800084:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800087:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80008b:	41 89 d0             	mov    %edx,%r8d
  80008e:	48 89 c1             	mov    %rax,%rcx
  800091:	48 ba a0 38 80 00 00 	movabs $0x8038a0,%rdx
  800098:	00 00 00 
  80009b:	be 0d 00 00 00       	mov    $0xd,%esi
  8000a0:	48 bf bb 38 80 00 00 	movabs $0x8038bb,%rdi
  8000a7:	00 00 00 
  8000aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8000af:	49 b9 f7 02 80 00 00 	movabs $0x8002f7,%r9
  8000b6:	00 00 00 
  8000b9:	41 ff d1             	callq  *%r9
cat(int f, char *s)
{
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  8000bc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000bf:	ba 00 20 00 00       	mov    $0x2000,%edx
  8000c4:	48 be 20 60 80 00 00 	movabs $0x806020,%rsi
  8000cb:	00 00 00 
  8000ce:	89 c7                	mov    %eax,%edi
  8000d0:	48 b8 99 21 80 00 00 	movabs $0x802199,%rax
  8000d7:	00 00 00 
  8000da:	ff d0                	callq  *%rax
  8000dc:	48 98                	cltq   
  8000de:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8000e2:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8000e7:	0f 8f 67 ff ff ff    	jg     800054 <cat+0x11>
		if ((r = write(1, buf, n)) != n)
			panic("write error copying %s: %e", s, r);
	if (n < 0)
  8000ed:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8000f2:	79 39                	jns    80012d <cat+0xea>
		panic("error reading %s: %e", s, n);
  8000f4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8000f8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000fc:	49 89 d0             	mov    %rdx,%r8
  8000ff:	48 89 c1             	mov    %rax,%rcx
  800102:	48 ba c6 38 80 00 00 	movabs $0x8038c6,%rdx
  800109:	00 00 00 
  80010c:	be 0f 00 00 00       	mov    $0xf,%esi
  800111:	48 bf bb 38 80 00 00 	movabs $0x8038bb,%rdi
  800118:	00 00 00 
  80011b:	b8 00 00 00 00       	mov    $0x0,%eax
  800120:	49 b9 f7 02 80 00 00 	movabs $0x8002f7,%r9
  800127:	00 00 00 
  80012a:	41 ff d1             	callq  *%r9
}
  80012d:	c9                   	leaveq 
  80012e:	c3                   	retq   

000000000080012f <umain>:

void
umain(int argc, char **argv)
{
  80012f:	55                   	push   %rbp
  800130:	48 89 e5             	mov    %rsp,%rbp
  800133:	53                   	push   %rbx
  800134:	48 83 ec 28          	sub    $0x28,%rsp
  800138:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80013b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int f, i;

	binaryname = "cat";
  80013f:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800146:	00 00 00 
  800149:	48 bb db 38 80 00 00 	movabs $0x8038db,%rbx
  800150:	00 00 00 
  800153:	48 89 18             	mov    %rbx,(%rax)
	if (argc == 1)
  800156:	83 7d dc 01          	cmpl   $0x1,-0x24(%rbp)
  80015a:	75 20                	jne    80017c <umain+0x4d>
		cat(0, "<stdin>");
  80015c:	48 be df 38 80 00 00 	movabs $0x8038df,%rsi
  800163:	00 00 00 
  800166:	bf 00 00 00 00       	mov    $0x0,%edi
  80016b:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800172:	00 00 00 
  800175:	ff d0                	callq  *%rax
  800177:	e9 c6 00 00 00       	jmpq   800242 <umain+0x113>
	else
		for (i = 1; i < argc; i++) {
  80017c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%rbp)
  800183:	e9 ae 00 00 00       	jmpq   800236 <umain+0x107>
			f = open(argv[i], O_RDONLY);
  800188:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80018b:	48 98                	cltq   
  80018d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800194:	00 
  800195:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800199:	48 01 d0             	add    %rdx,%rax
  80019c:	48 8b 00             	mov    (%rax),%rax
  80019f:	be 00 00 00 00       	mov    $0x0,%esi
  8001a4:	48 89 c7             	mov    %rax,%rdi
  8001a7:	48 b8 6f 26 80 00 00 	movabs $0x80266f,%rax
  8001ae:	00 00 00 
  8001b1:	ff d0                	callq  *%rax
  8001b3:	89 45 e8             	mov    %eax,-0x18(%rbp)
			if (f < 0)
  8001b6:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8001ba:	79 3a                	jns    8001f6 <umain+0xc7>
				printf("can't open %s: %e\n", argv[i], f);
  8001bc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001bf:	48 98                	cltq   
  8001c1:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8001c8:	00 
  8001c9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8001cd:	48 01 d0             	add    %rdx,%rax
  8001d0:	48 8b 00             	mov    (%rax),%rax
  8001d3:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8001d6:	48 89 c6             	mov    %rax,%rsi
  8001d9:	48 bf e7 38 80 00 00 	movabs $0x8038e7,%rdi
  8001e0:	00 00 00 
  8001e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e8:	48 b9 f8 2c 80 00 00 	movabs $0x802cf8,%rcx
  8001ef:	00 00 00 
  8001f2:	ff d1                	callq  *%rcx
  8001f4:	eb 3c                	jmp    800232 <umain+0x103>
			else {
				cat(f, argv[i]);
  8001f6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001f9:	48 98                	cltq   
  8001fb:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800202:	00 
  800203:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800207:	48 01 d0             	add    %rdx,%rax
  80020a:	48 8b 10             	mov    (%rax),%rdx
  80020d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800210:	48 89 d6             	mov    %rdx,%rsi
  800213:	89 c7                	mov    %eax,%edi
  800215:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80021c:	00 00 00 
  80021f:	ff d0                	callq  *%rax
				close(f);
  800221:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800224:	89 c7                	mov    %eax,%edi
  800226:	48 b8 77 1f 80 00 00 	movabs $0x801f77,%rax
  80022d:	00 00 00 
  800230:	ff d0                	callq  *%rax

	binaryname = "cat";
	if (argc == 1)
		cat(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  800232:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  800236:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800239:	3b 45 dc             	cmp    -0x24(%rbp),%eax
  80023c:	0f 8c 46 ff ff ff    	jl     800188 <umain+0x59>
			else {
				cat(f, argv[i]);
				close(f);
			}
		}
}
  800242:	48 83 c4 28          	add    $0x28,%rsp
  800246:	5b                   	pop    %rbx
  800247:	5d                   	pop    %rbp
  800248:	c3                   	retq   

0000000000800249 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800249:	55                   	push   %rbp
  80024a:	48 89 e5             	mov    %rsp,%rbp
  80024d:	48 83 ec 10          	sub    $0x10,%rsp
  800251:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800254:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800258:	48 b8 98 19 80 00 00 	movabs $0x801998,%rax
  80025f:	00 00 00 
  800262:	ff d0                	callq  *%rax
  800264:	25 ff 03 00 00       	and    $0x3ff,%eax
  800269:	48 63 d0             	movslq %eax,%rdx
  80026c:	48 89 d0             	mov    %rdx,%rax
  80026f:	48 c1 e0 03          	shl    $0x3,%rax
  800273:	48 01 d0             	add    %rdx,%rax
  800276:	48 c1 e0 05          	shl    $0x5,%rax
  80027a:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800281:	00 00 00 
  800284:	48 01 c2             	add    %rax,%rdx
  800287:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  80028e:	00 00 00 
  800291:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800294:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800298:	7e 14                	jle    8002ae <libmain+0x65>
		binaryname = argv[0];
  80029a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80029e:	48 8b 10             	mov    (%rax),%rdx
  8002a1:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8002a8:	00 00 00 
  8002ab:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8002ae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002b5:	48 89 d6             	mov    %rdx,%rsi
  8002b8:	89 c7                	mov    %eax,%edi
  8002ba:	48 b8 2f 01 80 00 00 	movabs $0x80012f,%rax
  8002c1:	00 00 00 
  8002c4:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8002c6:	48 b8 d4 02 80 00 00 	movabs $0x8002d4,%rax
  8002cd:	00 00 00 
  8002d0:	ff d0                	callq  *%rax
}
  8002d2:	c9                   	leaveq 
  8002d3:	c3                   	retq   

00000000008002d4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002d4:	55                   	push   %rbp
  8002d5:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8002d8:	48 b8 c2 1f 80 00 00 	movabs $0x801fc2,%rax
  8002df:	00 00 00 
  8002e2:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8002e4:	bf 00 00 00 00       	mov    $0x0,%edi
  8002e9:	48 b8 54 19 80 00 00 	movabs $0x801954,%rax
  8002f0:	00 00 00 
  8002f3:	ff d0                	callq  *%rax

}
  8002f5:	5d                   	pop    %rbp
  8002f6:	c3                   	retq   

00000000008002f7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002f7:	55                   	push   %rbp
  8002f8:	48 89 e5             	mov    %rsp,%rbp
  8002fb:	53                   	push   %rbx
  8002fc:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800303:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80030a:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800310:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800317:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80031e:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800325:	84 c0                	test   %al,%al
  800327:	74 23                	je     80034c <_panic+0x55>
  800329:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800330:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800334:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800338:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80033c:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800340:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800344:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800348:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80034c:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800353:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80035a:	00 00 00 
  80035d:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800364:	00 00 00 
  800367:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80036b:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800372:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800379:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800380:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800387:	00 00 00 
  80038a:	48 8b 18             	mov    (%rax),%rbx
  80038d:	48 b8 98 19 80 00 00 	movabs $0x801998,%rax
  800394:	00 00 00 
  800397:	ff d0                	callq  *%rax
  800399:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80039f:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8003a6:	41 89 c8             	mov    %ecx,%r8d
  8003a9:	48 89 d1             	mov    %rdx,%rcx
  8003ac:	48 89 da             	mov    %rbx,%rdx
  8003af:	89 c6                	mov    %eax,%esi
  8003b1:	48 bf 08 39 80 00 00 	movabs $0x803908,%rdi
  8003b8:	00 00 00 
  8003bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c0:	49 b9 30 05 80 00 00 	movabs $0x800530,%r9
  8003c7:	00 00 00 
  8003ca:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003cd:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8003d4:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003db:	48 89 d6             	mov    %rdx,%rsi
  8003de:	48 89 c7             	mov    %rax,%rdi
  8003e1:	48 b8 84 04 80 00 00 	movabs $0x800484,%rax
  8003e8:	00 00 00 
  8003eb:	ff d0                	callq  *%rax
	cprintf("\n");
  8003ed:	48 bf 2b 39 80 00 00 	movabs $0x80392b,%rdi
  8003f4:	00 00 00 
  8003f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8003fc:	48 ba 30 05 80 00 00 	movabs $0x800530,%rdx
  800403:	00 00 00 
  800406:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800408:	cc                   	int3   
  800409:	eb fd                	jmp    800408 <_panic+0x111>

000000000080040b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80040b:	55                   	push   %rbp
  80040c:	48 89 e5             	mov    %rsp,%rbp
  80040f:	48 83 ec 10          	sub    $0x10,%rsp
  800413:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800416:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  80041a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80041e:	8b 00                	mov    (%rax),%eax
  800420:	8d 48 01             	lea    0x1(%rax),%ecx
  800423:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800427:	89 0a                	mov    %ecx,(%rdx)
  800429:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80042c:	89 d1                	mov    %edx,%ecx
  80042e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800432:	48 98                	cltq   
  800434:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  800438:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80043c:	8b 00                	mov    (%rax),%eax
  80043e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800443:	75 2c                	jne    800471 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  800445:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800449:	8b 00                	mov    (%rax),%eax
  80044b:	48 98                	cltq   
  80044d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800451:	48 83 c2 08          	add    $0x8,%rdx
  800455:	48 89 c6             	mov    %rax,%rsi
  800458:	48 89 d7             	mov    %rdx,%rdi
  80045b:	48 b8 cc 18 80 00 00 	movabs $0x8018cc,%rax
  800462:	00 00 00 
  800465:	ff d0                	callq  *%rax
		b->idx = 0;
  800467:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80046b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800471:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800475:	8b 40 04             	mov    0x4(%rax),%eax
  800478:	8d 50 01             	lea    0x1(%rax),%edx
  80047b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80047f:	89 50 04             	mov    %edx,0x4(%rax)
}
  800482:	c9                   	leaveq 
  800483:	c3                   	retq   

0000000000800484 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800484:	55                   	push   %rbp
  800485:	48 89 e5             	mov    %rsp,%rbp
  800488:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80048f:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800496:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  80049d:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8004a4:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8004ab:	48 8b 0a             	mov    (%rdx),%rcx
  8004ae:	48 89 08             	mov    %rcx,(%rax)
  8004b1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004b5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8004b9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8004bd:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8004c1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8004c8:	00 00 00 
	b.cnt = 0;
  8004cb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8004d2:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8004d5:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8004dc:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8004e3:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8004ea:	48 89 c6             	mov    %rax,%rsi
  8004ed:	48 bf 0b 04 80 00 00 	movabs $0x80040b,%rdi
  8004f4:	00 00 00 
  8004f7:	48 b8 e3 08 80 00 00 	movabs $0x8008e3,%rax
  8004fe:	00 00 00 
  800501:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  800503:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800509:	48 98                	cltq   
  80050b:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800512:	48 83 c2 08          	add    $0x8,%rdx
  800516:	48 89 c6             	mov    %rax,%rsi
  800519:	48 89 d7             	mov    %rdx,%rdi
  80051c:	48 b8 cc 18 80 00 00 	movabs $0x8018cc,%rax
  800523:	00 00 00 
  800526:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  800528:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80052e:	c9                   	leaveq 
  80052f:	c3                   	retq   

0000000000800530 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800530:	55                   	push   %rbp
  800531:	48 89 e5             	mov    %rsp,%rbp
  800534:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80053b:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800542:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800549:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800550:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800557:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80055e:	84 c0                	test   %al,%al
  800560:	74 20                	je     800582 <cprintf+0x52>
  800562:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800566:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80056a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80056e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800572:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800576:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80057a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80057e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800582:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800589:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800590:	00 00 00 
  800593:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80059a:	00 00 00 
  80059d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8005a1:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8005a8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8005af:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8005b6:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8005bd:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8005c4:	48 8b 0a             	mov    (%rdx),%rcx
  8005c7:	48 89 08             	mov    %rcx,(%rax)
  8005ca:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005ce:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005d2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005d6:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8005da:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8005e1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005e8:	48 89 d6             	mov    %rdx,%rsi
  8005eb:	48 89 c7             	mov    %rax,%rdi
  8005ee:	48 b8 84 04 80 00 00 	movabs $0x800484,%rax
  8005f5:	00 00 00 
  8005f8:	ff d0                	callq  *%rax
  8005fa:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800600:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800606:	c9                   	leaveq 
  800607:	c3                   	retq   

0000000000800608 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800608:	55                   	push   %rbp
  800609:	48 89 e5             	mov    %rsp,%rbp
  80060c:	53                   	push   %rbx
  80060d:	48 83 ec 38          	sub    $0x38,%rsp
  800611:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800615:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800619:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80061d:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800620:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800624:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800628:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80062b:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80062f:	77 3b                	ja     80066c <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800631:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800634:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800638:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80063b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80063f:	ba 00 00 00 00       	mov    $0x0,%edx
  800644:	48 f7 f3             	div    %rbx
  800647:	48 89 c2             	mov    %rax,%rdx
  80064a:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80064d:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800650:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800654:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800658:	41 89 f9             	mov    %edi,%r9d
  80065b:	48 89 c7             	mov    %rax,%rdi
  80065e:	48 b8 08 06 80 00 00 	movabs $0x800608,%rax
  800665:	00 00 00 
  800668:	ff d0                	callq  *%rax
  80066a:	eb 1e                	jmp    80068a <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80066c:	eb 12                	jmp    800680 <printnum+0x78>
			putch(padc, putdat);
  80066e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800672:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800675:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800679:	48 89 ce             	mov    %rcx,%rsi
  80067c:	89 d7                	mov    %edx,%edi
  80067e:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800680:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800684:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800688:	7f e4                	jg     80066e <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80068a:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80068d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800691:	ba 00 00 00 00       	mov    $0x0,%edx
  800696:	48 f7 f1             	div    %rcx
  800699:	48 89 d0             	mov    %rdx,%rax
  80069c:	48 ba 08 3b 80 00 00 	movabs $0x803b08,%rdx
  8006a3:	00 00 00 
  8006a6:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8006aa:	0f be d0             	movsbl %al,%edx
  8006ad:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8006b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b5:	48 89 ce             	mov    %rcx,%rsi
  8006b8:	89 d7                	mov    %edx,%edi
  8006ba:	ff d0                	callq  *%rax
}
  8006bc:	48 83 c4 38          	add    $0x38,%rsp
  8006c0:	5b                   	pop    %rbx
  8006c1:	5d                   	pop    %rbp
  8006c2:	c3                   	retq   

00000000008006c3 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006c3:	55                   	push   %rbp
  8006c4:	48 89 e5             	mov    %rsp,%rbp
  8006c7:	48 83 ec 1c          	sub    $0x1c,%rsp
  8006cb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006cf:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8006d2:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8006d6:	7e 52                	jle    80072a <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8006d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006dc:	8b 00                	mov    (%rax),%eax
  8006de:	83 f8 30             	cmp    $0x30,%eax
  8006e1:	73 24                	jae    800707 <getuint+0x44>
  8006e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ef:	8b 00                	mov    (%rax),%eax
  8006f1:	89 c0                	mov    %eax,%eax
  8006f3:	48 01 d0             	add    %rdx,%rax
  8006f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006fa:	8b 12                	mov    (%rdx),%edx
  8006fc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800703:	89 0a                	mov    %ecx,(%rdx)
  800705:	eb 17                	jmp    80071e <getuint+0x5b>
  800707:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80070b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80070f:	48 89 d0             	mov    %rdx,%rax
  800712:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800716:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80071a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80071e:	48 8b 00             	mov    (%rax),%rax
  800721:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800725:	e9 a3 00 00 00       	jmpq   8007cd <getuint+0x10a>
	else if (lflag)
  80072a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80072e:	74 4f                	je     80077f <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800730:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800734:	8b 00                	mov    (%rax),%eax
  800736:	83 f8 30             	cmp    $0x30,%eax
  800739:	73 24                	jae    80075f <getuint+0x9c>
  80073b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800743:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800747:	8b 00                	mov    (%rax),%eax
  800749:	89 c0                	mov    %eax,%eax
  80074b:	48 01 d0             	add    %rdx,%rax
  80074e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800752:	8b 12                	mov    (%rdx),%edx
  800754:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800757:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80075b:	89 0a                	mov    %ecx,(%rdx)
  80075d:	eb 17                	jmp    800776 <getuint+0xb3>
  80075f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800763:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800767:	48 89 d0             	mov    %rdx,%rax
  80076a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80076e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800772:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800776:	48 8b 00             	mov    (%rax),%rax
  800779:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80077d:	eb 4e                	jmp    8007cd <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80077f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800783:	8b 00                	mov    (%rax),%eax
  800785:	83 f8 30             	cmp    $0x30,%eax
  800788:	73 24                	jae    8007ae <getuint+0xeb>
  80078a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800792:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800796:	8b 00                	mov    (%rax),%eax
  800798:	89 c0                	mov    %eax,%eax
  80079a:	48 01 d0             	add    %rdx,%rax
  80079d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007a1:	8b 12                	mov    (%rdx),%edx
  8007a3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007a6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007aa:	89 0a                	mov    %ecx,(%rdx)
  8007ac:	eb 17                	jmp    8007c5 <getuint+0x102>
  8007ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007b6:	48 89 d0             	mov    %rdx,%rax
  8007b9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007bd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007c1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007c5:	8b 00                	mov    (%rax),%eax
  8007c7:	89 c0                	mov    %eax,%eax
  8007c9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8007cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8007d1:	c9                   	leaveq 
  8007d2:	c3                   	retq   

00000000008007d3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007d3:	55                   	push   %rbp
  8007d4:	48 89 e5             	mov    %rsp,%rbp
  8007d7:	48 83 ec 1c          	sub    $0x1c,%rsp
  8007db:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007df:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8007e2:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007e6:	7e 52                	jle    80083a <getint+0x67>
		x=va_arg(*ap, long long);
  8007e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ec:	8b 00                	mov    (%rax),%eax
  8007ee:	83 f8 30             	cmp    $0x30,%eax
  8007f1:	73 24                	jae    800817 <getint+0x44>
  8007f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ff:	8b 00                	mov    (%rax),%eax
  800801:	89 c0                	mov    %eax,%eax
  800803:	48 01 d0             	add    %rdx,%rax
  800806:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80080a:	8b 12                	mov    (%rdx),%edx
  80080c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80080f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800813:	89 0a                	mov    %ecx,(%rdx)
  800815:	eb 17                	jmp    80082e <getint+0x5b>
  800817:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80081f:	48 89 d0             	mov    %rdx,%rax
  800822:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800826:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80082a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80082e:	48 8b 00             	mov    (%rax),%rax
  800831:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800835:	e9 a3 00 00 00       	jmpq   8008dd <getint+0x10a>
	else if (lflag)
  80083a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80083e:	74 4f                	je     80088f <getint+0xbc>
		x=va_arg(*ap, long);
  800840:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800844:	8b 00                	mov    (%rax),%eax
  800846:	83 f8 30             	cmp    $0x30,%eax
  800849:	73 24                	jae    80086f <getint+0x9c>
  80084b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800853:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800857:	8b 00                	mov    (%rax),%eax
  800859:	89 c0                	mov    %eax,%eax
  80085b:	48 01 d0             	add    %rdx,%rax
  80085e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800862:	8b 12                	mov    (%rdx),%edx
  800864:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800867:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80086b:	89 0a                	mov    %ecx,(%rdx)
  80086d:	eb 17                	jmp    800886 <getint+0xb3>
  80086f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800873:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800877:	48 89 d0             	mov    %rdx,%rax
  80087a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80087e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800882:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800886:	48 8b 00             	mov    (%rax),%rax
  800889:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80088d:	eb 4e                	jmp    8008dd <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80088f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800893:	8b 00                	mov    (%rax),%eax
  800895:	83 f8 30             	cmp    $0x30,%eax
  800898:	73 24                	jae    8008be <getint+0xeb>
  80089a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80089e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a6:	8b 00                	mov    (%rax),%eax
  8008a8:	89 c0                	mov    %eax,%eax
  8008aa:	48 01 d0             	add    %rdx,%rax
  8008ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008b1:	8b 12                	mov    (%rdx),%edx
  8008b3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008b6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ba:	89 0a                	mov    %ecx,(%rdx)
  8008bc:	eb 17                	jmp    8008d5 <getint+0x102>
  8008be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008c6:	48 89 d0             	mov    %rdx,%rax
  8008c9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008cd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008d1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008d5:	8b 00                	mov    (%rax),%eax
  8008d7:	48 98                	cltq   
  8008d9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008e1:	c9                   	leaveq 
  8008e2:	c3                   	retq   

00000000008008e3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008e3:	55                   	push   %rbp
  8008e4:	48 89 e5             	mov    %rsp,%rbp
  8008e7:	41 54                	push   %r12
  8008e9:	53                   	push   %rbx
  8008ea:	48 83 ec 60          	sub    $0x60,%rsp
  8008ee:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8008f2:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8008f6:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008fa:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8008fe:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800902:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800906:	48 8b 0a             	mov    (%rdx),%rcx
  800909:	48 89 08             	mov    %rcx,(%rax)
  80090c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800910:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800914:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800918:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80091c:	eb 17                	jmp    800935 <vprintfmt+0x52>
			if (ch == '\0')
  80091e:	85 db                	test   %ebx,%ebx
  800920:	0f 84 cc 04 00 00    	je     800df2 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800926:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80092a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80092e:	48 89 d6             	mov    %rdx,%rsi
  800931:	89 df                	mov    %ebx,%edi
  800933:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800935:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800939:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80093d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800941:	0f b6 00             	movzbl (%rax),%eax
  800944:	0f b6 d8             	movzbl %al,%ebx
  800947:	83 fb 25             	cmp    $0x25,%ebx
  80094a:	75 d2                	jne    80091e <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80094c:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800950:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800957:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80095e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800965:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80096c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800970:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800974:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800978:	0f b6 00             	movzbl (%rax),%eax
  80097b:	0f b6 d8             	movzbl %al,%ebx
  80097e:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800981:	83 f8 55             	cmp    $0x55,%eax
  800984:	0f 87 34 04 00 00    	ja     800dbe <vprintfmt+0x4db>
  80098a:	89 c0                	mov    %eax,%eax
  80098c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800993:	00 
  800994:	48 b8 30 3b 80 00 00 	movabs $0x803b30,%rax
  80099b:	00 00 00 
  80099e:	48 01 d0             	add    %rdx,%rax
  8009a1:	48 8b 00             	mov    (%rax),%rax
  8009a4:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009a6:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8009aa:	eb c0                	jmp    80096c <vprintfmt+0x89>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009ac:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8009b0:	eb ba                	jmp    80096c <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009b2:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8009b9:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8009bc:	89 d0                	mov    %edx,%eax
  8009be:	c1 e0 02             	shl    $0x2,%eax
  8009c1:	01 d0                	add    %edx,%eax
  8009c3:	01 c0                	add    %eax,%eax
  8009c5:	01 d8                	add    %ebx,%eax
  8009c7:	83 e8 30             	sub    $0x30,%eax
  8009ca:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8009cd:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009d1:	0f b6 00             	movzbl (%rax),%eax
  8009d4:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009d7:	83 fb 2f             	cmp    $0x2f,%ebx
  8009da:	7e 0c                	jle    8009e8 <vprintfmt+0x105>
  8009dc:	83 fb 39             	cmp    $0x39,%ebx
  8009df:	7f 07                	jg     8009e8 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009e1:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009e6:	eb d1                	jmp    8009b9 <vprintfmt+0xd6>
			goto process_precision;
  8009e8:	eb 58                	jmp    800a42 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8009ea:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009ed:	83 f8 30             	cmp    $0x30,%eax
  8009f0:	73 17                	jae    800a09 <vprintfmt+0x126>
  8009f2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009f6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f9:	89 c0                	mov    %eax,%eax
  8009fb:	48 01 d0             	add    %rdx,%rax
  8009fe:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a01:	83 c2 08             	add    $0x8,%edx
  800a04:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a07:	eb 0f                	jmp    800a18 <vprintfmt+0x135>
  800a09:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a0d:	48 89 d0             	mov    %rdx,%rax
  800a10:	48 83 c2 08          	add    $0x8,%rdx
  800a14:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a18:	8b 00                	mov    (%rax),%eax
  800a1a:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800a1d:	eb 23                	jmp    800a42 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800a1f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a23:	79 0c                	jns    800a31 <vprintfmt+0x14e>
				width = 0;
  800a25:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800a2c:	e9 3b ff ff ff       	jmpq   80096c <vprintfmt+0x89>
  800a31:	e9 36 ff ff ff       	jmpq   80096c <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800a36:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800a3d:	e9 2a ff ff ff       	jmpq   80096c <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800a42:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a46:	79 12                	jns    800a5a <vprintfmt+0x177>
				width = precision, precision = -1;
  800a48:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a4b:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800a4e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800a55:	e9 12 ff ff ff       	jmpq   80096c <vprintfmt+0x89>
  800a5a:	e9 0d ff ff ff       	jmpq   80096c <vprintfmt+0x89>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a5f:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800a63:	e9 04 ff ff ff       	jmpq   80096c <vprintfmt+0x89>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800a68:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a6b:	83 f8 30             	cmp    $0x30,%eax
  800a6e:	73 17                	jae    800a87 <vprintfmt+0x1a4>
  800a70:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a74:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a77:	89 c0                	mov    %eax,%eax
  800a79:	48 01 d0             	add    %rdx,%rax
  800a7c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a7f:	83 c2 08             	add    $0x8,%edx
  800a82:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a85:	eb 0f                	jmp    800a96 <vprintfmt+0x1b3>
  800a87:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a8b:	48 89 d0             	mov    %rdx,%rax
  800a8e:	48 83 c2 08          	add    $0x8,%rdx
  800a92:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a96:	8b 10                	mov    (%rax),%edx
  800a98:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a9c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aa0:	48 89 ce             	mov    %rcx,%rsi
  800aa3:	89 d7                	mov    %edx,%edi
  800aa5:	ff d0                	callq  *%rax
			break;
  800aa7:	e9 40 03 00 00       	jmpq   800dec <vprintfmt+0x509>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800aac:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aaf:	83 f8 30             	cmp    $0x30,%eax
  800ab2:	73 17                	jae    800acb <vprintfmt+0x1e8>
  800ab4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ab8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800abb:	89 c0                	mov    %eax,%eax
  800abd:	48 01 d0             	add    %rdx,%rax
  800ac0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ac3:	83 c2 08             	add    $0x8,%edx
  800ac6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ac9:	eb 0f                	jmp    800ada <vprintfmt+0x1f7>
  800acb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800acf:	48 89 d0             	mov    %rdx,%rax
  800ad2:	48 83 c2 08          	add    $0x8,%rdx
  800ad6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ada:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800adc:	85 db                	test   %ebx,%ebx
  800ade:	79 02                	jns    800ae2 <vprintfmt+0x1ff>
				err = -err;
  800ae0:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800ae2:	83 fb 10             	cmp    $0x10,%ebx
  800ae5:	7f 16                	jg     800afd <vprintfmt+0x21a>
  800ae7:	48 b8 80 3a 80 00 00 	movabs $0x803a80,%rax
  800aee:	00 00 00 
  800af1:	48 63 d3             	movslq %ebx,%rdx
  800af4:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800af8:	4d 85 e4             	test   %r12,%r12
  800afb:	75 2e                	jne    800b2b <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800afd:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b01:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b05:	89 d9                	mov    %ebx,%ecx
  800b07:	48 ba 19 3b 80 00 00 	movabs $0x803b19,%rdx
  800b0e:	00 00 00 
  800b11:	48 89 c7             	mov    %rax,%rdi
  800b14:	b8 00 00 00 00       	mov    $0x0,%eax
  800b19:	49 b8 fb 0d 80 00 00 	movabs $0x800dfb,%r8
  800b20:	00 00 00 
  800b23:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b26:	e9 c1 02 00 00       	jmpq   800dec <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b2b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b2f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b33:	4c 89 e1             	mov    %r12,%rcx
  800b36:	48 ba 22 3b 80 00 00 	movabs $0x803b22,%rdx
  800b3d:	00 00 00 
  800b40:	48 89 c7             	mov    %rax,%rdi
  800b43:	b8 00 00 00 00       	mov    $0x0,%eax
  800b48:	49 b8 fb 0d 80 00 00 	movabs $0x800dfb,%r8
  800b4f:	00 00 00 
  800b52:	41 ff d0             	callq  *%r8
			break;
  800b55:	e9 92 02 00 00       	jmpq   800dec <vprintfmt+0x509>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800b5a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b5d:	83 f8 30             	cmp    $0x30,%eax
  800b60:	73 17                	jae    800b79 <vprintfmt+0x296>
  800b62:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b66:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b69:	89 c0                	mov    %eax,%eax
  800b6b:	48 01 d0             	add    %rdx,%rax
  800b6e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b71:	83 c2 08             	add    $0x8,%edx
  800b74:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b77:	eb 0f                	jmp    800b88 <vprintfmt+0x2a5>
  800b79:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b7d:	48 89 d0             	mov    %rdx,%rax
  800b80:	48 83 c2 08          	add    $0x8,%rdx
  800b84:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b88:	4c 8b 20             	mov    (%rax),%r12
  800b8b:	4d 85 e4             	test   %r12,%r12
  800b8e:	75 0a                	jne    800b9a <vprintfmt+0x2b7>
				p = "(null)";
  800b90:	49 bc 25 3b 80 00 00 	movabs $0x803b25,%r12
  800b97:	00 00 00 
			if (width > 0 && padc != '-')
  800b9a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b9e:	7e 3f                	jle    800bdf <vprintfmt+0x2fc>
  800ba0:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800ba4:	74 39                	je     800bdf <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ba6:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ba9:	48 98                	cltq   
  800bab:	48 89 c6             	mov    %rax,%rsi
  800bae:	4c 89 e7             	mov    %r12,%rdi
  800bb1:	48 b8 a7 10 80 00 00 	movabs $0x8010a7,%rax
  800bb8:	00 00 00 
  800bbb:	ff d0                	callq  *%rax
  800bbd:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800bc0:	eb 17                	jmp    800bd9 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800bc2:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800bc6:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800bca:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bce:	48 89 ce             	mov    %rcx,%rsi
  800bd1:	89 d7                	mov    %edx,%edi
  800bd3:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bd5:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bd9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bdd:	7f e3                	jg     800bc2 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bdf:	eb 37                	jmp    800c18 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800be1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800be5:	74 1e                	je     800c05 <vprintfmt+0x322>
  800be7:	83 fb 1f             	cmp    $0x1f,%ebx
  800bea:	7e 05                	jle    800bf1 <vprintfmt+0x30e>
  800bec:	83 fb 7e             	cmp    $0x7e,%ebx
  800bef:	7e 14                	jle    800c05 <vprintfmt+0x322>
					putch('?', putdat);
  800bf1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bf5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bf9:	48 89 d6             	mov    %rdx,%rsi
  800bfc:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800c01:	ff d0                	callq  *%rax
  800c03:	eb 0f                	jmp    800c14 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800c05:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c09:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c0d:	48 89 d6             	mov    %rdx,%rsi
  800c10:	89 df                	mov    %ebx,%edi
  800c12:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c14:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c18:	4c 89 e0             	mov    %r12,%rax
  800c1b:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800c1f:	0f b6 00             	movzbl (%rax),%eax
  800c22:	0f be d8             	movsbl %al,%ebx
  800c25:	85 db                	test   %ebx,%ebx
  800c27:	74 10                	je     800c39 <vprintfmt+0x356>
  800c29:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c2d:	78 b2                	js     800be1 <vprintfmt+0x2fe>
  800c2f:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800c33:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c37:	79 a8                	jns    800be1 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c39:	eb 16                	jmp    800c51 <vprintfmt+0x36e>
				putch(' ', putdat);
  800c3b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c3f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c43:	48 89 d6             	mov    %rdx,%rsi
  800c46:	bf 20 00 00 00       	mov    $0x20,%edi
  800c4b:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c4d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c51:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c55:	7f e4                	jg     800c3b <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800c57:	e9 90 01 00 00       	jmpq   800dec <vprintfmt+0x509>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800c5c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c60:	be 03 00 00 00       	mov    $0x3,%esi
  800c65:	48 89 c7             	mov    %rax,%rdi
  800c68:	48 b8 d3 07 80 00 00 	movabs $0x8007d3,%rax
  800c6f:	00 00 00 
  800c72:	ff d0                	callq  *%rax
  800c74:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c7c:	48 85 c0             	test   %rax,%rax
  800c7f:	79 1d                	jns    800c9e <vprintfmt+0x3bb>
				putch('-', putdat);
  800c81:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c85:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c89:	48 89 d6             	mov    %rdx,%rsi
  800c8c:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c91:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c97:	48 f7 d8             	neg    %rax
  800c9a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c9e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ca5:	e9 d5 00 00 00       	jmpq   800d7f <vprintfmt+0x49c>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800caa:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cae:	be 03 00 00 00       	mov    $0x3,%esi
  800cb3:	48 89 c7             	mov    %rax,%rdi
  800cb6:	48 b8 c3 06 80 00 00 	movabs $0x8006c3,%rax
  800cbd:	00 00 00 
  800cc0:	ff d0                	callq  *%rax
  800cc2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800cc6:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ccd:	e9 ad 00 00 00       	jmpq   800d7f <vprintfmt+0x49c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800cd2:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800cd5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cd9:	89 d6                	mov    %edx,%esi
  800cdb:	48 89 c7             	mov    %rax,%rdi
  800cde:	48 b8 d3 07 80 00 00 	movabs $0x8007d3,%rax
  800ce5:	00 00 00 
  800ce8:	ff d0                	callq  *%rax
  800cea:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800cee:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800cf5:	e9 85 00 00 00       	jmpq   800d7f <vprintfmt+0x49c>


		// pointer
		case 'p':
			putch('0', putdat);
  800cfa:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cfe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d02:	48 89 d6             	mov    %rdx,%rsi
  800d05:	bf 30 00 00 00       	mov    $0x30,%edi
  800d0a:	ff d0                	callq  *%rax
			putch('x', putdat);
  800d0c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d10:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d14:	48 89 d6             	mov    %rdx,%rsi
  800d17:	bf 78 00 00 00       	mov    $0x78,%edi
  800d1c:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800d1e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d21:	83 f8 30             	cmp    $0x30,%eax
  800d24:	73 17                	jae    800d3d <vprintfmt+0x45a>
  800d26:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d2a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d2d:	89 c0                	mov    %eax,%eax
  800d2f:	48 01 d0             	add    %rdx,%rax
  800d32:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d35:	83 c2 08             	add    $0x8,%edx
  800d38:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d3b:	eb 0f                	jmp    800d4c <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800d3d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d41:	48 89 d0             	mov    %rdx,%rax
  800d44:	48 83 c2 08          	add    $0x8,%rdx
  800d48:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d4c:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d4f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800d53:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800d5a:	eb 23                	jmp    800d7f <vprintfmt+0x49c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800d5c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d60:	be 03 00 00 00       	mov    $0x3,%esi
  800d65:	48 89 c7             	mov    %rax,%rdi
  800d68:	48 b8 c3 06 80 00 00 	movabs $0x8006c3,%rax
  800d6f:	00 00 00 
  800d72:	ff d0                	callq  *%rax
  800d74:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d78:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d7f:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d84:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d87:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d8a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d8e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d92:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d96:	45 89 c1             	mov    %r8d,%r9d
  800d99:	41 89 f8             	mov    %edi,%r8d
  800d9c:	48 89 c7             	mov    %rax,%rdi
  800d9f:	48 b8 08 06 80 00 00 	movabs $0x800608,%rax
  800da6:	00 00 00 
  800da9:	ff d0                	callq  *%rax
			break;
  800dab:	eb 3f                	jmp    800dec <vprintfmt+0x509>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800dad:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800db1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800db5:	48 89 d6             	mov    %rdx,%rsi
  800db8:	89 df                	mov    %ebx,%edi
  800dba:	ff d0                	callq  *%rax
			break;
  800dbc:	eb 2e                	jmp    800dec <vprintfmt+0x509>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800dbe:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dc2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dc6:	48 89 d6             	mov    %rdx,%rsi
  800dc9:	bf 25 00 00 00       	mov    $0x25,%edi
  800dce:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800dd0:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800dd5:	eb 05                	jmp    800ddc <vprintfmt+0x4f9>
  800dd7:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ddc:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800de0:	48 83 e8 01          	sub    $0x1,%rax
  800de4:	0f b6 00             	movzbl (%rax),%eax
  800de7:	3c 25                	cmp    $0x25,%al
  800de9:	75 ec                	jne    800dd7 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800deb:	90                   	nop
		}
	}
  800dec:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ded:	e9 43 fb ff ff       	jmpq   800935 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  800df2:	48 83 c4 60          	add    $0x60,%rsp
  800df6:	5b                   	pop    %rbx
  800df7:	41 5c                	pop    %r12
  800df9:	5d                   	pop    %rbp
  800dfa:	c3                   	retq   

0000000000800dfb <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800dfb:	55                   	push   %rbp
  800dfc:	48 89 e5             	mov    %rsp,%rbp
  800dff:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800e06:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800e0d:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800e14:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e1b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e22:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e29:	84 c0                	test   %al,%al
  800e2b:	74 20                	je     800e4d <printfmt+0x52>
  800e2d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e31:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e35:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e39:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e3d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e41:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e45:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e49:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e4d:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800e54:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800e5b:	00 00 00 
  800e5e:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e65:	00 00 00 
  800e68:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e6c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e73:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e7a:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e81:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e88:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e8f:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e96:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e9d:	48 89 c7             	mov    %rax,%rdi
  800ea0:	48 b8 e3 08 80 00 00 	movabs $0x8008e3,%rax
  800ea7:	00 00 00 
  800eaa:	ff d0                	callq  *%rax
	va_end(ap);
}
  800eac:	c9                   	leaveq 
  800ead:	c3                   	retq   

0000000000800eae <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800eae:	55                   	push   %rbp
  800eaf:	48 89 e5             	mov    %rsp,%rbp
  800eb2:	48 83 ec 10          	sub    $0x10,%rsp
  800eb6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800eb9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800ebd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ec1:	8b 40 10             	mov    0x10(%rax),%eax
  800ec4:	8d 50 01             	lea    0x1(%rax),%edx
  800ec7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ecb:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800ece:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ed2:	48 8b 10             	mov    (%rax),%rdx
  800ed5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ed9:	48 8b 40 08          	mov    0x8(%rax),%rax
  800edd:	48 39 c2             	cmp    %rax,%rdx
  800ee0:	73 17                	jae    800ef9 <sprintputch+0x4b>
		*b->buf++ = ch;
  800ee2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ee6:	48 8b 00             	mov    (%rax),%rax
  800ee9:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800eed:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ef1:	48 89 0a             	mov    %rcx,(%rdx)
  800ef4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800ef7:	88 10                	mov    %dl,(%rax)
}
  800ef9:	c9                   	leaveq 
  800efa:	c3                   	retq   

0000000000800efb <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800efb:	55                   	push   %rbp
  800efc:	48 89 e5             	mov    %rsp,%rbp
  800eff:	48 83 ec 50          	sub    $0x50,%rsp
  800f03:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800f07:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800f0a:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800f0e:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800f12:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800f16:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800f1a:	48 8b 0a             	mov    (%rdx),%rcx
  800f1d:	48 89 08             	mov    %rcx,(%rax)
  800f20:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f24:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f28:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f2c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f30:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f34:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800f38:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800f3b:	48 98                	cltq   
  800f3d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800f41:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f45:	48 01 d0             	add    %rdx,%rax
  800f48:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800f4c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800f53:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800f58:	74 06                	je     800f60 <vsnprintf+0x65>
  800f5a:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800f5e:	7f 07                	jg     800f67 <vsnprintf+0x6c>
		return -E_INVAL;
  800f60:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f65:	eb 2f                	jmp    800f96 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f67:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f6b:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f6f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f73:	48 89 c6             	mov    %rax,%rsi
  800f76:	48 bf ae 0e 80 00 00 	movabs $0x800eae,%rdi
  800f7d:	00 00 00 
  800f80:	48 b8 e3 08 80 00 00 	movabs $0x8008e3,%rax
  800f87:	00 00 00 
  800f8a:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f8c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f90:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f93:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f96:	c9                   	leaveq 
  800f97:	c3                   	retq   

0000000000800f98 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f98:	55                   	push   %rbp
  800f99:	48 89 e5             	mov    %rsp,%rbp
  800f9c:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800fa3:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800faa:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800fb0:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800fb7:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800fbe:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800fc5:	84 c0                	test   %al,%al
  800fc7:	74 20                	je     800fe9 <snprintf+0x51>
  800fc9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800fcd:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800fd1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800fd5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800fd9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800fdd:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800fe1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800fe5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800fe9:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800ff0:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800ff7:	00 00 00 
  800ffa:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801001:	00 00 00 
  801004:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801008:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80100f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801016:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80101d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801024:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80102b:	48 8b 0a             	mov    (%rdx),%rcx
  80102e:	48 89 08             	mov    %rcx,(%rax)
  801031:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801035:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801039:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80103d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801041:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801048:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80104f:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801055:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80105c:	48 89 c7             	mov    %rax,%rdi
  80105f:	48 b8 fb 0e 80 00 00 	movabs $0x800efb,%rax
  801066:	00 00 00 
  801069:	ff d0                	callq  *%rax
  80106b:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801071:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801077:	c9                   	leaveq 
  801078:	c3                   	retq   

0000000000801079 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801079:	55                   	push   %rbp
  80107a:	48 89 e5             	mov    %rsp,%rbp
  80107d:	48 83 ec 18          	sub    $0x18,%rsp
  801081:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801085:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80108c:	eb 09                	jmp    801097 <strlen+0x1e>
		n++;
  80108e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801092:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801097:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80109b:	0f b6 00             	movzbl (%rax),%eax
  80109e:	84 c0                	test   %al,%al
  8010a0:	75 ec                	jne    80108e <strlen+0x15>
		n++;
	return n;
  8010a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010a5:	c9                   	leaveq 
  8010a6:	c3                   	retq   

00000000008010a7 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8010a7:	55                   	push   %rbp
  8010a8:	48 89 e5             	mov    %rsp,%rbp
  8010ab:	48 83 ec 20          	sub    $0x20,%rsp
  8010af:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010b3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010be:	eb 0e                	jmp    8010ce <strnlen+0x27>
		n++;
  8010c0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010c4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010c9:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8010ce:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8010d3:	74 0b                	je     8010e0 <strnlen+0x39>
  8010d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d9:	0f b6 00             	movzbl (%rax),%eax
  8010dc:	84 c0                	test   %al,%al
  8010de:	75 e0                	jne    8010c0 <strnlen+0x19>
		n++;
	return n;
  8010e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010e3:	c9                   	leaveq 
  8010e4:	c3                   	retq   

00000000008010e5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010e5:	55                   	push   %rbp
  8010e6:	48 89 e5             	mov    %rsp,%rbp
  8010e9:	48 83 ec 20          	sub    $0x20,%rsp
  8010ed:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010f1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8010f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8010fd:	90                   	nop
  8010fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801102:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801106:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80110a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80110e:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801112:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801116:	0f b6 12             	movzbl (%rdx),%edx
  801119:	88 10                	mov    %dl,(%rax)
  80111b:	0f b6 00             	movzbl (%rax),%eax
  80111e:	84 c0                	test   %al,%al
  801120:	75 dc                	jne    8010fe <strcpy+0x19>
		/* do nothing */;
	return ret;
  801122:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801126:	c9                   	leaveq 
  801127:	c3                   	retq   

0000000000801128 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801128:	55                   	push   %rbp
  801129:	48 89 e5             	mov    %rsp,%rbp
  80112c:	48 83 ec 20          	sub    $0x20,%rsp
  801130:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801134:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801138:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80113c:	48 89 c7             	mov    %rax,%rdi
  80113f:	48 b8 79 10 80 00 00 	movabs $0x801079,%rax
  801146:	00 00 00 
  801149:	ff d0                	callq  *%rax
  80114b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80114e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801151:	48 63 d0             	movslq %eax,%rdx
  801154:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801158:	48 01 c2             	add    %rax,%rdx
  80115b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80115f:	48 89 c6             	mov    %rax,%rsi
  801162:	48 89 d7             	mov    %rdx,%rdi
  801165:	48 b8 e5 10 80 00 00 	movabs $0x8010e5,%rax
  80116c:	00 00 00 
  80116f:	ff d0                	callq  *%rax
	return dst;
  801171:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801175:	c9                   	leaveq 
  801176:	c3                   	retq   

0000000000801177 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801177:	55                   	push   %rbp
  801178:	48 89 e5             	mov    %rsp,%rbp
  80117b:	48 83 ec 28          	sub    $0x28,%rsp
  80117f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801183:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801187:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80118b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80118f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801193:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80119a:	00 
  80119b:	eb 2a                	jmp    8011c7 <strncpy+0x50>
		*dst++ = *src;
  80119d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011a5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011a9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011ad:	0f b6 12             	movzbl (%rdx),%edx
  8011b0:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8011b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011b6:	0f b6 00             	movzbl (%rax),%eax
  8011b9:	84 c0                	test   %al,%al
  8011bb:	74 05                	je     8011c2 <strncpy+0x4b>
			src++;
  8011bd:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011c2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011cb:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8011cf:	72 cc                	jb     80119d <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8011d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8011d5:	c9                   	leaveq 
  8011d6:	c3                   	retq   

00000000008011d7 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8011d7:	55                   	push   %rbp
  8011d8:	48 89 e5             	mov    %rsp,%rbp
  8011db:	48 83 ec 28          	sub    $0x28,%rsp
  8011df:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011e3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011e7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8011eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ef:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8011f3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011f8:	74 3d                	je     801237 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8011fa:	eb 1d                	jmp    801219 <strlcpy+0x42>
			*dst++ = *src++;
  8011fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801200:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801204:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801208:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80120c:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801210:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801214:	0f b6 12             	movzbl (%rdx),%edx
  801217:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801219:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80121e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801223:	74 0b                	je     801230 <strlcpy+0x59>
  801225:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801229:	0f b6 00             	movzbl (%rax),%eax
  80122c:	84 c0                	test   %al,%al
  80122e:	75 cc                	jne    8011fc <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801230:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801234:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801237:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80123b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80123f:	48 29 c2             	sub    %rax,%rdx
  801242:	48 89 d0             	mov    %rdx,%rax
}
  801245:	c9                   	leaveq 
  801246:	c3                   	retq   

0000000000801247 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801247:	55                   	push   %rbp
  801248:	48 89 e5             	mov    %rsp,%rbp
  80124b:	48 83 ec 10          	sub    $0x10,%rsp
  80124f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801253:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801257:	eb 0a                	jmp    801263 <strcmp+0x1c>
		p++, q++;
  801259:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80125e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801263:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801267:	0f b6 00             	movzbl (%rax),%eax
  80126a:	84 c0                	test   %al,%al
  80126c:	74 12                	je     801280 <strcmp+0x39>
  80126e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801272:	0f b6 10             	movzbl (%rax),%edx
  801275:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801279:	0f b6 00             	movzbl (%rax),%eax
  80127c:	38 c2                	cmp    %al,%dl
  80127e:	74 d9                	je     801259 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801280:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801284:	0f b6 00             	movzbl (%rax),%eax
  801287:	0f b6 d0             	movzbl %al,%edx
  80128a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80128e:	0f b6 00             	movzbl (%rax),%eax
  801291:	0f b6 c0             	movzbl %al,%eax
  801294:	29 c2                	sub    %eax,%edx
  801296:	89 d0                	mov    %edx,%eax
}
  801298:	c9                   	leaveq 
  801299:	c3                   	retq   

000000000080129a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80129a:	55                   	push   %rbp
  80129b:	48 89 e5             	mov    %rsp,%rbp
  80129e:	48 83 ec 18          	sub    $0x18,%rsp
  8012a2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012a6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8012aa:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8012ae:	eb 0f                	jmp    8012bf <strncmp+0x25>
		n--, p++, q++;
  8012b0:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8012b5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012ba:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8012bf:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012c4:	74 1d                	je     8012e3 <strncmp+0x49>
  8012c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ca:	0f b6 00             	movzbl (%rax),%eax
  8012cd:	84 c0                	test   %al,%al
  8012cf:	74 12                	je     8012e3 <strncmp+0x49>
  8012d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d5:	0f b6 10             	movzbl (%rax),%edx
  8012d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012dc:	0f b6 00             	movzbl (%rax),%eax
  8012df:	38 c2                	cmp    %al,%dl
  8012e1:	74 cd                	je     8012b0 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8012e3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012e8:	75 07                	jne    8012f1 <strncmp+0x57>
		return 0;
  8012ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ef:	eb 18                	jmp    801309 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f5:	0f b6 00             	movzbl (%rax),%eax
  8012f8:	0f b6 d0             	movzbl %al,%edx
  8012fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012ff:	0f b6 00             	movzbl (%rax),%eax
  801302:	0f b6 c0             	movzbl %al,%eax
  801305:	29 c2                	sub    %eax,%edx
  801307:	89 d0                	mov    %edx,%eax
}
  801309:	c9                   	leaveq 
  80130a:	c3                   	retq   

000000000080130b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80130b:	55                   	push   %rbp
  80130c:	48 89 e5             	mov    %rsp,%rbp
  80130f:	48 83 ec 0c          	sub    $0xc,%rsp
  801313:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801317:	89 f0                	mov    %esi,%eax
  801319:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80131c:	eb 17                	jmp    801335 <strchr+0x2a>
		if (*s == c)
  80131e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801322:	0f b6 00             	movzbl (%rax),%eax
  801325:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801328:	75 06                	jne    801330 <strchr+0x25>
			return (char *) s;
  80132a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80132e:	eb 15                	jmp    801345 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801330:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801335:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801339:	0f b6 00             	movzbl (%rax),%eax
  80133c:	84 c0                	test   %al,%al
  80133e:	75 de                	jne    80131e <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801340:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801345:	c9                   	leaveq 
  801346:	c3                   	retq   

0000000000801347 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801347:	55                   	push   %rbp
  801348:	48 89 e5             	mov    %rsp,%rbp
  80134b:	48 83 ec 0c          	sub    $0xc,%rsp
  80134f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801353:	89 f0                	mov    %esi,%eax
  801355:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801358:	eb 13                	jmp    80136d <strfind+0x26>
		if (*s == c)
  80135a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80135e:	0f b6 00             	movzbl (%rax),%eax
  801361:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801364:	75 02                	jne    801368 <strfind+0x21>
			break;
  801366:	eb 10                	jmp    801378 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801368:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80136d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801371:	0f b6 00             	movzbl (%rax),%eax
  801374:	84 c0                	test   %al,%al
  801376:	75 e2                	jne    80135a <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801378:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80137c:	c9                   	leaveq 
  80137d:	c3                   	retq   

000000000080137e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80137e:	55                   	push   %rbp
  80137f:	48 89 e5             	mov    %rsp,%rbp
  801382:	48 83 ec 18          	sub    $0x18,%rsp
  801386:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80138a:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80138d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801391:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801396:	75 06                	jne    80139e <memset+0x20>
		return v;
  801398:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80139c:	eb 69                	jmp    801407 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80139e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013a2:	83 e0 03             	and    $0x3,%eax
  8013a5:	48 85 c0             	test   %rax,%rax
  8013a8:	75 48                	jne    8013f2 <memset+0x74>
  8013aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ae:	83 e0 03             	and    $0x3,%eax
  8013b1:	48 85 c0             	test   %rax,%rax
  8013b4:	75 3c                	jne    8013f2 <memset+0x74>
		c &= 0xFF;
  8013b6:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8013bd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013c0:	c1 e0 18             	shl    $0x18,%eax
  8013c3:	89 c2                	mov    %eax,%edx
  8013c5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013c8:	c1 e0 10             	shl    $0x10,%eax
  8013cb:	09 c2                	or     %eax,%edx
  8013cd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013d0:	c1 e0 08             	shl    $0x8,%eax
  8013d3:	09 d0                	or     %edx,%eax
  8013d5:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8013d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013dc:	48 c1 e8 02          	shr    $0x2,%rax
  8013e0:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8013e3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013e7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013ea:	48 89 d7             	mov    %rdx,%rdi
  8013ed:	fc                   	cld    
  8013ee:	f3 ab                	rep stos %eax,%es:(%rdi)
  8013f0:	eb 11                	jmp    801403 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8013f2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013f6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013f9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8013fd:	48 89 d7             	mov    %rdx,%rdi
  801400:	fc                   	cld    
  801401:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801403:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801407:	c9                   	leaveq 
  801408:	c3                   	retq   

0000000000801409 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801409:	55                   	push   %rbp
  80140a:	48 89 e5             	mov    %rsp,%rbp
  80140d:	48 83 ec 28          	sub    $0x28,%rsp
  801411:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801415:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801419:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80141d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801421:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801425:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801429:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80142d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801431:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801435:	0f 83 88 00 00 00    	jae    8014c3 <memmove+0xba>
  80143b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80143f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801443:	48 01 d0             	add    %rdx,%rax
  801446:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80144a:	76 77                	jbe    8014c3 <memmove+0xba>
		s += n;
  80144c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801450:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801454:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801458:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80145c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801460:	83 e0 03             	and    $0x3,%eax
  801463:	48 85 c0             	test   %rax,%rax
  801466:	75 3b                	jne    8014a3 <memmove+0x9a>
  801468:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80146c:	83 e0 03             	and    $0x3,%eax
  80146f:	48 85 c0             	test   %rax,%rax
  801472:	75 2f                	jne    8014a3 <memmove+0x9a>
  801474:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801478:	83 e0 03             	and    $0x3,%eax
  80147b:	48 85 c0             	test   %rax,%rax
  80147e:	75 23                	jne    8014a3 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801480:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801484:	48 83 e8 04          	sub    $0x4,%rax
  801488:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80148c:	48 83 ea 04          	sub    $0x4,%rdx
  801490:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801494:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801498:	48 89 c7             	mov    %rax,%rdi
  80149b:	48 89 d6             	mov    %rdx,%rsi
  80149e:	fd                   	std    
  80149f:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014a1:	eb 1d                	jmp    8014c0 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8014a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a7:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8014ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014af:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8014b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b7:	48 89 d7             	mov    %rdx,%rdi
  8014ba:	48 89 c1             	mov    %rax,%rcx
  8014bd:	fd                   	std    
  8014be:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8014c0:	fc                   	cld    
  8014c1:	eb 57                	jmp    80151a <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8014c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c7:	83 e0 03             	and    $0x3,%eax
  8014ca:	48 85 c0             	test   %rax,%rax
  8014cd:	75 36                	jne    801505 <memmove+0xfc>
  8014cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014d3:	83 e0 03             	and    $0x3,%eax
  8014d6:	48 85 c0             	test   %rax,%rax
  8014d9:	75 2a                	jne    801505 <memmove+0xfc>
  8014db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014df:	83 e0 03             	and    $0x3,%eax
  8014e2:	48 85 c0             	test   %rax,%rax
  8014e5:	75 1e                	jne    801505 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8014e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014eb:	48 c1 e8 02          	shr    $0x2,%rax
  8014ef:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8014f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014f6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014fa:	48 89 c7             	mov    %rax,%rdi
  8014fd:	48 89 d6             	mov    %rdx,%rsi
  801500:	fc                   	cld    
  801501:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801503:	eb 15                	jmp    80151a <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801505:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801509:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80150d:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801511:	48 89 c7             	mov    %rax,%rdi
  801514:	48 89 d6             	mov    %rdx,%rsi
  801517:	fc                   	cld    
  801518:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80151a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80151e:	c9                   	leaveq 
  80151f:	c3                   	retq   

0000000000801520 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801520:	55                   	push   %rbp
  801521:	48 89 e5             	mov    %rsp,%rbp
  801524:	48 83 ec 18          	sub    $0x18,%rsp
  801528:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80152c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801530:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801534:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801538:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80153c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801540:	48 89 ce             	mov    %rcx,%rsi
  801543:	48 89 c7             	mov    %rax,%rdi
  801546:	48 b8 09 14 80 00 00 	movabs $0x801409,%rax
  80154d:	00 00 00 
  801550:	ff d0                	callq  *%rax
}
  801552:	c9                   	leaveq 
  801553:	c3                   	retq   

0000000000801554 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801554:	55                   	push   %rbp
  801555:	48 89 e5             	mov    %rsp,%rbp
  801558:	48 83 ec 28          	sub    $0x28,%rsp
  80155c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801560:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801564:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801568:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80156c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801570:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801574:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801578:	eb 36                	jmp    8015b0 <memcmp+0x5c>
		if (*s1 != *s2)
  80157a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80157e:	0f b6 10             	movzbl (%rax),%edx
  801581:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801585:	0f b6 00             	movzbl (%rax),%eax
  801588:	38 c2                	cmp    %al,%dl
  80158a:	74 1a                	je     8015a6 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80158c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801590:	0f b6 00             	movzbl (%rax),%eax
  801593:	0f b6 d0             	movzbl %al,%edx
  801596:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80159a:	0f b6 00             	movzbl (%rax),%eax
  80159d:	0f b6 c0             	movzbl %al,%eax
  8015a0:	29 c2                	sub    %eax,%edx
  8015a2:	89 d0                	mov    %edx,%eax
  8015a4:	eb 20                	jmp    8015c6 <memcmp+0x72>
		s1++, s2++;
  8015a6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015ab:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8015b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b4:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015b8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8015bc:	48 85 c0             	test   %rax,%rax
  8015bf:	75 b9                	jne    80157a <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015c6:	c9                   	leaveq 
  8015c7:	c3                   	retq   

00000000008015c8 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8015c8:	55                   	push   %rbp
  8015c9:	48 89 e5             	mov    %rsp,%rbp
  8015cc:	48 83 ec 28          	sub    $0x28,%rsp
  8015d0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015d4:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8015d7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8015db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015e3:	48 01 d0             	add    %rdx,%rax
  8015e6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8015ea:	eb 15                	jmp    801601 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015f0:	0f b6 10             	movzbl (%rax),%edx
  8015f3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8015f6:	38 c2                	cmp    %al,%dl
  8015f8:	75 02                	jne    8015fc <memfind+0x34>
			break;
  8015fa:	eb 0f                	jmp    80160b <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015fc:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801601:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801605:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801609:	72 e1                	jb     8015ec <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80160b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80160f:	c9                   	leaveq 
  801610:	c3                   	retq   

0000000000801611 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801611:	55                   	push   %rbp
  801612:	48 89 e5             	mov    %rsp,%rbp
  801615:	48 83 ec 34          	sub    $0x34,%rsp
  801619:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80161d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801621:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801624:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80162b:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801632:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801633:	eb 05                	jmp    80163a <strtol+0x29>
		s++;
  801635:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80163a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163e:	0f b6 00             	movzbl (%rax),%eax
  801641:	3c 20                	cmp    $0x20,%al
  801643:	74 f0                	je     801635 <strtol+0x24>
  801645:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801649:	0f b6 00             	movzbl (%rax),%eax
  80164c:	3c 09                	cmp    $0x9,%al
  80164e:	74 e5                	je     801635 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801650:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801654:	0f b6 00             	movzbl (%rax),%eax
  801657:	3c 2b                	cmp    $0x2b,%al
  801659:	75 07                	jne    801662 <strtol+0x51>
		s++;
  80165b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801660:	eb 17                	jmp    801679 <strtol+0x68>
	else if (*s == '-')
  801662:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801666:	0f b6 00             	movzbl (%rax),%eax
  801669:	3c 2d                	cmp    $0x2d,%al
  80166b:	75 0c                	jne    801679 <strtol+0x68>
		s++, neg = 1;
  80166d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801672:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801679:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80167d:	74 06                	je     801685 <strtol+0x74>
  80167f:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801683:	75 28                	jne    8016ad <strtol+0x9c>
  801685:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801689:	0f b6 00             	movzbl (%rax),%eax
  80168c:	3c 30                	cmp    $0x30,%al
  80168e:	75 1d                	jne    8016ad <strtol+0x9c>
  801690:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801694:	48 83 c0 01          	add    $0x1,%rax
  801698:	0f b6 00             	movzbl (%rax),%eax
  80169b:	3c 78                	cmp    $0x78,%al
  80169d:	75 0e                	jne    8016ad <strtol+0x9c>
		s += 2, base = 16;
  80169f:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8016a4:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8016ab:	eb 2c                	jmp    8016d9 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8016ad:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016b1:	75 19                	jne    8016cc <strtol+0xbb>
  8016b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b7:	0f b6 00             	movzbl (%rax),%eax
  8016ba:	3c 30                	cmp    $0x30,%al
  8016bc:	75 0e                	jne    8016cc <strtol+0xbb>
		s++, base = 8;
  8016be:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016c3:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8016ca:	eb 0d                	jmp    8016d9 <strtol+0xc8>
	else if (base == 0)
  8016cc:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016d0:	75 07                	jne    8016d9 <strtol+0xc8>
		base = 10;
  8016d2:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016dd:	0f b6 00             	movzbl (%rax),%eax
  8016e0:	3c 2f                	cmp    $0x2f,%al
  8016e2:	7e 1d                	jle    801701 <strtol+0xf0>
  8016e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e8:	0f b6 00             	movzbl (%rax),%eax
  8016eb:	3c 39                	cmp    $0x39,%al
  8016ed:	7f 12                	jg     801701 <strtol+0xf0>
			dig = *s - '0';
  8016ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f3:	0f b6 00             	movzbl (%rax),%eax
  8016f6:	0f be c0             	movsbl %al,%eax
  8016f9:	83 e8 30             	sub    $0x30,%eax
  8016fc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016ff:	eb 4e                	jmp    80174f <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801701:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801705:	0f b6 00             	movzbl (%rax),%eax
  801708:	3c 60                	cmp    $0x60,%al
  80170a:	7e 1d                	jle    801729 <strtol+0x118>
  80170c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801710:	0f b6 00             	movzbl (%rax),%eax
  801713:	3c 7a                	cmp    $0x7a,%al
  801715:	7f 12                	jg     801729 <strtol+0x118>
			dig = *s - 'a' + 10;
  801717:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80171b:	0f b6 00             	movzbl (%rax),%eax
  80171e:	0f be c0             	movsbl %al,%eax
  801721:	83 e8 57             	sub    $0x57,%eax
  801724:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801727:	eb 26                	jmp    80174f <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801729:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80172d:	0f b6 00             	movzbl (%rax),%eax
  801730:	3c 40                	cmp    $0x40,%al
  801732:	7e 48                	jle    80177c <strtol+0x16b>
  801734:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801738:	0f b6 00             	movzbl (%rax),%eax
  80173b:	3c 5a                	cmp    $0x5a,%al
  80173d:	7f 3d                	jg     80177c <strtol+0x16b>
			dig = *s - 'A' + 10;
  80173f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801743:	0f b6 00             	movzbl (%rax),%eax
  801746:	0f be c0             	movsbl %al,%eax
  801749:	83 e8 37             	sub    $0x37,%eax
  80174c:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80174f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801752:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801755:	7c 02                	jl     801759 <strtol+0x148>
			break;
  801757:	eb 23                	jmp    80177c <strtol+0x16b>
		s++, val = (val * base) + dig;
  801759:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80175e:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801761:	48 98                	cltq   
  801763:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801768:	48 89 c2             	mov    %rax,%rdx
  80176b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80176e:	48 98                	cltq   
  801770:	48 01 d0             	add    %rdx,%rax
  801773:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801777:	e9 5d ff ff ff       	jmpq   8016d9 <strtol+0xc8>

	if (endptr)
  80177c:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801781:	74 0b                	je     80178e <strtol+0x17d>
		*endptr = (char *) s;
  801783:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801787:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80178b:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80178e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801792:	74 09                	je     80179d <strtol+0x18c>
  801794:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801798:	48 f7 d8             	neg    %rax
  80179b:	eb 04                	jmp    8017a1 <strtol+0x190>
  80179d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8017a1:	c9                   	leaveq 
  8017a2:	c3                   	retq   

00000000008017a3 <strstr>:

char * strstr(const char *in, const char *str)
{
  8017a3:	55                   	push   %rbp
  8017a4:	48 89 e5             	mov    %rsp,%rbp
  8017a7:	48 83 ec 30          	sub    $0x30,%rsp
  8017ab:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8017af:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  8017b3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017b7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017bb:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017bf:	0f b6 00             	movzbl (%rax),%eax
  8017c2:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  8017c5:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8017c9:	75 06                	jne    8017d1 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  8017cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017cf:	eb 6b                	jmp    80183c <strstr+0x99>

    len = strlen(str);
  8017d1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017d5:	48 89 c7             	mov    %rax,%rdi
  8017d8:	48 b8 79 10 80 00 00 	movabs $0x801079,%rax
  8017df:	00 00 00 
  8017e2:	ff d0                	callq  *%rax
  8017e4:	48 98                	cltq   
  8017e6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  8017ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ee:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017f2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017f6:	0f b6 00             	movzbl (%rax),%eax
  8017f9:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  8017fc:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801800:	75 07                	jne    801809 <strstr+0x66>
                return (char *) 0;
  801802:	b8 00 00 00 00       	mov    $0x0,%eax
  801807:	eb 33                	jmp    80183c <strstr+0x99>
        } while (sc != c);
  801809:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80180d:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801810:	75 d8                	jne    8017ea <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  801812:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801816:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80181a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80181e:	48 89 ce             	mov    %rcx,%rsi
  801821:	48 89 c7             	mov    %rax,%rdi
  801824:	48 b8 9a 12 80 00 00 	movabs $0x80129a,%rax
  80182b:	00 00 00 
  80182e:	ff d0                	callq  *%rax
  801830:	85 c0                	test   %eax,%eax
  801832:	75 b6                	jne    8017ea <strstr+0x47>

    return (char *) (in - 1);
  801834:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801838:	48 83 e8 01          	sub    $0x1,%rax
}
  80183c:	c9                   	leaveq 
  80183d:	c3                   	retq   

000000000080183e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80183e:	55                   	push   %rbp
  80183f:	48 89 e5             	mov    %rsp,%rbp
  801842:	53                   	push   %rbx
  801843:	48 83 ec 48          	sub    $0x48,%rsp
  801847:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80184a:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80184d:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801851:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801855:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801859:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80185d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801860:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801864:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801868:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80186c:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801870:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801874:	4c 89 c3             	mov    %r8,%rbx
  801877:	cd 30                	int    $0x30
  801879:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80187d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801881:	74 3e                	je     8018c1 <syscall+0x83>
  801883:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801888:	7e 37                	jle    8018c1 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80188a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80188e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801891:	49 89 d0             	mov    %rdx,%r8
  801894:	89 c1                	mov    %eax,%ecx
  801896:	48 ba e0 3d 80 00 00 	movabs $0x803de0,%rdx
  80189d:	00 00 00 
  8018a0:	be 23 00 00 00       	mov    $0x23,%esi
  8018a5:	48 bf fd 3d 80 00 00 	movabs $0x803dfd,%rdi
  8018ac:	00 00 00 
  8018af:	b8 00 00 00 00       	mov    $0x0,%eax
  8018b4:	49 b9 f7 02 80 00 00 	movabs $0x8002f7,%r9
  8018bb:	00 00 00 
  8018be:	41 ff d1             	callq  *%r9

	return ret;
  8018c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018c5:	48 83 c4 48          	add    $0x48,%rsp
  8018c9:	5b                   	pop    %rbx
  8018ca:	5d                   	pop    %rbp
  8018cb:	c3                   	retq   

00000000008018cc <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8018cc:	55                   	push   %rbp
  8018cd:	48 89 e5             	mov    %rsp,%rbp
  8018d0:	48 83 ec 20          	sub    $0x20,%rsp
  8018d4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018d8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8018dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018e0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018e4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018eb:	00 
  8018ec:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018f2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018f8:	48 89 d1             	mov    %rdx,%rcx
  8018fb:	48 89 c2             	mov    %rax,%rdx
  8018fe:	be 00 00 00 00       	mov    $0x0,%esi
  801903:	bf 00 00 00 00       	mov    $0x0,%edi
  801908:	48 b8 3e 18 80 00 00 	movabs $0x80183e,%rax
  80190f:	00 00 00 
  801912:	ff d0                	callq  *%rax
}
  801914:	c9                   	leaveq 
  801915:	c3                   	retq   

0000000000801916 <sys_cgetc>:

int
sys_cgetc(void)
{
  801916:	55                   	push   %rbp
  801917:	48 89 e5             	mov    %rsp,%rbp
  80191a:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80191e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801925:	00 
  801926:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80192c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801932:	b9 00 00 00 00       	mov    $0x0,%ecx
  801937:	ba 00 00 00 00       	mov    $0x0,%edx
  80193c:	be 00 00 00 00       	mov    $0x0,%esi
  801941:	bf 01 00 00 00       	mov    $0x1,%edi
  801946:	48 b8 3e 18 80 00 00 	movabs $0x80183e,%rax
  80194d:	00 00 00 
  801950:	ff d0                	callq  *%rax
}
  801952:	c9                   	leaveq 
  801953:	c3                   	retq   

0000000000801954 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801954:	55                   	push   %rbp
  801955:	48 89 e5             	mov    %rsp,%rbp
  801958:	48 83 ec 10          	sub    $0x10,%rsp
  80195c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80195f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801962:	48 98                	cltq   
  801964:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80196b:	00 
  80196c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801972:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801978:	b9 00 00 00 00       	mov    $0x0,%ecx
  80197d:	48 89 c2             	mov    %rax,%rdx
  801980:	be 01 00 00 00       	mov    $0x1,%esi
  801985:	bf 03 00 00 00       	mov    $0x3,%edi
  80198a:	48 b8 3e 18 80 00 00 	movabs $0x80183e,%rax
  801991:	00 00 00 
  801994:	ff d0                	callq  *%rax
}
  801996:	c9                   	leaveq 
  801997:	c3                   	retq   

0000000000801998 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801998:	55                   	push   %rbp
  801999:	48 89 e5             	mov    %rsp,%rbp
  80199c:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8019a0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019a7:	00 
  8019a8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019ae:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019b4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8019be:	be 00 00 00 00       	mov    $0x0,%esi
  8019c3:	bf 02 00 00 00       	mov    $0x2,%edi
  8019c8:	48 b8 3e 18 80 00 00 	movabs $0x80183e,%rax
  8019cf:	00 00 00 
  8019d2:	ff d0                	callq  *%rax
}
  8019d4:	c9                   	leaveq 
  8019d5:	c3                   	retq   

00000000008019d6 <sys_yield>:

void
sys_yield(void)
{
  8019d6:	55                   	push   %rbp
  8019d7:	48 89 e5             	mov    %rsp,%rbp
  8019da:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8019de:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019e5:	00 
  8019e6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019ec:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019f2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8019fc:	be 00 00 00 00       	mov    $0x0,%esi
  801a01:	bf 0b 00 00 00       	mov    $0xb,%edi
  801a06:	48 b8 3e 18 80 00 00 	movabs $0x80183e,%rax
  801a0d:	00 00 00 
  801a10:	ff d0                	callq  *%rax
}
  801a12:	c9                   	leaveq 
  801a13:	c3                   	retq   

0000000000801a14 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801a14:	55                   	push   %rbp
  801a15:	48 89 e5             	mov    %rsp,%rbp
  801a18:	48 83 ec 20          	sub    $0x20,%rsp
  801a1c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a1f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a23:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801a26:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a29:	48 63 c8             	movslq %eax,%rcx
  801a2c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a30:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a33:	48 98                	cltq   
  801a35:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a3c:	00 
  801a3d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a43:	49 89 c8             	mov    %rcx,%r8
  801a46:	48 89 d1             	mov    %rdx,%rcx
  801a49:	48 89 c2             	mov    %rax,%rdx
  801a4c:	be 01 00 00 00       	mov    $0x1,%esi
  801a51:	bf 04 00 00 00       	mov    $0x4,%edi
  801a56:	48 b8 3e 18 80 00 00 	movabs $0x80183e,%rax
  801a5d:	00 00 00 
  801a60:	ff d0                	callq  *%rax
}
  801a62:	c9                   	leaveq 
  801a63:	c3                   	retq   

0000000000801a64 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801a64:	55                   	push   %rbp
  801a65:	48 89 e5             	mov    %rsp,%rbp
  801a68:	48 83 ec 30          	sub    $0x30,%rsp
  801a6c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a6f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a73:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a76:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801a7a:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801a7e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a81:	48 63 c8             	movslq %eax,%rcx
  801a84:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a88:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a8b:	48 63 f0             	movslq %eax,%rsi
  801a8e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a92:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a95:	48 98                	cltq   
  801a97:	48 89 0c 24          	mov    %rcx,(%rsp)
  801a9b:	49 89 f9             	mov    %rdi,%r9
  801a9e:	49 89 f0             	mov    %rsi,%r8
  801aa1:	48 89 d1             	mov    %rdx,%rcx
  801aa4:	48 89 c2             	mov    %rax,%rdx
  801aa7:	be 01 00 00 00       	mov    $0x1,%esi
  801aac:	bf 05 00 00 00       	mov    $0x5,%edi
  801ab1:	48 b8 3e 18 80 00 00 	movabs $0x80183e,%rax
  801ab8:	00 00 00 
  801abb:	ff d0                	callq  *%rax
}
  801abd:	c9                   	leaveq 
  801abe:	c3                   	retq   

0000000000801abf <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801abf:	55                   	push   %rbp
  801ac0:	48 89 e5             	mov    %rsp,%rbp
  801ac3:	48 83 ec 20          	sub    $0x20,%rsp
  801ac7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801aca:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801ace:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ad2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ad5:	48 98                	cltq   
  801ad7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ade:	00 
  801adf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ae5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aeb:	48 89 d1             	mov    %rdx,%rcx
  801aee:	48 89 c2             	mov    %rax,%rdx
  801af1:	be 01 00 00 00       	mov    $0x1,%esi
  801af6:	bf 06 00 00 00       	mov    $0x6,%edi
  801afb:	48 b8 3e 18 80 00 00 	movabs $0x80183e,%rax
  801b02:	00 00 00 
  801b05:	ff d0                	callq  *%rax
}
  801b07:	c9                   	leaveq 
  801b08:	c3                   	retq   

0000000000801b09 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801b09:	55                   	push   %rbp
  801b0a:	48 89 e5             	mov    %rsp,%rbp
  801b0d:	48 83 ec 10          	sub    $0x10,%rsp
  801b11:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b14:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801b17:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b1a:	48 63 d0             	movslq %eax,%rdx
  801b1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b20:	48 98                	cltq   
  801b22:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b29:	00 
  801b2a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b30:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b36:	48 89 d1             	mov    %rdx,%rcx
  801b39:	48 89 c2             	mov    %rax,%rdx
  801b3c:	be 01 00 00 00       	mov    $0x1,%esi
  801b41:	bf 08 00 00 00       	mov    $0x8,%edi
  801b46:	48 b8 3e 18 80 00 00 	movabs $0x80183e,%rax
  801b4d:	00 00 00 
  801b50:	ff d0                	callq  *%rax
}
  801b52:	c9                   	leaveq 
  801b53:	c3                   	retq   

0000000000801b54 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801b54:	55                   	push   %rbp
  801b55:	48 89 e5             	mov    %rsp,%rbp
  801b58:	48 83 ec 20          	sub    $0x20,%rsp
  801b5c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b5f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801b63:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b67:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b6a:	48 98                	cltq   
  801b6c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b73:	00 
  801b74:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b7a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b80:	48 89 d1             	mov    %rdx,%rcx
  801b83:	48 89 c2             	mov    %rax,%rdx
  801b86:	be 01 00 00 00       	mov    $0x1,%esi
  801b8b:	bf 09 00 00 00       	mov    $0x9,%edi
  801b90:	48 b8 3e 18 80 00 00 	movabs $0x80183e,%rax
  801b97:	00 00 00 
  801b9a:	ff d0                	callq  *%rax
}
  801b9c:	c9                   	leaveq 
  801b9d:	c3                   	retq   

0000000000801b9e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801b9e:	55                   	push   %rbp
  801b9f:	48 89 e5             	mov    %rsp,%rbp
  801ba2:	48 83 ec 20          	sub    $0x20,%rsp
  801ba6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ba9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801bad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bb1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bb4:	48 98                	cltq   
  801bb6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bbd:	00 
  801bbe:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bc4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bca:	48 89 d1             	mov    %rdx,%rcx
  801bcd:	48 89 c2             	mov    %rax,%rdx
  801bd0:	be 01 00 00 00       	mov    $0x1,%esi
  801bd5:	bf 0a 00 00 00       	mov    $0xa,%edi
  801bda:	48 b8 3e 18 80 00 00 	movabs $0x80183e,%rax
  801be1:	00 00 00 
  801be4:	ff d0                	callq  *%rax
}
  801be6:	c9                   	leaveq 
  801be7:	c3                   	retq   

0000000000801be8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801be8:	55                   	push   %rbp
  801be9:	48 89 e5             	mov    %rsp,%rbp
  801bec:	48 83 ec 20          	sub    $0x20,%rsp
  801bf0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bf3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bf7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801bfb:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801bfe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c01:	48 63 f0             	movslq %eax,%rsi
  801c04:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801c08:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c0b:	48 98                	cltq   
  801c0d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c11:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c18:	00 
  801c19:	49 89 f1             	mov    %rsi,%r9
  801c1c:	49 89 c8             	mov    %rcx,%r8
  801c1f:	48 89 d1             	mov    %rdx,%rcx
  801c22:	48 89 c2             	mov    %rax,%rdx
  801c25:	be 00 00 00 00       	mov    $0x0,%esi
  801c2a:	bf 0c 00 00 00       	mov    $0xc,%edi
  801c2f:	48 b8 3e 18 80 00 00 	movabs $0x80183e,%rax
  801c36:	00 00 00 
  801c39:	ff d0                	callq  *%rax
}
  801c3b:	c9                   	leaveq 
  801c3c:	c3                   	retq   

0000000000801c3d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801c3d:	55                   	push   %rbp
  801c3e:	48 89 e5             	mov    %rsp,%rbp
  801c41:	48 83 ec 10          	sub    $0x10,%rsp
  801c45:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801c49:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c4d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c54:	00 
  801c55:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c5b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c61:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c66:	48 89 c2             	mov    %rax,%rdx
  801c69:	be 01 00 00 00       	mov    $0x1,%esi
  801c6e:	bf 0d 00 00 00       	mov    $0xd,%edi
  801c73:	48 b8 3e 18 80 00 00 	movabs $0x80183e,%rax
  801c7a:	00 00 00 
  801c7d:	ff d0                	callq  *%rax
}
  801c7f:	c9                   	leaveq 
  801c80:	c3                   	retq   

0000000000801c81 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801c81:	55                   	push   %rbp
  801c82:	48 89 e5             	mov    %rsp,%rbp
  801c85:	48 83 ec 08          	sub    $0x8,%rsp
  801c89:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801c8d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c91:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801c98:	ff ff ff 
  801c9b:	48 01 d0             	add    %rdx,%rax
  801c9e:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801ca2:	c9                   	leaveq 
  801ca3:	c3                   	retq   

0000000000801ca4 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801ca4:	55                   	push   %rbp
  801ca5:	48 89 e5             	mov    %rsp,%rbp
  801ca8:	48 83 ec 08          	sub    $0x8,%rsp
  801cac:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801cb0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cb4:	48 89 c7             	mov    %rax,%rdi
  801cb7:	48 b8 81 1c 80 00 00 	movabs $0x801c81,%rax
  801cbe:	00 00 00 
  801cc1:	ff d0                	callq  *%rax
  801cc3:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801cc9:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801ccd:	c9                   	leaveq 
  801cce:	c3                   	retq   

0000000000801ccf <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801ccf:	55                   	push   %rbp
  801cd0:	48 89 e5             	mov    %rsp,%rbp
  801cd3:	48 83 ec 18          	sub    $0x18,%rsp
  801cd7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801cdb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801ce2:	eb 6b                	jmp    801d4f <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801ce4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ce7:	48 98                	cltq   
  801ce9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801cef:	48 c1 e0 0c          	shl    $0xc,%rax
  801cf3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801cf7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cfb:	48 c1 e8 15          	shr    $0x15,%rax
  801cff:	48 89 c2             	mov    %rax,%rdx
  801d02:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801d09:	01 00 00 
  801d0c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d10:	83 e0 01             	and    $0x1,%eax
  801d13:	48 85 c0             	test   %rax,%rax
  801d16:	74 21                	je     801d39 <fd_alloc+0x6a>
  801d18:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d1c:	48 c1 e8 0c          	shr    $0xc,%rax
  801d20:	48 89 c2             	mov    %rax,%rdx
  801d23:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d2a:	01 00 00 
  801d2d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d31:	83 e0 01             	and    $0x1,%eax
  801d34:	48 85 c0             	test   %rax,%rax
  801d37:	75 12                	jne    801d4b <fd_alloc+0x7c>
			*fd_store = fd;
  801d39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d3d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d41:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801d44:	b8 00 00 00 00       	mov    $0x0,%eax
  801d49:	eb 1a                	jmp    801d65 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801d4b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801d4f:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801d53:	7e 8f                	jle    801ce4 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801d55:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d59:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801d60:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801d65:	c9                   	leaveq 
  801d66:	c3                   	retq   

0000000000801d67 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801d67:	55                   	push   %rbp
  801d68:	48 89 e5             	mov    %rsp,%rbp
  801d6b:	48 83 ec 20          	sub    $0x20,%rsp
  801d6f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801d72:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801d76:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801d7a:	78 06                	js     801d82 <fd_lookup+0x1b>
  801d7c:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801d80:	7e 07                	jle    801d89 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801d82:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d87:	eb 6c                	jmp    801df5 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801d89:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d8c:	48 98                	cltq   
  801d8e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d94:	48 c1 e0 0c          	shl    $0xc,%rax
  801d98:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801d9c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801da0:	48 c1 e8 15          	shr    $0x15,%rax
  801da4:	48 89 c2             	mov    %rax,%rdx
  801da7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801dae:	01 00 00 
  801db1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801db5:	83 e0 01             	and    $0x1,%eax
  801db8:	48 85 c0             	test   %rax,%rax
  801dbb:	74 21                	je     801dde <fd_lookup+0x77>
  801dbd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dc1:	48 c1 e8 0c          	shr    $0xc,%rax
  801dc5:	48 89 c2             	mov    %rax,%rdx
  801dc8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801dcf:	01 00 00 
  801dd2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dd6:	83 e0 01             	and    $0x1,%eax
  801dd9:	48 85 c0             	test   %rax,%rax
  801ddc:	75 07                	jne    801de5 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801dde:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801de3:	eb 10                	jmp    801df5 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801de5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801de9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ded:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801df0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801df5:	c9                   	leaveq 
  801df6:	c3                   	retq   

0000000000801df7 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801df7:	55                   	push   %rbp
  801df8:	48 89 e5             	mov    %rsp,%rbp
  801dfb:	48 83 ec 30          	sub    $0x30,%rsp
  801dff:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e03:	89 f0                	mov    %esi,%eax
  801e05:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801e08:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e0c:	48 89 c7             	mov    %rax,%rdi
  801e0f:	48 b8 81 1c 80 00 00 	movabs $0x801c81,%rax
  801e16:	00 00 00 
  801e19:	ff d0                	callq  *%rax
  801e1b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801e1f:	48 89 d6             	mov    %rdx,%rsi
  801e22:	89 c7                	mov    %eax,%edi
  801e24:	48 b8 67 1d 80 00 00 	movabs $0x801d67,%rax
  801e2b:	00 00 00 
  801e2e:	ff d0                	callq  *%rax
  801e30:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e33:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e37:	78 0a                	js     801e43 <fd_close+0x4c>
	    || fd != fd2)
  801e39:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e3d:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801e41:	74 12                	je     801e55 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801e43:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801e47:	74 05                	je     801e4e <fd_close+0x57>
  801e49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e4c:	eb 05                	jmp    801e53 <fd_close+0x5c>
  801e4e:	b8 00 00 00 00       	mov    $0x0,%eax
  801e53:	eb 69                	jmp    801ebe <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801e55:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e59:	8b 00                	mov    (%rax),%eax
  801e5b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801e5f:	48 89 d6             	mov    %rdx,%rsi
  801e62:	89 c7                	mov    %eax,%edi
  801e64:	48 b8 c0 1e 80 00 00 	movabs $0x801ec0,%rax
  801e6b:	00 00 00 
  801e6e:	ff d0                	callq  *%rax
  801e70:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e73:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e77:	78 2a                	js     801ea3 <fd_close+0xac>
		if (dev->dev_close)
  801e79:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e7d:	48 8b 40 20          	mov    0x20(%rax),%rax
  801e81:	48 85 c0             	test   %rax,%rax
  801e84:	74 16                	je     801e9c <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801e86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e8a:	48 8b 40 20          	mov    0x20(%rax),%rax
  801e8e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801e92:	48 89 d7             	mov    %rdx,%rdi
  801e95:	ff d0                	callq  *%rax
  801e97:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e9a:	eb 07                	jmp    801ea3 <fd_close+0xac>
		else
			r = 0;
  801e9c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801ea3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ea7:	48 89 c6             	mov    %rax,%rsi
  801eaa:	bf 00 00 00 00       	mov    $0x0,%edi
  801eaf:	48 b8 bf 1a 80 00 00 	movabs $0x801abf,%rax
  801eb6:	00 00 00 
  801eb9:	ff d0                	callq  *%rax
	return r;
  801ebb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801ebe:	c9                   	leaveq 
  801ebf:	c3                   	retq   

0000000000801ec0 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801ec0:	55                   	push   %rbp
  801ec1:	48 89 e5             	mov    %rsp,%rbp
  801ec4:	48 83 ec 20          	sub    $0x20,%rsp
  801ec8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801ecb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801ecf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801ed6:	eb 41                	jmp    801f19 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801ed8:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801edf:	00 00 00 
  801ee2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801ee5:	48 63 d2             	movslq %edx,%rdx
  801ee8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801eec:	8b 00                	mov    (%rax),%eax
  801eee:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801ef1:	75 22                	jne    801f15 <dev_lookup+0x55>
			*dev = devtab[i];
  801ef3:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801efa:	00 00 00 
  801efd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f00:	48 63 d2             	movslq %edx,%rdx
  801f03:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801f07:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f0b:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f0e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f13:	eb 60                	jmp    801f75 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801f15:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f19:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801f20:	00 00 00 
  801f23:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f26:	48 63 d2             	movslq %edx,%rdx
  801f29:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f2d:	48 85 c0             	test   %rax,%rax
  801f30:	75 a6                	jne    801ed8 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801f32:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  801f39:	00 00 00 
  801f3c:	48 8b 00             	mov    (%rax),%rax
  801f3f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801f45:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801f48:	89 c6                	mov    %eax,%esi
  801f4a:	48 bf 10 3e 80 00 00 	movabs $0x803e10,%rdi
  801f51:	00 00 00 
  801f54:	b8 00 00 00 00       	mov    $0x0,%eax
  801f59:	48 b9 30 05 80 00 00 	movabs $0x800530,%rcx
  801f60:	00 00 00 
  801f63:	ff d1                	callq  *%rcx
	*dev = 0;
  801f65:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f69:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801f70:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801f75:	c9                   	leaveq 
  801f76:	c3                   	retq   

0000000000801f77 <close>:

int
close(int fdnum)
{
  801f77:	55                   	push   %rbp
  801f78:	48 89 e5             	mov    %rsp,%rbp
  801f7b:	48 83 ec 20          	sub    $0x20,%rsp
  801f7f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f82:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f86:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f89:	48 89 d6             	mov    %rdx,%rsi
  801f8c:	89 c7                	mov    %eax,%edi
  801f8e:	48 b8 67 1d 80 00 00 	movabs $0x801d67,%rax
  801f95:	00 00 00 
  801f98:	ff d0                	callq  *%rax
  801f9a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f9d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fa1:	79 05                	jns    801fa8 <close+0x31>
		return r;
  801fa3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fa6:	eb 18                	jmp    801fc0 <close+0x49>
	else
		return fd_close(fd, 1);
  801fa8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fac:	be 01 00 00 00       	mov    $0x1,%esi
  801fb1:	48 89 c7             	mov    %rax,%rdi
  801fb4:	48 b8 f7 1d 80 00 00 	movabs $0x801df7,%rax
  801fbb:	00 00 00 
  801fbe:	ff d0                	callq  *%rax
}
  801fc0:	c9                   	leaveq 
  801fc1:	c3                   	retq   

0000000000801fc2 <close_all>:

void
close_all(void)
{
  801fc2:	55                   	push   %rbp
  801fc3:	48 89 e5             	mov    %rsp,%rbp
  801fc6:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801fca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801fd1:	eb 15                	jmp    801fe8 <close_all+0x26>
		close(i);
  801fd3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fd6:	89 c7                	mov    %eax,%edi
  801fd8:	48 b8 77 1f 80 00 00 	movabs $0x801f77,%rax
  801fdf:	00 00 00 
  801fe2:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801fe4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801fe8:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801fec:	7e e5                	jle    801fd3 <close_all+0x11>
		close(i);
}
  801fee:	c9                   	leaveq 
  801fef:	c3                   	retq   

0000000000801ff0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801ff0:	55                   	push   %rbp
  801ff1:	48 89 e5             	mov    %rsp,%rbp
  801ff4:	48 83 ec 40          	sub    $0x40,%rsp
  801ff8:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801ffb:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801ffe:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802002:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802005:	48 89 d6             	mov    %rdx,%rsi
  802008:	89 c7                	mov    %eax,%edi
  80200a:	48 b8 67 1d 80 00 00 	movabs $0x801d67,%rax
  802011:	00 00 00 
  802014:	ff d0                	callq  *%rax
  802016:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802019:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80201d:	79 08                	jns    802027 <dup+0x37>
		return r;
  80201f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802022:	e9 70 01 00 00       	jmpq   802197 <dup+0x1a7>
	close(newfdnum);
  802027:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80202a:	89 c7                	mov    %eax,%edi
  80202c:	48 b8 77 1f 80 00 00 	movabs $0x801f77,%rax
  802033:	00 00 00 
  802036:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802038:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80203b:	48 98                	cltq   
  80203d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802043:	48 c1 e0 0c          	shl    $0xc,%rax
  802047:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80204b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80204f:	48 89 c7             	mov    %rax,%rdi
  802052:	48 b8 a4 1c 80 00 00 	movabs $0x801ca4,%rax
  802059:	00 00 00 
  80205c:	ff d0                	callq  *%rax
  80205e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802062:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802066:	48 89 c7             	mov    %rax,%rdi
  802069:	48 b8 a4 1c 80 00 00 	movabs $0x801ca4,%rax
  802070:	00 00 00 
  802073:	ff d0                	callq  *%rax
  802075:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802079:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80207d:	48 c1 e8 15          	shr    $0x15,%rax
  802081:	48 89 c2             	mov    %rax,%rdx
  802084:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80208b:	01 00 00 
  80208e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802092:	83 e0 01             	and    $0x1,%eax
  802095:	48 85 c0             	test   %rax,%rax
  802098:	74 73                	je     80210d <dup+0x11d>
  80209a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80209e:	48 c1 e8 0c          	shr    $0xc,%rax
  8020a2:	48 89 c2             	mov    %rax,%rdx
  8020a5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020ac:	01 00 00 
  8020af:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020b3:	83 e0 01             	and    $0x1,%eax
  8020b6:	48 85 c0             	test   %rax,%rax
  8020b9:	74 52                	je     80210d <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8020bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020bf:	48 c1 e8 0c          	shr    $0xc,%rax
  8020c3:	48 89 c2             	mov    %rax,%rdx
  8020c6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020cd:	01 00 00 
  8020d0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020d4:	25 07 0e 00 00       	and    $0xe07,%eax
  8020d9:	89 c1                	mov    %eax,%ecx
  8020db:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8020df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020e3:	41 89 c8             	mov    %ecx,%r8d
  8020e6:	48 89 d1             	mov    %rdx,%rcx
  8020e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8020ee:	48 89 c6             	mov    %rax,%rsi
  8020f1:	bf 00 00 00 00       	mov    $0x0,%edi
  8020f6:	48 b8 64 1a 80 00 00 	movabs $0x801a64,%rax
  8020fd:	00 00 00 
  802100:	ff d0                	callq  *%rax
  802102:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802105:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802109:	79 02                	jns    80210d <dup+0x11d>
			goto err;
  80210b:	eb 57                	jmp    802164 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80210d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802111:	48 c1 e8 0c          	shr    $0xc,%rax
  802115:	48 89 c2             	mov    %rax,%rdx
  802118:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80211f:	01 00 00 
  802122:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802126:	25 07 0e 00 00       	and    $0xe07,%eax
  80212b:	89 c1                	mov    %eax,%ecx
  80212d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802131:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802135:	41 89 c8             	mov    %ecx,%r8d
  802138:	48 89 d1             	mov    %rdx,%rcx
  80213b:	ba 00 00 00 00       	mov    $0x0,%edx
  802140:	48 89 c6             	mov    %rax,%rsi
  802143:	bf 00 00 00 00       	mov    $0x0,%edi
  802148:	48 b8 64 1a 80 00 00 	movabs $0x801a64,%rax
  80214f:	00 00 00 
  802152:	ff d0                	callq  *%rax
  802154:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802157:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80215b:	79 02                	jns    80215f <dup+0x16f>
		goto err;
  80215d:	eb 05                	jmp    802164 <dup+0x174>

	return newfdnum;
  80215f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802162:	eb 33                	jmp    802197 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802164:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802168:	48 89 c6             	mov    %rax,%rsi
  80216b:	bf 00 00 00 00       	mov    $0x0,%edi
  802170:	48 b8 bf 1a 80 00 00 	movabs $0x801abf,%rax
  802177:	00 00 00 
  80217a:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80217c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802180:	48 89 c6             	mov    %rax,%rsi
  802183:	bf 00 00 00 00       	mov    $0x0,%edi
  802188:	48 b8 bf 1a 80 00 00 	movabs $0x801abf,%rax
  80218f:	00 00 00 
  802192:	ff d0                	callq  *%rax
	return r;
  802194:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802197:	c9                   	leaveq 
  802198:	c3                   	retq   

0000000000802199 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802199:	55                   	push   %rbp
  80219a:	48 89 e5             	mov    %rsp,%rbp
  80219d:	48 83 ec 40          	sub    $0x40,%rsp
  8021a1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8021a4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8021a8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8021ac:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8021b0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8021b3:	48 89 d6             	mov    %rdx,%rsi
  8021b6:	89 c7                	mov    %eax,%edi
  8021b8:	48 b8 67 1d 80 00 00 	movabs $0x801d67,%rax
  8021bf:	00 00 00 
  8021c2:	ff d0                	callq  *%rax
  8021c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021cb:	78 24                	js     8021f1 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8021cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021d1:	8b 00                	mov    (%rax),%eax
  8021d3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8021d7:	48 89 d6             	mov    %rdx,%rsi
  8021da:	89 c7                	mov    %eax,%edi
  8021dc:	48 b8 c0 1e 80 00 00 	movabs $0x801ec0,%rax
  8021e3:	00 00 00 
  8021e6:	ff d0                	callq  *%rax
  8021e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021ef:	79 05                	jns    8021f6 <read+0x5d>
		return r;
  8021f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021f4:	eb 76                	jmp    80226c <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8021f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021fa:	8b 40 08             	mov    0x8(%rax),%eax
  8021fd:	83 e0 03             	and    $0x3,%eax
  802200:	83 f8 01             	cmp    $0x1,%eax
  802203:	75 3a                	jne    80223f <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802205:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  80220c:	00 00 00 
  80220f:	48 8b 00             	mov    (%rax),%rax
  802212:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802218:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80221b:	89 c6                	mov    %eax,%esi
  80221d:	48 bf 2f 3e 80 00 00 	movabs $0x803e2f,%rdi
  802224:	00 00 00 
  802227:	b8 00 00 00 00       	mov    $0x0,%eax
  80222c:	48 b9 30 05 80 00 00 	movabs $0x800530,%rcx
  802233:	00 00 00 
  802236:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802238:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80223d:	eb 2d                	jmp    80226c <read+0xd3>
	}
	if (!dev->dev_read)
  80223f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802243:	48 8b 40 10          	mov    0x10(%rax),%rax
  802247:	48 85 c0             	test   %rax,%rax
  80224a:	75 07                	jne    802253 <read+0xba>
		return -E_NOT_SUPP;
  80224c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802251:	eb 19                	jmp    80226c <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802253:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802257:	48 8b 40 10          	mov    0x10(%rax),%rax
  80225b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80225f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802263:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802267:	48 89 cf             	mov    %rcx,%rdi
  80226a:	ff d0                	callq  *%rax
}
  80226c:	c9                   	leaveq 
  80226d:	c3                   	retq   

000000000080226e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80226e:	55                   	push   %rbp
  80226f:	48 89 e5             	mov    %rsp,%rbp
  802272:	48 83 ec 30          	sub    $0x30,%rsp
  802276:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802279:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80227d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802281:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802288:	eb 49                	jmp    8022d3 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80228a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80228d:	48 98                	cltq   
  80228f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802293:	48 29 c2             	sub    %rax,%rdx
  802296:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802299:	48 63 c8             	movslq %eax,%rcx
  80229c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022a0:	48 01 c1             	add    %rax,%rcx
  8022a3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022a6:	48 89 ce             	mov    %rcx,%rsi
  8022a9:	89 c7                	mov    %eax,%edi
  8022ab:	48 b8 99 21 80 00 00 	movabs $0x802199,%rax
  8022b2:	00 00 00 
  8022b5:	ff d0                	callq  *%rax
  8022b7:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8022ba:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8022be:	79 05                	jns    8022c5 <readn+0x57>
			return m;
  8022c0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022c3:	eb 1c                	jmp    8022e1 <readn+0x73>
		if (m == 0)
  8022c5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8022c9:	75 02                	jne    8022cd <readn+0x5f>
			break;
  8022cb:	eb 11                	jmp    8022de <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8022cd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022d0:	01 45 fc             	add    %eax,-0x4(%rbp)
  8022d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022d6:	48 98                	cltq   
  8022d8:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8022dc:	72 ac                	jb     80228a <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8022de:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8022e1:	c9                   	leaveq 
  8022e2:	c3                   	retq   

00000000008022e3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8022e3:	55                   	push   %rbp
  8022e4:	48 89 e5             	mov    %rsp,%rbp
  8022e7:	48 83 ec 40          	sub    $0x40,%rsp
  8022eb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8022ee:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8022f2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022f6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022fa:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022fd:	48 89 d6             	mov    %rdx,%rsi
  802300:	89 c7                	mov    %eax,%edi
  802302:	48 b8 67 1d 80 00 00 	movabs $0x801d67,%rax
  802309:	00 00 00 
  80230c:	ff d0                	callq  *%rax
  80230e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802311:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802315:	78 24                	js     80233b <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802317:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80231b:	8b 00                	mov    (%rax),%eax
  80231d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802321:	48 89 d6             	mov    %rdx,%rsi
  802324:	89 c7                	mov    %eax,%edi
  802326:	48 b8 c0 1e 80 00 00 	movabs $0x801ec0,%rax
  80232d:	00 00 00 
  802330:	ff d0                	callq  *%rax
  802332:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802335:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802339:	79 05                	jns    802340 <write+0x5d>
		return r;
  80233b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80233e:	eb 75                	jmp    8023b5 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802340:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802344:	8b 40 08             	mov    0x8(%rax),%eax
  802347:	83 e0 03             	and    $0x3,%eax
  80234a:	85 c0                	test   %eax,%eax
  80234c:	75 3a                	jne    802388 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80234e:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  802355:	00 00 00 
  802358:	48 8b 00             	mov    (%rax),%rax
  80235b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802361:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802364:	89 c6                	mov    %eax,%esi
  802366:	48 bf 4b 3e 80 00 00 	movabs $0x803e4b,%rdi
  80236d:	00 00 00 
  802370:	b8 00 00 00 00       	mov    $0x0,%eax
  802375:	48 b9 30 05 80 00 00 	movabs $0x800530,%rcx
  80237c:	00 00 00 
  80237f:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802381:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802386:	eb 2d                	jmp    8023b5 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802388:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80238c:	48 8b 40 18          	mov    0x18(%rax),%rax
  802390:	48 85 c0             	test   %rax,%rax
  802393:	75 07                	jne    80239c <write+0xb9>
		return -E_NOT_SUPP;
  802395:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80239a:	eb 19                	jmp    8023b5 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80239c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023a0:	48 8b 40 18          	mov    0x18(%rax),%rax
  8023a4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8023a8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8023ac:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8023b0:	48 89 cf             	mov    %rcx,%rdi
  8023b3:	ff d0                	callq  *%rax
}
  8023b5:	c9                   	leaveq 
  8023b6:	c3                   	retq   

00000000008023b7 <seek>:

int
seek(int fdnum, off_t offset)
{
  8023b7:	55                   	push   %rbp
  8023b8:	48 89 e5             	mov    %rsp,%rbp
  8023bb:	48 83 ec 18          	sub    $0x18,%rsp
  8023bf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023c2:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023c5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023c9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023cc:	48 89 d6             	mov    %rdx,%rsi
  8023cf:	89 c7                	mov    %eax,%edi
  8023d1:	48 b8 67 1d 80 00 00 	movabs $0x801d67,%rax
  8023d8:	00 00 00 
  8023db:	ff d0                	callq  *%rax
  8023dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023e4:	79 05                	jns    8023eb <seek+0x34>
		return r;
  8023e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023e9:	eb 0f                	jmp    8023fa <seek+0x43>
	fd->fd_offset = offset;
  8023eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023ef:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8023f2:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8023f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023fa:	c9                   	leaveq 
  8023fb:	c3                   	retq   

00000000008023fc <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8023fc:	55                   	push   %rbp
  8023fd:	48 89 e5             	mov    %rsp,%rbp
  802400:	48 83 ec 30          	sub    $0x30,%rsp
  802404:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802407:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80240a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80240e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802411:	48 89 d6             	mov    %rdx,%rsi
  802414:	89 c7                	mov    %eax,%edi
  802416:	48 b8 67 1d 80 00 00 	movabs $0x801d67,%rax
  80241d:	00 00 00 
  802420:	ff d0                	callq  *%rax
  802422:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802425:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802429:	78 24                	js     80244f <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80242b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80242f:	8b 00                	mov    (%rax),%eax
  802431:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802435:	48 89 d6             	mov    %rdx,%rsi
  802438:	89 c7                	mov    %eax,%edi
  80243a:	48 b8 c0 1e 80 00 00 	movabs $0x801ec0,%rax
  802441:	00 00 00 
  802444:	ff d0                	callq  *%rax
  802446:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802449:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80244d:	79 05                	jns    802454 <ftruncate+0x58>
		return r;
  80244f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802452:	eb 72                	jmp    8024c6 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802454:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802458:	8b 40 08             	mov    0x8(%rax),%eax
  80245b:	83 e0 03             	and    $0x3,%eax
  80245e:	85 c0                	test   %eax,%eax
  802460:	75 3a                	jne    80249c <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802462:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  802469:	00 00 00 
  80246c:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80246f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802475:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802478:	89 c6                	mov    %eax,%esi
  80247a:	48 bf 68 3e 80 00 00 	movabs $0x803e68,%rdi
  802481:	00 00 00 
  802484:	b8 00 00 00 00       	mov    $0x0,%eax
  802489:	48 b9 30 05 80 00 00 	movabs $0x800530,%rcx
  802490:	00 00 00 
  802493:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802495:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80249a:	eb 2a                	jmp    8024c6 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80249c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024a0:	48 8b 40 30          	mov    0x30(%rax),%rax
  8024a4:	48 85 c0             	test   %rax,%rax
  8024a7:	75 07                	jne    8024b0 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8024a9:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024ae:	eb 16                	jmp    8024c6 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8024b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024b4:	48 8b 40 30          	mov    0x30(%rax),%rax
  8024b8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8024bc:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8024bf:	89 ce                	mov    %ecx,%esi
  8024c1:	48 89 d7             	mov    %rdx,%rdi
  8024c4:	ff d0                	callq  *%rax
}
  8024c6:	c9                   	leaveq 
  8024c7:	c3                   	retq   

00000000008024c8 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8024c8:	55                   	push   %rbp
  8024c9:	48 89 e5             	mov    %rsp,%rbp
  8024cc:	48 83 ec 30          	sub    $0x30,%rsp
  8024d0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024d3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024d7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024db:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024de:	48 89 d6             	mov    %rdx,%rsi
  8024e1:	89 c7                	mov    %eax,%edi
  8024e3:	48 b8 67 1d 80 00 00 	movabs $0x801d67,%rax
  8024ea:	00 00 00 
  8024ed:	ff d0                	callq  *%rax
  8024ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024f6:	78 24                	js     80251c <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024fc:	8b 00                	mov    (%rax),%eax
  8024fe:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802502:	48 89 d6             	mov    %rdx,%rsi
  802505:	89 c7                	mov    %eax,%edi
  802507:	48 b8 c0 1e 80 00 00 	movabs $0x801ec0,%rax
  80250e:	00 00 00 
  802511:	ff d0                	callq  *%rax
  802513:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802516:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80251a:	79 05                	jns    802521 <fstat+0x59>
		return r;
  80251c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80251f:	eb 5e                	jmp    80257f <fstat+0xb7>
	if (!dev->dev_stat)
  802521:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802525:	48 8b 40 28          	mov    0x28(%rax),%rax
  802529:	48 85 c0             	test   %rax,%rax
  80252c:	75 07                	jne    802535 <fstat+0x6d>
		return -E_NOT_SUPP;
  80252e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802533:	eb 4a                	jmp    80257f <fstat+0xb7>
	stat->st_name[0] = 0;
  802535:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802539:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80253c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802540:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802547:	00 00 00 
	stat->st_isdir = 0;
  80254a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80254e:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802555:	00 00 00 
	stat->st_dev = dev;
  802558:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80255c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802560:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802567:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80256b:	48 8b 40 28          	mov    0x28(%rax),%rax
  80256f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802573:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802577:	48 89 ce             	mov    %rcx,%rsi
  80257a:	48 89 d7             	mov    %rdx,%rdi
  80257d:	ff d0                	callq  *%rax
}
  80257f:	c9                   	leaveq 
  802580:	c3                   	retq   

0000000000802581 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802581:	55                   	push   %rbp
  802582:	48 89 e5             	mov    %rsp,%rbp
  802585:	48 83 ec 20          	sub    $0x20,%rsp
  802589:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80258d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802591:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802595:	be 00 00 00 00       	mov    $0x0,%esi
  80259a:	48 89 c7             	mov    %rax,%rdi
  80259d:	48 b8 6f 26 80 00 00 	movabs $0x80266f,%rax
  8025a4:	00 00 00 
  8025a7:	ff d0                	callq  *%rax
  8025a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025b0:	79 05                	jns    8025b7 <stat+0x36>
		return fd;
  8025b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025b5:	eb 2f                	jmp    8025e6 <stat+0x65>
	r = fstat(fd, stat);
  8025b7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8025bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025be:	48 89 d6             	mov    %rdx,%rsi
  8025c1:	89 c7                	mov    %eax,%edi
  8025c3:	48 b8 c8 24 80 00 00 	movabs $0x8024c8,%rax
  8025ca:	00 00 00 
  8025cd:	ff d0                	callq  *%rax
  8025cf:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8025d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025d5:	89 c7                	mov    %eax,%edi
  8025d7:	48 b8 77 1f 80 00 00 	movabs $0x801f77,%rax
  8025de:	00 00 00 
  8025e1:	ff d0                	callq  *%rax
	return r;
  8025e3:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8025e6:	c9                   	leaveq 
  8025e7:	c3                   	retq   

00000000008025e8 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8025e8:	55                   	push   %rbp
  8025e9:	48 89 e5             	mov    %rsp,%rbp
  8025ec:	48 83 ec 10          	sub    $0x10,%rsp
  8025f0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8025f3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8025f7:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8025fe:	00 00 00 
  802601:	8b 00                	mov    (%rax),%eax
  802603:	85 c0                	test   %eax,%eax
  802605:	75 1d                	jne    802624 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802607:	bf 01 00 00 00       	mov    $0x1,%edi
  80260c:	48 b8 92 37 80 00 00 	movabs $0x803792,%rax
  802613:	00 00 00 
  802616:	ff d0                	callq  *%rax
  802618:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  80261f:	00 00 00 
  802622:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802624:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80262b:	00 00 00 
  80262e:	8b 00                	mov    (%rax),%eax
  802630:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802633:	b9 07 00 00 00       	mov    $0x7,%ecx
  802638:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  80263f:	00 00 00 
  802642:	89 c7                	mov    %eax,%edi
  802644:	48 b8 30 37 80 00 00 	movabs $0x803730,%rax
  80264b:	00 00 00 
  80264e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802650:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802654:	ba 00 00 00 00       	mov    $0x0,%edx
  802659:	48 89 c6             	mov    %rax,%rsi
  80265c:	bf 00 00 00 00       	mov    $0x0,%edi
  802661:	48 b8 2a 36 80 00 00 	movabs $0x80362a,%rax
  802668:	00 00 00 
  80266b:	ff d0                	callq  *%rax
}
  80266d:	c9                   	leaveq 
  80266e:	c3                   	retq   

000000000080266f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80266f:	55                   	push   %rbp
  802670:	48 89 e5             	mov    %rsp,%rbp
  802673:	48 83 ec 30          	sub    $0x30,%rsp
  802677:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80267b:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  80267e:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802685:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  80268c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802693:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802698:	75 08                	jne    8026a2 <open+0x33>
	{
		return r;
  80269a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80269d:	e9 f2 00 00 00       	jmpq   802794 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  8026a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026a6:	48 89 c7             	mov    %rax,%rdi
  8026a9:	48 b8 79 10 80 00 00 	movabs $0x801079,%rax
  8026b0:	00 00 00 
  8026b3:	ff d0                	callq  *%rax
  8026b5:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8026b8:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  8026bf:	7e 0a                	jle    8026cb <open+0x5c>
	{
		return -E_BAD_PATH;
  8026c1:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8026c6:	e9 c9 00 00 00       	jmpq   802794 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  8026cb:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8026d2:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  8026d3:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8026d7:	48 89 c7             	mov    %rax,%rdi
  8026da:	48 b8 cf 1c 80 00 00 	movabs $0x801ccf,%rax
  8026e1:	00 00 00 
  8026e4:	ff d0                	callq  *%rax
  8026e6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026ed:	78 09                	js     8026f8 <open+0x89>
  8026ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026f3:	48 85 c0             	test   %rax,%rax
  8026f6:	75 08                	jne    802700 <open+0x91>
		{
			return r;
  8026f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026fb:	e9 94 00 00 00       	jmpq   802794 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802700:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802704:	ba 00 04 00 00       	mov    $0x400,%edx
  802709:	48 89 c6             	mov    %rax,%rsi
  80270c:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802713:	00 00 00 
  802716:	48 b8 77 11 80 00 00 	movabs $0x801177,%rax
  80271d:	00 00 00 
  802720:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802722:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802729:	00 00 00 
  80272c:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  80272f:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802735:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802739:	48 89 c6             	mov    %rax,%rsi
  80273c:	bf 01 00 00 00       	mov    $0x1,%edi
  802741:	48 b8 e8 25 80 00 00 	movabs $0x8025e8,%rax
  802748:	00 00 00 
  80274b:	ff d0                	callq  *%rax
  80274d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802750:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802754:	79 2b                	jns    802781 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802756:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80275a:	be 00 00 00 00       	mov    $0x0,%esi
  80275f:	48 89 c7             	mov    %rax,%rdi
  802762:	48 b8 f7 1d 80 00 00 	movabs $0x801df7,%rax
  802769:	00 00 00 
  80276c:	ff d0                	callq  *%rax
  80276e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802771:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802775:	79 05                	jns    80277c <open+0x10d>
			{
				return d;
  802777:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80277a:	eb 18                	jmp    802794 <open+0x125>
			}
			return r;
  80277c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80277f:	eb 13                	jmp    802794 <open+0x125>
		}	
		return fd2num(fd_store);
  802781:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802785:	48 89 c7             	mov    %rax,%rdi
  802788:	48 b8 81 1c 80 00 00 	movabs $0x801c81,%rax
  80278f:	00 00 00 
  802792:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802794:	c9                   	leaveq 
  802795:	c3                   	retq   

0000000000802796 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802796:	55                   	push   %rbp
  802797:	48 89 e5             	mov    %rsp,%rbp
  80279a:	48 83 ec 10          	sub    $0x10,%rsp
  80279e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8027a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027a6:	8b 50 0c             	mov    0xc(%rax),%edx
  8027a9:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8027b0:	00 00 00 
  8027b3:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8027b5:	be 00 00 00 00       	mov    $0x0,%esi
  8027ba:	bf 06 00 00 00       	mov    $0x6,%edi
  8027bf:	48 b8 e8 25 80 00 00 	movabs $0x8025e8,%rax
  8027c6:	00 00 00 
  8027c9:	ff d0                	callq  *%rax
}
  8027cb:	c9                   	leaveq 
  8027cc:	c3                   	retq   

00000000008027cd <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8027cd:	55                   	push   %rbp
  8027ce:	48 89 e5             	mov    %rsp,%rbp
  8027d1:	48 83 ec 30          	sub    $0x30,%rsp
  8027d5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027d9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8027dd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  8027e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  8027e8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8027ed:	74 07                	je     8027f6 <devfile_read+0x29>
  8027ef:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8027f4:	75 07                	jne    8027fd <devfile_read+0x30>
		return -E_INVAL;
  8027f6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027fb:	eb 77                	jmp    802874 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8027fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802801:	8b 50 0c             	mov    0xc(%rax),%edx
  802804:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80280b:	00 00 00 
  80280e:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802810:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802817:	00 00 00 
  80281a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80281e:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802822:	be 00 00 00 00       	mov    $0x0,%esi
  802827:	bf 03 00 00 00       	mov    $0x3,%edi
  80282c:	48 b8 e8 25 80 00 00 	movabs $0x8025e8,%rax
  802833:	00 00 00 
  802836:	ff d0                	callq  *%rax
  802838:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80283b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80283f:	7f 05                	jg     802846 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802841:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802844:	eb 2e                	jmp    802874 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802846:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802849:	48 63 d0             	movslq %eax,%rdx
  80284c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802850:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  802857:	00 00 00 
  80285a:	48 89 c7             	mov    %rax,%rdi
  80285d:	48 b8 09 14 80 00 00 	movabs $0x801409,%rax
  802864:	00 00 00 
  802867:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802869:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80286d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802871:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802874:	c9                   	leaveq 
  802875:	c3                   	retq   

0000000000802876 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802876:	55                   	push   %rbp
  802877:	48 89 e5             	mov    %rsp,%rbp
  80287a:	48 83 ec 30          	sub    $0x30,%rsp
  80287e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802882:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802886:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  80288a:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802891:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802896:	74 07                	je     80289f <devfile_write+0x29>
  802898:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80289d:	75 08                	jne    8028a7 <devfile_write+0x31>
		return r;
  80289f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028a2:	e9 9a 00 00 00       	jmpq   802941 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8028a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028ab:	8b 50 0c             	mov    0xc(%rax),%edx
  8028ae:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8028b5:	00 00 00 
  8028b8:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  8028ba:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8028c1:	00 
  8028c2:	76 08                	jbe    8028cc <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  8028c4:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8028cb:	00 
	}
	fsipcbuf.write.req_n = n;
  8028cc:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8028d3:	00 00 00 
  8028d6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028da:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  8028de:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028e2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028e6:	48 89 c6             	mov    %rax,%rsi
  8028e9:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  8028f0:	00 00 00 
  8028f3:	48 b8 09 14 80 00 00 	movabs $0x801409,%rax
  8028fa:	00 00 00 
  8028fd:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  8028ff:	be 00 00 00 00       	mov    $0x0,%esi
  802904:	bf 04 00 00 00       	mov    $0x4,%edi
  802909:	48 b8 e8 25 80 00 00 	movabs $0x8025e8,%rax
  802910:	00 00 00 
  802913:	ff d0                	callq  *%rax
  802915:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802918:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80291c:	7f 20                	jg     80293e <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  80291e:	48 bf 8e 3e 80 00 00 	movabs $0x803e8e,%rdi
  802925:	00 00 00 
  802928:	b8 00 00 00 00       	mov    $0x0,%eax
  80292d:	48 ba 30 05 80 00 00 	movabs $0x800530,%rdx
  802934:	00 00 00 
  802937:	ff d2                	callq  *%rdx
		return r;
  802939:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80293c:	eb 03                	jmp    802941 <devfile_write+0xcb>
	}
	return r;
  80293e:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802941:	c9                   	leaveq 
  802942:	c3                   	retq   

0000000000802943 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802943:	55                   	push   %rbp
  802944:	48 89 e5             	mov    %rsp,%rbp
  802947:	48 83 ec 20          	sub    $0x20,%rsp
  80294b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80294f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802953:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802957:	8b 50 0c             	mov    0xc(%rax),%edx
  80295a:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802961:	00 00 00 
  802964:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802966:	be 00 00 00 00       	mov    $0x0,%esi
  80296b:	bf 05 00 00 00       	mov    $0x5,%edi
  802970:	48 b8 e8 25 80 00 00 	movabs $0x8025e8,%rax
  802977:	00 00 00 
  80297a:	ff d0                	callq  *%rax
  80297c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80297f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802983:	79 05                	jns    80298a <devfile_stat+0x47>
		return r;
  802985:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802988:	eb 56                	jmp    8029e0 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80298a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80298e:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  802995:	00 00 00 
  802998:	48 89 c7             	mov    %rax,%rdi
  80299b:	48 b8 e5 10 80 00 00 	movabs $0x8010e5,%rax
  8029a2:	00 00 00 
  8029a5:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8029a7:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8029ae:	00 00 00 
  8029b1:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8029b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029bb:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8029c1:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8029c8:	00 00 00 
  8029cb:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8029d1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029d5:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8029db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029e0:	c9                   	leaveq 
  8029e1:	c3                   	retq   

00000000008029e2 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8029e2:	55                   	push   %rbp
  8029e3:	48 89 e5             	mov    %rsp,%rbp
  8029e6:	48 83 ec 10          	sub    $0x10,%rsp
  8029ea:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8029ee:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8029f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029f5:	8b 50 0c             	mov    0xc(%rax),%edx
  8029f8:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8029ff:	00 00 00 
  802a02:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802a04:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802a0b:	00 00 00 
  802a0e:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802a11:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802a14:	be 00 00 00 00       	mov    $0x0,%esi
  802a19:	bf 02 00 00 00       	mov    $0x2,%edi
  802a1e:	48 b8 e8 25 80 00 00 	movabs $0x8025e8,%rax
  802a25:	00 00 00 
  802a28:	ff d0                	callq  *%rax
}
  802a2a:	c9                   	leaveq 
  802a2b:	c3                   	retq   

0000000000802a2c <remove>:

// Delete a file
int
remove(const char *path)
{
  802a2c:	55                   	push   %rbp
  802a2d:	48 89 e5             	mov    %rsp,%rbp
  802a30:	48 83 ec 10          	sub    $0x10,%rsp
  802a34:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802a38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a3c:	48 89 c7             	mov    %rax,%rdi
  802a3f:	48 b8 79 10 80 00 00 	movabs $0x801079,%rax
  802a46:	00 00 00 
  802a49:	ff d0                	callq  *%rax
  802a4b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802a50:	7e 07                	jle    802a59 <remove+0x2d>
		return -E_BAD_PATH;
  802a52:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802a57:	eb 33                	jmp    802a8c <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802a59:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a5d:	48 89 c6             	mov    %rax,%rsi
  802a60:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802a67:	00 00 00 
  802a6a:	48 b8 e5 10 80 00 00 	movabs $0x8010e5,%rax
  802a71:	00 00 00 
  802a74:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802a76:	be 00 00 00 00       	mov    $0x0,%esi
  802a7b:	bf 07 00 00 00       	mov    $0x7,%edi
  802a80:	48 b8 e8 25 80 00 00 	movabs $0x8025e8,%rax
  802a87:	00 00 00 
  802a8a:	ff d0                	callq  *%rax
}
  802a8c:	c9                   	leaveq 
  802a8d:	c3                   	retq   

0000000000802a8e <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802a8e:	55                   	push   %rbp
  802a8f:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802a92:	be 00 00 00 00       	mov    $0x0,%esi
  802a97:	bf 08 00 00 00       	mov    $0x8,%edi
  802a9c:	48 b8 e8 25 80 00 00 	movabs $0x8025e8,%rax
  802aa3:	00 00 00 
  802aa6:	ff d0                	callq  *%rax
}
  802aa8:	5d                   	pop    %rbp
  802aa9:	c3                   	retq   

0000000000802aaa <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  802aaa:	55                   	push   %rbp
  802aab:	48 89 e5             	mov    %rsp,%rbp
  802aae:	48 83 ec 20          	sub    $0x20,%rsp
  802ab2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  802ab6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aba:	8b 40 0c             	mov    0xc(%rax),%eax
  802abd:	85 c0                	test   %eax,%eax
  802abf:	7e 67                	jle    802b28 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802ac1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ac5:	8b 40 04             	mov    0x4(%rax),%eax
  802ac8:	48 63 d0             	movslq %eax,%rdx
  802acb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802acf:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802ad3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ad7:	8b 00                	mov    (%rax),%eax
  802ad9:	48 89 ce             	mov    %rcx,%rsi
  802adc:	89 c7                	mov    %eax,%edi
  802ade:	48 b8 e3 22 80 00 00 	movabs $0x8022e3,%rax
  802ae5:	00 00 00 
  802ae8:	ff d0                	callq  *%rax
  802aea:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  802aed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802af1:	7e 13                	jle    802b06 <writebuf+0x5c>
			b->result += result;
  802af3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802af7:	8b 50 08             	mov    0x8(%rax),%edx
  802afa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802afd:	01 c2                	add    %eax,%edx
  802aff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b03:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  802b06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b0a:	8b 40 04             	mov    0x4(%rax),%eax
  802b0d:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802b10:	74 16                	je     802b28 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  802b12:	b8 00 00 00 00       	mov    $0x0,%eax
  802b17:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b1b:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  802b1f:	89 c2                	mov    %eax,%edx
  802b21:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b25:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  802b28:	c9                   	leaveq 
  802b29:	c3                   	retq   

0000000000802b2a <putch>:

static void
putch(int ch, void *thunk)
{
  802b2a:	55                   	push   %rbp
  802b2b:	48 89 e5             	mov    %rsp,%rbp
  802b2e:	48 83 ec 20          	sub    $0x20,%rsp
  802b32:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b35:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  802b39:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b3d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  802b41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b45:	8b 40 04             	mov    0x4(%rax),%eax
  802b48:	8d 48 01             	lea    0x1(%rax),%ecx
  802b4b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802b4f:	89 4a 04             	mov    %ecx,0x4(%rdx)
  802b52:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802b55:	89 d1                	mov    %edx,%ecx
  802b57:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802b5b:	48 98                	cltq   
  802b5d:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  802b61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b65:	8b 40 04             	mov    0x4(%rax),%eax
  802b68:	3d 00 01 00 00       	cmp    $0x100,%eax
  802b6d:	75 1e                	jne    802b8d <putch+0x63>
		writebuf(b);
  802b6f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b73:	48 89 c7             	mov    %rax,%rdi
  802b76:	48 b8 aa 2a 80 00 00 	movabs $0x802aaa,%rax
  802b7d:	00 00 00 
  802b80:	ff d0                	callq  *%rax
		b->idx = 0;
  802b82:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b86:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  802b8d:	c9                   	leaveq 
  802b8e:	c3                   	retq   

0000000000802b8f <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802b8f:	55                   	push   %rbp
  802b90:	48 89 e5             	mov    %rsp,%rbp
  802b93:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  802b9a:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  802ba0:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  802ba7:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  802bae:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  802bb4:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  802bba:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802bc1:	00 00 00 
	b.result = 0;
  802bc4:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  802bcb:	00 00 00 
	b.error = 1;
  802bce:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  802bd5:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802bd8:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  802bdf:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  802be6:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802bed:	48 89 c6             	mov    %rax,%rsi
  802bf0:	48 bf 2a 2b 80 00 00 	movabs $0x802b2a,%rdi
  802bf7:	00 00 00 
  802bfa:	48 b8 e3 08 80 00 00 	movabs $0x8008e3,%rax
  802c01:	00 00 00 
  802c04:	ff d0                	callq  *%rax
	if (b.idx > 0)
  802c06:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  802c0c:	85 c0                	test   %eax,%eax
  802c0e:	7e 16                	jle    802c26 <vfprintf+0x97>
		writebuf(&b);
  802c10:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802c17:	48 89 c7             	mov    %rax,%rdi
  802c1a:	48 b8 aa 2a 80 00 00 	movabs $0x802aaa,%rax
  802c21:	00 00 00 
  802c24:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  802c26:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802c2c:	85 c0                	test   %eax,%eax
  802c2e:	74 08                	je     802c38 <vfprintf+0xa9>
  802c30:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802c36:	eb 06                	jmp    802c3e <vfprintf+0xaf>
  802c38:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  802c3e:	c9                   	leaveq 
  802c3f:	c3                   	retq   

0000000000802c40 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802c40:	55                   	push   %rbp
  802c41:	48 89 e5             	mov    %rsp,%rbp
  802c44:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802c4b:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  802c51:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802c58:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802c5f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802c66:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802c6d:	84 c0                	test   %al,%al
  802c6f:	74 20                	je     802c91 <fprintf+0x51>
  802c71:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802c75:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802c79:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802c7d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802c81:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802c85:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802c89:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802c8d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802c91:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802c98:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  802c9f:	00 00 00 
  802ca2:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802ca9:	00 00 00 
  802cac:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802cb0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802cb7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802cbe:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  802cc5:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802ccc:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  802cd3:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  802cd9:	48 89 ce             	mov    %rcx,%rsi
  802cdc:	89 c7                	mov    %eax,%edi
  802cde:	48 b8 8f 2b 80 00 00 	movabs $0x802b8f,%rax
  802ce5:	00 00 00 
  802ce8:	ff d0                	callq  *%rax
  802cea:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  802cf0:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802cf6:	c9                   	leaveq 
  802cf7:	c3                   	retq   

0000000000802cf8 <printf>:

int
printf(const char *fmt, ...)
{
  802cf8:	55                   	push   %rbp
  802cf9:	48 89 e5             	mov    %rsp,%rbp
  802cfc:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802d03:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  802d0a:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802d11:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802d18:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802d1f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802d26:	84 c0                	test   %al,%al
  802d28:	74 20                	je     802d4a <printf+0x52>
  802d2a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802d2e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802d32:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802d36:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802d3a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802d3e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802d42:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802d46:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802d4a:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802d51:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  802d58:	00 00 00 
  802d5b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802d62:	00 00 00 
  802d65:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802d69:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802d70:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802d77:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  802d7e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802d85:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  802d8c:	48 89 c6             	mov    %rax,%rsi
  802d8f:	bf 01 00 00 00       	mov    $0x1,%edi
  802d94:	48 b8 8f 2b 80 00 00 	movabs $0x802b8f,%rax
  802d9b:	00 00 00 
  802d9e:	ff d0                	callq  *%rax
  802da0:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  802da6:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802dac:	c9                   	leaveq 
  802dad:	c3                   	retq   

0000000000802dae <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802dae:	55                   	push   %rbp
  802daf:	48 89 e5             	mov    %rsp,%rbp
  802db2:	53                   	push   %rbx
  802db3:	48 83 ec 38          	sub    $0x38,%rsp
  802db7:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802dbb:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802dbf:	48 89 c7             	mov    %rax,%rdi
  802dc2:	48 b8 cf 1c 80 00 00 	movabs $0x801ccf,%rax
  802dc9:	00 00 00 
  802dcc:	ff d0                	callq  *%rax
  802dce:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802dd1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802dd5:	0f 88 bf 01 00 00    	js     802f9a <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802ddb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ddf:	ba 07 04 00 00       	mov    $0x407,%edx
  802de4:	48 89 c6             	mov    %rax,%rsi
  802de7:	bf 00 00 00 00       	mov    $0x0,%edi
  802dec:	48 b8 14 1a 80 00 00 	movabs $0x801a14,%rax
  802df3:	00 00 00 
  802df6:	ff d0                	callq  *%rax
  802df8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802dfb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802dff:	0f 88 95 01 00 00    	js     802f9a <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802e05:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802e09:	48 89 c7             	mov    %rax,%rdi
  802e0c:	48 b8 cf 1c 80 00 00 	movabs $0x801ccf,%rax
  802e13:	00 00 00 
  802e16:	ff d0                	callq  *%rax
  802e18:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802e1b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802e1f:	0f 88 5d 01 00 00    	js     802f82 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e25:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e29:	ba 07 04 00 00       	mov    $0x407,%edx
  802e2e:	48 89 c6             	mov    %rax,%rsi
  802e31:	bf 00 00 00 00       	mov    $0x0,%edi
  802e36:	48 b8 14 1a 80 00 00 	movabs $0x801a14,%rax
  802e3d:	00 00 00 
  802e40:	ff d0                	callq  *%rax
  802e42:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802e45:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802e49:	0f 88 33 01 00 00    	js     802f82 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802e4f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e53:	48 89 c7             	mov    %rax,%rdi
  802e56:	48 b8 a4 1c 80 00 00 	movabs $0x801ca4,%rax
  802e5d:	00 00 00 
  802e60:	ff d0                	callq  *%rax
  802e62:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e66:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e6a:	ba 07 04 00 00       	mov    $0x407,%edx
  802e6f:	48 89 c6             	mov    %rax,%rsi
  802e72:	bf 00 00 00 00       	mov    $0x0,%edi
  802e77:	48 b8 14 1a 80 00 00 	movabs $0x801a14,%rax
  802e7e:	00 00 00 
  802e81:	ff d0                	callq  *%rax
  802e83:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802e86:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802e8a:	79 05                	jns    802e91 <pipe+0xe3>
		goto err2;
  802e8c:	e9 d9 00 00 00       	jmpq   802f6a <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e91:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e95:	48 89 c7             	mov    %rax,%rdi
  802e98:	48 b8 a4 1c 80 00 00 	movabs $0x801ca4,%rax
  802e9f:	00 00 00 
  802ea2:	ff d0                	callq  *%rax
  802ea4:	48 89 c2             	mov    %rax,%rdx
  802ea7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802eab:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  802eb1:	48 89 d1             	mov    %rdx,%rcx
  802eb4:	ba 00 00 00 00       	mov    $0x0,%edx
  802eb9:	48 89 c6             	mov    %rax,%rsi
  802ebc:	bf 00 00 00 00       	mov    $0x0,%edi
  802ec1:	48 b8 64 1a 80 00 00 	movabs $0x801a64,%rax
  802ec8:	00 00 00 
  802ecb:	ff d0                	callq  *%rax
  802ecd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802ed0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802ed4:	79 1b                	jns    802ef1 <pipe+0x143>
		goto err3;
  802ed6:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  802ed7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802edb:	48 89 c6             	mov    %rax,%rsi
  802ede:	bf 00 00 00 00       	mov    $0x0,%edi
  802ee3:	48 b8 bf 1a 80 00 00 	movabs $0x801abf,%rax
  802eea:	00 00 00 
  802eed:	ff d0                	callq  *%rax
  802eef:	eb 79                	jmp    802f6a <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802ef1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ef5:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802efc:	00 00 00 
  802eff:	8b 12                	mov    (%rdx),%edx
  802f01:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802f03:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f07:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  802f0e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f12:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802f19:	00 00 00 
  802f1c:	8b 12                	mov    (%rdx),%edx
  802f1e:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  802f20:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f24:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802f2b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f2f:	48 89 c7             	mov    %rax,%rdi
  802f32:	48 b8 81 1c 80 00 00 	movabs $0x801c81,%rax
  802f39:	00 00 00 
  802f3c:	ff d0                	callq  *%rax
  802f3e:	89 c2                	mov    %eax,%edx
  802f40:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802f44:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  802f46:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802f4a:	48 8d 58 04          	lea    0x4(%rax),%rbx
  802f4e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f52:	48 89 c7             	mov    %rax,%rdi
  802f55:	48 b8 81 1c 80 00 00 	movabs $0x801c81,%rax
  802f5c:	00 00 00 
  802f5f:	ff d0                	callq  *%rax
  802f61:	89 03                	mov    %eax,(%rbx)
	return 0;
  802f63:	b8 00 00 00 00       	mov    $0x0,%eax
  802f68:	eb 33                	jmp    802f9d <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  802f6a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f6e:	48 89 c6             	mov    %rax,%rsi
  802f71:	bf 00 00 00 00       	mov    $0x0,%edi
  802f76:	48 b8 bf 1a 80 00 00 	movabs $0x801abf,%rax
  802f7d:	00 00 00 
  802f80:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  802f82:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f86:	48 89 c6             	mov    %rax,%rsi
  802f89:	bf 00 00 00 00       	mov    $0x0,%edi
  802f8e:	48 b8 bf 1a 80 00 00 	movabs $0x801abf,%rax
  802f95:	00 00 00 
  802f98:	ff d0                	callq  *%rax
    err:
	return r;
  802f9a:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  802f9d:	48 83 c4 38          	add    $0x38,%rsp
  802fa1:	5b                   	pop    %rbx
  802fa2:	5d                   	pop    %rbp
  802fa3:	c3                   	retq   

0000000000802fa4 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802fa4:	55                   	push   %rbp
  802fa5:	48 89 e5             	mov    %rsp,%rbp
  802fa8:	53                   	push   %rbx
  802fa9:	48 83 ec 28          	sub    $0x28,%rsp
  802fad:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802fb1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802fb5:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  802fbc:	00 00 00 
  802fbf:	48 8b 00             	mov    (%rax),%rax
  802fc2:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802fc8:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  802fcb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fcf:	48 89 c7             	mov    %rax,%rdi
  802fd2:	48 b8 14 38 80 00 00 	movabs $0x803814,%rax
  802fd9:	00 00 00 
  802fdc:	ff d0                	callq  *%rax
  802fde:	89 c3                	mov    %eax,%ebx
  802fe0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fe4:	48 89 c7             	mov    %rax,%rdi
  802fe7:	48 b8 14 38 80 00 00 	movabs $0x803814,%rax
  802fee:	00 00 00 
  802ff1:	ff d0                	callq  *%rax
  802ff3:	39 c3                	cmp    %eax,%ebx
  802ff5:	0f 94 c0             	sete   %al
  802ff8:	0f b6 c0             	movzbl %al,%eax
  802ffb:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  802ffe:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803005:	00 00 00 
  803008:	48 8b 00             	mov    (%rax),%rax
  80300b:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803011:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803014:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803017:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80301a:	75 05                	jne    803021 <_pipeisclosed+0x7d>
			return ret;
  80301c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80301f:	eb 4f                	jmp    803070 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803021:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803024:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803027:	74 42                	je     80306b <_pipeisclosed+0xc7>
  803029:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80302d:	75 3c                	jne    80306b <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80302f:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803036:	00 00 00 
  803039:	48 8b 00             	mov    (%rax),%rax
  80303c:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803042:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803045:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803048:	89 c6                	mov    %eax,%esi
  80304a:	48 bf af 3e 80 00 00 	movabs $0x803eaf,%rdi
  803051:	00 00 00 
  803054:	b8 00 00 00 00       	mov    $0x0,%eax
  803059:	49 b8 30 05 80 00 00 	movabs $0x800530,%r8
  803060:	00 00 00 
  803063:	41 ff d0             	callq  *%r8
	}
  803066:	e9 4a ff ff ff       	jmpq   802fb5 <_pipeisclosed+0x11>
  80306b:	e9 45 ff ff ff       	jmpq   802fb5 <_pipeisclosed+0x11>
}
  803070:	48 83 c4 28          	add    $0x28,%rsp
  803074:	5b                   	pop    %rbx
  803075:	5d                   	pop    %rbp
  803076:	c3                   	retq   

0000000000803077 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803077:	55                   	push   %rbp
  803078:	48 89 e5             	mov    %rsp,%rbp
  80307b:	48 83 ec 30          	sub    $0x30,%rsp
  80307f:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803082:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803086:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803089:	48 89 d6             	mov    %rdx,%rsi
  80308c:	89 c7                	mov    %eax,%edi
  80308e:	48 b8 67 1d 80 00 00 	movabs $0x801d67,%rax
  803095:	00 00 00 
  803098:	ff d0                	callq  *%rax
  80309a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80309d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030a1:	79 05                	jns    8030a8 <pipeisclosed+0x31>
		return r;
  8030a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030a6:	eb 31                	jmp    8030d9 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8030a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030ac:	48 89 c7             	mov    %rax,%rdi
  8030af:	48 b8 a4 1c 80 00 00 	movabs $0x801ca4,%rax
  8030b6:	00 00 00 
  8030b9:	ff d0                	callq  *%rax
  8030bb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8030bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030c3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8030c7:	48 89 d6             	mov    %rdx,%rsi
  8030ca:	48 89 c7             	mov    %rax,%rdi
  8030cd:	48 b8 a4 2f 80 00 00 	movabs $0x802fa4,%rax
  8030d4:	00 00 00 
  8030d7:	ff d0                	callq  *%rax
}
  8030d9:	c9                   	leaveq 
  8030da:	c3                   	retq   

00000000008030db <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8030db:	55                   	push   %rbp
  8030dc:	48 89 e5             	mov    %rsp,%rbp
  8030df:	48 83 ec 40          	sub    $0x40,%rsp
  8030e3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8030e7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8030eb:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8030ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030f3:	48 89 c7             	mov    %rax,%rdi
  8030f6:	48 b8 a4 1c 80 00 00 	movabs $0x801ca4,%rax
  8030fd:	00 00 00 
  803100:	ff d0                	callq  *%rax
  803102:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803106:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80310a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80310e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803115:	00 
  803116:	e9 92 00 00 00       	jmpq   8031ad <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80311b:	eb 41                	jmp    80315e <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80311d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803122:	74 09                	je     80312d <devpipe_read+0x52>
				return i;
  803124:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803128:	e9 92 00 00 00       	jmpq   8031bf <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80312d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803131:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803135:	48 89 d6             	mov    %rdx,%rsi
  803138:	48 89 c7             	mov    %rax,%rdi
  80313b:	48 b8 a4 2f 80 00 00 	movabs $0x802fa4,%rax
  803142:	00 00 00 
  803145:	ff d0                	callq  *%rax
  803147:	85 c0                	test   %eax,%eax
  803149:	74 07                	je     803152 <devpipe_read+0x77>
				return 0;
  80314b:	b8 00 00 00 00       	mov    $0x0,%eax
  803150:	eb 6d                	jmp    8031bf <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803152:	48 b8 d6 19 80 00 00 	movabs $0x8019d6,%rax
  803159:	00 00 00 
  80315c:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80315e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803162:	8b 10                	mov    (%rax),%edx
  803164:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803168:	8b 40 04             	mov    0x4(%rax),%eax
  80316b:	39 c2                	cmp    %eax,%edx
  80316d:	74 ae                	je     80311d <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80316f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803173:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803177:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80317b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80317f:	8b 00                	mov    (%rax),%eax
  803181:	99                   	cltd   
  803182:	c1 ea 1b             	shr    $0x1b,%edx
  803185:	01 d0                	add    %edx,%eax
  803187:	83 e0 1f             	and    $0x1f,%eax
  80318a:	29 d0                	sub    %edx,%eax
  80318c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803190:	48 98                	cltq   
  803192:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803197:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803199:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80319d:	8b 00                	mov    (%rax),%eax
  80319f:	8d 50 01             	lea    0x1(%rax),%edx
  8031a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031a6:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8031a8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8031ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031b1:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8031b5:	0f 82 60 ff ff ff    	jb     80311b <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8031bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8031bf:	c9                   	leaveq 
  8031c0:	c3                   	retq   

00000000008031c1 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8031c1:	55                   	push   %rbp
  8031c2:	48 89 e5             	mov    %rsp,%rbp
  8031c5:	48 83 ec 40          	sub    $0x40,%rsp
  8031c9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8031cd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8031d1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8031d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031d9:	48 89 c7             	mov    %rax,%rdi
  8031dc:	48 b8 a4 1c 80 00 00 	movabs $0x801ca4,%rax
  8031e3:	00 00 00 
  8031e6:	ff d0                	callq  *%rax
  8031e8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8031ec:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031f0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8031f4:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8031fb:	00 
  8031fc:	e9 8e 00 00 00       	jmpq   80328f <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803201:	eb 31                	jmp    803234 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803203:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803207:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80320b:	48 89 d6             	mov    %rdx,%rsi
  80320e:	48 89 c7             	mov    %rax,%rdi
  803211:	48 b8 a4 2f 80 00 00 	movabs $0x802fa4,%rax
  803218:	00 00 00 
  80321b:	ff d0                	callq  *%rax
  80321d:	85 c0                	test   %eax,%eax
  80321f:	74 07                	je     803228 <devpipe_write+0x67>
				return 0;
  803221:	b8 00 00 00 00       	mov    $0x0,%eax
  803226:	eb 79                	jmp    8032a1 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803228:	48 b8 d6 19 80 00 00 	movabs $0x8019d6,%rax
  80322f:	00 00 00 
  803232:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803234:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803238:	8b 40 04             	mov    0x4(%rax),%eax
  80323b:	48 63 d0             	movslq %eax,%rdx
  80323e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803242:	8b 00                	mov    (%rax),%eax
  803244:	48 98                	cltq   
  803246:	48 83 c0 20          	add    $0x20,%rax
  80324a:	48 39 c2             	cmp    %rax,%rdx
  80324d:	73 b4                	jae    803203 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80324f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803253:	8b 40 04             	mov    0x4(%rax),%eax
  803256:	99                   	cltd   
  803257:	c1 ea 1b             	shr    $0x1b,%edx
  80325a:	01 d0                	add    %edx,%eax
  80325c:	83 e0 1f             	and    $0x1f,%eax
  80325f:	29 d0                	sub    %edx,%eax
  803261:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803265:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803269:	48 01 ca             	add    %rcx,%rdx
  80326c:	0f b6 0a             	movzbl (%rdx),%ecx
  80326f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803273:	48 98                	cltq   
  803275:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803279:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80327d:	8b 40 04             	mov    0x4(%rax),%eax
  803280:	8d 50 01             	lea    0x1(%rax),%edx
  803283:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803287:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80328a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80328f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803293:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803297:	0f 82 64 ff ff ff    	jb     803201 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80329d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8032a1:	c9                   	leaveq 
  8032a2:	c3                   	retq   

00000000008032a3 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8032a3:	55                   	push   %rbp
  8032a4:	48 89 e5             	mov    %rsp,%rbp
  8032a7:	48 83 ec 20          	sub    $0x20,%rsp
  8032ab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8032af:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8032b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032b7:	48 89 c7             	mov    %rax,%rdi
  8032ba:	48 b8 a4 1c 80 00 00 	movabs $0x801ca4,%rax
  8032c1:	00 00 00 
  8032c4:	ff d0                	callq  *%rax
  8032c6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8032ca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032ce:	48 be c2 3e 80 00 00 	movabs $0x803ec2,%rsi
  8032d5:	00 00 00 
  8032d8:	48 89 c7             	mov    %rax,%rdi
  8032db:	48 b8 e5 10 80 00 00 	movabs $0x8010e5,%rax
  8032e2:	00 00 00 
  8032e5:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8032e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032eb:	8b 50 04             	mov    0x4(%rax),%edx
  8032ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032f2:	8b 00                	mov    (%rax),%eax
  8032f4:	29 c2                	sub    %eax,%edx
  8032f6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032fa:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803300:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803304:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80330b:	00 00 00 
	stat->st_dev = &devpipe;
  80330e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803312:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  803319:	00 00 00 
  80331c:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803323:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803328:	c9                   	leaveq 
  803329:	c3                   	retq   

000000000080332a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80332a:	55                   	push   %rbp
  80332b:	48 89 e5             	mov    %rsp,%rbp
  80332e:	48 83 ec 10          	sub    $0x10,%rsp
  803332:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803336:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80333a:	48 89 c6             	mov    %rax,%rsi
  80333d:	bf 00 00 00 00       	mov    $0x0,%edi
  803342:	48 b8 bf 1a 80 00 00 	movabs $0x801abf,%rax
  803349:	00 00 00 
  80334c:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80334e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803352:	48 89 c7             	mov    %rax,%rdi
  803355:	48 b8 a4 1c 80 00 00 	movabs $0x801ca4,%rax
  80335c:	00 00 00 
  80335f:	ff d0                	callq  *%rax
  803361:	48 89 c6             	mov    %rax,%rsi
  803364:	bf 00 00 00 00       	mov    $0x0,%edi
  803369:	48 b8 bf 1a 80 00 00 	movabs $0x801abf,%rax
  803370:	00 00 00 
  803373:	ff d0                	callq  *%rax
}
  803375:	c9                   	leaveq 
  803376:	c3                   	retq   

0000000000803377 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803377:	55                   	push   %rbp
  803378:	48 89 e5             	mov    %rsp,%rbp
  80337b:	48 83 ec 20          	sub    $0x20,%rsp
  80337f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803382:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803385:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803388:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80338c:	be 01 00 00 00       	mov    $0x1,%esi
  803391:	48 89 c7             	mov    %rax,%rdi
  803394:	48 b8 cc 18 80 00 00 	movabs $0x8018cc,%rax
  80339b:	00 00 00 
  80339e:	ff d0                	callq  *%rax
}
  8033a0:	c9                   	leaveq 
  8033a1:	c3                   	retq   

00000000008033a2 <getchar>:

int
getchar(void)
{
  8033a2:	55                   	push   %rbp
  8033a3:	48 89 e5             	mov    %rsp,%rbp
  8033a6:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8033aa:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8033ae:	ba 01 00 00 00       	mov    $0x1,%edx
  8033b3:	48 89 c6             	mov    %rax,%rsi
  8033b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8033bb:	48 b8 99 21 80 00 00 	movabs $0x802199,%rax
  8033c2:	00 00 00 
  8033c5:	ff d0                	callq  *%rax
  8033c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8033ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033ce:	79 05                	jns    8033d5 <getchar+0x33>
		return r;
  8033d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033d3:	eb 14                	jmp    8033e9 <getchar+0x47>
	if (r < 1)
  8033d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033d9:	7f 07                	jg     8033e2 <getchar+0x40>
		return -E_EOF;
  8033db:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8033e0:	eb 07                	jmp    8033e9 <getchar+0x47>
	return c;
  8033e2:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8033e6:	0f b6 c0             	movzbl %al,%eax
}
  8033e9:	c9                   	leaveq 
  8033ea:	c3                   	retq   

00000000008033eb <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8033eb:	55                   	push   %rbp
  8033ec:	48 89 e5             	mov    %rsp,%rbp
  8033ef:	48 83 ec 20          	sub    $0x20,%rsp
  8033f3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8033f6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8033fa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033fd:	48 89 d6             	mov    %rdx,%rsi
  803400:	89 c7                	mov    %eax,%edi
  803402:	48 b8 67 1d 80 00 00 	movabs $0x801d67,%rax
  803409:	00 00 00 
  80340c:	ff d0                	callq  *%rax
  80340e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803411:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803415:	79 05                	jns    80341c <iscons+0x31>
		return r;
  803417:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80341a:	eb 1a                	jmp    803436 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80341c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803420:	8b 10                	mov    (%rax),%edx
  803422:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  803429:	00 00 00 
  80342c:	8b 00                	mov    (%rax),%eax
  80342e:	39 c2                	cmp    %eax,%edx
  803430:	0f 94 c0             	sete   %al
  803433:	0f b6 c0             	movzbl %al,%eax
}
  803436:	c9                   	leaveq 
  803437:	c3                   	retq   

0000000000803438 <opencons>:

int
opencons(void)
{
  803438:	55                   	push   %rbp
  803439:	48 89 e5             	mov    %rsp,%rbp
  80343c:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803440:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803444:	48 89 c7             	mov    %rax,%rdi
  803447:	48 b8 cf 1c 80 00 00 	movabs $0x801ccf,%rax
  80344e:	00 00 00 
  803451:	ff d0                	callq  *%rax
  803453:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803456:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80345a:	79 05                	jns    803461 <opencons+0x29>
		return r;
  80345c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80345f:	eb 5b                	jmp    8034bc <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803461:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803465:	ba 07 04 00 00       	mov    $0x407,%edx
  80346a:	48 89 c6             	mov    %rax,%rsi
  80346d:	bf 00 00 00 00       	mov    $0x0,%edi
  803472:	48 b8 14 1a 80 00 00 	movabs $0x801a14,%rax
  803479:	00 00 00 
  80347c:	ff d0                	callq  *%rax
  80347e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803481:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803485:	79 05                	jns    80348c <opencons+0x54>
		return r;
  803487:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80348a:	eb 30                	jmp    8034bc <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80348c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803490:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  803497:	00 00 00 
  80349a:	8b 12                	mov    (%rdx),%edx
  80349c:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80349e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034a2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8034a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034ad:	48 89 c7             	mov    %rax,%rdi
  8034b0:	48 b8 81 1c 80 00 00 	movabs $0x801c81,%rax
  8034b7:	00 00 00 
  8034ba:	ff d0                	callq  *%rax
}
  8034bc:	c9                   	leaveq 
  8034bd:	c3                   	retq   

00000000008034be <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8034be:	55                   	push   %rbp
  8034bf:	48 89 e5             	mov    %rsp,%rbp
  8034c2:	48 83 ec 30          	sub    $0x30,%rsp
  8034c6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8034ca:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8034ce:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8034d2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8034d7:	75 07                	jne    8034e0 <devcons_read+0x22>
		return 0;
  8034d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8034de:	eb 4b                	jmp    80352b <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8034e0:	eb 0c                	jmp    8034ee <devcons_read+0x30>
		sys_yield();
  8034e2:	48 b8 d6 19 80 00 00 	movabs $0x8019d6,%rax
  8034e9:	00 00 00 
  8034ec:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8034ee:	48 b8 16 19 80 00 00 	movabs $0x801916,%rax
  8034f5:	00 00 00 
  8034f8:	ff d0                	callq  *%rax
  8034fa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803501:	74 df                	je     8034e2 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803503:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803507:	79 05                	jns    80350e <devcons_read+0x50>
		return c;
  803509:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80350c:	eb 1d                	jmp    80352b <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80350e:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803512:	75 07                	jne    80351b <devcons_read+0x5d>
		return 0;
  803514:	b8 00 00 00 00       	mov    $0x0,%eax
  803519:	eb 10                	jmp    80352b <devcons_read+0x6d>
	*(char*)vbuf = c;
  80351b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80351e:	89 c2                	mov    %eax,%edx
  803520:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803524:	88 10                	mov    %dl,(%rax)
	return 1;
  803526:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80352b:	c9                   	leaveq 
  80352c:	c3                   	retq   

000000000080352d <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80352d:	55                   	push   %rbp
  80352e:	48 89 e5             	mov    %rsp,%rbp
  803531:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803538:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80353f:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803546:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80354d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803554:	eb 76                	jmp    8035cc <devcons_write+0x9f>
		m = n - tot;
  803556:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80355d:	89 c2                	mov    %eax,%edx
  80355f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803562:	29 c2                	sub    %eax,%edx
  803564:	89 d0                	mov    %edx,%eax
  803566:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803569:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80356c:	83 f8 7f             	cmp    $0x7f,%eax
  80356f:	76 07                	jbe    803578 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803571:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803578:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80357b:	48 63 d0             	movslq %eax,%rdx
  80357e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803581:	48 63 c8             	movslq %eax,%rcx
  803584:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80358b:	48 01 c1             	add    %rax,%rcx
  80358e:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803595:	48 89 ce             	mov    %rcx,%rsi
  803598:	48 89 c7             	mov    %rax,%rdi
  80359b:	48 b8 09 14 80 00 00 	movabs $0x801409,%rax
  8035a2:	00 00 00 
  8035a5:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8035a7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035aa:	48 63 d0             	movslq %eax,%rdx
  8035ad:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8035b4:	48 89 d6             	mov    %rdx,%rsi
  8035b7:	48 89 c7             	mov    %rax,%rdi
  8035ba:	48 b8 cc 18 80 00 00 	movabs $0x8018cc,%rax
  8035c1:	00 00 00 
  8035c4:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8035c6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035c9:	01 45 fc             	add    %eax,-0x4(%rbp)
  8035cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035cf:	48 98                	cltq   
  8035d1:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8035d8:	0f 82 78 ff ff ff    	jb     803556 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8035de:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8035e1:	c9                   	leaveq 
  8035e2:	c3                   	retq   

00000000008035e3 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8035e3:	55                   	push   %rbp
  8035e4:	48 89 e5             	mov    %rsp,%rbp
  8035e7:	48 83 ec 08          	sub    $0x8,%rsp
  8035eb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8035ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8035f4:	c9                   	leaveq 
  8035f5:	c3                   	retq   

00000000008035f6 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8035f6:	55                   	push   %rbp
  8035f7:	48 89 e5             	mov    %rsp,%rbp
  8035fa:	48 83 ec 10          	sub    $0x10,%rsp
  8035fe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803602:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803606:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80360a:	48 be ce 3e 80 00 00 	movabs $0x803ece,%rsi
  803611:	00 00 00 
  803614:	48 89 c7             	mov    %rax,%rdi
  803617:	48 b8 e5 10 80 00 00 	movabs $0x8010e5,%rax
  80361e:	00 00 00 
  803621:	ff d0                	callq  *%rax
	return 0;
  803623:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803628:	c9                   	leaveq 
  803629:	c3                   	retq   

000000000080362a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80362a:	55                   	push   %rbp
  80362b:	48 89 e5             	mov    %rsp,%rbp
  80362e:	48 83 ec 30          	sub    $0x30,%rsp
  803632:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803636:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80363a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  80363e:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803645:	00 00 00 
  803648:	48 8b 00             	mov    (%rax),%rax
  80364b:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803651:	85 c0                	test   %eax,%eax
  803653:	75 3c                	jne    803691 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  803655:	48 b8 98 19 80 00 00 	movabs $0x801998,%rax
  80365c:	00 00 00 
  80365f:	ff d0                	callq  *%rax
  803661:	25 ff 03 00 00       	and    $0x3ff,%eax
  803666:	48 63 d0             	movslq %eax,%rdx
  803669:	48 89 d0             	mov    %rdx,%rax
  80366c:	48 c1 e0 03          	shl    $0x3,%rax
  803670:	48 01 d0             	add    %rdx,%rax
  803673:	48 c1 e0 05          	shl    $0x5,%rax
  803677:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80367e:	00 00 00 
  803681:	48 01 c2             	add    %rax,%rdx
  803684:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  80368b:	00 00 00 
  80368e:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803691:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803696:	75 0e                	jne    8036a6 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  803698:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80369f:	00 00 00 
  8036a2:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  8036a6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036aa:	48 89 c7             	mov    %rax,%rdi
  8036ad:	48 b8 3d 1c 80 00 00 	movabs $0x801c3d,%rax
  8036b4:	00 00 00 
  8036b7:	ff d0                	callq  *%rax
  8036b9:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  8036bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036c0:	79 19                	jns    8036db <ipc_recv+0xb1>
		*from_env_store = 0;
  8036c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036c6:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  8036cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036d0:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  8036d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036d9:	eb 53                	jmp    80372e <ipc_recv+0x104>
	}
	if(from_env_store)
  8036db:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8036e0:	74 19                	je     8036fb <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  8036e2:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8036e9:	00 00 00 
  8036ec:	48 8b 00             	mov    (%rax),%rax
  8036ef:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8036f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036f9:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  8036fb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803700:	74 19                	je     80371b <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  803702:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803709:	00 00 00 
  80370c:	48 8b 00             	mov    (%rax),%rax
  80370f:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803715:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803719:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  80371b:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803722:	00 00 00 
  803725:	48 8b 00             	mov    (%rax),%rax
  803728:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  80372e:	c9                   	leaveq 
  80372f:	c3                   	retq   

0000000000803730 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803730:	55                   	push   %rbp
  803731:	48 89 e5             	mov    %rsp,%rbp
  803734:	48 83 ec 30          	sub    $0x30,%rsp
  803738:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80373b:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80373e:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803742:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803745:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80374a:	75 0e                	jne    80375a <ipc_send+0x2a>
		pg = (void*)UTOP;
  80374c:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803753:	00 00 00 
  803756:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  80375a:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80375d:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803760:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803764:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803767:	89 c7                	mov    %eax,%edi
  803769:	48 b8 e8 1b 80 00 00 	movabs $0x801be8,%rax
  803770:	00 00 00 
  803773:	ff d0                	callq  *%rax
  803775:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  803778:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80377c:	75 0c                	jne    80378a <ipc_send+0x5a>
			sys_yield();
  80377e:	48 b8 d6 19 80 00 00 	movabs $0x8019d6,%rax
  803785:	00 00 00 
  803788:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  80378a:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80378e:	74 ca                	je     80375a <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  803790:	c9                   	leaveq 
  803791:	c3                   	retq   

0000000000803792 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803792:	55                   	push   %rbp
  803793:	48 89 e5             	mov    %rsp,%rbp
  803796:	48 83 ec 14          	sub    $0x14,%rsp
  80379a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  80379d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8037a4:	eb 5e                	jmp    803804 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8037a6:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8037ad:	00 00 00 
  8037b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037b3:	48 63 d0             	movslq %eax,%rdx
  8037b6:	48 89 d0             	mov    %rdx,%rax
  8037b9:	48 c1 e0 03          	shl    $0x3,%rax
  8037bd:	48 01 d0             	add    %rdx,%rax
  8037c0:	48 c1 e0 05          	shl    $0x5,%rax
  8037c4:	48 01 c8             	add    %rcx,%rax
  8037c7:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8037cd:	8b 00                	mov    (%rax),%eax
  8037cf:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8037d2:	75 2c                	jne    803800 <ipc_find_env+0x6e>
			return envs[i].env_id;
  8037d4:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8037db:	00 00 00 
  8037de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037e1:	48 63 d0             	movslq %eax,%rdx
  8037e4:	48 89 d0             	mov    %rdx,%rax
  8037e7:	48 c1 e0 03          	shl    $0x3,%rax
  8037eb:	48 01 d0             	add    %rdx,%rax
  8037ee:	48 c1 e0 05          	shl    $0x5,%rax
  8037f2:	48 01 c8             	add    %rcx,%rax
  8037f5:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8037fb:	8b 40 08             	mov    0x8(%rax),%eax
  8037fe:	eb 12                	jmp    803812 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803800:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803804:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80380b:	7e 99                	jle    8037a6 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  80380d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803812:	c9                   	leaveq 
  803813:	c3                   	retq   

0000000000803814 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803814:	55                   	push   %rbp
  803815:	48 89 e5             	mov    %rsp,%rbp
  803818:	48 83 ec 18          	sub    $0x18,%rsp
  80381c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803820:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803824:	48 c1 e8 15          	shr    $0x15,%rax
  803828:	48 89 c2             	mov    %rax,%rdx
  80382b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803832:	01 00 00 
  803835:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803839:	83 e0 01             	and    $0x1,%eax
  80383c:	48 85 c0             	test   %rax,%rax
  80383f:	75 07                	jne    803848 <pageref+0x34>
		return 0;
  803841:	b8 00 00 00 00       	mov    $0x0,%eax
  803846:	eb 53                	jmp    80389b <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803848:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80384c:	48 c1 e8 0c          	shr    $0xc,%rax
  803850:	48 89 c2             	mov    %rax,%rdx
  803853:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80385a:	01 00 00 
  80385d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803861:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803865:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803869:	83 e0 01             	and    $0x1,%eax
  80386c:	48 85 c0             	test   %rax,%rax
  80386f:	75 07                	jne    803878 <pageref+0x64>
		return 0;
  803871:	b8 00 00 00 00       	mov    $0x0,%eax
  803876:	eb 23                	jmp    80389b <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803878:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80387c:	48 c1 e8 0c          	shr    $0xc,%rax
  803880:	48 89 c2             	mov    %rax,%rdx
  803883:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80388a:	00 00 00 
  80388d:	48 c1 e2 04          	shl    $0x4,%rdx
  803891:	48 01 d0             	add    %rdx,%rax
  803894:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803898:	0f b7 c0             	movzwl %ax,%eax
}
  80389b:	c9                   	leaveq 
  80389c:	c3                   	retq   
