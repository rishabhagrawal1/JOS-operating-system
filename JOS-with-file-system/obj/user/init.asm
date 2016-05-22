
obj/user/init.debug:     file format elf64-x86-64


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
  80003c:	e8 51 06 00 00       	callq  800692 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <sum>:

char bss[6000];

int
sum(const char *s, int n)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 1c          	sub    $0x1c,%rsp
  80004b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80004f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	int i, tot = 0;
  800052:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	for (i = 0; i < n; i++)
  800059:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800060:	eb 1e                	jmp    800080 <sum+0x3d>
		tot ^= i * s[i];
  800062:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800065:	48 63 d0             	movslq %eax,%rdx
  800068:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80006c:	48 01 d0             	add    %rdx,%rax
  80006f:	0f b6 00             	movzbl (%rax),%eax
  800072:	0f be c0             	movsbl %al,%eax
  800075:	0f af 45 fc          	imul   -0x4(%rbp),%eax
  800079:	31 45 f8             	xor    %eax,-0x8(%rbp)

int
sum(const char *s, int n)
{
	int i, tot = 0;
	for (i = 0; i < n; i++)
  80007c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800080:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800083:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  800086:	7c da                	jl     800062 <sum+0x1f>
		tot ^= i * s[i];
	return tot;
  800088:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80008b:	c9                   	leaveq 
  80008c:	c3                   	retq   

000000000080008d <umain>:

void
umain(int argc, char **argv)
{
  80008d:	55                   	push   %rbp
  80008e:	48 89 e5             	mov    %rsp,%rbp
  800091:	48 81 ec 20 01 00 00 	sub    $0x120,%rsp
  800098:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  80009e:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
	int i, r, x, want;
	char args[256];

	cprintf("init: running\n");
  8000a5:	48 bf 20 43 80 00 00 	movabs $0x804320,%rdi
  8000ac:	00 00 00 
  8000af:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b4:	48 ba 79 09 80 00 00 	movabs $0x800979,%rdx
  8000bb:	00 00 00 
  8000be:	ff d2                	callq  *%rdx

	want = 0xf989e;
  8000c0:	c7 45 f8 9e 98 0f 00 	movl   $0xf989e,-0x8(%rbp)
	if ((x = sum((char*)&data, sizeof data)) != want)
  8000c7:	be 70 17 00 00       	mov    $0x1770,%esi
  8000cc:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  8000d3:	00 00 00 
  8000d6:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000dd:	00 00 00 
  8000e0:	ff d0                	callq  *%rax
  8000e2:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8000e5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8000e8:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  8000eb:	74 25                	je     800112 <umain+0x85>
		cprintf("init: data is not initialized: got sum %08x wanted %08x\n",
  8000ed:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8000f0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8000f3:	89 c6                	mov    %eax,%esi
  8000f5:	48 bf 30 43 80 00 00 	movabs $0x804330,%rdi
  8000fc:	00 00 00 
  8000ff:	b8 00 00 00 00       	mov    $0x0,%eax
  800104:	48 b9 79 09 80 00 00 	movabs $0x800979,%rcx
  80010b:	00 00 00 
  80010e:	ff d1                	callq  *%rcx
  800110:	eb 1b                	jmp    80012d <umain+0xa0>
			x, want);
	else
		cprintf("init: data seems okay\n");
  800112:	48 bf 69 43 80 00 00 	movabs $0x804369,%rdi
  800119:	00 00 00 
  80011c:	b8 00 00 00 00       	mov    $0x0,%eax
  800121:	48 ba 79 09 80 00 00 	movabs $0x800979,%rdx
  800128:	00 00 00 
  80012b:	ff d2                	callq  *%rdx
	if ((x = sum(bss, sizeof bss)) != 0)
  80012d:	be 70 17 00 00       	mov    $0x1770,%esi
  800132:	48 bf 20 80 80 00 00 	movabs $0x808020,%rdi
  800139:	00 00 00 
  80013c:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800143:	00 00 00 
  800146:	ff d0                	callq  *%rax
  800148:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80014b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80014f:	74 22                	je     800173 <umain+0xe6>
		cprintf("bss is not initialized: wanted sum 0 got %08x\n", x);
  800151:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800154:	89 c6                	mov    %eax,%esi
  800156:	48 bf 80 43 80 00 00 	movabs $0x804380,%rdi
  80015d:	00 00 00 
  800160:	b8 00 00 00 00       	mov    $0x0,%eax
  800165:	48 ba 79 09 80 00 00 	movabs $0x800979,%rdx
  80016c:	00 00 00 
  80016f:	ff d2                	callq  *%rdx
  800171:	eb 1b                	jmp    80018e <umain+0x101>
	else
		cprintf("init: bss seems okay\n");
  800173:	48 bf af 43 80 00 00 	movabs $0x8043af,%rdi
  80017a:	00 00 00 
  80017d:	b8 00 00 00 00       	mov    $0x0,%eax
  800182:	48 ba 79 09 80 00 00 	movabs $0x800979,%rdx
  800189:	00 00 00 
  80018c:	ff d2                	callq  *%rdx

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
  80018e:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800195:	48 be c5 43 80 00 00 	movabs $0x8043c5,%rsi
  80019c:	00 00 00 
  80019f:	48 89 c7             	mov    %rax,%rdi
  8001a2:	48 b8 71 15 80 00 00 	movabs $0x801571,%rax
  8001a9:	00 00 00 
  8001ac:	ff d0                	callq  *%rax
	for (i = 0; i < argc; i++) {
  8001ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8001b5:	eb 77                	jmp    80022e <umain+0x1a1>
		strcat(args, " '");
  8001b7:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8001be:	48 be d1 43 80 00 00 	movabs $0x8043d1,%rsi
  8001c5:	00 00 00 
  8001c8:	48 89 c7             	mov    %rax,%rdi
  8001cb:	48 b8 71 15 80 00 00 	movabs $0x801571,%rax
  8001d2:	00 00 00 
  8001d5:	ff d0                	callq  *%rax
		strcat(args, argv[i]);
  8001d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001da:	48 98                	cltq   
  8001dc:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8001e3:	00 
  8001e4:	48 8b 85 e0 fe ff ff 	mov    -0x120(%rbp),%rax
  8001eb:	48 01 d0             	add    %rdx,%rax
  8001ee:	48 8b 10             	mov    (%rax),%rdx
  8001f1:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8001f8:	48 89 d6             	mov    %rdx,%rsi
  8001fb:	48 89 c7             	mov    %rax,%rdi
  8001fe:	48 b8 71 15 80 00 00 	movabs $0x801571,%rax
  800205:	00 00 00 
  800208:	ff d0                	callq  *%rax
		strcat(args, "'");
  80020a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800211:	48 be d4 43 80 00 00 	movabs $0x8043d4,%rsi
  800218:	00 00 00 
  80021b:	48 89 c7             	mov    %rax,%rdi
  80021e:	48 b8 71 15 80 00 00 	movabs $0x801571,%rax
  800225:	00 00 00 
  800228:	ff d0                	callq  *%rax
	else
		cprintf("init: bss seems okay\n");

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
	for (i = 0; i < argc; i++) {
  80022a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80022e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800231:	3b 85 ec fe ff ff    	cmp    -0x114(%rbp),%eax
  800237:	0f 8c 7a ff ff ff    	jl     8001b7 <umain+0x12a>
		strcat(args, " '");
		strcat(args, argv[i]);
		strcat(args, "'");
	}
	cprintf("%s\n", args);
  80023d:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800244:	48 89 c6             	mov    %rax,%rsi
  800247:	48 bf d6 43 80 00 00 	movabs $0x8043d6,%rdi
  80024e:	00 00 00 
  800251:	b8 00 00 00 00       	mov    $0x0,%eax
  800256:	48 ba 79 09 80 00 00 	movabs $0x800979,%rdx
  80025d:	00 00 00 
  800260:	ff d2                	callq  *%rdx

	cprintf("init: running sh\n");
  800262:	48 bf da 43 80 00 00 	movabs $0x8043da,%rdi
  800269:	00 00 00 
  80026c:	b8 00 00 00 00       	mov    $0x0,%eax
  800271:	48 ba 79 09 80 00 00 	movabs $0x800979,%rdx
  800278:	00 00 00 
  80027b:	ff d2                	callq  *%rdx

	// being run directly from kernel, so no file descriptors open yet
	close(0);
  80027d:	bf 00 00 00 00       	mov    $0x0,%edi
  800282:	48 b8 c0 23 80 00 00 	movabs $0x8023c0,%rax
  800289:	00 00 00 
  80028c:	ff d0                	callq  *%rax
	if ((r = opencons()) < 0)
  80028e:	48 b8 a0 04 80 00 00 	movabs $0x8004a0,%rax
  800295:	00 00 00 
  800298:	ff d0                	callq  *%rax
  80029a:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80029d:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8002a1:	79 30                	jns    8002d3 <umain+0x246>
		panic("opencons: %e", r);
  8002a3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002a6:	89 c1                	mov    %eax,%ecx
  8002a8:	48 ba ec 43 80 00 00 	movabs $0x8043ec,%rdx
  8002af:	00 00 00 
  8002b2:	be 37 00 00 00       	mov    $0x37,%esi
  8002b7:	48 bf f9 43 80 00 00 	movabs $0x8043f9,%rdi
  8002be:	00 00 00 
  8002c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c6:	49 b8 40 07 80 00 00 	movabs $0x800740,%r8
  8002cd:	00 00 00 
  8002d0:	41 ff d0             	callq  *%r8
	if (r != 0)
  8002d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8002d7:	74 30                	je     800309 <umain+0x27c>
		panic("first opencons used fd %d", r);
  8002d9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002dc:	89 c1                	mov    %eax,%ecx
  8002de:	48 ba 05 44 80 00 00 	movabs $0x804405,%rdx
  8002e5:	00 00 00 
  8002e8:	be 39 00 00 00       	mov    $0x39,%esi
  8002ed:	48 bf f9 43 80 00 00 	movabs $0x8043f9,%rdi
  8002f4:	00 00 00 
  8002f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fc:	49 b8 40 07 80 00 00 	movabs $0x800740,%r8
  800303:	00 00 00 
  800306:	41 ff d0             	callq  *%r8
	if ((r = dup(0, 1)) < 0)
  800309:	be 01 00 00 00       	mov    $0x1,%esi
  80030e:	bf 00 00 00 00       	mov    $0x0,%edi
  800313:	48 b8 39 24 80 00 00 	movabs $0x802439,%rax
  80031a:	00 00 00 
  80031d:	ff d0                	callq  *%rax
  80031f:	89 45 f0             	mov    %eax,-0x10(%rbp)
  800322:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800326:	79 30                	jns    800358 <umain+0x2cb>
		panic("dup: %e", r);
  800328:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80032b:	89 c1                	mov    %eax,%ecx
  80032d:	48 ba 1f 44 80 00 00 	movabs $0x80441f,%rdx
  800334:	00 00 00 
  800337:	be 3b 00 00 00       	mov    $0x3b,%esi
  80033c:	48 bf f9 43 80 00 00 	movabs $0x8043f9,%rdi
  800343:	00 00 00 
  800346:	b8 00 00 00 00       	mov    $0x0,%eax
  80034b:	49 b8 40 07 80 00 00 	movabs $0x800740,%r8
  800352:	00 00 00 
  800355:	41 ff d0             	callq  *%r8
	while (1) {
		cprintf("init: starting sh\n");
  800358:	48 bf 27 44 80 00 00 	movabs $0x804427,%rdi
  80035f:	00 00 00 
  800362:	b8 00 00 00 00       	mov    $0x0,%eax
  800367:	48 ba 79 09 80 00 00 	movabs $0x800979,%rdx
  80036e:	00 00 00 
  800371:	ff d2                	callq  *%rdx
		r = spawnl("/bin/sh", "sh", (char*)0);
  800373:	ba 00 00 00 00       	mov    $0x0,%edx
  800378:	48 be 3a 44 80 00 00 	movabs $0x80443a,%rsi
  80037f:	00 00 00 
  800382:	48 bf 3d 44 80 00 00 	movabs $0x80443d,%rdi
  800389:	00 00 00 
  80038c:	b8 00 00 00 00       	mov    $0x0,%eax
  800391:	48 b9 4e 32 80 00 00 	movabs $0x80324e,%rcx
  800398:	00 00 00 
  80039b:	ff d1                	callq  *%rcx
  80039d:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (r < 0) {
  8003a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8003a4:	79 23                	jns    8003c9 <umain+0x33c>
			cprintf("init: spawn sh: %e\n", r);
  8003a6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8003a9:	89 c6                	mov    %eax,%esi
  8003ab:	48 bf 45 44 80 00 00 	movabs $0x804445,%rdi
  8003b2:	00 00 00 
  8003b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ba:	48 ba 79 09 80 00 00 	movabs $0x800979,%rdx
  8003c1:	00 00 00 
  8003c4:	ff d2                	callq  *%rdx
			continue;
  8003c6:	90                   	nop
		}
		wait(r);
	}
  8003c7:	eb 8f                	jmp    800358 <umain+0x2cb>
		r = spawnl("/bin/sh", "sh", (char*)0);
		if (r < 0) {
			cprintf("init: spawn sh: %e\n", r);
			continue;
		}
		wait(r);
  8003c9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8003cc:	89 c7                	mov    %eax,%edi
  8003ce:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  8003d5:	00 00 00 
  8003d8:	ff d0                	callq  *%rax
	}
  8003da:	e9 79 ff ff ff       	jmpq   800358 <umain+0x2cb>

00000000008003df <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8003df:	55                   	push   %rbp
  8003e0:	48 89 e5             	mov    %rsp,%rbp
  8003e3:	48 83 ec 20          	sub    $0x20,%rsp
  8003e7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8003ea:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8003ed:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8003f0:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8003f4:	be 01 00 00 00       	mov    $0x1,%esi
  8003f9:	48 89 c7             	mov    %rax,%rdi
  8003fc:	48 b8 15 1d 80 00 00 	movabs $0x801d15,%rax
  800403:	00 00 00 
  800406:	ff d0                	callq  *%rax
}
  800408:	c9                   	leaveq 
  800409:	c3                   	retq   

000000000080040a <getchar>:

int
getchar(void)
{
  80040a:	55                   	push   %rbp
  80040b:	48 89 e5             	mov    %rsp,%rbp
  80040e:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  800412:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  800416:	ba 01 00 00 00       	mov    $0x1,%edx
  80041b:	48 89 c6             	mov    %rax,%rsi
  80041e:	bf 00 00 00 00       	mov    $0x0,%edi
  800423:	48 b8 e2 25 80 00 00 	movabs $0x8025e2,%rax
  80042a:	00 00 00 
  80042d:	ff d0                	callq  *%rax
  80042f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  800432:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800436:	79 05                	jns    80043d <getchar+0x33>
		return r;
  800438:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80043b:	eb 14                	jmp    800451 <getchar+0x47>
	if (r < 1)
  80043d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800441:	7f 07                	jg     80044a <getchar+0x40>
		return -E_EOF;
  800443:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  800448:	eb 07                	jmp    800451 <getchar+0x47>
	return c;
  80044a:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80044e:	0f b6 c0             	movzbl %al,%eax
}
  800451:	c9                   	leaveq 
  800452:	c3                   	retq   

0000000000800453 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  800453:	55                   	push   %rbp
  800454:	48 89 e5             	mov    %rsp,%rbp
  800457:	48 83 ec 20          	sub    $0x20,%rsp
  80045b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80045e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800462:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800465:	48 89 d6             	mov    %rdx,%rsi
  800468:	89 c7                	mov    %eax,%edi
  80046a:	48 b8 b0 21 80 00 00 	movabs $0x8021b0,%rax
  800471:	00 00 00 
  800474:	ff d0                	callq  *%rax
  800476:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800479:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80047d:	79 05                	jns    800484 <iscons+0x31>
		return r;
  80047f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800482:	eb 1a                	jmp    80049e <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  800484:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800488:	8b 10                	mov    (%rax),%edx
  80048a:	48 b8 80 77 80 00 00 	movabs $0x807780,%rax
  800491:	00 00 00 
  800494:	8b 00                	mov    (%rax),%eax
  800496:	39 c2                	cmp    %eax,%edx
  800498:	0f 94 c0             	sete   %al
  80049b:	0f b6 c0             	movzbl %al,%eax
}
  80049e:	c9                   	leaveq 
  80049f:	c3                   	retq   

00000000008004a0 <opencons>:

int
opencons(void)
{
  8004a0:	55                   	push   %rbp
  8004a1:	48 89 e5             	mov    %rsp,%rbp
  8004a4:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8004a8:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8004ac:	48 89 c7             	mov    %rax,%rdi
  8004af:	48 b8 18 21 80 00 00 	movabs $0x802118,%rax
  8004b6:	00 00 00 
  8004b9:	ff d0                	callq  *%rax
  8004bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8004be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004c2:	79 05                	jns    8004c9 <opencons+0x29>
		return r;
  8004c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004c7:	eb 5b                	jmp    800524 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8004c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004cd:	ba 07 04 00 00       	mov    $0x407,%edx
  8004d2:	48 89 c6             	mov    %rax,%rsi
  8004d5:	bf 00 00 00 00       	mov    $0x0,%edi
  8004da:	48 b8 5d 1e 80 00 00 	movabs $0x801e5d,%rax
  8004e1:	00 00 00 
  8004e4:	ff d0                	callq  *%rax
  8004e6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8004e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004ed:	79 05                	jns    8004f4 <opencons+0x54>
		return r;
  8004ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004f2:	eb 30                	jmp    800524 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8004f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004f8:	48 ba 80 77 80 00 00 	movabs $0x807780,%rdx
  8004ff:	00 00 00 
  800502:	8b 12                	mov    (%rdx),%edx
  800504:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  800506:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80050a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  800511:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800515:	48 89 c7             	mov    %rax,%rdi
  800518:	48 b8 ca 20 80 00 00 	movabs $0x8020ca,%rax
  80051f:	00 00 00 
  800522:	ff d0                	callq  *%rax
}
  800524:	c9                   	leaveq 
  800525:	c3                   	retq   

0000000000800526 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  800526:	55                   	push   %rbp
  800527:	48 89 e5             	mov    %rsp,%rbp
  80052a:	48 83 ec 30          	sub    $0x30,%rsp
  80052e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800532:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800536:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80053a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80053f:	75 07                	jne    800548 <devcons_read+0x22>
		return 0;
  800541:	b8 00 00 00 00       	mov    $0x0,%eax
  800546:	eb 4b                	jmp    800593 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  800548:	eb 0c                	jmp    800556 <devcons_read+0x30>
		sys_yield();
  80054a:	48 b8 1f 1e 80 00 00 	movabs $0x801e1f,%rax
  800551:	00 00 00 
  800554:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  800556:	48 b8 5f 1d 80 00 00 	movabs $0x801d5f,%rax
  80055d:	00 00 00 
  800560:	ff d0                	callq  *%rax
  800562:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800565:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800569:	74 df                	je     80054a <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  80056b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80056f:	79 05                	jns    800576 <devcons_read+0x50>
		return c;
  800571:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800574:	eb 1d                	jmp    800593 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  800576:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80057a:	75 07                	jne    800583 <devcons_read+0x5d>
		return 0;
  80057c:	b8 00 00 00 00       	mov    $0x0,%eax
  800581:	eb 10                	jmp    800593 <devcons_read+0x6d>
	*(char*)vbuf = c;
  800583:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800586:	89 c2                	mov    %eax,%edx
  800588:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80058c:	88 10                	mov    %dl,(%rax)
	return 1;
  80058e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800593:	c9                   	leaveq 
  800594:	c3                   	retq   

0000000000800595 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800595:	55                   	push   %rbp
  800596:	48 89 e5             	mov    %rsp,%rbp
  800599:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8005a0:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8005a7:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8005ae:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8005b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8005bc:	eb 76                	jmp    800634 <devcons_write+0x9f>
		m = n - tot;
  8005be:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8005c5:	89 c2                	mov    %eax,%edx
  8005c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005ca:	29 c2                	sub    %eax,%edx
  8005cc:	89 d0                	mov    %edx,%eax
  8005ce:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8005d1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8005d4:	83 f8 7f             	cmp    $0x7f,%eax
  8005d7:	76 07                	jbe    8005e0 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8005d9:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8005e0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8005e3:	48 63 d0             	movslq %eax,%rdx
  8005e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005e9:	48 63 c8             	movslq %eax,%rcx
  8005ec:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8005f3:	48 01 c1             	add    %rax,%rcx
  8005f6:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8005fd:	48 89 ce             	mov    %rcx,%rsi
  800600:	48 89 c7             	mov    %rax,%rdi
  800603:	48 b8 52 18 80 00 00 	movabs $0x801852,%rax
  80060a:	00 00 00 
  80060d:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80060f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800612:	48 63 d0             	movslq %eax,%rdx
  800615:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80061c:	48 89 d6             	mov    %rdx,%rsi
  80061f:	48 89 c7             	mov    %rax,%rdi
  800622:	48 b8 15 1d 80 00 00 	movabs $0x801d15,%rax
  800629:	00 00 00 
  80062c:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80062e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800631:	01 45 fc             	add    %eax,-0x4(%rbp)
  800634:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800637:	48 98                	cltq   
  800639:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  800640:	0f 82 78 ff ff ff    	jb     8005be <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  800646:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800649:	c9                   	leaveq 
  80064a:	c3                   	retq   

000000000080064b <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80064b:	55                   	push   %rbp
  80064c:	48 89 e5             	mov    %rsp,%rbp
  80064f:	48 83 ec 08          	sub    $0x8,%rsp
  800653:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  800657:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80065c:	c9                   	leaveq 
  80065d:	c3                   	retq   

000000000080065e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80065e:	55                   	push   %rbp
  80065f:	48 89 e5             	mov    %rsp,%rbp
  800662:	48 83 ec 10          	sub    $0x10,%rsp
  800666:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80066a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80066e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800672:	48 be 5e 44 80 00 00 	movabs $0x80445e,%rsi
  800679:	00 00 00 
  80067c:	48 89 c7             	mov    %rax,%rdi
  80067f:	48 b8 2e 15 80 00 00 	movabs $0x80152e,%rax
  800686:	00 00 00 
  800689:	ff d0                	callq  *%rax
	return 0;
  80068b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800690:	c9                   	leaveq 
  800691:	c3                   	retq   

0000000000800692 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800692:	55                   	push   %rbp
  800693:	48 89 e5             	mov    %rsp,%rbp
  800696:	48 83 ec 10          	sub    $0x10,%rsp
  80069a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80069d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8006a1:	48 b8 e1 1d 80 00 00 	movabs $0x801de1,%rax
  8006a8:	00 00 00 
  8006ab:	ff d0                	callq  *%rax
  8006ad:	25 ff 03 00 00       	and    $0x3ff,%eax
  8006b2:	48 63 d0             	movslq %eax,%rdx
  8006b5:	48 89 d0             	mov    %rdx,%rax
  8006b8:	48 c1 e0 03          	shl    $0x3,%rax
  8006bc:	48 01 d0             	add    %rdx,%rax
  8006bf:	48 c1 e0 05          	shl    $0x5,%rax
  8006c3:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8006ca:	00 00 00 
  8006cd:	48 01 c2             	add    %rax,%rdx
  8006d0:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  8006d7:	00 00 00 
  8006da:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8006e1:	7e 14                	jle    8006f7 <libmain+0x65>
		binaryname = argv[0];
  8006e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006e7:	48 8b 10             	mov    (%rax),%rdx
  8006ea:	48 b8 b8 77 80 00 00 	movabs $0x8077b8,%rax
  8006f1:	00 00 00 
  8006f4:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8006f7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8006fe:	48 89 d6             	mov    %rdx,%rsi
  800701:	89 c7                	mov    %eax,%edi
  800703:	48 b8 8d 00 80 00 00 	movabs $0x80008d,%rax
  80070a:	00 00 00 
  80070d:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  80070f:	48 b8 1d 07 80 00 00 	movabs $0x80071d,%rax
  800716:	00 00 00 
  800719:	ff d0                	callq  *%rax
}
  80071b:	c9                   	leaveq 
  80071c:	c3                   	retq   

000000000080071d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80071d:	55                   	push   %rbp
  80071e:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800721:	48 b8 0b 24 80 00 00 	movabs $0x80240b,%rax
  800728:	00 00 00 
  80072b:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80072d:	bf 00 00 00 00       	mov    $0x0,%edi
  800732:	48 b8 9d 1d 80 00 00 	movabs $0x801d9d,%rax
  800739:	00 00 00 
  80073c:	ff d0                	callq  *%rax

}
  80073e:	5d                   	pop    %rbp
  80073f:	c3                   	retq   

0000000000800740 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800740:	55                   	push   %rbp
  800741:	48 89 e5             	mov    %rsp,%rbp
  800744:	53                   	push   %rbx
  800745:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80074c:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800753:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800759:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800760:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800767:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80076e:	84 c0                	test   %al,%al
  800770:	74 23                	je     800795 <_panic+0x55>
  800772:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800779:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80077d:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800781:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800785:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800789:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80078d:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800791:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800795:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80079c:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8007a3:	00 00 00 
  8007a6:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8007ad:	00 00 00 
  8007b0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007b4:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8007bb:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8007c2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8007c9:	48 b8 b8 77 80 00 00 	movabs $0x8077b8,%rax
  8007d0:	00 00 00 
  8007d3:	48 8b 18             	mov    (%rax),%rbx
  8007d6:	48 b8 e1 1d 80 00 00 	movabs $0x801de1,%rax
  8007dd:	00 00 00 
  8007e0:	ff d0                	callq  *%rax
  8007e2:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8007e8:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8007ef:	41 89 c8             	mov    %ecx,%r8d
  8007f2:	48 89 d1             	mov    %rdx,%rcx
  8007f5:	48 89 da             	mov    %rbx,%rdx
  8007f8:	89 c6                	mov    %eax,%esi
  8007fa:	48 bf 70 44 80 00 00 	movabs $0x804470,%rdi
  800801:	00 00 00 
  800804:	b8 00 00 00 00       	mov    $0x0,%eax
  800809:	49 b9 79 09 80 00 00 	movabs $0x800979,%r9
  800810:	00 00 00 
  800813:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800816:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80081d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800824:	48 89 d6             	mov    %rdx,%rsi
  800827:	48 89 c7             	mov    %rax,%rdi
  80082a:	48 b8 cd 08 80 00 00 	movabs $0x8008cd,%rax
  800831:	00 00 00 
  800834:	ff d0                	callq  *%rax
	cprintf("\n");
  800836:	48 bf 93 44 80 00 00 	movabs $0x804493,%rdi
  80083d:	00 00 00 
  800840:	b8 00 00 00 00       	mov    $0x0,%eax
  800845:	48 ba 79 09 80 00 00 	movabs $0x800979,%rdx
  80084c:	00 00 00 
  80084f:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800851:	cc                   	int3   
  800852:	eb fd                	jmp    800851 <_panic+0x111>

0000000000800854 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800854:	55                   	push   %rbp
  800855:	48 89 e5             	mov    %rsp,%rbp
  800858:	48 83 ec 10          	sub    $0x10,%rsp
  80085c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80085f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800863:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800867:	8b 00                	mov    (%rax),%eax
  800869:	8d 48 01             	lea    0x1(%rax),%ecx
  80086c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800870:	89 0a                	mov    %ecx,(%rdx)
  800872:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800875:	89 d1                	mov    %edx,%ecx
  800877:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80087b:	48 98                	cltq   
  80087d:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  800881:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800885:	8b 00                	mov    (%rax),%eax
  800887:	3d ff 00 00 00       	cmp    $0xff,%eax
  80088c:	75 2c                	jne    8008ba <putch+0x66>
		sys_cputs(b->buf, b->idx);
  80088e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800892:	8b 00                	mov    (%rax),%eax
  800894:	48 98                	cltq   
  800896:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80089a:	48 83 c2 08          	add    $0x8,%rdx
  80089e:	48 89 c6             	mov    %rax,%rsi
  8008a1:	48 89 d7             	mov    %rdx,%rdi
  8008a4:	48 b8 15 1d 80 00 00 	movabs $0x801d15,%rax
  8008ab:	00 00 00 
  8008ae:	ff d0                	callq  *%rax
		b->idx = 0;
  8008b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008b4:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  8008ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008be:	8b 40 04             	mov    0x4(%rax),%eax
  8008c1:	8d 50 01             	lea    0x1(%rax),%edx
  8008c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008c8:	89 50 04             	mov    %edx,0x4(%rax)
}
  8008cb:	c9                   	leaveq 
  8008cc:	c3                   	retq   

00000000008008cd <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8008cd:	55                   	push   %rbp
  8008ce:	48 89 e5             	mov    %rsp,%rbp
  8008d1:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8008d8:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8008df:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8008e6:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8008ed:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8008f4:	48 8b 0a             	mov    (%rdx),%rcx
  8008f7:	48 89 08             	mov    %rcx,(%rax)
  8008fa:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8008fe:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800902:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800906:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  80090a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800911:	00 00 00 
	b.cnt = 0;
  800914:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80091b:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  80091e:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800925:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80092c:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800933:	48 89 c6             	mov    %rax,%rsi
  800936:	48 bf 54 08 80 00 00 	movabs $0x800854,%rdi
  80093d:	00 00 00 
  800940:	48 b8 2c 0d 80 00 00 	movabs $0x800d2c,%rax
  800947:	00 00 00 
  80094a:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  80094c:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800952:	48 98                	cltq   
  800954:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80095b:	48 83 c2 08          	add    $0x8,%rdx
  80095f:	48 89 c6             	mov    %rax,%rsi
  800962:	48 89 d7             	mov    %rdx,%rdi
  800965:	48 b8 15 1d 80 00 00 	movabs $0x801d15,%rax
  80096c:	00 00 00 
  80096f:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  800971:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800977:	c9                   	leaveq 
  800978:	c3                   	retq   

0000000000800979 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800979:	55                   	push   %rbp
  80097a:	48 89 e5             	mov    %rsp,%rbp
  80097d:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800984:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80098b:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800992:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800999:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8009a0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8009a7:	84 c0                	test   %al,%al
  8009a9:	74 20                	je     8009cb <cprintf+0x52>
  8009ab:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8009af:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8009b3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8009b7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8009bb:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8009bf:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8009c3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8009c7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8009cb:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  8009d2:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8009d9:	00 00 00 
  8009dc:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8009e3:	00 00 00 
  8009e6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8009ea:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8009f1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8009f8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8009ff:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800a06:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800a0d:	48 8b 0a             	mov    (%rdx),%rcx
  800a10:	48 89 08             	mov    %rcx,(%rax)
  800a13:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a17:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a1b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a1f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  800a23:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800a2a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800a31:	48 89 d6             	mov    %rdx,%rsi
  800a34:	48 89 c7             	mov    %rax,%rdi
  800a37:	48 b8 cd 08 80 00 00 	movabs $0x8008cd,%rax
  800a3e:	00 00 00 
  800a41:	ff d0                	callq  *%rax
  800a43:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800a49:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800a4f:	c9                   	leaveq 
  800a50:	c3                   	retq   

0000000000800a51 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a51:	55                   	push   %rbp
  800a52:	48 89 e5             	mov    %rsp,%rbp
  800a55:	53                   	push   %rbx
  800a56:	48 83 ec 38          	sub    $0x38,%rsp
  800a5a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a5e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800a62:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800a66:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800a69:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800a6d:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a71:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800a74:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800a78:	77 3b                	ja     800ab5 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a7a:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800a7d:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800a81:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800a84:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a88:	ba 00 00 00 00       	mov    $0x0,%edx
  800a8d:	48 f7 f3             	div    %rbx
  800a90:	48 89 c2             	mov    %rax,%rdx
  800a93:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800a96:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800a99:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800a9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aa1:	41 89 f9             	mov    %edi,%r9d
  800aa4:	48 89 c7             	mov    %rax,%rdi
  800aa7:	48 b8 51 0a 80 00 00 	movabs $0x800a51,%rax
  800aae:	00 00 00 
  800ab1:	ff d0                	callq  *%rax
  800ab3:	eb 1e                	jmp    800ad3 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ab5:	eb 12                	jmp    800ac9 <printnum+0x78>
			putch(padc, putdat);
  800ab7:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800abb:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800abe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac2:	48 89 ce             	mov    %rcx,%rsi
  800ac5:	89 d7                	mov    %edx,%edi
  800ac7:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ac9:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800acd:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800ad1:	7f e4                	jg     800ab7 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800ad3:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800ad6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800ada:	ba 00 00 00 00       	mov    $0x0,%edx
  800adf:	48 f7 f1             	div    %rcx
  800ae2:	48 89 d0             	mov    %rdx,%rax
  800ae5:	48 ba 68 46 80 00 00 	movabs $0x804668,%rdx
  800aec:	00 00 00 
  800aef:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800af3:	0f be d0             	movsbl %al,%edx
  800af6:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800afa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800afe:	48 89 ce             	mov    %rcx,%rsi
  800b01:	89 d7                	mov    %edx,%edi
  800b03:	ff d0                	callq  *%rax
}
  800b05:	48 83 c4 38          	add    $0x38,%rsp
  800b09:	5b                   	pop    %rbx
  800b0a:	5d                   	pop    %rbp
  800b0b:	c3                   	retq   

0000000000800b0c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b0c:	55                   	push   %rbp
  800b0d:	48 89 e5             	mov    %rsp,%rbp
  800b10:	48 83 ec 1c          	sub    $0x1c,%rsp
  800b14:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800b18:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800b1b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800b1f:	7e 52                	jle    800b73 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800b21:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b25:	8b 00                	mov    (%rax),%eax
  800b27:	83 f8 30             	cmp    $0x30,%eax
  800b2a:	73 24                	jae    800b50 <getuint+0x44>
  800b2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b30:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b38:	8b 00                	mov    (%rax),%eax
  800b3a:	89 c0                	mov    %eax,%eax
  800b3c:	48 01 d0             	add    %rdx,%rax
  800b3f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b43:	8b 12                	mov    (%rdx),%edx
  800b45:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b48:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b4c:	89 0a                	mov    %ecx,(%rdx)
  800b4e:	eb 17                	jmp    800b67 <getuint+0x5b>
  800b50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b54:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b58:	48 89 d0             	mov    %rdx,%rax
  800b5b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b5f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b63:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b67:	48 8b 00             	mov    (%rax),%rax
  800b6a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b6e:	e9 a3 00 00 00       	jmpq   800c16 <getuint+0x10a>
	else if (lflag)
  800b73:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800b77:	74 4f                	je     800bc8 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800b79:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b7d:	8b 00                	mov    (%rax),%eax
  800b7f:	83 f8 30             	cmp    $0x30,%eax
  800b82:	73 24                	jae    800ba8 <getuint+0x9c>
  800b84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b88:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b90:	8b 00                	mov    (%rax),%eax
  800b92:	89 c0                	mov    %eax,%eax
  800b94:	48 01 d0             	add    %rdx,%rax
  800b97:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b9b:	8b 12                	mov    (%rdx),%edx
  800b9d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ba0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ba4:	89 0a                	mov    %ecx,(%rdx)
  800ba6:	eb 17                	jmp    800bbf <getuint+0xb3>
  800ba8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bac:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800bb0:	48 89 d0             	mov    %rdx,%rax
  800bb3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800bb7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bbb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800bbf:	48 8b 00             	mov    (%rax),%rax
  800bc2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800bc6:	eb 4e                	jmp    800c16 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800bc8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bcc:	8b 00                	mov    (%rax),%eax
  800bce:	83 f8 30             	cmp    $0x30,%eax
  800bd1:	73 24                	jae    800bf7 <getuint+0xeb>
  800bd3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bd7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800bdb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bdf:	8b 00                	mov    (%rax),%eax
  800be1:	89 c0                	mov    %eax,%eax
  800be3:	48 01 d0             	add    %rdx,%rax
  800be6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bea:	8b 12                	mov    (%rdx),%edx
  800bec:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800bef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bf3:	89 0a                	mov    %ecx,(%rdx)
  800bf5:	eb 17                	jmp    800c0e <getuint+0x102>
  800bf7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bfb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800bff:	48 89 d0             	mov    %rdx,%rax
  800c02:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800c06:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c0a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800c0e:	8b 00                	mov    (%rax),%eax
  800c10:	89 c0                	mov    %eax,%eax
  800c12:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800c16:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800c1a:	c9                   	leaveq 
  800c1b:	c3                   	retq   

0000000000800c1c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c1c:	55                   	push   %rbp
  800c1d:	48 89 e5             	mov    %rsp,%rbp
  800c20:	48 83 ec 1c          	sub    $0x1c,%rsp
  800c24:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800c28:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800c2b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800c2f:	7e 52                	jle    800c83 <getint+0x67>
		x=va_arg(*ap, long long);
  800c31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c35:	8b 00                	mov    (%rax),%eax
  800c37:	83 f8 30             	cmp    $0x30,%eax
  800c3a:	73 24                	jae    800c60 <getint+0x44>
  800c3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c40:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800c44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c48:	8b 00                	mov    (%rax),%eax
  800c4a:	89 c0                	mov    %eax,%eax
  800c4c:	48 01 d0             	add    %rdx,%rax
  800c4f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c53:	8b 12                	mov    (%rdx),%edx
  800c55:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800c58:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c5c:	89 0a                	mov    %ecx,(%rdx)
  800c5e:	eb 17                	jmp    800c77 <getint+0x5b>
  800c60:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c64:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800c68:	48 89 d0             	mov    %rdx,%rax
  800c6b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800c6f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c73:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800c77:	48 8b 00             	mov    (%rax),%rax
  800c7a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800c7e:	e9 a3 00 00 00       	jmpq   800d26 <getint+0x10a>
	else if (lflag)
  800c83:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800c87:	74 4f                	je     800cd8 <getint+0xbc>
		x=va_arg(*ap, long);
  800c89:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c8d:	8b 00                	mov    (%rax),%eax
  800c8f:	83 f8 30             	cmp    $0x30,%eax
  800c92:	73 24                	jae    800cb8 <getint+0x9c>
  800c94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c98:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800c9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ca0:	8b 00                	mov    (%rax),%eax
  800ca2:	89 c0                	mov    %eax,%eax
  800ca4:	48 01 d0             	add    %rdx,%rax
  800ca7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cab:	8b 12                	mov    (%rdx),%edx
  800cad:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800cb0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cb4:	89 0a                	mov    %ecx,(%rdx)
  800cb6:	eb 17                	jmp    800ccf <getint+0xb3>
  800cb8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cbc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800cc0:	48 89 d0             	mov    %rdx,%rax
  800cc3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800cc7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ccb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ccf:	48 8b 00             	mov    (%rax),%rax
  800cd2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800cd6:	eb 4e                	jmp    800d26 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800cd8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cdc:	8b 00                	mov    (%rax),%eax
  800cde:	83 f8 30             	cmp    $0x30,%eax
  800ce1:	73 24                	jae    800d07 <getint+0xeb>
  800ce3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ce7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ceb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cef:	8b 00                	mov    (%rax),%eax
  800cf1:	89 c0                	mov    %eax,%eax
  800cf3:	48 01 d0             	add    %rdx,%rax
  800cf6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cfa:	8b 12                	mov    (%rdx),%edx
  800cfc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800cff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d03:	89 0a                	mov    %ecx,(%rdx)
  800d05:	eb 17                	jmp    800d1e <getint+0x102>
  800d07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d0b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800d0f:	48 89 d0             	mov    %rdx,%rax
  800d12:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800d16:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d1a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800d1e:	8b 00                	mov    (%rax),%eax
  800d20:	48 98                	cltq   
  800d22:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800d26:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800d2a:	c9                   	leaveq 
  800d2b:	c3                   	retq   

0000000000800d2c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d2c:	55                   	push   %rbp
  800d2d:	48 89 e5             	mov    %rsp,%rbp
  800d30:	41 54                	push   %r12
  800d32:	53                   	push   %rbx
  800d33:	48 83 ec 60          	sub    $0x60,%rsp
  800d37:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800d3b:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800d3f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800d43:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800d47:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d4b:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800d4f:	48 8b 0a             	mov    (%rdx),%rcx
  800d52:	48 89 08             	mov    %rcx,(%rax)
  800d55:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d59:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d5d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d61:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d65:	eb 17                	jmp    800d7e <vprintfmt+0x52>
			if (ch == '\0')
  800d67:	85 db                	test   %ebx,%ebx
  800d69:	0f 84 cc 04 00 00    	je     80123b <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800d6f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d73:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d77:	48 89 d6             	mov    %rdx,%rsi
  800d7a:	89 df                	mov    %ebx,%edi
  800d7c:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d7e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d82:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800d86:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800d8a:	0f b6 00             	movzbl (%rax),%eax
  800d8d:	0f b6 d8             	movzbl %al,%ebx
  800d90:	83 fb 25             	cmp    $0x25,%ebx
  800d93:	75 d2                	jne    800d67 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d95:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800d99:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800da0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800da7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800dae:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800db5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800db9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800dbd:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800dc1:	0f b6 00             	movzbl (%rax),%eax
  800dc4:	0f b6 d8             	movzbl %al,%ebx
  800dc7:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800dca:	83 f8 55             	cmp    $0x55,%eax
  800dcd:	0f 87 34 04 00 00    	ja     801207 <vprintfmt+0x4db>
  800dd3:	89 c0                	mov    %eax,%eax
  800dd5:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800ddc:	00 
  800ddd:	48 b8 90 46 80 00 00 	movabs $0x804690,%rax
  800de4:	00 00 00 
  800de7:	48 01 d0             	add    %rdx,%rax
  800dea:	48 8b 00             	mov    (%rax),%rax
  800ded:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800def:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800df3:	eb c0                	jmp    800db5 <vprintfmt+0x89>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800df5:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800df9:	eb ba                	jmp    800db5 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800dfb:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800e02:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800e05:	89 d0                	mov    %edx,%eax
  800e07:	c1 e0 02             	shl    $0x2,%eax
  800e0a:	01 d0                	add    %edx,%eax
  800e0c:	01 c0                	add    %eax,%eax
  800e0e:	01 d8                	add    %ebx,%eax
  800e10:	83 e8 30             	sub    $0x30,%eax
  800e13:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800e16:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800e1a:	0f b6 00             	movzbl (%rax),%eax
  800e1d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e20:	83 fb 2f             	cmp    $0x2f,%ebx
  800e23:	7e 0c                	jle    800e31 <vprintfmt+0x105>
  800e25:	83 fb 39             	cmp    $0x39,%ebx
  800e28:	7f 07                	jg     800e31 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e2a:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e2f:	eb d1                	jmp    800e02 <vprintfmt+0xd6>
			goto process_precision;
  800e31:	eb 58                	jmp    800e8b <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800e33:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e36:	83 f8 30             	cmp    $0x30,%eax
  800e39:	73 17                	jae    800e52 <vprintfmt+0x126>
  800e3b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e3f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e42:	89 c0                	mov    %eax,%eax
  800e44:	48 01 d0             	add    %rdx,%rax
  800e47:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e4a:	83 c2 08             	add    $0x8,%edx
  800e4d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e50:	eb 0f                	jmp    800e61 <vprintfmt+0x135>
  800e52:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e56:	48 89 d0             	mov    %rdx,%rax
  800e59:	48 83 c2 08          	add    $0x8,%rdx
  800e5d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e61:	8b 00                	mov    (%rax),%eax
  800e63:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800e66:	eb 23                	jmp    800e8b <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800e68:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e6c:	79 0c                	jns    800e7a <vprintfmt+0x14e>
				width = 0;
  800e6e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800e75:	e9 3b ff ff ff       	jmpq   800db5 <vprintfmt+0x89>
  800e7a:	e9 36 ff ff ff       	jmpq   800db5 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800e7f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800e86:	e9 2a ff ff ff       	jmpq   800db5 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800e8b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e8f:	79 12                	jns    800ea3 <vprintfmt+0x177>
				width = precision, precision = -1;
  800e91:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800e94:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800e97:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800e9e:	e9 12 ff ff ff       	jmpq   800db5 <vprintfmt+0x89>
  800ea3:	e9 0d ff ff ff       	jmpq   800db5 <vprintfmt+0x89>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ea8:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800eac:	e9 04 ff ff ff       	jmpq   800db5 <vprintfmt+0x89>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800eb1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800eb4:	83 f8 30             	cmp    $0x30,%eax
  800eb7:	73 17                	jae    800ed0 <vprintfmt+0x1a4>
  800eb9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ebd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ec0:	89 c0                	mov    %eax,%eax
  800ec2:	48 01 d0             	add    %rdx,%rax
  800ec5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ec8:	83 c2 08             	add    $0x8,%edx
  800ecb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ece:	eb 0f                	jmp    800edf <vprintfmt+0x1b3>
  800ed0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ed4:	48 89 d0             	mov    %rdx,%rax
  800ed7:	48 83 c2 08          	add    $0x8,%rdx
  800edb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800edf:	8b 10                	mov    (%rax),%edx
  800ee1:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800ee5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ee9:	48 89 ce             	mov    %rcx,%rsi
  800eec:	89 d7                	mov    %edx,%edi
  800eee:	ff d0                	callq  *%rax
			break;
  800ef0:	e9 40 03 00 00       	jmpq   801235 <vprintfmt+0x509>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800ef5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ef8:	83 f8 30             	cmp    $0x30,%eax
  800efb:	73 17                	jae    800f14 <vprintfmt+0x1e8>
  800efd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800f01:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f04:	89 c0                	mov    %eax,%eax
  800f06:	48 01 d0             	add    %rdx,%rax
  800f09:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f0c:	83 c2 08             	add    $0x8,%edx
  800f0f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800f12:	eb 0f                	jmp    800f23 <vprintfmt+0x1f7>
  800f14:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f18:	48 89 d0             	mov    %rdx,%rax
  800f1b:	48 83 c2 08          	add    $0x8,%rdx
  800f1f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f23:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800f25:	85 db                	test   %ebx,%ebx
  800f27:	79 02                	jns    800f2b <vprintfmt+0x1ff>
				err = -err;
  800f29:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800f2b:	83 fb 10             	cmp    $0x10,%ebx
  800f2e:	7f 16                	jg     800f46 <vprintfmt+0x21a>
  800f30:	48 b8 e0 45 80 00 00 	movabs $0x8045e0,%rax
  800f37:	00 00 00 
  800f3a:	48 63 d3             	movslq %ebx,%rdx
  800f3d:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800f41:	4d 85 e4             	test   %r12,%r12
  800f44:	75 2e                	jne    800f74 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800f46:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f4a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f4e:	89 d9                	mov    %ebx,%ecx
  800f50:	48 ba 79 46 80 00 00 	movabs $0x804679,%rdx
  800f57:	00 00 00 
  800f5a:	48 89 c7             	mov    %rax,%rdi
  800f5d:	b8 00 00 00 00       	mov    $0x0,%eax
  800f62:	49 b8 44 12 80 00 00 	movabs $0x801244,%r8
  800f69:	00 00 00 
  800f6c:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f6f:	e9 c1 02 00 00       	jmpq   801235 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f74:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f78:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f7c:	4c 89 e1             	mov    %r12,%rcx
  800f7f:	48 ba 82 46 80 00 00 	movabs $0x804682,%rdx
  800f86:	00 00 00 
  800f89:	48 89 c7             	mov    %rax,%rdi
  800f8c:	b8 00 00 00 00       	mov    $0x0,%eax
  800f91:	49 b8 44 12 80 00 00 	movabs $0x801244,%r8
  800f98:	00 00 00 
  800f9b:	41 ff d0             	callq  *%r8
			break;
  800f9e:	e9 92 02 00 00       	jmpq   801235 <vprintfmt+0x509>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800fa3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800fa6:	83 f8 30             	cmp    $0x30,%eax
  800fa9:	73 17                	jae    800fc2 <vprintfmt+0x296>
  800fab:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800faf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800fb2:	89 c0                	mov    %eax,%eax
  800fb4:	48 01 d0             	add    %rdx,%rax
  800fb7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800fba:	83 c2 08             	add    $0x8,%edx
  800fbd:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800fc0:	eb 0f                	jmp    800fd1 <vprintfmt+0x2a5>
  800fc2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800fc6:	48 89 d0             	mov    %rdx,%rax
  800fc9:	48 83 c2 08          	add    $0x8,%rdx
  800fcd:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800fd1:	4c 8b 20             	mov    (%rax),%r12
  800fd4:	4d 85 e4             	test   %r12,%r12
  800fd7:	75 0a                	jne    800fe3 <vprintfmt+0x2b7>
				p = "(null)";
  800fd9:	49 bc 85 46 80 00 00 	movabs $0x804685,%r12
  800fe0:	00 00 00 
			if (width > 0 && padc != '-')
  800fe3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800fe7:	7e 3f                	jle    801028 <vprintfmt+0x2fc>
  800fe9:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800fed:	74 39                	je     801028 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800fef:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ff2:	48 98                	cltq   
  800ff4:	48 89 c6             	mov    %rax,%rsi
  800ff7:	4c 89 e7             	mov    %r12,%rdi
  800ffa:	48 b8 f0 14 80 00 00 	movabs $0x8014f0,%rax
  801001:	00 00 00 
  801004:	ff d0                	callq  *%rax
  801006:	29 45 dc             	sub    %eax,-0x24(%rbp)
  801009:	eb 17                	jmp    801022 <vprintfmt+0x2f6>
					putch(padc, putdat);
  80100b:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  80100f:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  801013:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801017:	48 89 ce             	mov    %rcx,%rsi
  80101a:	89 d7                	mov    %edx,%edi
  80101c:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80101e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801022:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801026:	7f e3                	jg     80100b <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801028:	eb 37                	jmp    801061 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  80102a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80102e:	74 1e                	je     80104e <vprintfmt+0x322>
  801030:	83 fb 1f             	cmp    $0x1f,%ebx
  801033:	7e 05                	jle    80103a <vprintfmt+0x30e>
  801035:	83 fb 7e             	cmp    $0x7e,%ebx
  801038:	7e 14                	jle    80104e <vprintfmt+0x322>
					putch('?', putdat);
  80103a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80103e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801042:	48 89 d6             	mov    %rdx,%rsi
  801045:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80104a:	ff d0                	callq  *%rax
  80104c:	eb 0f                	jmp    80105d <vprintfmt+0x331>
				else
					putch(ch, putdat);
  80104e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801052:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801056:	48 89 d6             	mov    %rdx,%rsi
  801059:	89 df                	mov    %ebx,%edi
  80105b:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80105d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801061:	4c 89 e0             	mov    %r12,%rax
  801064:	4c 8d 60 01          	lea    0x1(%rax),%r12
  801068:	0f b6 00             	movzbl (%rax),%eax
  80106b:	0f be d8             	movsbl %al,%ebx
  80106e:	85 db                	test   %ebx,%ebx
  801070:	74 10                	je     801082 <vprintfmt+0x356>
  801072:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801076:	78 b2                	js     80102a <vprintfmt+0x2fe>
  801078:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80107c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801080:	79 a8                	jns    80102a <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801082:	eb 16                	jmp    80109a <vprintfmt+0x36e>
				putch(' ', putdat);
  801084:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801088:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80108c:	48 89 d6             	mov    %rdx,%rsi
  80108f:	bf 20 00 00 00       	mov    $0x20,%edi
  801094:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801096:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80109a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80109e:	7f e4                	jg     801084 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  8010a0:	e9 90 01 00 00       	jmpq   801235 <vprintfmt+0x509>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  8010a5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8010a9:	be 03 00 00 00       	mov    $0x3,%esi
  8010ae:	48 89 c7             	mov    %rax,%rdi
  8010b1:	48 b8 1c 0c 80 00 00 	movabs $0x800c1c,%rax
  8010b8:	00 00 00 
  8010bb:	ff d0                	callq  *%rax
  8010bd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8010c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010c5:	48 85 c0             	test   %rax,%rax
  8010c8:	79 1d                	jns    8010e7 <vprintfmt+0x3bb>
				putch('-', putdat);
  8010ca:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010ce:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010d2:	48 89 d6             	mov    %rdx,%rsi
  8010d5:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8010da:	ff d0                	callq  *%rax
				num = -(long long) num;
  8010dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010e0:	48 f7 d8             	neg    %rax
  8010e3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8010e7:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8010ee:	e9 d5 00 00 00       	jmpq   8011c8 <vprintfmt+0x49c>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8010f3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8010f7:	be 03 00 00 00       	mov    $0x3,%esi
  8010fc:	48 89 c7             	mov    %rax,%rdi
  8010ff:	48 b8 0c 0b 80 00 00 	movabs $0x800b0c,%rax
  801106:	00 00 00 
  801109:	ff d0                	callq  *%rax
  80110b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  80110f:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801116:	e9 ad 00 00 00       	jmpq   8011c8 <vprintfmt+0x49c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  80111b:	8b 55 e0             	mov    -0x20(%rbp),%edx
  80111e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801122:	89 d6                	mov    %edx,%esi
  801124:	48 89 c7             	mov    %rax,%rdi
  801127:	48 b8 1c 0c 80 00 00 	movabs $0x800c1c,%rax
  80112e:	00 00 00 
  801131:	ff d0                	callq  *%rax
  801133:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  801137:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  80113e:	e9 85 00 00 00       	jmpq   8011c8 <vprintfmt+0x49c>


		// pointer
		case 'p':
			putch('0', putdat);
  801143:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801147:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80114b:	48 89 d6             	mov    %rdx,%rsi
  80114e:	bf 30 00 00 00       	mov    $0x30,%edi
  801153:	ff d0                	callq  *%rax
			putch('x', putdat);
  801155:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801159:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80115d:	48 89 d6             	mov    %rdx,%rsi
  801160:	bf 78 00 00 00       	mov    $0x78,%edi
  801165:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801167:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80116a:	83 f8 30             	cmp    $0x30,%eax
  80116d:	73 17                	jae    801186 <vprintfmt+0x45a>
  80116f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801173:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801176:	89 c0                	mov    %eax,%eax
  801178:	48 01 d0             	add    %rdx,%rax
  80117b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80117e:	83 c2 08             	add    $0x8,%edx
  801181:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801184:	eb 0f                	jmp    801195 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  801186:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80118a:	48 89 d0             	mov    %rdx,%rax
  80118d:	48 83 c2 08          	add    $0x8,%rdx
  801191:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801195:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801198:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  80119c:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  8011a3:	eb 23                	jmp    8011c8 <vprintfmt+0x49c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  8011a5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8011a9:	be 03 00 00 00       	mov    $0x3,%esi
  8011ae:	48 89 c7             	mov    %rax,%rdi
  8011b1:	48 b8 0c 0b 80 00 00 	movabs $0x800b0c,%rax
  8011b8:	00 00 00 
  8011bb:	ff d0                	callq  *%rax
  8011bd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8011c1:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8011c8:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8011cd:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8011d0:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8011d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011d7:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8011db:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011df:	45 89 c1             	mov    %r8d,%r9d
  8011e2:	41 89 f8             	mov    %edi,%r8d
  8011e5:	48 89 c7             	mov    %rax,%rdi
  8011e8:	48 b8 51 0a 80 00 00 	movabs $0x800a51,%rax
  8011ef:	00 00 00 
  8011f2:	ff d0                	callq  *%rax
			break;
  8011f4:	eb 3f                	jmp    801235 <vprintfmt+0x509>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8011f6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8011fa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011fe:	48 89 d6             	mov    %rdx,%rsi
  801201:	89 df                	mov    %ebx,%edi
  801203:	ff d0                	callq  *%rax
			break;
  801205:	eb 2e                	jmp    801235 <vprintfmt+0x509>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801207:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80120b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80120f:	48 89 d6             	mov    %rdx,%rsi
  801212:	bf 25 00 00 00       	mov    $0x25,%edi
  801217:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  801219:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80121e:	eb 05                	jmp    801225 <vprintfmt+0x4f9>
  801220:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801225:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801229:	48 83 e8 01          	sub    $0x1,%rax
  80122d:	0f b6 00             	movzbl (%rax),%eax
  801230:	3c 25                	cmp    $0x25,%al
  801232:	75 ec                	jne    801220 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  801234:	90                   	nop
		}
	}
  801235:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801236:	e9 43 fb ff ff       	jmpq   800d7e <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  80123b:	48 83 c4 60          	add    $0x60,%rsp
  80123f:	5b                   	pop    %rbx
  801240:	41 5c                	pop    %r12
  801242:	5d                   	pop    %rbp
  801243:	c3                   	retq   

0000000000801244 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801244:	55                   	push   %rbp
  801245:	48 89 e5             	mov    %rsp,%rbp
  801248:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80124f:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801256:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80125d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801264:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80126b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801272:	84 c0                	test   %al,%al
  801274:	74 20                	je     801296 <printfmt+0x52>
  801276:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80127a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80127e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801282:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801286:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80128a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80128e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801292:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801296:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80129d:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8012a4:	00 00 00 
  8012a7:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8012ae:	00 00 00 
  8012b1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8012b5:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8012bc:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8012c3:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8012ca:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8012d1:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8012d8:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8012df:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8012e6:	48 89 c7             	mov    %rax,%rdi
  8012e9:	48 b8 2c 0d 80 00 00 	movabs $0x800d2c,%rax
  8012f0:	00 00 00 
  8012f3:	ff d0                	callq  *%rax
	va_end(ap);
}
  8012f5:	c9                   	leaveq 
  8012f6:	c3                   	retq   

00000000008012f7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8012f7:	55                   	push   %rbp
  8012f8:	48 89 e5             	mov    %rsp,%rbp
  8012fb:	48 83 ec 10          	sub    $0x10,%rsp
  8012ff:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801302:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801306:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80130a:	8b 40 10             	mov    0x10(%rax),%eax
  80130d:	8d 50 01             	lea    0x1(%rax),%edx
  801310:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801314:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801317:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80131b:	48 8b 10             	mov    (%rax),%rdx
  80131e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801322:	48 8b 40 08          	mov    0x8(%rax),%rax
  801326:	48 39 c2             	cmp    %rax,%rdx
  801329:	73 17                	jae    801342 <sprintputch+0x4b>
		*b->buf++ = ch;
  80132b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80132f:	48 8b 00             	mov    (%rax),%rax
  801332:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801336:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80133a:	48 89 0a             	mov    %rcx,(%rdx)
  80133d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801340:	88 10                	mov    %dl,(%rax)
}
  801342:	c9                   	leaveq 
  801343:	c3                   	retq   

0000000000801344 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801344:	55                   	push   %rbp
  801345:	48 89 e5             	mov    %rsp,%rbp
  801348:	48 83 ec 50          	sub    $0x50,%rsp
  80134c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801350:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801353:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801357:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80135b:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80135f:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801363:	48 8b 0a             	mov    (%rdx),%rcx
  801366:	48 89 08             	mov    %rcx,(%rax)
  801369:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80136d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801371:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801375:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801379:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80137d:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801381:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801384:	48 98                	cltq   
  801386:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80138a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80138e:	48 01 d0             	add    %rdx,%rax
  801391:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801395:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80139c:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8013a1:	74 06                	je     8013a9 <vsnprintf+0x65>
  8013a3:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8013a7:	7f 07                	jg     8013b0 <vsnprintf+0x6c>
		return -E_INVAL;
  8013a9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013ae:	eb 2f                	jmp    8013df <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8013b0:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8013b4:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8013b8:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8013bc:	48 89 c6             	mov    %rax,%rsi
  8013bf:	48 bf f7 12 80 00 00 	movabs $0x8012f7,%rdi
  8013c6:	00 00 00 
  8013c9:	48 b8 2c 0d 80 00 00 	movabs $0x800d2c,%rax
  8013d0:	00 00 00 
  8013d3:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8013d5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8013d9:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8013dc:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8013df:	c9                   	leaveq 
  8013e0:	c3                   	retq   

00000000008013e1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8013e1:	55                   	push   %rbp
  8013e2:	48 89 e5             	mov    %rsp,%rbp
  8013e5:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8013ec:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8013f3:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8013f9:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801400:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801407:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80140e:	84 c0                	test   %al,%al
  801410:	74 20                	je     801432 <snprintf+0x51>
  801412:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801416:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80141a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80141e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801422:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801426:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80142a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80142e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801432:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801439:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801440:	00 00 00 
  801443:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80144a:	00 00 00 
  80144d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801451:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801458:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80145f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801466:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80146d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801474:	48 8b 0a             	mov    (%rdx),%rcx
  801477:	48 89 08             	mov    %rcx,(%rax)
  80147a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80147e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801482:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801486:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80148a:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801491:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801498:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80149e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8014a5:	48 89 c7             	mov    %rax,%rdi
  8014a8:	48 b8 44 13 80 00 00 	movabs $0x801344,%rax
  8014af:	00 00 00 
  8014b2:	ff d0                	callq  *%rax
  8014b4:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8014ba:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8014c0:	c9                   	leaveq 
  8014c1:	c3                   	retq   

00000000008014c2 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8014c2:	55                   	push   %rbp
  8014c3:	48 89 e5             	mov    %rsp,%rbp
  8014c6:	48 83 ec 18          	sub    $0x18,%rsp
  8014ca:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8014ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8014d5:	eb 09                	jmp    8014e0 <strlen+0x1e>
		n++;
  8014d7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8014db:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8014e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014e4:	0f b6 00             	movzbl (%rax),%eax
  8014e7:	84 c0                	test   %al,%al
  8014e9:	75 ec                	jne    8014d7 <strlen+0x15>
		n++;
	return n;
  8014eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8014ee:	c9                   	leaveq 
  8014ef:	c3                   	retq   

00000000008014f0 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8014f0:	55                   	push   %rbp
  8014f1:	48 89 e5             	mov    %rsp,%rbp
  8014f4:	48 83 ec 20          	sub    $0x20,%rsp
  8014f8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014fc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801500:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801507:	eb 0e                	jmp    801517 <strnlen+0x27>
		n++;
  801509:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80150d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801512:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801517:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80151c:	74 0b                	je     801529 <strnlen+0x39>
  80151e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801522:	0f b6 00             	movzbl (%rax),%eax
  801525:	84 c0                	test   %al,%al
  801527:	75 e0                	jne    801509 <strnlen+0x19>
		n++;
	return n;
  801529:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80152c:	c9                   	leaveq 
  80152d:	c3                   	retq   

000000000080152e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80152e:	55                   	push   %rbp
  80152f:	48 89 e5             	mov    %rsp,%rbp
  801532:	48 83 ec 20          	sub    $0x20,%rsp
  801536:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80153a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80153e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801542:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801546:	90                   	nop
  801547:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80154b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80154f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801553:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801557:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80155b:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80155f:	0f b6 12             	movzbl (%rdx),%edx
  801562:	88 10                	mov    %dl,(%rax)
  801564:	0f b6 00             	movzbl (%rax),%eax
  801567:	84 c0                	test   %al,%al
  801569:	75 dc                	jne    801547 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80156b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80156f:	c9                   	leaveq 
  801570:	c3                   	retq   

0000000000801571 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801571:	55                   	push   %rbp
  801572:	48 89 e5             	mov    %rsp,%rbp
  801575:	48 83 ec 20          	sub    $0x20,%rsp
  801579:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80157d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801581:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801585:	48 89 c7             	mov    %rax,%rdi
  801588:	48 b8 c2 14 80 00 00 	movabs $0x8014c2,%rax
  80158f:	00 00 00 
  801592:	ff d0                	callq  *%rax
  801594:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801597:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80159a:	48 63 d0             	movslq %eax,%rdx
  80159d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015a1:	48 01 c2             	add    %rax,%rdx
  8015a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015a8:	48 89 c6             	mov    %rax,%rsi
  8015ab:	48 89 d7             	mov    %rdx,%rdi
  8015ae:	48 b8 2e 15 80 00 00 	movabs $0x80152e,%rax
  8015b5:	00 00 00 
  8015b8:	ff d0                	callq  *%rax
	return dst;
  8015ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015be:	c9                   	leaveq 
  8015bf:	c3                   	retq   

00000000008015c0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8015c0:	55                   	push   %rbp
  8015c1:	48 89 e5             	mov    %rsp,%rbp
  8015c4:	48 83 ec 28          	sub    $0x28,%rsp
  8015c8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015cc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8015d0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8015d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015d8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8015dc:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8015e3:	00 
  8015e4:	eb 2a                	jmp    801610 <strncpy+0x50>
		*dst++ = *src;
  8015e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015ea:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015ee:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8015f2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8015f6:	0f b6 12             	movzbl (%rdx),%edx
  8015f9:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8015fb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015ff:	0f b6 00             	movzbl (%rax),%eax
  801602:	84 c0                	test   %al,%al
  801604:	74 05                	je     80160b <strncpy+0x4b>
			src++;
  801606:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80160b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801610:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801614:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801618:	72 cc                	jb     8015e6 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80161a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80161e:	c9                   	leaveq 
  80161f:	c3                   	retq   

0000000000801620 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801620:	55                   	push   %rbp
  801621:	48 89 e5             	mov    %rsp,%rbp
  801624:	48 83 ec 28          	sub    $0x28,%rsp
  801628:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80162c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801630:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801634:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801638:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80163c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801641:	74 3d                	je     801680 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801643:	eb 1d                	jmp    801662 <strlcpy+0x42>
			*dst++ = *src++;
  801645:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801649:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80164d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801651:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801655:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801659:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80165d:	0f b6 12             	movzbl (%rdx),%edx
  801660:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801662:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801667:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80166c:	74 0b                	je     801679 <strlcpy+0x59>
  80166e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801672:	0f b6 00             	movzbl (%rax),%eax
  801675:	84 c0                	test   %al,%al
  801677:	75 cc                	jne    801645 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801679:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80167d:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801680:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801684:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801688:	48 29 c2             	sub    %rax,%rdx
  80168b:	48 89 d0             	mov    %rdx,%rax
}
  80168e:	c9                   	leaveq 
  80168f:	c3                   	retq   

0000000000801690 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801690:	55                   	push   %rbp
  801691:	48 89 e5             	mov    %rsp,%rbp
  801694:	48 83 ec 10          	sub    $0x10,%rsp
  801698:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80169c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8016a0:	eb 0a                	jmp    8016ac <strcmp+0x1c>
		p++, q++;
  8016a2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016a7:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8016ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016b0:	0f b6 00             	movzbl (%rax),%eax
  8016b3:	84 c0                	test   %al,%al
  8016b5:	74 12                	je     8016c9 <strcmp+0x39>
  8016b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016bb:	0f b6 10             	movzbl (%rax),%edx
  8016be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016c2:	0f b6 00             	movzbl (%rax),%eax
  8016c5:	38 c2                	cmp    %al,%dl
  8016c7:	74 d9                	je     8016a2 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8016c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016cd:	0f b6 00             	movzbl (%rax),%eax
  8016d0:	0f b6 d0             	movzbl %al,%edx
  8016d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016d7:	0f b6 00             	movzbl (%rax),%eax
  8016da:	0f b6 c0             	movzbl %al,%eax
  8016dd:	29 c2                	sub    %eax,%edx
  8016df:	89 d0                	mov    %edx,%eax
}
  8016e1:	c9                   	leaveq 
  8016e2:	c3                   	retq   

00000000008016e3 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8016e3:	55                   	push   %rbp
  8016e4:	48 89 e5             	mov    %rsp,%rbp
  8016e7:	48 83 ec 18          	sub    $0x18,%rsp
  8016eb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016ef:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8016f3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8016f7:	eb 0f                	jmp    801708 <strncmp+0x25>
		n--, p++, q++;
  8016f9:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8016fe:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801703:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801708:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80170d:	74 1d                	je     80172c <strncmp+0x49>
  80170f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801713:	0f b6 00             	movzbl (%rax),%eax
  801716:	84 c0                	test   %al,%al
  801718:	74 12                	je     80172c <strncmp+0x49>
  80171a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80171e:	0f b6 10             	movzbl (%rax),%edx
  801721:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801725:	0f b6 00             	movzbl (%rax),%eax
  801728:	38 c2                	cmp    %al,%dl
  80172a:	74 cd                	je     8016f9 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80172c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801731:	75 07                	jne    80173a <strncmp+0x57>
		return 0;
  801733:	b8 00 00 00 00       	mov    $0x0,%eax
  801738:	eb 18                	jmp    801752 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80173a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80173e:	0f b6 00             	movzbl (%rax),%eax
  801741:	0f b6 d0             	movzbl %al,%edx
  801744:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801748:	0f b6 00             	movzbl (%rax),%eax
  80174b:	0f b6 c0             	movzbl %al,%eax
  80174e:	29 c2                	sub    %eax,%edx
  801750:	89 d0                	mov    %edx,%eax
}
  801752:	c9                   	leaveq 
  801753:	c3                   	retq   

0000000000801754 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801754:	55                   	push   %rbp
  801755:	48 89 e5             	mov    %rsp,%rbp
  801758:	48 83 ec 0c          	sub    $0xc,%rsp
  80175c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801760:	89 f0                	mov    %esi,%eax
  801762:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801765:	eb 17                	jmp    80177e <strchr+0x2a>
		if (*s == c)
  801767:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80176b:	0f b6 00             	movzbl (%rax),%eax
  80176e:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801771:	75 06                	jne    801779 <strchr+0x25>
			return (char *) s;
  801773:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801777:	eb 15                	jmp    80178e <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801779:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80177e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801782:	0f b6 00             	movzbl (%rax),%eax
  801785:	84 c0                	test   %al,%al
  801787:	75 de                	jne    801767 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801789:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80178e:	c9                   	leaveq 
  80178f:	c3                   	retq   

0000000000801790 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801790:	55                   	push   %rbp
  801791:	48 89 e5             	mov    %rsp,%rbp
  801794:	48 83 ec 0c          	sub    $0xc,%rsp
  801798:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80179c:	89 f0                	mov    %esi,%eax
  80179e:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8017a1:	eb 13                	jmp    8017b6 <strfind+0x26>
		if (*s == c)
  8017a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017a7:	0f b6 00             	movzbl (%rax),%eax
  8017aa:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8017ad:	75 02                	jne    8017b1 <strfind+0x21>
			break;
  8017af:	eb 10                	jmp    8017c1 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8017b1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017ba:	0f b6 00             	movzbl (%rax),%eax
  8017bd:	84 c0                	test   %al,%al
  8017bf:	75 e2                	jne    8017a3 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8017c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8017c5:	c9                   	leaveq 
  8017c6:	c3                   	retq   

00000000008017c7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8017c7:	55                   	push   %rbp
  8017c8:	48 89 e5             	mov    %rsp,%rbp
  8017cb:	48 83 ec 18          	sub    $0x18,%rsp
  8017cf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8017d3:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8017d6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8017da:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8017df:	75 06                	jne    8017e7 <memset+0x20>
		return v;
  8017e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017e5:	eb 69                	jmp    801850 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8017e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017eb:	83 e0 03             	and    $0x3,%eax
  8017ee:	48 85 c0             	test   %rax,%rax
  8017f1:	75 48                	jne    80183b <memset+0x74>
  8017f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017f7:	83 e0 03             	and    $0x3,%eax
  8017fa:	48 85 c0             	test   %rax,%rax
  8017fd:	75 3c                	jne    80183b <memset+0x74>
		c &= 0xFF;
  8017ff:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801806:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801809:	c1 e0 18             	shl    $0x18,%eax
  80180c:	89 c2                	mov    %eax,%edx
  80180e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801811:	c1 e0 10             	shl    $0x10,%eax
  801814:	09 c2                	or     %eax,%edx
  801816:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801819:	c1 e0 08             	shl    $0x8,%eax
  80181c:	09 d0                	or     %edx,%eax
  80181e:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801821:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801825:	48 c1 e8 02          	shr    $0x2,%rax
  801829:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80182c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801830:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801833:	48 89 d7             	mov    %rdx,%rdi
  801836:	fc                   	cld    
  801837:	f3 ab                	rep stos %eax,%es:(%rdi)
  801839:	eb 11                	jmp    80184c <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80183b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80183f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801842:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801846:	48 89 d7             	mov    %rdx,%rdi
  801849:	fc                   	cld    
  80184a:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  80184c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801850:	c9                   	leaveq 
  801851:	c3                   	retq   

0000000000801852 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801852:	55                   	push   %rbp
  801853:	48 89 e5             	mov    %rsp,%rbp
  801856:	48 83 ec 28          	sub    $0x28,%rsp
  80185a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80185e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801862:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801866:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80186a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80186e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801872:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801876:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80187a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80187e:	0f 83 88 00 00 00    	jae    80190c <memmove+0xba>
  801884:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801888:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80188c:	48 01 d0             	add    %rdx,%rax
  80188f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801893:	76 77                	jbe    80190c <memmove+0xba>
		s += n;
  801895:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801899:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80189d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018a1:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8018a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018a9:	83 e0 03             	and    $0x3,%eax
  8018ac:	48 85 c0             	test   %rax,%rax
  8018af:	75 3b                	jne    8018ec <memmove+0x9a>
  8018b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018b5:	83 e0 03             	and    $0x3,%eax
  8018b8:	48 85 c0             	test   %rax,%rax
  8018bb:	75 2f                	jne    8018ec <memmove+0x9a>
  8018bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018c1:	83 e0 03             	and    $0x3,%eax
  8018c4:	48 85 c0             	test   %rax,%rax
  8018c7:	75 23                	jne    8018ec <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8018c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018cd:	48 83 e8 04          	sub    $0x4,%rax
  8018d1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8018d5:	48 83 ea 04          	sub    $0x4,%rdx
  8018d9:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8018dd:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8018e1:	48 89 c7             	mov    %rax,%rdi
  8018e4:	48 89 d6             	mov    %rdx,%rsi
  8018e7:	fd                   	std    
  8018e8:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8018ea:	eb 1d                	jmp    801909 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8018ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018f0:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8018f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018f8:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8018fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801900:	48 89 d7             	mov    %rdx,%rdi
  801903:	48 89 c1             	mov    %rax,%rcx
  801906:	fd                   	std    
  801907:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801909:	fc                   	cld    
  80190a:	eb 57                	jmp    801963 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80190c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801910:	83 e0 03             	and    $0x3,%eax
  801913:	48 85 c0             	test   %rax,%rax
  801916:	75 36                	jne    80194e <memmove+0xfc>
  801918:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80191c:	83 e0 03             	and    $0x3,%eax
  80191f:	48 85 c0             	test   %rax,%rax
  801922:	75 2a                	jne    80194e <memmove+0xfc>
  801924:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801928:	83 e0 03             	and    $0x3,%eax
  80192b:	48 85 c0             	test   %rax,%rax
  80192e:	75 1e                	jne    80194e <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801930:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801934:	48 c1 e8 02          	shr    $0x2,%rax
  801938:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80193b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80193f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801943:	48 89 c7             	mov    %rax,%rdi
  801946:	48 89 d6             	mov    %rdx,%rsi
  801949:	fc                   	cld    
  80194a:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80194c:	eb 15                	jmp    801963 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80194e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801952:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801956:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80195a:	48 89 c7             	mov    %rax,%rdi
  80195d:	48 89 d6             	mov    %rdx,%rsi
  801960:	fc                   	cld    
  801961:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801963:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801967:	c9                   	leaveq 
  801968:	c3                   	retq   

0000000000801969 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801969:	55                   	push   %rbp
  80196a:	48 89 e5             	mov    %rsp,%rbp
  80196d:	48 83 ec 18          	sub    $0x18,%rsp
  801971:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801975:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801979:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80197d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801981:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801985:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801989:	48 89 ce             	mov    %rcx,%rsi
  80198c:	48 89 c7             	mov    %rax,%rdi
  80198f:	48 b8 52 18 80 00 00 	movabs $0x801852,%rax
  801996:	00 00 00 
  801999:	ff d0                	callq  *%rax
}
  80199b:	c9                   	leaveq 
  80199c:	c3                   	retq   

000000000080199d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80199d:	55                   	push   %rbp
  80199e:	48 89 e5             	mov    %rsp,%rbp
  8019a1:	48 83 ec 28          	sub    $0x28,%rsp
  8019a5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8019a9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8019ad:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8019b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019b5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8019b9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8019bd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8019c1:	eb 36                	jmp    8019f9 <memcmp+0x5c>
		if (*s1 != *s2)
  8019c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019c7:	0f b6 10             	movzbl (%rax),%edx
  8019ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019ce:	0f b6 00             	movzbl (%rax),%eax
  8019d1:	38 c2                	cmp    %al,%dl
  8019d3:	74 1a                	je     8019ef <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8019d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019d9:	0f b6 00             	movzbl (%rax),%eax
  8019dc:	0f b6 d0             	movzbl %al,%edx
  8019df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019e3:	0f b6 00             	movzbl (%rax),%eax
  8019e6:	0f b6 c0             	movzbl %al,%eax
  8019e9:	29 c2                	sub    %eax,%edx
  8019eb:	89 d0                	mov    %edx,%eax
  8019ed:	eb 20                	jmp    801a0f <memcmp+0x72>
		s1++, s2++;
  8019ef:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8019f4:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8019f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019fd:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801a01:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801a05:	48 85 c0             	test   %rax,%rax
  801a08:	75 b9                	jne    8019c3 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801a0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a0f:	c9                   	leaveq 
  801a10:	c3                   	retq   

0000000000801a11 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801a11:	55                   	push   %rbp
  801a12:	48 89 e5             	mov    %rsp,%rbp
  801a15:	48 83 ec 28          	sub    $0x28,%rsp
  801a19:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a1d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801a20:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801a24:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a28:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801a2c:	48 01 d0             	add    %rdx,%rax
  801a2f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801a33:	eb 15                	jmp    801a4a <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801a35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a39:	0f b6 10             	movzbl (%rax),%edx
  801a3c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a3f:	38 c2                	cmp    %al,%dl
  801a41:	75 02                	jne    801a45 <memfind+0x34>
			break;
  801a43:	eb 0f                	jmp    801a54 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801a45:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801a4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a4e:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801a52:	72 e1                	jb     801a35 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801a54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801a58:	c9                   	leaveq 
  801a59:	c3                   	retq   

0000000000801a5a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801a5a:	55                   	push   %rbp
  801a5b:	48 89 e5             	mov    %rsp,%rbp
  801a5e:	48 83 ec 34          	sub    $0x34,%rsp
  801a62:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801a66:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801a6a:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801a6d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801a74:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801a7b:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a7c:	eb 05                	jmp    801a83 <strtol+0x29>
		s++;
  801a7e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a83:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a87:	0f b6 00             	movzbl (%rax),%eax
  801a8a:	3c 20                	cmp    $0x20,%al
  801a8c:	74 f0                	je     801a7e <strtol+0x24>
  801a8e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a92:	0f b6 00             	movzbl (%rax),%eax
  801a95:	3c 09                	cmp    $0x9,%al
  801a97:	74 e5                	je     801a7e <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801a99:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a9d:	0f b6 00             	movzbl (%rax),%eax
  801aa0:	3c 2b                	cmp    $0x2b,%al
  801aa2:	75 07                	jne    801aab <strtol+0x51>
		s++;
  801aa4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801aa9:	eb 17                	jmp    801ac2 <strtol+0x68>
	else if (*s == '-')
  801aab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aaf:	0f b6 00             	movzbl (%rax),%eax
  801ab2:	3c 2d                	cmp    $0x2d,%al
  801ab4:	75 0c                	jne    801ac2 <strtol+0x68>
		s++, neg = 1;
  801ab6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801abb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ac2:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801ac6:	74 06                	je     801ace <strtol+0x74>
  801ac8:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801acc:	75 28                	jne    801af6 <strtol+0x9c>
  801ace:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ad2:	0f b6 00             	movzbl (%rax),%eax
  801ad5:	3c 30                	cmp    $0x30,%al
  801ad7:	75 1d                	jne    801af6 <strtol+0x9c>
  801ad9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801add:	48 83 c0 01          	add    $0x1,%rax
  801ae1:	0f b6 00             	movzbl (%rax),%eax
  801ae4:	3c 78                	cmp    $0x78,%al
  801ae6:	75 0e                	jne    801af6 <strtol+0x9c>
		s += 2, base = 16;
  801ae8:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801aed:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801af4:	eb 2c                	jmp    801b22 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801af6:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801afa:	75 19                	jne    801b15 <strtol+0xbb>
  801afc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b00:	0f b6 00             	movzbl (%rax),%eax
  801b03:	3c 30                	cmp    $0x30,%al
  801b05:	75 0e                	jne    801b15 <strtol+0xbb>
		s++, base = 8;
  801b07:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801b0c:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801b13:	eb 0d                	jmp    801b22 <strtol+0xc8>
	else if (base == 0)
  801b15:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801b19:	75 07                	jne    801b22 <strtol+0xc8>
		base = 10;
  801b1b:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801b22:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b26:	0f b6 00             	movzbl (%rax),%eax
  801b29:	3c 2f                	cmp    $0x2f,%al
  801b2b:	7e 1d                	jle    801b4a <strtol+0xf0>
  801b2d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b31:	0f b6 00             	movzbl (%rax),%eax
  801b34:	3c 39                	cmp    $0x39,%al
  801b36:	7f 12                	jg     801b4a <strtol+0xf0>
			dig = *s - '0';
  801b38:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b3c:	0f b6 00             	movzbl (%rax),%eax
  801b3f:	0f be c0             	movsbl %al,%eax
  801b42:	83 e8 30             	sub    $0x30,%eax
  801b45:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801b48:	eb 4e                	jmp    801b98 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801b4a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b4e:	0f b6 00             	movzbl (%rax),%eax
  801b51:	3c 60                	cmp    $0x60,%al
  801b53:	7e 1d                	jle    801b72 <strtol+0x118>
  801b55:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b59:	0f b6 00             	movzbl (%rax),%eax
  801b5c:	3c 7a                	cmp    $0x7a,%al
  801b5e:	7f 12                	jg     801b72 <strtol+0x118>
			dig = *s - 'a' + 10;
  801b60:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b64:	0f b6 00             	movzbl (%rax),%eax
  801b67:	0f be c0             	movsbl %al,%eax
  801b6a:	83 e8 57             	sub    $0x57,%eax
  801b6d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801b70:	eb 26                	jmp    801b98 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801b72:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b76:	0f b6 00             	movzbl (%rax),%eax
  801b79:	3c 40                	cmp    $0x40,%al
  801b7b:	7e 48                	jle    801bc5 <strtol+0x16b>
  801b7d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b81:	0f b6 00             	movzbl (%rax),%eax
  801b84:	3c 5a                	cmp    $0x5a,%al
  801b86:	7f 3d                	jg     801bc5 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801b88:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b8c:	0f b6 00             	movzbl (%rax),%eax
  801b8f:	0f be c0             	movsbl %al,%eax
  801b92:	83 e8 37             	sub    $0x37,%eax
  801b95:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801b98:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801b9b:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801b9e:	7c 02                	jl     801ba2 <strtol+0x148>
			break;
  801ba0:	eb 23                	jmp    801bc5 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801ba2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801ba7:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801baa:	48 98                	cltq   
  801bac:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801bb1:	48 89 c2             	mov    %rax,%rdx
  801bb4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801bb7:	48 98                	cltq   
  801bb9:	48 01 d0             	add    %rdx,%rax
  801bbc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801bc0:	e9 5d ff ff ff       	jmpq   801b22 <strtol+0xc8>

	if (endptr)
  801bc5:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801bca:	74 0b                	je     801bd7 <strtol+0x17d>
		*endptr = (char *) s;
  801bcc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801bd0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801bd4:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801bd7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bdb:	74 09                	je     801be6 <strtol+0x18c>
  801bdd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801be1:	48 f7 d8             	neg    %rax
  801be4:	eb 04                	jmp    801bea <strtol+0x190>
  801be6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801bea:	c9                   	leaveq 
  801beb:	c3                   	retq   

0000000000801bec <strstr>:

char * strstr(const char *in, const char *str)
{
  801bec:	55                   	push   %rbp
  801bed:	48 89 e5             	mov    %rsp,%rbp
  801bf0:	48 83 ec 30          	sub    $0x30,%rsp
  801bf4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801bf8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801bfc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c00:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801c04:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801c08:	0f b6 00             	movzbl (%rax),%eax
  801c0b:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  801c0e:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801c12:	75 06                	jne    801c1a <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  801c14:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c18:	eb 6b                	jmp    801c85 <strstr+0x99>

    len = strlen(str);
  801c1a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c1e:	48 89 c7             	mov    %rax,%rdi
  801c21:	48 b8 c2 14 80 00 00 	movabs $0x8014c2,%rax
  801c28:	00 00 00 
  801c2b:	ff d0                	callq  *%rax
  801c2d:	48 98                	cltq   
  801c2f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801c33:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c37:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801c3b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801c3f:	0f b6 00             	movzbl (%rax),%eax
  801c42:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  801c45:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801c49:	75 07                	jne    801c52 <strstr+0x66>
                return (char *) 0;
  801c4b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c50:	eb 33                	jmp    801c85 <strstr+0x99>
        } while (sc != c);
  801c52:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801c56:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801c59:	75 d8                	jne    801c33 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  801c5b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c5f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801c63:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c67:	48 89 ce             	mov    %rcx,%rsi
  801c6a:	48 89 c7             	mov    %rax,%rdi
  801c6d:	48 b8 e3 16 80 00 00 	movabs $0x8016e3,%rax
  801c74:	00 00 00 
  801c77:	ff d0                	callq  *%rax
  801c79:	85 c0                	test   %eax,%eax
  801c7b:	75 b6                	jne    801c33 <strstr+0x47>

    return (char *) (in - 1);
  801c7d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c81:	48 83 e8 01          	sub    $0x1,%rax
}
  801c85:	c9                   	leaveq 
  801c86:	c3                   	retq   

0000000000801c87 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801c87:	55                   	push   %rbp
  801c88:	48 89 e5             	mov    %rsp,%rbp
  801c8b:	53                   	push   %rbx
  801c8c:	48 83 ec 48          	sub    $0x48,%rsp
  801c90:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801c93:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801c96:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801c9a:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801c9e:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801ca2:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ca6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801ca9:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801cad:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801cb1:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801cb5:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801cb9:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801cbd:	4c 89 c3             	mov    %r8,%rbx
  801cc0:	cd 30                	int    $0x30
  801cc2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801cc6:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801cca:	74 3e                	je     801d0a <syscall+0x83>
  801ccc:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801cd1:	7e 37                	jle    801d0a <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801cd3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801cd7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801cda:	49 89 d0             	mov    %rdx,%r8
  801cdd:	89 c1                	mov    %eax,%ecx
  801cdf:	48 ba 40 49 80 00 00 	movabs $0x804940,%rdx
  801ce6:	00 00 00 
  801ce9:	be 23 00 00 00       	mov    $0x23,%esi
  801cee:	48 bf 5d 49 80 00 00 	movabs $0x80495d,%rdi
  801cf5:	00 00 00 
  801cf8:	b8 00 00 00 00       	mov    $0x0,%eax
  801cfd:	49 b9 40 07 80 00 00 	movabs $0x800740,%r9
  801d04:	00 00 00 
  801d07:	41 ff d1             	callq  *%r9

	return ret;
  801d0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801d0e:	48 83 c4 48          	add    $0x48,%rsp
  801d12:	5b                   	pop    %rbx
  801d13:	5d                   	pop    %rbp
  801d14:	c3                   	retq   

0000000000801d15 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801d15:	55                   	push   %rbp
  801d16:	48 89 e5             	mov    %rsp,%rbp
  801d19:	48 83 ec 20          	sub    $0x20,%rsp
  801d1d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d21:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801d25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d29:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d2d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d34:	00 
  801d35:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d3b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d41:	48 89 d1             	mov    %rdx,%rcx
  801d44:	48 89 c2             	mov    %rax,%rdx
  801d47:	be 00 00 00 00       	mov    $0x0,%esi
  801d4c:	bf 00 00 00 00       	mov    $0x0,%edi
  801d51:	48 b8 87 1c 80 00 00 	movabs $0x801c87,%rax
  801d58:	00 00 00 
  801d5b:	ff d0                	callq  *%rax
}
  801d5d:	c9                   	leaveq 
  801d5e:	c3                   	retq   

0000000000801d5f <sys_cgetc>:

int
sys_cgetc(void)
{
  801d5f:	55                   	push   %rbp
  801d60:	48 89 e5             	mov    %rsp,%rbp
  801d63:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801d67:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d6e:	00 
  801d6f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d75:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d7b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d80:	ba 00 00 00 00       	mov    $0x0,%edx
  801d85:	be 00 00 00 00       	mov    $0x0,%esi
  801d8a:	bf 01 00 00 00       	mov    $0x1,%edi
  801d8f:	48 b8 87 1c 80 00 00 	movabs $0x801c87,%rax
  801d96:	00 00 00 
  801d99:	ff d0                	callq  *%rax
}
  801d9b:	c9                   	leaveq 
  801d9c:	c3                   	retq   

0000000000801d9d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801d9d:	55                   	push   %rbp
  801d9e:	48 89 e5             	mov    %rsp,%rbp
  801da1:	48 83 ec 10          	sub    $0x10,%rsp
  801da5:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801da8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dab:	48 98                	cltq   
  801dad:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801db4:	00 
  801db5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dbb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dc1:	b9 00 00 00 00       	mov    $0x0,%ecx
  801dc6:	48 89 c2             	mov    %rax,%rdx
  801dc9:	be 01 00 00 00       	mov    $0x1,%esi
  801dce:	bf 03 00 00 00       	mov    $0x3,%edi
  801dd3:	48 b8 87 1c 80 00 00 	movabs $0x801c87,%rax
  801dda:	00 00 00 
  801ddd:	ff d0                	callq  *%rax
}
  801ddf:	c9                   	leaveq 
  801de0:	c3                   	retq   

0000000000801de1 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801de1:	55                   	push   %rbp
  801de2:	48 89 e5             	mov    %rsp,%rbp
  801de5:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801de9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801df0:	00 
  801df1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801df7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dfd:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e02:	ba 00 00 00 00       	mov    $0x0,%edx
  801e07:	be 00 00 00 00       	mov    $0x0,%esi
  801e0c:	bf 02 00 00 00       	mov    $0x2,%edi
  801e11:	48 b8 87 1c 80 00 00 	movabs $0x801c87,%rax
  801e18:	00 00 00 
  801e1b:	ff d0                	callq  *%rax
}
  801e1d:	c9                   	leaveq 
  801e1e:	c3                   	retq   

0000000000801e1f <sys_yield>:

void
sys_yield(void)
{
  801e1f:	55                   	push   %rbp
  801e20:	48 89 e5             	mov    %rsp,%rbp
  801e23:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801e27:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e2e:	00 
  801e2f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e35:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e3b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e40:	ba 00 00 00 00       	mov    $0x0,%edx
  801e45:	be 00 00 00 00       	mov    $0x0,%esi
  801e4a:	bf 0b 00 00 00       	mov    $0xb,%edi
  801e4f:	48 b8 87 1c 80 00 00 	movabs $0x801c87,%rax
  801e56:	00 00 00 
  801e59:	ff d0                	callq  *%rax
}
  801e5b:	c9                   	leaveq 
  801e5c:	c3                   	retq   

0000000000801e5d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801e5d:	55                   	push   %rbp
  801e5e:	48 89 e5             	mov    %rsp,%rbp
  801e61:	48 83 ec 20          	sub    $0x20,%rsp
  801e65:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e68:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e6c:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801e6f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e72:	48 63 c8             	movslq %eax,%rcx
  801e75:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e79:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e7c:	48 98                	cltq   
  801e7e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e85:	00 
  801e86:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e8c:	49 89 c8             	mov    %rcx,%r8
  801e8f:	48 89 d1             	mov    %rdx,%rcx
  801e92:	48 89 c2             	mov    %rax,%rdx
  801e95:	be 01 00 00 00       	mov    $0x1,%esi
  801e9a:	bf 04 00 00 00       	mov    $0x4,%edi
  801e9f:	48 b8 87 1c 80 00 00 	movabs $0x801c87,%rax
  801ea6:	00 00 00 
  801ea9:	ff d0                	callq  *%rax
}
  801eab:	c9                   	leaveq 
  801eac:	c3                   	retq   

0000000000801ead <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801ead:	55                   	push   %rbp
  801eae:	48 89 e5             	mov    %rsp,%rbp
  801eb1:	48 83 ec 30          	sub    $0x30,%rsp
  801eb5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801eb8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ebc:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801ebf:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801ec3:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801ec7:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801eca:	48 63 c8             	movslq %eax,%rcx
  801ecd:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801ed1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ed4:	48 63 f0             	movslq %eax,%rsi
  801ed7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801edb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ede:	48 98                	cltq   
  801ee0:	48 89 0c 24          	mov    %rcx,(%rsp)
  801ee4:	49 89 f9             	mov    %rdi,%r9
  801ee7:	49 89 f0             	mov    %rsi,%r8
  801eea:	48 89 d1             	mov    %rdx,%rcx
  801eed:	48 89 c2             	mov    %rax,%rdx
  801ef0:	be 01 00 00 00       	mov    $0x1,%esi
  801ef5:	bf 05 00 00 00       	mov    $0x5,%edi
  801efa:	48 b8 87 1c 80 00 00 	movabs $0x801c87,%rax
  801f01:	00 00 00 
  801f04:	ff d0                	callq  *%rax
}
  801f06:	c9                   	leaveq 
  801f07:	c3                   	retq   

0000000000801f08 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801f08:	55                   	push   %rbp
  801f09:	48 89 e5             	mov    %rsp,%rbp
  801f0c:	48 83 ec 20          	sub    $0x20,%rsp
  801f10:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f13:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801f17:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f1e:	48 98                	cltq   
  801f20:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f27:	00 
  801f28:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f2e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f34:	48 89 d1             	mov    %rdx,%rcx
  801f37:	48 89 c2             	mov    %rax,%rdx
  801f3a:	be 01 00 00 00       	mov    $0x1,%esi
  801f3f:	bf 06 00 00 00       	mov    $0x6,%edi
  801f44:	48 b8 87 1c 80 00 00 	movabs $0x801c87,%rax
  801f4b:	00 00 00 
  801f4e:	ff d0                	callq  *%rax
}
  801f50:	c9                   	leaveq 
  801f51:	c3                   	retq   

0000000000801f52 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801f52:	55                   	push   %rbp
  801f53:	48 89 e5             	mov    %rsp,%rbp
  801f56:	48 83 ec 10          	sub    $0x10,%rsp
  801f5a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f5d:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801f60:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f63:	48 63 d0             	movslq %eax,%rdx
  801f66:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f69:	48 98                	cltq   
  801f6b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f72:	00 
  801f73:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f79:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f7f:	48 89 d1             	mov    %rdx,%rcx
  801f82:	48 89 c2             	mov    %rax,%rdx
  801f85:	be 01 00 00 00       	mov    $0x1,%esi
  801f8a:	bf 08 00 00 00       	mov    $0x8,%edi
  801f8f:	48 b8 87 1c 80 00 00 	movabs $0x801c87,%rax
  801f96:	00 00 00 
  801f99:	ff d0                	callq  *%rax
}
  801f9b:	c9                   	leaveq 
  801f9c:	c3                   	retq   

0000000000801f9d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801f9d:	55                   	push   %rbp
  801f9e:	48 89 e5             	mov    %rsp,%rbp
  801fa1:	48 83 ec 20          	sub    $0x20,%rsp
  801fa5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801fa8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801fac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fb0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fb3:	48 98                	cltq   
  801fb5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fbc:	00 
  801fbd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fc3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fc9:	48 89 d1             	mov    %rdx,%rcx
  801fcc:	48 89 c2             	mov    %rax,%rdx
  801fcf:	be 01 00 00 00       	mov    $0x1,%esi
  801fd4:	bf 09 00 00 00       	mov    $0x9,%edi
  801fd9:	48 b8 87 1c 80 00 00 	movabs $0x801c87,%rax
  801fe0:	00 00 00 
  801fe3:	ff d0                	callq  *%rax
}
  801fe5:	c9                   	leaveq 
  801fe6:	c3                   	retq   

0000000000801fe7 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801fe7:	55                   	push   %rbp
  801fe8:	48 89 e5             	mov    %rsp,%rbp
  801feb:	48 83 ec 20          	sub    $0x20,%rsp
  801fef:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ff2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801ff6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ffa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ffd:	48 98                	cltq   
  801fff:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802006:	00 
  802007:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80200d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802013:	48 89 d1             	mov    %rdx,%rcx
  802016:	48 89 c2             	mov    %rax,%rdx
  802019:	be 01 00 00 00       	mov    $0x1,%esi
  80201e:	bf 0a 00 00 00       	mov    $0xa,%edi
  802023:	48 b8 87 1c 80 00 00 	movabs $0x801c87,%rax
  80202a:	00 00 00 
  80202d:	ff d0                	callq  *%rax
}
  80202f:	c9                   	leaveq 
  802030:	c3                   	retq   

0000000000802031 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  802031:	55                   	push   %rbp
  802032:	48 89 e5             	mov    %rsp,%rbp
  802035:	48 83 ec 20          	sub    $0x20,%rsp
  802039:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80203c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802040:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802044:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  802047:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80204a:	48 63 f0             	movslq %eax,%rsi
  80204d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802051:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802054:	48 98                	cltq   
  802056:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80205a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802061:	00 
  802062:	49 89 f1             	mov    %rsi,%r9
  802065:	49 89 c8             	mov    %rcx,%r8
  802068:	48 89 d1             	mov    %rdx,%rcx
  80206b:	48 89 c2             	mov    %rax,%rdx
  80206e:	be 00 00 00 00       	mov    $0x0,%esi
  802073:	bf 0c 00 00 00       	mov    $0xc,%edi
  802078:	48 b8 87 1c 80 00 00 	movabs $0x801c87,%rax
  80207f:	00 00 00 
  802082:	ff d0                	callq  *%rax
}
  802084:	c9                   	leaveq 
  802085:	c3                   	retq   

0000000000802086 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802086:	55                   	push   %rbp
  802087:	48 89 e5             	mov    %rsp,%rbp
  80208a:	48 83 ec 10          	sub    $0x10,%rsp
  80208e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  802092:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802096:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80209d:	00 
  80209e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020a4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020aa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020af:	48 89 c2             	mov    %rax,%rdx
  8020b2:	be 01 00 00 00       	mov    $0x1,%esi
  8020b7:	bf 0d 00 00 00       	mov    $0xd,%edi
  8020bc:	48 b8 87 1c 80 00 00 	movabs $0x801c87,%rax
  8020c3:	00 00 00 
  8020c6:	ff d0                	callq  *%rax
}
  8020c8:	c9                   	leaveq 
  8020c9:	c3                   	retq   

00000000008020ca <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8020ca:	55                   	push   %rbp
  8020cb:	48 89 e5             	mov    %rsp,%rbp
  8020ce:	48 83 ec 08          	sub    $0x8,%rsp
  8020d2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8020d6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8020da:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8020e1:	ff ff ff 
  8020e4:	48 01 d0             	add    %rdx,%rax
  8020e7:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8020eb:	c9                   	leaveq 
  8020ec:	c3                   	retq   

00000000008020ed <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8020ed:	55                   	push   %rbp
  8020ee:	48 89 e5             	mov    %rsp,%rbp
  8020f1:	48 83 ec 08          	sub    $0x8,%rsp
  8020f5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8020f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020fd:	48 89 c7             	mov    %rax,%rdi
  802100:	48 b8 ca 20 80 00 00 	movabs $0x8020ca,%rax
  802107:	00 00 00 
  80210a:	ff d0                	callq  *%rax
  80210c:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802112:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802116:	c9                   	leaveq 
  802117:	c3                   	retq   

0000000000802118 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802118:	55                   	push   %rbp
  802119:	48 89 e5             	mov    %rsp,%rbp
  80211c:	48 83 ec 18          	sub    $0x18,%rsp
  802120:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802124:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80212b:	eb 6b                	jmp    802198 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80212d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802130:	48 98                	cltq   
  802132:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802138:	48 c1 e0 0c          	shl    $0xc,%rax
  80213c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802140:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802144:	48 c1 e8 15          	shr    $0x15,%rax
  802148:	48 89 c2             	mov    %rax,%rdx
  80214b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802152:	01 00 00 
  802155:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802159:	83 e0 01             	and    $0x1,%eax
  80215c:	48 85 c0             	test   %rax,%rax
  80215f:	74 21                	je     802182 <fd_alloc+0x6a>
  802161:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802165:	48 c1 e8 0c          	shr    $0xc,%rax
  802169:	48 89 c2             	mov    %rax,%rdx
  80216c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802173:	01 00 00 
  802176:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80217a:	83 e0 01             	and    $0x1,%eax
  80217d:	48 85 c0             	test   %rax,%rax
  802180:	75 12                	jne    802194 <fd_alloc+0x7c>
			*fd_store = fd;
  802182:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802186:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80218a:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80218d:	b8 00 00 00 00       	mov    $0x0,%eax
  802192:	eb 1a                	jmp    8021ae <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802194:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802198:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80219c:	7e 8f                	jle    80212d <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80219e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021a2:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8021a9:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8021ae:	c9                   	leaveq 
  8021af:	c3                   	retq   

00000000008021b0 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8021b0:	55                   	push   %rbp
  8021b1:	48 89 e5             	mov    %rsp,%rbp
  8021b4:	48 83 ec 20          	sub    $0x20,%rsp
  8021b8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8021bb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8021bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8021c3:	78 06                	js     8021cb <fd_lookup+0x1b>
  8021c5:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8021c9:	7e 07                	jle    8021d2 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8021cb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021d0:	eb 6c                	jmp    80223e <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8021d2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021d5:	48 98                	cltq   
  8021d7:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8021dd:	48 c1 e0 0c          	shl    $0xc,%rax
  8021e1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8021e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021e9:	48 c1 e8 15          	shr    $0x15,%rax
  8021ed:	48 89 c2             	mov    %rax,%rdx
  8021f0:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021f7:	01 00 00 
  8021fa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021fe:	83 e0 01             	and    $0x1,%eax
  802201:	48 85 c0             	test   %rax,%rax
  802204:	74 21                	je     802227 <fd_lookup+0x77>
  802206:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80220a:	48 c1 e8 0c          	shr    $0xc,%rax
  80220e:	48 89 c2             	mov    %rax,%rdx
  802211:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802218:	01 00 00 
  80221b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80221f:	83 e0 01             	and    $0x1,%eax
  802222:	48 85 c0             	test   %rax,%rax
  802225:	75 07                	jne    80222e <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802227:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80222c:	eb 10                	jmp    80223e <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80222e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802232:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802236:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802239:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80223e:	c9                   	leaveq 
  80223f:	c3                   	retq   

0000000000802240 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802240:	55                   	push   %rbp
  802241:	48 89 e5             	mov    %rsp,%rbp
  802244:	48 83 ec 30          	sub    $0x30,%rsp
  802248:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80224c:	89 f0                	mov    %esi,%eax
  80224e:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802251:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802255:	48 89 c7             	mov    %rax,%rdi
  802258:	48 b8 ca 20 80 00 00 	movabs $0x8020ca,%rax
  80225f:	00 00 00 
  802262:	ff d0                	callq  *%rax
  802264:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802268:	48 89 d6             	mov    %rdx,%rsi
  80226b:	89 c7                	mov    %eax,%edi
  80226d:	48 b8 b0 21 80 00 00 	movabs $0x8021b0,%rax
  802274:	00 00 00 
  802277:	ff d0                	callq  *%rax
  802279:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80227c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802280:	78 0a                	js     80228c <fd_close+0x4c>
	    || fd != fd2)
  802282:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802286:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80228a:	74 12                	je     80229e <fd_close+0x5e>
		return (must_exist ? r : 0);
  80228c:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802290:	74 05                	je     802297 <fd_close+0x57>
  802292:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802295:	eb 05                	jmp    80229c <fd_close+0x5c>
  802297:	b8 00 00 00 00       	mov    $0x0,%eax
  80229c:	eb 69                	jmp    802307 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80229e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022a2:	8b 00                	mov    (%rax),%eax
  8022a4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022a8:	48 89 d6             	mov    %rdx,%rsi
  8022ab:	89 c7                	mov    %eax,%edi
  8022ad:	48 b8 09 23 80 00 00 	movabs $0x802309,%rax
  8022b4:	00 00 00 
  8022b7:	ff d0                	callq  *%rax
  8022b9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022c0:	78 2a                	js     8022ec <fd_close+0xac>
		if (dev->dev_close)
  8022c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022c6:	48 8b 40 20          	mov    0x20(%rax),%rax
  8022ca:	48 85 c0             	test   %rax,%rax
  8022cd:	74 16                	je     8022e5 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8022cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022d3:	48 8b 40 20          	mov    0x20(%rax),%rax
  8022d7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8022db:	48 89 d7             	mov    %rdx,%rdi
  8022de:	ff d0                	callq  *%rax
  8022e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022e3:	eb 07                	jmp    8022ec <fd_close+0xac>
		else
			r = 0;
  8022e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8022ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022f0:	48 89 c6             	mov    %rax,%rsi
  8022f3:	bf 00 00 00 00       	mov    $0x0,%edi
  8022f8:	48 b8 08 1f 80 00 00 	movabs $0x801f08,%rax
  8022ff:	00 00 00 
  802302:	ff d0                	callq  *%rax
	return r;
  802304:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802307:	c9                   	leaveq 
  802308:	c3                   	retq   

0000000000802309 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802309:	55                   	push   %rbp
  80230a:	48 89 e5             	mov    %rsp,%rbp
  80230d:	48 83 ec 20          	sub    $0x20,%rsp
  802311:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802314:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802318:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80231f:	eb 41                	jmp    802362 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802321:	48 b8 c0 77 80 00 00 	movabs $0x8077c0,%rax
  802328:	00 00 00 
  80232b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80232e:	48 63 d2             	movslq %edx,%rdx
  802331:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802335:	8b 00                	mov    (%rax),%eax
  802337:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80233a:	75 22                	jne    80235e <dev_lookup+0x55>
			*dev = devtab[i];
  80233c:	48 b8 c0 77 80 00 00 	movabs $0x8077c0,%rax
  802343:	00 00 00 
  802346:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802349:	48 63 d2             	movslq %edx,%rdx
  80234c:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802350:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802354:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802357:	b8 00 00 00 00       	mov    $0x0,%eax
  80235c:	eb 60                	jmp    8023be <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80235e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802362:	48 b8 c0 77 80 00 00 	movabs $0x8077c0,%rax
  802369:	00 00 00 
  80236c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80236f:	48 63 d2             	movslq %edx,%rdx
  802372:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802376:	48 85 c0             	test   %rax,%rax
  802379:	75 a6                	jne    802321 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80237b:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  802382:	00 00 00 
  802385:	48 8b 00             	mov    (%rax),%rax
  802388:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80238e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802391:	89 c6                	mov    %eax,%esi
  802393:	48 bf 70 49 80 00 00 	movabs $0x804970,%rdi
  80239a:	00 00 00 
  80239d:	b8 00 00 00 00       	mov    $0x0,%eax
  8023a2:	48 b9 79 09 80 00 00 	movabs $0x800979,%rcx
  8023a9:	00 00 00 
  8023ac:	ff d1                	callq  *%rcx
	*dev = 0;
  8023ae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023b2:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8023b9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8023be:	c9                   	leaveq 
  8023bf:	c3                   	retq   

00000000008023c0 <close>:

int
close(int fdnum)
{
  8023c0:	55                   	push   %rbp
  8023c1:	48 89 e5             	mov    %rsp,%rbp
  8023c4:	48 83 ec 20          	sub    $0x20,%rsp
  8023c8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023cb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023cf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023d2:	48 89 d6             	mov    %rdx,%rsi
  8023d5:	89 c7                	mov    %eax,%edi
  8023d7:	48 b8 b0 21 80 00 00 	movabs $0x8021b0,%rax
  8023de:	00 00 00 
  8023e1:	ff d0                	callq  *%rax
  8023e3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023ea:	79 05                	jns    8023f1 <close+0x31>
		return r;
  8023ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023ef:	eb 18                	jmp    802409 <close+0x49>
	else
		return fd_close(fd, 1);
  8023f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023f5:	be 01 00 00 00       	mov    $0x1,%esi
  8023fa:	48 89 c7             	mov    %rax,%rdi
  8023fd:	48 b8 40 22 80 00 00 	movabs $0x802240,%rax
  802404:	00 00 00 
  802407:	ff d0                	callq  *%rax
}
  802409:	c9                   	leaveq 
  80240a:	c3                   	retq   

000000000080240b <close_all>:

void
close_all(void)
{
  80240b:	55                   	push   %rbp
  80240c:	48 89 e5             	mov    %rsp,%rbp
  80240f:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802413:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80241a:	eb 15                	jmp    802431 <close_all+0x26>
		close(i);
  80241c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80241f:	89 c7                	mov    %eax,%edi
  802421:	48 b8 c0 23 80 00 00 	movabs $0x8023c0,%rax
  802428:	00 00 00 
  80242b:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80242d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802431:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802435:	7e e5                	jle    80241c <close_all+0x11>
		close(i);
}
  802437:	c9                   	leaveq 
  802438:	c3                   	retq   

0000000000802439 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802439:	55                   	push   %rbp
  80243a:	48 89 e5             	mov    %rsp,%rbp
  80243d:	48 83 ec 40          	sub    $0x40,%rsp
  802441:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802444:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802447:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80244b:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80244e:	48 89 d6             	mov    %rdx,%rsi
  802451:	89 c7                	mov    %eax,%edi
  802453:	48 b8 b0 21 80 00 00 	movabs $0x8021b0,%rax
  80245a:	00 00 00 
  80245d:	ff d0                	callq  *%rax
  80245f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802462:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802466:	79 08                	jns    802470 <dup+0x37>
		return r;
  802468:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80246b:	e9 70 01 00 00       	jmpq   8025e0 <dup+0x1a7>
	close(newfdnum);
  802470:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802473:	89 c7                	mov    %eax,%edi
  802475:	48 b8 c0 23 80 00 00 	movabs $0x8023c0,%rax
  80247c:	00 00 00 
  80247f:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802481:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802484:	48 98                	cltq   
  802486:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80248c:	48 c1 e0 0c          	shl    $0xc,%rax
  802490:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802494:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802498:	48 89 c7             	mov    %rax,%rdi
  80249b:	48 b8 ed 20 80 00 00 	movabs $0x8020ed,%rax
  8024a2:	00 00 00 
  8024a5:	ff d0                	callq  *%rax
  8024a7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8024ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024af:	48 89 c7             	mov    %rax,%rdi
  8024b2:	48 b8 ed 20 80 00 00 	movabs $0x8020ed,%rax
  8024b9:	00 00 00 
  8024bc:	ff d0                	callq  *%rax
  8024be:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8024c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024c6:	48 c1 e8 15          	shr    $0x15,%rax
  8024ca:	48 89 c2             	mov    %rax,%rdx
  8024cd:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8024d4:	01 00 00 
  8024d7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024db:	83 e0 01             	and    $0x1,%eax
  8024de:	48 85 c0             	test   %rax,%rax
  8024e1:	74 73                	je     802556 <dup+0x11d>
  8024e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024e7:	48 c1 e8 0c          	shr    $0xc,%rax
  8024eb:	48 89 c2             	mov    %rax,%rdx
  8024ee:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024f5:	01 00 00 
  8024f8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024fc:	83 e0 01             	and    $0x1,%eax
  8024ff:	48 85 c0             	test   %rax,%rax
  802502:	74 52                	je     802556 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802504:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802508:	48 c1 e8 0c          	shr    $0xc,%rax
  80250c:	48 89 c2             	mov    %rax,%rdx
  80250f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802516:	01 00 00 
  802519:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80251d:	25 07 0e 00 00       	and    $0xe07,%eax
  802522:	89 c1                	mov    %eax,%ecx
  802524:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802528:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80252c:	41 89 c8             	mov    %ecx,%r8d
  80252f:	48 89 d1             	mov    %rdx,%rcx
  802532:	ba 00 00 00 00       	mov    $0x0,%edx
  802537:	48 89 c6             	mov    %rax,%rsi
  80253a:	bf 00 00 00 00       	mov    $0x0,%edi
  80253f:	48 b8 ad 1e 80 00 00 	movabs $0x801ead,%rax
  802546:	00 00 00 
  802549:	ff d0                	callq  *%rax
  80254b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80254e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802552:	79 02                	jns    802556 <dup+0x11d>
			goto err;
  802554:	eb 57                	jmp    8025ad <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802556:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80255a:	48 c1 e8 0c          	shr    $0xc,%rax
  80255e:	48 89 c2             	mov    %rax,%rdx
  802561:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802568:	01 00 00 
  80256b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80256f:	25 07 0e 00 00       	and    $0xe07,%eax
  802574:	89 c1                	mov    %eax,%ecx
  802576:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80257a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80257e:	41 89 c8             	mov    %ecx,%r8d
  802581:	48 89 d1             	mov    %rdx,%rcx
  802584:	ba 00 00 00 00       	mov    $0x0,%edx
  802589:	48 89 c6             	mov    %rax,%rsi
  80258c:	bf 00 00 00 00       	mov    $0x0,%edi
  802591:	48 b8 ad 1e 80 00 00 	movabs $0x801ead,%rax
  802598:	00 00 00 
  80259b:	ff d0                	callq  *%rax
  80259d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025a4:	79 02                	jns    8025a8 <dup+0x16f>
		goto err;
  8025a6:	eb 05                	jmp    8025ad <dup+0x174>

	return newfdnum;
  8025a8:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8025ab:	eb 33                	jmp    8025e0 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8025ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025b1:	48 89 c6             	mov    %rax,%rsi
  8025b4:	bf 00 00 00 00       	mov    $0x0,%edi
  8025b9:	48 b8 08 1f 80 00 00 	movabs $0x801f08,%rax
  8025c0:	00 00 00 
  8025c3:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8025c5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025c9:	48 89 c6             	mov    %rax,%rsi
  8025cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8025d1:	48 b8 08 1f 80 00 00 	movabs $0x801f08,%rax
  8025d8:	00 00 00 
  8025db:	ff d0                	callq  *%rax
	return r;
  8025dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8025e0:	c9                   	leaveq 
  8025e1:	c3                   	retq   

00000000008025e2 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8025e2:	55                   	push   %rbp
  8025e3:	48 89 e5             	mov    %rsp,%rbp
  8025e6:	48 83 ec 40          	sub    $0x40,%rsp
  8025ea:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8025ed:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8025f1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8025f5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8025f9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8025fc:	48 89 d6             	mov    %rdx,%rsi
  8025ff:	89 c7                	mov    %eax,%edi
  802601:	48 b8 b0 21 80 00 00 	movabs $0x8021b0,%rax
  802608:	00 00 00 
  80260b:	ff d0                	callq  *%rax
  80260d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802610:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802614:	78 24                	js     80263a <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802616:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80261a:	8b 00                	mov    (%rax),%eax
  80261c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802620:	48 89 d6             	mov    %rdx,%rsi
  802623:	89 c7                	mov    %eax,%edi
  802625:	48 b8 09 23 80 00 00 	movabs $0x802309,%rax
  80262c:	00 00 00 
  80262f:	ff d0                	callq  *%rax
  802631:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802634:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802638:	79 05                	jns    80263f <read+0x5d>
		return r;
  80263a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80263d:	eb 76                	jmp    8026b5 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80263f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802643:	8b 40 08             	mov    0x8(%rax),%eax
  802646:	83 e0 03             	and    $0x3,%eax
  802649:	83 f8 01             	cmp    $0x1,%eax
  80264c:	75 3a                	jne    802688 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80264e:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  802655:	00 00 00 
  802658:	48 8b 00             	mov    (%rax),%rax
  80265b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802661:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802664:	89 c6                	mov    %eax,%esi
  802666:	48 bf 8f 49 80 00 00 	movabs $0x80498f,%rdi
  80266d:	00 00 00 
  802670:	b8 00 00 00 00       	mov    $0x0,%eax
  802675:	48 b9 79 09 80 00 00 	movabs $0x800979,%rcx
  80267c:	00 00 00 
  80267f:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802681:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802686:	eb 2d                	jmp    8026b5 <read+0xd3>
	}
	if (!dev->dev_read)
  802688:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80268c:	48 8b 40 10          	mov    0x10(%rax),%rax
  802690:	48 85 c0             	test   %rax,%rax
  802693:	75 07                	jne    80269c <read+0xba>
		return -E_NOT_SUPP;
  802695:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80269a:	eb 19                	jmp    8026b5 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80269c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026a0:	48 8b 40 10          	mov    0x10(%rax),%rax
  8026a4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8026a8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8026ac:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8026b0:	48 89 cf             	mov    %rcx,%rdi
  8026b3:	ff d0                	callq  *%rax
}
  8026b5:	c9                   	leaveq 
  8026b6:	c3                   	retq   

00000000008026b7 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8026b7:	55                   	push   %rbp
  8026b8:	48 89 e5             	mov    %rsp,%rbp
  8026bb:	48 83 ec 30          	sub    $0x30,%rsp
  8026bf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8026c2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8026c6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8026ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8026d1:	eb 49                	jmp    80271c <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8026d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026d6:	48 98                	cltq   
  8026d8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8026dc:	48 29 c2             	sub    %rax,%rdx
  8026df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026e2:	48 63 c8             	movslq %eax,%rcx
  8026e5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026e9:	48 01 c1             	add    %rax,%rcx
  8026ec:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026ef:	48 89 ce             	mov    %rcx,%rsi
  8026f2:	89 c7                	mov    %eax,%edi
  8026f4:	48 b8 e2 25 80 00 00 	movabs $0x8025e2,%rax
  8026fb:	00 00 00 
  8026fe:	ff d0                	callq  *%rax
  802700:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802703:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802707:	79 05                	jns    80270e <readn+0x57>
			return m;
  802709:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80270c:	eb 1c                	jmp    80272a <readn+0x73>
		if (m == 0)
  80270e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802712:	75 02                	jne    802716 <readn+0x5f>
			break;
  802714:	eb 11                	jmp    802727 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802716:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802719:	01 45 fc             	add    %eax,-0x4(%rbp)
  80271c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80271f:	48 98                	cltq   
  802721:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802725:	72 ac                	jb     8026d3 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802727:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80272a:	c9                   	leaveq 
  80272b:	c3                   	retq   

000000000080272c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80272c:	55                   	push   %rbp
  80272d:	48 89 e5             	mov    %rsp,%rbp
  802730:	48 83 ec 40          	sub    $0x40,%rsp
  802734:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802737:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80273b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80273f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802743:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802746:	48 89 d6             	mov    %rdx,%rsi
  802749:	89 c7                	mov    %eax,%edi
  80274b:	48 b8 b0 21 80 00 00 	movabs $0x8021b0,%rax
  802752:	00 00 00 
  802755:	ff d0                	callq  *%rax
  802757:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80275a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80275e:	78 24                	js     802784 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802760:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802764:	8b 00                	mov    (%rax),%eax
  802766:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80276a:	48 89 d6             	mov    %rdx,%rsi
  80276d:	89 c7                	mov    %eax,%edi
  80276f:	48 b8 09 23 80 00 00 	movabs $0x802309,%rax
  802776:	00 00 00 
  802779:	ff d0                	callq  *%rax
  80277b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80277e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802782:	79 05                	jns    802789 <write+0x5d>
		return r;
  802784:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802787:	eb 75                	jmp    8027fe <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802789:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80278d:	8b 40 08             	mov    0x8(%rax),%eax
  802790:	83 e0 03             	and    $0x3,%eax
  802793:	85 c0                	test   %eax,%eax
  802795:	75 3a                	jne    8027d1 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802797:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  80279e:	00 00 00 
  8027a1:	48 8b 00             	mov    (%rax),%rax
  8027a4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8027aa:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8027ad:	89 c6                	mov    %eax,%esi
  8027af:	48 bf ab 49 80 00 00 	movabs $0x8049ab,%rdi
  8027b6:	00 00 00 
  8027b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8027be:	48 b9 79 09 80 00 00 	movabs $0x800979,%rcx
  8027c5:	00 00 00 
  8027c8:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8027ca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027cf:	eb 2d                	jmp    8027fe <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8027d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027d5:	48 8b 40 18          	mov    0x18(%rax),%rax
  8027d9:	48 85 c0             	test   %rax,%rax
  8027dc:	75 07                	jne    8027e5 <write+0xb9>
		return -E_NOT_SUPP;
  8027de:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8027e3:	eb 19                	jmp    8027fe <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8027e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027e9:	48 8b 40 18          	mov    0x18(%rax),%rax
  8027ed:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8027f1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8027f5:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8027f9:	48 89 cf             	mov    %rcx,%rdi
  8027fc:	ff d0                	callq  *%rax
}
  8027fe:	c9                   	leaveq 
  8027ff:	c3                   	retq   

0000000000802800 <seek>:

int
seek(int fdnum, off_t offset)
{
  802800:	55                   	push   %rbp
  802801:	48 89 e5             	mov    %rsp,%rbp
  802804:	48 83 ec 18          	sub    $0x18,%rsp
  802808:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80280b:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80280e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802812:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802815:	48 89 d6             	mov    %rdx,%rsi
  802818:	89 c7                	mov    %eax,%edi
  80281a:	48 b8 b0 21 80 00 00 	movabs $0x8021b0,%rax
  802821:	00 00 00 
  802824:	ff d0                	callq  *%rax
  802826:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802829:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80282d:	79 05                	jns    802834 <seek+0x34>
		return r;
  80282f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802832:	eb 0f                	jmp    802843 <seek+0x43>
	fd->fd_offset = offset;
  802834:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802838:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80283b:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80283e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802843:	c9                   	leaveq 
  802844:	c3                   	retq   

0000000000802845 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802845:	55                   	push   %rbp
  802846:	48 89 e5             	mov    %rsp,%rbp
  802849:	48 83 ec 30          	sub    $0x30,%rsp
  80284d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802850:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802853:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802857:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80285a:	48 89 d6             	mov    %rdx,%rsi
  80285d:	89 c7                	mov    %eax,%edi
  80285f:	48 b8 b0 21 80 00 00 	movabs $0x8021b0,%rax
  802866:	00 00 00 
  802869:	ff d0                	callq  *%rax
  80286b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80286e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802872:	78 24                	js     802898 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802874:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802878:	8b 00                	mov    (%rax),%eax
  80287a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80287e:	48 89 d6             	mov    %rdx,%rsi
  802881:	89 c7                	mov    %eax,%edi
  802883:	48 b8 09 23 80 00 00 	movabs $0x802309,%rax
  80288a:	00 00 00 
  80288d:	ff d0                	callq  *%rax
  80288f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802892:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802896:	79 05                	jns    80289d <ftruncate+0x58>
		return r;
  802898:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80289b:	eb 72                	jmp    80290f <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80289d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028a1:	8b 40 08             	mov    0x8(%rax),%eax
  8028a4:	83 e0 03             	and    $0x3,%eax
  8028a7:	85 c0                	test   %eax,%eax
  8028a9:	75 3a                	jne    8028e5 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8028ab:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  8028b2:	00 00 00 
  8028b5:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8028b8:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8028be:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8028c1:	89 c6                	mov    %eax,%esi
  8028c3:	48 bf c8 49 80 00 00 	movabs $0x8049c8,%rdi
  8028ca:	00 00 00 
  8028cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8028d2:	48 b9 79 09 80 00 00 	movabs $0x800979,%rcx
  8028d9:	00 00 00 
  8028dc:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8028de:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028e3:	eb 2a                	jmp    80290f <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8028e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028e9:	48 8b 40 30          	mov    0x30(%rax),%rax
  8028ed:	48 85 c0             	test   %rax,%rax
  8028f0:	75 07                	jne    8028f9 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8028f2:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8028f7:	eb 16                	jmp    80290f <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8028f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028fd:	48 8b 40 30          	mov    0x30(%rax),%rax
  802901:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802905:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802908:	89 ce                	mov    %ecx,%esi
  80290a:	48 89 d7             	mov    %rdx,%rdi
  80290d:	ff d0                	callq  *%rax
}
  80290f:	c9                   	leaveq 
  802910:	c3                   	retq   

0000000000802911 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802911:	55                   	push   %rbp
  802912:	48 89 e5             	mov    %rsp,%rbp
  802915:	48 83 ec 30          	sub    $0x30,%rsp
  802919:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80291c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802920:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802924:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802927:	48 89 d6             	mov    %rdx,%rsi
  80292a:	89 c7                	mov    %eax,%edi
  80292c:	48 b8 b0 21 80 00 00 	movabs $0x8021b0,%rax
  802933:	00 00 00 
  802936:	ff d0                	callq  *%rax
  802938:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80293b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80293f:	78 24                	js     802965 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802941:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802945:	8b 00                	mov    (%rax),%eax
  802947:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80294b:	48 89 d6             	mov    %rdx,%rsi
  80294e:	89 c7                	mov    %eax,%edi
  802950:	48 b8 09 23 80 00 00 	movabs $0x802309,%rax
  802957:	00 00 00 
  80295a:	ff d0                	callq  *%rax
  80295c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80295f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802963:	79 05                	jns    80296a <fstat+0x59>
		return r;
  802965:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802968:	eb 5e                	jmp    8029c8 <fstat+0xb7>
	if (!dev->dev_stat)
  80296a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80296e:	48 8b 40 28          	mov    0x28(%rax),%rax
  802972:	48 85 c0             	test   %rax,%rax
  802975:	75 07                	jne    80297e <fstat+0x6d>
		return -E_NOT_SUPP;
  802977:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80297c:	eb 4a                	jmp    8029c8 <fstat+0xb7>
	stat->st_name[0] = 0;
  80297e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802982:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802985:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802989:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802990:	00 00 00 
	stat->st_isdir = 0;
  802993:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802997:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80299e:	00 00 00 
	stat->st_dev = dev;
  8029a1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8029a5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8029a9:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8029b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029b4:	48 8b 40 28          	mov    0x28(%rax),%rax
  8029b8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8029bc:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8029c0:	48 89 ce             	mov    %rcx,%rsi
  8029c3:	48 89 d7             	mov    %rdx,%rdi
  8029c6:	ff d0                	callq  *%rax
}
  8029c8:	c9                   	leaveq 
  8029c9:	c3                   	retq   

00000000008029ca <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8029ca:	55                   	push   %rbp
  8029cb:	48 89 e5             	mov    %rsp,%rbp
  8029ce:	48 83 ec 20          	sub    $0x20,%rsp
  8029d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029d6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8029da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029de:	be 00 00 00 00       	mov    $0x0,%esi
  8029e3:	48 89 c7             	mov    %rax,%rdi
  8029e6:	48 b8 b8 2a 80 00 00 	movabs $0x802ab8,%rax
  8029ed:	00 00 00 
  8029f0:	ff d0                	callq  *%rax
  8029f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029f9:	79 05                	jns    802a00 <stat+0x36>
		return fd;
  8029fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029fe:	eb 2f                	jmp    802a2f <stat+0x65>
	r = fstat(fd, stat);
  802a00:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802a04:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a07:	48 89 d6             	mov    %rdx,%rsi
  802a0a:	89 c7                	mov    %eax,%edi
  802a0c:	48 b8 11 29 80 00 00 	movabs $0x802911,%rax
  802a13:	00 00 00 
  802a16:	ff d0                	callq  *%rax
  802a18:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802a1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a1e:	89 c7                	mov    %eax,%edi
  802a20:	48 b8 c0 23 80 00 00 	movabs $0x8023c0,%rax
  802a27:	00 00 00 
  802a2a:	ff d0                	callq  *%rax
	return r;
  802a2c:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802a2f:	c9                   	leaveq 
  802a30:	c3                   	retq   

0000000000802a31 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802a31:	55                   	push   %rbp
  802a32:	48 89 e5             	mov    %rsp,%rbp
  802a35:	48 83 ec 10          	sub    $0x10,%rsp
  802a39:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802a3c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802a40:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a47:	00 00 00 
  802a4a:	8b 00                	mov    (%rax),%eax
  802a4c:	85 c0                	test   %eax,%eax
  802a4e:	75 1d                	jne    802a6d <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802a50:	bf 01 00 00 00       	mov    $0x1,%edi
  802a55:	48 b8 15 42 80 00 00 	movabs $0x804215,%rax
  802a5c:	00 00 00 
  802a5f:	ff d0                	callq  *%rax
  802a61:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802a68:	00 00 00 
  802a6b:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802a6d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a74:	00 00 00 
  802a77:	8b 00                	mov    (%rax),%eax
  802a79:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802a7c:	b9 07 00 00 00       	mov    $0x7,%ecx
  802a81:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  802a88:	00 00 00 
  802a8b:	89 c7                	mov    %eax,%edi
  802a8d:	48 b8 b3 41 80 00 00 	movabs $0x8041b3,%rax
  802a94:	00 00 00 
  802a97:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802a99:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a9d:	ba 00 00 00 00       	mov    $0x0,%edx
  802aa2:	48 89 c6             	mov    %rax,%rsi
  802aa5:	bf 00 00 00 00       	mov    $0x0,%edi
  802aaa:	48 b8 ad 40 80 00 00 	movabs $0x8040ad,%rax
  802ab1:	00 00 00 
  802ab4:	ff d0                	callq  *%rax
}
  802ab6:	c9                   	leaveq 
  802ab7:	c3                   	retq   

0000000000802ab8 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802ab8:	55                   	push   %rbp
  802ab9:	48 89 e5             	mov    %rsp,%rbp
  802abc:	48 83 ec 30          	sub    $0x30,%rsp
  802ac0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802ac4:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802ac7:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802ace:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802ad5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802adc:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802ae1:	75 08                	jne    802aeb <open+0x33>
	{
		return r;
  802ae3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ae6:	e9 f2 00 00 00       	jmpq   802bdd <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802aeb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802aef:	48 89 c7             	mov    %rax,%rdi
  802af2:	48 b8 c2 14 80 00 00 	movabs $0x8014c2,%rax
  802af9:	00 00 00 
  802afc:	ff d0                	callq  *%rax
  802afe:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802b01:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802b08:	7e 0a                	jle    802b14 <open+0x5c>
	{
		return -E_BAD_PATH;
  802b0a:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802b0f:	e9 c9 00 00 00       	jmpq   802bdd <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802b14:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802b1b:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802b1c:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802b20:	48 89 c7             	mov    %rax,%rdi
  802b23:	48 b8 18 21 80 00 00 	movabs $0x802118,%rax
  802b2a:	00 00 00 
  802b2d:	ff d0                	callq  *%rax
  802b2f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b32:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b36:	78 09                	js     802b41 <open+0x89>
  802b38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b3c:	48 85 c0             	test   %rax,%rax
  802b3f:	75 08                	jne    802b49 <open+0x91>
		{
			return r;
  802b41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b44:	e9 94 00 00 00       	jmpq   802bdd <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802b49:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b4d:	ba 00 04 00 00       	mov    $0x400,%edx
  802b52:	48 89 c6             	mov    %rax,%rsi
  802b55:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  802b5c:	00 00 00 
  802b5f:	48 b8 c0 15 80 00 00 	movabs $0x8015c0,%rax
  802b66:	00 00 00 
  802b69:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802b6b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802b72:	00 00 00 
  802b75:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802b78:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802b7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b82:	48 89 c6             	mov    %rax,%rsi
  802b85:	bf 01 00 00 00       	mov    $0x1,%edi
  802b8a:	48 b8 31 2a 80 00 00 	movabs $0x802a31,%rax
  802b91:	00 00 00 
  802b94:	ff d0                	callq  *%rax
  802b96:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b99:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b9d:	79 2b                	jns    802bca <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802b9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ba3:	be 00 00 00 00       	mov    $0x0,%esi
  802ba8:	48 89 c7             	mov    %rax,%rdi
  802bab:	48 b8 40 22 80 00 00 	movabs $0x802240,%rax
  802bb2:	00 00 00 
  802bb5:	ff d0                	callq  *%rax
  802bb7:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802bba:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802bbe:	79 05                	jns    802bc5 <open+0x10d>
			{
				return d;
  802bc0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bc3:	eb 18                	jmp    802bdd <open+0x125>
			}
			return r;
  802bc5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bc8:	eb 13                	jmp    802bdd <open+0x125>
		}	
		return fd2num(fd_store);
  802bca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bce:	48 89 c7             	mov    %rax,%rdi
  802bd1:	48 b8 ca 20 80 00 00 	movabs $0x8020ca,%rax
  802bd8:	00 00 00 
  802bdb:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802bdd:	c9                   	leaveq 
  802bde:	c3                   	retq   

0000000000802bdf <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802bdf:	55                   	push   %rbp
  802be0:	48 89 e5             	mov    %rsp,%rbp
  802be3:	48 83 ec 10          	sub    $0x10,%rsp
  802be7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802beb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bef:	8b 50 0c             	mov    0xc(%rax),%edx
  802bf2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802bf9:	00 00 00 
  802bfc:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802bfe:	be 00 00 00 00       	mov    $0x0,%esi
  802c03:	bf 06 00 00 00       	mov    $0x6,%edi
  802c08:	48 b8 31 2a 80 00 00 	movabs $0x802a31,%rax
  802c0f:	00 00 00 
  802c12:	ff d0                	callq  *%rax
}
  802c14:	c9                   	leaveq 
  802c15:	c3                   	retq   

0000000000802c16 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802c16:	55                   	push   %rbp
  802c17:	48 89 e5             	mov    %rsp,%rbp
  802c1a:	48 83 ec 30          	sub    $0x30,%rsp
  802c1e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c22:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c26:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802c2a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802c31:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802c36:	74 07                	je     802c3f <devfile_read+0x29>
  802c38:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802c3d:	75 07                	jne    802c46 <devfile_read+0x30>
		return -E_INVAL;
  802c3f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c44:	eb 77                	jmp    802cbd <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802c46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c4a:	8b 50 0c             	mov    0xc(%rax),%edx
  802c4d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802c54:	00 00 00 
  802c57:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802c59:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802c60:	00 00 00 
  802c63:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802c67:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802c6b:	be 00 00 00 00       	mov    $0x0,%esi
  802c70:	bf 03 00 00 00       	mov    $0x3,%edi
  802c75:	48 b8 31 2a 80 00 00 	movabs $0x802a31,%rax
  802c7c:	00 00 00 
  802c7f:	ff d0                	callq  *%rax
  802c81:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c84:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c88:	7f 05                	jg     802c8f <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802c8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c8d:	eb 2e                	jmp    802cbd <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802c8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c92:	48 63 d0             	movslq %eax,%rdx
  802c95:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c99:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  802ca0:	00 00 00 
  802ca3:	48 89 c7             	mov    %rax,%rdi
  802ca6:	48 b8 52 18 80 00 00 	movabs $0x801852,%rax
  802cad:	00 00 00 
  802cb0:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802cb2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cb6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802cba:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802cbd:	c9                   	leaveq 
  802cbe:	c3                   	retq   

0000000000802cbf <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802cbf:	55                   	push   %rbp
  802cc0:	48 89 e5             	mov    %rsp,%rbp
  802cc3:	48 83 ec 30          	sub    $0x30,%rsp
  802cc7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ccb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ccf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802cd3:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802cda:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802cdf:	74 07                	je     802ce8 <devfile_write+0x29>
  802ce1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802ce6:	75 08                	jne    802cf0 <devfile_write+0x31>
		return r;
  802ce8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ceb:	e9 9a 00 00 00       	jmpq   802d8a <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802cf0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cf4:	8b 50 0c             	mov    0xc(%rax),%edx
  802cf7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802cfe:	00 00 00 
  802d01:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802d03:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802d0a:	00 
  802d0b:	76 08                	jbe    802d15 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802d0d:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802d14:	00 
	}
	fsipcbuf.write.req_n = n;
  802d15:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802d1c:	00 00 00 
  802d1f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d23:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802d27:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d2b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d2f:	48 89 c6             	mov    %rax,%rsi
  802d32:	48 bf 10 a0 80 00 00 	movabs $0x80a010,%rdi
  802d39:	00 00 00 
  802d3c:	48 b8 52 18 80 00 00 	movabs $0x801852,%rax
  802d43:	00 00 00 
  802d46:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802d48:	be 00 00 00 00       	mov    $0x0,%esi
  802d4d:	bf 04 00 00 00       	mov    $0x4,%edi
  802d52:	48 b8 31 2a 80 00 00 	movabs $0x802a31,%rax
  802d59:	00 00 00 
  802d5c:	ff d0                	callq  *%rax
  802d5e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d61:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d65:	7f 20                	jg     802d87 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802d67:	48 bf ee 49 80 00 00 	movabs $0x8049ee,%rdi
  802d6e:	00 00 00 
  802d71:	b8 00 00 00 00       	mov    $0x0,%eax
  802d76:	48 ba 79 09 80 00 00 	movabs $0x800979,%rdx
  802d7d:	00 00 00 
  802d80:	ff d2                	callq  *%rdx
		return r;
  802d82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d85:	eb 03                	jmp    802d8a <devfile_write+0xcb>
	}
	return r;
  802d87:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802d8a:	c9                   	leaveq 
  802d8b:	c3                   	retq   

0000000000802d8c <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802d8c:	55                   	push   %rbp
  802d8d:	48 89 e5             	mov    %rsp,%rbp
  802d90:	48 83 ec 20          	sub    $0x20,%rsp
  802d94:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d98:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802d9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802da0:	8b 50 0c             	mov    0xc(%rax),%edx
  802da3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802daa:	00 00 00 
  802dad:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802daf:	be 00 00 00 00       	mov    $0x0,%esi
  802db4:	bf 05 00 00 00       	mov    $0x5,%edi
  802db9:	48 b8 31 2a 80 00 00 	movabs $0x802a31,%rax
  802dc0:	00 00 00 
  802dc3:	ff d0                	callq  *%rax
  802dc5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dc8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dcc:	79 05                	jns    802dd3 <devfile_stat+0x47>
		return r;
  802dce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dd1:	eb 56                	jmp    802e29 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802dd3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802dd7:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  802dde:	00 00 00 
  802de1:	48 89 c7             	mov    %rax,%rdi
  802de4:	48 b8 2e 15 80 00 00 	movabs $0x80152e,%rax
  802deb:	00 00 00 
  802dee:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802df0:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802df7:	00 00 00 
  802dfa:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802e00:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e04:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802e0a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802e11:	00 00 00 
  802e14:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802e1a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e1e:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802e24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e29:	c9                   	leaveq 
  802e2a:	c3                   	retq   

0000000000802e2b <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802e2b:	55                   	push   %rbp
  802e2c:	48 89 e5             	mov    %rsp,%rbp
  802e2f:	48 83 ec 10          	sub    $0x10,%rsp
  802e33:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e37:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802e3a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e3e:	8b 50 0c             	mov    0xc(%rax),%edx
  802e41:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802e48:	00 00 00 
  802e4b:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802e4d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802e54:	00 00 00 
  802e57:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802e5a:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802e5d:	be 00 00 00 00       	mov    $0x0,%esi
  802e62:	bf 02 00 00 00       	mov    $0x2,%edi
  802e67:	48 b8 31 2a 80 00 00 	movabs $0x802a31,%rax
  802e6e:	00 00 00 
  802e71:	ff d0                	callq  *%rax
}
  802e73:	c9                   	leaveq 
  802e74:	c3                   	retq   

0000000000802e75 <remove>:

// Delete a file
int
remove(const char *path)
{
  802e75:	55                   	push   %rbp
  802e76:	48 89 e5             	mov    %rsp,%rbp
  802e79:	48 83 ec 10          	sub    $0x10,%rsp
  802e7d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802e81:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e85:	48 89 c7             	mov    %rax,%rdi
  802e88:	48 b8 c2 14 80 00 00 	movabs $0x8014c2,%rax
  802e8f:	00 00 00 
  802e92:	ff d0                	callq  *%rax
  802e94:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802e99:	7e 07                	jle    802ea2 <remove+0x2d>
		return -E_BAD_PATH;
  802e9b:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802ea0:	eb 33                	jmp    802ed5 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802ea2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ea6:	48 89 c6             	mov    %rax,%rsi
  802ea9:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  802eb0:	00 00 00 
  802eb3:	48 b8 2e 15 80 00 00 	movabs $0x80152e,%rax
  802eba:	00 00 00 
  802ebd:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802ebf:	be 00 00 00 00       	mov    $0x0,%esi
  802ec4:	bf 07 00 00 00       	mov    $0x7,%edi
  802ec9:	48 b8 31 2a 80 00 00 	movabs $0x802a31,%rax
  802ed0:	00 00 00 
  802ed3:	ff d0                	callq  *%rax
}
  802ed5:	c9                   	leaveq 
  802ed6:	c3                   	retq   

0000000000802ed7 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802ed7:	55                   	push   %rbp
  802ed8:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802edb:	be 00 00 00 00       	mov    $0x0,%esi
  802ee0:	bf 08 00 00 00       	mov    $0x8,%edi
  802ee5:	48 b8 31 2a 80 00 00 	movabs $0x802a31,%rax
  802eec:	00 00 00 
  802eef:	ff d0                	callq  *%rax
}
  802ef1:	5d                   	pop    %rbp
  802ef2:	c3                   	retq   

0000000000802ef3 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802ef3:	55                   	push   %rbp
  802ef4:	48 89 e5             	mov    %rsp,%rbp
  802ef7:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  802efe:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  802f05:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802f0c:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  802f13:	be 00 00 00 00       	mov    $0x0,%esi
  802f18:	48 89 c7             	mov    %rax,%rdi
  802f1b:	48 b8 b8 2a 80 00 00 	movabs $0x802ab8,%rax
  802f22:	00 00 00 
  802f25:	ff d0                	callq  *%rax
  802f27:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802f2a:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802f2e:	79 08                	jns    802f38 <spawn+0x45>
		return r;
  802f30:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802f33:	e9 14 03 00 00       	jmpq   80324c <spawn+0x359>
	fd = r;
  802f38:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802f3b:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  802f3e:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  802f45:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802f49:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  802f50:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802f53:	ba 00 02 00 00       	mov    $0x200,%edx
  802f58:	48 89 ce             	mov    %rcx,%rsi
  802f5b:	89 c7                	mov    %eax,%edi
  802f5d:	48 b8 b7 26 80 00 00 	movabs $0x8026b7,%rax
  802f64:	00 00 00 
  802f67:	ff d0                	callq  *%rax
  802f69:	3d 00 02 00 00       	cmp    $0x200,%eax
  802f6e:	75 0d                	jne    802f7d <spawn+0x8a>
	    || elf->e_magic != ELF_MAGIC) {
  802f70:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f74:	8b 00                	mov    (%rax),%eax
  802f76:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  802f7b:	74 43                	je     802fc0 <spawn+0xcd>
		close(fd);
  802f7d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802f80:	89 c7                	mov    %eax,%edi
  802f82:	48 b8 c0 23 80 00 00 	movabs $0x8023c0,%rax
  802f89:	00 00 00 
  802f8c:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802f8e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f92:	8b 00                	mov    (%rax),%eax
  802f94:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  802f99:	89 c6                	mov    %eax,%esi
  802f9b:	48 bf 10 4a 80 00 00 	movabs $0x804a10,%rdi
  802fa2:	00 00 00 
  802fa5:	b8 00 00 00 00       	mov    $0x0,%eax
  802faa:	48 b9 79 09 80 00 00 	movabs $0x800979,%rcx
  802fb1:	00 00 00 
  802fb4:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  802fb6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802fbb:	e9 8c 02 00 00       	jmpq   80324c <spawn+0x359>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802fc0:	b8 07 00 00 00       	mov    $0x7,%eax
  802fc5:	cd 30                	int    $0x30
  802fc7:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802fca:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802fcd:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802fd0:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802fd4:	79 08                	jns    802fde <spawn+0xeb>
		return r;
  802fd6:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802fd9:	e9 6e 02 00 00       	jmpq   80324c <spawn+0x359>
	child = r;
  802fde:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802fe1:	89 45 d4             	mov    %eax,-0x2c(%rbp)
	//thisenv = &envs[ENVX(sys_getenvid())];
	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802fe4:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802fe7:	25 ff 03 00 00       	and    $0x3ff,%eax
  802fec:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802ff3:	00 00 00 
  802ff6:	48 63 d0             	movslq %eax,%rdx
  802ff9:	48 89 d0             	mov    %rdx,%rax
  802ffc:	48 c1 e0 03          	shl    $0x3,%rax
  803000:	48 01 d0             	add    %rdx,%rax
  803003:	48 c1 e0 05          	shl    $0x5,%rax
  803007:	48 01 c8             	add    %rcx,%rax
  80300a:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  803011:	48 89 c6             	mov    %rax,%rsi
  803014:	b8 18 00 00 00       	mov    $0x18,%eax
  803019:	48 89 d7             	mov    %rdx,%rdi
  80301c:	48 89 c1             	mov    %rax,%rcx
  80301f:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  803022:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803026:	48 8b 40 18          	mov    0x18(%rax),%rax
  80302a:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  803031:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  803038:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  80303f:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  803046:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803049:	48 89 ce             	mov    %rcx,%rsi
  80304c:	89 c7                	mov    %eax,%edi
  80304e:	48 b8 b6 34 80 00 00 	movabs $0x8034b6,%rax
  803055:	00 00 00 
  803058:	ff d0                	callq  *%rax
  80305a:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80305d:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803061:	79 08                	jns    80306b <spawn+0x178>
		return r;
  803063:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803066:	e9 e1 01 00 00       	jmpq   80324c <spawn+0x359>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  80306b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80306f:	48 8b 40 20          	mov    0x20(%rax),%rax
  803073:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  80307a:	48 01 d0             	add    %rdx,%rax
  80307d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  803081:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803088:	e9 a3 00 00 00       	jmpq   803130 <spawn+0x23d>
		if (ph->p_type != ELF_PROG_LOAD)
  80308d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803091:	8b 00                	mov    (%rax),%eax
  803093:	83 f8 01             	cmp    $0x1,%eax
  803096:	74 05                	je     80309d <spawn+0x1aa>
			continue;
  803098:	e9 8a 00 00 00       	jmpq   803127 <spawn+0x234>
		perm = PTE_P | PTE_U;
  80309d:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  8030a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030a8:	8b 40 04             	mov    0x4(%rax),%eax
  8030ab:	83 e0 02             	and    $0x2,%eax
  8030ae:	85 c0                	test   %eax,%eax
  8030b0:	74 04                	je     8030b6 <spawn+0x1c3>
			perm |= PTE_W;
  8030b2:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  8030b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030ba:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  8030be:	41 89 c1             	mov    %eax,%r9d
  8030c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030c5:	4c 8b 40 20          	mov    0x20(%rax),%r8
  8030c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030cd:	48 8b 50 28          	mov    0x28(%rax),%rdx
  8030d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030d5:	48 8b 70 10          	mov    0x10(%rax),%rsi
  8030d9:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8030dc:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8030df:	8b 7d ec             	mov    -0x14(%rbp),%edi
  8030e2:	89 3c 24             	mov    %edi,(%rsp)
  8030e5:	89 c7                	mov    %eax,%edi
  8030e7:	48 b8 5f 37 80 00 00 	movabs $0x80375f,%rax
  8030ee:	00 00 00 
  8030f1:	ff d0                	callq  *%rax
  8030f3:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8030f6:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8030fa:	79 2b                	jns    803127 <spawn+0x234>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  8030fc:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  8030fd:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803100:	89 c7                	mov    %eax,%edi
  803102:	48 b8 9d 1d 80 00 00 	movabs $0x801d9d,%rax
  803109:	00 00 00 
  80310c:	ff d0                	callq  *%rax
	close(fd);
  80310e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803111:	89 c7                	mov    %eax,%edi
  803113:	48 b8 c0 23 80 00 00 	movabs $0x8023c0,%rax
  80311a:	00 00 00 
  80311d:	ff d0                	callq  *%rax
	return r;
  80311f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803122:	e9 25 01 00 00       	jmpq   80324c <spawn+0x359>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  803127:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80312b:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  803130:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803134:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  803138:	0f b7 c0             	movzwl %ax,%eax
  80313b:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  80313e:	0f 8f 49 ff ff ff    	jg     80308d <spawn+0x19a>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  803144:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803147:	89 c7                	mov    %eax,%edi
  803149:	48 b8 c0 23 80 00 00 	movabs $0x8023c0,%rax
  803150:	00 00 00 
  803153:	ff d0                	callq  *%rax
	fd = -1;
  803155:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  80315c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80315f:	89 c7                	mov    %eax,%edi
  803161:	48 b8 4b 39 80 00 00 	movabs $0x80394b,%rax
  803168:	00 00 00 
  80316b:	ff d0                	callq  *%rax
  80316d:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803170:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803174:	79 30                	jns    8031a6 <spawn+0x2b3>
		panic("copy_shared_pages: %e", r);
  803176:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803179:	89 c1                	mov    %eax,%ecx
  80317b:	48 ba 2a 4a 80 00 00 	movabs $0x804a2a,%rdx
  803182:	00 00 00 
  803185:	be 82 00 00 00       	mov    $0x82,%esi
  80318a:	48 bf 40 4a 80 00 00 	movabs $0x804a40,%rdi
  803191:	00 00 00 
  803194:	b8 00 00 00 00       	mov    $0x0,%eax
  803199:	49 b8 40 07 80 00 00 	movabs $0x800740,%r8
  8031a0:	00 00 00 
  8031a3:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8031a6:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  8031ad:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8031b0:	48 89 d6             	mov    %rdx,%rsi
  8031b3:	89 c7                	mov    %eax,%edi
  8031b5:	48 b8 9d 1f 80 00 00 	movabs $0x801f9d,%rax
  8031bc:	00 00 00 
  8031bf:	ff d0                	callq  *%rax
  8031c1:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8031c4:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8031c8:	79 30                	jns    8031fa <spawn+0x307>
		panic("sys_env_set_trapframe: %e", r);
  8031ca:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8031cd:	89 c1                	mov    %eax,%ecx
  8031cf:	48 ba 4c 4a 80 00 00 	movabs $0x804a4c,%rdx
  8031d6:	00 00 00 
  8031d9:	be 85 00 00 00       	mov    $0x85,%esi
  8031de:	48 bf 40 4a 80 00 00 	movabs $0x804a40,%rdi
  8031e5:	00 00 00 
  8031e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8031ed:	49 b8 40 07 80 00 00 	movabs $0x800740,%r8
  8031f4:	00 00 00 
  8031f7:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  8031fa:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8031fd:	be 02 00 00 00       	mov    $0x2,%esi
  803202:	89 c7                	mov    %eax,%edi
  803204:	48 b8 52 1f 80 00 00 	movabs $0x801f52,%rax
  80320b:	00 00 00 
  80320e:	ff d0                	callq  *%rax
  803210:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803213:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803217:	79 30                	jns    803249 <spawn+0x356>
		panic("sys_env_set_status: %e", r);
  803219:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80321c:	89 c1                	mov    %eax,%ecx
  80321e:	48 ba 66 4a 80 00 00 	movabs $0x804a66,%rdx
  803225:	00 00 00 
  803228:	be 88 00 00 00       	mov    $0x88,%esi
  80322d:	48 bf 40 4a 80 00 00 	movabs $0x804a40,%rdi
  803234:	00 00 00 
  803237:	b8 00 00 00 00       	mov    $0x0,%eax
  80323c:	49 b8 40 07 80 00 00 	movabs $0x800740,%r8
  803243:	00 00 00 
  803246:	41 ff d0             	callq  *%r8

	return child;
  803249:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  80324c:	c9                   	leaveq 
  80324d:	c3                   	retq   

000000000080324e <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  80324e:	55                   	push   %rbp
  80324f:	48 89 e5             	mov    %rsp,%rbp
  803252:	41 55                	push   %r13
  803254:	41 54                	push   %r12
  803256:	53                   	push   %rbx
  803257:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80325e:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  803265:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  80326c:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  803273:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  80327a:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  803281:	84 c0                	test   %al,%al
  803283:	74 26                	je     8032ab <spawnl+0x5d>
  803285:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  80328c:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  803293:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  803297:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  80329b:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  80329f:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  8032a3:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  8032a7:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  8032ab:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  8032b2:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  8032b9:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  8032bc:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  8032c3:	00 00 00 
  8032c6:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  8032cd:	00 00 00 
  8032d0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8032d4:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  8032db:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  8032e2:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  8032e9:	eb 07                	jmp    8032f2 <spawnl+0xa4>
		argc++;
  8032eb:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8032f2:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  8032f8:	83 f8 30             	cmp    $0x30,%eax
  8032fb:	73 23                	jae    803320 <spawnl+0xd2>
  8032fd:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  803304:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  80330a:	89 c0                	mov    %eax,%eax
  80330c:	48 01 d0             	add    %rdx,%rax
  80330f:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803315:	83 c2 08             	add    $0x8,%edx
  803318:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  80331e:	eb 15                	jmp    803335 <spawnl+0xe7>
  803320:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  803327:	48 89 d0             	mov    %rdx,%rax
  80332a:	48 83 c2 08          	add    $0x8,%rdx
  80332e:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803335:	48 8b 00             	mov    (%rax),%rax
  803338:	48 85 c0             	test   %rax,%rax
  80333b:	75 ae                	jne    8032eb <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  80333d:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803343:	83 c0 02             	add    $0x2,%eax
  803346:	48 89 e2             	mov    %rsp,%rdx
  803349:	48 89 d3             	mov    %rdx,%rbx
  80334c:	48 63 d0             	movslq %eax,%rdx
  80334f:	48 83 ea 01          	sub    $0x1,%rdx
  803353:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  80335a:	48 63 d0             	movslq %eax,%rdx
  80335d:	49 89 d4             	mov    %rdx,%r12
  803360:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  803366:	48 63 d0             	movslq %eax,%rdx
  803369:	49 89 d2             	mov    %rdx,%r10
  80336c:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  803372:	48 98                	cltq   
  803374:	48 c1 e0 03          	shl    $0x3,%rax
  803378:	48 8d 50 07          	lea    0x7(%rax),%rdx
  80337c:	b8 10 00 00 00       	mov    $0x10,%eax
  803381:	48 83 e8 01          	sub    $0x1,%rax
  803385:	48 01 d0             	add    %rdx,%rax
  803388:	bf 10 00 00 00       	mov    $0x10,%edi
  80338d:	ba 00 00 00 00       	mov    $0x0,%edx
  803392:	48 f7 f7             	div    %rdi
  803395:	48 6b c0 10          	imul   $0x10,%rax,%rax
  803399:	48 29 c4             	sub    %rax,%rsp
  80339c:	48 89 e0             	mov    %rsp,%rax
  80339f:	48 83 c0 07          	add    $0x7,%rax
  8033a3:	48 c1 e8 03          	shr    $0x3,%rax
  8033a7:	48 c1 e0 03          	shl    $0x3,%rax
  8033ab:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  8033b2:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8033b9:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  8033c0:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  8033c3:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8033c9:	8d 50 01             	lea    0x1(%rax),%edx
  8033cc:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8033d3:	48 63 d2             	movslq %edx,%rdx
  8033d6:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  8033dd:	00 

	va_start(vl, arg0);
  8033de:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  8033e5:	00 00 00 
  8033e8:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  8033ef:	00 00 00 
  8033f2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8033f6:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  8033fd:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803404:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  80340b:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  803412:	00 00 00 
  803415:	eb 63                	jmp    80347a <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  803417:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  80341d:	8d 70 01             	lea    0x1(%rax),%esi
  803420:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803426:	83 f8 30             	cmp    $0x30,%eax
  803429:	73 23                	jae    80344e <spawnl+0x200>
  80342b:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  803432:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803438:	89 c0                	mov    %eax,%eax
  80343a:	48 01 d0             	add    %rdx,%rax
  80343d:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803443:	83 c2 08             	add    $0x8,%edx
  803446:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  80344c:	eb 15                	jmp    803463 <spawnl+0x215>
  80344e:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  803455:	48 89 d0             	mov    %rdx,%rax
  803458:	48 83 c2 08          	add    $0x8,%rdx
  80345c:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803463:	48 8b 08             	mov    (%rax),%rcx
  803466:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80346d:	89 f2                	mov    %esi,%edx
  80346f:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  803473:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  80347a:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803480:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  803486:	77 8f                	ja     803417 <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  803488:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80348f:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  803496:	48 89 d6             	mov    %rdx,%rsi
  803499:	48 89 c7             	mov    %rax,%rdi
  80349c:	48 b8 f3 2e 80 00 00 	movabs $0x802ef3,%rax
  8034a3:	00 00 00 
  8034a6:	ff d0                	callq  *%rax
  8034a8:	48 89 dc             	mov    %rbx,%rsp
}
  8034ab:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  8034af:	5b                   	pop    %rbx
  8034b0:	41 5c                	pop    %r12
  8034b2:	41 5d                	pop    %r13
  8034b4:	5d                   	pop    %rbp
  8034b5:	c3                   	retq   

00000000008034b6 <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  8034b6:	55                   	push   %rbp
  8034b7:	48 89 e5             	mov    %rsp,%rbp
  8034ba:	48 83 ec 50          	sub    $0x50,%rsp
  8034be:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8034c1:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8034c5:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  8034c9:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8034d0:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  8034d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  8034d8:	eb 33                	jmp    80350d <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  8034da:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8034dd:	48 98                	cltq   
  8034df:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8034e6:	00 
  8034e7:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8034eb:	48 01 d0             	add    %rdx,%rax
  8034ee:	48 8b 00             	mov    (%rax),%rax
  8034f1:	48 89 c7             	mov    %rax,%rdi
  8034f4:	48 b8 c2 14 80 00 00 	movabs $0x8014c2,%rax
  8034fb:	00 00 00 
  8034fe:	ff d0                	callq  *%rax
  803500:	83 c0 01             	add    $0x1,%eax
  803503:	48 98                	cltq   
  803505:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  803509:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  80350d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803510:	48 98                	cltq   
  803512:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803519:	00 
  80351a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80351e:	48 01 d0             	add    %rdx,%rax
  803521:	48 8b 00             	mov    (%rax),%rax
  803524:	48 85 c0             	test   %rax,%rax
  803527:	75 b1                	jne    8034da <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  803529:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80352d:	48 f7 d8             	neg    %rax
  803530:	48 05 00 10 40 00    	add    $0x401000,%rax
  803536:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  80353a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80353e:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803542:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803546:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  80354a:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80354d:	83 c2 01             	add    $0x1,%edx
  803550:	c1 e2 03             	shl    $0x3,%edx
  803553:	48 63 d2             	movslq %edx,%rdx
  803556:	48 f7 da             	neg    %rdx
  803559:	48 01 d0             	add    %rdx,%rax
  80355c:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  803560:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803564:	48 83 e8 10          	sub    $0x10,%rax
  803568:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  80356e:	77 0a                	ja     80357a <init_stack+0xc4>
		return -E_NO_MEM;
  803570:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  803575:	e9 e3 01 00 00       	jmpq   80375d <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80357a:	ba 07 00 00 00       	mov    $0x7,%edx
  80357f:	be 00 00 40 00       	mov    $0x400000,%esi
  803584:	bf 00 00 00 00       	mov    $0x0,%edi
  803589:	48 b8 5d 1e 80 00 00 	movabs $0x801e5d,%rax
  803590:	00 00 00 
  803593:	ff d0                	callq  *%rax
  803595:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803598:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80359c:	79 08                	jns    8035a6 <init_stack+0xf0>
		return r;
  80359e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035a1:	e9 b7 01 00 00       	jmpq   80375d <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8035a6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  8035ad:	e9 8a 00 00 00       	jmpq   80363c <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  8035b2:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8035b5:	48 98                	cltq   
  8035b7:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8035be:	00 
  8035bf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035c3:	48 01 c2             	add    %rax,%rdx
  8035c6:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8035cb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035cf:	48 01 c8             	add    %rcx,%rax
  8035d2:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  8035d8:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  8035db:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8035de:	48 98                	cltq   
  8035e0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8035e7:	00 
  8035e8:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8035ec:	48 01 d0             	add    %rdx,%rax
  8035ef:	48 8b 10             	mov    (%rax),%rdx
  8035f2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035f6:	48 89 d6             	mov    %rdx,%rsi
  8035f9:	48 89 c7             	mov    %rax,%rdi
  8035fc:	48 b8 2e 15 80 00 00 	movabs $0x80152e,%rax
  803603:	00 00 00 
  803606:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  803608:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80360b:	48 98                	cltq   
  80360d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803614:	00 
  803615:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803619:	48 01 d0             	add    %rdx,%rax
  80361c:	48 8b 00             	mov    (%rax),%rax
  80361f:	48 89 c7             	mov    %rax,%rdi
  803622:	48 b8 c2 14 80 00 00 	movabs $0x8014c2,%rax
  803629:	00 00 00 
  80362c:	ff d0                	callq  *%rax
  80362e:	48 98                	cltq   
  803630:	48 83 c0 01          	add    $0x1,%rax
  803634:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803638:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  80363c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80363f:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  803642:	0f 8c 6a ff ff ff    	jl     8035b2 <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  803648:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80364b:	48 98                	cltq   
  80364d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803654:	00 
  803655:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803659:	48 01 d0             	add    %rdx,%rax
  80365c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  803663:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  80366a:	00 
  80366b:	74 35                	je     8036a2 <init_stack+0x1ec>
  80366d:	48 b9 80 4a 80 00 00 	movabs $0x804a80,%rcx
  803674:	00 00 00 
  803677:	48 ba a6 4a 80 00 00 	movabs $0x804aa6,%rdx
  80367e:	00 00 00 
  803681:	be f1 00 00 00       	mov    $0xf1,%esi
  803686:	48 bf 40 4a 80 00 00 	movabs $0x804a40,%rdi
  80368d:	00 00 00 
  803690:	b8 00 00 00 00       	mov    $0x0,%eax
  803695:	49 b8 40 07 80 00 00 	movabs $0x800740,%r8
  80369c:	00 00 00 
  80369f:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8036a2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036a6:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  8036aa:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8036af:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036b3:	48 01 c8             	add    %rcx,%rax
  8036b6:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  8036bc:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  8036bf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036c3:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  8036c7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8036ca:	48 98                	cltq   
  8036cc:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  8036cf:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  8036d4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036d8:	48 01 d0             	add    %rdx,%rax
  8036db:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  8036e1:	48 89 c2             	mov    %rax,%rdx
  8036e4:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8036e8:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8036eb:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8036ee:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8036f4:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8036f9:	89 c2                	mov    %eax,%edx
  8036fb:	be 00 00 40 00       	mov    $0x400000,%esi
  803700:	bf 00 00 00 00       	mov    $0x0,%edi
  803705:	48 b8 ad 1e 80 00 00 	movabs $0x801ead,%rax
  80370c:	00 00 00 
  80370f:	ff d0                	callq  *%rax
  803711:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803714:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803718:	79 02                	jns    80371c <init_stack+0x266>
		goto error;
  80371a:	eb 28                	jmp    803744 <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  80371c:	be 00 00 40 00       	mov    $0x400000,%esi
  803721:	bf 00 00 00 00       	mov    $0x0,%edi
  803726:	48 b8 08 1f 80 00 00 	movabs $0x801f08,%rax
  80372d:	00 00 00 
  803730:	ff d0                	callq  *%rax
  803732:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803735:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803739:	79 02                	jns    80373d <init_stack+0x287>
		goto error;
  80373b:	eb 07                	jmp    803744 <init_stack+0x28e>

	return 0;
  80373d:	b8 00 00 00 00       	mov    $0x0,%eax
  803742:	eb 19                	jmp    80375d <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  803744:	be 00 00 40 00       	mov    $0x400000,%esi
  803749:	bf 00 00 00 00       	mov    $0x0,%edi
  80374e:	48 b8 08 1f 80 00 00 	movabs $0x801f08,%rax
  803755:	00 00 00 
  803758:	ff d0                	callq  *%rax
	return r;
  80375a:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80375d:	c9                   	leaveq 
  80375e:	c3                   	retq   

000000000080375f <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	int fd, size_t filesz, off_t fileoffset, int perm)
{
  80375f:	55                   	push   %rbp
  803760:	48 89 e5             	mov    %rsp,%rbp
  803763:	48 83 ec 50          	sub    $0x50,%rsp
  803767:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80376a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80376e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  803772:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  803775:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  803779:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  80377d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803781:	25 ff 0f 00 00       	and    $0xfff,%eax
  803786:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803789:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80378d:	74 21                	je     8037b0 <map_segment+0x51>
		va -= i;
  80378f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803792:	48 98                	cltq   
  803794:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  803798:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80379b:	48 98                	cltq   
  80379d:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  8037a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037a4:	48 98                	cltq   
  8037a6:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  8037aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037ad:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8037b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8037b7:	e9 79 01 00 00       	jmpq   803935 <map_segment+0x1d6>
		if (i >= filesz) {
  8037bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037bf:	48 98                	cltq   
  8037c1:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  8037c5:	72 3c                	jb     803803 <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8037c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037ca:	48 63 d0             	movslq %eax,%rdx
  8037cd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037d1:	48 01 d0             	add    %rdx,%rax
  8037d4:	48 89 c1             	mov    %rax,%rcx
  8037d7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8037da:	8b 55 10             	mov    0x10(%rbp),%edx
  8037dd:	48 89 ce             	mov    %rcx,%rsi
  8037e0:	89 c7                	mov    %eax,%edi
  8037e2:	48 b8 5d 1e 80 00 00 	movabs $0x801e5d,%rax
  8037e9:	00 00 00 
  8037ec:	ff d0                	callq  *%rax
  8037ee:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8037f1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8037f5:	0f 89 33 01 00 00    	jns    80392e <map_segment+0x1cf>
				return r;
  8037fb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8037fe:	e9 46 01 00 00       	jmpq   803949 <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803803:	ba 07 00 00 00       	mov    $0x7,%edx
  803808:	be 00 00 40 00       	mov    $0x400000,%esi
  80380d:	bf 00 00 00 00       	mov    $0x0,%edi
  803812:	48 b8 5d 1e 80 00 00 	movabs $0x801e5d,%rax
  803819:	00 00 00 
  80381c:	ff d0                	callq  *%rax
  80381e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803821:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803825:	79 08                	jns    80382f <map_segment+0xd0>
				return r;
  803827:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80382a:	e9 1a 01 00 00       	jmpq   803949 <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  80382f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803832:	8b 55 bc             	mov    -0x44(%rbp),%edx
  803835:	01 c2                	add    %eax,%edx
  803837:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80383a:	89 d6                	mov    %edx,%esi
  80383c:	89 c7                	mov    %eax,%edi
  80383e:	48 b8 00 28 80 00 00 	movabs $0x802800,%rax
  803845:	00 00 00 
  803848:	ff d0                	callq  *%rax
  80384a:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80384d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803851:	79 08                	jns    80385b <map_segment+0xfc>
				return r;
  803853:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803856:	e9 ee 00 00 00       	jmpq   803949 <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  80385b:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  803862:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803865:	48 98                	cltq   
  803867:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80386b:	48 29 c2             	sub    %rax,%rdx
  80386e:	48 89 d0             	mov    %rdx,%rax
  803871:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803875:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803878:	48 63 d0             	movslq %eax,%rdx
  80387b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80387f:	48 39 c2             	cmp    %rax,%rdx
  803882:	48 0f 47 d0          	cmova  %rax,%rdx
  803886:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803889:	be 00 00 40 00       	mov    $0x400000,%esi
  80388e:	89 c7                	mov    %eax,%edi
  803890:	48 b8 b7 26 80 00 00 	movabs $0x8026b7,%rax
  803897:	00 00 00 
  80389a:	ff d0                	callq  *%rax
  80389c:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80389f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8038a3:	79 08                	jns    8038ad <map_segment+0x14e>
				return r;
  8038a5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038a8:	e9 9c 00 00 00       	jmpq   803949 <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8038ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038b0:	48 63 d0             	movslq %eax,%rdx
  8038b3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038b7:	48 01 d0             	add    %rdx,%rax
  8038ba:	48 89 c2             	mov    %rax,%rdx
  8038bd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8038c0:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  8038c4:	48 89 d1             	mov    %rdx,%rcx
  8038c7:	89 c2                	mov    %eax,%edx
  8038c9:	be 00 00 40 00       	mov    $0x400000,%esi
  8038ce:	bf 00 00 00 00       	mov    $0x0,%edi
  8038d3:	48 b8 ad 1e 80 00 00 	movabs $0x801ead,%rax
  8038da:	00 00 00 
  8038dd:	ff d0                	callq  *%rax
  8038df:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8038e2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8038e6:	79 30                	jns    803918 <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  8038e8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038eb:	89 c1                	mov    %eax,%ecx
  8038ed:	48 ba bb 4a 80 00 00 	movabs $0x804abb,%rdx
  8038f4:	00 00 00 
  8038f7:	be 24 01 00 00       	mov    $0x124,%esi
  8038fc:	48 bf 40 4a 80 00 00 	movabs $0x804a40,%rdi
  803903:	00 00 00 
  803906:	b8 00 00 00 00       	mov    $0x0,%eax
  80390b:	49 b8 40 07 80 00 00 	movabs $0x800740,%r8
  803912:	00 00 00 
  803915:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  803918:	be 00 00 40 00       	mov    $0x400000,%esi
  80391d:	bf 00 00 00 00       	mov    $0x0,%edi
  803922:	48 b8 08 1f 80 00 00 	movabs $0x801f08,%rax
  803929:	00 00 00 
  80392c:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80392e:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  803935:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803938:	48 98                	cltq   
  80393a:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80393e:	0f 82 78 fe ff ff    	jb     8037bc <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  803944:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803949:	c9                   	leaveq 
  80394a:	c3                   	retq   

000000000080394b <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  80394b:	55                   	push   %rbp
  80394c:	48 89 e5             	mov    %rsp,%rbp
  80394f:	48 83 ec 20          	sub    $0x20,%rsp
  803953:	89 7d ec             	mov    %edi,-0x14(%rbp)
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  803956:	48 c7 45 f8 00 00 80 	movq   $0x800000,-0x8(%rbp)
  80395d:	00 
  80395e:	e9 c9 00 00 00       	jmpq   803a2c <copy_shared_pages+0xe1>
        {
            if(!((uvpml4e[VPML4E(addr)])&&(uvpde[VPDPE(addr)]) && (uvpd[VPD(addr)]  )))
  803963:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803967:	48 c1 e8 27          	shr    $0x27,%rax
  80396b:	48 89 c2             	mov    %rax,%rdx
  80396e:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  803975:	01 00 00 
  803978:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80397c:	48 85 c0             	test   %rax,%rax
  80397f:	74 3c                	je     8039bd <copy_shared_pages+0x72>
  803981:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803985:	48 c1 e8 1e          	shr    $0x1e,%rax
  803989:	48 89 c2             	mov    %rax,%rdx
  80398c:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  803993:	01 00 00 
  803996:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80399a:	48 85 c0             	test   %rax,%rax
  80399d:	74 1e                	je     8039bd <copy_shared_pages+0x72>
  80399f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039a3:	48 c1 e8 15          	shr    $0x15,%rax
  8039a7:	48 89 c2             	mov    %rax,%rdx
  8039aa:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8039b1:	01 00 00 
  8039b4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8039b8:	48 85 c0             	test   %rax,%rax
  8039bb:	75 02                	jne    8039bf <copy_shared_pages+0x74>
                continue;
  8039bd:	eb 65                	jmp    803a24 <copy_shared_pages+0xd9>

            if((uvpt[VPN(addr)] & PTE_SHARE) != 0)
  8039bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039c3:	48 c1 e8 0c          	shr    $0xc,%rax
  8039c7:	48 89 c2             	mov    %rax,%rdx
  8039ca:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8039d1:	01 00 00 
  8039d4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8039d8:	25 00 04 00 00       	and    $0x400,%eax
  8039dd:	48 85 c0             	test   %rax,%rax
  8039e0:	74 42                	je     803a24 <copy_shared_pages+0xd9>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);
  8039e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039e6:	48 c1 e8 0c          	shr    $0xc,%rax
  8039ea:	48 89 c2             	mov    %rax,%rdx
  8039ed:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8039f4:	01 00 00 
  8039f7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8039fb:	25 07 0e 00 00       	and    $0xe07,%eax
  803a00:	89 c6                	mov    %eax,%esi
  803a02:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  803a06:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a0a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803a0d:	41 89 f0             	mov    %esi,%r8d
  803a10:	48 89 c6             	mov    %rax,%rsi
  803a13:	bf 00 00 00 00       	mov    $0x0,%edi
  803a18:	48 b8 ad 1e 80 00 00 	movabs $0x801ead,%rax
  803a1f:	00 00 00 
  803a22:	ff d0                	callq  *%rax
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  803a24:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  803a2b:	00 
  803a2c:	48 b8 ff ff 7f 00 80 	movabs $0x80007fffff,%rax
  803a33:	00 00 00 
  803a36:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  803a3a:	0f 86 23 ff ff ff    	jbe    803963 <copy_shared_pages+0x18>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);

            }
        }
     return 0;
  803a40:	b8 00 00 00 00       	mov    $0x0,%eax
 }
  803a45:	c9                   	leaveq 
  803a46:	c3                   	retq   

0000000000803a47 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803a47:	55                   	push   %rbp
  803a48:	48 89 e5             	mov    %rsp,%rbp
  803a4b:	53                   	push   %rbx
  803a4c:	48 83 ec 38          	sub    $0x38,%rsp
  803a50:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803a54:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803a58:	48 89 c7             	mov    %rax,%rdi
  803a5b:	48 b8 18 21 80 00 00 	movabs $0x802118,%rax
  803a62:	00 00 00 
  803a65:	ff d0                	callq  *%rax
  803a67:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a6a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a6e:	0f 88 bf 01 00 00    	js     803c33 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a74:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a78:	ba 07 04 00 00       	mov    $0x407,%edx
  803a7d:	48 89 c6             	mov    %rax,%rsi
  803a80:	bf 00 00 00 00       	mov    $0x0,%edi
  803a85:	48 b8 5d 1e 80 00 00 	movabs $0x801e5d,%rax
  803a8c:	00 00 00 
  803a8f:	ff d0                	callq  *%rax
  803a91:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a94:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a98:	0f 88 95 01 00 00    	js     803c33 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803a9e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803aa2:	48 89 c7             	mov    %rax,%rdi
  803aa5:	48 b8 18 21 80 00 00 	movabs $0x802118,%rax
  803aac:	00 00 00 
  803aaf:	ff d0                	callq  *%rax
  803ab1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ab4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ab8:	0f 88 5d 01 00 00    	js     803c1b <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803abe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ac2:	ba 07 04 00 00       	mov    $0x407,%edx
  803ac7:	48 89 c6             	mov    %rax,%rsi
  803aca:	bf 00 00 00 00       	mov    $0x0,%edi
  803acf:	48 b8 5d 1e 80 00 00 	movabs $0x801e5d,%rax
  803ad6:	00 00 00 
  803ad9:	ff d0                	callq  *%rax
  803adb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ade:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ae2:	0f 88 33 01 00 00    	js     803c1b <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803ae8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803aec:	48 89 c7             	mov    %rax,%rdi
  803aef:	48 b8 ed 20 80 00 00 	movabs $0x8020ed,%rax
  803af6:	00 00 00 
  803af9:	ff d0                	callq  *%rax
  803afb:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803aff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b03:	ba 07 04 00 00       	mov    $0x407,%edx
  803b08:	48 89 c6             	mov    %rax,%rsi
  803b0b:	bf 00 00 00 00       	mov    $0x0,%edi
  803b10:	48 b8 5d 1e 80 00 00 	movabs $0x801e5d,%rax
  803b17:	00 00 00 
  803b1a:	ff d0                	callq  *%rax
  803b1c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b1f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b23:	79 05                	jns    803b2a <pipe+0xe3>
		goto err2;
  803b25:	e9 d9 00 00 00       	jmpq   803c03 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803b2a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b2e:	48 89 c7             	mov    %rax,%rdi
  803b31:	48 b8 ed 20 80 00 00 	movabs $0x8020ed,%rax
  803b38:	00 00 00 
  803b3b:	ff d0                	callq  *%rax
  803b3d:	48 89 c2             	mov    %rax,%rdx
  803b40:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b44:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803b4a:	48 89 d1             	mov    %rdx,%rcx
  803b4d:	ba 00 00 00 00       	mov    $0x0,%edx
  803b52:	48 89 c6             	mov    %rax,%rsi
  803b55:	bf 00 00 00 00       	mov    $0x0,%edi
  803b5a:	48 b8 ad 1e 80 00 00 	movabs $0x801ead,%rax
  803b61:	00 00 00 
  803b64:	ff d0                	callq  *%rax
  803b66:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b69:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b6d:	79 1b                	jns    803b8a <pipe+0x143>
		goto err3;
  803b6f:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  803b70:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b74:	48 89 c6             	mov    %rax,%rsi
  803b77:	bf 00 00 00 00       	mov    $0x0,%edi
  803b7c:	48 b8 08 1f 80 00 00 	movabs $0x801f08,%rax
  803b83:	00 00 00 
  803b86:	ff d0                	callq  *%rax
  803b88:	eb 79                	jmp    803c03 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803b8a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b8e:	48 ba 20 78 80 00 00 	movabs $0x807820,%rdx
  803b95:	00 00 00 
  803b98:	8b 12                	mov    (%rdx),%edx
  803b9a:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803b9c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ba0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803ba7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bab:	48 ba 20 78 80 00 00 	movabs $0x807820,%rdx
  803bb2:	00 00 00 
  803bb5:	8b 12                	mov    (%rdx),%edx
  803bb7:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803bb9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bbd:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803bc4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bc8:	48 89 c7             	mov    %rax,%rdi
  803bcb:	48 b8 ca 20 80 00 00 	movabs $0x8020ca,%rax
  803bd2:	00 00 00 
  803bd5:	ff d0                	callq  *%rax
  803bd7:	89 c2                	mov    %eax,%edx
  803bd9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803bdd:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803bdf:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803be3:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803be7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803beb:	48 89 c7             	mov    %rax,%rdi
  803bee:	48 b8 ca 20 80 00 00 	movabs $0x8020ca,%rax
  803bf5:	00 00 00 
  803bf8:	ff d0                	callq  *%rax
  803bfa:	89 03                	mov    %eax,(%rbx)
	return 0;
  803bfc:	b8 00 00 00 00       	mov    $0x0,%eax
  803c01:	eb 33                	jmp    803c36 <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  803c03:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c07:	48 89 c6             	mov    %rax,%rsi
  803c0a:	bf 00 00 00 00       	mov    $0x0,%edi
  803c0f:	48 b8 08 1f 80 00 00 	movabs $0x801f08,%rax
  803c16:	00 00 00 
  803c19:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  803c1b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c1f:	48 89 c6             	mov    %rax,%rsi
  803c22:	bf 00 00 00 00       	mov    $0x0,%edi
  803c27:	48 b8 08 1f 80 00 00 	movabs $0x801f08,%rax
  803c2e:	00 00 00 
  803c31:	ff d0                	callq  *%rax
    err:
	return r;
  803c33:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803c36:	48 83 c4 38          	add    $0x38,%rsp
  803c3a:	5b                   	pop    %rbx
  803c3b:	5d                   	pop    %rbp
  803c3c:	c3                   	retq   

0000000000803c3d <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803c3d:	55                   	push   %rbp
  803c3e:	48 89 e5             	mov    %rsp,%rbp
  803c41:	53                   	push   %rbx
  803c42:	48 83 ec 28          	sub    $0x28,%rsp
  803c46:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803c4a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803c4e:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  803c55:	00 00 00 
  803c58:	48 8b 00             	mov    (%rax),%rax
  803c5b:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803c61:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803c64:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c68:	48 89 c7             	mov    %rax,%rdi
  803c6b:	48 b8 97 42 80 00 00 	movabs $0x804297,%rax
  803c72:	00 00 00 
  803c75:	ff d0                	callq  *%rax
  803c77:	89 c3                	mov    %eax,%ebx
  803c79:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c7d:	48 89 c7             	mov    %rax,%rdi
  803c80:	48 b8 97 42 80 00 00 	movabs $0x804297,%rax
  803c87:	00 00 00 
  803c8a:	ff d0                	callq  *%rax
  803c8c:	39 c3                	cmp    %eax,%ebx
  803c8e:	0f 94 c0             	sete   %al
  803c91:	0f b6 c0             	movzbl %al,%eax
  803c94:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803c97:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  803c9e:	00 00 00 
  803ca1:	48 8b 00             	mov    (%rax),%rax
  803ca4:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803caa:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803cad:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cb0:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803cb3:	75 05                	jne    803cba <_pipeisclosed+0x7d>
			return ret;
  803cb5:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803cb8:	eb 4f                	jmp    803d09 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803cba:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cbd:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803cc0:	74 42                	je     803d04 <_pipeisclosed+0xc7>
  803cc2:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803cc6:	75 3c                	jne    803d04 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803cc8:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  803ccf:	00 00 00 
  803cd2:	48 8b 00             	mov    (%rax),%rax
  803cd5:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803cdb:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803cde:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ce1:	89 c6                	mov    %eax,%esi
  803ce3:	48 bf dd 4a 80 00 00 	movabs $0x804add,%rdi
  803cea:	00 00 00 
  803ced:	b8 00 00 00 00       	mov    $0x0,%eax
  803cf2:	49 b8 79 09 80 00 00 	movabs $0x800979,%r8
  803cf9:	00 00 00 
  803cfc:	41 ff d0             	callq  *%r8
	}
  803cff:	e9 4a ff ff ff       	jmpq   803c4e <_pipeisclosed+0x11>
  803d04:	e9 45 ff ff ff       	jmpq   803c4e <_pipeisclosed+0x11>
}
  803d09:	48 83 c4 28          	add    $0x28,%rsp
  803d0d:	5b                   	pop    %rbx
  803d0e:	5d                   	pop    %rbp
  803d0f:	c3                   	retq   

0000000000803d10 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803d10:	55                   	push   %rbp
  803d11:	48 89 e5             	mov    %rsp,%rbp
  803d14:	48 83 ec 30          	sub    $0x30,%rsp
  803d18:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803d1b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803d1f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803d22:	48 89 d6             	mov    %rdx,%rsi
  803d25:	89 c7                	mov    %eax,%edi
  803d27:	48 b8 b0 21 80 00 00 	movabs $0x8021b0,%rax
  803d2e:	00 00 00 
  803d31:	ff d0                	callq  *%rax
  803d33:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d36:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d3a:	79 05                	jns    803d41 <pipeisclosed+0x31>
		return r;
  803d3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d3f:	eb 31                	jmp    803d72 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803d41:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d45:	48 89 c7             	mov    %rax,%rdi
  803d48:	48 b8 ed 20 80 00 00 	movabs $0x8020ed,%rax
  803d4f:	00 00 00 
  803d52:	ff d0                	callq  *%rax
  803d54:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803d58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d5c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d60:	48 89 d6             	mov    %rdx,%rsi
  803d63:	48 89 c7             	mov    %rax,%rdi
  803d66:	48 b8 3d 3c 80 00 00 	movabs $0x803c3d,%rax
  803d6d:	00 00 00 
  803d70:	ff d0                	callq  *%rax
}
  803d72:	c9                   	leaveq 
  803d73:	c3                   	retq   

0000000000803d74 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803d74:	55                   	push   %rbp
  803d75:	48 89 e5             	mov    %rsp,%rbp
  803d78:	48 83 ec 40          	sub    $0x40,%rsp
  803d7c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803d80:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803d84:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803d88:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d8c:	48 89 c7             	mov    %rax,%rdi
  803d8f:	48 b8 ed 20 80 00 00 	movabs $0x8020ed,%rax
  803d96:	00 00 00 
  803d99:	ff d0                	callq  *%rax
  803d9b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803d9f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803da3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803da7:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803dae:	00 
  803daf:	e9 92 00 00 00       	jmpq   803e46 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803db4:	eb 41                	jmp    803df7 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803db6:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803dbb:	74 09                	je     803dc6 <devpipe_read+0x52>
				return i;
  803dbd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803dc1:	e9 92 00 00 00       	jmpq   803e58 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803dc6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803dca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dce:	48 89 d6             	mov    %rdx,%rsi
  803dd1:	48 89 c7             	mov    %rax,%rdi
  803dd4:	48 b8 3d 3c 80 00 00 	movabs $0x803c3d,%rax
  803ddb:	00 00 00 
  803dde:	ff d0                	callq  *%rax
  803de0:	85 c0                	test   %eax,%eax
  803de2:	74 07                	je     803deb <devpipe_read+0x77>
				return 0;
  803de4:	b8 00 00 00 00       	mov    $0x0,%eax
  803de9:	eb 6d                	jmp    803e58 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803deb:	48 b8 1f 1e 80 00 00 	movabs $0x801e1f,%rax
  803df2:	00 00 00 
  803df5:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803df7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dfb:	8b 10                	mov    (%rax),%edx
  803dfd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e01:	8b 40 04             	mov    0x4(%rax),%eax
  803e04:	39 c2                	cmp    %eax,%edx
  803e06:	74 ae                	je     803db6 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803e08:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e0c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803e10:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803e14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e18:	8b 00                	mov    (%rax),%eax
  803e1a:	99                   	cltd   
  803e1b:	c1 ea 1b             	shr    $0x1b,%edx
  803e1e:	01 d0                	add    %edx,%eax
  803e20:	83 e0 1f             	and    $0x1f,%eax
  803e23:	29 d0                	sub    %edx,%eax
  803e25:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e29:	48 98                	cltq   
  803e2b:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803e30:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803e32:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e36:	8b 00                	mov    (%rax),%eax
  803e38:	8d 50 01             	lea    0x1(%rax),%edx
  803e3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e3f:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803e41:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803e46:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e4a:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803e4e:	0f 82 60 ff ff ff    	jb     803db4 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803e54:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803e58:	c9                   	leaveq 
  803e59:	c3                   	retq   

0000000000803e5a <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803e5a:	55                   	push   %rbp
  803e5b:	48 89 e5             	mov    %rsp,%rbp
  803e5e:	48 83 ec 40          	sub    $0x40,%rsp
  803e62:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803e66:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803e6a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803e6e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e72:	48 89 c7             	mov    %rax,%rdi
  803e75:	48 b8 ed 20 80 00 00 	movabs $0x8020ed,%rax
  803e7c:	00 00 00 
  803e7f:	ff d0                	callq  *%rax
  803e81:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803e85:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e89:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803e8d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803e94:	00 
  803e95:	e9 8e 00 00 00       	jmpq   803f28 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803e9a:	eb 31                	jmp    803ecd <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803e9c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ea0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ea4:	48 89 d6             	mov    %rdx,%rsi
  803ea7:	48 89 c7             	mov    %rax,%rdi
  803eaa:	48 b8 3d 3c 80 00 00 	movabs $0x803c3d,%rax
  803eb1:	00 00 00 
  803eb4:	ff d0                	callq  *%rax
  803eb6:	85 c0                	test   %eax,%eax
  803eb8:	74 07                	je     803ec1 <devpipe_write+0x67>
				return 0;
  803eba:	b8 00 00 00 00       	mov    $0x0,%eax
  803ebf:	eb 79                	jmp    803f3a <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803ec1:	48 b8 1f 1e 80 00 00 	movabs $0x801e1f,%rax
  803ec8:	00 00 00 
  803ecb:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803ecd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ed1:	8b 40 04             	mov    0x4(%rax),%eax
  803ed4:	48 63 d0             	movslq %eax,%rdx
  803ed7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803edb:	8b 00                	mov    (%rax),%eax
  803edd:	48 98                	cltq   
  803edf:	48 83 c0 20          	add    $0x20,%rax
  803ee3:	48 39 c2             	cmp    %rax,%rdx
  803ee6:	73 b4                	jae    803e9c <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803ee8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803eec:	8b 40 04             	mov    0x4(%rax),%eax
  803eef:	99                   	cltd   
  803ef0:	c1 ea 1b             	shr    $0x1b,%edx
  803ef3:	01 d0                	add    %edx,%eax
  803ef5:	83 e0 1f             	and    $0x1f,%eax
  803ef8:	29 d0                	sub    %edx,%eax
  803efa:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803efe:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803f02:	48 01 ca             	add    %rcx,%rdx
  803f05:	0f b6 0a             	movzbl (%rdx),%ecx
  803f08:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803f0c:	48 98                	cltq   
  803f0e:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803f12:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f16:	8b 40 04             	mov    0x4(%rax),%eax
  803f19:	8d 50 01             	lea    0x1(%rax),%edx
  803f1c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f20:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803f23:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803f28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f2c:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803f30:	0f 82 64 ff ff ff    	jb     803e9a <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803f36:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803f3a:	c9                   	leaveq 
  803f3b:	c3                   	retq   

0000000000803f3c <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803f3c:	55                   	push   %rbp
  803f3d:	48 89 e5             	mov    %rsp,%rbp
  803f40:	48 83 ec 20          	sub    $0x20,%rsp
  803f44:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803f48:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803f4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f50:	48 89 c7             	mov    %rax,%rdi
  803f53:	48 b8 ed 20 80 00 00 	movabs $0x8020ed,%rax
  803f5a:	00 00 00 
  803f5d:	ff d0                	callq  *%rax
  803f5f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803f63:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f67:	48 be f0 4a 80 00 00 	movabs $0x804af0,%rsi
  803f6e:	00 00 00 
  803f71:	48 89 c7             	mov    %rax,%rdi
  803f74:	48 b8 2e 15 80 00 00 	movabs $0x80152e,%rax
  803f7b:	00 00 00 
  803f7e:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803f80:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f84:	8b 50 04             	mov    0x4(%rax),%edx
  803f87:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f8b:	8b 00                	mov    (%rax),%eax
  803f8d:	29 c2                	sub    %eax,%edx
  803f8f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f93:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803f99:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f9d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803fa4:	00 00 00 
	stat->st_dev = &devpipe;
  803fa7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fab:	48 b9 20 78 80 00 00 	movabs $0x807820,%rcx
  803fb2:	00 00 00 
  803fb5:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803fbc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803fc1:	c9                   	leaveq 
  803fc2:	c3                   	retq   

0000000000803fc3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803fc3:	55                   	push   %rbp
  803fc4:	48 89 e5             	mov    %rsp,%rbp
  803fc7:	48 83 ec 10          	sub    $0x10,%rsp
  803fcb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803fcf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fd3:	48 89 c6             	mov    %rax,%rsi
  803fd6:	bf 00 00 00 00       	mov    $0x0,%edi
  803fdb:	48 b8 08 1f 80 00 00 	movabs $0x801f08,%rax
  803fe2:	00 00 00 
  803fe5:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803fe7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803feb:	48 89 c7             	mov    %rax,%rdi
  803fee:	48 b8 ed 20 80 00 00 	movabs $0x8020ed,%rax
  803ff5:	00 00 00 
  803ff8:	ff d0                	callq  *%rax
  803ffa:	48 89 c6             	mov    %rax,%rsi
  803ffd:	bf 00 00 00 00       	mov    $0x0,%edi
  804002:	48 b8 08 1f 80 00 00 	movabs $0x801f08,%rax
  804009:	00 00 00 
  80400c:	ff d0                	callq  *%rax
}
  80400e:	c9                   	leaveq 
  80400f:	c3                   	retq   

0000000000804010 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  804010:	55                   	push   %rbp
  804011:	48 89 e5             	mov    %rsp,%rbp
  804014:	48 83 ec 20          	sub    $0x20,%rsp
  804018:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  80401b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80401f:	75 35                	jne    804056 <wait+0x46>
  804021:	48 b9 f7 4a 80 00 00 	movabs $0x804af7,%rcx
  804028:	00 00 00 
  80402b:	48 ba 02 4b 80 00 00 	movabs $0x804b02,%rdx
  804032:	00 00 00 
  804035:	be 09 00 00 00       	mov    $0x9,%esi
  80403a:	48 bf 17 4b 80 00 00 	movabs $0x804b17,%rdi
  804041:	00 00 00 
  804044:	b8 00 00 00 00       	mov    $0x0,%eax
  804049:	49 b8 40 07 80 00 00 	movabs $0x800740,%r8
  804050:	00 00 00 
  804053:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  804056:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804059:	25 ff 03 00 00       	and    $0x3ff,%eax
  80405e:	48 63 d0             	movslq %eax,%rdx
  804061:	48 89 d0             	mov    %rdx,%rax
  804064:	48 c1 e0 03          	shl    $0x3,%rax
  804068:	48 01 d0             	add    %rdx,%rax
  80406b:	48 c1 e0 05          	shl    $0x5,%rax
  80406f:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804076:	00 00 00 
  804079:	48 01 d0             	add    %rdx,%rax
  80407c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE){
  804080:	eb 0c                	jmp    80408e <wait+0x7e>
	//cprintf("envid is [%d]",envid);
		sys_yield();
  804082:	48 b8 1f 1e 80 00 00 	movabs $0x801e1f,%rax
  804089:	00 00 00 
  80408c:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE){
  80408e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804092:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804098:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80409b:	75 0e                	jne    8040ab <wait+0x9b>
  80409d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040a1:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8040a7:	85 c0                	test   %eax,%eax
  8040a9:	75 d7                	jne    804082 <wait+0x72>
	//cprintf("envid is [%d]",envid);
		sys_yield();
	}
}
  8040ab:	c9                   	leaveq 
  8040ac:	c3                   	retq   

00000000008040ad <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8040ad:	55                   	push   %rbp
  8040ae:	48 89 e5             	mov    %rsp,%rbp
  8040b1:	48 83 ec 30          	sub    $0x30,%rsp
  8040b5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8040b9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8040bd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  8040c1:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  8040c8:	00 00 00 
  8040cb:	48 8b 00             	mov    (%rax),%rax
  8040ce:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8040d4:	85 c0                	test   %eax,%eax
  8040d6:	75 3c                	jne    804114 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  8040d8:	48 b8 e1 1d 80 00 00 	movabs $0x801de1,%rax
  8040df:	00 00 00 
  8040e2:	ff d0                	callq  *%rax
  8040e4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8040e9:	48 63 d0             	movslq %eax,%rdx
  8040ec:	48 89 d0             	mov    %rdx,%rax
  8040ef:	48 c1 e0 03          	shl    $0x3,%rax
  8040f3:	48 01 d0             	add    %rdx,%rax
  8040f6:	48 c1 e0 05          	shl    $0x5,%rax
  8040fa:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804101:	00 00 00 
  804104:	48 01 c2             	add    %rax,%rdx
  804107:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  80410e:	00 00 00 
  804111:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  804114:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804119:	75 0e                	jne    804129 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  80411b:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804122:	00 00 00 
  804125:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  804129:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80412d:	48 89 c7             	mov    %rax,%rdi
  804130:	48 b8 86 20 80 00 00 	movabs $0x802086,%rax
  804137:	00 00 00 
  80413a:	ff d0                	callq  *%rax
  80413c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  80413f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804143:	79 19                	jns    80415e <ipc_recv+0xb1>
		*from_env_store = 0;
  804145:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804149:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  80414f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804153:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  804159:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80415c:	eb 53                	jmp    8041b1 <ipc_recv+0x104>
	}
	if(from_env_store)
  80415e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804163:	74 19                	je     80417e <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  804165:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  80416c:	00 00 00 
  80416f:	48 8b 00             	mov    (%rax),%rax
  804172:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804178:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80417c:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  80417e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804183:	74 19                	je     80419e <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  804185:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  80418c:	00 00 00 
  80418f:	48 8b 00             	mov    (%rax),%rax
  804192:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804198:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80419c:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  80419e:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  8041a5:	00 00 00 
  8041a8:	48 8b 00             	mov    (%rax),%rax
  8041ab:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  8041b1:	c9                   	leaveq 
  8041b2:	c3                   	retq   

00000000008041b3 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8041b3:	55                   	push   %rbp
  8041b4:	48 89 e5             	mov    %rsp,%rbp
  8041b7:	48 83 ec 30          	sub    $0x30,%rsp
  8041bb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8041be:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8041c1:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8041c5:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  8041c8:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8041cd:	75 0e                	jne    8041dd <ipc_send+0x2a>
		pg = (void*)UTOP;
  8041cf:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8041d6:	00 00 00 
  8041d9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  8041dd:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8041e0:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8041e3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8041e7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8041ea:	89 c7                	mov    %eax,%edi
  8041ec:	48 b8 31 20 80 00 00 	movabs $0x802031,%rax
  8041f3:	00 00 00 
  8041f6:	ff d0                	callq  *%rax
  8041f8:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  8041fb:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8041ff:	75 0c                	jne    80420d <ipc_send+0x5a>
			sys_yield();
  804201:	48 b8 1f 1e 80 00 00 	movabs $0x801e1f,%rax
  804208:	00 00 00 
  80420b:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  80420d:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804211:	74 ca                	je     8041dd <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  804213:	c9                   	leaveq 
  804214:	c3                   	retq   

0000000000804215 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804215:	55                   	push   %rbp
  804216:	48 89 e5             	mov    %rsp,%rbp
  804219:	48 83 ec 14          	sub    $0x14,%rsp
  80421d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  804220:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804227:	eb 5e                	jmp    804287 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  804229:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804230:	00 00 00 
  804233:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804236:	48 63 d0             	movslq %eax,%rdx
  804239:	48 89 d0             	mov    %rdx,%rax
  80423c:	48 c1 e0 03          	shl    $0x3,%rax
  804240:	48 01 d0             	add    %rdx,%rax
  804243:	48 c1 e0 05          	shl    $0x5,%rax
  804247:	48 01 c8             	add    %rcx,%rax
  80424a:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804250:	8b 00                	mov    (%rax),%eax
  804252:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804255:	75 2c                	jne    804283 <ipc_find_env+0x6e>
			return envs[i].env_id;
  804257:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80425e:	00 00 00 
  804261:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804264:	48 63 d0             	movslq %eax,%rdx
  804267:	48 89 d0             	mov    %rdx,%rax
  80426a:	48 c1 e0 03          	shl    $0x3,%rax
  80426e:	48 01 d0             	add    %rdx,%rax
  804271:	48 c1 e0 05          	shl    $0x5,%rax
  804275:	48 01 c8             	add    %rcx,%rax
  804278:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80427e:	8b 40 08             	mov    0x8(%rax),%eax
  804281:	eb 12                	jmp    804295 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  804283:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804287:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80428e:	7e 99                	jle    804229 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  804290:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804295:	c9                   	leaveq 
  804296:	c3                   	retq   

0000000000804297 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804297:	55                   	push   %rbp
  804298:	48 89 e5             	mov    %rsp,%rbp
  80429b:	48 83 ec 18          	sub    $0x18,%rsp
  80429f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8042a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042a7:	48 c1 e8 15          	shr    $0x15,%rax
  8042ab:	48 89 c2             	mov    %rax,%rdx
  8042ae:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8042b5:	01 00 00 
  8042b8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8042bc:	83 e0 01             	and    $0x1,%eax
  8042bf:	48 85 c0             	test   %rax,%rax
  8042c2:	75 07                	jne    8042cb <pageref+0x34>
		return 0;
  8042c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8042c9:	eb 53                	jmp    80431e <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8042cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042cf:	48 c1 e8 0c          	shr    $0xc,%rax
  8042d3:	48 89 c2             	mov    %rax,%rdx
  8042d6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8042dd:	01 00 00 
  8042e0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8042e4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8042e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042ec:	83 e0 01             	and    $0x1,%eax
  8042ef:	48 85 c0             	test   %rax,%rax
  8042f2:	75 07                	jne    8042fb <pageref+0x64>
		return 0;
  8042f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8042f9:	eb 23                	jmp    80431e <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8042fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042ff:	48 c1 e8 0c          	shr    $0xc,%rax
  804303:	48 89 c2             	mov    %rax,%rdx
  804306:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80430d:	00 00 00 
  804310:	48 c1 e2 04          	shl    $0x4,%rdx
  804314:	48 01 d0             	add    %rdx,%rax
  804317:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80431b:	0f b7 c0             	movzwl %ax,%eax
}
  80431e:	c9                   	leaveq 
  80431f:	c3                   	retq   
