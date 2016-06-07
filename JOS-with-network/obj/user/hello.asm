
obj/user/hello.debug:     file format elf64-x86-64


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
  80003c:	e8 5e 00 00 00       	callq  80009f <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
// hello, world
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	cprintf("hello, world\n");
  800052:	48 bf a0 3e 80 00 00 	movabs $0x803ea0,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 72 02 80 00 00 	movabs $0x800272,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	cprintf("i am environment %08x\n", thisenv->env_id);
  80006d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800074:	00 00 00 
  800077:	48 8b 00             	mov    (%rax),%rax
  80007a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800080:	89 c6                	mov    %eax,%esi
  800082:	48 bf ae 3e 80 00 00 	movabs $0x803eae,%rdi
  800089:	00 00 00 
  80008c:	b8 00 00 00 00       	mov    $0x0,%eax
  800091:	48 ba 72 02 80 00 00 	movabs $0x800272,%rdx
  800098:	00 00 00 
  80009b:	ff d2                	callq  *%rdx
}
  80009d:	c9                   	leaveq 
  80009e:	c3                   	retq   

000000000080009f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80009f:	55                   	push   %rbp
  8000a0:	48 89 e5             	mov    %rsp,%rbp
  8000a3:	48 83 ec 10          	sub    $0x10,%rsp
  8000a7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8000aa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000ae:	48 b8 da 16 80 00 00 	movabs $0x8016da,%rax
  8000b5:	00 00 00 
  8000b8:	ff d0                	callq  *%rax
  8000ba:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000bf:	48 63 d0             	movslq %eax,%rdx
  8000c2:	48 89 d0             	mov    %rdx,%rax
  8000c5:	48 c1 e0 03          	shl    $0x3,%rax
  8000c9:	48 01 d0             	add    %rdx,%rax
  8000cc:	48 c1 e0 05          	shl    $0x5,%rax
  8000d0:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8000d7:	00 00 00 
  8000da:	48 01 c2             	add    %rax,%rdx
  8000dd:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8000e4:	00 00 00 
  8000e7:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000ee:	7e 14                	jle    800104 <libmain+0x65>
		binaryname = argv[0];
  8000f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000f4:	48 8b 10             	mov    (%rax),%rdx
  8000f7:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8000fe:	00 00 00 
  800101:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800104:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800108:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80010b:	48 89 d6             	mov    %rdx,%rsi
  80010e:	89 c7                	mov    %eax,%edi
  800110:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800117:	00 00 00 
  80011a:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  80011c:	48 b8 2a 01 80 00 00 	movabs $0x80012a,%rax
  800123:	00 00 00 
  800126:	ff d0                	callq  *%rax
}
  800128:	c9                   	leaveq 
  800129:	c3                   	retq   

000000000080012a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80012a:	55                   	push   %rbp
  80012b:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80012e:	48 b8 ce 1d 80 00 00 	movabs $0x801dce,%rax
  800135:	00 00 00 
  800138:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80013a:	bf 00 00 00 00       	mov    $0x0,%edi
  80013f:	48 b8 96 16 80 00 00 	movabs $0x801696,%rax
  800146:	00 00 00 
  800149:	ff d0                	callq  *%rax

}
  80014b:	5d                   	pop    %rbp
  80014c:	c3                   	retq   

000000000080014d <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80014d:	55                   	push   %rbp
  80014e:	48 89 e5             	mov    %rsp,%rbp
  800151:	48 83 ec 10          	sub    $0x10,%rsp
  800155:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800158:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80015c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800160:	8b 00                	mov    (%rax),%eax
  800162:	8d 48 01             	lea    0x1(%rax),%ecx
  800165:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800169:	89 0a                	mov    %ecx,(%rdx)
  80016b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80016e:	89 d1                	mov    %edx,%ecx
  800170:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800174:	48 98                	cltq   
  800176:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80017a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80017e:	8b 00                	mov    (%rax),%eax
  800180:	3d ff 00 00 00       	cmp    $0xff,%eax
  800185:	75 2c                	jne    8001b3 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800187:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80018b:	8b 00                	mov    (%rax),%eax
  80018d:	48 98                	cltq   
  80018f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800193:	48 83 c2 08          	add    $0x8,%rdx
  800197:	48 89 c6             	mov    %rax,%rsi
  80019a:	48 89 d7             	mov    %rdx,%rdi
  80019d:	48 b8 0e 16 80 00 00 	movabs $0x80160e,%rax
  8001a4:	00 00 00 
  8001a7:	ff d0                	callq  *%rax
        b->idx = 0;
  8001a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001ad:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8001b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001b7:	8b 40 04             	mov    0x4(%rax),%eax
  8001ba:	8d 50 01             	lea    0x1(%rax),%edx
  8001bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001c1:	89 50 04             	mov    %edx,0x4(%rax)
}
  8001c4:	c9                   	leaveq 
  8001c5:	c3                   	retq   

00000000008001c6 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8001c6:	55                   	push   %rbp
  8001c7:	48 89 e5             	mov    %rsp,%rbp
  8001ca:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8001d1:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8001d8:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8001df:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8001e6:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8001ed:	48 8b 0a             	mov    (%rdx),%rcx
  8001f0:	48 89 08             	mov    %rcx,(%rax)
  8001f3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8001f7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8001fb:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8001ff:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800203:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80020a:	00 00 00 
    b.cnt = 0;
  80020d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800214:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800217:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80021e:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800225:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80022c:	48 89 c6             	mov    %rax,%rsi
  80022f:	48 bf 4d 01 80 00 00 	movabs $0x80014d,%rdi
  800236:	00 00 00 
  800239:	48 b8 25 06 80 00 00 	movabs $0x800625,%rax
  800240:	00 00 00 
  800243:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800245:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80024b:	48 98                	cltq   
  80024d:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800254:	48 83 c2 08          	add    $0x8,%rdx
  800258:	48 89 c6             	mov    %rax,%rsi
  80025b:	48 89 d7             	mov    %rdx,%rdi
  80025e:	48 b8 0e 16 80 00 00 	movabs $0x80160e,%rax
  800265:	00 00 00 
  800268:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80026a:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800270:	c9                   	leaveq 
  800271:	c3                   	retq   

0000000000800272 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800272:	55                   	push   %rbp
  800273:	48 89 e5             	mov    %rsp,%rbp
  800276:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80027d:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800284:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80028b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800292:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800299:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8002a0:	84 c0                	test   %al,%al
  8002a2:	74 20                	je     8002c4 <cprintf+0x52>
  8002a4:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8002a8:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8002ac:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8002b0:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8002b4:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8002b8:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8002bc:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8002c0:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8002c4:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8002cb:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8002d2:	00 00 00 
  8002d5:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8002dc:	00 00 00 
  8002df:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002e3:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8002ea:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8002f1:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8002f8:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8002ff:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800306:	48 8b 0a             	mov    (%rdx),%rcx
  800309:	48 89 08             	mov    %rcx,(%rax)
  80030c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800310:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800314:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800318:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80031c:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800323:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80032a:	48 89 d6             	mov    %rdx,%rsi
  80032d:	48 89 c7             	mov    %rax,%rdi
  800330:	48 b8 c6 01 80 00 00 	movabs $0x8001c6,%rax
  800337:	00 00 00 
  80033a:	ff d0                	callq  *%rax
  80033c:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800342:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800348:	c9                   	leaveq 
  800349:	c3                   	retq   

000000000080034a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80034a:	55                   	push   %rbp
  80034b:	48 89 e5             	mov    %rsp,%rbp
  80034e:	53                   	push   %rbx
  80034f:	48 83 ec 38          	sub    $0x38,%rsp
  800353:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800357:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80035b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80035f:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800362:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800366:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80036a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80036d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800371:	77 3b                	ja     8003ae <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800373:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800376:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80037a:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80037d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800381:	ba 00 00 00 00       	mov    $0x0,%edx
  800386:	48 f7 f3             	div    %rbx
  800389:	48 89 c2             	mov    %rax,%rdx
  80038c:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80038f:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800392:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800396:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80039a:	41 89 f9             	mov    %edi,%r9d
  80039d:	48 89 c7             	mov    %rax,%rdi
  8003a0:	48 b8 4a 03 80 00 00 	movabs $0x80034a,%rax
  8003a7:	00 00 00 
  8003aa:	ff d0                	callq  *%rax
  8003ac:	eb 1e                	jmp    8003cc <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003ae:	eb 12                	jmp    8003c2 <printnum+0x78>
			putch(padc, putdat);
  8003b0:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8003b4:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8003b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003bb:	48 89 ce             	mov    %rcx,%rsi
  8003be:	89 d7                	mov    %edx,%edi
  8003c0:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003c2:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8003c6:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8003ca:	7f e4                	jg     8003b0 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003cc:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8003cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8003d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d8:	48 f7 f1             	div    %rcx
  8003db:	48 89 d0             	mov    %rdx,%rax
  8003de:	48 ba d0 40 80 00 00 	movabs $0x8040d0,%rdx
  8003e5:	00 00 00 
  8003e8:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8003ec:	0f be d0             	movsbl %al,%edx
  8003ef:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8003f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003f7:	48 89 ce             	mov    %rcx,%rsi
  8003fa:	89 d7                	mov    %edx,%edi
  8003fc:	ff d0                	callq  *%rax
}
  8003fe:	48 83 c4 38          	add    $0x38,%rsp
  800402:	5b                   	pop    %rbx
  800403:	5d                   	pop    %rbp
  800404:	c3                   	retq   

0000000000800405 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800405:	55                   	push   %rbp
  800406:	48 89 e5             	mov    %rsp,%rbp
  800409:	48 83 ec 1c          	sub    $0x1c,%rsp
  80040d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800411:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800414:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800418:	7e 52                	jle    80046c <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80041a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80041e:	8b 00                	mov    (%rax),%eax
  800420:	83 f8 30             	cmp    $0x30,%eax
  800423:	73 24                	jae    800449 <getuint+0x44>
  800425:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800429:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80042d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800431:	8b 00                	mov    (%rax),%eax
  800433:	89 c0                	mov    %eax,%eax
  800435:	48 01 d0             	add    %rdx,%rax
  800438:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80043c:	8b 12                	mov    (%rdx),%edx
  80043e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800441:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800445:	89 0a                	mov    %ecx,(%rdx)
  800447:	eb 17                	jmp    800460 <getuint+0x5b>
  800449:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80044d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800451:	48 89 d0             	mov    %rdx,%rax
  800454:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800458:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80045c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800460:	48 8b 00             	mov    (%rax),%rax
  800463:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800467:	e9 a3 00 00 00       	jmpq   80050f <getuint+0x10a>
	else if (lflag)
  80046c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800470:	74 4f                	je     8004c1 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800472:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800476:	8b 00                	mov    (%rax),%eax
  800478:	83 f8 30             	cmp    $0x30,%eax
  80047b:	73 24                	jae    8004a1 <getuint+0x9c>
  80047d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800481:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800485:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800489:	8b 00                	mov    (%rax),%eax
  80048b:	89 c0                	mov    %eax,%eax
  80048d:	48 01 d0             	add    %rdx,%rax
  800490:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800494:	8b 12                	mov    (%rdx),%edx
  800496:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800499:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80049d:	89 0a                	mov    %ecx,(%rdx)
  80049f:	eb 17                	jmp    8004b8 <getuint+0xb3>
  8004a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004a5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004a9:	48 89 d0             	mov    %rdx,%rax
  8004ac:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004b0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004b4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004b8:	48 8b 00             	mov    (%rax),%rax
  8004bb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004bf:	eb 4e                	jmp    80050f <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8004c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004c5:	8b 00                	mov    (%rax),%eax
  8004c7:	83 f8 30             	cmp    $0x30,%eax
  8004ca:	73 24                	jae    8004f0 <getuint+0xeb>
  8004cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004d0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004d8:	8b 00                	mov    (%rax),%eax
  8004da:	89 c0                	mov    %eax,%eax
  8004dc:	48 01 d0             	add    %rdx,%rax
  8004df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004e3:	8b 12                	mov    (%rdx),%edx
  8004e5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004e8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004ec:	89 0a                	mov    %ecx,(%rdx)
  8004ee:	eb 17                	jmp    800507 <getuint+0x102>
  8004f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004f8:	48 89 d0             	mov    %rdx,%rax
  8004fb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800503:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800507:	8b 00                	mov    (%rax),%eax
  800509:	89 c0                	mov    %eax,%eax
  80050b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80050f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800513:	c9                   	leaveq 
  800514:	c3                   	retq   

0000000000800515 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800515:	55                   	push   %rbp
  800516:	48 89 e5             	mov    %rsp,%rbp
  800519:	48 83 ec 1c          	sub    $0x1c,%rsp
  80051d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800521:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800524:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800528:	7e 52                	jle    80057c <getint+0x67>
		x=va_arg(*ap, long long);
  80052a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80052e:	8b 00                	mov    (%rax),%eax
  800530:	83 f8 30             	cmp    $0x30,%eax
  800533:	73 24                	jae    800559 <getint+0x44>
  800535:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800539:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80053d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800541:	8b 00                	mov    (%rax),%eax
  800543:	89 c0                	mov    %eax,%eax
  800545:	48 01 d0             	add    %rdx,%rax
  800548:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80054c:	8b 12                	mov    (%rdx),%edx
  80054e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800551:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800555:	89 0a                	mov    %ecx,(%rdx)
  800557:	eb 17                	jmp    800570 <getint+0x5b>
  800559:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80055d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800561:	48 89 d0             	mov    %rdx,%rax
  800564:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800568:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80056c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800570:	48 8b 00             	mov    (%rax),%rax
  800573:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800577:	e9 a3 00 00 00       	jmpq   80061f <getint+0x10a>
	else if (lflag)
  80057c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800580:	74 4f                	je     8005d1 <getint+0xbc>
		x=va_arg(*ap, long);
  800582:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800586:	8b 00                	mov    (%rax),%eax
  800588:	83 f8 30             	cmp    $0x30,%eax
  80058b:	73 24                	jae    8005b1 <getint+0x9c>
  80058d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800591:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800595:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800599:	8b 00                	mov    (%rax),%eax
  80059b:	89 c0                	mov    %eax,%eax
  80059d:	48 01 d0             	add    %rdx,%rax
  8005a0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005a4:	8b 12                	mov    (%rdx),%edx
  8005a6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005a9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005ad:	89 0a                	mov    %ecx,(%rdx)
  8005af:	eb 17                	jmp    8005c8 <getint+0xb3>
  8005b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005b9:	48 89 d0             	mov    %rdx,%rax
  8005bc:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005c0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005c4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005c8:	48 8b 00             	mov    (%rax),%rax
  8005cb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005cf:	eb 4e                	jmp    80061f <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8005d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d5:	8b 00                	mov    (%rax),%eax
  8005d7:	83 f8 30             	cmp    $0x30,%eax
  8005da:	73 24                	jae    800600 <getint+0xeb>
  8005dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e8:	8b 00                	mov    (%rax),%eax
  8005ea:	89 c0                	mov    %eax,%eax
  8005ec:	48 01 d0             	add    %rdx,%rax
  8005ef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005f3:	8b 12                	mov    (%rdx),%edx
  8005f5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005f8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005fc:	89 0a                	mov    %ecx,(%rdx)
  8005fe:	eb 17                	jmp    800617 <getint+0x102>
  800600:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800604:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800608:	48 89 d0             	mov    %rdx,%rax
  80060b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80060f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800613:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800617:	8b 00                	mov    (%rax),%eax
  800619:	48 98                	cltq   
  80061b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80061f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800623:	c9                   	leaveq 
  800624:	c3                   	retq   

0000000000800625 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800625:	55                   	push   %rbp
  800626:	48 89 e5             	mov    %rsp,%rbp
  800629:	41 54                	push   %r12
  80062b:	53                   	push   %rbx
  80062c:	48 83 ec 60          	sub    $0x60,%rsp
  800630:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800634:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800638:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80063c:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800640:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800644:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800648:	48 8b 0a             	mov    (%rdx),%rcx
  80064b:	48 89 08             	mov    %rcx,(%rax)
  80064e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800652:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800656:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80065a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80065e:	eb 17                	jmp    800677 <vprintfmt+0x52>
			if (ch == '\0')
  800660:	85 db                	test   %ebx,%ebx
  800662:	0f 84 cc 04 00 00    	je     800b34 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800668:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80066c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800670:	48 89 d6             	mov    %rdx,%rsi
  800673:	89 df                	mov    %ebx,%edi
  800675:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800677:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80067b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80067f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800683:	0f b6 00             	movzbl (%rax),%eax
  800686:	0f b6 d8             	movzbl %al,%ebx
  800689:	83 fb 25             	cmp    $0x25,%ebx
  80068c:	75 d2                	jne    800660 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80068e:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800692:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800699:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8006a0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8006a7:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006ae:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006b2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8006b6:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006ba:	0f b6 00             	movzbl (%rax),%eax
  8006bd:	0f b6 d8             	movzbl %al,%ebx
  8006c0:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8006c3:	83 f8 55             	cmp    $0x55,%eax
  8006c6:	0f 87 34 04 00 00    	ja     800b00 <vprintfmt+0x4db>
  8006cc:	89 c0                	mov    %eax,%eax
  8006ce:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8006d5:	00 
  8006d6:	48 b8 f8 40 80 00 00 	movabs $0x8040f8,%rax
  8006dd:	00 00 00 
  8006e0:	48 01 d0             	add    %rdx,%rax
  8006e3:	48 8b 00             	mov    (%rax),%rax
  8006e6:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8006e8:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8006ec:	eb c0                	jmp    8006ae <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006ee:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8006f2:	eb ba                	jmp    8006ae <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006f4:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8006fb:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8006fe:	89 d0                	mov    %edx,%eax
  800700:	c1 e0 02             	shl    $0x2,%eax
  800703:	01 d0                	add    %edx,%eax
  800705:	01 c0                	add    %eax,%eax
  800707:	01 d8                	add    %ebx,%eax
  800709:	83 e8 30             	sub    $0x30,%eax
  80070c:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80070f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800713:	0f b6 00             	movzbl (%rax),%eax
  800716:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800719:	83 fb 2f             	cmp    $0x2f,%ebx
  80071c:	7e 0c                	jle    80072a <vprintfmt+0x105>
  80071e:	83 fb 39             	cmp    $0x39,%ebx
  800721:	7f 07                	jg     80072a <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800723:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800728:	eb d1                	jmp    8006fb <vprintfmt+0xd6>
			goto process_precision;
  80072a:	eb 58                	jmp    800784 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  80072c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80072f:	83 f8 30             	cmp    $0x30,%eax
  800732:	73 17                	jae    80074b <vprintfmt+0x126>
  800734:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800738:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80073b:	89 c0                	mov    %eax,%eax
  80073d:	48 01 d0             	add    %rdx,%rax
  800740:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800743:	83 c2 08             	add    $0x8,%edx
  800746:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800749:	eb 0f                	jmp    80075a <vprintfmt+0x135>
  80074b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80074f:	48 89 d0             	mov    %rdx,%rax
  800752:	48 83 c2 08          	add    $0x8,%rdx
  800756:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80075a:	8b 00                	mov    (%rax),%eax
  80075c:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80075f:	eb 23                	jmp    800784 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800761:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800765:	79 0c                	jns    800773 <vprintfmt+0x14e>
				width = 0;
  800767:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80076e:	e9 3b ff ff ff       	jmpq   8006ae <vprintfmt+0x89>
  800773:	e9 36 ff ff ff       	jmpq   8006ae <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800778:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80077f:	e9 2a ff ff ff       	jmpq   8006ae <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800784:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800788:	79 12                	jns    80079c <vprintfmt+0x177>
				width = precision, precision = -1;
  80078a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80078d:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800790:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800797:	e9 12 ff ff ff       	jmpq   8006ae <vprintfmt+0x89>
  80079c:	e9 0d ff ff ff       	jmpq   8006ae <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007a1:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8007a5:	e9 04 ff ff ff       	jmpq   8006ae <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8007aa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007ad:	83 f8 30             	cmp    $0x30,%eax
  8007b0:	73 17                	jae    8007c9 <vprintfmt+0x1a4>
  8007b2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007b6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007b9:	89 c0                	mov    %eax,%eax
  8007bb:	48 01 d0             	add    %rdx,%rax
  8007be:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007c1:	83 c2 08             	add    $0x8,%edx
  8007c4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007c7:	eb 0f                	jmp    8007d8 <vprintfmt+0x1b3>
  8007c9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007cd:	48 89 d0             	mov    %rdx,%rax
  8007d0:	48 83 c2 08          	add    $0x8,%rdx
  8007d4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007d8:	8b 10                	mov    (%rax),%edx
  8007da:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8007de:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007e2:	48 89 ce             	mov    %rcx,%rsi
  8007e5:	89 d7                	mov    %edx,%edi
  8007e7:	ff d0                	callq  *%rax
			break;
  8007e9:	e9 40 03 00 00       	jmpq   800b2e <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8007ee:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007f1:	83 f8 30             	cmp    $0x30,%eax
  8007f4:	73 17                	jae    80080d <vprintfmt+0x1e8>
  8007f6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007fa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007fd:	89 c0                	mov    %eax,%eax
  8007ff:	48 01 d0             	add    %rdx,%rax
  800802:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800805:	83 c2 08             	add    $0x8,%edx
  800808:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80080b:	eb 0f                	jmp    80081c <vprintfmt+0x1f7>
  80080d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800811:	48 89 d0             	mov    %rdx,%rax
  800814:	48 83 c2 08          	add    $0x8,%rdx
  800818:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80081c:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  80081e:	85 db                	test   %ebx,%ebx
  800820:	79 02                	jns    800824 <vprintfmt+0x1ff>
				err = -err;
  800822:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800824:	83 fb 15             	cmp    $0x15,%ebx
  800827:	7f 16                	jg     80083f <vprintfmt+0x21a>
  800829:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  800830:	00 00 00 
  800833:	48 63 d3             	movslq %ebx,%rdx
  800836:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  80083a:	4d 85 e4             	test   %r12,%r12
  80083d:	75 2e                	jne    80086d <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  80083f:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800843:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800847:	89 d9                	mov    %ebx,%ecx
  800849:	48 ba e1 40 80 00 00 	movabs $0x8040e1,%rdx
  800850:	00 00 00 
  800853:	48 89 c7             	mov    %rax,%rdi
  800856:	b8 00 00 00 00       	mov    $0x0,%eax
  80085b:	49 b8 3d 0b 80 00 00 	movabs $0x800b3d,%r8
  800862:	00 00 00 
  800865:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800868:	e9 c1 02 00 00       	jmpq   800b2e <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80086d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800871:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800875:	4c 89 e1             	mov    %r12,%rcx
  800878:	48 ba ea 40 80 00 00 	movabs $0x8040ea,%rdx
  80087f:	00 00 00 
  800882:	48 89 c7             	mov    %rax,%rdi
  800885:	b8 00 00 00 00       	mov    $0x0,%eax
  80088a:	49 b8 3d 0b 80 00 00 	movabs $0x800b3d,%r8
  800891:	00 00 00 
  800894:	41 ff d0             	callq  *%r8
			break;
  800897:	e9 92 02 00 00       	jmpq   800b2e <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80089c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80089f:	83 f8 30             	cmp    $0x30,%eax
  8008a2:	73 17                	jae    8008bb <vprintfmt+0x296>
  8008a4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008a8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008ab:	89 c0                	mov    %eax,%eax
  8008ad:	48 01 d0             	add    %rdx,%rax
  8008b0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008b3:	83 c2 08             	add    $0x8,%edx
  8008b6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008b9:	eb 0f                	jmp    8008ca <vprintfmt+0x2a5>
  8008bb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008bf:	48 89 d0             	mov    %rdx,%rax
  8008c2:	48 83 c2 08          	add    $0x8,%rdx
  8008c6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008ca:	4c 8b 20             	mov    (%rax),%r12
  8008cd:	4d 85 e4             	test   %r12,%r12
  8008d0:	75 0a                	jne    8008dc <vprintfmt+0x2b7>
				p = "(null)";
  8008d2:	49 bc ed 40 80 00 00 	movabs $0x8040ed,%r12
  8008d9:	00 00 00 
			if (width > 0 && padc != '-')
  8008dc:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008e0:	7e 3f                	jle    800921 <vprintfmt+0x2fc>
  8008e2:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8008e6:	74 39                	je     800921 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008e8:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8008eb:	48 98                	cltq   
  8008ed:	48 89 c6             	mov    %rax,%rsi
  8008f0:	4c 89 e7             	mov    %r12,%rdi
  8008f3:	48 b8 e9 0d 80 00 00 	movabs $0x800de9,%rax
  8008fa:	00 00 00 
  8008fd:	ff d0                	callq  *%rax
  8008ff:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800902:	eb 17                	jmp    80091b <vprintfmt+0x2f6>
					putch(padc, putdat);
  800904:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800908:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80090c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800910:	48 89 ce             	mov    %rcx,%rsi
  800913:	89 d7                	mov    %edx,%edi
  800915:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800917:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80091b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80091f:	7f e3                	jg     800904 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800921:	eb 37                	jmp    80095a <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800923:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800927:	74 1e                	je     800947 <vprintfmt+0x322>
  800929:	83 fb 1f             	cmp    $0x1f,%ebx
  80092c:	7e 05                	jle    800933 <vprintfmt+0x30e>
  80092e:	83 fb 7e             	cmp    $0x7e,%ebx
  800931:	7e 14                	jle    800947 <vprintfmt+0x322>
					putch('?', putdat);
  800933:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800937:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80093b:	48 89 d6             	mov    %rdx,%rsi
  80093e:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800943:	ff d0                	callq  *%rax
  800945:	eb 0f                	jmp    800956 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800947:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80094b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80094f:	48 89 d6             	mov    %rdx,%rsi
  800952:	89 df                	mov    %ebx,%edi
  800954:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800956:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80095a:	4c 89 e0             	mov    %r12,%rax
  80095d:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800961:	0f b6 00             	movzbl (%rax),%eax
  800964:	0f be d8             	movsbl %al,%ebx
  800967:	85 db                	test   %ebx,%ebx
  800969:	74 10                	je     80097b <vprintfmt+0x356>
  80096b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80096f:	78 b2                	js     800923 <vprintfmt+0x2fe>
  800971:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800975:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800979:	79 a8                	jns    800923 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80097b:	eb 16                	jmp    800993 <vprintfmt+0x36e>
				putch(' ', putdat);
  80097d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800981:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800985:	48 89 d6             	mov    %rdx,%rsi
  800988:	bf 20 00 00 00       	mov    $0x20,%edi
  80098d:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80098f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800993:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800997:	7f e4                	jg     80097d <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800999:	e9 90 01 00 00       	jmpq   800b2e <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  80099e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009a2:	be 03 00 00 00       	mov    $0x3,%esi
  8009a7:	48 89 c7             	mov    %rax,%rdi
  8009aa:	48 b8 15 05 80 00 00 	movabs $0x800515,%rax
  8009b1:	00 00 00 
  8009b4:	ff d0                	callq  *%rax
  8009b6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8009ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009be:	48 85 c0             	test   %rax,%rax
  8009c1:	79 1d                	jns    8009e0 <vprintfmt+0x3bb>
				putch('-', putdat);
  8009c3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009c7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009cb:	48 89 d6             	mov    %rdx,%rsi
  8009ce:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8009d3:	ff d0                	callq  *%rax
				num = -(long long) num;
  8009d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d9:	48 f7 d8             	neg    %rax
  8009dc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8009e0:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8009e7:	e9 d5 00 00 00       	jmpq   800ac1 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8009ec:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009f0:	be 03 00 00 00       	mov    $0x3,%esi
  8009f5:	48 89 c7             	mov    %rax,%rdi
  8009f8:	48 b8 05 04 80 00 00 	movabs $0x800405,%rax
  8009ff:	00 00 00 
  800a02:	ff d0                	callq  *%rax
  800a04:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800a08:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a0f:	e9 ad 00 00 00       	jmpq   800ac1 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800a14:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800a17:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a1b:	89 d6                	mov    %edx,%esi
  800a1d:	48 89 c7             	mov    %rax,%rdi
  800a20:	48 b8 15 05 80 00 00 	movabs $0x800515,%rax
  800a27:	00 00 00 
  800a2a:	ff d0                	callq  *%rax
  800a2c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800a30:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800a37:	e9 85 00 00 00       	jmpq   800ac1 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800a3c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a40:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a44:	48 89 d6             	mov    %rdx,%rsi
  800a47:	bf 30 00 00 00       	mov    $0x30,%edi
  800a4c:	ff d0                	callq  *%rax
			putch('x', putdat);
  800a4e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a52:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a56:	48 89 d6             	mov    %rdx,%rsi
  800a59:	bf 78 00 00 00       	mov    $0x78,%edi
  800a5e:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800a60:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a63:	83 f8 30             	cmp    $0x30,%eax
  800a66:	73 17                	jae    800a7f <vprintfmt+0x45a>
  800a68:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a6c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a6f:	89 c0                	mov    %eax,%eax
  800a71:	48 01 d0             	add    %rdx,%rax
  800a74:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a77:	83 c2 08             	add    $0x8,%edx
  800a7a:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a7d:	eb 0f                	jmp    800a8e <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800a7f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a83:	48 89 d0             	mov    %rdx,%rax
  800a86:	48 83 c2 08          	add    $0x8,%rdx
  800a8a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a8e:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a91:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800a95:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800a9c:	eb 23                	jmp    800ac1 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800a9e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800aa2:	be 03 00 00 00       	mov    $0x3,%esi
  800aa7:	48 89 c7             	mov    %rax,%rdi
  800aaa:	48 b8 05 04 80 00 00 	movabs $0x800405,%rax
  800ab1:	00 00 00 
  800ab4:	ff d0                	callq  *%rax
  800ab6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800aba:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ac1:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800ac6:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800ac9:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800acc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ad0:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ad4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ad8:	45 89 c1             	mov    %r8d,%r9d
  800adb:	41 89 f8             	mov    %edi,%r8d
  800ade:	48 89 c7             	mov    %rax,%rdi
  800ae1:	48 b8 4a 03 80 00 00 	movabs $0x80034a,%rax
  800ae8:	00 00 00 
  800aeb:	ff d0                	callq  *%rax
			break;
  800aed:	eb 3f                	jmp    800b2e <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800aef:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800af3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800af7:	48 89 d6             	mov    %rdx,%rsi
  800afa:	89 df                	mov    %ebx,%edi
  800afc:	ff d0                	callq  *%rax
			break;
  800afe:	eb 2e                	jmp    800b2e <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b00:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b04:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b08:	48 89 d6             	mov    %rdx,%rsi
  800b0b:	bf 25 00 00 00       	mov    $0x25,%edi
  800b10:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b12:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b17:	eb 05                	jmp    800b1e <vprintfmt+0x4f9>
  800b19:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b1e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b22:	48 83 e8 01          	sub    $0x1,%rax
  800b26:	0f b6 00             	movzbl (%rax),%eax
  800b29:	3c 25                	cmp    $0x25,%al
  800b2b:	75 ec                	jne    800b19 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800b2d:	90                   	nop
		}
	}
  800b2e:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b2f:	e9 43 fb ff ff       	jmpq   800677 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800b34:	48 83 c4 60          	add    $0x60,%rsp
  800b38:	5b                   	pop    %rbx
  800b39:	41 5c                	pop    %r12
  800b3b:	5d                   	pop    %rbp
  800b3c:	c3                   	retq   

0000000000800b3d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b3d:	55                   	push   %rbp
  800b3e:	48 89 e5             	mov    %rsp,%rbp
  800b41:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800b48:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800b4f:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800b56:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b5d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800b64:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800b6b:	84 c0                	test   %al,%al
  800b6d:	74 20                	je     800b8f <printfmt+0x52>
  800b6f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800b73:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800b77:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800b7b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800b7f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800b83:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800b87:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800b8b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800b8f:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800b96:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800b9d:	00 00 00 
  800ba0:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800ba7:	00 00 00 
  800baa:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800bae:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800bb5:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800bbc:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800bc3:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800bca:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800bd1:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800bd8:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800bdf:	48 89 c7             	mov    %rax,%rdi
  800be2:	48 b8 25 06 80 00 00 	movabs $0x800625,%rax
  800be9:	00 00 00 
  800bec:	ff d0                	callq  *%rax
	va_end(ap);
}
  800bee:	c9                   	leaveq 
  800bef:	c3                   	retq   

0000000000800bf0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bf0:	55                   	push   %rbp
  800bf1:	48 89 e5             	mov    %rsp,%rbp
  800bf4:	48 83 ec 10          	sub    $0x10,%rsp
  800bf8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800bfb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800bff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c03:	8b 40 10             	mov    0x10(%rax),%eax
  800c06:	8d 50 01             	lea    0x1(%rax),%edx
  800c09:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c0d:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800c10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c14:	48 8b 10             	mov    (%rax),%rdx
  800c17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c1b:	48 8b 40 08          	mov    0x8(%rax),%rax
  800c1f:	48 39 c2             	cmp    %rax,%rdx
  800c22:	73 17                	jae    800c3b <sprintputch+0x4b>
		*b->buf++ = ch;
  800c24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c28:	48 8b 00             	mov    (%rax),%rax
  800c2b:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800c2f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c33:	48 89 0a             	mov    %rcx,(%rdx)
  800c36:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c39:	88 10                	mov    %dl,(%rax)
}
  800c3b:	c9                   	leaveq 
  800c3c:	c3                   	retq   

0000000000800c3d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c3d:	55                   	push   %rbp
  800c3e:	48 89 e5             	mov    %rsp,%rbp
  800c41:	48 83 ec 50          	sub    $0x50,%rsp
  800c45:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800c49:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800c4c:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800c50:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800c54:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800c58:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800c5c:	48 8b 0a             	mov    (%rdx),%rcx
  800c5f:	48 89 08             	mov    %rcx,(%rax)
  800c62:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c66:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800c6a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800c6e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c72:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c76:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800c7a:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800c7d:	48 98                	cltq   
  800c7f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800c83:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c87:	48 01 d0             	add    %rdx,%rax
  800c8a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800c8e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800c95:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800c9a:	74 06                	je     800ca2 <vsnprintf+0x65>
  800c9c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800ca0:	7f 07                	jg     800ca9 <vsnprintf+0x6c>
		return -E_INVAL;
  800ca2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ca7:	eb 2f                	jmp    800cd8 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ca9:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800cad:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800cb1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800cb5:	48 89 c6             	mov    %rax,%rsi
  800cb8:	48 bf f0 0b 80 00 00 	movabs $0x800bf0,%rdi
  800cbf:	00 00 00 
  800cc2:	48 b8 25 06 80 00 00 	movabs $0x800625,%rax
  800cc9:	00 00 00 
  800ccc:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800cce:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800cd2:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800cd5:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800cd8:	c9                   	leaveq 
  800cd9:	c3                   	retq   

0000000000800cda <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cda:	55                   	push   %rbp
  800cdb:	48 89 e5             	mov    %rsp,%rbp
  800cde:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800ce5:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800cec:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800cf2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800cf9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d00:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d07:	84 c0                	test   %al,%al
  800d09:	74 20                	je     800d2b <snprintf+0x51>
  800d0b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d0f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d13:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d17:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d1b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d1f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d23:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d27:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d2b:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800d32:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800d39:	00 00 00 
  800d3c:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800d43:	00 00 00 
  800d46:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d4a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800d51:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d58:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800d5f:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800d66:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800d6d:	48 8b 0a             	mov    (%rdx),%rcx
  800d70:	48 89 08             	mov    %rcx,(%rax)
  800d73:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d77:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d7b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d7f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800d83:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800d8a:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800d91:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800d97:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800d9e:	48 89 c7             	mov    %rax,%rdi
  800da1:	48 b8 3d 0c 80 00 00 	movabs $0x800c3d,%rax
  800da8:	00 00 00 
  800dab:	ff d0                	callq  *%rax
  800dad:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800db3:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800db9:	c9                   	leaveq 
  800dba:	c3                   	retq   

0000000000800dbb <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800dbb:	55                   	push   %rbp
  800dbc:	48 89 e5             	mov    %rsp,%rbp
  800dbf:	48 83 ec 18          	sub    $0x18,%rsp
  800dc3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800dc7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800dce:	eb 09                	jmp    800dd9 <strlen+0x1e>
		n++;
  800dd0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800dd4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800dd9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ddd:	0f b6 00             	movzbl (%rax),%eax
  800de0:	84 c0                	test   %al,%al
  800de2:	75 ec                	jne    800dd0 <strlen+0x15>
		n++;
	return n;
  800de4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800de7:	c9                   	leaveq 
  800de8:	c3                   	retq   

0000000000800de9 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800de9:	55                   	push   %rbp
  800dea:	48 89 e5             	mov    %rsp,%rbp
  800ded:	48 83 ec 20          	sub    $0x20,%rsp
  800df1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800df5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800df9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e00:	eb 0e                	jmp    800e10 <strnlen+0x27>
		n++;
  800e02:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e06:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e0b:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800e10:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800e15:	74 0b                	je     800e22 <strnlen+0x39>
  800e17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e1b:	0f b6 00             	movzbl (%rax),%eax
  800e1e:	84 c0                	test   %al,%al
  800e20:	75 e0                	jne    800e02 <strnlen+0x19>
		n++;
	return n;
  800e22:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e25:	c9                   	leaveq 
  800e26:	c3                   	retq   

0000000000800e27 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e27:	55                   	push   %rbp
  800e28:	48 89 e5             	mov    %rsp,%rbp
  800e2b:	48 83 ec 20          	sub    $0x20,%rsp
  800e2f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e33:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800e37:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e3b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800e3f:	90                   	nop
  800e40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e44:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800e48:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800e4c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800e50:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800e54:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800e58:	0f b6 12             	movzbl (%rdx),%edx
  800e5b:	88 10                	mov    %dl,(%rax)
  800e5d:	0f b6 00             	movzbl (%rax),%eax
  800e60:	84 c0                	test   %al,%al
  800e62:	75 dc                	jne    800e40 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800e64:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800e68:	c9                   	leaveq 
  800e69:	c3                   	retq   

0000000000800e6a <strcat>:

char *
strcat(char *dst, const char *src)
{
  800e6a:	55                   	push   %rbp
  800e6b:	48 89 e5             	mov    %rsp,%rbp
  800e6e:	48 83 ec 20          	sub    $0x20,%rsp
  800e72:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e76:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800e7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e7e:	48 89 c7             	mov    %rax,%rdi
  800e81:	48 b8 bb 0d 80 00 00 	movabs $0x800dbb,%rax
  800e88:	00 00 00 
  800e8b:	ff d0                	callq  *%rax
  800e8d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800e90:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e93:	48 63 d0             	movslq %eax,%rdx
  800e96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e9a:	48 01 c2             	add    %rax,%rdx
  800e9d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800ea1:	48 89 c6             	mov    %rax,%rsi
  800ea4:	48 89 d7             	mov    %rdx,%rdi
  800ea7:	48 b8 27 0e 80 00 00 	movabs $0x800e27,%rax
  800eae:	00 00 00 
  800eb1:	ff d0                	callq  *%rax
	return dst;
  800eb3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800eb7:	c9                   	leaveq 
  800eb8:	c3                   	retq   

0000000000800eb9 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800eb9:	55                   	push   %rbp
  800eba:	48 89 e5             	mov    %rsp,%rbp
  800ebd:	48 83 ec 28          	sub    $0x28,%rsp
  800ec1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ec5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800ec9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800ecd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ed1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800ed5:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800edc:	00 
  800edd:	eb 2a                	jmp    800f09 <strncpy+0x50>
		*dst++ = *src;
  800edf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ee3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ee7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800eeb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800eef:	0f b6 12             	movzbl (%rdx),%edx
  800ef2:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ef4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800ef8:	0f b6 00             	movzbl (%rax),%eax
  800efb:	84 c0                	test   %al,%al
  800efd:	74 05                	je     800f04 <strncpy+0x4b>
			src++;
  800eff:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f04:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f0d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800f11:	72 cc                	jb     800edf <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f13:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800f17:	c9                   	leaveq 
  800f18:	c3                   	retq   

0000000000800f19 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f19:	55                   	push   %rbp
  800f1a:	48 89 e5             	mov    %rsp,%rbp
  800f1d:	48 83 ec 28          	sub    $0x28,%rsp
  800f21:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f25:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f29:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800f2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f31:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800f35:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f3a:	74 3d                	je     800f79 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800f3c:	eb 1d                	jmp    800f5b <strlcpy+0x42>
			*dst++ = *src++;
  800f3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f42:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f46:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f4a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f4e:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f52:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f56:	0f b6 12             	movzbl (%rdx),%edx
  800f59:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f5b:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800f60:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f65:	74 0b                	je     800f72 <strlcpy+0x59>
  800f67:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f6b:	0f b6 00             	movzbl (%rax),%eax
  800f6e:	84 c0                	test   %al,%al
  800f70:	75 cc                	jne    800f3e <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800f72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f76:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800f79:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f7d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f81:	48 29 c2             	sub    %rax,%rdx
  800f84:	48 89 d0             	mov    %rdx,%rax
}
  800f87:	c9                   	leaveq 
  800f88:	c3                   	retq   

0000000000800f89 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f89:	55                   	push   %rbp
  800f8a:	48 89 e5             	mov    %rsp,%rbp
  800f8d:	48 83 ec 10          	sub    $0x10,%rsp
  800f91:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800f95:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  800f99:	eb 0a                	jmp    800fa5 <strcmp+0x1c>
		p++, q++;
  800f9b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fa0:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800fa5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fa9:	0f b6 00             	movzbl (%rax),%eax
  800fac:	84 c0                	test   %al,%al
  800fae:	74 12                	je     800fc2 <strcmp+0x39>
  800fb0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fb4:	0f b6 10             	movzbl (%rax),%edx
  800fb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fbb:	0f b6 00             	movzbl (%rax),%eax
  800fbe:	38 c2                	cmp    %al,%dl
  800fc0:	74 d9                	je     800f9b <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fc2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fc6:	0f b6 00             	movzbl (%rax),%eax
  800fc9:	0f b6 d0             	movzbl %al,%edx
  800fcc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fd0:	0f b6 00             	movzbl (%rax),%eax
  800fd3:	0f b6 c0             	movzbl %al,%eax
  800fd6:	29 c2                	sub    %eax,%edx
  800fd8:	89 d0                	mov    %edx,%eax
}
  800fda:	c9                   	leaveq 
  800fdb:	c3                   	retq   

0000000000800fdc <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800fdc:	55                   	push   %rbp
  800fdd:	48 89 e5             	mov    %rsp,%rbp
  800fe0:	48 83 ec 18          	sub    $0x18,%rsp
  800fe4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800fe8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800fec:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  800ff0:	eb 0f                	jmp    801001 <strncmp+0x25>
		n--, p++, q++;
  800ff2:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  800ff7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800ffc:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801001:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801006:	74 1d                	je     801025 <strncmp+0x49>
  801008:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80100c:	0f b6 00             	movzbl (%rax),%eax
  80100f:	84 c0                	test   %al,%al
  801011:	74 12                	je     801025 <strncmp+0x49>
  801013:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801017:	0f b6 10             	movzbl (%rax),%edx
  80101a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80101e:	0f b6 00             	movzbl (%rax),%eax
  801021:	38 c2                	cmp    %al,%dl
  801023:	74 cd                	je     800ff2 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801025:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80102a:	75 07                	jne    801033 <strncmp+0x57>
		return 0;
  80102c:	b8 00 00 00 00       	mov    $0x0,%eax
  801031:	eb 18                	jmp    80104b <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801033:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801037:	0f b6 00             	movzbl (%rax),%eax
  80103a:	0f b6 d0             	movzbl %al,%edx
  80103d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801041:	0f b6 00             	movzbl (%rax),%eax
  801044:	0f b6 c0             	movzbl %al,%eax
  801047:	29 c2                	sub    %eax,%edx
  801049:	89 d0                	mov    %edx,%eax
}
  80104b:	c9                   	leaveq 
  80104c:	c3                   	retq   

000000000080104d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80104d:	55                   	push   %rbp
  80104e:	48 89 e5             	mov    %rsp,%rbp
  801051:	48 83 ec 0c          	sub    $0xc,%rsp
  801055:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801059:	89 f0                	mov    %esi,%eax
  80105b:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80105e:	eb 17                	jmp    801077 <strchr+0x2a>
		if (*s == c)
  801060:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801064:	0f b6 00             	movzbl (%rax),%eax
  801067:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80106a:	75 06                	jne    801072 <strchr+0x25>
			return (char *) s;
  80106c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801070:	eb 15                	jmp    801087 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801072:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801077:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80107b:	0f b6 00             	movzbl (%rax),%eax
  80107e:	84 c0                	test   %al,%al
  801080:	75 de                	jne    801060 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801082:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801087:	c9                   	leaveq 
  801088:	c3                   	retq   

0000000000801089 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801089:	55                   	push   %rbp
  80108a:	48 89 e5             	mov    %rsp,%rbp
  80108d:	48 83 ec 0c          	sub    $0xc,%rsp
  801091:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801095:	89 f0                	mov    %esi,%eax
  801097:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80109a:	eb 13                	jmp    8010af <strfind+0x26>
		if (*s == c)
  80109c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010a0:	0f b6 00             	movzbl (%rax),%eax
  8010a3:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8010a6:	75 02                	jne    8010aa <strfind+0x21>
			break;
  8010a8:	eb 10                	jmp    8010ba <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8010aa:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010b3:	0f b6 00             	movzbl (%rax),%eax
  8010b6:	84 c0                	test   %al,%al
  8010b8:	75 e2                	jne    80109c <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8010ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010be:	c9                   	leaveq 
  8010bf:	c3                   	retq   

00000000008010c0 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8010c0:	55                   	push   %rbp
  8010c1:	48 89 e5             	mov    %rsp,%rbp
  8010c4:	48 83 ec 18          	sub    $0x18,%rsp
  8010c8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010cc:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8010cf:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8010d3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010d8:	75 06                	jne    8010e0 <memset+0x20>
		return v;
  8010da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010de:	eb 69                	jmp    801149 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8010e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010e4:	83 e0 03             	and    $0x3,%eax
  8010e7:	48 85 c0             	test   %rax,%rax
  8010ea:	75 48                	jne    801134 <memset+0x74>
  8010ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f0:	83 e0 03             	and    $0x3,%eax
  8010f3:	48 85 c0             	test   %rax,%rax
  8010f6:	75 3c                	jne    801134 <memset+0x74>
		c &= 0xFF;
  8010f8:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8010ff:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801102:	c1 e0 18             	shl    $0x18,%eax
  801105:	89 c2                	mov    %eax,%edx
  801107:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80110a:	c1 e0 10             	shl    $0x10,%eax
  80110d:	09 c2                	or     %eax,%edx
  80110f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801112:	c1 e0 08             	shl    $0x8,%eax
  801115:	09 d0                	or     %edx,%eax
  801117:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80111a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80111e:	48 c1 e8 02          	shr    $0x2,%rax
  801122:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801125:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801129:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80112c:	48 89 d7             	mov    %rdx,%rdi
  80112f:	fc                   	cld    
  801130:	f3 ab                	rep stos %eax,%es:(%rdi)
  801132:	eb 11                	jmp    801145 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801134:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801138:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80113b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80113f:	48 89 d7             	mov    %rdx,%rdi
  801142:	fc                   	cld    
  801143:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801145:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801149:	c9                   	leaveq 
  80114a:	c3                   	retq   

000000000080114b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80114b:	55                   	push   %rbp
  80114c:	48 89 e5             	mov    %rsp,%rbp
  80114f:	48 83 ec 28          	sub    $0x28,%rsp
  801153:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801157:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80115b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80115f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801163:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801167:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80116b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80116f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801173:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801177:	0f 83 88 00 00 00    	jae    801205 <memmove+0xba>
  80117d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801181:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801185:	48 01 d0             	add    %rdx,%rax
  801188:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80118c:	76 77                	jbe    801205 <memmove+0xba>
		s += n;
  80118e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801192:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801196:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80119a:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80119e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011a2:	83 e0 03             	and    $0x3,%eax
  8011a5:	48 85 c0             	test   %rax,%rax
  8011a8:	75 3b                	jne    8011e5 <memmove+0x9a>
  8011aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011ae:	83 e0 03             	and    $0x3,%eax
  8011b1:	48 85 c0             	test   %rax,%rax
  8011b4:	75 2f                	jne    8011e5 <memmove+0x9a>
  8011b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011ba:	83 e0 03             	and    $0x3,%eax
  8011bd:	48 85 c0             	test   %rax,%rax
  8011c0:	75 23                	jne    8011e5 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8011c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011c6:	48 83 e8 04          	sub    $0x4,%rax
  8011ca:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011ce:	48 83 ea 04          	sub    $0x4,%rdx
  8011d2:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8011d6:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8011da:	48 89 c7             	mov    %rax,%rdi
  8011dd:	48 89 d6             	mov    %rdx,%rsi
  8011e0:	fd                   	std    
  8011e1:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8011e3:	eb 1d                	jmp    801202 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8011e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011e9:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8011ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f1:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8011f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011f9:	48 89 d7             	mov    %rdx,%rdi
  8011fc:	48 89 c1             	mov    %rax,%rcx
  8011ff:	fd                   	std    
  801200:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801202:	fc                   	cld    
  801203:	eb 57                	jmp    80125c <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801205:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801209:	83 e0 03             	and    $0x3,%eax
  80120c:	48 85 c0             	test   %rax,%rax
  80120f:	75 36                	jne    801247 <memmove+0xfc>
  801211:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801215:	83 e0 03             	and    $0x3,%eax
  801218:	48 85 c0             	test   %rax,%rax
  80121b:	75 2a                	jne    801247 <memmove+0xfc>
  80121d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801221:	83 e0 03             	and    $0x3,%eax
  801224:	48 85 c0             	test   %rax,%rax
  801227:	75 1e                	jne    801247 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801229:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80122d:	48 c1 e8 02          	shr    $0x2,%rax
  801231:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801234:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801238:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80123c:	48 89 c7             	mov    %rax,%rdi
  80123f:	48 89 d6             	mov    %rdx,%rsi
  801242:	fc                   	cld    
  801243:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801245:	eb 15                	jmp    80125c <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801247:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80124b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80124f:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801253:	48 89 c7             	mov    %rax,%rdi
  801256:	48 89 d6             	mov    %rdx,%rsi
  801259:	fc                   	cld    
  80125a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80125c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801260:	c9                   	leaveq 
  801261:	c3                   	retq   

0000000000801262 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801262:	55                   	push   %rbp
  801263:	48 89 e5             	mov    %rsp,%rbp
  801266:	48 83 ec 18          	sub    $0x18,%rsp
  80126a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80126e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801272:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801276:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80127a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80127e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801282:	48 89 ce             	mov    %rcx,%rsi
  801285:	48 89 c7             	mov    %rax,%rdi
  801288:	48 b8 4b 11 80 00 00 	movabs $0x80114b,%rax
  80128f:	00 00 00 
  801292:	ff d0                	callq  *%rax
}
  801294:	c9                   	leaveq 
  801295:	c3                   	retq   

0000000000801296 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801296:	55                   	push   %rbp
  801297:	48 89 e5             	mov    %rsp,%rbp
  80129a:	48 83 ec 28          	sub    $0x28,%rsp
  80129e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012a2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012a6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8012aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012ae:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8012b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012b6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8012ba:	eb 36                	jmp    8012f2 <memcmp+0x5c>
		if (*s1 != *s2)
  8012bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c0:	0f b6 10             	movzbl (%rax),%edx
  8012c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012c7:	0f b6 00             	movzbl (%rax),%eax
  8012ca:	38 c2                	cmp    %al,%dl
  8012cc:	74 1a                	je     8012e8 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8012ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d2:	0f b6 00             	movzbl (%rax),%eax
  8012d5:	0f b6 d0             	movzbl %al,%edx
  8012d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012dc:	0f b6 00             	movzbl (%rax),%eax
  8012df:	0f b6 c0             	movzbl %al,%eax
  8012e2:	29 c2                	sub    %eax,%edx
  8012e4:	89 d0                	mov    %edx,%eax
  8012e6:	eb 20                	jmp    801308 <memcmp+0x72>
		s1++, s2++;
  8012e8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012ed:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8012f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012f6:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8012fa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8012fe:	48 85 c0             	test   %rax,%rax
  801301:	75 b9                	jne    8012bc <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801303:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801308:	c9                   	leaveq 
  801309:	c3                   	retq   

000000000080130a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80130a:	55                   	push   %rbp
  80130b:	48 89 e5             	mov    %rsp,%rbp
  80130e:	48 83 ec 28          	sub    $0x28,%rsp
  801312:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801316:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801319:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80131d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801321:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801325:	48 01 d0             	add    %rdx,%rax
  801328:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80132c:	eb 15                	jmp    801343 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80132e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801332:	0f b6 10             	movzbl (%rax),%edx
  801335:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801338:	38 c2                	cmp    %al,%dl
  80133a:	75 02                	jne    80133e <memfind+0x34>
			break;
  80133c:	eb 0f                	jmp    80134d <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80133e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801343:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801347:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80134b:	72 e1                	jb     80132e <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80134d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801351:	c9                   	leaveq 
  801352:	c3                   	retq   

0000000000801353 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801353:	55                   	push   %rbp
  801354:	48 89 e5             	mov    %rsp,%rbp
  801357:	48 83 ec 34          	sub    $0x34,%rsp
  80135b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80135f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801363:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801366:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80136d:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801374:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801375:	eb 05                	jmp    80137c <strtol+0x29>
		s++;
  801377:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80137c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801380:	0f b6 00             	movzbl (%rax),%eax
  801383:	3c 20                	cmp    $0x20,%al
  801385:	74 f0                	je     801377 <strtol+0x24>
  801387:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80138b:	0f b6 00             	movzbl (%rax),%eax
  80138e:	3c 09                	cmp    $0x9,%al
  801390:	74 e5                	je     801377 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801392:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801396:	0f b6 00             	movzbl (%rax),%eax
  801399:	3c 2b                	cmp    $0x2b,%al
  80139b:	75 07                	jne    8013a4 <strtol+0x51>
		s++;
  80139d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013a2:	eb 17                	jmp    8013bb <strtol+0x68>
	else if (*s == '-')
  8013a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013a8:	0f b6 00             	movzbl (%rax),%eax
  8013ab:	3c 2d                	cmp    $0x2d,%al
  8013ad:	75 0c                	jne    8013bb <strtol+0x68>
		s++, neg = 1;
  8013af:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013b4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013bb:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013bf:	74 06                	je     8013c7 <strtol+0x74>
  8013c1:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8013c5:	75 28                	jne    8013ef <strtol+0x9c>
  8013c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013cb:	0f b6 00             	movzbl (%rax),%eax
  8013ce:	3c 30                	cmp    $0x30,%al
  8013d0:	75 1d                	jne    8013ef <strtol+0x9c>
  8013d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d6:	48 83 c0 01          	add    $0x1,%rax
  8013da:	0f b6 00             	movzbl (%rax),%eax
  8013dd:	3c 78                	cmp    $0x78,%al
  8013df:	75 0e                	jne    8013ef <strtol+0x9c>
		s += 2, base = 16;
  8013e1:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8013e6:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8013ed:	eb 2c                	jmp    80141b <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8013ef:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013f3:	75 19                	jne    80140e <strtol+0xbb>
  8013f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f9:	0f b6 00             	movzbl (%rax),%eax
  8013fc:	3c 30                	cmp    $0x30,%al
  8013fe:	75 0e                	jne    80140e <strtol+0xbb>
		s++, base = 8;
  801400:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801405:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80140c:	eb 0d                	jmp    80141b <strtol+0xc8>
	else if (base == 0)
  80140e:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801412:	75 07                	jne    80141b <strtol+0xc8>
		base = 10;
  801414:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80141b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80141f:	0f b6 00             	movzbl (%rax),%eax
  801422:	3c 2f                	cmp    $0x2f,%al
  801424:	7e 1d                	jle    801443 <strtol+0xf0>
  801426:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80142a:	0f b6 00             	movzbl (%rax),%eax
  80142d:	3c 39                	cmp    $0x39,%al
  80142f:	7f 12                	jg     801443 <strtol+0xf0>
			dig = *s - '0';
  801431:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801435:	0f b6 00             	movzbl (%rax),%eax
  801438:	0f be c0             	movsbl %al,%eax
  80143b:	83 e8 30             	sub    $0x30,%eax
  80143e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801441:	eb 4e                	jmp    801491 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801443:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801447:	0f b6 00             	movzbl (%rax),%eax
  80144a:	3c 60                	cmp    $0x60,%al
  80144c:	7e 1d                	jle    80146b <strtol+0x118>
  80144e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801452:	0f b6 00             	movzbl (%rax),%eax
  801455:	3c 7a                	cmp    $0x7a,%al
  801457:	7f 12                	jg     80146b <strtol+0x118>
			dig = *s - 'a' + 10;
  801459:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80145d:	0f b6 00             	movzbl (%rax),%eax
  801460:	0f be c0             	movsbl %al,%eax
  801463:	83 e8 57             	sub    $0x57,%eax
  801466:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801469:	eb 26                	jmp    801491 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80146b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80146f:	0f b6 00             	movzbl (%rax),%eax
  801472:	3c 40                	cmp    $0x40,%al
  801474:	7e 48                	jle    8014be <strtol+0x16b>
  801476:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80147a:	0f b6 00             	movzbl (%rax),%eax
  80147d:	3c 5a                	cmp    $0x5a,%al
  80147f:	7f 3d                	jg     8014be <strtol+0x16b>
			dig = *s - 'A' + 10;
  801481:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801485:	0f b6 00             	movzbl (%rax),%eax
  801488:	0f be c0             	movsbl %al,%eax
  80148b:	83 e8 37             	sub    $0x37,%eax
  80148e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801491:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801494:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801497:	7c 02                	jl     80149b <strtol+0x148>
			break;
  801499:	eb 23                	jmp    8014be <strtol+0x16b>
		s++, val = (val * base) + dig;
  80149b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014a0:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8014a3:	48 98                	cltq   
  8014a5:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8014aa:	48 89 c2             	mov    %rax,%rdx
  8014ad:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8014b0:	48 98                	cltq   
  8014b2:	48 01 d0             	add    %rdx,%rax
  8014b5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8014b9:	e9 5d ff ff ff       	jmpq   80141b <strtol+0xc8>

	if (endptr)
  8014be:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8014c3:	74 0b                	je     8014d0 <strtol+0x17d>
		*endptr = (char *) s;
  8014c5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014c9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8014cd:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8014d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8014d4:	74 09                	je     8014df <strtol+0x18c>
  8014d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014da:	48 f7 d8             	neg    %rax
  8014dd:	eb 04                	jmp    8014e3 <strtol+0x190>
  8014df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8014e3:	c9                   	leaveq 
  8014e4:	c3                   	retq   

00000000008014e5 <strstr>:

char * strstr(const char *in, const char *str)
{
  8014e5:	55                   	push   %rbp
  8014e6:	48 89 e5             	mov    %rsp,%rbp
  8014e9:	48 83 ec 30          	sub    $0x30,%rsp
  8014ed:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8014f1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8014f5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014f9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014fd:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801501:	0f b6 00             	movzbl (%rax),%eax
  801504:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801507:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80150b:	75 06                	jne    801513 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80150d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801511:	eb 6b                	jmp    80157e <strstr+0x99>

	len = strlen(str);
  801513:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801517:	48 89 c7             	mov    %rax,%rdi
  80151a:	48 b8 bb 0d 80 00 00 	movabs $0x800dbb,%rax
  801521:	00 00 00 
  801524:	ff d0                	callq  *%rax
  801526:	48 98                	cltq   
  801528:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80152c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801530:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801534:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801538:	0f b6 00             	movzbl (%rax),%eax
  80153b:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80153e:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801542:	75 07                	jne    80154b <strstr+0x66>
				return (char *) 0;
  801544:	b8 00 00 00 00       	mov    $0x0,%eax
  801549:	eb 33                	jmp    80157e <strstr+0x99>
		} while (sc != c);
  80154b:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80154f:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801552:	75 d8                	jne    80152c <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801554:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801558:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80155c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801560:	48 89 ce             	mov    %rcx,%rsi
  801563:	48 89 c7             	mov    %rax,%rdi
  801566:	48 b8 dc 0f 80 00 00 	movabs $0x800fdc,%rax
  80156d:	00 00 00 
  801570:	ff d0                	callq  *%rax
  801572:	85 c0                	test   %eax,%eax
  801574:	75 b6                	jne    80152c <strstr+0x47>

	return (char *) (in - 1);
  801576:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157a:	48 83 e8 01          	sub    $0x1,%rax
}
  80157e:	c9                   	leaveq 
  80157f:	c3                   	retq   

0000000000801580 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801580:	55                   	push   %rbp
  801581:	48 89 e5             	mov    %rsp,%rbp
  801584:	53                   	push   %rbx
  801585:	48 83 ec 48          	sub    $0x48,%rsp
  801589:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80158c:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80158f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801593:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801597:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80159b:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80159f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015a2:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8015a6:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8015aa:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8015ae:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8015b2:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8015b6:	4c 89 c3             	mov    %r8,%rbx
  8015b9:	cd 30                	int    $0x30
  8015bb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8015bf:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8015c3:	74 3e                	je     801603 <syscall+0x83>
  8015c5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015ca:	7e 37                	jle    801603 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8015cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015d0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015d3:	49 89 d0             	mov    %rdx,%r8
  8015d6:	89 c1                	mov    %eax,%ecx
  8015d8:	48 ba a8 43 80 00 00 	movabs $0x8043a8,%rdx
  8015df:	00 00 00 
  8015e2:	be 23 00 00 00       	mov    $0x23,%esi
  8015e7:	48 bf c5 43 80 00 00 	movabs $0x8043c5,%rdi
  8015ee:	00 00 00 
  8015f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8015f6:	49 b9 19 3b 80 00 00 	movabs $0x803b19,%r9
  8015fd:	00 00 00 
  801600:	41 ff d1             	callq  *%r9

	return ret;
  801603:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801607:	48 83 c4 48          	add    $0x48,%rsp
  80160b:	5b                   	pop    %rbx
  80160c:	5d                   	pop    %rbp
  80160d:	c3                   	retq   

000000000080160e <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80160e:	55                   	push   %rbp
  80160f:	48 89 e5             	mov    %rsp,%rbp
  801612:	48 83 ec 20          	sub    $0x20,%rsp
  801616:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80161a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80161e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801622:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801626:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80162d:	00 
  80162e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801634:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80163a:	48 89 d1             	mov    %rdx,%rcx
  80163d:	48 89 c2             	mov    %rax,%rdx
  801640:	be 00 00 00 00       	mov    $0x0,%esi
  801645:	bf 00 00 00 00       	mov    $0x0,%edi
  80164a:	48 b8 80 15 80 00 00 	movabs $0x801580,%rax
  801651:	00 00 00 
  801654:	ff d0                	callq  *%rax
}
  801656:	c9                   	leaveq 
  801657:	c3                   	retq   

0000000000801658 <sys_cgetc>:

int
sys_cgetc(void)
{
  801658:	55                   	push   %rbp
  801659:	48 89 e5             	mov    %rsp,%rbp
  80165c:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801660:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801667:	00 
  801668:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80166e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801674:	b9 00 00 00 00       	mov    $0x0,%ecx
  801679:	ba 00 00 00 00       	mov    $0x0,%edx
  80167e:	be 00 00 00 00       	mov    $0x0,%esi
  801683:	bf 01 00 00 00       	mov    $0x1,%edi
  801688:	48 b8 80 15 80 00 00 	movabs $0x801580,%rax
  80168f:	00 00 00 
  801692:	ff d0                	callq  *%rax
}
  801694:	c9                   	leaveq 
  801695:	c3                   	retq   

0000000000801696 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801696:	55                   	push   %rbp
  801697:	48 89 e5             	mov    %rsp,%rbp
  80169a:	48 83 ec 10          	sub    $0x10,%rsp
  80169e:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8016a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016a4:	48 98                	cltq   
  8016a6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016ad:	00 
  8016ae:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016b4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016ba:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016bf:	48 89 c2             	mov    %rax,%rdx
  8016c2:	be 01 00 00 00       	mov    $0x1,%esi
  8016c7:	bf 03 00 00 00       	mov    $0x3,%edi
  8016cc:	48 b8 80 15 80 00 00 	movabs $0x801580,%rax
  8016d3:	00 00 00 
  8016d6:	ff d0                	callq  *%rax
}
  8016d8:	c9                   	leaveq 
  8016d9:	c3                   	retq   

00000000008016da <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8016da:	55                   	push   %rbp
  8016db:	48 89 e5             	mov    %rsp,%rbp
  8016de:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8016e2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016e9:	00 
  8016ea:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016f0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016f6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016fb:	ba 00 00 00 00       	mov    $0x0,%edx
  801700:	be 00 00 00 00       	mov    $0x0,%esi
  801705:	bf 02 00 00 00       	mov    $0x2,%edi
  80170a:	48 b8 80 15 80 00 00 	movabs $0x801580,%rax
  801711:	00 00 00 
  801714:	ff d0                	callq  *%rax
}
  801716:	c9                   	leaveq 
  801717:	c3                   	retq   

0000000000801718 <sys_yield>:

void
sys_yield(void)
{
  801718:	55                   	push   %rbp
  801719:	48 89 e5             	mov    %rsp,%rbp
  80171c:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801720:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801727:	00 
  801728:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80172e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801734:	b9 00 00 00 00       	mov    $0x0,%ecx
  801739:	ba 00 00 00 00       	mov    $0x0,%edx
  80173e:	be 00 00 00 00       	mov    $0x0,%esi
  801743:	bf 0b 00 00 00       	mov    $0xb,%edi
  801748:	48 b8 80 15 80 00 00 	movabs $0x801580,%rax
  80174f:	00 00 00 
  801752:	ff d0                	callq  *%rax
}
  801754:	c9                   	leaveq 
  801755:	c3                   	retq   

0000000000801756 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801756:	55                   	push   %rbp
  801757:	48 89 e5             	mov    %rsp,%rbp
  80175a:	48 83 ec 20          	sub    $0x20,%rsp
  80175e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801761:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801765:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801768:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80176b:	48 63 c8             	movslq %eax,%rcx
  80176e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801772:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801775:	48 98                	cltq   
  801777:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80177e:	00 
  80177f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801785:	49 89 c8             	mov    %rcx,%r8
  801788:	48 89 d1             	mov    %rdx,%rcx
  80178b:	48 89 c2             	mov    %rax,%rdx
  80178e:	be 01 00 00 00       	mov    $0x1,%esi
  801793:	bf 04 00 00 00       	mov    $0x4,%edi
  801798:	48 b8 80 15 80 00 00 	movabs $0x801580,%rax
  80179f:	00 00 00 
  8017a2:	ff d0                	callq  *%rax
}
  8017a4:	c9                   	leaveq 
  8017a5:	c3                   	retq   

00000000008017a6 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8017a6:	55                   	push   %rbp
  8017a7:	48 89 e5             	mov    %rsp,%rbp
  8017aa:	48 83 ec 30          	sub    $0x30,%rsp
  8017ae:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017b1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017b5:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8017b8:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8017bc:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8017c0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8017c3:	48 63 c8             	movslq %eax,%rcx
  8017c6:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8017ca:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8017cd:	48 63 f0             	movslq %eax,%rsi
  8017d0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017d7:	48 98                	cltq   
  8017d9:	48 89 0c 24          	mov    %rcx,(%rsp)
  8017dd:	49 89 f9             	mov    %rdi,%r9
  8017e0:	49 89 f0             	mov    %rsi,%r8
  8017e3:	48 89 d1             	mov    %rdx,%rcx
  8017e6:	48 89 c2             	mov    %rax,%rdx
  8017e9:	be 01 00 00 00       	mov    $0x1,%esi
  8017ee:	bf 05 00 00 00       	mov    $0x5,%edi
  8017f3:	48 b8 80 15 80 00 00 	movabs $0x801580,%rax
  8017fa:	00 00 00 
  8017fd:	ff d0                	callq  *%rax
}
  8017ff:	c9                   	leaveq 
  801800:	c3                   	retq   

0000000000801801 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801801:	55                   	push   %rbp
  801802:	48 89 e5             	mov    %rsp,%rbp
  801805:	48 83 ec 20          	sub    $0x20,%rsp
  801809:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80180c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801810:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801814:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801817:	48 98                	cltq   
  801819:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801820:	00 
  801821:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801827:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80182d:	48 89 d1             	mov    %rdx,%rcx
  801830:	48 89 c2             	mov    %rax,%rdx
  801833:	be 01 00 00 00       	mov    $0x1,%esi
  801838:	bf 06 00 00 00       	mov    $0x6,%edi
  80183d:	48 b8 80 15 80 00 00 	movabs $0x801580,%rax
  801844:	00 00 00 
  801847:	ff d0                	callq  *%rax
}
  801849:	c9                   	leaveq 
  80184a:	c3                   	retq   

000000000080184b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80184b:	55                   	push   %rbp
  80184c:	48 89 e5             	mov    %rsp,%rbp
  80184f:	48 83 ec 10          	sub    $0x10,%rsp
  801853:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801856:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801859:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80185c:	48 63 d0             	movslq %eax,%rdx
  80185f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801862:	48 98                	cltq   
  801864:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80186b:	00 
  80186c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801872:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801878:	48 89 d1             	mov    %rdx,%rcx
  80187b:	48 89 c2             	mov    %rax,%rdx
  80187e:	be 01 00 00 00       	mov    $0x1,%esi
  801883:	bf 08 00 00 00       	mov    $0x8,%edi
  801888:	48 b8 80 15 80 00 00 	movabs $0x801580,%rax
  80188f:	00 00 00 
  801892:	ff d0                	callq  *%rax
}
  801894:	c9                   	leaveq 
  801895:	c3                   	retq   

0000000000801896 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801896:	55                   	push   %rbp
  801897:	48 89 e5             	mov    %rsp,%rbp
  80189a:	48 83 ec 20          	sub    $0x20,%rsp
  80189e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018a1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  8018a5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018ac:	48 98                	cltq   
  8018ae:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018b5:	00 
  8018b6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018bc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018c2:	48 89 d1             	mov    %rdx,%rcx
  8018c5:	48 89 c2             	mov    %rax,%rdx
  8018c8:	be 01 00 00 00       	mov    $0x1,%esi
  8018cd:	bf 09 00 00 00       	mov    $0x9,%edi
  8018d2:	48 b8 80 15 80 00 00 	movabs $0x801580,%rax
  8018d9:	00 00 00 
  8018dc:	ff d0                	callq  *%rax
}
  8018de:	c9                   	leaveq 
  8018df:	c3                   	retq   

00000000008018e0 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8018e0:	55                   	push   %rbp
  8018e1:	48 89 e5             	mov    %rsp,%rbp
  8018e4:	48 83 ec 20          	sub    $0x20,%rsp
  8018e8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018eb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8018ef:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018f6:	48 98                	cltq   
  8018f8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018ff:	00 
  801900:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801906:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80190c:	48 89 d1             	mov    %rdx,%rcx
  80190f:	48 89 c2             	mov    %rax,%rdx
  801912:	be 01 00 00 00       	mov    $0x1,%esi
  801917:	bf 0a 00 00 00       	mov    $0xa,%edi
  80191c:	48 b8 80 15 80 00 00 	movabs $0x801580,%rax
  801923:	00 00 00 
  801926:	ff d0                	callq  *%rax
}
  801928:	c9                   	leaveq 
  801929:	c3                   	retq   

000000000080192a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  80192a:	55                   	push   %rbp
  80192b:	48 89 e5             	mov    %rsp,%rbp
  80192e:	48 83 ec 20          	sub    $0x20,%rsp
  801932:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801935:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801939:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80193d:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801940:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801943:	48 63 f0             	movslq %eax,%rsi
  801946:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80194a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80194d:	48 98                	cltq   
  80194f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801953:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80195a:	00 
  80195b:	49 89 f1             	mov    %rsi,%r9
  80195e:	49 89 c8             	mov    %rcx,%r8
  801961:	48 89 d1             	mov    %rdx,%rcx
  801964:	48 89 c2             	mov    %rax,%rdx
  801967:	be 00 00 00 00       	mov    $0x0,%esi
  80196c:	bf 0c 00 00 00       	mov    $0xc,%edi
  801971:	48 b8 80 15 80 00 00 	movabs $0x801580,%rax
  801978:	00 00 00 
  80197b:	ff d0                	callq  *%rax
}
  80197d:	c9                   	leaveq 
  80197e:	c3                   	retq   

000000000080197f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80197f:	55                   	push   %rbp
  801980:	48 89 e5             	mov    %rsp,%rbp
  801983:	48 83 ec 10          	sub    $0x10,%rsp
  801987:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  80198b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80198f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801996:	00 
  801997:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80199d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019a3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019a8:	48 89 c2             	mov    %rax,%rdx
  8019ab:	be 01 00 00 00       	mov    $0x1,%esi
  8019b0:	bf 0d 00 00 00       	mov    $0xd,%edi
  8019b5:	48 b8 80 15 80 00 00 	movabs $0x801580,%rax
  8019bc:	00 00 00 
  8019bf:	ff d0                	callq  *%rax
}
  8019c1:	c9                   	leaveq 
  8019c2:	c3                   	retq   

00000000008019c3 <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  8019c3:	55                   	push   %rbp
  8019c4:	48 89 e5             	mov    %rsp,%rbp
  8019c7:	48 83 ec 20          	sub    $0x20,%rsp
  8019cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019cf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, (uint64_t)buf, len, 0, 0, 0, 0);
  8019d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019d7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019db:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019e2:	00 
  8019e3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019e9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019ef:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019f4:	89 c6                	mov    %eax,%esi
  8019f6:	bf 0f 00 00 00       	mov    $0xf,%edi
  8019fb:	48 b8 80 15 80 00 00 	movabs $0x801580,%rax
  801a02:	00 00 00 
  801a05:	ff d0                	callq  *%rax
}
  801a07:	c9                   	leaveq 
  801a08:	c3                   	retq   

0000000000801a09 <sys_net_rx>:

int
sys_net_rx(void *buf, size_t len)
{
  801a09:	55                   	push   %rbp
  801a0a:	48 89 e5             	mov    %rsp,%rbp
  801a0d:	48 83 ec 20          	sub    $0x20,%rsp
  801a11:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a15:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_rx, (uint64_t)buf, len, 0, 0, 0, 0);
  801a19:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a1d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a21:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a28:	00 
  801a29:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a2f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a35:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a3a:	89 c6                	mov    %eax,%esi
  801a3c:	bf 10 00 00 00       	mov    $0x10,%edi
  801a41:	48 b8 80 15 80 00 00 	movabs $0x801580,%rax
  801a48:	00 00 00 
  801a4b:	ff d0                	callq  *%rax
}
  801a4d:	c9                   	leaveq 
  801a4e:	c3                   	retq   

0000000000801a4f <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801a4f:	55                   	push   %rbp
  801a50:	48 89 e5             	mov    %rsp,%rbp
  801a53:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801a57:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a5e:	00 
  801a5f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a65:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a6b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a70:	ba 00 00 00 00       	mov    $0x0,%edx
  801a75:	be 00 00 00 00       	mov    $0x0,%esi
  801a7a:	bf 0e 00 00 00       	mov    $0xe,%edi
  801a7f:	48 b8 80 15 80 00 00 	movabs $0x801580,%rax
  801a86:	00 00 00 
  801a89:	ff d0                	callq  *%rax
}
  801a8b:	c9                   	leaveq 
  801a8c:	c3                   	retq   

0000000000801a8d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801a8d:	55                   	push   %rbp
  801a8e:	48 89 e5             	mov    %rsp,%rbp
  801a91:	48 83 ec 08          	sub    $0x8,%rsp
  801a95:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801a99:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a9d:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801aa4:	ff ff ff 
  801aa7:	48 01 d0             	add    %rdx,%rax
  801aaa:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801aae:	c9                   	leaveq 
  801aaf:	c3                   	retq   

0000000000801ab0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801ab0:	55                   	push   %rbp
  801ab1:	48 89 e5             	mov    %rsp,%rbp
  801ab4:	48 83 ec 08          	sub    $0x8,%rsp
  801ab8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801abc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ac0:	48 89 c7             	mov    %rax,%rdi
  801ac3:	48 b8 8d 1a 80 00 00 	movabs $0x801a8d,%rax
  801aca:	00 00 00 
  801acd:	ff d0                	callq  *%rax
  801acf:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801ad5:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801ad9:	c9                   	leaveq 
  801ada:	c3                   	retq   

0000000000801adb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801adb:	55                   	push   %rbp
  801adc:	48 89 e5             	mov    %rsp,%rbp
  801adf:	48 83 ec 18          	sub    $0x18,%rsp
  801ae3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801ae7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801aee:	eb 6b                	jmp    801b5b <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801af0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801af3:	48 98                	cltq   
  801af5:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801afb:	48 c1 e0 0c          	shl    $0xc,%rax
  801aff:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801b03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b07:	48 c1 e8 15          	shr    $0x15,%rax
  801b0b:	48 89 c2             	mov    %rax,%rdx
  801b0e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801b15:	01 00 00 
  801b18:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801b1c:	83 e0 01             	and    $0x1,%eax
  801b1f:	48 85 c0             	test   %rax,%rax
  801b22:	74 21                	je     801b45 <fd_alloc+0x6a>
  801b24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b28:	48 c1 e8 0c          	shr    $0xc,%rax
  801b2c:	48 89 c2             	mov    %rax,%rdx
  801b2f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801b36:	01 00 00 
  801b39:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801b3d:	83 e0 01             	and    $0x1,%eax
  801b40:	48 85 c0             	test   %rax,%rax
  801b43:	75 12                	jne    801b57 <fd_alloc+0x7c>
			*fd_store = fd;
  801b45:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b49:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b4d:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801b50:	b8 00 00 00 00       	mov    $0x0,%eax
  801b55:	eb 1a                	jmp    801b71 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801b57:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801b5b:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801b5f:	7e 8f                	jle    801af0 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801b61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b65:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801b6c:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801b71:	c9                   	leaveq 
  801b72:	c3                   	retq   

0000000000801b73 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801b73:	55                   	push   %rbp
  801b74:	48 89 e5             	mov    %rsp,%rbp
  801b77:	48 83 ec 20          	sub    $0x20,%rsp
  801b7b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801b7e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801b82:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801b86:	78 06                	js     801b8e <fd_lookup+0x1b>
  801b88:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801b8c:	7e 07                	jle    801b95 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801b8e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b93:	eb 6c                	jmp    801c01 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801b95:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801b98:	48 98                	cltq   
  801b9a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ba0:	48 c1 e0 0c          	shl    $0xc,%rax
  801ba4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801ba8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bac:	48 c1 e8 15          	shr    $0x15,%rax
  801bb0:	48 89 c2             	mov    %rax,%rdx
  801bb3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801bba:	01 00 00 
  801bbd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801bc1:	83 e0 01             	and    $0x1,%eax
  801bc4:	48 85 c0             	test   %rax,%rax
  801bc7:	74 21                	je     801bea <fd_lookup+0x77>
  801bc9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bcd:	48 c1 e8 0c          	shr    $0xc,%rax
  801bd1:	48 89 c2             	mov    %rax,%rdx
  801bd4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801bdb:	01 00 00 
  801bde:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801be2:	83 e0 01             	and    $0x1,%eax
  801be5:	48 85 c0             	test   %rax,%rax
  801be8:	75 07                	jne    801bf1 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801bea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bef:	eb 10                	jmp    801c01 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801bf1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801bf5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801bf9:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801bfc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c01:	c9                   	leaveq 
  801c02:	c3                   	retq   

0000000000801c03 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801c03:	55                   	push   %rbp
  801c04:	48 89 e5             	mov    %rsp,%rbp
  801c07:	48 83 ec 30          	sub    $0x30,%rsp
  801c0b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801c0f:	89 f0                	mov    %esi,%eax
  801c11:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801c14:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c18:	48 89 c7             	mov    %rax,%rdi
  801c1b:	48 b8 8d 1a 80 00 00 	movabs $0x801a8d,%rax
  801c22:	00 00 00 
  801c25:	ff d0                	callq  *%rax
  801c27:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801c2b:	48 89 d6             	mov    %rdx,%rsi
  801c2e:	89 c7                	mov    %eax,%edi
  801c30:	48 b8 73 1b 80 00 00 	movabs $0x801b73,%rax
  801c37:	00 00 00 
  801c3a:	ff d0                	callq  *%rax
  801c3c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c3f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c43:	78 0a                	js     801c4f <fd_close+0x4c>
	    || fd != fd2)
  801c45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c49:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801c4d:	74 12                	je     801c61 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801c4f:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801c53:	74 05                	je     801c5a <fd_close+0x57>
  801c55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c58:	eb 05                	jmp    801c5f <fd_close+0x5c>
  801c5a:	b8 00 00 00 00       	mov    $0x0,%eax
  801c5f:	eb 69                	jmp    801cca <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801c61:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c65:	8b 00                	mov    (%rax),%eax
  801c67:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801c6b:	48 89 d6             	mov    %rdx,%rsi
  801c6e:	89 c7                	mov    %eax,%edi
  801c70:	48 b8 cc 1c 80 00 00 	movabs $0x801ccc,%rax
  801c77:	00 00 00 
  801c7a:	ff d0                	callq  *%rax
  801c7c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c7f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c83:	78 2a                	js     801caf <fd_close+0xac>
		if (dev->dev_close)
  801c85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c89:	48 8b 40 20          	mov    0x20(%rax),%rax
  801c8d:	48 85 c0             	test   %rax,%rax
  801c90:	74 16                	je     801ca8 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801c92:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c96:	48 8b 40 20          	mov    0x20(%rax),%rax
  801c9a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801c9e:	48 89 d7             	mov    %rdx,%rdi
  801ca1:	ff d0                	callq  *%rax
  801ca3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ca6:	eb 07                	jmp    801caf <fd_close+0xac>
		else
			r = 0;
  801ca8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801caf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cb3:	48 89 c6             	mov    %rax,%rsi
  801cb6:	bf 00 00 00 00       	mov    $0x0,%edi
  801cbb:	48 b8 01 18 80 00 00 	movabs $0x801801,%rax
  801cc2:	00 00 00 
  801cc5:	ff d0                	callq  *%rax
	return r;
  801cc7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801cca:	c9                   	leaveq 
  801ccb:	c3                   	retq   

0000000000801ccc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801ccc:	55                   	push   %rbp
  801ccd:	48 89 e5             	mov    %rsp,%rbp
  801cd0:	48 83 ec 20          	sub    $0x20,%rsp
  801cd4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801cd7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801cdb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801ce2:	eb 41                	jmp    801d25 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801ce4:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801ceb:	00 00 00 
  801cee:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801cf1:	48 63 d2             	movslq %edx,%rdx
  801cf4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801cf8:	8b 00                	mov    (%rax),%eax
  801cfa:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801cfd:	75 22                	jne    801d21 <dev_lookup+0x55>
			*dev = devtab[i];
  801cff:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801d06:	00 00 00 
  801d09:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801d0c:	48 63 d2             	movslq %edx,%rdx
  801d0f:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801d13:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d17:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801d1a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d1f:	eb 60                	jmp    801d81 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801d21:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801d25:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801d2c:	00 00 00 
  801d2f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801d32:	48 63 d2             	movslq %edx,%rdx
  801d35:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d39:	48 85 c0             	test   %rax,%rax
  801d3c:	75 a6                	jne    801ce4 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801d3e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801d45:	00 00 00 
  801d48:	48 8b 00             	mov    (%rax),%rax
  801d4b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801d51:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801d54:	89 c6                	mov    %eax,%esi
  801d56:	48 bf d8 43 80 00 00 	movabs $0x8043d8,%rdi
  801d5d:	00 00 00 
  801d60:	b8 00 00 00 00       	mov    $0x0,%eax
  801d65:	48 b9 72 02 80 00 00 	movabs $0x800272,%rcx
  801d6c:	00 00 00 
  801d6f:	ff d1                	callq  *%rcx
	*dev = 0;
  801d71:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d75:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801d7c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801d81:	c9                   	leaveq 
  801d82:	c3                   	retq   

0000000000801d83 <close>:

int
close(int fdnum)
{
  801d83:	55                   	push   %rbp
  801d84:	48 89 e5             	mov    %rsp,%rbp
  801d87:	48 83 ec 20          	sub    $0x20,%rsp
  801d8b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d8e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801d92:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d95:	48 89 d6             	mov    %rdx,%rsi
  801d98:	89 c7                	mov    %eax,%edi
  801d9a:	48 b8 73 1b 80 00 00 	movabs $0x801b73,%rax
  801da1:	00 00 00 
  801da4:	ff d0                	callq  *%rax
  801da6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801da9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801dad:	79 05                	jns    801db4 <close+0x31>
		return r;
  801daf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801db2:	eb 18                	jmp    801dcc <close+0x49>
	else
		return fd_close(fd, 1);
  801db4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801db8:	be 01 00 00 00       	mov    $0x1,%esi
  801dbd:	48 89 c7             	mov    %rax,%rdi
  801dc0:	48 b8 03 1c 80 00 00 	movabs $0x801c03,%rax
  801dc7:	00 00 00 
  801dca:	ff d0                	callq  *%rax
}
  801dcc:	c9                   	leaveq 
  801dcd:	c3                   	retq   

0000000000801dce <close_all>:

void
close_all(void)
{
  801dce:	55                   	push   %rbp
  801dcf:	48 89 e5             	mov    %rsp,%rbp
  801dd2:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801dd6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801ddd:	eb 15                	jmp    801df4 <close_all+0x26>
		close(i);
  801ddf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801de2:	89 c7                	mov    %eax,%edi
  801de4:	48 b8 83 1d 80 00 00 	movabs $0x801d83,%rax
  801deb:	00 00 00 
  801dee:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801df0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801df4:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801df8:	7e e5                	jle    801ddf <close_all+0x11>
		close(i);
}
  801dfa:	c9                   	leaveq 
  801dfb:	c3                   	retq   

0000000000801dfc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801dfc:	55                   	push   %rbp
  801dfd:	48 89 e5             	mov    %rsp,%rbp
  801e00:	48 83 ec 40          	sub    $0x40,%rsp
  801e04:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801e07:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801e0a:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801e0e:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801e11:	48 89 d6             	mov    %rdx,%rsi
  801e14:	89 c7                	mov    %eax,%edi
  801e16:	48 b8 73 1b 80 00 00 	movabs $0x801b73,%rax
  801e1d:	00 00 00 
  801e20:	ff d0                	callq  *%rax
  801e22:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e25:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e29:	79 08                	jns    801e33 <dup+0x37>
		return r;
  801e2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e2e:	e9 70 01 00 00       	jmpq   801fa3 <dup+0x1a7>
	close(newfdnum);
  801e33:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801e36:	89 c7                	mov    %eax,%edi
  801e38:	48 b8 83 1d 80 00 00 	movabs $0x801d83,%rax
  801e3f:	00 00 00 
  801e42:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  801e44:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801e47:	48 98                	cltq   
  801e49:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e4f:	48 c1 e0 0c          	shl    $0xc,%rax
  801e53:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  801e57:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e5b:	48 89 c7             	mov    %rax,%rdi
  801e5e:	48 b8 b0 1a 80 00 00 	movabs $0x801ab0,%rax
  801e65:	00 00 00 
  801e68:	ff d0                	callq  *%rax
  801e6a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  801e6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e72:	48 89 c7             	mov    %rax,%rdi
  801e75:	48 b8 b0 1a 80 00 00 	movabs $0x801ab0,%rax
  801e7c:	00 00 00 
  801e7f:	ff d0                	callq  *%rax
  801e81:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801e85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e89:	48 c1 e8 15          	shr    $0x15,%rax
  801e8d:	48 89 c2             	mov    %rax,%rdx
  801e90:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e97:	01 00 00 
  801e9a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e9e:	83 e0 01             	and    $0x1,%eax
  801ea1:	48 85 c0             	test   %rax,%rax
  801ea4:	74 73                	je     801f19 <dup+0x11d>
  801ea6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801eaa:	48 c1 e8 0c          	shr    $0xc,%rax
  801eae:	48 89 c2             	mov    %rax,%rdx
  801eb1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801eb8:	01 00 00 
  801ebb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ebf:	83 e0 01             	and    $0x1,%eax
  801ec2:	48 85 c0             	test   %rax,%rax
  801ec5:	74 52                	je     801f19 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801ec7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ecb:	48 c1 e8 0c          	shr    $0xc,%rax
  801ecf:	48 89 c2             	mov    %rax,%rdx
  801ed2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ed9:	01 00 00 
  801edc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ee0:	25 07 0e 00 00       	and    $0xe07,%eax
  801ee5:	89 c1                	mov    %eax,%ecx
  801ee7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801eeb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801eef:	41 89 c8             	mov    %ecx,%r8d
  801ef2:	48 89 d1             	mov    %rdx,%rcx
  801ef5:	ba 00 00 00 00       	mov    $0x0,%edx
  801efa:	48 89 c6             	mov    %rax,%rsi
  801efd:	bf 00 00 00 00       	mov    $0x0,%edi
  801f02:	48 b8 a6 17 80 00 00 	movabs $0x8017a6,%rax
  801f09:	00 00 00 
  801f0c:	ff d0                	callq  *%rax
  801f0e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f11:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f15:	79 02                	jns    801f19 <dup+0x11d>
			goto err;
  801f17:	eb 57                	jmp    801f70 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801f19:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f1d:	48 c1 e8 0c          	shr    $0xc,%rax
  801f21:	48 89 c2             	mov    %rax,%rdx
  801f24:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f2b:	01 00 00 
  801f2e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f32:	25 07 0e 00 00       	and    $0xe07,%eax
  801f37:	89 c1                	mov    %eax,%ecx
  801f39:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f3d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f41:	41 89 c8             	mov    %ecx,%r8d
  801f44:	48 89 d1             	mov    %rdx,%rcx
  801f47:	ba 00 00 00 00       	mov    $0x0,%edx
  801f4c:	48 89 c6             	mov    %rax,%rsi
  801f4f:	bf 00 00 00 00       	mov    $0x0,%edi
  801f54:	48 b8 a6 17 80 00 00 	movabs $0x8017a6,%rax
  801f5b:	00 00 00 
  801f5e:	ff d0                	callq  *%rax
  801f60:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f63:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f67:	79 02                	jns    801f6b <dup+0x16f>
		goto err;
  801f69:	eb 05                	jmp    801f70 <dup+0x174>

	return newfdnum;
  801f6b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801f6e:	eb 33                	jmp    801fa3 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  801f70:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f74:	48 89 c6             	mov    %rax,%rsi
  801f77:	bf 00 00 00 00       	mov    $0x0,%edi
  801f7c:	48 b8 01 18 80 00 00 	movabs $0x801801,%rax
  801f83:	00 00 00 
  801f86:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  801f88:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f8c:	48 89 c6             	mov    %rax,%rsi
  801f8f:	bf 00 00 00 00       	mov    $0x0,%edi
  801f94:	48 b8 01 18 80 00 00 	movabs $0x801801,%rax
  801f9b:	00 00 00 
  801f9e:	ff d0                	callq  *%rax
	return r;
  801fa0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801fa3:	c9                   	leaveq 
  801fa4:	c3                   	retq   

0000000000801fa5 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801fa5:	55                   	push   %rbp
  801fa6:	48 89 e5             	mov    %rsp,%rbp
  801fa9:	48 83 ec 40          	sub    $0x40,%rsp
  801fad:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801fb0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801fb4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801fb8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801fbc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801fbf:	48 89 d6             	mov    %rdx,%rsi
  801fc2:	89 c7                	mov    %eax,%edi
  801fc4:	48 b8 73 1b 80 00 00 	movabs $0x801b73,%rax
  801fcb:	00 00 00 
  801fce:	ff d0                	callq  *%rax
  801fd0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fd3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fd7:	78 24                	js     801ffd <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801fd9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fdd:	8b 00                	mov    (%rax),%eax
  801fdf:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801fe3:	48 89 d6             	mov    %rdx,%rsi
  801fe6:	89 c7                	mov    %eax,%edi
  801fe8:	48 b8 cc 1c 80 00 00 	movabs $0x801ccc,%rax
  801fef:	00 00 00 
  801ff2:	ff d0                	callq  *%rax
  801ff4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ff7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ffb:	79 05                	jns    802002 <read+0x5d>
		return r;
  801ffd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802000:	eb 76                	jmp    802078 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802002:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802006:	8b 40 08             	mov    0x8(%rax),%eax
  802009:	83 e0 03             	and    $0x3,%eax
  80200c:	83 f8 01             	cmp    $0x1,%eax
  80200f:	75 3a                	jne    80204b <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802011:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802018:	00 00 00 
  80201b:	48 8b 00             	mov    (%rax),%rax
  80201e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802024:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802027:	89 c6                	mov    %eax,%esi
  802029:	48 bf f7 43 80 00 00 	movabs $0x8043f7,%rdi
  802030:	00 00 00 
  802033:	b8 00 00 00 00       	mov    $0x0,%eax
  802038:	48 b9 72 02 80 00 00 	movabs $0x800272,%rcx
  80203f:	00 00 00 
  802042:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802044:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802049:	eb 2d                	jmp    802078 <read+0xd3>
	}
	if (!dev->dev_read)
  80204b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80204f:	48 8b 40 10          	mov    0x10(%rax),%rax
  802053:	48 85 c0             	test   %rax,%rax
  802056:	75 07                	jne    80205f <read+0xba>
		return -E_NOT_SUPP;
  802058:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80205d:	eb 19                	jmp    802078 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80205f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802063:	48 8b 40 10          	mov    0x10(%rax),%rax
  802067:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80206b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80206f:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802073:	48 89 cf             	mov    %rcx,%rdi
  802076:	ff d0                	callq  *%rax
}
  802078:	c9                   	leaveq 
  802079:	c3                   	retq   

000000000080207a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80207a:	55                   	push   %rbp
  80207b:	48 89 e5             	mov    %rsp,%rbp
  80207e:	48 83 ec 30          	sub    $0x30,%rsp
  802082:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802085:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802089:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80208d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802094:	eb 49                	jmp    8020df <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802096:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802099:	48 98                	cltq   
  80209b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80209f:	48 29 c2             	sub    %rax,%rdx
  8020a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020a5:	48 63 c8             	movslq %eax,%rcx
  8020a8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020ac:	48 01 c1             	add    %rax,%rcx
  8020af:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020b2:	48 89 ce             	mov    %rcx,%rsi
  8020b5:	89 c7                	mov    %eax,%edi
  8020b7:	48 b8 a5 1f 80 00 00 	movabs $0x801fa5,%rax
  8020be:	00 00 00 
  8020c1:	ff d0                	callq  *%rax
  8020c3:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8020c6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8020ca:	79 05                	jns    8020d1 <readn+0x57>
			return m;
  8020cc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020cf:	eb 1c                	jmp    8020ed <readn+0x73>
		if (m == 0)
  8020d1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8020d5:	75 02                	jne    8020d9 <readn+0x5f>
			break;
  8020d7:	eb 11                	jmp    8020ea <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8020d9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020dc:	01 45 fc             	add    %eax,-0x4(%rbp)
  8020df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020e2:	48 98                	cltq   
  8020e4:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8020e8:	72 ac                	jb     802096 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8020ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8020ed:	c9                   	leaveq 
  8020ee:	c3                   	retq   

00000000008020ef <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8020ef:	55                   	push   %rbp
  8020f0:	48 89 e5             	mov    %rsp,%rbp
  8020f3:	48 83 ec 40          	sub    $0x40,%rsp
  8020f7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8020fa:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8020fe:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802102:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802106:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802109:	48 89 d6             	mov    %rdx,%rsi
  80210c:	89 c7                	mov    %eax,%edi
  80210e:	48 b8 73 1b 80 00 00 	movabs $0x801b73,%rax
  802115:	00 00 00 
  802118:	ff d0                	callq  *%rax
  80211a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80211d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802121:	78 24                	js     802147 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802123:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802127:	8b 00                	mov    (%rax),%eax
  802129:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80212d:	48 89 d6             	mov    %rdx,%rsi
  802130:	89 c7                	mov    %eax,%edi
  802132:	48 b8 cc 1c 80 00 00 	movabs $0x801ccc,%rax
  802139:	00 00 00 
  80213c:	ff d0                	callq  *%rax
  80213e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802141:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802145:	79 05                	jns    80214c <write+0x5d>
		return r;
  802147:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80214a:	eb 75                	jmp    8021c1 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80214c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802150:	8b 40 08             	mov    0x8(%rax),%eax
  802153:	83 e0 03             	and    $0x3,%eax
  802156:	85 c0                	test   %eax,%eax
  802158:	75 3a                	jne    802194 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80215a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802161:	00 00 00 
  802164:	48 8b 00             	mov    (%rax),%rax
  802167:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80216d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802170:	89 c6                	mov    %eax,%esi
  802172:	48 bf 13 44 80 00 00 	movabs $0x804413,%rdi
  802179:	00 00 00 
  80217c:	b8 00 00 00 00       	mov    $0x0,%eax
  802181:	48 b9 72 02 80 00 00 	movabs $0x800272,%rcx
  802188:	00 00 00 
  80218b:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80218d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802192:	eb 2d                	jmp    8021c1 <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  802194:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802198:	48 8b 40 18          	mov    0x18(%rax),%rax
  80219c:	48 85 c0             	test   %rax,%rax
  80219f:	75 07                	jne    8021a8 <write+0xb9>
		return -E_NOT_SUPP;
  8021a1:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8021a6:	eb 19                	jmp    8021c1 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8021a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021ac:	48 8b 40 18          	mov    0x18(%rax),%rax
  8021b0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8021b4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8021b8:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8021bc:	48 89 cf             	mov    %rcx,%rdi
  8021bf:	ff d0                	callq  *%rax
}
  8021c1:	c9                   	leaveq 
  8021c2:	c3                   	retq   

00000000008021c3 <seek>:

int
seek(int fdnum, off_t offset)
{
  8021c3:	55                   	push   %rbp
  8021c4:	48 89 e5             	mov    %rsp,%rbp
  8021c7:	48 83 ec 18          	sub    $0x18,%rsp
  8021cb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8021ce:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021d1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8021d5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021d8:	48 89 d6             	mov    %rdx,%rsi
  8021db:	89 c7                	mov    %eax,%edi
  8021dd:	48 b8 73 1b 80 00 00 	movabs $0x801b73,%rax
  8021e4:	00 00 00 
  8021e7:	ff d0                	callq  *%rax
  8021e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021f0:	79 05                	jns    8021f7 <seek+0x34>
		return r;
  8021f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021f5:	eb 0f                	jmp    802206 <seek+0x43>
	fd->fd_offset = offset;
  8021f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021fb:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8021fe:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802201:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802206:	c9                   	leaveq 
  802207:	c3                   	retq   

0000000000802208 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802208:	55                   	push   %rbp
  802209:	48 89 e5             	mov    %rsp,%rbp
  80220c:	48 83 ec 30          	sub    $0x30,%rsp
  802210:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802213:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802216:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80221a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80221d:	48 89 d6             	mov    %rdx,%rsi
  802220:	89 c7                	mov    %eax,%edi
  802222:	48 b8 73 1b 80 00 00 	movabs $0x801b73,%rax
  802229:	00 00 00 
  80222c:	ff d0                	callq  *%rax
  80222e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802231:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802235:	78 24                	js     80225b <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802237:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80223b:	8b 00                	mov    (%rax),%eax
  80223d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802241:	48 89 d6             	mov    %rdx,%rsi
  802244:	89 c7                	mov    %eax,%edi
  802246:	48 b8 cc 1c 80 00 00 	movabs $0x801ccc,%rax
  80224d:	00 00 00 
  802250:	ff d0                	callq  *%rax
  802252:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802255:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802259:	79 05                	jns    802260 <ftruncate+0x58>
		return r;
  80225b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80225e:	eb 72                	jmp    8022d2 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802260:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802264:	8b 40 08             	mov    0x8(%rax),%eax
  802267:	83 e0 03             	and    $0x3,%eax
  80226a:	85 c0                	test   %eax,%eax
  80226c:	75 3a                	jne    8022a8 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80226e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802275:	00 00 00 
  802278:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80227b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802281:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802284:	89 c6                	mov    %eax,%esi
  802286:	48 bf 30 44 80 00 00 	movabs $0x804430,%rdi
  80228d:	00 00 00 
  802290:	b8 00 00 00 00       	mov    $0x0,%eax
  802295:	48 b9 72 02 80 00 00 	movabs $0x800272,%rcx
  80229c:	00 00 00 
  80229f:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8022a1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022a6:	eb 2a                	jmp    8022d2 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8022a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022ac:	48 8b 40 30          	mov    0x30(%rax),%rax
  8022b0:	48 85 c0             	test   %rax,%rax
  8022b3:	75 07                	jne    8022bc <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8022b5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8022ba:	eb 16                	jmp    8022d2 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8022bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022c0:	48 8b 40 30          	mov    0x30(%rax),%rax
  8022c4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022c8:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8022cb:	89 ce                	mov    %ecx,%esi
  8022cd:	48 89 d7             	mov    %rdx,%rdi
  8022d0:	ff d0                	callq  *%rax
}
  8022d2:	c9                   	leaveq 
  8022d3:	c3                   	retq   

00000000008022d4 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8022d4:	55                   	push   %rbp
  8022d5:	48 89 e5             	mov    %rsp,%rbp
  8022d8:	48 83 ec 30          	sub    $0x30,%rsp
  8022dc:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8022df:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022e3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022e7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022ea:	48 89 d6             	mov    %rdx,%rsi
  8022ed:	89 c7                	mov    %eax,%edi
  8022ef:	48 b8 73 1b 80 00 00 	movabs $0x801b73,%rax
  8022f6:	00 00 00 
  8022f9:	ff d0                	callq  *%rax
  8022fb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802302:	78 24                	js     802328 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802304:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802308:	8b 00                	mov    (%rax),%eax
  80230a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80230e:	48 89 d6             	mov    %rdx,%rsi
  802311:	89 c7                	mov    %eax,%edi
  802313:	48 b8 cc 1c 80 00 00 	movabs $0x801ccc,%rax
  80231a:	00 00 00 
  80231d:	ff d0                	callq  *%rax
  80231f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802322:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802326:	79 05                	jns    80232d <fstat+0x59>
		return r;
  802328:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80232b:	eb 5e                	jmp    80238b <fstat+0xb7>
	if (!dev->dev_stat)
  80232d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802331:	48 8b 40 28          	mov    0x28(%rax),%rax
  802335:	48 85 c0             	test   %rax,%rax
  802338:	75 07                	jne    802341 <fstat+0x6d>
		return -E_NOT_SUPP;
  80233a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80233f:	eb 4a                	jmp    80238b <fstat+0xb7>
	stat->st_name[0] = 0;
  802341:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802345:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802348:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80234c:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802353:	00 00 00 
	stat->st_isdir = 0;
  802356:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80235a:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802361:	00 00 00 
	stat->st_dev = dev;
  802364:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802368:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80236c:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802373:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802377:	48 8b 40 28          	mov    0x28(%rax),%rax
  80237b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80237f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802383:	48 89 ce             	mov    %rcx,%rsi
  802386:	48 89 d7             	mov    %rdx,%rdi
  802389:	ff d0                	callq  *%rax
}
  80238b:	c9                   	leaveq 
  80238c:	c3                   	retq   

000000000080238d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80238d:	55                   	push   %rbp
  80238e:	48 89 e5             	mov    %rsp,%rbp
  802391:	48 83 ec 20          	sub    $0x20,%rsp
  802395:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802399:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80239d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023a1:	be 00 00 00 00       	mov    $0x0,%esi
  8023a6:	48 89 c7             	mov    %rax,%rdi
  8023a9:	48 b8 7b 24 80 00 00 	movabs $0x80247b,%rax
  8023b0:	00 00 00 
  8023b3:	ff d0                	callq  *%rax
  8023b5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023bc:	79 05                	jns    8023c3 <stat+0x36>
		return fd;
  8023be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023c1:	eb 2f                	jmp    8023f2 <stat+0x65>
	r = fstat(fd, stat);
  8023c3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8023c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023ca:	48 89 d6             	mov    %rdx,%rsi
  8023cd:	89 c7                	mov    %eax,%edi
  8023cf:	48 b8 d4 22 80 00 00 	movabs $0x8022d4,%rax
  8023d6:	00 00 00 
  8023d9:	ff d0                	callq  *%rax
  8023db:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8023de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023e1:	89 c7                	mov    %eax,%edi
  8023e3:	48 b8 83 1d 80 00 00 	movabs $0x801d83,%rax
  8023ea:	00 00 00 
  8023ed:	ff d0                	callq  *%rax
	return r;
  8023ef:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8023f2:	c9                   	leaveq 
  8023f3:	c3                   	retq   

00000000008023f4 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8023f4:	55                   	push   %rbp
  8023f5:	48 89 e5             	mov    %rsp,%rbp
  8023f8:	48 83 ec 10          	sub    $0x10,%rsp
  8023fc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8023ff:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802403:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80240a:	00 00 00 
  80240d:	8b 00                	mov    (%rax),%eax
  80240f:	85 c0                	test   %eax,%eax
  802411:	75 1d                	jne    802430 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802413:	bf 01 00 00 00       	mov    $0x1,%edi
  802418:	48 b8 95 3d 80 00 00 	movabs $0x803d95,%rax
  80241f:	00 00 00 
  802422:	ff d0                	callq  *%rax
  802424:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  80242b:	00 00 00 
  80242e:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802430:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802437:	00 00 00 
  80243a:	8b 00                	mov    (%rax),%eax
  80243c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80243f:	b9 07 00 00 00       	mov    $0x7,%ecx
  802444:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  80244b:	00 00 00 
  80244e:	89 c7                	mov    %eax,%edi
  802450:	48 b8 33 3d 80 00 00 	movabs $0x803d33,%rax
  802457:	00 00 00 
  80245a:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80245c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802460:	ba 00 00 00 00       	mov    $0x0,%edx
  802465:	48 89 c6             	mov    %rax,%rsi
  802468:	bf 00 00 00 00       	mov    $0x0,%edi
  80246d:	48 b8 2d 3c 80 00 00 	movabs $0x803c2d,%rax
  802474:	00 00 00 
  802477:	ff d0                	callq  *%rax
}
  802479:	c9                   	leaveq 
  80247a:	c3                   	retq   

000000000080247b <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80247b:	55                   	push   %rbp
  80247c:	48 89 e5             	mov    %rsp,%rbp
  80247f:	48 83 ec 30          	sub    $0x30,%rsp
  802483:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802487:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  80248a:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802491:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802498:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  80249f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8024a4:	75 08                	jne    8024ae <open+0x33>
	{
		return r;
  8024a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024a9:	e9 f2 00 00 00       	jmpq   8025a0 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  8024ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024b2:	48 89 c7             	mov    %rax,%rdi
  8024b5:	48 b8 bb 0d 80 00 00 	movabs $0x800dbb,%rax
  8024bc:	00 00 00 
  8024bf:	ff d0                	callq  *%rax
  8024c1:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8024c4:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  8024cb:	7e 0a                	jle    8024d7 <open+0x5c>
	{
		return -E_BAD_PATH;
  8024cd:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8024d2:	e9 c9 00 00 00       	jmpq   8025a0 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  8024d7:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8024de:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  8024df:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8024e3:	48 89 c7             	mov    %rax,%rdi
  8024e6:	48 b8 db 1a 80 00 00 	movabs $0x801adb,%rax
  8024ed:	00 00 00 
  8024f0:	ff d0                	callq  *%rax
  8024f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024f9:	78 09                	js     802504 <open+0x89>
  8024fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024ff:	48 85 c0             	test   %rax,%rax
  802502:	75 08                	jne    80250c <open+0x91>
		{
			return r;
  802504:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802507:	e9 94 00 00 00       	jmpq   8025a0 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  80250c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802510:	ba 00 04 00 00       	mov    $0x400,%edx
  802515:	48 89 c6             	mov    %rax,%rsi
  802518:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80251f:	00 00 00 
  802522:	48 b8 b9 0e 80 00 00 	movabs $0x800eb9,%rax
  802529:	00 00 00 
  80252c:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  80252e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802535:	00 00 00 
  802538:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  80253b:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802541:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802545:	48 89 c6             	mov    %rax,%rsi
  802548:	bf 01 00 00 00       	mov    $0x1,%edi
  80254d:	48 b8 f4 23 80 00 00 	movabs $0x8023f4,%rax
  802554:	00 00 00 
  802557:	ff d0                	callq  *%rax
  802559:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80255c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802560:	79 2b                	jns    80258d <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802562:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802566:	be 00 00 00 00       	mov    $0x0,%esi
  80256b:	48 89 c7             	mov    %rax,%rdi
  80256e:	48 b8 03 1c 80 00 00 	movabs $0x801c03,%rax
  802575:	00 00 00 
  802578:	ff d0                	callq  *%rax
  80257a:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80257d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802581:	79 05                	jns    802588 <open+0x10d>
			{
				return d;
  802583:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802586:	eb 18                	jmp    8025a0 <open+0x125>
			}
			return r;
  802588:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80258b:	eb 13                	jmp    8025a0 <open+0x125>
		}	
		return fd2num(fd_store);
  80258d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802591:	48 89 c7             	mov    %rax,%rdi
  802594:	48 b8 8d 1a 80 00 00 	movabs $0x801a8d,%rax
  80259b:	00 00 00 
  80259e:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  8025a0:	c9                   	leaveq 
  8025a1:	c3                   	retq   

00000000008025a2 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8025a2:	55                   	push   %rbp
  8025a3:	48 89 e5             	mov    %rsp,%rbp
  8025a6:	48 83 ec 10          	sub    $0x10,%rsp
  8025aa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8025ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025b2:	8b 50 0c             	mov    0xc(%rax),%edx
  8025b5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8025bc:	00 00 00 
  8025bf:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8025c1:	be 00 00 00 00       	mov    $0x0,%esi
  8025c6:	bf 06 00 00 00       	mov    $0x6,%edi
  8025cb:	48 b8 f4 23 80 00 00 	movabs $0x8023f4,%rax
  8025d2:	00 00 00 
  8025d5:	ff d0                	callq  *%rax
}
  8025d7:	c9                   	leaveq 
  8025d8:	c3                   	retq   

00000000008025d9 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8025d9:	55                   	push   %rbp
  8025da:	48 89 e5             	mov    %rsp,%rbp
  8025dd:	48 83 ec 30          	sub    $0x30,%rsp
  8025e1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8025e5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8025e9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  8025ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  8025f4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8025f9:	74 07                	je     802602 <devfile_read+0x29>
  8025fb:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802600:	75 07                	jne    802609 <devfile_read+0x30>
		return -E_INVAL;
  802602:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802607:	eb 77                	jmp    802680 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802609:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80260d:	8b 50 0c             	mov    0xc(%rax),%edx
  802610:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802617:	00 00 00 
  80261a:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80261c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802623:	00 00 00 
  802626:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80262a:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  80262e:	be 00 00 00 00       	mov    $0x0,%esi
  802633:	bf 03 00 00 00       	mov    $0x3,%edi
  802638:	48 b8 f4 23 80 00 00 	movabs $0x8023f4,%rax
  80263f:	00 00 00 
  802642:	ff d0                	callq  *%rax
  802644:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802647:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80264b:	7f 05                	jg     802652 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  80264d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802650:	eb 2e                	jmp    802680 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802652:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802655:	48 63 d0             	movslq %eax,%rdx
  802658:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80265c:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802663:	00 00 00 
  802666:	48 89 c7             	mov    %rax,%rdi
  802669:	48 b8 4b 11 80 00 00 	movabs $0x80114b,%rax
  802670:	00 00 00 
  802673:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802675:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802679:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  80267d:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802680:	c9                   	leaveq 
  802681:	c3                   	retq   

0000000000802682 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802682:	55                   	push   %rbp
  802683:	48 89 e5             	mov    %rsp,%rbp
  802686:	48 83 ec 30          	sub    $0x30,%rsp
  80268a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80268e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802692:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802696:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  80269d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8026a2:	74 07                	je     8026ab <devfile_write+0x29>
  8026a4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8026a9:	75 08                	jne    8026b3 <devfile_write+0x31>
		return r;
  8026ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026ae:	e9 9a 00 00 00       	jmpq   80274d <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8026b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026b7:	8b 50 0c             	mov    0xc(%rax),%edx
  8026ba:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8026c1:	00 00 00 
  8026c4:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  8026c6:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8026cd:	00 
  8026ce:	76 08                	jbe    8026d8 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  8026d0:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8026d7:	00 
	}
	fsipcbuf.write.req_n = n;
  8026d8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8026df:	00 00 00 
  8026e2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8026e6:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  8026ea:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8026ee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026f2:	48 89 c6             	mov    %rax,%rsi
  8026f5:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  8026fc:	00 00 00 
  8026ff:	48 b8 4b 11 80 00 00 	movabs $0x80114b,%rax
  802706:	00 00 00 
  802709:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  80270b:	be 00 00 00 00       	mov    $0x0,%esi
  802710:	bf 04 00 00 00       	mov    $0x4,%edi
  802715:	48 b8 f4 23 80 00 00 	movabs $0x8023f4,%rax
  80271c:	00 00 00 
  80271f:	ff d0                	callq  *%rax
  802721:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802724:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802728:	7f 20                	jg     80274a <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  80272a:	48 bf 56 44 80 00 00 	movabs $0x804456,%rdi
  802731:	00 00 00 
  802734:	b8 00 00 00 00       	mov    $0x0,%eax
  802739:	48 ba 72 02 80 00 00 	movabs $0x800272,%rdx
  802740:	00 00 00 
  802743:	ff d2                	callq  *%rdx
		return r;
  802745:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802748:	eb 03                	jmp    80274d <devfile_write+0xcb>
	}
	return r;
  80274a:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  80274d:	c9                   	leaveq 
  80274e:	c3                   	retq   

000000000080274f <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80274f:	55                   	push   %rbp
  802750:	48 89 e5             	mov    %rsp,%rbp
  802753:	48 83 ec 20          	sub    $0x20,%rsp
  802757:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80275b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80275f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802763:	8b 50 0c             	mov    0xc(%rax),%edx
  802766:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80276d:	00 00 00 
  802770:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802772:	be 00 00 00 00       	mov    $0x0,%esi
  802777:	bf 05 00 00 00       	mov    $0x5,%edi
  80277c:	48 b8 f4 23 80 00 00 	movabs $0x8023f4,%rax
  802783:	00 00 00 
  802786:	ff d0                	callq  *%rax
  802788:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80278b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80278f:	79 05                	jns    802796 <devfile_stat+0x47>
		return r;
  802791:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802794:	eb 56                	jmp    8027ec <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802796:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80279a:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8027a1:	00 00 00 
  8027a4:	48 89 c7             	mov    %rax,%rdi
  8027a7:	48 b8 27 0e 80 00 00 	movabs $0x800e27,%rax
  8027ae:	00 00 00 
  8027b1:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8027b3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027ba:	00 00 00 
  8027bd:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8027c3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027c7:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8027cd:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027d4:	00 00 00 
  8027d7:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8027dd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027e1:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8027e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027ec:	c9                   	leaveq 
  8027ed:	c3                   	retq   

00000000008027ee <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8027ee:	55                   	push   %rbp
  8027ef:	48 89 e5             	mov    %rsp,%rbp
  8027f2:	48 83 ec 10          	sub    $0x10,%rsp
  8027f6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8027fa:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8027fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802801:	8b 50 0c             	mov    0xc(%rax),%edx
  802804:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80280b:	00 00 00 
  80280e:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802810:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802817:	00 00 00 
  80281a:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80281d:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802820:	be 00 00 00 00       	mov    $0x0,%esi
  802825:	bf 02 00 00 00       	mov    $0x2,%edi
  80282a:	48 b8 f4 23 80 00 00 	movabs $0x8023f4,%rax
  802831:	00 00 00 
  802834:	ff d0                	callq  *%rax
}
  802836:	c9                   	leaveq 
  802837:	c3                   	retq   

0000000000802838 <remove>:

// Delete a file
int
remove(const char *path)
{
  802838:	55                   	push   %rbp
  802839:	48 89 e5             	mov    %rsp,%rbp
  80283c:	48 83 ec 10          	sub    $0x10,%rsp
  802840:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802844:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802848:	48 89 c7             	mov    %rax,%rdi
  80284b:	48 b8 bb 0d 80 00 00 	movabs $0x800dbb,%rax
  802852:	00 00 00 
  802855:	ff d0                	callq  *%rax
  802857:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80285c:	7e 07                	jle    802865 <remove+0x2d>
		return -E_BAD_PATH;
  80285e:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802863:	eb 33                	jmp    802898 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802865:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802869:	48 89 c6             	mov    %rax,%rsi
  80286c:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802873:	00 00 00 
  802876:	48 b8 27 0e 80 00 00 	movabs $0x800e27,%rax
  80287d:	00 00 00 
  802880:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802882:	be 00 00 00 00       	mov    $0x0,%esi
  802887:	bf 07 00 00 00       	mov    $0x7,%edi
  80288c:	48 b8 f4 23 80 00 00 	movabs $0x8023f4,%rax
  802893:	00 00 00 
  802896:	ff d0                	callq  *%rax
}
  802898:	c9                   	leaveq 
  802899:	c3                   	retq   

000000000080289a <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80289a:	55                   	push   %rbp
  80289b:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80289e:	be 00 00 00 00       	mov    $0x0,%esi
  8028a3:	bf 08 00 00 00       	mov    $0x8,%edi
  8028a8:	48 b8 f4 23 80 00 00 	movabs $0x8023f4,%rax
  8028af:	00 00 00 
  8028b2:	ff d0                	callq  *%rax
}
  8028b4:	5d                   	pop    %rbp
  8028b5:	c3                   	retq   

00000000008028b6 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8028b6:	55                   	push   %rbp
  8028b7:	48 89 e5             	mov    %rsp,%rbp
  8028ba:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8028c1:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8028c8:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8028cf:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8028d6:	be 00 00 00 00       	mov    $0x0,%esi
  8028db:	48 89 c7             	mov    %rax,%rdi
  8028de:	48 b8 7b 24 80 00 00 	movabs $0x80247b,%rax
  8028e5:	00 00 00 
  8028e8:	ff d0                	callq  *%rax
  8028ea:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8028ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028f1:	79 28                	jns    80291b <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8028f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028f6:	89 c6                	mov    %eax,%esi
  8028f8:	48 bf 72 44 80 00 00 	movabs $0x804472,%rdi
  8028ff:	00 00 00 
  802902:	b8 00 00 00 00       	mov    $0x0,%eax
  802907:	48 ba 72 02 80 00 00 	movabs $0x800272,%rdx
  80290e:	00 00 00 
  802911:	ff d2                	callq  *%rdx
		return fd_src;
  802913:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802916:	e9 74 01 00 00       	jmpq   802a8f <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80291b:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802922:	be 01 01 00 00       	mov    $0x101,%esi
  802927:	48 89 c7             	mov    %rax,%rdi
  80292a:	48 b8 7b 24 80 00 00 	movabs $0x80247b,%rax
  802931:	00 00 00 
  802934:	ff d0                	callq  *%rax
  802936:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802939:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80293d:	79 39                	jns    802978 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80293f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802942:	89 c6                	mov    %eax,%esi
  802944:	48 bf 88 44 80 00 00 	movabs $0x804488,%rdi
  80294b:	00 00 00 
  80294e:	b8 00 00 00 00       	mov    $0x0,%eax
  802953:	48 ba 72 02 80 00 00 	movabs $0x800272,%rdx
  80295a:	00 00 00 
  80295d:	ff d2                	callq  *%rdx
		close(fd_src);
  80295f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802962:	89 c7                	mov    %eax,%edi
  802964:	48 b8 83 1d 80 00 00 	movabs $0x801d83,%rax
  80296b:	00 00 00 
  80296e:	ff d0                	callq  *%rax
		return fd_dest;
  802970:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802973:	e9 17 01 00 00       	jmpq   802a8f <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802978:	eb 74                	jmp    8029ee <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  80297a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80297d:	48 63 d0             	movslq %eax,%rdx
  802980:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802987:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80298a:	48 89 ce             	mov    %rcx,%rsi
  80298d:	89 c7                	mov    %eax,%edi
  80298f:	48 b8 ef 20 80 00 00 	movabs $0x8020ef,%rax
  802996:	00 00 00 
  802999:	ff d0                	callq  *%rax
  80299b:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  80299e:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8029a2:	79 4a                	jns    8029ee <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8029a4:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8029a7:	89 c6                	mov    %eax,%esi
  8029a9:	48 bf a2 44 80 00 00 	movabs $0x8044a2,%rdi
  8029b0:	00 00 00 
  8029b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b8:	48 ba 72 02 80 00 00 	movabs $0x800272,%rdx
  8029bf:	00 00 00 
  8029c2:	ff d2                	callq  *%rdx
			close(fd_src);
  8029c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029c7:	89 c7                	mov    %eax,%edi
  8029c9:	48 b8 83 1d 80 00 00 	movabs $0x801d83,%rax
  8029d0:	00 00 00 
  8029d3:	ff d0                	callq  *%rax
			close(fd_dest);
  8029d5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8029d8:	89 c7                	mov    %eax,%edi
  8029da:	48 b8 83 1d 80 00 00 	movabs $0x801d83,%rax
  8029e1:	00 00 00 
  8029e4:	ff d0                	callq  *%rax
			return write_size;
  8029e6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8029e9:	e9 a1 00 00 00       	jmpq   802a8f <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8029ee:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8029f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029f8:	ba 00 02 00 00       	mov    $0x200,%edx
  8029fd:	48 89 ce             	mov    %rcx,%rsi
  802a00:	89 c7                	mov    %eax,%edi
  802a02:	48 b8 a5 1f 80 00 00 	movabs $0x801fa5,%rax
  802a09:	00 00 00 
  802a0c:	ff d0                	callq  *%rax
  802a0e:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802a11:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802a15:	0f 8f 5f ff ff ff    	jg     80297a <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802a1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802a1f:	79 47                	jns    802a68 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802a21:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802a24:	89 c6                	mov    %eax,%esi
  802a26:	48 bf b5 44 80 00 00 	movabs $0x8044b5,%rdi
  802a2d:	00 00 00 
  802a30:	b8 00 00 00 00       	mov    $0x0,%eax
  802a35:	48 ba 72 02 80 00 00 	movabs $0x800272,%rdx
  802a3c:	00 00 00 
  802a3f:	ff d2                	callq  *%rdx
		close(fd_src);
  802a41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a44:	89 c7                	mov    %eax,%edi
  802a46:	48 b8 83 1d 80 00 00 	movabs $0x801d83,%rax
  802a4d:	00 00 00 
  802a50:	ff d0                	callq  *%rax
		close(fd_dest);
  802a52:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a55:	89 c7                	mov    %eax,%edi
  802a57:	48 b8 83 1d 80 00 00 	movabs $0x801d83,%rax
  802a5e:	00 00 00 
  802a61:	ff d0                	callq  *%rax
		return read_size;
  802a63:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802a66:	eb 27                	jmp    802a8f <copy+0x1d9>
	}
	close(fd_src);
  802a68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a6b:	89 c7                	mov    %eax,%edi
  802a6d:	48 b8 83 1d 80 00 00 	movabs $0x801d83,%rax
  802a74:	00 00 00 
  802a77:	ff d0                	callq  *%rax
	close(fd_dest);
  802a79:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a7c:	89 c7                	mov    %eax,%edi
  802a7e:	48 b8 83 1d 80 00 00 	movabs $0x801d83,%rax
  802a85:	00 00 00 
  802a88:	ff d0                	callq  *%rax
	return 0;
  802a8a:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802a8f:	c9                   	leaveq 
  802a90:	c3                   	retq   

0000000000802a91 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802a91:	55                   	push   %rbp
  802a92:	48 89 e5             	mov    %rsp,%rbp
  802a95:	48 83 ec 20          	sub    $0x20,%rsp
  802a99:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802a9c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802aa0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802aa3:	48 89 d6             	mov    %rdx,%rsi
  802aa6:	89 c7                	mov    %eax,%edi
  802aa8:	48 b8 73 1b 80 00 00 	movabs $0x801b73,%rax
  802aaf:	00 00 00 
  802ab2:	ff d0                	callq  *%rax
  802ab4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ab7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802abb:	79 05                	jns    802ac2 <fd2sockid+0x31>
		return r;
  802abd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ac0:	eb 24                	jmp    802ae6 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802ac2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ac6:	8b 10                	mov    (%rax),%edx
  802ac8:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802acf:	00 00 00 
  802ad2:	8b 00                	mov    (%rax),%eax
  802ad4:	39 c2                	cmp    %eax,%edx
  802ad6:	74 07                	je     802adf <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802ad8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802add:	eb 07                	jmp    802ae6 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802adf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ae3:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802ae6:	c9                   	leaveq 
  802ae7:	c3                   	retq   

0000000000802ae8 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802ae8:	55                   	push   %rbp
  802ae9:	48 89 e5             	mov    %rsp,%rbp
  802aec:	48 83 ec 20          	sub    $0x20,%rsp
  802af0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802af3:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802af7:	48 89 c7             	mov    %rax,%rdi
  802afa:	48 b8 db 1a 80 00 00 	movabs $0x801adb,%rax
  802b01:	00 00 00 
  802b04:	ff d0                	callq  *%rax
  802b06:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b09:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b0d:	78 26                	js     802b35 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802b0f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b13:	ba 07 04 00 00       	mov    $0x407,%edx
  802b18:	48 89 c6             	mov    %rax,%rsi
  802b1b:	bf 00 00 00 00       	mov    $0x0,%edi
  802b20:	48 b8 56 17 80 00 00 	movabs $0x801756,%rax
  802b27:	00 00 00 
  802b2a:	ff d0                	callq  *%rax
  802b2c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b2f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b33:	79 16                	jns    802b4b <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802b35:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b38:	89 c7                	mov    %eax,%edi
  802b3a:	48 b8 f5 2f 80 00 00 	movabs $0x802ff5,%rax
  802b41:	00 00 00 
  802b44:	ff d0                	callq  *%rax
		return r;
  802b46:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b49:	eb 3a                	jmp    802b85 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802b4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b4f:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802b56:	00 00 00 
  802b59:	8b 12                	mov    (%rdx),%edx
  802b5b:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802b5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b61:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802b68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b6c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802b6f:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802b72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b76:	48 89 c7             	mov    %rax,%rdi
  802b79:	48 b8 8d 1a 80 00 00 	movabs $0x801a8d,%rax
  802b80:	00 00 00 
  802b83:	ff d0                	callq  *%rax
}
  802b85:	c9                   	leaveq 
  802b86:	c3                   	retq   

0000000000802b87 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802b87:	55                   	push   %rbp
  802b88:	48 89 e5             	mov    %rsp,%rbp
  802b8b:	48 83 ec 30          	sub    $0x30,%rsp
  802b8f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b92:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802b96:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802b9a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b9d:	89 c7                	mov    %eax,%edi
  802b9f:	48 b8 91 2a 80 00 00 	movabs $0x802a91,%rax
  802ba6:	00 00 00 
  802ba9:	ff d0                	callq  *%rax
  802bab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bb2:	79 05                	jns    802bb9 <accept+0x32>
		return r;
  802bb4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bb7:	eb 3b                	jmp    802bf4 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802bb9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802bbd:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802bc1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bc4:	48 89 ce             	mov    %rcx,%rsi
  802bc7:	89 c7                	mov    %eax,%edi
  802bc9:	48 b8 d2 2e 80 00 00 	movabs $0x802ed2,%rax
  802bd0:	00 00 00 
  802bd3:	ff d0                	callq  *%rax
  802bd5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bd8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bdc:	79 05                	jns    802be3 <accept+0x5c>
		return r;
  802bde:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802be1:	eb 11                	jmp    802bf4 <accept+0x6d>
	return alloc_sockfd(r);
  802be3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802be6:	89 c7                	mov    %eax,%edi
  802be8:	48 b8 e8 2a 80 00 00 	movabs $0x802ae8,%rax
  802bef:	00 00 00 
  802bf2:	ff d0                	callq  *%rax
}
  802bf4:	c9                   	leaveq 
  802bf5:	c3                   	retq   

0000000000802bf6 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802bf6:	55                   	push   %rbp
  802bf7:	48 89 e5             	mov    %rsp,%rbp
  802bfa:	48 83 ec 20          	sub    $0x20,%rsp
  802bfe:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c01:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c05:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802c08:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c0b:	89 c7                	mov    %eax,%edi
  802c0d:	48 b8 91 2a 80 00 00 	movabs $0x802a91,%rax
  802c14:	00 00 00 
  802c17:	ff d0                	callq  *%rax
  802c19:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c1c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c20:	79 05                	jns    802c27 <bind+0x31>
		return r;
  802c22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c25:	eb 1b                	jmp    802c42 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802c27:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802c2a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802c2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c31:	48 89 ce             	mov    %rcx,%rsi
  802c34:	89 c7                	mov    %eax,%edi
  802c36:	48 b8 51 2f 80 00 00 	movabs $0x802f51,%rax
  802c3d:	00 00 00 
  802c40:	ff d0                	callq  *%rax
}
  802c42:	c9                   	leaveq 
  802c43:	c3                   	retq   

0000000000802c44 <shutdown>:

int
shutdown(int s, int how)
{
  802c44:	55                   	push   %rbp
  802c45:	48 89 e5             	mov    %rsp,%rbp
  802c48:	48 83 ec 20          	sub    $0x20,%rsp
  802c4c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c4f:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802c52:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c55:	89 c7                	mov    %eax,%edi
  802c57:	48 b8 91 2a 80 00 00 	movabs $0x802a91,%rax
  802c5e:	00 00 00 
  802c61:	ff d0                	callq  *%rax
  802c63:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c66:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c6a:	79 05                	jns    802c71 <shutdown+0x2d>
		return r;
  802c6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c6f:	eb 16                	jmp    802c87 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802c71:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802c74:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c77:	89 d6                	mov    %edx,%esi
  802c79:	89 c7                	mov    %eax,%edi
  802c7b:	48 b8 b5 2f 80 00 00 	movabs $0x802fb5,%rax
  802c82:	00 00 00 
  802c85:	ff d0                	callq  *%rax
}
  802c87:	c9                   	leaveq 
  802c88:	c3                   	retq   

0000000000802c89 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  802c89:	55                   	push   %rbp
  802c8a:	48 89 e5             	mov    %rsp,%rbp
  802c8d:	48 83 ec 10          	sub    $0x10,%rsp
  802c91:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  802c95:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c99:	48 89 c7             	mov    %rax,%rdi
  802c9c:	48 b8 17 3e 80 00 00 	movabs $0x803e17,%rax
  802ca3:	00 00 00 
  802ca6:	ff d0                	callq  *%rax
  802ca8:	83 f8 01             	cmp    $0x1,%eax
  802cab:	75 17                	jne    802cc4 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  802cad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cb1:	8b 40 0c             	mov    0xc(%rax),%eax
  802cb4:	89 c7                	mov    %eax,%edi
  802cb6:	48 b8 f5 2f 80 00 00 	movabs $0x802ff5,%rax
  802cbd:	00 00 00 
  802cc0:	ff d0                	callq  *%rax
  802cc2:	eb 05                	jmp    802cc9 <devsock_close+0x40>
	else
		return 0;
  802cc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cc9:	c9                   	leaveq 
  802cca:	c3                   	retq   

0000000000802ccb <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802ccb:	55                   	push   %rbp
  802ccc:	48 89 e5             	mov    %rsp,%rbp
  802ccf:	48 83 ec 20          	sub    $0x20,%rsp
  802cd3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802cd6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802cda:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802cdd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ce0:	89 c7                	mov    %eax,%edi
  802ce2:	48 b8 91 2a 80 00 00 	movabs $0x802a91,%rax
  802ce9:	00 00 00 
  802cec:	ff d0                	callq  *%rax
  802cee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cf1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cf5:	79 05                	jns    802cfc <connect+0x31>
		return r;
  802cf7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cfa:	eb 1b                	jmp    802d17 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  802cfc:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802cff:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802d03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d06:	48 89 ce             	mov    %rcx,%rsi
  802d09:	89 c7                	mov    %eax,%edi
  802d0b:	48 b8 22 30 80 00 00 	movabs $0x803022,%rax
  802d12:	00 00 00 
  802d15:	ff d0                	callq  *%rax
}
  802d17:	c9                   	leaveq 
  802d18:	c3                   	retq   

0000000000802d19 <listen>:

int
listen(int s, int backlog)
{
  802d19:	55                   	push   %rbp
  802d1a:	48 89 e5             	mov    %rsp,%rbp
  802d1d:	48 83 ec 20          	sub    $0x20,%rsp
  802d21:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d24:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802d27:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d2a:	89 c7                	mov    %eax,%edi
  802d2c:	48 b8 91 2a 80 00 00 	movabs $0x802a91,%rax
  802d33:	00 00 00 
  802d36:	ff d0                	callq  *%rax
  802d38:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d3b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d3f:	79 05                	jns    802d46 <listen+0x2d>
		return r;
  802d41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d44:	eb 16                	jmp    802d5c <listen+0x43>
	return nsipc_listen(r, backlog);
  802d46:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802d49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d4c:	89 d6                	mov    %edx,%esi
  802d4e:	89 c7                	mov    %eax,%edi
  802d50:	48 b8 86 30 80 00 00 	movabs $0x803086,%rax
  802d57:	00 00 00 
  802d5a:	ff d0                	callq  *%rax
}
  802d5c:	c9                   	leaveq 
  802d5d:	c3                   	retq   

0000000000802d5e <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802d5e:	55                   	push   %rbp
  802d5f:	48 89 e5             	mov    %rsp,%rbp
  802d62:	48 83 ec 20          	sub    $0x20,%rsp
  802d66:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802d6a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802d6e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802d72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d76:	89 c2                	mov    %eax,%edx
  802d78:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d7c:	8b 40 0c             	mov    0xc(%rax),%eax
  802d7f:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802d83:	b9 00 00 00 00       	mov    $0x0,%ecx
  802d88:	89 c7                	mov    %eax,%edi
  802d8a:	48 b8 c6 30 80 00 00 	movabs $0x8030c6,%rax
  802d91:	00 00 00 
  802d94:	ff d0                	callq  *%rax
}
  802d96:	c9                   	leaveq 
  802d97:	c3                   	retq   

0000000000802d98 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802d98:	55                   	push   %rbp
  802d99:	48 89 e5             	mov    %rsp,%rbp
  802d9c:	48 83 ec 20          	sub    $0x20,%rsp
  802da0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802da4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802da8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802dac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802db0:	89 c2                	mov    %eax,%edx
  802db2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802db6:	8b 40 0c             	mov    0xc(%rax),%eax
  802db9:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802dbd:	b9 00 00 00 00       	mov    $0x0,%ecx
  802dc2:	89 c7                	mov    %eax,%edi
  802dc4:	48 b8 92 31 80 00 00 	movabs $0x803192,%rax
  802dcb:	00 00 00 
  802dce:	ff d0                	callq  *%rax
}
  802dd0:	c9                   	leaveq 
  802dd1:	c3                   	retq   

0000000000802dd2 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802dd2:	55                   	push   %rbp
  802dd3:	48 89 e5             	mov    %rsp,%rbp
  802dd6:	48 83 ec 10          	sub    $0x10,%rsp
  802dda:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802dde:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  802de2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802de6:	48 be d0 44 80 00 00 	movabs $0x8044d0,%rsi
  802ded:	00 00 00 
  802df0:	48 89 c7             	mov    %rax,%rdi
  802df3:	48 b8 27 0e 80 00 00 	movabs $0x800e27,%rax
  802dfa:	00 00 00 
  802dfd:	ff d0                	callq  *%rax
	return 0;
  802dff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e04:	c9                   	leaveq 
  802e05:	c3                   	retq   

0000000000802e06 <socket>:

int
socket(int domain, int type, int protocol)
{
  802e06:	55                   	push   %rbp
  802e07:	48 89 e5             	mov    %rsp,%rbp
  802e0a:	48 83 ec 20          	sub    $0x20,%rsp
  802e0e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e11:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802e14:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802e17:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802e1a:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802e1d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e20:	89 ce                	mov    %ecx,%esi
  802e22:	89 c7                	mov    %eax,%edi
  802e24:	48 b8 4a 32 80 00 00 	movabs $0x80324a,%rax
  802e2b:	00 00 00 
  802e2e:	ff d0                	callq  *%rax
  802e30:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e33:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e37:	79 05                	jns    802e3e <socket+0x38>
		return r;
  802e39:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e3c:	eb 11                	jmp    802e4f <socket+0x49>
	return alloc_sockfd(r);
  802e3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e41:	89 c7                	mov    %eax,%edi
  802e43:	48 b8 e8 2a 80 00 00 	movabs $0x802ae8,%rax
  802e4a:	00 00 00 
  802e4d:	ff d0                	callq  *%rax
}
  802e4f:	c9                   	leaveq 
  802e50:	c3                   	retq   

0000000000802e51 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802e51:	55                   	push   %rbp
  802e52:	48 89 e5             	mov    %rsp,%rbp
  802e55:	48 83 ec 10          	sub    $0x10,%rsp
  802e59:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  802e5c:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802e63:	00 00 00 
  802e66:	8b 00                	mov    (%rax),%eax
  802e68:	85 c0                	test   %eax,%eax
  802e6a:	75 1d                	jne    802e89 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802e6c:	bf 02 00 00 00       	mov    $0x2,%edi
  802e71:	48 b8 95 3d 80 00 00 	movabs $0x803d95,%rax
  802e78:	00 00 00 
  802e7b:	ff d0                	callq  *%rax
  802e7d:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  802e84:	00 00 00 
  802e87:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802e89:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802e90:	00 00 00 
  802e93:	8b 00                	mov    (%rax),%eax
  802e95:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802e98:	b9 07 00 00 00       	mov    $0x7,%ecx
  802e9d:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  802ea4:	00 00 00 
  802ea7:	89 c7                	mov    %eax,%edi
  802ea9:	48 b8 33 3d 80 00 00 	movabs $0x803d33,%rax
  802eb0:	00 00 00 
  802eb3:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  802eb5:	ba 00 00 00 00       	mov    $0x0,%edx
  802eba:	be 00 00 00 00       	mov    $0x0,%esi
  802ebf:	bf 00 00 00 00       	mov    $0x0,%edi
  802ec4:	48 b8 2d 3c 80 00 00 	movabs $0x803c2d,%rax
  802ecb:	00 00 00 
  802ece:	ff d0                	callq  *%rax
}
  802ed0:	c9                   	leaveq 
  802ed1:	c3                   	retq   

0000000000802ed2 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802ed2:	55                   	push   %rbp
  802ed3:	48 89 e5             	mov    %rsp,%rbp
  802ed6:	48 83 ec 30          	sub    $0x30,%rsp
  802eda:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802edd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ee1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  802ee5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802eec:	00 00 00 
  802eef:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802ef2:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802ef4:	bf 01 00 00 00       	mov    $0x1,%edi
  802ef9:	48 b8 51 2e 80 00 00 	movabs $0x802e51,%rax
  802f00:	00 00 00 
  802f03:	ff d0                	callq  *%rax
  802f05:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f08:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f0c:	78 3e                	js     802f4c <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  802f0e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f15:	00 00 00 
  802f18:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802f1c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f20:	8b 40 10             	mov    0x10(%rax),%eax
  802f23:	89 c2                	mov    %eax,%edx
  802f25:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802f29:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f2d:	48 89 ce             	mov    %rcx,%rsi
  802f30:	48 89 c7             	mov    %rax,%rdi
  802f33:	48 b8 4b 11 80 00 00 	movabs $0x80114b,%rax
  802f3a:	00 00 00 
  802f3d:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  802f3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f43:	8b 50 10             	mov    0x10(%rax),%edx
  802f46:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f4a:	89 10                	mov    %edx,(%rax)
	}
	return r;
  802f4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802f4f:	c9                   	leaveq 
  802f50:	c3                   	retq   

0000000000802f51 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802f51:	55                   	push   %rbp
  802f52:	48 89 e5             	mov    %rsp,%rbp
  802f55:	48 83 ec 10          	sub    $0x10,%rsp
  802f59:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802f5c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802f60:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  802f63:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f6a:	00 00 00 
  802f6d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802f70:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802f72:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802f75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f79:	48 89 c6             	mov    %rax,%rsi
  802f7c:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  802f83:	00 00 00 
  802f86:	48 b8 4b 11 80 00 00 	movabs $0x80114b,%rax
  802f8d:	00 00 00 
  802f90:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  802f92:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f99:	00 00 00 
  802f9c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802f9f:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  802fa2:	bf 02 00 00 00       	mov    $0x2,%edi
  802fa7:	48 b8 51 2e 80 00 00 	movabs $0x802e51,%rax
  802fae:	00 00 00 
  802fb1:	ff d0                	callq  *%rax
}
  802fb3:	c9                   	leaveq 
  802fb4:	c3                   	retq   

0000000000802fb5 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802fb5:	55                   	push   %rbp
  802fb6:	48 89 e5             	mov    %rsp,%rbp
  802fb9:	48 83 ec 10          	sub    $0x10,%rsp
  802fbd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802fc0:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  802fc3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802fca:	00 00 00 
  802fcd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802fd0:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  802fd2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802fd9:	00 00 00 
  802fdc:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802fdf:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  802fe2:	bf 03 00 00 00       	mov    $0x3,%edi
  802fe7:	48 b8 51 2e 80 00 00 	movabs $0x802e51,%rax
  802fee:	00 00 00 
  802ff1:	ff d0                	callq  *%rax
}
  802ff3:	c9                   	leaveq 
  802ff4:	c3                   	retq   

0000000000802ff5 <nsipc_close>:

int
nsipc_close(int s)
{
  802ff5:	55                   	push   %rbp
  802ff6:	48 89 e5             	mov    %rsp,%rbp
  802ff9:	48 83 ec 10          	sub    $0x10,%rsp
  802ffd:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803000:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803007:	00 00 00 
  80300a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80300d:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  80300f:	bf 04 00 00 00       	mov    $0x4,%edi
  803014:	48 b8 51 2e 80 00 00 	movabs $0x802e51,%rax
  80301b:	00 00 00 
  80301e:	ff d0                	callq  *%rax
}
  803020:	c9                   	leaveq 
  803021:	c3                   	retq   

0000000000803022 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803022:	55                   	push   %rbp
  803023:	48 89 e5             	mov    %rsp,%rbp
  803026:	48 83 ec 10          	sub    $0x10,%rsp
  80302a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80302d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803031:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803034:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80303b:	00 00 00 
  80303e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803041:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803043:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803046:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80304a:	48 89 c6             	mov    %rax,%rsi
  80304d:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803054:	00 00 00 
  803057:	48 b8 4b 11 80 00 00 	movabs $0x80114b,%rax
  80305e:	00 00 00 
  803061:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803063:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80306a:	00 00 00 
  80306d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803070:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803073:	bf 05 00 00 00       	mov    $0x5,%edi
  803078:	48 b8 51 2e 80 00 00 	movabs $0x802e51,%rax
  80307f:	00 00 00 
  803082:	ff d0                	callq  *%rax
}
  803084:	c9                   	leaveq 
  803085:	c3                   	retq   

0000000000803086 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803086:	55                   	push   %rbp
  803087:	48 89 e5             	mov    %rsp,%rbp
  80308a:	48 83 ec 10          	sub    $0x10,%rsp
  80308e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803091:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803094:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80309b:	00 00 00 
  80309e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8030a1:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8030a3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8030aa:	00 00 00 
  8030ad:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8030b0:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8030b3:	bf 06 00 00 00       	mov    $0x6,%edi
  8030b8:	48 b8 51 2e 80 00 00 	movabs $0x802e51,%rax
  8030bf:	00 00 00 
  8030c2:	ff d0                	callq  *%rax
}
  8030c4:	c9                   	leaveq 
  8030c5:	c3                   	retq   

00000000008030c6 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8030c6:	55                   	push   %rbp
  8030c7:	48 89 e5             	mov    %rsp,%rbp
  8030ca:	48 83 ec 30          	sub    $0x30,%rsp
  8030ce:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8030d1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030d5:	89 55 e8             	mov    %edx,-0x18(%rbp)
  8030d8:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  8030db:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8030e2:	00 00 00 
  8030e5:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8030e8:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8030ea:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8030f1:	00 00 00 
  8030f4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8030f7:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8030fa:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803101:	00 00 00 
  803104:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803107:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80310a:	bf 07 00 00 00       	mov    $0x7,%edi
  80310f:	48 b8 51 2e 80 00 00 	movabs $0x802e51,%rax
  803116:	00 00 00 
  803119:	ff d0                	callq  *%rax
  80311b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80311e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803122:	78 69                	js     80318d <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803124:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  80312b:	7f 08                	jg     803135 <nsipc_recv+0x6f>
  80312d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803130:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803133:	7e 35                	jle    80316a <nsipc_recv+0xa4>
  803135:	48 b9 d7 44 80 00 00 	movabs $0x8044d7,%rcx
  80313c:	00 00 00 
  80313f:	48 ba ec 44 80 00 00 	movabs $0x8044ec,%rdx
  803146:	00 00 00 
  803149:	be 61 00 00 00       	mov    $0x61,%esi
  80314e:	48 bf 01 45 80 00 00 	movabs $0x804501,%rdi
  803155:	00 00 00 
  803158:	b8 00 00 00 00       	mov    $0x0,%eax
  80315d:	49 b8 19 3b 80 00 00 	movabs $0x803b19,%r8
  803164:	00 00 00 
  803167:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80316a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80316d:	48 63 d0             	movslq %eax,%rdx
  803170:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803174:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  80317b:	00 00 00 
  80317e:	48 89 c7             	mov    %rax,%rdi
  803181:	48 b8 4b 11 80 00 00 	movabs $0x80114b,%rax
  803188:	00 00 00 
  80318b:	ff d0                	callq  *%rax
	}

	return r;
  80318d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803190:	c9                   	leaveq 
  803191:	c3                   	retq   

0000000000803192 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803192:	55                   	push   %rbp
  803193:	48 89 e5             	mov    %rsp,%rbp
  803196:	48 83 ec 20          	sub    $0x20,%rsp
  80319a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80319d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8031a1:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8031a4:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8031a7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031ae:	00 00 00 
  8031b1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8031b4:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8031b6:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  8031bd:	7e 35                	jle    8031f4 <nsipc_send+0x62>
  8031bf:	48 b9 0d 45 80 00 00 	movabs $0x80450d,%rcx
  8031c6:	00 00 00 
  8031c9:	48 ba ec 44 80 00 00 	movabs $0x8044ec,%rdx
  8031d0:	00 00 00 
  8031d3:	be 6c 00 00 00       	mov    $0x6c,%esi
  8031d8:	48 bf 01 45 80 00 00 	movabs $0x804501,%rdi
  8031df:	00 00 00 
  8031e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8031e7:	49 b8 19 3b 80 00 00 	movabs $0x803b19,%r8
  8031ee:	00 00 00 
  8031f1:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8031f4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031f7:	48 63 d0             	movslq %eax,%rdx
  8031fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031fe:	48 89 c6             	mov    %rax,%rsi
  803201:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803208:	00 00 00 
  80320b:	48 b8 4b 11 80 00 00 	movabs $0x80114b,%rax
  803212:	00 00 00 
  803215:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803217:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80321e:	00 00 00 
  803221:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803224:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803227:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80322e:	00 00 00 
  803231:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803234:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803237:	bf 08 00 00 00       	mov    $0x8,%edi
  80323c:	48 b8 51 2e 80 00 00 	movabs $0x802e51,%rax
  803243:	00 00 00 
  803246:	ff d0                	callq  *%rax
}
  803248:	c9                   	leaveq 
  803249:	c3                   	retq   

000000000080324a <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80324a:	55                   	push   %rbp
  80324b:	48 89 e5             	mov    %rsp,%rbp
  80324e:	48 83 ec 10          	sub    $0x10,%rsp
  803252:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803255:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803258:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  80325b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803262:	00 00 00 
  803265:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803268:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  80326a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803271:	00 00 00 
  803274:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803277:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  80327a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803281:	00 00 00 
  803284:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803287:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  80328a:	bf 09 00 00 00       	mov    $0x9,%edi
  80328f:	48 b8 51 2e 80 00 00 	movabs $0x802e51,%rax
  803296:	00 00 00 
  803299:	ff d0                	callq  *%rax
}
  80329b:	c9                   	leaveq 
  80329c:	c3                   	retq   

000000000080329d <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80329d:	55                   	push   %rbp
  80329e:	48 89 e5             	mov    %rsp,%rbp
  8032a1:	53                   	push   %rbx
  8032a2:	48 83 ec 38          	sub    $0x38,%rsp
  8032a6:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8032aa:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8032ae:	48 89 c7             	mov    %rax,%rdi
  8032b1:	48 b8 db 1a 80 00 00 	movabs $0x801adb,%rax
  8032b8:	00 00 00 
  8032bb:	ff d0                	callq  *%rax
  8032bd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032c0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032c4:	0f 88 bf 01 00 00    	js     803489 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8032ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032ce:	ba 07 04 00 00       	mov    $0x407,%edx
  8032d3:	48 89 c6             	mov    %rax,%rsi
  8032d6:	bf 00 00 00 00       	mov    $0x0,%edi
  8032db:	48 b8 56 17 80 00 00 	movabs $0x801756,%rax
  8032e2:	00 00 00 
  8032e5:	ff d0                	callq  *%rax
  8032e7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032ee:	0f 88 95 01 00 00    	js     803489 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8032f4:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8032f8:	48 89 c7             	mov    %rax,%rdi
  8032fb:	48 b8 db 1a 80 00 00 	movabs $0x801adb,%rax
  803302:	00 00 00 
  803305:	ff d0                	callq  *%rax
  803307:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80330a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80330e:	0f 88 5d 01 00 00    	js     803471 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803314:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803318:	ba 07 04 00 00       	mov    $0x407,%edx
  80331d:	48 89 c6             	mov    %rax,%rsi
  803320:	bf 00 00 00 00       	mov    $0x0,%edi
  803325:	48 b8 56 17 80 00 00 	movabs $0x801756,%rax
  80332c:	00 00 00 
  80332f:	ff d0                	callq  *%rax
  803331:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803334:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803338:	0f 88 33 01 00 00    	js     803471 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80333e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803342:	48 89 c7             	mov    %rax,%rdi
  803345:	48 b8 b0 1a 80 00 00 	movabs $0x801ab0,%rax
  80334c:	00 00 00 
  80334f:	ff d0                	callq  *%rax
  803351:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803355:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803359:	ba 07 04 00 00       	mov    $0x407,%edx
  80335e:	48 89 c6             	mov    %rax,%rsi
  803361:	bf 00 00 00 00       	mov    $0x0,%edi
  803366:	48 b8 56 17 80 00 00 	movabs $0x801756,%rax
  80336d:	00 00 00 
  803370:	ff d0                	callq  *%rax
  803372:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803375:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803379:	79 05                	jns    803380 <pipe+0xe3>
		goto err2;
  80337b:	e9 d9 00 00 00       	jmpq   803459 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803380:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803384:	48 89 c7             	mov    %rax,%rdi
  803387:	48 b8 b0 1a 80 00 00 	movabs $0x801ab0,%rax
  80338e:	00 00 00 
  803391:	ff d0                	callq  *%rax
  803393:	48 89 c2             	mov    %rax,%rdx
  803396:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80339a:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8033a0:	48 89 d1             	mov    %rdx,%rcx
  8033a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8033a8:	48 89 c6             	mov    %rax,%rsi
  8033ab:	bf 00 00 00 00       	mov    $0x0,%edi
  8033b0:	48 b8 a6 17 80 00 00 	movabs $0x8017a6,%rax
  8033b7:	00 00 00 
  8033ba:	ff d0                	callq  *%rax
  8033bc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8033bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8033c3:	79 1b                	jns    8033e0 <pipe+0x143>
		goto err3;
  8033c5:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8033c6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033ca:	48 89 c6             	mov    %rax,%rsi
  8033cd:	bf 00 00 00 00       	mov    $0x0,%edi
  8033d2:	48 b8 01 18 80 00 00 	movabs $0x801801,%rax
  8033d9:	00 00 00 
  8033dc:	ff d0                	callq  *%rax
  8033de:	eb 79                	jmp    803459 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8033e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033e4:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8033eb:	00 00 00 
  8033ee:	8b 12                	mov    (%rdx),%edx
  8033f0:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8033f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033f6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8033fd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803401:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803408:	00 00 00 
  80340b:	8b 12                	mov    (%rdx),%edx
  80340d:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80340f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803413:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80341a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80341e:	48 89 c7             	mov    %rax,%rdi
  803421:	48 b8 8d 1a 80 00 00 	movabs $0x801a8d,%rax
  803428:	00 00 00 
  80342b:	ff d0                	callq  *%rax
  80342d:	89 c2                	mov    %eax,%edx
  80342f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803433:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803435:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803439:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80343d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803441:	48 89 c7             	mov    %rax,%rdi
  803444:	48 b8 8d 1a 80 00 00 	movabs $0x801a8d,%rax
  80344b:	00 00 00 
  80344e:	ff d0                	callq  *%rax
  803450:	89 03                	mov    %eax,(%rbx)
	return 0;
  803452:	b8 00 00 00 00       	mov    $0x0,%eax
  803457:	eb 33                	jmp    80348c <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803459:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80345d:	48 89 c6             	mov    %rax,%rsi
  803460:	bf 00 00 00 00       	mov    $0x0,%edi
  803465:	48 b8 01 18 80 00 00 	movabs $0x801801,%rax
  80346c:	00 00 00 
  80346f:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803471:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803475:	48 89 c6             	mov    %rax,%rsi
  803478:	bf 00 00 00 00       	mov    $0x0,%edi
  80347d:	48 b8 01 18 80 00 00 	movabs $0x801801,%rax
  803484:	00 00 00 
  803487:	ff d0                	callq  *%rax
err:
	return r;
  803489:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80348c:	48 83 c4 38          	add    $0x38,%rsp
  803490:	5b                   	pop    %rbx
  803491:	5d                   	pop    %rbp
  803492:	c3                   	retq   

0000000000803493 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803493:	55                   	push   %rbp
  803494:	48 89 e5             	mov    %rsp,%rbp
  803497:	53                   	push   %rbx
  803498:	48 83 ec 28          	sub    $0x28,%rsp
  80349c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8034a0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8034a4:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8034ab:	00 00 00 
  8034ae:	48 8b 00             	mov    (%rax),%rax
  8034b1:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8034b7:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8034ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034be:	48 89 c7             	mov    %rax,%rdi
  8034c1:	48 b8 17 3e 80 00 00 	movabs $0x803e17,%rax
  8034c8:	00 00 00 
  8034cb:	ff d0                	callq  *%rax
  8034cd:	89 c3                	mov    %eax,%ebx
  8034cf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034d3:	48 89 c7             	mov    %rax,%rdi
  8034d6:	48 b8 17 3e 80 00 00 	movabs $0x803e17,%rax
  8034dd:	00 00 00 
  8034e0:	ff d0                	callq  *%rax
  8034e2:	39 c3                	cmp    %eax,%ebx
  8034e4:	0f 94 c0             	sete   %al
  8034e7:	0f b6 c0             	movzbl %al,%eax
  8034ea:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8034ed:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8034f4:	00 00 00 
  8034f7:	48 8b 00             	mov    (%rax),%rax
  8034fa:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803500:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803503:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803506:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803509:	75 05                	jne    803510 <_pipeisclosed+0x7d>
			return ret;
  80350b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80350e:	eb 4f                	jmp    80355f <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803510:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803513:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803516:	74 42                	je     80355a <_pipeisclosed+0xc7>
  803518:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80351c:	75 3c                	jne    80355a <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80351e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803525:	00 00 00 
  803528:	48 8b 00             	mov    (%rax),%rax
  80352b:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803531:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803534:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803537:	89 c6                	mov    %eax,%esi
  803539:	48 bf 1e 45 80 00 00 	movabs $0x80451e,%rdi
  803540:	00 00 00 
  803543:	b8 00 00 00 00       	mov    $0x0,%eax
  803548:	49 b8 72 02 80 00 00 	movabs $0x800272,%r8
  80354f:	00 00 00 
  803552:	41 ff d0             	callq  *%r8
	}
  803555:	e9 4a ff ff ff       	jmpq   8034a4 <_pipeisclosed+0x11>
  80355a:	e9 45 ff ff ff       	jmpq   8034a4 <_pipeisclosed+0x11>
}
  80355f:	48 83 c4 28          	add    $0x28,%rsp
  803563:	5b                   	pop    %rbx
  803564:	5d                   	pop    %rbp
  803565:	c3                   	retq   

0000000000803566 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803566:	55                   	push   %rbp
  803567:	48 89 e5             	mov    %rsp,%rbp
  80356a:	48 83 ec 30          	sub    $0x30,%rsp
  80356e:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803571:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803575:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803578:	48 89 d6             	mov    %rdx,%rsi
  80357b:	89 c7                	mov    %eax,%edi
  80357d:	48 b8 73 1b 80 00 00 	movabs $0x801b73,%rax
  803584:	00 00 00 
  803587:	ff d0                	callq  *%rax
  803589:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80358c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803590:	79 05                	jns    803597 <pipeisclosed+0x31>
		return r;
  803592:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803595:	eb 31                	jmp    8035c8 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803597:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80359b:	48 89 c7             	mov    %rax,%rdi
  80359e:	48 b8 b0 1a 80 00 00 	movabs $0x801ab0,%rax
  8035a5:	00 00 00 
  8035a8:	ff d0                	callq  *%rax
  8035aa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8035ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035b2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8035b6:	48 89 d6             	mov    %rdx,%rsi
  8035b9:	48 89 c7             	mov    %rax,%rdi
  8035bc:	48 b8 93 34 80 00 00 	movabs $0x803493,%rax
  8035c3:	00 00 00 
  8035c6:	ff d0                	callq  *%rax
}
  8035c8:	c9                   	leaveq 
  8035c9:	c3                   	retq   

00000000008035ca <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8035ca:	55                   	push   %rbp
  8035cb:	48 89 e5             	mov    %rsp,%rbp
  8035ce:	48 83 ec 40          	sub    $0x40,%rsp
  8035d2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8035d6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8035da:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8035de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035e2:	48 89 c7             	mov    %rax,%rdi
  8035e5:	48 b8 b0 1a 80 00 00 	movabs $0x801ab0,%rax
  8035ec:	00 00 00 
  8035ef:	ff d0                	callq  *%rax
  8035f1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8035f5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035f9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8035fd:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803604:	00 
  803605:	e9 92 00 00 00       	jmpq   80369c <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80360a:	eb 41                	jmp    80364d <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80360c:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803611:	74 09                	je     80361c <devpipe_read+0x52>
				return i;
  803613:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803617:	e9 92 00 00 00       	jmpq   8036ae <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80361c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803620:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803624:	48 89 d6             	mov    %rdx,%rsi
  803627:	48 89 c7             	mov    %rax,%rdi
  80362a:	48 b8 93 34 80 00 00 	movabs $0x803493,%rax
  803631:	00 00 00 
  803634:	ff d0                	callq  *%rax
  803636:	85 c0                	test   %eax,%eax
  803638:	74 07                	je     803641 <devpipe_read+0x77>
				return 0;
  80363a:	b8 00 00 00 00       	mov    $0x0,%eax
  80363f:	eb 6d                	jmp    8036ae <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803641:	48 b8 18 17 80 00 00 	movabs $0x801718,%rax
  803648:	00 00 00 
  80364b:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80364d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803651:	8b 10                	mov    (%rax),%edx
  803653:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803657:	8b 40 04             	mov    0x4(%rax),%eax
  80365a:	39 c2                	cmp    %eax,%edx
  80365c:	74 ae                	je     80360c <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80365e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803662:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803666:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80366a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80366e:	8b 00                	mov    (%rax),%eax
  803670:	99                   	cltd   
  803671:	c1 ea 1b             	shr    $0x1b,%edx
  803674:	01 d0                	add    %edx,%eax
  803676:	83 e0 1f             	and    $0x1f,%eax
  803679:	29 d0                	sub    %edx,%eax
  80367b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80367f:	48 98                	cltq   
  803681:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803686:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803688:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80368c:	8b 00                	mov    (%rax),%eax
  80368e:	8d 50 01             	lea    0x1(%rax),%edx
  803691:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803695:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803697:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80369c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036a0:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8036a4:	0f 82 60 ff ff ff    	jb     80360a <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8036aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8036ae:	c9                   	leaveq 
  8036af:	c3                   	retq   

00000000008036b0 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8036b0:	55                   	push   %rbp
  8036b1:	48 89 e5             	mov    %rsp,%rbp
  8036b4:	48 83 ec 40          	sub    $0x40,%rsp
  8036b8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8036bc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8036c0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8036c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036c8:	48 89 c7             	mov    %rax,%rdi
  8036cb:	48 b8 b0 1a 80 00 00 	movabs $0x801ab0,%rax
  8036d2:	00 00 00 
  8036d5:	ff d0                	callq  *%rax
  8036d7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8036db:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036df:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8036e3:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8036ea:	00 
  8036eb:	e9 8e 00 00 00       	jmpq   80377e <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8036f0:	eb 31                	jmp    803723 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8036f2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8036f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036fa:	48 89 d6             	mov    %rdx,%rsi
  8036fd:	48 89 c7             	mov    %rax,%rdi
  803700:	48 b8 93 34 80 00 00 	movabs $0x803493,%rax
  803707:	00 00 00 
  80370a:	ff d0                	callq  *%rax
  80370c:	85 c0                	test   %eax,%eax
  80370e:	74 07                	je     803717 <devpipe_write+0x67>
				return 0;
  803710:	b8 00 00 00 00       	mov    $0x0,%eax
  803715:	eb 79                	jmp    803790 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803717:	48 b8 18 17 80 00 00 	movabs $0x801718,%rax
  80371e:	00 00 00 
  803721:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803723:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803727:	8b 40 04             	mov    0x4(%rax),%eax
  80372a:	48 63 d0             	movslq %eax,%rdx
  80372d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803731:	8b 00                	mov    (%rax),%eax
  803733:	48 98                	cltq   
  803735:	48 83 c0 20          	add    $0x20,%rax
  803739:	48 39 c2             	cmp    %rax,%rdx
  80373c:	73 b4                	jae    8036f2 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80373e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803742:	8b 40 04             	mov    0x4(%rax),%eax
  803745:	99                   	cltd   
  803746:	c1 ea 1b             	shr    $0x1b,%edx
  803749:	01 d0                	add    %edx,%eax
  80374b:	83 e0 1f             	and    $0x1f,%eax
  80374e:	29 d0                	sub    %edx,%eax
  803750:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803754:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803758:	48 01 ca             	add    %rcx,%rdx
  80375b:	0f b6 0a             	movzbl (%rdx),%ecx
  80375e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803762:	48 98                	cltq   
  803764:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803768:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80376c:	8b 40 04             	mov    0x4(%rax),%eax
  80376f:	8d 50 01             	lea    0x1(%rax),%edx
  803772:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803776:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803779:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80377e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803782:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803786:	0f 82 64 ff ff ff    	jb     8036f0 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80378c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803790:	c9                   	leaveq 
  803791:	c3                   	retq   

0000000000803792 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803792:	55                   	push   %rbp
  803793:	48 89 e5             	mov    %rsp,%rbp
  803796:	48 83 ec 20          	sub    $0x20,%rsp
  80379a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80379e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8037a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037a6:	48 89 c7             	mov    %rax,%rdi
  8037a9:	48 b8 b0 1a 80 00 00 	movabs $0x801ab0,%rax
  8037b0:	00 00 00 
  8037b3:	ff d0                	callq  *%rax
  8037b5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8037b9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037bd:	48 be 31 45 80 00 00 	movabs $0x804531,%rsi
  8037c4:	00 00 00 
  8037c7:	48 89 c7             	mov    %rax,%rdi
  8037ca:	48 b8 27 0e 80 00 00 	movabs $0x800e27,%rax
  8037d1:	00 00 00 
  8037d4:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8037d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037da:	8b 50 04             	mov    0x4(%rax),%edx
  8037dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037e1:	8b 00                	mov    (%rax),%eax
  8037e3:	29 c2                	sub    %eax,%edx
  8037e5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037e9:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8037ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037f3:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8037fa:	00 00 00 
	stat->st_dev = &devpipe;
  8037fd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803801:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803808:	00 00 00 
  80380b:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803812:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803817:	c9                   	leaveq 
  803818:	c3                   	retq   

0000000000803819 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803819:	55                   	push   %rbp
  80381a:	48 89 e5             	mov    %rsp,%rbp
  80381d:	48 83 ec 10          	sub    $0x10,%rsp
  803821:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803825:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803829:	48 89 c6             	mov    %rax,%rsi
  80382c:	bf 00 00 00 00       	mov    $0x0,%edi
  803831:	48 b8 01 18 80 00 00 	movabs $0x801801,%rax
  803838:	00 00 00 
  80383b:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80383d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803841:	48 89 c7             	mov    %rax,%rdi
  803844:	48 b8 b0 1a 80 00 00 	movabs $0x801ab0,%rax
  80384b:	00 00 00 
  80384e:	ff d0                	callq  *%rax
  803850:	48 89 c6             	mov    %rax,%rsi
  803853:	bf 00 00 00 00       	mov    $0x0,%edi
  803858:	48 b8 01 18 80 00 00 	movabs $0x801801,%rax
  80385f:	00 00 00 
  803862:	ff d0                	callq  *%rax
}
  803864:	c9                   	leaveq 
  803865:	c3                   	retq   

0000000000803866 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803866:	55                   	push   %rbp
  803867:	48 89 e5             	mov    %rsp,%rbp
  80386a:	48 83 ec 20          	sub    $0x20,%rsp
  80386e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803871:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803874:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803877:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80387b:	be 01 00 00 00       	mov    $0x1,%esi
  803880:	48 89 c7             	mov    %rax,%rdi
  803883:	48 b8 0e 16 80 00 00 	movabs $0x80160e,%rax
  80388a:	00 00 00 
  80388d:	ff d0                	callq  *%rax
}
  80388f:	c9                   	leaveq 
  803890:	c3                   	retq   

0000000000803891 <getchar>:

int
getchar(void)
{
  803891:	55                   	push   %rbp
  803892:	48 89 e5             	mov    %rsp,%rbp
  803895:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803899:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80389d:	ba 01 00 00 00       	mov    $0x1,%edx
  8038a2:	48 89 c6             	mov    %rax,%rsi
  8038a5:	bf 00 00 00 00       	mov    $0x0,%edi
  8038aa:	48 b8 a5 1f 80 00 00 	movabs $0x801fa5,%rax
  8038b1:	00 00 00 
  8038b4:	ff d0                	callq  *%rax
  8038b6:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8038b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038bd:	79 05                	jns    8038c4 <getchar+0x33>
		return r;
  8038bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038c2:	eb 14                	jmp    8038d8 <getchar+0x47>
	if (r < 1)
  8038c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038c8:	7f 07                	jg     8038d1 <getchar+0x40>
		return -E_EOF;
  8038ca:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8038cf:	eb 07                	jmp    8038d8 <getchar+0x47>
	return c;
  8038d1:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8038d5:	0f b6 c0             	movzbl %al,%eax
}
  8038d8:	c9                   	leaveq 
  8038d9:	c3                   	retq   

00000000008038da <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8038da:	55                   	push   %rbp
  8038db:	48 89 e5             	mov    %rsp,%rbp
  8038de:	48 83 ec 20          	sub    $0x20,%rsp
  8038e2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8038e5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8038e9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038ec:	48 89 d6             	mov    %rdx,%rsi
  8038ef:	89 c7                	mov    %eax,%edi
  8038f1:	48 b8 73 1b 80 00 00 	movabs $0x801b73,%rax
  8038f8:	00 00 00 
  8038fb:	ff d0                	callq  *%rax
  8038fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803900:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803904:	79 05                	jns    80390b <iscons+0x31>
		return r;
  803906:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803909:	eb 1a                	jmp    803925 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80390b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80390f:	8b 10                	mov    (%rax),%edx
  803911:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803918:	00 00 00 
  80391b:	8b 00                	mov    (%rax),%eax
  80391d:	39 c2                	cmp    %eax,%edx
  80391f:	0f 94 c0             	sete   %al
  803922:	0f b6 c0             	movzbl %al,%eax
}
  803925:	c9                   	leaveq 
  803926:	c3                   	retq   

0000000000803927 <opencons>:

int
opencons(void)
{
  803927:	55                   	push   %rbp
  803928:	48 89 e5             	mov    %rsp,%rbp
  80392b:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80392f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803933:	48 89 c7             	mov    %rax,%rdi
  803936:	48 b8 db 1a 80 00 00 	movabs $0x801adb,%rax
  80393d:	00 00 00 
  803940:	ff d0                	callq  *%rax
  803942:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803945:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803949:	79 05                	jns    803950 <opencons+0x29>
		return r;
  80394b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80394e:	eb 5b                	jmp    8039ab <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803950:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803954:	ba 07 04 00 00       	mov    $0x407,%edx
  803959:	48 89 c6             	mov    %rax,%rsi
  80395c:	bf 00 00 00 00       	mov    $0x0,%edi
  803961:	48 b8 56 17 80 00 00 	movabs $0x801756,%rax
  803968:	00 00 00 
  80396b:	ff d0                	callq  *%rax
  80396d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803970:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803974:	79 05                	jns    80397b <opencons+0x54>
		return r;
  803976:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803979:	eb 30                	jmp    8039ab <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80397b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80397f:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803986:	00 00 00 
  803989:	8b 12                	mov    (%rdx),%edx
  80398b:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80398d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803991:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803998:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80399c:	48 89 c7             	mov    %rax,%rdi
  80399f:	48 b8 8d 1a 80 00 00 	movabs $0x801a8d,%rax
  8039a6:	00 00 00 
  8039a9:	ff d0                	callq  *%rax
}
  8039ab:	c9                   	leaveq 
  8039ac:	c3                   	retq   

00000000008039ad <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8039ad:	55                   	push   %rbp
  8039ae:	48 89 e5             	mov    %rsp,%rbp
  8039b1:	48 83 ec 30          	sub    $0x30,%rsp
  8039b5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8039b9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8039bd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8039c1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8039c6:	75 07                	jne    8039cf <devcons_read+0x22>
		return 0;
  8039c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8039cd:	eb 4b                	jmp    803a1a <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8039cf:	eb 0c                	jmp    8039dd <devcons_read+0x30>
		sys_yield();
  8039d1:	48 b8 18 17 80 00 00 	movabs $0x801718,%rax
  8039d8:	00 00 00 
  8039db:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8039dd:	48 b8 58 16 80 00 00 	movabs $0x801658,%rax
  8039e4:	00 00 00 
  8039e7:	ff d0                	callq  *%rax
  8039e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039f0:	74 df                	je     8039d1 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8039f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039f6:	79 05                	jns    8039fd <devcons_read+0x50>
		return c;
  8039f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039fb:	eb 1d                	jmp    803a1a <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8039fd:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803a01:	75 07                	jne    803a0a <devcons_read+0x5d>
		return 0;
  803a03:	b8 00 00 00 00       	mov    $0x0,%eax
  803a08:	eb 10                	jmp    803a1a <devcons_read+0x6d>
	*(char*)vbuf = c;
  803a0a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a0d:	89 c2                	mov    %eax,%edx
  803a0f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a13:	88 10                	mov    %dl,(%rax)
	return 1;
  803a15:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803a1a:	c9                   	leaveq 
  803a1b:	c3                   	retq   

0000000000803a1c <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803a1c:	55                   	push   %rbp
  803a1d:	48 89 e5             	mov    %rsp,%rbp
  803a20:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803a27:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803a2e:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803a35:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803a3c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803a43:	eb 76                	jmp    803abb <devcons_write+0x9f>
		m = n - tot;
  803a45:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803a4c:	89 c2                	mov    %eax,%edx
  803a4e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a51:	29 c2                	sub    %eax,%edx
  803a53:	89 d0                	mov    %edx,%eax
  803a55:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803a58:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a5b:	83 f8 7f             	cmp    $0x7f,%eax
  803a5e:	76 07                	jbe    803a67 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803a60:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803a67:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a6a:	48 63 d0             	movslq %eax,%rdx
  803a6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a70:	48 63 c8             	movslq %eax,%rcx
  803a73:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803a7a:	48 01 c1             	add    %rax,%rcx
  803a7d:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803a84:	48 89 ce             	mov    %rcx,%rsi
  803a87:	48 89 c7             	mov    %rax,%rdi
  803a8a:	48 b8 4b 11 80 00 00 	movabs $0x80114b,%rax
  803a91:	00 00 00 
  803a94:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803a96:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a99:	48 63 d0             	movslq %eax,%rdx
  803a9c:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803aa3:	48 89 d6             	mov    %rdx,%rsi
  803aa6:	48 89 c7             	mov    %rax,%rdi
  803aa9:	48 b8 0e 16 80 00 00 	movabs $0x80160e,%rax
  803ab0:	00 00 00 
  803ab3:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803ab5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ab8:	01 45 fc             	add    %eax,-0x4(%rbp)
  803abb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803abe:	48 98                	cltq   
  803ac0:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803ac7:	0f 82 78 ff ff ff    	jb     803a45 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803acd:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803ad0:	c9                   	leaveq 
  803ad1:	c3                   	retq   

0000000000803ad2 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803ad2:	55                   	push   %rbp
  803ad3:	48 89 e5             	mov    %rsp,%rbp
  803ad6:	48 83 ec 08          	sub    $0x8,%rsp
  803ada:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803ade:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ae3:	c9                   	leaveq 
  803ae4:	c3                   	retq   

0000000000803ae5 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803ae5:	55                   	push   %rbp
  803ae6:	48 89 e5             	mov    %rsp,%rbp
  803ae9:	48 83 ec 10          	sub    $0x10,%rsp
  803aed:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803af1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803af5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803af9:	48 be 3d 45 80 00 00 	movabs $0x80453d,%rsi
  803b00:	00 00 00 
  803b03:	48 89 c7             	mov    %rax,%rdi
  803b06:	48 b8 27 0e 80 00 00 	movabs $0x800e27,%rax
  803b0d:	00 00 00 
  803b10:	ff d0                	callq  *%rax
	return 0;
  803b12:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b17:	c9                   	leaveq 
  803b18:	c3                   	retq   

0000000000803b19 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803b19:	55                   	push   %rbp
  803b1a:	48 89 e5             	mov    %rsp,%rbp
  803b1d:	53                   	push   %rbx
  803b1e:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803b25:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803b2c:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803b32:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803b39:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803b40:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803b47:	84 c0                	test   %al,%al
  803b49:	74 23                	je     803b6e <_panic+0x55>
  803b4b:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803b52:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803b56:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803b5a:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803b5e:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803b62:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803b66:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803b6a:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803b6e:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803b75:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803b7c:	00 00 00 
  803b7f:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803b86:	00 00 00 
  803b89:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803b8d:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803b94:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803b9b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803ba2:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  803ba9:	00 00 00 
  803bac:	48 8b 18             	mov    (%rax),%rbx
  803baf:	48 b8 da 16 80 00 00 	movabs $0x8016da,%rax
  803bb6:	00 00 00 
  803bb9:	ff d0                	callq  *%rax
  803bbb:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803bc1:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803bc8:	41 89 c8             	mov    %ecx,%r8d
  803bcb:	48 89 d1             	mov    %rdx,%rcx
  803bce:	48 89 da             	mov    %rbx,%rdx
  803bd1:	89 c6                	mov    %eax,%esi
  803bd3:	48 bf 48 45 80 00 00 	movabs $0x804548,%rdi
  803bda:	00 00 00 
  803bdd:	b8 00 00 00 00       	mov    $0x0,%eax
  803be2:	49 b9 72 02 80 00 00 	movabs $0x800272,%r9
  803be9:	00 00 00 
  803bec:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803bef:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803bf6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803bfd:	48 89 d6             	mov    %rdx,%rsi
  803c00:	48 89 c7             	mov    %rax,%rdi
  803c03:	48 b8 c6 01 80 00 00 	movabs $0x8001c6,%rax
  803c0a:	00 00 00 
  803c0d:	ff d0                	callq  *%rax
	cprintf("\n");
  803c0f:	48 bf 6b 45 80 00 00 	movabs $0x80456b,%rdi
  803c16:	00 00 00 
  803c19:	b8 00 00 00 00       	mov    $0x0,%eax
  803c1e:	48 ba 72 02 80 00 00 	movabs $0x800272,%rdx
  803c25:	00 00 00 
  803c28:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803c2a:	cc                   	int3   
  803c2b:	eb fd                	jmp    803c2a <_panic+0x111>

0000000000803c2d <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803c2d:	55                   	push   %rbp
  803c2e:	48 89 e5             	mov    %rsp,%rbp
  803c31:	48 83 ec 30          	sub    $0x30,%rsp
  803c35:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803c39:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c3d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803c41:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c48:	00 00 00 
  803c4b:	48 8b 00             	mov    (%rax),%rax
  803c4e:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803c54:	85 c0                	test   %eax,%eax
  803c56:	75 3c                	jne    803c94 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  803c58:	48 b8 da 16 80 00 00 	movabs $0x8016da,%rax
  803c5f:	00 00 00 
  803c62:	ff d0                	callq  *%rax
  803c64:	25 ff 03 00 00       	and    $0x3ff,%eax
  803c69:	48 63 d0             	movslq %eax,%rdx
  803c6c:	48 89 d0             	mov    %rdx,%rax
  803c6f:	48 c1 e0 03          	shl    $0x3,%rax
  803c73:	48 01 d0             	add    %rdx,%rax
  803c76:	48 c1 e0 05          	shl    $0x5,%rax
  803c7a:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803c81:	00 00 00 
  803c84:	48 01 c2             	add    %rax,%rdx
  803c87:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c8e:	00 00 00 
  803c91:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803c94:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803c99:	75 0e                	jne    803ca9 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  803c9b:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803ca2:	00 00 00 
  803ca5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803ca9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cad:	48 89 c7             	mov    %rax,%rdi
  803cb0:	48 b8 7f 19 80 00 00 	movabs $0x80197f,%rax
  803cb7:	00 00 00 
  803cba:	ff d0                	callq  *%rax
  803cbc:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803cbf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cc3:	79 19                	jns    803cde <ipc_recv+0xb1>
		*from_env_store = 0;
  803cc5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cc9:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803ccf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cd3:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803cd9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cdc:	eb 53                	jmp    803d31 <ipc_recv+0x104>
	}
	if(from_env_store)
  803cde:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803ce3:	74 19                	je     803cfe <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  803ce5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803cec:	00 00 00 
  803cef:	48 8b 00             	mov    (%rax),%rax
  803cf2:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803cf8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cfc:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803cfe:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803d03:	74 19                	je     803d1e <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  803d05:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803d0c:	00 00 00 
  803d0f:	48 8b 00             	mov    (%rax),%rax
  803d12:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803d18:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d1c:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803d1e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803d25:	00 00 00 
  803d28:	48 8b 00             	mov    (%rax),%rax
  803d2b:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803d31:	c9                   	leaveq 
  803d32:	c3                   	retq   

0000000000803d33 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803d33:	55                   	push   %rbp
  803d34:	48 89 e5             	mov    %rsp,%rbp
  803d37:	48 83 ec 30          	sub    $0x30,%rsp
  803d3b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d3e:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803d41:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803d45:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803d48:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803d4d:	75 0e                	jne    803d5d <ipc_send+0x2a>
		pg = (void*)UTOP;
  803d4f:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803d56:	00 00 00 
  803d59:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  803d5d:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803d60:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803d63:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803d67:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d6a:	89 c7                	mov    %eax,%edi
  803d6c:	48 b8 2a 19 80 00 00 	movabs $0x80192a,%rax
  803d73:	00 00 00 
  803d76:	ff d0                	callq  *%rax
  803d78:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  803d7b:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803d7f:	75 0c                	jne    803d8d <ipc_send+0x5a>
			sys_yield();
  803d81:	48 b8 18 17 80 00 00 	movabs $0x801718,%rax
  803d88:	00 00 00 
  803d8b:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  803d8d:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803d91:	74 ca                	je     803d5d <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  803d93:	c9                   	leaveq 
  803d94:	c3                   	retq   

0000000000803d95 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803d95:	55                   	push   %rbp
  803d96:	48 89 e5             	mov    %rsp,%rbp
  803d99:	48 83 ec 14          	sub    $0x14,%rsp
  803d9d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803da0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803da7:	eb 5e                	jmp    803e07 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803da9:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803db0:	00 00 00 
  803db3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803db6:	48 63 d0             	movslq %eax,%rdx
  803db9:	48 89 d0             	mov    %rdx,%rax
  803dbc:	48 c1 e0 03          	shl    $0x3,%rax
  803dc0:	48 01 d0             	add    %rdx,%rax
  803dc3:	48 c1 e0 05          	shl    $0x5,%rax
  803dc7:	48 01 c8             	add    %rcx,%rax
  803dca:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803dd0:	8b 00                	mov    (%rax),%eax
  803dd2:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803dd5:	75 2c                	jne    803e03 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803dd7:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803dde:	00 00 00 
  803de1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803de4:	48 63 d0             	movslq %eax,%rdx
  803de7:	48 89 d0             	mov    %rdx,%rax
  803dea:	48 c1 e0 03          	shl    $0x3,%rax
  803dee:	48 01 d0             	add    %rdx,%rax
  803df1:	48 c1 e0 05          	shl    $0x5,%rax
  803df5:	48 01 c8             	add    %rcx,%rax
  803df8:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803dfe:	8b 40 08             	mov    0x8(%rax),%eax
  803e01:	eb 12                	jmp    803e15 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803e03:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803e07:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803e0e:	7e 99                	jle    803da9 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803e10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e15:	c9                   	leaveq 
  803e16:	c3                   	retq   

0000000000803e17 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803e17:	55                   	push   %rbp
  803e18:	48 89 e5             	mov    %rsp,%rbp
  803e1b:	48 83 ec 18          	sub    $0x18,%rsp
  803e1f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803e23:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e27:	48 c1 e8 15          	shr    $0x15,%rax
  803e2b:	48 89 c2             	mov    %rax,%rdx
  803e2e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803e35:	01 00 00 
  803e38:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e3c:	83 e0 01             	and    $0x1,%eax
  803e3f:	48 85 c0             	test   %rax,%rax
  803e42:	75 07                	jne    803e4b <pageref+0x34>
		return 0;
  803e44:	b8 00 00 00 00       	mov    $0x0,%eax
  803e49:	eb 53                	jmp    803e9e <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803e4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e4f:	48 c1 e8 0c          	shr    $0xc,%rax
  803e53:	48 89 c2             	mov    %rax,%rdx
  803e56:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803e5d:	01 00 00 
  803e60:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e64:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803e68:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e6c:	83 e0 01             	and    $0x1,%eax
  803e6f:	48 85 c0             	test   %rax,%rax
  803e72:	75 07                	jne    803e7b <pageref+0x64>
		return 0;
  803e74:	b8 00 00 00 00       	mov    $0x0,%eax
  803e79:	eb 23                	jmp    803e9e <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803e7b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e7f:	48 c1 e8 0c          	shr    $0xc,%rax
  803e83:	48 89 c2             	mov    %rax,%rdx
  803e86:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803e8d:	00 00 00 
  803e90:	48 c1 e2 04          	shl    $0x4,%rdx
  803e94:	48 01 d0             	add    %rdx,%rax
  803e97:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803e9b:	0f b7 c0             	movzwl %ax,%eax
}
  803e9e:	c9                   	leaveq 
  803e9f:	c3                   	retq   
