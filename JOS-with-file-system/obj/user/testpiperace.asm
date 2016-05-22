
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
  800052:	48 bf c0 3e 80 00 00 	movabs $0x803ec0,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 74 06 80 00 00 	movabs $0x800674,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	if ((r = pipe(p)) < 0)
  80006d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800071:	48 89 c7             	mov    %rax,%rdi
  800074:	48 b8 fb 34 80 00 00 	movabs $0x8034fb,%rax
  80007b:	00 00 00 
  80007e:	ff d0                	callq  *%rax
  800080:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800083:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800087:	79 30                	jns    8000b9 <umain+0x76>
		panic("pipe: %e", r);
  800089:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80008c:	89 c1                	mov    %eax,%ecx
  80008e:	48 ba d9 3e 80 00 00 	movabs $0x803ed9,%rdx
  800095:	00 00 00 
  800098:	be 0d 00 00 00       	mov    $0xd,%esi
  80009d:	48 bf e2 3e 80 00 00 	movabs $0x803ee2,%rdi
  8000a4:	00 00 00 
  8000a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ac:	49 b8 3b 04 80 00 00 	movabs $0x80043b,%r8
  8000b3:	00 00 00 
  8000b6:	41 ff d0             	callq  *%r8
	max = 200;
  8000b9:	c7 45 f4 c8 00 00 00 	movl   $0xc8,-0xc(%rbp)
	if ((r = fork()) < 0)
  8000c0:	48 b8 ae 21 80 00 00 	movabs $0x8021ae,%rax
  8000c7:	00 00 00 
  8000ca:	ff d0                	callq  *%rax
  8000cc:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000cf:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000d3:	79 30                	jns    800105 <umain+0xc2>
		panic("fork: %e", r);
  8000d5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d8:	89 c1                	mov    %eax,%ecx
  8000da:	48 ba f6 3e 80 00 00 	movabs $0x803ef6,%rdx
  8000e1:	00 00 00 
  8000e4:	be 10 00 00 00       	mov    $0x10,%esi
  8000e9:	48 bf e2 3e 80 00 00 	movabs $0x803ee2,%rdi
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
  800114:	48 b8 3f 29 80 00 00 	movabs $0x80293f,%rax
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
  80012e:	48 b8 c4 37 80 00 00 	movabs $0x8037c4,%rax
  800135:	00 00 00 
  800138:	ff d0                	callq  *%rax
  80013a:	85 c0                	test   %eax,%eax
  80013c:	74 27                	je     800165 <umain+0x122>
				cprintf("RACE: pipe appears closed\n");
  80013e:	48 bf ff 3e 80 00 00 	movabs $0x803eff,%rdi
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
  80018c:	48 b8 5f 24 80 00 00 	movabs $0x80245f,%rax
  800193:	00 00 00 
  800196:	ff d0                	callq  *%rax
	}
	pid = r;
  800198:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80019b:	89 45 f0             	mov    %eax,-0x10(%rbp)
	cprintf("pid is %d\n", pid);
  80019e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001a1:	89 c6                	mov    %eax,%esi
  8001a3:	48 bf 1a 3f 80 00 00 	movabs $0x803f1a,%rdi
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
  80021c:	48 bf 25 3f 80 00 00 	movabs $0x803f25,%rdi
  800223:	00 00 00 
  800226:	b8 00 00 00 00       	mov    $0x0,%eax
  80022b:	48 ba 74 06 80 00 00 	movabs $0x800674,%rdx
  800232:	00 00 00 
  800235:	ff d2                	callq  *%rdx
	dup(p[0], 10);
  800237:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80023a:	be 0a 00 00 00       	mov    $0xa,%esi
  80023f:	89 c7                	mov    %eax,%edi
  800241:	48 b8 b8 29 80 00 00 	movabs $0x8029b8,%rax
  800248:	00 00 00 
  80024b:	ff d0                	callq  *%rax
	while (kid->env_status == ENV_RUNNABLE)
  80024d:	eb 16                	jmp    800265 <umain+0x222>
		dup(p[0], 10);
  80024f:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800252:	be 0a 00 00 00       	mov    $0xa,%esi
  800257:	89 c7                	mov    %eax,%edi
  800259:	48 b8 b8 29 80 00 00 	movabs $0x8029b8,%rax
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
  800274:	48 bf 30 3f 80 00 00 	movabs $0x803f30,%rdi
  80027b:	00 00 00 
  80027e:	b8 00 00 00 00       	mov    $0x0,%eax
  800283:	48 ba 74 06 80 00 00 	movabs $0x800674,%rdx
  80028a:	00 00 00 
  80028d:	ff d2                	callq  *%rdx
	if (pipeisclosed(p[0]))
  80028f:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800292:	89 c7                	mov    %eax,%edi
  800294:	48 b8 c4 37 80 00 00 	movabs $0x8037c4,%rax
  80029b:	00 00 00 
  80029e:	ff d0                	callq  *%rax
  8002a0:	85 c0                	test   %eax,%eax
  8002a2:	74 2a                	je     8002ce <umain+0x28b>
		panic("somehow the other end of p[0] got closed!");
  8002a4:	48 ba 48 3f 80 00 00 	movabs $0x803f48,%rdx
  8002ab:	00 00 00 
  8002ae:	be 3a 00 00 00       	mov    $0x3a,%esi
  8002b3:	48 bf e2 3e 80 00 00 	movabs $0x803ee2,%rdi
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
  8002da:	48 b8 2f 27 80 00 00 	movabs $0x80272f,%rax
  8002e1:	00 00 00 
  8002e4:	ff d0                	callq  *%rax
  8002e6:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8002e9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8002ed:	79 30                	jns    80031f <umain+0x2dc>
		panic("cannot look up p[0]: %e", r);
  8002ef:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002f2:	89 c1                	mov    %eax,%ecx
  8002f4:	48 ba 72 3f 80 00 00 	movabs $0x803f72,%rdx
  8002fb:	00 00 00 
  8002fe:	be 3c 00 00 00       	mov    $0x3c,%esi
  800303:	48 bf e2 3e 80 00 00 	movabs $0x803ee2,%rdi
  80030a:	00 00 00 
  80030d:	b8 00 00 00 00       	mov    $0x0,%eax
  800312:	49 b8 3b 04 80 00 00 	movabs $0x80043b,%r8
  800319:	00 00 00 
  80031c:	41 ff d0             	callq  *%r8
	va = fd2data(fd);
  80031f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800323:	48 89 c7             	mov    %rax,%rdi
  800326:	48 b8 6c 26 80 00 00 	movabs $0x80266c,%rax
  80032d:	00 00 00 
  800330:	ff d0                	callq  *%rax
  800332:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	if (pageref(va) != 3+1)
  800336:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80033a:	48 89 c7             	mov    %rax,%rdi
  80033d:	48 b8 72 34 80 00 00 	movabs $0x803472,%rax
  800344:	00 00 00 
  800347:	ff d0                	callq  *%rax
  800349:	83 f8 04             	cmp    $0x4,%eax
  80034c:	74 1d                	je     80036b <umain+0x328>
		cprintf("\nchild detected race\n");
  80034e:	48 bf 8a 3f 80 00 00 	movabs $0x803f8a,%rdi
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
  800370:	48 bf a0 3f 80 00 00 	movabs $0x803fa0,%rdi
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
  8003cb:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
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
  8003e5:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
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
  80041c:	48 b8 8a 29 80 00 00 	movabs $0x80298a,%rax
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
  8004c4:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
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
  8004f5:	48 bf c0 3f 80 00 00 	movabs $0x803fc0,%rdi
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
  800531:	48 bf e3 3f 80 00 00 	movabs $0x803fe3,%rdi
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
  8007e0:	48 ba c8 41 80 00 00 	movabs $0x8041c8,%rdx
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
  800ad8:	48 b8 f0 41 80 00 00 	movabs $0x8041f0,%rax
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
  800c26:	83 fb 10             	cmp    $0x10,%ebx
  800c29:	7f 16                	jg     800c41 <vprintfmt+0x21a>
  800c2b:	48 b8 40 41 80 00 00 	movabs $0x804140,%rax
  800c32:	00 00 00 
  800c35:	48 63 d3             	movslq %ebx,%rdx
  800c38:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800c3c:	4d 85 e4             	test   %r12,%r12
  800c3f:	75 2e                	jne    800c6f <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800c41:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c45:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c49:	89 d9                	mov    %ebx,%ecx
  800c4b:	48 ba d9 41 80 00 00 	movabs $0x8041d9,%rdx
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
  800c7a:	48 ba e2 41 80 00 00 	movabs $0x8041e2,%rdx
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
  800cd4:	49 bc e5 41 80 00 00 	movabs $0x8041e5,%r12
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
  8019da:	48 ba a0 44 80 00 00 	movabs $0x8044a0,%rdx
  8019e1:	00 00 00 
  8019e4:	be 23 00 00 00       	mov    $0x23,%esi
  8019e9:	48 bf bd 44 80 00 00 	movabs $0x8044bd,%rdi
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

0000000000801dc5 <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  801dc5:	55                   	push   %rbp
  801dc6:	48 89 e5             	mov    %rsp,%rbp
  801dc9:	48 83 ec 30          	sub    $0x30,%rsp
  801dcd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801dd1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dd5:	48 8b 00             	mov    (%rax),%rax
  801dd8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801ddc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801de0:	48 8b 40 08          	mov    0x8(%rax),%rax
  801de4:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801de7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801dea:	83 e0 02             	and    $0x2,%eax
  801ded:	85 c0                	test   %eax,%eax
  801def:	75 4d                	jne    801e3e <pgfault+0x79>
  801df1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801df5:	48 c1 e8 0c          	shr    $0xc,%rax
  801df9:	48 89 c2             	mov    %rax,%rdx
  801dfc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e03:	01 00 00 
  801e06:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e0a:	25 00 08 00 00       	and    $0x800,%eax
  801e0f:	48 85 c0             	test   %rax,%rax
  801e12:	74 2a                	je     801e3e <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  801e14:	48 ba d0 44 80 00 00 	movabs $0x8044d0,%rdx
  801e1b:	00 00 00 
  801e1e:	be 23 00 00 00       	mov    $0x23,%esi
  801e23:	48 bf 05 45 80 00 00 	movabs $0x804505,%rdi
  801e2a:	00 00 00 
  801e2d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e32:	48 b9 3b 04 80 00 00 	movabs $0x80043b,%rcx
  801e39:	00 00 00 
  801e3c:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  801e3e:	ba 07 00 00 00       	mov    $0x7,%edx
  801e43:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801e48:	bf 00 00 00 00       	mov    $0x0,%edi
  801e4d:	48 b8 58 1b 80 00 00 	movabs $0x801b58,%rax
  801e54:	00 00 00 
  801e57:	ff d0                	callq  *%rax
  801e59:	85 c0                	test   %eax,%eax
  801e5b:	0f 85 cd 00 00 00    	jne    801f2e <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801e61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e65:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801e69:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e6d:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801e73:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801e77:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e7b:	ba 00 10 00 00       	mov    $0x1000,%edx
  801e80:	48 89 c6             	mov    %rax,%rsi
  801e83:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801e88:	48 b8 4d 15 80 00 00 	movabs $0x80154d,%rax
  801e8f:	00 00 00 
  801e92:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801e94:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e98:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801e9e:	48 89 c1             	mov    %rax,%rcx
  801ea1:	ba 00 00 00 00       	mov    $0x0,%edx
  801ea6:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801eab:	bf 00 00 00 00       	mov    $0x0,%edi
  801eb0:	48 b8 a8 1b 80 00 00 	movabs $0x801ba8,%rax
  801eb7:	00 00 00 
  801eba:	ff d0                	callq  *%rax
  801ebc:	85 c0                	test   %eax,%eax
  801ebe:	79 2a                	jns    801eea <pgfault+0x125>
				panic("Page map at temp address failed");
  801ec0:	48 ba 10 45 80 00 00 	movabs $0x804510,%rdx
  801ec7:	00 00 00 
  801eca:	be 30 00 00 00       	mov    $0x30,%esi
  801ecf:	48 bf 05 45 80 00 00 	movabs $0x804505,%rdi
  801ed6:	00 00 00 
  801ed9:	b8 00 00 00 00       	mov    $0x0,%eax
  801ede:	48 b9 3b 04 80 00 00 	movabs $0x80043b,%rcx
  801ee5:	00 00 00 
  801ee8:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801eea:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801eef:	bf 00 00 00 00       	mov    $0x0,%edi
  801ef4:	48 b8 03 1c 80 00 00 	movabs $0x801c03,%rax
  801efb:	00 00 00 
  801efe:	ff d0                	callq  *%rax
  801f00:	85 c0                	test   %eax,%eax
  801f02:	79 54                	jns    801f58 <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801f04:	48 ba 30 45 80 00 00 	movabs $0x804530,%rdx
  801f0b:	00 00 00 
  801f0e:	be 32 00 00 00       	mov    $0x32,%esi
  801f13:	48 bf 05 45 80 00 00 	movabs $0x804505,%rdi
  801f1a:	00 00 00 
  801f1d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f22:	48 b9 3b 04 80 00 00 	movabs $0x80043b,%rcx
  801f29:	00 00 00 
  801f2c:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  801f2e:	48 ba 58 45 80 00 00 	movabs $0x804558,%rdx
  801f35:	00 00 00 
  801f38:	be 34 00 00 00       	mov    $0x34,%esi
  801f3d:	48 bf 05 45 80 00 00 	movabs $0x804505,%rdi
  801f44:	00 00 00 
  801f47:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4c:	48 b9 3b 04 80 00 00 	movabs $0x80043b,%rcx
  801f53:	00 00 00 
  801f56:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  801f58:	c9                   	leaveq 
  801f59:	c3                   	retq   

0000000000801f5a <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801f5a:	55                   	push   %rbp
  801f5b:	48 89 e5             	mov    %rsp,%rbp
  801f5e:	48 83 ec 20          	sub    $0x20,%rsp
  801f62:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f65:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  801f68:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f6f:	01 00 00 
  801f72:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801f75:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f79:	25 07 0e 00 00       	and    $0xe07,%eax
  801f7e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801f81:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801f84:	48 c1 e0 0c          	shl    $0xc,%rax
  801f88:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  801f8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f8f:	25 00 04 00 00       	and    $0x400,%eax
  801f94:	85 c0                	test   %eax,%eax
  801f96:	74 57                	je     801fef <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801f98:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801f9b:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801f9f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801fa2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fa6:	41 89 f0             	mov    %esi,%r8d
  801fa9:	48 89 c6             	mov    %rax,%rsi
  801fac:	bf 00 00 00 00       	mov    $0x0,%edi
  801fb1:	48 b8 a8 1b 80 00 00 	movabs $0x801ba8,%rax
  801fb8:	00 00 00 
  801fbb:	ff d0                	callq  *%rax
  801fbd:	85 c0                	test   %eax,%eax
  801fbf:	0f 8e 52 01 00 00    	jle    802117 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801fc5:	48 ba 8a 45 80 00 00 	movabs $0x80458a,%rdx
  801fcc:	00 00 00 
  801fcf:	be 4e 00 00 00       	mov    $0x4e,%esi
  801fd4:	48 bf 05 45 80 00 00 	movabs $0x804505,%rdi
  801fdb:	00 00 00 
  801fde:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe3:	48 b9 3b 04 80 00 00 	movabs $0x80043b,%rcx
  801fea:	00 00 00 
  801fed:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  801fef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ff2:	83 e0 02             	and    $0x2,%eax
  801ff5:	85 c0                	test   %eax,%eax
  801ff7:	75 10                	jne    802009 <duppage+0xaf>
  801ff9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ffc:	25 00 08 00 00       	and    $0x800,%eax
  802001:	85 c0                	test   %eax,%eax
  802003:	0f 84 bb 00 00 00    	je     8020c4 <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  802009:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80200c:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  802011:	80 cc 08             	or     $0x8,%ah
  802014:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  802017:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80201a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80201e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802021:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802025:	41 89 f0             	mov    %esi,%r8d
  802028:	48 89 c6             	mov    %rax,%rsi
  80202b:	bf 00 00 00 00       	mov    $0x0,%edi
  802030:	48 b8 a8 1b 80 00 00 	movabs $0x801ba8,%rax
  802037:	00 00 00 
  80203a:	ff d0                	callq  *%rax
  80203c:	85 c0                	test   %eax,%eax
  80203e:	7e 2a                	jle    80206a <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  802040:	48 ba 8a 45 80 00 00 	movabs $0x80458a,%rdx
  802047:	00 00 00 
  80204a:	be 55 00 00 00       	mov    $0x55,%esi
  80204f:	48 bf 05 45 80 00 00 	movabs $0x804505,%rdi
  802056:	00 00 00 
  802059:	b8 00 00 00 00       	mov    $0x0,%eax
  80205e:	48 b9 3b 04 80 00 00 	movabs $0x80043b,%rcx
  802065:	00 00 00 
  802068:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  80206a:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  80206d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802071:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802075:	41 89 c8             	mov    %ecx,%r8d
  802078:	48 89 d1             	mov    %rdx,%rcx
  80207b:	ba 00 00 00 00       	mov    $0x0,%edx
  802080:	48 89 c6             	mov    %rax,%rsi
  802083:	bf 00 00 00 00       	mov    $0x0,%edi
  802088:	48 b8 a8 1b 80 00 00 	movabs $0x801ba8,%rax
  80208f:	00 00 00 
  802092:	ff d0                	callq  *%rax
  802094:	85 c0                	test   %eax,%eax
  802096:	7e 2a                	jle    8020c2 <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  802098:	48 ba 8a 45 80 00 00 	movabs $0x80458a,%rdx
  80209f:	00 00 00 
  8020a2:	be 57 00 00 00       	mov    $0x57,%esi
  8020a7:	48 bf 05 45 80 00 00 	movabs $0x804505,%rdi
  8020ae:	00 00 00 
  8020b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b6:	48 b9 3b 04 80 00 00 	movabs $0x80043b,%rcx
  8020bd:	00 00 00 
  8020c0:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  8020c2:	eb 53                	jmp    802117 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  8020c4:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8020c7:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8020cb:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8020ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020d2:	41 89 f0             	mov    %esi,%r8d
  8020d5:	48 89 c6             	mov    %rax,%rsi
  8020d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8020dd:	48 b8 a8 1b 80 00 00 	movabs $0x801ba8,%rax
  8020e4:	00 00 00 
  8020e7:	ff d0                	callq  *%rax
  8020e9:	85 c0                	test   %eax,%eax
  8020eb:	7e 2a                	jle    802117 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  8020ed:	48 ba 8a 45 80 00 00 	movabs $0x80458a,%rdx
  8020f4:	00 00 00 
  8020f7:	be 5b 00 00 00       	mov    $0x5b,%esi
  8020fc:	48 bf 05 45 80 00 00 	movabs $0x804505,%rdi
  802103:	00 00 00 
  802106:	b8 00 00 00 00       	mov    $0x0,%eax
  80210b:	48 b9 3b 04 80 00 00 	movabs $0x80043b,%rcx
  802112:	00 00 00 
  802115:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  802117:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80211c:	c9                   	leaveq 
  80211d:	c3                   	retq   

000000000080211e <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  80211e:	55                   	push   %rbp
  80211f:	48 89 e5             	mov    %rsp,%rbp
  802122:	48 83 ec 18          	sub    $0x18,%rsp
  802126:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  80212a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80212e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  802132:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802136:	48 c1 e8 27          	shr    $0x27,%rax
  80213a:	48 89 c2             	mov    %rax,%rdx
  80213d:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802144:	01 00 00 
  802147:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80214b:	83 e0 01             	and    $0x1,%eax
  80214e:	48 85 c0             	test   %rax,%rax
  802151:	74 51                	je     8021a4 <pt_is_mapped+0x86>
  802153:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802157:	48 c1 e0 0c          	shl    $0xc,%rax
  80215b:	48 c1 e8 1e          	shr    $0x1e,%rax
  80215f:	48 89 c2             	mov    %rax,%rdx
  802162:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802169:	01 00 00 
  80216c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802170:	83 e0 01             	and    $0x1,%eax
  802173:	48 85 c0             	test   %rax,%rax
  802176:	74 2c                	je     8021a4 <pt_is_mapped+0x86>
  802178:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80217c:	48 c1 e0 0c          	shl    $0xc,%rax
  802180:	48 c1 e8 15          	shr    $0x15,%rax
  802184:	48 89 c2             	mov    %rax,%rdx
  802187:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80218e:	01 00 00 
  802191:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802195:	83 e0 01             	and    $0x1,%eax
  802198:	48 85 c0             	test   %rax,%rax
  80219b:	74 07                	je     8021a4 <pt_is_mapped+0x86>
  80219d:	b8 01 00 00 00       	mov    $0x1,%eax
  8021a2:	eb 05                	jmp    8021a9 <pt_is_mapped+0x8b>
  8021a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a9:	83 e0 01             	and    $0x1,%eax
}
  8021ac:	c9                   	leaveq 
  8021ad:	c3                   	retq   

00000000008021ae <fork>:

envid_t
fork(void)
{
  8021ae:	55                   	push   %rbp
  8021af:	48 89 e5             	mov    %rsp,%rbp
  8021b2:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  8021b6:	48 bf c5 1d 80 00 00 	movabs $0x801dc5,%rdi
  8021bd:	00 00 00 
  8021c0:	48 b8 77 3d 80 00 00 	movabs $0x803d77,%rax
  8021c7:	00 00 00 
  8021ca:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8021cc:	b8 07 00 00 00       	mov    $0x7,%eax
  8021d1:	cd 30                	int    $0x30
  8021d3:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8021d6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  8021d9:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  8021dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8021e0:	79 30                	jns    802212 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  8021e2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8021e5:	89 c1                	mov    %eax,%ecx
  8021e7:	48 ba a8 45 80 00 00 	movabs $0x8045a8,%rdx
  8021ee:	00 00 00 
  8021f1:	be 86 00 00 00       	mov    $0x86,%esi
  8021f6:	48 bf 05 45 80 00 00 	movabs $0x804505,%rdi
  8021fd:	00 00 00 
  802200:	b8 00 00 00 00       	mov    $0x0,%eax
  802205:	49 b8 3b 04 80 00 00 	movabs $0x80043b,%r8
  80220c:	00 00 00 
  80220f:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  802212:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802216:	75 46                	jne    80225e <fork+0xb0>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  802218:	48 b8 dc 1a 80 00 00 	movabs $0x801adc,%rax
  80221f:	00 00 00 
  802222:	ff d0                	callq  *%rax
  802224:	25 ff 03 00 00       	and    $0x3ff,%eax
  802229:	48 63 d0             	movslq %eax,%rdx
  80222c:	48 89 d0             	mov    %rdx,%rax
  80222f:	48 c1 e0 03          	shl    $0x3,%rax
  802233:	48 01 d0             	add    %rdx,%rax
  802236:	48 c1 e0 05          	shl    $0x5,%rax
  80223a:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802241:	00 00 00 
  802244:	48 01 c2             	add    %rax,%rdx
  802247:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80224e:	00 00 00 
  802251:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  802254:	b8 00 00 00 00       	mov    $0x0,%eax
  802259:	e9 d1 01 00 00       	jmpq   80242f <fork+0x281>
	}
	uint64_t ad = 0;
  80225e:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802265:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  802266:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  80226b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80226f:	e9 df 00 00 00       	jmpq   802353 <fork+0x1a5>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  802274:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802278:	48 c1 e8 27          	shr    $0x27,%rax
  80227c:	48 89 c2             	mov    %rax,%rdx
  80227f:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802286:	01 00 00 
  802289:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80228d:	83 e0 01             	and    $0x1,%eax
  802290:	48 85 c0             	test   %rax,%rax
  802293:	0f 84 9e 00 00 00    	je     802337 <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  802299:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80229d:	48 c1 e8 1e          	shr    $0x1e,%rax
  8022a1:	48 89 c2             	mov    %rax,%rdx
  8022a4:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8022ab:	01 00 00 
  8022ae:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022b2:	83 e0 01             	and    $0x1,%eax
  8022b5:	48 85 c0             	test   %rax,%rax
  8022b8:	74 73                	je     80232d <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  8022ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022be:	48 c1 e8 15          	shr    $0x15,%rax
  8022c2:	48 89 c2             	mov    %rax,%rdx
  8022c5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8022cc:	01 00 00 
  8022cf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022d3:	83 e0 01             	and    $0x1,%eax
  8022d6:	48 85 c0             	test   %rax,%rax
  8022d9:	74 48                	je     802323 <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  8022db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022df:	48 c1 e8 0c          	shr    $0xc,%rax
  8022e3:	48 89 c2             	mov    %rax,%rdx
  8022e6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022ed:	01 00 00 
  8022f0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022f4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8022f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022fc:	83 e0 01             	and    $0x1,%eax
  8022ff:	48 85 c0             	test   %rax,%rax
  802302:	74 47                	je     80234b <fork+0x19d>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  802304:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802308:	48 c1 e8 0c          	shr    $0xc,%rax
  80230c:	89 c2                	mov    %eax,%edx
  80230e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802311:	89 d6                	mov    %edx,%esi
  802313:	89 c7                	mov    %eax,%edi
  802315:	48 b8 5a 1f 80 00 00 	movabs $0x801f5a,%rax
  80231c:	00 00 00 
  80231f:	ff d0                	callq  *%rax
  802321:	eb 28                	jmp    80234b <fork+0x19d>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  802323:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  80232a:	00 
  80232b:	eb 1e                	jmp    80234b <fork+0x19d>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  80232d:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  802334:	40 
  802335:	eb 14                	jmp    80234b <fork+0x19d>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  802337:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80233b:	48 c1 e8 27          	shr    $0x27,%rax
  80233f:	48 83 c0 01          	add    $0x1,%rax
  802343:	48 c1 e0 27          	shl    $0x27,%rax
  802347:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  80234b:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  802352:	00 
  802353:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  80235a:	00 
  80235b:	0f 87 13 ff ff ff    	ja     802274 <fork+0xc6>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  802361:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802364:	ba 07 00 00 00       	mov    $0x7,%edx
  802369:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80236e:	89 c7                	mov    %eax,%edi
  802370:	48 b8 58 1b 80 00 00 	movabs $0x801b58,%rax
  802377:	00 00 00 
  80237a:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  80237c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80237f:	ba 07 00 00 00       	mov    $0x7,%edx
  802384:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802389:	89 c7                	mov    %eax,%edi
  80238b:	48 b8 58 1b 80 00 00 	movabs $0x801b58,%rax
  802392:	00 00 00 
  802395:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  802397:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80239a:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8023a0:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  8023a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8023aa:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8023af:	89 c7                	mov    %eax,%edi
  8023b1:	48 b8 a8 1b 80 00 00 	movabs $0x801ba8,%rax
  8023b8:	00 00 00 
  8023bb:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  8023bd:	ba 00 10 00 00       	mov    $0x1000,%edx
  8023c2:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8023c7:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  8023cc:	48 b8 4d 15 80 00 00 	movabs $0x80154d,%rax
  8023d3:	00 00 00 
  8023d6:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  8023d8:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8023dd:	bf 00 00 00 00       	mov    $0x0,%edi
  8023e2:	48 b8 03 1c 80 00 00 	movabs $0x801c03,%rax
  8023e9:	00 00 00 
  8023ec:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  8023ee:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8023f5:	00 00 00 
  8023f8:	48 8b 00             	mov    (%rax),%rax
  8023fb:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802402:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802405:	48 89 d6             	mov    %rdx,%rsi
  802408:	89 c7                	mov    %eax,%edi
  80240a:	48 b8 e2 1c 80 00 00 	movabs $0x801ce2,%rax
  802411:	00 00 00 
  802414:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  802416:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802419:	be 02 00 00 00       	mov    $0x2,%esi
  80241e:	89 c7                	mov    %eax,%edi
  802420:	48 b8 4d 1c 80 00 00 	movabs $0x801c4d,%rax
  802427:	00 00 00 
  80242a:	ff d0                	callq  *%rax

	return envid;
  80242c:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  80242f:	c9                   	leaveq 
  802430:	c3                   	retq   

0000000000802431 <sfork>:

	
// Challenge!
int
sfork(void)
{
  802431:	55                   	push   %rbp
  802432:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802435:	48 ba c0 45 80 00 00 	movabs $0x8045c0,%rdx
  80243c:	00 00 00 
  80243f:	be bf 00 00 00       	mov    $0xbf,%esi
  802444:	48 bf 05 45 80 00 00 	movabs $0x804505,%rdi
  80244b:	00 00 00 
  80244e:	b8 00 00 00 00       	mov    $0x0,%eax
  802453:	48 b9 3b 04 80 00 00 	movabs $0x80043b,%rcx
  80245a:	00 00 00 
  80245d:	ff d1                	callq  *%rcx

000000000080245f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80245f:	55                   	push   %rbp
  802460:	48 89 e5             	mov    %rsp,%rbp
  802463:	48 83 ec 30          	sub    $0x30,%rsp
  802467:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80246b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80246f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  802473:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80247a:	00 00 00 
  80247d:	48 8b 00             	mov    (%rax),%rax
  802480:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  802486:	85 c0                	test   %eax,%eax
  802488:	75 3c                	jne    8024c6 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  80248a:	48 b8 dc 1a 80 00 00 	movabs $0x801adc,%rax
  802491:	00 00 00 
  802494:	ff d0                	callq  *%rax
  802496:	25 ff 03 00 00       	and    $0x3ff,%eax
  80249b:	48 63 d0             	movslq %eax,%rdx
  80249e:	48 89 d0             	mov    %rdx,%rax
  8024a1:	48 c1 e0 03          	shl    $0x3,%rax
  8024a5:	48 01 d0             	add    %rdx,%rax
  8024a8:	48 c1 e0 05          	shl    $0x5,%rax
  8024ac:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8024b3:	00 00 00 
  8024b6:	48 01 c2             	add    %rax,%rdx
  8024b9:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8024c0:	00 00 00 
  8024c3:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  8024c6:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8024cb:	75 0e                	jne    8024db <ipc_recv+0x7c>
		pg = (void*) UTOP;
  8024cd:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8024d4:	00 00 00 
  8024d7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  8024db:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024df:	48 89 c7             	mov    %rax,%rdi
  8024e2:	48 b8 81 1d 80 00 00 	movabs $0x801d81,%rax
  8024e9:	00 00 00 
  8024ec:	ff d0                	callq  *%rax
  8024ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  8024f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024f5:	79 19                	jns    802510 <ipc_recv+0xb1>
		*from_env_store = 0;
  8024f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024fb:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  802501:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802505:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  80250b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80250e:	eb 53                	jmp    802563 <ipc_recv+0x104>
	}
	if(from_env_store)
  802510:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802515:	74 19                	je     802530 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  802517:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80251e:	00 00 00 
  802521:	48 8b 00             	mov    (%rax),%rax
  802524:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80252a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80252e:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  802530:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802535:	74 19                	je     802550 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  802537:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80253e:	00 00 00 
  802541:	48 8b 00             	mov    (%rax),%rax
  802544:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80254a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80254e:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  802550:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802557:	00 00 00 
  80255a:	48 8b 00             	mov    (%rax),%rax
  80255d:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  802563:	c9                   	leaveq 
  802564:	c3                   	retq   

0000000000802565 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802565:	55                   	push   %rbp
  802566:	48 89 e5             	mov    %rsp,%rbp
  802569:	48 83 ec 30          	sub    $0x30,%rsp
  80256d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802570:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802573:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802577:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  80257a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80257f:	75 0e                	jne    80258f <ipc_send+0x2a>
		pg = (void*)UTOP;
  802581:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802588:	00 00 00 
  80258b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  80258f:	8b 75 e8             	mov    -0x18(%rbp),%esi
  802592:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  802595:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802599:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80259c:	89 c7                	mov    %eax,%edi
  80259e:	48 b8 2c 1d 80 00 00 	movabs $0x801d2c,%rax
  8025a5:	00 00 00 
  8025a8:	ff d0                	callq  *%rax
  8025aa:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  8025ad:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8025b1:	75 0c                	jne    8025bf <ipc_send+0x5a>
			sys_yield();
  8025b3:	48 b8 1a 1b 80 00 00 	movabs $0x801b1a,%rax
  8025ba:	00 00 00 
  8025bd:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  8025bf:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8025c3:	74 ca                	je     80258f <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  8025c5:	c9                   	leaveq 
  8025c6:	c3                   	retq   

00000000008025c7 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8025c7:	55                   	push   %rbp
  8025c8:	48 89 e5             	mov    %rsp,%rbp
  8025cb:	48 83 ec 14          	sub    $0x14,%rsp
  8025cf:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  8025d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8025d9:	eb 5e                	jmp    802639 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8025db:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8025e2:	00 00 00 
  8025e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025e8:	48 63 d0             	movslq %eax,%rdx
  8025eb:	48 89 d0             	mov    %rdx,%rax
  8025ee:	48 c1 e0 03          	shl    $0x3,%rax
  8025f2:	48 01 d0             	add    %rdx,%rax
  8025f5:	48 c1 e0 05          	shl    $0x5,%rax
  8025f9:	48 01 c8             	add    %rcx,%rax
  8025fc:	48 05 d0 00 00 00    	add    $0xd0,%rax
  802602:	8b 00                	mov    (%rax),%eax
  802604:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802607:	75 2c                	jne    802635 <ipc_find_env+0x6e>
			return envs[i].env_id;
  802609:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802610:	00 00 00 
  802613:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802616:	48 63 d0             	movslq %eax,%rdx
  802619:	48 89 d0             	mov    %rdx,%rax
  80261c:	48 c1 e0 03          	shl    $0x3,%rax
  802620:	48 01 d0             	add    %rdx,%rax
  802623:	48 c1 e0 05          	shl    $0x5,%rax
  802627:	48 01 c8             	add    %rcx,%rax
  80262a:	48 05 c0 00 00 00    	add    $0xc0,%rax
  802630:	8b 40 08             	mov    0x8(%rax),%eax
  802633:	eb 12                	jmp    802647 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802635:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802639:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802640:	7e 99                	jle    8025db <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802642:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802647:	c9                   	leaveq 
  802648:	c3                   	retq   

0000000000802649 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802649:	55                   	push   %rbp
  80264a:	48 89 e5             	mov    %rsp,%rbp
  80264d:	48 83 ec 08          	sub    $0x8,%rsp
  802651:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802655:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802659:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802660:	ff ff ff 
  802663:	48 01 d0             	add    %rdx,%rax
  802666:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80266a:	c9                   	leaveq 
  80266b:	c3                   	retq   

000000000080266c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80266c:	55                   	push   %rbp
  80266d:	48 89 e5             	mov    %rsp,%rbp
  802670:	48 83 ec 08          	sub    $0x8,%rsp
  802674:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802678:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80267c:	48 89 c7             	mov    %rax,%rdi
  80267f:	48 b8 49 26 80 00 00 	movabs $0x802649,%rax
  802686:	00 00 00 
  802689:	ff d0                	callq  *%rax
  80268b:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802691:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802695:	c9                   	leaveq 
  802696:	c3                   	retq   

0000000000802697 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802697:	55                   	push   %rbp
  802698:	48 89 e5             	mov    %rsp,%rbp
  80269b:	48 83 ec 18          	sub    $0x18,%rsp
  80269f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8026a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8026aa:	eb 6b                	jmp    802717 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8026ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026af:	48 98                	cltq   
  8026b1:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8026b7:	48 c1 e0 0c          	shl    $0xc,%rax
  8026bb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8026bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026c3:	48 c1 e8 15          	shr    $0x15,%rax
  8026c7:	48 89 c2             	mov    %rax,%rdx
  8026ca:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8026d1:	01 00 00 
  8026d4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026d8:	83 e0 01             	and    $0x1,%eax
  8026db:	48 85 c0             	test   %rax,%rax
  8026de:	74 21                	je     802701 <fd_alloc+0x6a>
  8026e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026e4:	48 c1 e8 0c          	shr    $0xc,%rax
  8026e8:	48 89 c2             	mov    %rax,%rdx
  8026eb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8026f2:	01 00 00 
  8026f5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026f9:	83 e0 01             	and    $0x1,%eax
  8026fc:	48 85 c0             	test   %rax,%rax
  8026ff:	75 12                	jne    802713 <fd_alloc+0x7c>
			*fd_store = fd;
  802701:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802705:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802709:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80270c:	b8 00 00 00 00       	mov    $0x0,%eax
  802711:	eb 1a                	jmp    80272d <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802713:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802717:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80271b:	7e 8f                	jle    8026ac <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80271d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802721:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802728:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80272d:	c9                   	leaveq 
  80272e:	c3                   	retq   

000000000080272f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80272f:	55                   	push   %rbp
  802730:	48 89 e5             	mov    %rsp,%rbp
  802733:	48 83 ec 20          	sub    $0x20,%rsp
  802737:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80273a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80273e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802742:	78 06                	js     80274a <fd_lookup+0x1b>
  802744:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802748:	7e 07                	jle    802751 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80274a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80274f:	eb 6c                	jmp    8027bd <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802751:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802754:	48 98                	cltq   
  802756:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80275c:	48 c1 e0 0c          	shl    $0xc,%rax
  802760:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802764:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802768:	48 c1 e8 15          	shr    $0x15,%rax
  80276c:	48 89 c2             	mov    %rax,%rdx
  80276f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802776:	01 00 00 
  802779:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80277d:	83 e0 01             	and    $0x1,%eax
  802780:	48 85 c0             	test   %rax,%rax
  802783:	74 21                	je     8027a6 <fd_lookup+0x77>
  802785:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802789:	48 c1 e8 0c          	shr    $0xc,%rax
  80278d:	48 89 c2             	mov    %rax,%rdx
  802790:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802797:	01 00 00 
  80279a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80279e:	83 e0 01             	and    $0x1,%eax
  8027a1:	48 85 c0             	test   %rax,%rax
  8027a4:	75 07                	jne    8027ad <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8027a6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027ab:	eb 10                	jmp    8027bd <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8027ad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027b1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8027b5:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8027b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027bd:	c9                   	leaveq 
  8027be:	c3                   	retq   

00000000008027bf <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8027bf:	55                   	push   %rbp
  8027c0:	48 89 e5             	mov    %rsp,%rbp
  8027c3:	48 83 ec 30          	sub    $0x30,%rsp
  8027c7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8027cb:	89 f0                	mov    %esi,%eax
  8027cd:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8027d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027d4:	48 89 c7             	mov    %rax,%rdi
  8027d7:	48 b8 49 26 80 00 00 	movabs $0x802649,%rax
  8027de:	00 00 00 
  8027e1:	ff d0                	callq  *%rax
  8027e3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027e7:	48 89 d6             	mov    %rdx,%rsi
  8027ea:	89 c7                	mov    %eax,%edi
  8027ec:	48 b8 2f 27 80 00 00 	movabs $0x80272f,%rax
  8027f3:	00 00 00 
  8027f6:	ff d0                	callq  *%rax
  8027f8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027ff:	78 0a                	js     80280b <fd_close+0x4c>
	    || fd != fd2)
  802801:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802805:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802809:	74 12                	je     80281d <fd_close+0x5e>
		return (must_exist ? r : 0);
  80280b:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80280f:	74 05                	je     802816 <fd_close+0x57>
  802811:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802814:	eb 05                	jmp    80281b <fd_close+0x5c>
  802816:	b8 00 00 00 00       	mov    $0x0,%eax
  80281b:	eb 69                	jmp    802886 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80281d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802821:	8b 00                	mov    (%rax),%eax
  802823:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802827:	48 89 d6             	mov    %rdx,%rsi
  80282a:	89 c7                	mov    %eax,%edi
  80282c:	48 b8 88 28 80 00 00 	movabs $0x802888,%rax
  802833:	00 00 00 
  802836:	ff d0                	callq  *%rax
  802838:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80283b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80283f:	78 2a                	js     80286b <fd_close+0xac>
		if (dev->dev_close)
  802841:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802845:	48 8b 40 20          	mov    0x20(%rax),%rax
  802849:	48 85 c0             	test   %rax,%rax
  80284c:	74 16                	je     802864 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  80284e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802852:	48 8b 40 20          	mov    0x20(%rax),%rax
  802856:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80285a:	48 89 d7             	mov    %rdx,%rdi
  80285d:	ff d0                	callq  *%rax
  80285f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802862:	eb 07                	jmp    80286b <fd_close+0xac>
		else
			r = 0;
  802864:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80286b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80286f:	48 89 c6             	mov    %rax,%rsi
  802872:	bf 00 00 00 00       	mov    $0x0,%edi
  802877:	48 b8 03 1c 80 00 00 	movabs $0x801c03,%rax
  80287e:	00 00 00 
  802881:	ff d0                	callq  *%rax
	return r;
  802883:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802886:	c9                   	leaveq 
  802887:	c3                   	retq   

0000000000802888 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802888:	55                   	push   %rbp
  802889:	48 89 e5             	mov    %rsp,%rbp
  80288c:	48 83 ec 20          	sub    $0x20,%rsp
  802890:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802893:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802897:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80289e:	eb 41                	jmp    8028e1 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8028a0:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8028a7:	00 00 00 
  8028aa:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8028ad:	48 63 d2             	movslq %edx,%rdx
  8028b0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028b4:	8b 00                	mov    (%rax),%eax
  8028b6:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8028b9:	75 22                	jne    8028dd <dev_lookup+0x55>
			*dev = devtab[i];
  8028bb:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8028c2:	00 00 00 
  8028c5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8028c8:	48 63 d2             	movslq %edx,%rdx
  8028cb:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8028cf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028d3:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8028d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8028db:	eb 60                	jmp    80293d <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8028dd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8028e1:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8028e8:	00 00 00 
  8028eb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8028ee:	48 63 d2             	movslq %edx,%rdx
  8028f1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028f5:	48 85 c0             	test   %rax,%rax
  8028f8:	75 a6                	jne    8028a0 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8028fa:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802901:	00 00 00 
  802904:	48 8b 00             	mov    (%rax),%rax
  802907:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80290d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802910:	89 c6                	mov    %eax,%esi
  802912:	48 bf d8 45 80 00 00 	movabs $0x8045d8,%rdi
  802919:	00 00 00 
  80291c:	b8 00 00 00 00       	mov    $0x0,%eax
  802921:	48 b9 74 06 80 00 00 	movabs $0x800674,%rcx
  802928:	00 00 00 
  80292b:	ff d1                	callq  *%rcx
	*dev = 0;
  80292d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802931:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802938:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80293d:	c9                   	leaveq 
  80293e:	c3                   	retq   

000000000080293f <close>:

int
close(int fdnum)
{
  80293f:	55                   	push   %rbp
  802940:	48 89 e5             	mov    %rsp,%rbp
  802943:	48 83 ec 20          	sub    $0x20,%rsp
  802947:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80294a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80294e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802951:	48 89 d6             	mov    %rdx,%rsi
  802954:	89 c7                	mov    %eax,%edi
  802956:	48 b8 2f 27 80 00 00 	movabs $0x80272f,%rax
  80295d:	00 00 00 
  802960:	ff d0                	callq  *%rax
  802962:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802965:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802969:	79 05                	jns    802970 <close+0x31>
		return r;
  80296b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80296e:	eb 18                	jmp    802988 <close+0x49>
	else
		return fd_close(fd, 1);
  802970:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802974:	be 01 00 00 00       	mov    $0x1,%esi
  802979:	48 89 c7             	mov    %rax,%rdi
  80297c:	48 b8 bf 27 80 00 00 	movabs $0x8027bf,%rax
  802983:	00 00 00 
  802986:	ff d0                	callq  *%rax
}
  802988:	c9                   	leaveq 
  802989:	c3                   	retq   

000000000080298a <close_all>:

void
close_all(void)
{
  80298a:	55                   	push   %rbp
  80298b:	48 89 e5             	mov    %rsp,%rbp
  80298e:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802992:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802999:	eb 15                	jmp    8029b0 <close_all+0x26>
		close(i);
  80299b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80299e:	89 c7                	mov    %eax,%edi
  8029a0:	48 b8 3f 29 80 00 00 	movabs $0x80293f,%rax
  8029a7:	00 00 00 
  8029aa:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8029ac:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8029b0:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8029b4:	7e e5                	jle    80299b <close_all+0x11>
		close(i);
}
  8029b6:	c9                   	leaveq 
  8029b7:	c3                   	retq   

00000000008029b8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8029b8:	55                   	push   %rbp
  8029b9:	48 89 e5             	mov    %rsp,%rbp
  8029bc:	48 83 ec 40          	sub    $0x40,%rsp
  8029c0:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8029c3:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8029c6:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8029ca:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8029cd:	48 89 d6             	mov    %rdx,%rsi
  8029d0:	89 c7                	mov    %eax,%edi
  8029d2:	48 b8 2f 27 80 00 00 	movabs $0x80272f,%rax
  8029d9:	00 00 00 
  8029dc:	ff d0                	callq  *%rax
  8029de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029e5:	79 08                	jns    8029ef <dup+0x37>
		return r;
  8029e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029ea:	e9 70 01 00 00       	jmpq   802b5f <dup+0x1a7>
	close(newfdnum);
  8029ef:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8029f2:	89 c7                	mov    %eax,%edi
  8029f4:	48 b8 3f 29 80 00 00 	movabs $0x80293f,%rax
  8029fb:	00 00 00 
  8029fe:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802a00:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a03:	48 98                	cltq   
  802a05:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802a0b:	48 c1 e0 0c          	shl    $0xc,%rax
  802a0f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802a13:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a17:	48 89 c7             	mov    %rax,%rdi
  802a1a:	48 b8 6c 26 80 00 00 	movabs $0x80266c,%rax
  802a21:	00 00 00 
  802a24:	ff d0                	callq  *%rax
  802a26:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802a2a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a2e:	48 89 c7             	mov    %rax,%rdi
  802a31:	48 b8 6c 26 80 00 00 	movabs $0x80266c,%rax
  802a38:	00 00 00 
  802a3b:	ff d0                	callq  *%rax
  802a3d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802a41:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a45:	48 c1 e8 15          	shr    $0x15,%rax
  802a49:	48 89 c2             	mov    %rax,%rdx
  802a4c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802a53:	01 00 00 
  802a56:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a5a:	83 e0 01             	and    $0x1,%eax
  802a5d:	48 85 c0             	test   %rax,%rax
  802a60:	74 73                	je     802ad5 <dup+0x11d>
  802a62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a66:	48 c1 e8 0c          	shr    $0xc,%rax
  802a6a:	48 89 c2             	mov    %rax,%rdx
  802a6d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a74:	01 00 00 
  802a77:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a7b:	83 e0 01             	and    $0x1,%eax
  802a7e:	48 85 c0             	test   %rax,%rax
  802a81:	74 52                	je     802ad5 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802a83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a87:	48 c1 e8 0c          	shr    $0xc,%rax
  802a8b:	48 89 c2             	mov    %rax,%rdx
  802a8e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a95:	01 00 00 
  802a98:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a9c:	25 07 0e 00 00       	and    $0xe07,%eax
  802aa1:	89 c1                	mov    %eax,%ecx
  802aa3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802aa7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aab:	41 89 c8             	mov    %ecx,%r8d
  802aae:	48 89 d1             	mov    %rdx,%rcx
  802ab1:	ba 00 00 00 00       	mov    $0x0,%edx
  802ab6:	48 89 c6             	mov    %rax,%rsi
  802ab9:	bf 00 00 00 00       	mov    $0x0,%edi
  802abe:	48 b8 a8 1b 80 00 00 	movabs $0x801ba8,%rax
  802ac5:	00 00 00 
  802ac8:	ff d0                	callq  *%rax
  802aca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802acd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ad1:	79 02                	jns    802ad5 <dup+0x11d>
			goto err;
  802ad3:	eb 57                	jmp    802b2c <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802ad5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ad9:	48 c1 e8 0c          	shr    $0xc,%rax
  802add:	48 89 c2             	mov    %rax,%rdx
  802ae0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ae7:	01 00 00 
  802aea:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802aee:	25 07 0e 00 00       	and    $0xe07,%eax
  802af3:	89 c1                	mov    %eax,%ecx
  802af5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802af9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802afd:	41 89 c8             	mov    %ecx,%r8d
  802b00:	48 89 d1             	mov    %rdx,%rcx
  802b03:	ba 00 00 00 00       	mov    $0x0,%edx
  802b08:	48 89 c6             	mov    %rax,%rsi
  802b0b:	bf 00 00 00 00       	mov    $0x0,%edi
  802b10:	48 b8 a8 1b 80 00 00 	movabs $0x801ba8,%rax
  802b17:	00 00 00 
  802b1a:	ff d0                	callq  *%rax
  802b1c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b1f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b23:	79 02                	jns    802b27 <dup+0x16f>
		goto err;
  802b25:	eb 05                	jmp    802b2c <dup+0x174>

	return newfdnum;
  802b27:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802b2a:	eb 33                	jmp    802b5f <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802b2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b30:	48 89 c6             	mov    %rax,%rsi
  802b33:	bf 00 00 00 00       	mov    $0x0,%edi
  802b38:	48 b8 03 1c 80 00 00 	movabs $0x801c03,%rax
  802b3f:	00 00 00 
  802b42:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802b44:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b48:	48 89 c6             	mov    %rax,%rsi
  802b4b:	bf 00 00 00 00       	mov    $0x0,%edi
  802b50:	48 b8 03 1c 80 00 00 	movabs $0x801c03,%rax
  802b57:	00 00 00 
  802b5a:	ff d0                	callq  *%rax
	return r;
  802b5c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802b5f:	c9                   	leaveq 
  802b60:	c3                   	retq   

0000000000802b61 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802b61:	55                   	push   %rbp
  802b62:	48 89 e5             	mov    %rsp,%rbp
  802b65:	48 83 ec 40          	sub    $0x40,%rsp
  802b69:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b6c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802b70:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b74:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b78:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b7b:	48 89 d6             	mov    %rdx,%rsi
  802b7e:	89 c7                	mov    %eax,%edi
  802b80:	48 b8 2f 27 80 00 00 	movabs $0x80272f,%rax
  802b87:	00 00 00 
  802b8a:	ff d0                	callq  *%rax
  802b8c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b8f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b93:	78 24                	js     802bb9 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b99:	8b 00                	mov    (%rax),%eax
  802b9b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b9f:	48 89 d6             	mov    %rdx,%rsi
  802ba2:	89 c7                	mov    %eax,%edi
  802ba4:	48 b8 88 28 80 00 00 	movabs $0x802888,%rax
  802bab:	00 00 00 
  802bae:	ff d0                	callq  *%rax
  802bb0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bb3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bb7:	79 05                	jns    802bbe <read+0x5d>
		return r;
  802bb9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bbc:	eb 76                	jmp    802c34 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802bbe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bc2:	8b 40 08             	mov    0x8(%rax),%eax
  802bc5:	83 e0 03             	and    $0x3,%eax
  802bc8:	83 f8 01             	cmp    $0x1,%eax
  802bcb:	75 3a                	jne    802c07 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802bcd:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802bd4:	00 00 00 
  802bd7:	48 8b 00             	mov    (%rax),%rax
  802bda:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802be0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802be3:	89 c6                	mov    %eax,%esi
  802be5:	48 bf f7 45 80 00 00 	movabs $0x8045f7,%rdi
  802bec:	00 00 00 
  802bef:	b8 00 00 00 00       	mov    $0x0,%eax
  802bf4:	48 b9 74 06 80 00 00 	movabs $0x800674,%rcx
  802bfb:	00 00 00 
  802bfe:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802c00:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c05:	eb 2d                	jmp    802c34 <read+0xd3>
	}
	if (!dev->dev_read)
  802c07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c0b:	48 8b 40 10          	mov    0x10(%rax),%rax
  802c0f:	48 85 c0             	test   %rax,%rax
  802c12:	75 07                	jne    802c1b <read+0xba>
		return -E_NOT_SUPP;
  802c14:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c19:	eb 19                	jmp    802c34 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802c1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c1f:	48 8b 40 10          	mov    0x10(%rax),%rax
  802c23:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802c27:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802c2b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802c2f:	48 89 cf             	mov    %rcx,%rdi
  802c32:	ff d0                	callq  *%rax
}
  802c34:	c9                   	leaveq 
  802c35:	c3                   	retq   

0000000000802c36 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802c36:	55                   	push   %rbp
  802c37:	48 89 e5             	mov    %rsp,%rbp
  802c3a:	48 83 ec 30          	sub    $0x30,%rsp
  802c3e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c41:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c45:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802c49:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802c50:	eb 49                	jmp    802c9b <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802c52:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c55:	48 98                	cltq   
  802c57:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802c5b:	48 29 c2             	sub    %rax,%rdx
  802c5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c61:	48 63 c8             	movslq %eax,%rcx
  802c64:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c68:	48 01 c1             	add    %rax,%rcx
  802c6b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c6e:	48 89 ce             	mov    %rcx,%rsi
  802c71:	89 c7                	mov    %eax,%edi
  802c73:	48 b8 61 2b 80 00 00 	movabs $0x802b61,%rax
  802c7a:	00 00 00 
  802c7d:	ff d0                	callq  *%rax
  802c7f:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802c82:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c86:	79 05                	jns    802c8d <readn+0x57>
			return m;
  802c88:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c8b:	eb 1c                	jmp    802ca9 <readn+0x73>
		if (m == 0)
  802c8d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c91:	75 02                	jne    802c95 <readn+0x5f>
			break;
  802c93:	eb 11                	jmp    802ca6 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802c95:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c98:	01 45 fc             	add    %eax,-0x4(%rbp)
  802c9b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c9e:	48 98                	cltq   
  802ca0:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802ca4:	72 ac                	jb     802c52 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802ca6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802ca9:	c9                   	leaveq 
  802caa:	c3                   	retq   

0000000000802cab <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802cab:	55                   	push   %rbp
  802cac:	48 89 e5             	mov    %rsp,%rbp
  802caf:	48 83 ec 40          	sub    $0x40,%rsp
  802cb3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802cb6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802cba:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802cbe:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802cc2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802cc5:	48 89 d6             	mov    %rdx,%rsi
  802cc8:	89 c7                	mov    %eax,%edi
  802cca:	48 b8 2f 27 80 00 00 	movabs $0x80272f,%rax
  802cd1:	00 00 00 
  802cd4:	ff d0                	callq  *%rax
  802cd6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cd9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cdd:	78 24                	js     802d03 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802cdf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ce3:	8b 00                	mov    (%rax),%eax
  802ce5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ce9:	48 89 d6             	mov    %rdx,%rsi
  802cec:	89 c7                	mov    %eax,%edi
  802cee:	48 b8 88 28 80 00 00 	movabs $0x802888,%rax
  802cf5:	00 00 00 
  802cf8:	ff d0                	callq  *%rax
  802cfa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cfd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d01:	79 05                	jns    802d08 <write+0x5d>
		return r;
  802d03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d06:	eb 75                	jmp    802d7d <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802d08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d0c:	8b 40 08             	mov    0x8(%rax),%eax
  802d0f:	83 e0 03             	and    $0x3,%eax
  802d12:	85 c0                	test   %eax,%eax
  802d14:	75 3a                	jne    802d50 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802d16:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802d1d:	00 00 00 
  802d20:	48 8b 00             	mov    (%rax),%rax
  802d23:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d29:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802d2c:	89 c6                	mov    %eax,%esi
  802d2e:	48 bf 13 46 80 00 00 	movabs $0x804613,%rdi
  802d35:	00 00 00 
  802d38:	b8 00 00 00 00       	mov    $0x0,%eax
  802d3d:	48 b9 74 06 80 00 00 	movabs $0x800674,%rcx
  802d44:	00 00 00 
  802d47:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802d49:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d4e:	eb 2d                	jmp    802d7d <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802d50:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d54:	48 8b 40 18          	mov    0x18(%rax),%rax
  802d58:	48 85 c0             	test   %rax,%rax
  802d5b:	75 07                	jne    802d64 <write+0xb9>
		return -E_NOT_SUPP;
  802d5d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d62:	eb 19                	jmp    802d7d <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802d64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d68:	48 8b 40 18          	mov    0x18(%rax),%rax
  802d6c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802d70:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802d74:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802d78:	48 89 cf             	mov    %rcx,%rdi
  802d7b:	ff d0                	callq  *%rax
}
  802d7d:	c9                   	leaveq 
  802d7e:	c3                   	retq   

0000000000802d7f <seek>:

int
seek(int fdnum, off_t offset)
{
  802d7f:	55                   	push   %rbp
  802d80:	48 89 e5             	mov    %rsp,%rbp
  802d83:	48 83 ec 18          	sub    $0x18,%rsp
  802d87:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d8a:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802d8d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d91:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d94:	48 89 d6             	mov    %rdx,%rsi
  802d97:	89 c7                	mov    %eax,%edi
  802d99:	48 b8 2f 27 80 00 00 	movabs $0x80272f,%rax
  802da0:	00 00 00 
  802da3:	ff d0                	callq  *%rax
  802da5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802da8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dac:	79 05                	jns    802db3 <seek+0x34>
		return r;
  802dae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802db1:	eb 0f                	jmp    802dc2 <seek+0x43>
	fd->fd_offset = offset;
  802db3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802db7:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802dba:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802dbd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802dc2:	c9                   	leaveq 
  802dc3:	c3                   	retq   

0000000000802dc4 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802dc4:	55                   	push   %rbp
  802dc5:	48 89 e5             	mov    %rsp,%rbp
  802dc8:	48 83 ec 30          	sub    $0x30,%rsp
  802dcc:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802dcf:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802dd2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802dd6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802dd9:	48 89 d6             	mov    %rdx,%rsi
  802ddc:	89 c7                	mov    %eax,%edi
  802dde:	48 b8 2f 27 80 00 00 	movabs $0x80272f,%rax
  802de5:	00 00 00 
  802de8:	ff d0                	callq  *%rax
  802dea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ded:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802df1:	78 24                	js     802e17 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802df3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802df7:	8b 00                	mov    (%rax),%eax
  802df9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802dfd:	48 89 d6             	mov    %rdx,%rsi
  802e00:	89 c7                	mov    %eax,%edi
  802e02:	48 b8 88 28 80 00 00 	movabs $0x802888,%rax
  802e09:	00 00 00 
  802e0c:	ff d0                	callq  *%rax
  802e0e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e11:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e15:	79 05                	jns    802e1c <ftruncate+0x58>
		return r;
  802e17:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e1a:	eb 72                	jmp    802e8e <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802e1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e20:	8b 40 08             	mov    0x8(%rax),%eax
  802e23:	83 e0 03             	and    $0x3,%eax
  802e26:	85 c0                	test   %eax,%eax
  802e28:	75 3a                	jne    802e64 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802e2a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802e31:	00 00 00 
  802e34:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802e37:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802e3d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802e40:	89 c6                	mov    %eax,%esi
  802e42:	48 bf 30 46 80 00 00 	movabs $0x804630,%rdi
  802e49:	00 00 00 
  802e4c:	b8 00 00 00 00       	mov    $0x0,%eax
  802e51:	48 b9 74 06 80 00 00 	movabs $0x800674,%rcx
  802e58:	00 00 00 
  802e5b:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802e5d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e62:	eb 2a                	jmp    802e8e <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802e64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e68:	48 8b 40 30          	mov    0x30(%rax),%rax
  802e6c:	48 85 c0             	test   %rax,%rax
  802e6f:	75 07                	jne    802e78 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802e71:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e76:	eb 16                	jmp    802e8e <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802e78:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e7c:	48 8b 40 30          	mov    0x30(%rax),%rax
  802e80:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802e84:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802e87:	89 ce                	mov    %ecx,%esi
  802e89:	48 89 d7             	mov    %rdx,%rdi
  802e8c:	ff d0                	callq  *%rax
}
  802e8e:	c9                   	leaveq 
  802e8f:	c3                   	retq   

0000000000802e90 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802e90:	55                   	push   %rbp
  802e91:	48 89 e5             	mov    %rsp,%rbp
  802e94:	48 83 ec 30          	sub    $0x30,%rsp
  802e98:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e9b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e9f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ea3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ea6:	48 89 d6             	mov    %rdx,%rsi
  802ea9:	89 c7                	mov    %eax,%edi
  802eab:	48 b8 2f 27 80 00 00 	movabs $0x80272f,%rax
  802eb2:	00 00 00 
  802eb5:	ff d0                	callq  *%rax
  802eb7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802eba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ebe:	78 24                	js     802ee4 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ec0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ec4:	8b 00                	mov    (%rax),%eax
  802ec6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802eca:	48 89 d6             	mov    %rdx,%rsi
  802ecd:	89 c7                	mov    %eax,%edi
  802ecf:	48 b8 88 28 80 00 00 	movabs $0x802888,%rax
  802ed6:	00 00 00 
  802ed9:	ff d0                	callq  *%rax
  802edb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ede:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ee2:	79 05                	jns    802ee9 <fstat+0x59>
		return r;
  802ee4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ee7:	eb 5e                	jmp    802f47 <fstat+0xb7>
	if (!dev->dev_stat)
  802ee9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eed:	48 8b 40 28          	mov    0x28(%rax),%rax
  802ef1:	48 85 c0             	test   %rax,%rax
  802ef4:	75 07                	jne    802efd <fstat+0x6d>
		return -E_NOT_SUPP;
  802ef6:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802efb:	eb 4a                	jmp    802f47 <fstat+0xb7>
	stat->st_name[0] = 0;
  802efd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f01:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802f04:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f08:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802f0f:	00 00 00 
	stat->st_isdir = 0;
  802f12:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f16:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802f1d:	00 00 00 
	stat->st_dev = dev;
  802f20:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f24:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f28:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802f2f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f33:	48 8b 40 28          	mov    0x28(%rax),%rax
  802f37:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802f3b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802f3f:	48 89 ce             	mov    %rcx,%rsi
  802f42:	48 89 d7             	mov    %rdx,%rdi
  802f45:	ff d0                	callq  *%rax
}
  802f47:	c9                   	leaveq 
  802f48:	c3                   	retq   

0000000000802f49 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802f49:	55                   	push   %rbp
  802f4a:	48 89 e5             	mov    %rsp,%rbp
  802f4d:	48 83 ec 20          	sub    $0x20,%rsp
  802f51:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f55:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802f59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f5d:	be 00 00 00 00       	mov    $0x0,%esi
  802f62:	48 89 c7             	mov    %rax,%rdi
  802f65:	48 b8 37 30 80 00 00 	movabs $0x803037,%rax
  802f6c:	00 00 00 
  802f6f:	ff d0                	callq  *%rax
  802f71:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f74:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f78:	79 05                	jns    802f7f <stat+0x36>
		return fd;
  802f7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f7d:	eb 2f                	jmp    802fae <stat+0x65>
	r = fstat(fd, stat);
  802f7f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802f83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f86:	48 89 d6             	mov    %rdx,%rsi
  802f89:	89 c7                	mov    %eax,%edi
  802f8b:	48 b8 90 2e 80 00 00 	movabs $0x802e90,%rax
  802f92:	00 00 00 
  802f95:	ff d0                	callq  *%rax
  802f97:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802f9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f9d:	89 c7                	mov    %eax,%edi
  802f9f:	48 b8 3f 29 80 00 00 	movabs $0x80293f,%rax
  802fa6:	00 00 00 
  802fa9:	ff d0                	callq  *%rax
	return r;
  802fab:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802fae:	c9                   	leaveq 
  802faf:	c3                   	retq   

0000000000802fb0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802fb0:	55                   	push   %rbp
  802fb1:	48 89 e5             	mov    %rsp,%rbp
  802fb4:	48 83 ec 10          	sub    $0x10,%rsp
  802fb8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802fbb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802fbf:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802fc6:	00 00 00 
  802fc9:	8b 00                	mov    (%rax),%eax
  802fcb:	85 c0                	test   %eax,%eax
  802fcd:	75 1d                	jne    802fec <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802fcf:	bf 01 00 00 00       	mov    $0x1,%edi
  802fd4:	48 b8 c7 25 80 00 00 	movabs $0x8025c7,%rax
  802fdb:	00 00 00 
  802fde:	ff d0                	callq  *%rax
  802fe0:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802fe7:	00 00 00 
  802fea:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802fec:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802ff3:	00 00 00 
  802ff6:	8b 00                	mov    (%rax),%eax
  802ff8:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802ffb:	b9 07 00 00 00       	mov    $0x7,%ecx
  803000:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  803007:	00 00 00 
  80300a:	89 c7                	mov    %eax,%edi
  80300c:	48 b8 65 25 80 00 00 	movabs $0x802565,%rax
  803013:	00 00 00 
  803016:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  803018:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80301c:	ba 00 00 00 00       	mov    $0x0,%edx
  803021:	48 89 c6             	mov    %rax,%rsi
  803024:	bf 00 00 00 00       	mov    $0x0,%edi
  803029:	48 b8 5f 24 80 00 00 	movabs $0x80245f,%rax
  803030:	00 00 00 
  803033:	ff d0                	callq  *%rax
}
  803035:	c9                   	leaveq 
  803036:	c3                   	retq   

0000000000803037 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  803037:	55                   	push   %rbp
  803038:	48 89 e5             	mov    %rsp,%rbp
  80303b:	48 83 ec 30          	sub    $0x30,%rsp
  80303f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803043:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  803046:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  80304d:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  803054:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  80305b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803060:	75 08                	jne    80306a <open+0x33>
	{
		return r;
  803062:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803065:	e9 f2 00 00 00       	jmpq   80315c <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  80306a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80306e:	48 89 c7             	mov    %rax,%rdi
  803071:	48 b8 bd 11 80 00 00 	movabs $0x8011bd,%rax
  803078:	00 00 00 
  80307b:	ff d0                	callq  *%rax
  80307d:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803080:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  803087:	7e 0a                	jle    803093 <open+0x5c>
	{
		return -E_BAD_PATH;
  803089:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80308e:	e9 c9 00 00 00       	jmpq   80315c <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  803093:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80309a:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  80309b:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80309f:	48 89 c7             	mov    %rax,%rdi
  8030a2:	48 b8 97 26 80 00 00 	movabs $0x802697,%rax
  8030a9:	00 00 00 
  8030ac:	ff d0                	callq  *%rax
  8030ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030b5:	78 09                	js     8030c0 <open+0x89>
  8030b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030bb:	48 85 c0             	test   %rax,%rax
  8030be:	75 08                	jne    8030c8 <open+0x91>
		{
			return r;
  8030c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030c3:	e9 94 00 00 00       	jmpq   80315c <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  8030c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030cc:	ba 00 04 00 00       	mov    $0x400,%edx
  8030d1:	48 89 c6             	mov    %rax,%rsi
  8030d4:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8030db:	00 00 00 
  8030de:	48 b8 bb 12 80 00 00 	movabs $0x8012bb,%rax
  8030e5:	00 00 00 
  8030e8:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  8030ea:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030f1:	00 00 00 
  8030f4:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  8030f7:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  8030fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803101:	48 89 c6             	mov    %rax,%rsi
  803104:	bf 01 00 00 00       	mov    $0x1,%edi
  803109:	48 b8 b0 2f 80 00 00 	movabs $0x802fb0,%rax
  803110:	00 00 00 
  803113:	ff d0                	callq  *%rax
  803115:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803118:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80311c:	79 2b                	jns    803149 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  80311e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803122:	be 00 00 00 00       	mov    $0x0,%esi
  803127:	48 89 c7             	mov    %rax,%rdi
  80312a:	48 b8 bf 27 80 00 00 	movabs $0x8027bf,%rax
  803131:	00 00 00 
  803134:	ff d0                	callq  *%rax
  803136:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803139:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80313d:	79 05                	jns    803144 <open+0x10d>
			{
				return d;
  80313f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803142:	eb 18                	jmp    80315c <open+0x125>
			}
			return r;
  803144:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803147:	eb 13                	jmp    80315c <open+0x125>
		}	
		return fd2num(fd_store);
  803149:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80314d:	48 89 c7             	mov    %rax,%rdi
  803150:	48 b8 49 26 80 00 00 	movabs $0x802649,%rax
  803157:	00 00 00 
  80315a:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  80315c:	c9                   	leaveq 
  80315d:	c3                   	retq   

000000000080315e <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80315e:	55                   	push   %rbp
  80315f:	48 89 e5             	mov    %rsp,%rbp
  803162:	48 83 ec 10          	sub    $0x10,%rsp
  803166:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80316a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80316e:	8b 50 0c             	mov    0xc(%rax),%edx
  803171:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803178:	00 00 00 
  80317b:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80317d:	be 00 00 00 00       	mov    $0x0,%esi
  803182:	bf 06 00 00 00       	mov    $0x6,%edi
  803187:	48 b8 b0 2f 80 00 00 	movabs $0x802fb0,%rax
  80318e:	00 00 00 
  803191:	ff d0                	callq  *%rax
}
  803193:	c9                   	leaveq 
  803194:	c3                   	retq   

0000000000803195 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803195:	55                   	push   %rbp
  803196:	48 89 e5             	mov    %rsp,%rbp
  803199:	48 83 ec 30          	sub    $0x30,%rsp
  80319d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031a1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8031a5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  8031a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  8031b0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8031b5:	74 07                	je     8031be <devfile_read+0x29>
  8031b7:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8031bc:	75 07                	jne    8031c5 <devfile_read+0x30>
		return -E_INVAL;
  8031be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8031c3:	eb 77                	jmp    80323c <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8031c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031c9:	8b 50 0c             	mov    0xc(%rax),%edx
  8031cc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031d3:	00 00 00 
  8031d6:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8031d8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031df:	00 00 00 
  8031e2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8031e6:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  8031ea:	be 00 00 00 00       	mov    $0x0,%esi
  8031ef:	bf 03 00 00 00       	mov    $0x3,%edi
  8031f4:	48 b8 b0 2f 80 00 00 	movabs $0x802fb0,%rax
  8031fb:	00 00 00 
  8031fe:	ff d0                	callq  *%rax
  803200:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803203:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803207:	7f 05                	jg     80320e <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  803209:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80320c:	eb 2e                	jmp    80323c <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  80320e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803211:	48 63 d0             	movslq %eax,%rdx
  803214:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803218:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80321f:	00 00 00 
  803222:	48 89 c7             	mov    %rax,%rdi
  803225:	48 b8 4d 15 80 00 00 	movabs $0x80154d,%rax
  80322c:	00 00 00 
  80322f:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  803231:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803235:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  803239:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  80323c:	c9                   	leaveq 
  80323d:	c3                   	retq   

000000000080323e <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80323e:	55                   	push   %rbp
  80323f:	48 89 e5             	mov    %rsp,%rbp
  803242:	48 83 ec 30          	sub    $0x30,%rsp
  803246:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80324a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80324e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  803252:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  803259:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80325e:	74 07                	je     803267 <devfile_write+0x29>
  803260:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803265:	75 08                	jne    80326f <devfile_write+0x31>
		return r;
  803267:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80326a:	e9 9a 00 00 00       	jmpq   803309 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80326f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803273:	8b 50 0c             	mov    0xc(%rax),%edx
  803276:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80327d:	00 00 00 
  803280:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  803282:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  803289:	00 
  80328a:	76 08                	jbe    803294 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  80328c:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  803293:	00 
	}
	fsipcbuf.write.req_n = n;
  803294:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80329b:	00 00 00 
  80329e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8032a2:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  8032a6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8032aa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032ae:	48 89 c6             	mov    %rax,%rsi
  8032b1:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  8032b8:	00 00 00 
  8032bb:	48 b8 4d 15 80 00 00 	movabs $0x80154d,%rax
  8032c2:	00 00 00 
  8032c5:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  8032c7:	be 00 00 00 00       	mov    $0x0,%esi
  8032cc:	bf 04 00 00 00       	mov    $0x4,%edi
  8032d1:	48 b8 b0 2f 80 00 00 	movabs $0x802fb0,%rax
  8032d8:	00 00 00 
  8032db:	ff d0                	callq  *%rax
  8032dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032e4:	7f 20                	jg     803306 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  8032e6:	48 bf 56 46 80 00 00 	movabs $0x804656,%rdi
  8032ed:	00 00 00 
  8032f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8032f5:	48 ba 74 06 80 00 00 	movabs $0x800674,%rdx
  8032fc:	00 00 00 
  8032ff:	ff d2                	callq  *%rdx
		return r;
  803301:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803304:	eb 03                	jmp    803309 <devfile_write+0xcb>
	}
	return r;
  803306:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  803309:	c9                   	leaveq 
  80330a:	c3                   	retq   

000000000080330b <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80330b:	55                   	push   %rbp
  80330c:	48 89 e5             	mov    %rsp,%rbp
  80330f:	48 83 ec 20          	sub    $0x20,%rsp
  803313:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803317:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80331b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80331f:	8b 50 0c             	mov    0xc(%rax),%edx
  803322:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803329:	00 00 00 
  80332c:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80332e:	be 00 00 00 00       	mov    $0x0,%esi
  803333:	bf 05 00 00 00       	mov    $0x5,%edi
  803338:	48 b8 b0 2f 80 00 00 	movabs $0x802fb0,%rax
  80333f:	00 00 00 
  803342:	ff d0                	callq  *%rax
  803344:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803347:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80334b:	79 05                	jns    803352 <devfile_stat+0x47>
		return r;
  80334d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803350:	eb 56                	jmp    8033a8 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803352:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803356:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80335d:	00 00 00 
  803360:	48 89 c7             	mov    %rax,%rdi
  803363:	48 b8 29 12 80 00 00 	movabs $0x801229,%rax
  80336a:	00 00 00 
  80336d:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80336f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803376:	00 00 00 
  803379:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80337f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803383:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803389:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803390:	00 00 00 
  803393:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803399:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80339d:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8033a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033a8:	c9                   	leaveq 
  8033a9:	c3                   	retq   

00000000008033aa <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8033aa:	55                   	push   %rbp
  8033ab:	48 89 e5             	mov    %rsp,%rbp
  8033ae:	48 83 ec 10          	sub    $0x10,%rsp
  8033b2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8033b6:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8033b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033bd:	8b 50 0c             	mov    0xc(%rax),%edx
  8033c0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8033c7:	00 00 00 
  8033ca:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8033cc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8033d3:	00 00 00 
  8033d6:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8033d9:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8033dc:	be 00 00 00 00       	mov    $0x0,%esi
  8033e1:	bf 02 00 00 00       	mov    $0x2,%edi
  8033e6:	48 b8 b0 2f 80 00 00 	movabs $0x802fb0,%rax
  8033ed:	00 00 00 
  8033f0:	ff d0                	callq  *%rax
}
  8033f2:	c9                   	leaveq 
  8033f3:	c3                   	retq   

00000000008033f4 <remove>:

// Delete a file
int
remove(const char *path)
{
  8033f4:	55                   	push   %rbp
  8033f5:	48 89 e5             	mov    %rsp,%rbp
  8033f8:	48 83 ec 10          	sub    $0x10,%rsp
  8033fc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803400:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803404:	48 89 c7             	mov    %rax,%rdi
  803407:	48 b8 bd 11 80 00 00 	movabs $0x8011bd,%rax
  80340e:	00 00 00 
  803411:	ff d0                	callq  *%rax
  803413:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803418:	7e 07                	jle    803421 <remove+0x2d>
		return -E_BAD_PATH;
  80341a:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80341f:	eb 33                	jmp    803454 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803421:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803425:	48 89 c6             	mov    %rax,%rsi
  803428:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80342f:	00 00 00 
  803432:	48 b8 29 12 80 00 00 	movabs $0x801229,%rax
  803439:	00 00 00 
  80343c:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80343e:	be 00 00 00 00       	mov    $0x0,%esi
  803443:	bf 07 00 00 00       	mov    $0x7,%edi
  803448:	48 b8 b0 2f 80 00 00 	movabs $0x802fb0,%rax
  80344f:	00 00 00 
  803452:	ff d0                	callq  *%rax
}
  803454:	c9                   	leaveq 
  803455:	c3                   	retq   

0000000000803456 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803456:	55                   	push   %rbp
  803457:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80345a:	be 00 00 00 00       	mov    $0x0,%esi
  80345f:	bf 08 00 00 00       	mov    $0x8,%edi
  803464:	48 b8 b0 2f 80 00 00 	movabs $0x802fb0,%rax
  80346b:	00 00 00 
  80346e:	ff d0                	callq  *%rax
}
  803470:	5d                   	pop    %rbp
  803471:	c3                   	retq   

0000000000803472 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803472:	55                   	push   %rbp
  803473:	48 89 e5             	mov    %rsp,%rbp
  803476:	48 83 ec 18          	sub    $0x18,%rsp
  80347a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80347e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803482:	48 c1 e8 15          	shr    $0x15,%rax
  803486:	48 89 c2             	mov    %rax,%rdx
  803489:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803490:	01 00 00 
  803493:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803497:	83 e0 01             	and    $0x1,%eax
  80349a:	48 85 c0             	test   %rax,%rax
  80349d:	75 07                	jne    8034a6 <pageref+0x34>
		return 0;
  80349f:	b8 00 00 00 00       	mov    $0x0,%eax
  8034a4:	eb 53                	jmp    8034f9 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8034a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034aa:	48 c1 e8 0c          	shr    $0xc,%rax
  8034ae:	48 89 c2             	mov    %rax,%rdx
  8034b1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8034b8:	01 00 00 
  8034bb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8034bf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8034c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034c7:	83 e0 01             	and    $0x1,%eax
  8034ca:	48 85 c0             	test   %rax,%rax
  8034cd:	75 07                	jne    8034d6 <pageref+0x64>
		return 0;
  8034cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8034d4:	eb 23                	jmp    8034f9 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8034d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034da:	48 c1 e8 0c          	shr    $0xc,%rax
  8034de:	48 89 c2             	mov    %rax,%rdx
  8034e1:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8034e8:	00 00 00 
  8034eb:	48 c1 e2 04          	shl    $0x4,%rdx
  8034ef:	48 01 d0             	add    %rdx,%rax
  8034f2:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8034f6:	0f b7 c0             	movzwl %ax,%eax
}
  8034f9:	c9                   	leaveq 
  8034fa:	c3                   	retq   

00000000008034fb <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8034fb:	55                   	push   %rbp
  8034fc:	48 89 e5             	mov    %rsp,%rbp
  8034ff:	53                   	push   %rbx
  803500:	48 83 ec 38          	sub    $0x38,%rsp
  803504:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803508:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80350c:	48 89 c7             	mov    %rax,%rdi
  80350f:	48 b8 97 26 80 00 00 	movabs $0x802697,%rax
  803516:	00 00 00 
  803519:	ff d0                	callq  *%rax
  80351b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80351e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803522:	0f 88 bf 01 00 00    	js     8036e7 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803528:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80352c:	ba 07 04 00 00       	mov    $0x407,%edx
  803531:	48 89 c6             	mov    %rax,%rsi
  803534:	bf 00 00 00 00       	mov    $0x0,%edi
  803539:	48 b8 58 1b 80 00 00 	movabs $0x801b58,%rax
  803540:	00 00 00 
  803543:	ff d0                	callq  *%rax
  803545:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803548:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80354c:	0f 88 95 01 00 00    	js     8036e7 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803552:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803556:	48 89 c7             	mov    %rax,%rdi
  803559:	48 b8 97 26 80 00 00 	movabs $0x802697,%rax
  803560:	00 00 00 
  803563:	ff d0                	callq  *%rax
  803565:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803568:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80356c:	0f 88 5d 01 00 00    	js     8036cf <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803572:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803576:	ba 07 04 00 00       	mov    $0x407,%edx
  80357b:	48 89 c6             	mov    %rax,%rsi
  80357e:	bf 00 00 00 00       	mov    $0x0,%edi
  803583:	48 b8 58 1b 80 00 00 	movabs $0x801b58,%rax
  80358a:	00 00 00 
  80358d:	ff d0                	callq  *%rax
  80358f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803592:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803596:	0f 88 33 01 00 00    	js     8036cf <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80359c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035a0:	48 89 c7             	mov    %rax,%rdi
  8035a3:	48 b8 6c 26 80 00 00 	movabs $0x80266c,%rax
  8035aa:	00 00 00 
  8035ad:	ff d0                	callq  *%rax
  8035af:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035b3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035b7:	ba 07 04 00 00       	mov    $0x407,%edx
  8035bc:	48 89 c6             	mov    %rax,%rsi
  8035bf:	bf 00 00 00 00       	mov    $0x0,%edi
  8035c4:	48 b8 58 1b 80 00 00 	movabs $0x801b58,%rax
  8035cb:	00 00 00 
  8035ce:	ff d0                	callq  *%rax
  8035d0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035d3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035d7:	79 05                	jns    8035de <pipe+0xe3>
		goto err2;
  8035d9:	e9 d9 00 00 00       	jmpq   8036b7 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035de:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035e2:	48 89 c7             	mov    %rax,%rdi
  8035e5:	48 b8 6c 26 80 00 00 	movabs $0x80266c,%rax
  8035ec:	00 00 00 
  8035ef:	ff d0                	callq  *%rax
  8035f1:	48 89 c2             	mov    %rax,%rdx
  8035f4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035f8:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8035fe:	48 89 d1             	mov    %rdx,%rcx
  803601:	ba 00 00 00 00       	mov    $0x0,%edx
  803606:	48 89 c6             	mov    %rax,%rsi
  803609:	bf 00 00 00 00       	mov    $0x0,%edi
  80360e:	48 b8 a8 1b 80 00 00 	movabs $0x801ba8,%rax
  803615:	00 00 00 
  803618:	ff d0                	callq  *%rax
  80361a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80361d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803621:	79 1b                	jns    80363e <pipe+0x143>
		goto err3;
  803623:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  803624:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803628:	48 89 c6             	mov    %rax,%rsi
  80362b:	bf 00 00 00 00       	mov    $0x0,%edi
  803630:	48 b8 03 1c 80 00 00 	movabs $0x801c03,%rax
  803637:	00 00 00 
  80363a:	ff d0                	callq  *%rax
  80363c:	eb 79                	jmp    8036b7 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80363e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803642:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803649:	00 00 00 
  80364c:	8b 12                	mov    (%rdx),%edx
  80364e:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803650:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803654:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80365b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80365f:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803666:	00 00 00 
  803669:	8b 12                	mov    (%rdx),%edx
  80366b:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80366d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803671:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803678:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80367c:	48 89 c7             	mov    %rax,%rdi
  80367f:	48 b8 49 26 80 00 00 	movabs $0x802649,%rax
  803686:	00 00 00 
  803689:	ff d0                	callq  *%rax
  80368b:	89 c2                	mov    %eax,%edx
  80368d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803691:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803693:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803697:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80369b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80369f:	48 89 c7             	mov    %rax,%rdi
  8036a2:	48 b8 49 26 80 00 00 	movabs $0x802649,%rax
  8036a9:	00 00 00 
  8036ac:	ff d0                	callq  *%rax
  8036ae:	89 03                	mov    %eax,(%rbx)
	return 0;
  8036b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8036b5:	eb 33                	jmp    8036ea <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  8036b7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036bb:	48 89 c6             	mov    %rax,%rsi
  8036be:	bf 00 00 00 00       	mov    $0x0,%edi
  8036c3:	48 b8 03 1c 80 00 00 	movabs $0x801c03,%rax
  8036ca:	00 00 00 
  8036cd:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  8036cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036d3:	48 89 c6             	mov    %rax,%rsi
  8036d6:	bf 00 00 00 00       	mov    $0x0,%edi
  8036db:	48 b8 03 1c 80 00 00 	movabs $0x801c03,%rax
  8036e2:	00 00 00 
  8036e5:	ff d0                	callq  *%rax
    err:
	return r;
  8036e7:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8036ea:	48 83 c4 38          	add    $0x38,%rsp
  8036ee:	5b                   	pop    %rbx
  8036ef:	5d                   	pop    %rbp
  8036f0:	c3                   	retq   

00000000008036f1 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8036f1:	55                   	push   %rbp
  8036f2:	48 89 e5             	mov    %rsp,%rbp
  8036f5:	53                   	push   %rbx
  8036f6:	48 83 ec 28          	sub    $0x28,%rsp
  8036fa:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8036fe:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803702:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803709:	00 00 00 
  80370c:	48 8b 00             	mov    (%rax),%rax
  80370f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803715:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803718:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80371c:	48 89 c7             	mov    %rax,%rdi
  80371f:	48 b8 72 34 80 00 00 	movabs $0x803472,%rax
  803726:	00 00 00 
  803729:	ff d0                	callq  *%rax
  80372b:	89 c3                	mov    %eax,%ebx
  80372d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803731:	48 89 c7             	mov    %rax,%rdi
  803734:	48 b8 72 34 80 00 00 	movabs $0x803472,%rax
  80373b:	00 00 00 
  80373e:	ff d0                	callq  *%rax
  803740:	39 c3                	cmp    %eax,%ebx
  803742:	0f 94 c0             	sete   %al
  803745:	0f b6 c0             	movzbl %al,%eax
  803748:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80374b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803752:	00 00 00 
  803755:	48 8b 00             	mov    (%rax),%rax
  803758:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80375e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803761:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803764:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803767:	75 05                	jne    80376e <_pipeisclosed+0x7d>
			return ret;
  803769:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80376c:	eb 4f                	jmp    8037bd <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80376e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803771:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803774:	74 42                	je     8037b8 <_pipeisclosed+0xc7>
  803776:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80377a:	75 3c                	jne    8037b8 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80377c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803783:	00 00 00 
  803786:	48 8b 00             	mov    (%rax),%rax
  803789:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80378f:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803792:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803795:	89 c6                	mov    %eax,%esi
  803797:	48 bf 77 46 80 00 00 	movabs $0x804677,%rdi
  80379e:	00 00 00 
  8037a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8037a6:	49 b8 74 06 80 00 00 	movabs $0x800674,%r8
  8037ad:	00 00 00 
  8037b0:	41 ff d0             	callq  *%r8
	}
  8037b3:	e9 4a ff ff ff       	jmpq   803702 <_pipeisclosed+0x11>
  8037b8:	e9 45 ff ff ff       	jmpq   803702 <_pipeisclosed+0x11>
}
  8037bd:	48 83 c4 28          	add    $0x28,%rsp
  8037c1:	5b                   	pop    %rbx
  8037c2:	5d                   	pop    %rbp
  8037c3:	c3                   	retq   

00000000008037c4 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8037c4:	55                   	push   %rbp
  8037c5:	48 89 e5             	mov    %rsp,%rbp
  8037c8:	48 83 ec 30          	sub    $0x30,%rsp
  8037cc:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8037cf:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8037d3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8037d6:	48 89 d6             	mov    %rdx,%rsi
  8037d9:	89 c7                	mov    %eax,%edi
  8037db:	48 b8 2f 27 80 00 00 	movabs $0x80272f,%rax
  8037e2:	00 00 00 
  8037e5:	ff d0                	callq  *%rax
  8037e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037ee:	79 05                	jns    8037f5 <pipeisclosed+0x31>
		return r;
  8037f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037f3:	eb 31                	jmp    803826 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8037f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037f9:	48 89 c7             	mov    %rax,%rdi
  8037fc:	48 b8 6c 26 80 00 00 	movabs $0x80266c,%rax
  803803:	00 00 00 
  803806:	ff d0                	callq  *%rax
  803808:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80380c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803810:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803814:	48 89 d6             	mov    %rdx,%rsi
  803817:	48 89 c7             	mov    %rax,%rdi
  80381a:	48 b8 f1 36 80 00 00 	movabs $0x8036f1,%rax
  803821:	00 00 00 
  803824:	ff d0                	callq  *%rax
}
  803826:	c9                   	leaveq 
  803827:	c3                   	retq   

0000000000803828 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803828:	55                   	push   %rbp
  803829:	48 89 e5             	mov    %rsp,%rbp
  80382c:	48 83 ec 40          	sub    $0x40,%rsp
  803830:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803834:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803838:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80383c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803840:	48 89 c7             	mov    %rax,%rdi
  803843:	48 b8 6c 26 80 00 00 	movabs $0x80266c,%rax
  80384a:	00 00 00 
  80384d:	ff d0                	callq  *%rax
  80384f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803853:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803857:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80385b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803862:	00 
  803863:	e9 92 00 00 00       	jmpq   8038fa <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803868:	eb 41                	jmp    8038ab <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80386a:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80386f:	74 09                	je     80387a <devpipe_read+0x52>
				return i;
  803871:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803875:	e9 92 00 00 00       	jmpq   80390c <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80387a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80387e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803882:	48 89 d6             	mov    %rdx,%rsi
  803885:	48 89 c7             	mov    %rax,%rdi
  803888:	48 b8 f1 36 80 00 00 	movabs $0x8036f1,%rax
  80388f:	00 00 00 
  803892:	ff d0                	callq  *%rax
  803894:	85 c0                	test   %eax,%eax
  803896:	74 07                	je     80389f <devpipe_read+0x77>
				return 0;
  803898:	b8 00 00 00 00       	mov    $0x0,%eax
  80389d:	eb 6d                	jmp    80390c <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80389f:	48 b8 1a 1b 80 00 00 	movabs $0x801b1a,%rax
  8038a6:	00 00 00 
  8038a9:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8038ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038af:	8b 10                	mov    (%rax),%edx
  8038b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038b5:	8b 40 04             	mov    0x4(%rax),%eax
  8038b8:	39 c2                	cmp    %eax,%edx
  8038ba:	74 ae                	je     80386a <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8038bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038c0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8038c4:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8038c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038cc:	8b 00                	mov    (%rax),%eax
  8038ce:	99                   	cltd   
  8038cf:	c1 ea 1b             	shr    $0x1b,%edx
  8038d2:	01 d0                	add    %edx,%eax
  8038d4:	83 e0 1f             	and    $0x1f,%eax
  8038d7:	29 d0                	sub    %edx,%eax
  8038d9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8038dd:	48 98                	cltq   
  8038df:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8038e4:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8038e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038ea:	8b 00                	mov    (%rax),%eax
  8038ec:	8d 50 01             	lea    0x1(%rax),%edx
  8038ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038f3:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8038f5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8038fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038fe:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803902:	0f 82 60 ff ff ff    	jb     803868 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803908:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80390c:	c9                   	leaveq 
  80390d:	c3                   	retq   

000000000080390e <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80390e:	55                   	push   %rbp
  80390f:	48 89 e5             	mov    %rsp,%rbp
  803912:	48 83 ec 40          	sub    $0x40,%rsp
  803916:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80391a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80391e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803922:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803926:	48 89 c7             	mov    %rax,%rdi
  803929:	48 b8 6c 26 80 00 00 	movabs $0x80266c,%rax
  803930:	00 00 00 
  803933:	ff d0                	callq  *%rax
  803935:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803939:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80393d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803941:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803948:	00 
  803949:	e9 8e 00 00 00       	jmpq   8039dc <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80394e:	eb 31                	jmp    803981 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803950:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803954:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803958:	48 89 d6             	mov    %rdx,%rsi
  80395b:	48 89 c7             	mov    %rax,%rdi
  80395e:	48 b8 f1 36 80 00 00 	movabs $0x8036f1,%rax
  803965:	00 00 00 
  803968:	ff d0                	callq  *%rax
  80396a:	85 c0                	test   %eax,%eax
  80396c:	74 07                	je     803975 <devpipe_write+0x67>
				return 0;
  80396e:	b8 00 00 00 00       	mov    $0x0,%eax
  803973:	eb 79                	jmp    8039ee <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803975:	48 b8 1a 1b 80 00 00 	movabs $0x801b1a,%rax
  80397c:	00 00 00 
  80397f:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803981:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803985:	8b 40 04             	mov    0x4(%rax),%eax
  803988:	48 63 d0             	movslq %eax,%rdx
  80398b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80398f:	8b 00                	mov    (%rax),%eax
  803991:	48 98                	cltq   
  803993:	48 83 c0 20          	add    $0x20,%rax
  803997:	48 39 c2             	cmp    %rax,%rdx
  80399a:	73 b4                	jae    803950 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80399c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039a0:	8b 40 04             	mov    0x4(%rax),%eax
  8039a3:	99                   	cltd   
  8039a4:	c1 ea 1b             	shr    $0x1b,%edx
  8039a7:	01 d0                	add    %edx,%eax
  8039a9:	83 e0 1f             	and    $0x1f,%eax
  8039ac:	29 d0                	sub    %edx,%eax
  8039ae:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8039b2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8039b6:	48 01 ca             	add    %rcx,%rdx
  8039b9:	0f b6 0a             	movzbl (%rdx),%ecx
  8039bc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039c0:	48 98                	cltq   
  8039c2:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8039c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039ca:	8b 40 04             	mov    0x4(%rax),%eax
  8039cd:	8d 50 01             	lea    0x1(%rax),%edx
  8039d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039d4:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8039d7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8039dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039e0:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8039e4:	0f 82 64 ff ff ff    	jb     80394e <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8039ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8039ee:	c9                   	leaveq 
  8039ef:	c3                   	retq   

00000000008039f0 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8039f0:	55                   	push   %rbp
  8039f1:	48 89 e5             	mov    %rsp,%rbp
  8039f4:	48 83 ec 20          	sub    $0x20,%rsp
  8039f8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8039fc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803a00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a04:	48 89 c7             	mov    %rax,%rdi
  803a07:	48 b8 6c 26 80 00 00 	movabs $0x80266c,%rax
  803a0e:	00 00 00 
  803a11:	ff d0                	callq  *%rax
  803a13:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803a17:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a1b:	48 be 8a 46 80 00 00 	movabs $0x80468a,%rsi
  803a22:	00 00 00 
  803a25:	48 89 c7             	mov    %rax,%rdi
  803a28:	48 b8 29 12 80 00 00 	movabs $0x801229,%rax
  803a2f:	00 00 00 
  803a32:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803a34:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a38:	8b 50 04             	mov    0x4(%rax),%edx
  803a3b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a3f:	8b 00                	mov    (%rax),%eax
  803a41:	29 c2                	sub    %eax,%edx
  803a43:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a47:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803a4d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a51:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803a58:	00 00 00 
	stat->st_dev = &devpipe;
  803a5b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a5f:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  803a66:	00 00 00 
  803a69:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803a70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a75:	c9                   	leaveq 
  803a76:	c3                   	retq   

0000000000803a77 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803a77:	55                   	push   %rbp
  803a78:	48 89 e5             	mov    %rsp,%rbp
  803a7b:	48 83 ec 10          	sub    $0x10,%rsp
  803a7f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803a83:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a87:	48 89 c6             	mov    %rax,%rsi
  803a8a:	bf 00 00 00 00       	mov    $0x0,%edi
  803a8f:	48 b8 03 1c 80 00 00 	movabs $0x801c03,%rax
  803a96:	00 00 00 
  803a99:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803a9b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a9f:	48 89 c7             	mov    %rax,%rdi
  803aa2:	48 b8 6c 26 80 00 00 	movabs $0x80266c,%rax
  803aa9:	00 00 00 
  803aac:	ff d0                	callq  *%rax
  803aae:	48 89 c6             	mov    %rax,%rsi
  803ab1:	bf 00 00 00 00       	mov    $0x0,%edi
  803ab6:	48 b8 03 1c 80 00 00 	movabs $0x801c03,%rax
  803abd:	00 00 00 
  803ac0:	ff d0                	callq  *%rax
}
  803ac2:	c9                   	leaveq 
  803ac3:	c3                   	retq   

0000000000803ac4 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803ac4:	55                   	push   %rbp
  803ac5:	48 89 e5             	mov    %rsp,%rbp
  803ac8:	48 83 ec 20          	sub    $0x20,%rsp
  803acc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803acf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ad2:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803ad5:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803ad9:	be 01 00 00 00       	mov    $0x1,%esi
  803ade:	48 89 c7             	mov    %rax,%rdi
  803ae1:	48 b8 10 1a 80 00 00 	movabs $0x801a10,%rax
  803ae8:	00 00 00 
  803aeb:	ff d0                	callq  *%rax
}
  803aed:	c9                   	leaveq 
  803aee:	c3                   	retq   

0000000000803aef <getchar>:

int
getchar(void)
{
  803aef:	55                   	push   %rbp
  803af0:	48 89 e5             	mov    %rsp,%rbp
  803af3:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803af7:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803afb:	ba 01 00 00 00       	mov    $0x1,%edx
  803b00:	48 89 c6             	mov    %rax,%rsi
  803b03:	bf 00 00 00 00       	mov    $0x0,%edi
  803b08:	48 b8 61 2b 80 00 00 	movabs $0x802b61,%rax
  803b0f:	00 00 00 
  803b12:	ff d0                	callq  *%rax
  803b14:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803b17:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b1b:	79 05                	jns    803b22 <getchar+0x33>
		return r;
  803b1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b20:	eb 14                	jmp    803b36 <getchar+0x47>
	if (r < 1)
  803b22:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b26:	7f 07                	jg     803b2f <getchar+0x40>
		return -E_EOF;
  803b28:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803b2d:	eb 07                	jmp    803b36 <getchar+0x47>
	return c;
  803b2f:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803b33:	0f b6 c0             	movzbl %al,%eax
}
  803b36:	c9                   	leaveq 
  803b37:	c3                   	retq   

0000000000803b38 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803b38:	55                   	push   %rbp
  803b39:	48 89 e5             	mov    %rsp,%rbp
  803b3c:	48 83 ec 20          	sub    $0x20,%rsp
  803b40:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803b43:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803b47:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b4a:	48 89 d6             	mov    %rdx,%rsi
  803b4d:	89 c7                	mov    %eax,%edi
  803b4f:	48 b8 2f 27 80 00 00 	movabs $0x80272f,%rax
  803b56:	00 00 00 
  803b59:	ff d0                	callq  *%rax
  803b5b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b5e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b62:	79 05                	jns    803b69 <iscons+0x31>
		return r;
  803b64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b67:	eb 1a                	jmp    803b83 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803b69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b6d:	8b 10                	mov    (%rax),%edx
  803b6f:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  803b76:	00 00 00 
  803b79:	8b 00                	mov    (%rax),%eax
  803b7b:	39 c2                	cmp    %eax,%edx
  803b7d:	0f 94 c0             	sete   %al
  803b80:	0f b6 c0             	movzbl %al,%eax
}
  803b83:	c9                   	leaveq 
  803b84:	c3                   	retq   

0000000000803b85 <opencons>:

int
opencons(void)
{
  803b85:	55                   	push   %rbp
  803b86:	48 89 e5             	mov    %rsp,%rbp
  803b89:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803b8d:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803b91:	48 89 c7             	mov    %rax,%rdi
  803b94:	48 b8 97 26 80 00 00 	movabs $0x802697,%rax
  803b9b:	00 00 00 
  803b9e:	ff d0                	callq  *%rax
  803ba0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ba3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ba7:	79 05                	jns    803bae <opencons+0x29>
		return r;
  803ba9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bac:	eb 5b                	jmp    803c09 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803bae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bb2:	ba 07 04 00 00       	mov    $0x407,%edx
  803bb7:	48 89 c6             	mov    %rax,%rsi
  803bba:	bf 00 00 00 00       	mov    $0x0,%edi
  803bbf:	48 b8 58 1b 80 00 00 	movabs $0x801b58,%rax
  803bc6:	00 00 00 
  803bc9:	ff d0                	callq  *%rax
  803bcb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bd2:	79 05                	jns    803bd9 <opencons+0x54>
		return r;
  803bd4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bd7:	eb 30                	jmp    803c09 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803bd9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bdd:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803be4:	00 00 00 
  803be7:	8b 12                	mov    (%rdx),%edx
  803be9:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803beb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bef:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803bf6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bfa:	48 89 c7             	mov    %rax,%rdi
  803bfd:	48 b8 49 26 80 00 00 	movabs $0x802649,%rax
  803c04:	00 00 00 
  803c07:	ff d0                	callq  *%rax
}
  803c09:	c9                   	leaveq 
  803c0a:	c3                   	retq   

0000000000803c0b <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803c0b:	55                   	push   %rbp
  803c0c:	48 89 e5             	mov    %rsp,%rbp
  803c0f:	48 83 ec 30          	sub    $0x30,%rsp
  803c13:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803c17:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c1b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803c1f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803c24:	75 07                	jne    803c2d <devcons_read+0x22>
		return 0;
  803c26:	b8 00 00 00 00       	mov    $0x0,%eax
  803c2b:	eb 4b                	jmp    803c78 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803c2d:	eb 0c                	jmp    803c3b <devcons_read+0x30>
		sys_yield();
  803c2f:	48 b8 1a 1b 80 00 00 	movabs $0x801b1a,%rax
  803c36:	00 00 00 
  803c39:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803c3b:	48 b8 5a 1a 80 00 00 	movabs $0x801a5a,%rax
  803c42:	00 00 00 
  803c45:	ff d0                	callq  *%rax
  803c47:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c4a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c4e:	74 df                	je     803c2f <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803c50:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c54:	79 05                	jns    803c5b <devcons_read+0x50>
		return c;
  803c56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c59:	eb 1d                	jmp    803c78 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803c5b:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803c5f:	75 07                	jne    803c68 <devcons_read+0x5d>
		return 0;
  803c61:	b8 00 00 00 00       	mov    $0x0,%eax
  803c66:	eb 10                	jmp    803c78 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803c68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c6b:	89 c2                	mov    %eax,%edx
  803c6d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c71:	88 10                	mov    %dl,(%rax)
	return 1;
  803c73:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803c78:	c9                   	leaveq 
  803c79:	c3                   	retq   

0000000000803c7a <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803c7a:	55                   	push   %rbp
  803c7b:	48 89 e5             	mov    %rsp,%rbp
  803c7e:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803c85:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803c8c:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803c93:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803c9a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803ca1:	eb 76                	jmp    803d19 <devcons_write+0x9f>
		m = n - tot;
  803ca3:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803caa:	89 c2                	mov    %eax,%edx
  803cac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803caf:	29 c2                	sub    %eax,%edx
  803cb1:	89 d0                	mov    %edx,%eax
  803cb3:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803cb6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803cb9:	83 f8 7f             	cmp    $0x7f,%eax
  803cbc:	76 07                	jbe    803cc5 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803cbe:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803cc5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803cc8:	48 63 d0             	movslq %eax,%rdx
  803ccb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cce:	48 63 c8             	movslq %eax,%rcx
  803cd1:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803cd8:	48 01 c1             	add    %rax,%rcx
  803cdb:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803ce2:	48 89 ce             	mov    %rcx,%rsi
  803ce5:	48 89 c7             	mov    %rax,%rdi
  803ce8:	48 b8 4d 15 80 00 00 	movabs $0x80154d,%rax
  803cef:	00 00 00 
  803cf2:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803cf4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803cf7:	48 63 d0             	movslq %eax,%rdx
  803cfa:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803d01:	48 89 d6             	mov    %rdx,%rsi
  803d04:	48 89 c7             	mov    %rax,%rdi
  803d07:	48 b8 10 1a 80 00 00 	movabs $0x801a10,%rax
  803d0e:	00 00 00 
  803d11:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803d13:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d16:	01 45 fc             	add    %eax,-0x4(%rbp)
  803d19:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d1c:	48 98                	cltq   
  803d1e:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803d25:	0f 82 78 ff ff ff    	jb     803ca3 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803d2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803d2e:	c9                   	leaveq 
  803d2f:	c3                   	retq   

0000000000803d30 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803d30:	55                   	push   %rbp
  803d31:	48 89 e5             	mov    %rsp,%rbp
  803d34:	48 83 ec 08          	sub    $0x8,%rsp
  803d38:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803d3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d41:	c9                   	leaveq 
  803d42:	c3                   	retq   

0000000000803d43 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803d43:	55                   	push   %rbp
  803d44:	48 89 e5             	mov    %rsp,%rbp
  803d47:	48 83 ec 10          	sub    $0x10,%rsp
  803d4b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803d4f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803d53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d57:	48 be 96 46 80 00 00 	movabs $0x804696,%rsi
  803d5e:	00 00 00 
  803d61:	48 89 c7             	mov    %rax,%rdi
  803d64:	48 b8 29 12 80 00 00 	movabs $0x801229,%rax
  803d6b:	00 00 00 
  803d6e:	ff d0                	callq  *%rax
	return 0;
  803d70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d75:	c9                   	leaveq 
  803d76:	c3                   	retq   

0000000000803d77 <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803d77:	55                   	push   %rbp
  803d78:	48 89 e5             	mov    %rsp,%rbp
  803d7b:	48 83 ec 10          	sub    $0x10,%rsp
  803d7f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  803d83:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803d8a:	00 00 00 
  803d8d:	48 8b 00             	mov    (%rax),%rax
  803d90:	48 85 c0             	test   %rax,%rax
  803d93:	0f 85 84 00 00 00    	jne    803e1d <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  803d99:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803da0:	00 00 00 
  803da3:	48 8b 00             	mov    (%rax),%rax
  803da6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803dac:	ba 07 00 00 00       	mov    $0x7,%edx
  803db1:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803db6:	89 c7                	mov    %eax,%edi
  803db8:	48 b8 58 1b 80 00 00 	movabs $0x801b58,%rax
  803dbf:	00 00 00 
  803dc2:	ff d0                	callq  *%rax
  803dc4:	85 c0                	test   %eax,%eax
  803dc6:	79 2a                	jns    803df2 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  803dc8:	48 ba a0 46 80 00 00 	movabs $0x8046a0,%rdx
  803dcf:	00 00 00 
  803dd2:	be 23 00 00 00       	mov    $0x23,%esi
  803dd7:	48 bf c7 46 80 00 00 	movabs $0x8046c7,%rdi
  803dde:	00 00 00 
  803de1:	b8 00 00 00 00       	mov    $0x0,%eax
  803de6:	48 b9 3b 04 80 00 00 	movabs $0x80043b,%rcx
  803ded:	00 00 00 
  803df0:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  803df2:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803df9:	00 00 00 
  803dfc:	48 8b 00             	mov    (%rax),%rax
  803dff:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803e05:	48 be 30 3e 80 00 00 	movabs $0x803e30,%rsi
  803e0c:	00 00 00 
  803e0f:	89 c7                	mov    %eax,%edi
  803e11:	48 b8 e2 1c 80 00 00 	movabs $0x801ce2,%rax
  803e18:	00 00 00 
  803e1b:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  803e1d:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803e24:	00 00 00 
  803e27:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803e2b:	48 89 10             	mov    %rdx,(%rax)
}
  803e2e:	c9                   	leaveq 
  803e2f:	c3                   	retq   

0000000000803e30 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  803e30:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  803e33:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  803e3a:	00 00 00 
	call *%rax
  803e3d:	ff d0                	callq  *%rax


	/*This code is to be removed*/

	// LAB 4: Your code here.
	movq 136(%rsp), %rbx  //Load RIP 
  803e3f:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  803e46:	00 
	movq 152(%rsp), %rcx  //Load RSP
  803e47:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  803e4e:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  803e4f:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  803e53:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  803e56:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  803e5d:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  803e5e:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  803e62:	4c 8b 3c 24          	mov    (%rsp),%r15
  803e66:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803e6b:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803e70:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803e75:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803e7a:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803e7f:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803e84:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803e89:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803e8e:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803e93:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803e98:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803e9d:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803ea2:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803ea7:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803eac:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  803eb0:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  803eb4:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  803eb5:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  803eb6:	c3                   	retq   
