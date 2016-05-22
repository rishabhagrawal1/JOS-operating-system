
obj/user/testfdsharing.debug:     file format elf64-x86-64


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
  80003c:	e8 fa 02 00 00       	callq  80033b <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

char buf[512], buf2[512];

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r, n, n2;

	if ((fd = open("motd", O_RDONLY)) < 0)
  800052:	be 00 00 00 00       	mov    $0x0,%esi
  800057:	48 bf 20 3f 80 00 00 	movabs $0x803f20,%rdi
  80005e:	00 00 00 
  800061:	48 b8 fb 2d 80 00 00 	movabs $0x802dfb,%rax
  800068:	00 00 00 
  80006b:	ff d0                	callq  *%rax
  80006d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800070:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800074:	79 30                	jns    8000a6 <umain+0x63>
		panic("open motd: %e", fd);
  800076:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800079:	89 c1                	mov    %eax,%ecx
  80007b:	48 ba 25 3f 80 00 00 	movabs $0x803f25,%rdx
  800082:	00 00 00 
  800085:	be 0c 00 00 00       	mov    $0xc,%esi
  80008a:	48 bf 33 3f 80 00 00 	movabs $0x803f33,%rdi
  800091:	00 00 00 
  800094:	b8 00 00 00 00       	mov    $0x0,%eax
  800099:	49 b8 e9 03 80 00 00 	movabs $0x8003e9,%r8
  8000a0:	00 00 00 
  8000a3:	41 ff d0             	callq  *%r8
	seek(fd, 0);
  8000a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000a9:	be 00 00 00 00       	mov    $0x0,%esi
  8000ae:	89 c7                	mov    %eax,%edi
  8000b0:	48 b8 43 2b 80 00 00 	movabs $0x802b43,%rax
  8000b7:	00 00 00 
  8000ba:	ff d0                	callq  *%rax
	if ((n = readn(fd, buf, sizeof buf)) <= 0)
  8000bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000bf:	ba 00 02 00 00       	mov    $0x200,%edx
  8000c4:	48 be 20 72 80 00 00 	movabs $0x807220,%rsi
  8000cb:	00 00 00 
  8000ce:	89 c7                	mov    %eax,%edi
  8000d0:	48 b8 fa 29 80 00 00 	movabs $0x8029fa,%rax
  8000d7:	00 00 00 
  8000da:	ff d0                	callq  *%rax
  8000dc:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000df:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000e3:	7f 30                	jg     800115 <umain+0xd2>
		panic("readn: %e", n);
  8000e5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000e8:	89 c1                	mov    %eax,%ecx
  8000ea:	48 ba 48 3f 80 00 00 	movabs $0x803f48,%rdx
  8000f1:	00 00 00 
  8000f4:	be 0f 00 00 00       	mov    $0xf,%esi
  8000f9:	48 bf 33 3f 80 00 00 	movabs $0x803f33,%rdi
  800100:	00 00 00 
  800103:	b8 00 00 00 00       	mov    $0x0,%eax
  800108:	49 b8 e9 03 80 00 00 	movabs $0x8003e9,%r8
  80010f:	00 00 00 
  800112:	41 ff d0             	callq  *%r8

	if ((r = fork()) < 0)
  800115:	48 b8 5c 21 80 00 00 	movabs $0x80215c,%rax
  80011c:	00 00 00 
  80011f:	ff d0                	callq  *%rax
  800121:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800124:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800128:	79 30                	jns    80015a <umain+0x117>
		panic("fork: %e", r);
  80012a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80012d:	89 c1                	mov    %eax,%ecx
  80012f:	48 ba 52 3f 80 00 00 	movabs $0x803f52,%rdx
  800136:	00 00 00 
  800139:	be 12 00 00 00       	mov    $0x12,%esi
  80013e:	48 bf 33 3f 80 00 00 	movabs $0x803f33,%rdi
  800145:	00 00 00 
  800148:	b8 00 00 00 00       	mov    $0x0,%eax
  80014d:	49 b8 e9 03 80 00 00 	movabs $0x8003e9,%r8
  800154:	00 00 00 
  800157:	41 ff d0             	callq  *%r8
	if (r == 0) {
  80015a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80015e:	0f 85 36 01 00 00    	jne    80029a <umain+0x257>
		seek(fd, 0);
  800164:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800167:	be 00 00 00 00       	mov    $0x0,%esi
  80016c:	89 c7                	mov    %eax,%edi
  80016e:	48 b8 43 2b 80 00 00 	movabs $0x802b43,%rax
  800175:	00 00 00 
  800178:	ff d0                	callq  *%rax
		cprintf("going to read in child (might page fault if your sharing is buggy)\n");
  80017a:	48 bf 60 3f 80 00 00 	movabs $0x803f60,%rdi
  800181:	00 00 00 
  800184:	b8 00 00 00 00       	mov    $0x0,%eax
  800189:	48 ba 22 06 80 00 00 	movabs $0x800622,%rdx
  800190:	00 00 00 
  800193:	ff d2                	callq  *%rdx
		if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  800195:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800198:	ba 00 02 00 00       	mov    $0x200,%edx
  80019d:	48 be 20 70 80 00 00 	movabs $0x807020,%rsi
  8001a4:	00 00 00 
  8001a7:	89 c7                	mov    %eax,%edi
  8001a9:	48 b8 fa 29 80 00 00 	movabs $0x8029fa,%rax
  8001b0:	00 00 00 
  8001b3:	ff d0                	callq  *%rax
  8001b5:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8001b8:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001bb:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  8001be:	74 36                	je     8001f6 <umain+0x1b3>
			panic("read in parent got %d, read in child got %d", n, n2);
  8001c0:	8b 55 f0             	mov    -0x10(%rbp),%edx
  8001c3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001c6:	41 89 d0             	mov    %edx,%r8d
  8001c9:	89 c1                	mov    %eax,%ecx
  8001cb:	48 ba a8 3f 80 00 00 	movabs $0x803fa8,%rdx
  8001d2:	00 00 00 
  8001d5:	be 17 00 00 00       	mov    $0x17,%esi
  8001da:	48 bf 33 3f 80 00 00 	movabs $0x803f33,%rdi
  8001e1:	00 00 00 
  8001e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e9:	49 b9 e9 03 80 00 00 	movabs $0x8003e9,%r9
  8001f0:	00 00 00 
  8001f3:	41 ff d1             	callq  *%r9
		if (memcmp(buf, buf2, n) != 0)
  8001f6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001f9:	48 98                	cltq   
  8001fb:	48 89 c2             	mov    %rax,%rdx
  8001fe:	48 be 20 70 80 00 00 	movabs $0x807020,%rsi
  800205:	00 00 00 
  800208:	48 bf 20 72 80 00 00 	movabs $0x807220,%rdi
  80020f:	00 00 00 
  800212:	48 b8 46 16 80 00 00 	movabs $0x801646,%rax
  800219:	00 00 00 
  80021c:	ff d0                	callq  *%rax
  80021e:	85 c0                	test   %eax,%eax
  800220:	74 2a                	je     80024c <umain+0x209>
			panic("read in parent got different bytes from read in child");
  800222:	48 ba d8 3f 80 00 00 	movabs $0x803fd8,%rdx
  800229:	00 00 00 
  80022c:	be 19 00 00 00       	mov    $0x19,%esi
  800231:	48 bf 33 3f 80 00 00 	movabs $0x803f33,%rdi
  800238:	00 00 00 
  80023b:	b8 00 00 00 00       	mov    $0x0,%eax
  800240:	48 b9 e9 03 80 00 00 	movabs $0x8003e9,%rcx
  800247:	00 00 00 
  80024a:	ff d1                	callq  *%rcx
		cprintf("read in child succeeded\n");
  80024c:	48 bf 0e 40 80 00 00 	movabs $0x80400e,%rdi
  800253:	00 00 00 
  800256:	b8 00 00 00 00       	mov    $0x0,%eax
  80025b:	48 ba 22 06 80 00 00 	movabs $0x800622,%rdx
  800262:	00 00 00 
  800265:	ff d2                	callq  *%rdx
		seek(fd, 0);
  800267:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80026a:	be 00 00 00 00       	mov    $0x0,%esi
  80026f:	89 c7                	mov    %eax,%edi
  800271:	48 b8 43 2b 80 00 00 	movabs $0x802b43,%rax
  800278:	00 00 00 
  80027b:	ff d0                	callq  *%rax
		close(fd);
  80027d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800280:	89 c7                	mov    %eax,%edi
  800282:	48 b8 03 27 80 00 00 	movabs $0x802703,%rax
  800289:	00 00 00 
  80028c:	ff d0                	callq  *%rax
		exit();
  80028e:	48 b8 c6 03 80 00 00 	movabs $0x8003c6,%rax
  800295:	00 00 00 
  800298:	ff d0                	callq  *%rax
	}
	wait(r);
  80029a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80029d:	89 c7                	mov    %eax,%edi
  80029f:	48 b8 ff 37 80 00 00 	movabs $0x8037ff,%rax
  8002a6:	00 00 00 
  8002a9:	ff d0                	callq  *%rax
	if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  8002ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002ae:	ba 00 02 00 00       	mov    $0x200,%edx
  8002b3:	48 be 20 70 80 00 00 	movabs $0x807020,%rsi
  8002ba:	00 00 00 
  8002bd:	89 c7                	mov    %eax,%edi
  8002bf:	48 b8 fa 29 80 00 00 	movabs $0x8029fa,%rax
  8002c6:	00 00 00 
  8002c9:	ff d0                	callq  *%rax
  8002cb:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8002ce:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002d1:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  8002d4:	74 36                	je     80030c <umain+0x2c9>
		panic("read in parent got %d, then got %d", n, n2);
  8002d6:	8b 55 f0             	mov    -0x10(%rbp),%edx
  8002d9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002dc:	41 89 d0             	mov    %edx,%r8d
  8002df:	89 c1                	mov    %eax,%ecx
  8002e1:	48 ba 28 40 80 00 00 	movabs $0x804028,%rdx
  8002e8:	00 00 00 
  8002eb:	be 21 00 00 00       	mov    $0x21,%esi
  8002f0:	48 bf 33 3f 80 00 00 	movabs $0x803f33,%rdi
  8002f7:	00 00 00 
  8002fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8002ff:	49 b9 e9 03 80 00 00 	movabs $0x8003e9,%r9
  800306:	00 00 00 
  800309:	41 ff d1             	callq  *%r9
	cprintf("read in parent succeeded\n");
  80030c:	48 bf 4b 40 80 00 00 	movabs $0x80404b,%rdi
  800313:	00 00 00 
  800316:	b8 00 00 00 00       	mov    $0x0,%eax
  80031b:	48 ba 22 06 80 00 00 	movabs $0x800622,%rdx
  800322:	00 00 00 
  800325:	ff d2                	callq  *%rdx
	close(fd);
  800327:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80032a:	89 c7                	mov    %eax,%edi
  80032c:	48 b8 03 27 80 00 00 	movabs $0x802703,%rax
  800333:	00 00 00 
  800336:	ff d0                	callq  *%rax
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  800338:	cc                   	int3   

	breakpoint();
}
  800339:	c9                   	leaveq 
  80033a:	c3                   	retq   

000000000080033b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80033b:	55                   	push   %rbp
  80033c:	48 89 e5             	mov    %rsp,%rbp
  80033f:	48 83 ec 10          	sub    $0x10,%rsp
  800343:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800346:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80034a:	48 b8 8a 1a 80 00 00 	movabs $0x801a8a,%rax
  800351:	00 00 00 
  800354:	ff d0                	callq  *%rax
  800356:	25 ff 03 00 00       	and    $0x3ff,%eax
  80035b:	48 63 d0             	movslq %eax,%rdx
  80035e:	48 89 d0             	mov    %rdx,%rax
  800361:	48 c1 e0 03          	shl    $0x3,%rax
  800365:	48 01 d0             	add    %rdx,%rax
  800368:	48 c1 e0 05          	shl    $0x5,%rax
  80036c:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800373:	00 00 00 
  800376:	48 01 c2             	add    %rax,%rdx
  800379:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  800380:	00 00 00 
  800383:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800386:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80038a:	7e 14                	jle    8003a0 <libmain+0x65>
		binaryname = argv[0];
  80038c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800390:	48 8b 10             	mov    (%rax),%rdx
  800393:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80039a:	00 00 00 
  80039d:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8003a0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003a7:	48 89 d6             	mov    %rdx,%rsi
  8003aa:	89 c7                	mov    %eax,%edi
  8003ac:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8003b3:	00 00 00 
  8003b6:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8003b8:	48 b8 c6 03 80 00 00 	movabs $0x8003c6,%rax
  8003bf:	00 00 00 
  8003c2:	ff d0                	callq  *%rax
}
  8003c4:	c9                   	leaveq 
  8003c5:	c3                   	retq   

00000000008003c6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003c6:	55                   	push   %rbp
  8003c7:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8003ca:	48 b8 4e 27 80 00 00 	movabs $0x80274e,%rax
  8003d1:	00 00 00 
  8003d4:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8003d6:	bf 00 00 00 00       	mov    $0x0,%edi
  8003db:	48 b8 46 1a 80 00 00 	movabs $0x801a46,%rax
  8003e2:	00 00 00 
  8003e5:	ff d0                	callq  *%rax

}
  8003e7:	5d                   	pop    %rbp
  8003e8:	c3                   	retq   

00000000008003e9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003e9:	55                   	push   %rbp
  8003ea:	48 89 e5             	mov    %rsp,%rbp
  8003ed:	53                   	push   %rbx
  8003ee:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8003f5:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8003fc:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800402:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800409:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800410:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800417:	84 c0                	test   %al,%al
  800419:	74 23                	je     80043e <_panic+0x55>
  80041b:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800422:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800426:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80042a:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80042e:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800432:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800436:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80043a:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80043e:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800445:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80044c:	00 00 00 
  80044f:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800456:	00 00 00 
  800459:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80045d:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800464:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80046b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800472:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800479:	00 00 00 
  80047c:	48 8b 18             	mov    (%rax),%rbx
  80047f:	48 b8 8a 1a 80 00 00 	movabs $0x801a8a,%rax
  800486:	00 00 00 
  800489:	ff d0                	callq  *%rax
  80048b:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800491:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800498:	41 89 c8             	mov    %ecx,%r8d
  80049b:	48 89 d1             	mov    %rdx,%rcx
  80049e:	48 89 da             	mov    %rbx,%rdx
  8004a1:	89 c6                	mov    %eax,%esi
  8004a3:	48 bf 70 40 80 00 00 	movabs $0x804070,%rdi
  8004aa:	00 00 00 
  8004ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b2:	49 b9 22 06 80 00 00 	movabs $0x800622,%r9
  8004b9:	00 00 00 
  8004bc:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8004bf:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8004c6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8004cd:	48 89 d6             	mov    %rdx,%rsi
  8004d0:	48 89 c7             	mov    %rax,%rdi
  8004d3:	48 b8 76 05 80 00 00 	movabs $0x800576,%rax
  8004da:	00 00 00 
  8004dd:	ff d0                	callq  *%rax
	cprintf("\n");
  8004df:	48 bf 93 40 80 00 00 	movabs $0x804093,%rdi
  8004e6:	00 00 00 
  8004e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ee:	48 ba 22 06 80 00 00 	movabs $0x800622,%rdx
  8004f5:	00 00 00 
  8004f8:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8004fa:	cc                   	int3   
  8004fb:	eb fd                	jmp    8004fa <_panic+0x111>

00000000008004fd <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8004fd:	55                   	push   %rbp
  8004fe:	48 89 e5             	mov    %rsp,%rbp
  800501:	48 83 ec 10          	sub    $0x10,%rsp
  800505:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800508:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  80050c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800510:	8b 00                	mov    (%rax),%eax
  800512:	8d 48 01             	lea    0x1(%rax),%ecx
  800515:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800519:	89 0a                	mov    %ecx,(%rdx)
  80051b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80051e:	89 d1                	mov    %edx,%ecx
  800520:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800524:	48 98                	cltq   
  800526:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  80052a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80052e:	8b 00                	mov    (%rax),%eax
  800530:	3d ff 00 00 00       	cmp    $0xff,%eax
  800535:	75 2c                	jne    800563 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  800537:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80053b:	8b 00                	mov    (%rax),%eax
  80053d:	48 98                	cltq   
  80053f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800543:	48 83 c2 08          	add    $0x8,%rdx
  800547:	48 89 c6             	mov    %rax,%rsi
  80054a:	48 89 d7             	mov    %rdx,%rdi
  80054d:	48 b8 be 19 80 00 00 	movabs $0x8019be,%rax
  800554:	00 00 00 
  800557:	ff d0                	callq  *%rax
		b->idx = 0;
  800559:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80055d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800563:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800567:	8b 40 04             	mov    0x4(%rax),%eax
  80056a:	8d 50 01             	lea    0x1(%rax),%edx
  80056d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800571:	89 50 04             	mov    %edx,0x4(%rax)
}
  800574:	c9                   	leaveq 
  800575:	c3                   	retq   

0000000000800576 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800576:	55                   	push   %rbp
  800577:	48 89 e5             	mov    %rsp,%rbp
  80057a:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800581:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800588:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  80058f:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800596:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80059d:	48 8b 0a             	mov    (%rdx),%rcx
  8005a0:	48 89 08             	mov    %rcx,(%rax)
  8005a3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005a7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005ab:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005af:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8005b3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8005ba:	00 00 00 
	b.cnt = 0;
  8005bd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8005c4:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8005c7:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8005ce:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8005d5:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8005dc:	48 89 c6             	mov    %rax,%rsi
  8005df:	48 bf fd 04 80 00 00 	movabs $0x8004fd,%rdi
  8005e6:	00 00 00 
  8005e9:	48 b8 d5 09 80 00 00 	movabs $0x8009d5,%rax
  8005f0:	00 00 00 
  8005f3:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  8005f5:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8005fb:	48 98                	cltq   
  8005fd:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800604:	48 83 c2 08          	add    $0x8,%rdx
  800608:	48 89 c6             	mov    %rax,%rsi
  80060b:	48 89 d7             	mov    %rdx,%rdi
  80060e:	48 b8 be 19 80 00 00 	movabs $0x8019be,%rax
  800615:	00 00 00 
  800618:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  80061a:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800620:	c9                   	leaveq 
  800621:	c3                   	retq   

0000000000800622 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800622:	55                   	push   %rbp
  800623:	48 89 e5             	mov    %rsp,%rbp
  800626:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80062d:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800634:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80063b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800642:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800649:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800650:	84 c0                	test   %al,%al
  800652:	74 20                	je     800674 <cprintf+0x52>
  800654:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800658:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80065c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800660:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800664:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800668:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80066c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800670:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800674:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  80067b:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800682:	00 00 00 
  800685:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80068c:	00 00 00 
  80068f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800693:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80069a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8006a1:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8006a8:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8006af:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8006b6:	48 8b 0a             	mov    (%rdx),%rcx
  8006b9:	48 89 08             	mov    %rcx,(%rax)
  8006bc:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006c0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006c4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006c8:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8006cc:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8006d3:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8006da:	48 89 d6             	mov    %rdx,%rsi
  8006dd:	48 89 c7             	mov    %rax,%rdi
  8006e0:	48 b8 76 05 80 00 00 	movabs $0x800576,%rax
  8006e7:	00 00 00 
  8006ea:	ff d0                	callq  *%rax
  8006ec:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  8006f2:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8006f8:	c9                   	leaveq 
  8006f9:	c3                   	retq   

00000000008006fa <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006fa:	55                   	push   %rbp
  8006fb:	48 89 e5             	mov    %rsp,%rbp
  8006fe:	53                   	push   %rbx
  8006ff:	48 83 ec 38          	sub    $0x38,%rsp
  800703:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800707:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80070b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80070f:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800712:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800716:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80071a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80071d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800721:	77 3b                	ja     80075e <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800723:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800726:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80072a:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80072d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800731:	ba 00 00 00 00       	mov    $0x0,%edx
  800736:	48 f7 f3             	div    %rbx
  800739:	48 89 c2             	mov    %rax,%rdx
  80073c:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80073f:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800742:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800746:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074a:	41 89 f9             	mov    %edi,%r9d
  80074d:	48 89 c7             	mov    %rax,%rdi
  800750:	48 b8 fa 06 80 00 00 	movabs $0x8006fa,%rax
  800757:	00 00 00 
  80075a:	ff d0                	callq  *%rax
  80075c:	eb 1e                	jmp    80077c <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80075e:	eb 12                	jmp    800772 <printnum+0x78>
			putch(padc, putdat);
  800760:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800764:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800767:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80076b:	48 89 ce             	mov    %rcx,%rsi
  80076e:	89 d7                	mov    %edx,%edi
  800770:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800772:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800776:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80077a:	7f e4                	jg     800760 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80077c:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80077f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800783:	ba 00 00 00 00       	mov    $0x0,%edx
  800788:	48 f7 f1             	div    %rcx
  80078b:	48 89 d0             	mov    %rdx,%rax
  80078e:	48 ba 68 42 80 00 00 	movabs $0x804268,%rdx
  800795:	00 00 00 
  800798:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80079c:	0f be d0             	movsbl %al,%edx
  80079f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8007a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a7:	48 89 ce             	mov    %rcx,%rsi
  8007aa:	89 d7                	mov    %edx,%edi
  8007ac:	ff d0                	callq  *%rax
}
  8007ae:	48 83 c4 38          	add    $0x38,%rsp
  8007b2:	5b                   	pop    %rbx
  8007b3:	5d                   	pop    %rbp
  8007b4:	c3                   	retq   

00000000008007b5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007b5:	55                   	push   %rbp
  8007b6:	48 89 e5             	mov    %rsp,%rbp
  8007b9:	48 83 ec 1c          	sub    $0x1c,%rsp
  8007bd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007c1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8007c4:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007c8:	7e 52                	jle    80081c <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8007ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ce:	8b 00                	mov    (%rax),%eax
  8007d0:	83 f8 30             	cmp    $0x30,%eax
  8007d3:	73 24                	jae    8007f9 <getuint+0x44>
  8007d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e1:	8b 00                	mov    (%rax),%eax
  8007e3:	89 c0                	mov    %eax,%eax
  8007e5:	48 01 d0             	add    %rdx,%rax
  8007e8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ec:	8b 12                	mov    (%rdx),%edx
  8007ee:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007f5:	89 0a                	mov    %ecx,(%rdx)
  8007f7:	eb 17                	jmp    800810 <getuint+0x5b>
  8007f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007fd:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800801:	48 89 d0             	mov    %rdx,%rax
  800804:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800808:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80080c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800810:	48 8b 00             	mov    (%rax),%rax
  800813:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800817:	e9 a3 00 00 00       	jmpq   8008bf <getuint+0x10a>
	else if (lflag)
  80081c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800820:	74 4f                	je     800871 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800822:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800826:	8b 00                	mov    (%rax),%eax
  800828:	83 f8 30             	cmp    $0x30,%eax
  80082b:	73 24                	jae    800851 <getuint+0x9c>
  80082d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800831:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800835:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800839:	8b 00                	mov    (%rax),%eax
  80083b:	89 c0                	mov    %eax,%eax
  80083d:	48 01 d0             	add    %rdx,%rax
  800840:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800844:	8b 12                	mov    (%rdx),%edx
  800846:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800849:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80084d:	89 0a                	mov    %ecx,(%rdx)
  80084f:	eb 17                	jmp    800868 <getuint+0xb3>
  800851:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800855:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800859:	48 89 d0             	mov    %rdx,%rax
  80085c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800860:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800864:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800868:	48 8b 00             	mov    (%rax),%rax
  80086b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80086f:	eb 4e                	jmp    8008bf <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800871:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800875:	8b 00                	mov    (%rax),%eax
  800877:	83 f8 30             	cmp    $0x30,%eax
  80087a:	73 24                	jae    8008a0 <getuint+0xeb>
  80087c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800880:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800884:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800888:	8b 00                	mov    (%rax),%eax
  80088a:	89 c0                	mov    %eax,%eax
  80088c:	48 01 d0             	add    %rdx,%rax
  80088f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800893:	8b 12                	mov    (%rdx),%edx
  800895:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800898:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80089c:	89 0a                	mov    %ecx,(%rdx)
  80089e:	eb 17                	jmp    8008b7 <getuint+0x102>
  8008a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008a8:	48 89 d0             	mov    %rdx,%rax
  8008ab:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008af:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008b3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008b7:	8b 00                	mov    (%rax),%eax
  8008b9:	89 c0                	mov    %eax,%eax
  8008bb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008c3:	c9                   	leaveq 
  8008c4:	c3                   	retq   

00000000008008c5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008c5:	55                   	push   %rbp
  8008c6:	48 89 e5             	mov    %rsp,%rbp
  8008c9:	48 83 ec 1c          	sub    $0x1c,%rsp
  8008cd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008d1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8008d4:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008d8:	7e 52                	jle    80092c <getint+0x67>
		x=va_arg(*ap, long long);
  8008da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008de:	8b 00                	mov    (%rax),%eax
  8008e0:	83 f8 30             	cmp    $0x30,%eax
  8008e3:	73 24                	jae    800909 <getint+0x44>
  8008e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f1:	8b 00                	mov    (%rax),%eax
  8008f3:	89 c0                	mov    %eax,%eax
  8008f5:	48 01 d0             	add    %rdx,%rax
  8008f8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008fc:	8b 12                	mov    (%rdx),%edx
  8008fe:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800901:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800905:	89 0a                	mov    %ecx,(%rdx)
  800907:	eb 17                	jmp    800920 <getint+0x5b>
  800909:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80090d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800911:	48 89 d0             	mov    %rdx,%rax
  800914:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800918:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80091c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800920:	48 8b 00             	mov    (%rax),%rax
  800923:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800927:	e9 a3 00 00 00       	jmpq   8009cf <getint+0x10a>
	else if (lflag)
  80092c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800930:	74 4f                	je     800981 <getint+0xbc>
		x=va_arg(*ap, long);
  800932:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800936:	8b 00                	mov    (%rax),%eax
  800938:	83 f8 30             	cmp    $0x30,%eax
  80093b:	73 24                	jae    800961 <getint+0x9c>
  80093d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800941:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800945:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800949:	8b 00                	mov    (%rax),%eax
  80094b:	89 c0                	mov    %eax,%eax
  80094d:	48 01 d0             	add    %rdx,%rax
  800950:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800954:	8b 12                	mov    (%rdx),%edx
  800956:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800959:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80095d:	89 0a                	mov    %ecx,(%rdx)
  80095f:	eb 17                	jmp    800978 <getint+0xb3>
  800961:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800965:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800969:	48 89 d0             	mov    %rdx,%rax
  80096c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800970:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800974:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800978:	48 8b 00             	mov    (%rax),%rax
  80097b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80097f:	eb 4e                	jmp    8009cf <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800981:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800985:	8b 00                	mov    (%rax),%eax
  800987:	83 f8 30             	cmp    $0x30,%eax
  80098a:	73 24                	jae    8009b0 <getint+0xeb>
  80098c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800990:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800994:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800998:	8b 00                	mov    (%rax),%eax
  80099a:	89 c0                	mov    %eax,%eax
  80099c:	48 01 d0             	add    %rdx,%rax
  80099f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009a3:	8b 12                	mov    (%rdx),%edx
  8009a5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009a8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ac:	89 0a                	mov    %ecx,(%rdx)
  8009ae:	eb 17                	jmp    8009c7 <getint+0x102>
  8009b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009b8:	48 89 d0             	mov    %rdx,%rax
  8009bb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009bf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009c3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009c7:	8b 00                	mov    (%rax),%eax
  8009c9:	48 98                	cltq   
  8009cb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009d3:	c9                   	leaveq 
  8009d4:	c3                   	retq   

00000000008009d5 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009d5:	55                   	push   %rbp
  8009d6:	48 89 e5             	mov    %rsp,%rbp
  8009d9:	41 54                	push   %r12
  8009db:	53                   	push   %rbx
  8009dc:	48 83 ec 60          	sub    $0x60,%rsp
  8009e0:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8009e4:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8009e8:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009ec:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8009f0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009f4:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8009f8:	48 8b 0a             	mov    (%rdx),%rcx
  8009fb:	48 89 08             	mov    %rcx,(%rax)
  8009fe:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a02:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a06:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a0a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a0e:	eb 17                	jmp    800a27 <vprintfmt+0x52>
			if (ch == '\0')
  800a10:	85 db                	test   %ebx,%ebx
  800a12:	0f 84 cc 04 00 00    	je     800ee4 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800a18:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a1c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a20:	48 89 d6             	mov    %rdx,%rsi
  800a23:	89 df                	mov    %ebx,%edi
  800a25:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a27:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a2b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a2f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a33:	0f b6 00             	movzbl (%rax),%eax
  800a36:	0f b6 d8             	movzbl %al,%ebx
  800a39:	83 fb 25             	cmp    $0x25,%ebx
  800a3c:	75 d2                	jne    800a10 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a3e:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800a42:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800a49:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800a50:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800a57:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a5e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a62:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a66:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a6a:	0f b6 00             	movzbl (%rax),%eax
  800a6d:	0f b6 d8             	movzbl %al,%ebx
  800a70:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800a73:	83 f8 55             	cmp    $0x55,%eax
  800a76:	0f 87 34 04 00 00    	ja     800eb0 <vprintfmt+0x4db>
  800a7c:	89 c0                	mov    %eax,%eax
  800a7e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800a85:	00 
  800a86:	48 b8 90 42 80 00 00 	movabs $0x804290,%rax
  800a8d:	00 00 00 
  800a90:	48 01 d0             	add    %rdx,%rax
  800a93:	48 8b 00             	mov    (%rax),%rax
  800a96:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a98:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800a9c:	eb c0                	jmp    800a5e <vprintfmt+0x89>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a9e:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800aa2:	eb ba                	jmp    800a5e <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800aa4:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800aab:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800aae:	89 d0                	mov    %edx,%eax
  800ab0:	c1 e0 02             	shl    $0x2,%eax
  800ab3:	01 d0                	add    %edx,%eax
  800ab5:	01 c0                	add    %eax,%eax
  800ab7:	01 d8                	add    %ebx,%eax
  800ab9:	83 e8 30             	sub    $0x30,%eax
  800abc:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800abf:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ac3:	0f b6 00             	movzbl (%rax),%eax
  800ac6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ac9:	83 fb 2f             	cmp    $0x2f,%ebx
  800acc:	7e 0c                	jle    800ada <vprintfmt+0x105>
  800ace:	83 fb 39             	cmp    $0x39,%ebx
  800ad1:	7f 07                	jg     800ada <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ad3:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ad8:	eb d1                	jmp    800aab <vprintfmt+0xd6>
			goto process_precision;
  800ada:	eb 58                	jmp    800b34 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800adc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800adf:	83 f8 30             	cmp    $0x30,%eax
  800ae2:	73 17                	jae    800afb <vprintfmt+0x126>
  800ae4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ae8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aeb:	89 c0                	mov    %eax,%eax
  800aed:	48 01 d0             	add    %rdx,%rax
  800af0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800af3:	83 c2 08             	add    $0x8,%edx
  800af6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800af9:	eb 0f                	jmp    800b0a <vprintfmt+0x135>
  800afb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aff:	48 89 d0             	mov    %rdx,%rax
  800b02:	48 83 c2 08          	add    $0x8,%rdx
  800b06:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b0a:	8b 00                	mov    (%rax),%eax
  800b0c:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800b0f:	eb 23                	jmp    800b34 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800b11:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b15:	79 0c                	jns    800b23 <vprintfmt+0x14e>
				width = 0;
  800b17:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800b1e:	e9 3b ff ff ff       	jmpq   800a5e <vprintfmt+0x89>
  800b23:	e9 36 ff ff ff       	jmpq   800a5e <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800b28:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800b2f:	e9 2a ff ff ff       	jmpq   800a5e <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800b34:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b38:	79 12                	jns    800b4c <vprintfmt+0x177>
				width = precision, precision = -1;
  800b3a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b3d:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800b40:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800b47:	e9 12 ff ff ff       	jmpq   800a5e <vprintfmt+0x89>
  800b4c:	e9 0d ff ff ff       	jmpq   800a5e <vprintfmt+0x89>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b51:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800b55:	e9 04 ff ff ff       	jmpq   800a5e <vprintfmt+0x89>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800b5a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b5d:	83 f8 30             	cmp    $0x30,%eax
  800b60:	73 17                	jae    800b79 <vprintfmt+0x1a4>
  800b62:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b66:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b69:	89 c0                	mov    %eax,%eax
  800b6b:	48 01 d0             	add    %rdx,%rax
  800b6e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b71:	83 c2 08             	add    $0x8,%edx
  800b74:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b77:	eb 0f                	jmp    800b88 <vprintfmt+0x1b3>
  800b79:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b7d:	48 89 d0             	mov    %rdx,%rax
  800b80:	48 83 c2 08          	add    $0x8,%rdx
  800b84:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b88:	8b 10                	mov    (%rax),%edx
  800b8a:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b8e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b92:	48 89 ce             	mov    %rcx,%rsi
  800b95:	89 d7                	mov    %edx,%edi
  800b97:	ff d0                	callq  *%rax
			break;
  800b99:	e9 40 03 00 00       	jmpq   800ede <vprintfmt+0x509>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800b9e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ba1:	83 f8 30             	cmp    $0x30,%eax
  800ba4:	73 17                	jae    800bbd <vprintfmt+0x1e8>
  800ba6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800baa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bad:	89 c0                	mov    %eax,%eax
  800baf:	48 01 d0             	add    %rdx,%rax
  800bb2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bb5:	83 c2 08             	add    $0x8,%edx
  800bb8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bbb:	eb 0f                	jmp    800bcc <vprintfmt+0x1f7>
  800bbd:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bc1:	48 89 d0             	mov    %rdx,%rax
  800bc4:	48 83 c2 08          	add    $0x8,%rdx
  800bc8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bcc:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800bce:	85 db                	test   %ebx,%ebx
  800bd0:	79 02                	jns    800bd4 <vprintfmt+0x1ff>
				err = -err;
  800bd2:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800bd4:	83 fb 10             	cmp    $0x10,%ebx
  800bd7:	7f 16                	jg     800bef <vprintfmt+0x21a>
  800bd9:	48 b8 e0 41 80 00 00 	movabs $0x8041e0,%rax
  800be0:	00 00 00 
  800be3:	48 63 d3             	movslq %ebx,%rdx
  800be6:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800bea:	4d 85 e4             	test   %r12,%r12
  800bed:	75 2e                	jne    800c1d <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800bef:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800bf3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bf7:	89 d9                	mov    %ebx,%ecx
  800bf9:	48 ba 79 42 80 00 00 	movabs $0x804279,%rdx
  800c00:	00 00 00 
  800c03:	48 89 c7             	mov    %rax,%rdi
  800c06:	b8 00 00 00 00       	mov    $0x0,%eax
  800c0b:	49 b8 ed 0e 80 00 00 	movabs $0x800eed,%r8
  800c12:	00 00 00 
  800c15:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c18:	e9 c1 02 00 00       	jmpq   800ede <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c1d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c21:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c25:	4c 89 e1             	mov    %r12,%rcx
  800c28:	48 ba 82 42 80 00 00 	movabs $0x804282,%rdx
  800c2f:	00 00 00 
  800c32:	48 89 c7             	mov    %rax,%rdi
  800c35:	b8 00 00 00 00       	mov    $0x0,%eax
  800c3a:	49 b8 ed 0e 80 00 00 	movabs $0x800eed,%r8
  800c41:	00 00 00 
  800c44:	41 ff d0             	callq  *%r8
			break;
  800c47:	e9 92 02 00 00       	jmpq   800ede <vprintfmt+0x509>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800c4c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c4f:	83 f8 30             	cmp    $0x30,%eax
  800c52:	73 17                	jae    800c6b <vprintfmt+0x296>
  800c54:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c58:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c5b:	89 c0                	mov    %eax,%eax
  800c5d:	48 01 d0             	add    %rdx,%rax
  800c60:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c63:	83 c2 08             	add    $0x8,%edx
  800c66:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c69:	eb 0f                	jmp    800c7a <vprintfmt+0x2a5>
  800c6b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c6f:	48 89 d0             	mov    %rdx,%rax
  800c72:	48 83 c2 08          	add    $0x8,%rdx
  800c76:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c7a:	4c 8b 20             	mov    (%rax),%r12
  800c7d:	4d 85 e4             	test   %r12,%r12
  800c80:	75 0a                	jne    800c8c <vprintfmt+0x2b7>
				p = "(null)";
  800c82:	49 bc 85 42 80 00 00 	movabs $0x804285,%r12
  800c89:	00 00 00 
			if (width > 0 && padc != '-')
  800c8c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c90:	7e 3f                	jle    800cd1 <vprintfmt+0x2fc>
  800c92:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800c96:	74 39                	je     800cd1 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c98:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c9b:	48 98                	cltq   
  800c9d:	48 89 c6             	mov    %rax,%rsi
  800ca0:	4c 89 e7             	mov    %r12,%rdi
  800ca3:	48 b8 99 11 80 00 00 	movabs $0x801199,%rax
  800caa:	00 00 00 
  800cad:	ff d0                	callq  *%rax
  800caf:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800cb2:	eb 17                	jmp    800ccb <vprintfmt+0x2f6>
					putch(padc, putdat);
  800cb4:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800cb8:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800cbc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cc0:	48 89 ce             	mov    %rcx,%rsi
  800cc3:	89 d7                	mov    %edx,%edi
  800cc5:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800cc7:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ccb:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ccf:	7f e3                	jg     800cb4 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cd1:	eb 37                	jmp    800d0a <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800cd3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800cd7:	74 1e                	je     800cf7 <vprintfmt+0x322>
  800cd9:	83 fb 1f             	cmp    $0x1f,%ebx
  800cdc:	7e 05                	jle    800ce3 <vprintfmt+0x30e>
  800cde:	83 fb 7e             	cmp    $0x7e,%ebx
  800ce1:	7e 14                	jle    800cf7 <vprintfmt+0x322>
					putch('?', putdat);
  800ce3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ce7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ceb:	48 89 d6             	mov    %rdx,%rsi
  800cee:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800cf3:	ff d0                	callq  *%rax
  800cf5:	eb 0f                	jmp    800d06 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800cf7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cfb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cff:	48 89 d6             	mov    %rdx,%rsi
  800d02:	89 df                	mov    %ebx,%edi
  800d04:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d06:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d0a:	4c 89 e0             	mov    %r12,%rax
  800d0d:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800d11:	0f b6 00             	movzbl (%rax),%eax
  800d14:	0f be d8             	movsbl %al,%ebx
  800d17:	85 db                	test   %ebx,%ebx
  800d19:	74 10                	je     800d2b <vprintfmt+0x356>
  800d1b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d1f:	78 b2                	js     800cd3 <vprintfmt+0x2fe>
  800d21:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800d25:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d29:	79 a8                	jns    800cd3 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d2b:	eb 16                	jmp    800d43 <vprintfmt+0x36e>
				putch(' ', putdat);
  800d2d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d31:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d35:	48 89 d6             	mov    %rdx,%rsi
  800d38:	bf 20 00 00 00       	mov    $0x20,%edi
  800d3d:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d3f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d43:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d47:	7f e4                	jg     800d2d <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800d49:	e9 90 01 00 00       	jmpq   800ede <vprintfmt+0x509>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800d4e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d52:	be 03 00 00 00       	mov    $0x3,%esi
  800d57:	48 89 c7             	mov    %rax,%rdi
  800d5a:	48 b8 c5 08 80 00 00 	movabs $0x8008c5,%rax
  800d61:	00 00 00 
  800d64:	ff d0                	callq  *%rax
  800d66:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800d6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d6e:	48 85 c0             	test   %rax,%rax
  800d71:	79 1d                	jns    800d90 <vprintfmt+0x3bb>
				putch('-', putdat);
  800d73:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d77:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d7b:	48 89 d6             	mov    %rdx,%rsi
  800d7e:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800d83:	ff d0                	callq  *%rax
				num = -(long long) num;
  800d85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d89:	48 f7 d8             	neg    %rax
  800d8c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800d90:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d97:	e9 d5 00 00 00       	jmpq   800e71 <vprintfmt+0x49c>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800d9c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800da0:	be 03 00 00 00       	mov    $0x3,%esi
  800da5:	48 89 c7             	mov    %rax,%rdi
  800da8:	48 b8 b5 07 80 00 00 	movabs $0x8007b5,%rax
  800daf:	00 00 00 
  800db2:	ff d0                	callq  *%rax
  800db4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800db8:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800dbf:	e9 ad 00 00 00       	jmpq   800e71 <vprintfmt+0x49c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800dc4:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800dc7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800dcb:	89 d6                	mov    %edx,%esi
  800dcd:	48 89 c7             	mov    %rax,%rdi
  800dd0:	48 b8 c5 08 80 00 00 	movabs $0x8008c5,%rax
  800dd7:	00 00 00 
  800dda:	ff d0                	callq  *%rax
  800ddc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800de0:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800de7:	e9 85 00 00 00       	jmpq   800e71 <vprintfmt+0x49c>


		// pointer
		case 'p':
			putch('0', putdat);
  800dec:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800df0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800df4:	48 89 d6             	mov    %rdx,%rsi
  800df7:	bf 30 00 00 00       	mov    $0x30,%edi
  800dfc:	ff d0                	callq  *%rax
			putch('x', putdat);
  800dfe:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e02:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e06:	48 89 d6             	mov    %rdx,%rsi
  800e09:	bf 78 00 00 00       	mov    $0x78,%edi
  800e0e:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800e10:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e13:	83 f8 30             	cmp    $0x30,%eax
  800e16:	73 17                	jae    800e2f <vprintfmt+0x45a>
  800e18:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e1c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e1f:	89 c0                	mov    %eax,%eax
  800e21:	48 01 d0             	add    %rdx,%rax
  800e24:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e27:	83 c2 08             	add    $0x8,%edx
  800e2a:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e2d:	eb 0f                	jmp    800e3e <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800e2f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e33:	48 89 d0             	mov    %rdx,%rax
  800e36:	48 83 c2 08          	add    $0x8,%rdx
  800e3a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e3e:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e41:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800e45:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800e4c:	eb 23                	jmp    800e71 <vprintfmt+0x49c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800e4e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e52:	be 03 00 00 00       	mov    $0x3,%esi
  800e57:	48 89 c7             	mov    %rax,%rdi
  800e5a:	48 b8 b5 07 80 00 00 	movabs $0x8007b5,%rax
  800e61:	00 00 00 
  800e64:	ff d0                	callq  *%rax
  800e66:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800e6a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e71:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800e76:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800e79:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800e7c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e80:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e84:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e88:	45 89 c1             	mov    %r8d,%r9d
  800e8b:	41 89 f8             	mov    %edi,%r8d
  800e8e:	48 89 c7             	mov    %rax,%rdi
  800e91:	48 b8 fa 06 80 00 00 	movabs $0x8006fa,%rax
  800e98:	00 00 00 
  800e9b:	ff d0                	callq  *%rax
			break;
  800e9d:	eb 3f                	jmp    800ede <vprintfmt+0x509>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e9f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ea3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ea7:	48 89 d6             	mov    %rdx,%rsi
  800eaa:	89 df                	mov    %ebx,%edi
  800eac:	ff d0                	callq  *%rax
			break;
  800eae:	eb 2e                	jmp    800ede <vprintfmt+0x509>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800eb0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800eb4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eb8:	48 89 d6             	mov    %rdx,%rsi
  800ebb:	bf 25 00 00 00       	mov    $0x25,%edi
  800ec0:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ec2:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ec7:	eb 05                	jmp    800ece <vprintfmt+0x4f9>
  800ec9:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ece:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ed2:	48 83 e8 01          	sub    $0x1,%rax
  800ed6:	0f b6 00             	movzbl (%rax),%eax
  800ed9:	3c 25                	cmp    $0x25,%al
  800edb:	75 ec                	jne    800ec9 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800edd:	90                   	nop
		}
	}
  800ede:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800edf:	e9 43 fb ff ff       	jmpq   800a27 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  800ee4:	48 83 c4 60          	add    $0x60,%rsp
  800ee8:	5b                   	pop    %rbx
  800ee9:	41 5c                	pop    %r12
  800eeb:	5d                   	pop    %rbp
  800eec:	c3                   	retq   

0000000000800eed <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800eed:	55                   	push   %rbp
  800eee:	48 89 e5             	mov    %rsp,%rbp
  800ef1:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800ef8:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800eff:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800f06:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f0d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f14:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f1b:	84 c0                	test   %al,%al
  800f1d:	74 20                	je     800f3f <printfmt+0x52>
  800f1f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f23:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f27:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f2b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f2f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f33:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f37:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f3b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f3f:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800f46:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800f4d:	00 00 00 
  800f50:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800f57:	00 00 00 
  800f5a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f5e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800f65:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f6c:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800f73:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800f7a:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800f81:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800f88:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800f8f:	48 89 c7             	mov    %rax,%rdi
  800f92:	48 b8 d5 09 80 00 00 	movabs $0x8009d5,%rax
  800f99:	00 00 00 
  800f9c:	ff d0                	callq  *%rax
	va_end(ap);
}
  800f9e:	c9                   	leaveq 
  800f9f:	c3                   	retq   

0000000000800fa0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fa0:	55                   	push   %rbp
  800fa1:	48 89 e5             	mov    %rsp,%rbp
  800fa4:	48 83 ec 10          	sub    $0x10,%rsp
  800fa8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800fab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800faf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fb3:	8b 40 10             	mov    0x10(%rax),%eax
  800fb6:	8d 50 01             	lea    0x1(%rax),%edx
  800fb9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fbd:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800fc0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fc4:	48 8b 10             	mov    (%rax),%rdx
  800fc7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fcb:	48 8b 40 08          	mov    0x8(%rax),%rax
  800fcf:	48 39 c2             	cmp    %rax,%rdx
  800fd2:	73 17                	jae    800feb <sprintputch+0x4b>
		*b->buf++ = ch;
  800fd4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fd8:	48 8b 00             	mov    (%rax),%rax
  800fdb:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800fdf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800fe3:	48 89 0a             	mov    %rcx,(%rdx)
  800fe6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800fe9:	88 10                	mov    %dl,(%rax)
}
  800feb:	c9                   	leaveq 
  800fec:	c3                   	retq   

0000000000800fed <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fed:	55                   	push   %rbp
  800fee:	48 89 e5             	mov    %rsp,%rbp
  800ff1:	48 83 ec 50          	sub    $0x50,%rsp
  800ff5:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800ff9:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800ffc:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801000:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801004:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801008:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80100c:	48 8b 0a             	mov    (%rdx),%rcx
  80100f:	48 89 08             	mov    %rcx,(%rax)
  801012:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801016:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80101a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80101e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801022:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801026:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80102a:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80102d:	48 98                	cltq   
  80102f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801033:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801037:	48 01 d0             	add    %rdx,%rax
  80103a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80103e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801045:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80104a:	74 06                	je     801052 <vsnprintf+0x65>
  80104c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801050:	7f 07                	jg     801059 <vsnprintf+0x6c>
		return -E_INVAL;
  801052:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801057:	eb 2f                	jmp    801088 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801059:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80105d:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801061:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801065:	48 89 c6             	mov    %rax,%rsi
  801068:	48 bf a0 0f 80 00 00 	movabs $0x800fa0,%rdi
  80106f:	00 00 00 
  801072:	48 b8 d5 09 80 00 00 	movabs $0x8009d5,%rax
  801079:	00 00 00 
  80107c:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80107e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801082:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801085:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801088:	c9                   	leaveq 
  801089:	c3                   	retq   

000000000080108a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80108a:	55                   	push   %rbp
  80108b:	48 89 e5             	mov    %rsp,%rbp
  80108e:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801095:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80109c:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8010a2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8010a9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8010b0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8010b7:	84 c0                	test   %al,%al
  8010b9:	74 20                	je     8010db <snprintf+0x51>
  8010bb:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8010bf:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8010c3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8010c7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8010cb:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8010cf:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8010d3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8010d7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8010db:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8010e2:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8010e9:	00 00 00 
  8010ec:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8010f3:	00 00 00 
  8010f6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8010fa:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801101:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801108:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80110f:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801116:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80111d:	48 8b 0a             	mov    (%rdx),%rcx
  801120:	48 89 08             	mov    %rcx,(%rax)
  801123:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801127:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80112b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80112f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801133:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80113a:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801141:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801147:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80114e:	48 89 c7             	mov    %rax,%rdi
  801151:	48 b8 ed 0f 80 00 00 	movabs $0x800fed,%rax
  801158:	00 00 00 
  80115b:	ff d0                	callq  *%rax
  80115d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801163:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801169:	c9                   	leaveq 
  80116a:	c3                   	retq   

000000000080116b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80116b:	55                   	push   %rbp
  80116c:	48 89 e5             	mov    %rsp,%rbp
  80116f:	48 83 ec 18          	sub    $0x18,%rsp
  801173:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801177:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80117e:	eb 09                	jmp    801189 <strlen+0x1e>
		n++;
  801180:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801184:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801189:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80118d:	0f b6 00             	movzbl (%rax),%eax
  801190:	84 c0                	test   %al,%al
  801192:	75 ec                	jne    801180 <strlen+0x15>
		n++;
	return n;
  801194:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801197:	c9                   	leaveq 
  801198:	c3                   	retq   

0000000000801199 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801199:	55                   	push   %rbp
  80119a:	48 89 e5             	mov    %rsp,%rbp
  80119d:	48 83 ec 20          	sub    $0x20,%rsp
  8011a1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011a5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011b0:	eb 0e                	jmp    8011c0 <strnlen+0x27>
		n++;
  8011b2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011b6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011bb:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8011c0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8011c5:	74 0b                	je     8011d2 <strnlen+0x39>
  8011c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011cb:	0f b6 00             	movzbl (%rax),%eax
  8011ce:	84 c0                	test   %al,%al
  8011d0:	75 e0                	jne    8011b2 <strnlen+0x19>
		n++;
	return n;
  8011d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011d5:	c9                   	leaveq 
  8011d6:	c3                   	retq   

00000000008011d7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8011d7:	55                   	push   %rbp
  8011d8:	48 89 e5             	mov    %rsp,%rbp
  8011db:	48 83 ec 20          	sub    $0x20,%rsp
  8011df:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011e3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8011e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011eb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8011ef:	90                   	nop
  8011f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011f4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011f8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011fc:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801200:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801204:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801208:	0f b6 12             	movzbl (%rdx),%edx
  80120b:	88 10                	mov    %dl,(%rax)
  80120d:	0f b6 00             	movzbl (%rax),%eax
  801210:	84 c0                	test   %al,%al
  801212:	75 dc                	jne    8011f0 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801214:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801218:	c9                   	leaveq 
  801219:	c3                   	retq   

000000000080121a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80121a:	55                   	push   %rbp
  80121b:	48 89 e5             	mov    %rsp,%rbp
  80121e:	48 83 ec 20          	sub    $0x20,%rsp
  801222:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801226:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80122a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80122e:	48 89 c7             	mov    %rax,%rdi
  801231:	48 b8 6b 11 80 00 00 	movabs $0x80116b,%rax
  801238:	00 00 00 
  80123b:	ff d0                	callq  *%rax
  80123d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801240:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801243:	48 63 d0             	movslq %eax,%rdx
  801246:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80124a:	48 01 c2             	add    %rax,%rdx
  80124d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801251:	48 89 c6             	mov    %rax,%rsi
  801254:	48 89 d7             	mov    %rdx,%rdi
  801257:	48 b8 d7 11 80 00 00 	movabs $0x8011d7,%rax
  80125e:	00 00 00 
  801261:	ff d0                	callq  *%rax
	return dst;
  801263:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801267:	c9                   	leaveq 
  801268:	c3                   	retq   

0000000000801269 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801269:	55                   	push   %rbp
  80126a:	48 89 e5             	mov    %rsp,%rbp
  80126d:	48 83 ec 28          	sub    $0x28,%rsp
  801271:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801275:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801279:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80127d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801281:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801285:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80128c:	00 
  80128d:	eb 2a                	jmp    8012b9 <strncpy+0x50>
		*dst++ = *src;
  80128f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801293:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801297:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80129b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80129f:	0f b6 12             	movzbl (%rdx),%edx
  8012a2:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012a8:	0f b6 00             	movzbl (%rax),%eax
  8012ab:	84 c0                	test   %al,%al
  8012ad:	74 05                	je     8012b4 <strncpy+0x4b>
			src++;
  8012af:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012b4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012bd:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8012c1:	72 cc                	jb     80128f <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8012c7:	c9                   	leaveq 
  8012c8:	c3                   	retq   

00000000008012c9 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8012c9:	55                   	push   %rbp
  8012ca:	48 89 e5             	mov    %rsp,%rbp
  8012cd:	48 83 ec 28          	sub    $0x28,%rsp
  8012d1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012d5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012d9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8012dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012e1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8012e5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8012ea:	74 3d                	je     801329 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8012ec:	eb 1d                	jmp    80130b <strlcpy+0x42>
			*dst++ = *src++;
  8012ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012f2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012f6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012fa:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012fe:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801302:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801306:	0f b6 12             	movzbl (%rdx),%edx
  801309:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80130b:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801310:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801315:	74 0b                	je     801322 <strlcpy+0x59>
  801317:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80131b:	0f b6 00             	movzbl (%rax),%eax
  80131e:	84 c0                	test   %al,%al
  801320:	75 cc                	jne    8012ee <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801322:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801326:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801329:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80132d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801331:	48 29 c2             	sub    %rax,%rdx
  801334:	48 89 d0             	mov    %rdx,%rax
}
  801337:	c9                   	leaveq 
  801338:	c3                   	retq   

0000000000801339 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801339:	55                   	push   %rbp
  80133a:	48 89 e5             	mov    %rsp,%rbp
  80133d:	48 83 ec 10          	sub    $0x10,%rsp
  801341:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801345:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801349:	eb 0a                	jmp    801355 <strcmp+0x1c>
		p++, q++;
  80134b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801350:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801355:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801359:	0f b6 00             	movzbl (%rax),%eax
  80135c:	84 c0                	test   %al,%al
  80135e:	74 12                	je     801372 <strcmp+0x39>
  801360:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801364:	0f b6 10             	movzbl (%rax),%edx
  801367:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80136b:	0f b6 00             	movzbl (%rax),%eax
  80136e:	38 c2                	cmp    %al,%dl
  801370:	74 d9                	je     80134b <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801372:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801376:	0f b6 00             	movzbl (%rax),%eax
  801379:	0f b6 d0             	movzbl %al,%edx
  80137c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801380:	0f b6 00             	movzbl (%rax),%eax
  801383:	0f b6 c0             	movzbl %al,%eax
  801386:	29 c2                	sub    %eax,%edx
  801388:	89 d0                	mov    %edx,%eax
}
  80138a:	c9                   	leaveq 
  80138b:	c3                   	retq   

000000000080138c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80138c:	55                   	push   %rbp
  80138d:	48 89 e5             	mov    %rsp,%rbp
  801390:	48 83 ec 18          	sub    $0x18,%rsp
  801394:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801398:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80139c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8013a0:	eb 0f                	jmp    8013b1 <strncmp+0x25>
		n--, p++, q++;
  8013a2:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8013a7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013ac:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8013b1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013b6:	74 1d                	je     8013d5 <strncmp+0x49>
  8013b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013bc:	0f b6 00             	movzbl (%rax),%eax
  8013bf:	84 c0                	test   %al,%al
  8013c1:	74 12                	je     8013d5 <strncmp+0x49>
  8013c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c7:	0f b6 10             	movzbl (%rax),%edx
  8013ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013ce:	0f b6 00             	movzbl (%rax),%eax
  8013d1:	38 c2                	cmp    %al,%dl
  8013d3:	74 cd                	je     8013a2 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8013d5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013da:	75 07                	jne    8013e3 <strncmp+0x57>
		return 0;
  8013dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8013e1:	eb 18                	jmp    8013fb <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e7:	0f b6 00             	movzbl (%rax),%eax
  8013ea:	0f b6 d0             	movzbl %al,%edx
  8013ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013f1:	0f b6 00             	movzbl (%rax),%eax
  8013f4:	0f b6 c0             	movzbl %al,%eax
  8013f7:	29 c2                	sub    %eax,%edx
  8013f9:	89 d0                	mov    %edx,%eax
}
  8013fb:	c9                   	leaveq 
  8013fc:	c3                   	retq   

00000000008013fd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013fd:	55                   	push   %rbp
  8013fe:	48 89 e5             	mov    %rsp,%rbp
  801401:	48 83 ec 0c          	sub    $0xc,%rsp
  801405:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801409:	89 f0                	mov    %esi,%eax
  80140b:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80140e:	eb 17                	jmp    801427 <strchr+0x2a>
		if (*s == c)
  801410:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801414:	0f b6 00             	movzbl (%rax),%eax
  801417:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80141a:	75 06                	jne    801422 <strchr+0x25>
			return (char *) s;
  80141c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801420:	eb 15                	jmp    801437 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801422:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801427:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80142b:	0f b6 00             	movzbl (%rax),%eax
  80142e:	84 c0                	test   %al,%al
  801430:	75 de                	jne    801410 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801432:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801437:	c9                   	leaveq 
  801438:	c3                   	retq   

0000000000801439 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801439:	55                   	push   %rbp
  80143a:	48 89 e5             	mov    %rsp,%rbp
  80143d:	48 83 ec 0c          	sub    $0xc,%rsp
  801441:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801445:	89 f0                	mov    %esi,%eax
  801447:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80144a:	eb 13                	jmp    80145f <strfind+0x26>
		if (*s == c)
  80144c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801450:	0f b6 00             	movzbl (%rax),%eax
  801453:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801456:	75 02                	jne    80145a <strfind+0x21>
			break;
  801458:	eb 10                	jmp    80146a <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80145a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80145f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801463:	0f b6 00             	movzbl (%rax),%eax
  801466:	84 c0                	test   %al,%al
  801468:	75 e2                	jne    80144c <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80146a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80146e:	c9                   	leaveq 
  80146f:	c3                   	retq   

0000000000801470 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801470:	55                   	push   %rbp
  801471:	48 89 e5             	mov    %rsp,%rbp
  801474:	48 83 ec 18          	sub    $0x18,%rsp
  801478:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80147c:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80147f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801483:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801488:	75 06                	jne    801490 <memset+0x20>
		return v;
  80148a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80148e:	eb 69                	jmp    8014f9 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801490:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801494:	83 e0 03             	and    $0x3,%eax
  801497:	48 85 c0             	test   %rax,%rax
  80149a:	75 48                	jne    8014e4 <memset+0x74>
  80149c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014a0:	83 e0 03             	and    $0x3,%eax
  8014a3:	48 85 c0             	test   %rax,%rax
  8014a6:	75 3c                	jne    8014e4 <memset+0x74>
		c &= 0xFF;
  8014a8:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8014af:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014b2:	c1 e0 18             	shl    $0x18,%eax
  8014b5:	89 c2                	mov    %eax,%edx
  8014b7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014ba:	c1 e0 10             	shl    $0x10,%eax
  8014bd:	09 c2                	or     %eax,%edx
  8014bf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014c2:	c1 e0 08             	shl    $0x8,%eax
  8014c5:	09 d0                	or     %edx,%eax
  8014c7:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8014ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014ce:	48 c1 e8 02          	shr    $0x2,%rax
  8014d2:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8014d5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014d9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014dc:	48 89 d7             	mov    %rdx,%rdi
  8014df:	fc                   	cld    
  8014e0:	f3 ab                	rep stos %eax,%es:(%rdi)
  8014e2:	eb 11                	jmp    8014f5 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8014e4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014e8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014eb:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8014ef:	48 89 d7             	mov    %rdx,%rdi
  8014f2:	fc                   	cld    
  8014f3:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  8014f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014f9:	c9                   	leaveq 
  8014fa:	c3                   	retq   

00000000008014fb <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8014fb:	55                   	push   %rbp
  8014fc:	48 89 e5             	mov    %rsp,%rbp
  8014ff:	48 83 ec 28          	sub    $0x28,%rsp
  801503:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801507:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80150b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80150f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801513:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801517:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80151b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80151f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801523:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801527:	0f 83 88 00 00 00    	jae    8015b5 <memmove+0xba>
  80152d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801531:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801535:	48 01 d0             	add    %rdx,%rax
  801538:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80153c:	76 77                	jbe    8015b5 <memmove+0xba>
		s += n;
  80153e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801542:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801546:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154a:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80154e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801552:	83 e0 03             	and    $0x3,%eax
  801555:	48 85 c0             	test   %rax,%rax
  801558:	75 3b                	jne    801595 <memmove+0x9a>
  80155a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80155e:	83 e0 03             	and    $0x3,%eax
  801561:	48 85 c0             	test   %rax,%rax
  801564:	75 2f                	jne    801595 <memmove+0x9a>
  801566:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80156a:	83 e0 03             	and    $0x3,%eax
  80156d:	48 85 c0             	test   %rax,%rax
  801570:	75 23                	jne    801595 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801572:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801576:	48 83 e8 04          	sub    $0x4,%rax
  80157a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80157e:	48 83 ea 04          	sub    $0x4,%rdx
  801582:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801586:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80158a:	48 89 c7             	mov    %rax,%rdi
  80158d:	48 89 d6             	mov    %rdx,%rsi
  801590:	fd                   	std    
  801591:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801593:	eb 1d                	jmp    8015b2 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801595:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801599:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80159d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015a1:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8015a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a9:	48 89 d7             	mov    %rdx,%rdi
  8015ac:	48 89 c1             	mov    %rax,%rcx
  8015af:	fd                   	std    
  8015b0:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8015b2:	fc                   	cld    
  8015b3:	eb 57                	jmp    80160c <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8015b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015b9:	83 e0 03             	and    $0x3,%eax
  8015bc:	48 85 c0             	test   %rax,%rax
  8015bf:	75 36                	jne    8015f7 <memmove+0xfc>
  8015c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015c5:	83 e0 03             	and    $0x3,%eax
  8015c8:	48 85 c0             	test   %rax,%rax
  8015cb:	75 2a                	jne    8015f7 <memmove+0xfc>
  8015cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d1:	83 e0 03             	and    $0x3,%eax
  8015d4:	48 85 c0             	test   %rax,%rax
  8015d7:	75 1e                	jne    8015f7 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8015d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015dd:	48 c1 e8 02          	shr    $0x2,%rax
  8015e1:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8015e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015e8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015ec:	48 89 c7             	mov    %rax,%rdi
  8015ef:	48 89 d6             	mov    %rdx,%rsi
  8015f2:	fc                   	cld    
  8015f3:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015f5:	eb 15                	jmp    80160c <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8015f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015fb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015ff:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801603:	48 89 c7             	mov    %rax,%rdi
  801606:	48 89 d6             	mov    %rdx,%rsi
  801609:	fc                   	cld    
  80160a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80160c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801610:	c9                   	leaveq 
  801611:	c3                   	retq   

0000000000801612 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801612:	55                   	push   %rbp
  801613:	48 89 e5             	mov    %rsp,%rbp
  801616:	48 83 ec 18          	sub    $0x18,%rsp
  80161a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80161e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801622:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801626:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80162a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80162e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801632:	48 89 ce             	mov    %rcx,%rsi
  801635:	48 89 c7             	mov    %rax,%rdi
  801638:	48 b8 fb 14 80 00 00 	movabs $0x8014fb,%rax
  80163f:	00 00 00 
  801642:	ff d0                	callq  *%rax
}
  801644:	c9                   	leaveq 
  801645:	c3                   	retq   

0000000000801646 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801646:	55                   	push   %rbp
  801647:	48 89 e5             	mov    %rsp,%rbp
  80164a:	48 83 ec 28          	sub    $0x28,%rsp
  80164e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801652:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801656:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80165a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80165e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801662:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801666:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80166a:	eb 36                	jmp    8016a2 <memcmp+0x5c>
		if (*s1 != *s2)
  80166c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801670:	0f b6 10             	movzbl (%rax),%edx
  801673:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801677:	0f b6 00             	movzbl (%rax),%eax
  80167a:	38 c2                	cmp    %al,%dl
  80167c:	74 1a                	je     801698 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80167e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801682:	0f b6 00             	movzbl (%rax),%eax
  801685:	0f b6 d0             	movzbl %al,%edx
  801688:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80168c:	0f b6 00             	movzbl (%rax),%eax
  80168f:	0f b6 c0             	movzbl %al,%eax
  801692:	29 c2                	sub    %eax,%edx
  801694:	89 d0                	mov    %edx,%eax
  801696:	eb 20                	jmp    8016b8 <memcmp+0x72>
		s1++, s2++;
  801698:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80169d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8016a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a6:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016aa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8016ae:	48 85 c0             	test   %rax,%rax
  8016b1:	75 b9                	jne    80166c <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016b8:	c9                   	leaveq 
  8016b9:	c3                   	retq   

00000000008016ba <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8016ba:	55                   	push   %rbp
  8016bb:	48 89 e5             	mov    %rsp,%rbp
  8016be:	48 83 ec 28          	sub    $0x28,%rsp
  8016c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016c6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8016c9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8016cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016d5:	48 01 d0             	add    %rdx,%rax
  8016d8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8016dc:	eb 15                	jmp    8016f3 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016e2:	0f b6 10             	movzbl (%rax),%edx
  8016e5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8016e8:	38 c2                	cmp    %al,%dl
  8016ea:	75 02                	jne    8016ee <memfind+0x34>
			break;
  8016ec:	eb 0f                	jmp    8016fd <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8016ee:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8016f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016f7:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8016fb:	72 e1                	jb     8016de <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8016fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801701:	c9                   	leaveq 
  801702:	c3                   	retq   

0000000000801703 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801703:	55                   	push   %rbp
  801704:	48 89 e5             	mov    %rsp,%rbp
  801707:	48 83 ec 34          	sub    $0x34,%rsp
  80170b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80170f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801713:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801716:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80171d:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801724:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801725:	eb 05                	jmp    80172c <strtol+0x29>
		s++;
  801727:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80172c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801730:	0f b6 00             	movzbl (%rax),%eax
  801733:	3c 20                	cmp    $0x20,%al
  801735:	74 f0                	je     801727 <strtol+0x24>
  801737:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80173b:	0f b6 00             	movzbl (%rax),%eax
  80173e:	3c 09                	cmp    $0x9,%al
  801740:	74 e5                	je     801727 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801742:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801746:	0f b6 00             	movzbl (%rax),%eax
  801749:	3c 2b                	cmp    $0x2b,%al
  80174b:	75 07                	jne    801754 <strtol+0x51>
		s++;
  80174d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801752:	eb 17                	jmp    80176b <strtol+0x68>
	else if (*s == '-')
  801754:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801758:	0f b6 00             	movzbl (%rax),%eax
  80175b:	3c 2d                	cmp    $0x2d,%al
  80175d:	75 0c                	jne    80176b <strtol+0x68>
		s++, neg = 1;
  80175f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801764:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80176b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80176f:	74 06                	je     801777 <strtol+0x74>
  801771:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801775:	75 28                	jne    80179f <strtol+0x9c>
  801777:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177b:	0f b6 00             	movzbl (%rax),%eax
  80177e:	3c 30                	cmp    $0x30,%al
  801780:	75 1d                	jne    80179f <strtol+0x9c>
  801782:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801786:	48 83 c0 01          	add    $0x1,%rax
  80178a:	0f b6 00             	movzbl (%rax),%eax
  80178d:	3c 78                	cmp    $0x78,%al
  80178f:	75 0e                	jne    80179f <strtol+0x9c>
		s += 2, base = 16;
  801791:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801796:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80179d:	eb 2c                	jmp    8017cb <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80179f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017a3:	75 19                	jne    8017be <strtol+0xbb>
  8017a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a9:	0f b6 00             	movzbl (%rax),%eax
  8017ac:	3c 30                	cmp    $0x30,%al
  8017ae:	75 0e                	jne    8017be <strtol+0xbb>
		s++, base = 8;
  8017b0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017b5:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8017bc:	eb 0d                	jmp    8017cb <strtol+0xc8>
	else if (base == 0)
  8017be:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017c2:	75 07                	jne    8017cb <strtol+0xc8>
		base = 10;
  8017c4:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017cf:	0f b6 00             	movzbl (%rax),%eax
  8017d2:	3c 2f                	cmp    $0x2f,%al
  8017d4:	7e 1d                	jle    8017f3 <strtol+0xf0>
  8017d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017da:	0f b6 00             	movzbl (%rax),%eax
  8017dd:	3c 39                	cmp    $0x39,%al
  8017df:	7f 12                	jg     8017f3 <strtol+0xf0>
			dig = *s - '0';
  8017e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e5:	0f b6 00             	movzbl (%rax),%eax
  8017e8:	0f be c0             	movsbl %al,%eax
  8017eb:	83 e8 30             	sub    $0x30,%eax
  8017ee:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8017f1:	eb 4e                	jmp    801841 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8017f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f7:	0f b6 00             	movzbl (%rax),%eax
  8017fa:	3c 60                	cmp    $0x60,%al
  8017fc:	7e 1d                	jle    80181b <strtol+0x118>
  8017fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801802:	0f b6 00             	movzbl (%rax),%eax
  801805:	3c 7a                	cmp    $0x7a,%al
  801807:	7f 12                	jg     80181b <strtol+0x118>
			dig = *s - 'a' + 10;
  801809:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80180d:	0f b6 00             	movzbl (%rax),%eax
  801810:	0f be c0             	movsbl %al,%eax
  801813:	83 e8 57             	sub    $0x57,%eax
  801816:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801819:	eb 26                	jmp    801841 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80181b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80181f:	0f b6 00             	movzbl (%rax),%eax
  801822:	3c 40                	cmp    $0x40,%al
  801824:	7e 48                	jle    80186e <strtol+0x16b>
  801826:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80182a:	0f b6 00             	movzbl (%rax),%eax
  80182d:	3c 5a                	cmp    $0x5a,%al
  80182f:	7f 3d                	jg     80186e <strtol+0x16b>
			dig = *s - 'A' + 10;
  801831:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801835:	0f b6 00             	movzbl (%rax),%eax
  801838:	0f be c0             	movsbl %al,%eax
  80183b:	83 e8 37             	sub    $0x37,%eax
  80183e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801841:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801844:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801847:	7c 02                	jl     80184b <strtol+0x148>
			break;
  801849:	eb 23                	jmp    80186e <strtol+0x16b>
		s++, val = (val * base) + dig;
  80184b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801850:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801853:	48 98                	cltq   
  801855:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80185a:	48 89 c2             	mov    %rax,%rdx
  80185d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801860:	48 98                	cltq   
  801862:	48 01 d0             	add    %rdx,%rax
  801865:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801869:	e9 5d ff ff ff       	jmpq   8017cb <strtol+0xc8>

	if (endptr)
  80186e:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801873:	74 0b                	je     801880 <strtol+0x17d>
		*endptr = (char *) s;
  801875:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801879:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80187d:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801880:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801884:	74 09                	je     80188f <strtol+0x18c>
  801886:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80188a:	48 f7 d8             	neg    %rax
  80188d:	eb 04                	jmp    801893 <strtol+0x190>
  80188f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801893:	c9                   	leaveq 
  801894:	c3                   	retq   

0000000000801895 <strstr>:

char * strstr(const char *in, const char *str)
{
  801895:	55                   	push   %rbp
  801896:	48 89 e5             	mov    %rsp,%rbp
  801899:	48 83 ec 30          	sub    $0x30,%rsp
  80189d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018a1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  8018a5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018a9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018ad:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018b1:	0f b6 00             	movzbl (%rax),%eax
  8018b4:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  8018b7:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8018bb:	75 06                	jne    8018c3 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  8018bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018c1:	eb 6b                	jmp    80192e <strstr+0x99>

    len = strlen(str);
  8018c3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018c7:	48 89 c7             	mov    %rax,%rdi
  8018ca:	48 b8 6b 11 80 00 00 	movabs $0x80116b,%rax
  8018d1:	00 00 00 
  8018d4:	ff d0                	callq  *%rax
  8018d6:	48 98                	cltq   
  8018d8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  8018dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018e4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8018e8:	0f b6 00             	movzbl (%rax),%eax
  8018eb:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  8018ee:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8018f2:	75 07                	jne    8018fb <strstr+0x66>
                return (char *) 0;
  8018f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f9:	eb 33                	jmp    80192e <strstr+0x99>
        } while (sc != c);
  8018fb:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8018ff:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801902:	75 d8                	jne    8018dc <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  801904:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801908:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80190c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801910:	48 89 ce             	mov    %rcx,%rsi
  801913:	48 89 c7             	mov    %rax,%rdi
  801916:	48 b8 8c 13 80 00 00 	movabs $0x80138c,%rax
  80191d:	00 00 00 
  801920:	ff d0                	callq  *%rax
  801922:	85 c0                	test   %eax,%eax
  801924:	75 b6                	jne    8018dc <strstr+0x47>

    return (char *) (in - 1);
  801926:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80192a:	48 83 e8 01          	sub    $0x1,%rax
}
  80192e:	c9                   	leaveq 
  80192f:	c3                   	retq   

0000000000801930 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801930:	55                   	push   %rbp
  801931:	48 89 e5             	mov    %rsp,%rbp
  801934:	53                   	push   %rbx
  801935:	48 83 ec 48          	sub    $0x48,%rsp
  801939:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80193c:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80193f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801943:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801947:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80194b:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80194f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801952:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801956:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80195a:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80195e:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801962:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801966:	4c 89 c3             	mov    %r8,%rbx
  801969:	cd 30                	int    $0x30
  80196b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80196f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801973:	74 3e                	je     8019b3 <syscall+0x83>
  801975:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80197a:	7e 37                	jle    8019b3 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80197c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801980:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801983:	49 89 d0             	mov    %rdx,%r8
  801986:	89 c1                	mov    %eax,%ecx
  801988:	48 ba 40 45 80 00 00 	movabs $0x804540,%rdx
  80198f:	00 00 00 
  801992:	be 23 00 00 00       	mov    $0x23,%esi
  801997:	48 bf 5d 45 80 00 00 	movabs $0x80455d,%rdi
  80199e:	00 00 00 
  8019a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8019a6:	49 b9 e9 03 80 00 00 	movabs $0x8003e9,%r9
  8019ad:	00 00 00 
  8019b0:	41 ff d1             	callq  *%r9

	return ret;
  8019b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8019b7:	48 83 c4 48          	add    $0x48,%rsp
  8019bb:	5b                   	pop    %rbx
  8019bc:	5d                   	pop    %rbp
  8019bd:	c3                   	retq   

00000000008019be <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8019be:	55                   	push   %rbp
  8019bf:	48 89 e5             	mov    %rsp,%rbp
  8019c2:	48 83 ec 20          	sub    $0x20,%rsp
  8019c6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019ca:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8019ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019d2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019d6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019dd:	00 
  8019de:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019e4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019ea:	48 89 d1             	mov    %rdx,%rcx
  8019ed:	48 89 c2             	mov    %rax,%rdx
  8019f0:	be 00 00 00 00       	mov    $0x0,%esi
  8019f5:	bf 00 00 00 00       	mov    $0x0,%edi
  8019fa:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  801a01:	00 00 00 
  801a04:	ff d0                	callq  *%rax
}
  801a06:	c9                   	leaveq 
  801a07:	c3                   	retq   

0000000000801a08 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a08:	55                   	push   %rbp
  801a09:	48 89 e5             	mov    %rsp,%rbp
  801a0c:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801a10:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a17:	00 
  801a18:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a1e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a24:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a29:	ba 00 00 00 00       	mov    $0x0,%edx
  801a2e:	be 00 00 00 00       	mov    $0x0,%esi
  801a33:	bf 01 00 00 00       	mov    $0x1,%edi
  801a38:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  801a3f:	00 00 00 
  801a42:	ff d0                	callq  *%rax
}
  801a44:	c9                   	leaveq 
  801a45:	c3                   	retq   

0000000000801a46 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801a46:	55                   	push   %rbp
  801a47:	48 89 e5             	mov    %rsp,%rbp
  801a4a:	48 83 ec 10          	sub    $0x10,%rsp
  801a4e:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801a51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a54:	48 98                	cltq   
  801a56:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a5d:	00 
  801a5e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a64:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a6a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a6f:	48 89 c2             	mov    %rax,%rdx
  801a72:	be 01 00 00 00       	mov    $0x1,%esi
  801a77:	bf 03 00 00 00       	mov    $0x3,%edi
  801a7c:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  801a83:	00 00 00 
  801a86:	ff d0                	callq  *%rax
}
  801a88:	c9                   	leaveq 
  801a89:	c3                   	retq   

0000000000801a8a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801a8a:	55                   	push   %rbp
  801a8b:	48 89 e5             	mov    %rsp,%rbp
  801a8e:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801a92:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a99:	00 
  801a9a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aa0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aa6:	b9 00 00 00 00       	mov    $0x0,%ecx
  801aab:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab0:	be 00 00 00 00       	mov    $0x0,%esi
  801ab5:	bf 02 00 00 00       	mov    $0x2,%edi
  801aba:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  801ac1:	00 00 00 
  801ac4:	ff d0                	callq  *%rax
}
  801ac6:	c9                   	leaveq 
  801ac7:	c3                   	retq   

0000000000801ac8 <sys_yield>:

void
sys_yield(void)
{
  801ac8:	55                   	push   %rbp
  801ac9:	48 89 e5             	mov    %rsp,%rbp
  801acc:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801ad0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ad7:	00 
  801ad8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ade:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ae4:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ae9:	ba 00 00 00 00       	mov    $0x0,%edx
  801aee:	be 00 00 00 00       	mov    $0x0,%esi
  801af3:	bf 0b 00 00 00       	mov    $0xb,%edi
  801af8:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  801aff:	00 00 00 
  801b02:	ff d0                	callq  *%rax
}
  801b04:	c9                   	leaveq 
  801b05:	c3                   	retq   

0000000000801b06 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801b06:	55                   	push   %rbp
  801b07:	48 89 e5             	mov    %rsp,%rbp
  801b0a:	48 83 ec 20          	sub    $0x20,%rsp
  801b0e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b11:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b15:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801b18:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b1b:	48 63 c8             	movslq %eax,%rcx
  801b1e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b25:	48 98                	cltq   
  801b27:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b2e:	00 
  801b2f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b35:	49 89 c8             	mov    %rcx,%r8
  801b38:	48 89 d1             	mov    %rdx,%rcx
  801b3b:	48 89 c2             	mov    %rax,%rdx
  801b3e:	be 01 00 00 00       	mov    $0x1,%esi
  801b43:	bf 04 00 00 00       	mov    $0x4,%edi
  801b48:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  801b4f:	00 00 00 
  801b52:	ff d0                	callq  *%rax
}
  801b54:	c9                   	leaveq 
  801b55:	c3                   	retq   

0000000000801b56 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801b56:	55                   	push   %rbp
  801b57:	48 89 e5             	mov    %rsp,%rbp
  801b5a:	48 83 ec 30          	sub    $0x30,%rsp
  801b5e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b61:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b65:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b68:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b6c:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801b70:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b73:	48 63 c8             	movslq %eax,%rcx
  801b76:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801b7a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b7d:	48 63 f0             	movslq %eax,%rsi
  801b80:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b84:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b87:	48 98                	cltq   
  801b89:	48 89 0c 24          	mov    %rcx,(%rsp)
  801b8d:	49 89 f9             	mov    %rdi,%r9
  801b90:	49 89 f0             	mov    %rsi,%r8
  801b93:	48 89 d1             	mov    %rdx,%rcx
  801b96:	48 89 c2             	mov    %rax,%rdx
  801b99:	be 01 00 00 00       	mov    $0x1,%esi
  801b9e:	bf 05 00 00 00       	mov    $0x5,%edi
  801ba3:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  801baa:	00 00 00 
  801bad:	ff d0                	callq  *%rax
}
  801baf:	c9                   	leaveq 
  801bb0:	c3                   	retq   

0000000000801bb1 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801bb1:	55                   	push   %rbp
  801bb2:	48 89 e5             	mov    %rsp,%rbp
  801bb5:	48 83 ec 20          	sub    $0x20,%rsp
  801bb9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bbc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801bc0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bc4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bc7:	48 98                	cltq   
  801bc9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bd0:	00 
  801bd1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bd7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bdd:	48 89 d1             	mov    %rdx,%rcx
  801be0:	48 89 c2             	mov    %rax,%rdx
  801be3:	be 01 00 00 00       	mov    $0x1,%esi
  801be8:	bf 06 00 00 00       	mov    $0x6,%edi
  801bed:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  801bf4:	00 00 00 
  801bf7:	ff d0                	callq  *%rax
}
  801bf9:	c9                   	leaveq 
  801bfa:	c3                   	retq   

0000000000801bfb <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801bfb:	55                   	push   %rbp
  801bfc:	48 89 e5             	mov    %rsp,%rbp
  801bff:	48 83 ec 10          	sub    $0x10,%rsp
  801c03:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c06:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801c09:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c0c:	48 63 d0             	movslq %eax,%rdx
  801c0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c12:	48 98                	cltq   
  801c14:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c1b:	00 
  801c1c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c22:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c28:	48 89 d1             	mov    %rdx,%rcx
  801c2b:	48 89 c2             	mov    %rax,%rdx
  801c2e:	be 01 00 00 00       	mov    $0x1,%esi
  801c33:	bf 08 00 00 00       	mov    $0x8,%edi
  801c38:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  801c3f:	00 00 00 
  801c42:	ff d0                	callq  *%rax
}
  801c44:	c9                   	leaveq 
  801c45:	c3                   	retq   

0000000000801c46 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801c46:	55                   	push   %rbp
  801c47:	48 89 e5             	mov    %rsp,%rbp
  801c4a:	48 83 ec 20          	sub    $0x20,%rsp
  801c4e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c51:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801c55:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c5c:	48 98                	cltq   
  801c5e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c65:	00 
  801c66:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c6c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c72:	48 89 d1             	mov    %rdx,%rcx
  801c75:	48 89 c2             	mov    %rax,%rdx
  801c78:	be 01 00 00 00       	mov    $0x1,%esi
  801c7d:	bf 09 00 00 00       	mov    $0x9,%edi
  801c82:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  801c89:	00 00 00 
  801c8c:	ff d0                	callq  *%rax
}
  801c8e:	c9                   	leaveq 
  801c8f:	c3                   	retq   

0000000000801c90 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801c90:	55                   	push   %rbp
  801c91:	48 89 e5             	mov    %rsp,%rbp
  801c94:	48 83 ec 20          	sub    $0x20,%rsp
  801c98:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c9b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801c9f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ca3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ca6:	48 98                	cltq   
  801ca8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801caf:	00 
  801cb0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cb6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cbc:	48 89 d1             	mov    %rdx,%rcx
  801cbf:	48 89 c2             	mov    %rax,%rdx
  801cc2:	be 01 00 00 00       	mov    $0x1,%esi
  801cc7:	bf 0a 00 00 00       	mov    $0xa,%edi
  801ccc:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  801cd3:	00 00 00 
  801cd6:	ff d0                	callq  *%rax
}
  801cd8:	c9                   	leaveq 
  801cd9:	c3                   	retq   

0000000000801cda <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801cda:	55                   	push   %rbp
  801cdb:	48 89 e5             	mov    %rsp,%rbp
  801cde:	48 83 ec 20          	sub    $0x20,%rsp
  801ce2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ce5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ce9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801ced:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801cf0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801cf3:	48 63 f0             	movslq %eax,%rsi
  801cf6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801cfa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cfd:	48 98                	cltq   
  801cff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d03:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d0a:	00 
  801d0b:	49 89 f1             	mov    %rsi,%r9
  801d0e:	49 89 c8             	mov    %rcx,%r8
  801d11:	48 89 d1             	mov    %rdx,%rcx
  801d14:	48 89 c2             	mov    %rax,%rdx
  801d17:	be 00 00 00 00       	mov    $0x0,%esi
  801d1c:	bf 0c 00 00 00       	mov    $0xc,%edi
  801d21:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  801d28:	00 00 00 
  801d2b:	ff d0                	callq  *%rax
}
  801d2d:	c9                   	leaveq 
  801d2e:	c3                   	retq   

0000000000801d2f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801d2f:	55                   	push   %rbp
  801d30:	48 89 e5             	mov    %rsp,%rbp
  801d33:	48 83 ec 10          	sub    $0x10,%rsp
  801d37:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801d3b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d3f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d46:	00 
  801d47:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d4d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d53:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d58:	48 89 c2             	mov    %rax,%rdx
  801d5b:	be 01 00 00 00       	mov    $0x1,%esi
  801d60:	bf 0d 00 00 00       	mov    $0xd,%edi
  801d65:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  801d6c:	00 00 00 
  801d6f:	ff d0                	callq  *%rax
}
  801d71:	c9                   	leaveq 
  801d72:	c3                   	retq   

0000000000801d73 <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  801d73:	55                   	push   %rbp
  801d74:	48 89 e5             	mov    %rsp,%rbp
  801d77:	48 83 ec 30          	sub    $0x30,%rsp
  801d7b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801d7f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d83:	48 8b 00             	mov    (%rax),%rax
  801d86:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801d8a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d8e:	48 8b 40 08          	mov    0x8(%rax),%rax
  801d92:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801d95:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801d98:	83 e0 02             	and    $0x2,%eax
  801d9b:	85 c0                	test   %eax,%eax
  801d9d:	75 4d                	jne    801dec <pgfault+0x79>
  801d9f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801da3:	48 c1 e8 0c          	shr    $0xc,%rax
  801da7:	48 89 c2             	mov    %rax,%rdx
  801daa:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801db1:	01 00 00 
  801db4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801db8:	25 00 08 00 00       	and    $0x800,%eax
  801dbd:	48 85 c0             	test   %rax,%rax
  801dc0:	74 2a                	je     801dec <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  801dc2:	48 ba 70 45 80 00 00 	movabs $0x804570,%rdx
  801dc9:	00 00 00 
  801dcc:	be 23 00 00 00       	mov    $0x23,%esi
  801dd1:	48 bf a5 45 80 00 00 	movabs $0x8045a5,%rdi
  801dd8:	00 00 00 
  801ddb:	b8 00 00 00 00       	mov    $0x0,%eax
  801de0:	48 b9 e9 03 80 00 00 	movabs $0x8003e9,%rcx
  801de7:	00 00 00 
  801dea:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  801dec:	ba 07 00 00 00       	mov    $0x7,%edx
  801df1:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801df6:	bf 00 00 00 00       	mov    $0x0,%edi
  801dfb:	48 b8 06 1b 80 00 00 	movabs $0x801b06,%rax
  801e02:	00 00 00 
  801e05:	ff d0                	callq  *%rax
  801e07:	85 c0                	test   %eax,%eax
  801e09:	0f 85 cd 00 00 00    	jne    801edc <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801e0f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e13:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801e17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e1b:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801e21:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801e25:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e29:	ba 00 10 00 00       	mov    $0x1000,%edx
  801e2e:	48 89 c6             	mov    %rax,%rsi
  801e31:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801e36:	48 b8 fb 14 80 00 00 	movabs $0x8014fb,%rax
  801e3d:	00 00 00 
  801e40:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801e42:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e46:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801e4c:	48 89 c1             	mov    %rax,%rcx
  801e4f:	ba 00 00 00 00       	mov    $0x0,%edx
  801e54:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801e59:	bf 00 00 00 00       	mov    $0x0,%edi
  801e5e:	48 b8 56 1b 80 00 00 	movabs $0x801b56,%rax
  801e65:	00 00 00 
  801e68:	ff d0                	callq  *%rax
  801e6a:	85 c0                	test   %eax,%eax
  801e6c:	79 2a                	jns    801e98 <pgfault+0x125>
				panic("Page map at temp address failed");
  801e6e:	48 ba b0 45 80 00 00 	movabs $0x8045b0,%rdx
  801e75:	00 00 00 
  801e78:	be 30 00 00 00       	mov    $0x30,%esi
  801e7d:	48 bf a5 45 80 00 00 	movabs $0x8045a5,%rdi
  801e84:	00 00 00 
  801e87:	b8 00 00 00 00       	mov    $0x0,%eax
  801e8c:	48 b9 e9 03 80 00 00 	movabs $0x8003e9,%rcx
  801e93:	00 00 00 
  801e96:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801e98:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801e9d:	bf 00 00 00 00       	mov    $0x0,%edi
  801ea2:	48 b8 b1 1b 80 00 00 	movabs $0x801bb1,%rax
  801ea9:	00 00 00 
  801eac:	ff d0                	callq  *%rax
  801eae:	85 c0                	test   %eax,%eax
  801eb0:	79 54                	jns    801f06 <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801eb2:	48 ba d0 45 80 00 00 	movabs $0x8045d0,%rdx
  801eb9:	00 00 00 
  801ebc:	be 32 00 00 00       	mov    $0x32,%esi
  801ec1:	48 bf a5 45 80 00 00 	movabs $0x8045a5,%rdi
  801ec8:	00 00 00 
  801ecb:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed0:	48 b9 e9 03 80 00 00 	movabs $0x8003e9,%rcx
  801ed7:	00 00 00 
  801eda:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  801edc:	48 ba f8 45 80 00 00 	movabs $0x8045f8,%rdx
  801ee3:	00 00 00 
  801ee6:	be 34 00 00 00       	mov    $0x34,%esi
  801eeb:	48 bf a5 45 80 00 00 	movabs $0x8045a5,%rdi
  801ef2:	00 00 00 
  801ef5:	b8 00 00 00 00       	mov    $0x0,%eax
  801efa:	48 b9 e9 03 80 00 00 	movabs $0x8003e9,%rcx
  801f01:	00 00 00 
  801f04:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  801f06:	c9                   	leaveq 
  801f07:	c3                   	retq   

0000000000801f08 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801f08:	55                   	push   %rbp
  801f09:	48 89 e5             	mov    %rsp,%rbp
  801f0c:	48 83 ec 20          	sub    $0x20,%rsp
  801f10:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f13:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  801f16:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f1d:	01 00 00 
  801f20:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801f23:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f27:	25 07 0e 00 00       	and    $0xe07,%eax
  801f2c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801f2f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801f32:	48 c1 e0 0c          	shl    $0xc,%rax
  801f36:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  801f3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f3d:	25 00 04 00 00       	and    $0x400,%eax
  801f42:	85 c0                	test   %eax,%eax
  801f44:	74 57                	je     801f9d <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801f46:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801f49:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801f4d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801f50:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f54:	41 89 f0             	mov    %esi,%r8d
  801f57:	48 89 c6             	mov    %rax,%rsi
  801f5a:	bf 00 00 00 00       	mov    $0x0,%edi
  801f5f:	48 b8 56 1b 80 00 00 	movabs $0x801b56,%rax
  801f66:	00 00 00 
  801f69:	ff d0                	callq  *%rax
  801f6b:	85 c0                	test   %eax,%eax
  801f6d:	0f 8e 52 01 00 00    	jle    8020c5 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801f73:	48 ba 2a 46 80 00 00 	movabs $0x80462a,%rdx
  801f7a:	00 00 00 
  801f7d:	be 4e 00 00 00       	mov    $0x4e,%esi
  801f82:	48 bf a5 45 80 00 00 	movabs $0x8045a5,%rdi
  801f89:	00 00 00 
  801f8c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f91:	48 b9 e9 03 80 00 00 	movabs $0x8003e9,%rcx
  801f98:	00 00 00 
  801f9b:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  801f9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fa0:	83 e0 02             	and    $0x2,%eax
  801fa3:	85 c0                	test   %eax,%eax
  801fa5:	75 10                	jne    801fb7 <duppage+0xaf>
  801fa7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801faa:	25 00 08 00 00       	and    $0x800,%eax
  801faf:	85 c0                	test   %eax,%eax
  801fb1:	0f 84 bb 00 00 00    	je     802072 <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  801fb7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fba:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  801fbf:	80 cc 08             	or     $0x8,%ah
  801fc2:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801fc5:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801fc8:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801fcc:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801fcf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fd3:	41 89 f0             	mov    %esi,%r8d
  801fd6:	48 89 c6             	mov    %rax,%rsi
  801fd9:	bf 00 00 00 00       	mov    $0x0,%edi
  801fde:	48 b8 56 1b 80 00 00 	movabs $0x801b56,%rax
  801fe5:	00 00 00 
  801fe8:	ff d0                	callq  *%rax
  801fea:	85 c0                	test   %eax,%eax
  801fec:	7e 2a                	jle    802018 <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  801fee:	48 ba 2a 46 80 00 00 	movabs $0x80462a,%rdx
  801ff5:	00 00 00 
  801ff8:	be 55 00 00 00       	mov    $0x55,%esi
  801ffd:	48 bf a5 45 80 00 00 	movabs $0x8045a5,%rdi
  802004:	00 00 00 
  802007:	b8 00 00 00 00       	mov    $0x0,%eax
  80200c:	48 b9 e9 03 80 00 00 	movabs $0x8003e9,%rcx
  802013:	00 00 00 
  802016:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  802018:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  80201b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80201f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802023:	41 89 c8             	mov    %ecx,%r8d
  802026:	48 89 d1             	mov    %rdx,%rcx
  802029:	ba 00 00 00 00       	mov    $0x0,%edx
  80202e:	48 89 c6             	mov    %rax,%rsi
  802031:	bf 00 00 00 00       	mov    $0x0,%edi
  802036:	48 b8 56 1b 80 00 00 	movabs $0x801b56,%rax
  80203d:	00 00 00 
  802040:	ff d0                	callq  *%rax
  802042:	85 c0                	test   %eax,%eax
  802044:	7e 2a                	jle    802070 <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  802046:	48 ba 2a 46 80 00 00 	movabs $0x80462a,%rdx
  80204d:	00 00 00 
  802050:	be 57 00 00 00       	mov    $0x57,%esi
  802055:	48 bf a5 45 80 00 00 	movabs $0x8045a5,%rdi
  80205c:	00 00 00 
  80205f:	b8 00 00 00 00       	mov    $0x0,%eax
  802064:	48 b9 e9 03 80 00 00 	movabs $0x8003e9,%rcx
  80206b:	00 00 00 
  80206e:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  802070:	eb 53                	jmp    8020c5 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  802072:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802075:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802079:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80207c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802080:	41 89 f0             	mov    %esi,%r8d
  802083:	48 89 c6             	mov    %rax,%rsi
  802086:	bf 00 00 00 00       	mov    $0x0,%edi
  80208b:	48 b8 56 1b 80 00 00 	movabs $0x801b56,%rax
  802092:	00 00 00 
  802095:	ff d0                	callq  *%rax
  802097:	85 c0                	test   %eax,%eax
  802099:	7e 2a                	jle    8020c5 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  80209b:	48 ba 2a 46 80 00 00 	movabs $0x80462a,%rdx
  8020a2:	00 00 00 
  8020a5:	be 5b 00 00 00       	mov    $0x5b,%esi
  8020aa:	48 bf a5 45 80 00 00 	movabs $0x8045a5,%rdi
  8020b1:	00 00 00 
  8020b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b9:	48 b9 e9 03 80 00 00 	movabs $0x8003e9,%rcx
  8020c0:	00 00 00 
  8020c3:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  8020c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020ca:	c9                   	leaveq 
  8020cb:	c3                   	retq   

00000000008020cc <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  8020cc:	55                   	push   %rbp
  8020cd:	48 89 e5             	mov    %rsp,%rbp
  8020d0:	48 83 ec 18          	sub    $0x18,%rsp
  8020d4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  8020d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020dc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  8020e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020e4:	48 c1 e8 27          	shr    $0x27,%rax
  8020e8:	48 89 c2             	mov    %rax,%rdx
  8020eb:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8020f2:	01 00 00 
  8020f5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020f9:	83 e0 01             	and    $0x1,%eax
  8020fc:	48 85 c0             	test   %rax,%rax
  8020ff:	74 51                	je     802152 <pt_is_mapped+0x86>
  802101:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802105:	48 c1 e0 0c          	shl    $0xc,%rax
  802109:	48 c1 e8 1e          	shr    $0x1e,%rax
  80210d:	48 89 c2             	mov    %rax,%rdx
  802110:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802117:	01 00 00 
  80211a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80211e:	83 e0 01             	and    $0x1,%eax
  802121:	48 85 c0             	test   %rax,%rax
  802124:	74 2c                	je     802152 <pt_is_mapped+0x86>
  802126:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80212a:	48 c1 e0 0c          	shl    $0xc,%rax
  80212e:	48 c1 e8 15          	shr    $0x15,%rax
  802132:	48 89 c2             	mov    %rax,%rdx
  802135:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80213c:	01 00 00 
  80213f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802143:	83 e0 01             	and    $0x1,%eax
  802146:	48 85 c0             	test   %rax,%rax
  802149:	74 07                	je     802152 <pt_is_mapped+0x86>
  80214b:	b8 01 00 00 00       	mov    $0x1,%eax
  802150:	eb 05                	jmp    802157 <pt_is_mapped+0x8b>
  802152:	b8 00 00 00 00       	mov    $0x0,%eax
  802157:	83 e0 01             	and    $0x1,%eax
}
  80215a:	c9                   	leaveq 
  80215b:	c3                   	retq   

000000000080215c <fork>:

envid_t
fork(void)
{
  80215c:	55                   	push   %rbp
  80215d:	48 89 e5             	mov    %rsp,%rbp
  802160:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  802164:	48 bf 73 1d 80 00 00 	movabs $0x801d73,%rdi
  80216b:	00 00 00 
  80216e:	48 b8 4f 3b 80 00 00 	movabs $0x803b4f,%rax
  802175:	00 00 00 
  802178:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80217a:	b8 07 00 00 00       	mov    $0x7,%eax
  80217f:	cd 30                	int    $0x30
  802181:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802184:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  802187:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  80218a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80218e:	79 30                	jns    8021c0 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  802190:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802193:	89 c1                	mov    %eax,%ecx
  802195:	48 ba 48 46 80 00 00 	movabs $0x804648,%rdx
  80219c:	00 00 00 
  80219f:	be 86 00 00 00       	mov    $0x86,%esi
  8021a4:	48 bf a5 45 80 00 00 	movabs $0x8045a5,%rdi
  8021ab:	00 00 00 
  8021ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b3:	49 b8 e9 03 80 00 00 	movabs $0x8003e9,%r8
  8021ba:	00 00 00 
  8021bd:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  8021c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8021c4:	75 46                	jne    80220c <fork+0xb0>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  8021c6:	48 b8 8a 1a 80 00 00 	movabs $0x801a8a,%rax
  8021cd:	00 00 00 
  8021d0:	ff d0                	callq  *%rax
  8021d2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8021d7:	48 63 d0             	movslq %eax,%rdx
  8021da:	48 89 d0             	mov    %rdx,%rax
  8021dd:	48 c1 e0 03          	shl    $0x3,%rax
  8021e1:	48 01 d0             	add    %rdx,%rax
  8021e4:	48 c1 e0 05          	shl    $0x5,%rax
  8021e8:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8021ef:	00 00 00 
  8021f2:	48 01 c2             	add    %rax,%rdx
  8021f5:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  8021fc:	00 00 00 
  8021ff:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  802202:	b8 00 00 00 00       	mov    $0x0,%eax
  802207:	e9 d1 01 00 00       	jmpq   8023dd <fork+0x281>
	}
	uint64_t ad = 0;
  80220c:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802213:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  802214:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  802219:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80221d:	e9 df 00 00 00       	jmpq   802301 <fork+0x1a5>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  802222:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802226:	48 c1 e8 27          	shr    $0x27,%rax
  80222a:	48 89 c2             	mov    %rax,%rdx
  80222d:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802234:	01 00 00 
  802237:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80223b:	83 e0 01             	and    $0x1,%eax
  80223e:	48 85 c0             	test   %rax,%rax
  802241:	0f 84 9e 00 00 00    	je     8022e5 <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  802247:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80224b:	48 c1 e8 1e          	shr    $0x1e,%rax
  80224f:	48 89 c2             	mov    %rax,%rdx
  802252:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802259:	01 00 00 
  80225c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802260:	83 e0 01             	and    $0x1,%eax
  802263:	48 85 c0             	test   %rax,%rax
  802266:	74 73                	je     8022db <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  802268:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80226c:	48 c1 e8 15          	shr    $0x15,%rax
  802270:	48 89 c2             	mov    %rax,%rdx
  802273:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80227a:	01 00 00 
  80227d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802281:	83 e0 01             	and    $0x1,%eax
  802284:	48 85 c0             	test   %rax,%rax
  802287:	74 48                	je     8022d1 <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  802289:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80228d:	48 c1 e8 0c          	shr    $0xc,%rax
  802291:	48 89 c2             	mov    %rax,%rdx
  802294:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80229b:	01 00 00 
  80229e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022a2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8022a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022aa:	83 e0 01             	and    $0x1,%eax
  8022ad:	48 85 c0             	test   %rax,%rax
  8022b0:	74 47                	je     8022f9 <fork+0x19d>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  8022b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022b6:	48 c1 e8 0c          	shr    $0xc,%rax
  8022ba:	89 c2                	mov    %eax,%edx
  8022bc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8022bf:	89 d6                	mov    %edx,%esi
  8022c1:	89 c7                	mov    %eax,%edi
  8022c3:	48 b8 08 1f 80 00 00 	movabs $0x801f08,%rax
  8022ca:	00 00 00 
  8022cd:	ff d0                	callq  *%rax
  8022cf:	eb 28                	jmp    8022f9 <fork+0x19d>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  8022d1:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  8022d8:	00 
  8022d9:	eb 1e                	jmp    8022f9 <fork+0x19d>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  8022db:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  8022e2:	40 
  8022e3:	eb 14                	jmp    8022f9 <fork+0x19d>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  8022e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022e9:	48 c1 e8 27          	shr    $0x27,%rax
  8022ed:	48 83 c0 01          	add    $0x1,%rax
  8022f1:	48 c1 e0 27          	shl    $0x27,%rax
  8022f5:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8022f9:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  802300:	00 
  802301:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  802308:	00 
  802309:	0f 87 13 ff ff ff    	ja     802222 <fork+0xc6>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  80230f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802312:	ba 07 00 00 00       	mov    $0x7,%edx
  802317:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80231c:	89 c7                	mov    %eax,%edi
  80231e:	48 b8 06 1b 80 00 00 	movabs $0x801b06,%rax
  802325:	00 00 00 
  802328:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  80232a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80232d:	ba 07 00 00 00       	mov    $0x7,%edx
  802332:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802337:	89 c7                	mov    %eax,%edi
  802339:	48 b8 06 1b 80 00 00 	movabs $0x801b06,%rax
  802340:	00 00 00 
  802343:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  802345:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802348:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80234e:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  802353:	ba 00 00 00 00       	mov    $0x0,%edx
  802358:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80235d:	89 c7                	mov    %eax,%edi
  80235f:	48 b8 56 1b 80 00 00 	movabs $0x801b56,%rax
  802366:	00 00 00 
  802369:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  80236b:	ba 00 10 00 00       	mov    $0x1000,%edx
  802370:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802375:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  80237a:	48 b8 fb 14 80 00 00 	movabs $0x8014fb,%rax
  802381:	00 00 00 
  802384:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  802386:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80238b:	bf 00 00 00 00       	mov    $0x0,%edi
  802390:	48 b8 b1 1b 80 00 00 	movabs $0x801bb1,%rax
  802397:	00 00 00 
  80239a:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  80239c:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  8023a3:	00 00 00 
  8023a6:	48 8b 00             	mov    (%rax),%rax
  8023a9:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  8023b0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8023b3:	48 89 d6             	mov    %rdx,%rsi
  8023b6:	89 c7                	mov    %eax,%edi
  8023b8:	48 b8 90 1c 80 00 00 	movabs $0x801c90,%rax
  8023bf:	00 00 00 
  8023c2:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  8023c4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8023c7:	be 02 00 00 00       	mov    $0x2,%esi
  8023cc:	89 c7                	mov    %eax,%edi
  8023ce:	48 b8 fb 1b 80 00 00 	movabs $0x801bfb,%rax
  8023d5:	00 00 00 
  8023d8:	ff d0                	callq  *%rax

	return envid;
  8023da:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  8023dd:	c9                   	leaveq 
  8023de:	c3                   	retq   

00000000008023df <sfork>:

	
// Challenge!
int
sfork(void)
{
  8023df:	55                   	push   %rbp
  8023e0:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8023e3:	48 ba 60 46 80 00 00 	movabs $0x804660,%rdx
  8023ea:	00 00 00 
  8023ed:	be bf 00 00 00       	mov    $0xbf,%esi
  8023f2:	48 bf a5 45 80 00 00 	movabs $0x8045a5,%rdi
  8023f9:	00 00 00 
  8023fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802401:	48 b9 e9 03 80 00 00 	movabs $0x8003e9,%rcx
  802408:	00 00 00 
  80240b:	ff d1                	callq  *%rcx

000000000080240d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80240d:	55                   	push   %rbp
  80240e:	48 89 e5             	mov    %rsp,%rbp
  802411:	48 83 ec 08          	sub    $0x8,%rsp
  802415:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802419:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80241d:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802424:	ff ff ff 
  802427:	48 01 d0             	add    %rdx,%rax
  80242a:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80242e:	c9                   	leaveq 
  80242f:	c3                   	retq   

0000000000802430 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802430:	55                   	push   %rbp
  802431:	48 89 e5             	mov    %rsp,%rbp
  802434:	48 83 ec 08          	sub    $0x8,%rsp
  802438:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80243c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802440:	48 89 c7             	mov    %rax,%rdi
  802443:	48 b8 0d 24 80 00 00 	movabs $0x80240d,%rax
  80244a:	00 00 00 
  80244d:	ff d0                	callq  *%rax
  80244f:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802455:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802459:	c9                   	leaveq 
  80245a:	c3                   	retq   

000000000080245b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80245b:	55                   	push   %rbp
  80245c:	48 89 e5             	mov    %rsp,%rbp
  80245f:	48 83 ec 18          	sub    $0x18,%rsp
  802463:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802467:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80246e:	eb 6b                	jmp    8024db <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802470:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802473:	48 98                	cltq   
  802475:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80247b:	48 c1 e0 0c          	shl    $0xc,%rax
  80247f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802483:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802487:	48 c1 e8 15          	shr    $0x15,%rax
  80248b:	48 89 c2             	mov    %rax,%rdx
  80248e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802495:	01 00 00 
  802498:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80249c:	83 e0 01             	and    $0x1,%eax
  80249f:	48 85 c0             	test   %rax,%rax
  8024a2:	74 21                	je     8024c5 <fd_alloc+0x6a>
  8024a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024a8:	48 c1 e8 0c          	shr    $0xc,%rax
  8024ac:	48 89 c2             	mov    %rax,%rdx
  8024af:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024b6:	01 00 00 
  8024b9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024bd:	83 e0 01             	and    $0x1,%eax
  8024c0:	48 85 c0             	test   %rax,%rax
  8024c3:	75 12                	jne    8024d7 <fd_alloc+0x7c>
			*fd_store = fd;
  8024c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024c9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8024cd:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8024d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d5:	eb 1a                	jmp    8024f1 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8024d7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8024db:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8024df:	7e 8f                	jle    802470 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8024e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024e5:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8024ec:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8024f1:	c9                   	leaveq 
  8024f2:	c3                   	retq   

00000000008024f3 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8024f3:	55                   	push   %rbp
  8024f4:	48 89 e5             	mov    %rsp,%rbp
  8024f7:	48 83 ec 20          	sub    $0x20,%rsp
  8024fb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8024fe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802502:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802506:	78 06                	js     80250e <fd_lookup+0x1b>
  802508:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80250c:	7e 07                	jle    802515 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80250e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802513:	eb 6c                	jmp    802581 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802515:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802518:	48 98                	cltq   
  80251a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802520:	48 c1 e0 0c          	shl    $0xc,%rax
  802524:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802528:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80252c:	48 c1 e8 15          	shr    $0x15,%rax
  802530:	48 89 c2             	mov    %rax,%rdx
  802533:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80253a:	01 00 00 
  80253d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802541:	83 e0 01             	and    $0x1,%eax
  802544:	48 85 c0             	test   %rax,%rax
  802547:	74 21                	je     80256a <fd_lookup+0x77>
  802549:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80254d:	48 c1 e8 0c          	shr    $0xc,%rax
  802551:	48 89 c2             	mov    %rax,%rdx
  802554:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80255b:	01 00 00 
  80255e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802562:	83 e0 01             	and    $0x1,%eax
  802565:	48 85 c0             	test   %rax,%rax
  802568:	75 07                	jne    802571 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80256a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80256f:	eb 10                	jmp    802581 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802571:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802575:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802579:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80257c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802581:	c9                   	leaveq 
  802582:	c3                   	retq   

0000000000802583 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802583:	55                   	push   %rbp
  802584:	48 89 e5             	mov    %rsp,%rbp
  802587:	48 83 ec 30          	sub    $0x30,%rsp
  80258b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80258f:	89 f0                	mov    %esi,%eax
  802591:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802594:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802598:	48 89 c7             	mov    %rax,%rdi
  80259b:	48 b8 0d 24 80 00 00 	movabs $0x80240d,%rax
  8025a2:	00 00 00 
  8025a5:	ff d0                	callq  *%rax
  8025a7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025ab:	48 89 d6             	mov    %rdx,%rsi
  8025ae:	89 c7                	mov    %eax,%edi
  8025b0:	48 b8 f3 24 80 00 00 	movabs $0x8024f3,%rax
  8025b7:	00 00 00 
  8025ba:	ff d0                	callq  *%rax
  8025bc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025c3:	78 0a                	js     8025cf <fd_close+0x4c>
	    || fd != fd2)
  8025c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025c9:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8025cd:	74 12                	je     8025e1 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8025cf:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8025d3:	74 05                	je     8025da <fd_close+0x57>
  8025d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025d8:	eb 05                	jmp    8025df <fd_close+0x5c>
  8025da:	b8 00 00 00 00       	mov    $0x0,%eax
  8025df:	eb 69                	jmp    80264a <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8025e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025e5:	8b 00                	mov    (%rax),%eax
  8025e7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8025eb:	48 89 d6             	mov    %rdx,%rsi
  8025ee:	89 c7                	mov    %eax,%edi
  8025f0:	48 b8 4c 26 80 00 00 	movabs $0x80264c,%rax
  8025f7:	00 00 00 
  8025fa:	ff d0                	callq  *%rax
  8025fc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802603:	78 2a                	js     80262f <fd_close+0xac>
		if (dev->dev_close)
  802605:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802609:	48 8b 40 20          	mov    0x20(%rax),%rax
  80260d:	48 85 c0             	test   %rax,%rax
  802610:	74 16                	je     802628 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802612:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802616:	48 8b 40 20          	mov    0x20(%rax),%rax
  80261a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80261e:	48 89 d7             	mov    %rdx,%rdi
  802621:	ff d0                	callq  *%rax
  802623:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802626:	eb 07                	jmp    80262f <fd_close+0xac>
		else
			r = 0;
  802628:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80262f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802633:	48 89 c6             	mov    %rax,%rsi
  802636:	bf 00 00 00 00       	mov    $0x0,%edi
  80263b:	48 b8 b1 1b 80 00 00 	movabs $0x801bb1,%rax
  802642:	00 00 00 
  802645:	ff d0                	callq  *%rax
	return r;
  802647:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80264a:	c9                   	leaveq 
  80264b:	c3                   	retq   

000000000080264c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80264c:	55                   	push   %rbp
  80264d:	48 89 e5             	mov    %rsp,%rbp
  802650:	48 83 ec 20          	sub    $0x20,%rsp
  802654:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802657:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80265b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802662:	eb 41                	jmp    8026a5 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802664:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80266b:	00 00 00 
  80266e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802671:	48 63 d2             	movslq %edx,%rdx
  802674:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802678:	8b 00                	mov    (%rax),%eax
  80267a:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80267d:	75 22                	jne    8026a1 <dev_lookup+0x55>
			*dev = devtab[i];
  80267f:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802686:	00 00 00 
  802689:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80268c:	48 63 d2             	movslq %edx,%rdx
  80268f:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802693:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802697:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80269a:	b8 00 00 00 00       	mov    $0x0,%eax
  80269f:	eb 60                	jmp    802701 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8026a1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8026a5:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8026ac:	00 00 00 
  8026af:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026b2:	48 63 d2             	movslq %edx,%rdx
  8026b5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026b9:	48 85 c0             	test   %rax,%rax
  8026bc:	75 a6                	jne    802664 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8026be:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  8026c5:	00 00 00 
  8026c8:	48 8b 00             	mov    (%rax),%rax
  8026cb:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8026d1:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8026d4:	89 c6                	mov    %eax,%esi
  8026d6:	48 bf 78 46 80 00 00 	movabs $0x804678,%rdi
  8026dd:	00 00 00 
  8026e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e5:	48 b9 22 06 80 00 00 	movabs $0x800622,%rcx
  8026ec:	00 00 00 
  8026ef:	ff d1                	callq  *%rcx
	*dev = 0;
  8026f1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026f5:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8026fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802701:	c9                   	leaveq 
  802702:	c3                   	retq   

0000000000802703 <close>:

int
close(int fdnum)
{
  802703:	55                   	push   %rbp
  802704:	48 89 e5             	mov    %rsp,%rbp
  802707:	48 83 ec 20          	sub    $0x20,%rsp
  80270b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80270e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802712:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802715:	48 89 d6             	mov    %rdx,%rsi
  802718:	89 c7                	mov    %eax,%edi
  80271a:	48 b8 f3 24 80 00 00 	movabs $0x8024f3,%rax
  802721:	00 00 00 
  802724:	ff d0                	callq  *%rax
  802726:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802729:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80272d:	79 05                	jns    802734 <close+0x31>
		return r;
  80272f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802732:	eb 18                	jmp    80274c <close+0x49>
	else
		return fd_close(fd, 1);
  802734:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802738:	be 01 00 00 00       	mov    $0x1,%esi
  80273d:	48 89 c7             	mov    %rax,%rdi
  802740:	48 b8 83 25 80 00 00 	movabs $0x802583,%rax
  802747:	00 00 00 
  80274a:	ff d0                	callq  *%rax
}
  80274c:	c9                   	leaveq 
  80274d:	c3                   	retq   

000000000080274e <close_all>:

void
close_all(void)
{
  80274e:	55                   	push   %rbp
  80274f:	48 89 e5             	mov    %rsp,%rbp
  802752:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802756:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80275d:	eb 15                	jmp    802774 <close_all+0x26>
		close(i);
  80275f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802762:	89 c7                	mov    %eax,%edi
  802764:	48 b8 03 27 80 00 00 	movabs $0x802703,%rax
  80276b:	00 00 00 
  80276e:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802770:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802774:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802778:	7e e5                	jle    80275f <close_all+0x11>
		close(i);
}
  80277a:	c9                   	leaveq 
  80277b:	c3                   	retq   

000000000080277c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80277c:	55                   	push   %rbp
  80277d:	48 89 e5             	mov    %rsp,%rbp
  802780:	48 83 ec 40          	sub    $0x40,%rsp
  802784:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802787:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80278a:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80278e:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802791:	48 89 d6             	mov    %rdx,%rsi
  802794:	89 c7                	mov    %eax,%edi
  802796:	48 b8 f3 24 80 00 00 	movabs $0x8024f3,%rax
  80279d:	00 00 00 
  8027a0:	ff d0                	callq  *%rax
  8027a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027a9:	79 08                	jns    8027b3 <dup+0x37>
		return r;
  8027ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027ae:	e9 70 01 00 00       	jmpq   802923 <dup+0x1a7>
	close(newfdnum);
  8027b3:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8027b6:	89 c7                	mov    %eax,%edi
  8027b8:	48 b8 03 27 80 00 00 	movabs $0x802703,%rax
  8027bf:	00 00 00 
  8027c2:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8027c4:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8027c7:	48 98                	cltq   
  8027c9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8027cf:	48 c1 e0 0c          	shl    $0xc,%rax
  8027d3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8027d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027db:	48 89 c7             	mov    %rax,%rdi
  8027de:	48 b8 30 24 80 00 00 	movabs $0x802430,%rax
  8027e5:	00 00 00 
  8027e8:	ff d0                	callq  *%rax
  8027ea:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8027ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027f2:	48 89 c7             	mov    %rax,%rdi
  8027f5:	48 b8 30 24 80 00 00 	movabs $0x802430,%rax
  8027fc:	00 00 00 
  8027ff:	ff d0                	callq  *%rax
  802801:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802805:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802809:	48 c1 e8 15          	shr    $0x15,%rax
  80280d:	48 89 c2             	mov    %rax,%rdx
  802810:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802817:	01 00 00 
  80281a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80281e:	83 e0 01             	and    $0x1,%eax
  802821:	48 85 c0             	test   %rax,%rax
  802824:	74 73                	je     802899 <dup+0x11d>
  802826:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80282a:	48 c1 e8 0c          	shr    $0xc,%rax
  80282e:	48 89 c2             	mov    %rax,%rdx
  802831:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802838:	01 00 00 
  80283b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80283f:	83 e0 01             	and    $0x1,%eax
  802842:	48 85 c0             	test   %rax,%rax
  802845:	74 52                	je     802899 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802847:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80284b:	48 c1 e8 0c          	shr    $0xc,%rax
  80284f:	48 89 c2             	mov    %rax,%rdx
  802852:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802859:	01 00 00 
  80285c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802860:	25 07 0e 00 00       	and    $0xe07,%eax
  802865:	89 c1                	mov    %eax,%ecx
  802867:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80286b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80286f:	41 89 c8             	mov    %ecx,%r8d
  802872:	48 89 d1             	mov    %rdx,%rcx
  802875:	ba 00 00 00 00       	mov    $0x0,%edx
  80287a:	48 89 c6             	mov    %rax,%rsi
  80287d:	bf 00 00 00 00       	mov    $0x0,%edi
  802882:	48 b8 56 1b 80 00 00 	movabs $0x801b56,%rax
  802889:	00 00 00 
  80288c:	ff d0                	callq  *%rax
  80288e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802891:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802895:	79 02                	jns    802899 <dup+0x11d>
			goto err;
  802897:	eb 57                	jmp    8028f0 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802899:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80289d:	48 c1 e8 0c          	shr    $0xc,%rax
  8028a1:	48 89 c2             	mov    %rax,%rdx
  8028a4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8028ab:	01 00 00 
  8028ae:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028b2:	25 07 0e 00 00       	and    $0xe07,%eax
  8028b7:	89 c1                	mov    %eax,%ecx
  8028b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028bd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8028c1:	41 89 c8             	mov    %ecx,%r8d
  8028c4:	48 89 d1             	mov    %rdx,%rcx
  8028c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8028cc:	48 89 c6             	mov    %rax,%rsi
  8028cf:	bf 00 00 00 00       	mov    $0x0,%edi
  8028d4:	48 b8 56 1b 80 00 00 	movabs $0x801b56,%rax
  8028db:	00 00 00 
  8028de:	ff d0                	callq  *%rax
  8028e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028e7:	79 02                	jns    8028eb <dup+0x16f>
		goto err;
  8028e9:	eb 05                	jmp    8028f0 <dup+0x174>

	return newfdnum;
  8028eb:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8028ee:	eb 33                	jmp    802923 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8028f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028f4:	48 89 c6             	mov    %rax,%rsi
  8028f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8028fc:	48 b8 b1 1b 80 00 00 	movabs $0x801bb1,%rax
  802903:	00 00 00 
  802906:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802908:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80290c:	48 89 c6             	mov    %rax,%rsi
  80290f:	bf 00 00 00 00       	mov    $0x0,%edi
  802914:	48 b8 b1 1b 80 00 00 	movabs $0x801bb1,%rax
  80291b:	00 00 00 
  80291e:	ff d0                	callq  *%rax
	return r;
  802920:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802923:	c9                   	leaveq 
  802924:	c3                   	retq   

0000000000802925 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802925:	55                   	push   %rbp
  802926:	48 89 e5             	mov    %rsp,%rbp
  802929:	48 83 ec 40          	sub    $0x40,%rsp
  80292d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802930:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802934:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802938:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80293c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80293f:	48 89 d6             	mov    %rdx,%rsi
  802942:	89 c7                	mov    %eax,%edi
  802944:	48 b8 f3 24 80 00 00 	movabs $0x8024f3,%rax
  80294b:	00 00 00 
  80294e:	ff d0                	callq  *%rax
  802950:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802953:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802957:	78 24                	js     80297d <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802959:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80295d:	8b 00                	mov    (%rax),%eax
  80295f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802963:	48 89 d6             	mov    %rdx,%rsi
  802966:	89 c7                	mov    %eax,%edi
  802968:	48 b8 4c 26 80 00 00 	movabs $0x80264c,%rax
  80296f:	00 00 00 
  802972:	ff d0                	callq  *%rax
  802974:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802977:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80297b:	79 05                	jns    802982 <read+0x5d>
		return r;
  80297d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802980:	eb 76                	jmp    8029f8 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802982:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802986:	8b 40 08             	mov    0x8(%rax),%eax
  802989:	83 e0 03             	and    $0x3,%eax
  80298c:	83 f8 01             	cmp    $0x1,%eax
  80298f:	75 3a                	jne    8029cb <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802991:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  802998:	00 00 00 
  80299b:	48 8b 00             	mov    (%rax),%rax
  80299e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029a4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8029a7:	89 c6                	mov    %eax,%esi
  8029a9:	48 bf 97 46 80 00 00 	movabs $0x804697,%rdi
  8029b0:	00 00 00 
  8029b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b8:	48 b9 22 06 80 00 00 	movabs $0x800622,%rcx
  8029bf:	00 00 00 
  8029c2:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8029c4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029c9:	eb 2d                	jmp    8029f8 <read+0xd3>
	}
	if (!dev->dev_read)
  8029cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029cf:	48 8b 40 10          	mov    0x10(%rax),%rax
  8029d3:	48 85 c0             	test   %rax,%rax
  8029d6:	75 07                	jne    8029df <read+0xba>
		return -E_NOT_SUPP;
  8029d8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8029dd:	eb 19                	jmp    8029f8 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8029df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029e3:	48 8b 40 10          	mov    0x10(%rax),%rax
  8029e7:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8029eb:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8029ef:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8029f3:	48 89 cf             	mov    %rcx,%rdi
  8029f6:	ff d0                	callq  *%rax
}
  8029f8:	c9                   	leaveq 
  8029f9:	c3                   	retq   

00000000008029fa <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8029fa:	55                   	push   %rbp
  8029fb:	48 89 e5             	mov    %rsp,%rbp
  8029fe:	48 83 ec 30          	sub    $0x30,%rsp
  802a02:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a05:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a09:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802a0d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a14:	eb 49                	jmp    802a5f <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802a16:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a19:	48 98                	cltq   
  802a1b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a1f:	48 29 c2             	sub    %rax,%rdx
  802a22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a25:	48 63 c8             	movslq %eax,%rcx
  802a28:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a2c:	48 01 c1             	add    %rax,%rcx
  802a2f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a32:	48 89 ce             	mov    %rcx,%rsi
  802a35:	89 c7                	mov    %eax,%edi
  802a37:	48 b8 25 29 80 00 00 	movabs $0x802925,%rax
  802a3e:	00 00 00 
  802a41:	ff d0                	callq  *%rax
  802a43:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802a46:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802a4a:	79 05                	jns    802a51 <readn+0x57>
			return m;
  802a4c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a4f:	eb 1c                	jmp    802a6d <readn+0x73>
		if (m == 0)
  802a51:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802a55:	75 02                	jne    802a59 <readn+0x5f>
			break;
  802a57:	eb 11                	jmp    802a6a <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802a59:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a5c:	01 45 fc             	add    %eax,-0x4(%rbp)
  802a5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a62:	48 98                	cltq   
  802a64:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802a68:	72 ac                	jb     802a16 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802a6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802a6d:	c9                   	leaveq 
  802a6e:	c3                   	retq   

0000000000802a6f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802a6f:	55                   	push   %rbp
  802a70:	48 89 e5             	mov    %rsp,%rbp
  802a73:	48 83 ec 40          	sub    $0x40,%rsp
  802a77:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a7a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802a7e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a82:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a86:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a89:	48 89 d6             	mov    %rdx,%rsi
  802a8c:	89 c7                	mov    %eax,%edi
  802a8e:	48 b8 f3 24 80 00 00 	movabs $0x8024f3,%rax
  802a95:	00 00 00 
  802a98:	ff d0                	callq  *%rax
  802a9a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a9d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802aa1:	78 24                	js     802ac7 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802aa3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aa7:	8b 00                	mov    (%rax),%eax
  802aa9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802aad:	48 89 d6             	mov    %rdx,%rsi
  802ab0:	89 c7                	mov    %eax,%edi
  802ab2:	48 b8 4c 26 80 00 00 	movabs $0x80264c,%rax
  802ab9:	00 00 00 
  802abc:	ff d0                	callq  *%rax
  802abe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ac1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ac5:	79 05                	jns    802acc <write+0x5d>
		return r;
  802ac7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aca:	eb 75                	jmp    802b41 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802acc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ad0:	8b 40 08             	mov    0x8(%rax),%eax
  802ad3:	83 e0 03             	and    $0x3,%eax
  802ad6:	85 c0                	test   %eax,%eax
  802ad8:	75 3a                	jne    802b14 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802ada:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  802ae1:	00 00 00 
  802ae4:	48 8b 00             	mov    (%rax),%rax
  802ae7:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802aed:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802af0:	89 c6                	mov    %eax,%esi
  802af2:	48 bf b3 46 80 00 00 	movabs $0x8046b3,%rdi
  802af9:	00 00 00 
  802afc:	b8 00 00 00 00       	mov    $0x0,%eax
  802b01:	48 b9 22 06 80 00 00 	movabs $0x800622,%rcx
  802b08:	00 00 00 
  802b0b:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802b0d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b12:	eb 2d                	jmp    802b41 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802b14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b18:	48 8b 40 18          	mov    0x18(%rax),%rax
  802b1c:	48 85 c0             	test   %rax,%rax
  802b1f:	75 07                	jne    802b28 <write+0xb9>
		return -E_NOT_SUPP;
  802b21:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b26:	eb 19                	jmp    802b41 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802b28:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b2c:	48 8b 40 18          	mov    0x18(%rax),%rax
  802b30:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802b34:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b38:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802b3c:	48 89 cf             	mov    %rcx,%rdi
  802b3f:	ff d0                	callq  *%rax
}
  802b41:	c9                   	leaveq 
  802b42:	c3                   	retq   

0000000000802b43 <seek>:

int
seek(int fdnum, off_t offset)
{
  802b43:	55                   	push   %rbp
  802b44:	48 89 e5             	mov    %rsp,%rbp
  802b47:	48 83 ec 18          	sub    $0x18,%rsp
  802b4b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b4e:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b51:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b55:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b58:	48 89 d6             	mov    %rdx,%rsi
  802b5b:	89 c7                	mov    %eax,%edi
  802b5d:	48 b8 f3 24 80 00 00 	movabs $0x8024f3,%rax
  802b64:	00 00 00 
  802b67:	ff d0                	callq  *%rax
  802b69:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b6c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b70:	79 05                	jns    802b77 <seek+0x34>
		return r;
  802b72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b75:	eb 0f                	jmp    802b86 <seek+0x43>
	fd->fd_offset = offset;
  802b77:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b7b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802b7e:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802b81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b86:	c9                   	leaveq 
  802b87:	c3                   	retq   

0000000000802b88 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802b88:	55                   	push   %rbp
  802b89:	48 89 e5             	mov    %rsp,%rbp
  802b8c:	48 83 ec 30          	sub    $0x30,%rsp
  802b90:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b93:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b96:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b9a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b9d:	48 89 d6             	mov    %rdx,%rsi
  802ba0:	89 c7                	mov    %eax,%edi
  802ba2:	48 b8 f3 24 80 00 00 	movabs $0x8024f3,%rax
  802ba9:	00 00 00 
  802bac:	ff d0                	callq  *%rax
  802bae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bb1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bb5:	78 24                	js     802bdb <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802bb7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bbb:	8b 00                	mov    (%rax),%eax
  802bbd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802bc1:	48 89 d6             	mov    %rdx,%rsi
  802bc4:	89 c7                	mov    %eax,%edi
  802bc6:	48 b8 4c 26 80 00 00 	movabs $0x80264c,%rax
  802bcd:	00 00 00 
  802bd0:	ff d0                	callq  *%rax
  802bd2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bd5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bd9:	79 05                	jns    802be0 <ftruncate+0x58>
		return r;
  802bdb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bde:	eb 72                	jmp    802c52 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802be0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802be4:	8b 40 08             	mov    0x8(%rax),%eax
  802be7:	83 e0 03             	and    $0x3,%eax
  802bea:	85 c0                	test   %eax,%eax
  802bec:	75 3a                	jne    802c28 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802bee:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  802bf5:	00 00 00 
  802bf8:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802bfb:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c01:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c04:	89 c6                	mov    %eax,%esi
  802c06:	48 bf d0 46 80 00 00 	movabs $0x8046d0,%rdi
  802c0d:	00 00 00 
  802c10:	b8 00 00 00 00       	mov    $0x0,%eax
  802c15:	48 b9 22 06 80 00 00 	movabs $0x800622,%rcx
  802c1c:	00 00 00 
  802c1f:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802c21:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c26:	eb 2a                	jmp    802c52 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802c28:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c2c:	48 8b 40 30          	mov    0x30(%rax),%rax
  802c30:	48 85 c0             	test   %rax,%rax
  802c33:	75 07                	jne    802c3c <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802c35:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c3a:	eb 16                	jmp    802c52 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802c3c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c40:	48 8b 40 30          	mov    0x30(%rax),%rax
  802c44:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c48:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802c4b:	89 ce                	mov    %ecx,%esi
  802c4d:	48 89 d7             	mov    %rdx,%rdi
  802c50:	ff d0                	callq  *%rax
}
  802c52:	c9                   	leaveq 
  802c53:	c3                   	retq   

0000000000802c54 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802c54:	55                   	push   %rbp
  802c55:	48 89 e5             	mov    %rsp,%rbp
  802c58:	48 83 ec 30          	sub    $0x30,%rsp
  802c5c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c5f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c63:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c67:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c6a:	48 89 d6             	mov    %rdx,%rsi
  802c6d:	89 c7                	mov    %eax,%edi
  802c6f:	48 b8 f3 24 80 00 00 	movabs $0x8024f3,%rax
  802c76:	00 00 00 
  802c79:	ff d0                	callq  *%rax
  802c7b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c7e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c82:	78 24                	js     802ca8 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c88:	8b 00                	mov    (%rax),%eax
  802c8a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c8e:	48 89 d6             	mov    %rdx,%rsi
  802c91:	89 c7                	mov    %eax,%edi
  802c93:	48 b8 4c 26 80 00 00 	movabs $0x80264c,%rax
  802c9a:	00 00 00 
  802c9d:	ff d0                	callq  *%rax
  802c9f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ca2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ca6:	79 05                	jns    802cad <fstat+0x59>
		return r;
  802ca8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cab:	eb 5e                	jmp    802d0b <fstat+0xb7>
	if (!dev->dev_stat)
  802cad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cb1:	48 8b 40 28          	mov    0x28(%rax),%rax
  802cb5:	48 85 c0             	test   %rax,%rax
  802cb8:	75 07                	jne    802cc1 <fstat+0x6d>
		return -E_NOT_SUPP;
  802cba:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802cbf:	eb 4a                	jmp    802d0b <fstat+0xb7>
	stat->st_name[0] = 0;
  802cc1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802cc5:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802cc8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ccc:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802cd3:	00 00 00 
	stat->st_isdir = 0;
  802cd6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802cda:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802ce1:	00 00 00 
	stat->st_dev = dev;
  802ce4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ce8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802cec:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802cf3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cf7:	48 8b 40 28          	mov    0x28(%rax),%rax
  802cfb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802cff:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802d03:	48 89 ce             	mov    %rcx,%rsi
  802d06:	48 89 d7             	mov    %rdx,%rdi
  802d09:	ff d0                	callq  *%rax
}
  802d0b:	c9                   	leaveq 
  802d0c:	c3                   	retq   

0000000000802d0d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802d0d:	55                   	push   %rbp
  802d0e:	48 89 e5             	mov    %rsp,%rbp
  802d11:	48 83 ec 20          	sub    $0x20,%rsp
  802d15:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d19:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802d1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d21:	be 00 00 00 00       	mov    $0x0,%esi
  802d26:	48 89 c7             	mov    %rax,%rdi
  802d29:	48 b8 fb 2d 80 00 00 	movabs $0x802dfb,%rax
  802d30:	00 00 00 
  802d33:	ff d0                	callq  *%rax
  802d35:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d38:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d3c:	79 05                	jns    802d43 <stat+0x36>
		return fd;
  802d3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d41:	eb 2f                	jmp    802d72 <stat+0x65>
	r = fstat(fd, stat);
  802d43:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802d47:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d4a:	48 89 d6             	mov    %rdx,%rsi
  802d4d:	89 c7                	mov    %eax,%edi
  802d4f:	48 b8 54 2c 80 00 00 	movabs $0x802c54,%rax
  802d56:	00 00 00 
  802d59:	ff d0                	callq  *%rax
  802d5b:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802d5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d61:	89 c7                	mov    %eax,%edi
  802d63:	48 b8 03 27 80 00 00 	movabs $0x802703,%rax
  802d6a:	00 00 00 
  802d6d:	ff d0                	callq  *%rax
	return r;
  802d6f:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802d72:	c9                   	leaveq 
  802d73:	c3                   	retq   

0000000000802d74 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802d74:	55                   	push   %rbp
  802d75:	48 89 e5             	mov    %rsp,%rbp
  802d78:	48 83 ec 10          	sub    $0x10,%rsp
  802d7c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802d7f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802d83:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802d8a:	00 00 00 
  802d8d:	8b 00                	mov    (%rax),%eax
  802d8f:	85 c0                	test   %eax,%eax
  802d91:	75 1d                	jne    802db0 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802d93:	bf 01 00 00 00       	mov    $0x1,%edi
  802d98:	48 b8 f7 3d 80 00 00 	movabs $0x803df7,%rax
  802d9f:	00 00 00 
  802da2:	ff d0                	callq  *%rax
  802da4:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802dab:	00 00 00 
  802dae:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802db0:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802db7:	00 00 00 
  802dba:	8b 00                	mov    (%rax),%eax
  802dbc:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802dbf:	b9 07 00 00 00       	mov    $0x7,%ecx
  802dc4:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802dcb:	00 00 00 
  802dce:	89 c7                	mov    %eax,%edi
  802dd0:	48 b8 95 3d 80 00 00 	movabs $0x803d95,%rax
  802dd7:	00 00 00 
  802dda:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802ddc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802de0:	ba 00 00 00 00       	mov    $0x0,%edx
  802de5:	48 89 c6             	mov    %rax,%rsi
  802de8:	bf 00 00 00 00       	mov    $0x0,%edi
  802ded:	48 b8 8f 3c 80 00 00 	movabs $0x803c8f,%rax
  802df4:	00 00 00 
  802df7:	ff d0                	callq  *%rax
}
  802df9:	c9                   	leaveq 
  802dfa:	c3                   	retq   

0000000000802dfb <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802dfb:	55                   	push   %rbp
  802dfc:	48 89 e5             	mov    %rsp,%rbp
  802dff:	48 83 ec 30          	sub    $0x30,%rsp
  802e03:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802e07:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802e0a:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802e11:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802e18:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802e1f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802e24:	75 08                	jne    802e2e <open+0x33>
	{
		return r;
  802e26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e29:	e9 f2 00 00 00       	jmpq   802f20 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802e2e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e32:	48 89 c7             	mov    %rax,%rdi
  802e35:	48 b8 6b 11 80 00 00 	movabs $0x80116b,%rax
  802e3c:	00 00 00 
  802e3f:	ff d0                	callq  *%rax
  802e41:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802e44:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802e4b:	7e 0a                	jle    802e57 <open+0x5c>
	{
		return -E_BAD_PATH;
  802e4d:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802e52:	e9 c9 00 00 00       	jmpq   802f20 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802e57:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802e5e:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802e5f:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802e63:	48 89 c7             	mov    %rax,%rdi
  802e66:	48 b8 5b 24 80 00 00 	movabs $0x80245b,%rax
  802e6d:	00 00 00 
  802e70:	ff d0                	callq  *%rax
  802e72:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e75:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e79:	78 09                	js     802e84 <open+0x89>
  802e7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e7f:	48 85 c0             	test   %rax,%rax
  802e82:	75 08                	jne    802e8c <open+0x91>
		{
			return r;
  802e84:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e87:	e9 94 00 00 00       	jmpq   802f20 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802e8c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e90:	ba 00 04 00 00       	mov    $0x400,%edx
  802e95:	48 89 c6             	mov    %rax,%rsi
  802e98:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802e9f:	00 00 00 
  802ea2:	48 b8 69 12 80 00 00 	movabs $0x801269,%rax
  802ea9:	00 00 00 
  802eac:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802eae:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802eb5:	00 00 00 
  802eb8:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802ebb:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802ec1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ec5:	48 89 c6             	mov    %rax,%rsi
  802ec8:	bf 01 00 00 00       	mov    $0x1,%edi
  802ecd:	48 b8 74 2d 80 00 00 	movabs $0x802d74,%rax
  802ed4:	00 00 00 
  802ed7:	ff d0                	callq  *%rax
  802ed9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802edc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ee0:	79 2b                	jns    802f0d <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802ee2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ee6:	be 00 00 00 00       	mov    $0x0,%esi
  802eeb:	48 89 c7             	mov    %rax,%rdi
  802eee:	48 b8 83 25 80 00 00 	movabs $0x802583,%rax
  802ef5:	00 00 00 
  802ef8:	ff d0                	callq  *%rax
  802efa:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802efd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802f01:	79 05                	jns    802f08 <open+0x10d>
			{
				return d;
  802f03:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f06:	eb 18                	jmp    802f20 <open+0x125>
			}
			return r;
  802f08:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f0b:	eb 13                	jmp    802f20 <open+0x125>
		}	
		return fd2num(fd_store);
  802f0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f11:	48 89 c7             	mov    %rax,%rdi
  802f14:	48 b8 0d 24 80 00 00 	movabs $0x80240d,%rax
  802f1b:	00 00 00 
  802f1e:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802f20:	c9                   	leaveq 
  802f21:	c3                   	retq   

0000000000802f22 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802f22:	55                   	push   %rbp
  802f23:	48 89 e5             	mov    %rsp,%rbp
  802f26:	48 83 ec 10          	sub    $0x10,%rsp
  802f2a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802f2e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f32:	8b 50 0c             	mov    0xc(%rax),%edx
  802f35:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f3c:	00 00 00 
  802f3f:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802f41:	be 00 00 00 00       	mov    $0x0,%esi
  802f46:	bf 06 00 00 00       	mov    $0x6,%edi
  802f4b:	48 b8 74 2d 80 00 00 	movabs $0x802d74,%rax
  802f52:	00 00 00 
  802f55:	ff d0                	callq  *%rax
}
  802f57:	c9                   	leaveq 
  802f58:	c3                   	retq   

0000000000802f59 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802f59:	55                   	push   %rbp
  802f5a:	48 89 e5             	mov    %rsp,%rbp
  802f5d:	48 83 ec 30          	sub    $0x30,%rsp
  802f61:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f65:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f69:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802f6d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802f74:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802f79:	74 07                	je     802f82 <devfile_read+0x29>
  802f7b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802f80:	75 07                	jne    802f89 <devfile_read+0x30>
		return -E_INVAL;
  802f82:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802f87:	eb 77                	jmp    803000 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802f89:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f8d:	8b 50 0c             	mov    0xc(%rax),%edx
  802f90:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f97:	00 00 00 
  802f9a:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802f9c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fa3:	00 00 00 
  802fa6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802faa:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802fae:	be 00 00 00 00       	mov    $0x0,%esi
  802fb3:	bf 03 00 00 00       	mov    $0x3,%edi
  802fb8:	48 b8 74 2d 80 00 00 	movabs $0x802d74,%rax
  802fbf:	00 00 00 
  802fc2:	ff d0                	callq  *%rax
  802fc4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fc7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fcb:	7f 05                	jg     802fd2 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802fcd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fd0:	eb 2e                	jmp    803000 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802fd2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fd5:	48 63 d0             	movslq %eax,%rdx
  802fd8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fdc:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802fe3:	00 00 00 
  802fe6:	48 89 c7             	mov    %rax,%rdi
  802fe9:	48 b8 fb 14 80 00 00 	movabs $0x8014fb,%rax
  802ff0:	00 00 00 
  802ff3:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802ff5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ff9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802ffd:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  803000:	c9                   	leaveq 
  803001:	c3                   	retq   

0000000000803002 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803002:	55                   	push   %rbp
  803003:	48 89 e5             	mov    %rsp,%rbp
  803006:	48 83 ec 30          	sub    $0x30,%rsp
  80300a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80300e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803012:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  803016:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  80301d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803022:	74 07                	je     80302b <devfile_write+0x29>
  803024:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803029:	75 08                	jne    803033 <devfile_write+0x31>
		return r;
  80302b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80302e:	e9 9a 00 00 00       	jmpq   8030cd <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  803033:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803037:	8b 50 0c             	mov    0xc(%rax),%edx
  80303a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803041:	00 00 00 
  803044:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  803046:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  80304d:	00 
  80304e:	76 08                	jbe    803058 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  803050:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  803057:	00 
	}
	fsipcbuf.write.req_n = n;
  803058:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80305f:	00 00 00 
  803062:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803066:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  80306a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80306e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803072:	48 89 c6             	mov    %rax,%rsi
  803075:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  80307c:	00 00 00 
  80307f:	48 b8 fb 14 80 00 00 	movabs $0x8014fb,%rax
  803086:	00 00 00 
  803089:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  80308b:	be 00 00 00 00       	mov    $0x0,%esi
  803090:	bf 04 00 00 00       	mov    $0x4,%edi
  803095:	48 b8 74 2d 80 00 00 	movabs $0x802d74,%rax
  80309c:	00 00 00 
  80309f:	ff d0                	callq  *%rax
  8030a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030a8:	7f 20                	jg     8030ca <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  8030aa:	48 bf f6 46 80 00 00 	movabs $0x8046f6,%rdi
  8030b1:	00 00 00 
  8030b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8030b9:	48 ba 22 06 80 00 00 	movabs $0x800622,%rdx
  8030c0:	00 00 00 
  8030c3:	ff d2                	callq  *%rdx
		return r;
  8030c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030c8:	eb 03                	jmp    8030cd <devfile_write+0xcb>
	}
	return r;
  8030ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  8030cd:	c9                   	leaveq 
  8030ce:	c3                   	retq   

00000000008030cf <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8030cf:	55                   	push   %rbp
  8030d0:	48 89 e5             	mov    %rsp,%rbp
  8030d3:	48 83 ec 20          	sub    $0x20,%rsp
  8030d7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030db:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8030df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030e3:	8b 50 0c             	mov    0xc(%rax),%edx
  8030e6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030ed:	00 00 00 
  8030f0:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8030f2:	be 00 00 00 00       	mov    $0x0,%esi
  8030f7:	bf 05 00 00 00       	mov    $0x5,%edi
  8030fc:	48 b8 74 2d 80 00 00 	movabs $0x802d74,%rax
  803103:	00 00 00 
  803106:	ff d0                	callq  *%rax
  803108:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80310b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80310f:	79 05                	jns    803116 <devfile_stat+0x47>
		return r;
  803111:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803114:	eb 56                	jmp    80316c <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803116:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80311a:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803121:	00 00 00 
  803124:	48 89 c7             	mov    %rax,%rdi
  803127:	48 b8 d7 11 80 00 00 	movabs $0x8011d7,%rax
  80312e:	00 00 00 
  803131:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803133:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80313a:	00 00 00 
  80313d:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803143:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803147:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80314d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803154:	00 00 00 
  803157:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80315d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803161:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803167:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80316c:	c9                   	leaveq 
  80316d:	c3                   	retq   

000000000080316e <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80316e:	55                   	push   %rbp
  80316f:	48 89 e5             	mov    %rsp,%rbp
  803172:	48 83 ec 10          	sub    $0x10,%rsp
  803176:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80317a:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80317d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803181:	8b 50 0c             	mov    0xc(%rax),%edx
  803184:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80318b:	00 00 00 
  80318e:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803190:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803197:	00 00 00 
  80319a:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80319d:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8031a0:	be 00 00 00 00       	mov    $0x0,%esi
  8031a5:	bf 02 00 00 00       	mov    $0x2,%edi
  8031aa:	48 b8 74 2d 80 00 00 	movabs $0x802d74,%rax
  8031b1:	00 00 00 
  8031b4:	ff d0                	callq  *%rax
}
  8031b6:	c9                   	leaveq 
  8031b7:	c3                   	retq   

00000000008031b8 <remove>:

// Delete a file
int
remove(const char *path)
{
  8031b8:	55                   	push   %rbp
  8031b9:	48 89 e5             	mov    %rsp,%rbp
  8031bc:	48 83 ec 10          	sub    $0x10,%rsp
  8031c0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8031c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031c8:	48 89 c7             	mov    %rax,%rdi
  8031cb:	48 b8 6b 11 80 00 00 	movabs $0x80116b,%rax
  8031d2:	00 00 00 
  8031d5:	ff d0                	callq  *%rax
  8031d7:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8031dc:	7e 07                	jle    8031e5 <remove+0x2d>
		return -E_BAD_PATH;
  8031de:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8031e3:	eb 33                	jmp    803218 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8031e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031e9:	48 89 c6             	mov    %rax,%rsi
  8031ec:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8031f3:	00 00 00 
  8031f6:	48 b8 d7 11 80 00 00 	movabs $0x8011d7,%rax
  8031fd:	00 00 00 
  803200:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803202:	be 00 00 00 00       	mov    $0x0,%esi
  803207:	bf 07 00 00 00       	mov    $0x7,%edi
  80320c:	48 b8 74 2d 80 00 00 	movabs $0x802d74,%rax
  803213:	00 00 00 
  803216:	ff d0                	callq  *%rax
}
  803218:	c9                   	leaveq 
  803219:	c3                   	retq   

000000000080321a <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80321a:	55                   	push   %rbp
  80321b:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80321e:	be 00 00 00 00       	mov    $0x0,%esi
  803223:	bf 08 00 00 00       	mov    $0x8,%edi
  803228:	48 b8 74 2d 80 00 00 	movabs $0x802d74,%rax
  80322f:	00 00 00 
  803232:	ff d0                	callq  *%rax
}
  803234:	5d                   	pop    %rbp
  803235:	c3                   	retq   

0000000000803236 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803236:	55                   	push   %rbp
  803237:	48 89 e5             	mov    %rsp,%rbp
  80323a:	53                   	push   %rbx
  80323b:	48 83 ec 38          	sub    $0x38,%rsp
  80323f:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803243:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803247:	48 89 c7             	mov    %rax,%rdi
  80324a:	48 b8 5b 24 80 00 00 	movabs $0x80245b,%rax
  803251:	00 00 00 
  803254:	ff d0                	callq  *%rax
  803256:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803259:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80325d:	0f 88 bf 01 00 00    	js     803422 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803263:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803267:	ba 07 04 00 00       	mov    $0x407,%edx
  80326c:	48 89 c6             	mov    %rax,%rsi
  80326f:	bf 00 00 00 00       	mov    $0x0,%edi
  803274:	48 b8 06 1b 80 00 00 	movabs $0x801b06,%rax
  80327b:	00 00 00 
  80327e:	ff d0                	callq  *%rax
  803280:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803283:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803287:	0f 88 95 01 00 00    	js     803422 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80328d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803291:	48 89 c7             	mov    %rax,%rdi
  803294:	48 b8 5b 24 80 00 00 	movabs $0x80245b,%rax
  80329b:	00 00 00 
  80329e:	ff d0                	callq  *%rax
  8032a0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032a3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032a7:	0f 88 5d 01 00 00    	js     80340a <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8032ad:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032b1:	ba 07 04 00 00       	mov    $0x407,%edx
  8032b6:	48 89 c6             	mov    %rax,%rsi
  8032b9:	bf 00 00 00 00       	mov    $0x0,%edi
  8032be:	48 b8 06 1b 80 00 00 	movabs $0x801b06,%rax
  8032c5:	00 00 00 
  8032c8:	ff d0                	callq  *%rax
  8032ca:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032d1:	0f 88 33 01 00 00    	js     80340a <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8032d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032db:	48 89 c7             	mov    %rax,%rdi
  8032de:	48 b8 30 24 80 00 00 	movabs $0x802430,%rax
  8032e5:	00 00 00 
  8032e8:	ff d0                	callq  *%rax
  8032ea:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8032ee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032f2:	ba 07 04 00 00       	mov    $0x407,%edx
  8032f7:	48 89 c6             	mov    %rax,%rsi
  8032fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8032ff:	48 b8 06 1b 80 00 00 	movabs $0x801b06,%rax
  803306:	00 00 00 
  803309:	ff d0                	callq  *%rax
  80330b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80330e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803312:	79 05                	jns    803319 <pipe+0xe3>
		goto err2;
  803314:	e9 d9 00 00 00       	jmpq   8033f2 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803319:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80331d:	48 89 c7             	mov    %rax,%rdi
  803320:	48 b8 30 24 80 00 00 	movabs $0x802430,%rax
  803327:	00 00 00 
  80332a:	ff d0                	callq  *%rax
  80332c:	48 89 c2             	mov    %rax,%rdx
  80332f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803333:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803339:	48 89 d1             	mov    %rdx,%rcx
  80333c:	ba 00 00 00 00       	mov    $0x0,%edx
  803341:	48 89 c6             	mov    %rax,%rsi
  803344:	bf 00 00 00 00       	mov    $0x0,%edi
  803349:	48 b8 56 1b 80 00 00 	movabs $0x801b56,%rax
  803350:	00 00 00 
  803353:	ff d0                	callq  *%rax
  803355:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803358:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80335c:	79 1b                	jns    803379 <pipe+0x143>
		goto err3;
  80335e:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  80335f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803363:	48 89 c6             	mov    %rax,%rsi
  803366:	bf 00 00 00 00       	mov    $0x0,%edi
  80336b:	48 b8 b1 1b 80 00 00 	movabs $0x801bb1,%rax
  803372:	00 00 00 
  803375:	ff d0                	callq  *%rax
  803377:	eb 79                	jmp    8033f2 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803379:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80337d:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803384:	00 00 00 
  803387:	8b 12                	mov    (%rdx),%edx
  803389:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80338b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80338f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803396:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80339a:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  8033a1:	00 00 00 
  8033a4:	8b 12                	mov    (%rdx),%edx
  8033a6:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8033a8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033ac:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8033b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033b7:	48 89 c7             	mov    %rax,%rdi
  8033ba:	48 b8 0d 24 80 00 00 	movabs $0x80240d,%rax
  8033c1:	00 00 00 
  8033c4:	ff d0                	callq  *%rax
  8033c6:	89 c2                	mov    %eax,%edx
  8033c8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8033cc:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8033ce:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8033d2:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8033d6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033da:	48 89 c7             	mov    %rax,%rdi
  8033dd:	48 b8 0d 24 80 00 00 	movabs $0x80240d,%rax
  8033e4:	00 00 00 
  8033e7:	ff d0                	callq  *%rax
  8033e9:	89 03                	mov    %eax,(%rbx)
	return 0;
  8033eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8033f0:	eb 33                	jmp    803425 <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  8033f2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033f6:	48 89 c6             	mov    %rax,%rsi
  8033f9:	bf 00 00 00 00       	mov    $0x0,%edi
  8033fe:	48 b8 b1 1b 80 00 00 	movabs $0x801bb1,%rax
  803405:	00 00 00 
  803408:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  80340a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80340e:	48 89 c6             	mov    %rax,%rsi
  803411:	bf 00 00 00 00       	mov    $0x0,%edi
  803416:	48 b8 b1 1b 80 00 00 	movabs $0x801bb1,%rax
  80341d:	00 00 00 
  803420:	ff d0                	callq  *%rax
    err:
	return r;
  803422:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803425:	48 83 c4 38          	add    $0x38,%rsp
  803429:	5b                   	pop    %rbx
  80342a:	5d                   	pop    %rbp
  80342b:	c3                   	retq   

000000000080342c <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80342c:	55                   	push   %rbp
  80342d:	48 89 e5             	mov    %rsp,%rbp
  803430:	53                   	push   %rbx
  803431:	48 83 ec 28          	sub    $0x28,%rsp
  803435:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803439:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80343d:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803444:	00 00 00 
  803447:	48 8b 00             	mov    (%rax),%rax
  80344a:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803450:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803453:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803457:	48 89 c7             	mov    %rax,%rdi
  80345a:	48 b8 79 3e 80 00 00 	movabs $0x803e79,%rax
  803461:	00 00 00 
  803464:	ff d0                	callq  *%rax
  803466:	89 c3                	mov    %eax,%ebx
  803468:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80346c:	48 89 c7             	mov    %rax,%rdi
  80346f:	48 b8 79 3e 80 00 00 	movabs $0x803e79,%rax
  803476:	00 00 00 
  803479:	ff d0                	callq  *%rax
  80347b:	39 c3                	cmp    %eax,%ebx
  80347d:	0f 94 c0             	sete   %al
  803480:	0f b6 c0             	movzbl %al,%eax
  803483:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803486:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  80348d:	00 00 00 
  803490:	48 8b 00             	mov    (%rax),%rax
  803493:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803499:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80349c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80349f:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8034a2:	75 05                	jne    8034a9 <_pipeisclosed+0x7d>
			return ret;
  8034a4:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8034a7:	eb 4f                	jmp    8034f8 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8034a9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034ac:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8034af:	74 42                	je     8034f3 <_pipeisclosed+0xc7>
  8034b1:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8034b5:	75 3c                	jne    8034f3 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8034b7:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  8034be:	00 00 00 
  8034c1:	48 8b 00             	mov    (%rax),%rax
  8034c4:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8034ca:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8034cd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034d0:	89 c6                	mov    %eax,%esi
  8034d2:	48 bf 17 47 80 00 00 	movabs $0x804717,%rdi
  8034d9:	00 00 00 
  8034dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8034e1:	49 b8 22 06 80 00 00 	movabs $0x800622,%r8
  8034e8:	00 00 00 
  8034eb:	41 ff d0             	callq  *%r8
	}
  8034ee:	e9 4a ff ff ff       	jmpq   80343d <_pipeisclosed+0x11>
  8034f3:	e9 45 ff ff ff       	jmpq   80343d <_pipeisclosed+0x11>
}
  8034f8:	48 83 c4 28          	add    $0x28,%rsp
  8034fc:	5b                   	pop    %rbx
  8034fd:	5d                   	pop    %rbp
  8034fe:	c3                   	retq   

00000000008034ff <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8034ff:	55                   	push   %rbp
  803500:	48 89 e5             	mov    %rsp,%rbp
  803503:	48 83 ec 30          	sub    $0x30,%rsp
  803507:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80350a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80350e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803511:	48 89 d6             	mov    %rdx,%rsi
  803514:	89 c7                	mov    %eax,%edi
  803516:	48 b8 f3 24 80 00 00 	movabs $0x8024f3,%rax
  80351d:	00 00 00 
  803520:	ff d0                	callq  *%rax
  803522:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803525:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803529:	79 05                	jns    803530 <pipeisclosed+0x31>
		return r;
  80352b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80352e:	eb 31                	jmp    803561 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803530:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803534:	48 89 c7             	mov    %rax,%rdi
  803537:	48 b8 30 24 80 00 00 	movabs $0x802430,%rax
  80353e:	00 00 00 
  803541:	ff d0                	callq  *%rax
  803543:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803547:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80354b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80354f:	48 89 d6             	mov    %rdx,%rsi
  803552:	48 89 c7             	mov    %rax,%rdi
  803555:	48 b8 2c 34 80 00 00 	movabs $0x80342c,%rax
  80355c:	00 00 00 
  80355f:	ff d0                	callq  *%rax
}
  803561:	c9                   	leaveq 
  803562:	c3                   	retq   

0000000000803563 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803563:	55                   	push   %rbp
  803564:	48 89 e5             	mov    %rsp,%rbp
  803567:	48 83 ec 40          	sub    $0x40,%rsp
  80356b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80356f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803573:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803577:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80357b:	48 89 c7             	mov    %rax,%rdi
  80357e:	48 b8 30 24 80 00 00 	movabs $0x802430,%rax
  803585:	00 00 00 
  803588:	ff d0                	callq  *%rax
  80358a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80358e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803592:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803596:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80359d:	00 
  80359e:	e9 92 00 00 00       	jmpq   803635 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8035a3:	eb 41                	jmp    8035e6 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8035a5:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8035aa:	74 09                	je     8035b5 <devpipe_read+0x52>
				return i;
  8035ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035b0:	e9 92 00 00 00       	jmpq   803647 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8035b5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8035b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035bd:	48 89 d6             	mov    %rdx,%rsi
  8035c0:	48 89 c7             	mov    %rax,%rdi
  8035c3:	48 b8 2c 34 80 00 00 	movabs $0x80342c,%rax
  8035ca:	00 00 00 
  8035cd:	ff d0                	callq  *%rax
  8035cf:	85 c0                	test   %eax,%eax
  8035d1:	74 07                	je     8035da <devpipe_read+0x77>
				return 0;
  8035d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8035d8:	eb 6d                	jmp    803647 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8035da:	48 b8 c8 1a 80 00 00 	movabs $0x801ac8,%rax
  8035e1:	00 00 00 
  8035e4:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8035e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035ea:	8b 10                	mov    (%rax),%edx
  8035ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035f0:	8b 40 04             	mov    0x4(%rax),%eax
  8035f3:	39 c2                	cmp    %eax,%edx
  8035f5:	74 ae                	je     8035a5 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8035f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035fb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8035ff:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803603:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803607:	8b 00                	mov    (%rax),%eax
  803609:	99                   	cltd   
  80360a:	c1 ea 1b             	shr    $0x1b,%edx
  80360d:	01 d0                	add    %edx,%eax
  80360f:	83 e0 1f             	and    $0x1f,%eax
  803612:	29 d0                	sub    %edx,%eax
  803614:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803618:	48 98                	cltq   
  80361a:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80361f:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803621:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803625:	8b 00                	mov    (%rax),%eax
  803627:	8d 50 01             	lea    0x1(%rax),%edx
  80362a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80362e:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803630:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803635:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803639:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80363d:	0f 82 60 ff ff ff    	jb     8035a3 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803643:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803647:	c9                   	leaveq 
  803648:	c3                   	retq   

0000000000803649 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803649:	55                   	push   %rbp
  80364a:	48 89 e5             	mov    %rsp,%rbp
  80364d:	48 83 ec 40          	sub    $0x40,%rsp
  803651:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803655:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803659:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80365d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803661:	48 89 c7             	mov    %rax,%rdi
  803664:	48 b8 30 24 80 00 00 	movabs $0x802430,%rax
  80366b:	00 00 00 
  80366e:	ff d0                	callq  *%rax
  803670:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803674:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803678:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80367c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803683:	00 
  803684:	e9 8e 00 00 00       	jmpq   803717 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803689:	eb 31                	jmp    8036bc <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80368b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80368f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803693:	48 89 d6             	mov    %rdx,%rsi
  803696:	48 89 c7             	mov    %rax,%rdi
  803699:	48 b8 2c 34 80 00 00 	movabs $0x80342c,%rax
  8036a0:	00 00 00 
  8036a3:	ff d0                	callq  *%rax
  8036a5:	85 c0                	test   %eax,%eax
  8036a7:	74 07                	je     8036b0 <devpipe_write+0x67>
				return 0;
  8036a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8036ae:	eb 79                	jmp    803729 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8036b0:	48 b8 c8 1a 80 00 00 	movabs $0x801ac8,%rax
  8036b7:	00 00 00 
  8036ba:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8036bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036c0:	8b 40 04             	mov    0x4(%rax),%eax
  8036c3:	48 63 d0             	movslq %eax,%rdx
  8036c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036ca:	8b 00                	mov    (%rax),%eax
  8036cc:	48 98                	cltq   
  8036ce:	48 83 c0 20          	add    $0x20,%rax
  8036d2:	48 39 c2             	cmp    %rax,%rdx
  8036d5:	73 b4                	jae    80368b <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8036d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036db:	8b 40 04             	mov    0x4(%rax),%eax
  8036de:	99                   	cltd   
  8036df:	c1 ea 1b             	shr    $0x1b,%edx
  8036e2:	01 d0                	add    %edx,%eax
  8036e4:	83 e0 1f             	and    $0x1f,%eax
  8036e7:	29 d0                	sub    %edx,%eax
  8036e9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8036ed:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8036f1:	48 01 ca             	add    %rcx,%rdx
  8036f4:	0f b6 0a             	movzbl (%rdx),%ecx
  8036f7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8036fb:	48 98                	cltq   
  8036fd:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803701:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803705:	8b 40 04             	mov    0x4(%rax),%eax
  803708:	8d 50 01             	lea    0x1(%rax),%edx
  80370b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80370f:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803712:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803717:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80371b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80371f:	0f 82 64 ff ff ff    	jb     803689 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803725:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803729:	c9                   	leaveq 
  80372a:	c3                   	retq   

000000000080372b <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80372b:	55                   	push   %rbp
  80372c:	48 89 e5             	mov    %rsp,%rbp
  80372f:	48 83 ec 20          	sub    $0x20,%rsp
  803733:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803737:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80373b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80373f:	48 89 c7             	mov    %rax,%rdi
  803742:	48 b8 30 24 80 00 00 	movabs $0x802430,%rax
  803749:	00 00 00 
  80374c:	ff d0                	callq  *%rax
  80374e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803752:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803756:	48 be 2a 47 80 00 00 	movabs $0x80472a,%rsi
  80375d:	00 00 00 
  803760:	48 89 c7             	mov    %rax,%rdi
  803763:	48 b8 d7 11 80 00 00 	movabs $0x8011d7,%rax
  80376a:	00 00 00 
  80376d:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80376f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803773:	8b 50 04             	mov    0x4(%rax),%edx
  803776:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80377a:	8b 00                	mov    (%rax),%eax
  80377c:	29 c2                	sub    %eax,%edx
  80377e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803782:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803788:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80378c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803793:	00 00 00 
	stat->st_dev = &devpipe;
  803796:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80379a:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  8037a1:	00 00 00 
  8037a4:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8037ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037b0:	c9                   	leaveq 
  8037b1:	c3                   	retq   

00000000008037b2 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8037b2:	55                   	push   %rbp
  8037b3:	48 89 e5             	mov    %rsp,%rbp
  8037b6:	48 83 ec 10          	sub    $0x10,%rsp
  8037ba:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8037be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037c2:	48 89 c6             	mov    %rax,%rsi
  8037c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8037ca:	48 b8 b1 1b 80 00 00 	movabs $0x801bb1,%rax
  8037d1:	00 00 00 
  8037d4:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8037d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037da:	48 89 c7             	mov    %rax,%rdi
  8037dd:	48 b8 30 24 80 00 00 	movabs $0x802430,%rax
  8037e4:	00 00 00 
  8037e7:	ff d0                	callq  *%rax
  8037e9:	48 89 c6             	mov    %rax,%rsi
  8037ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8037f1:	48 b8 b1 1b 80 00 00 	movabs $0x801bb1,%rax
  8037f8:	00 00 00 
  8037fb:	ff d0                	callq  *%rax
}
  8037fd:	c9                   	leaveq 
  8037fe:	c3                   	retq   

00000000008037ff <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8037ff:	55                   	push   %rbp
  803800:	48 89 e5             	mov    %rsp,%rbp
  803803:	48 83 ec 20          	sub    $0x20,%rsp
  803807:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  80380a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80380e:	75 35                	jne    803845 <wait+0x46>
  803810:	48 b9 31 47 80 00 00 	movabs $0x804731,%rcx
  803817:	00 00 00 
  80381a:	48 ba 3c 47 80 00 00 	movabs $0x80473c,%rdx
  803821:	00 00 00 
  803824:	be 09 00 00 00       	mov    $0x9,%esi
  803829:	48 bf 51 47 80 00 00 	movabs $0x804751,%rdi
  803830:	00 00 00 
  803833:	b8 00 00 00 00       	mov    $0x0,%eax
  803838:	49 b8 e9 03 80 00 00 	movabs $0x8003e9,%r8
  80383f:	00 00 00 
  803842:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  803845:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803848:	25 ff 03 00 00       	and    $0x3ff,%eax
  80384d:	48 63 d0             	movslq %eax,%rdx
  803850:	48 89 d0             	mov    %rdx,%rax
  803853:	48 c1 e0 03          	shl    $0x3,%rax
  803857:	48 01 d0             	add    %rdx,%rax
  80385a:	48 c1 e0 05          	shl    $0x5,%rax
  80385e:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803865:	00 00 00 
  803868:	48 01 d0             	add    %rdx,%rax
  80386b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE){
  80386f:	eb 0c                	jmp    80387d <wait+0x7e>
	//cprintf("envid is [%d]",envid);
		sys_yield();
  803871:	48 b8 c8 1a 80 00 00 	movabs $0x801ac8,%rax
  803878:	00 00 00 
  80387b:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE){
  80387d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803881:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803887:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80388a:	75 0e                	jne    80389a <wait+0x9b>
  80388c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803890:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803896:	85 c0                	test   %eax,%eax
  803898:	75 d7                	jne    803871 <wait+0x72>
	//cprintf("envid is [%d]",envid);
		sys_yield();
	}
}
  80389a:	c9                   	leaveq 
  80389b:	c3                   	retq   

000000000080389c <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80389c:	55                   	push   %rbp
  80389d:	48 89 e5             	mov    %rsp,%rbp
  8038a0:	48 83 ec 20          	sub    $0x20,%rsp
  8038a4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8038a7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038aa:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8038ad:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8038b1:	be 01 00 00 00       	mov    $0x1,%esi
  8038b6:	48 89 c7             	mov    %rax,%rdi
  8038b9:	48 b8 be 19 80 00 00 	movabs $0x8019be,%rax
  8038c0:	00 00 00 
  8038c3:	ff d0                	callq  *%rax
}
  8038c5:	c9                   	leaveq 
  8038c6:	c3                   	retq   

00000000008038c7 <getchar>:

int
getchar(void)
{
  8038c7:	55                   	push   %rbp
  8038c8:	48 89 e5             	mov    %rsp,%rbp
  8038cb:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8038cf:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8038d3:	ba 01 00 00 00       	mov    $0x1,%edx
  8038d8:	48 89 c6             	mov    %rax,%rsi
  8038db:	bf 00 00 00 00       	mov    $0x0,%edi
  8038e0:	48 b8 25 29 80 00 00 	movabs $0x802925,%rax
  8038e7:	00 00 00 
  8038ea:	ff d0                	callq  *%rax
  8038ec:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8038ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038f3:	79 05                	jns    8038fa <getchar+0x33>
		return r;
  8038f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038f8:	eb 14                	jmp    80390e <getchar+0x47>
	if (r < 1)
  8038fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038fe:	7f 07                	jg     803907 <getchar+0x40>
		return -E_EOF;
  803900:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803905:	eb 07                	jmp    80390e <getchar+0x47>
	return c;
  803907:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80390b:	0f b6 c0             	movzbl %al,%eax
}
  80390e:	c9                   	leaveq 
  80390f:	c3                   	retq   

0000000000803910 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803910:	55                   	push   %rbp
  803911:	48 89 e5             	mov    %rsp,%rbp
  803914:	48 83 ec 20          	sub    $0x20,%rsp
  803918:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80391b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80391f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803922:	48 89 d6             	mov    %rdx,%rsi
  803925:	89 c7                	mov    %eax,%edi
  803927:	48 b8 f3 24 80 00 00 	movabs $0x8024f3,%rax
  80392e:	00 00 00 
  803931:	ff d0                	callq  *%rax
  803933:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803936:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80393a:	79 05                	jns    803941 <iscons+0x31>
		return r;
  80393c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80393f:	eb 1a                	jmp    80395b <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803941:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803945:	8b 10                	mov    (%rax),%edx
  803947:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  80394e:	00 00 00 
  803951:	8b 00                	mov    (%rax),%eax
  803953:	39 c2                	cmp    %eax,%edx
  803955:	0f 94 c0             	sete   %al
  803958:	0f b6 c0             	movzbl %al,%eax
}
  80395b:	c9                   	leaveq 
  80395c:	c3                   	retq   

000000000080395d <opencons>:

int
opencons(void)
{
  80395d:	55                   	push   %rbp
  80395e:	48 89 e5             	mov    %rsp,%rbp
  803961:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803965:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803969:	48 89 c7             	mov    %rax,%rdi
  80396c:	48 b8 5b 24 80 00 00 	movabs $0x80245b,%rax
  803973:	00 00 00 
  803976:	ff d0                	callq  *%rax
  803978:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80397b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80397f:	79 05                	jns    803986 <opencons+0x29>
		return r;
  803981:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803984:	eb 5b                	jmp    8039e1 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803986:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80398a:	ba 07 04 00 00       	mov    $0x407,%edx
  80398f:	48 89 c6             	mov    %rax,%rsi
  803992:	bf 00 00 00 00       	mov    $0x0,%edi
  803997:	48 b8 06 1b 80 00 00 	movabs $0x801b06,%rax
  80399e:	00 00 00 
  8039a1:	ff d0                	callq  *%rax
  8039a3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039aa:	79 05                	jns    8039b1 <opencons+0x54>
		return r;
  8039ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039af:	eb 30                	jmp    8039e1 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8039b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039b5:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  8039bc:	00 00 00 
  8039bf:	8b 12                	mov    (%rdx),%edx
  8039c1:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8039c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039c7:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8039ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039d2:	48 89 c7             	mov    %rax,%rdi
  8039d5:	48 b8 0d 24 80 00 00 	movabs $0x80240d,%rax
  8039dc:	00 00 00 
  8039df:	ff d0                	callq  *%rax
}
  8039e1:	c9                   	leaveq 
  8039e2:	c3                   	retq   

00000000008039e3 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8039e3:	55                   	push   %rbp
  8039e4:	48 89 e5             	mov    %rsp,%rbp
  8039e7:	48 83 ec 30          	sub    $0x30,%rsp
  8039eb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8039ef:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8039f3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8039f7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8039fc:	75 07                	jne    803a05 <devcons_read+0x22>
		return 0;
  8039fe:	b8 00 00 00 00       	mov    $0x0,%eax
  803a03:	eb 4b                	jmp    803a50 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803a05:	eb 0c                	jmp    803a13 <devcons_read+0x30>
		sys_yield();
  803a07:	48 b8 c8 1a 80 00 00 	movabs $0x801ac8,%rax
  803a0e:	00 00 00 
  803a11:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803a13:	48 b8 08 1a 80 00 00 	movabs $0x801a08,%rax
  803a1a:	00 00 00 
  803a1d:	ff d0                	callq  *%rax
  803a1f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a22:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a26:	74 df                	je     803a07 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803a28:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a2c:	79 05                	jns    803a33 <devcons_read+0x50>
		return c;
  803a2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a31:	eb 1d                	jmp    803a50 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803a33:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803a37:	75 07                	jne    803a40 <devcons_read+0x5d>
		return 0;
  803a39:	b8 00 00 00 00       	mov    $0x0,%eax
  803a3e:	eb 10                	jmp    803a50 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803a40:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a43:	89 c2                	mov    %eax,%edx
  803a45:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a49:	88 10                	mov    %dl,(%rax)
	return 1;
  803a4b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803a50:	c9                   	leaveq 
  803a51:	c3                   	retq   

0000000000803a52 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803a52:	55                   	push   %rbp
  803a53:	48 89 e5             	mov    %rsp,%rbp
  803a56:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803a5d:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803a64:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803a6b:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803a72:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803a79:	eb 76                	jmp    803af1 <devcons_write+0x9f>
		m = n - tot;
  803a7b:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803a82:	89 c2                	mov    %eax,%edx
  803a84:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a87:	29 c2                	sub    %eax,%edx
  803a89:	89 d0                	mov    %edx,%eax
  803a8b:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803a8e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a91:	83 f8 7f             	cmp    $0x7f,%eax
  803a94:	76 07                	jbe    803a9d <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803a96:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803a9d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803aa0:	48 63 d0             	movslq %eax,%rdx
  803aa3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803aa6:	48 63 c8             	movslq %eax,%rcx
  803aa9:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803ab0:	48 01 c1             	add    %rax,%rcx
  803ab3:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803aba:	48 89 ce             	mov    %rcx,%rsi
  803abd:	48 89 c7             	mov    %rax,%rdi
  803ac0:	48 b8 fb 14 80 00 00 	movabs $0x8014fb,%rax
  803ac7:	00 00 00 
  803aca:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803acc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803acf:	48 63 d0             	movslq %eax,%rdx
  803ad2:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803ad9:	48 89 d6             	mov    %rdx,%rsi
  803adc:	48 89 c7             	mov    %rax,%rdi
  803adf:	48 b8 be 19 80 00 00 	movabs $0x8019be,%rax
  803ae6:	00 00 00 
  803ae9:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803aeb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803aee:	01 45 fc             	add    %eax,-0x4(%rbp)
  803af1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803af4:	48 98                	cltq   
  803af6:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803afd:	0f 82 78 ff ff ff    	jb     803a7b <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803b03:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803b06:	c9                   	leaveq 
  803b07:	c3                   	retq   

0000000000803b08 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803b08:	55                   	push   %rbp
  803b09:	48 89 e5             	mov    %rsp,%rbp
  803b0c:	48 83 ec 08          	sub    $0x8,%rsp
  803b10:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803b14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b19:	c9                   	leaveq 
  803b1a:	c3                   	retq   

0000000000803b1b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803b1b:	55                   	push   %rbp
  803b1c:	48 89 e5             	mov    %rsp,%rbp
  803b1f:	48 83 ec 10          	sub    $0x10,%rsp
  803b23:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803b27:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803b2b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b2f:	48 be 61 47 80 00 00 	movabs $0x804761,%rsi
  803b36:	00 00 00 
  803b39:	48 89 c7             	mov    %rax,%rdi
  803b3c:	48 b8 d7 11 80 00 00 	movabs $0x8011d7,%rax
  803b43:	00 00 00 
  803b46:	ff d0                	callq  *%rax
	return 0;
  803b48:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b4d:	c9                   	leaveq 
  803b4e:	c3                   	retq   

0000000000803b4f <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803b4f:	55                   	push   %rbp
  803b50:	48 89 e5             	mov    %rsp,%rbp
  803b53:	48 83 ec 10          	sub    $0x10,%rsp
  803b57:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  803b5b:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803b62:	00 00 00 
  803b65:	48 8b 00             	mov    (%rax),%rax
  803b68:	48 85 c0             	test   %rax,%rax
  803b6b:	0f 85 84 00 00 00    	jne    803bf5 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  803b71:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803b78:	00 00 00 
  803b7b:	48 8b 00             	mov    (%rax),%rax
  803b7e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803b84:	ba 07 00 00 00       	mov    $0x7,%edx
  803b89:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803b8e:	89 c7                	mov    %eax,%edi
  803b90:	48 b8 06 1b 80 00 00 	movabs $0x801b06,%rax
  803b97:	00 00 00 
  803b9a:	ff d0                	callq  *%rax
  803b9c:	85 c0                	test   %eax,%eax
  803b9e:	79 2a                	jns    803bca <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  803ba0:	48 ba 68 47 80 00 00 	movabs $0x804768,%rdx
  803ba7:	00 00 00 
  803baa:	be 23 00 00 00       	mov    $0x23,%esi
  803baf:	48 bf 8f 47 80 00 00 	movabs $0x80478f,%rdi
  803bb6:	00 00 00 
  803bb9:	b8 00 00 00 00       	mov    $0x0,%eax
  803bbe:	48 b9 e9 03 80 00 00 	movabs $0x8003e9,%rcx
  803bc5:	00 00 00 
  803bc8:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  803bca:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803bd1:	00 00 00 
  803bd4:	48 8b 00             	mov    (%rax),%rax
  803bd7:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803bdd:	48 be 08 3c 80 00 00 	movabs $0x803c08,%rsi
  803be4:	00 00 00 
  803be7:	89 c7                	mov    %eax,%edi
  803be9:	48 b8 90 1c 80 00 00 	movabs $0x801c90,%rax
  803bf0:	00 00 00 
  803bf3:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  803bf5:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803bfc:	00 00 00 
  803bff:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803c03:	48 89 10             	mov    %rdx,(%rax)
}
  803c06:	c9                   	leaveq 
  803c07:	c3                   	retq   

0000000000803c08 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  803c08:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  803c0b:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  803c12:	00 00 00 
	call *%rax
  803c15:	ff d0                	callq  *%rax


	/*This code is to be removed*/

	// LAB 4: Your code here.
	movq 136(%rsp), %rbx  //Load RIP 
  803c17:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  803c1e:	00 
	movq 152(%rsp), %rcx  //Load RSP
  803c1f:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  803c26:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  803c27:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  803c2b:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  803c2e:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  803c35:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  803c36:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  803c3a:	4c 8b 3c 24          	mov    (%rsp),%r15
  803c3e:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803c43:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803c48:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803c4d:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803c52:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803c57:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803c5c:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803c61:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803c66:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803c6b:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803c70:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803c75:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803c7a:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803c7f:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803c84:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  803c88:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  803c8c:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  803c8d:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  803c8e:	c3                   	retq   

0000000000803c8f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803c8f:	55                   	push   %rbp
  803c90:	48 89 e5             	mov    %rsp,%rbp
  803c93:	48 83 ec 30          	sub    $0x30,%rsp
  803c97:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803c9b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c9f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803ca3:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803caa:	00 00 00 
  803cad:	48 8b 00             	mov    (%rax),%rax
  803cb0:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803cb6:	85 c0                	test   %eax,%eax
  803cb8:	75 3c                	jne    803cf6 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  803cba:	48 b8 8a 1a 80 00 00 	movabs $0x801a8a,%rax
  803cc1:	00 00 00 
  803cc4:	ff d0                	callq  *%rax
  803cc6:	25 ff 03 00 00       	and    $0x3ff,%eax
  803ccb:	48 63 d0             	movslq %eax,%rdx
  803cce:	48 89 d0             	mov    %rdx,%rax
  803cd1:	48 c1 e0 03          	shl    $0x3,%rax
  803cd5:	48 01 d0             	add    %rdx,%rax
  803cd8:	48 c1 e0 05          	shl    $0x5,%rax
  803cdc:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803ce3:	00 00 00 
  803ce6:	48 01 c2             	add    %rax,%rdx
  803ce9:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803cf0:	00 00 00 
  803cf3:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803cf6:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803cfb:	75 0e                	jne    803d0b <ipc_recv+0x7c>
		pg = (void*) UTOP;
  803cfd:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803d04:	00 00 00 
  803d07:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803d0b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d0f:	48 89 c7             	mov    %rax,%rdi
  803d12:	48 b8 2f 1d 80 00 00 	movabs $0x801d2f,%rax
  803d19:	00 00 00 
  803d1c:	ff d0                	callq  *%rax
  803d1e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803d21:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d25:	79 19                	jns    803d40 <ipc_recv+0xb1>
		*from_env_store = 0;
  803d27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d2b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803d31:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d35:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803d3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d3e:	eb 53                	jmp    803d93 <ipc_recv+0x104>
	}
	if(from_env_store)
  803d40:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803d45:	74 19                	je     803d60 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  803d47:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803d4e:	00 00 00 
  803d51:	48 8b 00             	mov    (%rax),%rax
  803d54:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803d5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d5e:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803d60:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803d65:	74 19                	je     803d80 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  803d67:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803d6e:	00 00 00 
  803d71:	48 8b 00             	mov    (%rax),%rax
  803d74:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803d7a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d7e:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803d80:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803d87:	00 00 00 
  803d8a:	48 8b 00             	mov    (%rax),%rax
  803d8d:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803d93:	c9                   	leaveq 
  803d94:	c3                   	retq   

0000000000803d95 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803d95:	55                   	push   %rbp
  803d96:	48 89 e5             	mov    %rsp,%rbp
  803d99:	48 83 ec 30          	sub    $0x30,%rsp
  803d9d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803da0:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803da3:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803da7:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803daa:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803daf:	75 0e                	jne    803dbf <ipc_send+0x2a>
		pg = (void*)UTOP;
  803db1:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803db8:	00 00 00 
  803dbb:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  803dbf:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803dc2:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803dc5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803dc9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803dcc:	89 c7                	mov    %eax,%edi
  803dce:	48 b8 da 1c 80 00 00 	movabs $0x801cda,%rax
  803dd5:	00 00 00 
  803dd8:	ff d0                	callq  *%rax
  803dda:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  803ddd:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803de1:	75 0c                	jne    803def <ipc_send+0x5a>
			sys_yield();
  803de3:	48 b8 c8 1a 80 00 00 	movabs $0x801ac8,%rax
  803dea:	00 00 00 
  803ded:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  803def:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803df3:	74 ca                	je     803dbf <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  803df5:	c9                   	leaveq 
  803df6:	c3                   	retq   

0000000000803df7 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803df7:	55                   	push   %rbp
  803df8:	48 89 e5             	mov    %rsp,%rbp
  803dfb:	48 83 ec 14          	sub    $0x14,%rsp
  803dff:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  803e02:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803e09:	eb 5e                	jmp    803e69 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803e0b:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803e12:	00 00 00 
  803e15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e18:	48 63 d0             	movslq %eax,%rdx
  803e1b:	48 89 d0             	mov    %rdx,%rax
  803e1e:	48 c1 e0 03          	shl    $0x3,%rax
  803e22:	48 01 d0             	add    %rdx,%rax
  803e25:	48 c1 e0 05          	shl    $0x5,%rax
  803e29:	48 01 c8             	add    %rcx,%rax
  803e2c:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803e32:	8b 00                	mov    (%rax),%eax
  803e34:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803e37:	75 2c                	jne    803e65 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803e39:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803e40:	00 00 00 
  803e43:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e46:	48 63 d0             	movslq %eax,%rdx
  803e49:	48 89 d0             	mov    %rdx,%rax
  803e4c:	48 c1 e0 03          	shl    $0x3,%rax
  803e50:	48 01 d0             	add    %rdx,%rax
  803e53:	48 c1 e0 05          	shl    $0x5,%rax
  803e57:	48 01 c8             	add    %rcx,%rax
  803e5a:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803e60:	8b 40 08             	mov    0x8(%rax),%eax
  803e63:	eb 12                	jmp    803e77 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803e65:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803e69:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803e70:	7e 99                	jle    803e0b <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803e72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e77:	c9                   	leaveq 
  803e78:	c3                   	retq   

0000000000803e79 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803e79:	55                   	push   %rbp
  803e7a:	48 89 e5             	mov    %rsp,%rbp
  803e7d:	48 83 ec 18          	sub    $0x18,%rsp
  803e81:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803e85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e89:	48 c1 e8 15          	shr    $0x15,%rax
  803e8d:	48 89 c2             	mov    %rax,%rdx
  803e90:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803e97:	01 00 00 
  803e9a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e9e:	83 e0 01             	and    $0x1,%eax
  803ea1:	48 85 c0             	test   %rax,%rax
  803ea4:	75 07                	jne    803ead <pageref+0x34>
		return 0;
  803ea6:	b8 00 00 00 00       	mov    $0x0,%eax
  803eab:	eb 53                	jmp    803f00 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803ead:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803eb1:	48 c1 e8 0c          	shr    $0xc,%rax
  803eb5:	48 89 c2             	mov    %rax,%rdx
  803eb8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803ebf:	01 00 00 
  803ec2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803ec6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803eca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ece:	83 e0 01             	and    $0x1,%eax
  803ed1:	48 85 c0             	test   %rax,%rax
  803ed4:	75 07                	jne    803edd <pageref+0x64>
		return 0;
  803ed6:	b8 00 00 00 00       	mov    $0x0,%eax
  803edb:	eb 23                	jmp    803f00 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803edd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ee1:	48 c1 e8 0c          	shr    $0xc,%rax
  803ee5:	48 89 c2             	mov    %rax,%rdx
  803ee8:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803eef:	00 00 00 
  803ef2:	48 c1 e2 04          	shl    $0x4,%rdx
  803ef6:	48 01 d0             	add    %rdx,%rax
  803ef9:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803efd:	0f b7 c0             	movzwl %ax,%eax
}
  803f00:	c9                   	leaveq 
  803f01:	c3                   	retq   
