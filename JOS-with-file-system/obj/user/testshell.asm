
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
  800057:	48 b8 fe 2b 80 00 00 	movabs $0x802bfe,%rax
  80005e:	00 00 00 
  800061:	ff d0                	callq  *%rax
	close(1);
  800063:	bf 01 00 00 00       	mov    $0x1,%edi
  800068:	48 b8 fe 2b 80 00 00 	movabs $0x802bfe,%rax
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
  800091:	48 bf a0 4c 80 00 00 	movabs $0x804ca0,%rdi
  800098:	00 00 00 
  80009b:	48 b8 f6 32 80 00 00 	movabs $0x8032f6,%rax
  8000a2:	00 00 00 
  8000a5:	ff d0                	callq  *%rax
  8000a7:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8000aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8000ae:	79 30                	jns    8000e0 <umain+0x9d>
		panic("open testshell.sh: %e", rfd);
  8000b0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8000b3:	89 c1                	mov    %eax,%ecx
  8000b5:	48 ba ad 4c 80 00 00 	movabs $0x804cad,%rdx
  8000bc:	00 00 00 
  8000bf:	be 13 00 00 00       	mov    $0x13,%esi
  8000c4:	48 bf c3 4c 80 00 00 	movabs $0x804cc3,%rdi
  8000cb:	00 00 00 
  8000ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d3:	49 b8 e4 08 80 00 00 	movabs $0x8008e4,%r8
  8000da:	00 00 00 
  8000dd:	41 ff d0             	callq  *%r8
	if ((wfd = pipe(pfds)) < 0)
  8000e0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8000e4:	48 89 c7             	mov    %rax,%rdi
  8000e7:	48 b8 85 42 80 00 00 	movabs $0x804285,%rax
  8000ee:	00 00 00 
  8000f1:	ff d0                	callq  *%rax
  8000f3:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8000f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8000fa:	79 30                	jns    80012c <umain+0xe9>
		panic("pipe: %e", wfd);
  8000fc:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8000ff:	89 c1                	mov    %eax,%ecx
  800101:	48 ba d4 4c 80 00 00 	movabs $0x804cd4,%rdx
  800108:	00 00 00 
  80010b:	be 15 00 00 00       	mov    $0x15,%esi
  800110:	48 bf c3 4c 80 00 00 	movabs $0x804cc3,%rdi
  800117:	00 00 00 
  80011a:	b8 00 00 00 00       	mov    $0x0,%eax
  80011f:	49 b8 e4 08 80 00 00 	movabs $0x8008e4,%r8
  800126:	00 00 00 
  800129:	41 ff d0             	callq  *%r8
	wfd = pfds[1];
  80012c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80012f:	89 45 f0             	mov    %eax,-0x10(%rbp)

	cprintf("running sh -x < testshell.sh | cat\n");
  800132:	48 bf e0 4c 80 00 00 	movabs $0x804ce0,%rdi
  800139:	00 00 00 
  80013c:	b8 00 00 00 00       	mov    $0x0,%eax
  800141:	48 ba 1d 0b 80 00 00 	movabs $0x800b1d,%rdx
  800148:	00 00 00 
  80014b:	ff d2                	callq  *%rdx
	if ((r = fork()) < 0)
  80014d:	48 b8 57 26 80 00 00 	movabs $0x802657,%rax
  800154:	00 00 00 
  800157:	ff d0                	callq  *%rax
  800159:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80015c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800160:	79 30                	jns    800192 <umain+0x14f>
		panic("fork: %e", r);
  800162:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800165:	89 c1                	mov    %eax,%ecx
  800167:	48 ba 04 4d 80 00 00 	movabs $0x804d04,%rdx
  80016e:	00 00 00 
  800171:	be 1a 00 00 00       	mov    $0x1a,%esi
  800176:	48 bf c3 4c 80 00 00 	movabs $0x804cc3,%rdi
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
  8001a6:	48 b8 77 2c 80 00 00 	movabs $0x802c77,%rax
  8001ad:	00 00 00 
  8001b0:	ff d0                	callq  *%rax
		dup(wfd, 1);
  8001b2:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001b5:	be 01 00 00 00       	mov    $0x1,%esi
  8001ba:	89 c7                	mov    %eax,%edi
  8001bc:	48 b8 77 2c 80 00 00 	movabs $0x802c77,%rax
  8001c3:	00 00 00 
  8001c6:	ff d0                	callq  *%rax
		close(rfd);
  8001c8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8001cb:	89 c7                	mov    %eax,%edi
  8001cd:	48 b8 fe 2b 80 00 00 	movabs $0x802bfe,%rax
  8001d4:	00 00 00 
  8001d7:	ff d0                	callq  *%rax
		close(wfd);
  8001d9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001dc:	89 c7                	mov    %eax,%edi
  8001de:	48 b8 fe 2b 80 00 00 	movabs $0x802bfe,%rax
  8001e5:	00 00 00 
  8001e8:	ff d0                	callq  *%rax
		if ((r = spawnl("/bin/sh", "sh", "-x", 0)) < 0)
  8001ea:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001ef:	48 ba 0d 4d 80 00 00 	movabs $0x804d0d,%rdx
  8001f6:	00 00 00 
  8001f9:	48 be 10 4d 80 00 00 	movabs $0x804d10,%rsi
  800200:	00 00 00 
  800203:	48 bf 13 4d 80 00 00 	movabs $0x804d13,%rdi
  80020a:	00 00 00 
  80020d:	b8 00 00 00 00       	mov    $0x0,%eax
  800212:	49 b8 8c 3a 80 00 00 	movabs $0x803a8c,%r8
  800219:	00 00 00 
  80021c:	41 ff d0             	callq  *%r8
  80021f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800222:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800226:	79 30                	jns    800258 <umain+0x215>
			panic("spawn: %e", r);
  800228:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80022b:	89 c1                	mov    %eax,%ecx
  80022d:	48 ba 1b 4d 80 00 00 	movabs $0x804d1b,%rdx
  800234:	00 00 00 
  800237:	be 21 00 00 00       	mov    $0x21,%esi
  80023c:	48 bf c3 4c 80 00 00 	movabs $0x804cc3,%rdi
  800243:	00 00 00 
  800246:	b8 00 00 00 00       	mov    $0x0,%eax
  80024b:	49 b8 e4 08 80 00 00 	movabs $0x8008e4,%r8
  800252:	00 00 00 
  800255:	41 ff d0             	callq  *%r8
		close(0);
  800258:	bf 00 00 00 00       	mov    $0x0,%edi
  80025d:	48 b8 fe 2b 80 00 00 	movabs $0x802bfe,%rax
  800264:	00 00 00 
  800267:	ff d0                	callq  *%rax
		close(1);
  800269:	bf 01 00 00 00       	mov    $0x1,%edi
  80026e:	48 b8 fe 2b 80 00 00 	movabs $0x802bfe,%rax
  800275:	00 00 00 
  800278:	ff d0                	callq  *%rax
		wait(r);
  80027a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80027d:	89 c7                	mov    %eax,%edi
  80027f:	48 b8 4e 48 80 00 00 	movabs $0x80484e,%rax
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
  80029c:	48 b8 fe 2b 80 00 00 	movabs $0x802bfe,%rax
  8002a3:	00 00 00 
  8002a6:	ff d0                	callq  *%rax
	close(wfd);
  8002a8:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002ab:	89 c7                	mov    %eax,%edi
  8002ad:	48 b8 fe 2b 80 00 00 	movabs $0x802bfe,%rax
  8002b4:	00 00 00 
  8002b7:	ff d0                	callq  *%rax

	rfd = pfds[0];
  8002b9:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8002bc:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8002bf:	be 00 00 00 00       	mov    $0x0,%esi
  8002c4:	48 bf 25 4d 80 00 00 	movabs $0x804d25,%rdi
  8002cb:	00 00 00 
  8002ce:	48 b8 f6 32 80 00 00 	movabs $0x8032f6,%rax
  8002d5:	00 00 00 
  8002d8:	ff d0                	callq  *%rax
  8002da:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8002dd:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8002e1:	79 30                	jns    800313 <umain+0x2d0>
		panic("open testshell.key for reading: %e", kfd);
  8002e3:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8002e6:	89 c1                	mov    %eax,%ecx
  8002e8:	48 ba 38 4d 80 00 00 	movabs $0x804d38,%rdx
  8002ef:	00 00 00 
  8002f2:	be 2c 00 00 00       	mov    $0x2c,%esi
  8002f7:	48 bf c3 4c 80 00 00 	movabs $0x804cc3,%rdi
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
  800332:	48 b8 20 2e 80 00 00 	movabs $0x802e20,%rax
  800339:	00 00 00 
  80033c:	ff d0                	callq  *%rax
  80033e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		n2 = read(kfd, &c2, 1);
  800341:	48 8d 4d de          	lea    -0x22(%rbp),%rcx
  800345:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800348:	ba 01 00 00 00       	mov    $0x1,%edx
  80034d:	48 89 ce             	mov    %rcx,%rsi
  800350:	89 c7                	mov    %eax,%edi
  800352:	48 b8 20 2e 80 00 00 	movabs $0x802e20,%rax
  800359:	00 00 00 
  80035c:	ff d0                	callq  *%rax
  80035e:	89 45 e0             	mov    %eax,-0x20(%rbp)
		if (n1 < 0)
  800361:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800365:	79 30                	jns    800397 <umain+0x354>
			panic("reading testshell.out: %e", n1);
  800367:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80036a:	89 c1                	mov    %eax,%ecx
  80036c:	48 ba 5b 4d 80 00 00 	movabs $0x804d5b,%rdx
  800373:	00 00 00 
  800376:	be 33 00 00 00       	mov    $0x33,%esi
  80037b:	48 bf c3 4c 80 00 00 	movabs $0x804cc3,%rdi
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
  8003a2:	48 ba 75 4d 80 00 00 	movabs $0x804d75,%rdx
  8003a9:	00 00 00 
  8003ac:	be 35 00 00 00       	mov    $0x35,%esi
  8003b1:	48 bf c3 4c 80 00 00 	movabs $0x804cc3,%rdi
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
  800426:	48 bf 8f 4d 80 00 00 	movabs $0x804d8f,%rdi
  80042d:	00 00 00 
  800430:	b8 00 00 00 00       	mov    $0x0,%eax
  800435:	48 ba 1d 0b 80 00 00 	movabs $0x800b1d,%rdx
  80043c:	00 00 00 
  80043f:	ff d2                	callq  *%rdx
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

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
  80045f:	48 b8 3e 30 80 00 00 	movabs $0x80303e,%rax
  800466:	00 00 00 
  800469:	ff d0                	callq  *%rax
	seek(kfd, off);
  80046b:	8b 55 84             	mov    -0x7c(%rbp),%edx
  80046e:	8b 45 88             	mov    -0x78(%rbp),%eax
  800471:	89 d6                	mov    %edx,%esi
  800473:	89 c7                	mov    %eax,%edi
  800475:	48 b8 3e 30 80 00 00 	movabs $0x80303e,%rax
  80047c:	00 00 00 
  80047f:	ff d0                	callq  *%rax

	cprintf("shell produced incorrect output.\n");
  800481:	48 bf a8 4d 80 00 00 	movabs $0x804da8,%rdi
  800488:	00 00 00 
  80048b:	b8 00 00 00 00       	mov    $0x0,%eax
  800490:	48 ba 1d 0b 80 00 00 	movabs $0x800b1d,%rdx
  800497:	00 00 00 
  80049a:	ff d2                	callq  *%rdx
	cprintf("expected:\n===\n");
  80049c:	48 bf ca 4d 80 00 00 	movabs $0x804dca,%rdi
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
  8004e6:	48 b8 20 2e 80 00 00 	movabs $0x802e20,%rax
  8004ed:	00 00 00 
  8004f0:	ff d0                	callq  *%rax
  8004f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8004f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004f9:	7f be                	jg     8004b9 <wrong+0x75>
		sys_cputs(buf, n);
	cprintf("===\ngot:\n===\n");
  8004fb:	48 bf d9 4d 80 00 00 	movabs $0x804dd9,%rdi
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
  800545:	48 b8 20 2e 80 00 00 	movabs $0x802e20,%rax
  80054c:	00 00 00 
  80054f:	ff d0                	callq  *%rax
  800551:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800554:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800558:	7f be                	jg     800518 <wrong+0xd4>
		sys_cputs(buf, n);
	cprintf("===\n");
  80055a:	48 bf e7 4d 80 00 00 	movabs $0x804de7,%rdi
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
  8005c7:	48 b8 20 2e 80 00 00 	movabs $0x802e20,%rax
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
  80060e:	48 b8 ee 29 80 00 00 	movabs $0x8029ee,%rax
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
  80062e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
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
  800653:	48 b8 56 29 80 00 00 	movabs $0x802956,%rax
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
  80069c:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8006a3:	00 00 00 
  8006a6:	8b 12                	mov    (%rdx),%edx
  8006a8:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8006aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006ae:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8006b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006b9:	48 89 c7             	mov    %rax,%rdi
  8006bc:	48 b8 08 29 80 00 00 	movabs $0x802908,%rax
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
  800816:	48 be f1 4d 80 00 00 	movabs $0x804df1,%rsi
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
  800874:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
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
  80088e:	48 b8 38 70 80 00 00 	movabs $0x807038,%rax
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
  8008c5:	48 b8 49 2c 80 00 00 	movabs $0x802c49,%rax
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
  80096d:	48 b8 38 70 80 00 00 	movabs $0x807038,%rax
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
  80099e:	48 bf 08 4e 80 00 00 	movabs $0x804e08,%rdi
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
  8009da:	48 bf 2b 4e 80 00 00 	movabs $0x804e2b,%rdi
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
  800c89:	48 ba 08 50 80 00 00 	movabs $0x805008,%rdx
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
  800f81:	48 b8 30 50 80 00 00 	movabs $0x805030,%rax
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
  8010cf:	83 fb 10             	cmp    $0x10,%ebx
  8010d2:	7f 16                	jg     8010ea <vprintfmt+0x21a>
  8010d4:	48 b8 80 4f 80 00 00 	movabs $0x804f80,%rax
  8010db:	00 00 00 
  8010de:	48 63 d3             	movslq %ebx,%rdx
  8010e1:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8010e5:	4d 85 e4             	test   %r12,%r12
  8010e8:	75 2e                	jne    801118 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8010ea:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8010ee:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010f2:	89 d9                	mov    %ebx,%ecx
  8010f4:	48 ba 19 50 80 00 00 	movabs $0x805019,%rdx
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
  801123:	48 ba 22 50 80 00 00 	movabs $0x805022,%rdx
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
  80117d:	49 bc 25 50 80 00 00 	movabs $0x805025,%r12
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
  801e83:	48 ba e0 52 80 00 00 	movabs $0x8052e0,%rdx
  801e8a:	00 00 00 
  801e8d:	be 23 00 00 00       	mov    $0x23,%esi
  801e92:	48 bf fd 52 80 00 00 	movabs $0x8052fd,%rdi
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

000000000080226e <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  80226e:	55                   	push   %rbp
  80226f:	48 89 e5             	mov    %rsp,%rbp
  802272:	48 83 ec 30          	sub    $0x30,%rsp
  802276:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  80227a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80227e:	48 8b 00             	mov    (%rax),%rax
  802281:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  802285:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802289:	48 8b 40 08          	mov    0x8(%rax),%rax
  80228d:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  802290:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802293:	83 e0 02             	and    $0x2,%eax
  802296:	85 c0                	test   %eax,%eax
  802298:	75 4d                	jne    8022e7 <pgfault+0x79>
  80229a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80229e:	48 c1 e8 0c          	shr    $0xc,%rax
  8022a2:	48 89 c2             	mov    %rax,%rdx
  8022a5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022ac:	01 00 00 
  8022af:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022b3:	25 00 08 00 00       	and    $0x800,%eax
  8022b8:	48 85 c0             	test   %rax,%rax
  8022bb:	74 2a                	je     8022e7 <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  8022bd:	48 ba 10 53 80 00 00 	movabs $0x805310,%rdx
  8022c4:	00 00 00 
  8022c7:	be 23 00 00 00       	mov    $0x23,%esi
  8022cc:	48 bf 45 53 80 00 00 	movabs $0x805345,%rdi
  8022d3:	00 00 00 
  8022d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8022db:	48 b9 e4 08 80 00 00 	movabs $0x8008e4,%rcx
  8022e2:	00 00 00 
  8022e5:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  8022e7:	ba 07 00 00 00       	mov    $0x7,%edx
  8022ec:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8022f1:	bf 00 00 00 00       	mov    $0x0,%edi
  8022f6:	48 b8 01 20 80 00 00 	movabs $0x802001,%rax
  8022fd:	00 00 00 
  802300:	ff d0                	callq  *%rax
  802302:	85 c0                	test   %eax,%eax
  802304:	0f 85 cd 00 00 00    	jne    8023d7 <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  80230a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80230e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802312:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802316:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80231c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  802320:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802324:	ba 00 10 00 00       	mov    $0x1000,%edx
  802329:	48 89 c6             	mov    %rax,%rsi
  80232c:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802331:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  802338:	00 00 00 
  80233b:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  80233d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802341:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802347:	48 89 c1             	mov    %rax,%rcx
  80234a:	ba 00 00 00 00       	mov    $0x0,%edx
  80234f:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802354:	bf 00 00 00 00       	mov    $0x0,%edi
  802359:	48 b8 51 20 80 00 00 	movabs $0x802051,%rax
  802360:	00 00 00 
  802363:	ff d0                	callq  *%rax
  802365:	85 c0                	test   %eax,%eax
  802367:	79 2a                	jns    802393 <pgfault+0x125>
				panic("Page map at temp address failed");
  802369:	48 ba 50 53 80 00 00 	movabs $0x805350,%rdx
  802370:	00 00 00 
  802373:	be 30 00 00 00       	mov    $0x30,%esi
  802378:	48 bf 45 53 80 00 00 	movabs $0x805345,%rdi
  80237f:	00 00 00 
  802382:	b8 00 00 00 00       	mov    $0x0,%eax
  802387:	48 b9 e4 08 80 00 00 	movabs $0x8008e4,%rcx
  80238e:	00 00 00 
  802391:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  802393:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802398:	bf 00 00 00 00       	mov    $0x0,%edi
  80239d:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  8023a4:	00 00 00 
  8023a7:	ff d0                	callq  *%rax
  8023a9:	85 c0                	test   %eax,%eax
  8023ab:	79 54                	jns    802401 <pgfault+0x193>
				panic("Page unmap from temp location failed");
  8023ad:	48 ba 70 53 80 00 00 	movabs $0x805370,%rdx
  8023b4:	00 00 00 
  8023b7:	be 32 00 00 00       	mov    $0x32,%esi
  8023bc:	48 bf 45 53 80 00 00 	movabs $0x805345,%rdi
  8023c3:	00 00 00 
  8023c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8023cb:	48 b9 e4 08 80 00 00 	movabs $0x8008e4,%rcx
  8023d2:	00 00 00 
  8023d5:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  8023d7:	48 ba 98 53 80 00 00 	movabs $0x805398,%rdx
  8023de:	00 00 00 
  8023e1:	be 34 00 00 00       	mov    $0x34,%esi
  8023e6:	48 bf 45 53 80 00 00 	movabs $0x805345,%rdi
  8023ed:	00 00 00 
  8023f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f5:	48 b9 e4 08 80 00 00 	movabs $0x8008e4,%rcx
  8023fc:	00 00 00 
  8023ff:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  802401:	c9                   	leaveq 
  802402:	c3                   	retq   

0000000000802403 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  802403:	55                   	push   %rbp
  802404:	48 89 e5             	mov    %rsp,%rbp
  802407:	48 83 ec 20          	sub    $0x20,%rsp
  80240b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80240e:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  802411:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802418:	01 00 00 
  80241b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80241e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802422:	25 07 0e 00 00       	and    $0xe07,%eax
  802427:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  80242a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80242d:	48 c1 e0 0c          	shl    $0xc,%rax
  802431:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  802435:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802438:	25 00 04 00 00       	and    $0x400,%eax
  80243d:	85 c0                	test   %eax,%eax
  80243f:	74 57                	je     802498 <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  802441:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802444:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802448:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80244b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80244f:	41 89 f0             	mov    %esi,%r8d
  802452:	48 89 c6             	mov    %rax,%rsi
  802455:	bf 00 00 00 00       	mov    $0x0,%edi
  80245a:	48 b8 51 20 80 00 00 	movabs $0x802051,%rax
  802461:	00 00 00 
  802464:	ff d0                	callq  *%rax
  802466:	85 c0                	test   %eax,%eax
  802468:	0f 8e 52 01 00 00    	jle    8025c0 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  80246e:	48 ba ca 53 80 00 00 	movabs $0x8053ca,%rdx
  802475:	00 00 00 
  802478:	be 4e 00 00 00       	mov    $0x4e,%esi
  80247d:	48 bf 45 53 80 00 00 	movabs $0x805345,%rdi
  802484:	00 00 00 
  802487:	b8 00 00 00 00       	mov    $0x0,%eax
  80248c:	48 b9 e4 08 80 00 00 	movabs $0x8008e4,%rcx
  802493:	00 00 00 
  802496:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  802498:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80249b:	83 e0 02             	and    $0x2,%eax
  80249e:	85 c0                	test   %eax,%eax
  8024a0:	75 10                	jne    8024b2 <duppage+0xaf>
  8024a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024a5:	25 00 08 00 00       	and    $0x800,%eax
  8024aa:	85 c0                	test   %eax,%eax
  8024ac:	0f 84 bb 00 00 00    	je     80256d <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  8024b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024b5:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  8024ba:	80 cc 08             	or     $0x8,%ah
  8024bd:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  8024c0:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8024c3:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8024c7:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8024ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024ce:	41 89 f0             	mov    %esi,%r8d
  8024d1:	48 89 c6             	mov    %rax,%rsi
  8024d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8024d9:	48 b8 51 20 80 00 00 	movabs $0x802051,%rax
  8024e0:	00 00 00 
  8024e3:	ff d0                	callq  *%rax
  8024e5:	85 c0                	test   %eax,%eax
  8024e7:	7e 2a                	jle    802513 <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  8024e9:	48 ba ca 53 80 00 00 	movabs $0x8053ca,%rdx
  8024f0:	00 00 00 
  8024f3:	be 55 00 00 00       	mov    $0x55,%esi
  8024f8:	48 bf 45 53 80 00 00 	movabs $0x805345,%rdi
  8024ff:	00 00 00 
  802502:	b8 00 00 00 00       	mov    $0x0,%eax
  802507:	48 b9 e4 08 80 00 00 	movabs $0x8008e4,%rcx
  80250e:	00 00 00 
  802511:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  802513:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  802516:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80251a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80251e:	41 89 c8             	mov    %ecx,%r8d
  802521:	48 89 d1             	mov    %rdx,%rcx
  802524:	ba 00 00 00 00       	mov    $0x0,%edx
  802529:	48 89 c6             	mov    %rax,%rsi
  80252c:	bf 00 00 00 00       	mov    $0x0,%edi
  802531:	48 b8 51 20 80 00 00 	movabs $0x802051,%rax
  802538:	00 00 00 
  80253b:	ff d0                	callq  *%rax
  80253d:	85 c0                	test   %eax,%eax
  80253f:	7e 2a                	jle    80256b <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  802541:	48 ba ca 53 80 00 00 	movabs $0x8053ca,%rdx
  802548:	00 00 00 
  80254b:	be 57 00 00 00       	mov    $0x57,%esi
  802550:	48 bf 45 53 80 00 00 	movabs $0x805345,%rdi
  802557:	00 00 00 
  80255a:	b8 00 00 00 00       	mov    $0x0,%eax
  80255f:	48 b9 e4 08 80 00 00 	movabs $0x8008e4,%rcx
  802566:	00 00 00 
  802569:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  80256b:	eb 53                	jmp    8025c0 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  80256d:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802570:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802574:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802577:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80257b:	41 89 f0             	mov    %esi,%r8d
  80257e:	48 89 c6             	mov    %rax,%rsi
  802581:	bf 00 00 00 00       	mov    $0x0,%edi
  802586:	48 b8 51 20 80 00 00 	movabs $0x802051,%rax
  80258d:	00 00 00 
  802590:	ff d0                	callq  *%rax
  802592:	85 c0                	test   %eax,%eax
  802594:	7e 2a                	jle    8025c0 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  802596:	48 ba ca 53 80 00 00 	movabs $0x8053ca,%rdx
  80259d:	00 00 00 
  8025a0:	be 5b 00 00 00       	mov    $0x5b,%esi
  8025a5:	48 bf 45 53 80 00 00 	movabs $0x805345,%rdi
  8025ac:	00 00 00 
  8025af:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b4:	48 b9 e4 08 80 00 00 	movabs $0x8008e4,%rcx
  8025bb:	00 00 00 
  8025be:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  8025c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025c5:	c9                   	leaveq 
  8025c6:	c3                   	retq   

00000000008025c7 <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  8025c7:	55                   	push   %rbp
  8025c8:	48 89 e5             	mov    %rsp,%rbp
  8025cb:	48 83 ec 18          	sub    $0x18,%rsp
  8025cf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  8025d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025d7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  8025db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025df:	48 c1 e8 27          	shr    $0x27,%rax
  8025e3:	48 89 c2             	mov    %rax,%rdx
  8025e6:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8025ed:	01 00 00 
  8025f0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025f4:	83 e0 01             	and    $0x1,%eax
  8025f7:	48 85 c0             	test   %rax,%rax
  8025fa:	74 51                	je     80264d <pt_is_mapped+0x86>
  8025fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802600:	48 c1 e0 0c          	shl    $0xc,%rax
  802604:	48 c1 e8 1e          	shr    $0x1e,%rax
  802608:	48 89 c2             	mov    %rax,%rdx
  80260b:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802612:	01 00 00 
  802615:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802619:	83 e0 01             	and    $0x1,%eax
  80261c:	48 85 c0             	test   %rax,%rax
  80261f:	74 2c                	je     80264d <pt_is_mapped+0x86>
  802621:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802625:	48 c1 e0 0c          	shl    $0xc,%rax
  802629:	48 c1 e8 15          	shr    $0x15,%rax
  80262d:	48 89 c2             	mov    %rax,%rdx
  802630:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802637:	01 00 00 
  80263a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80263e:	83 e0 01             	and    $0x1,%eax
  802641:	48 85 c0             	test   %rax,%rax
  802644:	74 07                	je     80264d <pt_is_mapped+0x86>
  802646:	b8 01 00 00 00       	mov    $0x1,%eax
  80264b:	eb 05                	jmp    802652 <pt_is_mapped+0x8b>
  80264d:	b8 00 00 00 00       	mov    $0x0,%eax
  802652:	83 e0 01             	and    $0x1,%eax
}
  802655:	c9                   	leaveq 
  802656:	c3                   	retq   

0000000000802657 <fork>:

envid_t
fork(void)
{
  802657:	55                   	push   %rbp
  802658:	48 89 e5             	mov    %rsp,%rbp
  80265b:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  80265f:	48 bf 6e 22 80 00 00 	movabs $0x80226e,%rdi
  802666:	00 00 00 
  802669:	48 b8 eb 48 80 00 00 	movabs $0x8048eb,%rax
  802670:	00 00 00 
  802673:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802675:	b8 07 00 00 00       	mov    $0x7,%eax
  80267a:	cd 30                	int    $0x30
  80267c:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  80267f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  802682:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  802685:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802689:	79 30                	jns    8026bb <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  80268b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80268e:	89 c1                	mov    %eax,%ecx
  802690:	48 ba e8 53 80 00 00 	movabs $0x8053e8,%rdx
  802697:	00 00 00 
  80269a:	be 86 00 00 00       	mov    $0x86,%esi
  80269f:	48 bf 45 53 80 00 00 	movabs $0x805345,%rdi
  8026a6:	00 00 00 
  8026a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ae:	49 b8 e4 08 80 00 00 	movabs $0x8008e4,%r8
  8026b5:	00 00 00 
  8026b8:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  8026bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8026bf:	75 46                	jne    802707 <fork+0xb0>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  8026c1:	48 b8 85 1f 80 00 00 	movabs $0x801f85,%rax
  8026c8:	00 00 00 
  8026cb:	ff d0                	callq  *%rax
  8026cd:	25 ff 03 00 00       	and    $0x3ff,%eax
  8026d2:	48 63 d0             	movslq %eax,%rdx
  8026d5:	48 89 d0             	mov    %rdx,%rax
  8026d8:	48 c1 e0 03          	shl    $0x3,%rax
  8026dc:	48 01 d0             	add    %rdx,%rax
  8026df:	48 c1 e0 05          	shl    $0x5,%rax
  8026e3:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8026ea:	00 00 00 
  8026ed:	48 01 c2             	add    %rax,%rdx
  8026f0:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8026f7:	00 00 00 
  8026fa:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8026fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802702:	e9 d1 01 00 00       	jmpq   8028d8 <fork+0x281>
	}
	uint64_t ad = 0;
  802707:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80270e:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  80270f:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  802714:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802718:	e9 df 00 00 00       	jmpq   8027fc <fork+0x1a5>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  80271d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802721:	48 c1 e8 27          	shr    $0x27,%rax
  802725:	48 89 c2             	mov    %rax,%rdx
  802728:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80272f:	01 00 00 
  802732:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802736:	83 e0 01             	and    $0x1,%eax
  802739:	48 85 c0             	test   %rax,%rax
  80273c:	0f 84 9e 00 00 00    	je     8027e0 <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  802742:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802746:	48 c1 e8 1e          	shr    $0x1e,%rax
  80274a:	48 89 c2             	mov    %rax,%rdx
  80274d:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802754:	01 00 00 
  802757:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80275b:	83 e0 01             	and    $0x1,%eax
  80275e:	48 85 c0             	test   %rax,%rax
  802761:	74 73                	je     8027d6 <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  802763:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802767:	48 c1 e8 15          	shr    $0x15,%rax
  80276b:	48 89 c2             	mov    %rax,%rdx
  80276e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802775:	01 00 00 
  802778:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80277c:	83 e0 01             	and    $0x1,%eax
  80277f:	48 85 c0             	test   %rax,%rax
  802782:	74 48                	je     8027cc <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  802784:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802788:	48 c1 e8 0c          	shr    $0xc,%rax
  80278c:	48 89 c2             	mov    %rax,%rdx
  80278f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802796:	01 00 00 
  802799:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80279d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8027a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027a5:	83 e0 01             	and    $0x1,%eax
  8027a8:	48 85 c0             	test   %rax,%rax
  8027ab:	74 47                	je     8027f4 <fork+0x19d>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  8027ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027b1:	48 c1 e8 0c          	shr    $0xc,%rax
  8027b5:	89 c2                	mov    %eax,%edx
  8027b7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8027ba:	89 d6                	mov    %edx,%esi
  8027bc:	89 c7                	mov    %eax,%edi
  8027be:	48 b8 03 24 80 00 00 	movabs $0x802403,%rax
  8027c5:	00 00 00 
  8027c8:	ff d0                	callq  *%rax
  8027ca:	eb 28                	jmp    8027f4 <fork+0x19d>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  8027cc:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  8027d3:	00 
  8027d4:	eb 1e                	jmp    8027f4 <fork+0x19d>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  8027d6:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  8027dd:	40 
  8027de:	eb 14                	jmp    8027f4 <fork+0x19d>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  8027e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027e4:	48 c1 e8 27          	shr    $0x27,%rax
  8027e8:	48 83 c0 01          	add    $0x1,%rax
  8027ec:	48 c1 e0 27          	shl    $0x27,%rax
  8027f0:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8027f4:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  8027fb:	00 
  8027fc:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  802803:	00 
  802804:	0f 87 13 ff ff ff    	ja     80271d <fork+0xc6>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  80280a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80280d:	ba 07 00 00 00       	mov    $0x7,%edx
  802812:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802817:	89 c7                	mov    %eax,%edi
  802819:	48 b8 01 20 80 00 00 	movabs $0x802001,%rax
  802820:	00 00 00 
  802823:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  802825:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802828:	ba 07 00 00 00       	mov    $0x7,%edx
  80282d:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802832:	89 c7                	mov    %eax,%edi
  802834:	48 b8 01 20 80 00 00 	movabs $0x802001,%rax
  80283b:	00 00 00 
  80283e:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  802840:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802843:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802849:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  80284e:	ba 00 00 00 00       	mov    $0x0,%edx
  802853:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802858:	89 c7                	mov    %eax,%edi
  80285a:	48 b8 51 20 80 00 00 	movabs $0x802051,%rax
  802861:	00 00 00 
  802864:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  802866:	ba 00 10 00 00       	mov    $0x1000,%edx
  80286b:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802870:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802875:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  80287c:	00 00 00 
  80287f:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  802881:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802886:	bf 00 00 00 00       	mov    $0x0,%edi
  80288b:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  802892:	00 00 00 
  802895:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  802897:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80289e:	00 00 00 
  8028a1:	48 8b 00             	mov    (%rax),%rax
  8028a4:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  8028ab:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8028ae:	48 89 d6             	mov    %rdx,%rsi
  8028b1:	89 c7                	mov    %eax,%edi
  8028b3:	48 b8 8b 21 80 00 00 	movabs $0x80218b,%rax
  8028ba:	00 00 00 
  8028bd:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  8028bf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8028c2:	be 02 00 00 00       	mov    $0x2,%esi
  8028c7:	89 c7                	mov    %eax,%edi
  8028c9:	48 b8 f6 20 80 00 00 	movabs $0x8020f6,%rax
  8028d0:	00 00 00 
  8028d3:	ff d0                	callq  *%rax

	return envid;
  8028d5:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  8028d8:	c9                   	leaveq 
  8028d9:	c3                   	retq   

00000000008028da <sfork>:

	
// Challenge!
int
sfork(void)
{
  8028da:	55                   	push   %rbp
  8028db:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8028de:	48 ba 00 54 80 00 00 	movabs $0x805400,%rdx
  8028e5:	00 00 00 
  8028e8:	be bf 00 00 00       	mov    $0xbf,%esi
  8028ed:	48 bf 45 53 80 00 00 	movabs $0x805345,%rdi
  8028f4:	00 00 00 
  8028f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8028fc:	48 b9 e4 08 80 00 00 	movabs $0x8008e4,%rcx
  802903:	00 00 00 
  802906:	ff d1                	callq  *%rcx

0000000000802908 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802908:	55                   	push   %rbp
  802909:	48 89 e5             	mov    %rsp,%rbp
  80290c:	48 83 ec 08          	sub    $0x8,%rsp
  802910:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802914:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802918:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80291f:	ff ff ff 
  802922:	48 01 d0             	add    %rdx,%rax
  802925:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802929:	c9                   	leaveq 
  80292a:	c3                   	retq   

000000000080292b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80292b:	55                   	push   %rbp
  80292c:	48 89 e5             	mov    %rsp,%rbp
  80292f:	48 83 ec 08          	sub    $0x8,%rsp
  802933:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802937:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80293b:	48 89 c7             	mov    %rax,%rdi
  80293e:	48 b8 08 29 80 00 00 	movabs $0x802908,%rax
  802945:	00 00 00 
  802948:	ff d0                	callq  *%rax
  80294a:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802950:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802954:	c9                   	leaveq 
  802955:	c3                   	retq   

0000000000802956 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802956:	55                   	push   %rbp
  802957:	48 89 e5             	mov    %rsp,%rbp
  80295a:	48 83 ec 18          	sub    $0x18,%rsp
  80295e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802962:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802969:	eb 6b                	jmp    8029d6 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80296b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80296e:	48 98                	cltq   
  802970:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802976:	48 c1 e0 0c          	shl    $0xc,%rax
  80297a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80297e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802982:	48 c1 e8 15          	shr    $0x15,%rax
  802986:	48 89 c2             	mov    %rax,%rdx
  802989:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802990:	01 00 00 
  802993:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802997:	83 e0 01             	and    $0x1,%eax
  80299a:	48 85 c0             	test   %rax,%rax
  80299d:	74 21                	je     8029c0 <fd_alloc+0x6a>
  80299f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029a3:	48 c1 e8 0c          	shr    $0xc,%rax
  8029a7:	48 89 c2             	mov    %rax,%rdx
  8029aa:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8029b1:	01 00 00 
  8029b4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029b8:	83 e0 01             	and    $0x1,%eax
  8029bb:	48 85 c0             	test   %rax,%rax
  8029be:	75 12                	jne    8029d2 <fd_alloc+0x7c>
			*fd_store = fd;
  8029c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029c4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8029c8:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8029cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8029d0:	eb 1a                	jmp    8029ec <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8029d2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8029d6:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8029da:	7e 8f                	jle    80296b <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8029dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029e0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8029e7:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8029ec:	c9                   	leaveq 
  8029ed:	c3                   	retq   

00000000008029ee <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8029ee:	55                   	push   %rbp
  8029ef:	48 89 e5             	mov    %rsp,%rbp
  8029f2:	48 83 ec 20          	sub    $0x20,%rsp
  8029f6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8029f9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8029fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802a01:	78 06                	js     802a09 <fd_lookup+0x1b>
  802a03:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802a07:	7e 07                	jle    802a10 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802a09:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a0e:	eb 6c                	jmp    802a7c <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802a10:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a13:	48 98                	cltq   
  802a15:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802a1b:	48 c1 e0 0c          	shl    $0xc,%rax
  802a1f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802a23:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a27:	48 c1 e8 15          	shr    $0x15,%rax
  802a2b:	48 89 c2             	mov    %rax,%rdx
  802a2e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802a35:	01 00 00 
  802a38:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a3c:	83 e0 01             	and    $0x1,%eax
  802a3f:	48 85 c0             	test   %rax,%rax
  802a42:	74 21                	je     802a65 <fd_lookup+0x77>
  802a44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a48:	48 c1 e8 0c          	shr    $0xc,%rax
  802a4c:	48 89 c2             	mov    %rax,%rdx
  802a4f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a56:	01 00 00 
  802a59:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a5d:	83 e0 01             	and    $0x1,%eax
  802a60:	48 85 c0             	test   %rax,%rax
  802a63:	75 07                	jne    802a6c <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802a65:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a6a:	eb 10                	jmp    802a7c <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802a6c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a70:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802a74:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802a77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a7c:	c9                   	leaveq 
  802a7d:	c3                   	retq   

0000000000802a7e <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802a7e:	55                   	push   %rbp
  802a7f:	48 89 e5             	mov    %rsp,%rbp
  802a82:	48 83 ec 30          	sub    $0x30,%rsp
  802a86:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802a8a:	89 f0                	mov    %esi,%eax
  802a8c:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802a8f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a93:	48 89 c7             	mov    %rax,%rdi
  802a96:	48 b8 08 29 80 00 00 	movabs $0x802908,%rax
  802a9d:	00 00 00 
  802aa0:	ff d0                	callq  *%rax
  802aa2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802aa6:	48 89 d6             	mov    %rdx,%rsi
  802aa9:	89 c7                	mov    %eax,%edi
  802aab:	48 b8 ee 29 80 00 00 	movabs $0x8029ee,%rax
  802ab2:	00 00 00 
  802ab5:	ff d0                	callq  *%rax
  802ab7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802abe:	78 0a                	js     802aca <fd_close+0x4c>
	    || fd != fd2)
  802ac0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ac4:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802ac8:	74 12                	je     802adc <fd_close+0x5e>
		return (must_exist ? r : 0);
  802aca:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802ace:	74 05                	je     802ad5 <fd_close+0x57>
  802ad0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ad3:	eb 05                	jmp    802ada <fd_close+0x5c>
  802ad5:	b8 00 00 00 00       	mov    $0x0,%eax
  802ada:	eb 69                	jmp    802b45 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802adc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ae0:	8b 00                	mov    (%rax),%eax
  802ae2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ae6:	48 89 d6             	mov    %rdx,%rsi
  802ae9:	89 c7                	mov    %eax,%edi
  802aeb:	48 b8 47 2b 80 00 00 	movabs $0x802b47,%rax
  802af2:	00 00 00 
  802af5:	ff d0                	callq  *%rax
  802af7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802afa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802afe:	78 2a                	js     802b2a <fd_close+0xac>
		if (dev->dev_close)
  802b00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b04:	48 8b 40 20          	mov    0x20(%rax),%rax
  802b08:	48 85 c0             	test   %rax,%rax
  802b0b:	74 16                	je     802b23 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802b0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b11:	48 8b 40 20          	mov    0x20(%rax),%rax
  802b15:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802b19:	48 89 d7             	mov    %rdx,%rdi
  802b1c:	ff d0                	callq  *%rax
  802b1e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b21:	eb 07                	jmp    802b2a <fd_close+0xac>
		else
			r = 0;
  802b23:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802b2a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b2e:	48 89 c6             	mov    %rax,%rsi
  802b31:	bf 00 00 00 00       	mov    $0x0,%edi
  802b36:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  802b3d:	00 00 00 
  802b40:	ff d0                	callq  *%rax
	return r;
  802b42:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802b45:	c9                   	leaveq 
  802b46:	c3                   	retq   

0000000000802b47 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802b47:	55                   	push   %rbp
  802b48:	48 89 e5             	mov    %rsp,%rbp
  802b4b:	48 83 ec 20          	sub    $0x20,%rsp
  802b4f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b52:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802b56:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802b5d:	eb 41                	jmp    802ba0 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802b5f:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  802b66:	00 00 00 
  802b69:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802b6c:	48 63 d2             	movslq %edx,%rdx
  802b6f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b73:	8b 00                	mov    (%rax),%eax
  802b75:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802b78:	75 22                	jne    802b9c <dev_lookup+0x55>
			*dev = devtab[i];
  802b7a:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  802b81:	00 00 00 
  802b84:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802b87:	48 63 d2             	movslq %edx,%rdx
  802b8a:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802b8e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b92:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802b95:	b8 00 00 00 00       	mov    $0x0,%eax
  802b9a:	eb 60                	jmp    802bfc <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802b9c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802ba0:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  802ba7:	00 00 00 
  802baa:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802bad:	48 63 d2             	movslq %edx,%rdx
  802bb0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802bb4:	48 85 c0             	test   %rax,%rax
  802bb7:	75 a6                	jne    802b5f <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802bb9:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802bc0:	00 00 00 
  802bc3:	48 8b 00             	mov    (%rax),%rax
  802bc6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802bcc:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802bcf:	89 c6                	mov    %eax,%esi
  802bd1:	48 bf 18 54 80 00 00 	movabs $0x805418,%rdi
  802bd8:	00 00 00 
  802bdb:	b8 00 00 00 00       	mov    $0x0,%eax
  802be0:	48 b9 1d 0b 80 00 00 	movabs $0x800b1d,%rcx
  802be7:	00 00 00 
  802bea:	ff d1                	callq  *%rcx
	*dev = 0;
  802bec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bf0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802bf7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802bfc:	c9                   	leaveq 
  802bfd:	c3                   	retq   

0000000000802bfe <close>:

int
close(int fdnum)
{
  802bfe:	55                   	push   %rbp
  802bff:	48 89 e5             	mov    %rsp,%rbp
  802c02:	48 83 ec 20          	sub    $0x20,%rsp
  802c06:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802c09:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c0d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c10:	48 89 d6             	mov    %rdx,%rsi
  802c13:	89 c7                	mov    %eax,%edi
  802c15:	48 b8 ee 29 80 00 00 	movabs $0x8029ee,%rax
  802c1c:	00 00 00 
  802c1f:	ff d0                	callq  *%rax
  802c21:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c24:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c28:	79 05                	jns    802c2f <close+0x31>
		return r;
  802c2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c2d:	eb 18                	jmp    802c47 <close+0x49>
	else
		return fd_close(fd, 1);
  802c2f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c33:	be 01 00 00 00       	mov    $0x1,%esi
  802c38:	48 89 c7             	mov    %rax,%rdi
  802c3b:	48 b8 7e 2a 80 00 00 	movabs $0x802a7e,%rax
  802c42:	00 00 00 
  802c45:	ff d0                	callq  *%rax
}
  802c47:	c9                   	leaveq 
  802c48:	c3                   	retq   

0000000000802c49 <close_all>:

void
close_all(void)
{
  802c49:	55                   	push   %rbp
  802c4a:	48 89 e5             	mov    %rsp,%rbp
  802c4d:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802c51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802c58:	eb 15                	jmp    802c6f <close_all+0x26>
		close(i);
  802c5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c5d:	89 c7                	mov    %eax,%edi
  802c5f:	48 b8 fe 2b 80 00 00 	movabs $0x802bfe,%rax
  802c66:	00 00 00 
  802c69:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802c6b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802c6f:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802c73:	7e e5                	jle    802c5a <close_all+0x11>
		close(i);
}
  802c75:	c9                   	leaveq 
  802c76:	c3                   	retq   

0000000000802c77 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802c77:	55                   	push   %rbp
  802c78:	48 89 e5             	mov    %rsp,%rbp
  802c7b:	48 83 ec 40          	sub    $0x40,%rsp
  802c7f:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802c82:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802c85:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802c89:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802c8c:	48 89 d6             	mov    %rdx,%rsi
  802c8f:	89 c7                	mov    %eax,%edi
  802c91:	48 b8 ee 29 80 00 00 	movabs $0x8029ee,%rax
  802c98:	00 00 00 
  802c9b:	ff d0                	callq  *%rax
  802c9d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ca0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ca4:	79 08                	jns    802cae <dup+0x37>
		return r;
  802ca6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ca9:	e9 70 01 00 00       	jmpq   802e1e <dup+0x1a7>
	close(newfdnum);
  802cae:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802cb1:	89 c7                	mov    %eax,%edi
  802cb3:	48 b8 fe 2b 80 00 00 	movabs $0x802bfe,%rax
  802cba:	00 00 00 
  802cbd:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802cbf:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802cc2:	48 98                	cltq   
  802cc4:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802cca:	48 c1 e0 0c          	shl    $0xc,%rax
  802cce:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802cd2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802cd6:	48 89 c7             	mov    %rax,%rdi
  802cd9:	48 b8 2b 29 80 00 00 	movabs $0x80292b,%rax
  802ce0:	00 00 00 
  802ce3:	ff d0                	callq  *%rax
  802ce5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802ce9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ced:	48 89 c7             	mov    %rax,%rdi
  802cf0:	48 b8 2b 29 80 00 00 	movabs $0x80292b,%rax
  802cf7:	00 00 00 
  802cfa:	ff d0                	callq  *%rax
  802cfc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802d00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d04:	48 c1 e8 15          	shr    $0x15,%rax
  802d08:	48 89 c2             	mov    %rax,%rdx
  802d0b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802d12:	01 00 00 
  802d15:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d19:	83 e0 01             	and    $0x1,%eax
  802d1c:	48 85 c0             	test   %rax,%rax
  802d1f:	74 73                	je     802d94 <dup+0x11d>
  802d21:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d25:	48 c1 e8 0c          	shr    $0xc,%rax
  802d29:	48 89 c2             	mov    %rax,%rdx
  802d2c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802d33:	01 00 00 
  802d36:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d3a:	83 e0 01             	and    $0x1,%eax
  802d3d:	48 85 c0             	test   %rax,%rax
  802d40:	74 52                	je     802d94 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802d42:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d46:	48 c1 e8 0c          	shr    $0xc,%rax
  802d4a:	48 89 c2             	mov    %rax,%rdx
  802d4d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802d54:	01 00 00 
  802d57:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d5b:	25 07 0e 00 00       	and    $0xe07,%eax
  802d60:	89 c1                	mov    %eax,%ecx
  802d62:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802d66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d6a:	41 89 c8             	mov    %ecx,%r8d
  802d6d:	48 89 d1             	mov    %rdx,%rcx
  802d70:	ba 00 00 00 00       	mov    $0x0,%edx
  802d75:	48 89 c6             	mov    %rax,%rsi
  802d78:	bf 00 00 00 00       	mov    $0x0,%edi
  802d7d:	48 b8 51 20 80 00 00 	movabs $0x802051,%rax
  802d84:	00 00 00 
  802d87:	ff d0                	callq  *%rax
  802d89:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d8c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d90:	79 02                	jns    802d94 <dup+0x11d>
			goto err;
  802d92:	eb 57                	jmp    802deb <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802d94:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d98:	48 c1 e8 0c          	shr    $0xc,%rax
  802d9c:	48 89 c2             	mov    %rax,%rdx
  802d9f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802da6:	01 00 00 
  802da9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802dad:	25 07 0e 00 00       	and    $0xe07,%eax
  802db2:	89 c1                	mov    %eax,%ecx
  802db4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802db8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802dbc:	41 89 c8             	mov    %ecx,%r8d
  802dbf:	48 89 d1             	mov    %rdx,%rcx
  802dc2:	ba 00 00 00 00       	mov    $0x0,%edx
  802dc7:	48 89 c6             	mov    %rax,%rsi
  802dca:	bf 00 00 00 00       	mov    $0x0,%edi
  802dcf:	48 b8 51 20 80 00 00 	movabs $0x802051,%rax
  802dd6:	00 00 00 
  802dd9:	ff d0                	callq  *%rax
  802ddb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dde:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802de2:	79 02                	jns    802de6 <dup+0x16f>
		goto err;
  802de4:	eb 05                	jmp    802deb <dup+0x174>

	return newfdnum;
  802de6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802de9:	eb 33                	jmp    802e1e <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802deb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802def:	48 89 c6             	mov    %rax,%rsi
  802df2:	bf 00 00 00 00       	mov    $0x0,%edi
  802df7:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  802dfe:	00 00 00 
  802e01:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802e03:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e07:	48 89 c6             	mov    %rax,%rsi
  802e0a:	bf 00 00 00 00       	mov    $0x0,%edi
  802e0f:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  802e16:	00 00 00 
  802e19:	ff d0                	callq  *%rax
	return r;
  802e1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802e1e:	c9                   	leaveq 
  802e1f:	c3                   	retq   

0000000000802e20 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802e20:	55                   	push   %rbp
  802e21:	48 89 e5             	mov    %rsp,%rbp
  802e24:	48 83 ec 40          	sub    $0x40,%rsp
  802e28:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e2b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802e2f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e33:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e37:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e3a:	48 89 d6             	mov    %rdx,%rsi
  802e3d:	89 c7                	mov    %eax,%edi
  802e3f:	48 b8 ee 29 80 00 00 	movabs $0x8029ee,%rax
  802e46:	00 00 00 
  802e49:	ff d0                	callq  *%rax
  802e4b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e4e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e52:	78 24                	js     802e78 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e58:	8b 00                	mov    (%rax),%eax
  802e5a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e5e:	48 89 d6             	mov    %rdx,%rsi
  802e61:	89 c7                	mov    %eax,%edi
  802e63:	48 b8 47 2b 80 00 00 	movabs $0x802b47,%rax
  802e6a:	00 00 00 
  802e6d:	ff d0                	callq  *%rax
  802e6f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e72:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e76:	79 05                	jns    802e7d <read+0x5d>
		return r;
  802e78:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e7b:	eb 76                	jmp    802ef3 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802e7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e81:	8b 40 08             	mov    0x8(%rax),%eax
  802e84:	83 e0 03             	and    $0x3,%eax
  802e87:	83 f8 01             	cmp    $0x1,%eax
  802e8a:	75 3a                	jne    802ec6 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802e8c:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802e93:	00 00 00 
  802e96:	48 8b 00             	mov    (%rax),%rax
  802e99:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802e9f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802ea2:	89 c6                	mov    %eax,%esi
  802ea4:	48 bf 37 54 80 00 00 	movabs $0x805437,%rdi
  802eab:	00 00 00 
  802eae:	b8 00 00 00 00       	mov    $0x0,%eax
  802eb3:	48 b9 1d 0b 80 00 00 	movabs $0x800b1d,%rcx
  802eba:	00 00 00 
  802ebd:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802ebf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ec4:	eb 2d                	jmp    802ef3 <read+0xd3>
	}
	if (!dev->dev_read)
  802ec6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eca:	48 8b 40 10          	mov    0x10(%rax),%rax
  802ece:	48 85 c0             	test   %rax,%rax
  802ed1:	75 07                	jne    802eda <read+0xba>
		return -E_NOT_SUPP;
  802ed3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ed8:	eb 19                	jmp    802ef3 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802eda:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ede:	48 8b 40 10          	mov    0x10(%rax),%rax
  802ee2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802ee6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802eea:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802eee:	48 89 cf             	mov    %rcx,%rdi
  802ef1:	ff d0                	callq  *%rax
}
  802ef3:	c9                   	leaveq 
  802ef4:	c3                   	retq   

0000000000802ef5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802ef5:	55                   	push   %rbp
  802ef6:	48 89 e5             	mov    %rsp,%rbp
  802ef9:	48 83 ec 30          	sub    $0x30,%rsp
  802efd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f00:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f04:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802f08:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802f0f:	eb 49                	jmp    802f5a <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802f11:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f14:	48 98                	cltq   
  802f16:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f1a:	48 29 c2             	sub    %rax,%rdx
  802f1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f20:	48 63 c8             	movslq %eax,%rcx
  802f23:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f27:	48 01 c1             	add    %rax,%rcx
  802f2a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f2d:	48 89 ce             	mov    %rcx,%rsi
  802f30:	89 c7                	mov    %eax,%edi
  802f32:	48 b8 20 2e 80 00 00 	movabs $0x802e20,%rax
  802f39:	00 00 00 
  802f3c:	ff d0                	callq  *%rax
  802f3e:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802f41:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802f45:	79 05                	jns    802f4c <readn+0x57>
			return m;
  802f47:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f4a:	eb 1c                	jmp    802f68 <readn+0x73>
		if (m == 0)
  802f4c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802f50:	75 02                	jne    802f54 <readn+0x5f>
			break;
  802f52:	eb 11                	jmp    802f65 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802f54:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f57:	01 45 fc             	add    %eax,-0x4(%rbp)
  802f5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f5d:	48 98                	cltq   
  802f5f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802f63:	72 ac                	jb     802f11 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802f65:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802f68:	c9                   	leaveq 
  802f69:	c3                   	retq   

0000000000802f6a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802f6a:	55                   	push   %rbp
  802f6b:	48 89 e5             	mov    %rsp,%rbp
  802f6e:	48 83 ec 40          	sub    $0x40,%rsp
  802f72:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802f75:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802f79:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f7d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802f81:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f84:	48 89 d6             	mov    %rdx,%rsi
  802f87:	89 c7                	mov    %eax,%edi
  802f89:	48 b8 ee 29 80 00 00 	movabs $0x8029ee,%rax
  802f90:	00 00 00 
  802f93:	ff d0                	callq  *%rax
  802f95:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f98:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f9c:	78 24                	js     802fc2 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fa2:	8b 00                	mov    (%rax),%eax
  802fa4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802fa8:	48 89 d6             	mov    %rdx,%rsi
  802fab:	89 c7                	mov    %eax,%edi
  802fad:	48 b8 47 2b 80 00 00 	movabs $0x802b47,%rax
  802fb4:	00 00 00 
  802fb7:	ff d0                	callq  *%rax
  802fb9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fbc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fc0:	79 05                	jns    802fc7 <write+0x5d>
		return r;
  802fc2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fc5:	eb 75                	jmp    80303c <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802fc7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fcb:	8b 40 08             	mov    0x8(%rax),%eax
  802fce:	83 e0 03             	and    $0x3,%eax
  802fd1:	85 c0                	test   %eax,%eax
  802fd3:	75 3a                	jne    80300f <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802fd5:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802fdc:	00 00 00 
  802fdf:	48 8b 00             	mov    (%rax),%rax
  802fe2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802fe8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802feb:	89 c6                	mov    %eax,%esi
  802fed:	48 bf 53 54 80 00 00 	movabs $0x805453,%rdi
  802ff4:	00 00 00 
  802ff7:	b8 00 00 00 00       	mov    $0x0,%eax
  802ffc:	48 b9 1d 0b 80 00 00 	movabs $0x800b1d,%rcx
  803003:	00 00 00 
  803006:	ff d1                	callq  *%rcx
		return -E_INVAL;
  803008:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80300d:	eb 2d                	jmp    80303c <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80300f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803013:	48 8b 40 18          	mov    0x18(%rax),%rax
  803017:	48 85 c0             	test   %rax,%rax
  80301a:	75 07                	jne    803023 <write+0xb9>
		return -E_NOT_SUPP;
  80301c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803021:	eb 19                	jmp    80303c <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  803023:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803027:	48 8b 40 18          	mov    0x18(%rax),%rax
  80302b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80302f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803033:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803037:	48 89 cf             	mov    %rcx,%rdi
  80303a:	ff d0                	callq  *%rax
}
  80303c:	c9                   	leaveq 
  80303d:	c3                   	retq   

000000000080303e <seek>:

int
seek(int fdnum, off_t offset)
{
  80303e:	55                   	push   %rbp
  80303f:	48 89 e5             	mov    %rsp,%rbp
  803042:	48 83 ec 18          	sub    $0x18,%rsp
  803046:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803049:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80304c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803050:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803053:	48 89 d6             	mov    %rdx,%rsi
  803056:	89 c7                	mov    %eax,%edi
  803058:	48 b8 ee 29 80 00 00 	movabs $0x8029ee,%rax
  80305f:	00 00 00 
  803062:	ff d0                	callq  *%rax
  803064:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803067:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80306b:	79 05                	jns    803072 <seek+0x34>
		return r;
  80306d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803070:	eb 0f                	jmp    803081 <seek+0x43>
	fd->fd_offset = offset;
  803072:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803076:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803079:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80307c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803081:	c9                   	leaveq 
  803082:	c3                   	retq   

0000000000803083 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  803083:	55                   	push   %rbp
  803084:	48 89 e5             	mov    %rsp,%rbp
  803087:	48 83 ec 30          	sub    $0x30,%rsp
  80308b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80308e:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  803091:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803095:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803098:	48 89 d6             	mov    %rdx,%rsi
  80309b:	89 c7                	mov    %eax,%edi
  80309d:	48 b8 ee 29 80 00 00 	movabs $0x8029ee,%rax
  8030a4:	00 00 00 
  8030a7:	ff d0                	callq  *%rax
  8030a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030b0:	78 24                	js     8030d6 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8030b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030b6:	8b 00                	mov    (%rax),%eax
  8030b8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8030bc:	48 89 d6             	mov    %rdx,%rsi
  8030bf:	89 c7                	mov    %eax,%edi
  8030c1:	48 b8 47 2b 80 00 00 	movabs $0x802b47,%rax
  8030c8:	00 00 00 
  8030cb:	ff d0                	callq  *%rax
  8030cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030d4:	79 05                	jns    8030db <ftruncate+0x58>
		return r;
  8030d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030d9:	eb 72                	jmp    80314d <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8030db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030df:	8b 40 08             	mov    0x8(%rax),%eax
  8030e2:	83 e0 03             	and    $0x3,%eax
  8030e5:	85 c0                	test   %eax,%eax
  8030e7:	75 3a                	jne    803123 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8030e9:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8030f0:	00 00 00 
  8030f3:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8030f6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8030fc:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8030ff:	89 c6                	mov    %eax,%esi
  803101:	48 bf 70 54 80 00 00 	movabs $0x805470,%rdi
  803108:	00 00 00 
  80310b:	b8 00 00 00 00       	mov    $0x0,%eax
  803110:	48 b9 1d 0b 80 00 00 	movabs $0x800b1d,%rcx
  803117:	00 00 00 
  80311a:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80311c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803121:	eb 2a                	jmp    80314d <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  803123:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803127:	48 8b 40 30          	mov    0x30(%rax),%rax
  80312b:	48 85 c0             	test   %rax,%rax
  80312e:	75 07                	jne    803137 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  803130:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803135:	eb 16                	jmp    80314d <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  803137:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80313b:	48 8b 40 30          	mov    0x30(%rax),%rax
  80313f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803143:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  803146:	89 ce                	mov    %ecx,%esi
  803148:	48 89 d7             	mov    %rdx,%rdi
  80314b:	ff d0                	callq  *%rax
}
  80314d:	c9                   	leaveq 
  80314e:	c3                   	retq   

000000000080314f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80314f:	55                   	push   %rbp
  803150:	48 89 e5             	mov    %rsp,%rbp
  803153:	48 83 ec 30          	sub    $0x30,%rsp
  803157:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80315a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80315e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803162:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803165:	48 89 d6             	mov    %rdx,%rsi
  803168:	89 c7                	mov    %eax,%edi
  80316a:	48 b8 ee 29 80 00 00 	movabs $0x8029ee,%rax
  803171:	00 00 00 
  803174:	ff d0                	callq  *%rax
  803176:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803179:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80317d:	78 24                	js     8031a3 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80317f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803183:	8b 00                	mov    (%rax),%eax
  803185:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803189:	48 89 d6             	mov    %rdx,%rsi
  80318c:	89 c7                	mov    %eax,%edi
  80318e:	48 b8 47 2b 80 00 00 	movabs $0x802b47,%rax
  803195:	00 00 00 
  803198:	ff d0                	callq  *%rax
  80319a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80319d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031a1:	79 05                	jns    8031a8 <fstat+0x59>
		return r;
  8031a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031a6:	eb 5e                	jmp    803206 <fstat+0xb7>
	if (!dev->dev_stat)
  8031a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031ac:	48 8b 40 28          	mov    0x28(%rax),%rax
  8031b0:	48 85 c0             	test   %rax,%rax
  8031b3:	75 07                	jne    8031bc <fstat+0x6d>
		return -E_NOT_SUPP;
  8031b5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8031ba:	eb 4a                	jmp    803206 <fstat+0xb7>
	stat->st_name[0] = 0;
  8031bc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031c0:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8031c3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031c7:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8031ce:	00 00 00 
	stat->st_isdir = 0;
  8031d1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031d5:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8031dc:	00 00 00 
	stat->st_dev = dev;
  8031df:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8031e3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031e7:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8031ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031f2:	48 8b 40 28          	mov    0x28(%rax),%rax
  8031f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8031fa:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8031fe:	48 89 ce             	mov    %rcx,%rsi
  803201:	48 89 d7             	mov    %rdx,%rdi
  803204:	ff d0                	callq  *%rax
}
  803206:	c9                   	leaveq 
  803207:	c3                   	retq   

0000000000803208 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  803208:	55                   	push   %rbp
  803209:	48 89 e5             	mov    %rsp,%rbp
  80320c:	48 83 ec 20          	sub    $0x20,%rsp
  803210:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803214:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  803218:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80321c:	be 00 00 00 00       	mov    $0x0,%esi
  803221:	48 89 c7             	mov    %rax,%rdi
  803224:	48 b8 f6 32 80 00 00 	movabs $0x8032f6,%rax
  80322b:	00 00 00 
  80322e:	ff d0                	callq  *%rax
  803230:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803233:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803237:	79 05                	jns    80323e <stat+0x36>
		return fd;
  803239:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80323c:	eb 2f                	jmp    80326d <stat+0x65>
	r = fstat(fd, stat);
  80323e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803242:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803245:	48 89 d6             	mov    %rdx,%rsi
  803248:	89 c7                	mov    %eax,%edi
  80324a:	48 b8 4f 31 80 00 00 	movabs $0x80314f,%rax
  803251:	00 00 00 
  803254:	ff d0                	callq  *%rax
  803256:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  803259:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80325c:	89 c7                	mov    %eax,%edi
  80325e:	48 b8 fe 2b 80 00 00 	movabs $0x802bfe,%rax
  803265:	00 00 00 
  803268:	ff d0                	callq  *%rax
	return r;
  80326a:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80326d:	c9                   	leaveq 
  80326e:	c3                   	retq   

000000000080326f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80326f:	55                   	push   %rbp
  803270:	48 89 e5             	mov    %rsp,%rbp
  803273:	48 83 ec 10          	sub    $0x10,%rsp
  803277:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80327a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80327e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803285:	00 00 00 
  803288:	8b 00                	mov    (%rax),%eax
  80328a:	85 c0                	test   %eax,%eax
  80328c:	75 1d                	jne    8032ab <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80328e:	bf 01 00 00 00       	mov    $0x1,%edi
  803293:	48 b8 93 4b 80 00 00 	movabs $0x804b93,%rax
  80329a:	00 00 00 
  80329d:	ff d0                	callq  *%rax
  80329f:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8032a6:	00 00 00 
  8032a9:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8032ab:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8032b2:	00 00 00 
  8032b5:	8b 00                	mov    (%rax),%eax
  8032b7:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8032ba:	b9 07 00 00 00       	mov    $0x7,%ecx
  8032bf:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  8032c6:	00 00 00 
  8032c9:	89 c7                	mov    %eax,%edi
  8032cb:	48 b8 31 4b 80 00 00 	movabs $0x804b31,%rax
  8032d2:	00 00 00 
  8032d5:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8032d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032db:	ba 00 00 00 00       	mov    $0x0,%edx
  8032e0:	48 89 c6             	mov    %rax,%rsi
  8032e3:	bf 00 00 00 00       	mov    $0x0,%edi
  8032e8:	48 b8 2b 4a 80 00 00 	movabs $0x804a2b,%rax
  8032ef:	00 00 00 
  8032f2:	ff d0                	callq  *%rax
}
  8032f4:	c9                   	leaveq 
  8032f5:	c3                   	retq   

00000000008032f6 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8032f6:	55                   	push   %rbp
  8032f7:	48 89 e5             	mov    %rsp,%rbp
  8032fa:	48 83 ec 30          	sub    $0x30,%rsp
  8032fe:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803302:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  803305:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  80330c:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  803313:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  80331a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80331f:	75 08                	jne    803329 <open+0x33>
	{
		return r;
  803321:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803324:	e9 f2 00 00 00       	jmpq   80341b <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  803329:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80332d:	48 89 c7             	mov    %rax,%rdi
  803330:	48 b8 66 16 80 00 00 	movabs $0x801666,%rax
  803337:	00 00 00 
  80333a:	ff d0                	callq  *%rax
  80333c:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80333f:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  803346:	7e 0a                	jle    803352 <open+0x5c>
	{
		return -E_BAD_PATH;
  803348:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80334d:	e9 c9 00 00 00       	jmpq   80341b <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  803352:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  803359:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  80335a:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80335e:	48 89 c7             	mov    %rax,%rdi
  803361:	48 b8 56 29 80 00 00 	movabs $0x802956,%rax
  803368:	00 00 00 
  80336b:	ff d0                	callq  *%rax
  80336d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803370:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803374:	78 09                	js     80337f <open+0x89>
  803376:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80337a:	48 85 c0             	test   %rax,%rax
  80337d:	75 08                	jne    803387 <open+0x91>
		{
			return r;
  80337f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803382:	e9 94 00 00 00       	jmpq   80341b <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  803387:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80338b:	ba 00 04 00 00       	mov    $0x400,%edx
  803390:	48 89 c6             	mov    %rax,%rsi
  803393:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  80339a:	00 00 00 
  80339d:	48 b8 64 17 80 00 00 	movabs $0x801764,%rax
  8033a4:	00 00 00 
  8033a7:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  8033a9:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8033b0:	00 00 00 
  8033b3:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  8033b6:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  8033bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033c0:	48 89 c6             	mov    %rax,%rsi
  8033c3:	bf 01 00 00 00       	mov    $0x1,%edi
  8033c8:	48 b8 6f 32 80 00 00 	movabs $0x80326f,%rax
  8033cf:	00 00 00 
  8033d2:	ff d0                	callq  *%rax
  8033d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033db:	79 2b                	jns    803408 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  8033dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033e1:	be 00 00 00 00       	mov    $0x0,%esi
  8033e6:	48 89 c7             	mov    %rax,%rdi
  8033e9:	48 b8 7e 2a 80 00 00 	movabs $0x802a7e,%rax
  8033f0:	00 00 00 
  8033f3:	ff d0                	callq  *%rax
  8033f5:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8033f8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8033fc:	79 05                	jns    803403 <open+0x10d>
			{
				return d;
  8033fe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803401:	eb 18                	jmp    80341b <open+0x125>
			}
			return r;
  803403:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803406:	eb 13                	jmp    80341b <open+0x125>
		}	
		return fd2num(fd_store);
  803408:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80340c:	48 89 c7             	mov    %rax,%rdi
  80340f:	48 b8 08 29 80 00 00 	movabs $0x802908,%rax
  803416:	00 00 00 
  803419:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  80341b:	c9                   	leaveq 
  80341c:	c3                   	retq   

000000000080341d <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80341d:	55                   	push   %rbp
  80341e:	48 89 e5             	mov    %rsp,%rbp
  803421:	48 83 ec 10          	sub    $0x10,%rsp
  803425:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803429:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80342d:	8b 50 0c             	mov    0xc(%rax),%edx
  803430:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803437:	00 00 00 
  80343a:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80343c:	be 00 00 00 00       	mov    $0x0,%esi
  803441:	bf 06 00 00 00       	mov    $0x6,%edi
  803446:	48 b8 6f 32 80 00 00 	movabs $0x80326f,%rax
  80344d:	00 00 00 
  803450:	ff d0                	callq  *%rax
}
  803452:	c9                   	leaveq 
  803453:	c3                   	retq   

0000000000803454 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803454:	55                   	push   %rbp
  803455:	48 89 e5             	mov    %rsp,%rbp
  803458:	48 83 ec 30          	sub    $0x30,%rsp
  80345c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803460:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803464:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  803468:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  80346f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803474:	74 07                	je     80347d <devfile_read+0x29>
  803476:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80347b:	75 07                	jne    803484 <devfile_read+0x30>
		return -E_INVAL;
  80347d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803482:	eb 77                	jmp    8034fb <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  803484:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803488:	8b 50 0c             	mov    0xc(%rax),%edx
  80348b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803492:	00 00 00 
  803495:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  803497:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80349e:	00 00 00 
  8034a1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8034a5:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  8034a9:	be 00 00 00 00       	mov    $0x0,%esi
  8034ae:	bf 03 00 00 00       	mov    $0x3,%edi
  8034b3:	48 b8 6f 32 80 00 00 	movabs $0x80326f,%rax
  8034ba:	00 00 00 
  8034bd:	ff d0                	callq  *%rax
  8034bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034c6:	7f 05                	jg     8034cd <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  8034c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034cb:	eb 2e                	jmp    8034fb <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  8034cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034d0:	48 63 d0             	movslq %eax,%rdx
  8034d3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034d7:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8034de:	00 00 00 
  8034e1:	48 89 c7             	mov    %rax,%rdi
  8034e4:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  8034eb:	00 00 00 
  8034ee:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  8034f0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034f4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  8034f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8034fb:	c9                   	leaveq 
  8034fc:	c3                   	retq   

00000000008034fd <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8034fd:	55                   	push   %rbp
  8034fe:	48 89 e5             	mov    %rsp,%rbp
  803501:	48 83 ec 30          	sub    $0x30,%rsp
  803505:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803509:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80350d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  803511:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  803518:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80351d:	74 07                	je     803526 <devfile_write+0x29>
  80351f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803524:	75 08                	jne    80352e <devfile_write+0x31>
		return r;
  803526:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803529:	e9 9a 00 00 00       	jmpq   8035c8 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80352e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803532:	8b 50 0c             	mov    0xc(%rax),%edx
  803535:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80353c:	00 00 00 
  80353f:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  803541:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  803548:	00 
  803549:	76 08                	jbe    803553 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  80354b:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  803552:	00 
	}
	fsipcbuf.write.req_n = n;
  803553:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80355a:	00 00 00 
  80355d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803561:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  803565:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803569:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80356d:	48 89 c6             	mov    %rax,%rsi
  803570:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  803577:	00 00 00 
  80357a:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  803581:	00 00 00 
  803584:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  803586:	be 00 00 00 00       	mov    $0x0,%esi
  80358b:	bf 04 00 00 00       	mov    $0x4,%edi
  803590:	48 b8 6f 32 80 00 00 	movabs $0x80326f,%rax
  803597:	00 00 00 
  80359a:	ff d0                	callq  *%rax
  80359c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80359f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035a3:	7f 20                	jg     8035c5 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  8035a5:	48 bf 96 54 80 00 00 	movabs $0x805496,%rdi
  8035ac:	00 00 00 
  8035af:	b8 00 00 00 00       	mov    $0x0,%eax
  8035b4:	48 ba 1d 0b 80 00 00 	movabs $0x800b1d,%rdx
  8035bb:	00 00 00 
  8035be:	ff d2                	callq  *%rdx
		return r;
  8035c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035c3:	eb 03                	jmp    8035c8 <devfile_write+0xcb>
	}
	return r;
  8035c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  8035c8:	c9                   	leaveq 
  8035c9:	c3                   	retq   

00000000008035ca <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8035ca:	55                   	push   %rbp
  8035cb:	48 89 e5             	mov    %rsp,%rbp
  8035ce:	48 83 ec 20          	sub    $0x20,%rsp
  8035d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8035d6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8035da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035de:	8b 50 0c             	mov    0xc(%rax),%edx
  8035e1:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8035e8:	00 00 00 
  8035eb:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8035ed:	be 00 00 00 00       	mov    $0x0,%esi
  8035f2:	bf 05 00 00 00       	mov    $0x5,%edi
  8035f7:	48 b8 6f 32 80 00 00 	movabs $0x80326f,%rax
  8035fe:	00 00 00 
  803601:	ff d0                	callq  *%rax
  803603:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803606:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80360a:	79 05                	jns    803611 <devfile_stat+0x47>
		return r;
  80360c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80360f:	eb 56                	jmp    803667 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803611:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803615:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  80361c:	00 00 00 
  80361f:	48 89 c7             	mov    %rax,%rdi
  803622:	48 b8 d2 16 80 00 00 	movabs $0x8016d2,%rax
  803629:	00 00 00 
  80362c:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80362e:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803635:	00 00 00 
  803638:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80363e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803642:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803648:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80364f:	00 00 00 
  803652:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803658:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80365c:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803662:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803667:	c9                   	leaveq 
  803668:	c3                   	retq   

0000000000803669 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803669:	55                   	push   %rbp
  80366a:	48 89 e5             	mov    %rsp,%rbp
  80366d:	48 83 ec 10          	sub    $0x10,%rsp
  803671:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803675:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803678:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80367c:	8b 50 0c             	mov    0xc(%rax),%edx
  80367f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803686:	00 00 00 
  803689:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80368b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803692:	00 00 00 
  803695:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803698:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80369b:	be 00 00 00 00       	mov    $0x0,%esi
  8036a0:	bf 02 00 00 00       	mov    $0x2,%edi
  8036a5:	48 b8 6f 32 80 00 00 	movabs $0x80326f,%rax
  8036ac:	00 00 00 
  8036af:	ff d0                	callq  *%rax
}
  8036b1:	c9                   	leaveq 
  8036b2:	c3                   	retq   

00000000008036b3 <remove>:

// Delete a file
int
remove(const char *path)
{
  8036b3:	55                   	push   %rbp
  8036b4:	48 89 e5             	mov    %rsp,%rbp
  8036b7:	48 83 ec 10          	sub    $0x10,%rsp
  8036bb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8036bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036c3:	48 89 c7             	mov    %rax,%rdi
  8036c6:	48 b8 66 16 80 00 00 	movabs $0x801666,%rax
  8036cd:	00 00 00 
  8036d0:	ff d0                	callq  *%rax
  8036d2:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8036d7:	7e 07                	jle    8036e0 <remove+0x2d>
		return -E_BAD_PATH;
  8036d9:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8036de:	eb 33                	jmp    803713 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8036e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036e4:	48 89 c6             	mov    %rax,%rsi
  8036e7:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8036ee:	00 00 00 
  8036f1:	48 b8 d2 16 80 00 00 	movabs $0x8016d2,%rax
  8036f8:	00 00 00 
  8036fb:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8036fd:	be 00 00 00 00       	mov    $0x0,%esi
  803702:	bf 07 00 00 00       	mov    $0x7,%edi
  803707:	48 b8 6f 32 80 00 00 	movabs $0x80326f,%rax
  80370e:	00 00 00 
  803711:	ff d0                	callq  *%rax
}
  803713:	c9                   	leaveq 
  803714:	c3                   	retq   

0000000000803715 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803715:	55                   	push   %rbp
  803716:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803719:	be 00 00 00 00       	mov    $0x0,%esi
  80371e:	bf 08 00 00 00       	mov    $0x8,%edi
  803723:	48 b8 6f 32 80 00 00 	movabs $0x80326f,%rax
  80372a:	00 00 00 
  80372d:	ff d0                	callq  *%rax
}
  80372f:	5d                   	pop    %rbp
  803730:	c3                   	retq   

0000000000803731 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  803731:	55                   	push   %rbp
  803732:	48 89 e5             	mov    %rsp,%rbp
  803735:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  80373c:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  803743:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  80374a:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  803751:	be 00 00 00 00       	mov    $0x0,%esi
  803756:	48 89 c7             	mov    %rax,%rdi
  803759:	48 b8 f6 32 80 00 00 	movabs $0x8032f6,%rax
  803760:	00 00 00 
  803763:	ff d0                	callq  *%rax
  803765:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803768:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80376c:	79 08                	jns    803776 <spawn+0x45>
		return r;
  80376e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803771:	e9 14 03 00 00       	jmpq   803a8a <spawn+0x359>
	fd = r;
  803776:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803779:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  80377c:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  803783:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  803787:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  80378e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803791:	ba 00 02 00 00       	mov    $0x200,%edx
  803796:	48 89 ce             	mov    %rcx,%rsi
  803799:	89 c7                	mov    %eax,%edi
  80379b:	48 b8 f5 2e 80 00 00 	movabs $0x802ef5,%rax
  8037a2:	00 00 00 
  8037a5:	ff d0                	callq  *%rax
  8037a7:	3d 00 02 00 00       	cmp    $0x200,%eax
  8037ac:	75 0d                	jne    8037bb <spawn+0x8a>
	    || elf->e_magic != ELF_MAGIC) {
  8037ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037b2:	8b 00                	mov    (%rax),%eax
  8037b4:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  8037b9:	74 43                	je     8037fe <spawn+0xcd>
		close(fd);
  8037bb:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8037be:	89 c7                	mov    %eax,%edi
  8037c0:	48 b8 fe 2b 80 00 00 	movabs $0x802bfe,%rax
  8037c7:	00 00 00 
  8037ca:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8037cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037d0:	8b 00                	mov    (%rax),%eax
  8037d2:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  8037d7:	89 c6                	mov    %eax,%esi
  8037d9:	48 bf b8 54 80 00 00 	movabs $0x8054b8,%rdi
  8037e0:	00 00 00 
  8037e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8037e8:	48 b9 1d 0b 80 00 00 	movabs $0x800b1d,%rcx
  8037ef:	00 00 00 
  8037f2:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  8037f4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8037f9:	e9 8c 02 00 00       	jmpq   803a8a <spawn+0x359>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8037fe:	b8 07 00 00 00       	mov    $0x7,%eax
  803803:	cd 30                	int    $0x30
  803805:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  803808:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  80380b:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80380e:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803812:	79 08                	jns    80381c <spawn+0xeb>
		return r;
  803814:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803817:	e9 6e 02 00 00       	jmpq   803a8a <spawn+0x359>
	child = r;
  80381c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80381f:	89 45 d4             	mov    %eax,-0x2c(%rbp)
	//thisenv = &envs[ENVX(sys_getenvid())];
	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  803822:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803825:	25 ff 03 00 00       	and    $0x3ff,%eax
  80382a:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803831:	00 00 00 
  803834:	48 63 d0             	movslq %eax,%rdx
  803837:	48 89 d0             	mov    %rdx,%rax
  80383a:	48 c1 e0 03          	shl    $0x3,%rax
  80383e:	48 01 d0             	add    %rdx,%rax
  803841:	48 c1 e0 05          	shl    $0x5,%rax
  803845:	48 01 c8             	add    %rcx,%rax
  803848:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  80384f:	48 89 c6             	mov    %rax,%rsi
  803852:	b8 18 00 00 00       	mov    $0x18,%eax
  803857:	48 89 d7             	mov    %rdx,%rdi
  80385a:	48 89 c1             	mov    %rax,%rcx
  80385d:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  803860:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803864:	48 8b 40 18          	mov    0x18(%rax),%rax
  803868:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  80386f:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  803876:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  80387d:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  803884:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803887:	48 89 ce             	mov    %rcx,%rsi
  80388a:	89 c7                	mov    %eax,%edi
  80388c:	48 b8 f4 3c 80 00 00 	movabs $0x803cf4,%rax
  803893:	00 00 00 
  803896:	ff d0                	callq  *%rax
  803898:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80389b:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80389f:	79 08                	jns    8038a9 <spawn+0x178>
		return r;
  8038a1:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8038a4:	e9 e1 01 00 00       	jmpq   803a8a <spawn+0x359>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8038a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038ad:	48 8b 40 20          	mov    0x20(%rax),%rax
  8038b1:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  8038b8:	48 01 d0             	add    %rdx,%rax
  8038bb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8038bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8038c6:	e9 a3 00 00 00       	jmpq   80396e <spawn+0x23d>
		if (ph->p_type != ELF_PROG_LOAD)
  8038cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038cf:	8b 00                	mov    (%rax),%eax
  8038d1:	83 f8 01             	cmp    $0x1,%eax
  8038d4:	74 05                	je     8038db <spawn+0x1aa>
			continue;
  8038d6:	e9 8a 00 00 00       	jmpq   803965 <spawn+0x234>
		perm = PTE_P | PTE_U;
  8038db:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  8038e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038e6:	8b 40 04             	mov    0x4(%rax),%eax
  8038e9:	83 e0 02             	and    $0x2,%eax
  8038ec:	85 c0                	test   %eax,%eax
  8038ee:	74 04                	je     8038f4 <spawn+0x1c3>
			perm |= PTE_W;
  8038f0:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  8038f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038f8:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  8038fc:	41 89 c1             	mov    %eax,%r9d
  8038ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803903:	4c 8b 40 20          	mov    0x20(%rax),%r8
  803907:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80390b:	48 8b 50 28          	mov    0x28(%rax),%rdx
  80390f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803913:	48 8b 70 10          	mov    0x10(%rax),%rsi
  803917:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80391a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80391d:	8b 7d ec             	mov    -0x14(%rbp),%edi
  803920:	89 3c 24             	mov    %edi,(%rsp)
  803923:	89 c7                	mov    %eax,%edi
  803925:	48 b8 9d 3f 80 00 00 	movabs $0x803f9d,%rax
  80392c:	00 00 00 
  80392f:	ff d0                	callq  *%rax
  803931:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803934:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803938:	79 2b                	jns    803965 <spawn+0x234>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  80393a:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  80393b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80393e:	89 c7                	mov    %eax,%edi
  803940:	48 b8 41 1f 80 00 00 	movabs $0x801f41,%rax
  803947:	00 00 00 
  80394a:	ff d0                	callq  *%rax
	close(fd);
  80394c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80394f:	89 c7                	mov    %eax,%edi
  803951:	48 b8 fe 2b 80 00 00 	movabs $0x802bfe,%rax
  803958:	00 00 00 
  80395b:	ff d0                	callq  *%rax
	return r;
  80395d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803960:	e9 25 01 00 00       	jmpq   803a8a <spawn+0x359>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  803965:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803969:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  80396e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803972:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  803976:	0f b7 c0             	movzwl %ax,%eax
  803979:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  80397c:	0f 8f 49 ff ff ff    	jg     8038cb <spawn+0x19a>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  803982:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803985:	89 c7                	mov    %eax,%edi
  803987:	48 b8 fe 2b 80 00 00 	movabs $0x802bfe,%rax
  80398e:	00 00 00 
  803991:	ff d0                	callq  *%rax
	fd = -1;
  803993:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  80399a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80399d:	89 c7                	mov    %eax,%edi
  80399f:	48 b8 89 41 80 00 00 	movabs $0x804189,%rax
  8039a6:	00 00 00 
  8039a9:	ff d0                	callq  *%rax
  8039ab:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8039ae:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8039b2:	79 30                	jns    8039e4 <spawn+0x2b3>
		panic("copy_shared_pages: %e", r);
  8039b4:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8039b7:	89 c1                	mov    %eax,%ecx
  8039b9:	48 ba d2 54 80 00 00 	movabs $0x8054d2,%rdx
  8039c0:	00 00 00 
  8039c3:	be 82 00 00 00       	mov    $0x82,%esi
  8039c8:	48 bf e8 54 80 00 00 	movabs $0x8054e8,%rdi
  8039cf:	00 00 00 
  8039d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8039d7:	49 b8 e4 08 80 00 00 	movabs $0x8008e4,%r8
  8039de:	00 00 00 
  8039e1:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8039e4:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  8039eb:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8039ee:	48 89 d6             	mov    %rdx,%rsi
  8039f1:	89 c7                	mov    %eax,%edi
  8039f3:	48 b8 41 21 80 00 00 	movabs $0x802141,%rax
  8039fa:	00 00 00 
  8039fd:	ff d0                	callq  *%rax
  8039ff:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803a02:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803a06:	79 30                	jns    803a38 <spawn+0x307>
		panic("sys_env_set_trapframe: %e", r);
  803a08:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803a0b:	89 c1                	mov    %eax,%ecx
  803a0d:	48 ba f4 54 80 00 00 	movabs $0x8054f4,%rdx
  803a14:	00 00 00 
  803a17:	be 85 00 00 00       	mov    $0x85,%esi
  803a1c:	48 bf e8 54 80 00 00 	movabs $0x8054e8,%rdi
  803a23:	00 00 00 
  803a26:	b8 00 00 00 00       	mov    $0x0,%eax
  803a2b:	49 b8 e4 08 80 00 00 	movabs $0x8008e4,%r8
  803a32:	00 00 00 
  803a35:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  803a38:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803a3b:	be 02 00 00 00       	mov    $0x2,%esi
  803a40:	89 c7                	mov    %eax,%edi
  803a42:	48 b8 f6 20 80 00 00 	movabs $0x8020f6,%rax
  803a49:	00 00 00 
  803a4c:	ff d0                	callq  *%rax
  803a4e:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803a51:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803a55:	79 30                	jns    803a87 <spawn+0x356>
		panic("sys_env_set_status: %e", r);
  803a57:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803a5a:	89 c1                	mov    %eax,%ecx
  803a5c:	48 ba 0e 55 80 00 00 	movabs $0x80550e,%rdx
  803a63:	00 00 00 
  803a66:	be 88 00 00 00       	mov    $0x88,%esi
  803a6b:	48 bf e8 54 80 00 00 	movabs $0x8054e8,%rdi
  803a72:	00 00 00 
  803a75:	b8 00 00 00 00       	mov    $0x0,%eax
  803a7a:	49 b8 e4 08 80 00 00 	movabs $0x8008e4,%r8
  803a81:	00 00 00 
  803a84:	41 ff d0             	callq  *%r8

	return child;
  803a87:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  803a8a:	c9                   	leaveq 
  803a8b:	c3                   	retq   

0000000000803a8c <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  803a8c:	55                   	push   %rbp
  803a8d:	48 89 e5             	mov    %rsp,%rbp
  803a90:	41 55                	push   %r13
  803a92:	41 54                	push   %r12
  803a94:	53                   	push   %rbx
  803a95:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803a9c:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  803aa3:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  803aaa:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  803ab1:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  803ab8:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  803abf:	84 c0                	test   %al,%al
  803ac1:	74 26                	je     803ae9 <spawnl+0x5d>
  803ac3:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  803aca:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  803ad1:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  803ad5:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  803ad9:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  803add:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  803ae1:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  803ae5:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  803ae9:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  803af0:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  803af7:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  803afa:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803b01:	00 00 00 
  803b04:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803b0b:	00 00 00 
  803b0e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803b12:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803b19:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803b20:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  803b27:	eb 07                	jmp    803b30 <spawnl+0xa4>
		argc++;
  803b29:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  803b30:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803b36:	83 f8 30             	cmp    $0x30,%eax
  803b39:	73 23                	jae    803b5e <spawnl+0xd2>
  803b3b:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  803b42:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803b48:	89 c0                	mov    %eax,%eax
  803b4a:	48 01 d0             	add    %rdx,%rax
  803b4d:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803b53:	83 c2 08             	add    $0x8,%edx
  803b56:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803b5c:	eb 15                	jmp    803b73 <spawnl+0xe7>
  803b5e:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  803b65:	48 89 d0             	mov    %rdx,%rax
  803b68:	48 83 c2 08          	add    $0x8,%rdx
  803b6c:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803b73:	48 8b 00             	mov    (%rax),%rax
  803b76:	48 85 c0             	test   %rax,%rax
  803b79:	75 ae                	jne    803b29 <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  803b7b:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803b81:	83 c0 02             	add    $0x2,%eax
  803b84:	48 89 e2             	mov    %rsp,%rdx
  803b87:	48 89 d3             	mov    %rdx,%rbx
  803b8a:	48 63 d0             	movslq %eax,%rdx
  803b8d:	48 83 ea 01          	sub    $0x1,%rdx
  803b91:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  803b98:	48 63 d0             	movslq %eax,%rdx
  803b9b:	49 89 d4             	mov    %rdx,%r12
  803b9e:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  803ba4:	48 63 d0             	movslq %eax,%rdx
  803ba7:	49 89 d2             	mov    %rdx,%r10
  803baa:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  803bb0:	48 98                	cltq   
  803bb2:	48 c1 e0 03          	shl    $0x3,%rax
  803bb6:	48 8d 50 07          	lea    0x7(%rax),%rdx
  803bba:	b8 10 00 00 00       	mov    $0x10,%eax
  803bbf:	48 83 e8 01          	sub    $0x1,%rax
  803bc3:	48 01 d0             	add    %rdx,%rax
  803bc6:	bf 10 00 00 00       	mov    $0x10,%edi
  803bcb:	ba 00 00 00 00       	mov    $0x0,%edx
  803bd0:	48 f7 f7             	div    %rdi
  803bd3:	48 6b c0 10          	imul   $0x10,%rax,%rax
  803bd7:	48 29 c4             	sub    %rax,%rsp
  803bda:	48 89 e0             	mov    %rsp,%rax
  803bdd:	48 83 c0 07          	add    $0x7,%rax
  803be1:	48 c1 e8 03          	shr    $0x3,%rax
  803be5:	48 c1 e0 03          	shl    $0x3,%rax
  803be9:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  803bf0:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803bf7:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  803bfe:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  803c01:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803c07:	8d 50 01             	lea    0x1(%rax),%edx
  803c0a:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803c11:	48 63 d2             	movslq %edx,%rdx
  803c14:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  803c1b:	00 

	va_start(vl, arg0);
  803c1c:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803c23:	00 00 00 
  803c26:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803c2d:	00 00 00 
  803c30:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803c34:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803c3b:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803c42:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  803c49:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  803c50:	00 00 00 
  803c53:	eb 63                	jmp    803cb8 <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  803c55:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  803c5b:	8d 70 01             	lea    0x1(%rax),%esi
  803c5e:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803c64:	83 f8 30             	cmp    $0x30,%eax
  803c67:	73 23                	jae    803c8c <spawnl+0x200>
  803c69:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  803c70:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803c76:	89 c0                	mov    %eax,%eax
  803c78:	48 01 d0             	add    %rdx,%rax
  803c7b:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803c81:	83 c2 08             	add    $0x8,%edx
  803c84:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803c8a:	eb 15                	jmp    803ca1 <spawnl+0x215>
  803c8c:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  803c93:	48 89 d0             	mov    %rdx,%rax
  803c96:	48 83 c2 08          	add    $0x8,%rdx
  803c9a:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803ca1:	48 8b 08             	mov    (%rax),%rcx
  803ca4:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803cab:	89 f2                	mov    %esi,%edx
  803cad:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  803cb1:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  803cb8:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803cbe:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  803cc4:	77 8f                	ja     803c55 <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  803cc6:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803ccd:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  803cd4:	48 89 d6             	mov    %rdx,%rsi
  803cd7:	48 89 c7             	mov    %rax,%rdi
  803cda:	48 b8 31 37 80 00 00 	movabs $0x803731,%rax
  803ce1:	00 00 00 
  803ce4:	ff d0                	callq  *%rax
  803ce6:	48 89 dc             	mov    %rbx,%rsp
}
  803ce9:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  803ced:	5b                   	pop    %rbx
  803cee:	41 5c                	pop    %r12
  803cf0:	41 5d                	pop    %r13
  803cf2:	5d                   	pop    %rbp
  803cf3:	c3                   	retq   

0000000000803cf4 <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  803cf4:	55                   	push   %rbp
  803cf5:	48 89 e5             	mov    %rsp,%rbp
  803cf8:	48 83 ec 50          	sub    $0x50,%rsp
  803cfc:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803cff:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  803d03:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  803d07:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803d0e:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  803d0f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  803d16:	eb 33                	jmp    803d4b <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  803d18:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803d1b:	48 98                	cltq   
  803d1d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803d24:	00 
  803d25:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803d29:	48 01 d0             	add    %rdx,%rax
  803d2c:	48 8b 00             	mov    (%rax),%rax
  803d2f:	48 89 c7             	mov    %rax,%rdi
  803d32:	48 b8 66 16 80 00 00 	movabs $0x801666,%rax
  803d39:	00 00 00 
  803d3c:	ff d0                	callq  *%rax
  803d3e:	83 c0 01             	add    $0x1,%eax
  803d41:	48 98                	cltq   
  803d43:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  803d47:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  803d4b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803d4e:	48 98                	cltq   
  803d50:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803d57:	00 
  803d58:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803d5c:	48 01 d0             	add    %rdx,%rax
  803d5f:	48 8b 00             	mov    (%rax),%rax
  803d62:	48 85 c0             	test   %rax,%rax
  803d65:	75 b1                	jne    803d18 <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  803d67:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d6b:	48 f7 d8             	neg    %rax
  803d6e:	48 05 00 10 40 00    	add    $0x401000,%rax
  803d74:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  803d78:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d7c:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803d80:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d84:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  803d88:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803d8b:	83 c2 01             	add    $0x1,%edx
  803d8e:	c1 e2 03             	shl    $0x3,%edx
  803d91:	48 63 d2             	movslq %edx,%rdx
  803d94:	48 f7 da             	neg    %rdx
  803d97:	48 01 d0             	add    %rdx,%rax
  803d9a:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  803d9e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803da2:	48 83 e8 10          	sub    $0x10,%rax
  803da6:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  803dac:	77 0a                	ja     803db8 <init_stack+0xc4>
		return -E_NO_MEM;
  803dae:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  803db3:	e9 e3 01 00 00       	jmpq   803f9b <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803db8:	ba 07 00 00 00       	mov    $0x7,%edx
  803dbd:	be 00 00 40 00       	mov    $0x400000,%esi
  803dc2:	bf 00 00 00 00       	mov    $0x0,%edi
  803dc7:	48 b8 01 20 80 00 00 	movabs $0x802001,%rax
  803dce:	00 00 00 
  803dd1:	ff d0                	callq  *%rax
  803dd3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803dd6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803dda:	79 08                	jns    803de4 <init_stack+0xf0>
		return r;
  803ddc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ddf:	e9 b7 01 00 00       	jmpq   803f9b <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803de4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  803deb:	e9 8a 00 00 00       	jmpq   803e7a <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  803df0:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803df3:	48 98                	cltq   
  803df5:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803dfc:	00 
  803dfd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e01:	48 01 c2             	add    %rax,%rdx
  803e04:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803e09:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e0d:	48 01 c8             	add    %rcx,%rax
  803e10:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803e16:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  803e19:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803e1c:	48 98                	cltq   
  803e1e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803e25:	00 
  803e26:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803e2a:	48 01 d0             	add    %rdx,%rax
  803e2d:	48 8b 10             	mov    (%rax),%rdx
  803e30:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e34:	48 89 d6             	mov    %rdx,%rsi
  803e37:	48 89 c7             	mov    %rax,%rdi
  803e3a:	48 b8 d2 16 80 00 00 	movabs $0x8016d2,%rax
  803e41:	00 00 00 
  803e44:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  803e46:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803e49:	48 98                	cltq   
  803e4b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803e52:	00 
  803e53:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803e57:	48 01 d0             	add    %rdx,%rax
  803e5a:	48 8b 00             	mov    (%rax),%rax
  803e5d:	48 89 c7             	mov    %rax,%rdi
  803e60:	48 b8 66 16 80 00 00 	movabs $0x801666,%rax
  803e67:	00 00 00 
  803e6a:	ff d0                	callq  *%rax
  803e6c:	48 98                	cltq   
  803e6e:	48 83 c0 01          	add    $0x1,%rax
  803e72:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803e76:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  803e7a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803e7d:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  803e80:	0f 8c 6a ff ff ff    	jl     803df0 <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  803e86:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803e89:	48 98                	cltq   
  803e8b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803e92:	00 
  803e93:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e97:	48 01 d0             	add    %rdx,%rax
  803e9a:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  803ea1:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  803ea8:	00 
  803ea9:	74 35                	je     803ee0 <init_stack+0x1ec>
  803eab:	48 b9 28 55 80 00 00 	movabs $0x805528,%rcx
  803eb2:	00 00 00 
  803eb5:	48 ba 4e 55 80 00 00 	movabs $0x80554e,%rdx
  803ebc:	00 00 00 
  803ebf:	be f1 00 00 00       	mov    $0xf1,%esi
  803ec4:	48 bf e8 54 80 00 00 	movabs $0x8054e8,%rdi
  803ecb:	00 00 00 
  803ece:	b8 00 00 00 00       	mov    $0x0,%eax
  803ed3:	49 b8 e4 08 80 00 00 	movabs $0x8008e4,%r8
  803eda:	00 00 00 
  803edd:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  803ee0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ee4:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  803ee8:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803eed:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ef1:	48 01 c8             	add    %rcx,%rax
  803ef4:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803efa:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  803efd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f01:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  803f05:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803f08:	48 98                	cltq   
  803f0a:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  803f0d:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  803f12:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f16:	48 01 d0             	add    %rdx,%rax
  803f19:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803f1f:	48 89 c2             	mov    %rax,%rdx
  803f22:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803f26:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  803f29:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803f2c:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  803f32:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803f37:	89 c2                	mov    %eax,%edx
  803f39:	be 00 00 40 00       	mov    $0x400000,%esi
  803f3e:	bf 00 00 00 00       	mov    $0x0,%edi
  803f43:	48 b8 51 20 80 00 00 	movabs $0x802051,%rax
  803f4a:	00 00 00 
  803f4d:	ff d0                	callq  *%rax
  803f4f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f52:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f56:	79 02                	jns    803f5a <init_stack+0x266>
		goto error;
  803f58:	eb 28                	jmp    803f82 <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  803f5a:	be 00 00 40 00       	mov    $0x400000,%esi
  803f5f:	bf 00 00 00 00       	mov    $0x0,%edi
  803f64:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  803f6b:	00 00 00 
  803f6e:	ff d0                	callq  *%rax
  803f70:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f73:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f77:	79 02                	jns    803f7b <init_stack+0x287>
		goto error;
  803f79:	eb 07                	jmp    803f82 <init_stack+0x28e>

	return 0;
  803f7b:	b8 00 00 00 00       	mov    $0x0,%eax
  803f80:	eb 19                	jmp    803f9b <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  803f82:	be 00 00 40 00       	mov    $0x400000,%esi
  803f87:	bf 00 00 00 00       	mov    $0x0,%edi
  803f8c:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  803f93:	00 00 00 
  803f96:	ff d0                	callq  *%rax
	return r;
  803f98:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803f9b:	c9                   	leaveq 
  803f9c:	c3                   	retq   

0000000000803f9d <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	int fd, size_t filesz, off_t fileoffset, int perm)
{
  803f9d:	55                   	push   %rbp
  803f9e:	48 89 e5             	mov    %rsp,%rbp
  803fa1:	48 83 ec 50          	sub    $0x50,%rsp
  803fa5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803fa8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803fac:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  803fb0:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  803fb3:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  803fb7:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  803fbb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803fbf:	25 ff 0f 00 00       	and    $0xfff,%eax
  803fc4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fc7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fcb:	74 21                	je     803fee <map_segment+0x51>
		va -= i;
  803fcd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fd0:	48 98                	cltq   
  803fd2:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  803fd6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fd9:	48 98                	cltq   
  803fdb:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  803fdf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fe2:	48 98                	cltq   
  803fe4:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  803fe8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803feb:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803fee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803ff5:	e9 79 01 00 00       	jmpq   804173 <map_segment+0x1d6>
		if (i >= filesz) {
  803ffa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ffd:	48 98                	cltq   
  803fff:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  804003:	72 3c                	jb     804041 <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  804005:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804008:	48 63 d0             	movslq %eax,%rdx
  80400b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80400f:	48 01 d0             	add    %rdx,%rax
  804012:	48 89 c1             	mov    %rax,%rcx
  804015:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804018:	8b 55 10             	mov    0x10(%rbp),%edx
  80401b:	48 89 ce             	mov    %rcx,%rsi
  80401e:	89 c7                	mov    %eax,%edi
  804020:	48 b8 01 20 80 00 00 	movabs $0x802001,%rax
  804027:	00 00 00 
  80402a:	ff d0                	callq  *%rax
  80402c:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80402f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  804033:	0f 89 33 01 00 00    	jns    80416c <map_segment+0x1cf>
				return r;
  804039:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80403c:	e9 46 01 00 00       	jmpq   804187 <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  804041:	ba 07 00 00 00       	mov    $0x7,%edx
  804046:	be 00 00 40 00       	mov    $0x400000,%esi
  80404b:	bf 00 00 00 00       	mov    $0x0,%edi
  804050:	48 b8 01 20 80 00 00 	movabs $0x802001,%rax
  804057:	00 00 00 
  80405a:	ff d0                	callq  *%rax
  80405c:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80405f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  804063:	79 08                	jns    80406d <map_segment+0xd0>
				return r;
  804065:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804068:	e9 1a 01 00 00       	jmpq   804187 <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  80406d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804070:	8b 55 bc             	mov    -0x44(%rbp),%edx
  804073:	01 c2                	add    %eax,%edx
  804075:	8b 45 d8             	mov    -0x28(%rbp),%eax
  804078:	89 d6                	mov    %edx,%esi
  80407a:	89 c7                	mov    %eax,%edi
  80407c:	48 b8 3e 30 80 00 00 	movabs $0x80303e,%rax
  804083:	00 00 00 
  804086:	ff d0                	callq  *%rax
  804088:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80408b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80408f:	79 08                	jns    804099 <map_segment+0xfc>
				return r;
  804091:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804094:	e9 ee 00 00 00       	jmpq   804187 <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  804099:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  8040a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040a3:	48 98                	cltq   
  8040a5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8040a9:	48 29 c2             	sub    %rax,%rdx
  8040ac:	48 89 d0             	mov    %rdx,%rax
  8040af:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8040b3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8040b6:	48 63 d0             	movslq %eax,%rdx
  8040b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040bd:	48 39 c2             	cmp    %rax,%rdx
  8040c0:	48 0f 47 d0          	cmova  %rax,%rdx
  8040c4:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8040c7:	be 00 00 40 00       	mov    $0x400000,%esi
  8040cc:	89 c7                	mov    %eax,%edi
  8040ce:	48 b8 f5 2e 80 00 00 	movabs $0x802ef5,%rax
  8040d5:	00 00 00 
  8040d8:	ff d0                	callq  *%rax
  8040da:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8040dd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8040e1:	79 08                	jns    8040eb <map_segment+0x14e>
				return r;
  8040e3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8040e6:	e9 9c 00 00 00       	jmpq   804187 <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8040eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040ee:	48 63 d0             	movslq %eax,%rdx
  8040f1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040f5:	48 01 d0             	add    %rdx,%rax
  8040f8:	48 89 c2             	mov    %rax,%rdx
  8040fb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8040fe:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  804102:	48 89 d1             	mov    %rdx,%rcx
  804105:	89 c2                	mov    %eax,%edx
  804107:	be 00 00 40 00       	mov    $0x400000,%esi
  80410c:	bf 00 00 00 00       	mov    $0x0,%edi
  804111:	48 b8 51 20 80 00 00 	movabs $0x802051,%rax
  804118:	00 00 00 
  80411b:	ff d0                	callq  *%rax
  80411d:	89 45 f8             	mov    %eax,-0x8(%rbp)
  804120:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  804124:	79 30                	jns    804156 <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  804126:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804129:	89 c1                	mov    %eax,%ecx
  80412b:	48 ba 63 55 80 00 00 	movabs $0x805563,%rdx
  804132:	00 00 00 
  804135:	be 24 01 00 00       	mov    $0x124,%esi
  80413a:	48 bf e8 54 80 00 00 	movabs $0x8054e8,%rdi
  804141:	00 00 00 
  804144:	b8 00 00 00 00       	mov    $0x0,%eax
  804149:	49 b8 e4 08 80 00 00 	movabs $0x8008e4,%r8
  804150:	00 00 00 
  804153:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  804156:	be 00 00 40 00       	mov    $0x400000,%esi
  80415b:	bf 00 00 00 00       	mov    $0x0,%edi
  804160:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  804167:	00 00 00 
  80416a:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80416c:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  804173:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804176:	48 98                	cltq   
  804178:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80417c:	0f 82 78 fe ff ff    	jb     803ffa <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  804182:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804187:	c9                   	leaveq 
  804188:	c3                   	retq   

0000000000804189 <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  804189:	55                   	push   %rbp
  80418a:	48 89 e5             	mov    %rsp,%rbp
  80418d:	48 83 ec 20          	sub    $0x20,%rsp
  804191:	89 7d ec             	mov    %edi,-0x14(%rbp)
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  804194:	48 c7 45 f8 00 00 80 	movq   $0x800000,-0x8(%rbp)
  80419b:	00 
  80419c:	e9 c9 00 00 00       	jmpq   80426a <copy_shared_pages+0xe1>
        {
            if(!((uvpml4e[VPML4E(addr)])&&(uvpde[VPDPE(addr)]) && (uvpd[VPD(addr)]  )))
  8041a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041a5:	48 c1 e8 27          	shr    $0x27,%rax
  8041a9:	48 89 c2             	mov    %rax,%rdx
  8041ac:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8041b3:	01 00 00 
  8041b6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8041ba:	48 85 c0             	test   %rax,%rax
  8041bd:	74 3c                	je     8041fb <copy_shared_pages+0x72>
  8041bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041c3:	48 c1 e8 1e          	shr    $0x1e,%rax
  8041c7:	48 89 c2             	mov    %rax,%rdx
  8041ca:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8041d1:	01 00 00 
  8041d4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8041d8:	48 85 c0             	test   %rax,%rax
  8041db:	74 1e                	je     8041fb <copy_shared_pages+0x72>
  8041dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041e1:	48 c1 e8 15          	shr    $0x15,%rax
  8041e5:	48 89 c2             	mov    %rax,%rdx
  8041e8:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8041ef:	01 00 00 
  8041f2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8041f6:	48 85 c0             	test   %rax,%rax
  8041f9:	75 02                	jne    8041fd <copy_shared_pages+0x74>
                continue;
  8041fb:	eb 65                	jmp    804262 <copy_shared_pages+0xd9>

            if((uvpt[VPN(addr)] & PTE_SHARE) != 0)
  8041fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804201:	48 c1 e8 0c          	shr    $0xc,%rax
  804205:	48 89 c2             	mov    %rax,%rdx
  804208:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80420f:	01 00 00 
  804212:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804216:	25 00 04 00 00       	and    $0x400,%eax
  80421b:	48 85 c0             	test   %rax,%rax
  80421e:	74 42                	je     804262 <copy_shared_pages+0xd9>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);
  804220:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804224:	48 c1 e8 0c          	shr    $0xc,%rax
  804228:	48 89 c2             	mov    %rax,%rdx
  80422b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804232:	01 00 00 
  804235:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804239:	25 07 0e 00 00       	and    $0xe07,%eax
  80423e:	89 c6                	mov    %eax,%esi
  804240:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  804244:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804248:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80424b:	41 89 f0             	mov    %esi,%r8d
  80424e:	48 89 c6             	mov    %rax,%rsi
  804251:	bf 00 00 00 00       	mov    $0x0,%edi
  804256:	48 b8 51 20 80 00 00 	movabs $0x802051,%rax
  80425d:	00 00 00 
  804260:	ff d0                	callq  *%rax
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  804262:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  804269:	00 
  80426a:	48 b8 ff ff 7f 00 80 	movabs $0x80007fffff,%rax
  804271:	00 00 00 
  804274:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  804278:	0f 86 23 ff ff ff    	jbe    8041a1 <copy_shared_pages+0x18>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);

            }
        }
     return 0;
  80427e:	b8 00 00 00 00       	mov    $0x0,%eax
 }
  804283:	c9                   	leaveq 
  804284:	c3                   	retq   

0000000000804285 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  804285:	55                   	push   %rbp
  804286:	48 89 e5             	mov    %rsp,%rbp
  804289:	53                   	push   %rbx
  80428a:	48 83 ec 38          	sub    $0x38,%rsp
  80428e:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  804292:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  804296:	48 89 c7             	mov    %rax,%rdi
  804299:	48 b8 56 29 80 00 00 	movabs $0x802956,%rax
  8042a0:	00 00 00 
  8042a3:	ff d0                	callq  *%rax
  8042a5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8042a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8042ac:	0f 88 bf 01 00 00    	js     804471 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8042b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042b6:	ba 07 04 00 00       	mov    $0x407,%edx
  8042bb:	48 89 c6             	mov    %rax,%rsi
  8042be:	bf 00 00 00 00       	mov    $0x0,%edi
  8042c3:	48 b8 01 20 80 00 00 	movabs $0x802001,%rax
  8042ca:	00 00 00 
  8042cd:	ff d0                	callq  *%rax
  8042cf:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8042d2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8042d6:	0f 88 95 01 00 00    	js     804471 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8042dc:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8042e0:	48 89 c7             	mov    %rax,%rdi
  8042e3:	48 b8 56 29 80 00 00 	movabs $0x802956,%rax
  8042ea:	00 00 00 
  8042ed:	ff d0                	callq  *%rax
  8042ef:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8042f2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8042f6:	0f 88 5d 01 00 00    	js     804459 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8042fc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804300:	ba 07 04 00 00       	mov    $0x407,%edx
  804305:	48 89 c6             	mov    %rax,%rsi
  804308:	bf 00 00 00 00       	mov    $0x0,%edi
  80430d:	48 b8 01 20 80 00 00 	movabs $0x802001,%rax
  804314:	00 00 00 
  804317:	ff d0                	callq  *%rax
  804319:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80431c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804320:	0f 88 33 01 00 00    	js     804459 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  804326:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80432a:	48 89 c7             	mov    %rax,%rdi
  80432d:	48 b8 2b 29 80 00 00 	movabs $0x80292b,%rax
  804334:	00 00 00 
  804337:	ff d0                	callq  *%rax
  804339:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80433d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804341:	ba 07 04 00 00       	mov    $0x407,%edx
  804346:	48 89 c6             	mov    %rax,%rsi
  804349:	bf 00 00 00 00       	mov    $0x0,%edi
  80434e:	48 b8 01 20 80 00 00 	movabs $0x802001,%rax
  804355:	00 00 00 
  804358:	ff d0                	callq  *%rax
  80435a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80435d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804361:	79 05                	jns    804368 <pipe+0xe3>
		goto err2;
  804363:	e9 d9 00 00 00       	jmpq   804441 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804368:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80436c:	48 89 c7             	mov    %rax,%rdi
  80436f:	48 b8 2b 29 80 00 00 	movabs $0x80292b,%rax
  804376:	00 00 00 
  804379:	ff d0                	callq  *%rax
  80437b:	48 89 c2             	mov    %rax,%rdx
  80437e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804382:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  804388:	48 89 d1             	mov    %rdx,%rcx
  80438b:	ba 00 00 00 00       	mov    $0x0,%edx
  804390:	48 89 c6             	mov    %rax,%rsi
  804393:	bf 00 00 00 00       	mov    $0x0,%edi
  804398:	48 b8 51 20 80 00 00 	movabs $0x802051,%rax
  80439f:	00 00 00 
  8043a2:	ff d0                	callq  *%rax
  8043a4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8043a7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8043ab:	79 1b                	jns    8043c8 <pipe+0x143>
		goto err3;
  8043ad:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  8043ae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043b2:	48 89 c6             	mov    %rax,%rsi
  8043b5:	bf 00 00 00 00       	mov    $0x0,%edi
  8043ba:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  8043c1:	00 00 00 
  8043c4:	ff d0                	callq  *%rax
  8043c6:	eb 79                	jmp    804441 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8043c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043cc:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  8043d3:	00 00 00 
  8043d6:	8b 12                	mov    (%rdx),%edx
  8043d8:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8043da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043de:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8043e5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8043e9:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  8043f0:	00 00 00 
  8043f3:	8b 12                	mov    (%rdx),%edx
  8043f5:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8043f7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8043fb:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  804402:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804406:	48 89 c7             	mov    %rax,%rdi
  804409:	48 b8 08 29 80 00 00 	movabs $0x802908,%rax
  804410:	00 00 00 
  804413:	ff d0                	callq  *%rax
  804415:	89 c2                	mov    %eax,%edx
  804417:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80441b:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80441d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804421:	48 8d 58 04          	lea    0x4(%rax),%rbx
  804425:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804429:	48 89 c7             	mov    %rax,%rdi
  80442c:	48 b8 08 29 80 00 00 	movabs $0x802908,%rax
  804433:	00 00 00 
  804436:	ff d0                	callq  *%rax
  804438:	89 03                	mov    %eax,(%rbx)
	return 0;
  80443a:	b8 00 00 00 00       	mov    $0x0,%eax
  80443f:	eb 33                	jmp    804474 <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  804441:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804445:	48 89 c6             	mov    %rax,%rsi
  804448:	bf 00 00 00 00       	mov    $0x0,%edi
  80444d:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  804454:	00 00 00 
  804457:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  804459:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80445d:	48 89 c6             	mov    %rax,%rsi
  804460:	bf 00 00 00 00       	mov    $0x0,%edi
  804465:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  80446c:	00 00 00 
  80446f:	ff d0                	callq  *%rax
    err:
	return r;
  804471:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804474:	48 83 c4 38          	add    $0x38,%rsp
  804478:	5b                   	pop    %rbx
  804479:	5d                   	pop    %rbp
  80447a:	c3                   	retq   

000000000080447b <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80447b:	55                   	push   %rbp
  80447c:	48 89 e5             	mov    %rsp,%rbp
  80447f:	53                   	push   %rbx
  804480:	48 83 ec 28          	sub    $0x28,%rsp
  804484:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804488:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80448c:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804493:	00 00 00 
  804496:	48 8b 00             	mov    (%rax),%rax
  804499:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80449f:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8044a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044a6:	48 89 c7             	mov    %rax,%rdi
  8044a9:	48 b8 15 4c 80 00 00 	movabs $0x804c15,%rax
  8044b0:	00 00 00 
  8044b3:	ff d0                	callq  *%rax
  8044b5:	89 c3                	mov    %eax,%ebx
  8044b7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8044bb:	48 89 c7             	mov    %rax,%rdi
  8044be:	48 b8 15 4c 80 00 00 	movabs $0x804c15,%rax
  8044c5:	00 00 00 
  8044c8:	ff d0                	callq  *%rax
  8044ca:	39 c3                	cmp    %eax,%ebx
  8044cc:	0f 94 c0             	sete   %al
  8044cf:	0f b6 c0             	movzbl %al,%eax
  8044d2:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8044d5:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8044dc:	00 00 00 
  8044df:	48 8b 00             	mov    (%rax),%rax
  8044e2:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8044e8:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8044eb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8044ee:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8044f1:	75 05                	jne    8044f8 <_pipeisclosed+0x7d>
			return ret;
  8044f3:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8044f6:	eb 4f                	jmp    804547 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8044f8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8044fb:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8044fe:	74 42                	je     804542 <_pipeisclosed+0xc7>
  804500:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  804504:	75 3c                	jne    804542 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804506:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80450d:	00 00 00 
  804510:	48 8b 00             	mov    (%rax),%rax
  804513:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  804519:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80451c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80451f:	89 c6                	mov    %eax,%esi
  804521:	48 bf 85 55 80 00 00 	movabs $0x805585,%rdi
  804528:	00 00 00 
  80452b:	b8 00 00 00 00       	mov    $0x0,%eax
  804530:	49 b8 1d 0b 80 00 00 	movabs $0x800b1d,%r8
  804537:	00 00 00 
  80453a:	41 ff d0             	callq  *%r8
	}
  80453d:	e9 4a ff ff ff       	jmpq   80448c <_pipeisclosed+0x11>
  804542:	e9 45 ff ff ff       	jmpq   80448c <_pipeisclosed+0x11>
}
  804547:	48 83 c4 28          	add    $0x28,%rsp
  80454b:	5b                   	pop    %rbx
  80454c:	5d                   	pop    %rbp
  80454d:	c3                   	retq   

000000000080454e <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80454e:	55                   	push   %rbp
  80454f:	48 89 e5             	mov    %rsp,%rbp
  804552:	48 83 ec 30          	sub    $0x30,%rsp
  804556:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804559:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80455d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804560:	48 89 d6             	mov    %rdx,%rsi
  804563:	89 c7                	mov    %eax,%edi
  804565:	48 b8 ee 29 80 00 00 	movabs $0x8029ee,%rax
  80456c:	00 00 00 
  80456f:	ff d0                	callq  *%rax
  804571:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804574:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804578:	79 05                	jns    80457f <pipeisclosed+0x31>
		return r;
  80457a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80457d:	eb 31                	jmp    8045b0 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80457f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804583:	48 89 c7             	mov    %rax,%rdi
  804586:	48 b8 2b 29 80 00 00 	movabs $0x80292b,%rax
  80458d:	00 00 00 
  804590:	ff d0                	callq  *%rax
  804592:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804596:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80459a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80459e:	48 89 d6             	mov    %rdx,%rsi
  8045a1:	48 89 c7             	mov    %rax,%rdi
  8045a4:	48 b8 7b 44 80 00 00 	movabs $0x80447b,%rax
  8045ab:	00 00 00 
  8045ae:	ff d0                	callq  *%rax
}
  8045b0:	c9                   	leaveq 
  8045b1:	c3                   	retq   

00000000008045b2 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8045b2:	55                   	push   %rbp
  8045b3:	48 89 e5             	mov    %rsp,%rbp
  8045b6:	48 83 ec 40          	sub    $0x40,%rsp
  8045ba:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8045be:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8045c2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8045c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045ca:	48 89 c7             	mov    %rax,%rdi
  8045cd:	48 b8 2b 29 80 00 00 	movabs $0x80292b,%rax
  8045d4:	00 00 00 
  8045d7:	ff d0                	callq  *%rax
  8045d9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8045dd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8045e1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8045e5:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8045ec:	00 
  8045ed:	e9 92 00 00 00       	jmpq   804684 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8045f2:	eb 41                	jmp    804635 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8045f4:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8045f9:	74 09                	je     804604 <devpipe_read+0x52>
				return i;
  8045fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8045ff:	e9 92 00 00 00       	jmpq   804696 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804604:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804608:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80460c:	48 89 d6             	mov    %rdx,%rsi
  80460f:	48 89 c7             	mov    %rax,%rdi
  804612:	48 b8 7b 44 80 00 00 	movabs $0x80447b,%rax
  804619:	00 00 00 
  80461c:	ff d0                	callq  *%rax
  80461e:	85 c0                	test   %eax,%eax
  804620:	74 07                	je     804629 <devpipe_read+0x77>
				return 0;
  804622:	b8 00 00 00 00       	mov    $0x0,%eax
  804627:	eb 6d                	jmp    804696 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  804629:	48 b8 c3 1f 80 00 00 	movabs $0x801fc3,%rax
  804630:	00 00 00 
  804633:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  804635:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804639:	8b 10                	mov    (%rax),%edx
  80463b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80463f:	8b 40 04             	mov    0x4(%rax),%eax
  804642:	39 c2                	cmp    %eax,%edx
  804644:	74 ae                	je     8045f4 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804646:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80464a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80464e:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804652:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804656:	8b 00                	mov    (%rax),%eax
  804658:	99                   	cltd   
  804659:	c1 ea 1b             	shr    $0x1b,%edx
  80465c:	01 d0                	add    %edx,%eax
  80465e:	83 e0 1f             	and    $0x1f,%eax
  804661:	29 d0                	sub    %edx,%eax
  804663:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804667:	48 98                	cltq   
  804669:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80466e:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804670:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804674:	8b 00                	mov    (%rax),%eax
  804676:	8d 50 01             	lea    0x1(%rax),%edx
  804679:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80467d:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80467f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804684:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804688:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80468c:	0f 82 60 ff ff ff    	jb     8045f2 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804692:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804696:	c9                   	leaveq 
  804697:	c3                   	retq   

0000000000804698 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804698:	55                   	push   %rbp
  804699:	48 89 e5             	mov    %rsp,%rbp
  80469c:	48 83 ec 40          	sub    $0x40,%rsp
  8046a0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8046a4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8046a8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8046ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046b0:	48 89 c7             	mov    %rax,%rdi
  8046b3:	48 b8 2b 29 80 00 00 	movabs $0x80292b,%rax
  8046ba:	00 00 00 
  8046bd:	ff d0                	callq  *%rax
  8046bf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8046c3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8046c7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8046cb:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8046d2:	00 
  8046d3:	e9 8e 00 00 00       	jmpq   804766 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8046d8:	eb 31                	jmp    80470b <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8046da:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8046de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046e2:	48 89 d6             	mov    %rdx,%rsi
  8046e5:	48 89 c7             	mov    %rax,%rdi
  8046e8:	48 b8 7b 44 80 00 00 	movabs $0x80447b,%rax
  8046ef:	00 00 00 
  8046f2:	ff d0                	callq  *%rax
  8046f4:	85 c0                	test   %eax,%eax
  8046f6:	74 07                	je     8046ff <devpipe_write+0x67>
				return 0;
  8046f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8046fd:	eb 79                	jmp    804778 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8046ff:	48 b8 c3 1f 80 00 00 	movabs $0x801fc3,%rax
  804706:	00 00 00 
  804709:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80470b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80470f:	8b 40 04             	mov    0x4(%rax),%eax
  804712:	48 63 d0             	movslq %eax,%rdx
  804715:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804719:	8b 00                	mov    (%rax),%eax
  80471b:	48 98                	cltq   
  80471d:	48 83 c0 20          	add    $0x20,%rax
  804721:	48 39 c2             	cmp    %rax,%rdx
  804724:	73 b4                	jae    8046da <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804726:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80472a:	8b 40 04             	mov    0x4(%rax),%eax
  80472d:	99                   	cltd   
  80472e:	c1 ea 1b             	shr    $0x1b,%edx
  804731:	01 d0                	add    %edx,%eax
  804733:	83 e0 1f             	and    $0x1f,%eax
  804736:	29 d0                	sub    %edx,%eax
  804738:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80473c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804740:	48 01 ca             	add    %rcx,%rdx
  804743:	0f b6 0a             	movzbl (%rdx),%ecx
  804746:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80474a:	48 98                	cltq   
  80474c:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804750:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804754:	8b 40 04             	mov    0x4(%rax),%eax
  804757:	8d 50 01             	lea    0x1(%rax),%edx
  80475a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80475e:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804761:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804766:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80476a:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80476e:	0f 82 64 ff ff ff    	jb     8046d8 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804774:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804778:	c9                   	leaveq 
  804779:	c3                   	retq   

000000000080477a <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80477a:	55                   	push   %rbp
  80477b:	48 89 e5             	mov    %rsp,%rbp
  80477e:	48 83 ec 20          	sub    $0x20,%rsp
  804782:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804786:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80478a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80478e:	48 89 c7             	mov    %rax,%rdi
  804791:	48 b8 2b 29 80 00 00 	movabs $0x80292b,%rax
  804798:	00 00 00 
  80479b:	ff d0                	callq  *%rax
  80479d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8047a1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8047a5:	48 be 98 55 80 00 00 	movabs $0x805598,%rsi
  8047ac:	00 00 00 
  8047af:	48 89 c7             	mov    %rax,%rdi
  8047b2:	48 b8 d2 16 80 00 00 	movabs $0x8016d2,%rax
  8047b9:	00 00 00 
  8047bc:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8047be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8047c2:	8b 50 04             	mov    0x4(%rax),%edx
  8047c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8047c9:	8b 00                	mov    (%rax),%eax
  8047cb:	29 c2                	sub    %eax,%edx
  8047cd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8047d1:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8047d7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8047db:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8047e2:	00 00 00 
	stat->st_dev = &devpipe;
  8047e5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8047e9:	48 b9 a0 70 80 00 00 	movabs $0x8070a0,%rcx
  8047f0:	00 00 00 
  8047f3:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8047fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8047ff:	c9                   	leaveq 
  804800:	c3                   	retq   

0000000000804801 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804801:	55                   	push   %rbp
  804802:	48 89 e5             	mov    %rsp,%rbp
  804805:	48 83 ec 10          	sub    $0x10,%rsp
  804809:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80480d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804811:	48 89 c6             	mov    %rax,%rsi
  804814:	bf 00 00 00 00       	mov    $0x0,%edi
  804819:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  804820:	00 00 00 
  804823:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  804825:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804829:	48 89 c7             	mov    %rax,%rdi
  80482c:	48 b8 2b 29 80 00 00 	movabs $0x80292b,%rax
  804833:	00 00 00 
  804836:	ff d0                	callq  *%rax
  804838:	48 89 c6             	mov    %rax,%rsi
  80483b:	bf 00 00 00 00       	mov    $0x0,%edi
  804840:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  804847:	00 00 00 
  80484a:	ff d0                	callq  *%rax
}
  80484c:	c9                   	leaveq 
  80484d:	c3                   	retq   

000000000080484e <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80484e:	55                   	push   %rbp
  80484f:	48 89 e5             	mov    %rsp,%rbp
  804852:	48 83 ec 20          	sub    $0x20,%rsp
  804856:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  804859:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80485d:	75 35                	jne    804894 <wait+0x46>
  80485f:	48 b9 9f 55 80 00 00 	movabs $0x80559f,%rcx
  804866:	00 00 00 
  804869:	48 ba aa 55 80 00 00 	movabs $0x8055aa,%rdx
  804870:	00 00 00 
  804873:	be 09 00 00 00       	mov    $0x9,%esi
  804878:	48 bf bf 55 80 00 00 	movabs $0x8055bf,%rdi
  80487f:	00 00 00 
  804882:	b8 00 00 00 00       	mov    $0x0,%eax
  804887:	49 b8 e4 08 80 00 00 	movabs $0x8008e4,%r8
  80488e:	00 00 00 
  804891:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  804894:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804897:	25 ff 03 00 00       	and    $0x3ff,%eax
  80489c:	48 63 d0             	movslq %eax,%rdx
  80489f:	48 89 d0             	mov    %rdx,%rax
  8048a2:	48 c1 e0 03          	shl    $0x3,%rax
  8048a6:	48 01 d0             	add    %rdx,%rax
  8048a9:	48 c1 e0 05          	shl    $0x5,%rax
  8048ad:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8048b4:	00 00 00 
  8048b7:	48 01 d0             	add    %rdx,%rax
  8048ba:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE){
  8048be:	eb 0c                	jmp    8048cc <wait+0x7e>
	//cprintf("envid is [%d]",envid);
		sys_yield();
  8048c0:	48 b8 c3 1f 80 00 00 	movabs $0x801fc3,%rax
  8048c7:	00 00 00 
  8048ca:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE){
  8048cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048d0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8048d6:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8048d9:	75 0e                	jne    8048e9 <wait+0x9b>
  8048db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048df:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8048e5:	85 c0                	test   %eax,%eax
  8048e7:	75 d7                	jne    8048c0 <wait+0x72>
	//cprintf("envid is [%d]",envid);
		sys_yield();
	}
}
  8048e9:	c9                   	leaveq 
  8048ea:	c3                   	retq   

00000000008048eb <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8048eb:	55                   	push   %rbp
  8048ec:	48 89 e5             	mov    %rsp,%rbp
  8048ef:	48 83 ec 10          	sub    $0x10,%rsp
  8048f3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  8048f7:	48 b8 08 a0 80 00 00 	movabs $0x80a008,%rax
  8048fe:	00 00 00 
  804901:	48 8b 00             	mov    (%rax),%rax
  804904:	48 85 c0             	test   %rax,%rax
  804907:	0f 85 84 00 00 00    	jne    804991 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  80490d:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804914:	00 00 00 
  804917:	48 8b 00             	mov    (%rax),%rax
  80491a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804920:	ba 07 00 00 00       	mov    $0x7,%edx
  804925:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80492a:	89 c7                	mov    %eax,%edi
  80492c:	48 b8 01 20 80 00 00 	movabs $0x802001,%rax
  804933:	00 00 00 
  804936:	ff d0                	callq  *%rax
  804938:	85 c0                	test   %eax,%eax
  80493a:	79 2a                	jns    804966 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  80493c:	48 ba d0 55 80 00 00 	movabs $0x8055d0,%rdx
  804943:	00 00 00 
  804946:	be 23 00 00 00       	mov    $0x23,%esi
  80494b:	48 bf f7 55 80 00 00 	movabs $0x8055f7,%rdi
  804952:	00 00 00 
  804955:	b8 00 00 00 00       	mov    $0x0,%eax
  80495a:	48 b9 e4 08 80 00 00 	movabs $0x8008e4,%rcx
  804961:	00 00 00 
  804964:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  804966:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80496d:	00 00 00 
  804970:	48 8b 00             	mov    (%rax),%rax
  804973:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804979:	48 be a4 49 80 00 00 	movabs $0x8049a4,%rsi
  804980:	00 00 00 
  804983:	89 c7                	mov    %eax,%edi
  804985:	48 b8 8b 21 80 00 00 	movabs $0x80218b,%rax
  80498c:	00 00 00 
  80498f:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  804991:	48 b8 08 a0 80 00 00 	movabs $0x80a008,%rax
  804998:	00 00 00 
  80499b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80499f:	48 89 10             	mov    %rdx,(%rax)
}
  8049a2:	c9                   	leaveq 
  8049a3:	c3                   	retq   

00000000008049a4 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  8049a4:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  8049a7:	48 a1 08 a0 80 00 00 	movabs 0x80a008,%rax
  8049ae:	00 00 00 
	call *%rax
  8049b1:	ff d0                	callq  *%rax


	/*This code is to be removed*/

	// LAB 4: Your code here.
	movq 136(%rsp), %rbx  //Load RIP 
  8049b3:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8049ba:	00 
	movq 152(%rsp), %rcx  //Load RSP
  8049bb:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  8049c2:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  8049c3:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  8049c7:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  8049ca:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  8049d1:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  8049d2:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  8049d6:	4c 8b 3c 24          	mov    (%rsp),%r15
  8049da:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8049df:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8049e4:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8049e9:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8049ee:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8049f3:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8049f8:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8049fd:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804a02:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804a07:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804a0c:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804a11:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804a16:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804a1b:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804a20:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  804a24:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  804a28:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  804a29:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  804a2a:	c3                   	retq   

0000000000804a2b <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804a2b:	55                   	push   %rbp
  804a2c:	48 89 e5             	mov    %rsp,%rbp
  804a2f:	48 83 ec 30          	sub    $0x30,%rsp
  804a33:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804a37:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804a3b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  804a3f:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804a46:	00 00 00 
  804a49:	48 8b 00             	mov    (%rax),%rax
  804a4c:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  804a52:	85 c0                	test   %eax,%eax
  804a54:	75 3c                	jne    804a92 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  804a56:	48 b8 85 1f 80 00 00 	movabs $0x801f85,%rax
  804a5d:	00 00 00 
  804a60:	ff d0                	callq  *%rax
  804a62:	25 ff 03 00 00       	and    $0x3ff,%eax
  804a67:	48 63 d0             	movslq %eax,%rdx
  804a6a:	48 89 d0             	mov    %rdx,%rax
  804a6d:	48 c1 e0 03          	shl    $0x3,%rax
  804a71:	48 01 d0             	add    %rdx,%rax
  804a74:	48 c1 e0 05          	shl    $0x5,%rax
  804a78:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804a7f:	00 00 00 
  804a82:	48 01 c2             	add    %rax,%rdx
  804a85:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804a8c:	00 00 00 
  804a8f:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  804a92:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804a97:	75 0e                	jne    804aa7 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  804a99:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804aa0:	00 00 00 
  804aa3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  804aa7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804aab:	48 89 c7             	mov    %rax,%rdi
  804aae:	48 b8 2a 22 80 00 00 	movabs $0x80222a,%rax
  804ab5:	00 00 00 
  804ab8:	ff d0                	callq  *%rax
  804aba:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  804abd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804ac1:	79 19                	jns    804adc <ipc_recv+0xb1>
		*from_env_store = 0;
  804ac3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804ac7:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  804acd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804ad1:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  804ad7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ada:	eb 53                	jmp    804b2f <ipc_recv+0x104>
	}
	if(from_env_store)
  804adc:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804ae1:	74 19                	je     804afc <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  804ae3:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804aea:	00 00 00 
  804aed:	48 8b 00             	mov    (%rax),%rax
  804af0:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804af6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804afa:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  804afc:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804b01:	74 19                	je     804b1c <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  804b03:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804b0a:	00 00 00 
  804b0d:	48 8b 00             	mov    (%rax),%rax
  804b10:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804b16:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804b1a:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  804b1c:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804b23:	00 00 00 
  804b26:	48 8b 00             	mov    (%rax),%rax
  804b29:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  804b2f:	c9                   	leaveq 
  804b30:	c3                   	retq   

0000000000804b31 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804b31:	55                   	push   %rbp
  804b32:	48 89 e5             	mov    %rsp,%rbp
  804b35:	48 83 ec 30          	sub    $0x30,%rsp
  804b39:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804b3c:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804b3f:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804b43:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  804b46:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804b4b:	75 0e                	jne    804b5b <ipc_send+0x2a>
		pg = (void*)UTOP;
  804b4d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804b54:	00 00 00 
  804b57:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  804b5b:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804b5e:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804b61:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804b65:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804b68:	89 c7                	mov    %eax,%edi
  804b6a:	48 b8 d5 21 80 00 00 	movabs $0x8021d5,%rax
  804b71:	00 00 00 
  804b74:	ff d0                	callq  *%rax
  804b76:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  804b79:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804b7d:	75 0c                	jne    804b8b <ipc_send+0x5a>
			sys_yield();
  804b7f:	48 b8 c3 1f 80 00 00 	movabs $0x801fc3,%rax
  804b86:	00 00 00 
  804b89:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  804b8b:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804b8f:	74 ca                	je     804b5b <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  804b91:	c9                   	leaveq 
  804b92:	c3                   	retq   

0000000000804b93 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804b93:	55                   	push   %rbp
  804b94:	48 89 e5             	mov    %rsp,%rbp
  804b97:	48 83 ec 14          	sub    $0x14,%rsp
  804b9b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  804b9e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804ba5:	eb 5e                	jmp    804c05 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  804ba7:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804bae:	00 00 00 
  804bb1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804bb4:	48 63 d0             	movslq %eax,%rdx
  804bb7:	48 89 d0             	mov    %rdx,%rax
  804bba:	48 c1 e0 03          	shl    $0x3,%rax
  804bbe:	48 01 d0             	add    %rdx,%rax
  804bc1:	48 c1 e0 05          	shl    $0x5,%rax
  804bc5:	48 01 c8             	add    %rcx,%rax
  804bc8:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804bce:	8b 00                	mov    (%rax),%eax
  804bd0:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804bd3:	75 2c                	jne    804c01 <ipc_find_env+0x6e>
			return envs[i].env_id;
  804bd5:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804bdc:	00 00 00 
  804bdf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804be2:	48 63 d0             	movslq %eax,%rdx
  804be5:	48 89 d0             	mov    %rdx,%rax
  804be8:	48 c1 e0 03          	shl    $0x3,%rax
  804bec:	48 01 d0             	add    %rdx,%rax
  804bef:	48 c1 e0 05          	shl    $0x5,%rax
  804bf3:	48 01 c8             	add    %rcx,%rax
  804bf6:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804bfc:	8b 40 08             	mov    0x8(%rax),%eax
  804bff:	eb 12                	jmp    804c13 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  804c01:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804c05:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804c0c:	7e 99                	jle    804ba7 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  804c0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804c13:	c9                   	leaveq 
  804c14:	c3                   	retq   

0000000000804c15 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804c15:	55                   	push   %rbp
  804c16:	48 89 e5             	mov    %rsp,%rbp
  804c19:	48 83 ec 18          	sub    $0x18,%rsp
  804c1d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804c21:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804c25:	48 c1 e8 15          	shr    $0x15,%rax
  804c29:	48 89 c2             	mov    %rax,%rdx
  804c2c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804c33:	01 00 00 
  804c36:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804c3a:	83 e0 01             	and    $0x1,%eax
  804c3d:	48 85 c0             	test   %rax,%rax
  804c40:	75 07                	jne    804c49 <pageref+0x34>
		return 0;
  804c42:	b8 00 00 00 00       	mov    $0x0,%eax
  804c47:	eb 53                	jmp    804c9c <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804c49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804c4d:	48 c1 e8 0c          	shr    $0xc,%rax
  804c51:	48 89 c2             	mov    %rax,%rdx
  804c54:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804c5b:	01 00 00 
  804c5e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804c62:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804c66:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804c6a:	83 e0 01             	and    $0x1,%eax
  804c6d:	48 85 c0             	test   %rax,%rax
  804c70:	75 07                	jne    804c79 <pageref+0x64>
		return 0;
  804c72:	b8 00 00 00 00       	mov    $0x0,%eax
  804c77:	eb 23                	jmp    804c9c <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804c79:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804c7d:	48 c1 e8 0c          	shr    $0xc,%rax
  804c81:	48 89 c2             	mov    %rax,%rdx
  804c84:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804c8b:	00 00 00 
  804c8e:	48 c1 e2 04          	shl    $0x4,%rdx
  804c92:	48 01 d0             	add    %rdx,%rax
  804c95:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804c99:	0f b7 c0             	movzwl %ax,%eax
}
  804c9c:	c9                   	leaveq 
  804c9d:	c3                   	retq   
