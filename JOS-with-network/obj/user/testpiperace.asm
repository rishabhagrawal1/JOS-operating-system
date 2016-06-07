
obj/user/testpiperace.debug:     file format elf64-x86-64


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
  80003c:	e8 4c 03 00 00       	callq  80038d <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 50          	sub    $0x50,%rsp
  80004b:	89 7d bc             	mov    %edi,-0x44(%rbp)
  80004e:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
	int p[2], r, pid, i, max;
	void *va;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for dup race...\n");
  800052:	48 bf 80 49 80 00 00 	movabs $0x804980,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 74 06 80 00 00 	movabs $0x800674,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	if ((r = pipe(p)) < 0)
  80006d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800071:	48 89 c7             	mov    %rax,%rdi
  800074:	48 b8 ac 3f 80 00 00 	movabs $0x803fac,%rax
  80007b:	00 00 00 
  80007e:	ff d0                	callq  *%rax
  800080:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800083:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800087:	79 30                	jns    8000b9 <umain+0x76>
		panic("pipe: %e", r);
  800089:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80008c:	89 c1                	mov    %eax,%ecx
  80008e:	48 ba 99 49 80 00 00 	movabs $0x804999,%rdx
  800095:	00 00 00 
  800098:	be 0d 00 00 00       	mov    $0xd,%esi
  80009d:	48 bf a2 49 80 00 00 	movabs $0x8049a2,%rdi
  8000a4:	00 00 00 
  8000a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ac:	49 b8 3b 04 80 00 00 	movabs $0x80043b,%r8
  8000b3:	00 00 00 
  8000b6:	41 ff d0             	callq  *%r8
	max = 200;
  8000b9:	c7 45 f4 c8 00 00 00 	movl   $0xc8,-0xc(%rbp)
	if ((r = fork()) < 0)
  8000c0:	48 b8 78 22 80 00 00 	movabs $0x802278,%rax
  8000c7:	00 00 00 
  8000ca:	ff d0                	callq  *%rax
  8000cc:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000cf:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000d3:	79 30                	jns    800105 <umain+0xc2>
		panic("fork: %e", r);
  8000d5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d8:	89 c1                	mov    %eax,%ecx
  8000da:	48 ba b6 49 80 00 00 	movabs $0x8049b6,%rdx
  8000e1:	00 00 00 
  8000e4:	be 10 00 00 00       	mov    $0x10,%esi
  8000e9:	48 bf a2 49 80 00 00 	movabs $0x8049a2,%rdi
  8000f0:	00 00 00 
  8000f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f8:	49 b8 3b 04 80 00 00 	movabs $0x80043b,%r8
  8000ff:	00 00 00 
  800102:	41 ff d0             	callq  *%r8
	if (r == 0) {
  800105:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800109:	0f 85 89 00 00 00    	jne    800198 <umain+0x155>
		close(p[1]);
  80010f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800112:	89 c7                	mov    %eax,%edi
  800114:	48 b8 09 2a 80 00 00 	movabs $0x802a09,%rax
  80011b:	00 00 00 
  80011e:	ff d0                	callq  *%rax
		//
		// If a clock interrupt catches dup between mapping the
		// fd and mapping the pipe structure, we'll have the same
		// ref counts, still a no-no.
		//
		for (i=0; i<max; i++) {
  800120:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800127:	eb 4c                	jmp    800175 <umain+0x132>
			if(pipeisclosed(p[0])){
  800129:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80012c:	89 c7                	mov    %eax,%edi
  80012e:	48 b8 75 42 80 00 00 	movabs $0x804275,%rax
  800135:	00 00 00 
  800138:	ff d0                	callq  *%rax
  80013a:	85 c0                	test   %eax,%eax
  80013c:	74 27                	je     800165 <umain+0x122>
				cprintf("RACE: pipe appears closed\n");
  80013e:	48 bf bf 49 80 00 00 	movabs $0x8049bf,%rdi
  800145:	00 00 00 
  800148:	b8 00 00 00 00       	mov    $0x0,%eax
  80014d:	48 ba 74 06 80 00 00 	movabs $0x800674,%rdx
  800154:	00 00 00 
  800157:	ff d2                	callq  *%rdx
				exit();
  800159:	48 b8 18 04 80 00 00 	movabs $0x800418,%rax
  800160:	00 00 00 
  800163:	ff d0                	callq  *%rax
			}
			sys_yield();
  800165:	48 b8 1a 1b 80 00 00 	movabs $0x801b1a,%rax
  80016c:	00 00 00 
  80016f:	ff d0                	callq  *%rax
		//
		// If a clock interrupt catches dup between mapping the
		// fd and mapping the pipe structure, we'll have the same
		// ref counts, still a no-no.
		//
		for (i=0; i<max; i++) {
  800171:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800175:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800178:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80017b:	7c ac                	jl     800129 <umain+0xe6>
				exit();
			}
			sys_yield();
		}
		// do something to be not runnable besides exiting
		ipc_recv(0,0,0);
  80017d:	ba 00 00 00 00       	mov    $0x0,%edx
  800182:	be 00 00 00 00       	mov    $0x0,%esi
  800187:	bf 00 00 00 00       	mov    $0x0,%edi
  80018c:	48 b8 29 25 80 00 00 	movabs $0x802529,%rax
  800193:	00 00 00 
  800196:	ff d0                	callq  *%rax
	}
	pid = r;
  800198:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80019b:	89 45 f0             	mov    %eax,-0x10(%rbp)
	cprintf("pid is %d\n", pid);
  80019e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001a1:	89 c6                	mov    %eax,%esi
  8001a3:	48 bf da 49 80 00 00 	movabs $0x8049da,%rdi
  8001aa:	00 00 00 
  8001ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8001b2:	48 ba 74 06 80 00 00 	movabs $0x800674,%rdx
  8001b9:	00 00 00 
  8001bc:	ff d2                	callq  *%rdx
	va = 0;
  8001be:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8001c5:	00 
	kid = &envs[ENVX(pid)];
  8001c6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001c9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001ce:	48 63 d0             	movslq %eax,%rdx
  8001d1:	48 89 d0             	mov    %rdx,%rax
  8001d4:	48 c1 e0 03          	shl    $0x3,%rax
  8001d8:	48 01 d0             	add    %rdx,%rax
  8001db:	48 c1 e0 05          	shl    $0x5,%rax
  8001df:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8001e6:	00 00 00 
  8001e9:	48 01 d0             	add    %rdx,%rax
  8001ec:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	cprintf("kid is %d\n", kid-envs);
  8001f0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8001f4:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8001fb:	00 00 00 
  8001fe:	48 29 c2             	sub    %rax,%rdx
  800201:	48 89 d0             	mov    %rdx,%rax
  800204:	48 c1 f8 05          	sar    $0x5,%rax
  800208:	48 89 c2             	mov    %rax,%rdx
  80020b:	48 b8 39 8e e3 38 8e 	movabs $0x8e38e38e38e38e39,%rax
  800212:	e3 38 8e 
  800215:	48 0f af c2          	imul   %rdx,%rax
  800219:	48 89 c6             	mov    %rax,%rsi
  80021c:	48 bf e5 49 80 00 00 	movabs $0x8049e5,%rdi
  800223:	00 00 00 
  800226:	b8 00 00 00 00       	mov    $0x0,%eax
  80022b:	48 ba 74 06 80 00 00 	movabs $0x800674,%rdx
  800232:	00 00 00 
  800235:	ff d2                	callq  *%rdx
	dup(p[0], 10);
  800237:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80023a:	be 0a 00 00 00       	mov    $0xa,%esi
  80023f:	89 c7                	mov    %eax,%edi
  800241:	48 b8 82 2a 80 00 00 	movabs $0x802a82,%rax
  800248:	00 00 00 
  80024b:	ff d0                	callq  *%rax
	while (kid->env_status == ENV_RUNNABLE)
  80024d:	eb 16                	jmp    800265 <umain+0x222>
		dup(p[0], 10);
  80024f:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800252:	be 0a 00 00 00       	mov    $0xa,%esi
  800257:	89 c7                	mov    %eax,%edi
  800259:	48 b8 82 2a 80 00 00 	movabs $0x802a82,%rax
  800260:	00 00 00 
  800263:	ff d0                	callq  *%rax
	cprintf("pid is %d\n", pid);
	va = 0;
	kid = &envs[ENVX(pid)];
	cprintf("kid is %d\n", kid-envs);
	dup(p[0], 10);
	while (kid->env_status == ENV_RUNNABLE)
  800265:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800269:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  80026f:	83 f8 02             	cmp    $0x2,%eax
  800272:	74 db                	je     80024f <umain+0x20c>
		dup(p[0], 10);

	cprintf("child done with loop\n");
  800274:	48 bf f0 49 80 00 00 	movabs $0x8049f0,%rdi
  80027b:	00 00 00 
  80027e:	b8 00 00 00 00       	mov    $0x0,%eax
  800283:	48 ba 74 06 80 00 00 	movabs $0x800674,%rdx
  80028a:	00 00 00 
  80028d:	ff d2                	callq  *%rdx
	if (pipeisclosed(p[0]))
  80028f:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800292:	89 c7                	mov    %eax,%edi
  800294:	48 b8 75 42 80 00 00 	movabs $0x804275,%rax
  80029b:	00 00 00 
  80029e:	ff d0                	callq  *%rax
  8002a0:	85 c0                	test   %eax,%eax
  8002a2:	74 2a                	je     8002ce <umain+0x28b>
		panic("somehow the other end of p[0] got closed!");
  8002a4:	48 ba 08 4a 80 00 00 	movabs $0x804a08,%rdx
  8002ab:	00 00 00 
  8002ae:	be 3a 00 00 00       	mov    $0x3a,%esi
  8002b3:	48 bf a2 49 80 00 00 	movabs $0x8049a2,%rdi
  8002ba:	00 00 00 
  8002bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c2:	48 b9 3b 04 80 00 00 	movabs $0x80043b,%rcx
  8002c9:	00 00 00 
  8002cc:	ff d1                	callq  *%rcx
	if ((r = fd_lookup(p[0], &fd)) < 0)
  8002ce:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8002d1:	48 8d 55 c8          	lea    -0x38(%rbp),%rdx
  8002d5:	48 89 d6             	mov    %rdx,%rsi
  8002d8:	89 c7                	mov    %eax,%edi
  8002da:	48 b8 f9 27 80 00 00 	movabs $0x8027f9,%rax
  8002e1:	00 00 00 
  8002e4:	ff d0                	callq  *%rax
  8002e6:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8002e9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8002ed:	79 30                	jns    80031f <umain+0x2dc>
		panic("cannot look up p[0]: %e", r);
  8002ef:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002f2:	89 c1                	mov    %eax,%ecx
  8002f4:	48 ba 32 4a 80 00 00 	movabs $0x804a32,%rdx
  8002fb:	00 00 00 
  8002fe:	be 3c 00 00 00       	mov    $0x3c,%esi
  800303:	48 bf a2 49 80 00 00 	movabs $0x8049a2,%rdi
  80030a:	00 00 00 
  80030d:	b8 00 00 00 00       	mov    $0x0,%eax
  800312:	49 b8 3b 04 80 00 00 	movabs $0x80043b,%r8
  800319:	00 00 00 
  80031c:	41 ff d0             	callq  *%r8
	va = fd2data(fd);
  80031f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800323:	48 89 c7             	mov    %rax,%rdi
  800326:	48 b8 36 27 80 00 00 	movabs $0x802736,%rax
  80032d:	00 00 00 
  800330:	ff d0                	callq  *%rax
  800332:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	if (pageref(va) != 3+1)
  800336:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80033a:	48 89 c7             	mov    %rax,%rdi
  80033d:	48 b8 17 37 80 00 00 	movabs $0x803717,%rax
  800344:	00 00 00 
  800347:	ff d0                	callq  *%rax
  800349:	83 f8 04             	cmp    $0x4,%eax
  80034c:	74 1d                	je     80036b <umain+0x328>
		cprintf("\nchild detected race\n");
  80034e:	48 bf 4a 4a 80 00 00 	movabs $0x804a4a,%rdi
  800355:	00 00 00 
  800358:	b8 00 00 00 00       	mov    $0x0,%eax
  80035d:	48 ba 74 06 80 00 00 	movabs $0x800674,%rdx
  800364:	00 00 00 
  800367:	ff d2                	callq  *%rdx
  800369:	eb 20                	jmp    80038b <umain+0x348>
	else
		cprintf("\nrace didn't happen\n", max);
  80036b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80036e:	89 c6                	mov    %eax,%esi
  800370:	48 bf 60 4a 80 00 00 	movabs $0x804a60,%rdi
  800377:	00 00 00 
  80037a:	b8 00 00 00 00       	mov    $0x0,%eax
  80037f:	48 ba 74 06 80 00 00 	movabs $0x800674,%rdx
  800386:	00 00 00 
  800389:	ff d2                	callq  *%rdx
}
  80038b:	c9                   	leaveq 
  80038c:	c3                   	retq   

000000000080038d <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80038d:	55                   	push   %rbp
  80038e:	48 89 e5             	mov    %rsp,%rbp
  800391:	48 83 ec 10          	sub    $0x10,%rsp
  800395:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800398:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80039c:	48 b8 dc 1a 80 00 00 	movabs $0x801adc,%rax
  8003a3:	00 00 00 
  8003a6:	ff d0                	callq  *%rax
  8003a8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8003ad:	48 63 d0             	movslq %eax,%rdx
  8003b0:	48 89 d0             	mov    %rdx,%rax
  8003b3:	48 c1 e0 03          	shl    $0x3,%rax
  8003b7:	48 01 d0             	add    %rdx,%rax
  8003ba:	48 c1 e0 05          	shl    $0x5,%rax
  8003be:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8003c5:	00 00 00 
  8003c8:	48 01 c2             	add    %rax,%rdx
  8003cb:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8003d2:	00 00 00 
  8003d5:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8003dc:	7e 14                	jle    8003f2 <libmain+0x65>
		binaryname = argv[0];
  8003de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003e2:	48 8b 10             	mov    (%rax),%rdx
  8003e5:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8003ec:	00 00 00 
  8003ef:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8003f2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003f9:	48 89 d6             	mov    %rdx,%rsi
  8003fc:	89 c7                	mov    %eax,%edi
  8003fe:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800405:	00 00 00 
  800408:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  80040a:	48 b8 18 04 80 00 00 	movabs $0x800418,%rax
  800411:	00 00 00 
  800414:	ff d0                	callq  *%rax
}
  800416:	c9                   	leaveq 
  800417:	c3                   	retq   

0000000000800418 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800418:	55                   	push   %rbp
  800419:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80041c:	48 b8 54 2a 80 00 00 	movabs $0x802a54,%rax
  800423:	00 00 00 
  800426:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800428:	bf 00 00 00 00       	mov    $0x0,%edi
  80042d:	48 b8 98 1a 80 00 00 	movabs $0x801a98,%rax
  800434:	00 00 00 
  800437:	ff d0                	callq  *%rax

}
  800439:	5d                   	pop    %rbp
  80043a:	c3                   	retq   

000000000080043b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80043b:	55                   	push   %rbp
  80043c:	48 89 e5             	mov    %rsp,%rbp
  80043f:	53                   	push   %rbx
  800440:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800447:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80044e:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800454:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80045b:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800462:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800469:	84 c0                	test   %al,%al
  80046b:	74 23                	je     800490 <_panic+0x55>
  80046d:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800474:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800478:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80047c:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800480:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800484:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800488:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80048c:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800490:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800497:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80049e:	00 00 00 
  8004a1:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8004a8:	00 00 00 
  8004ab:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004af:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8004b6:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8004bd:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8004c4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8004cb:	00 00 00 
  8004ce:	48 8b 18             	mov    (%rax),%rbx
  8004d1:	48 b8 dc 1a 80 00 00 	movabs $0x801adc,%rax
  8004d8:	00 00 00 
  8004db:	ff d0                	callq  *%rax
  8004dd:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8004e3:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8004ea:	41 89 c8             	mov    %ecx,%r8d
  8004ed:	48 89 d1             	mov    %rdx,%rcx
  8004f0:	48 89 da             	mov    %rbx,%rdx
  8004f3:	89 c6                	mov    %eax,%esi
  8004f5:	48 bf 80 4a 80 00 00 	movabs $0x804a80,%rdi
  8004fc:	00 00 00 
  8004ff:	b8 00 00 00 00       	mov    $0x0,%eax
  800504:	49 b9 74 06 80 00 00 	movabs $0x800674,%r9
  80050b:	00 00 00 
  80050e:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800511:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800518:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80051f:	48 89 d6             	mov    %rdx,%rsi
  800522:	48 89 c7             	mov    %rax,%rdi
  800525:	48 b8 c8 05 80 00 00 	movabs $0x8005c8,%rax
  80052c:	00 00 00 
  80052f:	ff d0                	callq  *%rax
	cprintf("\n");
  800531:	48 bf a3 4a 80 00 00 	movabs $0x804aa3,%rdi
  800538:	00 00 00 
  80053b:	b8 00 00 00 00       	mov    $0x0,%eax
  800540:	48 ba 74 06 80 00 00 	movabs $0x800674,%rdx
  800547:	00 00 00 
  80054a:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80054c:	cc                   	int3   
  80054d:	eb fd                	jmp    80054c <_panic+0x111>

000000000080054f <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80054f:	55                   	push   %rbp
  800550:	48 89 e5             	mov    %rsp,%rbp
  800553:	48 83 ec 10          	sub    $0x10,%rsp
  800557:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80055a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80055e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800562:	8b 00                	mov    (%rax),%eax
  800564:	8d 48 01             	lea    0x1(%rax),%ecx
  800567:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80056b:	89 0a                	mov    %ecx,(%rdx)
  80056d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800570:	89 d1                	mov    %edx,%ecx
  800572:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800576:	48 98                	cltq   
  800578:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80057c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800580:	8b 00                	mov    (%rax),%eax
  800582:	3d ff 00 00 00       	cmp    $0xff,%eax
  800587:	75 2c                	jne    8005b5 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800589:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80058d:	8b 00                	mov    (%rax),%eax
  80058f:	48 98                	cltq   
  800591:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800595:	48 83 c2 08          	add    $0x8,%rdx
  800599:	48 89 c6             	mov    %rax,%rsi
  80059c:	48 89 d7             	mov    %rdx,%rdi
  80059f:	48 b8 10 1a 80 00 00 	movabs $0x801a10,%rax
  8005a6:	00 00 00 
  8005a9:	ff d0                	callq  *%rax
        b->idx = 0;
  8005ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005af:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8005b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005b9:	8b 40 04             	mov    0x4(%rax),%eax
  8005bc:	8d 50 01             	lea    0x1(%rax),%edx
  8005bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005c3:	89 50 04             	mov    %edx,0x4(%rax)
}
  8005c6:	c9                   	leaveq 
  8005c7:	c3                   	retq   

00000000008005c8 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8005c8:	55                   	push   %rbp
  8005c9:	48 89 e5             	mov    %rsp,%rbp
  8005cc:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8005d3:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8005da:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8005e1:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8005e8:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8005ef:	48 8b 0a             	mov    (%rdx),%rcx
  8005f2:	48 89 08             	mov    %rcx,(%rax)
  8005f5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005f9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005fd:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800601:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800605:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80060c:	00 00 00 
    b.cnt = 0;
  80060f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800616:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800619:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800620:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800627:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80062e:	48 89 c6             	mov    %rax,%rsi
  800631:	48 bf 4f 05 80 00 00 	movabs $0x80054f,%rdi
  800638:	00 00 00 
  80063b:	48 b8 27 0a 80 00 00 	movabs $0x800a27,%rax
  800642:	00 00 00 
  800645:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800647:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80064d:	48 98                	cltq   
  80064f:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800656:	48 83 c2 08          	add    $0x8,%rdx
  80065a:	48 89 c6             	mov    %rax,%rsi
  80065d:	48 89 d7             	mov    %rdx,%rdi
  800660:	48 b8 10 1a 80 00 00 	movabs $0x801a10,%rax
  800667:	00 00 00 
  80066a:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80066c:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800672:	c9                   	leaveq 
  800673:	c3                   	retq   

0000000000800674 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800674:	55                   	push   %rbp
  800675:	48 89 e5             	mov    %rsp,%rbp
  800678:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80067f:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800686:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80068d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800694:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80069b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8006a2:	84 c0                	test   %al,%al
  8006a4:	74 20                	je     8006c6 <cprintf+0x52>
  8006a6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8006aa:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8006ae:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8006b2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8006b6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8006ba:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8006be:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8006c2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8006c6:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8006cd:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8006d4:	00 00 00 
  8006d7:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8006de:	00 00 00 
  8006e1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8006e5:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8006ec:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8006f3:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8006fa:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800701:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800708:	48 8b 0a             	mov    (%rdx),%rcx
  80070b:	48 89 08             	mov    %rcx,(%rax)
  80070e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800712:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800716:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80071a:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80071e:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800725:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80072c:	48 89 d6             	mov    %rdx,%rsi
  80072f:	48 89 c7             	mov    %rax,%rdi
  800732:	48 b8 c8 05 80 00 00 	movabs $0x8005c8,%rax
  800739:	00 00 00 
  80073c:	ff d0                	callq  *%rax
  80073e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800744:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80074a:	c9                   	leaveq 
  80074b:	c3                   	retq   

000000000080074c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80074c:	55                   	push   %rbp
  80074d:	48 89 e5             	mov    %rsp,%rbp
  800750:	53                   	push   %rbx
  800751:	48 83 ec 38          	sub    $0x38,%rsp
  800755:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800759:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80075d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800761:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800764:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800768:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80076c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80076f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800773:	77 3b                	ja     8007b0 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800775:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800778:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80077c:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80077f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800783:	ba 00 00 00 00       	mov    $0x0,%edx
  800788:	48 f7 f3             	div    %rbx
  80078b:	48 89 c2             	mov    %rax,%rdx
  80078e:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800791:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800794:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800798:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079c:	41 89 f9             	mov    %edi,%r9d
  80079f:	48 89 c7             	mov    %rax,%rdi
  8007a2:	48 b8 4c 07 80 00 00 	movabs $0x80074c,%rax
  8007a9:	00 00 00 
  8007ac:	ff d0                	callq  *%rax
  8007ae:	eb 1e                	jmp    8007ce <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007b0:	eb 12                	jmp    8007c4 <printnum+0x78>
			putch(padc, putdat);
  8007b2:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8007b6:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8007b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007bd:	48 89 ce             	mov    %rcx,%rsi
  8007c0:	89 d7                	mov    %edx,%edi
  8007c2:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007c4:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8007c8:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8007cc:	7f e4                	jg     8007b2 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007ce:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8007d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8007da:	48 f7 f1             	div    %rcx
  8007dd:	48 89 d0             	mov    %rdx,%rax
  8007e0:	48 ba b0 4c 80 00 00 	movabs $0x804cb0,%rdx
  8007e7:	00 00 00 
  8007ea:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8007ee:	0f be d0             	movsbl %al,%edx
  8007f1:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8007f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f9:	48 89 ce             	mov    %rcx,%rsi
  8007fc:	89 d7                	mov    %edx,%edi
  8007fe:	ff d0                	callq  *%rax
}
  800800:	48 83 c4 38          	add    $0x38,%rsp
  800804:	5b                   	pop    %rbx
  800805:	5d                   	pop    %rbp
  800806:	c3                   	retq   

0000000000800807 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800807:	55                   	push   %rbp
  800808:	48 89 e5             	mov    %rsp,%rbp
  80080b:	48 83 ec 1c          	sub    $0x1c,%rsp
  80080f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800813:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800816:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80081a:	7e 52                	jle    80086e <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80081c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800820:	8b 00                	mov    (%rax),%eax
  800822:	83 f8 30             	cmp    $0x30,%eax
  800825:	73 24                	jae    80084b <getuint+0x44>
  800827:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80082b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80082f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800833:	8b 00                	mov    (%rax),%eax
  800835:	89 c0                	mov    %eax,%eax
  800837:	48 01 d0             	add    %rdx,%rax
  80083a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80083e:	8b 12                	mov    (%rdx),%edx
  800840:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800843:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800847:	89 0a                	mov    %ecx,(%rdx)
  800849:	eb 17                	jmp    800862 <getuint+0x5b>
  80084b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800853:	48 89 d0             	mov    %rdx,%rax
  800856:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80085a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80085e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800862:	48 8b 00             	mov    (%rax),%rax
  800865:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800869:	e9 a3 00 00 00       	jmpq   800911 <getuint+0x10a>
	else if (lflag)
  80086e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800872:	74 4f                	je     8008c3 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800874:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800878:	8b 00                	mov    (%rax),%eax
  80087a:	83 f8 30             	cmp    $0x30,%eax
  80087d:	73 24                	jae    8008a3 <getuint+0x9c>
  80087f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800883:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800887:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80088b:	8b 00                	mov    (%rax),%eax
  80088d:	89 c0                	mov    %eax,%eax
  80088f:	48 01 d0             	add    %rdx,%rax
  800892:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800896:	8b 12                	mov    (%rdx),%edx
  800898:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80089b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80089f:	89 0a                	mov    %ecx,(%rdx)
  8008a1:	eb 17                	jmp    8008ba <getuint+0xb3>
  8008a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008ab:	48 89 d0             	mov    %rdx,%rax
  8008ae:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008b2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008b6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008ba:	48 8b 00             	mov    (%rax),%rax
  8008bd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008c1:	eb 4e                	jmp    800911 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8008c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c7:	8b 00                	mov    (%rax),%eax
  8008c9:	83 f8 30             	cmp    $0x30,%eax
  8008cc:	73 24                	jae    8008f2 <getuint+0xeb>
  8008ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008da:	8b 00                	mov    (%rax),%eax
  8008dc:	89 c0                	mov    %eax,%eax
  8008de:	48 01 d0             	add    %rdx,%rax
  8008e1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008e5:	8b 12                	mov    (%rdx),%edx
  8008e7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008ea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ee:	89 0a                	mov    %ecx,(%rdx)
  8008f0:	eb 17                	jmp    800909 <getuint+0x102>
  8008f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f6:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008fa:	48 89 d0             	mov    %rdx,%rax
  8008fd:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800901:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800905:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800909:	8b 00                	mov    (%rax),%eax
  80090b:	89 c0                	mov    %eax,%eax
  80090d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800911:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800915:	c9                   	leaveq 
  800916:	c3                   	retq   

0000000000800917 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800917:	55                   	push   %rbp
  800918:	48 89 e5             	mov    %rsp,%rbp
  80091b:	48 83 ec 1c          	sub    $0x1c,%rsp
  80091f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800923:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800926:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80092a:	7e 52                	jle    80097e <getint+0x67>
		x=va_arg(*ap, long long);
  80092c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800930:	8b 00                	mov    (%rax),%eax
  800932:	83 f8 30             	cmp    $0x30,%eax
  800935:	73 24                	jae    80095b <getint+0x44>
  800937:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80093b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80093f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800943:	8b 00                	mov    (%rax),%eax
  800945:	89 c0                	mov    %eax,%eax
  800947:	48 01 d0             	add    %rdx,%rax
  80094a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80094e:	8b 12                	mov    (%rdx),%edx
  800950:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800953:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800957:	89 0a                	mov    %ecx,(%rdx)
  800959:	eb 17                	jmp    800972 <getint+0x5b>
  80095b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80095f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800963:	48 89 d0             	mov    %rdx,%rax
  800966:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80096a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80096e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800972:	48 8b 00             	mov    (%rax),%rax
  800975:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800979:	e9 a3 00 00 00       	jmpq   800a21 <getint+0x10a>
	else if (lflag)
  80097e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800982:	74 4f                	je     8009d3 <getint+0xbc>
		x=va_arg(*ap, long);
  800984:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800988:	8b 00                	mov    (%rax),%eax
  80098a:	83 f8 30             	cmp    $0x30,%eax
  80098d:	73 24                	jae    8009b3 <getint+0x9c>
  80098f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800993:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800997:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80099b:	8b 00                	mov    (%rax),%eax
  80099d:	89 c0                	mov    %eax,%eax
  80099f:	48 01 d0             	add    %rdx,%rax
  8009a2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009a6:	8b 12                	mov    (%rdx),%edx
  8009a8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009ab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009af:	89 0a                	mov    %ecx,(%rdx)
  8009b1:	eb 17                	jmp    8009ca <getint+0xb3>
  8009b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009bb:	48 89 d0             	mov    %rdx,%rax
  8009be:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009c2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009c6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009ca:	48 8b 00             	mov    (%rax),%rax
  8009cd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009d1:	eb 4e                	jmp    800a21 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8009d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d7:	8b 00                	mov    (%rax),%eax
  8009d9:	83 f8 30             	cmp    $0x30,%eax
  8009dc:	73 24                	jae    800a02 <getint+0xeb>
  8009de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009e2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ea:	8b 00                	mov    (%rax),%eax
  8009ec:	89 c0                	mov    %eax,%eax
  8009ee:	48 01 d0             	add    %rdx,%rax
  8009f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009f5:	8b 12                	mov    (%rdx),%edx
  8009f7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009fe:	89 0a                	mov    %ecx,(%rdx)
  800a00:	eb 17                	jmp    800a19 <getint+0x102>
  800a02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a06:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a0a:	48 89 d0             	mov    %rdx,%rax
  800a0d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a11:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a15:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a19:	8b 00                	mov    (%rax),%eax
  800a1b:	48 98                	cltq   
  800a1d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800a21:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800a25:	c9                   	leaveq 
  800a26:	c3                   	retq   

0000000000800a27 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a27:	55                   	push   %rbp
  800a28:	48 89 e5             	mov    %rsp,%rbp
  800a2b:	41 54                	push   %r12
  800a2d:	53                   	push   %rbx
  800a2e:	48 83 ec 60          	sub    $0x60,%rsp
  800a32:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800a36:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800a3a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a3e:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800a42:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a46:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800a4a:	48 8b 0a             	mov    (%rdx),%rcx
  800a4d:	48 89 08             	mov    %rcx,(%rax)
  800a50:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a54:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a58:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a5c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a60:	eb 17                	jmp    800a79 <vprintfmt+0x52>
			if (ch == '\0')
  800a62:	85 db                	test   %ebx,%ebx
  800a64:	0f 84 cc 04 00 00    	je     800f36 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800a6a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a6e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a72:	48 89 d6             	mov    %rdx,%rsi
  800a75:	89 df                	mov    %ebx,%edi
  800a77:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a79:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a7d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a81:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a85:	0f b6 00             	movzbl (%rax),%eax
  800a88:	0f b6 d8             	movzbl %al,%ebx
  800a8b:	83 fb 25             	cmp    $0x25,%ebx
  800a8e:	75 d2                	jne    800a62 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a90:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800a94:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800a9b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800aa2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800aa9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ab0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ab4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ab8:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800abc:	0f b6 00             	movzbl (%rax),%eax
  800abf:	0f b6 d8             	movzbl %al,%ebx
  800ac2:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800ac5:	83 f8 55             	cmp    $0x55,%eax
  800ac8:	0f 87 34 04 00 00    	ja     800f02 <vprintfmt+0x4db>
  800ace:	89 c0                	mov    %eax,%eax
  800ad0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800ad7:	00 
  800ad8:	48 b8 d8 4c 80 00 00 	movabs $0x804cd8,%rax
  800adf:	00 00 00 
  800ae2:	48 01 d0             	add    %rdx,%rax
  800ae5:	48 8b 00             	mov    (%rax),%rax
  800ae8:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800aea:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800aee:	eb c0                	jmp    800ab0 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800af0:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800af4:	eb ba                	jmp    800ab0 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800af6:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800afd:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800b00:	89 d0                	mov    %edx,%eax
  800b02:	c1 e0 02             	shl    $0x2,%eax
  800b05:	01 d0                	add    %edx,%eax
  800b07:	01 c0                	add    %eax,%eax
  800b09:	01 d8                	add    %ebx,%eax
  800b0b:	83 e8 30             	sub    $0x30,%eax
  800b0e:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800b11:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b15:	0f b6 00             	movzbl (%rax),%eax
  800b18:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800b1b:	83 fb 2f             	cmp    $0x2f,%ebx
  800b1e:	7e 0c                	jle    800b2c <vprintfmt+0x105>
  800b20:	83 fb 39             	cmp    $0x39,%ebx
  800b23:	7f 07                	jg     800b2c <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b25:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800b2a:	eb d1                	jmp    800afd <vprintfmt+0xd6>
			goto process_precision;
  800b2c:	eb 58                	jmp    800b86 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800b2e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b31:	83 f8 30             	cmp    $0x30,%eax
  800b34:	73 17                	jae    800b4d <vprintfmt+0x126>
  800b36:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b3a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b3d:	89 c0                	mov    %eax,%eax
  800b3f:	48 01 d0             	add    %rdx,%rax
  800b42:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b45:	83 c2 08             	add    $0x8,%edx
  800b48:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b4b:	eb 0f                	jmp    800b5c <vprintfmt+0x135>
  800b4d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b51:	48 89 d0             	mov    %rdx,%rax
  800b54:	48 83 c2 08          	add    $0x8,%rdx
  800b58:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b5c:	8b 00                	mov    (%rax),%eax
  800b5e:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800b61:	eb 23                	jmp    800b86 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800b63:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b67:	79 0c                	jns    800b75 <vprintfmt+0x14e>
				width = 0;
  800b69:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800b70:	e9 3b ff ff ff       	jmpq   800ab0 <vprintfmt+0x89>
  800b75:	e9 36 ff ff ff       	jmpq   800ab0 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800b7a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800b81:	e9 2a ff ff ff       	jmpq   800ab0 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800b86:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b8a:	79 12                	jns    800b9e <vprintfmt+0x177>
				width = precision, precision = -1;
  800b8c:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b8f:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800b92:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800b99:	e9 12 ff ff ff       	jmpq   800ab0 <vprintfmt+0x89>
  800b9e:	e9 0d ff ff ff       	jmpq   800ab0 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ba3:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800ba7:	e9 04 ff ff ff       	jmpq   800ab0 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800bac:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800baf:	83 f8 30             	cmp    $0x30,%eax
  800bb2:	73 17                	jae    800bcb <vprintfmt+0x1a4>
  800bb4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bb8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bbb:	89 c0                	mov    %eax,%eax
  800bbd:	48 01 d0             	add    %rdx,%rax
  800bc0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bc3:	83 c2 08             	add    $0x8,%edx
  800bc6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bc9:	eb 0f                	jmp    800bda <vprintfmt+0x1b3>
  800bcb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bcf:	48 89 d0             	mov    %rdx,%rax
  800bd2:	48 83 c2 08          	add    $0x8,%rdx
  800bd6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bda:	8b 10                	mov    (%rax),%edx
  800bdc:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800be0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800be4:	48 89 ce             	mov    %rcx,%rsi
  800be7:	89 d7                	mov    %edx,%edi
  800be9:	ff d0                	callq  *%rax
			break;
  800beb:	e9 40 03 00 00       	jmpq   800f30 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800bf0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bf3:	83 f8 30             	cmp    $0x30,%eax
  800bf6:	73 17                	jae    800c0f <vprintfmt+0x1e8>
  800bf8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bfc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bff:	89 c0                	mov    %eax,%eax
  800c01:	48 01 d0             	add    %rdx,%rax
  800c04:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c07:	83 c2 08             	add    $0x8,%edx
  800c0a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c0d:	eb 0f                	jmp    800c1e <vprintfmt+0x1f7>
  800c0f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c13:	48 89 d0             	mov    %rdx,%rax
  800c16:	48 83 c2 08          	add    $0x8,%rdx
  800c1a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c1e:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800c20:	85 db                	test   %ebx,%ebx
  800c22:	79 02                	jns    800c26 <vprintfmt+0x1ff>
				err = -err;
  800c24:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800c26:	83 fb 15             	cmp    $0x15,%ebx
  800c29:	7f 16                	jg     800c41 <vprintfmt+0x21a>
  800c2b:	48 b8 00 4c 80 00 00 	movabs $0x804c00,%rax
  800c32:	00 00 00 
  800c35:	48 63 d3             	movslq %ebx,%rdx
  800c38:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800c3c:	4d 85 e4             	test   %r12,%r12
  800c3f:	75 2e                	jne    800c6f <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800c41:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c45:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c49:	89 d9                	mov    %ebx,%ecx
  800c4b:	48 ba c1 4c 80 00 00 	movabs $0x804cc1,%rdx
  800c52:	00 00 00 
  800c55:	48 89 c7             	mov    %rax,%rdi
  800c58:	b8 00 00 00 00       	mov    $0x0,%eax
  800c5d:	49 b8 3f 0f 80 00 00 	movabs $0x800f3f,%r8
  800c64:	00 00 00 
  800c67:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c6a:	e9 c1 02 00 00       	jmpq   800f30 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c6f:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c73:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c77:	4c 89 e1             	mov    %r12,%rcx
  800c7a:	48 ba ca 4c 80 00 00 	movabs $0x804cca,%rdx
  800c81:	00 00 00 
  800c84:	48 89 c7             	mov    %rax,%rdi
  800c87:	b8 00 00 00 00       	mov    $0x0,%eax
  800c8c:	49 b8 3f 0f 80 00 00 	movabs $0x800f3f,%r8
  800c93:	00 00 00 
  800c96:	41 ff d0             	callq  *%r8
			break;
  800c99:	e9 92 02 00 00       	jmpq   800f30 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800c9e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ca1:	83 f8 30             	cmp    $0x30,%eax
  800ca4:	73 17                	jae    800cbd <vprintfmt+0x296>
  800ca6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800caa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cad:	89 c0                	mov    %eax,%eax
  800caf:	48 01 d0             	add    %rdx,%rax
  800cb2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cb5:	83 c2 08             	add    $0x8,%edx
  800cb8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cbb:	eb 0f                	jmp    800ccc <vprintfmt+0x2a5>
  800cbd:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cc1:	48 89 d0             	mov    %rdx,%rax
  800cc4:	48 83 c2 08          	add    $0x8,%rdx
  800cc8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ccc:	4c 8b 20             	mov    (%rax),%r12
  800ccf:	4d 85 e4             	test   %r12,%r12
  800cd2:	75 0a                	jne    800cde <vprintfmt+0x2b7>
				p = "(null)";
  800cd4:	49 bc cd 4c 80 00 00 	movabs $0x804ccd,%r12
  800cdb:	00 00 00 
			if (width > 0 && padc != '-')
  800cde:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ce2:	7e 3f                	jle    800d23 <vprintfmt+0x2fc>
  800ce4:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800ce8:	74 39                	je     800d23 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800cea:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ced:	48 98                	cltq   
  800cef:	48 89 c6             	mov    %rax,%rsi
  800cf2:	4c 89 e7             	mov    %r12,%rdi
  800cf5:	48 b8 eb 11 80 00 00 	movabs $0x8011eb,%rax
  800cfc:	00 00 00 
  800cff:	ff d0                	callq  *%rax
  800d01:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800d04:	eb 17                	jmp    800d1d <vprintfmt+0x2f6>
					putch(padc, putdat);
  800d06:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800d0a:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800d0e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d12:	48 89 ce             	mov    %rcx,%rsi
  800d15:	89 d7                	mov    %edx,%edi
  800d17:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d19:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d1d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d21:	7f e3                	jg     800d06 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d23:	eb 37                	jmp    800d5c <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800d25:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800d29:	74 1e                	je     800d49 <vprintfmt+0x322>
  800d2b:	83 fb 1f             	cmp    $0x1f,%ebx
  800d2e:	7e 05                	jle    800d35 <vprintfmt+0x30e>
  800d30:	83 fb 7e             	cmp    $0x7e,%ebx
  800d33:	7e 14                	jle    800d49 <vprintfmt+0x322>
					putch('?', putdat);
  800d35:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d39:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d3d:	48 89 d6             	mov    %rdx,%rsi
  800d40:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800d45:	ff d0                	callq  *%rax
  800d47:	eb 0f                	jmp    800d58 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800d49:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d4d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d51:	48 89 d6             	mov    %rdx,%rsi
  800d54:	89 df                	mov    %ebx,%edi
  800d56:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d58:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d5c:	4c 89 e0             	mov    %r12,%rax
  800d5f:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800d63:	0f b6 00             	movzbl (%rax),%eax
  800d66:	0f be d8             	movsbl %al,%ebx
  800d69:	85 db                	test   %ebx,%ebx
  800d6b:	74 10                	je     800d7d <vprintfmt+0x356>
  800d6d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d71:	78 b2                	js     800d25 <vprintfmt+0x2fe>
  800d73:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800d77:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d7b:	79 a8                	jns    800d25 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d7d:	eb 16                	jmp    800d95 <vprintfmt+0x36e>
				putch(' ', putdat);
  800d7f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d83:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d87:	48 89 d6             	mov    %rdx,%rsi
  800d8a:	bf 20 00 00 00       	mov    $0x20,%edi
  800d8f:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d91:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d95:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d99:	7f e4                	jg     800d7f <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800d9b:	e9 90 01 00 00       	jmpq   800f30 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800da0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800da4:	be 03 00 00 00       	mov    $0x3,%esi
  800da9:	48 89 c7             	mov    %rax,%rdi
  800dac:	48 b8 17 09 80 00 00 	movabs $0x800917,%rax
  800db3:	00 00 00 
  800db6:	ff d0                	callq  *%rax
  800db8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800dbc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dc0:	48 85 c0             	test   %rax,%rax
  800dc3:	79 1d                	jns    800de2 <vprintfmt+0x3bb>
				putch('-', putdat);
  800dc5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dc9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dcd:	48 89 d6             	mov    %rdx,%rsi
  800dd0:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800dd5:	ff d0                	callq  *%rax
				num = -(long long) num;
  800dd7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ddb:	48 f7 d8             	neg    %rax
  800dde:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800de2:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800de9:	e9 d5 00 00 00       	jmpq   800ec3 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800dee:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800df2:	be 03 00 00 00       	mov    $0x3,%esi
  800df7:	48 89 c7             	mov    %rax,%rdi
  800dfa:	48 b8 07 08 80 00 00 	movabs $0x800807,%rax
  800e01:	00 00 00 
  800e04:	ff d0                	callq  *%rax
  800e06:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800e0a:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800e11:	e9 ad 00 00 00       	jmpq   800ec3 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800e16:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800e19:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e1d:	89 d6                	mov    %edx,%esi
  800e1f:	48 89 c7             	mov    %rax,%rdi
  800e22:	48 b8 17 09 80 00 00 	movabs $0x800917,%rax
  800e29:	00 00 00 
  800e2c:	ff d0                	callq  *%rax
  800e2e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800e32:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800e39:	e9 85 00 00 00       	jmpq   800ec3 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800e3e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e42:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e46:	48 89 d6             	mov    %rdx,%rsi
  800e49:	bf 30 00 00 00       	mov    $0x30,%edi
  800e4e:	ff d0                	callq  *%rax
			putch('x', putdat);
  800e50:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e54:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e58:	48 89 d6             	mov    %rdx,%rsi
  800e5b:	bf 78 00 00 00       	mov    $0x78,%edi
  800e60:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800e62:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e65:	83 f8 30             	cmp    $0x30,%eax
  800e68:	73 17                	jae    800e81 <vprintfmt+0x45a>
  800e6a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e6e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e71:	89 c0                	mov    %eax,%eax
  800e73:	48 01 d0             	add    %rdx,%rax
  800e76:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e79:	83 c2 08             	add    $0x8,%edx
  800e7c:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e7f:	eb 0f                	jmp    800e90 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800e81:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e85:	48 89 d0             	mov    %rdx,%rax
  800e88:	48 83 c2 08          	add    $0x8,%rdx
  800e8c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e90:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e93:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800e97:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800e9e:	eb 23                	jmp    800ec3 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800ea0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ea4:	be 03 00 00 00       	mov    $0x3,%esi
  800ea9:	48 89 c7             	mov    %rax,%rdi
  800eac:	48 b8 07 08 80 00 00 	movabs $0x800807,%rax
  800eb3:	00 00 00 
  800eb6:	ff d0                	callq  *%rax
  800eb8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800ebc:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ec3:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800ec8:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800ecb:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800ece:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ed2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ed6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eda:	45 89 c1             	mov    %r8d,%r9d
  800edd:	41 89 f8             	mov    %edi,%r8d
  800ee0:	48 89 c7             	mov    %rax,%rdi
  800ee3:	48 b8 4c 07 80 00 00 	movabs $0x80074c,%rax
  800eea:	00 00 00 
  800eed:	ff d0                	callq  *%rax
			break;
  800eef:	eb 3f                	jmp    800f30 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ef1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ef5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ef9:	48 89 d6             	mov    %rdx,%rsi
  800efc:	89 df                	mov    %ebx,%edi
  800efe:	ff d0                	callq  *%rax
			break;
  800f00:	eb 2e                	jmp    800f30 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f02:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f06:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f0a:	48 89 d6             	mov    %rdx,%rsi
  800f0d:	bf 25 00 00 00       	mov    $0x25,%edi
  800f12:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f14:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f19:	eb 05                	jmp    800f20 <vprintfmt+0x4f9>
  800f1b:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f20:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f24:	48 83 e8 01          	sub    $0x1,%rax
  800f28:	0f b6 00             	movzbl (%rax),%eax
  800f2b:	3c 25                	cmp    $0x25,%al
  800f2d:	75 ec                	jne    800f1b <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800f2f:	90                   	nop
		}
	}
  800f30:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f31:	e9 43 fb ff ff       	jmpq   800a79 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800f36:	48 83 c4 60          	add    $0x60,%rsp
  800f3a:	5b                   	pop    %rbx
  800f3b:	41 5c                	pop    %r12
  800f3d:	5d                   	pop    %rbp
  800f3e:	c3                   	retq   

0000000000800f3f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f3f:	55                   	push   %rbp
  800f40:	48 89 e5             	mov    %rsp,%rbp
  800f43:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800f4a:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800f51:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800f58:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f5f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f66:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f6d:	84 c0                	test   %al,%al
  800f6f:	74 20                	je     800f91 <printfmt+0x52>
  800f71:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f75:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f79:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f7d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f81:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f85:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f89:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f8d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f91:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800f98:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800f9f:	00 00 00 
  800fa2:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800fa9:	00 00 00 
  800fac:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fb0:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800fb7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fbe:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800fc5:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800fcc:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800fd3:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800fda:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800fe1:	48 89 c7             	mov    %rax,%rdi
  800fe4:	48 b8 27 0a 80 00 00 	movabs $0x800a27,%rax
  800feb:	00 00 00 
  800fee:	ff d0                	callq  *%rax
	va_end(ap);
}
  800ff0:	c9                   	leaveq 
  800ff1:	c3                   	retq   

0000000000800ff2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ff2:	55                   	push   %rbp
  800ff3:	48 89 e5             	mov    %rsp,%rbp
  800ff6:	48 83 ec 10          	sub    $0x10,%rsp
  800ffa:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ffd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801001:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801005:	8b 40 10             	mov    0x10(%rax),%eax
  801008:	8d 50 01             	lea    0x1(%rax),%edx
  80100b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80100f:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801012:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801016:	48 8b 10             	mov    (%rax),%rdx
  801019:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80101d:	48 8b 40 08          	mov    0x8(%rax),%rax
  801021:	48 39 c2             	cmp    %rax,%rdx
  801024:	73 17                	jae    80103d <sprintputch+0x4b>
		*b->buf++ = ch;
  801026:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80102a:	48 8b 00             	mov    (%rax),%rax
  80102d:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801031:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801035:	48 89 0a             	mov    %rcx,(%rdx)
  801038:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80103b:	88 10                	mov    %dl,(%rax)
}
  80103d:	c9                   	leaveq 
  80103e:	c3                   	retq   

000000000080103f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80103f:	55                   	push   %rbp
  801040:	48 89 e5             	mov    %rsp,%rbp
  801043:	48 83 ec 50          	sub    $0x50,%rsp
  801047:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80104b:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80104e:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801052:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801056:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80105a:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80105e:	48 8b 0a             	mov    (%rdx),%rcx
  801061:	48 89 08             	mov    %rcx,(%rax)
  801064:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801068:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80106c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801070:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801074:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801078:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80107c:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80107f:	48 98                	cltq   
  801081:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801085:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801089:	48 01 d0             	add    %rdx,%rax
  80108c:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801090:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801097:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80109c:	74 06                	je     8010a4 <vsnprintf+0x65>
  80109e:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8010a2:	7f 07                	jg     8010ab <vsnprintf+0x6c>
		return -E_INVAL;
  8010a4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010a9:	eb 2f                	jmp    8010da <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8010ab:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8010af:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8010b3:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8010b7:	48 89 c6             	mov    %rax,%rsi
  8010ba:	48 bf f2 0f 80 00 00 	movabs $0x800ff2,%rdi
  8010c1:	00 00 00 
  8010c4:	48 b8 27 0a 80 00 00 	movabs $0x800a27,%rax
  8010cb:	00 00 00 
  8010ce:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8010d0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8010d4:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8010d7:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8010da:	c9                   	leaveq 
  8010db:	c3                   	retq   

00000000008010dc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010dc:	55                   	push   %rbp
  8010dd:	48 89 e5             	mov    %rsp,%rbp
  8010e0:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8010e7:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8010ee:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8010f4:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8010fb:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801102:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801109:	84 c0                	test   %al,%al
  80110b:	74 20                	je     80112d <snprintf+0x51>
  80110d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801111:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801115:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801119:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80111d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801121:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801125:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801129:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80112d:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801134:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80113b:	00 00 00 
  80113e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801145:	00 00 00 
  801148:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80114c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801153:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80115a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801161:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801168:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80116f:	48 8b 0a             	mov    (%rdx),%rcx
  801172:	48 89 08             	mov    %rcx,(%rax)
  801175:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801179:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80117d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801181:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801185:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80118c:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801193:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801199:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8011a0:	48 89 c7             	mov    %rax,%rdi
  8011a3:	48 b8 3f 10 80 00 00 	movabs $0x80103f,%rax
  8011aa:	00 00 00 
  8011ad:	ff d0                	callq  *%rax
  8011af:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8011b5:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8011bb:	c9                   	leaveq 
  8011bc:	c3                   	retq   

00000000008011bd <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8011bd:	55                   	push   %rbp
  8011be:	48 89 e5             	mov    %rsp,%rbp
  8011c1:	48 83 ec 18          	sub    $0x18,%rsp
  8011c5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8011c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011d0:	eb 09                	jmp    8011db <strlen+0x1e>
		n++;
  8011d2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8011d6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011df:	0f b6 00             	movzbl (%rax),%eax
  8011e2:	84 c0                	test   %al,%al
  8011e4:	75 ec                	jne    8011d2 <strlen+0x15>
		n++;
	return n;
  8011e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011e9:	c9                   	leaveq 
  8011ea:	c3                   	retq   

00000000008011eb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8011eb:	55                   	push   %rbp
  8011ec:	48 89 e5             	mov    %rsp,%rbp
  8011ef:	48 83 ec 20          	sub    $0x20,%rsp
  8011f3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011f7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011fb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801202:	eb 0e                	jmp    801212 <strnlen+0x27>
		n++;
  801204:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801208:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80120d:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801212:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801217:	74 0b                	je     801224 <strnlen+0x39>
  801219:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80121d:	0f b6 00             	movzbl (%rax),%eax
  801220:	84 c0                	test   %al,%al
  801222:	75 e0                	jne    801204 <strnlen+0x19>
		n++;
	return n;
  801224:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801227:	c9                   	leaveq 
  801228:	c3                   	retq   

0000000000801229 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801229:	55                   	push   %rbp
  80122a:	48 89 e5             	mov    %rsp,%rbp
  80122d:	48 83 ec 20          	sub    $0x20,%rsp
  801231:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801235:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801239:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80123d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801241:	90                   	nop
  801242:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801246:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80124a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80124e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801252:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801256:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80125a:	0f b6 12             	movzbl (%rdx),%edx
  80125d:	88 10                	mov    %dl,(%rax)
  80125f:	0f b6 00             	movzbl (%rax),%eax
  801262:	84 c0                	test   %al,%al
  801264:	75 dc                	jne    801242 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801266:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80126a:	c9                   	leaveq 
  80126b:	c3                   	retq   

000000000080126c <strcat>:

char *
strcat(char *dst, const char *src)
{
  80126c:	55                   	push   %rbp
  80126d:	48 89 e5             	mov    %rsp,%rbp
  801270:	48 83 ec 20          	sub    $0x20,%rsp
  801274:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801278:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80127c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801280:	48 89 c7             	mov    %rax,%rdi
  801283:	48 b8 bd 11 80 00 00 	movabs $0x8011bd,%rax
  80128a:	00 00 00 
  80128d:	ff d0                	callq  *%rax
  80128f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801292:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801295:	48 63 d0             	movslq %eax,%rdx
  801298:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80129c:	48 01 c2             	add    %rax,%rdx
  80129f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012a3:	48 89 c6             	mov    %rax,%rsi
  8012a6:	48 89 d7             	mov    %rdx,%rdi
  8012a9:	48 b8 29 12 80 00 00 	movabs $0x801229,%rax
  8012b0:	00 00 00 
  8012b3:	ff d0                	callq  *%rax
	return dst;
  8012b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8012b9:	c9                   	leaveq 
  8012ba:	c3                   	retq   

00000000008012bb <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8012bb:	55                   	push   %rbp
  8012bc:	48 89 e5             	mov    %rsp,%rbp
  8012bf:	48 83 ec 28          	sub    $0x28,%rsp
  8012c3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012c7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012cb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8012cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012d3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8012d7:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8012de:	00 
  8012df:	eb 2a                	jmp    80130b <strncpy+0x50>
		*dst++ = *src;
  8012e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012e5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012e9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012ed:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012f1:	0f b6 12             	movzbl (%rdx),%edx
  8012f4:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012f6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012fa:	0f b6 00             	movzbl (%rax),%eax
  8012fd:	84 c0                	test   %al,%al
  8012ff:	74 05                	je     801306 <strncpy+0x4b>
			src++;
  801301:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801306:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80130b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80130f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801313:	72 cc                	jb     8012e1 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801315:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801319:	c9                   	leaveq 
  80131a:	c3                   	retq   

000000000080131b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80131b:	55                   	push   %rbp
  80131c:	48 89 e5             	mov    %rsp,%rbp
  80131f:	48 83 ec 28          	sub    $0x28,%rsp
  801323:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801327:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80132b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80132f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801333:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801337:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80133c:	74 3d                	je     80137b <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80133e:	eb 1d                	jmp    80135d <strlcpy+0x42>
			*dst++ = *src++;
  801340:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801344:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801348:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80134c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801350:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801354:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801358:	0f b6 12             	movzbl (%rdx),%edx
  80135b:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80135d:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801362:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801367:	74 0b                	je     801374 <strlcpy+0x59>
  801369:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80136d:	0f b6 00             	movzbl (%rax),%eax
  801370:	84 c0                	test   %al,%al
  801372:	75 cc                	jne    801340 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801374:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801378:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80137b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80137f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801383:	48 29 c2             	sub    %rax,%rdx
  801386:	48 89 d0             	mov    %rdx,%rax
}
  801389:	c9                   	leaveq 
  80138a:	c3                   	retq   

000000000080138b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80138b:	55                   	push   %rbp
  80138c:	48 89 e5             	mov    %rsp,%rbp
  80138f:	48 83 ec 10          	sub    $0x10,%rsp
  801393:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801397:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80139b:	eb 0a                	jmp    8013a7 <strcmp+0x1c>
		p++, q++;
  80139d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013a2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ab:	0f b6 00             	movzbl (%rax),%eax
  8013ae:	84 c0                	test   %al,%al
  8013b0:	74 12                	je     8013c4 <strcmp+0x39>
  8013b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b6:	0f b6 10             	movzbl (%rax),%edx
  8013b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013bd:	0f b6 00             	movzbl (%rax),%eax
  8013c0:	38 c2                	cmp    %al,%dl
  8013c2:	74 d9                	je     80139d <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c8:	0f b6 00             	movzbl (%rax),%eax
  8013cb:	0f b6 d0             	movzbl %al,%edx
  8013ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013d2:	0f b6 00             	movzbl (%rax),%eax
  8013d5:	0f b6 c0             	movzbl %al,%eax
  8013d8:	29 c2                	sub    %eax,%edx
  8013da:	89 d0                	mov    %edx,%eax
}
  8013dc:	c9                   	leaveq 
  8013dd:	c3                   	retq   

00000000008013de <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8013de:	55                   	push   %rbp
  8013df:	48 89 e5             	mov    %rsp,%rbp
  8013e2:	48 83 ec 18          	sub    $0x18,%rsp
  8013e6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013ea:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013ee:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8013f2:	eb 0f                	jmp    801403 <strncmp+0x25>
		n--, p++, q++;
  8013f4:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8013f9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013fe:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801403:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801408:	74 1d                	je     801427 <strncmp+0x49>
  80140a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80140e:	0f b6 00             	movzbl (%rax),%eax
  801411:	84 c0                	test   %al,%al
  801413:	74 12                	je     801427 <strncmp+0x49>
  801415:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801419:	0f b6 10             	movzbl (%rax),%edx
  80141c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801420:	0f b6 00             	movzbl (%rax),%eax
  801423:	38 c2                	cmp    %al,%dl
  801425:	74 cd                	je     8013f4 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801427:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80142c:	75 07                	jne    801435 <strncmp+0x57>
		return 0;
  80142e:	b8 00 00 00 00       	mov    $0x0,%eax
  801433:	eb 18                	jmp    80144d <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801435:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801439:	0f b6 00             	movzbl (%rax),%eax
  80143c:	0f b6 d0             	movzbl %al,%edx
  80143f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801443:	0f b6 00             	movzbl (%rax),%eax
  801446:	0f b6 c0             	movzbl %al,%eax
  801449:	29 c2                	sub    %eax,%edx
  80144b:	89 d0                	mov    %edx,%eax
}
  80144d:	c9                   	leaveq 
  80144e:	c3                   	retq   

000000000080144f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80144f:	55                   	push   %rbp
  801450:	48 89 e5             	mov    %rsp,%rbp
  801453:	48 83 ec 0c          	sub    $0xc,%rsp
  801457:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80145b:	89 f0                	mov    %esi,%eax
  80145d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801460:	eb 17                	jmp    801479 <strchr+0x2a>
		if (*s == c)
  801462:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801466:	0f b6 00             	movzbl (%rax),%eax
  801469:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80146c:	75 06                	jne    801474 <strchr+0x25>
			return (char *) s;
  80146e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801472:	eb 15                	jmp    801489 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801474:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801479:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80147d:	0f b6 00             	movzbl (%rax),%eax
  801480:	84 c0                	test   %al,%al
  801482:	75 de                	jne    801462 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801484:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801489:	c9                   	leaveq 
  80148a:	c3                   	retq   

000000000080148b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80148b:	55                   	push   %rbp
  80148c:	48 89 e5             	mov    %rsp,%rbp
  80148f:	48 83 ec 0c          	sub    $0xc,%rsp
  801493:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801497:	89 f0                	mov    %esi,%eax
  801499:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80149c:	eb 13                	jmp    8014b1 <strfind+0x26>
		if (*s == c)
  80149e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014a2:	0f b6 00             	movzbl (%rax),%eax
  8014a5:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8014a8:	75 02                	jne    8014ac <strfind+0x21>
			break;
  8014aa:	eb 10                	jmp    8014bc <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014ac:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b5:	0f b6 00             	movzbl (%rax),%eax
  8014b8:	84 c0                	test   %al,%al
  8014ba:	75 e2                	jne    80149e <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8014bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014c0:	c9                   	leaveq 
  8014c1:	c3                   	retq   

00000000008014c2 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8014c2:	55                   	push   %rbp
  8014c3:	48 89 e5             	mov    %rsp,%rbp
  8014c6:	48 83 ec 18          	sub    $0x18,%rsp
  8014ca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014ce:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8014d1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8014d5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014da:	75 06                	jne    8014e2 <memset+0x20>
		return v;
  8014dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014e0:	eb 69                	jmp    80154b <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8014e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014e6:	83 e0 03             	and    $0x3,%eax
  8014e9:	48 85 c0             	test   %rax,%rax
  8014ec:	75 48                	jne    801536 <memset+0x74>
  8014ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014f2:	83 e0 03             	and    $0x3,%eax
  8014f5:	48 85 c0             	test   %rax,%rax
  8014f8:	75 3c                	jne    801536 <memset+0x74>
		c &= 0xFF;
  8014fa:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801501:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801504:	c1 e0 18             	shl    $0x18,%eax
  801507:	89 c2                	mov    %eax,%edx
  801509:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80150c:	c1 e0 10             	shl    $0x10,%eax
  80150f:	09 c2                	or     %eax,%edx
  801511:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801514:	c1 e0 08             	shl    $0x8,%eax
  801517:	09 d0                	or     %edx,%eax
  801519:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80151c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801520:	48 c1 e8 02          	shr    $0x2,%rax
  801524:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801527:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80152b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80152e:	48 89 d7             	mov    %rdx,%rdi
  801531:	fc                   	cld    
  801532:	f3 ab                	rep stos %eax,%es:(%rdi)
  801534:	eb 11                	jmp    801547 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801536:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80153a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80153d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801541:	48 89 d7             	mov    %rdx,%rdi
  801544:	fc                   	cld    
  801545:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801547:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80154b:	c9                   	leaveq 
  80154c:	c3                   	retq   

000000000080154d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80154d:	55                   	push   %rbp
  80154e:	48 89 e5             	mov    %rsp,%rbp
  801551:	48 83 ec 28          	sub    $0x28,%rsp
  801555:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801559:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80155d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801561:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801565:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801569:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80156d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801571:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801575:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801579:	0f 83 88 00 00 00    	jae    801607 <memmove+0xba>
  80157f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801583:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801587:	48 01 d0             	add    %rdx,%rax
  80158a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80158e:	76 77                	jbe    801607 <memmove+0xba>
		s += n;
  801590:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801594:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801598:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80159c:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8015a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015a4:	83 e0 03             	and    $0x3,%eax
  8015a7:	48 85 c0             	test   %rax,%rax
  8015aa:	75 3b                	jne    8015e7 <memmove+0x9a>
  8015ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015b0:	83 e0 03             	and    $0x3,%eax
  8015b3:	48 85 c0             	test   %rax,%rax
  8015b6:	75 2f                	jne    8015e7 <memmove+0x9a>
  8015b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015bc:	83 e0 03             	and    $0x3,%eax
  8015bf:	48 85 c0             	test   %rax,%rax
  8015c2:	75 23                	jne    8015e7 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8015c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015c8:	48 83 e8 04          	sub    $0x4,%rax
  8015cc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015d0:	48 83 ea 04          	sub    $0x4,%rdx
  8015d4:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015d8:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8015dc:	48 89 c7             	mov    %rax,%rdi
  8015df:	48 89 d6             	mov    %rdx,%rsi
  8015e2:	fd                   	std    
  8015e3:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015e5:	eb 1d                	jmp    801604 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8015e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015eb:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015f3:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8015f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015fb:	48 89 d7             	mov    %rdx,%rdi
  8015fe:	48 89 c1             	mov    %rax,%rcx
  801601:	fd                   	std    
  801602:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801604:	fc                   	cld    
  801605:	eb 57                	jmp    80165e <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801607:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80160b:	83 e0 03             	and    $0x3,%eax
  80160e:	48 85 c0             	test   %rax,%rax
  801611:	75 36                	jne    801649 <memmove+0xfc>
  801613:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801617:	83 e0 03             	and    $0x3,%eax
  80161a:	48 85 c0             	test   %rax,%rax
  80161d:	75 2a                	jne    801649 <memmove+0xfc>
  80161f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801623:	83 e0 03             	and    $0x3,%eax
  801626:	48 85 c0             	test   %rax,%rax
  801629:	75 1e                	jne    801649 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80162b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80162f:	48 c1 e8 02          	shr    $0x2,%rax
  801633:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801636:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80163a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80163e:	48 89 c7             	mov    %rax,%rdi
  801641:	48 89 d6             	mov    %rdx,%rsi
  801644:	fc                   	cld    
  801645:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801647:	eb 15                	jmp    80165e <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801649:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80164d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801651:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801655:	48 89 c7             	mov    %rax,%rdi
  801658:	48 89 d6             	mov    %rdx,%rsi
  80165b:	fc                   	cld    
  80165c:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80165e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801662:	c9                   	leaveq 
  801663:	c3                   	retq   

0000000000801664 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801664:	55                   	push   %rbp
  801665:	48 89 e5             	mov    %rsp,%rbp
  801668:	48 83 ec 18          	sub    $0x18,%rsp
  80166c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801670:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801674:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801678:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80167c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801680:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801684:	48 89 ce             	mov    %rcx,%rsi
  801687:	48 89 c7             	mov    %rax,%rdi
  80168a:	48 b8 4d 15 80 00 00 	movabs $0x80154d,%rax
  801691:	00 00 00 
  801694:	ff d0                	callq  *%rax
}
  801696:	c9                   	leaveq 
  801697:	c3                   	retq   

0000000000801698 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801698:	55                   	push   %rbp
  801699:	48 89 e5             	mov    %rsp,%rbp
  80169c:	48 83 ec 28          	sub    $0x28,%rsp
  8016a0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016a4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8016a8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8016ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016b0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8016b4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016b8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8016bc:	eb 36                	jmp    8016f4 <memcmp+0x5c>
		if (*s1 != *s2)
  8016be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016c2:	0f b6 10             	movzbl (%rax),%edx
  8016c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016c9:	0f b6 00             	movzbl (%rax),%eax
  8016cc:	38 c2                	cmp    %al,%dl
  8016ce:	74 1a                	je     8016ea <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8016d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016d4:	0f b6 00             	movzbl (%rax),%eax
  8016d7:	0f b6 d0             	movzbl %al,%edx
  8016da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016de:	0f b6 00             	movzbl (%rax),%eax
  8016e1:	0f b6 c0             	movzbl %al,%eax
  8016e4:	29 c2                	sub    %eax,%edx
  8016e6:	89 d0                	mov    %edx,%eax
  8016e8:	eb 20                	jmp    80170a <memcmp+0x72>
		s1++, s2++;
  8016ea:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016ef:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8016f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f8:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016fc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801700:	48 85 c0             	test   %rax,%rax
  801703:	75 b9                	jne    8016be <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801705:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80170a:	c9                   	leaveq 
  80170b:	c3                   	retq   

000000000080170c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80170c:	55                   	push   %rbp
  80170d:	48 89 e5             	mov    %rsp,%rbp
  801710:	48 83 ec 28          	sub    $0x28,%rsp
  801714:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801718:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80171b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80171f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801723:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801727:	48 01 d0             	add    %rdx,%rax
  80172a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80172e:	eb 15                	jmp    801745 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801730:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801734:	0f b6 10             	movzbl (%rax),%edx
  801737:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80173a:	38 c2                	cmp    %al,%dl
  80173c:	75 02                	jne    801740 <memfind+0x34>
			break;
  80173e:	eb 0f                	jmp    80174f <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801740:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801745:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801749:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80174d:	72 e1                	jb     801730 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80174f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801753:	c9                   	leaveq 
  801754:	c3                   	retq   

0000000000801755 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801755:	55                   	push   %rbp
  801756:	48 89 e5             	mov    %rsp,%rbp
  801759:	48 83 ec 34          	sub    $0x34,%rsp
  80175d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801761:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801765:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801768:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80176f:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801776:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801777:	eb 05                	jmp    80177e <strtol+0x29>
		s++;
  801779:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80177e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801782:	0f b6 00             	movzbl (%rax),%eax
  801785:	3c 20                	cmp    $0x20,%al
  801787:	74 f0                	je     801779 <strtol+0x24>
  801789:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80178d:	0f b6 00             	movzbl (%rax),%eax
  801790:	3c 09                	cmp    $0x9,%al
  801792:	74 e5                	je     801779 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801794:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801798:	0f b6 00             	movzbl (%rax),%eax
  80179b:	3c 2b                	cmp    $0x2b,%al
  80179d:	75 07                	jne    8017a6 <strtol+0x51>
		s++;
  80179f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017a4:	eb 17                	jmp    8017bd <strtol+0x68>
	else if (*s == '-')
  8017a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017aa:	0f b6 00             	movzbl (%rax),%eax
  8017ad:	3c 2d                	cmp    $0x2d,%al
  8017af:	75 0c                	jne    8017bd <strtol+0x68>
		s++, neg = 1;
  8017b1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017b6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017bd:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017c1:	74 06                	je     8017c9 <strtol+0x74>
  8017c3:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8017c7:	75 28                	jne    8017f1 <strtol+0x9c>
  8017c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017cd:	0f b6 00             	movzbl (%rax),%eax
  8017d0:	3c 30                	cmp    $0x30,%al
  8017d2:	75 1d                	jne    8017f1 <strtol+0x9c>
  8017d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d8:	48 83 c0 01          	add    $0x1,%rax
  8017dc:	0f b6 00             	movzbl (%rax),%eax
  8017df:	3c 78                	cmp    $0x78,%al
  8017e1:	75 0e                	jne    8017f1 <strtol+0x9c>
		s += 2, base = 16;
  8017e3:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8017e8:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8017ef:	eb 2c                	jmp    80181d <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8017f1:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017f5:	75 19                	jne    801810 <strtol+0xbb>
  8017f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017fb:	0f b6 00             	movzbl (%rax),%eax
  8017fe:	3c 30                	cmp    $0x30,%al
  801800:	75 0e                	jne    801810 <strtol+0xbb>
		s++, base = 8;
  801802:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801807:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80180e:	eb 0d                	jmp    80181d <strtol+0xc8>
	else if (base == 0)
  801810:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801814:	75 07                	jne    80181d <strtol+0xc8>
		base = 10;
  801816:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80181d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801821:	0f b6 00             	movzbl (%rax),%eax
  801824:	3c 2f                	cmp    $0x2f,%al
  801826:	7e 1d                	jle    801845 <strtol+0xf0>
  801828:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80182c:	0f b6 00             	movzbl (%rax),%eax
  80182f:	3c 39                	cmp    $0x39,%al
  801831:	7f 12                	jg     801845 <strtol+0xf0>
			dig = *s - '0';
  801833:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801837:	0f b6 00             	movzbl (%rax),%eax
  80183a:	0f be c0             	movsbl %al,%eax
  80183d:	83 e8 30             	sub    $0x30,%eax
  801840:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801843:	eb 4e                	jmp    801893 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801845:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801849:	0f b6 00             	movzbl (%rax),%eax
  80184c:	3c 60                	cmp    $0x60,%al
  80184e:	7e 1d                	jle    80186d <strtol+0x118>
  801850:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801854:	0f b6 00             	movzbl (%rax),%eax
  801857:	3c 7a                	cmp    $0x7a,%al
  801859:	7f 12                	jg     80186d <strtol+0x118>
			dig = *s - 'a' + 10;
  80185b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80185f:	0f b6 00             	movzbl (%rax),%eax
  801862:	0f be c0             	movsbl %al,%eax
  801865:	83 e8 57             	sub    $0x57,%eax
  801868:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80186b:	eb 26                	jmp    801893 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80186d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801871:	0f b6 00             	movzbl (%rax),%eax
  801874:	3c 40                	cmp    $0x40,%al
  801876:	7e 48                	jle    8018c0 <strtol+0x16b>
  801878:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80187c:	0f b6 00             	movzbl (%rax),%eax
  80187f:	3c 5a                	cmp    $0x5a,%al
  801881:	7f 3d                	jg     8018c0 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801883:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801887:	0f b6 00             	movzbl (%rax),%eax
  80188a:	0f be c0             	movsbl %al,%eax
  80188d:	83 e8 37             	sub    $0x37,%eax
  801890:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801893:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801896:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801899:	7c 02                	jl     80189d <strtol+0x148>
			break;
  80189b:	eb 23                	jmp    8018c0 <strtol+0x16b>
		s++, val = (val * base) + dig;
  80189d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018a2:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8018a5:	48 98                	cltq   
  8018a7:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8018ac:	48 89 c2             	mov    %rax,%rdx
  8018af:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8018b2:	48 98                	cltq   
  8018b4:	48 01 d0             	add    %rdx,%rax
  8018b7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8018bb:	e9 5d ff ff ff       	jmpq   80181d <strtol+0xc8>

	if (endptr)
  8018c0:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8018c5:	74 0b                	je     8018d2 <strtol+0x17d>
		*endptr = (char *) s;
  8018c7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018cb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8018cf:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8018d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8018d6:	74 09                	je     8018e1 <strtol+0x18c>
  8018d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018dc:	48 f7 d8             	neg    %rax
  8018df:	eb 04                	jmp    8018e5 <strtol+0x190>
  8018e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8018e5:	c9                   	leaveq 
  8018e6:	c3                   	retq   

00000000008018e7 <strstr>:

char * strstr(const char *in, const char *str)
{
  8018e7:	55                   	push   %rbp
  8018e8:	48 89 e5             	mov    %rsp,%rbp
  8018eb:	48 83 ec 30          	sub    $0x30,%rsp
  8018ef:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018f3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8018f7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018fb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018ff:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801903:	0f b6 00             	movzbl (%rax),%eax
  801906:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801909:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80190d:	75 06                	jne    801915 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80190f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801913:	eb 6b                	jmp    801980 <strstr+0x99>

	len = strlen(str);
  801915:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801919:	48 89 c7             	mov    %rax,%rdi
  80191c:	48 b8 bd 11 80 00 00 	movabs $0x8011bd,%rax
  801923:	00 00 00 
  801926:	ff d0                	callq  *%rax
  801928:	48 98                	cltq   
  80192a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80192e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801932:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801936:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80193a:	0f b6 00             	movzbl (%rax),%eax
  80193d:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801940:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801944:	75 07                	jne    80194d <strstr+0x66>
				return (char *) 0;
  801946:	b8 00 00 00 00       	mov    $0x0,%eax
  80194b:	eb 33                	jmp    801980 <strstr+0x99>
		} while (sc != c);
  80194d:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801951:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801954:	75 d8                	jne    80192e <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801956:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80195a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80195e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801962:	48 89 ce             	mov    %rcx,%rsi
  801965:	48 89 c7             	mov    %rax,%rdi
  801968:	48 b8 de 13 80 00 00 	movabs $0x8013de,%rax
  80196f:	00 00 00 
  801972:	ff d0                	callq  *%rax
  801974:	85 c0                	test   %eax,%eax
  801976:	75 b6                	jne    80192e <strstr+0x47>

	return (char *) (in - 1);
  801978:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80197c:	48 83 e8 01          	sub    $0x1,%rax
}
  801980:	c9                   	leaveq 
  801981:	c3                   	retq   

0000000000801982 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801982:	55                   	push   %rbp
  801983:	48 89 e5             	mov    %rsp,%rbp
  801986:	53                   	push   %rbx
  801987:	48 83 ec 48          	sub    $0x48,%rsp
  80198b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80198e:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801991:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801995:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801999:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80199d:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019a1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8019a4:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8019a8:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8019ac:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8019b0:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8019b4:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8019b8:	4c 89 c3             	mov    %r8,%rbx
  8019bb:	cd 30                	int    $0x30
  8019bd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8019c1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8019c5:	74 3e                	je     801a05 <syscall+0x83>
  8019c7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8019cc:	7e 37                	jle    801a05 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8019ce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8019d2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8019d5:	49 89 d0             	mov    %rdx,%r8
  8019d8:	89 c1                	mov    %eax,%ecx
  8019da:	48 ba 88 4f 80 00 00 	movabs $0x804f88,%rdx
  8019e1:	00 00 00 
  8019e4:	be 23 00 00 00       	mov    $0x23,%esi
  8019e9:	48 bf a5 4f 80 00 00 	movabs $0x804fa5,%rdi
  8019f0:	00 00 00 
  8019f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8019f8:	49 b9 3b 04 80 00 00 	movabs $0x80043b,%r9
  8019ff:	00 00 00 
  801a02:	41 ff d1             	callq  *%r9

	return ret;
  801a05:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801a09:	48 83 c4 48          	add    $0x48,%rsp
  801a0d:	5b                   	pop    %rbx
  801a0e:	5d                   	pop    %rbp
  801a0f:	c3                   	retq   

0000000000801a10 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801a10:	55                   	push   %rbp
  801a11:	48 89 e5             	mov    %rsp,%rbp
  801a14:	48 83 ec 20          	sub    $0x20,%rsp
  801a18:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a1c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801a20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a24:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a28:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a2f:	00 
  801a30:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a36:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a3c:	48 89 d1             	mov    %rdx,%rcx
  801a3f:	48 89 c2             	mov    %rax,%rdx
  801a42:	be 00 00 00 00       	mov    $0x0,%esi
  801a47:	bf 00 00 00 00       	mov    $0x0,%edi
  801a4c:	48 b8 82 19 80 00 00 	movabs $0x801982,%rax
  801a53:	00 00 00 
  801a56:	ff d0                	callq  *%rax
}
  801a58:	c9                   	leaveq 
  801a59:	c3                   	retq   

0000000000801a5a <sys_cgetc>:

int
sys_cgetc(void)
{
  801a5a:	55                   	push   %rbp
  801a5b:	48 89 e5             	mov    %rsp,%rbp
  801a5e:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801a62:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a69:	00 
  801a6a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a70:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a76:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a7b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a80:	be 00 00 00 00       	mov    $0x0,%esi
  801a85:	bf 01 00 00 00       	mov    $0x1,%edi
  801a8a:	48 b8 82 19 80 00 00 	movabs $0x801982,%rax
  801a91:	00 00 00 
  801a94:	ff d0                	callq  *%rax
}
  801a96:	c9                   	leaveq 
  801a97:	c3                   	retq   

0000000000801a98 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801a98:	55                   	push   %rbp
  801a99:	48 89 e5             	mov    %rsp,%rbp
  801a9c:	48 83 ec 10          	sub    $0x10,%rsp
  801aa0:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801aa3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aa6:	48 98                	cltq   
  801aa8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aaf:	00 
  801ab0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ab6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801abc:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ac1:	48 89 c2             	mov    %rax,%rdx
  801ac4:	be 01 00 00 00       	mov    $0x1,%esi
  801ac9:	bf 03 00 00 00       	mov    $0x3,%edi
  801ace:	48 b8 82 19 80 00 00 	movabs $0x801982,%rax
  801ad5:	00 00 00 
  801ad8:	ff d0                	callq  *%rax
}
  801ada:	c9                   	leaveq 
  801adb:	c3                   	retq   

0000000000801adc <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801adc:	55                   	push   %rbp
  801add:	48 89 e5             	mov    %rsp,%rbp
  801ae0:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801ae4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aeb:	00 
  801aec:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801af2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801af8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801afd:	ba 00 00 00 00       	mov    $0x0,%edx
  801b02:	be 00 00 00 00       	mov    $0x0,%esi
  801b07:	bf 02 00 00 00       	mov    $0x2,%edi
  801b0c:	48 b8 82 19 80 00 00 	movabs $0x801982,%rax
  801b13:	00 00 00 
  801b16:	ff d0                	callq  *%rax
}
  801b18:	c9                   	leaveq 
  801b19:	c3                   	retq   

0000000000801b1a <sys_yield>:

void
sys_yield(void)
{
  801b1a:	55                   	push   %rbp
  801b1b:	48 89 e5             	mov    %rsp,%rbp
  801b1e:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801b22:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b29:	00 
  801b2a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b30:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b36:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b3b:	ba 00 00 00 00       	mov    $0x0,%edx
  801b40:	be 00 00 00 00       	mov    $0x0,%esi
  801b45:	bf 0b 00 00 00       	mov    $0xb,%edi
  801b4a:	48 b8 82 19 80 00 00 	movabs $0x801982,%rax
  801b51:	00 00 00 
  801b54:	ff d0                	callq  *%rax
}
  801b56:	c9                   	leaveq 
  801b57:	c3                   	retq   

0000000000801b58 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801b58:	55                   	push   %rbp
  801b59:	48 89 e5             	mov    %rsp,%rbp
  801b5c:	48 83 ec 20          	sub    $0x20,%rsp
  801b60:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b63:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b67:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801b6a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b6d:	48 63 c8             	movslq %eax,%rcx
  801b70:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b74:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b77:	48 98                	cltq   
  801b79:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b80:	00 
  801b81:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b87:	49 89 c8             	mov    %rcx,%r8
  801b8a:	48 89 d1             	mov    %rdx,%rcx
  801b8d:	48 89 c2             	mov    %rax,%rdx
  801b90:	be 01 00 00 00       	mov    $0x1,%esi
  801b95:	bf 04 00 00 00       	mov    $0x4,%edi
  801b9a:	48 b8 82 19 80 00 00 	movabs $0x801982,%rax
  801ba1:	00 00 00 
  801ba4:	ff d0                	callq  *%rax
}
  801ba6:	c9                   	leaveq 
  801ba7:	c3                   	retq   

0000000000801ba8 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801ba8:	55                   	push   %rbp
  801ba9:	48 89 e5             	mov    %rsp,%rbp
  801bac:	48 83 ec 30          	sub    $0x30,%rsp
  801bb0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bb3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bb7:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801bba:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801bbe:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801bc2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801bc5:	48 63 c8             	movslq %eax,%rcx
  801bc8:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801bcc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bcf:	48 63 f0             	movslq %eax,%rsi
  801bd2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bd6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bd9:	48 98                	cltq   
  801bdb:	48 89 0c 24          	mov    %rcx,(%rsp)
  801bdf:	49 89 f9             	mov    %rdi,%r9
  801be2:	49 89 f0             	mov    %rsi,%r8
  801be5:	48 89 d1             	mov    %rdx,%rcx
  801be8:	48 89 c2             	mov    %rax,%rdx
  801beb:	be 01 00 00 00       	mov    $0x1,%esi
  801bf0:	bf 05 00 00 00       	mov    $0x5,%edi
  801bf5:	48 b8 82 19 80 00 00 	movabs $0x801982,%rax
  801bfc:	00 00 00 
  801bff:	ff d0                	callq  *%rax
}
  801c01:	c9                   	leaveq 
  801c02:	c3                   	retq   

0000000000801c03 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801c03:	55                   	push   %rbp
  801c04:	48 89 e5             	mov    %rsp,%rbp
  801c07:	48 83 ec 20          	sub    $0x20,%rsp
  801c0b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c0e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801c12:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c16:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c19:	48 98                	cltq   
  801c1b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c22:	00 
  801c23:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c29:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c2f:	48 89 d1             	mov    %rdx,%rcx
  801c32:	48 89 c2             	mov    %rax,%rdx
  801c35:	be 01 00 00 00       	mov    $0x1,%esi
  801c3a:	bf 06 00 00 00       	mov    $0x6,%edi
  801c3f:	48 b8 82 19 80 00 00 	movabs $0x801982,%rax
  801c46:	00 00 00 
  801c49:	ff d0                	callq  *%rax
}
  801c4b:	c9                   	leaveq 
  801c4c:	c3                   	retq   

0000000000801c4d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801c4d:	55                   	push   %rbp
  801c4e:	48 89 e5             	mov    %rsp,%rbp
  801c51:	48 83 ec 10          	sub    $0x10,%rsp
  801c55:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c58:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801c5b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c5e:	48 63 d0             	movslq %eax,%rdx
  801c61:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c64:	48 98                	cltq   
  801c66:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c6d:	00 
  801c6e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c74:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c7a:	48 89 d1             	mov    %rdx,%rcx
  801c7d:	48 89 c2             	mov    %rax,%rdx
  801c80:	be 01 00 00 00       	mov    $0x1,%esi
  801c85:	bf 08 00 00 00       	mov    $0x8,%edi
  801c8a:	48 b8 82 19 80 00 00 	movabs $0x801982,%rax
  801c91:	00 00 00 
  801c94:	ff d0                	callq  *%rax
}
  801c96:	c9                   	leaveq 
  801c97:	c3                   	retq   

0000000000801c98 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801c98:	55                   	push   %rbp
  801c99:	48 89 e5             	mov    %rsp,%rbp
  801c9c:	48 83 ec 20          	sub    $0x20,%rsp
  801ca0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ca3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801ca7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cae:	48 98                	cltq   
  801cb0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cb7:	00 
  801cb8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cbe:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cc4:	48 89 d1             	mov    %rdx,%rcx
  801cc7:	48 89 c2             	mov    %rax,%rdx
  801cca:	be 01 00 00 00       	mov    $0x1,%esi
  801ccf:	bf 09 00 00 00       	mov    $0x9,%edi
  801cd4:	48 b8 82 19 80 00 00 	movabs $0x801982,%rax
  801cdb:	00 00 00 
  801cde:	ff d0                	callq  *%rax
}
  801ce0:	c9                   	leaveq 
  801ce1:	c3                   	retq   

0000000000801ce2 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801ce2:	55                   	push   %rbp
  801ce3:	48 89 e5             	mov    %rsp,%rbp
  801ce6:	48 83 ec 20          	sub    $0x20,%rsp
  801cea:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ced:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801cf1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cf5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cf8:	48 98                	cltq   
  801cfa:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d01:	00 
  801d02:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d08:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d0e:	48 89 d1             	mov    %rdx,%rcx
  801d11:	48 89 c2             	mov    %rax,%rdx
  801d14:	be 01 00 00 00       	mov    $0x1,%esi
  801d19:	bf 0a 00 00 00       	mov    $0xa,%edi
  801d1e:	48 b8 82 19 80 00 00 	movabs $0x801982,%rax
  801d25:	00 00 00 
  801d28:	ff d0                	callq  *%rax
}
  801d2a:	c9                   	leaveq 
  801d2b:	c3                   	retq   

0000000000801d2c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801d2c:	55                   	push   %rbp
  801d2d:	48 89 e5             	mov    %rsp,%rbp
  801d30:	48 83 ec 20          	sub    $0x20,%rsp
  801d34:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d37:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d3b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801d3f:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801d42:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d45:	48 63 f0             	movslq %eax,%rsi
  801d48:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801d4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d4f:	48 98                	cltq   
  801d51:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d55:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d5c:	00 
  801d5d:	49 89 f1             	mov    %rsi,%r9
  801d60:	49 89 c8             	mov    %rcx,%r8
  801d63:	48 89 d1             	mov    %rdx,%rcx
  801d66:	48 89 c2             	mov    %rax,%rdx
  801d69:	be 00 00 00 00       	mov    $0x0,%esi
  801d6e:	bf 0c 00 00 00       	mov    $0xc,%edi
  801d73:	48 b8 82 19 80 00 00 	movabs $0x801982,%rax
  801d7a:	00 00 00 
  801d7d:	ff d0                	callq  *%rax
}
  801d7f:	c9                   	leaveq 
  801d80:	c3                   	retq   

0000000000801d81 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801d81:	55                   	push   %rbp
  801d82:	48 89 e5             	mov    %rsp,%rbp
  801d85:	48 83 ec 10          	sub    $0x10,%rsp
  801d89:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801d8d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d91:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d98:	00 
  801d99:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d9f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801da5:	b9 00 00 00 00       	mov    $0x0,%ecx
  801daa:	48 89 c2             	mov    %rax,%rdx
  801dad:	be 01 00 00 00       	mov    $0x1,%esi
  801db2:	bf 0d 00 00 00       	mov    $0xd,%edi
  801db7:	48 b8 82 19 80 00 00 	movabs $0x801982,%rax
  801dbe:	00 00 00 
  801dc1:	ff d0                	callq  *%rax
}
  801dc3:	c9                   	leaveq 
  801dc4:	c3                   	retq   

0000000000801dc5 <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801dc5:	55                   	push   %rbp
  801dc6:	48 89 e5             	mov    %rsp,%rbp
  801dc9:	48 83 ec 20          	sub    $0x20,%rsp
  801dcd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801dd1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, (uint64_t)buf, len, 0, 0, 0, 0);
  801dd5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dd9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ddd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801de4:	00 
  801de5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801deb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801df1:	b9 00 00 00 00       	mov    $0x0,%ecx
  801df6:	89 c6                	mov    %eax,%esi
  801df8:	bf 0f 00 00 00       	mov    $0xf,%edi
  801dfd:	48 b8 82 19 80 00 00 	movabs $0x801982,%rax
  801e04:	00 00 00 
  801e07:	ff d0                	callq  *%rax
}
  801e09:	c9                   	leaveq 
  801e0a:	c3                   	retq   

0000000000801e0b <sys_net_rx>:

int
sys_net_rx(void *buf, size_t len)
{
  801e0b:	55                   	push   %rbp
  801e0c:	48 89 e5             	mov    %rsp,%rbp
  801e0f:	48 83 ec 20          	sub    $0x20,%rsp
  801e13:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e17:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_rx, (uint64_t)buf, len, 0, 0, 0, 0);
  801e1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e1f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e23:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e2a:	00 
  801e2b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e31:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e37:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e3c:	89 c6                	mov    %eax,%esi
  801e3e:	bf 10 00 00 00       	mov    $0x10,%edi
  801e43:	48 b8 82 19 80 00 00 	movabs $0x801982,%rax
  801e4a:	00 00 00 
  801e4d:	ff d0                	callq  *%rax
}
  801e4f:	c9                   	leaveq 
  801e50:	c3                   	retq   

0000000000801e51 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801e51:	55                   	push   %rbp
  801e52:	48 89 e5             	mov    %rsp,%rbp
  801e55:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801e59:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e60:	00 
  801e61:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e67:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e6d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e72:	ba 00 00 00 00       	mov    $0x0,%edx
  801e77:	be 00 00 00 00       	mov    $0x0,%esi
  801e7c:	bf 0e 00 00 00       	mov    $0xe,%edi
  801e81:	48 b8 82 19 80 00 00 	movabs $0x801982,%rax
  801e88:	00 00 00 
  801e8b:	ff d0                	callq  *%rax
}
  801e8d:	c9                   	leaveq 
  801e8e:	c3                   	retq   

0000000000801e8f <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  801e8f:	55                   	push   %rbp
  801e90:	48 89 e5             	mov    %rsp,%rbp
  801e93:	48 83 ec 30          	sub    $0x30,%rsp
  801e97:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801e9b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e9f:	48 8b 00             	mov    (%rax),%rax
  801ea2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801ea6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eaa:	48 8b 40 08          	mov    0x8(%rax),%rax
  801eae:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801eb1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801eb4:	83 e0 02             	and    $0x2,%eax
  801eb7:	85 c0                	test   %eax,%eax
  801eb9:	75 4d                	jne    801f08 <pgfault+0x79>
  801ebb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ebf:	48 c1 e8 0c          	shr    $0xc,%rax
  801ec3:	48 89 c2             	mov    %rax,%rdx
  801ec6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ecd:	01 00 00 
  801ed0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ed4:	25 00 08 00 00       	and    $0x800,%eax
  801ed9:	48 85 c0             	test   %rax,%rax
  801edc:	74 2a                	je     801f08 <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  801ede:	48 ba b8 4f 80 00 00 	movabs $0x804fb8,%rdx
  801ee5:	00 00 00 
  801ee8:	be 23 00 00 00       	mov    $0x23,%esi
  801eed:	48 bf ed 4f 80 00 00 	movabs $0x804fed,%rdi
  801ef4:	00 00 00 
  801ef7:	b8 00 00 00 00       	mov    $0x0,%eax
  801efc:	48 b9 3b 04 80 00 00 	movabs $0x80043b,%rcx
  801f03:	00 00 00 
  801f06:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  801f08:	ba 07 00 00 00       	mov    $0x7,%edx
  801f0d:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f12:	bf 00 00 00 00       	mov    $0x0,%edi
  801f17:	48 b8 58 1b 80 00 00 	movabs $0x801b58,%rax
  801f1e:	00 00 00 
  801f21:	ff d0                	callq  *%rax
  801f23:	85 c0                	test   %eax,%eax
  801f25:	0f 85 cd 00 00 00    	jne    801ff8 <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801f2b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f2f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801f33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f37:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801f3d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801f41:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f45:	ba 00 10 00 00       	mov    $0x1000,%edx
  801f4a:	48 89 c6             	mov    %rax,%rsi
  801f4d:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801f52:	48 b8 4d 15 80 00 00 	movabs $0x80154d,%rax
  801f59:	00 00 00 
  801f5c:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801f5e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f62:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801f68:	48 89 c1             	mov    %rax,%rcx
  801f6b:	ba 00 00 00 00       	mov    $0x0,%edx
  801f70:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f75:	bf 00 00 00 00       	mov    $0x0,%edi
  801f7a:	48 b8 a8 1b 80 00 00 	movabs $0x801ba8,%rax
  801f81:	00 00 00 
  801f84:	ff d0                	callq  *%rax
  801f86:	85 c0                	test   %eax,%eax
  801f88:	79 2a                	jns    801fb4 <pgfault+0x125>
				panic("Page map at temp address failed");
  801f8a:	48 ba f8 4f 80 00 00 	movabs $0x804ff8,%rdx
  801f91:	00 00 00 
  801f94:	be 30 00 00 00       	mov    $0x30,%esi
  801f99:	48 bf ed 4f 80 00 00 	movabs $0x804fed,%rdi
  801fa0:	00 00 00 
  801fa3:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa8:	48 b9 3b 04 80 00 00 	movabs $0x80043b,%rcx
  801faf:	00 00 00 
  801fb2:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801fb4:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801fb9:	bf 00 00 00 00       	mov    $0x0,%edi
  801fbe:	48 b8 03 1c 80 00 00 	movabs $0x801c03,%rax
  801fc5:	00 00 00 
  801fc8:	ff d0                	callq  *%rax
  801fca:	85 c0                	test   %eax,%eax
  801fcc:	79 54                	jns    802022 <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801fce:	48 ba 18 50 80 00 00 	movabs $0x805018,%rdx
  801fd5:	00 00 00 
  801fd8:	be 32 00 00 00       	mov    $0x32,%esi
  801fdd:	48 bf ed 4f 80 00 00 	movabs $0x804fed,%rdi
  801fe4:	00 00 00 
  801fe7:	b8 00 00 00 00       	mov    $0x0,%eax
  801fec:	48 b9 3b 04 80 00 00 	movabs $0x80043b,%rcx
  801ff3:	00 00 00 
  801ff6:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  801ff8:	48 ba 40 50 80 00 00 	movabs $0x805040,%rdx
  801fff:	00 00 00 
  802002:	be 34 00 00 00       	mov    $0x34,%esi
  802007:	48 bf ed 4f 80 00 00 	movabs $0x804fed,%rdi
  80200e:	00 00 00 
  802011:	b8 00 00 00 00       	mov    $0x0,%eax
  802016:	48 b9 3b 04 80 00 00 	movabs $0x80043b,%rcx
  80201d:	00 00 00 
  802020:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  802022:	c9                   	leaveq 
  802023:	c3                   	retq   

0000000000802024 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  802024:	55                   	push   %rbp
  802025:	48 89 e5             	mov    %rsp,%rbp
  802028:	48 83 ec 20          	sub    $0x20,%rsp
  80202c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80202f:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  802032:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802039:	01 00 00 
  80203c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80203f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802043:	25 07 0e 00 00       	and    $0xe07,%eax
  802048:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  80204b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80204e:	48 c1 e0 0c          	shl    $0xc,%rax
  802052:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  802056:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802059:	25 00 04 00 00       	and    $0x400,%eax
  80205e:	85 c0                	test   %eax,%eax
  802060:	74 57                	je     8020b9 <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  802062:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802065:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802069:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80206c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802070:	41 89 f0             	mov    %esi,%r8d
  802073:	48 89 c6             	mov    %rax,%rsi
  802076:	bf 00 00 00 00       	mov    $0x0,%edi
  80207b:	48 b8 a8 1b 80 00 00 	movabs $0x801ba8,%rax
  802082:	00 00 00 
  802085:	ff d0                	callq  *%rax
  802087:	85 c0                	test   %eax,%eax
  802089:	0f 8e 52 01 00 00    	jle    8021e1 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  80208f:	48 ba 72 50 80 00 00 	movabs $0x805072,%rdx
  802096:	00 00 00 
  802099:	be 4e 00 00 00       	mov    $0x4e,%esi
  80209e:	48 bf ed 4f 80 00 00 	movabs $0x804fed,%rdi
  8020a5:	00 00 00 
  8020a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ad:	48 b9 3b 04 80 00 00 	movabs $0x80043b,%rcx
  8020b4:	00 00 00 
  8020b7:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  8020b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020bc:	83 e0 02             	and    $0x2,%eax
  8020bf:	85 c0                	test   %eax,%eax
  8020c1:	75 10                	jne    8020d3 <duppage+0xaf>
  8020c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020c6:	25 00 08 00 00       	and    $0x800,%eax
  8020cb:	85 c0                	test   %eax,%eax
  8020cd:	0f 84 bb 00 00 00    	je     80218e <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  8020d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020d6:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  8020db:	80 cc 08             	or     $0x8,%ah
  8020de:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  8020e1:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8020e4:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8020e8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8020eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020ef:	41 89 f0             	mov    %esi,%r8d
  8020f2:	48 89 c6             	mov    %rax,%rsi
  8020f5:	bf 00 00 00 00       	mov    $0x0,%edi
  8020fa:	48 b8 a8 1b 80 00 00 	movabs $0x801ba8,%rax
  802101:	00 00 00 
  802104:	ff d0                	callq  *%rax
  802106:	85 c0                	test   %eax,%eax
  802108:	7e 2a                	jle    802134 <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  80210a:	48 ba 72 50 80 00 00 	movabs $0x805072,%rdx
  802111:	00 00 00 
  802114:	be 55 00 00 00       	mov    $0x55,%esi
  802119:	48 bf ed 4f 80 00 00 	movabs $0x804fed,%rdi
  802120:	00 00 00 
  802123:	b8 00 00 00 00       	mov    $0x0,%eax
  802128:	48 b9 3b 04 80 00 00 	movabs $0x80043b,%rcx
  80212f:	00 00 00 
  802132:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  802134:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  802137:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80213b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80213f:	41 89 c8             	mov    %ecx,%r8d
  802142:	48 89 d1             	mov    %rdx,%rcx
  802145:	ba 00 00 00 00       	mov    $0x0,%edx
  80214a:	48 89 c6             	mov    %rax,%rsi
  80214d:	bf 00 00 00 00       	mov    $0x0,%edi
  802152:	48 b8 a8 1b 80 00 00 	movabs $0x801ba8,%rax
  802159:	00 00 00 
  80215c:	ff d0                	callq  *%rax
  80215e:	85 c0                	test   %eax,%eax
  802160:	7e 2a                	jle    80218c <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  802162:	48 ba 72 50 80 00 00 	movabs $0x805072,%rdx
  802169:	00 00 00 
  80216c:	be 57 00 00 00       	mov    $0x57,%esi
  802171:	48 bf ed 4f 80 00 00 	movabs $0x804fed,%rdi
  802178:	00 00 00 
  80217b:	b8 00 00 00 00       	mov    $0x0,%eax
  802180:	48 b9 3b 04 80 00 00 	movabs $0x80043b,%rcx
  802187:	00 00 00 
  80218a:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  80218c:	eb 53                	jmp    8021e1 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  80218e:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802191:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802195:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802198:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80219c:	41 89 f0             	mov    %esi,%r8d
  80219f:	48 89 c6             	mov    %rax,%rsi
  8021a2:	bf 00 00 00 00       	mov    $0x0,%edi
  8021a7:	48 b8 a8 1b 80 00 00 	movabs $0x801ba8,%rax
  8021ae:	00 00 00 
  8021b1:	ff d0                	callq  *%rax
  8021b3:	85 c0                	test   %eax,%eax
  8021b5:	7e 2a                	jle    8021e1 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  8021b7:	48 ba 72 50 80 00 00 	movabs $0x805072,%rdx
  8021be:	00 00 00 
  8021c1:	be 5b 00 00 00       	mov    $0x5b,%esi
  8021c6:	48 bf ed 4f 80 00 00 	movabs $0x804fed,%rdi
  8021cd:	00 00 00 
  8021d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d5:	48 b9 3b 04 80 00 00 	movabs $0x80043b,%rcx
  8021dc:	00 00 00 
  8021df:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  8021e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021e6:	c9                   	leaveq 
  8021e7:	c3                   	retq   

00000000008021e8 <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  8021e8:	55                   	push   %rbp
  8021e9:	48 89 e5             	mov    %rsp,%rbp
  8021ec:	48 83 ec 18          	sub    $0x18,%rsp
  8021f0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  8021f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021f8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  8021fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802200:	48 c1 e8 27          	shr    $0x27,%rax
  802204:	48 89 c2             	mov    %rax,%rdx
  802207:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80220e:	01 00 00 
  802211:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802215:	83 e0 01             	and    $0x1,%eax
  802218:	48 85 c0             	test   %rax,%rax
  80221b:	74 51                	je     80226e <pt_is_mapped+0x86>
  80221d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802221:	48 c1 e0 0c          	shl    $0xc,%rax
  802225:	48 c1 e8 1e          	shr    $0x1e,%rax
  802229:	48 89 c2             	mov    %rax,%rdx
  80222c:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802233:	01 00 00 
  802236:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80223a:	83 e0 01             	and    $0x1,%eax
  80223d:	48 85 c0             	test   %rax,%rax
  802240:	74 2c                	je     80226e <pt_is_mapped+0x86>
  802242:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802246:	48 c1 e0 0c          	shl    $0xc,%rax
  80224a:	48 c1 e8 15          	shr    $0x15,%rax
  80224e:	48 89 c2             	mov    %rax,%rdx
  802251:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802258:	01 00 00 
  80225b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80225f:	83 e0 01             	and    $0x1,%eax
  802262:	48 85 c0             	test   %rax,%rax
  802265:	74 07                	je     80226e <pt_is_mapped+0x86>
  802267:	b8 01 00 00 00       	mov    $0x1,%eax
  80226c:	eb 05                	jmp    802273 <pt_is_mapped+0x8b>
  80226e:	b8 00 00 00 00       	mov    $0x0,%eax
  802273:	83 e0 01             	and    $0x1,%eax
}
  802276:	c9                   	leaveq 
  802277:	c3                   	retq   

0000000000802278 <fork>:

envid_t
fork(void)
{
  802278:	55                   	push   %rbp
  802279:	48 89 e5             	mov    %rsp,%rbp
  80227c:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  802280:	48 bf 8f 1e 80 00 00 	movabs $0x801e8f,%rdi
  802287:	00 00 00 
  80228a:	48 b8 28 48 80 00 00 	movabs $0x804828,%rax
  802291:	00 00 00 
  802294:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802296:	b8 07 00 00 00       	mov    $0x7,%eax
  80229b:	cd 30                	int    $0x30
  80229d:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8022a0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  8022a3:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  8022a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8022aa:	79 30                	jns    8022dc <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  8022ac:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8022af:	89 c1                	mov    %eax,%ecx
  8022b1:	48 ba 90 50 80 00 00 	movabs $0x805090,%rdx
  8022b8:	00 00 00 
  8022bb:	be 86 00 00 00       	mov    $0x86,%esi
  8022c0:	48 bf ed 4f 80 00 00 	movabs $0x804fed,%rdi
  8022c7:	00 00 00 
  8022ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8022cf:	49 b8 3b 04 80 00 00 	movabs $0x80043b,%r8
  8022d6:	00 00 00 
  8022d9:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  8022dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8022e0:	75 46                	jne    802328 <fork+0xb0>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  8022e2:	48 b8 dc 1a 80 00 00 	movabs $0x801adc,%rax
  8022e9:	00 00 00 
  8022ec:	ff d0                	callq  *%rax
  8022ee:	25 ff 03 00 00       	and    $0x3ff,%eax
  8022f3:	48 63 d0             	movslq %eax,%rdx
  8022f6:	48 89 d0             	mov    %rdx,%rax
  8022f9:	48 c1 e0 03          	shl    $0x3,%rax
  8022fd:	48 01 d0             	add    %rdx,%rax
  802300:	48 c1 e0 05          	shl    $0x5,%rax
  802304:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80230b:	00 00 00 
  80230e:	48 01 c2             	add    %rax,%rdx
  802311:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802318:	00 00 00 
  80231b:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  80231e:	b8 00 00 00 00       	mov    $0x0,%eax
  802323:	e9 d1 01 00 00       	jmpq   8024f9 <fork+0x281>
	}
	uint64_t ad = 0;
  802328:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80232f:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  802330:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  802335:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802339:	e9 df 00 00 00       	jmpq   80241d <fork+0x1a5>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  80233e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802342:	48 c1 e8 27          	shr    $0x27,%rax
  802346:	48 89 c2             	mov    %rax,%rdx
  802349:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802350:	01 00 00 
  802353:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802357:	83 e0 01             	and    $0x1,%eax
  80235a:	48 85 c0             	test   %rax,%rax
  80235d:	0f 84 9e 00 00 00    	je     802401 <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  802363:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802367:	48 c1 e8 1e          	shr    $0x1e,%rax
  80236b:	48 89 c2             	mov    %rax,%rdx
  80236e:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802375:	01 00 00 
  802378:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80237c:	83 e0 01             	and    $0x1,%eax
  80237f:	48 85 c0             	test   %rax,%rax
  802382:	74 73                	je     8023f7 <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  802384:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802388:	48 c1 e8 15          	shr    $0x15,%rax
  80238c:	48 89 c2             	mov    %rax,%rdx
  80238f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802396:	01 00 00 
  802399:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80239d:	83 e0 01             	and    $0x1,%eax
  8023a0:	48 85 c0             	test   %rax,%rax
  8023a3:	74 48                	je     8023ed <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  8023a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023a9:	48 c1 e8 0c          	shr    $0xc,%rax
  8023ad:	48 89 c2             	mov    %rax,%rdx
  8023b0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023b7:	01 00 00 
  8023ba:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023be:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8023c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023c6:	83 e0 01             	and    $0x1,%eax
  8023c9:	48 85 c0             	test   %rax,%rax
  8023cc:	74 47                	je     802415 <fork+0x19d>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  8023ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023d2:	48 c1 e8 0c          	shr    $0xc,%rax
  8023d6:	89 c2                	mov    %eax,%edx
  8023d8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8023db:	89 d6                	mov    %edx,%esi
  8023dd:	89 c7                	mov    %eax,%edi
  8023df:	48 b8 24 20 80 00 00 	movabs $0x802024,%rax
  8023e6:	00 00 00 
  8023e9:	ff d0                	callq  *%rax
  8023eb:	eb 28                	jmp    802415 <fork+0x19d>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  8023ed:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  8023f4:	00 
  8023f5:	eb 1e                	jmp    802415 <fork+0x19d>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  8023f7:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  8023fe:	40 
  8023ff:	eb 14                	jmp    802415 <fork+0x19d>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  802401:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802405:	48 c1 e8 27          	shr    $0x27,%rax
  802409:	48 83 c0 01          	add    $0x1,%rax
  80240d:	48 c1 e0 27          	shl    $0x27,%rax
  802411:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  802415:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  80241c:	00 
  80241d:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  802424:	00 
  802425:	0f 87 13 ff ff ff    	ja     80233e <fork+0xc6>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  80242b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80242e:	ba 07 00 00 00       	mov    $0x7,%edx
  802433:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802438:	89 c7                	mov    %eax,%edi
  80243a:	48 b8 58 1b 80 00 00 	movabs $0x801b58,%rax
  802441:	00 00 00 
  802444:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  802446:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802449:	ba 07 00 00 00       	mov    $0x7,%edx
  80244e:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802453:	89 c7                	mov    %eax,%edi
  802455:	48 b8 58 1b 80 00 00 	movabs $0x801b58,%rax
  80245c:	00 00 00 
  80245f:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  802461:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802464:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80246a:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  80246f:	ba 00 00 00 00       	mov    $0x0,%edx
  802474:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802479:	89 c7                	mov    %eax,%edi
  80247b:	48 b8 a8 1b 80 00 00 	movabs $0x801ba8,%rax
  802482:	00 00 00 
  802485:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  802487:	ba 00 10 00 00       	mov    $0x1000,%edx
  80248c:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802491:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802496:	48 b8 4d 15 80 00 00 	movabs $0x80154d,%rax
  80249d:	00 00 00 
  8024a0:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  8024a2:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8024a7:	bf 00 00 00 00       	mov    $0x0,%edi
  8024ac:	48 b8 03 1c 80 00 00 	movabs $0x801c03,%rax
  8024b3:	00 00 00 
  8024b6:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  8024b8:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8024bf:	00 00 00 
  8024c2:	48 8b 00             	mov    (%rax),%rax
  8024c5:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  8024cc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8024cf:	48 89 d6             	mov    %rdx,%rsi
  8024d2:	89 c7                	mov    %eax,%edi
  8024d4:	48 b8 e2 1c 80 00 00 	movabs $0x801ce2,%rax
  8024db:	00 00 00 
  8024de:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  8024e0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8024e3:	be 02 00 00 00       	mov    $0x2,%esi
  8024e8:	89 c7                	mov    %eax,%edi
  8024ea:	48 b8 4d 1c 80 00 00 	movabs $0x801c4d,%rax
  8024f1:	00 00 00 
  8024f4:	ff d0                	callq  *%rax

	return envid;
  8024f6:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  8024f9:	c9                   	leaveq 
  8024fa:	c3                   	retq   

00000000008024fb <sfork>:

	
// Challenge!
int
sfork(void)
{
  8024fb:	55                   	push   %rbp
  8024fc:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8024ff:	48 ba a8 50 80 00 00 	movabs $0x8050a8,%rdx
  802506:	00 00 00 
  802509:	be bf 00 00 00       	mov    $0xbf,%esi
  80250e:	48 bf ed 4f 80 00 00 	movabs $0x804fed,%rdi
  802515:	00 00 00 
  802518:	b8 00 00 00 00       	mov    $0x0,%eax
  80251d:	48 b9 3b 04 80 00 00 	movabs $0x80043b,%rcx
  802524:	00 00 00 
  802527:	ff d1                	callq  *%rcx

0000000000802529 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802529:	55                   	push   %rbp
  80252a:	48 89 e5             	mov    %rsp,%rbp
  80252d:	48 83 ec 30          	sub    $0x30,%rsp
  802531:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802535:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802539:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  80253d:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802544:	00 00 00 
  802547:	48 8b 00             	mov    (%rax),%rax
  80254a:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  802550:	85 c0                	test   %eax,%eax
  802552:	75 3c                	jne    802590 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  802554:	48 b8 dc 1a 80 00 00 	movabs $0x801adc,%rax
  80255b:	00 00 00 
  80255e:	ff d0                	callq  *%rax
  802560:	25 ff 03 00 00       	and    $0x3ff,%eax
  802565:	48 63 d0             	movslq %eax,%rdx
  802568:	48 89 d0             	mov    %rdx,%rax
  80256b:	48 c1 e0 03          	shl    $0x3,%rax
  80256f:	48 01 d0             	add    %rdx,%rax
  802572:	48 c1 e0 05          	shl    $0x5,%rax
  802576:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80257d:	00 00 00 
  802580:	48 01 c2             	add    %rax,%rdx
  802583:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80258a:	00 00 00 
  80258d:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  802590:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802595:	75 0e                	jne    8025a5 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  802597:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80259e:	00 00 00 
  8025a1:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  8025a5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025a9:	48 89 c7             	mov    %rax,%rdi
  8025ac:	48 b8 81 1d 80 00 00 	movabs $0x801d81,%rax
  8025b3:	00 00 00 
  8025b6:	ff d0                	callq  *%rax
  8025b8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  8025bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025bf:	79 19                	jns    8025da <ipc_recv+0xb1>
		*from_env_store = 0;
  8025c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025c5:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  8025cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025cf:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  8025d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025d8:	eb 53                	jmp    80262d <ipc_recv+0x104>
	}
	if(from_env_store)
  8025da:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8025df:	74 19                	je     8025fa <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  8025e1:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8025e8:	00 00 00 
  8025eb:	48 8b 00             	mov    (%rax),%rax
  8025ee:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8025f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025f8:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  8025fa:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8025ff:	74 19                	je     80261a <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  802601:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802608:	00 00 00 
  80260b:	48 8b 00             	mov    (%rax),%rax
  80260e:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  802614:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802618:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  80261a:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802621:	00 00 00 
  802624:	48 8b 00             	mov    (%rax),%rax
  802627:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  80262d:	c9                   	leaveq 
  80262e:	c3                   	retq   

000000000080262f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80262f:	55                   	push   %rbp
  802630:	48 89 e5             	mov    %rsp,%rbp
  802633:	48 83 ec 30          	sub    $0x30,%rsp
  802637:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80263a:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80263d:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802641:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  802644:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802649:	75 0e                	jne    802659 <ipc_send+0x2a>
		pg = (void*)UTOP;
  80264b:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802652:	00 00 00 
  802655:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  802659:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80265c:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80265f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802663:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802666:	89 c7                	mov    %eax,%edi
  802668:	48 b8 2c 1d 80 00 00 	movabs $0x801d2c,%rax
  80266f:	00 00 00 
  802672:	ff d0                	callq  *%rax
  802674:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  802677:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80267b:	75 0c                	jne    802689 <ipc_send+0x5a>
			sys_yield();
  80267d:	48 b8 1a 1b 80 00 00 	movabs $0x801b1a,%rax
  802684:	00 00 00 
  802687:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  802689:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80268d:	74 ca                	je     802659 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  80268f:	c9                   	leaveq 
  802690:	c3                   	retq   

0000000000802691 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802691:	55                   	push   %rbp
  802692:	48 89 e5             	mov    %rsp,%rbp
  802695:	48 83 ec 14          	sub    $0x14,%rsp
  802699:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80269c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8026a3:	eb 5e                	jmp    802703 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8026a5:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8026ac:	00 00 00 
  8026af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026b2:	48 63 d0             	movslq %eax,%rdx
  8026b5:	48 89 d0             	mov    %rdx,%rax
  8026b8:	48 c1 e0 03          	shl    $0x3,%rax
  8026bc:	48 01 d0             	add    %rdx,%rax
  8026bf:	48 c1 e0 05          	shl    $0x5,%rax
  8026c3:	48 01 c8             	add    %rcx,%rax
  8026c6:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8026cc:	8b 00                	mov    (%rax),%eax
  8026ce:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8026d1:	75 2c                	jne    8026ff <ipc_find_env+0x6e>
			return envs[i].env_id;
  8026d3:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8026da:	00 00 00 
  8026dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026e0:	48 63 d0             	movslq %eax,%rdx
  8026e3:	48 89 d0             	mov    %rdx,%rax
  8026e6:	48 c1 e0 03          	shl    $0x3,%rax
  8026ea:	48 01 d0             	add    %rdx,%rax
  8026ed:	48 c1 e0 05          	shl    $0x5,%rax
  8026f1:	48 01 c8             	add    %rcx,%rax
  8026f4:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8026fa:	8b 40 08             	mov    0x8(%rax),%eax
  8026fd:	eb 12                	jmp    802711 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8026ff:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802703:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80270a:	7e 99                	jle    8026a5 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  80270c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802711:	c9                   	leaveq 
  802712:	c3                   	retq   

0000000000802713 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802713:	55                   	push   %rbp
  802714:	48 89 e5             	mov    %rsp,%rbp
  802717:	48 83 ec 08          	sub    $0x8,%rsp
  80271b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80271f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802723:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80272a:	ff ff ff 
  80272d:	48 01 d0             	add    %rdx,%rax
  802730:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802734:	c9                   	leaveq 
  802735:	c3                   	retq   

0000000000802736 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802736:	55                   	push   %rbp
  802737:	48 89 e5             	mov    %rsp,%rbp
  80273a:	48 83 ec 08          	sub    $0x8,%rsp
  80273e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802742:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802746:	48 89 c7             	mov    %rax,%rdi
  802749:	48 b8 13 27 80 00 00 	movabs $0x802713,%rax
  802750:	00 00 00 
  802753:	ff d0                	callq  *%rax
  802755:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80275b:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80275f:	c9                   	leaveq 
  802760:	c3                   	retq   

0000000000802761 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802761:	55                   	push   %rbp
  802762:	48 89 e5             	mov    %rsp,%rbp
  802765:	48 83 ec 18          	sub    $0x18,%rsp
  802769:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80276d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802774:	eb 6b                	jmp    8027e1 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802776:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802779:	48 98                	cltq   
  80277b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802781:	48 c1 e0 0c          	shl    $0xc,%rax
  802785:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802789:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80278d:	48 c1 e8 15          	shr    $0x15,%rax
  802791:	48 89 c2             	mov    %rax,%rdx
  802794:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80279b:	01 00 00 
  80279e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027a2:	83 e0 01             	and    $0x1,%eax
  8027a5:	48 85 c0             	test   %rax,%rax
  8027a8:	74 21                	je     8027cb <fd_alloc+0x6a>
  8027aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027ae:	48 c1 e8 0c          	shr    $0xc,%rax
  8027b2:	48 89 c2             	mov    %rax,%rdx
  8027b5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8027bc:	01 00 00 
  8027bf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027c3:	83 e0 01             	and    $0x1,%eax
  8027c6:	48 85 c0             	test   %rax,%rax
  8027c9:	75 12                	jne    8027dd <fd_alloc+0x7c>
			*fd_store = fd;
  8027cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027cf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8027d3:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8027d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8027db:	eb 1a                	jmp    8027f7 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8027dd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8027e1:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8027e5:	7e 8f                	jle    802776 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8027e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027eb:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8027f2:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8027f7:	c9                   	leaveq 
  8027f8:	c3                   	retq   

00000000008027f9 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8027f9:	55                   	push   %rbp
  8027fa:	48 89 e5             	mov    %rsp,%rbp
  8027fd:	48 83 ec 20          	sub    $0x20,%rsp
  802801:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802804:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802808:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80280c:	78 06                	js     802814 <fd_lookup+0x1b>
  80280e:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802812:	7e 07                	jle    80281b <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802814:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802819:	eb 6c                	jmp    802887 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80281b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80281e:	48 98                	cltq   
  802820:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802826:	48 c1 e0 0c          	shl    $0xc,%rax
  80282a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80282e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802832:	48 c1 e8 15          	shr    $0x15,%rax
  802836:	48 89 c2             	mov    %rax,%rdx
  802839:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802840:	01 00 00 
  802843:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802847:	83 e0 01             	and    $0x1,%eax
  80284a:	48 85 c0             	test   %rax,%rax
  80284d:	74 21                	je     802870 <fd_lookup+0x77>
  80284f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802853:	48 c1 e8 0c          	shr    $0xc,%rax
  802857:	48 89 c2             	mov    %rax,%rdx
  80285a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802861:	01 00 00 
  802864:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802868:	83 e0 01             	and    $0x1,%eax
  80286b:	48 85 c0             	test   %rax,%rax
  80286e:	75 07                	jne    802877 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802870:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802875:	eb 10                	jmp    802887 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802877:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80287b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80287f:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802882:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802887:	c9                   	leaveq 
  802888:	c3                   	retq   

0000000000802889 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802889:	55                   	push   %rbp
  80288a:	48 89 e5             	mov    %rsp,%rbp
  80288d:	48 83 ec 30          	sub    $0x30,%rsp
  802891:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802895:	89 f0                	mov    %esi,%eax
  802897:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80289a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80289e:	48 89 c7             	mov    %rax,%rdi
  8028a1:	48 b8 13 27 80 00 00 	movabs $0x802713,%rax
  8028a8:	00 00 00 
  8028ab:	ff d0                	callq  *%rax
  8028ad:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028b1:	48 89 d6             	mov    %rdx,%rsi
  8028b4:	89 c7                	mov    %eax,%edi
  8028b6:	48 b8 f9 27 80 00 00 	movabs $0x8027f9,%rax
  8028bd:	00 00 00 
  8028c0:	ff d0                	callq  *%rax
  8028c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028c9:	78 0a                	js     8028d5 <fd_close+0x4c>
	    || fd != fd2)
  8028cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028cf:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8028d3:	74 12                	je     8028e7 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8028d5:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8028d9:	74 05                	je     8028e0 <fd_close+0x57>
  8028db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028de:	eb 05                	jmp    8028e5 <fd_close+0x5c>
  8028e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e5:	eb 69                	jmp    802950 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8028e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028eb:	8b 00                	mov    (%rax),%eax
  8028ed:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8028f1:	48 89 d6             	mov    %rdx,%rsi
  8028f4:	89 c7                	mov    %eax,%edi
  8028f6:	48 b8 52 29 80 00 00 	movabs $0x802952,%rax
  8028fd:	00 00 00 
  802900:	ff d0                	callq  *%rax
  802902:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802905:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802909:	78 2a                	js     802935 <fd_close+0xac>
		if (dev->dev_close)
  80290b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80290f:	48 8b 40 20          	mov    0x20(%rax),%rax
  802913:	48 85 c0             	test   %rax,%rax
  802916:	74 16                	je     80292e <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802918:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80291c:	48 8b 40 20          	mov    0x20(%rax),%rax
  802920:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802924:	48 89 d7             	mov    %rdx,%rdi
  802927:	ff d0                	callq  *%rax
  802929:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80292c:	eb 07                	jmp    802935 <fd_close+0xac>
		else
			r = 0;
  80292e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802935:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802939:	48 89 c6             	mov    %rax,%rsi
  80293c:	bf 00 00 00 00       	mov    $0x0,%edi
  802941:	48 b8 03 1c 80 00 00 	movabs $0x801c03,%rax
  802948:	00 00 00 
  80294b:	ff d0                	callq  *%rax
	return r;
  80294d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802950:	c9                   	leaveq 
  802951:	c3                   	retq   

0000000000802952 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802952:	55                   	push   %rbp
  802953:	48 89 e5             	mov    %rsp,%rbp
  802956:	48 83 ec 20          	sub    $0x20,%rsp
  80295a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80295d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802961:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802968:	eb 41                	jmp    8029ab <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80296a:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802971:	00 00 00 
  802974:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802977:	48 63 d2             	movslq %edx,%rdx
  80297a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80297e:	8b 00                	mov    (%rax),%eax
  802980:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802983:	75 22                	jne    8029a7 <dev_lookup+0x55>
			*dev = devtab[i];
  802985:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80298c:	00 00 00 
  80298f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802992:	48 63 d2             	movslq %edx,%rdx
  802995:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802999:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80299d:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8029a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a5:	eb 60                	jmp    802a07 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8029a7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8029ab:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8029b2:	00 00 00 
  8029b5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8029b8:	48 63 d2             	movslq %edx,%rdx
  8029bb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029bf:	48 85 c0             	test   %rax,%rax
  8029c2:	75 a6                	jne    80296a <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8029c4:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8029cb:	00 00 00 
  8029ce:	48 8b 00             	mov    (%rax),%rax
  8029d1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029d7:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8029da:	89 c6                	mov    %eax,%esi
  8029dc:	48 bf c0 50 80 00 00 	movabs $0x8050c0,%rdi
  8029e3:	00 00 00 
  8029e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8029eb:	48 b9 74 06 80 00 00 	movabs $0x800674,%rcx
  8029f2:	00 00 00 
  8029f5:	ff d1                	callq  *%rcx
	*dev = 0;
  8029f7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029fb:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802a02:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802a07:	c9                   	leaveq 
  802a08:	c3                   	retq   

0000000000802a09 <close>:

int
close(int fdnum)
{
  802a09:	55                   	push   %rbp
  802a0a:	48 89 e5             	mov    %rsp,%rbp
  802a0d:	48 83 ec 20          	sub    $0x20,%rsp
  802a11:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a14:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a18:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a1b:	48 89 d6             	mov    %rdx,%rsi
  802a1e:	89 c7                	mov    %eax,%edi
  802a20:	48 b8 f9 27 80 00 00 	movabs $0x8027f9,%rax
  802a27:	00 00 00 
  802a2a:	ff d0                	callq  *%rax
  802a2c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a2f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a33:	79 05                	jns    802a3a <close+0x31>
		return r;
  802a35:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a38:	eb 18                	jmp    802a52 <close+0x49>
	else
		return fd_close(fd, 1);
  802a3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a3e:	be 01 00 00 00       	mov    $0x1,%esi
  802a43:	48 89 c7             	mov    %rax,%rdi
  802a46:	48 b8 89 28 80 00 00 	movabs $0x802889,%rax
  802a4d:	00 00 00 
  802a50:	ff d0                	callq  *%rax
}
  802a52:	c9                   	leaveq 
  802a53:	c3                   	retq   

0000000000802a54 <close_all>:

void
close_all(void)
{
  802a54:	55                   	push   %rbp
  802a55:	48 89 e5             	mov    %rsp,%rbp
  802a58:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802a5c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a63:	eb 15                	jmp    802a7a <close_all+0x26>
		close(i);
  802a65:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a68:	89 c7                	mov    %eax,%edi
  802a6a:	48 b8 09 2a 80 00 00 	movabs $0x802a09,%rax
  802a71:	00 00 00 
  802a74:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802a76:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802a7a:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802a7e:	7e e5                	jle    802a65 <close_all+0x11>
		close(i);
}
  802a80:	c9                   	leaveq 
  802a81:	c3                   	retq   

0000000000802a82 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802a82:	55                   	push   %rbp
  802a83:	48 89 e5             	mov    %rsp,%rbp
  802a86:	48 83 ec 40          	sub    $0x40,%rsp
  802a8a:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802a8d:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802a90:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802a94:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802a97:	48 89 d6             	mov    %rdx,%rsi
  802a9a:	89 c7                	mov    %eax,%edi
  802a9c:	48 b8 f9 27 80 00 00 	movabs $0x8027f9,%rax
  802aa3:	00 00 00 
  802aa6:	ff d0                	callq  *%rax
  802aa8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802aaf:	79 08                	jns    802ab9 <dup+0x37>
		return r;
  802ab1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ab4:	e9 70 01 00 00       	jmpq   802c29 <dup+0x1a7>
	close(newfdnum);
  802ab9:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802abc:	89 c7                	mov    %eax,%edi
  802abe:	48 b8 09 2a 80 00 00 	movabs $0x802a09,%rax
  802ac5:	00 00 00 
  802ac8:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802aca:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802acd:	48 98                	cltq   
  802acf:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802ad5:	48 c1 e0 0c          	shl    $0xc,%rax
  802ad9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802add:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ae1:	48 89 c7             	mov    %rax,%rdi
  802ae4:	48 b8 36 27 80 00 00 	movabs $0x802736,%rax
  802aeb:	00 00 00 
  802aee:	ff d0                	callq  *%rax
  802af0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802af4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802af8:	48 89 c7             	mov    %rax,%rdi
  802afb:	48 b8 36 27 80 00 00 	movabs $0x802736,%rax
  802b02:	00 00 00 
  802b05:	ff d0                	callq  *%rax
  802b07:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802b0b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b0f:	48 c1 e8 15          	shr    $0x15,%rax
  802b13:	48 89 c2             	mov    %rax,%rdx
  802b16:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802b1d:	01 00 00 
  802b20:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b24:	83 e0 01             	and    $0x1,%eax
  802b27:	48 85 c0             	test   %rax,%rax
  802b2a:	74 73                	je     802b9f <dup+0x11d>
  802b2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b30:	48 c1 e8 0c          	shr    $0xc,%rax
  802b34:	48 89 c2             	mov    %rax,%rdx
  802b37:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b3e:	01 00 00 
  802b41:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b45:	83 e0 01             	and    $0x1,%eax
  802b48:	48 85 c0             	test   %rax,%rax
  802b4b:	74 52                	je     802b9f <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802b4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b51:	48 c1 e8 0c          	shr    $0xc,%rax
  802b55:	48 89 c2             	mov    %rax,%rdx
  802b58:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b5f:	01 00 00 
  802b62:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b66:	25 07 0e 00 00       	and    $0xe07,%eax
  802b6b:	89 c1                	mov    %eax,%ecx
  802b6d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802b71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b75:	41 89 c8             	mov    %ecx,%r8d
  802b78:	48 89 d1             	mov    %rdx,%rcx
  802b7b:	ba 00 00 00 00       	mov    $0x0,%edx
  802b80:	48 89 c6             	mov    %rax,%rsi
  802b83:	bf 00 00 00 00       	mov    $0x0,%edi
  802b88:	48 b8 a8 1b 80 00 00 	movabs $0x801ba8,%rax
  802b8f:	00 00 00 
  802b92:	ff d0                	callq  *%rax
  802b94:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b97:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b9b:	79 02                	jns    802b9f <dup+0x11d>
			goto err;
  802b9d:	eb 57                	jmp    802bf6 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802b9f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ba3:	48 c1 e8 0c          	shr    $0xc,%rax
  802ba7:	48 89 c2             	mov    %rax,%rdx
  802baa:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802bb1:	01 00 00 
  802bb4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802bb8:	25 07 0e 00 00       	and    $0xe07,%eax
  802bbd:	89 c1                	mov    %eax,%ecx
  802bbf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bc3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802bc7:	41 89 c8             	mov    %ecx,%r8d
  802bca:	48 89 d1             	mov    %rdx,%rcx
  802bcd:	ba 00 00 00 00       	mov    $0x0,%edx
  802bd2:	48 89 c6             	mov    %rax,%rsi
  802bd5:	bf 00 00 00 00       	mov    $0x0,%edi
  802bda:	48 b8 a8 1b 80 00 00 	movabs $0x801ba8,%rax
  802be1:	00 00 00 
  802be4:	ff d0                	callq  *%rax
  802be6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802be9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bed:	79 02                	jns    802bf1 <dup+0x16f>
		goto err;
  802bef:	eb 05                	jmp    802bf6 <dup+0x174>

	return newfdnum;
  802bf1:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802bf4:	eb 33                	jmp    802c29 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802bf6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bfa:	48 89 c6             	mov    %rax,%rsi
  802bfd:	bf 00 00 00 00       	mov    $0x0,%edi
  802c02:	48 b8 03 1c 80 00 00 	movabs $0x801c03,%rax
  802c09:	00 00 00 
  802c0c:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802c0e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c12:	48 89 c6             	mov    %rax,%rsi
  802c15:	bf 00 00 00 00       	mov    $0x0,%edi
  802c1a:	48 b8 03 1c 80 00 00 	movabs $0x801c03,%rax
  802c21:	00 00 00 
  802c24:	ff d0                	callq  *%rax
	return r;
  802c26:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c29:	c9                   	leaveq 
  802c2a:	c3                   	retq   

0000000000802c2b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802c2b:	55                   	push   %rbp
  802c2c:	48 89 e5             	mov    %rsp,%rbp
  802c2f:	48 83 ec 40          	sub    $0x40,%rsp
  802c33:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c36:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802c3a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c3e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c42:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c45:	48 89 d6             	mov    %rdx,%rsi
  802c48:	89 c7                	mov    %eax,%edi
  802c4a:	48 b8 f9 27 80 00 00 	movabs $0x8027f9,%rax
  802c51:	00 00 00 
  802c54:	ff d0                	callq  *%rax
  802c56:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c59:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c5d:	78 24                	js     802c83 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c63:	8b 00                	mov    (%rax),%eax
  802c65:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c69:	48 89 d6             	mov    %rdx,%rsi
  802c6c:	89 c7                	mov    %eax,%edi
  802c6e:	48 b8 52 29 80 00 00 	movabs $0x802952,%rax
  802c75:	00 00 00 
  802c78:	ff d0                	callq  *%rax
  802c7a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c7d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c81:	79 05                	jns    802c88 <read+0x5d>
		return r;
  802c83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c86:	eb 76                	jmp    802cfe <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802c88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c8c:	8b 40 08             	mov    0x8(%rax),%eax
  802c8f:	83 e0 03             	and    $0x3,%eax
  802c92:	83 f8 01             	cmp    $0x1,%eax
  802c95:	75 3a                	jne    802cd1 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802c97:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802c9e:	00 00 00 
  802ca1:	48 8b 00             	mov    (%rax),%rax
  802ca4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802caa:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802cad:	89 c6                	mov    %eax,%esi
  802caf:	48 bf df 50 80 00 00 	movabs $0x8050df,%rdi
  802cb6:	00 00 00 
  802cb9:	b8 00 00 00 00       	mov    $0x0,%eax
  802cbe:	48 b9 74 06 80 00 00 	movabs $0x800674,%rcx
  802cc5:	00 00 00 
  802cc8:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802cca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ccf:	eb 2d                	jmp    802cfe <read+0xd3>
	}
	if (!dev->dev_read)
  802cd1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cd5:	48 8b 40 10          	mov    0x10(%rax),%rax
  802cd9:	48 85 c0             	test   %rax,%rax
  802cdc:	75 07                	jne    802ce5 <read+0xba>
		return -E_NOT_SUPP;
  802cde:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ce3:	eb 19                	jmp    802cfe <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802ce5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ce9:	48 8b 40 10          	mov    0x10(%rax),%rax
  802ced:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802cf1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802cf5:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802cf9:	48 89 cf             	mov    %rcx,%rdi
  802cfc:	ff d0                	callq  *%rax
}
  802cfe:	c9                   	leaveq 
  802cff:	c3                   	retq   

0000000000802d00 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802d00:	55                   	push   %rbp
  802d01:	48 89 e5             	mov    %rsp,%rbp
  802d04:	48 83 ec 30          	sub    $0x30,%rsp
  802d08:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d0b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d0f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802d13:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802d1a:	eb 49                	jmp    802d65 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802d1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d1f:	48 98                	cltq   
  802d21:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d25:	48 29 c2             	sub    %rax,%rdx
  802d28:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d2b:	48 63 c8             	movslq %eax,%rcx
  802d2e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d32:	48 01 c1             	add    %rax,%rcx
  802d35:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d38:	48 89 ce             	mov    %rcx,%rsi
  802d3b:	89 c7                	mov    %eax,%edi
  802d3d:	48 b8 2b 2c 80 00 00 	movabs $0x802c2b,%rax
  802d44:	00 00 00 
  802d47:	ff d0                	callq  *%rax
  802d49:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802d4c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802d50:	79 05                	jns    802d57 <readn+0x57>
			return m;
  802d52:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d55:	eb 1c                	jmp    802d73 <readn+0x73>
		if (m == 0)
  802d57:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802d5b:	75 02                	jne    802d5f <readn+0x5f>
			break;
  802d5d:	eb 11                	jmp    802d70 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802d5f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d62:	01 45 fc             	add    %eax,-0x4(%rbp)
  802d65:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d68:	48 98                	cltq   
  802d6a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802d6e:	72 ac                	jb     802d1c <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802d70:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802d73:	c9                   	leaveq 
  802d74:	c3                   	retq   

0000000000802d75 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802d75:	55                   	push   %rbp
  802d76:	48 89 e5             	mov    %rsp,%rbp
  802d79:	48 83 ec 40          	sub    $0x40,%rsp
  802d7d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d80:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802d84:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d88:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d8c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d8f:	48 89 d6             	mov    %rdx,%rsi
  802d92:	89 c7                	mov    %eax,%edi
  802d94:	48 b8 f9 27 80 00 00 	movabs $0x8027f9,%rax
  802d9b:	00 00 00 
  802d9e:	ff d0                	callq  *%rax
  802da0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802da3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802da7:	78 24                	js     802dcd <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802da9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dad:	8b 00                	mov    (%rax),%eax
  802daf:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802db3:	48 89 d6             	mov    %rdx,%rsi
  802db6:	89 c7                	mov    %eax,%edi
  802db8:	48 b8 52 29 80 00 00 	movabs $0x802952,%rax
  802dbf:	00 00 00 
  802dc2:	ff d0                	callq  *%rax
  802dc4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dc7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dcb:	79 05                	jns    802dd2 <write+0x5d>
		return r;
  802dcd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dd0:	eb 75                	jmp    802e47 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802dd2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dd6:	8b 40 08             	mov    0x8(%rax),%eax
  802dd9:	83 e0 03             	and    $0x3,%eax
  802ddc:	85 c0                	test   %eax,%eax
  802dde:	75 3a                	jne    802e1a <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802de0:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802de7:	00 00 00 
  802dea:	48 8b 00             	mov    (%rax),%rax
  802ded:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802df3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802df6:	89 c6                	mov    %eax,%esi
  802df8:	48 bf fb 50 80 00 00 	movabs $0x8050fb,%rdi
  802dff:	00 00 00 
  802e02:	b8 00 00 00 00       	mov    $0x0,%eax
  802e07:	48 b9 74 06 80 00 00 	movabs $0x800674,%rcx
  802e0e:	00 00 00 
  802e11:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802e13:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e18:	eb 2d                	jmp    802e47 <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  802e1a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e1e:	48 8b 40 18          	mov    0x18(%rax),%rax
  802e22:	48 85 c0             	test   %rax,%rax
  802e25:	75 07                	jne    802e2e <write+0xb9>
		return -E_NOT_SUPP;
  802e27:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e2c:	eb 19                	jmp    802e47 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802e2e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e32:	48 8b 40 18          	mov    0x18(%rax),%rax
  802e36:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802e3a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802e3e:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802e42:	48 89 cf             	mov    %rcx,%rdi
  802e45:	ff d0                	callq  *%rax
}
  802e47:	c9                   	leaveq 
  802e48:	c3                   	retq   

0000000000802e49 <seek>:

int
seek(int fdnum, off_t offset)
{
  802e49:	55                   	push   %rbp
  802e4a:	48 89 e5             	mov    %rsp,%rbp
  802e4d:	48 83 ec 18          	sub    $0x18,%rsp
  802e51:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e54:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802e57:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e5b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e5e:	48 89 d6             	mov    %rdx,%rsi
  802e61:	89 c7                	mov    %eax,%edi
  802e63:	48 b8 f9 27 80 00 00 	movabs $0x8027f9,%rax
  802e6a:	00 00 00 
  802e6d:	ff d0                	callq  *%rax
  802e6f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e72:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e76:	79 05                	jns    802e7d <seek+0x34>
		return r;
  802e78:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e7b:	eb 0f                	jmp    802e8c <seek+0x43>
	fd->fd_offset = offset;
  802e7d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e81:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802e84:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802e87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e8c:	c9                   	leaveq 
  802e8d:	c3                   	retq   

0000000000802e8e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802e8e:	55                   	push   %rbp
  802e8f:	48 89 e5             	mov    %rsp,%rbp
  802e92:	48 83 ec 30          	sub    $0x30,%rsp
  802e96:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e99:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e9c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ea0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ea3:	48 89 d6             	mov    %rdx,%rsi
  802ea6:	89 c7                	mov    %eax,%edi
  802ea8:	48 b8 f9 27 80 00 00 	movabs $0x8027f9,%rax
  802eaf:	00 00 00 
  802eb2:	ff d0                	callq  *%rax
  802eb4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802eb7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ebb:	78 24                	js     802ee1 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ebd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ec1:	8b 00                	mov    (%rax),%eax
  802ec3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ec7:	48 89 d6             	mov    %rdx,%rsi
  802eca:	89 c7                	mov    %eax,%edi
  802ecc:	48 b8 52 29 80 00 00 	movabs $0x802952,%rax
  802ed3:	00 00 00 
  802ed6:	ff d0                	callq  *%rax
  802ed8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802edb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802edf:	79 05                	jns    802ee6 <ftruncate+0x58>
		return r;
  802ee1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ee4:	eb 72                	jmp    802f58 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802ee6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eea:	8b 40 08             	mov    0x8(%rax),%eax
  802eed:	83 e0 03             	and    $0x3,%eax
  802ef0:	85 c0                	test   %eax,%eax
  802ef2:	75 3a                	jne    802f2e <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802ef4:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802efb:	00 00 00 
  802efe:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802f01:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802f07:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802f0a:	89 c6                	mov    %eax,%esi
  802f0c:	48 bf 18 51 80 00 00 	movabs $0x805118,%rdi
  802f13:	00 00 00 
  802f16:	b8 00 00 00 00       	mov    $0x0,%eax
  802f1b:	48 b9 74 06 80 00 00 	movabs $0x800674,%rcx
  802f22:	00 00 00 
  802f25:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802f27:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802f2c:	eb 2a                	jmp    802f58 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802f2e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f32:	48 8b 40 30          	mov    0x30(%rax),%rax
  802f36:	48 85 c0             	test   %rax,%rax
  802f39:	75 07                	jne    802f42 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802f3b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f40:	eb 16                	jmp    802f58 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802f42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f46:	48 8b 40 30          	mov    0x30(%rax),%rax
  802f4a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802f4e:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802f51:	89 ce                	mov    %ecx,%esi
  802f53:	48 89 d7             	mov    %rdx,%rdi
  802f56:	ff d0                	callq  *%rax
}
  802f58:	c9                   	leaveq 
  802f59:	c3                   	retq   

0000000000802f5a <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802f5a:	55                   	push   %rbp
  802f5b:	48 89 e5             	mov    %rsp,%rbp
  802f5e:	48 83 ec 30          	sub    $0x30,%rsp
  802f62:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802f65:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f69:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802f6d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f70:	48 89 d6             	mov    %rdx,%rsi
  802f73:	89 c7                	mov    %eax,%edi
  802f75:	48 b8 f9 27 80 00 00 	movabs $0x8027f9,%rax
  802f7c:	00 00 00 
  802f7f:	ff d0                	callq  *%rax
  802f81:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f84:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f88:	78 24                	js     802fae <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f8e:	8b 00                	mov    (%rax),%eax
  802f90:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f94:	48 89 d6             	mov    %rdx,%rsi
  802f97:	89 c7                	mov    %eax,%edi
  802f99:	48 b8 52 29 80 00 00 	movabs $0x802952,%rax
  802fa0:	00 00 00 
  802fa3:	ff d0                	callq  *%rax
  802fa5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fa8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fac:	79 05                	jns    802fb3 <fstat+0x59>
		return r;
  802fae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fb1:	eb 5e                	jmp    803011 <fstat+0xb7>
	if (!dev->dev_stat)
  802fb3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fb7:	48 8b 40 28          	mov    0x28(%rax),%rax
  802fbb:	48 85 c0             	test   %rax,%rax
  802fbe:	75 07                	jne    802fc7 <fstat+0x6d>
		return -E_NOT_SUPP;
  802fc0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802fc5:	eb 4a                	jmp    803011 <fstat+0xb7>
	stat->st_name[0] = 0;
  802fc7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fcb:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802fce:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fd2:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802fd9:	00 00 00 
	stat->st_isdir = 0;
  802fdc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fe0:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802fe7:	00 00 00 
	stat->st_dev = dev;
  802fea:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802fee:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ff2:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802ff9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ffd:	48 8b 40 28          	mov    0x28(%rax),%rax
  803001:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803005:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803009:	48 89 ce             	mov    %rcx,%rsi
  80300c:	48 89 d7             	mov    %rdx,%rdi
  80300f:	ff d0                	callq  *%rax
}
  803011:	c9                   	leaveq 
  803012:	c3                   	retq   

0000000000803013 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  803013:	55                   	push   %rbp
  803014:	48 89 e5             	mov    %rsp,%rbp
  803017:	48 83 ec 20          	sub    $0x20,%rsp
  80301b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80301f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  803023:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803027:	be 00 00 00 00       	mov    $0x0,%esi
  80302c:	48 89 c7             	mov    %rax,%rdi
  80302f:	48 b8 01 31 80 00 00 	movabs $0x803101,%rax
  803036:	00 00 00 
  803039:	ff d0                	callq  *%rax
  80303b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80303e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803042:	79 05                	jns    803049 <stat+0x36>
		return fd;
  803044:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803047:	eb 2f                	jmp    803078 <stat+0x65>
	r = fstat(fd, stat);
  803049:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80304d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803050:	48 89 d6             	mov    %rdx,%rsi
  803053:	89 c7                	mov    %eax,%edi
  803055:	48 b8 5a 2f 80 00 00 	movabs $0x802f5a,%rax
  80305c:	00 00 00 
  80305f:	ff d0                	callq  *%rax
  803061:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  803064:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803067:	89 c7                	mov    %eax,%edi
  803069:	48 b8 09 2a 80 00 00 	movabs $0x802a09,%rax
  803070:	00 00 00 
  803073:	ff d0                	callq  *%rax
	return r;
  803075:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  803078:	c9                   	leaveq 
  803079:	c3                   	retq   

000000000080307a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80307a:	55                   	push   %rbp
  80307b:	48 89 e5             	mov    %rsp,%rbp
  80307e:	48 83 ec 10          	sub    $0x10,%rsp
  803082:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803085:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  803089:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803090:	00 00 00 
  803093:	8b 00                	mov    (%rax),%eax
  803095:	85 c0                	test   %eax,%eax
  803097:	75 1d                	jne    8030b6 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  803099:	bf 01 00 00 00       	mov    $0x1,%edi
  80309e:	48 b8 91 26 80 00 00 	movabs $0x802691,%rax
  8030a5:	00 00 00 
  8030a8:	ff d0                	callq  *%rax
  8030aa:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8030b1:	00 00 00 
  8030b4:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8030b6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030bd:	00 00 00 
  8030c0:	8b 00                	mov    (%rax),%eax
  8030c2:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8030c5:	b9 07 00 00 00       	mov    $0x7,%ecx
  8030ca:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  8030d1:	00 00 00 
  8030d4:	89 c7                	mov    %eax,%edi
  8030d6:	48 b8 2f 26 80 00 00 	movabs $0x80262f,%rax
  8030dd:	00 00 00 
  8030e0:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8030e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8030eb:	48 89 c6             	mov    %rax,%rsi
  8030ee:	bf 00 00 00 00       	mov    $0x0,%edi
  8030f3:	48 b8 29 25 80 00 00 	movabs $0x802529,%rax
  8030fa:	00 00 00 
  8030fd:	ff d0                	callq  *%rax
}
  8030ff:	c9                   	leaveq 
  803100:	c3                   	retq   

0000000000803101 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  803101:	55                   	push   %rbp
  803102:	48 89 e5             	mov    %rsp,%rbp
  803105:	48 83 ec 30          	sub    $0x30,%rsp
  803109:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80310d:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  803110:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  803117:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  80311e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  803125:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80312a:	75 08                	jne    803134 <open+0x33>
	{
		return r;
  80312c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80312f:	e9 f2 00 00 00       	jmpq   803226 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  803134:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803138:	48 89 c7             	mov    %rax,%rdi
  80313b:	48 b8 bd 11 80 00 00 	movabs $0x8011bd,%rax
  803142:	00 00 00 
  803145:	ff d0                	callq  *%rax
  803147:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80314a:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  803151:	7e 0a                	jle    80315d <open+0x5c>
	{
		return -E_BAD_PATH;
  803153:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803158:	e9 c9 00 00 00       	jmpq   803226 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  80315d:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  803164:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  803165:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  803169:	48 89 c7             	mov    %rax,%rdi
  80316c:	48 b8 61 27 80 00 00 	movabs $0x802761,%rax
  803173:	00 00 00 
  803176:	ff d0                	callq  *%rax
  803178:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80317b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80317f:	78 09                	js     80318a <open+0x89>
  803181:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803185:	48 85 c0             	test   %rax,%rax
  803188:	75 08                	jne    803192 <open+0x91>
		{
			return r;
  80318a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80318d:	e9 94 00 00 00       	jmpq   803226 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  803192:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803196:	ba 00 04 00 00       	mov    $0x400,%edx
  80319b:	48 89 c6             	mov    %rax,%rsi
  80319e:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8031a5:	00 00 00 
  8031a8:	48 b8 bb 12 80 00 00 	movabs $0x8012bb,%rax
  8031af:	00 00 00 
  8031b2:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  8031b4:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8031bb:	00 00 00 
  8031be:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  8031c1:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  8031c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031cb:	48 89 c6             	mov    %rax,%rsi
  8031ce:	bf 01 00 00 00       	mov    $0x1,%edi
  8031d3:	48 b8 7a 30 80 00 00 	movabs $0x80307a,%rax
  8031da:	00 00 00 
  8031dd:	ff d0                	callq  *%rax
  8031df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031e6:	79 2b                	jns    803213 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  8031e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031ec:	be 00 00 00 00       	mov    $0x0,%esi
  8031f1:	48 89 c7             	mov    %rax,%rdi
  8031f4:	48 b8 89 28 80 00 00 	movabs $0x802889,%rax
  8031fb:	00 00 00 
  8031fe:	ff d0                	callq  *%rax
  803200:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803203:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803207:	79 05                	jns    80320e <open+0x10d>
			{
				return d;
  803209:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80320c:	eb 18                	jmp    803226 <open+0x125>
			}
			return r;
  80320e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803211:	eb 13                	jmp    803226 <open+0x125>
		}	
		return fd2num(fd_store);
  803213:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803217:	48 89 c7             	mov    %rax,%rdi
  80321a:	48 b8 13 27 80 00 00 	movabs $0x802713,%rax
  803221:	00 00 00 
  803224:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  803226:	c9                   	leaveq 
  803227:	c3                   	retq   

0000000000803228 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  803228:	55                   	push   %rbp
  803229:	48 89 e5             	mov    %rsp,%rbp
  80322c:	48 83 ec 10          	sub    $0x10,%rsp
  803230:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803234:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803238:	8b 50 0c             	mov    0xc(%rax),%edx
  80323b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803242:	00 00 00 
  803245:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  803247:	be 00 00 00 00       	mov    $0x0,%esi
  80324c:	bf 06 00 00 00       	mov    $0x6,%edi
  803251:	48 b8 7a 30 80 00 00 	movabs $0x80307a,%rax
  803258:	00 00 00 
  80325b:	ff d0                	callq  *%rax
}
  80325d:	c9                   	leaveq 
  80325e:	c3                   	retq   

000000000080325f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80325f:	55                   	push   %rbp
  803260:	48 89 e5             	mov    %rsp,%rbp
  803263:	48 83 ec 30          	sub    $0x30,%rsp
  803267:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80326b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80326f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  803273:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  80327a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80327f:	74 07                	je     803288 <devfile_read+0x29>
  803281:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803286:	75 07                	jne    80328f <devfile_read+0x30>
		return -E_INVAL;
  803288:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80328d:	eb 77                	jmp    803306 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80328f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803293:	8b 50 0c             	mov    0xc(%rax),%edx
  803296:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80329d:	00 00 00 
  8032a0:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8032a2:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8032a9:	00 00 00 
  8032ac:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8032b0:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  8032b4:	be 00 00 00 00       	mov    $0x0,%esi
  8032b9:	bf 03 00 00 00       	mov    $0x3,%edi
  8032be:	48 b8 7a 30 80 00 00 	movabs $0x80307a,%rax
  8032c5:	00 00 00 
  8032c8:	ff d0                	callq  *%rax
  8032ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032d1:	7f 05                	jg     8032d8 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  8032d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032d6:	eb 2e                	jmp    803306 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  8032d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032db:	48 63 d0             	movslq %eax,%rdx
  8032de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032e2:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8032e9:	00 00 00 
  8032ec:	48 89 c7             	mov    %rax,%rdi
  8032ef:	48 b8 4d 15 80 00 00 	movabs $0x80154d,%rax
  8032f6:	00 00 00 
  8032f9:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  8032fb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032ff:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  803303:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  803306:	c9                   	leaveq 
  803307:	c3                   	retq   

0000000000803308 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803308:	55                   	push   %rbp
  803309:	48 89 e5             	mov    %rsp,%rbp
  80330c:	48 83 ec 30          	sub    $0x30,%rsp
  803310:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803314:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803318:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  80331c:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  803323:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803328:	74 07                	je     803331 <devfile_write+0x29>
  80332a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80332f:	75 08                	jne    803339 <devfile_write+0x31>
		return r;
  803331:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803334:	e9 9a 00 00 00       	jmpq   8033d3 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  803339:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80333d:	8b 50 0c             	mov    0xc(%rax),%edx
  803340:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803347:	00 00 00 
  80334a:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  80334c:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  803353:	00 
  803354:	76 08                	jbe    80335e <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  803356:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  80335d:	00 
	}
	fsipcbuf.write.req_n = n;
  80335e:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803365:	00 00 00 
  803368:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80336c:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  803370:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803374:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803378:	48 89 c6             	mov    %rax,%rsi
  80337b:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  803382:	00 00 00 
  803385:	48 b8 4d 15 80 00 00 	movabs $0x80154d,%rax
  80338c:	00 00 00 
  80338f:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  803391:	be 00 00 00 00       	mov    $0x0,%esi
  803396:	bf 04 00 00 00       	mov    $0x4,%edi
  80339b:	48 b8 7a 30 80 00 00 	movabs $0x80307a,%rax
  8033a2:	00 00 00 
  8033a5:	ff d0                	callq  *%rax
  8033a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033ae:	7f 20                	jg     8033d0 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  8033b0:	48 bf 3e 51 80 00 00 	movabs $0x80513e,%rdi
  8033b7:	00 00 00 
  8033ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8033bf:	48 ba 74 06 80 00 00 	movabs $0x800674,%rdx
  8033c6:	00 00 00 
  8033c9:	ff d2                	callq  *%rdx
		return r;
  8033cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033ce:	eb 03                	jmp    8033d3 <devfile_write+0xcb>
	}
	return r;
  8033d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  8033d3:	c9                   	leaveq 
  8033d4:	c3                   	retq   

00000000008033d5 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8033d5:	55                   	push   %rbp
  8033d6:	48 89 e5             	mov    %rsp,%rbp
  8033d9:	48 83 ec 20          	sub    $0x20,%rsp
  8033dd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8033e1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8033e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033e9:	8b 50 0c             	mov    0xc(%rax),%edx
  8033ec:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8033f3:	00 00 00 
  8033f6:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8033f8:	be 00 00 00 00       	mov    $0x0,%esi
  8033fd:	bf 05 00 00 00       	mov    $0x5,%edi
  803402:	48 b8 7a 30 80 00 00 	movabs $0x80307a,%rax
  803409:	00 00 00 
  80340c:	ff d0                	callq  *%rax
  80340e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803411:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803415:	79 05                	jns    80341c <devfile_stat+0x47>
		return r;
  803417:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80341a:	eb 56                	jmp    803472 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80341c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803420:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  803427:	00 00 00 
  80342a:	48 89 c7             	mov    %rax,%rdi
  80342d:	48 b8 29 12 80 00 00 	movabs $0x801229,%rax
  803434:	00 00 00 
  803437:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803439:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803440:	00 00 00 
  803443:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803449:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80344d:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803453:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80345a:	00 00 00 
  80345d:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803463:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803467:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80346d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803472:	c9                   	leaveq 
  803473:	c3                   	retq   

0000000000803474 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803474:	55                   	push   %rbp
  803475:	48 89 e5             	mov    %rsp,%rbp
  803478:	48 83 ec 10          	sub    $0x10,%rsp
  80347c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803480:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803483:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803487:	8b 50 0c             	mov    0xc(%rax),%edx
  80348a:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803491:	00 00 00 
  803494:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803496:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80349d:	00 00 00 
  8034a0:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8034a3:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8034a6:	be 00 00 00 00       	mov    $0x0,%esi
  8034ab:	bf 02 00 00 00       	mov    $0x2,%edi
  8034b0:	48 b8 7a 30 80 00 00 	movabs $0x80307a,%rax
  8034b7:	00 00 00 
  8034ba:	ff d0                	callq  *%rax
}
  8034bc:	c9                   	leaveq 
  8034bd:	c3                   	retq   

00000000008034be <remove>:

// Delete a file
int
remove(const char *path)
{
  8034be:	55                   	push   %rbp
  8034bf:	48 89 e5             	mov    %rsp,%rbp
  8034c2:	48 83 ec 10          	sub    $0x10,%rsp
  8034c6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8034ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034ce:	48 89 c7             	mov    %rax,%rdi
  8034d1:	48 b8 bd 11 80 00 00 	movabs $0x8011bd,%rax
  8034d8:	00 00 00 
  8034db:	ff d0                	callq  *%rax
  8034dd:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8034e2:	7e 07                	jle    8034eb <remove+0x2d>
		return -E_BAD_PATH;
  8034e4:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8034e9:	eb 33                	jmp    80351e <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8034eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034ef:	48 89 c6             	mov    %rax,%rsi
  8034f2:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8034f9:	00 00 00 
  8034fc:	48 b8 29 12 80 00 00 	movabs $0x801229,%rax
  803503:	00 00 00 
  803506:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803508:	be 00 00 00 00       	mov    $0x0,%esi
  80350d:	bf 07 00 00 00       	mov    $0x7,%edi
  803512:	48 b8 7a 30 80 00 00 	movabs $0x80307a,%rax
  803519:	00 00 00 
  80351c:	ff d0                	callq  *%rax
}
  80351e:	c9                   	leaveq 
  80351f:	c3                   	retq   

0000000000803520 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803520:	55                   	push   %rbp
  803521:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803524:	be 00 00 00 00       	mov    $0x0,%esi
  803529:	bf 08 00 00 00       	mov    $0x8,%edi
  80352e:	48 b8 7a 30 80 00 00 	movabs $0x80307a,%rax
  803535:	00 00 00 
  803538:	ff d0                	callq  *%rax
}
  80353a:	5d                   	pop    %rbp
  80353b:	c3                   	retq   

000000000080353c <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  80353c:	55                   	push   %rbp
  80353d:	48 89 e5             	mov    %rsp,%rbp
  803540:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803547:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  80354e:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803555:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  80355c:	be 00 00 00 00       	mov    $0x0,%esi
  803561:	48 89 c7             	mov    %rax,%rdi
  803564:	48 b8 01 31 80 00 00 	movabs $0x803101,%rax
  80356b:	00 00 00 
  80356e:	ff d0                	callq  *%rax
  803570:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803573:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803577:	79 28                	jns    8035a1 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803579:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80357c:	89 c6                	mov    %eax,%esi
  80357e:	48 bf 5a 51 80 00 00 	movabs $0x80515a,%rdi
  803585:	00 00 00 
  803588:	b8 00 00 00 00       	mov    $0x0,%eax
  80358d:	48 ba 74 06 80 00 00 	movabs $0x800674,%rdx
  803594:	00 00 00 
  803597:	ff d2                	callq  *%rdx
		return fd_src;
  803599:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80359c:	e9 74 01 00 00       	jmpq   803715 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8035a1:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8035a8:	be 01 01 00 00       	mov    $0x101,%esi
  8035ad:	48 89 c7             	mov    %rax,%rdi
  8035b0:	48 b8 01 31 80 00 00 	movabs $0x803101,%rax
  8035b7:	00 00 00 
  8035ba:	ff d0                	callq  *%rax
  8035bc:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8035bf:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8035c3:	79 39                	jns    8035fe <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8035c5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035c8:	89 c6                	mov    %eax,%esi
  8035ca:	48 bf 70 51 80 00 00 	movabs $0x805170,%rdi
  8035d1:	00 00 00 
  8035d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8035d9:	48 ba 74 06 80 00 00 	movabs $0x800674,%rdx
  8035e0:	00 00 00 
  8035e3:	ff d2                	callq  *%rdx
		close(fd_src);
  8035e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035e8:	89 c7                	mov    %eax,%edi
  8035ea:	48 b8 09 2a 80 00 00 	movabs $0x802a09,%rax
  8035f1:	00 00 00 
  8035f4:	ff d0                	callq  *%rax
		return fd_dest;
  8035f6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035f9:	e9 17 01 00 00       	jmpq   803715 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8035fe:	eb 74                	jmp    803674 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  803600:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803603:	48 63 d0             	movslq %eax,%rdx
  803606:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80360d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803610:	48 89 ce             	mov    %rcx,%rsi
  803613:	89 c7                	mov    %eax,%edi
  803615:	48 b8 75 2d 80 00 00 	movabs $0x802d75,%rax
  80361c:	00 00 00 
  80361f:	ff d0                	callq  *%rax
  803621:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803624:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803628:	79 4a                	jns    803674 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  80362a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80362d:	89 c6                	mov    %eax,%esi
  80362f:	48 bf 8a 51 80 00 00 	movabs $0x80518a,%rdi
  803636:	00 00 00 
  803639:	b8 00 00 00 00       	mov    $0x0,%eax
  80363e:	48 ba 74 06 80 00 00 	movabs $0x800674,%rdx
  803645:	00 00 00 
  803648:	ff d2                	callq  *%rdx
			close(fd_src);
  80364a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80364d:	89 c7                	mov    %eax,%edi
  80364f:	48 b8 09 2a 80 00 00 	movabs $0x802a09,%rax
  803656:	00 00 00 
  803659:	ff d0                	callq  *%rax
			close(fd_dest);
  80365b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80365e:	89 c7                	mov    %eax,%edi
  803660:	48 b8 09 2a 80 00 00 	movabs $0x802a09,%rax
  803667:	00 00 00 
  80366a:	ff d0                	callq  *%rax
			return write_size;
  80366c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80366f:	e9 a1 00 00 00       	jmpq   803715 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803674:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80367b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80367e:	ba 00 02 00 00       	mov    $0x200,%edx
  803683:	48 89 ce             	mov    %rcx,%rsi
  803686:	89 c7                	mov    %eax,%edi
  803688:	48 b8 2b 2c 80 00 00 	movabs $0x802c2b,%rax
  80368f:	00 00 00 
  803692:	ff d0                	callq  *%rax
  803694:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803697:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80369b:	0f 8f 5f ff ff ff    	jg     803600 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  8036a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8036a5:	79 47                	jns    8036ee <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8036a7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8036aa:	89 c6                	mov    %eax,%esi
  8036ac:	48 bf 9d 51 80 00 00 	movabs $0x80519d,%rdi
  8036b3:	00 00 00 
  8036b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8036bb:	48 ba 74 06 80 00 00 	movabs $0x800674,%rdx
  8036c2:	00 00 00 
  8036c5:	ff d2                	callq  *%rdx
		close(fd_src);
  8036c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036ca:	89 c7                	mov    %eax,%edi
  8036cc:	48 b8 09 2a 80 00 00 	movabs $0x802a09,%rax
  8036d3:	00 00 00 
  8036d6:	ff d0                	callq  *%rax
		close(fd_dest);
  8036d8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036db:	89 c7                	mov    %eax,%edi
  8036dd:	48 b8 09 2a 80 00 00 	movabs $0x802a09,%rax
  8036e4:	00 00 00 
  8036e7:	ff d0                	callq  *%rax
		return read_size;
  8036e9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8036ec:	eb 27                	jmp    803715 <copy+0x1d9>
	}
	close(fd_src);
  8036ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036f1:	89 c7                	mov    %eax,%edi
  8036f3:	48 b8 09 2a 80 00 00 	movabs $0x802a09,%rax
  8036fa:	00 00 00 
  8036fd:	ff d0                	callq  *%rax
	close(fd_dest);
  8036ff:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803702:	89 c7                	mov    %eax,%edi
  803704:	48 b8 09 2a 80 00 00 	movabs $0x802a09,%rax
  80370b:	00 00 00 
  80370e:	ff d0                	callq  *%rax
	return 0;
  803710:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803715:	c9                   	leaveq 
  803716:	c3                   	retq   

0000000000803717 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803717:	55                   	push   %rbp
  803718:	48 89 e5             	mov    %rsp,%rbp
  80371b:	48 83 ec 18          	sub    $0x18,%rsp
  80371f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803723:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803727:	48 c1 e8 15          	shr    $0x15,%rax
  80372b:	48 89 c2             	mov    %rax,%rdx
  80372e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803735:	01 00 00 
  803738:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80373c:	83 e0 01             	and    $0x1,%eax
  80373f:	48 85 c0             	test   %rax,%rax
  803742:	75 07                	jne    80374b <pageref+0x34>
		return 0;
  803744:	b8 00 00 00 00       	mov    $0x0,%eax
  803749:	eb 53                	jmp    80379e <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80374b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80374f:	48 c1 e8 0c          	shr    $0xc,%rax
  803753:	48 89 c2             	mov    %rax,%rdx
  803756:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80375d:	01 00 00 
  803760:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803764:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803768:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80376c:	83 e0 01             	and    $0x1,%eax
  80376f:	48 85 c0             	test   %rax,%rax
  803772:	75 07                	jne    80377b <pageref+0x64>
		return 0;
  803774:	b8 00 00 00 00       	mov    $0x0,%eax
  803779:	eb 23                	jmp    80379e <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  80377b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80377f:	48 c1 e8 0c          	shr    $0xc,%rax
  803783:	48 89 c2             	mov    %rax,%rdx
  803786:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80378d:	00 00 00 
  803790:	48 c1 e2 04          	shl    $0x4,%rdx
  803794:	48 01 d0             	add    %rdx,%rax
  803797:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80379b:	0f b7 c0             	movzwl %ax,%eax
}
  80379e:	c9                   	leaveq 
  80379f:	c3                   	retq   

00000000008037a0 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8037a0:	55                   	push   %rbp
  8037a1:	48 89 e5             	mov    %rsp,%rbp
  8037a4:	48 83 ec 20          	sub    $0x20,%rsp
  8037a8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8037ab:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8037af:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037b2:	48 89 d6             	mov    %rdx,%rsi
  8037b5:	89 c7                	mov    %eax,%edi
  8037b7:	48 b8 f9 27 80 00 00 	movabs $0x8027f9,%rax
  8037be:	00 00 00 
  8037c1:	ff d0                	callq  *%rax
  8037c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037ca:	79 05                	jns    8037d1 <fd2sockid+0x31>
		return r;
  8037cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037cf:	eb 24                	jmp    8037f5 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8037d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037d5:	8b 10                	mov    (%rax),%edx
  8037d7:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  8037de:	00 00 00 
  8037e1:	8b 00                	mov    (%rax),%eax
  8037e3:	39 c2                	cmp    %eax,%edx
  8037e5:	74 07                	je     8037ee <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  8037e7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8037ec:	eb 07                	jmp    8037f5 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8037ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037f2:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8037f5:	c9                   	leaveq 
  8037f6:	c3                   	retq   

00000000008037f7 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8037f7:	55                   	push   %rbp
  8037f8:	48 89 e5             	mov    %rsp,%rbp
  8037fb:	48 83 ec 20          	sub    $0x20,%rsp
  8037ff:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803802:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803806:	48 89 c7             	mov    %rax,%rdi
  803809:	48 b8 61 27 80 00 00 	movabs $0x802761,%rax
  803810:	00 00 00 
  803813:	ff d0                	callq  *%rax
  803815:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803818:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80381c:	78 26                	js     803844 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80381e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803822:	ba 07 04 00 00       	mov    $0x407,%edx
  803827:	48 89 c6             	mov    %rax,%rsi
  80382a:	bf 00 00 00 00       	mov    $0x0,%edi
  80382f:	48 b8 58 1b 80 00 00 	movabs $0x801b58,%rax
  803836:	00 00 00 
  803839:	ff d0                	callq  *%rax
  80383b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80383e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803842:	79 16                	jns    80385a <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803844:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803847:	89 c7                	mov    %eax,%edi
  803849:	48 b8 04 3d 80 00 00 	movabs $0x803d04,%rax
  803850:	00 00 00 
  803853:	ff d0                	callq  *%rax
		return r;
  803855:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803858:	eb 3a                	jmp    803894 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  80385a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80385e:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  803865:	00 00 00 
  803868:	8b 12                	mov    (%rdx),%edx
  80386a:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  80386c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803870:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803877:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80387b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80387e:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803881:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803885:	48 89 c7             	mov    %rax,%rdi
  803888:	48 b8 13 27 80 00 00 	movabs $0x802713,%rax
  80388f:	00 00 00 
  803892:	ff d0                	callq  *%rax
}
  803894:	c9                   	leaveq 
  803895:	c3                   	retq   

0000000000803896 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803896:	55                   	push   %rbp
  803897:	48 89 e5             	mov    %rsp,%rbp
  80389a:	48 83 ec 30          	sub    $0x30,%rsp
  80389e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8038a1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8038a5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8038a9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038ac:	89 c7                	mov    %eax,%edi
  8038ae:	48 b8 a0 37 80 00 00 	movabs $0x8037a0,%rax
  8038b5:	00 00 00 
  8038b8:	ff d0                	callq  *%rax
  8038ba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038c1:	79 05                	jns    8038c8 <accept+0x32>
		return r;
  8038c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038c6:	eb 3b                	jmp    803903 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8038c8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8038cc:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8038d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038d3:	48 89 ce             	mov    %rcx,%rsi
  8038d6:	89 c7                	mov    %eax,%edi
  8038d8:	48 b8 e1 3b 80 00 00 	movabs $0x803be1,%rax
  8038df:	00 00 00 
  8038e2:	ff d0                	callq  *%rax
  8038e4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038eb:	79 05                	jns    8038f2 <accept+0x5c>
		return r;
  8038ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038f0:	eb 11                	jmp    803903 <accept+0x6d>
	return alloc_sockfd(r);
  8038f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038f5:	89 c7                	mov    %eax,%edi
  8038f7:	48 b8 f7 37 80 00 00 	movabs $0x8037f7,%rax
  8038fe:	00 00 00 
  803901:	ff d0                	callq  *%rax
}
  803903:	c9                   	leaveq 
  803904:	c3                   	retq   

0000000000803905 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803905:	55                   	push   %rbp
  803906:	48 89 e5             	mov    %rsp,%rbp
  803909:	48 83 ec 20          	sub    $0x20,%rsp
  80390d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803910:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803914:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803917:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80391a:	89 c7                	mov    %eax,%edi
  80391c:	48 b8 a0 37 80 00 00 	movabs $0x8037a0,%rax
  803923:	00 00 00 
  803926:	ff d0                	callq  *%rax
  803928:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80392b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80392f:	79 05                	jns    803936 <bind+0x31>
		return r;
  803931:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803934:	eb 1b                	jmp    803951 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803936:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803939:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80393d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803940:	48 89 ce             	mov    %rcx,%rsi
  803943:	89 c7                	mov    %eax,%edi
  803945:	48 b8 60 3c 80 00 00 	movabs $0x803c60,%rax
  80394c:	00 00 00 
  80394f:	ff d0                	callq  *%rax
}
  803951:	c9                   	leaveq 
  803952:	c3                   	retq   

0000000000803953 <shutdown>:

int
shutdown(int s, int how)
{
  803953:	55                   	push   %rbp
  803954:	48 89 e5             	mov    %rsp,%rbp
  803957:	48 83 ec 20          	sub    $0x20,%rsp
  80395b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80395e:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803961:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803964:	89 c7                	mov    %eax,%edi
  803966:	48 b8 a0 37 80 00 00 	movabs $0x8037a0,%rax
  80396d:	00 00 00 
  803970:	ff d0                	callq  *%rax
  803972:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803975:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803979:	79 05                	jns    803980 <shutdown+0x2d>
		return r;
  80397b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80397e:	eb 16                	jmp    803996 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803980:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803983:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803986:	89 d6                	mov    %edx,%esi
  803988:	89 c7                	mov    %eax,%edi
  80398a:	48 b8 c4 3c 80 00 00 	movabs $0x803cc4,%rax
  803991:	00 00 00 
  803994:	ff d0                	callq  *%rax
}
  803996:	c9                   	leaveq 
  803997:	c3                   	retq   

0000000000803998 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803998:	55                   	push   %rbp
  803999:	48 89 e5             	mov    %rsp,%rbp
  80399c:	48 83 ec 10          	sub    $0x10,%rsp
  8039a0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8039a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039a8:	48 89 c7             	mov    %rax,%rdi
  8039ab:	48 b8 17 37 80 00 00 	movabs $0x803717,%rax
  8039b2:	00 00 00 
  8039b5:	ff d0                	callq  *%rax
  8039b7:	83 f8 01             	cmp    $0x1,%eax
  8039ba:	75 17                	jne    8039d3 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8039bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039c0:	8b 40 0c             	mov    0xc(%rax),%eax
  8039c3:	89 c7                	mov    %eax,%edi
  8039c5:	48 b8 04 3d 80 00 00 	movabs $0x803d04,%rax
  8039cc:	00 00 00 
  8039cf:	ff d0                	callq  *%rax
  8039d1:	eb 05                	jmp    8039d8 <devsock_close+0x40>
	else
		return 0;
  8039d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8039d8:	c9                   	leaveq 
  8039d9:	c3                   	retq   

00000000008039da <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8039da:	55                   	push   %rbp
  8039db:	48 89 e5             	mov    %rsp,%rbp
  8039de:	48 83 ec 20          	sub    $0x20,%rsp
  8039e2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8039e5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8039e9:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8039ec:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039ef:	89 c7                	mov    %eax,%edi
  8039f1:	48 b8 a0 37 80 00 00 	movabs $0x8037a0,%rax
  8039f8:	00 00 00 
  8039fb:	ff d0                	callq  *%rax
  8039fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a00:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a04:	79 05                	jns    803a0b <connect+0x31>
		return r;
  803a06:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a09:	eb 1b                	jmp    803a26 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803a0b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803a0e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803a12:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a15:	48 89 ce             	mov    %rcx,%rsi
  803a18:	89 c7                	mov    %eax,%edi
  803a1a:	48 b8 31 3d 80 00 00 	movabs $0x803d31,%rax
  803a21:	00 00 00 
  803a24:	ff d0                	callq  *%rax
}
  803a26:	c9                   	leaveq 
  803a27:	c3                   	retq   

0000000000803a28 <listen>:

int
listen(int s, int backlog)
{
  803a28:	55                   	push   %rbp
  803a29:	48 89 e5             	mov    %rsp,%rbp
  803a2c:	48 83 ec 20          	sub    $0x20,%rsp
  803a30:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a33:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803a36:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a39:	89 c7                	mov    %eax,%edi
  803a3b:	48 b8 a0 37 80 00 00 	movabs $0x8037a0,%rax
  803a42:	00 00 00 
  803a45:	ff d0                	callq  *%rax
  803a47:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a4a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a4e:	79 05                	jns    803a55 <listen+0x2d>
		return r;
  803a50:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a53:	eb 16                	jmp    803a6b <listen+0x43>
	return nsipc_listen(r, backlog);
  803a55:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803a58:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a5b:	89 d6                	mov    %edx,%esi
  803a5d:	89 c7                	mov    %eax,%edi
  803a5f:	48 b8 95 3d 80 00 00 	movabs $0x803d95,%rax
  803a66:	00 00 00 
  803a69:	ff d0                	callq  *%rax
}
  803a6b:	c9                   	leaveq 
  803a6c:	c3                   	retq   

0000000000803a6d <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803a6d:	55                   	push   %rbp
  803a6e:	48 89 e5             	mov    %rsp,%rbp
  803a71:	48 83 ec 20          	sub    $0x20,%rsp
  803a75:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803a79:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803a7d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803a81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a85:	89 c2                	mov    %eax,%edx
  803a87:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a8b:	8b 40 0c             	mov    0xc(%rax),%eax
  803a8e:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803a92:	b9 00 00 00 00       	mov    $0x0,%ecx
  803a97:	89 c7                	mov    %eax,%edi
  803a99:	48 b8 d5 3d 80 00 00 	movabs $0x803dd5,%rax
  803aa0:	00 00 00 
  803aa3:	ff d0                	callq  *%rax
}
  803aa5:	c9                   	leaveq 
  803aa6:	c3                   	retq   

0000000000803aa7 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803aa7:	55                   	push   %rbp
  803aa8:	48 89 e5             	mov    %rsp,%rbp
  803aab:	48 83 ec 20          	sub    $0x20,%rsp
  803aaf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803ab3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803ab7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803abb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803abf:	89 c2                	mov    %eax,%edx
  803ac1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ac5:	8b 40 0c             	mov    0xc(%rax),%eax
  803ac8:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803acc:	b9 00 00 00 00       	mov    $0x0,%ecx
  803ad1:	89 c7                	mov    %eax,%edi
  803ad3:	48 b8 a1 3e 80 00 00 	movabs $0x803ea1,%rax
  803ada:	00 00 00 
  803add:	ff d0                	callq  *%rax
}
  803adf:	c9                   	leaveq 
  803ae0:	c3                   	retq   

0000000000803ae1 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803ae1:	55                   	push   %rbp
  803ae2:	48 89 e5             	mov    %rsp,%rbp
  803ae5:	48 83 ec 10          	sub    $0x10,%rsp
  803ae9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803aed:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803af1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803af5:	48 be b8 51 80 00 00 	movabs $0x8051b8,%rsi
  803afc:	00 00 00 
  803aff:	48 89 c7             	mov    %rax,%rdi
  803b02:	48 b8 29 12 80 00 00 	movabs $0x801229,%rax
  803b09:	00 00 00 
  803b0c:	ff d0                	callq  *%rax
	return 0;
  803b0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b13:	c9                   	leaveq 
  803b14:	c3                   	retq   

0000000000803b15 <socket>:

int
socket(int domain, int type, int protocol)
{
  803b15:	55                   	push   %rbp
  803b16:	48 89 e5             	mov    %rsp,%rbp
  803b19:	48 83 ec 20          	sub    $0x20,%rsp
  803b1d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b20:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803b23:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803b26:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803b29:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803b2c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b2f:	89 ce                	mov    %ecx,%esi
  803b31:	89 c7                	mov    %eax,%edi
  803b33:	48 b8 59 3f 80 00 00 	movabs $0x803f59,%rax
  803b3a:	00 00 00 
  803b3d:	ff d0                	callq  *%rax
  803b3f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b42:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b46:	79 05                	jns    803b4d <socket+0x38>
		return r;
  803b48:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b4b:	eb 11                	jmp    803b5e <socket+0x49>
	return alloc_sockfd(r);
  803b4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b50:	89 c7                	mov    %eax,%edi
  803b52:	48 b8 f7 37 80 00 00 	movabs $0x8037f7,%rax
  803b59:	00 00 00 
  803b5c:	ff d0                	callq  *%rax
}
  803b5e:	c9                   	leaveq 
  803b5f:	c3                   	retq   

0000000000803b60 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803b60:	55                   	push   %rbp
  803b61:	48 89 e5             	mov    %rsp,%rbp
  803b64:	48 83 ec 10          	sub    $0x10,%rsp
  803b68:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803b6b:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803b72:	00 00 00 
  803b75:	8b 00                	mov    (%rax),%eax
  803b77:	85 c0                	test   %eax,%eax
  803b79:	75 1d                	jne    803b98 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803b7b:	bf 02 00 00 00       	mov    $0x2,%edi
  803b80:	48 b8 91 26 80 00 00 	movabs $0x802691,%rax
  803b87:	00 00 00 
  803b8a:	ff d0                	callq  *%rax
  803b8c:	48 ba 04 80 80 00 00 	movabs $0x808004,%rdx
  803b93:	00 00 00 
  803b96:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803b98:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803b9f:	00 00 00 
  803ba2:	8b 00                	mov    (%rax),%eax
  803ba4:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803ba7:	b9 07 00 00 00       	mov    $0x7,%ecx
  803bac:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803bb3:	00 00 00 
  803bb6:	89 c7                	mov    %eax,%edi
  803bb8:	48 b8 2f 26 80 00 00 	movabs $0x80262f,%rax
  803bbf:	00 00 00 
  803bc2:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803bc4:	ba 00 00 00 00       	mov    $0x0,%edx
  803bc9:	be 00 00 00 00       	mov    $0x0,%esi
  803bce:	bf 00 00 00 00       	mov    $0x0,%edi
  803bd3:	48 b8 29 25 80 00 00 	movabs $0x802529,%rax
  803bda:	00 00 00 
  803bdd:	ff d0                	callq  *%rax
}
  803bdf:	c9                   	leaveq 
  803be0:	c3                   	retq   

0000000000803be1 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803be1:	55                   	push   %rbp
  803be2:	48 89 e5             	mov    %rsp,%rbp
  803be5:	48 83 ec 30          	sub    $0x30,%rsp
  803be9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803bec:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803bf0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803bf4:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bfb:	00 00 00 
  803bfe:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803c01:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803c03:	bf 01 00 00 00       	mov    $0x1,%edi
  803c08:	48 b8 60 3b 80 00 00 	movabs $0x803b60,%rax
  803c0f:	00 00 00 
  803c12:	ff d0                	callq  *%rax
  803c14:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c17:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c1b:	78 3e                	js     803c5b <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803c1d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c24:	00 00 00 
  803c27:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803c2b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c2f:	8b 40 10             	mov    0x10(%rax),%eax
  803c32:	89 c2                	mov    %eax,%edx
  803c34:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803c38:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c3c:	48 89 ce             	mov    %rcx,%rsi
  803c3f:	48 89 c7             	mov    %rax,%rdi
  803c42:	48 b8 4d 15 80 00 00 	movabs $0x80154d,%rax
  803c49:	00 00 00 
  803c4c:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803c4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c52:	8b 50 10             	mov    0x10(%rax),%edx
  803c55:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c59:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803c5b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803c5e:	c9                   	leaveq 
  803c5f:	c3                   	retq   

0000000000803c60 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803c60:	55                   	push   %rbp
  803c61:	48 89 e5             	mov    %rsp,%rbp
  803c64:	48 83 ec 10          	sub    $0x10,%rsp
  803c68:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c6b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803c6f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803c72:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c79:	00 00 00 
  803c7c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c7f:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803c81:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c84:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c88:	48 89 c6             	mov    %rax,%rsi
  803c8b:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803c92:	00 00 00 
  803c95:	48 b8 4d 15 80 00 00 	movabs $0x80154d,%rax
  803c9c:	00 00 00 
  803c9f:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803ca1:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ca8:	00 00 00 
  803cab:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803cae:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803cb1:	bf 02 00 00 00       	mov    $0x2,%edi
  803cb6:	48 b8 60 3b 80 00 00 	movabs $0x803b60,%rax
  803cbd:	00 00 00 
  803cc0:	ff d0                	callq  *%rax
}
  803cc2:	c9                   	leaveq 
  803cc3:	c3                   	retq   

0000000000803cc4 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803cc4:	55                   	push   %rbp
  803cc5:	48 89 e5             	mov    %rsp,%rbp
  803cc8:	48 83 ec 10          	sub    $0x10,%rsp
  803ccc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ccf:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803cd2:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cd9:	00 00 00 
  803cdc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803cdf:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803ce1:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ce8:	00 00 00 
  803ceb:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803cee:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803cf1:	bf 03 00 00 00       	mov    $0x3,%edi
  803cf6:	48 b8 60 3b 80 00 00 	movabs $0x803b60,%rax
  803cfd:	00 00 00 
  803d00:	ff d0                	callq  *%rax
}
  803d02:	c9                   	leaveq 
  803d03:	c3                   	retq   

0000000000803d04 <nsipc_close>:

int
nsipc_close(int s)
{
  803d04:	55                   	push   %rbp
  803d05:	48 89 e5             	mov    %rsp,%rbp
  803d08:	48 83 ec 10          	sub    $0x10,%rsp
  803d0c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803d0f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d16:	00 00 00 
  803d19:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803d1c:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803d1e:	bf 04 00 00 00       	mov    $0x4,%edi
  803d23:	48 b8 60 3b 80 00 00 	movabs $0x803b60,%rax
  803d2a:	00 00 00 
  803d2d:	ff d0                	callq  *%rax
}
  803d2f:	c9                   	leaveq 
  803d30:	c3                   	retq   

0000000000803d31 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803d31:	55                   	push   %rbp
  803d32:	48 89 e5             	mov    %rsp,%rbp
  803d35:	48 83 ec 10          	sub    $0x10,%rsp
  803d39:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803d3c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803d40:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803d43:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d4a:	00 00 00 
  803d4d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803d50:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803d52:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803d55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d59:	48 89 c6             	mov    %rax,%rsi
  803d5c:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803d63:	00 00 00 
  803d66:	48 b8 4d 15 80 00 00 	movabs $0x80154d,%rax
  803d6d:	00 00 00 
  803d70:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803d72:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d79:	00 00 00 
  803d7c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803d7f:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803d82:	bf 05 00 00 00       	mov    $0x5,%edi
  803d87:	48 b8 60 3b 80 00 00 	movabs $0x803b60,%rax
  803d8e:	00 00 00 
  803d91:	ff d0                	callq  *%rax
}
  803d93:	c9                   	leaveq 
  803d94:	c3                   	retq   

0000000000803d95 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803d95:	55                   	push   %rbp
  803d96:	48 89 e5             	mov    %rsp,%rbp
  803d99:	48 83 ec 10          	sub    $0x10,%rsp
  803d9d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803da0:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803da3:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803daa:	00 00 00 
  803dad:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803db0:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803db2:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803db9:	00 00 00 
  803dbc:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803dbf:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803dc2:	bf 06 00 00 00       	mov    $0x6,%edi
  803dc7:	48 b8 60 3b 80 00 00 	movabs $0x803b60,%rax
  803dce:	00 00 00 
  803dd1:	ff d0                	callq  *%rax
}
  803dd3:	c9                   	leaveq 
  803dd4:	c3                   	retq   

0000000000803dd5 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803dd5:	55                   	push   %rbp
  803dd6:	48 89 e5             	mov    %rsp,%rbp
  803dd9:	48 83 ec 30          	sub    $0x30,%rsp
  803ddd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803de0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803de4:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803de7:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803dea:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803df1:	00 00 00 
  803df4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803df7:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803df9:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e00:	00 00 00 
  803e03:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803e06:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803e09:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e10:	00 00 00 
  803e13:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803e16:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803e19:	bf 07 00 00 00       	mov    $0x7,%edi
  803e1e:	48 b8 60 3b 80 00 00 	movabs $0x803b60,%rax
  803e25:	00 00 00 
  803e28:	ff d0                	callq  *%rax
  803e2a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e2d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e31:	78 69                	js     803e9c <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803e33:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803e3a:	7f 08                	jg     803e44 <nsipc_recv+0x6f>
  803e3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e3f:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803e42:	7e 35                	jle    803e79 <nsipc_recv+0xa4>
  803e44:	48 b9 bf 51 80 00 00 	movabs $0x8051bf,%rcx
  803e4b:	00 00 00 
  803e4e:	48 ba d4 51 80 00 00 	movabs $0x8051d4,%rdx
  803e55:	00 00 00 
  803e58:	be 61 00 00 00       	mov    $0x61,%esi
  803e5d:	48 bf e9 51 80 00 00 	movabs $0x8051e9,%rdi
  803e64:	00 00 00 
  803e67:	b8 00 00 00 00       	mov    $0x0,%eax
  803e6c:	49 b8 3b 04 80 00 00 	movabs $0x80043b,%r8
  803e73:	00 00 00 
  803e76:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803e79:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e7c:	48 63 d0             	movslq %eax,%rdx
  803e7f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e83:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803e8a:	00 00 00 
  803e8d:	48 89 c7             	mov    %rax,%rdi
  803e90:	48 b8 4d 15 80 00 00 	movabs $0x80154d,%rax
  803e97:	00 00 00 
  803e9a:	ff d0                	callq  *%rax
	}

	return r;
  803e9c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803e9f:	c9                   	leaveq 
  803ea0:	c3                   	retq   

0000000000803ea1 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803ea1:	55                   	push   %rbp
  803ea2:	48 89 e5             	mov    %rsp,%rbp
  803ea5:	48 83 ec 20          	sub    $0x20,%rsp
  803ea9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803eac:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803eb0:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803eb3:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803eb6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ebd:	00 00 00 
  803ec0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803ec3:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803ec5:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803ecc:	7e 35                	jle    803f03 <nsipc_send+0x62>
  803ece:	48 b9 f5 51 80 00 00 	movabs $0x8051f5,%rcx
  803ed5:	00 00 00 
  803ed8:	48 ba d4 51 80 00 00 	movabs $0x8051d4,%rdx
  803edf:	00 00 00 
  803ee2:	be 6c 00 00 00       	mov    $0x6c,%esi
  803ee7:	48 bf e9 51 80 00 00 	movabs $0x8051e9,%rdi
  803eee:	00 00 00 
  803ef1:	b8 00 00 00 00       	mov    $0x0,%eax
  803ef6:	49 b8 3b 04 80 00 00 	movabs $0x80043b,%r8
  803efd:	00 00 00 
  803f00:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803f03:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f06:	48 63 d0             	movslq %eax,%rdx
  803f09:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f0d:	48 89 c6             	mov    %rax,%rsi
  803f10:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803f17:	00 00 00 
  803f1a:	48 b8 4d 15 80 00 00 	movabs $0x80154d,%rax
  803f21:	00 00 00 
  803f24:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803f26:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f2d:	00 00 00 
  803f30:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803f33:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803f36:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f3d:	00 00 00 
  803f40:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803f43:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803f46:	bf 08 00 00 00       	mov    $0x8,%edi
  803f4b:	48 b8 60 3b 80 00 00 	movabs $0x803b60,%rax
  803f52:	00 00 00 
  803f55:	ff d0                	callq  *%rax
}
  803f57:	c9                   	leaveq 
  803f58:	c3                   	retq   

0000000000803f59 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803f59:	55                   	push   %rbp
  803f5a:	48 89 e5             	mov    %rsp,%rbp
  803f5d:	48 83 ec 10          	sub    $0x10,%rsp
  803f61:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803f64:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803f67:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803f6a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f71:	00 00 00 
  803f74:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803f77:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803f79:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f80:	00 00 00 
  803f83:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803f86:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803f89:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f90:	00 00 00 
  803f93:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803f96:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803f99:	bf 09 00 00 00       	mov    $0x9,%edi
  803f9e:	48 b8 60 3b 80 00 00 	movabs $0x803b60,%rax
  803fa5:	00 00 00 
  803fa8:	ff d0                	callq  *%rax
}
  803faa:	c9                   	leaveq 
  803fab:	c3                   	retq   

0000000000803fac <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803fac:	55                   	push   %rbp
  803fad:	48 89 e5             	mov    %rsp,%rbp
  803fb0:	53                   	push   %rbx
  803fb1:	48 83 ec 38          	sub    $0x38,%rsp
  803fb5:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803fb9:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803fbd:	48 89 c7             	mov    %rax,%rdi
  803fc0:	48 b8 61 27 80 00 00 	movabs $0x802761,%rax
  803fc7:	00 00 00 
  803fca:	ff d0                	callq  *%rax
  803fcc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803fcf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803fd3:	0f 88 bf 01 00 00    	js     804198 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803fd9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fdd:	ba 07 04 00 00       	mov    $0x407,%edx
  803fe2:	48 89 c6             	mov    %rax,%rsi
  803fe5:	bf 00 00 00 00       	mov    $0x0,%edi
  803fea:	48 b8 58 1b 80 00 00 	movabs $0x801b58,%rax
  803ff1:	00 00 00 
  803ff4:	ff d0                	callq  *%rax
  803ff6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ff9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ffd:	0f 88 95 01 00 00    	js     804198 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  804003:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804007:	48 89 c7             	mov    %rax,%rdi
  80400a:	48 b8 61 27 80 00 00 	movabs $0x802761,%rax
  804011:	00 00 00 
  804014:	ff d0                	callq  *%rax
  804016:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804019:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80401d:	0f 88 5d 01 00 00    	js     804180 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804023:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804027:	ba 07 04 00 00       	mov    $0x407,%edx
  80402c:	48 89 c6             	mov    %rax,%rsi
  80402f:	bf 00 00 00 00       	mov    $0x0,%edi
  804034:	48 b8 58 1b 80 00 00 	movabs $0x801b58,%rax
  80403b:	00 00 00 
  80403e:	ff d0                	callq  *%rax
  804040:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804043:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804047:	0f 88 33 01 00 00    	js     804180 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80404d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804051:	48 89 c7             	mov    %rax,%rdi
  804054:	48 b8 36 27 80 00 00 	movabs $0x802736,%rax
  80405b:	00 00 00 
  80405e:	ff d0                	callq  *%rax
  804060:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804064:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804068:	ba 07 04 00 00       	mov    $0x407,%edx
  80406d:	48 89 c6             	mov    %rax,%rsi
  804070:	bf 00 00 00 00       	mov    $0x0,%edi
  804075:	48 b8 58 1b 80 00 00 	movabs $0x801b58,%rax
  80407c:	00 00 00 
  80407f:	ff d0                	callq  *%rax
  804081:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804084:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804088:	79 05                	jns    80408f <pipe+0xe3>
		goto err2;
  80408a:	e9 d9 00 00 00       	jmpq   804168 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80408f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804093:	48 89 c7             	mov    %rax,%rdi
  804096:	48 b8 36 27 80 00 00 	movabs $0x802736,%rax
  80409d:	00 00 00 
  8040a0:	ff d0                	callq  *%rax
  8040a2:	48 89 c2             	mov    %rax,%rdx
  8040a5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040a9:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8040af:	48 89 d1             	mov    %rdx,%rcx
  8040b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8040b7:	48 89 c6             	mov    %rax,%rsi
  8040ba:	bf 00 00 00 00       	mov    $0x0,%edi
  8040bf:	48 b8 a8 1b 80 00 00 	movabs $0x801ba8,%rax
  8040c6:	00 00 00 
  8040c9:	ff d0                	callq  *%rax
  8040cb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8040ce:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8040d2:	79 1b                	jns    8040ef <pipe+0x143>
		goto err3;
  8040d4:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8040d5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040d9:	48 89 c6             	mov    %rax,%rsi
  8040dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8040e1:	48 b8 03 1c 80 00 00 	movabs $0x801c03,%rax
  8040e8:	00 00 00 
  8040eb:	ff d0                	callq  *%rax
  8040ed:	eb 79                	jmp    804168 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8040ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040f3:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  8040fa:	00 00 00 
  8040fd:	8b 12                	mov    (%rdx),%edx
  8040ff:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  804101:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804105:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80410c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804110:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  804117:	00 00 00 
  80411a:	8b 12                	mov    (%rdx),%edx
  80411c:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80411e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804122:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  804129:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80412d:	48 89 c7             	mov    %rax,%rdi
  804130:	48 b8 13 27 80 00 00 	movabs $0x802713,%rax
  804137:	00 00 00 
  80413a:	ff d0                	callq  *%rax
  80413c:	89 c2                	mov    %eax,%edx
  80413e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804142:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  804144:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804148:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80414c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804150:	48 89 c7             	mov    %rax,%rdi
  804153:	48 b8 13 27 80 00 00 	movabs $0x802713,%rax
  80415a:	00 00 00 
  80415d:	ff d0                	callq  *%rax
  80415f:	89 03                	mov    %eax,(%rbx)
	return 0;
  804161:	b8 00 00 00 00       	mov    $0x0,%eax
  804166:	eb 33                	jmp    80419b <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  804168:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80416c:	48 89 c6             	mov    %rax,%rsi
  80416f:	bf 00 00 00 00       	mov    $0x0,%edi
  804174:	48 b8 03 1c 80 00 00 	movabs $0x801c03,%rax
  80417b:	00 00 00 
  80417e:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  804180:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804184:	48 89 c6             	mov    %rax,%rsi
  804187:	bf 00 00 00 00       	mov    $0x0,%edi
  80418c:	48 b8 03 1c 80 00 00 	movabs $0x801c03,%rax
  804193:	00 00 00 
  804196:	ff d0                	callq  *%rax
err:
	return r;
  804198:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80419b:	48 83 c4 38          	add    $0x38,%rsp
  80419f:	5b                   	pop    %rbx
  8041a0:	5d                   	pop    %rbp
  8041a1:	c3                   	retq   

00000000008041a2 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8041a2:	55                   	push   %rbp
  8041a3:	48 89 e5             	mov    %rsp,%rbp
  8041a6:	53                   	push   %rbx
  8041a7:	48 83 ec 28          	sub    $0x28,%rsp
  8041ab:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8041af:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8041b3:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8041ba:	00 00 00 
  8041bd:	48 8b 00             	mov    (%rax),%rax
  8041c0:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8041c6:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8041c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041cd:	48 89 c7             	mov    %rax,%rdi
  8041d0:	48 b8 17 37 80 00 00 	movabs $0x803717,%rax
  8041d7:	00 00 00 
  8041da:	ff d0                	callq  *%rax
  8041dc:	89 c3                	mov    %eax,%ebx
  8041de:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041e2:	48 89 c7             	mov    %rax,%rdi
  8041e5:	48 b8 17 37 80 00 00 	movabs $0x803717,%rax
  8041ec:	00 00 00 
  8041ef:	ff d0                	callq  *%rax
  8041f1:	39 c3                	cmp    %eax,%ebx
  8041f3:	0f 94 c0             	sete   %al
  8041f6:	0f b6 c0             	movzbl %al,%eax
  8041f9:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8041fc:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804203:	00 00 00 
  804206:	48 8b 00             	mov    (%rax),%rax
  804209:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80420f:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  804212:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804215:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804218:	75 05                	jne    80421f <_pipeisclosed+0x7d>
			return ret;
  80421a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80421d:	eb 4f                	jmp    80426e <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80421f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804222:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804225:	74 42                	je     804269 <_pipeisclosed+0xc7>
  804227:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80422b:	75 3c                	jne    804269 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80422d:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804234:	00 00 00 
  804237:	48 8b 00             	mov    (%rax),%rax
  80423a:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  804240:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804243:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804246:	89 c6                	mov    %eax,%esi
  804248:	48 bf 06 52 80 00 00 	movabs $0x805206,%rdi
  80424f:	00 00 00 
  804252:	b8 00 00 00 00       	mov    $0x0,%eax
  804257:	49 b8 74 06 80 00 00 	movabs $0x800674,%r8
  80425e:	00 00 00 
  804261:	41 ff d0             	callq  *%r8
	}
  804264:	e9 4a ff ff ff       	jmpq   8041b3 <_pipeisclosed+0x11>
  804269:	e9 45 ff ff ff       	jmpq   8041b3 <_pipeisclosed+0x11>
}
  80426e:	48 83 c4 28          	add    $0x28,%rsp
  804272:	5b                   	pop    %rbx
  804273:	5d                   	pop    %rbp
  804274:	c3                   	retq   

0000000000804275 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  804275:	55                   	push   %rbp
  804276:	48 89 e5             	mov    %rsp,%rbp
  804279:	48 83 ec 30          	sub    $0x30,%rsp
  80427d:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804280:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804284:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804287:	48 89 d6             	mov    %rdx,%rsi
  80428a:	89 c7                	mov    %eax,%edi
  80428c:	48 b8 f9 27 80 00 00 	movabs $0x8027f9,%rax
  804293:	00 00 00 
  804296:	ff d0                	callq  *%rax
  804298:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80429b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80429f:	79 05                	jns    8042a6 <pipeisclosed+0x31>
		return r;
  8042a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042a4:	eb 31                	jmp    8042d7 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8042a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042aa:	48 89 c7             	mov    %rax,%rdi
  8042ad:	48 b8 36 27 80 00 00 	movabs $0x802736,%rax
  8042b4:	00 00 00 
  8042b7:	ff d0                	callq  *%rax
  8042b9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8042bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042c1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8042c5:	48 89 d6             	mov    %rdx,%rsi
  8042c8:	48 89 c7             	mov    %rax,%rdi
  8042cb:	48 b8 a2 41 80 00 00 	movabs $0x8041a2,%rax
  8042d2:	00 00 00 
  8042d5:	ff d0                	callq  *%rax
}
  8042d7:	c9                   	leaveq 
  8042d8:	c3                   	retq   

00000000008042d9 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8042d9:	55                   	push   %rbp
  8042da:	48 89 e5             	mov    %rsp,%rbp
  8042dd:	48 83 ec 40          	sub    $0x40,%rsp
  8042e1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8042e5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8042e9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8042ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042f1:	48 89 c7             	mov    %rax,%rdi
  8042f4:	48 b8 36 27 80 00 00 	movabs $0x802736,%rax
  8042fb:	00 00 00 
  8042fe:	ff d0                	callq  *%rax
  804300:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804304:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804308:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80430c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804313:	00 
  804314:	e9 92 00 00 00       	jmpq   8043ab <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  804319:	eb 41                	jmp    80435c <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80431b:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804320:	74 09                	je     80432b <devpipe_read+0x52>
				return i;
  804322:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804326:	e9 92 00 00 00       	jmpq   8043bd <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80432b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80432f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804333:	48 89 d6             	mov    %rdx,%rsi
  804336:	48 89 c7             	mov    %rax,%rdi
  804339:	48 b8 a2 41 80 00 00 	movabs $0x8041a2,%rax
  804340:	00 00 00 
  804343:	ff d0                	callq  *%rax
  804345:	85 c0                	test   %eax,%eax
  804347:	74 07                	je     804350 <devpipe_read+0x77>
				return 0;
  804349:	b8 00 00 00 00       	mov    $0x0,%eax
  80434e:	eb 6d                	jmp    8043bd <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  804350:	48 b8 1a 1b 80 00 00 	movabs $0x801b1a,%rax
  804357:	00 00 00 
  80435a:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80435c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804360:	8b 10                	mov    (%rax),%edx
  804362:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804366:	8b 40 04             	mov    0x4(%rax),%eax
  804369:	39 c2                	cmp    %eax,%edx
  80436b:	74 ae                	je     80431b <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80436d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804371:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804375:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804379:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80437d:	8b 00                	mov    (%rax),%eax
  80437f:	99                   	cltd   
  804380:	c1 ea 1b             	shr    $0x1b,%edx
  804383:	01 d0                	add    %edx,%eax
  804385:	83 e0 1f             	and    $0x1f,%eax
  804388:	29 d0                	sub    %edx,%eax
  80438a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80438e:	48 98                	cltq   
  804390:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804395:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804397:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80439b:	8b 00                	mov    (%rax),%eax
  80439d:	8d 50 01             	lea    0x1(%rax),%edx
  8043a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043a4:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8043a6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8043ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043af:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8043b3:	0f 82 60 ff ff ff    	jb     804319 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8043b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8043bd:	c9                   	leaveq 
  8043be:	c3                   	retq   

00000000008043bf <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8043bf:	55                   	push   %rbp
  8043c0:	48 89 e5             	mov    %rsp,%rbp
  8043c3:	48 83 ec 40          	sub    $0x40,%rsp
  8043c7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8043cb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8043cf:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8043d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043d7:	48 89 c7             	mov    %rax,%rdi
  8043da:	48 b8 36 27 80 00 00 	movabs $0x802736,%rax
  8043e1:	00 00 00 
  8043e4:	ff d0                	callq  *%rax
  8043e6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8043ea:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8043ee:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8043f2:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8043f9:	00 
  8043fa:	e9 8e 00 00 00       	jmpq   80448d <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8043ff:	eb 31                	jmp    804432 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804401:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804405:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804409:	48 89 d6             	mov    %rdx,%rsi
  80440c:	48 89 c7             	mov    %rax,%rdi
  80440f:	48 b8 a2 41 80 00 00 	movabs $0x8041a2,%rax
  804416:	00 00 00 
  804419:	ff d0                	callq  *%rax
  80441b:	85 c0                	test   %eax,%eax
  80441d:	74 07                	je     804426 <devpipe_write+0x67>
				return 0;
  80441f:	b8 00 00 00 00       	mov    $0x0,%eax
  804424:	eb 79                	jmp    80449f <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804426:	48 b8 1a 1b 80 00 00 	movabs $0x801b1a,%rax
  80442d:	00 00 00 
  804430:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804432:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804436:	8b 40 04             	mov    0x4(%rax),%eax
  804439:	48 63 d0             	movslq %eax,%rdx
  80443c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804440:	8b 00                	mov    (%rax),%eax
  804442:	48 98                	cltq   
  804444:	48 83 c0 20          	add    $0x20,%rax
  804448:	48 39 c2             	cmp    %rax,%rdx
  80444b:	73 b4                	jae    804401 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80444d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804451:	8b 40 04             	mov    0x4(%rax),%eax
  804454:	99                   	cltd   
  804455:	c1 ea 1b             	shr    $0x1b,%edx
  804458:	01 d0                	add    %edx,%eax
  80445a:	83 e0 1f             	and    $0x1f,%eax
  80445d:	29 d0                	sub    %edx,%eax
  80445f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804463:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804467:	48 01 ca             	add    %rcx,%rdx
  80446a:	0f b6 0a             	movzbl (%rdx),%ecx
  80446d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804471:	48 98                	cltq   
  804473:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804477:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80447b:	8b 40 04             	mov    0x4(%rax),%eax
  80447e:	8d 50 01             	lea    0x1(%rax),%edx
  804481:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804485:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804488:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80448d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804491:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804495:	0f 82 64 ff ff ff    	jb     8043ff <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80449b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80449f:	c9                   	leaveq 
  8044a0:	c3                   	retq   

00000000008044a1 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8044a1:	55                   	push   %rbp
  8044a2:	48 89 e5             	mov    %rsp,%rbp
  8044a5:	48 83 ec 20          	sub    $0x20,%rsp
  8044a9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8044ad:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8044b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044b5:	48 89 c7             	mov    %rax,%rdi
  8044b8:	48 b8 36 27 80 00 00 	movabs $0x802736,%rax
  8044bf:	00 00 00 
  8044c2:	ff d0                	callq  *%rax
  8044c4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8044c8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8044cc:	48 be 19 52 80 00 00 	movabs $0x805219,%rsi
  8044d3:	00 00 00 
  8044d6:	48 89 c7             	mov    %rax,%rdi
  8044d9:	48 b8 29 12 80 00 00 	movabs $0x801229,%rax
  8044e0:	00 00 00 
  8044e3:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8044e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044e9:	8b 50 04             	mov    0x4(%rax),%edx
  8044ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044f0:	8b 00                	mov    (%rax),%eax
  8044f2:	29 c2                	sub    %eax,%edx
  8044f4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8044f8:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8044fe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804502:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804509:	00 00 00 
	stat->st_dev = &devpipe;
  80450c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804510:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  804517:	00 00 00 
  80451a:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804521:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804526:	c9                   	leaveq 
  804527:	c3                   	retq   

0000000000804528 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804528:	55                   	push   %rbp
  804529:	48 89 e5             	mov    %rsp,%rbp
  80452c:	48 83 ec 10          	sub    $0x10,%rsp
  804530:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  804534:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804538:	48 89 c6             	mov    %rax,%rsi
  80453b:	bf 00 00 00 00       	mov    $0x0,%edi
  804540:	48 b8 03 1c 80 00 00 	movabs $0x801c03,%rax
  804547:	00 00 00 
  80454a:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80454c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804550:	48 89 c7             	mov    %rax,%rdi
  804553:	48 b8 36 27 80 00 00 	movabs $0x802736,%rax
  80455a:	00 00 00 
  80455d:	ff d0                	callq  *%rax
  80455f:	48 89 c6             	mov    %rax,%rsi
  804562:	bf 00 00 00 00       	mov    $0x0,%edi
  804567:	48 b8 03 1c 80 00 00 	movabs $0x801c03,%rax
  80456e:	00 00 00 
  804571:	ff d0                	callq  *%rax
}
  804573:	c9                   	leaveq 
  804574:	c3                   	retq   

0000000000804575 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804575:	55                   	push   %rbp
  804576:	48 89 e5             	mov    %rsp,%rbp
  804579:	48 83 ec 20          	sub    $0x20,%rsp
  80457d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804580:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804583:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804586:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80458a:	be 01 00 00 00       	mov    $0x1,%esi
  80458f:	48 89 c7             	mov    %rax,%rdi
  804592:	48 b8 10 1a 80 00 00 	movabs $0x801a10,%rax
  804599:	00 00 00 
  80459c:	ff d0                	callq  *%rax
}
  80459e:	c9                   	leaveq 
  80459f:	c3                   	retq   

00000000008045a0 <getchar>:

int
getchar(void)
{
  8045a0:	55                   	push   %rbp
  8045a1:	48 89 e5             	mov    %rsp,%rbp
  8045a4:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8045a8:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8045ac:	ba 01 00 00 00       	mov    $0x1,%edx
  8045b1:	48 89 c6             	mov    %rax,%rsi
  8045b4:	bf 00 00 00 00       	mov    $0x0,%edi
  8045b9:	48 b8 2b 2c 80 00 00 	movabs $0x802c2b,%rax
  8045c0:	00 00 00 
  8045c3:	ff d0                	callq  *%rax
  8045c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8045c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045cc:	79 05                	jns    8045d3 <getchar+0x33>
		return r;
  8045ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045d1:	eb 14                	jmp    8045e7 <getchar+0x47>
	if (r < 1)
  8045d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045d7:	7f 07                	jg     8045e0 <getchar+0x40>
		return -E_EOF;
  8045d9:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8045de:	eb 07                	jmp    8045e7 <getchar+0x47>
	return c;
  8045e0:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8045e4:	0f b6 c0             	movzbl %al,%eax
}
  8045e7:	c9                   	leaveq 
  8045e8:	c3                   	retq   

00000000008045e9 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8045e9:	55                   	push   %rbp
  8045ea:	48 89 e5             	mov    %rsp,%rbp
  8045ed:	48 83 ec 20          	sub    $0x20,%rsp
  8045f1:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8045f4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8045f8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8045fb:	48 89 d6             	mov    %rdx,%rsi
  8045fe:	89 c7                	mov    %eax,%edi
  804600:	48 b8 f9 27 80 00 00 	movabs $0x8027f9,%rax
  804607:	00 00 00 
  80460a:	ff d0                	callq  *%rax
  80460c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80460f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804613:	79 05                	jns    80461a <iscons+0x31>
		return r;
  804615:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804618:	eb 1a                	jmp    804634 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80461a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80461e:	8b 10                	mov    (%rax),%edx
  804620:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  804627:	00 00 00 
  80462a:	8b 00                	mov    (%rax),%eax
  80462c:	39 c2                	cmp    %eax,%edx
  80462e:	0f 94 c0             	sete   %al
  804631:	0f b6 c0             	movzbl %al,%eax
}
  804634:	c9                   	leaveq 
  804635:	c3                   	retq   

0000000000804636 <opencons>:

int
opencons(void)
{
  804636:	55                   	push   %rbp
  804637:	48 89 e5             	mov    %rsp,%rbp
  80463a:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80463e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804642:	48 89 c7             	mov    %rax,%rdi
  804645:	48 b8 61 27 80 00 00 	movabs $0x802761,%rax
  80464c:	00 00 00 
  80464f:	ff d0                	callq  *%rax
  804651:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804654:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804658:	79 05                	jns    80465f <opencons+0x29>
		return r;
  80465a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80465d:	eb 5b                	jmp    8046ba <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80465f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804663:	ba 07 04 00 00       	mov    $0x407,%edx
  804668:	48 89 c6             	mov    %rax,%rsi
  80466b:	bf 00 00 00 00       	mov    $0x0,%edi
  804670:	48 b8 58 1b 80 00 00 	movabs $0x801b58,%rax
  804677:	00 00 00 
  80467a:	ff d0                	callq  *%rax
  80467c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80467f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804683:	79 05                	jns    80468a <opencons+0x54>
		return r;
  804685:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804688:	eb 30                	jmp    8046ba <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80468a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80468e:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  804695:	00 00 00 
  804698:	8b 12                	mov    (%rdx),%edx
  80469a:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80469c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046a0:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8046a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046ab:	48 89 c7             	mov    %rax,%rdi
  8046ae:	48 b8 13 27 80 00 00 	movabs $0x802713,%rax
  8046b5:	00 00 00 
  8046b8:	ff d0                	callq  *%rax
}
  8046ba:	c9                   	leaveq 
  8046bb:	c3                   	retq   

00000000008046bc <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8046bc:	55                   	push   %rbp
  8046bd:	48 89 e5             	mov    %rsp,%rbp
  8046c0:	48 83 ec 30          	sub    $0x30,%rsp
  8046c4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8046c8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8046cc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8046d0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8046d5:	75 07                	jne    8046de <devcons_read+0x22>
		return 0;
  8046d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8046dc:	eb 4b                	jmp    804729 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8046de:	eb 0c                	jmp    8046ec <devcons_read+0x30>
		sys_yield();
  8046e0:	48 b8 1a 1b 80 00 00 	movabs $0x801b1a,%rax
  8046e7:	00 00 00 
  8046ea:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8046ec:	48 b8 5a 1a 80 00 00 	movabs $0x801a5a,%rax
  8046f3:	00 00 00 
  8046f6:	ff d0                	callq  *%rax
  8046f8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8046fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8046ff:	74 df                	je     8046e0 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  804701:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804705:	79 05                	jns    80470c <devcons_read+0x50>
		return c;
  804707:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80470a:	eb 1d                	jmp    804729 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80470c:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804710:	75 07                	jne    804719 <devcons_read+0x5d>
		return 0;
  804712:	b8 00 00 00 00       	mov    $0x0,%eax
  804717:	eb 10                	jmp    804729 <devcons_read+0x6d>
	*(char*)vbuf = c;
  804719:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80471c:	89 c2                	mov    %eax,%edx
  80471e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804722:	88 10                	mov    %dl,(%rax)
	return 1;
  804724:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804729:	c9                   	leaveq 
  80472a:	c3                   	retq   

000000000080472b <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80472b:	55                   	push   %rbp
  80472c:	48 89 e5             	mov    %rsp,%rbp
  80472f:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804736:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80473d:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804744:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80474b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804752:	eb 76                	jmp    8047ca <devcons_write+0x9f>
		m = n - tot;
  804754:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80475b:	89 c2                	mov    %eax,%edx
  80475d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804760:	29 c2                	sub    %eax,%edx
  804762:	89 d0                	mov    %edx,%eax
  804764:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804767:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80476a:	83 f8 7f             	cmp    $0x7f,%eax
  80476d:	76 07                	jbe    804776 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80476f:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804776:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804779:	48 63 d0             	movslq %eax,%rdx
  80477c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80477f:	48 63 c8             	movslq %eax,%rcx
  804782:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804789:	48 01 c1             	add    %rax,%rcx
  80478c:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804793:	48 89 ce             	mov    %rcx,%rsi
  804796:	48 89 c7             	mov    %rax,%rdi
  804799:	48 b8 4d 15 80 00 00 	movabs $0x80154d,%rax
  8047a0:	00 00 00 
  8047a3:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8047a5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8047a8:	48 63 d0             	movslq %eax,%rdx
  8047ab:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8047b2:	48 89 d6             	mov    %rdx,%rsi
  8047b5:	48 89 c7             	mov    %rax,%rdi
  8047b8:	48 b8 10 1a 80 00 00 	movabs $0x801a10,%rax
  8047bf:	00 00 00 
  8047c2:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8047c4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8047c7:	01 45 fc             	add    %eax,-0x4(%rbp)
  8047ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047cd:	48 98                	cltq   
  8047cf:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8047d6:	0f 82 78 ff ff ff    	jb     804754 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8047dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8047df:	c9                   	leaveq 
  8047e0:	c3                   	retq   

00000000008047e1 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8047e1:	55                   	push   %rbp
  8047e2:	48 89 e5             	mov    %rsp,%rbp
  8047e5:	48 83 ec 08          	sub    $0x8,%rsp
  8047e9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8047ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8047f2:	c9                   	leaveq 
  8047f3:	c3                   	retq   

00000000008047f4 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8047f4:	55                   	push   %rbp
  8047f5:	48 89 e5             	mov    %rsp,%rbp
  8047f8:	48 83 ec 10          	sub    $0x10,%rsp
  8047fc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804800:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804804:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804808:	48 be 25 52 80 00 00 	movabs $0x805225,%rsi
  80480f:	00 00 00 
  804812:	48 89 c7             	mov    %rax,%rdi
  804815:	48 b8 29 12 80 00 00 	movabs $0x801229,%rax
  80481c:	00 00 00 
  80481f:	ff d0                	callq  *%rax
	return 0;
  804821:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804826:	c9                   	leaveq 
  804827:	c3                   	retq   

0000000000804828 <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804828:	55                   	push   %rbp
  804829:	48 89 e5             	mov    %rsp,%rbp
  80482c:	48 83 ec 10          	sub    $0x10,%rsp
  804830:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  804834:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80483b:	00 00 00 
  80483e:	48 8b 00             	mov    (%rax),%rax
  804841:	48 85 c0             	test   %rax,%rax
  804844:	0f 85 84 00 00 00    	jne    8048ce <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  80484a:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804851:	00 00 00 
  804854:	48 8b 00             	mov    (%rax),%rax
  804857:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80485d:	ba 07 00 00 00       	mov    $0x7,%edx
  804862:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  804867:	89 c7                	mov    %eax,%edi
  804869:	48 b8 58 1b 80 00 00 	movabs $0x801b58,%rax
  804870:	00 00 00 
  804873:	ff d0                	callq  *%rax
  804875:	85 c0                	test   %eax,%eax
  804877:	79 2a                	jns    8048a3 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  804879:	48 ba 30 52 80 00 00 	movabs $0x805230,%rdx
  804880:	00 00 00 
  804883:	be 23 00 00 00       	mov    $0x23,%esi
  804888:	48 bf 57 52 80 00 00 	movabs $0x805257,%rdi
  80488f:	00 00 00 
  804892:	b8 00 00 00 00       	mov    $0x0,%eax
  804897:	48 b9 3b 04 80 00 00 	movabs $0x80043b,%rcx
  80489e:	00 00 00 
  8048a1:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  8048a3:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8048aa:	00 00 00 
  8048ad:	48 8b 00             	mov    (%rax),%rax
  8048b0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8048b6:	48 be e1 48 80 00 00 	movabs $0x8048e1,%rsi
  8048bd:	00 00 00 
  8048c0:	89 c7                	mov    %eax,%edi
  8048c2:	48 b8 e2 1c 80 00 00 	movabs $0x801ce2,%rax
  8048c9:	00 00 00 
  8048cc:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  8048ce:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8048d5:	00 00 00 
  8048d8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8048dc:	48 89 10             	mov    %rdx,(%rax)
}
  8048df:	c9                   	leaveq 
  8048e0:	c3                   	retq   

00000000008048e1 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  8048e1:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  8048e4:	48 a1 00 c0 80 00 00 	movabs 0x80c000,%rax
  8048eb:	00 00 00 
call *%rax
  8048ee:	ff d0                	callq  *%rax
    // LAB 4: Your code here.

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.

	movq 136(%rsp), %rbx  //Load RIP 
  8048f0:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8048f7:	00 
	movq 152(%rsp), %rcx  //Load RSP
  8048f8:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  8048ff:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  804900:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  804904:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  804907:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  80490e:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  80490f:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  804913:	4c 8b 3c 24          	mov    (%rsp),%r15
  804917:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  80491c:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804921:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804926:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  80492b:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804930:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804935:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80493a:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  80493f:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804944:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804949:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  80494e:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804953:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804958:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  80495d:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  804961:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  804965:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  804966:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  804967:	c3                   	retq   
