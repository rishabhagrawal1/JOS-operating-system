
obj/user/writemotd.debug:     file format elf64-x86-64


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
  80003c:	e8 36 03 00 00       	callq  800377 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80004e:	89 bd ec fd ff ff    	mov    %edi,-0x214(%rbp)
  800054:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int rfd, wfd;
	char buf[512];
	int n, r;

	if ((rfd = open("/newmotd", O_RDONLY)) < 0)
  80005b:	be 00 00 00 00       	mov    $0x0,%esi
  800060:	48 bf 80 41 80 00 00 	movabs $0x804180,%rdi
  800067:	00 00 00 
  80006a:	48 b8 67 28 80 00 00 	movabs $0x802867,%rax
  800071:	00 00 00 
  800074:	ff d0                	callq  *%rax
  800076:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800079:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80007d:	79 30                	jns    8000af <umain+0x6c>
		panic("open /newmotd: %e", rfd);
  80007f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800082:	89 c1                	mov    %eax,%ecx
  800084:	48 ba 89 41 80 00 00 	movabs $0x804189,%rdx
  80008b:	00 00 00 
  80008e:	be 0b 00 00 00       	mov    $0xb,%esi
  800093:	48 bf 9b 41 80 00 00 	movabs $0x80419b,%rdi
  80009a:	00 00 00 
  80009d:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a2:	49 b8 25 04 80 00 00 	movabs $0x800425,%r8
  8000a9:	00 00 00 
  8000ac:	41 ff d0             	callq  *%r8
	if ((wfd = open("/motd", O_RDWR)) < 0)
  8000af:	be 02 00 00 00       	mov    $0x2,%esi
  8000b4:	48 bf ac 41 80 00 00 	movabs $0x8041ac,%rdi
  8000bb:	00 00 00 
  8000be:	48 b8 67 28 80 00 00 	movabs $0x802867,%rax
  8000c5:	00 00 00 
  8000c8:	ff d0                	callq  *%rax
  8000ca:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000cd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000d1:	79 30                	jns    800103 <umain+0xc0>
		panic("open /motd: %e", wfd);
  8000d3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d6:	89 c1                	mov    %eax,%ecx
  8000d8:	48 ba b2 41 80 00 00 	movabs $0x8041b2,%rdx
  8000df:	00 00 00 
  8000e2:	be 0d 00 00 00       	mov    $0xd,%esi
  8000e7:	48 bf 9b 41 80 00 00 	movabs $0x80419b,%rdi
  8000ee:	00 00 00 
  8000f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f6:	49 b8 25 04 80 00 00 	movabs $0x800425,%r8
  8000fd:	00 00 00 
  800100:	41 ff d0             	callq  *%r8
	cprintf("file descriptors %d %d\n", rfd, wfd);
  800103:	8b 55 f8             	mov    -0x8(%rbp),%edx
  800106:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800109:	89 c6                	mov    %eax,%esi
  80010b:	48 bf c1 41 80 00 00 	movabs $0x8041c1,%rdi
  800112:	00 00 00 
  800115:	b8 00 00 00 00       	mov    $0x0,%eax
  80011a:	48 b9 5e 06 80 00 00 	movabs $0x80065e,%rcx
  800121:	00 00 00 
  800124:	ff d1                	callq  *%rcx
	if (rfd == wfd)
  800126:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800129:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  80012c:	75 2a                	jne    800158 <umain+0x115>
		panic("open /newmotd and /motd give same file descriptor");
  80012e:	48 ba e0 41 80 00 00 	movabs $0x8041e0,%rdx
  800135:	00 00 00 
  800138:	be 10 00 00 00       	mov    $0x10,%esi
  80013d:	48 bf 9b 41 80 00 00 	movabs $0x80419b,%rdi
  800144:	00 00 00 
  800147:	b8 00 00 00 00       	mov    $0x0,%eax
  80014c:	48 b9 25 04 80 00 00 	movabs $0x800425,%rcx
  800153:	00 00 00 
  800156:	ff d1                	callq  *%rcx

	cprintf("OLD MOTD\n===\n");
  800158:	48 bf 12 42 80 00 00 	movabs $0x804212,%rdi
  80015f:	00 00 00 
  800162:	b8 00 00 00 00       	mov    $0x0,%eax
  800167:	48 ba 5e 06 80 00 00 	movabs $0x80065e,%rdx
  80016e:	00 00 00 
  800171:	ff d2                	callq  *%rdx
	while ((n = read(wfd, buf, sizeof buf-1)) > 0)
  800173:	eb 1f                	jmp    800194 <umain+0x151>
		sys_cputs(buf, n);
  800175:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800178:	48 63 d0             	movslq %eax,%rdx
  80017b:	48 8d 85 f0 fd ff ff 	lea    -0x210(%rbp),%rax
  800182:	48 89 d6             	mov    %rdx,%rsi
  800185:	48 89 c7             	mov    %rax,%rdi
  800188:	48 b8 fa 19 80 00 00 	movabs $0x8019fa,%rax
  80018f:	00 00 00 
  800192:	ff d0                	callq  *%rax
	cprintf("file descriptors %d %d\n", rfd, wfd);
	if (rfd == wfd)
		panic("open /newmotd and /motd give same file descriptor");

	cprintf("OLD MOTD\n===\n");
	while ((n = read(wfd, buf, sizeof buf-1)) > 0)
  800194:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80019b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80019e:	ba ff 01 00 00       	mov    $0x1ff,%edx
  8001a3:	48 89 ce             	mov    %rcx,%rsi
  8001a6:	89 c7                	mov    %eax,%edi
  8001a8:	48 b8 91 23 80 00 00 	movabs $0x802391,%rax
  8001af:	00 00 00 
  8001b2:	ff d0                	callq  *%rax
  8001b4:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8001b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8001bb:	7f b8                	jg     800175 <umain+0x132>
		sys_cputs(buf, n);
	cprintf("===\n");
  8001bd:	48 bf 20 42 80 00 00 	movabs $0x804220,%rdi
  8001c4:	00 00 00 
  8001c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8001cc:	48 ba 5e 06 80 00 00 	movabs $0x80065e,%rdx
  8001d3:	00 00 00 
  8001d6:	ff d2                	callq  *%rdx
	seek(wfd, 0);
  8001d8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001db:	be 00 00 00 00       	mov    $0x0,%esi
  8001e0:	89 c7                	mov    %eax,%edi
  8001e2:	48 b8 af 25 80 00 00 	movabs $0x8025af,%rax
  8001e9:	00 00 00 
  8001ec:	ff d0                	callq  *%rax

	if ((r = ftruncate(wfd, 0)) < 0)
  8001ee:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001f1:	be 00 00 00 00       	mov    $0x0,%esi
  8001f6:	89 c7                	mov    %eax,%edi
  8001f8:	48 b8 f4 25 80 00 00 	movabs $0x8025f4,%rax
  8001ff:	00 00 00 
  800202:	ff d0                	callq  *%rax
  800204:	89 45 f0             	mov    %eax,-0x10(%rbp)
  800207:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80020b:	79 30                	jns    80023d <umain+0x1fa>
		panic("truncate /motd: %e", r);
  80020d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800210:	89 c1                	mov    %eax,%ecx
  800212:	48 ba 25 42 80 00 00 	movabs $0x804225,%rdx
  800219:	00 00 00 
  80021c:	be 19 00 00 00       	mov    $0x19,%esi
  800221:	48 bf 9b 41 80 00 00 	movabs $0x80419b,%rdi
  800228:	00 00 00 
  80022b:	b8 00 00 00 00       	mov    $0x0,%eax
  800230:	49 b8 25 04 80 00 00 	movabs $0x800425,%r8
  800237:	00 00 00 
  80023a:	41 ff d0             	callq  *%r8

	cprintf("NEW MOTD\n===\n");
  80023d:	48 bf 38 42 80 00 00 	movabs $0x804238,%rdi
  800244:	00 00 00 
  800247:	b8 00 00 00 00       	mov    $0x0,%eax
  80024c:	48 ba 5e 06 80 00 00 	movabs $0x80065e,%rdx
  800253:	00 00 00 
  800256:	ff d2                	callq  *%rdx
	while ((n = read(rfd, buf, sizeof buf-1)) > 0) {
  800258:	eb 7b                	jmp    8002d5 <umain+0x292>
		sys_cputs(buf, n);
  80025a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80025d:	48 63 d0             	movslq %eax,%rdx
  800260:	48 8d 85 f0 fd ff ff 	lea    -0x210(%rbp),%rax
  800267:	48 89 d6             	mov    %rdx,%rsi
  80026a:	48 89 c7             	mov    %rax,%rdi
  80026d:	48 b8 fa 19 80 00 00 	movabs $0x8019fa,%rax
  800274:	00 00 00 
  800277:	ff d0                	callq  *%rax
		if ((r = write(wfd, buf, n)) != n)
  800279:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80027c:	48 63 d0             	movslq %eax,%rdx
  80027f:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  800286:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800289:	48 89 ce             	mov    %rcx,%rsi
  80028c:	89 c7                	mov    %eax,%edi
  80028e:	48 b8 db 24 80 00 00 	movabs $0x8024db,%rax
  800295:	00 00 00 
  800298:	ff d0                	callq  *%rax
  80029a:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80029d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002a0:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8002a3:	74 30                	je     8002d5 <umain+0x292>
			panic("write /motd: %e", r);
  8002a5:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002a8:	89 c1                	mov    %eax,%ecx
  8002aa:	48 ba 46 42 80 00 00 	movabs $0x804246,%rdx
  8002b1:	00 00 00 
  8002b4:	be 1f 00 00 00       	mov    $0x1f,%esi
  8002b9:	48 bf 9b 41 80 00 00 	movabs $0x80419b,%rdi
  8002c0:	00 00 00 
  8002c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c8:	49 b8 25 04 80 00 00 	movabs $0x800425,%r8
  8002cf:	00 00 00 
  8002d2:	41 ff d0             	callq  *%r8

	if ((r = ftruncate(wfd, 0)) < 0)
		panic("truncate /motd: %e", r);

	cprintf("NEW MOTD\n===\n");
	while ((n = read(rfd, buf, sizeof buf-1)) > 0) {
  8002d5:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8002dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002df:	ba ff 01 00 00       	mov    $0x1ff,%edx
  8002e4:	48 89 ce             	mov    %rcx,%rsi
  8002e7:	89 c7                	mov    %eax,%edi
  8002e9:	48 b8 91 23 80 00 00 	movabs $0x802391,%rax
  8002f0:	00 00 00 
  8002f3:	ff d0                	callq  *%rax
  8002f5:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8002f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8002fc:	0f 8f 58 ff ff ff    	jg     80025a <umain+0x217>
		sys_cputs(buf, n);
		if ((r = write(wfd, buf, n)) != n)
			panic("write /motd: %e", r);
	}
	cprintf("===\n");
  800302:	48 bf 20 42 80 00 00 	movabs $0x804220,%rdi
  800309:	00 00 00 
  80030c:	b8 00 00 00 00       	mov    $0x0,%eax
  800311:	48 ba 5e 06 80 00 00 	movabs $0x80065e,%rdx
  800318:	00 00 00 
  80031b:	ff d2                	callq  *%rdx

	if (n < 0)
  80031d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800321:	79 30                	jns    800353 <umain+0x310>
		panic("read /newmotd: %e", n);
  800323:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800326:	89 c1                	mov    %eax,%ecx
  800328:	48 ba 56 42 80 00 00 	movabs $0x804256,%rdx
  80032f:	00 00 00 
  800332:	be 24 00 00 00       	mov    $0x24,%esi
  800337:	48 bf 9b 41 80 00 00 	movabs $0x80419b,%rdi
  80033e:	00 00 00 
  800341:	b8 00 00 00 00       	mov    $0x0,%eax
  800346:	49 b8 25 04 80 00 00 	movabs $0x800425,%r8
  80034d:	00 00 00 
  800350:	41 ff d0             	callq  *%r8

	close(rfd);
  800353:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800356:	89 c7                	mov    %eax,%edi
  800358:	48 b8 6f 21 80 00 00 	movabs $0x80216f,%rax
  80035f:	00 00 00 
  800362:	ff d0                	callq  *%rax
	close(wfd);
  800364:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800367:	89 c7                	mov    %eax,%edi
  800369:	48 b8 6f 21 80 00 00 	movabs $0x80216f,%rax
  800370:	00 00 00 
  800373:	ff d0                	callq  *%rax
}
  800375:	c9                   	leaveq 
  800376:	c3                   	retq   

0000000000800377 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800377:	55                   	push   %rbp
  800378:	48 89 e5             	mov    %rsp,%rbp
  80037b:	48 83 ec 10          	sub    $0x10,%rsp
  80037f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800382:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800386:	48 b8 c6 1a 80 00 00 	movabs $0x801ac6,%rax
  80038d:	00 00 00 
  800390:	ff d0                	callq  *%rax
  800392:	25 ff 03 00 00       	and    $0x3ff,%eax
  800397:	48 63 d0             	movslq %eax,%rdx
  80039a:	48 89 d0             	mov    %rdx,%rax
  80039d:	48 c1 e0 03          	shl    $0x3,%rax
  8003a1:	48 01 d0             	add    %rdx,%rax
  8003a4:	48 c1 e0 05          	shl    $0x5,%rax
  8003a8:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8003af:	00 00 00 
  8003b2:	48 01 c2             	add    %rax,%rdx
  8003b5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8003bc:	00 00 00 
  8003bf:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8003c6:	7e 14                	jle    8003dc <libmain+0x65>
		binaryname = argv[0];
  8003c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003cc:	48 8b 10             	mov    (%rax),%rdx
  8003cf:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8003d6:	00 00 00 
  8003d9:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8003dc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003e3:	48 89 d6             	mov    %rdx,%rsi
  8003e6:	89 c7                	mov    %eax,%edi
  8003e8:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8003ef:	00 00 00 
  8003f2:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8003f4:	48 b8 02 04 80 00 00 	movabs $0x800402,%rax
  8003fb:	00 00 00 
  8003fe:	ff d0                	callq  *%rax
}
  800400:	c9                   	leaveq 
  800401:	c3                   	retq   

0000000000800402 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800402:	55                   	push   %rbp
  800403:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800406:	48 b8 ba 21 80 00 00 	movabs $0x8021ba,%rax
  80040d:	00 00 00 
  800410:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800412:	bf 00 00 00 00       	mov    $0x0,%edi
  800417:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  80041e:	00 00 00 
  800421:	ff d0                	callq  *%rax

}
  800423:	5d                   	pop    %rbp
  800424:	c3                   	retq   

0000000000800425 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800425:	55                   	push   %rbp
  800426:	48 89 e5             	mov    %rsp,%rbp
  800429:	53                   	push   %rbx
  80042a:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800431:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800438:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80043e:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800445:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80044c:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800453:	84 c0                	test   %al,%al
  800455:	74 23                	je     80047a <_panic+0x55>
  800457:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80045e:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800462:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800466:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80046a:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80046e:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800472:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800476:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80047a:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800481:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800488:	00 00 00 
  80048b:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800492:	00 00 00 
  800495:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800499:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8004a0:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8004a7:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8004ae:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8004b5:	00 00 00 
  8004b8:	48 8b 18             	mov    (%rax),%rbx
  8004bb:	48 b8 c6 1a 80 00 00 	movabs $0x801ac6,%rax
  8004c2:	00 00 00 
  8004c5:	ff d0                	callq  *%rax
  8004c7:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8004cd:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8004d4:	41 89 c8             	mov    %ecx,%r8d
  8004d7:	48 89 d1             	mov    %rdx,%rcx
  8004da:	48 89 da             	mov    %rbx,%rdx
  8004dd:	89 c6                	mov    %eax,%esi
  8004df:	48 bf 78 42 80 00 00 	movabs $0x804278,%rdi
  8004e6:	00 00 00 
  8004e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ee:	49 b9 5e 06 80 00 00 	movabs $0x80065e,%r9
  8004f5:	00 00 00 
  8004f8:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8004fb:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800502:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800509:	48 89 d6             	mov    %rdx,%rsi
  80050c:	48 89 c7             	mov    %rax,%rdi
  80050f:	48 b8 b2 05 80 00 00 	movabs $0x8005b2,%rax
  800516:	00 00 00 
  800519:	ff d0                	callq  *%rax
	cprintf("\n");
  80051b:	48 bf 9b 42 80 00 00 	movabs $0x80429b,%rdi
  800522:	00 00 00 
  800525:	b8 00 00 00 00       	mov    $0x0,%eax
  80052a:	48 ba 5e 06 80 00 00 	movabs $0x80065e,%rdx
  800531:	00 00 00 
  800534:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800536:	cc                   	int3   
  800537:	eb fd                	jmp    800536 <_panic+0x111>

0000000000800539 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800539:	55                   	push   %rbp
  80053a:	48 89 e5             	mov    %rsp,%rbp
  80053d:	48 83 ec 10          	sub    $0x10,%rsp
  800541:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800544:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800548:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80054c:	8b 00                	mov    (%rax),%eax
  80054e:	8d 48 01             	lea    0x1(%rax),%ecx
  800551:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800555:	89 0a                	mov    %ecx,(%rdx)
  800557:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80055a:	89 d1                	mov    %edx,%ecx
  80055c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800560:	48 98                	cltq   
  800562:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800566:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80056a:	8b 00                	mov    (%rax),%eax
  80056c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800571:	75 2c                	jne    80059f <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800573:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800577:	8b 00                	mov    (%rax),%eax
  800579:	48 98                	cltq   
  80057b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80057f:	48 83 c2 08          	add    $0x8,%rdx
  800583:	48 89 c6             	mov    %rax,%rsi
  800586:	48 89 d7             	mov    %rdx,%rdi
  800589:	48 b8 fa 19 80 00 00 	movabs $0x8019fa,%rax
  800590:	00 00 00 
  800593:	ff d0                	callq  *%rax
        b->idx = 0;
  800595:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800599:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80059f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005a3:	8b 40 04             	mov    0x4(%rax),%eax
  8005a6:	8d 50 01             	lea    0x1(%rax),%edx
  8005a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005ad:	89 50 04             	mov    %edx,0x4(%rax)
}
  8005b0:	c9                   	leaveq 
  8005b1:	c3                   	retq   

00000000008005b2 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8005b2:	55                   	push   %rbp
  8005b3:	48 89 e5             	mov    %rsp,%rbp
  8005b6:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8005bd:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8005c4:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8005cb:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8005d2:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8005d9:	48 8b 0a             	mov    (%rdx),%rcx
  8005dc:	48 89 08             	mov    %rcx,(%rax)
  8005df:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005e3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005e7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005eb:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8005ef:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8005f6:	00 00 00 
    b.cnt = 0;
  8005f9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800600:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800603:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80060a:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800611:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800618:	48 89 c6             	mov    %rax,%rsi
  80061b:	48 bf 39 05 80 00 00 	movabs $0x800539,%rdi
  800622:	00 00 00 
  800625:	48 b8 11 0a 80 00 00 	movabs $0x800a11,%rax
  80062c:	00 00 00 
  80062f:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800631:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800637:	48 98                	cltq   
  800639:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800640:	48 83 c2 08          	add    $0x8,%rdx
  800644:	48 89 c6             	mov    %rax,%rsi
  800647:	48 89 d7             	mov    %rdx,%rdi
  80064a:	48 b8 fa 19 80 00 00 	movabs $0x8019fa,%rax
  800651:	00 00 00 
  800654:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800656:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80065c:	c9                   	leaveq 
  80065d:	c3                   	retq   

000000000080065e <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80065e:	55                   	push   %rbp
  80065f:	48 89 e5             	mov    %rsp,%rbp
  800662:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800669:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800670:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800677:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80067e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800685:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80068c:	84 c0                	test   %al,%al
  80068e:	74 20                	je     8006b0 <cprintf+0x52>
  800690:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800694:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800698:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80069c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8006a0:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8006a4:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8006a8:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8006ac:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8006b0:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8006b7:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8006be:	00 00 00 
  8006c1:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8006c8:	00 00 00 
  8006cb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8006cf:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8006d6:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8006dd:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8006e4:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8006eb:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8006f2:	48 8b 0a             	mov    (%rdx),%rcx
  8006f5:	48 89 08             	mov    %rcx,(%rax)
  8006f8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006fc:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800700:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800704:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800708:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80070f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800716:	48 89 d6             	mov    %rdx,%rsi
  800719:	48 89 c7             	mov    %rax,%rdi
  80071c:	48 b8 b2 05 80 00 00 	movabs $0x8005b2,%rax
  800723:	00 00 00 
  800726:	ff d0                	callq  *%rax
  800728:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80072e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800734:	c9                   	leaveq 
  800735:	c3                   	retq   

0000000000800736 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800736:	55                   	push   %rbp
  800737:	48 89 e5             	mov    %rsp,%rbp
  80073a:	53                   	push   %rbx
  80073b:	48 83 ec 38          	sub    $0x38,%rsp
  80073f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800743:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800747:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80074b:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80074e:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800752:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800756:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800759:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80075d:	77 3b                	ja     80079a <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80075f:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800762:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800766:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800769:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80076d:	ba 00 00 00 00       	mov    $0x0,%edx
  800772:	48 f7 f3             	div    %rbx
  800775:	48 89 c2             	mov    %rax,%rdx
  800778:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80077b:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80077e:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800782:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800786:	41 89 f9             	mov    %edi,%r9d
  800789:	48 89 c7             	mov    %rax,%rdi
  80078c:	48 b8 36 07 80 00 00 	movabs $0x800736,%rax
  800793:	00 00 00 
  800796:	ff d0                	callq  *%rax
  800798:	eb 1e                	jmp    8007b8 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80079a:	eb 12                	jmp    8007ae <printnum+0x78>
			putch(padc, putdat);
  80079c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8007a0:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8007a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a7:	48 89 ce             	mov    %rcx,%rsi
  8007aa:	89 d7                	mov    %edx,%edi
  8007ac:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007ae:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8007b2:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8007b6:	7f e4                	jg     80079c <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007b8:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8007bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c4:	48 f7 f1             	div    %rcx
  8007c7:	48 89 d0             	mov    %rdx,%rax
  8007ca:	48 ba 90 44 80 00 00 	movabs $0x804490,%rdx
  8007d1:	00 00 00 
  8007d4:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8007d8:	0f be d0             	movsbl %al,%edx
  8007db:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8007df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e3:	48 89 ce             	mov    %rcx,%rsi
  8007e6:	89 d7                	mov    %edx,%edi
  8007e8:	ff d0                	callq  *%rax
}
  8007ea:	48 83 c4 38          	add    $0x38,%rsp
  8007ee:	5b                   	pop    %rbx
  8007ef:	5d                   	pop    %rbp
  8007f0:	c3                   	retq   

00000000008007f1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007f1:	55                   	push   %rbp
  8007f2:	48 89 e5             	mov    %rsp,%rbp
  8007f5:	48 83 ec 1c          	sub    $0x1c,%rsp
  8007f9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007fd:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800800:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800804:	7e 52                	jle    800858 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800806:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80080a:	8b 00                	mov    (%rax),%eax
  80080c:	83 f8 30             	cmp    $0x30,%eax
  80080f:	73 24                	jae    800835 <getuint+0x44>
  800811:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800815:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800819:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081d:	8b 00                	mov    (%rax),%eax
  80081f:	89 c0                	mov    %eax,%eax
  800821:	48 01 d0             	add    %rdx,%rax
  800824:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800828:	8b 12                	mov    (%rdx),%edx
  80082a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80082d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800831:	89 0a                	mov    %ecx,(%rdx)
  800833:	eb 17                	jmp    80084c <getuint+0x5b>
  800835:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800839:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80083d:	48 89 d0             	mov    %rdx,%rax
  800840:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800844:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800848:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80084c:	48 8b 00             	mov    (%rax),%rax
  80084f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800853:	e9 a3 00 00 00       	jmpq   8008fb <getuint+0x10a>
	else if (lflag)
  800858:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80085c:	74 4f                	je     8008ad <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80085e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800862:	8b 00                	mov    (%rax),%eax
  800864:	83 f8 30             	cmp    $0x30,%eax
  800867:	73 24                	jae    80088d <getuint+0x9c>
  800869:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80086d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800871:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800875:	8b 00                	mov    (%rax),%eax
  800877:	89 c0                	mov    %eax,%eax
  800879:	48 01 d0             	add    %rdx,%rax
  80087c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800880:	8b 12                	mov    (%rdx),%edx
  800882:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800885:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800889:	89 0a                	mov    %ecx,(%rdx)
  80088b:	eb 17                	jmp    8008a4 <getuint+0xb3>
  80088d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800891:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800895:	48 89 d0             	mov    %rdx,%rax
  800898:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80089c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008a0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008a4:	48 8b 00             	mov    (%rax),%rax
  8008a7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008ab:	eb 4e                	jmp    8008fb <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8008ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b1:	8b 00                	mov    (%rax),%eax
  8008b3:	83 f8 30             	cmp    $0x30,%eax
  8008b6:	73 24                	jae    8008dc <getuint+0xeb>
  8008b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008bc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c4:	8b 00                	mov    (%rax),%eax
  8008c6:	89 c0                	mov    %eax,%eax
  8008c8:	48 01 d0             	add    %rdx,%rax
  8008cb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008cf:	8b 12                	mov    (%rdx),%edx
  8008d1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008d4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008d8:	89 0a                	mov    %ecx,(%rdx)
  8008da:	eb 17                	jmp    8008f3 <getuint+0x102>
  8008dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008e4:	48 89 d0             	mov    %rdx,%rax
  8008e7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008eb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ef:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008f3:	8b 00                	mov    (%rax),%eax
  8008f5:	89 c0                	mov    %eax,%eax
  8008f7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008ff:	c9                   	leaveq 
  800900:	c3                   	retq   

0000000000800901 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800901:	55                   	push   %rbp
  800902:	48 89 e5             	mov    %rsp,%rbp
  800905:	48 83 ec 1c          	sub    $0x1c,%rsp
  800909:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80090d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800910:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800914:	7e 52                	jle    800968 <getint+0x67>
		x=va_arg(*ap, long long);
  800916:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80091a:	8b 00                	mov    (%rax),%eax
  80091c:	83 f8 30             	cmp    $0x30,%eax
  80091f:	73 24                	jae    800945 <getint+0x44>
  800921:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800925:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800929:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80092d:	8b 00                	mov    (%rax),%eax
  80092f:	89 c0                	mov    %eax,%eax
  800931:	48 01 d0             	add    %rdx,%rax
  800934:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800938:	8b 12                	mov    (%rdx),%edx
  80093a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80093d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800941:	89 0a                	mov    %ecx,(%rdx)
  800943:	eb 17                	jmp    80095c <getint+0x5b>
  800945:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800949:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80094d:	48 89 d0             	mov    %rdx,%rax
  800950:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800954:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800958:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80095c:	48 8b 00             	mov    (%rax),%rax
  80095f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800963:	e9 a3 00 00 00       	jmpq   800a0b <getint+0x10a>
	else if (lflag)
  800968:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80096c:	74 4f                	je     8009bd <getint+0xbc>
		x=va_arg(*ap, long);
  80096e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800972:	8b 00                	mov    (%rax),%eax
  800974:	83 f8 30             	cmp    $0x30,%eax
  800977:	73 24                	jae    80099d <getint+0x9c>
  800979:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80097d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800981:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800985:	8b 00                	mov    (%rax),%eax
  800987:	89 c0                	mov    %eax,%eax
  800989:	48 01 d0             	add    %rdx,%rax
  80098c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800990:	8b 12                	mov    (%rdx),%edx
  800992:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800995:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800999:	89 0a                	mov    %ecx,(%rdx)
  80099b:	eb 17                	jmp    8009b4 <getint+0xb3>
  80099d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a1:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009a5:	48 89 d0             	mov    %rdx,%rax
  8009a8:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009ac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009b4:	48 8b 00             	mov    (%rax),%rax
  8009b7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009bb:	eb 4e                	jmp    800a0b <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8009bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c1:	8b 00                	mov    (%rax),%eax
  8009c3:	83 f8 30             	cmp    $0x30,%eax
  8009c6:	73 24                	jae    8009ec <getint+0xeb>
  8009c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009cc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d4:	8b 00                	mov    (%rax),%eax
  8009d6:	89 c0                	mov    %eax,%eax
  8009d8:	48 01 d0             	add    %rdx,%rax
  8009db:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009df:	8b 12                	mov    (%rdx),%edx
  8009e1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009e4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009e8:	89 0a                	mov    %ecx,(%rdx)
  8009ea:	eb 17                	jmp    800a03 <getint+0x102>
  8009ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009f0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009f4:	48 89 d0             	mov    %rdx,%rax
  8009f7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009fb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ff:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a03:	8b 00                	mov    (%rax),%eax
  800a05:	48 98                	cltq   
  800a07:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800a0b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800a0f:	c9                   	leaveq 
  800a10:	c3                   	retq   

0000000000800a11 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a11:	55                   	push   %rbp
  800a12:	48 89 e5             	mov    %rsp,%rbp
  800a15:	41 54                	push   %r12
  800a17:	53                   	push   %rbx
  800a18:	48 83 ec 60          	sub    $0x60,%rsp
  800a1c:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800a20:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800a24:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a28:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800a2c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a30:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800a34:	48 8b 0a             	mov    (%rdx),%rcx
  800a37:	48 89 08             	mov    %rcx,(%rax)
  800a3a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a3e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a42:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a46:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a4a:	eb 17                	jmp    800a63 <vprintfmt+0x52>
			if (ch == '\0')
  800a4c:	85 db                	test   %ebx,%ebx
  800a4e:	0f 84 cc 04 00 00    	je     800f20 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800a54:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a58:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a5c:	48 89 d6             	mov    %rdx,%rsi
  800a5f:	89 df                	mov    %ebx,%edi
  800a61:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a63:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a67:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a6b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a6f:	0f b6 00             	movzbl (%rax),%eax
  800a72:	0f b6 d8             	movzbl %al,%ebx
  800a75:	83 fb 25             	cmp    $0x25,%ebx
  800a78:	75 d2                	jne    800a4c <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a7a:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800a7e:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800a85:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800a8c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800a93:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a9a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a9e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800aa2:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800aa6:	0f b6 00             	movzbl (%rax),%eax
  800aa9:	0f b6 d8             	movzbl %al,%ebx
  800aac:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800aaf:	83 f8 55             	cmp    $0x55,%eax
  800ab2:	0f 87 34 04 00 00    	ja     800eec <vprintfmt+0x4db>
  800ab8:	89 c0                	mov    %eax,%eax
  800aba:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800ac1:	00 
  800ac2:	48 b8 b8 44 80 00 00 	movabs $0x8044b8,%rax
  800ac9:	00 00 00 
  800acc:	48 01 d0             	add    %rdx,%rax
  800acf:	48 8b 00             	mov    (%rax),%rax
  800ad2:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800ad4:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800ad8:	eb c0                	jmp    800a9a <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ada:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800ade:	eb ba                	jmp    800a9a <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ae0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800ae7:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800aea:	89 d0                	mov    %edx,%eax
  800aec:	c1 e0 02             	shl    $0x2,%eax
  800aef:	01 d0                	add    %edx,%eax
  800af1:	01 c0                	add    %eax,%eax
  800af3:	01 d8                	add    %ebx,%eax
  800af5:	83 e8 30             	sub    $0x30,%eax
  800af8:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800afb:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800aff:	0f b6 00             	movzbl (%rax),%eax
  800b02:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800b05:	83 fb 2f             	cmp    $0x2f,%ebx
  800b08:	7e 0c                	jle    800b16 <vprintfmt+0x105>
  800b0a:	83 fb 39             	cmp    $0x39,%ebx
  800b0d:	7f 07                	jg     800b16 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b0f:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800b14:	eb d1                	jmp    800ae7 <vprintfmt+0xd6>
			goto process_precision;
  800b16:	eb 58                	jmp    800b70 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800b18:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b1b:	83 f8 30             	cmp    $0x30,%eax
  800b1e:	73 17                	jae    800b37 <vprintfmt+0x126>
  800b20:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b24:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b27:	89 c0                	mov    %eax,%eax
  800b29:	48 01 d0             	add    %rdx,%rax
  800b2c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b2f:	83 c2 08             	add    $0x8,%edx
  800b32:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b35:	eb 0f                	jmp    800b46 <vprintfmt+0x135>
  800b37:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b3b:	48 89 d0             	mov    %rdx,%rax
  800b3e:	48 83 c2 08          	add    $0x8,%rdx
  800b42:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b46:	8b 00                	mov    (%rax),%eax
  800b48:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800b4b:	eb 23                	jmp    800b70 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800b4d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b51:	79 0c                	jns    800b5f <vprintfmt+0x14e>
				width = 0;
  800b53:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800b5a:	e9 3b ff ff ff       	jmpq   800a9a <vprintfmt+0x89>
  800b5f:	e9 36 ff ff ff       	jmpq   800a9a <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800b64:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800b6b:	e9 2a ff ff ff       	jmpq   800a9a <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800b70:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b74:	79 12                	jns    800b88 <vprintfmt+0x177>
				width = precision, precision = -1;
  800b76:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b79:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800b7c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800b83:	e9 12 ff ff ff       	jmpq   800a9a <vprintfmt+0x89>
  800b88:	e9 0d ff ff ff       	jmpq   800a9a <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b8d:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800b91:	e9 04 ff ff ff       	jmpq   800a9a <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800b96:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b99:	83 f8 30             	cmp    $0x30,%eax
  800b9c:	73 17                	jae    800bb5 <vprintfmt+0x1a4>
  800b9e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ba2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ba5:	89 c0                	mov    %eax,%eax
  800ba7:	48 01 d0             	add    %rdx,%rax
  800baa:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bad:	83 c2 08             	add    $0x8,%edx
  800bb0:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bb3:	eb 0f                	jmp    800bc4 <vprintfmt+0x1b3>
  800bb5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bb9:	48 89 d0             	mov    %rdx,%rax
  800bbc:	48 83 c2 08          	add    $0x8,%rdx
  800bc0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bc4:	8b 10                	mov    (%rax),%edx
  800bc6:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800bca:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bce:	48 89 ce             	mov    %rcx,%rsi
  800bd1:	89 d7                	mov    %edx,%edi
  800bd3:	ff d0                	callq  *%rax
			break;
  800bd5:	e9 40 03 00 00       	jmpq   800f1a <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800bda:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bdd:	83 f8 30             	cmp    $0x30,%eax
  800be0:	73 17                	jae    800bf9 <vprintfmt+0x1e8>
  800be2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800be6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800be9:	89 c0                	mov    %eax,%eax
  800beb:	48 01 d0             	add    %rdx,%rax
  800bee:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bf1:	83 c2 08             	add    $0x8,%edx
  800bf4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bf7:	eb 0f                	jmp    800c08 <vprintfmt+0x1f7>
  800bf9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bfd:	48 89 d0             	mov    %rdx,%rax
  800c00:	48 83 c2 08          	add    $0x8,%rdx
  800c04:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c08:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800c0a:	85 db                	test   %ebx,%ebx
  800c0c:	79 02                	jns    800c10 <vprintfmt+0x1ff>
				err = -err;
  800c0e:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800c10:	83 fb 15             	cmp    $0x15,%ebx
  800c13:	7f 16                	jg     800c2b <vprintfmt+0x21a>
  800c15:	48 b8 e0 43 80 00 00 	movabs $0x8043e0,%rax
  800c1c:	00 00 00 
  800c1f:	48 63 d3             	movslq %ebx,%rdx
  800c22:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800c26:	4d 85 e4             	test   %r12,%r12
  800c29:	75 2e                	jne    800c59 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800c2b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c2f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c33:	89 d9                	mov    %ebx,%ecx
  800c35:	48 ba a1 44 80 00 00 	movabs $0x8044a1,%rdx
  800c3c:	00 00 00 
  800c3f:	48 89 c7             	mov    %rax,%rdi
  800c42:	b8 00 00 00 00       	mov    $0x0,%eax
  800c47:	49 b8 29 0f 80 00 00 	movabs $0x800f29,%r8
  800c4e:	00 00 00 
  800c51:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c54:	e9 c1 02 00 00       	jmpq   800f1a <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c59:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c5d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c61:	4c 89 e1             	mov    %r12,%rcx
  800c64:	48 ba aa 44 80 00 00 	movabs $0x8044aa,%rdx
  800c6b:	00 00 00 
  800c6e:	48 89 c7             	mov    %rax,%rdi
  800c71:	b8 00 00 00 00       	mov    $0x0,%eax
  800c76:	49 b8 29 0f 80 00 00 	movabs $0x800f29,%r8
  800c7d:	00 00 00 
  800c80:	41 ff d0             	callq  *%r8
			break;
  800c83:	e9 92 02 00 00       	jmpq   800f1a <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800c88:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c8b:	83 f8 30             	cmp    $0x30,%eax
  800c8e:	73 17                	jae    800ca7 <vprintfmt+0x296>
  800c90:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c94:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c97:	89 c0                	mov    %eax,%eax
  800c99:	48 01 d0             	add    %rdx,%rax
  800c9c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c9f:	83 c2 08             	add    $0x8,%edx
  800ca2:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ca5:	eb 0f                	jmp    800cb6 <vprintfmt+0x2a5>
  800ca7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cab:	48 89 d0             	mov    %rdx,%rax
  800cae:	48 83 c2 08          	add    $0x8,%rdx
  800cb2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cb6:	4c 8b 20             	mov    (%rax),%r12
  800cb9:	4d 85 e4             	test   %r12,%r12
  800cbc:	75 0a                	jne    800cc8 <vprintfmt+0x2b7>
				p = "(null)";
  800cbe:	49 bc ad 44 80 00 00 	movabs $0x8044ad,%r12
  800cc5:	00 00 00 
			if (width > 0 && padc != '-')
  800cc8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ccc:	7e 3f                	jle    800d0d <vprintfmt+0x2fc>
  800cce:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800cd2:	74 39                	je     800d0d <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800cd4:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800cd7:	48 98                	cltq   
  800cd9:	48 89 c6             	mov    %rax,%rsi
  800cdc:	4c 89 e7             	mov    %r12,%rdi
  800cdf:	48 b8 d5 11 80 00 00 	movabs $0x8011d5,%rax
  800ce6:	00 00 00 
  800ce9:	ff d0                	callq  *%rax
  800ceb:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800cee:	eb 17                	jmp    800d07 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800cf0:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800cf4:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800cf8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cfc:	48 89 ce             	mov    %rcx,%rsi
  800cff:	89 d7                	mov    %edx,%edi
  800d01:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d03:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d07:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d0b:	7f e3                	jg     800cf0 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d0d:	eb 37                	jmp    800d46 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800d0f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800d13:	74 1e                	je     800d33 <vprintfmt+0x322>
  800d15:	83 fb 1f             	cmp    $0x1f,%ebx
  800d18:	7e 05                	jle    800d1f <vprintfmt+0x30e>
  800d1a:	83 fb 7e             	cmp    $0x7e,%ebx
  800d1d:	7e 14                	jle    800d33 <vprintfmt+0x322>
					putch('?', putdat);
  800d1f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d23:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d27:	48 89 d6             	mov    %rdx,%rsi
  800d2a:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800d2f:	ff d0                	callq  *%rax
  800d31:	eb 0f                	jmp    800d42 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800d33:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d37:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d3b:	48 89 d6             	mov    %rdx,%rsi
  800d3e:	89 df                	mov    %ebx,%edi
  800d40:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d42:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d46:	4c 89 e0             	mov    %r12,%rax
  800d49:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800d4d:	0f b6 00             	movzbl (%rax),%eax
  800d50:	0f be d8             	movsbl %al,%ebx
  800d53:	85 db                	test   %ebx,%ebx
  800d55:	74 10                	je     800d67 <vprintfmt+0x356>
  800d57:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d5b:	78 b2                	js     800d0f <vprintfmt+0x2fe>
  800d5d:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800d61:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d65:	79 a8                	jns    800d0f <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d67:	eb 16                	jmp    800d7f <vprintfmt+0x36e>
				putch(' ', putdat);
  800d69:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d6d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d71:	48 89 d6             	mov    %rdx,%rsi
  800d74:	bf 20 00 00 00       	mov    $0x20,%edi
  800d79:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d7b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d7f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d83:	7f e4                	jg     800d69 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800d85:	e9 90 01 00 00       	jmpq   800f1a <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800d8a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d8e:	be 03 00 00 00       	mov    $0x3,%esi
  800d93:	48 89 c7             	mov    %rax,%rdi
  800d96:	48 b8 01 09 80 00 00 	movabs $0x800901,%rax
  800d9d:	00 00 00 
  800da0:	ff d0                	callq  *%rax
  800da2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800da6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800daa:	48 85 c0             	test   %rax,%rax
  800dad:	79 1d                	jns    800dcc <vprintfmt+0x3bb>
				putch('-', putdat);
  800daf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800db3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800db7:	48 89 d6             	mov    %rdx,%rsi
  800dba:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800dbf:	ff d0                	callq  *%rax
				num = -(long long) num;
  800dc1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dc5:	48 f7 d8             	neg    %rax
  800dc8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800dcc:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800dd3:	e9 d5 00 00 00       	jmpq   800ead <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800dd8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ddc:	be 03 00 00 00       	mov    $0x3,%esi
  800de1:	48 89 c7             	mov    %rax,%rdi
  800de4:	48 b8 f1 07 80 00 00 	movabs $0x8007f1,%rax
  800deb:	00 00 00 
  800dee:	ff d0                	callq  *%rax
  800df0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800df4:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800dfb:	e9 ad 00 00 00       	jmpq   800ead <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800e00:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800e03:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e07:	89 d6                	mov    %edx,%esi
  800e09:	48 89 c7             	mov    %rax,%rdi
  800e0c:	48 b8 01 09 80 00 00 	movabs $0x800901,%rax
  800e13:	00 00 00 
  800e16:	ff d0                	callq  *%rax
  800e18:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800e1c:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800e23:	e9 85 00 00 00       	jmpq   800ead <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800e28:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e2c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e30:	48 89 d6             	mov    %rdx,%rsi
  800e33:	bf 30 00 00 00       	mov    $0x30,%edi
  800e38:	ff d0                	callq  *%rax
			putch('x', putdat);
  800e3a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e3e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e42:	48 89 d6             	mov    %rdx,%rsi
  800e45:	bf 78 00 00 00       	mov    $0x78,%edi
  800e4a:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800e4c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e4f:	83 f8 30             	cmp    $0x30,%eax
  800e52:	73 17                	jae    800e6b <vprintfmt+0x45a>
  800e54:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e58:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e5b:	89 c0                	mov    %eax,%eax
  800e5d:	48 01 d0             	add    %rdx,%rax
  800e60:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e63:	83 c2 08             	add    $0x8,%edx
  800e66:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e69:	eb 0f                	jmp    800e7a <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800e6b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e6f:	48 89 d0             	mov    %rdx,%rax
  800e72:	48 83 c2 08          	add    $0x8,%rdx
  800e76:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e7a:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e7d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800e81:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800e88:	eb 23                	jmp    800ead <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800e8a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e8e:	be 03 00 00 00       	mov    $0x3,%esi
  800e93:	48 89 c7             	mov    %rax,%rdi
  800e96:	48 b8 f1 07 80 00 00 	movabs $0x8007f1,%rax
  800e9d:	00 00 00 
  800ea0:	ff d0                	callq  *%rax
  800ea2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800ea6:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ead:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800eb2:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800eb5:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800eb8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ebc:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ec0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ec4:	45 89 c1             	mov    %r8d,%r9d
  800ec7:	41 89 f8             	mov    %edi,%r8d
  800eca:	48 89 c7             	mov    %rax,%rdi
  800ecd:	48 b8 36 07 80 00 00 	movabs $0x800736,%rax
  800ed4:	00 00 00 
  800ed7:	ff d0                	callq  *%rax
			break;
  800ed9:	eb 3f                	jmp    800f1a <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800edb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800edf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ee3:	48 89 d6             	mov    %rdx,%rsi
  800ee6:	89 df                	mov    %ebx,%edi
  800ee8:	ff d0                	callq  *%rax
			break;
  800eea:	eb 2e                	jmp    800f1a <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800eec:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ef0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ef4:	48 89 d6             	mov    %rdx,%rsi
  800ef7:	bf 25 00 00 00       	mov    $0x25,%edi
  800efc:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800efe:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f03:	eb 05                	jmp    800f0a <vprintfmt+0x4f9>
  800f05:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f0a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f0e:	48 83 e8 01          	sub    $0x1,%rax
  800f12:	0f b6 00             	movzbl (%rax),%eax
  800f15:	3c 25                	cmp    $0x25,%al
  800f17:	75 ec                	jne    800f05 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800f19:	90                   	nop
		}
	}
  800f1a:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f1b:	e9 43 fb ff ff       	jmpq   800a63 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800f20:	48 83 c4 60          	add    $0x60,%rsp
  800f24:	5b                   	pop    %rbx
  800f25:	41 5c                	pop    %r12
  800f27:	5d                   	pop    %rbp
  800f28:	c3                   	retq   

0000000000800f29 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f29:	55                   	push   %rbp
  800f2a:	48 89 e5             	mov    %rsp,%rbp
  800f2d:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800f34:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800f3b:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800f42:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f49:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f50:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f57:	84 c0                	test   %al,%al
  800f59:	74 20                	je     800f7b <printfmt+0x52>
  800f5b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f5f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f63:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f67:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f6b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f6f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f73:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f77:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f7b:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800f82:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800f89:	00 00 00 
  800f8c:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800f93:	00 00 00 
  800f96:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f9a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800fa1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fa8:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800faf:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800fb6:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800fbd:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800fc4:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800fcb:	48 89 c7             	mov    %rax,%rdi
  800fce:	48 b8 11 0a 80 00 00 	movabs $0x800a11,%rax
  800fd5:	00 00 00 
  800fd8:	ff d0                	callq  *%rax
	va_end(ap);
}
  800fda:	c9                   	leaveq 
  800fdb:	c3                   	retq   

0000000000800fdc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fdc:	55                   	push   %rbp
  800fdd:	48 89 e5             	mov    %rsp,%rbp
  800fe0:	48 83 ec 10          	sub    $0x10,%rsp
  800fe4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800fe7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800feb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fef:	8b 40 10             	mov    0x10(%rax),%eax
  800ff2:	8d 50 01             	lea    0x1(%rax),%edx
  800ff5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ff9:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800ffc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801000:	48 8b 10             	mov    (%rax),%rdx
  801003:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801007:	48 8b 40 08          	mov    0x8(%rax),%rax
  80100b:	48 39 c2             	cmp    %rax,%rdx
  80100e:	73 17                	jae    801027 <sprintputch+0x4b>
		*b->buf++ = ch;
  801010:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801014:	48 8b 00             	mov    (%rax),%rax
  801017:	48 8d 48 01          	lea    0x1(%rax),%rcx
  80101b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80101f:	48 89 0a             	mov    %rcx,(%rdx)
  801022:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801025:	88 10                	mov    %dl,(%rax)
}
  801027:	c9                   	leaveq 
  801028:	c3                   	retq   

0000000000801029 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801029:	55                   	push   %rbp
  80102a:	48 89 e5             	mov    %rsp,%rbp
  80102d:	48 83 ec 50          	sub    $0x50,%rsp
  801031:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801035:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801038:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80103c:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801040:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801044:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801048:	48 8b 0a             	mov    (%rdx),%rcx
  80104b:	48 89 08             	mov    %rcx,(%rax)
  80104e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801052:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801056:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80105a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80105e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801062:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801066:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801069:	48 98                	cltq   
  80106b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80106f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801073:	48 01 d0             	add    %rdx,%rax
  801076:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80107a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801081:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801086:	74 06                	je     80108e <vsnprintf+0x65>
  801088:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80108c:	7f 07                	jg     801095 <vsnprintf+0x6c>
		return -E_INVAL;
  80108e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801093:	eb 2f                	jmp    8010c4 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801095:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801099:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80109d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8010a1:	48 89 c6             	mov    %rax,%rsi
  8010a4:	48 bf dc 0f 80 00 00 	movabs $0x800fdc,%rdi
  8010ab:	00 00 00 
  8010ae:	48 b8 11 0a 80 00 00 	movabs $0x800a11,%rax
  8010b5:	00 00 00 
  8010b8:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8010ba:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8010be:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8010c1:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8010c4:	c9                   	leaveq 
  8010c5:	c3                   	retq   

00000000008010c6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010c6:	55                   	push   %rbp
  8010c7:	48 89 e5             	mov    %rsp,%rbp
  8010ca:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8010d1:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8010d8:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8010de:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8010e5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8010ec:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8010f3:	84 c0                	test   %al,%al
  8010f5:	74 20                	je     801117 <snprintf+0x51>
  8010f7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8010fb:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8010ff:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801103:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801107:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80110b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80110f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801113:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801117:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80111e:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801125:	00 00 00 
  801128:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80112f:	00 00 00 
  801132:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801136:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80113d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801144:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80114b:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801152:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801159:	48 8b 0a             	mov    (%rdx),%rcx
  80115c:	48 89 08             	mov    %rcx,(%rax)
  80115f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801163:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801167:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80116b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80116f:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801176:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80117d:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801183:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80118a:	48 89 c7             	mov    %rax,%rdi
  80118d:	48 b8 29 10 80 00 00 	movabs $0x801029,%rax
  801194:	00 00 00 
  801197:	ff d0                	callq  *%rax
  801199:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80119f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8011a5:	c9                   	leaveq 
  8011a6:	c3                   	retq   

00000000008011a7 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8011a7:	55                   	push   %rbp
  8011a8:	48 89 e5             	mov    %rsp,%rbp
  8011ab:	48 83 ec 18          	sub    $0x18,%rsp
  8011af:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8011b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011ba:	eb 09                	jmp    8011c5 <strlen+0x1e>
		n++;
  8011bc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8011c0:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c9:	0f b6 00             	movzbl (%rax),%eax
  8011cc:	84 c0                	test   %al,%al
  8011ce:	75 ec                	jne    8011bc <strlen+0x15>
		n++;
	return n;
  8011d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011d3:	c9                   	leaveq 
  8011d4:	c3                   	retq   

00000000008011d5 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8011d5:	55                   	push   %rbp
  8011d6:	48 89 e5             	mov    %rsp,%rbp
  8011d9:	48 83 ec 20          	sub    $0x20,%rsp
  8011dd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011e1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011ec:	eb 0e                	jmp    8011fc <strnlen+0x27>
		n++;
  8011ee:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011f2:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011f7:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8011fc:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801201:	74 0b                	je     80120e <strnlen+0x39>
  801203:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801207:	0f b6 00             	movzbl (%rax),%eax
  80120a:	84 c0                	test   %al,%al
  80120c:	75 e0                	jne    8011ee <strnlen+0x19>
		n++;
	return n;
  80120e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801211:	c9                   	leaveq 
  801212:	c3                   	retq   

0000000000801213 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801213:	55                   	push   %rbp
  801214:	48 89 e5             	mov    %rsp,%rbp
  801217:	48 83 ec 20          	sub    $0x20,%rsp
  80121b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80121f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801223:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801227:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80122b:	90                   	nop
  80122c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801230:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801234:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801238:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80123c:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801240:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801244:	0f b6 12             	movzbl (%rdx),%edx
  801247:	88 10                	mov    %dl,(%rax)
  801249:	0f b6 00             	movzbl (%rax),%eax
  80124c:	84 c0                	test   %al,%al
  80124e:	75 dc                	jne    80122c <strcpy+0x19>
		/* do nothing */;
	return ret;
  801250:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801254:	c9                   	leaveq 
  801255:	c3                   	retq   

0000000000801256 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801256:	55                   	push   %rbp
  801257:	48 89 e5             	mov    %rsp,%rbp
  80125a:	48 83 ec 20          	sub    $0x20,%rsp
  80125e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801262:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801266:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80126a:	48 89 c7             	mov    %rax,%rdi
  80126d:	48 b8 a7 11 80 00 00 	movabs $0x8011a7,%rax
  801274:	00 00 00 
  801277:	ff d0                	callq  *%rax
  801279:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80127c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80127f:	48 63 d0             	movslq %eax,%rdx
  801282:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801286:	48 01 c2             	add    %rax,%rdx
  801289:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80128d:	48 89 c6             	mov    %rax,%rsi
  801290:	48 89 d7             	mov    %rdx,%rdi
  801293:	48 b8 13 12 80 00 00 	movabs $0x801213,%rax
  80129a:	00 00 00 
  80129d:	ff d0                	callq  *%rax
	return dst;
  80129f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8012a3:	c9                   	leaveq 
  8012a4:	c3                   	retq   

00000000008012a5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8012a5:	55                   	push   %rbp
  8012a6:	48 89 e5             	mov    %rsp,%rbp
  8012a9:	48 83 ec 28          	sub    $0x28,%rsp
  8012ad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012b1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012b5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8012b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012bd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8012c1:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8012c8:	00 
  8012c9:	eb 2a                	jmp    8012f5 <strncpy+0x50>
		*dst++ = *src;
  8012cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012cf:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012d3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012d7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012db:	0f b6 12             	movzbl (%rdx),%edx
  8012de:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012e0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012e4:	0f b6 00             	movzbl (%rax),%eax
  8012e7:	84 c0                	test   %al,%al
  8012e9:	74 05                	je     8012f0 <strncpy+0x4b>
			src++;
  8012eb:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012f0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f9:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8012fd:	72 cc                	jb     8012cb <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801303:	c9                   	leaveq 
  801304:	c3                   	retq   

0000000000801305 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801305:	55                   	push   %rbp
  801306:	48 89 e5             	mov    %rsp,%rbp
  801309:	48 83 ec 28          	sub    $0x28,%rsp
  80130d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801311:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801315:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801319:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80131d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801321:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801326:	74 3d                	je     801365 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801328:	eb 1d                	jmp    801347 <strlcpy+0x42>
			*dst++ = *src++;
  80132a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80132e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801332:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801336:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80133a:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80133e:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801342:	0f b6 12             	movzbl (%rdx),%edx
  801345:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801347:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80134c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801351:	74 0b                	je     80135e <strlcpy+0x59>
  801353:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801357:	0f b6 00             	movzbl (%rax),%eax
  80135a:	84 c0                	test   %al,%al
  80135c:	75 cc                	jne    80132a <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80135e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801362:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801365:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801369:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136d:	48 29 c2             	sub    %rax,%rdx
  801370:	48 89 d0             	mov    %rdx,%rax
}
  801373:	c9                   	leaveq 
  801374:	c3                   	retq   

0000000000801375 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801375:	55                   	push   %rbp
  801376:	48 89 e5             	mov    %rsp,%rbp
  801379:	48 83 ec 10          	sub    $0x10,%rsp
  80137d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801381:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801385:	eb 0a                	jmp    801391 <strcmp+0x1c>
		p++, q++;
  801387:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80138c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801391:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801395:	0f b6 00             	movzbl (%rax),%eax
  801398:	84 c0                	test   %al,%al
  80139a:	74 12                	je     8013ae <strcmp+0x39>
  80139c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013a0:	0f b6 10             	movzbl (%rax),%edx
  8013a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013a7:	0f b6 00             	movzbl (%rax),%eax
  8013aa:	38 c2                	cmp    %al,%dl
  8013ac:	74 d9                	je     801387 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b2:	0f b6 00             	movzbl (%rax),%eax
  8013b5:	0f b6 d0             	movzbl %al,%edx
  8013b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013bc:	0f b6 00             	movzbl (%rax),%eax
  8013bf:	0f b6 c0             	movzbl %al,%eax
  8013c2:	29 c2                	sub    %eax,%edx
  8013c4:	89 d0                	mov    %edx,%eax
}
  8013c6:	c9                   	leaveq 
  8013c7:	c3                   	retq   

00000000008013c8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8013c8:	55                   	push   %rbp
  8013c9:	48 89 e5             	mov    %rsp,%rbp
  8013cc:	48 83 ec 18          	sub    $0x18,%rsp
  8013d0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013d4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013d8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8013dc:	eb 0f                	jmp    8013ed <strncmp+0x25>
		n--, p++, q++;
  8013de:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8013e3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013e8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8013ed:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013f2:	74 1d                	je     801411 <strncmp+0x49>
  8013f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f8:	0f b6 00             	movzbl (%rax),%eax
  8013fb:	84 c0                	test   %al,%al
  8013fd:	74 12                	je     801411 <strncmp+0x49>
  8013ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801403:	0f b6 10             	movzbl (%rax),%edx
  801406:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80140a:	0f b6 00             	movzbl (%rax),%eax
  80140d:	38 c2                	cmp    %al,%dl
  80140f:	74 cd                	je     8013de <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801411:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801416:	75 07                	jne    80141f <strncmp+0x57>
		return 0;
  801418:	b8 00 00 00 00       	mov    $0x0,%eax
  80141d:	eb 18                	jmp    801437 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80141f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801423:	0f b6 00             	movzbl (%rax),%eax
  801426:	0f b6 d0             	movzbl %al,%edx
  801429:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80142d:	0f b6 00             	movzbl (%rax),%eax
  801430:	0f b6 c0             	movzbl %al,%eax
  801433:	29 c2                	sub    %eax,%edx
  801435:	89 d0                	mov    %edx,%eax
}
  801437:	c9                   	leaveq 
  801438:	c3                   	retq   

0000000000801439 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801439:	55                   	push   %rbp
  80143a:	48 89 e5             	mov    %rsp,%rbp
  80143d:	48 83 ec 0c          	sub    $0xc,%rsp
  801441:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801445:	89 f0                	mov    %esi,%eax
  801447:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80144a:	eb 17                	jmp    801463 <strchr+0x2a>
		if (*s == c)
  80144c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801450:	0f b6 00             	movzbl (%rax),%eax
  801453:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801456:	75 06                	jne    80145e <strchr+0x25>
			return (char *) s;
  801458:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80145c:	eb 15                	jmp    801473 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80145e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801463:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801467:	0f b6 00             	movzbl (%rax),%eax
  80146a:	84 c0                	test   %al,%al
  80146c:	75 de                	jne    80144c <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80146e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801473:	c9                   	leaveq 
  801474:	c3                   	retq   

0000000000801475 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801475:	55                   	push   %rbp
  801476:	48 89 e5             	mov    %rsp,%rbp
  801479:	48 83 ec 0c          	sub    $0xc,%rsp
  80147d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801481:	89 f0                	mov    %esi,%eax
  801483:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801486:	eb 13                	jmp    80149b <strfind+0x26>
		if (*s == c)
  801488:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80148c:	0f b6 00             	movzbl (%rax),%eax
  80148f:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801492:	75 02                	jne    801496 <strfind+0x21>
			break;
  801494:	eb 10                	jmp    8014a6 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801496:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80149b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80149f:	0f b6 00             	movzbl (%rax),%eax
  8014a2:	84 c0                	test   %al,%al
  8014a4:	75 e2                	jne    801488 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8014a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014aa:	c9                   	leaveq 
  8014ab:	c3                   	retq   

00000000008014ac <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8014ac:	55                   	push   %rbp
  8014ad:	48 89 e5             	mov    %rsp,%rbp
  8014b0:	48 83 ec 18          	sub    $0x18,%rsp
  8014b4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014b8:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8014bb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8014bf:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014c4:	75 06                	jne    8014cc <memset+0x20>
		return v;
  8014c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ca:	eb 69                	jmp    801535 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8014cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014d0:	83 e0 03             	and    $0x3,%eax
  8014d3:	48 85 c0             	test   %rax,%rax
  8014d6:	75 48                	jne    801520 <memset+0x74>
  8014d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014dc:	83 e0 03             	and    $0x3,%eax
  8014df:	48 85 c0             	test   %rax,%rax
  8014e2:	75 3c                	jne    801520 <memset+0x74>
		c &= 0xFF;
  8014e4:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8014eb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014ee:	c1 e0 18             	shl    $0x18,%eax
  8014f1:	89 c2                	mov    %eax,%edx
  8014f3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014f6:	c1 e0 10             	shl    $0x10,%eax
  8014f9:	09 c2                	or     %eax,%edx
  8014fb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014fe:	c1 e0 08             	shl    $0x8,%eax
  801501:	09 d0                	or     %edx,%eax
  801503:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801506:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80150a:	48 c1 e8 02          	shr    $0x2,%rax
  80150e:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801511:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801515:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801518:	48 89 d7             	mov    %rdx,%rdi
  80151b:	fc                   	cld    
  80151c:	f3 ab                	rep stos %eax,%es:(%rdi)
  80151e:	eb 11                	jmp    801531 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801520:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801524:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801527:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80152b:	48 89 d7             	mov    %rdx,%rdi
  80152e:	fc                   	cld    
  80152f:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801531:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801535:	c9                   	leaveq 
  801536:	c3                   	retq   

0000000000801537 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801537:	55                   	push   %rbp
  801538:	48 89 e5             	mov    %rsp,%rbp
  80153b:	48 83 ec 28          	sub    $0x28,%rsp
  80153f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801543:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801547:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80154b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80154f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801553:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801557:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80155b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80155f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801563:	0f 83 88 00 00 00    	jae    8015f1 <memmove+0xba>
  801569:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80156d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801571:	48 01 d0             	add    %rdx,%rax
  801574:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801578:	76 77                	jbe    8015f1 <memmove+0xba>
		s += n;
  80157a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157e:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801582:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801586:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80158a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80158e:	83 e0 03             	and    $0x3,%eax
  801591:	48 85 c0             	test   %rax,%rax
  801594:	75 3b                	jne    8015d1 <memmove+0x9a>
  801596:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80159a:	83 e0 03             	and    $0x3,%eax
  80159d:	48 85 c0             	test   %rax,%rax
  8015a0:	75 2f                	jne    8015d1 <memmove+0x9a>
  8015a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a6:	83 e0 03             	and    $0x3,%eax
  8015a9:	48 85 c0             	test   %rax,%rax
  8015ac:	75 23                	jne    8015d1 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8015ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015b2:	48 83 e8 04          	sub    $0x4,%rax
  8015b6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015ba:	48 83 ea 04          	sub    $0x4,%rdx
  8015be:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015c2:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8015c6:	48 89 c7             	mov    %rax,%rdi
  8015c9:	48 89 d6             	mov    %rdx,%rsi
  8015cc:	fd                   	std    
  8015cd:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015cf:	eb 1d                	jmp    8015ee <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8015d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015d5:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015dd:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8015e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e5:	48 89 d7             	mov    %rdx,%rdi
  8015e8:	48 89 c1             	mov    %rax,%rcx
  8015eb:	fd                   	std    
  8015ec:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8015ee:	fc                   	cld    
  8015ef:	eb 57                	jmp    801648 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8015f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015f5:	83 e0 03             	and    $0x3,%eax
  8015f8:	48 85 c0             	test   %rax,%rax
  8015fb:	75 36                	jne    801633 <memmove+0xfc>
  8015fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801601:	83 e0 03             	and    $0x3,%eax
  801604:	48 85 c0             	test   %rax,%rax
  801607:	75 2a                	jne    801633 <memmove+0xfc>
  801609:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80160d:	83 e0 03             	and    $0x3,%eax
  801610:	48 85 c0             	test   %rax,%rax
  801613:	75 1e                	jne    801633 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801615:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801619:	48 c1 e8 02          	shr    $0x2,%rax
  80161d:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801620:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801624:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801628:	48 89 c7             	mov    %rax,%rdi
  80162b:	48 89 d6             	mov    %rdx,%rsi
  80162e:	fc                   	cld    
  80162f:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801631:	eb 15                	jmp    801648 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801633:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801637:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80163b:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80163f:	48 89 c7             	mov    %rax,%rdi
  801642:	48 89 d6             	mov    %rdx,%rsi
  801645:	fc                   	cld    
  801646:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801648:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80164c:	c9                   	leaveq 
  80164d:	c3                   	retq   

000000000080164e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80164e:	55                   	push   %rbp
  80164f:	48 89 e5             	mov    %rsp,%rbp
  801652:	48 83 ec 18          	sub    $0x18,%rsp
  801656:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80165a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80165e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801662:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801666:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80166a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80166e:	48 89 ce             	mov    %rcx,%rsi
  801671:	48 89 c7             	mov    %rax,%rdi
  801674:	48 b8 37 15 80 00 00 	movabs $0x801537,%rax
  80167b:	00 00 00 
  80167e:	ff d0                	callq  *%rax
}
  801680:	c9                   	leaveq 
  801681:	c3                   	retq   

0000000000801682 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801682:	55                   	push   %rbp
  801683:	48 89 e5             	mov    %rsp,%rbp
  801686:	48 83 ec 28          	sub    $0x28,%rsp
  80168a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80168e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801692:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801696:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80169a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80169e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016a2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8016a6:	eb 36                	jmp    8016de <memcmp+0x5c>
		if (*s1 != *s2)
  8016a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016ac:	0f b6 10             	movzbl (%rax),%edx
  8016af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016b3:	0f b6 00             	movzbl (%rax),%eax
  8016b6:	38 c2                	cmp    %al,%dl
  8016b8:	74 1a                	je     8016d4 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8016ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016be:	0f b6 00             	movzbl (%rax),%eax
  8016c1:	0f b6 d0             	movzbl %al,%edx
  8016c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016c8:	0f b6 00             	movzbl (%rax),%eax
  8016cb:	0f b6 c0             	movzbl %al,%eax
  8016ce:	29 c2                	sub    %eax,%edx
  8016d0:	89 d0                	mov    %edx,%eax
  8016d2:	eb 20                	jmp    8016f4 <memcmp+0x72>
		s1++, s2++;
  8016d4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016d9:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8016de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e2:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016e6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8016ea:	48 85 c0             	test   %rax,%rax
  8016ed:	75 b9                	jne    8016a8 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016f4:	c9                   	leaveq 
  8016f5:	c3                   	retq   

00000000008016f6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8016f6:	55                   	push   %rbp
  8016f7:	48 89 e5             	mov    %rsp,%rbp
  8016fa:	48 83 ec 28          	sub    $0x28,%rsp
  8016fe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801702:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801705:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801709:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80170d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801711:	48 01 d0             	add    %rdx,%rax
  801714:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801718:	eb 15                	jmp    80172f <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80171a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80171e:	0f b6 10             	movzbl (%rax),%edx
  801721:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801724:	38 c2                	cmp    %al,%dl
  801726:	75 02                	jne    80172a <memfind+0x34>
			break;
  801728:	eb 0f                	jmp    801739 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80172a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80172f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801733:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801737:	72 e1                	jb     80171a <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801739:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80173d:	c9                   	leaveq 
  80173e:	c3                   	retq   

000000000080173f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80173f:	55                   	push   %rbp
  801740:	48 89 e5             	mov    %rsp,%rbp
  801743:	48 83 ec 34          	sub    $0x34,%rsp
  801747:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80174b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80174f:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801752:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801759:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801760:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801761:	eb 05                	jmp    801768 <strtol+0x29>
		s++;
  801763:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801768:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80176c:	0f b6 00             	movzbl (%rax),%eax
  80176f:	3c 20                	cmp    $0x20,%al
  801771:	74 f0                	je     801763 <strtol+0x24>
  801773:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801777:	0f b6 00             	movzbl (%rax),%eax
  80177a:	3c 09                	cmp    $0x9,%al
  80177c:	74 e5                	je     801763 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80177e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801782:	0f b6 00             	movzbl (%rax),%eax
  801785:	3c 2b                	cmp    $0x2b,%al
  801787:	75 07                	jne    801790 <strtol+0x51>
		s++;
  801789:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80178e:	eb 17                	jmp    8017a7 <strtol+0x68>
	else if (*s == '-')
  801790:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801794:	0f b6 00             	movzbl (%rax),%eax
  801797:	3c 2d                	cmp    $0x2d,%al
  801799:	75 0c                	jne    8017a7 <strtol+0x68>
		s++, neg = 1;
  80179b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017a0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017a7:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017ab:	74 06                	je     8017b3 <strtol+0x74>
  8017ad:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8017b1:	75 28                	jne    8017db <strtol+0x9c>
  8017b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b7:	0f b6 00             	movzbl (%rax),%eax
  8017ba:	3c 30                	cmp    $0x30,%al
  8017bc:	75 1d                	jne    8017db <strtol+0x9c>
  8017be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c2:	48 83 c0 01          	add    $0x1,%rax
  8017c6:	0f b6 00             	movzbl (%rax),%eax
  8017c9:	3c 78                	cmp    $0x78,%al
  8017cb:	75 0e                	jne    8017db <strtol+0x9c>
		s += 2, base = 16;
  8017cd:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8017d2:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8017d9:	eb 2c                	jmp    801807 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8017db:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017df:	75 19                	jne    8017fa <strtol+0xbb>
  8017e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e5:	0f b6 00             	movzbl (%rax),%eax
  8017e8:	3c 30                	cmp    $0x30,%al
  8017ea:	75 0e                	jne    8017fa <strtol+0xbb>
		s++, base = 8;
  8017ec:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017f1:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8017f8:	eb 0d                	jmp    801807 <strtol+0xc8>
	else if (base == 0)
  8017fa:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017fe:	75 07                	jne    801807 <strtol+0xc8>
		base = 10;
  801800:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801807:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80180b:	0f b6 00             	movzbl (%rax),%eax
  80180e:	3c 2f                	cmp    $0x2f,%al
  801810:	7e 1d                	jle    80182f <strtol+0xf0>
  801812:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801816:	0f b6 00             	movzbl (%rax),%eax
  801819:	3c 39                	cmp    $0x39,%al
  80181b:	7f 12                	jg     80182f <strtol+0xf0>
			dig = *s - '0';
  80181d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801821:	0f b6 00             	movzbl (%rax),%eax
  801824:	0f be c0             	movsbl %al,%eax
  801827:	83 e8 30             	sub    $0x30,%eax
  80182a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80182d:	eb 4e                	jmp    80187d <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80182f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801833:	0f b6 00             	movzbl (%rax),%eax
  801836:	3c 60                	cmp    $0x60,%al
  801838:	7e 1d                	jle    801857 <strtol+0x118>
  80183a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80183e:	0f b6 00             	movzbl (%rax),%eax
  801841:	3c 7a                	cmp    $0x7a,%al
  801843:	7f 12                	jg     801857 <strtol+0x118>
			dig = *s - 'a' + 10;
  801845:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801849:	0f b6 00             	movzbl (%rax),%eax
  80184c:	0f be c0             	movsbl %al,%eax
  80184f:	83 e8 57             	sub    $0x57,%eax
  801852:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801855:	eb 26                	jmp    80187d <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801857:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80185b:	0f b6 00             	movzbl (%rax),%eax
  80185e:	3c 40                	cmp    $0x40,%al
  801860:	7e 48                	jle    8018aa <strtol+0x16b>
  801862:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801866:	0f b6 00             	movzbl (%rax),%eax
  801869:	3c 5a                	cmp    $0x5a,%al
  80186b:	7f 3d                	jg     8018aa <strtol+0x16b>
			dig = *s - 'A' + 10;
  80186d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801871:	0f b6 00             	movzbl (%rax),%eax
  801874:	0f be c0             	movsbl %al,%eax
  801877:	83 e8 37             	sub    $0x37,%eax
  80187a:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80187d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801880:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801883:	7c 02                	jl     801887 <strtol+0x148>
			break;
  801885:	eb 23                	jmp    8018aa <strtol+0x16b>
		s++, val = (val * base) + dig;
  801887:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80188c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80188f:	48 98                	cltq   
  801891:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801896:	48 89 c2             	mov    %rax,%rdx
  801899:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80189c:	48 98                	cltq   
  80189e:	48 01 d0             	add    %rdx,%rax
  8018a1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8018a5:	e9 5d ff ff ff       	jmpq   801807 <strtol+0xc8>

	if (endptr)
  8018aa:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8018af:	74 0b                	je     8018bc <strtol+0x17d>
		*endptr = (char *) s;
  8018b1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018b5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8018b9:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8018bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8018c0:	74 09                	je     8018cb <strtol+0x18c>
  8018c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018c6:	48 f7 d8             	neg    %rax
  8018c9:	eb 04                	jmp    8018cf <strtol+0x190>
  8018cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8018cf:	c9                   	leaveq 
  8018d0:	c3                   	retq   

00000000008018d1 <strstr>:

char * strstr(const char *in, const char *str)
{
  8018d1:	55                   	push   %rbp
  8018d2:	48 89 e5             	mov    %rsp,%rbp
  8018d5:	48 83 ec 30          	sub    $0x30,%rsp
  8018d9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018dd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8018e1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018e5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018e9:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018ed:	0f b6 00             	movzbl (%rax),%eax
  8018f0:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8018f3:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8018f7:	75 06                	jne    8018ff <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8018f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018fd:	eb 6b                	jmp    80196a <strstr+0x99>

	len = strlen(str);
  8018ff:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801903:	48 89 c7             	mov    %rax,%rdi
  801906:	48 b8 a7 11 80 00 00 	movabs $0x8011a7,%rax
  80190d:	00 00 00 
  801910:	ff d0                	callq  *%rax
  801912:	48 98                	cltq   
  801914:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801918:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80191c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801920:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801924:	0f b6 00             	movzbl (%rax),%eax
  801927:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80192a:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80192e:	75 07                	jne    801937 <strstr+0x66>
				return (char *) 0;
  801930:	b8 00 00 00 00       	mov    $0x0,%eax
  801935:	eb 33                	jmp    80196a <strstr+0x99>
		} while (sc != c);
  801937:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80193b:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80193e:	75 d8                	jne    801918 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801940:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801944:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801948:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80194c:	48 89 ce             	mov    %rcx,%rsi
  80194f:	48 89 c7             	mov    %rax,%rdi
  801952:	48 b8 c8 13 80 00 00 	movabs $0x8013c8,%rax
  801959:	00 00 00 
  80195c:	ff d0                	callq  *%rax
  80195e:	85 c0                	test   %eax,%eax
  801960:	75 b6                	jne    801918 <strstr+0x47>

	return (char *) (in - 1);
  801962:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801966:	48 83 e8 01          	sub    $0x1,%rax
}
  80196a:	c9                   	leaveq 
  80196b:	c3                   	retq   

000000000080196c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80196c:	55                   	push   %rbp
  80196d:	48 89 e5             	mov    %rsp,%rbp
  801970:	53                   	push   %rbx
  801971:	48 83 ec 48          	sub    $0x48,%rsp
  801975:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801978:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80197b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80197f:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801983:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801987:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80198b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80198e:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801992:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801996:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80199a:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80199e:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8019a2:	4c 89 c3             	mov    %r8,%rbx
  8019a5:	cd 30                	int    $0x30
  8019a7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8019ab:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8019af:	74 3e                	je     8019ef <syscall+0x83>
  8019b1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8019b6:	7e 37                	jle    8019ef <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8019b8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8019bc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8019bf:	49 89 d0             	mov    %rdx,%r8
  8019c2:	89 c1                	mov    %eax,%ecx
  8019c4:	48 ba 68 47 80 00 00 	movabs $0x804768,%rdx
  8019cb:	00 00 00 
  8019ce:	be 23 00 00 00       	mov    $0x23,%esi
  8019d3:	48 bf 85 47 80 00 00 	movabs $0x804785,%rdi
  8019da:	00 00 00 
  8019dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8019e2:	49 b9 25 04 80 00 00 	movabs $0x800425,%r9
  8019e9:	00 00 00 
  8019ec:	41 ff d1             	callq  *%r9

	return ret;
  8019ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8019f3:	48 83 c4 48          	add    $0x48,%rsp
  8019f7:	5b                   	pop    %rbx
  8019f8:	5d                   	pop    %rbp
  8019f9:	c3                   	retq   

00000000008019fa <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8019fa:	55                   	push   %rbp
  8019fb:	48 89 e5             	mov    %rsp,%rbp
  8019fe:	48 83 ec 20          	sub    $0x20,%rsp
  801a02:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a06:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801a0a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a0e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a12:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a19:	00 
  801a1a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a20:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a26:	48 89 d1             	mov    %rdx,%rcx
  801a29:	48 89 c2             	mov    %rax,%rdx
  801a2c:	be 00 00 00 00       	mov    $0x0,%esi
  801a31:	bf 00 00 00 00       	mov    $0x0,%edi
  801a36:	48 b8 6c 19 80 00 00 	movabs $0x80196c,%rax
  801a3d:	00 00 00 
  801a40:	ff d0                	callq  *%rax
}
  801a42:	c9                   	leaveq 
  801a43:	c3                   	retq   

0000000000801a44 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a44:	55                   	push   %rbp
  801a45:	48 89 e5             	mov    %rsp,%rbp
  801a48:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801a4c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a53:	00 
  801a54:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a5a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a60:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a65:	ba 00 00 00 00       	mov    $0x0,%edx
  801a6a:	be 00 00 00 00       	mov    $0x0,%esi
  801a6f:	bf 01 00 00 00       	mov    $0x1,%edi
  801a74:	48 b8 6c 19 80 00 00 	movabs $0x80196c,%rax
  801a7b:	00 00 00 
  801a7e:	ff d0                	callq  *%rax
}
  801a80:	c9                   	leaveq 
  801a81:	c3                   	retq   

0000000000801a82 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801a82:	55                   	push   %rbp
  801a83:	48 89 e5             	mov    %rsp,%rbp
  801a86:	48 83 ec 10          	sub    $0x10,%rsp
  801a8a:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801a8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a90:	48 98                	cltq   
  801a92:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a99:	00 
  801a9a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aa0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aa6:	b9 00 00 00 00       	mov    $0x0,%ecx
  801aab:	48 89 c2             	mov    %rax,%rdx
  801aae:	be 01 00 00 00       	mov    $0x1,%esi
  801ab3:	bf 03 00 00 00       	mov    $0x3,%edi
  801ab8:	48 b8 6c 19 80 00 00 	movabs $0x80196c,%rax
  801abf:	00 00 00 
  801ac2:	ff d0                	callq  *%rax
}
  801ac4:	c9                   	leaveq 
  801ac5:	c3                   	retq   

0000000000801ac6 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801ac6:	55                   	push   %rbp
  801ac7:	48 89 e5             	mov    %rsp,%rbp
  801aca:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801ace:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ad5:	00 
  801ad6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801adc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ae2:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ae7:	ba 00 00 00 00       	mov    $0x0,%edx
  801aec:	be 00 00 00 00       	mov    $0x0,%esi
  801af1:	bf 02 00 00 00       	mov    $0x2,%edi
  801af6:	48 b8 6c 19 80 00 00 	movabs $0x80196c,%rax
  801afd:	00 00 00 
  801b00:	ff d0                	callq  *%rax
}
  801b02:	c9                   	leaveq 
  801b03:	c3                   	retq   

0000000000801b04 <sys_yield>:

void
sys_yield(void)
{
  801b04:	55                   	push   %rbp
  801b05:	48 89 e5             	mov    %rsp,%rbp
  801b08:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801b0c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b13:	00 
  801b14:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b1a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b20:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b25:	ba 00 00 00 00       	mov    $0x0,%edx
  801b2a:	be 00 00 00 00       	mov    $0x0,%esi
  801b2f:	bf 0b 00 00 00       	mov    $0xb,%edi
  801b34:	48 b8 6c 19 80 00 00 	movabs $0x80196c,%rax
  801b3b:	00 00 00 
  801b3e:	ff d0                	callq  *%rax
}
  801b40:	c9                   	leaveq 
  801b41:	c3                   	retq   

0000000000801b42 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801b42:	55                   	push   %rbp
  801b43:	48 89 e5             	mov    %rsp,%rbp
  801b46:	48 83 ec 20          	sub    $0x20,%rsp
  801b4a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b4d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b51:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801b54:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b57:	48 63 c8             	movslq %eax,%rcx
  801b5a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b61:	48 98                	cltq   
  801b63:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b6a:	00 
  801b6b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b71:	49 89 c8             	mov    %rcx,%r8
  801b74:	48 89 d1             	mov    %rdx,%rcx
  801b77:	48 89 c2             	mov    %rax,%rdx
  801b7a:	be 01 00 00 00       	mov    $0x1,%esi
  801b7f:	bf 04 00 00 00       	mov    $0x4,%edi
  801b84:	48 b8 6c 19 80 00 00 	movabs $0x80196c,%rax
  801b8b:	00 00 00 
  801b8e:	ff d0                	callq  *%rax
}
  801b90:	c9                   	leaveq 
  801b91:	c3                   	retq   

0000000000801b92 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801b92:	55                   	push   %rbp
  801b93:	48 89 e5             	mov    %rsp,%rbp
  801b96:	48 83 ec 30          	sub    $0x30,%rsp
  801b9a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b9d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ba1:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801ba4:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801ba8:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801bac:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801baf:	48 63 c8             	movslq %eax,%rcx
  801bb2:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801bb6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bb9:	48 63 f0             	movslq %eax,%rsi
  801bbc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bc0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bc3:	48 98                	cltq   
  801bc5:	48 89 0c 24          	mov    %rcx,(%rsp)
  801bc9:	49 89 f9             	mov    %rdi,%r9
  801bcc:	49 89 f0             	mov    %rsi,%r8
  801bcf:	48 89 d1             	mov    %rdx,%rcx
  801bd2:	48 89 c2             	mov    %rax,%rdx
  801bd5:	be 01 00 00 00       	mov    $0x1,%esi
  801bda:	bf 05 00 00 00       	mov    $0x5,%edi
  801bdf:	48 b8 6c 19 80 00 00 	movabs $0x80196c,%rax
  801be6:	00 00 00 
  801be9:	ff d0                	callq  *%rax
}
  801beb:	c9                   	leaveq 
  801bec:	c3                   	retq   

0000000000801bed <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801bed:	55                   	push   %rbp
  801bee:	48 89 e5             	mov    %rsp,%rbp
  801bf1:	48 83 ec 20          	sub    $0x20,%rsp
  801bf5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bf8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801bfc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c00:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c03:	48 98                	cltq   
  801c05:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c0c:	00 
  801c0d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c13:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c19:	48 89 d1             	mov    %rdx,%rcx
  801c1c:	48 89 c2             	mov    %rax,%rdx
  801c1f:	be 01 00 00 00       	mov    $0x1,%esi
  801c24:	bf 06 00 00 00       	mov    $0x6,%edi
  801c29:	48 b8 6c 19 80 00 00 	movabs $0x80196c,%rax
  801c30:	00 00 00 
  801c33:	ff d0                	callq  *%rax
}
  801c35:	c9                   	leaveq 
  801c36:	c3                   	retq   

0000000000801c37 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801c37:	55                   	push   %rbp
  801c38:	48 89 e5             	mov    %rsp,%rbp
  801c3b:	48 83 ec 10          	sub    $0x10,%rsp
  801c3f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c42:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801c45:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c48:	48 63 d0             	movslq %eax,%rdx
  801c4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c4e:	48 98                	cltq   
  801c50:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c57:	00 
  801c58:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c5e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c64:	48 89 d1             	mov    %rdx,%rcx
  801c67:	48 89 c2             	mov    %rax,%rdx
  801c6a:	be 01 00 00 00       	mov    $0x1,%esi
  801c6f:	bf 08 00 00 00       	mov    $0x8,%edi
  801c74:	48 b8 6c 19 80 00 00 	movabs $0x80196c,%rax
  801c7b:	00 00 00 
  801c7e:	ff d0                	callq  *%rax
}
  801c80:	c9                   	leaveq 
  801c81:	c3                   	retq   

0000000000801c82 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801c82:	55                   	push   %rbp
  801c83:	48 89 e5             	mov    %rsp,%rbp
  801c86:	48 83 ec 20          	sub    $0x20,%rsp
  801c8a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c8d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801c91:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c98:	48 98                	cltq   
  801c9a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ca1:	00 
  801ca2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ca8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cae:	48 89 d1             	mov    %rdx,%rcx
  801cb1:	48 89 c2             	mov    %rax,%rdx
  801cb4:	be 01 00 00 00       	mov    $0x1,%esi
  801cb9:	bf 09 00 00 00       	mov    $0x9,%edi
  801cbe:	48 b8 6c 19 80 00 00 	movabs $0x80196c,%rax
  801cc5:	00 00 00 
  801cc8:	ff d0                	callq  *%rax
}
  801cca:	c9                   	leaveq 
  801ccb:	c3                   	retq   

0000000000801ccc <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801ccc:	55                   	push   %rbp
  801ccd:	48 89 e5             	mov    %rsp,%rbp
  801cd0:	48 83 ec 20          	sub    $0x20,%rsp
  801cd4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cd7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801cdb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cdf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ce2:	48 98                	cltq   
  801ce4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ceb:	00 
  801cec:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cf2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cf8:	48 89 d1             	mov    %rdx,%rcx
  801cfb:	48 89 c2             	mov    %rax,%rdx
  801cfe:	be 01 00 00 00       	mov    $0x1,%esi
  801d03:	bf 0a 00 00 00       	mov    $0xa,%edi
  801d08:	48 b8 6c 19 80 00 00 	movabs $0x80196c,%rax
  801d0f:	00 00 00 
  801d12:	ff d0                	callq  *%rax
}
  801d14:	c9                   	leaveq 
  801d15:	c3                   	retq   

0000000000801d16 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801d16:	55                   	push   %rbp
  801d17:	48 89 e5             	mov    %rsp,%rbp
  801d1a:	48 83 ec 20          	sub    $0x20,%rsp
  801d1e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d21:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d25:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801d29:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801d2c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d2f:	48 63 f0             	movslq %eax,%rsi
  801d32:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801d36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d39:	48 98                	cltq   
  801d3b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d3f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d46:	00 
  801d47:	49 89 f1             	mov    %rsi,%r9
  801d4a:	49 89 c8             	mov    %rcx,%r8
  801d4d:	48 89 d1             	mov    %rdx,%rcx
  801d50:	48 89 c2             	mov    %rax,%rdx
  801d53:	be 00 00 00 00       	mov    $0x0,%esi
  801d58:	bf 0c 00 00 00       	mov    $0xc,%edi
  801d5d:	48 b8 6c 19 80 00 00 	movabs $0x80196c,%rax
  801d64:	00 00 00 
  801d67:	ff d0                	callq  *%rax
}
  801d69:	c9                   	leaveq 
  801d6a:	c3                   	retq   

0000000000801d6b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801d6b:	55                   	push   %rbp
  801d6c:	48 89 e5             	mov    %rsp,%rbp
  801d6f:	48 83 ec 10          	sub    $0x10,%rsp
  801d73:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801d77:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d7b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d82:	00 
  801d83:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d89:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d8f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d94:	48 89 c2             	mov    %rax,%rdx
  801d97:	be 01 00 00 00       	mov    $0x1,%esi
  801d9c:	bf 0d 00 00 00       	mov    $0xd,%edi
  801da1:	48 b8 6c 19 80 00 00 	movabs $0x80196c,%rax
  801da8:	00 00 00 
  801dab:	ff d0                	callq  *%rax
}
  801dad:	c9                   	leaveq 
  801dae:	c3                   	retq   

0000000000801daf <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801daf:	55                   	push   %rbp
  801db0:	48 89 e5             	mov    %rsp,%rbp
  801db3:	48 83 ec 20          	sub    $0x20,%rsp
  801db7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801dbb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, (uint64_t)buf, len, 0, 0, 0, 0);
  801dbf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dc3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dc7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dce:	00 
  801dcf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dd5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ddb:	b9 00 00 00 00       	mov    $0x0,%ecx
  801de0:	89 c6                	mov    %eax,%esi
  801de2:	bf 0f 00 00 00       	mov    $0xf,%edi
  801de7:	48 b8 6c 19 80 00 00 	movabs $0x80196c,%rax
  801dee:	00 00 00 
  801df1:	ff d0                	callq  *%rax
}
  801df3:	c9                   	leaveq 
  801df4:	c3                   	retq   

0000000000801df5 <sys_net_rx>:

int
sys_net_rx(void *buf, size_t len)
{
  801df5:	55                   	push   %rbp
  801df6:	48 89 e5             	mov    %rsp,%rbp
  801df9:	48 83 ec 20          	sub    $0x20,%rsp
  801dfd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e01:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_rx, (uint64_t)buf, len, 0, 0, 0, 0);
  801e05:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e09:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e0d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e14:	00 
  801e15:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e1b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e21:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e26:	89 c6                	mov    %eax,%esi
  801e28:	bf 10 00 00 00       	mov    $0x10,%edi
  801e2d:	48 b8 6c 19 80 00 00 	movabs $0x80196c,%rax
  801e34:	00 00 00 
  801e37:	ff d0                	callq  *%rax
}
  801e39:	c9                   	leaveq 
  801e3a:	c3                   	retq   

0000000000801e3b <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801e3b:	55                   	push   %rbp
  801e3c:	48 89 e5             	mov    %rsp,%rbp
  801e3f:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801e43:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e4a:	00 
  801e4b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e51:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e57:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e5c:	ba 00 00 00 00       	mov    $0x0,%edx
  801e61:	be 00 00 00 00       	mov    $0x0,%esi
  801e66:	bf 0e 00 00 00       	mov    $0xe,%edi
  801e6b:	48 b8 6c 19 80 00 00 	movabs $0x80196c,%rax
  801e72:	00 00 00 
  801e75:	ff d0                	callq  *%rax
}
  801e77:	c9                   	leaveq 
  801e78:	c3                   	retq   

0000000000801e79 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801e79:	55                   	push   %rbp
  801e7a:	48 89 e5             	mov    %rsp,%rbp
  801e7d:	48 83 ec 08          	sub    $0x8,%rsp
  801e81:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801e85:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e89:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801e90:	ff ff ff 
  801e93:	48 01 d0             	add    %rdx,%rax
  801e96:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801e9a:	c9                   	leaveq 
  801e9b:	c3                   	retq   

0000000000801e9c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801e9c:	55                   	push   %rbp
  801e9d:	48 89 e5             	mov    %rsp,%rbp
  801ea0:	48 83 ec 08          	sub    $0x8,%rsp
  801ea4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801ea8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eac:	48 89 c7             	mov    %rax,%rdi
  801eaf:	48 b8 79 1e 80 00 00 	movabs $0x801e79,%rax
  801eb6:	00 00 00 
  801eb9:	ff d0                	callq  *%rax
  801ebb:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801ec1:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801ec5:	c9                   	leaveq 
  801ec6:	c3                   	retq   

0000000000801ec7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801ec7:	55                   	push   %rbp
  801ec8:	48 89 e5             	mov    %rsp,%rbp
  801ecb:	48 83 ec 18          	sub    $0x18,%rsp
  801ecf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801ed3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801eda:	eb 6b                	jmp    801f47 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801edc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801edf:	48 98                	cltq   
  801ee1:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ee7:	48 c1 e0 0c          	shl    $0xc,%rax
  801eeb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801eef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ef3:	48 c1 e8 15          	shr    $0x15,%rax
  801ef7:	48 89 c2             	mov    %rax,%rdx
  801efa:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f01:	01 00 00 
  801f04:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f08:	83 e0 01             	and    $0x1,%eax
  801f0b:	48 85 c0             	test   %rax,%rax
  801f0e:	74 21                	je     801f31 <fd_alloc+0x6a>
  801f10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f14:	48 c1 e8 0c          	shr    $0xc,%rax
  801f18:	48 89 c2             	mov    %rax,%rdx
  801f1b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f22:	01 00 00 
  801f25:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f29:	83 e0 01             	and    $0x1,%eax
  801f2c:	48 85 c0             	test   %rax,%rax
  801f2f:	75 12                	jne    801f43 <fd_alloc+0x7c>
			*fd_store = fd;
  801f31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f35:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f39:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f3c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f41:	eb 1a                	jmp    801f5d <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801f43:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f47:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801f4b:	7e 8f                	jle    801edc <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801f4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f51:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801f58:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801f5d:	c9                   	leaveq 
  801f5e:	c3                   	retq   

0000000000801f5f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801f5f:	55                   	push   %rbp
  801f60:	48 89 e5             	mov    %rsp,%rbp
  801f63:	48 83 ec 20          	sub    $0x20,%rsp
  801f67:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f6a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801f6e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f72:	78 06                	js     801f7a <fd_lookup+0x1b>
  801f74:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801f78:	7e 07                	jle    801f81 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f7a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f7f:	eb 6c                	jmp    801fed <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801f81:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f84:	48 98                	cltq   
  801f86:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801f8c:	48 c1 e0 0c          	shl    $0xc,%rax
  801f90:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801f94:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f98:	48 c1 e8 15          	shr    $0x15,%rax
  801f9c:	48 89 c2             	mov    %rax,%rdx
  801f9f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801fa6:	01 00 00 
  801fa9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fad:	83 e0 01             	and    $0x1,%eax
  801fb0:	48 85 c0             	test   %rax,%rax
  801fb3:	74 21                	je     801fd6 <fd_lookup+0x77>
  801fb5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fb9:	48 c1 e8 0c          	shr    $0xc,%rax
  801fbd:	48 89 c2             	mov    %rax,%rdx
  801fc0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fc7:	01 00 00 
  801fca:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fce:	83 e0 01             	and    $0x1,%eax
  801fd1:	48 85 c0             	test   %rax,%rax
  801fd4:	75 07                	jne    801fdd <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801fd6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801fdb:	eb 10                	jmp    801fed <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801fdd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fe1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801fe5:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801fe8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fed:	c9                   	leaveq 
  801fee:	c3                   	retq   

0000000000801fef <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801fef:	55                   	push   %rbp
  801ff0:	48 89 e5             	mov    %rsp,%rbp
  801ff3:	48 83 ec 30          	sub    $0x30,%rsp
  801ff7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801ffb:	89 f0                	mov    %esi,%eax
  801ffd:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802000:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802004:	48 89 c7             	mov    %rax,%rdi
  802007:	48 b8 79 1e 80 00 00 	movabs $0x801e79,%rax
  80200e:	00 00 00 
  802011:	ff d0                	callq  *%rax
  802013:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802017:	48 89 d6             	mov    %rdx,%rsi
  80201a:	89 c7                	mov    %eax,%edi
  80201c:	48 b8 5f 1f 80 00 00 	movabs $0x801f5f,%rax
  802023:	00 00 00 
  802026:	ff d0                	callq  *%rax
  802028:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80202b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80202f:	78 0a                	js     80203b <fd_close+0x4c>
	    || fd != fd2)
  802031:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802035:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802039:	74 12                	je     80204d <fd_close+0x5e>
		return (must_exist ? r : 0);
  80203b:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80203f:	74 05                	je     802046 <fd_close+0x57>
  802041:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802044:	eb 05                	jmp    80204b <fd_close+0x5c>
  802046:	b8 00 00 00 00       	mov    $0x0,%eax
  80204b:	eb 69                	jmp    8020b6 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80204d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802051:	8b 00                	mov    (%rax),%eax
  802053:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802057:	48 89 d6             	mov    %rdx,%rsi
  80205a:	89 c7                	mov    %eax,%edi
  80205c:	48 b8 b8 20 80 00 00 	movabs $0x8020b8,%rax
  802063:	00 00 00 
  802066:	ff d0                	callq  *%rax
  802068:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80206b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80206f:	78 2a                	js     80209b <fd_close+0xac>
		if (dev->dev_close)
  802071:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802075:	48 8b 40 20          	mov    0x20(%rax),%rax
  802079:	48 85 c0             	test   %rax,%rax
  80207c:	74 16                	je     802094 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  80207e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802082:	48 8b 40 20          	mov    0x20(%rax),%rax
  802086:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80208a:	48 89 d7             	mov    %rdx,%rdi
  80208d:	ff d0                	callq  *%rax
  80208f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802092:	eb 07                	jmp    80209b <fd_close+0xac>
		else
			r = 0;
  802094:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80209b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80209f:	48 89 c6             	mov    %rax,%rsi
  8020a2:	bf 00 00 00 00       	mov    $0x0,%edi
  8020a7:	48 b8 ed 1b 80 00 00 	movabs $0x801bed,%rax
  8020ae:	00 00 00 
  8020b1:	ff d0                	callq  *%rax
	return r;
  8020b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8020b6:	c9                   	leaveq 
  8020b7:	c3                   	retq   

00000000008020b8 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8020b8:	55                   	push   %rbp
  8020b9:	48 89 e5             	mov    %rsp,%rbp
  8020bc:	48 83 ec 20          	sub    $0x20,%rsp
  8020c0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8020c3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8020c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020ce:	eb 41                	jmp    802111 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8020d0:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8020d7:	00 00 00 
  8020da:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020dd:	48 63 d2             	movslq %edx,%rdx
  8020e0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020e4:	8b 00                	mov    (%rax),%eax
  8020e6:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8020e9:	75 22                	jne    80210d <dev_lookup+0x55>
			*dev = devtab[i];
  8020eb:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8020f2:	00 00 00 
  8020f5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020f8:	48 63 d2             	movslq %edx,%rdx
  8020fb:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8020ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802103:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802106:	b8 00 00 00 00       	mov    $0x0,%eax
  80210b:	eb 60                	jmp    80216d <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80210d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802111:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802118:	00 00 00 
  80211b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80211e:	48 63 d2             	movslq %edx,%rdx
  802121:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802125:	48 85 c0             	test   %rax,%rax
  802128:	75 a6                	jne    8020d0 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80212a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802131:	00 00 00 
  802134:	48 8b 00             	mov    (%rax),%rax
  802137:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80213d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802140:	89 c6                	mov    %eax,%esi
  802142:	48 bf 98 47 80 00 00 	movabs $0x804798,%rdi
  802149:	00 00 00 
  80214c:	b8 00 00 00 00       	mov    $0x0,%eax
  802151:	48 b9 5e 06 80 00 00 	movabs $0x80065e,%rcx
  802158:	00 00 00 
  80215b:	ff d1                	callq  *%rcx
	*dev = 0;
  80215d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802161:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802168:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80216d:	c9                   	leaveq 
  80216e:	c3                   	retq   

000000000080216f <close>:

int
close(int fdnum)
{
  80216f:	55                   	push   %rbp
  802170:	48 89 e5             	mov    %rsp,%rbp
  802173:	48 83 ec 20          	sub    $0x20,%rsp
  802177:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80217a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80217e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802181:	48 89 d6             	mov    %rdx,%rsi
  802184:	89 c7                	mov    %eax,%edi
  802186:	48 b8 5f 1f 80 00 00 	movabs $0x801f5f,%rax
  80218d:	00 00 00 
  802190:	ff d0                	callq  *%rax
  802192:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802195:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802199:	79 05                	jns    8021a0 <close+0x31>
		return r;
  80219b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80219e:	eb 18                	jmp    8021b8 <close+0x49>
	else
		return fd_close(fd, 1);
  8021a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021a4:	be 01 00 00 00       	mov    $0x1,%esi
  8021a9:	48 89 c7             	mov    %rax,%rdi
  8021ac:	48 b8 ef 1f 80 00 00 	movabs $0x801fef,%rax
  8021b3:	00 00 00 
  8021b6:	ff d0                	callq  *%rax
}
  8021b8:	c9                   	leaveq 
  8021b9:	c3                   	retq   

00000000008021ba <close_all>:

void
close_all(void)
{
  8021ba:	55                   	push   %rbp
  8021bb:	48 89 e5             	mov    %rsp,%rbp
  8021be:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8021c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8021c9:	eb 15                	jmp    8021e0 <close_all+0x26>
		close(i);
  8021cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021ce:	89 c7                	mov    %eax,%edi
  8021d0:	48 b8 6f 21 80 00 00 	movabs $0x80216f,%rax
  8021d7:	00 00 00 
  8021da:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8021dc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8021e0:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8021e4:	7e e5                	jle    8021cb <close_all+0x11>
		close(i);
}
  8021e6:	c9                   	leaveq 
  8021e7:	c3                   	retq   

00000000008021e8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8021e8:	55                   	push   %rbp
  8021e9:	48 89 e5             	mov    %rsp,%rbp
  8021ec:	48 83 ec 40          	sub    $0x40,%rsp
  8021f0:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8021f3:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8021f6:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8021fa:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8021fd:	48 89 d6             	mov    %rdx,%rsi
  802200:	89 c7                	mov    %eax,%edi
  802202:	48 b8 5f 1f 80 00 00 	movabs $0x801f5f,%rax
  802209:	00 00 00 
  80220c:	ff d0                	callq  *%rax
  80220e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802211:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802215:	79 08                	jns    80221f <dup+0x37>
		return r;
  802217:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80221a:	e9 70 01 00 00       	jmpq   80238f <dup+0x1a7>
	close(newfdnum);
  80221f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802222:	89 c7                	mov    %eax,%edi
  802224:	48 b8 6f 21 80 00 00 	movabs $0x80216f,%rax
  80222b:	00 00 00 
  80222e:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802230:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802233:	48 98                	cltq   
  802235:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80223b:	48 c1 e0 0c          	shl    $0xc,%rax
  80223f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802243:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802247:	48 89 c7             	mov    %rax,%rdi
  80224a:	48 b8 9c 1e 80 00 00 	movabs $0x801e9c,%rax
  802251:	00 00 00 
  802254:	ff d0                	callq  *%rax
  802256:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80225a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80225e:	48 89 c7             	mov    %rax,%rdi
  802261:	48 b8 9c 1e 80 00 00 	movabs $0x801e9c,%rax
  802268:	00 00 00 
  80226b:	ff d0                	callq  *%rax
  80226d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802271:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802275:	48 c1 e8 15          	shr    $0x15,%rax
  802279:	48 89 c2             	mov    %rax,%rdx
  80227c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802283:	01 00 00 
  802286:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80228a:	83 e0 01             	and    $0x1,%eax
  80228d:	48 85 c0             	test   %rax,%rax
  802290:	74 73                	je     802305 <dup+0x11d>
  802292:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802296:	48 c1 e8 0c          	shr    $0xc,%rax
  80229a:	48 89 c2             	mov    %rax,%rdx
  80229d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022a4:	01 00 00 
  8022a7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022ab:	83 e0 01             	and    $0x1,%eax
  8022ae:	48 85 c0             	test   %rax,%rax
  8022b1:	74 52                	je     802305 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8022b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022b7:	48 c1 e8 0c          	shr    $0xc,%rax
  8022bb:	48 89 c2             	mov    %rax,%rdx
  8022be:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022c5:	01 00 00 
  8022c8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022cc:	25 07 0e 00 00       	and    $0xe07,%eax
  8022d1:	89 c1                	mov    %eax,%ecx
  8022d3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8022d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022db:	41 89 c8             	mov    %ecx,%r8d
  8022de:	48 89 d1             	mov    %rdx,%rcx
  8022e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8022e6:	48 89 c6             	mov    %rax,%rsi
  8022e9:	bf 00 00 00 00       	mov    $0x0,%edi
  8022ee:	48 b8 92 1b 80 00 00 	movabs $0x801b92,%rax
  8022f5:	00 00 00 
  8022f8:	ff d0                	callq  *%rax
  8022fa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802301:	79 02                	jns    802305 <dup+0x11d>
			goto err;
  802303:	eb 57                	jmp    80235c <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802305:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802309:	48 c1 e8 0c          	shr    $0xc,%rax
  80230d:	48 89 c2             	mov    %rax,%rdx
  802310:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802317:	01 00 00 
  80231a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80231e:	25 07 0e 00 00       	and    $0xe07,%eax
  802323:	89 c1                	mov    %eax,%ecx
  802325:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802329:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80232d:	41 89 c8             	mov    %ecx,%r8d
  802330:	48 89 d1             	mov    %rdx,%rcx
  802333:	ba 00 00 00 00       	mov    $0x0,%edx
  802338:	48 89 c6             	mov    %rax,%rsi
  80233b:	bf 00 00 00 00       	mov    $0x0,%edi
  802340:	48 b8 92 1b 80 00 00 	movabs $0x801b92,%rax
  802347:	00 00 00 
  80234a:	ff d0                	callq  *%rax
  80234c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80234f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802353:	79 02                	jns    802357 <dup+0x16f>
		goto err;
  802355:	eb 05                	jmp    80235c <dup+0x174>

	return newfdnum;
  802357:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80235a:	eb 33                	jmp    80238f <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  80235c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802360:	48 89 c6             	mov    %rax,%rsi
  802363:	bf 00 00 00 00       	mov    $0x0,%edi
  802368:	48 b8 ed 1b 80 00 00 	movabs $0x801bed,%rax
  80236f:	00 00 00 
  802372:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802374:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802378:	48 89 c6             	mov    %rax,%rsi
  80237b:	bf 00 00 00 00       	mov    $0x0,%edi
  802380:	48 b8 ed 1b 80 00 00 	movabs $0x801bed,%rax
  802387:	00 00 00 
  80238a:	ff d0                	callq  *%rax
	return r;
  80238c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80238f:	c9                   	leaveq 
  802390:	c3                   	retq   

0000000000802391 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802391:	55                   	push   %rbp
  802392:	48 89 e5             	mov    %rsp,%rbp
  802395:	48 83 ec 40          	sub    $0x40,%rsp
  802399:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80239c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8023a0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023a4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023a8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8023ab:	48 89 d6             	mov    %rdx,%rsi
  8023ae:	89 c7                	mov    %eax,%edi
  8023b0:	48 b8 5f 1f 80 00 00 	movabs $0x801f5f,%rax
  8023b7:	00 00 00 
  8023ba:	ff d0                	callq  *%rax
  8023bc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023c3:	78 24                	js     8023e9 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023c9:	8b 00                	mov    (%rax),%eax
  8023cb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023cf:	48 89 d6             	mov    %rdx,%rsi
  8023d2:	89 c7                	mov    %eax,%edi
  8023d4:	48 b8 b8 20 80 00 00 	movabs $0x8020b8,%rax
  8023db:	00 00 00 
  8023de:	ff d0                	callq  *%rax
  8023e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023e7:	79 05                	jns    8023ee <read+0x5d>
		return r;
  8023e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023ec:	eb 76                	jmp    802464 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8023ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023f2:	8b 40 08             	mov    0x8(%rax),%eax
  8023f5:	83 e0 03             	and    $0x3,%eax
  8023f8:	83 f8 01             	cmp    $0x1,%eax
  8023fb:	75 3a                	jne    802437 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8023fd:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802404:	00 00 00 
  802407:	48 8b 00             	mov    (%rax),%rax
  80240a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802410:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802413:	89 c6                	mov    %eax,%esi
  802415:	48 bf b7 47 80 00 00 	movabs $0x8047b7,%rdi
  80241c:	00 00 00 
  80241f:	b8 00 00 00 00       	mov    $0x0,%eax
  802424:	48 b9 5e 06 80 00 00 	movabs $0x80065e,%rcx
  80242b:	00 00 00 
  80242e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802430:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802435:	eb 2d                	jmp    802464 <read+0xd3>
	}
	if (!dev->dev_read)
  802437:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80243b:	48 8b 40 10          	mov    0x10(%rax),%rax
  80243f:	48 85 c0             	test   %rax,%rax
  802442:	75 07                	jne    80244b <read+0xba>
		return -E_NOT_SUPP;
  802444:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802449:	eb 19                	jmp    802464 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80244b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80244f:	48 8b 40 10          	mov    0x10(%rax),%rax
  802453:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802457:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80245b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80245f:	48 89 cf             	mov    %rcx,%rdi
  802462:	ff d0                	callq  *%rax
}
  802464:	c9                   	leaveq 
  802465:	c3                   	retq   

0000000000802466 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802466:	55                   	push   %rbp
  802467:	48 89 e5             	mov    %rsp,%rbp
  80246a:	48 83 ec 30          	sub    $0x30,%rsp
  80246e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802471:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802475:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802479:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802480:	eb 49                	jmp    8024cb <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802482:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802485:	48 98                	cltq   
  802487:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80248b:	48 29 c2             	sub    %rax,%rdx
  80248e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802491:	48 63 c8             	movslq %eax,%rcx
  802494:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802498:	48 01 c1             	add    %rax,%rcx
  80249b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80249e:	48 89 ce             	mov    %rcx,%rsi
  8024a1:	89 c7                	mov    %eax,%edi
  8024a3:	48 b8 91 23 80 00 00 	movabs $0x802391,%rax
  8024aa:	00 00 00 
  8024ad:	ff d0                	callq  *%rax
  8024af:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8024b2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8024b6:	79 05                	jns    8024bd <readn+0x57>
			return m;
  8024b8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024bb:	eb 1c                	jmp    8024d9 <readn+0x73>
		if (m == 0)
  8024bd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8024c1:	75 02                	jne    8024c5 <readn+0x5f>
			break;
  8024c3:	eb 11                	jmp    8024d6 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8024c5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024c8:	01 45 fc             	add    %eax,-0x4(%rbp)
  8024cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024ce:	48 98                	cltq   
  8024d0:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8024d4:	72 ac                	jb     802482 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8024d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8024d9:	c9                   	leaveq 
  8024da:	c3                   	retq   

00000000008024db <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8024db:	55                   	push   %rbp
  8024dc:	48 89 e5             	mov    %rsp,%rbp
  8024df:	48 83 ec 40          	sub    $0x40,%rsp
  8024e3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024e6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8024ea:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024ee:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024f2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024f5:	48 89 d6             	mov    %rdx,%rsi
  8024f8:	89 c7                	mov    %eax,%edi
  8024fa:	48 b8 5f 1f 80 00 00 	movabs $0x801f5f,%rax
  802501:	00 00 00 
  802504:	ff d0                	callq  *%rax
  802506:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802509:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80250d:	78 24                	js     802533 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80250f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802513:	8b 00                	mov    (%rax),%eax
  802515:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802519:	48 89 d6             	mov    %rdx,%rsi
  80251c:	89 c7                	mov    %eax,%edi
  80251e:	48 b8 b8 20 80 00 00 	movabs $0x8020b8,%rax
  802525:	00 00 00 
  802528:	ff d0                	callq  *%rax
  80252a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80252d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802531:	79 05                	jns    802538 <write+0x5d>
		return r;
  802533:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802536:	eb 75                	jmp    8025ad <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802538:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80253c:	8b 40 08             	mov    0x8(%rax),%eax
  80253f:	83 e0 03             	and    $0x3,%eax
  802542:	85 c0                	test   %eax,%eax
  802544:	75 3a                	jne    802580 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802546:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80254d:	00 00 00 
  802550:	48 8b 00             	mov    (%rax),%rax
  802553:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802559:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80255c:	89 c6                	mov    %eax,%esi
  80255e:	48 bf d3 47 80 00 00 	movabs $0x8047d3,%rdi
  802565:	00 00 00 
  802568:	b8 00 00 00 00       	mov    $0x0,%eax
  80256d:	48 b9 5e 06 80 00 00 	movabs $0x80065e,%rcx
  802574:	00 00 00 
  802577:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802579:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80257e:	eb 2d                	jmp    8025ad <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  802580:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802584:	48 8b 40 18          	mov    0x18(%rax),%rax
  802588:	48 85 c0             	test   %rax,%rax
  80258b:	75 07                	jne    802594 <write+0xb9>
		return -E_NOT_SUPP;
  80258d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802592:	eb 19                	jmp    8025ad <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802594:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802598:	48 8b 40 18          	mov    0x18(%rax),%rax
  80259c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8025a0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8025a4:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8025a8:	48 89 cf             	mov    %rcx,%rdi
  8025ab:	ff d0                	callq  *%rax
}
  8025ad:	c9                   	leaveq 
  8025ae:	c3                   	retq   

00000000008025af <seek>:

int
seek(int fdnum, off_t offset)
{
  8025af:	55                   	push   %rbp
  8025b0:	48 89 e5             	mov    %rsp,%rbp
  8025b3:	48 83 ec 18          	sub    $0x18,%rsp
  8025b7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025ba:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025bd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025c1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025c4:	48 89 d6             	mov    %rdx,%rsi
  8025c7:	89 c7                	mov    %eax,%edi
  8025c9:	48 b8 5f 1f 80 00 00 	movabs $0x801f5f,%rax
  8025d0:	00 00 00 
  8025d3:	ff d0                	callq  *%rax
  8025d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025dc:	79 05                	jns    8025e3 <seek+0x34>
		return r;
  8025de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025e1:	eb 0f                	jmp    8025f2 <seek+0x43>
	fd->fd_offset = offset;
  8025e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025e7:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8025ea:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8025ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025f2:	c9                   	leaveq 
  8025f3:	c3                   	retq   

00000000008025f4 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8025f4:	55                   	push   %rbp
  8025f5:	48 89 e5             	mov    %rsp,%rbp
  8025f8:	48 83 ec 30          	sub    $0x30,%rsp
  8025fc:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8025ff:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802602:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802606:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802609:	48 89 d6             	mov    %rdx,%rsi
  80260c:	89 c7                	mov    %eax,%edi
  80260e:	48 b8 5f 1f 80 00 00 	movabs $0x801f5f,%rax
  802615:	00 00 00 
  802618:	ff d0                	callq  *%rax
  80261a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80261d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802621:	78 24                	js     802647 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802623:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802627:	8b 00                	mov    (%rax),%eax
  802629:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80262d:	48 89 d6             	mov    %rdx,%rsi
  802630:	89 c7                	mov    %eax,%edi
  802632:	48 b8 b8 20 80 00 00 	movabs $0x8020b8,%rax
  802639:	00 00 00 
  80263c:	ff d0                	callq  *%rax
  80263e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802641:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802645:	79 05                	jns    80264c <ftruncate+0x58>
		return r;
  802647:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80264a:	eb 72                	jmp    8026be <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80264c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802650:	8b 40 08             	mov    0x8(%rax),%eax
  802653:	83 e0 03             	and    $0x3,%eax
  802656:	85 c0                	test   %eax,%eax
  802658:	75 3a                	jne    802694 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80265a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802661:	00 00 00 
  802664:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802667:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80266d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802670:	89 c6                	mov    %eax,%esi
  802672:	48 bf f0 47 80 00 00 	movabs $0x8047f0,%rdi
  802679:	00 00 00 
  80267c:	b8 00 00 00 00       	mov    $0x0,%eax
  802681:	48 b9 5e 06 80 00 00 	movabs $0x80065e,%rcx
  802688:	00 00 00 
  80268b:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80268d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802692:	eb 2a                	jmp    8026be <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802694:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802698:	48 8b 40 30          	mov    0x30(%rax),%rax
  80269c:	48 85 c0             	test   %rax,%rax
  80269f:	75 07                	jne    8026a8 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8026a1:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8026a6:	eb 16                	jmp    8026be <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8026a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026ac:	48 8b 40 30          	mov    0x30(%rax),%rax
  8026b0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8026b4:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8026b7:	89 ce                	mov    %ecx,%esi
  8026b9:	48 89 d7             	mov    %rdx,%rdi
  8026bc:	ff d0                	callq  *%rax
}
  8026be:	c9                   	leaveq 
  8026bf:	c3                   	retq   

00000000008026c0 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8026c0:	55                   	push   %rbp
  8026c1:	48 89 e5             	mov    %rsp,%rbp
  8026c4:	48 83 ec 30          	sub    $0x30,%rsp
  8026c8:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8026cb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8026cf:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026d3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8026d6:	48 89 d6             	mov    %rdx,%rsi
  8026d9:	89 c7                	mov    %eax,%edi
  8026db:	48 b8 5f 1f 80 00 00 	movabs $0x801f5f,%rax
  8026e2:	00 00 00 
  8026e5:	ff d0                	callq  *%rax
  8026e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026ee:	78 24                	js     802714 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8026f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026f4:	8b 00                	mov    (%rax),%eax
  8026f6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026fa:	48 89 d6             	mov    %rdx,%rsi
  8026fd:	89 c7                	mov    %eax,%edi
  8026ff:	48 b8 b8 20 80 00 00 	movabs $0x8020b8,%rax
  802706:	00 00 00 
  802709:	ff d0                	callq  *%rax
  80270b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80270e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802712:	79 05                	jns    802719 <fstat+0x59>
		return r;
  802714:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802717:	eb 5e                	jmp    802777 <fstat+0xb7>
	if (!dev->dev_stat)
  802719:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80271d:	48 8b 40 28          	mov    0x28(%rax),%rax
  802721:	48 85 c0             	test   %rax,%rax
  802724:	75 07                	jne    80272d <fstat+0x6d>
		return -E_NOT_SUPP;
  802726:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80272b:	eb 4a                	jmp    802777 <fstat+0xb7>
	stat->st_name[0] = 0;
  80272d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802731:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802734:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802738:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80273f:	00 00 00 
	stat->st_isdir = 0;
  802742:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802746:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80274d:	00 00 00 
	stat->st_dev = dev;
  802750:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802754:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802758:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80275f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802763:	48 8b 40 28          	mov    0x28(%rax),%rax
  802767:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80276b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80276f:	48 89 ce             	mov    %rcx,%rsi
  802772:	48 89 d7             	mov    %rdx,%rdi
  802775:	ff d0                	callq  *%rax
}
  802777:	c9                   	leaveq 
  802778:	c3                   	retq   

0000000000802779 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802779:	55                   	push   %rbp
  80277a:	48 89 e5             	mov    %rsp,%rbp
  80277d:	48 83 ec 20          	sub    $0x20,%rsp
  802781:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802785:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802789:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80278d:	be 00 00 00 00       	mov    $0x0,%esi
  802792:	48 89 c7             	mov    %rax,%rdi
  802795:	48 b8 67 28 80 00 00 	movabs $0x802867,%rax
  80279c:	00 00 00 
  80279f:	ff d0                	callq  *%rax
  8027a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027a8:	79 05                	jns    8027af <stat+0x36>
		return fd;
  8027aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027ad:	eb 2f                	jmp    8027de <stat+0x65>
	r = fstat(fd, stat);
  8027af:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8027b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027b6:	48 89 d6             	mov    %rdx,%rsi
  8027b9:	89 c7                	mov    %eax,%edi
  8027bb:	48 b8 c0 26 80 00 00 	movabs $0x8026c0,%rax
  8027c2:	00 00 00 
  8027c5:	ff d0                	callq  *%rax
  8027c7:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8027ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027cd:	89 c7                	mov    %eax,%edi
  8027cf:	48 b8 6f 21 80 00 00 	movabs $0x80216f,%rax
  8027d6:	00 00 00 
  8027d9:	ff d0                	callq  *%rax
	return r;
  8027db:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8027de:	c9                   	leaveq 
  8027df:	c3                   	retq   

00000000008027e0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8027e0:	55                   	push   %rbp
  8027e1:	48 89 e5             	mov    %rsp,%rbp
  8027e4:	48 83 ec 10          	sub    $0x10,%rsp
  8027e8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8027eb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8027ef:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027f6:	00 00 00 
  8027f9:	8b 00                	mov    (%rax),%eax
  8027fb:	85 c0                	test   %eax,%eax
  8027fd:	75 1d                	jne    80281c <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8027ff:	bf 01 00 00 00       	mov    $0x1,%edi
  802804:	48 b8 6d 40 80 00 00 	movabs $0x80406d,%rax
  80280b:	00 00 00 
  80280e:	ff d0                	callq  *%rax
  802810:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802817:	00 00 00 
  80281a:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80281c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802823:	00 00 00 
  802826:	8b 00                	mov    (%rax),%eax
  802828:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80282b:	b9 07 00 00 00       	mov    $0x7,%ecx
  802830:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802837:	00 00 00 
  80283a:	89 c7                	mov    %eax,%edi
  80283c:	48 b8 0b 40 80 00 00 	movabs $0x80400b,%rax
  802843:	00 00 00 
  802846:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802848:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80284c:	ba 00 00 00 00       	mov    $0x0,%edx
  802851:	48 89 c6             	mov    %rax,%rsi
  802854:	bf 00 00 00 00       	mov    $0x0,%edi
  802859:	48 b8 05 3f 80 00 00 	movabs $0x803f05,%rax
  802860:	00 00 00 
  802863:	ff d0                	callq  *%rax
}
  802865:	c9                   	leaveq 
  802866:	c3                   	retq   

0000000000802867 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802867:	55                   	push   %rbp
  802868:	48 89 e5             	mov    %rsp,%rbp
  80286b:	48 83 ec 30          	sub    $0x30,%rsp
  80286f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802873:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802876:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  80287d:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802884:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  80288b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802890:	75 08                	jne    80289a <open+0x33>
	{
		return r;
  802892:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802895:	e9 f2 00 00 00       	jmpq   80298c <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  80289a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80289e:	48 89 c7             	mov    %rax,%rdi
  8028a1:	48 b8 a7 11 80 00 00 	movabs $0x8011a7,%rax
  8028a8:	00 00 00 
  8028ab:	ff d0                	callq  *%rax
  8028ad:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8028b0:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  8028b7:	7e 0a                	jle    8028c3 <open+0x5c>
	{
		return -E_BAD_PATH;
  8028b9:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8028be:	e9 c9 00 00 00       	jmpq   80298c <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  8028c3:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8028ca:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  8028cb:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8028cf:	48 89 c7             	mov    %rax,%rdi
  8028d2:	48 b8 c7 1e 80 00 00 	movabs $0x801ec7,%rax
  8028d9:	00 00 00 
  8028dc:	ff d0                	callq  *%rax
  8028de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028e5:	78 09                	js     8028f0 <open+0x89>
  8028e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028eb:	48 85 c0             	test   %rax,%rax
  8028ee:	75 08                	jne    8028f8 <open+0x91>
		{
			return r;
  8028f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028f3:	e9 94 00 00 00       	jmpq   80298c <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  8028f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028fc:	ba 00 04 00 00       	mov    $0x400,%edx
  802901:	48 89 c6             	mov    %rax,%rsi
  802904:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80290b:	00 00 00 
  80290e:	48 b8 a5 12 80 00 00 	movabs $0x8012a5,%rax
  802915:	00 00 00 
  802918:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  80291a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802921:	00 00 00 
  802924:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802927:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  80292d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802931:	48 89 c6             	mov    %rax,%rsi
  802934:	bf 01 00 00 00       	mov    $0x1,%edi
  802939:	48 b8 e0 27 80 00 00 	movabs $0x8027e0,%rax
  802940:	00 00 00 
  802943:	ff d0                	callq  *%rax
  802945:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802948:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80294c:	79 2b                	jns    802979 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  80294e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802952:	be 00 00 00 00       	mov    $0x0,%esi
  802957:	48 89 c7             	mov    %rax,%rdi
  80295a:	48 b8 ef 1f 80 00 00 	movabs $0x801fef,%rax
  802961:	00 00 00 
  802964:	ff d0                	callq  *%rax
  802966:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802969:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80296d:	79 05                	jns    802974 <open+0x10d>
			{
				return d;
  80296f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802972:	eb 18                	jmp    80298c <open+0x125>
			}
			return r;
  802974:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802977:	eb 13                	jmp    80298c <open+0x125>
		}	
		return fd2num(fd_store);
  802979:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80297d:	48 89 c7             	mov    %rax,%rdi
  802980:	48 b8 79 1e 80 00 00 	movabs $0x801e79,%rax
  802987:	00 00 00 
  80298a:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  80298c:	c9                   	leaveq 
  80298d:	c3                   	retq   

000000000080298e <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80298e:	55                   	push   %rbp
  80298f:	48 89 e5             	mov    %rsp,%rbp
  802992:	48 83 ec 10          	sub    $0x10,%rsp
  802996:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80299a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80299e:	8b 50 0c             	mov    0xc(%rax),%edx
  8029a1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029a8:	00 00 00 
  8029ab:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8029ad:	be 00 00 00 00       	mov    $0x0,%esi
  8029b2:	bf 06 00 00 00       	mov    $0x6,%edi
  8029b7:	48 b8 e0 27 80 00 00 	movabs $0x8027e0,%rax
  8029be:	00 00 00 
  8029c1:	ff d0                	callq  *%rax
}
  8029c3:	c9                   	leaveq 
  8029c4:	c3                   	retq   

00000000008029c5 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8029c5:	55                   	push   %rbp
  8029c6:	48 89 e5             	mov    %rsp,%rbp
  8029c9:	48 83 ec 30          	sub    $0x30,%rsp
  8029cd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029d1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8029d5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  8029d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  8029e0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8029e5:	74 07                	je     8029ee <devfile_read+0x29>
  8029e7:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8029ec:	75 07                	jne    8029f5 <devfile_read+0x30>
		return -E_INVAL;
  8029ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029f3:	eb 77                	jmp    802a6c <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8029f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029f9:	8b 50 0c             	mov    0xc(%rax),%edx
  8029fc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a03:	00 00 00 
  802a06:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802a08:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a0f:	00 00 00 
  802a12:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a16:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802a1a:	be 00 00 00 00       	mov    $0x0,%esi
  802a1f:	bf 03 00 00 00       	mov    $0x3,%edi
  802a24:	48 b8 e0 27 80 00 00 	movabs $0x8027e0,%rax
  802a2b:	00 00 00 
  802a2e:	ff d0                	callq  *%rax
  802a30:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a33:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a37:	7f 05                	jg     802a3e <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802a39:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a3c:	eb 2e                	jmp    802a6c <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802a3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a41:	48 63 d0             	movslq %eax,%rdx
  802a44:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a48:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802a4f:	00 00 00 
  802a52:	48 89 c7             	mov    %rax,%rdi
  802a55:	48 b8 37 15 80 00 00 	movabs $0x801537,%rax
  802a5c:	00 00 00 
  802a5f:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802a61:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a65:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802a69:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802a6c:	c9                   	leaveq 
  802a6d:	c3                   	retq   

0000000000802a6e <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802a6e:	55                   	push   %rbp
  802a6f:	48 89 e5             	mov    %rsp,%rbp
  802a72:	48 83 ec 30          	sub    $0x30,%rsp
  802a76:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a7a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a7e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802a82:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802a89:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802a8e:	74 07                	je     802a97 <devfile_write+0x29>
  802a90:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802a95:	75 08                	jne    802a9f <devfile_write+0x31>
		return r;
  802a97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a9a:	e9 9a 00 00 00       	jmpq   802b39 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802a9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aa3:	8b 50 0c             	mov    0xc(%rax),%edx
  802aa6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802aad:	00 00 00 
  802ab0:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802ab2:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802ab9:	00 
  802aba:	76 08                	jbe    802ac4 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802abc:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802ac3:	00 
	}
	fsipcbuf.write.req_n = n;
  802ac4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802acb:	00 00 00 
  802ace:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ad2:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802ad6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ada:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ade:	48 89 c6             	mov    %rax,%rsi
  802ae1:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802ae8:	00 00 00 
  802aeb:	48 b8 37 15 80 00 00 	movabs $0x801537,%rax
  802af2:	00 00 00 
  802af5:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802af7:	be 00 00 00 00       	mov    $0x0,%esi
  802afc:	bf 04 00 00 00       	mov    $0x4,%edi
  802b01:	48 b8 e0 27 80 00 00 	movabs $0x8027e0,%rax
  802b08:	00 00 00 
  802b0b:	ff d0                	callq  *%rax
  802b0d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b10:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b14:	7f 20                	jg     802b36 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802b16:	48 bf 16 48 80 00 00 	movabs $0x804816,%rdi
  802b1d:	00 00 00 
  802b20:	b8 00 00 00 00       	mov    $0x0,%eax
  802b25:	48 ba 5e 06 80 00 00 	movabs $0x80065e,%rdx
  802b2c:	00 00 00 
  802b2f:	ff d2                	callq  *%rdx
		return r;
  802b31:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b34:	eb 03                	jmp    802b39 <devfile_write+0xcb>
	}
	return r;
  802b36:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802b39:	c9                   	leaveq 
  802b3a:	c3                   	retq   

0000000000802b3b <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802b3b:	55                   	push   %rbp
  802b3c:	48 89 e5             	mov    %rsp,%rbp
  802b3f:	48 83 ec 20          	sub    $0x20,%rsp
  802b43:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b47:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802b4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b4f:	8b 50 0c             	mov    0xc(%rax),%edx
  802b52:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b59:	00 00 00 
  802b5c:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802b5e:	be 00 00 00 00       	mov    $0x0,%esi
  802b63:	bf 05 00 00 00       	mov    $0x5,%edi
  802b68:	48 b8 e0 27 80 00 00 	movabs $0x8027e0,%rax
  802b6f:	00 00 00 
  802b72:	ff d0                	callq  *%rax
  802b74:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b77:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b7b:	79 05                	jns    802b82 <devfile_stat+0x47>
		return r;
  802b7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b80:	eb 56                	jmp    802bd8 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802b82:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b86:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802b8d:	00 00 00 
  802b90:	48 89 c7             	mov    %rax,%rdi
  802b93:	48 b8 13 12 80 00 00 	movabs $0x801213,%rax
  802b9a:	00 00 00 
  802b9d:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802b9f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ba6:	00 00 00 
  802ba9:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802baf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bb3:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802bb9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802bc0:	00 00 00 
  802bc3:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802bc9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bcd:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802bd3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bd8:	c9                   	leaveq 
  802bd9:	c3                   	retq   

0000000000802bda <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802bda:	55                   	push   %rbp
  802bdb:	48 89 e5             	mov    %rsp,%rbp
  802bde:	48 83 ec 10          	sub    $0x10,%rsp
  802be2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802be6:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802be9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bed:	8b 50 0c             	mov    0xc(%rax),%edx
  802bf0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802bf7:	00 00 00 
  802bfa:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802bfc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c03:	00 00 00 
  802c06:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802c09:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802c0c:	be 00 00 00 00       	mov    $0x0,%esi
  802c11:	bf 02 00 00 00       	mov    $0x2,%edi
  802c16:	48 b8 e0 27 80 00 00 	movabs $0x8027e0,%rax
  802c1d:	00 00 00 
  802c20:	ff d0                	callq  *%rax
}
  802c22:	c9                   	leaveq 
  802c23:	c3                   	retq   

0000000000802c24 <remove>:

// Delete a file
int
remove(const char *path)
{
  802c24:	55                   	push   %rbp
  802c25:	48 89 e5             	mov    %rsp,%rbp
  802c28:	48 83 ec 10          	sub    $0x10,%rsp
  802c2c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802c30:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c34:	48 89 c7             	mov    %rax,%rdi
  802c37:	48 b8 a7 11 80 00 00 	movabs $0x8011a7,%rax
  802c3e:	00 00 00 
  802c41:	ff d0                	callq  *%rax
  802c43:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802c48:	7e 07                	jle    802c51 <remove+0x2d>
		return -E_BAD_PATH;
  802c4a:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802c4f:	eb 33                	jmp    802c84 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802c51:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c55:	48 89 c6             	mov    %rax,%rsi
  802c58:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802c5f:	00 00 00 
  802c62:	48 b8 13 12 80 00 00 	movabs $0x801213,%rax
  802c69:	00 00 00 
  802c6c:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802c6e:	be 00 00 00 00       	mov    $0x0,%esi
  802c73:	bf 07 00 00 00       	mov    $0x7,%edi
  802c78:	48 b8 e0 27 80 00 00 	movabs $0x8027e0,%rax
  802c7f:	00 00 00 
  802c82:	ff d0                	callq  *%rax
}
  802c84:	c9                   	leaveq 
  802c85:	c3                   	retq   

0000000000802c86 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802c86:	55                   	push   %rbp
  802c87:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802c8a:	be 00 00 00 00       	mov    $0x0,%esi
  802c8f:	bf 08 00 00 00       	mov    $0x8,%edi
  802c94:	48 b8 e0 27 80 00 00 	movabs $0x8027e0,%rax
  802c9b:	00 00 00 
  802c9e:	ff d0                	callq  *%rax
}
  802ca0:	5d                   	pop    %rbp
  802ca1:	c3                   	retq   

0000000000802ca2 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802ca2:	55                   	push   %rbp
  802ca3:	48 89 e5             	mov    %rsp,%rbp
  802ca6:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802cad:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802cb4:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802cbb:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802cc2:	be 00 00 00 00       	mov    $0x0,%esi
  802cc7:	48 89 c7             	mov    %rax,%rdi
  802cca:	48 b8 67 28 80 00 00 	movabs $0x802867,%rax
  802cd1:	00 00 00 
  802cd4:	ff d0                	callq  *%rax
  802cd6:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802cd9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cdd:	79 28                	jns    802d07 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802cdf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ce2:	89 c6                	mov    %eax,%esi
  802ce4:	48 bf 32 48 80 00 00 	movabs $0x804832,%rdi
  802ceb:	00 00 00 
  802cee:	b8 00 00 00 00       	mov    $0x0,%eax
  802cf3:	48 ba 5e 06 80 00 00 	movabs $0x80065e,%rdx
  802cfa:	00 00 00 
  802cfd:	ff d2                	callq  *%rdx
		return fd_src;
  802cff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d02:	e9 74 01 00 00       	jmpq   802e7b <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802d07:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802d0e:	be 01 01 00 00       	mov    $0x101,%esi
  802d13:	48 89 c7             	mov    %rax,%rdi
  802d16:	48 b8 67 28 80 00 00 	movabs $0x802867,%rax
  802d1d:	00 00 00 
  802d20:	ff d0                	callq  *%rax
  802d22:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802d25:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802d29:	79 39                	jns    802d64 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802d2b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d2e:	89 c6                	mov    %eax,%esi
  802d30:	48 bf 48 48 80 00 00 	movabs $0x804848,%rdi
  802d37:	00 00 00 
  802d3a:	b8 00 00 00 00       	mov    $0x0,%eax
  802d3f:	48 ba 5e 06 80 00 00 	movabs $0x80065e,%rdx
  802d46:	00 00 00 
  802d49:	ff d2                	callq  *%rdx
		close(fd_src);
  802d4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d4e:	89 c7                	mov    %eax,%edi
  802d50:	48 b8 6f 21 80 00 00 	movabs $0x80216f,%rax
  802d57:	00 00 00 
  802d5a:	ff d0                	callq  *%rax
		return fd_dest;
  802d5c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d5f:	e9 17 01 00 00       	jmpq   802e7b <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802d64:	eb 74                	jmp    802dda <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802d66:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d69:	48 63 d0             	movslq %eax,%rdx
  802d6c:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802d73:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d76:	48 89 ce             	mov    %rcx,%rsi
  802d79:	89 c7                	mov    %eax,%edi
  802d7b:	48 b8 db 24 80 00 00 	movabs $0x8024db,%rax
  802d82:	00 00 00 
  802d85:	ff d0                	callq  *%rax
  802d87:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802d8a:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802d8e:	79 4a                	jns    802dda <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802d90:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802d93:	89 c6                	mov    %eax,%esi
  802d95:	48 bf 62 48 80 00 00 	movabs $0x804862,%rdi
  802d9c:	00 00 00 
  802d9f:	b8 00 00 00 00       	mov    $0x0,%eax
  802da4:	48 ba 5e 06 80 00 00 	movabs $0x80065e,%rdx
  802dab:	00 00 00 
  802dae:	ff d2                	callq  *%rdx
			close(fd_src);
  802db0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802db3:	89 c7                	mov    %eax,%edi
  802db5:	48 b8 6f 21 80 00 00 	movabs $0x80216f,%rax
  802dbc:	00 00 00 
  802dbf:	ff d0                	callq  *%rax
			close(fd_dest);
  802dc1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802dc4:	89 c7                	mov    %eax,%edi
  802dc6:	48 b8 6f 21 80 00 00 	movabs $0x80216f,%rax
  802dcd:	00 00 00 
  802dd0:	ff d0                	callq  *%rax
			return write_size;
  802dd2:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802dd5:	e9 a1 00 00 00       	jmpq   802e7b <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802dda:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802de1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802de4:	ba 00 02 00 00       	mov    $0x200,%edx
  802de9:	48 89 ce             	mov    %rcx,%rsi
  802dec:	89 c7                	mov    %eax,%edi
  802dee:	48 b8 91 23 80 00 00 	movabs $0x802391,%rax
  802df5:	00 00 00 
  802df8:	ff d0                	callq  *%rax
  802dfa:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802dfd:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802e01:	0f 8f 5f ff ff ff    	jg     802d66 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802e07:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802e0b:	79 47                	jns    802e54 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802e0d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e10:	89 c6                	mov    %eax,%esi
  802e12:	48 bf 75 48 80 00 00 	movabs $0x804875,%rdi
  802e19:	00 00 00 
  802e1c:	b8 00 00 00 00       	mov    $0x0,%eax
  802e21:	48 ba 5e 06 80 00 00 	movabs $0x80065e,%rdx
  802e28:	00 00 00 
  802e2b:	ff d2                	callq  *%rdx
		close(fd_src);
  802e2d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e30:	89 c7                	mov    %eax,%edi
  802e32:	48 b8 6f 21 80 00 00 	movabs $0x80216f,%rax
  802e39:	00 00 00 
  802e3c:	ff d0                	callq  *%rax
		close(fd_dest);
  802e3e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e41:	89 c7                	mov    %eax,%edi
  802e43:	48 b8 6f 21 80 00 00 	movabs $0x80216f,%rax
  802e4a:	00 00 00 
  802e4d:	ff d0                	callq  *%rax
		return read_size;
  802e4f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e52:	eb 27                	jmp    802e7b <copy+0x1d9>
	}
	close(fd_src);
  802e54:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e57:	89 c7                	mov    %eax,%edi
  802e59:	48 b8 6f 21 80 00 00 	movabs $0x80216f,%rax
  802e60:	00 00 00 
  802e63:	ff d0                	callq  *%rax
	close(fd_dest);
  802e65:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e68:	89 c7                	mov    %eax,%edi
  802e6a:	48 b8 6f 21 80 00 00 	movabs $0x80216f,%rax
  802e71:	00 00 00 
  802e74:	ff d0                	callq  *%rax
	return 0;
  802e76:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802e7b:	c9                   	leaveq 
  802e7c:	c3                   	retq   

0000000000802e7d <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802e7d:	55                   	push   %rbp
  802e7e:	48 89 e5             	mov    %rsp,%rbp
  802e81:	48 83 ec 20          	sub    $0x20,%rsp
  802e85:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802e88:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e8c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e8f:	48 89 d6             	mov    %rdx,%rsi
  802e92:	89 c7                	mov    %eax,%edi
  802e94:	48 b8 5f 1f 80 00 00 	movabs $0x801f5f,%rax
  802e9b:	00 00 00 
  802e9e:	ff d0                	callq  *%rax
  802ea0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ea3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ea7:	79 05                	jns    802eae <fd2sockid+0x31>
		return r;
  802ea9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eac:	eb 24                	jmp    802ed2 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802eae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eb2:	8b 10                	mov    (%rax),%edx
  802eb4:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802ebb:	00 00 00 
  802ebe:	8b 00                	mov    (%rax),%eax
  802ec0:	39 c2                	cmp    %eax,%edx
  802ec2:	74 07                	je     802ecb <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802ec4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ec9:	eb 07                	jmp    802ed2 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802ecb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ecf:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802ed2:	c9                   	leaveq 
  802ed3:	c3                   	retq   

0000000000802ed4 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802ed4:	55                   	push   %rbp
  802ed5:	48 89 e5             	mov    %rsp,%rbp
  802ed8:	48 83 ec 20          	sub    $0x20,%rsp
  802edc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802edf:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802ee3:	48 89 c7             	mov    %rax,%rdi
  802ee6:	48 b8 c7 1e 80 00 00 	movabs $0x801ec7,%rax
  802eed:	00 00 00 
  802ef0:	ff d0                	callq  *%rax
  802ef2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ef5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ef9:	78 26                	js     802f21 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802efb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eff:	ba 07 04 00 00       	mov    $0x407,%edx
  802f04:	48 89 c6             	mov    %rax,%rsi
  802f07:	bf 00 00 00 00       	mov    $0x0,%edi
  802f0c:	48 b8 42 1b 80 00 00 	movabs $0x801b42,%rax
  802f13:	00 00 00 
  802f16:	ff d0                	callq  *%rax
  802f18:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f1b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f1f:	79 16                	jns    802f37 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802f21:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f24:	89 c7                	mov    %eax,%edi
  802f26:	48 b8 e1 33 80 00 00 	movabs $0x8033e1,%rax
  802f2d:	00 00 00 
  802f30:	ff d0                	callq  *%rax
		return r;
  802f32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f35:	eb 3a                	jmp    802f71 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802f37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f3b:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802f42:	00 00 00 
  802f45:	8b 12                	mov    (%rdx),%edx
  802f47:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802f49:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f4d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802f54:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f58:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802f5b:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802f5e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f62:	48 89 c7             	mov    %rax,%rdi
  802f65:	48 b8 79 1e 80 00 00 	movabs $0x801e79,%rax
  802f6c:	00 00 00 
  802f6f:	ff d0                	callq  *%rax
}
  802f71:	c9                   	leaveq 
  802f72:	c3                   	retq   

0000000000802f73 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802f73:	55                   	push   %rbp
  802f74:	48 89 e5             	mov    %rsp,%rbp
  802f77:	48 83 ec 30          	sub    $0x30,%rsp
  802f7b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f7e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f82:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802f86:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f89:	89 c7                	mov    %eax,%edi
  802f8b:	48 b8 7d 2e 80 00 00 	movabs $0x802e7d,%rax
  802f92:	00 00 00 
  802f95:	ff d0                	callq  *%rax
  802f97:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f9a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f9e:	79 05                	jns    802fa5 <accept+0x32>
		return r;
  802fa0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fa3:	eb 3b                	jmp    802fe0 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802fa5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802fa9:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802fad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fb0:	48 89 ce             	mov    %rcx,%rsi
  802fb3:	89 c7                	mov    %eax,%edi
  802fb5:	48 b8 be 32 80 00 00 	movabs $0x8032be,%rax
  802fbc:	00 00 00 
  802fbf:	ff d0                	callq  *%rax
  802fc1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fc4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fc8:	79 05                	jns    802fcf <accept+0x5c>
		return r;
  802fca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fcd:	eb 11                	jmp    802fe0 <accept+0x6d>
	return alloc_sockfd(r);
  802fcf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fd2:	89 c7                	mov    %eax,%edi
  802fd4:	48 b8 d4 2e 80 00 00 	movabs $0x802ed4,%rax
  802fdb:	00 00 00 
  802fde:	ff d0                	callq  *%rax
}
  802fe0:	c9                   	leaveq 
  802fe1:	c3                   	retq   

0000000000802fe2 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802fe2:	55                   	push   %rbp
  802fe3:	48 89 e5             	mov    %rsp,%rbp
  802fe6:	48 83 ec 20          	sub    $0x20,%rsp
  802fea:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fed:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ff1:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802ff4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ff7:	89 c7                	mov    %eax,%edi
  802ff9:	48 b8 7d 2e 80 00 00 	movabs $0x802e7d,%rax
  803000:	00 00 00 
  803003:	ff d0                	callq  *%rax
  803005:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803008:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80300c:	79 05                	jns    803013 <bind+0x31>
		return r;
  80300e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803011:	eb 1b                	jmp    80302e <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803013:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803016:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80301a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80301d:	48 89 ce             	mov    %rcx,%rsi
  803020:	89 c7                	mov    %eax,%edi
  803022:	48 b8 3d 33 80 00 00 	movabs $0x80333d,%rax
  803029:	00 00 00 
  80302c:	ff d0                	callq  *%rax
}
  80302e:	c9                   	leaveq 
  80302f:	c3                   	retq   

0000000000803030 <shutdown>:

int
shutdown(int s, int how)
{
  803030:	55                   	push   %rbp
  803031:	48 89 e5             	mov    %rsp,%rbp
  803034:	48 83 ec 20          	sub    $0x20,%rsp
  803038:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80303b:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80303e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803041:	89 c7                	mov    %eax,%edi
  803043:	48 b8 7d 2e 80 00 00 	movabs $0x802e7d,%rax
  80304a:	00 00 00 
  80304d:	ff d0                	callq  *%rax
  80304f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803052:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803056:	79 05                	jns    80305d <shutdown+0x2d>
		return r;
  803058:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80305b:	eb 16                	jmp    803073 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  80305d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803060:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803063:	89 d6                	mov    %edx,%esi
  803065:	89 c7                	mov    %eax,%edi
  803067:	48 b8 a1 33 80 00 00 	movabs $0x8033a1,%rax
  80306e:	00 00 00 
  803071:	ff d0                	callq  *%rax
}
  803073:	c9                   	leaveq 
  803074:	c3                   	retq   

0000000000803075 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803075:	55                   	push   %rbp
  803076:	48 89 e5             	mov    %rsp,%rbp
  803079:	48 83 ec 10          	sub    $0x10,%rsp
  80307d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803081:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803085:	48 89 c7             	mov    %rax,%rdi
  803088:	48 b8 ef 40 80 00 00 	movabs $0x8040ef,%rax
  80308f:	00 00 00 
  803092:	ff d0                	callq  *%rax
  803094:	83 f8 01             	cmp    $0x1,%eax
  803097:	75 17                	jne    8030b0 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803099:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80309d:	8b 40 0c             	mov    0xc(%rax),%eax
  8030a0:	89 c7                	mov    %eax,%edi
  8030a2:	48 b8 e1 33 80 00 00 	movabs $0x8033e1,%rax
  8030a9:	00 00 00 
  8030ac:	ff d0                	callq  *%rax
  8030ae:	eb 05                	jmp    8030b5 <devsock_close+0x40>
	else
		return 0;
  8030b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030b5:	c9                   	leaveq 
  8030b6:	c3                   	retq   

00000000008030b7 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8030b7:	55                   	push   %rbp
  8030b8:	48 89 e5             	mov    %rsp,%rbp
  8030bb:	48 83 ec 20          	sub    $0x20,%rsp
  8030bf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8030c2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030c6:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8030c9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030cc:	89 c7                	mov    %eax,%edi
  8030ce:	48 b8 7d 2e 80 00 00 	movabs $0x802e7d,%rax
  8030d5:	00 00 00 
  8030d8:	ff d0                	callq  *%rax
  8030da:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030e1:	79 05                	jns    8030e8 <connect+0x31>
		return r;
  8030e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030e6:	eb 1b                	jmp    803103 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8030e8:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8030eb:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8030ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030f2:	48 89 ce             	mov    %rcx,%rsi
  8030f5:	89 c7                	mov    %eax,%edi
  8030f7:	48 b8 0e 34 80 00 00 	movabs $0x80340e,%rax
  8030fe:	00 00 00 
  803101:	ff d0                	callq  *%rax
}
  803103:	c9                   	leaveq 
  803104:	c3                   	retq   

0000000000803105 <listen>:

int
listen(int s, int backlog)
{
  803105:	55                   	push   %rbp
  803106:	48 89 e5             	mov    %rsp,%rbp
  803109:	48 83 ec 20          	sub    $0x20,%rsp
  80310d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803110:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803113:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803116:	89 c7                	mov    %eax,%edi
  803118:	48 b8 7d 2e 80 00 00 	movabs $0x802e7d,%rax
  80311f:	00 00 00 
  803122:	ff d0                	callq  *%rax
  803124:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803127:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80312b:	79 05                	jns    803132 <listen+0x2d>
		return r;
  80312d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803130:	eb 16                	jmp    803148 <listen+0x43>
	return nsipc_listen(r, backlog);
  803132:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803135:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803138:	89 d6                	mov    %edx,%esi
  80313a:	89 c7                	mov    %eax,%edi
  80313c:	48 b8 72 34 80 00 00 	movabs $0x803472,%rax
  803143:	00 00 00 
  803146:	ff d0                	callq  *%rax
}
  803148:	c9                   	leaveq 
  803149:	c3                   	retq   

000000000080314a <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80314a:	55                   	push   %rbp
  80314b:	48 89 e5             	mov    %rsp,%rbp
  80314e:	48 83 ec 20          	sub    $0x20,%rsp
  803152:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803156:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80315a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80315e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803162:	89 c2                	mov    %eax,%edx
  803164:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803168:	8b 40 0c             	mov    0xc(%rax),%eax
  80316b:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80316f:	b9 00 00 00 00       	mov    $0x0,%ecx
  803174:	89 c7                	mov    %eax,%edi
  803176:	48 b8 b2 34 80 00 00 	movabs $0x8034b2,%rax
  80317d:	00 00 00 
  803180:	ff d0                	callq  *%rax
}
  803182:	c9                   	leaveq 
  803183:	c3                   	retq   

0000000000803184 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803184:	55                   	push   %rbp
  803185:	48 89 e5             	mov    %rsp,%rbp
  803188:	48 83 ec 20          	sub    $0x20,%rsp
  80318c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803190:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803194:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803198:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80319c:	89 c2                	mov    %eax,%edx
  80319e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031a2:	8b 40 0c             	mov    0xc(%rax),%eax
  8031a5:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8031a9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8031ae:	89 c7                	mov    %eax,%edi
  8031b0:	48 b8 7e 35 80 00 00 	movabs $0x80357e,%rax
  8031b7:	00 00 00 
  8031ba:	ff d0                	callq  *%rax
}
  8031bc:	c9                   	leaveq 
  8031bd:	c3                   	retq   

00000000008031be <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8031be:	55                   	push   %rbp
  8031bf:	48 89 e5             	mov    %rsp,%rbp
  8031c2:	48 83 ec 10          	sub    $0x10,%rsp
  8031c6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8031ca:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8031ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031d2:	48 be 90 48 80 00 00 	movabs $0x804890,%rsi
  8031d9:	00 00 00 
  8031dc:	48 89 c7             	mov    %rax,%rdi
  8031df:	48 b8 13 12 80 00 00 	movabs $0x801213,%rax
  8031e6:	00 00 00 
  8031e9:	ff d0                	callq  *%rax
	return 0;
  8031eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031f0:	c9                   	leaveq 
  8031f1:	c3                   	retq   

00000000008031f2 <socket>:

int
socket(int domain, int type, int protocol)
{
  8031f2:	55                   	push   %rbp
  8031f3:	48 89 e5             	mov    %rsp,%rbp
  8031f6:	48 83 ec 20          	sub    $0x20,%rsp
  8031fa:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8031fd:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803200:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803203:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803206:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803209:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80320c:	89 ce                	mov    %ecx,%esi
  80320e:	89 c7                	mov    %eax,%edi
  803210:	48 b8 36 36 80 00 00 	movabs $0x803636,%rax
  803217:	00 00 00 
  80321a:	ff d0                	callq  *%rax
  80321c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80321f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803223:	79 05                	jns    80322a <socket+0x38>
		return r;
  803225:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803228:	eb 11                	jmp    80323b <socket+0x49>
	return alloc_sockfd(r);
  80322a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80322d:	89 c7                	mov    %eax,%edi
  80322f:	48 b8 d4 2e 80 00 00 	movabs $0x802ed4,%rax
  803236:	00 00 00 
  803239:	ff d0                	callq  *%rax
}
  80323b:	c9                   	leaveq 
  80323c:	c3                   	retq   

000000000080323d <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80323d:	55                   	push   %rbp
  80323e:	48 89 e5             	mov    %rsp,%rbp
  803241:	48 83 ec 10          	sub    $0x10,%rsp
  803245:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803248:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80324f:	00 00 00 
  803252:	8b 00                	mov    (%rax),%eax
  803254:	85 c0                	test   %eax,%eax
  803256:	75 1d                	jne    803275 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803258:	bf 02 00 00 00       	mov    $0x2,%edi
  80325d:	48 b8 6d 40 80 00 00 	movabs $0x80406d,%rax
  803264:	00 00 00 
  803267:	ff d0                	callq  *%rax
  803269:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  803270:	00 00 00 
  803273:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803275:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80327c:	00 00 00 
  80327f:	8b 00                	mov    (%rax),%eax
  803281:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803284:	b9 07 00 00 00       	mov    $0x7,%ecx
  803289:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  803290:	00 00 00 
  803293:	89 c7                	mov    %eax,%edi
  803295:	48 b8 0b 40 80 00 00 	movabs $0x80400b,%rax
  80329c:	00 00 00 
  80329f:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8032a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8032a6:	be 00 00 00 00       	mov    $0x0,%esi
  8032ab:	bf 00 00 00 00       	mov    $0x0,%edi
  8032b0:	48 b8 05 3f 80 00 00 	movabs $0x803f05,%rax
  8032b7:	00 00 00 
  8032ba:	ff d0                	callq  *%rax
}
  8032bc:	c9                   	leaveq 
  8032bd:	c3                   	retq   

00000000008032be <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8032be:	55                   	push   %rbp
  8032bf:	48 89 e5             	mov    %rsp,%rbp
  8032c2:	48 83 ec 30          	sub    $0x30,%rsp
  8032c6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8032c9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8032cd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8032d1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032d8:	00 00 00 
  8032db:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8032de:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8032e0:	bf 01 00 00 00       	mov    $0x1,%edi
  8032e5:	48 b8 3d 32 80 00 00 	movabs $0x80323d,%rax
  8032ec:	00 00 00 
  8032ef:	ff d0                	callq  *%rax
  8032f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032f8:	78 3e                	js     803338 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8032fa:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803301:	00 00 00 
  803304:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803308:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80330c:	8b 40 10             	mov    0x10(%rax),%eax
  80330f:	89 c2                	mov    %eax,%edx
  803311:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803315:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803319:	48 89 ce             	mov    %rcx,%rsi
  80331c:	48 89 c7             	mov    %rax,%rdi
  80331f:	48 b8 37 15 80 00 00 	movabs $0x801537,%rax
  803326:	00 00 00 
  803329:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  80332b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80332f:	8b 50 10             	mov    0x10(%rax),%edx
  803332:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803336:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803338:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80333b:	c9                   	leaveq 
  80333c:	c3                   	retq   

000000000080333d <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80333d:	55                   	push   %rbp
  80333e:	48 89 e5             	mov    %rsp,%rbp
  803341:	48 83 ec 10          	sub    $0x10,%rsp
  803345:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803348:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80334c:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  80334f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803356:	00 00 00 
  803359:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80335c:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80335e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803361:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803365:	48 89 c6             	mov    %rax,%rsi
  803368:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80336f:	00 00 00 
  803372:	48 b8 37 15 80 00 00 	movabs $0x801537,%rax
  803379:	00 00 00 
  80337c:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  80337e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803385:	00 00 00 
  803388:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80338b:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  80338e:	bf 02 00 00 00       	mov    $0x2,%edi
  803393:	48 b8 3d 32 80 00 00 	movabs $0x80323d,%rax
  80339a:	00 00 00 
  80339d:	ff d0                	callq  *%rax
}
  80339f:	c9                   	leaveq 
  8033a0:	c3                   	retq   

00000000008033a1 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8033a1:	55                   	push   %rbp
  8033a2:	48 89 e5             	mov    %rsp,%rbp
  8033a5:	48 83 ec 10          	sub    $0x10,%rsp
  8033a9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8033ac:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8033af:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033b6:	00 00 00 
  8033b9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8033bc:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8033be:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033c5:	00 00 00 
  8033c8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8033cb:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8033ce:	bf 03 00 00 00       	mov    $0x3,%edi
  8033d3:	48 b8 3d 32 80 00 00 	movabs $0x80323d,%rax
  8033da:	00 00 00 
  8033dd:	ff d0                	callq  *%rax
}
  8033df:	c9                   	leaveq 
  8033e0:	c3                   	retq   

00000000008033e1 <nsipc_close>:

int
nsipc_close(int s)
{
  8033e1:	55                   	push   %rbp
  8033e2:	48 89 e5             	mov    %rsp,%rbp
  8033e5:	48 83 ec 10          	sub    $0x10,%rsp
  8033e9:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8033ec:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033f3:	00 00 00 
  8033f6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8033f9:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8033fb:	bf 04 00 00 00       	mov    $0x4,%edi
  803400:	48 b8 3d 32 80 00 00 	movabs $0x80323d,%rax
  803407:	00 00 00 
  80340a:	ff d0                	callq  *%rax
}
  80340c:	c9                   	leaveq 
  80340d:	c3                   	retq   

000000000080340e <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80340e:	55                   	push   %rbp
  80340f:	48 89 e5             	mov    %rsp,%rbp
  803412:	48 83 ec 10          	sub    $0x10,%rsp
  803416:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803419:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80341d:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803420:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803427:	00 00 00 
  80342a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80342d:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80342f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803432:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803436:	48 89 c6             	mov    %rax,%rsi
  803439:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803440:	00 00 00 
  803443:	48 b8 37 15 80 00 00 	movabs $0x801537,%rax
  80344a:	00 00 00 
  80344d:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  80344f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803456:	00 00 00 
  803459:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80345c:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  80345f:	bf 05 00 00 00       	mov    $0x5,%edi
  803464:	48 b8 3d 32 80 00 00 	movabs $0x80323d,%rax
  80346b:	00 00 00 
  80346e:	ff d0                	callq  *%rax
}
  803470:	c9                   	leaveq 
  803471:	c3                   	retq   

0000000000803472 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803472:	55                   	push   %rbp
  803473:	48 89 e5             	mov    %rsp,%rbp
  803476:	48 83 ec 10          	sub    $0x10,%rsp
  80347a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80347d:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803480:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803487:	00 00 00 
  80348a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80348d:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  80348f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803496:	00 00 00 
  803499:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80349c:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  80349f:	bf 06 00 00 00       	mov    $0x6,%edi
  8034a4:	48 b8 3d 32 80 00 00 	movabs $0x80323d,%rax
  8034ab:	00 00 00 
  8034ae:	ff d0                	callq  *%rax
}
  8034b0:	c9                   	leaveq 
  8034b1:	c3                   	retq   

00000000008034b2 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8034b2:	55                   	push   %rbp
  8034b3:	48 89 e5             	mov    %rsp,%rbp
  8034b6:	48 83 ec 30          	sub    $0x30,%rsp
  8034ba:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8034bd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8034c1:	89 55 e8             	mov    %edx,-0x18(%rbp)
  8034c4:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  8034c7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034ce:	00 00 00 
  8034d1:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8034d4:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8034d6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034dd:	00 00 00 
  8034e0:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8034e3:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8034e6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034ed:	00 00 00 
  8034f0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8034f3:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8034f6:	bf 07 00 00 00       	mov    $0x7,%edi
  8034fb:	48 b8 3d 32 80 00 00 	movabs $0x80323d,%rax
  803502:	00 00 00 
  803505:	ff d0                	callq  *%rax
  803507:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80350a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80350e:	78 69                	js     803579 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803510:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803517:	7f 08                	jg     803521 <nsipc_recv+0x6f>
  803519:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80351c:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  80351f:	7e 35                	jle    803556 <nsipc_recv+0xa4>
  803521:	48 b9 97 48 80 00 00 	movabs $0x804897,%rcx
  803528:	00 00 00 
  80352b:	48 ba ac 48 80 00 00 	movabs $0x8048ac,%rdx
  803532:	00 00 00 
  803535:	be 61 00 00 00       	mov    $0x61,%esi
  80353a:	48 bf c1 48 80 00 00 	movabs $0x8048c1,%rdi
  803541:	00 00 00 
  803544:	b8 00 00 00 00       	mov    $0x0,%eax
  803549:	49 b8 25 04 80 00 00 	movabs $0x800425,%r8
  803550:	00 00 00 
  803553:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803556:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803559:	48 63 d0             	movslq %eax,%rdx
  80355c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803560:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803567:	00 00 00 
  80356a:	48 89 c7             	mov    %rax,%rdi
  80356d:	48 b8 37 15 80 00 00 	movabs $0x801537,%rax
  803574:	00 00 00 
  803577:	ff d0                	callq  *%rax
	}

	return r;
  803579:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80357c:	c9                   	leaveq 
  80357d:	c3                   	retq   

000000000080357e <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80357e:	55                   	push   %rbp
  80357f:	48 89 e5             	mov    %rsp,%rbp
  803582:	48 83 ec 20          	sub    $0x20,%rsp
  803586:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803589:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80358d:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803590:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803593:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80359a:	00 00 00 
  80359d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8035a0:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8035a2:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  8035a9:	7e 35                	jle    8035e0 <nsipc_send+0x62>
  8035ab:	48 b9 cd 48 80 00 00 	movabs $0x8048cd,%rcx
  8035b2:	00 00 00 
  8035b5:	48 ba ac 48 80 00 00 	movabs $0x8048ac,%rdx
  8035bc:	00 00 00 
  8035bf:	be 6c 00 00 00       	mov    $0x6c,%esi
  8035c4:	48 bf c1 48 80 00 00 	movabs $0x8048c1,%rdi
  8035cb:	00 00 00 
  8035ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8035d3:	49 b8 25 04 80 00 00 	movabs $0x800425,%r8
  8035da:	00 00 00 
  8035dd:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8035e0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035e3:	48 63 d0             	movslq %eax,%rdx
  8035e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035ea:	48 89 c6             	mov    %rax,%rsi
  8035ed:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  8035f4:	00 00 00 
  8035f7:	48 b8 37 15 80 00 00 	movabs $0x801537,%rax
  8035fe:	00 00 00 
  803601:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803603:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80360a:	00 00 00 
  80360d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803610:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803613:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80361a:	00 00 00 
  80361d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803620:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803623:	bf 08 00 00 00       	mov    $0x8,%edi
  803628:	48 b8 3d 32 80 00 00 	movabs $0x80323d,%rax
  80362f:	00 00 00 
  803632:	ff d0                	callq  *%rax
}
  803634:	c9                   	leaveq 
  803635:	c3                   	retq   

0000000000803636 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803636:	55                   	push   %rbp
  803637:	48 89 e5             	mov    %rsp,%rbp
  80363a:	48 83 ec 10          	sub    $0x10,%rsp
  80363e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803641:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803644:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803647:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80364e:	00 00 00 
  803651:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803654:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803656:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80365d:	00 00 00 
  803660:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803663:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803666:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80366d:	00 00 00 
  803670:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803673:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803676:	bf 09 00 00 00       	mov    $0x9,%edi
  80367b:	48 b8 3d 32 80 00 00 	movabs $0x80323d,%rax
  803682:	00 00 00 
  803685:	ff d0                	callq  *%rax
}
  803687:	c9                   	leaveq 
  803688:	c3                   	retq   

0000000000803689 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803689:	55                   	push   %rbp
  80368a:	48 89 e5             	mov    %rsp,%rbp
  80368d:	53                   	push   %rbx
  80368e:	48 83 ec 38          	sub    $0x38,%rsp
  803692:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803696:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80369a:	48 89 c7             	mov    %rax,%rdi
  80369d:	48 b8 c7 1e 80 00 00 	movabs $0x801ec7,%rax
  8036a4:	00 00 00 
  8036a7:	ff d0                	callq  *%rax
  8036a9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036ac:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036b0:	0f 88 bf 01 00 00    	js     803875 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8036b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036ba:	ba 07 04 00 00       	mov    $0x407,%edx
  8036bf:	48 89 c6             	mov    %rax,%rsi
  8036c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8036c7:	48 b8 42 1b 80 00 00 	movabs $0x801b42,%rax
  8036ce:	00 00 00 
  8036d1:	ff d0                	callq  *%rax
  8036d3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036da:	0f 88 95 01 00 00    	js     803875 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8036e0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8036e4:	48 89 c7             	mov    %rax,%rdi
  8036e7:	48 b8 c7 1e 80 00 00 	movabs $0x801ec7,%rax
  8036ee:	00 00 00 
  8036f1:	ff d0                	callq  *%rax
  8036f3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036f6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036fa:	0f 88 5d 01 00 00    	js     80385d <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803700:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803704:	ba 07 04 00 00       	mov    $0x407,%edx
  803709:	48 89 c6             	mov    %rax,%rsi
  80370c:	bf 00 00 00 00       	mov    $0x0,%edi
  803711:	48 b8 42 1b 80 00 00 	movabs $0x801b42,%rax
  803718:	00 00 00 
  80371b:	ff d0                	callq  *%rax
  80371d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803720:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803724:	0f 88 33 01 00 00    	js     80385d <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80372a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80372e:	48 89 c7             	mov    %rax,%rdi
  803731:	48 b8 9c 1e 80 00 00 	movabs $0x801e9c,%rax
  803738:	00 00 00 
  80373b:	ff d0                	callq  *%rax
  80373d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803741:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803745:	ba 07 04 00 00       	mov    $0x407,%edx
  80374a:	48 89 c6             	mov    %rax,%rsi
  80374d:	bf 00 00 00 00       	mov    $0x0,%edi
  803752:	48 b8 42 1b 80 00 00 	movabs $0x801b42,%rax
  803759:	00 00 00 
  80375c:	ff d0                	callq  *%rax
  80375e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803761:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803765:	79 05                	jns    80376c <pipe+0xe3>
		goto err2;
  803767:	e9 d9 00 00 00       	jmpq   803845 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80376c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803770:	48 89 c7             	mov    %rax,%rdi
  803773:	48 b8 9c 1e 80 00 00 	movabs $0x801e9c,%rax
  80377a:	00 00 00 
  80377d:	ff d0                	callq  *%rax
  80377f:	48 89 c2             	mov    %rax,%rdx
  803782:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803786:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80378c:	48 89 d1             	mov    %rdx,%rcx
  80378f:	ba 00 00 00 00       	mov    $0x0,%edx
  803794:	48 89 c6             	mov    %rax,%rsi
  803797:	bf 00 00 00 00       	mov    $0x0,%edi
  80379c:	48 b8 92 1b 80 00 00 	movabs $0x801b92,%rax
  8037a3:	00 00 00 
  8037a6:	ff d0                	callq  *%rax
  8037a8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8037ab:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037af:	79 1b                	jns    8037cc <pipe+0x143>
		goto err3;
  8037b1:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8037b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037b6:	48 89 c6             	mov    %rax,%rsi
  8037b9:	bf 00 00 00 00       	mov    $0x0,%edi
  8037be:	48 b8 ed 1b 80 00 00 	movabs $0x801bed,%rax
  8037c5:	00 00 00 
  8037c8:	ff d0                	callq  *%rax
  8037ca:	eb 79                	jmp    803845 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8037cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037d0:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8037d7:	00 00 00 
  8037da:	8b 12                	mov    (%rdx),%edx
  8037dc:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8037de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037e2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8037e9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037ed:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8037f4:	00 00 00 
  8037f7:	8b 12                	mov    (%rdx),%edx
  8037f9:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8037fb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037ff:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803806:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80380a:	48 89 c7             	mov    %rax,%rdi
  80380d:	48 b8 79 1e 80 00 00 	movabs $0x801e79,%rax
  803814:	00 00 00 
  803817:	ff d0                	callq  *%rax
  803819:	89 c2                	mov    %eax,%edx
  80381b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80381f:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803821:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803825:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803829:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80382d:	48 89 c7             	mov    %rax,%rdi
  803830:	48 b8 79 1e 80 00 00 	movabs $0x801e79,%rax
  803837:	00 00 00 
  80383a:	ff d0                	callq  *%rax
  80383c:	89 03                	mov    %eax,(%rbx)
	return 0;
  80383e:	b8 00 00 00 00       	mov    $0x0,%eax
  803843:	eb 33                	jmp    803878 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803845:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803849:	48 89 c6             	mov    %rax,%rsi
  80384c:	bf 00 00 00 00       	mov    $0x0,%edi
  803851:	48 b8 ed 1b 80 00 00 	movabs $0x801bed,%rax
  803858:	00 00 00 
  80385b:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80385d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803861:	48 89 c6             	mov    %rax,%rsi
  803864:	bf 00 00 00 00       	mov    $0x0,%edi
  803869:	48 b8 ed 1b 80 00 00 	movabs $0x801bed,%rax
  803870:	00 00 00 
  803873:	ff d0                	callq  *%rax
err:
	return r;
  803875:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803878:	48 83 c4 38          	add    $0x38,%rsp
  80387c:	5b                   	pop    %rbx
  80387d:	5d                   	pop    %rbp
  80387e:	c3                   	retq   

000000000080387f <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80387f:	55                   	push   %rbp
  803880:	48 89 e5             	mov    %rsp,%rbp
  803883:	53                   	push   %rbx
  803884:	48 83 ec 28          	sub    $0x28,%rsp
  803888:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80388c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803890:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803897:	00 00 00 
  80389a:	48 8b 00             	mov    (%rax),%rax
  80389d:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8038a3:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8038a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038aa:	48 89 c7             	mov    %rax,%rdi
  8038ad:	48 b8 ef 40 80 00 00 	movabs $0x8040ef,%rax
  8038b4:	00 00 00 
  8038b7:	ff d0                	callq  *%rax
  8038b9:	89 c3                	mov    %eax,%ebx
  8038bb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038bf:	48 89 c7             	mov    %rax,%rdi
  8038c2:	48 b8 ef 40 80 00 00 	movabs $0x8040ef,%rax
  8038c9:	00 00 00 
  8038cc:	ff d0                	callq  *%rax
  8038ce:	39 c3                	cmp    %eax,%ebx
  8038d0:	0f 94 c0             	sete   %al
  8038d3:	0f b6 c0             	movzbl %al,%eax
  8038d6:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8038d9:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8038e0:	00 00 00 
  8038e3:	48 8b 00             	mov    (%rax),%rax
  8038e6:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8038ec:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8038ef:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038f2:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8038f5:	75 05                	jne    8038fc <_pipeisclosed+0x7d>
			return ret;
  8038f7:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8038fa:	eb 4f                	jmp    80394b <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8038fc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038ff:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803902:	74 42                	je     803946 <_pipeisclosed+0xc7>
  803904:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803908:	75 3c                	jne    803946 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80390a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803911:	00 00 00 
  803914:	48 8b 00             	mov    (%rax),%rax
  803917:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80391d:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803920:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803923:	89 c6                	mov    %eax,%esi
  803925:	48 bf de 48 80 00 00 	movabs $0x8048de,%rdi
  80392c:	00 00 00 
  80392f:	b8 00 00 00 00       	mov    $0x0,%eax
  803934:	49 b8 5e 06 80 00 00 	movabs $0x80065e,%r8
  80393b:	00 00 00 
  80393e:	41 ff d0             	callq  *%r8
	}
  803941:	e9 4a ff ff ff       	jmpq   803890 <_pipeisclosed+0x11>
  803946:	e9 45 ff ff ff       	jmpq   803890 <_pipeisclosed+0x11>
}
  80394b:	48 83 c4 28          	add    $0x28,%rsp
  80394f:	5b                   	pop    %rbx
  803950:	5d                   	pop    %rbp
  803951:	c3                   	retq   

0000000000803952 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803952:	55                   	push   %rbp
  803953:	48 89 e5             	mov    %rsp,%rbp
  803956:	48 83 ec 30          	sub    $0x30,%rsp
  80395a:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80395d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803961:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803964:	48 89 d6             	mov    %rdx,%rsi
  803967:	89 c7                	mov    %eax,%edi
  803969:	48 b8 5f 1f 80 00 00 	movabs $0x801f5f,%rax
  803970:	00 00 00 
  803973:	ff d0                	callq  *%rax
  803975:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803978:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80397c:	79 05                	jns    803983 <pipeisclosed+0x31>
		return r;
  80397e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803981:	eb 31                	jmp    8039b4 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803983:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803987:	48 89 c7             	mov    %rax,%rdi
  80398a:	48 b8 9c 1e 80 00 00 	movabs $0x801e9c,%rax
  803991:	00 00 00 
  803994:	ff d0                	callq  *%rax
  803996:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80399a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80399e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039a2:	48 89 d6             	mov    %rdx,%rsi
  8039a5:	48 89 c7             	mov    %rax,%rdi
  8039a8:	48 b8 7f 38 80 00 00 	movabs $0x80387f,%rax
  8039af:	00 00 00 
  8039b2:	ff d0                	callq  *%rax
}
  8039b4:	c9                   	leaveq 
  8039b5:	c3                   	retq   

00000000008039b6 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8039b6:	55                   	push   %rbp
  8039b7:	48 89 e5             	mov    %rsp,%rbp
  8039ba:	48 83 ec 40          	sub    $0x40,%rsp
  8039be:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8039c2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8039c6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8039ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039ce:	48 89 c7             	mov    %rax,%rdi
  8039d1:	48 b8 9c 1e 80 00 00 	movabs $0x801e9c,%rax
  8039d8:	00 00 00 
  8039db:	ff d0                	callq  *%rax
  8039dd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8039e1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039e5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8039e9:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8039f0:	00 
  8039f1:	e9 92 00 00 00       	jmpq   803a88 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8039f6:	eb 41                	jmp    803a39 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8039f8:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8039fd:	74 09                	je     803a08 <devpipe_read+0x52>
				return i;
  8039ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a03:	e9 92 00 00 00       	jmpq   803a9a <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803a08:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a0c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a10:	48 89 d6             	mov    %rdx,%rsi
  803a13:	48 89 c7             	mov    %rax,%rdi
  803a16:	48 b8 7f 38 80 00 00 	movabs $0x80387f,%rax
  803a1d:	00 00 00 
  803a20:	ff d0                	callq  *%rax
  803a22:	85 c0                	test   %eax,%eax
  803a24:	74 07                	je     803a2d <devpipe_read+0x77>
				return 0;
  803a26:	b8 00 00 00 00       	mov    $0x0,%eax
  803a2b:	eb 6d                	jmp    803a9a <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803a2d:	48 b8 04 1b 80 00 00 	movabs $0x801b04,%rax
  803a34:	00 00 00 
  803a37:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803a39:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a3d:	8b 10                	mov    (%rax),%edx
  803a3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a43:	8b 40 04             	mov    0x4(%rax),%eax
  803a46:	39 c2                	cmp    %eax,%edx
  803a48:	74 ae                	je     8039f8 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803a4a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a4e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803a52:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803a56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a5a:	8b 00                	mov    (%rax),%eax
  803a5c:	99                   	cltd   
  803a5d:	c1 ea 1b             	shr    $0x1b,%edx
  803a60:	01 d0                	add    %edx,%eax
  803a62:	83 e0 1f             	and    $0x1f,%eax
  803a65:	29 d0                	sub    %edx,%eax
  803a67:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a6b:	48 98                	cltq   
  803a6d:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803a72:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803a74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a78:	8b 00                	mov    (%rax),%eax
  803a7a:	8d 50 01             	lea    0x1(%rax),%edx
  803a7d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a81:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803a83:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803a88:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a8c:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803a90:	0f 82 60 ff ff ff    	jb     8039f6 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803a96:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803a9a:	c9                   	leaveq 
  803a9b:	c3                   	retq   

0000000000803a9c <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803a9c:	55                   	push   %rbp
  803a9d:	48 89 e5             	mov    %rsp,%rbp
  803aa0:	48 83 ec 40          	sub    $0x40,%rsp
  803aa4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803aa8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803aac:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803ab0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ab4:	48 89 c7             	mov    %rax,%rdi
  803ab7:	48 b8 9c 1e 80 00 00 	movabs $0x801e9c,%rax
  803abe:	00 00 00 
  803ac1:	ff d0                	callq  *%rax
  803ac3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803ac7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803acb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803acf:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803ad6:	00 
  803ad7:	e9 8e 00 00 00       	jmpq   803b6a <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803adc:	eb 31                	jmp    803b0f <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803ade:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ae2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ae6:	48 89 d6             	mov    %rdx,%rsi
  803ae9:	48 89 c7             	mov    %rax,%rdi
  803aec:	48 b8 7f 38 80 00 00 	movabs $0x80387f,%rax
  803af3:	00 00 00 
  803af6:	ff d0                	callq  *%rax
  803af8:	85 c0                	test   %eax,%eax
  803afa:	74 07                	je     803b03 <devpipe_write+0x67>
				return 0;
  803afc:	b8 00 00 00 00       	mov    $0x0,%eax
  803b01:	eb 79                	jmp    803b7c <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803b03:	48 b8 04 1b 80 00 00 	movabs $0x801b04,%rax
  803b0a:	00 00 00 
  803b0d:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803b0f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b13:	8b 40 04             	mov    0x4(%rax),%eax
  803b16:	48 63 d0             	movslq %eax,%rdx
  803b19:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b1d:	8b 00                	mov    (%rax),%eax
  803b1f:	48 98                	cltq   
  803b21:	48 83 c0 20          	add    $0x20,%rax
  803b25:	48 39 c2             	cmp    %rax,%rdx
  803b28:	73 b4                	jae    803ade <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803b2a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b2e:	8b 40 04             	mov    0x4(%rax),%eax
  803b31:	99                   	cltd   
  803b32:	c1 ea 1b             	shr    $0x1b,%edx
  803b35:	01 d0                	add    %edx,%eax
  803b37:	83 e0 1f             	and    $0x1f,%eax
  803b3a:	29 d0                	sub    %edx,%eax
  803b3c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803b40:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803b44:	48 01 ca             	add    %rcx,%rdx
  803b47:	0f b6 0a             	movzbl (%rdx),%ecx
  803b4a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b4e:	48 98                	cltq   
  803b50:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803b54:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b58:	8b 40 04             	mov    0x4(%rax),%eax
  803b5b:	8d 50 01             	lea    0x1(%rax),%edx
  803b5e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b62:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803b65:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803b6a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b6e:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803b72:	0f 82 64 ff ff ff    	jb     803adc <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803b78:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803b7c:	c9                   	leaveq 
  803b7d:	c3                   	retq   

0000000000803b7e <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803b7e:	55                   	push   %rbp
  803b7f:	48 89 e5             	mov    %rsp,%rbp
  803b82:	48 83 ec 20          	sub    $0x20,%rsp
  803b86:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803b8a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803b8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b92:	48 89 c7             	mov    %rax,%rdi
  803b95:	48 b8 9c 1e 80 00 00 	movabs $0x801e9c,%rax
  803b9c:	00 00 00 
  803b9f:	ff d0                	callq  *%rax
  803ba1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803ba5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ba9:	48 be f1 48 80 00 00 	movabs $0x8048f1,%rsi
  803bb0:	00 00 00 
  803bb3:	48 89 c7             	mov    %rax,%rdi
  803bb6:	48 b8 13 12 80 00 00 	movabs $0x801213,%rax
  803bbd:	00 00 00 
  803bc0:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803bc2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bc6:	8b 50 04             	mov    0x4(%rax),%edx
  803bc9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bcd:	8b 00                	mov    (%rax),%eax
  803bcf:	29 c2                	sub    %eax,%edx
  803bd1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bd5:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803bdb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bdf:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803be6:	00 00 00 
	stat->st_dev = &devpipe;
  803be9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bed:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803bf4:	00 00 00 
  803bf7:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803bfe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c03:	c9                   	leaveq 
  803c04:	c3                   	retq   

0000000000803c05 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803c05:	55                   	push   %rbp
  803c06:	48 89 e5             	mov    %rsp,%rbp
  803c09:	48 83 ec 10          	sub    $0x10,%rsp
  803c0d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803c11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c15:	48 89 c6             	mov    %rax,%rsi
  803c18:	bf 00 00 00 00       	mov    $0x0,%edi
  803c1d:	48 b8 ed 1b 80 00 00 	movabs $0x801bed,%rax
  803c24:	00 00 00 
  803c27:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803c29:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c2d:	48 89 c7             	mov    %rax,%rdi
  803c30:	48 b8 9c 1e 80 00 00 	movabs $0x801e9c,%rax
  803c37:	00 00 00 
  803c3a:	ff d0                	callq  *%rax
  803c3c:	48 89 c6             	mov    %rax,%rsi
  803c3f:	bf 00 00 00 00       	mov    $0x0,%edi
  803c44:	48 b8 ed 1b 80 00 00 	movabs $0x801bed,%rax
  803c4b:	00 00 00 
  803c4e:	ff d0                	callq  *%rax
}
  803c50:	c9                   	leaveq 
  803c51:	c3                   	retq   

0000000000803c52 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803c52:	55                   	push   %rbp
  803c53:	48 89 e5             	mov    %rsp,%rbp
  803c56:	48 83 ec 20          	sub    $0x20,%rsp
  803c5a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803c5d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c60:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803c63:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803c67:	be 01 00 00 00       	mov    $0x1,%esi
  803c6c:	48 89 c7             	mov    %rax,%rdi
  803c6f:	48 b8 fa 19 80 00 00 	movabs $0x8019fa,%rax
  803c76:	00 00 00 
  803c79:	ff d0                	callq  *%rax
}
  803c7b:	c9                   	leaveq 
  803c7c:	c3                   	retq   

0000000000803c7d <getchar>:

int
getchar(void)
{
  803c7d:	55                   	push   %rbp
  803c7e:	48 89 e5             	mov    %rsp,%rbp
  803c81:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803c85:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803c89:	ba 01 00 00 00       	mov    $0x1,%edx
  803c8e:	48 89 c6             	mov    %rax,%rsi
  803c91:	bf 00 00 00 00       	mov    $0x0,%edi
  803c96:	48 b8 91 23 80 00 00 	movabs $0x802391,%rax
  803c9d:	00 00 00 
  803ca0:	ff d0                	callq  *%rax
  803ca2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803ca5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ca9:	79 05                	jns    803cb0 <getchar+0x33>
		return r;
  803cab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cae:	eb 14                	jmp    803cc4 <getchar+0x47>
	if (r < 1)
  803cb0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cb4:	7f 07                	jg     803cbd <getchar+0x40>
		return -E_EOF;
  803cb6:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803cbb:	eb 07                	jmp    803cc4 <getchar+0x47>
	return c;
  803cbd:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803cc1:	0f b6 c0             	movzbl %al,%eax
}
  803cc4:	c9                   	leaveq 
  803cc5:	c3                   	retq   

0000000000803cc6 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803cc6:	55                   	push   %rbp
  803cc7:	48 89 e5             	mov    %rsp,%rbp
  803cca:	48 83 ec 20          	sub    $0x20,%rsp
  803cce:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803cd1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803cd5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cd8:	48 89 d6             	mov    %rdx,%rsi
  803cdb:	89 c7                	mov    %eax,%edi
  803cdd:	48 b8 5f 1f 80 00 00 	movabs $0x801f5f,%rax
  803ce4:	00 00 00 
  803ce7:	ff d0                	callq  *%rax
  803ce9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cf0:	79 05                	jns    803cf7 <iscons+0x31>
		return r;
  803cf2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cf5:	eb 1a                	jmp    803d11 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803cf7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cfb:	8b 10                	mov    (%rax),%edx
  803cfd:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803d04:	00 00 00 
  803d07:	8b 00                	mov    (%rax),%eax
  803d09:	39 c2                	cmp    %eax,%edx
  803d0b:	0f 94 c0             	sete   %al
  803d0e:	0f b6 c0             	movzbl %al,%eax
}
  803d11:	c9                   	leaveq 
  803d12:	c3                   	retq   

0000000000803d13 <opencons>:

int
opencons(void)
{
  803d13:	55                   	push   %rbp
  803d14:	48 89 e5             	mov    %rsp,%rbp
  803d17:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803d1b:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803d1f:	48 89 c7             	mov    %rax,%rdi
  803d22:	48 b8 c7 1e 80 00 00 	movabs $0x801ec7,%rax
  803d29:	00 00 00 
  803d2c:	ff d0                	callq  *%rax
  803d2e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d31:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d35:	79 05                	jns    803d3c <opencons+0x29>
		return r;
  803d37:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d3a:	eb 5b                	jmp    803d97 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803d3c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d40:	ba 07 04 00 00       	mov    $0x407,%edx
  803d45:	48 89 c6             	mov    %rax,%rsi
  803d48:	bf 00 00 00 00       	mov    $0x0,%edi
  803d4d:	48 b8 42 1b 80 00 00 	movabs $0x801b42,%rax
  803d54:	00 00 00 
  803d57:	ff d0                	callq  *%rax
  803d59:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d5c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d60:	79 05                	jns    803d67 <opencons+0x54>
		return r;
  803d62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d65:	eb 30                	jmp    803d97 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803d67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d6b:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803d72:	00 00 00 
  803d75:	8b 12                	mov    (%rdx),%edx
  803d77:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803d79:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d7d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803d84:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d88:	48 89 c7             	mov    %rax,%rdi
  803d8b:	48 b8 79 1e 80 00 00 	movabs $0x801e79,%rax
  803d92:	00 00 00 
  803d95:	ff d0                	callq  *%rax
}
  803d97:	c9                   	leaveq 
  803d98:	c3                   	retq   

0000000000803d99 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803d99:	55                   	push   %rbp
  803d9a:	48 89 e5             	mov    %rsp,%rbp
  803d9d:	48 83 ec 30          	sub    $0x30,%rsp
  803da1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803da5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803da9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803dad:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803db2:	75 07                	jne    803dbb <devcons_read+0x22>
		return 0;
  803db4:	b8 00 00 00 00       	mov    $0x0,%eax
  803db9:	eb 4b                	jmp    803e06 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803dbb:	eb 0c                	jmp    803dc9 <devcons_read+0x30>
		sys_yield();
  803dbd:	48 b8 04 1b 80 00 00 	movabs $0x801b04,%rax
  803dc4:	00 00 00 
  803dc7:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803dc9:	48 b8 44 1a 80 00 00 	movabs $0x801a44,%rax
  803dd0:	00 00 00 
  803dd3:	ff d0                	callq  *%rax
  803dd5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803dd8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ddc:	74 df                	je     803dbd <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803dde:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803de2:	79 05                	jns    803de9 <devcons_read+0x50>
		return c;
  803de4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803de7:	eb 1d                	jmp    803e06 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803de9:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803ded:	75 07                	jne    803df6 <devcons_read+0x5d>
		return 0;
  803def:	b8 00 00 00 00       	mov    $0x0,%eax
  803df4:	eb 10                	jmp    803e06 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803df6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803df9:	89 c2                	mov    %eax,%edx
  803dfb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803dff:	88 10                	mov    %dl,(%rax)
	return 1;
  803e01:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803e06:	c9                   	leaveq 
  803e07:	c3                   	retq   

0000000000803e08 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803e08:	55                   	push   %rbp
  803e09:	48 89 e5             	mov    %rsp,%rbp
  803e0c:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803e13:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803e1a:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803e21:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803e28:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803e2f:	eb 76                	jmp    803ea7 <devcons_write+0x9f>
		m = n - tot;
  803e31:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803e38:	89 c2                	mov    %eax,%edx
  803e3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e3d:	29 c2                	sub    %eax,%edx
  803e3f:	89 d0                	mov    %edx,%eax
  803e41:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803e44:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e47:	83 f8 7f             	cmp    $0x7f,%eax
  803e4a:	76 07                	jbe    803e53 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803e4c:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803e53:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e56:	48 63 d0             	movslq %eax,%rdx
  803e59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e5c:	48 63 c8             	movslq %eax,%rcx
  803e5f:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803e66:	48 01 c1             	add    %rax,%rcx
  803e69:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803e70:	48 89 ce             	mov    %rcx,%rsi
  803e73:	48 89 c7             	mov    %rax,%rdi
  803e76:	48 b8 37 15 80 00 00 	movabs $0x801537,%rax
  803e7d:	00 00 00 
  803e80:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803e82:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e85:	48 63 d0             	movslq %eax,%rdx
  803e88:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803e8f:	48 89 d6             	mov    %rdx,%rsi
  803e92:	48 89 c7             	mov    %rax,%rdi
  803e95:	48 b8 fa 19 80 00 00 	movabs $0x8019fa,%rax
  803e9c:	00 00 00 
  803e9f:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803ea1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ea4:	01 45 fc             	add    %eax,-0x4(%rbp)
  803ea7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803eaa:	48 98                	cltq   
  803eac:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803eb3:	0f 82 78 ff ff ff    	jb     803e31 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803eb9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803ebc:	c9                   	leaveq 
  803ebd:	c3                   	retq   

0000000000803ebe <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803ebe:	55                   	push   %rbp
  803ebf:	48 89 e5             	mov    %rsp,%rbp
  803ec2:	48 83 ec 08          	sub    $0x8,%rsp
  803ec6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803eca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ecf:	c9                   	leaveq 
  803ed0:	c3                   	retq   

0000000000803ed1 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803ed1:	55                   	push   %rbp
  803ed2:	48 89 e5             	mov    %rsp,%rbp
  803ed5:	48 83 ec 10          	sub    $0x10,%rsp
  803ed9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803edd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803ee1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ee5:	48 be fd 48 80 00 00 	movabs $0x8048fd,%rsi
  803eec:	00 00 00 
  803eef:	48 89 c7             	mov    %rax,%rdi
  803ef2:	48 b8 13 12 80 00 00 	movabs $0x801213,%rax
  803ef9:	00 00 00 
  803efc:	ff d0                	callq  *%rax
	return 0;
  803efe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f03:	c9                   	leaveq 
  803f04:	c3                   	retq   

0000000000803f05 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803f05:	55                   	push   %rbp
  803f06:	48 89 e5             	mov    %rsp,%rbp
  803f09:	48 83 ec 30          	sub    $0x30,%rsp
  803f0d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803f11:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803f15:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803f19:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f20:	00 00 00 
  803f23:	48 8b 00             	mov    (%rax),%rax
  803f26:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803f2c:	85 c0                	test   %eax,%eax
  803f2e:	75 3c                	jne    803f6c <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  803f30:	48 b8 c6 1a 80 00 00 	movabs $0x801ac6,%rax
  803f37:	00 00 00 
  803f3a:	ff d0                	callq  *%rax
  803f3c:	25 ff 03 00 00       	and    $0x3ff,%eax
  803f41:	48 63 d0             	movslq %eax,%rdx
  803f44:	48 89 d0             	mov    %rdx,%rax
  803f47:	48 c1 e0 03          	shl    $0x3,%rax
  803f4b:	48 01 d0             	add    %rdx,%rax
  803f4e:	48 c1 e0 05          	shl    $0x5,%rax
  803f52:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803f59:	00 00 00 
  803f5c:	48 01 c2             	add    %rax,%rdx
  803f5f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f66:	00 00 00 
  803f69:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803f6c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803f71:	75 0e                	jne    803f81 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  803f73:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803f7a:	00 00 00 
  803f7d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803f81:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f85:	48 89 c7             	mov    %rax,%rdi
  803f88:	48 b8 6b 1d 80 00 00 	movabs $0x801d6b,%rax
  803f8f:	00 00 00 
  803f92:	ff d0                	callq  *%rax
  803f94:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803f97:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f9b:	79 19                	jns    803fb6 <ipc_recv+0xb1>
		*from_env_store = 0;
  803f9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fa1:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803fa7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fab:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803fb1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fb4:	eb 53                	jmp    804009 <ipc_recv+0x104>
	}
	if(from_env_store)
  803fb6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803fbb:	74 19                	je     803fd6 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  803fbd:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803fc4:	00 00 00 
  803fc7:	48 8b 00             	mov    (%rax),%rax
  803fca:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803fd0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fd4:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803fd6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803fdb:	74 19                	je     803ff6 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  803fdd:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803fe4:	00 00 00 
  803fe7:	48 8b 00             	mov    (%rax),%rax
  803fea:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803ff0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ff4:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803ff6:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803ffd:	00 00 00 
  804000:	48 8b 00             	mov    (%rax),%rax
  804003:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  804009:	c9                   	leaveq 
  80400a:	c3                   	retq   

000000000080400b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80400b:	55                   	push   %rbp
  80400c:	48 89 e5             	mov    %rsp,%rbp
  80400f:	48 83 ec 30          	sub    $0x30,%rsp
  804013:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804016:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804019:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80401d:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  804020:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804025:	75 0e                	jne    804035 <ipc_send+0x2a>
		pg = (void*)UTOP;
  804027:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80402e:	00 00 00 
  804031:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  804035:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804038:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80403b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80403f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804042:	89 c7                	mov    %eax,%edi
  804044:	48 b8 16 1d 80 00 00 	movabs $0x801d16,%rax
  80404b:	00 00 00 
  80404e:	ff d0                	callq  *%rax
  804050:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  804053:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804057:	75 0c                	jne    804065 <ipc_send+0x5a>
			sys_yield();
  804059:	48 b8 04 1b 80 00 00 	movabs $0x801b04,%rax
  804060:	00 00 00 
  804063:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  804065:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804069:	74 ca                	je     804035 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  80406b:	c9                   	leaveq 
  80406c:	c3                   	retq   

000000000080406d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80406d:	55                   	push   %rbp
  80406e:	48 89 e5             	mov    %rsp,%rbp
  804071:	48 83 ec 14          	sub    $0x14,%rsp
  804075:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804078:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80407f:	eb 5e                	jmp    8040df <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  804081:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804088:	00 00 00 
  80408b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80408e:	48 63 d0             	movslq %eax,%rdx
  804091:	48 89 d0             	mov    %rdx,%rax
  804094:	48 c1 e0 03          	shl    $0x3,%rax
  804098:	48 01 d0             	add    %rdx,%rax
  80409b:	48 c1 e0 05          	shl    $0x5,%rax
  80409f:	48 01 c8             	add    %rcx,%rax
  8040a2:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8040a8:	8b 00                	mov    (%rax),%eax
  8040aa:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8040ad:	75 2c                	jne    8040db <ipc_find_env+0x6e>
			return envs[i].env_id;
  8040af:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8040b6:	00 00 00 
  8040b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040bc:	48 63 d0             	movslq %eax,%rdx
  8040bf:	48 89 d0             	mov    %rdx,%rax
  8040c2:	48 c1 e0 03          	shl    $0x3,%rax
  8040c6:	48 01 d0             	add    %rdx,%rax
  8040c9:	48 c1 e0 05          	shl    $0x5,%rax
  8040cd:	48 01 c8             	add    %rcx,%rax
  8040d0:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8040d6:	8b 40 08             	mov    0x8(%rax),%eax
  8040d9:	eb 12                	jmp    8040ed <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8040db:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8040df:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8040e6:	7e 99                	jle    804081 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8040e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8040ed:	c9                   	leaveq 
  8040ee:	c3                   	retq   

00000000008040ef <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8040ef:	55                   	push   %rbp
  8040f0:	48 89 e5             	mov    %rsp,%rbp
  8040f3:	48 83 ec 18          	sub    $0x18,%rsp
  8040f7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8040fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040ff:	48 c1 e8 15          	shr    $0x15,%rax
  804103:	48 89 c2             	mov    %rax,%rdx
  804106:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80410d:	01 00 00 
  804110:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804114:	83 e0 01             	and    $0x1,%eax
  804117:	48 85 c0             	test   %rax,%rax
  80411a:	75 07                	jne    804123 <pageref+0x34>
		return 0;
  80411c:	b8 00 00 00 00       	mov    $0x0,%eax
  804121:	eb 53                	jmp    804176 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804123:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804127:	48 c1 e8 0c          	shr    $0xc,%rax
  80412b:	48 89 c2             	mov    %rax,%rdx
  80412e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804135:	01 00 00 
  804138:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80413c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804140:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804144:	83 e0 01             	and    $0x1,%eax
  804147:	48 85 c0             	test   %rax,%rax
  80414a:	75 07                	jne    804153 <pageref+0x64>
		return 0;
  80414c:	b8 00 00 00 00       	mov    $0x0,%eax
  804151:	eb 23                	jmp    804176 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804153:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804157:	48 c1 e8 0c          	shr    $0xc,%rax
  80415b:	48 89 c2             	mov    %rax,%rdx
  80415e:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804165:	00 00 00 
  804168:	48 c1 e2 04          	shl    $0x4,%rdx
  80416c:	48 01 d0             	add    %rdx,%rax
  80416f:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804173:	0f b7 c0             	movzwl %ax,%eax
}
  804176:	c9                   	leaveq 
  804177:	c3                   	retq   
