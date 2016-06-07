
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
  80003c:	e8 6c 06 00 00       	callq  8006ad <libmain>
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
  8000a5:	48 bf 00 4e 80 00 00 	movabs $0x804e00,%rdi
  8000ac:	00 00 00 
  8000af:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b4:	48 ba 94 09 80 00 00 	movabs $0x800994,%rdx
  8000bb:	00 00 00 
  8000be:	ff d2                	callq  *%rdx

	want = 0xf989e;
  8000c0:	c7 45 f8 9e 98 0f 00 	movl   $0xf989e,-0x8(%rbp)
	if ((x = sum((char*)&data, sizeof data)) != want)
  8000c7:	be 70 17 00 00       	mov    $0x1770,%esi
  8000cc:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
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
  8000f5:	48 bf 10 4e 80 00 00 	movabs $0x804e10,%rdi
  8000fc:	00 00 00 
  8000ff:	b8 00 00 00 00       	mov    $0x0,%eax
  800104:	48 b9 94 09 80 00 00 	movabs $0x800994,%rcx
  80010b:	00 00 00 
  80010e:	ff d1                	callq  *%rcx
  800110:	eb 1b                	jmp    80012d <umain+0xa0>
			x, want);
	else
		cprintf("init: data seems okay\n");
  800112:	48 bf 49 4e 80 00 00 	movabs $0x804e49,%rdi
  800119:	00 00 00 
  80011c:	b8 00 00 00 00       	mov    $0x0,%eax
  800121:	48 ba 94 09 80 00 00 	movabs $0x800994,%rdx
  800128:	00 00 00 
  80012b:	ff d2                	callq  *%rdx
	if ((x = sum(bss, sizeof bss)) != 0)
  80012d:	be 70 17 00 00       	mov    $0x1770,%esi
  800132:	48 bf 20 90 80 00 00 	movabs $0x809020,%rdi
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
  800156:	48 bf 60 4e 80 00 00 	movabs $0x804e60,%rdi
  80015d:	00 00 00 
  800160:	b8 00 00 00 00       	mov    $0x0,%eax
  800165:	48 ba 94 09 80 00 00 	movabs $0x800994,%rdx
  80016c:	00 00 00 
  80016f:	ff d2                	callq  *%rdx
  800171:	eb 1b                	jmp    80018e <umain+0x101>
	else
		cprintf("init: bss seems okay\n");
  800173:	48 bf 8f 4e 80 00 00 	movabs $0x804e8f,%rdi
  80017a:	00 00 00 
  80017d:	b8 00 00 00 00       	mov    $0x0,%eax
  800182:	48 ba 94 09 80 00 00 	movabs $0x800994,%rdx
  800189:	00 00 00 
  80018c:	ff d2                	callq  *%rdx

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
  80018e:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800195:	48 be a5 4e 80 00 00 	movabs $0x804ea5,%rsi
  80019c:	00 00 00 
  80019f:	48 89 c7             	mov    %rax,%rdi
  8001a2:	48 b8 8c 15 80 00 00 	movabs $0x80158c,%rax
  8001a9:	00 00 00 
  8001ac:	ff d0                	callq  *%rax
	for (i = 0; i < argc; i++) {
  8001ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8001b5:	eb 77                	jmp    80022e <umain+0x1a1>
		strcat(args, " '");
  8001b7:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8001be:	48 be b1 4e 80 00 00 	movabs $0x804eb1,%rsi
  8001c5:	00 00 00 
  8001c8:	48 89 c7             	mov    %rax,%rdi
  8001cb:	48 b8 8c 15 80 00 00 	movabs $0x80158c,%rax
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
  8001fe:	48 b8 8c 15 80 00 00 	movabs $0x80158c,%rax
  800205:	00 00 00 
  800208:	ff d0                	callq  *%rax
		strcat(args, "'");
  80020a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800211:	48 be b4 4e 80 00 00 	movabs $0x804eb4,%rsi
  800218:	00 00 00 
  80021b:	48 89 c7             	mov    %rax,%rdi
  80021e:	48 b8 8c 15 80 00 00 	movabs $0x80158c,%rax
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
  800247:	48 bf b6 4e 80 00 00 	movabs $0x804eb6,%rdi
  80024e:	00 00 00 
  800251:	b8 00 00 00 00       	mov    $0x0,%eax
  800256:	48 ba 94 09 80 00 00 	movabs $0x800994,%rdx
  80025d:	00 00 00 
  800260:	ff d2                	callq  *%rdx

	cprintf("init: running sh\n");
  800262:	48 bf ba 4e 80 00 00 	movabs $0x804eba,%rdi
  800269:	00 00 00 
  80026c:	b8 00 00 00 00       	mov    $0x0,%eax
  800271:	48 ba 94 09 80 00 00 	movabs $0x800994,%rdx
  800278:	00 00 00 
  80027b:	ff d2                	callq  *%rdx

	// being run directly from kernel, so no file descriptors open yet
	close(0);
  80027d:	bf 00 00 00 00       	mov    $0x0,%edi
  800282:	48 b8 a5 24 80 00 00 	movabs $0x8024a5,%rax
  800289:	00 00 00 
  80028c:	ff d0                	callq  *%rax
	if ((r = opencons()) < 0)
  80028e:	48 b8 bb 04 80 00 00 	movabs $0x8004bb,%rax
  800295:	00 00 00 
  800298:	ff d0                	callq  *%rax
  80029a:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80029d:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8002a1:	79 30                	jns    8002d3 <umain+0x246>
		panic("opencons: %e", r);
  8002a3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002a6:	89 c1                	mov    %eax,%ecx
  8002a8:	48 ba cc 4e 80 00 00 	movabs $0x804ecc,%rdx
  8002af:	00 00 00 
  8002b2:	be 37 00 00 00       	mov    $0x37,%esi
  8002b7:	48 bf d9 4e 80 00 00 	movabs $0x804ed9,%rdi
  8002be:	00 00 00 
  8002c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c6:	49 b8 5b 07 80 00 00 	movabs $0x80075b,%r8
  8002cd:	00 00 00 
  8002d0:	41 ff d0             	callq  *%r8
	if (r != 0)
  8002d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8002d7:	74 30                	je     800309 <umain+0x27c>
		panic("first opencons used fd %d", r);
  8002d9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002dc:	89 c1                	mov    %eax,%ecx
  8002de:	48 ba e5 4e 80 00 00 	movabs $0x804ee5,%rdx
  8002e5:	00 00 00 
  8002e8:	be 39 00 00 00       	mov    $0x39,%esi
  8002ed:	48 bf d9 4e 80 00 00 	movabs $0x804ed9,%rdi
  8002f4:	00 00 00 
  8002f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fc:	49 b8 5b 07 80 00 00 	movabs $0x80075b,%r8
  800303:	00 00 00 
  800306:	41 ff d0             	callq  *%r8
	if ((r = dup(0, 1)) < 0)
  800309:	be 01 00 00 00       	mov    $0x1,%esi
  80030e:	bf 00 00 00 00       	mov    $0x0,%edi
  800313:	48 b8 1e 25 80 00 00 	movabs $0x80251e,%rax
  80031a:	00 00 00 
  80031d:	ff d0                	callq  *%rax
  80031f:	89 45 f0             	mov    %eax,-0x10(%rbp)
  800322:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800326:	79 30                	jns    800358 <umain+0x2cb>
		panic("dup: %e", r);
  800328:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80032b:	89 c1                	mov    %eax,%ecx
  80032d:	48 ba ff 4e 80 00 00 	movabs $0x804eff,%rdx
  800334:	00 00 00 
  800337:	be 3b 00 00 00       	mov    $0x3b,%esi
  80033c:	48 bf d9 4e 80 00 00 	movabs $0x804ed9,%rdi
  800343:	00 00 00 
  800346:	b8 00 00 00 00       	mov    $0x0,%eax
  80034b:	49 b8 5b 07 80 00 00 	movabs $0x80075b,%r8
  800352:	00 00 00 
  800355:	41 ff d0             	callq  *%r8
	while (1) {
		cprintf("init: starting sh\n");
  800358:	48 bf 07 4f 80 00 00 	movabs $0x804f07,%rdi
  80035f:	00 00 00 
  800362:	b8 00 00 00 00       	mov    $0x0,%eax
  800367:	48 ba 94 09 80 00 00 	movabs $0x800994,%rdx
  80036e:	00 00 00 
  800371:	ff d2                	callq  *%rdx
		r = spawnl("/bin/sh", "sh", (char*)0);
  800373:	ba 00 00 00 00       	mov    $0x0,%edx
  800378:	48 be 1a 4f 80 00 00 	movabs $0x804f1a,%rsi
  80037f:	00 00 00 
  800382:	48 bf 1d 4f 80 00 00 	movabs $0x804f1d,%rdi
  800389:	00 00 00 
  80038c:	b8 00 00 00 00       	mov    $0x0,%eax
  800391:	48 b9 0e 35 80 00 00 	movabs $0x80350e,%rcx
  800398:	00 00 00 
  80039b:	ff d1                	callq  *%rcx
  80039d:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (r < 0) {
  8003a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8003a4:	79 23                	jns    8003c9 <umain+0x33c>
			cprintf("init: spawn sh: %e\n", r);
  8003a6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8003a9:	89 c6                	mov    %eax,%esi
  8003ab:	48 bf 25 4f 80 00 00 	movabs $0x804f25,%rdi
  8003b2:	00 00 00 
  8003b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ba:	48 ba 94 09 80 00 00 	movabs $0x800994,%rdx
  8003c1:	00 00 00 
  8003c4:	ff d2                	callq  *%rdx
			continue;
  8003c6:	90                   	nop
		}
		cprintf("init waiting\n");
		wait(r);
	}
  8003c7:	eb 8f                	jmp    800358 <umain+0x2cb>
		r = spawnl("/bin/sh", "sh", (char*)0);
		if (r < 0) {
			cprintf("init: spawn sh: %e\n", r);
			continue;
		}
		cprintf("init waiting\n");
  8003c9:	48 bf 39 4f 80 00 00 	movabs $0x804f39,%rdi
  8003d0:	00 00 00 
  8003d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003d8:	48 ba 94 09 80 00 00 	movabs $0x800994,%rdx
  8003df:	00 00 00 
  8003e2:	ff d2                	callq  *%rdx
		wait(r);
  8003e4:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8003e7:	89 c7                	mov    %eax,%edi
  8003e9:	48 b8 dc 4a 80 00 00 	movabs $0x804adc,%rax
  8003f0:	00 00 00 
  8003f3:	ff d0                	callq  *%rax
	}
  8003f5:	e9 5e ff ff ff       	jmpq   800358 <umain+0x2cb>

00000000008003fa <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8003fa:	55                   	push   %rbp
  8003fb:	48 89 e5             	mov    %rsp,%rbp
  8003fe:	48 83 ec 20          	sub    $0x20,%rsp
  800402:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  800405:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800408:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80040b:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80040f:	be 01 00 00 00       	mov    $0x1,%esi
  800414:	48 89 c7             	mov    %rax,%rdi
  800417:	48 b8 30 1d 80 00 00 	movabs $0x801d30,%rax
  80041e:	00 00 00 
  800421:	ff d0                	callq  *%rax
}
  800423:	c9                   	leaveq 
  800424:	c3                   	retq   

0000000000800425 <getchar>:

int
getchar(void)
{
  800425:	55                   	push   %rbp
  800426:	48 89 e5             	mov    %rsp,%rbp
  800429:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80042d:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  800431:	ba 01 00 00 00       	mov    $0x1,%edx
  800436:	48 89 c6             	mov    %rax,%rsi
  800439:	bf 00 00 00 00       	mov    $0x0,%edi
  80043e:	48 b8 c7 26 80 00 00 	movabs $0x8026c7,%rax
  800445:	00 00 00 
  800448:	ff d0                	callq  *%rax
  80044a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80044d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800451:	79 05                	jns    800458 <getchar+0x33>
		return r;
  800453:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800456:	eb 14                	jmp    80046c <getchar+0x47>
	if (r < 1)
  800458:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80045c:	7f 07                	jg     800465 <getchar+0x40>
		return -E_EOF;
  80045e:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  800463:	eb 07                	jmp    80046c <getchar+0x47>
	return c;
  800465:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  800469:	0f b6 c0             	movzbl %al,%eax
}
  80046c:	c9                   	leaveq 
  80046d:	c3                   	retq   

000000000080046e <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80046e:	55                   	push   %rbp
  80046f:	48 89 e5             	mov    %rsp,%rbp
  800472:	48 83 ec 20          	sub    $0x20,%rsp
  800476:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800479:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80047d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800480:	48 89 d6             	mov    %rdx,%rsi
  800483:	89 c7                	mov    %eax,%edi
  800485:	48 b8 95 22 80 00 00 	movabs $0x802295,%rax
  80048c:	00 00 00 
  80048f:	ff d0                	callq  *%rax
  800491:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800494:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800498:	79 05                	jns    80049f <iscons+0x31>
		return r;
  80049a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80049d:	eb 1a                	jmp    8004b9 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80049f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004a3:	8b 10                	mov    (%rax),%edx
  8004a5:	48 b8 80 87 80 00 00 	movabs $0x808780,%rax
  8004ac:	00 00 00 
  8004af:	8b 00                	mov    (%rax),%eax
  8004b1:	39 c2                	cmp    %eax,%edx
  8004b3:	0f 94 c0             	sete   %al
  8004b6:	0f b6 c0             	movzbl %al,%eax
}
  8004b9:	c9                   	leaveq 
  8004ba:	c3                   	retq   

00000000008004bb <opencons>:

int
opencons(void)
{
  8004bb:	55                   	push   %rbp
  8004bc:	48 89 e5             	mov    %rsp,%rbp
  8004bf:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8004c3:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8004c7:	48 89 c7             	mov    %rax,%rdi
  8004ca:	48 b8 fd 21 80 00 00 	movabs $0x8021fd,%rax
  8004d1:	00 00 00 
  8004d4:	ff d0                	callq  *%rax
  8004d6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8004d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004dd:	79 05                	jns    8004e4 <opencons+0x29>
		return r;
  8004df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004e2:	eb 5b                	jmp    80053f <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8004e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004e8:	ba 07 04 00 00       	mov    $0x407,%edx
  8004ed:	48 89 c6             	mov    %rax,%rsi
  8004f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8004f5:	48 b8 78 1e 80 00 00 	movabs $0x801e78,%rax
  8004fc:	00 00 00 
  8004ff:	ff d0                	callq  *%rax
  800501:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800504:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800508:	79 05                	jns    80050f <opencons+0x54>
		return r;
  80050a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80050d:	eb 30                	jmp    80053f <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80050f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800513:	48 ba 80 87 80 00 00 	movabs $0x808780,%rdx
  80051a:	00 00 00 
  80051d:	8b 12                	mov    (%rdx),%edx
  80051f:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  800521:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800525:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80052c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800530:	48 89 c7             	mov    %rax,%rdi
  800533:	48 b8 af 21 80 00 00 	movabs $0x8021af,%rax
  80053a:	00 00 00 
  80053d:	ff d0                	callq  *%rax
}
  80053f:	c9                   	leaveq 
  800540:	c3                   	retq   

0000000000800541 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  800541:	55                   	push   %rbp
  800542:	48 89 e5             	mov    %rsp,%rbp
  800545:	48 83 ec 30          	sub    $0x30,%rsp
  800549:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80054d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800551:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  800555:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80055a:	75 07                	jne    800563 <devcons_read+0x22>
		return 0;
  80055c:	b8 00 00 00 00       	mov    $0x0,%eax
  800561:	eb 4b                	jmp    8005ae <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  800563:	eb 0c                	jmp    800571 <devcons_read+0x30>
		sys_yield();
  800565:	48 b8 3a 1e 80 00 00 	movabs $0x801e3a,%rax
  80056c:	00 00 00 
  80056f:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  800571:	48 b8 7a 1d 80 00 00 	movabs $0x801d7a,%rax
  800578:	00 00 00 
  80057b:	ff d0                	callq  *%rax
  80057d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800580:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800584:	74 df                	je     800565 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  800586:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80058a:	79 05                	jns    800591 <devcons_read+0x50>
		return c;
  80058c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80058f:	eb 1d                	jmp    8005ae <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  800591:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  800595:	75 07                	jne    80059e <devcons_read+0x5d>
		return 0;
  800597:	b8 00 00 00 00       	mov    $0x0,%eax
  80059c:	eb 10                	jmp    8005ae <devcons_read+0x6d>
	*(char*)vbuf = c;
  80059e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005a1:	89 c2                	mov    %eax,%edx
  8005a3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8005a7:	88 10                	mov    %dl,(%rax)
	return 1;
  8005a9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8005ae:	c9                   	leaveq 
  8005af:	c3                   	retq   

00000000008005b0 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8005b0:	55                   	push   %rbp
  8005b1:	48 89 e5             	mov    %rsp,%rbp
  8005b4:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8005bb:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8005c2:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8005c9:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8005d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8005d7:	eb 76                	jmp    80064f <devcons_write+0x9f>
		m = n - tot;
  8005d9:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8005e0:	89 c2                	mov    %eax,%edx
  8005e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005e5:	29 c2                	sub    %eax,%edx
  8005e7:	89 d0                	mov    %edx,%eax
  8005e9:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8005ec:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8005ef:	83 f8 7f             	cmp    $0x7f,%eax
  8005f2:	76 07                	jbe    8005fb <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8005f4:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8005fb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8005fe:	48 63 d0             	movslq %eax,%rdx
  800601:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800604:	48 63 c8             	movslq %eax,%rcx
  800607:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80060e:	48 01 c1             	add    %rax,%rcx
  800611:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  800618:	48 89 ce             	mov    %rcx,%rsi
  80061b:	48 89 c7             	mov    %rax,%rdi
  80061e:	48 b8 6d 18 80 00 00 	movabs $0x80186d,%rax
  800625:	00 00 00 
  800628:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80062a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80062d:	48 63 d0             	movslq %eax,%rdx
  800630:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  800637:	48 89 d6             	mov    %rdx,%rsi
  80063a:	48 89 c7             	mov    %rax,%rdi
  80063d:	48 b8 30 1d 80 00 00 	movabs $0x801d30,%rax
  800644:	00 00 00 
  800647:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800649:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80064c:	01 45 fc             	add    %eax,-0x4(%rbp)
  80064f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800652:	48 98                	cltq   
  800654:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80065b:	0f 82 78 ff ff ff    	jb     8005d9 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  800661:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800664:	c9                   	leaveq 
  800665:	c3                   	retq   

0000000000800666 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  800666:	55                   	push   %rbp
  800667:	48 89 e5             	mov    %rsp,%rbp
  80066a:	48 83 ec 08          	sub    $0x8,%rsp
  80066e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  800672:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800677:	c9                   	leaveq 
  800678:	c3                   	retq   

0000000000800679 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800679:	55                   	push   %rbp
  80067a:	48 89 e5             	mov    %rsp,%rbp
  80067d:	48 83 ec 10          	sub    $0x10,%rsp
  800681:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800685:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  800689:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80068d:	48 be 4c 4f 80 00 00 	movabs $0x804f4c,%rsi
  800694:	00 00 00 
  800697:	48 89 c7             	mov    %rax,%rdi
  80069a:	48 b8 49 15 80 00 00 	movabs $0x801549,%rax
  8006a1:	00 00 00 
  8006a4:	ff d0                	callq  *%rax
	return 0;
  8006a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8006ab:	c9                   	leaveq 
  8006ac:	c3                   	retq   

00000000008006ad <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8006ad:	55                   	push   %rbp
  8006ae:	48 89 e5             	mov    %rsp,%rbp
  8006b1:	48 83 ec 10          	sub    $0x10,%rsp
  8006b5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8006b8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8006bc:	48 b8 fc 1d 80 00 00 	movabs $0x801dfc,%rax
  8006c3:	00 00 00 
  8006c6:	ff d0                	callq  *%rax
  8006c8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8006cd:	48 63 d0             	movslq %eax,%rdx
  8006d0:	48 89 d0             	mov    %rdx,%rax
  8006d3:	48 c1 e0 03          	shl    $0x3,%rax
  8006d7:	48 01 d0             	add    %rdx,%rax
  8006da:	48 c1 e0 05          	shl    $0x5,%rax
  8006de:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8006e5:	00 00 00 
  8006e8:	48 01 c2             	add    %rax,%rdx
  8006eb:	48 b8 90 a7 80 00 00 	movabs $0x80a790,%rax
  8006f2:	00 00 00 
  8006f5:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8006fc:	7e 14                	jle    800712 <libmain+0x65>
		binaryname = argv[0];
  8006fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800702:	48 8b 10             	mov    (%rax),%rdx
  800705:	48 b8 b8 87 80 00 00 	movabs $0x8087b8,%rax
  80070c:	00 00 00 
  80070f:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800712:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800716:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800719:	48 89 d6             	mov    %rdx,%rsi
  80071c:	89 c7                	mov    %eax,%edi
  80071e:	48 b8 8d 00 80 00 00 	movabs $0x80008d,%rax
  800725:	00 00 00 
  800728:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  80072a:	48 b8 38 07 80 00 00 	movabs $0x800738,%rax
  800731:	00 00 00 
  800734:	ff d0                	callq  *%rax
}
  800736:	c9                   	leaveq 
  800737:	c3                   	retq   

0000000000800738 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800738:	55                   	push   %rbp
  800739:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80073c:	48 b8 f0 24 80 00 00 	movabs $0x8024f0,%rax
  800743:	00 00 00 
  800746:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800748:	bf 00 00 00 00       	mov    $0x0,%edi
  80074d:	48 b8 b8 1d 80 00 00 	movabs $0x801db8,%rax
  800754:	00 00 00 
  800757:	ff d0                	callq  *%rax

}
  800759:	5d                   	pop    %rbp
  80075a:	c3                   	retq   

000000000080075b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80075b:	55                   	push   %rbp
  80075c:	48 89 e5             	mov    %rsp,%rbp
  80075f:	53                   	push   %rbx
  800760:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800767:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80076e:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800774:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80077b:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800782:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800789:	84 c0                	test   %al,%al
  80078b:	74 23                	je     8007b0 <_panic+0x55>
  80078d:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800794:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800798:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80079c:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8007a0:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8007a4:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8007a8:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8007ac:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8007b0:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8007b7:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8007be:	00 00 00 
  8007c1:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8007c8:	00 00 00 
  8007cb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007cf:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8007d6:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8007dd:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8007e4:	48 b8 b8 87 80 00 00 	movabs $0x8087b8,%rax
  8007eb:	00 00 00 
  8007ee:	48 8b 18             	mov    (%rax),%rbx
  8007f1:	48 b8 fc 1d 80 00 00 	movabs $0x801dfc,%rax
  8007f8:	00 00 00 
  8007fb:	ff d0                	callq  *%rax
  8007fd:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800803:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80080a:	41 89 c8             	mov    %ecx,%r8d
  80080d:	48 89 d1             	mov    %rdx,%rcx
  800810:	48 89 da             	mov    %rbx,%rdx
  800813:	89 c6                	mov    %eax,%esi
  800815:	48 bf 60 4f 80 00 00 	movabs $0x804f60,%rdi
  80081c:	00 00 00 
  80081f:	b8 00 00 00 00       	mov    $0x0,%eax
  800824:	49 b9 94 09 80 00 00 	movabs $0x800994,%r9
  80082b:	00 00 00 
  80082e:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800831:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800838:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80083f:	48 89 d6             	mov    %rdx,%rsi
  800842:	48 89 c7             	mov    %rax,%rdi
  800845:	48 b8 e8 08 80 00 00 	movabs $0x8008e8,%rax
  80084c:	00 00 00 
  80084f:	ff d0                	callq  *%rax
	cprintf("\n");
  800851:	48 bf 83 4f 80 00 00 	movabs $0x804f83,%rdi
  800858:	00 00 00 
  80085b:	b8 00 00 00 00       	mov    $0x0,%eax
  800860:	48 ba 94 09 80 00 00 	movabs $0x800994,%rdx
  800867:	00 00 00 
  80086a:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80086c:	cc                   	int3   
  80086d:	eb fd                	jmp    80086c <_panic+0x111>

000000000080086f <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80086f:	55                   	push   %rbp
  800870:	48 89 e5             	mov    %rsp,%rbp
  800873:	48 83 ec 10          	sub    $0x10,%rsp
  800877:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80087a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80087e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800882:	8b 00                	mov    (%rax),%eax
  800884:	8d 48 01             	lea    0x1(%rax),%ecx
  800887:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80088b:	89 0a                	mov    %ecx,(%rdx)
  80088d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800890:	89 d1                	mov    %edx,%ecx
  800892:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800896:	48 98                	cltq   
  800898:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80089c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008a0:	8b 00                	mov    (%rax),%eax
  8008a2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8008a7:	75 2c                	jne    8008d5 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8008a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008ad:	8b 00                	mov    (%rax),%eax
  8008af:	48 98                	cltq   
  8008b1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8008b5:	48 83 c2 08          	add    $0x8,%rdx
  8008b9:	48 89 c6             	mov    %rax,%rsi
  8008bc:	48 89 d7             	mov    %rdx,%rdi
  8008bf:	48 b8 30 1d 80 00 00 	movabs $0x801d30,%rax
  8008c6:	00 00 00 
  8008c9:	ff d0                	callq  *%rax
        b->idx = 0;
  8008cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008cf:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8008d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008d9:	8b 40 04             	mov    0x4(%rax),%eax
  8008dc:	8d 50 01             	lea    0x1(%rax),%edx
  8008df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008e3:	89 50 04             	mov    %edx,0x4(%rax)
}
  8008e6:	c9                   	leaveq 
  8008e7:	c3                   	retq   

00000000008008e8 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8008e8:	55                   	push   %rbp
  8008e9:	48 89 e5             	mov    %rsp,%rbp
  8008ec:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8008f3:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8008fa:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800901:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800908:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80090f:	48 8b 0a             	mov    (%rdx),%rcx
  800912:	48 89 08             	mov    %rcx,(%rax)
  800915:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800919:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80091d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800921:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800925:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80092c:	00 00 00 
    b.cnt = 0;
  80092f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800936:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800939:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800940:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800947:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80094e:	48 89 c6             	mov    %rax,%rsi
  800951:	48 bf 6f 08 80 00 00 	movabs $0x80086f,%rdi
  800958:	00 00 00 
  80095b:	48 b8 47 0d 80 00 00 	movabs $0x800d47,%rax
  800962:	00 00 00 
  800965:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800967:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80096d:	48 98                	cltq   
  80096f:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800976:	48 83 c2 08          	add    $0x8,%rdx
  80097a:	48 89 c6             	mov    %rax,%rsi
  80097d:	48 89 d7             	mov    %rdx,%rdi
  800980:	48 b8 30 1d 80 00 00 	movabs $0x801d30,%rax
  800987:	00 00 00 
  80098a:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80098c:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800992:	c9                   	leaveq 
  800993:	c3                   	retq   

0000000000800994 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800994:	55                   	push   %rbp
  800995:	48 89 e5             	mov    %rsp,%rbp
  800998:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80099f:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8009a6:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8009ad:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8009b4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8009bb:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8009c2:	84 c0                	test   %al,%al
  8009c4:	74 20                	je     8009e6 <cprintf+0x52>
  8009c6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8009ca:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8009ce:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8009d2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8009d6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8009da:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8009de:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8009e2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8009e6:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8009ed:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8009f4:	00 00 00 
  8009f7:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8009fe:	00 00 00 
  800a01:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800a05:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800a0c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800a13:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800a1a:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800a21:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800a28:	48 8b 0a             	mov    (%rdx),%rcx
  800a2b:	48 89 08             	mov    %rcx,(%rax)
  800a2e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a32:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a36:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a3a:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800a3e:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800a45:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800a4c:	48 89 d6             	mov    %rdx,%rsi
  800a4f:	48 89 c7             	mov    %rax,%rdi
  800a52:	48 b8 e8 08 80 00 00 	movabs $0x8008e8,%rax
  800a59:	00 00 00 
  800a5c:	ff d0                	callq  *%rax
  800a5e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800a64:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800a6a:	c9                   	leaveq 
  800a6b:	c3                   	retq   

0000000000800a6c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a6c:	55                   	push   %rbp
  800a6d:	48 89 e5             	mov    %rsp,%rbp
  800a70:	53                   	push   %rbx
  800a71:	48 83 ec 38          	sub    $0x38,%rsp
  800a75:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a79:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800a7d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800a81:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800a84:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800a88:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a8c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800a8f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800a93:	77 3b                	ja     800ad0 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a95:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800a98:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800a9c:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800a9f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800aa3:	ba 00 00 00 00       	mov    $0x0,%edx
  800aa8:	48 f7 f3             	div    %rbx
  800aab:	48 89 c2             	mov    %rax,%rdx
  800aae:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800ab1:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800ab4:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800ab8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800abc:	41 89 f9             	mov    %edi,%r9d
  800abf:	48 89 c7             	mov    %rax,%rdi
  800ac2:	48 b8 6c 0a 80 00 00 	movabs $0x800a6c,%rax
  800ac9:	00 00 00 
  800acc:	ff d0                	callq  *%rax
  800ace:	eb 1e                	jmp    800aee <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ad0:	eb 12                	jmp    800ae4 <printnum+0x78>
			putch(padc, putdat);
  800ad2:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800ad6:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800ad9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800add:	48 89 ce             	mov    %rcx,%rsi
  800ae0:	89 d7                	mov    %edx,%edi
  800ae2:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ae4:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800ae8:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800aec:	7f e4                	jg     800ad2 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800aee:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800af1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800af5:	ba 00 00 00 00       	mov    $0x0,%edx
  800afa:	48 f7 f1             	div    %rcx
  800afd:	48 89 d0             	mov    %rdx,%rax
  800b00:	48 ba 90 51 80 00 00 	movabs $0x805190,%rdx
  800b07:	00 00 00 
  800b0a:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800b0e:	0f be d0             	movsbl %al,%edx
  800b11:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800b15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b19:	48 89 ce             	mov    %rcx,%rsi
  800b1c:	89 d7                	mov    %edx,%edi
  800b1e:	ff d0                	callq  *%rax
}
  800b20:	48 83 c4 38          	add    $0x38,%rsp
  800b24:	5b                   	pop    %rbx
  800b25:	5d                   	pop    %rbp
  800b26:	c3                   	retq   

0000000000800b27 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b27:	55                   	push   %rbp
  800b28:	48 89 e5             	mov    %rsp,%rbp
  800b2b:	48 83 ec 1c          	sub    $0x1c,%rsp
  800b2f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800b33:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800b36:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800b3a:	7e 52                	jle    800b8e <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800b3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b40:	8b 00                	mov    (%rax),%eax
  800b42:	83 f8 30             	cmp    $0x30,%eax
  800b45:	73 24                	jae    800b6b <getuint+0x44>
  800b47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b4b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b4f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b53:	8b 00                	mov    (%rax),%eax
  800b55:	89 c0                	mov    %eax,%eax
  800b57:	48 01 d0             	add    %rdx,%rax
  800b5a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b5e:	8b 12                	mov    (%rdx),%edx
  800b60:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b63:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b67:	89 0a                	mov    %ecx,(%rdx)
  800b69:	eb 17                	jmp    800b82 <getuint+0x5b>
  800b6b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b6f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b73:	48 89 d0             	mov    %rdx,%rax
  800b76:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b7a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b7e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b82:	48 8b 00             	mov    (%rax),%rax
  800b85:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b89:	e9 a3 00 00 00       	jmpq   800c31 <getuint+0x10a>
	else if (lflag)
  800b8e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800b92:	74 4f                	je     800be3 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800b94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b98:	8b 00                	mov    (%rax),%eax
  800b9a:	83 f8 30             	cmp    $0x30,%eax
  800b9d:	73 24                	jae    800bc3 <getuint+0x9c>
  800b9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ba3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ba7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bab:	8b 00                	mov    (%rax),%eax
  800bad:	89 c0                	mov    %eax,%eax
  800baf:	48 01 d0             	add    %rdx,%rax
  800bb2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bb6:	8b 12                	mov    (%rdx),%edx
  800bb8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800bbb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bbf:	89 0a                	mov    %ecx,(%rdx)
  800bc1:	eb 17                	jmp    800bda <getuint+0xb3>
  800bc3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bc7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800bcb:	48 89 d0             	mov    %rdx,%rax
  800bce:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800bd2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bd6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800bda:	48 8b 00             	mov    (%rax),%rax
  800bdd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800be1:	eb 4e                	jmp    800c31 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800be3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800be7:	8b 00                	mov    (%rax),%eax
  800be9:	83 f8 30             	cmp    $0x30,%eax
  800bec:	73 24                	jae    800c12 <getuint+0xeb>
  800bee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bf2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800bf6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bfa:	8b 00                	mov    (%rax),%eax
  800bfc:	89 c0                	mov    %eax,%eax
  800bfe:	48 01 d0             	add    %rdx,%rax
  800c01:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c05:	8b 12                	mov    (%rdx),%edx
  800c07:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800c0a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c0e:	89 0a                	mov    %ecx,(%rdx)
  800c10:	eb 17                	jmp    800c29 <getuint+0x102>
  800c12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c16:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800c1a:	48 89 d0             	mov    %rdx,%rax
  800c1d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800c21:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c25:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800c29:	8b 00                	mov    (%rax),%eax
  800c2b:	89 c0                	mov    %eax,%eax
  800c2d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800c31:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800c35:	c9                   	leaveq 
  800c36:	c3                   	retq   

0000000000800c37 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c37:	55                   	push   %rbp
  800c38:	48 89 e5             	mov    %rsp,%rbp
  800c3b:	48 83 ec 1c          	sub    $0x1c,%rsp
  800c3f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800c43:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800c46:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800c4a:	7e 52                	jle    800c9e <getint+0x67>
		x=va_arg(*ap, long long);
  800c4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c50:	8b 00                	mov    (%rax),%eax
  800c52:	83 f8 30             	cmp    $0x30,%eax
  800c55:	73 24                	jae    800c7b <getint+0x44>
  800c57:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c5b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800c5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c63:	8b 00                	mov    (%rax),%eax
  800c65:	89 c0                	mov    %eax,%eax
  800c67:	48 01 d0             	add    %rdx,%rax
  800c6a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c6e:	8b 12                	mov    (%rdx),%edx
  800c70:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800c73:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c77:	89 0a                	mov    %ecx,(%rdx)
  800c79:	eb 17                	jmp    800c92 <getint+0x5b>
  800c7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c7f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800c83:	48 89 d0             	mov    %rdx,%rax
  800c86:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800c8a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c8e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800c92:	48 8b 00             	mov    (%rax),%rax
  800c95:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800c99:	e9 a3 00 00 00       	jmpq   800d41 <getint+0x10a>
	else if (lflag)
  800c9e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800ca2:	74 4f                	je     800cf3 <getint+0xbc>
		x=va_arg(*ap, long);
  800ca4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ca8:	8b 00                	mov    (%rax),%eax
  800caa:	83 f8 30             	cmp    $0x30,%eax
  800cad:	73 24                	jae    800cd3 <getint+0x9c>
  800caf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cb3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800cb7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cbb:	8b 00                	mov    (%rax),%eax
  800cbd:	89 c0                	mov    %eax,%eax
  800cbf:	48 01 d0             	add    %rdx,%rax
  800cc2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cc6:	8b 12                	mov    (%rdx),%edx
  800cc8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ccb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ccf:	89 0a                	mov    %ecx,(%rdx)
  800cd1:	eb 17                	jmp    800cea <getint+0xb3>
  800cd3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cd7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800cdb:	48 89 d0             	mov    %rdx,%rax
  800cde:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800ce2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ce6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800cea:	48 8b 00             	mov    (%rax),%rax
  800ced:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800cf1:	eb 4e                	jmp    800d41 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800cf3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cf7:	8b 00                	mov    (%rax),%eax
  800cf9:	83 f8 30             	cmp    $0x30,%eax
  800cfc:	73 24                	jae    800d22 <getint+0xeb>
  800cfe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d02:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800d06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d0a:	8b 00                	mov    (%rax),%eax
  800d0c:	89 c0                	mov    %eax,%eax
  800d0e:	48 01 d0             	add    %rdx,%rax
  800d11:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d15:	8b 12                	mov    (%rdx),%edx
  800d17:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800d1a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d1e:	89 0a                	mov    %ecx,(%rdx)
  800d20:	eb 17                	jmp    800d39 <getint+0x102>
  800d22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d26:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800d2a:	48 89 d0             	mov    %rdx,%rax
  800d2d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800d31:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d35:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800d39:	8b 00                	mov    (%rax),%eax
  800d3b:	48 98                	cltq   
  800d3d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800d41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800d45:	c9                   	leaveq 
  800d46:	c3                   	retq   

0000000000800d47 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d47:	55                   	push   %rbp
  800d48:	48 89 e5             	mov    %rsp,%rbp
  800d4b:	41 54                	push   %r12
  800d4d:	53                   	push   %rbx
  800d4e:	48 83 ec 60          	sub    $0x60,%rsp
  800d52:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800d56:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800d5a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800d5e:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800d62:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d66:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800d6a:	48 8b 0a             	mov    (%rdx),%rcx
  800d6d:	48 89 08             	mov    %rcx,(%rax)
  800d70:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d74:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d78:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d7c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d80:	eb 17                	jmp    800d99 <vprintfmt+0x52>
			if (ch == '\0')
  800d82:	85 db                	test   %ebx,%ebx
  800d84:	0f 84 cc 04 00 00    	je     801256 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800d8a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d8e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d92:	48 89 d6             	mov    %rdx,%rsi
  800d95:	89 df                	mov    %ebx,%edi
  800d97:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d99:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d9d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800da1:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800da5:	0f b6 00             	movzbl (%rax),%eax
  800da8:	0f b6 d8             	movzbl %al,%ebx
  800dab:	83 fb 25             	cmp    $0x25,%ebx
  800dae:	75 d2                	jne    800d82 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800db0:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800db4:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800dbb:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800dc2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800dc9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800dd0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800dd4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800dd8:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800ddc:	0f b6 00             	movzbl (%rax),%eax
  800ddf:	0f b6 d8             	movzbl %al,%ebx
  800de2:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800de5:	83 f8 55             	cmp    $0x55,%eax
  800de8:	0f 87 34 04 00 00    	ja     801222 <vprintfmt+0x4db>
  800dee:	89 c0                	mov    %eax,%eax
  800df0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800df7:	00 
  800df8:	48 b8 b8 51 80 00 00 	movabs $0x8051b8,%rax
  800dff:	00 00 00 
  800e02:	48 01 d0             	add    %rdx,%rax
  800e05:	48 8b 00             	mov    (%rax),%rax
  800e08:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800e0a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800e0e:	eb c0                	jmp    800dd0 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e10:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800e14:	eb ba                	jmp    800dd0 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e16:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800e1d:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800e20:	89 d0                	mov    %edx,%eax
  800e22:	c1 e0 02             	shl    $0x2,%eax
  800e25:	01 d0                	add    %edx,%eax
  800e27:	01 c0                	add    %eax,%eax
  800e29:	01 d8                	add    %ebx,%eax
  800e2b:	83 e8 30             	sub    $0x30,%eax
  800e2e:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800e31:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800e35:	0f b6 00             	movzbl (%rax),%eax
  800e38:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e3b:	83 fb 2f             	cmp    $0x2f,%ebx
  800e3e:	7e 0c                	jle    800e4c <vprintfmt+0x105>
  800e40:	83 fb 39             	cmp    $0x39,%ebx
  800e43:	7f 07                	jg     800e4c <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e45:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e4a:	eb d1                	jmp    800e1d <vprintfmt+0xd6>
			goto process_precision;
  800e4c:	eb 58                	jmp    800ea6 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800e4e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e51:	83 f8 30             	cmp    $0x30,%eax
  800e54:	73 17                	jae    800e6d <vprintfmt+0x126>
  800e56:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e5a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e5d:	89 c0                	mov    %eax,%eax
  800e5f:	48 01 d0             	add    %rdx,%rax
  800e62:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e65:	83 c2 08             	add    $0x8,%edx
  800e68:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e6b:	eb 0f                	jmp    800e7c <vprintfmt+0x135>
  800e6d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e71:	48 89 d0             	mov    %rdx,%rax
  800e74:	48 83 c2 08          	add    $0x8,%rdx
  800e78:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e7c:	8b 00                	mov    (%rax),%eax
  800e7e:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800e81:	eb 23                	jmp    800ea6 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800e83:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e87:	79 0c                	jns    800e95 <vprintfmt+0x14e>
				width = 0;
  800e89:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800e90:	e9 3b ff ff ff       	jmpq   800dd0 <vprintfmt+0x89>
  800e95:	e9 36 ff ff ff       	jmpq   800dd0 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800e9a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800ea1:	e9 2a ff ff ff       	jmpq   800dd0 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800ea6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800eaa:	79 12                	jns    800ebe <vprintfmt+0x177>
				width = precision, precision = -1;
  800eac:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800eaf:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800eb2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800eb9:	e9 12 ff ff ff       	jmpq   800dd0 <vprintfmt+0x89>
  800ebe:	e9 0d ff ff ff       	jmpq   800dd0 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ec3:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800ec7:	e9 04 ff ff ff       	jmpq   800dd0 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800ecc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ecf:	83 f8 30             	cmp    $0x30,%eax
  800ed2:	73 17                	jae    800eeb <vprintfmt+0x1a4>
  800ed4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ed8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800edb:	89 c0                	mov    %eax,%eax
  800edd:	48 01 d0             	add    %rdx,%rax
  800ee0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ee3:	83 c2 08             	add    $0x8,%edx
  800ee6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ee9:	eb 0f                	jmp    800efa <vprintfmt+0x1b3>
  800eeb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800eef:	48 89 d0             	mov    %rdx,%rax
  800ef2:	48 83 c2 08          	add    $0x8,%rdx
  800ef6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800efa:	8b 10                	mov    (%rax),%edx
  800efc:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800f00:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f04:	48 89 ce             	mov    %rcx,%rsi
  800f07:	89 d7                	mov    %edx,%edi
  800f09:	ff d0                	callq  *%rax
			break;
  800f0b:	e9 40 03 00 00       	jmpq   801250 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800f10:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f13:	83 f8 30             	cmp    $0x30,%eax
  800f16:	73 17                	jae    800f2f <vprintfmt+0x1e8>
  800f18:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800f1c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f1f:	89 c0                	mov    %eax,%eax
  800f21:	48 01 d0             	add    %rdx,%rax
  800f24:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f27:	83 c2 08             	add    $0x8,%edx
  800f2a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800f2d:	eb 0f                	jmp    800f3e <vprintfmt+0x1f7>
  800f2f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f33:	48 89 d0             	mov    %rdx,%rax
  800f36:	48 83 c2 08          	add    $0x8,%rdx
  800f3a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f3e:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800f40:	85 db                	test   %ebx,%ebx
  800f42:	79 02                	jns    800f46 <vprintfmt+0x1ff>
				err = -err;
  800f44:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800f46:	83 fb 15             	cmp    $0x15,%ebx
  800f49:	7f 16                	jg     800f61 <vprintfmt+0x21a>
  800f4b:	48 b8 e0 50 80 00 00 	movabs $0x8050e0,%rax
  800f52:	00 00 00 
  800f55:	48 63 d3             	movslq %ebx,%rdx
  800f58:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800f5c:	4d 85 e4             	test   %r12,%r12
  800f5f:	75 2e                	jne    800f8f <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800f61:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f65:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f69:	89 d9                	mov    %ebx,%ecx
  800f6b:	48 ba a1 51 80 00 00 	movabs $0x8051a1,%rdx
  800f72:	00 00 00 
  800f75:	48 89 c7             	mov    %rax,%rdi
  800f78:	b8 00 00 00 00       	mov    $0x0,%eax
  800f7d:	49 b8 5f 12 80 00 00 	movabs $0x80125f,%r8
  800f84:	00 00 00 
  800f87:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f8a:	e9 c1 02 00 00       	jmpq   801250 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f8f:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f93:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f97:	4c 89 e1             	mov    %r12,%rcx
  800f9a:	48 ba aa 51 80 00 00 	movabs $0x8051aa,%rdx
  800fa1:	00 00 00 
  800fa4:	48 89 c7             	mov    %rax,%rdi
  800fa7:	b8 00 00 00 00       	mov    $0x0,%eax
  800fac:	49 b8 5f 12 80 00 00 	movabs $0x80125f,%r8
  800fb3:	00 00 00 
  800fb6:	41 ff d0             	callq  *%r8
			break;
  800fb9:	e9 92 02 00 00       	jmpq   801250 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800fbe:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800fc1:	83 f8 30             	cmp    $0x30,%eax
  800fc4:	73 17                	jae    800fdd <vprintfmt+0x296>
  800fc6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800fca:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800fcd:	89 c0                	mov    %eax,%eax
  800fcf:	48 01 d0             	add    %rdx,%rax
  800fd2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800fd5:	83 c2 08             	add    $0x8,%edx
  800fd8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800fdb:	eb 0f                	jmp    800fec <vprintfmt+0x2a5>
  800fdd:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800fe1:	48 89 d0             	mov    %rdx,%rax
  800fe4:	48 83 c2 08          	add    $0x8,%rdx
  800fe8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800fec:	4c 8b 20             	mov    (%rax),%r12
  800fef:	4d 85 e4             	test   %r12,%r12
  800ff2:	75 0a                	jne    800ffe <vprintfmt+0x2b7>
				p = "(null)";
  800ff4:	49 bc ad 51 80 00 00 	movabs $0x8051ad,%r12
  800ffb:	00 00 00 
			if (width > 0 && padc != '-')
  800ffe:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801002:	7e 3f                	jle    801043 <vprintfmt+0x2fc>
  801004:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  801008:	74 39                	je     801043 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  80100a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80100d:	48 98                	cltq   
  80100f:	48 89 c6             	mov    %rax,%rsi
  801012:	4c 89 e7             	mov    %r12,%rdi
  801015:	48 b8 0b 15 80 00 00 	movabs $0x80150b,%rax
  80101c:	00 00 00 
  80101f:	ff d0                	callq  *%rax
  801021:	29 45 dc             	sub    %eax,-0x24(%rbp)
  801024:	eb 17                	jmp    80103d <vprintfmt+0x2f6>
					putch(padc, putdat);
  801026:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  80102a:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80102e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801032:	48 89 ce             	mov    %rcx,%rsi
  801035:	89 d7                	mov    %edx,%edi
  801037:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801039:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80103d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801041:	7f e3                	jg     801026 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801043:	eb 37                	jmp    80107c <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  801045:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  801049:	74 1e                	je     801069 <vprintfmt+0x322>
  80104b:	83 fb 1f             	cmp    $0x1f,%ebx
  80104e:	7e 05                	jle    801055 <vprintfmt+0x30e>
  801050:	83 fb 7e             	cmp    $0x7e,%ebx
  801053:	7e 14                	jle    801069 <vprintfmt+0x322>
					putch('?', putdat);
  801055:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801059:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80105d:	48 89 d6             	mov    %rdx,%rsi
  801060:	bf 3f 00 00 00       	mov    $0x3f,%edi
  801065:	ff d0                	callq  *%rax
  801067:	eb 0f                	jmp    801078 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  801069:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80106d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801071:	48 89 d6             	mov    %rdx,%rsi
  801074:	89 df                	mov    %ebx,%edi
  801076:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801078:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80107c:	4c 89 e0             	mov    %r12,%rax
  80107f:	4c 8d 60 01          	lea    0x1(%rax),%r12
  801083:	0f b6 00             	movzbl (%rax),%eax
  801086:	0f be d8             	movsbl %al,%ebx
  801089:	85 db                	test   %ebx,%ebx
  80108b:	74 10                	je     80109d <vprintfmt+0x356>
  80108d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801091:	78 b2                	js     801045 <vprintfmt+0x2fe>
  801093:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  801097:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80109b:	79 a8                	jns    801045 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80109d:	eb 16                	jmp    8010b5 <vprintfmt+0x36e>
				putch(' ', putdat);
  80109f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010a3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010a7:	48 89 d6             	mov    %rdx,%rsi
  8010aa:	bf 20 00 00 00       	mov    $0x20,%edi
  8010af:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8010b1:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8010b5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8010b9:	7f e4                	jg     80109f <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  8010bb:	e9 90 01 00 00       	jmpq   801250 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  8010c0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8010c4:	be 03 00 00 00       	mov    $0x3,%esi
  8010c9:	48 89 c7             	mov    %rax,%rdi
  8010cc:	48 b8 37 0c 80 00 00 	movabs $0x800c37,%rax
  8010d3:	00 00 00 
  8010d6:	ff d0                	callq  *%rax
  8010d8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8010dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010e0:	48 85 c0             	test   %rax,%rax
  8010e3:	79 1d                	jns    801102 <vprintfmt+0x3bb>
				putch('-', putdat);
  8010e5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010e9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010ed:	48 89 d6             	mov    %rdx,%rsi
  8010f0:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8010f5:	ff d0                	callq  *%rax
				num = -(long long) num;
  8010f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010fb:	48 f7 d8             	neg    %rax
  8010fe:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  801102:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801109:	e9 d5 00 00 00       	jmpq   8011e3 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  80110e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801112:	be 03 00 00 00       	mov    $0x3,%esi
  801117:	48 89 c7             	mov    %rax,%rdi
  80111a:	48 b8 27 0b 80 00 00 	movabs $0x800b27,%rax
  801121:	00 00 00 
  801124:	ff d0                	callq  *%rax
  801126:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  80112a:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801131:	e9 ad 00 00 00       	jmpq   8011e3 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  801136:	8b 55 e0             	mov    -0x20(%rbp),%edx
  801139:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80113d:	89 d6                	mov    %edx,%esi
  80113f:	48 89 c7             	mov    %rax,%rdi
  801142:	48 b8 37 0c 80 00 00 	movabs $0x800c37,%rax
  801149:	00 00 00 
  80114c:	ff d0                	callq  *%rax
  80114e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  801152:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  801159:	e9 85 00 00 00       	jmpq   8011e3 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  80115e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801162:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801166:	48 89 d6             	mov    %rdx,%rsi
  801169:	bf 30 00 00 00       	mov    $0x30,%edi
  80116e:	ff d0                	callq  *%rax
			putch('x', putdat);
  801170:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801174:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801178:	48 89 d6             	mov    %rdx,%rsi
  80117b:	bf 78 00 00 00       	mov    $0x78,%edi
  801180:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801182:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801185:	83 f8 30             	cmp    $0x30,%eax
  801188:	73 17                	jae    8011a1 <vprintfmt+0x45a>
  80118a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80118e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801191:	89 c0                	mov    %eax,%eax
  801193:	48 01 d0             	add    %rdx,%rax
  801196:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801199:	83 c2 08             	add    $0x8,%edx
  80119c:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80119f:	eb 0f                	jmp    8011b0 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  8011a1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8011a5:	48 89 d0             	mov    %rdx,%rax
  8011a8:	48 83 c2 08          	add    $0x8,%rdx
  8011ac:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8011b0:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8011b3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  8011b7:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  8011be:	eb 23                	jmp    8011e3 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  8011c0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8011c4:	be 03 00 00 00       	mov    $0x3,%esi
  8011c9:	48 89 c7             	mov    %rax,%rdi
  8011cc:	48 b8 27 0b 80 00 00 	movabs $0x800b27,%rax
  8011d3:	00 00 00 
  8011d6:	ff d0                	callq  *%rax
  8011d8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8011dc:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8011e3:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8011e8:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8011eb:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8011ee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011f2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8011f6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011fa:	45 89 c1             	mov    %r8d,%r9d
  8011fd:	41 89 f8             	mov    %edi,%r8d
  801200:	48 89 c7             	mov    %rax,%rdi
  801203:	48 b8 6c 0a 80 00 00 	movabs $0x800a6c,%rax
  80120a:	00 00 00 
  80120d:	ff d0                	callq  *%rax
			break;
  80120f:	eb 3f                	jmp    801250 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  801211:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801215:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801219:	48 89 d6             	mov    %rdx,%rsi
  80121c:	89 df                	mov    %ebx,%edi
  80121e:	ff d0                	callq  *%rax
			break;
  801220:	eb 2e                	jmp    801250 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801222:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801226:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80122a:	48 89 d6             	mov    %rdx,%rsi
  80122d:	bf 25 00 00 00       	mov    $0x25,%edi
  801232:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  801234:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801239:	eb 05                	jmp    801240 <vprintfmt+0x4f9>
  80123b:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801240:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801244:	48 83 e8 01          	sub    $0x1,%rax
  801248:	0f b6 00             	movzbl (%rax),%eax
  80124b:	3c 25                	cmp    $0x25,%al
  80124d:	75 ec                	jne    80123b <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  80124f:	90                   	nop
		}
	}
  801250:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801251:	e9 43 fb ff ff       	jmpq   800d99 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  801256:	48 83 c4 60          	add    $0x60,%rsp
  80125a:	5b                   	pop    %rbx
  80125b:	41 5c                	pop    %r12
  80125d:	5d                   	pop    %rbp
  80125e:	c3                   	retq   

000000000080125f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80125f:	55                   	push   %rbp
  801260:	48 89 e5             	mov    %rsp,%rbp
  801263:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80126a:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801271:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801278:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80127f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801286:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80128d:	84 c0                	test   %al,%al
  80128f:	74 20                	je     8012b1 <printfmt+0x52>
  801291:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801295:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801299:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80129d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8012a1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8012a5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8012a9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8012ad:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8012b1:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8012b8:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8012bf:	00 00 00 
  8012c2:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8012c9:	00 00 00 
  8012cc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8012d0:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8012d7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8012de:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8012e5:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8012ec:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8012f3:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8012fa:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801301:	48 89 c7             	mov    %rax,%rdi
  801304:	48 b8 47 0d 80 00 00 	movabs $0x800d47,%rax
  80130b:	00 00 00 
  80130e:	ff d0                	callq  *%rax
	va_end(ap);
}
  801310:	c9                   	leaveq 
  801311:	c3                   	retq   

0000000000801312 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801312:	55                   	push   %rbp
  801313:	48 89 e5             	mov    %rsp,%rbp
  801316:	48 83 ec 10          	sub    $0x10,%rsp
  80131a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80131d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801321:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801325:	8b 40 10             	mov    0x10(%rax),%eax
  801328:	8d 50 01             	lea    0x1(%rax),%edx
  80132b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80132f:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801332:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801336:	48 8b 10             	mov    (%rax),%rdx
  801339:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80133d:	48 8b 40 08          	mov    0x8(%rax),%rax
  801341:	48 39 c2             	cmp    %rax,%rdx
  801344:	73 17                	jae    80135d <sprintputch+0x4b>
		*b->buf++ = ch;
  801346:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80134a:	48 8b 00             	mov    (%rax),%rax
  80134d:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801351:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801355:	48 89 0a             	mov    %rcx,(%rdx)
  801358:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80135b:	88 10                	mov    %dl,(%rax)
}
  80135d:	c9                   	leaveq 
  80135e:	c3                   	retq   

000000000080135f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80135f:	55                   	push   %rbp
  801360:	48 89 e5             	mov    %rsp,%rbp
  801363:	48 83 ec 50          	sub    $0x50,%rsp
  801367:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80136b:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80136e:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801372:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801376:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80137a:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80137e:	48 8b 0a             	mov    (%rdx),%rcx
  801381:	48 89 08             	mov    %rcx,(%rax)
  801384:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801388:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80138c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801390:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801394:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801398:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80139c:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80139f:	48 98                	cltq   
  8013a1:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8013a5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8013a9:	48 01 d0             	add    %rdx,%rax
  8013ac:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8013b0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8013b7:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8013bc:	74 06                	je     8013c4 <vsnprintf+0x65>
  8013be:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8013c2:	7f 07                	jg     8013cb <vsnprintf+0x6c>
		return -E_INVAL;
  8013c4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013c9:	eb 2f                	jmp    8013fa <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8013cb:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8013cf:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8013d3:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8013d7:	48 89 c6             	mov    %rax,%rsi
  8013da:	48 bf 12 13 80 00 00 	movabs $0x801312,%rdi
  8013e1:	00 00 00 
  8013e4:	48 b8 47 0d 80 00 00 	movabs $0x800d47,%rax
  8013eb:	00 00 00 
  8013ee:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8013f0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8013f4:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8013f7:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8013fa:	c9                   	leaveq 
  8013fb:	c3                   	retq   

00000000008013fc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8013fc:	55                   	push   %rbp
  8013fd:	48 89 e5             	mov    %rsp,%rbp
  801400:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801407:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80140e:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801414:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80141b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801422:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801429:	84 c0                	test   %al,%al
  80142b:	74 20                	je     80144d <snprintf+0x51>
  80142d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801431:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801435:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801439:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80143d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801441:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801445:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801449:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80144d:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801454:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80145b:	00 00 00 
  80145e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801465:	00 00 00 
  801468:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80146c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801473:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80147a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801481:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801488:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80148f:	48 8b 0a             	mov    (%rdx),%rcx
  801492:	48 89 08             	mov    %rcx,(%rax)
  801495:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801499:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80149d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8014a1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8014a5:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8014ac:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8014b3:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8014b9:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8014c0:	48 89 c7             	mov    %rax,%rdi
  8014c3:	48 b8 5f 13 80 00 00 	movabs $0x80135f,%rax
  8014ca:	00 00 00 
  8014cd:	ff d0                	callq  *%rax
  8014cf:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8014d5:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8014db:	c9                   	leaveq 
  8014dc:	c3                   	retq   

00000000008014dd <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8014dd:	55                   	push   %rbp
  8014de:	48 89 e5             	mov    %rsp,%rbp
  8014e1:	48 83 ec 18          	sub    $0x18,%rsp
  8014e5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8014e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8014f0:	eb 09                	jmp    8014fb <strlen+0x1e>
		n++;
  8014f2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8014f6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8014fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014ff:	0f b6 00             	movzbl (%rax),%eax
  801502:	84 c0                	test   %al,%al
  801504:	75 ec                	jne    8014f2 <strlen+0x15>
		n++;
	return n;
  801506:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801509:	c9                   	leaveq 
  80150a:	c3                   	retq   

000000000080150b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80150b:	55                   	push   %rbp
  80150c:	48 89 e5             	mov    %rsp,%rbp
  80150f:	48 83 ec 20          	sub    $0x20,%rsp
  801513:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801517:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80151b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801522:	eb 0e                	jmp    801532 <strnlen+0x27>
		n++;
  801524:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801528:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80152d:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801532:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801537:	74 0b                	je     801544 <strnlen+0x39>
  801539:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80153d:	0f b6 00             	movzbl (%rax),%eax
  801540:	84 c0                	test   %al,%al
  801542:	75 e0                	jne    801524 <strnlen+0x19>
		n++;
	return n;
  801544:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801547:	c9                   	leaveq 
  801548:	c3                   	retq   

0000000000801549 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801549:	55                   	push   %rbp
  80154a:	48 89 e5             	mov    %rsp,%rbp
  80154d:	48 83 ec 20          	sub    $0x20,%rsp
  801551:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801555:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801559:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80155d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801561:	90                   	nop
  801562:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801566:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80156a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80156e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801572:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801576:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80157a:	0f b6 12             	movzbl (%rdx),%edx
  80157d:	88 10                	mov    %dl,(%rax)
  80157f:	0f b6 00             	movzbl (%rax),%eax
  801582:	84 c0                	test   %al,%al
  801584:	75 dc                	jne    801562 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801586:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80158a:	c9                   	leaveq 
  80158b:	c3                   	retq   

000000000080158c <strcat>:

char *
strcat(char *dst, const char *src)
{
  80158c:	55                   	push   %rbp
  80158d:	48 89 e5             	mov    %rsp,%rbp
  801590:	48 83 ec 20          	sub    $0x20,%rsp
  801594:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801598:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80159c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015a0:	48 89 c7             	mov    %rax,%rdi
  8015a3:	48 b8 dd 14 80 00 00 	movabs $0x8014dd,%rax
  8015aa:	00 00 00 
  8015ad:	ff d0                	callq  *%rax
  8015af:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8015b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8015b5:	48 63 d0             	movslq %eax,%rdx
  8015b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015bc:	48 01 c2             	add    %rax,%rdx
  8015bf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015c3:	48 89 c6             	mov    %rax,%rsi
  8015c6:	48 89 d7             	mov    %rdx,%rdi
  8015c9:	48 b8 49 15 80 00 00 	movabs $0x801549,%rax
  8015d0:	00 00 00 
  8015d3:	ff d0                	callq  *%rax
	return dst;
  8015d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015d9:	c9                   	leaveq 
  8015da:	c3                   	retq   

00000000008015db <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8015db:	55                   	push   %rbp
  8015dc:	48 89 e5             	mov    %rsp,%rbp
  8015df:	48 83 ec 28          	sub    $0x28,%rsp
  8015e3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015e7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8015eb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8015ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015f3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8015f7:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8015fe:	00 
  8015ff:	eb 2a                	jmp    80162b <strncpy+0x50>
		*dst++ = *src;
  801601:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801605:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801609:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80160d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801611:	0f b6 12             	movzbl (%rdx),%edx
  801614:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801616:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80161a:	0f b6 00             	movzbl (%rax),%eax
  80161d:	84 c0                	test   %al,%al
  80161f:	74 05                	je     801626 <strncpy+0x4b>
			src++;
  801621:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801626:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80162b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80162f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801633:	72 cc                	jb     801601 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801635:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801639:	c9                   	leaveq 
  80163a:	c3                   	retq   

000000000080163b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80163b:	55                   	push   %rbp
  80163c:	48 89 e5             	mov    %rsp,%rbp
  80163f:	48 83 ec 28          	sub    $0x28,%rsp
  801643:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801647:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80164b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80164f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801653:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801657:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80165c:	74 3d                	je     80169b <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80165e:	eb 1d                	jmp    80167d <strlcpy+0x42>
			*dst++ = *src++;
  801660:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801664:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801668:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80166c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801670:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801674:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801678:	0f b6 12             	movzbl (%rdx),%edx
  80167b:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80167d:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801682:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801687:	74 0b                	je     801694 <strlcpy+0x59>
  801689:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80168d:	0f b6 00             	movzbl (%rax),%eax
  801690:	84 c0                	test   %al,%al
  801692:	75 cc                	jne    801660 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801694:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801698:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80169b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80169f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016a3:	48 29 c2             	sub    %rax,%rdx
  8016a6:	48 89 d0             	mov    %rdx,%rax
}
  8016a9:	c9                   	leaveq 
  8016aa:	c3                   	retq   

00000000008016ab <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8016ab:	55                   	push   %rbp
  8016ac:	48 89 e5             	mov    %rsp,%rbp
  8016af:	48 83 ec 10          	sub    $0x10,%rsp
  8016b3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016b7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8016bb:	eb 0a                	jmp    8016c7 <strcmp+0x1c>
		p++, q++;
  8016bd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016c2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8016c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016cb:	0f b6 00             	movzbl (%rax),%eax
  8016ce:	84 c0                	test   %al,%al
  8016d0:	74 12                	je     8016e4 <strcmp+0x39>
  8016d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016d6:	0f b6 10             	movzbl (%rax),%edx
  8016d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016dd:	0f b6 00             	movzbl (%rax),%eax
  8016e0:	38 c2                	cmp    %al,%dl
  8016e2:	74 d9                	je     8016bd <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8016e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016e8:	0f b6 00             	movzbl (%rax),%eax
  8016eb:	0f b6 d0             	movzbl %al,%edx
  8016ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016f2:	0f b6 00             	movzbl (%rax),%eax
  8016f5:	0f b6 c0             	movzbl %al,%eax
  8016f8:	29 c2                	sub    %eax,%edx
  8016fa:	89 d0                	mov    %edx,%eax
}
  8016fc:	c9                   	leaveq 
  8016fd:	c3                   	retq   

00000000008016fe <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8016fe:	55                   	push   %rbp
  8016ff:	48 89 e5             	mov    %rsp,%rbp
  801702:	48 83 ec 18          	sub    $0x18,%rsp
  801706:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80170a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80170e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801712:	eb 0f                	jmp    801723 <strncmp+0x25>
		n--, p++, q++;
  801714:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801719:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80171e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801723:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801728:	74 1d                	je     801747 <strncmp+0x49>
  80172a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80172e:	0f b6 00             	movzbl (%rax),%eax
  801731:	84 c0                	test   %al,%al
  801733:	74 12                	je     801747 <strncmp+0x49>
  801735:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801739:	0f b6 10             	movzbl (%rax),%edx
  80173c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801740:	0f b6 00             	movzbl (%rax),%eax
  801743:	38 c2                	cmp    %al,%dl
  801745:	74 cd                	je     801714 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801747:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80174c:	75 07                	jne    801755 <strncmp+0x57>
		return 0;
  80174e:	b8 00 00 00 00       	mov    $0x0,%eax
  801753:	eb 18                	jmp    80176d <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801755:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801759:	0f b6 00             	movzbl (%rax),%eax
  80175c:	0f b6 d0             	movzbl %al,%edx
  80175f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801763:	0f b6 00             	movzbl (%rax),%eax
  801766:	0f b6 c0             	movzbl %al,%eax
  801769:	29 c2                	sub    %eax,%edx
  80176b:	89 d0                	mov    %edx,%eax
}
  80176d:	c9                   	leaveq 
  80176e:	c3                   	retq   

000000000080176f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80176f:	55                   	push   %rbp
  801770:	48 89 e5             	mov    %rsp,%rbp
  801773:	48 83 ec 0c          	sub    $0xc,%rsp
  801777:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80177b:	89 f0                	mov    %esi,%eax
  80177d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801780:	eb 17                	jmp    801799 <strchr+0x2a>
		if (*s == c)
  801782:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801786:	0f b6 00             	movzbl (%rax),%eax
  801789:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80178c:	75 06                	jne    801794 <strchr+0x25>
			return (char *) s;
  80178e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801792:	eb 15                	jmp    8017a9 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801794:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801799:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80179d:	0f b6 00             	movzbl (%rax),%eax
  8017a0:	84 c0                	test   %al,%al
  8017a2:	75 de                	jne    801782 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8017a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017a9:	c9                   	leaveq 
  8017aa:	c3                   	retq   

00000000008017ab <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8017ab:	55                   	push   %rbp
  8017ac:	48 89 e5             	mov    %rsp,%rbp
  8017af:	48 83 ec 0c          	sub    $0xc,%rsp
  8017b3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8017b7:	89 f0                	mov    %esi,%eax
  8017b9:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8017bc:	eb 13                	jmp    8017d1 <strfind+0x26>
		if (*s == c)
  8017be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017c2:	0f b6 00             	movzbl (%rax),%eax
  8017c5:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8017c8:	75 02                	jne    8017cc <strfind+0x21>
			break;
  8017ca:	eb 10                	jmp    8017dc <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8017cc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017d5:	0f b6 00             	movzbl (%rax),%eax
  8017d8:	84 c0                	test   %al,%al
  8017da:	75 e2                	jne    8017be <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8017dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8017e0:	c9                   	leaveq 
  8017e1:	c3                   	retq   

00000000008017e2 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8017e2:	55                   	push   %rbp
  8017e3:	48 89 e5             	mov    %rsp,%rbp
  8017e6:	48 83 ec 18          	sub    $0x18,%rsp
  8017ea:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8017ee:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8017f1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8017f5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8017fa:	75 06                	jne    801802 <memset+0x20>
		return v;
  8017fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801800:	eb 69                	jmp    80186b <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801802:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801806:	83 e0 03             	and    $0x3,%eax
  801809:	48 85 c0             	test   %rax,%rax
  80180c:	75 48                	jne    801856 <memset+0x74>
  80180e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801812:	83 e0 03             	and    $0x3,%eax
  801815:	48 85 c0             	test   %rax,%rax
  801818:	75 3c                	jne    801856 <memset+0x74>
		c &= 0xFF;
  80181a:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801821:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801824:	c1 e0 18             	shl    $0x18,%eax
  801827:	89 c2                	mov    %eax,%edx
  801829:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80182c:	c1 e0 10             	shl    $0x10,%eax
  80182f:	09 c2                	or     %eax,%edx
  801831:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801834:	c1 e0 08             	shl    $0x8,%eax
  801837:	09 d0                	or     %edx,%eax
  801839:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80183c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801840:	48 c1 e8 02          	shr    $0x2,%rax
  801844:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801847:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80184b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80184e:	48 89 d7             	mov    %rdx,%rdi
  801851:	fc                   	cld    
  801852:	f3 ab                	rep stos %eax,%es:(%rdi)
  801854:	eb 11                	jmp    801867 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801856:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80185a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80185d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801861:	48 89 d7             	mov    %rdx,%rdi
  801864:	fc                   	cld    
  801865:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801867:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80186b:	c9                   	leaveq 
  80186c:	c3                   	retq   

000000000080186d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80186d:	55                   	push   %rbp
  80186e:	48 89 e5             	mov    %rsp,%rbp
  801871:	48 83 ec 28          	sub    $0x28,%rsp
  801875:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801879:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80187d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801881:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801885:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801889:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80188d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801891:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801895:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801899:	0f 83 88 00 00 00    	jae    801927 <memmove+0xba>
  80189f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018a3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8018a7:	48 01 d0             	add    %rdx,%rax
  8018aa:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8018ae:	76 77                	jbe    801927 <memmove+0xba>
		s += n;
  8018b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b4:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8018b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018bc:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8018c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018c4:	83 e0 03             	and    $0x3,%eax
  8018c7:	48 85 c0             	test   %rax,%rax
  8018ca:	75 3b                	jne    801907 <memmove+0x9a>
  8018cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018d0:	83 e0 03             	and    $0x3,%eax
  8018d3:	48 85 c0             	test   %rax,%rax
  8018d6:	75 2f                	jne    801907 <memmove+0x9a>
  8018d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018dc:	83 e0 03             	and    $0x3,%eax
  8018df:	48 85 c0             	test   %rax,%rax
  8018e2:	75 23                	jne    801907 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8018e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018e8:	48 83 e8 04          	sub    $0x4,%rax
  8018ec:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8018f0:	48 83 ea 04          	sub    $0x4,%rdx
  8018f4:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8018f8:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8018fc:	48 89 c7             	mov    %rax,%rdi
  8018ff:	48 89 d6             	mov    %rdx,%rsi
  801902:	fd                   	std    
  801903:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801905:	eb 1d                	jmp    801924 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801907:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80190b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80190f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801913:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801917:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80191b:	48 89 d7             	mov    %rdx,%rdi
  80191e:	48 89 c1             	mov    %rax,%rcx
  801921:	fd                   	std    
  801922:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801924:	fc                   	cld    
  801925:	eb 57                	jmp    80197e <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801927:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80192b:	83 e0 03             	and    $0x3,%eax
  80192e:	48 85 c0             	test   %rax,%rax
  801931:	75 36                	jne    801969 <memmove+0xfc>
  801933:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801937:	83 e0 03             	and    $0x3,%eax
  80193a:	48 85 c0             	test   %rax,%rax
  80193d:	75 2a                	jne    801969 <memmove+0xfc>
  80193f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801943:	83 e0 03             	and    $0x3,%eax
  801946:	48 85 c0             	test   %rax,%rax
  801949:	75 1e                	jne    801969 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80194b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80194f:	48 c1 e8 02          	shr    $0x2,%rax
  801953:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801956:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80195a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80195e:	48 89 c7             	mov    %rax,%rdi
  801961:	48 89 d6             	mov    %rdx,%rsi
  801964:	fc                   	cld    
  801965:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801967:	eb 15                	jmp    80197e <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801969:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80196d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801971:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801975:	48 89 c7             	mov    %rax,%rdi
  801978:	48 89 d6             	mov    %rdx,%rsi
  80197b:	fc                   	cld    
  80197c:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80197e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801982:	c9                   	leaveq 
  801983:	c3                   	retq   

0000000000801984 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801984:	55                   	push   %rbp
  801985:	48 89 e5             	mov    %rsp,%rbp
  801988:	48 83 ec 18          	sub    $0x18,%rsp
  80198c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801990:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801994:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801998:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80199c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8019a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019a4:	48 89 ce             	mov    %rcx,%rsi
  8019a7:	48 89 c7             	mov    %rax,%rdi
  8019aa:	48 b8 6d 18 80 00 00 	movabs $0x80186d,%rax
  8019b1:	00 00 00 
  8019b4:	ff d0                	callq  *%rax
}
  8019b6:	c9                   	leaveq 
  8019b7:	c3                   	retq   

00000000008019b8 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8019b8:	55                   	push   %rbp
  8019b9:	48 89 e5             	mov    %rsp,%rbp
  8019bc:	48 83 ec 28          	sub    $0x28,%rsp
  8019c0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8019c4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8019c8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8019cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019d0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8019d4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8019d8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8019dc:	eb 36                	jmp    801a14 <memcmp+0x5c>
		if (*s1 != *s2)
  8019de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019e2:	0f b6 10             	movzbl (%rax),%edx
  8019e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019e9:	0f b6 00             	movzbl (%rax),%eax
  8019ec:	38 c2                	cmp    %al,%dl
  8019ee:	74 1a                	je     801a0a <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8019f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019f4:	0f b6 00             	movzbl (%rax),%eax
  8019f7:	0f b6 d0             	movzbl %al,%edx
  8019fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019fe:	0f b6 00             	movzbl (%rax),%eax
  801a01:	0f b6 c0             	movzbl %al,%eax
  801a04:	29 c2                	sub    %eax,%edx
  801a06:	89 d0                	mov    %edx,%eax
  801a08:	eb 20                	jmp    801a2a <memcmp+0x72>
		s1++, s2++;
  801a0a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801a0f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801a14:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a18:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801a1c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801a20:	48 85 c0             	test   %rax,%rax
  801a23:	75 b9                	jne    8019de <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801a25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a2a:	c9                   	leaveq 
  801a2b:	c3                   	retq   

0000000000801a2c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801a2c:	55                   	push   %rbp
  801a2d:	48 89 e5             	mov    %rsp,%rbp
  801a30:	48 83 ec 28          	sub    $0x28,%rsp
  801a34:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a38:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801a3b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801a3f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a43:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801a47:	48 01 d0             	add    %rdx,%rax
  801a4a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801a4e:	eb 15                	jmp    801a65 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801a50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a54:	0f b6 10             	movzbl (%rax),%edx
  801a57:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a5a:	38 c2                	cmp    %al,%dl
  801a5c:	75 02                	jne    801a60 <memfind+0x34>
			break;
  801a5e:	eb 0f                	jmp    801a6f <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801a60:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801a65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a69:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801a6d:	72 e1                	jb     801a50 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801a6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801a73:	c9                   	leaveq 
  801a74:	c3                   	retq   

0000000000801a75 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801a75:	55                   	push   %rbp
  801a76:	48 89 e5             	mov    %rsp,%rbp
  801a79:	48 83 ec 34          	sub    $0x34,%rsp
  801a7d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801a81:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801a85:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801a88:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801a8f:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801a96:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a97:	eb 05                	jmp    801a9e <strtol+0x29>
		s++;
  801a99:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a9e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aa2:	0f b6 00             	movzbl (%rax),%eax
  801aa5:	3c 20                	cmp    $0x20,%al
  801aa7:	74 f0                	je     801a99 <strtol+0x24>
  801aa9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aad:	0f b6 00             	movzbl (%rax),%eax
  801ab0:	3c 09                	cmp    $0x9,%al
  801ab2:	74 e5                	je     801a99 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801ab4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ab8:	0f b6 00             	movzbl (%rax),%eax
  801abb:	3c 2b                	cmp    $0x2b,%al
  801abd:	75 07                	jne    801ac6 <strtol+0x51>
		s++;
  801abf:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801ac4:	eb 17                	jmp    801add <strtol+0x68>
	else if (*s == '-')
  801ac6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aca:	0f b6 00             	movzbl (%rax),%eax
  801acd:	3c 2d                	cmp    $0x2d,%al
  801acf:	75 0c                	jne    801add <strtol+0x68>
		s++, neg = 1;
  801ad1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801ad6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801add:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801ae1:	74 06                	je     801ae9 <strtol+0x74>
  801ae3:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801ae7:	75 28                	jne    801b11 <strtol+0x9c>
  801ae9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aed:	0f b6 00             	movzbl (%rax),%eax
  801af0:	3c 30                	cmp    $0x30,%al
  801af2:	75 1d                	jne    801b11 <strtol+0x9c>
  801af4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801af8:	48 83 c0 01          	add    $0x1,%rax
  801afc:	0f b6 00             	movzbl (%rax),%eax
  801aff:	3c 78                	cmp    $0x78,%al
  801b01:	75 0e                	jne    801b11 <strtol+0x9c>
		s += 2, base = 16;
  801b03:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801b08:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801b0f:	eb 2c                	jmp    801b3d <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801b11:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801b15:	75 19                	jne    801b30 <strtol+0xbb>
  801b17:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b1b:	0f b6 00             	movzbl (%rax),%eax
  801b1e:	3c 30                	cmp    $0x30,%al
  801b20:	75 0e                	jne    801b30 <strtol+0xbb>
		s++, base = 8;
  801b22:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801b27:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801b2e:	eb 0d                	jmp    801b3d <strtol+0xc8>
	else if (base == 0)
  801b30:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801b34:	75 07                	jne    801b3d <strtol+0xc8>
		base = 10;
  801b36:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801b3d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b41:	0f b6 00             	movzbl (%rax),%eax
  801b44:	3c 2f                	cmp    $0x2f,%al
  801b46:	7e 1d                	jle    801b65 <strtol+0xf0>
  801b48:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b4c:	0f b6 00             	movzbl (%rax),%eax
  801b4f:	3c 39                	cmp    $0x39,%al
  801b51:	7f 12                	jg     801b65 <strtol+0xf0>
			dig = *s - '0';
  801b53:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b57:	0f b6 00             	movzbl (%rax),%eax
  801b5a:	0f be c0             	movsbl %al,%eax
  801b5d:	83 e8 30             	sub    $0x30,%eax
  801b60:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801b63:	eb 4e                	jmp    801bb3 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801b65:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b69:	0f b6 00             	movzbl (%rax),%eax
  801b6c:	3c 60                	cmp    $0x60,%al
  801b6e:	7e 1d                	jle    801b8d <strtol+0x118>
  801b70:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b74:	0f b6 00             	movzbl (%rax),%eax
  801b77:	3c 7a                	cmp    $0x7a,%al
  801b79:	7f 12                	jg     801b8d <strtol+0x118>
			dig = *s - 'a' + 10;
  801b7b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b7f:	0f b6 00             	movzbl (%rax),%eax
  801b82:	0f be c0             	movsbl %al,%eax
  801b85:	83 e8 57             	sub    $0x57,%eax
  801b88:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801b8b:	eb 26                	jmp    801bb3 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801b8d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b91:	0f b6 00             	movzbl (%rax),%eax
  801b94:	3c 40                	cmp    $0x40,%al
  801b96:	7e 48                	jle    801be0 <strtol+0x16b>
  801b98:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b9c:	0f b6 00             	movzbl (%rax),%eax
  801b9f:	3c 5a                	cmp    $0x5a,%al
  801ba1:	7f 3d                	jg     801be0 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801ba3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ba7:	0f b6 00             	movzbl (%rax),%eax
  801baa:	0f be c0             	movsbl %al,%eax
  801bad:	83 e8 37             	sub    $0x37,%eax
  801bb0:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801bb3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801bb6:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801bb9:	7c 02                	jl     801bbd <strtol+0x148>
			break;
  801bbb:	eb 23                	jmp    801be0 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801bbd:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801bc2:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801bc5:	48 98                	cltq   
  801bc7:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801bcc:	48 89 c2             	mov    %rax,%rdx
  801bcf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801bd2:	48 98                	cltq   
  801bd4:	48 01 d0             	add    %rdx,%rax
  801bd7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801bdb:	e9 5d ff ff ff       	jmpq   801b3d <strtol+0xc8>

	if (endptr)
  801be0:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801be5:	74 0b                	je     801bf2 <strtol+0x17d>
		*endptr = (char *) s;
  801be7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801beb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801bef:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801bf2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bf6:	74 09                	je     801c01 <strtol+0x18c>
  801bf8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bfc:	48 f7 d8             	neg    %rax
  801bff:	eb 04                	jmp    801c05 <strtol+0x190>
  801c01:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801c05:	c9                   	leaveq 
  801c06:	c3                   	retq   

0000000000801c07 <strstr>:

char * strstr(const char *in, const char *str)
{
  801c07:	55                   	push   %rbp
  801c08:	48 89 e5             	mov    %rsp,%rbp
  801c0b:	48 83 ec 30          	sub    $0x30,%rsp
  801c0f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801c13:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801c17:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c1b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801c1f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801c23:	0f b6 00             	movzbl (%rax),%eax
  801c26:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801c29:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801c2d:	75 06                	jne    801c35 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801c2f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c33:	eb 6b                	jmp    801ca0 <strstr+0x99>

	len = strlen(str);
  801c35:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c39:	48 89 c7             	mov    %rax,%rdi
  801c3c:	48 b8 dd 14 80 00 00 	movabs $0x8014dd,%rax
  801c43:	00 00 00 
  801c46:	ff d0                	callq  *%rax
  801c48:	48 98                	cltq   
  801c4a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801c4e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c52:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801c56:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801c5a:	0f b6 00             	movzbl (%rax),%eax
  801c5d:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801c60:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801c64:	75 07                	jne    801c6d <strstr+0x66>
				return (char *) 0;
  801c66:	b8 00 00 00 00       	mov    $0x0,%eax
  801c6b:	eb 33                	jmp    801ca0 <strstr+0x99>
		} while (sc != c);
  801c6d:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801c71:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801c74:	75 d8                	jne    801c4e <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801c76:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c7a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801c7e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c82:	48 89 ce             	mov    %rcx,%rsi
  801c85:	48 89 c7             	mov    %rax,%rdi
  801c88:	48 b8 fe 16 80 00 00 	movabs $0x8016fe,%rax
  801c8f:	00 00 00 
  801c92:	ff d0                	callq  *%rax
  801c94:	85 c0                	test   %eax,%eax
  801c96:	75 b6                	jne    801c4e <strstr+0x47>

	return (char *) (in - 1);
  801c98:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c9c:	48 83 e8 01          	sub    $0x1,%rax
}
  801ca0:	c9                   	leaveq 
  801ca1:	c3                   	retq   

0000000000801ca2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801ca2:	55                   	push   %rbp
  801ca3:	48 89 e5             	mov    %rsp,%rbp
  801ca6:	53                   	push   %rbx
  801ca7:	48 83 ec 48          	sub    $0x48,%rsp
  801cab:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801cae:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801cb1:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801cb5:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801cb9:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801cbd:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801cc1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801cc4:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801cc8:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801ccc:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801cd0:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801cd4:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801cd8:	4c 89 c3             	mov    %r8,%rbx
  801cdb:	cd 30                	int    $0x30
  801cdd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801ce1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801ce5:	74 3e                	je     801d25 <syscall+0x83>
  801ce7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801cec:	7e 37                	jle    801d25 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801cee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801cf2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801cf5:	49 89 d0             	mov    %rdx,%r8
  801cf8:	89 c1                	mov    %eax,%ecx
  801cfa:	48 ba 68 54 80 00 00 	movabs $0x805468,%rdx
  801d01:	00 00 00 
  801d04:	be 23 00 00 00       	mov    $0x23,%esi
  801d09:	48 bf 85 54 80 00 00 	movabs $0x805485,%rdi
  801d10:	00 00 00 
  801d13:	b8 00 00 00 00       	mov    $0x0,%eax
  801d18:	49 b9 5b 07 80 00 00 	movabs $0x80075b,%r9
  801d1f:	00 00 00 
  801d22:	41 ff d1             	callq  *%r9

	return ret;
  801d25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801d29:	48 83 c4 48          	add    $0x48,%rsp
  801d2d:	5b                   	pop    %rbx
  801d2e:	5d                   	pop    %rbp
  801d2f:	c3                   	retq   

0000000000801d30 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801d30:	55                   	push   %rbp
  801d31:	48 89 e5             	mov    %rsp,%rbp
  801d34:	48 83 ec 20          	sub    $0x20,%rsp
  801d38:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d3c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801d40:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d44:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d48:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d4f:	00 
  801d50:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d56:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d5c:	48 89 d1             	mov    %rdx,%rcx
  801d5f:	48 89 c2             	mov    %rax,%rdx
  801d62:	be 00 00 00 00       	mov    $0x0,%esi
  801d67:	bf 00 00 00 00       	mov    $0x0,%edi
  801d6c:	48 b8 a2 1c 80 00 00 	movabs $0x801ca2,%rax
  801d73:	00 00 00 
  801d76:	ff d0                	callq  *%rax
}
  801d78:	c9                   	leaveq 
  801d79:	c3                   	retq   

0000000000801d7a <sys_cgetc>:

int
sys_cgetc(void)
{
  801d7a:	55                   	push   %rbp
  801d7b:	48 89 e5             	mov    %rsp,%rbp
  801d7e:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801d82:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d89:	00 
  801d8a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d90:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d96:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d9b:	ba 00 00 00 00       	mov    $0x0,%edx
  801da0:	be 00 00 00 00       	mov    $0x0,%esi
  801da5:	bf 01 00 00 00       	mov    $0x1,%edi
  801daa:	48 b8 a2 1c 80 00 00 	movabs $0x801ca2,%rax
  801db1:	00 00 00 
  801db4:	ff d0                	callq  *%rax
}
  801db6:	c9                   	leaveq 
  801db7:	c3                   	retq   

0000000000801db8 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801db8:	55                   	push   %rbp
  801db9:	48 89 e5             	mov    %rsp,%rbp
  801dbc:	48 83 ec 10          	sub    $0x10,%rsp
  801dc0:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801dc3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dc6:	48 98                	cltq   
  801dc8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dcf:	00 
  801dd0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dd6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ddc:	b9 00 00 00 00       	mov    $0x0,%ecx
  801de1:	48 89 c2             	mov    %rax,%rdx
  801de4:	be 01 00 00 00       	mov    $0x1,%esi
  801de9:	bf 03 00 00 00       	mov    $0x3,%edi
  801dee:	48 b8 a2 1c 80 00 00 	movabs $0x801ca2,%rax
  801df5:	00 00 00 
  801df8:	ff d0                	callq  *%rax
}
  801dfa:	c9                   	leaveq 
  801dfb:	c3                   	retq   

0000000000801dfc <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801dfc:	55                   	push   %rbp
  801dfd:	48 89 e5             	mov    %rsp,%rbp
  801e00:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801e04:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e0b:	00 
  801e0c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e12:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e18:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e1d:	ba 00 00 00 00       	mov    $0x0,%edx
  801e22:	be 00 00 00 00       	mov    $0x0,%esi
  801e27:	bf 02 00 00 00       	mov    $0x2,%edi
  801e2c:	48 b8 a2 1c 80 00 00 	movabs $0x801ca2,%rax
  801e33:	00 00 00 
  801e36:	ff d0                	callq  *%rax
}
  801e38:	c9                   	leaveq 
  801e39:	c3                   	retq   

0000000000801e3a <sys_yield>:

void
sys_yield(void)
{
  801e3a:	55                   	push   %rbp
  801e3b:	48 89 e5             	mov    %rsp,%rbp
  801e3e:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801e42:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e49:	00 
  801e4a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e50:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e56:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e5b:	ba 00 00 00 00       	mov    $0x0,%edx
  801e60:	be 00 00 00 00       	mov    $0x0,%esi
  801e65:	bf 0b 00 00 00       	mov    $0xb,%edi
  801e6a:	48 b8 a2 1c 80 00 00 	movabs $0x801ca2,%rax
  801e71:	00 00 00 
  801e74:	ff d0                	callq  *%rax
}
  801e76:	c9                   	leaveq 
  801e77:	c3                   	retq   

0000000000801e78 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801e78:	55                   	push   %rbp
  801e79:	48 89 e5             	mov    %rsp,%rbp
  801e7c:	48 83 ec 20          	sub    $0x20,%rsp
  801e80:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e83:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e87:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801e8a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e8d:	48 63 c8             	movslq %eax,%rcx
  801e90:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e94:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e97:	48 98                	cltq   
  801e99:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ea0:	00 
  801ea1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ea7:	49 89 c8             	mov    %rcx,%r8
  801eaa:	48 89 d1             	mov    %rdx,%rcx
  801ead:	48 89 c2             	mov    %rax,%rdx
  801eb0:	be 01 00 00 00       	mov    $0x1,%esi
  801eb5:	bf 04 00 00 00       	mov    $0x4,%edi
  801eba:	48 b8 a2 1c 80 00 00 	movabs $0x801ca2,%rax
  801ec1:	00 00 00 
  801ec4:	ff d0                	callq  *%rax
}
  801ec6:	c9                   	leaveq 
  801ec7:	c3                   	retq   

0000000000801ec8 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801ec8:	55                   	push   %rbp
  801ec9:	48 89 e5             	mov    %rsp,%rbp
  801ecc:	48 83 ec 30          	sub    $0x30,%rsp
  801ed0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ed3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ed7:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801eda:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801ede:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801ee2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801ee5:	48 63 c8             	movslq %eax,%rcx
  801ee8:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801eec:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801eef:	48 63 f0             	movslq %eax,%rsi
  801ef2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ef6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ef9:	48 98                	cltq   
  801efb:	48 89 0c 24          	mov    %rcx,(%rsp)
  801eff:	49 89 f9             	mov    %rdi,%r9
  801f02:	49 89 f0             	mov    %rsi,%r8
  801f05:	48 89 d1             	mov    %rdx,%rcx
  801f08:	48 89 c2             	mov    %rax,%rdx
  801f0b:	be 01 00 00 00       	mov    $0x1,%esi
  801f10:	bf 05 00 00 00       	mov    $0x5,%edi
  801f15:	48 b8 a2 1c 80 00 00 	movabs $0x801ca2,%rax
  801f1c:	00 00 00 
  801f1f:	ff d0                	callq  *%rax
}
  801f21:	c9                   	leaveq 
  801f22:	c3                   	retq   

0000000000801f23 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801f23:	55                   	push   %rbp
  801f24:	48 89 e5             	mov    %rsp,%rbp
  801f27:	48 83 ec 20          	sub    $0x20,%rsp
  801f2b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f2e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801f32:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f39:	48 98                	cltq   
  801f3b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f42:	00 
  801f43:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f49:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f4f:	48 89 d1             	mov    %rdx,%rcx
  801f52:	48 89 c2             	mov    %rax,%rdx
  801f55:	be 01 00 00 00       	mov    $0x1,%esi
  801f5a:	bf 06 00 00 00       	mov    $0x6,%edi
  801f5f:	48 b8 a2 1c 80 00 00 	movabs $0x801ca2,%rax
  801f66:	00 00 00 
  801f69:	ff d0                	callq  *%rax
}
  801f6b:	c9                   	leaveq 
  801f6c:	c3                   	retq   

0000000000801f6d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801f6d:	55                   	push   %rbp
  801f6e:	48 89 e5             	mov    %rsp,%rbp
  801f71:	48 83 ec 10          	sub    $0x10,%rsp
  801f75:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f78:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801f7b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f7e:	48 63 d0             	movslq %eax,%rdx
  801f81:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f84:	48 98                	cltq   
  801f86:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f8d:	00 
  801f8e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f94:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f9a:	48 89 d1             	mov    %rdx,%rcx
  801f9d:	48 89 c2             	mov    %rax,%rdx
  801fa0:	be 01 00 00 00       	mov    $0x1,%esi
  801fa5:	bf 08 00 00 00       	mov    $0x8,%edi
  801faa:	48 b8 a2 1c 80 00 00 	movabs $0x801ca2,%rax
  801fb1:	00 00 00 
  801fb4:	ff d0                	callq  *%rax
}
  801fb6:	c9                   	leaveq 
  801fb7:	c3                   	retq   

0000000000801fb8 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801fb8:	55                   	push   %rbp
  801fb9:	48 89 e5             	mov    %rsp,%rbp
  801fbc:	48 83 ec 20          	sub    $0x20,%rsp
  801fc0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801fc3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801fc7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fcb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fce:	48 98                	cltq   
  801fd0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fd7:	00 
  801fd8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fde:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fe4:	48 89 d1             	mov    %rdx,%rcx
  801fe7:	48 89 c2             	mov    %rax,%rdx
  801fea:	be 01 00 00 00       	mov    $0x1,%esi
  801fef:	bf 09 00 00 00       	mov    $0x9,%edi
  801ff4:	48 b8 a2 1c 80 00 00 	movabs $0x801ca2,%rax
  801ffb:	00 00 00 
  801ffe:	ff d0                	callq  *%rax
}
  802000:	c9                   	leaveq 
  802001:	c3                   	retq   

0000000000802002 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802002:	55                   	push   %rbp
  802003:	48 89 e5             	mov    %rsp,%rbp
  802006:	48 83 ec 20          	sub    $0x20,%rsp
  80200a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80200d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  802011:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802015:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802018:	48 98                	cltq   
  80201a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802021:	00 
  802022:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802028:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80202e:	48 89 d1             	mov    %rdx,%rcx
  802031:	48 89 c2             	mov    %rax,%rdx
  802034:	be 01 00 00 00       	mov    $0x1,%esi
  802039:	bf 0a 00 00 00       	mov    $0xa,%edi
  80203e:	48 b8 a2 1c 80 00 00 	movabs $0x801ca2,%rax
  802045:	00 00 00 
  802048:	ff d0                	callq  *%rax
}
  80204a:	c9                   	leaveq 
  80204b:	c3                   	retq   

000000000080204c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  80204c:	55                   	push   %rbp
  80204d:	48 89 e5             	mov    %rsp,%rbp
  802050:	48 83 ec 20          	sub    $0x20,%rsp
  802054:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802057:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80205b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80205f:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  802062:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802065:	48 63 f0             	movslq %eax,%rsi
  802068:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80206c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80206f:	48 98                	cltq   
  802071:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802075:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80207c:	00 
  80207d:	49 89 f1             	mov    %rsi,%r9
  802080:	49 89 c8             	mov    %rcx,%r8
  802083:	48 89 d1             	mov    %rdx,%rcx
  802086:	48 89 c2             	mov    %rax,%rdx
  802089:	be 00 00 00 00       	mov    $0x0,%esi
  80208e:	bf 0c 00 00 00       	mov    $0xc,%edi
  802093:	48 b8 a2 1c 80 00 00 	movabs $0x801ca2,%rax
  80209a:	00 00 00 
  80209d:	ff d0                	callq  *%rax
}
  80209f:	c9                   	leaveq 
  8020a0:	c3                   	retq   

00000000008020a1 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8020a1:	55                   	push   %rbp
  8020a2:	48 89 e5             	mov    %rsp,%rbp
  8020a5:	48 83 ec 10          	sub    $0x10,%rsp
  8020a9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8020ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020b1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8020b8:	00 
  8020b9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020bf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020c5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020ca:	48 89 c2             	mov    %rax,%rdx
  8020cd:	be 01 00 00 00       	mov    $0x1,%esi
  8020d2:	bf 0d 00 00 00       	mov    $0xd,%edi
  8020d7:	48 b8 a2 1c 80 00 00 	movabs $0x801ca2,%rax
  8020de:	00 00 00 
  8020e1:	ff d0                	callq  *%rax
}
  8020e3:	c9                   	leaveq 
  8020e4:	c3                   	retq   

00000000008020e5 <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  8020e5:	55                   	push   %rbp
  8020e6:	48 89 e5             	mov    %rsp,%rbp
  8020e9:	48 83 ec 20          	sub    $0x20,%rsp
  8020ed:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8020f1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, (uint64_t)buf, len, 0, 0, 0, 0);
  8020f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020f9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020fd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802104:	00 
  802105:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80210b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802111:	b9 00 00 00 00       	mov    $0x0,%ecx
  802116:	89 c6                	mov    %eax,%esi
  802118:	bf 0f 00 00 00       	mov    $0xf,%edi
  80211d:	48 b8 a2 1c 80 00 00 	movabs $0x801ca2,%rax
  802124:	00 00 00 
  802127:	ff d0                	callq  *%rax
}
  802129:	c9                   	leaveq 
  80212a:	c3                   	retq   

000000000080212b <sys_net_rx>:

int
sys_net_rx(void *buf, size_t len)
{
  80212b:	55                   	push   %rbp
  80212c:	48 89 e5             	mov    %rsp,%rbp
  80212f:	48 83 ec 20          	sub    $0x20,%rsp
  802133:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802137:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_rx, (uint64_t)buf, len, 0, 0, 0, 0);
  80213b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80213f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802143:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80214a:	00 
  80214b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802151:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802157:	b9 00 00 00 00       	mov    $0x0,%ecx
  80215c:	89 c6                	mov    %eax,%esi
  80215e:	bf 10 00 00 00       	mov    $0x10,%edi
  802163:	48 b8 a2 1c 80 00 00 	movabs $0x801ca2,%rax
  80216a:	00 00 00 
  80216d:	ff d0                	callq  *%rax
}
  80216f:	c9                   	leaveq 
  802170:	c3                   	retq   

0000000000802171 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  802171:	55                   	push   %rbp
  802172:	48 89 e5             	mov    %rsp,%rbp
  802175:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  802179:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802180:	00 
  802181:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802187:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80218d:	b9 00 00 00 00       	mov    $0x0,%ecx
  802192:	ba 00 00 00 00       	mov    $0x0,%edx
  802197:	be 00 00 00 00       	mov    $0x0,%esi
  80219c:	bf 0e 00 00 00       	mov    $0xe,%edi
  8021a1:	48 b8 a2 1c 80 00 00 	movabs $0x801ca2,%rax
  8021a8:	00 00 00 
  8021ab:	ff d0                	callq  *%rax
}
  8021ad:	c9                   	leaveq 
  8021ae:	c3                   	retq   

00000000008021af <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8021af:	55                   	push   %rbp
  8021b0:	48 89 e5             	mov    %rsp,%rbp
  8021b3:	48 83 ec 08          	sub    $0x8,%rsp
  8021b7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8021bb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8021bf:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8021c6:	ff ff ff 
  8021c9:	48 01 d0             	add    %rdx,%rax
  8021cc:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8021d0:	c9                   	leaveq 
  8021d1:	c3                   	retq   

00000000008021d2 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8021d2:	55                   	push   %rbp
  8021d3:	48 89 e5             	mov    %rsp,%rbp
  8021d6:	48 83 ec 08          	sub    $0x8,%rsp
  8021da:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8021de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021e2:	48 89 c7             	mov    %rax,%rdi
  8021e5:	48 b8 af 21 80 00 00 	movabs $0x8021af,%rax
  8021ec:	00 00 00 
  8021ef:	ff d0                	callq  *%rax
  8021f1:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8021f7:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8021fb:	c9                   	leaveq 
  8021fc:	c3                   	retq   

00000000008021fd <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8021fd:	55                   	push   %rbp
  8021fe:	48 89 e5             	mov    %rsp,%rbp
  802201:	48 83 ec 18          	sub    $0x18,%rsp
  802205:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802209:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802210:	eb 6b                	jmp    80227d <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802212:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802215:	48 98                	cltq   
  802217:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80221d:	48 c1 e0 0c          	shl    $0xc,%rax
  802221:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802225:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802229:	48 c1 e8 15          	shr    $0x15,%rax
  80222d:	48 89 c2             	mov    %rax,%rdx
  802230:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802237:	01 00 00 
  80223a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80223e:	83 e0 01             	and    $0x1,%eax
  802241:	48 85 c0             	test   %rax,%rax
  802244:	74 21                	je     802267 <fd_alloc+0x6a>
  802246:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80224a:	48 c1 e8 0c          	shr    $0xc,%rax
  80224e:	48 89 c2             	mov    %rax,%rdx
  802251:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802258:	01 00 00 
  80225b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80225f:	83 e0 01             	and    $0x1,%eax
  802262:	48 85 c0             	test   %rax,%rax
  802265:	75 12                	jne    802279 <fd_alloc+0x7c>
			*fd_store = fd;
  802267:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80226b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80226f:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802272:	b8 00 00 00 00       	mov    $0x0,%eax
  802277:	eb 1a                	jmp    802293 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802279:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80227d:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802281:	7e 8f                	jle    802212 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802283:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802287:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80228e:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802293:	c9                   	leaveq 
  802294:	c3                   	retq   

0000000000802295 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802295:	55                   	push   %rbp
  802296:	48 89 e5             	mov    %rsp,%rbp
  802299:	48 83 ec 20          	sub    $0x20,%rsp
  80229d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8022a0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8022a4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8022a8:	78 06                	js     8022b0 <fd_lookup+0x1b>
  8022aa:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8022ae:	7e 07                	jle    8022b7 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8022b0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022b5:	eb 6c                	jmp    802323 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8022b7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022ba:	48 98                	cltq   
  8022bc:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8022c2:	48 c1 e0 0c          	shl    $0xc,%rax
  8022c6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8022ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022ce:	48 c1 e8 15          	shr    $0x15,%rax
  8022d2:	48 89 c2             	mov    %rax,%rdx
  8022d5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8022dc:	01 00 00 
  8022df:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022e3:	83 e0 01             	and    $0x1,%eax
  8022e6:	48 85 c0             	test   %rax,%rax
  8022e9:	74 21                	je     80230c <fd_lookup+0x77>
  8022eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022ef:	48 c1 e8 0c          	shr    $0xc,%rax
  8022f3:	48 89 c2             	mov    %rax,%rdx
  8022f6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022fd:	01 00 00 
  802300:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802304:	83 e0 01             	and    $0x1,%eax
  802307:	48 85 c0             	test   %rax,%rax
  80230a:	75 07                	jne    802313 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80230c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802311:	eb 10                	jmp    802323 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802313:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802317:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80231b:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80231e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802323:	c9                   	leaveq 
  802324:	c3                   	retq   

0000000000802325 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802325:	55                   	push   %rbp
  802326:	48 89 e5             	mov    %rsp,%rbp
  802329:	48 83 ec 30          	sub    $0x30,%rsp
  80232d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802331:	89 f0                	mov    %esi,%eax
  802333:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802336:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80233a:	48 89 c7             	mov    %rax,%rdi
  80233d:	48 b8 af 21 80 00 00 	movabs $0x8021af,%rax
  802344:	00 00 00 
  802347:	ff d0                	callq  *%rax
  802349:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80234d:	48 89 d6             	mov    %rdx,%rsi
  802350:	89 c7                	mov    %eax,%edi
  802352:	48 b8 95 22 80 00 00 	movabs $0x802295,%rax
  802359:	00 00 00 
  80235c:	ff d0                	callq  *%rax
  80235e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802361:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802365:	78 0a                	js     802371 <fd_close+0x4c>
	    || fd != fd2)
  802367:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80236b:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80236f:	74 12                	je     802383 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802371:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802375:	74 05                	je     80237c <fd_close+0x57>
  802377:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80237a:	eb 05                	jmp    802381 <fd_close+0x5c>
  80237c:	b8 00 00 00 00       	mov    $0x0,%eax
  802381:	eb 69                	jmp    8023ec <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802383:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802387:	8b 00                	mov    (%rax),%eax
  802389:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80238d:	48 89 d6             	mov    %rdx,%rsi
  802390:	89 c7                	mov    %eax,%edi
  802392:	48 b8 ee 23 80 00 00 	movabs $0x8023ee,%rax
  802399:	00 00 00 
  80239c:	ff d0                	callq  *%rax
  80239e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023a5:	78 2a                	js     8023d1 <fd_close+0xac>
		if (dev->dev_close)
  8023a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023ab:	48 8b 40 20          	mov    0x20(%rax),%rax
  8023af:	48 85 c0             	test   %rax,%rax
  8023b2:	74 16                	je     8023ca <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8023b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023b8:	48 8b 40 20          	mov    0x20(%rax),%rax
  8023bc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8023c0:	48 89 d7             	mov    %rdx,%rdi
  8023c3:	ff d0                	callq  *%rax
  8023c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023c8:	eb 07                	jmp    8023d1 <fd_close+0xac>
		else
			r = 0;
  8023ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8023d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023d5:	48 89 c6             	mov    %rax,%rsi
  8023d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8023dd:	48 b8 23 1f 80 00 00 	movabs $0x801f23,%rax
  8023e4:	00 00 00 
  8023e7:	ff d0                	callq  *%rax
	return r;
  8023e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023ec:	c9                   	leaveq 
  8023ed:	c3                   	retq   

00000000008023ee <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8023ee:	55                   	push   %rbp
  8023ef:	48 89 e5             	mov    %rsp,%rbp
  8023f2:	48 83 ec 20          	sub    $0x20,%rsp
  8023f6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023f9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8023fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802404:	eb 41                	jmp    802447 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802406:	48 b8 c0 87 80 00 00 	movabs $0x8087c0,%rax
  80240d:	00 00 00 
  802410:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802413:	48 63 d2             	movslq %edx,%rdx
  802416:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80241a:	8b 00                	mov    (%rax),%eax
  80241c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80241f:	75 22                	jne    802443 <dev_lookup+0x55>
			*dev = devtab[i];
  802421:	48 b8 c0 87 80 00 00 	movabs $0x8087c0,%rax
  802428:	00 00 00 
  80242b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80242e:	48 63 d2             	movslq %edx,%rdx
  802431:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802435:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802439:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80243c:	b8 00 00 00 00       	mov    $0x0,%eax
  802441:	eb 60                	jmp    8024a3 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802443:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802447:	48 b8 c0 87 80 00 00 	movabs $0x8087c0,%rax
  80244e:	00 00 00 
  802451:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802454:	48 63 d2             	movslq %edx,%rdx
  802457:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80245b:	48 85 c0             	test   %rax,%rax
  80245e:	75 a6                	jne    802406 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802460:	48 b8 90 a7 80 00 00 	movabs $0x80a790,%rax
  802467:	00 00 00 
  80246a:	48 8b 00             	mov    (%rax),%rax
  80246d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802473:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802476:	89 c6                	mov    %eax,%esi
  802478:	48 bf 98 54 80 00 00 	movabs $0x805498,%rdi
  80247f:	00 00 00 
  802482:	b8 00 00 00 00       	mov    $0x0,%eax
  802487:	48 b9 94 09 80 00 00 	movabs $0x800994,%rcx
  80248e:	00 00 00 
  802491:	ff d1                	callq  *%rcx
	*dev = 0;
  802493:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802497:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80249e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8024a3:	c9                   	leaveq 
  8024a4:	c3                   	retq   

00000000008024a5 <close>:

int
close(int fdnum)
{
  8024a5:	55                   	push   %rbp
  8024a6:	48 89 e5             	mov    %rsp,%rbp
  8024a9:	48 83 ec 20          	sub    $0x20,%rsp
  8024ad:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024b0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024b4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024b7:	48 89 d6             	mov    %rdx,%rsi
  8024ba:	89 c7                	mov    %eax,%edi
  8024bc:	48 b8 95 22 80 00 00 	movabs $0x802295,%rax
  8024c3:	00 00 00 
  8024c6:	ff d0                	callq  *%rax
  8024c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024cf:	79 05                	jns    8024d6 <close+0x31>
		return r;
  8024d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024d4:	eb 18                	jmp    8024ee <close+0x49>
	else
		return fd_close(fd, 1);
  8024d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024da:	be 01 00 00 00       	mov    $0x1,%esi
  8024df:	48 89 c7             	mov    %rax,%rdi
  8024e2:	48 b8 25 23 80 00 00 	movabs $0x802325,%rax
  8024e9:	00 00 00 
  8024ec:	ff d0                	callq  *%rax
}
  8024ee:	c9                   	leaveq 
  8024ef:	c3                   	retq   

00000000008024f0 <close_all>:

void
close_all(void)
{
  8024f0:	55                   	push   %rbp
  8024f1:	48 89 e5             	mov    %rsp,%rbp
  8024f4:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8024f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8024ff:	eb 15                	jmp    802516 <close_all+0x26>
		close(i);
  802501:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802504:	89 c7                	mov    %eax,%edi
  802506:	48 b8 a5 24 80 00 00 	movabs $0x8024a5,%rax
  80250d:	00 00 00 
  802510:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802512:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802516:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80251a:	7e e5                	jle    802501 <close_all+0x11>
		close(i);
}
  80251c:	c9                   	leaveq 
  80251d:	c3                   	retq   

000000000080251e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80251e:	55                   	push   %rbp
  80251f:	48 89 e5             	mov    %rsp,%rbp
  802522:	48 83 ec 40          	sub    $0x40,%rsp
  802526:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802529:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80252c:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802530:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802533:	48 89 d6             	mov    %rdx,%rsi
  802536:	89 c7                	mov    %eax,%edi
  802538:	48 b8 95 22 80 00 00 	movabs $0x802295,%rax
  80253f:	00 00 00 
  802542:	ff d0                	callq  *%rax
  802544:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802547:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80254b:	79 08                	jns    802555 <dup+0x37>
		return r;
  80254d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802550:	e9 70 01 00 00       	jmpq   8026c5 <dup+0x1a7>
	close(newfdnum);
  802555:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802558:	89 c7                	mov    %eax,%edi
  80255a:	48 b8 a5 24 80 00 00 	movabs $0x8024a5,%rax
  802561:	00 00 00 
  802564:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802566:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802569:	48 98                	cltq   
  80256b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802571:	48 c1 e0 0c          	shl    $0xc,%rax
  802575:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802579:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80257d:	48 89 c7             	mov    %rax,%rdi
  802580:	48 b8 d2 21 80 00 00 	movabs $0x8021d2,%rax
  802587:	00 00 00 
  80258a:	ff d0                	callq  *%rax
  80258c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802590:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802594:	48 89 c7             	mov    %rax,%rdi
  802597:	48 b8 d2 21 80 00 00 	movabs $0x8021d2,%rax
  80259e:	00 00 00 
  8025a1:	ff d0                	callq  *%rax
  8025a3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8025a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025ab:	48 c1 e8 15          	shr    $0x15,%rax
  8025af:	48 89 c2             	mov    %rax,%rdx
  8025b2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8025b9:	01 00 00 
  8025bc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025c0:	83 e0 01             	and    $0x1,%eax
  8025c3:	48 85 c0             	test   %rax,%rax
  8025c6:	74 73                	je     80263b <dup+0x11d>
  8025c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025cc:	48 c1 e8 0c          	shr    $0xc,%rax
  8025d0:	48 89 c2             	mov    %rax,%rdx
  8025d3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025da:	01 00 00 
  8025dd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025e1:	83 e0 01             	and    $0x1,%eax
  8025e4:	48 85 c0             	test   %rax,%rax
  8025e7:	74 52                	je     80263b <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8025e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025ed:	48 c1 e8 0c          	shr    $0xc,%rax
  8025f1:	48 89 c2             	mov    %rax,%rdx
  8025f4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025fb:	01 00 00 
  8025fe:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802602:	25 07 0e 00 00       	and    $0xe07,%eax
  802607:	89 c1                	mov    %eax,%ecx
  802609:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80260d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802611:	41 89 c8             	mov    %ecx,%r8d
  802614:	48 89 d1             	mov    %rdx,%rcx
  802617:	ba 00 00 00 00       	mov    $0x0,%edx
  80261c:	48 89 c6             	mov    %rax,%rsi
  80261f:	bf 00 00 00 00       	mov    $0x0,%edi
  802624:	48 b8 c8 1e 80 00 00 	movabs $0x801ec8,%rax
  80262b:	00 00 00 
  80262e:	ff d0                	callq  *%rax
  802630:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802633:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802637:	79 02                	jns    80263b <dup+0x11d>
			goto err;
  802639:	eb 57                	jmp    802692 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80263b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80263f:	48 c1 e8 0c          	shr    $0xc,%rax
  802643:	48 89 c2             	mov    %rax,%rdx
  802646:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80264d:	01 00 00 
  802650:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802654:	25 07 0e 00 00       	and    $0xe07,%eax
  802659:	89 c1                	mov    %eax,%ecx
  80265b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80265f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802663:	41 89 c8             	mov    %ecx,%r8d
  802666:	48 89 d1             	mov    %rdx,%rcx
  802669:	ba 00 00 00 00       	mov    $0x0,%edx
  80266e:	48 89 c6             	mov    %rax,%rsi
  802671:	bf 00 00 00 00       	mov    $0x0,%edi
  802676:	48 b8 c8 1e 80 00 00 	movabs $0x801ec8,%rax
  80267d:	00 00 00 
  802680:	ff d0                	callq  *%rax
  802682:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802685:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802689:	79 02                	jns    80268d <dup+0x16f>
		goto err;
  80268b:	eb 05                	jmp    802692 <dup+0x174>

	return newfdnum;
  80268d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802690:	eb 33                	jmp    8026c5 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802692:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802696:	48 89 c6             	mov    %rax,%rsi
  802699:	bf 00 00 00 00       	mov    $0x0,%edi
  80269e:	48 b8 23 1f 80 00 00 	movabs $0x801f23,%rax
  8026a5:	00 00 00 
  8026a8:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8026aa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026ae:	48 89 c6             	mov    %rax,%rsi
  8026b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8026b6:	48 b8 23 1f 80 00 00 	movabs $0x801f23,%rax
  8026bd:	00 00 00 
  8026c0:	ff d0                	callq  *%rax
	return r;
  8026c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8026c5:	c9                   	leaveq 
  8026c6:	c3                   	retq   

00000000008026c7 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8026c7:	55                   	push   %rbp
  8026c8:	48 89 e5             	mov    %rsp,%rbp
  8026cb:	48 83 ec 40          	sub    $0x40,%rsp
  8026cf:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8026d2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8026d6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8026da:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026de:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8026e1:	48 89 d6             	mov    %rdx,%rsi
  8026e4:	89 c7                	mov    %eax,%edi
  8026e6:	48 b8 95 22 80 00 00 	movabs $0x802295,%rax
  8026ed:	00 00 00 
  8026f0:	ff d0                	callq  *%rax
  8026f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026f9:	78 24                	js     80271f <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8026fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026ff:	8b 00                	mov    (%rax),%eax
  802701:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802705:	48 89 d6             	mov    %rdx,%rsi
  802708:	89 c7                	mov    %eax,%edi
  80270a:	48 b8 ee 23 80 00 00 	movabs $0x8023ee,%rax
  802711:	00 00 00 
  802714:	ff d0                	callq  *%rax
  802716:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802719:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80271d:	79 05                	jns    802724 <read+0x5d>
		return r;
  80271f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802722:	eb 76                	jmp    80279a <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802724:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802728:	8b 40 08             	mov    0x8(%rax),%eax
  80272b:	83 e0 03             	and    $0x3,%eax
  80272e:	83 f8 01             	cmp    $0x1,%eax
  802731:	75 3a                	jne    80276d <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802733:	48 b8 90 a7 80 00 00 	movabs $0x80a790,%rax
  80273a:	00 00 00 
  80273d:	48 8b 00             	mov    (%rax),%rax
  802740:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802746:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802749:	89 c6                	mov    %eax,%esi
  80274b:	48 bf b7 54 80 00 00 	movabs $0x8054b7,%rdi
  802752:	00 00 00 
  802755:	b8 00 00 00 00       	mov    $0x0,%eax
  80275a:	48 b9 94 09 80 00 00 	movabs $0x800994,%rcx
  802761:	00 00 00 
  802764:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802766:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80276b:	eb 2d                	jmp    80279a <read+0xd3>
	}
	if (!dev->dev_read)
  80276d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802771:	48 8b 40 10          	mov    0x10(%rax),%rax
  802775:	48 85 c0             	test   %rax,%rax
  802778:	75 07                	jne    802781 <read+0xba>
		return -E_NOT_SUPP;
  80277a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80277f:	eb 19                	jmp    80279a <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802781:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802785:	48 8b 40 10          	mov    0x10(%rax),%rax
  802789:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80278d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802791:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802795:	48 89 cf             	mov    %rcx,%rdi
  802798:	ff d0                	callq  *%rax
}
  80279a:	c9                   	leaveq 
  80279b:	c3                   	retq   

000000000080279c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80279c:	55                   	push   %rbp
  80279d:	48 89 e5             	mov    %rsp,%rbp
  8027a0:	48 83 ec 30          	sub    $0x30,%rsp
  8027a4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8027a7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8027ab:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8027af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8027b6:	eb 49                	jmp    802801 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8027b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027bb:	48 98                	cltq   
  8027bd:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027c1:	48 29 c2             	sub    %rax,%rdx
  8027c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027c7:	48 63 c8             	movslq %eax,%rcx
  8027ca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027ce:	48 01 c1             	add    %rax,%rcx
  8027d1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027d4:	48 89 ce             	mov    %rcx,%rsi
  8027d7:	89 c7                	mov    %eax,%edi
  8027d9:	48 b8 c7 26 80 00 00 	movabs $0x8026c7,%rax
  8027e0:	00 00 00 
  8027e3:	ff d0                	callq  *%rax
  8027e5:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8027e8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8027ec:	79 05                	jns    8027f3 <readn+0x57>
			return m;
  8027ee:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8027f1:	eb 1c                	jmp    80280f <readn+0x73>
		if (m == 0)
  8027f3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8027f7:	75 02                	jne    8027fb <readn+0x5f>
			break;
  8027f9:	eb 11                	jmp    80280c <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8027fb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8027fe:	01 45 fc             	add    %eax,-0x4(%rbp)
  802801:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802804:	48 98                	cltq   
  802806:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80280a:	72 ac                	jb     8027b8 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80280c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80280f:	c9                   	leaveq 
  802810:	c3                   	retq   

0000000000802811 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802811:	55                   	push   %rbp
  802812:	48 89 e5             	mov    %rsp,%rbp
  802815:	48 83 ec 40          	sub    $0x40,%rsp
  802819:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80281c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802820:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802824:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802828:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80282b:	48 89 d6             	mov    %rdx,%rsi
  80282e:	89 c7                	mov    %eax,%edi
  802830:	48 b8 95 22 80 00 00 	movabs $0x802295,%rax
  802837:	00 00 00 
  80283a:	ff d0                	callq  *%rax
  80283c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80283f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802843:	78 24                	js     802869 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802845:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802849:	8b 00                	mov    (%rax),%eax
  80284b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80284f:	48 89 d6             	mov    %rdx,%rsi
  802852:	89 c7                	mov    %eax,%edi
  802854:	48 b8 ee 23 80 00 00 	movabs $0x8023ee,%rax
  80285b:	00 00 00 
  80285e:	ff d0                	callq  *%rax
  802860:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802863:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802867:	79 05                	jns    80286e <write+0x5d>
		return r;
  802869:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80286c:	eb 75                	jmp    8028e3 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80286e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802872:	8b 40 08             	mov    0x8(%rax),%eax
  802875:	83 e0 03             	and    $0x3,%eax
  802878:	85 c0                	test   %eax,%eax
  80287a:	75 3a                	jne    8028b6 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80287c:	48 b8 90 a7 80 00 00 	movabs $0x80a790,%rax
  802883:	00 00 00 
  802886:	48 8b 00             	mov    (%rax),%rax
  802889:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80288f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802892:	89 c6                	mov    %eax,%esi
  802894:	48 bf d3 54 80 00 00 	movabs $0x8054d3,%rdi
  80289b:	00 00 00 
  80289e:	b8 00 00 00 00       	mov    $0x0,%eax
  8028a3:	48 b9 94 09 80 00 00 	movabs $0x800994,%rcx
  8028aa:	00 00 00 
  8028ad:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8028af:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028b4:	eb 2d                	jmp    8028e3 <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  8028b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028ba:	48 8b 40 18          	mov    0x18(%rax),%rax
  8028be:	48 85 c0             	test   %rax,%rax
  8028c1:	75 07                	jne    8028ca <write+0xb9>
		return -E_NOT_SUPP;
  8028c3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8028c8:	eb 19                	jmp    8028e3 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8028ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028ce:	48 8b 40 18          	mov    0x18(%rax),%rax
  8028d2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8028d6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8028da:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8028de:	48 89 cf             	mov    %rcx,%rdi
  8028e1:	ff d0                	callq  *%rax
}
  8028e3:	c9                   	leaveq 
  8028e4:	c3                   	retq   

00000000008028e5 <seek>:

int
seek(int fdnum, off_t offset)
{
  8028e5:	55                   	push   %rbp
  8028e6:	48 89 e5             	mov    %rsp,%rbp
  8028e9:	48 83 ec 18          	sub    $0x18,%rsp
  8028ed:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8028f0:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028f3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028f7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028fa:	48 89 d6             	mov    %rdx,%rsi
  8028fd:	89 c7                	mov    %eax,%edi
  8028ff:	48 b8 95 22 80 00 00 	movabs $0x802295,%rax
  802906:	00 00 00 
  802909:	ff d0                	callq  *%rax
  80290b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80290e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802912:	79 05                	jns    802919 <seek+0x34>
		return r;
  802914:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802917:	eb 0f                	jmp    802928 <seek+0x43>
	fd->fd_offset = offset;
  802919:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80291d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802920:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802923:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802928:	c9                   	leaveq 
  802929:	c3                   	retq   

000000000080292a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80292a:	55                   	push   %rbp
  80292b:	48 89 e5             	mov    %rsp,%rbp
  80292e:	48 83 ec 30          	sub    $0x30,%rsp
  802932:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802935:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802938:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80293c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80293f:	48 89 d6             	mov    %rdx,%rsi
  802942:	89 c7                	mov    %eax,%edi
  802944:	48 b8 95 22 80 00 00 	movabs $0x802295,%rax
  80294b:	00 00 00 
  80294e:	ff d0                	callq  *%rax
  802950:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802953:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802957:	78 24                	js     80297d <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802959:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80295d:	8b 00                	mov    (%rax),%eax
  80295f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802963:	48 89 d6             	mov    %rdx,%rsi
  802966:	89 c7                	mov    %eax,%edi
  802968:	48 b8 ee 23 80 00 00 	movabs $0x8023ee,%rax
  80296f:	00 00 00 
  802972:	ff d0                	callq  *%rax
  802974:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802977:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80297b:	79 05                	jns    802982 <ftruncate+0x58>
		return r;
  80297d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802980:	eb 72                	jmp    8029f4 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802982:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802986:	8b 40 08             	mov    0x8(%rax),%eax
  802989:	83 e0 03             	and    $0x3,%eax
  80298c:	85 c0                	test   %eax,%eax
  80298e:	75 3a                	jne    8029ca <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802990:	48 b8 90 a7 80 00 00 	movabs $0x80a790,%rax
  802997:	00 00 00 
  80299a:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80299d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029a3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8029a6:	89 c6                	mov    %eax,%esi
  8029a8:	48 bf f0 54 80 00 00 	movabs $0x8054f0,%rdi
  8029af:	00 00 00 
  8029b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b7:	48 b9 94 09 80 00 00 	movabs $0x800994,%rcx
  8029be:	00 00 00 
  8029c1:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8029c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029c8:	eb 2a                	jmp    8029f4 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8029ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029ce:	48 8b 40 30          	mov    0x30(%rax),%rax
  8029d2:	48 85 c0             	test   %rax,%rax
  8029d5:	75 07                	jne    8029de <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8029d7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8029dc:	eb 16                	jmp    8029f4 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8029de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029e2:	48 8b 40 30          	mov    0x30(%rax),%rax
  8029e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8029ea:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8029ed:	89 ce                	mov    %ecx,%esi
  8029ef:	48 89 d7             	mov    %rdx,%rdi
  8029f2:	ff d0                	callq  *%rax
}
  8029f4:	c9                   	leaveq 
  8029f5:	c3                   	retq   

00000000008029f6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8029f6:	55                   	push   %rbp
  8029f7:	48 89 e5             	mov    %rsp,%rbp
  8029fa:	48 83 ec 30          	sub    $0x30,%rsp
  8029fe:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a01:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a05:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a09:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a0c:	48 89 d6             	mov    %rdx,%rsi
  802a0f:	89 c7                	mov    %eax,%edi
  802a11:	48 b8 95 22 80 00 00 	movabs $0x802295,%rax
  802a18:	00 00 00 
  802a1b:	ff d0                	callq  *%rax
  802a1d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a20:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a24:	78 24                	js     802a4a <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a26:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a2a:	8b 00                	mov    (%rax),%eax
  802a2c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a30:	48 89 d6             	mov    %rdx,%rsi
  802a33:	89 c7                	mov    %eax,%edi
  802a35:	48 b8 ee 23 80 00 00 	movabs $0x8023ee,%rax
  802a3c:	00 00 00 
  802a3f:	ff d0                	callq  *%rax
  802a41:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a44:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a48:	79 05                	jns    802a4f <fstat+0x59>
		return r;
  802a4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a4d:	eb 5e                	jmp    802aad <fstat+0xb7>
	if (!dev->dev_stat)
  802a4f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a53:	48 8b 40 28          	mov    0x28(%rax),%rax
  802a57:	48 85 c0             	test   %rax,%rax
  802a5a:	75 07                	jne    802a63 <fstat+0x6d>
		return -E_NOT_SUPP;
  802a5c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a61:	eb 4a                	jmp    802aad <fstat+0xb7>
	stat->st_name[0] = 0;
  802a63:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a67:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802a6a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a6e:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802a75:	00 00 00 
	stat->st_isdir = 0;
  802a78:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a7c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802a83:	00 00 00 
	stat->st_dev = dev;
  802a86:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a8a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a8e:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802a95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a99:	48 8b 40 28          	mov    0x28(%rax),%rax
  802a9d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802aa1:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802aa5:	48 89 ce             	mov    %rcx,%rsi
  802aa8:	48 89 d7             	mov    %rdx,%rdi
  802aab:	ff d0                	callq  *%rax
}
  802aad:	c9                   	leaveq 
  802aae:	c3                   	retq   

0000000000802aaf <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802aaf:	55                   	push   %rbp
  802ab0:	48 89 e5             	mov    %rsp,%rbp
  802ab3:	48 83 ec 20          	sub    $0x20,%rsp
  802ab7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802abb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802abf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ac3:	be 00 00 00 00       	mov    $0x0,%esi
  802ac8:	48 89 c7             	mov    %rax,%rdi
  802acb:	48 b8 9d 2b 80 00 00 	movabs $0x802b9d,%rax
  802ad2:	00 00 00 
  802ad5:	ff d0                	callq  *%rax
  802ad7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ada:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ade:	79 05                	jns    802ae5 <stat+0x36>
		return fd;
  802ae0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ae3:	eb 2f                	jmp    802b14 <stat+0x65>
	r = fstat(fd, stat);
  802ae5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802ae9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aec:	48 89 d6             	mov    %rdx,%rsi
  802aef:	89 c7                	mov    %eax,%edi
  802af1:	48 b8 f6 29 80 00 00 	movabs $0x8029f6,%rax
  802af8:	00 00 00 
  802afb:	ff d0                	callq  *%rax
  802afd:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802b00:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b03:	89 c7                	mov    %eax,%edi
  802b05:	48 b8 a5 24 80 00 00 	movabs $0x8024a5,%rax
  802b0c:	00 00 00 
  802b0f:	ff d0                	callq  *%rax
	return r;
  802b11:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802b14:	c9                   	leaveq 
  802b15:	c3                   	retq   

0000000000802b16 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802b16:	55                   	push   %rbp
  802b17:	48 89 e5             	mov    %rsp,%rbp
  802b1a:	48 83 ec 10          	sub    $0x10,%rsp
  802b1e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802b21:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802b25:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802b2c:	00 00 00 
  802b2f:	8b 00                	mov    (%rax),%eax
  802b31:	85 c0                	test   %eax,%eax
  802b33:	75 1d                	jne    802b52 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802b35:	bf 01 00 00 00       	mov    $0x1,%edi
  802b3a:	48 b8 e1 4c 80 00 00 	movabs $0x804ce1,%rax
  802b41:	00 00 00 
  802b44:	ff d0                	callq  *%rax
  802b46:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  802b4d:	00 00 00 
  802b50:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802b52:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802b59:	00 00 00 
  802b5c:	8b 00                	mov    (%rax),%eax
  802b5e:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802b61:	b9 07 00 00 00       	mov    $0x7,%ecx
  802b66:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  802b6d:	00 00 00 
  802b70:	89 c7                	mov    %eax,%edi
  802b72:	48 b8 7f 4c 80 00 00 	movabs $0x804c7f,%rax
  802b79:	00 00 00 
  802b7c:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802b7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b82:	ba 00 00 00 00       	mov    $0x0,%edx
  802b87:	48 89 c6             	mov    %rax,%rsi
  802b8a:	bf 00 00 00 00       	mov    $0x0,%edi
  802b8f:	48 b8 79 4b 80 00 00 	movabs $0x804b79,%rax
  802b96:	00 00 00 
  802b99:	ff d0                	callq  *%rax
}
  802b9b:	c9                   	leaveq 
  802b9c:	c3                   	retq   

0000000000802b9d <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802b9d:	55                   	push   %rbp
  802b9e:	48 89 e5             	mov    %rsp,%rbp
  802ba1:	48 83 ec 30          	sub    $0x30,%rsp
  802ba5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802ba9:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802bac:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802bb3:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802bba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802bc1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802bc6:	75 08                	jne    802bd0 <open+0x33>
	{
		return r;
  802bc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bcb:	e9 f2 00 00 00       	jmpq   802cc2 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802bd0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bd4:	48 89 c7             	mov    %rax,%rdi
  802bd7:	48 b8 dd 14 80 00 00 	movabs $0x8014dd,%rax
  802bde:	00 00 00 
  802be1:	ff d0                	callq  *%rax
  802be3:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802be6:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802bed:	7e 0a                	jle    802bf9 <open+0x5c>
	{
		return -E_BAD_PATH;
  802bef:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802bf4:	e9 c9 00 00 00       	jmpq   802cc2 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802bf9:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802c00:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802c01:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802c05:	48 89 c7             	mov    %rax,%rdi
  802c08:	48 b8 fd 21 80 00 00 	movabs $0x8021fd,%rax
  802c0f:	00 00 00 
  802c12:	ff d0                	callq  *%rax
  802c14:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c17:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c1b:	78 09                	js     802c26 <open+0x89>
  802c1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c21:	48 85 c0             	test   %rax,%rax
  802c24:	75 08                	jne    802c2e <open+0x91>
		{
			return r;
  802c26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c29:	e9 94 00 00 00       	jmpq   802cc2 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802c2e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c32:	ba 00 04 00 00       	mov    $0x400,%edx
  802c37:	48 89 c6             	mov    %rax,%rsi
  802c3a:	48 bf 00 b0 80 00 00 	movabs $0x80b000,%rdi
  802c41:	00 00 00 
  802c44:	48 b8 db 15 80 00 00 	movabs $0x8015db,%rax
  802c4b:	00 00 00 
  802c4e:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802c50:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802c57:	00 00 00 
  802c5a:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802c5d:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802c63:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c67:	48 89 c6             	mov    %rax,%rsi
  802c6a:	bf 01 00 00 00       	mov    $0x1,%edi
  802c6f:	48 b8 16 2b 80 00 00 	movabs $0x802b16,%rax
  802c76:	00 00 00 
  802c79:	ff d0                	callq  *%rax
  802c7b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c7e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c82:	79 2b                	jns    802caf <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802c84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c88:	be 00 00 00 00       	mov    $0x0,%esi
  802c8d:	48 89 c7             	mov    %rax,%rdi
  802c90:	48 b8 25 23 80 00 00 	movabs $0x802325,%rax
  802c97:	00 00 00 
  802c9a:	ff d0                	callq  *%rax
  802c9c:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802c9f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ca3:	79 05                	jns    802caa <open+0x10d>
			{
				return d;
  802ca5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ca8:	eb 18                	jmp    802cc2 <open+0x125>
			}
			return r;
  802caa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cad:	eb 13                	jmp    802cc2 <open+0x125>
		}	
		return fd2num(fd_store);
  802caf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cb3:	48 89 c7             	mov    %rax,%rdi
  802cb6:	48 b8 af 21 80 00 00 	movabs $0x8021af,%rax
  802cbd:	00 00 00 
  802cc0:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802cc2:	c9                   	leaveq 
  802cc3:	c3                   	retq   

0000000000802cc4 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802cc4:	55                   	push   %rbp
  802cc5:	48 89 e5             	mov    %rsp,%rbp
  802cc8:	48 83 ec 10          	sub    $0x10,%rsp
  802ccc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802cd0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cd4:	8b 50 0c             	mov    0xc(%rax),%edx
  802cd7:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802cde:	00 00 00 
  802ce1:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802ce3:	be 00 00 00 00       	mov    $0x0,%esi
  802ce8:	bf 06 00 00 00       	mov    $0x6,%edi
  802ced:	48 b8 16 2b 80 00 00 	movabs $0x802b16,%rax
  802cf4:	00 00 00 
  802cf7:	ff d0                	callq  *%rax
}
  802cf9:	c9                   	leaveq 
  802cfa:	c3                   	retq   

0000000000802cfb <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802cfb:	55                   	push   %rbp
  802cfc:	48 89 e5             	mov    %rsp,%rbp
  802cff:	48 83 ec 30          	sub    $0x30,%rsp
  802d03:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d07:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d0b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802d0f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802d16:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802d1b:	74 07                	je     802d24 <devfile_read+0x29>
  802d1d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802d22:	75 07                	jne    802d2b <devfile_read+0x30>
		return -E_INVAL;
  802d24:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d29:	eb 77                	jmp    802da2 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802d2b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d2f:	8b 50 0c             	mov    0xc(%rax),%edx
  802d32:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802d39:	00 00 00 
  802d3c:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802d3e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802d45:	00 00 00 
  802d48:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d4c:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802d50:	be 00 00 00 00       	mov    $0x0,%esi
  802d55:	bf 03 00 00 00       	mov    $0x3,%edi
  802d5a:	48 b8 16 2b 80 00 00 	movabs $0x802b16,%rax
  802d61:	00 00 00 
  802d64:	ff d0                	callq  *%rax
  802d66:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d69:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d6d:	7f 05                	jg     802d74 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802d6f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d72:	eb 2e                	jmp    802da2 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802d74:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d77:	48 63 d0             	movslq %eax,%rdx
  802d7a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d7e:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  802d85:	00 00 00 
  802d88:	48 89 c7             	mov    %rax,%rdi
  802d8b:	48 b8 6d 18 80 00 00 	movabs $0x80186d,%rax
  802d92:	00 00 00 
  802d95:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802d97:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d9b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802d9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802da2:	c9                   	leaveq 
  802da3:	c3                   	retq   

0000000000802da4 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802da4:	55                   	push   %rbp
  802da5:	48 89 e5             	mov    %rsp,%rbp
  802da8:	48 83 ec 30          	sub    $0x30,%rsp
  802dac:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802db0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802db4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802db8:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802dbf:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802dc4:	74 07                	je     802dcd <devfile_write+0x29>
  802dc6:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802dcb:	75 08                	jne    802dd5 <devfile_write+0x31>
		return r;
  802dcd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dd0:	e9 9a 00 00 00       	jmpq   802e6f <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802dd5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dd9:	8b 50 0c             	mov    0xc(%rax),%edx
  802ddc:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802de3:	00 00 00 
  802de6:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802de8:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802def:	00 
  802df0:	76 08                	jbe    802dfa <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802df2:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802df9:	00 
	}
	fsipcbuf.write.req_n = n;
  802dfa:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802e01:	00 00 00 
  802e04:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e08:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802e0c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e10:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e14:	48 89 c6             	mov    %rax,%rsi
  802e17:	48 bf 10 b0 80 00 00 	movabs $0x80b010,%rdi
  802e1e:	00 00 00 
  802e21:	48 b8 6d 18 80 00 00 	movabs $0x80186d,%rax
  802e28:	00 00 00 
  802e2b:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802e2d:	be 00 00 00 00       	mov    $0x0,%esi
  802e32:	bf 04 00 00 00       	mov    $0x4,%edi
  802e37:	48 b8 16 2b 80 00 00 	movabs $0x802b16,%rax
  802e3e:	00 00 00 
  802e41:	ff d0                	callq  *%rax
  802e43:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e46:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e4a:	7f 20                	jg     802e6c <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802e4c:	48 bf 16 55 80 00 00 	movabs $0x805516,%rdi
  802e53:	00 00 00 
  802e56:	b8 00 00 00 00       	mov    $0x0,%eax
  802e5b:	48 ba 94 09 80 00 00 	movabs $0x800994,%rdx
  802e62:	00 00 00 
  802e65:	ff d2                	callq  *%rdx
		return r;
  802e67:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e6a:	eb 03                	jmp    802e6f <devfile_write+0xcb>
	}
	return r;
  802e6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802e6f:	c9                   	leaveq 
  802e70:	c3                   	retq   

0000000000802e71 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802e71:	55                   	push   %rbp
  802e72:	48 89 e5             	mov    %rsp,%rbp
  802e75:	48 83 ec 20          	sub    $0x20,%rsp
  802e79:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e7d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802e81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e85:	8b 50 0c             	mov    0xc(%rax),%edx
  802e88:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802e8f:	00 00 00 
  802e92:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802e94:	be 00 00 00 00       	mov    $0x0,%esi
  802e99:	bf 05 00 00 00       	mov    $0x5,%edi
  802e9e:	48 b8 16 2b 80 00 00 	movabs $0x802b16,%rax
  802ea5:	00 00 00 
  802ea8:	ff d0                	callq  *%rax
  802eaa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ead:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802eb1:	79 05                	jns    802eb8 <devfile_stat+0x47>
		return r;
  802eb3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eb6:	eb 56                	jmp    802f0e <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802eb8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ebc:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  802ec3:	00 00 00 
  802ec6:	48 89 c7             	mov    %rax,%rdi
  802ec9:	48 b8 49 15 80 00 00 	movabs $0x801549,%rax
  802ed0:	00 00 00 
  802ed3:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802ed5:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802edc:	00 00 00 
  802edf:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802ee5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ee9:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802eef:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802ef6:	00 00 00 
  802ef9:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802eff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f03:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802f09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f0e:	c9                   	leaveq 
  802f0f:	c3                   	retq   

0000000000802f10 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802f10:	55                   	push   %rbp
  802f11:	48 89 e5             	mov    %rsp,%rbp
  802f14:	48 83 ec 10          	sub    $0x10,%rsp
  802f18:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802f1c:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802f1f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f23:	8b 50 0c             	mov    0xc(%rax),%edx
  802f26:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802f2d:	00 00 00 
  802f30:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802f32:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802f39:	00 00 00 
  802f3c:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802f3f:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802f42:	be 00 00 00 00       	mov    $0x0,%esi
  802f47:	bf 02 00 00 00       	mov    $0x2,%edi
  802f4c:	48 b8 16 2b 80 00 00 	movabs $0x802b16,%rax
  802f53:	00 00 00 
  802f56:	ff d0                	callq  *%rax
}
  802f58:	c9                   	leaveq 
  802f59:	c3                   	retq   

0000000000802f5a <remove>:

// Delete a file
int
remove(const char *path)
{
  802f5a:	55                   	push   %rbp
  802f5b:	48 89 e5             	mov    %rsp,%rbp
  802f5e:	48 83 ec 10          	sub    $0x10,%rsp
  802f62:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802f66:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f6a:	48 89 c7             	mov    %rax,%rdi
  802f6d:	48 b8 dd 14 80 00 00 	movabs $0x8014dd,%rax
  802f74:	00 00 00 
  802f77:	ff d0                	callq  *%rax
  802f79:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802f7e:	7e 07                	jle    802f87 <remove+0x2d>
		return -E_BAD_PATH;
  802f80:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802f85:	eb 33                	jmp    802fba <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802f87:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f8b:	48 89 c6             	mov    %rax,%rsi
  802f8e:	48 bf 00 b0 80 00 00 	movabs $0x80b000,%rdi
  802f95:	00 00 00 
  802f98:	48 b8 49 15 80 00 00 	movabs $0x801549,%rax
  802f9f:	00 00 00 
  802fa2:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802fa4:	be 00 00 00 00       	mov    $0x0,%esi
  802fa9:	bf 07 00 00 00       	mov    $0x7,%edi
  802fae:	48 b8 16 2b 80 00 00 	movabs $0x802b16,%rax
  802fb5:	00 00 00 
  802fb8:	ff d0                	callq  *%rax
}
  802fba:	c9                   	leaveq 
  802fbb:	c3                   	retq   

0000000000802fbc <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802fbc:	55                   	push   %rbp
  802fbd:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802fc0:	be 00 00 00 00       	mov    $0x0,%esi
  802fc5:	bf 08 00 00 00       	mov    $0x8,%edi
  802fca:	48 b8 16 2b 80 00 00 	movabs $0x802b16,%rax
  802fd1:	00 00 00 
  802fd4:	ff d0                	callq  *%rax
}
  802fd6:	5d                   	pop    %rbp
  802fd7:	c3                   	retq   

0000000000802fd8 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802fd8:	55                   	push   %rbp
  802fd9:	48 89 e5             	mov    %rsp,%rbp
  802fdc:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802fe3:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802fea:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802ff1:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802ff8:	be 00 00 00 00       	mov    $0x0,%esi
  802ffd:	48 89 c7             	mov    %rax,%rdi
  803000:	48 b8 9d 2b 80 00 00 	movabs $0x802b9d,%rax
  803007:	00 00 00 
  80300a:	ff d0                	callq  *%rax
  80300c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  80300f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803013:	79 28                	jns    80303d <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803015:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803018:	89 c6                	mov    %eax,%esi
  80301a:	48 bf 32 55 80 00 00 	movabs $0x805532,%rdi
  803021:	00 00 00 
  803024:	b8 00 00 00 00       	mov    $0x0,%eax
  803029:	48 ba 94 09 80 00 00 	movabs $0x800994,%rdx
  803030:	00 00 00 
  803033:	ff d2                	callq  *%rdx
		return fd_src;
  803035:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803038:	e9 74 01 00 00       	jmpq   8031b1 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80303d:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803044:	be 01 01 00 00       	mov    $0x101,%esi
  803049:	48 89 c7             	mov    %rax,%rdi
  80304c:	48 b8 9d 2b 80 00 00 	movabs $0x802b9d,%rax
  803053:	00 00 00 
  803056:	ff d0                	callq  *%rax
  803058:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  80305b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80305f:	79 39                	jns    80309a <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803061:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803064:	89 c6                	mov    %eax,%esi
  803066:	48 bf 48 55 80 00 00 	movabs $0x805548,%rdi
  80306d:	00 00 00 
  803070:	b8 00 00 00 00       	mov    $0x0,%eax
  803075:	48 ba 94 09 80 00 00 	movabs $0x800994,%rdx
  80307c:	00 00 00 
  80307f:	ff d2                	callq  *%rdx
		close(fd_src);
  803081:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803084:	89 c7                	mov    %eax,%edi
  803086:	48 b8 a5 24 80 00 00 	movabs $0x8024a5,%rax
  80308d:	00 00 00 
  803090:	ff d0                	callq  *%rax
		return fd_dest;
  803092:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803095:	e9 17 01 00 00       	jmpq   8031b1 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80309a:	eb 74                	jmp    803110 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  80309c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80309f:	48 63 d0             	movslq %eax,%rdx
  8030a2:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8030a9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030ac:	48 89 ce             	mov    %rcx,%rsi
  8030af:	89 c7                	mov    %eax,%edi
  8030b1:	48 b8 11 28 80 00 00 	movabs $0x802811,%rax
  8030b8:	00 00 00 
  8030bb:	ff d0                	callq  *%rax
  8030bd:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8030c0:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8030c4:	79 4a                	jns    803110 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8030c6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8030c9:	89 c6                	mov    %eax,%esi
  8030cb:	48 bf 62 55 80 00 00 	movabs $0x805562,%rdi
  8030d2:	00 00 00 
  8030d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8030da:	48 ba 94 09 80 00 00 	movabs $0x800994,%rdx
  8030e1:	00 00 00 
  8030e4:	ff d2                	callq  *%rdx
			close(fd_src);
  8030e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030e9:	89 c7                	mov    %eax,%edi
  8030eb:	48 b8 a5 24 80 00 00 	movabs $0x8024a5,%rax
  8030f2:	00 00 00 
  8030f5:	ff d0                	callq  *%rax
			close(fd_dest);
  8030f7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030fa:	89 c7                	mov    %eax,%edi
  8030fc:	48 b8 a5 24 80 00 00 	movabs $0x8024a5,%rax
  803103:	00 00 00 
  803106:	ff d0                	callq  *%rax
			return write_size;
  803108:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80310b:	e9 a1 00 00 00       	jmpq   8031b1 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803110:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803117:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80311a:	ba 00 02 00 00       	mov    $0x200,%edx
  80311f:	48 89 ce             	mov    %rcx,%rsi
  803122:	89 c7                	mov    %eax,%edi
  803124:	48 b8 c7 26 80 00 00 	movabs $0x8026c7,%rax
  80312b:	00 00 00 
  80312e:	ff d0                	callq  *%rax
  803130:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803133:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803137:	0f 8f 5f ff ff ff    	jg     80309c <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  80313d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803141:	79 47                	jns    80318a <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803143:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803146:	89 c6                	mov    %eax,%esi
  803148:	48 bf 75 55 80 00 00 	movabs $0x805575,%rdi
  80314f:	00 00 00 
  803152:	b8 00 00 00 00       	mov    $0x0,%eax
  803157:	48 ba 94 09 80 00 00 	movabs $0x800994,%rdx
  80315e:	00 00 00 
  803161:	ff d2                	callq  *%rdx
		close(fd_src);
  803163:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803166:	89 c7                	mov    %eax,%edi
  803168:	48 b8 a5 24 80 00 00 	movabs $0x8024a5,%rax
  80316f:	00 00 00 
  803172:	ff d0                	callq  *%rax
		close(fd_dest);
  803174:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803177:	89 c7                	mov    %eax,%edi
  803179:	48 b8 a5 24 80 00 00 	movabs $0x8024a5,%rax
  803180:	00 00 00 
  803183:	ff d0                	callq  *%rax
		return read_size;
  803185:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803188:	eb 27                	jmp    8031b1 <copy+0x1d9>
	}
	close(fd_src);
  80318a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80318d:	89 c7                	mov    %eax,%edi
  80318f:	48 b8 a5 24 80 00 00 	movabs $0x8024a5,%rax
  803196:	00 00 00 
  803199:	ff d0                	callq  *%rax
	close(fd_dest);
  80319b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80319e:	89 c7                	mov    %eax,%edi
  8031a0:	48 b8 a5 24 80 00 00 	movabs $0x8024a5,%rax
  8031a7:	00 00 00 
  8031aa:	ff d0                	callq  *%rax
	return 0;
  8031ac:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8031b1:	c9                   	leaveq 
  8031b2:	c3                   	retq   

00000000008031b3 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8031b3:	55                   	push   %rbp
  8031b4:	48 89 e5             	mov    %rsp,%rbp
  8031b7:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  8031be:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  8031c5:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8031cc:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  8031d3:	be 00 00 00 00       	mov    $0x0,%esi
  8031d8:	48 89 c7             	mov    %rax,%rdi
  8031db:	48 b8 9d 2b 80 00 00 	movabs $0x802b9d,%rax
  8031e2:	00 00 00 
  8031e5:	ff d0                	callq  *%rax
  8031e7:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8031ea:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8031ee:	79 08                	jns    8031f8 <spawn+0x45>
		return r;
  8031f0:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8031f3:	e9 14 03 00 00       	jmpq   80350c <spawn+0x359>
	fd = r;
  8031f8:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8031fb:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  8031fe:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  803205:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  803209:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  803210:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803213:	ba 00 02 00 00       	mov    $0x200,%edx
  803218:	48 89 ce             	mov    %rcx,%rsi
  80321b:	89 c7                	mov    %eax,%edi
  80321d:	48 b8 9c 27 80 00 00 	movabs $0x80279c,%rax
  803224:	00 00 00 
  803227:	ff d0                	callq  *%rax
  803229:	3d 00 02 00 00       	cmp    $0x200,%eax
  80322e:	75 0d                	jne    80323d <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  803230:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803234:	8b 00                	mov    (%rax),%eax
  803236:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  80323b:	74 43                	je     803280 <spawn+0xcd>
		close(fd);
  80323d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803240:	89 c7                	mov    %eax,%edi
  803242:	48 b8 a5 24 80 00 00 	movabs $0x8024a5,%rax
  803249:	00 00 00 
  80324c:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  80324e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803252:	8b 00                	mov    (%rax),%eax
  803254:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  803259:	89 c6                	mov    %eax,%esi
  80325b:	48 bf 90 55 80 00 00 	movabs $0x805590,%rdi
  803262:	00 00 00 
  803265:	b8 00 00 00 00       	mov    $0x0,%eax
  80326a:	48 b9 94 09 80 00 00 	movabs $0x800994,%rcx
  803271:	00 00 00 
  803274:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  803276:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80327b:	e9 8c 02 00 00       	jmpq   80350c <spawn+0x359>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  803280:	b8 07 00 00 00       	mov    $0x7,%eax
  803285:	cd 30                	int    $0x30
  803287:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  80328a:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  80328d:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803290:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803294:	79 08                	jns    80329e <spawn+0xeb>
		return r;
  803296:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803299:	e9 6e 02 00 00       	jmpq   80350c <spawn+0x359>
	child = r;
  80329e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8032a1:	89 45 d4             	mov    %eax,-0x2c(%rbp)
	//thisenv = &envs[ENVX(sys_getenvid())];
	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  8032a4:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8032a7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8032ac:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8032b3:	00 00 00 
  8032b6:	48 63 d0             	movslq %eax,%rdx
  8032b9:	48 89 d0             	mov    %rdx,%rax
  8032bc:	48 c1 e0 03          	shl    $0x3,%rax
  8032c0:	48 01 d0             	add    %rdx,%rax
  8032c3:	48 c1 e0 05          	shl    $0x5,%rax
  8032c7:	48 01 c8             	add    %rcx,%rax
  8032ca:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  8032d1:	48 89 c6             	mov    %rax,%rsi
  8032d4:	b8 18 00 00 00       	mov    $0x18,%eax
  8032d9:	48 89 d7             	mov    %rdx,%rdi
  8032dc:	48 89 c1             	mov    %rax,%rcx
  8032df:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  8032e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032e6:	48 8b 40 18          	mov    0x18(%rax),%rax
  8032ea:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  8032f1:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  8032f8:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  8032ff:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  803306:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803309:	48 89 ce             	mov    %rcx,%rsi
  80330c:	89 c7                	mov    %eax,%edi
  80330e:	48 b8 76 37 80 00 00 	movabs $0x803776,%rax
  803315:	00 00 00 
  803318:	ff d0                	callq  *%rax
  80331a:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80331d:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803321:	79 08                	jns    80332b <spawn+0x178>
		return r;
  803323:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803326:	e9 e1 01 00 00       	jmpq   80350c <spawn+0x359>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  80332b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80332f:	48 8b 40 20          	mov    0x20(%rax),%rax
  803333:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  80333a:	48 01 d0             	add    %rdx,%rax
  80333d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  803341:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803348:	e9 a3 00 00 00       	jmpq   8033f0 <spawn+0x23d>
		if (ph->p_type != ELF_PROG_LOAD)
  80334d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803351:	8b 00                	mov    (%rax),%eax
  803353:	83 f8 01             	cmp    $0x1,%eax
  803356:	74 05                	je     80335d <spawn+0x1aa>
			continue;
  803358:	e9 8a 00 00 00       	jmpq   8033e7 <spawn+0x234>
		perm = PTE_P | PTE_U;
  80335d:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  803364:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803368:	8b 40 04             	mov    0x4(%rax),%eax
  80336b:	83 e0 02             	and    $0x2,%eax
  80336e:	85 c0                	test   %eax,%eax
  803370:	74 04                	je     803376 <spawn+0x1c3>
			perm |= PTE_W;
  803372:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  803376:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80337a:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  80337e:	41 89 c1             	mov    %eax,%r9d
  803381:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803385:	4c 8b 40 20          	mov    0x20(%rax),%r8
  803389:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80338d:	48 8b 50 28          	mov    0x28(%rax),%rdx
  803391:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803395:	48 8b 70 10          	mov    0x10(%rax),%rsi
  803399:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80339c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80339f:	8b 7d ec             	mov    -0x14(%rbp),%edi
  8033a2:	89 3c 24             	mov    %edi,(%rsp)
  8033a5:	89 c7                	mov    %eax,%edi
  8033a7:	48 b8 1f 3a 80 00 00 	movabs $0x803a1f,%rax
  8033ae:	00 00 00 
  8033b1:	ff d0                	callq  *%rax
  8033b3:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8033b6:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8033ba:	79 2b                	jns    8033e7 <spawn+0x234>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  8033bc:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  8033bd:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8033c0:	89 c7                	mov    %eax,%edi
  8033c2:	48 b8 b8 1d 80 00 00 	movabs $0x801db8,%rax
  8033c9:	00 00 00 
  8033cc:	ff d0                	callq  *%rax
	close(fd);
  8033ce:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8033d1:	89 c7                	mov    %eax,%edi
  8033d3:	48 b8 a5 24 80 00 00 	movabs $0x8024a5,%rax
  8033da:	00 00 00 
  8033dd:	ff d0                	callq  *%rax
	return r;
  8033df:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8033e2:	e9 25 01 00 00       	jmpq   80350c <spawn+0x359>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8033e7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8033eb:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  8033f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033f4:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  8033f8:	0f b7 c0             	movzwl %ax,%eax
  8033fb:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8033fe:	0f 8f 49 ff ff ff    	jg     80334d <spawn+0x19a>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  803404:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803407:	89 c7                	mov    %eax,%edi
  803409:	48 b8 a5 24 80 00 00 	movabs $0x8024a5,%rax
  803410:	00 00 00 
  803413:	ff d0                	callq  *%rax
	fd = -1;
  803415:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  80341c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80341f:	89 c7                	mov    %eax,%edi
  803421:	48 b8 0b 3c 80 00 00 	movabs $0x803c0b,%rax
  803428:	00 00 00 
  80342b:	ff d0                	callq  *%rax
  80342d:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803430:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803434:	79 30                	jns    803466 <spawn+0x2b3>
		panic("copy_shared_pages: %e", r);
  803436:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803439:	89 c1                	mov    %eax,%ecx
  80343b:	48 ba aa 55 80 00 00 	movabs $0x8055aa,%rdx
  803442:	00 00 00 
  803445:	be 82 00 00 00       	mov    $0x82,%esi
  80344a:	48 bf c0 55 80 00 00 	movabs $0x8055c0,%rdi
  803451:	00 00 00 
  803454:	b8 00 00 00 00       	mov    $0x0,%eax
  803459:	49 b8 5b 07 80 00 00 	movabs $0x80075b,%r8
  803460:	00 00 00 
  803463:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  803466:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  80346d:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803470:	48 89 d6             	mov    %rdx,%rsi
  803473:	89 c7                	mov    %eax,%edi
  803475:	48 b8 b8 1f 80 00 00 	movabs $0x801fb8,%rax
  80347c:	00 00 00 
  80347f:	ff d0                	callq  *%rax
  803481:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803484:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803488:	79 30                	jns    8034ba <spawn+0x307>
		panic("sys_env_set_trapframe: %e", r);
  80348a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80348d:	89 c1                	mov    %eax,%ecx
  80348f:	48 ba cc 55 80 00 00 	movabs $0x8055cc,%rdx
  803496:	00 00 00 
  803499:	be 85 00 00 00       	mov    $0x85,%esi
  80349e:	48 bf c0 55 80 00 00 	movabs $0x8055c0,%rdi
  8034a5:	00 00 00 
  8034a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8034ad:	49 b8 5b 07 80 00 00 	movabs $0x80075b,%r8
  8034b4:	00 00 00 
  8034b7:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  8034ba:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8034bd:	be 02 00 00 00       	mov    $0x2,%esi
  8034c2:	89 c7                	mov    %eax,%edi
  8034c4:	48 b8 6d 1f 80 00 00 	movabs $0x801f6d,%rax
  8034cb:	00 00 00 
  8034ce:	ff d0                	callq  *%rax
  8034d0:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8034d3:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8034d7:	79 30                	jns    803509 <spawn+0x356>
		panic("sys_env_set_status: %e", r);
  8034d9:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8034dc:	89 c1                	mov    %eax,%ecx
  8034de:	48 ba e6 55 80 00 00 	movabs $0x8055e6,%rdx
  8034e5:	00 00 00 
  8034e8:	be 88 00 00 00       	mov    $0x88,%esi
  8034ed:	48 bf c0 55 80 00 00 	movabs $0x8055c0,%rdi
  8034f4:	00 00 00 
  8034f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8034fc:	49 b8 5b 07 80 00 00 	movabs $0x80075b,%r8
  803503:	00 00 00 
  803506:	41 ff d0             	callq  *%r8

	return child;
  803509:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  80350c:	c9                   	leaveq 
  80350d:	c3                   	retq   

000000000080350e <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  80350e:	55                   	push   %rbp
  80350f:	48 89 e5             	mov    %rsp,%rbp
  803512:	41 55                	push   %r13
  803514:	41 54                	push   %r12
  803516:	53                   	push   %rbx
  803517:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80351e:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  803525:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  80352c:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  803533:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  80353a:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  803541:	84 c0                	test   %al,%al
  803543:	74 26                	je     80356b <spawnl+0x5d>
  803545:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  80354c:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  803553:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  803557:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  80355b:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  80355f:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  803563:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  803567:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  80356b:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  803572:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  803579:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  80357c:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803583:	00 00 00 
  803586:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  80358d:	00 00 00 
  803590:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803594:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  80359b:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  8035a2:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  8035a9:	eb 07                	jmp    8035b2 <spawnl+0xa4>
		argc++;
  8035ab:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8035b2:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  8035b8:	83 f8 30             	cmp    $0x30,%eax
  8035bb:	73 23                	jae    8035e0 <spawnl+0xd2>
  8035bd:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  8035c4:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  8035ca:	89 c0                	mov    %eax,%eax
  8035cc:	48 01 d0             	add    %rdx,%rax
  8035cf:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8035d5:	83 c2 08             	add    $0x8,%edx
  8035d8:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  8035de:	eb 15                	jmp    8035f5 <spawnl+0xe7>
  8035e0:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  8035e7:	48 89 d0             	mov    %rdx,%rax
  8035ea:	48 83 c2 08          	add    $0x8,%rdx
  8035ee:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8035f5:	48 8b 00             	mov    (%rax),%rax
  8035f8:	48 85 c0             	test   %rax,%rax
  8035fb:	75 ae                	jne    8035ab <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  8035fd:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803603:	83 c0 02             	add    $0x2,%eax
  803606:	48 89 e2             	mov    %rsp,%rdx
  803609:	48 89 d3             	mov    %rdx,%rbx
  80360c:	48 63 d0             	movslq %eax,%rdx
  80360f:	48 83 ea 01          	sub    $0x1,%rdx
  803613:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  80361a:	48 63 d0             	movslq %eax,%rdx
  80361d:	49 89 d4             	mov    %rdx,%r12
  803620:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  803626:	48 63 d0             	movslq %eax,%rdx
  803629:	49 89 d2             	mov    %rdx,%r10
  80362c:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  803632:	48 98                	cltq   
  803634:	48 c1 e0 03          	shl    $0x3,%rax
  803638:	48 8d 50 07          	lea    0x7(%rax),%rdx
  80363c:	b8 10 00 00 00       	mov    $0x10,%eax
  803641:	48 83 e8 01          	sub    $0x1,%rax
  803645:	48 01 d0             	add    %rdx,%rax
  803648:	bf 10 00 00 00       	mov    $0x10,%edi
  80364d:	ba 00 00 00 00       	mov    $0x0,%edx
  803652:	48 f7 f7             	div    %rdi
  803655:	48 6b c0 10          	imul   $0x10,%rax,%rax
  803659:	48 29 c4             	sub    %rax,%rsp
  80365c:	48 89 e0             	mov    %rsp,%rax
  80365f:	48 83 c0 07          	add    $0x7,%rax
  803663:	48 c1 e8 03          	shr    $0x3,%rax
  803667:	48 c1 e0 03          	shl    $0x3,%rax
  80366b:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  803672:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803679:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  803680:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  803683:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803689:	8d 50 01             	lea    0x1(%rax),%edx
  80368c:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803693:	48 63 d2             	movslq %edx,%rdx
  803696:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  80369d:	00 

	va_start(vl, arg0);
  80369e:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  8036a5:	00 00 00 
  8036a8:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  8036af:	00 00 00 
  8036b2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8036b6:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  8036bd:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  8036c4:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  8036cb:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  8036d2:	00 00 00 
  8036d5:	eb 63                	jmp    80373a <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  8036d7:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  8036dd:	8d 70 01             	lea    0x1(%rax),%esi
  8036e0:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  8036e6:	83 f8 30             	cmp    $0x30,%eax
  8036e9:	73 23                	jae    80370e <spawnl+0x200>
  8036eb:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  8036f2:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  8036f8:	89 c0                	mov    %eax,%eax
  8036fa:	48 01 d0             	add    %rdx,%rax
  8036fd:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803703:	83 c2 08             	add    $0x8,%edx
  803706:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  80370c:	eb 15                	jmp    803723 <spawnl+0x215>
  80370e:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  803715:	48 89 d0             	mov    %rdx,%rax
  803718:	48 83 c2 08          	add    $0x8,%rdx
  80371c:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803723:	48 8b 08             	mov    (%rax),%rcx
  803726:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80372d:	89 f2                	mov    %esi,%edx
  80372f:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  803733:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  80373a:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803740:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  803746:	77 8f                	ja     8036d7 <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  803748:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80374f:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  803756:	48 89 d6             	mov    %rdx,%rsi
  803759:	48 89 c7             	mov    %rax,%rdi
  80375c:	48 b8 b3 31 80 00 00 	movabs $0x8031b3,%rax
  803763:	00 00 00 
  803766:	ff d0                	callq  *%rax
  803768:	48 89 dc             	mov    %rbx,%rsp
}
  80376b:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  80376f:	5b                   	pop    %rbx
  803770:	41 5c                	pop    %r12
  803772:	41 5d                	pop    %r13
  803774:	5d                   	pop    %rbp
  803775:	c3                   	retq   

0000000000803776 <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  803776:	55                   	push   %rbp
  803777:	48 89 e5             	mov    %rsp,%rbp
  80377a:	48 83 ec 50          	sub    $0x50,%rsp
  80377e:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803781:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  803785:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  803789:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803790:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  803791:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  803798:	eb 33                	jmp    8037cd <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  80379a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80379d:	48 98                	cltq   
  80379f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8037a6:	00 
  8037a7:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8037ab:	48 01 d0             	add    %rdx,%rax
  8037ae:	48 8b 00             	mov    (%rax),%rax
  8037b1:	48 89 c7             	mov    %rax,%rdi
  8037b4:	48 b8 dd 14 80 00 00 	movabs $0x8014dd,%rax
  8037bb:	00 00 00 
  8037be:	ff d0                	callq  *%rax
  8037c0:	83 c0 01             	add    $0x1,%eax
  8037c3:	48 98                	cltq   
  8037c5:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8037c9:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  8037cd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8037d0:	48 98                	cltq   
  8037d2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8037d9:	00 
  8037da:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8037de:	48 01 d0             	add    %rdx,%rax
  8037e1:	48 8b 00             	mov    (%rax),%rax
  8037e4:	48 85 c0             	test   %rax,%rax
  8037e7:	75 b1                	jne    80379a <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8037e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037ed:	48 f7 d8             	neg    %rax
  8037f0:	48 05 00 10 40 00    	add    $0x401000,%rax
  8037f6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  8037fa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037fe:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803802:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803806:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  80380a:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80380d:	83 c2 01             	add    $0x1,%edx
  803810:	c1 e2 03             	shl    $0x3,%edx
  803813:	48 63 d2             	movslq %edx,%rdx
  803816:	48 f7 da             	neg    %rdx
  803819:	48 01 d0             	add    %rdx,%rax
  80381c:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  803820:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803824:	48 83 e8 10          	sub    $0x10,%rax
  803828:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  80382e:	77 0a                	ja     80383a <init_stack+0xc4>
		return -E_NO_MEM;
  803830:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  803835:	e9 e3 01 00 00       	jmpq   803a1d <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80383a:	ba 07 00 00 00       	mov    $0x7,%edx
  80383f:	be 00 00 40 00       	mov    $0x400000,%esi
  803844:	bf 00 00 00 00       	mov    $0x0,%edi
  803849:	48 b8 78 1e 80 00 00 	movabs $0x801e78,%rax
  803850:	00 00 00 
  803853:	ff d0                	callq  *%rax
  803855:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803858:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80385c:	79 08                	jns    803866 <init_stack+0xf0>
		return r;
  80385e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803861:	e9 b7 01 00 00       	jmpq   803a1d <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803866:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  80386d:	e9 8a 00 00 00       	jmpq   8038fc <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  803872:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803875:	48 98                	cltq   
  803877:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80387e:	00 
  80387f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803883:	48 01 c2             	add    %rax,%rdx
  803886:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  80388b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80388f:	48 01 c8             	add    %rcx,%rax
  803892:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803898:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  80389b:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80389e:	48 98                	cltq   
  8038a0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8038a7:	00 
  8038a8:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8038ac:	48 01 d0             	add    %rdx,%rax
  8038af:	48 8b 10             	mov    (%rax),%rdx
  8038b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038b6:	48 89 d6             	mov    %rdx,%rsi
  8038b9:	48 89 c7             	mov    %rax,%rdi
  8038bc:	48 b8 49 15 80 00 00 	movabs $0x801549,%rax
  8038c3:	00 00 00 
  8038c6:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  8038c8:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8038cb:	48 98                	cltq   
  8038cd:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8038d4:	00 
  8038d5:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8038d9:	48 01 d0             	add    %rdx,%rax
  8038dc:	48 8b 00             	mov    (%rax),%rax
  8038df:	48 89 c7             	mov    %rax,%rdi
  8038e2:	48 b8 dd 14 80 00 00 	movabs $0x8014dd,%rax
  8038e9:	00 00 00 
  8038ec:	ff d0                	callq  *%rax
  8038ee:	48 98                	cltq   
  8038f0:	48 83 c0 01          	add    $0x1,%rax
  8038f4:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8038f8:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  8038fc:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8038ff:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  803902:	0f 8c 6a ff ff ff    	jl     803872 <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  803908:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80390b:	48 98                	cltq   
  80390d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803914:	00 
  803915:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803919:	48 01 d0             	add    %rdx,%rax
  80391c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  803923:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  80392a:	00 
  80392b:	74 35                	je     803962 <init_stack+0x1ec>
  80392d:	48 b9 00 56 80 00 00 	movabs $0x805600,%rcx
  803934:	00 00 00 
  803937:	48 ba 26 56 80 00 00 	movabs $0x805626,%rdx
  80393e:	00 00 00 
  803941:	be f1 00 00 00       	mov    $0xf1,%esi
  803946:	48 bf c0 55 80 00 00 	movabs $0x8055c0,%rdi
  80394d:	00 00 00 
  803950:	b8 00 00 00 00       	mov    $0x0,%eax
  803955:	49 b8 5b 07 80 00 00 	movabs $0x80075b,%r8
  80395c:	00 00 00 
  80395f:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  803962:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803966:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  80396a:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  80396f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803973:	48 01 c8             	add    %rcx,%rax
  803976:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  80397c:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  80397f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803983:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  803987:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80398a:	48 98                	cltq   
  80398c:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  80398f:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  803994:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803998:	48 01 d0             	add    %rdx,%rax
  80399b:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  8039a1:	48 89 c2             	mov    %rax,%rdx
  8039a4:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8039a8:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8039ab:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8039ae:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8039b4:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8039b9:	89 c2                	mov    %eax,%edx
  8039bb:	be 00 00 40 00       	mov    $0x400000,%esi
  8039c0:	bf 00 00 00 00       	mov    $0x0,%edi
  8039c5:	48 b8 c8 1e 80 00 00 	movabs $0x801ec8,%rax
  8039cc:	00 00 00 
  8039cf:	ff d0                	callq  *%rax
  8039d1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8039d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8039d8:	79 02                	jns    8039dc <init_stack+0x266>
		goto error;
  8039da:	eb 28                	jmp    803a04 <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8039dc:	be 00 00 40 00       	mov    $0x400000,%esi
  8039e1:	bf 00 00 00 00       	mov    $0x0,%edi
  8039e6:	48 b8 23 1f 80 00 00 	movabs $0x801f23,%rax
  8039ed:	00 00 00 
  8039f0:	ff d0                	callq  *%rax
  8039f2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8039f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8039f9:	79 02                	jns    8039fd <init_stack+0x287>
		goto error;
  8039fb:	eb 07                	jmp    803a04 <init_stack+0x28e>

	return 0;
  8039fd:	b8 00 00 00 00       	mov    $0x0,%eax
  803a02:	eb 19                	jmp    803a1d <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  803a04:	be 00 00 40 00       	mov    $0x400000,%esi
  803a09:	bf 00 00 00 00       	mov    $0x0,%edi
  803a0e:	48 b8 23 1f 80 00 00 	movabs $0x801f23,%rax
  803a15:	00 00 00 
  803a18:	ff d0                	callq  *%rax
	return r;
  803a1a:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803a1d:	c9                   	leaveq 
  803a1e:	c3                   	retq   

0000000000803a1f <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  803a1f:	55                   	push   %rbp
  803a20:	48 89 e5             	mov    %rsp,%rbp
  803a23:	48 83 ec 50          	sub    $0x50,%rsp
  803a27:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803a2a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803a2e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  803a32:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  803a35:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  803a39:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  803a3d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a41:	25 ff 0f 00 00       	and    $0xfff,%eax
  803a46:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a49:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a4d:	74 21                	je     803a70 <map_segment+0x51>
		va -= i;
  803a4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a52:	48 98                	cltq   
  803a54:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  803a58:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a5b:	48 98                	cltq   
  803a5d:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  803a61:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a64:	48 98                	cltq   
  803a66:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  803a6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a6d:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803a70:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803a77:	e9 79 01 00 00       	jmpq   803bf5 <map_segment+0x1d6>
		if (i >= filesz) {
  803a7c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a7f:	48 98                	cltq   
  803a81:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  803a85:	72 3c                	jb     803ac3 <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  803a87:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a8a:	48 63 d0             	movslq %eax,%rdx
  803a8d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a91:	48 01 d0             	add    %rdx,%rax
  803a94:	48 89 c1             	mov    %rax,%rcx
  803a97:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803a9a:	8b 55 10             	mov    0x10(%rbp),%edx
  803a9d:	48 89 ce             	mov    %rcx,%rsi
  803aa0:	89 c7                	mov    %eax,%edi
  803aa2:	48 b8 78 1e 80 00 00 	movabs $0x801e78,%rax
  803aa9:	00 00 00 
  803aac:	ff d0                	callq  *%rax
  803aae:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803ab1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803ab5:	0f 89 33 01 00 00    	jns    803bee <map_segment+0x1cf>
				return r;
  803abb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803abe:	e9 46 01 00 00       	jmpq   803c09 <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803ac3:	ba 07 00 00 00       	mov    $0x7,%edx
  803ac8:	be 00 00 40 00       	mov    $0x400000,%esi
  803acd:	bf 00 00 00 00       	mov    $0x0,%edi
  803ad2:	48 b8 78 1e 80 00 00 	movabs $0x801e78,%rax
  803ad9:	00 00 00 
  803adc:	ff d0                	callq  *%rax
  803ade:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803ae1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803ae5:	79 08                	jns    803aef <map_segment+0xd0>
				return r;
  803ae7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803aea:	e9 1a 01 00 00       	jmpq   803c09 <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  803aef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803af2:	8b 55 bc             	mov    -0x44(%rbp),%edx
  803af5:	01 c2                	add    %eax,%edx
  803af7:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803afa:	89 d6                	mov    %edx,%esi
  803afc:	89 c7                	mov    %eax,%edi
  803afe:	48 b8 e5 28 80 00 00 	movabs $0x8028e5,%rax
  803b05:	00 00 00 
  803b08:	ff d0                	callq  *%rax
  803b0a:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803b0d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803b11:	79 08                	jns    803b1b <map_segment+0xfc>
				return r;
  803b13:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b16:	e9 ee 00 00 00       	jmpq   803c09 <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  803b1b:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  803b22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b25:	48 98                	cltq   
  803b27:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803b2b:	48 29 c2             	sub    %rax,%rdx
  803b2e:	48 89 d0             	mov    %rdx,%rax
  803b31:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803b35:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803b38:	48 63 d0             	movslq %eax,%rdx
  803b3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b3f:	48 39 c2             	cmp    %rax,%rdx
  803b42:	48 0f 47 d0          	cmova  %rax,%rdx
  803b46:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803b49:	be 00 00 40 00       	mov    $0x400000,%esi
  803b4e:	89 c7                	mov    %eax,%edi
  803b50:	48 b8 9c 27 80 00 00 	movabs $0x80279c,%rax
  803b57:	00 00 00 
  803b5a:	ff d0                	callq  *%rax
  803b5c:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803b5f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803b63:	79 08                	jns    803b6d <map_segment+0x14e>
				return r;
  803b65:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b68:	e9 9c 00 00 00       	jmpq   803c09 <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  803b6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b70:	48 63 d0             	movslq %eax,%rdx
  803b73:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b77:	48 01 d0             	add    %rdx,%rax
  803b7a:	48 89 c2             	mov    %rax,%rdx
  803b7d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803b80:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  803b84:	48 89 d1             	mov    %rdx,%rcx
  803b87:	89 c2                	mov    %eax,%edx
  803b89:	be 00 00 40 00       	mov    $0x400000,%esi
  803b8e:	bf 00 00 00 00       	mov    $0x0,%edi
  803b93:	48 b8 c8 1e 80 00 00 	movabs $0x801ec8,%rax
  803b9a:	00 00 00 
  803b9d:	ff d0                	callq  *%rax
  803b9f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803ba2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803ba6:	79 30                	jns    803bd8 <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  803ba8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803bab:	89 c1                	mov    %eax,%ecx
  803bad:	48 ba 3b 56 80 00 00 	movabs $0x80563b,%rdx
  803bb4:	00 00 00 
  803bb7:	be 24 01 00 00       	mov    $0x124,%esi
  803bbc:	48 bf c0 55 80 00 00 	movabs $0x8055c0,%rdi
  803bc3:	00 00 00 
  803bc6:	b8 00 00 00 00       	mov    $0x0,%eax
  803bcb:	49 b8 5b 07 80 00 00 	movabs $0x80075b,%r8
  803bd2:	00 00 00 
  803bd5:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  803bd8:	be 00 00 40 00       	mov    $0x400000,%esi
  803bdd:	bf 00 00 00 00       	mov    $0x0,%edi
  803be2:	48 b8 23 1f 80 00 00 	movabs $0x801f23,%rax
  803be9:	00 00 00 
  803bec:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803bee:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  803bf5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bf8:	48 98                	cltq   
  803bfa:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803bfe:	0f 82 78 fe ff ff    	jb     803a7c <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  803c04:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c09:	c9                   	leaveq 
  803c0a:	c3                   	retq   

0000000000803c0b <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  803c0b:	55                   	push   %rbp
  803c0c:	48 89 e5             	mov    %rsp,%rbp
  803c0f:	48 83 ec 20          	sub    $0x20,%rsp
  803c13:	89 7d ec             	mov    %edi,-0x14(%rbp)
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  803c16:	48 c7 45 f8 00 00 80 	movq   $0x800000,-0x8(%rbp)
  803c1d:	00 
  803c1e:	e9 c9 00 00 00       	jmpq   803cec <copy_shared_pages+0xe1>
        {
            if(!((uvpml4e[VPML4E(addr)])&&(uvpde[VPDPE(addr)]) && (uvpd[VPD(addr)]  )))
  803c23:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c27:	48 c1 e8 27          	shr    $0x27,%rax
  803c2b:	48 89 c2             	mov    %rax,%rdx
  803c2e:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  803c35:	01 00 00 
  803c38:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c3c:	48 85 c0             	test   %rax,%rax
  803c3f:	74 3c                	je     803c7d <copy_shared_pages+0x72>
  803c41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c45:	48 c1 e8 1e          	shr    $0x1e,%rax
  803c49:	48 89 c2             	mov    %rax,%rdx
  803c4c:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  803c53:	01 00 00 
  803c56:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c5a:	48 85 c0             	test   %rax,%rax
  803c5d:	74 1e                	je     803c7d <copy_shared_pages+0x72>
  803c5f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c63:	48 c1 e8 15          	shr    $0x15,%rax
  803c67:	48 89 c2             	mov    %rax,%rdx
  803c6a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803c71:	01 00 00 
  803c74:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c78:	48 85 c0             	test   %rax,%rax
  803c7b:	75 02                	jne    803c7f <copy_shared_pages+0x74>
                continue;
  803c7d:	eb 65                	jmp    803ce4 <copy_shared_pages+0xd9>

            if((uvpt[VPN(addr)] & PTE_SHARE) != 0)
  803c7f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c83:	48 c1 e8 0c          	shr    $0xc,%rax
  803c87:	48 89 c2             	mov    %rax,%rdx
  803c8a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803c91:	01 00 00 
  803c94:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c98:	25 00 04 00 00       	and    $0x400,%eax
  803c9d:	48 85 c0             	test   %rax,%rax
  803ca0:	74 42                	je     803ce4 <copy_shared_pages+0xd9>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);
  803ca2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ca6:	48 c1 e8 0c          	shr    $0xc,%rax
  803caa:	48 89 c2             	mov    %rax,%rdx
  803cad:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803cb4:	01 00 00 
  803cb7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803cbb:	25 07 0e 00 00       	and    $0xe07,%eax
  803cc0:	89 c6                	mov    %eax,%esi
  803cc2:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  803cc6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cca:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803ccd:	41 89 f0             	mov    %esi,%r8d
  803cd0:	48 89 c6             	mov    %rax,%rsi
  803cd3:	bf 00 00 00 00       	mov    $0x0,%edi
  803cd8:	48 b8 c8 1e 80 00 00 	movabs $0x801ec8,%rax
  803cdf:	00 00 00 
  803ce2:	ff d0                	callq  *%rax
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  803ce4:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  803ceb:	00 
  803cec:	48 b8 ff ff 7f 00 80 	movabs $0x80007fffff,%rax
  803cf3:	00 00 00 
  803cf6:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  803cfa:	0f 86 23 ff ff ff    	jbe    803c23 <copy_shared_pages+0x18>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);

            }
        }
     return 0;
  803d00:	b8 00 00 00 00       	mov    $0x0,%eax
 }
  803d05:	c9                   	leaveq 
  803d06:	c3                   	retq   

0000000000803d07 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803d07:	55                   	push   %rbp
  803d08:	48 89 e5             	mov    %rsp,%rbp
  803d0b:	48 83 ec 20          	sub    $0x20,%rsp
  803d0f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803d12:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803d16:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d19:	48 89 d6             	mov    %rdx,%rsi
  803d1c:	89 c7                	mov    %eax,%edi
  803d1e:	48 b8 95 22 80 00 00 	movabs $0x802295,%rax
  803d25:	00 00 00 
  803d28:	ff d0                	callq  *%rax
  803d2a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d2d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d31:	79 05                	jns    803d38 <fd2sockid+0x31>
		return r;
  803d33:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d36:	eb 24                	jmp    803d5c <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803d38:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d3c:	8b 10                	mov    (%rax),%edx
  803d3e:	48 b8 40 88 80 00 00 	movabs $0x808840,%rax
  803d45:	00 00 00 
  803d48:	8b 00                	mov    (%rax),%eax
  803d4a:	39 c2                	cmp    %eax,%edx
  803d4c:	74 07                	je     803d55 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803d4e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803d53:	eb 07                	jmp    803d5c <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803d55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d59:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803d5c:	c9                   	leaveq 
  803d5d:	c3                   	retq   

0000000000803d5e <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803d5e:	55                   	push   %rbp
  803d5f:	48 89 e5             	mov    %rsp,%rbp
  803d62:	48 83 ec 20          	sub    $0x20,%rsp
  803d66:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803d69:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803d6d:	48 89 c7             	mov    %rax,%rdi
  803d70:	48 b8 fd 21 80 00 00 	movabs $0x8021fd,%rax
  803d77:	00 00 00 
  803d7a:	ff d0                	callq  *%rax
  803d7c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d7f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d83:	78 26                	js     803dab <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803d85:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d89:	ba 07 04 00 00       	mov    $0x407,%edx
  803d8e:	48 89 c6             	mov    %rax,%rsi
  803d91:	bf 00 00 00 00       	mov    $0x0,%edi
  803d96:	48 b8 78 1e 80 00 00 	movabs $0x801e78,%rax
  803d9d:	00 00 00 
  803da0:	ff d0                	callq  *%rax
  803da2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803da5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803da9:	79 16                	jns    803dc1 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803dab:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803dae:	89 c7                	mov    %eax,%edi
  803db0:	48 b8 6b 42 80 00 00 	movabs $0x80426b,%rax
  803db7:	00 00 00 
  803dba:	ff d0                	callq  *%rax
		return r;
  803dbc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dbf:	eb 3a                	jmp    803dfb <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803dc1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dc5:	48 ba 40 88 80 00 00 	movabs $0x808840,%rdx
  803dcc:	00 00 00 
  803dcf:	8b 12                	mov    (%rdx),%edx
  803dd1:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803dd3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dd7:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803dde:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803de2:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803de5:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803de8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dec:	48 89 c7             	mov    %rax,%rdi
  803def:	48 b8 af 21 80 00 00 	movabs $0x8021af,%rax
  803df6:	00 00 00 
  803df9:	ff d0                	callq  *%rax
}
  803dfb:	c9                   	leaveq 
  803dfc:	c3                   	retq   

0000000000803dfd <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803dfd:	55                   	push   %rbp
  803dfe:	48 89 e5             	mov    %rsp,%rbp
  803e01:	48 83 ec 30          	sub    $0x30,%rsp
  803e05:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803e08:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803e0c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803e10:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e13:	89 c7                	mov    %eax,%edi
  803e15:	48 b8 07 3d 80 00 00 	movabs $0x803d07,%rax
  803e1c:	00 00 00 
  803e1f:	ff d0                	callq  *%rax
  803e21:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e24:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e28:	79 05                	jns    803e2f <accept+0x32>
		return r;
  803e2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e2d:	eb 3b                	jmp    803e6a <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803e2f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803e33:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803e37:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e3a:	48 89 ce             	mov    %rcx,%rsi
  803e3d:	89 c7                	mov    %eax,%edi
  803e3f:	48 b8 48 41 80 00 00 	movabs $0x804148,%rax
  803e46:	00 00 00 
  803e49:	ff d0                	callq  *%rax
  803e4b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e4e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e52:	79 05                	jns    803e59 <accept+0x5c>
		return r;
  803e54:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e57:	eb 11                	jmp    803e6a <accept+0x6d>
	return alloc_sockfd(r);
  803e59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e5c:	89 c7                	mov    %eax,%edi
  803e5e:	48 b8 5e 3d 80 00 00 	movabs $0x803d5e,%rax
  803e65:	00 00 00 
  803e68:	ff d0                	callq  *%rax
}
  803e6a:	c9                   	leaveq 
  803e6b:	c3                   	retq   

0000000000803e6c <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803e6c:	55                   	push   %rbp
  803e6d:	48 89 e5             	mov    %rsp,%rbp
  803e70:	48 83 ec 20          	sub    $0x20,%rsp
  803e74:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803e77:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803e7b:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803e7e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e81:	89 c7                	mov    %eax,%edi
  803e83:	48 b8 07 3d 80 00 00 	movabs $0x803d07,%rax
  803e8a:	00 00 00 
  803e8d:	ff d0                	callq  *%rax
  803e8f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e92:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e96:	79 05                	jns    803e9d <bind+0x31>
		return r;
  803e98:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e9b:	eb 1b                	jmp    803eb8 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803e9d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803ea0:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803ea4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ea7:	48 89 ce             	mov    %rcx,%rsi
  803eaa:	89 c7                	mov    %eax,%edi
  803eac:	48 b8 c7 41 80 00 00 	movabs $0x8041c7,%rax
  803eb3:	00 00 00 
  803eb6:	ff d0                	callq  *%rax
}
  803eb8:	c9                   	leaveq 
  803eb9:	c3                   	retq   

0000000000803eba <shutdown>:

int
shutdown(int s, int how)
{
  803eba:	55                   	push   %rbp
  803ebb:	48 89 e5             	mov    %rsp,%rbp
  803ebe:	48 83 ec 20          	sub    $0x20,%rsp
  803ec2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803ec5:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803ec8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ecb:	89 c7                	mov    %eax,%edi
  803ecd:	48 b8 07 3d 80 00 00 	movabs $0x803d07,%rax
  803ed4:	00 00 00 
  803ed7:	ff d0                	callq  *%rax
  803ed9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803edc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ee0:	79 05                	jns    803ee7 <shutdown+0x2d>
		return r;
  803ee2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ee5:	eb 16                	jmp    803efd <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803ee7:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803eea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803eed:	89 d6                	mov    %edx,%esi
  803eef:	89 c7                	mov    %eax,%edi
  803ef1:	48 b8 2b 42 80 00 00 	movabs $0x80422b,%rax
  803ef8:	00 00 00 
  803efb:	ff d0                	callq  *%rax
}
  803efd:	c9                   	leaveq 
  803efe:	c3                   	retq   

0000000000803eff <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803eff:	55                   	push   %rbp
  803f00:	48 89 e5             	mov    %rsp,%rbp
  803f03:	48 83 ec 10          	sub    $0x10,%rsp
  803f07:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803f0b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f0f:	48 89 c7             	mov    %rax,%rdi
  803f12:	48 b8 63 4d 80 00 00 	movabs $0x804d63,%rax
  803f19:	00 00 00 
  803f1c:	ff d0                	callq  *%rax
  803f1e:	83 f8 01             	cmp    $0x1,%eax
  803f21:	75 17                	jne    803f3a <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803f23:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f27:	8b 40 0c             	mov    0xc(%rax),%eax
  803f2a:	89 c7                	mov    %eax,%edi
  803f2c:	48 b8 6b 42 80 00 00 	movabs $0x80426b,%rax
  803f33:	00 00 00 
  803f36:	ff d0                	callq  *%rax
  803f38:	eb 05                	jmp    803f3f <devsock_close+0x40>
	else
		return 0;
  803f3a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f3f:	c9                   	leaveq 
  803f40:	c3                   	retq   

0000000000803f41 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803f41:	55                   	push   %rbp
  803f42:	48 89 e5             	mov    %rsp,%rbp
  803f45:	48 83 ec 20          	sub    $0x20,%rsp
  803f49:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803f4c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803f50:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803f53:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f56:	89 c7                	mov    %eax,%edi
  803f58:	48 b8 07 3d 80 00 00 	movabs $0x803d07,%rax
  803f5f:	00 00 00 
  803f62:	ff d0                	callq  *%rax
  803f64:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f67:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f6b:	79 05                	jns    803f72 <connect+0x31>
		return r;
  803f6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f70:	eb 1b                	jmp    803f8d <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803f72:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803f75:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803f79:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f7c:	48 89 ce             	mov    %rcx,%rsi
  803f7f:	89 c7                	mov    %eax,%edi
  803f81:	48 b8 98 42 80 00 00 	movabs $0x804298,%rax
  803f88:	00 00 00 
  803f8b:	ff d0                	callq  *%rax
}
  803f8d:	c9                   	leaveq 
  803f8e:	c3                   	retq   

0000000000803f8f <listen>:

int
listen(int s, int backlog)
{
  803f8f:	55                   	push   %rbp
  803f90:	48 89 e5             	mov    %rsp,%rbp
  803f93:	48 83 ec 20          	sub    $0x20,%rsp
  803f97:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803f9a:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803f9d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fa0:	89 c7                	mov    %eax,%edi
  803fa2:	48 b8 07 3d 80 00 00 	movabs $0x803d07,%rax
  803fa9:	00 00 00 
  803fac:	ff d0                	callq  *%rax
  803fae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fb1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fb5:	79 05                	jns    803fbc <listen+0x2d>
		return r;
  803fb7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fba:	eb 16                	jmp    803fd2 <listen+0x43>
	return nsipc_listen(r, backlog);
  803fbc:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803fbf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fc2:	89 d6                	mov    %edx,%esi
  803fc4:	89 c7                	mov    %eax,%edi
  803fc6:	48 b8 fc 42 80 00 00 	movabs $0x8042fc,%rax
  803fcd:	00 00 00 
  803fd0:	ff d0                	callq  *%rax
}
  803fd2:	c9                   	leaveq 
  803fd3:	c3                   	retq   

0000000000803fd4 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803fd4:	55                   	push   %rbp
  803fd5:	48 89 e5             	mov    %rsp,%rbp
  803fd8:	48 83 ec 20          	sub    $0x20,%rsp
  803fdc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803fe0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803fe4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803fe8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fec:	89 c2                	mov    %eax,%edx
  803fee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ff2:	8b 40 0c             	mov    0xc(%rax),%eax
  803ff5:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803ff9:	b9 00 00 00 00       	mov    $0x0,%ecx
  803ffe:	89 c7                	mov    %eax,%edi
  804000:	48 b8 3c 43 80 00 00 	movabs $0x80433c,%rax
  804007:	00 00 00 
  80400a:	ff d0                	callq  *%rax
}
  80400c:	c9                   	leaveq 
  80400d:	c3                   	retq   

000000000080400e <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80400e:	55                   	push   %rbp
  80400f:	48 89 e5             	mov    %rsp,%rbp
  804012:	48 83 ec 20          	sub    $0x20,%rsp
  804016:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80401a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80401e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  804022:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804026:	89 c2                	mov    %eax,%edx
  804028:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80402c:	8b 40 0c             	mov    0xc(%rax),%eax
  80402f:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  804033:	b9 00 00 00 00       	mov    $0x0,%ecx
  804038:	89 c7                	mov    %eax,%edi
  80403a:	48 b8 08 44 80 00 00 	movabs $0x804408,%rax
  804041:	00 00 00 
  804044:	ff d0                	callq  *%rax
}
  804046:	c9                   	leaveq 
  804047:	c3                   	retq   

0000000000804048 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  804048:	55                   	push   %rbp
  804049:	48 89 e5             	mov    %rsp,%rbp
  80404c:	48 83 ec 10          	sub    $0x10,%rsp
  804050:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804054:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  804058:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80405c:	48 be 5d 56 80 00 00 	movabs $0x80565d,%rsi
  804063:	00 00 00 
  804066:	48 89 c7             	mov    %rax,%rdi
  804069:	48 b8 49 15 80 00 00 	movabs $0x801549,%rax
  804070:	00 00 00 
  804073:	ff d0                	callq  *%rax
	return 0;
  804075:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80407a:	c9                   	leaveq 
  80407b:	c3                   	retq   

000000000080407c <socket>:

int
socket(int domain, int type, int protocol)
{
  80407c:	55                   	push   %rbp
  80407d:	48 89 e5             	mov    %rsp,%rbp
  804080:	48 83 ec 20          	sub    $0x20,%rsp
  804084:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804087:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80408a:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80408d:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  804090:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804093:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804096:	89 ce                	mov    %ecx,%esi
  804098:	89 c7                	mov    %eax,%edi
  80409a:	48 b8 c0 44 80 00 00 	movabs $0x8044c0,%rax
  8040a1:	00 00 00 
  8040a4:	ff d0                	callq  *%rax
  8040a6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040a9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040ad:	79 05                	jns    8040b4 <socket+0x38>
		return r;
  8040af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040b2:	eb 11                	jmp    8040c5 <socket+0x49>
	return alloc_sockfd(r);
  8040b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040b7:	89 c7                	mov    %eax,%edi
  8040b9:	48 b8 5e 3d 80 00 00 	movabs $0x803d5e,%rax
  8040c0:	00 00 00 
  8040c3:	ff d0                	callq  *%rax
}
  8040c5:	c9                   	leaveq 
  8040c6:	c3                   	retq   

00000000008040c7 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8040c7:	55                   	push   %rbp
  8040c8:	48 89 e5             	mov    %rsp,%rbp
  8040cb:	48 83 ec 10          	sub    $0x10,%rsp
  8040cf:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8040d2:	48 b8 04 90 80 00 00 	movabs $0x809004,%rax
  8040d9:	00 00 00 
  8040dc:	8b 00                	mov    (%rax),%eax
  8040de:	85 c0                	test   %eax,%eax
  8040e0:	75 1d                	jne    8040ff <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8040e2:	bf 02 00 00 00       	mov    $0x2,%edi
  8040e7:	48 b8 e1 4c 80 00 00 	movabs $0x804ce1,%rax
  8040ee:	00 00 00 
  8040f1:	ff d0                	callq  *%rax
  8040f3:	48 ba 04 90 80 00 00 	movabs $0x809004,%rdx
  8040fa:	00 00 00 
  8040fd:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8040ff:	48 b8 04 90 80 00 00 	movabs $0x809004,%rax
  804106:	00 00 00 
  804109:	8b 00                	mov    (%rax),%eax
  80410b:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80410e:	b9 07 00 00 00       	mov    $0x7,%ecx
  804113:	48 ba 00 d0 80 00 00 	movabs $0x80d000,%rdx
  80411a:	00 00 00 
  80411d:	89 c7                	mov    %eax,%edi
  80411f:	48 b8 7f 4c 80 00 00 	movabs $0x804c7f,%rax
  804126:	00 00 00 
  804129:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  80412b:	ba 00 00 00 00       	mov    $0x0,%edx
  804130:	be 00 00 00 00       	mov    $0x0,%esi
  804135:	bf 00 00 00 00       	mov    $0x0,%edi
  80413a:	48 b8 79 4b 80 00 00 	movabs $0x804b79,%rax
  804141:	00 00 00 
  804144:	ff d0                	callq  *%rax
}
  804146:	c9                   	leaveq 
  804147:	c3                   	retq   

0000000000804148 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  804148:	55                   	push   %rbp
  804149:	48 89 e5             	mov    %rsp,%rbp
  80414c:	48 83 ec 30          	sub    $0x30,%rsp
  804150:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804153:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804157:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  80415b:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  804162:	00 00 00 
  804165:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804168:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80416a:	bf 01 00 00 00       	mov    $0x1,%edi
  80416f:	48 b8 c7 40 80 00 00 	movabs $0x8040c7,%rax
  804176:	00 00 00 
  804179:	ff d0                	callq  *%rax
  80417b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80417e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804182:	78 3e                	js     8041c2 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  804184:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  80418b:	00 00 00 
  80418e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  804192:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804196:	8b 40 10             	mov    0x10(%rax),%eax
  804199:	89 c2                	mov    %eax,%edx
  80419b:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80419f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041a3:	48 89 ce             	mov    %rcx,%rsi
  8041a6:	48 89 c7             	mov    %rax,%rdi
  8041a9:	48 b8 6d 18 80 00 00 	movabs $0x80186d,%rax
  8041b0:	00 00 00 
  8041b3:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8041b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041b9:	8b 50 10             	mov    0x10(%rax),%edx
  8041bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041c0:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8041c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8041c5:	c9                   	leaveq 
  8041c6:	c3                   	retq   

00000000008041c7 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8041c7:	55                   	push   %rbp
  8041c8:	48 89 e5             	mov    %rsp,%rbp
  8041cb:	48 83 ec 10          	sub    $0x10,%rsp
  8041cf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8041d2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8041d6:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8041d9:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8041e0:	00 00 00 
  8041e3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8041e6:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8041e8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8041eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041ef:	48 89 c6             	mov    %rax,%rsi
  8041f2:	48 bf 04 d0 80 00 00 	movabs $0x80d004,%rdi
  8041f9:	00 00 00 
  8041fc:	48 b8 6d 18 80 00 00 	movabs $0x80186d,%rax
  804203:	00 00 00 
  804206:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  804208:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  80420f:	00 00 00 
  804212:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804215:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  804218:	bf 02 00 00 00       	mov    $0x2,%edi
  80421d:	48 b8 c7 40 80 00 00 	movabs $0x8040c7,%rax
  804224:	00 00 00 
  804227:	ff d0                	callq  *%rax
}
  804229:	c9                   	leaveq 
  80422a:	c3                   	retq   

000000000080422b <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80422b:	55                   	push   %rbp
  80422c:	48 89 e5             	mov    %rsp,%rbp
  80422f:	48 83 ec 10          	sub    $0x10,%rsp
  804233:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804236:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  804239:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  804240:	00 00 00 
  804243:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804246:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  804248:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  80424f:	00 00 00 
  804252:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804255:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  804258:	bf 03 00 00 00       	mov    $0x3,%edi
  80425d:	48 b8 c7 40 80 00 00 	movabs $0x8040c7,%rax
  804264:	00 00 00 
  804267:	ff d0                	callq  *%rax
}
  804269:	c9                   	leaveq 
  80426a:	c3                   	retq   

000000000080426b <nsipc_close>:

int
nsipc_close(int s)
{
  80426b:	55                   	push   %rbp
  80426c:	48 89 e5             	mov    %rsp,%rbp
  80426f:	48 83 ec 10          	sub    $0x10,%rsp
  804273:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  804276:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  80427d:	00 00 00 
  804280:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804283:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  804285:	bf 04 00 00 00       	mov    $0x4,%edi
  80428a:	48 b8 c7 40 80 00 00 	movabs $0x8040c7,%rax
  804291:	00 00 00 
  804294:	ff d0                	callq  *%rax
}
  804296:	c9                   	leaveq 
  804297:	c3                   	retq   

0000000000804298 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  804298:	55                   	push   %rbp
  804299:	48 89 e5             	mov    %rsp,%rbp
  80429c:	48 83 ec 10          	sub    $0x10,%rsp
  8042a0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8042a3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8042a7:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8042aa:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8042b1:	00 00 00 
  8042b4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8042b7:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8042b9:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8042bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042c0:	48 89 c6             	mov    %rax,%rsi
  8042c3:	48 bf 04 d0 80 00 00 	movabs $0x80d004,%rdi
  8042ca:	00 00 00 
  8042cd:	48 b8 6d 18 80 00 00 	movabs $0x80186d,%rax
  8042d4:	00 00 00 
  8042d7:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8042d9:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8042e0:	00 00 00 
  8042e3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8042e6:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8042e9:	bf 05 00 00 00       	mov    $0x5,%edi
  8042ee:	48 b8 c7 40 80 00 00 	movabs $0x8040c7,%rax
  8042f5:	00 00 00 
  8042f8:	ff d0                	callq  *%rax
}
  8042fa:	c9                   	leaveq 
  8042fb:	c3                   	retq   

00000000008042fc <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8042fc:	55                   	push   %rbp
  8042fd:	48 89 e5             	mov    %rsp,%rbp
  804300:	48 83 ec 10          	sub    $0x10,%rsp
  804304:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804307:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  80430a:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  804311:	00 00 00 
  804314:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804317:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  804319:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  804320:	00 00 00 
  804323:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804326:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  804329:	bf 06 00 00 00       	mov    $0x6,%edi
  80432e:	48 b8 c7 40 80 00 00 	movabs $0x8040c7,%rax
  804335:	00 00 00 
  804338:	ff d0                	callq  *%rax
}
  80433a:	c9                   	leaveq 
  80433b:	c3                   	retq   

000000000080433c <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80433c:	55                   	push   %rbp
  80433d:	48 89 e5             	mov    %rsp,%rbp
  804340:	48 83 ec 30          	sub    $0x30,%rsp
  804344:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804347:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80434b:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80434e:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  804351:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  804358:	00 00 00 
  80435b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80435e:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  804360:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  804367:	00 00 00 
  80436a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80436d:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  804370:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  804377:	00 00 00 
  80437a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80437d:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  804380:	bf 07 00 00 00       	mov    $0x7,%edi
  804385:	48 b8 c7 40 80 00 00 	movabs $0x8040c7,%rax
  80438c:	00 00 00 
  80438f:	ff d0                	callq  *%rax
  804391:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804394:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804398:	78 69                	js     804403 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  80439a:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8043a1:	7f 08                	jg     8043ab <nsipc_recv+0x6f>
  8043a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043a6:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8043a9:	7e 35                	jle    8043e0 <nsipc_recv+0xa4>
  8043ab:	48 b9 64 56 80 00 00 	movabs $0x805664,%rcx
  8043b2:	00 00 00 
  8043b5:	48 ba 79 56 80 00 00 	movabs $0x805679,%rdx
  8043bc:	00 00 00 
  8043bf:	be 61 00 00 00       	mov    $0x61,%esi
  8043c4:	48 bf 8e 56 80 00 00 	movabs $0x80568e,%rdi
  8043cb:	00 00 00 
  8043ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8043d3:	49 b8 5b 07 80 00 00 	movabs $0x80075b,%r8
  8043da:	00 00 00 
  8043dd:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8043e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043e3:	48 63 d0             	movslq %eax,%rdx
  8043e6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043ea:	48 be 00 d0 80 00 00 	movabs $0x80d000,%rsi
  8043f1:	00 00 00 
  8043f4:	48 89 c7             	mov    %rax,%rdi
  8043f7:	48 b8 6d 18 80 00 00 	movabs $0x80186d,%rax
  8043fe:	00 00 00 
  804401:	ff d0                	callq  *%rax
	}

	return r;
  804403:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804406:	c9                   	leaveq 
  804407:	c3                   	retq   

0000000000804408 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  804408:	55                   	push   %rbp
  804409:	48 89 e5             	mov    %rsp,%rbp
  80440c:	48 83 ec 20          	sub    $0x20,%rsp
  804410:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804413:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804417:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80441a:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  80441d:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  804424:	00 00 00 
  804427:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80442a:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  80442c:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  804433:	7e 35                	jle    80446a <nsipc_send+0x62>
  804435:	48 b9 9a 56 80 00 00 	movabs $0x80569a,%rcx
  80443c:	00 00 00 
  80443f:	48 ba 79 56 80 00 00 	movabs $0x805679,%rdx
  804446:	00 00 00 
  804449:	be 6c 00 00 00       	mov    $0x6c,%esi
  80444e:	48 bf 8e 56 80 00 00 	movabs $0x80568e,%rdi
  804455:	00 00 00 
  804458:	b8 00 00 00 00       	mov    $0x0,%eax
  80445d:	49 b8 5b 07 80 00 00 	movabs $0x80075b,%r8
  804464:	00 00 00 
  804467:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80446a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80446d:	48 63 d0             	movslq %eax,%rdx
  804470:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804474:	48 89 c6             	mov    %rax,%rsi
  804477:	48 bf 0c d0 80 00 00 	movabs $0x80d00c,%rdi
  80447e:	00 00 00 
  804481:	48 b8 6d 18 80 00 00 	movabs $0x80186d,%rax
  804488:	00 00 00 
  80448b:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  80448d:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  804494:	00 00 00 
  804497:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80449a:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  80449d:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8044a4:	00 00 00 
  8044a7:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8044aa:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8044ad:	bf 08 00 00 00       	mov    $0x8,%edi
  8044b2:	48 b8 c7 40 80 00 00 	movabs $0x8040c7,%rax
  8044b9:	00 00 00 
  8044bc:	ff d0                	callq  *%rax
}
  8044be:	c9                   	leaveq 
  8044bf:	c3                   	retq   

00000000008044c0 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8044c0:	55                   	push   %rbp
  8044c1:	48 89 e5             	mov    %rsp,%rbp
  8044c4:	48 83 ec 10          	sub    $0x10,%rsp
  8044c8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8044cb:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8044ce:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8044d1:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8044d8:	00 00 00 
  8044db:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8044de:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8044e0:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8044e7:	00 00 00 
  8044ea:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8044ed:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8044f0:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8044f7:	00 00 00 
  8044fa:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8044fd:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  804500:	bf 09 00 00 00       	mov    $0x9,%edi
  804505:	48 b8 c7 40 80 00 00 	movabs $0x8040c7,%rax
  80450c:	00 00 00 
  80450f:	ff d0                	callq  *%rax
}
  804511:	c9                   	leaveq 
  804512:	c3                   	retq   

0000000000804513 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  804513:	55                   	push   %rbp
  804514:	48 89 e5             	mov    %rsp,%rbp
  804517:	53                   	push   %rbx
  804518:	48 83 ec 38          	sub    $0x38,%rsp
  80451c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  804520:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  804524:	48 89 c7             	mov    %rax,%rdi
  804527:	48 b8 fd 21 80 00 00 	movabs $0x8021fd,%rax
  80452e:	00 00 00 
  804531:	ff d0                	callq  *%rax
  804533:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804536:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80453a:	0f 88 bf 01 00 00    	js     8046ff <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804540:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804544:	ba 07 04 00 00       	mov    $0x407,%edx
  804549:	48 89 c6             	mov    %rax,%rsi
  80454c:	bf 00 00 00 00       	mov    $0x0,%edi
  804551:	48 b8 78 1e 80 00 00 	movabs $0x801e78,%rax
  804558:	00 00 00 
  80455b:	ff d0                	callq  *%rax
  80455d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804560:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804564:	0f 88 95 01 00 00    	js     8046ff <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80456a:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80456e:	48 89 c7             	mov    %rax,%rdi
  804571:	48 b8 fd 21 80 00 00 	movabs $0x8021fd,%rax
  804578:	00 00 00 
  80457b:	ff d0                	callq  *%rax
  80457d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804580:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804584:	0f 88 5d 01 00 00    	js     8046e7 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80458a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80458e:	ba 07 04 00 00       	mov    $0x407,%edx
  804593:	48 89 c6             	mov    %rax,%rsi
  804596:	bf 00 00 00 00       	mov    $0x0,%edi
  80459b:	48 b8 78 1e 80 00 00 	movabs $0x801e78,%rax
  8045a2:	00 00 00 
  8045a5:	ff d0                	callq  *%rax
  8045a7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8045aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8045ae:	0f 88 33 01 00 00    	js     8046e7 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8045b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045b8:	48 89 c7             	mov    %rax,%rdi
  8045bb:	48 b8 d2 21 80 00 00 	movabs $0x8021d2,%rax
  8045c2:	00 00 00 
  8045c5:	ff d0                	callq  *%rax
  8045c7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8045cb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8045cf:	ba 07 04 00 00       	mov    $0x407,%edx
  8045d4:	48 89 c6             	mov    %rax,%rsi
  8045d7:	bf 00 00 00 00       	mov    $0x0,%edi
  8045dc:	48 b8 78 1e 80 00 00 	movabs $0x801e78,%rax
  8045e3:	00 00 00 
  8045e6:	ff d0                	callq  *%rax
  8045e8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8045eb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8045ef:	79 05                	jns    8045f6 <pipe+0xe3>
		goto err2;
  8045f1:	e9 d9 00 00 00       	jmpq   8046cf <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8045f6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8045fa:	48 89 c7             	mov    %rax,%rdi
  8045fd:	48 b8 d2 21 80 00 00 	movabs $0x8021d2,%rax
  804604:	00 00 00 
  804607:	ff d0                	callq  *%rax
  804609:	48 89 c2             	mov    %rax,%rdx
  80460c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804610:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  804616:	48 89 d1             	mov    %rdx,%rcx
  804619:	ba 00 00 00 00       	mov    $0x0,%edx
  80461e:	48 89 c6             	mov    %rax,%rsi
  804621:	bf 00 00 00 00       	mov    $0x0,%edi
  804626:	48 b8 c8 1e 80 00 00 	movabs $0x801ec8,%rax
  80462d:	00 00 00 
  804630:	ff d0                	callq  *%rax
  804632:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804635:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804639:	79 1b                	jns    804656 <pipe+0x143>
		goto err3;
  80463b:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80463c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804640:	48 89 c6             	mov    %rax,%rsi
  804643:	bf 00 00 00 00       	mov    $0x0,%edi
  804648:	48 b8 23 1f 80 00 00 	movabs $0x801f23,%rax
  80464f:	00 00 00 
  804652:	ff d0                	callq  *%rax
  804654:	eb 79                	jmp    8046cf <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  804656:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80465a:	48 ba 80 88 80 00 00 	movabs $0x808880,%rdx
  804661:	00 00 00 
  804664:	8b 12                	mov    (%rdx),%edx
  804666:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  804668:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80466c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  804673:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804677:	48 ba 80 88 80 00 00 	movabs $0x808880,%rdx
  80467e:	00 00 00 
  804681:	8b 12                	mov    (%rdx),%edx
  804683:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  804685:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804689:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  804690:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804694:	48 89 c7             	mov    %rax,%rdi
  804697:	48 b8 af 21 80 00 00 	movabs $0x8021af,%rax
  80469e:	00 00 00 
  8046a1:	ff d0                	callq  *%rax
  8046a3:	89 c2                	mov    %eax,%edx
  8046a5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8046a9:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8046ab:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8046af:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8046b3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8046b7:	48 89 c7             	mov    %rax,%rdi
  8046ba:	48 b8 af 21 80 00 00 	movabs $0x8021af,%rax
  8046c1:	00 00 00 
  8046c4:	ff d0                	callq  *%rax
  8046c6:	89 03                	mov    %eax,(%rbx)
	return 0;
  8046c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8046cd:	eb 33                	jmp    804702 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8046cf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8046d3:	48 89 c6             	mov    %rax,%rsi
  8046d6:	bf 00 00 00 00       	mov    $0x0,%edi
  8046db:	48 b8 23 1f 80 00 00 	movabs $0x801f23,%rax
  8046e2:	00 00 00 
  8046e5:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8046e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046eb:	48 89 c6             	mov    %rax,%rsi
  8046ee:	bf 00 00 00 00       	mov    $0x0,%edi
  8046f3:	48 b8 23 1f 80 00 00 	movabs $0x801f23,%rax
  8046fa:	00 00 00 
  8046fd:	ff d0                	callq  *%rax
err:
	return r;
  8046ff:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804702:	48 83 c4 38          	add    $0x38,%rsp
  804706:	5b                   	pop    %rbx
  804707:	5d                   	pop    %rbp
  804708:	c3                   	retq   

0000000000804709 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  804709:	55                   	push   %rbp
  80470a:	48 89 e5             	mov    %rsp,%rbp
  80470d:	53                   	push   %rbx
  80470e:	48 83 ec 28          	sub    $0x28,%rsp
  804712:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804716:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80471a:	48 b8 90 a7 80 00 00 	movabs $0x80a790,%rax
  804721:	00 00 00 
  804724:	48 8b 00             	mov    (%rax),%rax
  804727:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80472d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  804730:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804734:	48 89 c7             	mov    %rax,%rdi
  804737:	48 b8 63 4d 80 00 00 	movabs $0x804d63,%rax
  80473e:	00 00 00 
  804741:	ff d0                	callq  *%rax
  804743:	89 c3                	mov    %eax,%ebx
  804745:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804749:	48 89 c7             	mov    %rax,%rdi
  80474c:	48 b8 63 4d 80 00 00 	movabs $0x804d63,%rax
  804753:	00 00 00 
  804756:	ff d0                	callq  *%rax
  804758:	39 c3                	cmp    %eax,%ebx
  80475a:	0f 94 c0             	sete   %al
  80475d:	0f b6 c0             	movzbl %al,%eax
  804760:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  804763:	48 b8 90 a7 80 00 00 	movabs $0x80a790,%rax
  80476a:	00 00 00 
  80476d:	48 8b 00             	mov    (%rax),%rax
  804770:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804776:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  804779:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80477c:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80477f:	75 05                	jne    804786 <_pipeisclosed+0x7d>
			return ret;
  804781:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804784:	eb 4f                	jmp    8047d5 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  804786:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804789:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80478c:	74 42                	je     8047d0 <_pipeisclosed+0xc7>
  80478e:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  804792:	75 3c                	jne    8047d0 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804794:	48 b8 90 a7 80 00 00 	movabs $0x80a790,%rax
  80479b:	00 00 00 
  80479e:	48 8b 00             	mov    (%rax),%rax
  8047a1:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8047a7:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8047aa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8047ad:	89 c6                	mov    %eax,%esi
  8047af:	48 bf ab 56 80 00 00 	movabs $0x8056ab,%rdi
  8047b6:	00 00 00 
  8047b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8047be:	49 b8 94 09 80 00 00 	movabs $0x800994,%r8
  8047c5:	00 00 00 
  8047c8:	41 ff d0             	callq  *%r8
	}
  8047cb:	e9 4a ff ff ff       	jmpq   80471a <_pipeisclosed+0x11>
  8047d0:	e9 45 ff ff ff       	jmpq   80471a <_pipeisclosed+0x11>
}
  8047d5:	48 83 c4 28          	add    $0x28,%rsp
  8047d9:	5b                   	pop    %rbx
  8047da:	5d                   	pop    %rbp
  8047db:	c3                   	retq   

00000000008047dc <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8047dc:	55                   	push   %rbp
  8047dd:	48 89 e5             	mov    %rsp,%rbp
  8047e0:	48 83 ec 30          	sub    $0x30,%rsp
  8047e4:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8047e7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8047eb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8047ee:	48 89 d6             	mov    %rdx,%rsi
  8047f1:	89 c7                	mov    %eax,%edi
  8047f3:	48 b8 95 22 80 00 00 	movabs $0x802295,%rax
  8047fa:	00 00 00 
  8047fd:	ff d0                	callq  *%rax
  8047ff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804802:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804806:	79 05                	jns    80480d <pipeisclosed+0x31>
		return r;
  804808:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80480b:	eb 31                	jmp    80483e <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80480d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804811:	48 89 c7             	mov    %rax,%rdi
  804814:	48 b8 d2 21 80 00 00 	movabs $0x8021d2,%rax
  80481b:	00 00 00 
  80481e:	ff d0                	callq  *%rax
  804820:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804824:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804828:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80482c:	48 89 d6             	mov    %rdx,%rsi
  80482f:	48 89 c7             	mov    %rax,%rdi
  804832:	48 b8 09 47 80 00 00 	movabs $0x804709,%rax
  804839:	00 00 00 
  80483c:	ff d0                	callq  *%rax
}
  80483e:	c9                   	leaveq 
  80483f:	c3                   	retq   

0000000000804840 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804840:	55                   	push   %rbp
  804841:	48 89 e5             	mov    %rsp,%rbp
  804844:	48 83 ec 40          	sub    $0x40,%rsp
  804848:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80484c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804850:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804854:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804858:	48 89 c7             	mov    %rax,%rdi
  80485b:	48 b8 d2 21 80 00 00 	movabs $0x8021d2,%rax
  804862:	00 00 00 
  804865:	ff d0                	callq  *%rax
  804867:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80486b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80486f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804873:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80487a:	00 
  80487b:	e9 92 00 00 00       	jmpq   804912 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  804880:	eb 41                	jmp    8048c3 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804882:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804887:	74 09                	je     804892 <devpipe_read+0x52>
				return i;
  804889:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80488d:	e9 92 00 00 00       	jmpq   804924 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804892:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804896:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80489a:	48 89 d6             	mov    %rdx,%rsi
  80489d:	48 89 c7             	mov    %rax,%rdi
  8048a0:	48 b8 09 47 80 00 00 	movabs $0x804709,%rax
  8048a7:	00 00 00 
  8048aa:	ff d0                	callq  *%rax
  8048ac:	85 c0                	test   %eax,%eax
  8048ae:	74 07                	je     8048b7 <devpipe_read+0x77>
				return 0;
  8048b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8048b5:	eb 6d                	jmp    804924 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8048b7:	48 b8 3a 1e 80 00 00 	movabs $0x801e3a,%rax
  8048be:	00 00 00 
  8048c1:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8048c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8048c7:	8b 10                	mov    (%rax),%edx
  8048c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8048cd:	8b 40 04             	mov    0x4(%rax),%eax
  8048d0:	39 c2                	cmp    %eax,%edx
  8048d2:	74 ae                	je     804882 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8048d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048d8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8048dc:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8048e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8048e4:	8b 00                	mov    (%rax),%eax
  8048e6:	99                   	cltd   
  8048e7:	c1 ea 1b             	shr    $0x1b,%edx
  8048ea:	01 d0                	add    %edx,%eax
  8048ec:	83 e0 1f             	and    $0x1f,%eax
  8048ef:	29 d0                	sub    %edx,%eax
  8048f1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8048f5:	48 98                	cltq   
  8048f7:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8048fc:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8048fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804902:	8b 00                	mov    (%rax),%eax
  804904:	8d 50 01             	lea    0x1(%rax),%edx
  804907:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80490b:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80490d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804912:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804916:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80491a:	0f 82 60 ff ff ff    	jb     804880 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804920:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804924:	c9                   	leaveq 
  804925:	c3                   	retq   

0000000000804926 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804926:	55                   	push   %rbp
  804927:	48 89 e5             	mov    %rsp,%rbp
  80492a:	48 83 ec 40          	sub    $0x40,%rsp
  80492e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804932:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804936:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80493a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80493e:	48 89 c7             	mov    %rax,%rdi
  804941:	48 b8 d2 21 80 00 00 	movabs $0x8021d2,%rax
  804948:	00 00 00 
  80494b:	ff d0                	callq  *%rax
  80494d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804951:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804955:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804959:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804960:	00 
  804961:	e9 8e 00 00 00       	jmpq   8049f4 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804966:	eb 31                	jmp    804999 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804968:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80496c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804970:	48 89 d6             	mov    %rdx,%rsi
  804973:	48 89 c7             	mov    %rax,%rdi
  804976:	48 b8 09 47 80 00 00 	movabs $0x804709,%rax
  80497d:	00 00 00 
  804980:	ff d0                	callq  *%rax
  804982:	85 c0                	test   %eax,%eax
  804984:	74 07                	je     80498d <devpipe_write+0x67>
				return 0;
  804986:	b8 00 00 00 00       	mov    $0x0,%eax
  80498b:	eb 79                	jmp    804a06 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80498d:	48 b8 3a 1e 80 00 00 	movabs $0x801e3a,%rax
  804994:	00 00 00 
  804997:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804999:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80499d:	8b 40 04             	mov    0x4(%rax),%eax
  8049a0:	48 63 d0             	movslq %eax,%rdx
  8049a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8049a7:	8b 00                	mov    (%rax),%eax
  8049a9:	48 98                	cltq   
  8049ab:	48 83 c0 20          	add    $0x20,%rax
  8049af:	48 39 c2             	cmp    %rax,%rdx
  8049b2:	73 b4                	jae    804968 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8049b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8049b8:	8b 40 04             	mov    0x4(%rax),%eax
  8049bb:	99                   	cltd   
  8049bc:	c1 ea 1b             	shr    $0x1b,%edx
  8049bf:	01 d0                	add    %edx,%eax
  8049c1:	83 e0 1f             	and    $0x1f,%eax
  8049c4:	29 d0                	sub    %edx,%eax
  8049c6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8049ca:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8049ce:	48 01 ca             	add    %rcx,%rdx
  8049d1:	0f b6 0a             	movzbl (%rdx),%ecx
  8049d4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8049d8:	48 98                	cltq   
  8049da:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8049de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8049e2:	8b 40 04             	mov    0x4(%rax),%eax
  8049e5:	8d 50 01             	lea    0x1(%rax),%edx
  8049e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8049ec:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8049ef:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8049f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8049f8:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8049fc:	0f 82 64 ff ff ff    	jb     804966 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804a02:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804a06:	c9                   	leaveq 
  804a07:	c3                   	retq   

0000000000804a08 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804a08:	55                   	push   %rbp
  804a09:	48 89 e5             	mov    %rsp,%rbp
  804a0c:	48 83 ec 20          	sub    $0x20,%rsp
  804a10:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804a14:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804a18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804a1c:	48 89 c7             	mov    %rax,%rdi
  804a1f:	48 b8 d2 21 80 00 00 	movabs $0x8021d2,%rax
  804a26:	00 00 00 
  804a29:	ff d0                	callq  *%rax
  804a2b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804a2f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804a33:	48 be be 56 80 00 00 	movabs $0x8056be,%rsi
  804a3a:	00 00 00 
  804a3d:	48 89 c7             	mov    %rax,%rdi
  804a40:	48 b8 49 15 80 00 00 	movabs $0x801549,%rax
  804a47:	00 00 00 
  804a4a:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804a4c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804a50:	8b 50 04             	mov    0x4(%rax),%edx
  804a53:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804a57:	8b 00                	mov    (%rax),%eax
  804a59:	29 c2                	sub    %eax,%edx
  804a5b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804a5f:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804a65:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804a69:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804a70:	00 00 00 
	stat->st_dev = &devpipe;
  804a73:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804a77:	48 b9 80 88 80 00 00 	movabs $0x808880,%rcx
  804a7e:	00 00 00 
  804a81:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804a88:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804a8d:	c9                   	leaveq 
  804a8e:	c3                   	retq   

0000000000804a8f <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804a8f:	55                   	push   %rbp
  804a90:	48 89 e5             	mov    %rsp,%rbp
  804a93:	48 83 ec 10          	sub    $0x10,%rsp
  804a97:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  804a9b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804a9f:	48 89 c6             	mov    %rax,%rsi
  804aa2:	bf 00 00 00 00       	mov    $0x0,%edi
  804aa7:	48 b8 23 1f 80 00 00 	movabs $0x801f23,%rax
  804aae:	00 00 00 
  804ab1:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  804ab3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804ab7:	48 89 c7             	mov    %rax,%rdi
  804aba:	48 b8 d2 21 80 00 00 	movabs $0x8021d2,%rax
  804ac1:	00 00 00 
  804ac4:	ff d0                	callq  *%rax
  804ac6:	48 89 c6             	mov    %rax,%rsi
  804ac9:	bf 00 00 00 00       	mov    $0x0,%edi
  804ace:	48 b8 23 1f 80 00 00 	movabs $0x801f23,%rax
  804ad5:	00 00 00 
  804ad8:	ff d0                	callq  *%rax
}
  804ada:	c9                   	leaveq 
  804adb:	c3                   	retq   

0000000000804adc <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  804adc:	55                   	push   %rbp
  804add:	48 89 e5             	mov    %rsp,%rbp
  804ae0:	48 83 ec 20          	sub    $0x20,%rsp
  804ae4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  804ae7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804aeb:	75 35                	jne    804b22 <wait+0x46>
  804aed:	48 b9 c5 56 80 00 00 	movabs $0x8056c5,%rcx
  804af4:	00 00 00 
  804af7:	48 ba d0 56 80 00 00 	movabs $0x8056d0,%rdx
  804afe:	00 00 00 
  804b01:	be 09 00 00 00       	mov    $0x9,%esi
  804b06:	48 bf e5 56 80 00 00 	movabs $0x8056e5,%rdi
  804b0d:	00 00 00 
  804b10:	b8 00 00 00 00       	mov    $0x0,%eax
  804b15:	49 b8 5b 07 80 00 00 	movabs $0x80075b,%r8
  804b1c:	00 00 00 
  804b1f:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  804b22:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804b25:	25 ff 03 00 00       	and    $0x3ff,%eax
  804b2a:	48 63 d0             	movslq %eax,%rdx
  804b2d:	48 89 d0             	mov    %rdx,%rax
  804b30:	48 c1 e0 03          	shl    $0x3,%rax
  804b34:	48 01 d0             	add    %rdx,%rax
  804b37:	48 c1 e0 05          	shl    $0x5,%rax
  804b3b:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804b42:	00 00 00 
  804b45:	48 01 d0             	add    %rdx,%rax
  804b48:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE){
  804b4c:	eb 0c                	jmp    804b5a <wait+0x7e>
	//cprintf("envid is [%d]",envid);
		sys_yield();
  804b4e:	48 b8 3a 1e 80 00 00 	movabs $0x801e3a,%rax
  804b55:	00 00 00 
  804b58:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE){
  804b5a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b5e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804b64:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804b67:	75 0e                	jne    804b77 <wait+0x9b>
  804b69:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b6d:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  804b73:	85 c0                	test   %eax,%eax
  804b75:	75 d7                	jne    804b4e <wait+0x72>
	//cprintf("envid is [%d]",envid);
		sys_yield();
	}
}
  804b77:	c9                   	leaveq 
  804b78:	c3                   	retq   

0000000000804b79 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804b79:	55                   	push   %rbp
  804b7a:	48 89 e5             	mov    %rsp,%rbp
  804b7d:	48 83 ec 30          	sub    $0x30,%rsp
  804b81:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804b85:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804b89:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  804b8d:	48 b8 90 a7 80 00 00 	movabs $0x80a790,%rax
  804b94:	00 00 00 
  804b97:	48 8b 00             	mov    (%rax),%rax
  804b9a:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  804ba0:	85 c0                	test   %eax,%eax
  804ba2:	75 3c                	jne    804be0 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  804ba4:	48 b8 fc 1d 80 00 00 	movabs $0x801dfc,%rax
  804bab:	00 00 00 
  804bae:	ff d0                	callq  *%rax
  804bb0:	25 ff 03 00 00       	and    $0x3ff,%eax
  804bb5:	48 63 d0             	movslq %eax,%rdx
  804bb8:	48 89 d0             	mov    %rdx,%rax
  804bbb:	48 c1 e0 03          	shl    $0x3,%rax
  804bbf:	48 01 d0             	add    %rdx,%rax
  804bc2:	48 c1 e0 05          	shl    $0x5,%rax
  804bc6:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804bcd:	00 00 00 
  804bd0:	48 01 c2             	add    %rax,%rdx
  804bd3:	48 b8 90 a7 80 00 00 	movabs $0x80a790,%rax
  804bda:	00 00 00 
  804bdd:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  804be0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804be5:	75 0e                	jne    804bf5 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  804be7:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804bee:	00 00 00 
  804bf1:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  804bf5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804bf9:	48 89 c7             	mov    %rax,%rdi
  804bfc:	48 b8 a1 20 80 00 00 	movabs $0x8020a1,%rax
  804c03:	00 00 00 
  804c06:	ff d0                	callq  *%rax
  804c08:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  804c0b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804c0f:	79 19                	jns    804c2a <ipc_recv+0xb1>
		*from_env_store = 0;
  804c11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804c15:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  804c1b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804c1f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  804c25:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c28:	eb 53                	jmp    804c7d <ipc_recv+0x104>
	}
	if(from_env_store)
  804c2a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804c2f:	74 19                	je     804c4a <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  804c31:	48 b8 90 a7 80 00 00 	movabs $0x80a790,%rax
  804c38:	00 00 00 
  804c3b:	48 8b 00             	mov    (%rax),%rax
  804c3e:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804c44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804c48:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  804c4a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804c4f:	74 19                	je     804c6a <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  804c51:	48 b8 90 a7 80 00 00 	movabs $0x80a790,%rax
  804c58:	00 00 00 
  804c5b:	48 8b 00             	mov    (%rax),%rax
  804c5e:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804c64:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804c68:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  804c6a:	48 b8 90 a7 80 00 00 	movabs $0x80a790,%rax
  804c71:	00 00 00 
  804c74:	48 8b 00             	mov    (%rax),%rax
  804c77:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  804c7d:	c9                   	leaveq 
  804c7e:	c3                   	retq   

0000000000804c7f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804c7f:	55                   	push   %rbp
  804c80:	48 89 e5             	mov    %rsp,%rbp
  804c83:	48 83 ec 30          	sub    $0x30,%rsp
  804c87:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804c8a:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804c8d:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804c91:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  804c94:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804c99:	75 0e                	jne    804ca9 <ipc_send+0x2a>
		pg = (void*)UTOP;
  804c9b:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804ca2:	00 00 00 
  804ca5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  804ca9:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804cac:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804caf:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804cb3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804cb6:	89 c7                	mov    %eax,%edi
  804cb8:	48 b8 4c 20 80 00 00 	movabs $0x80204c,%rax
  804cbf:	00 00 00 
  804cc2:	ff d0                	callq  *%rax
  804cc4:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  804cc7:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804ccb:	75 0c                	jne    804cd9 <ipc_send+0x5a>
			sys_yield();
  804ccd:	48 b8 3a 1e 80 00 00 	movabs $0x801e3a,%rax
  804cd4:	00 00 00 
  804cd7:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  804cd9:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804cdd:	74 ca                	je     804ca9 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  804cdf:	c9                   	leaveq 
  804ce0:	c3                   	retq   

0000000000804ce1 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804ce1:	55                   	push   %rbp
  804ce2:	48 89 e5             	mov    %rsp,%rbp
  804ce5:	48 83 ec 14          	sub    $0x14,%rsp
  804ce9:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804cec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804cf3:	eb 5e                	jmp    804d53 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  804cf5:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804cfc:	00 00 00 
  804cff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804d02:	48 63 d0             	movslq %eax,%rdx
  804d05:	48 89 d0             	mov    %rdx,%rax
  804d08:	48 c1 e0 03          	shl    $0x3,%rax
  804d0c:	48 01 d0             	add    %rdx,%rax
  804d0f:	48 c1 e0 05          	shl    $0x5,%rax
  804d13:	48 01 c8             	add    %rcx,%rax
  804d16:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804d1c:	8b 00                	mov    (%rax),%eax
  804d1e:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804d21:	75 2c                	jne    804d4f <ipc_find_env+0x6e>
			return envs[i].env_id;
  804d23:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804d2a:	00 00 00 
  804d2d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804d30:	48 63 d0             	movslq %eax,%rdx
  804d33:	48 89 d0             	mov    %rdx,%rax
  804d36:	48 c1 e0 03          	shl    $0x3,%rax
  804d3a:	48 01 d0             	add    %rdx,%rax
  804d3d:	48 c1 e0 05          	shl    $0x5,%rax
  804d41:	48 01 c8             	add    %rcx,%rax
  804d44:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804d4a:	8b 40 08             	mov    0x8(%rax),%eax
  804d4d:	eb 12                	jmp    804d61 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804d4f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804d53:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804d5a:	7e 99                	jle    804cf5 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804d5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804d61:	c9                   	leaveq 
  804d62:	c3                   	retq   

0000000000804d63 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804d63:	55                   	push   %rbp
  804d64:	48 89 e5             	mov    %rsp,%rbp
  804d67:	48 83 ec 18          	sub    $0x18,%rsp
  804d6b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804d6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804d73:	48 c1 e8 15          	shr    $0x15,%rax
  804d77:	48 89 c2             	mov    %rax,%rdx
  804d7a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804d81:	01 00 00 
  804d84:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804d88:	83 e0 01             	and    $0x1,%eax
  804d8b:	48 85 c0             	test   %rax,%rax
  804d8e:	75 07                	jne    804d97 <pageref+0x34>
		return 0;
  804d90:	b8 00 00 00 00       	mov    $0x0,%eax
  804d95:	eb 53                	jmp    804dea <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804d97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804d9b:	48 c1 e8 0c          	shr    $0xc,%rax
  804d9f:	48 89 c2             	mov    %rax,%rdx
  804da2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804da9:	01 00 00 
  804dac:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804db0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804db4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804db8:	83 e0 01             	and    $0x1,%eax
  804dbb:	48 85 c0             	test   %rax,%rax
  804dbe:	75 07                	jne    804dc7 <pageref+0x64>
		return 0;
  804dc0:	b8 00 00 00 00       	mov    $0x0,%eax
  804dc5:	eb 23                	jmp    804dea <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804dc7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804dcb:	48 c1 e8 0c          	shr    $0xc,%rax
  804dcf:	48 89 c2             	mov    %rax,%rdx
  804dd2:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804dd9:	00 00 00 
  804ddc:	48 c1 e2 04          	shl    $0x4,%rdx
  804de0:	48 01 d0             	add    %rdx,%rax
  804de3:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804de7:	0f b7 c0             	movzwl %ax,%eax
}
  804dea:	c9                   	leaveq 
  804deb:	c3                   	retq   
