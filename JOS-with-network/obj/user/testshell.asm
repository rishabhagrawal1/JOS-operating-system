
obj/user/testshell.debug:     file format elf64-x86-64


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
  80003c:	e8 f5 07 00 00       	callq  800836 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

void wrong(int, int, int);

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 40          	sub    $0x40,%rsp
  80004b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80004e:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	char c1, c2;
	int r, rfd, wfd, kfd, n1, n2, off, nloff;
	int pfds[2];

	close(0);
  800052:	bf 00 00 00 00       	mov    $0x0,%edi
  800057:	48 b8 c8 2c 80 00 00 	movabs $0x802cc8,%rax
  80005e:	00 00 00 
  800061:	ff d0                	callq  *%rax
	close(1);
  800063:	bf 01 00 00 00       	mov    $0x1,%edi
  800068:	48 b8 c8 2c 80 00 00 	movabs $0x802cc8,%rax
  80006f:	00 00 00 
  800072:	ff d0                	callq  *%rax
	opencons();
  800074:	48 b8 44 06 80 00 00 	movabs $0x800644,%rax
  80007b:	00 00 00 
  80007e:	ff d0                	callq  *%rax
	opencons();
  800080:	48 b8 44 06 80 00 00 	movabs $0x800644,%rax
  800087:	00 00 00 
  80008a:	ff d0                	callq  *%rax

	if ((rfd = open("testshell.sh", O_RDONLY)) < 0)
  80008c:	be 00 00 00 00       	mov    $0x0,%esi
  800091:	48 bf 60 57 80 00 00 	movabs $0x805760,%rdi
  800098:	00 00 00 
  80009b:	48 b8 c0 33 80 00 00 	movabs $0x8033c0,%rax
  8000a2:	00 00 00 
  8000a5:	ff d0                	callq  *%rax
  8000a7:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8000aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8000ae:	79 30                	jns    8000e0 <umain+0x9d>
		panic("open testshell.sh: %e", rfd);
  8000b0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8000b3:	89 c1                	mov    %eax,%ecx
  8000b5:	48 ba 6d 57 80 00 00 	movabs $0x80576d,%rdx
  8000bc:	00 00 00 
  8000bf:	be 13 00 00 00       	mov    $0x13,%esi
  8000c4:	48 bf 83 57 80 00 00 	movabs $0x805783,%rdi
  8000cb:	00 00 00 
  8000ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d3:	49 b8 e4 08 80 00 00 	movabs $0x8008e4,%r8
  8000da:	00 00 00 
  8000dd:	41 ff d0             	callq  *%r8
	if ((wfd = pipe(pfds)) < 0)
  8000e0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8000e4:	48 89 c7             	mov    %rax,%rdi
  8000e7:	48 b8 36 4d 80 00 00 	movabs $0x804d36,%rax
  8000ee:	00 00 00 
  8000f1:	ff d0                	callq  *%rax
  8000f3:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8000f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8000fa:	79 30                	jns    80012c <umain+0xe9>
		panic("pipe: %e", wfd);
  8000fc:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8000ff:	89 c1                	mov    %eax,%ecx
  800101:	48 ba 94 57 80 00 00 	movabs $0x805794,%rdx
  800108:	00 00 00 
  80010b:	be 15 00 00 00       	mov    $0x15,%esi
  800110:	48 bf 83 57 80 00 00 	movabs $0x805783,%rdi
  800117:	00 00 00 
  80011a:	b8 00 00 00 00       	mov    $0x0,%eax
  80011f:	49 b8 e4 08 80 00 00 	movabs $0x8008e4,%r8
  800126:	00 00 00 
  800129:	41 ff d0             	callq  *%r8
	wfd = pfds[1];
  80012c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80012f:	89 45 f0             	mov    %eax,-0x10(%rbp)

	cprintf("running sh -x < testshell.sh | cat\n");
  800132:	48 bf a0 57 80 00 00 	movabs $0x8057a0,%rdi
  800139:	00 00 00 
  80013c:	b8 00 00 00 00       	mov    $0x0,%eax
  800141:	48 ba 1d 0b 80 00 00 	movabs $0x800b1d,%rdx
  800148:	00 00 00 
  80014b:	ff d2                	callq  *%rdx
	if ((r = fork()) < 0)
  80014d:	48 b8 21 27 80 00 00 	movabs $0x802721,%rax
  800154:	00 00 00 
  800157:	ff d0                	callq  *%rax
  800159:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80015c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800160:	79 30                	jns    800192 <umain+0x14f>
		panic("fork: %e", r);
  800162:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800165:	89 c1                	mov    %eax,%ecx
  800167:	48 ba c4 57 80 00 00 	movabs $0x8057c4,%rdx
  80016e:	00 00 00 
  800171:	be 1a 00 00 00       	mov    $0x1a,%esi
  800176:	48 bf 83 57 80 00 00 	movabs $0x805783,%rdi
  80017d:	00 00 00 
  800180:	b8 00 00 00 00       	mov    $0x0,%eax
  800185:	49 b8 e4 08 80 00 00 	movabs $0x8008e4,%r8
  80018c:	00 00 00 
  80018f:	41 ff d0             	callq  *%r8
	if (r == 0) {
  800192:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800196:	0f 85 fb 00 00 00    	jne    800297 <umain+0x254>
		dup(rfd, 0);
  80019c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80019f:	be 00 00 00 00       	mov    $0x0,%esi
  8001a4:	89 c7                	mov    %eax,%edi
  8001a6:	48 b8 41 2d 80 00 00 	movabs $0x802d41,%rax
  8001ad:	00 00 00 
  8001b0:	ff d0                	callq  *%rax
		dup(wfd, 1);
  8001b2:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001b5:	be 01 00 00 00       	mov    $0x1,%esi
  8001ba:	89 c7                	mov    %eax,%edi
  8001bc:	48 b8 41 2d 80 00 00 	movabs $0x802d41,%rax
  8001c3:	00 00 00 
  8001c6:	ff d0                	callq  *%rax
		close(rfd);
  8001c8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8001cb:	89 c7                	mov    %eax,%edi
  8001cd:	48 b8 c8 2c 80 00 00 	movabs $0x802cc8,%rax
  8001d4:	00 00 00 
  8001d7:	ff d0                	callq  *%rax
		close(wfd);
  8001d9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001dc:	89 c7                	mov    %eax,%edi
  8001de:	48 b8 c8 2c 80 00 00 	movabs $0x802cc8,%rax
  8001e5:	00 00 00 
  8001e8:	ff d0                	callq  *%rax
		if ((r = spawnl("/bin/sh", "sh", "-x", 0)) < 0)
  8001ea:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001ef:	48 ba cd 57 80 00 00 	movabs $0x8057cd,%rdx
  8001f6:	00 00 00 
  8001f9:	48 be d0 57 80 00 00 	movabs $0x8057d0,%rsi
  800200:	00 00 00 
  800203:	48 bf d3 57 80 00 00 	movabs $0x8057d3,%rdi
  80020a:	00 00 00 
  80020d:	b8 00 00 00 00       	mov    $0x0,%eax
  800212:	49 b8 31 3d 80 00 00 	movabs $0x803d31,%r8
  800219:	00 00 00 
  80021c:	41 ff d0             	callq  *%r8
  80021f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800222:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800226:	79 30                	jns    800258 <umain+0x215>
			panic("spawn: %e", r);
  800228:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80022b:	89 c1                	mov    %eax,%ecx
  80022d:	48 ba db 57 80 00 00 	movabs $0x8057db,%rdx
  800234:	00 00 00 
  800237:	be 21 00 00 00       	mov    $0x21,%esi
  80023c:	48 bf 83 57 80 00 00 	movabs $0x805783,%rdi
  800243:	00 00 00 
  800246:	b8 00 00 00 00       	mov    $0x0,%eax
  80024b:	49 b8 e4 08 80 00 00 	movabs $0x8008e4,%r8
  800252:	00 00 00 
  800255:	41 ff d0             	callq  *%r8
		close(0);
  800258:	bf 00 00 00 00       	mov    $0x0,%edi
  80025d:	48 b8 c8 2c 80 00 00 	movabs $0x802cc8,%rax
  800264:	00 00 00 
  800267:	ff d0                	callq  *%rax
		close(1);
  800269:	bf 01 00 00 00       	mov    $0x1,%edi
  80026e:	48 b8 c8 2c 80 00 00 	movabs $0x802cc8,%rax
  800275:	00 00 00 
  800278:	ff d0                	callq  *%rax
		wait(r);
  80027a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80027d:	89 c7                	mov    %eax,%edi
  80027f:	48 b8 ff 52 80 00 00 	movabs $0x8052ff,%rax
  800286:	00 00 00 
  800289:	ff d0                	callq  *%rax
		exit();
  80028b:	48 b8 c1 08 80 00 00 	movabs $0x8008c1,%rax
  800292:	00 00 00 
  800295:	ff d0                	callq  *%rax
	}
	close(rfd);
  800297:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80029a:	89 c7                	mov    %eax,%edi
  80029c:	48 b8 c8 2c 80 00 00 	movabs $0x802cc8,%rax
  8002a3:	00 00 00 
  8002a6:	ff d0                	callq  *%rax
	close(wfd);
  8002a8:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002ab:	89 c7                	mov    %eax,%edi
  8002ad:	48 b8 c8 2c 80 00 00 	movabs $0x802cc8,%rax
  8002b4:	00 00 00 
  8002b7:	ff d0                	callq  *%rax

	rfd = pfds[0];
  8002b9:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8002bc:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8002bf:	be 00 00 00 00       	mov    $0x0,%esi
  8002c4:	48 bf e5 57 80 00 00 	movabs $0x8057e5,%rdi
  8002cb:	00 00 00 
  8002ce:	48 b8 c0 33 80 00 00 	movabs $0x8033c0,%rax
  8002d5:	00 00 00 
  8002d8:	ff d0                	callq  *%rax
  8002da:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8002dd:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8002e1:	79 30                	jns    800313 <umain+0x2d0>
		panic("open testshell.key for reading: %e", kfd);
  8002e3:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8002e6:	89 c1                	mov    %eax,%ecx
  8002e8:	48 ba f8 57 80 00 00 	movabs $0x8057f8,%rdx
  8002ef:	00 00 00 
  8002f2:	be 2c 00 00 00       	mov    $0x2c,%esi
  8002f7:	48 bf 83 57 80 00 00 	movabs $0x805783,%rdi
  8002fe:	00 00 00 
  800301:	b8 00 00 00 00       	mov    $0x0,%eax
  800306:	49 b8 e4 08 80 00 00 	movabs $0x8008e4,%r8
  80030d:	00 00 00 
  800310:	41 ff d0             	callq  *%r8

	nloff = 0;
  800313:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	for (off=0;; off++) {
  80031a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
		n1 = read(rfd, &c1, 1);
  800321:	48 8d 4d df          	lea    -0x21(%rbp),%rcx
  800325:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800328:	ba 01 00 00 00       	mov    $0x1,%edx
  80032d:	48 89 ce             	mov    %rcx,%rsi
  800330:	89 c7                	mov    %eax,%edi
  800332:	48 b8 ea 2e 80 00 00 	movabs $0x802eea,%rax
  800339:	00 00 00 
  80033c:	ff d0                	callq  *%rax
  80033e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		n2 = read(kfd, &c2, 1);
  800341:	48 8d 4d de          	lea    -0x22(%rbp),%rcx
  800345:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800348:	ba 01 00 00 00       	mov    $0x1,%edx
  80034d:	48 89 ce             	mov    %rcx,%rsi
  800350:	89 c7                	mov    %eax,%edi
  800352:	48 b8 ea 2e 80 00 00 	movabs $0x802eea,%rax
  800359:	00 00 00 
  80035c:	ff d0                	callq  *%rax
  80035e:	89 45 e0             	mov    %eax,-0x20(%rbp)
		if (n1 < 0)
  800361:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800365:	79 30                	jns    800397 <umain+0x354>
			panic("reading testshell.out: %e", n1);
  800367:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80036a:	89 c1                	mov    %eax,%ecx
  80036c:	48 ba 1b 58 80 00 00 	movabs $0x80581b,%rdx
  800373:	00 00 00 
  800376:	be 33 00 00 00       	mov    $0x33,%esi
  80037b:	48 bf 83 57 80 00 00 	movabs $0x805783,%rdi
  800382:	00 00 00 
  800385:	b8 00 00 00 00       	mov    $0x0,%eax
  80038a:	49 b8 e4 08 80 00 00 	movabs $0x8008e4,%r8
  800391:	00 00 00 
  800394:	41 ff d0             	callq  *%r8
		if (n2 < 0)
  800397:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80039b:	79 30                	jns    8003cd <umain+0x38a>
			panic("reading testshell.key: %e", n2);
  80039d:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8003a0:	89 c1                	mov    %eax,%ecx
  8003a2:	48 ba 35 58 80 00 00 	movabs $0x805835,%rdx
  8003a9:	00 00 00 
  8003ac:	be 35 00 00 00       	mov    $0x35,%esi
  8003b1:	48 bf 83 57 80 00 00 	movabs $0x805783,%rdi
  8003b8:	00 00 00 
  8003bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c0:	49 b8 e4 08 80 00 00 	movabs $0x8008e4,%r8
  8003c7:	00 00 00 
  8003ca:	41 ff d0             	callq  *%r8
		if (n1 == 0 && n2 == 0)
  8003cd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8003d1:	75 08                	jne    8003db <umain+0x398>
  8003d3:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8003d7:	75 02                	jne    8003db <umain+0x398>
			break;
  8003d9:	eb 4b                	jmp    800426 <umain+0x3e3>
		if (n1 != 1 || n2 != 1 || c1 != c2)
  8003db:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8003df:	75 12                	jne    8003f3 <umain+0x3b0>
  8003e1:	83 7d e0 01          	cmpl   $0x1,-0x20(%rbp)
  8003e5:	75 0c                	jne    8003f3 <umain+0x3b0>
  8003e7:	0f b6 55 df          	movzbl -0x21(%rbp),%edx
  8003eb:	0f b6 45 de          	movzbl -0x22(%rbp),%eax
  8003ef:	38 c2                	cmp    %al,%dl
  8003f1:	74 19                	je     80040c <umain+0x3c9>
			wrong(rfd, kfd, nloff);
  8003f3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8003f6:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8003f9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8003fc:	89 ce                	mov    %ecx,%esi
  8003fe:	89 c7                	mov    %eax,%edi
  800400:	48 b8 44 04 80 00 00 	movabs $0x800444,%rax
  800407:	00 00 00 
  80040a:	ff d0                	callq  *%rax
		if (c1 == '\n')
  80040c:	0f b6 45 df          	movzbl -0x21(%rbp),%eax
  800410:	3c 0a                	cmp    $0xa,%al
  800412:	75 09                	jne    80041d <umain+0x3da>
			nloff = off+1;
  800414:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800417:	83 c0 01             	add    $0x1,%eax
  80041a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	rfd = pfds[0];
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
		panic("open testshell.key for reading: %e", kfd);

	nloff = 0;
	for (off=0;; off++) {
  80041d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
			break;
		if (n1 != 1 || n2 != 1 || c1 != c2)
			wrong(rfd, kfd, nloff);
		if (c1 == '\n')
			nloff = off+1;
	}
  800421:	e9 fb fe ff ff       	jmpq   800321 <umain+0x2de>
	cprintf("shell ran correctly\n");
  800426:	48 bf 4f 58 80 00 00 	movabs $0x80584f,%rdi
  80042d:	00 00 00 
  800430:	b8 00 00 00 00       	mov    $0x0,%eax
  800435:	48 ba 1d 0b 80 00 00 	movabs $0x800b1d,%rdx
  80043c:	00 00 00 
  80043f:	ff d2                	callq  *%rdx
static __inline void read_gdtr (uint64_t *gdtbase, uint16_t *gdtlimit) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  800441:	cc                   	int3   

	breakpoint();
}
  800442:	c9                   	leaveq 
  800443:	c3                   	retq   

0000000000800444 <wrong>:

void
wrong(int rfd, int kfd, int off)
{
  800444:	55                   	push   %rbp
  800445:	48 89 e5             	mov    %rsp,%rbp
  800448:	48 83 c4 80          	add    $0xffffffffffffff80,%rsp
  80044c:	89 7d 8c             	mov    %edi,-0x74(%rbp)
  80044f:	89 75 88             	mov    %esi,-0x78(%rbp)
  800452:	89 55 84             	mov    %edx,-0x7c(%rbp)
	char buf[100];
	int n;

	seek(rfd, off);
  800455:	8b 55 84             	mov    -0x7c(%rbp),%edx
  800458:	8b 45 8c             	mov    -0x74(%rbp),%eax
  80045b:	89 d6                	mov    %edx,%esi
  80045d:	89 c7                	mov    %eax,%edi
  80045f:	48 b8 08 31 80 00 00 	movabs $0x803108,%rax
  800466:	00 00 00 
  800469:	ff d0                	callq  *%rax
	seek(kfd, off);
  80046b:	8b 55 84             	mov    -0x7c(%rbp),%edx
  80046e:	8b 45 88             	mov    -0x78(%rbp),%eax
  800471:	89 d6                	mov    %edx,%esi
  800473:	89 c7                	mov    %eax,%edi
  800475:	48 b8 08 31 80 00 00 	movabs $0x803108,%rax
  80047c:	00 00 00 
  80047f:	ff d0                	callq  *%rax

	cprintf("shell produced incorrect output.\n");
  800481:	48 bf 68 58 80 00 00 	movabs $0x805868,%rdi
  800488:	00 00 00 
  80048b:	b8 00 00 00 00       	mov    $0x0,%eax
  800490:	48 ba 1d 0b 80 00 00 	movabs $0x800b1d,%rdx
  800497:	00 00 00 
  80049a:	ff d2                	callq  *%rdx
	cprintf("expected:\n===\n");
  80049c:	48 bf 8a 58 80 00 00 	movabs $0x80588a,%rdi
  8004a3:	00 00 00 
  8004a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ab:	48 ba 1d 0b 80 00 00 	movabs $0x800b1d,%rdx
  8004b2:	00 00 00 
  8004b5:	ff d2                	callq  *%rdx
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  8004b7:	eb 1c                	jmp    8004d5 <wrong+0x91>
		sys_cputs(buf, n);
  8004b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004bc:	48 63 d0             	movslq %eax,%rdx
  8004bf:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  8004c3:	48 89 d6             	mov    %rdx,%rsi
  8004c6:	48 89 c7             	mov    %rax,%rdi
  8004c9:	48 b8 b9 1e 80 00 00 	movabs $0x801eb9,%rax
  8004d0:	00 00 00 
  8004d3:	ff d0                	callq  *%rax
	seek(rfd, off);
	seek(kfd, off);

	cprintf("shell produced incorrect output.\n");
	cprintf("expected:\n===\n");
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  8004d5:	48 8d 4d 90          	lea    -0x70(%rbp),%rcx
  8004d9:	8b 45 88             	mov    -0x78(%rbp),%eax
  8004dc:	ba 63 00 00 00       	mov    $0x63,%edx
  8004e1:	48 89 ce             	mov    %rcx,%rsi
  8004e4:	89 c7                	mov    %eax,%edi
  8004e6:	48 b8 ea 2e 80 00 00 	movabs $0x802eea,%rax
  8004ed:	00 00 00 
  8004f0:	ff d0                	callq  *%rax
  8004f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8004f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004f9:	7f be                	jg     8004b9 <wrong+0x75>
		sys_cputs(buf, n);
	cprintf("===\ngot:\n===\n");
  8004fb:	48 bf 99 58 80 00 00 	movabs $0x805899,%rdi
  800502:	00 00 00 
  800505:	b8 00 00 00 00       	mov    $0x0,%eax
  80050a:	48 ba 1d 0b 80 00 00 	movabs $0x800b1d,%rdx
  800511:	00 00 00 
  800514:	ff d2                	callq  *%rdx
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  800516:	eb 1c                	jmp    800534 <wrong+0xf0>
		sys_cputs(buf, n);
  800518:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80051b:	48 63 d0             	movslq %eax,%rdx
  80051e:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  800522:	48 89 d6             	mov    %rdx,%rsi
  800525:	48 89 c7             	mov    %rax,%rdi
  800528:	48 b8 b9 1e 80 00 00 	movabs $0x801eb9,%rax
  80052f:	00 00 00 
  800532:	ff d0                	callq  *%rax
	cprintf("shell produced incorrect output.\n");
	cprintf("expected:\n===\n");
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
		sys_cputs(buf, n);
	cprintf("===\ngot:\n===\n");
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  800534:	48 8d 4d 90          	lea    -0x70(%rbp),%rcx
  800538:	8b 45 8c             	mov    -0x74(%rbp),%eax
  80053b:	ba 63 00 00 00       	mov    $0x63,%edx
  800540:	48 89 ce             	mov    %rcx,%rsi
  800543:	89 c7                	mov    %eax,%edi
  800545:	48 b8 ea 2e 80 00 00 	movabs $0x802eea,%rax
  80054c:	00 00 00 
  80054f:	ff d0                	callq  *%rax
  800551:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800554:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800558:	7f be                	jg     800518 <wrong+0xd4>
		sys_cputs(buf, n);
	cprintf("===\n");
  80055a:	48 bf a7 58 80 00 00 	movabs $0x8058a7,%rdi
  800561:	00 00 00 
  800564:	b8 00 00 00 00       	mov    $0x0,%eax
  800569:	48 ba 1d 0b 80 00 00 	movabs $0x800b1d,%rdx
  800570:	00 00 00 
  800573:	ff d2                	callq  *%rdx
	exit();
  800575:	48 b8 c1 08 80 00 00 	movabs $0x8008c1,%rax
  80057c:	00 00 00 
  80057f:	ff d0                	callq  *%rax
}
  800581:	c9                   	leaveq 
  800582:	c3                   	retq   

0000000000800583 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800583:	55                   	push   %rbp
  800584:	48 89 e5             	mov    %rsp,%rbp
  800587:	48 83 ec 20          	sub    $0x20,%rsp
  80058b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80058e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800591:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800594:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  800598:	be 01 00 00 00       	mov    $0x1,%esi
  80059d:	48 89 c7             	mov    %rax,%rdi
  8005a0:	48 b8 b9 1e 80 00 00 	movabs $0x801eb9,%rax
  8005a7:	00 00 00 
  8005aa:	ff d0                	callq  *%rax
}
  8005ac:	c9                   	leaveq 
  8005ad:	c3                   	retq   

00000000008005ae <getchar>:

int
getchar(void)
{
  8005ae:	55                   	push   %rbp
  8005af:	48 89 e5             	mov    %rsp,%rbp
  8005b2:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8005b6:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8005ba:	ba 01 00 00 00       	mov    $0x1,%edx
  8005bf:	48 89 c6             	mov    %rax,%rsi
  8005c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8005c7:	48 b8 ea 2e 80 00 00 	movabs $0x802eea,%rax
  8005ce:	00 00 00 
  8005d1:	ff d0                	callq  *%rax
  8005d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8005d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8005da:	79 05                	jns    8005e1 <getchar+0x33>
		return r;
  8005dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005df:	eb 14                	jmp    8005f5 <getchar+0x47>
	if (r < 1)
  8005e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8005e5:	7f 07                	jg     8005ee <getchar+0x40>
		return -E_EOF;
  8005e7:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8005ec:	eb 07                	jmp    8005f5 <getchar+0x47>
	return c;
  8005ee:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8005f2:	0f b6 c0             	movzbl %al,%eax
}
  8005f5:	c9                   	leaveq 
  8005f6:	c3                   	retq   

00000000008005f7 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8005f7:	55                   	push   %rbp
  8005f8:	48 89 e5             	mov    %rsp,%rbp
  8005fb:	48 83 ec 20          	sub    $0x20,%rsp
  8005ff:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800602:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800606:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800609:	48 89 d6             	mov    %rdx,%rsi
  80060c:	89 c7                	mov    %eax,%edi
  80060e:	48 b8 b8 2a 80 00 00 	movabs $0x802ab8,%rax
  800615:	00 00 00 
  800618:	ff d0                	callq  *%rax
  80061a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80061d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800621:	79 05                	jns    800628 <iscons+0x31>
		return r;
  800623:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800626:	eb 1a                	jmp    800642 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  800628:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80062c:	8b 10                	mov    (%rax),%edx
  80062e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  800635:	00 00 00 
  800638:	8b 00                	mov    (%rax),%eax
  80063a:	39 c2                	cmp    %eax,%edx
  80063c:	0f 94 c0             	sete   %al
  80063f:	0f b6 c0             	movzbl %al,%eax
}
  800642:	c9                   	leaveq 
  800643:	c3                   	retq   

0000000000800644 <opencons>:

int
opencons(void)
{
  800644:	55                   	push   %rbp
  800645:	48 89 e5             	mov    %rsp,%rbp
  800648:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80064c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800650:	48 89 c7             	mov    %rax,%rdi
  800653:	48 b8 20 2a 80 00 00 	movabs $0x802a20,%rax
  80065a:	00 00 00 
  80065d:	ff d0                	callq  *%rax
  80065f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800662:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800666:	79 05                	jns    80066d <opencons+0x29>
		return r;
  800668:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80066b:	eb 5b                	jmp    8006c8 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80066d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800671:	ba 07 04 00 00       	mov    $0x407,%edx
  800676:	48 89 c6             	mov    %rax,%rsi
  800679:	bf 00 00 00 00       	mov    $0x0,%edi
  80067e:	48 b8 01 20 80 00 00 	movabs $0x802001,%rax
  800685:	00 00 00 
  800688:	ff d0                	callq  *%rax
  80068a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80068d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800691:	79 05                	jns    800698 <opencons+0x54>
		return r;
  800693:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800696:	eb 30                	jmp    8006c8 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  800698:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80069c:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8006a3:	00 00 00 
  8006a6:	8b 12                	mov    (%rdx),%edx
  8006a8:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8006aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006ae:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8006b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006b9:	48 89 c7             	mov    %rax,%rdi
  8006bc:	48 b8 d2 29 80 00 00 	movabs $0x8029d2,%rax
  8006c3:	00 00 00 
  8006c6:	ff d0                	callq  *%rax
}
  8006c8:	c9                   	leaveq 
  8006c9:	c3                   	retq   

00000000008006ca <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8006ca:	55                   	push   %rbp
  8006cb:	48 89 e5             	mov    %rsp,%rbp
  8006ce:	48 83 ec 30          	sub    $0x30,%rsp
  8006d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006d6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8006da:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8006de:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8006e3:	75 07                	jne    8006ec <devcons_read+0x22>
		return 0;
  8006e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8006ea:	eb 4b                	jmp    800737 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8006ec:	eb 0c                	jmp    8006fa <devcons_read+0x30>
		sys_yield();
  8006ee:	48 b8 c3 1f 80 00 00 	movabs $0x801fc3,%rax
  8006f5:	00 00 00 
  8006f8:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8006fa:	48 b8 03 1f 80 00 00 	movabs $0x801f03,%rax
  800701:	00 00 00 
  800704:	ff d0                	callq  *%rax
  800706:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800709:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80070d:	74 df                	je     8006ee <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  80070f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800713:	79 05                	jns    80071a <devcons_read+0x50>
		return c;
  800715:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800718:	eb 1d                	jmp    800737 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80071a:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80071e:	75 07                	jne    800727 <devcons_read+0x5d>
		return 0;
  800720:	b8 00 00 00 00       	mov    $0x0,%eax
  800725:	eb 10                	jmp    800737 <devcons_read+0x6d>
	*(char*)vbuf = c;
  800727:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80072a:	89 c2                	mov    %eax,%edx
  80072c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800730:	88 10                	mov    %dl,(%rax)
	return 1;
  800732:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800737:	c9                   	leaveq 
  800738:	c3                   	retq   

0000000000800739 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800739:	55                   	push   %rbp
  80073a:	48 89 e5             	mov    %rsp,%rbp
  80073d:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  800744:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80074b:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  800752:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800759:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800760:	eb 76                	jmp    8007d8 <devcons_write+0x9f>
		m = n - tot;
  800762:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800769:	89 c2                	mov    %eax,%edx
  80076b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80076e:	29 c2                	sub    %eax,%edx
  800770:	89 d0                	mov    %edx,%eax
  800772:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  800775:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800778:	83 f8 7f             	cmp    $0x7f,%eax
  80077b:	76 07                	jbe    800784 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80077d:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  800784:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800787:	48 63 d0             	movslq %eax,%rdx
  80078a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80078d:	48 63 c8             	movslq %eax,%rcx
  800790:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  800797:	48 01 c1             	add    %rax,%rcx
  80079a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8007a1:	48 89 ce             	mov    %rcx,%rsi
  8007a4:	48 89 c7             	mov    %rax,%rdi
  8007a7:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  8007ae:	00 00 00 
  8007b1:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8007b3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8007b6:	48 63 d0             	movslq %eax,%rdx
  8007b9:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8007c0:	48 89 d6             	mov    %rdx,%rsi
  8007c3:	48 89 c7             	mov    %rax,%rdi
  8007c6:	48 b8 b9 1e 80 00 00 	movabs $0x801eb9,%rax
  8007cd:	00 00 00 
  8007d0:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8007d2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8007d5:	01 45 fc             	add    %eax,-0x4(%rbp)
  8007d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8007db:	48 98                	cltq   
  8007dd:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8007e4:	0f 82 78 ff ff ff    	jb     800762 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8007ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8007ed:	c9                   	leaveq 
  8007ee:	c3                   	retq   

00000000008007ef <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8007ef:	55                   	push   %rbp
  8007f0:	48 89 e5             	mov    %rsp,%rbp
  8007f3:	48 83 ec 08          	sub    $0x8,%rsp
  8007f7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8007fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800800:	c9                   	leaveq 
  800801:	c3                   	retq   

0000000000800802 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800802:	55                   	push   %rbp
  800803:	48 89 e5             	mov    %rsp,%rbp
  800806:	48 83 ec 10          	sub    $0x10,%rsp
  80080a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80080e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  800812:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800816:	48 be b1 58 80 00 00 	movabs $0x8058b1,%rsi
  80081d:	00 00 00 
  800820:	48 89 c7             	mov    %rax,%rdi
  800823:	48 b8 d2 16 80 00 00 	movabs $0x8016d2,%rax
  80082a:	00 00 00 
  80082d:	ff d0                	callq  *%rax
	return 0;
  80082f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800834:	c9                   	leaveq 
  800835:	c3                   	retq   

0000000000800836 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800836:	55                   	push   %rbp
  800837:	48 89 e5             	mov    %rsp,%rbp
  80083a:	48 83 ec 10          	sub    $0x10,%rsp
  80083e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800841:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800845:	48 b8 85 1f 80 00 00 	movabs $0x801f85,%rax
  80084c:	00 00 00 
  80084f:	ff d0                	callq  *%rax
  800851:	25 ff 03 00 00       	and    $0x3ff,%eax
  800856:	48 63 d0             	movslq %eax,%rdx
  800859:	48 89 d0             	mov    %rdx,%rax
  80085c:	48 c1 e0 03          	shl    $0x3,%rax
  800860:	48 01 d0             	add    %rdx,%rax
  800863:	48 c1 e0 05          	shl    $0x5,%rax
  800867:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80086e:	00 00 00 
  800871:	48 01 c2             	add    %rax,%rdx
  800874:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  80087b:	00 00 00 
  80087e:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800881:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800885:	7e 14                	jle    80089b <libmain+0x65>
		binaryname = argv[0];
  800887:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80088b:	48 8b 10             	mov    (%rax),%rdx
  80088e:	48 b8 38 80 80 00 00 	movabs $0x808038,%rax
  800895:	00 00 00 
  800898:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80089b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80089f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8008a2:	48 89 d6             	mov    %rdx,%rsi
  8008a5:	89 c7                	mov    %eax,%edi
  8008a7:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8008ae:	00 00 00 
  8008b1:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8008b3:	48 b8 c1 08 80 00 00 	movabs $0x8008c1,%rax
  8008ba:	00 00 00 
  8008bd:	ff d0                	callq  *%rax
}
  8008bf:	c9                   	leaveq 
  8008c0:	c3                   	retq   

00000000008008c1 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8008c1:	55                   	push   %rbp
  8008c2:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8008c5:	48 b8 13 2d 80 00 00 	movabs $0x802d13,%rax
  8008cc:	00 00 00 
  8008cf:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8008d1:	bf 00 00 00 00       	mov    $0x0,%edi
  8008d6:	48 b8 41 1f 80 00 00 	movabs $0x801f41,%rax
  8008dd:	00 00 00 
  8008e0:	ff d0                	callq  *%rax

}
  8008e2:	5d                   	pop    %rbp
  8008e3:	c3                   	retq   

00000000008008e4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8008e4:	55                   	push   %rbp
  8008e5:	48 89 e5             	mov    %rsp,%rbp
  8008e8:	53                   	push   %rbx
  8008e9:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8008f0:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8008f7:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8008fd:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800904:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80090b:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800912:	84 c0                	test   %al,%al
  800914:	74 23                	je     800939 <_panic+0x55>
  800916:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80091d:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800921:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800925:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800929:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80092d:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800931:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800935:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800939:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800940:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800947:	00 00 00 
  80094a:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800951:	00 00 00 
  800954:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800958:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80095f:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800966:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80096d:	48 b8 38 80 80 00 00 	movabs $0x808038,%rax
  800974:	00 00 00 
  800977:	48 8b 18             	mov    (%rax),%rbx
  80097a:	48 b8 85 1f 80 00 00 	movabs $0x801f85,%rax
  800981:	00 00 00 
  800984:	ff d0                	callq  *%rax
  800986:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80098c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800993:	41 89 c8             	mov    %ecx,%r8d
  800996:	48 89 d1             	mov    %rdx,%rcx
  800999:	48 89 da             	mov    %rbx,%rdx
  80099c:	89 c6                	mov    %eax,%esi
  80099e:	48 bf c8 58 80 00 00 	movabs $0x8058c8,%rdi
  8009a5:	00 00 00 
  8009a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ad:	49 b9 1d 0b 80 00 00 	movabs $0x800b1d,%r9
  8009b4:	00 00 00 
  8009b7:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8009ba:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8009c1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8009c8:	48 89 d6             	mov    %rdx,%rsi
  8009cb:	48 89 c7             	mov    %rax,%rdi
  8009ce:	48 b8 71 0a 80 00 00 	movabs $0x800a71,%rax
  8009d5:	00 00 00 
  8009d8:	ff d0                	callq  *%rax
	cprintf("\n");
  8009da:	48 bf eb 58 80 00 00 	movabs $0x8058eb,%rdi
  8009e1:	00 00 00 
  8009e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8009e9:	48 ba 1d 0b 80 00 00 	movabs $0x800b1d,%rdx
  8009f0:	00 00 00 
  8009f3:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8009f5:	cc                   	int3   
  8009f6:	eb fd                	jmp    8009f5 <_panic+0x111>

00000000008009f8 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8009f8:	55                   	push   %rbp
  8009f9:	48 89 e5             	mov    %rsp,%rbp
  8009fc:	48 83 ec 10          	sub    $0x10,%rsp
  800a00:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800a03:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800a07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a0b:	8b 00                	mov    (%rax),%eax
  800a0d:	8d 48 01             	lea    0x1(%rax),%ecx
  800a10:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a14:	89 0a                	mov    %ecx,(%rdx)
  800a16:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800a19:	89 d1                	mov    %edx,%ecx
  800a1b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a1f:	48 98                	cltq   
  800a21:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800a25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a29:	8b 00                	mov    (%rax),%eax
  800a2b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a30:	75 2c                	jne    800a5e <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800a32:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a36:	8b 00                	mov    (%rax),%eax
  800a38:	48 98                	cltq   
  800a3a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a3e:	48 83 c2 08          	add    $0x8,%rdx
  800a42:	48 89 c6             	mov    %rax,%rsi
  800a45:	48 89 d7             	mov    %rdx,%rdi
  800a48:	48 b8 b9 1e 80 00 00 	movabs $0x801eb9,%rax
  800a4f:	00 00 00 
  800a52:	ff d0                	callq  *%rax
        b->idx = 0;
  800a54:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a58:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800a5e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a62:	8b 40 04             	mov    0x4(%rax),%eax
  800a65:	8d 50 01             	lea    0x1(%rax),%edx
  800a68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a6c:	89 50 04             	mov    %edx,0x4(%rax)
}
  800a6f:	c9                   	leaveq 
  800a70:	c3                   	retq   

0000000000800a71 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800a71:	55                   	push   %rbp
  800a72:	48 89 e5             	mov    %rsp,%rbp
  800a75:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800a7c:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800a83:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800a8a:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800a91:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800a98:	48 8b 0a             	mov    (%rdx),%rcx
  800a9b:	48 89 08             	mov    %rcx,(%rax)
  800a9e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800aa2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800aa6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800aaa:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800aae:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800ab5:	00 00 00 
    b.cnt = 0;
  800ab8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800abf:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800ac2:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800ac9:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800ad0:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800ad7:	48 89 c6             	mov    %rax,%rsi
  800ada:	48 bf f8 09 80 00 00 	movabs $0x8009f8,%rdi
  800ae1:	00 00 00 
  800ae4:	48 b8 d0 0e 80 00 00 	movabs $0x800ed0,%rax
  800aeb:	00 00 00 
  800aee:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800af0:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800af6:	48 98                	cltq   
  800af8:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800aff:	48 83 c2 08          	add    $0x8,%rdx
  800b03:	48 89 c6             	mov    %rax,%rsi
  800b06:	48 89 d7             	mov    %rdx,%rdi
  800b09:	48 b8 b9 1e 80 00 00 	movabs $0x801eb9,%rax
  800b10:	00 00 00 
  800b13:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800b15:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800b1b:	c9                   	leaveq 
  800b1c:	c3                   	retq   

0000000000800b1d <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800b1d:	55                   	push   %rbp
  800b1e:	48 89 e5             	mov    %rsp,%rbp
  800b21:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800b28:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800b2f:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800b36:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b3d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800b44:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800b4b:	84 c0                	test   %al,%al
  800b4d:	74 20                	je     800b6f <cprintf+0x52>
  800b4f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800b53:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800b57:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800b5b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800b5f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800b63:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800b67:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800b6b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800b6f:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800b76:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800b7d:	00 00 00 
  800b80:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800b87:	00 00 00 
  800b8a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b8e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800b95:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800b9c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800ba3:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800baa:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800bb1:	48 8b 0a             	mov    (%rdx),%rcx
  800bb4:	48 89 08             	mov    %rcx,(%rax)
  800bb7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800bbb:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800bbf:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800bc3:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800bc7:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800bce:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800bd5:	48 89 d6             	mov    %rdx,%rsi
  800bd8:	48 89 c7             	mov    %rax,%rdi
  800bdb:	48 b8 71 0a 80 00 00 	movabs $0x800a71,%rax
  800be2:	00 00 00 
  800be5:	ff d0                	callq  *%rax
  800be7:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800bed:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800bf3:	c9                   	leaveq 
  800bf4:	c3                   	retq   

0000000000800bf5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800bf5:	55                   	push   %rbp
  800bf6:	48 89 e5             	mov    %rsp,%rbp
  800bf9:	53                   	push   %rbx
  800bfa:	48 83 ec 38          	sub    $0x38,%rsp
  800bfe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800c02:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800c06:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800c0a:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800c0d:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800c11:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c15:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800c18:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800c1c:	77 3b                	ja     800c59 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c1e:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800c21:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800c25:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800c28:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800c2c:	ba 00 00 00 00       	mov    $0x0,%edx
  800c31:	48 f7 f3             	div    %rbx
  800c34:	48 89 c2             	mov    %rax,%rdx
  800c37:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800c3a:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800c3d:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800c41:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c45:	41 89 f9             	mov    %edi,%r9d
  800c48:	48 89 c7             	mov    %rax,%rdi
  800c4b:	48 b8 f5 0b 80 00 00 	movabs $0x800bf5,%rax
  800c52:	00 00 00 
  800c55:	ff d0                	callq  *%rax
  800c57:	eb 1e                	jmp    800c77 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c59:	eb 12                	jmp    800c6d <printnum+0x78>
			putch(padc, putdat);
  800c5b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800c5f:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800c62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c66:	48 89 ce             	mov    %rcx,%rsi
  800c69:	89 d7                	mov    %edx,%edi
  800c6b:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c6d:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800c71:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800c75:	7f e4                	jg     800c5b <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c77:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800c7a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800c7e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c83:	48 f7 f1             	div    %rcx
  800c86:	48 89 d0             	mov    %rdx,%rax
  800c89:	48 ba f0 5a 80 00 00 	movabs $0x805af0,%rdx
  800c90:	00 00 00 
  800c93:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800c97:	0f be d0             	movsbl %al,%edx
  800c9a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800c9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ca2:	48 89 ce             	mov    %rcx,%rsi
  800ca5:	89 d7                	mov    %edx,%edi
  800ca7:	ff d0                	callq  *%rax
}
  800ca9:	48 83 c4 38          	add    $0x38,%rsp
  800cad:	5b                   	pop    %rbx
  800cae:	5d                   	pop    %rbp
  800caf:	c3                   	retq   

0000000000800cb0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800cb0:	55                   	push   %rbp
  800cb1:	48 89 e5             	mov    %rsp,%rbp
  800cb4:	48 83 ec 1c          	sub    $0x1c,%rsp
  800cb8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800cbc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800cbf:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800cc3:	7e 52                	jle    800d17 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800cc5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cc9:	8b 00                	mov    (%rax),%eax
  800ccb:	83 f8 30             	cmp    $0x30,%eax
  800cce:	73 24                	jae    800cf4 <getuint+0x44>
  800cd0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cd4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800cd8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cdc:	8b 00                	mov    (%rax),%eax
  800cde:	89 c0                	mov    %eax,%eax
  800ce0:	48 01 d0             	add    %rdx,%rax
  800ce3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ce7:	8b 12                	mov    (%rdx),%edx
  800ce9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800cec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cf0:	89 0a                	mov    %ecx,(%rdx)
  800cf2:	eb 17                	jmp    800d0b <getuint+0x5b>
  800cf4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cf8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800cfc:	48 89 d0             	mov    %rdx,%rax
  800cff:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800d03:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d07:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800d0b:	48 8b 00             	mov    (%rax),%rax
  800d0e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800d12:	e9 a3 00 00 00       	jmpq   800dba <getuint+0x10a>
	else if (lflag)
  800d17:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800d1b:	74 4f                	je     800d6c <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800d1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d21:	8b 00                	mov    (%rax),%eax
  800d23:	83 f8 30             	cmp    $0x30,%eax
  800d26:	73 24                	jae    800d4c <getuint+0x9c>
  800d28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d2c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800d30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d34:	8b 00                	mov    (%rax),%eax
  800d36:	89 c0                	mov    %eax,%eax
  800d38:	48 01 d0             	add    %rdx,%rax
  800d3b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d3f:	8b 12                	mov    (%rdx),%edx
  800d41:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800d44:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d48:	89 0a                	mov    %ecx,(%rdx)
  800d4a:	eb 17                	jmp    800d63 <getuint+0xb3>
  800d4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d50:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800d54:	48 89 d0             	mov    %rdx,%rax
  800d57:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800d5b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d5f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800d63:	48 8b 00             	mov    (%rax),%rax
  800d66:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800d6a:	eb 4e                	jmp    800dba <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800d6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d70:	8b 00                	mov    (%rax),%eax
  800d72:	83 f8 30             	cmp    $0x30,%eax
  800d75:	73 24                	jae    800d9b <getuint+0xeb>
  800d77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d7b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800d7f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d83:	8b 00                	mov    (%rax),%eax
  800d85:	89 c0                	mov    %eax,%eax
  800d87:	48 01 d0             	add    %rdx,%rax
  800d8a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d8e:	8b 12                	mov    (%rdx),%edx
  800d90:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800d93:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d97:	89 0a                	mov    %ecx,(%rdx)
  800d99:	eb 17                	jmp    800db2 <getuint+0x102>
  800d9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d9f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800da3:	48 89 d0             	mov    %rdx,%rax
  800da6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800daa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800dae:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800db2:	8b 00                	mov    (%rax),%eax
  800db4:	89 c0                	mov    %eax,%eax
  800db6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800dba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800dbe:	c9                   	leaveq 
  800dbf:	c3                   	retq   

0000000000800dc0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800dc0:	55                   	push   %rbp
  800dc1:	48 89 e5             	mov    %rsp,%rbp
  800dc4:	48 83 ec 1c          	sub    $0x1c,%rsp
  800dc8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800dcc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800dcf:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800dd3:	7e 52                	jle    800e27 <getint+0x67>
		x=va_arg(*ap, long long);
  800dd5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dd9:	8b 00                	mov    (%rax),%eax
  800ddb:	83 f8 30             	cmp    $0x30,%eax
  800dde:	73 24                	jae    800e04 <getint+0x44>
  800de0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800de4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800de8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dec:	8b 00                	mov    (%rax),%eax
  800dee:	89 c0                	mov    %eax,%eax
  800df0:	48 01 d0             	add    %rdx,%rax
  800df3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800df7:	8b 12                	mov    (%rdx),%edx
  800df9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800dfc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e00:	89 0a                	mov    %ecx,(%rdx)
  800e02:	eb 17                	jmp    800e1b <getint+0x5b>
  800e04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e08:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800e0c:	48 89 d0             	mov    %rdx,%rax
  800e0f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800e13:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e17:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800e1b:	48 8b 00             	mov    (%rax),%rax
  800e1e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800e22:	e9 a3 00 00 00       	jmpq   800eca <getint+0x10a>
	else if (lflag)
  800e27:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800e2b:	74 4f                	je     800e7c <getint+0xbc>
		x=va_arg(*ap, long);
  800e2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e31:	8b 00                	mov    (%rax),%eax
  800e33:	83 f8 30             	cmp    $0x30,%eax
  800e36:	73 24                	jae    800e5c <getint+0x9c>
  800e38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e3c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800e40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e44:	8b 00                	mov    (%rax),%eax
  800e46:	89 c0                	mov    %eax,%eax
  800e48:	48 01 d0             	add    %rdx,%rax
  800e4b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e4f:	8b 12                	mov    (%rdx),%edx
  800e51:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800e54:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e58:	89 0a                	mov    %ecx,(%rdx)
  800e5a:	eb 17                	jmp    800e73 <getint+0xb3>
  800e5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e60:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800e64:	48 89 d0             	mov    %rdx,%rax
  800e67:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800e6b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e6f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800e73:	48 8b 00             	mov    (%rax),%rax
  800e76:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800e7a:	eb 4e                	jmp    800eca <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800e7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e80:	8b 00                	mov    (%rax),%eax
  800e82:	83 f8 30             	cmp    $0x30,%eax
  800e85:	73 24                	jae    800eab <getint+0xeb>
  800e87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e8b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800e8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e93:	8b 00                	mov    (%rax),%eax
  800e95:	89 c0                	mov    %eax,%eax
  800e97:	48 01 d0             	add    %rdx,%rax
  800e9a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e9e:	8b 12                	mov    (%rdx),%edx
  800ea0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ea3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ea7:	89 0a                	mov    %ecx,(%rdx)
  800ea9:	eb 17                	jmp    800ec2 <getint+0x102>
  800eab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eaf:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800eb3:	48 89 d0             	mov    %rdx,%rax
  800eb6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800eba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ebe:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ec2:	8b 00                	mov    (%rax),%eax
  800ec4:	48 98                	cltq   
  800ec6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800eca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800ece:	c9                   	leaveq 
  800ecf:	c3                   	retq   

0000000000800ed0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ed0:	55                   	push   %rbp
  800ed1:	48 89 e5             	mov    %rsp,%rbp
  800ed4:	41 54                	push   %r12
  800ed6:	53                   	push   %rbx
  800ed7:	48 83 ec 60          	sub    $0x60,%rsp
  800edb:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800edf:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800ee3:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800ee7:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800eeb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800eef:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800ef3:	48 8b 0a             	mov    (%rdx),%rcx
  800ef6:	48 89 08             	mov    %rcx,(%rax)
  800ef9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800efd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f01:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f05:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f09:	eb 17                	jmp    800f22 <vprintfmt+0x52>
			if (ch == '\0')
  800f0b:	85 db                	test   %ebx,%ebx
  800f0d:	0f 84 cc 04 00 00    	je     8013df <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800f13:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f17:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f1b:	48 89 d6             	mov    %rdx,%rsi
  800f1e:	89 df                	mov    %ebx,%edi
  800f20:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f22:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f26:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f2a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800f2e:	0f b6 00             	movzbl (%rax),%eax
  800f31:	0f b6 d8             	movzbl %al,%ebx
  800f34:	83 fb 25             	cmp    $0x25,%ebx
  800f37:	75 d2                	jne    800f0b <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800f39:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800f3d:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800f44:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800f4b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800f52:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f59:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f5d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f61:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800f65:	0f b6 00             	movzbl (%rax),%eax
  800f68:	0f b6 d8             	movzbl %al,%ebx
  800f6b:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800f6e:	83 f8 55             	cmp    $0x55,%eax
  800f71:	0f 87 34 04 00 00    	ja     8013ab <vprintfmt+0x4db>
  800f77:	89 c0                	mov    %eax,%eax
  800f79:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800f80:	00 
  800f81:	48 b8 18 5b 80 00 00 	movabs $0x805b18,%rax
  800f88:	00 00 00 
  800f8b:	48 01 d0             	add    %rdx,%rax
  800f8e:	48 8b 00             	mov    (%rax),%rax
  800f91:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800f93:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800f97:	eb c0                	jmp    800f59 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800f99:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800f9d:	eb ba                	jmp    800f59 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f9f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800fa6:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800fa9:	89 d0                	mov    %edx,%eax
  800fab:	c1 e0 02             	shl    $0x2,%eax
  800fae:	01 d0                	add    %edx,%eax
  800fb0:	01 c0                	add    %eax,%eax
  800fb2:	01 d8                	add    %ebx,%eax
  800fb4:	83 e8 30             	sub    $0x30,%eax
  800fb7:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800fba:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800fbe:	0f b6 00             	movzbl (%rax),%eax
  800fc1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800fc4:	83 fb 2f             	cmp    $0x2f,%ebx
  800fc7:	7e 0c                	jle    800fd5 <vprintfmt+0x105>
  800fc9:	83 fb 39             	cmp    $0x39,%ebx
  800fcc:	7f 07                	jg     800fd5 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800fce:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800fd3:	eb d1                	jmp    800fa6 <vprintfmt+0xd6>
			goto process_precision;
  800fd5:	eb 58                	jmp    80102f <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800fd7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800fda:	83 f8 30             	cmp    $0x30,%eax
  800fdd:	73 17                	jae    800ff6 <vprintfmt+0x126>
  800fdf:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800fe3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800fe6:	89 c0                	mov    %eax,%eax
  800fe8:	48 01 d0             	add    %rdx,%rax
  800feb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800fee:	83 c2 08             	add    $0x8,%edx
  800ff1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ff4:	eb 0f                	jmp    801005 <vprintfmt+0x135>
  800ff6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ffa:	48 89 d0             	mov    %rdx,%rax
  800ffd:	48 83 c2 08          	add    $0x8,%rdx
  801001:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801005:	8b 00                	mov    (%rax),%eax
  801007:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80100a:	eb 23                	jmp    80102f <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80100c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801010:	79 0c                	jns    80101e <vprintfmt+0x14e>
				width = 0;
  801012:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  801019:	e9 3b ff ff ff       	jmpq   800f59 <vprintfmt+0x89>
  80101e:	e9 36 ff ff ff       	jmpq   800f59 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  801023:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80102a:	e9 2a ff ff ff       	jmpq   800f59 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80102f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801033:	79 12                	jns    801047 <vprintfmt+0x177>
				width = precision, precision = -1;
  801035:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801038:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80103b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  801042:	e9 12 ff ff ff       	jmpq   800f59 <vprintfmt+0x89>
  801047:	e9 0d ff ff ff       	jmpq   800f59 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  80104c:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  801050:	e9 04 ff ff ff       	jmpq   800f59 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  801055:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801058:	83 f8 30             	cmp    $0x30,%eax
  80105b:	73 17                	jae    801074 <vprintfmt+0x1a4>
  80105d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801061:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801064:	89 c0                	mov    %eax,%eax
  801066:	48 01 d0             	add    %rdx,%rax
  801069:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80106c:	83 c2 08             	add    $0x8,%edx
  80106f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801072:	eb 0f                	jmp    801083 <vprintfmt+0x1b3>
  801074:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801078:	48 89 d0             	mov    %rdx,%rax
  80107b:	48 83 c2 08          	add    $0x8,%rdx
  80107f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801083:	8b 10                	mov    (%rax),%edx
  801085:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  801089:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80108d:	48 89 ce             	mov    %rcx,%rsi
  801090:	89 d7                	mov    %edx,%edi
  801092:	ff d0                	callq  *%rax
			break;
  801094:	e9 40 03 00 00       	jmpq   8013d9 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  801099:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80109c:	83 f8 30             	cmp    $0x30,%eax
  80109f:	73 17                	jae    8010b8 <vprintfmt+0x1e8>
  8010a1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8010a5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8010a8:	89 c0                	mov    %eax,%eax
  8010aa:	48 01 d0             	add    %rdx,%rax
  8010ad:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8010b0:	83 c2 08             	add    $0x8,%edx
  8010b3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8010b6:	eb 0f                	jmp    8010c7 <vprintfmt+0x1f7>
  8010b8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8010bc:	48 89 d0             	mov    %rdx,%rax
  8010bf:	48 83 c2 08          	add    $0x8,%rdx
  8010c3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8010c7:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8010c9:	85 db                	test   %ebx,%ebx
  8010cb:	79 02                	jns    8010cf <vprintfmt+0x1ff>
				err = -err;
  8010cd:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8010cf:	83 fb 15             	cmp    $0x15,%ebx
  8010d2:	7f 16                	jg     8010ea <vprintfmt+0x21a>
  8010d4:	48 b8 40 5a 80 00 00 	movabs $0x805a40,%rax
  8010db:	00 00 00 
  8010de:	48 63 d3             	movslq %ebx,%rdx
  8010e1:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8010e5:	4d 85 e4             	test   %r12,%r12
  8010e8:	75 2e                	jne    801118 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8010ea:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8010ee:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010f2:	89 d9                	mov    %ebx,%ecx
  8010f4:	48 ba 01 5b 80 00 00 	movabs $0x805b01,%rdx
  8010fb:	00 00 00 
  8010fe:	48 89 c7             	mov    %rax,%rdi
  801101:	b8 00 00 00 00       	mov    $0x0,%eax
  801106:	49 b8 e8 13 80 00 00 	movabs $0x8013e8,%r8
  80110d:	00 00 00 
  801110:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801113:	e9 c1 02 00 00       	jmpq   8013d9 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801118:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80111c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801120:	4c 89 e1             	mov    %r12,%rcx
  801123:	48 ba 0a 5b 80 00 00 	movabs $0x805b0a,%rdx
  80112a:	00 00 00 
  80112d:	48 89 c7             	mov    %rax,%rdi
  801130:	b8 00 00 00 00       	mov    $0x0,%eax
  801135:	49 b8 e8 13 80 00 00 	movabs $0x8013e8,%r8
  80113c:	00 00 00 
  80113f:	41 ff d0             	callq  *%r8
			break;
  801142:	e9 92 02 00 00       	jmpq   8013d9 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  801147:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80114a:	83 f8 30             	cmp    $0x30,%eax
  80114d:	73 17                	jae    801166 <vprintfmt+0x296>
  80114f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801153:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801156:	89 c0                	mov    %eax,%eax
  801158:	48 01 d0             	add    %rdx,%rax
  80115b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80115e:	83 c2 08             	add    $0x8,%edx
  801161:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801164:	eb 0f                	jmp    801175 <vprintfmt+0x2a5>
  801166:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80116a:	48 89 d0             	mov    %rdx,%rax
  80116d:	48 83 c2 08          	add    $0x8,%rdx
  801171:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801175:	4c 8b 20             	mov    (%rax),%r12
  801178:	4d 85 e4             	test   %r12,%r12
  80117b:	75 0a                	jne    801187 <vprintfmt+0x2b7>
				p = "(null)";
  80117d:	49 bc 0d 5b 80 00 00 	movabs $0x805b0d,%r12
  801184:	00 00 00 
			if (width > 0 && padc != '-')
  801187:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80118b:	7e 3f                	jle    8011cc <vprintfmt+0x2fc>
  80118d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  801191:	74 39                	je     8011cc <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  801193:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801196:	48 98                	cltq   
  801198:	48 89 c6             	mov    %rax,%rsi
  80119b:	4c 89 e7             	mov    %r12,%rdi
  80119e:	48 b8 94 16 80 00 00 	movabs $0x801694,%rax
  8011a5:	00 00 00 
  8011a8:	ff d0                	callq  *%rax
  8011aa:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8011ad:	eb 17                	jmp    8011c6 <vprintfmt+0x2f6>
					putch(padc, putdat);
  8011af:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8011b3:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8011b7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011bb:	48 89 ce             	mov    %rcx,%rsi
  8011be:	89 d7                	mov    %edx,%edi
  8011c0:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8011c2:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8011c6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8011ca:	7f e3                	jg     8011af <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8011cc:	eb 37                	jmp    801205 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8011ce:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8011d2:	74 1e                	je     8011f2 <vprintfmt+0x322>
  8011d4:	83 fb 1f             	cmp    $0x1f,%ebx
  8011d7:	7e 05                	jle    8011de <vprintfmt+0x30e>
  8011d9:	83 fb 7e             	cmp    $0x7e,%ebx
  8011dc:	7e 14                	jle    8011f2 <vprintfmt+0x322>
					putch('?', putdat);
  8011de:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8011e2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011e6:	48 89 d6             	mov    %rdx,%rsi
  8011e9:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8011ee:	ff d0                	callq  *%rax
  8011f0:	eb 0f                	jmp    801201 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  8011f2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8011f6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011fa:	48 89 d6             	mov    %rdx,%rsi
  8011fd:	89 df                	mov    %ebx,%edi
  8011ff:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801201:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801205:	4c 89 e0             	mov    %r12,%rax
  801208:	4c 8d 60 01          	lea    0x1(%rax),%r12
  80120c:	0f b6 00             	movzbl (%rax),%eax
  80120f:	0f be d8             	movsbl %al,%ebx
  801212:	85 db                	test   %ebx,%ebx
  801214:	74 10                	je     801226 <vprintfmt+0x356>
  801216:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80121a:	78 b2                	js     8011ce <vprintfmt+0x2fe>
  80121c:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  801220:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801224:	79 a8                	jns    8011ce <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801226:	eb 16                	jmp    80123e <vprintfmt+0x36e>
				putch(' ', putdat);
  801228:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80122c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801230:	48 89 d6             	mov    %rdx,%rsi
  801233:	bf 20 00 00 00       	mov    $0x20,%edi
  801238:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80123a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80123e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801242:	7f e4                	jg     801228 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  801244:	e9 90 01 00 00       	jmpq   8013d9 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801249:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80124d:	be 03 00 00 00       	mov    $0x3,%esi
  801252:	48 89 c7             	mov    %rax,%rdi
  801255:	48 b8 c0 0d 80 00 00 	movabs $0x800dc0,%rax
  80125c:	00 00 00 
  80125f:	ff d0                	callq  *%rax
  801261:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  801265:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801269:	48 85 c0             	test   %rax,%rax
  80126c:	79 1d                	jns    80128b <vprintfmt+0x3bb>
				putch('-', putdat);
  80126e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801272:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801276:	48 89 d6             	mov    %rdx,%rsi
  801279:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80127e:	ff d0                	callq  *%rax
				num = -(long long) num;
  801280:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801284:	48 f7 d8             	neg    %rax
  801287:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  80128b:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801292:	e9 d5 00 00 00       	jmpq   80136c <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  801297:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80129b:	be 03 00 00 00       	mov    $0x3,%esi
  8012a0:	48 89 c7             	mov    %rax,%rdi
  8012a3:	48 b8 b0 0c 80 00 00 	movabs $0x800cb0,%rax
  8012aa:	00 00 00 
  8012ad:	ff d0                	callq  *%rax
  8012af:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8012b3:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8012ba:	e9 ad 00 00 00       	jmpq   80136c <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  8012bf:	8b 55 e0             	mov    -0x20(%rbp),%edx
  8012c2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8012c6:	89 d6                	mov    %edx,%esi
  8012c8:	48 89 c7             	mov    %rax,%rdi
  8012cb:	48 b8 c0 0d 80 00 00 	movabs $0x800dc0,%rax
  8012d2:	00 00 00 
  8012d5:	ff d0                	callq  *%rax
  8012d7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  8012db:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  8012e2:	e9 85 00 00 00       	jmpq   80136c <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  8012e7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8012eb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8012ef:	48 89 d6             	mov    %rdx,%rsi
  8012f2:	bf 30 00 00 00       	mov    $0x30,%edi
  8012f7:	ff d0                	callq  *%rax
			putch('x', putdat);
  8012f9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8012fd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801301:	48 89 d6             	mov    %rdx,%rsi
  801304:	bf 78 00 00 00       	mov    $0x78,%edi
  801309:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  80130b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80130e:	83 f8 30             	cmp    $0x30,%eax
  801311:	73 17                	jae    80132a <vprintfmt+0x45a>
  801313:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801317:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80131a:	89 c0                	mov    %eax,%eax
  80131c:	48 01 d0             	add    %rdx,%rax
  80131f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801322:	83 c2 08             	add    $0x8,%edx
  801325:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801328:	eb 0f                	jmp    801339 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  80132a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80132e:	48 89 d0             	mov    %rdx,%rax
  801331:	48 83 c2 08          	add    $0x8,%rdx
  801335:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801339:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80133c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801340:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801347:	eb 23                	jmp    80136c <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801349:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80134d:	be 03 00 00 00       	mov    $0x3,%esi
  801352:	48 89 c7             	mov    %rax,%rdi
  801355:	48 b8 b0 0c 80 00 00 	movabs $0x800cb0,%rax
  80135c:	00 00 00 
  80135f:	ff d0                	callq  *%rax
  801361:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801365:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80136c:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  801371:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801374:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801377:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80137b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80137f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801383:	45 89 c1             	mov    %r8d,%r9d
  801386:	41 89 f8             	mov    %edi,%r8d
  801389:	48 89 c7             	mov    %rax,%rdi
  80138c:	48 b8 f5 0b 80 00 00 	movabs $0x800bf5,%rax
  801393:	00 00 00 
  801396:	ff d0                	callq  *%rax
			break;
  801398:	eb 3f                	jmp    8013d9 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  80139a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80139e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013a2:	48 89 d6             	mov    %rdx,%rsi
  8013a5:	89 df                	mov    %ebx,%edi
  8013a7:	ff d0                	callq  *%rax
			break;
  8013a9:	eb 2e                	jmp    8013d9 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8013ab:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8013af:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013b3:	48 89 d6             	mov    %rdx,%rsi
  8013b6:	bf 25 00 00 00       	mov    $0x25,%edi
  8013bb:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8013bd:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8013c2:	eb 05                	jmp    8013c9 <vprintfmt+0x4f9>
  8013c4:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8013c9:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8013cd:	48 83 e8 01          	sub    $0x1,%rax
  8013d1:	0f b6 00             	movzbl (%rax),%eax
  8013d4:	3c 25                	cmp    $0x25,%al
  8013d6:	75 ec                	jne    8013c4 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  8013d8:	90                   	nop
		}
	}
  8013d9:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8013da:	e9 43 fb ff ff       	jmpq   800f22 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  8013df:	48 83 c4 60          	add    $0x60,%rsp
  8013e3:	5b                   	pop    %rbx
  8013e4:	41 5c                	pop    %r12
  8013e6:	5d                   	pop    %rbp
  8013e7:	c3                   	retq   

00000000008013e8 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8013e8:	55                   	push   %rbp
  8013e9:	48 89 e5             	mov    %rsp,%rbp
  8013ec:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8013f3:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8013fa:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801401:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801408:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80140f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801416:	84 c0                	test   %al,%al
  801418:	74 20                	je     80143a <printfmt+0x52>
  80141a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80141e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801422:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801426:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80142a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80142e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801432:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801436:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80143a:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801441:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801448:	00 00 00 
  80144b:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801452:	00 00 00 
  801455:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801459:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801460:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801467:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  80146e:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801475:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80147c:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801483:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80148a:	48 89 c7             	mov    %rax,%rdi
  80148d:	48 b8 d0 0e 80 00 00 	movabs $0x800ed0,%rax
  801494:	00 00 00 
  801497:	ff d0                	callq  *%rax
	va_end(ap);
}
  801499:	c9                   	leaveq 
  80149a:	c3                   	retq   

000000000080149b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80149b:	55                   	push   %rbp
  80149c:	48 89 e5             	mov    %rsp,%rbp
  80149f:	48 83 ec 10          	sub    $0x10,%rsp
  8014a3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8014a6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8014aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ae:	8b 40 10             	mov    0x10(%rax),%eax
  8014b1:	8d 50 01             	lea    0x1(%rax),%edx
  8014b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014b8:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8014bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014bf:	48 8b 10             	mov    (%rax),%rdx
  8014c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014c6:	48 8b 40 08          	mov    0x8(%rax),%rax
  8014ca:	48 39 c2             	cmp    %rax,%rdx
  8014cd:	73 17                	jae    8014e6 <sprintputch+0x4b>
		*b->buf++ = ch;
  8014cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014d3:	48 8b 00             	mov    (%rax),%rax
  8014d6:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8014da:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8014de:	48 89 0a             	mov    %rcx,(%rdx)
  8014e1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8014e4:	88 10                	mov    %dl,(%rax)
}
  8014e6:	c9                   	leaveq 
  8014e7:	c3                   	retq   

00000000008014e8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8014e8:	55                   	push   %rbp
  8014e9:	48 89 e5             	mov    %rsp,%rbp
  8014ec:	48 83 ec 50          	sub    $0x50,%rsp
  8014f0:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8014f4:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8014f7:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8014fb:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8014ff:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801503:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801507:	48 8b 0a             	mov    (%rdx),%rcx
  80150a:	48 89 08             	mov    %rcx,(%rax)
  80150d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801511:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801515:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801519:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80151d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801521:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801525:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801528:	48 98                	cltq   
  80152a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80152e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801532:	48 01 d0             	add    %rdx,%rax
  801535:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801539:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801540:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801545:	74 06                	je     80154d <vsnprintf+0x65>
  801547:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80154b:	7f 07                	jg     801554 <vsnprintf+0x6c>
		return -E_INVAL;
  80154d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801552:	eb 2f                	jmp    801583 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801554:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801558:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80155c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801560:	48 89 c6             	mov    %rax,%rsi
  801563:	48 bf 9b 14 80 00 00 	movabs $0x80149b,%rdi
  80156a:	00 00 00 
  80156d:	48 b8 d0 0e 80 00 00 	movabs $0x800ed0,%rax
  801574:	00 00 00 
  801577:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801579:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80157d:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801580:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801583:	c9                   	leaveq 
  801584:	c3                   	retq   

0000000000801585 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801585:	55                   	push   %rbp
  801586:	48 89 e5             	mov    %rsp,%rbp
  801589:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801590:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801597:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  80159d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8015a4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8015ab:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8015b2:	84 c0                	test   %al,%al
  8015b4:	74 20                	je     8015d6 <snprintf+0x51>
  8015b6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8015ba:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8015be:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8015c2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8015c6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8015ca:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8015ce:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8015d2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8015d6:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8015dd:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8015e4:	00 00 00 
  8015e7:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8015ee:	00 00 00 
  8015f1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8015f5:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8015fc:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801603:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80160a:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801611:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801618:	48 8b 0a             	mov    (%rdx),%rcx
  80161b:	48 89 08             	mov    %rcx,(%rax)
  80161e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801622:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801626:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80162a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80162e:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801635:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80163c:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801642:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801649:	48 89 c7             	mov    %rax,%rdi
  80164c:	48 b8 e8 14 80 00 00 	movabs $0x8014e8,%rax
  801653:	00 00 00 
  801656:	ff d0                	callq  *%rax
  801658:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80165e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801664:	c9                   	leaveq 
  801665:	c3                   	retq   

0000000000801666 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801666:	55                   	push   %rbp
  801667:	48 89 e5             	mov    %rsp,%rbp
  80166a:	48 83 ec 18          	sub    $0x18,%rsp
  80166e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801672:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801679:	eb 09                	jmp    801684 <strlen+0x1e>
		n++;
  80167b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80167f:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801684:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801688:	0f b6 00             	movzbl (%rax),%eax
  80168b:	84 c0                	test   %al,%al
  80168d:	75 ec                	jne    80167b <strlen+0x15>
		n++;
	return n;
  80168f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801692:	c9                   	leaveq 
  801693:	c3                   	retq   

0000000000801694 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801694:	55                   	push   %rbp
  801695:	48 89 e5             	mov    %rsp,%rbp
  801698:	48 83 ec 20          	sub    $0x20,%rsp
  80169c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016a0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8016a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8016ab:	eb 0e                	jmp    8016bb <strnlen+0x27>
		n++;
  8016ad:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8016b1:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8016b6:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8016bb:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8016c0:	74 0b                	je     8016cd <strnlen+0x39>
  8016c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016c6:	0f b6 00             	movzbl (%rax),%eax
  8016c9:	84 c0                	test   %al,%al
  8016cb:	75 e0                	jne    8016ad <strnlen+0x19>
		n++;
	return n;
  8016cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8016d0:	c9                   	leaveq 
  8016d1:	c3                   	retq   

00000000008016d2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8016d2:	55                   	push   %rbp
  8016d3:	48 89 e5             	mov    %rsp,%rbp
  8016d6:	48 83 ec 20          	sub    $0x20,%rsp
  8016da:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016de:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8016e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016e6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8016ea:	90                   	nop
  8016eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016ef:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8016f3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8016f7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8016fb:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8016ff:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801703:	0f b6 12             	movzbl (%rdx),%edx
  801706:	88 10                	mov    %dl,(%rax)
  801708:	0f b6 00             	movzbl (%rax),%eax
  80170b:	84 c0                	test   %al,%al
  80170d:	75 dc                	jne    8016eb <strcpy+0x19>
		/* do nothing */;
	return ret;
  80170f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801713:	c9                   	leaveq 
  801714:	c3                   	retq   

0000000000801715 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801715:	55                   	push   %rbp
  801716:	48 89 e5             	mov    %rsp,%rbp
  801719:	48 83 ec 20          	sub    $0x20,%rsp
  80171d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801721:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801725:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801729:	48 89 c7             	mov    %rax,%rdi
  80172c:	48 b8 66 16 80 00 00 	movabs $0x801666,%rax
  801733:	00 00 00 
  801736:	ff d0                	callq  *%rax
  801738:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80173b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80173e:	48 63 d0             	movslq %eax,%rdx
  801741:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801745:	48 01 c2             	add    %rax,%rdx
  801748:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80174c:	48 89 c6             	mov    %rax,%rsi
  80174f:	48 89 d7             	mov    %rdx,%rdi
  801752:	48 b8 d2 16 80 00 00 	movabs $0x8016d2,%rax
  801759:	00 00 00 
  80175c:	ff d0                	callq  *%rax
	return dst;
  80175e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801762:	c9                   	leaveq 
  801763:	c3                   	retq   

0000000000801764 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801764:	55                   	push   %rbp
  801765:	48 89 e5             	mov    %rsp,%rbp
  801768:	48 83 ec 28          	sub    $0x28,%rsp
  80176c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801770:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801774:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801778:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80177c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801780:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801787:	00 
  801788:	eb 2a                	jmp    8017b4 <strncpy+0x50>
		*dst++ = *src;
  80178a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80178e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801792:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801796:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80179a:	0f b6 12             	movzbl (%rdx),%edx
  80179d:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80179f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8017a3:	0f b6 00             	movzbl (%rax),%eax
  8017a6:	84 c0                	test   %al,%al
  8017a8:	74 05                	je     8017af <strncpy+0x4b>
			src++;
  8017aa:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8017af:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017b8:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8017bc:	72 cc                	jb     80178a <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8017be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8017c2:	c9                   	leaveq 
  8017c3:	c3                   	retq   

00000000008017c4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8017c4:	55                   	push   %rbp
  8017c5:	48 89 e5             	mov    %rsp,%rbp
  8017c8:	48 83 ec 28          	sub    $0x28,%rsp
  8017cc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017d0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8017d4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8017d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017dc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8017e0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8017e5:	74 3d                	je     801824 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8017e7:	eb 1d                	jmp    801806 <strlcpy+0x42>
			*dst++ = *src++;
  8017e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017ed:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017f1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8017f5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8017f9:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8017fd:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801801:	0f b6 12             	movzbl (%rdx),%edx
  801804:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801806:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80180b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801810:	74 0b                	je     80181d <strlcpy+0x59>
  801812:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801816:	0f b6 00             	movzbl (%rax),%eax
  801819:	84 c0                	test   %al,%al
  80181b:	75 cc                	jne    8017e9 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80181d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801821:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801824:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801828:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80182c:	48 29 c2             	sub    %rax,%rdx
  80182f:	48 89 d0             	mov    %rdx,%rax
}
  801832:	c9                   	leaveq 
  801833:	c3                   	retq   

0000000000801834 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801834:	55                   	push   %rbp
  801835:	48 89 e5             	mov    %rsp,%rbp
  801838:	48 83 ec 10          	sub    $0x10,%rsp
  80183c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801840:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801844:	eb 0a                	jmp    801850 <strcmp+0x1c>
		p++, q++;
  801846:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80184b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801850:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801854:	0f b6 00             	movzbl (%rax),%eax
  801857:	84 c0                	test   %al,%al
  801859:	74 12                	je     80186d <strcmp+0x39>
  80185b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80185f:	0f b6 10             	movzbl (%rax),%edx
  801862:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801866:	0f b6 00             	movzbl (%rax),%eax
  801869:	38 c2                	cmp    %al,%dl
  80186b:	74 d9                	je     801846 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80186d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801871:	0f b6 00             	movzbl (%rax),%eax
  801874:	0f b6 d0             	movzbl %al,%edx
  801877:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80187b:	0f b6 00             	movzbl (%rax),%eax
  80187e:	0f b6 c0             	movzbl %al,%eax
  801881:	29 c2                	sub    %eax,%edx
  801883:	89 d0                	mov    %edx,%eax
}
  801885:	c9                   	leaveq 
  801886:	c3                   	retq   

0000000000801887 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801887:	55                   	push   %rbp
  801888:	48 89 e5             	mov    %rsp,%rbp
  80188b:	48 83 ec 18          	sub    $0x18,%rsp
  80188f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801893:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801897:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80189b:	eb 0f                	jmp    8018ac <strncmp+0x25>
		n--, p++, q++;
  80189d:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8018a2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8018a7:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8018ac:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8018b1:	74 1d                	je     8018d0 <strncmp+0x49>
  8018b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018b7:	0f b6 00             	movzbl (%rax),%eax
  8018ba:	84 c0                	test   %al,%al
  8018bc:	74 12                	je     8018d0 <strncmp+0x49>
  8018be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018c2:	0f b6 10             	movzbl (%rax),%edx
  8018c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018c9:	0f b6 00             	movzbl (%rax),%eax
  8018cc:	38 c2                	cmp    %al,%dl
  8018ce:	74 cd                	je     80189d <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8018d0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8018d5:	75 07                	jne    8018de <strncmp+0x57>
		return 0;
  8018d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8018dc:	eb 18                	jmp    8018f6 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8018de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018e2:	0f b6 00             	movzbl (%rax),%eax
  8018e5:	0f b6 d0             	movzbl %al,%edx
  8018e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018ec:	0f b6 00             	movzbl (%rax),%eax
  8018ef:	0f b6 c0             	movzbl %al,%eax
  8018f2:	29 c2                	sub    %eax,%edx
  8018f4:	89 d0                	mov    %edx,%eax
}
  8018f6:	c9                   	leaveq 
  8018f7:	c3                   	retq   

00000000008018f8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8018f8:	55                   	push   %rbp
  8018f9:	48 89 e5             	mov    %rsp,%rbp
  8018fc:	48 83 ec 0c          	sub    $0xc,%rsp
  801900:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801904:	89 f0                	mov    %esi,%eax
  801906:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801909:	eb 17                	jmp    801922 <strchr+0x2a>
		if (*s == c)
  80190b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80190f:	0f b6 00             	movzbl (%rax),%eax
  801912:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801915:	75 06                	jne    80191d <strchr+0x25>
			return (char *) s;
  801917:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80191b:	eb 15                	jmp    801932 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80191d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801922:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801926:	0f b6 00             	movzbl (%rax),%eax
  801929:	84 c0                	test   %al,%al
  80192b:	75 de                	jne    80190b <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80192d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801932:	c9                   	leaveq 
  801933:	c3                   	retq   

0000000000801934 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801934:	55                   	push   %rbp
  801935:	48 89 e5             	mov    %rsp,%rbp
  801938:	48 83 ec 0c          	sub    $0xc,%rsp
  80193c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801940:	89 f0                	mov    %esi,%eax
  801942:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801945:	eb 13                	jmp    80195a <strfind+0x26>
		if (*s == c)
  801947:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80194b:	0f b6 00             	movzbl (%rax),%eax
  80194e:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801951:	75 02                	jne    801955 <strfind+0x21>
			break;
  801953:	eb 10                	jmp    801965 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801955:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80195a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80195e:	0f b6 00             	movzbl (%rax),%eax
  801961:	84 c0                	test   %al,%al
  801963:	75 e2                	jne    801947 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801965:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801969:	c9                   	leaveq 
  80196a:	c3                   	retq   

000000000080196b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80196b:	55                   	push   %rbp
  80196c:	48 89 e5             	mov    %rsp,%rbp
  80196f:	48 83 ec 18          	sub    $0x18,%rsp
  801973:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801977:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80197a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80197e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801983:	75 06                	jne    80198b <memset+0x20>
		return v;
  801985:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801989:	eb 69                	jmp    8019f4 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80198b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80198f:	83 e0 03             	and    $0x3,%eax
  801992:	48 85 c0             	test   %rax,%rax
  801995:	75 48                	jne    8019df <memset+0x74>
  801997:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80199b:	83 e0 03             	and    $0x3,%eax
  80199e:	48 85 c0             	test   %rax,%rax
  8019a1:	75 3c                	jne    8019df <memset+0x74>
		c &= 0xFF;
  8019a3:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8019aa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8019ad:	c1 e0 18             	shl    $0x18,%eax
  8019b0:	89 c2                	mov    %eax,%edx
  8019b2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8019b5:	c1 e0 10             	shl    $0x10,%eax
  8019b8:	09 c2                	or     %eax,%edx
  8019ba:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8019bd:	c1 e0 08             	shl    $0x8,%eax
  8019c0:	09 d0                	or     %edx,%eax
  8019c2:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8019c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019c9:	48 c1 e8 02          	shr    $0x2,%rax
  8019cd:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8019d0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8019d4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8019d7:	48 89 d7             	mov    %rdx,%rdi
  8019da:	fc                   	cld    
  8019db:	f3 ab                	rep stos %eax,%es:(%rdi)
  8019dd:	eb 11                	jmp    8019f0 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8019df:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8019e3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8019e6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8019ea:	48 89 d7             	mov    %rdx,%rdi
  8019ed:	fc                   	cld    
  8019ee:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8019f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8019f4:	c9                   	leaveq 
  8019f5:	c3                   	retq   

00000000008019f6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8019f6:	55                   	push   %rbp
  8019f7:	48 89 e5             	mov    %rsp,%rbp
  8019fa:	48 83 ec 28          	sub    $0x28,%rsp
  8019fe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a02:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801a06:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801a0a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a0e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801a12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a16:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801a1a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a1e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801a22:	0f 83 88 00 00 00    	jae    801ab0 <memmove+0xba>
  801a28:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a2c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a30:	48 01 d0             	add    %rdx,%rax
  801a33:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801a37:	76 77                	jbe    801ab0 <memmove+0xba>
		s += n;
  801a39:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a3d:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801a41:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a45:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801a49:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a4d:	83 e0 03             	and    $0x3,%eax
  801a50:	48 85 c0             	test   %rax,%rax
  801a53:	75 3b                	jne    801a90 <memmove+0x9a>
  801a55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a59:	83 e0 03             	and    $0x3,%eax
  801a5c:	48 85 c0             	test   %rax,%rax
  801a5f:	75 2f                	jne    801a90 <memmove+0x9a>
  801a61:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a65:	83 e0 03             	and    $0x3,%eax
  801a68:	48 85 c0             	test   %rax,%rax
  801a6b:	75 23                	jne    801a90 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801a6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a71:	48 83 e8 04          	sub    $0x4,%rax
  801a75:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a79:	48 83 ea 04          	sub    $0x4,%rdx
  801a7d:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801a81:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801a85:	48 89 c7             	mov    %rax,%rdi
  801a88:	48 89 d6             	mov    %rdx,%rsi
  801a8b:	fd                   	std    
  801a8c:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801a8e:	eb 1d                	jmp    801aad <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801a90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a94:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801a98:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a9c:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801aa0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aa4:	48 89 d7             	mov    %rdx,%rdi
  801aa7:	48 89 c1             	mov    %rax,%rcx
  801aaa:	fd                   	std    
  801aab:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801aad:	fc                   	cld    
  801aae:	eb 57                	jmp    801b07 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801ab0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ab4:	83 e0 03             	and    $0x3,%eax
  801ab7:	48 85 c0             	test   %rax,%rax
  801aba:	75 36                	jne    801af2 <memmove+0xfc>
  801abc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ac0:	83 e0 03             	and    $0x3,%eax
  801ac3:	48 85 c0             	test   %rax,%rax
  801ac6:	75 2a                	jne    801af2 <memmove+0xfc>
  801ac8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801acc:	83 e0 03             	and    $0x3,%eax
  801acf:	48 85 c0             	test   %rax,%rax
  801ad2:	75 1e                	jne    801af2 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801ad4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ad8:	48 c1 e8 02          	shr    $0x2,%rax
  801adc:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801adf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ae3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ae7:	48 89 c7             	mov    %rax,%rdi
  801aea:	48 89 d6             	mov    %rdx,%rsi
  801aed:	fc                   	cld    
  801aee:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801af0:	eb 15                	jmp    801b07 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801af2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801af6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801afa:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801afe:	48 89 c7             	mov    %rax,%rdi
  801b01:	48 89 d6             	mov    %rdx,%rsi
  801b04:	fc                   	cld    
  801b05:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801b07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801b0b:	c9                   	leaveq 
  801b0c:	c3                   	retq   

0000000000801b0d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801b0d:	55                   	push   %rbp
  801b0e:	48 89 e5             	mov    %rsp,%rbp
  801b11:	48 83 ec 18          	sub    $0x18,%rsp
  801b15:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b19:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b1d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801b21:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801b25:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801b29:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b2d:	48 89 ce             	mov    %rcx,%rsi
  801b30:	48 89 c7             	mov    %rax,%rdi
  801b33:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  801b3a:	00 00 00 
  801b3d:	ff d0                	callq  *%rax
}
  801b3f:	c9                   	leaveq 
  801b40:	c3                   	retq   

0000000000801b41 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801b41:	55                   	push   %rbp
  801b42:	48 89 e5             	mov    %rsp,%rbp
  801b45:	48 83 ec 28          	sub    $0x28,%rsp
  801b49:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b4d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801b51:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801b55:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b59:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801b5d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b61:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801b65:	eb 36                	jmp    801b9d <memcmp+0x5c>
		if (*s1 != *s2)
  801b67:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b6b:	0f b6 10             	movzbl (%rax),%edx
  801b6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b72:	0f b6 00             	movzbl (%rax),%eax
  801b75:	38 c2                	cmp    %al,%dl
  801b77:	74 1a                	je     801b93 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801b79:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b7d:	0f b6 00             	movzbl (%rax),%eax
  801b80:	0f b6 d0             	movzbl %al,%edx
  801b83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b87:	0f b6 00             	movzbl (%rax),%eax
  801b8a:	0f b6 c0             	movzbl %al,%eax
  801b8d:	29 c2                	sub    %eax,%edx
  801b8f:	89 d0                	mov    %edx,%eax
  801b91:	eb 20                	jmp    801bb3 <memcmp+0x72>
		s1++, s2++;
  801b93:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801b98:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801b9d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ba1:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801ba5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801ba9:	48 85 c0             	test   %rax,%rax
  801bac:	75 b9                	jne    801b67 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801bae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bb3:	c9                   	leaveq 
  801bb4:	c3                   	retq   

0000000000801bb5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801bb5:	55                   	push   %rbp
  801bb6:	48 89 e5             	mov    %rsp,%rbp
  801bb9:	48 83 ec 28          	sub    $0x28,%rsp
  801bbd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801bc1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801bc4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801bc8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bcc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801bd0:	48 01 d0             	add    %rdx,%rax
  801bd3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801bd7:	eb 15                	jmp    801bee <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801bd9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bdd:	0f b6 10             	movzbl (%rax),%edx
  801be0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801be3:	38 c2                	cmp    %al,%dl
  801be5:	75 02                	jne    801be9 <memfind+0x34>
			break;
  801be7:	eb 0f                	jmp    801bf8 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801be9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801bee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bf2:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801bf6:	72 e1                	jb     801bd9 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801bf8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801bfc:	c9                   	leaveq 
  801bfd:	c3                   	retq   

0000000000801bfe <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801bfe:	55                   	push   %rbp
  801bff:	48 89 e5             	mov    %rsp,%rbp
  801c02:	48 83 ec 34          	sub    $0x34,%rsp
  801c06:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801c0a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801c0e:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801c11:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801c18:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801c1f:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c20:	eb 05                	jmp    801c27 <strtol+0x29>
		s++;
  801c22:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c27:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c2b:	0f b6 00             	movzbl (%rax),%eax
  801c2e:	3c 20                	cmp    $0x20,%al
  801c30:	74 f0                	je     801c22 <strtol+0x24>
  801c32:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c36:	0f b6 00             	movzbl (%rax),%eax
  801c39:	3c 09                	cmp    $0x9,%al
  801c3b:	74 e5                	je     801c22 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801c3d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c41:	0f b6 00             	movzbl (%rax),%eax
  801c44:	3c 2b                	cmp    $0x2b,%al
  801c46:	75 07                	jne    801c4f <strtol+0x51>
		s++;
  801c48:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801c4d:	eb 17                	jmp    801c66 <strtol+0x68>
	else if (*s == '-')
  801c4f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c53:	0f b6 00             	movzbl (%rax),%eax
  801c56:	3c 2d                	cmp    $0x2d,%al
  801c58:	75 0c                	jne    801c66 <strtol+0x68>
		s++, neg = 1;
  801c5a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801c5f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801c66:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801c6a:	74 06                	je     801c72 <strtol+0x74>
  801c6c:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801c70:	75 28                	jne    801c9a <strtol+0x9c>
  801c72:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c76:	0f b6 00             	movzbl (%rax),%eax
  801c79:	3c 30                	cmp    $0x30,%al
  801c7b:	75 1d                	jne    801c9a <strtol+0x9c>
  801c7d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c81:	48 83 c0 01          	add    $0x1,%rax
  801c85:	0f b6 00             	movzbl (%rax),%eax
  801c88:	3c 78                	cmp    $0x78,%al
  801c8a:	75 0e                	jne    801c9a <strtol+0x9c>
		s += 2, base = 16;
  801c8c:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801c91:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801c98:	eb 2c                	jmp    801cc6 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801c9a:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801c9e:	75 19                	jne    801cb9 <strtol+0xbb>
  801ca0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ca4:	0f b6 00             	movzbl (%rax),%eax
  801ca7:	3c 30                	cmp    $0x30,%al
  801ca9:	75 0e                	jne    801cb9 <strtol+0xbb>
		s++, base = 8;
  801cab:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801cb0:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801cb7:	eb 0d                	jmp    801cc6 <strtol+0xc8>
	else if (base == 0)
  801cb9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801cbd:	75 07                	jne    801cc6 <strtol+0xc8>
		base = 10;
  801cbf:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801cc6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cca:	0f b6 00             	movzbl (%rax),%eax
  801ccd:	3c 2f                	cmp    $0x2f,%al
  801ccf:	7e 1d                	jle    801cee <strtol+0xf0>
  801cd1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cd5:	0f b6 00             	movzbl (%rax),%eax
  801cd8:	3c 39                	cmp    $0x39,%al
  801cda:	7f 12                	jg     801cee <strtol+0xf0>
			dig = *s - '0';
  801cdc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ce0:	0f b6 00             	movzbl (%rax),%eax
  801ce3:	0f be c0             	movsbl %al,%eax
  801ce6:	83 e8 30             	sub    $0x30,%eax
  801ce9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801cec:	eb 4e                	jmp    801d3c <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801cee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cf2:	0f b6 00             	movzbl (%rax),%eax
  801cf5:	3c 60                	cmp    $0x60,%al
  801cf7:	7e 1d                	jle    801d16 <strtol+0x118>
  801cf9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cfd:	0f b6 00             	movzbl (%rax),%eax
  801d00:	3c 7a                	cmp    $0x7a,%al
  801d02:	7f 12                	jg     801d16 <strtol+0x118>
			dig = *s - 'a' + 10;
  801d04:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d08:	0f b6 00             	movzbl (%rax),%eax
  801d0b:	0f be c0             	movsbl %al,%eax
  801d0e:	83 e8 57             	sub    $0x57,%eax
  801d11:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801d14:	eb 26                	jmp    801d3c <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801d16:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d1a:	0f b6 00             	movzbl (%rax),%eax
  801d1d:	3c 40                	cmp    $0x40,%al
  801d1f:	7e 48                	jle    801d69 <strtol+0x16b>
  801d21:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d25:	0f b6 00             	movzbl (%rax),%eax
  801d28:	3c 5a                	cmp    $0x5a,%al
  801d2a:	7f 3d                	jg     801d69 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801d2c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d30:	0f b6 00             	movzbl (%rax),%eax
  801d33:	0f be c0             	movsbl %al,%eax
  801d36:	83 e8 37             	sub    $0x37,%eax
  801d39:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801d3c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d3f:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801d42:	7c 02                	jl     801d46 <strtol+0x148>
			break;
  801d44:	eb 23                	jmp    801d69 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801d46:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801d4b:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801d4e:	48 98                	cltq   
  801d50:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801d55:	48 89 c2             	mov    %rax,%rdx
  801d58:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d5b:	48 98                	cltq   
  801d5d:	48 01 d0             	add    %rdx,%rax
  801d60:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801d64:	e9 5d ff ff ff       	jmpq   801cc6 <strtol+0xc8>

	if (endptr)
  801d69:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801d6e:	74 0b                	je     801d7b <strtol+0x17d>
		*endptr = (char *) s;
  801d70:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d74:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801d78:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801d7b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d7f:	74 09                	je     801d8a <strtol+0x18c>
  801d81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d85:	48 f7 d8             	neg    %rax
  801d88:	eb 04                	jmp    801d8e <strtol+0x190>
  801d8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801d8e:	c9                   	leaveq 
  801d8f:	c3                   	retq   

0000000000801d90 <strstr>:

char * strstr(const char *in, const char *str)
{
  801d90:	55                   	push   %rbp
  801d91:	48 89 e5             	mov    %rsp,%rbp
  801d94:	48 83 ec 30          	sub    $0x30,%rsp
  801d98:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801d9c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801da0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801da4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801da8:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801dac:	0f b6 00             	movzbl (%rax),%eax
  801daf:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801db2:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801db6:	75 06                	jne    801dbe <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801db8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dbc:	eb 6b                	jmp    801e29 <strstr+0x99>

	len = strlen(str);
  801dbe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801dc2:	48 89 c7             	mov    %rax,%rdi
  801dc5:	48 b8 66 16 80 00 00 	movabs $0x801666,%rax
  801dcc:	00 00 00 
  801dcf:	ff d0                	callq  *%rax
  801dd1:	48 98                	cltq   
  801dd3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801dd7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ddb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801ddf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801de3:	0f b6 00             	movzbl (%rax),%eax
  801de6:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801de9:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801ded:	75 07                	jne    801df6 <strstr+0x66>
				return (char *) 0;
  801def:	b8 00 00 00 00       	mov    $0x0,%eax
  801df4:	eb 33                	jmp    801e29 <strstr+0x99>
		} while (sc != c);
  801df6:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801dfa:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801dfd:	75 d8                	jne    801dd7 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801dff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e03:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801e07:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e0b:	48 89 ce             	mov    %rcx,%rsi
  801e0e:	48 89 c7             	mov    %rax,%rdi
  801e11:	48 b8 87 18 80 00 00 	movabs $0x801887,%rax
  801e18:	00 00 00 
  801e1b:	ff d0                	callq  *%rax
  801e1d:	85 c0                	test   %eax,%eax
  801e1f:	75 b6                	jne    801dd7 <strstr+0x47>

	return (char *) (in - 1);
  801e21:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e25:	48 83 e8 01          	sub    $0x1,%rax
}
  801e29:	c9                   	leaveq 
  801e2a:	c3                   	retq   

0000000000801e2b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801e2b:	55                   	push   %rbp
  801e2c:	48 89 e5             	mov    %rsp,%rbp
  801e2f:	53                   	push   %rbx
  801e30:	48 83 ec 48          	sub    $0x48,%rsp
  801e34:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801e37:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801e3a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801e3e:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801e42:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801e46:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e4a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801e4d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801e51:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801e55:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801e59:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801e5d:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801e61:	4c 89 c3             	mov    %r8,%rbx
  801e64:	cd 30                	int    $0x30
  801e66:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801e6a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801e6e:	74 3e                	je     801eae <syscall+0x83>
  801e70:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801e75:	7e 37                	jle    801eae <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801e77:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801e7b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801e7e:	49 89 d0             	mov    %rdx,%r8
  801e81:	89 c1                	mov    %eax,%ecx
  801e83:	48 ba c8 5d 80 00 00 	movabs $0x805dc8,%rdx
  801e8a:	00 00 00 
  801e8d:	be 23 00 00 00       	mov    $0x23,%esi
  801e92:	48 bf e5 5d 80 00 00 	movabs $0x805de5,%rdi
  801e99:	00 00 00 
  801e9c:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea1:	49 b9 e4 08 80 00 00 	movabs $0x8008e4,%r9
  801ea8:	00 00 00 
  801eab:	41 ff d1             	callq  *%r9

	return ret;
  801eae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801eb2:	48 83 c4 48          	add    $0x48,%rsp
  801eb6:	5b                   	pop    %rbx
  801eb7:	5d                   	pop    %rbp
  801eb8:	c3                   	retq   

0000000000801eb9 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801eb9:	55                   	push   %rbp
  801eba:	48 89 e5             	mov    %rsp,%rbp
  801ebd:	48 83 ec 20          	sub    $0x20,%rsp
  801ec1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ec5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801ec9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ecd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ed1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ed8:	00 
  801ed9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801edf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ee5:	48 89 d1             	mov    %rdx,%rcx
  801ee8:	48 89 c2             	mov    %rax,%rdx
  801eeb:	be 00 00 00 00       	mov    $0x0,%esi
  801ef0:	bf 00 00 00 00       	mov    $0x0,%edi
  801ef5:	48 b8 2b 1e 80 00 00 	movabs $0x801e2b,%rax
  801efc:	00 00 00 
  801eff:	ff d0                	callq  *%rax
}
  801f01:	c9                   	leaveq 
  801f02:	c3                   	retq   

0000000000801f03 <sys_cgetc>:

int
sys_cgetc(void)
{
  801f03:	55                   	push   %rbp
  801f04:	48 89 e5             	mov    %rsp,%rbp
  801f07:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801f0b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f12:	00 
  801f13:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f19:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f1f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f24:	ba 00 00 00 00       	mov    $0x0,%edx
  801f29:	be 00 00 00 00       	mov    $0x0,%esi
  801f2e:	bf 01 00 00 00       	mov    $0x1,%edi
  801f33:	48 b8 2b 1e 80 00 00 	movabs $0x801e2b,%rax
  801f3a:	00 00 00 
  801f3d:	ff d0                	callq  *%rax
}
  801f3f:	c9                   	leaveq 
  801f40:	c3                   	retq   

0000000000801f41 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801f41:	55                   	push   %rbp
  801f42:	48 89 e5             	mov    %rsp,%rbp
  801f45:	48 83 ec 10          	sub    $0x10,%rsp
  801f49:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801f4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f4f:	48 98                	cltq   
  801f51:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f58:	00 
  801f59:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f5f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f65:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f6a:	48 89 c2             	mov    %rax,%rdx
  801f6d:	be 01 00 00 00       	mov    $0x1,%esi
  801f72:	bf 03 00 00 00       	mov    $0x3,%edi
  801f77:	48 b8 2b 1e 80 00 00 	movabs $0x801e2b,%rax
  801f7e:	00 00 00 
  801f81:	ff d0                	callq  *%rax
}
  801f83:	c9                   	leaveq 
  801f84:	c3                   	retq   

0000000000801f85 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801f85:	55                   	push   %rbp
  801f86:	48 89 e5             	mov    %rsp,%rbp
  801f89:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801f8d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f94:	00 
  801f95:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f9b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fa1:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fa6:	ba 00 00 00 00       	mov    $0x0,%edx
  801fab:	be 00 00 00 00       	mov    $0x0,%esi
  801fb0:	bf 02 00 00 00       	mov    $0x2,%edi
  801fb5:	48 b8 2b 1e 80 00 00 	movabs $0x801e2b,%rax
  801fbc:	00 00 00 
  801fbf:	ff d0                	callq  *%rax
}
  801fc1:	c9                   	leaveq 
  801fc2:	c3                   	retq   

0000000000801fc3 <sys_yield>:

void
sys_yield(void)
{
  801fc3:	55                   	push   %rbp
  801fc4:	48 89 e5             	mov    %rsp,%rbp
  801fc7:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801fcb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fd2:	00 
  801fd3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fd9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fdf:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fe4:	ba 00 00 00 00       	mov    $0x0,%edx
  801fe9:	be 00 00 00 00       	mov    $0x0,%esi
  801fee:	bf 0b 00 00 00       	mov    $0xb,%edi
  801ff3:	48 b8 2b 1e 80 00 00 	movabs $0x801e2b,%rax
  801ffa:	00 00 00 
  801ffd:	ff d0                	callq  *%rax
}
  801fff:	c9                   	leaveq 
  802000:	c3                   	retq   

0000000000802001 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802001:	55                   	push   %rbp
  802002:	48 89 e5             	mov    %rsp,%rbp
  802005:	48 83 ec 20          	sub    $0x20,%rsp
  802009:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80200c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802010:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  802013:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802016:	48 63 c8             	movslq %eax,%rcx
  802019:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80201d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802020:	48 98                	cltq   
  802022:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802029:	00 
  80202a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802030:	49 89 c8             	mov    %rcx,%r8
  802033:	48 89 d1             	mov    %rdx,%rcx
  802036:	48 89 c2             	mov    %rax,%rdx
  802039:	be 01 00 00 00       	mov    $0x1,%esi
  80203e:	bf 04 00 00 00       	mov    $0x4,%edi
  802043:	48 b8 2b 1e 80 00 00 	movabs $0x801e2b,%rax
  80204a:	00 00 00 
  80204d:	ff d0                	callq  *%rax
}
  80204f:	c9                   	leaveq 
  802050:	c3                   	retq   

0000000000802051 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802051:	55                   	push   %rbp
  802052:	48 89 e5             	mov    %rsp,%rbp
  802055:	48 83 ec 30          	sub    $0x30,%rsp
  802059:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80205c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802060:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802063:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802067:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80206b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80206e:	48 63 c8             	movslq %eax,%rcx
  802071:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802075:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802078:	48 63 f0             	movslq %eax,%rsi
  80207b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80207f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802082:	48 98                	cltq   
  802084:	48 89 0c 24          	mov    %rcx,(%rsp)
  802088:	49 89 f9             	mov    %rdi,%r9
  80208b:	49 89 f0             	mov    %rsi,%r8
  80208e:	48 89 d1             	mov    %rdx,%rcx
  802091:	48 89 c2             	mov    %rax,%rdx
  802094:	be 01 00 00 00       	mov    $0x1,%esi
  802099:	bf 05 00 00 00       	mov    $0x5,%edi
  80209e:	48 b8 2b 1e 80 00 00 	movabs $0x801e2b,%rax
  8020a5:	00 00 00 
  8020a8:	ff d0                	callq  *%rax
}
  8020aa:	c9                   	leaveq 
  8020ab:	c3                   	retq   

00000000008020ac <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8020ac:	55                   	push   %rbp
  8020ad:	48 89 e5             	mov    %rsp,%rbp
  8020b0:	48 83 ec 20          	sub    $0x20,%rsp
  8020b4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8020b7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8020bb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020c2:	48 98                	cltq   
  8020c4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8020cb:	00 
  8020cc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020d2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020d8:	48 89 d1             	mov    %rdx,%rcx
  8020db:	48 89 c2             	mov    %rax,%rdx
  8020de:	be 01 00 00 00       	mov    $0x1,%esi
  8020e3:	bf 06 00 00 00       	mov    $0x6,%edi
  8020e8:	48 b8 2b 1e 80 00 00 	movabs $0x801e2b,%rax
  8020ef:	00 00 00 
  8020f2:	ff d0                	callq  *%rax
}
  8020f4:	c9                   	leaveq 
  8020f5:	c3                   	retq   

00000000008020f6 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8020f6:	55                   	push   %rbp
  8020f7:	48 89 e5             	mov    %rsp,%rbp
  8020fa:	48 83 ec 10          	sub    $0x10,%rsp
  8020fe:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802101:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  802104:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802107:	48 63 d0             	movslq %eax,%rdx
  80210a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80210d:	48 98                	cltq   
  80210f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802116:	00 
  802117:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80211d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802123:	48 89 d1             	mov    %rdx,%rcx
  802126:	48 89 c2             	mov    %rax,%rdx
  802129:	be 01 00 00 00       	mov    $0x1,%esi
  80212e:	bf 08 00 00 00       	mov    $0x8,%edi
  802133:	48 b8 2b 1e 80 00 00 	movabs $0x801e2b,%rax
  80213a:	00 00 00 
  80213d:	ff d0                	callq  *%rax
}
  80213f:	c9                   	leaveq 
  802140:	c3                   	retq   

0000000000802141 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802141:	55                   	push   %rbp
  802142:	48 89 e5             	mov    %rsp,%rbp
  802145:	48 83 ec 20          	sub    $0x20,%rsp
  802149:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80214c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  802150:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802154:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802157:	48 98                	cltq   
  802159:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802160:	00 
  802161:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802167:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80216d:	48 89 d1             	mov    %rdx,%rcx
  802170:	48 89 c2             	mov    %rax,%rdx
  802173:	be 01 00 00 00       	mov    $0x1,%esi
  802178:	bf 09 00 00 00       	mov    $0x9,%edi
  80217d:	48 b8 2b 1e 80 00 00 	movabs $0x801e2b,%rax
  802184:	00 00 00 
  802187:	ff d0                	callq  *%rax
}
  802189:	c9                   	leaveq 
  80218a:	c3                   	retq   

000000000080218b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80218b:	55                   	push   %rbp
  80218c:	48 89 e5             	mov    %rsp,%rbp
  80218f:	48 83 ec 20          	sub    $0x20,%rsp
  802193:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802196:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80219a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80219e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021a1:	48 98                	cltq   
  8021a3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8021aa:	00 
  8021ab:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021b1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021b7:	48 89 d1             	mov    %rdx,%rcx
  8021ba:	48 89 c2             	mov    %rax,%rdx
  8021bd:	be 01 00 00 00       	mov    $0x1,%esi
  8021c2:	bf 0a 00 00 00       	mov    $0xa,%edi
  8021c7:	48 b8 2b 1e 80 00 00 	movabs $0x801e2b,%rax
  8021ce:	00 00 00 
  8021d1:	ff d0                	callq  *%rax
}
  8021d3:	c9                   	leaveq 
  8021d4:	c3                   	retq   

00000000008021d5 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8021d5:	55                   	push   %rbp
  8021d6:	48 89 e5             	mov    %rsp,%rbp
  8021d9:	48 83 ec 20          	sub    $0x20,%rsp
  8021dd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8021e0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8021e4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8021e8:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8021eb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8021ee:	48 63 f0             	movslq %eax,%rsi
  8021f1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8021f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021f8:	48 98                	cltq   
  8021fa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021fe:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802205:	00 
  802206:	49 89 f1             	mov    %rsi,%r9
  802209:	49 89 c8             	mov    %rcx,%r8
  80220c:	48 89 d1             	mov    %rdx,%rcx
  80220f:	48 89 c2             	mov    %rax,%rdx
  802212:	be 00 00 00 00       	mov    $0x0,%esi
  802217:	bf 0c 00 00 00       	mov    $0xc,%edi
  80221c:	48 b8 2b 1e 80 00 00 	movabs $0x801e2b,%rax
  802223:	00 00 00 
  802226:	ff d0                	callq  *%rax
}
  802228:	c9                   	leaveq 
  802229:	c3                   	retq   

000000000080222a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80222a:	55                   	push   %rbp
  80222b:	48 89 e5             	mov    %rsp,%rbp
  80222e:	48 83 ec 10          	sub    $0x10,%rsp
  802232:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  802236:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80223a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802241:	00 
  802242:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802248:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80224e:	b9 00 00 00 00       	mov    $0x0,%ecx
  802253:	48 89 c2             	mov    %rax,%rdx
  802256:	be 01 00 00 00       	mov    $0x1,%esi
  80225b:	bf 0d 00 00 00       	mov    $0xd,%edi
  802260:	48 b8 2b 1e 80 00 00 	movabs $0x801e2b,%rax
  802267:	00 00 00 
  80226a:	ff d0                	callq  *%rax
}
  80226c:	c9                   	leaveq 
  80226d:	c3                   	retq   

000000000080226e <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  80226e:	55                   	push   %rbp
  80226f:	48 89 e5             	mov    %rsp,%rbp
  802272:	48 83 ec 20          	sub    $0x20,%rsp
  802276:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80227a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, (uint64_t)buf, len, 0, 0, 0, 0);
  80227e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802282:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802286:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80228d:	00 
  80228e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802294:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80229a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80229f:	89 c6                	mov    %eax,%esi
  8022a1:	bf 0f 00 00 00       	mov    $0xf,%edi
  8022a6:	48 b8 2b 1e 80 00 00 	movabs $0x801e2b,%rax
  8022ad:	00 00 00 
  8022b0:	ff d0                	callq  *%rax
}
  8022b2:	c9                   	leaveq 
  8022b3:	c3                   	retq   

00000000008022b4 <sys_net_rx>:

int
sys_net_rx(void *buf, size_t len)
{
  8022b4:	55                   	push   %rbp
  8022b5:	48 89 e5             	mov    %rsp,%rbp
  8022b8:	48 83 ec 20          	sub    $0x20,%rsp
  8022bc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8022c0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_rx, (uint64_t)buf, len, 0, 0, 0, 0);
  8022c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022c8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022cc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8022d3:	00 
  8022d4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8022da:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8022e0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8022e5:	89 c6                	mov    %eax,%esi
  8022e7:	bf 10 00 00 00       	mov    $0x10,%edi
  8022ec:	48 b8 2b 1e 80 00 00 	movabs $0x801e2b,%rax
  8022f3:	00 00 00 
  8022f6:	ff d0                	callq  *%rax
}
  8022f8:	c9                   	leaveq 
  8022f9:	c3                   	retq   

00000000008022fa <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  8022fa:	55                   	push   %rbp
  8022fb:	48 89 e5             	mov    %rsp,%rbp
  8022fe:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  802302:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802309:	00 
  80230a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802310:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802316:	b9 00 00 00 00       	mov    $0x0,%ecx
  80231b:	ba 00 00 00 00       	mov    $0x0,%edx
  802320:	be 00 00 00 00       	mov    $0x0,%esi
  802325:	bf 0e 00 00 00       	mov    $0xe,%edi
  80232a:	48 b8 2b 1e 80 00 00 	movabs $0x801e2b,%rax
  802331:	00 00 00 
  802334:	ff d0                	callq  *%rax
}
  802336:	c9                   	leaveq 
  802337:	c3                   	retq   

0000000000802338 <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  802338:	55                   	push   %rbp
  802339:	48 89 e5             	mov    %rsp,%rbp
  80233c:	48 83 ec 30          	sub    $0x30,%rsp
  802340:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  802344:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802348:	48 8b 00             	mov    (%rax),%rax
  80234b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  80234f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802353:	48 8b 40 08          	mov    0x8(%rax),%rax
  802357:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  80235a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80235d:	83 e0 02             	and    $0x2,%eax
  802360:	85 c0                	test   %eax,%eax
  802362:	75 4d                	jne    8023b1 <pgfault+0x79>
  802364:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802368:	48 c1 e8 0c          	shr    $0xc,%rax
  80236c:	48 89 c2             	mov    %rax,%rdx
  80236f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802376:	01 00 00 
  802379:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80237d:	25 00 08 00 00       	and    $0x800,%eax
  802382:	48 85 c0             	test   %rax,%rax
  802385:	74 2a                	je     8023b1 <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  802387:	48 ba f8 5d 80 00 00 	movabs $0x805df8,%rdx
  80238e:	00 00 00 
  802391:	be 23 00 00 00       	mov    $0x23,%esi
  802396:	48 bf 2d 5e 80 00 00 	movabs $0x805e2d,%rdi
  80239d:	00 00 00 
  8023a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8023a5:	48 b9 e4 08 80 00 00 	movabs $0x8008e4,%rcx
  8023ac:	00 00 00 
  8023af:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  8023b1:	ba 07 00 00 00       	mov    $0x7,%edx
  8023b6:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8023bb:	bf 00 00 00 00       	mov    $0x0,%edi
  8023c0:	48 b8 01 20 80 00 00 	movabs $0x802001,%rax
  8023c7:	00 00 00 
  8023ca:	ff d0                	callq  *%rax
  8023cc:	85 c0                	test   %eax,%eax
  8023ce:	0f 85 cd 00 00 00    	jne    8024a1 <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  8023d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023d8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8023dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023e0:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8023e6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  8023ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023ee:	ba 00 10 00 00       	mov    $0x1000,%edx
  8023f3:	48 89 c6             	mov    %rax,%rsi
  8023f6:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  8023fb:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  802402:	00 00 00 
  802405:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  802407:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80240b:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802411:	48 89 c1             	mov    %rax,%rcx
  802414:	ba 00 00 00 00       	mov    $0x0,%edx
  802419:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80241e:	bf 00 00 00 00       	mov    $0x0,%edi
  802423:	48 b8 51 20 80 00 00 	movabs $0x802051,%rax
  80242a:	00 00 00 
  80242d:	ff d0                	callq  *%rax
  80242f:	85 c0                	test   %eax,%eax
  802431:	79 2a                	jns    80245d <pgfault+0x125>
				panic("Page map at temp address failed");
  802433:	48 ba 38 5e 80 00 00 	movabs $0x805e38,%rdx
  80243a:	00 00 00 
  80243d:	be 30 00 00 00       	mov    $0x30,%esi
  802442:	48 bf 2d 5e 80 00 00 	movabs $0x805e2d,%rdi
  802449:	00 00 00 
  80244c:	b8 00 00 00 00       	mov    $0x0,%eax
  802451:	48 b9 e4 08 80 00 00 	movabs $0x8008e4,%rcx
  802458:	00 00 00 
  80245b:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  80245d:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802462:	bf 00 00 00 00       	mov    $0x0,%edi
  802467:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  80246e:	00 00 00 
  802471:	ff d0                	callq  *%rax
  802473:	85 c0                	test   %eax,%eax
  802475:	79 54                	jns    8024cb <pgfault+0x193>
				panic("Page unmap from temp location failed");
  802477:	48 ba 58 5e 80 00 00 	movabs $0x805e58,%rdx
  80247e:	00 00 00 
  802481:	be 32 00 00 00       	mov    $0x32,%esi
  802486:	48 bf 2d 5e 80 00 00 	movabs $0x805e2d,%rdi
  80248d:	00 00 00 
  802490:	b8 00 00 00 00       	mov    $0x0,%eax
  802495:	48 b9 e4 08 80 00 00 	movabs $0x8008e4,%rcx
  80249c:	00 00 00 
  80249f:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  8024a1:	48 ba 80 5e 80 00 00 	movabs $0x805e80,%rdx
  8024a8:	00 00 00 
  8024ab:	be 34 00 00 00       	mov    $0x34,%esi
  8024b0:	48 bf 2d 5e 80 00 00 	movabs $0x805e2d,%rdi
  8024b7:	00 00 00 
  8024ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8024bf:	48 b9 e4 08 80 00 00 	movabs $0x8008e4,%rcx
  8024c6:	00 00 00 
  8024c9:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  8024cb:	c9                   	leaveq 
  8024cc:	c3                   	retq   

00000000008024cd <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8024cd:	55                   	push   %rbp
  8024ce:	48 89 e5             	mov    %rsp,%rbp
  8024d1:	48 83 ec 20          	sub    $0x20,%rsp
  8024d5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8024d8:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  8024db:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024e2:	01 00 00 
  8024e5:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8024e8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024ec:	25 07 0e 00 00       	and    $0xe07,%eax
  8024f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  8024f4:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8024f7:	48 c1 e0 0c          	shl    $0xc,%rax
  8024fb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  8024ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802502:	25 00 04 00 00       	and    $0x400,%eax
  802507:	85 c0                	test   %eax,%eax
  802509:	74 57                	je     802562 <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  80250b:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80250e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802512:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802515:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802519:	41 89 f0             	mov    %esi,%r8d
  80251c:	48 89 c6             	mov    %rax,%rsi
  80251f:	bf 00 00 00 00       	mov    $0x0,%edi
  802524:	48 b8 51 20 80 00 00 	movabs $0x802051,%rax
  80252b:	00 00 00 
  80252e:	ff d0                	callq  *%rax
  802530:	85 c0                	test   %eax,%eax
  802532:	0f 8e 52 01 00 00    	jle    80268a <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  802538:	48 ba b2 5e 80 00 00 	movabs $0x805eb2,%rdx
  80253f:	00 00 00 
  802542:	be 4e 00 00 00       	mov    $0x4e,%esi
  802547:	48 bf 2d 5e 80 00 00 	movabs $0x805e2d,%rdi
  80254e:	00 00 00 
  802551:	b8 00 00 00 00       	mov    $0x0,%eax
  802556:	48 b9 e4 08 80 00 00 	movabs $0x8008e4,%rcx
  80255d:	00 00 00 
  802560:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  802562:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802565:	83 e0 02             	and    $0x2,%eax
  802568:	85 c0                	test   %eax,%eax
  80256a:	75 10                	jne    80257c <duppage+0xaf>
  80256c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80256f:	25 00 08 00 00       	and    $0x800,%eax
  802574:	85 c0                	test   %eax,%eax
  802576:	0f 84 bb 00 00 00    	je     802637 <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  80257c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80257f:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  802584:	80 cc 08             	or     $0x8,%ah
  802587:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  80258a:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80258d:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802591:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802594:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802598:	41 89 f0             	mov    %esi,%r8d
  80259b:	48 89 c6             	mov    %rax,%rsi
  80259e:	bf 00 00 00 00       	mov    $0x0,%edi
  8025a3:	48 b8 51 20 80 00 00 	movabs $0x802051,%rax
  8025aa:	00 00 00 
  8025ad:	ff d0                	callq  *%rax
  8025af:	85 c0                	test   %eax,%eax
  8025b1:	7e 2a                	jle    8025dd <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  8025b3:	48 ba b2 5e 80 00 00 	movabs $0x805eb2,%rdx
  8025ba:	00 00 00 
  8025bd:	be 55 00 00 00       	mov    $0x55,%esi
  8025c2:	48 bf 2d 5e 80 00 00 	movabs $0x805e2d,%rdi
  8025c9:	00 00 00 
  8025cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d1:	48 b9 e4 08 80 00 00 	movabs $0x8008e4,%rcx
  8025d8:	00 00 00 
  8025db:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  8025dd:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  8025e0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025e8:	41 89 c8             	mov    %ecx,%r8d
  8025eb:	48 89 d1             	mov    %rdx,%rcx
  8025ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8025f3:	48 89 c6             	mov    %rax,%rsi
  8025f6:	bf 00 00 00 00       	mov    $0x0,%edi
  8025fb:	48 b8 51 20 80 00 00 	movabs $0x802051,%rax
  802602:	00 00 00 
  802605:	ff d0                	callq  *%rax
  802607:	85 c0                	test   %eax,%eax
  802609:	7e 2a                	jle    802635 <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  80260b:	48 ba b2 5e 80 00 00 	movabs $0x805eb2,%rdx
  802612:	00 00 00 
  802615:	be 57 00 00 00       	mov    $0x57,%esi
  80261a:	48 bf 2d 5e 80 00 00 	movabs $0x805e2d,%rdi
  802621:	00 00 00 
  802624:	b8 00 00 00 00       	mov    $0x0,%eax
  802629:	48 b9 e4 08 80 00 00 	movabs $0x8008e4,%rcx
  802630:	00 00 00 
  802633:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  802635:	eb 53                	jmp    80268a <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  802637:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80263a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80263e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802641:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802645:	41 89 f0             	mov    %esi,%r8d
  802648:	48 89 c6             	mov    %rax,%rsi
  80264b:	bf 00 00 00 00       	mov    $0x0,%edi
  802650:	48 b8 51 20 80 00 00 	movabs $0x802051,%rax
  802657:	00 00 00 
  80265a:	ff d0                	callq  *%rax
  80265c:	85 c0                	test   %eax,%eax
  80265e:	7e 2a                	jle    80268a <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  802660:	48 ba b2 5e 80 00 00 	movabs $0x805eb2,%rdx
  802667:	00 00 00 
  80266a:	be 5b 00 00 00       	mov    $0x5b,%esi
  80266f:	48 bf 2d 5e 80 00 00 	movabs $0x805e2d,%rdi
  802676:	00 00 00 
  802679:	b8 00 00 00 00       	mov    $0x0,%eax
  80267e:	48 b9 e4 08 80 00 00 	movabs $0x8008e4,%rcx
  802685:	00 00 00 
  802688:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  80268a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80268f:	c9                   	leaveq 
  802690:	c3                   	retq   

0000000000802691 <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  802691:	55                   	push   %rbp
  802692:	48 89 e5             	mov    %rsp,%rbp
  802695:	48 83 ec 18          	sub    $0x18,%rsp
  802699:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  80269d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026a1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  8026a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026a9:	48 c1 e8 27          	shr    $0x27,%rax
  8026ad:	48 89 c2             	mov    %rax,%rdx
  8026b0:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8026b7:	01 00 00 
  8026ba:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026be:	83 e0 01             	and    $0x1,%eax
  8026c1:	48 85 c0             	test   %rax,%rax
  8026c4:	74 51                	je     802717 <pt_is_mapped+0x86>
  8026c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026ca:	48 c1 e0 0c          	shl    $0xc,%rax
  8026ce:	48 c1 e8 1e          	shr    $0x1e,%rax
  8026d2:	48 89 c2             	mov    %rax,%rdx
  8026d5:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8026dc:	01 00 00 
  8026df:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026e3:	83 e0 01             	and    $0x1,%eax
  8026e6:	48 85 c0             	test   %rax,%rax
  8026e9:	74 2c                	je     802717 <pt_is_mapped+0x86>
  8026eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026ef:	48 c1 e0 0c          	shl    $0xc,%rax
  8026f3:	48 c1 e8 15          	shr    $0x15,%rax
  8026f7:	48 89 c2             	mov    %rax,%rdx
  8026fa:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802701:	01 00 00 
  802704:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802708:	83 e0 01             	and    $0x1,%eax
  80270b:	48 85 c0             	test   %rax,%rax
  80270e:	74 07                	je     802717 <pt_is_mapped+0x86>
  802710:	b8 01 00 00 00       	mov    $0x1,%eax
  802715:	eb 05                	jmp    80271c <pt_is_mapped+0x8b>
  802717:	b8 00 00 00 00       	mov    $0x0,%eax
  80271c:	83 e0 01             	and    $0x1,%eax
}
  80271f:	c9                   	leaveq 
  802720:	c3                   	retq   

0000000000802721 <fork>:

envid_t
fork(void)
{
  802721:	55                   	push   %rbp
  802722:	48 89 e5             	mov    %rsp,%rbp
  802725:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  802729:	48 bf 38 23 80 00 00 	movabs $0x802338,%rdi
  802730:	00 00 00 
  802733:	48 b8 9c 53 80 00 00 	movabs $0x80539c,%rax
  80273a:	00 00 00 
  80273d:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80273f:	b8 07 00 00 00       	mov    $0x7,%eax
  802744:	cd 30                	int    $0x30
  802746:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802749:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  80274c:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  80274f:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802753:	79 30                	jns    802785 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  802755:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802758:	89 c1                	mov    %eax,%ecx
  80275a:	48 ba d0 5e 80 00 00 	movabs $0x805ed0,%rdx
  802761:	00 00 00 
  802764:	be 86 00 00 00       	mov    $0x86,%esi
  802769:	48 bf 2d 5e 80 00 00 	movabs $0x805e2d,%rdi
  802770:	00 00 00 
  802773:	b8 00 00 00 00       	mov    $0x0,%eax
  802778:	49 b8 e4 08 80 00 00 	movabs $0x8008e4,%r8
  80277f:	00 00 00 
  802782:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  802785:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802789:	75 46                	jne    8027d1 <fork+0xb0>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  80278b:	48 b8 85 1f 80 00 00 	movabs $0x801f85,%rax
  802792:	00 00 00 
  802795:	ff d0                	callq  *%rax
  802797:	25 ff 03 00 00       	and    $0x3ff,%eax
  80279c:	48 63 d0             	movslq %eax,%rdx
  80279f:	48 89 d0             	mov    %rdx,%rax
  8027a2:	48 c1 e0 03          	shl    $0x3,%rax
  8027a6:	48 01 d0             	add    %rdx,%rax
  8027a9:	48 c1 e0 05          	shl    $0x5,%rax
  8027ad:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8027b4:	00 00 00 
  8027b7:	48 01 c2             	add    %rax,%rdx
  8027ba:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8027c1:	00 00 00 
  8027c4:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8027c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8027cc:	e9 d1 01 00 00       	jmpq   8029a2 <fork+0x281>
	}
	uint64_t ad = 0;
  8027d1:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8027d8:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8027d9:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  8027de:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8027e2:	e9 df 00 00 00       	jmpq   8028c6 <fork+0x1a5>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  8027e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027eb:	48 c1 e8 27          	shr    $0x27,%rax
  8027ef:	48 89 c2             	mov    %rax,%rdx
  8027f2:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8027f9:	01 00 00 
  8027fc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802800:	83 e0 01             	and    $0x1,%eax
  802803:	48 85 c0             	test   %rax,%rax
  802806:	0f 84 9e 00 00 00    	je     8028aa <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  80280c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802810:	48 c1 e8 1e          	shr    $0x1e,%rax
  802814:	48 89 c2             	mov    %rax,%rdx
  802817:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80281e:	01 00 00 
  802821:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802825:	83 e0 01             	and    $0x1,%eax
  802828:	48 85 c0             	test   %rax,%rax
  80282b:	74 73                	je     8028a0 <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  80282d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802831:	48 c1 e8 15          	shr    $0x15,%rax
  802835:	48 89 c2             	mov    %rax,%rdx
  802838:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80283f:	01 00 00 
  802842:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802846:	83 e0 01             	and    $0x1,%eax
  802849:	48 85 c0             	test   %rax,%rax
  80284c:	74 48                	je     802896 <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  80284e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802852:	48 c1 e8 0c          	shr    $0xc,%rax
  802856:	48 89 c2             	mov    %rax,%rdx
  802859:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802860:	01 00 00 
  802863:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802867:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80286b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80286f:	83 e0 01             	and    $0x1,%eax
  802872:	48 85 c0             	test   %rax,%rax
  802875:	74 47                	je     8028be <fork+0x19d>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  802877:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80287b:	48 c1 e8 0c          	shr    $0xc,%rax
  80287f:	89 c2                	mov    %eax,%edx
  802881:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802884:	89 d6                	mov    %edx,%esi
  802886:	89 c7                	mov    %eax,%edi
  802888:	48 b8 cd 24 80 00 00 	movabs $0x8024cd,%rax
  80288f:	00 00 00 
  802892:	ff d0                	callq  *%rax
  802894:	eb 28                	jmp    8028be <fork+0x19d>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  802896:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  80289d:	00 
  80289e:	eb 1e                	jmp    8028be <fork+0x19d>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  8028a0:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  8028a7:	40 
  8028a8:	eb 14                	jmp    8028be <fork+0x19d>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  8028aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028ae:	48 c1 e8 27          	shr    $0x27,%rax
  8028b2:	48 83 c0 01          	add    $0x1,%rax
  8028b6:	48 c1 e0 27          	shl    $0x27,%rax
  8028ba:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8028be:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  8028c5:	00 
  8028c6:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  8028cd:	00 
  8028ce:	0f 87 13 ff ff ff    	ja     8027e7 <fork+0xc6>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8028d4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8028d7:	ba 07 00 00 00       	mov    $0x7,%edx
  8028dc:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8028e1:	89 c7                	mov    %eax,%edi
  8028e3:	48 b8 01 20 80 00 00 	movabs $0x802001,%rax
  8028ea:	00 00 00 
  8028ed:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8028ef:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8028f2:	ba 07 00 00 00       	mov    $0x7,%edx
  8028f7:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8028fc:	89 c7                	mov    %eax,%edi
  8028fe:	48 b8 01 20 80 00 00 	movabs $0x802001,%rax
  802905:	00 00 00 
  802908:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  80290a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80290d:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802913:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  802918:	ba 00 00 00 00       	mov    $0x0,%edx
  80291d:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802922:	89 c7                	mov    %eax,%edi
  802924:	48 b8 51 20 80 00 00 	movabs $0x802051,%rax
  80292b:	00 00 00 
  80292e:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  802930:	ba 00 10 00 00       	mov    $0x1000,%edx
  802935:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80293a:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  80293f:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  802946:	00 00 00 
  802949:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  80294b:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802950:	bf 00 00 00 00       	mov    $0x0,%edi
  802955:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  80295c:	00 00 00 
  80295f:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  802961:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  802968:	00 00 00 
  80296b:	48 8b 00             	mov    (%rax),%rax
  80296e:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802975:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802978:	48 89 d6             	mov    %rdx,%rsi
  80297b:	89 c7                	mov    %eax,%edi
  80297d:	48 b8 8b 21 80 00 00 	movabs $0x80218b,%rax
  802984:	00 00 00 
  802987:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  802989:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80298c:	be 02 00 00 00       	mov    $0x2,%esi
  802991:	89 c7                	mov    %eax,%edi
  802993:	48 b8 f6 20 80 00 00 	movabs $0x8020f6,%rax
  80299a:	00 00 00 
  80299d:	ff d0                	callq  *%rax

	return envid;
  80299f:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  8029a2:	c9                   	leaveq 
  8029a3:	c3                   	retq   

00000000008029a4 <sfork>:

	
// Challenge!
int
sfork(void)
{
  8029a4:	55                   	push   %rbp
  8029a5:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8029a8:	48 ba e8 5e 80 00 00 	movabs $0x805ee8,%rdx
  8029af:	00 00 00 
  8029b2:	be bf 00 00 00       	mov    $0xbf,%esi
  8029b7:	48 bf 2d 5e 80 00 00 	movabs $0x805e2d,%rdi
  8029be:	00 00 00 
  8029c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8029c6:	48 b9 e4 08 80 00 00 	movabs $0x8008e4,%rcx
  8029cd:	00 00 00 
  8029d0:	ff d1                	callq  *%rcx

00000000008029d2 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8029d2:	55                   	push   %rbp
  8029d3:	48 89 e5             	mov    %rsp,%rbp
  8029d6:	48 83 ec 08          	sub    $0x8,%rsp
  8029da:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8029de:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8029e2:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8029e9:	ff ff ff 
  8029ec:	48 01 d0             	add    %rdx,%rax
  8029ef:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8029f3:	c9                   	leaveq 
  8029f4:	c3                   	retq   

00000000008029f5 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8029f5:	55                   	push   %rbp
  8029f6:	48 89 e5             	mov    %rsp,%rbp
  8029f9:	48 83 ec 08          	sub    $0x8,%rsp
  8029fd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802a01:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a05:	48 89 c7             	mov    %rax,%rdi
  802a08:	48 b8 d2 29 80 00 00 	movabs $0x8029d2,%rax
  802a0f:	00 00 00 
  802a12:	ff d0                	callq  *%rax
  802a14:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802a1a:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802a1e:	c9                   	leaveq 
  802a1f:	c3                   	retq   

0000000000802a20 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802a20:	55                   	push   %rbp
  802a21:	48 89 e5             	mov    %rsp,%rbp
  802a24:	48 83 ec 18          	sub    $0x18,%rsp
  802a28:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802a2c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a33:	eb 6b                	jmp    802aa0 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802a35:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a38:	48 98                	cltq   
  802a3a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802a40:	48 c1 e0 0c          	shl    $0xc,%rax
  802a44:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802a48:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a4c:	48 c1 e8 15          	shr    $0x15,%rax
  802a50:	48 89 c2             	mov    %rax,%rdx
  802a53:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802a5a:	01 00 00 
  802a5d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a61:	83 e0 01             	and    $0x1,%eax
  802a64:	48 85 c0             	test   %rax,%rax
  802a67:	74 21                	je     802a8a <fd_alloc+0x6a>
  802a69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a6d:	48 c1 e8 0c          	shr    $0xc,%rax
  802a71:	48 89 c2             	mov    %rax,%rdx
  802a74:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a7b:	01 00 00 
  802a7e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a82:	83 e0 01             	and    $0x1,%eax
  802a85:	48 85 c0             	test   %rax,%rax
  802a88:	75 12                	jne    802a9c <fd_alloc+0x7c>
			*fd_store = fd;
  802a8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a8e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a92:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802a95:	b8 00 00 00 00       	mov    $0x0,%eax
  802a9a:	eb 1a                	jmp    802ab6 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802a9c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802aa0:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802aa4:	7e 8f                	jle    802a35 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802aa6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aaa:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802ab1:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802ab6:	c9                   	leaveq 
  802ab7:	c3                   	retq   

0000000000802ab8 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802ab8:	55                   	push   %rbp
  802ab9:	48 89 e5             	mov    %rsp,%rbp
  802abc:	48 83 ec 20          	sub    $0x20,%rsp
  802ac0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ac3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802ac7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802acb:	78 06                	js     802ad3 <fd_lookup+0x1b>
  802acd:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802ad1:	7e 07                	jle    802ada <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802ad3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ad8:	eb 6c                	jmp    802b46 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802ada:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802add:	48 98                	cltq   
  802adf:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802ae5:	48 c1 e0 0c          	shl    $0xc,%rax
  802ae9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802aed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802af1:	48 c1 e8 15          	shr    $0x15,%rax
  802af5:	48 89 c2             	mov    %rax,%rdx
  802af8:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802aff:	01 00 00 
  802b02:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b06:	83 e0 01             	and    $0x1,%eax
  802b09:	48 85 c0             	test   %rax,%rax
  802b0c:	74 21                	je     802b2f <fd_lookup+0x77>
  802b0e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b12:	48 c1 e8 0c          	shr    $0xc,%rax
  802b16:	48 89 c2             	mov    %rax,%rdx
  802b19:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b20:	01 00 00 
  802b23:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b27:	83 e0 01             	and    $0x1,%eax
  802b2a:	48 85 c0             	test   %rax,%rax
  802b2d:	75 07                	jne    802b36 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802b2f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b34:	eb 10                	jmp    802b46 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802b36:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b3a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802b3e:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802b41:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b46:	c9                   	leaveq 
  802b47:	c3                   	retq   

0000000000802b48 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802b48:	55                   	push   %rbp
  802b49:	48 89 e5             	mov    %rsp,%rbp
  802b4c:	48 83 ec 30          	sub    $0x30,%rsp
  802b50:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802b54:	89 f0                	mov    %esi,%eax
  802b56:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802b59:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b5d:	48 89 c7             	mov    %rax,%rdi
  802b60:	48 b8 d2 29 80 00 00 	movabs $0x8029d2,%rax
  802b67:	00 00 00 
  802b6a:	ff d0                	callq  *%rax
  802b6c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b70:	48 89 d6             	mov    %rdx,%rsi
  802b73:	89 c7                	mov    %eax,%edi
  802b75:	48 b8 b8 2a 80 00 00 	movabs $0x802ab8,%rax
  802b7c:	00 00 00 
  802b7f:	ff d0                	callq  *%rax
  802b81:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b84:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b88:	78 0a                	js     802b94 <fd_close+0x4c>
	    || fd != fd2)
  802b8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b8e:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802b92:	74 12                	je     802ba6 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802b94:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802b98:	74 05                	je     802b9f <fd_close+0x57>
  802b9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b9d:	eb 05                	jmp    802ba4 <fd_close+0x5c>
  802b9f:	b8 00 00 00 00       	mov    $0x0,%eax
  802ba4:	eb 69                	jmp    802c0f <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802ba6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802baa:	8b 00                	mov    (%rax),%eax
  802bac:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802bb0:	48 89 d6             	mov    %rdx,%rsi
  802bb3:	89 c7                	mov    %eax,%edi
  802bb5:	48 b8 11 2c 80 00 00 	movabs $0x802c11,%rax
  802bbc:	00 00 00 
  802bbf:	ff d0                	callq  *%rax
  802bc1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bc4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bc8:	78 2a                	js     802bf4 <fd_close+0xac>
		if (dev->dev_close)
  802bca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bce:	48 8b 40 20          	mov    0x20(%rax),%rax
  802bd2:	48 85 c0             	test   %rax,%rax
  802bd5:	74 16                	je     802bed <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802bd7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bdb:	48 8b 40 20          	mov    0x20(%rax),%rax
  802bdf:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802be3:	48 89 d7             	mov    %rdx,%rdi
  802be6:	ff d0                	callq  *%rax
  802be8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802beb:	eb 07                	jmp    802bf4 <fd_close+0xac>
		else
			r = 0;
  802bed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802bf4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bf8:	48 89 c6             	mov    %rax,%rsi
  802bfb:	bf 00 00 00 00       	mov    $0x0,%edi
  802c00:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  802c07:	00 00 00 
  802c0a:	ff d0                	callq  *%rax
	return r;
  802c0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c0f:	c9                   	leaveq 
  802c10:	c3                   	retq   

0000000000802c11 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802c11:	55                   	push   %rbp
  802c12:	48 89 e5             	mov    %rsp,%rbp
  802c15:	48 83 ec 20          	sub    $0x20,%rsp
  802c19:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c1c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802c20:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802c27:	eb 41                	jmp    802c6a <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802c29:	48 b8 40 80 80 00 00 	movabs $0x808040,%rax
  802c30:	00 00 00 
  802c33:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802c36:	48 63 d2             	movslq %edx,%rdx
  802c39:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c3d:	8b 00                	mov    (%rax),%eax
  802c3f:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802c42:	75 22                	jne    802c66 <dev_lookup+0x55>
			*dev = devtab[i];
  802c44:	48 b8 40 80 80 00 00 	movabs $0x808040,%rax
  802c4b:	00 00 00 
  802c4e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802c51:	48 63 d2             	movslq %edx,%rdx
  802c54:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802c58:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c5c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802c5f:	b8 00 00 00 00       	mov    $0x0,%eax
  802c64:	eb 60                	jmp    802cc6 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802c66:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802c6a:	48 b8 40 80 80 00 00 	movabs $0x808040,%rax
  802c71:	00 00 00 
  802c74:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802c77:	48 63 d2             	movslq %edx,%rdx
  802c7a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c7e:	48 85 c0             	test   %rax,%rax
  802c81:	75 a6                	jne    802c29 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802c83:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  802c8a:	00 00 00 
  802c8d:	48 8b 00             	mov    (%rax),%rax
  802c90:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c96:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802c99:	89 c6                	mov    %eax,%esi
  802c9b:	48 bf 00 5f 80 00 00 	movabs $0x805f00,%rdi
  802ca2:	00 00 00 
  802ca5:	b8 00 00 00 00       	mov    $0x0,%eax
  802caa:	48 b9 1d 0b 80 00 00 	movabs $0x800b1d,%rcx
  802cb1:	00 00 00 
  802cb4:	ff d1                	callq  *%rcx
	*dev = 0;
  802cb6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cba:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802cc1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802cc6:	c9                   	leaveq 
  802cc7:	c3                   	retq   

0000000000802cc8 <close>:

int
close(int fdnum)
{
  802cc8:	55                   	push   %rbp
  802cc9:	48 89 e5             	mov    %rsp,%rbp
  802ccc:	48 83 ec 20          	sub    $0x20,%rsp
  802cd0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802cd3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802cd7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cda:	48 89 d6             	mov    %rdx,%rsi
  802cdd:	89 c7                	mov    %eax,%edi
  802cdf:	48 b8 b8 2a 80 00 00 	movabs $0x802ab8,%rax
  802ce6:	00 00 00 
  802ce9:	ff d0                	callq  *%rax
  802ceb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cf2:	79 05                	jns    802cf9 <close+0x31>
		return r;
  802cf4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cf7:	eb 18                	jmp    802d11 <close+0x49>
	else
		return fd_close(fd, 1);
  802cf9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cfd:	be 01 00 00 00       	mov    $0x1,%esi
  802d02:	48 89 c7             	mov    %rax,%rdi
  802d05:	48 b8 48 2b 80 00 00 	movabs $0x802b48,%rax
  802d0c:	00 00 00 
  802d0f:	ff d0                	callq  *%rax
}
  802d11:	c9                   	leaveq 
  802d12:	c3                   	retq   

0000000000802d13 <close_all>:

void
close_all(void)
{
  802d13:	55                   	push   %rbp
  802d14:	48 89 e5             	mov    %rsp,%rbp
  802d17:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802d1b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802d22:	eb 15                	jmp    802d39 <close_all+0x26>
		close(i);
  802d24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d27:	89 c7                	mov    %eax,%edi
  802d29:	48 b8 c8 2c 80 00 00 	movabs $0x802cc8,%rax
  802d30:	00 00 00 
  802d33:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802d35:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802d39:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802d3d:	7e e5                	jle    802d24 <close_all+0x11>
		close(i);
}
  802d3f:	c9                   	leaveq 
  802d40:	c3                   	retq   

0000000000802d41 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802d41:	55                   	push   %rbp
  802d42:	48 89 e5             	mov    %rsp,%rbp
  802d45:	48 83 ec 40          	sub    $0x40,%rsp
  802d49:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802d4c:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802d4f:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802d53:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802d56:	48 89 d6             	mov    %rdx,%rsi
  802d59:	89 c7                	mov    %eax,%edi
  802d5b:	48 b8 b8 2a 80 00 00 	movabs $0x802ab8,%rax
  802d62:	00 00 00 
  802d65:	ff d0                	callq  *%rax
  802d67:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d6a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d6e:	79 08                	jns    802d78 <dup+0x37>
		return r;
  802d70:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d73:	e9 70 01 00 00       	jmpq   802ee8 <dup+0x1a7>
	close(newfdnum);
  802d78:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802d7b:	89 c7                	mov    %eax,%edi
  802d7d:	48 b8 c8 2c 80 00 00 	movabs $0x802cc8,%rax
  802d84:	00 00 00 
  802d87:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802d89:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802d8c:	48 98                	cltq   
  802d8e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802d94:	48 c1 e0 0c          	shl    $0xc,%rax
  802d98:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802d9c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802da0:	48 89 c7             	mov    %rax,%rdi
  802da3:	48 b8 f5 29 80 00 00 	movabs $0x8029f5,%rax
  802daa:	00 00 00 
  802dad:	ff d0                	callq  *%rax
  802daf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802db3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802db7:	48 89 c7             	mov    %rax,%rdi
  802dba:	48 b8 f5 29 80 00 00 	movabs $0x8029f5,%rax
  802dc1:	00 00 00 
  802dc4:	ff d0                	callq  *%rax
  802dc6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802dca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dce:	48 c1 e8 15          	shr    $0x15,%rax
  802dd2:	48 89 c2             	mov    %rax,%rdx
  802dd5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802ddc:	01 00 00 
  802ddf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802de3:	83 e0 01             	and    $0x1,%eax
  802de6:	48 85 c0             	test   %rax,%rax
  802de9:	74 73                	je     802e5e <dup+0x11d>
  802deb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802def:	48 c1 e8 0c          	shr    $0xc,%rax
  802df3:	48 89 c2             	mov    %rax,%rdx
  802df6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802dfd:	01 00 00 
  802e00:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e04:	83 e0 01             	and    $0x1,%eax
  802e07:	48 85 c0             	test   %rax,%rax
  802e0a:	74 52                	je     802e5e <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802e0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e10:	48 c1 e8 0c          	shr    $0xc,%rax
  802e14:	48 89 c2             	mov    %rax,%rdx
  802e17:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802e1e:	01 00 00 
  802e21:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e25:	25 07 0e 00 00       	and    $0xe07,%eax
  802e2a:	89 c1                	mov    %eax,%ecx
  802e2c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802e30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e34:	41 89 c8             	mov    %ecx,%r8d
  802e37:	48 89 d1             	mov    %rdx,%rcx
  802e3a:	ba 00 00 00 00       	mov    $0x0,%edx
  802e3f:	48 89 c6             	mov    %rax,%rsi
  802e42:	bf 00 00 00 00       	mov    $0x0,%edi
  802e47:	48 b8 51 20 80 00 00 	movabs $0x802051,%rax
  802e4e:	00 00 00 
  802e51:	ff d0                	callq  *%rax
  802e53:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e56:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e5a:	79 02                	jns    802e5e <dup+0x11d>
			goto err;
  802e5c:	eb 57                	jmp    802eb5 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802e5e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e62:	48 c1 e8 0c          	shr    $0xc,%rax
  802e66:	48 89 c2             	mov    %rax,%rdx
  802e69:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802e70:	01 00 00 
  802e73:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e77:	25 07 0e 00 00       	and    $0xe07,%eax
  802e7c:	89 c1                	mov    %eax,%ecx
  802e7e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e82:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e86:	41 89 c8             	mov    %ecx,%r8d
  802e89:	48 89 d1             	mov    %rdx,%rcx
  802e8c:	ba 00 00 00 00       	mov    $0x0,%edx
  802e91:	48 89 c6             	mov    %rax,%rsi
  802e94:	bf 00 00 00 00       	mov    $0x0,%edi
  802e99:	48 b8 51 20 80 00 00 	movabs $0x802051,%rax
  802ea0:	00 00 00 
  802ea3:	ff d0                	callq  *%rax
  802ea5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ea8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802eac:	79 02                	jns    802eb0 <dup+0x16f>
		goto err;
  802eae:	eb 05                	jmp    802eb5 <dup+0x174>

	return newfdnum;
  802eb0:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802eb3:	eb 33                	jmp    802ee8 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802eb5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eb9:	48 89 c6             	mov    %rax,%rsi
  802ebc:	bf 00 00 00 00       	mov    $0x0,%edi
  802ec1:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  802ec8:	00 00 00 
  802ecb:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802ecd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ed1:	48 89 c6             	mov    %rax,%rsi
  802ed4:	bf 00 00 00 00       	mov    $0x0,%edi
  802ed9:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  802ee0:	00 00 00 
  802ee3:	ff d0                	callq  *%rax
	return r;
  802ee5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802ee8:	c9                   	leaveq 
  802ee9:	c3                   	retq   

0000000000802eea <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802eea:	55                   	push   %rbp
  802eeb:	48 89 e5             	mov    %rsp,%rbp
  802eee:	48 83 ec 40          	sub    $0x40,%rsp
  802ef2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ef5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802ef9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802efd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802f01:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f04:	48 89 d6             	mov    %rdx,%rsi
  802f07:	89 c7                	mov    %eax,%edi
  802f09:	48 b8 b8 2a 80 00 00 	movabs $0x802ab8,%rax
  802f10:	00 00 00 
  802f13:	ff d0                	callq  *%rax
  802f15:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f18:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f1c:	78 24                	js     802f42 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f1e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f22:	8b 00                	mov    (%rax),%eax
  802f24:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f28:	48 89 d6             	mov    %rdx,%rsi
  802f2b:	89 c7                	mov    %eax,%edi
  802f2d:	48 b8 11 2c 80 00 00 	movabs $0x802c11,%rax
  802f34:	00 00 00 
  802f37:	ff d0                	callq  *%rax
  802f39:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f3c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f40:	79 05                	jns    802f47 <read+0x5d>
		return r;
  802f42:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f45:	eb 76                	jmp    802fbd <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802f47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f4b:	8b 40 08             	mov    0x8(%rax),%eax
  802f4e:	83 e0 03             	and    $0x3,%eax
  802f51:	83 f8 01             	cmp    $0x1,%eax
  802f54:	75 3a                	jne    802f90 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802f56:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  802f5d:	00 00 00 
  802f60:	48 8b 00             	mov    (%rax),%rax
  802f63:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802f69:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802f6c:	89 c6                	mov    %eax,%esi
  802f6e:	48 bf 1f 5f 80 00 00 	movabs $0x805f1f,%rdi
  802f75:	00 00 00 
  802f78:	b8 00 00 00 00       	mov    $0x0,%eax
  802f7d:	48 b9 1d 0b 80 00 00 	movabs $0x800b1d,%rcx
  802f84:	00 00 00 
  802f87:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802f89:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802f8e:	eb 2d                	jmp    802fbd <read+0xd3>
	}
	if (!dev->dev_read)
  802f90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f94:	48 8b 40 10          	mov    0x10(%rax),%rax
  802f98:	48 85 c0             	test   %rax,%rax
  802f9b:	75 07                	jne    802fa4 <read+0xba>
		return -E_NOT_SUPP;
  802f9d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802fa2:	eb 19                	jmp    802fbd <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802fa4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fa8:	48 8b 40 10          	mov    0x10(%rax),%rax
  802fac:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802fb0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802fb4:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802fb8:	48 89 cf             	mov    %rcx,%rdi
  802fbb:	ff d0                	callq  *%rax
}
  802fbd:	c9                   	leaveq 
  802fbe:	c3                   	retq   

0000000000802fbf <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802fbf:	55                   	push   %rbp
  802fc0:	48 89 e5             	mov    %rsp,%rbp
  802fc3:	48 83 ec 30          	sub    $0x30,%rsp
  802fc7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fca:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802fce:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802fd2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802fd9:	eb 49                	jmp    803024 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802fdb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fde:	48 98                	cltq   
  802fe0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802fe4:	48 29 c2             	sub    %rax,%rdx
  802fe7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fea:	48 63 c8             	movslq %eax,%rcx
  802fed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ff1:	48 01 c1             	add    %rax,%rcx
  802ff4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ff7:	48 89 ce             	mov    %rcx,%rsi
  802ffa:	89 c7                	mov    %eax,%edi
  802ffc:	48 b8 ea 2e 80 00 00 	movabs $0x802eea,%rax
  803003:	00 00 00 
  803006:	ff d0                	callq  *%rax
  803008:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80300b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80300f:	79 05                	jns    803016 <readn+0x57>
			return m;
  803011:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803014:	eb 1c                	jmp    803032 <readn+0x73>
		if (m == 0)
  803016:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80301a:	75 02                	jne    80301e <readn+0x5f>
			break;
  80301c:	eb 11                	jmp    80302f <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80301e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803021:	01 45 fc             	add    %eax,-0x4(%rbp)
  803024:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803027:	48 98                	cltq   
  803029:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80302d:	72 ac                	jb     802fdb <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80302f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803032:	c9                   	leaveq 
  803033:	c3                   	retq   

0000000000803034 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  803034:	55                   	push   %rbp
  803035:	48 89 e5             	mov    %rsp,%rbp
  803038:	48 83 ec 40          	sub    $0x40,%rsp
  80303c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80303f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803043:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  803047:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80304b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80304e:	48 89 d6             	mov    %rdx,%rsi
  803051:	89 c7                	mov    %eax,%edi
  803053:	48 b8 b8 2a 80 00 00 	movabs $0x802ab8,%rax
  80305a:	00 00 00 
  80305d:	ff d0                	callq  *%rax
  80305f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803062:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803066:	78 24                	js     80308c <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803068:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80306c:	8b 00                	mov    (%rax),%eax
  80306e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803072:	48 89 d6             	mov    %rdx,%rsi
  803075:	89 c7                	mov    %eax,%edi
  803077:	48 b8 11 2c 80 00 00 	movabs $0x802c11,%rax
  80307e:	00 00 00 
  803081:	ff d0                	callq  *%rax
  803083:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803086:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80308a:	79 05                	jns    803091 <write+0x5d>
		return r;
  80308c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80308f:	eb 75                	jmp    803106 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803091:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803095:	8b 40 08             	mov    0x8(%rax),%eax
  803098:	83 e0 03             	and    $0x3,%eax
  80309b:	85 c0                	test   %eax,%eax
  80309d:	75 3a                	jne    8030d9 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80309f:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8030a6:	00 00 00 
  8030a9:	48 8b 00             	mov    (%rax),%rax
  8030ac:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8030b2:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8030b5:	89 c6                	mov    %eax,%esi
  8030b7:	48 bf 3b 5f 80 00 00 	movabs $0x805f3b,%rdi
  8030be:	00 00 00 
  8030c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8030c6:	48 b9 1d 0b 80 00 00 	movabs $0x800b1d,%rcx
  8030cd:	00 00 00 
  8030d0:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8030d2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8030d7:	eb 2d                	jmp    803106 <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  8030d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030dd:	48 8b 40 18          	mov    0x18(%rax),%rax
  8030e1:	48 85 c0             	test   %rax,%rax
  8030e4:	75 07                	jne    8030ed <write+0xb9>
		return -E_NOT_SUPP;
  8030e6:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8030eb:	eb 19                	jmp    803106 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8030ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030f1:	48 8b 40 18          	mov    0x18(%rax),%rax
  8030f5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8030f9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8030fd:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803101:	48 89 cf             	mov    %rcx,%rdi
  803104:	ff d0                	callq  *%rax
}
  803106:	c9                   	leaveq 
  803107:	c3                   	retq   

0000000000803108 <seek>:

int
seek(int fdnum, off_t offset)
{
  803108:	55                   	push   %rbp
  803109:	48 89 e5             	mov    %rsp,%rbp
  80310c:	48 83 ec 18          	sub    $0x18,%rsp
  803110:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803113:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803116:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80311a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80311d:	48 89 d6             	mov    %rdx,%rsi
  803120:	89 c7                	mov    %eax,%edi
  803122:	48 b8 b8 2a 80 00 00 	movabs $0x802ab8,%rax
  803129:	00 00 00 
  80312c:	ff d0                	callq  *%rax
  80312e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803131:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803135:	79 05                	jns    80313c <seek+0x34>
		return r;
  803137:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80313a:	eb 0f                	jmp    80314b <seek+0x43>
	fd->fd_offset = offset;
  80313c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803140:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803143:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  803146:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80314b:	c9                   	leaveq 
  80314c:	c3                   	retq   

000000000080314d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80314d:	55                   	push   %rbp
  80314e:	48 89 e5             	mov    %rsp,%rbp
  803151:	48 83 ec 30          	sub    $0x30,%rsp
  803155:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803158:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80315b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80315f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803162:	48 89 d6             	mov    %rdx,%rsi
  803165:	89 c7                	mov    %eax,%edi
  803167:	48 b8 b8 2a 80 00 00 	movabs $0x802ab8,%rax
  80316e:	00 00 00 
  803171:	ff d0                	callq  *%rax
  803173:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803176:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80317a:	78 24                	js     8031a0 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80317c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803180:	8b 00                	mov    (%rax),%eax
  803182:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803186:	48 89 d6             	mov    %rdx,%rsi
  803189:	89 c7                	mov    %eax,%edi
  80318b:	48 b8 11 2c 80 00 00 	movabs $0x802c11,%rax
  803192:	00 00 00 
  803195:	ff d0                	callq  *%rax
  803197:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80319a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80319e:	79 05                	jns    8031a5 <ftruncate+0x58>
		return r;
  8031a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031a3:	eb 72                	jmp    803217 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8031a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031a9:	8b 40 08             	mov    0x8(%rax),%eax
  8031ac:	83 e0 03             	and    $0x3,%eax
  8031af:	85 c0                	test   %eax,%eax
  8031b1:	75 3a                	jne    8031ed <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8031b3:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8031ba:	00 00 00 
  8031bd:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8031c0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8031c6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8031c9:	89 c6                	mov    %eax,%esi
  8031cb:	48 bf 58 5f 80 00 00 	movabs $0x805f58,%rdi
  8031d2:	00 00 00 
  8031d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8031da:	48 b9 1d 0b 80 00 00 	movabs $0x800b1d,%rcx
  8031e1:	00 00 00 
  8031e4:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8031e6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8031eb:	eb 2a                	jmp    803217 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8031ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031f1:	48 8b 40 30          	mov    0x30(%rax),%rax
  8031f5:	48 85 c0             	test   %rax,%rax
  8031f8:	75 07                	jne    803201 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8031fa:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8031ff:	eb 16                	jmp    803217 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  803201:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803205:	48 8b 40 30          	mov    0x30(%rax),%rax
  803209:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80320d:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  803210:	89 ce                	mov    %ecx,%esi
  803212:	48 89 d7             	mov    %rdx,%rdi
  803215:	ff d0                	callq  *%rax
}
  803217:	c9                   	leaveq 
  803218:	c3                   	retq   

0000000000803219 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  803219:	55                   	push   %rbp
  80321a:	48 89 e5             	mov    %rsp,%rbp
  80321d:	48 83 ec 30          	sub    $0x30,%rsp
  803221:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803224:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803228:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80322c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80322f:	48 89 d6             	mov    %rdx,%rsi
  803232:	89 c7                	mov    %eax,%edi
  803234:	48 b8 b8 2a 80 00 00 	movabs $0x802ab8,%rax
  80323b:	00 00 00 
  80323e:	ff d0                	callq  *%rax
  803240:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803243:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803247:	78 24                	js     80326d <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803249:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80324d:	8b 00                	mov    (%rax),%eax
  80324f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803253:	48 89 d6             	mov    %rdx,%rsi
  803256:	89 c7                	mov    %eax,%edi
  803258:	48 b8 11 2c 80 00 00 	movabs $0x802c11,%rax
  80325f:	00 00 00 
  803262:	ff d0                	callq  *%rax
  803264:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803267:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80326b:	79 05                	jns    803272 <fstat+0x59>
		return r;
  80326d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803270:	eb 5e                	jmp    8032d0 <fstat+0xb7>
	if (!dev->dev_stat)
  803272:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803276:	48 8b 40 28          	mov    0x28(%rax),%rax
  80327a:	48 85 c0             	test   %rax,%rax
  80327d:	75 07                	jne    803286 <fstat+0x6d>
		return -E_NOT_SUPP;
  80327f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803284:	eb 4a                	jmp    8032d0 <fstat+0xb7>
	stat->st_name[0] = 0;
  803286:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80328a:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80328d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803291:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  803298:	00 00 00 
	stat->st_isdir = 0;
  80329b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80329f:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8032a6:	00 00 00 
	stat->st_dev = dev;
  8032a9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8032ad:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032b1:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8032b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032bc:	48 8b 40 28          	mov    0x28(%rax),%rax
  8032c0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8032c4:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8032c8:	48 89 ce             	mov    %rcx,%rsi
  8032cb:	48 89 d7             	mov    %rdx,%rdi
  8032ce:	ff d0                	callq  *%rax
}
  8032d0:	c9                   	leaveq 
  8032d1:	c3                   	retq   

00000000008032d2 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8032d2:	55                   	push   %rbp
  8032d3:	48 89 e5             	mov    %rsp,%rbp
  8032d6:	48 83 ec 20          	sub    $0x20,%rsp
  8032da:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8032de:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8032e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032e6:	be 00 00 00 00       	mov    $0x0,%esi
  8032eb:	48 89 c7             	mov    %rax,%rdi
  8032ee:	48 b8 c0 33 80 00 00 	movabs $0x8033c0,%rax
  8032f5:	00 00 00 
  8032f8:	ff d0                	callq  *%rax
  8032fa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803301:	79 05                	jns    803308 <stat+0x36>
		return fd;
  803303:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803306:	eb 2f                	jmp    803337 <stat+0x65>
	r = fstat(fd, stat);
  803308:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80330c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80330f:	48 89 d6             	mov    %rdx,%rsi
  803312:	89 c7                	mov    %eax,%edi
  803314:	48 b8 19 32 80 00 00 	movabs $0x803219,%rax
  80331b:	00 00 00 
  80331e:	ff d0                	callq  *%rax
  803320:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  803323:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803326:	89 c7                	mov    %eax,%edi
  803328:	48 b8 c8 2c 80 00 00 	movabs $0x802cc8,%rax
  80332f:	00 00 00 
  803332:	ff d0                	callq  *%rax
	return r;
  803334:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  803337:	c9                   	leaveq 
  803338:	c3                   	retq   

0000000000803339 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  803339:	55                   	push   %rbp
  80333a:	48 89 e5             	mov    %rsp,%rbp
  80333d:	48 83 ec 10          	sub    $0x10,%rsp
  803341:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803344:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  803348:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80334f:	00 00 00 
  803352:	8b 00                	mov    (%rax),%eax
  803354:	85 c0                	test   %eax,%eax
  803356:	75 1d                	jne    803375 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  803358:	bf 01 00 00 00       	mov    $0x1,%edi
  80335d:	48 b8 44 56 80 00 00 	movabs $0x805644,%rax
  803364:	00 00 00 
  803367:	ff d0                	callq  *%rax
  803369:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  803370:	00 00 00 
  803373:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803375:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80337c:	00 00 00 
  80337f:	8b 00                	mov    (%rax),%eax
  803381:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803384:	b9 07 00 00 00       	mov    $0x7,%ecx
  803389:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  803390:	00 00 00 
  803393:	89 c7                	mov    %eax,%edi
  803395:	48 b8 e2 55 80 00 00 	movabs $0x8055e2,%rax
  80339c:	00 00 00 
  80339f:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8033a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8033aa:	48 89 c6             	mov    %rax,%rsi
  8033ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8033b2:	48 b8 dc 54 80 00 00 	movabs $0x8054dc,%rax
  8033b9:	00 00 00 
  8033bc:	ff d0                	callq  *%rax
}
  8033be:	c9                   	leaveq 
  8033bf:	c3                   	retq   

00000000008033c0 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8033c0:	55                   	push   %rbp
  8033c1:	48 89 e5             	mov    %rsp,%rbp
  8033c4:	48 83 ec 30          	sub    $0x30,%rsp
  8033c8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8033cc:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  8033cf:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  8033d6:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  8033dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  8033e4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8033e9:	75 08                	jne    8033f3 <open+0x33>
	{
		return r;
  8033eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033ee:	e9 f2 00 00 00       	jmpq   8034e5 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  8033f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033f7:	48 89 c7             	mov    %rax,%rdi
  8033fa:	48 b8 66 16 80 00 00 	movabs $0x801666,%rax
  803401:	00 00 00 
  803404:	ff d0                	callq  *%rax
  803406:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803409:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  803410:	7e 0a                	jle    80341c <open+0x5c>
	{
		return -E_BAD_PATH;
  803412:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803417:	e9 c9 00 00 00       	jmpq   8034e5 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  80341c:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  803423:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  803424:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  803428:	48 89 c7             	mov    %rax,%rdi
  80342b:	48 b8 20 2a 80 00 00 	movabs $0x802a20,%rax
  803432:	00 00 00 
  803435:	ff d0                	callq  *%rax
  803437:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80343a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80343e:	78 09                	js     803449 <open+0x89>
  803440:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803444:	48 85 c0             	test   %rax,%rax
  803447:	75 08                	jne    803451 <open+0x91>
		{
			return r;
  803449:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80344c:	e9 94 00 00 00       	jmpq   8034e5 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  803451:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803455:	ba 00 04 00 00       	mov    $0x400,%edx
  80345a:	48 89 c6             	mov    %rax,%rsi
  80345d:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  803464:	00 00 00 
  803467:	48 b8 64 17 80 00 00 	movabs $0x801764,%rax
  80346e:	00 00 00 
  803471:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  803473:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80347a:	00 00 00 
  80347d:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  803480:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  803486:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80348a:	48 89 c6             	mov    %rax,%rsi
  80348d:	bf 01 00 00 00       	mov    $0x1,%edi
  803492:	48 b8 39 33 80 00 00 	movabs $0x803339,%rax
  803499:	00 00 00 
  80349c:	ff d0                	callq  *%rax
  80349e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034a5:	79 2b                	jns    8034d2 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  8034a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034ab:	be 00 00 00 00       	mov    $0x0,%esi
  8034b0:	48 89 c7             	mov    %rax,%rdi
  8034b3:	48 b8 48 2b 80 00 00 	movabs $0x802b48,%rax
  8034ba:	00 00 00 
  8034bd:	ff d0                	callq  *%rax
  8034bf:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8034c2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8034c6:	79 05                	jns    8034cd <open+0x10d>
			{
				return d;
  8034c8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034cb:	eb 18                	jmp    8034e5 <open+0x125>
			}
			return r;
  8034cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034d0:	eb 13                	jmp    8034e5 <open+0x125>
		}	
		return fd2num(fd_store);
  8034d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034d6:	48 89 c7             	mov    %rax,%rdi
  8034d9:	48 b8 d2 29 80 00 00 	movabs $0x8029d2,%rax
  8034e0:	00 00 00 
  8034e3:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  8034e5:	c9                   	leaveq 
  8034e6:	c3                   	retq   

00000000008034e7 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8034e7:	55                   	push   %rbp
  8034e8:	48 89 e5             	mov    %rsp,%rbp
  8034eb:	48 83 ec 10          	sub    $0x10,%rsp
  8034ef:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8034f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034f7:	8b 50 0c             	mov    0xc(%rax),%edx
  8034fa:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803501:	00 00 00 
  803504:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  803506:	be 00 00 00 00       	mov    $0x0,%esi
  80350b:	bf 06 00 00 00       	mov    $0x6,%edi
  803510:	48 b8 39 33 80 00 00 	movabs $0x803339,%rax
  803517:	00 00 00 
  80351a:	ff d0                	callq  *%rax
}
  80351c:	c9                   	leaveq 
  80351d:	c3                   	retq   

000000000080351e <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80351e:	55                   	push   %rbp
  80351f:	48 89 e5             	mov    %rsp,%rbp
  803522:	48 83 ec 30          	sub    $0x30,%rsp
  803526:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80352a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80352e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  803532:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  803539:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80353e:	74 07                	je     803547 <devfile_read+0x29>
  803540:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803545:	75 07                	jne    80354e <devfile_read+0x30>
		return -E_INVAL;
  803547:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80354c:	eb 77                	jmp    8035c5 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80354e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803552:	8b 50 0c             	mov    0xc(%rax),%edx
  803555:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80355c:	00 00 00 
  80355f:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  803561:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803568:	00 00 00 
  80356b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80356f:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  803573:	be 00 00 00 00       	mov    $0x0,%esi
  803578:	bf 03 00 00 00       	mov    $0x3,%edi
  80357d:	48 b8 39 33 80 00 00 	movabs $0x803339,%rax
  803584:	00 00 00 
  803587:	ff d0                	callq  *%rax
  803589:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80358c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803590:	7f 05                	jg     803597 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  803592:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803595:	eb 2e                	jmp    8035c5 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  803597:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80359a:	48 63 d0             	movslq %eax,%rdx
  80359d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035a1:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8035a8:	00 00 00 
  8035ab:	48 89 c7             	mov    %rax,%rdi
  8035ae:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  8035b5:	00 00 00 
  8035b8:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  8035ba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035be:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  8035c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8035c5:	c9                   	leaveq 
  8035c6:	c3                   	retq   

00000000008035c7 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8035c7:	55                   	push   %rbp
  8035c8:	48 89 e5             	mov    %rsp,%rbp
  8035cb:	48 83 ec 30          	sub    $0x30,%rsp
  8035cf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8035d3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8035d7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  8035db:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  8035e2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8035e7:	74 07                	je     8035f0 <devfile_write+0x29>
  8035e9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8035ee:	75 08                	jne    8035f8 <devfile_write+0x31>
		return r;
  8035f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035f3:	e9 9a 00 00 00       	jmpq   803692 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8035f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035fc:	8b 50 0c             	mov    0xc(%rax),%edx
  8035ff:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803606:	00 00 00 
  803609:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  80360b:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  803612:	00 
  803613:	76 08                	jbe    80361d <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  803615:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  80361c:	00 
	}
	fsipcbuf.write.req_n = n;
  80361d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803624:	00 00 00 
  803627:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80362b:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  80362f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803633:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803637:	48 89 c6             	mov    %rax,%rsi
  80363a:	48 bf 10 a0 80 00 00 	movabs $0x80a010,%rdi
  803641:	00 00 00 
  803644:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  80364b:	00 00 00 
  80364e:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  803650:	be 00 00 00 00       	mov    $0x0,%esi
  803655:	bf 04 00 00 00       	mov    $0x4,%edi
  80365a:	48 b8 39 33 80 00 00 	movabs $0x803339,%rax
  803661:	00 00 00 
  803664:	ff d0                	callq  *%rax
  803666:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803669:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80366d:	7f 20                	jg     80368f <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  80366f:	48 bf 7e 5f 80 00 00 	movabs $0x805f7e,%rdi
  803676:	00 00 00 
  803679:	b8 00 00 00 00       	mov    $0x0,%eax
  80367e:	48 ba 1d 0b 80 00 00 	movabs $0x800b1d,%rdx
  803685:	00 00 00 
  803688:	ff d2                	callq  *%rdx
		return r;
  80368a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80368d:	eb 03                	jmp    803692 <devfile_write+0xcb>
	}
	return r;
  80368f:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  803692:	c9                   	leaveq 
  803693:	c3                   	retq   

0000000000803694 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803694:	55                   	push   %rbp
  803695:	48 89 e5             	mov    %rsp,%rbp
  803698:	48 83 ec 20          	sub    $0x20,%rsp
  80369c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8036a0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8036a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036a8:	8b 50 0c             	mov    0xc(%rax),%edx
  8036ab:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036b2:	00 00 00 
  8036b5:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8036b7:	be 00 00 00 00       	mov    $0x0,%esi
  8036bc:	bf 05 00 00 00       	mov    $0x5,%edi
  8036c1:	48 b8 39 33 80 00 00 	movabs $0x803339,%rax
  8036c8:	00 00 00 
  8036cb:	ff d0                	callq  *%rax
  8036cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036d4:	79 05                	jns    8036db <devfile_stat+0x47>
		return r;
  8036d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036d9:	eb 56                	jmp    803731 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8036db:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036df:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8036e6:	00 00 00 
  8036e9:	48 89 c7             	mov    %rax,%rdi
  8036ec:	48 b8 d2 16 80 00 00 	movabs $0x8016d2,%rax
  8036f3:	00 00 00 
  8036f6:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8036f8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036ff:	00 00 00 
  803702:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803708:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80370c:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803712:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803719:	00 00 00 
  80371c:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803722:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803726:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80372c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803731:	c9                   	leaveq 
  803732:	c3                   	retq   

0000000000803733 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803733:	55                   	push   %rbp
  803734:	48 89 e5             	mov    %rsp,%rbp
  803737:	48 83 ec 10          	sub    $0x10,%rsp
  80373b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80373f:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803742:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803746:	8b 50 0c             	mov    0xc(%rax),%edx
  803749:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803750:	00 00 00 
  803753:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803755:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80375c:	00 00 00 
  80375f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803762:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803765:	be 00 00 00 00       	mov    $0x0,%esi
  80376a:	bf 02 00 00 00       	mov    $0x2,%edi
  80376f:	48 b8 39 33 80 00 00 	movabs $0x803339,%rax
  803776:	00 00 00 
  803779:	ff d0                	callq  *%rax
}
  80377b:	c9                   	leaveq 
  80377c:	c3                   	retq   

000000000080377d <remove>:

// Delete a file
int
remove(const char *path)
{
  80377d:	55                   	push   %rbp
  80377e:	48 89 e5             	mov    %rsp,%rbp
  803781:	48 83 ec 10          	sub    $0x10,%rsp
  803785:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803789:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80378d:	48 89 c7             	mov    %rax,%rdi
  803790:	48 b8 66 16 80 00 00 	movabs $0x801666,%rax
  803797:	00 00 00 
  80379a:	ff d0                	callq  *%rax
  80379c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8037a1:	7e 07                	jle    8037aa <remove+0x2d>
		return -E_BAD_PATH;
  8037a3:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8037a8:	eb 33                	jmp    8037dd <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8037aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037ae:	48 89 c6             	mov    %rax,%rsi
  8037b1:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  8037b8:	00 00 00 
  8037bb:	48 b8 d2 16 80 00 00 	movabs $0x8016d2,%rax
  8037c2:	00 00 00 
  8037c5:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8037c7:	be 00 00 00 00       	mov    $0x0,%esi
  8037cc:	bf 07 00 00 00       	mov    $0x7,%edi
  8037d1:	48 b8 39 33 80 00 00 	movabs $0x803339,%rax
  8037d8:	00 00 00 
  8037db:	ff d0                	callq  *%rax
}
  8037dd:	c9                   	leaveq 
  8037de:	c3                   	retq   

00000000008037df <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8037df:	55                   	push   %rbp
  8037e0:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8037e3:	be 00 00 00 00       	mov    $0x0,%esi
  8037e8:	bf 08 00 00 00       	mov    $0x8,%edi
  8037ed:	48 b8 39 33 80 00 00 	movabs $0x803339,%rax
  8037f4:	00 00 00 
  8037f7:	ff d0                	callq  *%rax
}
  8037f9:	5d                   	pop    %rbp
  8037fa:	c3                   	retq   

00000000008037fb <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8037fb:	55                   	push   %rbp
  8037fc:	48 89 e5             	mov    %rsp,%rbp
  8037ff:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803806:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  80380d:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803814:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  80381b:	be 00 00 00 00       	mov    $0x0,%esi
  803820:	48 89 c7             	mov    %rax,%rdi
  803823:	48 b8 c0 33 80 00 00 	movabs $0x8033c0,%rax
  80382a:	00 00 00 
  80382d:	ff d0                	callq  *%rax
  80382f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803832:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803836:	79 28                	jns    803860 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803838:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80383b:	89 c6                	mov    %eax,%esi
  80383d:	48 bf 9a 5f 80 00 00 	movabs $0x805f9a,%rdi
  803844:	00 00 00 
  803847:	b8 00 00 00 00       	mov    $0x0,%eax
  80384c:	48 ba 1d 0b 80 00 00 	movabs $0x800b1d,%rdx
  803853:	00 00 00 
  803856:	ff d2                	callq  *%rdx
		return fd_src;
  803858:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80385b:	e9 74 01 00 00       	jmpq   8039d4 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803860:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803867:	be 01 01 00 00       	mov    $0x101,%esi
  80386c:	48 89 c7             	mov    %rax,%rdi
  80386f:	48 b8 c0 33 80 00 00 	movabs $0x8033c0,%rax
  803876:	00 00 00 
  803879:	ff d0                	callq  *%rax
  80387b:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  80387e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803882:	79 39                	jns    8038bd <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803884:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803887:	89 c6                	mov    %eax,%esi
  803889:	48 bf b0 5f 80 00 00 	movabs $0x805fb0,%rdi
  803890:	00 00 00 
  803893:	b8 00 00 00 00       	mov    $0x0,%eax
  803898:	48 ba 1d 0b 80 00 00 	movabs $0x800b1d,%rdx
  80389f:	00 00 00 
  8038a2:	ff d2                	callq  *%rdx
		close(fd_src);
  8038a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038a7:	89 c7                	mov    %eax,%edi
  8038a9:	48 b8 c8 2c 80 00 00 	movabs $0x802cc8,%rax
  8038b0:	00 00 00 
  8038b3:	ff d0                	callq  *%rax
		return fd_dest;
  8038b5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038b8:	e9 17 01 00 00       	jmpq   8039d4 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8038bd:	eb 74                	jmp    803933 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8038bf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8038c2:	48 63 d0             	movslq %eax,%rdx
  8038c5:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8038cc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038cf:	48 89 ce             	mov    %rcx,%rsi
  8038d2:	89 c7                	mov    %eax,%edi
  8038d4:	48 b8 34 30 80 00 00 	movabs $0x803034,%rax
  8038db:	00 00 00 
  8038de:	ff d0                	callq  *%rax
  8038e0:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8038e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8038e7:	79 4a                	jns    803933 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8038e9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8038ec:	89 c6                	mov    %eax,%esi
  8038ee:	48 bf ca 5f 80 00 00 	movabs $0x805fca,%rdi
  8038f5:	00 00 00 
  8038f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8038fd:	48 ba 1d 0b 80 00 00 	movabs $0x800b1d,%rdx
  803904:	00 00 00 
  803907:	ff d2                	callq  *%rdx
			close(fd_src);
  803909:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80390c:	89 c7                	mov    %eax,%edi
  80390e:	48 b8 c8 2c 80 00 00 	movabs $0x802cc8,%rax
  803915:	00 00 00 
  803918:	ff d0                	callq  *%rax
			close(fd_dest);
  80391a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80391d:	89 c7                	mov    %eax,%edi
  80391f:	48 b8 c8 2c 80 00 00 	movabs $0x802cc8,%rax
  803926:	00 00 00 
  803929:	ff d0                	callq  *%rax
			return write_size;
  80392b:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80392e:	e9 a1 00 00 00       	jmpq   8039d4 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803933:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80393a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80393d:	ba 00 02 00 00       	mov    $0x200,%edx
  803942:	48 89 ce             	mov    %rcx,%rsi
  803945:	89 c7                	mov    %eax,%edi
  803947:	48 b8 ea 2e 80 00 00 	movabs $0x802eea,%rax
  80394e:	00 00 00 
  803951:	ff d0                	callq  *%rax
  803953:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803956:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80395a:	0f 8f 5f ff ff ff    	jg     8038bf <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803960:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803964:	79 47                	jns    8039ad <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803966:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803969:	89 c6                	mov    %eax,%esi
  80396b:	48 bf dd 5f 80 00 00 	movabs $0x805fdd,%rdi
  803972:	00 00 00 
  803975:	b8 00 00 00 00       	mov    $0x0,%eax
  80397a:	48 ba 1d 0b 80 00 00 	movabs $0x800b1d,%rdx
  803981:	00 00 00 
  803984:	ff d2                	callq  *%rdx
		close(fd_src);
  803986:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803989:	89 c7                	mov    %eax,%edi
  80398b:	48 b8 c8 2c 80 00 00 	movabs $0x802cc8,%rax
  803992:	00 00 00 
  803995:	ff d0                	callq  *%rax
		close(fd_dest);
  803997:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80399a:	89 c7                	mov    %eax,%edi
  80399c:	48 b8 c8 2c 80 00 00 	movabs $0x802cc8,%rax
  8039a3:	00 00 00 
  8039a6:	ff d0                	callq  *%rax
		return read_size;
  8039a8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8039ab:	eb 27                	jmp    8039d4 <copy+0x1d9>
	}
	close(fd_src);
  8039ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039b0:	89 c7                	mov    %eax,%edi
  8039b2:	48 b8 c8 2c 80 00 00 	movabs $0x802cc8,%rax
  8039b9:	00 00 00 
  8039bc:	ff d0                	callq  *%rax
	close(fd_dest);
  8039be:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8039c1:	89 c7                	mov    %eax,%edi
  8039c3:	48 b8 c8 2c 80 00 00 	movabs $0x802cc8,%rax
  8039ca:	00 00 00 
  8039cd:	ff d0                	callq  *%rax
	return 0;
  8039cf:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8039d4:	c9                   	leaveq 
  8039d5:	c3                   	retq   

00000000008039d6 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8039d6:	55                   	push   %rbp
  8039d7:	48 89 e5             	mov    %rsp,%rbp
  8039da:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  8039e1:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  8039e8:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8039ef:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  8039f6:	be 00 00 00 00       	mov    $0x0,%esi
  8039fb:	48 89 c7             	mov    %rax,%rdi
  8039fe:	48 b8 c0 33 80 00 00 	movabs $0x8033c0,%rax
  803a05:	00 00 00 
  803a08:	ff d0                	callq  *%rax
  803a0a:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803a0d:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803a11:	79 08                	jns    803a1b <spawn+0x45>
		return r;
  803a13:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803a16:	e9 14 03 00 00       	jmpq   803d2f <spawn+0x359>
	fd = r;
  803a1b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803a1e:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  803a21:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  803a28:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  803a2c:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  803a33:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803a36:	ba 00 02 00 00       	mov    $0x200,%edx
  803a3b:	48 89 ce             	mov    %rcx,%rsi
  803a3e:	89 c7                	mov    %eax,%edi
  803a40:	48 b8 bf 2f 80 00 00 	movabs $0x802fbf,%rax
  803a47:	00 00 00 
  803a4a:	ff d0                	callq  *%rax
  803a4c:	3d 00 02 00 00       	cmp    $0x200,%eax
  803a51:	75 0d                	jne    803a60 <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  803a53:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a57:	8b 00                	mov    (%rax),%eax
  803a59:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  803a5e:	74 43                	je     803aa3 <spawn+0xcd>
		close(fd);
  803a60:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803a63:	89 c7                	mov    %eax,%edi
  803a65:	48 b8 c8 2c 80 00 00 	movabs $0x802cc8,%rax
  803a6c:	00 00 00 
  803a6f:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  803a71:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a75:	8b 00                	mov    (%rax),%eax
  803a77:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  803a7c:	89 c6                	mov    %eax,%esi
  803a7e:	48 bf f8 5f 80 00 00 	movabs $0x805ff8,%rdi
  803a85:	00 00 00 
  803a88:	b8 00 00 00 00       	mov    $0x0,%eax
  803a8d:	48 b9 1d 0b 80 00 00 	movabs $0x800b1d,%rcx
  803a94:	00 00 00 
  803a97:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  803a99:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803a9e:	e9 8c 02 00 00       	jmpq   803d2f <spawn+0x359>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  803aa3:	b8 07 00 00 00       	mov    $0x7,%eax
  803aa8:	cd 30                	int    $0x30
  803aaa:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  803aad:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  803ab0:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803ab3:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803ab7:	79 08                	jns    803ac1 <spawn+0xeb>
		return r;
  803ab9:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803abc:	e9 6e 02 00 00       	jmpq   803d2f <spawn+0x359>
	child = r;
  803ac1:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803ac4:	89 45 d4             	mov    %eax,-0x2c(%rbp)
	//thisenv = &envs[ENVX(sys_getenvid())];
	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  803ac7:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803aca:	25 ff 03 00 00       	and    $0x3ff,%eax
  803acf:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803ad6:	00 00 00 
  803ad9:	48 63 d0             	movslq %eax,%rdx
  803adc:	48 89 d0             	mov    %rdx,%rax
  803adf:	48 c1 e0 03          	shl    $0x3,%rax
  803ae3:	48 01 d0             	add    %rdx,%rax
  803ae6:	48 c1 e0 05          	shl    $0x5,%rax
  803aea:	48 01 c8             	add    %rcx,%rax
  803aed:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  803af4:	48 89 c6             	mov    %rax,%rsi
  803af7:	b8 18 00 00 00       	mov    $0x18,%eax
  803afc:	48 89 d7             	mov    %rdx,%rdi
  803aff:	48 89 c1             	mov    %rax,%rcx
  803b02:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  803b05:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b09:	48 8b 40 18          	mov    0x18(%rax),%rax
  803b0d:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  803b14:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  803b1b:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  803b22:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  803b29:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803b2c:	48 89 ce             	mov    %rcx,%rsi
  803b2f:	89 c7                	mov    %eax,%edi
  803b31:	48 b8 99 3f 80 00 00 	movabs $0x803f99,%rax
  803b38:	00 00 00 
  803b3b:	ff d0                	callq  *%rax
  803b3d:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803b40:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803b44:	79 08                	jns    803b4e <spawn+0x178>
		return r;
  803b46:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803b49:	e9 e1 01 00 00       	jmpq   803d2f <spawn+0x359>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  803b4e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b52:	48 8b 40 20          	mov    0x20(%rax),%rax
  803b56:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  803b5d:	48 01 d0             	add    %rdx,%rax
  803b60:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  803b64:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803b6b:	e9 a3 00 00 00       	jmpq   803c13 <spawn+0x23d>
		if (ph->p_type != ELF_PROG_LOAD)
  803b70:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b74:	8b 00                	mov    (%rax),%eax
  803b76:	83 f8 01             	cmp    $0x1,%eax
  803b79:	74 05                	je     803b80 <spawn+0x1aa>
			continue;
  803b7b:	e9 8a 00 00 00       	jmpq   803c0a <spawn+0x234>
		perm = PTE_P | PTE_U;
  803b80:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  803b87:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b8b:	8b 40 04             	mov    0x4(%rax),%eax
  803b8e:	83 e0 02             	and    $0x2,%eax
  803b91:	85 c0                	test   %eax,%eax
  803b93:	74 04                	je     803b99 <spawn+0x1c3>
			perm |= PTE_W;
  803b95:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  803b99:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b9d:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  803ba1:	41 89 c1             	mov    %eax,%r9d
  803ba4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ba8:	4c 8b 40 20          	mov    0x20(%rax),%r8
  803bac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bb0:	48 8b 50 28          	mov    0x28(%rax),%rdx
  803bb4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bb8:	48 8b 70 10          	mov    0x10(%rax),%rsi
  803bbc:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  803bbf:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803bc2:	8b 7d ec             	mov    -0x14(%rbp),%edi
  803bc5:	89 3c 24             	mov    %edi,(%rsp)
  803bc8:	89 c7                	mov    %eax,%edi
  803bca:	48 b8 42 42 80 00 00 	movabs $0x804242,%rax
  803bd1:	00 00 00 
  803bd4:	ff d0                	callq  *%rax
  803bd6:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803bd9:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803bdd:	79 2b                	jns    803c0a <spawn+0x234>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  803bdf:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  803be0:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803be3:	89 c7                	mov    %eax,%edi
  803be5:	48 b8 41 1f 80 00 00 	movabs $0x801f41,%rax
  803bec:	00 00 00 
  803bef:	ff d0                	callq  *%rax
	close(fd);
  803bf1:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803bf4:	89 c7                	mov    %eax,%edi
  803bf6:	48 b8 c8 2c 80 00 00 	movabs $0x802cc8,%rax
  803bfd:	00 00 00 
  803c00:	ff d0                	callq  *%rax
	return r;
  803c02:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803c05:	e9 25 01 00 00       	jmpq   803d2f <spawn+0x359>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  803c0a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803c0e:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  803c13:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c17:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  803c1b:	0f b7 c0             	movzwl %ax,%eax
  803c1e:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  803c21:	0f 8f 49 ff ff ff    	jg     803b70 <spawn+0x19a>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  803c27:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803c2a:	89 c7                	mov    %eax,%edi
  803c2c:	48 b8 c8 2c 80 00 00 	movabs $0x802cc8,%rax
  803c33:	00 00 00 
  803c36:	ff d0                	callq  *%rax
	fd = -1;
  803c38:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  803c3f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803c42:	89 c7                	mov    %eax,%edi
  803c44:	48 b8 2e 44 80 00 00 	movabs $0x80442e,%rax
  803c4b:	00 00 00 
  803c4e:	ff d0                	callq  *%rax
  803c50:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803c53:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803c57:	79 30                	jns    803c89 <spawn+0x2b3>
		panic("copy_shared_pages: %e", r);
  803c59:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803c5c:	89 c1                	mov    %eax,%ecx
  803c5e:	48 ba 12 60 80 00 00 	movabs $0x806012,%rdx
  803c65:	00 00 00 
  803c68:	be 82 00 00 00       	mov    $0x82,%esi
  803c6d:	48 bf 28 60 80 00 00 	movabs $0x806028,%rdi
  803c74:	00 00 00 
  803c77:	b8 00 00 00 00       	mov    $0x0,%eax
  803c7c:	49 b8 e4 08 80 00 00 	movabs $0x8008e4,%r8
  803c83:	00 00 00 
  803c86:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  803c89:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  803c90:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803c93:	48 89 d6             	mov    %rdx,%rsi
  803c96:	89 c7                	mov    %eax,%edi
  803c98:	48 b8 41 21 80 00 00 	movabs $0x802141,%rax
  803c9f:	00 00 00 
  803ca2:	ff d0                	callq  *%rax
  803ca4:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803ca7:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803cab:	79 30                	jns    803cdd <spawn+0x307>
		panic("sys_env_set_trapframe: %e", r);
  803cad:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803cb0:	89 c1                	mov    %eax,%ecx
  803cb2:	48 ba 34 60 80 00 00 	movabs $0x806034,%rdx
  803cb9:	00 00 00 
  803cbc:	be 85 00 00 00       	mov    $0x85,%esi
  803cc1:	48 bf 28 60 80 00 00 	movabs $0x806028,%rdi
  803cc8:	00 00 00 
  803ccb:	b8 00 00 00 00       	mov    $0x0,%eax
  803cd0:	49 b8 e4 08 80 00 00 	movabs $0x8008e4,%r8
  803cd7:	00 00 00 
  803cda:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  803cdd:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803ce0:	be 02 00 00 00       	mov    $0x2,%esi
  803ce5:	89 c7                	mov    %eax,%edi
  803ce7:	48 b8 f6 20 80 00 00 	movabs $0x8020f6,%rax
  803cee:	00 00 00 
  803cf1:	ff d0                	callq  *%rax
  803cf3:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803cf6:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803cfa:	79 30                	jns    803d2c <spawn+0x356>
		panic("sys_env_set_status: %e", r);
  803cfc:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803cff:	89 c1                	mov    %eax,%ecx
  803d01:	48 ba 4e 60 80 00 00 	movabs $0x80604e,%rdx
  803d08:	00 00 00 
  803d0b:	be 88 00 00 00       	mov    $0x88,%esi
  803d10:	48 bf 28 60 80 00 00 	movabs $0x806028,%rdi
  803d17:	00 00 00 
  803d1a:	b8 00 00 00 00       	mov    $0x0,%eax
  803d1f:	49 b8 e4 08 80 00 00 	movabs $0x8008e4,%r8
  803d26:	00 00 00 
  803d29:	41 ff d0             	callq  *%r8

	return child;
  803d2c:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  803d2f:	c9                   	leaveq 
  803d30:	c3                   	retq   

0000000000803d31 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  803d31:	55                   	push   %rbp
  803d32:	48 89 e5             	mov    %rsp,%rbp
  803d35:	41 55                	push   %r13
  803d37:	41 54                	push   %r12
  803d39:	53                   	push   %rbx
  803d3a:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803d41:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  803d48:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  803d4f:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  803d56:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  803d5d:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  803d64:	84 c0                	test   %al,%al
  803d66:	74 26                	je     803d8e <spawnl+0x5d>
  803d68:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  803d6f:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  803d76:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  803d7a:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  803d7e:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  803d82:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  803d86:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  803d8a:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  803d8e:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  803d95:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  803d9c:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  803d9f:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803da6:	00 00 00 
  803da9:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803db0:	00 00 00 
  803db3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803db7:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803dbe:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803dc5:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  803dcc:	eb 07                	jmp    803dd5 <spawnl+0xa4>
		argc++;
  803dce:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  803dd5:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803ddb:	83 f8 30             	cmp    $0x30,%eax
  803dde:	73 23                	jae    803e03 <spawnl+0xd2>
  803de0:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  803de7:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803ded:	89 c0                	mov    %eax,%eax
  803def:	48 01 d0             	add    %rdx,%rax
  803df2:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803df8:	83 c2 08             	add    $0x8,%edx
  803dfb:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803e01:	eb 15                	jmp    803e18 <spawnl+0xe7>
  803e03:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  803e0a:	48 89 d0             	mov    %rdx,%rax
  803e0d:	48 83 c2 08          	add    $0x8,%rdx
  803e11:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803e18:	48 8b 00             	mov    (%rax),%rax
  803e1b:	48 85 c0             	test   %rax,%rax
  803e1e:	75 ae                	jne    803dce <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  803e20:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803e26:	83 c0 02             	add    $0x2,%eax
  803e29:	48 89 e2             	mov    %rsp,%rdx
  803e2c:	48 89 d3             	mov    %rdx,%rbx
  803e2f:	48 63 d0             	movslq %eax,%rdx
  803e32:	48 83 ea 01          	sub    $0x1,%rdx
  803e36:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  803e3d:	48 63 d0             	movslq %eax,%rdx
  803e40:	49 89 d4             	mov    %rdx,%r12
  803e43:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  803e49:	48 63 d0             	movslq %eax,%rdx
  803e4c:	49 89 d2             	mov    %rdx,%r10
  803e4f:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  803e55:	48 98                	cltq   
  803e57:	48 c1 e0 03          	shl    $0x3,%rax
  803e5b:	48 8d 50 07          	lea    0x7(%rax),%rdx
  803e5f:	b8 10 00 00 00       	mov    $0x10,%eax
  803e64:	48 83 e8 01          	sub    $0x1,%rax
  803e68:	48 01 d0             	add    %rdx,%rax
  803e6b:	bf 10 00 00 00       	mov    $0x10,%edi
  803e70:	ba 00 00 00 00       	mov    $0x0,%edx
  803e75:	48 f7 f7             	div    %rdi
  803e78:	48 6b c0 10          	imul   $0x10,%rax,%rax
  803e7c:	48 29 c4             	sub    %rax,%rsp
  803e7f:	48 89 e0             	mov    %rsp,%rax
  803e82:	48 83 c0 07          	add    $0x7,%rax
  803e86:	48 c1 e8 03          	shr    $0x3,%rax
  803e8a:	48 c1 e0 03          	shl    $0x3,%rax
  803e8e:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  803e95:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803e9c:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  803ea3:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  803ea6:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803eac:	8d 50 01             	lea    0x1(%rax),%edx
  803eaf:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803eb6:	48 63 d2             	movslq %edx,%rdx
  803eb9:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  803ec0:	00 

	va_start(vl, arg0);
  803ec1:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803ec8:	00 00 00 
  803ecb:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803ed2:	00 00 00 
  803ed5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803ed9:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803ee0:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803ee7:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  803eee:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  803ef5:	00 00 00 
  803ef8:	eb 63                	jmp    803f5d <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  803efa:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  803f00:	8d 70 01             	lea    0x1(%rax),%esi
  803f03:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803f09:	83 f8 30             	cmp    $0x30,%eax
  803f0c:	73 23                	jae    803f31 <spawnl+0x200>
  803f0e:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  803f15:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803f1b:	89 c0                	mov    %eax,%eax
  803f1d:	48 01 d0             	add    %rdx,%rax
  803f20:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803f26:	83 c2 08             	add    $0x8,%edx
  803f29:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803f2f:	eb 15                	jmp    803f46 <spawnl+0x215>
  803f31:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  803f38:	48 89 d0             	mov    %rdx,%rax
  803f3b:	48 83 c2 08          	add    $0x8,%rdx
  803f3f:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803f46:	48 8b 08             	mov    (%rax),%rcx
  803f49:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803f50:	89 f2                	mov    %esi,%edx
  803f52:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  803f56:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  803f5d:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803f63:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  803f69:	77 8f                	ja     803efa <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  803f6b:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803f72:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  803f79:	48 89 d6             	mov    %rdx,%rsi
  803f7c:	48 89 c7             	mov    %rax,%rdi
  803f7f:	48 b8 d6 39 80 00 00 	movabs $0x8039d6,%rax
  803f86:	00 00 00 
  803f89:	ff d0                	callq  *%rax
  803f8b:	48 89 dc             	mov    %rbx,%rsp
}
  803f8e:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  803f92:	5b                   	pop    %rbx
  803f93:	41 5c                	pop    %r12
  803f95:	41 5d                	pop    %r13
  803f97:	5d                   	pop    %rbp
  803f98:	c3                   	retq   

0000000000803f99 <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  803f99:	55                   	push   %rbp
  803f9a:	48 89 e5             	mov    %rsp,%rbp
  803f9d:	48 83 ec 50          	sub    $0x50,%rsp
  803fa1:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803fa4:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  803fa8:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  803fac:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803fb3:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  803fb4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  803fbb:	eb 33                	jmp    803ff0 <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  803fbd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803fc0:	48 98                	cltq   
  803fc2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803fc9:	00 
  803fca:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803fce:	48 01 d0             	add    %rdx,%rax
  803fd1:	48 8b 00             	mov    (%rax),%rax
  803fd4:	48 89 c7             	mov    %rax,%rdi
  803fd7:	48 b8 66 16 80 00 00 	movabs $0x801666,%rax
  803fde:	00 00 00 
  803fe1:	ff d0                	callq  *%rax
  803fe3:	83 c0 01             	add    $0x1,%eax
  803fe6:	48 98                	cltq   
  803fe8:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  803fec:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  803ff0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803ff3:	48 98                	cltq   
  803ff5:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803ffc:	00 
  803ffd:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  804001:	48 01 d0             	add    %rdx,%rax
  804004:	48 8b 00             	mov    (%rax),%rax
  804007:	48 85 c0             	test   %rax,%rax
  80400a:	75 b1                	jne    803fbd <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  80400c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804010:	48 f7 d8             	neg    %rax
  804013:	48 05 00 10 40 00    	add    $0x401000,%rax
  804019:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  80401d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804021:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  804025:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804029:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  80402d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  804030:	83 c2 01             	add    $0x1,%edx
  804033:	c1 e2 03             	shl    $0x3,%edx
  804036:	48 63 d2             	movslq %edx,%rdx
  804039:	48 f7 da             	neg    %rdx
  80403c:	48 01 d0             	add    %rdx,%rax
  80403f:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  804043:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804047:	48 83 e8 10          	sub    $0x10,%rax
  80404b:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  804051:	77 0a                	ja     80405d <init_stack+0xc4>
		return -E_NO_MEM;
  804053:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  804058:	e9 e3 01 00 00       	jmpq   804240 <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80405d:	ba 07 00 00 00       	mov    $0x7,%edx
  804062:	be 00 00 40 00       	mov    $0x400000,%esi
  804067:	bf 00 00 00 00       	mov    $0x0,%edi
  80406c:	48 b8 01 20 80 00 00 	movabs $0x802001,%rax
  804073:	00 00 00 
  804076:	ff d0                	callq  *%rax
  804078:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80407b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80407f:	79 08                	jns    804089 <init_stack+0xf0>
		return r;
  804081:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804084:	e9 b7 01 00 00       	jmpq   804240 <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  804089:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  804090:	e9 8a 00 00 00       	jmpq   80411f <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  804095:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804098:	48 98                	cltq   
  80409a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8040a1:	00 
  8040a2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040a6:	48 01 c2             	add    %rax,%rdx
  8040a9:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8040ae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040b2:	48 01 c8             	add    %rcx,%rax
  8040b5:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  8040bb:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  8040be:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8040c1:	48 98                	cltq   
  8040c3:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8040ca:	00 
  8040cb:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8040cf:	48 01 d0             	add    %rdx,%rax
  8040d2:	48 8b 10             	mov    (%rax),%rdx
  8040d5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040d9:	48 89 d6             	mov    %rdx,%rsi
  8040dc:	48 89 c7             	mov    %rax,%rdi
  8040df:	48 b8 d2 16 80 00 00 	movabs $0x8016d2,%rax
  8040e6:	00 00 00 
  8040e9:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  8040eb:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8040ee:	48 98                	cltq   
  8040f0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8040f7:	00 
  8040f8:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8040fc:	48 01 d0             	add    %rdx,%rax
  8040ff:	48 8b 00             	mov    (%rax),%rax
  804102:	48 89 c7             	mov    %rax,%rdi
  804105:	48 b8 66 16 80 00 00 	movabs $0x801666,%rax
  80410c:	00 00 00 
  80410f:	ff d0                	callq  *%rax
  804111:	48 98                	cltq   
  804113:	48 83 c0 01          	add    $0x1,%rax
  804117:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  80411b:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  80411f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804122:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  804125:	0f 8c 6a ff ff ff    	jl     804095 <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  80412b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80412e:	48 98                	cltq   
  804130:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804137:	00 
  804138:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80413c:	48 01 d0             	add    %rdx,%rax
  80413f:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  804146:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  80414d:	00 
  80414e:	74 35                	je     804185 <init_stack+0x1ec>
  804150:	48 b9 68 60 80 00 00 	movabs $0x806068,%rcx
  804157:	00 00 00 
  80415a:	48 ba 8e 60 80 00 00 	movabs $0x80608e,%rdx
  804161:	00 00 00 
  804164:	be f1 00 00 00       	mov    $0xf1,%esi
  804169:	48 bf 28 60 80 00 00 	movabs $0x806028,%rdi
  804170:	00 00 00 
  804173:	b8 00 00 00 00       	mov    $0x0,%eax
  804178:	49 b8 e4 08 80 00 00 	movabs $0x8008e4,%r8
  80417f:	00 00 00 
  804182:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  804185:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804189:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  80418d:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  804192:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804196:	48 01 c8             	add    %rcx,%rax
  804199:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  80419f:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  8041a2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041a6:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  8041aa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8041ad:	48 98                	cltq   
  8041af:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  8041b2:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  8041b7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041bb:	48 01 d0             	add    %rdx,%rax
  8041be:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  8041c4:	48 89 c2             	mov    %rax,%rdx
  8041c7:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8041cb:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8041ce:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8041d1:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8041d7:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8041dc:	89 c2                	mov    %eax,%edx
  8041de:	be 00 00 40 00       	mov    $0x400000,%esi
  8041e3:	bf 00 00 00 00       	mov    $0x0,%edi
  8041e8:	48 b8 51 20 80 00 00 	movabs $0x802051,%rax
  8041ef:	00 00 00 
  8041f2:	ff d0                	callq  *%rax
  8041f4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8041f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8041fb:	79 02                	jns    8041ff <init_stack+0x266>
		goto error;
  8041fd:	eb 28                	jmp    804227 <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8041ff:	be 00 00 40 00       	mov    $0x400000,%esi
  804204:	bf 00 00 00 00       	mov    $0x0,%edi
  804209:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  804210:	00 00 00 
  804213:	ff d0                	callq  *%rax
  804215:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804218:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80421c:	79 02                	jns    804220 <init_stack+0x287>
		goto error;
  80421e:	eb 07                	jmp    804227 <init_stack+0x28e>

	return 0;
  804220:	b8 00 00 00 00       	mov    $0x0,%eax
  804225:	eb 19                	jmp    804240 <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  804227:	be 00 00 40 00       	mov    $0x400000,%esi
  80422c:	bf 00 00 00 00       	mov    $0x0,%edi
  804231:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  804238:	00 00 00 
  80423b:	ff d0                	callq  *%rax
	return r;
  80423d:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804240:	c9                   	leaveq 
  804241:	c3                   	retq   

0000000000804242 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  804242:	55                   	push   %rbp
  804243:	48 89 e5             	mov    %rsp,%rbp
  804246:	48 83 ec 50          	sub    $0x50,%rsp
  80424a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80424d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804251:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  804255:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  804258:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80425c:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  804260:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804264:	25 ff 0f 00 00       	and    $0xfff,%eax
  804269:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80426c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804270:	74 21                	je     804293 <map_segment+0x51>
		va -= i;
  804272:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804275:	48 98                	cltq   
  804277:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  80427b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80427e:	48 98                	cltq   
  804280:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  804284:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804287:	48 98                	cltq   
  804289:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  80428d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804290:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  804293:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80429a:	e9 79 01 00 00       	jmpq   804418 <map_segment+0x1d6>
		if (i >= filesz) {
  80429f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042a2:	48 98                	cltq   
  8042a4:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  8042a8:	72 3c                	jb     8042e6 <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8042aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042ad:	48 63 d0             	movslq %eax,%rdx
  8042b0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8042b4:	48 01 d0             	add    %rdx,%rax
  8042b7:	48 89 c1             	mov    %rax,%rcx
  8042ba:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8042bd:	8b 55 10             	mov    0x10(%rbp),%edx
  8042c0:	48 89 ce             	mov    %rcx,%rsi
  8042c3:	89 c7                	mov    %eax,%edi
  8042c5:	48 b8 01 20 80 00 00 	movabs $0x802001,%rax
  8042cc:	00 00 00 
  8042cf:	ff d0                	callq  *%rax
  8042d1:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8042d4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8042d8:	0f 89 33 01 00 00    	jns    804411 <map_segment+0x1cf>
				return r;
  8042de:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8042e1:	e9 46 01 00 00       	jmpq   80442c <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8042e6:	ba 07 00 00 00       	mov    $0x7,%edx
  8042eb:	be 00 00 40 00       	mov    $0x400000,%esi
  8042f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8042f5:	48 b8 01 20 80 00 00 	movabs $0x802001,%rax
  8042fc:	00 00 00 
  8042ff:	ff d0                	callq  *%rax
  804301:	89 45 f8             	mov    %eax,-0x8(%rbp)
  804304:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  804308:	79 08                	jns    804312 <map_segment+0xd0>
				return r;
  80430a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80430d:	e9 1a 01 00 00       	jmpq   80442c <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  804312:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804315:	8b 55 bc             	mov    -0x44(%rbp),%edx
  804318:	01 c2                	add    %eax,%edx
  80431a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80431d:	89 d6                	mov    %edx,%esi
  80431f:	89 c7                	mov    %eax,%edi
  804321:	48 b8 08 31 80 00 00 	movabs $0x803108,%rax
  804328:	00 00 00 
  80432b:	ff d0                	callq  *%rax
  80432d:	89 45 f8             	mov    %eax,-0x8(%rbp)
  804330:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  804334:	79 08                	jns    80433e <map_segment+0xfc>
				return r;
  804336:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804339:	e9 ee 00 00 00       	jmpq   80442c <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  80433e:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  804345:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804348:	48 98                	cltq   
  80434a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80434e:	48 29 c2             	sub    %rax,%rdx
  804351:	48 89 d0             	mov    %rdx,%rax
  804354:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  804358:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80435b:	48 63 d0             	movslq %eax,%rdx
  80435e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804362:	48 39 c2             	cmp    %rax,%rdx
  804365:	48 0f 47 d0          	cmova  %rax,%rdx
  804369:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80436c:	be 00 00 40 00       	mov    $0x400000,%esi
  804371:	89 c7                	mov    %eax,%edi
  804373:	48 b8 bf 2f 80 00 00 	movabs $0x802fbf,%rax
  80437a:	00 00 00 
  80437d:	ff d0                	callq  *%rax
  80437f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  804382:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  804386:	79 08                	jns    804390 <map_segment+0x14e>
				return r;
  804388:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80438b:	e9 9c 00 00 00       	jmpq   80442c <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  804390:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804393:	48 63 d0             	movslq %eax,%rdx
  804396:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80439a:	48 01 d0             	add    %rdx,%rax
  80439d:	48 89 c2             	mov    %rax,%rdx
  8043a0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8043a3:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  8043a7:	48 89 d1             	mov    %rdx,%rcx
  8043aa:	89 c2                	mov    %eax,%edx
  8043ac:	be 00 00 40 00       	mov    $0x400000,%esi
  8043b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8043b6:	48 b8 51 20 80 00 00 	movabs $0x802051,%rax
  8043bd:	00 00 00 
  8043c0:	ff d0                	callq  *%rax
  8043c2:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8043c5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8043c9:	79 30                	jns    8043fb <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  8043cb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8043ce:	89 c1                	mov    %eax,%ecx
  8043d0:	48 ba a3 60 80 00 00 	movabs $0x8060a3,%rdx
  8043d7:	00 00 00 
  8043da:	be 24 01 00 00       	mov    $0x124,%esi
  8043df:	48 bf 28 60 80 00 00 	movabs $0x806028,%rdi
  8043e6:	00 00 00 
  8043e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8043ee:	49 b8 e4 08 80 00 00 	movabs $0x8008e4,%r8
  8043f5:	00 00 00 
  8043f8:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  8043fb:	be 00 00 40 00       	mov    $0x400000,%esi
  804400:	bf 00 00 00 00       	mov    $0x0,%edi
  804405:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  80440c:	00 00 00 
  80440f:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  804411:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  804418:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80441b:	48 98                	cltq   
  80441d:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804421:	0f 82 78 fe ff ff    	jb     80429f <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  804427:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80442c:	c9                   	leaveq 
  80442d:	c3                   	retq   

000000000080442e <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  80442e:	55                   	push   %rbp
  80442f:	48 89 e5             	mov    %rsp,%rbp
  804432:	48 83 ec 20          	sub    $0x20,%rsp
  804436:	89 7d ec             	mov    %edi,-0x14(%rbp)
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  804439:	48 c7 45 f8 00 00 80 	movq   $0x800000,-0x8(%rbp)
  804440:	00 
  804441:	e9 c9 00 00 00       	jmpq   80450f <copy_shared_pages+0xe1>
        {
            if(!((uvpml4e[VPML4E(addr)])&&(uvpde[VPDPE(addr)]) && (uvpd[VPD(addr)]  )))
  804446:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80444a:	48 c1 e8 27          	shr    $0x27,%rax
  80444e:	48 89 c2             	mov    %rax,%rdx
  804451:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  804458:	01 00 00 
  80445b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80445f:	48 85 c0             	test   %rax,%rax
  804462:	74 3c                	je     8044a0 <copy_shared_pages+0x72>
  804464:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804468:	48 c1 e8 1e          	shr    $0x1e,%rax
  80446c:	48 89 c2             	mov    %rax,%rdx
  80446f:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  804476:	01 00 00 
  804479:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80447d:	48 85 c0             	test   %rax,%rax
  804480:	74 1e                	je     8044a0 <copy_shared_pages+0x72>
  804482:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804486:	48 c1 e8 15          	shr    $0x15,%rax
  80448a:	48 89 c2             	mov    %rax,%rdx
  80448d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804494:	01 00 00 
  804497:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80449b:	48 85 c0             	test   %rax,%rax
  80449e:	75 02                	jne    8044a2 <copy_shared_pages+0x74>
                continue;
  8044a0:	eb 65                	jmp    804507 <copy_shared_pages+0xd9>

            if((uvpt[VPN(addr)] & PTE_SHARE) != 0)
  8044a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044a6:	48 c1 e8 0c          	shr    $0xc,%rax
  8044aa:	48 89 c2             	mov    %rax,%rdx
  8044ad:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8044b4:	01 00 00 
  8044b7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8044bb:	25 00 04 00 00       	and    $0x400,%eax
  8044c0:	48 85 c0             	test   %rax,%rax
  8044c3:	74 42                	je     804507 <copy_shared_pages+0xd9>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);
  8044c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044c9:	48 c1 e8 0c          	shr    $0xc,%rax
  8044cd:	48 89 c2             	mov    %rax,%rdx
  8044d0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8044d7:	01 00 00 
  8044da:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8044de:	25 07 0e 00 00       	and    $0xe07,%eax
  8044e3:	89 c6                	mov    %eax,%esi
  8044e5:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8044e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044ed:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8044f0:	41 89 f0             	mov    %esi,%r8d
  8044f3:	48 89 c6             	mov    %rax,%rsi
  8044f6:	bf 00 00 00 00       	mov    $0x0,%edi
  8044fb:	48 b8 51 20 80 00 00 	movabs $0x802051,%rax
  804502:	00 00 00 
  804505:	ff d0                	callq  *%rax
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  804507:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  80450e:	00 
  80450f:	48 b8 ff ff 7f 00 80 	movabs $0x80007fffff,%rax
  804516:	00 00 00 
  804519:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  80451d:	0f 86 23 ff ff ff    	jbe    804446 <copy_shared_pages+0x18>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);

            }
        }
     return 0;
  804523:	b8 00 00 00 00       	mov    $0x0,%eax
 }
  804528:	c9                   	leaveq 
  804529:	c3                   	retq   

000000000080452a <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  80452a:	55                   	push   %rbp
  80452b:	48 89 e5             	mov    %rsp,%rbp
  80452e:	48 83 ec 20          	sub    $0x20,%rsp
  804532:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  804535:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804539:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80453c:	48 89 d6             	mov    %rdx,%rsi
  80453f:	89 c7                	mov    %eax,%edi
  804541:	48 b8 b8 2a 80 00 00 	movabs $0x802ab8,%rax
  804548:	00 00 00 
  80454b:	ff d0                	callq  *%rax
  80454d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804550:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804554:	79 05                	jns    80455b <fd2sockid+0x31>
		return r;
  804556:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804559:	eb 24                	jmp    80457f <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  80455b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80455f:	8b 10                	mov    (%rax),%edx
  804561:	48 b8 c0 80 80 00 00 	movabs $0x8080c0,%rax
  804568:	00 00 00 
  80456b:	8b 00                	mov    (%rax),%eax
  80456d:	39 c2                	cmp    %eax,%edx
  80456f:	74 07                	je     804578 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  804571:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  804576:	eb 07                	jmp    80457f <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  804578:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80457c:	8b 40 0c             	mov    0xc(%rax),%eax
}
  80457f:	c9                   	leaveq 
  804580:	c3                   	retq   

0000000000804581 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  804581:	55                   	push   %rbp
  804582:	48 89 e5             	mov    %rsp,%rbp
  804585:	48 83 ec 20          	sub    $0x20,%rsp
  804589:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  80458c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804590:	48 89 c7             	mov    %rax,%rdi
  804593:	48 b8 20 2a 80 00 00 	movabs $0x802a20,%rax
  80459a:	00 00 00 
  80459d:	ff d0                	callq  *%rax
  80459f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8045a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045a6:	78 26                	js     8045ce <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8045a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045ac:	ba 07 04 00 00       	mov    $0x407,%edx
  8045b1:	48 89 c6             	mov    %rax,%rsi
  8045b4:	bf 00 00 00 00       	mov    $0x0,%edi
  8045b9:	48 b8 01 20 80 00 00 	movabs $0x802001,%rax
  8045c0:	00 00 00 
  8045c3:	ff d0                	callq  *%rax
  8045c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8045c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045cc:	79 16                	jns    8045e4 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8045ce:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8045d1:	89 c7                	mov    %eax,%edi
  8045d3:	48 b8 8e 4a 80 00 00 	movabs $0x804a8e,%rax
  8045da:	00 00 00 
  8045dd:	ff d0                	callq  *%rax
		return r;
  8045df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045e2:	eb 3a                	jmp    80461e <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8045e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045e8:	48 ba c0 80 80 00 00 	movabs $0x8080c0,%rdx
  8045ef:	00 00 00 
  8045f2:	8b 12                	mov    (%rdx),%edx
  8045f4:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8045f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045fa:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  804601:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804605:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804608:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  80460b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80460f:	48 89 c7             	mov    %rax,%rdi
  804612:	48 b8 d2 29 80 00 00 	movabs $0x8029d2,%rax
  804619:	00 00 00 
  80461c:	ff d0                	callq  *%rax
}
  80461e:	c9                   	leaveq 
  80461f:	c3                   	retq   

0000000000804620 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  804620:	55                   	push   %rbp
  804621:	48 89 e5             	mov    %rsp,%rbp
  804624:	48 83 ec 30          	sub    $0x30,%rsp
  804628:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80462b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80462f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  804633:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804636:	89 c7                	mov    %eax,%edi
  804638:	48 b8 2a 45 80 00 00 	movabs $0x80452a,%rax
  80463f:	00 00 00 
  804642:	ff d0                	callq  *%rax
  804644:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804647:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80464b:	79 05                	jns    804652 <accept+0x32>
		return r;
  80464d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804650:	eb 3b                	jmp    80468d <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  804652:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  804656:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80465a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80465d:	48 89 ce             	mov    %rcx,%rsi
  804660:	89 c7                	mov    %eax,%edi
  804662:	48 b8 6b 49 80 00 00 	movabs $0x80496b,%rax
  804669:	00 00 00 
  80466c:	ff d0                	callq  *%rax
  80466e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804671:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804675:	79 05                	jns    80467c <accept+0x5c>
		return r;
  804677:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80467a:	eb 11                	jmp    80468d <accept+0x6d>
	return alloc_sockfd(r);
  80467c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80467f:	89 c7                	mov    %eax,%edi
  804681:	48 b8 81 45 80 00 00 	movabs $0x804581,%rax
  804688:	00 00 00 
  80468b:	ff d0                	callq  *%rax
}
  80468d:	c9                   	leaveq 
  80468e:	c3                   	retq   

000000000080468f <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80468f:	55                   	push   %rbp
  804690:	48 89 e5             	mov    %rsp,%rbp
  804693:	48 83 ec 20          	sub    $0x20,%rsp
  804697:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80469a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80469e:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8046a1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8046a4:	89 c7                	mov    %eax,%edi
  8046a6:	48 b8 2a 45 80 00 00 	movabs $0x80452a,%rax
  8046ad:	00 00 00 
  8046b0:	ff d0                	callq  *%rax
  8046b2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8046b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8046b9:	79 05                	jns    8046c0 <bind+0x31>
		return r;
  8046bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046be:	eb 1b                	jmp    8046db <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8046c0:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8046c3:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8046c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046ca:	48 89 ce             	mov    %rcx,%rsi
  8046cd:	89 c7                	mov    %eax,%edi
  8046cf:	48 b8 ea 49 80 00 00 	movabs $0x8049ea,%rax
  8046d6:	00 00 00 
  8046d9:	ff d0                	callq  *%rax
}
  8046db:	c9                   	leaveq 
  8046dc:	c3                   	retq   

00000000008046dd <shutdown>:

int
shutdown(int s, int how)
{
  8046dd:	55                   	push   %rbp
  8046de:	48 89 e5             	mov    %rsp,%rbp
  8046e1:	48 83 ec 20          	sub    $0x20,%rsp
  8046e5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8046e8:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8046eb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8046ee:	89 c7                	mov    %eax,%edi
  8046f0:	48 b8 2a 45 80 00 00 	movabs $0x80452a,%rax
  8046f7:	00 00 00 
  8046fa:	ff d0                	callq  *%rax
  8046fc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8046ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804703:	79 05                	jns    80470a <shutdown+0x2d>
		return r;
  804705:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804708:	eb 16                	jmp    804720 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  80470a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80470d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804710:	89 d6                	mov    %edx,%esi
  804712:	89 c7                	mov    %eax,%edi
  804714:	48 b8 4e 4a 80 00 00 	movabs $0x804a4e,%rax
  80471b:	00 00 00 
  80471e:	ff d0                	callq  *%rax
}
  804720:	c9                   	leaveq 
  804721:	c3                   	retq   

0000000000804722 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  804722:	55                   	push   %rbp
  804723:	48 89 e5             	mov    %rsp,%rbp
  804726:	48 83 ec 10          	sub    $0x10,%rsp
  80472a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  80472e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804732:	48 89 c7             	mov    %rax,%rdi
  804735:	48 b8 c6 56 80 00 00 	movabs $0x8056c6,%rax
  80473c:	00 00 00 
  80473f:	ff d0                	callq  *%rax
  804741:	83 f8 01             	cmp    $0x1,%eax
  804744:	75 17                	jne    80475d <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  804746:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80474a:	8b 40 0c             	mov    0xc(%rax),%eax
  80474d:	89 c7                	mov    %eax,%edi
  80474f:	48 b8 8e 4a 80 00 00 	movabs $0x804a8e,%rax
  804756:	00 00 00 
  804759:	ff d0                	callq  *%rax
  80475b:	eb 05                	jmp    804762 <devsock_close+0x40>
	else
		return 0;
  80475d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804762:	c9                   	leaveq 
  804763:	c3                   	retq   

0000000000804764 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  804764:	55                   	push   %rbp
  804765:	48 89 e5             	mov    %rsp,%rbp
  804768:	48 83 ec 20          	sub    $0x20,%rsp
  80476c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80476f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804773:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  804776:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804779:	89 c7                	mov    %eax,%edi
  80477b:	48 b8 2a 45 80 00 00 	movabs $0x80452a,%rax
  804782:	00 00 00 
  804785:	ff d0                	callq  *%rax
  804787:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80478a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80478e:	79 05                	jns    804795 <connect+0x31>
		return r;
  804790:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804793:	eb 1b                	jmp    8047b0 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  804795:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804798:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80479c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80479f:	48 89 ce             	mov    %rcx,%rsi
  8047a2:	89 c7                	mov    %eax,%edi
  8047a4:	48 b8 bb 4a 80 00 00 	movabs $0x804abb,%rax
  8047ab:	00 00 00 
  8047ae:	ff d0                	callq  *%rax
}
  8047b0:	c9                   	leaveq 
  8047b1:	c3                   	retq   

00000000008047b2 <listen>:

int
listen(int s, int backlog)
{
  8047b2:	55                   	push   %rbp
  8047b3:	48 89 e5             	mov    %rsp,%rbp
  8047b6:	48 83 ec 20          	sub    $0x20,%rsp
  8047ba:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8047bd:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8047c0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8047c3:	89 c7                	mov    %eax,%edi
  8047c5:	48 b8 2a 45 80 00 00 	movabs $0x80452a,%rax
  8047cc:	00 00 00 
  8047cf:	ff d0                	callq  *%rax
  8047d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8047d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8047d8:	79 05                	jns    8047df <listen+0x2d>
		return r;
  8047da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047dd:	eb 16                	jmp    8047f5 <listen+0x43>
	return nsipc_listen(r, backlog);
  8047df:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8047e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047e5:	89 d6                	mov    %edx,%esi
  8047e7:	89 c7                	mov    %eax,%edi
  8047e9:	48 b8 1f 4b 80 00 00 	movabs $0x804b1f,%rax
  8047f0:	00 00 00 
  8047f3:	ff d0                	callq  *%rax
}
  8047f5:	c9                   	leaveq 
  8047f6:	c3                   	retq   

00000000008047f7 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8047f7:	55                   	push   %rbp
  8047f8:	48 89 e5             	mov    %rsp,%rbp
  8047fb:	48 83 ec 20          	sub    $0x20,%rsp
  8047ff:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804803:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804807:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80480b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80480f:	89 c2                	mov    %eax,%edx
  804811:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804815:	8b 40 0c             	mov    0xc(%rax),%eax
  804818:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80481c:	b9 00 00 00 00       	mov    $0x0,%ecx
  804821:	89 c7                	mov    %eax,%edi
  804823:	48 b8 5f 4b 80 00 00 	movabs $0x804b5f,%rax
  80482a:	00 00 00 
  80482d:	ff d0                	callq  *%rax
}
  80482f:	c9                   	leaveq 
  804830:	c3                   	retq   

0000000000804831 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  804831:	55                   	push   %rbp
  804832:	48 89 e5             	mov    %rsp,%rbp
  804835:	48 83 ec 20          	sub    $0x20,%rsp
  804839:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80483d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804841:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  804845:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804849:	89 c2                	mov    %eax,%edx
  80484b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80484f:	8b 40 0c             	mov    0xc(%rax),%eax
  804852:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  804856:	b9 00 00 00 00       	mov    $0x0,%ecx
  80485b:	89 c7                	mov    %eax,%edi
  80485d:	48 b8 2b 4c 80 00 00 	movabs $0x804c2b,%rax
  804864:	00 00 00 
  804867:	ff d0                	callq  *%rax
}
  804869:	c9                   	leaveq 
  80486a:	c3                   	retq   

000000000080486b <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80486b:	55                   	push   %rbp
  80486c:	48 89 e5             	mov    %rsp,%rbp
  80486f:	48 83 ec 10          	sub    $0x10,%rsp
  804873:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804877:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  80487b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80487f:	48 be c5 60 80 00 00 	movabs $0x8060c5,%rsi
  804886:	00 00 00 
  804889:	48 89 c7             	mov    %rax,%rdi
  80488c:	48 b8 d2 16 80 00 00 	movabs $0x8016d2,%rax
  804893:	00 00 00 
  804896:	ff d0                	callq  *%rax
	return 0;
  804898:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80489d:	c9                   	leaveq 
  80489e:	c3                   	retq   

000000000080489f <socket>:

int
socket(int domain, int type, int protocol)
{
  80489f:	55                   	push   %rbp
  8048a0:	48 89 e5             	mov    %rsp,%rbp
  8048a3:	48 83 ec 20          	sub    $0x20,%rsp
  8048a7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8048aa:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8048ad:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8048b0:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8048b3:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8048b6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8048b9:	89 ce                	mov    %ecx,%esi
  8048bb:	89 c7                	mov    %eax,%edi
  8048bd:	48 b8 e3 4c 80 00 00 	movabs $0x804ce3,%rax
  8048c4:	00 00 00 
  8048c7:	ff d0                	callq  *%rax
  8048c9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8048cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8048d0:	79 05                	jns    8048d7 <socket+0x38>
		return r;
  8048d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048d5:	eb 11                	jmp    8048e8 <socket+0x49>
	return alloc_sockfd(r);
  8048d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048da:	89 c7                	mov    %eax,%edi
  8048dc:	48 b8 81 45 80 00 00 	movabs $0x804581,%rax
  8048e3:	00 00 00 
  8048e6:	ff d0                	callq  *%rax
}
  8048e8:	c9                   	leaveq 
  8048e9:	c3                   	retq   

00000000008048ea <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8048ea:	55                   	push   %rbp
  8048eb:	48 89 e5             	mov    %rsp,%rbp
  8048ee:	48 83 ec 10          	sub    $0x10,%rsp
  8048f2:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8048f5:	48 b8 04 90 80 00 00 	movabs $0x809004,%rax
  8048fc:	00 00 00 
  8048ff:	8b 00                	mov    (%rax),%eax
  804901:	85 c0                	test   %eax,%eax
  804903:	75 1d                	jne    804922 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  804905:	bf 02 00 00 00       	mov    $0x2,%edi
  80490a:	48 b8 44 56 80 00 00 	movabs $0x805644,%rax
  804911:	00 00 00 
  804914:	ff d0                	callq  *%rax
  804916:	48 ba 04 90 80 00 00 	movabs $0x809004,%rdx
  80491d:	00 00 00 
  804920:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  804922:	48 b8 04 90 80 00 00 	movabs $0x809004,%rax
  804929:	00 00 00 
  80492c:	8b 00                	mov    (%rax),%eax
  80492e:	8b 75 fc             	mov    -0x4(%rbp),%esi
  804931:	b9 07 00 00 00       	mov    $0x7,%ecx
  804936:	48 ba 00 c0 80 00 00 	movabs $0x80c000,%rdx
  80493d:	00 00 00 
  804940:	89 c7                	mov    %eax,%edi
  804942:	48 b8 e2 55 80 00 00 	movabs $0x8055e2,%rax
  804949:	00 00 00 
  80494c:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  80494e:	ba 00 00 00 00       	mov    $0x0,%edx
  804953:	be 00 00 00 00       	mov    $0x0,%esi
  804958:	bf 00 00 00 00       	mov    $0x0,%edi
  80495d:	48 b8 dc 54 80 00 00 	movabs $0x8054dc,%rax
  804964:	00 00 00 
  804967:	ff d0                	callq  *%rax
}
  804969:	c9                   	leaveq 
  80496a:	c3                   	retq   

000000000080496b <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80496b:	55                   	push   %rbp
  80496c:	48 89 e5             	mov    %rsp,%rbp
  80496f:	48 83 ec 30          	sub    $0x30,%rsp
  804973:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804976:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80497a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  80497e:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804985:	00 00 00 
  804988:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80498b:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80498d:	bf 01 00 00 00       	mov    $0x1,%edi
  804992:	48 b8 ea 48 80 00 00 	movabs $0x8048ea,%rax
  804999:	00 00 00 
  80499c:	ff d0                	callq  *%rax
  80499e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8049a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8049a5:	78 3e                	js     8049e5 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8049a7:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8049ae:	00 00 00 
  8049b1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8049b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8049b9:	8b 40 10             	mov    0x10(%rax),%eax
  8049bc:	89 c2                	mov    %eax,%edx
  8049be:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8049c2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8049c6:	48 89 ce             	mov    %rcx,%rsi
  8049c9:	48 89 c7             	mov    %rax,%rdi
  8049cc:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  8049d3:	00 00 00 
  8049d6:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8049d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8049dc:	8b 50 10             	mov    0x10(%rax),%edx
  8049df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8049e3:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8049e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8049e8:	c9                   	leaveq 
  8049e9:	c3                   	retq   

00000000008049ea <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8049ea:	55                   	push   %rbp
  8049eb:	48 89 e5             	mov    %rsp,%rbp
  8049ee:	48 83 ec 10          	sub    $0x10,%rsp
  8049f2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8049f5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8049f9:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8049fc:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804a03:	00 00 00 
  804a06:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804a09:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  804a0b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804a0e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a12:	48 89 c6             	mov    %rax,%rsi
  804a15:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  804a1c:	00 00 00 
  804a1f:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  804a26:	00 00 00 
  804a29:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  804a2b:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804a32:	00 00 00 
  804a35:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804a38:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  804a3b:	bf 02 00 00 00       	mov    $0x2,%edi
  804a40:	48 b8 ea 48 80 00 00 	movabs $0x8048ea,%rax
  804a47:	00 00 00 
  804a4a:	ff d0                	callq  *%rax
}
  804a4c:	c9                   	leaveq 
  804a4d:	c3                   	retq   

0000000000804a4e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  804a4e:	55                   	push   %rbp
  804a4f:	48 89 e5             	mov    %rsp,%rbp
  804a52:	48 83 ec 10          	sub    $0x10,%rsp
  804a56:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804a59:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  804a5c:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804a63:	00 00 00 
  804a66:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804a69:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  804a6b:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804a72:	00 00 00 
  804a75:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804a78:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  804a7b:	bf 03 00 00 00       	mov    $0x3,%edi
  804a80:	48 b8 ea 48 80 00 00 	movabs $0x8048ea,%rax
  804a87:	00 00 00 
  804a8a:	ff d0                	callq  *%rax
}
  804a8c:	c9                   	leaveq 
  804a8d:	c3                   	retq   

0000000000804a8e <nsipc_close>:

int
nsipc_close(int s)
{
  804a8e:	55                   	push   %rbp
  804a8f:	48 89 e5             	mov    %rsp,%rbp
  804a92:	48 83 ec 10          	sub    $0x10,%rsp
  804a96:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  804a99:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804aa0:	00 00 00 
  804aa3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804aa6:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  804aa8:	bf 04 00 00 00       	mov    $0x4,%edi
  804aad:	48 b8 ea 48 80 00 00 	movabs $0x8048ea,%rax
  804ab4:	00 00 00 
  804ab7:	ff d0                	callq  *%rax
}
  804ab9:	c9                   	leaveq 
  804aba:	c3                   	retq   

0000000000804abb <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  804abb:	55                   	push   %rbp
  804abc:	48 89 e5             	mov    %rsp,%rbp
  804abf:	48 83 ec 10          	sub    $0x10,%rsp
  804ac3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804ac6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804aca:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  804acd:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804ad4:	00 00 00 
  804ad7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804ada:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  804adc:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804adf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804ae3:	48 89 c6             	mov    %rax,%rsi
  804ae6:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  804aed:	00 00 00 
  804af0:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  804af7:	00 00 00 
  804afa:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  804afc:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804b03:	00 00 00 
  804b06:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804b09:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  804b0c:	bf 05 00 00 00       	mov    $0x5,%edi
  804b11:	48 b8 ea 48 80 00 00 	movabs $0x8048ea,%rax
  804b18:	00 00 00 
  804b1b:	ff d0                	callq  *%rax
}
  804b1d:	c9                   	leaveq 
  804b1e:	c3                   	retq   

0000000000804b1f <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  804b1f:	55                   	push   %rbp
  804b20:	48 89 e5             	mov    %rsp,%rbp
  804b23:	48 83 ec 10          	sub    $0x10,%rsp
  804b27:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804b2a:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  804b2d:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804b34:	00 00 00 
  804b37:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804b3a:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  804b3c:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804b43:	00 00 00 
  804b46:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804b49:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  804b4c:	bf 06 00 00 00       	mov    $0x6,%edi
  804b51:	48 b8 ea 48 80 00 00 	movabs $0x8048ea,%rax
  804b58:	00 00 00 
  804b5b:	ff d0                	callq  *%rax
}
  804b5d:	c9                   	leaveq 
  804b5e:	c3                   	retq   

0000000000804b5f <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  804b5f:	55                   	push   %rbp
  804b60:	48 89 e5             	mov    %rsp,%rbp
  804b63:	48 83 ec 30          	sub    $0x30,%rsp
  804b67:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804b6a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804b6e:	89 55 e8             	mov    %edx,-0x18(%rbp)
  804b71:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  804b74:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804b7b:	00 00 00 
  804b7e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804b81:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  804b83:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804b8a:	00 00 00 
  804b8d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804b90:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  804b93:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804b9a:	00 00 00 
  804b9d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  804ba0:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  804ba3:	bf 07 00 00 00       	mov    $0x7,%edi
  804ba8:	48 b8 ea 48 80 00 00 	movabs $0x8048ea,%rax
  804baf:	00 00 00 
  804bb2:	ff d0                	callq  *%rax
  804bb4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804bb7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804bbb:	78 69                	js     804c26 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  804bbd:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  804bc4:	7f 08                	jg     804bce <nsipc_recv+0x6f>
  804bc6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804bc9:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  804bcc:	7e 35                	jle    804c03 <nsipc_recv+0xa4>
  804bce:	48 b9 cc 60 80 00 00 	movabs $0x8060cc,%rcx
  804bd5:	00 00 00 
  804bd8:	48 ba e1 60 80 00 00 	movabs $0x8060e1,%rdx
  804bdf:	00 00 00 
  804be2:	be 61 00 00 00       	mov    $0x61,%esi
  804be7:	48 bf f6 60 80 00 00 	movabs $0x8060f6,%rdi
  804bee:	00 00 00 
  804bf1:	b8 00 00 00 00       	mov    $0x0,%eax
  804bf6:	49 b8 e4 08 80 00 00 	movabs $0x8008e4,%r8
  804bfd:	00 00 00 
  804c00:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  804c03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c06:	48 63 d0             	movslq %eax,%rdx
  804c09:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804c0d:	48 be 00 c0 80 00 00 	movabs $0x80c000,%rsi
  804c14:	00 00 00 
  804c17:	48 89 c7             	mov    %rax,%rdi
  804c1a:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  804c21:	00 00 00 
  804c24:	ff d0                	callq  *%rax
	}

	return r;
  804c26:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804c29:	c9                   	leaveq 
  804c2a:	c3                   	retq   

0000000000804c2b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  804c2b:	55                   	push   %rbp
  804c2c:	48 89 e5             	mov    %rsp,%rbp
  804c2f:	48 83 ec 20          	sub    $0x20,%rsp
  804c33:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804c36:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804c3a:	89 55 f8             	mov    %edx,-0x8(%rbp)
  804c3d:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  804c40:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804c47:	00 00 00 
  804c4a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804c4d:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  804c4f:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  804c56:	7e 35                	jle    804c8d <nsipc_send+0x62>
  804c58:	48 b9 02 61 80 00 00 	movabs $0x806102,%rcx
  804c5f:	00 00 00 
  804c62:	48 ba e1 60 80 00 00 	movabs $0x8060e1,%rdx
  804c69:	00 00 00 
  804c6c:	be 6c 00 00 00       	mov    $0x6c,%esi
  804c71:	48 bf f6 60 80 00 00 	movabs $0x8060f6,%rdi
  804c78:	00 00 00 
  804c7b:	b8 00 00 00 00       	mov    $0x0,%eax
  804c80:	49 b8 e4 08 80 00 00 	movabs $0x8008e4,%r8
  804c87:	00 00 00 
  804c8a:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  804c8d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804c90:	48 63 d0             	movslq %eax,%rdx
  804c93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c97:	48 89 c6             	mov    %rax,%rsi
  804c9a:	48 bf 0c c0 80 00 00 	movabs $0x80c00c,%rdi
  804ca1:	00 00 00 
  804ca4:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  804cab:	00 00 00 
  804cae:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  804cb0:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804cb7:	00 00 00 
  804cba:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804cbd:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  804cc0:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804cc7:	00 00 00 
  804cca:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804ccd:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  804cd0:	bf 08 00 00 00       	mov    $0x8,%edi
  804cd5:	48 b8 ea 48 80 00 00 	movabs $0x8048ea,%rax
  804cdc:	00 00 00 
  804cdf:	ff d0                	callq  *%rax
}
  804ce1:	c9                   	leaveq 
  804ce2:	c3                   	retq   

0000000000804ce3 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  804ce3:	55                   	push   %rbp
  804ce4:	48 89 e5             	mov    %rsp,%rbp
  804ce7:	48 83 ec 10          	sub    $0x10,%rsp
  804ceb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804cee:	89 75 f8             	mov    %esi,-0x8(%rbp)
  804cf1:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  804cf4:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804cfb:	00 00 00 
  804cfe:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804d01:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  804d03:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804d0a:	00 00 00 
  804d0d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804d10:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  804d13:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804d1a:	00 00 00 
  804d1d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  804d20:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  804d23:	bf 09 00 00 00       	mov    $0x9,%edi
  804d28:	48 b8 ea 48 80 00 00 	movabs $0x8048ea,%rax
  804d2f:	00 00 00 
  804d32:	ff d0                	callq  *%rax
}
  804d34:	c9                   	leaveq 
  804d35:	c3                   	retq   

0000000000804d36 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  804d36:	55                   	push   %rbp
  804d37:	48 89 e5             	mov    %rsp,%rbp
  804d3a:	53                   	push   %rbx
  804d3b:	48 83 ec 38          	sub    $0x38,%rsp
  804d3f:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  804d43:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  804d47:	48 89 c7             	mov    %rax,%rdi
  804d4a:	48 b8 20 2a 80 00 00 	movabs $0x802a20,%rax
  804d51:	00 00 00 
  804d54:	ff d0                	callq  *%rax
  804d56:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804d59:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804d5d:	0f 88 bf 01 00 00    	js     804f22 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804d63:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804d67:	ba 07 04 00 00       	mov    $0x407,%edx
  804d6c:	48 89 c6             	mov    %rax,%rsi
  804d6f:	bf 00 00 00 00       	mov    $0x0,%edi
  804d74:	48 b8 01 20 80 00 00 	movabs $0x802001,%rax
  804d7b:	00 00 00 
  804d7e:	ff d0                	callq  *%rax
  804d80:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804d83:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804d87:	0f 88 95 01 00 00    	js     804f22 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  804d8d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804d91:	48 89 c7             	mov    %rax,%rdi
  804d94:	48 b8 20 2a 80 00 00 	movabs $0x802a20,%rax
  804d9b:	00 00 00 
  804d9e:	ff d0                	callq  *%rax
  804da0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804da3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804da7:	0f 88 5d 01 00 00    	js     804f0a <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804dad:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804db1:	ba 07 04 00 00       	mov    $0x407,%edx
  804db6:	48 89 c6             	mov    %rax,%rsi
  804db9:	bf 00 00 00 00       	mov    $0x0,%edi
  804dbe:	48 b8 01 20 80 00 00 	movabs $0x802001,%rax
  804dc5:	00 00 00 
  804dc8:	ff d0                	callq  *%rax
  804dca:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804dcd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804dd1:	0f 88 33 01 00 00    	js     804f0a <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  804dd7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804ddb:	48 89 c7             	mov    %rax,%rdi
  804dde:	48 b8 f5 29 80 00 00 	movabs $0x8029f5,%rax
  804de5:	00 00 00 
  804de8:	ff d0                	callq  *%rax
  804dea:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804dee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804df2:	ba 07 04 00 00       	mov    $0x407,%edx
  804df7:	48 89 c6             	mov    %rax,%rsi
  804dfa:	bf 00 00 00 00       	mov    $0x0,%edi
  804dff:	48 b8 01 20 80 00 00 	movabs $0x802001,%rax
  804e06:	00 00 00 
  804e09:	ff d0                	callq  *%rax
  804e0b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804e0e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804e12:	79 05                	jns    804e19 <pipe+0xe3>
		goto err2;
  804e14:	e9 d9 00 00 00       	jmpq   804ef2 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804e19:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804e1d:	48 89 c7             	mov    %rax,%rdi
  804e20:	48 b8 f5 29 80 00 00 	movabs $0x8029f5,%rax
  804e27:	00 00 00 
  804e2a:	ff d0                	callq  *%rax
  804e2c:	48 89 c2             	mov    %rax,%rdx
  804e2f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804e33:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  804e39:	48 89 d1             	mov    %rdx,%rcx
  804e3c:	ba 00 00 00 00       	mov    $0x0,%edx
  804e41:	48 89 c6             	mov    %rax,%rsi
  804e44:	bf 00 00 00 00       	mov    $0x0,%edi
  804e49:	48 b8 51 20 80 00 00 	movabs $0x802051,%rax
  804e50:	00 00 00 
  804e53:	ff d0                	callq  *%rax
  804e55:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804e58:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804e5c:	79 1b                	jns    804e79 <pipe+0x143>
		goto err3;
  804e5e:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  804e5f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804e63:	48 89 c6             	mov    %rax,%rsi
  804e66:	bf 00 00 00 00       	mov    $0x0,%edi
  804e6b:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  804e72:	00 00 00 
  804e75:	ff d0                	callq  *%rax
  804e77:	eb 79                	jmp    804ef2 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  804e79:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804e7d:	48 ba 00 81 80 00 00 	movabs $0x808100,%rdx
  804e84:	00 00 00 
  804e87:	8b 12                	mov    (%rdx),%edx
  804e89:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  804e8b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804e8f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  804e96:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804e9a:	48 ba 00 81 80 00 00 	movabs $0x808100,%rdx
  804ea1:	00 00 00 
  804ea4:	8b 12                	mov    (%rdx),%edx
  804ea6:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  804ea8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804eac:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  804eb3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804eb7:	48 89 c7             	mov    %rax,%rdi
  804eba:	48 b8 d2 29 80 00 00 	movabs $0x8029d2,%rax
  804ec1:	00 00 00 
  804ec4:	ff d0                	callq  *%rax
  804ec6:	89 c2                	mov    %eax,%edx
  804ec8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804ecc:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  804ece:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804ed2:	48 8d 58 04          	lea    0x4(%rax),%rbx
  804ed6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804eda:	48 89 c7             	mov    %rax,%rdi
  804edd:	48 b8 d2 29 80 00 00 	movabs $0x8029d2,%rax
  804ee4:	00 00 00 
  804ee7:	ff d0                	callq  *%rax
  804ee9:	89 03                	mov    %eax,(%rbx)
	return 0;
  804eeb:	b8 00 00 00 00       	mov    $0x0,%eax
  804ef0:	eb 33                	jmp    804f25 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  804ef2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804ef6:	48 89 c6             	mov    %rax,%rsi
  804ef9:	bf 00 00 00 00       	mov    $0x0,%edi
  804efe:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  804f05:	00 00 00 
  804f08:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  804f0a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804f0e:	48 89 c6             	mov    %rax,%rsi
  804f11:	bf 00 00 00 00       	mov    $0x0,%edi
  804f16:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  804f1d:	00 00 00 
  804f20:	ff d0                	callq  *%rax
err:
	return r;
  804f22:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804f25:	48 83 c4 38          	add    $0x38,%rsp
  804f29:	5b                   	pop    %rbx
  804f2a:	5d                   	pop    %rbp
  804f2b:	c3                   	retq   

0000000000804f2c <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  804f2c:	55                   	push   %rbp
  804f2d:	48 89 e5             	mov    %rsp,%rbp
  804f30:	53                   	push   %rbx
  804f31:	48 83 ec 28          	sub    $0x28,%rsp
  804f35:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804f39:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  804f3d:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  804f44:	00 00 00 
  804f47:	48 8b 00             	mov    (%rax),%rax
  804f4a:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804f50:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  804f53:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804f57:	48 89 c7             	mov    %rax,%rdi
  804f5a:	48 b8 c6 56 80 00 00 	movabs $0x8056c6,%rax
  804f61:	00 00 00 
  804f64:	ff d0                	callq  *%rax
  804f66:	89 c3                	mov    %eax,%ebx
  804f68:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804f6c:	48 89 c7             	mov    %rax,%rdi
  804f6f:	48 b8 c6 56 80 00 00 	movabs $0x8056c6,%rax
  804f76:	00 00 00 
  804f79:	ff d0                	callq  *%rax
  804f7b:	39 c3                	cmp    %eax,%ebx
  804f7d:	0f 94 c0             	sete   %al
  804f80:	0f b6 c0             	movzbl %al,%eax
  804f83:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  804f86:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  804f8d:	00 00 00 
  804f90:	48 8b 00             	mov    (%rax),%rax
  804f93:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804f99:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  804f9c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804f9f:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804fa2:	75 05                	jne    804fa9 <_pipeisclosed+0x7d>
			return ret;
  804fa4:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804fa7:	eb 4f                	jmp    804ff8 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  804fa9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804fac:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804faf:	74 42                	je     804ff3 <_pipeisclosed+0xc7>
  804fb1:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  804fb5:	75 3c                	jne    804ff3 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804fb7:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  804fbe:	00 00 00 
  804fc1:	48 8b 00             	mov    (%rax),%rax
  804fc4:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  804fca:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804fcd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804fd0:	89 c6                	mov    %eax,%esi
  804fd2:	48 bf 13 61 80 00 00 	movabs $0x806113,%rdi
  804fd9:	00 00 00 
  804fdc:	b8 00 00 00 00       	mov    $0x0,%eax
  804fe1:	49 b8 1d 0b 80 00 00 	movabs $0x800b1d,%r8
  804fe8:	00 00 00 
  804feb:	41 ff d0             	callq  *%r8
	}
  804fee:	e9 4a ff ff ff       	jmpq   804f3d <_pipeisclosed+0x11>
  804ff3:	e9 45 ff ff ff       	jmpq   804f3d <_pipeisclosed+0x11>
}
  804ff8:	48 83 c4 28          	add    $0x28,%rsp
  804ffc:	5b                   	pop    %rbx
  804ffd:	5d                   	pop    %rbp
  804ffe:	c3                   	retq   

0000000000804fff <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  804fff:	55                   	push   %rbp
  805000:	48 89 e5             	mov    %rsp,%rbp
  805003:	48 83 ec 30          	sub    $0x30,%rsp
  805007:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80500a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80500e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805011:	48 89 d6             	mov    %rdx,%rsi
  805014:	89 c7                	mov    %eax,%edi
  805016:	48 b8 b8 2a 80 00 00 	movabs $0x802ab8,%rax
  80501d:	00 00 00 
  805020:	ff d0                	callq  *%rax
  805022:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805025:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805029:	79 05                	jns    805030 <pipeisclosed+0x31>
		return r;
  80502b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80502e:	eb 31                	jmp    805061 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  805030:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805034:	48 89 c7             	mov    %rax,%rdi
  805037:	48 b8 f5 29 80 00 00 	movabs $0x8029f5,%rax
  80503e:	00 00 00 
  805041:	ff d0                	callq  *%rax
  805043:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  805047:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80504b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80504f:	48 89 d6             	mov    %rdx,%rsi
  805052:	48 89 c7             	mov    %rax,%rdi
  805055:	48 b8 2c 4f 80 00 00 	movabs $0x804f2c,%rax
  80505c:	00 00 00 
  80505f:	ff d0                	callq  *%rax
}
  805061:	c9                   	leaveq 
  805062:	c3                   	retq   

0000000000805063 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  805063:	55                   	push   %rbp
  805064:	48 89 e5             	mov    %rsp,%rbp
  805067:	48 83 ec 40          	sub    $0x40,%rsp
  80506b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80506f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  805073:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  805077:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80507b:	48 89 c7             	mov    %rax,%rdi
  80507e:	48 b8 f5 29 80 00 00 	movabs $0x8029f5,%rax
  805085:	00 00 00 
  805088:	ff d0                	callq  *%rax
  80508a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80508e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805092:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  805096:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80509d:	00 
  80509e:	e9 92 00 00 00       	jmpq   805135 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8050a3:	eb 41                	jmp    8050e6 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8050a5:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8050aa:	74 09                	je     8050b5 <devpipe_read+0x52>
				return i;
  8050ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8050b0:	e9 92 00 00 00       	jmpq   805147 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8050b5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8050b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8050bd:	48 89 d6             	mov    %rdx,%rsi
  8050c0:	48 89 c7             	mov    %rax,%rdi
  8050c3:	48 b8 2c 4f 80 00 00 	movabs $0x804f2c,%rax
  8050ca:	00 00 00 
  8050cd:	ff d0                	callq  *%rax
  8050cf:	85 c0                	test   %eax,%eax
  8050d1:	74 07                	je     8050da <devpipe_read+0x77>
				return 0;
  8050d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8050d8:	eb 6d                	jmp    805147 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8050da:	48 b8 c3 1f 80 00 00 	movabs $0x801fc3,%rax
  8050e1:	00 00 00 
  8050e4:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8050e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8050ea:	8b 10                	mov    (%rax),%edx
  8050ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8050f0:	8b 40 04             	mov    0x4(%rax),%eax
  8050f3:	39 c2                	cmp    %eax,%edx
  8050f5:	74 ae                	je     8050a5 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8050f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8050fb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8050ff:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  805103:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805107:	8b 00                	mov    (%rax),%eax
  805109:	99                   	cltd   
  80510a:	c1 ea 1b             	shr    $0x1b,%edx
  80510d:	01 d0                	add    %edx,%eax
  80510f:	83 e0 1f             	and    $0x1f,%eax
  805112:	29 d0                	sub    %edx,%eax
  805114:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805118:	48 98                	cltq   
  80511a:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80511f:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  805121:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805125:	8b 00                	mov    (%rax),%eax
  805127:	8d 50 01             	lea    0x1(%rax),%edx
  80512a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80512e:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  805130:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  805135:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805139:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80513d:	0f 82 60 ff ff ff    	jb     8050a3 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  805143:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  805147:	c9                   	leaveq 
  805148:	c3                   	retq   

0000000000805149 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  805149:	55                   	push   %rbp
  80514a:	48 89 e5             	mov    %rsp,%rbp
  80514d:	48 83 ec 40          	sub    $0x40,%rsp
  805151:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  805155:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  805159:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80515d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805161:	48 89 c7             	mov    %rax,%rdi
  805164:	48 b8 f5 29 80 00 00 	movabs $0x8029f5,%rax
  80516b:	00 00 00 
  80516e:	ff d0                	callq  *%rax
  805170:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  805174:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805178:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80517c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  805183:	00 
  805184:	e9 8e 00 00 00       	jmpq   805217 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  805189:	eb 31                	jmp    8051bc <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80518b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80518f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805193:	48 89 d6             	mov    %rdx,%rsi
  805196:	48 89 c7             	mov    %rax,%rdi
  805199:	48 b8 2c 4f 80 00 00 	movabs $0x804f2c,%rax
  8051a0:	00 00 00 
  8051a3:	ff d0                	callq  *%rax
  8051a5:	85 c0                	test   %eax,%eax
  8051a7:	74 07                	je     8051b0 <devpipe_write+0x67>
				return 0;
  8051a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8051ae:	eb 79                	jmp    805229 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8051b0:	48 b8 c3 1f 80 00 00 	movabs $0x801fc3,%rax
  8051b7:	00 00 00 
  8051ba:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8051bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8051c0:	8b 40 04             	mov    0x4(%rax),%eax
  8051c3:	48 63 d0             	movslq %eax,%rdx
  8051c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8051ca:	8b 00                	mov    (%rax),%eax
  8051cc:	48 98                	cltq   
  8051ce:	48 83 c0 20          	add    $0x20,%rax
  8051d2:	48 39 c2             	cmp    %rax,%rdx
  8051d5:	73 b4                	jae    80518b <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8051d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8051db:	8b 40 04             	mov    0x4(%rax),%eax
  8051de:	99                   	cltd   
  8051df:	c1 ea 1b             	shr    $0x1b,%edx
  8051e2:	01 d0                	add    %edx,%eax
  8051e4:	83 e0 1f             	and    $0x1f,%eax
  8051e7:	29 d0                	sub    %edx,%eax
  8051e9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8051ed:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8051f1:	48 01 ca             	add    %rcx,%rdx
  8051f4:	0f b6 0a             	movzbl (%rdx),%ecx
  8051f7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8051fb:	48 98                	cltq   
  8051fd:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  805201:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805205:	8b 40 04             	mov    0x4(%rax),%eax
  805208:	8d 50 01             	lea    0x1(%rax),%edx
  80520b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80520f:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  805212:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  805217:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80521b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80521f:	0f 82 64 ff ff ff    	jb     805189 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  805225:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  805229:	c9                   	leaveq 
  80522a:	c3                   	retq   

000000000080522b <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80522b:	55                   	push   %rbp
  80522c:	48 89 e5             	mov    %rsp,%rbp
  80522f:	48 83 ec 20          	sub    $0x20,%rsp
  805233:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805237:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80523b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80523f:	48 89 c7             	mov    %rax,%rdi
  805242:	48 b8 f5 29 80 00 00 	movabs $0x8029f5,%rax
  805249:	00 00 00 
  80524c:	ff d0                	callq  *%rax
  80524e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  805252:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805256:	48 be 26 61 80 00 00 	movabs $0x806126,%rsi
  80525d:	00 00 00 
  805260:	48 89 c7             	mov    %rax,%rdi
  805263:	48 b8 d2 16 80 00 00 	movabs $0x8016d2,%rax
  80526a:	00 00 00 
  80526d:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80526f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805273:	8b 50 04             	mov    0x4(%rax),%edx
  805276:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80527a:	8b 00                	mov    (%rax),%eax
  80527c:	29 c2                	sub    %eax,%edx
  80527e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805282:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  805288:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80528c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  805293:	00 00 00 
	stat->st_dev = &devpipe;
  805296:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80529a:	48 b9 00 81 80 00 00 	movabs $0x808100,%rcx
  8052a1:	00 00 00 
  8052a4:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8052ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8052b0:	c9                   	leaveq 
  8052b1:	c3                   	retq   

00000000008052b2 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8052b2:	55                   	push   %rbp
  8052b3:	48 89 e5             	mov    %rsp,%rbp
  8052b6:	48 83 ec 10          	sub    $0x10,%rsp
  8052ba:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8052be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8052c2:	48 89 c6             	mov    %rax,%rsi
  8052c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8052ca:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  8052d1:	00 00 00 
  8052d4:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8052d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8052da:	48 89 c7             	mov    %rax,%rdi
  8052dd:	48 b8 f5 29 80 00 00 	movabs $0x8029f5,%rax
  8052e4:	00 00 00 
  8052e7:	ff d0                	callq  *%rax
  8052e9:	48 89 c6             	mov    %rax,%rsi
  8052ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8052f1:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  8052f8:	00 00 00 
  8052fb:	ff d0                	callq  *%rax
}
  8052fd:	c9                   	leaveq 
  8052fe:	c3                   	retq   

00000000008052ff <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8052ff:	55                   	push   %rbp
  805300:	48 89 e5             	mov    %rsp,%rbp
  805303:	48 83 ec 20          	sub    $0x20,%rsp
  805307:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  80530a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80530e:	75 35                	jne    805345 <wait+0x46>
  805310:	48 b9 2d 61 80 00 00 	movabs $0x80612d,%rcx
  805317:	00 00 00 
  80531a:	48 ba 38 61 80 00 00 	movabs $0x806138,%rdx
  805321:	00 00 00 
  805324:	be 09 00 00 00       	mov    $0x9,%esi
  805329:	48 bf 4d 61 80 00 00 	movabs $0x80614d,%rdi
  805330:	00 00 00 
  805333:	b8 00 00 00 00       	mov    $0x0,%eax
  805338:	49 b8 e4 08 80 00 00 	movabs $0x8008e4,%r8
  80533f:	00 00 00 
  805342:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  805345:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805348:	25 ff 03 00 00       	and    $0x3ff,%eax
  80534d:	48 63 d0             	movslq %eax,%rdx
  805350:	48 89 d0             	mov    %rdx,%rax
  805353:	48 c1 e0 03          	shl    $0x3,%rax
  805357:	48 01 d0             	add    %rdx,%rax
  80535a:	48 c1 e0 05          	shl    $0x5,%rax
  80535e:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  805365:	00 00 00 
  805368:	48 01 d0             	add    %rdx,%rax
  80536b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE){
  80536f:	eb 0c                	jmp    80537d <wait+0x7e>
	//cprintf("envid is [%d]",envid);
		sys_yield();
  805371:	48 b8 c3 1f 80 00 00 	movabs $0x801fc3,%rax
  805378:	00 00 00 
  80537b:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE){
  80537d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805381:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  805387:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80538a:	75 0e                	jne    80539a <wait+0x9b>
  80538c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805390:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  805396:	85 c0                	test   %eax,%eax
  805398:	75 d7                	jne    805371 <wait+0x72>
	//cprintf("envid is [%d]",envid);
		sys_yield();
	}
}
  80539a:	c9                   	leaveq 
  80539b:	c3                   	retq   

000000000080539c <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80539c:	55                   	push   %rbp
  80539d:	48 89 e5             	mov    %rsp,%rbp
  8053a0:	48 83 ec 10          	sub    $0x10,%rsp
  8053a4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  8053a8:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8053af:	00 00 00 
  8053b2:	48 8b 00             	mov    (%rax),%rax
  8053b5:	48 85 c0             	test   %rax,%rax
  8053b8:	0f 85 84 00 00 00    	jne    805442 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  8053be:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8053c5:	00 00 00 
  8053c8:	48 8b 00             	mov    (%rax),%rax
  8053cb:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8053d1:	ba 07 00 00 00       	mov    $0x7,%edx
  8053d6:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8053db:	89 c7                	mov    %eax,%edi
  8053dd:	48 b8 01 20 80 00 00 	movabs $0x802001,%rax
  8053e4:	00 00 00 
  8053e7:	ff d0                	callq  *%rax
  8053e9:	85 c0                	test   %eax,%eax
  8053eb:	79 2a                	jns    805417 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  8053ed:	48 ba 58 61 80 00 00 	movabs $0x806158,%rdx
  8053f4:	00 00 00 
  8053f7:	be 23 00 00 00       	mov    $0x23,%esi
  8053fc:	48 bf 7f 61 80 00 00 	movabs $0x80617f,%rdi
  805403:	00 00 00 
  805406:	b8 00 00 00 00       	mov    $0x0,%eax
  80540b:	48 b9 e4 08 80 00 00 	movabs $0x8008e4,%rcx
  805412:	00 00 00 
  805415:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  805417:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  80541e:	00 00 00 
  805421:	48 8b 00             	mov    (%rax),%rax
  805424:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80542a:	48 be 55 54 80 00 00 	movabs $0x805455,%rsi
  805431:	00 00 00 
  805434:	89 c7                	mov    %eax,%edi
  805436:	48 b8 8b 21 80 00 00 	movabs $0x80218b,%rax
  80543d:	00 00 00 
  805440:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  805442:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805449:	00 00 00 
  80544c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  805450:	48 89 10             	mov    %rdx,(%rax)
}
  805453:	c9                   	leaveq 
  805454:	c3                   	retq   

0000000000805455 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  805455:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  805458:	48 a1 00 d0 80 00 00 	movabs 0x80d000,%rax
  80545f:	00 00 00 
call *%rax
  805462:	ff d0                	callq  *%rax
    // LAB 4: Your code here.

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.

	movq 136(%rsp), %rbx  //Load RIP 
  805464:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  80546b:	00 
	movq 152(%rsp), %rcx  //Load RSP
  80546c:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  805473:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  805474:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  805478:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  80547b:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  805482:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  805483:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  805487:	4c 8b 3c 24          	mov    (%rsp),%r15
  80548b:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  805490:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  805495:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  80549a:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  80549f:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8054a4:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8054a9:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8054ae:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8054b3:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8054b8:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8054bd:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8054c2:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8054c7:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8054cc:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8054d1:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  8054d5:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  8054d9:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  8054da:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8054db:	c3                   	retq   

00000000008054dc <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8054dc:	55                   	push   %rbp
  8054dd:	48 89 e5             	mov    %rsp,%rbp
  8054e0:	48 83 ec 30          	sub    $0x30,%rsp
  8054e4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8054e8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8054ec:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  8054f0:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8054f7:	00 00 00 
  8054fa:	48 8b 00             	mov    (%rax),%rax
  8054fd:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  805503:	85 c0                	test   %eax,%eax
  805505:	75 3c                	jne    805543 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  805507:	48 b8 85 1f 80 00 00 	movabs $0x801f85,%rax
  80550e:	00 00 00 
  805511:	ff d0                	callq  *%rax
  805513:	25 ff 03 00 00       	and    $0x3ff,%eax
  805518:	48 63 d0             	movslq %eax,%rdx
  80551b:	48 89 d0             	mov    %rdx,%rax
  80551e:	48 c1 e0 03          	shl    $0x3,%rax
  805522:	48 01 d0             	add    %rdx,%rax
  805525:	48 c1 e0 05          	shl    $0x5,%rax
  805529:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  805530:	00 00 00 
  805533:	48 01 c2             	add    %rax,%rdx
  805536:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  80553d:	00 00 00 
  805540:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  805543:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  805548:	75 0e                	jne    805558 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  80554a:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  805551:	00 00 00 
  805554:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  805558:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80555c:	48 89 c7             	mov    %rax,%rdi
  80555f:	48 b8 2a 22 80 00 00 	movabs $0x80222a,%rax
  805566:	00 00 00 
  805569:	ff d0                	callq  *%rax
  80556b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  80556e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805572:	79 19                	jns    80558d <ipc_recv+0xb1>
		*from_env_store = 0;
  805574:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805578:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  80557e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805582:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  805588:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80558b:	eb 53                	jmp    8055e0 <ipc_recv+0x104>
	}
	if(from_env_store)
  80558d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  805592:	74 19                	je     8055ad <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  805594:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  80559b:	00 00 00 
  80559e:	48 8b 00             	mov    (%rax),%rax
  8055a1:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8055a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8055ab:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  8055ad:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8055b2:	74 19                	je     8055cd <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  8055b4:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8055bb:	00 00 00 
  8055be:	48 8b 00             	mov    (%rax),%rax
  8055c1:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8055c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8055cb:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  8055cd:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8055d4:	00 00 00 
  8055d7:	48 8b 00             	mov    (%rax),%rax
  8055da:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  8055e0:	c9                   	leaveq 
  8055e1:	c3                   	retq   

00000000008055e2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8055e2:	55                   	push   %rbp
  8055e3:	48 89 e5             	mov    %rsp,%rbp
  8055e6:	48 83 ec 30          	sub    $0x30,%rsp
  8055ea:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8055ed:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8055f0:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8055f4:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  8055f7:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8055fc:	75 0e                	jne    80560c <ipc_send+0x2a>
		pg = (void*)UTOP;
  8055fe:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  805605:	00 00 00 
  805608:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  80560c:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80560f:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  805612:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  805616:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805619:	89 c7                	mov    %eax,%edi
  80561b:	48 b8 d5 21 80 00 00 	movabs $0x8021d5,%rax
  805622:	00 00 00 
  805625:	ff d0                	callq  *%rax
  805627:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  80562a:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80562e:	75 0c                	jne    80563c <ipc_send+0x5a>
			sys_yield();
  805630:	48 b8 c3 1f 80 00 00 	movabs $0x801fc3,%rax
  805637:	00 00 00 
  80563a:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  80563c:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  805640:	74 ca                	je     80560c <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  805642:	c9                   	leaveq 
  805643:	c3                   	retq   

0000000000805644 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  805644:	55                   	push   %rbp
  805645:	48 89 e5             	mov    %rsp,%rbp
  805648:	48 83 ec 14          	sub    $0x14,%rsp
  80564c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80564f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  805656:	eb 5e                	jmp    8056b6 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  805658:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80565f:	00 00 00 
  805662:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805665:	48 63 d0             	movslq %eax,%rdx
  805668:	48 89 d0             	mov    %rdx,%rax
  80566b:	48 c1 e0 03          	shl    $0x3,%rax
  80566f:	48 01 d0             	add    %rdx,%rax
  805672:	48 c1 e0 05          	shl    $0x5,%rax
  805676:	48 01 c8             	add    %rcx,%rax
  805679:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80567f:	8b 00                	mov    (%rax),%eax
  805681:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  805684:	75 2c                	jne    8056b2 <ipc_find_env+0x6e>
			return envs[i].env_id;
  805686:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80568d:	00 00 00 
  805690:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805693:	48 63 d0             	movslq %eax,%rdx
  805696:	48 89 d0             	mov    %rdx,%rax
  805699:	48 c1 e0 03          	shl    $0x3,%rax
  80569d:	48 01 d0             	add    %rdx,%rax
  8056a0:	48 c1 e0 05          	shl    $0x5,%rax
  8056a4:	48 01 c8             	add    %rcx,%rax
  8056a7:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8056ad:	8b 40 08             	mov    0x8(%rax),%eax
  8056b0:	eb 12                	jmp    8056c4 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8056b2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8056b6:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8056bd:	7e 99                	jle    805658 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8056bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8056c4:	c9                   	leaveq 
  8056c5:	c3                   	retq   

00000000008056c6 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8056c6:	55                   	push   %rbp
  8056c7:	48 89 e5             	mov    %rsp,%rbp
  8056ca:	48 83 ec 18          	sub    $0x18,%rsp
  8056ce:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8056d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8056d6:	48 c1 e8 15          	shr    $0x15,%rax
  8056da:	48 89 c2             	mov    %rax,%rdx
  8056dd:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8056e4:	01 00 00 
  8056e7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8056eb:	83 e0 01             	and    $0x1,%eax
  8056ee:	48 85 c0             	test   %rax,%rax
  8056f1:	75 07                	jne    8056fa <pageref+0x34>
		return 0;
  8056f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8056f8:	eb 53                	jmp    80574d <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8056fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8056fe:	48 c1 e8 0c          	shr    $0xc,%rax
  805702:	48 89 c2             	mov    %rax,%rdx
  805705:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80570c:	01 00 00 
  80570f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805713:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  805717:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80571b:	83 e0 01             	and    $0x1,%eax
  80571e:	48 85 c0             	test   %rax,%rax
  805721:	75 07                	jne    80572a <pageref+0x64>
		return 0;
  805723:	b8 00 00 00 00       	mov    $0x0,%eax
  805728:	eb 23                	jmp    80574d <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  80572a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80572e:	48 c1 e8 0c          	shr    $0xc,%rax
  805732:	48 89 c2             	mov    %rax,%rdx
  805735:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80573c:	00 00 00 
  80573f:	48 c1 e2 04          	shl    $0x4,%rdx
  805743:	48 01 d0             	add    %rdx,%rax
  805746:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80574a:	0f b7 c0             	movzwl %ax,%eax
}
  80574d:	c9                   	leaveq 
  80574e:	c3                   	retq   
