
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
  80006a:	48 b8 d6 1f 80 00 00 	movabs $0x801fd6,%rax
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
  8000f2:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8000f9:	00 00 00 
  8000fc:	8b 00                	mov    (%rax),%eax
  8000fe:	8d 50 01             	lea    0x1(%rax),%edx
  800101:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
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
  800124:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80012b:	00 00 00 
  80012e:	8b 00                	mov    (%rax),%eax
  800130:	3d a0 86 01 00       	cmp    $0x186a0,%eax
  800135:	74 39                	je     800170 <umain+0x12d>
		panic("ran on two CPUs at once (counter is %d)", counter);
  800137:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80013e:	00 00 00 
  800141:	8b 00                	mov    (%rax),%eax
  800143:	89 c1                	mov    %eax,%ecx
  800145:	48 ba e0 3c 80 00 00 	movabs $0x803ce0,%rdx
  80014c:	00 00 00 
  80014f:	be 21 00 00 00       	mov    $0x21,%esi
  800154:	48 bf 08 3d 80 00 00 	movabs $0x803d08,%rdi
  80015b:	00 00 00 
  80015e:	b8 00 00 00 00       	mov    $0x0,%eax
  800163:	49 b8 63 02 80 00 00 	movabs $0x800263,%r8
  80016a:	00 00 00 
  80016d:	41 ff d0             	callq  *%r8

	// Check that we see environments running on different CPUs
	cprintf("[%08x] stresssched on CPU %d\n", thisenv->env_id, thisenv->env_cpunum);
  800170:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800177:	00 00 00 
  80017a:	48 8b 00             	mov    (%rax),%rax
  80017d:	8b 90 dc 00 00 00    	mov    0xdc(%rax),%edx
  800183:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80018a:	00 00 00 
  80018d:	48 8b 00             	mov    (%rax),%rax
  800190:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800196:	89 c6                	mov    %eax,%esi
  800198:	48 bf 1b 3d 80 00 00 	movabs $0x803d1b,%rdi
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
  8001f3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
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
  800244:	48 b8 c8 25 80 00 00 	movabs $0x8025c8,%rax
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
  80031d:	48 bf 48 3d 80 00 00 	movabs $0x803d48,%rdi
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
  800359:	48 bf 6b 3d 80 00 00 	movabs $0x803d6b,%rdi
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
  800608:	48 ba 48 3f 80 00 00 	movabs $0x803f48,%rdx
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
  800900:	48 b8 70 3f 80 00 00 	movabs $0x803f70,%rax
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
  800a4e:	83 fb 10             	cmp    $0x10,%ebx
  800a51:	7f 16                	jg     800a69 <vprintfmt+0x21a>
  800a53:	48 b8 c0 3e 80 00 00 	movabs $0x803ec0,%rax
  800a5a:	00 00 00 
  800a5d:	48 63 d3             	movslq %ebx,%rdx
  800a60:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a64:	4d 85 e4             	test   %r12,%r12
  800a67:	75 2e                	jne    800a97 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a69:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a6d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a71:	89 d9                	mov    %ebx,%ecx
  800a73:	48 ba 59 3f 80 00 00 	movabs $0x803f59,%rdx
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
  800aa2:	48 ba 62 3f 80 00 00 	movabs $0x803f62,%rdx
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
  800afc:	49 bc 65 3f 80 00 00 	movabs $0x803f65,%r12
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
  801802:	48 ba 20 42 80 00 00 	movabs $0x804220,%rdx
  801809:	00 00 00 
  80180c:	be 23 00 00 00       	mov    $0x23,%esi
  801811:	48 bf 3d 42 80 00 00 	movabs $0x80423d,%rdi
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

0000000000801bed <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  801bed:	55                   	push   %rbp
  801bee:	48 89 e5             	mov    %rsp,%rbp
  801bf1:	48 83 ec 30          	sub    $0x30,%rsp
  801bf5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801bf9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bfd:	48 8b 00             	mov    (%rax),%rax
  801c00:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801c04:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c08:	48 8b 40 08          	mov    0x8(%rax),%rax
  801c0c:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801c0f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801c12:	83 e0 02             	and    $0x2,%eax
  801c15:	85 c0                	test   %eax,%eax
  801c17:	75 4d                	jne    801c66 <pgfault+0x79>
  801c19:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c1d:	48 c1 e8 0c          	shr    $0xc,%rax
  801c21:	48 89 c2             	mov    %rax,%rdx
  801c24:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c2b:	01 00 00 
  801c2e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c32:	25 00 08 00 00       	and    $0x800,%eax
  801c37:	48 85 c0             	test   %rax,%rax
  801c3a:	74 2a                	je     801c66 <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  801c3c:	48 ba 50 42 80 00 00 	movabs $0x804250,%rdx
  801c43:	00 00 00 
  801c46:	be 23 00 00 00       	mov    $0x23,%esi
  801c4b:	48 bf 85 42 80 00 00 	movabs $0x804285,%rdi
  801c52:	00 00 00 
  801c55:	b8 00 00 00 00       	mov    $0x0,%eax
  801c5a:	48 b9 63 02 80 00 00 	movabs $0x800263,%rcx
  801c61:	00 00 00 
  801c64:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  801c66:	ba 07 00 00 00       	mov    $0x7,%edx
  801c6b:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801c70:	bf 00 00 00 00       	mov    $0x0,%edi
  801c75:	48 b8 80 19 80 00 00 	movabs $0x801980,%rax
  801c7c:	00 00 00 
  801c7f:	ff d0                	callq  *%rax
  801c81:	85 c0                	test   %eax,%eax
  801c83:	0f 85 cd 00 00 00    	jne    801d56 <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801c89:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c8d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801c91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c95:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801c9b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801c9f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ca3:	ba 00 10 00 00       	mov    $0x1000,%edx
  801ca8:	48 89 c6             	mov    %rax,%rsi
  801cab:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801cb0:	48 b8 75 13 80 00 00 	movabs $0x801375,%rax
  801cb7:	00 00 00 
  801cba:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801cbc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801cc0:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801cc6:	48 89 c1             	mov    %rax,%rcx
  801cc9:	ba 00 00 00 00       	mov    $0x0,%edx
  801cce:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801cd3:	bf 00 00 00 00       	mov    $0x0,%edi
  801cd8:	48 b8 d0 19 80 00 00 	movabs $0x8019d0,%rax
  801cdf:	00 00 00 
  801ce2:	ff d0                	callq  *%rax
  801ce4:	85 c0                	test   %eax,%eax
  801ce6:	79 2a                	jns    801d12 <pgfault+0x125>
				panic("Page map at temp address failed");
  801ce8:	48 ba 90 42 80 00 00 	movabs $0x804290,%rdx
  801cef:	00 00 00 
  801cf2:	be 30 00 00 00       	mov    $0x30,%esi
  801cf7:	48 bf 85 42 80 00 00 	movabs $0x804285,%rdi
  801cfe:	00 00 00 
  801d01:	b8 00 00 00 00       	mov    $0x0,%eax
  801d06:	48 b9 63 02 80 00 00 	movabs $0x800263,%rcx
  801d0d:	00 00 00 
  801d10:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801d12:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801d17:	bf 00 00 00 00       	mov    $0x0,%edi
  801d1c:	48 b8 2b 1a 80 00 00 	movabs $0x801a2b,%rax
  801d23:	00 00 00 
  801d26:	ff d0                	callq  *%rax
  801d28:	85 c0                	test   %eax,%eax
  801d2a:	79 54                	jns    801d80 <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801d2c:	48 ba b0 42 80 00 00 	movabs $0x8042b0,%rdx
  801d33:	00 00 00 
  801d36:	be 32 00 00 00       	mov    $0x32,%esi
  801d3b:	48 bf 85 42 80 00 00 	movabs $0x804285,%rdi
  801d42:	00 00 00 
  801d45:	b8 00 00 00 00       	mov    $0x0,%eax
  801d4a:	48 b9 63 02 80 00 00 	movabs $0x800263,%rcx
  801d51:	00 00 00 
  801d54:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  801d56:	48 ba d8 42 80 00 00 	movabs $0x8042d8,%rdx
  801d5d:	00 00 00 
  801d60:	be 34 00 00 00       	mov    $0x34,%esi
  801d65:	48 bf 85 42 80 00 00 	movabs $0x804285,%rdi
  801d6c:	00 00 00 
  801d6f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d74:	48 b9 63 02 80 00 00 	movabs $0x800263,%rcx
  801d7b:	00 00 00 
  801d7e:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  801d80:	c9                   	leaveq 
  801d81:	c3                   	retq   

0000000000801d82 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801d82:	55                   	push   %rbp
  801d83:	48 89 e5             	mov    %rsp,%rbp
  801d86:	48 83 ec 20          	sub    $0x20,%rsp
  801d8a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801d8d:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  801d90:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d97:	01 00 00 
  801d9a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801d9d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801da1:	25 07 0e 00 00       	and    $0xe07,%eax
  801da6:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801da9:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801dac:	48 c1 e0 0c          	shl    $0xc,%rax
  801db0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  801db4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801db7:	25 00 04 00 00       	and    $0x400,%eax
  801dbc:	85 c0                	test   %eax,%eax
  801dbe:	74 57                	je     801e17 <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801dc0:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801dc3:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801dc7:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801dca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dce:	41 89 f0             	mov    %esi,%r8d
  801dd1:	48 89 c6             	mov    %rax,%rsi
  801dd4:	bf 00 00 00 00       	mov    $0x0,%edi
  801dd9:	48 b8 d0 19 80 00 00 	movabs $0x8019d0,%rax
  801de0:	00 00 00 
  801de3:	ff d0                	callq  *%rax
  801de5:	85 c0                	test   %eax,%eax
  801de7:	0f 8e 52 01 00 00    	jle    801f3f <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801ded:	48 ba 0a 43 80 00 00 	movabs $0x80430a,%rdx
  801df4:	00 00 00 
  801df7:	be 4e 00 00 00       	mov    $0x4e,%esi
  801dfc:	48 bf 85 42 80 00 00 	movabs $0x804285,%rdi
  801e03:	00 00 00 
  801e06:	b8 00 00 00 00       	mov    $0x0,%eax
  801e0b:	48 b9 63 02 80 00 00 	movabs $0x800263,%rcx
  801e12:	00 00 00 
  801e15:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  801e17:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e1a:	83 e0 02             	and    $0x2,%eax
  801e1d:	85 c0                	test   %eax,%eax
  801e1f:	75 10                	jne    801e31 <duppage+0xaf>
  801e21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e24:	25 00 08 00 00       	and    $0x800,%eax
  801e29:	85 c0                	test   %eax,%eax
  801e2b:	0f 84 bb 00 00 00    	je     801eec <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  801e31:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e34:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  801e39:	80 cc 08             	or     $0x8,%ah
  801e3c:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801e3f:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801e42:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801e46:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801e49:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e4d:	41 89 f0             	mov    %esi,%r8d
  801e50:	48 89 c6             	mov    %rax,%rsi
  801e53:	bf 00 00 00 00       	mov    $0x0,%edi
  801e58:	48 b8 d0 19 80 00 00 	movabs $0x8019d0,%rax
  801e5f:	00 00 00 
  801e62:	ff d0                	callq  *%rax
  801e64:	85 c0                	test   %eax,%eax
  801e66:	7e 2a                	jle    801e92 <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  801e68:	48 ba 0a 43 80 00 00 	movabs $0x80430a,%rdx
  801e6f:	00 00 00 
  801e72:	be 55 00 00 00       	mov    $0x55,%esi
  801e77:	48 bf 85 42 80 00 00 	movabs $0x804285,%rdi
  801e7e:	00 00 00 
  801e81:	b8 00 00 00 00       	mov    $0x0,%eax
  801e86:	48 b9 63 02 80 00 00 	movabs $0x800263,%rcx
  801e8d:	00 00 00 
  801e90:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  801e92:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801e95:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e99:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e9d:	41 89 c8             	mov    %ecx,%r8d
  801ea0:	48 89 d1             	mov    %rdx,%rcx
  801ea3:	ba 00 00 00 00       	mov    $0x0,%edx
  801ea8:	48 89 c6             	mov    %rax,%rsi
  801eab:	bf 00 00 00 00       	mov    $0x0,%edi
  801eb0:	48 b8 d0 19 80 00 00 	movabs $0x8019d0,%rax
  801eb7:	00 00 00 
  801eba:	ff d0                	callq  *%rax
  801ebc:	85 c0                	test   %eax,%eax
  801ebe:	7e 2a                	jle    801eea <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  801ec0:	48 ba 0a 43 80 00 00 	movabs $0x80430a,%rdx
  801ec7:	00 00 00 
  801eca:	be 57 00 00 00       	mov    $0x57,%esi
  801ecf:	48 bf 85 42 80 00 00 	movabs $0x804285,%rdi
  801ed6:	00 00 00 
  801ed9:	b8 00 00 00 00       	mov    $0x0,%eax
  801ede:	48 b9 63 02 80 00 00 	movabs $0x800263,%rcx
  801ee5:	00 00 00 
  801ee8:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  801eea:	eb 53                	jmp    801f3f <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801eec:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801eef:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801ef3:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801ef6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801efa:	41 89 f0             	mov    %esi,%r8d
  801efd:	48 89 c6             	mov    %rax,%rsi
  801f00:	bf 00 00 00 00       	mov    $0x0,%edi
  801f05:	48 b8 d0 19 80 00 00 	movabs $0x8019d0,%rax
  801f0c:	00 00 00 
  801f0f:	ff d0                	callq  *%rax
  801f11:	85 c0                	test   %eax,%eax
  801f13:	7e 2a                	jle    801f3f <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801f15:	48 ba 0a 43 80 00 00 	movabs $0x80430a,%rdx
  801f1c:	00 00 00 
  801f1f:	be 5b 00 00 00       	mov    $0x5b,%esi
  801f24:	48 bf 85 42 80 00 00 	movabs $0x804285,%rdi
  801f2b:	00 00 00 
  801f2e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f33:	48 b9 63 02 80 00 00 	movabs $0x800263,%rcx
  801f3a:	00 00 00 
  801f3d:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  801f3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f44:	c9                   	leaveq 
  801f45:	c3                   	retq   

0000000000801f46 <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  801f46:	55                   	push   %rbp
  801f47:	48 89 e5             	mov    %rsp,%rbp
  801f4a:	48 83 ec 18          	sub    $0x18,%rsp
  801f4e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  801f52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f56:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  801f5a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f5e:	48 c1 e8 27          	shr    $0x27,%rax
  801f62:	48 89 c2             	mov    %rax,%rdx
  801f65:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801f6c:	01 00 00 
  801f6f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f73:	83 e0 01             	and    $0x1,%eax
  801f76:	48 85 c0             	test   %rax,%rax
  801f79:	74 51                	je     801fcc <pt_is_mapped+0x86>
  801f7b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f7f:	48 c1 e0 0c          	shl    $0xc,%rax
  801f83:	48 c1 e8 1e          	shr    $0x1e,%rax
  801f87:	48 89 c2             	mov    %rax,%rdx
  801f8a:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  801f91:	01 00 00 
  801f94:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f98:	83 e0 01             	and    $0x1,%eax
  801f9b:	48 85 c0             	test   %rax,%rax
  801f9e:	74 2c                	je     801fcc <pt_is_mapped+0x86>
  801fa0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fa4:	48 c1 e0 0c          	shl    $0xc,%rax
  801fa8:	48 c1 e8 15          	shr    $0x15,%rax
  801fac:	48 89 c2             	mov    %rax,%rdx
  801faf:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801fb6:	01 00 00 
  801fb9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fbd:	83 e0 01             	and    $0x1,%eax
  801fc0:	48 85 c0             	test   %rax,%rax
  801fc3:	74 07                	je     801fcc <pt_is_mapped+0x86>
  801fc5:	b8 01 00 00 00       	mov    $0x1,%eax
  801fca:	eb 05                	jmp    801fd1 <pt_is_mapped+0x8b>
  801fcc:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd1:	83 e0 01             	and    $0x1,%eax
}
  801fd4:	c9                   	leaveq 
  801fd5:	c3                   	retq   

0000000000801fd6 <fork>:

envid_t
fork(void)
{
  801fd6:	55                   	push   %rbp
  801fd7:	48 89 e5             	mov    %rsp,%rbp
  801fda:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  801fde:	48 bf ed 1b 80 00 00 	movabs $0x801bed,%rdi
  801fe5:	00 00 00 
  801fe8:	48 b8 2c 39 80 00 00 	movabs $0x80392c,%rax
  801fef:	00 00 00 
  801ff2:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801ff4:	b8 07 00 00 00       	mov    $0x7,%eax
  801ff9:	cd 30                	int    $0x30
  801ffb:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801ffe:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  802001:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  802004:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802008:	79 30                	jns    80203a <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  80200a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80200d:	89 c1                	mov    %eax,%ecx
  80200f:	48 ba 28 43 80 00 00 	movabs $0x804328,%rdx
  802016:	00 00 00 
  802019:	be 86 00 00 00       	mov    $0x86,%esi
  80201e:	48 bf 85 42 80 00 00 	movabs $0x804285,%rdi
  802025:	00 00 00 
  802028:	b8 00 00 00 00       	mov    $0x0,%eax
  80202d:	49 b8 63 02 80 00 00 	movabs $0x800263,%r8
  802034:	00 00 00 
  802037:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  80203a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80203e:	75 46                	jne    802086 <fork+0xb0>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  802040:	48 b8 04 19 80 00 00 	movabs $0x801904,%rax
  802047:	00 00 00 
  80204a:	ff d0                	callq  *%rax
  80204c:	25 ff 03 00 00       	and    $0x3ff,%eax
  802051:	48 63 d0             	movslq %eax,%rdx
  802054:	48 89 d0             	mov    %rdx,%rax
  802057:	48 c1 e0 03          	shl    $0x3,%rax
  80205b:	48 01 d0             	add    %rdx,%rax
  80205e:	48 c1 e0 05          	shl    $0x5,%rax
  802062:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802069:	00 00 00 
  80206c:	48 01 c2             	add    %rax,%rdx
  80206f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802076:	00 00 00 
  802079:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  80207c:	b8 00 00 00 00       	mov    $0x0,%eax
  802081:	e9 d1 01 00 00       	jmpq   802257 <fork+0x281>
	}
	uint64_t ad = 0;
  802086:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80208d:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  80208e:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  802093:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802097:	e9 df 00 00 00       	jmpq   80217b <fork+0x1a5>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  80209c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020a0:	48 c1 e8 27          	shr    $0x27,%rax
  8020a4:	48 89 c2             	mov    %rax,%rdx
  8020a7:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8020ae:	01 00 00 
  8020b1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020b5:	83 e0 01             	and    $0x1,%eax
  8020b8:	48 85 c0             	test   %rax,%rax
  8020bb:	0f 84 9e 00 00 00    	je     80215f <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  8020c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020c5:	48 c1 e8 1e          	shr    $0x1e,%rax
  8020c9:	48 89 c2             	mov    %rax,%rdx
  8020cc:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8020d3:	01 00 00 
  8020d6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020da:	83 e0 01             	and    $0x1,%eax
  8020dd:	48 85 c0             	test   %rax,%rax
  8020e0:	74 73                	je     802155 <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  8020e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020e6:	48 c1 e8 15          	shr    $0x15,%rax
  8020ea:	48 89 c2             	mov    %rax,%rdx
  8020ed:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8020f4:	01 00 00 
  8020f7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020fb:	83 e0 01             	and    $0x1,%eax
  8020fe:	48 85 c0             	test   %rax,%rax
  802101:	74 48                	je     80214b <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  802103:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802107:	48 c1 e8 0c          	shr    $0xc,%rax
  80210b:	48 89 c2             	mov    %rax,%rdx
  80210e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802115:	01 00 00 
  802118:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80211c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802120:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802124:	83 e0 01             	and    $0x1,%eax
  802127:	48 85 c0             	test   %rax,%rax
  80212a:	74 47                	je     802173 <fork+0x19d>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  80212c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802130:	48 c1 e8 0c          	shr    $0xc,%rax
  802134:	89 c2                	mov    %eax,%edx
  802136:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802139:	89 d6                	mov    %edx,%esi
  80213b:	89 c7                	mov    %eax,%edi
  80213d:	48 b8 82 1d 80 00 00 	movabs $0x801d82,%rax
  802144:	00 00 00 
  802147:	ff d0                	callq  *%rax
  802149:	eb 28                	jmp    802173 <fork+0x19d>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  80214b:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  802152:	00 
  802153:	eb 1e                	jmp    802173 <fork+0x19d>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  802155:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  80215c:	40 
  80215d:	eb 14                	jmp    802173 <fork+0x19d>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  80215f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802163:	48 c1 e8 27          	shr    $0x27,%rax
  802167:	48 83 c0 01          	add    $0x1,%rax
  80216b:	48 c1 e0 27          	shl    $0x27,%rax
  80216f:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  802173:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  80217a:	00 
  80217b:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  802182:	00 
  802183:	0f 87 13 ff ff ff    	ja     80209c <fork+0xc6>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  802189:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80218c:	ba 07 00 00 00       	mov    $0x7,%edx
  802191:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802196:	89 c7                	mov    %eax,%edi
  802198:	48 b8 80 19 80 00 00 	movabs $0x801980,%rax
  80219f:	00 00 00 
  8021a2:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8021a4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8021a7:	ba 07 00 00 00       	mov    $0x7,%edx
  8021ac:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8021b1:	89 c7                	mov    %eax,%edi
  8021b3:	48 b8 80 19 80 00 00 	movabs $0x801980,%rax
  8021ba:	00 00 00 
  8021bd:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  8021bf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8021c2:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8021c8:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  8021cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8021d2:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8021d7:	89 c7                	mov    %eax,%edi
  8021d9:	48 b8 d0 19 80 00 00 	movabs $0x8019d0,%rax
  8021e0:	00 00 00 
  8021e3:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  8021e5:	ba 00 10 00 00       	mov    $0x1000,%edx
  8021ea:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8021ef:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  8021f4:	48 b8 75 13 80 00 00 	movabs $0x801375,%rax
  8021fb:	00 00 00 
  8021fe:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  802200:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802205:	bf 00 00 00 00       	mov    $0x0,%edi
  80220a:	48 b8 2b 1a 80 00 00 	movabs $0x801a2b,%rax
  802211:	00 00 00 
  802214:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  802216:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80221d:	00 00 00 
  802220:	48 8b 00             	mov    (%rax),%rax
  802223:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  80222a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80222d:	48 89 d6             	mov    %rdx,%rsi
  802230:	89 c7                	mov    %eax,%edi
  802232:	48 b8 0a 1b 80 00 00 	movabs $0x801b0a,%rax
  802239:	00 00 00 
  80223c:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  80223e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802241:	be 02 00 00 00       	mov    $0x2,%esi
  802246:	89 c7                	mov    %eax,%edi
  802248:	48 b8 75 1a 80 00 00 	movabs $0x801a75,%rax
  80224f:	00 00 00 
  802252:	ff d0                	callq  *%rax

	return envid;
  802254:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  802257:	c9                   	leaveq 
  802258:	c3                   	retq   

0000000000802259 <sfork>:

	
// Challenge!
int
sfork(void)
{
  802259:	55                   	push   %rbp
  80225a:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  80225d:	48 ba 40 43 80 00 00 	movabs $0x804340,%rdx
  802264:	00 00 00 
  802267:	be bf 00 00 00       	mov    $0xbf,%esi
  80226c:	48 bf 85 42 80 00 00 	movabs $0x804285,%rdi
  802273:	00 00 00 
  802276:	b8 00 00 00 00       	mov    $0x0,%eax
  80227b:	48 b9 63 02 80 00 00 	movabs $0x800263,%rcx
  802282:	00 00 00 
  802285:	ff d1                	callq  *%rcx

0000000000802287 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802287:	55                   	push   %rbp
  802288:	48 89 e5             	mov    %rsp,%rbp
  80228b:	48 83 ec 08          	sub    $0x8,%rsp
  80228f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802293:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802297:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80229e:	ff ff ff 
  8022a1:	48 01 d0             	add    %rdx,%rax
  8022a4:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8022a8:	c9                   	leaveq 
  8022a9:	c3                   	retq   

00000000008022aa <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8022aa:	55                   	push   %rbp
  8022ab:	48 89 e5             	mov    %rsp,%rbp
  8022ae:	48 83 ec 08          	sub    $0x8,%rsp
  8022b2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8022b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022ba:	48 89 c7             	mov    %rax,%rdi
  8022bd:	48 b8 87 22 80 00 00 	movabs $0x802287,%rax
  8022c4:	00 00 00 
  8022c7:	ff d0                	callq  *%rax
  8022c9:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8022cf:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8022d3:	c9                   	leaveq 
  8022d4:	c3                   	retq   

00000000008022d5 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8022d5:	55                   	push   %rbp
  8022d6:	48 89 e5             	mov    %rsp,%rbp
  8022d9:	48 83 ec 18          	sub    $0x18,%rsp
  8022dd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8022e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8022e8:	eb 6b                	jmp    802355 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8022ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022ed:	48 98                	cltq   
  8022ef:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8022f5:	48 c1 e0 0c          	shl    $0xc,%rax
  8022f9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8022fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802301:	48 c1 e8 15          	shr    $0x15,%rax
  802305:	48 89 c2             	mov    %rax,%rdx
  802308:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80230f:	01 00 00 
  802312:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802316:	83 e0 01             	and    $0x1,%eax
  802319:	48 85 c0             	test   %rax,%rax
  80231c:	74 21                	je     80233f <fd_alloc+0x6a>
  80231e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802322:	48 c1 e8 0c          	shr    $0xc,%rax
  802326:	48 89 c2             	mov    %rax,%rdx
  802329:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802330:	01 00 00 
  802333:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802337:	83 e0 01             	and    $0x1,%eax
  80233a:	48 85 c0             	test   %rax,%rax
  80233d:	75 12                	jne    802351 <fd_alloc+0x7c>
			*fd_store = fd;
  80233f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802343:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802347:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80234a:	b8 00 00 00 00       	mov    $0x0,%eax
  80234f:	eb 1a                	jmp    80236b <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802351:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802355:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802359:	7e 8f                	jle    8022ea <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80235b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80235f:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802366:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80236b:	c9                   	leaveq 
  80236c:	c3                   	retq   

000000000080236d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80236d:	55                   	push   %rbp
  80236e:	48 89 e5             	mov    %rsp,%rbp
  802371:	48 83 ec 20          	sub    $0x20,%rsp
  802375:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802378:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80237c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802380:	78 06                	js     802388 <fd_lookup+0x1b>
  802382:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802386:	7e 07                	jle    80238f <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802388:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80238d:	eb 6c                	jmp    8023fb <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80238f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802392:	48 98                	cltq   
  802394:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80239a:	48 c1 e0 0c          	shl    $0xc,%rax
  80239e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8023a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023a6:	48 c1 e8 15          	shr    $0x15,%rax
  8023aa:	48 89 c2             	mov    %rax,%rdx
  8023ad:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8023b4:	01 00 00 
  8023b7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023bb:	83 e0 01             	and    $0x1,%eax
  8023be:	48 85 c0             	test   %rax,%rax
  8023c1:	74 21                	je     8023e4 <fd_lookup+0x77>
  8023c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023c7:	48 c1 e8 0c          	shr    $0xc,%rax
  8023cb:	48 89 c2             	mov    %rax,%rdx
  8023ce:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023d5:	01 00 00 
  8023d8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023dc:	83 e0 01             	and    $0x1,%eax
  8023df:	48 85 c0             	test   %rax,%rax
  8023e2:	75 07                	jne    8023eb <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8023e4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8023e9:	eb 10                	jmp    8023fb <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8023eb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023ef:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8023f3:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8023f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023fb:	c9                   	leaveq 
  8023fc:	c3                   	retq   

00000000008023fd <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8023fd:	55                   	push   %rbp
  8023fe:	48 89 e5             	mov    %rsp,%rbp
  802401:	48 83 ec 30          	sub    $0x30,%rsp
  802405:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802409:	89 f0                	mov    %esi,%eax
  80240b:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80240e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802412:	48 89 c7             	mov    %rax,%rdi
  802415:	48 b8 87 22 80 00 00 	movabs $0x802287,%rax
  80241c:	00 00 00 
  80241f:	ff d0                	callq  *%rax
  802421:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802425:	48 89 d6             	mov    %rdx,%rsi
  802428:	89 c7                	mov    %eax,%edi
  80242a:	48 b8 6d 23 80 00 00 	movabs $0x80236d,%rax
  802431:	00 00 00 
  802434:	ff d0                	callq  *%rax
  802436:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802439:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80243d:	78 0a                	js     802449 <fd_close+0x4c>
	    || fd != fd2)
  80243f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802443:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802447:	74 12                	je     80245b <fd_close+0x5e>
		return (must_exist ? r : 0);
  802449:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80244d:	74 05                	je     802454 <fd_close+0x57>
  80244f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802452:	eb 05                	jmp    802459 <fd_close+0x5c>
  802454:	b8 00 00 00 00       	mov    $0x0,%eax
  802459:	eb 69                	jmp    8024c4 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80245b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80245f:	8b 00                	mov    (%rax),%eax
  802461:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802465:	48 89 d6             	mov    %rdx,%rsi
  802468:	89 c7                	mov    %eax,%edi
  80246a:	48 b8 c6 24 80 00 00 	movabs $0x8024c6,%rax
  802471:	00 00 00 
  802474:	ff d0                	callq  *%rax
  802476:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802479:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80247d:	78 2a                	js     8024a9 <fd_close+0xac>
		if (dev->dev_close)
  80247f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802483:	48 8b 40 20          	mov    0x20(%rax),%rax
  802487:	48 85 c0             	test   %rax,%rax
  80248a:	74 16                	je     8024a2 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  80248c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802490:	48 8b 40 20          	mov    0x20(%rax),%rax
  802494:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802498:	48 89 d7             	mov    %rdx,%rdi
  80249b:	ff d0                	callq  *%rax
  80249d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024a0:	eb 07                	jmp    8024a9 <fd_close+0xac>
		else
			r = 0;
  8024a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8024a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024ad:	48 89 c6             	mov    %rax,%rsi
  8024b0:	bf 00 00 00 00       	mov    $0x0,%edi
  8024b5:	48 b8 2b 1a 80 00 00 	movabs $0x801a2b,%rax
  8024bc:	00 00 00 
  8024bf:	ff d0                	callq  *%rax
	return r;
  8024c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8024c4:	c9                   	leaveq 
  8024c5:	c3                   	retq   

00000000008024c6 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8024c6:	55                   	push   %rbp
  8024c7:	48 89 e5             	mov    %rsp,%rbp
  8024ca:	48 83 ec 20          	sub    $0x20,%rsp
  8024ce:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8024d1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8024d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8024dc:	eb 41                	jmp    80251f <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8024de:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8024e5:	00 00 00 
  8024e8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8024eb:	48 63 d2             	movslq %edx,%rdx
  8024ee:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024f2:	8b 00                	mov    (%rax),%eax
  8024f4:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8024f7:	75 22                	jne    80251b <dev_lookup+0x55>
			*dev = devtab[i];
  8024f9:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802500:	00 00 00 
  802503:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802506:	48 63 d2             	movslq %edx,%rdx
  802509:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80250d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802511:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802514:	b8 00 00 00 00       	mov    $0x0,%eax
  802519:	eb 60                	jmp    80257b <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80251b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80251f:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802526:	00 00 00 
  802529:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80252c:	48 63 d2             	movslq %edx,%rdx
  80252f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802533:	48 85 c0             	test   %rax,%rax
  802536:	75 a6                	jne    8024de <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802538:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80253f:	00 00 00 
  802542:	48 8b 00             	mov    (%rax),%rax
  802545:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80254b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80254e:	89 c6                	mov    %eax,%esi
  802550:	48 bf 58 43 80 00 00 	movabs $0x804358,%rdi
  802557:	00 00 00 
  80255a:	b8 00 00 00 00       	mov    $0x0,%eax
  80255f:	48 b9 9c 04 80 00 00 	movabs $0x80049c,%rcx
  802566:	00 00 00 
  802569:	ff d1                	callq  *%rcx
	*dev = 0;
  80256b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80256f:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802576:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80257b:	c9                   	leaveq 
  80257c:	c3                   	retq   

000000000080257d <close>:

int
close(int fdnum)
{
  80257d:	55                   	push   %rbp
  80257e:	48 89 e5             	mov    %rsp,%rbp
  802581:	48 83 ec 20          	sub    $0x20,%rsp
  802585:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802588:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80258c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80258f:	48 89 d6             	mov    %rdx,%rsi
  802592:	89 c7                	mov    %eax,%edi
  802594:	48 b8 6d 23 80 00 00 	movabs $0x80236d,%rax
  80259b:	00 00 00 
  80259e:	ff d0                	callq  *%rax
  8025a0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025a7:	79 05                	jns    8025ae <close+0x31>
		return r;
  8025a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025ac:	eb 18                	jmp    8025c6 <close+0x49>
	else
		return fd_close(fd, 1);
  8025ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025b2:	be 01 00 00 00       	mov    $0x1,%esi
  8025b7:	48 89 c7             	mov    %rax,%rdi
  8025ba:	48 b8 fd 23 80 00 00 	movabs $0x8023fd,%rax
  8025c1:	00 00 00 
  8025c4:	ff d0                	callq  *%rax
}
  8025c6:	c9                   	leaveq 
  8025c7:	c3                   	retq   

00000000008025c8 <close_all>:

void
close_all(void)
{
  8025c8:	55                   	push   %rbp
  8025c9:	48 89 e5             	mov    %rsp,%rbp
  8025cc:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8025d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8025d7:	eb 15                	jmp    8025ee <close_all+0x26>
		close(i);
  8025d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025dc:	89 c7                	mov    %eax,%edi
  8025de:	48 b8 7d 25 80 00 00 	movabs $0x80257d,%rax
  8025e5:	00 00 00 
  8025e8:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8025ea:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8025ee:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8025f2:	7e e5                	jle    8025d9 <close_all+0x11>
		close(i);
}
  8025f4:	c9                   	leaveq 
  8025f5:	c3                   	retq   

00000000008025f6 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8025f6:	55                   	push   %rbp
  8025f7:	48 89 e5             	mov    %rsp,%rbp
  8025fa:	48 83 ec 40          	sub    $0x40,%rsp
  8025fe:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802601:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802604:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802608:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80260b:	48 89 d6             	mov    %rdx,%rsi
  80260e:	89 c7                	mov    %eax,%edi
  802610:	48 b8 6d 23 80 00 00 	movabs $0x80236d,%rax
  802617:	00 00 00 
  80261a:	ff d0                	callq  *%rax
  80261c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80261f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802623:	79 08                	jns    80262d <dup+0x37>
		return r;
  802625:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802628:	e9 70 01 00 00       	jmpq   80279d <dup+0x1a7>
	close(newfdnum);
  80262d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802630:	89 c7                	mov    %eax,%edi
  802632:	48 b8 7d 25 80 00 00 	movabs $0x80257d,%rax
  802639:	00 00 00 
  80263c:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80263e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802641:	48 98                	cltq   
  802643:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802649:	48 c1 e0 0c          	shl    $0xc,%rax
  80264d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802651:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802655:	48 89 c7             	mov    %rax,%rdi
  802658:	48 b8 aa 22 80 00 00 	movabs $0x8022aa,%rax
  80265f:	00 00 00 
  802662:	ff d0                	callq  *%rax
  802664:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802668:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80266c:	48 89 c7             	mov    %rax,%rdi
  80266f:	48 b8 aa 22 80 00 00 	movabs $0x8022aa,%rax
  802676:	00 00 00 
  802679:	ff d0                	callq  *%rax
  80267b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80267f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802683:	48 c1 e8 15          	shr    $0x15,%rax
  802687:	48 89 c2             	mov    %rax,%rdx
  80268a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802691:	01 00 00 
  802694:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802698:	83 e0 01             	and    $0x1,%eax
  80269b:	48 85 c0             	test   %rax,%rax
  80269e:	74 73                	je     802713 <dup+0x11d>
  8026a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026a4:	48 c1 e8 0c          	shr    $0xc,%rax
  8026a8:	48 89 c2             	mov    %rax,%rdx
  8026ab:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8026b2:	01 00 00 
  8026b5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026b9:	83 e0 01             	and    $0x1,%eax
  8026bc:	48 85 c0             	test   %rax,%rax
  8026bf:	74 52                	je     802713 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8026c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026c5:	48 c1 e8 0c          	shr    $0xc,%rax
  8026c9:	48 89 c2             	mov    %rax,%rdx
  8026cc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8026d3:	01 00 00 
  8026d6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026da:	25 07 0e 00 00       	and    $0xe07,%eax
  8026df:	89 c1                	mov    %eax,%ecx
  8026e1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8026e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026e9:	41 89 c8             	mov    %ecx,%r8d
  8026ec:	48 89 d1             	mov    %rdx,%rcx
  8026ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8026f4:	48 89 c6             	mov    %rax,%rsi
  8026f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8026fc:	48 b8 d0 19 80 00 00 	movabs $0x8019d0,%rax
  802703:	00 00 00 
  802706:	ff d0                	callq  *%rax
  802708:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80270b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80270f:	79 02                	jns    802713 <dup+0x11d>
			goto err;
  802711:	eb 57                	jmp    80276a <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802713:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802717:	48 c1 e8 0c          	shr    $0xc,%rax
  80271b:	48 89 c2             	mov    %rax,%rdx
  80271e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802725:	01 00 00 
  802728:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80272c:	25 07 0e 00 00       	and    $0xe07,%eax
  802731:	89 c1                	mov    %eax,%ecx
  802733:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802737:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80273b:	41 89 c8             	mov    %ecx,%r8d
  80273e:	48 89 d1             	mov    %rdx,%rcx
  802741:	ba 00 00 00 00       	mov    $0x0,%edx
  802746:	48 89 c6             	mov    %rax,%rsi
  802749:	bf 00 00 00 00       	mov    $0x0,%edi
  80274e:	48 b8 d0 19 80 00 00 	movabs $0x8019d0,%rax
  802755:	00 00 00 
  802758:	ff d0                	callq  *%rax
  80275a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80275d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802761:	79 02                	jns    802765 <dup+0x16f>
		goto err;
  802763:	eb 05                	jmp    80276a <dup+0x174>

	return newfdnum;
  802765:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802768:	eb 33                	jmp    80279d <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  80276a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80276e:	48 89 c6             	mov    %rax,%rsi
  802771:	bf 00 00 00 00       	mov    $0x0,%edi
  802776:	48 b8 2b 1a 80 00 00 	movabs $0x801a2b,%rax
  80277d:	00 00 00 
  802780:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802782:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802786:	48 89 c6             	mov    %rax,%rsi
  802789:	bf 00 00 00 00       	mov    $0x0,%edi
  80278e:	48 b8 2b 1a 80 00 00 	movabs $0x801a2b,%rax
  802795:	00 00 00 
  802798:	ff d0                	callq  *%rax
	return r;
  80279a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80279d:	c9                   	leaveq 
  80279e:	c3                   	retq   

000000000080279f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80279f:	55                   	push   %rbp
  8027a0:	48 89 e5             	mov    %rsp,%rbp
  8027a3:	48 83 ec 40          	sub    $0x40,%rsp
  8027a7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8027aa:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8027ae:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8027b2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8027b6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8027b9:	48 89 d6             	mov    %rdx,%rsi
  8027bc:	89 c7                	mov    %eax,%edi
  8027be:	48 b8 6d 23 80 00 00 	movabs $0x80236d,%rax
  8027c5:	00 00 00 
  8027c8:	ff d0                	callq  *%rax
  8027ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027d1:	78 24                	js     8027f7 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8027d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027d7:	8b 00                	mov    (%rax),%eax
  8027d9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027dd:	48 89 d6             	mov    %rdx,%rsi
  8027e0:	89 c7                	mov    %eax,%edi
  8027e2:	48 b8 c6 24 80 00 00 	movabs $0x8024c6,%rax
  8027e9:	00 00 00 
  8027ec:	ff d0                	callq  *%rax
  8027ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027f5:	79 05                	jns    8027fc <read+0x5d>
		return r;
  8027f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027fa:	eb 76                	jmp    802872 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8027fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802800:	8b 40 08             	mov    0x8(%rax),%eax
  802803:	83 e0 03             	and    $0x3,%eax
  802806:	83 f8 01             	cmp    $0x1,%eax
  802809:	75 3a                	jne    802845 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80280b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802812:	00 00 00 
  802815:	48 8b 00             	mov    (%rax),%rax
  802818:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80281e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802821:	89 c6                	mov    %eax,%esi
  802823:	48 bf 77 43 80 00 00 	movabs $0x804377,%rdi
  80282a:	00 00 00 
  80282d:	b8 00 00 00 00       	mov    $0x0,%eax
  802832:	48 b9 9c 04 80 00 00 	movabs $0x80049c,%rcx
  802839:	00 00 00 
  80283c:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80283e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802843:	eb 2d                	jmp    802872 <read+0xd3>
	}
	if (!dev->dev_read)
  802845:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802849:	48 8b 40 10          	mov    0x10(%rax),%rax
  80284d:	48 85 c0             	test   %rax,%rax
  802850:	75 07                	jne    802859 <read+0xba>
		return -E_NOT_SUPP;
  802852:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802857:	eb 19                	jmp    802872 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802859:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80285d:	48 8b 40 10          	mov    0x10(%rax),%rax
  802861:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802865:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802869:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80286d:	48 89 cf             	mov    %rcx,%rdi
  802870:	ff d0                	callq  *%rax
}
  802872:	c9                   	leaveq 
  802873:	c3                   	retq   

0000000000802874 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802874:	55                   	push   %rbp
  802875:	48 89 e5             	mov    %rsp,%rbp
  802878:	48 83 ec 30          	sub    $0x30,%rsp
  80287c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80287f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802883:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802887:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80288e:	eb 49                	jmp    8028d9 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802890:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802893:	48 98                	cltq   
  802895:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802899:	48 29 c2             	sub    %rax,%rdx
  80289c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80289f:	48 63 c8             	movslq %eax,%rcx
  8028a2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028a6:	48 01 c1             	add    %rax,%rcx
  8028a9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028ac:	48 89 ce             	mov    %rcx,%rsi
  8028af:	89 c7                	mov    %eax,%edi
  8028b1:	48 b8 9f 27 80 00 00 	movabs $0x80279f,%rax
  8028b8:	00 00 00 
  8028bb:	ff d0                	callq  *%rax
  8028bd:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8028c0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8028c4:	79 05                	jns    8028cb <readn+0x57>
			return m;
  8028c6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8028c9:	eb 1c                	jmp    8028e7 <readn+0x73>
		if (m == 0)
  8028cb:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8028cf:	75 02                	jne    8028d3 <readn+0x5f>
			break;
  8028d1:	eb 11                	jmp    8028e4 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8028d3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8028d6:	01 45 fc             	add    %eax,-0x4(%rbp)
  8028d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028dc:	48 98                	cltq   
  8028de:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8028e2:	72 ac                	jb     802890 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8028e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8028e7:	c9                   	leaveq 
  8028e8:	c3                   	retq   

00000000008028e9 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8028e9:	55                   	push   %rbp
  8028ea:	48 89 e5             	mov    %rsp,%rbp
  8028ed:	48 83 ec 40          	sub    $0x40,%rsp
  8028f1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8028f4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8028f8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8028fc:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802900:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802903:	48 89 d6             	mov    %rdx,%rsi
  802906:	89 c7                	mov    %eax,%edi
  802908:	48 b8 6d 23 80 00 00 	movabs $0x80236d,%rax
  80290f:	00 00 00 
  802912:	ff d0                	callq  *%rax
  802914:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802917:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80291b:	78 24                	js     802941 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80291d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802921:	8b 00                	mov    (%rax),%eax
  802923:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802927:	48 89 d6             	mov    %rdx,%rsi
  80292a:	89 c7                	mov    %eax,%edi
  80292c:	48 b8 c6 24 80 00 00 	movabs $0x8024c6,%rax
  802933:	00 00 00 
  802936:	ff d0                	callq  *%rax
  802938:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80293b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80293f:	79 05                	jns    802946 <write+0x5d>
		return r;
  802941:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802944:	eb 75                	jmp    8029bb <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802946:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80294a:	8b 40 08             	mov    0x8(%rax),%eax
  80294d:	83 e0 03             	and    $0x3,%eax
  802950:	85 c0                	test   %eax,%eax
  802952:	75 3a                	jne    80298e <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802954:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80295b:	00 00 00 
  80295e:	48 8b 00             	mov    (%rax),%rax
  802961:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802967:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80296a:	89 c6                	mov    %eax,%esi
  80296c:	48 bf 93 43 80 00 00 	movabs $0x804393,%rdi
  802973:	00 00 00 
  802976:	b8 00 00 00 00       	mov    $0x0,%eax
  80297b:	48 b9 9c 04 80 00 00 	movabs $0x80049c,%rcx
  802982:	00 00 00 
  802985:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802987:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80298c:	eb 2d                	jmp    8029bb <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80298e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802992:	48 8b 40 18          	mov    0x18(%rax),%rax
  802996:	48 85 c0             	test   %rax,%rax
  802999:	75 07                	jne    8029a2 <write+0xb9>
		return -E_NOT_SUPP;
  80299b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8029a0:	eb 19                	jmp    8029bb <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8029a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029a6:	48 8b 40 18          	mov    0x18(%rax),%rax
  8029aa:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8029ae:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8029b2:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8029b6:	48 89 cf             	mov    %rcx,%rdi
  8029b9:	ff d0                	callq  *%rax
}
  8029bb:	c9                   	leaveq 
  8029bc:	c3                   	retq   

00000000008029bd <seek>:

int
seek(int fdnum, off_t offset)
{
  8029bd:	55                   	push   %rbp
  8029be:	48 89 e5             	mov    %rsp,%rbp
  8029c1:	48 83 ec 18          	sub    $0x18,%rsp
  8029c5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8029c8:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8029cb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029cf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029d2:	48 89 d6             	mov    %rdx,%rsi
  8029d5:	89 c7                	mov    %eax,%edi
  8029d7:	48 b8 6d 23 80 00 00 	movabs $0x80236d,%rax
  8029de:	00 00 00 
  8029e1:	ff d0                	callq  *%rax
  8029e3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029ea:	79 05                	jns    8029f1 <seek+0x34>
		return r;
  8029ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029ef:	eb 0f                	jmp    802a00 <seek+0x43>
	fd->fd_offset = offset;
  8029f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029f5:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8029f8:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8029fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a00:	c9                   	leaveq 
  802a01:	c3                   	retq   

0000000000802a02 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802a02:	55                   	push   %rbp
  802a03:	48 89 e5             	mov    %rsp,%rbp
  802a06:	48 83 ec 30          	sub    $0x30,%rsp
  802a0a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a0d:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a10:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a14:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a17:	48 89 d6             	mov    %rdx,%rsi
  802a1a:	89 c7                	mov    %eax,%edi
  802a1c:	48 b8 6d 23 80 00 00 	movabs $0x80236d,%rax
  802a23:	00 00 00 
  802a26:	ff d0                	callq  *%rax
  802a28:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a2b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a2f:	78 24                	js     802a55 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a35:	8b 00                	mov    (%rax),%eax
  802a37:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a3b:	48 89 d6             	mov    %rdx,%rsi
  802a3e:	89 c7                	mov    %eax,%edi
  802a40:	48 b8 c6 24 80 00 00 	movabs $0x8024c6,%rax
  802a47:	00 00 00 
  802a4a:	ff d0                	callq  *%rax
  802a4c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a4f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a53:	79 05                	jns    802a5a <ftruncate+0x58>
		return r;
  802a55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a58:	eb 72                	jmp    802acc <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802a5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a5e:	8b 40 08             	mov    0x8(%rax),%eax
  802a61:	83 e0 03             	and    $0x3,%eax
  802a64:	85 c0                	test   %eax,%eax
  802a66:	75 3a                	jne    802aa2 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802a68:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802a6f:	00 00 00 
  802a72:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802a75:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a7b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a7e:	89 c6                	mov    %eax,%esi
  802a80:	48 bf b0 43 80 00 00 	movabs $0x8043b0,%rdi
  802a87:	00 00 00 
  802a8a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a8f:	48 b9 9c 04 80 00 00 	movabs $0x80049c,%rcx
  802a96:	00 00 00 
  802a99:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802a9b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802aa0:	eb 2a                	jmp    802acc <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802aa2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802aa6:	48 8b 40 30          	mov    0x30(%rax),%rax
  802aaa:	48 85 c0             	test   %rax,%rax
  802aad:	75 07                	jne    802ab6 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802aaf:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ab4:	eb 16                	jmp    802acc <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802ab6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802aba:	48 8b 40 30          	mov    0x30(%rax),%rax
  802abe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ac2:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802ac5:	89 ce                	mov    %ecx,%esi
  802ac7:	48 89 d7             	mov    %rdx,%rdi
  802aca:	ff d0                	callq  *%rax
}
  802acc:	c9                   	leaveq 
  802acd:	c3                   	retq   

0000000000802ace <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802ace:	55                   	push   %rbp
  802acf:	48 89 e5             	mov    %rsp,%rbp
  802ad2:	48 83 ec 30          	sub    $0x30,%rsp
  802ad6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ad9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802add:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ae1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ae4:	48 89 d6             	mov    %rdx,%rsi
  802ae7:	89 c7                	mov    %eax,%edi
  802ae9:	48 b8 6d 23 80 00 00 	movabs $0x80236d,%rax
  802af0:	00 00 00 
  802af3:	ff d0                	callq  *%rax
  802af5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802af8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802afc:	78 24                	js     802b22 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802afe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b02:	8b 00                	mov    (%rax),%eax
  802b04:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b08:	48 89 d6             	mov    %rdx,%rsi
  802b0b:	89 c7                	mov    %eax,%edi
  802b0d:	48 b8 c6 24 80 00 00 	movabs $0x8024c6,%rax
  802b14:	00 00 00 
  802b17:	ff d0                	callq  *%rax
  802b19:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b1c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b20:	79 05                	jns    802b27 <fstat+0x59>
		return r;
  802b22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b25:	eb 5e                	jmp    802b85 <fstat+0xb7>
	if (!dev->dev_stat)
  802b27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b2b:	48 8b 40 28          	mov    0x28(%rax),%rax
  802b2f:	48 85 c0             	test   %rax,%rax
  802b32:	75 07                	jne    802b3b <fstat+0x6d>
		return -E_NOT_SUPP;
  802b34:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b39:	eb 4a                	jmp    802b85 <fstat+0xb7>
	stat->st_name[0] = 0;
  802b3b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b3f:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802b42:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b46:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802b4d:	00 00 00 
	stat->st_isdir = 0;
  802b50:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b54:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802b5b:	00 00 00 
	stat->st_dev = dev;
  802b5e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b62:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b66:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802b6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b71:	48 8b 40 28          	mov    0x28(%rax),%rax
  802b75:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b79:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802b7d:	48 89 ce             	mov    %rcx,%rsi
  802b80:	48 89 d7             	mov    %rdx,%rdi
  802b83:	ff d0                	callq  *%rax
}
  802b85:	c9                   	leaveq 
  802b86:	c3                   	retq   

0000000000802b87 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802b87:	55                   	push   %rbp
  802b88:	48 89 e5             	mov    %rsp,%rbp
  802b8b:	48 83 ec 20          	sub    $0x20,%rsp
  802b8f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b93:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802b97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b9b:	be 00 00 00 00       	mov    $0x0,%esi
  802ba0:	48 89 c7             	mov    %rax,%rdi
  802ba3:	48 b8 75 2c 80 00 00 	movabs $0x802c75,%rax
  802baa:	00 00 00 
  802bad:	ff d0                	callq  *%rax
  802baf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bb2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bb6:	79 05                	jns    802bbd <stat+0x36>
		return fd;
  802bb8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bbb:	eb 2f                	jmp    802bec <stat+0x65>
	r = fstat(fd, stat);
  802bbd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802bc1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bc4:	48 89 d6             	mov    %rdx,%rsi
  802bc7:	89 c7                	mov    %eax,%edi
  802bc9:	48 b8 ce 2a 80 00 00 	movabs $0x802ace,%rax
  802bd0:	00 00 00 
  802bd3:	ff d0                	callq  *%rax
  802bd5:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802bd8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bdb:	89 c7                	mov    %eax,%edi
  802bdd:	48 b8 7d 25 80 00 00 	movabs $0x80257d,%rax
  802be4:	00 00 00 
  802be7:	ff d0                	callq  *%rax
	return r;
  802be9:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802bec:	c9                   	leaveq 
  802bed:	c3                   	retq   

0000000000802bee <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802bee:	55                   	push   %rbp
  802bef:	48 89 e5             	mov    %rsp,%rbp
  802bf2:	48 83 ec 10          	sub    $0x10,%rsp
  802bf6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802bf9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802bfd:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802c04:	00 00 00 
  802c07:	8b 00                	mov    (%rax),%eax
  802c09:	85 c0                	test   %eax,%eax
  802c0b:	75 1d                	jne    802c2a <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802c0d:	bf 01 00 00 00       	mov    $0x1,%edi
  802c12:	48 b8 d4 3b 80 00 00 	movabs $0x803bd4,%rax
  802c19:	00 00 00 
  802c1c:	ff d0                	callq  *%rax
  802c1e:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802c25:	00 00 00 
  802c28:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802c2a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802c31:	00 00 00 
  802c34:	8b 00                	mov    (%rax),%eax
  802c36:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802c39:	b9 07 00 00 00       	mov    $0x7,%ecx
  802c3e:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802c45:	00 00 00 
  802c48:	89 c7                	mov    %eax,%edi
  802c4a:	48 b8 72 3b 80 00 00 	movabs $0x803b72,%rax
  802c51:	00 00 00 
  802c54:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802c56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c5a:	ba 00 00 00 00       	mov    $0x0,%edx
  802c5f:	48 89 c6             	mov    %rax,%rsi
  802c62:	bf 00 00 00 00       	mov    $0x0,%edi
  802c67:	48 b8 6c 3a 80 00 00 	movabs $0x803a6c,%rax
  802c6e:	00 00 00 
  802c71:	ff d0                	callq  *%rax
}
  802c73:	c9                   	leaveq 
  802c74:	c3                   	retq   

0000000000802c75 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802c75:	55                   	push   %rbp
  802c76:	48 89 e5             	mov    %rsp,%rbp
  802c79:	48 83 ec 30          	sub    $0x30,%rsp
  802c7d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802c81:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802c84:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802c8b:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802c92:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802c99:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802c9e:	75 08                	jne    802ca8 <open+0x33>
	{
		return r;
  802ca0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ca3:	e9 f2 00 00 00       	jmpq   802d9a <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802ca8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802cac:	48 89 c7             	mov    %rax,%rdi
  802caf:	48 b8 e5 0f 80 00 00 	movabs $0x800fe5,%rax
  802cb6:	00 00 00 
  802cb9:	ff d0                	callq  *%rax
  802cbb:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802cbe:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802cc5:	7e 0a                	jle    802cd1 <open+0x5c>
	{
		return -E_BAD_PATH;
  802cc7:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802ccc:	e9 c9 00 00 00       	jmpq   802d9a <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802cd1:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802cd8:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802cd9:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802cdd:	48 89 c7             	mov    %rax,%rdi
  802ce0:	48 b8 d5 22 80 00 00 	movabs $0x8022d5,%rax
  802ce7:	00 00 00 
  802cea:	ff d0                	callq  *%rax
  802cec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cf3:	78 09                	js     802cfe <open+0x89>
  802cf5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cf9:	48 85 c0             	test   %rax,%rax
  802cfc:	75 08                	jne    802d06 <open+0x91>
		{
			return r;
  802cfe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d01:	e9 94 00 00 00       	jmpq   802d9a <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802d06:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d0a:	ba 00 04 00 00       	mov    $0x400,%edx
  802d0f:	48 89 c6             	mov    %rax,%rsi
  802d12:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802d19:	00 00 00 
  802d1c:	48 b8 e3 10 80 00 00 	movabs $0x8010e3,%rax
  802d23:	00 00 00 
  802d26:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802d28:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d2f:	00 00 00 
  802d32:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802d35:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802d3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d3f:	48 89 c6             	mov    %rax,%rsi
  802d42:	bf 01 00 00 00       	mov    $0x1,%edi
  802d47:	48 b8 ee 2b 80 00 00 	movabs $0x802bee,%rax
  802d4e:	00 00 00 
  802d51:	ff d0                	callq  *%rax
  802d53:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d56:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d5a:	79 2b                	jns    802d87 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802d5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d60:	be 00 00 00 00       	mov    $0x0,%esi
  802d65:	48 89 c7             	mov    %rax,%rdi
  802d68:	48 b8 fd 23 80 00 00 	movabs $0x8023fd,%rax
  802d6f:	00 00 00 
  802d72:	ff d0                	callq  *%rax
  802d74:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802d77:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802d7b:	79 05                	jns    802d82 <open+0x10d>
			{
				return d;
  802d7d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d80:	eb 18                	jmp    802d9a <open+0x125>
			}
			return r;
  802d82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d85:	eb 13                	jmp    802d9a <open+0x125>
		}	
		return fd2num(fd_store);
  802d87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d8b:	48 89 c7             	mov    %rax,%rdi
  802d8e:	48 b8 87 22 80 00 00 	movabs $0x802287,%rax
  802d95:	00 00 00 
  802d98:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802d9a:	c9                   	leaveq 
  802d9b:	c3                   	retq   

0000000000802d9c <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802d9c:	55                   	push   %rbp
  802d9d:	48 89 e5             	mov    %rsp,%rbp
  802da0:	48 83 ec 10          	sub    $0x10,%rsp
  802da4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802da8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dac:	8b 50 0c             	mov    0xc(%rax),%edx
  802daf:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802db6:	00 00 00 
  802db9:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802dbb:	be 00 00 00 00       	mov    $0x0,%esi
  802dc0:	bf 06 00 00 00       	mov    $0x6,%edi
  802dc5:	48 b8 ee 2b 80 00 00 	movabs $0x802bee,%rax
  802dcc:	00 00 00 
  802dcf:	ff d0                	callq  *%rax
}
  802dd1:	c9                   	leaveq 
  802dd2:	c3                   	retq   

0000000000802dd3 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802dd3:	55                   	push   %rbp
  802dd4:	48 89 e5             	mov    %rsp,%rbp
  802dd7:	48 83 ec 30          	sub    $0x30,%rsp
  802ddb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ddf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802de3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802de7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802dee:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802df3:	74 07                	je     802dfc <devfile_read+0x29>
  802df5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802dfa:	75 07                	jne    802e03 <devfile_read+0x30>
		return -E_INVAL;
  802dfc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e01:	eb 77                	jmp    802e7a <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802e03:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e07:	8b 50 0c             	mov    0xc(%rax),%edx
  802e0a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e11:	00 00 00 
  802e14:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802e16:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e1d:	00 00 00 
  802e20:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e24:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802e28:	be 00 00 00 00       	mov    $0x0,%esi
  802e2d:	bf 03 00 00 00       	mov    $0x3,%edi
  802e32:	48 b8 ee 2b 80 00 00 	movabs $0x802bee,%rax
  802e39:	00 00 00 
  802e3c:	ff d0                	callq  *%rax
  802e3e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e41:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e45:	7f 05                	jg     802e4c <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802e47:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e4a:	eb 2e                	jmp    802e7a <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802e4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e4f:	48 63 d0             	movslq %eax,%rdx
  802e52:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e56:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802e5d:	00 00 00 
  802e60:	48 89 c7             	mov    %rax,%rdi
  802e63:	48 b8 75 13 80 00 00 	movabs $0x801375,%rax
  802e6a:	00 00 00 
  802e6d:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802e6f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e73:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802e77:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802e7a:	c9                   	leaveq 
  802e7b:	c3                   	retq   

0000000000802e7c <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802e7c:	55                   	push   %rbp
  802e7d:	48 89 e5             	mov    %rsp,%rbp
  802e80:	48 83 ec 30          	sub    $0x30,%rsp
  802e84:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e88:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e8c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802e90:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802e97:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802e9c:	74 07                	je     802ea5 <devfile_write+0x29>
  802e9e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802ea3:	75 08                	jne    802ead <devfile_write+0x31>
		return r;
  802ea5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ea8:	e9 9a 00 00 00       	jmpq   802f47 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802ead:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eb1:	8b 50 0c             	mov    0xc(%rax),%edx
  802eb4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ebb:	00 00 00 
  802ebe:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802ec0:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802ec7:	00 
  802ec8:	76 08                	jbe    802ed2 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802eca:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802ed1:	00 
	}
	fsipcbuf.write.req_n = n;
  802ed2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ed9:	00 00 00 
  802edc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ee0:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802ee4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ee8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802eec:	48 89 c6             	mov    %rax,%rsi
  802eef:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802ef6:	00 00 00 
  802ef9:	48 b8 75 13 80 00 00 	movabs $0x801375,%rax
  802f00:	00 00 00 
  802f03:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802f05:	be 00 00 00 00       	mov    $0x0,%esi
  802f0a:	bf 04 00 00 00       	mov    $0x4,%edi
  802f0f:	48 b8 ee 2b 80 00 00 	movabs $0x802bee,%rax
  802f16:	00 00 00 
  802f19:	ff d0                	callq  *%rax
  802f1b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f1e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f22:	7f 20                	jg     802f44 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802f24:	48 bf d6 43 80 00 00 	movabs $0x8043d6,%rdi
  802f2b:	00 00 00 
  802f2e:	b8 00 00 00 00       	mov    $0x0,%eax
  802f33:	48 ba 9c 04 80 00 00 	movabs $0x80049c,%rdx
  802f3a:	00 00 00 
  802f3d:	ff d2                	callq  *%rdx
		return r;
  802f3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f42:	eb 03                	jmp    802f47 <devfile_write+0xcb>
	}
	return r;
  802f44:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802f47:	c9                   	leaveq 
  802f48:	c3                   	retq   

0000000000802f49 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802f49:	55                   	push   %rbp
  802f4a:	48 89 e5             	mov    %rsp,%rbp
  802f4d:	48 83 ec 20          	sub    $0x20,%rsp
  802f51:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f55:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802f59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f5d:	8b 50 0c             	mov    0xc(%rax),%edx
  802f60:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f67:	00 00 00 
  802f6a:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802f6c:	be 00 00 00 00       	mov    $0x0,%esi
  802f71:	bf 05 00 00 00       	mov    $0x5,%edi
  802f76:	48 b8 ee 2b 80 00 00 	movabs $0x802bee,%rax
  802f7d:	00 00 00 
  802f80:	ff d0                	callq  *%rax
  802f82:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f85:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f89:	79 05                	jns    802f90 <devfile_stat+0x47>
		return r;
  802f8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f8e:	eb 56                	jmp    802fe6 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802f90:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f94:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802f9b:	00 00 00 
  802f9e:	48 89 c7             	mov    %rax,%rdi
  802fa1:	48 b8 51 10 80 00 00 	movabs $0x801051,%rax
  802fa8:	00 00 00 
  802fab:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802fad:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fb4:	00 00 00 
  802fb7:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802fbd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fc1:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802fc7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fce:	00 00 00 
  802fd1:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802fd7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fdb:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802fe1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fe6:	c9                   	leaveq 
  802fe7:	c3                   	retq   

0000000000802fe8 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802fe8:	55                   	push   %rbp
  802fe9:	48 89 e5             	mov    %rsp,%rbp
  802fec:	48 83 ec 10          	sub    $0x10,%rsp
  802ff0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802ff4:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802ff7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ffb:	8b 50 0c             	mov    0xc(%rax),%edx
  802ffe:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803005:	00 00 00 
  803008:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80300a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803011:	00 00 00 
  803014:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803017:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80301a:	be 00 00 00 00       	mov    $0x0,%esi
  80301f:	bf 02 00 00 00       	mov    $0x2,%edi
  803024:	48 b8 ee 2b 80 00 00 	movabs $0x802bee,%rax
  80302b:	00 00 00 
  80302e:	ff d0                	callq  *%rax
}
  803030:	c9                   	leaveq 
  803031:	c3                   	retq   

0000000000803032 <remove>:

// Delete a file
int
remove(const char *path)
{
  803032:	55                   	push   %rbp
  803033:	48 89 e5             	mov    %rsp,%rbp
  803036:	48 83 ec 10          	sub    $0x10,%rsp
  80303a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  80303e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803042:	48 89 c7             	mov    %rax,%rdi
  803045:	48 b8 e5 0f 80 00 00 	movabs $0x800fe5,%rax
  80304c:	00 00 00 
  80304f:	ff d0                	callq  *%rax
  803051:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803056:	7e 07                	jle    80305f <remove+0x2d>
		return -E_BAD_PATH;
  803058:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80305d:	eb 33                	jmp    803092 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  80305f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803063:	48 89 c6             	mov    %rax,%rsi
  803066:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80306d:	00 00 00 
  803070:	48 b8 51 10 80 00 00 	movabs $0x801051,%rax
  803077:	00 00 00 
  80307a:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80307c:	be 00 00 00 00       	mov    $0x0,%esi
  803081:	bf 07 00 00 00       	mov    $0x7,%edi
  803086:	48 b8 ee 2b 80 00 00 	movabs $0x802bee,%rax
  80308d:	00 00 00 
  803090:	ff d0                	callq  *%rax
}
  803092:	c9                   	leaveq 
  803093:	c3                   	retq   

0000000000803094 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803094:	55                   	push   %rbp
  803095:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803098:	be 00 00 00 00       	mov    $0x0,%esi
  80309d:	bf 08 00 00 00       	mov    $0x8,%edi
  8030a2:	48 b8 ee 2b 80 00 00 	movabs $0x802bee,%rax
  8030a9:	00 00 00 
  8030ac:	ff d0                	callq  *%rax
}
  8030ae:	5d                   	pop    %rbp
  8030af:	c3                   	retq   

00000000008030b0 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8030b0:	55                   	push   %rbp
  8030b1:	48 89 e5             	mov    %rsp,%rbp
  8030b4:	53                   	push   %rbx
  8030b5:	48 83 ec 38          	sub    $0x38,%rsp
  8030b9:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8030bd:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8030c1:	48 89 c7             	mov    %rax,%rdi
  8030c4:	48 b8 d5 22 80 00 00 	movabs $0x8022d5,%rax
  8030cb:	00 00 00 
  8030ce:	ff d0                	callq  *%rax
  8030d0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8030d3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8030d7:	0f 88 bf 01 00 00    	js     80329c <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8030dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030e1:	ba 07 04 00 00       	mov    $0x407,%edx
  8030e6:	48 89 c6             	mov    %rax,%rsi
  8030e9:	bf 00 00 00 00       	mov    $0x0,%edi
  8030ee:	48 b8 80 19 80 00 00 	movabs $0x801980,%rax
  8030f5:	00 00 00 
  8030f8:	ff d0                	callq  *%rax
  8030fa:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8030fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803101:	0f 88 95 01 00 00    	js     80329c <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803107:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80310b:	48 89 c7             	mov    %rax,%rdi
  80310e:	48 b8 d5 22 80 00 00 	movabs $0x8022d5,%rax
  803115:	00 00 00 
  803118:	ff d0                	callq  *%rax
  80311a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80311d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803121:	0f 88 5d 01 00 00    	js     803284 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803127:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80312b:	ba 07 04 00 00       	mov    $0x407,%edx
  803130:	48 89 c6             	mov    %rax,%rsi
  803133:	bf 00 00 00 00       	mov    $0x0,%edi
  803138:	48 b8 80 19 80 00 00 	movabs $0x801980,%rax
  80313f:	00 00 00 
  803142:	ff d0                	callq  *%rax
  803144:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803147:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80314b:	0f 88 33 01 00 00    	js     803284 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803151:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803155:	48 89 c7             	mov    %rax,%rdi
  803158:	48 b8 aa 22 80 00 00 	movabs $0x8022aa,%rax
  80315f:	00 00 00 
  803162:	ff d0                	callq  *%rax
  803164:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803168:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80316c:	ba 07 04 00 00       	mov    $0x407,%edx
  803171:	48 89 c6             	mov    %rax,%rsi
  803174:	bf 00 00 00 00       	mov    $0x0,%edi
  803179:	48 b8 80 19 80 00 00 	movabs $0x801980,%rax
  803180:	00 00 00 
  803183:	ff d0                	callq  *%rax
  803185:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803188:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80318c:	79 05                	jns    803193 <pipe+0xe3>
		goto err2;
  80318e:	e9 d9 00 00 00       	jmpq   80326c <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803193:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803197:	48 89 c7             	mov    %rax,%rdi
  80319a:	48 b8 aa 22 80 00 00 	movabs $0x8022aa,%rax
  8031a1:	00 00 00 
  8031a4:	ff d0                	callq  *%rax
  8031a6:	48 89 c2             	mov    %rax,%rdx
  8031a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031ad:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8031b3:	48 89 d1             	mov    %rdx,%rcx
  8031b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8031bb:	48 89 c6             	mov    %rax,%rsi
  8031be:	bf 00 00 00 00       	mov    $0x0,%edi
  8031c3:	48 b8 d0 19 80 00 00 	movabs $0x8019d0,%rax
  8031ca:	00 00 00 
  8031cd:	ff d0                	callq  *%rax
  8031cf:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8031d2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8031d6:	79 1b                	jns    8031f3 <pipe+0x143>
		goto err3;
  8031d8:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  8031d9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031dd:	48 89 c6             	mov    %rax,%rsi
  8031e0:	bf 00 00 00 00       	mov    $0x0,%edi
  8031e5:	48 b8 2b 1a 80 00 00 	movabs $0x801a2b,%rax
  8031ec:	00 00 00 
  8031ef:	ff d0                	callq  *%rax
  8031f1:	eb 79                	jmp    80326c <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8031f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031f7:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  8031fe:	00 00 00 
  803201:	8b 12                	mov    (%rdx),%edx
  803203:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803205:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803209:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803210:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803214:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  80321b:	00 00 00 
  80321e:	8b 12                	mov    (%rdx),%edx
  803220:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803222:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803226:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80322d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803231:	48 89 c7             	mov    %rax,%rdi
  803234:	48 b8 87 22 80 00 00 	movabs $0x802287,%rax
  80323b:	00 00 00 
  80323e:	ff d0                	callq  *%rax
  803240:	89 c2                	mov    %eax,%edx
  803242:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803246:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803248:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80324c:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803250:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803254:	48 89 c7             	mov    %rax,%rdi
  803257:	48 b8 87 22 80 00 00 	movabs $0x802287,%rax
  80325e:	00 00 00 
  803261:	ff d0                	callq  *%rax
  803263:	89 03                	mov    %eax,(%rbx)
	return 0;
  803265:	b8 00 00 00 00       	mov    $0x0,%eax
  80326a:	eb 33                	jmp    80329f <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  80326c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803270:	48 89 c6             	mov    %rax,%rsi
  803273:	bf 00 00 00 00       	mov    $0x0,%edi
  803278:	48 b8 2b 1a 80 00 00 	movabs $0x801a2b,%rax
  80327f:	00 00 00 
  803282:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  803284:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803288:	48 89 c6             	mov    %rax,%rsi
  80328b:	bf 00 00 00 00       	mov    $0x0,%edi
  803290:	48 b8 2b 1a 80 00 00 	movabs $0x801a2b,%rax
  803297:	00 00 00 
  80329a:	ff d0                	callq  *%rax
    err:
	return r;
  80329c:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80329f:	48 83 c4 38          	add    $0x38,%rsp
  8032a3:	5b                   	pop    %rbx
  8032a4:	5d                   	pop    %rbp
  8032a5:	c3                   	retq   

00000000008032a6 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8032a6:	55                   	push   %rbp
  8032a7:	48 89 e5             	mov    %rsp,%rbp
  8032aa:	53                   	push   %rbx
  8032ab:	48 83 ec 28          	sub    $0x28,%rsp
  8032af:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8032b3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8032b7:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8032be:	00 00 00 
  8032c1:	48 8b 00             	mov    (%rax),%rax
  8032c4:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8032ca:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8032cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032d1:	48 89 c7             	mov    %rax,%rdi
  8032d4:	48 b8 56 3c 80 00 00 	movabs $0x803c56,%rax
  8032db:	00 00 00 
  8032de:	ff d0                	callq  *%rax
  8032e0:	89 c3                	mov    %eax,%ebx
  8032e2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032e6:	48 89 c7             	mov    %rax,%rdi
  8032e9:	48 b8 56 3c 80 00 00 	movabs $0x803c56,%rax
  8032f0:	00 00 00 
  8032f3:	ff d0                	callq  *%rax
  8032f5:	39 c3                	cmp    %eax,%ebx
  8032f7:	0f 94 c0             	sete   %al
  8032fa:	0f b6 c0             	movzbl %al,%eax
  8032fd:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803300:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803307:	00 00 00 
  80330a:	48 8b 00             	mov    (%rax),%rax
  80330d:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803313:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803316:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803319:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80331c:	75 05                	jne    803323 <_pipeisclosed+0x7d>
			return ret;
  80331e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803321:	eb 4f                	jmp    803372 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803323:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803326:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803329:	74 42                	je     80336d <_pipeisclosed+0xc7>
  80332b:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80332f:	75 3c                	jne    80336d <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803331:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803338:	00 00 00 
  80333b:	48 8b 00             	mov    (%rax),%rax
  80333e:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803344:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803347:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80334a:	89 c6                	mov    %eax,%esi
  80334c:	48 bf f7 43 80 00 00 	movabs $0x8043f7,%rdi
  803353:	00 00 00 
  803356:	b8 00 00 00 00       	mov    $0x0,%eax
  80335b:	49 b8 9c 04 80 00 00 	movabs $0x80049c,%r8
  803362:	00 00 00 
  803365:	41 ff d0             	callq  *%r8
	}
  803368:	e9 4a ff ff ff       	jmpq   8032b7 <_pipeisclosed+0x11>
  80336d:	e9 45 ff ff ff       	jmpq   8032b7 <_pipeisclosed+0x11>
}
  803372:	48 83 c4 28          	add    $0x28,%rsp
  803376:	5b                   	pop    %rbx
  803377:	5d                   	pop    %rbp
  803378:	c3                   	retq   

0000000000803379 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803379:	55                   	push   %rbp
  80337a:	48 89 e5             	mov    %rsp,%rbp
  80337d:	48 83 ec 30          	sub    $0x30,%rsp
  803381:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803384:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803388:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80338b:	48 89 d6             	mov    %rdx,%rsi
  80338e:	89 c7                	mov    %eax,%edi
  803390:	48 b8 6d 23 80 00 00 	movabs $0x80236d,%rax
  803397:	00 00 00 
  80339a:	ff d0                	callq  *%rax
  80339c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80339f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033a3:	79 05                	jns    8033aa <pipeisclosed+0x31>
		return r;
  8033a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033a8:	eb 31                	jmp    8033db <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8033aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033ae:	48 89 c7             	mov    %rax,%rdi
  8033b1:	48 b8 aa 22 80 00 00 	movabs $0x8022aa,%rax
  8033b8:	00 00 00 
  8033bb:	ff d0                	callq  *%rax
  8033bd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8033c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033c5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8033c9:	48 89 d6             	mov    %rdx,%rsi
  8033cc:	48 89 c7             	mov    %rax,%rdi
  8033cf:	48 b8 a6 32 80 00 00 	movabs $0x8032a6,%rax
  8033d6:	00 00 00 
  8033d9:	ff d0                	callq  *%rax
}
  8033db:	c9                   	leaveq 
  8033dc:	c3                   	retq   

00000000008033dd <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8033dd:	55                   	push   %rbp
  8033de:	48 89 e5             	mov    %rsp,%rbp
  8033e1:	48 83 ec 40          	sub    $0x40,%rsp
  8033e5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8033e9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8033ed:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8033f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033f5:	48 89 c7             	mov    %rax,%rdi
  8033f8:	48 b8 aa 22 80 00 00 	movabs $0x8022aa,%rax
  8033ff:	00 00 00 
  803402:	ff d0                	callq  *%rax
  803404:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803408:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80340c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803410:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803417:	00 
  803418:	e9 92 00 00 00       	jmpq   8034af <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80341d:	eb 41                	jmp    803460 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80341f:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803424:	74 09                	je     80342f <devpipe_read+0x52>
				return i;
  803426:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80342a:	e9 92 00 00 00       	jmpq   8034c1 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80342f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803433:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803437:	48 89 d6             	mov    %rdx,%rsi
  80343a:	48 89 c7             	mov    %rax,%rdi
  80343d:	48 b8 a6 32 80 00 00 	movabs $0x8032a6,%rax
  803444:	00 00 00 
  803447:	ff d0                	callq  *%rax
  803449:	85 c0                	test   %eax,%eax
  80344b:	74 07                	je     803454 <devpipe_read+0x77>
				return 0;
  80344d:	b8 00 00 00 00       	mov    $0x0,%eax
  803452:	eb 6d                	jmp    8034c1 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803454:	48 b8 42 19 80 00 00 	movabs $0x801942,%rax
  80345b:	00 00 00 
  80345e:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803460:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803464:	8b 10                	mov    (%rax),%edx
  803466:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80346a:	8b 40 04             	mov    0x4(%rax),%eax
  80346d:	39 c2                	cmp    %eax,%edx
  80346f:	74 ae                	je     80341f <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803471:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803475:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803479:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80347d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803481:	8b 00                	mov    (%rax),%eax
  803483:	99                   	cltd   
  803484:	c1 ea 1b             	shr    $0x1b,%edx
  803487:	01 d0                	add    %edx,%eax
  803489:	83 e0 1f             	and    $0x1f,%eax
  80348c:	29 d0                	sub    %edx,%eax
  80348e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803492:	48 98                	cltq   
  803494:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803499:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80349b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80349f:	8b 00                	mov    (%rax),%eax
  8034a1:	8d 50 01             	lea    0x1(%rax),%edx
  8034a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034a8:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8034aa:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8034af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034b3:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8034b7:	0f 82 60 ff ff ff    	jb     80341d <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8034bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8034c1:	c9                   	leaveq 
  8034c2:	c3                   	retq   

00000000008034c3 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8034c3:	55                   	push   %rbp
  8034c4:	48 89 e5             	mov    %rsp,%rbp
  8034c7:	48 83 ec 40          	sub    $0x40,%rsp
  8034cb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8034cf:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8034d3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8034d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034db:	48 89 c7             	mov    %rax,%rdi
  8034de:	48 b8 aa 22 80 00 00 	movabs $0x8022aa,%rax
  8034e5:	00 00 00 
  8034e8:	ff d0                	callq  *%rax
  8034ea:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8034ee:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034f2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8034f6:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8034fd:	00 
  8034fe:	e9 8e 00 00 00       	jmpq   803591 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803503:	eb 31                	jmp    803536 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803505:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803509:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80350d:	48 89 d6             	mov    %rdx,%rsi
  803510:	48 89 c7             	mov    %rax,%rdi
  803513:	48 b8 a6 32 80 00 00 	movabs $0x8032a6,%rax
  80351a:	00 00 00 
  80351d:	ff d0                	callq  *%rax
  80351f:	85 c0                	test   %eax,%eax
  803521:	74 07                	je     80352a <devpipe_write+0x67>
				return 0;
  803523:	b8 00 00 00 00       	mov    $0x0,%eax
  803528:	eb 79                	jmp    8035a3 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80352a:	48 b8 42 19 80 00 00 	movabs $0x801942,%rax
  803531:	00 00 00 
  803534:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803536:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80353a:	8b 40 04             	mov    0x4(%rax),%eax
  80353d:	48 63 d0             	movslq %eax,%rdx
  803540:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803544:	8b 00                	mov    (%rax),%eax
  803546:	48 98                	cltq   
  803548:	48 83 c0 20          	add    $0x20,%rax
  80354c:	48 39 c2             	cmp    %rax,%rdx
  80354f:	73 b4                	jae    803505 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803551:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803555:	8b 40 04             	mov    0x4(%rax),%eax
  803558:	99                   	cltd   
  803559:	c1 ea 1b             	shr    $0x1b,%edx
  80355c:	01 d0                	add    %edx,%eax
  80355e:	83 e0 1f             	and    $0x1f,%eax
  803561:	29 d0                	sub    %edx,%eax
  803563:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803567:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80356b:	48 01 ca             	add    %rcx,%rdx
  80356e:	0f b6 0a             	movzbl (%rdx),%ecx
  803571:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803575:	48 98                	cltq   
  803577:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80357b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80357f:	8b 40 04             	mov    0x4(%rax),%eax
  803582:	8d 50 01             	lea    0x1(%rax),%edx
  803585:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803589:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80358c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803591:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803595:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803599:	0f 82 64 ff ff ff    	jb     803503 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80359f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8035a3:	c9                   	leaveq 
  8035a4:	c3                   	retq   

00000000008035a5 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8035a5:	55                   	push   %rbp
  8035a6:	48 89 e5             	mov    %rsp,%rbp
  8035a9:	48 83 ec 20          	sub    $0x20,%rsp
  8035ad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8035b1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8035b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035b9:	48 89 c7             	mov    %rax,%rdi
  8035bc:	48 b8 aa 22 80 00 00 	movabs $0x8022aa,%rax
  8035c3:	00 00 00 
  8035c6:	ff d0                	callq  *%rax
  8035c8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8035cc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035d0:	48 be 0a 44 80 00 00 	movabs $0x80440a,%rsi
  8035d7:	00 00 00 
  8035da:	48 89 c7             	mov    %rax,%rdi
  8035dd:	48 b8 51 10 80 00 00 	movabs $0x801051,%rax
  8035e4:	00 00 00 
  8035e7:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8035e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035ed:	8b 50 04             	mov    0x4(%rax),%edx
  8035f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035f4:	8b 00                	mov    (%rax),%eax
  8035f6:	29 c2                	sub    %eax,%edx
  8035f8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035fc:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803602:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803606:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80360d:	00 00 00 
	stat->st_dev = &devpipe;
  803610:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803614:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  80361b:	00 00 00 
  80361e:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803625:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80362a:	c9                   	leaveq 
  80362b:	c3                   	retq   

000000000080362c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80362c:	55                   	push   %rbp
  80362d:	48 89 e5             	mov    %rsp,%rbp
  803630:	48 83 ec 10          	sub    $0x10,%rsp
  803634:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803638:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80363c:	48 89 c6             	mov    %rax,%rsi
  80363f:	bf 00 00 00 00       	mov    $0x0,%edi
  803644:	48 b8 2b 1a 80 00 00 	movabs $0x801a2b,%rax
  80364b:	00 00 00 
  80364e:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803650:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803654:	48 89 c7             	mov    %rax,%rdi
  803657:	48 b8 aa 22 80 00 00 	movabs $0x8022aa,%rax
  80365e:	00 00 00 
  803661:	ff d0                	callq  *%rax
  803663:	48 89 c6             	mov    %rax,%rsi
  803666:	bf 00 00 00 00       	mov    $0x0,%edi
  80366b:	48 b8 2b 1a 80 00 00 	movabs $0x801a2b,%rax
  803672:	00 00 00 
  803675:	ff d0                	callq  *%rax
}
  803677:	c9                   	leaveq 
  803678:	c3                   	retq   

0000000000803679 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803679:	55                   	push   %rbp
  80367a:	48 89 e5             	mov    %rsp,%rbp
  80367d:	48 83 ec 20          	sub    $0x20,%rsp
  803681:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803684:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803687:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80368a:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80368e:	be 01 00 00 00       	mov    $0x1,%esi
  803693:	48 89 c7             	mov    %rax,%rdi
  803696:	48 b8 38 18 80 00 00 	movabs $0x801838,%rax
  80369d:	00 00 00 
  8036a0:	ff d0                	callq  *%rax
}
  8036a2:	c9                   	leaveq 
  8036a3:	c3                   	retq   

00000000008036a4 <getchar>:

int
getchar(void)
{
  8036a4:	55                   	push   %rbp
  8036a5:	48 89 e5             	mov    %rsp,%rbp
  8036a8:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8036ac:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8036b0:	ba 01 00 00 00       	mov    $0x1,%edx
  8036b5:	48 89 c6             	mov    %rax,%rsi
  8036b8:	bf 00 00 00 00       	mov    $0x0,%edi
  8036bd:	48 b8 9f 27 80 00 00 	movabs $0x80279f,%rax
  8036c4:	00 00 00 
  8036c7:	ff d0                	callq  *%rax
  8036c9:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8036cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036d0:	79 05                	jns    8036d7 <getchar+0x33>
		return r;
  8036d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036d5:	eb 14                	jmp    8036eb <getchar+0x47>
	if (r < 1)
  8036d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036db:	7f 07                	jg     8036e4 <getchar+0x40>
		return -E_EOF;
  8036dd:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8036e2:	eb 07                	jmp    8036eb <getchar+0x47>
	return c;
  8036e4:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8036e8:	0f b6 c0             	movzbl %al,%eax
}
  8036eb:	c9                   	leaveq 
  8036ec:	c3                   	retq   

00000000008036ed <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8036ed:	55                   	push   %rbp
  8036ee:	48 89 e5             	mov    %rsp,%rbp
  8036f1:	48 83 ec 20          	sub    $0x20,%rsp
  8036f5:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8036f8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8036fc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036ff:	48 89 d6             	mov    %rdx,%rsi
  803702:	89 c7                	mov    %eax,%edi
  803704:	48 b8 6d 23 80 00 00 	movabs $0x80236d,%rax
  80370b:	00 00 00 
  80370e:	ff d0                	callq  *%rax
  803710:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803713:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803717:	79 05                	jns    80371e <iscons+0x31>
		return r;
  803719:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80371c:	eb 1a                	jmp    803738 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80371e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803722:	8b 10                	mov    (%rax),%edx
  803724:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  80372b:	00 00 00 
  80372e:	8b 00                	mov    (%rax),%eax
  803730:	39 c2                	cmp    %eax,%edx
  803732:	0f 94 c0             	sete   %al
  803735:	0f b6 c0             	movzbl %al,%eax
}
  803738:	c9                   	leaveq 
  803739:	c3                   	retq   

000000000080373a <opencons>:

int
opencons(void)
{
  80373a:	55                   	push   %rbp
  80373b:	48 89 e5             	mov    %rsp,%rbp
  80373e:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803742:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803746:	48 89 c7             	mov    %rax,%rdi
  803749:	48 b8 d5 22 80 00 00 	movabs $0x8022d5,%rax
  803750:	00 00 00 
  803753:	ff d0                	callq  *%rax
  803755:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803758:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80375c:	79 05                	jns    803763 <opencons+0x29>
		return r;
  80375e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803761:	eb 5b                	jmp    8037be <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803763:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803767:	ba 07 04 00 00       	mov    $0x407,%edx
  80376c:	48 89 c6             	mov    %rax,%rsi
  80376f:	bf 00 00 00 00       	mov    $0x0,%edi
  803774:	48 b8 80 19 80 00 00 	movabs $0x801980,%rax
  80377b:	00 00 00 
  80377e:	ff d0                	callq  *%rax
  803780:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803783:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803787:	79 05                	jns    80378e <opencons+0x54>
		return r;
  803789:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80378c:	eb 30                	jmp    8037be <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80378e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803792:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803799:	00 00 00 
  80379c:	8b 12                	mov    (%rdx),%edx
  80379e:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8037a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037a4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8037ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037af:	48 89 c7             	mov    %rax,%rdi
  8037b2:	48 b8 87 22 80 00 00 	movabs $0x802287,%rax
  8037b9:	00 00 00 
  8037bc:	ff d0                	callq  *%rax
}
  8037be:	c9                   	leaveq 
  8037bf:	c3                   	retq   

00000000008037c0 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8037c0:	55                   	push   %rbp
  8037c1:	48 89 e5             	mov    %rsp,%rbp
  8037c4:	48 83 ec 30          	sub    $0x30,%rsp
  8037c8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8037cc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8037d0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8037d4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8037d9:	75 07                	jne    8037e2 <devcons_read+0x22>
		return 0;
  8037db:	b8 00 00 00 00       	mov    $0x0,%eax
  8037e0:	eb 4b                	jmp    80382d <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8037e2:	eb 0c                	jmp    8037f0 <devcons_read+0x30>
		sys_yield();
  8037e4:	48 b8 42 19 80 00 00 	movabs $0x801942,%rax
  8037eb:	00 00 00 
  8037ee:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8037f0:	48 b8 82 18 80 00 00 	movabs $0x801882,%rax
  8037f7:	00 00 00 
  8037fa:	ff d0                	callq  *%rax
  8037fc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803803:	74 df                	je     8037e4 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803805:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803809:	79 05                	jns    803810 <devcons_read+0x50>
		return c;
  80380b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80380e:	eb 1d                	jmp    80382d <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803810:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803814:	75 07                	jne    80381d <devcons_read+0x5d>
		return 0;
  803816:	b8 00 00 00 00       	mov    $0x0,%eax
  80381b:	eb 10                	jmp    80382d <devcons_read+0x6d>
	*(char*)vbuf = c;
  80381d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803820:	89 c2                	mov    %eax,%edx
  803822:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803826:	88 10                	mov    %dl,(%rax)
	return 1;
  803828:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80382d:	c9                   	leaveq 
  80382e:	c3                   	retq   

000000000080382f <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80382f:	55                   	push   %rbp
  803830:	48 89 e5             	mov    %rsp,%rbp
  803833:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80383a:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803841:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803848:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80384f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803856:	eb 76                	jmp    8038ce <devcons_write+0x9f>
		m = n - tot;
  803858:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80385f:	89 c2                	mov    %eax,%edx
  803861:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803864:	29 c2                	sub    %eax,%edx
  803866:	89 d0                	mov    %edx,%eax
  803868:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80386b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80386e:	83 f8 7f             	cmp    $0x7f,%eax
  803871:	76 07                	jbe    80387a <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803873:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80387a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80387d:	48 63 d0             	movslq %eax,%rdx
  803880:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803883:	48 63 c8             	movslq %eax,%rcx
  803886:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80388d:	48 01 c1             	add    %rax,%rcx
  803890:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803897:	48 89 ce             	mov    %rcx,%rsi
  80389a:	48 89 c7             	mov    %rax,%rdi
  80389d:	48 b8 75 13 80 00 00 	movabs $0x801375,%rax
  8038a4:	00 00 00 
  8038a7:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8038a9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038ac:	48 63 d0             	movslq %eax,%rdx
  8038af:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8038b6:	48 89 d6             	mov    %rdx,%rsi
  8038b9:	48 89 c7             	mov    %rax,%rdi
  8038bc:	48 b8 38 18 80 00 00 	movabs $0x801838,%rax
  8038c3:	00 00 00 
  8038c6:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8038c8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038cb:	01 45 fc             	add    %eax,-0x4(%rbp)
  8038ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038d1:	48 98                	cltq   
  8038d3:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8038da:	0f 82 78 ff ff ff    	jb     803858 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8038e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8038e3:	c9                   	leaveq 
  8038e4:	c3                   	retq   

00000000008038e5 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8038e5:	55                   	push   %rbp
  8038e6:	48 89 e5             	mov    %rsp,%rbp
  8038e9:	48 83 ec 08          	sub    $0x8,%rsp
  8038ed:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8038f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8038f6:	c9                   	leaveq 
  8038f7:	c3                   	retq   

00000000008038f8 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8038f8:	55                   	push   %rbp
  8038f9:	48 89 e5             	mov    %rsp,%rbp
  8038fc:	48 83 ec 10          	sub    $0x10,%rsp
  803900:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803904:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803908:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80390c:	48 be 16 44 80 00 00 	movabs $0x804416,%rsi
  803913:	00 00 00 
  803916:	48 89 c7             	mov    %rax,%rdi
  803919:	48 b8 51 10 80 00 00 	movabs $0x801051,%rax
  803920:	00 00 00 
  803923:	ff d0                	callq  *%rax
	return 0;
  803925:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80392a:	c9                   	leaveq 
  80392b:	c3                   	retq   

000000000080392c <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80392c:	55                   	push   %rbp
  80392d:	48 89 e5             	mov    %rsp,%rbp
  803930:	48 83 ec 10          	sub    $0x10,%rsp
  803934:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  803938:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  80393f:	00 00 00 
  803942:	48 8b 00             	mov    (%rax),%rax
  803945:	48 85 c0             	test   %rax,%rax
  803948:	0f 85 84 00 00 00    	jne    8039d2 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  80394e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803955:	00 00 00 
  803958:	48 8b 00             	mov    (%rax),%rax
  80395b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803961:	ba 07 00 00 00       	mov    $0x7,%edx
  803966:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80396b:	89 c7                	mov    %eax,%edi
  80396d:	48 b8 80 19 80 00 00 	movabs $0x801980,%rax
  803974:	00 00 00 
  803977:	ff d0                	callq  *%rax
  803979:	85 c0                	test   %eax,%eax
  80397b:	79 2a                	jns    8039a7 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  80397d:	48 ba 20 44 80 00 00 	movabs $0x804420,%rdx
  803984:	00 00 00 
  803987:	be 23 00 00 00       	mov    $0x23,%esi
  80398c:	48 bf 47 44 80 00 00 	movabs $0x804447,%rdi
  803993:	00 00 00 
  803996:	b8 00 00 00 00       	mov    $0x0,%eax
  80399b:	48 b9 63 02 80 00 00 	movabs $0x800263,%rcx
  8039a2:	00 00 00 
  8039a5:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  8039a7:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8039ae:	00 00 00 
  8039b1:	48 8b 00             	mov    (%rax),%rax
  8039b4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8039ba:	48 be e5 39 80 00 00 	movabs $0x8039e5,%rsi
  8039c1:	00 00 00 
  8039c4:	89 c7                	mov    %eax,%edi
  8039c6:	48 b8 0a 1b 80 00 00 	movabs $0x801b0a,%rax
  8039cd:	00 00 00 
  8039d0:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  8039d2:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8039d9:	00 00 00 
  8039dc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8039e0:	48 89 10             	mov    %rdx,(%rax)
}
  8039e3:	c9                   	leaveq 
  8039e4:	c3                   	retq   

00000000008039e5 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  8039e5:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  8039e8:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  8039ef:	00 00 00 
	call *%rax
  8039f2:	ff d0                	callq  *%rax


	/*This code is to be removed*/

	// LAB 4: Your code here.
	movq 136(%rsp), %rbx  //Load RIP 
  8039f4:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8039fb:	00 
	movq 152(%rsp), %rcx  //Load RSP
  8039fc:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  803a03:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  803a04:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  803a08:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  803a0b:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  803a12:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  803a13:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  803a17:	4c 8b 3c 24          	mov    (%rsp),%r15
  803a1b:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803a20:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803a25:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803a2a:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803a2f:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803a34:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803a39:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803a3e:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803a43:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803a48:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803a4d:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803a52:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803a57:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803a5c:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803a61:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  803a65:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  803a69:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  803a6a:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  803a6b:	c3                   	retq   

0000000000803a6c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803a6c:	55                   	push   %rbp
  803a6d:	48 89 e5             	mov    %rsp,%rbp
  803a70:	48 83 ec 30          	sub    $0x30,%rsp
  803a74:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803a78:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a7c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803a80:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803a87:	00 00 00 
  803a8a:	48 8b 00             	mov    (%rax),%rax
  803a8d:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803a93:	85 c0                	test   %eax,%eax
  803a95:	75 3c                	jne    803ad3 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  803a97:	48 b8 04 19 80 00 00 	movabs $0x801904,%rax
  803a9e:	00 00 00 
  803aa1:	ff d0                	callq  *%rax
  803aa3:	25 ff 03 00 00       	and    $0x3ff,%eax
  803aa8:	48 63 d0             	movslq %eax,%rdx
  803aab:	48 89 d0             	mov    %rdx,%rax
  803aae:	48 c1 e0 03          	shl    $0x3,%rax
  803ab2:	48 01 d0             	add    %rdx,%rax
  803ab5:	48 c1 e0 05          	shl    $0x5,%rax
  803ab9:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803ac0:	00 00 00 
  803ac3:	48 01 c2             	add    %rax,%rdx
  803ac6:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803acd:	00 00 00 
  803ad0:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803ad3:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803ad8:	75 0e                	jne    803ae8 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  803ada:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803ae1:	00 00 00 
  803ae4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803ae8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803aec:	48 89 c7             	mov    %rax,%rdi
  803aef:	48 b8 a9 1b 80 00 00 	movabs $0x801ba9,%rax
  803af6:	00 00 00 
  803af9:	ff d0                	callq  *%rax
  803afb:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803afe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b02:	79 19                	jns    803b1d <ipc_recv+0xb1>
		*from_env_store = 0;
  803b04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b08:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803b0e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b12:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803b18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b1b:	eb 53                	jmp    803b70 <ipc_recv+0x104>
	}
	if(from_env_store)
  803b1d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803b22:	74 19                	je     803b3d <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  803b24:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803b2b:	00 00 00 
  803b2e:	48 8b 00             	mov    (%rax),%rax
  803b31:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803b37:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b3b:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803b3d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803b42:	74 19                	je     803b5d <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  803b44:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803b4b:	00 00 00 
  803b4e:	48 8b 00             	mov    (%rax),%rax
  803b51:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803b57:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b5b:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803b5d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803b64:	00 00 00 
  803b67:	48 8b 00             	mov    (%rax),%rax
  803b6a:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803b70:	c9                   	leaveq 
  803b71:	c3                   	retq   

0000000000803b72 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803b72:	55                   	push   %rbp
  803b73:	48 89 e5             	mov    %rsp,%rbp
  803b76:	48 83 ec 30          	sub    $0x30,%rsp
  803b7a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b7d:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803b80:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803b84:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803b87:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803b8c:	75 0e                	jne    803b9c <ipc_send+0x2a>
		pg = (void*)UTOP;
  803b8e:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803b95:	00 00 00 
  803b98:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  803b9c:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803b9f:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803ba2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803ba6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ba9:	89 c7                	mov    %eax,%edi
  803bab:	48 b8 54 1b 80 00 00 	movabs $0x801b54,%rax
  803bb2:	00 00 00 
  803bb5:	ff d0                	callq  *%rax
  803bb7:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  803bba:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803bbe:	75 0c                	jne    803bcc <ipc_send+0x5a>
			sys_yield();
  803bc0:	48 b8 42 19 80 00 00 	movabs $0x801942,%rax
  803bc7:	00 00 00 
  803bca:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  803bcc:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803bd0:	74 ca                	je     803b9c <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  803bd2:	c9                   	leaveq 
  803bd3:	c3                   	retq   

0000000000803bd4 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803bd4:	55                   	push   %rbp
  803bd5:	48 89 e5             	mov    %rsp,%rbp
  803bd8:	48 83 ec 14          	sub    $0x14,%rsp
  803bdc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  803bdf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803be6:	eb 5e                	jmp    803c46 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803be8:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803bef:	00 00 00 
  803bf2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bf5:	48 63 d0             	movslq %eax,%rdx
  803bf8:	48 89 d0             	mov    %rdx,%rax
  803bfb:	48 c1 e0 03          	shl    $0x3,%rax
  803bff:	48 01 d0             	add    %rdx,%rax
  803c02:	48 c1 e0 05          	shl    $0x5,%rax
  803c06:	48 01 c8             	add    %rcx,%rax
  803c09:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803c0f:	8b 00                	mov    (%rax),%eax
  803c11:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803c14:	75 2c                	jne    803c42 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803c16:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803c1d:	00 00 00 
  803c20:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c23:	48 63 d0             	movslq %eax,%rdx
  803c26:	48 89 d0             	mov    %rdx,%rax
  803c29:	48 c1 e0 03          	shl    $0x3,%rax
  803c2d:	48 01 d0             	add    %rdx,%rax
  803c30:	48 c1 e0 05          	shl    $0x5,%rax
  803c34:	48 01 c8             	add    %rcx,%rax
  803c37:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803c3d:	8b 40 08             	mov    0x8(%rax),%eax
  803c40:	eb 12                	jmp    803c54 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803c42:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803c46:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803c4d:	7e 99                	jle    803be8 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803c4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c54:	c9                   	leaveq 
  803c55:	c3                   	retq   

0000000000803c56 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803c56:	55                   	push   %rbp
  803c57:	48 89 e5             	mov    %rsp,%rbp
  803c5a:	48 83 ec 18          	sub    $0x18,%rsp
  803c5e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803c62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c66:	48 c1 e8 15          	shr    $0x15,%rax
  803c6a:	48 89 c2             	mov    %rax,%rdx
  803c6d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803c74:	01 00 00 
  803c77:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c7b:	83 e0 01             	and    $0x1,%eax
  803c7e:	48 85 c0             	test   %rax,%rax
  803c81:	75 07                	jne    803c8a <pageref+0x34>
		return 0;
  803c83:	b8 00 00 00 00       	mov    $0x0,%eax
  803c88:	eb 53                	jmp    803cdd <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803c8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c8e:	48 c1 e8 0c          	shr    $0xc,%rax
  803c92:	48 89 c2             	mov    %rax,%rdx
  803c95:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803c9c:	01 00 00 
  803c9f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803ca3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803ca7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cab:	83 e0 01             	and    $0x1,%eax
  803cae:	48 85 c0             	test   %rax,%rax
  803cb1:	75 07                	jne    803cba <pageref+0x64>
		return 0;
  803cb3:	b8 00 00 00 00       	mov    $0x0,%eax
  803cb8:	eb 23                	jmp    803cdd <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803cba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cbe:	48 c1 e8 0c          	shr    $0xc,%rax
  803cc2:	48 89 c2             	mov    %rax,%rdx
  803cc5:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803ccc:	00 00 00 
  803ccf:	48 c1 e2 04          	shl    $0x4,%rdx
  803cd3:	48 01 d0             	add    %rdx,%rax
  803cd6:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803cda:	0f b7 c0             	movzwl %ax,%eax
}
  803cdd:	c9                   	leaveq 
  803cde:	c3                   	retq   
