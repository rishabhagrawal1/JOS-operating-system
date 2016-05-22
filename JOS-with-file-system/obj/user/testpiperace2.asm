
obj/user/testpiperace2.debug:     file format elf64-x86-64


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
  80003c:	e8 ea 02 00 00       	callq  80032b <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 40          	sub    $0x40,%rsp
  80004b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80004e:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	int p[2], r, i;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for pipeisclosed race...\n");
  800052:	48 bf 60 3e 80 00 00 	movabs $0x803e60,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 12 06 80 00 00 	movabs $0x800612,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	if ((r = pipe(p)) < 0)
  80006d:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  800071:	48 89 c7             	mov    %rax,%rdi
  800074:	48 b8 26 32 80 00 00 	movabs $0x803226,%rax
  80007b:	00 00 00 
  80007e:	ff d0                	callq  *%rax
  800080:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800083:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800087:	79 30                	jns    8000b9 <umain+0x76>
		panic("pipe: %e", r);
  800089:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80008c:	89 c1                	mov    %eax,%ecx
  80008e:	48 ba 82 3e 80 00 00 	movabs $0x803e82,%rdx
  800095:	00 00 00 
  800098:	be 0d 00 00 00       	mov    $0xd,%esi
  80009d:	48 bf 8b 3e 80 00 00 	movabs $0x803e8b,%rdi
  8000a4:	00 00 00 
  8000a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ac:	49 b8 d9 03 80 00 00 	movabs $0x8003d9,%r8
  8000b3:	00 00 00 
  8000b6:	41 ff d0             	callq  *%r8
	if ((r = fork()) < 0)
  8000b9:	48 b8 4c 21 80 00 00 	movabs $0x80214c,%rax
  8000c0:	00 00 00 
  8000c3:	ff d0                	callq  *%rax
  8000c5:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000c8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000cc:	79 30                	jns    8000fe <umain+0xbb>
		panic("fork: %e", r);
  8000ce:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d1:	89 c1                	mov    %eax,%ecx
  8000d3:	48 ba a0 3e 80 00 00 	movabs $0x803ea0,%rdx
  8000da:	00 00 00 
  8000dd:	be 0f 00 00 00       	mov    $0xf,%esi
  8000e2:	48 bf 8b 3e 80 00 00 	movabs $0x803e8b,%rdi
  8000e9:	00 00 00 
  8000ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f1:	49 b8 d9 03 80 00 00 	movabs $0x8003d9,%r8
  8000f8:	00 00 00 
  8000fb:	41 ff d0             	callq  *%r8
	if (r == 0) {
  8000fe:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800102:	0f 85 c0 00 00 00    	jne    8001c8 <umain+0x185>
		// child just dups and closes repeatedly,
		// yielding so the parent can see
		// the fd state between the two.
		close(p[1]);
  800108:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80010b:	89 c7                	mov    %eax,%edi
  80010d:	48 b8 f3 26 80 00 00 	movabs $0x8026f3,%rax
  800114:	00 00 00 
  800117:	ff d0                	callq  *%rax
		for (i = 0; i < 200; i++) {
  800119:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800120:	e9 8a 00 00 00       	jmpq   8001af <umain+0x16c>
			if (i % 10 == 0)
  800125:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  800128:	ba 67 66 66 66       	mov    $0x66666667,%edx
  80012d:	89 c8                	mov    %ecx,%eax
  80012f:	f7 ea                	imul   %edx
  800131:	c1 fa 02             	sar    $0x2,%edx
  800134:	89 c8                	mov    %ecx,%eax
  800136:	c1 f8 1f             	sar    $0x1f,%eax
  800139:	29 c2                	sub    %eax,%edx
  80013b:	89 d0                	mov    %edx,%eax
  80013d:	c1 e0 02             	shl    $0x2,%eax
  800140:	01 d0                	add    %edx,%eax
  800142:	01 c0                	add    %eax,%eax
  800144:	29 c1                	sub    %eax,%ecx
  800146:	89 ca                	mov    %ecx,%edx
  800148:	85 d2                	test   %edx,%edx
  80014a:	75 20                	jne    80016c <umain+0x129>
				cprintf("%d.", i);
  80014c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80014f:	89 c6                	mov    %eax,%esi
  800151:	48 bf a9 3e 80 00 00 	movabs $0x803ea9,%rdi
  800158:	00 00 00 
  80015b:	b8 00 00 00 00       	mov    $0x0,%eax
  800160:	48 ba 12 06 80 00 00 	movabs $0x800612,%rdx
  800167:	00 00 00 
  80016a:	ff d2                	callq  *%rdx
			// dup, then close.  yield so that other guy will
			// see us while we're between them.
			dup(p[0], 10);
  80016c:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80016f:	be 0a 00 00 00       	mov    $0xa,%esi
  800174:	89 c7                	mov    %eax,%edi
  800176:	48 b8 6c 27 80 00 00 	movabs $0x80276c,%rax
  80017d:	00 00 00 
  800180:	ff d0                	callq  *%rax
			sys_yield();
  800182:	48 b8 b8 1a 80 00 00 	movabs $0x801ab8,%rax
  800189:	00 00 00 
  80018c:	ff d0                	callq  *%rax
			close(10);
  80018e:	bf 0a 00 00 00       	mov    $0xa,%edi
  800193:	48 b8 f3 26 80 00 00 	movabs $0x8026f3,%rax
  80019a:	00 00 00 
  80019d:	ff d0                	callq  *%rax
			sys_yield();
  80019f:	48 b8 b8 1a 80 00 00 	movabs $0x801ab8,%rax
  8001a6:	00 00 00 
  8001a9:	ff d0                	callq  *%rax
	if (r == 0) {
		// child just dups and closes repeatedly,
		// yielding so the parent can see
		// the fd state between the two.
		close(p[1]);
		for (i = 0; i < 200; i++) {
  8001ab:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8001af:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%rbp)
  8001b6:	0f 8e 69 ff ff ff    	jle    800125 <umain+0xe2>
			dup(p[0], 10);
			sys_yield();
			close(10);
			sys_yield();
		}
		exit();
  8001bc:	48 b8 b6 03 80 00 00 	movabs $0x8003b6,%rax
  8001c3:	00 00 00 
  8001c6:	ff d0                	callq  *%rax
	// pageref(p[0]) and gets 3, then it will return true when
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
  8001c8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001cb:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001d0:	48 63 d0             	movslq %eax,%rdx
  8001d3:	48 89 d0             	mov    %rdx,%rax
  8001d6:	48 c1 e0 03          	shl    $0x3,%rax
  8001da:	48 01 d0             	add    %rdx,%rax
  8001dd:	48 c1 e0 05          	shl    $0x5,%rax
  8001e1:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8001e8:	00 00 00 
  8001eb:	48 01 d0             	add    %rdx,%rax
  8001ee:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	while (kid->env_status == ENV_RUNNABLE)
  8001f2:	eb 4d                	jmp    800241 <umain+0x1fe>
		if (pipeisclosed(p[0]) != 0) {
  8001f4:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8001f7:	89 c7                	mov    %eax,%edi
  8001f9:	48 b8 ef 34 80 00 00 	movabs $0x8034ef,%rax
  800200:	00 00 00 
  800203:	ff d0                	callq  *%rax
  800205:	85 c0                	test   %eax,%eax
  800207:	74 38                	je     800241 <umain+0x1fe>
			cprintf("\nRACE: pipe appears closed\n");
  800209:	48 bf ad 3e 80 00 00 	movabs $0x803ead,%rdi
  800210:	00 00 00 
  800213:	b8 00 00 00 00       	mov    $0x0,%eax
  800218:	48 ba 12 06 80 00 00 	movabs $0x800612,%rdx
  80021f:	00 00 00 
  800222:	ff d2                	callq  *%rdx
			sys_env_destroy(r);
  800224:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800227:	89 c7                	mov    %eax,%edi
  800229:	48 b8 36 1a 80 00 00 	movabs $0x801a36,%rax
  800230:	00 00 00 
  800233:	ff d0                	callq  *%rax
			exit();
  800235:	48 b8 b6 03 80 00 00 	movabs $0x8003b6,%rax
  80023c:	00 00 00 
  80023f:	ff d0                	callq  *%rax
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
	while (kid->env_status == ENV_RUNNABLE)
  800241:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800245:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  80024b:	83 f8 02             	cmp    $0x2,%eax
  80024e:	74 a4                	je     8001f4 <umain+0x1b1>
		if (pipeisclosed(p[0]) != 0) {
			cprintf("\nRACE: pipe appears closed\n");
			sys_env_destroy(r);
			exit();
		}
	cprintf("child done with loop\n");
  800250:	48 bf c9 3e 80 00 00 	movabs $0x803ec9,%rdi
  800257:	00 00 00 
  80025a:	b8 00 00 00 00       	mov    $0x0,%eax
  80025f:	48 ba 12 06 80 00 00 	movabs $0x800612,%rdx
  800266:	00 00 00 
  800269:	ff d2                	callq  *%rdx
	if (pipeisclosed(p[0]))
  80026b:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80026e:	89 c7                	mov    %eax,%edi
  800270:	48 b8 ef 34 80 00 00 	movabs $0x8034ef,%rax
  800277:	00 00 00 
  80027a:	ff d0                	callq  *%rax
  80027c:	85 c0                	test   %eax,%eax
  80027e:	74 2a                	je     8002aa <umain+0x267>
		panic("somehow the other end of p[0] got closed!");
  800280:	48 ba e0 3e 80 00 00 	movabs $0x803ee0,%rdx
  800287:	00 00 00 
  80028a:	be 40 00 00 00       	mov    $0x40,%esi
  80028f:	48 bf 8b 3e 80 00 00 	movabs $0x803e8b,%rdi
  800296:	00 00 00 
  800299:	b8 00 00 00 00       	mov    $0x0,%eax
  80029e:	48 b9 d9 03 80 00 00 	movabs $0x8003d9,%rcx
  8002a5:	00 00 00 
  8002a8:	ff d1                	callq  *%rcx
	if ((r = fd_lookup(p[0], &fd)) < 0)
  8002aa:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8002ad:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8002b1:	48 89 d6             	mov    %rdx,%rsi
  8002b4:	89 c7                	mov    %eax,%edi
  8002b6:	48 b8 e3 24 80 00 00 	movabs $0x8024e3,%rax
  8002bd:	00 00 00 
  8002c0:	ff d0                	callq  *%rax
  8002c2:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8002c5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8002c9:	79 30                	jns    8002fb <umain+0x2b8>
		panic("cannot look up p[0]: %e", r);
  8002cb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002ce:	89 c1                	mov    %eax,%ecx
  8002d0:	48 ba 0a 3f 80 00 00 	movabs $0x803f0a,%rdx
  8002d7:	00 00 00 
  8002da:	be 42 00 00 00       	mov    $0x42,%esi
  8002df:	48 bf 8b 3e 80 00 00 	movabs $0x803e8b,%rdi
  8002e6:	00 00 00 
  8002e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8002ee:	49 b8 d9 03 80 00 00 	movabs $0x8003d9,%r8
  8002f5:	00 00 00 
  8002f8:	41 ff d0             	callq  *%r8
	(void) fd2data(fd);
  8002fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8002ff:	48 89 c7             	mov    %rax,%rdi
  800302:	48 b8 20 24 80 00 00 	movabs $0x802420,%rax
  800309:	00 00 00 
  80030c:	ff d0                	callq  *%rax
	cprintf("race didn't happen\n");
  80030e:	48 bf 22 3f 80 00 00 	movabs $0x803f22,%rdi
  800315:	00 00 00 
  800318:	b8 00 00 00 00       	mov    $0x0,%eax
  80031d:	48 ba 12 06 80 00 00 	movabs $0x800612,%rdx
  800324:	00 00 00 
  800327:	ff d2                	callq  *%rdx
}
  800329:	c9                   	leaveq 
  80032a:	c3                   	retq   

000000000080032b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80032b:	55                   	push   %rbp
  80032c:	48 89 e5             	mov    %rsp,%rbp
  80032f:	48 83 ec 10          	sub    $0x10,%rsp
  800333:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800336:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80033a:	48 b8 7a 1a 80 00 00 	movabs $0x801a7a,%rax
  800341:	00 00 00 
  800344:	ff d0                	callq  *%rax
  800346:	25 ff 03 00 00       	and    $0x3ff,%eax
  80034b:	48 63 d0             	movslq %eax,%rdx
  80034e:	48 89 d0             	mov    %rdx,%rax
  800351:	48 c1 e0 03          	shl    $0x3,%rax
  800355:	48 01 d0             	add    %rdx,%rax
  800358:	48 c1 e0 05          	shl    $0x5,%rax
  80035c:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800363:	00 00 00 
  800366:	48 01 c2             	add    %rax,%rdx
  800369:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800370:	00 00 00 
  800373:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800376:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80037a:	7e 14                	jle    800390 <libmain+0x65>
		binaryname = argv[0];
  80037c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800380:	48 8b 10             	mov    (%rax),%rdx
  800383:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80038a:	00 00 00 
  80038d:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800390:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800394:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800397:	48 89 d6             	mov    %rdx,%rsi
  80039a:	89 c7                	mov    %eax,%edi
  80039c:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8003a3:	00 00 00 
  8003a6:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8003a8:	48 b8 b6 03 80 00 00 	movabs $0x8003b6,%rax
  8003af:	00 00 00 
  8003b2:	ff d0                	callq  *%rax
}
  8003b4:	c9                   	leaveq 
  8003b5:	c3                   	retq   

00000000008003b6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003b6:	55                   	push   %rbp
  8003b7:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8003ba:	48 b8 3e 27 80 00 00 	movabs $0x80273e,%rax
  8003c1:	00 00 00 
  8003c4:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8003c6:	bf 00 00 00 00       	mov    $0x0,%edi
  8003cb:	48 b8 36 1a 80 00 00 	movabs $0x801a36,%rax
  8003d2:	00 00 00 
  8003d5:	ff d0                	callq  *%rax

}
  8003d7:	5d                   	pop    %rbp
  8003d8:	c3                   	retq   

00000000008003d9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003d9:	55                   	push   %rbp
  8003da:	48 89 e5             	mov    %rsp,%rbp
  8003dd:	53                   	push   %rbx
  8003de:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8003e5:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8003ec:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8003f2:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8003f9:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800400:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800407:	84 c0                	test   %al,%al
  800409:	74 23                	je     80042e <_panic+0x55>
  80040b:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800412:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800416:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80041a:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80041e:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800422:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800426:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80042a:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80042e:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800435:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80043c:	00 00 00 
  80043f:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800446:	00 00 00 
  800449:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80044d:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800454:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80045b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800462:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800469:	00 00 00 
  80046c:	48 8b 18             	mov    (%rax),%rbx
  80046f:	48 b8 7a 1a 80 00 00 	movabs $0x801a7a,%rax
  800476:	00 00 00 
  800479:	ff d0                	callq  *%rax
  80047b:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800481:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800488:	41 89 c8             	mov    %ecx,%r8d
  80048b:	48 89 d1             	mov    %rdx,%rcx
  80048e:	48 89 da             	mov    %rbx,%rdx
  800491:	89 c6                	mov    %eax,%esi
  800493:	48 bf 40 3f 80 00 00 	movabs $0x803f40,%rdi
  80049a:	00 00 00 
  80049d:	b8 00 00 00 00       	mov    $0x0,%eax
  8004a2:	49 b9 12 06 80 00 00 	movabs $0x800612,%r9
  8004a9:	00 00 00 
  8004ac:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8004af:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8004b6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8004bd:	48 89 d6             	mov    %rdx,%rsi
  8004c0:	48 89 c7             	mov    %rax,%rdi
  8004c3:	48 b8 66 05 80 00 00 	movabs $0x800566,%rax
  8004ca:	00 00 00 
  8004cd:	ff d0                	callq  *%rax
	cprintf("\n");
  8004cf:	48 bf 63 3f 80 00 00 	movabs $0x803f63,%rdi
  8004d6:	00 00 00 
  8004d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8004de:	48 ba 12 06 80 00 00 	movabs $0x800612,%rdx
  8004e5:	00 00 00 
  8004e8:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8004ea:	cc                   	int3   
  8004eb:	eb fd                	jmp    8004ea <_panic+0x111>

00000000008004ed <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8004ed:	55                   	push   %rbp
  8004ee:	48 89 e5             	mov    %rsp,%rbp
  8004f1:	48 83 ec 10          	sub    $0x10,%rsp
  8004f5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004f8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  8004fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800500:	8b 00                	mov    (%rax),%eax
  800502:	8d 48 01             	lea    0x1(%rax),%ecx
  800505:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800509:	89 0a                	mov    %ecx,(%rdx)
  80050b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80050e:	89 d1                	mov    %edx,%ecx
  800510:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800514:	48 98                	cltq   
  800516:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  80051a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80051e:	8b 00                	mov    (%rax),%eax
  800520:	3d ff 00 00 00       	cmp    $0xff,%eax
  800525:	75 2c                	jne    800553 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  800527:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80052b:	8b 00                	mov    (%rax),%eax
  80052d:	48 98                	cltq   
  80052f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800533:	48 83 c2 08          	add    $0x8,%rdx
  800537:	48 89 c6             	mov    %rax,%rsi
  80053a:	48 89 d7             	mov    %rdx,%rdi
  80053d:	48 b8 ae 19 80 00 00 	movabs $0x8019ae,%rax
  800544:	00 00 00 
  800547:	ff d0                	callq  *%rax
		b->idx = 0;
  800549:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80054d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800553:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800557:	8b 40 04             	mov    0x4(%rax),%eax
  80055a:	8d 50 01             	lea    0x1(%rax),%edx
  80055d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800561:	89 50 04             	mov    %edx,0x4(%rax)
}
  800564:	c9                   	leaveq 
  800565:	c3                   	retq   

0000000000800566 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800566:	55                   	push   %rbp
  800567:	48 89 e5             	mov    %rsp,%rbp
  80056a:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800571:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800578:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  80057f:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800586:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80058d:	48 8b 0a             	mov    (%rdx),%rcx
  800590:	48 89 08             	mov    %rcx,(%rax)
  800593:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800597:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80059b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80059f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8005a3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8005aa:	00 00 00 
	b.cnt = 0;
  8005ad:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8005b4:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8005b7:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8005be:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8005c5:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8005cc:	48 89 c6             	mov    %rax,%rsi
  8005cf:	48 bf ed 04 80 00 00 	movabs $0x8004ed,%rdi
  8005d6:	00 00 00 
  8005d9:	48 b8 c5 09 80 00 00 	movabs $0x8009c5,%rax
  8005e0:	00 00 00 
  8005e3:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  8005e5:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8005eb:	48 98                	cltq   
  8005ed:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8005f4:	48 83 c2 08          	add    $0x8,%rdx
  8005f8:	48 89 c6             	mov    %rax,%rsi
  8005fb:	48 89 d7             	mov    %rdx,%rdi
  8005fe:	48 b8 ae 19 80 00 00 	movabs $0x8019ae,%rax
  800605:	00 00 00 
  800608:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  80060a:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800610:	c9                   	leaveq 
  800611:	c3                   	retq   

0000000000800612 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800612:	55                   	push   %rbp
  800613:	48 89 e5             	mov    %rsp,%rbp
  800616:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80061d:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800624:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80062b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800632:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800639:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800640:	84 c0                	test   %al,%al
  800642:	74 20                	je     800664 <cprintf+0x52>
  800644:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800648:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80064c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800650:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800654:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800658:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80065c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800660:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800664:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  80066b:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800672:	00 00 00 
  800675:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80067c:	00 00 00 
  80067f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800683:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80068a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800691:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800698:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80069f:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8006a6:	48 8b 0a             	mov    (%rdx),%rcx
  8006a9:	48 89 08             	mov    %rcx,(%rax)
  8006ac:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006b0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006b4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006b8:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8006bc:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8006c3:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8006ca:	48 89 d6             	mov    %rdx,%rsi
  8006cd:	48 89 c7             	mov    %rax,%rdi
  8006d0:	48 b8 66 05 80 00 00 	movabs $0x800566,%rax
  8006d7:	00 00 00 
  8006da:	ff d0                	callq  *%rax
  8006dc:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  8006e2:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8006e8:	c9                   	leaveq 
  8006e9:	c3                   	retq   

00000000008006ea <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006ea:	55                   	push   %rbp
  8006eb:	48 89 e5             	mov    %rsp,%rbp
  8006ee:	53                   	push   %rbx
  8006ef:	48 83 ec 38          	sub    $0x38,%rsp
  8006f3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006f7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8006fb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8006ff:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800702:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800706:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80070a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80070d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800711:	77 3b                	ja     80074e <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800713:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800716:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80071a:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80071d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800721:	ba 00 00 00 00       	mov    $0x0,%edx
  800726:	48 f7 f3             	div    %rbx
  800729:	48 89 c2             	mov    %rax,%rdx
  80072c:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80072f:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800732:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800736:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073a:	41 89 f9             	mov    %edi,%r9d
  80073d:	48 89 c7             	mov    %rax,%rdi
  800740:	48 b8 ea 06 80 00 00 	movabs $0x8006ea,%rax
  800747:	00 00 00 
  80074a:	ff d0                	callq  *%rax
  80074c:	eb 1e                	jmp    80076c <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80074e:	eb 12                	jmp    800762 <printnum+0x78>
			putch(padc, putdat);
  800750:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800754:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800757:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80075b:	48 89 ce             	mov    %rcx,%rsi
  80075e:	89 d7                	mov    %edx,%edi
  800760:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800762:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800766:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80076a:	7f e4                	jg     800750 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80076c:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80076f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800773:	ba 00 00 00 00       	mov    $0x0,%edx
  800778:	48 f7 f1             	div    %rcx
  80077b:	48 89 d0             	mov    %rdx,%rax
  80077e:	48 ba 48 41 80 00 00 	movabs $0x804148,%rdx
  800785:	00 00 00 
  800788:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80078c:	0f be d0             	movsbl %al,%edx
  80078f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800793:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800797:	48 89 ce             	mov    %rcx,%rsi
  80079a:	89 d7                	mov    %edx,%edi
  80079c:	ff d0                	callq  *%rax
}
  80079e:	48 83 c4 38          	add    $0x38,%rsp
  8007a2:	5b                   	pop    %rbx
  8007a3:	5d                   	pop    %rbp
  8007a4:	c3                   	retq   

00000000008007a5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007a5:	55                   	push   %rbp
  8007a6:	48 89 e5             	mov    %rsp,%rbp
  8007a9:	48 83 ec 1c          	sub    $0x1c,%rsp
  8007ad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007b1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8007b4:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007b8:	7e 52                	jle    80080c <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8007ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007be:	8b 00                	mov    (%rax),%eax
  8007c0:	83 f8 30             	cmp    $0x30,%eax
  8007c3:	73 24                	jae    8007e9 <getuint+0x44>
  8007c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d1:	8b 00                	mov    (%rax),%eax
  8007d3:	89 c0                	mov    %eax,%eax
  8007d5:	48 01 d0             	add    %rdx,%rax
  8007d8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007dc:	8b 12                	mov    (%rdx),%edx
  8007de:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007e1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e5:	89 0a                	mov    %ecx,(%rdx)
  8007e7:	eb 17                	jmp    800800 <getuint+0x5b>
  8007e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ed:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007f1:	48 89 d0             	mov    %rdx,%rax
  8007f4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007f8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007fc:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800800:	48 8b 00             	mov    (%rax),%rax
  800803:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800807:	e9 a3 00 00 00       	jmpq   8008af <getuint+0x10a>
	else if (lflag)
  80080c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800810:	74 4f                	je     800861 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800812:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800816:	8b 00                	mov    (%rax),%eax
  800818:	83 f8 30             	cmp    $0x30,%eax
  80081b:	73 24                	jae    800841 <getuint+0x9c>
  80081d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800821:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800825:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800829:	8b 00                	mov    (%rax),%eax
  80082b:	89 c0                	mov    %eax,%eax
  80082d:	48 01 d0             	add    %rdx,%rax
  800830:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800834:	8b 12                	mov    (%rdx),%edx
  800836:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800839:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80083d:	89 0a                	mov    %ecx,(%rdx)
  80083f:	eb 17                	jmp    800858 <getuint+0xb3>
  800841:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800845:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800849:	48 89 d0             	mov    %rdx,%rax
  80084c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800850:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800854:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800858:	48 8b 00             	mov    (%rax),%rax
  80085b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80085f:	eb 4e                	jmp    8008af <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800861:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800865:	8b 00                	mov    (%rax),%eax
  800867:	83 f8 30             	cmp    $0x30,%eax
  80086a:	73 24                	jae    800890 <getuint+0xeb>
  80086c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800870:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800874:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800878:	8b 00                	mov    (%rax),%eax
  80087a:	89 c0                	mov    %eax,%eax
  80087c:	48 01 d0             	add    %rdx,%rax
  80087f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800883:	8b 12                	mov    (%rdx),%edx
  800885:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800888:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80088c:	89 0a                	mov    %ecx,(%rdx)
  80088e:	eb 17                	jmp    8008a7 <getuint+0x102>
  800890:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800894:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800898:	48 89 d0             	mov    %rdx,%rax
  80089b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80089f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008a3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008a7:	8b 00                	mov    (%rax),%eax
  8008a9:	89 c0                	mov    %eax,%eax
  8008ab:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008b3:	c9                   	leaveq 
  8008b4:	c3                   	retq   

00000000008008b5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008b5:	55                   	push   %rbp
  8008b6:	48 89 e5             	mov    %rsp,%rbp
  8008b9:	48 83 ec 1c          	sub    $0x1c,%rsp
  8008bd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008c1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8008c4:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008c8:	7e 52                	jle    80091c <getint+0x67>
		x=va_arg(*ap, long long);
  8008ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ce:	8b 00                	mov    (%rax),%eax
  8008d0:	83 f8 30             	cmp    $0x30,%eax
  8008d3:	73 24                	jae    8008f9 <getint+0x44>
  8008d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e1:	8b 00                	mov    (%rax),%eax
  8008e3:	89 c0                	mov    %eax,%eax
  8008e5:	48 01 d0             	add    %rdx,%rax
  8008e8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ec:	8b 12                	mov    (%rdx),%edx
  8008ee:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008f5:	89 0a                	mov    %ecx,(%rdx)
  8008f7:	eb 17                	jmp    800910 <getint+0x5b>
  8008f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008fd:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800901:	48 89 d0             	mov    %rdx,%rax
  800904:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800908:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80090c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800910:	48 8b 00             	mov    (%rax),%rax
  800913:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800917:	e9 a3 00 00 00       	jmpq   8009bf <getint+0x10a>
	else if (lflag)
  80091c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800920:	74 4f                	je     800971 <getint+0xbc>
		x=va_arg(*ap, long);
  800922:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800926:	8b 00                	mov    (%rax),%eax
  800928:	83 f8 30             	cmp    $0x30,%eax
  80092b:	73 24                	jae    800951 <getint+0x9c>
  80092d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800931:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800935:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800939:	8b 00                	mov    (%rax),%eax
  80093b:	89 c0                	mov    %eax,%eax
  80093d:	48 01 d0             	add    %rdx,%rax
  800940:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800944:	8b 12                	mov    (%rdx),%edx
  800946:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800949:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80094d:	89 0a                	mov    %ecx,(%rdx)
  80094f:	eb 17                	jmp    800968 <getint+0xb3>
  800951:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800955:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800959:	48 89 d0             	mov    %rdx,%rax
  80095c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800960:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800964:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800968:	48 8b 00             	mov    (%rax),%rax
  80096b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80096f:	eb 4e                	jmp    8009bf <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800971:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800975:	8b 00                	mov    (%rax),%eax
  800977:	83 f8 30             	cmp    $0x30,%eax
  80097a:	73 24                	jae    8009a0 <getint+0xeb>
  80097c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800980:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800984:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800988:	8b 00                	mov    (%rax),%eax
  80098a:	89 c0                	mov    %eax,%eax
  80098c:	48 01 d0             	add    %rdx,%rax
  80098f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800993:	8b 12                	mov    (%rdx),%edx
  800995:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800998:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80099c:	89 0a                	mov    %ecx,(%rdx)
  80099e:	eb 17                	jmp    8009b7 <getint+0x102>
  8009a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009a8:	48 89 d0             	mov    %rdx,%rax
  8009ab:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009af:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009b7:	8b 00                	mov    (%rax),%eax
  8009b9:	48 98                	cltq   
  8009bb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009c3:	c9                   	leaveq 
  8009c4:	c3                   	retq   

00000000008009c5 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009c5:	55                   	push   %rbp
  8009c6:	48 89 e5             	mov    %rsp,%rbp
  8009c9:	41 54                	push   %r12
  8009cb:	53                   	push   %rbx
  8009cc:	48 83 ec 60          	sub    $0x60,%rsp
  8009d0:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8009d4:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8009d8:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009dc:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8009e0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009e4:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8009e8:	48 8b 0a             	mov    (%rdx),%rcx
  8009eb:	48 89 08             	mov    %rcx,(%rax)
  8009ee:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8009f2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8009f6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8009fa:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009fe:	eb 17                	jmp    800a17 <vprintfmt+0x52>
			if (ch == '\0')
  800a00:	85 db                	test   %ebx,%ebx
  800a02:	0f 84 cc 04 00 00    	je     800ed4 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800a08:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a0c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a10:	48 89 d6             	mov    %rdx,%rsi
  800a13:	89 df                	mov    %ebx,%edi
  800a15:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a17:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a1b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a1f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a23:	0f b6 00             	movzbl (%rax),%eax
  800a26:	0f b6 d8             	movzbl %al,%ebx
  800a29:	83 fb 25             	cmp    $0x25,%ebx
  800a2c:	75 d2                	jne    800a00 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a2e:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800a32:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800a39:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800a40:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800a47:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a4e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a52:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a56:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a5a:	0f b6 00             	movzbl (%rax),%eax
  800a5d:	0f b6 d8             	movzbl %al,%ebx
  800a60:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800a63:	83 f8 55             	cmp    $0x55,%eax
  800a66:	0f 87 34 04 00 00    	ja     800ea0 <vprintfmt+0x4db>
  800a6c:	89 c0                	mov    %eax,%eax
  800a6e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800a75:	00 
  800a76:	48 b8 70 41 80 00 00 	movabs $0x804170,%rax
  800a7d:	00 00 00 
  800a80:	48 01 d0             	add    %rdx,%rax
  800a83:	48 8b 00             	mov    (%rax),%rax
  800a86:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a88:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800a8c:	eb c0                	jmp    800a4e <vprintfmt+0x89>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a8e:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800a92:	eb ba                	jmp    800a4e <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a94:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800a9b:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800a9e:	89 d0                	mov    %edx,%eax
  800aa0:	c1 e0 02             	shl    $0x2,%eax
  800aa3:	01 d0                	add    %edx,%eax
  800aa5:	01 c0                	add    %eax,%eax
  800aa7:	01 d8                	add    %ebx,%eax
  800aa9:	83 e8 30             	sub    $0x30,%eax
  800aac:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800aaf:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ab3:	0f b6 00             	movzbl (%rax),%eax
  800ab6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ab9:	83 fb 2f             	cmp    $0x2f,%ebx
  800abc:	7e 0c                	jle    800aca <vprintfmt+0x105>
  800abe:	83 fb 39             	cmp    $0x39,%ebx
  800ac1:	7f 07                	jg     800aca <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ac3:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ac8:	eb d1                	jmp    800a9b <vprintfmt+0xd6>
			goto process_precision;
  800aca:	eb 58                	jmp    800b24 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800acc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800acf:	83 f8 30             	cmp    $0x30,%eax
  800ad2:	73 17                	jae    800aeb <vprintfmt+0x126>
  800ad4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ad8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800adb:	89 c0                	mov    %eax,%eax
  800add:	48 01 d0             	add    %rdx,%rax
  800ae0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ae3:	83 c2 08             	add    $0x8,%edx
  800ae6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ae9:	eb 0f                	jmp    800afa <vprintfmt+0x135>
  800aeb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aef:	48 89 d0             	mov    %rdx,%rax
  800af2:	48 83 c2 08          	add    $0x8,%rdx
  800af6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800afa:	8b 00                	mov    (%rax),%eax
  800afc:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800aff:	eb 23                	jmp    800b24 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800b01:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b05:	79 0c                	jns    800b13 <vprintfmt+0x14e>
				width = 0;
  800b07:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800b0e:	e9 3b ff ff ff       	jmpq   800a4e <vprintfmt+0x89>
  800b13:	e9 36 ff ff ff       	jmpq   800a4e <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800b18:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800b1f:	e9 2a ff ff ff       	jmpq   800a4e <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800b24:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b28:	79 12                	jns    800b3c <vprintfmt+0x177>
				width = precision, precision = -1;
  800b2a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b2d:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800b30:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800b37:	e9 12 ff ff ff       	jmpq   800a4e <vprintfmt+0x89>
  800b3c:	e9 0d ff ff ff       	jmpq   800a4e <vprintfmt+0x89>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b41:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800b45:	e9 04 ff ff ff       	jmpq   800a4e <vprintfmt+0x89>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800b4a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b4d:	83 f8 30             	cmp    $0x30,%eax
  800b50:	73 17                	jae    800b69 <vprintfmt+0x1a4>
  800b52:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b56:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b59:	89 c0                	mov    %eax,%eax
  800b5b:	48 01 d0             	add    %rdx,%rax
  800b5e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b61:	83 c2 08             	add    $0x8,%edx
  800b64:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b67:	eb 0f                	jmp    800b78 <vprintfmt+0x1b3>
  800b69:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b6d:	48 89 d0             	mov    %rdx,%rax
  800b70:	48 83 c2 08          	add    $0x8,%rdx
  800b74:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b78:	8b 10                	mov    (%rax),%edx
  800b7a:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b7e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b82:	48 89 ce             	mov    %rcx,%rsi
  800b85:	89 d7                	mov    %edx,%edi
  800b87:	ff d0                	callq  *%rax
			break;
  800b89:	e9 40 03 00 00       	jmpq   800ece <vprintfmt+0x509>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800b8e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b91:	83 f8 30             	cmp    $0x30,%eax
  800b94:	73 17                	jae    800bad <vprintfmt+0x1e8>
  800b96:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b9a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b9d:	89 c0                	mov    %eax,%eax
  800b9f:	48 01 d0             	add    %rdx,%rax
  800ba2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ba5:	83 c2 08             	add    $0x8,%edx
  800ba8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bab:	eb 0f                	jmp    800bbc <vprintfmt+0x1f7>
  800bad:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bb1:	48 89 d0             	mov    %rdx,%rax
  800bb4:	48 83 c2 08          	add    $0x8,%rdx
  800bb8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bbc:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800bbe:	85 db                	test   %ebx,%ebx
  800bc0:	79 02                	jns    800bc4 <vprintfmt+0x1ff>
				err = -err;
  800bc2:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800bc4:	83 fb 10             	cmp    $0x10,%ebx
  800bc7:	7f 16                	jg     800bdf <vprintfmt+0x21a>
  800bc9:	48 b8 c0 40 80 00 00 	movabs $0x8040c0,%rax
  800bd0:	00 00 00 
  800bd3:	48 63 d3             	movslq %ebx,%rdx
  800bd6:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800bda:	4d 85 e4             	test   %r12,%r12
  800bdd:	75 2e                	jne    800c0d <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800bdf:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800be3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800be7:	89 d9                	mov    %ebx,%ecx
  800be9:	48 ba 59 41 80 00 00 	movabs $0x804159,%rdx
  800bf0:	00 00 00 
  800bf3:	48 89 c7             	mov    %rax,%rdi
  800bf6:	b8 00 00 00 00       	mov    $0x0,%eax
  800bfb:	49 b8 dd 0e 80 00 00 	movabs $0x800edd,%r8
  800c02:	00 00 00 
  800c05:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c08:	e9 c1 02 00 00       	jmpq   800ece <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c0d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c11:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c15:	4c 89 e1             	mov    %r12,%rcx
  800c18:	48 ba 62 41 80 00 00 	movabs $0x804162,%rdx
  800c1f:	00 00 00 
  800c22:	48 89 c7             	mov    %rax,%rdi
  800c25:	b8 00 00 00 00       	mov    $0x0,%eax
  800c2a:	49 b8 dd 0e 80 00 00 	movabs $0x800edd,%r8
  800c31:	00 00 00 
  800c34:	41 ff d0             	callq  *%r8
			break;
  800c37:	e9 92 02 00 00       	jmpq   800ece <vprintfmt+0x509>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800c3c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c3f:	83 f8 30             	cmp    $0x30,%eax
  800c42:	73 17                	jae    800c5b <vprintfmt+0x296>
  800c44:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c48:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c4b:	89 c0                	mov    %eax,%eax
  800c4d:	48 01 d0             	add    %rdx,%rax
  800c50:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c53:	83 c2 08             	add    $0x8,%edx
  800c56:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c59:	eb 0f                	jmp    800c6a <vprintfmt+0x2a5>
  800c5b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c5f:	48 89 d0             	mov    %rdx,%rax
  800c62:	48 83 c2 08          	add    $0x8,%rdx
  800c66:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c6a:	4c 8b 20             	mov    (%rax),%r12
  800c6d:	4d 85 e4             	test   %r12,%r12
  800c70:	75 0a                	jne    800c7c <vprintfmt+0x2b7>
				p = "(null)";
  800c72:	49 bc 65 41 80 00 00 	movabs $0x804165,%r12
  800c79:	00 00 00 
			if (width > 0 && padc != '-')
  800c7c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c80:	7e 3f                	jle    800cc1 <vprintfmt+0x2fc>
  800c82:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800c86:	74 39                	je     800cc1 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c88:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c8b:	48 98                	cltq   
  800c8d:	48 89 c6             	mov    %rax,%rsi
  800c90:	4c 89 e7             	mov    %r12,%rdi
  800c93:	48 b8 89 11 80 00 00 	movabs $0x801189,%rax
  800c9a:	00 00 00 
  800c9d:	ff d0                	callq  *%rax
  800c9f:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800ca2:	eb 17                	jmp    800cbb <vprintfmt+0x2f6>
					putch(padc, putdat);
  800ca4:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800ca8:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800cac:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cb0:	48 89 ce             	mov    %rcx,%rsi
  800cb3:	89 d7                	mov    %edx,%edi
  800cb5:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800cb7:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cbb:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cbf:	7f e3                	jg     800ca4 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cc1:	eb 37                	jmp    800cfa <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800cc3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800cc7:	74 1e                	je     800ce7 <vprintfmt+0x322>
  800cc9:	83 fb 1f             	cmp    $0x1f,%ebx
  800ccc:	7e 05                	jle    800cd3 <vprintfmt+0x30e>
  800cce:	83 fb 7e             	cmp    $0x7e,%ebx
  800cd1:	7e 14                	jle    800ce7 <vprintfmt+0x322>
					putch('?', putdat);
  800cd3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cd7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cdb:	48 89 d6             	mov    %rdx,%rsi
  800cde:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800ce3:	ff d0                	callq  *%rax
  800ce5:	eb 0f                	jmp    800cf6 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800ce7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ceb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cef:	48 89 d6             	mov    %rdx,%rsi
  800cf2:	89 df                	mov    %ebx,%edi
  800cf4:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cf6:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cfa:	4c 89 e0             	mov    %r12,%rax
  800cfd:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800d01:	0f b6 00             	movzbl (%rax),%eax
  800d04:	0f be d8             	movsbl %al,%ebx
  800d07:	85 db                	test   %ebx,%ebx
  800d09:	74 10                	je     800d1b <vprintfmt+0x356>
  800d0b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d0f:	78 b2                	js     800cc3 <vprintfmt+0x2fe>
  800d11:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800d15:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d19:	79 a8                	jns    800cc3 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d1b:	eb 16                	jmp    800d33 <vprintfmt+0x36e>
				putch(' ', putdat);
  800d1d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d21:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d25:	48 89 d6             	mov    %rdx,%rsi
  800d28:	bf 20 00 00 00       	mov    $0x20,%edi
  800d2d:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d2f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d33:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d37:	7f e4                	jg     800d1d <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800d39:	e9 90 01 00 00       	jmpq   800ece <vprintfmt+0x509>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800d3e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d42:	be 03 00 00 00       	mov    $0x3,%esi
  800d47:	48 89 c7             	mov    %rax,%rdi
  800d4a:	48 b8 b5 08 80 00 00 	movabs $0x8008b5,%rax
  800d51:	00 00 00 
  800d54:	ff d0                	callq  *%rax
  800d56:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800d5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d5e:	48 85 c0             	test   %rax,%rax
  800d61:	79 1d                	jns    800d80 <vprintfmt+0x3bb>
				putch('-', putdat);
  800d63:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d67:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d6b:	48 89 d6             	mov    %rdx,%rsi
  800d6e:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800d73:	ff d0                	callq  *%rax
				num = -(long long) num;
  800d75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d79:	48 f7 d8             	neg    %rax
  800d7c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800d80:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d87:	e9 d5 00 00 00       	jmpq   800e61 <vprintfmt+0x49c>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800d8c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d90:	be 03 00 00 00       	mov    $0x3,%esi
  800d95:	48 89 c7             	mov    %rax,%rdi
  800d98:	48 b8 a5 07 80 00 00 	movabs $0x8007a5,%rax
  800d9f:	00 00 00 
  800da2:	ff d0                	callq  *%rax
  800da4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800da8:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800daf:	e9 ad 00 00 00       	jmpq   800e61 <vprintfmt+0x49c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800db4:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800db7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800dbb:	89 d6                	mov    %edx,%esi
  800dbd:	48 89 c7             	mov    %rax,%rdi
  800dc0:	48 b8 b5 08 80 00 00 	movabs $0x8008b5,%rax
  800dc7:	00 00 00 
  800dca:	ff d0                	callq  *%rax
  800dcc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800dd0:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800dd7:	e9 85 00 00 00       	jmpq   800e61 <vprintfmt+0x49c>


		// pointer
		case 'p':
			putch('0', putdat);
  800ddc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800de0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800de4:	48 89 d6             	mov    %rdx,%rsi
  800de7:	bf 30 00 00 00       	mov    $0x30,%edi
  800dec:	ff d0                	callq  *%rax
			putch('x', putdat);
  800dee:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800df2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800df6:	48 89 d6             	mov    %rdx,%rsi
  800df9:	bf 78 00 00 00       	mov    $0x78,%edi
  800dfe:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800e00:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e03:	83 f8 30             	cmp    $0x30,%eax
  800e06:	73 17                	jae    800e1f <vprintfmt+0x45a>
  800e08:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e0c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e0f:	89 c0                	mov    %eax,%eax
  800e11:	48 01 d0             	add    %rdx,%rax
  800e14:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e17:	83 c2 08             	add    $0x8,%edx
  800e1a:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e1d:	eb 0f                	jmp    800e2e <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800e1f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e23:	48 89 d0             	mov    %rdx,%rax
  800e26:	48 83 c2 08          	add    $0x8,%rdx
  800e2a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e2e:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e31:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800e35:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800e3c:	eb 23                	jmp    800e61 <vprintfmt+0x49c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800e3e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e42:	be 03 00 00 00       	mov    $0x3,%esi
  800e47:	48 89 c7             	mov    %rax,%rdi
  800e4a:	48 b8 a5 07 80 00 00 	movabs $0x8007a5,%rax
  800e51:	00 00 00 
  800e54:	ff d0                	callq  *%rax
  800e56:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800e5a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e61:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800e66:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800e69:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800e6c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e70:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e74:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e78:	45 89 c1             	mov    %r8d,%r9d
  800e7b:	41 89 f8             	mov    %edi,%r8d
  800e7e:	48 89 c7             	mov    %rax,%rdi
  800e81:	48 b8 ea 06 80 00 00 	movabs $0x8006ea,%rax
  800e88:	00 00 00 
  800e8b:	ff d0                	callq  *%rax
			break;
  800e8d:	eb 3f                	jmp    800ece <vprintfmt+0x509>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e8f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e93:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e97:	48 89 d6             	mov    %rdx,%rsi
  800e9a:	89 df                	mov    %ebx,%edi
  800e9c:	ff d0                	callq  *%rax
			break;
  800e9e:	eb 2e                	jmp    800ece <vprintfmt+0x509>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ea0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ea4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ea8:	48 89 d6             	mov    %rdx,%rsi
  800eab:	bf 25 00 00 00       	mov    $0x25,%edi
  800eb0:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800eb2:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800eb7:	eb 05                	jmp    800ebe <vprintfmt+0x4f9>
  800eb9:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ebe:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ec2:	48 83 e8 01          	sub    $0x1,%rax
  800ec6:	0f b6 00             	movzbl (%rax),%eax
  800ec9:	3c 25                	cmp    $0x25,%al
  800ecb:	75 ec                	jne    800eb9 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800ecd:	90                   	nop
		}
	}
  800ece:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ecf:	e9 43 fb ff ff       	jmpq   800a17 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  800ed4:	48 83 c4 60          	add    $0x60,%rsp
  800ed8:	5b                   	pop    %rbx
  800ed9:	41 5c                	pop    %r12
  800edb:	5d                   	pop    %rbp
  800edc:	c3                   	retq   

0000000000800edd <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800edd:	55                   	push   %rbp
  800ede:	48 89 e5             	mov    %rsp,%rbp
  800ee1:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800ee8:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800eef:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800ef6:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800efd:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f04:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f0b:	84 c0                	test   %al,%al
  800f0d:	74 20                	je     800f2f <printfmt+0x52>
  800f0f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f13:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f17:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f1b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f1f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f23:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f27:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f2b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f2f:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800f36:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800f3d:	00 00 00 
  800f40:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800f47:	00 00 00 
  800f4a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f4e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800f55:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f5c:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800f63:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800f6a:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800f71:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800f78:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800f7f:	48 89 c7             	mov    %rax,%rdi
  800f82:	48 b8 c5 09 80 00 00 	movabs $0x8009c5,%rax
  800f89:	00 00 00 
  800f8c:	ff d0                	callq  *%rax
	va_end(ap);
}
  800f8e:	c9                   	leaveq 
  800f8f:	c3                   	retq   

0000000000800f90 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f90:	55                   	push   %rbp
  800f91:	48 89 e5             	mov    %rsp,%rbp
  800f94:	48 83 ec 10          	sub    $0x10,%rsp
  800f98:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800f9b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800f9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fa3:	8b 40 10             	mov    0x10(%rax),%eax
  800fa6:	8d 50 01             	lea    0x1(%rax),%edx
  800fa9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fad:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800fb0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fb4:	48 8b 10             	mov    (%rax),%rdx
  800fb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fbb:	48 8b 40 08          	mov    0x8(%rax),%rax
  800fbf:	48 39 c2             	cmp    %rax,%rdx
  800fc2:	73 17                	jae    800fdb <sprintputch+0x4b>
		*b->buf++ = ch;
  800fc4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fc8:	48 8b 00             	mov    (%rax),%rax
  800fcb:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800fcf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800fd3:	48 89 0a             	mov    %rcx,(%rdx)
  800fd6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800fd9:	88 10                	mov    %dl,(%rax)
}
  800fdb:	c9                   	leaveq 
  800fdc:	c3                   	retq   

0000000000800fdd <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fdd:	55                   	push   %rbp
  800fde:	48 89 e5             	mov    %rsp,%rbp
  800fe1:	48 83 ec 50          	sub    $0x50,%rsp
  800fe5:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800fe9:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800fec:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800ff0:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800ff4:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800ff8:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800ffc:	48 8b 0a             	mov    (%rdx),%rcx
  800fff:	48 89 08             	mov    %rcx,(%rax)
  801002:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801006:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80100a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80100e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801012:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801016:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80101a:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80101d:	48 98                	cltq   
  80101f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801023:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801027:	48 01 d0             	add    %rdx,%rax
  80102a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80102e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801035:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80103a:	74 06                	je     801042 <vsnprintf+0x65>
  80103c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801040:	7f 07                	jg     801049 <vsnprintf+0x6c>
		return -E_INVAL;
  801042:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801047:	eb 2f                	jmp    801078 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801049:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80104d:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801051:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801055:	48 89 c6             	mov    %rax,%rsi
  801058:	48 bf 90 0f 80 00 00 	movabs $0x800f90,%rdi
  80105f:	00 00 00 
  801062:	48 b8 c5 09 80 00 00 	movabs $0x8009c5,%rax
  801069:	00 00 00 
  80106c:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80106e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801072:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801075:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801078:	c9                   	leaveq 
  801079:	c3                   	retq   

000000000080107a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80107a:	55                   	push   %rbp
  80107b:	48 89 e5             	mov    %rsp,%rbp
  80107e:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801085:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80108c:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801092:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801099:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8010a0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8010a7:	84 c0                	test   %al,%al
  8010a9:	74 20                	je     8010cb <snprintf+0x51>
  8010ab:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8010af:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8010b3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8010b7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8010bb:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8010bf:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8010c3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8010c7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8010cb:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8010d2:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8010d9:	00 00 00 
  8010dc:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8010e3:	00 00 00 
  8010e6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8010ea:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8010f1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8010f8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8010ff:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801106:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80110d:	48 8b 0a             	mov    (%rdx),%rcx
  801110:	48 89 08             	mov    %rcx,(%rax)
  801113:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801117:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80111b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80111f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801123:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80112a:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801131:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801137:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80113e:	48 89 c7             	mov    %rax,%rdi
  801141:	48 b8 dd 0f 80 00 00 	movabs $0x800fdd,%rax
  801148:	00 00 00 
  80114b:	ff d0                	callq  *%rax
  80114d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801153:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801159:	c9                   	leaveq 
  80115a:	c3                   	retq   

000000000080115b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80115b:	55                   	push   %rbp
  80115c:	48 89 e5             	mov    %rsp,%rbp
  80115f:	48 83 ec 18          	sub    $0x18,%rsp
  801163:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801167:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80116e:	eb 09                	jmp    801179 <strlen+0x1e>
		n++;
  801170:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801174:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801179:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80117d:	0f b6 00             	movzbl (%rax),%eax
  801180:	84 c0                	test   %al,%al
  801182:	75 ec                	jne    801170 <strlen+0x15>
		n++;
	return n;
  801184:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801187:	c9                   	leaveq 
  801188:	c3                   	retq   

0000000000801189 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801189:	55                   	push   %rbp
  80118a:	48 89 e5             	mov    %rsp,%rbp
  80118d:	48 83 ec 20          	sub    $0x20,%rsp
  801191:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801195:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801199:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011a0:	eb 0e                	jmp    8011b0 <strnlen+0x27>
		n++;
  8011a2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011a6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011ab:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8011b0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8011b5:	74 0b                	je     8011c2 <strnlen+0x39>
  8011b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011bb:	0f b6 00             	movzbl (%rax),%eax
  8011be:	84 c0                	test   %al,%al
  8011c0:	75 e0                	jne    8011a2 <strnlen+0x19>
		n++;
	return n;
  8011c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011c5:	c9                   	leaveq 
  8011c6:	c3                   	retq   

00000000008011c7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8011c7:	55                   	push   %rbp
  8011c8:	48 89 e5             	mov    %rsp,%rbp
  8011cb:	48 83 ec 20          	sub    $0x20,%rsp
  8011cf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011d3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8011d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011db:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8011df:	90                   	nop
  8011e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011e4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011e8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011ec:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011f0:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8011f4:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8011f8:	0f b6 12             	movzbl (%rdx),%edx
  8011fb:	88 10                	mov    %dl,(%rax)
  8011fd:	0f b6 00             	movzbl (%rax),%eax
  801200:	84 c0                	test   %al,%al
  801202:	75 dc                	jne    8011e0 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801204:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801208:	c9                   	leaveq 
  801209:	c3                   	retq   

000000000080120a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80120a:	55                   	push   %rbp
  80120b:	48 89 e5             	mov    %rsp,%rbp
  80120e:	48 83 ec 20          	sub    $0x20,%rsp
  801212:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801216:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80121a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80121e:	48 89 c7             	mov    %rax,%rdi
  801221:	48 b8 5b 11 80 00 00 	movabs $0x80115b,%rax
  801228:	00 00 00 
  80122b:	ff d0                	callq  *%rax
  80122d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801230:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801233:	48 63 d0             	movslq %eax,%rdx
  801236:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80123a:	48 01 c2             	add    %rax,%rdx
  80123d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801241:	48 89 c6             	mov    %rax,%rsi
  801244:	48 89 d7             	mov    %rdx,%rdi
  801247:	48 b8 c7 11 80 00 00 	movabs $0x8011c7,%rax
  80124e:	00 00 00 
  801251:	ff d0                	callq  *%rax
	return dst;
  801253:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801257:	c9                   	leaveq 
  801258:	c3                   	retq   

0000000000801259 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801259:	55                   	push   %rbp
  80125a:	48 89 e5             	mov    %rsp,%rbp
  80125d:	48 83 ec 28          	sub    $0x28,%rsp
  801261:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801265:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801269:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80126d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801271:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801275:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80127c:	00 
  80127d:	eb 2a                	jmp    8012a9 <strncpy+0x50>
		*dst++ = *src;
  80127f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801283:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801287:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80128b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80128f:	0f b6 12             	movzbl (%rdx),%edx
  801292:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801294:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801298:	0f b6 00             	movzbl (%rax),%eax
  80129b:	84 c0                	test   %al,%al
  80129d:	74 05                	je     8012a4 <strncpy+0x4b>
			src++;
  80129f:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012a4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ad:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8012b1:	72 cc                	jb     80127f <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8012b7:	c9                   	leaveq 
  8012b8:	c3                   	retq   

00000000008012b9 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8012b9:	55                   	push   %rbp
  8012ba:	48 89 e5             	mov    %rsp,%rbp
  8012bd:	48 83 ec 28          	sub    $0x28,%rsp
  8012c1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012c5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012c9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8012cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012d1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8012d5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8012da:	74 3d                	je     801319 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8012dc:	eb 1d                	jmp    8012fb <strlcpy+0x42>
			*dst++ = *src++;
  8012de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012e2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012e6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012ea:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012ee:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8012f2:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8012f6:	0f b6 12             	movzbl (%rdx),%edx
  8012f9:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8012fb:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801300:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801305:	74 0b                	je     801312 <strlcpy+0x59>
  801307:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80130b:	0f b6 00             	movzbl (%rax),%eax
  80130e:	84 c0                	test   %al,%al
  801310:	75 cc                	jne    8012de <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801312:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801316:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801319:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80131d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801321:	48 29 c2             	sub    %rax,%rdx
  801324:	48 89 d0             	mov    %rdx,%rax
}
  801327:	c9                   	leaveq 
  801328:	c3                   	retq   

0000000000801329 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801329:	55                   	push   %rbp
  80132a:	48 89 e5             	mov    %rsp,%rbp
  80132d:	48 83 ec 10          	sub    $0x10,%rsp
  801331:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801335:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801339:	eb 0a                	jmp    801345 <strcmp+0x1c>
		p++, q++;
  80133b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801340:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801345:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801349:	0f b6 00             	movzbl (%rax),%eax
  80134c:	84 c0                	test   %al,%al
  80134e:	74 12                	je     801362 <strcmp+0x39>
  801350:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801354:	0f b6 10             	movzbl (%rax),%edx
  801357:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80135b:	0f b6 00             	movzbl (%rax),%eax
  80135e:	38 c2                	cmp    %al,%dl
  801360:	74 d9                	je     80133b <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801362:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801366:	0f b6 00             	movzbl (%rax),%eax
  801369:	0f b6 d0             	movzbl %al,%edx
  80136c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801370:	0f b6 00             	movzbl (%rax),%eax
  801373:	0f b6 c0             	movzbl %al,%eax
  801376:	29 c2                	sub    %eax,%edx
  801378:	89 d0                	mov    %edx,%eax
}
  80137a:	c9                   	leaveq 
  80137b:	c3                   	retq   

000000000080137c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80137c:	55                   	push   %rbp
  80137d:	48 89 e5             	mov    %rsp,%rbp
  801380:	48 83 ec 18          	sub    $0x18,%rsp
  801384:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801388:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80138c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801390:	eb 0f                	jmp    8013a1 <strncmp+0x25>
		n--, p++, q++;
  801392:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801397:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80139c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8013a1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013a6:	74 1d                	je     8013c5 <strncmp+0x49>
  8013a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ac:	0f b6 00             	movzbl (%rax),%eax
  8013af:	84 c0                	test   %al,%al
  8013b1:	74 12                	je     8013c5 <strncmp+0x49>
  8013b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b7:	0f b6 10             	movzbl (%rax),%edx
  8013ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013be:	0f b6 00             	movzbl (%rax),%eax
  8013c1:	38 c2                	cmp    %al,%dl
  8013c3:	74 cd                	je     801392 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8013c5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013ca:	75 07                	jne    8013d3 <strncmp+0x57>
		return 0;
  8013cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8013d1:	eb 18                	jmp    8013eb <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013d7:	0f b6 00             	movzbl (%rax),%eax
  8013da:	0f b6 d0             	movzbl %al,%edx
  8013dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013e1:	0f b6 00             	movzbl (%rax),%eax
  8013e4:	0f b6 c0             	movzbl %al,%eax
  8013e7:	29 c2                	sub    %eax,%edx
  8013e9:	89 d0                	mov    %edx,%eax
}
  8013eb:	c9                   	leaveq 
  8013ec:	c3                   	retq   

00000000008013ed <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013ed:	55                   	push   %rbp
  8013ee:	48 89 e5             	mov    %rsp,%rbp
  8013f1:	48 83 ec 0c          	sub    $0xc,%rsp
  8013f5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013f9:	89 f0                	mov    %esi,%eax
  8013fb:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8013fe:	eb 17                	jmp    801417 <strchr+0x2a>
		if (*s == c)
  801400:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801404:	0f b6 00             	movzbl (%rax),%eax
  801407:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80140a:	75 06                	jne    801412 <strchr+0x25>
			return (char *) s;
  80140c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801410:	eb 15                	jmp    801427 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801412:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801417:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80141b:	0f b6 00             	movzbl (%rax),%eax
  80141e:	84 c0                	test   %al,%al
  801420:	75 de                	jne    801400 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801422:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801427:	c9                   	leaveq 
  801428:	c3                   	retq   

0000000000801429 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801429:	55                   	push   %rbp
  80142a:	48 89 e5             	mov    %rsp,%rbp
  80142d:	48 83 ec 0c          	sub    $0xc,%rsp
  801431:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801435:	89 f0                	mov    %esi,%eax
  801437:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80143a:	eb 13                	jmp    80144f <strfind+0x26>
		if (*s == c)
  80143c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801440:	0f b6 00             	movzbl (%rax),%eax
  801443:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801446:	75 02                	jne    80144a <strfind+0x21>
			break;
  801448:	eb 10                	jmp    80145a <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80144a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80144f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801453:	0f b6 00             	movzbl (%rax),%eax
  801456:	84 c0                	test   %al,%al
  801458:	75 e2                	jne    80143c <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80145a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80145e:	c9                   	leaveq 
  80145f:	c3                   	retq   

0000000000801460 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801460:	55                   	push   %rbp
  801461:	48 89 e5             	mov    %rsp,%rbp
  801464:	48 83 ec 18          	sub    $0x18,%rsp
  801468:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80146c:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80146f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801473:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801478:	75 06                	jne    801480 <memset+0x20>
		return v;
  80147a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80147e:	eb 69                	jmp    8014e9 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801480:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801484:	83 e0 03             	and    $0x3,%eax
  801487:	48 85 c0             	test   %rax,%rax
  80148a:	75 48                	jne    8014d4 <memset+0x74>
  80148c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801490:	83 e0 03             	and    $0x3,%eax
  801493:	48 85 c0             	test   %rax,%rax
  801496:	75 3c                	jne    8014d4 <memset+0x74>
		c &= 0xFF;
  801498:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80149f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014a2:	c1 e0 18             	shl    $0x18,%eax
  8014a5:	89 c2                	mov    %eax,%edx
  8014a7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014aa:	c1 e0 10             	shl    $0x10,%eax
  8014ad:	09 c2                	or     %eax,%edx
  8014af:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014b2:	c1 e0 08             	shl    $0x8,%eax
  8014b5:	09 d0                	or     %edx,%eax
  8014b7:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8014ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014be:	48 c1 e8 02          	shr    $0x2,%rax
  8014c2:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8014c5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014c9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014cc:	48 89 d7             	mov    %rdx,%rdi
  8014cf:	fc                   	cld    
  8014d0:	f3 ab                	rep stos %eax,%es:(%rdi)
  8014d2:	eb 11                	jmp    8014e5 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8014d4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014d8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014db:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8014df:	48 89 d7             	mov    %rdx,%rdi
  8014e2:	fc                   	cld    
  8014e3:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  8014e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014e9:	c9                   	leaveq 
  8014ea:	c3                   	retq   

00000000008014eb <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8014eb:	55                   	push   %rbp
  8014ec:	48 89 e5             	mov    %rsp,%rbp
  8014ef:	48 83 ec 28          	sub    $0x28,%rsp
  8014f3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014f7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014fb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8014ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801503:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801507:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80150b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80150f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801513:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801517:	0f 83 88 00 00 00    	jae    8015a5 <memmove+0xba>
  80151d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801521:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801525:	48 01 d0             	add    %rdx,%rax
  801528:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80152c:	76 77                	jbe    8015a5 <memmove+0xba>
		s += n;
  80152e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801532:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801536:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80153a:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80153e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801542:	83 e0 03             	and    $0x3,%eax
  801545:	48 85 c0             	test   %rax,%rax
  801548:	75 3b                	jne    801585 <memmove+0x9a>
  80154a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80154e:	83 e0 03             	and    $0x3,%eax
  801551:	48 85 c0             	test   %rax,%rax
  801554:	75 2f                	jne    801585 <memmove+0x9a>
  801556:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80155a:	83 e0 03             	and    $0x3,%eax
  80155d:	48 85 c0             	test   %rax,%rax
  801560:	75 23                	jne    801585 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801562:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801566:	48 83 e8 04          	sub    $0x4,%rax
  80156a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80156e:	48 83 ea 04          	sub    $0x4,%rdx
  801572:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801576:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80157a:	48 89 c7             	mov    %rax,%rdi
  80157d:	48 89 d6             	mov    %rdx,%rsi
  801580:	fd                   	std    
  801581:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801583:	eb 1d                	jmp    8015a2 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801585:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801589:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80158d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801591:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801595:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801599:	48 89 d7             	mov    %rdx,%rdi
  80159c:	48 89 c1             	mov    %rax,%rcx
  80159f:	fd                   	std    
  8015a0:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8015a2:	fc                   	cld    
  8015a3:	eb 57                	jmp    8015fc <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8015a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015a9:	83 e0 03             	and    $0x3,%eax
  8015ac:	48 85 c0             	test   %rax,%rax
  8015af:	75 36                	jne    8015e7 <memmove+0xfc>
  8015b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015b5:	83 e0 03             	and    $0x3,%eax
  8015b8:	48 85 c0             	test   %rax,%rax
  8015bb:	75 2a                	jne    8015e7 <memmove+0xfc>
  8015bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c1:	83 e0 03             	and    $0x3,%eax
  8015c4:	48 85 c0             	test   %rax,%rax
  8015c7:	75 1e                	jne    8015e7 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8015c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015cd:	48 c1 e8 02          	shr    $0x2,%rax
  8015d1:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8015d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015d8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015dc:	48 89 c7             	mov    %rax,%rdi
  8015df:	48 89 d6             	mov    %rdx,%rsi
  8015e2:	fc                   	cld    
  8015e3:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015e5:	eb 15                	jmp    8015fc <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8015e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015eb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015ef:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015f3:	48 89 c7             	mov    %rax,%rdi
  8015f6:	48 89 d6             	mov    %rdx,%rsi
  8015f9:	fc                   	cld    
  8015fa:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8015fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801600:	c9                   	leaveq 
  801601:	c3                   	retq   

0000000000801602 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801602:	55                   	push   %rbp
  801603:	48 89 e5             	mov    %rsp,%rbp
  801606:	48 83 ec 18          	sub    $0x18,%rsp
  80160a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80160e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801612:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801616:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80161a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80161e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801622:	48 89 ce             	mov    %rcx,%rsi
  801625:	48 89 c7             	mov    %rax,%rdi
  801628:	48 b8 eb 14 80 00 00 	movabs $0x8014eb,%rax
  80162f:	00 00 00 
  801632:	ff d0                	callq  *%rax
}
  801634:	c9                   	leaveq 
  801635:	c3                   	retq   

0000000000801636 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801636:	55                   	push   %rbp
  801637:	48 89 e5             	mov    %rsp,%rbp
  80163a:	48 83 ec 28          	sub    $0x28,%rsp
  80163e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801642:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801646:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80164a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80164e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801652:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801656:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80165a:	eb 36                	jmp    801692 <memcmp+0x5c>
		if (*s1 != *s2)
  80165c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801660:	0f b6 10             	movzbl (%rax),%edx
  801663:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801667:	0f b6 00             	movzbl (%rax),%eax
  80166a:	38 c2                	cmp    %al,%dl
  80166c:	74 1a                	je     801688 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80166e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801672:	0f b6 00             	movzbl (%rax),%eax
  801675:	0f b6 d0             	movzbl %al,%edx
  801678:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80167c:	0f b6 00             	movzbl (%rax),%eax
  80167f:	0f b6 c0             	movzbl %al,%eax
  801682:	29 c2                	sub    %eax,%edx
  801684:	89 d0                	mov    %edx,%eax
  801686:	eb 20                	jmp    8016a8 <memcmp+0x72>
		s1++, s2++;
  801688:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80168d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801692:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801696:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80169a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80169e:	48 85 c0             	test   %rax,%rax
  8016a1:	75 b9                	jne    80165c <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016a8:	c9                   	leaveq 
  8016a9:	c3                   	retq   

00000000008016aa <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8016aa:	55                   	push   %rbp
  8016ab:	48 89 e5             	mov    %rsp,%rbp
  8016ae:	48 83 ec 28          	sub    $0x28,%rsp
  8016b2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016b6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8016b9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8016bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016c5:	48 01 d0             	add    %rdx,%rax
  8016c8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8016cc:	eb 15                	jmp    8016e3 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016d2:	0f b6 10             	movzbl (%rax),%edx
  8016d5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8016d8:	38 c2                	cmp    %al,%dl
  8016da:	75 02                	jne    8016de <memfind+0x34>
			break;
  8016dc:	eb 0f                	jmp    8016ed <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8016de:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8016e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016e7:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8016eb:	72 e1                	jb     8016ce <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8016ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016f1:	c9                   	leaveq 
  8016f2:	c3                   	retq   

00000000008016f3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8016f3:	55                   	push   %rbp
  8016f4:	48 89 e5             	mov    %rsp,%rbp
  8016f7:	48 83 ec 34          	sub    $0x34,%rsp
  8016fb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016ff:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801703:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801706:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80170d:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801714:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801715:	eb 05                	jmp    80171c <strtol+0x29>
		s++;
  801717:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80171c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801720:	0f b6 00             	movzbl (%rax),%eax
  801723:	3c 20                	cmp    $0x20,%al
  801725:	74 f0                	je     801717 <strtol+0x24>
  801727:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80172b:	0f b6 00             	movzbl (%rax),%eax
  80172e:	3c 09                	cmp    $0x9,%al
  801730:	74 e5                	je     801717 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801732:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801736:	0f b6 00             	movzbl (%rax),%eax
  801739:	3c 2b                	cmp    $0x2b,%al
  80173b:	75 07                	jne    801744 <strtol+0x51>
		s++;
  80173d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801742:	eb 17                	jmp    80175b <strtol+0x68>
	else if (*s == '-')
  801744:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801748:	0f b6 00             	movzbl (%rax),%eax
  80174b:	3c 2d                	cmp    $0x2d,%al
  80174d:	75 0c                	jne    80175b <strtol+0x68>
		s++, neg = 1;
  80174f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801754:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80175b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80175f:	74 06                	je     801767 <strtol+0x74>
  801761:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801765:	75 28                	jne    80178f <strtol+0x9c>
  801767:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80176b:	0f b6 00             	movzbl (%rax),%eax
  80176e:	3c 30                	cmp    $0x30,%al
  801770:	75 1d                	jne    80178f <strtol+0x9c>
  801772:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801776:	48 83 c0 01          	add    $0x1,%rax
  80177a:	0f b6 00             	movzbl (%rax),%eax
  80177d:	3c 78                	cmp    $0x78,%al
  80177f:	75 0e                	jne    80178f <strtol+0x9c>
		s += 2, base = 16;
  801781:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801786:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80178d:	eb 2c                	jmp    8017bb <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80178f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801793:	75 19                	jne    8017ae <strtol+0xbb>
  801795:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801799:	0f b6 00             	movzbl (%rax),%eax
  80179c:	3c 30                	cmp    $0x30,%al
  80179e:	75 0e                	jne    8017ae <strtol+0xbb>
		s++, base = 8;
  8017a0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017a5:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8017ac:	eb 0d                	jmp    8017bb <strtol+0xc8>
	else if (base == 0)
  8017ae:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017b2:	75 07                	jne    8017bb <strtol+0xc8>
		base = 10;
  8017b4:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017bf:	0f b6 00             	movzbl (%rax),%eax
  8017c2:	3c 2f                	cmp    $0x2f,%al
  8017c4:	7e 1d                	jle    8017e3 <strtol+0xf0>
  8017c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ca:	0f b6 00             	movzbl (%rax),%eax
  8017cd:	3c 39                	cmp    $0x39,%al
  8017cf:	7f 12                	jg     8017e3 <strtol+0xf0>
			dig = *s - '0';
  8017d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d5:	0f b6 00             	movzbl (%rax),%eax
  8017d8:	0f be c0             	movsbl %al,%eax
  8017db:	83 e8 30             	sub    $0x30,%eax
  8017de:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8017e1:	eb 4e                	jmp    801831 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8017e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e7:	0f b6 00             	movzbl (%rax),%eax
  8017ea:	3c 60                	cmp    $0x60,%al
  8017ec:	7e 1d                	jle    80180b <strtol+0x118>
  8017ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f2:	0f b6 00             	movzbl (%rax),%eax
  8017f5:	3c 7a                	cmp    $0x7a,%al
  8017f7:	7f 12                	jg     80180b <strtol+0x118>
			dig = *s - 'a' + 10;
  8017f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017fd:	0f b6 00             	movzbl (%rax),%eax
  801800:	0f be c0             	movsbl %al,%eax
  801803:	83 e8 57             	sub    $0x57,%eax
  801806:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801809:	eb 26                	jmp    801831 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80180b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80180f:	0f b6 00             	movzbl (%rax),%eax
  801812:	3c 40                	cmp    $0x40,%al
  801814:	7e 48                	jle    80185e <strtol+0x16b>
  801816:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80181a:	0f b6 00             	movzbl (%rax),%eax
  80181d:	3c 5a                	cmp    $0x5a,%al
  80181f:	7f 3d                	jg     80185e <strtol+0x16b>
			dig = *s - 'A' + 10;
  801821:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801825:	0f b6 00             	movzbl (%rax),%eax
  801828:	0f be c0             	movsbl %al,%eax
  80182b:	83 e8 37             	sub    $0x37,%eax
  80182e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801831:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801834:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801837:	7c 02                	jl     80183b <strtol+0x148>
			break;
  801839:	eb 23                	jmp    80185e <strtol+0x16b>
		s++, val = (val * base) + dig;
  80183b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801840:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801843:	48 98                	cltq   
  801845:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80184a:	48 89 c2             	mov    %rax,%rdx
  80184d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801850:	48 98                	cltq   
  801852:	48 01 d0             	add    %rdx,%rax
  801855:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801859:	e9 5d ff ff ff       	jmpq   8017bb <strtol+0xc8>

	if (endptr)
  80185e:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801863:	74 0b                	je     801870 <strtol+0x17d>
		*endptr = (char *) s;
  801865:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801869:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80186d:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801870:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801874:	74 09                	je     80187f <strtol+0x18c>
  801876:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80187a:	48 f7 d8             	neg    %rax
  80187d:	eb 04                	jmp    801883 <strtol+0x190>
  80187f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801883:	c9                   	leaveq 
  801884:	c3                   	retq   

0000000000801885 <strstr>:

char * strstr(const char *in, const char *str)
{
  801885:	55                   	push   %rbp
  801886:	48 89 e5             	mov    %rsp,%rbp
  801889:	48 83 ec 30          	sub    $0x30,%rsp
  80188d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801891:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801895:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801899:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80189d:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018a1:	0f b6 00             	movzbl (%rax),%eax
  8018a4:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  8018a7:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8018ab:	75 06                	jne    8018b3 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  8018ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b1:	eb 6b                	jmp    80191e <strstr+0x99>

    len = strlen(str);
  8018b3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018b7:	48 89 c7             	mov    %rax,%rdi
  8018ba:	48 b8 5b 11 80 00 00 	movabs $0x80115b,%rax
  8018c1:	00 00 00 
  8018c4:	ff d0                	callq  *%rax
  8018c6:	48 98                	cltq   
  8018c8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  8018cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018d0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018d4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8018d8:	0f b6 00             	movzbl (%rax),%eax
  8018db:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  8018de:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8018e2:	75 07                	jne    8018eb <strstr+0x66>
                return (char *) 0;
  8018e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e9:	eb 33                	jmp    80191e <strstr+0x99>
        } while (sc != c);
  8018eb:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8018ef:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8018f2:	75 d8                	jne    8018cc <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  8018f4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018f8:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8018fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801900:	48 89 ce             	mov    %rcx,%rsi
  801903:	48 89 c7             	mov    %rax,%rdi
  801906:	48 b8 7c 13 80 00 00 	movabs $0x80137c,%rax
  80190d:	00 00 00 
  801910:	ff d0                	callq  *%rax
  801912:	85 c0                	test   %eax,%eax
  801914:	75 b6                	jne    8018cc <strstr+0x47>

    return (char *) (in - 1);
  801916:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80191a:	48 83 e8 01          	sub    $0x1,%rax
}
  80191e:	c9                   	leaveq 
  80191f:	c3                   	retq   

0000000000801920 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801920:	55                   	push   %rbp
  801921:	48 89 e5             	mov    %rsp,%rbp
  801924:	53                   	push   %rbx
  801925:	48 83 ec 48          	sub    $0x48,%rsp
  801929:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80192c:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80192f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801933:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801937:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80193b:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80193f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801942:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801946:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80194a:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80194e:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801952:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801956:	4c 89 c3             	mov    %r8,%rbx
  801959:	cd 30                	int    $0x30
  80195b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80195f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801963:	74 3e                	je     8019a3 <syscall+0x83>
  801965:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80196a:	7e 37                	jle    8019a3 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80196c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801970:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801973:	49 89 d0             	mov    %rdx,%r8
  801976:	89 c1                	mov    %eax,%ecx
  801978:	48 ba 20 44 80 00 00 	movabs $0x804420,%rdx
  80197f:	00 00 00 
  801982:	be 23 00 00 00       	mov    $0x23,%esi
  801987:	48 bf 3d 44 80 00 00 	movabs $0x80443d,%rdi
  80198e:	00 00 00 
  801991:	b8 00 00 00 00       	mov    $0x0,%eax
  801996:	49 b9 d9 03 80 00 00 	movabs $0x8003d9,%r9
  80199d:	00 00 00 
  8019a0:	41 ff d1             	callq  *%r9

	return ret;
  8019a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8019a7:	48 83 c4 48          	add    $0x48,%rsp
  8019ab:	5b                   	pop    %rbx
  8019ac:	5d                   	pop    %rbp
  8019ad:	c3                   	retq   

00000000008019ae <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8019ae:	55                   	push   %rbp
  8019af:	48 89 e5             	mov    %rsp,%rbp
  8019b2:	48 83 ec 20          	sub    $0x20,%rsp
  8019b6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019ba:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8019be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019c2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019c6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019cd:	00 
  8019ce:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019d4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019da:	48 89 d1             	mov    %rdx,%rcx
  8019dd:	48 89 c2             	mov    %rax,%rdx
  8019e0:	be 00 00 00 00       	mov    $0x0,%esi
  8019e5:	bf 00 00 00 00       	mov    $0x0,%edi
  8019ea:	48 b8 20 19 80 00 00 	movabs $0x801920,%rax
  8019f1:	00 00 00 
  8019f4:	ff d0                	callq  *%rax
}
  8019f6:	c9                   	leaveq 
  8019f7:	c3                   	retq   

00000000008019f8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8019f8:	55                   	push   %rbp
  8019f9:	48 89 e5             	mov    %rsp,%rbp
  8019fc:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801a00:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a07:	00 
  801a08:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a0e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a14:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a19:	ba 00 00 00 00       	mov    $0x0,%edx
  801a1e:	be 00 00 00 00       	mov    $0x0,%esi
  801a23:	bf 01 00 00 00       	mov    $0x1,%edi
  801a28:	48 b8 20 19 80 00 00 	movabs $0x801920,%rax
  801a2f:	00 00 00 
  801a32:	ff d0                	callq  *%rax
}
  801a34:	c9                   	leaveq 
  801a35:	c3                   	retq   

0000000000801a36 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801a36:	55                   	push   %rbp
  801a37:	48 89 e5             	mov    %rsp,%rbp
  801a3a:	48 83 ec 10          	sub    $0x10,%rsp
  801a3e:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801a41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a44:	48 98                	cltq   
  801a46:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a4d:	00 
  801a4e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a54:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a5a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a5f:	48 89 c2             	mov    %rax,%rdx
  801a62:	be 01 00 00 00       	mov    $0x1,%esi
  801a67:	bf 03 00 00 00       	mov    $0x3,%edi
  801a6c:	48 b8 20 19 80 00 00 	movabs $0x801920,%rax
  801a73:	00 00 00 
  801a76:	ff d0                	callq  *%rax
}
  801a78:	c9                   	leaveq 
  801a79:	c3                   	retq   

0000000000801a7a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801a7a:	55                   	push   %rbp
  801a7b:	48 89 e5             	mov    %rsp,%rbp
  801a7e:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801a82:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a89:	00 
  801a8a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a90:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a96:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a9b:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa0:	be 00 00 00 00       	mov    $0x0,%esi
  801aa5:	bf 02 00 00 00       	mov    $0x2,%edi
  801aaa:	48 b8 20 19 80 00 00 	movabs $0x801920,%rax
  801ab1:	00 00 00 
  801ab4:	ff d0                	callq  *%rax
}
  801ab6:	c9                   	leaveq 
  801ab7:	c3                   	retq   

0000000000801ab8 <sys_yield>:

void
sys_yield(void)
{
  801ab8:	55                   	push   %rbp
  801ab9:	48 89 e5             	mov    %rsp,%rbp
  801abc:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801ac0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ac7:	00 
  801ac8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ace:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ad4:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ad9:	ba 00 00 00 00       	mov    $0x0,%edx
  801ade:	be 00 00 00 00       	mov    $0x0,%esi
  801ae3:	bf 0b 00 00 00       	mov    $0xb,%edi
  801ae8:	48 b8 20 19 80 00 00 	movabs $0x801920,%rax
  801aef:	00 00 00 
  801af2:	ff d0                	callq  *%rax
}
  801af4:	c9                   	leaveq 
  801af5:	c3                   	retq   

0000000000801af6 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801af6:	55                   	push   %rbp
  801af7:	48 89 e5             	mov    %rsp,%rbp
  801afa:	48 83 ec 20          	sub    $0x20,%rsp
  801afe:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b01:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b05:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801b08:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b0b:	48 63 c8             	movslq %eax,%rcx
  801b0e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b12:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b15:	48 98                	cltq   
  801b17:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b1e:	00 
  801b1f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b25:	49 89 c8             	mov    %rcx,%r8
  801b28:	48 89 d1             	mov    %rdx,%rcx
  801b2b:	48 89 c2             	mov    %rax,%rdx
  801b2e:	be 01 00 00 00       	mov    $0x1,%esi
  801b33:	bf 04 00 00 00       	mov    $0x4,%edi
  801b38:	48 b8 20 19 80 00 00 	movabs $0x801920,%rax
  801b3f:	00 00 00 
  801b42:	ff d0                	callq  *%rax
}
  801b44:	c9                   	leaveq 
  801b45:	c3                   	retq   

0000000000801b46 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801b46:	55                   	push   %rbp
  801b47:	48 89 e5             	mov    %rsp,%rbp
  801b4a:	48 83 ec 30          	sub    $0x30,%rsp
  801b4e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b51:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b55:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b58:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b5c:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801b60:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b63:	48 63 c8             	movslq %eax,%rcx
  801b66:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801b6a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b6d:	48 63 f0             	movslq %eax,%rsi
  801b70:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b74:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b77:	48 98                	cltq   
  801b79:	48 89 0c 24          	mov    %rcx,(%rsp)
  801b7d:	49 89 f9             	mov    %rdi,%r9
  801b80:	49 89 f0             	mov    %rsi,%r8
  801b83:	48 89 d1             	mov    %rdx,%rcx
  801b86:	48 89 c2             	mov    %rax,%rdx
  801b89:	be 01 00 00 00       	mov    $0x1,%esi
  801b8e:	bf 05 00 00 00       	mov    $0x5,%edi
  801b93:	48 b8 20 19 80 00 00 	movabs $0x801920,%rax
  801b9a:	00 00 00 
  801b9d:	ff d0                	callq  *%rax
}
  801b9f:	c9                   	leaveq 
  801ba0:	c3                   	retq   

0000000000801ba1 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801ba1:	55                   	push   %rbp
  801ba2:	48 89 e5             	mov    %rsp,%rbp
  801ba5:	48 83 ec 20          	sub    $0x20,%rsp
  801ba9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bac:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801bb0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bb4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bb7:	48 98                	cltq   
  801bb9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bc0:	00 
  801bc1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bc7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bcd:	48 89 d1             	mov    %rdx,%rcx
  801bd0:	48 89 c2             	mov    %rax,%rdx
  801bd3:	be 01 00 00 00       	mov    $0x1,%esi
  801bd8:	bf 06 00 00 00       	mov    $0x6,%edi
  801bdd:	48 b8 20 19 80 00 00 	movabs $0x801920,%rax
  801be4:	00 00 00 
  801be7:	ff d0                	callq  *%rax
}
  801be9:	c9                   	leaveq 
  801bea:	c3                   	retq   

0000000000801beb <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801beb:	55                   	push   %rbp
  801bec:	48 89 e5             	mov    %rsp,%rbp
  801bef:	48 83 ec 10          	sub    $0x10,%rsp
  801bf3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bf6:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801bf9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bfc:	48 63 d0             	movslq %eax,%rdx
  801bff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c02:	48 98                	cltq   
  801c04:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c0b:	00 
  801c0c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c12:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c18:	48 89 d1             	mov    %rdx,%rcx
  801c1b:	48 89 c2             	mov    %rax,%rdx
  801c1e:	be 01 00 00 00       	mov    $0x1,%esi
  801c23:	bf 08 00 00 00       	mov    $0x8,%edi
  801c28:	48 b8 20 19 80 00 00 	movabs $0x801920,%rax
  801c2f:	00 00 00 
  801c32:	ff d0                	callq  *%rax
}
  801c34:	c9                   	leaveq 
  801c35:	c3                   	retq   

0000000000801c36 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801c36:	55                   	push   %rbp
  801c37:	48 89 e5             	mov    %rsp,%rbp
  801c3a:	48 83 ec 20          	sub    $0x20,%rsp
  801c3e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c41:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801c45:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c4c:	48 98                	cltq   
  801c4e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c55:	00 
  801c56:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c5c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c62:	48 89 d1             	mov    %rdx,%rcx
  801c65:	48 89 c2             	mov    %rax,%rdx
  801c68:	be 01 00 00 00       	mov    $0x1,%esi
  801c6d:	bf 09 00 00 00       	mov    $0x9,%edi
  801c72:	48 b8 20 19 80 00 00 	movabs $0x801920,%rax
  801c79:	00 00 00 
  801c7c:	ff d0                	callq  *%rax
}
  801c7e:	c9                   	leaveq 
  801c7f:	c3                   	retq   

0000000000801c80 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801c80:	55                   	push   %rbp
  801c81:	48 89 e5             	mov    %rsp,%rbp
  801c84:	48 83 ec 20          	sub    $0x20,%rsp
  801c88:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c8b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801c8f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c96:	48 98                	cltq   
  801c98:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c9f:	00 
  801ca0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ca6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cac:	48 89 d1             	mov    %rdx,%rcx
  801caf:	48 89 c2             	mov    %rax,%rdx
  801cb2:	be 01 00 00 00       	mov    $0x1,%esi
  801cb7:	bf 0a 00 00 00       	mov    $0xa,%edi
  801cbc:	48 b8 20 19 80 00 00 	movabs $0x801920,%rax
  801cc3:	00 00 00 
  801cc6:	ff d0                	callq  *%rax
}
  801cc8:	c9                   	leaveq 
  801cc9:	c3                   	retq   

0000000000801cca <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801cca:	55                   	push   %rbp
  801ccb:	48 89 e5             	mov    %rsp,%rbp
  801cce:	48 83 ec 20          	sub    $0x20,%rsp
  801cd2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cd5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801cd9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801cdd:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801ce0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ce3:	48 63 f0             	movslq %eax,%rsi
  801ce6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801cea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ced:	48 98                	cltq   
  801cef:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cf3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cfa:	00 
  801cfb:	49 89 f1             	mov    %rsi,%r9
  801cfe:	49 89 c8             	mov    %rcx,%r8
  801d01:	48 89 d1             	mov    %rdx,%rcx
  801d04:	48 89 c2             	mov    %rax,%rdx
  801d07:	be 00 00 00 00       	mov    $0x0,%esi
  801d0c:	bf 0c 00 00 00       	mov    $0xc,%edi
  801d11:	48 b8 20 19 80 00 00 	movabs $0x801920,%rax
  801d18:	00 00 00 
  801d1b:	ff d0                	callq  *%rax
}
  801d1d:	c9                   	leaveq 
  801d1e:	c3                   	retq   

0000000000801d1f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801d1f:	55                   	push   %rbp
  801d20:	48 89 e5             	mov    %rsp,%rbp
  801d23:	48 83 ec 10          	sub    $0x10,%rsp
  801d27:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801d2b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d2f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d36:	00 
  801d37:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d3d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d43:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d48:	48 89 c2             	mov    %rax,%rdx
  801d4b:	be 01 00 00 00       	mov    $0x1,%esi
  801d50:	bf 0d 00 00 00       	mov    $0xd,%edi
  801d55:	48 b8 20 19 80 00 00 	movabs $0x801920,%rax
  801d5c:	00 00 00 
  801d5f:	ff d0                	callq  *%rax
}
  801d61:	c9                   	leaveq 
  801d62:	c3                   	retq   

0000000000801d63 <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  801d63:	55                   	push   %rbp
  801d64:	48 89 e5             	mov    %rsp,%rbp
  801d67:	48 83 ec 30          	sub    $0x30,%rsp
  801d6b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801d6f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d73:	48 8b 00             	mov    (%rax),%rax
  801d76:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801d7a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d7e:	48 8b 40 08          	mov    0x8(%rax),%rax
  801d82:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801d85:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801d88:	83 e0 02             	and    $0x2,%eax
  801d8b:	85 c0                	test   %eax,%eax
  801d8d:	75 4d                	jne    801ddc <pgfault+0x79>
  801d8f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d93:	48 c1 e8 0c          	shr    $0xc,%rax
  801d97:	48 89 c2             	mov    %rax,%rdx
  801d9a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801da1:	01 00 00 
  801da4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801da8:	25 00 08 00 00       	and    $0x800,%eax
  801dad:	48 85 c0             	test   %rax,%rax
  801db0:	74 2a                	je     801ddc <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  801db2:	48 ba 50 44 80 00 00 	movabs $0x804450,%rdx
  801db9:	00 00 00 
  801dbc:	be 23 00 00 00       	mov    $0x23,%esi
  801dc1:	48 bf 85 44 80 00 00 	movabs $0x804485,%rdi
  801dc8:	00 00 00 
  801dcb:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd0:	48 b9 d9 03 80 00 00 	movabs $0x8003d9,%rcx
  801dd7:	00 00 00 
  801dda:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  801ddc:	ba 07 00 00 00       	mov    $0x7,%edx
  801de1:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801de6:	bf 00 00 00 00       	mov    $0x0,%edi
  801deb:	48 b8 f6 1a 80 00 00 	movabs $0x801af6,%rax
  801df2:	00 00 00 
  801df5:	ff d0                	callq  *%rax
  801df7:	85 c0                	test   %eax,%eax
  801df9:	0f 85 cd 00 00 00    	jne    801ecc <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801dff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e03:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801e07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e0b:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801e11:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801e15:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e19:	ba 00 10 00 00       	mov    $0x1000,%edx
  801e1e:	48 89 c6             	mov    %rax,%rsi
  801e21:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801e26:	48 b8 eb 14 80 00 00 	movabs $0x8014eb,%rax
  801e2d:	00 00 00 
  801e30:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801e32:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e36:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801e3c:	48 89 c1             	mov    %rax,%rcx
  801e3f:	ba 00 00 00 00       	mov    $0x0,%edx
  801e44:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801e49:	bf 00 00 00 00       	mov    $0x0,%edi
  801e4e:	48 b8 46 1b 80 00 00 	movabs $0x801b46,%rax
  801e55:	00 00 00 
  801e58:	ff d0                	callq  *%rax
  801e5a:	85 c0                	test   %eax,%eax
  801e5c:	79 2a                	jns    801e88 <pgfault+0x125>
				panic("Page map at temp address failed");
  801e5e:	48 ba 90 44 80 00 00 	movabs $0x804490,%rdx
  801e65:	00 00 00 
  801e68:	be 30 00 00 00       	mov    $0x30,%esi
  801e6d:	48 bf 85 44 80 00 00 	movabs $0x804485,%rdi
  801e74:	00 00 00 
  801e77:	b8 00 00 00 00       	mov    $0x0,%eax
  801e7c:	48 b9 d9 03 80 00 00 	movabs $0x8003d9,%rcx
  801e83:	00 00 00 
  801e86:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801e88:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801e8d:	bf 00 00 00 00       	mov    $0x0,%edi
  801e92:	48 b8 a1 1b 80 00 00 	movabs $0x801ba1,%rax
  801e99:	00 00 00 
  801e9c:	ff d0                	callq  *%rax
  801e9e:	85 c0                	test   %eax,%eax
  801ea0:	79 54                	jns    801ef6 <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801ea2:	48 ba b0 44 80 00 00 	movabs $0x8044b0,%rdx
  801ea9:	00 00 00 
  801eac:	be 32 00 00 00       	mov    $0x32,%esi
  801eb1:	48 bf 85 44 80 00 00 	movabs $0x804485,%rdi
  801eb8:	00 00 00 
  801ebb:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec0:	48 b9 d9 03 80 00 00 	movabs $0x8003d9,%rcx
  801ec7:	00 00 00 
  801eca:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  801ecc:	48 ba d8 44 80 00 00 	movabs $0x8044d8,%rdx
  801ed3:	00 00 00 
  801ed6:	be 34 00 00 00       	mov    $0x34,%esi
  801edb:	48 bf 85 44 80 00 00 	movabs $0x804485,%rdi
  801ee2:	00 00 00 
  801ee5:	b8 00 00 00 00       	mov    $0x0,%eax
  801eea:	48 b9 d9 03 80 00 00 	movabs $0x8003d9,%rcx
  801ef1:	00 00 00 
  801ef4:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  801ef6:	c9                   	leaveq 
  801ef7:	c3                   	retq   

0000000000801ef8 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801ef8:	55                   	push   %rbp
  801ef9:	48 89 e5             	mov    %rsp,%rbp
  801efc:	48 83 ec 20          	sub    $0x20,%rsp
  801f00:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f03:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  801f06:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f0d:	01 00 00 
  801f10:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801f13:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f17:	25 07 0e 00 00       	and    $0xe07,%eax
  801f1c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801f1f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801f22:	48 c1 e0 0c          	shl    $0xc,%rax
  801f26:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  801f2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f2d:	25 00 04 00 00       	and    $0x400,%eax
  801f32:	85 c0                	test   %eax,%eax
  801f34:	74 57                	je     801f8d <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801f36:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801f39:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801f3d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801f40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f44:	41 89 f0             	mov    %esi,%r8d
  801f47:	48 89 c6             	mov    %rax,%rsi
  801f4a:	bf 00 00 00 00       	mov    $0x0,%edi
  801f4f:	48 b8 46 1b 80 00 00 	movabs $0x801b46,%rax
  801f56:	00 00 00 
  801f59:	ff d0                	callq  *%rax
  801f5b:	85 c0                	test   %eax,%eax
  801f5d:	0f 8e 52 01 00 00    	jle    8020b5 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801f63:	48 ba 0a 45 80 00 00 	movabs $0x80450a,%rdx
  801f6a:	00 00 00 
  801f6d:	be 4e 00 00 00       	mov    $0x4e,%esi
  801f72:	48 bf 85 44 80 00 00 	movabs $0x804485,%rdi
  801f79:	00 00 00 
  801f7c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f81:	48 b9 d9 03 80 00 00 	movabs $0x8003d9,%rcx
  801f88:	00 00 00 
  801f8b:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  801f8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f90:	83 e0 02             	and    $0x2,%eax
  801f93:	85 c0                	test   %eax,%eax
  801f95:	75 10                	jne    801fa7 <duppage+0xaf>
  801f97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f9a:	25 00 08 00 00       	and    $0x800,%eax
  801f9f:	85 c0                	test   %eax,%eax
  801fa1:	0f 84 bb 00 00 00    	je     802062 <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  801fa7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801faa:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  801faf:	80 cc 08             	or     $0x8,%ah
  801fb2:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801fb5:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801fb8:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801fbc:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801fbf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fc3:	41 89 f0             	mov    %esi,%r8d
  801fc6:	48 89 c6             	mov    %rax,%rsi
  801fc9:	bf 00 00 00 00       	mov    $0x0,%edi
  801fce:	48 b8 46 1b 80 00 00 	movabs $0x801b46,%rax
  801fd5:	00 00 00 
  801fd8:	ff d0                	callq  *%rax
  801fda:	85 c0                	test   %eax,%eax
  801fdc:	7e 2a                	jle    802008 <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  801fde:	48 ba 0a 45 80 00 00 	movabs $0x80450a,%rdx
  801fe5:	00 00 00 
  801fe8:	be 55 00 00 00       	mov    $0x55,%esi
  801fed:	48 bf 85 44 80 00 00 	movabs $0x804485,%rdi
  801ff4:	00 00 00 
  801ff7:	b8 00 00 00 00       	mov    $0x0,%eax
  801ffc:	48 b9 d9 03 80 00 00 	movabs $0x8003d9,%rcx
  802003:	00 00 00 
  802006:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  802008:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  80200b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80200f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802013:	41 89 c8             	mov    %ecx,%r8d
  802016:	48 89 d1             	mov    %rdx,%rcx
  802019:	ba 00 00 00 00       	mov    $0x0,%edx
  80201e:	48 89 c6             	mov    %rax,%rsi
  802021:	bf 00 00 00 00       	mov    $0x0,%edi
  802026:	48 b8 46 1b 80 00 00 	movabs $0x801b46,%rax
  80202d:	00 00 00 
  802030:	ff d0                	callq  *%rax
  802032:	85 c0                	test   %eax,%eax
  802034:	7e 2a                	jle    802060 <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  802036:	48 ba 0a 45 80 00 00 	movabs $0x80450a,%rdx
  80203d:	00 00 00 
  802040:	be 57 00 00 00       	mov    $0x57,%esi
  802045:	48 bf 85 44 80 00 00 	movabs $0x804485,%rdi
  80204c:	00 00 00 
  80204f:	b8 00 00 00 00       	mov    $0x0,%eax
  802054:	48 b9 d9 03 80 00 00 	movabs $0x8003d9,%rcx
  80205b:	00 00 00 
  80205e:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  802060:	eb 53                	jmp    8020b5 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  802062:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802065:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802069:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80206c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802070:	41 89 f0             	mov    %esi,%r8d
  802073:	48 89 c6             	mov    %rax,%rsi
  802076:	bf 00 00 00 00       	mov    $0x0,%edi
  80207b:	48 b8 46 1b 80 00 00 	movabs $0x801b46,%rax
  802082:	00 00 00 
  802085:	ff d0                	callq  *%rax
  802087:	85 c0                	test   %eax,%eax
  802089:	7e 2a                	jle    8020b5 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  80208b:	48 ba 0a 45 80 00 00 	movabs $0x80450a,%rdx
  802092:	00 00 00 
  802095:	be 5b 00 00 00       	mov    $0x5b,%esi
  80209a:	48 bf 85 44 80 00 00 	movabs $0x804485,%rdi
  8020a1:	00 00 00 
  8020a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a9:	48 b9 d9 03 80 00 00 	movabs $0x8003d9,%rcx
  8020b0:	00 00 00 
  8020b3:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  8020b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020ba:	c9                   	leaveq 
  8020bb:	c3                   	retq   

00000000008020bc <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  8020bc:	55                   	push   %rbp
  8020bd:	48 89 e5             	mov    %rsp,%rbp
  8020c0:	48 83 ec 18          	sub    $0x18,%rsp
  8020c4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  8020c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020cc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  8020d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020d4:	48 c1 e8 27          	shr    $0x27,%rax
  8020d8:	48 89 c2             	mov    %rax,%rdx
  8020db:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8020e2:	01 00 00 
  8020e5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020e9:	83 e0 01             	and    $0x1,%eax
  8020ec:	48 85 c0             	test   %rax,%rax
  8020ef:	74 51                	je     802142 <pt_is_mapped+0x86>
  8020f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020f5:	48 c1 e0 0c          	shl    $0xc,%rax
  8020f9:	48 c1 e8 1e          	shr    $0x1e,%rax
  8020fd:	48 89 c2             	mov    %rax,%rdx
  802100:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802107:	01 00 00 
  80210a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80210e:	83 e0 01             	and    $0x1,%eax
  802111:	48 85 c0             	test   %rax,%rax
  802114:	74 2c                	je     802142 <pt_is_mapped+0x86>
  802116:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80211a:	48 c1 e0 0c          	shl    $0xc,%rax
  80211e:	48 c1 e8 15          	shr    $0x15,%rax
  802122:	48 89 c2             	mov    %rax,%rdx
  802125:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80212c:	01 00 00 
  80212f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802133:	83 e0 01             	and    $0x1,%eax
  802136:	48 85 c0             	test   %rax,%rax
  802139:	74 07                	je     802142 <pt_is_mapped+0x86>
  80213b:	b8 01 00 00 00       	mov    $0x1,%eax
  802140:	eb 05                	jmp    802147 <pt_is_mapped+0x8b>
  802142:	b8 00 00 00 00       	mov    $0x0,%eax
  802147:	83 e0 01             	and    $0x1,%eax
}
  80214a:	c9                   	leaveq 
  80214b:	c3                   	retq   

000000000080214c <fork>:

envid_t
fork(void)
{
  80214c:	55                   	push   %rbp
  80214d:	48 89 e5             	mov    %rsp,%rbp
  802150:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  802154:	48 bf 63 1d 80 00 00 	movabs $0x801d63,%rdi
  80215b:	00 00 00 
  80215e:	48 b8 a2 3a 80 00 00 	movabs $0x803aa2,%rax
  802165:	00 00 00 
  802168:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80216a:	b8 07 00 00 00       	mov    $0x7,%eax
  80216f:	cd 30                	int    $0x30
  802171:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802174:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  802177:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  80217a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80217e:	79 30                	jns    8021b0 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  802180:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802183:	89 c1                	mov    %eax,%ecx
  802185:	48 ba 28 45 80 00 00 	movabs $0x804528,%rdx
  80218c:	00 00 00 
  80218f:	be 86 00 00 00       	mov    $0x86,%esi
  802194:	48 bf 85 44 80 00 00 	movabs $0x804485,%rdi
  80219b:	00 00 00 
  80219e:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a3:	49 b8 d9 03 80 00 00 	movabs $0x8003d9,%r8
  8021aa:	00 00 00 
  8021ad:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  8021b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8021b4:	75 46                	jne    8021fc <fork+0xb0>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  8021b6:	48 b8 7a 1a 80 00 00 	movabs $0x801a7a,%rax
  8021bd:	00 00 00 
  8021c0:	ff d0                	callq  *%rax
  8021c2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8021c7:	48 63 d0             	movslq %eax,%rdx
  8021ca:	48 89 d0             	mov    %rdx,%rax
  8021cd:	48 c1 e0 03          	shl    $0x3,%rax
  8021d1:	48 01 d0             	add    %rdx,%rax
  8021d4:	48 c1 e0 05          	shl    $0x5,%rax
  8021d8:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8021df:	00 00 00 
  8021e2:	48 01 c2             	add    %rax,%rdx
  8021e5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8021ec:	00 00 00 
  8021ef:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8021f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f7:	e9 d1 01 00 00       	jmpq   8023cd <fork+0x281>
	}
	uint64_t ad = 0;
  8021fc:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802203:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  802204:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  802209:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80220d:	e9 df 00 00 00       	jmpq   8022f1 <fork+0x1a5>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  802212:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802216:	48 c1 e8 27          	shr    $0x27,%rax
  80221a:	48 89 c2             	mov    %rax,%rdx
  80221d:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802224:	01 00 00 
  802227:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80222b:	83 e0 01             	and    $0x1,%eax
  80222e:	48 85 c0             	test   %rax,%rax
  802231:	0f 84 9e 00 00 00    	je     8022d5 <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  802237:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80223b:	48 c1 e8 1e          	shr    $0x1e,%rax
  80223f:	48 89 c2             	mov    %rax,%rdx
  802242:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802249:	01 00 00 
  80224c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802250:	83 e0 01             	and    $0x1,%eax
  802253:	48 85 c0             	test   %rax,%rax
  802256:	74 73                	je     8022cb <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  802258:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80225c:	48 c1 e8 15          	shr    $0x15,%rax
  802260:	48 89 c2             	mov    %rax,%rdx
  802263:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80226a:	01 00 00 
  80226d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802271:	83 e0 01             	and    $0x1,%eax
  802274:	48 85 c0             	test   %rax,%rax
  802277:	74 48                	je     8022c1 <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  802279:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80227d:	48 c1 e8 0c          	shr    $0xc,%rax
  802281:	48 89 c2             	mov    %rax,%rdx
  802284:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80228b:	01 00 00 
  80228e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802292:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802296:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80229a:	83 e0 01             	and    $0x1,%eax
  80229d:	48 85 c0             	test   %rax,%rax
  8022a0:	74 47                	je     8022e9 <fork+0x19d>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  8022a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022a6:	48 c1 e8 0c          	shr    $0xc,%rax
  8022aa:	89 c2                	mov    %eax,%edx
  8022ac:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8022af:	89 d6                	mov    %edx,%esi
  8022b1:	89 c7                	mov    %eax,%edi
  8022b3:	48 b8 f8 1e 80 00 00 	movabs $0x801ef8,%rax
  8022ba:	00 00 00 
  8022bd:	ff d0                	callq  *%rax
  8022bf:	eb 28                	jmp    8022e9 <fork+0x19d>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  8022c1:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  8022c8:	00 
  8022c9:	eb 1e                	jmp    8022e9 <fork+0x19d>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  8022cb:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  8022d2:	40 
  8022d3:	eb 14                	jmp    8022e9 <fork+0x19d>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  8022d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022d9:	48 c1 e8 27          	shr    $0x27,%rax
  8022dd:	48 83 c0 01          	add    $0x1,%rax
  8022e1:	48 c1 e0 27          	shl    $0x27,%rax
  8022e5:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8022e9:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  8022f0:	00 
  8022f1:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  8022f8:	00 
  8022f9:	0f 87 13 ff ff ff    	ja     802212 <fork+0xc6>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8022ff:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802302:	ba 07 00 00 00       	mov    $0x7,%edx
  802307:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80230c:	89 c7                	mov    %eax,%edi
  80230e:	48 b8 f6 1a 80 00 00 	movabs $0x801af6,%rax
  802315:	00 00 00 
  802318:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  80231a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80231d:	ba 07 00 00 00       	mov    $0x7,%edx
  802322:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802327:	89 c7                	mov    %eax,%edi
  802329:	48 b8 f6 1a 80 00 00 	movabs $0x801af6,%rax
  802330:	00 00 00 
  802333:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  802335:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802338:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80233e:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  802343:	ba 00 00 00 00       	mov    $0x0,%edx
  802348:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80234d:	89 c7                	mov    %eax,%edi
  80234f:	48 b8 46 1b 80 00 00 	movabs $0x801b46,%rax
  802356:	00 00 00 
  802359:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  80235b:	ba 00 10 00 00       	mov    $0x1000,%edx
  802360:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802365:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  80236a:	48 b8 eb 14 80 00 00 	movabs $0x8014eb,%rax
  802371:	00 00 00 
  802374:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  802376:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80237b:	bf 00 00 00 00       	mov    $0x0,%edi
  802380:	48 b8 a1 1b 80 00 00 	movabs $0x801ba1,%rax
  802387:	00 00 00 
  80238a:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  80238c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802393:	00 00 00 
  802396:	48 8b 00             	mov    (%rax),%rax
  802399:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  8023a0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8023a3:	48 89 d6             	mov    %rdx,%rsi
  8023a6:	89 c7                	mov    %eax,%edi
  8023a8:	48 b8 80 1c 80 00 00 	movabs $0x801c80,%rax
  8023af:	00 00 00 
  8023b2:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  8023b4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8023b7:	be 02 00 00 00       	mov    $0x2,%esi
  8023bc:	89 c7                	mov    %eax,%edi
  8023be:	48 b8 eb 1b 80 00 00 	movabs $0x801beb,%rax
  8023c5:	00 00 00 
  8023c8:	ff d0                	callq  *%rax

	return envid;
  8023ca:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  8023cd:	c9                   	leaveq 
  8023ce:	c3                   	retq   

00000000008023cf <sfork>:

	
// Challenge!
int
sfork(void)
{
  8023cf:	55                   	push   %rbp
  8023d0:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8023d3:	48 ba 40 45 80 00 00 	movabs $0x804540,%rdx
  8023da:	00 00 00 
  8023dd:	be bf 00 00 00       	mov    $0xbf,%esi
  8023e2:	48 bf 85 44 80 00 00 	movabs $0x804485,%rdi
  8023e9:	00 00 00 
  8023ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f1:	48 b9 d9 03 80 00 00 	movabs $0x8003d9,%rcx
  8023f8:	00 00 00 
  8023fb:	ff d1                	callq  *%rcx

00000000008023fd <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8023fd:	55                   	push   %rbp
  8023fe:	48 89 e5             	mov    %rsp,%rbp
  802401:	48 83 ec 08          	sub    $0x8,%rsp
  802405:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802409:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80240d:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802414:	ff ff ff 
  802417:	48 01 d0             	add    %rdx,%rax
  80241a:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80241e:	c9                   	leaveq 
  80241f:	c3                   	retq   

0000000000802420 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802420:	55                   	push   %rbp
  802421:	48 89 e5             	mov    %rsp,%rbp
  802424:	48 83 ec 08          	sub    $0x8,%rsp
  802428:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80242c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802430:	48 89 c7             	mov    %rax,%rdi
  802433:	48 b8 fd 23 80 00 00 	movabs $0x8023fd,%rax
  80243a:	00 00 00 
  80243d:	ff d0                	callq  *%rax
  80243f:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802445:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802449:	c9                   	leaveq 
  80244a:	c3                   	retq   

000000000080244b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80244b:	55                   	push   %rbp
  80244c:	48 89 e5             	mov    %rsp,%rbp
  80244f:	48 83 ec 18          	sub    $0x18,%rsp
  802453:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802457:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80245e:	eb 6b                	jmp    8024cb <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802460:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802463:	48 98                	cltq   
  802465:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80246b:	48 c1 e0 0c          	shl    $0xc,%rax
  80246f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802473:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802477:	48 c1 e8 15          	shr    $0x15,%rax
  80247b:	48 89 c2             	mov    %rax,%rdx
  80247e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802485:	01 00 00 
  802488:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80248c:	83 e0 01             	and    $0x1,%eax
  80248f:	48 85 c0             	test   %rax,%rax
  802492:	74 21                	je     8024b5 <fd_alloc+0x6a>
  802494:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802498:	48 c1 e8 0c          	shr    $0xc,%rax
  80249c:	48 89 c2             	mov    %rax,%rdx
  80249f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024a6:	01 00 00 
  8024a9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024ad:	83 e0 01             	and    $0x1,%eax
  8024b0:	48 85 c0             	test   %rax,%rax
  8024b3:	75 12                	jne    8024c7 <fd_alloc+0x7c>
			*fd_store = fd;
  8024b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024b9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8024bd:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8024c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c5:	eb 1a                	jmp    8024e1 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8024c7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8024cb:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8024cf:	7e 8f                	jle    802460 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8024d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024d5:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8024dc:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8024e1:	c9                   	leaveq 
  8024e2:	c3                   	retq   

00000000008024e3 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8024e3:	55                   	push   %rbp
  8024e4:	48 89 e5             	mov    %rsp,%rbp
  8024e7:	48 83 ec 20          	sub    $0x20,%rsp
  8024eb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8024ee:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8024f2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8024f6:	78 06                	js     8024fe <fd_lookup+0x1b>
  8024f8:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8024fc:	7e 07                	jle    802505 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8024fe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802503:	eb 6c                	jmp    802571 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802505:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802508:	48 98                	cltq   
  80250a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802510:	48 c1 e0 0c          	shl    $0xc,%rax
  802514:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802518:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80251c:	48 c1 e8 15          	shr    $0x15,%rax
  802520:	48 89 c2             	mov    %rax,%rdx
  802523:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80252a:	01 00 00 
  80252d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802531:	83 e0 01             	and    $0x1,%eax
  802534:	48 85 c0             	test   %rax,%rax
  802537:	74 21                	je     80255a <fd_lookup+0x77>
  802539:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80253d:	48 c1 e8 0c          	shr    $0xc,%rax
  802541:	48 89 c2             	mov    %rax,%rdx
  802544:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80254b:	01 00 00 
  80254e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802552:	83 e0 01             	and    $0x1,%eax
  802555:	48 85 c0             	test   %rax,%rax
  802558:	75 07                	jne    802561 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80255a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80255f:	eb 10                	jmp    802571 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802561:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802565:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802569:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80256c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802571:	c9                   	leaveq 
  802572:	c3                   	retq   

0000000000802573 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802573:	55                   	push   %rbp
  802574:	48 89 e5             	mov    %rsp,%rbp
  802577:	48 83 ec 30          	sub    $0x30,%rsp
  80257b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80257f:	89 f0                	mov    %esi,%eax
  802581:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802584:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802588:	48 89 c7             	mov    %rax,%rdi
  80258b:	48 b8 fd 23 80 00 00 	movabs $0x8023fd,%rax
  802592:	00 00 00 
  802595:	ff d0                	callq  *%rax
  802597:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80259b:	48 89 d6             	mov    %rdx,%rsi
  80259e:	89 c7                	mov    %eax,%edi
  8025a0:	48 b8 e3 24 80 00 00 	movabs $0x8024e3,%rax
  8025a7:	00 00 00 
  8025aa:	ff d0                	callq  *%rax
  8025ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025b3:	78 0a                	js     8025bf <fd_close+0x4c>
	    || fd != fd2)
  8025b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025b9:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8025bd:	74 12                	je     8025d1 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8025bf:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8025c3:	74 05                	je     8025ca <fd_close+0x57>
  8025c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025c8:	eb 05                	jmp    8025cf <fd_close+0x5c>
  8025ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8025cf:	eb 69                	jmp    80263a <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8025d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025d5:	8b 00                	mov    (%rax),%eax
  8025d7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8025db:	48 89 d6             	mov    %rdx,%rsi
  8025de:	89 c7                	mov    %eax,%edi
  8025e0:	48 b8 3c 26 80 00 00 	movabs $0x80263c,%rax
  8025e7:	00 00 00 
  8025ea:	ff d0                	callq  *%rax
  8025ec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025f3:	78 2a                	js     80261f <fd_close+0xac>
		if (dev->dev_close)
  8025f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025f9:	48 8b 40 20          	mov    0x20(%rax),%rax
  8025fd:	48 85 c0             	test   %rax,%rax
  802600:	74 16                	je     802618 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802602:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802606:	48 8b 40 20          	mov    0x20(%rax),%rax
  80260a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80260e:	48 89 d7             	mov    %rdx,%rdi
  802611:	ff d0                	callq  *%rax
  802613:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802616:	eb 07                	jmp    80261f <fd_close+0xac>
		else
			r = 0;
  802618:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80261f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802623:	48 89 c6             	mov    %rax,%rsi
  802626:	bf 00 00 00 00       	mov    $0x0,%edi
  80262b:	48 b8 a1 1b 80 00 00 	movabs $0x801ba1,%rax
  802632:	00 00 00 
  802635:	ff d0                	callq  *%rax
	return r;
  802637:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80263a:	c9                   	leaveq 
  80263b:	c3                   	retq   

000000000080263c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80263c:	55                   	push   %rbp
  80263d:	48 89 e5             	mov    %rsp,%rbp
  802640:	48 83 ec 20          	sub    $0x20,%rsp
  802644:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802647:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80264b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802652:	eb 41                	jmp    802695 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802654:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80265b:	00 00 00 
  80265e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802661:	48 63 d2             	movslq %edx,%rdx
  802664:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802668:	8b 00                	mov    (%rax),%eax
  80266a:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80266d:	75 22                	jne    802691 <dev_lookup+0x55>
			*dev = devtab[i];
  80266f:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802676:	00 00 00 
  802679:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80267c:	48 63 d2             	movslq %edx,%rdx
  80267f:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802683:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802687:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80268a:	b8 00 00 00 00       	mov    $0x0,%eax
  80268f:	eb 60                	jmp    8026f1 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802691:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802695:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80269c:	00 00 00 
  80269f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026a2:	48 63 d2             	movslq %edx,%rdx
  8026a5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026a9:	48 85 c0             	test   %rax,%rax
  8026ac:	75 a6                	jne    802654 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8026ae:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8026b5:	00 00 00 
  8026b8:	48 8b 00             	mov    (%rax),%rax
  8026bb:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8026c1:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8026c4:	89 c6                	mov    %eax,%esi
  8026c6:	48 bf 58 45 80 00 00 	movabs $0x804558,%rdi
  8026cd:	00 00 00 
  8026d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d5:	48 b9 12 06 80 00 00 	movabs $0x800612,%rcx
  8026dc:	00 00 00 
  8026df:	ff d1                	callq  *%rcx
	*dev = 0;
  8026e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026e5:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8026ec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8026f1:	c9                   	leaveq 
  8026f2:	c3                   	retq   

00000000008026f3 <close>:

int
close(int fdnum)
{
  8026f3:	55                   	push   %rbp
  8026f4:	48 89 e5             	mov    %rsp,%rbp
  8026f7:	48 83 ec 20          	sub    $0x20,%rsp
  8026fb:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026fe:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802702:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802705:	48 89 d6             	mov    %rdx,%rsi
  802708:	89 c7                	mov    %eax,%edi
  80270a:	48 b8 e3 24 80 00 00 	movabs $0x8024e3,%rax
  802711:	00 00 00 
  802714:	ff d0                	callq  *%rax
  802716:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802719:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80271d:	79 05                	jns    802724 <close+0x31>
		return r;
  80271f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802722:	eb 18                	jmp    80273c <close+0x49>
	else
		return fd_close(fd, 1);
  802724:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802728:	be 01 00 00 00       	mov    $0x1,%esi
  80272d:	48 89 c7             	mov    %rax,%rdi
  802730:	48 b8 73 25 80 00 00 	movabs $0x802573,%rax
  802737:	00 00 00 
  80273a:	ff d0                	callq  *%rax
}
  80273c:	c9                   	leaveq 
  80273d:	c3                   	retq   

000000000080273e <close_all>:

void
close_all(void)
{
  80273e:	55                   	push   %rbp
  80273f:	48 89 e5             	mov    %rsp,%rbp
  802742:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802746:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80274d:	eb 15                	jmp    802764 <close_all+0x26>
		close(i);
  80274f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802752:	89 c7                	mov    %eax,%edi
  802754:	48 b8 f3 26 80 00 00 	movabs $0x8026f3,%rax
  80275b:	00 00 00 
  80275e:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802760:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802764:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802768:	7e e5                	jle    80274f <close_all+0x11>
		close(i);
}
  80276a:	c9                   	leaveq 
  80276b:	c3                   	retq   

000000000080276c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80276c:	55                   	push   %rbp
  80276d:	48 89 e5             	mov    %rsp,%rbp
  802770:	48 83 ec 40          	sub    $0x40,%rsp
  802774:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802777:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80277a:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80277e:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802781:	48 89 d6             	mov    %rdx,%rsi
  802784:	89 c7                	mov    %eax,%edi
  802786:	48 b8 e3 24 80 00 00 	movabs $0x8024e3,%rax
  80278d:	00 00 00 
  802790:	ff d0                	callq  *%rax
  802792:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802795:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802799:	79 08                	jns    8027a3 <dup+0x37>
		return r;
  80279b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80279e:	e9 70 01 00 00       	jmpq   802913 <dup+0x1a7>
	close(newfdnum);
  8027a3:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8027a6:	89 c7                	mov    %eax,%edi
  8027a8:	48 b8 f3 26 80 00 00 	movabs $0x8026f3,%rax
  8027af:	00 00 00 
  8027b2:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8027b4:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8027b7:	48 98                	cltq   
  8027b9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8027bf:	48 c1 e0 0c          	shl    $0xc,%rax
  8027c3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8027c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027cb:	48 89 c7             	mov    %rax,%rdi
  8027ce:	48 b8 20 24 80 00 00 	movabs $0x802420,%rax
  8027d5:	00 00 00 
  8027d8:	ff d0                	callq  *%rax
  8027da:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8027de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027e2:	48 89 c7             	mov    %rax,%rdi
  8027e5:	48 b8 20 24 80 00 00 	movabs $0x802420,%rax
  8027ec:	00 00 00 
  8027ef:	ff d0                	callq  *%rax
  8027f1:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8027f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027f9:	48 c1 e8 15          	shr    $0x15,%rax
  8027fd:	48 89 c2             	mov    %rax,%rdx
  802800:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802807:	01 00 00 
  80280a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80280e:	83 e0 01             	and    $0x1,%eax
  802811:	48 85 c0             	test   %rax,%rax
  802814:	74 73                	je     802889 <dup+0x11d>
  802816:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80281a:	48 c1 e8 0c          	shr    $0xc,%rax
  80281e:	48 89 c2             	mov    %rax,%rdx
  802821:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802828:	01 00 00 
  80282b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80282f:	83 e0 01             	and    $0x1,%eax
  802832:	48 85 c0             	test   %rax,%rax
  802835:	74 52                	je     802889 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802837:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80283b:	48 c1 e8 0c          	shr    $0xc,%rax
  80283f:	48 89 c2             	mov    %rax,%rdx
  802842:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802849:	01 00 00 
  80284c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802850:	25 07 0e 00 00       	and    $0xe07,%eax
  802855:	89 c1                	mov    %eax,%ecx
  802857:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80285b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80285f:	41 89 c8             	mov    %ecx,%r8d
  802862:	48 89 d1             	mov    %rdx,%rcx
  802865:	ba 00 00 00 00       	mov    $0x0,%edx
  80286a:	48 89 c6             	mov    %rax,%rsi
  80286d:	bf 00 00 00 00       	mov    $0x0,%edi
  802872:	48 b8 46 1b 80 00 00 	movabs $0x801b46,%rax
  802879:	00 00 00 
  80287c:	ff d0                	callq  *%rax
  80287e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802881:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802885:	79 02                	jns    802889 <dup+0x11d>
			goto err;
  802887:	eb 57                	jmp    8028e0 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802889:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80288d:	48 c1 e8 0c          	shr    $0xc,%rax
  802891:	48 89 c2             	mov    %rax,%rdx
  802894:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80289b:	01 00 00 
  80289e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028a2:	25 07 0e 00 00       	and    $0xe07,%eax
  8028a7:	89 c1                	mov    %eax,%ecx
  8028a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028ad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8028b1:	41 89 c8             	mov    %ecx,%r8d
  8028b4:	48 89 d1             	mov    %rdx,%rcx
  8028b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8028bc:	48 89 c6             	mov    %rax,%rsi
  8028bf:	bf 00 00 00 00       	mov    $0x0,%edi
  8028c4:	48 b8 46 1b 80 00 00 	movabs $0x801b46,%rax
  8028cb:	00 00 00 
  8028ce:	ff d0                	callq  *%rax
  8028d0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028d7:	79 02                	jns    8028db <dup+0x16f>
		goto err;
  8028d9:	eb 05                	jmp    8028e0 <dup+0x174>

	return newfdnum;
  8028db:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8028de:	eb 33                	jmp    802913 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8028e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028e4:	48 89 c6             	mov    %rax,%rsi
  8028e7:	bf 00 00 00 00       	mov    $0x0,%edi
  8028ec:	48 b8 a1 1b 80 00 00 	movabs $0x801ba1,%rax
  8028f3:	00 00 00 
  8028f6:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8028f8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028fc:	48 89 c6             	mov    %rax,%rsi
  8028ff:	bf 00 00 00 00       	mov    $0x0,%edi
  802904:	48 b8 a1 1b 80 00 00 	movabs $0x801ba1,%rax
  80290b:	00 00 00 
  80290e:	ff d0                	callq  *%rax
	return r;
  802910:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802913:	c9                   	leaveq 
  802914:	c3                   	retq   

0000000000802915 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802915:	55                   	push   %rbp
  802916:	48 89 e5             	mov    %rsp,%rbp
  802919:	48 83 ec 40          	sub    $0x40,%rsp
  80291d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802920:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802924:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802928:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80292c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80292f:	48 89 d6             	mov    %rdx,%rsi
  802932:	89 c7                	mov    %eax,%edi
  802934:	48 b8 e3 24 80 00 00 	movabs $0x8024e3,%rax
  80293b:	00 00 00 
  80293e:	ff d0                	callq  *%rax
  802940:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802943:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802947:	78 24                	js     80296d <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802949:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80294d:	8b 00                	mov    (%rax),%eax
  80294f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802953:	48 89 d6             	mov    %rdx,%rsi
  802956:	89 c7                	mov    %eax,%edi
  802958:	48 b8 3c 26 80 00 00 	movabs $0x80263c,%rax
  80295f:	00 00 00 
  802962:	ff d0                	callq  *%rax
  802964:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802967:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80296b:	79 05                	jns    802972 <read+0x5d>
		return r;
  80296d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802970:	eb 76                	jmp    8029e8 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802972:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802976:	8b 40 08             	mov    0x8(%rax),%eax
  802979:	83 e0 03             	and    $0x3,%eax
  80297c:	83 f8 01             	cmp    $0x1,%eax
  80297f:	75 3a                	jne    8029bb <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802981:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802988:	00 00 00 
  80298b:	48 8b 00             	mov    (%rax),%rax
  80298e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802994:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802997:	89 c6                	mov    %eax,%esi
  802999:	48 bf 77 45 80 00 00 	movabs $0x804577,%rdi
  8029a0:	00 00 00 
  8029a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a8:	48 b9 12 06 80 00 00 	movabs $0x800612,%rcx
  8029af:	00 00 00 
  8029b2:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8029b4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029b9:	eb 2d                	jmp    8029e8 <read+0xd3>
	}
	if (!dev->dev_read)
  8029bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029bf:	48 8b 40 10          	mov    0x10(%rax),%rax
  8029c3:	48 85 c0             	test   %rax,%rax
  8029c6:	75 07                	jne    8029cf <read+0xba>
		return -E_NOT_SUPP;
  8029c8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8029cd:	eb 19                	jmp    8029e8 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8029cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029d3:	48 8b 40 10          	mov    0x10(%rax),%rax
  8029d7:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8029db:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8029df:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8029e3:	48 89 cf             	mov    %rcx,%rdi
  8029e6:	ff d0                	callq  *%rax
}
  8029e8:	c9                   	leaveq 
  8029e9:	c3                   	retq   

00000000008029ea <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8029ea:	55                   	push   %rbp
  8029eb:	48 89 e5             	mov    %rsp,%rbp
  8029ee:	48 83 ec 30          	sub    $0x30,%rsp
  8029f2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8029f5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8029f9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8029fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a04:	eb 49                	jmp    802a4f <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802a06:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a09:	48 98                	cltq   
  802a0b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a0f:	48 29 c2             	sub    %rax,%rdx
  802a12:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a15:	48 63 c8             	movslq %eax,%rcx
  802a18:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a1c:	48 01 c1             	add    %rax,%rcx
  802a1f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a22:	48 89 ce             	mov    %rcx,%rsi
  802a25:	89 c7                	mov    %eax,%edi
  802a27:	48 b8 15 29 80 00 00 	movabs $0x802915,%rax
  802a2e:	00 00 00 
  802a31:	ff d0                	callq  *%rax
  802a33:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802a36:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802a3a:	79 05                	jns    802a41 <readn+0x57>
			return m;
  802a3c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a3f:	eb 1c                	jmp    802a5d <readn+0x73>
		if (m == 0)
  802a41:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802a45:	75 02                	jne    802a49 <readn+0x5f>
			break;
  802a47:	eb 11                	jmp    802a5a <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802a49:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a4c:	01 45 fc             	add    %eax,-0x4(%rbp)
  802a4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a52:	48 98                	cltq   
  802a54:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802a58:	72 ac                	jb     802a06 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802a5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802a5d:	c9                   	leaveq 
  802a5e:	c3                   	retq   

0000000000802a5f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802a5f:	55                   	push   %rbp
  802a60:	48 89 e5             	mov    %rsp,%rbp
  802a63:	48 83 ec 40          	sub    $0x40,%rsp
  802a67:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a6a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802a6e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a72:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a76:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a79:	48 89 d6             	mov    %rdx,%rsi
  802a7c:	89 c7                	mov    %eax,%edi
  802a7e:	48 b8 e3 24 80 00 00 	movabs $0x8024e3,%rax
  802a85:	00 00 00 
  802a88:	ff d0                	callq  *%rax
  802a8a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a8d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a91:	78 24                	js     802ab7 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a97:	8b 00                	mov    (%rax),%eax
  802a99:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a9d:	48 89 d6             	mov    %rdx,%rsi
  802aa0:	89 c7                	mov    %eax,%edi
  802aa2:	48 b8 3c 26 80 00 00 	movabs $0x80263c,%rax
  802aa9:	00 00 00 
  802aac:	ff d0                	callq  *%rax
  802aae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ab1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ab5:	79 05                	jns    802abc <write+0x5d>
		return r;
  802ab7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aba:	eb 75                	jmp    802b31 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802abc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ac0:	8b 40 08             	mov    0x8(%rax),%eax
  802ac3:	83 e0 03             	and    $0x3,%eax
  802ac6:	85 c0                	test   %eax,%eax
  802ac8:	75 3a                	jne    802b04 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802aca:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802ad1:	00 00 00 
  802ad4:	48 8b 00             	mov    (%rax),%rax
  802ad7:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802add:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802ae0:	89 c6                	mov    %eax,%esi
  802ae2:	48 bf 93 45 80 00 00 	movabs $0x804593,%rdi
  802ae9:	00 00 00 
  802aec:	b8 00 00 00 00       	mov    $0x0,%eax
  802af1:	48 b9 12 06 80 00 00 	movabs $0x800612,%rcx
  802af8:	00 00 00 
  802afb:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802afd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b02:	eb 2d                	jmp    802b31 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802b04:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b08:	48 8b 40 18          	mov    0x18(%rax),%rax
  802b0c:	48 85 c0             	test   %rax,%rax
  802b0f:	75 07                	jne    802b18 <write+0xb9>
		return -E_NOT_SUPP;
  802b11:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b16:	eb 19                	jmp    802b31 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802b18:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b1c:	48 8b 40 18          	mov    0x18(%rax),%rax
  802b20:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802b24:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b28:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802b2c:	48 89 cf             	mov    %rcx,%rdi
  802b2f:	ff d0                	callq  *%rax
}
  802b31:	c9                   	leaveq 
  802b32:	c3                   	retq   

0000000000802b33 <seek>:

int
seek(int fdnum, off_t offset)
{
  802b33:	55                   	push   %rbp
  802b34:	48 89 e5             	mov    %rsp,%rbp
  802b37:	48 83 ec 18          	sub    $0x18,%rsp
  802b3b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b3e:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b41:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b45:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b48:	48 89 d6             	mov    %rdx,%rsi
  802b4b:	89 c7                	mov    %eax,%edi
  802b4d:	48 b8 e3 24 80 00 00 	movabs $0x8024e3,%rax
  802b54:	00 00 00 
  802b57:	ff d0                	callq  *%rax
  802b59:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b5c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b60:	79 05                	jns    802b67 <seek+0x34>
		return r;
  802b62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b65:	eb 0f                	jmp    802b76 <seek+0x43>
	fd->fd_offset = offset;
  802b67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b6b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802b6e:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802b71:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b76:	c9                   	leaveq 
  802b77:	c3                   	retq   

0000000000802b78 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802b78:	55                   	push   %rbp
  802b79:	48 89 e5             	mov    %rsp,%rbp
  802b7c:	48 83 ec 30          	sub    $0x30,%rsp
  802b80:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b83:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b86:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b8a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b8d:	48 89 d6             	mov    %rdx,%rsi
  802b90:	89 c7                	mov    %eax,%edi
  802b92:	48 b8 e3 24 80 00 00 	movabs $0x8024e3,%rax
  802b99:	00 00 00 
  802b9c:	ff d0                	callq  *%rax
  802b9e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ba1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ba5:	78 24                	js     802bcb <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ba7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bab:	8b 00                	mov    (%rax),%eax
  802bad:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802bb1:	48 89 d6             	mov    %rdx,%rsi
  802bb4:	89 c7                	mov    %eax,%edi
  802bb6:	48 b8 3c 26 80 00 00 	movabs $0x80263c,%rax
  802bbd:	00 00 00 
  802bc0:	ff d0                	callq  *%rax
  802bc2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bc5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bc9:	79 05                	jns    802bd0 <ftruncate+0x58>
		return r;
  802bcb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bce:	eb 72                	jmp    802c42 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802bd0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bd4:	8b 40 08             	mov    0x8(%rax),%eax
  802bd7:	83 e0 03             	and    $0x3,%eax
  802bda:	85 c0                	test   %eax,%eax
  802bdc:	75 3a                	jne    802c18 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802bde:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802be5:	00 00 00 
  802be8:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802beb:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802bf1:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802bf4:	89 c6                	mov    %eax,%esi
  802bf6:	48 bf b0 45 80 00 00 	movabs $0x8045b0,%rdi
  802bfd:	00 00 00 
  802c00:	b8 00 00 00 00       	mov    $0x0,%eax
  802c05:	48 b9 12 06 80 00 00 	movabs $0x800612,%rcx
  802c0c:	00 00 00 
  802c0f:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802c11:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c16:	eb 2a                	jmp    802c42 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802c18:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c1c:	48 8b 40 30          	mov    0x30(%rax),%rax
  802c20:	48 85 c0             	test   %rax,%rax
  802c23:	75 07                	jne    802c2c <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802c25:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c2a:	eb 16                	jmp    802c42 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802c2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c30:	48 8b 40 30          	mov    0x30(%rax),%rax
  802c34:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c38:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802c3b:	89 ce                	mov    %ecx,%esi
  802c3d:	48 89 d7             	mov    %rdx,%rdi
  802c40:	ff d0                	callq  *%rax
}
  802c42:	c9                   	leaveq 
  802c43:	c3                   	retq   

0000000000802c44 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802c44:	55                   	push   %rbp
  802c45:	48 89 e5             	mov    %rsp,%rbp
  802c48:	48 83 ec 30          	sub    $0x30,%rsp
  802c4c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c4f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c53:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c57:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c5a:	48 89 d6             	mov    %rdx,%rsi
  802c5d:	89 c7                	mov    %eax,%edi
  802c5f:	48 b8 e3 24 80 00 00 	movabs $0x8024e3,%rax
  802c66:	00 00 00 
  802c69:	ff d0                	callq  *%rax
  802c6b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c6e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c72:	78 24                	js     802c98 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c78:	8b 00                	mov    (%rax),%eax
  802c7a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c7e:	48 89 d6             	mov    %rdx,%rsi
  802c81:	89 c7                	mov    %eax,%edi
  802c83:	48 b8 3c 26 80 00 00 	movabs $0x80263c,%rax
  802c8a:	00 00 00 
  802c8d:	ff d0                	callq  *%rax
  802c8f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c92:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c96:	79 05                	jns    802c9d <fstat+0x59>
		return r;
  802c98:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c9b:	eb 5e                	jmp    802cfb <fstat+0xb7>
	if (!dev->dev_stat)
  802c9d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ca1:	48 8b 40 28          	mov    0x28(%rax),%rax
  802ca5:	48 85 c0             	test   %rax,%rax
  802ca8:	75 07                	jne    802cb1 <fstat+0x6d>
		return -E_NOT_SUPP;
  802caa:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802caf:	eb 4a                	jmp    802cfb <fstat+0xb7>
	stat->st_name[0] = 0;
  802cb1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802cb5:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802cb8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802cbc:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802cc3:	00 00 00 
	stat->st_isdir = 0;
  802cc6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802cca:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802cd1:	00 00 00 
	stat->st_dev = dev;
  802cd4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802cd8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802cdc:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802ce3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ce7:	48 8b 40 28          	mov    0x28(%rax),%rax
  802ceb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802cef:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802cf3:	48 89 ce             	mov    %rcx,%rsi
  802cf6:	48 89 d7             	mov    %rdx,%rdi
  802cf9:	ff d0                	callq  *%rax
}
  802cfb:	c9                   	leaveq 
  802cfc:	c3                   	retq   

0000000000802cfd <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802cfd:	55                   	push   %rbp
  802cfe:	48 89 e5             	mov    %rsp,%rbp
  802d01:	48 83 ec 20          	sub    $0x20,%rsp
  802d05:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d09:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802d0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d11:	be 00 00 00 00       	mov    $0x0,%esi
  802d16:	48 89 c7             	mov    %rax,%rdi
  802d19:	48 b8 eb 2d 80 00 00 	movabs $0x802deb,%rax
  802d20:	00 00 00 
  802d23:	ff d0                	callq  *%rax
  802d25:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d28:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d2c:	79 05                	jns    802d33 <stat+0x36>
		return fd;
  802d2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d31:	eb 2f                	jmp    802d62 <stat+0x65>
	r = fstat(fd, stat);
  802d33:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802d37:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d3a:	48 89 d6             	mov    %rdx,%rsi
  802d3d:	89 c7                	mov    %eax,%edi
  802d3f:	48 b8 44 2c 80 00 00 	movabs $0x802c44,%rax
  802d46:	00 00 00 
  802d49:	ff d0                	callq  *%rax
  802d4b:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802d4e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d51:	89 c7                	mov    %eax,%edi
  802d53:	48 b8 f3 26 80 00 00 	movabs $0x8026f3,%rax
  802d5a:	00 00 00 
  802d5d:	ff d0                	callq  *%rax
	return r;
  802d5f:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802d62:	c9                   	leaveq 
  802d63:	c3                   	retq   

0000000000802d64 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802d64:	55                   	push   %rbp
  802d65:	48 89 e5             	mov    %rsp,%rbp
  802d68:	48 83 ec 10          	sub    $0x10,%rsp
  802d6c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802d6f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802d73:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802d7a:	00 00 00 
  802d7d:	8b 00                	mov    (%rax),%eax
  802d7f:	85 c0                	test   %eax,%eax
  802d81:	75 1d                	jne    802da0 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802d83:	bf 01 00 00 00       	mov    $0x1,%edi
  802d88:	48 b8 4a 3d 80 00 00 	movabs $0x803d4a,%rax
  802d8f:	00 00 00 
  802d92:	ff d0                	callq  *%rax
  802d94:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802d9b:	00 00 00 
  802d9e:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802da0:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802da7:	00 00 00 
  802daa:	8b 00                	mov    (%rax),%eax
  802dac:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802daf:	b9 07 00 00 00       	mov    $0x7,%ecx
  802db4:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802dbb:	00 00 00 
  802dbe:	89 c7                	mov    %eax,%edi
  802dc0:	48 b8 e8 3c 80 00 00 	movabs $0x803ce8,%rax
  802dc7:	00 00 00 
  802dca:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802dcc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dd0:	ba 00 00 00 00       	mov    $0x0,%edx
  802dd5:	48 89 c6             	mov    %rax,%rsi
  802dd8:	bf 00 00 00 00       	mov    $0x0,%edi
  802ddd:	48 b8 e2 3b 80 00 00 	movabs $0x803be2,%rax
  802de4:	00 00 00 
  802de7:	ff d0                	callq  *%rax
}
  802de9:	c9                   	leaveq 
  802dea:	c3                   	retq   

0000000000802deb <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802deb:	55                   	push   %rbp
  802dec:	48 89 e5             	mov    %rsp,%rbp
  802def:	48 83 ec 30          	sub    $0x30,%rsp
  802df3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802df7:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802dfa:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802e01:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802e08:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802e0f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802e14:	75 08                	jne    802e1e <open+0x33>
	{
		return r;
  802e16:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e19:	e9 f2 00 00 00       	jmpq   802f10 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802e1e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e22:	48 89 c7             	mov    %rax,%rdi
  802e25:	48 b8 5b 11 80 00 00 	movabs $0x80115b,%rax
  802e2c:	00 00 00 
  802e2f:	ff d0                	callq  *%rax
  802e31:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802e34:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802e3b:	7e 0a                	jle    802e47 <open+0x5c>
	{
		return -E_BAD_PATH;
  802e3d:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802e42:	e9 c9 00 00 00       	jmpq   802f10 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802e47:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802e4e:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802e4f:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802e53:	48 89 c7             	mov    %rax,%rdi
  802e56:	48 b8 4b 24 80 00 00 	movabs $0x80244b,%rax
  802e5d:	00 00 00 
  802e60:	ff d0                	callq  *%rax
  802e62:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e65:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e69:	78 09                	js     802e74 <open+0x89>
  802e6b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e6f:	48 85 c0             	test   %rax,%rax
  802e72:	75 08                	jne    802e7c <open+0x91>
		{
			return r;
  802e74:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e77:	e9 94 00 00 00       	jmpq   802f10 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802e7c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e80:	ba 00 04 00 00       	mov    $0x400,%edx
  802e85:	48 89 c6             	mov    %rax,%rsi
  802e88:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802e8f:	00 00 00 
  802e92:	48 b8 59 12 80 00 00 	movabs $0x801259,%rax
  802e99:	00 00 00 
  802e9c:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802e9e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ea5:	00 00 00 
  802ea8:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802eab:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802eb1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eb5:	48 89 c6             	mov    %rax,%rsi
  802eb8:	bf 01 00 00 00       	mov    $0x1,%edi
  802ebd:	48 b8 64 2d 80 00 00 	movabs $0x802d64,%rax
  802ec4:	00 00 00 
  802ec7:	ff d0                	callq  *%rax
  802ec9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ecc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ed0:	79 2b                	jns    802efd <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802ed2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ed6:	be 00 00 00 00       	mov    $0x0,%esi
  802edb:	48 89 c7             	mov    %rax,%rdi
  802ede:	48 b8 73 25 80 00 00 	movabs $0x802573,%rax
  802ee5:	00 00 00 
  802ee8:	ff d0                	callq  *%rax
  802eea:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802eed:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ef1:	79 05                	jns    802ef8 <open+0x10d>
			{
				return d;
  802ef3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ef6:	eb 18                	jmp    802f10 <open+0x125>
			}
			return r;
  802ef8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802efb:	eb 13                	jmp    802f10 <open+0x125>
		}	
		return fd2num(fd_store);
  802efd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f01:	48 89 c7             	mov    %rax,%rdi
  802f04:	48 b8 fd 23 80 00 00 	movabs $0x8023fd,%rax
  802f0b:	00 00 00 
  802f0e:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802f10:	c9                   	leaveq 
  802f11:	c3                   	retq   

0000000000802f12 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802f12:	55                   	push   %rbp
  802f13:	48 89 e5             	mov    %rsp,%rbp
  802f16:	48 83 ec 10          	sub    $0x10,%rsp
  802f1a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802f1e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f22:	8b 50 0c             	mov    0xc(%rax),%edx
  802f25:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f2c:	00 00 00 
  802f2f:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802f31:	be 00 00 00 00       	mov    $0x0,%esi
  802f36:	bf 06 00 00 00       	mov    $0x6,%edi
  802f3b:	48 b8 64 2d 80 00 00 	movabs $0x802d64,%rax
  802f42:	00 00 00 
  802f45:	ff d0                	callq  *%rax
}
  802f47:	c9                   	leaveq 
  802f48:	c3                   	retq   

0000000000802f49 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802f49:	55                   	push   %rbp
  802f4a:	48 89 e5             	mov    %rsp,%rbp
  802f4d:	48 83 ec 30          	sub    $0x30,%rsp
  802f51:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f55:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f59:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802f5d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802f64:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802f69:	74 07                	je     802f72 <devfile_read+0x29>
  802f6b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802f70:	75 07                	jne    802f79 <devfile_read+0x30>
		return -E_INVAL;
  802f72:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802f77:	eb 77                	jmp    802ff0 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802f79:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f7d:	8b 50 0c             	mov    0xc(%rax),%edx
  802f80:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f87:	00 00 00 
  802f8a:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802f8c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f93:	00 00 00 
  802f96:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f9a:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802f9e:	be 00 00 00 00       	mov    $0x0,%esi
  802fa3:	bf 03 00 00 00       	mov    $0x3,%edi
  802fa8:	48 b8 64 2d 80 00 00 	movabs $0x802d64,%rax
  802faf:	00 00 00 
  802fb2:	ff d0                	callq  *%rax
  802fb4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fb7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fbb:	7f 05                	jg     802fc2 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802fbd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fc0:	eb 2e                	jmp    802ff0 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802fc2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fc5:	48 63 d0             	movslq %eax,%rdx
  802fc8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fcc:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802fd3:	00 00 00 
  802fd6:	48 89 c7             	mov    %rax,%rdi
  802fd9:	48 b8 eb 14 80 00 00 	movabs $0x8014eb,%rax
  802fe0:	00 00 00 
  802fe3:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802fe5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fe9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802fed:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802ff0:	c9                   	leaveq 
  802ff1:	c3                   	retq   

0000000000802ff2 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802ff2:	55                   	push   %rbp
  802ff3:	48 89 e5             	mov    %rsp,%rbp
  802ff6:	48 83 ec 30          	sub    $0x30,%rsp
  802ffa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ffe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803002:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  803006:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  80300d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803012:	74 07                	je     80301b <devfile_write+0x29>
  803014:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803019:	75 08                	jne    803023 <devfile_write+0x31>
		return r;
  80301b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80301e:	e9 9a 00 00 00       	jmpq   8030bd <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  803023:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803027:	8b 50 0c             	mov    0xc(%rax),%edx
  80302a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803031:	00 00 00 
  803034:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  803036:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  80303d:	00 
  80303e:	76 08                	jbe    803048 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  803040:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  803047:	00 
	}
	fsipcbuf.write.req_n = n;
  803048:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80304f:	00 00 00 
  803052:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803056:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  80305a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80305e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803062:	48 89 c6             	mov    %rax,%rsi
  803065:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  80306c:	00 00 00 
  80306f:	48 b8 eb 14 80 00 00 	movabs $0x8014eb,%rax
  803076:	00 00 00 
  803079:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  80307b:	be 00 00 00 00       	mov    $0x0,%esi
  803080:	bf 04 00 00 00       	mov    $0x4,%edi
  803085:	48 b8 64 2d 80 00 00 	movabs $0x802d64,%rax
  80308c:	00 00 00 
  80308f:	ff d0                	callq  *%rax
  803091:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803094:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803098:	7f 20                	jg     8030ba <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  80309a:	48 bf d6 45 80 00 00 	movabs $0x8045d6,%rdi
  8030a1:	00 00 00 
  8030a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8030a9:	48 ba 12 06 80 00 00 	movabs $0x800612,%rdx
  8030b0:	00 00 00 
  8030b3:	ff d2                	callq  *%rdx
		return r;
  8030b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030b8:	eb 03                	jmp    8030bd <devfile_write+0xcb>
	}
	return r;
  8030ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  8030bd:	c9                   	leaveq 
  8030be:	c3                   	retq   

00000000008030bf <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8030bf:	55                   	push   %rbp
  8030c0:	48 89 e5             	mov    %rsp,%rbp
  8030c3:	48 83 ec 20          	sub    $0x20,%rsp
  8030c7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030cb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8030cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030d3:	8b 50 0c             	mov    0xc(%rax),%edx
  8030d6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030dd:	00 00 00 
  8030e0:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8030e2:	be 00 00 00 00       	mov    $0x0,%esi
  8030e7:	bf 05 00 00 00       	mov    $0x5,%edi
  8030ec:	48 b8 64 2d 80 00 00 	movabs $0x802d64,%rax
  8030f3:	00 00 00 
  8030f6:	ff d0                	callq  *%rax
  8030f8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030ff:	79 05                	jns    803106 <devfile_stat+0x47>
		return r;
  803101:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803104:	eb 56                	jmp    80315c <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803106:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80310a:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803111:	00 00 00 
  803114:	48 89 c7             	mov    %rax,%rdi
  803117:	48 b8 c7 11 80 00 00 	movabs $0x8011c7,%rax
  80311e:	00 00 00 
  803121:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803123:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80312a:	00 00 00 
  80312d:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803133:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803137:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80313d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803144:	00 00 00 
  803147:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80314d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803151:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803157:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80315c:	c9                   	leaveq 
  80315d:	c3                   	retq   

000000000080315e <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80315e:	55                   	push   %rbp
  80315f:	48 89 e5             	mov    %rsp,%rbp
  803162:	48 83 ec 10          	sub    $0x10,%rsp
  803166:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80316a:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80316d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803171:	8b 50 0c             	mov    0xc(%rax),%edx
  803174:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80317b:	00 00 00 
  80317e:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803180:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803187:	00 00 00 
  80318a:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80318d:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803190:	be 00 00 00 00       	mov    $0x0,%esi
  803195:	bf 02 00 00 00       	mov    $0x2,%edi
  80319a:	48 b8 64 2d 80 00 00 	movabs $0x802d64,%rax
  8031a1:	00 00 00 
  8031a4:	ff d0                	callq  *%rax
}
  8031a6:	c9                   	leaveq 
  8031a7:	c3                   	retq   

00000000008031a8 <remove>:

// Delete a file
int
remove(const char *path)
{
  8031a8:	55                   	push   %rbp
  8031a9:	48 89 e5             	mov    %rsp,%rbp
  8031ac:	48 83 ec 10          	sub    $0x10,%rsp
  8031b0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8031b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031b8:	48 89 c7             	mov    %rax,%rdi
  8031bb:	48 b8 5b 11 80 00 00 	movabs $0x80115b,%rax
  8031c2:	00 00 00 
  8031c5:	ff d0                	callq  *%rax
  8031c7:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8031cc:	7e 07                	jle    8031d5 <remove+0x2d>
		return -E_BAD_PATH;
  8031ce:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8031d3:	eb 33                	jmp    803208 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8031d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031d9:	48 89 c6             	mov    %rax,%rsi
  8031dc:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8031e3:	00 00 00 
  8031e6:	48 b8 c7 11 80 00 00 	movabs $0x8011c7,%rax
  8031ed:	00 00 00 
  8031f0:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8031f2:	be 00 00 00 00       	mov    $0x0,%esi
  8031f7:	bf 07 00 00 00       	mov    $0x7,%edi
  8031fc:	48 b8 64 2d 80 00 00 	movabs $0x802d64,%rax
  803203:	00 00 00 
  803206:	ff d0                	callq  *%rax
}
  803208:	c9                   	leaveq 
  803209:	c3                   	retq   

000000000080320a <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80320a:	55                   	push   %rbp
  80320b:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80320e:	be 00 00 00 00       	mov    $0x0,%esi
  803213:	bf 08 00 00 00       	mov    $0x8,%edi
  803218:	48 b8 64 2d 80 00 00 	movabs $0x802d64,%rax
  80321f:	00 00 00 
  803222:	ff d0                	callq  *%rax
}
  803224:	5d                   	pop    %rbp
  803225:	c3                   	retq   

0000000000803226 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803226:	55                   	push   %rbp
  803227:	48 89 e5             	mov    %rsp,%rbp
  80322a:	53                   	push   %rbx
  80322b:	48 83 ec 38          	sub    $0x38,%rsp
  80322f:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803233:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803237:	48 89 c7             	mov    %rax,%rdi
  80323a:	48 b8 4b 24 80 00 00 	movabs $0x80244b,%rax
  803241:	00 00 00 
  803244:	ff d0                	callq  *%rax
  803246:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803249:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80324d:	0f 88 bf 01 00 00    	js     803412 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803253:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803257:	ba 07 04 00 00       	mov    $0x407,%edx
  80325c:	48 89 c6             	mov    %rax,%rsi
  80325f:	bf 00 00 00 00       	mov    $0x0,%edi
  803264:	48 b8 f6 1a 80 00 00 	movabs $0x801af6,%rax
  80326b:	00 00 00 
  80326e:	ff d0                	callq  *%rax
  803270:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803273:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803277:	0f 88 95 01 00 00    	js     803412 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80327d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803281:	48 89 c7             	mov    %rax,%rdi
  803284:	48 b8 4b 24 80 00 00 	movabs $0x80244b,%rax
  80328b:	00 00 00 
  80328e:	ff d0                	callq  *%rax
  803290:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803293:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803297:	0f 88 5d 01 00 00    	js     8033fa <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80329d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032a1:	ba 07 04 00 00       	mov    $0x407,%edx
  8032a6:	48 89 c6             	mov    %rax,%rsi
  8032a9:	bf 00 00 00 00       	mov    $0x0,%edi
  8032ae:	48 b8 f6 1a 80 00 00 	movabs $0x801af6,%rax
  8032b5:	00 00 00 
  8032b8:	ff d0                	callq  *%rax
  8032ba:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032c1:	0f 88 33 01 00 00    	js     8033fa <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8032c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032cb:	48 89 c7             	mov    %rax,%rdi
  8032ce:	48 b8 20 24 80 00 00 	movabs $0x802420,%rax
  8032d5:	00 00 00 
  8032d8:	ff d0                	callq  *%rax
  8032da:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8032de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032e2:	ba 07 04 00 00       	mov    $0x407,%edx
  8032e7:	48 89 c6             	mov    %rax,%rsi
  8032ea:	bf 00 00 00 00       	mov    $0x0,%edi
  8032ef:	48 b8 f6 1a 80 00 00 	movabs $0x801af6,%rax
  8032f6:	00 00 00 
  8032f9:	ff d0                	callq  *%rax
  8032fb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032fe:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803302:	79 05                	jns    803309 <pipe+0xe3>
		goto err2;
  803304:	e9 d9 00 00 00       	jmpq   8033e2 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803309:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80330d:	48 89 c7             	mov    %rax,%rdi
  803310:	48 b8 20 24 80 00 00 	movabs $0x802420,%rax
  803317:	00 00 00 
  80331a:	ff d0                	callq  *%rax
  80331c:	48 89 c2             	mov    %rax,%rdx
  80331f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803323:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803329:	48 89 d1             	mov    %rdx,%rcx
  80332c:	ba 00 00 00 00       	mov    $0x0,%edx
  803331:	48 89 c6             	mov    %rax,%rsi
  803334:	bf 00 00 00 00       	mov    $0x0,%edi
  803339:	48 b8 46 1b 80 00 00 	movabs $0x801b46,%rax
  803340:	00 00 00 
  803343:	ff d0                	callq  *%rax
  803345:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803348:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80334c:	79 1b                	jns    803369 <pipe+0x143>
		goto err3;
  80334e:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  80334f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803353:	48 89 c6             	mov    %rax,%rsi
  803356:	bf 00 00 00 00       	mov    $0x0,%edi
  80335b:	48 b8 a1 1b 80 00 00 	movabs $0x801ba1,%rax
  803362:	00 00 00 
  803365:	ff d0                	callq  *%rax
  803367:	eb 79                	jmp    8033e2 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803369:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80336d:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803374:	00 00 00 
  803377:	8b 12                	mov    (%rdx),%edx
  803379:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80337b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80337f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803386:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80338a:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803391:	00 00 00 
  803394:	8b 12                	mov    (%rdx),%edx
  803396:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803398:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80339c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8033a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033a7:	48 89 c7             	mov    %rax,%rdi
  8033aa:	48 b8 fd 23 80 00 00 	movabs $0x8023fd,%rax
  8033b1:	00 00 00 
  8033b4:	ff d0                	callq  *%rax
  8033b6:	89 c2                	mov    %eax,%edx
  8033b8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8033bc:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8033be:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8033c2:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8033c6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033ca:	48 89 c7             	mov    %rax,%rdi
  8033cd:	48 b8 fd 23 80 00 00 	movabs $0x8023fd,%rax
  8033d4:	00 00 00 
  8033d7:	ff d0                	callq  *%rax
  8033d9:	89 03                	mov    %eax,(%rbx)
	return 0;
  8033db:	b8 00 00 00 00       	mov    $0x0,%eax
  8033e0:	eb 33                	jmp    803415 <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  8033e2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033e6:	48 89 c6             	mov    %rax,%rsi
  8033e9:	bf 00 00 00 00       	mov    $0x0,%edi
  8033ee:	48 b8 a1 1b 80 00 00 	movabs $0x801ba1,%rax
  8033f5:	00 00 00 
  8033f8:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  8033fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033fe:	48 89 c6             	mov    %rax,%rsi
  803401:	bf 00 00 00 00       	mov    $0x0,%edi
  803406:	48 b8 a1 1b 80 00 00 	movabs $0x801ba1,%rax
  80340d:	00 00 00 
  803410:	ff d0                	callq  *%rax
    err:
	return r;
  803412:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803415:	48 83 c4 38          	add    $0x38,%rsp
  803419:	5b                   	pop    %rbx
  80341a:	5d                   	pop    %rbp
  80341b:	c3                   	retq   

000000000080341c <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80341c:	55                   	push   %rbp
  80341d:	48 89 e5             	mov    %rsp,%rbp
  803420:	53                   	push   %rbx
  803421:	48 83 ec 28          	sub    $0x28,%rsp
  803425:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803429:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80342d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803434:	00 00 00 
  803437:	48 8b 00             	mov    (%rax),%rax
  80343a:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803440:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803443:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803447:	48 89 c7             	mov    %rax,%rdi
  80344a:	48 b8 cc 3d 80 00 00 	movabs $0x803dcc,%rax
  803451:	00 00 00 
  803454:	ff d0                	callq  *%rax
  803456:	89 c3                	mov    %eax,%ebx
  803458:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80345c:	48 89 c7             	mov    %rax,%rdi
  80345f:	48 b8 cc 3d 80 00 00 	movabs $0x803dcc,%rax
  803466:	00 00 00 
  803469:	ff d0                	callq  *%rax
  80346b:	39 c3                	cmp    %eax,%ebx
  80346d:	0f 94 c0             	sete   %al
  803470:	0f b6 c0             	movzbl %al,%eax
  803473:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803476:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80347d:	00 00 00 
  803480:	48 8b 00             	mov    (%rax),%rax
  803483:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803489:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80348c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80348f:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803492:	75 05                	jne    803499 <_pipeisclosed+0x7d>
			return ret;
  803494:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803497:	eb 4f                	jmp    8034e8 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803499:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80349c:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80349f:	74 42                	je     8034e3 <_pipeisclosed+0xc7>
  8034a1:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8034a5:	75 3c                	jne    8034e3 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8034a7:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8034ae:	00 00 00 
  8034b1:	48 8b 00             	mov    (%rax),%rax
  8034b4:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8034ba:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8034bd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034c0:	89 c6                	mov    %eax,%esi
  8034c2:	48 bf f7 45 80 00 00 	movabs $0x8045f7,%rdi
  8034c9:	00 00 00 
  8034cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8034d1:	49 b8 12 06 80 00 00 	movabs $0x800612,%r8
  8034d8:	00 00 00 
  8034db:	41 ff d0             	callq  *%r8
	}
  8034de:	e9 4a ff ff ff       	jmpq   80342d <_pipeisclosed+0x11>
  8034e3:	e9 45 ff ff ff       	jmpq   80342d <_pipeisclosed+0x11>
}
  8034e8:	48 83 c4 28          	add    $0x28,%rsp
  8034ec:	5b                   	pop    %rbx
  8034ed:	5d                   	pop    %rbp
  8034ee:	c3                   	retq   

00000000008034ef <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8034ef:	55                   	push   %rbp
  8034f0:	48 89 e5             	mov    %rsp,%rbp
  8034f3:	48 83 ec 30          	sub    $0x30,%rsp
  8034f7:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8034fa:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8034fe:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803501:	48 89 d6             	mov    %rdx,%rsi
  803504:	89 c7                	mov    %eax,%edi
  803506:	48 b8 e3 24 80 00 00 	movabs $0x8024e3,%rax
  80350d:	00 00 00 
  803510:	ff d0                	callq  *%rax
  803512:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803515:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803519:	79 05                	jns    803520 <pipeisclosed+0x31>
		return r;
  80351b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80351e:	eb 31                	jmp    803551 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803520:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803524:	48 89 c7             	mov    %rax,%rdi
  803527:	48 b8 20 24 80 00 00 	movabs $0x802420,%rax
  80352e:	00 00 00 
  803531:	ff d0                	callq  *%rax
  803533:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803537:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80353b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80353f:	48 89 d6             	mov    %rdx,%rsi
  803542:	48 89 c7             	mov    %rax,%rdi
  803545:	48 b8 1c 34 80 00 00 	movabs $0x80341c,%rax
  80354c:	00 00 00 
  80354f:	ff d0                	callq  *%rax
}
  803551:	c9                   	leaveq 
  803552:	c3                   	retq   

0000000000803553 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803553:	55                   	push   %rbp
  803554:	48 89 e5             	mov    %rsp,%rbp
  803557:	48 83 ec 40          	sub    $0x40,%rsp
  80355b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80355f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803563:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803567:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80356b:	48 89 c7             	mov    %rax,%rdi
  80356e:	48 b8 20 24 80 00 00 	movabs $0x802420,%rax
  803575:	00 00 00 
  803578:	ff d0                	callq  *%rax
  80357a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80357e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803582:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803586:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80358d:	00 
  80358e:	e9 92 00 00 00       	jmpq   803625 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803593:	eb 41                	jmp    8035d6 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803595:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80359a:	74 09                	je     8035a5 <devpipe_read+0x52>
				return i;
  80359c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035a0:	e9 92 00 00 00       	jmpq   803637 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8035a5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8035a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035ad:	48 89 d6             	mov    %rdx,%rsi
  8035b0:	48 89 c7             	mov    %rax,%rdi
  8035b3:	48 b8 1c 34 80 00 00 	movabs $0x80341c,%rax
  8035ba:	00 00 00 
  8035bd:	ff d0                	callq  *%rax
  8035bf:	85 c0                	test   %eax,%eax
  8035c1:	74 07                	je     8035ca <devpipe_read+0x77>
				return 0;
  8035c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8035c8:	eb 6d                	jmp    803637 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8035ca:	48 b8 b8 1a 80 00 00 	movabs $0x801ab8,%rax
  8035d1:	00 00 00 
  8035d4:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8035d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035da:	8b 10                	mov    (%rax),%edx
  8035dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035e0:	8b 40 04             	mov    0x4(%rax),%eax
  8035e3:	39 c2                	cmp    %eax,%edx
  8035e5:	74 ae                	je     803595 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8035e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035eb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8035ef:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8035f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035f7:	8b 00                	mov    (%rax),%eax
  8035f9:	99                   	cltd   
  8035fa:	c1 ea 1b             	shr    $0x1b,%edx
  8035fd:	01 d0                	add    %edx,%eax
  8035ff:	83 e0 1f             	and    $0x1f,%eax
  803602:	29 d0                	sub    %edx,%eax
  803604:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803608:	48 98                	cltq   
  80360a:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80360f:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803611:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803615:	8b 00                	mov    (%rax),%eax
  803617:	8d 50 01             	lea    0x1(%rax),%edx
  80361a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80361e:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803620:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803625:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803629:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80362d:	0f 82 60 ff ff ff    	jb     803593 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803633:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803637:	c9                   	leaveq 
  803638:	c3                   	retq   

0000000000803639 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803639:	55                   	push   %rbp
  80363a:	48 89 e5             	mov    %rsp,%rbp
  80363d:	48 83 ec 40          	sub    $0x40,%rsp
  803641:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803645:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803649:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80364d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803651:	48 89 c7             	mov    %rax,%rdi
  803654:	48 b8 20 24 80 00 00 	movabs $0x802420,%rax
  80365b:	00 00 00 
  80365e:	ff d0                	callq  *%rax
  803660:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803664:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803668:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80366c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803673:	00 
  803674:	e9 8e 00 00 00       	jmpq   803707 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803679:	eb 31                	jmp    8036ac <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80367b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80367f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803683:	48 89 d6             	mov    %rdx,%rsi
  803686:	48 89 c7             	mov    %rax,%rdi
  803689:	48 b8 1c 34 80 00 00 	movabs $0x80341c,%rax
  803690:	00 00 00 
  803693:	ff d0                	callq  *%rax
  803695:	85 c0                	test   %eax,%eax
  803697:	74 07                	je     8036a0 <devpipe_write+0x67>
				return 0;
  803699:	b8 00 00 00 00       	mov    $0x0,%eax
  80369e:	eb 79                	jmp    803719 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8036a0:	48 b8 b8 1a 80 00 00 	movabs $0x801ab8,%rax
  8036a7:	00 00 00 
  8036aa:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8036ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036b0:	8b 40 04             	mov    0x4(%rax),%eax
  8036b3:	48 63 d0             	movslq %eax,%rdx
  8036b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036ba:	8b 00                	mov    (%rax),%eax
  8036bc:	48 98                	cltq   
  8036be:	48 83 c0 20          	add    $0x20,%rax
  8036c2:	48 39 c2             	cmp    %rax,%rdx
  8036c5:	73 b4                	jae    80367b <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8036c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036cb:	8b 40 04             	mov    0x4(%rax),%eax
  8036ce:	99                   	cltd   
  8036cf:	c1 ea 1b             	shr    $0x1b,%edx
  8036d2:	01 d0                	add    %edx,%eax
  8036d4:	83 e0 1f             	and    $0x1f,%eax
  8036d7:	29 d0                	sub    %edx,%eax
  8036d9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8036dd:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8036e1:	48 01 ca             	add    %rcx,%rdx
  8036e4:	0f b6 0a             	movzbl (%rdx),%ecx
  8036e7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8036eb:	48 98                	cltq   
  8036ed:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8036f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036f5:	8b 40 04             	mov    0x4(%rax),%eax
  8036f8:	8d 50 01             	lea    0x1(%rax),%edx
  8036fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036ff:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803702:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803707:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80370b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80370f:	0f 82 64 ff ff ff    	jb     803679 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803715:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803719:	c9                   	leaveq 
  80371a:	c3                   	retq   

000000000080371b <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80371b:	55                   	push   %rbp
  80371c:	48 89 e5             	mov    %rsp,%rbp
  80371f:	48 83 ec 20          	sub    $0x20,%rsp
  803723:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803727:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80372b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80372f:	48 89 c7             	mov    %rax,%rdi
  803732:	48 b8 20 24 80 00 00 	movabs $0x802420,%rax
  803739:	00 00 00 
  80373c:	ff d0                	callq  *%rax
  80373e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803742:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803746:	48 be 0a 46 80 00 00 	movabs $0x80460a,%rsi
  80374d:	00 00 00 
  803750:	48 89 c7             	mov    %rax,%rdi
  803753:	48 b8 c7 11 80 00 00 	movabs $0x8011c7,%rax
  80375a:	00 00 00 
  80375d:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80375f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803763:	8b 50 04             	mov    0x4(%rax),%edx
  803766:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80376a:	8b 00                	mov    (%rax),%eax
  80376c:	29 c2                	sub    %eax,%edx
  80376e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803772:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803778:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80377c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803783:	00 00 00 
	stat->st_dev = &devpipe;
  803786:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80378a:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  803791:	00 00 00 
  803794:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80379b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037a0:	c9                   	leaveq 
  8037a1:	c3                   	retq   

00000000008037a2 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8037a2:	55                   	push   %rbp
  8037a3:	48 89 e5             	mov    %rsp,%rbp
  8037a6:	48 83 ec 10          	sub    $0x10,%rsp
  8037aa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8037ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037b2:	48 89 c6             	mov    %rax,%rsi
  8037b5:	bf 00 00 00 00       	mov    $0x0,%edi
  8037ba:	48 b8 a1 1b 80 00 00 	movabs $0x801ba1,%rax
  8037c1:	00 00 00 
  8037c4:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8037c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037ca:	48 89 c7             	mov    %rax,%rdi
  8037cd:	48 b8 20 24 80 00 00 	movabs $0x802420,%rax
  8037d4:	00 00 00 
  8037d7:	ff d0                	callq  *%rax
  8037d9:	48 89 c6             	mov    %rax,%rsi
  8037dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8037e1:	48 b8 a1 1b 80 00 00 	movabs $0x801ba1,%rax
  8037e8:	00 00 00 
  8037eb:	ff d0                	callq  *%rax
}
  8037ed:	c9                   	leaveq 
  8037ee:	c3                   	retq   

00000000008037ef <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8037ef:	55                   	push   %rbp
  8037f0:	48 89 e5             	mov    %rsp,%rbp
  8037f3:	48 83 ec 20          	sub    $0x20,%rsp
  8037f7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8037fa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037fd:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803800:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803804:	be 01 00 00 00       	mov    $0x1,%esi
  803809:	48 89 c7             	mov    %rax,%rdi
  80380c:	48 b8 ae 19 80 00 00 	movabs $0x8019ae,%rax
  803813:	00 00 00 
  803816:	ff d0                	callq  *%rax
}
  803818:	c9                   	leaveq 
  803819:	c3                   	retq   

000000000080381a <getchar>:

int
getchar(void)
{
  80381a:	55                   	push   %rbp
  80381b:	48 89 e5             	mov    %rsp,%rbp
  80381e:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803822:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803826:	ba 01 00 00 00       	mov    $0x1,%edx
  80382b:	48 89 c6             	mov    %rax,%rsi
  80382e:	bf 00 00 00 00       	mov    $0x0,%edi
  803833:	48 b8 15 29 80 00 00 	movabs $0x802915,%rax
  80383a:	00 00 00 
  80383d:	ff d0                	callq  *%rax
  80383f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803842:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803846:	79 05                	jns    80384d <getchar+0x33>
		return r;
  803848:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80384b:	eb 14                	jmp    803861 <getchar+0x47>
	if (r < 1)
  80384d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803851:	7f 07                	jg     80385a <getchar+0x40>
		return -E_EOF;
  803853:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803858:	eb 07                	jmp    803861 <getchar+0x47>
	return c;
  80385a:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80385e:	0f b6 c0             	movzbl %al,%eax
}
  803861:	c9                   	leaveq 
  803862:	c3                   	retq   

0000000000803863 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803863:	55                   	push   %rbp
  803864:	48 89 e5             	mov    %rsp,%rbp
  803867:	48 83 ec 20          	sub    $0x20,%rsp
  80386b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80386e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803872:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803875:	48 89 d6             	mov    %rdx,%rsi
  803878:	89 c7                	mov    %eax,%edi
  80387a:	48 b8 e3 24 80 00 00 	movabs $0x8024e3,%rax
  803881:	00 00 00 
  803884:	ff d0                	callq  *%rax
  803886:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803889:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80388d:	79 05                	jns    803894 <iscons+0x31>
		return r;
  80388f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803892:	eb 1a                	jmp    8038ae <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803894:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803898:	8b 10                	mov    (%rax),%edx
  80389a:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  8038a1:	00 00 00 
  8038a4:	8b 00                	mov    (%rax),%eax
  8038a6:	39 c2                	cmp    %eax,%edx
  8038a8:	0f 94 c0             	sete   %al
  8038ab:	0f b6 c0             	movzbl %al,%eax
}
  8038ae:	c9                   	leaveq 
  8038af:	c3                   	retq   

00000000008038b0 <opencons>:

int
opencons(void)
{
  8038b0:	55                   	push   %rbp
  8038b1:	48 89 e5             	mov    %rsp,%rbp
  8038b4:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8038b8:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8038bc:	48 89 c7             	mov    %rax,%rdi
  8038bf:	48 b8 4b 24 80 00 00 	movabs $0x80244b,%rax
  8038c6:	00 00 00 
  8038c9:	ff d0                	callq  *%rax
  8038cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038d2:	79 05                	jns    8038d9 <opencons+0x29>
		return r;
  8038d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038d7:	eb 5b                	jmp    803934 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8038d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038dd:	ba 07 04 00 00       	mov    $0x407,%edx
  8038e2:	48 89 c6             	mov    %rax,%rsi
  8038e5:	bf 00 00 00 00       	mov    $0x0,%edi
  8038ea:	48 b8 f6 1a 80 00 00 	movabs $0x801af6,%rax
  8038f1:	00 00 00 
  8038f4:	ff d0                	callq  *%rax
  8038f6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038fd:	79 05                	jns    803904 <opencons+0x54>
		return r;
  8038ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803902:	eb 30                	jmp    803934 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803904:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803908:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  80390f:	00 00 00 
  803912:	8b 12                	mov    (%rdx),%edx
  803914:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803916:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80391a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803921:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803925:	48 89 c7             	mov    %rax,%rdi
  803928:	48 b8 fd 23 80 00 00 	movabs $0x8023fd,%rax
  80392f:	00 00 00 
  803932:	ff d0                	callq  *%rax
}
  803934:	c9                   	leaveq 
  803935:	c3                   	retq   

0000000000803936 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803936:	55                   	push   %rbp
  803937:	48 89 e5             	mov    %rsp,%rbp
  80393a:	48 83 ec 30          	sub    $0x30,%rsp
  80393e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803942:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803946:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80394a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80394f:	75 07                	jne    803958 <devcons_read+0x22>
		return 0;
  803951:	b8 00 00 00 00       	mov    $0x0,%eax
  803956:	eb 4b                	jmp    8039a3 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803958:	eb 0c                	jmp    803966 <devcons_read+0x30>
		sys_yield();
  80395a:	48 b8 b8 1a 80 00 00 	movabs $0x801ab8,%rax
  803961:	00 00 00 
  803964:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803966:	48 b8 f8 19 80 00 00 	movabs $0x8019f8,%rax
  80396d:	00 00 00 
  803970:	ff d0                	callq  *%rax
  803972:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803975:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803979:	74 df                	je     80395a <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  80397b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80397f:	79 05                	jns    803986 <devcons_read+0x50>
		return c;
  803981:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803984:	eb 1d                	jmp    8039a3 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803986:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80398a:	75 07                	jne    803993 <devcons_read+0x5d>
		return 0;
  80398c:	b8 00 00 00 00       	mov    $0x0,%eax
  803991:	eb 10                	jmp    8039a3 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803993:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803996:	89 c2                	mov    %eax,%edx
  803998:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80399c:	88 10                	mov    %dl,(%rax)
	return 1;
  80399e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8039a3:	c9                   	leaveq 
  8039a4:	c3                   	retq   

00000000008039a5 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8039a5:	55                   	push   %rbp
  8039a6:	48 89 e5             	mov    %rsp,%rbp
  8039a9:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8039b0:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8039b7:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8039be:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8039c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8039cc:	eb 76                	jmp    803a44 <devcons_write+0x9f>
		m = n - tot;
  8039ce:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8039d5:	89 c2                	mov    %eax,%edx
  8039d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039da:	29 c2                	sub    %eax,%edx
  8039dc:	89 d0                	mov    %edx,%eax
  8039de:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8039e1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8039e4:	83 f8 7f             	cmp    $0x7f,%eax
  8039e7:	76 07                	jbe    8039f0 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8039e9:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8039f0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8039f3:	48 63 d0             	movslq %eax,%rdx
  8039f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039f9:	48 63 c8             	movslq %eax,%rcx
  8039fc:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803a03:	48 01 c1             	add    %rax,%rcx
  803a06:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803a0d:	48 89 ce             	mov    %rcx,%rsi
  803a10:	48 89 c7             	mov    %rax,%rdi
  803a13:	48 b8 eb 14 80 00 00 	movabs $0x8014eb,%rax
  803a1a:	00 00 00 
  803a1d:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803a1f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a22:	48 63 d0             	movslq %eax,%rdx
  803a25:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803a2c:	48 89 d6             	mov    %rdx,%rsi
  803a2f:	48 89 c7             	mov    %rax,%rdi
  803a32:	48 b8 ae 19 80 00 00 	movabs $0x8019ae,%rax
  803a39:	00 00 00 
  803a3c:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803a3e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a41:	01 45 fc             	add    %eax,-0x4(%rbp)
  803a44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a47:	48 98                	cltq   
  803a49:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803a50:	0f 82 78 ff ff ff    	jb     8039ce <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803a56:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803a59:	c9                   	leaveq 
  803a5a:	c3                   	retq   

0000000000803a5b <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803a5b:	55                   	push   %rbp
  803a5c:	48 89 e5             	mov    %rsp,%rbp
  803a5f:	48 83 ec 08          	sub    $0x8,%rsp
  803a63:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803a67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a6c:	c9                   	leaveq 
  803a6d:	c3                   	retq   

0000000000803a6e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803a6e:	55                   	push   %rbp
  803a6f:	48 89 e5             	mov    %rsp,%rbp
  803a72:	48 83 ec 10          	sub    $0x10,%rsp
  803a76:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803a7a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803a7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a82:	48 be 16 46 80 00 00 	movabs $0x804616,%rsi
  803a89:	00 00 00 
  803a8c:	48 89 c7             	mov    %rax,%rdi
  803a8f:	48 b8 c7 11 80 00 00 	movabs $0x8011c7,%rax
  803a96:	00 00 00 
  803a99:	ff d0                	callq  *%rax
	return 0;
  803a9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803aa0:	c9                   	leaveq 
  803aa1:	c3                   	retq   

0000000000803aa2 <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803aa2:	55                   	push   %rbp
  803aa3:	48 89 e5             	mov    %rsp,%rbp
  803aa6:	48 83 ec 10          	sub    $0x10,%rsp
  803aaa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  803aae:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803ab5:	00 00 00 
  803ab8:	48 8b 00             	mov    (%rax),%rax
  803abb:	48 85 c0             	test   %rax,%rax
  803abe:	0f 85 84 00 00 00    	jne    803b48 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  803ac4:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803acb:	00 00 00 
  803ace:	48 8b 00             	mov    (%rax),%rax
  803ad1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803ad7:	ba 07 00 00 00       	mov    $0x7,%edx
  803adc:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803ae1:	89 c7                	mov    %eax,%edi
  803ae3:	48 b8 f6 1a 80 00 00 	movabs $0x801af6,%rax
  803aea:	00 00 00 
  803aed:	ff d0                	callq  *%rax
  803aef:	85 c0                	test   %eax,%eax
  803af1:	79 2a                	jns    803b1d <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  803af3:	48 ba 20 46 80 00 00 	movabs $0x804620,%rdx
  803afa:	00 00 00 
  803afd:	be 23 00 00 00       	mov    $0x23,%esi
  803b02:	48 bf 47 46 80 00 00 	movabs $0x804647,%rdi
  803b09:	00 00 00 
  803b0c:	b8 00 00 00 00       	mov    $0x0,%eax
  803b11:	48 b9 d9 03 80 00 00 	movabs $0x8003d9,%rcx
  803b18:	00 00 00 
  803b1b:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  803b1d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803b24:	00 00 00 
  803b27:	48 8b 00             	mov    (%rax),%rax
  803b2a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803b30:	48 be 5b 3b 80 00 00 	movabs $0x803b5b,%rsi
  803b37:	00 00 00 
  803b3a:	89 c7                	mov    %eax,%edi
  803b3c:	48 b8 80 1c 80 00 00 	movabs $0x801c80,%rax
  803b43:	00 00 00 
  803b46:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  803b48:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803b4f:	00 00 00 
  803b52:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803b56:	48 89 10             	mov    %rdx,(%rax)
}
  803b59:	c9                   	leaveq 
  803b5a:	c3                   	retq   

0000000000803b5b <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  803b5b:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  803b5e:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  803b65:	00 00 00 
	call *%rax
  803b68:	ff d0                	callq  *%rax


	/*This code is to be removed*/

	// LAB 4: Your code here.
	movq 136(%rsp), %rbx  //Load RIP 
  803b6a:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  803b71:	00 
	movq 152(%rsp), %rcx  //Load RSP
  803b72:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  803b79:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  803b7a:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  803b7e:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  803b81:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  803b88:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  803b89:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  803b8d:	4c 8b 3c 24          	mov    (%rsp),%r15
  803b91:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803b96:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803b9b:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803ba0:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803ba5:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803baa:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803baf:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803bb4:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803bb9:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803bbe:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803bc3:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803bc8:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803bcd:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803bd2:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803bd7:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  803bdb:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  803bdf:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  803be0:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  803be1:	c3                   	retq   

0000000000803be2 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803be2:	55                   	push   %rbp
  803be3:	48 89 e5             	mov    %rsp,%rbp
  803be6:	48 83 ec 30          	sub    $0x30,%rsp
  803bea:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803bee:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803bf2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803bf6:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803bfd:	00 00 00 
  803c00:	48 8b 00             	mov    (%rax),%rax
  803c03:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803c09:	85 c0                	test   %eax,%eax
  803c0b:	75 3c                	jne    803c49 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  803c0d:	48 b8 7a 1a 80 00 00 	movabs $0x801a7a,%rax
  803c14:	00 00 00 
  803c17:	ff d0                	callq  *%rax
  803c19:	25 ff 03 00 00       	and    $0x3ff,%eax
  803c1e:	48 63 d0             	movslq %eax,%rdx
  803c21:	48 89 d0             	mov    %rdx,%rax
  803c24:	48 c1 e0 03          	shl    $0x3,%rax
  803c28:	48 01 d0             	add    %rdx,%rax
  803c2b:	48 c1 e0 05          	shl    $0x5,%rax
  803c2f:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803c36:	00 00 00 
  803c39:	48 01 c2             	add    %rax,%rdx
  803c3c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c43:	00 00 00 
  803c46:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803c49:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803c4e:	75 0e                	jne    803c5e <ipc_recv+0x7c>
		pg = (void*) UTOP;
  803c50:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803c57:	00 00 00 
  803c5a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803c5e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c62:	48 89 c7             	mov    %rax,%rdi
  803c65:	48 b8 1f 1d 80 00 00 	movabs $0x801d1f,%rax
  803c6c:	00 00 00 
  803c6f:	ff d0                	callq  *%rax
  803c71:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803c74:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c78:	79 19                	jns    803c93 <ipc_recv+0xb1>
		*from_env_store = 0;
  803c7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c7e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803c84:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c88:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803c8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c91:	eb 53                	jmp    803ce6 <ipc_recv+0x104>
	}
	if(from_env_store)
  803c93:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803c98:	74 19                	je     803cb3 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  803c9a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803ca1:	00 00 00 
  803ca4:	48 8b 00             	mov    (%rax),%rax
  803ca7:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803cad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cb1:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803cb3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803cb8:	74 19                	je     803cd3 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  803cba:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803cc1:	00 00 00 
  803cc4:	48 8b 00             	mov    (%rax),%rax
  803cc7:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803ccd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cd1:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803cd3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803cda:	00 00 00 
  803cdd:	48 8b 00             	mov    (%rax),%rax
  803ce0:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803ce6:	c9                   	leaveq 
  803ce7:	c3                   	retq   

0000000000803ce8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803ce8:	55                   	push   %rbp
  803ce9:	48 89 e5             	mov    %rsp,%rbp
  803cec:	48 83 ec 30          	sub    $0x30,%rsp
  803cf0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803cf3:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803cf6:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803cfa:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803cfd:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803d02:	75 0e                	jne    803d12 <ipc_send+0x2a>
		pg = (void*)UTOP;
  803d04:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803d0b:	00 00 00 
  803d0e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  803d12:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803d15:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803d18:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803d1c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d1f:	89 c7                	mov    %eax,%edi
  803d21:	48 b8 ca 1c 80 00 00 	movabs $0x801cca,%rax
  803d28:	00 00 00 
  803d2b:	ff d0                	callq  *%rax
  803d2d:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  803d30:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803d34:	75 0c                	jne    803d42 <ipc_send+0x5a>
			sys_yield();
  803d36:	48 b8 b8 1a 80 00 00 	movabs $0x801ab8,%rax
  803d3d:	00 00 00 
  803d40:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  803d42:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803d46:	74 ca                	je     803d12 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  803d48:	c9                   	leaveq 
  803d49:	c3                   	retq   

0000000000803d4a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803d4a:	55                   	push   %rbp
  803d4b:	48 89 e5             	mov    %rsp,%rbp
  803d4e:	48 83 ec 14          	sub    $0x14,%rsp
  803d52:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  803d55:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803d5c:	eb 5e                	jmp    803dbc <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803d5e:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803d65:	00 00 00 
  803d68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d6b:	48 63 d0             	movslq %eax,%rdx
  803d6e:	48 89 d0             	mov    %rdx,%rax
  803d71:	48 c1 e0 03          	shl    $0x3,%rax
  803d75:	48 01 d0             	add    %rdx,%rax
  803d78:	48 c1 e0 05          	shl    $0x5,%rax
  803d7c:	48 01 c8             	add    %rcx,%rax
  803d7f:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803d85:	8b 00                	mov    (%rax),%eax
  803d87:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803d8a:	75 2c                	jne    803db8 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803d8c:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803d93:	00 00 00 
  803d96:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d99:	48 63 d0             	movslq %eax,%rdx
  803d9c:	48 89 d0             	mov    %rdx,%rax
  803d9f:	48 c1 e0 03          	shl    $0x3,%rax
  803da3:	48 01 d0             	add    %rdx,%rax
  803da6:	48 c1 e0 05          	shl    $0x5,%rax
  803daa:	48 01 c8             	add    %rcx,%rax
  803dad:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803db3:	8b 40 08             	mov    0x8(%rax),%eax
  803db6:	eb 12                	jmp    803dca <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803db8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803dbc:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803dc3:	7e 99                	jle    803d5e <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803dc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803dca:	c9                   	leaveq 
  803dcb:	c3                   	retq   

0000000000803dcc <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803dcc:	55                   	push   %rbp
  803dcd:	48 89 e5             	mov    %rsp,%rbp
  803dd0:	48 83 ec 18          	sub    $0x18,%rsp
  803dd4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803dd8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ddc:	48 c1 e8 15          	shr    $0x15,%rax
  803de0:	48 89 c2             	mov    %rax,%rdx
  803de3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803dea:	01 00 00 
  803ded:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803df1:	83 e0 01             	and    $0x1,%eax
  803df4:	48 85 c0             	test   %rax,%rax
  803df7:	75 07                	jne    803e00 <pageref+0x34>
		return 0;
  803df9:	b8 00 00 00 00       	mov    $0x0,%eax
  803dfe:	eb 53                	jmp    803e53 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803e00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e04:	48 c1 e8 0c          	shr    $0xc,%rax
  803e08:	48 89 c2             	mov    %rax,%rdx
  803e0b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803e12:	01 00 00 
  803e15:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e19:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803e1d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e21:	83 e0 01             	and    $0x1,%eax
  803e24:	48 85 c0             	test   %rax,%rax
  803e27:	75 07                	jne    803e30 <pageref+0x64>
		return 0;
  803e29:	b8 00 00 00 00       	mov    $0x0,%eax
  803e2e:	eb 23                	jmp    803e53 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803e30:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e34:	48 c1 e8 0c          	shr    $0xc,%rax
  803e38:	48 89 c2             	mov    %rax,%rdx
  803e3b:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803e42:	00 00 00 
  803e45:	48 c1 e2 04          	shl    $0x4,%rdx
  803e49:	48 01 d0             	add    %rdx,%rax
  803e4c:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803e50:	0f b7 c0             	movzwl %ax,%eax
}
  803e53:	c9                   	leaveq 
  803e54:	c3                   	retq   
