
obj/user/lsfd.debug:     file format elf64-x86-64


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
  80003c:	e8 7c 01 00 00       	callq  8001bd <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <usage>:
#include <inc/lib.h>

void
usage(void)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
	cprintf("usage: lsfd [-1]\n");
  800047:	48 bf c0 45 80 00 00 	movabs $0x8045c0,%rdi
  80004e:	00 00 00 
  800051:	b8 00 00 00 00       	mov    $0x0,%eax
  800056:	48 ba 90 03 80 00 00 	movabs $0x800390,%rdx
  80005d:	00 00 00 
  800060:	ff d2                	callq  *%rdx
	exit();
  800062:	48 b8 48 02 80 00 00 	movabs $0x800248,%rax
  800069:	00 00 00 
  80006c:	ff d0                	callq  *%rax
}
  80006e:	5d                   	pop    %rbp
  80006f:	c3                   	retq   

0000000000800070 <umain>:

void
umain(int argc, char **argv)
{
  800070:	55                   	push   %rbp
  800071:	48 89 e5             	mov    %rsp,%rbp
  800074:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  80007b:	89 bd 3c ff ff ff    	mov    %edi,-0xc4(%rbp)
  800081:	48 89 b5 30 ff ff ff 	mov    %rsi,-0xd0(%rbp)
	int i, usefprint = 0;
  800088:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
  80008f:	48 8d 95 40 ff ff ff 	lea    -0xc0(%rbp),%rdx
  800096:	48 8b 8d 30 ff ff ff 	mov    -0xd0(%rbp),%rcx
  80009d:	48 8d 85 3c ff ff ff 	lea    -0xc4(%rbp),%rax
  8000a4:	48 89 ce             	mov    %rcx,%rsi
  8000a7:	48 89 c7             	mov    %rax,%rdi
  8000aa:	48 b8 ab 1b 80 00 00 	movabs $0x801bab,%rax
  8000b1:	00 00 00 
  8000b4:	ff d0                	callq  *%rax
	while ((i = argnext(&args)) >= 0)
  8000b6:	eb 1b                	jmp    8000d3 <umain+0x63>
		if (i == '1')
  8000b8:	83 7d fc 31          	cmpl   $0x31,-0x4(%rbp)
  8000bc:	75 09                	jne    8000c7 <umain+0x57>
			usefprint = 1;
  8000be:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
  8000c5:	eb 0c                	jmp    8000d3 <umain+0x63>
		else
			usage();
  8000c7:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000ce:	00 00 00 
  8000d1:	ff d0                	callq  *%rax
	int i, usefprint = 0;
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  8000d3:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8000da:	48 89 c7             	mov    %rax,%rdi
  8000dd:	48 b8 0f 1c 80 00 00 	movabs $0x801c0f,%rax
  8000e4:	00 00 00 
  8000e7:	ff d0                	callq  *%rax
  8000e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000f0:	79 c6                	jns    8000b8 <umain+0x48>
		if (i == '1')
			usefprint = 1;
		else
			usage();

	for (i = 0; i < 32; i++)
  8000f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8000f9:	e9 b3 00 00 00       	jmpq   8001b1 <umain+0x141>
		if (fstat(i, &st) >= 0) {
  8000fe:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  800105:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800108:	48 89 d6             	mov    %rdx,%rsi
  80010b:	89 c7                	mov    %eax,%edi
  80010d:	48 b8 d7 26 80 00 00 	movabs $0x8026d7,%rax
  800114:	00 00 00 
  800117:	ff d0                	callq  *%rax
  800119:	85 c0                	test   %eax,%eax
  80011b:	0f 88 8c 00 00 00    	js     8001ad <umain+0x13d>
			if (usefprint)
  800121:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800125:	74 4a                	je     800171 <umain+0x101>
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
  800127:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
			usage();

	for (i = 0; i < 32; i++)
		if (fstat(i, &st) >= 0) {
			if (usefprint)
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
  80012b:	48 8b 48 08          	mov    0x8(%rax),%rcx
  80012f:	8b 7d e0             	mov    -0x20(%rbp),%edi
  800132:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800135:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  80013c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80013f:	48 89 0c 24          	mov    %rcx,(%rsp)
  800143:	41 89 f9             	mov    %edi,%r9d
  800146:	41 89 f0             	mov    %esi,%r8d
  800149:	48 89 d1             	mov    %rdx,%rcx
  80014c:	89 c2                	mov    %eax,%edx
  80014e:	48 be d8 45 80 00 00 	movabs $0x8045d8,%rsi
  800155:	00 00 00 
  800158:	bf 01 00 00 00       	mov    $0x1,%edi
  80015d:	b8 00 00 00 00       	mov    $0x0,%eax
  800162:	49 ba 2a 30 80 00 00 	movabs $0x80302a,%r10
  800169:	00 00 00 
  80016c:	41 ff d2             	callq  *%r10
  80016f:	eb 3c                	jmp    8001ad <umain+0x13d>
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
  800171:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
			if (usefprint)
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
  800175:	48 8b 78 08          	mov    0x8(%rax),%rdi
  800179:	8b 75 e0             	mov    -0x20(%rbp),%esi
  80017c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80017f:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  800186:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800189:	49 89 f9             	mov    %rdi,%r9
  80018c:	41 89 f0             	mov    %esi,%r8d
  80018f:	89 c6                	mov    %eax,%esi
  800191:	48 bf d8 45 80 00 00 	movabs $0x8045d8,%rdi
  800198:	00 00 00 
  80019b:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a0:	49 ba 90 03 80 00 00 	movabs $0x800390,%r10
  8001a7:	00 00 00 
  8001aa:	41 ff d2             	callq  *%r10
		if (i == '1')
			usefprint = 1;
		else
			usage();

	for (i = 0; i < 32; i++)
  8001ad:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8001b1:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8001b5:	0f 8e 43 ff ff ff    	jle    8000fe <umain+0x8e>
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
		}
}
  8001bb:	c9                   	leaveq 
  8001bc:	c3                   	retq   

00000000008001bd <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001bd:	55                   	push   %rbp
  8001be:	48 89 e5             	mov    %rsp,%rbp
  8001c1:	48 83 ec 10          	sub    $0x10,%rsp
  8001c5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001c8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001cc:	48 b8 f8 17 80 00 00 	movabs $0x8017f8,%rax
  8001d3:	00 00 00 
  8001d6:	ff d0                	callq  *%rax
  8001d8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001dd:	48 63 d0             	movslq %eax,%rdx
  8001e0:	48 89 d0             	mov    %rdx,%rax
  8001e3:	48 c1 e0 03          	shl    $0x3,%rax
  8001e7:	48 01 d0             	add    %rdx,%rax
  8001ea:	48 c1 e0 05          	shl    $0x5,%rax
  8001ee:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8001f5:	00 00 00 
  8001f8:	48 01 c2             	add    %rax,%rdx
  8001fb:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800202:	00 00 00 
  800205:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800208:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80020c:	7e 14                	jle    800222 <libmain+0x65>
		binaryname = argv[0];
  80020e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800212:	48 8b 10             	mov    (%rax),%rdx
  800215:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80021c:	00 00 00 
  80021f:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800222:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800226:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800229:	48 89 d6             	mov    %rdx,%rsi
  80022c:	89 c7                	mov    %eax,%edi
  80022e:	48 b8 70 00 80 00 00 	movabs $0x800070,%rax
  800235:	00 00 00 
  800238:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  80023a:	48 b8 48 02 80 00 00 	movabs $0x800248,%rax
  800241:	00 00 00 
  800244:	ff d0                	callq  *%rax
}
  800246:	c9                   	leaveq 
  800247:	c3                   	retq   

0000000000800248 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800248:	55                   	push   %rbp
  800249:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80024c:	48 b8 d1 21 80 00 00 	movabs $0x8021d1,%rax
  800253:	00 00 00 
  800256:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800258:	bf 00 00 00 00       	mov    $0x0,%edi
  80025d:	48 b8 b4 17 80 00 00 	movabs $0x8017b4,%rax
  800264:	00 00 00 
  800267:	ff d0                	callq  *%rax

}
  800269:	5d                   	pop    %rbp
  80026a:	c3                   	retq   

000000000080026b <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80026b:	55                   	push   %rbp
  80026c:	48 89 e5             	mov    %rsp,%rbp
  80026f:	48 83 ec 10          	sub    $0x10,%rsp
  800273:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800276:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80027a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80027e:	8b 00                	mov    (%rax),%eax
  800280:	8d 48 01             	lea    0x1(%rax),%ecx
  800283:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800287:	89 0a                	mov    %ecx,(%rdx)
  800289:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80028c:	89 d1                	mov    %edx,%ecx
  80028e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800292:	48 98                	cltq   
  800294:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800298:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80029c:	8b 00                	mov    (%rax),%eax
  80029e:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002a3:	75 2c                	jne    8002d1 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8002a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002a9:	8b 00                	mov    (%rax),%eax
  8002ab:	48 98                	cltq   
  8002ad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002b1:	48 83 c2 08          	add    $0x8,%rdx
  8002b5:	48 89 c6             	mov    %rax,%rsi
  8002b8:	48 89 d7             	mov    %rdx,%rdi
  8002bb:	48 b8 2c 17 80 00 00 	movabs $0x80172c,%rax
  8002c2:	00 00 00 
  8002c5:	ff d0                	callq  *%rax
        b->idx = 0;
  8002c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002cb:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8002d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002d5:	8b 40 04             	mov    0x4(%rax),%eax
  8002d8:	8d 50 01             	lea    0x1(%rax),%edx
  8002db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002df:	89 50 04             	mov    %edx,0x4(%rax)
}
  8002e2:	c9                   	leaveq 
  8002e3:	c3                   	retq   

00000000008002e4 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8002e4:	55                   	push   %rbp
  8002e5:	48 89 e5             	mov    %rsp,%rbp
  8002e8:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8002ef:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8002f6:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8002fd:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800304:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80030b:	48 8b 0a             	mov    (%rdx),%rcx
  80030e:	48 89 08             	mov    %rcx,(%rax)
  800311:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800315:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800319:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80031d:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800321:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800328:	00 00 00 
    b.cnt = 0;
  80032b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800332:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800335:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80033c:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800343:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80034a:	48 89 c6             	mov    %rax,%rsi
  80034d:	48 bf 6b 02 80 00 00 	movabs $0x80026b,%rdi
  800354:	00 00 00 
  800357:	48 b8 43 07 80 00 00 	movabs $0x800743,%rax
  80035e:	00 00 00 
  800361:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800363:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800369:	48 98                	cltq   
  80036b:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800372:	48 83 c2 08          	add    $0x8,%rdx
  800376:	48 89 c6             	mov    %rax,%rsi
  800379:	48 89 d7             	mov    %rdx,%rdi
  80037c:	48 b8 2c 17 80 00 00 	movabs $0x80172c,%rax
  800383:	00 00 00 
  800386:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800388:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80038e:	c9                   	leaveq 
  80038f:	c3                   	retq   

0000000000800390 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800390:	55                   	push   %rbp
  800391:	48 89 e5             	mov    %rsp,%rbp
  800394:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80039b:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8003a2:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8003a9:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8003b0:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8003b7:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8003be:	84 c0                	test   %al,%al
  8003c0:	74 20                	je     8003e2 <cprintf+0x52>
  8003c2:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8003c6:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8003ca:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8003ce:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8003d2:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8003d6:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8003da:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8003de:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8003e2:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8003e9:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8003f0:	00 00 00 
  8003f3:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8003fa:	00 00 00 
  8003fd:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800401:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800408:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80040f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800416:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80041d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800424:	48 8b 0a             	mov    (%rdx),%rcx
  800427:	48 89 08             	mov    %rcx,(%rax)
  80042a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80042e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800432:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800436:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80043a:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800441:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800448:	48 89 d6             	mov    %rdx,%rsi
  80044b:	48 89 c7             	mov    %rax,%rdi
  80044e:	48 b8 e4 02 80 00 00 	movabs $0x8002e4,%rax
  800455:	00 00 00 
  800458:	ff d0                	callq  *%rax
  80045a:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800460:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800466:	c9                   	leaveq 
  800467:	c3                   	retq   

0000000000800468 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800468:	55                   	push   %rbp
  800469:	48 89 e5             	mov    %rsp,%rbp
  80046c:	53                   	push   %rbx
  80046d:	48 83 ec 38          	sub    $0x38,%rsp
  800471:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800475:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800479:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80047d:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800480:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800484:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800488:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80048b:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80048f:	77 3b                	ja     8004cc <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800491:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800494:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800498:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80049b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80049f:	ba 00 00 00 00       	mov    $0x0,%edx
  8004a4:	48 f7 f3             	div    %rbx
  8004a7:	48 89 c2             	mov    %rax,%rdx
  8004aa:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8004ad:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8004b0:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8004b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004b8:	41 89 f9             	mov    %edi,%r9d
  8004bb:	48 89 c7             	mov    %rax,%rdi
  8004be:	48 b8 68 04 80 00 00 	movabs $0x800468,%rax
  8004c5:	00 00 00 
  8004c8:	ff d0                	callq  *%rax
  8004ca:	eb 1e                	jmp    8004ea <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004cc:	eb 12                	jmp    8004e0 <printnum+0x78>
			putch(padc, putdat);
  8004ce:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8004d2:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8004d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004d9:	48 89 ce             	mov    %rcx,%rsi
  8004dc:	89 d7                	mov    %edx,%edi
  8004de:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004e0:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8004e4:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8004e8:	7f e4                	jg     8004ce <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004ea:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8004ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8004f6:	48 f7 f1             	div    %rcx
  8004f9:	48 89 d0             	mov    %rdx,%rax
  8004fc:	48 ba 10 48 80 00 00 	movabs $0x804810,%rdx
  800503:	00 00 00 
  800506:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80050a:	0f be d0             	movsbl %al,%edx
  80050d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800511:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800515:	48 89 ce             	mov    %rcx,%rsi
  800518:	89 d7                	mov    %edx,%edi
  80051a:	ff d0                	callq  *%rax
}
  80051c:	48 83 c4 38          	add    $0x38,%rsp
  800520:	5b                   	pop    %rbx
  800521:	5d                   	pop    %rbp
  800522:	c3                   	retq   

0000000000800523 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800523:	55                   	push   %rbp
  800524:	48 89 e5             	mov    %rsp,%rbp
  800527:	48 83 ec 1c          	sub    $0x1c,%rsp
  80052b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80052f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800532:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800536:	7e 52                	jle    80058a <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800538:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80053c:	8b 00                	mov    (%rax),%eax
  80053e:	83 f8 30             	cmp    $0x30,%eax
  800541:	73 24                	jae    800567 <getuint+0x44>
  800543:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800547:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80054b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80054f:	8b 00                	mov    (%rax),%eax
  800551:	89 c0                	mov    %eax,%eax
  800553:	48 01 d0             	add    %rdx,%rax
  800556:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80055a:	8b 12                	mov    (%rdx),%edx
  80055c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80055f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800563:	89 0a                	mov    %ecx,(%rdx)
  800565:	eb 17                	jmp    80057e <getuint+0x5b>
  800567:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80056b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80056f:	48 89 d0             	mov    %rdx,%rax
  800572:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800576:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80057a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80057e:	48 8b 00             	mov    (%rax),%rax
  800581:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800585:	e9 a3 00 00 00       	jmpq   80062d <getuint+0x10a>
	else if (lflag)
  80058a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80058e:	74 4f                	je     8005df <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800590:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800594:	8b 00                	mov    (%rax),%eax
  800596:	83 f8 30             	cmp    $0x30,%eax
  800599:	73 24                	jae    8005bf <getuint+0x9c>
  80059b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80059f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a7:	8b 00                	mov    (%rax),%eax
  8005a9:	89 c0                	mov    %eax,%eax
  8005ab:	48 01 d0             	add    %rdx,%rax
  8005ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b2:	8b 12                	mov    (%rdx),%edx
  8005b4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005bb:	89 0a                	mov    %ecx,(%rdx)
  8005bd:	eb 17                	jmp    8005d6 <getuint+0xb3>
  8005bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005c7:	48 89 d0             	mov    %rdx,%rax
  8005ca:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005ce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005d2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005d6:	48 8b 00             	mov    (%rax),%rax
  8005d9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005dd:	eb 4e                	jmp    80062d <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8005df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e3:	8b 00                	mov    (%rax),%eax
  8005e5:	83 f8 30             	cmp    $0x30,%eax
  8005e8:	73 24                	jae    80060e <getuint+0xeb>
  8005ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ee:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f6:	8b 00                	mov    (%rax),%eax
  8005f8:	89 c0                	mov    %eax,%eax
  8005fa:	48 01 d0             	add    %rdx,%rax
  8005fd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800601:	8b 12                	mov    (%rdx),%edx
  800603:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800606:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80060a:	89 0a                	mov    %ecx,(%rdx)
  80060c:	eb 17                	jmp    800625 <getuint+0x102>
  80060e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800612:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800616:	48 89 d0             	mov    %rdx,%rax
  800619:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80061d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800621:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800625:	8b 00                	mov    (%rax),%eax
  800627:	89 c0                	mov    %eax,%eax
  800629:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80062d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800631:	c9                   	leaveq 
  800632:	c3                   	retq   

0000000000800633 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800633:	55                   	push   %rbp
  800634:	48 89 e5             	mov    %rsp,%rbp
  800637:	48 83 ec 1c          	sub    $0x1c,%rsp
  80063b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80063f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800642:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800646:	7e 52                	jle    80069a <getint+0x67>
		x=va_arg(*ap, long long);
  800648:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80064c:	8b 00                	mov    (%rax),%eax
  80064e:	83 f8 30             	cmp    $0x30,%eax
  800651:	73 24                	jae    800677 <getint+0x44>
  800653:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800657:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80065b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80065f:	8b 00                	mov    (%rax),%eax
  800661:	89 c0                	mov    %eax,%eax
  800663:	48 01 d0             	add    %rdx,%rax
  800666:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80066a:	8b 12                	mov    (%rdx),%edx
  80066c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80066f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800673:	89 0a                	mov    %ecx,(%rdx)
  800675:	eb 17                	jmp    80068e <getint+0x5b>
  800677:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80067b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80067f:	48 89 d0             	mov    %rdx,%rax
  800682:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800686:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80068a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80068e:	48 8b 00             	mov    (%rax),%rax
  800691:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800695:	e9 a3 00 00 00       	jmpq   80073d <getint+0x10a>
	else if (lflag)
  80069a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80069e:	74 4f                	je     8006ef <getint+0xbc>
		x=va_arg(*ap, long);
  8006a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a4:	8b 00                	mov    (%rax),%eax
  8006a6:	83 f8 30             	cmp    $0x30,%eax
  8006a9:	73 24                	jae    8006cf <getint+0x9c>
  8006ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006af:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b7:	8b 00                	mov    (%rax),%eax
  8006b9:	89 c0                	mov    %eax,%eax
  8006bb:	48 01 d0             	add    %rdx,%rax
  8006be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c2:	8b 12                	mov    (%rdx),%edx
  8006c4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006c7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006cb:	89 0a                	mov    %ecx,(%rdx)
  8006cd:	eb 17                	jmp    8006e6 <getint+0xb3>
  8006cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006d7:	48 89 d0             	mov    %rdx,%rax
  8006da:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006de:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006e2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006e6:	48 8b 00             	mov    (%rax),%rax
  8006e9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006ed:	eb 4e                	jmp    80073d <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8006ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f3:	8b 00                	mov    (%rax),%eax
  8006f5:	83 f8 30             	cmp    $0x30,%eax
  8006f8:	73 24                	jae    80071e <getint+0xeb>
  8006fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006fe:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800702:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800706:	8b 00                	mov    (%rax),%eax
  800708:	89 c0                	mov    %eax,%eax
  80070a:	48 01 d0             	add    %rdx,%rax
  80070d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800711:	8b 12                	mov    (%rdx),%edx
  800713:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800716:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80071a:	89 0a                	mov    %ecx,(%rdx)
  80071c:	eb 17                	jmp    800735 <getint+0x102>
  80071e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800722:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800726:	48 89 d0             	mov    %rdx,%rax
  800729:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80072d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800731:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800735:	8b 00                	mov    (%rax),%eax
  800737:	48 98                	cltq   
  800739:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80073d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800741:	c9                   	leaveq 
  800742:	c3                   	retq   

0000000000800743 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800743:	55                   	push   %rbp
  800744:	48 89 e5             	mov    %rsp,%rbp
  800747:	41 54                	push   %r12
  800749:	53                   	push   %rbx
  80074a:	48 83 ec 60          	sub    $0x60,%rsp
  80074e:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800752:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800756:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80075a:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80075e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800762:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800766:	48 8b 0a             	mov    (%rdx),%rcx
  800769:	48 89 08             	mov    %rcx,(%rax)
  80076c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800770:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800774:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800778:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80077c:	eb 17                	jmp    800795 <vprintfmt+0x52>
			if (ch == '\0')
  80077e:	85 db                	test   %ebx,%ebx
  800780:	0f 84 cc 04 00 00    	je     800c52 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800786:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80078a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80078e:	48 89 d6             	mov    %rdx,%rsi
  800791:	89 df                	mov    %ebx,%edi
  800793:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800795:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800799:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80079d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8007a1:	0f b6 00             	movzbl (%rax),%eax
  8007a4:	0f b6 d8             	movzbl %al,%ebx
  8007a7:	83 fb 25             	cmp    $0x25,%ebx
  8007aa:	75 d2                	jne    80077e <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007ac:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8007b0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8007b7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8007be:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8007c5:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007cc:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007d0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8007d4:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8007d8:	0f b6 00             	movzbl (%rax),%eax
  8007db:	0f b6 d8             	movzbl %al,%ebx
  8007de:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8007e1:	83 f8 55             	cmp    $0x55,%eax
  8007e4:	0f 87 34 04 00 00    	ja     800c1e <vprintfmt+0x4db>
  8007ea:	89 c0                	mov    %eax,%eax
  8007ec:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8007f3:	00 
  8007f4:	48 b8 38 48 80 00 00 	movabs $0x804838,%rax
  8007fb:	00 00 00 
  8007fe:	48 01 d0             	add    %rdx,%rax
  800801:	48 8b 00             	mov    (%rax),%rax
  800804:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800806:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80080a:	eb c0                	jmp    8007cc <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80080c:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800810:	eb ba                	jmp    8007cc <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800812:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800819:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80081c:	89 d0                	mov    %edx,%eax
  80081e:	c1 e0 02             	shl    $0x2,%eax
  800821:	01 d0                	add    %edx,%eax
  800823:	01 c0                	add    %eax,%eax
  800825:	01 d8                	add    %ebx,%eax
  800827:	83 e8 30             	sub    $0x30,%eax
  80082a:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80082d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800831:	0f b6 00             	movzbl (%rax),%eax
  800834:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800837:	83 fb 2f             	cmp    $0x2f,%ebx
  80083a:	7e 0c                	jle    800848 <vprintfmt+0x105>
  80083c:	83 fb 39             	cmp    $0x39,%ebx
  80083f:	7f 07                	jg     800848 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800841:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800846:	eb d1                	jmp    800819 <vprintfmt+0xd6>
			goto process_precision;
  800848:	eb 58                	jmp    8008a2 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  80084a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80084d:	83 f8 30             	cmp    $0x30,%eax
  800850:	73 17                	jae    800869 <vprintfmt+0x126>
  800852:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800856:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800859:	89 c0                	mov    %eax,%eax
  80085b:	48 01 d0             	add    %rdx,%rax
  80085e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800861:	83 c2 08             	add    $0x8,%edx
  800864:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800867:	eb 0f                	jmp    800878 <vprintfmt+0x135>
  800869:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80086d:	48 89 d0             	mov    %rdx,%rax
  800870:	48 83 c2 08          	add    $0x8,%rdx
  800874:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800878:	8b 00                	mov    (%rax),%eax
  80087a:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80087d:	eb 23                	jmp    8008a2 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80087f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800883:	79 0c                	jns    800891 <vprintfmt+0x14e>
				width = 0;
  800885:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80088c:	e9 3b ff ff ff       	jmpq   8007cc <vprintfmt+0x89>
  800891:	e9 36 ff ff ff       	jmpq   8007cc <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800896:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80089d:	e9 2a ff ff ff       	jmpq   8007cc <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8008a2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008a6:	79 12                	jns    8008ba <vprintfmt+0x177>
				width = precision, precision = -1;
  8008a8:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8008ab:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8008ae:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8008b5:	e9 12 ff ff ff       	jmpq   8007cc <vprintfmt+0x89>
  8008ba:	e9 0d ff ff ff       	jmpq   8007cc <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008bf:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8008c3:	e9 04 ff ff ff       	jmpq   8007cc <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8008c8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008cb:	83 f8 30             	cmp    $0x30,%eax
  8008ce:	73 17                	jae    8008e7 <vprintfmt+0x1a4>
  8008d0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008d4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008d7:	89 c0                	mov    %eax,%eax
  8008d9:	48 01 d0             	add    %rdx,%rax
  8008dc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008df:	83 c2 08             	add    $0x8,%edx
  8008e2:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008e5:	eb 0f                	jmp    8008f6 <vprintfmt+0x1b3>
  8008e7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008eb:	48 89 d0             	mov    %rdx,%rax
  8008ee:	48 83 c2 08          	add    $0x8,%rdx
  8008f2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008f6:	8b 10                	mov    (%rax),%edx
  8008f8:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8008fc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800900:	48 89 ce             	mov    %rcx,%rsi
  800903:	89 d7                	mov    %edx,%edi
  800905:	ff d0                	callq  *%rax
			break;
  800907:	e9 40 03 00 00       	jmpq   800c4c <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  80090c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80090f:	83 f8 30             	cmp    $0x30,%eax
  800912:	73 17                	jae    80092b <vprintfmt+0x1e8>
  800914:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800918:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80091b:	89 c0                	mov    %eax,%eax
  80091d:	48 01 d0             	add    %rdx,%rax
  800920:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800923:	83 c2 08             	add    $0x8,%edx
  800926:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800929:	eb 0f                	jmp    80093a <vprintfmt+0x1f7>
  80092b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80092f:	48 89 d0             	mov    %rdx,%rax
  800932:	48 83 c2 08          	add    $0x8,%rdx
  800936:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80093a:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  80093c:	85 db                	test   %ebx,%ebx
  80093e:	79 02                	jns    800942 <vprintfmt+0x1ff>
				err = -err;
  800940:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800942:	83 fb 15             	cmp    $0x15,%ebx
  800945:	7f 16                	jg     80095d <vprintfmt+0x21a>
  800947:	48 b8 60 47 80 00 00 	movabs $0x804760,%rax
  80094e:	00 00 00 
  800951:	48 63 d3             	movslq %ebx,%rdx
  800954:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800958:	4d 85 e4             	test   %r12,%r12
  80095b:	75 2e                	jne    80098b <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  80095d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800961:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800965:	89 d9                	mov    %ebx,%ecx
  800967:	48 ba 21 48 80 00 00 	movabs $0x804821,%rdx
  80096e:	00 00 00 
  800971:	48 89 c7             	mov    %rax,%rdi
  800974:	b8 00 00 00 00       	mov    $0x0,%eax
  800979:	49 b8 5b 0c 80 00 00 	movabs $0x800c5b,%r8
  800980:	00 00 00 
  800983:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800986:	e9 c1 02 00 00       	jmpq   800c4c <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80098b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80098f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800993:	4c 89 e1             	mov    %r12,%rcx
  800996:	48 ba 2a 48 80 00 00 	movabs $0x80482a,%rdx
  80099d:	00 00 00 
  8009a0:	48 89 c7             	mov    %rax,%rdi
  8009a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8009a8:	49 b8 5b 0c 80 00 00 	movabs $0x800c5b,%r8
  8009af:	00 00 00 
  8009b2:	41 ff d0             	callq  *%r8
			break;
  8009b5:	e9 92 02 00 00       	jmpq   800c4c <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8009ba:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009bd:	83 f8 30             	cmp    $0x30,%eax
  8009c0:	73 17                	jae    8009d9 <vprintfmt+0x296>
  8009c2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009c6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009c9:	89 c0                	mov    %eax,%eax
  8009cb:	48 01 d0             	add    %rdx,%rax
  8009ce:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009d1:	83 c2 08             	add    $0x8,%edx
  8009d4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009d7:	eb 0f                	jmp    8009e8 <vprintfmt+0x2a5>
  8009d9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009dd:	48 89 d0             	mov    %rdx,%rax
  8009e0:	48 83 c2 08          	add    $0x8,%rdx
  8009e4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009e8:	4c 8b 20             	mov    (%rax),%r12
  8009eb:	4d 85 e4             	test   %r12,%r12
  8009ee:	75 0a                	jne    8009fa <vprintfmt+0x2b7>
				p = "(null)";
  8009f0:	49 bc 2d 48 80 00 00 	movabs $0x80482d,%r12
  8009f7:	00 00 00 
			if (width > 0 && padc != '-')
  8009fa:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009fe:	7e 3f                	jle    800a3f <vprintfmt+0x2fc>
  800a00:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800a04:	74 39                	je     800a3f <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a06:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a09:	48 98                	cltq   
  800a0b:	48 89 c6             	mov    %rax,%rsi
  800a0e:	4c 89 e7             	mov    %r12,%rdi
  800a11:	48 b8 07 0f 80 00 00 	movabs $0x800f07,%rax
  800a18:	00 00 00 
  800a1b:	ff d0                	callq  *%rax
  800a1d:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800a20:	eb 17                	jmp    800a39 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800a22:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800a26:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a2a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a2e:	48 89 ce             	mov    %rcx,%rsi
  800a31:	89 d7                	mov    %edx,%edi
  800a33:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a35:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a39:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a3d:	7f e3                	jg     800a22 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a3f:	eb 37                	jmp    800a78 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800a41:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800a45:	74 1e                	je     800a65 <vprintfmt+0x322>
  800a47:	83 fb 1f             	cmp    $0x1f,%ebx
  800a4a:	7e 05                	jle    800a51 <vprintfmt+0x30e>
  800a4c:	83 fb 7e             	cmp    $0x7e,%ebx
  800a4f:	7e 14                	jle    800a65 <vprintfmt+0x322>
					putch('?', putdat);
  800a51:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a55:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a59:	48 89 d6             	mov    %rdx,%rsi
  800a5c:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800a61:	ff d0                	callq  *%rax
  800a63:	eb 0f                	jmp    800a74 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800a65:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a69:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a6d:	48 89 d6             	mov    %rdx,%rsi
  800a70:	89 df                	mov    %ebx,%edi
  800a72:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a74:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a78:	4c 89 e0             	mov    %r12,%rax
  800a7b:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800a7f:	0f b6 00             	movzbl (%rax),%eax
  800a82:	0f be d8             	movsbl %al,%ebx
  800a85:	85 db                	test   %ebx,%ebx
  800a87:	74 10                	je     800a99 <vprintfmt+0x356>
  800a89:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a8d:	78 b2                	js     800a41 <vprintfmt+0x2fe>
  800a8f:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800a93:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a97:	79 a8                	jns    800a41 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a99:	eb 16                	jmp    800ab1 <vprintfmt+0x36e>
				putch(' ', putdat);
  800a9b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a9f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aa3:	48 89 d6             	mov    %rdx,%rsi
  800aa6:	bf 20 00 00 00       	mov    $0x20,%edi
  800aab:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800aad:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ab1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ab5:	7f e4                	jg     800a9b <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800ab7:	e9 90 01 00 00       	jmpq   800c4c <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800abc:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ac0:	be 03 00 00 00       	mov    $0x3,%esi
  800ac5:	48 89 c7             	mov    %rax,%rdi
  800ac8:	48 b8 33 06 80 00 00 	movabs $0x800633,%rax
  800acf:	00 00 00 
  800ad2:	ff d0                	callq  *%rax
  800ad4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800ad8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800adc:	48 85 c0             	test   %rax,%rax
  800adf:	79 1d                	jns    800afe <vprintfmt+0x3bb>
				putch('-', putdat);
  800ae1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ae5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ae9:	48 89 d6             	mov    %rdx,%rsi
  800aec:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800af1:	ff d0                	callq  *%rax
				num = -(long long) num;
  800af3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800af7:	48 f7 d8             	neg    %rax
  800afa:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800afe:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b05:	e9 d5 00 00 00       	jmpq   800bdf <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800b0a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b0e:	be 03 00 00 00       	mov    $0x3,%esi
  800b13:	48 89 c7             	mov    %rax,%rdi
  800b16:	48 b8 23 05 80 00 00 	movabs $0x800523,%rax
  800b1d:	00 00 00 
  800b20:	ff d0                	callq  *%rax
  800b22:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800b26:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b2d:	e9 ad 00 00 00       	jmpq   800bdf <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800b32:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800b35:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b39:	89 d6                	mov    %edx,%esi
  800b3b:	48 89 c7             	mov    %rax,%rdi
  800b3e:	48 b8 33 06 80 00 00 	movabs $0x800633,%rax
  800b45:	00 00 00 
  800b48:	ff d0                	callq  *%rax
  800b4a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800b4e:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800b55:	e9 85 00 00 00       	jmpq   800bdf <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800b5a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b5e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b62:	48 89 d6             	mov    %rdx,%rsi
  800b65:	bf 30 00 00 00       	mov    $0x30,%edi
  800b6a:	ff d0                	callq  *%rax
			putch('x', putdat);
  800b6c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b70:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b74:	48 89 d6             	mov    %rdx,%rsi
  800b77:	bf 78 00 00 00       	mov    $0x78,%edi
  800b7c:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800b7e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b81:	83 f8 30             	cmp    $0x30,%eax
  800b84:	73 17                	jae    800b9d <vprintfmt+0x45a>
  800b86:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b8a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b8d:	89 c0                	mov    %eax,%eax
  800b8f:	48 01 d0             	add    %rdx,%rax
  800b92:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b95:	83 c2 08             	add    $0x8,%edx
  800b98:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b9b:	eb 0f                	jmp    800bac <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800b9d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ba1:	48 89 d0             	mov    %rdx,%rax
  800ba4:	48 83 c2 08          	add    $0x8,%rdx
  800ba8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bac:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800baf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800bb3:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800bba:	eb 23                	jmp    800bdf <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800bbc:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bc0:	be 03 00 00 00       	mov    $0x3,%esi
  800bc5:	48 89 c7             	mov    %rax,%rdi
  800bc8:	48 b8 23 05 80 00 00 	movabs $0x800523,%rax
  800bcf:	00 00 00 
  800bd2:	ff d0                	callq  *%rax
  800bd4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800bd8:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bdf:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800be4:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800be7:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800bea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bee:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800bf2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bf6:	45 89 c1             	mov    %r8d,%r9d
  800bf9:	41 89 f8             	mov    %edi,%r8d
  800bfc:	48 89 c7             	mov    %rax,%rdi
  800bff:	48 b8 68 04 80 00 00 	movabs $0x800468,%rax
  800c06:	00 00 00 
  800c09:	ff d0                	callq  *%rax
			break;
  800c0b:	eb 3f                	jmp    800c4c <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c0d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c11:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c15:	48 89 d6             	mov    %rdx,%rsi
  800c18:	89 df                	mov    %ebx,%edi
  800c1a:	ff d0                	callq  *%rax
			break;
  800c1c:	eb 2e                	jmp    800c4c <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c1e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c22:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c26:	48 89 d6             	mov    %rdx,%rsi
  800c29:	bf 25 00 00 00       	mov    $0x25,%edi
  800c2e:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c30:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c35:	eb 05                	jmp    800c3c <vprintfmt+0x4f9>
  800c37:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c3c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c40:	48 83 e8 01          	sub    $0x1,%rax
  800c44:	0f b6 00             	movzbl (%rax),%eax
  800c47:	3c 25                	cmp    $0x25,%al
  800c49:	75 ec                	jne    800c37 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800c4b:	90                   	nop
		}
	}
  800c4c:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c4d:	e9 43 fb ff ff       	jmpq   800795 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800c52:	48 83 c4 60          	add    $0x60,%rsp
  800c56:	5b                   	pop    %rbx
  800c57:	41 5c                	pop    %r12
  800c59:	5d                   	pop    %rbp
  800c5a:	c3                   	retq   

0000000000800c5b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c5b:	55                   	push   %rbp
  800c5c:	48 89 e5             	mov    %rsp,%rbp
  800c5f:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800c66:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800c6d:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800c74:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800c7b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800c82:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800c89:	84 c0                	test   %al,%al
  800c8b:	74 20                	je     800cad <printfmt+0x52>
  800c8d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800c91:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800c95:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800c99:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800c9d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800ca1:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800ca5:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ca9:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800cad:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800cb4:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800cbb:	00 00 00 
  800cbe:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800cc5:	00 00 00 
  800cc8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ccc:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800cd3:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800cda:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800ce1:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800ce8:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800cef:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800cf6:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800cfd:	48 89 c7             	mov    %rax,%rdi
  800d00:	48 b8 43 07 80 00 00 	movabs $0x800743,%rax
  800d07:	00 00 00 
  800d0a:	ff d0                	callq  *%rax
	va_end(ap);
}
  800d0c:	c9                   	leaveq 
  800d0d:	c3                   	retq   

0000000000800d0e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d0e:	55                   	push   %rbp
  800d0f:	48 89 e5             	mov    %rsp,%rbp
  800d12:	48 83 ec 10          	sub    $0x10,%rsp
  800d16:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d19:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800d1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d21:	8b 40 10             	mov    0x10(%rax),%eax
  800d24:	8d 50 01             	lea    0x1(%rax),%edx
  800d27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d2b:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800d2e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d32:	48 8b 10             	mov    (%rax),%rdx
  800d35:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d39:	48 8b 40 08          	mov    0x8(%rax),%rax
  800d3d:	48 39 c2             	cmp    %rax,%rdx
  800d40:	73 17                	jae    800d59 <sprintputch+0x4b>
		*b->buf++ = ch;
  800d42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d46:	48 8b 00             	mov    (%rax),%rax
  800d49:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800d4d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d51:	48 89 0a             	mov    %rcx,(%rdx)
  800d54:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800d57:	88 10                	mov    %dl,(%rax)
}
  800d59:	c9                   	leaveq 
  800d5a:	c3                   	retq   

0000000000800d5b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d5b:	55                   	push   %rbp
  800d5c:	48 89 e5             	mov    %rsp,%rbp
  800d5f:	48 83 ec 50          	sub    $0x50,%rsp
  800d63:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800d67:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800d6a:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800d6e:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800d72:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800d76:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800d7a:	48 8b 0a             	mov    (%rdx),%rcx
  800d7d:	48 89 08             	mov    %rcx,(%rax)
  800d80:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d84:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d88:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d8c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d90:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d94:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800d98:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800d9b:	48 98                	cltq   
  800d9d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800da1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800da5:	48 01 d0             	add    %rdx,%rax
  800da8:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800dac:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800db3:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800db8:	74 06                	je     800dc0 <vsnprintf+0x65>
  800dba:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800dbe:	7f 07                	jg     800dc7 <vsnprintf+0x6c>
		return -E_INVAL;
  800dc0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800dc5:	eb 2f                	jmp    800df6 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800dc7:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800dcb:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800dcf:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800dd3:	48 89 c6             	mov    %rax,%rsi
  800dd6:	48 bf 0e 0d 80 00 00 	movabs $0x800d0e,%rdi
  800ddd:	00 00 00 
  800de0:	48 b8 43 07 80 00 00 	movabs $0x800743,%rax
  800de7:	00 00 00 
  800dea:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800dec:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800df0:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800df3:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800df6:	c9                   	leaveq 
  800df7:	c3                   	retq   

0000000000800df8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800df8:	55                   	push   %rbp
  800df9:	48 89 e5             	mov    %rsp,%rbp
  800dfc:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800e03:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800e0a:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800e10:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e17:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e1e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e25:	84 c0                	test   %al,%al
  800e27:	74 20                	je     800e49 <snprintf+0x51>
  800e29:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e2d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e31:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e35:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e39:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e3d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e41:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e45:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e49:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800e50:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800e57:	00 00 00 
  800e5a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800e61:	00 00 00 
  800e64:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e68:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800e6f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e76:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800e7d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800e84:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800e8b:	48 8b 0a             	mov    (%rdx),%rcx
  800e8e:	48 89 08             	mov    %rcx,(%rax)
  800e91:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e95:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e99:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e9d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800ea1:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800ea8:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800eaf:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800eb5:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800ebc:	48 89 c7             	mov    %rax,%rdi
  800ebf:	48 b8 5b 0d 80 00 00 	movabs $0x800d5b,%rax
  800ec6:	00 00 00 
  800ec9:	ff d0                	callq  *%rax
  800ecb:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800ed1:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800ed7:	c9                   	leaveq 
  800ed8:	c3                   	retq   

0000000000800ed9 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ed9:	55                   	push   %rbp
  800eda:	48 89 e5             	mov    %rsp,%rbp
  800edd:	48 83 ec 18          	sub    $0x18,%rsp
  800ee1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800ee5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800eec:	eb 09                	jmp    800ef7 <strlen+0x1e>
		n++;
  800eee:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ef2:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800ef7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800efb:	0f b6 00             	movzbl (%rax),%eax
  800efe:	84 c0                	test   %al,%al
  800f00:	75 ec                	jne    800eee <strlen+0x15>
		n++;
	return n;
  800f02:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f05:	c9                   	leaveq 
  800f06:	c3                   	retq   

0000000000800f07 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800f07:	55                   	push   %rbp
  800f08:	48 89 e5             	mov    %rsp,%rbp
  800f0b:	48 83 ec 20          	sub    $0x20,%rsp
  800f0f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f13:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f17:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f1e:	eb 0e                	jmp    800f2e <strnlen+0x27>
		n++;
  800f20:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f24:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f29:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800f2e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800f33:	74 0b                	je     800f40 <strnlen+0x39>
  800f35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f39:	0f b6 00             	movzbl (%rax),%eax
  800f3c:	84 c0                	test   %al,%al
  800f3e:	75 e0                	jne    800f20 <strnlen+0x19>
		n++;
	return n;
  800f40:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f43:	c9                   	leaveq 
  800f44:	c3                   	retq   

0000000000800f45 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f45:	55                   	push   %rbp
  800f46:	48 89 e5             	mov    %rsp,%rbp
  800f49:	48 83 ec 20          	sub    $0x20,%rsp
  800f4d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f51:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800f55:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f59:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800f5d:	90                   	nop
  800f5e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f62:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f66:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f6a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f6e:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f72:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f76:	0f b6 12             	movzbl (%rdx),%edx
  800f79:	88 10                	mov    %dl,(%rax)
  800f7b:	0f b6 00             	movzbl (%rax),%eax
  800f7e:	84 c0                	test   %al,%al
  800f80:	75 dc                	jne    800f5e <strcpy+0x19>
		/* do nothing */;
	return ret;
  800f82:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800f86:	c9                   	leaveq 
  800f87:	c3                   	retq   

0000000000800f88 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800f88:	55                   	push   %rbp
  800f89:	48 89 e5             	mov    %rsp,%rbp
  800f8c:	48 83 ec 20          	sub    $0x20,%rsp
  800f90:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f94:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800f98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f9c:	48 89 c7             	mov    %rax,%rdi
  800f9f:	48 b8 d9 0e 80 00 00 	movabs $0x800ed9,%rax
  800fa6:	00 00 00 
  800fa9:	ff d0                	callq  *%rax
  800fab:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800fae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fb1:	48 63 d0             	movslq %eax,%rdx
  800fb4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fb8:	48 01 c2             	add    %rax,%rdx
  800fbb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fbf:	48 89 c6             	mov    %rax,%rsi
  800fc2:	48 89 d7             	mov    %rdx,%rdi
  800fc5:	48 b8 45 0f 80 00 00 	movabs $0x800f45,%rax
  800fcc:	00 00 00 
  800fcf:	ff d0                	callq  *%rax
	return dst;
  800fd1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800fd5:	c9                   	leaveq 
  800fd6:	c3                   	retq   

0000000000800fd7 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800fd7:	55                   	push   %rbp
  800fd8:	48 89 e5             	mov    %rsp,%rbp
  800fdb:	48 83 ec 28          	sub    $0x28,%rsp
  800fdf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fe3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800fe7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800feb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fef:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800ff3:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800ffa:	00 
  800ffb:	eb 2a                	jmp    801027 <strncpy+0x50>
		*dst++ = *src;
  800ffd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801001:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801005:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801009:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80100d:	0f b6 12             	movzbl (%rdx),%edx
  801010:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801012:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801016:	0f b6 00             	movzbl (%rax),%eax
  801019:	84 c0                	test   %al,%al
  80101b:	74 05                	je     801022 <strncpy+0x4b>
			src++;
  80101d:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801022:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801027:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80102b:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80102f:	72 cc                	jb     800ffd <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801031:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801035:	c9                   	leaveq 
  801036:	c3                   	retq   

0000000000801037 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801037:	55                   	push   %rbp
  801038:	48 89 e5             	mov    %rsp,%rbp
  80103b:	48 83 ec 28          	sub    $0x28,%rsp
  80103f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801043:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801047:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80104b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80104f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801053:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801058:	74 3d                	je     801097 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80105a:	eb 1d                	jmp    801079 <strlcpy+0x42>
			*dst++ = *src++;
  80105c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801060:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801064:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801068:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80106c:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801070:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801074:	0f b6 12             	movzbl (%rdx),%edx
  801077:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801079:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80107e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801083:	74 0b                	je     801090 <strlcpy+0x59>
  801085:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801089:	0f b6 00             	movzbl (%rax),%eax
  80108c:	84 c0                	test   %al,%al
  80108e:	75 cc                	jne    80105c <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801090:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801094:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801097:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80109b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80109f:	48 29 c2             	sub    %rax,%rdx
  8010a2:	48 89 d0             	mov    %rdx,%rax
}
  8010a5:	c9                   	leaveq 
  8010a6:	c3                   	retq   

00000000008010a7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010a7:	55                   	push   %rbp
  8010a8:	48 89 e5             	mov    %rsp,%rbp
  8010ab:	48 83 ec 10          	sub    $0x10,%rsp
  8010af:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010b3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8010b7:	eb 0a                	jmp    8010c3 <strcmp+0x1c>
		p++, q++;
  8010b9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010be:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8010c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010c7:	0f b6 00             	movzbl (%rax),%eax
  8010ca:	84 c0                	test   %al,%al
  8010cc:	74 12                	je     8010e0 <strcmp+0x39>
  8010ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010d2:	0f b6 10             	movzbl (%rax),%edx
  8010d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010d9:	0f b6 00             	movzbl (%rax),%eax
  8010dc:	38 c2                	cmp    %al,%dl
  8010de:	74 d9                	je     8010b9 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8010e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010e4:	0f b6 00             	movzbl (%rax),%eax
  8010e7:	0f b6 d0             	movzbl %al,%edx
  8010ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010ee:	0f b6 00             	movzbl (%rax),%eax
  8010f1:	0f b6 c0             	movzbl %al,%eax
  8010f4:	29 c2                	sub    %eax,%edx
  8010f6:	89 d0                	mov    %edx,%eax
}
  8010f8:	c9                   	leaveq 
  8010f9:	c3                   	retq   

00000000008010fa <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8010fa:	55                   	push   %rbp
  8010fb:	48 89 e5             	mov    %rsp,%rbp
  8010fe:	48 83 ec 18          	sub    $0x18,%rsp
  801102:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801106:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80110a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80110e:	eb 0f                	jmp    80111f <strncmp+0x25>
		n--, p++, q++;
  801110:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801115:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80111a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80111f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801124:	74 1d                	je     801143 <strncmp+0x49>
  801126:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80112a:	0f b6 00             	movzbl (%rax),%eax
  80112d:	84 c0                	test   %al,%al
  80112f:	74 12                	je     801143 <strncmp+0x49>
  801131:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801135:	0f b6 10             	movzbl (%rax),%edx
  801138:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80113c:	0f b6 00             	movzbl (%rax),%eax
  80113f:	38 c2                	cmp    %al,%dl
  801141:	74 cd                	je     801110 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801143:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801148:	75 07                	jne    801151 <strncmp+0x57>
		return 0;
  80114a:	b8 00 00 00 00       	mov    $0x0,%eax
  80114f:	eb 18                	jmp    801169 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801151:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801155:	0f b6 00             	movzbl (%rax),%eax
  801158:	0f b6 d0             	movzbl %al,%edx
  80115b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80115f:	0f b6 00             	movzbl (%rax),%eax
  801162:	0f b6 c0             	movzbl %al,%eax
  801165:	29 c2                	sub    %eax,%edx
  801167:	89 d0                	mov    %edx,%eax
}
  801169:	c9                   	leaveq 
  80116a:	c3                   	retq   

000000000080116b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80116b:	55                   	push   %rbp
  80116c:	48 89 e5             	mov    %rsp,%rbp
  80116f:	48 83 ec 0c          	sub    $0xc,%rsp
  801173:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801177:	89 f0                	mov    %esi,%eax
  801179:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80117c:	eb 17                	jmp    801195 <strchr+0x2a>
		if (*s == c)
  80117e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801182:	0f b6 00             	movzbl (%rax),%eax
  801185:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801188:	75 06                	jne    801190 <strchr+0x25>
			return (char *) s;
  80118a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80118e:	eb 15                	jmp    8011a5 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801190:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801195:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801199:	0f b6 00             	movzbl (%rax),%eax
  80119c:	84 c0                	test   %al,%al
  80119e:	75 de                	jne    80117e <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8011a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011a5:	c9                   	leaveq 
  8011a6:	c3                   	retq   

00000000008011a7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011a7:	55                   	push   %rbp
  8011a8:	48 89 e5             	mov    %rsp,%rbp
  8011ab:	48 83 ec 0c          	sub    $0xc,%rsp
  8011af:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011b3:	89 f0                	mov    %esi,%eax
  8011b5:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8011b8:	eb 13                	jmp    8011cd <strfind+0x26>
		if (*s == c)
  8011ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011be:	0f b6 00             	movzbl (%rax),%eax
  8011c1:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8011c4:	75 02                	jne    8011c8 <strfind+0x21>
			break;
  8011c6:	eb 10                	jmp    8011d8 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011c8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d1:	0f b6 00             	movzbl (%rax),%eax
  8011d4:	84 c0                	test   %al,%al
  8011d6:	75 e2                	jne    8011ba <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8011d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011dc:	c9                   	leaveq 
  8011dd:	c3                   	retq   

00000000008011de <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8011de:	55                   	push   %rbp
  8011df:	48 89 e5             	mov    %rsp,%rbp
  8011e2:	48 83 ec 18          	sub    $0x18,%rsp
  8011e6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011ea:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8011ed:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8011f1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8011f6:	75 06                	jne    8011fe <memset+0x20>
		return v;
  8011f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011fc:	eb 69                	jmp    801267 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8011fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801202:	83 e0 03             	and    $0x3,%eax
  801205:	48 85 c0             	test   %rax,%rax
  801208:	75 48                	jne    801252 <memset+0x74>
  80120a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80120e:	83 e0 03             	and    $0x3,%eax
  801211:	48 85 c0             	test   %rax,%rax
  801214:	75 3c                	jne    801252 <memset+0x74>
		c &= 0xFF;
  801216:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80121d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801220:	c1 e0 18             	shl    $0x18,%eax
  801223:	89 c2                	mov    %eax,%edx
  801225:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801228:	c1 e0 10             	shl    $0x10,%eax
  80122b:	09 c2                	or     %eax,%edx
  80122d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801230:	c1 e0 08             	shl    $0x8,%eax
  801233:	09 d0                	or     %edx,%eax
  801235:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801238:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80123c:	48 c1 e8 02          	shr    $0x2,%rax
  801240:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801243:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801247:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80124a:	48 89 d7             	mov    %rdx,%rdi
  80124d:	fc                   	cld    
  80124e:	f3 ab                	rep stos %eax,%es:(%rdi)
  801250:	eb 11                	jmp    801263 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801252:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801256:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801259:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80125d:	48 89 d7             	mov    %rdx,%rdi
  801260:	fc                   	cld    
  801261:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801263:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801267:	c9                   	leaveq 
  801268:	c3                   	retq   

0000000000801269 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801269:	55                   	push   %rbp
  80126a:	48 89 e5             	mov    %rsp,%rbp
  80126d:	48 83 ec 28          	sub    $0x28,%rsp
  801271:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801275:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801279:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80127d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801281:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801285:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801289:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80128d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801291:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801295:	0f 83 88 00 00 00    	jae    801323 <memmove+0xba>
  80129b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80129f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012a3:	48 01 d0             	add    %rdx,%rax
  8012a6:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8012aa:	76 77                	jbe    801323 <memmove+0xba>
		s += n;
  8012ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012b0:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8012b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012b8:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8012bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c0:	83 e0 03             	and    $0x3,%eax
  8012c3:	48 85 c0             	test   %rax,%rax
  8012c6:	75 3b                	jne    801303 <memmove+0x9a>
  8012c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012cc:	83 e0 03             	and    $0x3,%eax
  8012cf:	48 85 c0             	test   %rax,%rax
  8012d2:	75 2f                	jne    801303 <memmove+0x9a>
  8012d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012d8:	83 e0 03             	and    $0x3,%eax
  8012db:	48 85 c0             	test   %rax,%rax
  8012de:	75 23                	jne    801303 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8012e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012e4:	48 83 e8 04          	sub    $0x4,%rax
  8012e8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012ec:	48 83 ea 04          	sub    $0x4,%rdx
  8012f0:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8012f4:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8012f8:	48 89 c7             	mov    %rax,%rdi
  8012fb:	48 89 d6             	mov    %rdx,%rsi
  8012fe:	fd                   	std    
  8012ff:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801301:	eb 1d                	jmp    801320 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801303:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801307:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80130b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80130f:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801313:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801317:	48 89 d7             	mov    %rdx,%rdi
  80131a:	48 89 c1             	mov    %rax,%rcx
  80131d:	fd                   	std    
  80131e:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801320:	fc                   	cld    
  801321:	eb 57                	jmp    80137a <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801323:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801327:	83 e0 03             	and    $0x3,%eax
  80132a:	48 85 c0             	test   %rax,%rax
  80132d:	75 36                	jne    801365 <memmove+0xfc>
  80132f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801333:	83 e0 03             	and    $0x3,%eax
  801336:	48 85 c0             	test   %rax,%rax
  801339:	75 2a                	jne    801365 <memmove+0xfc>
  80133b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80133f:	83 e0 03             	and    $0x3,%eax
  801342:	48 85 c0             	test   %rax,%rax
  801345:	75 1e                	jne    801365 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801347:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80134b:	48 c1 e8 02          	shr    $0x2,%rax
  80134f:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801352:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801356:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80135a:	48 89 c7             	mov    %rax,%rdi
  80135d:	48 89 d6             	mov    %rdx,%rsi
  801360:	fc                   	cld    
  801361:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801363:	eb 15                	jmp    80137a <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801365:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801369:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80136d:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801371:	48 89 c7             	mov    %rax,%rdi
  801374:	48 89 d6             	mov    %rdx,%rsi
  801377:	fc                   	cld    
  801378:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80137a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80137e:	c9                   	leaveq 
  80137f:	c3                   	retq   

0000000000801380 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801380:	55                   	push   %rbp
  801381:	48 89 e5             	mov    %rsp,%rbp
  801384:	48 83 ec 18          	sub    $0x18,%rsp
  801388:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80138c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801390:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801394:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801398:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80139c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013a0:	48 89 ce             	mov    %rcx,%rsi
  8013a3:	48 89 c7             	mov    %rax,%rdi
  8013a6:	48 b8 69 12 80 00 00 	movabs $0x801269,%rax
  8013ad:	00 00 00 
  8013b0:	ff d0                	callq  *%rax
}
  8013b2:	c9                   	leaveq 
  8013b3:	c3                   	retq   

00000000008013b4 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8013b4:	55                   	push   %rbp
  8013b5:	48 89 e5             	mov    %rsp,%rbp
  8013b8:	48 83 ec 28          	sub    $0x28,%rsp
  8013bc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013c0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013c4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8013c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013cc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8013d0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013d4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8013d8:	eb 36                	jmp    801410 <memcmp+0x5c>
		if (*s1 != *s2)
  8013da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013de:	0f b6 10             	movzbl (%rax),%edx
  8013e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013e5:	0f b6 00             	movzbl (%rax),%eax
  8013e8:	38 c2                	cmp    %al,%dl
  8013ea:	74 1a                	je     801406 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8013ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f0:	0f b6 00             	movzbl (%rax),%eax
  8013f3:	0f b6 d0             	movzbl %al,%edx
  8013f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013fa:	0f b6 00             	movzbl (%rax),%eax
  8013fd:	0f b6 c0             	movzbl %al,%eax
  801400:	29 c2                	sub    %eax,%edx
  801402:	89 d0                	mov    %edx,%eax
  801404:	eb 20                	jmp    801426 <memcmp+0x72>
		s1++, s2++;
  801406:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80140b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801410:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801414:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801418:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80141c:	48 85 c0             	test   %rax,%rax
  80141f:	75 b9                	jne    8013da <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801421:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801426:	c9                   	leaveq 
  801427:	c3                   	retq   

0000000000801428 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801428:	55                   	push   %rbp
  801429:	48 89 e5             	mov    %rsp,%rbp
  80142c:	48 83 ec 28          	sub    $0x28,%rsp
  801430:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801434:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801437:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80143b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80143f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801443:	48 01 d0             	add    %rdx,%rax
  801446:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80144a:	eb 15                	jmp    801461 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80144c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801450:	0f b6 10             	movzbl (%rax),%edx
  801453:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801456:	38 c2                	cmp    %al,%dl
  801458:	75 02                	jne    80145c <memfind+0x34>
			break;
  80145a:	eb 0f                	jmp    80146b <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80145c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801461:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801465:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801469:	72 e1                	jb     80144c <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80146b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80146f:	c9                   	leaveq 
  801470:	c3                   	retq   

0000000000801471 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801471:	55                   	push   %rbp
  801472:	48 89 e5             	mov    %rsp,%rbp
  801475:	48 83 ec 34          	sub    $0x34,%rsp
  801479:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80147d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801481:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801484:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80148b:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801492:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801493:	eb 05                	jmp    80149a <strtol+0x29>
		s++;
  801495:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80149a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80149e:	0f b6 00             	movzbl (%rax),%eax
  8014a1:	3c 20                	cmp    $0x20,%al
  8014a3:	74 f0                	je     801495 <strtol+0x24>
  8014a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a9:	0f b6 00             	movzbl (%rax),%eax
  8014ac:	3c 09                	cmp    $0x9,%al
  8014ae:	74 e5                	je     801495 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8014b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b4:	0f b6 00             	movzbl (%rax),%eax
  8014b7:	3c 2b                	cmp    $0x2b,%al
  8014b9:	75 07                	jne    8014c2 <strtol+0x51>
		s++;
  8014bb:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014c0:	eb 17                	jmp    8014d9 <strtol+0x68>
	else if (*s == '-')
  8014c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c6:	0f b6 00             	movzbl (%rax),%eax
  8014c9:	3c 2d                	cmp    $0x2d,%al
  8014cb:	75 0c                	jne    8014d9 <strtol+0x68>
		s++, neg = 1;
  8014cd:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014d2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8014d9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014dd:	74 06                	je     8014e5 <strtol+0x74>
  8014df:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8014e3:	75 28                	jne    80150d <strtol+0x9c>
  8014e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e9:	0f b6 00             	movzbl (%rax),%eax
  8014ec:	3c 30                	cmp    $0x30,%al
  8014ee:	75 1d                	jne    80150d <strtol+0x9c>
  8014f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f4:	48 83 c0 01          	add    $0x1,%rax
  8014f8:	0f b6 00             	movzbl (%rax),%eax
  8014fb:	3c 78                	cmp    $0x78,%al
  8014fd:	75 0e                	jne    80150d <strtol+0x9c>
		s += 2, base = 16;
  8014ff:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801504:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80150b:	eb 2c                	jmp    801539 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80150d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801511:	75 19                	jne    80152c <strtol+0xbb>
  801513:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801517:	0f b6 00             	movzbl (%rax),%eax
  80151a:	3c 30                	cmp    $0x30,%al
  80151c:	75 0e                	jne    80152c <strtol+0xbb>
		s++, base = 8;
  80151e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801523:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80152a:	eb 0d                	jmp    801539 <strtol+0xc8>
	else if (base == 0)
  80152c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801530:	75 07                	jne    801539 <strtol+0xc8>
		base = 10;
  801532:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801539:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80153d:	0f b6 00             	movzbl (%rax),%eax
  801540:	3c 2f                	cmp    $0x2f,%al
  801542:	7e 1d                	jle    801561 <strtol+0xf0>
  801544:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801548:	0f b6 00             	movzbl (%rax),%eax
  80154b:	3c 39                	cmp    $0x39,%al
  80154d:	7f 12                	jg     801561 <strtol+0xf0>
			dig = *s - '0';
  80154f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801553:	0f b6 00             	movzbl (%rax),%eax
  801556:	0f be c0             	movsbl %al,%eax
  801559:	83 e8 30             	sub    $0x30,%eax
  80155c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80155f:	eb 4e                	jmp    8015af <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801561:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801565:	0f b6 00             	movzbl (%rax),%eax
  801568:	3c 60                	cmp    $0x60,%al
  80156a:	7e 1d                	jle    801589 <strtol+0x118>
  80156c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801570:	0f b6 00             	movzbl (%rax),%eax
  801573:	3c 7a                	cmp    $0x7a,%al
  801575:	7f 12                	jg     801589 <strtol+0x118>
			dig = *s - 'a' + 10;
  801577:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157b:	0f b6 00             	movzbl (%rax),%eax
  80157e:	0f be c0             	movsbl %al,%eax
  801581:	83 e8 57             	sub    $0x57,%eax
  801584:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801587:	eb 26                	jmp    8015af <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801589:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80158d:	0f b6 00             	movzbl (%rax),%eax
  801590:	3c 40                	cmp    $0x40,%al
  801592:	7e 48                	jle    8015dc <strtol+0x16b>
  801594:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801598:	0f b6 00             	movzbl (%rax),%eax
  80159b:	3c 5a                	cmp    $0x5a,%al
  80159d:	7f 3d                	jg     8015dc <strtol+0x16b>
			dig = *s - 'A' + 10;
  80159f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a3:	0f b6 00             	movzbl (%rax),%eax
  8015a6:	0f be c0             	movsbl %al,%eax
  8015a9:	83 e8 37             	sub    $0x37,%eax
  8015ac:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8015af:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8015b2:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8015b5:	7c 02                	jl     8015b9 <strtol+0x148>
			break;
  8015b7:	eb 23                	jmp    8015dc <strtol+0x16b>
		s++, val = (val * base) + dig;
  8015b9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015be:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8015c1:	48 98                	cltq   
  8015c3:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8015c8:	48 89 c2             	mov    %rax,%rdx
  8015cb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8015ce:	48 98                	cltq   
  8015d0:	48 01 d0             	add    %rdx,%rax
  8015d3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8015d7:	e9 5d ff ff ff       	jmpq   801539 <strtol+0xc8>

	if (endptr)
  8015dc:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8015e1:	74 0b                	je     8015ee <strtol+0x17d>
		*endptr = (char *) s;
  8015e3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015e7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8015eb:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8015ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8015f2:	74 09                	je     8015fd <strtol+0x18c>
  8015f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015f8:	48 f7 d8             	neg    %rax
  8015fb:	eb 04                	jmp    801601 <strtol+0x190>
  8015fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801601:	c9                   	leaveq 
  801602:	c3                   	retq   

0000000000801603 <strstr>:

char * strstr(const char *in, const char *str)
{
  801603:	55                   	push   %rbp
  801604:	48 89 e5             	mov    %rsp,%rbp
  801607:	48 83 ec 30          	sub    $0x30,%rsp
  80160b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80160f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801613:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801617:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80161b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80161f:	0f b6 00             	movzbl (%rax),%eax
  801622:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801625:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801629:	75 06                	jne    801631 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80162b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80162f:	eb 6b                	jmp    80169c <strstr+0x99>

	len = strlen(str);
  801631:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801635:	48 89 c7             	mov    %rax,%rdi
  801638:	48 b8 d9 0e 80 00 00 	movabs $0x800ed9,%rax
  80163f:	00 00 00 
  801642:	ff d0                	callq  *%rax
  801644:	48 98                	cltq   
  801646:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80164a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80164e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801652:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801656:	0f b6 00             	movzbl (%rax),%eax
  801659:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80165c:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801660:	75 07                	jne    801669 <strstr+0x66>
				return (char *) 0;
  801662:	b8 00 00 00 00       	mov    $0x0,%eax
  801667:	eb 33                	jmp    80169c <strstr+0x99>
		} while (sc != c);
  801669:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80166d:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801670:	75 d8                	jne    80164a <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801672:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801676:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80167a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167e:	48 89 ce             	mov    %rcx,%rsi
  801681:	48 89 c7             	mov    %rax,%rdi
  801684:	48 b8 fa 10 80 00 00 	movabs $0x8010fa,%rax
  80168b:	00 00 00 
  80168e:	ff d0                	callq  *%rax
  801690:	85 c0                	test   %eax,%eax
  801692:	75 b6                	jne    80164a <strstr+0x47>

	return (char *) (in - 1);
  801694:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801698:	48 83 e8 01          	sub    $0x1,%rax
}
  80169c:	c9                   	leaveq 
  80169d:	c3                   	retq   

000000000080169e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80169e:	55                   	push   %rbp
  80169f:	48 89 e5             	mov    %rsp,%rbp
  8016a2:	53                   	push   %rbx
  8016a3:	48 83 ec 48          	sub    $0x48,%rsp
  8016a7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8016aa:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8016ad:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8016b1:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8016b5:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8016b9:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016bd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8016c0:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8016c4:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8016c8:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8016cc:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8016d0:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8016d4:	4c 89 c3             	mov    %r8,%rbx
  8016d7:	cd 30                	int    $0x30
  8016d9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8016dd:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8016e1:	74 3e                	je     801721 <syscall+0x83>
  8016e3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8016e8:	7e 37                	jle    801721 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8016ea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016ee:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8016f1:	49 89 d0             	mov    %rdx,%r8
  8016f4:	89 c1                	mov    %eax,%ecx
  8016f6:	48 ba e8 4a 80 00 00 	movabs $0x804ae8,%rdx
  8016fd:	00 00 00 
  801700:	be 23 00 00 00       	mov    $0x23,%esi
  801705:	48 bf 05 4b 80 00 00 	movabs $0x804b05,%rdi
  80170c:	00 00 00 
  80170f:	b8 00 00 00 00       	mov    $0x0,%eax
  801714:	49 b9 20 42 80 00 00 	movabs $0x804220,%r9
  80171b:	00 00 00 
  80171e:	41 ff d1             	callq  *%r9

	return ret;
  801721:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801725:	48 83 c4 48          	add    $0x48,%rsp
  801729:	5b                   	pop    %rbx
  80172a:	5d                   	pop    %rbp
  80172b:	c3                   	retq   

000000000080172c <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80172c:	55                   	push   %rbp
  80172d:	48 89 e5             	mov    %rsp,%rbp
  801730:	48 83 ec 20          	sub    $0x20,%rsp
  801734:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801738:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80173c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801740:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801744:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80174b:	00 
  80174c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801752:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801758:	48 89 d1             	mov    %rdx,%rcx
  80175b:	48 89 c2             	mov    %rax,%rdx
  80175e:	be 00 00 00 00       	mov    $0x0,%esi
  801763:	bf 00 00 00 00       	mov    $0x0,%edi
  801768:	48 b8 9e 16 80 00 00 	movabs $0x80169e,%rax
  80176f:	00 00 00 
  801772:	ff d0                	callq  *%rax
}
  801774:	c9                   	leaveq 
  801775:	c3                   	retq   

0000000000801776 <sys_cgetc>:

int
sys_cgetc(void)
{
  801776:	55                   	push   %rbp
  801777:	48 89 e5             	mov    %rsp,%rbp
  80177a:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80177e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801785:	00 
  801786:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80178c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801792:	b9 00 00 00 00       	mov    $0x0,%ecx
  801797:	ba 00 00 00 00       	mov    $0x0,%edx
  80179c:	be 00 00 00 00       	mov    $0x0,%esi
  8017a1:	bf 01 00 00 00       	mov    $0x1,%edi
  8017a6:	48 b8 9e 16 80 00 00 	movabs $0x80169e,%rax
  8017ad:	00 00 00 
  8017b0:	ff d0                	callq  *%rax
}
  8017b2:	c9                   	leaveq 
  8017b3:	c3                   	retq   

00000000008017b4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8017b4:	55                   	push   %rbp
  8017b5:	48 89 e5             	mov    %rsp,%rbp
  8017b8:	48 83 ec 10          	sub    $0x10,%rsp
  8017bc:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8017bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017c2:	48 98                	cltq   
  8017c4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017cb:	00 
  8017cc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017d2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017d8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017dd:	48 89 c2             	mov    %rax,%rdx
  8017e0:	be 01 00 00 00       	mov    $0x1,%esi
  8017e5:	bf 03 00 00 00       	mov    $0x3,%edi
  8017ea:	48 b8 9e 16 80 00 00 	movabs $0x80169e,%rax
  8017f1:	00 00 00 
  8017f4:	ff d0                	callq  *%rax
}
  8017f6:	c9                   	leaveq 
  8017f7:	c3                   	retq   

00000000008017f8 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8017f8:	55                   	push   %rbp
  8017f9:	48 89 e5             	mov    %rsp,%rbp
  8017fc:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801800:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801807:	00 
  801808:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80180e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801814:	b9 00 00 00 00       	mov    $0x0,%ecx
  801819:	ba 00 00 00 00       	mov    $0x0,%edx
  80181e:	be 00 00 00 00       	mov    $0x0,%esi
  801823:	bf 02 00 00 00       	mov    $0x2,%edi
  801828:	48 b8 9e 16 80 00 00 	movabs $0x80169e,%rax
  80182f:	00 00 00 
  801832:	ff d0                	callq  *%rax
}
  801834:	c9                   	leaveq 
  801835:	c3                   	retq   

0000000000801836 <sys_yield>:

void
sys_yield(void)
{
  801836:	55                   	push   %rbp
  801837:	48 89 e5             	mov    %rsp,%rbp
  80183a:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80183e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801845:	00 
  801846:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80184c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801852:	b9 00 00 00 00       	mov    $0x0,%ecx
  801857:	ba 00 00 00 00       	mov    $0x0,%edx
  80185c:	be 00 00 00 00       	mov    $0x0,%esi
  801861:	bf 0b 00 00 00       	mov    $0xb,%edi
  801866:	48 b8 9e 16 80 00 00 	movabs $0x80169e,%rax
  80186d:	00 00 00 
  801870:	ff d0                	callq  *%rax
}
  801872:	c9                   	leaveq 
  801873:	c3                   	retq   

0000000000801874 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801874:	55                   	push   %rbp
  801875:	48 89 e5             	mov    %rsp,%rbp
  801878:	48 83 ec 20          	sub    $0x20,%rsp
  80187c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80187f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801883:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801886:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801889:	48 63 c8             	movslq %eax,%rcx
  80188c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801890:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801893:	48 98                	cltq   
  801895:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80189c:	00 
  80189d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018a3:	49 89 c8             	mov    %rcx,%r8
  8018a6:	48 89 d1             	mov    %rdx,%rcx
  8018a9:	48 89 c2             	mov    %rax,%rdx
  8018ac:	be 01 00 00 00       	mov    $0x1,%esi
  8018b1:	bf 04 00 00 00       	mov    $0x4,%edi
  8018b6:	48 b8 9e 16 80 00 00 	movabs $0x80169e,%rax
  8018bd:	00 00 00 
  8018c0:	ff d0                	callq  *%rax
}
  8018c2:	c9                   	leaveq 
  8018c3:	c3                   	retq   

00000000008018c4 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8018c4:	55                   	push   %rbp
  8018c5:	48 89 e5             	mov    %rsp,%rbp
  8018c8:	48 83 ec 30          	sub    $0x30,%rsp
  8018cc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018cf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018d3:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8018d6:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8018da:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8018de:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8018e1:	48 63 c8             	movslq %eax,%rcx
  8018e4:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8018e8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018eb:	48 63 f0             	movslq %eax,%rsi
  8018ee:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018f5:	48 98                	cltq   
  8018f7:	48 89 0c 24          	mov    %rcx,(%rsp)
  8018fb:	49 89 f9             	mov    %rdi,%r9
  8018fe:	49 89 f0             	mov    %rsi,%r8
  801901:	48 89 d1             	mov    %rdx,%rcx
  801904:	48 89 c2             	mov    %rax,%rdx
  801907:	be 01 00 00 00       	mov    $0x1,%esi
  80190c:	bf 05 00 00 00       	mov    $0x5,%edi
  801911:	48 b8 9e 16 80 00 00 	movabs $0x80169e,%rax
  801918:	00 00 00 
  80191b:	ff d0                	callq  *%rax
}
  80191d:	c9                   	leaveq 
  80191e:	c3                   	retq   

000000000080191f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80191f:	55                   	push   %rbp
  801920:	48 89 e5             	mov    %rsp,%rbp
  801923:	48 83 ec 20          	sub    $0x20,%rsp
  801927:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80192a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  80192e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801932:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801935:	48 98                	cltq   
  801937:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80193e:	00 
  80193f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801945:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80194b:	48 89 d1             	mov    %rdx,%rcx
  80194e:	48 89 c2             	mov    %rax,%rdx
  801951:	be 01 00 00 00       	mov    $0x1,%esi
  801956:	bf 06 00 00 00       	mov    $0x6,%edi
  80195b:	48 b8 9e 16 80 00 00 	movabs $0x80169e,%rax
  801962:	00 00 00 
  801965:	ff d0                	callq  *%rax
}
  801967:	c9                   	leaveq 
  801968:	c3                   	retq   

0000000000801969 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801969:	55                   	push   %rbp
  80196a:	48 89 e5             	mov    %rsp,%rbp
  80196d:	48 83 ec 10          	sub    $0x10,%rsp
  801971:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801974:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801977:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80197a:	48 63 d0             	movslq %eax,%rdx
  80197d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801980:	48 98                	cltq   
  801982:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801989:	00 
  80198a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801990:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801996:	48 89 d1             	mov    %rdx,%rcx
  801999:	48 89 c2             	mov    %rax,%rdx
  80199c:	be 01 00 00 00       	mov    $0x1,%esi
  8019a1:	bf 08 00 00 00       	mov    $0x8,%edi
  8019a6:	48 b8 9e 16 80 00 00 	movabs $0x80169e,%rax
  8019ad:	00 00 00 
  8019b0:	ff d0                	callq  *%rax
}
  8019b2:	c9                   	leaveq 
  8019b3:	c3                   	retq   

00000000008019b4 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8019b4:	55                   	push   %rbp
  8019b5:	48 89 e5             	mov    %rsp,%rbp
  8019b8:	48 83 ec 20          	sub    $0x20,%rsp
  8019bc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019bf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  8019c3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019ca:	48 98                	cltq   
  8019cc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019d3:	00 
  8019d4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019da:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019e0:	48 89 d1             	mov    %rdx,%rcx
  8019e3:	48 89 c2             	mov    %rax,%rdx
  8019e6:	be 01 00 00 00       	mov    $0x1,%esi
  8019eb:	bf 09 00 00 00       	mov    $0x9,%edi
  8019f0:	48 b8 9e 16 80 00 00 	movabs $0x80169e,%rax
  8019f7:	00 00 00 
  8019fa:	ff d0                	callq  *%rax
}
  8019fc:	c9                   	leaveq 
  8019fd:	c3                   	retq   

00000000008019fe <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8019fe:	55                   	push   %rbp
  8019ff:	48 89 e5             	mov    %rsp,%rbp
  801a02:	48 83 ec 20          	sub    $0x20,%rsp
  801a06:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a09:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801a0d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a11:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a14:	48 98                	cltq   
  801a16:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a1d:	00 
  801a1e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a24:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a2a:	48 89 d1             	mov    %rdx,%rcx
  801a2d:	48 89 c2             	mov    %rax,%rdx
  801a30:	be 01 00 00 00       	mov    $0x1,%esi
  801a35:	bf 0a 00 00 00       	mov    $0xa,%edi
  801a3a:	48 b8 9e 16 80 00 00 	movabs $0x80169e,%rax
  801a41:	00 00 00 
  801a44:	ff d0                	callq  *%rax
}
  801a46:	c9                   	leaveq 
  801a47:	c3                   	retq   

0000000000801a48 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801a48:	55                   	push   %rbp
  801a49:	48 89 e5             	mov    %rsp,%rbp
  801a4c:	48 83 ec 20          	sub    $0x20,%rsp
  801a50:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a53:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a57:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801a5b:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801a5e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a61:	48 63 f0             	movslq %eax,%rsi
  801a64:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801a68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a6b:	48 98                	cltq   
  801a6d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a71:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a78:	00 
  801a79:	49 89 f1             	mov    %rsi,%r9
  801a7c:	49 89 c8             	mov    %rcx,%r8
  801a7f:	48 89 d1             	mov    %rdx,%rcx
  801a82:	48 89 c2             	mov    %rax,%rdx
  801a85:	be 00 00 00 00       	mov    $0x0,%esi
  801a8a:	bf 0c 00 00 00       	mov    $0xc,%edi
  801a8f:	48 b8 9e 16 80 00 00 	movabs $0x80169e,%rax
  801a96:	00 00 00 
  801a99:	ff d0                	callq  *%rax
}
  801a9b:	c9                   	leaveq 
  801a9c:	c3                   	retq   

0000000000801a9d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801a9d:	55                   	push   %rbp
  801a9e:	48 89 e5             	mov    %rsp,%rbp
  801aa1:	48 83 ec 10          	sub    $0x10,%rsp
  801aa5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801aa9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801aad:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ab4:	00 
  801ab5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801abb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ac1:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ac6:	48 89 c2             	mov    %rax,%rdx
  801ac9:	be 01 00 00 00       	mov    $0x1,%esi
  801ace:	bf 0d 00 00 00       	mov    $0xd,%edi
  801ad3:	48 b8 9e 16 80 00 00 	movabs $0x80169e,%rax
  801ada:	00 00 00 
  801add:	ff d0                	callq  *%rax
}
  801adf:	c9                   	leaveq 
  801ae0:	c3                   	retq   

0000000000801ae1 <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801ae1:	55                   	push   %rbp
  801ae2:	48 89 e5             	mov    %rsp,%rbp
  801ae5:	48 83 ec 20          	sub    $0x20,%rsp
  801ae9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801aed:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, (uint64_t)buf, len, 0, 0, 0, 0);
  801af1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801af5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801af9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b00:	00 
  801b01:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b07:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b0d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b12:	89 c6                	mov    %eax,%esi
  801b14:	bf 0f 00 00 00       	mov    $0xf,%edi
  801b19:	48 b8 9e 16 80 00 00 	movabs $0x80169e,%rax
  801b20:	00 00 00 
  801b23:	ff d0                	callq  *%rax
}
  801b25:	c9                   	leaveq 
  801b26:	c3                   	retq   

0000000000801b27 <sys_net_rx>:

int
sys_net_rx(void *buf, size_t len)
{
  801b27:	55                   	push   %rbp
  801b28:	48 89 e5             	mov    %rsp,%rbp
  801b2b:	48 83 ec 20          	sub    $0x20,%rsp
  801b2f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b33:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_rx, (uint64_t)buf, len, 0, 0, 0, 0);
  801b37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b3b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b3f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b46:	00 
  801b47:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b4d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b53:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b58:	89 c6                	mov    %eax,%esi
  801b5a:	bf 10 00 00 00       	mov    $0x10,%edi
  801b5f:	48 b8 9e 16 80 00 00 	movabs $0x80169e,%rax
  801b66:	00 00 00 
  801b69:	ff d0                	callq  *%rax
}
  801b6b:	c9                   	leaveq 
  801b6c:	c3                   	retq   

0000000000801b6d <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801b6d:	55                   	push   %rbp
  801b6e:	48 89 e5             	mov    %rsp,%rbp
  801b71:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801b75:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b7c:	00 
  801b7d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b83:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b89:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b8e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b93:	be 00 00 00 00       	mov    $0x0,%esi
  801b98:	bf 0e 00 00 00       	mov    $0xe,%edi
  801b9d:	48 b8 9e 16 80 00 00 	movabs $0x80169e,%rax
  801ba4:	00 00 00 
  801ba7:	ff d0                	callq  *%rax
}
  801ba9:	c9                   	leaveq 
  801baa:	c3                   	retq   

0000000000801bab <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801bab:	55                   	push   %rbp
  801bac:	48 89 e5             	mov    %rsp,%rbp
  801baf:	48 83 ec 18          	sub    $0x18,%rsp
  801bb3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801bb7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bbb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	args->argc = argc;
  801bbf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bc3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801bc7:	48 89 10             	mov    %rdx,(%rax)
	args->argv = (const char **) argv;
  801bca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bce:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bd2:	48 89 50 08          	mov    %rdx,0x8(%rax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801bd6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bda:	8b 00                	mov    (%rax),%eax
  801bdc:	83 f8 01             	cmp    $0x1,%eax
  801bdf:	7e 13                	jle    801bf4 <argstart+0x49>
  801be1:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  801be6:	74 0c                	je     801bf4 <argstart+0x49>
  801be8:	48 b8 13 4b 80 00 00 	movabs $0x804b13,%rax
  801bef:	00 00 00 
  801bf2:	eb 05                	jmp    801bf9 <argstart+0x4e>
  801bf4:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801bfd:	48 89 42 10          	mov    %rax,0x10(%rdx)
	args->argvalue = 0;
  801c01:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c05:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  801c0c:	00 
}
  801c0d:	c9                   	leaveq 
  801c0e:	c3                   	retq   

0000000000801c0f <argnext>:

int
argnext(struct Argstate *args)
{
  801c0f:	55                   	push   %rbp
  801c10:	48 89 e5             	mov    %rsp,%rbp
  801c13:	48 83 ec 20          	sub    $0x20,%rsp
  801c17:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int arg;

	args->argvalue = 0;
  801c1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c1f:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  801c26:	00 

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801c27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c2b:	48 8b 40 10          	mov    0x10(%rax),%rax
  801c2f:	48 85 c0             	test   %rax,%rax
  801c32:	75 0a                	jne    801c3e <argnext+0x2f>
		return -1;
  801c34:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801c39:	e9 25 01 00 00       	jmpq   801d63 <argnext+0x154>

	if (!*args->curarg) {
  801c3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c42:	48 8b 40 10          	mov    0x10(%rax),%rax
  801c46:	0f b6 00             	movzbl (%rax),%eax
  801c49:	84 c0                	test   %al,%al
  801c4b:	0f 85 d7 00 00 00    	jne    801d28 <argnext+0x119>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801c51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c55:	48 8b 00             	mov    (%rax),%rax
  801c58:	8b 00                	mov    (%rax),%eax
  801c5a:	83 f8 01             	cmp    $0x1,%eax
  801c5d:	0f 84 ef 00 00 00    	je     801d52 <argnext+0x143>
		    || args->argv[1][0] != '-'
  801c63:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c67:	48 8b 40 08          	mov    0x8(%rax),%rax
  801c6b:	48 83 c0 08          	add    $0x8,%rax
  801c6f:	48 8b 00             	mov    (%rax),%rax
  801c72:	0f b6 00             	movzbl (%rax),%eax
  801c75:	3c 2d                	cmp    $0x2d,%al
  801c77:	0f 85 d5 00 00 00    	jne    801d52 <argnext+0x143>
		    || args->argv[1][1] == '\0')
  801c7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c81:	48 8b 40 08          	mov    0x8(%rax),%rax
  801c85:	48 83 c0 08          	add    $0x8,%rax
  801c89:	48 8b 00             	mov    (%rax),%rax
  801c8c:	48 83 c0 01          	add    $0x1,%rax
  801c90:	0f b6 00             	movzbl (%rax),%eax
  801c93:	84 c0                	test   %al,%al
  801c95:	0f 84 b7 00 00 00    	je     801d52 <argnext+0x143>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801c9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c9f:	48 8b 40 08          	mov    0x8(%rax),%rax
  801ca3:	48 83 c0 08          	add    $0x8,%rax
  801ca7:	48 8b 00             	mov    (%rax),%rax
  801caa:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801cae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cb2:	48 89 50 10          	mov    %rdx,0x10(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801cb6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cba:	48 8b 00             	mov    (%rax),%rax
  801cbd:	8b 00                	mov    (%rax),%eax
  801cbf:	83 e8 01             	sub    $0x1,%eax
  801cc2:	48 98                	cltq   
  801cc4:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801ccb:	00 
  801ccc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cd0:	48 8b 40 08          	mov    0x8(%rax),%rax
  801cd4:	48 8d 48 10          	lea    0x10(%rax),%rcx
  801cd8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cdc:	48 8b 40 08          	mov    0x8(%rax),%rax
  801ce0:	48 83 c0 08          	add    $0x8,%rax
  801ce4:	48 89 ce             	mov    %rcx,%rsi
  801ce7:	48 89 c7             	mov    %rax,%rdi
  801cea:	48 b8 69 12 80 00 00 	movabs $0x801269,%rax
  801cf1:	00 00 00 
  801cf4:	ff d0                	callq  *%rax
		(*args->argc)--;
  801cf6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cfa:	48 8b 00             	mov    (%rax),%rax
  801cfd:	8b 10                	mov    (%rax),%edx
  801cff:	83 ea 01             	sub    $0x1,%edx
  801d02:	89 10                	mov    %edx,(%rax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801d04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d08:	48 8b 40 10          	mov    0x10(%rax),%rax
  801d0c:	0f b6 00             	movzbl (%rax),%eax
  801d0f:	3c 2d                	cmp    $0x2d,%al
  801d11:	75 15                	jne    801d28 <argnext+0x119>
  801d13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d17:	48 8b 40 10          	mov    0x10(%rax),%rax
  801d1b:	48 83 c0 01          	add    $0x1,%rax
  801d1f:	0f b6 00             	movzbl (%rax),%eax
  801d22:	84 c0                	test   %al,%al
  801d24:	75 02                	jne    801d28 <argnext+0x119>
			goto endofargs;
  801d26:	eb 2a                	jmp    801d52 <argnext+0x143>
	}

	arg = (unsigned char) *args->curarg;
  801d28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d2c:	48 8b 40 10          	mov    0x10(%rax),%rax
  801d30:	0f b6 00             	movzbl (%rax),%eax
  801d33:	0f b6 c0             	movzbl %al,%eax
  801d36:	89 45 fc             	mov    %eax,-0x4(%rbp)
	args->curarg++;
  801d39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d3d:	48 8b 40 10          	mov    0x10(%rax),%rax
  801d41:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801d45:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d49:	48 89 50 10          	mov    %rdx,0x10(%rax)
	return arg;
  801d4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d50:	eb 11                	jmp    801d63 <argnext+0x154>

endofargs:
	args->curarg = 0;
  801d52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d56:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  801d5d:	00 
	return -1;
  801d5e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  801d63:	c9                   	leaveq 
  801d64:	c3                   	retq   

0000000000801d65 <argvalue>:

char *
argvalue(struct Argstate *args)
{
  801d65:	55                   	push   %rbp
  801d66:	48 89 e5             	mov    %rsp,%rbp
  801d69:	48 83 ec 10          	sub    $0x10,%rsp
  801d6d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801d71:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d75:	48 8b 40 18          	mov    0x18(%rax),%rax
  801d79:	48 85 c0             	test   %rax,%rax
  801d7c:	74 0a                	je     801d88 <argvalue+0x23>
  801d7e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d82:	48 8b 40 18          	mov    0x18(%rax),%rax
  801d86:	eb 13                	jmp    801d9b <argvalue+0x36>
  801d88:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d8c:	48 89 c7             	mov    %rax,%rdi
  801d8f:	48 b8 9d 1d 80 00 00 	movabs $0x801d9d,%rax
  801d96:	00 00 00 
  801d99:	ff d0                	callq  *%rax
}
  801d9b:	c9                   	leaveq 
  801d9c:	c3                   	retq   

0000000000801d9d <argnextvalue>:

char *
argnextvalue(struct Argstate *args)
{
  801d9d:	55                   	push   %rbp
  801d9e:	48 89 e5             	mov    %rsp,%rbp
  801da1:	53                   	push   %rbx
  801da2:	48 83 ec 18          	sub    $0x18,%rsp
  801da6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (!args->curarg)
  801daa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dae:	48 8b 40 10          	mov    0x10(%rax),%rax
  801db2:	48 85 c0             	test   %rax,%rax
  801db5:	75 0a                	jne    801dc1 <argnextvalue+0x24>
		return 0;
  801db7:	b8 00 00 00 00       	mov    $0x0,%eax
  801dbc:	e9 c8 00 00 00       	jmpq   801e89 <argnextvalue+0xec>
	if (*args->curarg) {
  801dc1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dc5:	48 8b 40 10          	mov    0x10(%rax),%rax
  801dc9:	0f b6 00             	movzbl (%rax),%eax
  801dcc:	84 c0                	test   %al,%al
  801dce:	74 27                	je     801df7 <argnextvalue+0x5a>
		args->argvalue = args->curarg;
  801dd0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dd4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801dd8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ddc:	48 89 50 18          	mov    %rdx,0x18(%rax)
		args->curarg = "";
  801de0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801de4:	48 bb 13 4b 80 00 00 	movabs $0x804b13,%rbx
  801deb:	00 00 00 
  801dee:	48 89 58 10          	mov    %rbx,0x10(%rax)
  801df2:	e9 8a 00 00 00       	jmpq   801e81 <argnextvalue+0xe4>
	} else if (*args->argc > 1) {
  801df7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dfb:	48 8b 00             	mov    (%rax),%rax
  801dfe:	8b 00                	mov    (%rax),%eax
  801e00:	83 f8 01             	cmp    $0x1,%eax
  801e03:	7e 64                	jle    801e69 <argnextvalue+0xcc>
		args->argvalue = args->argv[1];
  801e05:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e09:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e0d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801e11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e15:	48 89 50 18          	mov    %rdx,0x18(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801e19:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e1d:	48 8b 00             	mov    (%rax),%rax
  801e20:	8b 00                	mov    (%rax),%eax
  801e22:	83 e8 01             	sub    $0x1,%eax
  801e25:	48 98                	cltq   
  801e27:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801e2e:	00 
  801e2f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e33:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e37:	48 8d 48 10          	lea    0x10(%rax),%rcx
  801e3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e3f:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e43:	48 83 c0 08          	add    $0x8,%rax
  801e47:	48 89 ce             	mov    %rcx,%rsi
  801e4a:	48 89 c7             	mov    %rax,%rdi
  801e4d:	48 b8 69 12 80 00 00 	movabs $0x801269,%rax
  801e54:	00 00 00 
  801e57:	ff d0                	callq  *%rax
		(*args->argc)--;
  801e59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e5d:	48 8b 00             	mov    (%rax),%rax
  801e60:	8b 10                	mov    (%rax),%edx
  801e62:	83 ea 01             	sub    $0x1,%edx
  801e65:	89 10                	mov    %edx,(%rax)
  801e67:	eb 18                	jmp    801e81 <argnextvalue+0xe4>
	} else {
		args->argvalue = 0;
  801e69:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e6d:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  801e74:	00 
		args->curarg = 0;
  801e75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e79:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  801e80:	00 
	}
	return (char*) args->argvalue;
  801e81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e85:	48 8b 40 18          	mov    0x18(%rax),%rax
}
  801e89:	48 83 c4 18          	add    $0x18,%rsp
  801e8d:	5b                   	pop    %rbx
  801e8e:	5d                   	pop    %rbp
  801e8f:	c3                   	retq   

0000000000801e90 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801e90:	55                   	push   %rbp
  801e91:	48 89 e5             	mov    %rsp,%rbp
  801e94:	48 83 ec 08          	sub    $0x8,%rsp
  801e98:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801e9c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ea0:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801ea7:	ff ff ff 
  801eaa:	48 01 d0             	add    %rdx,%rax
  801ead:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801eb1:	c9                   	leaveq 
  801eb2:	c3                   	retq   

0000000000801eb3 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801eb3:	55                   	push   %rbp
  801eb4:	48 89 e5             	mov    %rsp,%rbp
  801eb7:	48 83 ec 08          	sub    $0x8,%rsp
  801ebb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801ebf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ec3:	48 89 c7             	mov    %rax,%rdi
  801ec6:	48 b8 90 1e 80 00 00 	movabs $0x801e90,%rax
  801ecd:	00 00 00 
  801ed0:	ff d0                	callq  *%rax
  801ed2:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801ed8:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801edc:	c9                   	leaveq 
  801edd:	c3                   	retq   

0000000000801ede <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801ede:	55                   	push   %rbp
  801edf:	48 89 e5             	mov    %rsp,%rbp
  801ee2:	48 83 ec 18          	sub    $0x18,%rsp
  801ee6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801eea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801ef1:	eb 6b                	jmp    801f5e <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801ef3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ef6:	48 98                	cltq   
  801ef8:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801efe:	48 c1 e0 0c          	shl    $0xc,%rax
  801f02:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801f06:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f0a:	48 c1 e8 15          	shr    $0x15,%rax
  801f0e:	48 89 c2             	mov    %rax,%rdx
  801f11:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f18:	01 00 00 
  801f1b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f1f:	83 e0 01             	and    $0x1,%eax
  801f22:	48 85 c0             	test   %rax,%rax
  801f25:	74 21                	je     801f48 <fd_alloc+0x6a>
  801f27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f2b:	48 c1 e8 0c          	shr    $0xc,%rax
  801f2f:	48 89 c2             	mov    %rax,%rdx
  801f32:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f39:	01 00 00 
  801f3c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f40:	83 e0 01             	and    $0x1,%eax
  801f43:	48 85 c0             	test   %rax,%rax
  801f46:	75 12                	jne    801f5a <fd_alloc+0x7c>
			*fd_store = fd;
  801f48:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f4c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f50:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f53:	b8 00 00 00 00       	mov    $0x0,%eax
  801f58:	eb 1a                	jmp    801f74 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801f5a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f5e:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801f62:	7e 8f                	jle    801ef3 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801f64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f68:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801f6f:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801f74:	c9                   	leaveq 
  801f75:	c3                   	retq   

0000000000801f76 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801f76:	55                   	push   %rbp
  801f77:	48 89 e5             	mov    %rsp,%rbp
  801f7a:	48 83 ec 20          	sub    $0x20,%rsp
  801f7e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f81:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801f85:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f89:	78 06                	js     801f91 <fd_lookup+0x1b>
  801f8b:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801f8f:	7e 07                	jle    801f98 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f91:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f96:	eb 6c                	jmp    802004 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801f98:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f9b:	48 98                	cltq   
  801f9d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801fa3:	48 c1 e0 0c          	shl    $0xc,%rax
  801fa7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801fab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801faf:	48 c1 e8 15          	shr    $0x15,%rax
  801fb3:	48 89 c2             	mov    %rax,%rdx
  801fb6:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801fbd:	01 00 00 
  801fc0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fc4:	83 e0 01             	and    $0x1,%eax
  801fc7:	48 85 c0             	test   %rax,%rax
  801fca:	74 21                	je     801fed <fd_lookup+0x77>
  801fcc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fd0:	48 c1 e8 0c          	shr    $0xc,%rax
  801fd4:	48 89 c2             	mov    %rax,%rdx
  801fd7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fde:	01 00 00 
  801fe1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fe5:	83 e0 01             	and    $0x1,%eax
  801fe8:	48 85 c0             	test   %rax,%rax
  801feb:	75 07                	jne    801ff4 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801fed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ff2:	eb 10                	jmp    802004 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801ff4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ff8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ffc:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801fff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802004:	c9                   	leaveq 
  802005:	c3                   	retq   

0000000000802006 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802006:	55                   	push   %rbp
  802007:	48 89 e5             	mov    %rsp,%rbp
  80200a:	48 83 ec 30          	sub    $0x30,%rsp
  80200e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802012:	89 f0                	mov    %esi,%eax
  802014:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802017:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80201b:	48 89 c7             	mov    %rax,%rdi
  80201e:	48 b8 90 1e 80 00 00 	movabs $0x801e90,%rax
  802025:	00 00 00 
  802028:	ff d0                	callq  *%rax
  80202a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80202e:	48 89 d6             	mov    %rdx,%rsi
  802031:	89 c7                	mov    %eax,%edi
  802033:	48 b8 76 1f 80 00 00 	movabs $0x801f76,%rax
  80203a:	00 00 00 
  80203d:	ff d0                	callq  *%rax
  80203f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802042:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802046:	78 0a                	js     802052 <fd_close+0x4c>
	    || fd != fd2)
  802048:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80204c:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802050:	74 12                	je     802064 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802052:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802056:	74 05                	je     80205d <fd_close+0x57>
  802058:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80205b:	eb 05                	jmp    802062 <fd_close+0x5c>
  80205d:	b8 00 00 00 00       	mov    $0x0,%eax
  802062:	eb 69                	jmp    8020cd <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802064:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802068:	8b 00                	mov    (%rax),%eax
  80206a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80206e:	48 89 d6             	mov    %rdx,%rsi
  802071:	89 c7                	mov    %eax,%edi
  802073:	48 b8 cf 20 80 00 00 	movabs $0x8020cf,%rax
  80207a:	00 00 00 
  80207d:	ff d0                	callq  *%rax
  80207f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802082:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802086:	78 2a                	js     8020b2 <fd_close+0xac>
		if (dev->dev_close)
  802088:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80208c:	48 8b 40 20          	mov    0x20(%rax),%rax
  802090:	48 85 c0             	test   %rax,%rax
  802093:	74 16                	je     8020ab <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802095:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802099:	48 8b 40 20          	mov    0x20(%rax),%rax
  80209d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8020a1:	48 89 d7             	mov    %rdx,%rdi
  8020a4:	ff d0                	callq  *%rax
  8020a6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020a9:	eb 07                	jmp    8020b2 <fd_close+0xac>
		else
			r = 0;
  8020ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8020b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020b6:	48 89 c6             	mov    %rax,%rsi
  8020b9:	bf 00 00 00 00       	mov    $0x0,%edi
  8020be:	48 b8 1f 19 80 00 00 	movabs $0x80191f,%rax
  8020c5:	00 00 00 
  8020c8:	ff d0                	callq  *%rax
	return r;
  8020ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8020cd:	c9                   	leaveq 
  8020ce:	c3                   	retq   

00000000008020cf <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8020cf:	55                   	push   %rbp
  8020d0:	48 89 e5             	mov    %rsp,%rbp
  8020d3:	48 83 ec 20          	sub    $0x20,%rsp
  8020d7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8020da:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8020de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020e5:	eb 41                	jmp    802128 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8020e7:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8020ee:	00 00 00 
  8020f1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020f4:	48 63 d2             	movslq %edx,%rdx
  8020f7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020fb:	8b 00                	mov    (%rax),%eax
  8020fd:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802100:	75 22                	jne    802124 <dev_lookup+0x55>
			*dev = devtab[i];
  802102:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802109:	00 00 00 
  80210c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80210f:	48 63 d2             	movslq %edx,%rdx
  802112:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802116:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80211a:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80211d:	b8 00 00 00 00       	mov    $0x0,%eax
  802122:	eb 60                	jmp    802184 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802124:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802128:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80212f:	00 00 00 
  802132:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802135:	48 63 d2             	movslq %edx,%rdx
  802138:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80213c:	48 85 c0             	test   %rax,%rax
  80213f:	75 a6                	jne    8020e7 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802141:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802148:	00 00 00 
  80214b:	48 8b 00             	mov    (%rax),%rax
  80214e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802154:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802157:	89 c6                	mov    %eax,%esi
  802159:	48 bf 18 4b 80 00 00 	movabs $0x804b18,%rdi
  802160:	00 00 00 
  802163:	b8 00 00 00 00       	mov    $0x0,%eax
  802168:	48 b9 90 03 80 00 00 	movabs $0x800390,%rcx
  80216f:	00 00 00 
  802172:	ff d1                	callq  *%rcx
	*dev = 0;
  802174:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802178:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80217f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802184:	c9                   	leaveq 
  802185:	c3                   	retq   

0000000000802186 <close>:

int
close(int fdnum)
{
  802186:	55                   	push   %rbp
  802187:	48 89 e5             	mov    %rsp,%rbp
  80218a:	48 83 ec 20          	sub    $0x20,%rsp
  80218e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802191:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802195:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802198:	48 89 d6             	mov    %rdx,%rsi
  80219b:	89 c7                	mov    %eax,%edi
  80219d:	48 b8 76 1f 80 00 00 	movabs $0x801f76,%rax
  8021a4:	00 00 00 
  8021a7:	ff d0                	callq  *%rax
  8021a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021b0:	79 05                	jns    8021b7 <close+0x31>
		return r;
  8021b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021b5:	eb 18                	jmp    8021cf <close+0x49>
	else
		return fd_close(fd, 1);
  8021b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021bb:	be 01 00 00 00       	mov    $0x1,%esi
  8021c0:	48 89 c7             	mov    %rax,%rdi
  8021c3:	48 b8 06 20 80 00 00 	movabs $0x802006,%rax
  8021ca:	00 00 00 
  8021cd:	ff d0                	callq  *%rax
}
  8021cf:	c9                   	leaveq 
  8021d0:	c3                   	retq   

00000000008021d1 <close_all>:

void
close_all(void)
{
  8021d1:	55                   	push   %rbp
  8021d2:	48 89 e5             	mov    %rsp,%rbp
  8021d5:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8021d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8021e0:	eb 15                	jmp    8021f7 <close_all+0x26>
		close(i);
  8021e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021e5:	89 c7                	mov    %eax,%edi
  8021e7:	48 b8 86 21 80 00 00 	movabs $0x802186,%rax
  8021ee:	00 00 00 
  8021f1:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8021f3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8021f7:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8021fb:	7e e5                	jle    8021e2 <close_all+0x11>
		close(i);
}
  8021fd:	c9                   	leaveq 
  8021fe:	c3                   	retq   

00000000008021ff <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8021ff:	55                   	push   %rbp
  802200:	48 89 e5             	mov    %rsp,%rbp
  802203:	48 83 ec 40          	sub    $0x40,%rsp
  802207:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80220a:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80220d:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802211:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802214:	48 89 d6             	mov    %rdx,%rsi
  802217:	89 c7                	mov    %eax,%edi
  802219:	48 b8 76 1f 80 00 00 	movabs $0x801f76,%rax
  802220:	00 00 00 
  802223:	ff d0                	callq  *%rax
  802225:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802228:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80222c:	79 08                	jns    802236 <dup+0x37>
		return r;
  80222e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802231:	e9 70 01 00 00       	jmpq   8023a6 <dup+0x1a7>
	close(newfdnum);
  802236:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802239:	89 c7                	mov    %eax,%edi
  80223b:	48 b8 86 21 80 00 00 	movabs $0x802186,%rax
  802242:	00 00 00 
  802245:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802247:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80224a:	48 98                	cltq   
  80224c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802252:	48 c1 e0 0c          	shl    $0xc,%rax
  802256:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80225a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80225e:	48 89 c7             	mov    %rax,%rdi
  802261:	48 b8 b3 1e 80 00 00 	movabs $0x801eb3,%rax
  802268:	00 00 00 
  80226b:	ff d0                	callq  *%rax
  80226d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802271:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802275:	48 89 c7             	mov    %rax,%rdi
  802278:	48 b8 b3 1e 80 00 00 	movabs $0x801eb3,%rax
  80227f:	00 00 00 
  802282:	ff d0                	callq  *%rax
  802284:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802288:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80228c:	48 c1 e8 15          	shr    $0x15,%rax
  802290:	48 89 c2             	mov    %rax,%rdx
  802293:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80229a:	01 00 00 
  80229d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022a1:	83 e0 01             	and    $0x1,%eax
  8022a4:	48 85 c0             	test   %rax,%rax
  8022a7:	74 73                	je     80231c <dup+0x11d>
  8022a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022ad:	48 c1 e8 0c          	shr    $0xc,%rax
  8022b1:	48 89 c2             	mov    %rax,%rdx
  8022b4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022bb:	01 00 00 
  8022be:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022c2:	83 e0 01             	and    $0x1,%eax
  8022c5:	48 85 c0             	test   %rax,%rax
  8022c8:	74 52                	je     80231c <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8022ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022ce:	48 c1 e8 0c          	shr    $0xc,%rax
  8022d2:	48 89 c2             	mov    %rax,%rdx
  8022d5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022dc:	01 00 00 
  8022df:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022e3:	25 07 0e 00 00       	and    $0xe07,%eax
  8022e8:	89 c1                	mov    %eax,%ecx
  8022ea:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8022ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022f2:	41 89 c8             	mov    %ecx,%r8d
  8022f5:	48 89 d1             	mov    %rdx,%rcx
  8022f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8022fd:	48 89 c6             	mov    %rax,%rsi
  802300:	bf 00 00 00 00       	mov    $0x0,%edi
  802305:	48 b8 c4 18 80 00 00 	movabs $0x8018c4,%rax
  80230c:	00 00 00 
  80230f:	ff d0                	callq  *%rax
  802311:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802314:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802318:	79 02                	jns    80231c <dup+0x11d>
			goto err;
  80231a:	eb 57                	jmp    802373 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80231c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802320:	48 c1 e8 0c          	shr    $0xc,%rax
  802324:	48 89 c2             	mov    %rax,%rdx
  802327:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80232e:	01 00 00 
  802331:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802335:	25 07 0e 00 00       	and    $0xe07,%eax
  80233a:	89 c1                	mov    %eax,%ecx
  80233c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802340:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802344:	41 89 c8             	mov    %ecx,%r8d
  802347:	48 89 d1             	mov    %rdx,%rcx
  80234a:	ba 00 00 00 00       	mov    $0x0,%edx
  80234f:	48 89 c6             	mov    %rax,%rsi
  802352:	bf 00 00 00 00       	mov    $0x0,%edi
  802357:	48 b8 c4 18 80 00 00 	movabs $0x8018c4,%rax
  80235e:	00 00 00 
  802361:	ff d0                	callq  *%rax
  802363:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802366:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80236a:	79 02                	jns    80236e <dup+0x16f>
		goto err;
  80236c:	eb 05                	jmp    802373 <dup+0x174>

	return newfdnum;
  80236e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802371:	eb 33                	jmp    8023a6 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802373:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802377:	48 89 c6             	mov    %rax,%rsi
  80237a:	bf 00 00 00 00       	mov    $0x0,%edi
  80237f:	48 b8 1f 19 80 00 00 	movabs $0x80191f,%rax
  802386:	00 00 00 
  802389:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80238b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80238f:	48 89 c6             	mov    %rax,%rsi
  802392:	bf 00 00 00 00       	mov    $0x0,%edi
  802397:	48 b8 1f 19 80 00 00 	movabs $0x80191f,%rax
  80239e:	00 00 00 
  8023a1:	ff d0                	callq  *%rax
	return r;
  8023a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023a6:	c9                   	leaveq 
  8023a7:	c3                   	retq   

00000000008023a8 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8023a8:	55                   	push   %rbp
  8023a9:	48 89 e5             	mov    %rsp,%rbp
  8023ac:	48 83 ec 40          	sub    $0x40,%rsp
  8023b0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8023b3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8023b7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023bb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023bf:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8023c2:	48 89 d6             	mov    %rdx,%rsi
  8023c5:	89 c7                	mov    %eax,%edi
  8023c7:	48 b8 76 1f 80 00 00 	movabs $0x801f76,%rax
  8023ce:	00 00 00 
  8023d1:	ff d0                	callq  *%rax
  8023d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023da:	78 24                	js     802400 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023e0:	8b 00                	mov    (%rax),%eax
  8023e2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023e6:	48 89 d6             	mov    %rdx,%rsi
  8023e9:	89 c7                	mov    %eax,%edi
  8023eb:	48 b8 cf 20 80 00 00 	movabs $0x8020cf,%rax
  8023f2:	00 00 00 
  8023f5:	ff d0                	callq  *%rax
  8023f7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023fe:	79 05                	jns    802405 <read+0x5d>
		return r;
  802400:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802403:	eb 76                	jmp    80247b <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802405:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802409:	8b 40 08             	mov    0x8(%rax),%eax
  80240c:	83 e0 03             	and    $0x3,%eax
  80240f:	83 f8 01             	cmp    $0x1,%eax
  802412:	75 3a                	jne    80244e <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802414:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80241b:	00 00 00 
  80241e:	48 8b 00             	mov    (%rax),%rax
  802421:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802427:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80242a:	89 c6                	mov    %eax,%esi
  80242c:	48 bf 37 4b 80 00 00 	movabs $0x804b37,%rdi
  802433:	00 00 00 
  802436:	b8 00 00 00 00       	mov    $0x0,%eax
  80243b:	48 b9 90 03 80 00 00 	movabs $0x800390,%rcx
  802442:	00 00 00 
  802445:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802447:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80244c:	eb 2d                	jmp    80247b <read+0xd3>
	}
	if (!dev->dev_read)
  80244e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802452:	48 8b 40 10          	mov    0x10(%rax),%rax
  802456:	48 85 c0             	test   %rax,%rax
  802459:	75 07                	jne    802462 <read+0xba>
		return -E_NOT_SUPP;
  80245b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802460:	eb 19                	jmp    80247b <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802462:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802466:	48 8b 40 10          	mov    0x10(%rax),%rax
  80246a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80246e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802472:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802476:	48 89 cf             	mov    %rcx,%rdi
  802479:	ff d0                	callq  *%rax
}
  80247b:	c9                   	leaveq 
  80247c:	c3                   	retq   

000000000080247d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80247d:	55                   	push   %rbp
  80247e:	48 89 e5             	mov    %rsp,%rbp
  802481:	48 83 ec 30          	sub    $0x30,%rsp
  802485:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802488:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80248c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802490:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802497:	eb 49                	jmp    8024e2 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802499:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80249c:	48 98                	cltq   
  80249e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8024a2:	48 29 c2             	sub    %rax,%rdx
  8024a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024a8:	48 63 c8             	movslq %eax,%rcx
  8024ab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024af:	48 01 c1             	add    %rax,%rcx
  8024b2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024b5:	48 89 ce             	mov    %rcx,%rsi
  8024b8:	89 c7                	mov    %eax,%edi
  8024ba:	48 b8 a8 23 80 00 00 	movabs $0x8023a8,%rax
  8024c1:	00 00 00 
  8024c4:	ff d0                	callq  *%rax
  8024c6:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8024c9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8024cd:	79 05                	jns    8024d4 <readn+0x57>
			return m;
  8024cf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024d2:	eb 1c                	jmp    8024f0 <readn+0x73>
		if (m == 0)
  8024d4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8024d8:	75 02                	jne    8024dc <readn+0x5f>
			break;
  8024da:	eb 11                	jmp    8024ed <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8024dc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024df:	01 45 fc             	add    %eax,-0x4(%rbp)
  8024e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024e5:	48 98                	cltq   
  8024e7:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8024eb:	72 ac                	jb     802499 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8024ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8024f0:	c9                   	leaveq 
  8024f1:	c3                   	retq   

00000000008024f2 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8024f2:	55                   	push   %rbp
  8024f3:	48 89 e5             	mov    %rsp,%rbp
  8024f6:	48 83 ec 40          	sub    $0x40,%rsp
  8024fa:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024fd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802501:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802505:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802509:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80250c:	48 89 d6             	mov    %rdx,%rsi
  80250f:	89 c7                	mov    %eax,%edi
  802511:	48 b8 76 1f 80 00 00 	movabs $0x801f76,%rax
  802518:	00 00 00 
  80251b:	ff d0                	callq  *%rax
  80251d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802520:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802524:	78 24                	js     80254a <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802526:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80252a:	8b 00                	mov    (%rax),%eax
  80252c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802530:	48 89 d6             	mov    %rdx,%rsi
  802533:	89 c7                	mov    %eax,%edi
  802535:	48 b8 cf 20 80 00 00 	movabs $0x8020cf,%rax
  80253c:	00 00 00 
  80253f:	ff d0                	callq  *%rax
  802541:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802544:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802548:	79 05                	jns    80254f <write+0x5d>
		return r;
  80254a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80254d:	eb 75                	jmp    8025c4 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80254f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802553:	8b 40 08             	mov    0x8(%rax),%eax
  802556:	83 e0 03             	and    $0x3,%eax
  802559:	85 c0                	test   %eax,%eax
  80255b:	75 3a                	jne    802597 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80255d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802564:	00 00 00 
  802567:	48 8b 00             	mov    (%rax),%rax
  80256a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802570:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802573:	89 c6                	mov    %eax,%esi
  802575:	48 bf 53 4b 80 00 00 	movabs $0x804b53,%rdi
  80257c:	00 00 00 
  80257f:	b8 00 00 00 00       	mov    $0x0,%eax
  802584:	48 b9 90 03 80 00 00 	movabs $0x800390,%rcx
  80258b:	00 00 00 
  80258e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802590:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802595:	eb 2d                	jmp    8025c4 <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  802597:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80259b:	48 8b 40 18          	mov    0x18(%rax),%rax
  80259f:	48 85 c0             	test   %rax,%rax
  8025a2:	75 07                	jne    8025ab <write+0xb9>
		return -E_NOT_SUPP;
  8025a4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025a9:	eb 19                	jmp    8025c4 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8025ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025af:	48 8b 40 18          	mov    0x18(%rax),%rax
  8025b3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8025b7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8025bb:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8025bf:	48 89 cf             	mov    %rcx,%rdi
  8025c2:	ff d0                	callq  *%rax
}
  8025c4:	c9                   	leaveq 
  8025c5:	c3                   	retq   

00000000008025c6 <seek>:

int
seek(int fdnum, off_t offset)
{
  8025c6:	55                   	push   %rbp
  8025c7:	48 89 e5             	mov    %rsp,%rbp
  8025ca:	48 83 ec 18          	sub    $0x18,%rsp
  8025ce:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025d1:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025d4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025d8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025db:	48 89 d6             	mov    %rdx,%rsi
  8025de:	89 c7                	mov    %eax,%edi
  8025e0:	48 b8 76 1f 80 00 00 	movabs $0x801f76,%rax
  8025e7:	00 00 00 
  8025ea:	ff d0                	callq  *%rax
  8025ec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025f3:	79 05                	jns    8025fa <seek+0x34>
		return r;
  8025f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025f8:	eb 0f                	jmp    802609 <seek+0x43>
	fd->fd_offset = offset;
  8025fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025fe:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802601:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802604:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802609:	c9                   	leaveq 
  80260a:	c3                   	retq   

000000000080260b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80260b:	55                   	push   %rbp
  80260c:	48 89 e5             	mov    %rsp,%rbp
  80260f:	48 83 ec 30          	sub    $0x30,%rsp
  802613:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802616:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802619:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80261d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802620:	48 89 d6             	mov    %rdx,%rsi
  802623:	89 c7                	mov    %eax,%edi
  802625:	48 b8 76 1f 80 00 00 	movabs $0x801f76,%rax
  80262c:	00 00 00 
  80262f:	ff d0                	callq  *%rax
  802631:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802634:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802638:	78 24                	js     80265e <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80263a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80263e:	8b 00                	mov    (%rax),%eax
  802640:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802644:	48 89 d6             	mov    %rdx,%rsi
  802647:	89 c7                	mov    %eax,%edi
  802649:	48 b8 cf 20 80 00 00 	movabs $0x8020cf,%rax
  802650:	00 00 00 
  802653:	ff d0                	callq  *%rax
  802655:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802658:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80265c:	79 05                	jns    802663 <ftruncate+0x58>
		return r;
  80265e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802661:	eb 72                	jmp    8026d5 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802663:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802667:	8b 40 08             	mov    0x8(%rax),%eax
  80266a:	83 e0 03             	and    $0x3,%eax
  80266d:	85 c0                	test   %eax,%eax
  80266f:	75 3a                	jne    8026ab <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802671:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802678:	00 00 00 
  80267b:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80267e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802684:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802687:	89 c6                	mov    %eax,%esi
  802689:	48 bf 70 4b 80 00 00 	movabs $0x804b70,%rdi
  802690:	00 00 00 
  802693:	b8 00 00 00 00       	mov    $0x0,%eax
  802698:	48 b9 90 03 80 00 00 	movabs $0x800390,%rcx
  80269f:	00 00 00 
  8026a2:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8026a4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026a9:	eb 2a                	jmp    8026d5 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8026ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026af:	48 8b 40 30          	mov    0x30(%rax),%rax
  8026b3:	48 85 c0             	test   %rax,%rax
  8026b6:	75 07                	jne    8026bf <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8026b8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8026bd:	eb 16                	jmp    8026d5 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8026bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026c3:	48 8b 40 30          	mov    0x30(%rax),%rax
  8026c7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8026cb:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8026ce:	89 ce                	mov    %ecx,%esi
  8026d0:	48 89 d7             	mov    %rdx,%rdi
  8026d3:	ff d0                	callq  *%rax
}
  8026d5:	c9                   	leaveq 
  8026d6:	c3                   	retq   

00000000008026d7 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8026d7:	55                   	push   %rbp
  8026d8:	48 89 e5             	mov    %rsp,%rbp
  8026db:	48 83 ec 30          	sub    $0x30,%rsp
  8026df:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8026e2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8026e6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026ea:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8026ed:	48 89 d6             	mov    %rdx,%rsi
  8026f0:	89 c7                	mov    %eax,%edi
  8026f2:	48 b8 76 1f 80 00 00 	movabs $0x801f76,%rax
  8026f9:	00 00 00 
  8026fc:	ff d0                	callq  *%rax
  8026fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802701:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802705:	78 24                	js     80272b <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802707:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80270b:	8b 00                	mov    (%rax),%eax
  80270d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802711:	48 89 d6             	mov    %rdx,%rsi
  802714:	89 c7                	mov    %eax,%edi
  802716:	48 b8 cf 20 80 00 00 	movabs $0x8020cf,%rax
  80271d:	00 00 00 
  802720:	ff d0                	callq  *%rax
  802722:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802725:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802729:	79 05                	jns    802730 <fstat+0x59>
		return r;
  80272b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80272e:	eb 5e                	jmp    80278e <fstat+0xb7>
	if (!dev->dev_stat)
  802730:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802734:	48 8b 40 28          	mov    0x28(%rax),%rax
  802738:	48 85 c0             	test   %rax,%rax
  80273b:	75 07                	jne    802744 <fstat+0x6d>
		return -E_NOT_SUPP;
  80273d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802742:	eb 4a                	jmp    80278e <fstat+0xb7>
	stat->st_name[0] = 0;
  802744:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802748:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80274b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80274f:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802756:	00 00 00 
	stat->st_isdir = 0;
  802759:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80275d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802764:	00 00 00 
	stat->st_dev = dev;
  802767:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80276b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80276f:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802776:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80277a:	48 8b 40 28          	mov    0x28(%rax),%rax
  80277e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802782:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802786:	48 89 ce             	mov    %rcx,%rsi
  802789:	48 89 d7             	mov    %rdx,%rdi
  80278c:	ff d0                	callq  *%rax
}
  80278e:	c9                   	leaveq 
  80278f:	c3                   	retq   

0000000000802790 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802790:	55                   	push   %rbp
  802791:	48 89 e5             	mov    %rsp,%rbp
  802794:	48 83 ec 20          	sub    $0x20,%rsp
  802798:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80279c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8027a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027a4:	be 00 00 00 00       	mov    $0x0,%esi
  8027a9:	48 89 c7             	mov    %rax,%rdi
  8027ac:	48 b8 7e 28 80 00 00 	movabs $0x80287e,%rax
  8027b3:	00 00 00 
  8027b6:	ff d0                	callq  *%rax
  8027b8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027bf:	79 05                	jns    8027c6 <stat+0x36>
		return fd;
  8027c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027c4:	eb 2f                	jmp    8027f5 <stat+0x65>
	r = fstat(fd, stat);
  8027c6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8027ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027cd:	48 89 d6             	mov    %rdx,%rsi
  8027d0:	89 c7                	mov    %eax,%edi
  8027d2:	48 b8 d7 26 80 00 00 	movabs $0x8026d7,%rax
  8027d9:	00 00 00 
  8027dc:	ff d0                	callq  *%rax
  8027de:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8027e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027e4:	89 c7                	mov    %eax,%edi
  8027e6:	48 b8 86 21 80 00 00 	movabs $0x802186,%rax
  8027ed:	00 00 00 
  8027f0:	ff d0                	callq  *%rax
	return r;
  8027f2:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8027f5:	c9                   	leaveq 
  8027f6:	c3                   	retq   

00000000008027f7 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8027f7:	55                   	push   %rbp
  8027f8:	48 89 e5             	mov    %rsp,%rbp
  8027fb:	48 83 ec 10          	sub    $0x10,%rsp
  8027ff:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802802:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802806:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80280d:	00 00 00 
  802810:	8b 00                	mov    (%rax),%eax
  802812:	85 c0                	test   %eax,%eax
  802814:	75 1d                	jne    802833 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802816:	bf 01 00 00 00       	mov    $0x1,%edi
  80281b:	48 b8 9c 44 80 00 00 	movabs $0x80449c,%rax
  802822:	00 00 00 
  802825:	ff d0                	callq  *%rax
  802827:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  80282e:	00 00 00 
  802831:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802833:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80283a:	00 00 00 
  80283d:	8b 00                	mov    (%rax),%eax
  80283f:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802842:	b9 07 00 00 00       	mov    $0x7,%ecx
  802847:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  80284e:	00 00 00 
  802851:	89 c7                	mov    %eax,%edi
  802853:	48 b8 3a 44 80 00 00 	movabs $0x80443a,%rax
  80285a:	00 00 00 
  80285d:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80285f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802863:	ba 00 00 00 00       	mov    $0x0,%edx
  802868:	48 89 c6             	mov    %rax,%rsi
  80286b:	bf 00 00 00 00       	mov    $0x0,%edi
  802870:	48 b8 34 43 80 00 00 	movabs $0x804334,%rax
  802877:	00 00 00 
  80287a:	ff d0                	callq  *%rax
}
  80287c:	c9                   	leaveq 
  80287d:	c3                   	retq   

000000000080287e <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80287e:	55                   	push   %rbp
  80287f:	48 89 e5             	mov    %rsp,%rbp
  802882:	48 83 ec 30          	sub    $0x30,%rsp
  802886:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80288a:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  80288d:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802894:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  80289b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  8028a2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8028a7:	75 08                	jne    8028b1 <open+0x33>
	{
		return r;
  8028a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028ac:	e9 f2 00 00 00       	jmpq   8029a3 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  8028b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028b5:	48 89 c7             	mov    %rax,%rdi
  8028b8:	48 b8 d9 0e 80 00 00 	movabs $0x800ed9,%rax
  8028bf:	00 00 00 
  8028c2:	ff d0                	callq  *%rax
  8028c4:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8028c7:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  8028ce:	7e 0a                	jle    8028da <open+0x5c>
	{
		return -E_BAD_PATH;
  8028d0:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8028d5:	e9 c9 00 00 00       	jmpq   8029a3 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  8028da:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8028e1:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  8028e2:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8028e6:	48 89 c7             	mov    %rax,%rdi
  8028e9:	48 b8 de 1e 80 00 00 	movabs $0x801ede,%rax
  8028f0:	00 00 00 
  8028f3:	ff d0                	callq  *%rax
  8028f5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028fc:	78 09                	js     802907 <open+0x89>
  8028fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802902:	48 85 c0             	test   %rax,%rax
  802905:	75 08                	jne    80290f <open+0x91>
		{
			return r;
  802907:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80290a:	e9 94 00 00 00       	jmpq   8029a3 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  80290f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802913:	ba 00 04 00 00       	mov    $0x400,%edx
  802918:	48 89 c6             	mov    %rax,%rsi
  80291b:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802922:	00 00 00 
  802925:	48 b8 d7 0f 80 00 00 	movabs $0x800fd7,%rax
  80292c:	00 00 00 
  80292f:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802931:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802938:	00 00 00 
  80293b:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  80293e:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802944:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802948:	48 89 c6             	mov    %rax,%rsi
  80294b:	bf 01 00 00 00       	mov    $0x1,%edi
  802950:	48 b8 f7 27 80 00 00 	movabs $0x8027f7,%rax
  802957:	00 00 00 
  80295a:	ff d0                	callq  *%rax
  80295c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80295f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802963:	79 2b                	jns    802990 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802965:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802969:	be 00 00 00 00       	mov    $0x0,%esi
  80296e:	48 89 c7             	mov    %rax,%rdi
  802971:	48 b8 06 20 80 00 00 	movabs $0x802006,%rax
  802978:	00 00 00 
  80297b:	ff d0                	callq  *%rax
  80297d:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802980:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802984:	79 05                	jns    80298b <open+0x10d>
			{
				return d;
  802986:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802989:	eb 18                	jmp    8029a3 <open+0x125>
			}
			return r;
  80298b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80298e:	eb 13                	jmp    8029a3 <open+0x125>
		}	
		return fd2num(fd_store);
  802990:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802994:	48 89 c7             	mov    %rax,%rdi
  802997:	48 b8 90 1e 80 00 00 	movabs $0x801e90,%rax
  80299e:	00 00 00 
  8029a1:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  8029a3:	c9                   	leaveq 
  8029a4:	c3                   	retq   

00000000008029a5 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8029a5:	55                   	push   %rbp
  8029a6:	48 89 e5             	mov    %rsp,%rbp
  8029a9:	48 83 ec 10          	sub    $0x10,%rsp
  8029ad:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8029b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029b5:	8b 50 0c             	mov    0xc(%rax),%edx
  8029b8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029bf:	00 00 00 
  8029c2:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8029c4:	be 00 00 00 00       	mov    $0x0,%esi
  8029c9:	bf 06 00 00 00       	mov    $0x6,%edi
  8029ce:	48 b8 f7 27 80 00 00 	movabs $0x8027f7,%rax
  8029d5:	00 00 00 
  8029d8:	ff d0                	callq  *%rax
}
  8029da:	c9                   	leaveq 
  8029db:	c3                   	retq   

00000000008029dc <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8029dc:	55                   	push   %rbp
  8029dd:	48 89 e5             	mov    %rsp,%rbp
  8029e0:	48 83 ec 30          	sub    $0x30,%rsp
  8029e4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029e8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8029ec:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  8029f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  8029f7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8029fc:	74 07                	je     802a05 <devfile_read+0x29>
  8029fe:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802a03:	75 07                	jne    802a0c <devfile_read+0x30>
		return -E_INVAL;
  802a05:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a0a:	eb 77                	jmp    802a83 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802a0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a10:	8b 50 0c             	mov    0xc(%rax),%edx
  802a13:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a1a:	00 00 00 
  802a1d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802a1f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a26:	00 00 00 
  802a29:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a2d:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802a31:	be 00 00 00 00       	mov    $0x0,%esi
  802a36:	bf 03 00 00 00       	mov    $0x3,%edi
  802a3b:	48 b8 f7 27 80 00 00 	movabs $0x8027f7,%rax
  802a42:	00 00 00 
  802a45:	ff d0                	callq  *%rax
  802a47:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a4a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a4e:	7f 05                	jg     802a55 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802a50:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a53:	eb 2e                	jmp    802a83 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802a55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a58:	48 63 d0             	movslq %eax,%rdx
  802a5b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a5f:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802a66:	00 00 00 
  802a69:	48 89 c7             	mov    %rax,%rdi
  802a6c:	48 b8 69 12 80 00 00 	movabs $0x801269,%rax
  802a73:	00 00 00 
  802a76:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802a78:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a7c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802a80:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802a83:	c9                   	leaveq 
  802a84:	c3                   	retq   

0000000000802a85 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802a85:	55                   	push   %rbp
  802a86:	48 89 e5             	mov    %rsp,%rbp
  802a89:	48 83 ec 30          	sub    $0x30,%rsp
  802a8d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a91:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a95:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802a99:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802aa0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802aa5:	74 07                	je     802aae <devfile_write+0x29>
  802aa7:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802aac:	75 08                	jne    802ab6 <devfile_write+0x31>
		return r;
  802aae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ab1:	e9 9a 00 00 00       	jmpq   802b50 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802ab6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aba:	8b 50 0c             	mov    0xc(%rax),%edx
  802abd:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ac4:	00 00 00 
  802ac7:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802ac9:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802ad0:	00 
  802ad1:	76 08                	jbe    802adb <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802ad3:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802ada:	00 
	}
	fsipcbuf.write.req_n = n;
  802adb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ae2:	00 00 00 
  802ae5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ae9:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802aed:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802af1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802af5:	48 89 c6             	mov    %rax,%rsi
  802af8:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802aff:	00 00 00 
  802b02:	48 b8 69 12 80 00 00 	movabs $0x801269,%rax
  802b09:	00 00 00 
  802b0c:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802b0e:	be 00 00 00 00       	mov    $0x0,%esi
  802b13:	bf 04 00 00 00       	mov    $0x4,%edi
  802b18:	48 b8 f7 27 80 00 00 	movabs $0x8027f7,%rax
  802b1f:	00 00 00 
  802b22:	ff d0                	callq  *%rax
  802b24:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b27:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b2b:	7f 20                	jg     802b4d <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802b2d:	48 bf 96 4b 80 00 00 	movabs $0x804b96,%rdi
  802b34:	00 00 00 
  802b37:	b8 00 00 00 00       	mov    $0x0,%eax
  802b3c:	48 ba 90 03 80 00 00 	movabs $0x800390,%rdx
  802b43:	00 00 00 
  802b46:	ff d2                	callq  *%rdx
		return r;
  802b48:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b4b:	eb 03                	jmp    802b50 <devfile_write+0xcb>
	}
	return r;
  802b4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802b50:	c9                   	leaveq 
  802b51:	c3                   	retq   

0000000000802b52 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802b52:	55                   	push   %rbp
  802b53:	48 89 e5             	mov    %rsp,%rbp
  802b56:	48 83 ec 20          	sub    $0x20,%rsp
  802b5a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b5e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802b62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b66:	8b 50 0c             	mov    0xc(%rax),%edx
  802b69:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b70:	00 00 00 
  802b73:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802b75:	be 00 00 00 00       	mov    $0x0,%esi
  802b7a:	bf 05 00 00 00       	mov    $0x5,%edi
  802b7f:	48 b8 f7 27 80 00 00 	movabs $0x8027f7,%rax
  802b86:	00 00 00 
  802b89:	ff d0                	callq  *%rax
  802b8b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b8e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b92:	79 05                	jns    802b99 <devfile_stat+0x47>
		return r;
  802b94:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b97:	eb 56                	jmp    802bef <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802b99:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b9d:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802ba4:	00 00 00 
  802ba7:	48 89 c7             	mov    %rax,%rdi
  802baa:	48 b8 45 0f 80 00 00 	movabs $0x800f45,%rax
  802bb1:	00 00 00 
  802bb4:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802bb6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802bbd:	00 00 00 
  802bc0:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802bc6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bca:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802bd0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802bd7:	00 00 00 
  802bda:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802be0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802be4:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802bea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bef:	c9                   	leaveq 
  802bf0:	c3                   	retq   

0000000000802bf1 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802bf1:	55                   	push   %rbp
  802bf2:	48 89 e5             	mov    %rsp,%rbp
  802bf5:	48 83 ec 10          	sub    $0x10,%rsp
  802bf9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802bfd:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802c00:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c04:	8b 50 0c             	mov    0xc(%rax),%edx
  802c07:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c0e:	00 00 00 
  802c11:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802c13:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c1a:	00 00 00 
  802c1d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802c20:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802c23:	be 00 00 00 00       	mov    $0x0,%esi
  802c28:	bf 02 00 00 00       	mov    $0x2,%edi
  802c2d:	48 b8 f7 27 80 00 00 	movabs $0x8027f7,%rax
  802c34:	00 00 00 
  802c37:	ff d0                	callq  *%rax
}
  802c39:	c9                   	leaveq 
  802c3a:	c3                   	retq   

0000000000802c3b <remove>:

// Delete a file
int
remove(const char *path)
{
  802c3b:	55                   	push   %rbp
  802c3c:	48 89 e5             	mov    %rsp,%rbp
  802c3f:	48 83 ec 10          	sub    $0x10,%rsp
  802c43:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802c47:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c4b:	48 89 c7             	mov    %rax,%rdi
  802c4e:	48 b8 d9 0e 80 00 00 	movabs $0x800ed9,%rax
  802c55:	00 00 00 
  802c58:	ff d0                	callq  *%rax
  802c5a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802c5f:	7e 07                	jle    802c68 <remove+0x2d>
		return -E_BAD_PATH;
  802c61:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802c66:	eb 33                	jmp    802c9b <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802c68:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c6c:	48 89 c6             	mov    %rax,%rsi
  802c6f:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802c76:	00 00 00 
  802c79:	48 b8 45 0f 80 00 00 	movabs $0x800f45,%rax
  802c80:	00 00 00 
  802c83:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802c85:	be 00 00 00 00       	mov    $0x0,%esi
  802c8a:	bf 07 00 00 00       	mov    $0x7,%edi
  802c8f:	48 b8 f7 27 80 00 00 	movabs $0x8027f7,%rax
  802c96:	00 00 00 
  802c99:	ff d0                	callq  *%rax
}
  802c9b:	c9                   	leaveq 
  802c9c:	c3                   	retq   

0000000000802c9d <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802c9d:	55                   	push   %rbp
  802c9e:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802ca1:	be 00 00 00 00       	mov    $0x0,%esi
  802ca6:	bf 08 00 00 00       	mov    $0x8,%edi
  802cab:	48 b8 f7 27 80 00 00 	movabs $0x8027f7,%rax
  802cb2:	00 00 00 
  802cb5:	ff d0                	callq  *%rax
}
  802cb7:	5d                   	pop    %rbp
  802cb8:	c3                   	retq   

0000000000802cb9 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802cb9:	55                   	push   %rbp
  802cba:	48 89 e5             	mov    %rsp,%rbp
  802cbd:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802cc4:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802ccb:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802cd2:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802cd9:	be 00 00 00 00       	mov    $0x0,%esi
  802cde:	48 89 c7             	mov    %rax,%rdi
  802ce1:	48 b8 7e 28 80 00 00 	movabs $0x80287e,%rax
  802ce8:	00 00 00 
  802ceb:	ff d0                	callq  *%rax
  802ced:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802cf0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cf4:	79 28                	jns    802d1e <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802cf6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cf9:	89 c6                	mov    %eax,%esi
  802cfb:	48 bf b2 4b 80 00 00 	movabs $0x804bb2,%rdi
  802d02:	00 00 00 
  802d05:	b8 00 00 00 00       	mov    $0x0,%eax
  802d0a:	48 ba 90 03 80 00 00 	movabs $0x800390,%rdx
  802d11:	00 00 00 
  802d14:	ff d2                	callq  *%rdx
		return fd_src;
  802d16:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d19:	e9 74 01 00 00       	jmpq   802e92 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802d1e:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802d25:	be 01 01 00 00       	mov    $0x101,%esi
  802d2a:	48 89 c7             	mov    %rax,%rdi
  802d2d:	48 b8 7e 28 80 00 00 	movabs $0x80287e,%rax
  802d34:	00 00 00 
  802d37:	ff d0                	callq  *%rax
  802d39:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802d3c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802d40:	79 39                	jns    802d7b <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802d42:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d45:	89 c6                	mov    %eax,%esi
  802d47:	48 bf c8 4b 80 00 00 	movabs $0x804bc8,%rdi
  802d4e:	00 00 00 
  802d51:	b8 00 00 00 00       	mov    $0x0,%eax
  802d56:	48 ba 90 03 80 00 00 	movabs $0x800390,%rdx
  802d5d:	00 00 00 
  802d60:	ff d2                	callq  *%rdx
		close(fd_src);
  802d62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d65:	89 c7                	mov    %eax,%edi
  802d67:	48 b8 86 21 80 00 00 	movabs $0x802186,%rax
  802d6e:	00 00 00 
  802d71:	ff d0                	callq  *%rax
		return fd_dest;
  802d73:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d76:	e9 17 01 00 00       	jmpq   802e92 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802d7b:	eb 74                	jmp    802df1 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802d7d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d80:	48 63 d0             	movslq %eax,%rdx
  802d83:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802d8a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d8d:	48 89 ce             	mov    %rcx,%rsi
  802d90:	89 c7                	mov    %eax,%edi
  802d92:	48 b8 f2 24 80 00 00 	movabs $0x8024f2,%rax
  802d99:	00 00 00 
  802d9c:	ff d0                	callq  *%rax
  802d9e:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802da1:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802da5:	79 4a                	jns    802df1 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802da7:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802daa:	89 c6                	mov    %eax,%esi
  802dac:	48 bf e2 4b 80 00 00 	movabs $0x804be2,%rdi
  802db3:	00 00 00 
  802db6:	b8 00 00 00 00       	mov    $0x0,%eax
  802dbb:	48 ba 90 03 80 00 00 	movabs $0x800390,%rdx
  802dc2:	00 00 00 
  802dc5:	ff d2                	callq  *%rdx
			close(fd_src);
  802dc7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dca:	89 c7                	mov    %eax,%edi
  802dcc:	48 b8 86 21 80 00 00 	movabs $0x802186,%rax
  802dd3:	00 00 00 
  802dd6:	ff d0                	callq  *%rax
			close(fd_dest);
  802dd8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ddb:	89 c7                	mov    %eax,%edi
  802ddd:	48 b8 86 21 80 00 00 	movabs $0x802186,%rax
  802de4:	00 00 00 
  802de7:	ff d0                	callq  *%rax
			return write_size;
  802de9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802dec:	e9 a1 00 00 00       	jmpq   802e92 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802df1:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802df8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dfb:	ba 00 02 00 00       	mov    $0x200,%edx
  802e00:	48 89 ce             	mov    %rcx,%rsi
  802e03:	89 c7                	mov    %eax,%edi
  802e05:	48 b8 a8 23 80 00 00 	movabs $0x8023a8,%rax
  802e0c:	00 00 00 
  802e0f:	ff d0                	callq  *%rax
  802e11:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802e14:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802e18:	0f 8f 5f ff ff ff    	jg     802d7d <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802e1e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802e22:	79 47                	jns    802e6b <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802e24:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e27:	89 c6                	mov    %eax,%esi
  802e29:	48 bf f5 4b 80 00 00 	movabs $0x804bf5,%rdi
  802e30:	00 00 00 
  802e33:	b8 00 00 00 00       	mov    $0x0,%eax
  802e38:	48 ba 90 03 80 00 00 	movabs $0x800390,%rdx
  802e3f:	00 00 00 
  802e42:	ff d2                	callq  *%rdx
		close(fd_src);
  802e44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e47:	89 c7                	mov    %eax,%edi
  802e49:	48 b8 86 21 80 00 00 	movabs $0x802186,%rax
  802e50:	00 00 00 
  802e53:	ff d0                	callq  *%rax
		close(fd_dest);
  802e55:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e58:	89 c7                	mov    %eax,%edi
  802e5a:	48 b8 86 21 80 00 00 	movabs $0x802186,%rax
  802e61:	00 00 00 
  802e64:	ff d0                	callq  *%rax
		return read_size;
  802e66:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e69:	eb 27                	jmp    802e92 <copy+0x1d9>
	}
	close(fd_src);
  802e6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e6e:	89 c7                	mov    %eax,%edi
  802e70:	48 b8 86 21 80 00 00 	movabs $0x802186,%rax
  802e77:	00 00 00 
  802e7a:	ff d0                	callq  *%rax
	close(fd_dest);
  802e7c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e7f:	89 c7                	mov    %eax,%edi
  802e81:	48 b8 86 21 80 00 00 	movabs $0x802186,%rax
  802e88:	00 00 00 
  802e8b:	ff d0                	callq  *%rax
	return 0;
  802e8d:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802e92:	c9                   	leaveq 
  802e93:	c3                   	retq   

0000000000802e94 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  802e94:	55                   	push   %rbp
  802e95:	48 89 e5             	mov    %rsp,%rbp
  802e98:	48 83 ec 20          	sub    $0x20,%rsp
  802e9c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  802ea0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ea4:	8b 40 0c             	mov    0xc(%rax),%eax
  802ea7:	85 c0                	test   %eax,%eax
  802ea9:	7e 67                	jle    802f12 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802eab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eaf:	8b 40 04             	mov    0x4(%rax),%eax
  802eb2:	48 63 d0             	movslq %eax,%rdx
  802eb5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eb9:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802ebd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ec1:	8b 00                	mov    (%rax),%eax
  802ec3:	48 89 ce             	mov    %rcx,%rsi
  802ec6:	89 c7                	mov    %eax,%edi
  802ec8:	48 b8 f2 24 80 00 00 	movabs $0x8024f2,%rax
  802ecf:	00 00 00 
  802ed2:	ff d0                	callq  *%rax
  802ed4:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  802ed7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802edb:	7e 13                	jle    802ef0 <writebuf+0x5c>
			b->result += result;
  802edd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ee1:	8b 50 08             	mov    0x8(%rax),%edx
  802ee4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ee7:	01 c2                	add    %eax,%edx
  802ee9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eed:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  802ef0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ef4:	8b 40 04             	mov    0x4(%rax),%eax
  802ef7:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802efa:	74 16                	je     802f12 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  802efc:	b8 00 00 00 00       	mov    $0x0,%eax
  802f01:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f05:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  802f09:	89 c2                	mov    %eax,%edx
  802f0b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f0f:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  802f12:	c9                   	leaveq 
  802f13:	c3                   	retq   

0000000000802f14 <putch>:

static void
putch(int ch, void *thunk)
{
  802f14:	55                   	push   %rbp
  802f15:	48 89 e5             	mov    %rsp,%rbp
  802f18:	48 83 ec 20          	sub    $0x20,%rsp
  802f1c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f1f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  802f23:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f27:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  802f2b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f2f:	8b 40 04             	mov    0x4(%rax),%eax
  802f32:	8d 48 01             	lea    0x1(%rax),%ecx
  802f35:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f39:	89 4a 04             	mov    %ecx,0x4(%rdx)
  802f3c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802f3f:	89 d1                	mov    %edx,%ecx
  802f41:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f45:	48 98                	cltq   
  802f47:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  802f4b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f4f:	8b 40 04             	mov    0x4(%rax),%eax
  802f52:	3d 00 01 00 00       	cmp    $0x100,%eax
  802f57:	75 1e                	jne    802f77 <putch+0x63>
		writebuf(b);
  802f59:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f5d:	48 89 c7             	mov    %rax,%rdi
  802f60:	48 b8 94 2e 80 00 00 	movabs $0x802e94,%rax
  802f67:	00 00 00 
  802f6a:	ff d0                	callq  *%rax
		b->idx = 0;
  802f6c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f70:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  802f77:	c9                   	leaveq 
  802f78:	c3                   	retq   

0000000000802f79 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802f79:	55                   	push   %rbp
  802f7a:	48 89 e5             	mov    %rsp,%rbp
  802f7d:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  802f84:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  802f8a:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  802f91:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  802f98:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  802f9e:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  802fa4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802fab:	00 00 00 
	b.result = 0;
  802fae:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  802fb5:	00 00 00 
	b.error = 1;
  802fb8:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  802fbf:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802fc2:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  802fc9:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  802fd0:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802fd7:	48 89 c6             	mov    %rax,%rsi
  802fda:	48 bf 14 2f 80 00 00 	movabs $0x802f14,%rdi
  802fe1:	00 00 00 
  802fe4:	48 b8 43 07 80 00 00 	movabs $0x800743,%rax
  802feb:	00 00 00 
  802fee:	ff d0                	callq  *%rax
	if (b.idx > 0)
  802ff0:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  802ff6:	85 c0                	test   %eax,%eax
  802ff8:	7e 16                	jle    803010 <vfprintf+0x97>
		writebuf(&b);
  802ffa:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  803001:	48 89 c7             	mov    %rax,%rdi
  803004:	48 b8 94 2e 80 00 00 	movabs $0x802e94,%rax
  80300b:	00 00 00 
  80300e:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  803010:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  803016:	85 c0                	test   %eax,%eax
  803018:	74 08                	je     803022 <vfprintf+0xa9>
  80301a:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  803020:	eb 06                	jmp    803028 <vfprintf+0xaf>
  803022:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  803028:	c9                   	leaveq 
  803029:	c3                   	retq   

000000000080302a <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  80302a:	55                   	push   %rbp
  80302b:	48 89 e5             	mov    %rsp,%rbp
  80302e:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  803035:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  80303b:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  803042:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803049:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803050:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803057:	84 c0                	test   %al,%al
  803059:	74 20                	je     80307b <fprintf+0x51>
  80305b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80305f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803063:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803067:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80306b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80306f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803073:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803077:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80307b:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  803082:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  803089:	00 00 00 
  80308c:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803093:	00 00 00 
  803096:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80309a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8030a1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8030a8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  8030af:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8030b6:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  8030bd:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8030c3:	48 89 ce             	mov    %rcx,%rsi
  8030c6:	89 c7                	mov    %eax,%edi
  8030c8:	48 b8 79 2f 80 00 00 	movabs $0x802f79,%rax
  8030cf:	00 00 00 
  8030d2:	ff d0                	callq  *%rax
  8030d4:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  8030da:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8030e0:	c9                   	leaveq 
  8030e1:	c3                   	retq   

00000000008030e2 <printf>:

int
printf(const char *fmt, ...)
{
  8030e2:	55                   	push   %rbp
  8030e3:	48 89 e5             	mov    %rsp,%rbp
  8030e6:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  8030ed:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8030f4:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8030fb:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803102:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803109:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803110:	84 c0                	test   %al,%al
  803112:	74 20                	je     803134 <printf+0x52>
  803114:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803118:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80311c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803120:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803124:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803128:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80312c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803130:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803134:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80313b:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  803142:	00 00 00 
  803145:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80314c:	00 00 00 
  80314f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803153:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80315a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803161:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  803168:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80316f:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803176:	48 89 c6             	mov    %rax,%rsi
  803179:	bf 01 00 00 00       	mov    $0x1,%edi
  80317e:	48 b8 79 2f 80 00 00 	movabs $0x802f79,%rax
  803185:	00 00 00 
  803188:	ff d0                	callq  *%rax
  80318a:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  803190:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803196:	c9                   	leaveq 
  803197:	c3                   	retq   

0000000000803198 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803198:	55                   	push   %rbp
  803199:	48 89 e5             	mov    %rsp,%rbp
  80319c:	48 83 ec 20          	sub    $0x20,%rsp
  8031a0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8031a3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8031a7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031aa:	48 89 d6             	mov    %rdx,%rsi
  8031ad:	89 c7                	mov    %eax,%edi
  8031af:	48 b8 76 1f 80 00 00 	movabs $0x801f76,%rax
  8031b6:	00 00 00 
  8031b9:	ff d0                	callq  *%rax
  8031bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031c2:	79 05                	jns    8031c9 <fd2sockid+0x31>
		return r;
  8031c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031c7:	eb 24                	jmp    8031ed <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8031c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031cd:	8b 10                	mov    (%rax),%edx
  8031cf:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  8031d6:	00 00 00 
  8031d9:	8b 00                	mov    (%rax),%eax
  8031db:	39 c2                	cmp    %eax,%edx
  8031dd:	74 07                	je     8031e6 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  8031df:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8031e4:	eb 07                	jmp    8031ed <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8031e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031ea:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8031ed:	c9                   	leaveq 
  8031ee:	c3                   	retq   

00000000008031ef <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8031ef:	55                   	push   %rbp
  8031f0:	48 89 e5             	mov    %rsp,%rbp
  8031f3:	48 83 ec 20          	sub    $0x20,%rsp
  8031f7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8031fa:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8031fe:	48 89 c7             	mov    %rax,%rdi
  803201:	48 b8 de 1e 80 00 00 	movabs $0x801ede,%rax
  803208:	00 00 00 
  80320b:	ff d0                	callq  *%rax
  80320d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803210:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803214:	78 26                	js     80323c <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803216:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80321a:	ba 07 04 00 00       	mov    $0x407,%edx
  80321f:	48 89 c6             	mov    %rax,%rsi
  803222:	bf 00 00 00 00       	mov    $0x0,%edi
  803227:	48 b8 74 18 80 00 00 	movabs $0x801874,%rax
  80322e:	00 00 00 
  803231:	ff d0                	callq  *%rax
  803233:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803236:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80323a:	79 16                	jns    803252 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  80323c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80323f:	89 c7                	mov    %eax,%edi
  803241:	48 b8 fc 36 80 00 00 	movabs $0x8036fc,%rax
  803248:	00 00 00 
  80324b:	ff d0                	callq  *%rax
		return r;
  80324d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803250:	eb 3a                	jmp    80328c <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803252:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803256:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  80325d:	00 00 00 
  803260:	8b 12                	mov    (%rdx),%edx
  803262:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803264:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803268:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  80326f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803273:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803276:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803279:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80327d:	48 89 c7             	mov    %rax,%rdi
  803280:	48 b8 90 1e 80 00 00 	movabs $0x801e90,%rax
  803287:	00 00 00 
  80328a:	ff d0                	callq  *%rax
}
  80328c:	c9                   	leaveq 
  80328d:	c3                   	retq   

000000000080328e <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80328e:	55                   	push   %rbp
  80328f:	48 89 e5             	mov    %rsp,%rbp
  803292:	48 83 ec 30          	sub    $0x30,%rsp
  803296:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803299:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80329d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8032a1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032a4:	89 c7                	mov    %eax,%edi
  8032a6:	48 b8 98 31 80 00 00 	movabs $0x803198,%rax
  8032ad:	00 00 00 
  8032b0:	ff d0                	callq  *%rax
  8032b2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032b9:	79 05                	jns    8032c0 <accept+0x32>
		return r;
  8032bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032be:	eb 3b                	jmp    8032fb <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8032c0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8032c4:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8032c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032cb:	48 89 ce             	mov    %rcx,%rsi
  8032ce:	89 c7                	mov    %eax,%edi
  8032d0:	48 b8 d9 35 80 00 00 	movabs $0x8035d9,%rax
  8032d7:	00 00 00 
  8032da:	ff d0                	callq  *%rax
  8032dc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032df:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032e3:	79 05                	jns    8032ea <accept+0x5c>
		return r;
  8032e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032e8:	eb 11                	jmp    8032fb <accept+0x6d>
	return alloc_sockfd(r);
  8032ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032ed:	89 c7                	mov    %eax,%edi
  8032ef:	48 b8 ef 31 80 00 00 	movabs $0x8031ef,%rax
  8032f6:	00 00 00 
  8032f9:	ff d0                	callq  *%rax
}
  8032fb:	c9                   	leaveq 
  8032fc:	c3                   	retq   

00000000008032fd <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8032fd:	55                   	push   %rbp
  8032fe:	48 89 e5             	mov    %rsp,%rbp
  803301:	48 83 ec 20          	sub    $0x20,%rsp
  803305:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803308:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80330c:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80330f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803312:	89 c7                	mov    %eax,%edi
  803314:	48 b8 98 31 80 00 00 	movabs $0x803198,%rax
  80331b:	00 00 00 
  80331e:	ff d0                	callq  *%rax
  803320:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803323:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803327:	79 05                	jns    80332e <bind+0x31>
		return r;
  803329:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80332c:	eb 1b                	jmp    803349 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  80332e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803331:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803335:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803338:	48 89 ce             	mov    %rcx,%rsi
  80333b:	89 c7                	mov    %eax,%edi
  80333d:	48 b8 58 36 80 00 00 	movabs $0x803658,%rax
  803344:	00 00 00 
  803347:	ff d0                	callq  *%rax
}
  803349:	c9                   	leaveq 
  80334a:	c3                   	retq   

000000000080334b <shutdown>:

int
shutdown(int s, int how)
{
  80334b:	55                   	push   %rbp
  80334c:	48 89 e5             	mov    %rsp,%rbp
  80334f:	48 83 ec 20          	sub    $0x20,%rsp
  803353:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803356:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803359:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80335c:	89 c7                	mov    %eax,%edi
  80335e:	48 b8 98 31 80 00 00 	movabs $0x803198,%rax
  803365:	00 00 00 
  803368:	ff d0                	callq  *%rax
  80336a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80336d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803371:	79 05                	jns    803378 <shutdown+0x2d>
		return r;
  803373:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803376:	eb 16                	jmp    80338e <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803378:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80337b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80337e:	89 d6                	mov    %edx,%esi
  803380:	89 c7                	mov    %eax,%edi
  803382:	48 b8 bc 36 80 00 00 	movabs $0x8036bc,%rax
  803389:	00 00 00 
  80338c:	ff d0                	callq  *%rax
}
  80338e:	c9                   	leaveq 
  80338f:	c3                   	retq   

0000000000803390 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803390:	55                   	push   %rbp
  803391:	48 89 e5             	mov    %rsp,%rbp
  803394:	48 83 ec 10          	sub    $0x10,%rsp
  803398:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  80339c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033a0:	48 89 c7             	mov    %rax,%rdi
  8033a3:	48 b8 1e 45 80 00 00 	movabs $0x80451e,%rax
  8033aa:	00 00 00 
  8033ad:	ff d0                	callq  *%rax
  8033af:	83 f8 01             	cmp    $0x1,%eax
  8033b2:	75 17                	jne    8033cb <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8033b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033b8:	8b 40 0c             	mov    0xc(%rax),%eax
  8033bb:	89 c7                	mov    %eax,%edi
  8033bd:	48 b8 fc 36 80 00 00 	movabs $0x8036fc,%rax
  8033c4:	00 00 00 
  8033c7:	ff d0                	callq  *%rax
  8033c9:	eb 05                	jmp    8033d0 <devsock_close+0x40>
	else
		return 0;
  8033cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033d0:	c9                   	leaveq 
  8033d1:	c3                   	retq   

00000000008033d2 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8033d2:	55                   	push   %rbp
  8033d3:	48 89 e5             	mov    %rsp,%rbp
  8033d6:	48 83 ec 20          	sub    $0x20,%rsp
  8033da:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8033dd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8033e1:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8033e4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033e7:	89 c7                	mov    %eax,%edi
  8033e9:	48 b8 98 31 80 00 00 	movabs $0x803198,%rax
  8033f0:	00 00 00 
  8033f3:	ff d0                	callq  *%rax
  8033f5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033fc:	79 05                	jns    803403 <connect+0x31>
		return r;
  8033fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803401:	eb 1b                	jmp    80341e <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803403:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803406:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80340a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80340d:	48 89 ce             	mov    %rcx,%rsi
  803410:	89 c7                	mov    %eax,%edi
  803412:	48 b8 29 37 80 00 00 	movabs $0x803729,%rax
  803419:	00 00 00 
  80341c:	ff d0                	callq  *%rax
}
  80341e:	c9                   	leaveq 
  80341f:	c3                   	retq   

0000000000803420 <listen>:

int
listen(int s, int backlog)
{
  803420:	55                   	push   %rbp
  803421:	48 89 e5             	mov    %rsp,%rbp
  803424:	48 83 ec 20          	sub    $0x20,%rsp
  803428:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80342b:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80342e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803431:	89 c7                	mov    %eax,%edi
  803433:	48 b8 98 31 80 00 00 	movabs $0x803198,%rax
  80343a:	00 00 00 
  80343d:	ff d0                	callq  *%rax
  80343f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803442:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803446:	79 05                	jns    80344d <listen+0x2d>
		return r;
  803448:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80344b:	eb 16                	jmp    803463 <listen+0x43>
	return nsipc_listen(r, backlog);
  80344d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803450:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803453:	89 d6                	mov    %edx,%esi
  803455:	89 c7                	mov    %eax,%edi
  803457:	48 b8 8d 37 80 00 00 	movabs $0x80378d,%rax
  80345e:	00 00 00 
  803461:	ff d0                	callq  *%rax
}
  803463:	c9                   	leaveq 
  803464:	c3                   	retq   

0000000000803465 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803465:	55                   	push   %rbp
  803466:	48 89 e5             	mov    %rsp,%rbp
  803469:	48 83 ec 20          	sub    $0x20,%rsp
  80346d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803471:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803475:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803479:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80347d:	89 c2                	mov    %eax,%edx
  80347f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803483:	8b 40 0c             	mov    0xc(%rax),%eax
  803486:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80348a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80348f:	89 c7                	mov    %eax,%edi
  803491:	48 b8 cd 37 80 00 00 	movabs $0x8037cd,%rax
  803498:	00 00 00 
  80349b:	ff d0                	callq  *%rax
}
  80349d:	c9                   	leaveq 
  80349e:	c3                   	retq   

000000000080349f <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80349f:	55                   	push   %rbp
  8034a0:	48 89 e5             	mov    %rsp,%rbp
  8034a3:	48 83 ec 20          	sub    $0x20,%rsp
  8034a7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8034ab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8034af:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8034b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034b7:	89 c2                	mov    %eax,%edx
  8034b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034bd:	8b 40 0c             	mov    0xc(%rax),%eax
  8034c0:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8034c4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8034c9:	89 c7                	mov    %eax,%edi
  8034cb:	48 b8 99 38 80 00 00 	movabs $0x803899,%rax
  8034d2:	00 00 00 
  8034d5:	ff d0                	callq  *%rax
}
  8034d7:	c9                   	leaveq 
  8034d8:	c3                   	retq   

00000000008034d9 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8034d9:	55                   	push   %rbp
  8034da:	48 89 e5             	mov    %rsp,%rbp
  8034dd:	48 83 ec 10          	sub    $0x10,%rsp
  8034e1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8034e5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8034e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034ed:	48 be 10 4c 80 00 00 	movabs $0x804c10,%rsi
  8034f4:	00 00 00 
  8034f7:	48 89 c7             	mov    %rax,%rdi
  8034fa:	48 b8 45 0f 80 00 00 	movabs $0x800f45,%rax
  803501:	00 00 00 
  803504:	ff d0                	callq  *%rax
	return 0;
  803506:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80350b:	c9                   	leaveq 
  80350c:	c3                   	retq   

000000000080350d <socket>:

int
socket(int domain, int type, int protocol)
{
  80350d:	55                   	push   %rbp
  80350e:	48 89 e5             	mov    %rsp,%rbp
  803511:	48 83 ec 20          	sub    $0x20,%rsp
  803515:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803518:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80351b:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80351e:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803521:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803524:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803527:	89 ce                	mov    %ecx,%esi
  803529:	89 c7                	mov    %eax,%edi
  80352b:	48 b8 51 39 80 00 00 	movabs $0x803951,%rax
  803532:	00 00 00 
  803535:	ff d0                	callq  *%rax
  803537:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80353a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80353e:	79 05                	jns    803545 <socket+0x38>
		return r;
  803540:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803543:	eb 11                	jmp    803556 <socket+0x49>
	return alloc_sockfd(r);
  803545:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803548:	89 c7                	mov    %eax,%edi
  80354a:	48 b8 ef 31 80 00 00 	movabs $0x8031ef,%rax
  803551:	00 00 00 
  803554:	ff d0                	callq  *%rax
}
  803556:	c9                   	leaveq 
  803557:	c3                   	retq   

0000000000803558 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803558:	55                   	push   %rbp
  803559:	48 89 e5             	mov    %rsp,%rbp
  80355c:	48 83 ec 10          	sub    $0x10,%rsp
  803560:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803563:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80356a:	00 00 00 
  80356d:	8b 00                	mov    (%rax),%eax
  80356f:	85 c0                	test   %eax,%eax
  803571:	75 1d                	jne    803590 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803573:	bf 02 00 00 00       	mov    $0x2,%edi
  803578:	48 b8 9c 44 80 00 00 	movabs $0x80449c,%rax
  80357f:	00 00 00 
  803582:	ff d0                	callq  *%rax
  803584:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  80358b:	00 00 00 
  80358e:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803590:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803597:	00 00 00 
  80359a:	8b 00                	mov    (%rax),%eax
  80359c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80359f:	b9 07 00 00 00       	mov    $0x7,%ecx
  8035a4:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8035ab:	00 00 00 
  8035ae:	89 c7                	mov    %eax,%edi
  8035b0:	48 b8 3a 44 80 00 00 	movabs $0x80443a,%rax
  8035b7:	00 00 00 
  8035ba:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8035bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8035c1:	be 00 00 00 00       	mov    $0x0,%esi
  8035c6:	bf 00 00 00 00       	mov    $0x0,%edi
  8035cb:	48 b8 34 43 80 00 00 	movabs $0x804334,%rax
  8035d2:	00 00 00 
  8035d5:	ff d0                	callq  *%rax
}
  8035d7:	c9                   	leaveq 
  8035d8:	c3                   	retq   

00000000008035d9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8035d9:	55                   	push   %rbp
  8035da:	48 89 e5             	mov    %rsp,%rbp
  8035dd:	48 83 ec 30          	sub    $0x30,%rsp
  8035e1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8035e4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8035e8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8035ec:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035f3:	00 00 00 
  8035f6:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8035f9:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8035fb:	bf 01 00 00 00       	mov    $0x1,%edi
  803600:	48 b8 58 35 80 00 00 	movabs $0x803558,%rax
  803607:	00 00 00 
  80360a:	ff d0                	callq  *%rax
  80360c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80360f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803613:	78 3e                	js     803653 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803615:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80361c:	00 00 00 
  80361f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803623:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803627:	8b 40 10             	mov    0x10(%rax),%eax
  80362a:	89 c2                	mov    %eax,%edx
  80362c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803630:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803634:	48 89 ce             	mov    %rcx,%rsi
  803637:	48 89 c7             	mov    %rax,%rdi
  80363a:	48 b8 69 12 80 00 00 	movabs $0x801269,%rax
  803641:	00 00 00 
  803644:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803646:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80364a:	8b 50 10             	mov    0x10(%rax),%edx
  80364d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803651:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803653:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803656:	c9                   	leaveq 
  803657:	c3                   	retq   

0000000000803658 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803658:	55                   	push   %rbp
  803659:	48 89 e5             	mov    %rsp,%rbp
  80365c:	48 83 ec 10          	sub    $0x10,%rsp
  803660:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803663:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803667:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  80366a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803671:	00 00 00 
  803674:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803677:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803679:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80367c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803680:	48 89 c6             	mov    %rax,%rsi
  803683:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80368a:	00 00 00 
  80368d:	48 b8 69 12 80 00 00 	movabs $0x801269,%rax
  803694:	00 00 00 
  803697:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803699:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036a0:	00 00 00 
  8036a3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8036a6:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8036a9:	bf 02 00 00 00       	mov    $0x2,%edi
  8036ae:	48 b8 58 35 80 00 00 	movabs $0x803558,%rax
  8036b5:	00 00 00 
  8036b8:	ff d0                	callq  *%rax
}
  8036ba:	c9                   	leaveq 
  8036bb:	c3                   	retq   

00000000008036bc <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8036bc:	55                   	push   %rbp
  8036bd:	48 89 e5             	mov    %rsp,%rbp
  8036c0:	48 83 ec 10          	sub    $0x10,%rsp
  8036c4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8036c7:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8036ca:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036d1:	00 00 00 
  8036d4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8036d7:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8036d9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036e0:	00 00 00 
  8036e3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8036e6:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8036e9:	bf 03 00 00 00       	mov    $0x3,%edi
  8036ee:	48 b8 58 35 80 00 00 	movabs $0x803558,%rax
  8036f5:	00 00 00 
  8036f8:	ff d0                	callq  *%rax
}
  8036fa:	c9                   	leaveq 
  8036fb:	c3                   	retq   

00000000008036fc <nsipc_close>:

int
nsipc_close(int s)
{
  8036fc:	55                   	push   %rbp
  8036fd:	48 89 e5             	mov    %rsp,%rbp
  803700:	48 83 ec 10          	sub    $0x10,%rsp
  803704:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803707:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80370e:	00 00 00 
  803711:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803714:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803716:	bf 04 00 00 00       	mov    $0x4,%edi
  80371b:	48 b8 58 35 80 00 00 	movabs $0x803558,%rax
  803722:	00 00 00 
  803725:	ff d0                	callq  *%rax
}
  803727:	c9                   	leaveq 
  803728:	c3                   	retq   

0000000000803729 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803729:	55                   	push   %rbp
  80372a:	48 89 e5             	mov    %rsp,%rbp
  80372d:	48 83 ec 10          	sub    $0x10,%rsp
  803731:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803734:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803738:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  80373b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803742:	00 00 00 
  803745:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803748:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80374a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80374d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803751:	48 89 c6             	mov    %rax,%rsi
  803754:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80375b:	00 00 00 
  80375e:	48 b8 69 12 80 00 00 	movabs $0x801269,%rax
  803765:	00 00 00 
  803768:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  80376a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803771:	00 00 00 
  803774:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803777:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  80377a:	bf 05 00 00 00       	mov    $0x5,%edi
  80377f:	48 b8 58 35 80 00 00 	movabs $0x803558,%rax
  803786:	00 00 00 
  803789:	ff d0                	callq  *%rax
}
  80378b:	c9                   	leaveq 
  80378c:	c3                   	retq   

000000000080378d <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80378d:	55                   	push   %rbp
  80378e:	48 89 e5             	mov    %rsp,%rbp
  803791:	48 83 ec 10          	sub    $0x10,%rsp
  803795:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803798:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  80379b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037a2:	00 00 00 
  8037a5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8037a8:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8037aa:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037b1:	00 00 00 
  8037b4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8037b7:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8037ba:	bf 06 00 00 00       	mov    $0x6,%edi
  8037bf:	48 b8 58 35 80 00 00 	movabs $0x803558,%rax
  8037c6:	00 00 00 
  8037c9:	ff d0                	callq  *%rax
}
  8037cb:	c9                   	leaveq 
  8037cc:	c3                   	retq   

00000000008037cd <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8037cd:	55                   	push   %rbp
  8037ce:	48 89 e5             	mov    %rsp,%rbp
  8037d1:	48 83 ec 30          	sub    $0x30,%rsp
  8037d5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8037d8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8037dc:	89 55 e8             	mov    %edx,-0x18(%rbp)
  8037df:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  8037e2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037e9:	00 00 00 
  8037ec:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8037ef:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8037f1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037f8:	00 00 00 
  8037fb:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8037fe:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803801:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803808:	00 00 00 
  80380b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80380e:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803811:	bf 07 00 00 00       	mov    $0x7,%edi
  803816:	48 b8 58 35 80 00 00 	movabs $0x803558,%rax
  80381d:	00 00 00 
  803820:	ff d0                	callq  *%rax
  803822:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803825:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803829:	78 69                	js     803894 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  80382b:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803832:	7f 08                	jg     80383c <nsipc_recv+0x6f>
  803834:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803837:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  80383a:	7e 35                	jle    803871 <nsipc_recv+0xa4>
  80383c:	48 b9 17 4c 80 00 00 	movabs $0x804c17,%rcx
  803843:	00 00 00 
  803846:	48 ba 2c 4c 80 00 00 	movabs $0x804c2c,%rdx
  80384d:	00 00 00 
  803850:	be 61 00 00 00       	mov    $0x61,%esi
  803855:	48 bf 41 4c 80 00 00 	movabs $0x804c41,%rdi
  80385c:	00 00 00 
  80385f:	b8 00 00 00 00       	mov    $0x0,%eax
  803864:	49 b8 20 42 80 00 00 	movabs $0x804220,%r8
  80386b:	00 00 00 
  80386e:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803871:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803874:	48 63 d0             	movslq %eax,%rdx
  803877:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80387b:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803882:	00 00 00 
  803885:	48 89 c7             	mov    %rax,%rdi
  803888:	48 b8 69 12 80 00 00 	movabs $0x801269,%rax
  80388f:	00 00 00 
  803892:	ff d0                	callq  *%rax
	}

	return r;
  803894:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803897:	c9                   	leaveq 
  803898:	c3                   	retq   

0000000000803899 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803899:	55                   	push   %rbp
  80389a:	48 89 e5             	mov    %rsp,%rbp
  80389d:	48 83 ec 20          	sub    $0x20,%rsp
  8038a1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8038a4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8038a8:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8038ab:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8038ae:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038b5:	00 00 00 
  8038b8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8038bb:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8038bd:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  8038c4:	7e 35                	jle    8038fb <nsipc_send+0x62>
  8038c6:	48 b9 4d 4c 80 00 00 	movabs $0x804c4d,%rcx
  8038cd:	00 00 00 
  8038d0:	48 ba 2c 4c 80 00 00 	movabs $0x804c2c,%rdx
  8038d7:	00 00 00 
  8038da:	be 6c 00 00 00       	mov    $0x6c,%esi
  8038df:	48 bf 41 4c 80 00 00 	movabs $0x804c41,%rdi
  8038e6:	00 00 00 
  8038e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8038ee:	49 b8 20 42 80 00 00 	movabs $0x804220,%r8
  8038f5:	00 00 00 
  8038f8:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8038fb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038fe:	48 63 d0             	movslq %eax,%rdx
  803901:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803905:	48 89 c6             	mov    %rax,%rsi
  803908:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  80390f:	00 00 00 
  803912:	48 b8 69 12 80 00 00 	movabs $0x801269,%rax
  803919:	00 00 00 
  80391c:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  80391e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803925:	00 00 00 
  803928:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80392b:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  80392e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803935:	00 00 00 
  803938:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80393b:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  80393e:	bf 08 00 00 00       	mov    $0x8,%edi
  803943:	48 b8 58 35 80 00 00 	movabs $0x803558,%rax
  80394a:	00 00 00 
  80394d:	ff d0                	callq  *%rax
}
  80394f:	c9                   	leaveq 
  803950:	c3                   	retq   

0000000000803951 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803951:	55                   	push   %rbp
  803952:	48 89 e5             	mov    %rsp,%rbp
  803955:	48 83 ec 10          	sub    $0x10,%rsp
  803959:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80395c:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80395f:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803962:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803969:	00 00 00 
  80396c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80396f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803971:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803978:	00 00 00 
  80397b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80397e:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803981:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803988:	00 00 00 
  80398b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80398e:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803991:	bf 09 00 00 00       	mov    $0x9,%edi
  803996:	48 b8 58 35 80 00 00 	movabs $0x803558,%rax
  80399d:	00 00 00 
  8039a0:	ff d0                	callq  *%rax
}
  8039a2:	c9                   	leaveq 
  8039a3:	c3                   	retq   

00000000008039a4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8039a4:	55                   	push   %rbp
  8039a5:	48 89 e5             	mov    %rsp,%rbp
  8039a8:	53                   	push   %rbx
  8039a9:	48 83 ec 38          	sub    $0x38,%rsp
  8039ad:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8039b1:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8039b5:	48 89 c7             	mov    %rax,%rdi
  8039b8:	48 b8 de 1e 80 00 00 	movabs $0x801ede,%rax
  8039bf:	00 00 00 
  8039c2:	ff d0                	callq  *%rax
  8039c4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8039c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8039cb:	0f 88 bf 01 00 00    	js     803b90 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8039d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039d5:	ba 07 04 00 00       	mov    $0x407,%edx
  8039da:	48 89 c6             	mov    %rax,%rsi
  8039dd:	bf 00 00 00 00       	mov    $0x0,%edi
  8039e2:	48 b8 74 18 80 00 00 	movabs $0x801874,%rax
  8039e9:	00 00 00 
  8039ec:	ff d0                	callq  *%rax
  8039ee:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8039f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8039f5:	0f 88 95 01 00 00    	js     803b90 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8039fb:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8039ff:	48 89 c7             	mov    %rax,%rdi
  803a02:	48 b8 de 1e 80 00 00 	movabs $0x801ede,%rax
  803a09:	00 00 00 
  803a0c:	ff d0                	callq  *%rax
  803a0e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a11:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a15:	0f 88 5d 01 00 00    	js     803b78 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a1b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a1f:	ba 07 04 00 00       	mov    $0x407,%edx
  803a24:	48 89 c6             	mov    %rax,%rsi
  803a27:	bf 00 00 00 00       	mov    $0x0,%edi
  803a2c:	48 b8 74 18 80 00 00 	movabs $0x801874,%rax
  803a33:	00 00 00 
  803a36:	ff d0                	callq  *%rax
  803a38:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a3b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a3f:	0f 88 33 01 00 00    	js     803b78 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803a45:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a49:	48 89 c7             	mov    %rax,%rdi
  803a4c:	48 b8 b3 1e 80 00 00 	movabs $0x801eb3,%rax
  803a53:	00 00 00 
  803a56:	ff d0                	callq  *%rax
  803a58:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a5c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a60:	ba 07 04 00 00       	mov    $0x407,%edx
  803a65:	48 89 c6             	mov    %rax,%rsi
  803a68:	bf 00 00 00 00       	mov    $0x0,%edi
  803a6d:	48 b8 74 18 80 00 00 	movabs $0x801874,%rax
  803a74:	00 00 00 
  803a77:	ff d0                	callq  *%rax
  803a79:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a7c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a80:	79 05                	jns    803a87 <pipe+0xe3>
		goto err2;
  803a82:	e9 d9 00 00 00       	jmpq   803b60 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a87:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a8b:	48 89 c7             	mov    %rax,%rdi
  803a8e:	48 b8 b3 1e 80 00 00 	movabs $0x801eb3,%rax
  803a95:	00 00 00 
  803a98:	ff d0                	callq  *%rax
  803a9a:	48 89 c2             	mov    %rax,%rdx
  803a9d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803aa1:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803aa7:	48 89 d1             	mov    %rdx,%rcx
  803aaa:	ba 00 00 00 00       	mov    $0x0,%edx
  803aaf:	48 89 c6             	mov    %rax,%rsi
  803ab2:	bf 00 00 00 00       	mov    $0x0,%edi
  803ab7:	48 b8 c4 18 80 00 00 	movabs $0x8018c4,%rax
  803abe:	00 00 00 
  803ac1:	ff d0                	callq  *%rax
  803ac3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ac6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803aca:	79 1b                	jns    803ae7 <pipe+0x143>
		goto err3;
  803acc:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803acd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ad1:	48 89 c6             	mov    %rax,%rsi
  803ad4:	bf 00 00 00 00       	mov    $0x0,%edi
  803ad9:	48 b8 1f 19 80 00 00 	movabs $0x80191f,%rax
  803ae0:	00 00 00 
  803ae3:	ff d0                	callq  *%rax
  803ae5:	eb 79                	jmp    803b60 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803ae7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803aeb:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803af2:	00 00 00 
  803af5:	8b 12                	mov    (%rdx),%edx
  803af7:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803af9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803afd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803b04:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b08:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803b0f:	00 00 00 
  803b12:	8b 12                	mov    (%rdx),%edx
  803b14:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803b16:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b1a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803b21:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b25:	48 89 c7             	mov    %rax,%rdi
  803b28:	48 b8 90 1e 80 00 00 	movabs $0x801e90,%rax
  803b2f:	00 00 00 
  803b32:	ff d0                	callq  *%rax
  803b34:	89 c2                	mov    %eax,%edx
  803b36:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803b3a:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803b3c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803b40:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803b44:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b48:	48 89 c7             	mov    %rax,%rdi
  803b4b:	48 b8 90 1e 80 00 00 	movabs $0x801e90,%rax
  803b52:	00 00 00 
  803b55:	ff d0                	callq  *%rax
  803b57:	89 03                	mov    %eax,(%rbx)
	return 0;
  803b59:	b8 00 00 00 00       	mov    $0x0,%eax
  803b5e:	eb 33                	jmp    803b93 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803b60:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b64:	48 89 c6             	mov    %rax,%rsi
  803b67:	bf 00 00 00 00       	mov    $0x0,%edi
  803b6c:	48 b8 1f 19 80 00 00 	movabs $0x80191f,%rax
  803b73:	00 00 00 
  803b76:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803b78:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b7c:	48 89 c6             	mov    %rax,%rsi
  803b7f:	bf 00 00 00 00       	mov    $0x0,%edi
  803b84:	48 b8 1f 19 80 00 00 	movabs $0x80191f,%rax
  803b8b:	00 00 00 
  803b8e:	ff d0                	callq  *%rax
err:
	return r;
  803b90:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803b93:	48 83 c4 38          	add    $0x38,%rsp
  803b97:	5b                   	pop    %rbx
  803b98:	5d                   	pop    %rbp
  803b99:	c3                   	retq   

0000000000803b9a <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803b9a:	55                   	push   %rbp
  803b9b:	48 89 e5             	mov    %rsp,%rbp
  803b9e:	53                   	push   %rbx
  803b9f:	48 83 ec 28          	sub    $0x28,%rsp
  803ba3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803ba7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803bab:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803bb2:	00 00 00 
  803bb5:	48 8b 00             	mov    (%rax),%rax
  803bb8:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803bbe:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803bc1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bc5:	48 89 c7             	mov    %rax,%rdi
  803bc8:	48 b8 1e 45 80 00 00 	movabs $0x80451e,%rax
  803bcf:	00 00 00 
  803bd2:	ff d0                	callq  *%rax
  803bd4:	89 c3                	mov    %eax,%ebx
  803bd6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bda:	48 89 c7             	mov    %rax,%rdi
  803bdd:	48 b8 1e 45 80 00 00 	movabs $0x80451e,%rax
  803be4:	00 00 00 
  803be7:	ff d0                	callq  *%rax
  803be9:	39 c3                	cmp    %eax,%ebx
  803beb:	0f 94 c0             	sete   %al
  803bee:	0f b6 c0             	movzbl %al,%eax
  803bf1:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803bf4:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803bfb:	00 00 00 
  803bfe:	48 8b 00             	mov    (%rax),%rax
  803c01:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803c07:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803c0a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c0d:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803c10:	75 05                	jne    803c17 <_pipeisclosed+0x7d>
			return ret;
  803c12:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803c15:	eb 4f                	jmp    803c66 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803c17:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c1a:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803c1d:	74 42                	je     803c61 <_pipeisclosed+0xc7>
  803c1f:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803c23:	75 3c                	jne    803c61 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803c25:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c2c:	00 00 00 
  803c2f:	48 8b 00             	mov    (%rax),%rax
  803c32:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803c38:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803c3b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c3e:	89 c6                	mov    %eax,%esi
  803c40:	48 bf 5e 4c 80 00 00 	movabs $0x804c5e,%rdi
  803c47:	00 00 00 
  803c4a:	b8 00 00 00 00       	mov    $0x0,%eax
  803c4f:	49 b8 90 03 80 00 00 	movabs $0x800390,%r8
  803c56:	00 00 00 
  803c59:	41 ff d0             	callq  *%r8
	}
  803c5c:	e9 4a ff ff ff       	jmpq   803bab <_pipeisclosed+0x11>
  803c61:	e9 45 ff ff ff       	jmpq   803bab <_pipeisclosed+0x11>
}
  803c66:	48 83 c4 28          	add    $0x28,%rsp
  803c6a:	5b                   	pop    %rbx
  803c6b:	5d                   	pop    %rbp
  803c6c:	c3                   	retq   

0000000000803c6d <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803c6d:	55                   	push   %rbp
  803c6e:	48 89 e5             	mov    %rsp,%rbp
  803c71:	48 83 ec 30          	sub    $0x30,%rsp
  803c75:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803c78:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803c7c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803c7f:	48 89 d6             	mov    %rdx,%rsi
  803c82:	89 c7                	mov    %eax,%edi
  803c84:	48 b8 76 1f 80 00 00 	movabs $0x801f76,%rax
  803c8b:	00 00 00 
  803c8e:	ff d0                	callq  *%rax
  803c90:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c93:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c97:	79 05                	jns    803c9e <pipeisclosed+0x31>
		return r;
  803c99:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c9c:	eb 31                	jmp    803ccf <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803c9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ca2:	48 89 c7             	mov    %rax,%rdi
  803ca5:	48 b8 b3 1e 80 00 00 	movabs $0x801eb3,%rax
  803cac:	00 00 00 
  803caf:	ff d0                	callq  *%rax
  803cb1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803cb5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cb9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803cbd:	48 89 d6             	mov    %rdx,%rsi
  803cc0:	48 89 c7             	mov    %rax,%rdi
  803cc3:	48 b8 9a 3b 80 00 00 	movabs $0x803b9a,%rax
  803cca:	00 00 00 
  803ccd:	ff d0                	callq  *%rax
}
  803ccf:	c9                   	leaveq 
  803cd0:	c3                   	retq   

0000000000803cd1 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803cd1:	55                   	push   %rbp
  803cd2:	48 89 e5             	mov    %rsp,%rbp
  803cd5:	48 83 ec 40          	sub    $0x40,%rsp
  803cd9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803cdd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803ce1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803ce5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ce9:	48 89 c7             	mov    %rax,%rdi
  803cec:	48 b8 b3 1e 80 00 00 	movabs $0x801eb3,%rax
  803cf3:	00 00 00 
  803cf6:	ff d0                	callq  *%rax
  803cf8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803cfc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d00:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803d04:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803d0b:	00 
  803d0c:	e9 92 00 00 00       	jmpq   803da3 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803d11:	eb 41                	jmp    803d54 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803d13:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803d18:	74 09                	je     803d23 <devpipe_read+0x52>
				return i;
  803d1a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d1e:	e9 92 00 00 00       	jmpq   803db5 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803d23:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d27:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d2b:	48 89 d6             	mov    %rdx,%rsi
  803d2e:	48 89 c7             	mov    %rax,%rdi
  803d31:	48 b8 9a 3b 80 00 00 	movabs $0x803b9a,%rax
  803d38:	00 00 00 
  803d3b:	ff d0                	callq  *%rax
  803d3d:	85 c0                	test   %eax,%eax
  803d3f:	74 07                	je     803d48 <devpipe_read+0x77>
				return 0;
  803d41:	b8 00 00 00 00       	mov    $0x0,%eax
  803d46:	eb 6d                	jmp    803db5 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803d48:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  803d4f:	00 00 00 
  803d52:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803d54:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d58:	8b 10                	mov    (%rax),%edx
  803d5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d5e:	8b 40 04             	mov    0x4(%rax),%eax
  803d61:	39 c2                	cmp    %eax,%edx
  803d63:	74 ae                	je     803d13 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803d65:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d69:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803d6d:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803d71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d75:	8b 00                	mov    (%rax),%eax
  803d77:	99                   	cltd   
  803d78:	c1 ea 1b             	shr    $0x1b,%edx
  803d7b:	01 d0                	add    %edx,%eax
  803d7d:	83 e0 1f             	and    $0x1f,%eax
  803d80:	29 d0                	sub    %edx,%eax
  803d82:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d86:	48 98                	cltq   
  803d88:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803d8d:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803d8f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d93:	8b 00                	mov    (%rax),%eax
  803d95:	8d 50 01             	lea    0x1(%rax),%edx
  803d98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d9c:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803d9e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803da3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803da7:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803dab:	0f 82 60 ff ff ff    	jb     803d11 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803db1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803db5:	c9                   	leaveq 
  803db6:	c3                   	retq   

0000000000803db7 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803db7:	55                   	push   %rbp
  803db8:	48 89 e5             	mov    %rsp,%rbp
  803dbb:	48 83 ec 40          	sub    $0x40,%rsp
  803dbf:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803dc3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803dc7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803dcb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dcf:	48 89 c7             	mov    %rax,%rdi
  803dd2:	48 b8 b3 1e 80 00 00 	movabs $0x801eb3,%rax
  803dd9:	00 00 00 
  803ddc:	ff d0                	callq  *%rax
  803dde:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803de2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803de6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803dea:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803df1:	00 
  803df2:	e9 8e 00 00 00       	jmpq   803e85 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803df7:	eb 31                	jmp    803e2a <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803df9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803dfd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e01:	48 89 d6             	mov    %rdx,%rsi
  803e04:	48 89 c7             	mov    %rax,%rdi
  803e07:	48 b8 9a 3b 80 00 00 	movabs $0x803b9a,%rax
  803e0e:	00 00 00 
  803e11:	ff d0                	callq  *%rax
  803e13:	85 c0                	test   %eax,%eax
  803e15:	74 07                	je     803e1e <devpipe_write+0x67>
				return 0;
  803e17:	b8 00 00 00 00       	mov    $0x0,%eax
  803e1c:	eb 79                	jmp    803e97 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803e1e:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  803e25:	00 00 00 
  803e28:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803e2a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e2e:	8b 40 04             	mov    0x4(%rax),%eax
  803e31:	48 63 d0             	movslq %eax,%rdx
  803e34:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e38:	8b 00                	mov    (%rax),%eax
  803e3a:	48 98                	cltq   
  803e3c:	48 83 c0 20          	add    $0x20,%rax
  803e40:	48 39 c2             	cmp    %rax,%rdx
  803e43:	73 b4                	jae    803df9 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803e45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e49:	8b 40 04             	mov    0x4(%rax),%eax
  803e4c:	99                   	cltd   
  803e4d:	c1 ea 1b             	shr    $0x1b,%edx
  803e50:	01 d0                	add    %edx,%eax
  803e52:	83 e0 1f             	and    $0x1f,%eax
  803e55:	29 d0                	sub    %edx,%eax
  803e57:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803e5b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803e5f:	48 01 ca             	add    %rcx,%rdx
  803e62:	0f b6 0a             	movzbl (%rdx),%ecx
  803e65:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e69:	48 98                	cltq   
  803e6b:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803e6f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e73:	8b 40 04             	mov    0x4(%rax),%eax
  803e76:	8d 50 01             	lea    0x1(%rax),%edx
  803e79:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e7d:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803e80:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803e85:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e89:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803e8d:	0f 82 64 ff ff ff    	jb     803df7 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803e93:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803e97:	c9                   	leaveq 
  803e98:	c3                   	retq   

0000000000803e99 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803e99:	55                   	push   %rbp
  803e9a:	48 89 e5             	mov    %rsp,%rbp
  803e9d:	48 83 ec 20          	sub    $0x20,%rsp
  803ea1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803ea5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803ea9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ead:	48 89 c7             	mov    %rax,%rdi
  803eb0:	48 b8 b3 1e 80 00 00 	movabs $0x801eb3,%rax
  803eb7:	00 00 00 
  803eba:	ff d0                	callq  *%rax
  803ebc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803ec0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ec4:	48 be 71 4c 80 00 00 	movabs $0x804c71,%rsi
  803ecb:	00 00 00 
  803ece:	48 89 c7             	mov    %rax,%rdi
  803ed1:	48 b8 45 0f 80 00 00 	movabs $0x800f45,%rax
  803ed8:	00 00 00 
  803edb:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803edd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ee1:	8b 50 04             	mov    0x4(%rax),%edx
  803ee4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ee8:	8b 00                	mov    (%rax),%eax
  803eea:	29 c2                	sub    %eax,%edx
  803eec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ef0:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803ef6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803efa:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803f01:	00 00 00 
	stat->st_dev = &devpipe;
  803f04:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f08:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803f0f:	00 00 00 
  803f12:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803f19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f1e:	c9                   	leaveq 
  803f1f:	c3                   	retq   

0000000000803f20 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803f20:	55                   	push   %rbp
  803f21:	48 89 e5             	mov    %rsp,%rbp
  803f24:	48 83 ec 10          	sub    $0x10,%rsp
  803f28:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803f2c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f30:	48 89 c6             	mov    %rax,%rsi
  803f33:	bf 00 00 00 00       	mov    $0x0,%edi
  803f38:	48 b8 1f 19 80 00 00 	movabs $0x80191f,%rax
  803f3f:	00 00 00 
  803f42:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803f44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f48:	48 89 c7             	mov    %rax,%rdi
  803f4b:	48 b8 b3 1e 80 00 00 	movabs $0x801eb3,%rax
  803f52:	00 00 00 
  803f55:	ff d0                	callq  *%rax
  803f57:	48 89 c6             	mov    %rax,%rsi
  803f5a:	bf 00 00 00 00       	mov    $0x0,%edi
  803f5f:	48 b8 1f 19 80 00 00 	movabs $0x80191f,%rax
  803f66:	00 00 00 
  803f69:	ff d0                	callq  *%rax
}
  803f6b:	c9                   	leaveq 
  803f6c:	c3                   	retq   

0000000000803f6d <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803f6d:	55                   	push   %rbp
  803f6e:	48 89 e5             	mov    %rsp,%rbp
  803f71:	48 83 ec 20          	sub    $0x20,%rsp
  803f75:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803f78:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f7b:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803f7e:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803f82:	be 01 00 00 00       	mov    $0x1,%esi
  803f87:	48 89 c7             	mov    %rax,%rdi
  803f8a:	48 b8 2c 17 80 00 00 	movabs $0x80172c,%rax
  803f91:	00 00 00 
  803f94:	ff d0                	callq  *%rax
}
  803f96:	c9                   	leaveq 
  803f97:	c3                   	retq   

0000000000803f98 <getchar>:

int
getchar(void)
{
  803f98:	55                   	push   %rbp
  803f99:	48 89 e5             	mov    %rsp,%rbp
  803f9c:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803fa0:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803fa4:	ba 01 00 00 00       	mov    $0x1,%edx
  803fa9:	48 89 c6             	mov    %rax,%rsi
  803fac:	bf 00 00 00 00       	mov    $0x0,%edi
  803fb1:	48 b8 a8 23 80 00 00 	movabs $0x8023a8,%rax
  803fb8:	00 00 00 
  803fbb:	ff d0                	callq  *%rax
  803fbd:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803fc0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fc4:	79 05                	jns    803fcb <getchar+0x33>
		return r;
  803fc6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fc9:	eb 14                	jmp    803fdf <getchar+0x47>
	if (r < 1)
  803fcb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fcf:	7f 07                	jg     803fd8 <getchar+0x40>
		return -E_EOF;
  803fd1:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803fd6:	eb 07                	jmp    803fdf <getchar+0x47>
	return c;
  803fd8:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803fdc:	0f b6 c0             	movzbl %al,%eax
}
  803fdf:	c9                   	leaveq 
  803fe0:	c3                   	retq   

0000000000803fe1 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803fe1:	55                   	push   %rbp
  803fe2:	48 89 e5             	mov    %rsp,%rbp
  803fe5:	48 83 ec 20          	sub    $0x20,%rsp
  803fe9:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803fec:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803ff0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ff3:	48 89 d6             	mov    %rdx,%rsi
  803ff6:	89 c7                	mov    %eax,%edi
  803ff8:	48 b8 76 1f 80 00 00 	movabs $0x801f76,%rax
  803fff:	00 00 00 
  804002:	ff d0                	callq  *%rax
  804004:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804007:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80400b:	79 05                	jns    804012 <iscons+0x31>
		return r;
  80400d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804010:	eb 1a                	jmp    80402c <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804012:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804016:	8b 10                	mov    (%rax),%edx
  804018:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  80401f:	00 00 00 
  804022:	8b 00                	mov    (%rax),%eax
  804024:	39 c2                	cmp    %eax,%edx
  804026:	0f 94 c0             	sete   %al
  804029:	0f b6 c0             	movzbl %al,%eax
}
  80402c:	c9                   	leaveq 
  80402d:	c3                   	retq   

000000000080402e <opencons>:

int
opencons(void)
{
  80402e:	55                   	push   %rbp
  80402f:	48 89 e5             	mov    %rsp,%rbp
  804032:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804036:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80403a:	48 89 c7             	mov    %rax,%rdi
  80403d:	48 b8 de 1e 80 00 00 	movabs $0x801ede,%rax
  804044:	00 00 00 
  804047:	ff d0                	callq  *%rax
  804049:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80404c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804050:	79 05                	jns    804057 <opencons+0x29>
		return r;
  804052:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804055:	eb 5b                	jmp    8040b2 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804057:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80405b:	ba 07 04 00 00       	mov    $0x407,%edx
  804060:	48 89 c6             	mov    %rax,%rsi
  804063:	bf 00 00 00 00       	mov    $0x0,%edi
  804068:	48 b8 74 18 80 00 00 	movabs $0x801874,%rax
  80406f:	00 00 00 
  804072:	ff d0                	callq  *%rax
  804074:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804077:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80407b:	79 05                	jns    804082 <opencons+0x54>
		return r;
  80407d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804080:	eb 30                	jmp    8040b2 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804082:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804086:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  80408d:	00 00 00 
  804090:	8b 12                	mov    (%rdx),%edx
  804092:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804094:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804098:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80409f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040a3:	48 89 c7             	mov    %rax,%rdi
  8040a6:	48 b8 90 1e 80 00 00 	movabs $0x801e90,%rax
  8040ad:	00 00 00 
  8040b0:	ff d0                	callq  *%rax
}
  8040b2:	c9                   	leaveq 
  8040b3:	c3                   	retq   

00000000008040b4 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8040b4:	55                   	push   %rbp
  8040b5:	48 89 e5             	mov    %rsp,%rbp
  8040b8:	48 83 ec 30          	sub    $0x30,%rsp
  8040bc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8040c0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8040c4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8040c8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8040cd:	75 07                	jne    8040d6 <devcons_read+0x22>
		return 0;
  8040cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8040d4:	eb 4b                	jmp    804121 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8040d6:	eb 0c                	jmp    8040e4 <devcons_read+0x30>
		sys_yield();
  8040d8:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  8040df:	00 00 00 
  8040e2:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8040e4:	48 b8 76 17 80 00 00 	movabs $0x801776,%rax
  8040eb:	00 00 00 
  8040ee:	ff d0                	callq  *%rax
  8040f0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040f7:	74 df                	je     8040d8 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8040f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040fd:	79 05                	jns    804104 <devcons_read+0x50>
		return c;
  8040ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804102:	eb 1d                	jmp    804121 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  804104:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804108:	75 07                	jne    804111 <devcons_read+0x5d>
		return 0;
  80410a:	b8 00 00 00 00       	mov    $0x0,%eax
  80410f:	eb 10                	jmp    804121 <devcons_read+0x6d>
	*(char*)vbuf = c;
  804111:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804114:	89 c2                	mov    %eax,%edx
  804116:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80411a:	88 10                	mov    %dl,(%rax)
	return 1;
  80411c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804121:	c9                   	leaveq 
  804122:	c3                   	retq   

0000000000804123 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804123:	55                   	push   %rbp
  804124:	48 89 e5             	mov    %rsp,%rbp
  804127:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80412e:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804135:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80413c:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804143:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80414a:	eb 76                	jmp    8041c2 <devcons_write+0x9f>
		m = n - tot;
  80414c:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804153:	89 c2                	mov    %eax,%edx
  804155:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804158:	29 c2                	sub    %eax,%edx
  80415a:	89 d0                	mov    %edx,%eax
  80415c:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80415f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804162:	83 f8 7f             	cmp    $0x7f,%eax
  804165:	76 07                	jbe    80416e <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804167:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80416e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804171:	48 63 d0             	movslq %eax,%rdx
  804174:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804177:	48 63 c8             	movslq %eax,%rcx
  80417a:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804181:	48 01 c1             	add    %rax,%rcx
  804184:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80418b:	48 89 ce             	mov    %rcx,%rsi
  80418e:	48 89 c7             	mov    %rax,%rdi
  804191:	48 b8 69 12 80 00 00 	movabs $0x801269,%rax
  804198:	00 00 00 
  80419b:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80419d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8041a0:	48 63 d0             	movslq %eax,%rdx
  8041a3:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8041aa:	48 89 d6             	mov    %rdx,%rsi
  8041ad:	48 89 c7             	mov    %rax,%rdi
  8041b0:	48 b8 2c 17 80 00 00 	movabs $0x80172c,%rax
  8041b7:	00 00 00 
  8041ba:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8041bc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8041bf:	01 45 fc             	add    %eax,-0x4(%rbp)
  8041c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041c5:	48 98                	cltq   
  8041c7:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8041ce:	0f 82 78 ff ff ff    	jb     80414c <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8041d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8041d7:	c9                   	leaveq 
  8041d8:	c3                   	retq   

00000000008041d9 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8041d9:	55                   	push   %rbp
  8041da:	48 89 e5             	mov    %rsp,%rbp
  8041dd:	48 83 ec 08          	sub    $0x8,%rsp
  8041e1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8041e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8041ea:	c9                   	leaveq 
  8041eb:	c3                   	retq   

00000000008041ec <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8041ec:	55                   	push   %rbp
  8041ed:	48 89 e5             	mov    %rsp,%rbp
  8041f0:	48 83 ec 10          	sub    $0x10,%rsp
  8041f4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8041f8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8041fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804200:	48 be 7d 4c 80 00 00 	movabs $0x804c7d,%rsi
  804207:	00 00 00 
  80420a:	48 89 c7             	mov    %rax,%rdi
  80420d:	48 b8 45 0f 80 00 00 	movabs $0x800f45,%rax
  804214:	00 00 00 
  804217:	ff d0                	callq  *%rax
	return 0;
  804219:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80421e:	c9                   	leaveq 
  80421f:	c3                   	retq   

0000000000804220 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  804220:	55                   	push   %rbp
  804221:	48 89 e5             	mov    %rsp,%rbp
  804224:	53                   	push   %rbx
  804225:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80422c:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  804233:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  804239:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  804240:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  804247:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80424e:	84 c0                	test   %al,%al
  804250:	74 23                	je     804275 <_panic+0x55>
  804252:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  804259:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80425d:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  804261:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  804265:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  804269:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80426d:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  804271:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  804275:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80427c:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  804283:	00 00 00 
  804286:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80428d:	00 00 00 
  804290:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804294:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80429b:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8042a2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8042a9:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8042b0:	00 00 00 
  8042b3:	48 8b 18             	mov    (%rax),%rbx
  8042b6:	48 b8 f8 17 80 00 00 	movabs $0x8017f8,%rax
  8042bd:	00 00 00 
  8042c0:	ff d0                	callq  *%rax
  8042c2:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8042c8:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8042cf:	41 89 c8             	mov    %ecx,%r8d
  8042d2:	48 89 d1             	mov    %rdx,%rcx
  8042d5:	48 89 da             	mov    %rbx,%rdx
  8042d8:	89 c6                	mov    %eax,%esi
  8042da:	48 bf 88 4c 80 00 00 	movabs $0x804c88,%rdi
  8042e1:	00 00 00 
  8042e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8042e9:	49 b9 90 03 80 00 00 	movabs $0x800390,%r9
  8042f0:	00 00 00 
  8042f3:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8042f6:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8042fd:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  804304:	48 89 d6             	mov    %rdx,%rsi
  804307:	48 89 c7             	mov    %rax,%rdi
  80430a:	48 b8 e4 02 80 00 00 	movabs $0x8002e4,%rax
  804311:	00 00 00 
  804314:	ff d0                	callq  *%rax
	cprintf("\n");
  804316:	48 bf ab 4c 80 00 00 	movabs $0x804cab,%rdi
  80431d:	00 00 00 
  804320:	b8 00 00 00 00       	mov    $0x0,%eax
  804325:	48 ba 90 03 80 00 00 	movabs $0x800390,%rdx
  80432c:	00 00 00 
  80432f:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  804331:	cc                   	int3   
  804332:	eb fd                	jmp    804331 <_panic+0x111>

0000000000804334 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804334:	55                   	push   %rbp
  804335:	48 89 e5             	mov    %rsp,%rbp
  804338:	48 83 ec 30          	sub    $0x30,%rsp
  80433c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804340:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804344:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  804348:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80434f:	00 00 00 
  804352:	48 8b 00             	mov    (%rax),%rax
  804355:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  80435b:	85 c0                	test   %eax,%eax
  80435d:	75 3c                	jne    80439b <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  80435f:	48 b8 f8 17 80 00 00 	movabs $0x8017f8,%rax
  804366:	00 00 00 
  804369:	ff d0                	callq  *%rax
  80436b:	25 ff 03 00 00       	and    $0x3ff,%eax
  804370:	48 63 d0             	movslq %eax,%rdx
  804373:	48 89 d0             	mov    %rdx,%rax
  804376:	48 c1 e0 03          	shl    $0x3,%rax
  80437a:	48 01 d0             	add    %rdx,%rax
  80437d:	48 c1 e0 05          	shl    $0x5,%rax
  804381:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804388:	00 00 00 
  80438b:	48 01 c2             	add    %rax,%rdx
  80438e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804395:	00 00 00 
  804398:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  80439b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8043a0:	75 0e                	jne    8043b0 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  8043a2:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8043a9:	00 00 00 
  8043ac:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  8043b0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043b4:	48 89 c7             	mov    %rax,%rdi
  8043b7:	48 b8 9d 1a 80 00 00 	movabs $0x801a9d,%rax
  8043be:	00 00 00 
  8043c1:	ff d0                	callq  *%rax
  8043c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  8043c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043ca:	79 19                	jns    8043e5 <ipc_recv+0xb1>
		*from_env_store = 0;
  8043cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8043d0:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  8043d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043da:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  8043e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043e3:	eb 53                	jmp    804438 <ipc_recv+0x104>
	}
	if(from_env_store)
  8043e5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8043ea:	74 19                	je     804405 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  8043ec:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8043f3:	00 00 00 
  8043f6:	48 8b 00             	mov    (%rax),%rax
  8043f9:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8043ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804403:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  804405:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80440a:	74 19                	je     804425 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  80440c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804413:	00 00 00 
  804416:	48 8b 00             	mov    (%rax),%rax
  804419:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80441f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804423:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  804425:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80442c:	00 00 00 
  80442f:	48 8b 00             	mov    (%rax),%rax
  804432:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  804438:	c9                   	leaveq 
  804439:	c3                   	retq   

000000000080443a <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80443a:	55                   	push   %rbp
  80443b:	48 89 e5             	mov    %rsp,%rbp
  80443e:	48 83 ec 30          	sub    $0x30,%rsp
  804442:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804445:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804448:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80444c:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  80444f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804454:	75 0e                	jne    804464 <ipc_send+0x2a>
		pg = (void*)UTOP;
  804456:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80445d:	00 00 00 
  804460:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  804464:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804467:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80446a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80446e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804471:	89 c7                	mov    %eax,%edi
  804473:	48 b8 48 1a 80 00 00 	movabs $0x801a48,%rax
  80447a:	00 00 00 
  80447d:	ff d0                	callq  *%rax
  80447f:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  804482:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804486:	75 0c                	jne    804494 <ipc_send+0x5a>
			sys_yield();
  804488:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  80448f:	00 00 00 
  804492:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  804494:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804498:	74 ca                	je     804464 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  80449a:	c9                   	leaveq 
  80449b:	c3                   	retq   

000000000080449c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80449c:	55                   	push   %rbp
  80449d:	48 89 e5             	mov    %rsp,%rbp
  8044a0:	48 83 ec 14          	sub    $0x14,%rsp
  8044a4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8044a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8044ae:	eb 5e                	jmp    80450e <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8044b0:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8044b7:	00 00 00 
  8044ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044bd:	48 63 d0             	movslq %eax,%rdx
  8044c0:	48 89 d0             	mov    %rdx,%rax
  8044c3:	48 c1 e0 03          	shl    $0x3,%rax
  8044c7:	48 01 d0             	add    %rdx,%rax
  8044ca:	48 c1 e0 05          	shl    $0x5,%rax
  8044ce:	48 01 c8             	add    %rcx,%rax
  8044d1:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8044d7:	8b 00                	mov    (%rax),%eax
  8044d9:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8044dc:	75 2c                	jne    80450a <ipc_find_env+0x6e>
			return envs[i].env_id;
  8044de:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8044e5:	00 00 00 
  8044e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044eb:	48 63 d0             	movslq %eax,%rdx
  8044ee:	48 89 d0             	mov    %rdx,%rax
  8044f1:	48 c1 e0 03          	shl    $0x3,%rax
  8044f5:	48 01 d0             	add    %rdx,%rax
  8044f8:	48 c1 e0 05          	shl    $0x5,%rax
  8044fc:	48 01 c8             	add    %rcx,%rax
  8044ff:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804505:	8b 40 08             	mov    0x8(%rax),%eax
  804508:	eb 12                	jmp    80451c <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80450a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80450e:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804515:	7e 99                	jle    8044b0 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804517:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80451c:	c9                   	leaveq 
  80451d:	c3                   	retq   

000000000080451e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80451e:	55                   	push   %rbp
  80451f:	48 89 e5             	mov    %rsp,%rbp
  804522:	48 83 ec 18          	sub    $0x18,%rsp
  804526:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80452a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80452e:	48 c1 e8 15          	shr    $0x15,%rax
  804532:	48 89 c2             	mov    %rax,%rdx
  804535:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80453c:	01 00 00 
  80453f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804543:	83 e0 01             	and    $0x1,%eax
  804546:	48 85 c0             	test   %rax,%rax
  804549:	75 07                	jne    804552 <pageref+0x34>
		return 0;
  80454b:	b8 00 00 00 00       	mov    $0x0,%eax
  804550:	eb 53                	jmp    8045a5 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804552:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804556:	48 c1 e8 0c          	shr    $0xc,%rax
  80455a:	48 89 c2             	mov    %rax,%rdx
  80455d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804564:	01 00 00 
  804567:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80456b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80456f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804573:	83 e0 01             	and    $0x1,%eax
  804576:	48 85 c0             	test   %rax,%rax
  804579:	75 07                	jne    804582 <pageref+0x64>
		return 0;
  80457b:	b8 00 00 00 00       	mov    $0x0,%eax
  804580:	eb 23                	jmp    8045a5 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804582:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804586:	48 c1 e8 0c          	shr    $0xc,%rax
  80458a:	48 89 c2             	mov    %rax,%rdx
  80458d:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804594:	00 00 00 
  804597:	48 c1 e2 04          	shl    $0x4,%rdx
  80459b:	48 01 d0             	add    %rdx,%rax
  80459e:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8045a2:	0f b7 c0             	movzwl %ax,%eax
}
  8045a5:	c9                   	leaveq 
  8045a6:	c3                   	retq   
