
obj/user/icode.debug:     file format elf64-x86-64


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
  80003c:	e8 06 02 00 00       	callq  800247 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	53                   	push   %rbx
  800048:	48 81 ec 28 02 00 00 	sub    $0x228,%rsp
  80004f:	89 bd dc fd ff ff    	mov    %edi,-0x224(%rbp)
  800055:	48 89 b5 d0 fd ff ff 	mov    %rsi,-0x230(%rbp)
	int fd, n, r;
	char buf[512+1];

	binaryname = "icode";
  80005c:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800063:	00 00 00 
  800066:	48 bb 00 41 80 00 00 	movabs $0x804100,%rbx
  80006d:	00 00 00 
  800070:	48 89 18             	mov    %rbx,(%rax)

	cprintf("icode startup\n");
  800073:	48 bf 06 41 80 00 00 	movabs $0x804106,%rdi
  80007a:	00 00 00 
  80007d:	b8 00 00 00 00       	mov    $0x0,%eax
  800082:	48 ba 2e 05 80 00 00 	movabs $0x80052e,%rdx
  800089:	00 00 00 
  80008c:	ff d2                	callq  *%rdx

	cprintf("icode: open /motd\n");
  80008e:	48 bf 15 41 80 00 00 	movabs $0x804115,%rdi
  800095:	00 00 00 
  800098:	b8 00 00 00 00       	mov    $0x0,%eax
  80009d:	48 ba 2e 05 80 00 00 	movabs $0x80052e,%rdx
  8000a4:	00 00 00 
  8000a7:	ff d2                	callq  *%rdx
	if ((fd = open("/motd", O_RDONLY)) < 0)
  8000a9:	be 00 00 00 00       	mov    $0x0,%esi
  8000ae:	48 bf 28 41 80 00 00 	movabs $0x804128,%rdi
  8000b5:	00 00 00 
  8000b8:	48 b8 6d 26 80 00 00 	movabs $0x80266d,%rax
  8000bf:	00 00 00 
  8000c2:	ff d0                	callq  *%rax
  8000c4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8000c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000cb:	79 30                	jns    8000fd <umain+0xba>
		panic("icode: open /motd: %e", fd);
  8000cd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000d0:	89 c1                	mov    %eax,%ecx
  8000d2:	48 ba 2e 41 80 00 00 	movabs $0x80412e,%rdx
  8000d9:	00 00 00 
  8000dc:	be 0f 00 00 00       	mov    $0xf,%esi
  8000e1:	48 bf 44 41 80 00 00 	movabs $0x804144,%rdi
  8000e8:	00 00 00 
  8000eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f0:	49 b8 f5 02 80 00 00 	movabs $0x8002f5,%r8
  8000f7:	00 00 00 
  8000fa:	41 ff d0             	callq  *%r8

	cprintf("icode: read /motd\n");
  8000fd:	48 bf 51 41 80 00 00 	movabs $0x804151,%rdi
  800104:	00 00 00 
  800107:	b8 00 00 00 00       	mov    $0x0,%eax
  80010c:	48 ba 2e 05 80 00 00 	movabs $0x80052e,%rdx
  800113:	00 00 00 
  800116:	ff d2                	callq  *%rdx
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  800118:	eb 1f                	jmp    800139 <umain+0xf6>
		sys_cputs(buf, n);
  80011a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80011d:	48 63 d0             	movslq %eax,%rdx
  800120:	48 8d 85 e0 fd ff ff 	lea    -0x220(%rbp),%rax
  800127:	48 89 d6             	mov    %rdx,%rsi
  80012a:	48 89 c7             	mov    %rax,%rdi
  80012d:	48 b8 ca 18 80 00 00 	movabs $0x8018ca,%rax
  800134:	00 00 00 
  800137:	ff d0                	callq  *%rax
	cprintf("icode: open /motd\n");
	if ((fd = open("/motd", O_RDONLY)) < 0)
		panic("icode: open /motd: %e", fd);

	cprintf("icode: read /motd\n");
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  800139:	48 8d 8d e0 fd ff ff 	lea    -0x220(%rbp),%rcx
  800140:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800143:	ba 00 02 00 00       	mov    $0x200,%edx
  800148:	48 89 ce             	mov    %rcx,%rsi
  80014b:	89 c7                	mov    %eax,%edi
  80014d:	48 b8 97 21 80 00 00 	movabs $0x802197,%rax
  800154:	00 00 00 
  800157:	ff d0                	callq  *%rax
  800159:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80015c:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800160:	7f b8                	jg     80011a <umain+0xd7>
		sys_cputs(buf, n);

	cprintf("icode: close /motd\n");
  800162:	48 bf 64 41 80 00 00 	movabs $0x804164,%rdi
  800169:	00 00 00 
  80016c:	b8 00 00 00 00       	mov    $0x0,%eax
  800171:	48 ba 2e 05 80 00 00 	movabs $0x80052e,%rdx
  800178:	00 00 00 
  80017b:	ff d2                	callq  *%rdx
	close(fd);
  80017d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800180:	89 c7                	mov    %eax,%edi
  800182:	48 b8 75 1f 80 00 00 	movabs $0x801f75,%rax
  800189:	00 00 00 
  80018c:	ff d0                	callq  *%rax

	cprintf("icode: spawn /init\n");
  80018e:	48 bf 78 41 80 00 00 	movabs $0x804178,%rdi
  800195:	00 00 00 
  800198:	b8 00 00 00 00       	mov    $0x0,%eax
  80019d:	48 ba 2e 05 80 00 00 	movabs $0x80052e,%rdx
  8001a4:	00 00 00 
  8001a7:	ff d2                	callq  *%rdx
	if ((r = spawnl("/sbin/init", "init", "initarg1", "initarg2", (char*)0)) < 0)
  8001a9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001af:	48 b9 8c 41 80 00 00 	movabs $0x80418c,%rcx
  8001b6:	00 00 00 
  8001b9:	48 ba 95 41 80 00 00 	movabs $0x804195,%rdx
  8001c0:	00 00 00 
  8001c3:	48 be 9e 41 80 00 00 	movabs $0x80419e,%rsi
  8001ca:	00 00 00 
  8001cd:	48 bf a3 41 80 00 00 	movabs $0x8041a3,%rdi
  8001d4:	00 00 00 
  8001d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8001dc:	49 b9 03 2e 80 00 00 	movabs $0x802e03,%r9
  8001e3:	00 00 00 
  8001e6:	41 ff d1             	callq  *%r9
  8001e9:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8001ec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8001f0:	79 30                	jns    800222 <umain+0x1df>
		panic("icode: spawn /sbin/init: %e", r);
  8001f2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8001f5:	89 c1                	mov    %eax,%ecx
  8001f7:	48 ba ae 41 80 00 00 	movabs $0x8041ae,%rdx
  8001fe:	00 00 00 
  800201:	be 1a 00 00 00       	mov    $0x1a,%esi
  800206:	48 bf 44 41 80 00 00 	movabs $0x804144,%rdi
  80020d:	00 00 00 
  800210:	b8 00 00 00 00       	mov    $0x0,%eax
  800215:	49 b8 f5 02 80 00 00 	movabs $0x8002f5,%r8
  80021c:	00 00 00 
  80021f:	41 ff d0             	callq  *%r8

	cprintf("icode: exiting\n");
  800222:	48 bf ca 41 80 00 00 	movabs $0x8041ca,%rdi
  800229:	00 00 00 
  80022c:	b8 00 00 00 00       	mov    $0x0,%eax
  800231:	48 ba 2e 05 80 00 00 	movabs $0x80052e,%rdx
  800238:	00 00 00 
  80023b:	ff d2                	callq  *%rdx
}
  80023d:	48 81 c4 28 02 00 00 	add    $0x228,%rsp
  800244:	5b                   	pop    %rbx
  800245:	5d                   	pop    %rbp
  800246:	c3                   	retq   

0000000000800247 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800247:	55                   	push   %rbp
  800248:	48 89 e5             	mov    %rsp,%rbp
  80024b:	48 83 ec 10          	sub    $0x10,%rsp
  80024f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800252:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800256:	48 b8 96 19 80 00 00 	movabs $0x801996,%rax
  80025d:	00 00 00 
  800260:	ff d0                	callq  *%rax
  800262:	25 ff 03 00 00       	and    $0x3ff,%eax
  800267:	48 63 d0             	movslq %eax,%rdx
  80026a:	48 89 d0             	mov    %rdx,%rax
  80026d:	48 c1 e0 03          	shl    $0x3,%rax
  800271:	48 01 d0             	add    %rdx,%rax
  800274:	48 c1 e0 05          	shl    $0x5,%rax
  800278:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80027f:	00 00 00 
  800282:	48 01 c2             	add    %rax,%rdx
  800285:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80028c:	00 00 00 
  80028f:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800292:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800296:	7e 14                	jle    8002ac <libmain+0x65>
		binaryname = argv[0];
  800298:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80029c:	48 8b 10             	mov    (%rax),%rdx
  80029f:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002a6:	00 00 00 
  8002a9:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8002ac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002b3:	48 89 d6             	mov    %rdx,%rsi
  8002b6:	89 c7                	mov    %eax,%edi
  8002b8:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8002bf:	00 00 00 
  8002c2:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8002c4:	48 b8 d2 02 80 00 00 	movabs $0x8002d2,%rax
  8002cb:	00 00 00 
  8002ce:	ff d0                	callq  *%rax
}
  8002d0:	c9                   	leaveq 
  8002d1:	c3                   	retq   

00000000008002d2 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002d2:	55                   	push   %rbp
  8002d3:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8002d6:	48 b8 c0 1f 80 00 00 	movabs $0x801fc0,%rax
  8002dd:	00 00 00 
  8002e0:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8002e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8002e7:	48 b8 52 19 80 00 00 	movabs $0x801952,%rax
  8002ee:	00 00 00 
  8002f1:	ff d0                	callq  *%rax

}
  8002f3:	5d                   	pop    %rbp
  8002f4:	c3                   	retq   

00000000008002f5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002f5:	55                   	push   %rbp
  8002f6:	48 89 e5             	mov    %rsp,%rbp
  8002f9:	53                   	push   %rbx
  8002fa:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800301:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800308:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80030e:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800315:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80031c:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800323:	84 c0                	test   %al,%al
  800325:	74 23                	je     80034a <_panic+0x55>
  800327:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80032e:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800332:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800336:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80033a:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80033e:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800342:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800346:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80034a:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800351:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800358:	00 00 00 
  80035b:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800362:	00 00 00 
  800365:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800369:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800370:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800377:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80037e:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800385:	00 00 00 
  800388:	48 8b 18             	mov    (%rax),%rbx
  80038b:	48 b8 96 19 80 00 00 	movabs $0x801996,%rax
  800392:	00 00 00 
  800395:	ff d0                	callq  *%rax
  800397:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80039d:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8003a4:	41 89 c8             	mov    %ecx,%r8d
  8003a7:	48 89 d1             	mov    %rdx,%rcx
  8003aa:	48 89 da             	mov    %rbx,%rdx
  8003ad:	89 c6                	mov    %eax,%esi
  8003af:	48 bf e8 41 80 00 00 	movabs $0x8041e8,%rdi
  8003b6:	00 00 00 
  8003b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8003be:	49 b9 2e 05 80 00 00 	movabs $0x80052e,%r9
  8003c5:	00 00 00 
  8003c8:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003cb:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8003d2:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003d9:	48 89 d6             	mov    %rdx,%rsi
  8003dc:	48 89 c7             	mov    %rax,%rdi
  8003df:	48 b8 82 04 80 00 00 	movabs $0x800482,%rax
  8003e6:	00 00 00 
  8003e9:	ff d0                	callq  *%rax
	cprintf("\n");
  8003eb:	48 bf 0b 42 80 00 00 	movabs $0x80420b,%rdi
  8003f2:	00 00 00 
  8003f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8003fa:	48 ba 2e 05 80 00 00 	movabs $0x80052e,%rdx
  800401:	00 00 00 
  800404:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800406:	cc                   	int3   
  800407:	eb fd                	jmp    800406 <_panic+0x111>

0000000000800409 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800409:	55                   	push   %rbp
  80040a:	48 89 e5             	mov    %rsp,%rbp
  80040d:	48 83 ec 10          	sub    $0x10,%rsp
  800411:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800414:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800418:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80041c:	8b 00                	mov    (%rax),%eax
  80041e:	8d 48 01             	lea    0x1(%rax),%ecx
  800421:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800425:	89 0a                	mov    %ecx,(%rdx)
  800427:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80042a:	89 d1                	mov    %edx,%ecx
  80042c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800430:	48 98                	cltq   
  800432:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  800436:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80043a:	8b 00                	mov    (%rax),%eax
  80043c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800441:	75 2c                	jne    80046f <putch+0x66>
		sys_cputs(b->buf, b->idx);
  800443:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800447:	8b 00                	mov    (%rax),%eax
  800449:	48 98                	cltq   
  80044b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80044f:	48 83 c2 08          	add    $0x8,%rdx
  800453:	48 89 c6             	mov    %rax,%rsi
  800456:	48 89 d7             	mov    %rdx,%rdi
  800459:	48 b8 ca 18 80 00 00 	movabs $0x8018ca,%rax
  800460:	00 00 00 
  800463:	ff d0                	callq  *%rax
		b->idx = 0;
  800465:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800469:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  80046f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800473:	8b 40 04             	mov    0x4(%rax),%eax
  800476:	8d 50 01             	lea    0x1(%rax),%edx
  800479:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80047d:	89 50 04             	mov    %edx,0x4(%rax)
}
  800480:	c9                   	leaveq 
  800481:	c3                   	retq   

0000000000800482 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800482:	55                   	push   %rbp
  800483:	48 89 e5             	mov    %rsp,%rbp
  800486:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80048d:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800494:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  80049b:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8004a2:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8004a9:	48 8b 0a             	mov    (%rdx),%rcx
  8004ac:	48 89 08             	mov    %rcx,(%rax)
  8004af:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004b3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8004b7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8004bb:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8004bf:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8004c6:	00 00 00 
	b.cnt = 0;
  8004c9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8004d0:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8004d3:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8004da:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8004e1:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8004e8:	48 89 c6             	mov    %rax,%rsi
  8004eb:	48 bf 09 04 80 00 00 	movabs $0x800409,%rdi
  8004f2:	00 00 00 
  8004f5:	48 b8 e1 08 80 00 00 	movabs $0x8008e1,%rax
  8004fc:	00 00 00 
  8004ff:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  800501:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800507:	48 98                	cltq   
  800509:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800510:	48 83 c2 08          	add    $0x8,%rdx
  800514:	48 89 c6             	mov    %rax,%rsi
  800517:	48 89 d7             	mov    %rdx,%rdi
  80051a:	48 b8 ca 18 80 00 00 	movabs $0x8018ca,%rax
  800521:	00 00 00 
  800524:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  800526:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80052c:	c9                   	leaveq 
  80052d:	c3                   	retq   

000000000080052e <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80052e:	55                   	push   %rbp
  80052f:	48 89 e5             	mov    %rsp,%rbp
  800532:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800539:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800540:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800547:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80054e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800555:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80055c:	84 c0                	test   %al,%al
  80055e:	74 20                	je     800580 <cprintf+0x52>
  800560:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800564:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800568:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80056c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800570:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800574:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800578:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80057c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800580:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800587:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80058e:	00 00 00 
  800591:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800598:	00 00 00 
  80059b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80059f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8005a6:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8005ad:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8005b4:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8005bb:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8005c2:	48 8b 0a             	mov    (%rdx),%rcx
  8005c5:	48 89 08             	mov    %rcx,(%rax)
  8005c8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005cc:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005d0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005d4:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8005d8:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8005df:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005e6:	48 89 d6             	mov    %rdx,%rsi
  8005e9:	48 89 c7             	mov    %rax,%rdi
  8005ec:	48 b8 82 04 80 00 00 	movabs $0x800482,%rax
  8005f3:	00 00 00 
  8005f6:	ff d0                	callq  *%rax
  8005f8:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  8005fe:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800604:	c9                   	leaveq 
  800605:	c3                   	retq   

0000000000800606 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800606:	55                   	push   %rbp
  800607:	48 89 e5             	mov    %rsp,%rbp
  80060a:	53                   	push   %rbx
  80060b:	48 83 ec 38          	sub    $0x38,%rsp
  80060f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800613:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800617:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80061b:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80061e:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800622:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800626:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800629:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80062d:	77 3b                	ja     80066a <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80062f:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800632:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800636:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800639:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80063d:	ba 00 00 00 00       	mov    $0x0,%edx
  800642:	48 f7 f3             	div    %rbx
  800645:	48 89 c2             	mov    %rax,%rdx
  800648:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80064b:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80064e:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800652:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800656:	41 89 f9             	mov    %edi,%r9d
  800659:	48 89 c7             	mov    %rax,%rdi
  80065c:	48 b8 06 06 80 00 00 	movabs $0x800606,%rax
  800663:	00 00 00 
  800666:	ff d0                	callq  *%rax
  800668:	eb 1e                	jmp    800688 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80066a:	eb 12                	jmp    80067e <printnum+0x78>
			putch(padc, putdat);
  80066c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800670:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800673:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800677:	48 89 ce             	mov    %rcx,%rsi
  80067a:	89 d7                	mov    %edx,%edi
  80067c:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80067e:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800682:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800686:	7f e4                	jg     80066c <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800688:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80068b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80068f:	ba 00 00 00 00       	mov    $0x0,%edx
  800694:	48 f7 f1             	div    %rcx
  800697:	48 89 d0             	mov    %rdx,%rax
  80069a:	48 ba e8 43 80 00 00 	movabs $0x8043e8,%rdx
  8006a1:	00 00 00 
  8006a4:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8006a8:	0f be d0             	movsbl %al,%edx
  8006ab:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8006af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b3:	48 89 ce             	mov    %rcx,%rsi
  8006b6:	89 d7                	mov    %edx,%edi
  8006b8:	ff d0                	callq  *%rax
}
  8006ba:	48 83 c4 38          	add    $0x38,%rsp
  8006be:	5b                   	pop    %rbx
  8006bf:	5d                   	pop    %rbp
  8006c0:	c3                   	retq   

00000000008006c1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006c1:	55                   	push   %rbp
  8006c2:	48 89 e5             	mov    %rsp,%rbp
  8006c5:	48 83 ec 1c          	sub    $0x1c,%rsp
  8006c9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006cd:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8006d0:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8006d4:	7e 52                	jle    800728 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8006d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006da:	8b 00                	mov    (%rax),%eax
  8006dc:	83 f8 30             	cmp    $0x30,%eax
  8006df:	73 24                	jae    800705 <getuint+0x44>
  8006e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ed:	8b 00                	mov    (%rax),%eax
  8006ef:	89 c0                	mov    %eax,%eax
  8006f1:	48 01 d0             	add    %rdx,%rax
  8006f4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006f8:	8b 12                	mov    (%rdx),%edx
  8006fa:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006fd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800701:	89 0a                	mov    %ecx,(%rdx)
  800703:	eb 17                	jmp    80071c <getuint+0x5b>
  800705:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800709:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80070d:	48 89 d0             	mov    %rdx,%rax
  800710:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800714:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800718:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80071c:	48 8b 00             	mov    (%rax),%rax
  80071f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800723:	e9 a3 00 00 00       	jmpq   8007cb <getuint+0x10a>
	else if (lflag)
  800728:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80072c:	74 4f                	je     80077d <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80072e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800732:	8b 00                	mov    (%rax),%eax
  800734:	83 f8 30             	cmp    $0x30,%eax
  800737:	73 24                	jae    80075d <getuint+0x9c>
  800739:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800741:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800745:	8b 00                	mov    (%rax),%eax
  800747:	89 c0                	mov    %eax,%eax
  800749:	48 01 d0             	add    %rdx,%rax
  80074c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800750:	8b 12                	mov    (%rdx),%edx
  800752:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800755:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800759:	89 0a                	mov    %ecx,(%rdx)
  80075b:	eb 17                	jmp    800774 <getuint+0xb3>
  80075d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800761:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800765:	48 89 d0             	mov    %rdx,%rax
  800768:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80076c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800770:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800774:	48 8b 00             	mov    (%rax),%rax
  800777:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80077b:	eb 4e                	jmp    8007cb <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80077d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800781:	8b 00                	mov    (%rax),%eax
  800783:	83 f8 30             	cmp    $0x30,%eax
  800786:	73 24                	jae    8007ac <getuint+0xeb>
  800788:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800790:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800794:	8b 00                	mov    (%rax),%eax
  800796:	89 c0                	mov    %eax,%eax
  800798:	48 01 d0             	add    %rdx,%rax
  80079b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80079f:	8b 12                	mov    (%rdx),%edx
  8007a1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007a4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007a8:	89 0a                	mov    %ecx,(%rdx)
  8007aa:	eb 17                	jmp    8007c3 <getuint+0x102>
  8007ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007b4:	48 89 d0             	mov    %rdx,%rax
  8007b7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007bb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007bf:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007c3:	8b 00                	mov    (%rax),%eax
  8007c5:	89 c0                	mov    %eax,%eax
  8007c7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8007cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8007cf:	c9                   	leaveq 
  8007d0:	c3                   	retq   

00000000008007d1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007d1:	55                   	push   %rbp
  8007d2:	48 89 e5             	mov    %rsp,%rbp
  8007d5:	48 83 ec 1c          	sub    $0x1c,%rsp
  8007d9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007dd:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8007e0:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007e4:	7e 52                	jle    800838 <getint+0x67>
		x=va_arg(*ap, long long);
  8007e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ea:	8b 00                	mov    (%rax),%eax
  8007ec:	83 f8 30             	cmp    $0x30,%eax
  8007ef:	73 24                	jae    800815 <getint+0x44>
  8007f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007fd:	8b 00                	mov    (%rax),%eax
  8007ff:	89 c0                	mov    %eax,%eax
  800801:	48 01 d0             	add    %rdx,%rax
  800804:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800808:	8b 12                	mov    (%rdx),%edx
  80080a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80080d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800811:	89 0a                	mov    %ecx,(%rdx)
  800813:	eb 17                	jmp    80082c <getint+0x5b>
  800815:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800819:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80081d:	48 89 d0             	mov    %rdx,%rax
  800820:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800824:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800828:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80082c:	48 8b 00             	mov    (%rax),%rax
  80082f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800833:	e9 a3 00 00 00       	jmpq   8008db <getint+0x10a>
	else if (lflag)
  800838:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80083c:	74 4f                	je     80088d <getint+0xbc>
		x=va_arg(*ap, long);
  80083e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800842:	8b 00                	mov    (%rax),%eax
  800844:	83 f8 30             	cmp    $0x30,%eax
  800847:	73 24                	jae    80086d <getint+0x9c>
  800849:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800851:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800855:	8b 00                	mov    (%rax),%eax
  800857:	89 c0                	mov    %eax,%eax
  800859:	48 01 d0             	add    %rdx,%rax
  80085c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800860:	8b 12                	mov    (%rdx),%edx
  800862:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800865:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800869:	89 0a                	mov    %ecx,(%rdx)
  80086b:	eb 17                	jmp    800884 <getint+0xb3>
  80086d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800871:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800875:	48 89 d0             	mov    %rdx,%rax
  800878:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80087c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800880:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800884:	48 8b 00             	mov    (%rax),%rax
  800887:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80088b:	eb 4e                	jmp    8008db <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80088d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800891:	8b 00                	mov    (%rax),%eax
  800893:	83 f8 30             	cmp    $0x30,%eax
  800896:	73 24                	jae    8008bc <getint+0xeb>
  800898:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80089c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a4:	8b 00                	mov    (%rax),%eax
  8008a6:	89 c0                	mov    %eax,%eax
  8008a8:	48 01 d0             	add    %rdx,%rax
  8008ab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008af:	8b 12                	mov    (%rdx),%edx
  8008b1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008b4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008b8:	89 0a                	mov    %ecx,(%rdx)
  8008ba:	eb 17                	jmp    8008d3 <getint+0x102>
  8008bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008c4:	48 89 d0             	mov    %rdx,%rax
  8008c7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008cb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008cf:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008d3:	8b 00                	mov    (%rax),%eax
  8008d5:	48 98                	cltq   
  8008d7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008df:	c9                   	leaveq 
  8008e0:	c3                   	retq   

00000000008008e1 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008e1:	55                   	push   %rbp
  8008e2:	48 89 e5             	mov    %rsp,%rbp
  8008e5:	41 54                	push   %r12
  8008e7:	53                   	push   %rbx
  8008e8:	48 83 ec 60          	sub    $0x60,%rsp
  8008ec:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8008f0:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8008f4:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008f8:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8008fc:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800900:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800904:	48 8b 0a             	mov    (%rdx),%rcx
  800907:	48 89 08             	mov    %rcx,(%rax)
  80090a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80090e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800912:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800916:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80091a:	eb 17                	jmp    800933 <vprintfmt+0x52>
			if (ch == '\0')
  80091c:	85 db                	test   %ebx,%ebx
  80091e:	0f 84 cc 04 00 00    	je     800df0 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800924:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800928:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80092c:	48 89 d6             	mov    %rdx,%rsi
  80092f:	89 df                	mov    %ebx,%edi
  800931:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800933:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800937:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80093b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80093f:	0f b6 00             	movzbl (%rax),%eax
  800942:	0f b6 d8             	movzbl %al,%ebx
  800945:	83 fb 25             	cmp    $0x25,%ebx
  800948:	75 d2                	jne    80091c <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80094a:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80094e:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800955:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80095c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800963:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80096a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80096e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800972:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800976:	0f b6 00             	movzbl (%rax),%eax
  800979:	0f b6 d8             	movzbl %al,%ebx
  80097c:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80097f:	83 f8 55             	cmp    $0x55,%eax
  800982:	0f 87 34 04 00 00    	ja     800dbc <vprintfmt+0x4db>
  800988:	89 c0                	mov    %eax,%eax
  80098a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800991:	00 
  800992:	48 b8 10 44 80 00 00 	movabs $0x804410,%rax
  800999:	00 00 00 
  80099c:	48 01 d0             	add    %rdx,%rax
  80099f:	48 8b 00             	mov    (%rax),%rax
  8009a2:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009a4:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8009a8:	eb c0                	jmp    80096a <vprintfmt+0x89>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009aa:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8009ae:	eb ba                	jmp    80096a <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009b0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8009b7:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8009ba:	89 d0                	mov    %edx,%eax
  8009bc:	c1 e0 02             	shl    $0x2,%eax
  8009bf:	01 d0                	add    %edx,%eax
  8009c1:	01 c0                	add    %eax,%eax
  8009c3:	01 d8                	add    %ebx,%eax
  8009c5:	83 e8 30             	sub    $0x30,%eax
  8009c8:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8009cb:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009cf:	0f b6 00             	movzbl (%rax),%eax
  8009d2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009d5:	83 fb 2f             	cmp    $0x2f,%ebx
  8009d8:	7e 0c                	jle    8009e6 <vprintfmt+0x105>
  8009da:	83 fb 39             	cmp    $0x39,%ebx
  8009dd:	7f 07                	jg     8009e6 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009df:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009e4:	eb d1                	jmp    8009b7 <vprintfmt+0xd6>
			goto process_precision;
  8009e6:	eb 58                	jmp    800a40 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8009e8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009eb:	83 f8 30             	cmp    $0x30,%eax
  8009ee:	73 17                	jae    800a07 <vprintfmt+0x126>
  8009f0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009f4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f7:	89 c0                	mov    %eax,%eax
  8009f9:	48 01 d0             	add    %rdx,%rax
  8009fc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009ff:	83 c2 08             	add    $0x8,%edx
  800a02:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a05:	eb 0f                	jmp    800a16 <vprintfmt+0x135>
  800a07:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a0b:	48 89 d0             	mov    %rdx,%rax
  800a0e:	48 83 c2 08          	add    $0x8,%rdx
  800a12:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a16:	8b 00                	mov    (%rax),%eax
  800a18:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800a1b:	eb 23                	jmp    800a40 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800a1d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a21:	79 0c                	jns    800a2f <vprintfmt+0x14e>
				width = 0;
  800a23:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800a2a:	e9 3b ff ff ff       	jmpq   80096a <vprintfmt+0x89>
  800a2f:	e9 36 ff ff ff       	jmpq   80096a <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800a34:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800a3b:	e9 2a ff ff ff       	jmpq   80096a <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800a40:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a44:	79 12                	jns    800a58 <vprintfmt+0x177>
				width = precision, precision = -1;
  800a46:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a49:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800a4c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800a53:	e9 12 ff ff ff       	jmpq   80096a <vprintfmt+0x89>
  800a58:	e9 0d ff ff ff       	jmpq   80096a <vprintfmt+0x89>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a5d:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800a61:	e9 04 ff ff ff       	jmpq   80096a <vprintfmt+0x89>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800a66:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a69:	83 f8 30             	cmp    $0x30,%eax
  800a6c:	73 17                	jae    800a85 <vprintfmt+0x1a4>
  800a6e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a72:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a75:	89 c0                	mov    %eax,%eax
  800a77:	48 01 d0             	add    %rdx,%rax
  800a7a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a7d:	83 c2 08             	add    $0x8,%edx
  800a80:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a83:	eb 0f                	jmp    800a94 <vprintfmt+0x1b3>
  800a85:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a89:	48 89 d0             	mov    %rdx,%rax
  800a8c:	48 83 c2 08          	add    $0x8,%rdx
  800a90:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a94:	8b 10                	mov    (%rax),%edx
  800a96:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a9a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a9e:	48 89 ce             	mov    %rcx,%rsi
  800aa1:	89 d7                	mov    %edx,%edi
  800aa3:	ff d0                	callq  *%rax
			break;
  800aa5:	e9 40 03 00 00       	jmpq   800dea <vprintfmt+0x509>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800aaa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aad:	83 f8 30             	cmp    $0x30,%eax
  800ab0:	73 17                	jae    800ac9 <vprintfmt+0x1e8>
  800ab2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ab6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ab9:	89 c0                	mov    %eax,%eax
  800abb:	48 01 d0             	add    %rdx,%rax
  800abe:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ac1:	83 c2 08             	add    $0x8,%edx
  800ac4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ac7:	eb 0f                	jmp    800ad8 <vprintfmt+0x1f7>
  800ac9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800acd:	48 89 d0             	mov    %rdx,%rax
  800ad0:	48 83 c2 08          	add    $0x8,%rdx
  800ad4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ad8:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800ada:	85 db                	test   %ebx,%ebx
  800adc:	79 02                	jns    800ae0 <vprintfmt+0x1ff>
				err = -err;
  800ade:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800ae0:	83 fb 10             	cmp    $0x10,%ebx
  800ae3:	7f 16                	jg     800afb <vprintfmt+0x21a>
  800ae5:	48 b8 60 43 80 00 00 	movabs $0x804360,%rax
  800aec:	00 00 00 
  800aef:	48 63 d3             	movslq %ebx,%rdx
  800af2:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800af6:	4d 85 e4             	test   %r12,%r12
  800af9:	75 2e                	jne    800b29 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800afb:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800aff:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b03:	89 d9                	mov    %ebx,%ecx
  800b05:	48 ba f9 43 80 00 00 	movabs $0x8043f9,%rdx
  800b0c:	00 00 00 
  800b0f:	48 89 c7             	mov    %rax,%rdi
  800b12:	b8 00 00 00 00       	mov    $0x0,%eax
  800b17:	49 b8 f9 0d 80 00 00 	movabs $0x800df9,%r8
  800b1e:	00 00 00 
  800b21:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b24:	e9 c1 02 00 00       	jmpq   800dea <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b29:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b2d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b31:	4c 89 e1             	mov    %r12,%rcx
  800b34:	48 ba 02 44 80 00 00 	movabs $0x804402,%rdx
  800b3b:	00 00 00 
  800b3e:	48 89 c7             	mov    %rax,%rdi
  800b41:	b8 00 00 00 00       	mov    $0x0,%eax
  800b46:	49 b8 f9 0d 80 00 00 	movabs $0x800df9,%r8
  800b4d:	00 00 00 
  800b50:	41 ff d0             	callq  *%r8
			break;
  800b53:	e9 92 02 00 00       	jmpq   800dea <vprintfmt+0x509>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800b58:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b5b:	83 f8 30             	cmp    $0x30,%eax
  800b5e:	73 17                	jae    800b77 <vprintfmt+0x296>
  800b60:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b64:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b67:	89 c0                	mov    %eax,%eax
  800b69:	48 01 d0             	add    %rdx,%rax
  800b6c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b6f:	83 c2 08             	add    $0x8,%edx
  800b72:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b75:	eb 0f                	jmp    800b86 <vprintfmt+0x2a5>
  800b77:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b7b:	48 89 d0             	mov    %rdx,%rax
  800b7e:	48 83 c2 08          	add    $0x8,%rdx
  800b82:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b86:	4c 8b 20             	mov    (%rax),%r12
  800b89:	4d 85 e4             	test   %r12,%r12
  800b8c:	75 0a                	jne    800b98 <vprintfmt+0x2b7>
				p = "(null)";
  800b8e:	49 bc 05 44 80 00 00 	movabs $0x804405,%r12
  800b95:	00 00 00 
			if (width > 0 && padc != '-')
  800b98:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b9c:	7e 3f                	jle    800bdd <vprintfmt+0x2fc>
  800b9e:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800ba2:	74 39                	je     800bdd <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ba4:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ba7:	48 98                	cltq   
  800ba9:	48 89 c6             	mov    %rax,%rsi
  800bac:	4c 89 e7             	mov    %r12,%rdi
  800baf:	48 b8 a5 10 80 00 00 	movabs $0x8010a5,%rax
  800bb6:	00 00 00 
  800bb9:	ff d0                	callq  *%rax
  800bbb:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800bbe:	eb 17                	jmp    800bd7 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800bc0:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800bc4:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800bc8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bcc:	48 89 ce             	mov    %rcx,%rsi
  800bcf:	89 d7                	mov    %edx,%edi
  800bd1:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bd3:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bd7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bdb:	7f e3                	jg     800bc0 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bdd:	eb 37                	jmp    800c16 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800bdf:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800be3:	74 1e                	je     800c03 <vprintfmt+0x322>
  800be5:	83 fb 1f             	cmp    $0x1f,%ebx
  800be8:	7e 05                	jle    800bef <vprintfmt+0x30e>
  800bea:	83 fb 7e             	cmp    $0x7e,%ebx
  800bed:	7e 14                	jle    800c03 <vprintfmt+0x322>
					putch('?', putdat);
  800bef:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bf3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bf7:	48 89 d6             	mov    %rdx,%rsi
  800bfa:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800bff:	ff d0                	callq  *%rax
  800c01:	eb 0f                	jmp    800c12 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800c03:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c07:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c0b:	48 89 d6             	mov    %rdx,%rsi
  800c0e:	89 df                	mov    %ebx,%edi
  800c10:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c12:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c16:	4c 89 e0             	mov    %r12,%rax
  800c19:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800c1d:	0f b6 00             	movzbl (%rax),%eax
  800c20:	0f be d8             	movsbl %al,%ebx
  800c23:	85 db                	test   %ebx,%ebx
  800c25:	74 10                	je     800c37 <vprintfmt+0x356>
  800c27:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c2b:	78 b2                	js     800bdf <vprintfmt+0x2fe>
  800c2d:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800c31:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c35:	79 a8                	jns    800bdf <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c37:	eb 16                	jmp    800c4f <vprintfmt+0x36e>
				putch(' ', putdat);
  800c39:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c3d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c41:	48 89 d6             	mov    %rdx,%rsi
  800c44:	bf 20 00 00 00       	mov    $0x20,%edi
  800c49:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c4b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c4f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c53:	7f e4                	jg     800c39 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800c55:	e9 90 01 00 00       	jmpq   800dea <vprintfmt+0x509>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800c5a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c5e:	be 03 00 00 00       	mov    $0x3,%esi
  800c63:	48 89 c7             	mov    %rax,%rdi
  800c66:	48 b8 d1 07 80 00 00 	movabs $0x8007d1,%rax
  800c6d:	00 00 00 
  800c70:	ff d0                	callq  *%rax
  800c72:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c7a:	48 85 c0             	test   %rax,%rax
  800c7d:	79 1d                	jns    800c9c <vprintfmt+0x3bb>
				putch('-', putdat);
  800c7f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c83:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c87:	48 89 d6             	mov    %rdx,%rsi
  800c8a:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c8f:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c95:	48 f7 d8             	neg    %rax
  800c98:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c9c:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ca3:	e9 d5 00 00 00       	jmpq   800d7d <vprintfmt+0x49c>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800ca8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cac:	be 03 00 00 00       	mov    $0x3,%esi
  800cb1:	48 89 c7             	mov    %rax,%rdi
  800cb4:	48 b8 c1 06 80 00 00 	movabs $0x8006c1,%rax
  800cbb:	00 00 00 
  800cbe:	ff d0                	callq  *%rax
  800cc0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800cc4:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ccb:	e9 ad 00 00 00       	jmpq   800d7d <vprintfmt+0x49c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800cd0:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800cd3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cd7:	89 d6                	mov    %edx,%esi
  800cd9:	48 89 c7             	mov    %rax,%rdi
  800cdc:	48 b8 d1 07 80 00 00 	movabs $0x8007d1,%rax
  800ce3:	00 00 00 
  800ce6:	ff d0                	callq  *%rax
  800ce8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800cec:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800cf3:	e9 85 00 00 00       	jmpq   800d7d <vprintfmt+0x49c>


		// pointer
		case 'p':
			putch('0', putdat);
  800cf8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cfc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d00:	48 89 d6             	mov    %rdx,%rsi
  800d03:	bf 30 00 00 00       	mov    $0x30,%edi
  800d08:	ff d0                	callq  *%rax
			putch('x', putdat);
  800d0a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d0e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d12:	48 89 d6             	mov    %rdx,%rsi
  800d15:	bf 78 00 00 00       	mov    $0x78,%edi
  800d1a:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800d1c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d1f:	83 f8 30             	cmp    $0x30,%eax
  800d22:	73 17                	jae    800d3b <vprintfmt+0x45a>
  800d24:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d28:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d2b:	89 c0                	mov    %eax,%eax
  800d2d:	48 01 d0             	add    %rdx,%rax
  800d30:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d33:	83 c2 08             	add    $0x8,%edx
  800d36:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d39:	eb 0f                	jmp    800d4a <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800d3b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d3f:	48 89 d0             	mov    %rdx,%rax
  800d42:	48 83 c2 08          	add    $0x8,%rdx
  800d46:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d4a:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d4d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800d51:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800d58:	eb 23                	jmp    800d7d <vprintfmt+0x49c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800d5a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d5e:	be 03 00 00 00       	mov    $0x3,%esi
  800d63:	48 89 c7             	mov    %rax,%rdi
  800d66:	48 b8 c1 06 80 00 00 	movabs $0x8006c1,%rax
  800d6d:	00 00 00 
  800d70:	ff d0                	callq  *%rax
  800d72:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d76:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d7d:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d82:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d85:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d88:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d8c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d90:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d94:	45 89 c1             	mov    %r8d,%r9d
  800d97:	41 89 f8             	mov    %edi,%r8d
  800d9a:	48 89 c7             	mov    %rax,%rdi
  800d9d:	48 b8 06 06 80 00 00 	movabs $0x800606,%rax
  800da4:	00 00 00 
  800da7:	ff d0                	callq  *%rax
			break;
  800da9:	eb 3f                	jmp    800dea <vprintfmt+0x509>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800dab:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800daf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800db3:	48 89 d6             	mov    %rdx,%rsi
  800db6:	89 df                	mov    %ebx,%edi
  800db8:	ff d0                	callq  *%rax
			break;
  800dba:	eb 2e                	jmp    800dea <vprintfmt+0x509>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800dbc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dc0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dc4:	48 89 d6             	mov    %rdx,%rsi
  800dc7:	bf 25 00 00 00       	mov    $0x25,%edi
  800dcc:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800dce:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800dd3:	eb 05                	jmp    800dda <vprintfmt+0x4f9>
  800dd5:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800dda:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800dde:	48 83 e8 01          	sub    $0x1,%rax
  800de2:	0f b6 00             	movzbl (%rax),%eax
  800de5:	3c 25                	cmp    $0x25,%al
  800de7:	75 ec                	jne    800dd5 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800de9:	90                   	nop
		}
	}
  800dea:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800deb:	e9 43 fb ff ff       	jmpq   800933 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  800df0:	48 83 c4 60          	add    $0x60,%rsp
  800df4:	5b                   	pop    %rbx
  800df5:	41 5c                	pop    %r12
  800df7:	5d                   	pop    %rbp
  800df8:	c3                   	retq   

0000000000800df9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800df9:	55                   	push   %rbp
  800dfa:	48 89 e5             	mov    %rsp,%rbp
  800dfd:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800e04:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800e0b:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800e12:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e19:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e20:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e27:	84 c0                	test   %al,%al
  800e29:	74 20                	je     800e4b <printfmt+0x52>
  800e2b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e2f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e33:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e37:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e3b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e3f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e43:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e47:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e4b:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800e52:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800e59:	00 00 00 
  800e5c:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e63:	00 00 00 
  800e66:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e6a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e71:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e78:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e7f:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e86:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e8d:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e94:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e9b:	48 89 c7             	mov    %rax,%rdi
  800e9e:	48 b8 e1 08 80 00 00 	movabs $0x8008e1,%rax
  800ea5:	00 00 00 
  800ea8:	ff d0                	callq  *%rax
	va_end(ap);
}
  800eaa:	c9                   	leaveq 
  800eab:	c3                   	retq   

0000000000800eac <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800eac:	55                   	push   %rbp
  800ead:	48 89 e5             	mov    %rsp,%rbp
  800eb0:	48 83 ec 10          	sub    $0x10,%rsp
  800eb4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800eb7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800ebb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ebf:	8b 40 10             	mov    0x10(%rax),%eax
  800ec2:	8d 50 01             	lea    0x1(%rax),%edx
  800ec5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ec9:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800ecc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ed0:	48 8b 10             	mov    (%rax),%rdx
  800ed3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ed7:	48 8b 40 08          	mov    0x8(%rax),%rax
  800edb:	48 39 c2             	cmp    %rax,%rdx
  800ede:	73 17                	jae    800ef7 <sprintputch+0x4b>
		*b->buf++ = ch;
  800ee0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ee4:	48 8b 00             	mov    (%rax),%rax
  800ee7:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800eeb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800eef:	48 89 0a             	mov    %rcx,(%rdx)
  800ef2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800ef5:	88 10                	mov    %dl,(%rax)
}
  800ef7:	c9                   	leaveq 
  800ef8:	c3                   	retq   

0000000000800ef9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ef9:	55                   	push   %rbp
  800efa:	48 89 e5             	mov    %rsp,%rbp
  800efd:	48 83 ec 50          	sub    $0x50,%rsp
  800f01:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800f05:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800f08:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800f0c:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800f10:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800f14:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800f18:	48 8b 0a             	mov    (%rdx),%rcx
  800f1b:	48 89 08             	mov    %rcx,(%rax)
  800f1e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f22:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f26:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f2a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f2e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f32:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800f36:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800f39:	48 98                	cltq   
  800f3b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800f3f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f43:	48 01 d0             	add    %rdx,%rax
  800f46:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800f4a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800f51:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800f56:	74 06                	je     800f5e <vsnprintf+0x65>
  800f58:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800f5c:	7f 07                	jg     800f65 <vsnprintf+0x6c>
		return -E_INVAL;
  800f5e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f63:	eb 2f                	jmp    800f94 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f65:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f69:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f6d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f71:	48 89 c6             	mov    %rax,%rsi
  800f74:	48 bf ac 0e 80 00 00 	movabs $0x800eac,%rdi
  800f7b:	00 00 00 
  800f7e:	48 b8 e1 08 80 00 00 	movabs $0x8008e1,%rax
  800f85:	00 00 00 
  800f88:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f8a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f8e:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f91:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f94:	c9                   	leaveq 
  800f95:	c3                   	retq   

0000000000800f96 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f96:	55                   	push   %rbp
  800f97:	48 89 e5             	mov    %rsp,%rbp
  800f9a:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800fa1:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800fa8:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800fae:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800fb5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800fbc:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800fc3:	84 c0                	test   %al,%al
  800fc5:	74 20                	je     800fe7 <snprintf+0x51>
  800fc7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800fcb:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800fcf:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800fd3:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800fd7:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800fdb:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800fdf:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800fe3:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800fe7:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800fee:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800ff5:	00 00 00 
  800ff8:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800fff:	00 00 00 
  801002:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801006:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80100d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801014:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80101b:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801022:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801029:	48 8b 0a             	mov    (%rdx),%rcx
  80102c:	48 89 08             	mov    %rcx,(%rax)
  80102f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801033:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801037:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80103b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80103f:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801046:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80104d:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801053:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80105a:	48 89 c7             	mov    %rax,%rdi
  80105d:	48 b8 f9 0e 80 00 00 	movabs $0x800ef9,%rax
  801064:	00 00 00 
  801067:	ff d0                	callq  *%rax
  801069:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80106f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801075:	c9                   	leaveq 
  801076:	c3                   	retq   

0000000000801077 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801077:	55                   	push   %rbp
  801078:	48 89 e5             	mov    %rsp,%rbp
  80107b:	48 83 ec 18          	sub    $0x18,%rsp
  80107f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801083:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80108a:	eb 09                	jmp    801095 <strlen+0x1e>
		n++;
  80108c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801090:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801095:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801099:	0f b6 00             	movzbl (%rax),%eax
  80109c:	84 c0                	test   %al,%al
  80109e:	75 ec                	jne    80108c <strlen+0x15>
		n++;
	return n;
  8010a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010a3:	c9                   	leaveq 
  8010a4:	c3                   	retq   

00000000008010a5 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8010a5:	55                   	push   %rbp
  8010a6:	48 89 e5             	mov    %rsp,%rbp
  8010a9:	48 83 ec 20          	sub    $0x20,%rsp
  8010ad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010b1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010bc:	eb 0e                	jmp    8010cc <strnlen+0x27>
		n++;
  8010be:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010c2:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010c7:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8010cc:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8010d1:	74 0b                	je     8010de <strnlen+0x39>
  8010d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d7:	0f b6 00             	movzbl (%rax),%eax
  8010da:	84 c0                	test   %al,%al
  8010dc:	75 e0                	jne    8010be <strnlen+0x19>
		n++;
	return n;
  8010de:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010e1:	c9                   	leaveq 
  8010e2:	c3                   	retq   

00000000008010e3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010e3:	55                   	push   %rbp
  8010e4:	48 89 e5             	mov    %rsp,%rbp
  8010e7:	48 83 ec 20          	sub    $0x20,%rsp
  8010eb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010ef:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8010f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8010fb:	90                   	nop
  8010fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801100:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801104:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801108:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80110c:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801110:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801114:	0f b6 12             	movzbl (%rdx),%edx
  801117:	88 10                	mov    %dl,(%rax)
  801119:	0f b6 00             	movzbl (%rax),%eax
  80111c:	84 c0                	test   %al,%al
  80111e:	75 dc                	jne    8010fc <strcpy+0x19>
		/* do nothing */;
	return ret;
  801120:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801124:	c9                   	leaveq 
  801125:	c3                   	retq   

0000000000801126 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801126:	55                   	push   %rbp
  801127:	48 89 e5             	mov    %rsp,%rbp
  80112a:	48 83 ec 20          	sub    $0x20,%rsp
  80112e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801132:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801136:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80113a:	48 89 c7             	mov    %rax,%rdi
  80113d:	48 b8 77 10 80 00 00 	movabs $0x801077,%rax
  801144:	00 00 00 
  801147:	ff d0                	callq  *%rax
  801149:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80114c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80114f:	48 63 d0             	movslq %eax,%rdx
  801152:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801156:	48 01 c2             	add    %rax,%rdx
  801159:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80115d:	48 89 c6             	mov    %rax,%rsi
  801160:	48 89 d7             	mov    %rdx,%rdi
  801163:	48 b8 e3 10 80 00 00 	movabs $0x8010e3,%rax
  80116a:	00 00 00 
  80116d:	ff d0                	callq  *%rax
	return dst;
  80116f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801173:	c9                   	leaveq 
  801174:	c3                   	retq   

0000000000801175 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801175:	55                   	push   %rbp
  801176:	48 89 e5             	mov    %rsp,%rbp
  801179:	48 83 ec 28          	sub    $0x28,%rsp
  80117d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801181:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801185:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801189:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80118d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801191:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801198:	00 
  801199:	eb 2a                	jmp    8011c5 <strncpy+0x50>
		*dst++ = *src;
  80119b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80119f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011a3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011a7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011ab:	0f b6 12             	movzbl (%rdx),%edx
  8011ae:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8011b0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011b4:	0f b6 00             	movzbl (%rax),%eax
  8011b7:	84 c0                	test   %al,%al
  8011b9:	74 05                	je     8011c0 <strncpy+0x4b>
			src++;
  8011bb:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011c0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011c9:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8011cd:	72 cc                	jb     80119b <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8011cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8011d3:	c9                   	leaveq 
  8011d4:	c3                   	retq   

00000000008011d5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8011d5:	55                   	push   %rbp
  8011d6:	48 89 e5             	mov    %rsp,%rbp
  8011d9:	48 83 ec 28          	sub    $0x28,%rsp
  8011dd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011e1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011e5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8011e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ed:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8011f1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011f6:	74 3d                	je     801235 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8011f8:	eb 1d                	jmp    801217 <strlcpy+0x42>
			*dst++ = *src++;
  8011fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011fe:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801202:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801206:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80120a:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80120e:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801212:	0f b6 12             	movzbl (%rdx),%edx
  801215:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801217:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80121c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801221:	74 0b                	je     80122e <strlcpy+0x59>
  801223:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801227:	0f b6 00             	movzbl (%rax),%eax
  80122a:	84 c0                	test   %al,%al
  80122c:	75 cc                	jne    8011fa <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80122e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801232:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801235:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801239:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80123d:	48 29 c2             	sub    %rax,%rdx
  801240:	48 89 d0             	mov    %rdx,%rax
}
  801243:	c9                   	leaveq 
  801244:	c3                   	retq   

0000000000801245 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801245:	55                   	push   %rbp
  801246:	48 89 e5             	mov    %rsp,%rbp
  801249:	48 83 ec 10          	sub    $0x10,%rsp
  80124d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801251:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801255:	eb 0a                	jmp    801261 <strcmp+0x1c>
		p++, q++;
  801257:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80125c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801261:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801265:	0f b6 00             	movzbl (%rax),%eax
  801268:	84 c0                	test   %al,%al
  80126a:	74 12                	je     80127e <strcmp+0x39>
  80126c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801270:	0f b6 10             	movzbl (%rax),%edx
  801273:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801277:	0f b6 00             	movzbl (%rax),%eax
  80127a:	38 c2                	cmp    %al,%dl
  80127c:	74 d9                	je     801257 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80127e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801282:	0f b6 00             	movzbl (%rax),%eax
  801285:	0f b6 d0             	movzbl %al,%edx
  801288:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80128c:	0f b6 00             	movzbl (%rax),%eax
  80128f:	0f b6 c0             	movzbl %al,%eax
  801292:	29 c2                	sub    %eax,%edx
  801294:	89 d0                	mov    %edx,%eax
}
  801296:	c9                   	leaveq 
  801297:	c3                   	retq   

0000000000801298 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801298:	55                   	push   %rbp
  801299:	48 89 e5             	mov    %rsp,%rbp
  80129c:	48 83 ec 18          	sub    $0x18,%rsp
  8012a0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012a4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8012a8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8012ac:	eb 0f                	jmp    8012bd <strncmp+0x25>
		n--, p++, q++;
  8012ae:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8012b3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012b8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8012bd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012c2:	74 1d                	je     8012e1 <strncmp+0x49>
  8012c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c8:	0f b6 00             	movzbl (%rax),%eax
  8012cb:	84 c0                	test   %al,%al
  8012cd:	74 12                	je     8012e1 <strncmp+0x49>
  8012cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d3:	0f b6 10             	movzbl (%rax),%edx
  8012d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012da:	0f b6 00             	movzbl (%rax),%eax
  8012dd:	38 c2                	cmp    %al,%dl
  8012df:	74 cd                	je     8012ae <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8012e1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012e6:	75 07                	jne    8012ef <strncmp+0x57>
		return 0;
  8012e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ed:	eb 18                	jmp    801307 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f3:	0f b6 00             	movzbl (%rax),%eax
  8012f6:	0f b6 d0             	movzbl %al,%edx
  8012f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012fd:	0f b6 00             	movzbl (%rax),%eax
  801300:	0f b6 c0             	movzbl %al,%eax
  801303:	29 c2                	sub    %eax,%edx
  801305:	89 d0                	mov    %edx,%eax
}
  801307:	c9                   	leaveq 
  801308:	c3                   	retq   

0000000000801309 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801309:	55                   	push   %rbp
  80130a:	48 89 e5             	mov    %rsp,%rbp
  80130d:	48 83 ec 0c          	sub    $0xc,%rsp
  801311:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801315:	89 f0                	mov    %esi,%eax
  801317:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80131a:	eb 17                	jmp    801333 <strchr+0x2a>
		if (*s == c)
  80131c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801320:	0f b6 00             	movzbl (%rax),%eax
  801323:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801326:	75 06                	jne    80132e <strchr+0x25>
			return (char *) s;
  801328:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80132c:	eb 15                	jmp    801343 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80132e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801333:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801337:	0f b6 00             	movzbl (%rax),%eax
  80133a:	84 c0                	test   %al,%al
  80133c:	75 de                	jne    80131c <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80133e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801343:	c9                   	leaveq 
  801344:	c3                   	retq   

0000000000801345 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801345:	55                   	push   %rbp
  801346:	48 89 e5             	mov    %rsp,%rbp
  801349:	48 83 ec 0c          	sub    $0xc,%rsp
  80134d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801351:	89 f0                	mov    %esi,%eax
  801353:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801356:	eb 13                	jmp    80136b <strfind+0x26>
		if (*s == c)
  801358:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80135c:	0f b6 00             	movzbl (%rax),%eax
  80135f:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801362:	75 02                	jne    801366 <strfind+0x21>
			break;
  801364:	eb 10                	jmp    801376 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801366:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80136b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136f:	0f b6 00             	movzbl (%rax),%eax
  801372:	84 c0                	test   %al,%al
  801374:	75 e2                	jne    801358 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801376:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80137a:	c9                   	leaveq 
  80137b:	c3                   	retq   

000000000080137c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80137c:	55                   	push   %rbp
  80137d:	48 89 e5             	mov    %rsp,%rbp
  801380:	48 83 ec 18          	sub    $0x18,%rsp
  801384:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801388:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80138b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80138f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801394:	75 06                	jne    80139c <memset+0x20>
		return v;
  801396:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80139a:	eb 69                	jmp    801405 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80139c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013a0:	83 e0 03             	and    $0x3,%eax
  8013a3:	48 85 c0             	test   %rax,%rax
  8013a6:	75 48                	jne    8013f0 <memset+0x74>
  8013a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ac:	83 e0 03             	and    $0x3,%eax
  8013af:	48 85 c0             	test   %rax,%rax
  8013b2:	75 3c                	jne    8013f0 <memset+0x74>
		c &= 0xFF;
  8013b4:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8013bb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013be:	c1 e0 18             	shl    $0x18,%eax
  8013c1:	89 c2                	mov    %eax,%edx
  8013c3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013c6:	c1 e0 10             	shl    $0x10,%eax
  8013c9:	09 c2                	or     %eax,%edx
  8013cb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013ce:	c1 e0 08             	shl    $0x8,%eax
  8013d1:	09 d0                	or     %edx,%eax
  8013d3:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8013d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013da:	48 c1 e8 02          	shr    $0x2,%rax
  8013de:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8013e1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013e5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013e8:	48 89 d7             	mov    %rdx,%rdi
  8013eb:	fc                   	cld    
  8013ec:	f3 ab                	rep stos %eax,%es:(%rdi)
  8013ee:	eb 11                	jmp    801401 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8013f0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013f4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013f7:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8013fb:	48 89 d7             	mov    %rdx,%rdi
  8013fe:	fc                   	cld    
  8013ff:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801401:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801405:	c9                   	leaveq 
  801406:	c3                   	retq   

0000000000801407 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801407:	55                   	push   %rbp
  801408:	48 89 e5             	mov    %rsp,%rbp
  80140b:	48 83 ec 28          	sub    $0x28,%rsp
  80140f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801413:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801417:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80141b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80141f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801423:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801427:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80142b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80142f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801433:	0f 83 88 00 00 00    	jae    8014c1 <memmove+0xba>
  801439:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80143d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801441:	48 01 d0             	add    %rdx,%rax
  801444:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801448:	76 77                	jbe    8014c1 <memmove+0xba>
		s += n;
  80144a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144e:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801452:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801456:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80145a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80145e:	83 e0 03             	and    $0x3,%eax
  801461:	48 85 c0             	test   %rax,%rax
  801464:	75 3b                	jne    8014a1 <memmove+0x9a>
  801466:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80146a:	83 e0 03             	and    $0x3,%eax
  80146d:	48 85 c0             	test   %rax,%rax
  801470:	75 2f                	jne    8014a1 <memmove+0x9a>
  801472:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801476:	83 e0 03             	and    $0x3,%eax
  801479:	48 85 c0             	test   %rax,%rax
  80147c:	75 23                	jne    8014a1 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80147e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801482:	48 83 e8 04          	sub    $0x4,%rax
  801486:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80148a:	48 83 ea 04          	sub    $0x4,%rdx
  80148e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801492:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801496:	48 89 c7             	mov    %rax,%rdi
  801499:	48 89 d6             	mov    %rdx,%rsi
  80149c:	fd                   	std    
  80149d:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80149f:	eb 1d                	jmp    8014be <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8014a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a5:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8014a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ad:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8014b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b5:	48 89 d7             	mov    %rdx,%rdi
  8014b8:	48 89 c1             	mov    %rax,%rcx
  8014bb:	fd                   	std    
  8014bc:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8014be:	fc                   	cld    
  8014bf:	eb 57                	jmp    801518 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8014c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c5:	83 e0 03             	and    $0x3,%eax
  8014c8:	48 85 c0             	test   %rax,%rax
  8014cb:	75 36                	jne    801503 <memmove+0xfc>
  8014cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014d1:	83 e0 03             	and    $0x3,%eax
  8014d4:	48 85 c0             	test   %rax,%rax
  8014d7:	75 2a                	jne    801503 <memmove+0xfc>
  8014d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014dd:	83 e0 03             	and    $0x3,%eax
  8014e0:	48 85 c0             	test   %rax,%rax
  8014e3:	75 1e                	jne    801503 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8014e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e9:	48 c1 e8 02          	shr    $0x2,%rax
  8014ed:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8014f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014f4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014f8:	48 89 c7             	mov    %rax,%rdi
  8014fb:	48 89 d6             	mov    %rdx,%rsi
  8014fe:	fc                   	cld    
  8014ff:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801501:	eb 15                	jmp    801518 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801503:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801507:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80150b:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80150f:	48 89 c7             	mov    %rax,%rdi
  801512:	48 89 d6             	mov    %rdx,%rsi
  801515:	fc                   	cld    
  801516:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801518:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80151c:	c9                   	leaveq 
  80151d:	c3                   	retq   

000000000080151e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80151e:	55                   	push   %rbp
  80151f:	48 89 e5             	mov    %rsp,%rbp
  801522:	48 83 ec 18          	sub    $0x18,%rsp
  801526:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80152a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80152e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801532:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801536:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80153a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80153e:	48 89 ce             	mov    %rcx,%rsi
  801541:	48 89 c7             	mov    %rax,%rdi
  801544:	48 b8 07 14 80 00 00 	movabs $0x801407,%rax
  80154b:	00 00 00 
  80154e:	ff d0                	callq  *%rax
}
  801550:	c9                   	leaveq 
  801551:	c3                   	retq   

0000000000801552 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801552:	55                   	push   %rbp
  801553:	48 89 e5             	mov    %rsp,%rbp
  801556:	48 83 ec 28          	sub    $0x28,%rsp
  80155a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80155e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801562:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801566:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80156a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80156e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801572:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801576:	eb 36                	jmp    8015ae <memcmp+0x5c>
		if (*s1 != *s2)
  801578:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80157c:	0f b6 10             	movzbl (%rax),%edx
  80157f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801583:	0f b6 00             	movzbl (%rax),%eax
  801586:	38 c2                	cmp    %al,%dl
  801588:	74 1a                	je     8015a4 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80158a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80158e:	0f b6 00             	movzbl (%rax),%eax
  801591:	0f b6 d0             	movzbl %al,%edx
  801594:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801598:	0f b6 00             	movzbl (%rax),%eax
  80159b:	0f b6 c0             	movzbl %al,%eax
  80159e:	29 c2                	sub    %eax,%edx
  8015a0:	89 d0                	mov    %edx,%eax
  8015a2:	eb 20                	jmp    8015c4 <memcmp+0x72>
		s1++, s2++;
  8015a4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015a9:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8015ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b2:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015b6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8015ba:	48 85 c0             	test   %rax,%rax
  8015bd:	75 b9                	jne    801578 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015c4:	c9                   	leaveq 
  8015c5:	c3                   	retq   

00000000008015c6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8015c6:	55                   	push   %rbp
  8015c7:	48 89 e5             	mov    %rsp,%rbp
  8015ca:	48 83 ec 28          	sub    $0x28,%rsp
  8015ce:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015d2:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8015d5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8015d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015dd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015e1:	48 01 d0             	add    %rdx,%rax
  8015e4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8015e8:	eb 15                	jmp    8015ff <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015ee:	0f b6 10             	movzbl (%rax),%edx
  8015f1:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8015f4:	38 c2                	cmp    %al,%dl
  8015f6:	75 02                	jne    8015fa <memfind+0x34>
			break;
  8015f8:	eb 0f                	jmp    801609 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015fa:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8015ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801603:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801607:	72 e1                	jb     8015ea <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801609:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80160d:	c9                   	leaveq 
  80160e:	c3                   	retq   

000000000080160f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80160f:	55                   	push   %rbp
  801610:	48 89 e5             	mov    %rsp,%rbp
  801613:	48 83 ec 34          	sub    $0x34,%rsp
  801617:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80161b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80161f:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801622:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801629:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801630:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801631:	eb 05                	jmp    801638 <strtol+0x29>
		s++;
  801633:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801638:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163c:	0f b6 00             	movzbl (%rax),%eax
  80163f:	3c 20                	cmp    $0x20,%al
  801641:	74 f0                	je     801633 <strtol+0x24>
  801643:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801647:	0f b6 00             	movzbl (%rax),%eax
  80164a:	3c 09                	cmp    $0x9,%al
  80164c:	74 e5                	je     801633 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80164e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801652:	0f b6 00             	movzbl (%rax),%eax
  801655:	3c 2b                	cmp    $0x2b,%al
  801657:	75 07                	jne    801660 <strtol+0x51>
		s++;
  801659:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80165e:	eb 17                	jmp    801677 <strtol+0x68>
	else if (*s == '-')
  801660:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801664:	0f b6 00             	movzbl (%rax),%eax
  801667:	3c 2d                	cmp    $0x2d,%al
  801669:	75 0c                	jne    801677 <strtol+0x68>
		s++, neg = 1;
  80166b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801670:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801677:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80167b:	74 06                	je     801683 <strtol+0x74>
  80167d:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801681:	75 28                	jne    8016ab <strtol+0x9c>
  801683:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801687:	0f b6 00             	movzbl (%rax),%eax
  80168a:	3c 30                	cmp    $0x30,%al
  80168c:	75 1d                	jne    8016ab <strtol+0x9c>
  80168e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801692:	48 83 c0 01          	add    $0x1,%rax
  801696:	0f b6 00             	movzbl (%rax),%eax
  801699:	3c 78                	cmp    $0x78,%al
  80169b:	75 0e                	jne    8016ab <strtol+0x9c>
		s += 2, base = 16;
  80169d:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8016a2:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8016a9:	eb 2c                	jmp    8016d7 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8016ab:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016af:	75 19                	jne    8016ca <strtol+0xbb>
  8016b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b5:	0f b6 00             	movzbl (%rax),%eax
  8016b8:	3c 30                	cmp    $0x30,%al
  8016ba:	75 0e                	jne    8016ca <strtol+0xbb>
		s++, base = 8;
  8016bc:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016c1:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8016c8:	eb 0d                	jmp    8016d7 <strtol+0xc8>
	else if (base == 0)
  8016ca:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016ce:	75 07                	jne    8016d7 <strtol+0xc8>
		base = 10;
  8016d0:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016db:	0f b6 00             	movzbl (%rax),%eax
  8016de:	3c 2f                	cmp    $0x2f,%al
  8016e0:	7e 1d                	jle    8016ff <strtol+0xf0>
  8016e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e6:	0f b6 00             	movzbl (%rax),%eax
  8016e9:	3c 39                	cmp    $0x39,%al
  8016eb:	7f 12                	jg     8016ff <strtol+0xf0>
			dig = *s - '0';
  8016ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f1:	0f b6 00             	movzbl (%rax),%eax
  8016f4:	0f be c0             	movsbl %al,%eax
  8016f7:	83 e8 30             	sub    $0x30,%eax
  8016fa:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016fd:	eb 4e                	jmp    80174d <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8016ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801703:	0f b6 00             	movzbl (%rax),%eax
  801706:	3c 60                	cmp    $0x60,%al
  801708:	7e 1d                	jle    801727 <strtol+0x118>
  80170a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80170e:	0f b6 00             	movzbl (%rax),%eax
  801711:	3c 7a                	cmp    $0x7a,%al
  801713:	7f 12                	jg     801727 <strtol+0x118>
			dig = *s - 'a' + 10;
  801715:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801719:	0f b6 00             	movzbl (%rax),%eax
  80171c:	0f be c0             	movsbl %al,%eax
  80171f:	83 e8 57             	sub    $0x57,%eax
  801722:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801725:	eb 26                	jmp    80174d <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801727:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80172b:	0f b6 00             	movzbl (%rax),%eax
  80172e:	3c 40                	cmp    $0x40,%al
  801730:	7e 48                	jle    80177a <strtol+0x16b>
  801732:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801736:	0f b6 00             	movzbl (%rax),%eax
  801739:	3c 5a                	cmp    $0x5a,%al
  80173b:	7f 3d                	jg     80177a <strtol+0x16b>
			dig = *s - 'A' + 10;
  80173d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801741:	0f b6 00             	movzbl (%rax),%eax
  801744:	0f be c0             	movsbl %al,%eax
  801747:	83 e8 37             	sub    $0x37,%eax
  80174a:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80174d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801750:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801753:	7c 02                	jl     801757 <strtol+0x148>
			break;
  801755:	eb 23                	jmp    80177a <strtol+0x16b>
		s++, val = (val * base) + dig;
  801757:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80175c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80175f:	48 98                	cltq   
  801761:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801766:	48 89 c2             	mov    %rax,%rdx
  801769:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80176c:	48 98                	cltq   
  80176e:	48 01 d0             	add    %rdx,%rax
  801771:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801775:	e9 5d ff ff ff       	jmpq   8016d7 <strtol+0xc8>

	if (endptr)
  80177a:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80177f:	74 0b                	je     80178c <strtol+0x17d>
		*endptr = (char *) s;
  801781:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801785:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801789:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80178c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801790:	74 09                	je     80179b <strtol+0x18c>
  801792:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801796:	48 f7 d8             	neg    %rax
  801799:	eb 04                	jmp    80179f <strtol+0x190>
  80179b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80179f:	c9                   	leaveq 
  8017a0:	c3                   	retq   

00000000008017a1 <strstr>:

char * strstr(const char *in, const char *str)
{
  8017a1:	55                   	push   %rbp
  8017a2:	48 89 e5             	mov    %rsp,%rbp
  8017a5:	48 83 ec 30          	sub    $0x30,%rsp
  8017a9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8017ad:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  8017b1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017b5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017b9:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017bd:	0f b6 00             	movzbl (%rax),%eax
  8017c0:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  8017c3:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8017c7:	75 06                	jne    8017cf <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  8017c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017cd:	eb 6b                	jmp    80183a <strstr+0x99>

    len = strlen(str);
  8017cf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017d3:	48 89 c7             	mov    %rax,%rdi
  8017d6:	48 b8 77 10 80 00 00 	movabs $0x801077,%rax
  8017dd:	00 00 00 
  8017e0:	ff d0                	callq  *%rax
  8017e2:	48 98                	cltq   
  8017e4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  8017e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ec:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017f0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017f4:	0f b6 00             	movzbl (%rax),%eax
  8017f7:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  8017fa:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8017fe:	75 07                	jne    801807 <strstr+0x66>
                return (char *) 0;
  801800:	b8 00 00 00 00       	mov    $0x0,%eax
  801805:	eb 33                	jmp    80183a <strstr+0x99>
        } while (sc != c);
  801807:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80180b:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80180e:	75 d8                	jne    8017e8 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  801810:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801814:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801818:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80181c:	48 89 ce             	mov    %rcx,%rsi
  80181f:	48 89 c7             	mov    %rax,%rdi
  801822:	48 b8 98 12 80 00 00 	movabs $0x801298,%rax
  801829:	00 00 00 
  80182c:	ff d0                	callq  *%rax
  80182e:	85 c0                	test   %eax,%eax
  801830:	75 b6                	jne    8017e8 <strstr+0x47>

    return (char *) (in - 1);
  801832:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801836:	48 83 e8 01          	sub    $0x1,%rax
}
  80183a:	c9                   	leaveq 
  80183b:	c3                   	retq   

000000000080183c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80183c:	55                   	push   %rbp
  80183d:	48 89 e5             	mov    %rsp,%rbp
  801840:	53                   	push   %rbx
  801841:	48 83 ec 48          	sub    $0x48,%rsp
  801845:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801848:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80184b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80184f:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801853:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801857:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80185b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80185e:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801862:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801866:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80186a:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80186e:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801872:	4c 89 c3             	mov    %r8,%rbx
  801875:	cd 30                	int    $0x30
  801877:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80187b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80187f:	74 3e                	je     8018bf <syscall+0x83>
  801881:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801886:	7e 37                	jle    8018bf <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801888:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80188c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80188f:	49 89 d0             	mov    %rdx,%r8
  801892:	89 c1                	mov    %eax,%ecx
  801894:	48 ba c0 46 80 00 00 	movabs $0x8046c0,%rdx
  80189b:	00 00 00 
  80189e:	be 23 00 00 00       	mov    $0x23,%esi
  8018a3:	48 bf dd 46 80 00 00 	movabs $0x8046dd,%rdi
  8018aa:	00 00 00 
  8018ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8018b2:	49 b9 f5 02 80 00 00 	movabs $0x8002f5,%r9
  8018b9:	00 00 00 
  8018bc:	41 ff d1             	callq  *%r9

	return ret;
  8018bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018c3:	48 83 c4 48          	add    $0x48,%rsp
  8018c7:	5b                   	pop    %rbx
  8018c8:	5d                   	pop    %rbp
  8018c9:	c3                   	retq   

00000000008018ca <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8018ca:	55                   	push   %rbp
  8018cb:	48 89 e5             	mov    %rsp,%rbp
  8018ce:	48 83 ec 20          	sub    $0x20,%rsp
  8018d2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018d6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8018da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018de:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018e2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018e9:	00 
  8018ea:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018f0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018f6:	48 89 d1             	mov    %rdx,%rcx
  8018f9:	48 89 c2             	mov    %rax,%rdx
  8018fc:	be 00 00 00 00       	mov    $0x0,%esi
  801901:	bf 00 00 00 00       	mov    $0x0,%edi
  801906:	48 b8 3c 18 80 00 00 	movabs $0x80183c,%rax
  80190d:	00 00 00 
  801910:	ff d0                	callq  *%rax
}
  801912:	c9                   	leaveq 
  801913:	c3                   	retq   

0000000000801914 <sys_cgetc>:

int
sys_cgetc(void)
{
  801914:	55                   	push   %rbp
  801915:	48 89 e5             	mov    %rsp,%rbp
  801918:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80191c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801923:	00 
  801924:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80192a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801930:	b9 00 00 00 00       	mov    $0x0,%ecx
  801935:	ba 00 00 00 00       	mov    $0x0,%edx
  80193a:	be 00 00 00 00       	mov    $0x0,%esi
  80193f:	bf 01 00 00 00       	mov    $0x1,%edi
  801944:	48 b8 3c 18 80 00 00 	movabs $0x80183c,%rax
  80194b:	00 00 00 
  80194e:	ff d0                	callq  *%rax
}
  801950:	c9                   	leaveq 
  801951:	c3                   	retq   

0000000000801952 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801952:	55                   	push   %rbp
  801953:	48 89 e5             	mov    %rsp,%rbp
  801956:	48 83 ec 10          	sub    $0x10,%rsp
  80195a:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80195d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801960:	48 98                	cltq   
  801962:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801969:	00 
  80196a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801970:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801976:	b9 00 00 00 00       	mov    $0x0,%ecx
  80197b:	48 89 c2             	mov    %rax,%rdx
  80197e:	be 01 00 00 00       	mov    $0x1,%esi
  801983:	bf 03 00 00 00       	mov    $0x3,%edi
  801988:	48 b8 3c 18 80 00 00 	movabs $0x80183c,%rax
  80198f:	00 00 00 
  801992:	ff d0                	callq  *%rax
}
  801994:	c9                   	leaveq 
  801995:	c3                   	retq   

0000000000801996 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801996:	55                   	push   %rbp
  801997:	48 89 e5             	mov    %rsp,%rbp
  80199a:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80199e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019a5:	00 
  8019a6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019ac:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019b2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8019bc:	be 00 00 00 00       	mov    $0x0,%esi
  8019c1:	bf 02 00 00 00       	mov    $0x2,%edi
  8019c6:	48 b8 3c 18 80 00 00 	movabs $0x80183c,%rax
  8019cd:	00 00 00 
  8019d0:	ff d0                	callq  *%rax
}
  8019d2:	c9                   	leaveq 
  8019d3:	c3                   	retq   

00000000008019d4 <sys_yield>:

void
sys_yield(void)
{
  8019d4:	55                   	push   %rbp
  8019d5:	48 89 e5             	mov    %rsp,%rbp
  8019d8:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8019dc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019e3:	00 
  8019e4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019ea:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019f0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8019fa:	be 00 00 00 00       	mov    $0x0,%esi
  8019ff:	bf 0b 00 00 00       	mov    $0xb,%edi
  801a04:	48 b8 3c 18 80 00 00 	movabs $0x80183c,%rax
  801a0b:	00 00 00 
  801a0e:	ff d0                	callq  *%rax
}
  801a10:	c9                   	leaveq 
  801a11:	c3                   	retq   

0000000000801a12 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801a12:	55                   	push   %rbp
  801a13:	48 89 e5             	mov    %rsp,%rbp
  801a16:	48 83 ec 20          	sub    $0x20,%rsp
  801a1a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a1d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a21:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801a24:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a27:	48 63 c8             	movslq %eax,%rcx
  801a2a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a31:	48 98                	cltq   
  801a33:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a3a:	00 
  801a3b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a41:	49 89 c8             	mov    %rcx,%r8
  801a44:	48 89 d1             	mov    %rdx,%rcx
  801a47:	48 89 c2             	mov    %rax,%rdx
  801a4a:	be 01 00 00 00       	mov    $0x1,%esi
  801a4f:	bf 04 00 00 00       	mov    $0x4,%edi
  801a54:	48 b8 3c 18 80 00 00 	movabs $0x80183c,%rax
  801a5b:	00 00 00 
  801a5e:	ff d0                	callq  *%rax
}
  801a60:	c9                   	leaveq 
  801a61:	c3                   	retq   

0000000000801a62 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801a62:	55                   	push   %rbp
  801a63:	48 89 e5             	mov    %rsp,%rbp
  801a66:	48 83 ec 30          	sub    $0x30,%rsp
  801a6a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a6d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a71:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a74:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801a78:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801a7c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a7f:	48 63 c8             	movslq %eax,%rcx
  801a82:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a86:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a89:	48 63 f0             	movslq %eax,%rsi
  801a8c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a90:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a93:	48 98                	cltq   
  801a95:	48 89 0c 24          	mov    %rcx,(%rsp)
  801a99:	49 89 f9             	mov    %rdi,%r9
  801a9c:	49 89 f0             	mov    %rsi,%r8
  801a9f:	48 89 d1             	mov    %rdx,%rcx
  801aa2:	48 89 c2             	mov    %rax,%rdx
  801aa5:	be 01 00 00 00       	mov    $0x1,%esi
  801aaa:	bf 05 00 00 00       	mov    $0x5,%edi
  801aaf:	48 b8 3c 18 80 00 00 	movabs $0x80183c,%rax
  801ab6:	00 00 00 
  801ab9:	ff d0                	callq  *%rax
}
  801abb:	c9                   	leaveq 
  801abc:	c3                   	retq   

0000000000801abd <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801abd:	55                   	push   %rbp
  801abe:	48 89 e5             	mov    %rsp,%rbp
  801ac1:	48 83 ec 20          	sub    $0x20,%rsp
  801ac5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ac8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801acc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ad0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ad3:	48 98                	cltq   
  801ad5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801adc:	00 
  801add:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ae3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ae9:	48 89 d1             	mov    %rdx,%rcx
  801aec:	48 89 c2             	mov    %rax,%rdx
  801aef:	be 01 00 00 00       	mov    $0x1,%esi
  801af4:	bf 06 00 00 00       	mov    $0x6,%edi
  801af9:	48 b8 3c 18 80 00 00 	movabs $0x80183c,%rax
  801b00:	00 00 00 
  801b03:	ff d0                	callq  *%rax
}
  801b05:	c9                   	leaveq 
  801b06:	c3                   	retq   

0000000000801b07 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801b07:	55                   	push   %rbp
  801b08:	48 89 e5             	mov    %rsp,%rbp
  801b0b:	48 83 ec 10          	sub    $0x10,%rsp
  801b0f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b12:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801b15:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b18:	48 63 d0             	movslq %eax,%rdx
  801b1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b1e:	48 98                	cltq   
  801b20:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b27:	00 
  801b28:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b2e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b34:	48 89 d1             	mov    %rdx,%rcx
  801b37:	48 89 c2             	mov    %rax,%rdx
  801b3a:	be 01 00 00 00       	mov    $0x1,%esi
  801b3f:	bf 08 00 00 00       	mov    $0x8,%edi
  801b44:	48 b8 3c 18 80 00 00 	movabs $0x80183c,%rax
  801b4b:	00 00 00 
  801b4e:	ff d0                	callq  *%rax
}
  801b50:	c9                   	leaveq 
  801b51:	c3                   	retq   

0000000000801b52 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801b52:	55                   	push   %rbp
  801b53:	48 89 e5             	mov    %rsp,%rbp
  801b56:	48 83 ec 20          	sub    $0x20,%rsp
  801b5a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b5d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801b61:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b65:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b68:	48 98                	cltq   
  801b6a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b71:	00 
  801b72:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b78:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b7e:	48 89 d1             	mov    %rdx,%rcx
  801b81:	48 89 c2             	mov    %rax,%rdx
  801b84:	be 01 00 00 00       	mov    $0x1,%esi
  801b89:	bf 09 00 00 00       	mov    $0x9,%edi
  801b8e:	48 b8 3c 18 80 00 00 	movabs $0x80183c,%rax
  801b95:	00 00 00 
  801b98:	ff d0                	callq  *%rax
}
  801b9a:	c9                   	leaveq 
  801b9b:	c3                   	retq   

0000000000801b9c <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801b9c:	55                   	push   %rbp
  801b9d:	48 89 e5             	mov    %rsp,%rbp
  801ba0:	48 83 ec 20          	sub    $0x20,%rsp
  801ba4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ba7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801bab:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801baf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bb2:	48 98                	cltq   
  801bb4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bbb:	00 
  801bbc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bc2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bc8:	48 89 d1             	mov    %rdx,%rcx
  801bcb:	48 89 c2             	mov    %rax,%rdx
  801bce:	be 01 00 00 00       	mov    $0x1,%esi
  801bd3:	bf 0a 00 00 00       	mov    $0xa,%edi
  801bd8:	48 b8 3c 18 80 00 00 	movabs $0x80183c,%rax
  801bdf:	00 00 00 
  801be2:	ff d0                	callq  *%rax
}
  801be4:	c9                   	leaveq 
  801be5:	c3                   	retq   

0000000000801be6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801be6:	55                   	push   %rbp
  801be7:	48 89 e5             	mov    %rsp,%rbp
  801bea:	48 83 ec 20          	sub    $0x20,%rsp
  801bee:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bf1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bf5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801bf9:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801bfc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bff:	48 63 f0             	movslq %eax,%rsi
  801c02:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801c06:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c09:	48 98                	cltq   
  801c0b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c0f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c16:	00 
  801c17:	49 89 f1             	mov    %rsi,%r9
  801c1a:	49 89 c8             	mov    %rcx,%r8
  801c1d:	48 89 d1             	mov    %rdx,%rcx
  801c20:	48 89 c2             	mov    %rax,%rdx
  801c23:	be 00 00 00 00       	mov    $0x0,%esi
  801c28:	bf 0c 00 00 00       	mov    $0xc,%edi
  801c2d:	48 b8 3c 18 80 00 00 	movabs $0x80183c,%rax
  801c34:	00 00 00 
  801c37:	ff d0                	callq  *%rax
}
  801c39:	c9                   	leaveq 
  801c3a:	c3                   	retq   

0000000000801c3b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801c3b:	55                   	push   %rbp
  801c3c:	48 89 e5             	mov    %rsp,%rbp
  801c3f:	48 83 ec 10          	sub    $0x10,%rsp
  801c43:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801c47:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c4b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c52:	00 
  801c53:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c59:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c5f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c64:	48 89 c2             	mov    %rax,%rdx
  801c67:	be 01 00 00 00       	mov    $0x1,%esi
  801c6c:	bf 0d 00 00 00       	mov    $0xd,%edi
  801c71:	48 b8 3c 18 80 00 00 	movabs $0x80183c,%rax
  801c78:	00 00 00 
  801c7b:	ff d0                	callq  *%rax
}
  801c7d:	c9                   	leaveq 
  801c7e:	c3                   	retq   

0000000000801c7f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801c7f:	55                   	push   %rbp
  801c80:	48 89 e5             	mov    %rsp,%rbp
  801c83:	48 83 ec 08          	sub    $0x8,%rsp
  801c87:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801c8b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c8f:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801c96:	ff ff ff 
  801c99:	48 01 d0             	add    %rdx,%rax
  801c9c:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801ca0:	c9                   	leaveq 
  801ca1:	c3                   	retq   

0000000000801ca2 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801ca2:	55                   	push   %rbp
  801ca3:	48 89 e5             	mov    %rsp,%rbp
  801ca6:	48 83 ec 08          	sub    $0x8,%rsp
  801caa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801cae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cb2:	48 89 c7             	mov    %rax,%rdi
  801cb5:	48 b8 7f 1c 80 00 00 	movabs $0x801c7f,%rax
  801cbc:	00 00 00 
  801cbf:	ff d0                	callq  *%rax
  801cc1:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801cc7:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801ccb:	c9                   	leaveq 
  801ccc:	c3                   	retq   

0000000000801ccd <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801ccd:	55                   	push   %rbp
  801cce:	48 89 e5             	mov    %rsp,%rbp
  801cd1:	48 83 ec 18          	sub    $0x18,%rsp
  801cd5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801cd9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801ce0:	eb 6b                	jmp    801d4d <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801ce2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ce5:	48 98                	cltq   
  801ce7:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ced:	48 c1 e0 0c          	shl    $0xc,%rax
  801cf1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801cf5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cf9:	48 c1 e8 15          	shr    $0x15,%rax
  801cfd:	48 89 c2             	mov    %rax,%rdx
  801d00:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801d07:	01 00 00 
  801d0a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d0e:	83 e0 01             	and    $0x1,%eax
  801d11:	48 85 c0             	test   %rax,%rax
  801d14:	74 21                	je     801d37 <fd_alloc+0x6a>
  801d16:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d1a:	48 c1 e8 0c          	shr    $0xc,%rax
  801d1e:	48 89 c2             	mov    %rax,%rdx
  801d21:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d28:	01 00 00 
  801d2b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d2f:	83 e0 01             	and    $0x1,%eax
  801d32:	48 85 c0             	test   %rax,%rax
  801d35:	75 12                	jne    801d49 <fd_alloc+0x7c>
			*fd_store = fd;
  801d37:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d3b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d3f:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801d42:	b8 00 00 00 00       	mov    $0x0,%eax
  801d47:	eb 1a                	jmp    801d63 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801d49:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801d4d:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801d51:	7e 8f                	jle    801ce2 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801d53:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d57:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801d5e:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801d63:	c9                   	leaveq 
  801d64:	c3                   	retq   

0000000000801d65 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801d65:	55                   	push   %rbp
  801d66:	48 89 e5             	mov    %rsp,%rbp
  801d69:	48 83 ec 20          	sub    $0x20,%rsp
  801d6d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801d70:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801d74:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801d78:	78 06                	js     801d80 <fd_lookup+0x1b>
  801d7a:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801d7e:	7e 07                	jle    801d87 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801d80:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d85:	eb 6c                	jmp    801df3 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801d87:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d8a:	48 98                	cltq   
  801d8c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d92:	48 c1 e0 0c          	shl    $0xc,%rax
  801d96:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801d9a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d9e:	48 c1 e8 15          	shr    $0x15,%rax
  801da2:	48 89 c2             	mov    %rax,%rdx
  801da5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801dac:	01 00 00 
  801daf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801db3:	83 e0 01             	and    $0x1,%eax
  801db6:	48 85 c0             	test   %rax,%rax
  801db9:	74 21                	je     801ddc <fd_lookup+0x77>
  801dbb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dbf:	48 c1 e8 0c          	shr    $0xc,%rax
  801dc3:	48 89 c2             	mov    %rax,%rdx
  801dc6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801dcd:	01 00 00 
  801dd0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dd4:	83 e0 01             	and    $0x1,%eax
  801dd7:	48 85 c0             	test   %rax,%rax
  801dda:	75 07                	jne    801de3 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801ddc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801de1:	eb 10                	jmp    801df3 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801de3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801de7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801deb:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801dee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801df3:	c9                   	leaveq 
  801df4:	c3                   	retq   

0000000000801df5 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801df5:	55                   	push   %rbp
  801df6:	48 89 e5             	mov    %rsp,%rbp
  801df9:	48 83 ec 30          	sub    $0x30,%rsp
  801dfd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e01:	89 f0                	mov    %esi,%eax
  801e03:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801e06:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e0a:	48 89 c7             	mov    %rax,%rdi
  801e0d:	48 b8 7f 1c 80 00 00 	movabs $0x801c7f,%rax
  801e14:	00 00 00 
  801e17:	ff d0                	callq  *%rax
  801e19:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801e1d:	48 89 d6             	mov    %rdx,%rsi
  801e20:	89 c7                	mov    %eax,%edi
  801e22:	48 b8 65 1d 80 00 00 	movabs $0x801d65,%rax
  801e29:	00 00 00 
  801e2c:	ff d0                	callq  *%rax
  801e2e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e31:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e35:	78 0a                	js     801e41 <fd_close+0x4c>
	    || fd != fd2)
  801e37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e3b:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801e3f:	74 12                	je     801e53 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801e41:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801e45:	74 05                	je     801e4c <fd_close+0x57>
  801e47:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e4a:	eb 05                	jmp    801e51 <fd_close+0x5c>
  801e4c:	b8 00 00 00 00       	mov    $0x0,%eax
  801e51:	eb 69                	jmp    801ebc <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801e53:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e57:	8b 00                	mov    (%rax),%eax
  801e59:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801e5d:	48 89 d6             	mov    %rdx,%rsi
  801e60:	89 c7                	mov    %eax,%edi
  801e62:	48 b8 be 1e 80 00 00 	movabs $0x801ebe,%rax
  801e69:	00 00 00 
  801e6c:	ff d0                	callq  *%rax
  801e6e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e71:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e75:	78 2a                	js     801ea1 <fd_close+0xac>
		if (dev->dev_close)
  801e77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e7b:	48 8b 40 20          	mov    0x20(%rax),%rax
  801e7f:	48 85 c0             	test   %rax,%rax
  801e82:	74 16                	je     801e9a <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801e84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e88:	48 8b 40 20          	mov    0x20(%rax),%rax
  801e8c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801e90:	48 89 d7             	mov    %rdx,%rdi
  801e93:	ff d0                	callq  *%rax
  801e95:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e98:	eb 07                	jmp    801ea1 <fd_close+0xac>
		else
			r = 0;
  801e9a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801ea1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ea5:	48 89 c6             	mov    %rax,%rsi
  801ea8:	bf 00 00 00 00       	mov    $0x0,%edi
  801ead:	48 b8 bd 1a 80 00 00 	movabs $0x801abd,%rax
  801eb4:	00 00 00 
  801eb7:	ff d0                	callq  *%rax
	return r;
  801eb9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801ebc:	c9                   	leaveq 
  801ebd:	c3                   	retq   

0000000000801ebe <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801ebe:	55                   	push   %rbp
  801ebf:	48 89 e5             	mov    %rsp,%rbp
  801ec2:	48 83 ec 20          	sub    $0x20,%rsp
  801ec6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801ec9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801ecd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801ed4:	eb 41                	jmp    801f17 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801ed6:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801edd:	00 00 00 
  801ee0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801ee3:	48 63 d2             	movslq %edx,%rdx
  801ee6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801eea:	8b 00                	mov    (%rax),%eax
  801eec:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801eef:	75 22                	jne    801f13 <dev_lookup+0x55>
			*dev = devtab[i];
  801ef1:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801ef8:	00 00 00 
  801efb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801efe:	48 63 d2             	movslq %edx,%rdx
  801f01:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801f05:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f09:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f0c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f11:	eb 60                	jmp    801f73 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801f13:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f17:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801f1e:	00 00 00 
  801f21:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f24:	48 63 d2             	movslq %edx,%rdx
  801f27:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f2b:	48 85 c0             	test   %rax,%rax
  801f2e:	75 a6                	jne    801ed6 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801f30:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801f37:	00 00 00 
  801f3a:	48 8b 00             	mov    (%rax),%rax
  801f3d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801f43:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801f46:	89 c6                	mov    %eax,%esi
  801f48:	48 bf f0 46 80 00 00 	movabs $0x8046f0,%rdi
  801f4f:	00 00 00 
  801f52:	b8 00 00 00 00       	mov    $0x0,%eax
  801f57:	48 b9 2e 05 80 00 00 	movabs $0x80052e,%rcx
  801f5e:	00 00 00 
  801f61:	ff d1                	callq  *%rcx
	*dev = 0;
  801f63:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f67:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801f6e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801f73:	c9                   	leaveq 
  801f74:	c3                   	retq   

0000000000801f75 <close>:

int
close(int fdnum)
{
  801f75:	55                   	push   %rbp
  801f76:	48 89 e5             	mov    %rsp,%rbp
  801f79:	48 83 ec 20          	sub    $0x20,%rsp
  801f7d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f80:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f84:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f87:	48 89 d6             	mov    %rdx,%rsi
  801f8a:	89 c7                	mov    %eax,%edi
  801f8c:	48 b8 65 1d 80 00 00 	movabs $0x801d65,%rax
  801f93:	00 00 00 
  801f96:	ff d0                	callq  *%rax
  801f98:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f9b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f9f:	79 05                	jns    801fa6 <close+0x31>
		return r;
  801fa1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fa4:	eb 18                	jmp    801fbe <close+0x49>
	else
		return fd_close(fd, 1);
  801fa6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801faa:	be 01 00 00 00       	mov    $0x1,%esi
  801faf:	48 89 c7             	mov    %rax,%rdi
  801fb2:	48 b8 f5 1d 80 00 00 	movabs $0x801df5,%rax
  801fb9:	00 00 00 
  801fbc:	ff d0                	callq  *%rax
}
  801fbe:	c9                   	leaveq 
  801fbf:	c3                   	retq   

0000000000801fc0 <close_all>:

void
close_all(void)
{
  801fc0:	55                   	push   %rbp
  801fc1:	48 89 e5             	mov    %rsp,%rbp
  801fc4:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801fc8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801fcf:	eb 15                	jmp    801fe6 <close_all+0x26>
		close(i);
  801fd1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fd4:	89 c7                	mov    %eax,%edi
  801fd6:	48 b8 75 1f 80 00 00 	movabs $0x801f75,%rax
  801fdd:	00 00 00 
  801fe0:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801fe2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801fe6:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801fea:	7e e5                	jle    801fd1 <close_all+0x11>
		close(i);
}
  801fec:	c9                   	leaveq 
  801fed:	c3                   	retq   

0000000000801fee <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801fee:	55                   	push   %rbp
  801fef:	48 89 e5             	mov    %rsp,%rbp
  801ff2:	48 83 ec 40          	sub    $0x40,%rsp
  801ff6:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801ff9:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801ffc:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802000:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802003:	48 89 d6             	mov    %rdx,%rsi
  802006:	89 c7                	mov    %eax,%edi
  802008:	48 b8 65 1d 80 00 00 	movabs $0x801d65,%rax
  80200f:	00 00 00 
  802012:	ff d0                	callq  *%rax
  802014:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802017:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80201b:	79 08                	jns    802025 <dup+0x37>
		return r;
  80201d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802020:	e9 70 01 00 00       	jmpq   802195 <dup+0x1a7>
	close(newfdnum);
  802025:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802028:	89 c7                	mov    %eax,%edi
  80202a:	48 b8 75 1f 80 00 00 	movabs $0x801f75,%rax
  802031:	00 00 00 
  802034:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802036:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802039:	48 98                	cltq   
  80203b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802041:	48 c1 e0 0c          	shl    $0xc,%rax
  802045:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802049:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80204d:	48 89 c7             	mov    %rax,%rdi
  802050:	48 b8 a2 1c 80 00 00 	movabs $0x801ca2,%rax
  802057:	00 00 00 
  80205a:	ff d0                	callq  *%rax
  80205c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802060:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802064:	48 89 c7             	mov    %rax,%rdi
  802067:	48 b8 a2 1c 80 00 00 	movabs $0x801ca2,%rax
  80206e:	00 00 00 
  802071:	ff d0                	callq  *%rax
  802073:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802077:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80207b:	48 c1 e8 15          	shr    $0x15,%rax
  80207f:	48 89 c2             	mov    %rax,%rdx
  802082:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802089:	01 00 00 
  80208c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802090:	83 e0 01             	and    $0x1,%eax
  802093:	48 85 c0             	test   %rax,%rax
  802096:	74 73                	je     80210b <dup+0x11d>
  802098:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80209c:	48 c1 e8 0c          	shr    $0xc,%rax
  8020a0:	48 89 c2             	mov    %rax,%rdx
  8020a3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020aa:	01 00 00 
  8020ad:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020b1:	83 e0 01             	and    $0x1,%eax
  8020b4:	48 85 c0             	test   %rax,%rax
  8020b7:	74 52                	je     80210b <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8020b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020bd:	48 c1 e8 0c          	shr    $0xc,%rax
  8020c1:	48 89 c2             	mov    %rax,%rdx
  8020c4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020cb:	01 00 00 
  8020ce:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020d2:	25 07 0e 00 00       	and    $0xe07,%eax
  8020d7:	89 c1                	mov    %eax,%ecx
  8020d9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8020dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020e1:	41 89 c8             	mov    %ecx,%r8d
  8020e4:	48 89 d1             	mov    %rdx,%rcx
  8020e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8020ec:	48 89 c6             	mov    %rax,%rsi
  8020ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8020f4:	48 b8 62 1a 80 00 00 	movabs $0x801a62,%rax
  8020fb:	00 00 00 
  8020fe:	ff d0                	callq  *%rax
  802100:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802103:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802107:	79 02                	jns    80210b <dup+0x11d>
			goto err;
  802109:	eb 57                	jmp    802162 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80210b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80210f:	48 c1 e8 0c          	shr    $0xc,%rax
  802113:	48 89 c2             	mov    %rax,%rdx
  802116:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80211d:	01 00 00 
  802120:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802124:	25 07 0e 00 00       	and    $0xe07,%eax
  802129:	89 c1                	mov    %eax,%ecx
  80212b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80212f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802133:	41 89 c8             	mov    %ecx,%r8d
  802136:	48 89 d1             	mov    %rdx,%rcx
  802139:	ba 00 00 00 00       	mov    $0x0,%edx
  80213e:	48 89 c6             	mov    %rax,%rsi
  802141:	bf 00 00 00 00       	mov    $0x0,%edi
  802146:	48 b8 62 1a 80 00 00 	movabs $0x801a62,%rax
  80214d:	00 00 00 
  802150:	ff d0                	callq  *%rax
  802152:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802155:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802159:	79 02                	jns    80215d <dup+0x16f>
		goto err;
  80215b:	eb 05                	jmp    802162 <dup+0x174>

	return newfdnum;
  80215d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802160:	eb 33                	jmp    802195 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802162:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802166:	48 89 c6             	mov    %rax,%rsi
  802169:	bf 00 00 00 00       	mov    $0x0,%edi
  80216e:	48 b8 bd 1a 80 00 00 	movabs $0x801abd,%rax
  802175:	00 00 00 
  802178:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80217a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80217e:	48 89 c6             	mov    %rax,%rsi
  802181:	bf 00 00 00 00       	mov    $0x0,%edi
  802186:	48 b8 bd 1a 80 00 00 	movabs $0x801abd,%rax
  80218d:	00 00 00 
  802190:	ff d0                	callq  *%rax
	return r;
  802192:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802195:	c9                   	leaveq 
  802196:	c3                   	retq   

0000000000802197 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802197:	55                   	push   %rbp
  802198:	48 89 e5             	mov    %rsp,%rbp
  80219b:	48 83 ec 40          	sub    $0x40,%rsp
  80219f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8021a2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8021a6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8021aa:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8021ae:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8021b1:	48 89 d6             	mov    %rdx,%rsi
  8021b4:	89 c7                	mov    %eax,%edi
  8021b6:	48 b8 65 1d 80 00 00 	movabs $0x801d65,%rax
  8021bd:	00 00 00 
  8021c0:	ff d0                	callq  *%rax
  8021c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021c9:	78 24                	js     8021ef <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8021cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021cf:	8b 00                	mov    (%rax),%eax
  8021d1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8021d5:	48 89 d6             	mov    %rdx,%rsi
  8021d8:	89 c7                	mov    %eax,%edi
  8021da:	48 b8 be 1e 80 00 00 	movabs $0x801ebe,%rax
  8021e1:	00 00 00 
  8021e4:	ff d0                	callq  *%rax
  8021e6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021ed:	79 05                	jns    8021f4 <read+0x5d>
		return r;
  8021ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021f2:	eb 76                	jmp    80226a <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8021f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021f8:	8b 40 08             	mov    0x8(%rax),%eax
  8021fb:	83 e0 03             	and    $0x3,%eax
  8021fe:	83 f8 01             	cmp    $0x1,%eax
  802201:	75 3a                	jne    80223d <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802203:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80220a:	00 00 00 
  80220d:	48 8b 00             	mov    (%rax),%rax
  802210:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802216:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802219:	89 c6                	mov    %eax,%esi
  80221b:	48 bf 0f 47 80 00 00 	movabs $0x80470f,%rdi
  802222:	00 00 00 
  802225:	b8 00 00 00 00       	mov    $0x0,%eax
  80222a:	48 b9 2e 05 80 00 00 	movabs $0x80052e,%rcx
  802231:	00 00 00 
  802234:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802236:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80223b:	eb 2d                	jmp    80226a <read+0xd3>
	}
	if (!dev->dev_read)
  80223d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802241:	48 8b 40 10          	mov    0x10(%rax),%rax
  802245:	48 85 c0             	test   %rax,%rax
  802248:	75 07                	jne    802251 <read+0xba>
		return -E_NOT_SUPP;
  80224a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80224f:	eb 19                	jmp    80226a <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802251:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802255:	48 8b 40 10          	mov    0x10(%rax),%rax
  802259:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80225d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802261:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802265:	48 89 cf             	mov    %rcx,%rdi
  802268:	ff d0                	callq  *%rax
}
  80226a:	c9                   	leaveq 
  80226b:	c3                   	retq   

000000000080226c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80226c:	55                   	push   %rbp
  80226d:	48 89 e5             	mov    %rsp,%rbp
  802270:	48 83 ec 30          	sub    $0x30,%rsp
  802274:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802277:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80227b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80227f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802286:	eb 49                	jmp    8022d1 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802288:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80228b:	48 98                	cltq   
  80228d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802291:	48 29 c2             	sub    %rax,%rdx
  802294:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802297:	48 63 c8             	movslq %eax,%rcx
  80229a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80229e:	48 01 c1             	add    %rax,%rcx
  8022a1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022a4:	48 89 ce             	mov    %rcx,%rsi
  8022a7:	89 c7                	mov    %eax,%edi
  8022a9:	48 b8 97 21 80 00 00 	movabs $0x802197,%rax
  8022b0:	00 00 00 
  8022b3:	ff d0                	callq  *%rax
  8022b5:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8022b8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8022bc:	79 05                	jns    8022c3 <readn+0x57>
			return m;
  8022be:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022c1:	eb 1c                	jmp    8022df <readn+0x73>
		if (m == 0)
  8022c3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8022c7:	75 02                	jne    8022cb <readn+0x5f>
			break;
  8022c9:	eb 11                	jmp    8022dc <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8022cb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022ce:	01 45 fc             	add    %eax,-0x4(%rbp)
  8022d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022d4:	48 98                	cltq   
  8022d6:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8022da:	72 ac                	jb     802288 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8022dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8022df:	c9                   	leaveq 
  8022e0:	c3                   	retq   

00000000008022e1 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8022e1:	55                   	push   %rbp
  8022e2:	48 89 e5             	mov    %rsp,%rbp
  8022e5:	48 83 ec 40          	sub    $0x40,%rsp
  8022e9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8022ec:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8022f0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022f4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022f8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022fb:	48 89 d6             	mov    %rdx,%rsi
  8022fe:	89 c7                	mov    %eax,%edi
  802300:	48 b8 65 1d 80 00 00 	movabs $0x801d65,%rax
  802307:	00 00 00 
  80230a:	ff d0                	callq  *%rax
  80230c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80230f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802313:	78 24                	js     802339 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802315:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802319:	8b 00                	mov    (%rax),%eax
  80231b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80231f:	48 89 d6             	mov    %rdx,%rsi
  802322:	89 c7                	mov    %eax,%edi
  802324:	48 b8 be 1e 80 00 00 	movabs $0x801ebe,%rax
  80232b:	00 00 00 
  80232e:	ff d0                	callq  *%rax
  802330:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802333:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802337:	79 05                	jns    80233e <write+0x5d>
		return r;
  802339:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80233c:	eb 75                	jmp    8023b3 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80233e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802342:	8b 40 08             	mov    0x8(%rax),%eax
  802345:	83 e0 03             	and    $0x3,%eax
  802348:	85 c0                	test   %eax,%eax
  80234a:	75 3a                	jne    802386 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80234c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802353:	00 00 00 
  802356:	48 8b 00             	mov    (%rax),%rax
  802359:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80235f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802362:	89 c6                	mov    %eax,%esi
  802364:	48 bf 2b 47 80 00 00 	movabs $0x80472b,%rdi
  80236b:	00 00 00 
  80236e:	b8 00 00 00 00       	mov    $0x0,%eax
  802373:	48 b9 2e 05 80 00 00 	movabs $0x80052e,%rcx
  80237a:	00 00 00 
  80237d:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80237f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802384:	eb 2d                	jmp    8023b3 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802386:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80238a:	48 8b 40 18          	mov    0x18(%rax),%rax
  80238e:	48 85 c0             	test   %rax,%rax
  802391:	75 07                	jne    80239a <write+0xb9>
		return -E_NOT_SUPP;
  802393:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802398:	eb 19                	jmp    8023b3 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80239a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80239e:	48 8b 40 18          	mov    0x18(%rax),%rax
  8023a2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8023a6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8023aa:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8023ae:	48 89 cf             	mov    %rcx,%rdi
  8023b1:	ff d0                	callq  *%rax
}
  8023b3:	c9                   	leaveq 
  8023b4:	c3                   	retq   

00000000008023b5 <seek>:

int
seek(int fdnum, off_t offset)
{
  8023b5:	55                   	push   %rbp
  8023b6:	48 89 e5             	mov    %rsp,%rbp
  8023b9:	48 83 ec 18          	sub    $0x18,%rsp
  8023bd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023c0:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023c3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023c7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023ca:	48 89 d6             	mov    %rdx,%rsi
  8023cd:	89 c7                	mov    %eax,%edi
  8023cf:	48 b8 65 1d 80 00 00 	movabs $0x801d65,%rax
  8023d6:	00 00 00 
  8023d9:	ff d0                	callq  *%rax
  8023db:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023de:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023e2:	79 05                	jns    8023e9 <seek+0x34>
		return r;
  8023e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023e7:	eb 0f                	jmp    8023f8 <seek+0x43>
	fd->fd_offset = offset;
  8023e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023ed:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8023f0:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8023f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023f8:	c9                   	leaveq 
  8023f9:	c3                   	retq   

00000000008023fa <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8023fa:	55                   	push   %rbp
  8023fb:	48 89 e5             	mov    %rsp,%rbp
  8023fe:	48 83 ec 30          	sub    $0x30,%rsp
  802402:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802405:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802408:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80240c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80240f:	48 89 d6             	mov    %rdx,%rsi
  802412:	89 c7                	mov    %eax,%edi
  802414:	48 b8 65 1d 80 00 00 	movabs $0x801d65,%rax
  80241b:	00 00 00 
  80241e:	ff d0                	callq  *%rax
  802420:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802423:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802427:	78 24                	js     80244d <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802429:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80242d:	8b 00                	mov    (%rax),%eax
  80242f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802433:	48 89 d6             	mov    %rdx,%rsi
  802436:	89 c7                	mov    %eax,%edi
  802438:	48 b8 be 1e 80 00 00 	movabs $0x801ebe,%rax
  80243f:	00 00 00 
  802442:	ff d0                	callq  *%rax
  802444:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802447:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80244b:	79 05                	jns    802452 <ftruncate+0x58>
		return r;
  80244d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802450:	eb 72                	jmp    8024c4 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802452:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802456:	8b 40 08             	mov    0x8(%rax),%eax
  802459:	83 e0 03             	and    $0x3,%eax
  80245c:	85 c0                	test   %eax,%eax
  80245e:	75 3a                	jne    80249a <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802460:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802467:	00 00 00 
  80246a:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80246d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802473:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802476:	89 c6                	mov    %eax,%esi
  802478:	48 bf 48 47 80 00 00 	movabs $0x804748,%rdi
  80247f:	00 00 00 
  802482:	b8 00 00 00 00       	mov    $0x0,%eax
  802487:	48 b9 2e 05 80 00 00 	movabs $0x80052e,%rcx
  80248e:	00 00 00 
  802491:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802493:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802498:	eb 2a                	jmp    8024c4 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80249a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80249e:	48 8b 40 30          	mov    0x30(%rax),%rax
  8024a2:	48 85 c0             	test   %rax,%rax
  8024a5:	75 07                	jne    8024ae <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8024a7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024ac:	eb 16                	jmp    8024c4 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8024ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024b2:	48 8b 40 30          	mov    0x30(%rax),%rax
  8024b6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8024ba:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8024bd:	89 ce                	mov    %ecx,%esi
  8024bf:	48 89 d7             	mov    %rdx,%rdi
  8024c2:	ff d0                	callq  *%rax
}
  8024c4:	c9                   	leaveq 
  8024c5:	c3                   	retq   

00000000008024c6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8024c6:	55                   	push   %rbp
  8024c7:	48 89 e5             	mov    %rsp,%rbp
  8024ca:	48 83 ec 30          	sub    $0x30,%rsp
  8024ce:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024d1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024d5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024d9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024dc:	48 89 d6             	mov    %rdx,%rsi
  8024df:	89 c7                	mov    %eax,%edi
  8024e1:	48 b8 65 1d 80 00 00 	movabs $0x801d65,%rax
  8024e8:	00 00 00 
  8024eb:	ff d0                	callq  *%rax
  8024ed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024f4:	78 24                	js     80251a <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024fa:	8b 00                	mov    (%rax),%eax
  8024fc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802500:	48 89 d6             	mov    %rdx,%rsi
  802503:	89 c7                	mov    %eax,%edi
  802505:	48 b8 be 1e 80 00 00 	movabs $0x801ebe,%rax
  80250c:	00 00 00 
  80250f:	ff d0                	callq  *%rax
  802511:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802514:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802518:	79 05                	jns    80251f <fstat+0x59>
		return r;
  80251a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80251d:	eb 5e                	jmp    80257d <fstat+0xb7>
	if (!dev->dev_stat)
  80251f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802523:	48 8b 40 28          	mov    0x28(%rax),%rax
  802527:	48 85 c0             	test   %rax,%rax
  80252a:	75 07                	jne    802533 <fstat+0x6d>
		return -E_NOT_SUPP;
  80252c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802531:	eb 4a                	jmp    80257d <fstat+0xb7>
	stat->st_name[0] = 0;
  802533:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802537:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80253a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80253e:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802545:	00 00 00 
	stat->st_isdir = 0;
  802548:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80254c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802553:	00 00 00 
	stat->st_dev = dev;
  802556:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80255a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80255e:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802565:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802569:	48 8b 40 28          	mov    0x28(%rax),%rax
  80256d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802571:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802575:	48 89 ce             	mov    %rcx,%rsi
  802578:	48 89 d7             	mov    %rdx,%rdi
  80257b:	ff d0                	callq  *%rax
}
  80257d:	c9                   	leaveq 
  80257e:	c3                   	retq   

000000000080257f <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80257f:	55                   	push   %rbp
  802580:	48 89 e5             	mov    %rsp,%rbp
  802583:	48 83 ec 20          	sub    $0x20,%rsp
  802587:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80258b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80258f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802593:	be 00 00 00 00       	mov    $0x0,%esi
  802598:	48 89 c7             	mov    %rax,%rdi
  80259b:	48 b8 6d 26 80 00 00 	movabs $0x80266d,%rax
  8025a2:	00 00 00 
  8025a5:	ff d0                	callq  *%rax
  8025a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025ae:	79 05                	jns    8025b5 <stat+0x36>
		return fd;
  8025b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025b3:	eb 2f                	jmp    8025e4 <stat+0x65>
	r = fstat(fd, stat);
  8025b5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8025b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025bc:	48 89 d6             	mov    %rdx,%rsi
  8025bf:	89 c7                	mov    %eax,%edi
  8025c1:	48 b8 c6 24 80 00 00 	movabs $0x8024c6,%rax
  8025c8:	00 00 00 
  8025cb:	ff d0                	callq  *%rax
  8025cd:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8025d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025d3:	89 c7                	mov    %eax,%edi
  8025d5:	48 b8 75 1f 80 00 00 	movabs $0x801f75,%rax
  8025dc:	00 00 00 
  8025df:	ff d0                	callq  *%rax
	return r;
  8025e1:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8025e4:	c9                   	leaveq 
  8025e5:	c3                   	retq   

00000000008025e6 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8025e6:	55                   	push   %rbp
  8025e7:	48 89 e5             	mov    %rsp,%rbp
  8025ea:	48 83 ec 10          	sub    $0x10,%rsp
  8025ee:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8025f1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8025f5:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8025fc:	00 00 00 
  8025ff:	8b 00                	mov    (%rax),%eax
  802601:	85 c0                	test   %eax,%eax
  802603:	75 1d                	jne    802622 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802605:	bf 01 00 00 00       	mov    $0x1,%edi
  80260a:	48 b8 e0 3f 80 00 00 	movabs $0x803fe0,%rax
  802611:	00 00 00 
  802614:	ff d0                	callq  *%rax
  802616:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  80261d:	00 00 00 
  802620:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802622:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802629:	00 00 00 
  80262c:	8b 00                	mov    (%rax),%eax
  80262e:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802631:	b9 07 00 00 00       	mov    $0x7,%ecx
  802636:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  80263d:	00 00 00 
  802640:	89 c7                	mov    %eax,%edi
  802642:	48 b8 7e 3f 80 00 00 	movabs $0x803f7e,%rax
  802649:	00 00 00 
  80264c:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80264e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802652:	ba 00 00 00 00       	mov    $0x0,%edx
  802657:	48 89 c6             	mov    %rax,%rsi
  80265a:	bf 00 00 00 00       	mov    $0x0,%edi
  80265f:	48 b8 78 3e 80 00 00 	movabs $0x803e78,%rax
  802666:	00 00 00 
  802669:	ff d0                	callq  *%rax
}
  80266b:	c9                   	leaveq 
  80266c:	c3                   	retq   

000000000080266d <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80266d:	55                   	push   %rbp
  80266e:	48 89 e5             	mov    %rsp,%rbp
  802671:	48 83 ec 30          	sub    $0x30,%rsp
  802675:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802679:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  80267c:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802683:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  80268a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802691:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802696:	75 08                	jne    8026a0 <open+0x33>
	{
		return r;
  802698:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80269b:	e9 f2 00 00 00       	jmpq   802792 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  8026a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026a4:	48 89 c7             	mov    %rax,%rdi
  8026a7:	48 b8 77 10 80 00 00 	movabs $0x801077,%rax
  8026ae:	00 00 00 
  8026b1:	ff d0                	callq  *%rax
  8026b3:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8026b6:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  8026bd:	7e 0a                	jle    8026c9 <open+0x5c>
	{
		return -E_BAD_PATH;
  8026bf:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8026c4:	e9 c9 00 00 00       	jmpq   802792 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  8026c9:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8026d0:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  8026d1:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8026d5:	48 89 c7             	mov    %rax,%rdi
  8026d8:	48 b8 cd 1c 80 00 00 	movabs $0x801ccd,%rax
  8026df:	00 00 00 
  8026e2:	ff d0                	callq  *%rax
  8026e4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026eb:	78 09                	js     8026f6 <open+0x89>
  8026ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026f1:	48 85 c0             	test   %rax,%rax
  8026f4:	75 08                	jne    8026fe <open+0x91>
		{
			return r;
  8026f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026f9:	e9 94 00 00 00       	jmpq   802792 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  8026fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802702:	ba 00 04 00 00       	mov    $0x400,%edx
  802707:	48 89 c6             	mov    %rax,%rsi
  80270a:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802711:	00 00 00 
  802714:	48 b8 75 11 80 00 00 	movabs $0x801175,%rax
  80271b:	00 00 00 
  80271e:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802720:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802727:	00 00 00 
  80272a:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  80272d:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802733:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802737:	48 89 c6             	mov    %rax,%rsi
  80273a:	bf 01 00 00 00       	mov    $0x1,%edi
  80273f:	48 b8 e6 25 80 00 00 	movabs $0x8025e6,%rax
  802746:	00 00 00 
  802749:	ff d0                	callq  *%rax
  80274b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80274e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802752:	79 2b                	jns    80277f <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802754:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802758:	be 00 00 00 00       	mov    $0x0,%esi
  80275d:	48 89 c7             	mov    %rax,%rdi
  802760:	48 b8 f5 1d 80 00 00 	movabs $0x801df5,%rax
  802767:	00 00 00 
  80276a:	ff d0                	callq  *%rax
  80276c:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80276f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802773:	79 05                	jns    80277a <open+0x10d>
			{
				return d;
  802775:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802778:	eb 18                	jmp    802792 <open+0x125>
			}
			return r;
  80277a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80277d:	eb 13                	jmp    802792 <open+0x125>
		}	
		return fd2num(fd_store);
  80277f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802783:	48 89 c7             	mov    %rax,%rdi
  802786:	48 b8 7f 1c 80 00 00 	movabs $0x801c7f,%rax
  80278d:	00 00 00 
  802790:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802792:	c9                   	leaveq 
  802793:	c3                   	retq   

0000000000802794 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802794:	55                   	push   %rbp
  802795:	48 89 e5             	mov    %rsp,%rbp
  802798:	48 83 ec 10          	sub    $0x10,%rsp
  80279c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8027a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027a4:	8b 50 0c             	mov    0xc(%rax),%edx
  8027a7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027ae:	00 00 00 
  8027b1:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8027b3:	be 00 00 00 00       	mov    $0x0,%esi
  8027b8:	bf 06 00 00 00       	mov    $0x6,%edi
  8027bd:	48 b8 e6 25 80 00 00 	movabs $0x8025e6,%rax
  8027c4:	00 00 00 
  8027c7:	ff d0                	callq  *%rax
}
  8027c9:	c9                   	leaveq 
  8027ca:	c3                   	retq   

00000000008027cb <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8027cb:	55                   	push   %rbp
  8027cc:	48 89 e5             	mov    %rsp,%rbp
  8027cf:	48 83 ec 30          	sub    $0x30,%rsp
  8027d3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027d7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8027db:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  8027df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  8027e6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8027eb:	74 07                	je     8027f4 <devfile_read+0x29>
  8027ed:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8027f2:	75 07                	jne    8027fb <devfile_read+0x30>
		return -E_INVAL;
  8027f4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027f9:	eb 77                	jmp    802872 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8027fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027ff:	8b 50 0c             	mov    0xc(%rax),%edx
  802802:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802809:	00 00 00 
  80280c:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80280e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802815:	00 00 00 
  802818:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80281c:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802820:	be 00 00 00 00       	mov    $0x0,%esi
  802825:	bf 03 00 00 00       	mov    $0x3,%edi
  80282a:	48 b8 e6 25 80 00 00 	movabs $0x8025e6,%rax
  802831:	00 00 00 
  802834:	ff d0                	callq  *%rax
  802836:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802839:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80283d:	7f 05                	jg     802844 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  80283f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802842:	eb 2e                	jmp    802872 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802844:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802847:	48 63 d0             	movslq %eax,%rdx
  80284a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80284e:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802855:	00 00 00 
  802858:	48 89 c7             	mov    %rax,%rdi
  80285b:	48 b8 07 14 80 00 00 	movabs $0x801407,%rax
  802862:	00 00 00 
  802865:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802867:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80286b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  80286f:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802872:	c9                   	leaveq 
  802873:	c3                   	retq   

0000000000802874 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802874:	55                   	push   %rbp
  802875:	48 89 e5             	mov    %rsp,%rbp
  802878:	48 83 ec 30          	sub    $0x30,%rsp
  80287c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802880:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802884:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802888:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  80288f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802894:	74 07                	je     80289d <devfile_write+0x29>
  802896:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80289b:	75 08                	jne    8028a5 <devfile_write+0x31>
		return r;
  80289d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028a0:	e9 9a 00 00 00       	jmpq   80293f <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8028a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028a9:	8b 50 0c             	mov    0xc(%rax),%edx
  8028ac:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028b3:	00 00 00 
  8028b6:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  8028b8:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8028bf:	00 
  8028c0:	76 08                	jbe    8028ca <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  8028c2:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8028c9:	00 
	}
	fsipcbuf.write.req_n = n;
  8028ca:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028d1:	00 00 00 
  8028d4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028d8:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  8028dc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028e0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028e4:	48 89 c6             	mov    %rax,%rsi
  8028e7:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  8028ee:	00 00 00 
  8028f1:	48 b8 07 14 80 00 00 	movabs $0x801407,%rax
  8028f8:	00 00 00 
  8028fb:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  8028fd:	be 00 00 00 00       	mov    $0x0,%esi
  802902:	bf 04 00 00 00       	mov    $0x4,%edi
  802907:	48 b8 e6 25 80 00 00 	movabs $0x8025e6,%rax
  80290e:	00 00 00 
  802911:	ff d0                	callq  *%rax
  802913:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802916:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80291a:	7f 20                	jg     80293c <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  80291c:	48 bf 6e 47 80 00 00 	movabs $0x80476e,%rdi
  802923:	00 00 00 
  802926:	b8 00 00 00 00       	mov    $0x0,%eax
  80292b:	48 ba 2e 05 80 00 00 	movabs $0x80052e,%rdx
  802932:	00 00 00 
  802935:	ff d2                	callq  *%rdx
		return r;
  802937:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80293a:	eb 03                	jmp    80293f <devfile_write+0xcb>
	}
	return r;
  80293c:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  80293f:	c9                   	leaveq 
  802940:	c3                   	retq   

0000000000802941 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802941:	55                   	push   %rbp
  802942:	48 89 e5             	mov    %rsp,%rbp
  802945:	48 83 ec 20          	sub    $0x20,%rsp
  802949:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80294d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802951:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802955:	8b 50 0c             	mov    0xc(%rax),%edx
  802958:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80295f:	00 00 00 
  802962:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802964:	be 00 00 00 00       	mov    $0x0,%esi
  802969:	bf 05 00 00 00       	mov    $0x5,%edi
  80296e:	48 b8 e6 25 80 00 00 	movabs $0x8025e6,%rax
  802975:	00 00 00 
  802978:	ff d0                	callq  *%rax
  80297a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80297d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802981:	79 05                	jns    802988 <devfile_stat+0x47>
		return r;
  802983:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802986:	eb 56                	jmp    8029de <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802988:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80298c:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802993:	00 00 00 
  802996:	48 89 c7             	mov    %rax,%rdi
  802999:	48 b8 e3 10 80 00 00 	movabs $0x8010e3,%rax
  8029a0:	00 00 00 
  8029a3:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8029a5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029ac:	00 00 00 
  8029af:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8029b5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029b9:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8029bf:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029c6:	00 00 00 
  8029c9:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8029cf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029d3:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8029d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029de:	c9                   	leaveq 
  8029df:	c3                   	retq   

00000000008029e0 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8029e0:	55                   	push   %rbp
  8029e1:	48 89 e5             	mov    %rsp,%rbp
  8029e4:	48 83 ec 10          	sub    $0x10,%rsp
  8029e8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8029ec:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8029ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029f3:	8b 50 0c             	mov    0xc(%rax),%edx
  8029f6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029fd:	00 00 00 
  802a00:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802a02:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a09:	00 00 00 
  802a0c:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802a0f:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802a12:	be 00 00 00 00       	mov    $0x0,%esi
  802a17:	bf 02 00 00 00       	mov    $0x2,%edi
  802a1c:	48 b8 e6 25 80 00 00 	movabs $0x8025e6,%rax
  802a23:	00 00 00 
  802a26:	ff d0                	callq  *%rax
}
  802a28:	c9                   	leaveq 
  802a29:	c3                   	retq   

0000000000802a2a <remove>:

// Delete a file
int
remove(const char *path)
{
  802a2a:	55                   	push   %rbp
  802a2b:	48 89 e5             	mov    %rsp,%rbp
  802a2e:	48 83 ec 10          	sub    $0x10,%rsp
  802a32:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802a36:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a3a:	48 89 c7             	mov    %rax,%rdi
  802a3d:	48 b8 77 10 80 00 00 	movabs $0x801077,%rax
  802a44:	00 00 00 
  802a47:	ff d0                	callq  *%rax
  802a49:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802a4e:	7e 07                	jle    802a57 <remove+0x2d>
		return -E_BAD_PATH;
  802a50:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802a55:	eb 33                	jmp    802a8a <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802a57:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a5b:	48 89 c6             	mov    %rax,%rsi
  802a5e:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802a65:	00 00 00 
  802a68:	48 b8 e3 10 80 00 00 	movabs $0x8010e3,%rax
  802a6f:	00 00 00 
  802a72:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802a74:	be 00 00 00 00       	mov    $0x0,%esi
  802a79:	bf 07 00 00 00       	mov    $0x7,%edi
  802a7e:	48 b8 e6 25 80 00 00 	movabs $0x8025e6,%rax
  802a85:	00 00 00 
  802a88:	ff d0                	callq  *%rax
}
  802a8a:	c9                   	leaveq 
  802a8b:	c3                   	retq   

0000000000802a8c <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802a8c:	55                   	push   %rbp
  802a8d:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802a90:	be 00 00 00 00       	mov    $0x0,%esi
  802a95:	bf 08 00 00 00       	mov    $0x8,%edi
  802a9a:	48 b8 e6 25 80 00 00 	movabs $0x8025e6,%rax
  802aa1:	00 00 00 
  802aa4:	ff d0                	callq  *%rax
}
  802aa6:	5d                   	pop    %rbp
  802aa7:	c3                   	retq   

0000000000802aa8 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802aa8:	55                   	push   %rbp
  802aa9:	48 89 e5             	mov    %rsp,%rbp
  802aac:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  802ab3:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  802aba:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802ac1:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  802ac8:	be 00 00 00 00       	mov    $0x0,%esi
  802acd:	48 89 c7             	mov    %rax,%rdi
  802ad0:	48 b8 6d 26 80 00 00 	movabs $0x80266d,%rax
  802ad7:	00 00 00 
  802ada:	ff d0                	callq  *%rax
  802adc:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802adf:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802ae3:	79 08                	jns    802aed <spawn+0x45>
		return r;
  802ae5:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802ae8:	e9 14 03 00 00       	jmpq   802e01 <spawn+0x359>
	fd = r;
  802aed:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802af0:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  802af3:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  802afa:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802afe:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  802b05:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802b08:	ba 00 02 00 00       	mov    $0x200,%edx
  802b0d:	48 89 ce             	mov    %rcx,%rsi
  802b10:	89 c7                	mov    %eax,%edi
  802b12:	48 b8 6c 22 80 00 00 	movabs $0x80226c,%rax
  802b19:	00 00 00 
  802b1c:	ff d0                	callq  *%rax
  802b1e:	3d 00 02 00 00       	cmp    $0x200,%eax
  802b23:	75 0d                	jne    802b32 <spawn+0x8a>
	    || elf->e_magic != ELF_MAGIC) {
  802b25:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b29:	8b 00                	mov    (%rax),%eax
  802b2b:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  802b30:	74 43                	je     802b75 <spawn+0xcd>
		close(fd);
  802b32:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802b35:	89 c7                	mov    %eax,%edi
  802b37:	48 b8 75 1f 80 00 00 	movabs $0x801f75,%rax
  802b3e:	00 00 00 
  802b41:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802b43:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b47:	8b 00                	mov    (%rax),%eax
  802b49:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  802b4e:	89 c6                	mov    %eax,%esi
  802b50:	48 bf 90 47 80 00 00 	movabs $0x804790,%rdi
  802b57:	00 00 00 
  802b5a:	b8 00 00 00 00       	mov    $0x0,%eax
  802b5f:	48 b9 2e 05 80 00 00 	movabs $0x80052e,%rcx
  802b66:	00 00 00 
  802b69:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  802b6b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802b70:	e9 8c 02 00 00       	jmpq   802e01 <spawn+0x359>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802b75:	b8 07 00 00 00       	mov    $0x7,%eax
  802b7a:	cd 30                	int    $0x30
  802b7c:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802b7f:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802b82:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802b85:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802b89:	79 08                	jns    802b93 <spawn+0xeb>
		return r;
  802b8b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802b8e:	e9 6e 02 00 00       	jmpq   802e01 <spawn+0x359>
	child = r;
  802b93:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802b96:	89 45 d4             	mov    %eax,-0x2c(%rbp)
	//thisenv = &envs[ENVX(sys_getenvid())];
	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802b99:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802b9c:	25 ff 03 00 00       	and    $0x3ff,%eax
  802ba1:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802ba8:	00 00 00 
  802bab:	48 63 d0             	movslq %eax,%rdx
  802bae:	48 89 d0             	mov    %rdx,%rax
  802bb1:	48 c1 e0 03          	shl    $0x3,%rax
  802bb5:	48 01 d0             	add    %rdx,%rax
  802bb8:	48 c1 e0 05          	shl    $0x5,%rax
  802bbc:	48 01 c8             	add    %rcx,%rax
  802bbf:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  802bc6:	48 89 c6             	mov    %rax,%rsi
  802bc9:	b8 18 00 00 00       	mov    $0x18,%eax
  802bce:	48 89 d7             	mov    %rdx,%rdi
  802bd1:	48 89 c1             	mov    %rax,%rcx
  802bd4:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  802bd7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bdb:	48 8b 40 18          	mov    0x18(%rax),%rax
  802bdf:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  802be6:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  802bed:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  802bf4:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  802bfb:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802bfe:	48 89 ce             	mov    %rcx,%rsi
  802c01:	89 c7                	mov    %eax,%edi
  802c03:	48 b8 6b 30 80 00 00 	movabs $0x80306b,%rax
  802c0a:	00 00 00 
  802c0d:	ff d0                	callq  *%rax
  802c0f:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802c12:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802c16:	79 08                	jns    802c20 <spawn+0x178>
		return r;
  802c18:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802c1b:	e9 e1 01 00 00       	jmpq   802e01 <spawn+0x359>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802c20:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c24:	48 8b 40 20          	mov    0x20(%rax),%rax
  802c28:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  802c2f:	48 01 d0             	add    %rdx,%rax
  802c32:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802c36:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802c3d:	e9 a3 00 00 00       	jmpq   802ce5 <spawn+0x23d>
		if (ph->p_type != ELF_PROG_LOAD)
  802c42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c46:	8b 00                	mov    (%rax),%eax
  802c48:	83 f8 01             	cmp    $0x1,%eax
  802c4b:	74 05                	je     802c52 <spawn+0x1aa>
			continue;
  802c4d:	e9 8a 00 00 00       	jmpq   802cdc <spawn+0x234>
		perm = PTE_P | PTE_U;
  802c52:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802c59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c5d:	8b 40 04             	mov    0x4(%rax),%eax
  802c60:	83 e0 02             	and    $0x2,%eax
  802c63:	85 c0                	test   %eax,%eax
  802c65:	74 04                	je     802c6b <spawn+0x1c3>
			perm |= PTE_W;
  802c67:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  802c6b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c6f:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802c73:	41 89 c1             	mov    %eax,%r9d
  802c76:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c7a:	4c 8b 40 20          	mov    0x20(%rax),%r8
  802c7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c82:	48 8b 50 28          	mov    0x28(%rax),%rdx
  802c86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c8a:	48 8b 70 10          	mov    0x10(%rax),%rsi
  802c8e:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  802c91:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802c94:	8b 7d ec             	mov    -0x14(%rbp),%edi
  802c97:	89 3c 24             	mov    %edi,(%rsp)
  802c9a:	89 c7                	mov    %eax,%edi
  802c9c:	48 b8 14 33 80 00 00 	movabs $0x803314,%rax
  802ca3:	00 00 00 
  802ca6:	ff d0                	callq  *%rax
  802ca8:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802cab:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802caf:	79 2b                	jns    802cdc <spawn+0x234>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  802cb1:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  802cb2:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802cb5:	89 c7                	mov    %eax,%edi
  802cb7:	48 b8 52 19 80 00 00 	movabs $0x801952,%rax
  802cbe:	00 00 00 
  802cc1:	ff d0                	callq  *%rax
	close(fd);
  802cc3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802cc6:	89 c7                	mov    %eax,%edi
  802cc8:	48 b8 75 1f 80 00 00 	movabs $0x801f75,%rax
  802ccf:	00 00 00 
  802cd2:	ff d0                	callq  *%rax
	return r;
  802cd4:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802cd7:	e9 25 01 00 00       	jmpq   802e01 <spawn+0x359>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802cdc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802ce0:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  802ce5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ce9:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  802ced:	0f b7 c0             	movzwl %ax,%eax
  802cf0:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802cf3:	0f 8f 49 ff ff ff    	jg     802c42 <spawn+0x19a>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  802cf9:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802cfc:	89 c7                	mov    %eax,%edi
  802cfe:	48 b8 75 1f 80 00 00 	movabs $0x801f75,%rax
  802d05:	00 00 00 
  802d08:	ff d0                	callq  *%rax
	fd = -1;
  802d0a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  802d11:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802d14:	89 c7                	mov    %eax,%edi
  802d16:	48 b8 00 35 80 00 00 	movabs $0x803500,%rax
  802d1d:	00 00 00 
  802d20:	ff d0                	callq  *%rax
  802d22:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802d25:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802d29:	79 30                	jns    802d5b <spawn+0x2b3>
		panic("copy_shared_pages: %e", r);
  802d2b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802d2e:	89 c1                	mov    %eax,%ecx
  802d30:	48 ba aa 47 80 00 00 	movabs $0x8047aa,%rdx
  802d37:	00 00 00 
  802d3a:	be 82 00 00 00       	mov    $0x82,%esi
  802d3f:	48 bf c0 47 80 00 00 	movabs $0x8047c0,%rdi
  802d46:	00 00 00 
  802d49:	b8 00 00 00 00       	mov    $0x0,%eax
  802d4e:	49 b8 f5 02 80 00 00 	movabs $0x8002f5,%r8
  802d55:	00 00 00 
  802d58:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802d5b:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  802d62:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802d65:	48 89 d6             	mov    %rdx,%rsi
  802d68:	89 c7                	mov    %eax,%edi
  802d6a:	48 b8 52 1b 80 00 00 	movabs $0x801b52,%rax
  802d71:	00 00 00 
  802d74:	ff d0                	callq  *%rax
  802d76:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802d79:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802d7d:	79 30                	jns    802daf <spawn+0x307>
		panic("sys_env_set_trapframe: %e", r);
  802d7f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802d82:	89 c1                	mov    %eax,%ecx
  802d84:	48 ba cc 47 80 00 00 	movabs $0x8047cc,%rdx
  802d8b:	00 00 00 
  802d8e:	be 85 00 00 00       	mov    $0x85,%esi
  802d93:	48 bf c0 47 80 00 00 	movabs $0x8047c0,%rdi
  802d9a:	00 00 00 
  802d9d:	b8 00 00 00 00       	mov    $0x0,%eax
  802da2:	49 b8 f5 02 80 00 00 	movabs $0x8002f5,%r8
  802da9:	00 00 00 
  802dac:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802daf:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802db2:	be 02 00 00 00       	mov    $0x2,%esi
  802db7:	89 c7                	mov    %eax,%edi
  802db9:	48 b8 07 1b 80 00 00 	movabs $0x801b07,%rax
  802dc0:	00 00 00 
  802dc3:	ff d0                	callq  *%rax
  802dc5:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802dc8:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802dcc:	79 30                	jns    802dfe <spawn+0x356>
		panic("sys_env_set_status: %e", r);
  802dce:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802dd1:	89 c1                	mov    %eax,%ecx
  802dd3:	48 ba e6 47 80 00 00 	movabs $0x8047e6,%rdx
  802dda:	00 00 00 
  802ddd:	be 88 00 00 00       	mov    $0x88,%esi
  802de2:	48 bf c0 47 80 00 00 	movabs $0x8047c0,%rdi
  802de9:	00 00 00 
  802dec:	b8 00 00 00 00       	mov    $0x0,%eax
  802df1:	49 b8 f5 02 80 00 00 	movabs $0x8002f5,%r8
  802df8:	00 00 00 
  802dfb:	41 ff d0             	callq  *%r8

	return child;
  802dfe:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  802e01:	c9                   	leaveq 
  802e02:	c3                   	retq   

0000000000802e03 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  802e03:	55                   	push   %rbp
  802e04:	48 89 e5             	mov    %rsp,%rbp
  802e07:	41 55                	push   %r13
  802e09:	41 54                	push   %r12
  802e0b:	53                   	push   %rbx
  802e0c:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  802e13:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  802e1a:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  802e21:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  802e28:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  802e2f:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  802e36:	84 c0                	test   %al,%al
  802e38:	74 26                	je     802e60 <spawnl+0x5d>
  802e3a:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  802e41:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  802e48:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  802e4c:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  802e50:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  802e54:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  802e58:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  802e5c:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  802e60:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  802e67:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  802e6e:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  802e71:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  802e78:	00 00 00 
  802e7b:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  802e82:	00 00 00 
  802e85:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802e89:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  802e90:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  802e97:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  802e9e:	eb 07                	jmp    802ea7 <spawnl+0xa4>
		argc++;
  802ea0:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802ea7:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  802ead:	83 f8 30             	cmp    $0x30,%eax
  802eb0:	73 23                	jae    802ed5 <spawnl+0xd2>
  802eb2:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  802eb9:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  802ebf:	89 c0                	mov    %eax,%eax
  802ec1:	48 01 d0             	add    %rdx,%rax
  802ec4:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  802eca:	83 c2 08             	add    $0x8,%edx
  802ecd:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  802ed3:	eb 15                	jmp    802eea <spawnl+0xe7>
  802ed5:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  802edc:	48 89 d0             	mov    %rdx,%rax
  802edf:	48 83 c2 08          	add    $0x8,%rdx
  802ee3:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  802eea:	48 8b 00             	mov    (%rax),%rax
  802eed:	48 85 c0             	test   %rax,%rax
  802ef0:	75 ae                	jne    802ea0 <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  802ef2:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  802ef8:	83 c0 02             	add    $0x2,%eax
  802efb:	48 89 e2             	mov    %rsp,%rdx
  802efe:	48 89 d3             	mov    %rdx,%rbx
  802f01:	48 63 d0             	movslq %eax,%rdx
  802f04:	48 83 ea 01          	sub    $0x1,%rdx
  802f08:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  802f0f:	48 63 d0             	movslq %eax,%rdx
  802f12:	49 89 d4             	mov    %rdx,%r12
  802f15:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  802f1b:	48 63 d0             	movslq %eax,%rdx
  802f1e:	49 89 d2             	mov    %rdx,%r10
  802f21:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  802f27:	48 98                	cltq   
  802f29:	48 c1 e0 03          	shl    $0x3,%rax
  802f2d:	48 8d 50 07          	lea    0x7(%rax),%rdx
  802f31:	b8 10 00 00 00       	mov    $0x10,%eax
  802f36:	48 83 e8 01          	sub    $0x1,%rax
  802f3a:	48 01 d0             	add    %rdx,%rax
  802f3d:	bf 10 00 00 00       	mov    $0x10,%edi
  802f42:	ba 00 00 00 00       	mov    $0x0,%edx
  802f47:	48 f7 f7             	div    %rdi
  802f4a:	48 6b c0 10          	imul   $0x10,%rax,%rax
  802f4e:	48 29 c4             	sub    %rax,%rsp
  802f51:	48 89 e0             	mov    %rsp,%rax
  802f54:	48 83 c0 07          	add    $0x7,%rax
  802f58:	48 c1 e8 03          	shr    $0x3,%rax
  802f5c:	48 c1 e0 03          	shl    $0x3,%rax
  802f60:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  802f67:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  802f6e:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  802f75:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  802f78:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  802f7e:	8d 50 01             	lea    0x1(%rax),%edx
  802f81:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  802f88:	48 63 d2             	movslq %edx,%rdx
  802f8b:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  802f92:	00 

	va_start(vl, arg0);
  802f93:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  802f9a:	00 00 00 
  802f9d:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  802fa4:	00 00 00 
  802fa7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802fab:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  802fb2:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  802fb9:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  802fc0:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  802fc7:	00 00 00 
  802fca:	eb 63                	jmp    80302f <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  802fcc:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  802fd2:	8d 70 01             	lea    0x1(%rax),%esi
  802fd5:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  802fdb:	83 f8 30             	cmp    $0x30,%eax
  802fde:	73 23                	jae    803003 <spawnl+0x200>
  802fe0:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  802fe7:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  802fed:	89 c0                	mov    %eax,%eax
  802fef:	48 01 d0             	add    %rdx,%rax
  802ff2:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  802ff8:	83 c2 08             	add    $0x8,%edx
  802ffb:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803001:	eb 15                	jmp    803018 <spawnl+0x215>
  803003:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  80300a:	48 89 d0             	mov    %rdx,%rax
  80300d:	48 83 c2 08          	add    $0x8,%rdx
  803011:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803018:	48 8b 08             	mov    (%rax),%rcx
  80301b:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803022:	89 f2                	mov    %esi,%edx
  803024:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  803028:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  80302f:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803035:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  80303b:	77 8f                	ja     802fcc <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  80303d:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803044:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  80304b:	48 89 d6             	mov    %rdx,%rsi
  80304e:	48 89 c7             	mov    %rax,%rdi
  803051:	48 b8 a8 2a 80 00 00 	movabs $0x802aa8,%rax
  803058:	00 00 00 
  80305b:	ff d0                	callq  *%rax
  80305d:	48 89 dc             	mov    %rbx,%rsp
}
  803060:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  803064:	5b                   	pop    %rbx
  803065:	41 5c                	pop    %r12
  803067:	41 5d                	pop    %r13
  803069:	5d                   	pop    %rbp
  80306a:	c3                   	retq   

000000000080306b <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  80306b:	55                   	push   %rbp
  80306c:	48 89 e5             	mov    %rsp,%rbp
  80306f:	48 83 ec 50          	sub    $0x50,%rsp
  803073:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803076:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  80307a:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  80307e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803085:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  803086:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  80308d:	eb 33                	jmp    8030c2 <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  80308f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803092:	48 98                	cltq   
  803094:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80309b:	00 
  80309c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8030a0:	48 01 d0             	add    %rdx,%rax
  8030a3:	48 8b 00             	mov    (%rax),%rax
  8030a6:	48 89 c7             	mov    %rax,%rdi
  8030a9:	48 b8 77 10 80 00 00 	movabs $0x801077,%rax
  8030b0:	00 00 00 
  8030b3:	ff d0                	callq  *%rax
  8030b5:	83 c0 01             	add    $0x1,%eax
  8030b8:	48 98                	cltq   
  8030ba:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8030be:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  8030c2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8030c5:	48 98                	cltq   
  8030c7:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8030ce:	00 
  8030cf:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8030d3:	48 01 d0             	add    %rdx,%rax
  8030d6:	48 8b 00             	mov    (%rax),%rax
  8030d9:	48 85 c0             	test   %rax,%rax
  8030dc:	75 b1                	jne    80308f <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8030de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030e2:	48 f7 d8             	neg    %rax
  8030e5:	48 05 00 10 40 00    	add    $0x401000,%rax
  8030eb:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  8030ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030f3:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8030f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030fb:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  8030ff:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803102:	83 c2 01             	add    $0x1,%edx
  803105:	c1 e2 03             	shl    $0x3,%edx
  803108:	48 63 d2             	movslq %edx,%rdx
  80310b:	48 f7 da             	neg    %rdx
  80310e:	48 01 d0             	add    %rdx,%rax
  803111:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  803115:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803119:	48 83 e8 10          	sub    $0x10,%rax
  80311d:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  803123:	77 0a                	ja     80312f <init_stack+0xc4>
		return -E_NO_MEM;
  803125:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  80312a:	e9 e3 01 00 00       	jmpq   803312 <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80312f:	ba 07 00 00 00       	mov    $0x7,%edx
  803134:	be 00 00 40 00       	mov    $0x400000,%esi
  803139:	bf 00 00 00 00       	mov    $0x0,%edi
  80313e:	48 b8 12 1a 80 00 00 	movabs $0x801a12,%rax
  803145:	00 00 00 
  803148:	ff d0                	callq  *%rax
  80314a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80314d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803151:	79 08                	jns    80315b <init_stack+0xf0>
		return r;
  803153:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803156:	e9 b7 01 00 00       	jmpq   803312 <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  80315b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  803162:	e9 8a 00 00 00       	jmpq   8031f1 <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  803167:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80316a:	48 98                	cltq   
  80316c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803173:	00 
  803174:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803178:	48 01 c2             	add    %rax,%rdx
  80317b:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803180:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803184:	48 01 c8             	add    %rcx,%rax
  803187:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  80318d:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  803190:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803193:	48 98                	cltq   
  803195:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80319c:	00 
  80319d:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8031a1:	48 01 d0             	add    %rdx,%rax
  8031a4:	48 8b 10             	mov    (%rax),%rdx
  8031a7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031ab:	48 89 d6             	mov    %rdx,%rsi
  8031ae:	48 89 c7             	mov    %rax,%rdi
  8031b1:	48 b8 e3 10 80 00 00 	movabs $0x8010e3,%rax
  8031b8:	00 00 00 
  8031bb:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  8031bd:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8031c0:	48 98                	cltq   
  8031c2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8031c9:	00 
  8031ca:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8031ce:	48 01 d0             	add    %rdx,%rax
  8031d1:	48 8b 00             	mov    (%rax),%rax
  8031d4:	48 89 c7             	mov    %rax,%rdi
  8031d7:	48 b8 77 10 80 00 00 	movabs $0x801077,%rax
  8031de:	00 00 00 
  8031e1:	ff d0                	callq  *%rax
  8031e3:	48 98                	cltq   
  8031e5:	48 83 c0 01          	add    $0x1,%rax
  8031e9:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8031ed:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  8031f1:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8031f4:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8031f7:	0f 8c 6a ff ff ff    	jl     803167 <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  8031fd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803200:	48 98                	cltq   
  803202:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803209:	00 
  80320a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80320e:	48 01 d0             	add    %rdx,%rax
  803211:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  803218:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  80321f:	00 
  803220:	74 35                	je     803257 <init_stack+0x1ec>
  803222:	48 b9 00 48 80 00 00 	movabs $0x804800,%rcx
  803229:	00 00 00 
  80322c:	48 ba 26 48 80 00 00 	movabs $0x804826,%rdx
  803233:	00 00 00 
  803236:	be f1 00 00 00       	mov    $0xf1,%esi
  80323b:	48 bf c0 47 80 00 00 	movabs $0x8047c0,%rdi
  803242:	00 00 00 
  803245:	b8 00 00 00 00       	mov    $0x0,%eax
  80324a:	49 b8 f5 02 80 00 00 	movabs $0x8002f5,%r8
  803251:	00 00 00 
  803254:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  803257:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80325b:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  80325f:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803264:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803268:	48 01 c8             	add    %rcx,%rax
  80326b:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803271:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  803274:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803278:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  80327c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80327f:	48 98                	cltq   
  803281:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  803284:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  803289:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80328d:	48 01 d0             	add    %rdx,%rax
  803290:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803296:	48 89 c2             	mov    %rax,%rdx
  803299:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  80329d:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8032a0:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8032a3:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8032a9:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8032ae:	89 c2                	mov    %eax,%edx
  8032b0:	be 00 00 40 00       	mov    $0x400000,%esi
  8032b5:	bf 00 00 00 00       	mov    $0x0,%edi
  8032ba:	48 b8 62 1a 80 00 00 	movabs $0x801a62,%rax
  8032c1:	00 00 00 
  8032c4:	ff d0                	callq  *%rax
  8032c6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032c9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032cd:	79 02                	jns    8032d1 <init_stack+0x266>
		goto error;
  8032cf:	eb 28                	jmp    8032f9 <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8032d1:	be 00 00 40 00       	mov    $0x400000,%esi
  8032d6:	bf 00 00 00 00       	mov    $0x0,%edi
  8032db:	48 b8 bd 1a 80 00 00 	movabs $0x801abd,%rax
  8032e2:	00 00 00 
  8032e5:	ff d0                	callq  *%rax
  8032e7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032ee:	79 02                	jns    8032f2 <init_stack+0x287>
		goto error;
  8032f0:	eb 07                	jmp    8032f9 <init_stack+0x28e>

	return 0;
  8032f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8032f7:	eb 19                	jmp    803312 <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  8032f9:	be 00 00 40 00       	mov    $0x400000,%esi
  8032fe:	bf 00 00 00 00       	mov    $0x0,%edi
  803303:	48 b8 bd 1a 80 00 00 	movabs $0x801abd,%rax
  80330a:	00 00 00 
  80330d:	ff d0                	callq  *%rax
	return r;
  80330f:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803312:	c9                   	leaveq 
  803313:	c3                   	retq   

0000000000803314 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	int fd, size_t filesz, off_t fileoffset, int perm)
{
  803314:	55                   	push   %rbp
  803315:	48 89 e5             	mov    %rsp,%rbp
  803318:	48 83 ec 50          	sub    $0x50,%rsp
  80331c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80331f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803323:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  803327:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  80332a:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80332e:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  803332:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803336:	25 ff 0f 00 00       	and    $0xfff,%eax
  80333b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80333e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803342:	74 21                	je     803365 <map_segment+0x51>
		va -= i;
  803344:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803347:	48 98                	cltq   
  803349:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  80334d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803350:	48 98                	cltq   
  803352:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  803356:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803359:	48 98                	cltq   
  80335b:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  80335f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803362:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803365:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80336c:	e9 79 01 00 00       	jmpq   8034ea <map_segment+0x1d6>
		if (i >= filesz) {
  803371:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803374:	48 98                	cltq   
  803376:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  80337a:	72 3c                	jb     8033b8 <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  80337c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80337f:	48 63 d0             	movslq %eax,%rdx
  803382:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803386:	48 01 d0             	add    %rdx,%rax
  803389:	48 89 c1             	mov    %rax,%rcx
  80338c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80338f:	8b 55 10             	mov    0x10(%rbp),%edx
  803392:	48 89 ce             	mov    %rcx,%rsi
  803395:	89 c7                	mov    %eax,%edi
  803397:	48 b8 12 1a 80 00 00 	movabs $0x801a12,%rax
  80339e:	00 00 00 
  8033a1:	ff d0                	callq  *%rax
  8033a3:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8033a6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8033aa:	0f 89 33 01 00 00    	jns    8034e3 <map_segment+0x1cf>
				return r;
  8033b0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033b3:	e9 46 01 00 00       	jmpq   8034fe <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8033b8:	ba 07 00 00 00       	mov    $0x7,%edx
  8033bd:	be 00 00 40 00       	mov    $0x400000,%esi
  8033c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8033c7:	48 b8 12 1a 80 00 00 	movabs $0x801a12,%rax
  8033ce:	00 00 00 
  8033d1:	ff d0                	callq  *%rax
  8033d3:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8033d6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8033da:	79 08                	jns    8033e4 <map_segment+0xd0>
				return r;
  8033dc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033df:	e9 1a 01 00 00       	jmpq   8034fe <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  8033e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033e7:	8b 55 bc             	mov    -0x44(%rbp),%edx
  8033ea:	01 c2                	add    %eax,%edx
  8033ec:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8033ef:	89 d6                	mov    %edx,%esi
  8033f1:	89 c7                	mov    %eax,%edi
  8033f3:	48 b8 b5 23 80 00 00 	movabs $0x8023b5,%rax
  8033fa:	00 00 00 
  8033fd:	ff d0                	callq  *%rax
  8033ff:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803402:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803406:	79 08                	jns    803410 <map_segment+0xfc>
				return r;
  803408:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80340b:	e9 ee 00 00 00       	jmpq   8034fe <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  803410:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  803417:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80341a:	48 98                	cltq   
  80341c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803420:	48 29 c2             	sub    %rax,%rdx
  803423:	48 89 d0             	mov    %rdx,%rax
  803426:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80342a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80342d:	48 63 d0             	movslq %eax,%rdx
  803430:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803434:	48 39 c2             	cmp    %rax,%rdx
  803437:	48 0f 47 d0          	cmova  %rax,%rdx
  80343b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80343e:	be 00 00 40 00       	mov    $0x400000,%esi
  803443:	89 c7                	mov    %eax,%edi
  803445:	48 b8 6c 22 80 00 00 	movabs $0x80226c,%rax
  80344c:	00 00 00 
  80344f:	ff d0                	callq  *%rax
  803451:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803454:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803458:	79 08                	jns    803462 <map_segment+0x14e>
				return r;
  80345a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80345d:	e9 9c 00 00 00       	jmpq   8034fe <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  803462:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803465:	48 63 d0             	movslq %eax,%rdx
  803468:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80346c:	48 01 d0             	add    %rdx,%rax
  80346f:	48 89 c2             	mov    %rax,%rdx
  803472:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803475:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  803479:	48 89 d1             	mov    %rdx,%rcx
  80347c:	89 c2                	mov    %eax,%edx
  80347e:	be 00 00 40 00       	mov    $0x400000,%esi
  803483:	bf 00 00 00 00       	mov    $0x0,%edi
  803488:	48 b8 62 1a 80 00 00 	movabs $0x801a62,%rax
  80348f:	00 00 00 
  803492:	ff d0                	callq  *%rax
  803494:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803497:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80349b:	79 30                	jns    8034cd <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  80349d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034a0:	89 c1                	mov    %eax,%ecx
  8034a2:	48 ba 3b 48 80 00 00 	movabs $0x80483b,%rdx
  8034a9:	00 00 00 
  8034ac:	be 24 01 00 00       	mov    $0x124,%esi
  8034b1:	48 bf c0 47 80 00 00 	movabs $0x8047c0,%rdi
  8034b8:	00 00 00 
  8034bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8034c0:	49 b8 f5 02 80 00 00 	movabs $0x8002f5,%r8
  8034c7:	00 00 00 
  8034ca:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  8034cd:	be 00 00 40 00       	mov    $0x400000,%esi
  8034d2:	bf 00 00 00 00       	mov    $0x0,%edi
  8034d7:	48 b8 bd 1a 80 00 00 	movabs $0x801abd,%rax
  8034de:	00 00 00 
  8034e1:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8034e3:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  8034ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034ed:	48 98                	cltq   
  8034ef:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8034f3:	0f 82 78 fe ff ff    	jb     803371 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  8034f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034fe:	c9                   	leaveq 
  8034ff:	c3                   	retq   

0000000000803500 <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  803500:	55                   	push   %rbp
  803501:	48 89 e5             	mov    %rsp,%rbp
  803504:	48 83 ec 20          	sub    $0x20,%rsp
  803508:	89 7d ec             	mov    %edi,-0x14(%rbp)
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  80350b:	48 c7 45 f8 00 00 80 	movq   $0x800000,-0x8(%rbp)
  803512:	00 
  803513:	e9 c9 00 00 00       	jmpq   8035e1 <copy_shared_pages+0xe1>
        {
            if(!((uvpml4e[VPML4E(addr)])&&(uvpde[VPDPE(addr)]) && (uvpd[VPD(addr)]  )))
  803518:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80351c:	48 c1 e8 27          	shr    $0x27,%rax
  803520:	48 89 c2             	mov    %rax,%rdx
  803523:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80352a:	01 00 00 
  80352d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803531:	48 85 c0             	test   %rax,%rax
  803534:	74 3c                	je     803572 <copy_shared_pages+0x72>
  803536:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80353a:	48 c1 e8 1e          	shr    $0x1e,%rax
  80353e:	48 89 c2             	mov    %rax,%rdx
  803541:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  803548:	01 00 00 
  80354b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80354f:	48 85 c0             	test   %rax,%rax
  803552:	74 1e                	je     803572 <copy_shared_pages+0x72>
  803554:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803558:	48 c1 e8 15          	shr    $0x15,%rax
  80355c:	48 89 c2             	mov    %rax,%rdx
  80355f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803566:	01 00 00 
  803569:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80356d:	48 85 c0             	test   %rax,%rax
  803570:	75 02                	jne    803574 <copy_shared_pages+0x74>
                continue;
  803572:	eb 65                	jmp    8035d9 <copy_shared_pages+0xd9>

            if((uvpt[VPN(addr)] & PTE_SHARE) != 0)
  803574:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803578:	48 c1 e8 0c          	shr    $0xc,%rax
  80357c:	48 89 c2             	mov    %rax,%rdx
  80357f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803586:	01 00 00 
  803589:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80358d:	25 00 04 00 00       	and    $0x400,%eax
  803592:	48 85 c0             	test   %rax,%rax
  803595:	74 42                	je     8035d9 <copy_shared_pages+0xd9>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);
  803597:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80359b:	48 c1 e8 0c          	shr    $0xc,%rax
  80359f:	48 89 c2             	mov    %rax,%rdx
  8035a2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8035a9:	01 00 00 
  8035ac:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8035b0:	25 07 0e 00 00       	and    $0xe07,%eax
  8035b5:	89 c6                	mov    %eax,%esi
  8035b7:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8035bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035bf:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8035c2:	41 89 f0             	mov    %esi,%r8d
  8035c5:	48 89 c6             	mov    %rax,%rsi
  8035c8:	bf 00 00 00 00       	mov    $0x0,%edi
  8035cd:	48 b8 62 1a 80 00 00 	movabs $0x801a62,%rax
  8035d4:	00 00 00 
  8035d7:	ff d0                	callq  *%rax
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  8035d9:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  8035e0:	00 
  8035e1:	48 b8 ff ff 7f 00 80 	movabs $0x80007fffff,%rax
  8035e8:	00 00 00 
  8035eb:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  8035ef:	0f 86 23 ff ff ff    	jbe    803518 <copy_shared_pages+0x18>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);

            }
        }
     return 0;
  8035f5:	b8 00 00 00 00       	mov    $0x0,%eax
 }
  8035fa:	c9                   	leaveq 
  8035fb:	c3                   	retq   

00000000008035fc <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8035fc:	55                   	push   %rbp
  8035fd:	48 89 e5             	mov    %rsp,%rbp
  803600:	53                   	push   %rbx
  803601:	48 83 ec 38          	sub    $0x38,%rsp
  803605:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803609:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80360d:	48 89 c7             	mov    %rax,%rdi
  803610:	48 b8 cd 1c 80 00 00 	movabs $0x801ccd,%rax
  803617:	00 00 00 
  80361a:	ff d0                	callq  *%rax
  80361c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80361f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803623:	0f 88 bf 01 00 00    	js     8037e8 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803629:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80362d:	ba 07 04 00 00       	mov    $0x407,%edx
  803632:	48 89 c6             	mov    %rax,%rsi
  803635:	bf 00 00 00 00       	mov    $0x0,%edi
  80363a:	48 b8 12 1a 80 00 00 	movabs $0x801a12,%rax
  803641:	00 00 00 
  803644:	ff d0                	callq  *%rax
  803646:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803649:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80364d:	0f 88 95 01 00 00    	js     8037e8 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803653:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803657:	48 89 c7             	mov    %rax,%rdi
  80365a:	48 b8 cd 1c 80 00 00 	movabs $0x801ccd,%rax
  803661:	00 00 00 
  803664:	ff d0                	callq  *%rax
  803666:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803669:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80366d:	0f 88 5d 01 00 00    	js     8037d0 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803673:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803677:	ba 07 04 00 00       	mov    $0x407,%edx
  80367c:	48 89 c6             	mov    %rax,%rsi
  80367f:	bf 00 00 00 00       	mov    $0x0,%edi
  803684:	48 b8 12 1a 80 00 00 	movabs $0x801a12,%rax
  80368b:	00 00 00 
  80368e:	ff d0                	callq  *%rax
  803690:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803693:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803697:	0f 88 33 01 00 00    	js     8037d0 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80369d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036a1:	48 89 c7             	mov    %rax,%rdi
  8036a4:	48 b8 a2 1c 80 00 00 	movabs $0x801ca2,%rax
  8036ab:	00 00 00 
  8036ae:	ff d0                	callq  *%rax
  8036b0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8036b4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036b8:	ba 07 04 00 00       	mov    $0x407,%edx
  8036bd:	48 89 c6             	mov    %rax,%rsi
  8036c0:	bf 00 00 00 00       	mov    $0x0,%edi
  8036c5:	48 b8 12 1a 80 00 00 	movabs $0x801a12,%rax
  8036cc:	00 00 00 
  8036cf:	ff d0                	callq  *%rax
  8036d1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036d8:	79 05                	jns    8036df <pipe+0xe3>
		goto err2;
  8036da:	e9 d9 00 00 00       	jmpq   8037b8 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8036df:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036e3:	48 89 c7             	mov    %rax,%rdi
  8036e6:	48 b8 a2 1c 80 00 00 	movabs $0x801ca2,%rax
  8036ed:	00 00 00 
  8036f0:	ff d0                	callq  *%rax
  8036f2:	48 89 c2             	mov    %rax,%rdx
  8036f5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036f9:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8036ff:	48 89 d1             	mov    %rdx,%rcx
  803702:	ba 00 00 00 00       	mov    $0x0,%edx
  803707:	48 89 c6             	mov    %rax,%rsi
  80370a:	bf 00 00 00 00       	mov    $0x0,%edi
  80370f:	48 b8 62 1a 80 00 00 	movabs $0x801a62,%rax
  803716:	00 00 00 
  803719:	ff d0                	callq  *%rax
  80371b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80371e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803722:	79 1b                	jns    80373f <pipe+0x143>
		goto err3;
  803724:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  803725:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803729:	48 89 c6             	mov    %rax,%rsi
  80372c:	bf 00 00 00 00       	mov    $0x0,%edi
  803731:	48 b8 bd 1a 80 00 00 	movabs $0x801abd,%rax
  803738:	00 00 00 
  80373b:	ff d0                	callq  *%rax
  80373d:	eb 79                	jmp    8037b8 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80373f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803743:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  80374a:	00 00 00 
  80374d:	8b 12                	mov    (%rdx),%edx
  80374f:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803751:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803755:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80375c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803760:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803767:	00 00 00 
  80376a:	8b 12                	mov    (%rdx),%edx
  80376c:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80376e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803772:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803779:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80377d:	48 89 c7             	mov    %rax,%rdi
  803780:	48 b8 7f 1c 80 00 00 	movabs $0x801c7f,%rax
  803787:	00 00 00 
  80378a:	ff d0                	callq  *%rax
  80378c:	89 c2                	mov    %eax,%edx
  80378e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803792:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803794:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803798:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80379c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037a0:	48 89 c7             	mov    %rax,%rdi
  8037a3:	48 b8 7f 1c 80 00 00 	movabs $0x801c7f,%rax
  8037aa:	00 00 00 
  8037ad:	ff d0                	callq  *%rax
  8037af:	89 03                	mov    %eax,(%rbx)
	return 0;
  8037b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8037b6:	eb 33                	jmp    8037eb <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  8037b8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037bc:	48 89 c6             	mov    %rax,%rsi
  8037bf:	bf 00 00 00 00       	mov    $0x0,%edi
  8037c4:	48 b8 bd 1a 80 00 00 	movabs $0x801abd,%rax
  8037cb:	00 00 00 
  8037ce:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  8037d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037d4:	48 89 c6             	mov    %rax,%rsi
  8037d7:	bf 00 00 00 00       	mov    $0x0,%edi
  8037dc:	48 b8 bd 1a 80 00 00 	movabs $0x801abd,%rax
  8037e3:	00 00 00 
  8037e6:	ff d0                	callq  *%rax
    err:
	return r;
  8037e8:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8037eb:	48 83 c4 38          	add    $0x38,%rsp
  8037ef:	5b                   	pop    %rbx
  8037f0:	5d                   	pop    %rbp
  8037f1:	c3                   	retq   

00000000008037f2 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8037f2:	55                   	push   %rbp
  8037f3:	48 89 e5             	mov    %rsp,%rbp
  8037f6:	53                   	push   %rbx
  8037f7:	48 83 ec 28          	sub    $0x28,%rsp
  8037fb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8037ff:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803803:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80380a:	00 00 00 
  80380d:	48 8b 00             	mov    (%rax),%rax
  803810:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803816:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803819:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80381d:	48 89 c7             	mov    %rax,%rdi
  803820:	48 b8 62 40 80 00 00 	movabs $0x804062,%rax
  803827:	00 00 00 
  80382a:	ff d0                	callq  *%rax
  80382c:	89 c3                	mov    %eax,%ebx
  80382e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803832:	48 89 c7             	mov    %rax,%rdi
  803835:	48 b8 62 40 80 00 00 	movabs $0x804062,%rax
  80383c:	00 00 00 
  80383f:	ff d0                	callq  *%rax
  803841:	39 c3                	cmp    %eax,%ebx
  803843:	0f 94 c0             	sete   %al
  803846:	0f b6 c0             	movzbl %al,%eax
  803849:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80384c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803853:	00 00 00 
  803856:	48 8b 00             	mov    (%rax),%rax
  803859:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80385f:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803862:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803865:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803868:	75 05                	jne    80386f <_pipeisclosed+0x7d>
			return ret;
  80386a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80386d:	eb 4f                	jmp    8038be <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80386f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803872:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803875:	74 42                	je     8038b9 <_pipeisclosed+0xc7>
  803877:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80387b:	75 3c                	jne    8038b9 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80387d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803884:	00 00 00 
  803887:	48 8b 00             	mov    (%rax),%rax
  80388a:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803890:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803893:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803896:	89 c6                	mov    %eax,%esi
  803898:	48 bf 5d 48 80 00 00 	movabs $0x80485d,%rdi
  80389f:	00 00 00 
  8038a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8038a7:	49 b8 2e 05 80 00 00 	movabs $0x80052e,%r8
  8038ae:	00 00 00 
  8038b1:	41 ff d0             	callq  *%r8
	}
  8038b4:	e9 4a ff ff ff       	jmpq   803803 <_pipeisclosed+0x11>
  8038b9:	e9 45 ff ff ff       	jmpq   803803 <_pipeisclosed+0x11>
}
  8038be:	48 83 c4 28          	add    $0x28,%rsp
  8038c2:	5b                   	pop    %rbx
  8038c3:	5d                   	pop    %rbp
  8038c4:	c3                   	retq   

00000000008038c5 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8038c5:	55                   	push   %rbp
  8038c6:	48 89 e5             	mov    %rsp,%rbp
  8038c9:	48 83 ec 30          	sub    $0x30,%rsp
  8038cd:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8038d0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8038d4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8038d7:	48 89 d6             	mov    %rdx,%rsi
  8038da:	89 c7                	mov    %eax,%edi
  8038dc:	48 b8 65 1d 80 00 00 	movabs $0x801d65,%rax
  8038e3:	00 00 00 
  8038e6:	ff d0                	callq  *%rax
  8038e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038ef:	79 05                	jns    8038f6 <pipeisclosed+0x31>
		return r;
  8038f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038f4:	eb 31                	jmp    803927 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8038f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038fa:	48 89 c7             	mov    %rax,%rdi
  8038fd:	48 b8 a2 1c 80 00 00 	movabs $0x801ca2,%rax
  803904:	00 00 00 
  803907:	ff d0                	callq  *%rax
  803909:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80390d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803911:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803915:	48 89 d6             	mov    %rdx,%rsi
  803918:	48 89 c7             	mov    %rax,%rdi
  80391b:	48 b8 f2 37 80 00 00 	movabs $0x8037f2,%rax
  803922:	00 00 00 
  803925:	ff d0                	callq  *%rax
}
  803927:	c9                   	leaveq 
  803928:	c3                   	retq   

0000000000803929 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803929:	55                   	push   %rbp
  80392a:	48 89 e5             	mov    %rsp,%rbp
  80392d:	48 83 ec 40          	sub    $0x40,%rsp
  803931:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803935:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803939:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80393d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803941:	48 89 c7             	mov    %rax,%rdi
  803944:	48 b8 a2 1c 80 00 00 	movabs $0x801ca2,%rax
  80394b:	00 00 00 
  80394e:	ff d0                	callq  *%rax
  803950:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803954:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803958:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80395c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803963:	00 
  803964:	e9 92 00 00 00       	jmpq   8039fb <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803969:	eb 41                	jmp    8039ac <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80396b:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803970:	74 09                	je     80397b <devpipe_read+0x52>
				return i;
  803972:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803976:	e9 92 00 00 00       	jmpq   803a0d <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80397b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80397f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803983:	48 89 d6             	mov    %rdx,%rsi
  803986:	48 89 c7             	mov    %rax,%rdi
  803989:	48 b8 f2 37 80 00 00 	movabs $0x8037f2,%rax
  803990:	00 00 00 
  803993:	ff d0                	callq  *%rax
  803995:	85 c0                	test   %eax,%eax
  803997:	74 07                	je     8039a0 <devpipe_read+0x77>
				return 0;
  803999:	b8 00 00 00 00       	mov    $0x0,%eax
  80399e:	eb 6d                	jmp    803a0d <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8039a0:	48 b8 d4 19 80 00 00 	movabs $0x8019d4,%rax
  8039a7:	00 00 00 
  8039aa:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8039ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039b0:	8b 10                	mov    (%rax),%edx
  8039b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039b6:	8b 40 04             	mov    0x4(%rax),%eax
  8039b9:	39 c2                	cmp    %eax,%edx
  8039bb:	74 ae                	je     80396b <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8039bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039c1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8039c5:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8039c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039cd:	8b 00                	mov    (%rax),%eax
  8039cf:	99                   	cltd   
  8039d0:	c1 ea 1b             	shr    $0x1b,%edx
  8039d3:	01 d0                	add    %edx,%eax
  8039d5:	83 e0 1f             	and    $0x1f,%eax
  8039d8:	29 d0                	sub    %edx,%eax
  8039da:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039de:	48 98                	cltq   
  8039e0:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8039e5:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8039e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039eb:	8b 00                	mov    (%rax),%eax
  8039ed:	8d 50 01             	lea    0x1(%rax),%edx
  8039f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039f4:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8039f6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8039fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039ff:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803a03:	0f 82 60 ff ff ff    	jb     803969 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803a09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803a0d:	c9                   	leaveq 
  803a0e:	c3                   	retq   

0000000000803a0f <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803a0f:	55                   	push   %rbp
  803a10:	48 89 e5             	mov    %rsp,%rbp
  803a13:	48 83 ec 40          	sub    $0x40,%rsp
  803a17:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803a1b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803a1f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803a23:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a27:	48 89 c7             	mov    %rax,%rdi
  803a2a:	48 b8 a2 1c 80 00 00 	movabs $0x801ca2,%rax
  803a31:	00 00 00 
  803a34:	ff d0                	callq  *%rax
  803a36:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803a3a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a3e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803a42:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803a49:	00 
  803a4a:	e9 8e 00 00 00       	jmpq   803add <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803a4f:	eb 31                	jmp    803a82 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803a51:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a55:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a59:	48 89 d6             	mov    %rdx,%rsi
  803a5c:	48 89 c7             	mov    %rax,%rdi
  803a5f:	48 b8 f2 37 80 00 00 	movabs $0x8037f2,%rax
  803a66:	00 00 00 
  803a69:	ff d0                	callq  *%rax
  803a6b:	85 c0                	test   %eax,%eax
  803a6d:	74 07                	je     803a76 <devpipe_write+0x67>
				return 0;
  803a6f:	b8 00 00 00 00       	mov    $0x0,%eax
  803a74:	eb 79                	jmp    803aef <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803a76:	48 b8 d4 19 80 00 00 	movabs $0x8019d4,%rax
  803a7d:	00 00 00 
  803a80:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803a82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a86:	8b 40 04             	mov    0x4(%rax),%eax
  803a89:	48 63 d0             	movslq %eax,%rdx
  803a8c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a90:	8b 00                	mov    (%rax),%eax
  803a92:	48 98                	cltq   
  803a94:	48 83 c0 20          	add    $0x20,%rax
  803a98:	48 39 c2             	cmp    %rax,%rdx
  803a9b:	73 b4                	jae    803a51 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803a9d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803aa1:	8b 40 04             	mov    0x4(%rax),%eax
  803aa4:	99                   	cltd   
  803aa5:	c1 ea 1b             	shr    $0x1b,%edx
  803aa8:	01 d0                	add    %edx,%eax
  803aaa:	83 e0 1f             	and    $0x1f,%eax
  803aad:	29 d0                	sub    %edx,%eax
  803aaf:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803ab3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803ab7:	48 01 ca             	add    %rcx,%rdx
  803aba:	0f b6 0a             	movzbl (%rdx),%ecx
  803abd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ac1:	48 98                	cltq   
  803ac3:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803ac7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803acb:	8b 40 04             	mov    0x4(%rax),%eax
  803ace:	8d 50 01             	lea    0x1(%rax),%edx
  803ad1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ad5:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803ad8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803add:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ae1:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803ae5:	0f 82 64 ff ff ff    	jb     803a4f <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803aeb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803aef:	c9                   	leaveq 
  803af0:	c3                   	retq   

0000000000803af1 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803af1:	55                   	push   %rbp
  803af2:	48 89 e5             	mov    %rsp,%rbp
  803af5:	48 83 ec 20          	sub    $0x20,%rsp
  803af9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803afd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803b01:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b05:	48 89 c7             	mov    %rax,%rdi
  803b08:	48 b8 a2 1c 80 00 00 	movabs $0x801ca2,%rax
  803b0f:	00 00 00 
  803b12:	ff d0                	callq  *%rax
  803b14:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803b18:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b1c:	48 be 70 48 80 00 00 	movabs $0x804870,%rsi
  803b23:	00 00 00 
  803b26:	48 89 c7             	mov    %rax,%rdi
  803b29:	48 b8 e3 10 80 00 00 	movabs $0x8010e3,%rax
  803b30:	00 00 00 
  803b33:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803b35:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b39:	8b 50 04             	mov    0x4(%rax),%edx
  803b3c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b40:	8b 00                	mov    (%rax),%eax
  803b42:	29 c2                	sub    %eax,%edx
  803b44:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b48:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803b4e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b52:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803b59:	00 00 00 
	stat->st_dev = &devpipe;
  803b5c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b60:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  803b67:	00 00 00 
  803b6a:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803b71:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b76:	c9                   	leaveq 
  803b77:	c3                   	retq   

0000000000803b78 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803b78:	55                   	push   %rbp
  803b79:	48 89 e5             	mov    %rsp,%rbp
  803b7c:	48 83 ec 10          	sub    $0x10,%rsp
  803b80:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803b84:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b88:	48 89 c6             	mov    %rax,%rsi
  803b8b:	bf 00 00 00 00       	mov    $0x0,%edi
  803b90:	48 b8 bd 1a 80 00 00 	movabs $0x801abd,%rax
  803b97:	00 00 00 
  803b9a:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803b9c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ba0:	48 89 c7             	mov    %rax,%rdi
  803ba3:	48 b8 a2 1c 80 00 00 	movabs $0x801ca2,%rax
  803baa:	00 00 00 
  803bad:	ff d0                	callq  *%rax
  803baf:	48 89 c6             	mov    %rax,%rsi
  803bb2:	bf 00 00 00 00       	mov    $0x0,%edi
  803bb7:	48 b8 bd 1a 80 00 00 	movabs $0x801abd,%rax
  803bbe:	00 00 00 
  803bc1:	ff d0                	callq  *%rax
}
  803bc3:	c9                   	leaveq 
  803bc4:	c3                   	retq   

0000000000803bc5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803bc5:	55                   	push   %rbp
  803bc6:	48 89 e5             	mov    %rsp,%rbp
  803bc9:	48 83 ec 20          	sub    $0x20,%rsp
  803bcd:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803bd0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bd3:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803bd6:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803bda:	be 01 00 00 00       	mov    $0x1,%esi
  803bdf:	48 89 c7             	mov    %rax,%rdi
  803be2:	48 b8 ca 18 80 00 00 	movabs $0x8018ca,%rax
  803be9:	00 00 00 
  803bec:	ff d0                	callq  *%rax
}
  803bee:	c9                   	leaveq 
  803bef:	c3                   	retq   

0000000000803bf0 <getchar>:

int
getchar(void)
{
  803bf0:	55                   	push   %rbp
  803bf1:	48 89 e5             	mov    %rsp,%rbp
  803bf4:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803bf8:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803bfc:	ba 01 00 00 00       	mov    $0x1,%edx
  803c01:	48 89 c6             	mov    %rax,%rsi
  803c04:	bf 00 00 00 00       	mov    $0x0,%edi
  803c09:	48 b8 97 21 80 00 00 	movabs $0x802197,%rax
  803c10:	00 00 00 
  803c13:	ff d0                	callq  *%rax
  803c15:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803c18:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c1c:	79 05                	jns    803c23 <getchar+0x33>
		return r;
  803c1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c21:	eb 14                	jmp    803c37 <getchar+0x47>
	if (r < 1)
  803c23:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c27:	7f 07                	jg     803c30 <getchar+0x40>
		return -E_EOF;
  803c29:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803c2e:	eb 07                	jmp    803c37 <getchar+0x47>
	return c;
  803c30:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803c34:	0f b6 c0             	movzbl %al,%eax
}
  803c37:	c9                   	leaveq 
  803c38:	c3                   	retq   

0000000000803c39 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803c39:	55                   	push   %rbp
  803c3a:	48 89 e5             	mov    %rsp,%rbp
  803c3d:	48 83 ec 20          	sub    $0x20,%rsp
  803c41:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803c44:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803c48:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c4b:	48 89 d6             	mov    %rdx,%rsi
  803c4e:	89 c7                	mov    %eax,%edi
  803c50:	48 b8 65 1d 80 00 00 	movabs $0x801d65,%rax
  803c57:	00 00 00 
  803c5a:	ff d0                	callq  *%rax
  803c5c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c5f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c63:	79 05                	jns    803c6a <iscons+0x31>
		return r;
  803c65:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c68:	eb 1a                	jmp    803c84 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803c6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c6e:	8b 10                	mov    (%rax),%edx
  803c70:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  803c77:	00 00 00 
  803c7a:	8b 00                	mov    (%rax),%eax
  803c7c:	39 c2                	cmp    %eax,%edx
  803c7e:	0f 94 c0             	sete   %al
  803c81:	0f b6 c0             	movzbl %al,%eax
}
  803c84:	c9                   	leaveq 
  803c85:	c3                   	retq   

0000000000803c86 <opencons>:

int
opencons(void)
{
  803c86:	55                   	push   %rbp
  803c87:	48 89 e5             	mov    %rsp,%rbp
  803c8a:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803c8e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803c92:	48 89 c7             	mov    %rax,%rdi
  803c95:	48 b8 cd 1c 80 00 00 	movabs $0x801ccd,%rax
  803c9c:	00 00 00 
  803c9f:	ff d0                	callq  *%rax
  803ca1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ca4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ca8:	79 05                	jns    803caf <opencons+0x29>
		return r;
  803caa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cad:	eb 5b                	jmp    803d0a <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803caf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cb3:	ba 07 04 00 00       	mov    $0x407,%edx
  803cb8:	48 89 c6             	mov    %rax,%rsi
  803cbb:	bf 00 00 00 00       	mov    $0x0,%edi
  803cc0:	48 b8 12 1a 80 00 00 	movabs $0x801a12,%rax
  803cc7:	00 00 00 
  803cca:	ff d0                	callq  *%rax
  803ccc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ccf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cd3:	79 05                	jns    803cda <opencons+0x54>
		return r;
  803cd5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cd8:	eb 30                	jmp    803d0a <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803cda:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cde:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803ce5:	00 00 00 
  803ce8:	8b 12                	mov    (%rdx),%edx
  803cea:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803cec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cf0:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803cf7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cfb:	48 89 c7             	mov    %rax,%rdi
  803cfe:	48 b8 7f 1c 80 00 00 	movabs $0x801c7f,%rax
  803d05:	00 00 00 
  803d08:	ff d0                	callq  *%rax
}
  803d0a:	c9                   	leaveq 
  803d0b:	c3                   	retq   

0000000000803d0c <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803d0c:	55                   	push   %rbp
  803d0d:	48 89 e5             	mov    %rsp,%rbp
  803d10:	48 83 ec 30          	sub    $0x30,%rsp
  803d14:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803d18:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d1c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803d20:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803d25:	75 07                	jne    803d2e <devcons_read+0x22>
		return 0;
  803d27:	b8 00 00 00 00       	mov    $0x0,%eax
  803d2c:	eb 4b                	jmp    803d79 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803d2e:	eb 0c                	jmp    803d3c <devcons_read+0x30>
		sys_yield();
  803d30:	48 b8 d4 19 80 00 00 	movabs $0x8019d4,%rax
  803d37:	00 00 00 
  803d3a:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803d3c:	48 b8 14 19 80 00 00 	movabs $0x801914,%rax
  803d43:	00 00 00 
  803d46:	ff d0                	callq  *%rax
  803d48:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d4b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d4f:	74 df                	je     803d30 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803d51:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d55:	79 05                	jns    803d5c <devcons_read+0x50>
		return c;
  803d57:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d5a:	eb 1d                	jmp    803d79 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803d5c:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803d60:	75 07                	jne    803d69 <devcons_read+0x5d>
		return 0;
  803d62:	b8 00 00 00 00       	mov    $0x0,%eax
  803d67:	eb 10                	jmp    803d79 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803d69:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d6c:	89 c2                	mov    %eax,%edx
  803d6e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d72:	88 10                	mov    %dl,(%rax)
	return 1;
  803d74:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803d79:	c9                   	leaveq 
  803d7a:	c3                   	retq   

0000000000803d7b <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803d7b:	55                   	push   %rbp
  803d7c:	48 89 e5             	mov    %rsp,%rbp
  803d7f:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803d86:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803d8d:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803d94:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803d9b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803da2:	eb 76                	jmp    803e1a <devcons_write+0x9f>
		m = n - tot;
  803da4:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803dab:	89 c2                	mov    %eax,%edx
  803dad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803db0:	29 c2                	sub    %eax,%edx
  803db2:	89 d0                	mov    %edx,%eax
  803db4:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803db7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803dba:	83 f8 7f             	cmp    $0x7f,%eax
  803dbd:	76 07                	jbe    803dc6 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803dbf:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803dc6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803dc9:	48 63 d0             	movslq %eax,%rdx
  803dcc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dcf:	48 63 c8             	movslq %eax,%rcx
  803dd2:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803dd9:	48 01 c1             	add    %rax,%rcx
  803ddc:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803de3:	48 89 ce             	mov    %rcx,%rsi
  803de6:	48 89 c7             	mov    %rax,%rdi
  803de9:	48 b8 07 14 80 00 00 	movabs $0x801407,%rax
  803df0:	00 00 00 
  803df3:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803df5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803df8:	48 63 d0             	movslq %eax,%rdx
  803dfb:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803e02:	48 89 d6             	mov    %rdx,%rsi
  803e05:	48 89 c7             	mov    %rax,%rdi
  803e08:	48 b8 ca 18 80 00 00 	movabs $0x8018ca,%rax
  803e0f:	00 00 00 
  803e12:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803e14:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e17:	01 45 fc             	add    %eax,-0x4(%rbp)
  803e1a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e1d:	48 98                	cltq   
  803e1f:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803e26:	0f 82 78 ff ff ff    	jb     803da4 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803e2c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803e2f:	c9                   	leaveq 
  803e30:	c3                   	retq   

0000000000803e31 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803e31:	55                   	push   %rbp
  803e32:	48 89 e5             	mov    %rsp,%rbp
  803e35:	48 83 ec 08          	sub    $0x8,%rsp
  803e39:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803e3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e42:	c9                   	leaveq 
  803e43:	c3                   	retq   

0000000000803e44 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803e44:	55                   	push   %rbp
  803e45:	48 89 e5             	mov    %rsp,%rbp
  803e48:	48 83 ec 10          	sub    $0x10,%rsp
  803e4c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803e50:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803e54:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e58:	48 be 7c 48 80 00 00 	movabs $0x80487c,%rsi
  803e5f:	00 00 00 
  803e62:	48 89 c7             	mov    %rax,%rdi
  803e65:	48 b8 e3 10 80 00 00 	movabs $0x8010e3,%rax
  803e6c:	00 00 00 
  803e6f:	ff d0                	callq  *%rax
	return 0;
  803e71:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e76:	c9                   	leaveq 
  803e77:	c3                   	retq   

0000000000803e78 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803e78:	55                   	push   %rbp
  803e79:	48 89 e5             	mov    %rsp,%rbp
  803e7c:	48 83 ec 30          	sub    $0x30,%rsp
  803e80:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803e84:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803e88:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803e8c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803e93:	00 00 00 
  803e96:	48 8b 00             	mov    (%rax),%rax
  803e99:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803e9f:	85 c0                	test   %eax,%eax
  803ea1:	75 3c                	jne    803edf <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  803ea3:	48 b8 96 19 80 00 00 	movabs $0x801996,%rax
  803eaa:	00 00 00 
  803ead:	ff d0                	callq  *%rax
  803eaf:	25 ff 03 00 00       	and    $0x3ff,%eax
  803eb4:	48 63 d0             	movslq %eax,%rdx
  803eb7:	48 89 d0             	mov    %rdx,%rax
  803eba:	48 c1 e0 03          	shl    $0x3,%rax
  803ebe:	48 01 d0             	add    %rdx,%rax
  803ec1:	48 c1 e0 05          	shl    $0x5,%rax
  803ec5:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803ecc:	00 00 00 
  803ecf:	48 01 c2             	add    %rax,%rdx
  803ed2:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803ed9:	00 00 00 
  803edc:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803edf:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803ee4:	75 0e                	jne    803ef4 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  803ee6:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803eed:	00 00 00 
  803ef0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803ef4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ef8:	48 89 c7             	mov    %rax,%rdi
  803efb:	48 b8 3b 1c 80 00 00 	movabs $0x801c3b,%rax
  803f02:	00 00 00 
  803f05:	ff d0                	callq  *%rax
  803f07:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803f0a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f0e:	79 19                	jns    803f29 <ipc_recv+0xb1>
		*from_env_store = 0;
  803f10:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f14:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803f1a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f1e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803f24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f27:	eb 53                	jmp    803f7c <ipc_recv+0x104>
	}
	if(from_env_store)
  803f29:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803f2e:	74 19                	je     803f49 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  803f30:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f37:	00 00 00 
  803f3a:	48 8b 00             	mov    (%rax),%rax
  803f3d:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803f43:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f47:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803f49:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803f4e:	74 19                	je     803f69 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  803f50:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f57:	00 00 00 
  803f5a:	48 8b 00             	mov    (%rax),%rax
  803f5d:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803f63:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f67:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803f69:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f70:	00 00 00 
  803f73:	48 8b 00             	mov    (%rax),%rax
  803f76:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803f7c:	c9                   	leaveq 
  803f7d:	c3                   	retq   

0000000000803f7e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803f7e:	55                   	push   %rbp
  803f7f:	48 89 e5             	mov    %rsp,%rbp
  803f82:	48 83 ec 30          	sub    $0x30,%rsp
  803f86:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803f89:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803f8c:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803f90:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803f93:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803f98:	75 0e                	jne    803fa8 <ipc_send+0x2a>
		pg = (void*)UTOP;
  803f9a:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803fa1:	00 00 00 
  803fa4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  803fa8:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803fab:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803fae:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803fb2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fb5:	89 c7                	mov    %eax,%edi
  803fb7:	48 b8 e6 1b 80 00 00 	movabs $0x801be6,%rax
  803fbe:	00 00 00 
  803fc1:	ff d0                	callq  *%rax
  803fc3:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  803fc6:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803fca:	75 0c                	jne    803fd8 <ipc_send+0x5a>
			sys_yield();
  803fcc:	48 b8 d4 19 80 00 00 	movabs $0x8019d4,%rax
  803fd3:	00 00 00 
  803fd6:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  803fd8:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803fdc:	74 ca                	je     803fa8 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  803fde:	c9                   	leaveq 
  803fdf:	c3                   	retq   

0000000000803fe0 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803fe0:	55                   	push   %rbp
  803fe1:	48 89 e5             	mov    %rsp,%rbp
  803fe4:	48 83 ec 14          	sub    $0x14,%rsp
  803fe8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  803feb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803ff2:	eb 5e                	jmp    804052 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803ff4:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803ffb:	00 00 00 
  803ffe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804001:	48 63 d0             	movslq %eax,%rdx
  804004:	48 89 d0             	mov    %rdx,%rax
  804007:	48 c1 e0 03          	shl    $0x3,%rax
  80400b:	48 01 d0             	add    %rdx,%rax
  80400e:	48 c1 e0 05          	shl    $0x5,%rax
  804012:	48 01 c8             	add    %rcx,%rax
  804015:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80401b:	8b 00                	mov    (%rax),%eax
  80401d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804020:	75 2c                	jne    80404e <ipc_find_env+0x6e>
			return envs[i].env_id;
  804022:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804029:	00 00 00 
  80402c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80402f:	48 63 d0             	movslq %eax,%rdx
  804032:	48 89 d0             	mov    %rdx,%rax
  804035:	48 c1 e0 03          	shl    $0x3,%rax
  804039:	48 01 d0             	add    %rdx,%rax
  80403c:	48 c1 e0 05          	shl    $0x5,%rax
  804040:	48 01 c8             	add    %rcx,%rax
  804043:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804049:	8b 40 08             	mov    0x8(%rax),%eax
  80404c:	eb 12                	jmp    804060 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80404e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804052:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804059:	7e 99                	jle    803ff4 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  80405b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804060:	c9                   	leaveq 
  804061:	c3                   	retq   

0000000000804062 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804062:	55                   	push   %rbp
  804063:	48 89 e5             	mov    %rsp,%rbp
  804066:	48 83 ec 18          	sub    $0x18,%rsp
  80406a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80406e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804072:	48 c1 e8 15          	shr    $0x15,%rax
  804076:	48 89 c2             	mov    %rax,%rdx
  804079:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804080:	01 00 00 
  804083:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804087:	83 e0 01             	and    $0x1,%eax
  80408a:	48 85 c0             	test   %rax,%rax
  80408d:	75 07                	jne    804096 <pageref+0x34>
		return 0;
  80408f:	b8 00 00 00 00       	mov    $0x0,%eax
  804094:	eb 53                	jmp    8040e9 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804096:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80409a:	48 c1 e8 0c          	shr    $0xc,%rax
  80409e:	48 89 c2             	mov    %rax,%rdx
  8040a1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8040a8:	01 00 00 
  8040ab:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8040af:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8040b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040b7:	83 e0 01             	and    $0x1,%eax
  8040ba:	48 85 c0             	test   %rax,%rax
  8040bd:	75 07                	jne    8040c6 <pageref+0x64>
		return 0;
  8040bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8040c4:	eb 23                	jmp    8040e9 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8040c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040ca:	48 c1 e8 0c          	shr    $0xc,%rax
  8040ce:	48 89 c2             	mov    %rax,%rdx
  8040d1:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8040d8:	00 00 00 
  8040db:	48 c1 e2 04          	shl    $0x4,%rdx
  8040df:	48 01 d0             	add    %rdx,%rax
  8040e2:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8040e6:	0f b7 c0             	movzwl %ax,%eax
}
  8040e9:	c9                   	leaveq 
  8040ea:	c3                   	retq   
