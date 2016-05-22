
obj/user/primes.debug:     file format elf64-x86-64


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
  80003c:	e8 8d 01 00 00       	callq  8001ce <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(void)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
	int i, id, p;
	envid_t envid;
	// fetch a prime from our left neighbor
top:
	p = ipc_recv(&envid, 0, 0);
  80004b:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80004f:	ba 00 00 00 00       	mov    $0x0,%edx
  800054:	be 00 00 00 00       	mov    $0x0,%esi
  800059:	48 89 c7             	mov    %rax,%rdi
  80005c:	48 b8 a0 22 80 00 00 	movabs $0x8022a0,%rax
  800063:	00 00 00 
  800066:	ff d0                	callq  *%rax
  800068:	89 45 fc             	mov    %eax,-0x4(%rbp)
	cprintf("CPU %d: %d", thisenv->env_cpunum, p);
  80006b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800072:	00 00 00 
  800075:	48 8b 00             	mov    (%rax),%rax
  800078:	8b 80 dc 00 00 00    	mov    0xdc(%rax),%eax
  80007e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800081:	89 c6                	mov    %eax,%esi
  800083:	48 bf 00 3d 80 00 00 	movabs $0x803d00,%rdi
  80008a:	00 00 00 
  80008d:	b8 00 00 00 00       	mov    $0x0,%eax
  800092:	48 b9 b5 04 80 00 00 	movabs $0x8004b5,%rcx
  800099:	00 00 00 
  80009c:	ff d1                	callq  *%rcx

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  80009e:	48 b8 ef 1f 80 00 00 	movabs $0x801fef,%rax
  8000a5:	00 00 00 
  8000a8:	ff d0                	callq  *%rax
  8000aa:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000ad:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000b1:	79 30                	jns    8000e3 <primeproc+0xa0>
		panic("fork: %e", id);
  8000b3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000b6:	89 c1                	mov    %eax,%ecx
  8000b8:	48 ba 0b 3d 80 00 00 	movabs $0x803d0b,%rdx
  8000bf:	00 00 00 
  8000c2:	be 19 00 00 00       	mov    $0x19,%esi
  8000c7:	48 bf 14 3d 80 00 00 	movabs $0x803d14,%rdi
  8000ce:	00 00 00 
  8000d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d6:	49 b8 7c 02 80 00 00 	movabs $0x80027c,%r8
  8000dd:	00 00 00 
  8000e0:	41 ff d0             	callq  *%r8
	if (id == 0)
  8000e3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000e7:	75 05                	jne    8000ee <primeproc+0xab>
		goto top;
  8000e9:	e9 5d ff ff ff       	jmpq   80004b <primeproc+0x8>

	// filter out multiples of our prime
	while (1) {
		i = ipc_recv(&envid, 0, 0);
  8000ee:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8000f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8000f7:	be 00 00 00 00       	mov    $0x0,%esi
  8000fc:	48 89 c7             	mov    %rax,%rdi
  8000ff:	48 b8 a0 22 80 00 00 	movabs $0x8022a0,%rax
  800106:	00 00 00 
  800109:	ff d0                	callq  *%rax
  80010b:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if (i % p)
  80010e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800111:	99                   	cltd   
  800112:	f7 7d fc             	idivl  -0x4(%rbp)
  800115:	89 d0                	mov    %edx,%eax
  800117:	85 c0                	test   %eax,%eax
  800119:	74 20                	je     80013b <primeproc+0xf8>
			ipc_send(id, i, 0, 0);
  80011b:	8b 75 f4             	mov    -0xc(%rbp),%esi
  80011e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800121:	b9 00 00 00 00       	mov    $0x0,%ecx
  800126:	ba 00 00 00 00       	mov    $0x0,%edx
  80012b:	89 c7                	mov    %eax,%edi
  80012d:	48 b8 a6 23 80 00 00 	movabs $0x8023a6,%rax
  800134:	00 00 00 
  800137:	ff d0                	callq  *%rax
	}
  800139:	eb b3                	jmp    8000ee <primeproc+0xab>
  80013b:	eb b1                	jmp    8000ee <primeproc+0xab>

000000000080013d <umain>:
}

void
umain(int argc, char **argv)
{
  80013d:	55                   	push   %rbp
  80013e:	48 89 e5             	mov    %rsp,%rbp
  800141:	48 83 ec 20          	sub    $0x20,%rsp
  800145:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800148:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i, id;

	// fork the first prime process in the chain
	if ((id = fork()) < 0)
  80014c:	48 b8 ef 1f 80 00 00 	movabs $0x801fef,%rax
  800153:	00 00 00 
  800156:	ff d0                	callq  *%rax
  800158:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80015b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80015f:	79 30                	jns    800191 <umain+0x54>
		panic("fork: %e", id);
  800161:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800164:	89 c1                	mov    %eax,%ecx
  800166:	48 ba 0b 3d 80 00 00 	movabs $0x803d0b,%rdx
  80016d:	00 00 00 
  800170:	be 2c 00 00 00       	mov    $0x2c,%esi
  800175:	48 bf 14 3d 80 00 00 	movabs $0x803d14,%rdi
  80017c:	00 00 00 
  80017f:	b8 00 00 00 00       	mov    $0x0,%eax
  800184:	49 b8 7c 02 80 00 00 	movabs $0x80027c,%r8
  80018b:	00 00 00 
  80018e:	41 ff d0             	callq  *%r8
	if (id == 0)
  800191:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800195:	75 0c                	jne    8001a3 <umain+0x66>
		primeproc();
  800197:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80019e:	00 00 00 
  8001a1:	ff d0                	callq  *%rax

	// feed all the integers through
	for (i = 2; ; i++)
  8001a3:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%rbp)
		ipc_send(id, i, 0, 0);
  8001aa:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8001ad:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001b0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8001ba:	89 c7                	mov    %eax,%edi
  8001bc:	48 b8 a6 23 80 00 00 	movabs $0x8023a6,%rax
  8001c3:	00 00 00 
  8001c6:	ff d0                	callq  *%rax
		panic("fork: %e", id);
	if (id == 0)
		primeproc();

	// feed all the integers through
	for (i = 2; ; i++)
  8001c8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
		ipc_send(id, i, 0, 0);
  8001cc:	eb dc                	jmp    8001aa <umain+0x6d>

00000000008001ce <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001ce:	55                   	push   %rbp
  8001cf:	48 89 e5             	mov    %rsp,%rbp
  8001d2:	48 83 ec 10          	sub    $0x10,%rsp
  8001d6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001d9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001dd:	48 b8 1d 19 80 00 00 	movabs $0x80191d,%rax
  8001e4:	00 00 00 
  8001e7:	ff d0                	callq  *%rax
  8001e9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001ee:	48 63 d0             	movslq %eax,%rdx
  8001f1:	48 89 d0             	mov    %rdx,%rax
  8001f4:	48 c1 e0 03          	shl    $0x3,%rax
  8001f8:	48 01 d0             	add    %rdx,%rax
  8001fb:	48 c1 e0 05          	shl    $0x5,%rax
  8001ff:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800206:	00 00 00 
  800209:	48 01 c2             	add    %rax,%rdx
  80020c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800213:	00 00 00 
  800216:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800219:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80021d:	7e 14                	jle    800233 <libmain+0x65>
		binaryname = argv[0];
  80021f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800223:	48 8b 10             	mov    (%rax),%rdx
  800226:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80022d:	00 00 00 
  800230:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800233:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800237:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80023a:	48 89 d6             	mov    %rdx,%rsi
  80023d:	89 c7                	mov    %eax,%edi
  80023f:	48 b8 3d 01 80 00 00 	movabs $0x80013d,%rax
  800246:	00 00 00 
  800249:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  80024b:	48 b8 59 02 80 00 00 	movabs $0x800259,%rax
  800252:	00 00 00 
  800255:	ff d0                	callq  *%rax
}
  800257:	c9                   	leaveq 
  800258:	c3                   	retq   

0000000000800259 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800259:	55                   	push   %rbp
  80025a:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80025d:	48 b8 cb 27 80 00 00 	movabs $0x8027cb,%rax
  800264:	00 00 00 
  800267:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800269:	bf 00 00 00 00       	mov    $0x0,%edi
  80026e:	48 b8 d9 18 80 00 00 	movabs $0x8018d9,%rax
  800275:	00 00 00 
  800278:	ff d0                	callq  *%rax

}
  80027a:	5d                   	pop    %rbp
  80027b:	c3                   	retq   

000000000080027c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80027c:	55                   	push   %rbp
  80027d:	48 89 e5             	mov    %rsp,%rbp
  800280:	53                   	push   %rbx
  800281:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800288:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80028f:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800295:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80029c:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8002a3:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8002aa:	84 c0                	test   %al,%al
  8002ac:	74 23                	je     8002d1 <_panic+0x55>
  8002ae:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8002b5:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8002b9:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8002bd:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8002c1:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8002c5:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8002c9:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8002cd:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8002d1:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8002d8:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8002df:	00 00 00 
  8002e2:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8002e9:	00 00 00 
  8002ec:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002f0:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8002f7:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8002fe:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800305:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80030c:	00 00 00 
  80030f:	48 8b 18             	mov    (%rax),%rbx
  800312:	48 b8 1d 19 80 00 00 	movabs $0x80191d,%rax
  800319:	00 00 00 
  80031c:	ff d0                	callq  *%rax
  80031e:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800324:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80032b:	41 89 c8             	mov    %ecx,%r8d
  80032e:	48 89 d1             	mov    %rdx,%rcx
  800331:	48 89 da             	mov    %rbx,%rdx
  800334:	89 c6                	mov    %eax,%esi
  800336:	48 bf 30 3d 80 00 00 	movabs $0x803d30,%rdi
  80033d:	00 00 00 
  800340:	b8 00 00 00 00       	mov    $0x0,%eax
  800345:	49 b9 b5 04 80 00 00 	movabs $0x8004b5,%r9
  80034c:	00 00 00 
  80034f:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800352:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800359:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800360:	48 89 d6             	mov    %rdx,%rsi
  800363:	48 89 c7             	mov    %rax,%rdi
  800366:	48 b8 09 04 80 00 00 	movabs $0x800409,%rax
  80036d:	00 00 00 
  800370:	ff d0                	callq  *%rax
	cprintf("\n");
  800372:	48 bf 53 3d 80 00 00 	movabs $0x803d53,%rdi
  800379:	00 00 00 
  80037c:	b8 00 00 00 00       	mov    $0x0,%eax
  800381:	48 ba b5 04 80 00 00 	movabs $0x8004b5,%rdx
  800388:	00 00 00 
  80038b:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80038d:	cc                   	int3   
  80038e:	eb fd                	jmp    80038d <_panic+0x111>

0000000000800390 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800390:	55                   	push   %rbp
  800391:	48 89 e5             	mov    %rsp,%rbp
  800394:	48 83 ec 10          	sub    $0x10,%rsp
  800398:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80039b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  80039f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003a3:	8b 00                	mov    (%rax),%eax
  8003a5:	8d 48 01             	lea    0x1(%rax),%ecx
  8003a8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003ac:	89 0a                	mov    %ecx,(%rdx)
  8003ae:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8003b1:	89 d1                	mov    %edx,%ecx
  8003b3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003b7:	48 98                	cltq   
  8003b9:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  8003bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003c1:	8b 00                	mov    (%rax),%eax
  8003c3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003c8:	75 2c                	jne    8003f6 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  8003ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003ce:	8b 00                	mov    (%rax),%eax
  8003d0:	48 98                	cltq   
  8003d2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003d6:	48 83 c2 08          	add    $0x8,%rdx
  8003da:	48 89 c6             	mov    %rax,%rsi
  8003dd:	48 89 d7             	mov    %rdx,%rdi
  8003e0:	48 b8 51 18 80 00 00 	movabs $0x801851,%rax
  8003e7:	00 00 00 
  8003ea:	ff d0                	callq  *%rax
		b->idx = 0;
  8003ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003f0:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  8003f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003fa:	8b 40 04             	mov    0x4(%rax),%eax
  8003fd:	8d 50 01             	lea    0x1(%rax),%edx
  800400:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800404:	89 50 04             	mov    %edx,0x4(%rax)
}
  800407:	c9                   	leaveq 
  800408:	c3                   	retq   

0000000000800409 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800409:	55                   	push   %rbp
  80040a:	48 89 e5             	mov    %rsp,%rbp
  80040d:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800414:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80041b:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  800422:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800429:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800430:	48 8b 0a             	mov    (%rdx),%rcx
  800433:	48 89 08             	mov    %rcx,(%rax)
  800436:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80043a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80043e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800442:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  800446:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80044d:	00 00 00 
	b.cnt = 0;
  800450:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800457:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  80045a:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800461:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800468:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80046f:	48 89 c6             	mov    %rax,%rsi
  800472:	48 bf 90 03 80 00 00 	movabs $0x800390,%rdi
  800479:	00 00 00 
  80047c:	48 b8 68 08 80 00 00 	movabs $0x800868,%rax
  800483:	00 00 00 
  800486:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  800488:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80048e:	48 98                	cltq   
  800490:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800497:	48 83 c2 08          	add    $0x8,%rdx
  80049b:	48 89 c6             	mov    %rax,%rsi
  80049e:	48 89 d7             	mov    %rdx,%rdi
  8004a1:	48 b8 51 18 80 00 00 	movabs $0x801851,%rax
  8004a8:	00 00 00 
  8004ab:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  8004ad:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8004b3:	c9                   	leaveq 
  8004b4:	c3                   	retq   

00000000008004b5 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8004b5:	55                   	push   %rbp
  8004b6:	48 89 e5             	mov    %rsp,%rbp
  8004b9:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8004c0:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004c7:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004ce:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004d5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004dc:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004e3:	84 c0                	test   %al,%al
  8004e5:	74 20                	je     800507 <cprintf+0x52>
  8004e7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004eb:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004ef:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004f3:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004f7:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004fb:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004ff:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800503:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800507:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  80050e:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800515:	00 00 00 
  800518:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80051f:	00 00 00 
  800522:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800526:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80052d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800534:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80053b:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800542:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800549:	48 8b 0a             	mov    (%rdx),%rcx
  80054c:	48 89 08             	mov    %rcx,(%rax)
  80054f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800553:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800557:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80055b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  80055f:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800566:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80056d:	48 89 d6             	mov    %rdx,%rsi
  800570:	48 89 c7             	mov    %rax,%rdi
  800573:	48 b8 09 04 80 00 00 	movabs $0x800409,%rax
  80057a:	00 00 00 
  80057d:	ff d0                	callq  *%rax
  80057f:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800585:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80058b:	c9                   	leaveq 
  80058c:	c3                   	retq   

000000000080058d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80058d:	55                   	push   %rbp
  80058e:	48 89 e5             	mov    %rsp,%rbp
  800591:	53                   	push   %rbx
  800592:	48 83 ec 38          	sub    $0x38,%rsp
  800596:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80059a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80059e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8005a2:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8005a5:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8005a9:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005ad:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8005b0:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8005b4:	77 3b                	ja     8005f1 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005b6:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8005b9:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8005bd:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8005c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c9:	48 f7 f3             	div    %rbx
  8005cc:	48 89 c2             	mov    %rax,%rdx
  8005cf:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8005d2:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005d5:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8005d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005dd:	41 89 f9             	mov    %edi,%r9d
  8005e0:	48 89 c7             	mov    %rax,%rdi
  8005e3:	48 b8 8d 05 80 00 00 	movabs $0x80058d,%rax
  8005ea:	00 00 00 
  8005ed:	ff d0                	callq  *%rax
  8005ef:	eb 1e                	jmp    80060f <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005f1:	eb 12                	jmp    800605 <printnum+0x78>
			putch(padc, putdat);
  8005f3:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005f7:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8005fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005fe:	48 89 ce             	mov    %rcx,%rsi
  800601:	89 d7                	mov    %edx,%edi
  800603:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800605:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800609:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80060d:	7f e4                	jg     8005f3 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80060f:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800612:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800616:	ba 00 00 00 00       	mov    $0x0,%edx
  80061b:	48 f7 f1             	div    %rcx
  80061e:	48 89 d0             	mov    %rdx,%rax
  800621:	48 ba 28 3f 80 00 00 	movabs $0x803f28,%rdx
  800628:	00 00 00 
  80062b:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80062f:	0f be d0             	movsbl %al,%edx
  800632:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800636:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80063a:	48 89 ce             	mov    %rcx,%rsi
  80063d:	89 d7                	mov    %edx,%edi
  80063f:	ff d0                	callq  *%rax
}
  800641:	48 83 c4 38          	add    $0x38,%rsp
  800645:	5b                   	pop    %rbx
  800646:	5d                   	pop    %rbp
  800647:	c3                   	retq   

0000000000800648 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800648:	55                   	push   %rbp
  800649:	48 89 e5             	mov    %rsp,%rbp
  80064c:	48 83 ec 1c          	sub    $0x1c,%rsp
  800650:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800654:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800657:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80065b:	7e 52                	jle    8006af <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80065d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800661:	8b 00                	mov    (%rax),%eax
  800663:	83 f8 30             	cmp    $0x30,%eax
  800666:	73 24                	jae    80068c <getuint+0x44>
  800668:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80066c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800670:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800674:	8b 00                	mov    (%rax),%eax
  800676:	89 c0                	mov    %eax,%eax
  800678:	48 01 d0             	add    %rdx,%rax
  80067b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80067f:	8b 12                	mov    (%rdx),%edx
  800681:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800684:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800688:	89 0a                	mov    %ecx,(%rdx)
  80068a:	eb 17                	jmp    8006a3 <getuint+0x5b>
  80068c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800690:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800694:	48 89 d0             	mov    %rdx,%rax
  800697:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80069b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80069f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006a3:	48 8b 00             	mov    (%rax),%rax
  8006a6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006aa:	e9 a3 00 00 00       	jmpq   800752 <getuint+0x10a>
	else if (lflag)
  8006af:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006b3:	74 4f                	je     800704 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8006b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b9:	8b 00                	mov    (%rax),%eax
  8006bb:	83 f8 30             	cmp    $0x30,%eax
  8006be:	73 24                	jae    8006e4 <getuint+0x9c>
  8006c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006cc:	8b 00                	mov    (%rax),%eax
  8006ce:	89 c0                	mov    %eax,%eax
  8006d0:	48 01 d0             	add    %rdx,%rax
  8006d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006d7:	8b 12                	mov    (%rdx),%edx
  8006d9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006dc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006e0:	89 0a                	mov    %ecx,(%rdx)
  8006e2:	eb 17                	jmp    8006fb <getuint+0xb3>
  8006e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006ec:	48 89 d0             	mov    %rdx,%rax
  8006ef:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006f3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006f7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006fb:	48 8b 00             	mov    (%rax),%rax
  8006fe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800702:	eb 4e                	jmp    800752 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800704:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800708:	8b 00                	mov    (%rax),%eax
  80070a:	83 f8 30             	cmp    $0x30,%eax
  80070d:	73 24                	jae    800733 <getuint+0xeb>
  80070f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800713:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800717:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80071b:	8b 00                	mov    (%rax),%eax
  80071d:	89 c0                	mov    %eax,%eax
  80071f:	48 01 d0             	add    %rdx,%rax
  800722:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800726:	8b 12                	mov    (%rdx),%edx
  800728:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80072b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80072f:	89 0a                	mov    %ecx,(%rdx)
  800731:	eb 17                	jmp    80074a <getuint+0x102>
  800733:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800737:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80073b:	48 89 d0             	mov    %rdx,%rax
  80073e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800742:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800746:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80074a:	8b 00                	mov    (%rax),%eax
  80074c:	89 c0                	mov    %eax,%eax
  80074e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800752:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800756:	c9                   	leaveq 
  800757:	c3                   	retq   

0000000000800758 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800758:	55                   	push   %rbp
  800759:	48 89 e5             	mov    %rsp,%rbp
  80075c:	48 83 ec 1c          	sub    $0x1c,%rsp
  800760:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800764:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800767:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80076b:	7e 52                	jle    8007bf <getint+0x67>
		x=va_arg(*ap, long long);
  80076d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800771:	8b 00                	mov    (%rax),%eax
  800773:	83 f8 30             	cmp    $0x30,%eax
  800776:	73 24                	jae    80079c <getint+0x44>
  800778:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80077c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800780:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800784:	8b 00                	mov    (%rax),%eax
  800786:	89 c0                	mov    %eax,%eax
  800788:	48 01 d0             	add    %rdx,%rax
  80078b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80078f:	8b 12                	mov    (%rdx),%edx
  800791:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800794:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800798:	89 0a                	mov    %ecx,(%rdx)
  80079a:	eb 17                	jmp    8007b3 <getint+0x5b>
  80079c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007a4:	48 89 d0             	mov    %rdx,%rax
  8007a7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007ab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007af:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007b3:	48 8b 00             	mov    (%rax),%rax
  8007b6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007ba:	e9 a3 00 00 00       	jmpq   800862 <getint+0x10a>
	else if (lflag)
  8007bf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007c3:	74 4f                	je     800814 <getint+0xbc>
		x=va_arg(*ap, long);
  8007c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c9:	8b 00                	mov    (%rax),%eax
  8007cb:	83 f8 30             	cmp    $0x30,%eax
  8007ce:	73 24                	jae    8007f4 <getint+0x9c>
  8007d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007dc:	8b 00                	mov    (%rax),%eax
  8007de:	89 c0                	mov    %eax,%eax
  8007e0:	48 01 d0             	add    %rdx,%rax
  8007e3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e7:	8b 12                	mov    (%rdx),%edx
  8007e9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007ec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007f0:	89 0a                	mov    %ecx,(%rdx)
  8007f2:	eb 17                	jmp    80080b <getint+0xb3>
  8007f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007fc:	48 89 d0             	mov    %rdx,%rax
  8007ff:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800803:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800807:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80080b:	48 8b 00             	mov    (%rax),%rax
  80080e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800812:	eb 4e                	jmp    800862 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800814:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800818:	8b 00                	mov    (%rax),%eax
  80081a:	83 f8 30             	cmp    $0x30,%eax
  80081d:	73 24                	jae    800843 <getint+0xeb>
  80081f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800823:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800827:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80082b:	8b 00                	mov    (%rax),%eax
  80082d:	89 c0                	mov    %eax,%eax
  80082f:	48 01 d0             	add    %rdx,%rax
  800832:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800836:	8b 12                	mov    (%rdx),%edx
  800838:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80083b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80083f:	89 0a                	mov    %ecx,(%rdx)
  800841:	eb 17                	jmp    80085a <getint+0x102>
  800843:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800847:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80084b:	48 89 d0             	mov    %rdx,%rax
  80084e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800852:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800856:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80085a:	8b 00                	mov    (%rax),%eax
  80085c:	48 98                	cltq   
  80085e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800862:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800866:	c9                   	leaveq 
  800867:	c3                   	retq   

0000000000800868 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800868:	55                   	push   %rbp
  800869:	48 89 e5             	mov    %rsp,%rbp
  80086c:	41 54                	push   %r12
  80086e:	53                   	push   %rbx
  80086f:	48 83 ec 60          	sub    $0x60,%rsp
  800873:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800877:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80087b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80087f:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800883:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800887:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80088b:	48 8b 0a             	mov    (%rdx),%rcx
  80088e:	48 89 08             	mov    %rcx,(%rax)
  800891:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800895:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800899:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80089d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008a1:	eb 17                	jmp    8008ba <vprintfmt+0x52>
			if (ch == '\0')
  8008a3:	85 db                	test   %ebx,%ebx
  8008a5:	0f 84 cc 04 00 00    	je     800d77 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  8008ab:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008af:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008b3:	48 89 d6             	mov    %rdx,%rsi
  8008b6:	89 df                	mov    %ebx,%edi
  8008b8:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008ba:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008be:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008c2:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008c6:	0f b6 00             	movzbl (%rax),%eax
  8008c9:	0f b6 d8             	movzbl %al,%ebx
  8008cc:	83 fb 25             	cmp    $0x25,%ebx
  8008cf:	75 d2                	jne    8008a3 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008d1:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8008d5:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008dc:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008e3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008ea:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008f1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008f5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008f9:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008fd:	0f b6 00             	movzbl (%rax),%eax
  800900:	0f b6 d8             	movzbl %al,%ebx
  800903:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800906:	83 f8 55             	cmp    $0x55,%eax
  800909:	0f 87 34 04 00 00    	ja     800d43 <vprintfmt+0x4db>
  80090f:	89 c0                	mov    %eax,%eax
  800911:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800918:	00 
  800919:	48 b8 50 3f 80 00 00 	movabs $0x803f50,%rax
  800920:	00 00 00 
  800923:	48 01 d0             	add    %rdx,%rax
  800926:	48 8b 00             	mov    (%rax),%rax
  800929:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  80092b:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80092f:	eb c0                	jmp    8008f1 <vprintfmt+0x89>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800931:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800935:	eb ba                	jmp    8008f1 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800937:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80093e:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800941:	89 d0                	mov    %edx,%eax
  800943:	c1 e0 02             	shl    $0x2,%eax
  800946:	01 d0                	add    %edx,%eax
  800948:	01 c0                	add    %eax,%eax
  80094a:	01 d8                	add    %ebx,%eax
  80094c:	83 e8 30             	sub    $0x30,%eax
  80094f:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800952:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800956:	0f b6 00             	movzbl (%rax),%eax
  800959:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80095c:	83 fb 2f             	cmp    $0x2f,%ebx
  80095f:	7e 0c                	jle    80096d <vprintfmt+0x105>
  800961:	83 fb 39             	cmp    $0x39,%ebx
  800964:	7f 07                	jg     80096d <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800966:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80096b:	eb d1                	jmp    80093e <vprintfmt+0xd6>
			goto process_precision;
  80096d:	eb 58                	jmp    8009c7 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  80096f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800972:	83 f8 30             	cmp    $0x30,%eax
  800975:	73 17                	jae    80098e <vprintfmt+0x126>
  800977:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80097b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80097e:	89 c0                	mov    %eax,%eax
  800980:	48 01 d0             	add    %rdx,%rax
  800983:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800986:	83 c2 08             	add    $0x8,%edx
  800989:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80098c:	eb 0f                	jmp    80099d <vprintfmt+0x135>
  80098e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800992:	48 89 d0             	mov    %rdx,%rax
  800995:	48 83 c2 08          	add    $0x8,%rdx
  800999:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80099d:	8b 00                	mov    (%rax),%eax
  80099f:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8009a2:	eb 23                	jmp    8009c7 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8009a4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009a8:	79 0c                	jns    8009b6 <vprintfmt+0x14e>
				width = 0;
  8009aa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8009b1:	e9 3b ff ff ff       	jmpq   8008f1 <vprintfmt+0x89>
  8009b6:	e9 36 ff ff ff       	jmpq   8008f1 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8009bb:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8009c2:	e9 2a ff ff ff       	jmpq   8008f1 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8009c7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009cb:	79 12                	jns    8009df <vprintfmt+0x177>
				width = precision, precision = -1;
  8009cd:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009d0:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8009d3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8009da:	e9 12 ff ff ff       	jmpq   8008f1 <vprintfmt+0x89>
  8009df:	e9 0d ff ff ff       	jmpq   8008f1 <vprintfmt+0x89>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009e4:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009e8:	e9 04 ff ff ff       	jmpq   8008f1 <vprintfmt+0x89>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8009ed:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f0:	83 f8 30             	cmp    $0x30,%eax
  8009f3:	73 17                	jae    800a0c <vprintfmt+0x1a4>
  8009f5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009f9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009fc:	89 c0                	mov    %eax,%eax
  8009fe:	48 01 d0             	add    %rdx,%rax
  800a01:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a04:	83 c2 08             	add    $0x8,%edx
  800a07:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a0a:	eb 0f                	jmp    800a1b <vprintfmt+0x1b3>
  800a0c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a10:	48 89 d0             	mov    %rdx,%rax
  800a13:	48 83 c2 08          	add    $0x8,%rdx
  800a17:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a1b:	8b 10                	mov    (%rax),%edx
  800a1d:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a21:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a25:	48 89 ce             	mov    %rcx,%rsi
  800a28:	89 d7                	mov    %edx,%edi
  800a2a:	ff d0                	callq  *%rax
			break;
  800a2c:	e9 40 03 00 00       	jmpq   800d71 <vprintfmt+0x509>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800a31:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a34:	83 f8 30             	cmp    $0x30,%eax
  800a37:	73 17                	jae    800a50 <vprintfmt+0x1e8>
  800a39:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a3d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a40:	89 c0                	mov    %eax,%eax
  800a42:	48 01 d0             	add    %rdx,%rax
  800a45:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a48:	83 c2 08             	add    $0x8,%edx
  800a4b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a4e:	eb 0f                	jmp    800a5f <vprintfmt+0x1f7>
  800a50:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a54:	48 89 d0             	mov    %rdx,%rax
  800a57:	48 83 c2 08          	add    $0x8,%rdx
  800a5b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a5f:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a61:	85 db                	test   %ebx,%ebx
  800a63:	79 02                	jns    800a67 <vprintfmt+0x1ff>
				err = -err;
  800a65:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a67:	83 fb 10             	cmp    $0x10,%ebx
  800a6a:	7f 16                	jg     800a82 <vprintfmt+0x21a>
  800a6c:	48 b8 a0 3e 80 00 00 	movabs $0x803ea0,%rax
  800a73:	00 00 00 
  800a76:	48 63 d3             	movslq %ebx,%rdx
  800a79:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a7d:	4d 85 e4             	test   %r12,%r12
  800a80:	75 2e                	jne    800ab0 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a82:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a86:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a8a:	89 d9                	mov    %ebx,%ecx
  800a8c:	48 ba 39 3f 80 00 00 	movabs $0x803f39,%rdx
  800a93:	00 00 00 
  800a96:	48 89 c7             	mov    %rax,%rdi
  800a99:	b8 00 00 00 00       	mov    $0x0,%eax
  800a9e:	49 b8 80 0d 80 00 00 	movabs $0x800d80,%r8
  800aa5:	00 00 00 
  800aa8:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800aab:	e9 c1 02 00 00       	jmpq   800d71 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ab0:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ab4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ab8:	4c 89 e1             	mov    %r12,%rcx
  800abb:	48 ba 42 3f 80 00 00 	movabs $0x803f42,%rdx
  800ac2:	00 00 00 
  800ac5:	48 89 c7             	mov    %rax,%rdi
  800ac8:	b8 00 00 00 00       	mov    $0x0,%eax
  800acd:	49 b8 80 0d 80 00 00 	movabs $0x800d80,%r8
  800ad4:	00 00 00 
  800ad7:	41 ff d0             	callq  *%r8
			break;
  800ada:	e9 92 02 00 00       	jmpq   800d71 <vprintfmt+0x509>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800adf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ae2:	83 f8 30             	cmp    $0x30,%eax
  800ae5:	73 17                	jae    800afe <vprintfmt+0x296>
  800ae7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800aeb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aee:	89 c0                	mov    %eax,%eax
  800af0:	48 01 d0             	add    %rdx,%rax
  800af3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800af6:	83 c2 08             	add    $0x8,%edx
  800af9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800afc:	eb 0f                	jmp    800b0d <vprintfmt+0x2a5>
  800afe:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b02:	48 89 d0             	mov    %rdx,%rax
  800b05:	48 83 c2 08          	add    $0x8,%rdx
  800b09:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b0d:	4c 8b 20             	mov    (%rax),%r12
  800b10:	4d 85 e4             	test   %r12,%r12
  800b13:	75 0a                	jne    800b1f <vprintfmt+0x2b7>
				p = "(null)";
  800b15:	49 bc 45 3f 80 00 00 	movabs $0x803f45,%r12
  800b1c:	00 00 00 
			if (width > 0 && padc != '-')
  800b1f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b23:	7e 3f                	jle    800b64 <vprintfmt+0x2fc>
  800b25:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b29:	74 39                	je     800b64 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b2b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b2e:	48 98                	cltq   
  800b30:	48 89 c6             	mov    %rax,%rsi
  800b33:	4c 89 e7             	mov    %r12,%rdi
  800b36:	48 b8 2c 10 80 00 00 	movabs $0x80102c,%rax
  800b3d:	00 00 00 
  800b40:	ff d0                	callq  *%rax
  800b42:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b45:	eb 17                	jmp    800b5e <vprintfmt+0x2f6>
					putch(padc, putdat);
  800b47:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b4b:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b4f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b53:	48 89 ce             	mov    %rcx,%rsi
  800b56:	89 d7                	mov    %edx,%edi
  800b58:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b5a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b5e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b62:	7f e3                	jg     800b47 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b64:	eb 37                	jmp    800b9d <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800b66:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b6a:	74 1e                	je     800b8a <vprintfmt+0x322>
  800b6c:	83 fb 1f             	cmp    $0x1f,%ebx
  800b6f:	7e 05                	jle    800b76 <vprintfmt+0x30e>
  800b71:	83 fb 7e             	cmp    $0x7e,%ebx
  800b74:	7e 14                	jle    800b8a <vprintfmt+0x322>
					putch('?', putdat);
  800b76:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b7a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b7e:	48 89 d6             	mov    %rdx,%rsi
  800b81:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b86:	ff d0                	callq  *%rax
  800b88:	eb 0f                	jmp    800b99 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800b8a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b8e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b92:	48 89 d6             	mov    %rdx,%rsi
  800b95:	89 df                	mov    %ebx,%edi
  800b97:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b99:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b9d:	4c 89 e0             	mov    %r12,%rax
  800ba0:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800ba4:	0f b6 00             	movzbl (%rax),%eax
  800ba7:	0f be d8             	movsbl %al,%ebx
  800baa:	85 db                	test   %ebx,%ebx
  800bac:	74 10                	je     800bbe <vprintfmt+0x356>
  800bae:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bb2:	78 b2                	js     800b66 <vprintfmt+0x2fe>
  800bb4:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800bb8:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bbc:	79 a8                	jns    800b66 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bbe:	eb 16                	jmp    800bd6 <vprintfmt+0x36e>
				putch(' ', putdat);
  800bc0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bc4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bc8:	48 89 d6             	mov    %rdx,%rsi
  800bcb:	bf 20 00 00 00       	mov    $0x20,%edi
  800bd0:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bd2:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bd6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bda:	7f e4                	jg     800bc0 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800bdc:	e9 90 01 00 00       	jmpq   800d71 <vprintfmt+0x509>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800be1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800be5:	be 03 00 00 00       	mov    $0x3,%esi
  800bea:	48 89 c7             	mov    %rax,%rdi
  800bed:	48 b8 58 07 80 00 00 	movabs $0x800758,%rax
  800bf4:	00 00 00 
  800bf7:	ff d0                	callq  *%rax
  800bf9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800bfd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c01:	48 85 c0             	test   %rax,%rax
  800c04:	79 1d                	jns    800c23 <vprintfmt+0x3bb>
				putch('-', putdat);
  800c06:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c0a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c0e:	48 89 d6             	mov    %rdx,%rsi
  800c11:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c16:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c1c:	48 f7 d8             	neg    %rax
  800c1f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c23:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c2a:	e9 d5 00 00 00       	jmpq   800d04 <vprintfmt+0x49c>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c2f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c33:	be 03 00 00 00       	mov    $0x3,%esi
  800c38:	48 89 c7             	mov    %rax,%rdi
  800c3b:	48 b8 48 06 80 00 00 	movabs $0x800648,%rax
  800c42:	00 00 00 
  800c45:	ff d0                	callq  *%rax
  800c47:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c4b:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c52:	e9 ad 00 00 00       	jmpq   800d04 <vprintfmt+0x49c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800c57:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800c5a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c5e:	89 d6                	mov    %edx,%esi
  800c60:	48 89 c7             	mov    %rax,%rdi
  800c63:	48 b8 58 07 80 00 00 	movabs $0x800758,%rax
  800c6a:	00 00 00 
  800c6d:	ff d0                	callq  *%rax
  800c6f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800c73:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800c7a:	e9 85 00 00 00       	jmpq   800d04 <vprintfmt+0x49c>


		// pointer
		case 'p':
			putch('0', putdat);
  800c7f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c83:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c87:	48 89 d6             	mov    %rdx,%rsi
  800c8a:	bf 30 00 00 00       	mov    $0x30,%edi
  800c8f:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c91:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c95:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c99:	48 89 d6             	mov    %rdx,%rsi
  800c9c:	bf 78 00 00 00       	mov    $0x78,%edi
  800ca1:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800ca3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ca6:	83 f8 30             	cmp    $0x30,%eax
  800ca9:	73 17                	jae    800cc2 <vprintfmt+0x45a>
  800cab:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800caf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cb2:	89 c0                	mov    %eax,%eax
  800cb4:	48 01 d0             	add    %rdx,%rax
  800cb7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cba:	83 c2 08             	add    $0x8,%edx
  800cbd:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cc0:	eb 0f                	jmp    800cd1 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800cc2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cc6:	48 89 d0             	mov    %rdx,%rax
  800cc9:	48 83 c2 08          	add    $0x8,%rdx
  800ccd:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cd1:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cd4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800cd8:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800cdf:	eb 23                	jmp    800d04 <vprintfmt+0x49c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800ce1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ce5:	be 03 00 00 00       	mov    $0x3,%esi
  800cea:	48 89 c7             	mov    %rax,%rdi
  800ced:	48 b8 48 06 80 00 00 	movabs $0x800648,%rax
  800cf4:	00 00 00 
  800cf7:	ff d0                	callq  *%rax
  800cf9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800cfd:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d04:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d09:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d0c:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d0f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d13:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d17:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d1b:	45 89 c1             	mov    %r8d,%r9d
  800d1e:	41 89 f8             	mov    %edi,%r8d
  800d21:	48 89 c7             	mov    %rax,%rdi
  800d24:	48 b8 8d 05 80 00 00 	movabs $0x80058d,%rax
  800d2b:	00 00 00 
  800d2e:	ff d0                	callq  *%rax
			break;
  800d30:	eb 3f                	jmp    800d71 <vprintfmt+0x509>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d32:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d36:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d3a:	48 89 d6             	mov    %rdx,%rsi
  800d3d:	89 df                	mov    %ebx,%edi
  800d3f:	ff d0                	callq  *%rax
			break;
  800d41:	eb 2e                	jmp    800d71 <vprintfmt+0x509>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d43:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d47:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d4b:	48 89 d6             	mov    %rdx,%rsi
  800d4e:	bf 25 00 00 00       	mov    $0x25,%edi
  800d53:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d55:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d5a:	eb 05                	jmp    800d61 <vprintfmt+0x4f9>
  800d5c:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d61:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d65:	48 83 e8 01          	sub    $0x1,%rax
  800d69:	0f b6 00             	movzbl (%rax),%eax
  800d6c:	3c 25                	cmp    $0x25,%al
  800d6e:	75 ec                	jne    800d5c <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800d70:	90                   	nop
		}
	}
  800d71:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d72:	e9 43 fb ff ff       	jmpq   8008ba <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  800d77:	48 83 c4 60          	add    $0x60,%rsp
  800d7b:	5b                   	pop    %rbx
  800d7c:	41 5c                	pop    %r12
  800d7e:	5d                   	pop    %rbp
  800d7f:	c3                   	retq   

0000000000800d80 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d80:	55                   	push   %rbp
  800d81:	48 89 e5             	mov    %rsp,%rbp
  800d84:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d8b:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d92:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d99:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800da0:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800da7:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800dae:	84 c0                	test   %al,%al
  800db0:	74 20                	je     800dd2 <printfmt+0x52>
  800db2:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800db6:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800dba:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800dbe:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800dc2:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800dc6:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800dca:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800dce:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800dd2:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800dd9:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800de0:	00 00 00 
  800de3:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800dea:	00 00 00 
  800ded:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800df1:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800df8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800dff:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e06:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e0d:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e14:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e1b:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e22:	48 89 c7             	mov    %rax,%rdi
  800e25:	48 b8 68 08 80 00 00 	movabs $0x800868,%rax
  800e2c:	00 00 00 
  800e2f:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e31:	c9                   	leaveq 
  800e32:	c3                   	retq   

0000000000800e33 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e33:	55                   	push   %rbp
  800e34:	48 89 e5             	mov    %rsp,%rbp
  800e37:	48 83 ec 10          	sub    $0x10,%rsp
  800e3b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e3e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e46:	8b 40 10             	mov    0x10(%rax),%eax
  800e49:	8d 50 01             	lea    0x1(%rax),%edx
  800e4c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e50:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e57:	48 8b 10             	mov    (%rax),%rdx
  800e5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e5e:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e62:	48 39 c2             	cmp    %rax,%rdx
  800e65:	73 17                	jae    800e7e <sprintputch+0x4b>
		*b->buf++ = ch;
  800e67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e6b:	48 8b 00             	mov    (%rax),%rax
  800e6e:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e72:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e76:	48 89 0a             	mov    %rcx,(%rdx)
  800e79:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e7c:	88 10                	mov    %dl,(%rax)
}
  800e7e:	c9                   	leaveq 
  800e7f:	c3                   	retq   

0000000000800e80 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e80:	55                   	push   %rbp
  800e81:	48 89 e5             	mov    %rsp,%rbp
  800e84:	48 83 ec 50          	sub    $0x50,%rsp
  800e88:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e8c:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e8f:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e93:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e97:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800e9b:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800e9f:	48 8b 0a             	mov    (%rdx),%rcx
  800ea2:	48 89 08             	mov    %rcx,(%rax)
  800ea5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ea9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ead:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800eb1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800eb5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800eb9:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800ebd:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800ec0:	48 98                	cltq   
  800ec2:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800ec6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800eca:	48 01 d0             	add    %rdx,%rax
  800ecd:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800ed1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800ed8:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800edd:	74 06                	je     800ee5 <vsnprintf+0x65>
  800edf:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800ee3:	7f 07                	jg     800eec <vsnprintf+0x6c>
		return -E_INVAL;
  800ee5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800eea:	eb 2f                	jmp    800f1b <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800eec:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800ef0:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800ef4:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800ef8:	48 89 c6             	mov    %rax,%rsi
  800efb:	48 bf 33 0e 80 00 00 	movabs $0x800e33,%rdi
  800f02:	00 00 00 
  800f05:	48 b8 68 08 80 00 00 	movabs $0x800868,%rax
  800f0c:	00 00 00 
  800f0f:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f11:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f15:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f18:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f1b:	c9                   	leaveq 
  800f1c:	c3                   	retq   

0000000000800f1d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f1d:	55                   	push   %rbp
  800f1e:	48 89 e5             	mov    %rsp,%rbp
  800f21:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f28:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f2f:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f35:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f3c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f43:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f4a:	84 c0                	test   %al,%al
  800f4c:	74 20                	je     800f6e <snprintf+0x51>
  800f4e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f52:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f56:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f5a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f5e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f62:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f66:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f6a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f6e:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f75:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f7c:	00 00 00 
  800f7f:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f86:	00 00 00 
  800f89:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f8d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f94:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f9b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800fa2:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800fa9:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800fb0:	48 8b 0a             	mov    (%rdx),%rcx
  800fb3:	48 89 08             	mov    %rcx,(%rax)
  800fb6:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fba:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fbe:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fc2:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800fc6:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800fcd:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800fd4:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800fda:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800fe1:	48 89 c7             	mov    %rax,%rdi
  800fe4:	48 b8 80 0e 80 00 00 	movabs $0x800e80,%rax
  800feb:	00 00 00 
  800fee:	ff d0                	callq  *%rax
  800ff0:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800ff6:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800ffc:	c9                   	leaveq 
  800ffd:	c3                   	retq   

0000000000800ffe <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ffe:	55                   	push   %rbp
  800fff:	48 89 e5             	mov    %rsp,%rbp
  801002:	48 83 ec 18          	sub    $0x18,%rsp
  801006:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80100a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801011:	eb 09                	jmp    80101c <strlen+0x1e>
		n++;
  801013:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801017:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80101c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801020:	0f b6 00             	movzbl (%rax),%eax
  801023:	84 c0                	test   %al,%al
  801025:	75 ec                	jne    801013 <strlen+0x15>
		n++;
	return n;
  801027:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80102a:	c9                   	leaveq 
  80102b:	c3                   	retq   

000000000080102c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80102c:	55                   	push   %rbp
  80102d:	48 89 e5             	mov    %rsp,%rbp
  801030:	48 83 ec 20          	sub    $0x20,%rsp
  801034:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801038:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80103c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801043:	eb 0e                	jmp    801053 <strnlen+0x27>
		n++;
  801045:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801049:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80104e:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801053:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801058:	74 0b                	je     801065 <strnlen+0x39>
  80105a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80105e:	0f b6 00             	movzbl (%rax),%eax
  801061:	84 c0                	test   %al,%al
  801063:	75 e0                	jne    801045 <strnlen+0x19>
		n++;
	return n;
  801065:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801068:	c9                   	leaveq 
  801069:	c3                   	retq   

000000000080106a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80106a:	55                   	push   %rbp
  80106b:	48 89 e5             	mov    %rsp,%rbp
  80106e:	48 83 ec 20          	sub    $0x20,%rsp
  801072:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801076:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80107a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80107e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801082:	90                   	nop
  801083:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801087:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80108b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80108f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801093:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801097:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80109b:	0f b6 12             	movzbl (%rdx),%edx
  80109e:	88 10                	mov    %dl,(%rax)
  8010a0:	0f b6 00             	movzbl (%rax),%eax
  8010a3:	84 c0                	test   %al,%al
  8010a5:	75 dc                	jne    801083 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8010a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010ab:	c9                   	leaveq 
  8010ac:	c3                   	retq   

00000000008010ad <strcat>:

char *
strcat(char *dst, const char *src)
{
  8010ad:	55                   	push   %rbp
  8010ae:	48 89 e5             	mov    %rsp,%rbp
  8010b1:	48 83 ec 20          	sub    $0x20,%rsp
  8010b5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010b9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8010bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010c1:	48 89 c7             	mov    %rax,%rdi
  8010c4:	48 b8 fe 0f 80 00 00 	movabs $0x800ffe,%rax
  8010cb:	00 00 00 
  8010ce:	ff d0                	callq  *%rax
  8010d0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8010d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010d6:	48 63 d0             	movslq %eax,%rdx
  8010d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010dd:	48 01 c2             	add    %rax,%rdx
  8010e0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010e4:	48 89 c6             	mov    %rax,%rsi
  8010e7:	48 89 d7             	mov    %rdx,%rdi
  8010ea:	48 b8 6a 10 80 00 00 	movabs $0x80106a,%rax
  8010f1:	00 00 00 
  8010f4:	ff d0                	callq  *%rax
	return dst;
  8010f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8010fa:	c9                   	leaveq 
  8010fb:	c3                   	retq   

00000000008010fc <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8010fc:	55                   	push   %rbp
  8010fd:	48 89 e5             	mov    %rsp,%rbp
  801100:	48 83 ec 28          	sub    $0x28,%rsp
  801104:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801108:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80110c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801110:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801114:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801118:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80111f:	00 
  801120:	eb 2a                	jmp    80114c <strncpy+0x50>
		*dst++ = *src;
  801122:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801126:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80112a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80112e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801132:	0f b6 12             	movzbl (%rdx),%edx
  801135:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801137:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80113b:	0f b6 00             	movzbl (%rax),%eax
  80113e:	84 c0                	test   %al,%al
  801140:	74 05                	je     801147 <strncpy+0x4b>
			src++;
  801142:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801147:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80114c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801150:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801154:	72 cc                	jb     801122 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801156:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80115a:	c9                   	leaveq 
  80115b:	c3                   	retq   

000000000080115c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80115c:	55                   	push   %rbp
  80115d:	48 89 e5             	mov    %rsp,%rbp
  801160:	48 83 ec 28          	sub    $0x28,%rsp
  801164:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801168:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80116c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801170:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801174:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801178:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80117d:	74 3d                	je     8011bc <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80117f:	eb 1d                	jmp    80119e <strlcpy+0x42>
			*dst++ = *src++;
  801181:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801185:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801189:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80118d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801191:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801195:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801199:	0f b6 12             	movzbl (%rdx),%edx
  80119c:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80119e:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8011a3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011a8:	74 0b                	je     8011b5 <strlcpy+0x59>
  8011aa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011ae:	0f b6 00             	movzbl (%rax),%eax
  8011b1:	84 c0                	test   %al,%al
  8011b3:	75 cc                	jne    801181 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8011b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b9:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8011bc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011c4:	48 29 c2             	sub    %rax,%rdx
  8011c7:	48 89 d0             	mov    %rdx,%rax
}
  8011ca:	c9                   	leaveq 
  8011cb:	c3                   	retq   

00000000008011cc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011cc:	55                   	push   %rbp
  8011cd:	48 89 e5             	mov    %rsp,%rbp
  8011d0:	48 83 ec 10          	sub    $0x10,%rsp
  8011d4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011d8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8011dc:	eb 0a                	jmp    8011e8 <strcmp+0x1c>
		p++, q++;
  8011de:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011e3:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ec:	0f b6 00             	movzbl (%rax),%eax
  8011ef:	84 c0                	test   %al,%al
  8011f1:	74 12                	je     801205 <strcmp+0x39>
  8011f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f7:	0f b6 10             	movzbl (%rax),%edx
  8011fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011fe:	0f b6 00             	movzbl (%rax),%eax
  801201:	38 c2                	cmp    %al,%dl
  801203:	74 d9                	je     8011de <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801205:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801209:	0f b6 00             	movzbl (%rax),%eax
  80120c:	0f b6 d0             	movzbl %al,%edx
  80120f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801213:	0f b6 00             	movzbl (%rax),%eax
  801216:	0f b6 c0             	movzbl %al,%eax
  801219:	29 c2                	sub    %eax,%edx
  80121b:	89 d0                	mov    %edx,%eax
}
  80121d:	c9                   	leaveq 
  80121e:	c3                   	retq   

000000000080121f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80121f:	55                   	push   %rbp
  801220:	48 89 e5             	mov    %rsp,%rbp
  801223:	48 83 ec 18          	sub    $0x18,%rsp
  801227:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80122b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80122f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801233:	eb 0f                	jmp    801244 <strncmp+0x25>
		n--, p++, q++;
  801235:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80123a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80123f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801244:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801249:	74 1d                	je     801268 <strncmp+0x49>
  80124b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80124f:	0f b6 00             	movzbl (%rax),%eax
  801252:	84 c0                	test   %al,%al
  801254:	74 12                	je     801268 <strncmp+0x49>
  801256:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80125a:	0f b6 10             	movzbl (%rax),%edx
  80125d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801261:	0f b6 00             	movzbl (%rax),%eax
  801264:	38 c2                	cmp    %al,%dl
  801266:	74 cd                	je     801235 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801268:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80126d:	75 07                	jne    801276 <strncmp+0x57>
		return 0;
  80126f:	b8 00 00 00 00       	mov    $0x0,%eax
  801274:	eb 18                	jmp    80128e <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801276:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80127a:	0f b6 00             	movzbl (%rax),%eax
  80127d:	0f b6 d0             	movzbl %al,%edx
  801280:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801284:	0f b6 00             	movzbl (%rax),%eax
  801287:	0f b6 c0             	movzbl %al,%eax
  80128a:	29 c2                	sub    %eax,%edx
  80128c:	89 d0                	mov    %edx,%eax
}
  80128e:	c9                   	leaveq 
  80128f:	c3                   	retq   

0000000000801290 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801290:	55                   	push   %rbp
  801291:	48 89 e5             	mov    %rsp,%rbp
  801294:	48 83 ec 0c          	sub    $0xc,%rsp
  801298:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80129c:	89 f0                	mov    %esi,%eax
  80129e:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012a1:	eb 17                	jmp    8012ba <strchr+0x2a>
		if (*s == c)
  8012a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a7:	0f b6 00             	movzbl (%rax),%eax
  8012aa:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012ad:	75 06                	jne    8012b5 <strchr+0x25>
			return (char *) s;
  8012af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b3:	eb 15                	jmp    8012ca <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012b5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012be:	0f b6 00             	movzbl (%rax),%eax
  8012c1:	84 c0                	test   %al,%al
  8012c3:	75 de                	jne    8012a3 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8012c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012ca:	c9                   	leaveq 
  8012cb:	c3                   	retq   

00000000008012cc <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012cc:	55                   	push   %rbp
  8012cd:	48 89 e5             	mov    %rsp,%rbp
  8012d0:	48 83 ec 0c          	sub    $0xc,%rsp
  8012d4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012d8:	89 f0                	mov    %esi,%eax
  8012da:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012dd:	eb 13                	jmp    8012f2 <strfind+0x26>
		if (*s == c)
  8012df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e3:	0f b6 00             	movzbl (%rax),%eax
  8012e6:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012e9:	75 02                	jne    8012ed <strfind+0x21>
			break;
  8012eb:	eb 10                	jmp    8012fd <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012ed:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f6:	0f b6 00             	movzbl (%rax),%eax
  8012f9:	84 c0                	test   %al,%al
  8012fb:	75 e2                	jne    8012df <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8012fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801301:	c9                   	leaveq 
  801302:	c3                   	retq   

0000000000801303 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801303:	55                   	push   %rbp
  801304:	48 89 e5             	mov    %rsp,%rbp
  801307:	48 83 ec 18          	sub    $0x18,%rsp
  80130b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80130f:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801312:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801316:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80131b:	75 06                	jne    801323 <memset+0x20>
		return v;
  80131d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801321:	eb 69                	jmp    80138c <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801323:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801327:	83 e0 03             	and    $0x3,%eax
  80132a:	48 85 c0             	test   %rax,%rax
  80132d:	75 48                	jne    801377 <memset+0x74>
  80132f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801333:	83 e0 03             	and    $0x3,%eax
  801336:	48 85 c0             	test   %rax,%rax
  801339:	75 3c                	jne    801377 <memset+0x74>
		c &= 0xFF;
  80133b:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801342:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801345:	c1 e0 18             	shl    $0x18,%eax
  801348:	89 c2                	mov    %eax,%edx
  80134a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80134d:	c1 e0 10             	shl    $0x10,%eax
  801350:	09 c2                	or     %eax,%edx
  801352:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801355:	c1 e0 08             	shl    $0x8,%eax
  801358:	09 d0                	or     %edx,%eax
  80135a:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80135d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801361:	48 c1 e8 02          	shr    $0x2,%rax
  801365:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801368:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80136c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80136f:	48 89 d7             	mov    %rdx,%rdi
  801372:	fc                   	cld    
  801373:	f3 ab                	rep stos %eax,%es:(%rdi)
  801375:	eb 11                	jmp    801388 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801377:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80137b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80137e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801382:	48 89 d7             	mov    %rdx,%rdi
  801385:	fc                   	cld    
  801386:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801388:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80138c:	c9                   	leaveq 
  80138d:	c3                   	retq   

000000000080138e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80138e:	55                   	push   %rbp
  80138f:	48 89 e5             	mov    %rsp,%rbp
  801392:	48 83 ec 28          	sub    $0x28,%rsp
  801396:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80139a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80139e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8013a2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013a6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8013aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ae:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8013b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b6:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013ba:	0f 83 88 00 00 00    	jae    801448 <memmove+0xba>
  8013c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013c4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013c8:	48 01 d0             	add    %rdx,%rax
  8013cb:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013cf:	76 77                	jbe    801448 <memmove+0xba>
		s += n;
  8013d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d5:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8013d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013dd:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e5:	83 e0 03             	and    $0x3,%eax
  8013e8:	48 85 c0             	test   %rax,%rax
  8013eb:	75 3b                	jne    801428 <memmove+0x9a>
  8013ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013f1:	83 e0 03             	and    $0x3,%eax
  8013f4:	48 85 c0             	test   %rax,%rax
  8013f7:	75 2f                	jne    801428 <memmove+0x9a>
  8013f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013fd:	83 e0 03             	and    $0x3,%eax
  801400:	48 85 c0             	test   %rax,%rax
  801403:	75 23                	jne    801428 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801405:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801409:	48 83 e8 04          	sub    $0x4,%rax
  80140d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801411:	48 83 ea 04          	sub    $0x4,%rdx
  801415:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801419:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80141d:	48 89 c7             	mov    %rax,%rdi
  801420:	48 89 d6             	mov    %rdx,%rsi
  801423:	fd                   	std    
  801424:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801426:	eb 1d                	jmp    801445 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801428:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80142c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801430:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801434:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801438:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80143c:	48 89 d7             	mov    %rdx,%rdi
  80143f:	48 89 c1             	mov    %rax,%rcx
  801442:	fd                   	std    
  801443:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801445:	fc                   	cld    
  801446:	eb 57                	jmp    80149f <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801448:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80144c:	83 e0 03             	and    $0x3,%eax
  80144f:	48 85 c0             	test   %rax,%rax
  801452:	75 36                	jne    80148a <memmove+0xfc>
  801454:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801458:	83 e0 03             	and    $0x3,%eax
  80145b:	48 85 c0             	test   %rax,%rax
  80145e:	75 2a                	jne    80148a <memmove+0xfc>
  801460:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801464:	83 e0 03             	and    $0x3,%eax
  801467:	48 85 c0             	test   %rax,%rax
  80146a:	75 1e                	jne    80148a <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80146c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801470:	48 c1 e8 02          	shr    $0x2,%rax
  801474:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801477:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80147b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80147f:	48 89 c7             	mov    %rax,%rdi
  801482:	48 89 d6             	mov    %rdx,%rsi
  801485:	fc                   	cld    
  801486:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801488:	eb 15                	jmp    80149f <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80148a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80148e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801492:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801496:	48 89 c7             	mov    %rax,%rdi
  801499:	48 89 d6             	mov    %rdx,%rsi
  80149c:	fc                   	cld    
  80149d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80149f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014a3:	c9                   	leaveq 
  8014a4:	c3                   	retq   

00000000008014a5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8014a5:	55                   	push   %rbp
  8014a6:	48 89 e5             	mov    %rsp,%rbp
  8014a9:	48 83 ec 18          	sub    $0x18,%rsp
  8014ad:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014b1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014b5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8014b9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014bd:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8014c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c5:	48 89 ce             	mov    %rcx,%rsi
  8014c8:	48 89 c7             	mov    %rax,%rdi
  8014cb:	48 b8 8e 13 80 00 00 	movabs $0x80138e,%rax
  8014d2:	00 00 00 
  8014d5:	ff d0                	callq  *%rax
}
  8014d7:	c9                   	leaveq 
  8014d8:	c3                   	retq   

00000000008014d9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014d9:	55                   	push   %rbp
  8014da:	48 89 e5             	mov    %rsp,%rbp
  8014dd:	48 83 ec 28          	sub    $0x28,%rsp
  8014e1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014e5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014e9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8014ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014f1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8014f5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014f9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8014fd:	eb 36                	jmp    801535 <memcmp+0x5c>
		if (*s1 != *s2)
  8014ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801503:	0f b6 10             	movzbl (%rax),%edx
  801506:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80150a:	0f b6 00             	movzbl (%rax),%eax
  80150d:	38 c2                	cmp    %al,%dl
  80150f:	74 1a                	je     80152b <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801511:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801515:	0f b6 00             	movzbl (%rax),%eax
  801518:	0f b6 d0             	movzbl %al,%edx
  80151b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80151f:	0f b6 00             	movzbl (%rax),%eax
  801522:	0f b6 c0             	movzbl %al,%eax
  801525:	29 c2                	sub    %eax,%edx
  801527:	89 d0                	mov    %edx,%eax
  801529:	eb 20                	jmp    80154b <memcmp+0x72>
		s1++, s2++;
  80152b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801530:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801535:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801539:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80153d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801541:	48 85 c0             	test   %rax,%rax
  801544:	75 b9                	jne    8014ff <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801546:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80154b:	c9                   	leaveq 
  80154c:	c3                   	retq   

000000000080154d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80154d:	55                   	push   %rbp
  80154e:	48 89 e5             	mov    %rsp,%rbp
  801551:	48 83 ec 28          	sub    $0x28,%rsp
  801555:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801559:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80155c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801560:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801564:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801568:	48 01 d0             	add    %rdx,%rax
  80156b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80156f:	eb 15                	jmp    801586 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801571:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801575:	0f b6 10             	movzbl (%rax),%edx
  801578:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80157b:	38 c2                	cmp    %al,%dl
  80157d:	75 02                	jne    801581 <memfind+0x34>
			break;
  80157f:	eb 0f                	jmp    801590 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801581:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801586:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80158a:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80158e:	72 e1                	jb     801571 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801590:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801594:	c9                   	leaveq 
  801595:	c3                   	retq   

0000000000801596 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801596:	55                   	push   %rbp
  801597:	48 89 e5             	mov    %rsp,%rbp
  80159a:	48 83 ec 34          	sub    $0x34,%rsp
  80159e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015a2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8015a6:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8015a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8015b0:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8015b7:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015b8:	eb 05                	jmp    8015bf <strtol+0x29>
		s++;
  8015ba:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c3:	0f b6 00             	movzbl (%rax),%eax
  8015c6:	3c 20                	cmp    $0x20,%al
  8015c8:	74 f0                	je     8015ba <strtol+0x24>
  8015ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ce:	0f b6 00             	movzbl (%rax),%eax
  8015d1:	3c 09                	cmp    $0x9,%al
  8015d3:	74 e5                	je     8015ba <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d9:	0f b6 00             	movzbl (%rax),%eax
  8015dc:	3c 2b                	cmp    $0x2b,%al
  8015de:	75 07                	jne    8015e7 <strtol+0x51>
		s++;
  8015e0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015e5:	eb 17                	jmp    8015fe <strtol+0x68>
	else if (*s == '-')
  8015e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015eb:	0f b6 00             	movzbl (%rax),%eax
  8015ee:	3c 2d                	cmp    $0x2d,%al
  8015f0:	75 0c                	jne    8015fe <strtol+0x68>
		s++, neg = 1;
  8015f2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015f7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015fe:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801602:	74 06                	je     80160a <strtol+0x74>
  801604:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801608:	75 28                	jne    801632 <strtol+0x9c>
  80160a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80160e:	0f b6 00             	movzbl (%rax),%eax
  801611:	3c 30                	cmp    $0x30,%al
  801613:	75 1d                	jne    801632 <strtol+0x9c>
  801615:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801619:	48 83 c0 01          	add    $0x1,%rax
  80161d:	0f b6 00             	movzbl (%rax),%eax
  801620:	3c 78                	cmp    $0x78,%al
  801622:	75 0e                	jne    801632 <strtol+0x9c>
		s += 2, base = 16;
  801624:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801629:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801630:	eb 2c                	jmp    80165e <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801632:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801636:	75 19                	jne    801651 <strtol+0xbb>
  801638:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163c:	0f b6 00             	movzbl (%rax),%eax
  80163f:	3c 30                	cmp    $0x30,%al
  801641:	75 0e                	jne    801651 <strtol+0xbb>
		s++, base = 8;
  801643:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801648:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80164f:	eb 0d                	jmp    80165e <strtol+0xc8>
	else if (base == 0)
  801651:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801655:	75 07                	jne    80165e <strtol+0xc8>
		base = 10;
  801657:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80165e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801662:	0f b6 00             	movzbl (%rax),%eax
  801665:	3c 2f                	cmp    $0x2f,%al
  801667:	7e 1d                	jle    801686 <strtol+0xf0>
  801669:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166d:	0f b6 00             	movzbl (%rax),%eax
  801670:	3c 39                	cmp    $0x39,%al
  801672:	7f 12                	jg     801686 <strtol+0xf0>
			dig = *s - '0';
  801674:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801678:	0f b6 00             	movzbl (%rax),%eax
  80167b:	0f be c0             	movsbl %al,%eax
  80167e:	83 e8 30             	sub    $0x30,%eax
  801681:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801684:	eb 4e                	jmp    8016d4 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801686:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80168a:	0f b6 00             	movzbl (%rax),%eax
  80168d:	3c 60                	cmp    $0x60,%al
  80168f:	7e 1d                	jle    8016ae <strtol+0x118>
  801691:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801695:	0f b6 00             	movzbl (%rax),%eax
  801698:	3c 7a                	cmp    $0x7a,%al
  80169a:	7f 12                	jg     8016ae <strtol+0x118>
			dig = *s - 'a' + 10;
  80169c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a0:	0f b6 00             	movzbl (%rax),%eax
  8016a3:	0f be c0             	movsbl %al,%eax
  8016a6:	83 e8 57             	sub    $0x57,%eax
  8016a9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016ac:	eb 26                	jmp    8016d4 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8016ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b2:	0f b6 00             	movzbl (%rax),%eax
  8016b5:	3c 40                	cmp    $0x40,%al
  8016b7:	7e 48                	jle    801701 <strtol+0x16b>
  8016b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016bd:	0f b6 00             	movzbl (%rax),%eax
  8016c0:	3c 5a                	cmp    $0x5a,%al
  8016c2:	7f 3d                	jg     801701 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8016c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c8:	0f b6 00             	movzbl (%rax),%eax
  8016cb:	0f be c0             	movsbl %al,%eax
  8016ce:	83 e8 37             	sub    $0x37,%eax
  8016d1:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8016d4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016d7:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8016da:	7c 02                	jl     8016de <strtol+0x148>
			break;
  8016dc:	eb 23                	jmp    801701 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8016de:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016e3:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8016e6:	48 98                	cltq   
  8016e8:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8016ed:	48 89 c2             	mov    %rax,%rdx
  8016f0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016f3:	48 98                	cltq   
  8016f5:	48 01 d0             	add    %rdx,%rax
  8016f8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8016fc:	e9 5d ff ff ff       	jmpq   80165e <strtol+0xc8>

	if (endptr)
  801701:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801706:	74 0b                	je     801713 <strtol+0x17d>
		*endptr = (char *) s;
  801708:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80170c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801710:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801713:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801717:	74 09                	je     801722 <strtol+0x18c>
  801719:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80171d:	48 f7 d8             	neg    %rax
  801720:	eb 04                	jmp    801726 <strtol+0x190>
  801722:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801726:	c9                   	leaveq 
  801727:	c3                   	retq   

0000000000801728 <strstr>:

char * strstr(const char *in, const char *str)
{
  801728:	55                   	push   %rbp
  801729:	48 89 e5             	mov    %rsp,%rbp
  80172c:	48 83 ec 30          	sub    $0x30,%rsp
  801730:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801734:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801738:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80173c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801740:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801744:	0f b6 00             	movzbl (%rax),%eax
  801747:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  80174a:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80174e:	75 06                	jne    801756 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  801750:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801754:	eb 6b                	jmp    8017c1 <strstr+0x99>

    len = strlen(str);
  801756:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80175a:	48 89 c7             	mov    %rax,%rdi
  80175d:	48 b8 fe 0f 80 00 00 	movabs $0x800ffe,%rax
  801764:	00 00 00 
  801767:	ff d0                	callq  *%rax
  801769:	48 98                	cltq   
  80176b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  80176f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801773:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801777:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80177b:	0f b6 00             	movzbl (%rax),%eax
  80177e:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  801781:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801785:	75 07                	jne    80178e <strstr+0x66>
                return (char *) 0;
  801787:	b8 00 00 00 00       	mov    $0x0,%eax
  80178c:	eb 33                	jmp    8017c1 <strstr+0x99>
        } while (sc != c);
  80178e:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801792:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801795:	75 d8                	jne    80176f <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  801797:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80179b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80179f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a3:	48 89 ce             	mov    %rcx,%rsi
  8017a6:	48 89 c7             	mov    %rax,%rdi
  8017a9:	48 b8 1f 12 80 00 00 	movabs $0x80121f,%rax
  8017b0:	00 00 00 
  8017b3:	ff d0                	callq  *%rax
  8017b5:	85 c0                	test   %eax,%eax
  8017b7:	75 b6                	jne    80176f <strstr+0x47>

    return (char *) (in - 1);
  8017b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017bd:	48 83 e8 01          	sub    $0x1,%rax
}
  8017c1:	c9                   	leaveq 
  8017c2:	c3                   	retq   

00000000008017c3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8017c3:	55                   	push   %rbp
  8017c4:	48 89 e5             	mov    %rsp,%rbp
  8017c7:	53                   	push   %rbx
  8017c8:	48 83 ec 48          	sub    $0x48,%rsp
  8017cc:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8017cf:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8017d2:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017d6:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8017da:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8017de:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017e2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017e5:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8017e9:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8017ed:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8017f1:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8017f5:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8017f9:	4c 89 c3             	mov    %r8,%rbx
  8017fc:	cd 30                	int    $0x30
  8017fe:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801802:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801806:	74 3e                	je     801846 <syscall+0x83>
  801808:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80180d:	7e 37                	jle    801846 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80180f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801813:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801816:	49 89 d0             	mov    %rdx,%r8
  801819:	89 c1                	mov    %eax,%ecx
  80181b:	48 ba 00 42 80 00 00 	movabs $0x804200,%rdx
  801822:	00 00 00 
  801825:	be 23 00 00 00       	mov    $0x23,%esi
  80182a:	48 bf 1d 42 80 00 00 	movabs $0x80421d,%rdi
  801831:	00 00 00 
  801834:	b8 00 00 00 00       	mov    $0x0,%eax
  801839:	49 b9 7c 02 80 00 00 	movabs $0x80027c,%r9
  801840:	00 00 00 
  801843:	41 ff d1             	callq  *%r9

	return ret;
  801846:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80184a:	48 83 c4 48          	add    $0x48,%rsp
  80184e:	5b                   	pop    %rbx
  80184f:	5d                   	pop    %rbp
  801850:	c3                   	retq   

0000000000801851 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801851:	55                   	push   %rbp
  801852:	48 89 e5             	mov    %rsp,%rbp
  801855:	48 83 ec 20          	sub    $0x20,%rsp
  801859:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80185d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801861:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801865:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801869:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801870:	00 
  801871:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801877:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80187d:	48 89 d1             	mov    %rdx,%rcx
  801880:	48 89 c2             	mov    %rax,%rdx
  801883:	be 00 00 00 00       	mov    $0x0,%esi
  801888:	bf 00 00 00 00       	mov    $0x0,%edi
  80188d:	48 b8 c3 17 80 00 00 	movabs $0x8017c3,%rax
  801894:	00 00 00 
  801897:	ff d0                	callq  *%rax
}
  801899:	c9                   	leaveq 
  80189a:	c3                   	retq   

000000000080189b <sys_cgetc>:

int
sys_cgetc(void)
{
  80189b:	55                   	push   %rbp
  80189c:	48 89 e5             	mov    %rsp,%rbp
  80189f:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8018a3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018aa:	00 
  8018ab:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018b1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018b7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8018c1:	be 00 00 00 00       	mov    $0x0,%esi
  8018c6:	bf 01 00 00 00       	mov    $0x1,%edi
  8018cb:	48 b8 c3 17 80 00 00 	movabs $0x8017c3,%rax
  8018d2:	00 00 00 
  8018d5:	ff d0                	callq  *%rax
}
  8018d7:	c9                   	leaveq 
  8018d8:	c3                   	retq   

00000000008018d9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8018d9:	55                   	push   %rbp
  8018da:	48 89 e5             	mov    %rsp,%rbp
  8018dd:	48 83 ec 10          	sub    $0x10,%rsp
  8018e1:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8018e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018e7:	48 98                	cltq   
  8018e9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018f0:	00 
  8018f1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018f7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018fd:	b9 00 00 00 00       	mov    $0x0,%ecx
  801902:	48 89 c2             	mov    %rax,%rdx
  801905:	be 01 00 00 00       	mov    $0x1,%esi
  80190a:	bf 03 00 00 00       	mov    $0x3,%edi
  80190f:	48 b8 c3 17 80 00 00 	movabs $0x8017c3,%rax
  801916:	00 00 00 
  801919:	ff d0                	callq  *%rax
}
  80191b:	c9                   	leaveq 
  80191c:	c3                   	retq   

000000000080191d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80191d:	55                   	push   %rbp
  80191e:	48 89 e5             	mov    %rsp,%rbp
  801921:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801925:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80192c:	00 
  80192d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801933:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801939:	b9 00 00 00 00       	mov    $0x0,%ecx
  80193e:	ba 00 00 00 00       	mov    $0x0,%edx
  801943:	be 00 00 00 00       	mov    $0x0,%esi
  801948:	bf 02 00 00 00       	mov    $0x2,%edi
  80194d:	48 b8 c3 17 80 00 00 	movabs $0x8017c3,%rax
  801954:	00 00 00 
  801957:	ff d0                	callq  *%rax
}
  801959:	c9                   	leaveq 
  80195a:	c3                   	retq   

000000000080195b <sys_yield>:

void
sys_yield(void)
{
  80195b:	55                   	push   %rbp
  80195c:	48 89 e5             	mov    %rsp,%rbp
  80195f:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801963:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80196a:	00 
  80196b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801971:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801977:	b9 00 00 00 00       	mov    $0x0,%ecx
  80197c:	ba 00 00 00 00       	mov    $0x0,%edx
  801981:	be 00 00 00 00       	mov    $0x0,%esi
  801986:	bf 0b 00 00 00       	mov    $0xb,%edi
  80198b:	48 b8 c3 17 80 00 00 	movabs $0x8017c3,%rax
  801992:	00 00 00 
  801995:	ff d0                	callq  *%rax
}
  801997:	c9                   	leaveq 
  801998:	c3                   	retq   

0000000000801999 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801999:	55                   	push   %rbp
  80199a:	48 89 e5             	mov    %rsp,%rbp
  80199d:	48 83 ec 20          	sub    $0x20,%rsp
  8019a1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019a4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019a8:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8019ab:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019ae:	48 63 c8             	movslq %eax,%rcx
  8019b1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019b8:	48 98                	cltq   
  8019ba:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019c1:	00 
  8019c2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019c8:	49 89 c8             	mov    %rcx,%r8
  8019cb:	48 89 d1             	mov    %rdx,%rcx
  8019ce:	48 89 c2             	mov    %rax,%rdx
  8019d1:	be 01 00 00 00       	mov    $0x1,%esi
  8019d6:	bf 04 00 00 00       	mov    $0x4,%edi
  8019db:	48 b8 c3 17 80 00 00 	movabs $0x8017c3,%rax
  8019e2:	00 00 00 
  8019e5:	ff d0                	callq  *%rax
}
  8019e7:	c9                   	leaveq 
  8019e8:	c3                   	retq   

00000000008019e9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8019e9:	55                   	push   %rbp
  8019ea:	48 89 e5             	mov    %rsp,%rbp
  8019ed:	48 83 ec 30          	sub    $0x30,%rsp
  8019f1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019f4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019f8:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8019fb:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8019ff:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801a03:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a06:	48 63 c8             	movslq %eax,%rcx
  801a09:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a0d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a10:	48 63 f0             	movslq %eax,%rsi
  801a13:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a17:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a1a:	48 98                	cltq   
  801a1c:	48 89 0c 24          	mov    %rcx,(%rsp)
  801a20:	49 89 f9             	mov    %rdi,%r9
  801a23:	49 89 f0             	mov    %rsi,%r8
  801a26:	48 89 d1             	mov    %rdx,%rcx
  801a29:	48 89 c2             	mov    %rax,%rdx
  801a2c:	be 01 00 00 00       	mov    $0x1,%esi
  801a31:	bf 05 00 00 00       	mov    $0x5,%edi
  801a36:	48 b8 c3 17 80 00 00 	movabs $0x8017c3,%rax
  801a3d:	00 00 00 
  801a40:	ff d0                	callq  *%rax
}
  801a42:	c9                   	leaveq 
  801a43:	c3                   	retq   

0000000000801a44 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a44:	55                   	push   %rbp
  801a45:	48 89 e5             	mov    %rsp,%rbp
  801a48:	48 83 ec 20          	sub    $0x20,%rsp
  801a4c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a4f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a53:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a57:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a5a:	48 98                	cltq   
  801a5c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a63:	00 
  801a64:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a6a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a70:	48 89 d1             	mov    %rdx,%rcx
  801a73:	48 89 c2             	mov    %rax,%rdx
  801a76:	be 01 00 00 00       	mov    $0x1,%esi
  801a7b:	bf 06 00 00 00       	mov    $0x6,%edi
  801a80:	48 b8 c3 17 80 00 00 	movabs $0x8017c3,%rax
  801a87:	00 00 00 
  801a8a:	ff d0                	callq  *%rax
}
  801a8c:	c9                   	leaveq 
  801a8d:	c3                   	retq   

0000000000801a8e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a8e:	55                   	push   %rbp
  801a8f:	48 89 e5             	mov    %rsp,%rbp
  801a92:	48 83 ec 10          	sub    $0x10,%rsp
  801a96:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a99:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801a9c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a9f:	48 63 d0             	movslq %eax,%rdx
  801aa2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aa5:	48 98                	cltq   
  801aa7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aae:	00 
  801aaf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ab5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801abb:	48 89 d1             	mov    %rdx,%rcx
  801abe:	48 89 c2             	mov    %rax,%rdx
  801ac1:	be 01 00 00 00       	mov    $0x1,%esi
  801ac6:	bf 08 00 00 00       	mov    $0x8,%edi
  801acb:	48 b8 c3 17 80 00 00 	movabs $0x8017c3,%rax
  801ad2:	00 00 00 
  801ad5:	ff d0                	callq  *%rax
}
  801ad7:	c9                   	leaveq 
  801ad8:	c3                   	retq   

0000000000801ad9 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801ad9:	55                   	push   %rbp
  801ada:	48 89 e5             	mov    %rsp,%rbp
  801add:	48 83 ec 20          	sub    $0x20,%rsp
  801ae1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ae4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801ae8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aef:	48 98                	cltq   
  801af1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801af8:	00 
  801af9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aff:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b05:	48 89 d1             	mov    %rdx,%rcx
  801b08:	48 89 c2             	mov    %rax,%rdx
  801b0b:	be 01 00 00 00       	mov    $0x1,%esi
  801b10:	bf 09 00 00 00       	mov    $0x9,%edi
  801b15:	48 b8 c3 17 80 00 00 	movabs $0x8017c3,%rax
  801b1c:	00 00 00 
  801b1f:	ff d0                	callq  *%rax
}
  801b21:	c9                   	leaveq 
  801b22:	c3                   	retq   

0000000000801b23 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801b23:	55                   	push   %rbp
  801b24:	48 89 e5             	mov    %rsp,%rbp
  801b27:	48 83 ec 20          	sub    $0x20,%rsp
  801b2b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b2e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801b32:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b39:	48 98                	cltq   
  801b3b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b42:	00 
  801b43:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b49:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b4f:	48 89 d1             	mov    %rdx,%rcx
  801b52:	48 89 c2             	mov    %rax,%rdx
  801b55:	be 01 00 00 00       	mov    $0x1,%esi
  801b5a:	bf 0a 00 00 00       	mov    $0xa,%edi
  801b5f:	48 b8 c3 17 80 00 00 	movabs $0x8017c3,%rax
  801b66:	00 00 00 
  801b69:	ff d0                	callq  *%rax
}
  801b6b:	c9                   	leaveq 
  801b6c:	c3                   	retq   

0000000000801b6d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801b6d:	55                   	push   %rbp
  801b6e:	48 89 e5             	mov    %rsp,%rbp
  801b71:	48 83 ec 20          	sub    $0x20,%rsp
  801b75:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b78:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b7c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b80:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b83:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b86:	48 63 f0             	movslq %eax,%rsi
  801b89:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801b8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b90:	48 98                	cltq   
  801b92:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b96:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b9d:	00 
  801b9e:	49 89 f1             	mov    %rsi,%r9
  801ba1:	49 89 c8             	mov    %rcx,%r8
  801ba4:	48 89 d1             	mov    %rdx,%rcx
  801ba7:	48 89 c2             	mov    %rax,%rdx
  801baa:	be 00 00 00 00       	mov    $0x0,%esi
  801baf:	bf 0c 00 00 00       	mov    $0xc,%edi
  801bb4:	48 b8 c3 17 80 00 00 	movabs $0x8017c3,%rax
  801bbb:	00 00 00 
  801bbe:	ff d0                	callq  *%rax
}
  801bc0:	c9                   	leaveq 
  801bc1:	c3                   	retq   

0000000000801bc2 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801bc2:	55                   	push   %rbp
  801bc3:	48 89 e5             	mov    %rsp,%rbp
  801bc6:	48 83 ec 10          	sub    $0x10,%rsp
  801bca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801bce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bd2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bd9:	00 
  801bda:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801be0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801be6:	b9 00 00 00 00       	mov    $0x0,%ecx
  801beb:	48 89 c2             	mov    %rax,%rdx
  801bee:	be 01 00 00 00       	mov    $0x1,%esi
  801bf3:	bf 0d 00 00 00       	mov    $0xd,%edi
  801bf8:	48 b8 c3 17 80 00 00 	movabs $0x8017c3,%rax
  801bff:	00 00 00 
  801c02:	ff d0                	callq  *%rax
}
  801c04:	c9                   	leaveq 
  801c05:	c3                   	retq   

0000000000801c06 <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  801c06:	55                   	push   %rbp
  801c07:	48 89 e5             	mov    %rsp,%rbp
  801c0a:	48 83 ec 30          	sub    $0x30,%rsp
  801c0e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801c12:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c16:	48 8b 00             	mov    (%rax),%rax
  801c19:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801c1d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c21:	48 8b 40 08          	mov    0x8(%rax),%rax
  801c25:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801c28:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801c2b:	83 e0 02             	and    $0x2,%eax
  801c2e:	85 c0                	test   %eax,%eax
  801c30:	75 4d                	jne    801c7f <pgfault+0x79>
  801c32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c36:	48 c1 e8 0c          	shr    $0xc,%rax
  801c3a:	48 89 c2             	mov    %rax,%rdx
  801c3d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c44:	01 00 00 
  801c47:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c4b:	25 00 08 00 00       	and    $0x800,%eax
  801c50:	48 85 c0             	test   %rax,%rax
  801c53:	74 2a                	je     801c7f <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  801c55:	48 ba 30 42 80 00 00 	movabs $0x804230,%rdx
  801c5c:	00 00 00 
  801c5f:	be 23 00 00 00       	mov    $0x23,%esi
  801c64:	48 bf 65 42 80 00 00 	movabs $0x804265,%rdi
  801c6b:	00 00 00 
  801c6e:	b8 00 00 00 00       	mov    $0x0,%eax
  801c73:	48 b9 7c 02 80 00 00 	movabs $0x80027c,%rcx
  801c7a:	00 00 00 
  801c7d:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  801c7f:	ba 07 00 00 00       	mov    $0x7,%edx
  801c84:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801c89:	bf 00 00 00 00       	mov    $0x0,%edi
  801c8e:	48 b8 99 19 80 00 00 	movabs $0x801999,%rax
  801c95:	00 00 00 
  801c98:	ff d0                	callq  *%rax
  801c9a:	85 c0                	test   %eax,%eax
  801c9c:	0f 85 cd 00 00 00    	jne    801d6f <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801ca2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ca6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801caa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cae:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801cb4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801cb8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801cbc:	ba 00 10 00 00       	mov    $0x1000,%edx
  801cc1:	48 89 c6             	mov    %rax,%rsi
  801cc4:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801cc9:	48 b8 8e 13 80 00 00 	movabs $0x80138e,%rax
  801cd0:	00 00 00 
  801cd3:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801cd5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801cd9:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801cdf:	48 89 c1             	mov    %rax,%rcx
  801ce2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ce7:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801cec:	bf 00 00 00 00       	mov    $0x0,%edi
  801cf1:	48 b8 e9 19 80 00 00 	movabs $0x8019e9,%rax
  801cf8:	00 00 00 
  801cfb:	ff d0                	callq  *%rax
  801cfd:	85 c0                	test   %eax,%eax
  801cff:	79 2a                	jns    801d2b <pgfault+0x125>
				panic("Page map at temp address failed");
  801d01:	48 ba 70 42 80 00 00 	movabs $0x804270,%rdx
  801d08:	00 00 00 
  801d0b:	be 30 00 00 00       	mov    $0x30,%esi
  801d10:	48 bf 65 42 80 00 00 	movabs $0x804265,%rdi
  801d17:	00 00 00 
  801d1a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d1f:	48 b9 7c 02 80 00 00 	movabs $0x80027c,%rcx
  801d26:	00 00 00 
  801d29:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801d2b:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801d30:	bf 00 00 00 00       	mov    $0x0,%edi
  801d35:	48 b8 44 1a 80 00 00 	movabs $0x801a44,%rax
  801d3c:	00 00 00 
  801d3f:	ff d0                	callq  *%rax
  801d41:	85 c0                	test   %eax,%eax
  801d43:	79 54                	jns    801d99 <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801d45:	48 ba 90 42 80 00 00 	movabs $0x804290,%rdx
  801d4c:	00 00 00 
  801d4f:	be 32 00 00 00       	mov    $0x32,%esi
  801d54:	48 bf 65 42 80 00 00 	movabs $0x804265,%rdi
  801d5b:	00 00 00 
  801d5e:	b8 00 00 00 00       	mov    $0x0,%eax
  801d63:	48 b9 7c 02 80 00 00 	movabs $0x80027c,%rcx
  801d6a:	00 00 00 
  801d6d:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  801d6f:	48 ba b8 42 80 00 00 	movabs $0x8042b8,%rdx
  801d76:	00 00 00 
  801d79:	be 34 00 00 00       	mov    $0x34,%esi
  801d7e:	48 bf 65 42 80 00 00 	movabs $0x804265,%rdi
  801d85:	00 00 00 
  801d88:	b8 00 00 00 00       	mov    $0x0,%eax
  801d8d:	48 b9 7c 02 80 00 00 	movabs $0x80027c,%rcx
  801d94:	00 00 00 
  801d97:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  801d99:	c9                   	leaveq 
  801d9a:	c3                   	retq   

0000000000801d9b <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801d9b:	55                   	push   %rbp
  801d9c:	48 89 e5             	mov    %rsp,%rbp
  801d9f:	48 83 ec 20          	sub    $0x20,%rsp
  801da3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801da6:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  801da9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801db0:	01 00 00 
  801db3:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801db6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dba:	25 07 0e 00 00       	and    $0xe07,%eax
  801dbf:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801dc2:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801dc5:	48 c1 e0 0c          	shl    $0xc,%rax
  801dc9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  801dcd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dd0:	25 00 04 00 00       	and    $0x400,%eax
  801dd5:	85 c0                	test   %eax,%eax
  801dd7:	74 57                	je     801e30 <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801dd9:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801ddc:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801de0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801de3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801de7:	41 89 f0             	mov    %esi,%r8d
  801dea:	48 89 c6             	mov    %rax,%rsi
  801ded:	bf 00 00 00 00       	mov    $0x0,%edi
  801df2:	48 b8 e9 19 80 00 00 	movabs $0x8019e9,%rax
  801df9:	00 00 00 
  801dfc:	ff d0                	callq  *%rax
  801dfe:	85 c0                	test   %eax,%eax
  801e00:	0f 8e 52 01 00 00    	jle    801f58 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801e06:	48 ba ea 42 80 00 00 	movabs $0x8042ea,%rdx
  801e0d:	00 00 00 
  801e10:	be 4e 00 00 00       	mov    $0x4e,%esi
  801e15:	48 bf 65 42 80 00 00 	movabs $0x804265,%rdi
  801e1c:	00 00 00 
  801e1f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e24:	48 b9 7c 02 80 00 00 	movabs $0x80027c,%rcx
  801e2b:	00 00 00 
  801e2e:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  801e30:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e33:	83 e0 02             	and    $0x2,%eax
  801e36:	85 c0                	test   %eax,%eax
  801e38:	75 10                	jne    801e4a <duppage+0xaf>
  801e3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e3d:	25 00 08 00 00       	and    $0x800,%eax
  801e42:	85 c0                	test   %eax,%eax
  801e44:	0f 84 bb 00 00 00    	je     801f05 <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  801e4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e4d:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  801e52:	80 cc 08             	or     $0x8,%ah
  801e55:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801e58:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801e5b:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801e5f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801e62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e66:	41 89 f0             	mov    %esi,%r8d
  801e69:	48 89 c6             	mov    %rax,%rsi
  801e6c:	bf 00 00 00 00       	mov    $0x0,%edi
  801e71:	48 b8 e9 19 80 00 00 	movabs $0x8019e9,%rax
  801e78:	00 00 00 
  801e7b:	ff d0                	callq  *%rax
  801e7d:	85 c0                	test   %eax,%eax
  801e7f:	7e 2a                	jle    801eab <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  801e81:	48 ba ea 42 80 00 00 	movabs $0x8042ea,%rdx
  801e88:	00 00 00 
  801e8b:	be 55 00 00 00       	mov    $0x55,%esi
  801e90:	48 bf 65 42 80 00 00 	movabs $0x804265,%rdi
  801e97:	00 00 00 
  801e9a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e9f:	48 b9 7c 02 80 00 00 	movabs $0x80027c,%rcx
  801ea6:	00 00 00 
  801ea9:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  801eab:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801eae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801eb2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801eb6:	41 89 c8             	mov    %ecx,%r8d
  801eb9:	48 89 d1             	mov    %rdx,%rcx
  801ebc:	ba 00 00 00 00       	mov    $0x0,%edx
  801ec1:	48 89 c6             	mov    %rax,%rsi
  801ec4:	bf 00 00 00 00       	mov    $0x0,%edi
  801ec9:	48 b8 e9 19 80 00 00 	movabs $0x8019e9,%rax
  801ed0:	00 00 00 
  801ed3:	ff d0                	callq  *%rax
  801ed5:	85 c0                	test   %eax,%eax
  801ed7:	7e 2a                	jle    801f03 <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  801ed9:	48 ba ea 42 80 00 00 	movabs $0x8042ea,%rdx
  801ee0:	00 00 00 
  801ee3:	be 57 00 00 00       	mov    $0x57,%esi
  801ee8:	48 bf 65 42 80 00 00 	movabs $0x804265,%rdi
  801eef:	00 00 00 
  801ef2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef7:	48 b9 7c 02 80 00 00 	movabs $0x80027c,%rcx
  801efe:	00 00 00 
  801f01:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  801f03:	eb 53                	jmp    801f58 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801f05:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801f08:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801f0c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801f0f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f13:	41 89 f0             	mov    %esi,%r8d
  801f16:	48 89 c6             	mov    %rax,%rsi
  801f19:	bf 00 00 00 00       	mov    $0x0,%edi
  801f1e:	48 b8 e9 19 80 00 00 	movabs $0x8019e9,%rax
  801f25:	00 00 00 
  801f28:	ff d0                	callq  *%rax
  801f2a:	85 c0                	test   %eax,%eax
  801f2c:	7e 2a                	jle    801f58 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801f2e:	48 ba ea 42 80 00 00 	movabs $0x8042ea,%rdx
  801f35:	00 00 00 
  801f38:	be 5b 00 00 00       	mov    $0x5b,%esi
  801f3d:	48 bf 65 42 80 00 00 	movabs $0x804265,%rdi
  801f44:	00 00 00 
  801f47:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4c:	48 b9 7c 02 80 00 00 	movabs $0x80027c,%rcx
  801f53:	00 00 00 
  801f56:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  801f58:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f5d:	c9                   	leaveq 
  801f5e:	c3                   	retq   

0000000000801f5f <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  801f5f:	55                   	push   %rbp
  801f60:	48 89 e5             	mov    %rsp,%rbp
  801f63:	48 83 ec 18          	sub    $0x18,%rsp
  801f67:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  801f6b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f6f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  801f73:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f77:	48 c1 e8 27          	shr    $0x27,%rax
  801f7b:	48 89 c2             	mov    %rax,%rdx
  801f7e:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801f85:	01 00 00 
  801f88:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f8c:	83 e0 01             	and    $0x1,%eax
  801f8f:	48 85 c0             	test   %rax,%rax
  801f92:	74 51                	je     801fe5 <pt_is_mapped+0x86>
  801f94:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f98:	48 c1 e0 0c          	shl    $0xc,%rax
  801f9c:	48 c1 e8 1e          	shr    $0x1e,%rax
  801fa0:	48 89 c2             	mov    %rax,%rdx
  801fa3:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  801faa:	01 00 00 
  801fad:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fb1:	83 e0 01             	and    $0x1,%eax
  801fb4:	48 85 c0             	test   %rax,%rax
  801fb7:	74 2c                	je     801fe5 <pt_is_mapped+0x86>
  801fb9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fbd:	48 c1 e0 0c          	shl    $0xc,%rax
  801fc1:	48 c1 e8 15          	shr    $0x15,%rax
  801fc5:	48 89 c2             	mov    %rax,%rdx
  801fc8:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801fcf:	01 00 00 
  801fd2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fd6:	83 e0 01             	and    $0x1,%eax
  801fd9:	48 85 c0             	test   %rax,%rax
  801fdc:	74 07                	je     801fe5 <pt_is_mapped+0x86>
  801fde:	b8 01 00 00 00       	mov    $0x1,%eax
  801fe3:	eb 05                	jmp    801fea <pt_is_mapped+0x8b>
  801fe5:	b8 00 00 00 00       	mov    $0x0,%eax
  801fea:	83 e0 01             	and    $0x1,%eax
}
  801fed:	c9                   	leaveq 
  801fee:	c3                   	retq   

0000000000801fef <fork>:

envid_t
fork(void)
{
  801fef:	55                   	push   %rbp
  801ff0:	48 89 e5             	mov    %rsp,%rbp
  801ff3:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  801ff7:	48 bf 06 1c 80 00 00 	movabs $0x801c06,%rdi
  801ffe:	00 00 00 
  802001:	48 b8 2f 3b 80 00 00 	movabs $0x803b2f,%rax
  802008:	00 00 00 
  80200b:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80200d:	b8 07 00 00 00       	mov    $0x7,%eax
  802012:	cd 30                	int    $0x30
  802014:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802017:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  80201a:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  80201d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802021:	79 30                	jns    802053 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  802023:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802026:	89 c1                	mov    %eax,%ecx
  802028:	48 ba 08 43 80 00 00 	movabs $0x804308,%rdx
  80202f:	00 00 00 
  802032:	be 86 00 00 00       	mov    $0x86,%esi
  802037:	48 bf 65 42 80 00 00 	movabs $0x804265,%rdi
  80203e:	00 00 00 
  802041:	b8 00 00 00 00       	mov    $0x0,%eax
  802046:	49 b8 7c 02 80 00 00 	movabs $0x80027c,%r8
  80204d:	00 00 00 
  802050:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  802053:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802057:	75 46                	jne    80209f <fork+0xb0>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  802059:	48 b8 1d 19 80 00 00 	movabs $0x80191d,%rax
  802060:	00 00 00 
  802063:	ff d0                	callq  *%rax
  802065:	25 ff 03 00 00       	and    $0x3ff,%eax
  80206a:	48 63 d0             	movslq %eax,%rdx
  80206d:	48 89 d0             	mov    %rdx,%rax
  802070:	48 c1 e0 03          	shl    $0x3,%rax
  802074:	48 01 d0             	add    %rdx,%rax
  802077:	48 c1 e0 05          	shl    $0x5,%rax
  80207b:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802082:	00 00 00 
  802085:	48 01 c2             	add    %rax,%rdx
  802088:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80208f:	00 00 00 
  802092:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  802095:	b8 00 00 00 00       	mov    $0x0,%eax
  80209a:	e9 d1 01 00 00       	jmpq   802270 <fork+0x281>
	}
	uint64_t ad = 0;
  80209f:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8020a6:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8020a7:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  8020ac:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8020b0:	e9 df 00 00 00       	jmpq   802194 <fork+0x1a5>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  8020b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020b9:	48 c1 e8 27          	shr    $0x27,%rax
  8020bd:	48 89 c2             	mov    %rax,%rdx
  8020c0:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8020c7:	01 00 00 
  8020ca:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020ce:	83 e0 01             	and    $0x1,%eax
  8020d1:	48 85 c0             	test   %rax,%rax
  8020d4:	0f 84 9e 00 00 00    	je     802178 <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  8020da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020de:	48 c1 e8 1e          	shr    $0x1e,%rax
  8020e2:	48 89 c2             	mov    %rax,%rdx
  8020e5:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8020ec:	01 00 00 
  8020ef:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020f3:	83 e0 01             	and    $0x1,%eax
  8020f6:	48 85 c0             	test   %rax,%rax
  8020f9:	74 73                	je     80216e <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  8020fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020ff:	48 c1 e8 15          	shr    $0x15,%rax
  802103:	48 89 c2             	mov    %rax,%rdx
  802106:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80210d:	01 00 00 
  802110:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802114:	83 e0 01             	and    $0x1,%eax
  802117:	48 85 c0             	test   %rax,%rax
  80211a:	74 48                	je     802164 <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  80211c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802120:	48 c1 e8 0c          	shr    $0xc,%rax
  802124:	48 89 c2             	mov    %rax,%rdx
  802127:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80212e:	01 00 00 
  802131:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802135:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802139:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80213d:	83 e0 01             	and    $0x1,%eax
  802140:	48 85 c0             	test   %rax,%rax
  802143:	74 47                	je     80218c <fork+0x19d>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  802145:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802149:	48 c1 e8 0c          	shr    $0xc,%rax
  80214d:	89 c2                	mov    %eax,%edx
  80214f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802152:	89 d6                	mov    %edx,%esi
  802154:	89 c7                	mov    %eax,%edi
  802156:	48 b8 9b 1d 80 00 00 	movabs $0x801d9b,%rax
  80215d:	00 00 00 
  802160:	ff d0                	callq  *%rax
  802162:	eb 28                	jmp    80218c <fork+0x19d>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  802164:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  80216b:	00 
  80216c:	eb 1e                	jmp    80218c <fork+0x19d>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  80216e:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  802175:	40 
  802176:	eb 14                	jmp    80218c <fork+0x19d>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  802178:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80217c:	48 c1 e8 27          	shr    $0x27,%rax
  802180:	48 83 c0 01          	add    $0x1,%rax
  802184:	48 c1 e0 27          	shl    $0x27,%rax
  802188:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  80218c:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  802193:	00 
  802194:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  80219b:	00 
  80219c:	0f 87 13 ff ff ff    	ja     8020b5 <fork+0xc6>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8021a2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8021a5:	ba 07 00 00 00       	mov    $0x7,%edx
  8021aa:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8021af:	89 c7                	mov    %eax,%edi
  8021b1:	48 b8 99 19 80 00 00 	movabs $0x801999,%rax
  8021b8:	00 00 00 
  8021bb:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8021bd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8021c0:	ba 07 00 00 00       	mov    $0x7,%edx
  8021c5:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8021ca:	89 c7                	mov    %eax,%edi
  8021cc:	48 b8 99 19 80 00 00 	movabs $0x801999,%rax
  8021d3:	00 00 00 
  8021d6:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  8021d8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8021db:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8021e1:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  8021e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8021eb:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8021f0:	89 c7                	mov    %eax,%edi
  8021f2:	48 b8 e9 19 80 00 00 	movabs $0x8019e9,%rax
  8021f9:	00 00 00 
  8021fc:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  8021fe:	ba 00 10 00 00       	mov    $0x1000,%edx
  802203:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802208:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  80220d:	48 b8 8e 13 80 00 00 	movabs $0x80138e,%rax
  802214:	00 00 00 
  802217:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  802219:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80221e:	bf 00 00 00 00       	mov    $0x0,%edi
  802223:	48 b8 44 1a 80 00 00 	movabs $0x801a44,%rax
  80222a:	00 00 00 
  80222d:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  80222f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802236:	00 00 00 
  802239:	48 8b 00             	mov    (%rax),%rax
  80223c:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802243:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802246:	48 89 d6             	mov    %rdx,%rsi
  802249:	89 c7                	mov    %eax,%edi
  80224b:	48 b8 23 1b 80 00 00 	movabs $0x801b23,%rax
  802252:	00 00 00 
  802255:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  802257:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80225a:	be 02 00 00 00       	mov    $0x2,%esi
  80225f:	89 c7                	mov    %eax,%edi
  802261:	48 b8 8e 1a 80 00 00 	movabs $0x801a8e,%rax
  802268:	00 00 00 
  80226b:	ff d0                	callq  *%rax

	return envid;
  80226d:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  802270:	c9                   	leaveq 
  802271:	c3                   	retq   

0000000000802272 <sfork>:

	
// Challenge!
int
sfork(void)
{
  802272:	55                   	push   %rbp
  802273:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802276:	48 ba 20 43 80 00 00 	movabs $0x804320,%rdx
  80227d:	00 00 00 
  802280:	be bf 00 00 00       	mov    $0xbf,%esi
  802285:	48 bf 65 42 80 00 00 	movabs $0x804265,%rdi
  80228c:	00 00 00 
  80228f:	b8 00 00 00 00       	mov    $0x0,%eax
  802294:	48 b9 7c 02 80 00 00 	movabs $0x80027c,%rcx
  80229b:	00 00 00 
  80229e:	ff d1                	callq  *%rcx

00000000008022a0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8022a0:	55                   	push   %rbp
  8022a1:	48 89 e5             	mov    %rsp,%rbp
  8022a4:	48 83 ec 30          	sub    $0x30,%rsp
  8022a8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8022ac:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8022b0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  8022b4:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8022bb:	00 00 00 
  8022be:	48 8b 00             	mov    (%rax),%rax
  8022c1:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8022c7:	85 c0                	test   %eax,%eax
  8022c9:	75 3c                	jne    802307 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  8022cb:	48 b8 1d 19 80 00 00 	movabs $0x80191d,%rax
  8022d2:	00 00 00 
  8022d5:	ff d0                	callq  *%rax
  8022d7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8022dc:	48 63 d0             	movslq %eax,%rdx
  8022df:	48 89 d0             	mov    %rdx,%rax
  8022e2:	48 c1 e0 03          	shl    $0x3,%rax
  8022e6:	48 01 d0             	add    %rdx,%rax
  8022e9:	48 c1 e0 05          	shl    $0x5,%rax
  8022ed:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8022f4:	00 00 00 
  8022f7:	48 01 c2             	add    %rax,%rdx
  8022fa:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802301:	00 00 00 
  802304:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  802307:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80230c:	75 0e                	jne    80231c <ipc_recv+0x7c>
		pg = (void*) UTOP;
  80230e:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802315:	00 00 00 
  802318:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  80231c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802320:	48 89 c7             	mov    %rax,%rdi
  802323:	48 b8 c2 1b 80 00 00 	movabs $0x801bc2,%rax
  80232a:	00 00 00 
  80232d:	ff d0                	callq  *%rax
  80232f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  802332:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802336:	79 19                	jns    802351 <ipc_recv+0xb1>
		*from_env_store = 0;
  802338:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80233c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  802342:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802346:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  80234c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80234f:	eb 53                	jmp    8023a4 <ipc_recv+0x104>
	}
	if(from_env_store)
  802351:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802356:	74 19                	je     802371 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  802358:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80235f:	00 00 00 
  802362:	48 8b 00             	mov    (%rax),%rax
  802365:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80236b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80236f:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  802371:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802376:	74 19                	je     802391 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  802378:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80237f:	00 00 00 
  802382:	48 8b 00             	mov    (%rax),%rax
  802385:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80238b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80238f:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  802391:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802398:	00 00 00 
  80239b:	48 8b 00             	mov    (%rax),%rax
  80239e:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  8023a4:	c9                   	leaveq 
  8023a5:	c3                   	retq   

00000000008023a6 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8023a6:	55                   	push   %rbp
  8023a7:	48 89 e5             	mov    %rsp,%rbp
  8023aa:	48 83 ec 30          	sub    $0x30,%rsp
  8023ae:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023b1:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8023b4:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8023b8:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  8023bb:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8023c0:	75 0e                	jne    8023d0 <ipc_send+0x2a>
		pg = (void*)UTOP;
  8023c2:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8023c9:	00 00 00 
  8023cc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  8023d0:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8023d3:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8023d6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8023da:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023dd:	89 c7                	mov    %eax,%edi
  8023df:	48 b8 6d 1b 80 00 00 	movabs $0x801b6d,%rax
  8023e6:	00 00 00 
  8023e9:	ff d0                	callq  *%rax
  8023eb:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  8023ee:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8023f2:	75 0c                	jne    802400 <ipc_send+0x5a>
			sys_yield();
  8023f4:	48 b8 5b 19 80 00 00 	movabs $0x80195b,%rax
  8023fb:	00 00 00 
  8023fe:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  802400:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  802404:	74 ca                	je     8023d0 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  802406:	c9                   	leaveq 
  802407:	c3                   	retq   

0000000000802408 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802408:	55                   	push   %rbp
  802409:	48 89 e5             	mov    %rsp,%rbp
  80240c:	48 83 ec 14          	sub    $0x14,%rsp
  802410:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  802413:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80241a:	eb 5e                	jmp    80247a <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  80241c:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802423:	00 00 00 
  802426:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802429:	48 63 d0             	movslq %eax,%rdx
  80242c:	48 89 d0             	mov    %rdx,%rax
  80242f:	48 c1 e0 03          	shl    $0x3,%rax
  802433:	48 01 d0             	add    %rdx,%rax
  802436:	48 c1 e0 05          	shl    $0x5,%rax
  80243a:	48 01 c8             	add    %rcx,%rax
  80243d:	48 05 d0 00 00 00    	add    $0xd0,%rax
  802443:	8b 00                	mov    (%rax),%eax
  802445:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802448:	75 2c                	jne    802476 <ipc_find_env+0x6e>
			return envs[i].env_id;
  80244a:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802451:	00 00 00 
  802454:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802457:	48 63 d0             	movslq %eax,%rdx
  80245a:	48 89 d0             	mov    %rdx,%rax
  80245d:	48 c1 e0 03          	shl    $0x3,%rax
  802461:	48 01 d0             	add    %rdx,%rax
  802464:	48 c1 e0 05          	shl    $0x5,%rax
  802468:	48 01 c8             	add    %rcx,%rax
  80246b:	48 05 c0 00 00 00    	add    $0xc0,%rax
  802471:	8b 40 08             	mov    0x8(%rax),%eax
  802474:	eb 12                	jmp    802488 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802476:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80247a:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802481:	7e 99                	jle    80241c <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802483:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802488:	c9                   	leaveq 
  802489:	c3                   	retq   

000000000080248a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80248a:	55                   	push   %rbp
  80248b:	48 89 e5             	mov    %rsp,%rbp
  80248e:	48 83 ec 08          	sub    $0x8,%rsp
  802492:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802496:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80249a:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8024a1:	ff ff ff 
  8024a4:	48 01 d0             	add    %rdx,%rax
  8024a7:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8024ab:	c9                   	leaveq 
  8024ac:	c3                   	retq   

00000000008024ad <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8024ad:	55                   	push   %rbp
  8024ae:	48 89 e5             	mov    %rsp,%rbp
  8024b1:	48 83 ec 08          	sub    $0x8,%rsp
  8024b5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8024b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024bd:	48 89 c7             	mov    %rax,%rdi
  8024c0:	48 b8 8a 24 80 00 00 	movabs $0x80248a,%rax
  8024c7:	00 00 00 
  8024ca:	ff d0                	callq  *%rax
  8024cc:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8024d2:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8024d6:	c9                   	leaveq 
  8024d7:	c3                   	retq   

00000000008024d8 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8024d8:	55                   	push   %rbp
  8024d9:	48 89 e5             	mov    %rsp,%rbp
  8024dc:	48 83 ec 18          	sub    $0x18,%rsp
  8024e0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8024e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8024eb:	eb 6b                	jmp    802558 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8024ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024f0:	48 98                	cltq   
  8024f2:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8024f8:	48 c1 e0 0c          	shl    $0xc,%rax
  8024fc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802500:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802504:	48 c1 e8 15          	shr    $0x15,%rax
  802508:	48 89 c2             	mov    %rax,%rdx
  80250b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802512:	01 00 00 
  802515:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802519:	83 e0 01             	and    $0x1,%eax
  80251c:	48 85 c0             	test   %rax,%rax
  80251f:	74 21                	je     802542 <fd_alloc+0x6a>
  802521:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802525:	48 c1 e8 0c          	shr    $0xc,%rax
  802529:	48 89 c2             	mov    %rax,%rdx
  80252c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802533:	01 00 00 
  802536:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80253a:	83 e0 01             	and    $0x1,%eax
  80253d:	48 85 c0             	test   %rax,%rax
  802540:	75 12                	jne    802554 <fd_alloc+0x7c>
			*fd_store = fd;
  802542:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802546:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80254a:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80254d:	b8 00 00 00 00       	mov    $0x0,%eax
  802552:	eb 1a                	jmp    80256e <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802554:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802558:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80255c:	7e 8f                	jle    8024ed <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80255e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802562:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802569:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80256e:	c9                   	leaveq 
  80256f:	c3                   	retq   

0000000000802570 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802570:	55                   	push   %rbp
  802571:	48 89 e5             	mov    %rsp,%rbp
  802574:	48 83 ec 20          	sub    $0x20,%rsp
  802578:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80257b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80257f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802583:	78 06                	js     80258b <fd_lookup+0x1b>
  802585:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802589:	7e 07                	jle    802592 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80258b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802590:	eb 6c                	jmp    8025fe <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802592:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802595:	48 98                	cltq   
  802597:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80259d:	48 c1 e0 0c          	shl    $0xc,%rax
  8025a1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8025a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025a9:	48 c1 e8 15          	shr    $0x15,%rax
  8025ad:	48 89 c2             	mov    %rax,%rdx
  8025b0:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8025b7:	01 00 00 
  8025ba:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025be:	83 e0 01             	and    $0x1,%eax
  8025c1:	48 85 c0             	test   %rax,%rax
  8025c4:	74 21                	je     8025e7 <fd_lookup+0x77>
  8025c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025ca:	48 c1 e8 0c          	shr    $0xc,%rax
  8025ce:	48 89 c2             	mov    %rax,%rdx
  8025d1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025d8:	01 00 00 
  8025db:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025df:	83 e0 01             	and    $0x1,%eax
  8025e2:	48 85 c0             	test   %rax,%rax
  8025e5:	75 07                	jne    8025ee <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8025e7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025ec:	eb 10                	jmp    8025fe <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8025ee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025f2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8025f6:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8025f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025fe:	c9                   	leaveq 
  8025ff:	c3                   	retq   

0000000000802600 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802600:	55                   	push   %rbp
  802601:	48 89 e5             	mov    %rsp,%rbp
  802604:	48 83 ec 30          	sub    $0x30,%rsp
  802608:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80260c:	89 f0                	mov    %esi,%eax
  80260e:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802611:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802615:	48 89 c7             	mov    %rax,%rdi
  802618:	48 b8 8a 24 80 00 00 	movabs $0x80248a,%rax
  80261f:	00 00 00 
  802622:	ff d0                	callq  *%rax
  802624:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802628:	48 89 d6             	mov    %rdx,%rsi
  80262b:	89 c7                	mov    %eax,%edi
  80262d:	48 b8 70 25 80 00 00 	movabs $0x802570,%rax
  802634:	00 00 00 
  802637:	ff d0                	callq  *%rax
  802639:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80263c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802640:	78 0a                	js     80264c <fd_close+0x4c>
	    || fd != fd2)
  802642:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802646:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80264a:	74 12                	je     80265e <fd_close+0x5e>
		return (must_exist ? r : 0);
  80264c:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802650:	74 05                	je     802657 <fd_close+0x57>
  802652:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802655:	eb 05                	jmp    80265c <fd_close+0x5c>
  802657:	b8 00 00 00 00       	mov    $0x0,%eax
  80265c:	eb 69                	jmp    8026c7 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80265e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802662:	8b 00                	mov    (%rax),%eax
  802664:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802668:	48 89 d6             	mov    %rdx,%rsi
  80266b:	89 c7                	mov    %eax,%edi
  80266d:	48 b8 c9 26 80 00 00 	movabs $0x8026c9,%rax
  802674:	00 00 00 
  802677:	ff d0                	callq  *%rax
  802679:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80267c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802680:	78 2a                	js     8026ac <fd_close+0xac>
		if (dev->dev_close)
  802682:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802686:	48 8b 40 20          	mov    0x20(%rax),%rax
  80268a:	48 85 c0             	test   %rax,%rax
  80268d:	74 16                	je     8026a5 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  80268f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802693:	48 8b 40 20          	mov    0x20(%rax),%rax
  802697:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80269b:	48 89 d7             	mov    %rdx,%rdi
  80269e:	ff d0                	callq  *%rax
  8026a0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026a3:	eb 07                	jmp    8026ac <fd_close+0xac>
		else
			r = 0;
  8026a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8026ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026b0:	48 89 c6             	mov    %rax,%rsi
  8026b3:	bf 00 00 00 00       	mov    $0x0,%edi
  8026b8:	48 b8 44 1a 80 00 00 	movabs $0x801a44,%rax
  8026bf:	00 00 00 
  8026c2:	ff d0                	callq  *%rax
	return r;
  8026c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8026c7:	c9                   	leaveq 
  8026c8:	c3                   	retq   

00000000008026c9 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8026c9:	55                   	push   %rbp
  8026ca:	48 89 e5             	mov    %rsp,%rbp
  8026cd:	48 83 ec 20          	sub    $0x20,%rsp
  8026d1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8026d4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8026d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8026df:	eb 41                	jmp    802722 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8026e1:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8026e8:	00 00 00 
  8026eb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026ee:	48 63 d2             	movslq %edx,%rdx
  8026f1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026f5:	8b 00                	mov    (%rax),%eax
  8026f7:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8026fa:	75 22                	jne    80271e <dev_lookup+0x55>
			*dev = devtab[i];
  8026fc:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802703:	00 00 00 
  802706:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802709:	48 63 d2             	movslq %edx,%rdx
  80270c:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802710:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802714:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802717:	b8 00 00 00 00       	mov    $0x0,%eax
  80271c:	eb 60                	jmp    80277e <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80271e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802722:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802729:	00 00 00 
  80272c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80272f:	48 63 d2             	movslq %edx,%rdx
  802732:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802736:	48 85 c0             	test   %rax,%rax
  802739:	75 a6                	jne    8026e1 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80273b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802742:	00 00 00 
  802745:	48 8b 00             	mov    (%rax),%rax
  802748:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80274e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802751:	89 c6                	mov    %eax,%esi
  802753:	48 bf 38 43 80 00 00 	movabs $0x804338,%rdi
  80275a:	00 00 00 
  80275d:	b8 00 00 00 00       	mov    $0x0,%eax
  802762:	48 b9 b5 04 80 00 00 	movabs $0x8004b5,%rcx
  802769:	00 00 00 
  80276c:	ff d1                	callq  *%rcx
	*dev = 0;
  80276e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802772:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802779:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80277e:	c9                   	leaveq 
  80277f:	c3                   	retq   

0000000000802780 <close>:

int
close(int fdnum)
{
  802780:	55                   	push   %rbp
  802781:	48 89 e5             	mov    %rsp,%rbp
  802784:	48 83 ec 20          	sub    $0x20,%rsp
  802788:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80278b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80278f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802792:	48 89 d6             	mov    %rdx,%rsi
  802795:	89 c7                	mov    %eax,%edi
  802797:	48 b8 70 25 80 00 00 	movabs $0x802570,%rax
  80279e:	00 00 00 
  8027a1:	ff d0                	callq  *%rax
  8027a3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027aa:	79 05                	jns    8027b1 <close+0x31>
		return r;
  8027ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027af:	eb 18                	jmp    8027c9 <close+0x49>
	else
		return fd_close(fd, 1);
  8027b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027b5:	be 01 00 00 00       	mov    $0x1,%esi
  8027ba:	48 89 c7             	mov    %rax,%rdi
  8027bd:	48 b8 00 26 80 00 00 	movabs $0x802600,%rax
  8027c4:	00 00 00 
  8027c7:	ff d0                	callq  *%rax
}
  8027c9:	c9                   	leaveq 
  8027ca:	c3                   	retq   

00000000008027cb <close_all>:

void
close_all(void)
{
  8027cb:	55                   	push   %rbp
  8027cc:	48 89 e5             	mov    %rsp,%rbp
  8027cf:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8027d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8027da:	eb 15                	jmp    8027f1 <close_all+0x26>
		close(i);
  8027dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027df:	89 c7                	mov    %eax,%edi
  8027e1:	48 b8 80 27 80 00 00 	movabs $0x802780,%rax
  8027e8:	00 00 00 
  8027eb:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8027ed:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8027f1:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8027f5:	7e e5                	jle    8027dc <close_all+0x11>
		close(i);
}
  8027f7:	c9                   	leaveq 
  8027f8:	c3                   	retq   

00000000008027f9 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8027f9:	55                   	push   %rbp
  8027fa:	48 89 e5             	mov    %rsp,%rbp
  8027fd:	48 83 ec 40          	sub    $0x40,%rsp
  802801:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802804:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802807:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80280b:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80280e:	48 89 d6             	mov    %rdx,%rsi
  802811:	89 c7                	mov    %eax,%edi
  802813:	48 b8 70 25 80 00 00 	movabs $0x802570,%rax
  80281a:	00 00 00 
  80281d:	ff d0                	callq  *%rax
  80281f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802822:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802826:	79 08                	jns    802830 <dup+0x37>
		return r;
  802828:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80282b:	e9 70 01 00 00       	jmpq   8029a0 <dup+0x1a7>
	close(newfdnum);
  802830:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802833:	89 c7                	mov    %eax,%edi
  802835:	48 b8 80 27 80 00 00 	movabs $0x802780,%rax
  80283c:	00 00 00 
  80283f:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802841:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802844:	48 98                	cltq   
  802846:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80284c:	48 c1 e0 0c          	shl    $0xc,%rax
  802850:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802854:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802858:	48 89 c7             	mov    %rax,%rdi
  80285b:	48 b8 ad 24 80 00 00 	movabs $0x8024ad,%rax
  802862:	00 00 00 
  802865:	ff d0                	callq  *%rax
  802867:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80286b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80286f:	48 89 c7             	mov    %rax,%rdi
  802872:	48 b8 ad 24 80 00 00 	movabs $0x8024ad,%rax
  802879:	00 00 00 
  80287c:	ff d0                	callq  *%rax
  80287e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802882:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802886:	48 c1 e8 15          	shr    $0x15,%rax
  80288a:	48 89 c2             	mov    %rax,%rdx
  80288d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802894:	01 00 00 
  802897:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80289b:	83 e0 01             	and    $0x1,%eax
  80289e:	48 85 c0             	test   %rax,%rax
  8028a1:	74 73                	je     802916 <dup+0x11d>
  8028a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028a7:	48 c1 e8 0c          	shr    $0xc,%rax
  8028ab:	48 89 c2             	mov    %rax,%rdx
  8028ae:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8028b5:	01 00 00 
  8028b8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028bc:	83 e0 01             	and    $0x1,%eax
  8028bf:	48 85 c0             	test   %rax,%rax
  8028c2:	74 52                	je     802916 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8028c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028c8:	48 c1 e8 0c          	shr    $0xc,%rax
  8028cc:	48 89 c2             	mov    %rax,%rdx
  8028cf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8028d6:	01 00 00 
  8028d9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028dd:	25 07 0e 00 00       	and    $0xe07,%eax
  8028e2:	89 c1                	mov    %eax,%ecx
  8028e4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8028e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028ec:	41 89 c8             	mov    %ecx,%r8d
  8028ef:	48 89 d1             	mov    %rdx,%rcx
  8028f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8028f7:	48 89 c6             	mov    %rax,%rsi
  8028fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8028ff:	48 b8 e9 19 80 00 00 	movabs $0x8019e9,%rax
  802906:	00 00 00 
  802909:	ff d0                	callq  *%rax
  80290b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80290e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802912:	79 02                	jns    802916 <dup+0x11d>
			goto err;
  802914:	eb 57                	jmp    80296d <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802916:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80291a:	48 c1 e8 0c          	shr    $0xc,%rax
  80291e:	48 89 c2             	mov    %rax,%rdx
  802921:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802928:	01 00 00 
  80292b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80292f:	25 07 0e 00 00       	and    $0xe07,%eax
  802934:	89 c1                	mov    %eax,%ecx
  802936:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80293a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80293e:	41 89 c8             	mov    %ecx,%r8d
  802941:	48 89 d1             	mov    %rdx,%rcx
  802944:	ba 00 00 00 00       	mov    $0x0,%edx
  802949:	48 89 c6             	mov    %rax,%rsi
  80294c:	bf 00 00 00 00       	mov    $0x0,%edi
  802951:	48 b8 e9 19 80 00 00 	movabs $0x8019e9,%rax
  802958:	00 00 00 
  80295b:	ff d0                	callq  *%rax
  80295d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802960:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802964:	79 02                	jns    802968 <dup+0x16f>
		goto err;
  802966:	eb 05                	jmp    80296d <dup+0x174>

	return newfdnum;
  802968:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80296b:	eb 33                	jmp    8029a0 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  80296d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802971:	48 89 c6             	mov    %rax,%rsi
  802974:	bf 00 00 00 00       	mov    $0x0,%edi
  802979:	48 b8 44 1a 80 00 00 	movabs $0x801a44,%rax
  802980:	00 00 00 
  802983:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802985:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802989:	48 89 c6             	mov    %rax,%rsi
  80298c:	bf 00 00 00 00       	mov    $0x0,%edi
  802991:	48 b8 44 1a 80 00 00 	movabs $0x801a44,%rax
  802998:	00 00 00 
  80299b:	ff d0                	callq  *%rax
	return r;
  80299d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8029a0:	c9                   	leaveq 
  8029a1:	c3                   	retq   

00000000008029a2 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8029a2:	55                   	push   %rbp
  8029a3:	48 89 e5             	mov    %rsp,%rbp
  8029a6:	48 83 ec 40          	sub    $0x40,%rsp
  8029aa:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8029ad:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8029b1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8029b5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029b9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029bc:	48 89 d6             	mov    %rdx,%rsi
  8029bf:	89 c7                	mov    %eax,%edi
  8029c1:	48 b8 70 25 80 00 00 	movabs $0x802570,%rax
  8029c8:	00 00 00 
  8029cb:	ff d0                	callq  *%rax
  8029cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029d4:	78 24                	js     8029fa <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8029d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029da:	8b 00                	mov    (%rax),%eax
  8029dc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029e0:	48 89 d6             	mov    %rdx,%rsi
  8029e3:	89 c7                	mov    %eax,%edi
  8029e5:	48 b8 c9 26 80 00 00 	movabs $0x8026c9,%rax
  8029ec:	00 00 00 
  8029ef:	ff d0                	callq  *%rax
  8029f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029f8:	79 05                	jns    8029ff <read+0x5d>
		return r;
  8029fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029fd:	eb 76                	jmp    802a75 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8029ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a03:	8b 40 08             	mov    0x8(%rax),%eax
  802a06:	83 e0 03             	and    $0x3,%eax
  802a09:	83 f8 01             	cmp    $0x1,%eax
  802a0c:	75 3a                	jne    802a48 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802a0e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802a15:	00 00 00 
  802a18:	48 8b 00             	mov    (%rax),%rax
  802a1b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a21:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a24:	89 c6                	mov    %eax,%esi
  802a26:	48 bf 57 43 80 00 00 	movabs $0x804357,%rdi
  802a2d:	00 00 00 
  802a30:	b8 00 00 00 00       	mov    $0x0,%eax
  802a35:	48 b9 b5 04 80 00 00 	movabs $0x8004b5,%rcx
  802a3c:	00 00 00 
  802a3f:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802a41:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a46:	eb 2d                	jmp    802a75 <read+0xd3>
	}
	if (!dev->dev_read)
  802a48:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a4c:	48 8b 40 10          	mov    0x10(%rax),%rax
  802a50:	48 85 c0             	test   %rax,%rax
  802a53:	75 07                	jne    802a5c <read+0xba>
		return -E_NOT_SUPP;
  802a55:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a5a:	eb 19                	jmp    802a75 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802a5c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a60:	48 8b 40 10          	mov    0x10(%rax),%rax
  802a64:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802a68:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a6c:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802a70:	48 89 cf             	mov    %rcx,%rdi
  802a73:	ff d0                	callq  *%rax
}
  802a75:	c9                   	leaveq 
  802a76:	c3                   	retq   

0000000000802a77 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802a77:	55                   	push   %rbp
  802a78:	48 89 e5             	mov    %rsp,%rbp
  802a7b:	48 83 ec 30          	sub    $0x30,%rsp
  802a7f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a82:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a86:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802a8a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a91:	eb 49                	jmp    802adc <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802a93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a96:	48 98                	cltq   
  802a98:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a9c:	48 29 c2             	sub    %rax,%rdx
  802a9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aa2:	48 63 c8             	movslq %eax,%rcx
  802aa5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802aa9:	48 01 c1             	add    %rax,%rcx
  802aac:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802aaf:	48 89 ce             	mov    %rcx,%rsi
  802ab2:	89 c7                	mov    %eax,%edi
  802ab4:	48 b8 a2 29 80 00 00 	movabs $0x8029a2,%rax
  802abb:	00 00 00 
  802abe:	ff d0                	callq  *%rax
  802ac0:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802ac3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ac7:	79 05                	jns    802ace <readn+0x57>
			return m;
  802ac9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802acc:	eb 1c                	jmp    802aea <readn+0x73>
		if (m == 0)
  802ace:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ad2:	75 02                	jne    802ad6 <readn+0x5f>
			break;
  802ad4:	eb 11                	jmp    802ae7 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802ad6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ad9:	01 45 fc             	add    %eax,-0x4(%rbp)
  802adc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802adf:	48 98                	cltq   
  802ae1:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802ae5:	72 ac                	jb     802a93 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802ae7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802aea:	c9                   	leaveq 
  802aeb:	c3                   	retq   

0000000000802aec <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802aec:	55                   	push   %rbp
  802aed:	48 89 e5             	mov    %rsp,%rbp
  802af0:	48 83 ec 40          	sub    $0x40,%rsp
  802af4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802af7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802afb:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802aff:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b03:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b06:	48 89 d6             	mov    %rdx,%rsi
  802b09:	89 c7                	mov    %eax,%edi
  802b0b:	48 b8 70 25 80 00 00 	movabs $0x802570,%rax
  802b12:	00 00 00 
  802b15:	ff d0                	callq  *%rax
  802b17:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b1a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b1e:	78 24                	js     802b44 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b24:	8b 00                	mov    (%rax),%eax
  802b26:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b2a:	48 89 d6             	mov    %rdx,%rsi
  802b2d:	89 c7                	mov    %eax,%edi
  802b2f:	48 b8 c9 26 80 00 00 	movabs $0x8026c9,%rax
  802b36:	00 00 00 
  802b39:	ff d0                	callq  *%rax
  802b3b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b3e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b42:	79 05                	jns    802b49 <write+0x5d>
		return r;
  802b44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b47:	eb 75                	jmp    802bbe <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802b49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b4d:	8b 40 08             	mov    0x8(%rax),%eax
  802b50:	83 e0 03             	and    $0x3,%eax
  802b53:	85 c0                	test   %eax,%eax
  802b55:	75 3a                	jne    802b91 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802b57:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802b5e:	00 00 00 
  802b61:	48 8b 00             	mov    (%rax),%rax
  802b64:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b6a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b6d:	89 c6                	mov    %eax,%esi
  802b6f:	48 bf 73 43 80 00 00 	movabs $0x804373,%rdi
  802b76:	00 00 00 
  802b79:	b8 00 00 00 00       	mov    $0x0,%eax
  802b7e:	48 b9 b5 04 80 00 00 	movabs $0x8004b5,%rcx
  802b85:	00 00 00 
  802b88:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802b8a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b8f:	eb 2d                	jmp    802bbe <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802b91:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b95:	48 8b 40 18          	mov    0x18(%rax),%rax
  802b99:	48 85 c0             	test   %rax,%rax
  802b9c:	75 07                	jne    802ba5 <write+0xb9>
		return -E_NOT_SUPP;
  802b9e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ba3:	eb 19                	jmp    802bbe <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802ba5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ba9:	48 8b 40 18          	mov    0x18(%rax),%rax
  802bad:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802bb1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802bb5:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802bb9:	48 89 cf             	mov    %rcx,%rdi
  802bbc:	ff d0                	callq  *%rax
}
  802bbe:	c9                   	leaveq 
  802bbf:	c3                   	retq   

0000000000802bc0 <seek>:

int
seek(int fdnum, off_t offset)
{
  802bc0:	55                   	push   %rbp
  802bc1:	48 89 e5             	mov    %rsp,%rbp
  802bc4:	48 83 ec 18          	sub    $0x18,%rsp
  802bc8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802bcb:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802bce:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802bd2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bd5:	48 89 d6             	mov    %rdx,%rsi
  802bd8:	89 c7                	mov    %eax,%edi
  802bda:	48 b8 70 25 80 00 00 	movabs $0x802570,%rax
  802be1:	00 00 00 
  802be4:	ff d0                	callq  *%rax
  802be6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802be9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bed:	79 05                	jns    802bf4 <seek+0x34>
		return r;
  802bef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bf2:	eb 0f                	jmp    802c03 <seek+0x43>
	fd->fd_offset = offset;
  802bf4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bf8:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802bfb:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802bfe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c03:	c9                   	leaveq 
  802c04:	c3                   	retq   

0000000000802c05 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802c05:	55                   	push   %rbp
  802c06:	48 89 e5             	mov    %rsp,%rbp
  802c09:	48 83 ec 30          	sub    $0x30,%rsp
  802c0d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c10:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c13:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c17:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c1a:	48 89 d6             	mov    %rdx,%rsi
  802c1d:	89 c7                	mov    %eax,%edi
  802c1f:	48 b8 70 25 80 00 00 	movabs $0x802570,%rax
  802c26:	00 00 00 
  802c29:	ff d0                	callq  *%rax
  802c2b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c2e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c32:	78 24                	js     802c58 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c38:	8b 00                	mov    (%rax),%eax
  802c3a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c3e:	48 89 d6             	mov    %rdx,%rsi
  802c41:	89 c7                	mov    %eax,%edi
  802c43:	48 b8 c9 26 80 00 00 	movabs $0x8026c9,%rax
  802c4a:	00 00 00 
  802c4d:	ff d0                	callq  *%rax
  802c4f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c52:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c56:	79 05                	jns    802c5d <ftruncate+0x58>
		return r;
  802c58:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c5b:	eb 72                	jmp    802ccf <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802c5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c61:	8b 40 08             	mov    0x8(%rax),%eax
  802c64:	83 e0 03             	and    $0x3,%eax
  802c67:	85 c0                	test   %eax,%eax
  802c69:	75 3a                	jne    802ca5 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802c6b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802c72:	00 00 00 
  802c75:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802c78:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c7e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c81:	89 c6                	mov    %eax,%esi
  802c83:	48 bf 90 43 80 00 00 	movabs $0x804390,%rdi
  802c8a:	00 00 00 
  802c8d:	b8 00 00 00 00       	mov    $0x0,%eax
  802c92:	48 b9 b5 04 80 00 00 	movabs $0x8004b5,%rcx
  802c99:	00 00 00 
  802c9c:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802c9e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ca3:	eb 2a                	jmp    802ccf <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802ca5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ca9:	48 8b 40 30          	mov    0x30(%rax),%rax
  802cad:	48 85 c0             	test   %rax,%rax
  802cb0:	75 07                	jne    802cb9 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802cb2:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802cb7:	eb 16                	jmp    802ccf <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802cb9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cbd:	48 8b 40 30          	mov    0x30(%rax),%rax
  802cc1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802cc5:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802cc8:	89 ce                	mov    %ecx,%esi
  802cca:	48 89 d7             	mov    %rdx,%rdi
  802ccd:	ff d0                	callq  *%rax
}
  802ccf:	c9                   	leaveq 
  802cd0:	c3                   	retq   

0000000000802cd1 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802cd1:	55                   	push   %rbp
  802cd2:	48 89 e5             	mov    %rsp,%rbp
  802cd5:	48 83 ec 30          	sub    $0x30,%rsp
  802cd9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802cdc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ce0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ce4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ce7:	48 89 d6             	mov    %rdx,%rsi
  802cea:	89 c7                	mov    %eax,%edi
  802cec:	48 b8 70 25 80 00 00 	movabs $0x802570,%rax
  802cf3:	00 00 00 
  802cf6:	ff d0                	callq  *%rax
  802cf8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cfb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cff:	78 24                	js     802d25 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d01:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d05:	8b 00                	mov    (%rax),%eax
  802d07:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d0b:	48 89 d6             	mov    %rdx,%rsi
  802d0e:	89 c7                	mov    %eax,%edi
  802d10:	48 b8 c9 26 80 00 00 	movabs $0x8026c9,%rax
  802d17:	00 00 00 
  802d1a:	ff d0                	callq  *%rax
  802d1c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d1f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d23:	79 05                	jns    802d2a <fstat+0x59>
		return r;
  802d25:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d28:	eb 5e                	jmp    802d88 <fstat+0xb7>
	if (!dev->dev_stat)
  802d2a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d2e:	48 8b 40 28          	mov    0x28(%rax),%rax
  802d32:	48 85 c0             	test   %rax,%rax
  802d35:	75 07                	jne    802d3e <fstat+0x6d>
		return -E_NOT_SUPP;
  802d37:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d3c:	eb 4a                	jmp    802d88 <fstat+0xb7>
	stat->st_name[0] = 0;
  802d3e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d42:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802d45:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d49:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802d50:	00 00 00 
	stat->st_isdir = 0;
  802d53:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d57:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802d5e:	00 00 00 
	stat->st_dev = dev;
  802d61:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d65:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d69:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802d70:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d74:	48 8b 40 28          	mov    0x28(%rax),%rax
  802d78:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d7c:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802d80:	48 89 ce             	mov    %rcx,%rsi
  802d83:	48 89 d7             	mov    %rdx,%rdi
  802d86:	ff d0                	callq  *%rax
}
  802d88:	c9                   	leaveq 
  802d89:	c3                   	retq   

0000000000802d8a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802d8a:	55                   	push   %rbp
  802d8b:	48 89 e5             	mov    %rsp,%rbp
  802d8e:	48 83 ec 20          	sub    $0x20,%rsp
  802d92:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d96:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802d9a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d9e:	be 00 00 00 00       	mov    $0x0,%esi
  802da3:	48 89 c7             	mov    %rax,%rdi
  802da6:	48 b8 78 2e 80 00 00 	movabs $0x802e78,%rax
  802dad:	00 00 00 
  802db0:	ff d0                	callq  *%rax
  802db2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802db5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802db9:	79 05                	jns    802dc0 <stat+0x36>
		return fd;
  802dbb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dbe:	eb 2f                	jmp    802def <stat+0x65>
	r = fstat(fd, stat);
  802dc0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802dc4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dc7:	48 89 d6             	mov    %rdx,%rsi
  802dca:	89 c7                	mov    %eax,%edi
  802dcc:	48 b8 d1 2c 80 00 00 	movabs $0x802cd1,%rax
  802dd3:	00 00 00 
  802dd6:	ff d0                	callq  *%rax
  802dd8:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802ddb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dde:	89 c7                	mov    %eax,%edi
  802de0:	48 b8 80 27 80 00 00 	movabs $0x802780,%rax
  802de7:	00 00 00 
  802dea:	ff d0                	callq  *%rax
	return r;
  802dec:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802def:	c9                   	leaveq 
  802df0:	c3                   	retq   

0000000000802df1 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802df1:	55                   	push   %rbp
  802df2:	48 89 e5             	mov    %rsp,%rbp
  802df5:	48 83 ec 10          	sub    $0x10,%rsp
  802df9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802dfc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802e00:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802e07:	00 00 00 
  802e0a:	8b 00                	mov    (%rax),%eax
  802e0c:	85 c0                	test   %eax,%eax
  802e0e:	75 1d                	jne    802e2d <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802e10:	bf 01 00 00 00       	mov    $0x1,%edi
  802e15:	48 b8 08 24 80 00 00 	movabs $0x802408,%rax
  802e1c:	00 00 00 
  802e1f:	ff d0                	callq  *%rax
  802e21:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802e28:	00 00 00 
  802e2b:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802e2d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802e34:	00 00 00 
  802e37:	8b 00                	mov    (%rax),%eax
  802e39:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802e3c:	b9 07 00 00 00       	mov    $0x7,%ecx
  802e41:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802e48:	00 00 00 
  802e4b:	89 c7                	mov    %eax,%edi
  802e4d:	48 b8 a6 23 80 00 00 	movabs $0x8023a6,%rax
  802e54:	00 00 00 
  802e57:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802e59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e5d:	ba 00 00 00 00       	mov    $0x0,%edx
  802e62:	48 89 c6             	mov    %rax,%rsi
  802e65:	bf 00 00 00 00       	mov    $0x0,%edi
  802e6a:	48 b8 a0 22 80 00 00 	movabs $0x8022a0,%rax
  802e71:	00 00 00 
  802e74:	ff d0                	callq  *%rax
}
  802e76:	c9                   	leaveq 
  802e77:	c3                   	retq   

0000000000802e78 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802e78:	55                   	push   %rbp
  802e79:	48 89 e5             	mov    %rsp,%rbp
  802e7c:	48 83 ec 30          	sub    $0x30,%rsp
  802e80:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802e84:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802e87:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802e8e:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802e95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802e9c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802ea1:	75 08                	jne    802eab <open+0x33>
	{
		return r;
  802ea3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ea6:	e9 f2 00 00 00       	jmpq   802f9d <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802eab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802eaf:	48 89 c7             	mov    %rax,%rdi
  802eb2:	48 b8 fe 0f 80 00 00 	movabs $0x800ffe,%rax
  802eb9:	00 00 00 
  802ebc:	ff d0                	callq  *%rax
  802ebe:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802ec1:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802ec8:	7e 0a                	jle    802ed4 <open+0x5c>
	{
		return -E_BAD_PATH;
  802eca:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802ecf:	e9 c9 00 00 00       	jmpq   802f9d <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802ed4:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802edb:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802edc:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802ee0:	48 89 c7             	mov    %rax,%rdi
  802ee3:	48 b8 d8 24 80 00 00 	movabs $0x8024d8,%rax
  802eea:	00 00 00 
  802eed:	ff d0                	callq  *%rax
  802eef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ef2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ef6:	78 09                	js     802f01 <open+0x89>
  802ef8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802efc:	48 85 c0             	test   %rax,%rax
  802eff:	75 08                	jne    802f09 <open+0x91>
		{
			return r;
  802f01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f04:	e9 94 00 00 00       	jmpq   802f9d <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802f09:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f0d:	ba 00 04 00 00       	mov    $0x400,%edx
  802f12:	48 89 c6             	mov    %rax,%rsi
  802f15:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802f1c:	00 00 00 
  802f1f:	48 b8 fc 10 80 00 00 	movabs $0x8010fc,%rax
  802f26:	00 00 00 
  802f29:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802f2b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f32:	00 00 00 
  802f35:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802f38:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802f3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f42:	48 89 c6             	mov    %rax,%rsi
  802f45:	bf 01 00 00 00       	mov    $0x1,%edi
  802f4a:	48 b8 f1 2d 80 00 00 	movabs $0x802df1,%rax
  802f51:	00 00 00 
  802f54:	ff d0                	callq  *%rax
  802f56:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f59:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f5d:	79 2b                	jns    802f8a <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802f5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f63:	be 00 00 00 00       	mov    $0x0,%esi
  802f68:	48 89 c7             	mov    %rax,%rdi
  802f6b:	48 b8 00 26 80 00 00 	movabs $0x802600,%rax
  802f72:	00 00 00 
  802f75:	ff d0                	callq  *%rax
  802f77:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802f7a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802f7e:	79 05                	jns    802f85 <open+0x10d>
			{
				return d;
  802f80:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f83:	eb 18                	jmp    802f9d <open+0x125>
			}
			return r;
  802f85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f88:	eb 13                	jmp    802f9d <open+0x125>
		}	
		return fd2num(fd_store);
  802f8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f8e:	48 89 c7             	mov    %rax,%rdi
  802f91:	48 b8 8a 24 80 00 00 	movabs $0x80248a,%rax
  802f98:	00 00 00 
  802f9b:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802f9d:	c9                   	leaveq 
  802f9e:	c3                   	retq   

0000000000802f9f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802f9f:	55                   	push   %rbp
  802fa0:	48 89 e5             	mov    %rsp,%rbp
  802fa3:	48 83 ec 10          	sub    $0x10,%rsp
  802fa7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802fab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802faf:	8b 50 0c             	mov    0xc(%rax),%edx
  802fb2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fb9:	00 00 00 
  802fbc:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802fbe:	be 00 00 00 00       	mov    $0x0,%esi
  802fc3:	bf 06 00 00 00       	mov    $0x6,%edi
  802fc8:	48 b8 f1 2d 80 00 00 	movabs $0x802df1,%rax
  802fcf:	00 00 00 
  802fd2:	ff d0                	callq  *%rax
}
  802fd4:	c9                   	leaveq 
  802fd5:	c3                   	retq   

0000000000802fd6 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802fd6:	55                   	push   %rbp
  802fd7:	48 89 e5             	mov    %rsp,%rbp
  802fda:	48 83 ec 30          	sub    $0x30,%rsp
  802fde:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802fe2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802fe6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802fea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802ff1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802ff6:	74 07                	je     802fff <devfile_read+0x29>
  802ff8:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802ffd:	75 07                	jne    803006 <devfile_read+0x30>
		return -E_INVAL;
  802fff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803004:	eb 77                	jmp    80307d <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  803006:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80300a:	8b 50 0c             	mov    0xc(%rax),%edx
  80300d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803014:	00 00 00 
  803017:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  803019:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803020:	00 00 00 
  803023:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803027:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  80302b:	be 00 00 00 00       	mov    $0x0,%esi
  803030:	bf 03 00 00 00       	mov    $0x3,%edi
  803035:	48 b8 f1 2d 80 00 00 	movabs $0x802df1,%rax
  80303c:	00 00 00 
  80303f:	ff d0                	callq  *%rax
  803041:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803044:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803048:	7f 05                	jg     80304f <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  80304a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80304d:	eb 2e                	jmp    80307d <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  80304f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803052:	48 63 d0             	movslq %eax,%rdx
  803055:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803059:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803060:	00 00 00 
  803063:	48 89 c7             	mov    %rax,%rdi
  803066:	48 b8 8e 13 80 00 00 	movabs $0x80138e,%rax
  80306d:	00 00 00 
  803070:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  803072:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803076:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  80307a:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  80307d:	c9                   	leaveq 
  80307e:	c3                   	retq   

000000000080307f <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80307f:	55                   	push   %rbp
  803080:	48 89 e5             	mov    %rsp,%rbp
  803083:	48 83 ec 30          	sub    $0x30,%rsp
  803087:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80308b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80308f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  803093:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  80309a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80309f:	74 07                	je     8030a8 <devfile_write+0x29>
  8030a1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8030a6:	75 08                	jne    8030b0 <devfile_write+0x31>
		return r;
  8030a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030ab:	e9 9a 00 00 00       	jmpq   80314a <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8030b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030b4:	8b 50 0c             	mov    0xc(%rax),%edx
  8030b7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030be:	00 00 00 
  8030c1:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  8030c3:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8030ca:	00 
  8030cb:	76 08                	jbe    8030d5 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  8030cd:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8030d4:	00 
	}
	fsipcbuf.write.req_n = n;
  8030d5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030dc:	00 00 00 
  8030df:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8030e3:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  8030e7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8030eb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030ef:	48 89 c6             	mov    %rax,%rsi
  8030f2:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  8030f9:	00 00 00 
  8030fc:	48 b8 8e 13 80 00 00 	movabs $0x80138e,%rax
  803103:	00 00 00 
  803106:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  803108:	be 00 00 00 00       	mov    $0x0,%esi
  80310d:	bf 04 00 00 00       	mov    $0x4,%edi
  803112:	48 b8 f1 2d 80 00 00 	movabs $0x802df1,%rax
  803119:	00 00 00 
  80311c:	ff d0                	callq  *%rax
  80311e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803121:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803125:	7f 20                	jg     803147 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  803127:	48 bf b6 43 80 00 00 	movabs $0x8043b6,%rdi
  80312e:	00 00 00 
  803131:	b8 00 00 00 00       	mov    $0x0,%eax
  803136:	48 ba b5 04 80 00 00 	movabs $0x8004b5,%rdx
  80313d:	00 00 00 
  803140:	ff d2                	callq  *%rdx
		return r;
  803142:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803145:	eb 03                	jmp    80314a <devfile_write+0xcb>
	}
	return r;
  803147:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  80314a:	c9                   	leaveq 
  80314b:	c3                   	retq   

000000000080314c <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80314c:	55                   	push   %rbp
  80314d:	48 89 e5             	mov    %rsp,%rbp
  803150:	48 83 ec 20          	sub    $0x20,%rsp
  803154:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803158:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80315c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803160:	8b 50 0c             	mov    0xc(%rax),%edx
  803163:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80316a:	00 00 00 
  80316d:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80316f:	be 00 00 00 00       	mov    $0x0,%esi
  803174:	bf 05 00 00 00       	mov    $0x5,%edi
  803179:	48 b8 f1 2d 80 00 00 	movabs $0x802df1,%rax
  803180:	00 00 00 
  803183:	ff d0                	callq  *%rax
  803185:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803188:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80318c:	79 05                	jns    803193 <devfile_stat+0x47>
		return r;
  80318e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803191:	eb 56                	jmp    8031e9 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803193:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803197:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80319e:	00 00 00 
  8031a1:	48 89 c7             	mov    %rax,%rdi
  8031a4:	48 b8 6a 10 80 00 00 	movabs $0x80106a,%rax
  8031ab:	00 00 00 
  8031ae:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8031b0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031b7:	00 00 00 
  8031ba:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8031c0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031c4:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8031ca:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031d1:	00 00 00 
  8031d4:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8031da:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031de:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8031e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031e9:	c9                   	leaveq 
  8031ea:	c3                   	retq   

00000000008031eb <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8031eb:	55                   	push   %rbp
  8031ec:	48 89 e5             	mov    %rsp,%rbp
  8031ef:	48 83 ec 10          	sub    $0x10,%rsp
  8031f3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8031f7:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8031fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031fe:	8b 50 0c             	mov    0xc(%rax),%edx
  803201:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803208:	00 00 00 
  80320b:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80320d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803214:	00 00 00 
  803217:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80321a:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80321d:	be 00 00 00 00       	mov    $0x0,%esi
  803222:	bf 02 00 00 00       	mov    $0x2,%edi
  803227:	48 b8 f1 2d 80 00 00 	movabs $0x802df1,%rax
  80322e:	00 00 00 
  803231:	ff d0                	callq  *%rax
}
  803233:	c9                   	leaveq 
  803234:	c3                   	retq   

0000000000803235 <remove>:

// Delete a file
int
remove(const char *path)
{
  803235:	55                   	push   %rbp
  803236:	48 89 e5             	mov    %rsp,%rbp
  803239:	48 83 ec 10          	sub    $0x10,%rsp
  80323d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803241:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803245:	48 89 c7             	mov    %rax,%rdi
  803248:	48 b8 fe 0f 80 00 00 	movabs $0x800ffe,%rax
  80324f:	00 00 00 
  803252:	ff d0                	callq  *%rax
  803254:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803259:	7e 07                	jle    803262 <remove+0x2d>
		return -E_BAD_PATH;
  80325b:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803260:	eb 33                	jmp    803295 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803262:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803266:	48 89 c6             	mov    %rax,%rsi
  803269:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  803270:	00 00 00 
  803273:	48 b8 6a 10 80 00 00 	movabs $0x80106a,%rax
  80327a:	00 00 00 
  80327d:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80327f:	be 00 00 00 00       	mov    $0x0,%esi
  803284:	bf 07 00 00 00       	mov    $0x7,%edi
  803289:	48 b8 f1 2d 80 00 00 	movabs $0x802df1,%rax
  803290:	00 00 00 
  803293:	ff d0                	callq  *%rax
}
  803295:	c9                   	leaveq 
  803296:	c3                   	retq   

0000000000803297 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803297:	55                   	push   %rbp
  803298:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80329b:	be 00 00 00 00       	mov    $0x0,%esi
  8032a0:	bf 08 00 00 00       	mov    $0x8,%edi
  8032a5:	48 b8 f1 2d 80 00 00 	movabs $0x802df1,%rax
  8032ac:	00 00 00 
  8032af:	ff d0                	callq  *%rax
}
  8032b1:	5d                   	pop    %rbp
  8032b2:	c3                   	retq   

00000000008032b3 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8032b3:	55                   	push   %rbp
  8032b4:	48 89 e5             	mov    %rsp,%rbp
  8032b7:	53                   	push   %rbx
  8032b8:	48 83 ec 38          	sub    $0x38,%rsp
  8032bc:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8032c0:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8032c4:	48 89 c7             	mov    %rax,%rdi
  8032c7:	48 b8 d8 24 80 00 00 	movabs $0x8024d8,%rax
  8032ce:	00 00 00 
  8032d1:	ff d0                	callq  *%rax
  8032d3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032da:	0f 88 bf 01 00 00    	js     80349f <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8032e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032e4:	ba 07 04 00 00       	mov    $0x407,%edx
  8032e9:	48 89 c6             	mov    %rax,%rsi
  8032ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8032f1:	48 b8 99 19 80 00 00 	movabs $0x801999,%rax
  8032f8:	00 00 00 
  8032fb:	ff d0                	callq  *%rax
  8032fd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803300:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803304:	0f 88 95 01 00 00    	js     80349f <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80330a:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80330e:	48 89 c7             	mov    %rax,%rdi
  803311:	48 b8 d8 24 80 00 00 	movabs $0x8024d8,%rax
  803318:	00 00 00 
  80331b:	ff d0                	callq  *%rax
  80331d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803320:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803324:	0f 88 5d 01 00 00    	js     803487 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80332a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80332e:	ba 07 04 00 00       	mov    $0x407,%edx
  803333:	48 89 c6             	mov    %rax,%rsi
  803336:	bf 00 00 00 00       	mov    $0x0,%edi
  80333b:	48 b8 99 19 80 00 00 	movabs $0x801999,%rax
  803342:	00 00 00 
  803345:	ff d0                	callq  *%rax
  803347:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80334a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80334e:	0f 88 33 01 00 00    	js     803487 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803354:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803358:	48 89 c7             	mov    %rax,%rdi
  80335b:	48 b8 ad 24 80 00 00 	movabs $0x8024ad,%rax
  803362:	00 00 00 
  803365:	ff d0                	callq  *%rax
  803367:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80336b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80336f:	ba 07 04 00 00       	mov    $0x407,%edx
  803374:	48 89 c6             	mov    %rax,%rsi
  803377:	bf 00 00 00 00       	mov    $0x0,%edi
  80337c:	48 b8 99 19 80 00 00 	movabs $0x801999,%rax
  803383:	00 00 00 
  803386:	ff d0                	callq  *%rax
  803388:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80338b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80338f:	79 05                	jns    803396 <pipe+0xe3>
		goto err2;
  803391:	e9 d9 00 00 00       	jmpq   80346f <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803396:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80339a:	48 89 c7             	mov    %rax,%rdi
  80339d:	48 b8 ad 24 80 00 00 	movabs $0x8024ad,%rax
  8033a4:	00 00 00 
  8033a7:	ff d0                	callq  *%rax
  8033a9:	48 89 c2             	mov    %rax,%rdx
  8033ac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033b0:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8033b6:	48 89 d1             	mov    %rdx,%rcx
  8033b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8033be:	48 89 c6             	mov    %rax,%rsi
  8033c1:	bf 00 00 00 00       	mov    $0x0,%edi
  8033c6:	48 b8 e9 19 80 00 00 	movabs $0x8019e9,%rax
  8033cd:	00 00 00 
  8033d0:	ff d0                	callq  *%rax
  8033d2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8033d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8033d9:	79 1b                	jns    8033f6 <pipe+0x143>
		goto err3;
  8033db:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  8033dc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033e0:	48 89 c6             	mov    %rax,%rsi
  8033e3:	bf 00 00 00 00       	mov    $0x0,%edi
  8033e8:	48 b8 44 1a 80 00 00 	movabs $0x801a44,%rax
  8033ef:	00 00 00 
  8033f2:	ff d0                	callq  *%rax
  8033f4:	eb 79                	jmp    80346f <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8033f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033fa:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803401:	00 00 00 
  803404:	8b 12                	mov    (%rdx),%edx
  803406:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803408:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80340c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803413:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803417:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  80341e:	00 00 00 
  803421:	8b 12                	mov    (%rdx),%edx
  803423:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803425:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803429:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803430:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803434:	48 89 c7             	mov    %rax,%rdi
  803437:	48 b8 8a 24 80 00 00 	movabs $0x80248a,%rax
  80343e:	00 00 00 
  803441:	ff d0                	callq  *%rax
  803443:	89 c2                	mov    %eax,%edx
  803445:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803449:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80344b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80344f:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803453:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803457:	48 89 c7             	mov    %rax,%rdi
  80345a:	48 b8 8a 24 80 00 00 	movabs $0x80248a,%rax
  803461:	00 00 00 
  803464:	ff d0                	callq  *%rax
  803466:	89 03                	mov    %eax,(%rbx)
	return 0;
  803468:	b8 00 00 00 00       	mov    $0x0,%eax
  80346d:	eb 33                	jmp    8034a2 <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  80346f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803473:	48 89 c6             	mov    %rax,%rsi
  803476:	bf 00 00 00 00       	mov    $0x0,%edi
  80347b:	48 b8 44 1a 80 00 00 	movabs $0x801a44,%rax
  803482:	00 00 00 
  803485:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  803487:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80348b:	48 89 c6             	mov    %rax,%rsi
  80348e:	bf 00 00 00 00       	mov    $0x0,%edi
  803493:	48 b8 44 1a 80 00 00 	movabs $0x801a44,%rax
  80349a:	00 00 00 
  80349d:	ff d0                	callq  *%rax
    err:
	return r;
  80349f:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8034a2:	48 83 c4 38          	add    $0x38,%rsp
  8034a6:	5b                   	pop    %rbx
  8034a7:	5d                   	pop    %rbp
  8034a8:	c3                   	retq   

00000000008034a9 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8034a9:	55                   	push   %rbp
  8034aa:	48 89 e5             	mov    %rsp,%rbp
  8034ad:	53                   	push   %rbx
  8034ae:	48 83 ec 28          	sub    $0x28,%rsp
  8034b2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8034b6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8034ba:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8034c1:	00 00 00 
  8034c4:	48 8b 00             	mov    (%rax),%rax
  8034c7:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8034cd:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8034d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034d4:	48 89 c7             	mov    %rax,%rdi
  8034d7:	48 b8 6f 3c 80 00 00 	movabs $0x803c6f,%rax
  8034de:	00 00 00 
  8034e1:	ff d0                	callq  *%rax
  8034e3:	89 c3                	mov    %eax,%ebx
  8034e5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034e9:	48 89 c7             	mov    %rax,%rdi
  8034ec:	48 b8 6f 3c 80 00 00 	movabs $0x803c6f,%rax
  8034f3:	00 00 00 
  8034f6:	ff d0                	callq  *%rax
  8034f8:	39 c3                	cmp    %eax,%ebx
  8034fa:	0f 94 c0             	sete   %al
  8034fd:	0f b6 c0             	movzbl %al,%eax
  803500:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803503:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80350a:	00 00 00 
  80350d:	48 8b 00             	mov    (%rax),%rax
  803510:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803516:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803519:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80351c:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80351f:	75 05                	jne    803526 <_pipeisclosed+0x7d>
			return ret;
  803521:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803524:	eb 4f                	jmp    803575 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803526:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803529:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80352c:	74 42                	je     803570 <_pipeisclosed+0xc7>
  80352e:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803532:	75 3c                	jne    803570 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803534:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80353b:	00 00 00 
  80353e:	48 8b 00             	mov    (%rax),%rax
  803541:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803547:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80354a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80354d:	89 c6                	mov    %eax,%esi
  80354f:	48 bf d7 43 80 00 00 	movabs $0x8043d7,%rdi
  803556:	00 00 00 
  803559:	b8 00 00 00 00       	mov    $0x0,%eax
  80355e:	49 b8 b5 04 80 00 00 	movabs $0x8004b5,%r8
  803565:	00 00 00 
  803568:	41 ff d0             	callq  *%r8
	}
  80356b:	e9 4a ff ff ff       	jmpq   8034ba <_pipeisclosed+0x11>
  803570:	e9 45 ff ff ff       	jmpq   8034ba <_pipeisclosed+0x11>
}
  803575:	48 83 c4 28          	add    $0x28,%rsp
  803579:	5b                   	pop    %rbx
  80357a:	5d                   	pop    %rbp
  80357b:	c3                   	retq   

000000000080357c <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80357c:	55                   	push   %rbp
  80357d:	48 89 e5             	mov    %rsp,%rbp
  803580:	48 83 ec 30          	sub    $0x30,%rsp
  803584:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803587:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80358b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80358e:	48 89 d6             	mov    %rdx,%rsi
  803591:	89 c7                	mov    %eax,%edi
  803593:	48 b8 70 25 80 00 00 	movabs $0x802570,%rax
  80359a:	00 00 00 
  80359d:	ff d0                	callq  *%rax
  80359f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035a6:	79 05                	jns    8035ad <pipeisclosed+0x31>
		return r;
  8035a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035ab:	eb 31                	jmp    8035de <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8035ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035b1:	48 89 c7             	mov    %rax,%rdi
  8035b4:	48 b8 ad 24 80 00 00 	movabs $0x8024ad,%rax
  8035bb:	00 00 00 
  8035be:	ff d0                	callq  *%rax
  8035c0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8035c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035c8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8035cc:	48 89 d6             	mov    %rdx,%rsi
  8035cf:	48 89 c7             	mov    %rax,%rdi
  8035d2:	48 b8 a9 34 80 00 00 	movabs $0x8034a9,%rax
  8035d9:	00 00 00 
  8035dc:	ff d0                	callq  *%rax
}
  8035de:	c9                   	leaveq 
  8035df:	c3                   	retq   

00000000008035e0 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8035e0:	55                   	push   %rbp
  8035e1:	48 89 e5             	mov    %rsp,%rbp
  8035e4:	48 83 ec 40          	sub    $0x40,%rsp
  8035e8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8035ec:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8035f0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8035f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035f8:	48 89 c7             	mov    %rax,%rdi
  8035fb:	48 b8 ad 24 80 00 00 	movabs $0x8024ad,%rax
  803602:	00 00 00 
  803605:	ff d0                	callq  *%rax
  803607:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80360b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80360f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803613:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80361a:	00 
  80361b:	e9 92 00 00 00       	jmpq   8036b2 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803620:	eb 41                	jmp    803663 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803622:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803627:	74 09                	je     803632 <devpipe_read+0x52>
				return i;
  803629:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80362d:	e9 92 00 00 00       	jmpq   8036c4 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803632:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803636:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80363a:	48 89 d6             	mov    %rdx,%rsi
  80363d:	48 89 c7             	mov    %rax,%rdi
  803640:	48 b8 a9 34 80 00 00 	movabs $0x8034a9,%rax
  803647:	00 00 00 
  80364a:	ff d0                	callq  *%rax
  80364c:	85 c0                	test   %eax,%eax
  80364e:	74 07                	je     803657 <devpipe_read+0x77>
				return 0;
  803650:	b8 00 00 00 00       	mov    $0x0,%eax
  803655:	eb 6d                	jmp    8036c4 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803657:	48 b8 5b 19 80 00 00 	movabs $0x80195b,%rax
  80365e:	00 00 00 
  803661:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803663:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803667:	8b 10                	mov    (%rax),%edx
  803669:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80366d:	8b 40 04             	mov    0x4(%rax),%eax
  803670:	39 c2                	cmp    %eax,%edx
  803672:	74 ae                	je     803622 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803674:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803678:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80367c:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803680:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803684:	8b 00                	mov    (%rax),%eax
  803686:	99                   	cltd   
  803687:	c1 ea 1b             	shr    $0x1b,%edx
  80368a:	01 d0                	add    %edx,%eax
  80368c:	83 e0 1f             	and    $0x1f,%eax
  80368f:	29 d0                	sub    %edx,%eax
  803691:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803695:	48 98                	cltq   
  803697:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80369c:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80369e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036a2:	8b 00                	mov    (%rax),%eax
  8036a4:	8d 50 01             	lea    0x1(%rax),%edx
  8036a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036ab:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8036ad:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8036b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036b6:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8036ba:	0f 82 60 ff ff ff    	jb     803620 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8036c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8036c4:	c9                   	leaveq 
  8036c5:	c3                   	retq   

00000000008036c6 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8036c6:	55                   	push   %rbp
  8036c7:	48 89 e5             	mov    %rsp,%rbp
  8036ca:	48 83 ec 40          	sub    $0x40,%rsp
  8036ce:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8036d2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8036d6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8036da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036de:	48 89 c7             	mov    %rax,%rdi
  8036e1:	48 b8 ad 24 80 00 00 	movabs $0x8024ad,%rax
  8036e8:	00 00 00 
  8036eb:	ff d0                	callq  *%rax
  8036ed:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8036f1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036f5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8036f9:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803700:	00 
  803701:	e9 8e 00 00 00       	jmpq   803794 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803706:	eb 31                	jmp    803739 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803708:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80370c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803710:	48 89 d6             	mov    %rdx,%rsi
  803713:	48 89 c7             	mov    %rax,%rdi
  803716:	48 b8 a9 34 80 00 00 	movabs $0x8034a9,%rax
  80371d:	00 00 00 
  803720:	ff d0                	callq  *%rax
  803722:	85 c0                	test   %eax,%eax
  803724:	74 07                	je     80372d <devpipe_write+0x67>
				return 0;
  803726:	b8 00 00 00 00       	mov    $0x0,%eax
  80372b:	eb 79                	jmp    8037a6 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80372d:	48 b8 5b 19 80 00 00 	movabs $0x80195b,%rax
  803734:	00 00 00 
  803737:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803739:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80373d:	8b 40 04             	mov    0x4(%rax),%eax
  803740:	48 63 d0             	movslq %eax,%rdx
  803743:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803747:	8b 00                	mov    (%rax),%eax
  803749:	48 98                	cltq   
  80374b:	48 83 c0 20          	add    $0x20,%rax
  80374f:	48 39 c2             	cmp    %rax,%rdx
  803752:	73 b4                	jae    803708 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803754:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803758:	8b 40 04             	mov    0x4(%rax),%eax
  80375b:	99                   	cltd   
  80375c:	c1 ea 1b             	shr    $0x1b,%edx
  80375f:	01 d0                	add    %edx,%eax
  803761:	83 e0 1f             	and    $0x1f,%eax
  803764:	29 d0                	sub    %edx,%eax
  803766:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80376a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80376e:	48 01 ca             	add    %rcx,%rdx
  803771:	0f b6 0a             	movzbl (%rdx),%ecx
  803774:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803778:	48 98                	cltq   
  80377a:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80377e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803782:	8b 40 04             	mov    0x4(%rax),%eax
  803785:	8d 50 01             	lea    0x1(%rax),%edx
  803788:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80378c:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80378f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803794:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803798:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80379c:	0f 82 64 ff ff ff    	jb     803706 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8037a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8037a6:	c9                   	leaveq 
  8037a7:	c3                   	retq   

00000000008037a8 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8037a8:	55                   	push   %rbp
  8037a9:	48 89 e5             	mov    %rsp,%rbp
  8037ac:	48 83 ec 20          	sub    $0x20,%rsp
  8037b0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8037b4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8037b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037bc:	48 89 c7             	mov    %rax,%rdi
  8037bf:	48 b8 ad 24 80 00 00 	movabs $0x8024ad,%rax
  8037c6:	00 00 00 
  8037c9:	ff d0                	callq  *%rax
  8037cb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8037cf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037d3:	48 be ea 43 80 00 00 	movabs $0x8043ea,%rsi
  8037da:	00 00 00 
  8037dd:	48 89 c7             	mov    %rax,%rdi
  8037e0:	48 b8 6a 10 80 00 00 	movabs $0x80106a,%rax
  8037e7:	00 00 00 
  8037ea:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8037ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037f0:	8b 50 04             	mov    0x4(%rax),%edx
  8037f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037f7:	8b 00                	mov    (%rax),%eax
  8037f9:	29 c2                	sub    %eax,%edx
  8037fb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037ff:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803805:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803809:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803810:	00 00 00 
	stat->st_dev = &devpipe;
  803813:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803817:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  80381e:	00 00 00 
  803821:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803828:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80382d:	c9                   	leaveq 
  80382e:	c3                   	retq   

000000000080382f <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80382f:	55                   	push   %rbp
  803830:	48 89 e5             	mov    %rsp,%rbp
  803833:	48 83 ec 10          	sub    $0x10,%rsp
  803837:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80383b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80383f:	48 89 c6             	mov    %rax,%rsi
  803842:	bf 00 00 00 00       	mov    $0x0,%edi
  803847:	48 b8 44 1a 80 00 00 	movabs $0x801a44,%rax
  80384e:	00 00 00 
  803851:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803853:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803857:	48 89 c7             	mov    %rax,%rdi
  80385a:	48 b8 ad 24 80 00 00 	movabs $0x8024ad,%rax
  803861:	00 00 00 
  803864:	ff d0                	callq  *%rax
  803866:	48 89 c6             	mov    %rax,%rsi
  803869:	bf 00 00 00 00       	mov    $0x0,%edi
  80386e:	48 b8 44 1a 80 00 00 	movabs $0x801a44,%rax
  803875:	00 00 00 
  803878:	ff d0                	callq  *%rax
}
  80387a:	c9                   	leaveq 
  80387b:	c3                   	retq   

000000000080387c <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80387c:	55                   	push   %rbp
  80387d:	48 89 e5             	mov    %rsp,%rbp
  803880:	48 83 ec 20          	sub    $0x20,%rsp
  803884:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803887:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80388a:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80388d:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803891:	be 01 00 00 00       	mov    $0x1,%esi
  803896:	48 89 c7             	mov    %rax,%rdi
  803899:	48 b8 51 18 80 00 00 	movabs $0x801851,%rax
  8038a0:	00 00 00 
  8038a3:	ff d0                	callq  *%rax
}
  8038a5:	c9                   	leaveq 
  8038a6:	c3                   	retq   

00000000008038a7 <getchar>:

int
getchar(void)
{
  8038a7:	55                   	push   %rbp
  8038a8:	48 89 e5             	mov    %rsp,%rbp
  8038ab:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8038af:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8038b3:	ba 01 00 00 00       	mov    $0x1,%edx
  8038b8:	48 89 c6             	mov    %rax,%rsi
  8038bb:	bf 00 00 00 00       	mov    $0x0,%edi
  8038c0:	48 b8 a2 29 80 00 00 	movabs $0x8029a2,%rax
  8038c7:	00 00 00 
  8038ca:	ff d0                	callq  *%rax
  8038cc:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8038cf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038d3:	79 05                	jns    8038da <getchar+0x33>
		return r;
  8038d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038d8:	eb 14                	jmp    8038ee <getchar+0x47>
	if (r < 1)
  8038da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038de:	7f 07                	jg     8038e7 <getchar+0x40>
		return -E_EOF;
  8038e0:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8038e5:	eb 07                	jmp    8038ee <getchar+0x47>
	return c;
  8038e7:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8038eb:	0f b6 c0             	movzbl %al,%eax
}
  8038ee:	c9                   	leaveq 
  8038ef:	c3                   	retq   

00000000008038f0 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8038f0:	55                   	push   %rbp
  8038f1:	48 89 e5             	mov    %rsp,%rbp
  8038f4:	48 83 ec 20          	sub    $0x20,%rsp
  8038f8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8038fb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8038ff:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803902:	48 89 d6             	mov    %rdx,%rsi
  803905:	89 c7                	mov    %eax,%edi
  803907:	48 b8 70 25 80 00 00 	movabs $0x802570,%rax
  80390e:	00 00 00 
  803911:	ff d0                	callq  *%rax
  803913:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803916:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80391a:	79 05                	jns    803921 <iscons+0x31>
		return r;
  80391c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80391f:	eb 1a                	jmp    80393b <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803921:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803925:	8b 10                	mov    (%rax),%edx
  803927:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  80392e:	00 00 00 
  803931:	8b 00                	mov    (%rax),%eax
  803933:	39 c2                	cmp    %eax,%edx
  803935:	0f 94 c0             	sete   %al
  803938:	0f b6 c0             	movzbl %al,%eax
}
  80393b:	c9                   	leaveq 
  80393c:	c3                   	retq   

000000000080393d <opencons>:

int
opencons(void)
{
  80393d:	55                   	push   %rbp
  80393e:	48 89 e5             	mov    %rsp,%rbp
  803941:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803945:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803949:	48 89 c7             	mov    %rax,%rdi
  80394c:	48 b8 d8 24 80 00 00 	movabs $0x8024d8,%rax
  803953:	00 00 00 
  803956:	ff d0                	callq  *%rax
  803958:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80395b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80395f:	79 05                	jns    803966 <opencons+0x29>
		return r;
  803961:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803964:	eb 5b                	jmp    8039c1 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803966:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80396a:	ba 07 04 00 00       	mov    $0x407,%edx
  80396f:	48 89 c6             	mov    %rax,%rsi
  803972:	bf 00 00 00 00       	mov    $0x0,%edi
  803977:	48 b8 99 19 80 00 00 	movabs $0x801999,%rax
  80397e:	00 00 00 
  803981:	ff d0                	callq  *%rax
  803983:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803986:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80398a:	79 05                	jns    803991 <opencons+0x54>
		return r;
  80398c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80398f:	eb 30                	jmp    8039c1 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803991:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803995:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  80399c:	00 00 00 
  80399f:	8b 12                	mov    (%rdx),%edx
  8039a1:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8039a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039a7:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8039ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039b2:	48 89 c7             	mov    %rax,%rdi
  8039b5:	48 b8 8a 24 80 00 00 	movabs $0x80248a,%rax
  8039bc:	00 00 00 
  8039bf:	ff d0                	callq  *%rax
}
  8039c1:	c9                   	leaveq 
  8039c2:	c3                   	retq   

00000000008039c3 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8039c3:	55                   	push   %rbp
  8039c4:	48 89 e5             	mov    %rsp,%rbp
  8039c7:	48 83 ec 30          	sub    $0x30,%rsp
  8039cb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8039cf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8039d3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8039d7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8039dc:	75 07                	jne    8039e5 <devcons_read+0x22>
		return 0;
  8039de:	b8 00 00 00 00       	mov    $0x0,%eax
  8039e3:	eb 4b                	jmp    803a30 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8039e5:	eb 0c                	jmp    8039f3 <devcons_read+0x30>
		sys_yield();
  8039e7:	48 b8 5b 19 80 00 00 	movabs $0x80195b,%rax
  8039ee:	00 00 00 
  8039f1:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8039f3:	48 b8 9b 18 80 00 00 	movabs $0x80189b,%rax
  8039fa:	00 00 00 
  8039fd:	ff d0                	callq  *%rax
  8039ff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a02:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a06:	74 df                	je     8039e7 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803a08:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a0c:	79 05                	jns    803a13 <devcons_read+0x50>
		return c;
  803a0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a11:	eb 1d                	jmp    803a30 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803a13:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803a17:	75 07                	jne    803a20 <devcons_read+0x5d>
		return 0;
  803a19:	b8 00 00 00 00       	mov    $0x0,%eax
  803a1e:	eb 10                	jmp    803a30 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803a20:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a23:	89 c2                	mov    %eax,%edx
  803a25:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a29:	88 10                	mov    %dl,(%rax)
	return 1;
  803a2b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803a30:	c9                   	leaveq 
  803a31:	c3                   	retq   

0000000000803a32 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803a32:	55                   	push   %rbp
  803a33:	48 89 e5             	mov    %rsp,%rbp
  803a36:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803a3d:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803a44:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803a4b:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803a52:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803a59:	eb 76                	jmp    803ad1 <devcons_write+0x9f>
		m = n - tot;
  803a5b:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803a62:	89 c2                	mov    %eax,%edx
  803a64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a67:	29 c2                	sub    %eax,%edx
  803a69:	89 d0                	mov    %edx,%eax
  803a6b:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803a6e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a71:	83 f8 7f             	cmp    $0x7f,%eax
  803a74:	76 07                	jbe    803a7d <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803a76:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803a7d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a80:	48 63 d0             	movslq %eax,%rdx
  803a83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a86:	48 63 c8             	movslq %eax,%rcx
  803a89:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803a90:	48 01 c1             	add    %rax,%rcx
  803a93:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803a9a:	48 89 ce             	mov    %rcx,%rsi
  803a9d:	48 89 c7             	mov    %rax,%rdi
  803aa0:	48 b8 8e 13 80 00 00 	movabs $0x80138e,%rax
  803aa7:	00 00 00 
  803aaa:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803aac:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803aaf:	48 63 d0             	movslq %eax,%rdx
  803ab2:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803ab9:	48 89 d6             	mov    %rdx,%rsi
  803abc:	48 89 c7             	mov    %rax,%rdi
  803abf:	48 b8 51 18 80 00 00 	movabs $0x801851,%rax
  803ac6:	00 00 00 
  803ac9:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803acb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ace:	01 45 fc             	add    %eax,-0x4(%rbp)
  803ad1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ad4:	48 98                	cltq   
  803ad6:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803add:	0f 82 78 ff ff ff    	jb     803a5b <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803ae3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803ae6:	c9                   	leaveq 
  803ae7:	c3                   	retq   

0000000000803ae8 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803ae8:	55                   	push   %rbp
  803ae9:	48 89 e5             	mov    %rsp,%rbp
  803aec:	48 83 ec 08          	sub    $0x8,%rsp
  803af0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803af4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803af9:	c9                   	leaveq 
  803afa:	c3                   	retq   

0000000000803afb <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803afb:	55                   	push   %rbp
  803afc:	48 89 e5             	mov    %rsp,%rbp
  803aff:	48 83 ec 10          	sub    $0x10,%rsp
  803b03:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803b07:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803b0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b0f:	48 be f6 43 80 00 00 	movabs $0x8043f6,%rsi
  803b16:	00 00 00 
  803b19:	48 89 c7             	mov    %rax,%rdi
  803b1c:	48 b8 6a 10 80 00 00 	movabs $0x80106a,%rax
  803b23:	00 00 00 
  803b26:	ff d0                	callq  *%rax
	return 0;
  803b28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b2d:	c9                   	leaveq 
  803b2e:	c3                   	retq   

0000000000803b2f <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803b2f:	55                   	push   %rbp
  803b30:	48 89 e5             	mov    %rsp,%rbp
  803b33:	48 83 ec 10          	sub    $0x10,%rsp
  803b37:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  803b3b:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803b42:	00 00 00 
  803b45:	48 8b 00             	mov    (%rax),%rax
  803b48:	48 85 c0             	test   %rax,%rax
  803b4b:	0f 85 84 00 00 00    	jne    803bd5 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  803b51:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803b58:	00 00 00 
  803b5b:	48 8b 00             	mov    (%rax),%rax
  803b5e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803b64:	ba 07 00 00 00       	mov    $0x7,%edx
  803b69:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803b6e:	89 c7                	mov    %eax,%edi
  803b70:	48 b8 99 19 80 00 00 	movabs $0x801999,%rax
  803b77:	00 00 00 
  803b7a:	ff d0                	callq  *%rax
  803b7c:	85 c0                	test   %eax,%eax
  803b7e:	79 2a                	jns    803baa <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  803b80:	48 ba 00 44 80 00 00 	movabs $0x804400,%rdx
  803b87:	00 00 00 
  803b8a:	be 23 00 00 00       	mov    $0x23,%esi
  803b8f:	48 bf 27 44 80 00 00 	movabs $0x804427,%rdi
  803b96:	00 00 00 
  803b99:	b8 00 00 00 00       	mov    $0x0,%eax
  803b9e:	48 b9 7c 02 80 00 00 	movabs $0x80027c,%rcx
  803ba5:	00 00 00 
  803ba8:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  803baa:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803bb1:	00 00 00 
  803bb4:	48 8b 00             	mov    (%rax),%rax
  803bb7:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803bbd:	48 be e8 3b 80 00 00 	movabs $0x803be8,%rsi
  803bc4:	00 00 00 
  803bc7:	89 c7                	mov    %eax,%edi
  803bc9:	48 b8 23 1b 80 00 00 	movabs $0x801b23,%rax
  803bd0:	00 00 00 
  803bd3:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  803bd5:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803bdc:	00 00 00 
  803bdf:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803be3:	48 89 10             	mov    %rdx,(%rax)
}
  803be6:	c9                   	leaveq 
  803be7:	c3                   	retq   

0000000000803be8 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  803be8:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  803beb:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  803bf2:	00 00 00 
	call *%rax
  803bf5:	ff d0                	callq  *%rax


	/*This code is to be removed*/

	// LAB 4: Your code here.
	movq 136(%rsp), %rbx  //Load RIP 
  803bf7:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  803bfe:	00 
	movq 152(%rsp), %rcx  //Load RSP
  803bff:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  803c06:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  803c07:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  803c0b:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  803c0e:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  803c15:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  803c16:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  803c1a:	4c 8b 3c 24          	mov    (%rsp),%r15
  803c1e:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803c23:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803c28:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803c2d:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803c32:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803c37:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803c3c:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803c41:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803c46:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803c4b:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803c50:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803c55:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803c5a:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803c5f:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803c64:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  803c68:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  803c6c:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  803c6d:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  803c6e:	c3                   	retq   

0000000000803c6f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803c6f:	55                   	push   %rbp
  803c70:	48 89 e5             	mov    %rsp,%rbp
  803c73:	48 83 ec 18          	sub    $0x18,%rsp
  803c77:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803c7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c7f:	48 c1 e8 15          	shr    $0x15,%rax
  803c83:	48 89 c2             	mov    %rax,%rdx
  803c86:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803c8d:	01 00 00 
  803c90:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c94:	83 e0 01             	and    $0x1,%eax
  803c97:	48 85 c0             	test   %rax,%rax
  803c9a:	75 07                	jne    803ca3 <pageref+0x34>
		return 0;
  803c9c:	b8 00 00 00 00       	mov    $0x0,%eax
  803ca1:	eb 53                	jmp    803cf6 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803ca3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ca7:	48 c1 e8 0c          	shr    $0xc,%rax
  803cab:	48 89 c2             	mov    %rax,%rdx
  803cae:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803cb5:	01 00 00 
  803cb8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803cbc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803cc0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cc4:	83 e0 01             	and    $0x1,%eax
  803cc7:	48 85 c0             	test   %rax,%rax
  803cca:	75 07                	jne    803cd3 <pageref+0x64>
		return 0;
  803ccc:	b8 00 00 00 00       	mov    $0x0,%eax
  803cd1:	eb 23                	jmp    803cf6 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803cd3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cd7:	48 c1 e8 0c          	shr    $0xc,%rax
  803cdb:	48 89 c2             	mov    %rax,%rdx
  803cde:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803ce5:	00 00 00 
  803ce8:	48 c1 e2 04          	shl    $0x4,%rdx
  803cec:	48 01 d0             	add    %rdx,%rax
  803cef:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803cf3:	0f b7 c0             	movzwl %ax,%eax
}
  803cf6:	c9                   	leaveq 
  803cf7:	c3                   	retq   
