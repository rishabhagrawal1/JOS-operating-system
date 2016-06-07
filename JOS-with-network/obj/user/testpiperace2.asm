
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
  800052:	48 bf 20 49 80 00 00 	movabs $0x804920,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 12 06 80 00 00 	movabs $0x800612,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	if ((r = pipe(p)) < 0)
  80006d:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  800071:	48 89 c7             	mov    %rax,%rdi
  800074:	48 b8 d7 3c 80 00 00 	movabs $0x803cd7,%rax
  80007b:	00 00 00 
  80007e:	ff d0                	callq  *%rax
  800080:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800083:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800087:	79 30                	jns    8000b9 <umain+0x76>
		panic("pipe: %e", r);
  800089:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80008c:	89 c1                	mov    %eax,%ecx
  80008e:	48 ba 42 49 80 00 00 	movabs $0x804942,%rdx
  800095:	00 00 00 
  800098:	be 0d 00 00 00       	mov    $0xd,%esi
  80009d:	48 bf 4b 49 80 00 00 	movabs $0x80494b,%rdi
  8000a4:	00 00 00 
  8000a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ac:	49 b8 d9 03 80 00 00 	movabs $0x8003d9,%r8
  8000b3:	00 00 00 
  8000b6:	41 ff d0             	callq  *%r8
	if ((r = fork()) < 0)
  8000b9:	48 b8 16 22 80 00 00 	movabs $0x802216,%rax
  8000c0:	00 00 00 
  8000c3:	ff d0                	callq  *%rax
  8000c5:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000c8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000cc:	79 30                	jns    8000fe <umain+0xbb>
		panic("fork: %e", r);
  8000ce:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d1:	89 c1                	mov    %eax,%ecx
  8000d3:	48 ba 60 49 80 00 00 	movabs $0x804960,%rdx
  8000da:	00 00 00 
  8000dd:	be 0f 00 00 00       	mov    $0xf,%esi
  8000e2:	48 bf 4b 49 80 00 00 	movabs $0x80494b,%rdi
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
  80010d:	48 b8 bd 27 80 00 00 	movabs $0x8027bd,%rax
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
  800151:	48 bf 69 49 80 00 00 	movabs $0x804969,%rdi
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
  800176:	48 b8 36 28 80 00 00 	movabs $0x802836,%rax
  80017d:	00 00 00 
  800180:	ff d0                	callq  *%rax
			sys_yield();
  800182:	48 b8 b8 1a 80 00 00 	movabs $0x801ab8,%rax
  800189:	00 00 00 
  80018c:	ff d0                	callq  *%rax
			close(10);
  80018e:	bf 0a 00 00 00       	mov    $0xa,%edi
  800193:	48 b8 bd 27 80 00 00 	movabs $0x8027bd,%rax
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
  8001f9:	48 b8 a0 3f 80 00 00 	movabs $0x803fa0,%rax
  800200:	00 00 00 
  800203:	ff d0                	callq  *%rax
  800205:	85 c0                	test   %eax,%eax
  800207:	74 38                	je     800241 <umain+0x1fe>
			cprintf("\nRACE: pipe appears closed\n");
  800209:	48 bf 6d 49 80 00 00 	movabs $0x80496d,%rdi
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
  800250:	48 bf 89 49 80 00 00 	movabs $0x804989,%rdi
  800257:	00 00 00 
  80025a:	b8 00 00 00 00       	mov    $0x0,%eax
  80025f:	48 ba 12 06 80 00 00 	movabs $0x800612,%rdx
  800266:	00 00 00 
  800269:	ff d2                	callq  *%rdx
	if (pipeisclosed(p[0]))
  80026b:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80026e:	89 c7                	mov    %eax,%edi
  800270:	48 b8 a0 3f 80 00 00 	movabs $0x803fa0,%rax
  800277:	00 00 00 
  80027a:	ff d0                	callq  *%rax
  80027c:	85 c0                	test   %eax,%eax
  80027e:	74 2a                	je     8002aa <umain+0x267>
		panic("somehow the other end of p[0] got closed!");
  800280:	48 ba a0 49 80 00 00 	movabs $0x8049a0,%rdx
  800287:	00 00 00 
  80028a:	be 40 00 00 00       	mov    $0x40,%esi
  80028f:	48 bf 4b 49 80 00 00 	movabs $0x80494b,%rdi
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
  8002b6:	48 b8 ad 25 80 00 00 	movabs $0x8025ad,%rax
  8002bd:	00 00 00 
  8002c0:	ff d0                	callq  *%rax
  8002c2:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8002c5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8002c9:	79 30                	jns    8002fb <umain+0x2b8>
		panic("cannot look up p[0]: %e", r);
  8002cb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002ce:	89 c1                	mov    %eax,%ecx
  8002d0:	48 ba ca 49 80 00 00 	movabs $0x8049ca,%rdx
  8002d7:	00 00 00 
  8002da:	be 42 00 00 00       	mov    $0x42,%esi
  8002df:	48 bf 4b 49 80 00 00 	movabs $0x80494b,%rdi
  8002e6:	00 00 00 
  8002e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8002ee:	49 b8 d9 03 80 00 00 	movabs $0x8003d9,%r8
  8002f5:	00 00 00 
  8002f8:	41 ff d0             	callq  *%r8
	(void) fd2data(fd);
  8002fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8002ff:	48 89 c7             	mov    %rax,%rdi
  800302:	48 b8 ea 24 80 00 00 	movabs $0x8024ea,%rax
  800309:	00 00 00 
  80030c:	ff d0                	callq  *%rax
	cprintf("race didn't happen\n");
  80030e:	48 bf e2 49 80 00 00 	movabs $0x8049e2,%rdi
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
  800369:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
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
  800383:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
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
  8003ba:	48 b8 08 28 80 00 00 	movabs $0x802808,%rax
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
  800462:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
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
  800493:	48 bf 00 4a 80 00 00 	movabs $0x804a00,%rdi
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
  8004cf:	48 bf 23 4a 80 00 00 	movabs $0x804a23,%rdi
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
  80077e:	48 ba 30 4c 80 00 00 	movabs $0x804c30,%rdx
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
  800a76:	48 b8 58 4c 80 00 00 	movabs $0x804c58,%rax
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
  800bc4:	83 fb 15             	cmp    $0x15,%ebx
  800bc7:	7f 16                	jg     800bdf <vprintfmt+0x21a>
  800bc9:	48 b8 80 4b 80 00 00 	movabs $0x804b80,%rax
  800bd0:	00 00 00 
  800bd3:	48 63 d3             	movslq %ebx,%rdx
  800bd6:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800bda:	4d 85 e4             	test   %r12,%r12
  800bdd:	75 2e                	jne    800c0d <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800bdf:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800be3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800be7:	89 d9                	mov    %ebx,%ecx
  800be9:	48 ba 41 4c 80 00 00 	movabs $0x804c41,%rdx
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
  800c18:	48 ba 4a 4c 80 00 00 	movabs $0x804c4a,%rdx
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
  800c72:	49 bc 4d 4c 80 00 00 	movabs $0x804c4d,%r12
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
  801978:	48 ba 08 4f 80 00 00 	movabs $0x804f08,%rdx
  80197f:	00 00 00 
  801982:	be 23 00 00 00       	mov    $0x23,%esi
  801987:	48 bf 25 4f 80 00 00 	movabs $0x804f25,%rdi
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

0000000000801d63 <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801d63:	55                   	push   %rbp
  801d64:	48 89 e5             	mov    %rsp,%rbp
  801d67:	48 83 ec 20          	sub    $0x20,%rsp
  801d6b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d6f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, (uint64_t)buf, len, 0, 0, 0, 0);
  801d73:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d77:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d7b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d82:	00 
  801d83:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d89:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d8f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d94:	89 c6                	mov    %eax,%esi
  801d96:	bf 0f 00 00 00       	mov    $0xf,%edi
  801d9b:	48 b8 20 19 80 00 00 	movabs $0x801920,%rax
  801da2:	00 00 00 
  801da5:	ff d0                	callq  *%rax
}
  801da7:	c9                   	leaveq 
  801da8:	c3                   	retq   

0000000000801da9 <sys_net_rx>:

int
sys_net_rx(void *buf, size_t len)
{
  801da9:	55                   	push   %rbp
  801daa:	48 89 e5             	mov    %rsp,%rbp
  801dad:	48 83 ec 20          	sub    $0x20,%rsp
  801db1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801db5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_rx, (uint64_t)buf, len, 0, 0, 0, 0);
  801db9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dbd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dc1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dc8:	00 
  801dc9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dcf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dd5:	b9 00 00 00 00       	mov    $0x0,%ecx
  801dda:	89 c6                	mov    %eax,%esi
  801ddc:	bf 10 00 00 00       	mov    $0x10,%edi
  801de1:	48 b8 20 19 80 00 00 	movabs $0x801920,%rax
  801de8:	00 00 00 
  801deb:	ff d0                	callq  *%rax
}
  801ded:	c9                   	leaveq 
  801dee:	c3                   	retq   

0000000000801def <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801def:	55                   	push   %rbp
  801df0:	48 89 e5             	mov    %rsp,%rbp
  801df3:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801df7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dfe:	00 
  801dff:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e05:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e0b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e10:	ba 00 00 00 00       	mov    $0x0,%edx
  801e15:	be 00 00 00 00       	mov    $0x0,%esi
  801e1a:	bf 0e 00 00 00       	mov    $0xe,%edi
  801e1f:	48 b8 20 19 80 00 00 	movabs $0x801920,%rax
  801e26:	00 00 00 
  801e29:	ff d0                	callq  *%rax
}
  801e2b:	c9                   	leaveq 
  801e2c:	c3                   	retq   

0000000000801e2d <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  801e2d:	55                   	push   %rbp
  801e2e:	48 89 e5             	mov    %rsp,%rbp
  801e31:	48 83 ec 30          	sub    $0x30,%rsp
  801e35:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801e39:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e3d:	48 8b 00             	mov    (%rax),%rax
  801e40:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801e44:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e48:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e4c:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801e4f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e52:	83 e0 02             	and    $0x2,%eax
  801e55:	85 c0                	test   %eax,%eax
  801e57:	75 4d                	jne    801ea6 <pgfault+0x79>
  801e59:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e5d:	48 c1 e8 0c          	shr    $0xc,%rax
  801e61:	48 89 c2             	mov    %rax,%rdx
  801e64:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e6b:	01 00 00 
  801e6e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e72:	25 00 08 00 00       	and    $0x800,%eax
  801e77:	48 85 c0             	test   %rax,%rax
  801e7a:	74 2a                	je     801ea6 <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  801e7c:	48 ba 38 4f 80 00 00 	movabs $0x804f38,%rdx
  801e83:	00 00 00 
  801e86:	be 23 00 00 00       	mov    $0x23,%esi
  801e8b:	48 bf 6d 4f 80 00 00 	movabs $0x804f6d,%rdi
  801e92:	00 00 00 
  801e95:	b8 00 00 00 00       	mov    $0x0,%eax
  801e9a:	48 b9 d9 03 80 00 00 	movabs $0x8003d9,%rcx
  801ea1:	00 00 00 
  801ea4:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  801ea6:	ba 07 00 00 00       	mov    $0x7,%edx
  801eab:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801eb0:	bf 00 00 00 00       	mov    $0x0,%edi
  801eb5:	48 b8 f6 1a 80 00 00 	movabs $0x801af6,%rax
  801ebc:	00 00 00 
  801ebf:	ff d0                	callq  *%rax
  801ec1:	85 c0                	test   %eax,%eax
  801ec3:	0f 85 cd 00 00 00    	jne    801f96 <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801ec9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ecd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801ed1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ed5:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801edb:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801edf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ee3:	ba 00 10 00 00       	mov    $0x1000,%edx
  801ee8:	48 89 c6             	mov    %rax,%rsi
  801eeb:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801ef0:	48 b8 eb 14 80 00 00 	movabs $0x8014eb,%rax
  801ef7:	00 00 00 
  801efa:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801efc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f00:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801f06:	48 89 c1             	mov    %rax,%rcx
  801f09:	ba 00 00 00 00       	mov    $0x0,%edx
  801f0e:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f13:	bf 00 00 00 00       	mov    $0x0,%edi
  801f18:	48 b8 46 1b 80 00 00 	movabs $0x801b46,%rax
  801f1f:	00 00 00 
  801f22:	ff d0                	callq  *%rax
  801f24:	85 c0                	test   %eax,%eax
  801f26:	79 2a                	jns    801f52 <pgfault+0x125>
				panic("Page map at temp address failed");
  801f28:	48 ba 78 4f 80 00 00 	movabs $0x804f78,%rdx
  801f2f:	00 00 00 
  801f32:	be 30 00 00 00       	mov    $0x30,%esi
  801f37:	48 bf 6d 4f 80 00 00 	movabs $0x804f6d,%rdi
  801f3e:	00 00 00 
  801f41:	b8 00 00 00 00       	mov    $0x0,%eax
  801f46:	48 b9 d9 03 80 00 00 	movabs $0x8003d9,%rcx
  801f4d:	00 00 00 
  801f50:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801f52:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f57:	bf 00 00 00 00       	mov    $0x0,%edi
  801f5c:	48 b8 a1 1b 80 00 00 	movabs $0x801ba1,%rax
  801f63:	00 00 00 
  801f66:	ff d0                	callq  *%rax
  801f68:	85 c0                	test   %eax,%eax
  801f6a:	79 54                	jns    801fc0 <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801f6c:	48 ba 98 4f 80 00 00 	movabs $0x804f98,%rdx
  801f73:	00 00 00 
  801f76:	be 32 00 00 00       	mov    $0x32,%esi
  801f7b:	48 bf 6d 4f 80 00 00 	movabs $0x804f6d,%rdi
  801f82:	00 00 00 
  801f85:	b8 00 00 00 00       	mov    $0x0,%eax
  801f8a:	48 b9 d9 03 80 00 00 	movabs $0x8003d9,%rcx
  801f91:	00 00 00 
  801f94:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  801f96:	48 ba c0 4f 80 00 00 	movabs $0x804fc0,%rdx
  801f9d:	00 00 00 
  801fa0:	be 34 00 00 00       	mov    $0x34,%esi
  801fa5:	48 bf 6d 4f 80 00 00 	movabs $0x804f6d,%rdi
  801fac:	00 00 00 
  801faf:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb4:	48 b9 d9 03 80 00 00 	movabs $0x8003d9,%rcx
  801fbb:	00 00 00 
  801fbe:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  801fc0:	c9                   	leaveq 
  801fc1:	c3                   	retq   

0000000000801fc2 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801fc2:	55                   	push   %rbp
  801fc3:	48 89 e5             	mov    %rsp,%rbp
  801fc6:	48 83 ec 20          	sub    $0x20,%rsp
  801fca:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801fcd:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  801fd0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fd7:	01 00 00 
  801fda:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801fdd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fe1:	25 07 0e 00 00       	and    $0xe07,%eax
  801fe6:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801fe9:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801fec:	48 c1 e0 0c          	shl    $0xc,%rax
  801ff0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  801ff4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ff7:	25 00 04 00 00       	and    $0x400,%eax
  801ffc:	85 c0                	test   %eax,%eax
  801ffe:	74 57                	je     802057 <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  802000:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802003:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802007:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80200a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80200e:	41 89 f0             	mov    %esi,%r8d
  802011:	48 89 c6             	mov    %rax,%rsi
  802014:	bf 00 00 00 00       	mov    $0x0,%edi
  802019:	48 b8 46 1b 80 00 00 	movabs $0x801b46,%rax
  802020:	00 00 00 
  802023:	ff d0                	callq  *%rax
  802025:	85 c0                	test   %eax,%eax
  802027:	0f 8e 52 01 00 00    	jle    80217f <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  80202d:	48 ba f2 4f 80 00 00 	movabs $0x804ff2,%rdx
  802034:	00 00 00 
  802037:	be 4e 00 00 00       	mov    $0x4e,%esi
  80203c:	48 bf 6d 4f 80 00 00 	movabs $0x804f6d,%rdi
  802043:	00 00 00 
  802046:	b8 00 00 00 00       	mov    $0x0,%eax
  80204b:	48 b9 d9 03 80 00 00 	movabs $0x8003d9,%rcx
  802052:	00 00 00 
  802055:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  802057:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80205a:	83 e0 02             	and    $0x2,%eax
  80205d:	85 c0                	test   %eax,%eax
  80205f:	75 10                	jne    802071 <duppage+0xaf>
  802061:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802064:	25 00 08 00 00       	and    $0x800,%eax
  802069:	85 c0                	test   %eax,%eax
  80206b:	0f 84 bb 00 00 00    	je     80212c <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  802071:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802074:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  802079:	80 cc 08             	or     $0x8,%ah
  80207c:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  80207f:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802082:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802086:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802089:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80208d:	41 89 f0             	mov    %esi,%r8d
  802090:	48 89 c6             	mov    %rax,%rsi
  802093:	bf 00 00 00 00       	mov    $0x0,%edi
  802098:	48 b8 46 1b 80 00 00 	movabs $0x801b46,%rax
  80209f:	00 00 00 
  8020a2:	ff d0                	callq  *%rax
  8020a4:	85 c0                	test   %eax,%eax
  8020a6:	7e 2a                	jle    8020d2 <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  8020a8:	48 ba f2 4f 80 00 00 	movabs $0x804ff2,%rdx
  8020af:	00 00 00 
  8020b2:	be 55 00 00 00       	mov    $0x55,%esi
  8020b7:	48 bf 6d 4f 80 00 00 	movabs $0x804f6d,%rdi
  8020be:	00 00 00 
  8020c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c6:	48 b9 d9 03 80 00 00 	movabs $0x8003d9,%rcx
  8020cd:	00 00 00 
  8020d0:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  8020d2:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  8020d5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020dd:	41 89 c8             	mov    %ecx,%r8d
  8020e0:	48 89 d1             	mov    %rdx,%rcx
  8020e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8020e8:	48 89 c6             	mov    %rax,%rsi
  8020eb:	bf 00 00 00 00       	mov    $0x0,%edi
  8020f0:	48 b8 46 1b 80 00 00 	movabs $0x801b46,%rax
  8020f7:	00 00 00 
  8020fa:	ff d0                	callq  *%rax
  8020fc:	85 c0                	test   %eax,%eax
  8020fe:	7e 2a                	jle    80212a <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  802100:	48 ba f2 4f 80 00 00 	movabs $0x804ff2,%rdx
  802107:	00 00 00 
  80210a:	be 57 00 00 00       	mov    $0x57,%esi
  80210f:	48 bf 6d 4f 80 00 00 	movabs $0x804f6d,%rdi
  802116:	00 00 00 
  802119:	b8 00 00 00 00       	mov    $0x0,%eax
  80211e:	48 b9 d9 03 80 00 00 	movabs $0x8003d9,%rcx
  802125:	00 00 00 
  802128:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  80212a:	eb 53                	jmp    80217f <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  80212c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80212f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802133:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802136:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80213a:	41 89 f0             	mov    %esi,%r8d
  80213d:	48 89 c6             	mov    %rax,%rsi
  802140:	bf 00 00 00 00       	mov    $0x0,%edi
  802145:	48 b8 46 1b 80 00 00 	movabs $0x801b46,%rax
  80214c:	00 00 00 
  80214f:	ff d0                	callq  *%rax
  802151:	85 c0                	test   %eax,%eax
  802153:	7e 2a                	jle    80217f <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  802155:	48 ba f2 4f 80 00 00 	movabs $0x804ff2,%rdx
  80215c:	00 00 00 
  80215f:	be 5b 00 00 00       	mov    $0x5b,%esi
  802164:	48 bf 6d 4f 80 00 00 	movabs $0x804f6d,%rdi
  80216b:	00 00 00 
  80216e:	b8 00 00 00 00       	mov    $0x0,%eax
  802173:	48 b9 d9 03 80 00 00 	movabs $0x8003d9,%rcx
  80217a:	00 00 00 
  80217d:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  80217f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802184:	c9                   	leaveq 
  802185:	c3                   	retq   

0000000000802186 <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  802186:	55                   	push   %rbp
  802187:	48 89 e5             	mov    %rsp,%rbp
  80218a:	48 83 ec 18          	sub    $0x18,%rsp
  80218e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  802192:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802196:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  80219a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80219e:	48 c1 e8 27          	shr    $0x27,%rax
  8021a2:	48 89 c2             	mov    %rax,%rdx
  8021a5:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8021ac:	01 00 00 
  8021af:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021b3:	83 e0 01             	and    $0x1,%eax
  8021b6:	48 85 c0             	test   %rax,%rax
  8021b9:	74 51                	je     80220c <pt_is_mapped+0x86>
  8021bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021bf:	48 c1 e0 0c          	shl    $0xc,%rax
  8021c3:	48 c1 e8 1e          	shr    $0x1e,%rax
  8021c7:	48 89 c2             	mov    %rax,%rdx
  8021ca:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8021d1:	01 00 00 
  8021d4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021d8:	83 e0 01             	and    $0x1,%eax
  8021db:	48 85 c0             	test   %rax,%rax
  8021de:	74 2c                	je     80220c <pt_is_mapped+0x86>
  8021e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021e4:	48 c1 e0 0c          	shl    $0xc,%rax
  8021e8:	48 c1 e8 15          	shr    $0x15,%rax
  8021ec:	48 89 c2             	mov    %rax,%rdx
  8021ef:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021f6:	01 00 00 
  8021f9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021fd:	83 e0 01             	and    $0x1,%eax
  802200:	48 85 c0             	test   %rax,%rax
  802203:	74 07                	je     80220c <pt_is_mapped+0x86>
  802205:	b8 01 00 00 00       	mov    $0x1,%eax
  80220a:	eb 05                	jmp    802211 <pt_is_mapped+0x8b>
  80220c:	b8 00 00 00 00       	mov    $0x0,%eax
  802211:	83 e0 01             	and    $0x1,%eax
}
  802214:	c9                   	leaveq 
  802215:	c3                   	retq   

0000000000802216 <fork>:

envid_t
fork(void)
{
  802216:	55                   	push   %rbp
  802217:	48 89 e5             	mov    %rsp,%rbp
  80221a:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  80221e:	48 bf 2d 1e 80 00 00 	movabs $0x801e2d,%rdi
  802225:	00 00 00 
  802228:	48 b8 53 45 80 00 00 	movabs $0x804553,%rax
  80222f:	00 00 00 
  802232:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802234:	b8 07 00 00 00       	mov    $0x7,%eax
  802239:	cd 30                	int    $0x30
  80223b:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  80223e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  802241:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  802244:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802248:	79 30                	jns    80227a <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  80224a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80224d:	89 c1                	mov    %eax,%ecx
  80224f:	48 ba 10 50 80 00 00 	movabs $0x805010,%rdx
  802256:	00 00 00 
  802259:	be 86 00 00 00       	mov    $0x86,%esi
  80225e:	48 bf 6d 4f 80 00 00 	movabs $0x804f6d,%rdi
  802265:	00 00 00 
  802268:	b8 00 00 00 00       	mov    $0x0,%eax
  80226d:	49 b8 d9 03 80 00 00 	movabs $0x8003d9,%r8
  802274:	00 00 00 
  802277:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  80227a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80227e:	75 46                	jne    8022c6 <fork+0xb0>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  802280:	48 b8 7a 1a 80 00 00 	movabs $0x801a7a,%rax
  802287:	00 00 00 
  80228a:	ff d0                	callq  *%rax
  80228c:	25 ff 03 00 00       	and    $0x3ff,%eax
  802291:	48 63 d0             	movslq %eax,%rdx
  802294:	48 89 d0             	mov    %rdx,%rax
  802297:	48 c1 e0 03          	shl    $0x3,%rax
  80229b:	48 01 d0             	add    %rdx,%rax
  80229e:	48 c1 e0 05          	shl    $0x5,%rax
  8022a2:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8022a9:	00 00 00 
  8022ac:	48 01 c2             	add    %rax,%rdx
  8022af:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8022b6:	00 00 00 
  8022b9:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8022bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c1:	e9 d1 01 00 00       	jmpq   802497 <fork+0x281>
	}
	uint64_t ad = 0;
  8022c6:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8022cd:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8022ce:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  8022d3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8022d7:	e9 df 00 00 00       	jmpq   8023bb <fork+0x1a5>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  8022dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022e0:	48 c1 e8 27          	shr    $0x27,%rax
  8022e4:	48 89 c2             	mov    %rax,%rdx
  8022e7:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8022ee:	01 00 00 
  8022f1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022f5:	83 e0 01             	and    $0x1,%eax
  8022f8:	48 85 c0             	test   %rax,%rax
  8022fb:	0f 84 9e 00 00 00    	je     80239f <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  802301:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802305:	48 c1 e8 1e          	shr    $0x1e,%rax
  802309:	48 89 c2             	mov    %rax,%rdx
  80230c:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802313:	01 00 00 
  802316:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80231a:	83 e0 01             	and    $0x1,%eax
  80231d:	48 85 c0             	test   %rax,%rax
  802320:	74 73                	je     802395 <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  802322:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802326:	48 c1 e8 15          	shr    $0x15,%rax
  80232a:	48 89 c2             	mov    %rax,%rdx
  80232d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802334:	01 00 00 
  802337:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80233b:	83 e0 01             	and    $0x1,%eax
  80233e:	48 85 c0             	test   %rax,%rax
  802341:	74 48                	je     80238b <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  802343:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802347:	48 c1 e8 0c          	shr    $0xc,%rax
  80234b:	48 89 c2             	mov    %rax,%rdx
  80234e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802355:	01 00 00 
  802358:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80235c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802360:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802364:	83 e0 01             	and    $0x1,%eax
  802367:	48 85 c0             	test   %rax,%rax
  80236a:	74 47                	je     8023b3 <fork+0x19d>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  80236c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802370:	48 c1 e8 0c          	shr    $0xc,%rax
  802374:	89 c2                	mov    %eax,%edx
  802376:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802379:	89 d6                	mov    %edx,%esi
  80237b:	89 c7                	mov    %eax,%edi
  80237d:	48 b8 c2 1f 80 00 00 	movabs $0x801fc2,%rax
  802384:	00 00 00 
  802387:	ff d0                	callq  *%rax
  802389:	eb 28                	jmp    8023b3 <fork+0x19d>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  80238b:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  802392:	00 
  802393:	eb 1e                	jmp    8023b3 <fork+0x19d>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  802395:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  80239c:	40 
  80239d:	eb 14                	jmp    8023b3 <fork+0x19d>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  80239f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023a3:	48 c1 e8 27          	shr    $0x27,%rax
  8023a7:	48 83 c0 01          	add    $0x1,%rax
  8023ab:	48 c1 e0 27          	shl    $0x27,%rax
  8023af:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8023b3:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  8023ba:	00 
  8023bb:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  8023c2:	00 
  8023c3:	0f 87 13 ff ff ff    	ja     8022dc <fork+0xc6>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8023c9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8023cc:	ba 07 00 00 00       	mov    $0x7,%edx
  8023d1:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8023d6:	89 c7                	mov    %eax,%edi
  8023d8:	48 b8 f6 1a 80 00 00 	movabs $0x801af6,%rax
  8023df:	00 00 00 
  8023e2:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8023e4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8023e7:	ba 07 00 00 00       	mov    $0x7,%edx
  8023ec:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8023f1:	89 c7                	mov    %eax,%edi
  8023f3:	48 b8 f6 1a 80 00 00 	movabs $0x801af6,%rax
  8023fa:	00 00 00 
  8023fd:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  8023ff:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802402:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802408:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  80240d:	ba 00 00 00 00       	mov    $0x0,%edx
  802412:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802417:	89 c7                	mov    %eax,%edi
  802419:	48 b8 46 1b 80 00 00 	movabs $0x801b46,%rax
  802420:	00 00 00 
  802423:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  802425:	ba 00 10 00 00       	mov    $0x1000,%edx
  80242a:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80242f:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802434:	48 b8 eb 14 80 00 00 	movabs $0x8014eb,%rax
  80243b:	00 00 00 
  80243e:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  802440:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802445:	bf 00 00 00 00       	mov    $0x0,%edi
  80244a:	48 b8 a1 1b 80 00 00 	movabs $0x801ba1,%rax
  802451:	00 00 00 
  802454:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  802456:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80245d:	00 00 00 
  802460:	48 8b 00             	mov    (%rax),%rax
  802463:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  80246a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80246d:	48 89 d6             	mov    %rdx,%rsi
  802470:	89 c7                	mov    %eax,%edi
  802472:	48 b8 80 1c 80 00 00 	movabs $0x801c80,%rax
  802479:	00 00 00 
  80247c:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  80247e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802481:	be 02 00 00 00       	mov    $0x2,%esi
  802486:	89 c7                	mov    %eax,%edi
  802488:	48 b8 eb 1b 80 00 00 	movabs $0x801beb,%rax
  80248f:	00 00 00 
  802492:	ff d0                	callq  *%rax

	return envid;
  802494:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  802497:	c9                   	leaveq 
  802498:	c3                   	retq   

0000000000802499 <sfork>:

	
// Challenge!
int
sfork(void)
{
  802499:	55                   	push   %rbp
  80249a:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  80249d:	48 ba 28 50 80 00 00 	movabs $0x805028,%rdx
  8024a4:	00 00 00 
  8024a7:	be bf 00 00 00       	mov    $0xbf,%esi
  8024ac:	48 bf 6d 4f 80 00 00 	movabs $0x804f6d,%rdi
  8024b3:	00 00 00 
  8024b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8024bb:	48 b9 d9 03 80 00 00 	movabs $0x8003d9,%rcx
  8024c2:	00 00 00 
  8024c5:	ff d1                	callq  *%rcx

00000000008024c7 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8024c7:	55                   	push   %rbp
  8024c8:	48 89 e5             	mov    %rsp,%rbp
  8024cb:	48 83 ec 08          	sub    $0x8,%rsp
  8024cf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8024d3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8024d7:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8024de:	ff ff ff 
  8024e1:	48 01 d0             	add    %rdx,%rax
  8024e4:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8024e8:	c9                   	leaveq 
  8024e9:	c3                   	retq   

00000000008024ea <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8024ea:	55                   	push   %rbp
  8024eb:	48 89 e5             	mov    %rsp,%rbp
  8024ee:	48 83 ec 08          	sub    $0x8,%rsp
  8024f2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8024f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024fa:	48 89 c7             	mov    %rax,%rdi
  8024fd:	48 b8 c7 24 80 00 00 	movabs $0x8024c7,%rax
  802504:	00 00 00 
  802507:	ff d0                	callq  *%rax
  802509:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80250f:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802513:	c9                   	leaveq 
  802514:	c3                   	retq   

0000000000802515 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802515:	55                   	push   %rbp
  802516:	48 89 e5             	mov    %rsp,%rbp
  802519:	48 83 ec 18          	sub    $0x18,%rsp
  80251d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802521:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802528:	eb 6b                	jmp    802595 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80252a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80252d:	48 98                	cltq   
  80252f:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802535:	48 c1 e0 0c          	shl    $0xc,%rax
  802539:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80253d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802541:	48 c1 e8 15          	shr    $0x15,%rax
  802545:	48 89 c2             	mov    %rax,%rdx
  802548:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80254f:	01 00 00 
  802552:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802556:	83 e0 01             	and    $0x1,%eax
  802559:	48 85 c0             	test   %rax,%rax
  80255c:	74 21                	je     80257f <fd_alloc+0x6a>
  80255e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802562:	48 c1 e8 0c          	shr    $0xc,%rax
  802566:	48 89 c2             	mov    %rax,%rdx
  802569:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802570:	01 00 00 
  802573:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802577:	83 e0 01             	and    $0x1,%eax
  80257a:	48 85 c0             	test   %rax,%rax
  80257d:	75 12                	jne    802591 <fd_alloc+0x7c>
			*fd_store = fd;
  80257f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802583:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802587:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80258a:	b8 00 00 00 00       	mov    $0x0,%eax
  80258f:	eb 1a                	jmp    8025ab <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802591:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802595:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802599:	7e 8f                	jle    80252a <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80259b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80259f:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8025a6:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8025ab:	c9                   	leaveq 
  8025ac:	c3                   	retq   

00000000008025ad <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8025ad:	55                   	push   %rbp
  8025ae:	48 89 e5             	mov    %rsp,%rbp
  8025b1:	48 83 ec 20          	sub    $0x20,%rsp
  8025b5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025b8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8025bc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8025c0:	78 06                	js     8025c8 <fd_lookup+0x1b>
  8025c2:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8025c6:	7e 07                	jle    8025cf <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8025c8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025cd:	eb 6c                	jmp    80263b <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8025cf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025d2:	48 98                	cltq   
  8025d4:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8025da:	48 c1 e0 0c          	shl    $0xc,%rax
  8025de:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8025e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025e6:	48 c1 e8 15          	shr    $0x15,%rax
  8025ea:	48 89 c2             	mov    %rax,%rdx
  8025ed:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8025f4:	01 00 00 
  8025f7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025fb:	83 e0 01             	and    $0x1,%eax
  8025fe:	48 85 c0             	test   %rax,%rax
  802601:	74 21                	je     802624 <fd_lookup+0x77>
  802603:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802607:	48 c1 e8 0c          	shr    $0xc,%rax
  80260b:	48 89 c2             	mov    %rax,%rdx
  80260e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802615:	01 00 00 
  802618:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80261c:	83 e0 01             	and    $0x1,%eax
  80261f:	48 85 c0             	test   %rax,%rax
  802622:	75 07                	jne    80262b <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802624:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802629:	eb 10                	jmp    80263b <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80262b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80262f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802633:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802636:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80263b:	c9                   	leaveq 
  80263c:	c3                   	retq   

000000000080263d <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80263d:	55                   	push   %rbp
  80263e:	48 89 e5             	mov    %rsp,%rbp
  802641:	48 83 ec 30          	sub    $0x30,%rsp
  802645:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802649:	89 f0                	mov    %esi,%eax
  80264b:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80264e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802652:	48 89 c7             	mov    %rax,%rdi
  802655:	48 b8 c7 24 80 00 00 	movabs $0x8024c7,%rax
  80265c:	00 00 00 
  80265f:	ff d0                	callq  *%rax
  802661:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802665:	48 89 d6             	mov    %rdx,%rsi
  802668:	89 c7                	mov    %eax,%edi
  80266a:	48 b8 ad 25 80 00 00 	movabs $0x8025ad,%rax
  802671:	00 00 00 
  802674:	ff d0                	callq  *%rax
  802676:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802679:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80267d:	78 0a                	js     802689 <fd_close+0x4c>
	    || fd != fd2)
  80267f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802683:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802687:	74 12                	je     80269b <fd_close+0x5e>
		return (must_exist ? r : 0);
  802689:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80268d:	74 05                	je     802694 <fd_close+0x57>
  80268f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802692:	eb 05                	jmp    802699 <fd_close+0x5c>
  802694:	b8 00 00 00 00       	mov    $0x0,%eax
  802699:	eb 69                	jmp    802704 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80269b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80269f:	8b 00                	mov    (%rax),%eax
  8026a1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026a5:	48 89 d6             	mov    %rdx,%rsi
  8026a8:	89 c7                	mov    %eax,%edi
  8026aa:	48 b8 06 27 80 00 00 	movabs $0x802706,%rax
  8026b1:	00 00 00 
  8026b4:	ff d0                	callq  *%rax
  8026b6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026bd:	78 2a                	js     8026e9 <fd_close+0xac>
		if (dev->dev_close)
  8026bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026c3:	48 8b 40 20          	mov    0x20(%rax),%rax
  8026c7:	48 85 c0             	test   %rax,%rax
  8026ca:	74 16                	je     8026e2 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8026cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026d0:	48 8b 40 20          	mov    0x20(%rax),%rax
  8026d4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8026d8:	48 89 d7             	mov    %rdx,%rdi
  8026db:	ff d0                	callq  *%rax
  8026dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026e0:	eb 07                	jmp    8026e9 <fd_close+0xac>
		else
			r = 0;
  8026e2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8026e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026ed:	48 89 c6             	mov    %rax,%rsi
  8026f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8026f5:	48 b8 a1 1b 80 00 00 	movabs $0x801ba1,%rax
  8026fc:	00 00 00 
  8026ff:	ff d0                	callq  *%rax
	return r;
  802701:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802704:	c9                   	leaveq 
  802705:	c3                   	retq   

0000000000802706 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802706:	55                   	push   %rbp
  802707:	48 89 e5             	mov    %rsp,%rbp
  80270a:	48 83 ec 20          	sub    $0x20,%rsp
  80270e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802711:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802715:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80271c:	eb 41                	jmp    80275f <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80271e:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802725:	00 00 00 
  802728:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80272b:	48 63 d2             	movslq %edx,%rdx
  80272e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802732:	8b 00                	mov    (%rax),%eax
  802734:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802737:	75 22                	jne    80275b <dev_lookup+0x55>
			*dev = devtab[i];
  802739:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802740:	00 00 00 
  802743:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802746:	48 63 d2             	movslq %edx,%rdx
  802749:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80274d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802751:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802754:	b8 00 00 00 00       	mov    $0x0,%eax
  802759:	eb 60                	jmp    8027bb <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80275b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80275f:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802766:	00 00 00 
  802769:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80276c:	48 63 d2             	movslq %edx,%rdx
  80276f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802773:	48 85 c0             	test   %rax,%rax
  802776:	75 a6                	jne    80271e <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802778:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80277f:	00 00 00 
  802782:	48 8b 00             	mov    (%rax),%rax
  802785:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80278b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80278e:	89 c6                	mov    %eax,%esi
  802790:	48 bf 40 50 80 00 00 	movabs $0x805040,%rdi
  802797:	00 00 00 
  80279a:	b8 00 00 00 00       	mov    $0x0,%eax
  80279f:	48 b9 12 06 80 00 00 	movabs $0x800612,%rcx
  8027a6:	00 00 00 
  8027a9:	ff d1                	callq  *%rcx
	*dev = 0;
  8027ab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027af:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8027b6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8027bb:	c9                   	leaveq 
  8027bc:	c3                   	retq   

00000000008027bd <close>:

int
close(int fdnum)
{
  8027bd:	55                   	push   %rbp
  8027be:	48 89 e5             	mov    %rsp,%rbp
  8027c1:	48 83 ec 20          	sub    $0x20,%rsp
  8027c5:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027c8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027cc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027cf:	48 89 d6             	mov    %rdx,%rsi
  8027d2:	89 c7                	mov    %eax,%edi
  8027d4:	48 b8 ad 25 80 00 00 	movabs $0x8025ad,%rax
  8027db:	00 00 00 
  8027de:	ff d0                	callq  *%rax
  8027e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027e7:	79 05                	jns    8027ee <close+0x31>
		return r;
  8027e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027ec:	eb 18                	jmp    802806 <close+0x49>
	else
		return fd_close(fd, 1);
  8027ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027f2:	be 01 00 00 00       	mov    $0x1,%esi
  8027f7:	48 89 c7             	mov    %rax,%rdi
  8027fa:	48 b8 3d 26 80 00 00 	movabs $0x80263d,%rax
  802801:	00 00 00 
  802804:	ff d0                	callq  *%rax
}
  802806:	c9                   	leaveq 
  802807:	c3                   	retq   

0000000000802808 <close_all>:

void
close_all(void)
{
  802808:	55                   	push   %rbp
  802809:	48 89 e5             	mov    %rsp,%rbp
  80280c:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802810:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802817:	eb 15                	jmp    80282e <close_all+0x26>
		close(i);
  802819:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80281c:	89 c7                	mov    %eax,%edi
  80281e:	48 b8 bd 27 80 00 00 	movabs $0x8027bd,%rax
  802825:	00 00 00 
  802828:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80282a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80282e:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802832:	7e e5                	jle    802819 <close_all+0x11>
		close(i);
}
  802834:	c9                   	leaveq 
  802835:	c3                   	retq   

0000000000802836 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802836:	55                   	push   %rbp
  802837:	48 89 e5             	mov    %rsp,%rbp
  80283a:	48 83 ec 40          	sub    $0x40,%rsp
  80283e:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802841:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802844:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802848:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80284b:	48 89 d6             	mov    %rdx,%rsi
  80284e:	89 c7                	mov    %eax,%edi
  802850:	48 b8 ad 25 80 00 00 	movabs $0x8025ad,%rax
  802857:	00 00 00 
  80285a:	ff d0                	callq  *%rax
  80285c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80285f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802863:	79 08                	jns    80286d <dup+0x37>
		return r;
  802865:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802868:	e9 70 01 00 00       	jmpq   8029dd <dup+0x1a7>
	close(newfdnum);
  80286d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802870:	89 c7                	mov    %eax,%edi
  802872:	48 b8 bd 27 80 00 00 	movabs $0x8027bd,%rax
  802879:	00 00 00 
  80287c:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80287e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802881:	48 98                	cltq   
  802883:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802889:	48 c1 e0 0c          	shl    $0xc,%rax
  80288d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802891:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802895:	48 89 c7             	mov    %rax,%rdi
  802898:	48 b8 ea 24 80 00 00 	movabs $0x8024ea,%rax
  80289f:	00 00 00 
  8028a2:	ff d0                	callq  *%rax
  8028a4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8028a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028ac:	48 89 c7             	mov    %rax,%rdi
  8028af:	48 b8 ea 24 80 00 00 	movabs $0x8024ea,%rax
  8028b6:	00 00 00 
  8028b9:	ff d0                	callq  *%rax
  8028bb:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8028bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028c3:	48 c1 e8 15          	shr    $0x15,%rax
  8028c7:	48 89 c2             	mov    %rax,%rdx
  8028ca:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8028d1:	01 00 00 
  8028d4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028d8:	83 e0 01             	and    $0x1,%eax
  8028db:	48 85 c0             	test   %rax,%rax
  8028de:	74 73                	je     802953 <dup+0x11d>
  8028e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028e4:	48 c1 e8 0c          	shr    $0xc,%rax
  8028e8:	48 89 c2             	mov    %rax,%rdx
  8028eb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8028f2:	01 00 00 
  8028f5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028f9:	83 e0 01             	and    $0x1,%eax
  8028fc:	48 85 c0             	test   %rax,%rax
  8028ff:	74 52                	je     802953 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802901:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802905:	48 c1 e8 0c          	shr    $0xc,%rax
  802909:	48 89 c2             	mov    %rax,%rdx
  80290c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802913:	01 00 00 
  802916:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80291a:	25 07 0e 00 00       	and    $0xe07,%eax
  80291f:	89 c1                	mov    %eax,%ecx
  802921:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802925:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802929:	41 89 c8             	mov    %ecx,%r8d
  80292c:	48 89 d1             	mov    %rdx,%rcx
  80292f:	ba 00 00 00 00       	mov    $0x0,%edx
  802934:	48 89 c6             	mov    %rax,%rsi
  802937:	bf 00 00 00 00       	mov    $0x0,%edi
  80293c:	48 b8 46 1b 80 00 00 	movabs $0x801b46,%rax
  802943:	00 00 00 
  802946:	ff d0                	callq  *%rax
  802948:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80294b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80294f:	79 02                	jns    802953 <dup+0x11d>
			goto err;
  802951:	eb 57                	jmp    8029aa <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802953:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802957:	48 c1 e8 0c          	shr    $0xc,%rax
  80295b:	48 89 c2             	mov    %rax,%rdx
  80295e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802965:	01 00 00 
  802968:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80296c:	25 07 0e 00 00       	and    $0xe07,%eax
  802971:	89 c1                	mov    %eax,%ecx
  802973:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802977:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80297b:	41 89 c8             	mov    %ecx,%r8d
  80297e:	48 89 d1             	mov    %rdx,%rcx
  802981:	ba 00 00 00 00       	mov    $0x0,%edx
  802986:	48 89 c6             	mov    %rax,%rsi
  802989:	bf 00 00 00 00       	mov    $0x0,%edi
  80298e:	48 b8 46 1b 80 00 00 	movabs $0x801b46,%rax
  802995:	00 00 00 
  802998:	ff d0                	callq  *%rax
  80299a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80299d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029a1:	79 02                	jns    8029a5 <dup+0x16f>
		goto err;
  8029a3:	eb 05                	jmp    8029aa <dup+0x174>

	return newfdnum;
  8029a5:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8029a8:	eb 33                	jmp    8029dd <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8029aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029ae:	48 89 c6             	mov    %rax,%rsi
  8029b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8029b6:	48 b8 a1 1b 80 00 00 	movabs $0x801ba1,%rax
  8029bd:	00 00 00 
  8029c0:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8029c2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029c6:	48 89 c6             	mov    %rax,%rsi
  8029c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8029ce:	48 b8 a1 1b 80 00 00 	movabs $0x801ba1,%rax
  8029d5:	00 00 00 
  8029d8:	ff d0                	callq  *%rax
	return r;
  8029da:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8029dd:	c9                   	leaveq 
  8029de:	c3                   	retq   

00000000008029df <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8029df:	55                   	push   %rbp
  8029e0:	48 89 e5             	mov    %rsp,%rbp
  8029e3:	48 83 ec 40          	sub    $0x40,%rsp
  8029e7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8029ea:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8029ee:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8029f2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029f6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029f9:	48 89 d6             	mov    %rdx,%rsi
  8029fc:	89 c7                	mov    %eax,%edi
  8029fe:	48 b8 ad 25 80 00 00 	movabs $0x8025ad,%rax
  802a05:	00 00 00 
  802a08:	ff d0                	callq  *%rax
  802a0a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a0d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a11:	78 24                	js     802a37 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a17:	8b 00                	mov    (%rax),%eax
  802a19:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a1d:	48 89 d6             	mov    %rdx,%rsi
  802a20:	89 c7                	mov    %eax,%edi
  802a22:	48 b8 06 27 80 00 00 	movabs $0x802706,%rax
  802a29:	00 00 00 
  802a2c:	ff d0                	callq  *%rax
  802a2e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a31:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a35:	79 05                	jns    802a3c <read+0x5d>
		return r;
  802a37:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a3a:	eb 76                	jmp    802ab2 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802a3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a40:	8b 40 08             	mov    0x8(%rax),%eax
  802a43:	83 e0 03             	and    $0x3,%eax
  802a46:	83 f8 01             	cmp    $0x1,%eax
  802a49:	75 3a                	jne    802a85 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802a4b:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802a52:	00 00 00 
  802a55:	48 8b 00             	mov    (%rax),%rax
  802a58:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a5e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a61:	89 c6                	mov    %eax,%esi
  802a63:	48 bf 5f 50 80 00 00 	movabs $0x80505f,%rdi
  802a6a:	00 00 00 
  802a6d:	b8 00 00 00 00       	mov    $0x0,%eax
  802a72:	48 b9 12 06 80 00 00 	movabs $0x800612,%rcx
  802a79:	00 00 00 
  802a7c:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802a7e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a83:	eb 2d                	jmp    802ab2 <read+0xd3>
	}
	if (!dev->dev_read)
  802a85:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a89:	48 8b 40 10          	mov    0x10(%rax),%rax
  802a8d:	48 85 c0             	test   %rax,%rax
  802a90:	75 07                	jne    802a99 <read+0xba>
		return -E_NOT_SUPP;
  802a92:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a97:	eb 19                	jmp    802ab2 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802a99:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a9d:	48 8b 40 10          	mov    0x10(%rax),%rax
  802aa1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802aa5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802aa9:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802aad:	48 89 cf             	mov    %rcx,%rdi
  802ab0:	ff d0                	callq  *%rax
}
  802ab2:	c9                   	leaveq 
  802ab3:	c3                   	retq   

0000000000802ab4 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802ab4:	55                   	push   %rbp
  802ab5:	48 89 e5             	mov    %rsp,%rbp
  802ab8:	48 83 ec 30          	sub    $0x30,%rsp
  802abc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802abf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ac3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802ac7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802ace:	eb 49                	jmp    802b19 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802ad0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ad3:	48 98                	cltq   
  802ad5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ad9:	48 29 c2             	sub    %rax,%rdx
  802adc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802adf:	48 63 c8             	movslq %eax,%rcx
  802ae2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ae6:	48 01 c1             	add    %rax,%rcx
  802ae9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802aec:	48 89 ce             	mov    %rcx,%rsi
  802aef:	89 c7                	mov    %eax,%edi
  802af1:	48 b8 df 29 80 00 00 	movabs $0x8029df,%rax
  802af8:	00 00 00 
  802afb:	ff d0                	callq  *%rax
  802afd:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802b00:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b04:	79 05                	jns    802b0b <readn+0x57>
			return m;
  802b06:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b09:	eb 1c                	jmp    802b27 <readn+0x73>
		if (m == 0)
  802b0b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b0f:	75 02                	jne    802b13 <readn+0x5f>
			break;
  802b11:	eb 11                	jmp    802b24 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802b13:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b16:	01 45 fc             	add    %eax,-0x4(%rbp)
  802b19:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b1c:	48 98                	cltq   
  802b1e:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802b22:	72 ac                	jb     802ad0 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802b24:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802b27:	c9                   	leaveq 
  802b28:	c3                   	retq   

0000000000802b29 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802b29:	55                   	push   %rbp
  802b2a:	48 89 e5             	mov    %rsp,%rbp
  802b2d:	48 83 ec 40          	sub    $0x40,%rsp
  802b31:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b34:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802b38:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b3c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b40:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b43:	48 89 d6             	mov    %rdx,%rsi
  802b46:	89 c7                	mov    %eax,%edi
  802b48:	48 b8 ad 25 80 00 00 	movabs $0x8025ad,%rax
  802b4f:	00 00 00 
  802b52:	ff d0                	callq  *%rax
  802b54:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b57:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b5b:	78 24                	js     802b81 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b61:	8b 00                	mov    (%rax),%eax
  802b63:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b67:	48 89 d6             	mov    %rdx,%rsi
  802b6a:	89 c7                	mov    %eax,%edi
  802b6c:	48 b8 06 27 80 00 00 	movabs $0x802706,%rax
  802b73:	00 00 00 
  802b76:	ff d0                	callq  *%rax
  802b78:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b7b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b7f:	79 05                	jns    802b86 <write+0x5d>
		return r;
  802b81:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b84:	eb 75                	jmp    802bfb <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802b86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b8a:	8b 40 08             	mov    0x8(%rax),%eax
  802b8d:	83 e0 03             	and    $0x3,%eax
  802b90:	85 c0                	test   %eax,%eax
  802b92:	75 3a                	jne    802bce <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802b94:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802b9b:	00 00 00 
  802b9e:	48 8b 00             	mov    (%rax),%rax
  802ba1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ba7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802baa:	89 c6                	mov    %eax,%esi
  802bac:	48 bf 7b 50 80 00 00 	movabs $0x80507b,%rdi
  802bb3:	00 00 00 
  802bb6:	b8 00 00 00 00       	mov    $0x0,%eax
  802bbb:	48 b9 12 06 80 00 00 	movabs $0x800612,%rcx
  802bc2:	00 00 00 
  802bc5:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802bc7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802bcc:	eb 2d                	jmp    802bfb <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  802bce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bd2:	48 8b 40 18          	mov    0x18(%rax),%rax
  802bd6:	48 85 c0             	test   %rax,%rax
  802bd9:	75 07                	jne    802be2 <write+0xb9>
		return -E_NOT_SUPP;
  802bdb:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802be0:	eb 19                	jmp    802bfb <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802be2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802be6:	48 8b 40 18          	mov    0x18(%rax),%rax
  802bea:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802bee:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802bf2:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802bf6:	48 89 cf             	mov    %rcx,%rdi
  802bf9:	ff d0                	callq  *%rax
}
  802bfb:	c9                   	leaveq 
  802bfc:	c3                   	retq   

0000000000802bfd <seek>:

int
seek(int fdnum, off_t offset)
{
  802bfd:	55                   	push   %rbp
  802bfe:	48 89 e5             	mov    %rsp,%rbp
  802c01:	48 83 ec 18          	sub    $0x18,%rsp
  802c05:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c08:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802c0b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c0f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c12:	48 89 d6             	mov    %rdx,%rsi
  802c15:	89 c7                	mov    %eax,%edi
  802c17:	48 b8 ad 25 80 00 00 	movabs $0x8025ad,%rax
  802c1e:	00 00 00 
  802c21:	ff d0                	callq  *%rax
  802c23:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c26:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c2a:	79 05                	jns    802c31 <seek+0x34>
		return r;
  802c2c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c2f:	eb 0f                	jmp    802c40 <seek+0x43>
	fd->fd_offset = offset;
  802c31:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c35:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802c38:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802c3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c40:	c9                   	leaveq 
  802c41:	c3                   	retq   

0000000000802c42 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802c42:	55                   	push   %rbp
  802c43:	48 89 e5             	mov    %rsp,%rbp
  802c46:	48 83 ec 30          	sub    $0x30,%rsp
  802c4a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c4d:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c50:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c54:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c57:	48 89 d6             	mov    %rdx,%rsi
  802c5a:	89 c7                	mov    %eax,%edi
  802c5c:	48 b8 ad 25 80 00 00 	movabs $0x8025ad,%rax
  802c63:	00 00 00 
  802c66:	ff d0                	callq  *%rax
  802c68:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c6b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c6f:	78 24                	js     802c95 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c75:	8b 00                	mov    (%rax),%eax
  802c77:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c7b:	48 89 d6             	mov    %rdx,%rsi
  802c7e:	89 c7                	mov    %eax,%edi
  802c80:	48 b8 06 27 80 00 00 	movabs $0x802706,%rax
  802c87:	00 00 00 
  802c8a:	ff d0                	callq  *%rax
  802c8c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c8f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c93:	79 05                	jns    802c9a <ftruncate+0x58>
		return r;
  802c95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c98:	eb 72                	jmp    802d0c <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802c9a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c9e:	8b 40 08             	mov    0x8(%rax),%eax
  802ca1:	83 e0 03             	and    $0x3,%eax
  802ca4:	85 c0                	test   %eax,%eax
  802ca6:	75 3a                	jne    802ce2 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802ca8:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802caf:	00 00 00 
  802cb2:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802cb5:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802cbb:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802cbe:	89 c6                	mov    %eax,%esi
  802cc0:	48 bf 98 50 80 00 00 	movabs $0x805098,%rdi
  802cc7:	00 00 00 
  802cca:	b8 00 00 00 00       	mov    $0x0,%eax
  802ccf:	48 b9 12 06 80 00 00 	movabs $0x800612,%rcx
  802cd6:	00 00 00 
  802cd9:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802cdb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ce0:	eb 2a                	jmp    802d0c <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802ce2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ce6:	48 8b 40 30          	mov    0x30(%rax),%rax
  802cea:	48 85 c0             	test   %rax,%rax
  802ced:	75 07                	jne    802cf6 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802cef:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802cf4:	eb 16                	jmp    802d0c <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802cf6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cfa:	48 8b 40 30          	mov    0x30(%rax),%rax
  802cfe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d02:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802d05:	89 ce                	mov    %ecx,%esi
  802d07:	48 89 d7             	mov    %rdx,%rdi
  802d0a:	ff d0                	callq  *%rax
}
  802d0c:	c9                   	leaveq 
  802d0d:	c3                   	retq   

0000000000802d0e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802d0e:	55                   	push   %rbp
  802d0f:	48 89 e5             	mov    %rsp,%rbp
  802d12:	48 83 ec 30          	sub    $0x30,%rsp
  802d16:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d19:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d1d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d21:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d24:	48 89 d6             	mov    %rdx,%rsi
  802d27:	89 c7                	mov    %eax,%edi
  802d29:	48 b8 ad 25 80 00 00 	movabs $0x8025ad,%rax
  802d30:	00 00 00 
  802d33:	ff d0                	callq  *%rax
  802d35:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d38:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d3c:	78 24                	js     802d62 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d42:	8b 00                	mov    (%rax),%eax
  802d44:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d48:	48 89 d6             	mov    %rdx,%rsi
  802d4b:	89 c7                	mov    %eax,%edi
  802d4d:	48 b8 06 27 80 00 00 	movabs $0x802706,%rax
  802d54:	00 00 00 
  802d57:	ff d0                	callq  *%rax
  802d59:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d5c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d60:	79 05                	jns    802d67 <fstat+0x59>
		return r;
  802d62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d65:	eb 5e                	jmp    802dc5 <fstat+0xb7>
	if (!dev->dev_stat)
  802d67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d6b:	48 8b 40 28          	mov    0x28(%rax),%rax
  802d6f:	48 85 c0             	test   %rax,%rax
  802d72:	75 07                	jne    802d7b <fstat+0x6d>
		return -E_NOT_SUPP;
  802d74:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d79:	eb 4a                	jmp    802dc5 <fstat+0xb7>
	stat->st_name[0] = 0;
  802d7b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d7f:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802d82:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d86:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802d8d:	00 00 00 
	stat->st_isdir = 0;
  802d90:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d94:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802d9b:	00 00 00 
	stat->st_dev = dev;
  802d9e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802da2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802da6:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802dad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802db1:	48 8b 40 28          	mov    0x28(%rax),%rax
  802db5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802db9:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802dbd:	48 89 ce             	mov    %rcx,%rsi
  802dc0:	48 89 d7             	mov    %rdx,%rdi
  802dc3:	ff d0                	callq  *%rax
}
  802dc5:	c9                   	leaveq 
  802dc6:	c3                   	retq   

0000000000802dc7 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802dc7:	55                   	push   %rbp
  802dc8:	48 89 e5             	mov    %rsp,%rbp
  802dcb:	48 83 ec 20          	sub    $0x20,%rsp
  802dcf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802dd3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802dd7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ddb:	be 00 00 00 00       	mov    $0x0,%esi
  802de0:	48 89 c7             	mov    %rax,%rdi
  802de3:	48 b8 b5 2e 80 00 00 	movabs $0x802eb5,%rax
  802dea:	00 00 00 
  802ded:	ff d0                	callq  *%rax
  802def:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802df2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802df6:	79 05                	jns    802dfd <stat+0x36>
		return fd;
  802df8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dfb:	eb 2f                	jmp    802e2c <stat+0x65>
	r = fstat(fd, stat);
  802dfd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802e01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e04:	48 89 d6             	mov    %rdx,%rsi
  802e07:	89 c7                	mov    %eax,%edi
  802e09:	48 b8 0e 2d 80 00 00 	movabs $0x802d0e,%rax
  802e10:	00 00 00 
  802e13:	ff d0                	callq  *%rax
  802e15:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802e18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e1b:	89 c7                	mov    %eax,%edi
  802e1d:	48 b8 bd 27 80 00 00 	movabs $0x8027bd,%rax
  802e24:	00 00 00 
  802e27:	ff d0                	callq  *%rax
	return r;
  802e29:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802e2c:	c9                   	leaveq 
  802e2d:	c3                   	retq   

0000000000802e2e <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802e2e:	55                   	push   %rbp
  802e2f:	48 89 e5             	mov    %rsp,%rbp
  802e32:	48 83 ec 10          	sub    $0x10,%rsp
  802e36:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802e39:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802e3d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e44:	00 00 00 
  802e47:	8b 00                	mov    (%rax),%eax
  802e49:	85 c0                	test   %eax,%eax
  802e4b:	75 1d                	jne    802e6a <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802e4d:	bf 01 00 00 00       	mov    $0x1,%edi
  802e52:	48 b8 fb 47 80 00 00 	movabs $0x8047fb,%rax
  802e59:	00 00 00 
  802e5c:	ff d0                	callq  *%rax
  802e5e:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802e65:	00 00 00 
  802e68:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802e6a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e71:	00 00 00 
  802e74:	8b 00                	mov    (%rax),%eax
  802e76:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802e79:	b9 07 00 00 00       	mov    $0x7,%ecx
  802e7e:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  802e85:	00 00 00 
  802e88:	89 c7                	mov    %eax,%edi
  802e8a:	48 b8 99 47 80 00 00 	movabs $0x804799,%rax
  802e91:	00 00 00 
  802e94:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802e96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e9a:	ba 00 00 00 00       	mov    $0x0,%edx
  802e9f:	48 89 c6             	mov    %rax,%rsi
  802ea2:	bf 00 00 00 00       	mov    $0x0,%edi
  802ea7:	48 b8 93 46 80 00 00 	movabs $0x804693,%rax
  802eae:	00 00 00 
  802eb1:	ff d0                	callq  *%rax
}
  802eb3:	c9                   	leaveq 
  802eb4:	c3                   	retq   

0000000000802eb5 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802eb5:	55                   	push   %rbp
  802eb6:	48 89 e5             	mov    %rsp,%rbp
  802eb9:	48 83 ec 30          	sub    $0x30,%rsp
  802ebd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802ec1:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802ec4:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802ecb:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802ed2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802ed9:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802ede:	75 08                	jne    802ee8 <open+0x33>
	{
		return r;
  802ee0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ee3:	e9 f2 00 00 00       	jmpq   802fda <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802ee8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802eec:	48 89 c7             	mov    %rax,%rdi
  802eef:	48 b8 5b 11 80 00 00 	movabs $0x80115b,%rax
  802ef6:	00 00 00 
  802ef9:	ff d0                	callq  *%rax
  802efb:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802efe:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802f05:	7e 0a                	jle    802f11 <open+0x5c>
	{
		return -E_BAD_PATH;
  802f07:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802f0c:	e9 c9 00 00 00       	jmpq   802fda <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802f11:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802f18:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802f19:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802f1d:	48 89 c7             	mov    %rax,%rdi
  802f20:	48 b8 15 25 80 00 00 	movabs $0x802515,%rax
  802f27:	00 00 00 
  802f2a:	ff d0                	callq  *%rax
  802f2c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f2f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f33:	78 09                	js     802f3e <open+0x89>
  802f35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f39:	48 85 c0             	test   %rax,%rax
  802f3c:	75 08                	jne    802f46 <open+0x91>
		{
			return r;
  802f3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f41:	e9 94 00 00 00       	jmpq   802fda <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802f46:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f4a:	ba 00 04 00 00       	mov    $0x400,%edx
  802f4f:	48 89 c6             	mov    %rax,%rsi
  802f52:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802f59:	00 00 00 
  802f5c:	48 b8 59 12 80 00 00 	movabs $0x801259,%rax
  802f63:	00 00 00 
  802f66:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802f68:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802f6f:	00 00 00 
  802f72:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802f75:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802f7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f7f:	48 89 c6             	mov    %rax,%rsi
  802f82:	bf 01 00 00 00       	mov    $0x1,%edi
  802f87:	48 b8 2e 2e 80 00 00 	movabs $0x802e2e,%rax
  802f8e:	00 00 00 
  802f91:	ff d0                	callq  *%rax
  802f93:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f96:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f9a:	79 2b                	jns    802fc7 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802f9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fa0:	be 00 00 00 00       	mov    $0x0,%esi
  802fa5:	48 89 c7             	mov    %rax,%rdi
  802fa8:	48 b8 3d 26 80 00 00 	movabs $0x80263d,%rax
  802faf:	00 00 00 
  802fb2:	ff d0                	callq  *%rax
  802fb4:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802fb7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802fbb:	79 05                	jns    802fc2 <open+0x10d>
			{
				return d;
  802fbd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802fc0:	eb 18                	jmp    802fda <open+0x125>
			}
			return r;
  802fc2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fc5:	eb 13                	jmp    802fda <open+0x125>
		}	
		return fd2num(fd_store);
  802fc7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fcb:	48 89 c7             	mov    %rax,%rdi
  802fce:	48 b8 c7 24 80 00 00 	movabs $0x8024c7,%rax
  802fd5:	00 00 00 
  802fd8:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802fda:	c9                   	leaveq 
  802fdb:	c3                   	retq   

0000000000802fdc <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802fdc:	55                   	push   %rbp
  802fdd:	48 89 e5             	mov    %rsp,%rbp
  802fe0:	48 83 ec 10          	sub    $0x10,%rsp
  802fe4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802fe8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fec:	8b 50 0c             	mov    0xc(%rax),%edx
  802fef:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802ff6:	00 00 00 
  802ff9:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802ffb:	be 00 00 00 00       	mov    $0x0,%esi
  803000:	bf 06 00 00 00       	mov    $0x6,%edi
  803005:	48 b8 2e 2e 80 00 00 	movabs $0x802e2e,%rax
  80300c:	00 00 00 
  80300f:	ff d0                	callq  *%rax
}
  803011:	c9                   	leaveq 
  803012:	c3                   	retq   

0000000000803013 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803013:	55                   	push   %rbp
  803014:	48 89 e5             	mov    %rsp,%rbp
  803017:	48 83 ec 30          	sub    $0x30,%rsp
  80301b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80301f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803023:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  803027:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  80302e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803033:	74 07                	je     80303c <devfile_read+0x29>
  803035:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80303a:	75 07                	jne    803043 <devfile_read+0x30>
		return -E_INVAL;
  80303c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803041:	eb 77                	jmp    8030ba <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  803043:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803047:	8b 50 0c             	mov    0xc(%rax),%edx
  80304a:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803051:	00 00 00 
  803054:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  803056:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80305d:	00 00 00 
  803060:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803064:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  803068:	be 00 00 00 00       	mov    $0x0,%esi
  80306d:	bf 03 00 00 00       	mov    $0x3,%edi
  803072:	48 b8 2e 2e 80 00 00 	movabs $0x802e2e,%rax
  803079:	00 00 00 
  80307c:	ff d0                	callq  *%rax
  80307e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803081:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803085:	7f 05                	jg     80308c <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  803087:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80308a:	eb 2e                	jmp    8030ba <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  80308c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80308f:	48 63 d0             	movslq %eax,%rdx
  803092:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803096:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  80309d:	00 00 00 
  8030a0:	48 89 c7             	mov    %rax,%rdi
  8030a3:	48 b8 eb 14 80 00 00 	movabs $0x8014eb,%rax
  8030aa:	00 00 00 
  8030ad:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  8030af:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030b3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  8030b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8030ba:	c9                   	leaveq 
  8030bb:	c3                   	retq   

00000000008030bc <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8030bc:	55                   	push   %rbp
  8030bd:	48 89 e5             	mov    %rsp,%rbp
  8030c0:	48 83 ec 30          	sub    $0x30,%rsp
  8030c4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030c8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030cc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  8030d0:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  8030d7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8030dc:	74 07                	je     8030e5 <devfile_write+0x29>
  8030de:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8030e3:	75 08                	jne    8030ed <devfile_write+0x31>
		return r;
  8030e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030e8:	e9 9a 00 00 00       	jmpq   803187 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8030ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030f1:	8b 50 0c             	mov    0xc(%rax),%edx
  8030f4:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8030fb:	00 00 00 
  8030fe:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  803100:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  803107:	00 
  803108:	76 08                	jbe    803112 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  80310a:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  803111:	00 
	}
	fsipcbuf.write.req_n = n;
  803112:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803119:	00 00 00 
  80311c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803120:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  803124:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803128:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80312c:	48 89 c6             	mov    %rax,%rsi
  80312f:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  803136:	00 00 00 
  803139:	48 b8 eb 14 80 00 00 	movabs $0x8014eb,%rax
  803140:	00 00 00 
  803143:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  803145:	be 00 00 00 00       	mov    $0x0,%esi
  80314a:	bf 04 00 00 00       	mov    $0x4,%edi
  80314f:	48 b8 2e 2e 80 00 00 	movabs $0x802e2e,%rax
  803156:	00 00 00 
  803159:	ff d0                	callq  *%rax
  80315b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80315e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803162:	7f 20                	jg     803184 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  803164:	48 bf be 50 80 00 00 	movabs $0x8050be,%rdi
  80316b:	00 00 00 
  80316e:	b8 00 00 00 00       	mov    $0x0,%eax
  803173:	48 ba 12 06 80 00 00 	movabs $0x800612,%rdx
  80317a:	00 00 00 
  80317d:	ff d2                	callq  *%rdx
		return r;
  80317f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803182:	eb 03                	jmp    803187 <devfile_write+0xcb>
	}
	return r;
  803184:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  803187:	c9                   	leaveq 
  803188:	c3                   	retq   

0000000000803189 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803189:	55                   	push   %rbp
  80318a:	48 89 e5             	mov    %rsp,%rbp
  80318d:	48 83 ec 20          	sub    $0x20,%rsp
  803191:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803195:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803199:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80319d:	8b 50 0c             	mov    0xc(%rax),%edx
  8031a0:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8031a7:	00 00 00 
  8031aa:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8031ac:	be 00 00 00 00       	mov    $0x0,%esi
  8031b1:	bf 05 00 00 00       	mov    $0x5,%edi
  8031b6:	48 b8 2e 2e 80 00 00 	movabs $0x802e2e,%rax
  8031bd:	00 00 00 
  8031c0:	ff d0                	callq  *%rax
  8031c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031c9:	79 05                	jns    8031d0 <devfile_stat+0x47>
		return r;
  8031cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031ce:	eb 56                	jmp    803226 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8031d0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031d4:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8031db:	00 00 00 
  8031de:	48 89 c7             	mov    %rax,%rdi
  8031e1:	48 b8 c7 11 80 00 00 	movabs $0x8011c7,%rax
  8031e8:	00 00 00 
  8031eb:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8031ed:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8031f4:	00 00 00 
  8031f7:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8031fd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803201:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803207:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80320e:	00 00 00 
  803211:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803217:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80321b:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803221:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803226:	c9                   	leaveq 
  803227:	c3                   	retq   

0000000000803228 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803228:	55                   	push   %rbp
  803229:	48 89 e5             	mov    %rsp,%rbp
  80322c:	48 83 ec 10          	sub    $0x10,%rsp
  803230:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803234:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803237:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80323b:	8b 50 0c             	mov    0xc(%rax),%edx
  80323e:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803245:	00 00 00 
  803248:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80324a:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803251:	00 00 00 
  803254:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803257:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80325a:	be 00 00 00 00       	mov    $0x0,%esi
  80325f:	bf 02 00 00 00       	mov    $0x2,%edi
  803264:	48 b8 2e 2e 80 00 00 	movabs $0x802e2e,%rax
  80326b:	00 00 00 
  80326e:	ff d0                	callq  *%rax
}
  803270:	c9                   	leaveq 
  803271:	c3                   	retq   

0000000000803272 <remove>:

// Delete a file
int
remove(const char *path)
{
  803272:	55                   	push   %rbp
  803273:	48 89 e5             	mov    %rsp,%rbp
  803276:	48 83 ec 10          	sub    $0x10,%rsp
  80327a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  80327e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803282:	48 89 c7             	mov    %rax,%rdi
  803285:	48 b8 5b 11 80 00 00 	movabs $0x80115b,%rax
  80328c:	00 00 00 
  80328f:	ff d0                	callq  *%rax
  803291:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803296:	7e 07                	jle    80329f <remove+0x2d>
		return -E_BAD_PATH;
  803298:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80329d:	eb 33                	jmp    8032d2 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  80329f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032a3:	48 89 c6             	mov    %rax,%rsi
  8032a6:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8032ad:	00 00 00 
  8032b0:	48 b8 c7 11 80 00 00 	movabs $0x8011c7,%rax
  8032b7:	00 00 00 
  8032ba:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8032bc:	be 00 00 00 00       	mov    $0x0,%esi
  8032c1:	bf 07 00 00 00       	mov    $0x7,%edi
  8032c6:	48 b8 2e 2e 80 00 00 	movabs $0x802e2e,%rax
  8032cd:	00 00 00 
  8032d0:	ff d0                	callq  *%rax
}
  8032d2:	c9                   	leaveq 
  8032d3:	c3                   	retq   

00000000008032d4 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8032d4:	55                   	push   %rbp
  8032d5:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8032d8:	be 00 00 00 00       	mov    $0x0,%esi
  8032dd:	bf 08 00 00 00       	mov    $0x8,%edi
  8032e2:	48 b8 2e 2e 80 00 00 	movabs $0x802e2e,%rax
  8032e9:	00 00 00 
  8032ec:	ff d0                	callq  *%rax
}
  8032ee:	5d                   	pop    %rbp
  8032ef:	c3                   	retq   

00000000008032f0 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8032f0:	55                   	push   %rbp
  8032f1:	48 89 e5             	mov    %rsp,%rbp
  8032f4:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8032fb:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803302:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803309:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803310:	be 00 00 00 00       	mov    $0x0,%esi
  803315:	48 89 c7             	mov    %rax,%rdi
  803318:	48 b8 b5 2e 80 00 00 	movabs $0x802eb5,%rax
  80331f:	00 00 00 
  803322:	ff d0                	callq  *%rax
  803324:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803327:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80332b:	79 28                	jns    803355 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  80332d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803330:	89 c6                	mov    %eax,%esi
  803332:	48 bf da 50 80 00 00 	movabs $0x8050da,%rdi
  803339:	00 00 00 
  80333c:	b8 00 00 00 00       	mov    $0x0,%eax
  803341:	48 ba 12 06 80 00 00 	movabs $0x800612,%rdx
  803348:	00 00 00 
  80334b:	ff d2                	callq  *%rdx
		return fd_src;
  80334d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803350:	e9 74 01 00 00       	jmpq   8034c9 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803355:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  80335c:	be 01 01 00 00       	mov    $0x101,%esi
  803361:	48 89 c7             	mov    %rax,%rdi
  803364:	48 b8 b5 2e 80 00 00 	movabs $0x802eb5,%rax
  80336b:	00 00 00 
  80336e:	ff d0                	callq  *%rax
  803370:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803373:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803377:	79 39                	jns    8033b2 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803379:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80337c:	89 c6                	mov    %eax,%esi
  80337e:	48 bf f0 50 80 00 00 	movabs $0x8050f0,%rdi
  803385:	00 00 00 
  803388:	b8 00 00 00 00       	mov    $0x0,%eax
  80338d:	48 ba 12 06 80 00 00 	movabs $0x800612,%rdx
  803394:	00 00 00 
  803397:	ff d2                	callq  *%rdx
		close(fd_src);
  803399:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80339c:	89 c7                	mov    %eax,%edi
  80339e:	48 b8 bd 27 80 00 00 	movabs $0x8027bd,%rax
  8033a5:	00 00 00 
  8033a8:	ff d0                	callq  *%rax
		return fd_dest;
  8033aa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033ad:	e9 17 01 00 00       	jmpq   8034c9 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8033b2:	eb 74                	jmp    803428 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8033b4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8033b7:	48 63 d0             	movslq %eax,%rdx
  8033ba:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8033c1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033c4:	48 89 ce             	mov    %rcx,%rsi
  8033c7:	89 c7                	mov    %eax,%edi
  8033c9:	48 b8 29 2b 80 00 00 	movabs $0x802b29,%rax
  8033d0:	00 00 00 
  8033d3:	ff d0                	callq  *%rax
  8033d5:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8033d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8033dc:	79 4a                	jns    803428 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8033de:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8033e1:	89 c6                	mov    %eax,%esi
  8033e3:	48 bf 0a 51 80 00 00 	movabs $0x80510a,%rdi
  8033ea:	00 00 00 
  8033ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8033f2:	48 ba 12 06 80 00 00 	movabs $0x800612,%rdx
  8033f9:	00 00 00 
  8033fc:	ff d2                	callq  *%rdx
			close(fd_src);
  8033fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803401:	89 c7                	mov    %eax,%edi
  803403:	48 b8 bd 27 80 00 00 	movabs $0x8027bd,%rax
  80340a:	00 00 00 
  80340d:	ff d0                	callq  *%rax
			close(fd_dest);
  80340f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803412:	89 c7                	mov    %eax,%edi
  803414:	48 b8 bd 27 80 00 00 	movabs $0x8027bd,%rax
  80341b:	00 00 00 
  80341e:	ff d0                	callq  *%rax
			return write_size;
  803420:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803423:	e9 a1 00 00 00       	jmpq   8034c9 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803428:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80342f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803432:	ba 00 02 00 00       	mov    $0x200,%edx
  803437:	48 89 ce             	mov    %rcx,%rsi
  80343a:	89 c7                	mov    %eax,%edi
  80343c:	48 b8 df 29 80 00 00 	movabs $0x8029df,%rax
  803443:	00 00 00 
  803446:	ff d0                	callq  *%rax
  803448:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80344b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80344f:	0f 8f 5f ff ff ff    	jg     8033b4 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803455:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803459:	79 47                	jns    8034a2 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  80345b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80345e:	89 c6                	mov    %eax,%esi
  803460:	48 bf 1d 51 80 00 00 	movabs $0x80511d,%rdi
  803467:	00 00 00 
  80346a:	b8 00 00 00 00       	mov    $0x0,%eax
  80346f:	48 ba 12 06 80 00 00 	movabs $0x800612,%rdx
  803476:	00 00 00 
  803479:	ff d2                	callq  *%rdx
		close(fd_src);
  80347b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80347e:	89 c7                	mov    %eax,%edi
  803480:	48 b8 bd 27 80 00 00 	movabs $0x8027bd,%rax
  803487:	00 00 00 
  80348a:	ff d0                	callq  *%rax
		close(fd_dest);
  80348c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80348f:	89 c7                	mov    %eax,%edi
  803491:	48 b8 bd 27 80 00 00 	movabs $0x8027bd,%rax
  803498:	00 00 00 
  80349b:	ff d0                	callq  *%rax
		return read_size;
  80349d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8034a0:	eb 27                	jmp    8034c9 <copy+0x1d9>
	}
	close(fd_src);
  8034a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034a5:	89 c7                	mov    %eax,%edi
  8034a7:	48 b8 bd 27 80 00 00 	movabs $0x8027bd,%rax
  8034ae:	00 00 00 
  8034b1:	ff d0                	callq  *%rax
	close(fd_dest);
  8034b3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034b6:	89 c7                	mov    %eax,%edi
  8034b8:	48 b8 bd 27 80 00 00 	movabs $0x8027bd,%rax
  8034bf:	00 00 00 
  8034c2:	ff d0                	callq  *%rax
	return 0;
  8034c4:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8034c9:	c9                   	leaveq 
  8034ca:	c3                   	retq   

00000000008034cb <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8034cb:	55                   	push   %rbp
  8034cc:	48 89 e5             	mov    %rsp,%rbp
  8034cf:	48 83 ec 20          	sub    $0x20,%rsp
  8034d3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8034d6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8034da:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034dd:	48 89 d6             	mov    %rdx,%rsi
  8034e0:	89 c7                	mov    %eax,%edi
  8034e2:	48 b8 ad 25 80 00 00 	movabs $0x8025ad,%rax
  8034e9:	00 00 00 
  8034ec:	ff d0                	callq  *%rax
  8034ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034f5:	79 05                	jns    8034fc <fd2sockid+0x31>
		return r;
  8034f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034fa:	eb 24                	jmp    803520 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8034fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803500:	8b 10                	mov    (%rax),%edx
  803502:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  803509:	00 00 00 
  80350c:	8b 00                	mov    (%rax),%eax
  80350e:	39 c2                	cmp    %eax,%edx
  803510:	74 07                	je     803519 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803512:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803517:	eb 07                	jmp    803520 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803519:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80351d:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803520:	c9                   	leaveq 
  803521:	c3                   	retq   

0000000000803522 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803522:	55                   	push   %rbp
  803523:	48 89 e5             	mov    %rsp,%rbp
  803526:	48 83 ec 20          	sub    $0x20,%rsp
  80352a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  80352d:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803531:	48 89 c7             	mov    %rax,%rdi
  803534:	48 b8 15 25 80 00 00 	movabs $0x802515,%rax
  80353b:	00 00 00 
  80353e:	ff d0                	callq  *%rax
  803540:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803543:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803547:	78 26                	js     80356f <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803549:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80354d:	ba 07 04 00 00       	mov    $0x407,%edx
  803552:	48 89 c6             	mov    %rax,%rsi
  803555:	bf 00 00 00 00       	mov    $0x0,%edi
  80355a:	48 b8 f6 1a 80 00 00 	movabs $0x801af6,%rax
  803561:	00 00 00 
  803564:	ff d0                	callq  *%rax
  803566:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803569:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80356d:	79 16                	jns    803585 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  80356f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803572:	89 c7                	mov    %eax,%edi
  803574:	48 b8 2f 3a 80 00 00 	movabs $0x803a2f,%rax
  80357b:	00 00 00 
  80357e:	ff d0                	callq  *%rax
		return r;
  803580:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803583:	eb 3a                	jmp    8035bf <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803585:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803589:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  803590:	00 00 00 
  803593:	8b 12                	mov    (%rdx),%edx
  803595:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803597:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80359b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8035a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035a6:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8035a9:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8035ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035b0:	48 89 c7             	mov    %rax,%rdi
  8035b3:	48 b8 c7 24 80 00 00 	movabs $0x8024c7,%rax
  8035ba:	00 00 00 
  8035bd:	ff d0                	callq  *%rax
}
  8035bf:	c9                   	leaveq 
  8035c0:	c3                   	retq   

00000000008035c1 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8035c1:	55                   	push   %rbp
  8035c2:	48 89 e5             	mov    %rsp,%rbp
  8035c5:	48 83 ec 30          	sub    $0x30,%rsp
  8035c9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8035cc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8035d0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8035d4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035d7:	89 c7                	mov    %eax,%edi
  8035d9:	48 b8 cb 34 80 00 00 	movabs $0x8034cb,%rax
  8035e0:	00 00 00 
  8035e3:	ff d0                	callq  *%rax
  8035e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035ec:	79 05                	jns    8035f3 <accept+0x32>
		return r;
  8035ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035f1:	eb 3b                	jmp    80362e <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8035f3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8035f7:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8035fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035fe:	48 89 ce             	mov    %rcx,%rsi
  803601:	89 c7                	mov    %eax,%edi
  803603:	48 b8 0c 39 80 00 00 	movabs $0x80390c,%rax
  80360a:	00 00 00 
  80360d:	ff d0                	callq  *%rax
  80360f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803612:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803616:	79 05                	jns    80361d <accept+0x5c>
		return r;
  803618:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80361b:	eb 11                	jmp    80362e <accept+0x6d>
	return alloc_sockfd(r);
  80361d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803620:	89 c7                	mov    %eax,%edi
  803622:	48 b8 22 35 80 00 00 	movabs $0x803522,%rax
  803629:	00 00 00 
  80362c:	ff d0                	callq  *%rax
}
  80362e:	c9                   	leaveq 
  80362f:	c3                   	retq   

0000000000803630 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803630:	55                   	push   %rbp
  803631:	48 89 e5             	mov    %rsp,%rbp
  803634:	48 83 ec 20          	sub    $0x20,%rsp
  803638:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80363b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80363f:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803642:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803645:	89 c7                	mov    %eax,%edi
  803647:	48 b8 cb 34 80 00 00 	movabs $0x8034cb,%rax
  80364e:	00 00 00 
  803651:	ff d0                	callq  *%rax
  803653:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803656:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80365a:	79 05                	jns    803661 <bind+0x31>
		return r;
  80365c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80365f:	eb 1b                	jmp    80367c <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803661:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803664:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803668:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80366b:	48 89 ce             	mov    %rcx,%rsi
  80366e:	89 c7                	mov    %eax,%edi
  803670:	48 b8 8b 39 80 00 00 	movabs $0x80398b,%rax
  803677:	00 00 00 
  80367a:	ff d0                	callq  *%rax
}
  80367c:	c9                   	leaveq 
  80367d:	c3                   	retq   

000000000080367e <shutdown>:

int
shutdown(int s, int how)
{
  80367e:	55                   	push   %rbp
  80367f:	48 89 e5             	mov    %rsp,%rbp
  803682:	48 83 ec 20          	sub    $0x20,%rsp
  803686:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803689:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80368c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80368f:	89 c7                	mov    %eax,%edi
  803691:	48 b8 cb 34 80 00 00 	movabs $0x8034cb,%rax
  803698:	00 00 00 
  80369b:	ff d0                	callq  *%rax
  80369d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036a4:	79 05                	jns    8036ab <shutdown+0x2d>
		return r;
  8036a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036a9:	eb 16                	jmp    8036c1 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8036ab:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8036ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036b1:	89 d6                	mov    %edx,%esi
  8036b3:	89 c7                	mov    %eax,%edi
  8036b5:	48 b8 ef 39 80 00 00 	movabs $0x8039ef,%rax
  8036bc:	00 00 00 
  8036bf:	ff d0                	callq  *%rax
}
  8036c1:	c9                   	leaveq 
  8036c2:	c3                   	retq   

00000000008036c3 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8036c3:	55                   	push   %rbp
  8036c4:	48 89 e5             	mov    %rsp,%rbp
  8036c7:	48 83 ec 10          	sub    $0x10,%rsp
  8036cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8036cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036d3:	48 89 c7             	mov    %rax,%rdi
  8036d6:	48 b8 7d 48 80 00 00 	movabs $0x80487d,%rax
  8036dd:	00 00 00 
  8036e0:	ff d0                	callq  *%rax
  8036e2:	83 f8 01             	cmp    $0x1,%eax
  8036e5:	75 17                	jne    8036fe <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8036e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036eb:	8b 40 0c             	mov    0xc(%rax),%eax
  8036ee:	89 c7                	mov    %eax,%edi
  8036f0:	48 b8 2f 3a 80 00 00 	movabs $0x803a2f,%rax
  8036f7:	00 00 00 
  8036fa:	ff d0                	callq  *%rax
  8036fc:	eb 05                	jmp    803703 <devsock_close+0x40>
	else
		return 0;
  8036fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803703:	c9                   	leaveq 
  803704:	c3                   	retq   

0000000000803705 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803705:	55                   	push   %rbp
  803706:	48 89 e5             	mov    %rsp,%rbp
  803709:	48 83 ec 20          	sub    $0x20,%rsp
  80370d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803710:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803714:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803717:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80371a:	89 c7                	mov    %eax,%edi
  80371c:	48 b8 cb 34 80 00 00 	movabs $0x8034cb,%rax
  803723:	00 00 00 
  803726:	ff d0                	callq  *%rax
  803728:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80372b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80372f:	79 05                	jns    803736 <connect+0x31>
		return r;
  803731:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803734:	eb 1b                	jmp    803751 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803736:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803739:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80373d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803740:	48 89 ce             	mov    %rcx,%rsi
  803743:	89 c7                	mov    %eax,%edi
  803745:	48 b8 5c 3a 80 00 00 	movabs $0x803a5c,%rax
  80374c:	00 00 00 
  80374f:	ff d0                	callq  *%rax
}
  803751:	c9                   	leaveq 
  803752:	c3                   	retq   

0000000000803753 <listen>:

int
listen(int s, int backlog)
{
  803753:	55                   	push   %rbp
  803754:	48 89 e5             	mov    %rsp,%rbp
  803757:	48 83 ec 20          	sub    $0x20,%rsp
  80375b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80375e:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803761:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803764:	89 c7                	mov    %eax,%edi
  803766:	48 b8 cb 34 80 00 00 	movabs $0x8034cb,%rax
  80376d:	00 00 00 
  803770:	ff d0                	callq  *%rax
  803772:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803775:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803779:	79 05                	jns    803780 <listen+0x2d>
		return r;
  80377b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80377e:	eb 16                	jmp    803796 <listen+0x43>
	return nsipc_listen(r, backlog);
  803780:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803783:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803786:	89 d6                	mov    %edx,%esi
  803788:	89 c7                	mov    %eax,%edi
  80378a:	48 b8 c0 3a 80 00 00 	movabs $0x803ac0,%rax
  803791:	00 00 00 
  803794:	ff d0                	callq  *%rax
}
  803796:	c9                   	leaveq 
  803797:	c3                   	retq   

0000000000803798 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803798:	55                   	push   %rbp
  803799:	48 89 e5             	mov    %rsp,%rbp
  80379c:	48 83 ec 20          	sub    $0x20,%rsp
  8037a0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8037a4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8037a8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8037ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037b0:	89 c2                	mov    %eax,%edx
  8037b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037b6:	8b 40 0c             	mov    0xc(%rax),%eax
  8037b9:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8037bd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8037c2:	89 c7                	mov    %eax,%edi
  8037c4:	48 b8 00 3b 80 00 00 	movabs $0x803b00,%rax
  8037cb:	00 00 00 
  8037ce:	ff d0                	callq  *%rax
}
  8037d0:	c9                   	leaveq 
  8037d1:	c3                   	retq   

00000000008037d2 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8037d2:	55                   	push   %rbp
  8037d3:	48 89 e5             	mov    %rsp,%rbp
  8037d6:	48 83 ec 20          	sub    $0x20,%rsp
  8037da:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8037de:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8037e2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8037e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037ea:	89 c2                	mov    %eax,%edx
  8037ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037f0:	8b 40 0c             	mov    0xc(%rax),%eax
  8037f3:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8037f7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8037fc:	89 c7                	mov    %eax,%edi
  8037fe:	48 b8 cc 3b 80 00 00 	movabs $0x803bcc,%rax
  803805:	00 00 00 
  803808:	ff d0                	callq  *%rax
}
  80380a:	c9                   	leaveq 
  80380b:	c3                   	retq   

000000000080380c <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80380c:	55                   	push   %rbp
  80380d:	48 89 e5             	mov    %rsp,%rbp
  803810:	48 83 ec 10          	sub    $0x10,%rsp
  803814:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803818:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  80381c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803820:	48 be 38 51 80 00 00 	movabs $0x805138,%rsi
  803827:	00 00 00 
  80382a:	48 89 c7             	mov    %rax,%rdi
  80382d:	48 b8 c7 11 80 00 00 	movabs $0x8011c7,%rax
  803834:	00 00 00 
  803837:	ff d0                	callq  *%rax
	return 0;
  803839:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80383e:	c9                   	leaveq 
  80383f:	c3                   	retq   

0000000000803840 <socket>:

int
socket(int domain, int type, int protocol)
{
  803840:	55                   	push   %rbp
  803841:	48 89 e5             	mov    %rsp,%rbp
  803844:	48 83 ec 20          	sub    $0x20,%rsp
  803848:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80384b:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80384e:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803851:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803854:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803857:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80385a:	89 ce                	mov    %ecx,%esi
  80385c:	89 c7                	mov    %eax,%edi
  80385e:	48 b8 84 3c 80 00 00 	movabs $0x803c84,%rax
  803865:	00 00 00 
  803868:	ff d0                	callq  *%rax
  80386a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80386d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803871:	79 05                	jns    803878 <socket+0x38>
		return r;
  803873:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803876:	eb 11                	jmp    803889 <socket+0x49>
	return alloc_sockfd(r);
  803878:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80387b:	89 c7                	mov    %eax,%edi
  80387d:	48 b8 22 35 80 00 00 	movabs $0x803522,%rax
  803884:	00 00 00 
  803887:	ff d0                	callq  *%rax
}
  803889:	c9                   	leaveq 
  80388a:	c3                   	retq   

000000000080388b <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80388b:	55                   	push   %rbp
  80388c:	48 89 e5             	mov    %rsp,%rbp
  80388f:	48 83 ec 10          	sub    $0x10,%rsp
  803893:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803896:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  80389d:	00 00 00 
  8038a0:	8b 00                	mov    (%rax),%eax
  8038a2:	85 c0                	test   %eax,%eax
  8038a4:	75 1d                	jne    8038c3 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8038a6:	bf 02 00 00 00       	mov    $0x2,%edi
  8038ab:	48 b8 fb 47 80 00 00 	movabs $0x8047fb,%rax
  8038b2:	00 00 00 
  8038b5:	ff d0                	callq  *%rax
  8038b7:	48 ba 04 80 80 00 00 	movabs $0x808004,%rdx
  8038be:	00 00 00 
  8038c1:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8038c3:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  8038ca:	00 00 00 
  8038cd:	8b 00                	mov    (%rax),%eax
  8038cf:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8038d2:	b9 07 00 00 00       	mov    $0x7,%ecx
  8038d7:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  8038de:	00 00 00 
  8038e1:	89 c7                	mov    %eax,%edi
  8038e3:	48 b8 99 47 80 00 00 	movabs $0x804799,%rax
  8038ea:	00 00 00 
  8038ed:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8038ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8038f4:	be 00 00 00 00       	mov    $0x0,%esi
  8038f9:	bf 00 00 00 00       	mov    $0x0,%edi
  8038fe:	48 b8 93 46 80 00 00 	movabs $0x804693,%rax
  803905:	00 00 00 
  803908:	ff d0                	callq  *%rax
}
  80390a:	c9                   	leaveq 
  80390b:	c3                   	retq   

000000000080390c <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80390c:	55                   	push   %rbp
  80390d:	48 89 e5             	mov    %rsp,%rbp
  803910:	48 83 ec 30          	sub    $0x30,%rsp
  803914:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803917:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80391b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  80391f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803926:	00 00 00 
  803929:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80392c:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80392e:	bf 01 00 00 00       	mov    $0x1,%edi
  803933:	48 b8 8b 38 80 00 00 	movabs $0x80388b,%rax
  80393a:	00 00 00 
  80393d:	ff d0                	callq  *%rax
  80393f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803942:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803946:	78 3e                	js     803986 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803948:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80394f:	00 00 00 
  803952:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803956:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80395a:	8b 40 10             	mov    0x10(%rax),%eax
  80395d:	89 c2                	mov    %eax,%edx
  80395f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803963:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803967:	48 89 ce             	mov    %rcx,%rsi
  80396a:	48 89 c7             	mov    %rax,%rdi
  80396d:	48 b8 eb 14 80 00 00 	movabs $0x8014eb,%rax
  803974:	00 00 00 
  803977:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803979:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80397d:	8b 50 10             	mov    0x10(%rax),%edx
  803980:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803984:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803986:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803989:	c9                   	leaveq 
  80398a:	c3                   	retq   

000000000080398b <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80398b:	55                   	push   %rbp
  80398c:	48 89 e5             	mov    %rsp,%rbp
  80398f:	48 83 ec 10          	sub    $0x10,%rsp
  803993:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803996:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80399a:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  80399d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8039a4:	00 00 00 
  8039a7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8039aa:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8039ac:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039b3:	48 89 c6             	mov    %rax,%rsi
  8039b6:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  8039bd:	00 00 00 
  8039c0:	48 b8 eb 14 80 00 00 	movabs $0x8014eb,%rax
  8039c7:	00 00 00 
  8039ca:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8039cc:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8039d3:	00 00 00 
  8039d6:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039d9:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8039dc:	bf 02 00 00 00       	mov    $0x2,%edi
  8039e1:	48 b8 8b 38 80 00 00 	movabs $0x80388b,%rax
  8039e8:	00 00 00 
  8039eb:	ff d0                	callq  *%rax
}
  8039ed:	c9                   	leaveq 
  8039ee:	c3                   	retq   

00000000008039ef <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8039ef:	55                   	push   %rbp
  8039f0:	48 89 e5             	mov    %rsp,%rbp
  8039f3:	48 83 ec 10          	sub    $0x10,%rsp
  8039f7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8039fa:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8039fd:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a04:	00 00 00 
  803a07:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a0a:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803a0c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a13:	00 00 00 
  803a16:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a19:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803a1c:	bf 03 00 00 00       	mov    $0x3,%edi
  803a21:	48 b8 8b 38 80 00 00 	movabs $0x80388b,%rax
  803a28:	00 00 00 
  803a2b:	ff d0                	callq  *%rax
}
  803a2d:	c9                   	leaveq 
  803a2e:	c3                   	retq   

0000000000803a2f <nsipc_close>:

int
nsipc_close(int s)
{
  803a2f:	55                   	push   %rbp
  803a30:	48 89 e5             	mov    %rsp,%rbp
  803a33:	48 83 ec 10          	sub    $0x10,%rsp
  803a37:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803a3a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a41:	00 00 00 
  803a44:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a47:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803a49:	bf 04 00 00 00       	mov    $0x4,%edi
  803a4e:	48 b8 8b 38 80 00 00 	movabs $0x80388b,%rax
  803a55:	00 00 00 
  803a58:	ff d0                	callq  *%rax
}
  803a5a:	c9                   	leaveq 
  803a5b:	c3                   	retq   

0000000000803a5c <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803a5c:	55                   	push   %rbp
  803a5d:	48 89 e5             	mov    %rsp,%rbp
  803a60:	48 83 ec 10          	sub    $0x10,%rsp
  803a64:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a67:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803a6b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803a6e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a75:	00 00 00 
  803a78:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a7b:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803a7d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a84:	48 89 c6             	mov    %rax,%rsi
  803a87:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803a8e:	00 00 00 
  803a91:	48 b8 eb 14 80 00 00 	movabs $0x8014eb,%rax
  803a98:	00 00 00 
  803a9b:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803a9d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803aa4:	00 00 00 
  803aa7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803aaa:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803aad:	bf 05 00 00 00       	mov    $0x5,%edi
  803ab2:	48 b8 8b 38 80 00 00 	movabs $0x80388b,%rax
  803ab9:	00 00 00 
  803abc:	ff d0                	callq  *%rax
}
  803abe:	c9                   	leaveq 
  803abf:	c3                   	retq   

0000000000803ac0 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803ac0:	55                   	push   %rbp
  803ac1:	48 89 e5             	mov    %rsp,%rbp
  803ac4:	48 83 ec 10          	sub    $0x10,%rsp
  803ac8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803acb:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803ace:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ad5:	00 00 00 
  803ad8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803adb:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803add:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ae4:	00 00 00 
  803ae7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803aea:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803aed:	bf 06 00 00 00       	mov    $0x6,%edi
  803af2:	48 b8 8b 38 80 00 00 	movabs $0x80388b,%rax
  803af9:	00 00 00 
  803afc:	ff d0                	callq  *%rax
}
  803afe:	c9                   	leaveq 
  803aff:	c3                   	retq   

0000000000803b00 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803b00:	55                   	push   %rbp
  803b01:	48 89 e5             	mov    %rsp,%rbp
  803b04:	48 83 ec 30          	sub    $0x30,%rsp
  803b08:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b0b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803b0f:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803b12:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803b15:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b1c:	00 00 00 
  803b1f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803b22:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803b24:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b2b:	00 00 00 
  803b2e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803b31:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803b34:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b3b:	00 00 00 
  803b3e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803b41:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803b44:	bf 07 00 00 00       	mov    $0x7,%edi
  803b49:	48 b8 8b 38 80 00 00 	movabs $0x80388b,%rax
  803b50:	00 00 00 
  803b53:	ff d0                	callq  *%rax
  803b55:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b58:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b5c:	78 69                	js     803bc7 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803b5e:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803b65:	7f 08                	jg     803b6f <nsipc_recv+0x6f>
  803b67:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b6a:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803b6d:	7e 35                	jle    803ba4 <nsipc_recv+0xa4>
  803b6f:	48 b9 3f 51 80 00 00 	movabs $0x80513f,%rcx
  803b76:	00 00 00 
  803b79:	48 ba 54 51 80 00 00 	movabs $0x805154,%rdx
  803b80:	00 00 00 
  803b83:	be 61 00 00 00       	mov    $0x61,%esi
  803b88:	48 bf 69 51 80 00 00 	movabs $0x805169,%rdi
  803b8f:	00 00 00 
  803b92:	b8 00 00 00 00       	mov    $0x0,%eax
  803b97:	49 b8 d9 03 80 00 00 	movabs $0x8003d9,%r8
  803b9e:	00 00 00 
  803ba1:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803ba4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ba7:	48 63 d0             	movslq %eax,%rdx
  803baa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bae:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803bb5:	00 00 00 
  803bb8:	48 89 c7             	mov    %rax,%rdi
  803bbb:	48 b8 eb 14 80 00 00 	movabs $0x8014eb,%rax
  803bc2:	00 00 00 
  803bc5:	ff d0                	callq  *%rax
	}

	return r;
  803bc7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803bca:	c9                   	leaveq 
  803bcb:	c3                   	retq   

0000000000803bcc <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803bcc:	55                   	push   %rbp
  803bcd:	48 89 e5             	mov    %rsp,%rbp
  803bd0:	48 83 ec 20          	sub    $0x20,%rsp
  803bd4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803bd7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803bdb:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803bde:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803be1:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803be8:	00 00 00 
  803beb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803bee:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803bf0:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803bf7:	7e 35                	jle    803c2e <nsipc_send+0x62>
  803bf9:	48 b9 75 51 80 00 00 	movabs $0x805175,%rcx
  803c00:	00 00 00 
  803c03:	48 ba 54 51 80 00 00 	movabs $0x805154,%rdx
  803c0a:	00 00 00 
  803c0d:	be 6c 00 00 00       	mov    $0x6c,%esi
  803c12:	48 bf 69 51 80 00 00 	movabs $0x805169,%rdi
  803c19:	00 00 00 
  803c1c:	b8 00 00 00 00       	mov    $0x0,%eax
  803c21:	49 b8 d9 03 80 00 00 	movabs $0x8003d9,%r8
  803c28:	00 00 00 
  803c2b:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803c2e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c31:	48 63 d0             	movslq %eax,%rdx
  803c34:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c38:	48 89 c6             	mov    %rax,%rsi
  803c3b:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803c42:	00 00 00 
  803c45:	48 b8 eb 14 80 00 00 	movabs $0x8014eb,%rax
  803c4c:	00 00 00 
  803c4f:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803c51:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c58:	00 00 00 
  803c5b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c5e:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803c61:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c68:	00 00 00 
  803c6b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803c6e:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803c71:	bf 08 00 00 00       	mov    $0x8,%edi
  803c76:	48 b8 8b 38 80 00 00 	movabs $0x80388b,%rax
  803c7d:	00 00 00 
  803c80:	ff d0                	callq  *%rax
}
  803c82:	c9                   	leaveq 
  803c83:	c3                   	retq   

0000000000803c84 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803c84:	55                   	push   %rbp
  803c85:	48 89 e5             	mov    %rsp,%rbp
  803c88:	48 83 ec 10          	sub    $0x10,%rsp
  803c8c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c8f:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803c92:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803c95:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c9c:	00 00 00 
  803c9f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803ca2:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803ca4:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cab:	00 00 00 
  803cae:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803cb1:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803cb4:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cbb:	00 00 00 
  803cbe:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803cc1:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803cc4:	bf 09 00 00 00       	mov    $0x9,%edi
  803cc9:	48 b8 8b 38 80 00 00 	movabs $0x80388b,%rax
  803cd0:	00 00 00 
  803cd3:	ff d0                	callq  *%rax
}
  803cd5:	c9                   	leaveq 
  803cd6:	c3                   	retq   

0000000000803cd7 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803cd7:	55                   	push   %rbp
  803cd8:	48 89 e5             	mov    %rsp,%rbp
  803cdb:	53                   	push   %rbx
  803cdc:	48 83 ec 38          	sub    $0x38,%rsp
  803ce0:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803ce4:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803ce8:	48 89 c7             	mov    %rax,%rdi
  803ceb:	48 b8 15 25 80 00 00 	movabs $0x802515,%rax
  803cf2:	00 00 00 
  803cf5:	ff d0                	callq  *%rax
  803cf7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803cfa:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803cfe:	0f 88 bf 01 00 00    	js     803ec3 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d04:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d08:	ba 07 04 00 00       	mov    $0x407,%edx
  803d0d:	48 89 c6             	mov    %rax,%rsi
  803d10:	bf 00 00 00 00       	mov    $0x0,%edi
  803d15:	48 b8 f6 1a 80 00 00 	movabs $0x801af6,%rax
  803d1c:	00 00 00 
  803d1f:	ff d0                	callq  *%rax
  803d21:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d24:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d28:	0f 88 95 01 00 00    	js     803ec3 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803d2e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803d32:	48 89 c7             	mov    %rax,%rdi
  803d35:	48 b8 15 25 80 00 00 	movabs $0x802515,%rax
  803d3c:	00 00 00 
  803d3f:	ff d0                	callq  *%rax
  803d41:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d44:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d48:	0f 88 5d 01 00 00    	js     803eab <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d4e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d52:	ba 07 04 00 00       	mov    $0x407,%edx
  803d57:	48 89 c6             	mov    %rax,%rsi
  803d5a:	bf 00 00 00 00       	mov    $0x0,%edi
  803d5f:	48 b8 f6 1a 80 00 00 	movabs $0x801af6,%rax
  803d66:	00 00 00 
  803d69:	ff d0                	callq  *%rax
  803d6b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d6e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d72:	0f 88 33 01 00 00    	js     803eab <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803d78:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d7c:	48 89 c7             	mov    %rax,%rdi
  803d7f:	48 b8 ea 24 80 00 00 	movabs $0x8024ea,%rax
  803d86:	00 00 00 
  803d89:	ff d0                	callq  *%rax
  803d8b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d8f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d93:	ba 07 04 00 00       	mov    $0x407,%edx
  803d98:	48 89 c6             	mov    %rax,%rsi
  803d9b:	bf 00 00 00 00       	mov    $0x0,%edi
  803da0:	48 b8 f6 1a 80 00 00 	movabs $0x801af6,%rax
  803da7:	00 00 00 
  803daa:	ff d0                	callq  *%rax
  803dac:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803daf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803db3:	79 05                	jns    803dba <pipe+0xe3>
		goto err2;
  803db5:	e9 d9 00 00 00       	jmpq   803e93 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803dba:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803dbe:	48 89 c7             	mov    %rax,%rdi
  803dc1:	48 b8 ea 24 80 00 00 	movabs $0x8024ea,%rax
  803dc8:	00 00 00 
  803dcb:	ff d0                	callq  *%rax
  803dcd:	48 89 c2             	mov    %rax,%rdx
  803dd0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803dd4:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803dda:	48 89 d1             	mov    %rdx,%rcx
  803ddd:	ba 00 00 00 00       	mov    $0x0,%edx
  803de2:	48 89 c6             	mov    %rax,%rsi
  803de5:	bf 00 00 00 00       	mov    $0x0,%edi
  803dea:	48 b8 46 1b 80 00 00 	movabs $0x801b46,%rax
  803df1:	00 00 00 
  803df4:	ff d0                	callq  *%rax
  803df6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803df9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803dfd:	79 1b                	jns    803e1a <pipe+0x143>
		goto err3;
  803dff:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803e00:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e04:	48 89 c6             	mov    %rax,%rsi
  803e07:	bf 00 00 00 00       	mov    $0x0,%edi
  803e0c:	48 b8 a1 1b 80 00 00 	movabs $0x801ba1,%rax
  803e13:	00 00 00 
  803e16:	ff d0                	callq  *%rax
  803e18:	eb 79                	jmp    803e93 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803e1a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e1e:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803e25:	00 00 00 
  803e28:	8b 12                	mov    (%rdx),%edx
  803e2a:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803e2c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e30:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803e37:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e3b:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803e42:	00 00 00 
  803e45:	8b 12                	mov    (%rdx),%edx
  803e47:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803e49:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e4d:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803e54:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e58:	48 89 c7             	mov    %rax,%rdi
  803e5b:	48 b8 c7 24 80 00 00 	movabs $0x8024c7,%rax
  803e62:	00 00 00 
  803e65:	ff d0                	callq  *%rax
  803e67:	89 c2                	mov    %eax,%edx
  803e69:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803e6d:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803e6f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803e73:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803e77:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e7b:	48 89 c7             	mov    %rax,%rdi
  803e7e:	48 b8 c7 24 80 00 00 	movabs $0x8024c7,%rax
  803e85:	00 00 00 
  803e88:	ff d0                	callq  *%rax
  803e8a:	89 03                	mov    %eax,(%rbx)
	return 0;
  803e8c:	b8 00 00 00 00       	mov    $0x0,%eax
  803e91:	eb 33                	jmp    803ec6 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803e93:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e97:	48 89 c6             	mov    %rax,%rsi
  803e9a:	bf 00 00 00 00       	mov    $0x0,%edi
  803e9f:	48 b8 a1 1b 80 00 00 	movabs $0x801ba1,%rax
  803ea6:	00 00 00 
  803ea9:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803eab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803eaf:	48 89 c6             	mov    %rax,%rsi
  803eb2:	bf 00 00 00 00       	mov    $0x0,%edi
  803eb7:	48 b8 a1 1b 80 00 00 	movabs $0x801ba1,%rax
  803ebe:	00 00 00 
  803ec1:	ff d0                	callq  *%rax
err:
	return r;
  803ec3:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803ec6:	48 83 c4 38          	add    $0x38,%rsp
  803eca:	5b                   	pop    %rbx
  803ecb:	5d                   	pop    %rbp
  803ecc:	c3                   	retq   

0000000000803ecd <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803ecd:	55                   	push   %rbp
  803ece:	48 89 e5             	mov    %rsp,%rbp
  803ed1:	53                   	push   %rbx
  803ed2:	48 83 ec 28          	sub    $0x28,%rsp
  803ed6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803eda:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803ede:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803ee5:	00 00 00 
  803ee8:	48 8b 00             	mov    (%rax),%rax
  803eeb:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803ef1:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803ef4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ef8:	48 89 c7             	mov    %rax,%rdi
  803efb:	48 b8 7d 48 80 00 00 	movabs $0x80487d,%rax
  803f02:	00 00 00 
  803f05:	ff d0                	callq  *%rax
  803f07:	89 c3                	mov    %eax,%ebx
  803f09:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f0d:	48 89 c7             	mov    %rax,%rdi
  803f10:	48 b8 7d 48 80 00 00 	movabs $0x80487d,%rax
  803f17:	00 00 00 
  803f1a:	ff d0                	callq  *%rax
  803f1c:	39 c3                	cmp    %eax,%ebx
  803f1e:	0f 94 c0             	sete   %al
  803f21:	0f b6 c0             	movzbl %al,%eax
  803f24:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803f27:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803f2e:	00 00 00 
  803f31:	48 8b 00             	mov    (%rax),%rax
  803f34:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803f3a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803f3d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f40:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803f43:	75 05                	jne    803f4a <_pipeisclosed+0x7d>
			return ret;
  803f45:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803f48:	eb 4f                	jmp    803f99 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803f4a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f4d:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803f50:	74 42                	je     803f94 <_pipeisclosed+0xc7>
  803f52:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803f56:	75 3c                	jne    803f94 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803f58:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803f5f:	00 00 00 
  803f62:	48 8b 00             	mov    (%rax),%rax
  803f65:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803f6b:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803f6e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f71:	89 c6                	mov    %eax,%esi
  803f73:	48 bf 86 51 80 00 00 	movabs $0x805186,%rdi
  803f7a:	00 00 00 
  803f7d:	b8 00 00 00 00       	mov    $0x0,%eax
  803f82:	49 b8 12 06 80 00 00 	movabs $0x800612,%r8
  803f89:	00 00 00 
  803f8c:	41 ff d0             	callq  *%r8
	}
  803f8f:	e9 4a ff ff ff       	jmpq   803ede <_pipeisclosed+0x11>
  803f94:	e9 45 ff ff ff       	jmpq   803ede <_pipeisclosed+0x11>
}
  803f99:	48 83 c4 28          	add    $0x28,%rsp
  803f9d:	5b                   	pop    %rbx
  803f9e:	5d                   	pop    %rbp
  803f9f:	c3                   	retq   

0000000000803fa0 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803fa0:	55                   	push   %rbp
  803fa1:	48 89 e5             	mov    %rsp,%rbp
  803fa4:	48 83 ec 30          	sub    $0x30,%rsp
  803fa8:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803fab:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803faf:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803fb2:	48 89 d6             	mov    %rdx,%rsi
  803fb5:	89 c7                	mov    %eax,%edi
  803fb7:	48 b8 ad 25 80 00 00 	movabs $0x8025ad,%rax
  803fbe:	00 00 00 
  803fc1:	ff d0                	callq  *%rax
  803fc3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fc6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fca:	79 05                	jns    803fd1 <pipeisclosed+0x31>
		return r;
  803fcc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fcf:	eb 31                	jmp    804002 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803fd1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fd5:	48 89 c7             	mov    %rax,%rdi
  803fd8:	48 b8 ea 24 80 00 00 	movabs $0x8024ea,%rax
  803fdf:	00 00 00 
  803fe2:	ff d0                	callq  *%rax
  803fe4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803fe8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fec:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ff0:	48 89 d6             	mov    %rdx,%rsi
  803ff3:	48 89 c7             	mov    %rax,%rdi
  803ff6:	48 b8 cd 3e 80 00 00 	movabs $0x803ecd,%rax
  803ffd:	00 00 00 
  804000:	ff d0                	callq  *%rax
}
  804002:	c9                   	leaveq 
  804003:	c3                   	retq   

0000000000804004 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804004:	55                   	push   %rbp
  804005:	48 89 e5             	mov    %rsp,%rbp
  804008:	48 83 ec 40          	sub    $0x40,%rsp
  80400c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804010:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804014:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804018:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80401c:	48 89 c7             	mov    %rax,%rdi
  80401f:	48 b8 ea 24 80 00 00 	movabs $0x8024ea,%rax
  804026:	00 00 00 
  804029:	ff d0                	callq  *%rax
  80402b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80402f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804033:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804037:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80403e:	00 
  80403f:	e9 92 00 00 00       	jmpq   8040d6 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  804044:	eb 41                	jmp    804087 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804046:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80404b:	74 09                	je     804056 <devpipe_read+0x52>
				return i;
  80404d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804051:	e9 92 00 00 00       	jmpq   8040e8 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804056:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80405a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80405e:	48 89 d6             	mov    %rdx,%rsi
  804061:	48 89 c7             	mov    %rax,%rdi
  804064:	48 b8 cd 3e 80 00 00 	movabs $0x803ecd,%rax
  80406b:	00 00 00 
  80406e:	ff d0                	callq  *%rax
  804070:	85 c0                	test   %eax,%eax
  804072:	74 07                	je     80407b <devpipe_read+0x77>
				return 0;
  804074:	b8 00 00 00 00       	mov    $0x0,%eax
  804079:	eb 6d                	jmp    8040e8 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80407b:	48 b8 b8 1a 80 00 00 	movabs $0x801ab8,%rax
  804082:	00 00 00 
  804085:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  804087:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80408b:	8b 10                	mov    (%rax),%edx
  80408d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804091:	8b 40 04             	mov    0x4(%rax),%eax
  804094:	39 c2                	cmp    %eax,%edx
  804096:	74 ae                	je     804046 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804098:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80409c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8040a0:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8040a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040a8:	8b 00                	mov    (%rax),%eax
  8040aa:	99                   	cltd   
  8040ab:	c1 ea 1b             	shr    $0x1b,%edx
  8040ae:	01 d0                	add    %edx,%eax
  8040b0:	83 e0 1f             	and    $0x1f,%eax
  8040b3:	29 d0                	sub    %edx,%eax
  8040b5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8040b9:	48 98                	cltq   
  8040bb:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8040c0:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8040c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040c6:	8b 00                	mov    (%rax),%eax
  8040c8:	8d 50 01             	lea    0x1(%rax),%edx
  8040cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040cf:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8040d1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8040d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040da:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8040de:	0f 82 60 ff ff ff    	jb     804044 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8040e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8040e8:	c9                   	leaveq 
  8040e9:	c3                   	retq   

00000000008040ea <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8040ea:	55                   	push   %rbp
  8040eb:	48 89 e5             	mov    %rsp,%rbp
  8040ee:	48 83 ec 40          	sub    $0x40,%rsp
  8040f2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8040f6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8040fa:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8040fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804102:	48 89 c7             	mov    %rax,%rdi
  804105:	48 b8 ea 24 80 00 00 	movabs $0x8024ea,%rax
  80410c:	00 00 00 
  80410f:	ff d0                	callq  *%rax
  804111:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804115:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804119:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80411d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804124:	00 
  804125:	e9 8e 00 00 00       	jmpq   8041b8 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80412a:	eb 31                	jmp    80415d <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80412c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804130:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804134:	48 89 d6             	mov    %rdx,%rsi
  804137:	48 89 c7             	mov    %rax,%rdi
  80413a:	48 b8 cd 3e 80 00 00 	movabs $0x803ecd,%rax
  804141:	00 00 00 
  804144:	ff d0                	callq  *%rax
  804146:	85 c0                	test   %eax,%eax
  804148:	74 07                	je     804151 <devpipe_write+0x67>
				return 0;
  80414a:	b8 00 00 00 00       	mov    $0x0,%eax
  80414f:	eb 79                	jmp    8041ca <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804151:	48 b8 b8 1a 80 00 00 	movabs $0x801ab8,%rax
  804158:	00 00 00 
  80415b:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80415d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804161:	8b 40 04             	mov    0x4(%rax),%eax
  804164:	48 63 d0             	movslq %eax,%rdx
  804167:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80416b:	8b 00                	mov    (%rax),%eax
  80416d:	48 98                	cltq   
  80416f:	48 83 c0 20          	add    $0x20,%rax
  804173:	48 39 c2             	cmp    %rax,%rdx
  804176:	73 b4                	jae    80412c <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804178:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80417c:	8b 40 04             	mov    0x4(%rax),%eax
  80417f:	99                   	cltd   
  804180:	c1 ea 1b             	shr    $0x1b,%edx
  804183:	01 d0                	add    %edx,%eax
  804185:	83 e0 1f             	and    $0x1f,%eax
  804188:	29 d0                	sub    %edx,%eax
  80418a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80418e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804192:	48 01 ca             	add    %rcx,%rdx
  804195:	0f b6 0a             	movzbl (%rdx),%ecx
  804198:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80419c:	48 98                	cltq   
  80419e:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8041a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041a6:	8b 40 04             	mov    0x4(%rax),%eax
  8041a9:	8d 50 01             	lea    0x1(%rax),%edx
  8041ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041b0:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8041b3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8041b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041bc:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8041c0:	0f 82 64 ff ff ff    	jb     80412a <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8041c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8041ca:	c9                   	leaveq 
  8041cb:	c3                   	retq   

00000000008041cc <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8041cc:	55                   	push   %rbp
  8041cd:	48 89 e5             	mov    %rsp,%rbp
  8041d0:	48 83 ec 20          	sub    $0x20,%rsp
  8041d4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8041d8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8041dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041e0:	48 89 c7             	mov    %rax,%rdi
  8041e3:	48 b8 ea 24 80 00 00 	movabs $0x8024ea,%rax
  8041ea:	00 00 00 
  8041ed:	ff d0                	callq  *%rax
  8041ef:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8041f3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041f7:	48 be 99 51 80 00 00 	movabs $0x805199,%rsi
  8041fe:	00 00 00 
  804201:	48 89 c7             	mov    %rax,%rdi
  804204:	48 b8 c7 11 80 00 00 	movabs $0x8011c7,%rax
  80420b:	00 00 00 
  80420e:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804210:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804214:	8b 50 04             	mov    0x4(%rax),%edx
  804217:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80421b:	8b 00                	mov    (%rax),%eax
  80421d:	29 c2                	sub    %eax,%edx
  80421f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804223:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804229:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80422d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804234:	00 00 00 
	stat->st_dev = &devpipe;
  804237:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80423b:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  804242:	00 00 00 
  804245:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80424c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804251:	c9                   	leaveq 
  804252:	c3                   	retq   

0000000000804253 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804253:	55                   	push   %rbp
  804254:	48 89 e5             	mov    %rsp,%rbp
  804257:	48 83 ec 10          	sub    $0x10,%rsp
  80425b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80425f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804263:	48 89 c6             	mov    %rax,%rsi
  804266:	bf 00 00 00 00       	mov    $0x0,%edi
  80426b:	48 b8 a1 1b 80 00 00 	movabs $0x801ba1,%rax
  804272:	00 00 00 
  804275:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  804277:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80427b:	48 89 c7             	mov    %rax,%rdi
  80427e:	48 b8 ea 24 80 00 00 	movabs $0x8024ea,%rax
  804285:	00 00 00 
  804288:	ff d0                	callq  *%rax
  80428a:	48 89 c6             	mov    %rax,%rsi
  80428d:	bf 00 00 00 00       	mov    $0x0,%edi
  804292:	48 b8 a1 1b 80 00 00 	movabs $0x801ba1,%rax
  804299:	00 00 00 
  80429c:	ff d0                	callq  *%rax
}
  80429e:	c9                   	leaveq 
  80429f:	c3                   	retq   

00000000008042a0 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8042a0:	55                   	push   %rbp
  8042a1:	48 89 e5             	mov    %rsp,%rbp
  8042a4:	48 83 ec 20          	sub    $0x20,%rsp
  8042a8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8042ab:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8042ae:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8042b1:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8042b5:	be 01 00 00 00       	mov    $0x1,%esi
  8042ba:	48 89 c7             	mov    %rax,%rdi
  8042bd:	48 b8 ae 19 80 00 00 	movabs $0x8019ae,%rax
  8042c4:	00 00 00 
  8042c7:	ff d0                	callq  *%rax
}
  8042c9:	c9                   	leaveq 
  8042ca:	c3                   	retq   

00000000008042cb <getchar>:

int
getchar(void)
{
  8042cb:	55                   	push   %rbp
  8042cc:	48 89 e5             	mov    %rsp,%rbp
  8042cf:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8042d3:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8042d7:	ba 01 00 00 00       	mov    $0x1,%edx
  8042dc:	48 89 c6             	mov    %rax,%rsi
  8042df:	bf 00 00 00 00       	mov    $0x0,%edi
  8042e4:	48 b8 df 29 80 00 00 	movabs $0x8029df,%rax
  8042eb:	00 00 00 
  8042ee:	ff d0                	callq  *%rax
  8042f0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8042f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042f7:	79 05                	jns    8042fe <getchar+0x33>
		return r;
  8042f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042fc:	eb 14                	jmp    804312 <getchar+0x47>
	if (r < 1)
  8042fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804302:	7f 07                	jg     80430b <getchar+0x40>
		return -E_EOF;
  804304:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804309:	eb 07                	jmp    804312 <getchar+0x47>
	return c;
  80430b:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80430f:	0f b6 c0             	movzbl %al,%eax
}
  804312:	c9                   	leaveq 
  804313:	c3                   	retq   

0000000000804314 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804314:	55                   	push   %rbp
  804315:	48 89 e5             	mov    %rsp,%rbp
  804318:	48 83 ec 20          	sub    $0x20,%rsp
  80431c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80431f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804323:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804326:	48 89 d6             	mov    %rdx,%rsi
  804329:	89 c7                	mov    %eax,%edi
  80432b:	48 b8 ad 25 80 00 00 	movabs $0x8025ad,%rax
  804332:	00 00 00 
  804335:	ff d0                	callq  *%rax
  804337:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80433a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80433e:	79 05                	jns    804345 <iscons+0x31>
		return r;
  804340:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804343:	eb 1a                	jmp    80435f <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804345:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804349:	8b 10                	mov    (%rax),%edx
  80434b:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  804352:	00 00 00 
  804355:	8b 00                	mov    (%rax),%eax
  804357:	39 c2                	cmp    %eax,%edx
  804359:	0f 94 c0             	sete   %al
  80435c:	0f b6 c0             	movzbl %al,%eax
}
  80435f:	c9                   	leaveq 
  804360:	c3                   	retq   

0000000000804361 <opencons>:

int
opencons(void)
{
  804361:	55                   	push   %rbp
  804362:	48 89 e5             	mov    %rsp,%rbp
  804365:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804369:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80436d:	48 89 c7             	mov    %rax,%rdi
  804370:	48 b8 15 25 80 00 00 	movabs $0x802515,%rax
  804377:	00 00 00 
  80437a:	ff d0                	callq  *%rax
  80437c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80437f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804383:	79 05                	jns    80438a <opencons+0x29>
		return r;
  804385:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804388:	eb 5b                	jmp    8043e5 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80438a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80438e:	ba 07 04 00 00       	mov    $0x407,%edx
  804393:	48 89 c6             	mov    %rax,%rsi
  804396:	bf 00 00 00 00       	mov    $0x0,%edi
  80439b:	48 b8 f6 1a 80 00 00 	movabs $0x801af6,%rax
  8043a2:	00 00 00 
  8043a5:	ff d0                	callq  *%rax
  8043a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8043aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043ae:	79 05                	jns    8043b5 <opencons+0x54>
		return r;
  8043b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043b3:	eb 30                	jmp    8043e5 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8043b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043b9:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  8043c0:	00 00 00 
  8043c3:	8b 12                	mov    (%rdx),%edx
  8043c5:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8043c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043cb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8043d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043d6:	48 89 c7             	mov    %rax,%rdi
  8043d9:	48 b8 c7 24 80 00 00 	movabs $0x8024c7,%rax
  8043e0:	00 00 00 
  8043e3:	ff d0                	callq  *%rax
}
  8043e5:	c9                   	leaveq 
  8043e6:	c3                   	retq   

00000000008043e7 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8043e7:	55                   	push   %rbp
  8043e8:	48 89 e5             	mov    %rsp,%rbp
  8043eb:	48 83 ec 30          	sub    $0x30,%rsp
  8043ef:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8043f3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8043f7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8043fb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804400:	75 07                	jne    804409 <devcons_read+0x22>
		return 0;
  804402:	b8 00 00 00 00       	mov    $0x0,%eax
  804407:	eb 4b                	jmp    804454 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  804409:	eb 0c                	jmp    804417 <devcons_read+0x30>
		sys_yield();
  80440b:	48 b8 b8 1a 80 00 00 	movabs $0x801ab8,%rax
  804412:	00 00 00 
  804415:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804417:	48 b8 f8 19 80 00 00 	movabs $0x8019f8,%rax
  80441e:	00 00 00 
  804421:	ff d0                	callq  *%rax
  804423:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804426:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80442a:	74 df                	je     80440b <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  80442c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804430:	79 05                	jns    804437 <devcons_read+0x50>
		return c;
  804432:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804435:	eb 1d                	jmp    804454 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  804437:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80443b:	75 07                	jne    804444 <devcons_read+0x5d>
		return 0;
  80443d:	b8 00 00 00 00       	mov    $0x0,%eax
  804442:	eb 10                	jmp    804454 <devcons_read+0x6d>
	*(char*)vbuf = c;
  804444:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804447:	89 c2                	mov    %eax,%edx
  804449:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80444d:	88 10                	mov    %dl,(%rax)
	return 1;
  80444f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804454:	c9                   	leaveq 
  804455:	c3                   	retq   

0000000000804456 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804456:	55                   	push   %rbp
  804457:	48 89 e5             	mov    %rsp,%rbp
  80445a:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804461:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804468:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80446f:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804476:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80447d:	eb 76                	jmp    8044f5 <devcons_write+0x9f>
		m = n - tot;
  80447f:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804486:	89 c2                	mov    %eax,%edx
  804488:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80448b:	29 c2                	sub    %eax,%edx
  80448d:	89 d0                	mov    %edx,%eax
  80448f:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804492:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804495:	83 f8 7f             	cmp    $0x7f,%eax
  804498:	76 07                	jbe    8044a1 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80449a:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8044a1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8044a4:	48 63 d0             	movslq %eax,%rdx
  8044a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044aa:	48 63 c8             	movslq %eax,%rcx
  8044ad:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8044b4:	48 01 c1             	add    %rax,%rcx
  8044b7:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8044be:	48 89 ce             	mov    %rcx,%rsi
  8044c1:	48 89 c7             	mov    %rax,%rdi
  8044c4:	48 b8 eb 14 80 00 00 	movabs $0x8014eb,%rax
  8044cb:	00 00 00 
  8044ce:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8044d0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8044d3:	48 63 d0             	movslq %eax,%rdx
  8044d6:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8044dd:	48 89 d6             	mov    %rdx,%rsi
  8044e0:	48 89 c7             	mov    %rax,%rdi
  8044e3:	48 b8 ae 19 80 00 00 	movabs $0x8019ae,%rax
  8044ea:	00 00 00 
  8044ed:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8044ef:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8044f2:	01 45 fc             	add    %eax,-0x4(%rbp)
  8044f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044f8:	48 98                	cltq   
  8044fa:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804501:	0f 82 78 ff ff ff    	jb     80447f <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804507:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80450a:	c9                   	leaveq 
  80450b:	c3                   	retq   

000000000080450c <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80450c:	55                   	push   %rbp
  80450d:	48 89 e5             	mov    %rsp,%rbp
  804510:	48 83 ec 08          	sub    $0x8,%rsp
  804514:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804518:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80451d:	c9                   	leaveq 
  80451e:	c3                   	retq   

000000000080451f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80451f:	55                   	push   %rbp
  804520:	48 89 e5             	mov    %rsp,%rbp
  804523:	48 83 ec 10          	sub    $0x10,%rsp
  804527:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80452b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80452f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804533:	48 be a5 51 80 00 00 	movabs $0x8051a5,%rsi
  80453a:	00 00 00 
  80453d:	48 89 c7             	mov    %rax,%rdi
  804540:	48 b8 c7 11 80 00 00 	movabs $0x8011c7,%rax
  804547:	00 00 00 
  80454a:	ff d0                	callq  *%rax
	return 0;
  80454c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804551:	c9                   	leaveq 
  804552:	c3                   	retq   

0000000000804553 <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804553:	55                   	push   %rbp
  804554:	48 89 e5             	mov    %rsp,%rbp
  804557:	48 83 ec 10          	sub    $0x10,%rsp
  80455b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  80455f:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804566:	00 00 00 
  804569:	48 8b 00             	mov    (%rax),%rax
  80456c:	48 85 c0             	test   %rax,%rax
  80456f:	0f 85 84 00 00 00    	jne    8045f9 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  804575:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80457c:	00 00 00 
  80457f:	48 8b 00             	mov    (%rax),%rax
  804582:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804588:	ba 07 00 00 00       	mov    $0x7,%edx
  80458d:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  804592:	89 c7                	mov    %eax,%edi
  804594:	48 b8 f6 1a 80 00 00 	movabs $0x801af6,%rax
  80459b:	00 00 00 
  80459e:	ff d0                	callq  *%rax
  8045a0:	85 c0                	test   %eax,%eax
  8045a2:	79 2a                	jns    8045ce <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  8045a4:	48 ba b0 51 80 00 00 	movabs $0x8051b0,%rdx
  8045ab:	00 00 00 
  8045ae:	be 23 00 00 00       	mov    $0x23,%esi
  8045b3:	48 bf d7 51 80 00 00 	movabs $0x8051d7,%rdi
  8045ba:	00 00 00 
  8045bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8045c2:	48 b9 d9 03 80 00 00 	movabs $0x8003d9,%rcx
  8045c9:	00 00 00 
  8045cc:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  8045ce:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8045d5:	00 00 00 
  8045d8:	48 8b 00             	mov    (%rax),%rax
  8045db:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8045e1:	48 be 0c 46 80 00 00 	movabs $0x80460c,%rsi
  8045e8:	00 00 00 
  8045eb:	89 c7                	mov    %eax,%edi
  8045ed:	48 b8 80 1c 80 00 00 	movabs $0x801c80,%rax
  8045f4:	00 00 00 
  8045f7:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  8045f9:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804600:	00 00 00 
  804603:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804607:	48 89 10             	mov    %rdx,(%rax)
}
  80460a:	c9                   	leaveq 
  80460b:	c3                   	retq   

000000000080460c <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  80460c:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  80460f:	48 a1 00 c0 80 00 00 	movabs 0x80c000,%rax
  804616:	00 00 00 
call *%rax
  804619:	ff d0                	callq  *%rax
    // LAB 4: Your code here.

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.

	movq 136(%rsp), %rbx  //Load RIP 
  80461b:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  804622:	00 
	movq 152(%rsp), %rcx  //Load RSP
  804623:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  80462a:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  80462b:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  80462f:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  804632:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  804639:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  80463a:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  80463e:	4c 8b 3c 24          	mov    (%rsp),%r15
  804642:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804647:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  80464c:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804651:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804656:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  80465b:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804660:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  804665:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  80466a:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  80466f:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804674:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804679:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  80467e:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804683:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804688:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  80468c:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  804690:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  804691:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  804692:	c3                   	retq   

0000000000804693 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804693:	55                   	push   %rbp
  804694:	48 89 e5             	mov    %rsp,%rbp
  804697:	48 83 ec 30          	sub    $0x30,%rsp
  80469b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80469f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8046a3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  8046a7:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8046ae:	00 00 00 
  8046b1:	48 8b 00             	mov    (%rax),%rax
  8046b4:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8046ba:	85 c0                	test   %eax,%eax
  8046bc:	75 3c                	jne    8046fa <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  8046be:	48 b8 7a 1a 80 00 00 	movabs $0x801a7a,%rax
  8046c5:	00 00 00 
  8046c8:	ff d0                	callq  *%rax
  8046ca:	25 ff 03 00 00       	and    $0x3ff,%eax
  8046cf:	48 63 d0             	movslq %eax,%rdx
  8046d2:	48 89 d0             	mov    %rdx,%rax
  8046d5:	48 c1 e0 03          	shl    $0x3,%rax
  8046d9:	48 01 d0             	add    %rdx,%rax
  8046dc:	48 c1 e0 05          	shl    $0x5,%rax
  8046e0:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8046e7:	00 00 00 
  8046ea:	48 01 c2             	add    %rax,%rdx
  8046ed:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8046f4:	00 00 00 
  8046f7:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  8046fa:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8046ff:	75 0e                	jne    80470f <ipc_recv+0x7c>
		pg = (void*) UTOP;
  804701:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804708:	00 00 00 
  80470b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  80470f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804713:	48 89 c7             	mov    %rax,%rdi
  804716:	48 b8 1f 1d 80 00 00 	movabs $0x801d1f,%rax
  80471d:	00 00 00 
  804720:	ff d0                	callq  *%rax
  804722:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  804725:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804729:	79 19                	jns    804744 <ipc_recv+0xb1>
		*from_env_store = 0;
  80472b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80472f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  804735:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804739:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  80473f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804742:	eb 53                	jmp    804797 <ipc_recv+0x104>
	}
	if(from_env_store)
  804744:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804749:	74 19                	je     804764 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  80474b:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804752:	00 00 00 
  804755:	48 8b 00             	mov    (%rax),%rax
  804758:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80475e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804762:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  804764:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804769:	74 19                	je     804784 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  80476b:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804772:	00 00 00 
  804775:	48 8b 00             	mov    (%rax),%rax
  804778:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80477e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804782:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  804784:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80478b:	00 00 00 
  80478e:	48 8b 00             	mov    (%rax),%rax
  804791:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  804797:	c9                   	leaveq 
  804798:	c3                   	retq   

0000000000804799 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804799:	55                   	push   %rbp
  80479a:	48 89 e5             	mov    %rsp,%rbp
  80479d:	48 83 ec 30          	sub    $0x30,%rsp
  8047a1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8047a4:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8047a7:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8047ab:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  8047ae:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8047b3:	75 0e                	jne    8047c3 <ipc_send+0x2a>
		pg = (void*)UTOP;
  8047b5:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8047bc:	00 00 00 
  8047bf:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  8047c3:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8047c6:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8047c9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8047cd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8047d0:	89 c7                	mov    %eax,%edi
  8047d2:	48 b8 ca 1c 80 00 00 	movabs $0x801cca,%rax
  8047d9:	00 00 00 
  8047dc:	ff d0                	callq  *%rax
  8047de:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  8047e1:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8047e5:	75 0c                	jne    8047f3 <ipc_send+0x5a>
			sys_yield();
  8047e7:	48 b8 b8 1a 80 00 00 	movabs $0x801ab8,%rax
  8047ee:	00 00 00 
  8047f1:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  8047f3:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8047f7:	74 ca                	je     8047c3 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  8047f9:	c9                   	leaveq 
  8047fa:	c3                   	retq   

00000000008047fb <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8047fb:	55                   	push   %rbp
  8047fc:	48 89 e5             	mov    %rsp,%rbp
  8047ff:	48 83 ec 14          	sub    $0x14,%rsp
  804803:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804806:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80480d:	eb 5e                	jmp    80486d <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  80480f:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804816:	00 00 00 
  804819:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80481c:	48 63 d0             	movslq %eax,%rdx
  80481f:	48 89 d0             	mov    %rdx,%rax
  804822:	48 c1 e0 03          	shl    $0x3,%rax
  804826:	48 01 d0             	add    %rdx,%rax
  804829:	48 c1 e0 05          	shl    $0x5,%rax
  80482d:	48 01 c8             	add    %rcx,%rax
  804830:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804836:	8b 00                	mov    (%rax),%eax
  804838:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80483b:	75 2c                	jne    804869 <ipc_find_env+0x6e>
			return envs[i].env_id;
  80483d:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804844:	00 00 00 
  804847:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80484a:	48 63 d0             	movslq %eax,%rdx
  80484d:	48 89 d0             	mov    %rdx,%rax
  804850:	48 c1 e0 03          	shl    $0x3,%rax
  804854:	48 01 d0             	add    %rdx,%rax
  804857:	48 c1 e0 05          	shl    $0x5,%rax
  80485b:	48 01 c8             	add    %rcx,%rax
  80485e:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804864:	8b 40 08             	mov    0x8(%rax),%eax
  804867:	eb 12                	jmp    80487b <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804869:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80486d:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804874:	7e 99                	jle    80480f <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804876:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80487b:	c9                   	leaveq 
  80487c:	c3                   	retq   

000000000080487d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80487d:	55                   	push   %rbp
  80487e:	48 89 e5             	mov    %rsp,%rbp
  804881:	48 83 ec 18          	sub    $0x18,%rsp
  804885:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804889:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80488d:	48 c1 e8 15          	shr    $0x15,%rax
  804891:	48 89 c2             	mov    %rax,%rdx
  804894:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80489b:	01 00 00 
  80489e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8048a2:	83 e0 01             	and    $0x1,%eax
  8048a5:	48 85 c0             	test   %rax,%rax
  8048a8:	75 07                	jne    8048b1 <pageref+0x34>
		return 0;
  8048aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8048af:	eb 53                	jmp    804904 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8048b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8048b5:	48 c1 e8 0c          	shr    $0xc,%rax
  8048b9:	48 89 c2             	mov    %rax,%rdx
  8048bc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8048c3:	01 00 00 
  8048c6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8048ca:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8048ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048d2:	83 e0 01             	and    $0x1,%eax
  8048d5:	48 85 c0             	test   %rax,%rax
  8048d8:	75 07                	jne    8048e1 <pageref+0x64>
		return 0;
  8048da:	b8 00 00 00 00       	mov    $0x0,%eax
  8048df:	eb 23                	jmp    804904 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8048e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048e5:	48 c1 e8 0c          	shr    $0xc,%rax
  8048e9:	48 89 c2             	mov    %rax,%rdx
  8048ec:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8048f3:	00 00 00 
  8048f6:	48 c1 e2 04          	shl    $0x4,%rdx
  8048fa:	48 01 d0             	add    %rdx,%rax
  8048fd:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804901:	0f b7 c0             	movzwl %ax,%eax
}
  804904:	c9                   	leaveq 
  804905:	c3                   	retq   
