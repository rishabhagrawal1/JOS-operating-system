
obj/user/stresssched.debug:     file format elf64-x86-64


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
  80003c:	e8 74 01 00 00       	callq  8001b5 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

volatile int counter;

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();
  800052:	48 b8 04 19 80 00 00 	movabs $0x801904,%rax
  800059:	00 00 00 
  80005c:	ff d0                	callq  *%rax
  80005e:	89 45 f4             	mov    %eax,-0xc(%rbp)

	// Fork several environments
	for (i = 0; i < 20; i++)
  800061:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800068:	eb 16                	jmp    800080 <umain+0x3d>
		if (fork() == 0)
  80006a:	48 b8 a0 20 80 00 00 	movabs $0x8020a0,%rax
  800071:	00 00 00 
  800074:	ff d0                	callq  *%rax
  800076:	85 c0                	test   %eax,%eax
  800078:	75 02                	jne    80007c <umain+0x39>
			break;
  80007a:	eb 0a                	jmp    800086 <umain+0x43>
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();

	// Fork several environments
	for (i = 0; i < 20; i++)
  80007c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800080:	83 7d fc 13          	cmpl   $0x13,-0x4(%rbp)
  800084:	7e e4                	jle    80006a <umain+0x27>
		if (fork() == 0)
			break;
	if (i == 20) {
  800086:	83 7d fc 14          	cmpl   $0x14,-0x4(%rbp)
  80008a:	75 11                	jne    80009d <umain+0x5a>
		sys_yield();
  80008c:	48 b8 42 19 80 00 00 	movabs $0x801942,%rax
  800093:	00 00 00 
  800096:	ff d0                	callq  *%rax
		return;
  800098:	e9 16 01 00 00       	jmpq   8001b3 <umain+0x170>
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  80009d:	eb 02                	jmp    8000a1 <umain+0x5e>
		asm volatile("pause");
  80009f:	f3 90                	pause  
		sys_yield();
		return;
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  8000a1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8000a4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000a9:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8000b0:	00 00 00 
  8000b3:	48 63 d0             	movslq %eax,%rdx
  8000b6:	48 89 d0             	mov    %rdx,%rax
  8000b9:	48 c1 e0 03          	shl    $0x3,%rax
  8000bd:	48 01 d0             	add    %rdx,%rax
  8000c0:	48 c1 e0 05          	shl    $0x5,%rax
  8000c4:	48 01 c8             	add    %rcx,%rax
  8000c7:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8000cd:	8b 40 04             	mov    0x4(%rax),%eax
  8000d0:	85 c0                	test   %eax,%eax
  8000d2:	75 cb                	jne    80009f <umain+0x5c>
		asm volatile("pause");

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
  8000d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8000db:	eb 41                	jmp    80011e <umain+0xdb>
		sys_yield();
  8000dd:	48 b8 42 19 80 00 00 	movabs $0x801942,%rax
  8000e4:	00 00 00 
  8000e7:	ff d0                	callq  *%rax
		for (j = 0; j < 10000; j++)
  8000e9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8000f0:	eb 1f                	jmp    800111 <umain+0xce>
			counter++;
  8000f2:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8000f9:	00 00 00 
  8000fc:	8b 00                	mov    (%rax),%eax
  8000fe:	8d 50 01             	lea    0x1(%rax),%edx
  800101:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800108:	00 00 00 
  80010b:	89 10                	mov    %edx,(%rax)
		asm volatile("pause");

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
		sys_yield();
		for (j = 0; j < 10000; j++)
  80010d:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  800111:	81 7d f8 0f 27 00 00 	cmpl   $0x270f,-0x8(%rbp)
  800118:	7e d8                	jle    8000f2 <umain+0xaf>
	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
		asm volatile("pause");

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
  80011a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80011e:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
  800122:	7e b9                	jle    8000dd <umain+0x9a>
		sys_yield();
		for (j = 0; j < 10000; j++)
			counter++;
	}

	if (counter != 10*10000)
  800124:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80012b:	00 00 00 
  80012e:	8b 00                	mov    (%rax),%eax
  800130:	3d a0 86 01 00       	cmp    $0x186a0,%eax
  800135:	74 39                	je     800170 <umain+0x12d>
		panic("ran on two CPUs at once (counter is %d)", counter);
  800137:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80013e:	00 00 00 
  800141:	8b 00                	mov    (%rax),%eax
  800143:	89 c1                	mov    %eax,%ecx
  800145:	48 ba a0 47 80 00 00 	movabs $0x8047a0,%rdx
  80014c:	00 00 00 
  80014f:	be 21 00 00 00       	mov    $0x21,%esi
  800154:	48 bf c8 47 80 00 00 	movabs $0x8047c8,%rdi
  80015b:	00 00 00 
  80015e:	b8 00 00 00 00       	mov    $0x0,%eax
  800163:	49 b8 63 02 80 00 00 	movabs $0x800263,%r8
  80016a:	00 00 00 
  80016d:	41 ff d0             	callq  *%r8

	// Check that we see environments running on different CPUs
	cprintf("[%08x] stresssched on CPU %d\n", thisenv->env_id, thisenv->env_cpunum);
  800170:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  800177:	00 00 00 
  80017a:	48 8b 00             	mov    (%rax),%rax
  80017d:	8b 90 dc 00 00 00    	mov    0xdc(%rax),%edx
  800183:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  80018a:	00 00 00 
  80018d:	48 8b 00             	mov    (%rax),%rax
  800190:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800196:	89 c6                	mov    %eax,%esi
  800198:	48 bf db 47 80 00 00 	movabs $0x8047db,%rdi
  80019f:	00 00 00 
  8001a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a7:	48 b9 9c 04 80 00 00 	movabs $0x80049c,%rcx
  8001ae:	00 00 00 
  8001b1:	ff d1                	callq  *%rcx

}
  8001b3:	c9                   	leaveq 
  8001b4:	c3                   	retq   

00000000008001b5 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001b5:	55                   	push   %rbp
  8001b6:	48 89 e5             	mov    %rsp,%rbp
  8001b9:	48 83 ec 10          	sub    $0x10,%rsp
  8001bd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001c0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001c4:	48 b8 04 19 80 00 00 	movabs $0x801904,%rax
  8001cb:	00 00 00 
  8001ce:	ff d0                	callq  *%rax
  8001d0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001d5:	48 63 d0             	movslq %eax,%rdx
  8001d8:	48 89 d0             	mov    %rdx,%rax
  8001db:	48 c1 e0 03          	shl    $0x3,%rax
  8001df:	48 01 d0             	add    %rdx,%rax
  8001e2:	48 c1 e0 05          	shl    $0x5,%rax
  8001e6:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8001ed:	00 00 00 
  8001f0:	48 01 c2             	add    %rax,%rdx
  8001f3:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8001fa:	00 00 00 
  8001fd:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800200:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800204:	7e 14                	jle    80021a <libmain+0x65>
		binaryname = argv[0];
  800206:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80020a:	48 8b 10             	mov    (%rax),%rdx
  80020d:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800214:	00 00 00 
  800217:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80021a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80021e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800221:	48 89 d6             	mov    %rdx,%rsi
  800224:	89 c7                	mov    %eax,%edi
  800226:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80022d:	00 00 00 
  800230:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  800232:	48 b8 40 02 80 00 00 	movabs $0x800240,%rax
  800239:	00 00 00 
  80023c:	ff d0                	callq  *%rax
}
  80023e:	c9                   	leaveq 
  80023f:	c3                   	retq   

0000000000800240 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800240:	55                   	push   %rbp
  800241:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800244:	48 b8 92 26 80 00 00 	movabs $0x802692,%rax
  80024b:	00 00 00 
  80024e:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800250:	bf 00 00 00 00       	mov    $0x0,%edi
  800255:	48 b8 c0 18 80 00 00 	movabs $0x8018c0,%rax
  80025c:	00 00 00 
  80025f:	ff d0                	callq  *%rax

}
  800261:	5d                   	pop    %rbp
  800262:	c3                   	retq   

0000000000800263 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800263:	55                   	push   %rbp
  800264:	48 89 e5             	mov    %rsp,%rbp
  800267:	53                   	push   %rbx
  800268:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80026f:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800276:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80027c:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800283:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80028a:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800291:	84 c0                	test   %al,%al
  800293:	74 23                	je     8002b8 <_panic+0x55>
  800295:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80029c:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8002a0:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8002a4:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8002a8:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8002ac:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8002b0:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8002b4:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8002b8:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8002bf:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8002c6:	00 00 00 
  8002c9:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8002d0:	00 00 00 
  8002d3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002d7:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8002de:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8002e5:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002ec:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002f3:	00 00 00 
  8002f6:	48 8b 18             	mov    (%rax),%rbx
  8002f9:	48 b8 04 19 80 00 00 	movabs $0x801904,%rax
  800300:	00 00 00 
  800303:	ff d0                	callq  *%rax
  800305:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80030b:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800312:	41 89 c8             	mov    %ecx,%r8d
  800315:	48 89 d1             	mov    %rdx,%rcx
  800318:	48 89 da             	mov    %rbx,%rdx
  80031b:	89 c6                	mov    %eax,%esi
  80031d:	48 bf 08 48 80 00 00 	movabs $0x804808,%rdi
  800324:	00 00 00 
  800327:	b8 00 00 00 00       	mov    $0x0,%eax
  80032c:	49 b9 9c 04 80 00 00 	movabs $0x80049c,%r9
  800333:	00 00 00 
  800336:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800339:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800340:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800347:	48 89 d6             	mov    %rdx,%rsi
  80034a:	48 89 c7             	mov    %rax,%rdi
  80034d:	48 b8 f0 03 80 00 00 	movabs $0x8003f0,%rax
  800354:	00 00 00 
  800357:	ff d0                	callq  *%rax
	cprintf("\n");
  800359:	48 bf 2b 48 80 00 00 	movabs $0x80482b,%rdi
  800360:	00 00 00 
  800363:	b8 00 00 00 00       	mov    $0x0,%eax
  800368:	48 ba 9c 04 80 00 00 	movabs $0x80049c,%rdx
  80036f:	00 00 00 
  800372:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800374:	cc                   	int3   
  800375:	eb fd                	jmp    800374 <_panic+0x111>

0000000000800377 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800377:	55                   	push   %rbp
  800378:	48 89 e5             	mov    %rsp,%rbp
  80037b:	48 83 ec 10          	sub    $0x10,%rsp
  80037f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800382:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800386:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80038a:	8b 00                	mov    (%rax),%eax
  80038c:	8d 48 01             	lea    0x1(%rax),%ecx
  80038f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800393:	89 0a                	mov    %ecx,(%rdx)
  800395:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800398:	89 d1                	mov    %edx,%ecx
  80039a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80039e:	48 98                	cltq   
  8003a0:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8003a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003a8:	8b 00                	mov    (%rax),%eax
  8003aa:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003af:	75 2c                	jne    8003dd <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8003b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003b5:	8b 00                	mov    (%rax),%eax
  8003b7:	48 98                	cltq   
  8003b9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003bd:	48 83 c2 08          	add    $0x8,%rdx
  8003c1:	48 89 c6             	mov    %rax,%rsi
  8003c4:	48 89 d7             	mov    %rdx,%rdi
  8003c7:	48 b8 38 18 80 00 00 	movabs $0x801838,%rax
  8003ce:	00 00 00 
  8003d1:	ff d0                	callq  *%rax
        b->idx = 0;
  8003d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003d7:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8003dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003e1:	8b 40 04             	mov    0x4(%rax),%eax
  8003e4:	8d 50 01             	lea    0x1(%rax),%edx
  8003e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003eb:	89 50 04             	mov    %edx,0x4(%rax)
}
  8003ee:	c9                   	leaveq 
  8003ef:	c3                   	retq   

00000000008003f0 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8003f0:	55                   	push   %rbp
  8003f1:	48 89 e5             	mov    %rsp,%rbp
  8003f4:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8003fb:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800402:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800409:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800410:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800417:	48 8b 0a             	mov    (%rdx),%rcx
  80041a:	48 89 08             	mov    %rcx,(%rax)
  80041d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800421:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800425:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800429:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80042d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800434:	00 00 00 
    b.cnt = 0;
  800437:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80043e:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800441:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800448:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80044f:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800456:	48 89 c6             	mov    %rax,%rsi
  800459:	48 bf 77 03 80 00 00 	movabs $0x800377,%rdi
  800460:	00 00 00 
  800463:	48 b8 4f 08 80 00 00 	movabs $0x80084f,%rax
  80046a:	00 00 00 
  80046d:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80046f:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800475:	48 98                	cltq   
  800477:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80047e:	48 83 c2 08          	add    $0x8,%rdx
  800482:	48 89 c6             	mov    %rax,%rsi
  800485:	48 89 d7             	mov    %rdx,%rdi
  800488:	48 b8 38 18 80 00 00 	movabs $0x801838,%rax
  80048f:	00 00 00 
  800492:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800494:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80049a:	c9                   	leaveq 
  80049b:	c3                   	retq   

000000000080049c <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80049c:	55                   	push   %rbp
  80049d:	48 89 e5             	mov    %rsp,%rbp
  8004a0:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8004a7:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004ae:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004b5:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004bc:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004c3:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004ca:	84 c0                	test   %al,%al
  8004cc:	74 20                	je     8004ee <cprintf+0x52>
  8004ce:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004d2:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004d6:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004da:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004de:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004e2:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004e6:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004ea:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8004ee:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8004f5:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8004fc:	00 00 00 
  8004ff:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800506:	00 00 00 
  800509:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80050d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800514:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80051b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800522:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800529:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800530:	48 8b 0a             	mov    (%rdx),%rcx
  800533:	48 89 08             	mov    %rcx,(%rax)
  800536:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80053a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80053e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800542:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800546:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80054d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800554:	48 89 d6             	mov    %rdx,%rsi
  800557:	48 89 c7             	mov    %rax,%rdi
  80055a:	48 b8 f0 03 80 00 00 	movabs $0x8003f0,%rax
  800561:	00 00 00 
  800564:	ff d0                	callq  *%rax
  800566:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80056c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800572:	c9                   	leaveq 
  800573:	c3                   	retq   

0000000000800574 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800574:	55                   	push   %rbp
  800575:	48 89 e5             	mov    %rsp,%rbp
  800578:	53                   	push   %rbx
  800579:	48 83 ec 38          	sub    $0x38,%rsp
  80057d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800581:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800585:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800589:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80058c:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800590:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800594:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800597:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80059b:	77 3b                	ja     8005d8 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80059d:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8005a0:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8005a4:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8005a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b0:	48 f7 f3             	div    %rbx
  8005b3:	48 89 c2             	mov    %rax,%rdx
  8005b6:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8005b9:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005bc:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8005c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c4:	41 89 f9             	mov    %edi,%r9d
  8005c7:	48 89 c7             	mov    %rax,%rdi
  8005ca:	48 b8 74 05 80 00 00 	movabs $0x800574,%rax
  8005d1:	00 00 00 
  8005d4:	ff d0                	callq  *%rax
  8005d6:	eb 1e                	jmp    8005f6 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005d8:	eb 12                	jmp    8005ec <printnum+0x78>
			putch(padc, putdat);
  8005da:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005de:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8005e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e5:	48 89 ce             	mov    %rcx,%rsi
  8005e8:	89 d7                	mov    %edx,%edi
  8005ea:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005ec:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8005f0:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8005f4:	7f e4                	jg     8005da <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005f6:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005fd:	ba 00 00 00 00       	mov    $0x0,%edx
  800602:	48 f7 f1             	div    %rcx
  800605:	48 89 d0             	mov    %rdx,%rax
  800608:	48 ba 30 4a 80 00 00 	movabs $0x804a30,%rdx
  80060f:	00 00 00 
  800612:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800616:	0f be d0             	movsbl %al,%edx
  800619:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80061d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800621:	48 89 ce             	mov    %rcx,%rsi
  800624:	89 d7                	mov    %edx,%edi
  800626:	ff d0                	callq  *%rax
}
  800628:	48 83 c4 38          	add    $0x38,%rsp
  80062c:	5b                   	pop    %rbx
  80062d:	5d                   	pop    %rbp
  80062e:	c3                   	retq   

000000000080062f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80062f:	55                   	push   %rbp
  800630:	48 89 e5             	mov    %rsp,%rbp
  800633:	48 83 ec 1c          	sub    $0x1c,%rsp
  800637:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80063b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80063e:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800642:	7e 52                	jle    800696 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800644:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800648:	8b 00                	mov    (%rax),%eax
  80064a:	83 f8 30             	cmp    $0x30,%eax
  80064d:	73 24                	jae    800673 <getuint+0x44>
  80064f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800653:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800657:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80065b:	8b 00                	mov    (%rax),%eax
  80065d:	89 c0                	mov    %eax,%eax
  80065f:	48 01 d0             	add    %rdx,%rax
  800662:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800666:	8b 12                	mov    (%rdx),%edx
  800668:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80066b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80066f:	89 0a                	mov    %ecx,(%rdx)
  800671:	eb 17                	jmp    80068a <getuint+0x5b>
  800673:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800677:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80067b:	48 89 d0             	mov    %rdx,%rax
  80067e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800682:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800686:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80068a:	48 8b 00             	mov    (%rax),%rax
  80068d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800691:	e9 a3 00 00 00       	jmpq   800739 <getuint+0x10a>
	else if (lflag)
  800696:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80069a:	74 4f                	je     8006eb <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80069c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a0:	8b 00                	mov    (%rax),%eax
  8006a2:	83 f8 30             	cmp    $0x30,%eax
  8006a5:	73 24                	jae    8006cb <getuint+0x9c>
  8006a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ab:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b3:	8b 00                	mov    (%rax),%eax
  8006b5:	89 c0                	mov    %eax,%eax
  8006b7:	48 01 d0             	add    %rdx,%rax
  8006ba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006be:	8b 12                	mov    (%rdx),%edx
  8006c0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c7:	89 0a                	mov    %ecx,(%rdx)
  8006c9:	eb 17                	jmp    8006e2 <getuint+0xb3>
  8006cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006cf:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006d3:	48 89 d0             	mov    %rdx,%rax
  8006d6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006da:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006de:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006e2:	48 8b 00             	mov    (%rax),%rax
  8006e5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006e9:	eb 4e                	jmp    800739 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8006eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ef:	8b 00                	mov    (%rax),%eax
  8006f1:	83 f8 30             	cmp    $0x30,%eax
  8006f4:	73 24                	jae    80071a <getuint+0xeb>
  8006f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006fa:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800702:	8b 00                	mov    (%rax),%eax
  800704:	89 c0                	mov    %eax,%eax
  800706:	48 01 d0             	add    %rdx,%rax
  800709:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80070d:	8b 12                	mov    (%rdx),%edx
  80070f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800712:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800716:	89 0a                	mov    %ecx,(%rdx)
  800718:	eb 17                	jmp    800731 <getuint+0x102>
  80071a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80071e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800722:	48 89 d0             	mov    %rdx,%rax
  800725:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800729:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80072d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800731:	8b 00                	mov    (%rax),%eax
  800733:	89 c0                	mov    %eax,%eax
  800735:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800739:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80073d:	c9                   	leaveq 
  80073e:	c3                   	retq   

000000000080073f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80073f:	55                   	push   %rbp
  800740:	48 89 e5             	mov    %rsp,%rbp
  800743:	48 83 ec 1c          	sub    $0x1c,%rsp
  800747:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80074b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80074e:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800752:	7e 52                	jle    8007a6 <getint+0x67>
		x=va_arg(*ap, long long);
  800754:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800758:	8b 00                	mov    (%rax),%eax
  80075a:	83 f8 30             	cmp    $0x30,%eax
  80075d:	73 24                	jae    800783 <getint+0x44>
  80075f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800763:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800767:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80076b:	8b 00                	mov    (%rax),%eax
  80076d:	89 c0                	mov    %eax,%eax
  80076f:	48 01 d0             	add    %rdx,%rax
  800772:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800776:	8b 12                	mov    (%rdx),%edx
  800778:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80077b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80077f:	89 0a                	mov    %ecx,(%rdx)
  800781:	eb 17                	jmp    80079a <getint+0x5b>
  800783:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800787:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80078b:	48 89 d0             	mov    %rdx,%rax
  80078e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800792:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800796:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80079a:	48 8b 00             	mov    (%rax),%rax
  80079d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007a1:	e9 a3 00 00 00       	jmpq   800849 <getint+0x10a>
	else if (lflag)
  8007a6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007aa:	74 4f                	je     8007fb <getint+0xbc>
		x=va_arg(*ap, long);
  8007ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b0:	8b 00                	mov    (%rax),%eax
  8007b2:	83 f8 30             	cmp    $0x30,%eax
  8007b5:	73 24                	jae    8007db <getint+0x9c>
  8007b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007bb:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c3:	8b 00                	mov    (%rax),%eax
  8007c5:	89 c0                	mov    %eax,%eax
  8007c7:	48 01 d0             	add    %rdx,%rax
  8007ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ce:	8b 12                	mov    (%rdx),%edx
  8007d0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d7:	89 0a                	mov    %ecx,(%rdx)
  8007d9:	eb 17                	jmp    8007f2 <getint+0xb3>
  8007db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007df:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007e3:	48 89 d0             	mov    %rdx,%rax
  8007e6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007ea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ee:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007f2:	48 8b 00             	mov    (%rax),%rax
  8007f5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007f9:	eb 4e                	jmp    800849 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8007fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ff:	8b 00                	mov    (%rax),%eax
  800801:	83 f8 30             	cmp    $0x30,%eax
  800804:	73 24                	jae    80082a <getint+0xeb>
  800806:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80080a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80080e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800812:	8b 00                	mov    (%rax),%eax
  800814:	89 c0                	mov    %eax,%eax
  800816:	48 01 d0             	add    %rdx,%rax
  800819:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80081d:	8b 12                	mov    (%rdx),%edx
  80081f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800822:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800826:	89 0a                	mov    %ecx,(%rdx)
  800828:	eb 17                	jmp    800841 <getint+0x102>
  80082a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80082e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800832:	48 89 d0             	mov    %rdx,%rax
  800835:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800839:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80083d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800841:	8b 00                	mov    (%rax),%eax
  800843:	48 98                	cltq   
  800845:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800849:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80084d:	c9                   	leaveq 
  80084e:	c3                   	retq   

000000000080084f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80084f:	55                   	push   %rbp
  800850:	48 89 e5             	mov    %rsp,%rbp
  800853:	41 54                	push   %r12
  800855:	53                   	push   %rbx
  800856:	48 83 ec 60          	sub    $0x60,%rsp
  80085a:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80085e:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800862:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800866:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80086a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80086e:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800872:	48 8b 0a             	mov    (%rdx),%rcx
  800875:	48 89 08             	mov    %rcx,(%rax)
  800878:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80087c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800880:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800884:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800888:	eb 17                	jmp    8008a1 <vprintfmt+0x52>
			if (ch == '\0')
  80088a:	85 db                	test   %ebx,%ebx
  80088c:	0f 84 cc 04 00 00    	je     800d5e <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800892:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800896:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80089a:	48 89 d6             	mov    %rdx,%rsi
  80089d:	89 df                	mov    %ebx,%edi
  80089f:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008a1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008a5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008a9:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008ad:	0f b6 00             	movzbl (%rax),%eax
  8008b0:	0f b6 d8             	movzbl %al,%ebx
  8008b3:	83 fb 25             	cmp    $0x25,%ebx
  8008b6:	75 d2                	jne    80088a <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008b8:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8008bc:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008c3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008ca:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008d1:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008d8:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008dc:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008e0:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008e4:	0f b6 00             	movzbl (%rax),%eax
  8008e7:	0f b6 d8             	movzbl %al,%ebx
  8008ea:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8008ed:	83 f8 55             	cmp    $0x55,%eax
  8008f0:	0f 87 34 04 00 00    	ja     800d2a <vprintfmt+0x4db>
  8008f6:	89 c0                	mov    %eax,%eax
  8008f8:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8008ff:	00 
  800900:	48 b8 58 4a 80 00 00 	movabs $0x804a58,%rax
  800907:	00 00 00 
  80090a:	48 01 d0             	add    %rdx,%rax
  80090d:	48 8b 00             	mov    (%rax),%rax
  800910:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800912:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800916:	eb c0                	jmp    8008d8 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800918:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80091c:	eb ba                	jmp    8008d8 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80091e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800925:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800928:	89 d0                	mov    %edx,%eax
  80092a:	c1 e0 02             	shl    $0x2,%eax
  80092d:	01 d0                	add    %edx,%eax
  80092f:	01 c0                	add    %eax,%eax
  800931:	01 d8                	add    %ebx,%eax
  800933:	83 e8 30             	sub    $0x30,%eax
  800936:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800939:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80093d:	0f b6 00             	movzbl (%rax),%eax
  800940:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800943:	83 fb 2f             	cmp    $0x2f,%ebx
  800946:	7e 0c                	jle    800954 <vprintfmt+0x105>
  800948:	83 fb 39             	cmp    $0x39,%ebx
  80094b:	7f 07                	jg     800954 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80094d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800952:	eb d1                	jmp    800925 <vprintfmt+0xd6>
			goto process_precision;
  800954:	eb 58                	jmp    8009ae <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800956:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800959:	83 f8 30             	cmp    $0x30,%eax
  80095c:	73 17                	jae    800975 <vprintfmt+0x126>
  80095e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800962:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800965:	89 c0                	mov    %eax,%eax
  800967:	48 01 d0             	add    %rdx,%rax
  80096a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80096d:	83 c2 08             	add    $0x8,%edx
  800970:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800973:	eb 0f                	jmp    800984 <vprintfmt+0x135>
  800975:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800979:	48 89 d0             	mov    %rdx,%rax
  80097c:	48 83 c2 08          	add    $0x8,%rdx
  800980:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800984:	8b 00                	mov    (%rax),%eax
  800986:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800989:	eb 23                	jmp    8009ae <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80098b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80098f:	79 0c                	jns    80099d <vprintfmt+0x14e>
				width = 0;
  800991:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800998:	e9 3b ff ff ff       	jmpq   8008d8 <vprintfmt+0x89>
  80099d:	e9 36 ff ff ff       	jmpq   8008d8 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8009a2:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8009a9:	e9 2a ff ff ff       	jmpq   8008d8 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8009ae:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009b2:	79 12                	jns    8009c6 <vprintfmt+0x177>
				width = precision, precision = -1;
  8009b4:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009b7:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8009ba:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8009c1:	e9 12 ff ff ff       	jmpq   8008d8 <vprintfmt+0x89>
  8009c6:	e9 0d ff ff ff       	jmpq   8008d8 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009cb:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009cf:	e9 04 ff ff ff       	jmpq   8008d8 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8009d4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009d7:	83 f8 30             	cmp    $0x30,%eax
  8009da:	73 17                	jae    8009f3 <vprintfmt+0x1a4>
  8009dc:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009e0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009e3:	89 c0                	mov    %eax,%eax
  8009e5:	48 01 d0             	add    %rdx,%rax
  8009e8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009eb:	83 c2 08             	add    $0x8,%edx
  8009ee:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009f1:	eb 0f                	jmp    800a02 <vprintfmt+0x1b3>
  8009f3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009f7:	48 89 d0             	mov    %rdx,%rax
  8009fa:	48 83 c2 08          	add    $0x8,%rdx
  8009fe:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a02:	8b 10                	mov    (%rax),%edx
  800a04:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a08:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a0c:	48 89 ce             	mov    %rcx,%rsi
  800a0f:	89 d7                	mov    %edx,%edi
  800a11:	ff d0                	callq  *%rax
			break;
  800a13:	e9 40 03 00 00       	jmpq   800d58 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800a18:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a1b:	83 f8 30             	cmp    $0x30,%eax
  800a1e:	73 17                	jae    800a37 <vprintfmt+0x1e8>
  800a20:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a24:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a27:	89 c0                	mov    %eax,%eax
  800a29:	48 01 d0             	add    %rdx,%rax
  800a2c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a2f:	83 c2 08             	add    $0x8,%edx
  800a32:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a35:	eb 0f                	jmp    800a46 <vprintfmt+0x1f7>
  800a37:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a3b:	48 89 d0             	mov    %rdx,%rax
  800a3e:	48 83 c2 08          	add    $0x8,%rdx
  800a42:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a46:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a48:	85 db                	test   %ebx,%ebx
  800a4a:	79 02                	jns    800a4e <vprintfmt+0x1ff>
				err = -err;
  800a4c:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a4e:	83 fb 15             	cmp    $0x15,%ebx
  800a51:	7f 16                	jg     800a69 <vprintfmt+0x21a>
  800a53:	48 b8 80 49 80 00 00 	movabs $0x804980,%rax
  800a5a:	00 00 00 
  800a5d:	48 63 d3             	movslq %ebx,%rdx
  800a60:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a64:	4d 85 e4             	test   %r12,%r12
  800a67:	75 2e                	jne    800a97 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a69:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a6d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a71:	89 d9                	mov    %ebx,%ecx
  800a73:	48 ba 41 4a 80 00 00 	movabs $0x804a41,%rdx
  800a7a:	00 00 00 
  800a7d:	48 89 c7             	mov    %rax,%rdi
  800a80:	b8 00 00 00 00       	mov    $0x0,%eax
  800a85:	49 b8 67 0d 80 00 00 	movabs $0x800d67,%r8
  800a8c:	00 00 00 
  800a8f:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a92:	e9 c1 02 00 00       	jmpq   800d58 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a97:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a9b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a9f:	4c 89 e1             	mov    %r12,%rcx
  800aa2:	48 ba 4a 4a 80 00 00 	movabs $0x804a4a,%rdx
  800aa9:	00 00 00 
  800aac:	48 89 c7             	mov    %rax,%rdi
  800aaf:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab4:	49 b8 67 0d 80 00 00 	movabs $0x800d67,%r8
  800abb:	00 00 00 
  800abe:	41 ff d0             	callq  *%r8
			break;
  800ac1:	e9 92 02 00 00       	jmpq   800d58 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800ac6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ac9:	83 f8 30             	cmp    $0x30,%eax
  800acc:	73 17                	jae    800ae5 <vprintfmt+0x296>
  800ace:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ad2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ad5:	89 c0                	mov    %eax,%eax
  800ad7:	48 01 d0             	add    %rdx,%rax
  800ada:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800add:	83 c2 08             	add    $0x8,%edx
  800ae0:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ae3:	eb 0f                	jmp    800af4 <vprintfmt+0x2a5>
  800ae5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ae9:	48 89 d0             	mov    %rdx,%rax
  800aec:	48 83 c2 08          	add    $0x8,%rdx
  800af0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800af4:	4c 8b 20             	mov    (%rax),%r12
  800af7:	4d 85 e4             	test   %r12,%r12
  800afa:	75 0a                	jne    800b06 <vprintfmt+0x2b7>
				p = "(null)";
  800afc:	49 bc 4d 4a 80 00 00 	movabs $0x804a4d,%r12
  800b03:	00 00 00 
			if (width > 0 && padc != '-')
  800b06:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b0a:	7e 3f                	jle    800b4b <vprintfmt+0x2fc>
  800b0c:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b10:	74 39                	je     800b4b <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b12:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b15:	48 98                	cltq   
  800b17:	48 89 c6             	mov    %rax,%rsi
  800b1a:	4c 89 e7             	mov    %r12,%rdi
  800b1d:	48 b8 13 10 80 00 00 	movabs $0x801013,%rax
  800b24:	00 00 00 
  800b27:	ff d0                	callq  *%rax
  800b29:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b2c:	eb 17                	jmp    800b45 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800b2e:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b32:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b36:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b3a:	48 89 ce             	mov    %rcx,%rsi
  800b3d:	89 d7                	mov    %edx,%edi
  800b3f:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b41:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b45:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b49:	7f e3                	jg     800b2e <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b4b:	eb 37                	jmp    800b84 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800b4d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b51:	74 1e                	je     800b71 <vprintfmt+0x322>
  800b53:	83 fb 1f             	cmp    $0x1f,%ebx
  800b56:	7e 05                	jle    800b5d <vprintfmt+0x30e>
  800b58:	83 fb 7e             	cmp    $0x7e,%ebx
  800b5b:	7e 14                	jle    800b71 <vprintfmt+0x322>
					putch('?', putdat);
  800b5d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b61:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b65:	48 89 d6             	mov    %rdx,%rsi
  800b68:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b6d:	ff d0                	callq  *%rax
  800b6f:	eb 0f                	jmp    800b80 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800b71:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b75:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b79:	48 89 d6             	mov    %rdx,%rsi
  800b7c:	89 df                	mov    %ebx,%edi
  800b7e:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b80:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b84:	4c 89 e0             	mov    %r12,%rax
  800b87:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b8b:	0f b6 00             	movzbl (%rax),%eax
  800b8e:	0f be d8             	movsbl %al,%ebx
  800b91:	85 db                	test   %ebx,%ebx
  800b93:	74 10                	je     800ba5 <vprintfmt+0x356>
  800b95:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b99:	78 b2                	js     800b4d <vprintfmt+0x2fe>
  800b9b:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800b9f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ba3:	79 a8                	jns    800b4d <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ba5:	eb 16                	jmp    800bbd <vprintfmt+0x36e>
				putch(' ', putdat);
  800ba7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bab:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800baf:	48 89 d6             	mov    %rdx,%rsi
  800bb2:	bf 20 00 00 00       	mov    $0x20,%edi
  800bb7:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bb9:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bbd:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bc1:	7f e4                	jg     800ba7 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800bc3:	e9 90 01 00 00       	jmpq   800d58 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800bc8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bcc:	be 03 00 00 00       	mov    $0x3,%esi
  800bd1:	48 89 c7             	mov    %rax,%rdi
  800bd4:	48 b8 3f 07 80 00 00 	movabs $0x80073f,%rax
  800bdb:	00 00 00 
  800bde:	ff d0                	callq  *%rax
  800be0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800be4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800be8:	48 85 c0             	test   %rax,%rax
  800beb:	79 1d                	jns    800c0a <vprintfmt+0x3bb>
				putch('-', putdat);
  800bed:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bf1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bf5:	48 89 d6             	mov    %rdx,%rsi
  800bf8:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800bfd:	ff d0                	callq  *%rax
				num = -(long long) num;
  800bff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c03:	48 f7 d8             	neg    %rax
  800c06:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c0a:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c11:	e9 d5 00 00 00       	jmpq   800ceb <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c16:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c1a:	be 03 00 00 00       	mov    $0x3,%esi
  800c1f:	48 89 c7             	mov    %rax,%rdi
  800c22:	48 b8 2f 06 80 00 00 	movabs $0x80062f,%rax
  800c29:	00 00 00 
  800c2c:	ff d0                	callq  *%rax
  800c2e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c32:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c39:	e9 ad 00 00 00       	jmpq   800ceb <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800c3e:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800c41:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c45:	89 d6                	mov    %edx,%esi
  800c47:	48 89 c7             	mov    %rax,%rdi
  800c4a:	48 b8 3f 07 80 00 00 	movabs $0x80073f,%rax
  800c51:	00 00 00 
  800c54:	ff d0                	callq  *%rax
  800c56:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800c5a:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800c61:	e9 85 00 00 00       	jmpq   800ceb <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800c66:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c6a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c6e:	48 89 d6             	mov    %rdx,%rsi
  800c71:	bf 30 00 00 00       	mov    $0x30,%edi
  800c76:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c78:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c7c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c80:	48 89 d6             	mov    %rdx,%rsi
  800c83:	bf 78 00 00 00       	mov    $0x78,%edi
  800c88:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800c8a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c8d:	83 f8 30             	cmp    $0x30,%eax
  800c90:	73 17                	jae    800ca9 <vprintfmt+0x45a>
  800c92:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c96:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c99:	89 c0                	mov    %eax,%eax
  800c9b:	48 01 d0             	add    %rdx,%rax
  800c9e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ca1:	83 c2 08             	add    $0x8,%edx
  800ca4:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ca7:	eb 0f                	jmp    800cb8 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800ca9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cad:	48 89 d0             	mov    %rdx,%rax
  800cb0:	48 83 c2 08          	add    $0x8,%rdx
  800cb4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cb8:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cbb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800cbf:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800cc6:	eb 23                	jmp    800ceb <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800cc8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ccc:	be 03 00 00 00       	mov    $0x3,%esi
  800cd1:	48 89 c7             	mov    %rax,%rdi
  800cd4:	48 b8 2f 06 80 00 00 	movabs $0x80062f,%rax
  800cdb:	00 00 00 
  800cde:	ff d0                	callq  *%rax
  800ce0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800ce4:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ceb:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800cf0:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800cf3:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800cf6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cfa:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800cfe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d02:	45 89 c1             	mov    %r8d,%r9d
  800d05:	41 89 f8             	mov    %edi,%r8d
  800d08:	48 89 c7             	mov    %rax,%rdi
  800d0b:	48 b8 74 05 80 00 00 	movabs $0x800574,%rax
  800d12:	00 00 00 
  800d15:	ff d0                	callq  *%rax
			break;
  800d17:	eb 3f                	jmp    800d58 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d19:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d1d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d21:	48 89 d6             	mov    %rdx,%rsi
  800d24:	89 df                	mov    %ebx,%edi
  800d26:	ff d0                	callq  *%rax
			break;
  800d28:	eb 2e                	jmp    800d58 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d2a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d2e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d32:	48 89 d6             	mov    %rdx,%rsi
  800d35:	bf 25 00 00 00       	mov    $0x25,%edi
  800d3a:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d3c:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d41:	eb 05                	jmp    800d48 <vprintfmt+0x4f9>
  800d43:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d48:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d4c:	48 83 e8 01          	sub    $0x1,%rax
  800d50:	0f b6 00             	movzbl (%rax),%eax
  800d53:	3c 25                	cmp    $0x25,%al
  800d55:	75 ec                	jne    800d43 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800d57:	90                   	nop
		}
	}
  800d58:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d59:	e9 43 fb ff ff       	jmpq   8008a1 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800d5e:	48 83 c4 60          	add    $0x60,%rsp
  800d62:	5b                   	pop    %rbx
  800d63:	41 5c                	pop    %r12
  800d65:	5d                   	pop    %rbp
  800d66:	c3                   	retq   

0000000000800d67 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d67:	55                   	push   %rbp
  800d68:	48 89 e5             	mov    %rsp,%rbp
  800d6b:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d72:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d79:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d80:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d87:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d8e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d95:	84 c0                	test   %al,%al
  800d97:	74 20                	je     800db9 <printfmt+0x52>
  800d99:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d9d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800da1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800da5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800da9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800dad:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800db1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800db5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800db9:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800dc0:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800dc7:	00 00 00 
  800dca:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800dd1:	00 00 00 
  800dd4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800dd8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800ddf:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800de6:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800ded:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800df4:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800dfb:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e02:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e09:	48 89 c7             	mov    %rax,%rdi
  800e0c:	48 b8 4f 08 80 00 00 	movabs $0x80084f,%rax
  800e13:	00 00 00 
  800e16:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e18:	c9                   	leaveq 
  800e19:	c3                   	retq   

0000000000800e1a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e1a:	55                   	push   %rbp
  800e1b:	48 89 e5             	mov    %rsp,%rbp
  800e1e:	48 83 ec 10          	sub    $0x10,%rsp
  800e22:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e25:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e29:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e2d:	8b 40 10             	mov    0x10(%rax),%eax
  800e30:	8d 50 01             	lea    0x1(%rax),%edx
  800e33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e37:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e3e:	48 8b 10             	mov    (%rax),%rdx
  800e41:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e45:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e49:	48 39 c2             	cmp    %rax,%rdx
  800e4c:	73 17                	jae    800e65 <sprintputch+0x4b>
		*b->buf++ = ch;
  800e4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e52:	48 8b 00             	mov    (%rax),%rax
  800e55:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e59:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e5d:	48 89 0a             	mov    %rcx,(%rdx)
  800e60:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e63:	88 10                	mov    %dl,(%rax)
}
  800e65:	c9                   	leaveq 
  800e66:	c3                   	retq   

0000000000800e67 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e67:	55                   	push   %rbp
  800e68:	48 89 e5             	mov    %rsp,%rbp
  800e6b:	48 83 ec 50          	sub    $0x50,%rsp
  800e6f:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e73:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e76:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e7a:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e7e:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800e82:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800e86:	48 8b 0a             	mov    (%rdx),%rcx
  800e89:	48 89 08             	mov    %rcx,(%rax)
  800e8c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e90:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e94:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e98:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e9c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ea0:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800ea4:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800ea7:	48 98                	cltq   
  800ea9:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800ead:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800eb1:	48 01 d0             	add    %rdx,%rax
  800eb4:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800eb8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800ebf:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800ec4:	74 06                	je     800ecc <vsnprintf+0x65>
  800ec6:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800eca:	7f 07                	jg     800ed3 <vsnprintf+0x6c>
		return -E_INVAL;
  800ecc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ed1:	eb 2f                	jmp    800f02 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ed3:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800ed7:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800edb:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800edf:	48 89 c6             	mov    %rax,%rsi
  800ee2:	48 bf 1a 0e 80 00 00 	movabs $0x800e1a,%rdi
  800ee9:	00 00 00 
  800eec:	48 b8 4f 08 80 00 00 	movabs $0x80084f,%rax
  800ef3:	00 00 00 
  800ef6:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800ef8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800efc:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800eff:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f02:	c9                   	leaveq 
  800f03:	c3                   	retq   

0000000000800f04 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f04:	55                   	push   %rbp
  800f05:	48 89 e5             	mov    %rsp,%rbp
  800f08:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f0f:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f16:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f1c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f23:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f2a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f31:	84 c0                	test   %al,%al
  800f33:	74 20                	je     800f55 <snprintf+0x51>
  800f35:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f39:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f3d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f41:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f45:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f49:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f4d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f51:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f55:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f5c:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f63:	00 00 00 
  800f66:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f6d:	00 00 00 
  800f70:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f74:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f7b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f82:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800f89:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800f90:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800f97:	48 8b 0a             	mov    (%rdx),%rcx
  800f9a:	48 89 08             	mov    %rcx,(%rax)
  800f9d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fa1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fa5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fa9:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800fad:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800fb4:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800fbb:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800fc1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800fc8:	48 89 c7             	mov    %rax,%rdi
  800fcb:	48 b8 67 0e 80 00 00 	movabs $0x800e67,%rax
  800fd2:	00 00 00 
  800fd5:	ff d0                	callq  *%rax
  800fd7:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800fdd:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800fe3:	c9                   	leaveq 
  800fe4:	c3                   	retq   

0000000000800fe5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800fe5:	55                   	push   %rbp
  800fe6:	48 89 e5             	mov    %rsp,%rbp
  800fe9:	48 83 ec 18          	sub    $0x18,%rsp
  800fed:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800ff1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800ff8:	eb 09                	jmp    801003 <strlen+0x1e>
		n++;
  800ffa:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ffe:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801003:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801007:	0f b6 00             	movzbl (%rax),%eax
  80100a:	84 c0                	test   %al,%al
  80100c:	75 ec                	jne    800ffa <strlen+0x15>
		n++;
	return n;
  80100e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801011:	c9                   	leaveq 
  801012:	c3                   	retq   

0000000000801013 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801013:	55                   	push   %rbp
  801014:	48 89 e5             	mov    %rsp,%rbp
  801017:	48 83 ec 20          	sub    $0x20,%rsp
  80101b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80101f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801023:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80102a:	eb 0e                	jmp    80103a <strnlen+0x27>
		n++;
  80102c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801030:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801035:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80103a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80103f:	74 0b                	je     80104c <strnlen+0x39>
  801041:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801045:	0f b6 00             	movzbl (%rax),%eax
  801048:	84 c0                	test   %al,%al
  80104a:	75 e0                	jne    80102c <strnlen+0x19>
		n++;
	return n;
  80104c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80104f:	c9                   	leaveq 
  801050:	c3                   	retq   

0000000000801051 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801051:	55                   	push   %rbp
  801052:	48 89 e5             	mov    %rsp,%rbp
  801055:	48 83 ec 20          	sub    $0x20,%rsp
  801059:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80105d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801061:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801065:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801069:	90                   	nop
  80106a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80106e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801072:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801076:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80107a:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80107e:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801082:	0f b6 12             	movzbl (%rdx),%edx
  801085:	88 10                	mov    %dl,(%rax)
  801087:	0f b6 00             	movzbl (%rax),%eax
  80108a:	84 c0                	test   %al,%al
  80108c:	75 dc                	jne    80106a <strcpy+0x19>
		/* do nothing */;
	return ret;
  80108e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801092:	c9                   	leaveq 
  801093:	c3                   	retq   

0000000000801094 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801094:	55                   	push   %rbp
  801095:	48 89 e5             	mov    %rsp,%rbp
  801098:	48 83 ec 20          	sub    $0x20,%rsp
  80109c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010a0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8010a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a8:	48 89 c7             	mov    %rax,%rdi
  8010ab:	48 b8 e5 0f 80 00 00 	movabs $0x800fe5,%rax
  8010b2:	00 00 00 
  8010b5:	ff d0                	callq  *%rax
  8010b7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8010ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010bd:	48 63 d0             	movslq %eax,%rdx
  8010c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010c4:	48 01 c2             	add    %rax,%rdx
  8010c7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010cb:	48 89 c6             	mov    %rax,%rsi
  8010ce:	48 89 d7             	mov    %rdx,%rdi
  8010d1:	48 b8 51 10 80 00 00 	movabs $0x801051,%rax
  8010d8:	00 00 00 
  8010db:	ff d0                	callq  *%rax
	return dst;
  8010dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8010e1:	c9                   	leaveq 
  8010e2:	c3                   	retq   

00000000008010e3 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8010e3:	55                   	push   %rbp
  8010e4:	48 89 e5             	mov    %rsp,%rbp
  8010e7:	48 83 ec 28          	sub    $0x28,%rsp
  8010eb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010ef:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8010f3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8010f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010fb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8010ff:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801106:	00 
  801107:	eb 2a                	jmp    801133 <strncpy+0x50>
		*dst++ = *src;
  801109:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80110d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801111:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801115:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801119:	0f b6 12             	movzbl (%rdx),%edx
  80111c:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80111e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801122:	0f b6 00             	movzbl (%rax),%eax
  801125:	84 c0                	test   %al,%al
  801127:	74 05                	je     80112e <strncpy+0x4b>
			src++;
  801129:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80112e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801133:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801137:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80113b:	72 cc                	jb     801109 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80113d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801141:	c9                   	leaveq 
  801142:	c3                   	retq   

0000000000801143 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801143:	55                   	push   %rbp
  801144:	48 89 e5             	mov    %rsp,%rbp
  801147:	48 83 ec 28          	sub    $0x28,%rsp
  80114b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80114f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801153:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801157:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80115b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80115f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801164:	74 3d                	je     8011a3 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801166:	eb 1d                	jmp    801185 <strlcpy+0x42>
			*dst++ = *src++;
  801168:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80116c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801170:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801174:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801178:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80117c:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801180:	0f b6 12             	movzbl (%rdx),%edx
  801183:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801185:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80118a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80118f:	74 0b                	je     80119c <strlcpy+0x59>
  801191:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801195:	0f b6 00             	movzbl (%rax),%eax
  801198:	84 c0                	test   %al,%al
  80119a:	75 cc                	jne    801168 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80119c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a0:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8011a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ab:	48 29 c2             	sub    %rax,%rdx
  8011ae:	48 89 d0             	mov    %rdx,%rax
}
  8011b1:	c9                   	leaveq 
  8011b2:	c3                   	retq   

00000000008011b3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011b3:	55                   	push   %rbp
  8011b4:	48 89 e5             	mov    %rsp,%rbp
  8011b7:	48 83 ec 10          	sub    $0x10,%rsp
  8011bb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011bf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8011c3:	eb 0a                	jmp    8011cf <strcmp+0x1c>
		p++, q++;
  8011c5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011ca:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d3:	0f b6 00             	movzbl (%rax),%eax
  8011d6:	84 c0                	test   %al,%al
  8011d8:	74 12                	je     8011ec <strcmp+0x39>
  8011da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011de:	0f b6 10             	movzbl (%rax),%edx
  8011e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011e5:	0f b6 00             	movzbl (%rax),%eax
  8011e8:	38 c2                	cmp    %al,%dl
  8011ea:	74 d9                	je     8011c5 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f0:	0f b6 00             	movzbl (%rax),%eax
  8011f3:	0f b6 d0             	movzbl %al,%edx
  8011f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011fa:	0f b6 00             	movzbl (%rax),%eax
  8011fd:	0f b6 c0             	movzbl %al,%eax
  801200:	29 c2                	sub    %eax,%edx
  801202:	89 d0                	mov    %edx,%eax
}
  801204:	c9                   	leaveq 
  801205:	c3                   	retq   

0000000000801206 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801206:	55                   	push   %rbp
  801207:	48 89 e5             	mov    %rsp,%rbp
  80120a:	48 83 ec 18          	sub    $0x18,%rsp
  80120e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801212:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801216:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80121a:	eb 0f                	jmp    80122b <strncmp+0x25>
		n--, p++, q++;
  80121c:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801221:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801226:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80122b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801230:	74 1d                	je     80124f <strncmp+0x49>
  801232:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801236:	0f b6 00             	movzbl (%rax),%eax
  801239:	84 c0                	test   %al,%al
  80123b:	74 12                	je     80124f <strncmp+0x49>
  80123d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801241:	0f b6 10             	movzbl (%rax),%edx
  801244:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801248:	0f b6 00             	movzbl (%rax),%eax
  80124b:	38 c2                	cmp    %al,%dl
  80124d:	74 cd                	je     80121c <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80124f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801254:	75 07                	jne    80125d <strncmp+0x57>
		return 0;
  801256:	b8 00 00 00 00       	mov    $0x0,%eax
  80125b:	eb 18                	jmp    801275 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80125d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801261:	0f b6 00             	movzbl (%rax),%eax
  801264:	0f b6 d0             	movzbl %al,%edx
  801267:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80126b:	0f b6 00             	movzbl (%rax),%eax
  80126e:	0f b6 c0             	movzbl %al,%eax
  801271:	29 c2                	sub    %eax,%edx
  801273:	89 d0                	mov    %edx,%eax
}
  801275:	c9                   	leaveq 
  801276:	c3                   	retq   

0000000000801277 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801277:	55                   	push   %rbp
  801278:	48 89 e5             	mov    %rsp,%rbp
  80127b:	48 83 ec 0c          	sub    $0xc,%rsp
  80127f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801283:	89 f0                	mov    %esi,%eax
  801285:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801288:	eb 17                	jmp    8012a1 <strchr+0x2a>
		if (*s == c)
  80128a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80128e:	0f b6 00             	movzbl (%rax),%eax
  801291:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801294:	75 06                	jne    80129c <strchr+0x25>
			return (char *) s;
  801296:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80129a:	eb 15                	jmp    8012b1 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80129c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a5:	0f b6 00             	movzbl (%rax),%eax
  8012a8:	84 c0                	test   %al,%al
  8012aa:	75 de                	jne    80128a <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8012ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012b1:	c9                   	leaveq 
  8012b2:	c3                   	retq   

00000000008012b3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012b3:	55                   	push   %rbp
  8012b4:	48 89 e5             	mov    %rsp,%rbp
  8012b7:	48 83 ec 0c          	sub    $0xc,%rsp
  8012bb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012bf:	89 f0                	mov    %esi,%eax
  8012c1:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012c4:	eb 13                	jmp    8012d9 <strfind+0x26>
		if (*s == c)
  8012c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ca:	0f b6 00             	movzbl (%rax),%eax
  8012cd:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012d0:	75 02                	jne    8012d4 <strfind+0x21>
			break;
  8012d2:	eb 10                	jmp    8012e4 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012d4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012dd:	0f b6 00             	movzbl (%rax),%eax
  8012e0:	84 c0                	test   %al,%al
  8012e2:	75 e2                	jne    8012c6 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8012e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012e8:	c9                   	leaveq 
  8012e9:	c3                   	retq   

00000000008012ea <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8012ea:	55                   	push   %rbp
  8012eb:	48 89 e5             	mov    %rsp,%rbp
  8012ee:	48 83 ec 18          	sub    $0x18,%rsp
  8012f2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012f6:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8012f9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8012fd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801302:	75 06                	jne    80130a <memset+0x20>
		return v;
  801304:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801308:	eb 69                	jmp    801373 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80130a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80130e:	83 e0 03             	and    $0x3,%eax
  801311:	48 85 c0             	test   %rax,%rax
  801314:	75 48                	jne    80135e <memset+0x74>
  801316:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80131a:	83 e0 03             	and    $0x3,%eax
  80131d:	48 85 c0             	test   %rax,%rax
  801320:	75 3c                	jne    80135e <memset+0x74>
		c &= 0xFF;
  801322:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801329:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80132c:	c1 e0 18             	shl    $0x18,%eax
  80132f:	89 c2                	mov    %eax,%edx
  801331:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801334:	c1 e0 10             	shl    $0x10,%eax
  801337:	09 c2                	or     %eax,%edx
  801339:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80133c:	c1 e0 08             	shl    $0x8,%eax
  80133f:	09 d0                	or     %edx,%eax
  801341:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801344:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801348:	48 c1 e8 02          	shr    $0x2,%rax
  80134c:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80134f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801353:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801356:	48 89 d7             	mov    %rdx,%rdi
  801359:	fc                   	cld    
  80135a:	f3 ab                	rep stos %eax,%es:(%rdi)
  80135c:	eb 11                	jmp    80136f <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80135e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801362:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801365:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801369:	48 89 d7             	mov    %rdx,%rdi
  80136c:	fc                   	cld    
  80136d:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80136f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801373:	c9                   	leaveq 
  801374:	c3                   	retq   

0000000000801375 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801375:	55                   	push   %rbp
  801376:	48 89 e5             	mov    %rsp,%rbp
  801379:	48 83 ec 28          	sub    $0x28,%rsp
  80137d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801381:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801385:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801389:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80138d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801391:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801395:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801399:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80139d:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013a1:	0f 83 88 00 00 00    	jae    80142f <memmove+0xba>
  8013a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ab:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013af:	48 01 d0             	add    %rdx,%rax
  8013b2:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013b6:	76 77                	jbe    80142f <memmove+0xba>
		s += n;
  8013b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013bc:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8013c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013c4:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013cc:	83 e0 03             	and    $0x3,%eax
  8013cf:	48 85 c0             	test   %rax,%rax
  8013d2:	75 3b                	jne    80140f <memmove+0x9a>
  8013d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013d8:	83 e0 03             	and    $0x3,%eax
  8013db:	48 85 c0             	test   %rax,%rax
  8013de:	75 2f                	jne    80140f <memmove+0x9a>
  8013e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013e4:	83 e0 03             	and    $0x3,%eax
  8013e7:	48 85 c0             	test   %rax,%rax
  8013ea:	75 23                	jne    80140f <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8013ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013f0:	48 83 e8 04          	sub    $0x4,%rax
  8013f4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013f8:	48 83 ea 04          	sub    $0x4,%rdx
  8013fc:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801400:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801404:	48 89 c7             	mov    %rax,%rdi
  801407:	48 89 d6             	mov    %rdx,%rsi
  80140a:	fd                   	std    
  80140b:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80140d:	eb 1d                	jmp    80142c <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80140f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801413:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801417:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80141b:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80141f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801423:	48 89 d7             	mov    %rdx,%rdi
  801426:	48 89 c1             	mov    %rax,%rcx
  801429:	fd                   	std    
  80142a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80142c:	fc                   	cld    
  80142d:	eb 57                	jmp    801486 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80142f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801433:	83 e0 03             	and    $0x3,%eax
  801436:	48 85 c0             	test   %rax,%rax
  801439:	75 36                	jne    801471 <memmove+0xfc>
  80143b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80143f:	83 e0 03             	and    $0x3,%eax
  801442:	48 85 c0             	test   %rax,%rax
  801445:	75 2a                	jne    801471 <memmove+0xfc>
  801447:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144b:	83 e0 03             	and    $0x3,%eax
  80144e:	48 85 c0             	test   %rax,%rax
  801451:	75 1e                	jne    801471 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801453:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801457:	48 c1 e8 02          	shr    $0x2,%rax
  80145b:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80145e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801462:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801466:	48 89 c7             	mov    %rax,%rdi
  801469:	48 89 d6             	mov    %rdx,%rsi
  80146c:	fc                   	cld    
  80146d:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80146f:	eb 15                	jmp    801486 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801471:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801475:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801479:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80147d:	48 89 c7             	mov    %rax,%rdi
  801480:	48 89 d6             	mov    %rdx,%rsi
  801483:	fc                   	cld    
  801484:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801486:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80148a:	c9                   	leaveq 
  80148b:	c3                   	retq   

000000000080148c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80148c:	55                   	push   %rbp
  80148d:	48 89 e5             	mov    %rsp,%rbp
  801490:	48 83 ec 18          	sub    $0x18,%rsp
  801494:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801498:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80149c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8014a0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014a4:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8014a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ac:	48 89 ce             	mov    %rcx,%rsi
  8014af:	48 89 c7             	mov    %rax,%rdi
  8014b2:	48 b8 75 13 80 00 00 	movabs $0x801375,%rax
  8014b9:	00 00 00 
  8014bc:	ff d0                	callq  *%rax
}
  8014be:	c9                   	leaveq 
  8014bf:	c3                   	retq   

00000000008014c0 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014c0:	55                   	push   %rbp
  8014c1:	48 89 e5             	mov    %rsp,%rbp
  8014c4:	48 83 ec 28          	sub    $0x28,%rsp
  8014c8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014cc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014d0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8014d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014d8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8014dc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014e0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8014e4:	eb 36                	jmp    80151c <memcmp+0x5c>
		if (*s1 != *s2)
  8014e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ea:	0f b6 10             	movzbl (%rax),%edx
  8014ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014f1:	0f b6 00             	movzbl (%rax),%eax
  8014f4:	38 c2                	cmp    %al,%dl
  8014f6:	74 1a                	je     801512 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8014f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014fc:	0f b6 00             	movzbl (%rax),%eax
  8014ff:	0f b6 d0             	movzbl %al,%edx
  801502:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801506:	0f b6 00             	movzbl (%rax),%eax
  801509:	0f b6 c0             	movzbl %al,%eax
  80150c:	29 c2                	sub    %eax,%edx
  80150e:	89 d0                	mov    %edx,%eax
  801510:	eb 20                	jmp    801532 <memcmp+0x72>
		s1++, s2++;
  801512:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801517:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80151c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801520:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801524:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801528:	48 85 c0             	test   %rax,%rax
  80152b:	75 b9                	jne    8014e6 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80152d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801532:	c9                   	leaveq 
  801533:	c3                   	retq   

0000000000801534 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801534:	55                   	push   %rbp
  801535:	48 89 e5             	mov    %rsp,%rbp
  801538:	48 83 ec 28          	sub    $0x28,%rsp
  80153c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801540:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801543:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801547:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80154f:	48 01 d0             	add    %rdx,%rax
  801552:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801556:	eb 15                	jmp    80156d <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801558:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80155c:	0f b6 10             	movzbl (%rax),%edx
  80155f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801562:	38 c2                	cmp    %al,%dl
  801564:	75 02                	jne    801568 <memfind+0x34>
			break;
  801566:	eb 0f                	jmp    801577 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801568:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80156d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801571:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801575:	72 e1                	jb     801558 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801577:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80157b:	c9                   	leaveq 
  80157c:	c3                   	retq   

000000000080157d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80157d:	55                   	push   %rbp
  80157e:	48 89 e5             	mov    %rsp,%rbp
  801581:	48 83 ec 34          	sub    $0x34,%rsp
  801585:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801589:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80158d:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801590:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801597:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80159e:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80159f:	eb 05                	jmp    8015a6 <strtol+0x29>
		s++;
  8015a1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015aa:	0f b6 00             	movzbl (%rax),%eax
  8015ad:	3c 20                	cmp    $0x20,%al
  8015af:	74 f0                	je     8015a1 <strtol+0x24>
  8015b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b5:	0f b6 00             	movzbl (%rax),%eax
  8015b8:	3c 09                	cmp    $0x9,%al
  8015ba:	74 e5                	je     8015a1 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c0:	0f b6 00             	movzbl (%rax),%eax
  8015c3:	3c 2b                	cmp    $0x2b,%al
  8015c5:	75 07                	jne    8015ce <strtol+0x51>
		s++;
  8015c7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015cc:	eb 17                	jmp    8015e5 <strtol+0x68>
	else if (*s == '-')
  8015ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d2:	0f b6 00             	movzbl (%rax),%eax
  8015d5:	3c 2d                	cmp    $0x2d,%al
  8015d7:	75 0c                	jne    8015e5 <strtol+0x68>
		s++, neg = 1;
  8015d9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015de:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015e5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015e9:	74 06                	je     8015f1 <strtol+0x74>
  8015eb:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8015ef:	75 28                	jne    801619 <strtol+0x9c>
  8015f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f5:	0f b6 00             	movzbl (%rax),%eax
  8015f8:	3c 30                	cmp    $0x30,%al
  8015fa:	75 1d                	jne    801619 <strtol+0x9c>
  8015fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801600:	48 83 c0 01          	add    $0x1,%rax
  801604:	0f b6 00             	movzbl (%rax),%eax
  801607:	3c 78                	cmp    $0x78,%al
  801609:	75 0e                	jne    801619 <strtol+0x9c>
		s += 2, base = 16;
  80160b:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801610:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801617:	eb 2c                	jmp    801645 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801619:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80161d:	75 19                	jne    801638 <strtol+0xbb>
  80161f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801623:	0f b6 00             	movzbl (%rax),%eax
  801626:	3c 30                	cmp    $0x30,%al
  801628:	75 0e                	jne    801638 <strtol+0xbb>
		s++, base = 8;
  80162a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80162f:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801636:	eb 0d                	jmp    801645 <strtol+0xc8>
	else if (base == 0)
  801638:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80163c:	75 07                	jne    801645 <strtol+0xc8>
		base = 10;
  80163e:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801645:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801649:	0f b6 00             	movzbl (%rax),%eax
  80164c:	3c 2f                	cmp    $0x2f,%al
  80164e:	7e 1d                	jle    80166d <strtol+0xf0>
  801650:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801654:	0f b6 00             	movzbl (%rax),%eax
  801657:	3c 39                	cmp    $0x39,%al
  801659:	7f 12                	jg     80166d <strtol+0xf0>
			dig = *s - '0';
  80165b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80165f:	0f b6 00             	movzbl (%rax),%eax
  801662:	0f be c0             	movsbl %al,%eax
  801665:	83 e8 30             	sub    $0x30,%eax
  801668:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80166b:	eb 4e                	jmp    8016bb <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80166d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801671:	0f b6 00             	movzbl (%rax),%eax
  801674:	3c 60                	cmp    $0x60,%al
  801676:	7e 1d                	jle    801695 <strtol+0x118>
  801678:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167c:	0f b6 00             	movzbl (%rax),%eax
  80167f:	3c 7a                	cmp    $0x7a,%al
  801681:	7f 12                	jg     801695 <strtol+0x118>
			dig = *s - 'a' + 10;
  801683:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801687:	0f b6 00             	movzbl (%rax),%eax
  80168a:	0f be c0             	movsbl %al,%eax
  80168d:	83 e8 57             	sub    $0x57,%eax
  801690:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801693:	eb 26                	jmp    8016bb <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801695:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801699:	0f b6 00             	movzbl (%rax),%eax
  80169c:	3c 40                	cmp    $0x40,%al
  80169e:	7e 48                	jle    8016e8 <strtol+0x16b>
  8016a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a4:	0f b6 00             	movzbl (%rax),%eax
  8016a7:	3c 5a                	cmp    $0x5a,%al
  8016a9:	7f 3d                	jg     8016e8 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8016ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016af:	0f b6 00             	movzbl (%rax),%eax
  8016b2:	0f be c0             	movsbl %al,%eax
  8016b5:	83 e8 37             	sub    $0x37,%eax
  8016b8:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8016bb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016be:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8016c1:	7c 02                	jl     8016c5 <strtol+0x148>
			break;
  8016c3:	eb 23                	jmp    8016e8 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8016c5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016ca:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8016cd:	48 98                	cltq   
  8016cf:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8016d4:	48 89 c2             	mov    %rax,%rdx
  8016d7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016da:	48 98                	cltq   
  8016dc:	48 01 d0             	add    %rdx,%rax
  8016df:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8016e3:	e9 5d ff ff ff       	jmpq   801645 <strtol+0xc8>

	if (endptr)
  8016e8:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8016ed:	74 0b                	je     8016fa <strtol+0x17d>
		*endptr = (char *) s;
  8016ef:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016f3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8016f7:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8016fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016fe:	74 09                	je     801709 <strtol+0x18c>
  801700:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801704:	48 f7 d8             	neg    %rax
  801707:	eb 04                	jmp    80170d <strtol+0x190>
  801709:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80170d:	c9                   	leaveq 
  80170e:	c3                   	retq   

000000000080170f <strstr>:

char * strstr(const char *in, const char *str)
{
  80170f:	55                   	push   %rbp
  801710:	48 89 e5             	mov    %rsp,%rbp
  801713:	48 83 ec 30          	sub    $0x30,%rsp
  801717:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80171b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80171f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801723:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801727:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80172b:	0f b6 00             	movzbl (%rax),%eax
  80172e:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801731:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801735:	75 06                	jne    80173d <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801737:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80173b:	eb 6b                	jmp    8017a8 <strstr+0x99>

	len = strlen(str);
  80173d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801741:	48 89 c7             	mov    %rax,%rdi
  801744:	48 b8 e5 0f 80 00 00 	movabs $0x800fe5,%rax
  80174b:	00 00 00 
  80174e:	ff d0                	callq  *%rax
  801750:	48 98                	cltq   
  801752:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801756:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80175a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80175e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801762:	0f b6 00             	movzbl (%rax),%eax
  801765:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801768:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80176c:	75 07                	jne    801775 <strstr+0x66>
				return (char *) 0;
  80176e:	b8 00 00 00 00       	mov    $0x0,%eax
  801773:	eb 33                	jmp    8017a8 <strstr+0x99>
		} while (sc != c);
  801775:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801779:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80177c:	75 d8                	jne    801756 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80177e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801782:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801786:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80178a:	48 89 ce             	mov    %rcx,%rsi
  80178d:	48 89 c7             	mov    %rax,%rdi
  801790:	48 b8 06 12 80 00 00 	movabs $0x801206,%rax
  801797:	00 00 00 
  80179a:	ff d0                	callq  *%rax
  80179c:	85 c0                	test   %eax,%eax
  80179e:	75 b6                	jne    801756 <strstr+0x47>

	return (char *) (in - 1);
  8017a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a4:	48 83 e8 01          	sub    $0x1,%rax
}
  8017a8:	c9                   	leaveq 
  8017a9:	c3                   	retq   

00000000008017aa <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8017aa:	55                   	push   %rbp
  8017ab:	48 89 e5             	mov    %rsp,%rbp
  8017ae:	53                   	push   %rbx
  8017af:	48 83 ec 48          	sub    $0x48,%rsp
  8017b3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8017b6:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8017b9:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017bd:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8017c1:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8017c5:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017c9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017cc:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8017d0:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8017d4:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8017d8:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8017dc:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8017e0:	4c 89 c3             	mov    %r8,%rbx
  8017e3:	cd 30                	int    $0x30
  8017e5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8017e9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8017ed:	74 3e                	je     80182d <syscall+0x83>
  8017ef:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8017f4:	7e 37                	jle    80182d <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017fa:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017fd:	49 89 d0             	mov    %rdx,%r8
  801800:	89 c1                	mov    %eax,%ecx
  801802:	48 ba 08 4d 80 00 00 	movabs $0x804d08,%rdx
  801809:	00 00 00 
  80180c:	be 23 00 00 00       	mov    $0x23,%esi
  801811:	48 bf 25 4d 80 00 00 	movabs $0x804d25,%rdi
  801818:	00 00 00 
  80181b:	b8 00 00 00 00       	mov    $0x0,%eax
  801820:	49 b9 63 02 80 00 00 	movabs $0x800263,%r9
  801827:	00 00 00 
  80182a:	41 ff d1             	callq  *%r9

	return ret;
  80182d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801831:	48 83 c4 48          	add    $0x48,%rsp
  801835:	5b                   	pop    %rbx
  801836:	5d                   	pop    %rbp
  801837:	c3                   	retq   

0000000000801838 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801838:	55                   	push   %rbp
  801839:	48 89 e5             	mov    %rsp,%rbp
  80183c:	48 83 ec 20          	sub    $0x20,%rsp
  801840:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801844:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801848:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80184c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801850:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801857:	00 
  801858:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80185e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801864:	48 89 d1             	mov    %rdx,%rcx
  801867:	48 89 c2             	mov    %rax,%rdx
  80186a:	be 00 00 00 00       	mov    $0x0,%esi
  80186f:	bf 00 00 00 00       	mov    $0x0,%edi
  801874:	48 b8 aa 17 80 00 00 	movabs $0x8017aa,%rax
  80187b:	00 00 00 
  80187e:	ff d0                	callq  *%rax
}
  801880:	c9                   	leaveq 
  801881:	c3                   	retq   

0000000000801882 <sys_cgetc>:

int
sys_cgetc(void)
{
  801882:	55                   	push   %rbp
  801883:	48 89 e5             	mov    %rsp,%rbp
  801886:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80188a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801891:	00 
  801892:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801898:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80189e:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8018a8:	be 00 00 00 00       	mov    $0x0,%esi
  8018ad:	bf 01 00 00 00       	mov    $0x1,%edi
  8018b2:	48 b8 aa 17 80 00 00 	movabs $0x8017aa,%rax
  8018b9:	00 00 00 
  8018bc:	ff d0                	callq  *%rax
}
  8018be:	c9                   	leaveq 
  8018bf:	c3                   	retq   

00000000008018c0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8018c0:	55                   	push   %rbp
  8018c1:	48 89 e5             	mov    %rsp,%rbp
  8018c4:	48 83 ec 10          	sub    $0x10,%rsp
  8018c8:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8018cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018ce:	48 98                	cltq   
  8018d0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018d7:	00 
  8018d8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018de:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018e4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018e9:	48 89 c2             	mov    %rax,%rdx
  8018ec:	be 01 00 00 00       	mov    $0x1,%esi
  8018f1:	bf 03 00 00 00       	mov    $0x3,%edi
  8018f6:	48 b8 aa 17 80 00 00 	movabs $0x8017aa,%rax
  8018fd:	00 00 00 
  801900:	ff d0                	callq  *%rax
}
  801902:	c9                   	leaveq 
  801903:	c3                   	retq   

0000000000801904 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801904:	55                   	push   %rbp
  801905:	48 89 e5             	mov    %rsp,%rbp
  801908:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80190c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801913:	00 
  801914:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80191a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801920:	b9 00 00 00 00       	mov    $0x0,%ecx
  801925:	ba 00 00 00 00       	mov    $0x0,%edx
  80192a:	be 00 00 00 00       	mov    $0x0,%esi
  80192f:	bf 02 00 00 00       	mov    $0x2,%edi
  801934:	48 b8 aa 17 80 00 00 	movabs $0x8017aa,%rax
  80193b:	00 00 00 
  80193e:	ff d0                	callq  *%rax
}
  801940:	c9                   	leaveq 
  801941:	c3                   	retq   

0000000000801942 <sys_yield>:

void
sys_yield(void)
{
  801942:	55                   	push   %rbp
  801943:	48 89 e5             	mov    %rsp,%rbp
  801946:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80194a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801951:	00 
  801952:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801958:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80195e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801963:	ba 00 00 00 00       	mov    $0x0,%edx
  801968:	be 00 00 00 00       	mov    $0x0,%esi
  80196d:	bf 0b 00 00 00       	mov    $0xb,%edi
  801972:	48 b8 aa 17 80 00 00 	movabs $0x8017aa,%rax
  801979:	00 00 00 
  80197c:	ff d0                	callq  *%rax
}
  80197e:	c9                   	leaveq 
  80197f:	c3                   	retq   

0000000000801980 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801980:	55                   	push   %rbp
  801981:	48 89 e5             	mov    %rsp,%rbp
  801984:	48 83 ec 20          	sub    $0x20,%rsp
  801988:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80198b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80198f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801992:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801995:	48 63 c8             	movslq %eax,%rcx
  801998:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80199c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80199f:	48 98                	cltq   
  8019a1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019a8:	00 
  8019a9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019af:	49 89 c8             	mov    %rcx,%r8
  8019b2:	48 89 d1             	mov    %rdx,%rcx
  8019b5:	48 89 c2             	mov    %rax,%rdx
  8019b8:	be 01 00 00 00       	mov    $0x1,%esi
  8019bd:	bf 04 00 00 00       	mov    $0x4,%edi
  8019c2:	48 b8 aa 17 80 00 00 	movabs $0x8017aa,%rax
  8019c9:	00 00 00 
  8019cc:	ff d0                	callq  *%rax
}
  8019ce:	c9                   	leaveq 
  8019cf:	c3                   	retq   

00000000008019d0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8019d0:	55                   	push   %rbp
  8019d1:	48 89 e5             	mov    %rsp,%rbp
  8019d4:	48 83 ec 30          	sub    $0x30,%rsp
  8019d8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019db:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019df:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8019e2:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8019e6:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8019ea:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8019ed:	48 63 c8             	movslq %eax,%rcx
  8019f0:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8019f4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019f7:	48 63 f0             	movslq %eax,%rsi
  8019fa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a01:	48 98                	cltq   
  801a03:	48 89 0c 24          	mov    %rcx,(%rsp)
  801a07:	49 89 f9             	mov    %rdi,%r9
  801a0a:	49 89 f0             	mov    %rsi,%r8
  801a0d:	48 89 d1             	mov    %rdx,%rcx
  801a10:	48 89 c2             	mov    %rax,%rdx
  801a13:	be 01 00 00 00       	mov    $0x1,%esi
  801a18:	bf 05 00 00 00       	mov    $0x5,%edi
  801a1d:	48 b8 aa 17 80 00 00 	movabs $0x8017aa,%rax
  801a24:	00 00 00 
  801a27:	ff d0                	callq  *%rax
}
  801a29:	c9                   	leaveq 
  801a2a:	c3                   	retq   

0000000000801a2b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a2b:	55                   	push   %rbp
  801a2c:	48 89 e5             	mov    %rsp,%rbp
  801a2f:	48 83 ec 20          	sub    $0x20,%rsp
  801a33:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a36:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a3a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a41:	48 98                	cltq   
  801a43:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a4a:	00 
  801a4b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a51:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a57:	48 89 d1             	mov    %rdx,%rcx
  801a5a:	48 89 c2             	mov    %rax,%rdx
  801a5d:	be 01 00 00 00       	mov    $0x1,%esi
  801a62:	bf 06 00 00 00       	mov    $0x6,%edi
  801a67:	48 b8 aa 17 80 00 00 	movabs $0x8017aa,%rax
  801a6e:	00 00 00 
  801a71:	ff d0                	callq  *%rax
}
  801a73:	c9                   	leaveq 
  801a74:	c3                   	retq   

0000000000801a75 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a75:	55                   	push   %rbp
  801a76:	48 89 e5             	mov    %rsp,%rbp
  801a79:	48 83 ec 10          	sub    $0x10,%rsp
  801a7d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a80:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801a83:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a86:	48 63 d0             	movslq %eax,%rdx
  801a89:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a8c:	48 98                	cltq   
  801a8e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a95:	00 
  801a96:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a9c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aa2:	48 89 d1             	mov    %rdx,%rcx
  801aa5:	48 89 c2             	mov    %rax,%rdx
  801aa8:	be 01 00 00 00       	mov    $0x1,%esi
  801aad:	bf 08 00 00 00       	mov    $0x8,%edi
  801ab2:	48 b8 aa 17 80 00 00 	movabs $0x8017aa,%rax
  801ab9:	00 00 00 
  801abc:	ff d0                	callq  *%rax
}
  801abe:	c9                   	leaveq 
  801abf:	c3                   	retq   

0000000000801ac0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801ac0:	55                   	push   %rbp
  801ac1:	48 89 e5             	mov    %rsp,%rbp
  801ac4:	48 83 ec 20          	sub    $0x20,%rsp
  801ac8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801acb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801acf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ad3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ad6:	48 98                	cltq   
  801ad8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801adf:	00 
  801ae0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ae6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aec:	48 89 d1             	mov    %rdx,%rcx
  801aef:	48 89 c2             	mov    %rax,%rdx
  801af2:	be 01 00 00 00       	mov    $0x1,%esi
  801af7:	bf 09 00 00 00       	mov    $0x9,%edi
  801afc:	48 b8 aa 17 80 00 00 	movabs $0x8017aa,%rax
  801b03:	00 00 00 
  801b06:	ff d0                	callq  *%rax
}
  801b08:	c9                   	leaveq 
  801b09:	c3                   	retq   

0000000000801b0a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801b0a:	55                   	push   %rbp
  801b0b:	48 89 e5             	mov    %rsp,%rbp
  801b0e:	48 83 ec 20          	sub    $0x20,%rsp
  801b12:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b15:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801b19:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b20:	48 98                	cltq   
  801b22:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b29:	00 
  801b2a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b30:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b36:	48 89 d1             	mov    %rdx,%rcx
  801b39:	48 89 c2             	mov    %rax,%rdx
  801b3c:	be 01 00 00 00       	mov    $0x1,%esi
  801b41:	bf 0a 00 00 00       	mov    $0xa,%edi
  801b46:	48 b8 aa 17 80 00 00 	movabs $0x8017aa,%rax
  801b4d:	00 00 00 
  801b50:	ff d0                	callq  *%rax
}
  801b52:	c9                   	leaveq 
  801b53:	c3                   	retq   

0000000000801b54 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801b54:	55                   	push   %rbp
  801b55:	48 89 e5             	mov    %rsp,%rbp
  801b58:	48 83 ec 20          	sub    $0x20,%rsp
  801b5c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b5f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b63:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b67:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b6a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b6d:	48 63 f0             	movslq %eax,%rsi
  801b70:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801b74:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b77:	48 98                	cltq   
  801b79:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b7d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b84:	00 
  801b85:	49 89 f1             	mov    %rsi,%r9
  801b88:	49 89 c8             	mov    %rcx,%r8
  801b8b:	48 89 d1             	mov    %rdx,%rcx
  801b8e:	48 89 c2             	mov    %rax,%rdx
  801b91:	be 00 00 00 00       	mov    $0x0,%esi
  801b96:	bf 0c 00 00 00       	mov    $0xc,%edi
  801b9b:	48 b8 aa 17 80 00 00 	movabs $0x8017aa,%rax
  801ba2:	00 00 00 
  801ba5:	ff d0                	callq  *%rax
}
  801ba7:	c9                   	leaveq 
  801ba8:	c3                   	retq   

0000000000801ba9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801ba9:	55                   	push   %rbp
  801baa:	48 89 e5             	mov    %rsp,%rbp
  801bad:	48 83 ec 10          	sub    $0x10,%rsp
  801bb1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801bb5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bb9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bc0:	00 
  801bc1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bc7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bcd:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bd2:	48 89 c2             	mov    %rax,%rdx
  801bd5:	be 01 00 00 00       	mov    $0x1,%esi
  801bda:	bf 0d 00 00 00       	mov    $0xd,%edi
  801bdf:	48 b8 aa 17 80 00 00 	movabs $0x8017aa,%rax
  801be6:	00 00 00 
  801be9:	ff d0                	callq  *%rax
}
  801beb:	c9                   	leaveq 
  801bec:	c3                   	retq   

0000000000801bed <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801bed:	55                   	push   %rbp
  801bee:	48 89 e5             	mov    %rsp,%rbp
  801bf1:	48 83 ec 20          	sub    $0x20,%rsp
  801bf5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801bf9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, (uint64_t)buf, len, 0, 0, 0, 0);
  801bfd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c01:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c05:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c0c:	00 
  801c0d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c13:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c19:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c1e:	89 c6                	mov    %eax,%esi
  801c20:	bf 0f 00 00 00       	mov    $0xf,%edi
  801c25:	48 b8 aa 17 80 00 00 	movabs $0x8017aa,%rax
  801c2c:	00 00 00 
  801c2f:	ff d0                	callq  *%rax
}
  801c31:	c9                   	leaveq 
  801c32:	c3                   	retq   

0000000000801c33 <sys_net_rx>:

int
sys_net_rx(void *buf, size_t len)
{
  801c33:	55                   	push   %rbp
  801c34:	48 89 e5             	mov    %rsp,%rbp
  801c37:	48 83 ec 20          	sub    $0x20,%rsp
  801c3b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c3f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_rx, (uint64_t)buf, len, 0, 0, 0, 0);
  801c43:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c47:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c4b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c52:	00 
  801c53:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c59:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c5f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c64:	89 c6                	mov    %eax,%esi
  801c66:	bf 10 00 00 00       	mov    $0x10,%edi
  801c6b:	48 b8 aa 17 80 00 00 	movabs $0x8017aa,%rax
  801c72:	00 00 00 
  801c75:	ff d0                	callq  *%rax
}
  801c77:	c9                   	leaveq 
  801c78:	c3                   	retq   

0000000000801c79 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801c79:	55                   	push   %rbp
  801c7a:	48 89 e5             	mov    %rsp,%rbp
  801c7d:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801c81:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c88:	00 
  801c89:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c8f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c95:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c9a:	ba 00 00 00 00       	mov    $0x0,%edx
  801c9f:	be 00 00 00 00       	mov    $0x0,%esi
  801ca4:	bf 0e 00 00 00       	mov    $0xe,%edi
  801ca9:	48 b8 aa 17 80 00 00 	movabs $0x8017aa,%rax
  801cb0:	00 00 00 
  801cb3:	ff d0                	callq  *%rax
}
  801cb5:	c9                   	leaveq 
  801cb6:	c3                   	retq   

0000000000801cb7 <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  801cb7:	55                   	push   %rbp
  801cb8:	48 89 e5             	mov    %rsp,%rbp
  801cbb:	48 83 ec 30          	sub    $0x30,%rsp
  801cbf:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801cc3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cc7:	48 8b 00             	mov    (%rax),%rax
  801cca:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801cce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cd2:	48 8b 40 08          	mov    0x8(%rax),%rax
  801cd6:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801cd9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801cdc:	83 e0 02             	and    $0x2,%eax
  801cdf:	85 c0                	test   %eax,%eax
  801ce1:	75 4d                	jne    801d30 <pgfault+0x79>
  801ce3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ce7:	48 c1 e8 0c          	shr    $0xc,%rax
  801ceb:	48 89 c2             	mov    %rax,%rdx
  801cee:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801cf5:	01 00 00 
  801cf8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801cfc:	25 00 08 00 00       	and    $0x800,%eax
  801d01:	48 85 c0             	test   %rax,%rax
  801d04:	74 2a                	je     801d30 <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  801d06:	48 ba 38 4d 80 00 00 	movabs $0x804d38,%rdx
  801d0d:	00 00 00 
  801d10:	be 23 00 00 00       	mov    $0x23,%esi
  801d15:	48 bf 6d 4d 80 00 00 	movabs $0x804d6d,%rdi
  801d1c:	00 00 00 
  801d1f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d24:	48 b9 63 02 80 00 00 	movabs $0x800263,%rcx
  801d2b:	00 00 00 
  801d2e:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  801d30:	ba 07 00 00 00       	mov    $0x7,%edx
  801d35:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801d3a:	bf 00 00 00 00       	mov    $0x0,%edi
  801d3f:	48 b8 80 19 80 00 00 	movabs $0x801980,%rax
  801d46:	00 00 00 
  801d49:	ff d0                	callq  *%rax
  801d4b:	85 c0                	test   %eax,%eax
  801d4d:	0f 85 cd 00 00 00    	jne    801e20 <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801d53:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d57:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801d5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d5f:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801d65:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801d69:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d6d:	ba 00 10 00 00       	mov    $0x1000,%edx
  801d72:	48 89 c6             	mov    %rax,%rsi
  801d75:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801d7a:	48 b8 75 13 80 00 00 	movabs $0x801375,%rax
  801d81:	00 00 00 
  801d84:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801d86:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d8a:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801d90:	48 89 c1             	mov    %rax,%rcx
  801d93:	ba 00 00 00 00       	mov    $0x0,%edx
  801d98:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801d9d:	bf 00 00 00 00       	mov    $0x0,%edi
  801da2:	48 b8 d0 19 80 00 00 	movabs $0x8019d0,%rax
  801da9:	00 00 00 
  801dac:	ff d0                	callq  *%rax
  801dae:	85 c0                	test   %eax,%eax
  801db0:	79 2a                	jns    801ddc <pgfault+0x125>
				panic("Page map at temp address failed");
  801db2:	48 ba 78 4d 80 00 00 	movabs $0x804d78,%rdx
  801db9:	00 00 00 
  801dbc:	be 30 00 00 00       	mov    $0x30,%esi
  801dc1:	48 bf 6d 4d 80 00 00 	movabs $0x804d6d,%rdi
  801dc8:	00 00 00 
  801dcb:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd0:	48 b9 63 02 80 00 00 	movabs $0x800263,%rcx
  801dd7:	00 00 00 
  801dda:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801ddc:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801de1:	bf 00 00 00 00       	mov    $0x0,%edi
  801de6:	48 b8 2b 1a 80 00 00 	movabs $0x801a2b,%rax
  801ded:	00 00 00 
  801df0:	ff d0                	callq  *%rax
  801df2:	85 c0                	test   %eax,%eax
  801df4:	79 54                	jns    801e4a <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801df6:	48 ba 98 4d 80 00 00 	movabs $0x804d98,%rdx
  801dfd:	00 00 00 
  801e00:	be 32 00 00 00       	mov    $0x32,%esi
  801e05:	48 bf 6d 4d 80 00 00 	movabs $0x804d6d,%rdi
  801e0c:	00 00 00 
  801e0f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e14:	48 b9 63 02 80 00 00 	movabs $0x800263,%rcx
  801e1b:	00 00 00 
  801e1e:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  801e20:	48 ba c0 4d 80 00 00 	movabs $0x804dc0,%rdx
  801e27:	00 00 00 
  801e2a:	be 34 00 00 00       	mov    $0x34,%esi
  801e2f:	48 bf 6d 4d 80 00 00 	movabs $0x804d6d,%rdi
  801e36:	00 00 00 
  801e39:	b8 00 00 00 00       	mov    $0x0,%eax
  801e3e:	48 b9 63 02 80 00 00 	movabs $0x800263,%rcx
  801e45:	00 00 00 
  801e48:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  801e4a:	c9                   	leaveq 
  801e4b:	c3                   	retq   

0000000000801e4c <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801e4c:	55                   	push   %rbp
  801e4d:	48 89 e5             	mov    %rsp,%rbp
  801e50:	48 83 ec 20          	sub    $0x20,%rsp
  801e54:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e57:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  801e5a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e61:	01 00 00 
  801e64:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801e67:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e6b:	25 07 0e 00 00       	and    $0xe07,%eax
  801e70:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801e73:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801e76:	48 c1 e0 0c          	shl    $0xc,%rax
  801e7a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  801e7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e81:	25 00 04 00 00       	and    $0x400,%eax
  801e86:	85 c0                	test   %eax,%eax
  801e88:	74 57                	je     801ee1 <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801e8a:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801e8d:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801e91:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801e94:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e98:	41 89 f0             	mov    %esi,%r8d
  801e9b:	48 89 c6             	mov    %rax,%rsi
  801e9e:	bf 00 00 00 00       	mov    $0x0,%edi
  801ea3:	48 b8 d0 19 80 00 00 	movabs $0x8019d0,%rax
  801eaa:	00 00 00 
  801ead:	ff d0                	callq  *%rax
  801eaf:	85 c0                	test   %eax,%eax
  801eb1:	0f 8e 52 01 00 00    	jle    802009 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801eb7:	48 ba f2 4d 80 00 00 	movabs $0x804df2,%rdx
  801ebe:	00 00 00 
  801ec1:	be 4e 00 00 00       	mov    $0x4e,%esi
  801ec6:	48 bf 6d 4d 80 00 00 	movabs $0x804d6d,%rdi
  801ecd:	00 00 00 
  801ed0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed5:	48 b9 63 02 80 00 00 	movabs $0x800263,%rcx
  801edc:	00 00 00 
  801edf:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  801ee1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ee4:	83 e0 02             	and    $0x2,%eax
  801ee7:	85 c0                	test   %eax,%eax
  801ee9:	75 10                	jne    801efb <duppage+0xaf>
  801eeb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801eee:	25 00 08 00 00       	and    $0x800,%eax
  801ef3:	85 c0                	test   %eax,%eax
  801ef5:	0f 84 bb 00 00 00    	je     801fb6 <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  801efb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801efe:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  801f03:	80 cc 08             	or     $0x8,%ah
  801f06:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801f09:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801f0c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801f10:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801f13:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f17:	41 89 f0             	mov    %esi,%r8d
  801f1a:	48 89 c6             	mov    %rax,%rsi
  801f1d:	bf 00 00 00 00       	mov    $0x0,%edi
  801f22:	48 b8 d0 19 80 00 00 	movabs $0x8019d0,%rax
  801f29:	00 00 00 
  801f2c:	ff d0                	callq  *%rax
  801f2e:	85 c0                	test   %eax,%eax
  801f30:	7e 2a                	jle    801f5c <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  801f32:	48 ba f2 4d 80 00 00 	movabs $0x804df2,%rdx
  801f39:	00 00 00 
  801f3c:	be 55 00 00 00       	mov    $0x55,%esi
  801f41:	48 bf 6d 4d 80 00 00 	movabs $0x804d6d,%rdi
  801f48:	00 00 00 
  801f4b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f50:	48 b9 63 02 80 00 00 	movabs $0x800263,%rcx
  801f57:	00 00 00 
  801f5a:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  801f5c:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801f5f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f63:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f67:	41 89 c8             	mov    %ecx,%r8d
  801f6a:	48 89 d1             	mov    %rdx,%rcx
  801f6d:	ba 00 00 00 00       	mov    $0x0,%edx
  801f72:	48 89 c6             	mov    %rax,%rsi
  801f75:	bf 00 00 00 00       	mov    $0x0,%edi
  801f7a:	48 b8 d0 19 80 00 00 	movabs $0x8019d0,%rax
  801f81:	00 00 00 
  801f84:	ff d0                	callq  *%rax
  801f86:	85 c0                	test   %eax,%eax
  801f88:	7e 2a                	jle    801fb4 <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  801f8a:	48 ba f2 4d 80 00 00 	movabs $0x804df2,%rdx
  801f91:	00 00 00 
  801f94:	be 57 00 00 00       	mov    $0x57,%esi
  801f99:	48 bf 6d 4d 80 00 00 	movabs $0x804d6d,%rdi
  801fa0:	00 00 00 
  801fa3:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa8:	48 b9 63 02 80 00 00 	movabs $0x800263,%rcx
  801faf:	00 00 00 
  801fb2:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  801fb4:	eb 53                	jmp    802009 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801fb6:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801fb9:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801fbd:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801fc0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fc4:	41 89 f0             	mov    %esi,%r8d
  801fc7:	48 89 c6             	mov    %rax,%rsi
  801fca:	bf 00 00 00 00       	mov    $0x0,%edi
  801fcf:	48 b8 d0 19 80 00 00 	movabs $0x8019d0,%rax
  801fd6:	00 00 00 
  801fd9:	ff d0                	callq  *%rax
  801fdb:	85 c0                	test   %eax,%eax
  801fdd:	7e 2a                	jle    802009 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801fdf:	48 ba f2 4d 80 00 00 	movabs $0x804df2,%rdx
  801fe6:	00 00 00 
  801fe9:	be 5b 00 00 00       	mov    $0x5b,%esi
  801fee:	48 bf 6d 4d 80 00 00 	movabs $0x804d6d,%rdi
  801ff5:	00 00 00 
  801ff8:	b8 00 00 00 00       	mov    $0x0,%eax
  801ffd:	48 b9 63 02 80 00 00 	movabs $0x800263,%rcx
  802004:	00 00 00 
  802007:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  802009:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80200e:	c9                   	leaveq 
  80200f:	c3                   	retq   

0000000000802010 <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  802010:	55                   	push   %rbp
  802011:	48 89 e5             	mov    %rsp,%rbp
  802014:	48 83 ec 18          	sub    $0x18,%rsp
  802018:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  80201c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802020:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  802024:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802028:	48 c1 e8 27          	shr    $0x27,%rax
  80202c:	48 89 c2             	mov    %rax,%rdx
  80202f:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802036:	01 00 00 
  802039:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80203d:	83 e0 01             	and    $0x1,%eax
  802040:	48 85 c0             	test   %rax,%rax
  802043:	74 51                	je     802096 <pt_is_mapped+0x86>
  802045:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802049:	48 c1 e0 0c          	shl    $0xc,%rax
  80204d:	48 c1 e8 1e          	shr    $0x1e,%rax
  802051:	48 89 c2             	mov    %rax,%rdx
  802054:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80205b:	01 00 00 
  80205e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802062:	83 e0 01             	and    $0x1,%eax
  802065:	48 85 c0             	test   %rax,%rax
  802068:	74 2c                	je     802096 <pt_is_mapped+0x86>
  80206a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80206e:	48 c1 e0 0c          	shl    $0xc,%rax
  802072:	48 c1 e8 15          	shr    $0x15,%rax
  802076:	48 89 c2             	mov    %rax,%rdx
  802079:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802080:	01 00 00 
  802083:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802087:	83 e0 01             	and    $0x1,%eax
  80208a:	48 85 c0             	test   %rax,%rax
  80208d:	74 07                	je     802096 <pt_is_mapped+0x86>
  80208f:	b8 01 00 00 00       	mov    $0x1,%eax
  802094:	eb 05                	jmp    80209b <pt_is_mapped+0x8b>
  802096:	b8 00 00 00 00       	mov    $0x0,%eax
  80209b:	83 e0 01             	and    $0x1,%eax
}
  80209e:	c9                   	leaveq 
  80209f:	c3                   	retq   

00000000008020a0 <fork>:

envid_t
fork(void)
{
  8020a0:	55                   	push   %rbp
  8020a1:	48 89 e5             	mov    %rsp,%rbp
  8020a4:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  8020a8:	48 bf b7 1c 80 00 00 	movabs $0x801cb7,%rdi
  8020af:	00 00 00 
  8020b2:	48 b8 dd 43 80 00 00 	movabs $0x8043dd,%rax
  8020b9:	00 00 00 
  8020bc:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8020be:	b8 07 00 00 00       	mov    $0x7,%eax
  8020c3:	cd 30                	int    $0x30
  8020c5:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8020c8:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  8020cb:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  8020ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8020d2:	79 30                	jns    802104 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  8020d4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020d7:	89 c1                	mov    %eax,%ecx
  8020d9:	48 ba 10 4e 80 00 00 	movabs $0x804e10,%rdx
  8020e0:	00 00 00 
  8020e3:	be 86 00 00 00       	mov    $0x86,%esi
  8020e8:	48 bf 6d 4d 80 00 00 	movabs $0x804d6d,%rdi
  8020ef:	00 00 00 
  8020f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f7:	49 b8 63 02 80 00 00 	movabs $0x800263,%r8
  8020fe:	00 00 00 
  802101:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  802104:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802108:	75 46                	jne    802150 <fork+0xb0>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  80210a:	48 b8 04 19 80 00 00 	movabs $0x801904,%rax
  802111:	00 00 00 
  802114:	ff d0                	callq  *%rax
  802116:	25 ff 03 00 00       	and    $0x3ff,%eax
  80211b:	48 63 d0             	movslq %eax,%rdx
  80211e:	48 89 d0             	mov    %rdx,%rax
  802121:	48 c1 e0 03          	shl    $0x3,%rax
  802125:	48 01 d0             	add    %rdx,%rax
  802128:	48 c1 e0 05          	shl    $0x5,%rax
  80212c:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802133:	00 00 00 
  802136:	48 01 c2             	add    %rax,%rdx
  802139:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  802140:	00 00 00 
  802143:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  802146:	b8 00 00 00 00       	mov    $0x0,%eax
  80214b:	e9 d1 01 00 00       	jmpq   802321 <fork+0x281>
	}
	uint64_t ad = 0;
  802150:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802157:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  802158:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  80215d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802161:	e9 df 00 00 00       	jmpq   802245 <fork+0x1a5>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  802166:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80216a:	48 c1 e8 27          	shr    $0x27,%rax
  80216e:	48 89 c2             	mov    %rax,%rdx
  802171:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802178:	01 00 00 
  80217b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80217f:	83 e0 01             	and    $0x1,%eax
  802182:	48 85 c0             	test   %rax,%rax
  802185:	0f 84 9e 00 00 00    	je     802229 <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  80218b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80218f:	48 c1 e8 1e          	shr    $0x1e,%rax
  802193:	48 89 c2             	mov    %rax,%rdx
  802196:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80219d:	01 00 00 
  8021a0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021a4:	83 e0 01             	and    $0x1,%eax
  8021a7:	48 85 c0             	test   %rax,%rax
  8021aa:	74 73                	je     80221f <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  8021ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021b0:	48 c1 e8 15          	shr    $0x15,%rax
  8021b4:	48 89 c2             	mov    %rax,%rdx
  8021b7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021be:	01 00 00 
  8021c1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021c5:	83 e0 01             	and    $0x1,%eax
  8021c8:	48 85 c0             	test   %rax,%rax
  8021cb:	74 48                	je     802215 <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  8021cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021d1:	48 c1 e8 0c          	shr    $0xc,%rax
  8021d5:	48 89 c2             	mov    %rax,%rdx
  8021d8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021df:	01 00 00 
  8021e2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021e6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8021ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021ee:	83 e0 01             	and    $0x1,%eax
  8021f1:	48 85 c0             	test   %rax,%rax
  8021f4:	74 47                	je     80223d <fork+0x19d>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  8021f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021fa:	48 c1 e8 0c          	shr    $0xc,%rax
  8021fe:	89 c2                	mov    %eax,%edx
  802200:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802203:	89 d6                	mov    %edx,%esi
  802205:	89 c7                	mov    %eax,%edi
  802207:	48 b8 4c 1e 80 00 00 	movabs $0x801e4c,%rax
  80220e:	00 00 00 
  802211:	ff d0                	callq  *%rax
  802213:	eb 28                	jmp    80223d <fork+0x19d>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  802215:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  80221c:	00 
  80221d:	eb 1e                	jmp    80223d <fork+0x19d>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  80221f:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  802226:	40 
  802227:	eb 14                	jmp    80223d <fork+0x19d>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  802229:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80222d:	48 c1 e8 27          	shr    $0x27,%rax
  802231:	48 83 c0 01          	add    $0x1,%rax
  802235:	48 c1 e0 27          	shl    $0x27,%rax
  802239:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  80223d:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  802244:	00 
  802245:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  80224c:	00 
  80224d:	0f 87 13 ff ff ff    	ja     802166 <fork+0xc6>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  802253:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802256:	ba 07 00 00 00       	mov    $0x7,%edx
  80225b:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802260:	89 c7                	mov    %eax,%edi
  802262:	48 b8 80 19 80 00 00 	movabs $0x801980,%rax
  802269:	00 00 00 
  80226c:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  80226e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802271:	ba 07 00 00 00       	mov    $0x7,%edx
  802276:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80227b:	89 c7                	mov    %eax,%edi
  80227d:	48 b8 80 19 80 00 00 	movabs $0x801980,%rax
  802284:	00 00 00 
  802287:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  802289:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80228c:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802292:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  802297:	ba 00 00 00 00       	mov    $0x0,%edx
  80229c:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8022a1:	89 c7                	mov    %eax,%edi
  8022a3:	48 b8 d0 19 80 00 00 	movabs $0x8019d0,%rax
  8022aa:	00 00 00 
  8022ad:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  8022af:	ba 00 10 00 00       	mov    $0x1000,%edx
  8022b4:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8022b9:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  8022be:	48 b8 75 13 80 00 00 	movabs $0x801375,%rax
  8022c5:	00 00 00 
  8022c8:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  8022ca:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8022cf:	bf 00 00 00 00       	mov    $0x0,%edi
  8022d4:	48 b8 2b 1a 80 00 00 	movabs $0x801a2b,%rax
  8022db:	00 00 00 
  8022de:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  8022e0:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8022e7:	00 00 00 
  8022ea:	48 8b 00             	mov    (%rax),%rax
  8022ed:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  8022f4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8022f7:	48 89 d6             	mov    %rdx,%rsi
  8022fa:	89 c7                	mov    %eax,%edi
  8022fc:	48 b8 0a 1b 80 00 00 	movabs $0x801b0a,%rax
  802303:	00 00 00 
  802306:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  802308:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80230b:	be 02 00 00 00       	mov    $0x2,%esi
  802310:	89 c7                	mov    %eax,%edi
  802312:	48 b8 75 1a 80 00 00 	movabs $0x801a75,%rax
  802319:	00 00 00 
  80231c:	ff d0                	callq  *%rax

	return envid;
  80231e:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  802321:	c9                   	leaveq 
  802322:	c3                   	retq   

0000000000802323 <sfork>:

	
// Challenge!
int
sfork(void)
{
  802323:	55                   	push   %rbp
  802324:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802327:	48 ba 28 4e 80 00 00 	movabs $0x804e28,%rdx
  80232e:	00 00 00 
  802331:	be bf 00 00 00       	mov    $0xbf,%esi
  802336:	48 bf 6d 4d 80 00 00 	movabs $0x804d6d,%rdi
  80233d:	00 00 00 
  802340:	b8 00 00 00 00       	mov    $0x0,%eax
  802345:	48 b9 63 02 80 00 00 	movabs $0x800263,%rcx
  80234c:	00 00 00 
  80234f:	ff d1                	callq  *%rcx

0000000000802351 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802351:	55                   	push   %rbp
  802352:	48 89 e5             	mov    %rsp,%rbp
  802355:	48 83 ec 08          	sub    $0x8,%rsp
  802359:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80235d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802361:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802368:	ff ff ff 
  80236b:	48 01 d0             	add    %rdx,%rax
  80236e:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802372:	c9                   	leaveq 
  802373:	c3                   	retq   

0000000000802374 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802374:	55                   	push   %rbp
  802375:	48 89 e5             	mov    %rsp,%rbp
  802378:	48 83 ec 08          	sub    $0x8,%rsp
  80237c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802380:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802384:	48 89 c7             	mov    %rax,%rdi
  802387:	48 b8 51 23 80 00 00 	movabs $0x802351,%rax
  80238e:	00 00 00 
  802391:	ff d0                	callq  *%rax
  802393:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802399:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80239d:	c9                   	leaveq 
  80239e:	c3                   	retq   

000000000080239f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80239f:	55                   	push   %rbp
  8023a0:	48 89 e5             	mov    %rsp,%rbp
  8023a3:	48 83 ec 18          	sub    $0x18,%rsp
  8023a7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8023ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8023b2:	eb 6b                	jmp    80241f <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8023b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023b7:	48 98                	cltq   
  8023b9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8023bf:	48 c1 e0 0c          	shl    $0xc,%rax
  8023c3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8023c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023cb:	48 c1 e8 15          	shr    $0x15,%rax
  8023cf:	48 89 c2             	mov    %rax,%rdx
  8023d2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8023d9:	01 00 00 
  8023dc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023e0:	83 e0 01             	and    $0x1,%eax
  8023e3:	48 85 c0             	test   %rax,%rax
  8023e6:	74 21                	je     802409 <fd_alloc+0x6a>
  8023e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023ec:	48 c1 e8 0c          	shr    $0xc,%rax
  8023f0:	48 89 c2             	mov    %rax,%rdx
  8023f3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023fa:	01 00 00 
  8023fd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802401:	83 e0 01             	and    $0x1,%eax
  802404:	48 85 c0             	test   %rax,%rax
  802407:	75 12                	jne    80241b <fd_alloc+0x7c>
			*fd_store = fd;
  802409:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80240d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802411:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802414:	b8 00 00 00 00       	mov    $0x0,%eax
  802419:	eb 1a                	jmp    802435 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80241b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80241f:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802423:	7e 8f                	jle    8023b4 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802425:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802429:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802430:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802435:	c9                   	leaveq 
  802436:	c3                   	retq   

0000000000802437 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802437:	55                   	push   %rbp
  802438:	48 89 e5             	mov    %rsp,%rbp
  80243b:	48 83 ec 20          	sub    $0x20,%rsp
  80243f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802442:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802446:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80244a:	78 06                	js     802452 <fd_lookup+0x1b>
  80244c:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802450:	7e 07                	jle    802459 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802452:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802457:	eb 6c                	jmp    8024c5 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802459:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80245c:	48 98                	cltq   
  80245e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802464:	48 c1 e0 0c          	shl    $0xc,%rax
  802468:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80246c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802470:	48 c1 e8 15          	shr    $0x15,%rax
  802474:	48 89 c2             	mov    %rax,%rdx
  802477:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80247e:	01 00 00 
  802481:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802485:	83 e0 01             	and    $0x1,%eax
  802488:	48 85 c0             	test   %rax,%rax
  80248b:	74 21                	je     8024ae <fd_lookup+0x77>
  80248d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802491:	48 c1 e8 0c          	shr    $0xc,%rax
  802495:	48 89 c2             	mov    %rax,%rdx
  802498:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80249f:	01 00 00 
  8024a2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024a6:	83 e0 01             	and    $0x1,%eax
  8024a9:	48 85 c0             	test   %rax,%rax
  8024ac:	75 07                	jne    8024b5 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8024ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024b3:	eb 10                	jmp    8024c5 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8024b5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024b9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8024bd:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8024c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024c5:	c9                   	leaveq 
  8024c6:	c3                   	retq   

00000000008024c7 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8024c7:	55                   	push   %rbp
  8024c8:	48 89 e5             	mov    %rsp,%rbp
  8024cb:	48 83 ec 30          	sub    $0x30,%rsp
  8024cf:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8024d3:	89 f0                	mov    %esi,%eax
  8024d5:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8024d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024dc:	48 89 c7             	mov    %rax,%rdi
  8024df:	48 b8 51 23 80 00 00 	movabs $0x802351,%rax
  8024e6:	00 00 00 
  8024e9:	ff d0                	callq  *%rax
  8024eb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024ef:	48 89 d6             	mov    %rdx,%rsi
  8024f2:	89 c7                	mov    %eax,%edi
  8024f4:	48 b8 37 24 80 00 00 	movabs $0x802437,%rax
  8024fb:	00 00 00 
  8024fe:	ff d0                	callq  *%rax
  802500:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802503:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802507:	78 0a                	js     802513 <fd_close+0x4c>
	    || fd != fd2)
  802509:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80250d:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802511:	74 12                	je     802525 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802513:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802517:	74 05                	je     80251e <fd_close+0x57>
  802519:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80251c:	eb 05                	jmp    802523 <fd_close+0x5c>
  80251e:	b8 00 00 00 00       	mov    $0x0,%eax
  802523:	eb 69                	jmp    80258e <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802525:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802529:	8b 00                	mov    (%rax),%eax
  80252b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80252f:	48 89 d6             	mov    %rdx,%rsi
  802532:	89 c7                	mov    %eax,%edi
  802534:	48 b8 90 25 80 00 00 	movabs $0x802590,%rax
  80253b:	00 00 00 
  80253e:	ff d0                	callq  *%rax
  802540:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802543:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802547:	78 2a                	js     802573 <fd_close+0xac>
		if (dev->dev_close)
  802549:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80254d:	48 8b 40 20          	mov    0x20(%rax),%rax
  802551:	48 85 c0             	test   %rax,%rax
  802554:	74 16                	je     80256c <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802556:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80255a:	48 8b 40 20          	mov    0x20(%rax),%rax
  80255e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802562:	48 89 d7             	mov    %rdx,%rdi
  802565:	ff d0                	callq  *%rax
  802567:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80256a:	eb 07                	jmp    802573 <fd_close+0xac>
		else
			r = 0;
  80256c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802573:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802577:	48 89 c6             	mov    %rax,%rsi
  80257a:	bf 00 00 00 00       	mov    $0x0,%edi
  80257f:	48 b8 2b 1a 80 00 00 	movabs $0x801a2b,%rax
  802586:	00 00 00 
  802589:	ff d0                	callq  *%rax
	return r;
  80258b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80258e:	c9                   	leaveq 
  80258f:	c3                   	retq   

0000000000802590 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802590:	55                   	push   %rbp
  802591:	48 89 e5             	mov    %rsp,%rbp
  802594:	48 83 ec 20          	sub    $0x20,%rsp
  802598:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80259b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80259f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8025a6:	eb 41                	jmp    8025e9 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8025a8:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8025af:	00 00 00 
  8025b2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8025b5:	48 63 d2             	movslq %edx,%rdx
  8025b8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025bc:	8b 00                	mov    (%rax),%eax
  8025be:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8025c1:	75 22                	jne    8025e5 <dev_lookup+0x55>
			*dev = devtab[i];
  8025c3:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8025ca:	00 00 00 
  8025cd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8025d0:	48 63 d2             	movslq %edx,%rdx
  8025d3:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8025d7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025db:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8025de:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e3:	eb 60                	jmp    802645 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8025e5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8025e9:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8025f0:	00 00 00 
  8025f3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8025f6:	48 63 d2             	movslq %edx,%rdx
  8025f9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025fd:	48 85 c0             	test   %rax,%rax
  802600:	75 a6                	jne    8025a8 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802602:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  802609:	00 00 00 
  80260c:	48 8b 00             	mov    (%rax),%rax
  80260f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802615:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802618:	89 c6                	mov    %eax,%esi
  80261a:	48 bf 40 4e 80 00 00 	movabs $0x804e40,%rdi
  802621:	00 00 00 
  802624:	b8 00 00 00 00       	mov    $0x0,%eax
  802629:	48 b9 9c 04 80 00 00 	movabs $0x80049c,%rcx
  802630:	00 00 00 
  802633:	ff d1                	callq  *%rcx
	*dev = 0;
  802635:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802639:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802640:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802645:	c9                   	leaveq 
  802646:	c3                   	retq   

0000000000802647 <close>:

int
close(int fdnum)
{
  802647:	55                   	push   %rbp
  802648:	48 89 e5             	mov    %rsp,%rbp
  80264b:	48 83 ec 20          	sub    $0x20,%rsp
  80264f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802652:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802656:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802659:	48 89 d6             	mov    %rdx,%rsi
  80265c:	89 c7                	mov    %eax,%edi
  80265e:	48 b8 37 24 80 00 00 	movabs $0x802437,%rax
  802665:	00 00 00 
  802668:	ff d0                	callq  *%rax
  80266a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80266d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802671:	79 05                	jns    802678 <close+0x31>
		return r;
  802673:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802676:	eb 18                	jmp    802690 <close+0x49>
	else
		return fd_close(fd, 1);
  802678:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80267c:	be 01 00 00 00       	mov    $0x1,%esi
  802681:	48 89 c7             	mov    %rax,%rdi
  802684:	48 b8 c7 24 80 00 00 	movabs $0x8024c7,%rax
  80268b:	00 00 00 
  80268e:	ff d0                	callq  *%rax
}
  802690:	c9                   	leaveq 
  802691:	c3                   	retq   

0000000000802692 <close_all>:

void
close_all(void)
{
  802692:	55                   	push   %rbp
  802693:	48 89 e5             	mov    %rsp,%rbp
  802696:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80269a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8026a1:	eb 15                	jmp    8026b8 <close_all+0x26>
		close(i);
  8026a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026a6:	89 c7                	mov    %eax,%edi
  8026a8:	48 b8 47 26 80 00 00 	movabs $0x802647,%rax
  8026af:	00 00 00 
  8026b2:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8026b4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8026b8:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8026bc:	7e e5                	jle    8026a3 <close_all+0x11>
		close(i);
}
  8026be:	c9                   	leaveq 
  8026bf:	c3                   	retq   

00000000008026c0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8026c0:	55                   	push   %rbp
  8026c1:	48 89 e5             	mov    %rsp,%rbp
  8026c4:	48 83 ec 40          	sub    $0x40,%rsp
  8026c8:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8026cb:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8026ce:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8026d2:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8026d5:	48 89 d6             	mov    %rdx,%rsi
  8026d8:	89 c7                	mov    %eax,%edi
  8026da:	48 b8 37 24 80 00 00 	movabs $0x802437,%rax
  8026e1:	00 00 00 
  8026e4:	ff d0                	callq  *%rax
  8026e6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026ed:	79 08                	jns    8026f7 <dup+0x37>
		return r;
  8026ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026f2:	e9 70 01 00 00       	jmpq   802867 <dup+0x1a7>
	close(newfdnum);
  8026f7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8026fa:	89 c7                	mov    %eax,%edi
  8026fc:	48 b8 47 26 80 00 00 	movabs $0x802647,%rax
  802703:	00 00 00 
  802706:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802708:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80270b:	48 98                	cltq   
  80270d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802713:	48 c1 e0 0c          	shl    $0xc,%rax
  802717:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80271b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80271f:	48 89 c7             	mov    %rax,%rdi
  802722:	48 b8 74 23 80 00 00 	movabs $0x802374,%rax
  802729:	00 00 00 
  80272c:	ff d0                	callq  *%rax
  80272e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802732:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802736:	48 89 c7             	mov    %rax,%rdi
  802739:	48 b8 74 23 80 00 00 	movabs $0x802374,%rax
  802740:	00 00 00 
  802743:	ff d0                	callq  *%rax
  802745:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802749:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80274d:	48 c1 e8 15          	shr    $0x15,%rax
  802751:	48 89 c2             	mov    %rax,%rdx
  802754:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80275b:	01 00 00 
  80275e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802762:	83 e0 01             	and    $0x1,%eax
  802765:	48 85 c0             	test   %rax,%rax
  802768:	74 73                	je     8027dd <dup+0x11d>
  80276a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80276e:	48 c1 e8 0c          	shr    $0xc,%rax
  802772:	48 89 c2             	mov    %rax,%rdx
  802775:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80277c:	01 00 00 
  80277f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802783:	83 e0 01             	and    $0x1,%eax
  802786:	48 85 c0             	test   %rax,%rax
  802789:	74 52                	je     8027dd <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80278b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80278f:	48 c1 e8 0c          	shr    $0xc,%rax
  802793:	48 89 c2             	mov    %rax,%rdx
  802796:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80279d:	01 00 00 
  8027a0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027a4:	25 07 0e 00 00       	and    $0xe07,%eax
  8027a9:	89 c1                	mov    %eax,%ecx
  8027ab:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8027af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027b3:	41 89 c8             	mov    %ecx,%r8d
  8027b6:	48 89 d1             	mov    %rdx,%rcx
  8027b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8027be:	48 89 c6             	mov    %rax,%rsi
  8027c1:	bf 00 00 00 00       	mov    $0x0,%edi
  8027c6:	48 b8 d0 19 80 00 00 	movabs $0x8019d0,%rax
  8027cd:	00 00 00 
  8027d0:	ff d0                	callq  *%rax
  8027d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027d9:	79 02                	jns    8027dd <dup+0x11d>
			goto err;
  8027db:	eb 57                	jmp    802834 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8027dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027e1:	48 c1 e8 0c          	shr    $0xc,%rax
  8027e5:	48 89 c2             	mov    %rax,%rdx
  8027e8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8027ef:	01 00 00 
  8027f2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027f6:	25 07 0e 00 00       	and    $0xe07,%eax
  8027fb:	89 c1                	mov    %eax,%ecx
  8027fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802801:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802805:	41 89 c8             	mov    %ecx,%r8d
  802808:	48 89 d1             	mov    %rdx,%rcx
  80280b:	ba 00 00 00 00       	mov    $0x0,%edx
  802810:	48 89 c6             	mov    %rax,%rsi
  802813:	bf 00 00 00 00       	mov    $0x0,%edi
  802818:	48 b8 d0 19 80 00 00 	movabs $0x8019d0,%rax
  80281f:	00 00 00 
  802822:	ff d0                	callq  *%rax
  802824:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802827:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80282b:	79 02                	jns    80282f <dup+0x16f>
		goto err;
  80282d:	eb 05                	jmp    802834 <dup+0x174>

	return newfdnum;
  80282f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802832:	eb 33                	jmp    802867 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802834:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802838:	48 89 c6             	mov    %rax,%rsi
  80283b:	bf 00 00 00 00       	mov    $0x0,%edi
  802840:	48 b8 2b 1a 80 00 00 	movabs $0x801a2b,%rax
  802847:	00 00 00 
  80284a:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80284c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802850:	48 89 c6             	mov    %rax,%rsi
  802853:	bf 00 00 00 00       	mov    $0x0,%edi
  802858:	48 b8 2b 1a 80 00 00 	movabs $0x801a2b,%rax
  80285f:	00 00 00 
  802862:	ff d0                	callq  *%rax
	return r;
  802864:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802867:	c9                   	leaveq 
  802868:	c3                   	retq   

0000000000802869 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802869:	55                   	push   %rbp
  80286a:	48 89 e5             	mov    %rsp,%rbp
  80286d:	48 83 ec 40          	sub    $0x40,%rsp
  802871:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802874:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802878:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80287c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802880:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802883:	48 89 d6             	mov    %rdx,%rsi
  802886:	89 c7                	mov    %eax,%edi
  802888:	48 b8 37 24 80 00 00 	movabs $0x802437,%rax
  80288f:	00 00 00 
  802892:	ff d0                	callq  *%rax
  802894:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802897:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80289b:	78 24                	js     8028c1 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80289d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028a1:	8b 00                	mov    (%rax),%eax
  8028a3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028a7:	48 89 d6             	mov    %rdx,%rsi
  8028aa:	89 c7                	mov    %eax,%edi
  8028ac:	48 b8 90 25 80 00 00 	movabs $0x802590,%rax
  8028b3:	00 00 00 
  8028b6:	ff d0                	callq  *%rax
  8028b8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028bf:	79 05                	jns    8028c6 <read+0x5d>
		return r;
  8028c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028c4:	eb 76                	jmp    80293c <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8028c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028ca:	8b 40 08             	mov    0x8(%rax),%eax
  8028cd:	83 e0 03             	and    $0x3,%eax
  8028d0:	83 f8 01             	cmp    $0x1,%eax
  8028d3:	75 3a                	jne    80290f <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8028d5:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8028dc:	00 00 00 
  8028df:	48 8b 00             	mov    (%rax),%rax
  8028e2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8028e8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8028eb:	89 c6                	mov    %eax,%esi
  8028ed:	48 bf 5f 4e 80 00 00 	movabs $0x804e5f,%rdi
  8028f4:	00 00 00 
  8028f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8028fc:	48 b9 9c 04 80 00 00 	movabs $0x80049c,%rcx
  802903:	00 00 00 
  802906:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802908:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80290d:	eb 2d                	jmp    80293c <read+0xd3>
	}
	if (!dev->dev_read)
  80290f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802913:	48 8b 40 10          	mov    0x10(%rax),%rax
  802917:	48 85 c0             	test   %rax,%rax
  80291a:	75 07                	jne    802923 <read+0xba>
		return -E_NOT_SUPP;
  80291c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802921:	eb 19                	jmp    80293c <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802923:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802927:	48 8b 40 10          	mov    0x10(%rax),%rax
  80292b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80292f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802933:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802937:	48 89 cf             	mov    %rcx,%rdi
  80293a:	ff d0                	callq  *%rax
}
  80293c:	c9                   	leaveq 
  80293d:	c3                   	retq   

000000000080293e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80293e:	55                   	push   %rbp
  80293f:	48 89 e5             	mov    %rsp,%rbp
  802942:	48 83 ec 30          	sub    $0x30,%rsp
  802946:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802949:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80294d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802951:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802958:	eb 49                	jmp    8029a3 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80295a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80295d:	48 98                	cltq   
  80295f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802963:	48 29 c2             	sub    %rax,%rdx
  802966:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802969:	48 63 c8             	movslq %eax,%rcx
  80296c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802970:	48 01 c1             	add    %rax,%rcx
  802973:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802976:	48 89 ce             	mov    %rcx,%rsi
  802979:	89 c7                	mov    %eax,%edi
  80297b:	48 b8 69 28 80 00 00 	movabs $0x802869,%rax
  802982:	00 00 00 
  802985:	ff d0                	callq  *%rax
  802987:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80298a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80298e:	79 05                	jns    802995 <readn+0x57>
			return m;
  802990:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802993:	eb 1c                	jmp    8029b1 <readn+0x73>
		if (m == 0)
  802995:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802999:	75 02                	jne    80299d <readn+0x5f>
			break;
  80299b:	eb 11                	jmp    8029ae <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80299d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8029a0:	01 45 fc             	add    %eax,-0x4(%rbp)
  8029a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029a6:	48 98                	cltq   
  8029a8:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8029ac:	72 ac                	jb     80295a <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8029ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8029b1:	c9                   	leaveq 
  8029b2:	c3                   	retq   

00000000008029b3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8029b3:	55                   	push   %rbp
  8029b4:	48 89 e5             	mov    %rsp,%rbp
  8029b7:	48 83 ec 40          	sub    $0x40,%rsp
  8029bb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8029be:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8029c2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8029c6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029ca:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029cd:	48 89 d6             	mov    %rdx,%rsi
  8029d0:	89 c7                	mov    %eax,%edi
  8029d2:	48 b8 37 24 80 00 00 	movabs $0x802437,%rax
  8029d9:	00 00 00 
  8029dc:	ff d0                	callq  *%rax
  8029de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029e5:	78 24                	js     802a0b <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8029e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029eb:	8b 00                	mov    (%rax),%eax
  8029ed:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029f1:	48 89 d6             	mov    %rdx,%rsi
  8029f4:	89 c7                	mov    %eax,%edi
  8029f6:	48 b8 90 25 80 00 00 	movabs $0x802590,%rax
  8029fd:	00 00 00 
  802a00:	ff d0                	callq  *%rax
  802a02:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a05:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a09:	79 05                	jns    802a10 <write+0x5d>
		return r;
  802a0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a0e:	eb 75                	jmp    802a85 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802a10:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a14:	8b 40 08             	mov    0x8(%rax),%eax
  802a17:	83 e0 03             	and    $0x3,%eax
  802a1a:	85 c0                	test   %eax,%eax
  802a1c:	75 3a                	jne    802a58 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802a1e:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  802a25:	00 00 00 
  802a28:	48 8b 00             	mov    (%rax),%rax
  802a2b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a31:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a34:	89 c6                	mov    %eax,%esi
  802a36:	48 bf 7b 4e 80 00 00 	movabs $0x804e7b,%rdi
  802a3d:	00 00 00 
  802a40:	b8 00 00 00 00       	mov    $0x0,%eax
  802a45:	48 b9 9c 04 80 00 00 	movabs $0x80049c,%rcx
  802a4c:	00 00 00 
  802a4f:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802a51:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a56:	eb 2d                	jmp    802a85 <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  802a58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a5c:	48 8b 40 18          	mov    0x18(%rax),%rax
  802a60:	48 85 c0             	test   %rax,%rax
  802a63:	75 07                	jne    802a6c <write+0xb9>
		return -E_NOT_SUPP;
  802a65:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a6a:	eb 19                	jmp    802a85 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802a6c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a70:	48 8b 40 18          	mov    0x18(%rax),%rax
  802a74:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802a78:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a7c:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802a80:	48 89 cf             	mov    %rcx,%rdi
  802a83:	ff d0                	callq  *%rax
}
  802a85:	c9                   	leaveq 
  802a86:	c3                   	retq   

0000000000802a87 <seek>:

int
seek(int fdnum, off_t offset)
{
  802a87:	55                   	push   %rbp
  802a88:	48 89 e5             	mov    %rsp,%rbp
  802a8b:	48 83 ec 18          	sub    $0x18,%rsp
  802a8f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a92:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a95:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a99:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a9c:	48 89 d6             	mov    %rdx,%rsi
  802a9f:	89 c7                	mov    %eax,%edi
  802aa1:	48 b8 37 24 80 00 00 	movabs $0x802437,%rax
  802aa8:	00 00 00 
  802aab:	ff d0                	callq  *%rax
  802aad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ab0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ab4:	79 05                	jns    802abb <seek+0x34>
		return r;
  802ab6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ab9:	eb 0f                	jmp    802aca <seek+0x43>
	fd->fd_offset = offset;
  802abb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802abf:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802ac2:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802ac5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802aca:	c9                   	leaveq 
  802acb:	c3                   	retq   

0000000000802acc <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802acc:	55                   	push   %rbp
  802acd:	48 89 e5             	mov    %rsp,%rbp
  802ad0:	48 83 ec 30          	sub    $0x30,%rsp
  802ad4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ad7:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ada:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ade:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ae1:	48 89 d6             	mov    %rdx,%rsi
  802ae4:	89 c7                	mov    %eax,%edi
  802ae6:	48 b8 37 24 80 00 00 	movabs $0x802437,%rax
  802aed:	00 00 00 
  802af0:	ff d0                	callq  *%rax
  802af2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802af5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802af9:	78 24                	js     802b1f <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802afb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aff:	8b 00                	mov    (%rax),%eax
  802b01:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b05:	48 89 d6             	mov    %rdx,%rsi
  802b08:	89 c7                	mov    %eax,%edi
  802b0a:	48 b8 90 25 80 00 00 	movabs $0x802590,%rax
  802b11:	00 00 00 
  802b14:	ff d0                	callq  *%rax
  802b16:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b19:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b1d:	79 05                	jns    802b24 <ftruncate+0x58>
		return r;
  802b1f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b22:	eb 72                	jmp    802b96 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802b24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b28:	8b 40 08             	mov    0x8(%rax),%eax
  802b2b:	83 e0 03             	and    $0x3,%eax
  802b2e:	85 c0                	test   %eax,%eax
  802b30:	75 3a                	jne    802b6c <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802b32:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  802b39:	00 00 00 
  802b3c:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802b3f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b45:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b48:	89 c6                	mov    %eax,%esi
  802b4a:	48 bf 98 4e 80 00 00 	movabs $0x804e98,%rdi
  802b51:	00 00 00 
  802b54:	b8 00 00 00 00       	mov    $0x0,%eax
  802b59:	48 b9 9c 04 80 00 00 	movabs $0x80049c,%rcx
  802b60:	00 00 00 
  802b63:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802b65:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b6a:	eb 2a                	jmp    802b96 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802b6c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b70:	48 8b 40 30          	mov    0x30(%rax),%rax
  802b74:	48 85 c0             	test   %rax,%rax
  802b77:	75 07                	jne    802b80 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802b79:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b7e:	eb 16                	jmp    802b96 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802b80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b84:	48 8b 40 30          	mov    0x30(%rax),%rax
  802b88:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b8c:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802b8f:	89 ce                	mov    %ecx,%esi
  802b91:	48 89 d7             	mov    %rdx,%rdi
  802b94:	ff d0                	callq  *%rax
}
  802b96:	c9                   	leaveq 
  802b97:	c3                   	retq   

0000000000802b98 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802b98:	55                   	push   %rbp
  802b99:	48 89 e5             	mov    %rsp,%rbp
  802b9c:	48 83 ec 30          	sub    $0x30,%rsp
  802ba0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ba3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ba7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802bab:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802bae:	48 89 d6             	mov    %rdx,%rsi
  802bb1:	89 c7                	mov    %eax,%edi
  802bb3:	48 b8 37 24 80 00 00 	movabs $0x802437,%rax
  802bba:	00 00 00 
  802bbd:	ff d0                	callq  *%rax
  802bbf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bc2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bc6:	78 24                	js     802bec <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802bc8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bcc:	8b 00                	mov    (%rax),%eax
  802bce:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802bd2:	48 89 d6             	mov    %rdx,%rsi
  802bd5:	89 c7                	mov    %eax,%edi
  802bd7:	48 b8 90 25 80 00 00 	movabs $0x802590,%rax
  802bde:	00 00 00 
  802be1:	ff d0                	callq  *%rax
  802be3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802be6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bea:	79 05                	jns    802bf1 <fstat+0x59>
		return r;
  802bec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bef:	eb 5e                	jmp    802c4f <fstat+0xb7>
	if (!dev->dev_stat)
  802bf1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bf5:	48 8b 40 28          	mov    0x28(%rax),%rax
  802bf9:	48 85 c0             	test   %rax,%rax
  802bfc:	75 07                	jne    802c05 <fstat+0x6d>
		return -E_NOT_SUPP;
  802bfe:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c03:	eb 4a                	jmp    802c4f <fstat+0xb7>
	stat->st_name[0] = 0;
  802c05:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c09:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802c0c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c10:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802c17:	00 00 00 
	stat->st_isdir = 0;
  802c1a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c1e:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802c25:	00 00 00 
	stat->st_dev = dev;
  802c28:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c2c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c30:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802c37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c3b:	48 8b 40 28          	mov    0x28(%rax),%rax
  802c3f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c43:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802c47:	48 89 ce             	mov    %rcx,%rsi
  802c4a:	48 89 d7             	mov    %rdx,%rdi
  802c4d:	ff d0                	callq  *%rax
}
  802c4f:	c9                   	leaveq 
  802c50:	c3                   	retq   

0000000000802c51 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802c51:	55                   	push   %rbp
  802c52:	48 89 e5             	mov    %rsp,%rbp
  802c55:	48 83 ec 20          	sub    $0x20,%rsp
  802c59:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c5d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802c61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c65:	be 00 00 00 00       	mov    $0x0,%esi
  802c6a:	48 89 c7             	mov    %rax,%rdi
  802c6d:	48 b8 3f 2d 80 00 00 	movabs $0x802d3f,%rax
  802c74:	00 00 00 
  802c77:	ff d0                	callq  *%rax
  802c79:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c7c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c80:	79 05                	jns    802c87 <stat+0x36>
		return fd;
  802c82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c85:	eb 2f                	jmp    802cb6 <stat+0x65>
	r = fstat(fd, stat);
  802c87:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c8e:	48 89 d6             	mov    %rdx,%rsi
  802c91:	89 c7                	mov    %eax,%edi
  802c93:	48 b8 98 2b 80 00 00 	movabs $0x802b98,%rax
  802c9a:	00 00 00 
  802c9d:	ff d0                	callq  *%rax
  802c9f:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802ca2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ca5:	89 c7                	mov    %eax,%edi
  802ca7:	48 b8 47 26 80 00 00 	movabs $0x802647,%rax
  802cae:	00 00 00 
  802cb1:	ff d0                	callq  *%rax
	return r;
  802cb3:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802cb6:	c9                   	leaveq 
  802cb7:	c3                   	retq   

0000000000802cb8 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802cb8:	55                   	push   %rbp
  802cb9:	48 89 e5             	mov    %rsp,%rbp
  802cbc:	48 83 ec 10          	sub    $0x10,%rsp
  802cc0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802cc3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802cc7:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802cce:	00 00 00 
  802cd1:	8b 00                	mov    (%rax),%eax
  802cd3:	85 c0                	test   %eax,%eax
  802cd5:	75 1d                	jne    802cf4 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802cd7:	bf 01 00 00 00       	mov    $0x1,%edi
  802cdc:	48 b8 85 46 80 00 00 	movabs $0x804685,%rax
  802ce3:	00 00 00 
  802ce6:	ff d0                	callq  *%rax
  802ce8:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802cef:	00 00 00 
  802cf2:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802cf4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802cfb:	00 00 00 
  802cfe:	8b 00                	mov    (%rax),%eax
  802d00:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802d03:	b9 07 00 00 00       	mov    $0x7,%ecx
  802d08:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802d0f:	00 00 00 
  802d12:	89 c7                	mov    %eax,%edi
  802d14:	48 b8 23 46 80 00 00 	movabs $0x804623,%rax
  802d1b:	00 00 00 
  802d1e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802d20:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d24:	ba 00 00 00 00       	mov    $0x0,%edx
  802d29:	48 89 c6             	mov    %rax,%rsi
  802d2c:	bf 00 00 00 00       	mov    $0x0,%edi
  802d31:	48 b8 1d 45 80 00 00 	movabs $0x80451d,%rax
  802d38:	00 00 00 
  802d3b:	ff d0                	callq  *%rax
}
  802d3d:	c9                   	leaveq 
  802d3e:	c3                   	retq   

0000000000802d3f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802d3f:	55                   	push   %rbp
  802d40:	48 89 e5             	mov    %rsp,%rbp
  802d43:	48 83 ec 30          	sub    $0x30,%rsp
  802d47:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802d4b:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802d4e:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802d55:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802d5c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802d63:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802d68:	75 08                	jne    802d72 <open+0x33>
	{
		return r;
  802d6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d6d:	e9 f2 00 00 00       	jmpq   802e64 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802d72:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d76:	48 89 c7             	mov    %rax,%rdi
  802d79:	48 b8 e5 0f 80 00 00 	movabs $0x800fe5,%rax
  802d80:	00 00 00 
  802d83:	ff d0                	callq  *%rax
  802d85:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802d88:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802d8f:	7e 0a                	jle    802d9b <open+0x5c>
	{
		return -E_BAD_PATH;
  802d91:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802d96:	e9 c9 00 00 00       	jmpq   802e64 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802d9b:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802da2:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802da3:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802da7:	48 89 c7             	mov    %rax,%rdi
  802daa:	48 b8 9f 23 80 00 00 	movabs $0x80239f,%rax
  802db1:	00 00 00 
  802db4:	ff d0                	callq  *%rax
  802db6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802db9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dbd:	78 09                	js     802dc8 <open+0x89>
  802dbf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dc3:	48 85 c0             	test   %rax,%rax
  802dc6:	75 08                	jne    802dd0 <open+0x91>
		{
			return r;
  802dc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dcb:	e9 94 00 00 00       	jmpq   802e64 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802dd0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802dd4:	ba 00 04 00 00       	mov    $0x400,%edx
  802dd9:	48 89 c6             	mov    %rax,%rsi
  802ddc:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802de3:	00 00 00 
  802de6:	48 b8 e3 10 80 00 00 	movabs $0x8010e3,%rax
  802ded:	00 00 00 
  802df0:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802df2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802df9:	00 00 00 
  802dfc:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802dff:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802e05:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e09:	48 89 c6             	mov    %rax,%rsi
  802e0c:	bf 01 00 00 00       	mov    $0x1,%edi
  802e11:	48 b8 b8 2c 80 00 00 	movabs $0x802cb8,%rax
  802e18:	00 00 00 
  802e1b:	ff d0                	callq  *%rax
  802e1d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e20:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e24:	79 2b                	jns    802e51 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802e26:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e2a:	be 00 00 00 00       	mov    $0x0,%esi
  802e2f:	48 89 c7             	mov    %rax,%rdi
  802e32:	48 b8 c7 24 80 00 00 	movabs $0x8024c7,%rax
  802e39:	00 00 00 
  802e3c:	ff d0                	callq  *%rax
  802e3e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802e41:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802e45:	79 05                	jns    802e4c <open+0x10d>
			{
				return d;
  802e47:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e4a:	eb 18                	jmp    802e64 <open+0x125>
			}
			return r;
  802e4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e4f:	eb 13                	jmp    802e64 <open+0x125>
		}	
		return fd2num(fd_store);
  802e51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e55:	48 89 c7             	mov    %rax,%rdi
  802e58:	48 b8 51 23 80 00 00 	movabs $0x802351,%rax
  802e5f:	00 00 00 
  802e62:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802e64:	c9                   	leaveq 
  802e65:	c3                   	retq   

0000000000802e66 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802e66:	55                   	push   %rbp
  802e67:	48 89 e5             	mov    %rsp,%rbp
  802e6a:	48 83 ec 10          	sub    $0x10,%rsp
  802e6e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802e72:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e76:	8b 50 0c             	mov    0xc(%rax),%edx
  802e79:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e80:	00 00 00 
  802e83:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802e85:	be 00 00 00 00       	mov    $0x0,%esi
  802e8a:	bf 06 00 00 00       	mov    $0x6,%edi
  802e8f:	48 b8 b8 2c 80 00 00 	movabs $0x802cb8,%rax
  802e96:	00 00 00 
  802e99:	ff d0                	callq  *%rax
}
  802e9b:	c9                   	leaveq 
  802e9c:	c3                   	retq   

0000000000802e9d <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802e9d:	55                   	push   %rbp
  802e9e:	48 89 e5             	mov    %rsp,%rbp
  802ea1:	48 83 ec 30          	sub    $0x30,%rsp
  802ea5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ea9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ead:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802eb1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802eb8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802ebd:	74 07                	je     802ec6 <devfile_read+0x29>
  802ebf:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802ec4:	75 07                	jne    802ecd <devfile_read+0x30>
		return -E_INVAL;
  802ec6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ecb:	eb 77                	jmp    802f44 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802ecd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ed1:	8b 50 0c             	mov    0xc(%rax),%edx
  802ed4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802edb:	00 00 00 
  802ede:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802ee0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ee7:	00 00 00 
  802eea:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802eee:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802ef2:	be 00 00 00 00       	mov    $0x0,%esi
  802ef7:	bf 03 00 00 00       	mov    $0x3,%edi
  802efc:	48 b8 b8 2c 80 00 00 	movabs $0x802cb8,%rax
  802f03:	00 00 00 
  802f06:	ff d0                	callq  *%rax
  802f08:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f0b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f0f:	7f 05                	jg     802f16 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802f11:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f14:	eb 2e                	jmp    802f44 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802f16:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f19:	48 63 d0             	movslq %eax,%rdx
  802f1c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f20:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802f27:	00 00 00 
  802f2a:	48 89 c7             	mov    %rax,%rdi
  802f2d:	48 b8 75 13 80 00 00 	movabs $0x801375,%rax
  802f34:	00 00 00 
  802f37:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802f39:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f3d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802f41:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802f44:	c9                   	leaveq 
  802f45:	c3                   	retq   

0000000000802f46 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802f46:	55                   	push   %rbp
  802f47:	48 89 e5             	mov    %rsp,%rbp
  802f4a:	48 83 ec 30          	sub    $0x30,%rsp
  802f4e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f52:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f56:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802f5a:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802f61:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802f66:	74 07                	je     802f6f <devfile_write+0x29>
  802f68:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802f6d:	75 08                	jne    802f77 <devfile_write+0x31>
		return r;
  802f6f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f72:	e9 9a 00 00 00       	jmpq   803011 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802f77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f7b:	8b 50 0c             	mov    0xc(%rax),%edx
  802f7e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f85:	00 00 00 
  802f88:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802f8a:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802f91:	00 
  802f92:	76 08                	jbe    802f9c <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802f94:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802f9b:	00 
	}
	fsipcbuf.write.req_n = n;
  802f9c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fa3:	00 00 00 
  802fa6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802faa:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802fae:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802fb2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fb6:	48 89 c6             	mov    %rax,%rsi
  802fb9:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802fc0:	00 00 00 
  802fc3:	48 b8 75 13 80 00 00 	movabs $0x801375,%rax
  802fca:	00 00 00 
  802fcd:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802fcf:	be 00 00 00 00       	mov    $0x0,%esi
  802fd4:	bf 04 00 00 00       	mov    $0x4,%edi
  802fd9:	48 b8 b8 2c 80 00 00 	movabs $0x802cb8,%rax
  802fe0:	00 00 00 
  802fe3:	ff d0                	callq  *%rax
  802fe5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fe8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fec:	7f 20                	jg     80300e <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802fee:	48 bf be 4e 80 00 00 	movabs $0x804ebe,%rdi
  802ff5:	00 00 00 
  802ff8:	b8 00 00 00 00       	mov    $0x0,%eax
  802ffd:	48 ba 9c 04 80 00 00 	movabs $0x80049c,%rdx
  803004:	00 00 00 
  803007:	ff d2                	callq  *%rdx
		return r;
  803009:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80300c:	eb 03                	jmp    803011 <devfile_write+0xcb>
	}
	return r;
  80300e:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  803011:	c9                   	leaveq 
  803012:	c3                   	retq   

0000000000803013 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803013:	55                   	push   %rbp
  803014:	48 89 e5             	mov    %rsp,%rbp
  803017:	48 83 ec 20          	sub    $0x20,%rsp
  80301b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80301f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803023:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803027:	8b 50 0c             	mov    0xc(%rax),%edx
  80302a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803031:	00 00 00 
  803034:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803036:	be 00 00 00 00       	mov    $0x0,%esi
  80303b:	bf 05 00 00 00       	mov    $0x5,%edi
  803040:	48 b8 b8 2c 80 00 00 	movabs $0x802cb8,%rax
  803047:	00 00 00 
  80304a:	ff d0                	callq  *%rax
  80304c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80304f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803053:	79 05                	jns    80305a <devfile_stat+0x47>
		return r;
  803055:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803058:	eb 56                	jmp    8030b0 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80305a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80305e:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803065:	00 00 00 
  803068:	48 89 c7             	mov    %rax,%rdi
  80306b:	48 b8 51 10 80 00 00 	movabs $0x801051,%rax
  803072:	00 00 00 
  803075:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803077:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80307e:	00 00 00 
  803081:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803087:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80308b:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803091:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803098:	00 00 00 
  80309b:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8030a1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030a5:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8030ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030b0:	c9                   	leaveq 
  8030b1:	c3                   	retq   

00000000008030b2 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8030b2:	55                   	push   %rbp
  8030b3:	48 89 e5             	mov    %rsp,%rbp
  8030b6:	48 83 ec 10          	sub    $0x10,%rsp
  8030ba:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8030be:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8030c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030c5:	8b 50 0c             	mov    0xc(%rax),%edx
  8030c8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030cf:	00 00 00 
  8030d2:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8030d4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030db:	00 00 00 
  8030de:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8030e1:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8030e4:	be 00 00 00 00       	mov    $0x0,%esi
  8030e9:	bf 02 00 00 00       	mov    $0x2,%edi
  8030ee:	48 b8 b8 2c 80 00 00 	movabs $0x802cb8,%rax
  8030f5:	00 00 00 
  8030f8:	ff d0                	callq  *%rax
}
  8030fa:	c9                   	leaveq 
  8030fb:	c3                   	retq   

00000000008030fc <remove>:

// Delete a file
int
remove(const char *path)
{
  8030fc:	55                   	push   %rbp
  8030fd:	48 89 e5             	mov    %rsp,%rbp
  803100:	48 83 ec 10          	sub    $0x10,%rsp
  803104:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803108:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80310c:	48 89 c7             	mov    %rax,%rdi
  80310f:	48 b8 e5 0f 80 00 00 	movabs $0x800fe5,%rax
  803116:	00 00 00 
  803119:	ff d0                	callq  *%rax
  80311b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803120:	7e 07                	jle    803129 <remove+0x2d>
		return -E_BAD_PATH;
  803122:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803127:	eb 33                	jmp    80315c <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803129:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80312d:	48 89 c6             	mov    %rax,%rsi
  803130:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  803137:	00 00 00 
  80313a:	48 b8 51 10 80 00 00 	movabs $0x801051,%rax
  803141:	00 00 00 
  803144:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803146:	be 00 00 00 00       	mov    $0x0,%esi
  80314b:	bf 07 00 00 00       	mov    $0x7,%edi
  803150:	48 b8 b8 2c 80 00 00 	movabs $0x802cb8,%rax
  803157:	00 00 00 
  80315a:	ff d0                	callq  *%rax
}
  80315c:	c9                   	leaveq 
  80315d:	c3                   	retq   

000000000080315e <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80315e:	55                   	push   %rbp
  80315f:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803162:	be 00 00 00 00       	mov    $0x0,%esi
  803167:	bf 08 00 00 00       	mov    $0x8,%edi
  80316c:	48 b8 b8 2c 80 00 00 	movabs $0x802cb8,%rax
  803173:	00 00 00 
  803176:	ff d0                	callq  *%rax
}
  803178:	5d                   	pop    %rbp
  803179:	c3                   	retq   

000000000080317a <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  80317a:	55                   	push   %rbp
  80317b:	48 89 e5             	mov    %rsp,%rbp
  80317e:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803185:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  80318c:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803193:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  80319a:	be 00 00 00 00       	mov    $0x0,%esi
  80319f:	48 89 c7             	mov    %rax,%rdi
  8031a2:	48 b8 3f 2d 80 00 00 	movabs $0x802d3f,%rax
  8031a9:	00 00 00 
  8031ac:	ff d0                	callq  *%rax
  8031ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8031b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031b5:	79 28                	jns    8031df <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8031b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031ba:	89 c6                	mov    %eax,%esi
  8031bc:	48 bf da 4e 80 00 00 	movabs $0x804eda,%rdi
  8031c3:	00 00 00 
  8031c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8031cb:	48 ba 9c 04 80 00 00 	movabs $0x80049c,%rdx
  8031d2:	00 00 00 
  8031d5:	ff d2                	callq  *%rdx
		return fd_src;
  8031d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031da:	e9 74 01 00 00       	jmpq   803353 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8031df:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8031e6:	be 01 01 00 00       	mov    $0x101,%esi
  8031eb:	48 89 c7             	mov    %rax,%rdi
  8031ee:	48 b8 3f 2d 80 00 00 	movabs $0x802d3f,%rax
  8031f5:	00 00 00 
  8031f8:	ff d0                	callq  *%rax
  8031fa:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8031fd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803201:	79 39                	jns    80323c <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803203:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803206:	89 c6                	mov    %eax,%esi
  803208:	48 bf f0 4e 80 00 00 	movabs $0x804ef0,%rdi
  80320f:	00 00 00 
  803212:	b8 00 00 00 00       	mov    $0x0,%eax
  803217:	48 ba 9c 04 80 00 00 	movabs $0x80049c,%rdx
  80321e:	00 00 00 
  803221:	ff d2                	callq  *%rdx
		close(fd_src);
  803223:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803226:	89 c7                	mov    %eax,%edi
  803228:	48 b8 47 26 80 00 00 	movabs $0x802647,%rax
  80322f:	00 00 00 
  803232:	ff d0                	callq  *%rax
		return fd_dest;
  803234:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803237:	e9 17 01 00 00       	jmpq   803353 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80323c:	eb 74                	jmp    8032b2 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  80323e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803241:	48 63 d0             	movslq %eax,%rdx
  803244:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80324b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80324e:	48 89 ce             	mov    %rcx,%rsi
  803251:	89 c7                	mov    %eax,%edi
  803253:	48 b8 b3 29 80 00 00 	movabs $0x8029b3,%rax
  80325a:	00 00 00 
  80325d:	ff d0                	callq  *%rax
  80325f:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803262:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803266:	79 4a                	jns    8032b2 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  803268:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80326b:	89 c6                	mov    %eax,%esi
  80326d:	48 bf 0a 4f 80 00 00 	movabs $0x804f0a,%rdi
  803274:	00 00 00 
  803277:	b8 00 00 00 00       	mov    $0x0,%eax
  80327c:	48 ba 9c 04 80 00 00 	movabs $0x80049c,%rdx
  803283:	00 00 00 
  803286:	ff d2                	callq  *%rdx
			close(fd_src);
  803288:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80328b:	89 c7                	mov    %eax,%edi
  80328d:	48 b8 47 26 80 00 00 	movabs $0x802647,%rax
  803294:	00 00 00 
  803297:	ff d0                	callq  *%rax
			close(fd_dest);
  803299:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80329c:	89 c7                	mov    %eax,%edi
  80329e:	48 b8 47 26 80 00 00 	movabs $0x802647,%rax
  8032a5:	00 00 00 
  8032a8:	ff d0                	callq  *%rax
			return write_size;
  8032aa:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8032ad:	e9 a1 00 00 00       	jmpq   803353 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8032b2:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8032b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032bc:	ba 00 02 00 00       	mov    $0x200,%edx
  8032c1:	48 89 ce             	mov    %rcx,%rsi
  8032c4:	89 c7                	mov    %eax,%edi
  8032c6:	48 b8 69 28 80 00 00 	movabs $0x802869,%rax
  8032cd:	00 00 00 
  8032d0:	ff d0                	callq  *%rax
  8032d2:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8032d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8032d9:	0f 8f 5f ff ff ff    	jg     80323e <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  8032df:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8032e3:	79 47                	jns    80332c <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8032e5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8032e8:	89 c6                	mov    %eax,%esi
  8032ea:	48 bf 1d 4f 80 00 00 	movabs $0x804f1d,%rdi
  8032f1:	00 00 00 
  8032f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8032f9:	48 ba 9c 04 80 00 00 	movabs $0x80049c,%rdx
  803300:	00 00 00 
  803303:	ff d2                	callq  *%rdx
		close(fd_src);
  803305:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803308:	89 c7                	mov    %eax,%edi
  80330a:	48 b8 47 26 80 00 00 	movabs $0x802647,%rax
  803311:	00 00 00 
  803314:	ff d0                	callq  *%rax
		close(fd_dest);
  803316:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803319:	89 c7                	mov    %eax,%edi
  80331b:	48 b8 47 26 80 00 00 	movabs $0x802647,%rax
  803322:	00 00 00 
  803325:	ff d0                	callq  *%rax
		return read_size;
  803327:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80332a:	eb 27                	jmp    803353 <copy+0x1d9>
	}
	close(fd_src);
  80332c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80332f:	89 c7                	mov    %eax,%edi
  803331:	48 b8 47 26 80 00 00 	movabs $0x802647,%rax
  803338:	00 00 00 
  80333b:	ff d0                	callq  *%rax
	close(fd_dest);
  80333d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803340:	89 c7                	mov    %eax,%edi
  803342:	48 b8 47 26 80 00 00 	movabs $0x802647,%rax
  803349:	00 00 00 
  80334c:	ff d0                	callq  *%rax
	return 0;
  80334e:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803353:	c9                   	leaveq 
  803354:	c3                   	retq   

0000000000803355 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803355:	55                   	push   %rbp
  803356:	48 89 e5             	mov    %rsp,%rbp
  803359:	48 83 ec 20          	sub    $0x20,%rsp
  80335d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803360:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803364:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803367:	48 89 d6             	mov    %rdx,%rsi
  80336a:	89 c7                	mov    %eax,%edi
  80336c:	48 b8 37 24 80 00 00 	movabs $0x802437,%rax
  803373:	00 00 00 
  803376:	ff d0                	callq  *%rax
  803378:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80337b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80337f:	79 05                	jns    803386 <fd2sockid+0x31>
		return r;
  803381:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803384:	eb 24                	jmp    8033aa <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803386:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80338a:	8b 10                	mov    (%rax),%edx
  80338c:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  803393:	00 00 00 
  803396:	8b 00                	mov    (%rax),%eax
  803398:	39 c2                	cmp    %eax,%edx
  80339a:	74 07                	je     8033a3 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80339c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8033a1:	eb 07                	jmp    8033aa <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8033a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033a7:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8033aa:	c9                   	leaveq 
  8033ab:	c3                   	retq   

00000000008033ac <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8033ac:	55                   	push   %rbp
  8033ad:	48 89 e5             	mov    %rsp,%rbp
  8033b0:	48 83 ec 20          	sub    $0x20,%rsp
  8033b4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8033b7:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8033bb:	48 89 c7             	mov    %rax,%rdi
  8033be:	48 b8 9f 23 80 00 00 	movabs $0x80239f,%rax
  8033c5:	00 00 00 
  8033c8:	ff d0                	callq  *%rax
  8033ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033d1:	78 26                	js     8033f9 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8033d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033d7:	ba 07 04 00 00       	mov    $0x407,%edx
  8033dc:	48 89 c6             	mov    %rax,%rsi
  8033df:	bf 00 00 00 00       	mov    $0x0,%edi
  8033e4:	48 b8 80 19 80 00 00 	movabs $0x801980,%rax
  8033eb:	00 00 00 
  8033ee:	ff d0                	callq  *%rax
  8033f0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033f7:	79 16                	jns    80340f <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8033f9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033fc:	89 c7                	mov    %eax,%edi
  8033fe:	48 b8 b9 38 80 00 00 	movabs $0x8038b9,%rax
  803405:	00 00 00 
  803408:	ff d0                	callq  *%rax
		return r;
  80340a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80340d:	eb 3a                	jmp    803449 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  80340f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803413:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  80341a:	00 00 00 
  80341d:	8b 12                	mov    (%rdx),%edx
  80341f:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803421:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803425:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  80342c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803430:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803433:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803436:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80343a:	48 89 c7             	mov    %rax,%rdi
  80343d:	48 b8 51 23 80 00 00 	movabs $0x802351,%rax
  803444:	00 00 00 
  803447:	ff d0                	callq  *%rax
}
  803449:	c9                   	leaveq 
  80344a:	c3                   	retq   

000000000080344b <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80344b:	55                   	push   %rbp
  80344c:	48 89 e5             	mov    %rsp,%rbp
  80344f:	48 83 ec 30          	sub    $0x30,%rsp
  803453:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803456:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80345a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80345e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803461:	89 c7                	mov    %eax,%edi
  803463:	48 b8 55 33 80 00 00 	movabs $0x803355,%rax
  80346a:	00 00 00 
  80346d:	ff d0                	callq  *%rax
  80346f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803472:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803476:	79 05                	jns    80347d <accept+0x32>
		return r;
  803478:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80347b:	eb 3b                	jmp    8034b8 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80347d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803481:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803485:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803488:	48 89 ce             	mov    %rcx,%rsi
  80348b:	89 c7                	mov    %eax,%edi
  80348d:	48 b8 96 37 80 00 00 	movabs $0x803796,%rax
  803494:	00 00 00 
  803497:	ff d0                	callq  *%rax
  803499:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80349c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034a0:	79 05                	jns    8034a7 <accept+0x5c>
		return r;
  8034a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034a5:	eb 11                	jmp    8034b8 <accept+0x6d>
	return alloc_sockfd(r);
  8034a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034aa:	89 c7                	mov    %eax,%edi
  8034ac:	48 b8 ac 33 80 00 00 	movabs $0x8033ac,%rax
  8034b3:	00 00 00 
  8034b6:	ff d0                	callq  *%rax
}
  8034b8:	c9                   	leaveq 
  8034b9:	c3                   	retq   

00000000008034ba <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8034ba:	55                   	push   %rbp
  8034bb:	48 89 e5             	mov    %rsp,%rbp
  8034be:	48 83 ec 20          	sub    $0x20,%rsp
  8034c2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8034c5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8034c9:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8034cc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034cf:	89 c7                	mov    %eax,%edi
  8034d1:	48 b8 55 33 80 00 00 	movabs $0x803355,%rax
  8034d8:	00 00 00 
  8034db:	ff d0                	callq  *%rax
  8034dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034e4:	79 05                	jns    8034eb <bind+0x31>
		return r;
  8034e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034e9:	eb 1b                	jmp    803506 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8034eb:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8034ee:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8034f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034f5:	48 89 ce             	mov    %rcx,%rsi
  8034f8:	89 c7                	mov    %eax,%edi
  8034fa:	48 b8 15 38 80 00 00 	movabs $0x803815,%rax
  803501:	00 00 00 
  803504:	ff d0                	callq  *%rax
}
  803506:	c9                   	leaveq 
  803507:	c3                   	retq   

0000000000803508 <shutdown>:

int
shutdown(int s, int how)
{
  803508:	55                   	push   %rbp
  803509:	48 89 e5             	mov    %rsp,%rbp
  80350c:	48 83 ec 20          	sub    $0x20,%rsp
  803510:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803513:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803516:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803519:	89 c7                	mov    %eax,%edi
  80351b:	48 b8 55 33 80 00 00 	movabs $0x803355,%rax
  803522:	00 00 00 
  803525:	ff d0                	callq  *%rax
  803527:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80352a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80352e:	79 05                	jns    803535 <shutdown+0x2d>
		return r;
  803530:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803533:	eb 16                	jmp    80354b <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803535:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803538:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80353b:	89 d6                	mov    %edx,%esi
  80353d:	89 c7                	mov    %eax,%edi
  80353f:	48 b8 79 38 80 00 00 	movabs $0x803879,%rax
  803546:	00 00 00 
  803549:	ff d0                	callq  *%rax
}
  80354b:	c9                   	leaveq 
  80354c:	c3                   	retq   

000000000080354d <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  80354d:	55                   	push   %rbp
  80354e:	48 89 e5             	mov    %rsp,%rbp
  803551:	48 83 ec 10          	sub    $0x10,%rsp
  803555:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803559:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80355d:	48 89 c7             	mov    %rax,%rdi
  803560:	48 b8 07 47 80 00 00 	movabs $0x804707,%rax
  803567:	00 00 00 
  80356a:	ff d0                	callq  *%rax
  80356c:	83 f8 01             	cmp    $0x1,%eax
  80356f:	75 17                	jne    803588 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803571:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803575:	8b 40 0c             	mov    0xc(%rax),%eax
  803578:	89 c7                	mov    %eax,%edi
  80357a:	48 b8 b9 38 80 00 00 	movabs $0x8038b9,%rax
  803581:	00 00 00 
  803584:	ff d0                	callq  *%rax
  803586:	eb 05                	jmp    80358d <devsock_close+0x40>
	else
		return 0;
  803588:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80358d:	c9                   	leaveq 
  80358e:	c3                   	retq   

000000000080358f <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80358f:	55                   	push   %rbp
  803590:	48 89 e5             	mov    %rsp,%rbp
  803593:	48 83 ec 20          	sub    $0x20,%rsp
  803597:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80359a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80359e:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8035a1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035a4:	89 c7                	mov    %eax,%edi
  8035a6:	48 b8 55 33 80 00 00 	movabs $0x803355,%rax
  8035ad:	00 00 00 
  8035b0:	ff d0                	callq  *%rax
  8035b2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035b9:	79 05                	jns    8035c0 <connect+0x31>
		return r;
  8035bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035be:	eb 1b                	jmp    8035db <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8035c0:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8035c3:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8035c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035ca:	48 89 ce             	mov    %rcx,%rsi
  8035cd:	89 c7                	mov    %eax,%edi
  8035cf:	48 b8 e6 38 80 00 00 	movabs $0x8038e6,%rax
  8035d6:	00 00 00 
  8035d9:	ff d0                	callq  *%rax
}
  8035db:	c9                   	leaveq 
  8035dc:	c3                   	retq   

00000000008035dd <listen>:

int
listen(int s, int backlog)
{
  8035dd:	55                   	push   %rbp
  8035de:	48 89 e5             	mov    %rsp,%rbp
  8035e1:	48 83 ec 20          	sub    $0x20,%rsp
  8035e5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8035e8:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8035eb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035ee:	89 c7                	mov    %eax,%edi
  8035f0:	48 b8 55 33 80 00 00 	movabs $0x803355,%rax
  8035f7:	00 00 00 
  8035fa:	ff d0                	callq  *%rax
  8035fc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803603:	79 05                	jns    80360a <listen+0x2d>
		return r;
  803605:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803608:	eb 16                	jmp    803620 <listen+0x43>
	return nsipc_listen(r, backlog);
  80360a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80360d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803610:	89 d6                	mov    %edx,%esi
  803612:	89 c7                	mov    %eax,%edi
  803614:	48 b8 4a 39 80 00 00 	movabs $0x80394a,%rax
  80361b:	00 00 00 
  80361e:	ff d0                	callq  *%rax
}
  803620:	c9                   	leaveq 
  803621:	c3                   	retq   

0000000000803622 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803622:	55                   	push   %rbp
  803623:	48 89 e5             	mov    %rsp,%rbp
  803626:	48 83 ec 20          	sub    $0x20,%rsp
  80362a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80362e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803632:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803636:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80363a:	89 c2                	mov    %eax,%edx
  80363c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803640:	8b 40 0c             	mov    0xc(%rax),%eax
  803643:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803647:	b9 00 00 00 00       	mov    $0x0,%ecx
  80364c:	89 c7                	mov    %eax,%edi
  80364e:	48 b8 8a 39 80 00 00 	movabs $0x80398a,%rax
  803655:	00 00 00 
  803658:	ff d0                	callq  *%rax
}
  80365a:	c9                   	leaveq 
  80365b:	c3                   	retq   

000000000080365c <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80365c:	55                   	push   %rbp
  80365d:	48 89 e5             	mov    %rsp,%rbp
  803660:	48 83 ec 20          	sub    $0x20,%rsp
  803664:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803668:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80366c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803670:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803674:	89 c2                	mov    %eax,%edx
  803676:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80367a:	8b 40 0c             	mov    0xc(%rax),%eax
  80367d:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803681:	b9 00 00 00 00       	mov    $0x0,%ecx
  803686:	89 c7                	mov    %eax,%edi
  803688:	48 b8 56 3a 80 00 00 	movabs $0x803a56,%rax
  80368f:	00 00 00 
  803692:	ff d0                	callq  *%rax
}
  803694:	c9                   	leaveq 
  803695:	c3                   	retq   

0000000000803696 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803696:	55                   	push   %rbp
  803697:	48 89 e5             	mov    %rsp,%rbp
  80369a:	48 83 ec 10          	sub    $0x10,%rsp
  80369e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8036a2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8036a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036aa:	48 be 38 4f 80 00 00 	movabs $0x804f38,%rsi
  8036b1:	00 00 00 
  8036b4:	48 89 c7             	mov    %rax,%rdi
  8036b7:	48 b8 51 10 80 00 00 	movabs $0x801051,%rax
  8036be:	00 00 00 
  8036c1:	ff d0                	callq  *%rax
	return 0;
  8036c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8036c8:	c9                   	leaveq 
  8036c9:	c3                   	retq   

00000000008036ca <socket>:

int
socket(int domain, int type, int protocol)
{
  8036ca:	55                   	push   %rbp
  8036cb:	48 89 e5             	mov    %rsp,%rbp
  8036ce:	48 83 ec 20          	sub    $0x20,%rsp
  8036d2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8036d5:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8036d8:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8036db:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8036de:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8036e1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036e4:	89 ce                	mov    %ecx,%esi
  8036e6:	89 c7                	mov    %eax,%edi
  8036e8:	48 b8 0e 3b 80 00 00 	movabs $0x803b0e,%rax
  8036ef:	00 00 00 
  8036f2:	ff d0                	callq  *%rax
  8036f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036fb:	79 05                	jns    803702 <socket+0x38>
		return r;
  8036fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803700:	eb 11                	jmp    803713 <socket+0x49>
	return alloc_sockfd(r);
  803702:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803705:	89 c7                	mov    %eax,%edi
  803707:	48 b8 ac 33 80 00 00 	movabs $0x8033ac,%rax
  80370e:	00 00 00 
  803711:	ff d0                	callq  *%rax
}
  803713:	c9                   	leaveq 
  803714:	c3                   	retq   

0000000000803715 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803715:	55                   	push   %rbp
  803716:	48 89 e5             	mov    %rsp,%rbp
  803719:	48 83 ec 10          	sub    $0x10,%rsp
  80371d:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803720:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803727:	00 00 00 
  80372a:	8b 00                	mov    (%rax),%eax
  80372c:	85 c0                	test   %eax,%eax
  80372e:	75 1d                	jne    80374d <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803730:	bf 02 00 00 00       	mov    $0x2,%edi
  803735:	48 b8 85 46 80 00 00 	movabs $0x804685,%rax
  80373c:	00 00 00 
  80373f:	ff d0                	callq  *%rax
  803741:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  803748:	00 00 00 
  80374b:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80374d:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803754:	00 00 00 
  803757:	8b 00                	mov    (%rax),%eax
  803759:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80375c:	b9 07 00 00 00       	mov    $0x7,%ecx
  803761:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  803768:	00 00 00 
  80376b:	89 c7                	mov    %eax,%edi
  80376d:	48 b8 23 46 80 00 00 	movabs $0x804623,%rax
  803774:	00 00 00 
  803777:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803779:	ba 00 00 00 00       	mov    $0x0,%edx
  80377e:	be 00 00 00 00       	mov    $0x0,%esi
  803783:	bf 00 00 00 00       	mov    $0x0,%edi
  803788:	48 b8 1d 45 80 00 00 	movabs $0x80451d,%rax
  80378f:	00 00 00 
  803792:	ff d0                	callq  *%rax
}
  803794:	c9                   	leaveq 
  803795:	c3                   	retq   

0000000000803796 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803796:	55                   	push   %rbp
  803797:	48 89 e5             	mov    %rsp,%rbp
  80379a:	48 83 ec 30          	sub    $0x30,%rsp
  80379e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8037a1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8037a5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8037a9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037b0:	00 00 00 
  8037b3:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8037b6:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8037b8:	bf 01 00 00 00       	mov    $0x1,%edi
  8037bd:	48 b8 15 37 80 00 00 	movabs $0x803715,%rax
  8037c4:	00 00 00 
  8037c7:	ff d0                	callq  *%rax
  8037c9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037d0:	78 3e                	js     803810 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8037d2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037d9:	00 00 00 
  8037dc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8037e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037e4:	8b 40 10             	mov    0x10(%rax),%eax
  8037e7:	89 c2                	mov    %eax,%edx
  8037e9:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8037ed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037f1:	48 89 ce             	mov    %rcx,%rsi
  8037f4:	48 89 c7             	mov    %rax,%rdi
  8037f7:	48 b8 75 13 80 00 00 	movabs $0x801375,%rax
  8037fe:	00 00 00 
  803801:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803803:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803807:	8b 50 10             	mov    0x10(%rax),%edx
  80380a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80380e:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803810:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803813:	c9                   	leaveq 
  803814:	c3                   	retq   

0000000000803815 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803815:	55                   	push   %rbp
  803816:	48 89 e5             	mov    %rsp,%rbp
  803819:	48 83 ec 10          	sub    $0x10,%rsp
  80381d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803820:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803824:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803827:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80382e:	00 00 00 
  803831:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803834:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803836:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803839:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80383d:	48 89 c6             	mov    %rax,%rsi
  803840:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803847:	00 00 00 
  80384a:	48 b8 75 13 80 00 00 	movabs $0x801375,%rax
  803851:	00 00 00 
  803854:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803856:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80385d:	00 00 00 
  803860:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803863:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803866:	bf 02 00 00 00       	mov    $0x2,%edi
  80386b:	48 b8 15 37 80 00 00 	movabs $0x803715,%rax
  803872:	00 00 00 
  803875:	ff d0                	callq  *%rax
}
  803877:	c9                   	leaveq 
  803878:	c3                   	retq   

0000000000803879 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803879:	55                   	push   %rbp
  80387a:	48 89 e5             	mov    %rsp,%rbp
  80387d:	48 83 ec 10          	sub    $0x10,%rsp
  803881:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803884:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803887:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80388e:	00 00 00 
  803891:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803894:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803896:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80389d:	00 00 00 
  8038a0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8038a3:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8038a6:	bf 03 00 00 00       	mov    $0x3,%edi
  8038ab:	48 b8 15 37 80 00 00 	movabs $0x803715,%rax
  8038b2:	00 00 00 
  8038b5:	ff d0                	callq  *%rax
}
  8038b7:	c9                   	leaveq 
  8038b8:	c3                   	retq   

00000000008038b9 <nsipc_close>:

int
nsipc_close(int s)
{
  8038b9:	55                   	push   %rbp
  8038ba:	48 89 e5             	mov    %rsp,%rbp
  8038bd:	48 83 ec 10          	sub    $0x10,%rsp
  8038c1:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8038c4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038cb:	00 00 00 
  8038ce:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8038d1:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8038d3:	bf 04 00 00 00       	mov    $0x4,%edi
  8038d8:	48 b8 15 37 80 00 00 	movabs $0x803715,%rax
  8038df:	00 00 00 
  8038e2:	ff d0                	callq  *%rax
}
  8038e4:	c9                   	leaveq 
  8038e5:	c3                   	retq   

00000000008038e6 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8038e6:	55                   	push   %rbp
  8038e7:	48 89 e5             	mov    %rsp,%rbp
  8038ea:	48 83 ec 10          	sub    $0x10,%rsp
  8038ee:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8038f1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8038f5:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8038f8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038ff:	00 00 00 
  803902:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803905:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803907:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80390a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80390e:	48 89 c6             	mov    %rax,%rsi
  803911:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803918:	00 00 00 
  80391b:	48 b8 75 13 80 00 00 	movabs $0x801375,%rax
  803922:	00 00 00 
  803925:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803927:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80392e:	00 00 00 
  803931:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803934:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803937:	bf 05 00 00 00       	mov    $0x5,%edi
  80393c:	48 b8 15 37 80 00 00 	movabs $0x803715,%rax
  803943:	00 00 00 
  803946:	ff d0                	callq  *%rax
}
  803948:	c9                   	leaveq 
  803949:	c3                   	retq   

000000000080394a <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80394a:	55                   	push   %rbp
  80394b:	48 89 e5             	mov    %rsp,%rbp
  80394e:	48 83 ec 10          	sub    $0x10,%rsp
  803952:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803955:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803958:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80395f:	00 00 00 
  803962:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803965:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803967:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80396e:	00 00 00 
  803971:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803974:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803977:	bf 06 00 00 00       	mov    $0x6,%edi
  80397c:	48 b8 15 37 80 00 00 	movabs $0x803715,%rax
  803983:	00 00 00 
  803986:	ff d0                	callq  *%rax
}
  803988:	c9                   	leaveq 
  803989:	c3                   	retq   

000000000080398a <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80398a:	55                   	push   %rbp
  80398b:	48 89 e5             	mov    %rsp,%rbp
  80398e:	48 83 ec 30          	sub    $0x30,%rsp
  803992:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803995:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803999:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80399c:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  80399f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039a6:	00 00 00 
  8039a9:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8039ac:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8039ae:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039b5:	00 00 00 
  8039b8:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8039bb:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8039be:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039c5:	00 00 00 
  8039c8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8039cb:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8039ce:	bf 07 00 00 00       	mov    $0x7,%edi
  8039d3:	48 b8 15 37 80 00 00 	movabs $0x803715,%rax
  8039da:	00 00 00 
  8039dd:	ff d0                	callq  *%rax
  8039df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039e6:	78 69                	js     803a51 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8039e8:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8039ef:	7f 08                	jg     8039f9 <nsipc_recv+0x6f>
  8039f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039f4:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8039f7:	7e 35                	jle    803a2e <nsipc_recv+0xa4>
  8039f9:	48 b9 3f 4f 80 00 00 	movabs $0x804f3f,%rcx
  803a00:	00 00 00 
  803a03:	48 ba 54 4f 80 00 00 	movabs $0x804f54,%rdx
  803a0a:	00 00 00 
  803a0d:	be 61 00 00 00       	mov    $0x61,%esi
  803a12:	48 bf 69 4f 80 00 00 	movabs $0x804f69,%rdi
  803a19:	00 00 00 
  803a1c:	b8 00 00 00 00       	mov    $0x0,%eax
  803a21:	49 b8 63 02 80 00 00 	movabs $0x800263,%r8
  803a28:	00 00 00 
  803a2b:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803a2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a31:	48 63 d0             	movslq %eax,%rdx
  803a34:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a38:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803a3f:	00 00 00 
  803a42:	48 89 c7             	mov    %rax,%rdi
  803a45:	48 b8 75 13 80 00 00 	movabs $0x801375,%rax
  803a4c:	00 00 00 
  803a4f:	ff d0                	callq  *%rax
	}

	return r;
  803a51:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803a54:	c9                   	leaveq 
  803a55:	c3                   	retq   

0000000000803a56 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803a56:	55                   	push   %rbp
  803a57:	48 89 e5             	mov    %rsp,%rbp
  803a5a:	48 83 ec 20          	sub    $0x20,%rsp
  803a5e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a61:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803a65:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803a68:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803a6b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a72:	00 00 00 
  803a75:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a78:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803a7a:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803a81:	7e 35                	jle    803ab8 <nsipc_send+0x62>
  803a83:	48 b9 75 4f 80 00 00 	movabs $0x804f75,%rcx
  803a8a:	00 00 00 
  803a8d:	48 ba 54 4f 80 00 00 	movabs $0x804f54,%rdx
  803a94:	00 00 00 
  803a97:	be 6c 00 00 00       	mov    $0x6c,%esi
  803a9c:	48 bf 69 4f 80 00 00 	movabs $0x804f69,%rdi
  803aa3:	00 00 00 
  803aa6:	b8 00 00 00 00       	mov    $0x0,%eax
  803aab:	49 b8 63 02 80 00 00 	movabs $0x800263,%r8
  803ab2:	00 00 00 
  803ab5:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803ab8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803abb:	48 63 d0             	movslq %eax,%rdx
  803abe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ac2:	48 89 c6             	mov    %rax,%rsi
  803ac5:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803acc:	00 00 00 
  803acf:	48 b8 75 13 80 00 00 	movabs $0x801375,%rax
  803ad6:	00 00 00 
  803ad9:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803adb:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803ae2:	00 00 00 
  803ae5:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803ae8:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803aeb:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803af2:	00 00 00 
  803af5:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803af8:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803afb:	bf 08 00 00 00       	mov    $0x8,%edi
  803b00:	48 b8 15 37 80 00 00 	movabs $0x803715,%rax
  803b07:	00 00 00 
  803b0a:	ff d0                	callq  *%rax
}
  803b0c:	c9                   	leaveq 
  803b0d:	c3                   	retq   

0000000000803b0e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803b0e:	55                   	push   %rbp
  803b0f:	48 89 e5             	mov    %rsp,%rbp
  803b12:	48 83 ec 10          	sub    $0x10,%rsp
  803b16:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803b19:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803b1c:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803b1f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b26:	00 00 00 
  803b29:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b2c:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803b2e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b35:	00 00 00 
  803b38:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b3b:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803b3e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b45:	00 00 00 
  803b48:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803b4b:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803b4e:	bf 09 00 00 00       	mov    $0x9,%edi
  803b53:	48 b8 15 37 80 00 00 	movabs $0x803715,%rax
  803b5a:	00 00 00 
  803b5d:	ff d0                	callq  *%rax
}
  803b5f:	c9                   	leaveq 
  803b60:	c3                   	retq   

0000000000803b61 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803b61:	55                   	push   %rbp
  803b62:	48 89 e5             	mov    %rsp,%rbp
  803b65:	53                   	push   %rbx
  803b66:	48 83 ec 38          	sub    $0x38,%rsp
  803b6a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803b6e:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803b72:	48 89 c7             	mov    %rax,%rdi
  803b75:	48 b8 9f 23 80 00 00 	movabs $0x80239f,%rax
  803b7c:	00 00 00 
  803b7f:	ff d0                	callq  *%rax
  803b81:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b84:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b88:	0f 88 bf 01 00 00    	js     803d4d <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803b8e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b92:	ba 07 04 00 00       	mov    $0x407,%edx
  803b97:	48 89 c6             	mov    %rax,%rsi
  803b9a:	bf 00 00 00 00       	mov    $0x0,%edi
  803b9f:	48 b8 80 19 80 00 00 	movabs $0x801980,%rax
  803ba6:	00 00 00 
  803ba9:	ff d0                	callq  *%rax
  803bab:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803bae:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803bb2:	0f 88 95 01 00 00    	js     803d4d <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803bb8:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803bbc:	48 89 c7             	mov    %rax,%rdi
  803bbf:	48 b8 9f 23 80 00 00 	movabs $0x80239f,%rax
  803bc6:	00 00 00 
  803bc9:	ff d0                	callq  *%rax
  803bcb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803bce:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803bd2:	0f 88 5d 01 00 00    	js     803d35 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803bd8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bdc:	ba 07 04 00 00       	mov    $0x407,%edx
  803be1:	48 89 c6             	mov    %rax,%rsi
  803be4:	bf 00 00 00 00       	mov    $0x0,%edi
  803be9:	48 b8 80 19 80 00 00 	movabs $0x801980,%rax
  803bf0:	00 00 00 
  803bf3:	ff d0                	callq  *%rax
  803bf5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803bf8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803bfc:	0f 88 33 01 00 00    	js     803d35 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803c02:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c06:	48 89 c7             	mov    %rax,%rdi
  803c09:	48 b8 74 23 80 00 00 	movabs $0x802374,%rax
  803c10:	00 00 00 
  803c13:	ff d0                	callq  *%rax
  803c15:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803c19:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c1d:	ba 07 04 00 00       	mov    $0x407,%edx
  803c22:	48 89 c6             	mov    %rax,%rsi
  803c25:	bf 00 00 00 00       	mov    $0x0,%edi
  803c2a:	48 b8 80 19 80 00 00 	movabs $0x801980,%rax
  803c31:	00 00 00 
  803c34:	ff d0                	callq  *%rax
  803c36:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c39:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c3d:	79 05                	jns    803c44 <pipe+0xe3>
		goto err2;
  803c3f:	e9 d9 00 00 00       	jmpq   803d1d <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803c44:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c48:	48 89 c7             	mov    %rax,%rdi
  803c4b:	48 b8 74 23 80 00 00 	movabs $0x802374,%rax
  803c52:	00 00 00 
  803c55:	ff d0                	callq  *%rax
  803c57:	48 89 c2             	mov    %rax,%rdx
  803c5a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c5e:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803c64:	48 89 d1             	mov    %rdx,%rcx
  803c67:	ba 00 00 00 00       	mov    $0x0,%edx
  803c6c:	48 89 c6             	mov    %rax,%rsi
  803c6f:	bf 00 00 00 00       	mov    $0x0,%edi
  803c74:	48 b8 d0 19 80 00 00 	movabs $0x8019d0,%rax
  803c7b:	00 00 00 
  803c7e:	ff d0                	callq  *%rax
  803c80:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c83:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c87:	79 1b                	jns    803ca4 <pipe+0x143>
		goto err3;
  803c89:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803c8a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c8e:	48 89 c6             	mov    %rax,%rsi
  803c91:	bf 00 00 00 00       	mov    $0x0,%edi
  803c96:	48 b8 2b 1a 80 00 00 	movabs $0x801a2b,%rax
  803c9d:	00 00 00 
  803ca0:	ff d0                	callq  *%rax
  803ca2:	eb 79                	jmp    803d1d <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803ca4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ca8:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803caf:	00 00 00 
  803cb2:	8b 12                	mov    (%rdx),%edx
  803cb4:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803cb6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cba:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803cc1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803cc5:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803ccc:	00 00 00 
  803ccf:	8b 12                	mov    (%rdx),%edx
  803cd1:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803cd3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803cd7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803cde:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ce2:	48 89 c7             	mov    %rax,%rdi
  803ce5:	48 b8 51 23 80 00 00 	movabs $0x802351,%rax
  803cec:	00 00 00 
  803cef:	ff d0                	callq  *%rax
  803cf1:	89 c2                	mov    %eax,%edx
  803cf3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803cf7:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803cf9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803cfd:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803d01:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d05:	48 89 c7             	mov    %rax,%rdi
  803d08:	48 b8 51 23 80 00 00 	movabs $0x802351,%rax
  803d0f:	00 00 00 
  803d12:	ff d0                	callq  *%rax
  803d14:	89 03                	mov    %eax,(%rbx)
	return 0;
  803d16:	b8 00 00 00 00       	mov    $0x0,%eax
  803d1b:	eb 33                	jmp    803d50 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803d1d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d21:	48 89 c6             	mov    %rax,%rsi
  803d24:	bf 00 00 00 00       	mov    $0x0,%edi
  803d29:	48 b8 2b 1a 80 00 00 	movabs $0x801a2b,%rax
  803d30:	00 00 00 
  803d33:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803d35:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d39:	48 89 c6             	mov    %rax,%rsi
  803d3c:	bf 00 00 00 00       	mov    $0x0,%edi
  803d41:	48 b8 2b 1a 80 00 00 	movabs $0x801a2b,%rax
  803d48:	00 00 00 
  803d4b:	ff d0                	callq  *%rax
err:
	return r;
  803d4d:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803d50:	48 83 c4 38          	add    $0x38,%rsp
  803d54:	5b                   	pop    %rbx
  803d55:	5d                   	pop    %rbp
  803d56:	c3                   	retq   

0000000000803d57 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803d57:	55                   	push   %rbp
  803d58:	48 89 e5             	mov    %rsp,%rbp
  803d5b:	53                   	push   %rbx
  803d5c:	48 83 ec 28          	sub    $0x28,%rsp
  803d60:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803d64:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803d68:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  803d6f:	00 00 00 
  803d72:	48 8b 00             	mov    (%rax),%rax
  803d75:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803d7b:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803d7e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d82:	48 89 c7             	mov    %rax,%rdi
  803d85:	48 b8 07 47 80 00 00 	movabs $0x804707,%rax
  803d8c:	00 00 00 
  803d8f:	ff d0                	callq  *%rax
  803d91:	89 c3                	mov    %eax,%ebx
  803d93:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d97:	48 89 c7             	mov    %rax,%rdi
  803d9a:	48 b8 07 47 80 00 00 	movabs $0x804707,%rax
  803da1:	00 00 00 
  803da4:	ff d0                	callq  *%rax
  803da6:	39 c3                	cmp    %eax,%ebx
  803da8:	0f 94 c0             	sete   %al
  803dab:	0f b6 c0             	movzbl %al,%eax
  803dae:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803db1:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  803db8:	00 00 00 
  803dbb:	48 8b 00             	mov    (%rax),%rax
  803dbe:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803dc4:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803dc7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803dca:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803dcd:	75 05                	jne    803dd4 <_pipeisclosed+0x7d>
			return ret;
  803dcf:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803dd2:	eb 4f                	jmp    803e23 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803dd4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803dd7:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803dda:	74 42                	je     803e1e <_pipeisclosed+0xc7>
  803ddc:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803de0:	75 3c                	jne    803e1e <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803de2:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  803de9:	00 00 00 
  803dec:	48 8b 00             	mov    (%rax),%rax
  803def:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803df5:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803df8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803dfb:	89 c6                	mov    %eax,%esi
  803dfd:	48 bf 86 4f 80 00 00 	movabs $0x804f86,%rdi
  803e04:	00 00 00 
  803e07:	b8 00 00 00 00       	mov    $0x0,%eax
  803e0c:	49 b8 9c 04 80 00 00 	movabs $0x80049c,%r8
  803e13:	00 00 00 
  803e16:	41 ff d0             	callq  *%r8
	}
  803e19:	e9 4a ff ff ff       	jmpq   803d68 <_pipeisclosed+0x11>
  803e1e:	e9 45 ff ff ff       	jmpq   803d68 <_pipeisclosed+0x11>
}
  803e23:	48 83 c4 28          	add    $0x28,%rsp
  803e27:	5b                   	pop    %rbx
  803e28:	5d                   	pop    %rbp
  803e29:	c3                   	retq   

0000000000803e2a <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803e2a:	55                   	push   %rbp
  803e2b:	48 89 e5             	mov    %rsp,%rbp
  803e2e:	48 83 ec 30          	sub    $0x30,%rsp
  803e32:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803e35:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803e39:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803e3c:	48 89 d6             	mov    %rdx,%rsi
  803e3f:	89 c7                	mov    %eax,%edi
  803e41:	48 b8 37 24 80 00 00 	movabs $0x802437,%rax
  803e48:	00 00 00 
  803e4b:	ff d0                	callq  *%rax
  803e4d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e50:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e54:	79 05                	jns    803e5b <pipeisclosed+0x31>
		return r;
  803e56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e59:	eb 31                	jmp    803e8c <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803e5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e5f:	48 89 c7             	mov    %rax,%rdi
  803e62:	48 b8 74 23 80 00 00 	movabs $0x802374,%rax
  803e69:	00 00 00 
  803e6c:	ff d0                	callq  *%rax
  803e6e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803e72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e76:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e7a:	48 89 d6             	mov    %rdx,%rsi
  803e7d:	48 89 c7             	mov    %rax,%rdi
  803e80:	48 b8 57 3d 80 00 00 	movabs $0x803d57,%rax
  803e87:	00 00 00 
  803e8a:	ff d0                	callq  *%rax
}
  803e8c:	c9                   	leaveq 
  803e8d:	c3                   	retq   

0000000000803e8e <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803e8e:	55                   	push   %rbp
  803e8f:	48 89 e5             	mov    %rsp,%rbp
  803e92:	48 83 ec 40          	sub    $0x40,%rsp
  803e96:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803e9a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803e9e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803ea2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ea6:	48 89 c7             	mov    %rax,%rdi
  803ea9:	48 b8 74 23 80 00 00 	movabs $0x802374,%rax
  803eb0:	00 00 00 
  803eb3:	ff d0                	callq  *%rax
  803eb5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803eb9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ebd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803ec1:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803ec8:	00 
  803ec9:	e9 92 00 00 00       	jmpq   803f60 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803ece:	eb 41                	jmp    803f11 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803ed0:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803ed5:	74 09                	je     803ee0 <devpipe_read+0x52>
				return i;
  803ed7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803edb:	e9 92 00 00 00       	jmpq   803f72 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803ee0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ee4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ee8:	48 89 d6             	mov    %rdx,%rsi
  803eeb:	48 89 c7             	mov    %rax,%rdi
  803eee:	48 b8 57 3d 80 00 00 	movabs $0x803d57,%rax
  803ef5:	00 00 00 
  803ef8:	ff d0                	callq  *%rax
  803efa:	85 c0                	test   %eax,%eax
  803efc:	74 07                	je     803f05 <devpipe_read+0x77>
				return 0;
  803efe:	b8 00 00 00 00       	mov    $0x0,%eax
  803f03:	eb 6d                	jmp    803f72 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803f05:	48 b8 42 19 80 00 00 	movabs $0x801942,%rax
  803f0c:	00 00 00 
  803f0f:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803f11:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f15:	8b 10                	mov    (%rax),%edx
  803f17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f1b:	8b 40 04             	mov    0x4(%rax),%eax
  803f1e:	39 c2                	cmp    %eax,%edx
  803f20:	74 ae                	je     803ed0 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803f22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f26:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803f2a:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803f2e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f32:	8b 00                	mov    (%rax),%eax
  803f34:	99                   	cltd   
  803f35:	c1 ea 1b             	shr    $0x1b,%edx
  803f38:	01 d0                	add    %edx,%eax
  803f3a:	83 e0 1f             	and    $0x1f,%eax
  803f3d:	29 d0                	sub    %edx,%eax
  803f3f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803f43:	48 98                	cltq   
  803f45:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803f4a:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803f4c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f50:	8b 00                	mov    (%rax),%eax
  803f52:	8d 50 01             	lea    0x1(%rax),%edx
  803f55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f59:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803f5b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803f60:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f64:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803f68:	0f 82 60 ff ff ff    	jb     803ece <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803f6e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803f72:	c9                   	leaveq 
  803f73:	c3                   	retq   

0000000000803f74 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803f74:	55                   	push   %rbp
  803f75:	48 89 e5             	mov    %rsp,%rbp
  803f78:	48 83 ec 40          	sub    $0x40,%rsp
  803f7c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803f80:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803f84:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803f88:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f8c:	48 89 c7             	mov    %rax,%rdi
  803f8f:	48 b8 74 23 80 00 00 	movabs $0x802374,%rax
  803f96:	00 00 00 
  803f99:	ff d0                	callq  *%rax
  803f9b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803f9f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803fa3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803fa7:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803fae:	00 
  803faf:	e9 8e 00 00 00       	jmpq   804042 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803fb4:	eb 31                	jmp    803fe7 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803fb6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803fba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fbe:	48 89 d6             	mov    %rdx,%rsi
  803fc1:	48 89 c7             	mov    %rax,%rdi
  803fc4:	48 b8 57 3d 80 00 00 	movabs $0x803d57,%rax
  803fcb:	00 00 00 
  803fce:	ff d0                	callq  *%rax
  803fd0:	85 c0                	test   %eax,%eax
  803fd2:	74 07                	je     803fdb <devpipe_write+0x67>
				return 0;
  803fd4:	b8 00 00 00 00       	mov    $0x0,%eax
  803fd9:	eb 79                	jmp    804054 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803fdb:	48 b8 42 19 80 00 00 	movabs $0x801942,%rax
  803fe2:	00 00 00 
  803fe5:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803fe7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803feb:	8b 40 04             	mov    0x4(%rax),%eax
  803fee:	48 63 d0             	movslq %eax,%rdx
  803ff1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ff5:	8b 00                	mov    (%rax),%eax
  803ff7:	48 98                	cltq   
  803ff9:	48 83 c0 20          	add    $0x20,%rax
  803ffd:	48 39 c2             	cmp    %rax,%rdx
  804000:	73 b4                	jae    803fb6 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804002:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804006:	8b 40 04             	mov    0x4(%rax),%eax
  804009:	99                   	cltd   
  80400a:	c1 ea 1b             	shr    $0x1b,%edx
  80400d:	01 d0                	add    %edx,%eax
  80400f:	83 e0 1f             	and    $0x1f,%eax
  804012:	29 d0                	sub    %edx,%eax
  804014:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804018:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80401c:	48 01 ca             	add    %rcx,%rdx
  80401f:	0f b6 0a             	movzbl (%rdx),%ecx
  804022:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804026:	48 98                	cltq   
  804028:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80402c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804030:	8b 40 04             	mov    0x4(%rax),%eax
  804033:	8d 50 01             	lea    0x1(%rax),%edx
  804036:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80403a:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80403d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804042:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804046:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80404a:	0f 82 64 ff ff ff    	jb     803fb4 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804050:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804054:	c9                   	leaveq 
  804055:	c3                   	retq   

0000000000804056 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804056:	55                   	push   %rbp
  804057:	48 89 e5             	mov    %rsp,%rbp
  80405a:	48 83 ec 20          	sub    $0x20,%rsp
  80405e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804062:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804066:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80406a:	48 89 c7             	mov    %rax,%rdi
  80406d:	48 b8 74 23 80 00 00 	movabs $0x802374,%rax
  804074:	00 00 00 
  804077:	ff d0                	callq  *%rax
  804079:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80407d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804081:	48 be 99 4f 80 00 00 	movabs $0x804f99,%rsi
  804088:	00 00 00 
  80408b:	48 89 c7             	mov    %rax,%rdi
  80408e:	48 b8 51 10 80 00 00 	movabs $0x801051,%rax
  804095:	00 00 00 
  804098:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80409a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80409e:	8b 50 04             	mov    0x4(%rax),%edx
  8040a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040a5:	8b 00                	mov    (%rax),%eax
  8040a7:	29 c2                	sub    %eax,%edx
  8040a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040ad:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8040b3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040b7:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8040be:	00 00 00 
	stat->st_dev = &devpipe;
  8040c1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040c5:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  8040cc:	00 00 00 
  8040cf:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8040d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8040db:	c9                   	leaveq 
  8040dc:	c3                   	retq   

00000000008040dd <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8040dd:	55                   	push   %rbp
  8040de:	48 89 e5             	mov    %rsp,%rbp
  8040e1:	48 83 ec 10          	sub    $0x10,%rsp
  8040e5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8040e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040ed:	48 89 c6             	mov    %rax,%rsi
  8040f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8040f5:	48 b8 2b 1a 80 00 00 	movabs $0x801a2b,%rax
  8040fc:	00 00 00 
  8040ff:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  804101:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804105:	48 89 c7             	mov    %rax,%rdi
  804108:	48 b8 74 23 80 00 00 	movabs $0x802374,%rax
  80410f:	00 00 00 
  804112:	ff d0                	callq  *%rax
  804114:	48 89 c6             	mov    %rax,%rsi
  804117:	bf 00 00 00 00       	mov    $0x0,%edi
  80411c:	48 b8 2b 1a 80 00 00 	movabs $0x801a2b,%rax
  804123:	00 00 00 
  804126:	ff d0                	callq  *%rax
}
  804128:	c9                   	leaveq 
  804129:	c3                   	retq   

000000000080412a <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80412a:	55                   	push   %rbp
  80412b:	48 89 e5             	mov    %rsp,%rbp
  80412e:	48 83 ec 20          	sub    $0x20,%rsp
  804132:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804135:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804138:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80413b:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80413f:	be 01 00 00 00       	mov    $0x1,%esi
  804144:	48 89 c7             	mov    %rax,%rdi
  804147:	48 b8 38 18 80 00 00 	movabs $0x801838,%rax
  80414e:	00 00 00 
  804151:	ff d0                	callq  *%rax
}
  804153:	c9                   	leaveq 
  804154:	c3                   	retq   

0000000000804155 <getchar>:

int
getchar(void)
{
  804155:	55                   	push   %rbp
  804156:	48 89 e5             	mov    %rsp,%rbp
  804159:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80415d:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804161:	ba 01 00 00 00       	mov    $0x1,%edx
  804166:	48 89 c6             	mov    %rax,%rsi
  804169:	bf 00 00 00 00       	mov    $0x0,%edi
  80416e:	48 b8 69 28 80 00 00 	movabs $0x802869,%rax
  804175:	00 00 00 
  804178:	ff d0                	callq  *%rax
  80417a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80417d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804181:	79 05                	jns    804188 <getchar+0x33>
		return r;
  804183:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804186:	eb 14                	jmp    80419c <getchar+0x47>
	if (r < 1)
  804188:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80418c:	7f 07                	jg     804195 <getchar+0x40>
		return -E_EOF;
  80418e:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804193:	eb 07                	jmp    80419c <getchar+0x47>
	return c;
  804195:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804199:	0f b6 c0             	movzbl %al,%eax
}
  80419c:	c9                   	leaveq 
  80419d:	c3                   	retq   

000000000080419e <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80419e:	55                   	push   %rbp
  80419f:	48 89 e5             	mov    %rsp,%rbp
  8041a2:	48 83 ec 20          	sub    $0x20,%rsp
  8041a6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8041a9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8041ad:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8041b0:	48 89 d6             	mov    %rdx,%rsi
  8041b3:	89 c7                	mov    %eax,%edi
  8041b5:	48 b8 37 24 80 00 00 	movabs $0x802437,%rax
  8041bc:	00 00 00 
  8041bf:	ff d0                	callq  *%rax
  8041c1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8041c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041c8:	79 05                	jns    8041cf <iscons+0x31>
		return r;
  8041ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041cd:	eb 1a                	jmp    8041e9 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8041cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041d3:	8b 10                	mov    (%rax),%edx
  8041d5:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  8041dc:	00 00 00 
  8041df:	8b 00                	mov    (%rax),%eax
  8041e1:	39 c2                	cmp    %eax,%edx
  8041e3:	0f 94 c0             	sete   %al
  8041e6:	0f b6 c0             	movzbl %al,%eax
}
  8041e9:	c9                   	leaveq 
  8041ea:	c3                   	retq   

00000000008041eb <opencons>:

int
opencons(void)
{
  8041eb:	55                   	push   %rbp
  8041ec:	48 89 e5             	mov    %rsp,%rbp
  8041ef:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8041f3:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8041f7:	48 89 c7             	mov    %rax,%rdi
  8041fa:	48 b8 9f 23 80 00 00 	movabs $0x80239f,%rax
  804201:	00 00 00 
  804204:	ff d0                	callq  *%rax
  804206:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804209:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80420d:	79 05                	jns    804214 <opencons+0x29>
		return r;
  80420f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804212:	eb 5b                	jmp    80426f <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804214:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804218:	ba 07 04 00 00       	mov    $0x407,%edx
  80421d:	48 89 c6             	mov    %rax,%rsi
  804220:	bf 00 00 00 00       	mov    $0x0,%edi
  804225:	48 b8 80 19 80 00 00 	movabs $0x801980,%rax
  80422c:	00 00 00 
  80422f:	ff d0                	callq  *%rax
  804231:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804234:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804238:	79 05                	jns    80423f <opencons+0x54>
		return r;
  80423a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80423d:	eb 30                	jmp    80426f <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80423f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804243:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  80424a:	00 00 00 
  80424d:	8b 12                	mov    (%rdx),%edx
  80424f:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804251:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804255:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80425c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804260:	48 89 c7             	mov    %rax,%rdi
  804263:	48 b8 51 23 80 00 00 	movabs $0x802351,%rax
  80426a:	00 00 00 
  80426d:	ff d0                	callq  *%rax
}
  80426f:	c9                   	leaveq 
  804270:	c3                   	retq   

0000000000804271 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804271:	55                   	push   %rbp
  804272:	48 89 e5             	mov    %rsp,%rbp
  804275:	48 83 ec 30          	sub    $0x30,%rsp
  804279:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80427d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804281:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804285:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80428a:	75 07                	jne    804293 <devcons_read+0x22>
		return 0;
  80428c:	b8 00 00 00 00       	mov    $0x0,%eax
  804291:	eb 4b                	jmp    8042de <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  804293:	eb 0c                	jmp    8042a1 <devcons_read+0x30>
		sys_yield();
  804295:	48 b8 42 19 80 00 00 	movabs $0x801942,%rax
  80429c:	00 00 00 
  80429f:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8042a1:	48 b8 82 18 80 00 00 	movabs $0x801882,%rax
  8042a8:	00 00 00 
  8042ab:	ff d0                	callq  *%rax
  8042ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8042b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042b4:	74 df                	je     804295 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8042b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042ba:	79 05                	jns    8042c1 <devcons_read+0x50>
		return c;
  8042bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042bf:	eb 1d                	jmp    8042de <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8042c1:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8042c5:	75 07                	jne    8042ce <devcons_read+0x5d>
		return 0;
  8042c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8042cc:	eb 10                	jmp    8042de <devcons_read+0x6d>
	*(char*)vbuf = c;
  8042ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042d1:	89 c2                	mov    %eax,%edx
  8042d3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8042d7:	88 10                	mov    %dl,(%rax)
	return 1;
  8042d9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8042de:	c9                   	leaveq 
  8042df:	c3                   	retq   

00000000008042e0 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8042e0:	55                   	push   %rbp
  8042e1:	48 89 e5             	mov    %rsp,%rbp
  8042e4:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8042eb:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8042f2:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8042f9:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804300:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804307:	eb 76                	jmp    80437f <devcons_write+0x9f>
		m = n - tot;
  804309:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804310:	89 c2                	mov    %eax,%edx
  804312:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804315:	29 c2                	sub    %eax,%edx
  804317:	89 d0                	mov    %edx,%eax
  804319:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80431c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80431f:	83 f8 7f             	cmp    $0x7f,%eax
  804322:	76 07                	jbe    80432b <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804324:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80432b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80432e:	48 63 d0             	movslq %eax,%rdx
  804331:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804334:	48 63 c8             	movslq %eax,%rcx
  804337:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80433e:	48 01 c1             	add    %rax,%rcx
  804341:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804348:	48 89 ce             	mov    %rcx,%rsi
  80434b:	48 89 c7             	mov    %rax,%rdi
  80434e:	48 b8 75 13 80 00 00 	movabs $0x801375,%rax
  804355:	00 00 00 
  804358:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80435a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80435d:	48 63 d0             	movslq %eax,%rdx
  804360:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804367:	48 89 d6             	mov    %rdx,%rsi
  80436a:	48 89 c7             	mov    %rax,%rdi
  80436d:	48 b8 38 18 80 00 00 	movabs $0x801838,%rax
  804374:	00 00 00 
  804377:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804379:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80437c:	01 45 fc             	add    %eax,-0x4(%rbp)
  80437f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804382:	48 98                	cltq   
  804384:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80438b:	0f 82 78 ff ff ff    	jb     804309 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804391:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804394:	c9                   	leaveq 
  804395:	c3                   	retq   

0000000000804396 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804396:	55                   	push   %rbp
  804397:	48 89 e5             	mov    %rsp,%rbp
  80439a:	48 83 ec 08          	sub    $0x8,%rsp
  80439e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8043a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8043a7:	c9                   	leaveq 
  8043a8:	c3                   	retq   

00000000008043a9 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8043a9:	55                   	push   %rbp
  8043aa:	48 89 e5             	mov    %rsp,%rbp
  8043ad:	48 83 ec 10          	sub    $0x10,%rsp
  8043b1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8043b5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8043b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043bd:	48 be a5 4f 80 00 00 	movabs $0x804fa5,%rsi
  8043c4:	00 00 00 
  8043c7:	48 89 c7             	mov    %rax,%rdi
  8043ca:	48 b8 51 10 80 00 00 	movabs $0x801051,%rax
  8043d1:	00 00 00 
  8043d4:	ff d0                	callq  *%rax
	return 0;
  8043d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8043db:	c9                   	leaveq 
  8043dc:	c3                   	retq   

00000000008043dd <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8043dd:	55                   	push   %rbp
  8043de:	48 89 e5             	mov    %rsp,%rbp
  8043e1:	48 83 ec 10          	sub    $0x10,%rsp
  8043e5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  8043e9:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8043f0:	00 00 00 
  8043f3:	48 8b 00             	mov    (%rax),%rax
  8043f6:	48 85 c0             	test   %rax,%rax
  8043f9:	0f 85 84 00 00 00    	jne    804483 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  8043ff:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  804406:	00 00 00 
  804409:	48 8b 00             	mov    (%rax),%rax
  80440c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804412:	ba 07 00 00 00       	mov    $0x7,%edx
  804417:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80441c:	89 c7                	mov    %eax,%edi
  80441e:	48 b8 80 19 80 00 00 	movabs $0x801980,%rax
  804425:	00 00 00 
  804428:	ff d0                	callq  *%rax
  80442a:	85 c0                	test   %eax,%eax
  80442c:	79 2a                	jns    804458 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  80442e:	48 ba b0 4f 80 00 00 	movabs $0x804fb0,%rdx
  804435:	00 00 00 
  804438:	be 23 00 00 00       	mov    $0x23,%esi
  80443d:	48 bf d7 4f 80 00 00 	movabs $0x804fd7,%rdi
  804444:	00 00 00 
  804447:	b8 00 00 00 00       	mov    $0x0,%eax
  80444c:	48 b9 63 02 80 00 00 	movabs $0x800263,%rcx
  804453:	00 00 00 
  804456:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  804458:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  80445f:	00 00 00 
  804462:	48 8b 00             	mov    (%rax),%rax
  804465:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80446b:	48 be 96 44 80 00 00 	movabs $0x804496,%rsi
  804472:	00 00 00 
  804475:	89 c7                	mov    %eax,%edi
  804477:	48 b8 0a 1b 80 00 00 	movabs $0x801b0a,%rax
  80447e:	00 00 00 
  804481:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  804483:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80448a:	00 00 00 
  80448d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804491:	48 89 10             	mov    %rdx,(%rax)
}
  804494:	c9                   	leaveq 
  804495:	c3                   	retq   

0000000000804496 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  804496:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  804499:	48 a1 00 b0 80 00 00 	movabs 0x80b000,%rax
  8044a0:	00 00 00 
call *%rax
  8044a3:	ff d0                	callq  *%rax
    // LAB 4: Your code here.

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.

	movq 136(%rsp), %rbx  //Load RIP 
  8044a5:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8044ac:	00 
	movq 152(%rsp), %rcx  //Load RSP
  8044ad:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  8044b4:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  8044b5:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  8044b9:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  8044bc:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  8044c3:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  8044c4:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  8044c8:	4c 8b 3c 24          	mov    (%rsp),%r15
  8044cc:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8044d1:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8044d6:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8044db:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8044e0:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8044e5:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8044ea:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8044ef:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8044f4:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8044f9:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8044fe:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804503:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804508:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  80450d:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804512:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  804516:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  80451a:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  80451b:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  80451c:	c3                   	retq   

000000000080451d <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80451d:	55                   	push   %rbp
  80451e:	48 89 e5             	mov    %rsp,%rbp
  804521:	48 83 ec 30          	sub    $0x30,%rsp
  804525:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804529:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80452d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  804531:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  804538:	00 00 00 
  80453b:	48 8b 00             	mov    (%rax),%rax
  80453e:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  804544:	85 c0                	test   %eax,%eax
  804546:	75 3c                	jne    804584 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  804548:	48 b8 04 19 80 00 00 	movabs $0x801904,%rax
  80454f:	00 00 00 
  804552:	ff d0                	callq  *%rax
  804554:	25 ff 03 00 00       	and    $0x3ff,%eax
  804559:	48 63 d0             	movslq %eax,%rdx
  80455c:	48 89 d0             	mov    %rdx,%rax
  80455f:	48 c1 e0 03          	shl    $0x3,%rax
  804563:	48 01 d0             	add    %rdx,%rax
  804566:	48 c1 e0 05          	shl    $0x5,%rax
  80456a:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804571:	00 00 00 
  804574:	48 01 c2             	add    %rax,%rdx
  804577:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  80457e:	00 00 00 
  804581:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  804584:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804589:	75 0e                	jne    804599 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  80458b:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804592:	00 00 00 
  804595:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  804599:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80459d:	48 89 c7             	mov    %rax,%rdi
  8045a0:	48 b8 a9 1b 80 00 00 	movabs $0x801ba9,%rax
  8045a7:	00 00 00 
  8045aa:	ff d0                	callq  *%rax
  8045ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  8045af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045b3:	79 19                	jns    8045ce <ipc_recv+0xb1>
		*from_env_store = 0;
  8045b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8045b9:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  8045bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045c3:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  8045c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045cc:	eb 53                	jmp    804621 <ipc_recv+0x104>
	}
	if(from_env_store)
  8045ce:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8045d3:	74 19                	je     8045ee <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  8045d5:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8045dc:	00 00 00 
  8045df:	48 8b 00             	mov    (%rax),%rax
  8045e2:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8045e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8045ec:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  8045ee:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8045f3:	74 19                	je     80460e <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  8045f5:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8045fc:	00 00 00 
  8045ff:	48 8b 00             	mov    (%rax),%rax
  804602:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804608:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80460c:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  80460e:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  804615:	00 00 00 
  804618:	48 8b 00             	mov    (%rax),%rax
  80461b:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  804621:	c9                   	leaveq 
  804622:	c3                   	retq   

0000000000804623 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804623:	55                   	push   %rbp
  804624:	48 89 e5             	mov    %rsp,%rbp
  804627:	48 83 ec 30          	sub    $0x30,%rsp
  80462b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80462e:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804631:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804635:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  804638:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80463d:	75 0e                	jne    80464d <ipc_send+0x2a>
		pg = (void*)UTOP;
  80463f:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804646:	00 00 00 
  804649:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  80464d:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804650:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804653:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804657:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80465a:	89 c7                	mov    %eax,%edi
  80465c:	48 b8 54 1b 80 00 00 	movabs $0x801b54,%rax
  804663:	00 00 00 
  804666:	ff d0                	callq  *%rax
  804668:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  80466b:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80466f:	75 0c                	jne    80467d <ipc_send+0x5a>
			sys_yield();
  804671:	48 b8 42 19 80 00 00 	movabs $0x801942,%rax
  804678:	00 00 00 
  80467b:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  80467d:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804681:	74 ca                	je     80464d <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  804683:	c9                   	leaveq 
  804684:	c3                   	retq   

0000000000804685 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804685:	55                   	push   %rbp
  804686:	48 89 e5             	mov    %rsp,%rbp
  804689:	48 83 ec 14          	sub    $0x14,%rsp
  80468d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804690:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804697:	eb 5e                	jmp    8046f7 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  804699:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8046a0:	00 00 00 
  8046a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046a6:	48 63 d0             	movslq %eax,%rdx
  8046a9:	48 89 d0             	mov    %rdx,%rax
  8046ac:	48 c1 e0 03          	shl    $0x3,%rax
  8046b0:	48 01 d0             	add    %rdx,%rax
  8046b3:	48 c1 e0 05          	shl    $0x5,%rax
  8046b7:	48 01 c8             	add    %rcx,%rax
  8046ba:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8046c0:	8b 00                	mov    (%rax),%eax
  8046c2:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8046c5:	75 2c                	jne    8046f3 <ipc_find_env+0x6e>
			return envs[i].env_id;
  8046c7:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8046ce:	00 00 00 
  8046d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046d4:	48 63 d0             	movslq %eax,%rdx
  8046d7:	48 89 d0             	mov    %rdx,%rax
  8046da:	48 c1 e0 03          	shl    $0x3,%rax
  8046de:	48 01 d0             	add    %rdx,%rax
  8046e1:	48 c1 e0 05          	shl    $0x5,%rax
  8046e5:	48 01 c8             	add    %rcx,%rax
  8046e8:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8046ee:	8b 40 08             	mov    0x8(%rax),%eax
  8046f1:	eb 12                	jmp    804705 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8046f3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8046f7:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8046fe:	7e 99                	jle    804699 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804700:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804705:	c9                   	leaveq 
  804706:	c3                   	retq   

0000000000804707 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804707:	55                   	push   %rbp
  804708:	48 89 e5             	mov    %rsp,%rbp
  80470b:	48 83 ec 18          	sub    $0x18,%rsp
  80470f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804713:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804717:	48 c1 e8 15          	shr    $0x15,%rax
  80471b:	48 89 c2             	mov    %rax,%rdx
  80471e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804725:	01 00 00 
  804728:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80472c:	83 e0 01             	and    $0x1,%eax
  80472f:	48 85 c0             	test   %rax,%rax
  804732:	75 07                	jne    80473b <pageref+0x34>
		return 0;
  804734:	b8 00 00 00 00       	mov    $0x0,%eax
  804739:	eb 53                	jmp    80478e <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80473b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80473f:	48 c1 e8 0c          	shr    $0xc,%rax
  804743:	48 89 c2             	mov    %rax,%rdx
  804746:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80474d:	01 00 00 
  804750:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804754:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804758:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80475c:	83 e0 01             	and    $0x1,%eax
  80475f:	48 85 c0             	test   %rax,%rax
  804762:	75 07                	jne    80476b <pageref+0x64>
		return 0;
  804764:	b8 00 00 00 00       	mov    $0x0,%eax
  804769:	eb 23                	jmp    80478e <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  80476b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80476f:	48 c1 e8 0c          	shr    $0xc,%rax
  804773:	48 89 c2             	mov    %rax,%rdx
  804776:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80477d:	00 00 00 
  804780:	48 c1 e2 04          	shl    $0x4,%rdx
  804784:	48 01 d0             	add    %rdx,%rax
  804787:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80478b:	0f b7 c0             	movzwl %ax,%eax
}
  80478e:	c9                   	leaveq 
  80478f:	c3                   	retq   
