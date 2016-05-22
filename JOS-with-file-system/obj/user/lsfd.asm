
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
  800047:	48 bf 00 3b 80 00 00 	movabs $0x803b00,%rdi
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
  8000aa:	48 b8 e1 1a 80 00 00 	movabs $0x801ae1,%rax
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
  8000dd:	48 b8 45 1b 80 00 00 	movabs $0x801b45,%rax
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
  80010d:	48 b8 0d 26 80 00 00 	movabs $0x80260d,%rax
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
  80014e:	48 be 18 3b 80 00 00 	movabs $0x803b18,%rsi
  800155:	00 00 00 
  800158:	bf 01 00 00 00       	mov    $0x1,%edi
  80015d:	b8 00 00 00 00       	mov    $0x0,%eax
  800162:	49 ba 85 2d 80 00 00 	movabs $0x802d85,%r10
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
  800191:	48 bf 18 3b 80 00 00 	movabs $0x803b18,%rdi
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
  8001fb:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
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
  800215:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
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
  80024c:	48 b8 07 21 80 00 00 	movabs $0x802107,%rax
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
  8004fc:	48 ba 28 3d 80 00 00 	movabs $0x803d28,%rdx
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
  8007f4:	48 b8 50 3d 80 00 00 	movabs $0x803d50,%rax
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
  800942:	83 fb 10             	cmp    $0x10,%ebx
  800945:	7f 16                	jg     80095d <vprintfmt+0x21a>
  800947:	48 b8 a0 3c 80 00 00 	movabs $0x803ca0,%rax
  80094e:	00 00 00 
  800951:	48 63 d3             	movslq %ebx,%rdx
  800954:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800958:	4d 85 e4             	test   %r12,%r12
  80095b:	75 2e                	jne    80098b <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  80095d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800961:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800965:	89 d9                	mov    %ebx,%ecx
  800967:	48 ba 39 3d 80 00 00 	movabs $0x803d39,%rdx
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
  800996:	48 ba 42 3d 80 00 00 	movabs $0x803d42,%rdx
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
  8009f0:	49 bc 45 3d 80 00 00 	movabs $0x803d45,%r12
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
  8016f6:	48 ba 00 40 80 00 00 	movabs $0x804000,%rdx
  8016fd:	00 00 00 
  801700:	be 23 00 00 00       	mov    $0x23,%esi
  801705:	48 bf 1d 40 80 00 00 	movabs $0x80401d,%rdi
  80170c:	00 00 00 
  80170f:	b8 00 00 00 00       	mov    $0x0,%eax
  801714:	49 b9 6f 37 80 00 00 	movabs $0x80376f,%r9
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

0000000000801ae1 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801ae1:	55                   	push   %rbp
  801ae2:	48 89 e5             	mov    %rsp,%rbp
  801ae5:	48 83 ec 18          	sub    $0x18,%rsp
  801ae9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801aed:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801af1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	args->argc = argc;
  801af5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801af9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801afd:	48 89 10             	mov    %rdx,(%rax)
	args->argv = (const char **) argv;
  801b00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b04:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b08:	48 89 50 08          	mov    %rdx,0x8(%rax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801b0c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b10:	8b 00                	mov    (%rax),%eax
  801b12:	83 f8 01             	cmp    $0x1,%eax
  801b15:	7e 13                	jle    801b2a <argstart+0x49>
  801b17:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  801b1c:	74 0c                	je     801b2a <argstart+0x49>
  801b1e:	48 b8 2b 40 80 00 00 	movabs $0x80402b,%rax
  801b25:	00 00 00 
  801b28:	eb 05                	jmp    801b2f <argstart+0x4e>
  801b2a:	b8 00 00 00 00       	mov    $0x0,%eax
  801b2f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801b33:	48 89 42 10          	mov    %rax,0x10(%rdx)
	args->argvalue = 0;
  801b37:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b3b:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  801b42:	00 
}
  801b43:	c9                   	leaveq 
  801b44:	c3                   	retq   

0000000000801b45 <argnext>:

int
argnext(struct Argstate *args)
{
  801b45:	55                   	push   %rbp
  801b46:	48 89 e5             	mov    %rsp,%rbp
  801b49:	48 83 ec 20          	sub    $0x20,%rsp
  801b4d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int arg;

	args->argvalue = 0;
  801b51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b55:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  801b5c:	00 

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801b5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b61:	48 8b 40 10          	mov    0x10(%rax),%rax
  801b65:	48 85 c0             	test   %rax,%rax
  801b68:	75 0a                	jne    801b74 <argnext+0x2f>
		return -1;
  801b6a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801b6f:	e9 25 01 00 00       	jmpq   801c99 <argnext+0x154>

	if (!*args->curarg) {
  801b74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b78:	48 8b 40 10          	mov    0x10(%rax),%rax
  801b7c:	0f b6 00             	movzbl (%rax),%eax
  801b7f:	84 c0                	test   %al,%al
  801b81:	0f 85 d7 00 00 00    	jne    801c5e <argnext+0x119>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801b87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b8b:	48 8b 00             	mov    (%rax),%rax
  801b8e:	8b 00                	mov    (%rax),%eax
  801b90:	83 f8 01             	cmp    $0x1,%eax
  801b93:	0f 84 ef 00 00 00    	je     801c88 <argnext+0x143>
		    || args->argv[1][0] != '-'
  801b99:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b9d:	48 8b 40 08          	mov    0x8(%rax),%rax
  801ba1:	48 83 c0 08          	add    $0x8,%rax
  801ba5:	48 8b 00             	mov    (%rax),%rax
  801ba8:	0f b6 00             	movzbl (%rax),%eax
  801bab:	3c 2d                	cmp    $0x2d,%al
  801bad:	0f 85 d5 00 00 00    	jne    801c88 <argnext+0x143>
		    || args->argv[1][1] == '\0')
  801bb3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bb7:	48 8b 40 08          	mov    0x8(%rax),%rax
  801bbb:	48 83 c0 08          	add    $0x8,%rax
  801bbf:	48 8b 00             	mov    (%rax),%rax
  801bc2:	48 83 c0 01          	add    $0x1,%rax
  801bc6:	0f b6 00             	movzbl (%rax),%eax
  801bc9:	84 c0                	test   %al,%al
  801bcb:	0f 84 b7 00 00 00    	je     801c88 <argnext+0x143>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801bd1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bd5:	48 8b 40 08          	mov    0x8(%rax),%rax
  801bd9:	48 83 c0 08          	add    $0x8,%rax
  801bdd:	48 8b 00             	mov    (%rax),%rax
  801be0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801be4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801be8:	48 89 50 10          	mov    %rdx,0x10(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801bec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bf0:	48 8b 00             	mov    (%rax),%rax
  801bf3:	8b 00                	mov    (%rax),%eax
  801bf5:	83 e8 01             	sub    $0x1,%eax
  801bf8:	48 98                	cltq   
  801bfa:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801c01:	00 
  801c02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c06:	48 8b 40 08          	mov    0x8(%rax),%rax
  801c0a:	48 8d 48 10          	lea    0x10(%rax),%rcx
  801c0e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c12:	48 8b 40 08          	mov    0x8(%rax),%rax
  801c16:	48 83 c0 08          	add    $0x8,%rax
  801c1a:	48 89 ce             	mov    %rcx,%rsi
  801c1d:	48 89 c7             	mov    %rax,%rdi
  801c20:	48 b8 69 12 80 00 00 	movabs $0x801269,%rax
  801c27:	00 00 00 
  801c2a:	ff d0                	callq  *%rax
		(*args->argc)--;
  801c2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c30:	48 8b 00             	mov    (%rax),%rax
  801c33:	8b 10                	mov    (%rax),%edx
  801c35:	83 ea 01             	sub    $0x1,%edx
  801c38:	89 10                	mov    %edx,(%rax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801c3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c3e:	48 8b 40 10          	mov    0x10(%rax),%rax
  801c42:	0f b6 00             	movzbl (%rax),%eax
  801c45:	3c 2d                	cmp    $0x2d,%al
  801c47:	75 15                	jne    801c5e <argnext+0x119>
  801c49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c4d:	48 8b 40 10          	mov    0x10(%rax),%rax
  801c51:	48 83 c0 01          	add    $0x1,%rax
  801c55:	0f b6 00             	movzbl (%rax),%eax
  801c58:	84 c0                	test   %al,%al
  801c5a:	75 02                	jne    801c5e <argnext+0x119>
			goto endofargs;
  801c5c:	eb 2a                	jmp    801c88 <argnext+0x143>
	}

	arg = (unsigned char) *args->curarg;
  801c5e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c62:	48 8b 40 10          	mov    0x10(%rax),%rax
  801c66:	0f b6 00             	movzbl (%rax),%eax
  801c69:	0f b6 c0             	movzbl %al,%eax
  801c6c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	args->curarg++;
  801c6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c73:	48 8b 40 10          	mov    0x10(%rax),%rax
  801c77:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801c7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c7f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	return arg;
  801c83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c86:	eb 11                	jmp    801c99 <argnext+0x154>

    endofargs:
	args->curarg = 0;
  801c88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c8c:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  801c93:	00 
	return -1;
  801c94:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  801c99:	c9                   	leaveq 
  801c9a:	c3                   	retq   

0000000000801c9b <argvalue>:

char *
argvalue(struct Argstate *args)
{
  801c9b:	55                   	push   %rbp
  801c9c:	48 89 e5             	mov    %rsp,%rbp
  801c9f:	48 83 ec 10          	sub    $0x10,%rsp
  801ca3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801ca7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cab:	48 8b 40 18          	mov    0x18(%rax),%rax
  801caf:	48 85 c0             	test   %rax,%rax
  801cb2:	74 0a                	je     801cbe <argvalue+0x23>
  801cb4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cb8:	48 8b 40 18          	mov    0x18(%rax),%rax
  801cbc:	eb 13                	jmp    801cd1 <argvalue+0x36>
  801cbe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cc2:	48 89 c7             	mov    %rax,%rdi
  801cc5:	48 b8 d3 1c 80 00 00 	movabs $0x801cd3,%rax
  801ccc:	00 00 00 
  801ccf:	ff d0                	callq  *%rax
}
  801cd1:	c9                   	leaveq 
  801cd2:	c3                   	retq   

0000000000801cd3 <argnextvalue>:

char *
argnextvalue(struct Argstate *args)
{
  801cd3:	55                   	push   %rbp
  801cd4:	48 89 e5             	mov    %rsp,%rbp
  801cd7:	53                   	push   %rbx
  801cd8:	48 83 ec 18          	sub    $0x18,%rsp
  801cdc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (!args->curarg)
  801ce0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ce4:	48 8b 40 10          	mov    0x10(%rax),%rax
  801ce8:	48 85 c0             	test   %rax,%rax
  801ceb:	75 0a                	jne    801cf7 <argnextvalue+0x24>
		return 0;
  801ced:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf2:	e9 c8 00 00 00       	jmpq   801dbf <argnextvalue+0xec>
	if (*args->curarg) {
  801cf7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cfb:	48 8b 40 10          	mov    0x10(%rax),%rax
  801cff:	0f b6 00             	movzbl (%rax),%eax
  801d02:	84 c0                	test   %al,%al
  801d04:	74 27                	je     801d2d <argnextvalue+0x5a>
		args->argvalue = args->curarg;
  801d06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d0a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801d0e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d12:	48 89 50 18          	mov    %rdx,0x18(%rax)
		args->curarg = "";
  801d16:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d1a:	48 bb 2b 40 80 00 00 	movabs $0x80402b,%rbx
  801d21:	00 00 00 
  801d24:	48 89 58 10          	mov    %rbx,0x10(%rax)
  801d28:	e9 8a 00 00 00       	jmpq   801db7 <argnextvalue+0xe4>
	} else if (*args->argc > 1) {
  801d2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d31:	48 8b 00             	mov    (%rax),%rax
  801d34:	8b 00                	mov    (%rax),%eax
  801d36:	83 f8 01             	cmp    $0x1,%eax
  801d39:	7e 64                	jle    801d9f <argnextvalue+0xcc>
		args->argvalue = args->argv[1];
  801d3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d3f:	48 8b 40 08          	mov    0x8(%rax),%rax
  801d43:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801d47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d4b:	48 89 50 18          	mov    %rdx,0x18(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801d4f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d53:	48 8b 00             	mov    (%rax),%rax
  801d56:	8b 00                	mov    (%rax),%eax
  801d58:	83 e8 01             	sub    $0x1,%eax
  801d5b:	48 98                	cltq   
  801d5d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801d64:	00 
  801d65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d69:	48 8b 40 08          	mov    0x8(%rax),%rax
  801d6d:	48 8d 48 10          	lea    0x10(%rax),%rcx
  801d71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d75:	48 8b 40 08          	mov    0x8(%rax),%rax
  801d79:	48 83 c0 08          	add    $0x8,%rax
  801d7d:	48 89 ce             	mov    %rcx,%rsi
  801d80:	48 89 c7             	mov    %rax,%rdi
  801d83:	48 b8 69 12 80 00 00 	movabs $0x801269,%rax
  801d8a:	00 00 00 
  801d8d:	ff d0                	callq  *%rax
		(*args->argc)--;
  801d8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d93:	48 8b 00             	mov    (%rax),%rax
  801d96:	8b 10                	mov    (%rax),%edx
  801d98:	83 ea 01             	sub    $0x1,%edx
  801d9b:	89 10                	mov    %edx,(%rax)
  801d9d:	eb 18                	jmp    801db7 <argnextvalue+0xe4>
	} else {
		args->argvalue = 0;
  801d9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801da3:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  801daa:	00 
		args->curarg = 0;
  801dab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801daf:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  801db6:	00 
	}
	return (char*) args->argvalue;
  801db7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dbb:	48 8b 40 18          	mov    0x18(%rax),%rax
}
  801dbf:	48 83 c4 18          	add    $0x18,%rsp
  801dc3:	5b                   	pop    %rbx
  801dc4:	5d                   	pop    %rbp
  801dc5:	c3                   	retq   

0000000000801dc6 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801dc6:	55                   	push   %rbp
  801dc7:	48 89 e5             	mov    %rsp,%rbp
  801dca:	48 83 ec 08          	sub    $0x8,%rsp
  801dce:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801dd2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801dd6:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801ddd:	ff ff ff 
  801de0:	48 01 d0             	add    %rdx,%rax
  801de3:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801de7:	c9                   	leaveq 
  801de8:	c3                   	retq   

0000000000801de9 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801de9:	55                   	push   %rbp
  801dea:	48 89 e5             	mov    %rsp,%rbp
  801ded:	48 83 ec 08          	sub    $0x8,%rsp
  801df1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801df5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801df9:	48 89 c7             	mov    %rax,%rdi
  801dfc:	48 b8 c6 1d 80 00 00 	movabs $0x801dc6,%rax
  801e03:	00 00 00 
  801e06:	ff d0                	callq  *%rax
  801e08:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801e0e:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801e12:	c9                   	leaveq 
  801e13:	c3                   	retq   

0000000000801e14 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801e14:	55                   	push   %rbp
  801e15:	48 89 e5             	mov    %rsp,%rbp
  801e18:	48 83 ec 18          	sub    $0x18,%rsp
  801e1c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e20:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e27:	eb 6b                	jmp    801e94 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801e29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e2c:	48 98                	cltq   
  801e2e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e34:	48 c1 e0 0c          	shl    $0xc,%rax
  801e38:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801e3c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e40:	48 c1 e8 15          	shr    $0x15,%rax
  801e44:	48 89 c2             	mov    %rax,%rdx
  801e47:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e4e:	01 00 00 
  801e51:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e55:	83 e0 01             	and    $0x1,%eax
  801e58:	48 85 c0             	test   %rax,%rax
  801e5b:	74 21                	je     801e7e <fd_alloc+0x6a>
  801e5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e61:	48 c1 e8 0c          	shr    $0xc,%rax
  801e65:	48 89 c2             	mov    %rax,%rdx
  801e68:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e6f:	01 00 00 
  801e72:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e76:	83 e0 01             	and    $0x1,%eax
  801e79:	48 85 c0             	test   %rax,%rax
  801e7c:	75 12                	jne    801e90 <fd_alloc+0x7c>
			*fd_store = fd;
  801e7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e82:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e86:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801e89:	b8 00 00 00 00       	mov    $0x0,%eax
  801e8e:	eb 1a                	jmp    801eaa <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e90:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e94:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801e98:	7e 8f                	jle    801e29 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801e9a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e9e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801ea5:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801eaa:	c9                   	leaveq 
  801eab:	c3                   	retq   

0000000000801eac <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801eac:	55                   	push   %rbp
  801ead:	48 89 e5             	mov    %rsp,%rbp
  801eb0:	48 83 ec 20          	sub    $0x20,%rsp
  801eb4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801eb7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801ebb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801ebf:	78 06                	js     801ec7 <fd_lookup+0x1b>
  801ec1:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801ec5:	7e 07                	jle    801ece <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801ec7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ecc:	eb 6c                	jmp    801f3a <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801ece:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ed1:	48 98                	cltq   
  801ed3:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ed9:	48 c1 e0 0c          	shl    $0xc,%rax
  801edd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801ee1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ee5:	48 c1 e8 15          	shr    $0x15,%rax
  801ee9:	48 89 c2             	mov    %rax,%rdx
  801eec:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801ef3:	01 00 00 
  801ef6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801efa:	83 e0 01             	and    $0x1,%eax
  801efd:	48 85 c0             	test   %rax,%rax
  801f00:	74 21                	je     801f23 <fd_lookup+0x77>
  801f02:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f06:	48 c1 e8 0c          	shr    $0xc,%rax
  801f0a:	48 89 c2             	mov    %rax,%rdx
  801f0d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f14:	01 00 00 
  801f17:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f1b:	83 e0 01             	and    $0x1,%eax
  801f1e:	48 85 c0             	test   %rax,%rax
  801f21:	75 07                	jne    801f2a <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f23:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f28:	eb 10                	jmp    801f3a <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801f2a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f2e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f32:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801f35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f3a:	c9                   	leaveq 
  801f3b:	c3                   	retq   

0000000000801f3c <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801f3c:	55                   	push   %rbp
  801f3d:	48 89 e5             	mov    %rsp,%rbp
  801f40:	48 83 ec 30          	sub    $0x30,%rsp
  801f44:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801f48:	89 f0                	mov    %esi,%eax
  801f4a:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801f4d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f51:	48 89 c7             	mov    %rax,%rdi
  801f54:	48 b8 c6 1d 80 00 00 	movabs $0x801dc6,%rax
  801f5b:	00 00 00 
  801f5e:	ff d0                	callq  *%rax
  801f60:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f64:	48 89 d6             	mov    %rdx,%rsi
  801f67:	89 c7                	mov    %eax,%edi
  801f69:	48 b8 ac 1e 80 00 00 	movabs $0x801eac,%rax
  801f70:	00 00 00 
  801f73:	ff d0                	callq  *%rax
  801f75:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f78:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f7c:	78 0a                	js     801f88 <fd_close+0x4c>
	    || fd != fd2)
  801f7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f82:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801f86:	74 12                	je     801f9a <fd_close+0x5e>
		return (must_exist ? r : 0);
  801f88:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801f8c:	74 05                	je     801f93 <fd_close+0x57>
  801f8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f91:	eb 05                	jmp    801f98 <fd_close+0x5c>
  801f93:	b8 00 00 00 00       	mov    $0x0,%eax
  801f98:	eb 69                	jmp    802003 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801f9a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f9e:	8b 00                	mov    (%rax),%eax
  801fa0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801fa4:	48 89 d6             	mov    %rdx,%rsi
  801fa7:	89 c7                	mov    %eax,%edi
  801fa9:	48 b8 05 20 80 00 00 	movabs $0x802005,%rax
  801fb0:	00 00 00 
  801fb3:	ff d0                	callq  *%rax
  801fb5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fb8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fbc:	78 2a                	js     801fe8 <fd_close+0xac>
		if (dev->dev_close)
  801fbe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fc2:	48 8b 40 20          	mov    0x20(%rax),%rax
  801fc6:	48 85 c0             	test   %rax,%rax
  801fc9:	74 16                	je     801fe1 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801fcb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fcf:	48 8b 40 20          	mov    0x20(%rax),%rax
  801fd3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801fd7:	48 89 d7             	mov    %rdx,%rdi
  801fda:	ff d0                	callq  *%rax
  801fdc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fdf:	eb 07                	jmp    801fe8 <fd_close+0xac>
		else
			r = 0;
  801fe1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801fe8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fec:	48 89 c6             	mov    %rax,%rsi
  801fef:	bf 00 00 00 00       	mov    $0x0,%edi
  801ff4:	48 b8 1f 19 80 00 00 	movabs $0x80191f,%rax
  801ffb:	00 00 00 
  801ffe:	ff d0                	callq  *%rax
	return r;
  802000:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802003:	c9                   	leaveq 
  802004:	c3                   	retq   

0000000000802005 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802005:	55                   	push   %rbp
  802006:	48 89 e5             	mov    %rsp,%rbp
  802009:	48 83 ec 20          	sub    $0x20,%rsp
  80200d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802010:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802014:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80201b:	eb 41                	jmp    80205e <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80201d:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  802024:	00 00 00 
  802027:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80202a:	48 63 d2             	movslq %edx,%rdx
  80202d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802031:	8b 00                	mov    (%rax),%eax
  802033:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802036:	75 22                	jne    80205a <dev_lookup+0x55>
			*dev = devtab[i];
  802038:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  80203f:	00 00 00 
  802042:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802045:	48 63 d2             	movslq %edx,%rdx
  802048:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80204c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802050:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802053:	b8 00 00 00 00       	mov    $0x0,%eax
  802058:	eb 60                	jmp    8020ba <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80205a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80205e:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  802065:	00 00 00 
  802068:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80206b:	48 63 d2             	movslq %edx,%rdx
  80206e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802072:	48 85 c0             	test   %rax,%rax
  802075:	75 a6                	jne    80201d <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802077:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80207e:	00 00 00 
  802081:	48 8b 00             	mov    (%rax),%rax
  802084:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80208a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80208d:	89 c6                	mov    %eax,%esi
  80208f:	48 bf 30 40 80 00 00 	movabs $0x804030,%rdi
  802096:	00 00 00 
  802099:	b8 00 00 00 00       	mov    $0x0,%eax
  80209e:	48 b9 90 03 80 00 00 	movabs $0x800390,%rcx
  8020a5:	00 00 00 
  8020a8:	ff d1                	callq  *%rcx
	*dev = 0;
  8020aa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020ae:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8020b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8020ba:	c9                   	leaveq 
  8020bb:	c3                   	retq   

00000000008020bc <close>:

int
close(int fdnum)
{
  8020bc:	55                   	push   %rbp
  8020bd:	48 89 e5             	mov    %rsp,%rbp
  8020c0:	48 83 ec 20          	sub    $0x20,%rsp
  8020c4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020c7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8020cb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020ce:	48 89 d6             	mov    %rdx,%rsi
  8020d1:	89 c7                	mov    %eax,%edi
  8020d3:	48 b8 ac 1e 80 00 00 	movabs $0x801eac,%rax
  8020da:	00 00 00 
  8020dd:	ff d0                	callq  *%rax
  8020df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020e6:	79 05                	jns    8020ed <close+0x31>
		return r;
  8020e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020eb:	eb 18                	jmp    802105 <close+0x49>
	else
		return fd_close(fd, 1);
  8020ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020f1:	be 01 00 00 00       	mov    $0x1,%esi
  8020f6:	48 89 c7             	mov    %rax,%rdi
  8020f9:	48 b8 3c 1f 80 00 00 	movabs $0x801f3c,%rax
  802100:	00 00 00 
  802103:	ff d0                	callq  *%rax
}
  802105:	c9                   	leaveq 
  802106:	c3                   	retq   

0000000000802107 <close_all>:

void
close_all(void)
{
  802107:	55                   	push   %rbp
  802108:	48 89 e5             	mov    %rsp,%rbp
  80210b:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80210f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802116:	eb 15                	jmp    80212d <close_all+0x26>
		close(i);
  802118:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80211b:	89 c7                	mov    %eax,%edi
  80211d:	48 b8 bc 20 80 00 00 	movabs $0x8020bc,%rax
  802124:	00 00 00 
  802127:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802129:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80212d:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802131:	7e e5                	jle    802118 <close_all+0x11>
		close(i);
}
  802133:	c9                   	leaveq 
  802134:	c3                   	retq   

0000000000802135 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802135:	55                   	push   %rbp
  802136:	48 89 e5             	mov    %rsp,%rbp
  802139:	48 83 ec 40          	sub    $0x40,%rsp
  80213d:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802140:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802143:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802147:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80214a:	48 89 d6             	mov    %rdx,%rsi
  80214d:	89 c7                	mov    %eax,%edi
  80214f:	48 b8 ac 1e 80 00 00 	movabs $0x801eac,%rax
  802156:	00 00 00 
  802159:	ff d0                	callq  *%rax
  80215b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80215e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802162:	79 08                	jns    80216c <dup+0x37>
		return r;
  802164:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802167:	e9 70 01 00 00       	jmpq   8022dc <dup+0x1a7>
	close(newfdnum);
  80216c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80216f:	89 c7                	mov    %eax,%edi
  802171:	48 b8 bc 20 80 00 00 	movabs $0x8020bc,%rax
  802178:	00 00 00 
  80217b:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80217d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802180:	48 98                	cltq   
  802182:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802188:	48 c1 e0 0c          	shl    $0xc,%rax
  80218c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802190:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802194:	48 89 c7             	mov    %rax,%rdi
  802197:	48 b8 e9 1d 80 00 00 	movabs $0x801de9,%rax
  80219e:	00 00 00 
  8021a1:	ff d0                	callq  *%rax
  8021a3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8021a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021ab:	48 89 c7             	mov    %rax,%rdi
  8021ae:	48 b8 e9 1d 80 00 00 	movabs $0x801de9,%rax
  8021b5:	00 00 00 
  8021b8:	ff d0                	callq  *%rax
  8021ba:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8021be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021c2:	48 c1 e8 15          	shr    $0x15,%rax
  8021c6:	48 89 c2             	mov    %rax,%rdx
  8021c9:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021d0:	01 00 00 
  8021d3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021d7:	83 e0 01             	and    $0x1,%eax
  8021da:	48 85 c0             	test   %rax,%rax
  8021dd:	74 73                	je     802252 <dup+0x11d>
  8021df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021e3:	48 c1 e8 0c          	shr    $0xc,%rax
  8021e7:	48 89 c2             	mov    %rax,%rdx
  8021ea:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021f1:	01 00 00 
  8021f4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021f8:	83 e0 01             	and    $0x1,%eax
  8021fb:	48 85 c0             	test   %rax,%rax
  8021fe:	74 52                	je     802252 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802200:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802204:	48 c1 e8 0c          	shr    $0xc,%rax
  802208:	48 89 c2             	mov    %rax,%rdx
  80220b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802212:	01 00 00 
  802215:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802219:	25 07 0e 00 00       	and    $0xe07,%eax
  80221e:	89 c1                	mov    %eax,%ecx
  802220:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802224:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802228:	41 89 c8             	mov    %ecx,%r8d
  80222b:	48 89 d1             	mov    %rdx,%rcx
  80222e:	ba 00 00 00 00       	mov    $0x0,%edx
  802233:	48 89 c6             	mov    %rax,%rsi
  802236:	bf 00 00 00 00       	mov    $0x0,%edi
  80223b:	48 b8 c4 18 80 00 00 	movabs $0x8018c4,%rax
  802242:	00 00 00 
  802245:	ff d0                	callq  *%rax
  802247:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80224a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80224e:	79 02                	jns    802252 <dup+0x11d>
			goto err;
  802250:	eb 57                	jmp    8022a9 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802252:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802256:	48 c1 e8 0c          	shr    $0xc,%rax
  80225a:	48 89 c2             	mov    %rax,%rdx
  80225d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802264:	01 00 00 
  802267:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80226b:	25 07 0e 00 00       	and    $0xe07,%eax
  802270:	89 c1                	mov    %eax,%ecx
  802272:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802276:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80227a:	41 89 c8             	mov    %ecx,%r8d
  80227d:	48 89 d1             	mov    %rdx,%rcx
  802280:	ba 00 00 00 00       	mov    $0x0,%edx
  802285:	48 89 c6             	mov    %rax,%rsi
  802288:	bf 00 00 00 00       	mov    $0x0,%edi
  80228d:	48 b8 c4 18 80 00 00 	movabs $0x8018c4,%rax
  802294:	00 00 00 
  802297:	ff d0                	callq  *%rax
  802299:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80229c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022a0:	79 02                	jns    8022a4 <dup+0x16f>
		goto err;
  8022a2:	eb 05                	jmp    8022a9 <dup+0x174>

	return newfdnum;
  8022a4:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8022a7:	eb 33                	jmp    8022dc <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8022a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022ad:	48 89 c6             	mov    %rax,%rsi
  8022b0:	bf 00 00 00 00       	mov    $0x0,%edi
  8022b5:	48 b8 1f 19 80 00 00 	movabs $0x80191f,%rax
  8022bc:	00 00 00 
  8022bf:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8022c1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022c5:	48 89 c6             	mov    %rax,%rsi
  8022c8:	bf 00 00 00 00       	mov    $0x0,%edi
  8022cd:	48 b8 1f 19 80 00 00 	movabs $0x80191f,%rax
  8022d4:	00 00 00 
  8022d7:	ff d0                	callq  *%rax
	return r;
  8022d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8022dc:	c9                   	leaveq 
  8022dd:	c3                   	retq   

00000000008022de <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8022de:	55                   	push   %rbp
  8022df:	48 89 e5             	mov    %rsp,%rbp
  8022e2:	48 83 ec 40          	sub    $0x40,%rsp
  8022e6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8022e9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8022ed:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022f1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022f5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022f8:	48 89 d6             	mov    %rdx,%rsi
  8022fb:	89 c7                	mov    %eax,%edi
  8022fd:	48 b8 ac 1e 80 00 00 	movabs $0x801eac,%rax
  802304:	00 00 00 
  802307:	ff d0                	callq  *%rax
  802309:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80230c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802310:	78 24                	js     802336 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802312:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802316:	8b 00                	mov    (%rax),%eax
  802318:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80231c:	48 89 d6             	mov    %rdx,%rsi
  80231f:	89 c7                	mov    %eax,%edi
  802321:	48 b8 05 20 80 00 00 	movabs $0x802005,%rax
  802328:	00 00 00 
  80232b:	ff d0                	callq  *%rax
  80232d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802330:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802334:	79 05                	jns    80233b <read+0x5d>
		return r;
  802336:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802339:	eb 76                	jmp    8023b1 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80233b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80233f:	8b 40 08             	mov    0x8(%rax),%eax
  802342:	83 e0 03             	and    $0x3,%eax
  802345:	83 f8 01             	cmp    $0x1,%eax
  802348:	75 3a                	jne    802384 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80234a:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802351:	00 00 00 
  802354:	48 8b 00             	mov    (%rax),%rax
  802357:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80235d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802360:	89 c6                	mov    %eax,%esi
  802362:	48 bf 4f 40 80 00 00 	movabs $0x80404f,%rdi
  802369:	00 00 00 
  80236c:	b8 00 00 00 00       	mov    $0x0,%eax
  802371:	48 b9 90 03 80 00 00 	movabs $0x800390,%rcx
  802378:	00 00 00 
  80237b:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80237d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802382:	eb 2d                	jmp    8023b1 <read+0xd3>
	}
	if (!dev->dev_read)
  802384:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802388:	48 8b 40 10          	mov    0x10(%rax),%rax
  80238c:	48 85 c0             	test   %rax,%rax
  80238f:	75 07                	jne    802398 <read+0xba>
		return -E_NOT_SUPP;
  802391:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802396:	eb 19                	jmp    8023b1 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802398:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80239c:	48 8b 40 10          	mov    0x10(%rax),%rax
  8023a0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8023a4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8023a8:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8023ac:	48 89 cf             	mov    %rcx,%rdi
  8023af:	ff d0                	callq  *%rax
}
  8023b1:	c9                   	leaveq 
  8023b2:	c3                   	retq   

00000000008023b3 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8023b3:	55                   	push   %rbp
  8023b4:	48 89 e5             	mov    %rsp,%rbp
  8023b7:	48 83 ec 30          	sub    $0x30,%rsp
  8023bb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023be:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8023c2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8023c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8023cd:	eb 49                	jmp    802418 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8023cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023d2:	48 98                	cltq   
  8023d4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8023d8:	48 29 c2             	sub    %rax,%rdx
  8023db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023de:	48 63 c8             	movslq %eax,%rcx
  8023e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023e5:	48 01 c1             	add    %rax,%rcx
  8023e8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023eb:	48 89 ce             	mov    %rcx,%rsi
  8023ee:	89 c7                	mov    %eax,%edi
  8023f0:	48 b8 de 22 80 00 00 	movabs $0x8022de,%rax
  8023f7:	00 00 00 
  8023fa:	ff d0                	callq  *%rax
  8023fc:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8023ff:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802403:	79 05                	jns    80240a <readn+0x57>
			return m;
  802405:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802408:	eb 1c                	jmp    802426 <readn+0x73>
		if (m == 0)
  80240a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80240e:	75 02                	jne    802412 <readn+0x5f>
			break;
  802410:	eb 11                	jmp    802423 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802412:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802415:	01 45 fc             	add    %eax,-0x4(%rbp)
  802418:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80241b:	48 98                	cltq   
  80241d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802421:	72 ac                	jb     8023cf <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802423:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802426:	c9                   	leaveq 
  802427:	c3                   	retq   

0000000000802428 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802428:	55                   	push   %rbp
  802429:	48 89 e5             	mov    %rsp,%rbp
  80242c:	48 83 ec 40          	sub    $0x40,%rsp
  802430:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802433:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802437:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80243b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80243f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802442:	48 89 d6             	mov    %rdx,%rsi
  802445:	89 c7                	mov    %eax,%edi
  802447:	48 b8 ac 1e 80 00 00 	movabs $0x801eac,%rax
  80244e:	00 00 00 
  802451:	ff d0                	callq  *%rax
  802453:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802456:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80245a:	78 24                	js     802480 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80245c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802460:	8b 00                	mov    (%rax),%eax
  802462:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802466:	48 89 d6             	mov    %rdx,%rsi
  802469:	89 c7                	mov    %eax,%edi
  80246b:	48 b8 05 20 80 00 00 	movabs $0x802005,%rax
  802472:	00 00 00 
  802475:	ff d0                	callq  *%rax
  802477:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80247a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80247e:	79 05                	jns    802485 <write+0x5d>
		return r;
  802480:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802483:	eb 75                	jmp    8024fa <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802485:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802489:	8b 40 08             	mov    0x8(%rax),%eax
  80248c:	83 e0 03             	and    $0x3,%eax
  80248f:	85 c0                	test   %eax,%eax
  802491:	75 3a                	jne    8024cd <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802493:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80249a:	00 00 00 
  80249d:	48 8b 00             	mov    (%rax),%rax
  8024a0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024a6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8024a9:	89 c6                	mov    %eax,%esi
  8024ab:	48 bf 6b 40 80 00 00 	movabs $0x80406b,%rdi
  8024b2:	00 00 00 
  8024b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ba:	48 b9 90 03 80 00 00 	movabs $0x800390,%rcx
  8024c1:	00 00 00 
  8024c4:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8024c6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024cb:	eb 2d                	jmp    8024fa <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8024cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024d1:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024d5:	48 85 c0             	test   %rax,%rax
  8024d8:	75 07                	jne    8024e1 <write+0xb9>
		return -E_NOT_SUPP;
  8024da:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024df:	eb 19                	jmp    8024fa <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8024e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024e5:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024e9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8024ed:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8024f1:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8024f5:	48 89 cf             	mov    %rcx,%rdi
  8024f8:	ff d0                	callq  *%rax
}
  8024fa:	c9                   	leaveq 
  8024fb:	c3                   	retq   

00000000008024fc <seek>:

int
seek(int fdnum, off_t offset)
{
  8024fc:	55                   	push   %rbp
  8024fd:	48 89 e5             	mov    %rsp,%rbp
  802500:	48 83 ec 18          	sub    $0x18,%rsp
  802504:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802507:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80250a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80250e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802511:	48 89 d6             	mov    %rdx,%rsi
  802514:	89 c7                	mov    %eax,%edi
  802516:	48 b8 ac 1e 80 00 00 	movabs $0x801eac,%rax
  80251d:	00 00 00 
  802520:	ff d0                	callq  *%rax
  802522:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802525:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802529:	79 05                	jns    802530 <seek+0x34>
		return r;
  80252b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80252e:	eb 0f                	jmp    80253f <seek+0x43>
	fd->fd_offset = offset;
  802530:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802534:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802537:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80253a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80253f:	c9                   	leaveq 
  802540:	c3                   	retq   

0000000000802541 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802541:	55                   	push   %rbp
  802542:	48 89 e5             	mov    %rsp,%rbp
  802545:	48 83 ec 30          	sub    $0x30,%rsp
  802549:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80254c:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80254f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802553:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802556:	48 89 d6             	mov    %rdx,%rsi
  802559:	89 c7                	mov    %eax,%edi
  80255b:	48 b8 ac 1e 80 00 00 	movabs $0x801eac,%rax
  802562:	00 00 00 
  802565:	ff d0                	callq  *%rax
  802567:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80256a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80256e:	78 24                	js     802594 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802570:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802574:	8b 00                	mov    (%rax),%eax
  802576:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80257a:	48 89 d6             	mov    %rdx,%rsi
  80257d:	89 c7                	mov    %eax,%edi
  80257f:	48 b8 05 20 80 00 00 	movabs $0x802005,%rax
  802586:	00 00 00 
  802589:	ff d0                	callq  *%rax
  80258b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80258e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802592:	79 05                	jns    802599 <ftruncate+0x58>
		return r;
  802594:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802597:	eb 72                	jmp    80260b <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802599:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80259d:	8b 40 08             	mov    0x8(%rax),%eax
  8025a0:	83 e0 03             	and    $0x3,%eax
  8025a3:	85 c0                	test   %eax,%eax
  8025a5:	75 3a                	jne    8025e1 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8025a7:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8025ae:	00 00 00 
  8025b1:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8025b4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025ba:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8025bd:	89 c6                	mov    %eax,%esi
  8025bf:	48 bf 88 40 80 00 00 	movabs $0x804088,%rdi
  8025c6:	00 00 00 
  8025c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ce:	48 b9 90 03 80 00 00 	movabs $0x800390,%rcx
  8025d5:	00 00 00 
  8025d8:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8025da:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025df:	eb 2a                	jmp    80260b <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8025e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025e5:	48 8b 40 30          	mov    0x30(%rax),%rax
  8025e9:	48 85 c0             	test   %rax,%rax
  8025ec:	75 07                	jne    8025f5 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8025ee:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025f3:	eb 16                	jmp    80260b <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8025f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025f9:	48 8b 40 30          	mov    0x30(%rax),%rax
  8025fd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802601:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802604:	89 ce                	mov    %ecx,%esi
  802606:	48 89 d7             	mov    %rdx,%rdi
  802609:	ff d0                	callq  *%rax
}
  80260b:	c9                   	leaveq 
  80260c:	c3                   	retq   

000000000080260d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80260d:	55                   	push   %rbp
  80260e:	48 89 e5             	mov    %rsp,%rbp
  802611:	48 83 ec 30          	sub    $0x30,%rsp
  802615:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802618:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80261c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802620:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802623:	48 89 d6             	mov    %rdx,%rsi
  802626:	89 c7                	mov    %eax,%edi
  802628:	48 b8 ac 1e 80 00 00 	movabs $0x801eac,%rax
  80262f:	00 00 00 
  802632:	ff d0                	callq  *%rax
  802634:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802637:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80263b:	78 24                	js     802661 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80263d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802641:	8b 00                	mov    (%rax),%eax
  802643:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802647:	48 89 d6             	mov    %rdx,%rsi
  80264a:	89 c7                	mov    %eax,%edi
  80264c:	48 b8 05 20 80 00 00 	movabs $0x802005,%rax
  802653:	00 00 00 
  802656:	ff d0                	callq  *%rax
  802658:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80265b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80265f:	79 05                	jns    802666 <fstat+0x59>
		return r;
  802661:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802664:	eb 5e                	jmp    8026c4 <fstat+0xb7>
	if (!dev->dev_stat)
  802666:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80266a:	48 8b 40 28          	mov    0x28(%rax),%rax
  80266e:	48 85 c0             	test   %rax,%rax
  802671:	75 07                	jne    80267a <fstat+0x6d>
		return -E_NOT_SUPP;
  802673:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802678:	eb 4a                	jmp    8026c4 <fstat+0xb7>
	stat->st_name[0] = 0;
  80267a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80267e:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802681:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802685:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80268c:	00 00 00 
	stat->st_isdir = 0;
  80268f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802693:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80269a:	00 00 00 
	stat->st_dev = dev;
  80269d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8026a1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026a5:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8026ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026b0:	48 8b 40 28          	mov    0x28(%rax),%rax
  8026b4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8026b8:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8026bc:	48 89 ce             	mov    %rcx,%rsi
  8026bf:	48 89 d7             	mov    %rdx,%rdi
  8026c2:	ff d0                	callq  *%rax
}
  8026c4:	c9                   	leaveq 
  8026c5:	c3                   	retq   

00000000008026c6 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8026c6:	55                   	push   %rbp
  8026c7:	48 89 e5             	mov    %rsp,%rbp
  8026ca:	48 83 ec 20          	sub    $0x20,%rsp
  8026ce:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026d2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8026d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026da:	be 00 00 00 00       	mov    $0x0,%esi
  8026df:	48 89 c7             	mov    %rax,%rdi
  8026e2:	48 b8 b4 27 80 00 00 	movabs $0x8027b4,%rax
  8026e9:	00 00 00 
  8026ec:	ff d0                	callq  *%rax
  8026ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026f5:	79 05                	jns    8026fc <stat+0x36>
		return fd;
  8026f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026fa:	eb 2f                	jmp    80272b <stat+0x65>
	r = fstat(fd, stat);
  8026fc:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802700:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802703:	48 89 d6             	mov    %rdx,%rsi
  802706:	89 c7                	mov    %eax,%edi
  802708:	48 b8 0d 26 80 00 00 	movabs $0x80260d,%rax
  80270f:	00 00 00 
  802712:	ff d0                	callq  *%rax
  802714:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802717:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80271a:	89 c7                	mov    %eax,%edi
  80271c:	48 b8 bc 20 80 00 00 	movabs $0x8020bc,%rax
  802723:	00 00 00 
  802726:	ff d0                	callq  *%rax
	return r;
  802728:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80272b:	c9                   	leaveq 
  80272c:	c3                   	retq   

000000000080272d <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80272d:	55                   	push   %rbp
  80272e:	48 89 e5             	mov    %rsp,%rbp
  802731:	48 83 ec 10          	sub    $0x10,%rsp
  802735:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802738:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80273c:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802743:	00 00 00 
  802746:	8b 00                	mov    (%rax),%eax
  802748:	85 c0                	test   %eax,%eax
  80274a:	75 1d                	jne    802769 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80274c:	bf 01 00 00 00       	mov    $0x1,%edi
  802751:	48 b8 eb 39 80 00 00 	movabs $0x8039eb,%rax
  802758:	00 00 00 
  80275b:	ff d0                	callq  *%rax
  80275d:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  802764:	00 00 00 
  802767:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802769:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802770:	00 00 00 
  802773:	8b 00                	mov    (%rax),%eax
  802775:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802778:	b9 07 00 00 00       	mov    $0x7,%ecx
  80277d:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802784:	00 00 00 
  802787:	89 c7                	mov    %eax,%edi
  802789:	48 b8 89 39 80 00 00 	movabs $0x803989,%rax
  802790:	00 00 00 
  802793:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802795:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802799:	ba 00 00 00 00       	mov    $0x0,%edx
  80279e:	48 89 c6             	mov    %rax,%rsi
  8027a1:	bf 00 00 00 00       	mov    $0x0,%edi
  8027a6:	48 b8 83 38 80 00 00 	movabs $0x803883,%rax
  8027ad:	00 00 00 
  8027b0:	ff d0                	callq  *%rax
}
  8027b2:	c9                   	leaveq 
  8027b3:	c3                   	retq   

00000000008027b4 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8027b4:	55                   	push   %rbp
  8027b5:	48 89 e5             	mov    %rsp,%rbp
  8027b8:	48 83 ec 30          	sub    $0x30,%rsp
  8027bc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8027c0:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  8027c3:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  8027ca:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  8027d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  8027d8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8027dd:	75 08                	jne    8027e7 <open+0x33>
	{
		return r;
  8027df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027e2:	e9 f2 00 00 00       	jmpq   8028d9 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  8027e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027eb:	48 89 c7             	mov    %rax,%rdi
  8027ee:	48 b8 d9 0e 80 00 00 	movabs $0x800ed9,%rax
  8027f5:	00 00 00 
  8027f8:	ff d0                	callq  *%rax
  8027fa:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8027fd:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802804:	7e 0a                	jle    802810 <open+0x5c>
	{
		return -E_BAD_PATH;
  802806:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80280b:	e9 c9 00 00 00       	jmpq   8028d9 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802810:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802817:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802818:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80281c:	48 89 c7             	mov    %rax,%rdi
  80281f:	48 b8 14 1e 80 00 00 	movabs $0x801e14,%rax
  802826:	00 00 00 
  802829:	ff d0                	callq  *%rax
  80282b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80282e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802832:	78 09                	js     80283d <open+0x89>
  802834:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802838:	48 85 c0             	test   %rax,%rax
  80283b:	75 08                	jne    802845 <open+0x91>
		{
			return r;
  80283d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802840:	e9 94 00 00 00       	jmpq   8028d9 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802845:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802849:	ba 00 04 00 00       	mov    $0x400,%edx
  80284e:	48 89 c6             	mov    %rax,%rsi
  802851:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802858:	00 00 00 
  80285b:	48 b8 d7 0f 80 00 00 	movabs $0x800fd7,%rax
  802862:	00 00 00 
  802865:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802867:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80286e:	00 00 00 
  802871:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802874:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  80287a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80287e:	48 89 c6             	mov    %rax,%rsi
  802881:	bf 01 00 00 00       	mov    $0x1,%edi
  802886:	48 b8 2d 27 80 00 00 	movabs $0x80272d,%rax
  80288d:	00 00 00 
  802890:	ff d0                	callq  *%rax
  802892:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802895:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802899:	79 2b                	jns    8028c6 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  80289b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80289f:	be 00 00 00 00       	mov    $0x0,%esi
  8028a4:	48 89 c7             	mov    %rax,%rdi
  8028a7:	48 b8 3c 1f 80 00 00 	movabs $0x801f3c,%rax
  8028ae:	00 00 00 
  8028b1:	ff d0                	callq  *%rax
  8028b3:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8028b6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8028ba:	79 05                	jns    8028c1 <open+0x10d>
			{
				return d;
  8028bc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8028bf:	eb 18                	jmp    8028d9 <open+0x125>
			}
			return r;
  8028c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028c4:	eb 13                	jmp    8028d9 <open+0x125>
		}	
		return fd2num(fd_store);
  8028c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028ca:	48 89 c7             	mov    %rax,%rdi
  8028cd:	48 b8 c6 1d 80 00 00 	movabs $0x801dc6,%rax
  8028d4:	00 00 00 
  8028d7:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  8028d9:	c9                   	leaveq 
  8028da:	c3                   	retq   

00000000008028db <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8028db:	55                   	push   %rbp
  8028dc:	48 89 e5             	mov    %rsp,%rbp
  8028df:	48 83 ec 10          	sub    $0x10,%rsp
  8028e3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8028e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028eb:	8b 50 0c             	mov    0xc(%rax),%edx
  8028ee:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8028f5:	00 00 00 
  8028f8:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8028fa:	be 00 00 00 00       	mov    $0x0,%esi
  8028ff:	bf 06 00 00 00       	mov    $0x6,%edi
  802904:	48 b8 2d 27 80 00 00 	movabs $0x80272d,%rax
  80290b:	00 00 00 
  80290e:	ff d0                	callq  *%rax
}
  802910:	c9                   	leaveq 
  802911:	c3                   	retq   

0000000000802912 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802912:	55                   	push   %rbp
  802913:	48 89 e5             	mov    %rsp,%rbp
  802916:	48 83 ec 30          	sub    $0x30,%rsp
  80291a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80291e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802922:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802926:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  80292d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802932:	74 07                	je     80293b <devfile_read+0x29>
  802934:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802939:	75 07                	jne    802942 <devfile_read+0x30>
		return -E_INVAL;
  80293b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802940:	eb 77                	jmp    8029b9 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802942:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802946:	8b 50 0c             	mov    0xc(%rax),%edx
  802949:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802950:	00 00 00 
  802953:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802955:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80295c:	00 00 00 
  80295f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802963:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802967:	be 00 00 00 00       	mov    $0x0,%esi
  80296c:	bf 03 00 00 00       	mov    $0x3,%edi
  802971:	48 b8 2d 27 80 00 00 	movabs $0x80272d,%rax
  802978:	00 00 00 
  80297b:	ff d0                	callq  *%rax
  80297d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802980:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802984:	7f 05                	jg     80298b <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802986:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802989:	eb 2e                	jmp    8029b9 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  80298b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80298e:	48 63 d0             	movslq %eax,%rdx
  802991:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802995:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  80299c:	00 00 00 
  80299f:	48 89 c7             	mov    %rax,%rdi
  8029a2:	48 b8 69 12 80 00 00 	movabs $0x801269,%rax
  8029a9:	00 00 00 
  8029ac:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  8029ae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029b2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  8029b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8029b9:	c9                   	leaveq 
  8029ba:	c3                   	retq   

00000000008029bb <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8029bb:	55                   	push   %rbp
  8029bc:	48 89 e5             	mov    %rsp,%rbp
  8029bf:	48 83 ec 30          	sub    $0x30,%rsp
  8029c3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029c7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8029cb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  8029cf:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  8029d6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8029db:	74 07                	je     8029e4 <devfile_write+0x29>
  8029dd:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8029e2:	75 08                	jne    8029ec <devfile_write+0x31>
		return r;
  8029e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029e7:	e9 9a 00 00 00       	jmpq   802a86 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8029ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029f0:	8b 50 0c             	mov    0xc(%rax),%edx
  8029f3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8029fa:	00 00 00 
  8029fd:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  8029ff:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802a06:	00 
  802a07:	76 08                	jbe    802a11 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802a09:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802a10:	00 
	}
	fsipcbuf.write.req_n = n;
  802a11:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a18:	00 00 00 
  802a1b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a1f:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802a23:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a27:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a2b:	48 89 c6             	mov    %rax,%rsi
  802a2e:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  802a35:	00 00 00 
  802a38:	48 b8 69 12 80 00 00 	movabs $0x801269,%rax
  802a3f:	00 00 00 
  802a42:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802a44:	be 00 00 00 00       	mov    $0x0,%esi
  802a49:	bf 04 00 00 00       	mov    $0x4,%edi
  802a4e:	48 b8 2d 27 80 00 00 	movabs $0x80272d,%rax
  802a55:	00 00 00 
  802a58:	ff d0                	callq  *%rax
  802a5a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a5d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a61:	7f 20                	jg     802a83 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802a63:	48 bf ae 40 80 00 00 	movabs $0x8040ae,%rdi
  802a6a:	00 00 00 
  802a6d:	b8 00 00 00 00       	mov    $0x0,%eax
  802a72:	48 ba 90 03 80 00 00 	movabs $0x800390,%rdx
  802a79:	00 00 00 
  802a7c:	ff d2                	callq  *%rdx
		return r;
  802a7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a81:	eb 03                	jmp    802a86 <devfile_write+0xcb>
	}
	return r;
  802a83:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802a86:	c9                   	leaveq 
  802a87:	c3                   	retq   

0000000000802a88 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802a88:	55                   	push   %rbp
  802a89:	48 89 e5             	mov    %rsp,%rbp
  802a8c:	48 83 ec 20          	sub    $0x20,%rsp
  802a90:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a94:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802a98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a9c:	8b 50 0c             	mov    0xc(%rax),%edx
  802a9f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802aa6:	00 00 00 
  802aa9:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802aab:	be 00 00 00 00       	mov    $0x0,%esi
  802ab0:	bf 05 00 00 00       	mov    $0x5,%edi
  802ab5:	48 b8 2d 27 80 00 00 	movabs $0x80272d,%rax
  802abc:	00 00 00 
  802abf:	ff d0                	callq  *%rax
  802ac1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ac4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ac8:	79 05                	jns    802acf <devfile_stat+0x47>
		return r;
  802aca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802acd:	eb 56                	jmp    802b25 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802acf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ad3:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802ada:	00 00 00 
  802add:	48 89 c7             	mov    %rax,%rdi
  802ae0:	48 b8 45 0f 80 00 00 	movabs $0x800f45,%rax
  802ae7:	00 00 00 
  802aea:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802aec:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802af3:	00 00 00 
  802af6:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802afc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b00:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802b06:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b0d:	00 00 00 
  802b10:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802b16:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b1a:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802b20:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b25:	c9                   	leaveq 
  802b26:	c3                   	retq   

0000000000802b27 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802b27:	55                   	push   %rbp
  802b28:	48 89 e5             	mov    %rsp,%rbp
  802b2b:	48 83 ec 10          	sub    $0x10,%rsp
  802b2f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802b33:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802b36:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b3a:	8b 50 0c             	mov    0xc(%rax),%edx
  802b3d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b44:	00 00 00 
  802b47:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802b49:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b50:	00 00 00 
  802b53:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802b56:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802b59:	be 00 00 00 00       	mov    $0x0,%esi
  802b5e:	bf 02 00 00 00       	mov    $0x2,%edi
  802b63:	48 b8 2d 27 80 00 00 	movabs $0x80272d,%rax
  802b6a:	00 00 00 
  802b6d:	ff d0                	callq  *%rax
}
  802b6f:	c9                   	leaveq 
  802b70:	c3                   	retq   

0000000000802b71 <remove>:

// Delete a file
int
remove(const char *path)
{
  802b71:	55                   	push   %rbp
  802b72:	48 89 e5             	mov    %rsp,%rbp
  802b75:	48 83 ec 10          	sub    $0x10,%rsp
  802b79:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802b7d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b81:	48 89 c7             	mov    %rax,%rdi
  802b84:	48 b8 d9 0e 80 00 00 	movabs $0x800ed9,%rax
  802b8b:	00 00 00 
  802b8e:	ff d0                	callq  *%rax
  802b90:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802b95:	7e 07                	jle    802b9e <remove+0x2d>
		return -E_BAD_PATH;
  802b97:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802b9c:	eb 33                	jmp    802bd1 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802b9e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ba2:	48 89 c6             	mov    %rax,%rsi
  802ba5:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802bac:	00 00 00 
  802baf:	48 b8 45 0f 80 00 00 	movabs $0x800f45,%rax
  802bb6:	00 00 00 
  802bb9:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802bbb:	be 00 00 00 00       	mov    $0x0,%esi
  802bc0:	bf 07 00 00 00       	mov    $0x7,%edi
  802bc5:	48 b8 2d 27 80 00 00 	movabs $0x80272d,%rax
  802bcc:	00 00 00 
  802bcf:	ff d0                	callq  *%rax
}
  802bd1:	c9                   	leaveq 
  802bd2:	c3                   	retq   

0000000000802bd3 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802bd3:	55                   	push   %rbp
  802bd4:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802bd7:	be 00 00 00 00       	mov    $0x0,%esi
  802bdc:	bf 08 00 00 00       	mov    $0x8,%edi
  802be1:	48 b8 2d 27 80 00 00 	movabs $0x80272d,%rax
  802be8:	00 00 00 
  802beb:	ff d0                	callq  *%rax
}
  802bed:	5d                   	pop    %rbp
  802bee:	c3                   	retq   

0000000000802bef <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  802bef:	55                   	push   %rbp
  802bf0:	48 89 e5             	mov    %rsp,%rbp
  802bf3:	48 83 ec 20          	sub    $0x20,%rsp
  802bf7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  802bfb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bff:	8b 40 0c             	mov    0xc(%rax),%eax
  802c02:	85 c0                	test   %eax,%eax
  802c04:	7e 67                	jle    802c6d <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802c06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c0a:	8b 40 04             	mov    0x4(%rax),%eax
  802c0d:	48 63 d0             	movslq %eax,%rdx
  802c10:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c14:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802c18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c1c:	8b 00                	mov    (%rax),%eax
  802c1e:	48 89 ce             	mov    %rcx,%rsi
  802c21:	89 c7                	mov    %eax,%edi
  802c23:	48 b8 28 24 80 00 00 	movabs $0x802428,%rax
  802c2a:	00 00 00 
  802c2d:	ff d0                	callq  *%rax
  802c2f:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  802c32:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c36:	7e 13                	jle    802c4b <writebuf+0x5c>
			b->result += result;
  802c38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c3c:	8b 50 08             	mov    0x8(%rax),%edx
  802c3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c42:	01 c2                	add    %eax,%edx
  802c44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c48:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  802c4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c4f:	8b 40 04             	mov    0x4(%rax),%eax
  802c52:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802c55:	74 16                	je     802c6d <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  802c57:	b8 00 00 00 00       	mov    $0x0,%eax
  802c5c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c60:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  802c64:	89 c2                	mov    %eax,%edx
  802c66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c6a:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  802c6d:	c9                   	leaveq 
  802c6e:	c3                   	retq   

0000000000802c6f <putch>:

static void
putch(int ch, void *thunk)
{
  802c6f:	55                   	push   %rbp
  802c70:	48 89 e5             	mov    %rsp,%rbp
  802c73:	48 83 ec 20          	sub    $0x20,%rsp
  802c77:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c7a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  802c7e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c82:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  802c86:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c8a:	8b 40 04             	mov    0x4(%rax),%eax
  802c8d:	8d 48 01             	lea    0x1(%rax),%ecx
  802c90:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802c94:	89 4a 04             	mov    %ecx,0x4(%rdx)
  802c97:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802c9a:	89 d1                	mov    %edx,%ecx
  802c9c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802ca0:	48 98                	cltq   
  802ca2:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  802ca6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802caa:	8b 40 04             	mov    0x4(%rax),%eax
  802cad:	3d 00 01 00 00       	cmp    $0x100,%eax
  802cb2:	75 1e                	jne    802cd2 <putch+0x63>
		writebuf(b);
  802cb4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cb8:	48 89 c7             	mov    %rax,%rdi
  802cbb:	48 b8 ef 2b 80 00 00 	movabs $0x802bef,%rax
  802cc2:	00 00 00 
  802cc5:	ff d0                	callq  *%rax
		b->idx = 0;
  802cc7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ccb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  802cd2:	c9                   	leaveq 
  802cd3:	c3                   	retq   

0000000000802cd4 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802cd4:	55                   	push   %rbp
  802cd5:	48 89 e5             	mov    %rsp,%rbp
  802cd8:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  802cdf:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  802ce5:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  802cec:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  802cf3:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  802cf9:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  802cff:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802d06:	00 00 00 
	b.result = 0;
  802d09:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  802d10:	00 00 00 
	b.error = 1;
  802d13:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  802d1a:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802d1d:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  802d24:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  802d2b:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802d32:	48 89 c6             	mov    %rax,%rsi
  802d35:	48 bf 6f 2c 80 00 00 	movabs $0x802c6f,%rdi
  802d3c:	00 00 00 
  802d3f:	48 b8 43 07 80 00 00 	movabs $0x800743,%rax
  802d46:	00 00 00 
  802d49:	ff d0                	callq  *%rax
	if (b.idx > 0)
  802d4b:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  802d51:	85 c0                	test   %eax,%eax
  802d53:	7e 16                	jle    802d6b <vfprintf+0x97>
		writebuf(&b);
  802d55:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802d5c:	48 89 c7             	mov    %rax,%rdi
  802d5f:	48 b8 ef 2b 80 00 00 	movabs $0x802bef,%rax
  802d66:	00 00 00 
  802d69:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  802d6b:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802d71:	85 c0                	test   %eax,%eax
  802d73:	74 08                	je     802d7d <vfprintf+0xa9>
  802d75:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802d7b:	eb 06                	jmp    802d83 <vfprintf+0xaf>
  802d7d:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  802d83:	c9                   	leaveq 
  802d84:	c3                   	retq   

0000000000802d85 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802d85:	55                   	push   %rbp
  802d86:	48 89 e5             	mov    %rsp,%rbp
  802d89:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802d90:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  802d96:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802d9d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802da4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802dab:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802db2:	84 c0                	test   %al,%al
  802db4:	74 20                	je     802dd6 <fprintf+0x51>
  802db6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802dba:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802dbe:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802dc2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802dc6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802dca:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802dce:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802dd2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802dd6:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802ddd:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  802de4:	00 00 00 
  802de7:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802dee:	00 00 00 
  802df1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802df5:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802dfc:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802e03:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  802e0a:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802e11:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  802e18:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  802e1e:	48 89 ce             	mov    %rcx,%rsi
  802e21:	89 c7                	mov    %eax,%edi
  802e23:	48 b8 d4 2c 80 00 00 	movabs $0x802cd4,%rax
  802e2a:	00 00 00 
  802e2d:	ff d0                	callq  *%rax
  802e2f:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  802e35:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802e3b:	c9                   	leaveq 
  802e3c:	c3                   	retq   

0000000000802e3d <printf>:

int
printf(const char *fmt, ...)
{
  802e3d:	55                   	push   %rbp
  802e3e:	48 89 e5             	mov    %rsp,%rbp
  802e41:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802e48:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  802e4f:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802e56:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802e5d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802e64:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802e6b:	84 c0                	test   %al,%al
  802e6d:	74 20                	je     802e8f <printf+0x52>
  802e6f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802e73:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802e77:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802e7b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802e7f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802e83:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802e87:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802e8b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802e8f:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802e96:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  802e9d:	00 00 00 
  802ea0:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802ea7:	00 00 00 
  802eaa:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802eae:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802eb5:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802ebc:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  802ec3:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802eca:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  802ed1:	48 89 c6             	mov    %rax,%rsi
  802ed4:	bf 01 00 00 00       	mov    $0x1,%edi
  802ed9:	48 b8 d4 2c 80 00 00 	movabs $0x802cd4,%rax
  802ee0:	00 00 00 
  802ee3:	ff d0                	callq  *%rax
  802ee5:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  802eeb:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802ef1:	c9                   	leaveq 
  802ef2:	c3                   	retq   

0000000000802ef3 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802ef3:	55                   	push   %rbp
  802ef4:	48 89 e5             	mov    %rsp,%rbp
  802ef7:	53                   	push   %rbx
  802ef8:	48 83 ec 38          	sub    $0x38,%rsp
  802efc:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802f00:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802f04:	48 89 c7             	mov    %rax,%rdi
  802f07:	48 b8 14 1e 80 00 00 	movabs $0x801e14,%rax
  802f0e:	00 00 00 
  802f11:	ff d0                	callq  *%rax
  802f13:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802f16:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802f1a:	0f 88 bf 01 00 00    	js     8030df <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802f20:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f24:	ba 07 04 00 00       	mov    $0x407,%edx
  802f29:	48 89 c6             	mov    %rax,%rsi
  802f2c:	bf 00 00 00 00       	mov    $0x0,%edi
  802f31:	48 b8 74 18 80 00 00 	movabs $0x801874,%rax
  802f38:	00 00 00 
  802f3b:	ff d0                	callq  *%rax
  802f3d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802f40:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802f44:	0f 88 95 01 00 00    	js     8030df <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802f4a:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802f4e:	48 89 c7             	mov    %rax,%rdi
  802f51:	48 b8 14 1e 80 00 00 	movabs $0x801e14,%rax
  802f58:	00 00 00 
  802f5b:	ff d0                	callq  *%rax
  802f5d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802f60:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802f64:	0f 88 5d 01 00 00    	js     8030c7 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802f6a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f6e:	ba 07 04 00 00       	mov    $0x407,%edx
  802f73:	48 89 c6             	mov    %rax,%rsi
  802f76:	bf 00 00 00 00       	mov    $0x0,%edi
  802f7b:	48 b8 74 18 80 00 00 	movabs $0x801874,%rax
  802f82:	00 00 00 
  802f85:	ff d0                	callq  *%rax
  802f87:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802f8a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802f8e:	0f 88 33 01 00 00    	js     8030c7 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802f94:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f98:	48 89 c7             	mov    %rax,%rdi
  802f9b:	48 b8 e9 1d 80 00 00 	movabs $0x801de9,%rax
  802fa2:	00 00 00 
  802fa5:	ff d0                	callq  *%rax
  802fa7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802fab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802faf:	ba 07 04 00 00       	mov    $0x407,%edx
  802fb4:	48 89 c6             	mov    %rax,%rsi
  802fb7:	bf 00 00 00 00       	mov    $0x0,%edi
  802fbc:	48 b8 74 18 80 00 00 	movabs $0x801874,%rax
  802fc3:	00 00 00 
  802fc6:	ff d0                	callq  *%rax
  802fc8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802fcb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802fcf:	79 05                	jns    802fd6 <pipe+0xe3>
		goto err2;
  802fd1:	e9 d9 00 00 00       	jmpq   8030af <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802fd6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fda:	48 89 c7             	mov    %rax,%rdi
  802fdd:	48 b8 e9 1d 80 00 00 	movabs $0x801de9,%rax
  802fe4:	00 00 00 
  802fe7:	ff d0                	callq  *%rax
  802fe9:	48 89 c2             	mov    %rax,%rdx
  802fec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ff0:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  802ff6:	48 89 d1             	mov    %rdx,%rcx
  802ff9:	ba 00 00 00 00       	mov    $0x0,%edx
  802ffe:	48 89 c6             	mov    %rax,%rsi
  803001:	bf 00 00 00 00       	mov    $0x0,%edi
  803006:	48 b8 c4 18 80 00 00 	movabs $0x8018c4,%rax
  80300d:	00 00 00 
  803010:	ff d0                	callq  *%rax
  803012:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803015:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803019:	79 1b                	jns    803036 <pipe+0x143>
		goto err3;
  80301b:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  80301c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803020:	48 89 c6             	mov    %rax,%rsi
  803023:	bf 00 00 00 00       	mov    $0x0,%edi
  803028:	48 b8 1f 19 80 00 00 	movabs $0x80191f,%rax
  80302f:	00 00 00 
  803032:	ff d0                	callq  *%rax
  803034:	eb 79                	jmp    8030af <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803036:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80303a:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  803041:	00 00 00 
  803044:	8b 12                	mov    (%rdx),%edx
  803046:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803048:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80304c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803053:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803057:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  80305e:	00 00 00 
  803061:	8b 12                	mov    (%rdx),%edx
  803063:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803065:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803069:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803070:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803074:	48 89 c7             	mov    %rax,%rdi
  803077:	48 b8 c6 1d 80 00 00 	movabs $0x801dc6,%rax
  80307e:	00 00 00 
  803081:	ff d0                	callq  *%rax
  803083:	89 c2                	mov    %eax,%edx
  803085:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803089:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80308b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80308f:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803093:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803097:	48 89 c7             	mov    %rax,%rdi
  80309a:	48 b8 c6 1d 80 00 00 	movabs $0x801dc6,%rax
  8030a1:	00 00 00 
  8030a4:	ff d0                	callq  *%rax
  8030a6:	89 03                	mov    %eax,(%rbx)
	return 0;
  8030a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8030ad:	eb 33                	jmp    8030e2 <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  8030af:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030b3:	48 89 c6             	mov    %rax,%rsi
  8030b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8030bb:	48 b8 1f 19 80 00 00 	movabs $0x80191f,%rax
  8030c2:	00 00 00 
  8030c5:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  8030c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030cb:	48 89 c6             	mov    %rax,%rsi
  8030ce:	bf 00 00 00 00       	mov    $0x0,%edi
  8030d3:	48 b8 1f 19 80 00 00 	movabs $0x80191f,%rax
  8030da:	00 00 00 
  8030dd:	ff d0                	callq  *%rax
    err:
	return r;
  8030df:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8030e2:	48 83 c4 38          	add    $0x38,%rsp
  8030e6:	5b                   	pop    %rbx
  8030e7:	5d                   	pop    %rbp
  8030e8:	c3                   	retq   

00000000008030e9 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8030e9:	55                   	push   %rbp
  8030ea:	48 89 e5             	mov    %rsp,%rbp
  8030ed:	53                   	push   %rbx
  8030ee:	48 83 ec 28          	sub    $0x28,%rsp
  8030f2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8030f6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8030fa:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803101:	00 00 00 
  803104:	48 8b 00             	mov    (%rax),%rax
  803107:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80310d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803110:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803114:	48 89 c7             	mov    %rax,%rdi
  803117:	48 b8 6d 3a 80 00 00 	movabs $0x803a6d,%rax
  80311e:	00 00 00 
  803121:	ff d0                	callq  *%rax
  803123:	89 c3                	mov    %eax,%ebx
  803125:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803129:	48 89 c7             	mov    %rax,%rdi
  80312c:	48 b8 6d 3a 80 00 00 	movabs $0x803a6d,%rax
  803133:	00 00 00 
  803136:	ff d0                	callq  *%rax
  803138:	39 c3                	cmp    %eax,%ebx
  80313a:	0f 94 c0             	sete   %al
  80313d:	0f b6 c0             	movzbl %al,%eax
  803140:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803143:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80314a:	00 00 00 
  80314d:	48 8b 00             	mov    (%rax),%rax
  803150:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803156:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803159:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80315c:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80315f:	75 05                	jne    803166 <_pipeisclosed+0x7d>
			return ret;
  803161:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803164:	eb 4f                	jmp    8031b5 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803166:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803169:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80316c:	74 42                	je     8031b0 <_pipeisclosed+0xc7>
  80316e:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803172:	75 3c                	jne    8031b0 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803174:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80317b:	00 00 00 
  80317e:	48 8b 00             	mov    (%rax),%rax
  803181:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803187:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80318a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80318d:	89 c6                	mov    %eax,%esi
  80318f:	48 bf cf 40 80 00 00 	movabs $0x8040cf,%rdi
  803196:	00 00 00 
  803199:	b8 00 00 00 00       	mov    $0x0,%eax
  80319e:	49 b8 90 03 80 00 00 	movabs $0x800390,%r8
  8031a5:	00 00 00 
  8031a8:	41 ff d0             	callq  *%r8
	}
  8031ab:	e9 4a ff ff ff       	jmpq   8030fa <_pipeisclosed+0x11>
  8031b0:	e9 45 ff ff ff       	jmpq   8030fa <_pipeisclosed+0x11>
}
  8031b5:	48 83 c4 28          	add    $0x28,%rsp
  8031b9:	5b                   	pop    %rbx
  8031ba:	5d                   	pop    %rbp
  8031bb:	c3                   	retq   

00000000008031bc <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8031bc:	55                   	push   %rbp
  8031bd:	48 89 e5             	mov    %rsp,%rbp
  8031c0:	48 83 ec 30          	sub    $0x30,%rsp
  8031c4:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8031c7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8031cb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8031ce:	48 89 d6             	mov    %rdx,%rsi
  8031d1:	89 c7                	mov    %eax,%edi
  8031d3:	48 b8 ac 1e 80 00 00 	movabs $0x801eac,%rax
  8031da:	00 00 00 
  8031dd:	ff d0                	callq  *%rax
  8031df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031e6:	79 05                	jns    8031ed <pipeisclosed+0x31>
		return r;
  8031e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031eb:	eb 31                	jmp    80321e <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8031ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031f1:	48 89 c7             	mov    %rax,%rdi
  8031f4:	48 b8 e9 1d 80 00 00 	movabs $0x801de9,%rax
  8031fb:	00 00 00 
  8031fe:	ff d0                	callq  *%rax
  803200:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803204:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803208:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80320c:	48 89 d6             	mov    %rdx,%rsi
  80320f:	48 89 c7             	mov    %rax,%rdi
  803212:	48 b8 e9 30 80 00 00 	movabs $0x8030e9,%rax
  803219:	00 00 00 
  80321c:	ff d0                	callq  *%rax
}
  80321e:	c9                   	leaveq 
  80321f:	c3                   	retq   

0000000000803220 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803220:	55                   	push   %rbp
  803221:	48 89 e5             	mov    %rsp,%rbp
  803224:	48 83 ec 40          	sub    $0x40,%rsp
  803228:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80322c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803230:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803234:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803238:	48 89 c7             	mov    %rax,%rdi
  80323b:	48 b8 e9 1d 80 00 00 	movabs $0x801de9,%rax
  803242:	00 00 00 
  803245:	ff d0                	callq  *%rax
  803247:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80324b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80324f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803253:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80325a:	00 
  80325b:	e9 92 00 00 00       	jmpq   8032f2 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803260:	eb 41                	jmp    8032a3 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803262:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803267:	74 09                	je     803272 <devpipe_read+0x52>
				return i;
  803269:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80326d:	e9 92 00 00 00       	jmpq   803304 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803272:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803276:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80327a:	48 89 d6             	mov    %rdx,%rsi
  80327d:	48 89 c7             	mov    %rax,%rdi
  803280:	48 b8 e9 30 80 00 00 	movabs $0x8030e9,%rax
  803287:	00 00 00 
  80328a:	ff d0                	callq  *%rax
  80328c:	85 c0                	test   %eax,%eax
  80328e:	74 07                	je     803297 <devpipe_read+0x77>
				return 0;
  803290:	b8 00 00 00 00       	mov    $0x0,%eax
  803295:	eb 6d                	jmp    803304 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803297:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  80329e:	00 00 00 
  8032a1:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8032a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032a7:	8b 10                	mov    (%rax),%edx
  8032a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032ad:	8b 40 04             	mov    0x4(%rax),%eax
  8032b0:	39 c2                	cmp    %eax,%edx
  8032b2:	74 ae                	je     803262 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8032b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032b8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8032bc:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8032c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032c4:	8b 00                	mov    (%rax),%eax
  8032c6:	99                   	cltd   
  8032c7:	c1 ea 1b             	shr    $0x1b,%edx
  8032ca:	01 d0                	add    %edx,%eax
  8032cc:	83 e0 1f             	and    $0x1f,%eax
  8032cf:	29 d0                	sub    %edx,%eax
  8032d1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8032d5:	48 98                	cltq   
  8032d7:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8032dc:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8032de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032e2:	8b 00                	mov    (%rax),%eax
  8032e4:	8d 50 01             	lea    0x1(%rax),%edx
  8032e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032eb:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8032ed:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8032f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032f6:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8032fa:	0f 82 60 ff ff ff    	jb     803260 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803300:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803304:	c9                   	leaveq 
  803305:	c3                   	retq   

0000000000803306 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803306:	55                   	push   %rbp
  803307:	48 89 e5             	mov    %rsp,%rbp
  80330a:	48 83 ec 40          	sub    $0x40,%rsp
  80330e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803312:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803316:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80331a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80331e:	48 89 c7             	mov    %rax,%rdi
  803321:	48 b8 e9 1d 80 00 00 	movabs $0x801de9,%rax
  803328:	00 00 00 
  80332b:	ff d0                	callq  *%rax
  80332d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803331:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803335:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803339:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803340:	00 
  803341:	e9 8e 00 00 00       	jmpq   8033d4 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803346:	eb 31                	jmp    803379 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803348:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80334c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803350:	48 89 d6             	mov    %rdx,%rsi
  803353:	48 89 c7             	mov    %rax,%rdi
  803356:	48 b8 e9 30 80 00 00 	movabs $0x8030e9,%rax
  80335d:	00 00 00 
  803360:	ff d0                	callq  *%rax
  803362:	85 c0                	test   %eax,%eax
  803364:	74 07                	je     80336d <devpipe_write+0x67>
				return 0;
  803366:	b8 00 00 00 00       	mov    $0x0,%eax
  80336b:	eb 79                	jmp    8033e6 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80336d:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  803374:	00 00 00 
  803377:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803379:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80337d:	8b 40 04             	mov    0x4(%rax),%eax
  803380:	48 63 d0             	movslq %eax,%rdx
  803383:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803387:	8b 00                	mov    (%rax),%eax
  803389:	48 98                	cltq   
  80338b:	48 83 c0 20          	add    $0x20,%rax
  80338f:	48 39 c2             	cmp    %rax,%rdx
  803392:	73 b4                	jae    803348 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803394:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803398:	8b 40 04             	mov    0x4(%rax),%eax
  80339b:	99                   	cltd   
  80339c:	c1 ea 1b             	shr    $0x1b,%edx
  80339f:	01 d0                	add    %edx,%eax
  8033a1:	83 e0 1f             	and    $0x1f,%eax
  8033a4:	29 d0                	sub    %edx,%eax
  8033a6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8033aa:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8033ae:	48 01 ca             	add    %rcx,%rdx
  8033b1:	0f b6 0a             	movzbl (%rdx),%ecx
  8033b4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8033b8:	48 98                	cltq   
  8033ba:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8033be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033c2:	8b 40 04             	mov    0x4(%rax),%eax
  8033c5:	8d 50 01             	lea    0x1(%rax),%edx
  8033c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033cc:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8033cf:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8033d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033d8:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8033dc:	0f 82 64 ff ff ff    	jb     803346 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8033e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8033e6:	c9                   	leaveq 
  8033e7:	c3                   	retq   

00000000008033e8 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8033e8:	55                   	push   %rbp
  8033e9:	48 89 e5             	mov    %rsp,%rbp
  8033ec:	48 83 ec 20          	sub    $0x20,%rsp
  8033f0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8033f4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8033f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033fc:	48 89 c7             	mov    %rax,%rdi
  8033ff:	48 b8 e9 1d 80 00 00 	movabs $0x801de9,%rax
  803406:	00 00 00 
  803409:	ff d0                	callq  *%rax
  80340b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80340f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803413:	48 be e2 40 80 00 00 	movabs $0x8040e2,%rsi
  80341a:	00 00 00 
  80341d:	48 89 c7             	mov    %rax,%rdi
  803420:	48 b8 45 0f 80 00 00 	movabs $0x800f45,%rax
  803427:	00 00 00 
  80342a:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80342c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803430:	8b 50 04             	mov    0x4(%rax),%edx
  803433:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803437:	8b 00                	mov    (%rax),%eax
  803439:	29 c2                	sub    %eax,%edx
  80343b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80343f:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803445:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803449:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803450:	00 00 00 
	stat->st_dev = &devpipe;
  803453:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803457:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  80345e:	00 00 00 
  803461:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803468:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80346d:	c9                   	leaveq 
  80346e:	c3                   	retq   

000000000080346f <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80346f:	55                   	push   %rbp
  803470:	48 89 e5             	mov    %rsp,%rbp
  803473:	48 83 ec 10          	sub    $0x10,%rsp
  803477:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80347b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80347f:	48 89 c6             	mov    %rax,%rsi
  803482:	bf 00 00 00 00       	mov    $0x0,%edi
  803487:	48 b8 1f 19 80 00 00 	movabs $0x80191f,%rax
  80348e:	00 00 00 
  803491:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803493:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803497:	48 89 c7             	mov    %rax,%rdi
  80349a:	48 b8 e9 1d 80 00 00 	movabs $0x801de9,%rax
  8034a1:	00 00 00 
  8034a4:	ff d0                	callq  *%rax
  8034a6:	48 89 c6             	mov    %rax,%rsi
  8034a9:	bf 00 00 00 00       	mov    $0x0,%edi
  8034ae:	48 b8 1f 19 80 00 00 	movabs $0x80191f,%rax
  8034b5:	00 00 00 
  8034b8:	ff d0                	callq  *%rax
}
  8034ba:	c9                   	leaveq 
  8034bb:	c3                   	retq   

00000000008034bc <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8034bc:	55                   	push   %rbp
  8034bd:	48 89 e5             	mov    %rsp,%rbp
  8034c0:	48 83 ec 20          	sub    $0x20,%rsp
  8034c4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8034c7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034ca:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8034cd:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8034d1:	be 01 00 00 00       	mov    $0x1,%esi
  8034d6:	48 89 c7             	mov    %rax,%rdi
  8034d9:	48 b8 2c 17 80 00 00 	movabs $0x80172c,%rax
  8034e0:	00 00 00 
  8034e3:	ff d0                	callq  *%rax
}
  8034e5:	c9                   	leaveq 
  8034e6:	c3                   	retq   

00000000008034e7 <getchar>:

int
getchar(void)
{
  8034e7:	55                   	push   %rbp
  8034e8:	48 89 e5             	mov    %rsp,%rbp
  8034eb:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8034ef:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8034f3:	ba 01 00 00 00       	mov    $0x1,%edx
  8034f8:	48 89 c6             	mov    %rax,%rsi
  8034fb:	bf 00 00 00 00       	mov    $0x0,%edi
  803500:	48 b8 de 22 80 00 00 	movabs $0x8022de,%rax
  803507:	00 00 00 
  80350a:	ff d0                	callq  *%rax
  80350c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80350f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803513:	79 05                	jns    80351a <getchar+0x33>
		return r;
  803515:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803518:	eb 14                	jmp    80352e <getchar+0x47>
	if (r < 1)
  80351a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80351e:	7f 07                	jg     803527 <getchar+0x40>
		return -E_EOF;
  803520:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803525:	eb 07                	jmp    80352e <getchar+0x47>
	return c;
  803527:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80352b:	0f b6 c0             	movzbl %al,%eax
}
  80352e:	c9                   	leaveq 
  80352f:	c3                   	retq   

0000000000803530 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803530:	55                   	push   %rbp
  803531:	48 89 e5             	mov    %rsp,%rbp
  803534:	48 83 ec 20          	sub    $0x20,%rsp
  803538:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80353b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80353f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803542:	48 89 d6             	mov    %rdx,%rsi
  803545:	89 c7                	mov    %eax,%edi
  803547:	48 b8 ac 1e 80 00 00 	movabs $0x801eac,%rax
  80354e:	00 00 00 
  803551:	ff d0                	callq  *%rax
  803553:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803556:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80355a:	79 05                	jns    803561 <iscons+0x31>
		return r;
  80355c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80355f:	eb 1a                	jmp    80357b <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803561:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803565:	8b 10                	mov    (%rax),%edx
  803567:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  80356e:	00 00 00 
  803571:	8b 00                	mov    (%rax),%eax
  803573:	39 c2                	cmp    %eax,%edx
  803575:	0f 94 c0             	sete   %al
  803578:	0f b6 c0             	movzbl %al,%eax
}
  80357b:	c9                   	leaveq 
  80357c:	c3                   	retq   

000000000080357d <opencons>:

int
opencons(void)
{
  80357d:	55                   	push   %rbp
  80357e:	48 89 e5             	mov    %rsp,%rbp
  803581:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803585:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803589:	48 89 c7             	mov    %rax,%rdi
  80358c:	48 b8 14 1e 80 00 00 	movabs $0x801e14,%rax
  803593:	00 00 00 
  803596:	ff d0                	callq  *%rax
  803598:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80359b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80359f:	79 05                	jns    8035a6 <opencons+0x29>
		return r;
  8035a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035a4:	eb 5b                	jmp    803601 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8035a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035aa:	ba 07 04 00 00       	mov    $0x407,%edx
  8035af:	48 89 c6             	mov    %rax,%rsi
  8035b2:	bf 00 00 00 00       	mov    $0x0,%edi
  8035b7:	48 b8 74 18 80 00 00 	movabs $0x801874,%rax
  8035be:	00 00 00 
  8035c1:	ff d0                	callq  *%rax
  8035c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035ca:	79 05                	jns    8035d1 <opencons+0x54>
		return r;
  8035cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035cf:	eb 30                	jmp    803601 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8035d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035d5:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  8035dc:	00 00 00 
  8035df:	8b 12                	mov    (%rdx),%edx
  8035e1:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8035e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035e7:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8035ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035f2:	48 89 c7             	mov    %rax,%rdi
  8035f5:	48 b8 c6 1d 80 00 00 	movabs $0x801dc6,%rax
  8035fc:	00 00 00 
  8035ff:	ff d0                	callq  *%rax
}
  803601:	c9                   	leaveq 
  803602:	c3                   	retq   

0000000000803603 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803603:	55                   	push   %rbp
  803604:	48 89 e5             	mov    %rsp,%rbp
  803607:	48 83 ec 30          	sub    $0x30,%rsp
  80360b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80360f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803613:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803617:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80361c:	75 07                	jne    803625 <devcons_read+0x22>
		return 0;
  80361e:	b8 00 00 00 00       	mov    $0x0,%eax
  803623:	eb 4b                	jmp    803670 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803625:	eb 0c                	jmp    803633 <devcons_read+0x30>
		sys_yield();
  803627:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  80362e:	00 00 00 
  803631:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803633:	48 b8 76 17 80 00 00 	movabs $0x801776,%rax
  80363a:	00 00 00 
  80363d:	ff d0                	callq  *%rax
  80363f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803642:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803646:	74 df                	je     803627 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803648:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80364c:	79 05                	jns    803653 <devcons_read+0x50>
		return c;
  80364e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803651:	eb 1d                	jmp    803670 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803653:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803657:	75 07                	jne    803660 <devcons_read+0x5d>
		return 0;
  803659:	b8 00 00 00 00       	mov    $0x0,%eax
  80365e:	eb 10                	jmp    803670 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803660:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803663:	89 c2                	mov    %eax,%edx
  803665:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803669:	88 10                	mov    %dl,(%rax)
	return 1;
  80366b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803670:	c9                   	leaveq 
  803671:	c3                   	retq   

0000000000803672 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803672:	55                   	push   %rbp
  803673:	48 89 e5             	mov    %rsp,%rbp
  803676:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80367d:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803684:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80368b:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803692:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803699:	eb 76                	jmp    803711 <devcons_write+0x9f>
		m = n - tot;
  80369b:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8036a2:	89 c2                	mov    %eax,%edx
  8036a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036a7:	29 c2                	sub    %eax,%edx
  8036a9:	89 d0                	mov    %edx,%eax
  8036ab:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8036ae:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036b1:	83 f8 7f             	cmp    $0x7f,%eax
  8036b4:	76 07                	jbe    8036bd <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8036b6:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8036bd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036c0:	48 63 d0             	movslq %eax,%rdx
  8036c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036c6:	48 63 c8             	movslq %eax,%rcx
  8036c9:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8036d0:	48 01 c1             	add    %rax,%rcx
  8036d3:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8036da:	48 89 ce             	mov    %rcx,%rsi
  8036dd:	48 89 c7             	mov    %rax,%rdi
  8036e0:	48 b8 69 12 80 00 00 	movabs $0x801269,%rax
  8036e7:	00 00 00 
  8036ea:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8036ec:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036ef:	48 63 d0             	movslq %eax,%rdx
  8036f2:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8036f9:	48 89 d6             	mov    %rdx,%rsi
  8036fc:	48 89 c7             	mov    %rax,%rdi
  8036ff:	48 b8 2c 17 80 00 00 	movabs $0x80172c,%rax
  803706:	00 00 00 
  803709:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80370b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80370e:	01 45 fc             	add    %eax,-0x4(%rbp)
  803711:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803714:	48 98                	cltq   
  803716:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80371d:	0f 82 78 ff ff ff    	jb     80369b <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803723:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803726:	c9                   	leaveq 
  803727:	c3                   	retq   

0000000000803728 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803728:	55                   	push   %rbp
  803729:	48 89 e5             	mov    %rsp,%rbp
  80372c:	48 83 ec 08          	sub    $0x8,%rsp
  803730:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803734:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803739:	c9                   	leaveq 
  80373a:	c3                   	retq   

000000000080373b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80373b:	55                   	push   %rbp
  80373c:	48 89 e5             	mov    %rsp,%rbp
  80373f:	48 83 ec 10          	sub    $0x10,%rsp
  803743:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803747:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80374b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80374f:	48 be ee 40 80 00 00 	movabs $0x8040ee,%rsi
  803756:	00 00 00 
  803759:	48 89 c7             	mov    %rax,%rdi
  80375c:	48 b8 45 0f 80 00 00 	movabs $0x800f45,%rax
  803763:	00 00 00 
  803766:	ff d0                	callq  *%rax
	return 0;
  803768:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80376d:	c9                   	leaveq 
  80376e:	c3                   	retq   

000000000080376f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80376f:	55                   	push   %rbp
  803770:	48 89 e5             	mov    %rsp,%rbp
  803773:	53                   	push   %rbx
  803774:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80377b:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803782:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803788:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80378f:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803796:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80379d:	84 c0                	test   %al,%al
  80379f:	74 23                	je     8037c4 <_panic+0x55>
  8037a1:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8037a8:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8037ac:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8037b0:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8037b4:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8037b8:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8037bc:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8037c0:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8037c4:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8037cb:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8037d2:	00 00 00 
  8037d5:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8037dc:	00 00 00 
  8037df:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8037e3:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8037ea:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8037f1:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8037f8:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8037ff:	00 00 00 
  803802:	48 8b 18             	mov    (%rax),%rbx
  803805:	48 b8 f8 17 80 00 00 	movabs $0x8017f8,%rax
  80380c:	00 00 00 
  80380f:	ff d0                	callq  *%rax
  803811:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803817:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80381e:	41 89 c8             	mov    %ecx,%r8d
  803821:	48 89 d1             	mov    %rdx,%rcx
  803824:	48 89 da             	mov    %rbx,%rdx
  803827:	89 c6                	mov    %eax,%esi
  803829:	48 bf f8 40 80 00 00 	movabs $0x8040f8,%rdi
  803830:	00 00 00 
  803833:	b8 00 00 00 00       	mov    $0x0,%eax
  803838:	49 b9 90 03 80 00 00 	movabs $0x800390,%r9
  80383f:	00 00 00 
  803842:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803845:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80384c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803853:	48 89 d6             	mov    %rdx,%rsi
  803856:	48 89 c7             	mov    %rax,%rdi
  803859:	48 b8 e4 02 80 00 00 	movabs $0x8002e4,%rax
  803860:	00 00 00 
  803863:	ff d0                	callq  *%rax
	cprintf("\n");
  803865:	48 bf 1b 41 80 00 00 	movabs $0x80411b,%rdi
  80386c:	00 00 00 
  80386f:	b8 00 00 00 00       	mov    $0x0,%eax
  803874:	48 ba 90 03 80 00 00 	movabs $0x800390,%rdx
  80387b:	00 00 00 
  80387e:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803880:	cc                   	int3   
  803881:	eb fd                	jmp    803880 <_panic+0x111>

0000000000803883 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803883:	55                   	push   %rbp
  803884:	48 89 e5             	mov    %rsp,%rbp
  803887:	48 83 ec 30          	sub    $0x30,%rsp
  80388b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80388f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803893:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803897:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80389e:	00 00 00 
  8038a1:	48 8b 00             	mov    (%rax),%rax
  8038a4:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8038aa:	85 c0                	test   %eax,%eax
  8038ac:	75 3c                	jne    8038ea <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  8038ae:	48 b8 f8 17 80 00 00 	movabs $0x8017f8,%rax
  8038b5:	00 00 00 
  8038b8:	ff d0                	callq  *%rax
  8038ba:	25 ff 03 00 00       	and    $0x3ff,%eax
  8038bf:	48 63 d0             	movslq %eax,%rdx
  8038c2:	48 89 d0             	mov    %rdx,%rax
  8038c5:	48 c1 e0 03          	shl    $0x3,%rax
  8038c9:	48 01 d0             	add    %rdx,%rax
  8038cc:	48 c1 e0 05          	shl    $0x5,%rax
  8038d0:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8038d7:	00 00 00 
  8038da:	48 01 c2             	add    %rax,%rdx
  8038dd:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8038e4:	00 00 00 
  8038e7:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  8038ea:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8038ef:	75 0e                	jne    8038ff <ipc_recv+0x7c>
		pg = (void*) UTOP;
  8038f1:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8038f8:	00 00 00 
  8038fb:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  8038ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803903:	48 89 c7             	mov    %rax,%rdi
  803906:	48 b8 9d 1a 80 00 00 	movabs $0x801a9d,%rax
  80390d:	00 00 00 
  803910:	ff d0                	callq  *%rax
  803912:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803915:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803919:	79 19                	jns    803934 <ipc_recv+0xb1>
		*from_env_store = 0;
  80391b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80391f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803925:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803929:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  80392f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803932:	eb 53                	jmp    803987 <ipc_recv+0x104>
	}
	if(from_env_store)
  803934:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803939:	74 19                	je     803954 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  80393b:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803942:	00 00 00 
  803945:	48 8b 00             	mov    (%rax),%rax
  803948:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80394e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803952:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803954:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803959:	74 19                	je     803974 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  80395b:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803962:	00 00 00 
  803965:	48 8b 00             	mov    (%rax),%rax
  803968:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80396e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803972:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803974:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80397b:	00 00 00 
  80397e:	48 8b 00             	mov    (%rax),%rax
  803981:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803987:	c9                   	leaveq 
  803988:	c3                   	retq   

0000000000803989 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803989:	55                   	push   %rbp
  80398a:	48 89 e5             	mov    %rsp,%rbp
  80398d:	48 83 ec 30          	sub    $0x30,%rsp
  803991:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803994:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803997:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80399b:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  80399e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8039a3:	75 0e                	jne    8039b3 <ipc_send+0x2a>
		pg = (void*)UTOP;
  8039a5:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8039ac:	00 00 00 
  8039af:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  8039b3:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8039b6:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8039b9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8039bd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039c0:	89 c7                	mov    %eax,%edi
  8039c2:	48 b8 48 1a 80 00 00 	movabs $0x801a48,%rax
  8039c9:	00 00 00 
  8039cc:	ff d0                	callq  *%rax
  8039ce:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  8039d1:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8039d5:	75 0c                	jne    8039e3 <ipc_send+0x5a>
			sys_yield();
  8039d7:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  8039de:	00 00 00 
  8039e1:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  8039e3:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8039e7:	74 ca                	je     8039b3 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  8039e9:	c9                   	leaveq 
  8039ea:	c3                   	retq   

00000000008039eb <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8039eb:	55                   	push   %rbp
  8039ec:	48 89 e5             	mov    %rsp,%rbp
  8039ef:	48 83 ec 14          	sub    $0x14,%rsp
  8039f3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  8039f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8039fd:	eb 5e                	jmp    803a5d <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8039ff:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803a06:	00 00 00 
  803a09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a0c:	48 63 d0             	movslq %eax,%rdx
  803a0f:	48 89 d0             	mov    %rdx,%rax
  803a12:	48 c1 e0 03          	shl    $0x3,%rax
  803a16:	48 01 d0             	add    %rdx,%rax
  803a19:	48 c1 e0 05          	shl    $0x5,%rax
  803a1d:	48 01 c8             	add    %rcx,%rax
  803a20:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803a26:	8b 00                	mov    (%rax),%eax
  803a28:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803a2b:	75 2c                	jne    803a59 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803a2d:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803a34:	00 00 00 
  803a37:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a3a:	48 63 d0             	movslq %eax,%rdx
  803a3d:	48 89 d0             	mov    %rdx,%rax
  803a40:	48 c1 e0 03          	shl    $0x3,%rax
  803a44:	48 01 d0             	add    %rdx,%rax
  803a47:	48 c1 e0 05          	shl    $0x5,%rax
  803a4b:	48 01 c8             	add    %rcx,%rax
  803a4e:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803a54:	8b 40 08             	mov    0x8(%rax),%eax
  803a57:	eb 12                	jmp    803a6b <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803a59:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803a5d:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803a64:	7e 99                	jle    8039ff <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803a66:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a6b:	c9                   	leaveq 
  803a6c:	c3                   	retq   

0000000000803a6d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803a6d:	55                   	push   %rbp
  803a6e:	48 89 e5             	mov    %rsp,%rbp
  803a71:	48 83 ec 18          	sub    $0x18,%rsp
  803a75:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803a79:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a7d:	48 c1 e8 15          	shr    $0x15,%rax
  803a81:	48 89 c2             	mov    %rax,%rdx
  803a84:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803a8b:	01 00 00 
  803a8e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803a92:	83 e0 01             	and    $0x1,%eax
  803a95:	48 85 c0             	test   %rax,%rax
  803a98:	75 07                	jne    803aa1 <pageref+0x34>
		return 0;
  803a9a:	b8 00 00 00 00       	mov    $0x0,%eax
  803a9f:	eb 53                	jmp    803af4 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803aa1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803aa5:	48 c1 e8 0c          	shr    $0xc,%rax
  803aa9:	48 89 c2             	mov    %rax,%rdx
  803aac:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803ab3:	01 00 00 
  803ab6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803aba:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803abe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ac2:	83 e0 01             	and    $0x1,%eax
  803ac5:	48 85 c0             	test   %rax,%rax
  803ac8:	75 07                	jne    803ad1 <pageref+0x64>
		return 0;
  803aca:	b8 00 00 00 00       	mov    $0x0,%eax
  803acf:	eb 23                	jmp    803af4 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803ad1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ad5:	48 c1 e8 0c          	shr    $0xc,%rax
  803ad9:	48 89 c2             	mov    %rax,%rdx
  803adc:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803ae3:	00 00 00 
  803ae6:	48 c1 e2 04          	shl    $0x4,%rdx
  803aea:	48 01 d0             	add    %rdx,%rax
  803aed:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803af1:	0f b7 c0             	movzwl %ax,%eax
}
  803af4:	c9                   	leaveq 
  803af5:	c3                   	retq   
