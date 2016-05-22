
obj/user/ls.debug:     file format elf64-x86-64


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
  80003c:	e8 da 04 00 00       	callq  80051b <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <ls>:
void lsdir(const char*, const char*);
void ls1(const char*, bool, off_t, const char*);

void
ls(const char *path, const char *prefix)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80004e:	48 89 bd 58 ff ff ff 	mov    %rdi,-0xa8(%rbp)
  800055:	48 89 b5 50 ff ff ff 	mov    %rsi,-0xb0(%rbp)
	int r;
	struct Stat st;

	if ((r = stat(path, &st)) < 0)
  80005c:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  800063:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80006a:	48 89 d6             	mov    %rdx,%rsi
  80006d:	48 89 c7             	mov    %rax,%rdi
  800070:	48 b8 38 2b 80 00 00 	movabs $0x802b38,%rax
  800077:	00 00 00 
  80007a:	ff d0                	callq  *%rax
  80007c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80007f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800083:	79 3b                	jns    8000c0 <ls+0x7d>
		panic("stat %s: %e", path, r);
  800085:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800088:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80008f:	41 89 d0             	mov    %edx,%r8d
  800092:	48 89 c1             	mov    %rax,%rcx
  800095:	48 ba 60 3e 80 00 00 	movabs $0x803e60,%rdx
  80009c:	00 00 00 
  80009f:	be 0f 00 00 00       	mov    $0xf,%esi
  8000a4:	48 bf 6c 3e 80 00 00 	movabs $0x803e6c,%rdi
  8000ab:	00 00 00 
  8000ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b3:	49 b9 c9 05 80 00 00 	movabs $0x8005c9,%r9
  8000ba:	00 00 00 
  8000bd:	41 ff d1             	callq  *%r9
	if (st.st_isdir && !flag['d'])
  8000c0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8000c3:	85 c0                	test   %eax,%eax
  8000c5:	74 36                	je     8000fd <ls+0xba>
  8000c7:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8000ce:	00 00 00 
  8000d1:	8b 80 90 01 00 00    	mov    0x190(%rax),%eax
  8000d7:	85 c0                	test   %eax,%eax
  8000d9:	75 22                	jne    8000fd <ls+0xba>
		lsdir(path, prefix);
  8000db:	48 8b 95 50 ff ff ff 	mov    -0xb0(%rbp),%rdx
  8000e2:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8000e9:	48 89 d6             	mov    %rdx,%rsi
  8000ec:	48 89 c7             	mov    %rax,%rdi
  8000ef:	48 b8 27 01 80 00 00 	movabs $0x800127,%rax
  8000f6:	00 00 00 
  8000f9:	ff d0                	callq  *%rax
  8000fb:	eb 28                	jmp    800125 <ls+0xe2>
	else
		ls1(0, st.st_isdir, st.st_size, path);
  8000fd:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800100:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800103:	85 c0                	test   %eax,%eax
  800105:	0f 95 c0             	setne  %al
  800108:	0f b6 c0             	movzbl %al,%eax
  80010b:	48 8b 8d 58 ff ff ff 	mov    -0xa8(%rbp),%rcx
  800112:	89 c6                	mov    %eax,%esi
  800114:	bf 00 00 00 00       	mov    $0x0,%edi
  800119:	48 b8 88 02 80 00 00 	movabs $0x800288,%rax
  800120:	00 00 00 
  800123:	ff d0                	callq  *%rax
}
  800125:	c9                   	leaveq 
  800126:	c3                   	retq   

0000000000800127 <lsdir>:

void
lsdir(const char *path, const char *prefix)
{
  800127:	55                   	push   %rbp
  800128:	48 89 e5             	mov    %rsp,%rbp
  80012b:	48 81 ec 20 01 00 00 	sub    $0x120,%rsp
  800132:	48 89 bd e8 fe ff ff 	mov    %rdi,-0x118(%rbp)
  800139:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
  800140:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  800147:	be 00 00 00 00       	mov    $0x0,%esi
  80014c:	48 89 c7             	mov    %rax,%rdi
  80014f:	48 b8 26 2c 80 00 00 	movabs $0x802c26,%rax
  800156:	00 00 00 
  800159:	ff d0                	callq  *%rax
  80015b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80015e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800162:	79 3b                	jns    80019f <lsdir+0x78>
		panic("open %s: %e", path, fd);
  800164:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800167:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  80016e:	41 89 d0             	mov    %edx,%r8d
  800171:	48 89 c1             	mov    %rax,%rcx
  800174:	48 ba 76 3e 80 00 00 	movabs $0x803e76,%rdx
  80017b:	00 00 00 
  80017e:	be 1d 00 00 00       	mov    $0x1d,%esi
  800183:	48 bf 6c 3e 80 00 00 	movabs $0x803e6c,%rdi
  80018a:	00 00 00 
  80018d:	b8 00 00 00 00       	mov    $0x0,%eax
  800192:	49 b9 c9 05 80 00 00 	movabs $0x8005c9,%r9
  800199:	00 00 00 
  80019c:	41 ff d1             	callq  *%r9
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  80019f:	eb 3d                	jmp    8001de <lsdir+0xb7>
		if (f.f_name[0])
  8001a1:	0f b6 85 f0 fe ff ff 	movzbl -0x110(%rbp),%eax
  8001a8:	84 c0                	test   %al,%al
  8001aa:	74 32                	je     8001de <lsdir+0xb7>
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
  8001ac:	8b 95 70 ff ff ff    	mov    -0x90(%rbp),%edx
  8001b2:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  8001b8:	83 f8 01             	cmp    $0x1,%eax
  8001bb:	0f 94 c0             	sete   %al
  8001be:	0f b6 f0             	movzbl %al,%esi
  8001c1:	48 8d 8d f0 fe ff ff 	lea    -0x110(%rbp),%rcx
  8001c8:	48 8b 85 e0 fe ff ff 	mov    -0x120(%rbp),%rax
  8001cf:	48 89 c7             	mov    %rax,%rdi
  8001d2:	48 b8 88 02 80 00 00 	movabs $0x800288,%rax
  8001d9:	00 00 00 
  8001dc:	ff d0                	callq  *%rax
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
		panic("open %s: %e", path, fd);
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  8001de:	48 8d 8d f0 fe ff ff 	lea    -0x110(%rbp),%rcx
  8001e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001e8:	ba 00 01 00 00       	mov    $0x100,%edx
  8001ed:	48 89 ce             	mov    %rcx,%rsi
  8001f0:	89 c7                	mov    %eax,%edi
  8001f2:	48 b8 25 28 80 00 00 	movabs $0x802825,%rax
  8001f9:	00 00 00 
  8001fc:	ff d0                	callq  *%rax
  8001fe:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800201:	81 7d f8 00 01 00 00 	cmpl   $0x100,-0x8(%rbp)
  800208:	74 97                	je     8001a1 <lsdir+0x7a>
		if (f.f_name[0])
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
	if (n > 0)
  80020a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80020e:	7e 35                	jle    800245 <lsdir+0x11e>
		panic("short read in directory %s", path);
  800210:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  800217:	48 89 c1             	mov    %rax,%rcx
  80021a:	48 ba 82 3e 80 00 00 	movabs $0x803e82,%rdx
  800221:	00 00 00 
  800224:	be 22 00 00 00       	mov    $0x22,%esi
  800229:	48 bf 6c 3e 80 00 00 	movabs $0x803e6c,%rdi
  800230:	00 00 00 
  800233:	b8 00 00 00 00       	mov    $0x0,%eax
  800238:	49 b8 c9 05 80 00 00 	movabs $0x8005c9,%r8
  80023f:	00 00 00 
  800242:	41 ff d0             	callq  *%r8
	if (n < 0)
  800245:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800249:	79 3b                	jns    800286 <lsdir+0x15f>
		panic("error reading directory %s: %e", path, n);
  80024b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80024e:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  800255:	41 89 d0             	mov    %edx,%r8d
  800258:	48 89 c1             	mov    %rax,%rcx
  80025b:	48 ba a0 3e 80 00 00 	movabs $0x803ea0,%rdx
  800262:	00 00 00 
  800265:	be 24 00 00 00       	mov    $0x24,%esi
  80026a:	48 bf 6c 3e 80 00 00 	movabs $0x803e6c,%rdi
  800271:	00 00 00 
  800274:	b8 00 00 00 00       	mov    $0x0,%eax
  800279:	49 b9 c9 05 80 00 00 	movabs $0x8005c9,%r9
  800280:	00 00 00 
  800283:	41 ff d1             	callq  *%r9
}
  800286:	c9                   	leaveq 
  800287:	c3                   	retq   

0000000000800288 <ls1>:

void
ls1(const char *prefix, bool isdir, off_t size, const char *name)
{
  800288:	55                   	push   %rbp
  800289:	48 89 e5             	mov    %rsp,%rbp
  80028c:	48 83 ec 30          	sub    $0x30,%rsp
  800290:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800294:	89 f0                	mov    %esi,%eax
  800296:	89 55 e0             	mov    %edx,-0x20(%rbp)
  800299:	48 89 4d d8          	mov    %rcx,-0x28(%rbp)
  80029d:	88 45 e4             	mov    %al,-0x1c(%rbp)
	const char *sep;

	if(flag['l'])
  8002a0:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8002a7:	00 00 00 
  8002aa:	8b 80 b0 01 00 00    	mov    0x1b0(%rax),%eax
  8002b0:	85 c0                	test   %eax,%eax
  8002b2:	74 34                	je     8002e8 <ls1+0x60>
		printf("%11d %c ", size, isdir ? 'd' : '-');
  8002b4:	80 7d e4 00          	cmpb   $0x0,-0x1c(%rbp)
  8002b8:	74 07                	je     8002c1 <ls1+0x39>
  8002ba:	b8 64 00 00 00       	mov    $0x64,%eax
  8002bf:	eb 05                	jmp    8002c6 <ls1+0x3e>
  8002c1:	b8 2d 00 00 00       	mov    $0x2d,%eax
  8002c6:	8b 4d e0             	mov    -0x20(%rbp),%ecx
  8002c9:	89 c2                	mov    %eax,%edx
  8002cb:	89 ce                	mov    %ecx,%esi
  8002cd:	48 bf bf 3e 80 00 00 	movabs $0x803ebf,%rdi
  8002d4:	00 00 00 
  8002d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8002dc:	48 b9 af 32 80 00 00 	movabs $0x8032af,%rcx
  8002e3:	00 00 00 
  8002e6:	ff d1                	callq  *%rcx
	if(prefix) {
  8002e8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8002ed:	74 76                	je     800365 <ls1+0xdd>
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  8002ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002f3:	0f b6 00             	movzbl (%rax),%eax
  8002f6:	84 c0                	test   %al,%al
  8002f8:	74 37                	je     800331 <ls1+0xa9>
  8002fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002fe:	48 89 c7             	mov    %rax,%rdi
  800301:	48 b8 4b 13 80 00 00 	movabs $0x80134b,%rax
  800308:	00 00 00 
  80030b:	ff d0                	callq  *%rax
  80030d:	48 98                	cltq   
  80030f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800313:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800317:	48 01 d0             	add    %rdx,%rax
  80031a:	0f b6 00             	movzbl (%rax),%eax
  80031d:	3c 2f                	cmp    $0x2f,%al
  80031f:	74 10                	je     800331 <ls1+0xa9>
			sep = "/";
  800321:	48 b8 c8 3e 80 00 00 	movabs $0x803ec8,%rax
  800328:	00 00 00 
  80032b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80032f:	eb 0e                	jmp    80033f <ls1+0xb7>
		else
			sep = "";
  800331:	48 b8 ca 3e 80 00 00 	movabs $0x803eca,%rax
  800338:	00 00 00 
  80033b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		printf("%s%s", prefix, sep);
  80033f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800343:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800347:	48 89 c6             	mov    %rax,%rsi
  80034a:	48 bf cb 3e 80 00 00 	movabs $0x803ecb,%rdi
  800351:	00 00 00 
  800354:	b8 00 00 00 00       	mov    $0x0,%eax
  800359:	48 b9 af 32 80 00 00 	movabs $0x8032af,%rcx
  800360:	00 00 00 
  800363:	ff d1                	callq  *%rcx
	}
	printf("%s", name);
  800365:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800369:	48 89 c6             	mov    %rax,%rsi
  80036c:	48 bf d0 3e 80 00 00 	movabs $0x803ed0,%rdi
  800373:	00 00 00 
  800376:	b8 00 00 00 00       	mov    $0x0,%eax
  80037b:	48 ba af 32 80 00 00 	movabs $0x8032af,%rdx
  800382:	00 00 00 
  800385:	ff d2                	callq  *%rdx
	if(flag['F'] && isdir)
  800387:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80038e:	00 00 00 
  800391:	8b 80 18 01 00 00    	mov    0x118(%rax),%eax
  800397:	85 c0                	test   %eax,%eax
  800399:	74 21                	je     8003bc <ls1+0x134>
  80039b:	80 7d e4 00          	cmpb   $0x0,-0x1c(%rbp)
  80039f:	74 1b                	je     8003bc <ls1+0x134>
		printf("/");
  8003a1:	48 bf c8 3e 80 00 00 	movabs $0x803ec8,%rdi
  8003a8:	00 00 00 
  8003ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8003b0:	48 ba af 32 80 00 00 	movabs $0x8032af,%rdx
  8003b7:	00 00 00 
  8003ba:	ff d2                	callq  *%rdx
	printf("\n");
  8003bc:	48 bf d3 3e 80 00 00 	movabs $0x803ed3,%rdi
  8003c3:	00 00 00 
  8003c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8003cb:	48 ba af 32 80 00 00 	movabs $0x8032af,%rdx
  8003d2:	00 00 00 
  8003d5:	ff d2                	callq  *%rdx
}
  8003d7:	c9                   	leaveq 
  8003d8:	c3                   	retq   

00000000008003d9 <usage>:

void
usage(void)
{
  8003d9:	55                   	push   %rbp
  8003da:	48 89 e5             	mov    %rsp,%rbp
	printf("usage: ls [-dFl] [file...]\n");
  8003dd:	48 bf d5 3e 80 00 00 	movabs $0x803ed5,%rdi
  8003e4:	00 00 00 
  8003e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ec:	48 ba af 32 80 00 00 	movabs $0x8032af,%rdx
  8003f3:	00 00 00 
  8003f6:	ff d2                	callq  *%rdx
	exit();
  8003f8:	48 b8 a6 05 80 00 00 	movabs $0x8005a6,%rax
  8003ff:	00 00 00 
  800402:	ff d0                	callq  *%rax
}
  800404:	5d                   	pop    %rbp
  800405:	c3                   	retq   

0000000000800406 <umain>:

void
umain(int argc, char **argv)
{
  800406:	55                   	push   %rbp
  800407:	48 89 e5             	mov    %rsp,%rbp
  80040a:	48 83 ec 40          	sub    $0x40,%rsp
  80040e:	89 7d cc             	mov    %edi,-0x34(%rbp)
  800411:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800415:	48 8d 55 d0          	lea    -0x30(%rbp),%rdx
  800419:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80041d:	48 8d 45 cc          	lea    -0x34(%rbp),%rax
  800421:	48 89 ce             	mov    %rcx,%rsi
  800424:	48 89 c7             	mov    %rax,%rdi
  800427:	48 b8 53 1f 80 00 00 	movabs $0x801f53,%rax
  80042e:	00 00 00 
  800431:	ff d0                	callq  *%rax
	while ((i = argnext(&args)) >= 0)
  800433:	eb 49                	jmp    80047e <umain+0x78>
		switch (i) {
  800435:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800438:	83 f8 64             	cmp    $0x64,%eax
  80043b:	74 0a                	je     800447 <umain+0x41>
  80043d:	83 f8 6c             	cmp    $0x6c,%eax
  800440:	74 05                	je     800447 <umain+0x41>
  800442:	83 f8 46             	cmp    $0x46,%eax
  800445:	75 2b                	jne    800472 <umain+0x6c>
		case 'd':
		case 'F':
		case 'l':
			flag[i]++;
  800447:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80044e:	00 00 00 
  800451:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800454:	48 63 d2             	movslq %edx,%rdx
  800457:	8b 04 90             	mov    (%rax,%rdx,4),%eax
  80045a:	8d 48 01             	lea    0x1(%rax),%ecx
  80045d:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  800464:	00 00 00 
  800467:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80046a:	48 63 d2             	movslq %edx,%rdx
  80046d:	89 0c 90             	mov    %ecx,(%rax,%rdx,4)
			break;
  800470:	eb 0c                	jmp    80047e <umain+0x78>
		default:
			usage();
  800472:	48 b8 d9 03 80 00 00 	movabs $0x8003d9,%rax
  800479:	00 00 00 
  80047c:	ff d0                	callq  *%rax
{
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  80047e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800482:	48 89 c7             	mov    %rax,%rdi
  800485:	48 b8 b7 1f 80 00 00 	movabs $0x801fb7,%rax
  80048c:	00 00 00 
  80048f:	ff d0                	callq  *%rax
  800491:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800494:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800498:	79 9b                	jns    800435 <umain+0x2f>
			break;
		default:
			usage();
		}

	if (argc == 1)
  80049a:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80049d:	83 f8 01             	cmp    $0x1,%eax
  8004a0:	75 22                	jne    8004c4 <umain+0xbe>
		ls("/", "");
  8004a2:	48 be ca 3e 80 00 00 	movabs $0x803eca,%rsi
  8004a9:	00 00 00 
  8004ac:	48 bf c8 3e 80 00 00 	movabs $0x803ec8,%rdi
  8004b3:	00 00 00 
  8004b6:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8004bd:	00 00 00 
  8004c0:	ff d0                	callq  *%rax
  8004c2:	eb 55                	jmp    800519 <umain+0x113>
	else {
		for (i = 1; i < argc; i++)
  8004c4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  8004cb:	eb 44                	jmp    800511 <umain+0x10b>
			ls(argv[i], argv[i]);
  8004cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004d0:	48 98                	cltq   
  8004d2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8004d9:	00 
  8004da:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004de:	48 01 d0             	add    %rdx,%rax
  8004e1:	48 8b 10             	mov    (%rax),%rdx
  8004e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004e7:	48 98                	cltq   
  8004e9:	48 8d 0c c5 00 00 00 	lea    0x0(,%rax,8),%rcx
  8004f0:	00 
  8004f1:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004f5:	48 01 c8             	add    %rcx,%rax
  8004f8:	48 8b 00             	mov    (%rax),%rax
  8004fb:	48 89 d6             	mov    %rdx,%rsi
  8004fe:	48 89 c7             	mov    %rax,%rdi
  800501:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800508:	00 00 00 
  80050b:	ff d0                	callq  *%rax
		}

	if (argc == 1)
		ls("/", "");
	else {
		for (i = 1; i < argc; i++)
  80050d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800511:	8b 45 cc             	mov    -0x34(%rbp),%eax
  800514:	39 45 fc             	cmp    %eax,-0x4(%rbp)
  800517:	7c b4                	jl     8004cd <umain+0xc7>
			ls(argv[i], argv[i]);
	}
}
  800519:	c9                   	leaveq 
  80051a:	c3                   	retq   

000000000080051b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80051b:	55                   	push   %rbp
  80051c:	48 89 e5             	mov    %rsp,%rbp
  80051f:	48 83 ec 10          	sub    $0x10,%rsp
  800523:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800526:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80052a:	48 b8 6a 1c 80 00 00 	movabs $0x801c6a,%rax
  800531:	00 00 00 
  800534:	ff d0                	callq  *%rax
  800536:	25 ff 03 00 00       	and    $0x3ff,%eax
  80053b:	48 63 d0             	movslq %eax,%rdx
  80053e:	48 89 d0             	mov    %rdx,%rax
  800541:	48 c1 e0 03          	shl    $0x3,%rax
  800545:	48 01 d0             	add    %rdx,%rax
  800548:	48 c1 e0 05          	shl    $0x5,%rax
  80054c:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800553:	00 00 00 
  800556:	48 01 c2             	add    %rax,%rdx
  800559:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  800560:	00 00 00 
  800563:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800566:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80056a:	7e 14                	jle    800580 <libmain+0x65>
		binaryname = argv[0];
  80056c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800570:	48 8b 10             	mov    (%rax),%rdx
  800573:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80057a:	00 00 00 
  80057d:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800580:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800584:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800587:	48 89 d6             	mov    %rdx,%rsi
  80058a:	89 c7                	mov    %eax,%edi
  80058c:	48 b8 06 04 80 00 00 	movabs $0x800406,%rax
  800593:	00 00 00 
  800596:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  800598:	48 b8 a6 05 80 00 00 	movabs $0x8005a6,%rax
  80059f:	00 00 00 
  8005a2:	ff d0                	callq  *%rax
}
  8005a4:	c9                   	leaveq 
  8005a5:	c3                   	retq   

00000000008005a6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8005a6:	55                   	push   %rbp
  8005a7:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8005aa:	48 b8 79 25 80 00 00 	movabs $0x802579,%rax
  8005b1:	00 00 00 
  8005b4:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8005b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8005bb:	48 b8 26 1c 80 00 00 	movabs $0x801c26,%rax
  8005c2:	00 00 00 
  8005c5:	ff d0                	callq  *%rax

}
  8005c7:	5d                   	pop    %rbp
  8005c8:	c3                   	retq   

00000000008005c9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8005c9:	55                   	push   %rbp
  8005ca:	48 89 e5             	mov    %rsp,%rbp
  8005cd:	53                   	push   %rbx
  8005ce:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8005d5:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8005dc:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8005e2:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8005e9:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8005f0:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8005f7:	84 c0                	test   %al,%al
  8005f9:	74 23                	je     80061e <_panic+0x55>
  8005fb:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800602:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800606:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80060a:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80060e:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800612:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800616:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80061a:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80061e:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800625:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80062c:	00 00 00 
  80062f:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800636:	00 00 00 
  800639:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80063d:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800644:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80064b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800652:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800659:	00 00 00 
  80065c:	48 8b 18             	mov    (%rax),%rbx
  80065f:	48 b8 6a 1c 80 00 00 	movabs $0x801c6a,%rax
  800666:	00 00 00 
  800669:	ff d0                	callq  *%rax
  80066b:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800671:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800678:	41 89 c8             	mov    %ecx,%r8d
  80067b:	48 89 d1             	mov    %rdx,%rcx
  80067e:	48 89 da             	mov    %rbx,%rdx
  800681:	89 c6                	mov    %eax,%esi
  800683:	48 bf 00 3f 80 00 00 	movabs $0x803f00,%rdi
  80068a:	00 00 00 
  80068d:	b8 00 00 00 00       	mov    $0x0,%eax
  800692:	49 b9 02 08 80 00 00 	movabs $0x800802,%r9
  800699:	00 00 00 
  80069c:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80069f:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8006a6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8006ad:	48 89 d6             	mov    %rdx,%rsi
  8006b0:	48 89 c7             	mov    %rax,%rdi
  8006b3:	48 b8 56 07 80 00 00 	movabs $0x800756,%rax
  8006ba:	00 00 00 
  8006bd:	ff d0                	callq  *%rax
	cprintf("\n");
  8006bf:	48 bf 23 3f 80 00 00 	movabs $0x803f23,%rdi
  8006c6:	00 00 00 
  8006c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8006ce:	48 ba 02 08 80 00 00 	movabs $0x800802,%rdx
  8006d5:	00 00 00 
  8006d8:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8006da:	cc                   	int3   
  8006db:	eb fd                	jmp    8006da <_panic+0x111>

00000000008006dd <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8006dd:	55                   	push   %rbp
  8006de:	48 89 e5             	mov    %rsp,%rbp
  8006e1:	48 83 ec 10          	sub    $0x10,%rsp
  8006e5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8006e8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  8006ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006f0:	8b 00                	mov    (%rax),%eax
  8006f2:	8d 48 01             	lea    0x1(%rax),%ecx
  8006f5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006f9:	89 0a                	mov    %ecx,(%rdx)
  8006fb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8006fe:	89 d1                	mov    %edx,%ecx
  800700:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800704:	48 98                	cltq   
  800706:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  80070a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80070e:	8b 00                	mov    (%rax),%eax
  800710:	3d ff 00 00 00       	cmp    $0xff,%eax
  800715:	75 2c                	jne    800743 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  800717:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80071b:	8b 00                	mov    (%rax),%eax
  80071d:	48 98                	cltq   
  80071f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800723:	48 83 c2 08          	add    $0x8,%rdx
  800727:	48 89 c6             	mov    %rax,%rsi
  80072a:	48 89 d7             	mov    %rdx,%rdi
  80072d:	48 b8 9e 1b 80 00 00 	movabs $0x801b9e,%rax
  800734:	00 00 00 
  800737:	ff d0                	callq  *%rax
		b->idx = 0;
  800739:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80073d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800743:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800747:	8b 40 04             	mov    0x4(%rax),%eax
  80074a:	8d 50 01             	lea    0x1(%rax),%edx
  80074d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800751:	89 50 04             	mov    %edx,0x4(%rax)
}
  800754:	c9                   	leaveq 
  800755:	c3                   	retq   

0000000000800756 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800756:	55                   	push   %rbp
  800757:	48 89 e5             	mov    %rsp,%rbp
  80075a:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800761:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800768:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  80076f:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800776:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80077d:	48 8b 0a             	mov    (%rdx),%rcx
  800780:	48 89 08             	mov    %rcx,(%rax)
  800783:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800787:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80078b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80078f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  800793:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80079a:	00 00 00 
	b.cnt = 0;
  80079d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8007a4:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8007a7:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8007ae:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8007b5:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8007bc:	48 89 c6             	mov    %rax,%rsi
  8007bf:	48 bf dd 06 80 00 00 	movabs $0x8006dd,%rdi
  8007c6:	00 00 00 
  8007c9:	48 b8 b5 0b 80 00 00 	movabs $0x800bb5,%rax
  8007d0:	00 00 00 
  8007d3:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  8007d5:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8007db:	48 98                	cltq   
  8007dd:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8007e4:	48 83 c2 08          	add    $0x8,%rdx
  8007e8:	48 89 c6             	mov    %rax,%rsi
  8007eb:	48 89 d7             	mov    %rdx,%rdi
  8007ee:	48 b8 9e 1b 80 00 00 	movabs $0x801b9e,%rax
  8007f5:	00 00 00 
  8007f8:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  8007fa:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800800:	c9                   	leaveq 
  800801:	c3                   	retq   

0000000000800802 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800802:	55                   	push   %rbp
  800803:	48 89 e5             	mov    %rsp,%rbp
  800806:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80080d:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800814:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80081b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800822:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800829:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800830:	84 c0                	test   %al,%al
  800832:	74 20                	je     800854 <cprintf+0x52>
  800834:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800838:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80083c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800840:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800844:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800848:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80084c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800850:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800854:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  80085b:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800862:	00 00 00 
  800865:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80086c:	00 00 00 
  80086f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800873:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80087a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800881:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800888:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80088f:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800896:	48 8b 0a             	mov    (%rdx),%rcx
  800899:	48 89 08             	mov    %rcx,(%rax)
  80089c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8008a0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8008a4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8008a8:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8008ac:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8008b3:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8008ba:	48 89 d6             	mov    %rdx,%rsi
  8008bd:	48 89 c7             	mov    %rax,%rdi
  8008c0:	48 b8 56 07 80 00 00 	movabs $0x800756,%rax
  8008c7:	00 00 00 
  8008ca:	ff d0                	callq  *%rax
  8008cc:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  8008d2:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8008d8:	c9                   	leaveq 
  8008d9:	c3                   	retq   

00000000008008da <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008da:	55                   	push   %rbp
  8008db:	48 89 e5             	mov    %rsp,%rbp
  8008de:	53                   	push   %rbx
  8008df:	48 83 ec 38          	sub    $0x38,%rsp
  8008e3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008e7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8008eb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8008ef:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8008f2:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8008f6:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8008fa:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8008fd:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800901:	77 3b                	ja     80093e <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800903:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800906:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80090a:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80090d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800911:	ba 00 00 00 00       	mov    $0x0,%edx
  800916:	48 f7 f3             	div    %rbx
  800919:	48 89 c2             	mov    %rax,%rdx
  80091c:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80091f:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800922:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800926:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80092a:	41 89 f9             	mov    %edi,%r9d
  80092d:	48 89 c7             	mov    %rax,%rdi
  800930:	48 b8 da 08 80 00 00 	movabs $0x8008da,%rax
  800937:	00 00 00 
  80093a:	ff d0                	callq  *%rax
  80093c:	eb 1e                	jmp    80095c <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80093e:	eb 12                	jmp    800952 <printnum+0x78>
			putch(padc, putdat);
  800940:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800944:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800947:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80094b:	48 89 ce             	mov    %rcx,%rsi
  80094e:	89 d7                	mov    %edx,%edi
  800950:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800952:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800956:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80095a:	7f e4                	jg     800940 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80095c:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80095f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800963:	ba 00 00 00 00       	mov    $0x0,%edx
  800968:	48 f7 f1             	div    %rcx
  80096b:	48 89 d0             	mov    %rdx,%rax
  80096e:	48 ba 08 41 80 00 00 	movabs $0x804108,%rdx
  800975:	00 00 00 
  800978:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80097c:	0f be d0             	movsbl %al,%edx
  80097f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800983:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800987:	48 89 ce             	mov    %rcx,%rsi
  80098a:	89 d7                	mov    %edx,%edi
  80098c:	ff d0                	callq  *%rax
}
  80098e:	48 83 c4 38          	add    $0x38,%rsp
  800992:	5b                   	pop    %rbx
  800993:	5d                   	pop    %rbp
  800994:	c3                   	retq   

0000000000800995 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800995:	55                   	push   %rbp
  800996:	48 89 e5             	mov    %rsp,%rbp
  800999:	48 83 ec 1c          	sub    $0x1c,%rsp
  80099d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8009a1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8009a4:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8009a8:	7e 52                	jle    8009fc <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8009aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ae:	8b 00                	mov    (%rax),%eax
  8009b0:	83 f8 30             	cmp    $0x30,%eax
  8009b3:	73 24                	jae    8009d9 <getuint+0x44>
  8009b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c1:	8b 00                	mov    (%rax),%eax
  8009c3:	89 c0                	mov    %eax,%eax
  8009c5:	48 01 d0             	add    %rdx,%rax
  8009c8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009cc:	8b 12                	mov    (%rdx),%edx
  8009ce:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009d1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009d5:	89 0a                	mov    %ecx,(%rdx)
  8009d7:	eb 17                	jmp    8009f0 <getuint+0x5b>
  8009d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009dd:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009e1:	48 89 d0             	mov    %rdx,%rax
  8009e4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009e8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ec:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009f0:	48 8b 00             	mov    (%rax),%rax
  8009f3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009f7:	e9 a3 00 00 00       	jmpq   800a9f <getuint+0x10a>
	else if (lflag)
  8009fc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a00:	74 4f                	je     800a51 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800a02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a06:	8b 00                	mov    (%rax),%eax
  800a08:	83 f8 30             	cmp    $0x30,%eax
  800a0b:	73 24                	jae    800a31 <getuint+0x9c>
  800a0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a11:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a19:	8b 00                	mov    (%rax),%eax
  800a1b:	89 c0                	mov    %eax,%eax
  800a1d:	48 01 d0             	add    %rdx,%rax
  800a20:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a24:	8b 12                	mov    (%rdx),%edx
  800a26:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a29:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a2d:	89 0a                	mov    %ecx,(%rdx)
  800a2f:	eb 17                	jmp    800a48 <getuint+0xb3>
  800a31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a35:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a39:	48 89 d0             	mov    %rdx,%rax
  800a3c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a40:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a44:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a48:	48 8b 00             	mov    (%rax),%rax
  800a4b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a4f:	eb 4e                	jmp    800a9f <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800a51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a55:	8b 00                	mov    (%rax),%eax
  800a57:	83 f8 30             	cmp    $0x30,%eax
  800a5a:	73 24                	jae    800a80 <getuint+0xeb>
  800a5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a60:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a68:	8b 00                	mov    (%rax),%eax
  800a6a:	89 c0                	mov    %eax,%eax
  800a6c:	48 01 d0             	add    %rdx,%rax
  800a6f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a73:	8b 12                	mov    (%rdx),%edx
  800a75:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a78:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a7c:	89 0a                	mov    %ecx,(%rdx)
  800a7e:	eb 17                	jmp    800a97 <getuint+0x102>
  800a80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a84:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a88:	48 89 d0             	mov    %rdx,%rax
  800a8b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a8f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a93:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a97:	8b 00                	mov    (%rax),%eax
  800a99:	89 c0                	mov    %eax,%eax
  800a9b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800a9f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800aa3:	c9                   	leaveq 
  800aa4:	c3                   	retq   

0000000000800aa5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800aa5:	55                   	push   %rbp
  800aa6:	48 89 e5             	mov    %rsp,%rbp
  800aa9:	48 83 ec 1c          	sub    $0x1c,%rsp
  800aad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ab1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800ab4:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800ab8:	7e 52                	jle    800b0c <getint+0x67>
		x=va_arg(*ap, long long);
  800aba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800abe:	8b 00                	mov    (%rax),%eax
  800ac0:	83 f8 30             	cmp    $0x30,%eax
  800ac3:	73 24                	jae    800ae9 <getint+0x44>
  800ac5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800acd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ad1:	8b 00                	mov    (%rax),%eax
  800ad3:	89 c0                	mov    %eax,%eax
  800ad5:	48 01 d0             	add    %rdx,%rax
  800ad8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800adc:	8b 12                	mov    (%rdx),%edx
  800ade:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ae1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ae5:	89 0a                	mov    %ecx,(%rdx)
  800ae7:	eb 17                	jmp    800b00 <getint+0x5b>
  800ae9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aed:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800af1:	48 89 d0             	mov    %rdx,%rax
  800af4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800af8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800afc:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b00:	48 8b 00             	mov    (%rax),%rax
  800b03:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b07:	e9 a3 00 00 00       	jmpq   800baf <getint+0x10a>
	else if (lflag)
  800b0c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800b10:	74 4f                	je     800b61 <getint+0xbc>
		x=va_arg(*ap, long);
  800b12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b16:	8b 00                	mov    (%rax),%eax
  800b18:	83 f8 30             	cmp    $0x30,%eax
  800b1b:	73 24                	jae    800b41 <getint+0x9c>
  800b1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b21:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b29:	8b 00                	mov    (%rax),%eax
  800b2b:	89 c0                	mov    %eax,%eax
  800b2d:	48 01 d0             	add    %rdx,%rax
  800b30:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b34:	8b 12                	mov    (%rdx),%edx
  800b36:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b39:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b3d:	89 0a                	mov    %ecx,(%rdx)
  800b3f:	eb 17                	jmp    800b58 <getint+0xb3>
  800b41:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b45:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b49:	48 89 d0             	mov    %rdx,%rax
  800b4c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b50:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b54:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b58:	48 8b 00             	mov    (%rax),%rax
  800b5b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b5f:	eb 4e                	jmp    800baf <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800b61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b65:	8b 00                	mov    (%rax),%eax
  800b67:	83 f8 30             	cmp    $0x30,%eax
  800b6a:	73 24                	jae    800b90 <getint+0xeb>
  800b6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b70:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b78:	8b 00                	mov    (%rax),%eax
  800b7a:	89 c0                	mov    %eax,%eax
  800b7c:	48 01 d0             	add    %rdx,%rax
  800b7f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b83:	8b 12                	mov    (%rdx),%edx
  800b85:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b88:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b8c:	89 0a                	mov    %ecx,(%rdx)
  800b8e:	eb 17                	jmp    800ba7 <getint+0x102>
  800b90:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b94:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b98:	48 89 d0             	mov    %rdx,%rax
  800b9b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b9f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ba3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ba7:	8b 00                	mov    (%rax),%eax
  800ba9:	48 98                	cltq   
  800bab:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800baf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800bb3:	c9                   	leaveq 
  800bb4:	c3                   	retq   

0000000000800bb5 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bb5:	55                   	push   %rbp
  800bb6:	48 89 e5             	mov    %rsp,%rbp
  800bb9:	41 54                	push   %r12
  800bbb:	53                   	push   %rbx
  800bbc:	48 83 ec 60          	sub    $0x60,%rsp
  800bc0:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800bc4:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800bc8:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800bcc:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800bd0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bd4:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800bd8:	48 8b 0a             	mov    (%rdx),%rcx
  800bdb:	48 89 08             	mov    %rcx,(%rax)
  800bde:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800be2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800be6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800bea:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bee:	eb 17                	jmp    800c07 <vprintfmt+0x52>
			if (ch == '\0')
  800bf0:	85 db                	test   %ebx,%ebx
  800bf2:	0f 84 cc 04 00 00    	je     8010c4 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800bf8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bfc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c00:	48 89 d6             	mov    %rdx,%rsi
  800c03:	89 df                	mov    %ebx,%edi
  800c05:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c07:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c0b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800c0f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800c13:	0f b6 00             	movzbl (%rax),%eax
  800c16:	0f b6 d8             	movzbl %al,%ebx
  800c19:	83 fb 25             	cmp    $0x25,%ebx
  800c1c:	75 d2                	jne    800bf0 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c1e:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800c22:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800c29:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800c30:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800c37:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c3e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c42:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800c46:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800c4a:	0f b6 00             	movzbl (%rax),%eax
  800c4d:	0f b6 d8             	movzbl %al,%ebx
  800c50:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800c53:	83 f8 55             	cmp    $0x55,%eax
  800c56:	0f 87 34 04 00 00    	ja     801090 <vprintfmt+0x4db>
  800c5c:	89 c0                	mov    %eax,%eax
  800c5e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800c65:	00 
  800c66:	48 b8 30 41 80 00 00 	movabs $0x804130,%rax
  800c6d:	00 00 00 
  800c70:	48 01 d0             	add    %rdx,%rax
  800c73:	48 8b 00             	mov    (%rax),%rax
  800c76:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c78:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800c7c:	eb c0                	jmp    800c3e <vprintfmt+0x89>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c7e:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800c82:	eb ba                	jmp    800c3e <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c84:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800c8b:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800c8e:	89 d0                	mov    %edx,%eax
  800c90:	c1 e0 02             	shl    $0x2,%eax
  800c93:	01 d0                	add    %edx,%eax
  800c95:	01 c0                	add    %eax,%eax
  800c97:	01 d8                	add    %ebx,%eax
  800c99:	83 e8 30             	sub    $0x30,%eax
  800c9c:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800c9f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ca3:	0f b6 00             	movzbl (%rax),%eax
  800ca6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ca9:	83 fb 2f             	cmp    $0x2f,%ebx
  800cac:	7e 0c                	jle    800cba <vprintfmt+0x105>
  800cae:	83 fb 39             	cmp    $0x39,%ebx
  800cb1:	7f 07                	jg     800cba <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cb3:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cb8:	eb d1                	jmp    800c8b <vprintfmt+0xd6>
			goto process_precision;
  800cba:	eb 58                	jmp    800d14 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800cbc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cbf:	83 f8 30             	cmp    $0x30,%eax
  800cc2:	73 17                	jae    800cdb <vprintfmt+0x126>
  800cc4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cc8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ccb:	89 c0                	mov    %eax,%eax
  800ccd:	48 01 d0             	add    %rdx,%rax
  800cd0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cd3:	83 c2 08             	add    $0x8,%edx
  800cd6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cd9:	eb 0f                	jmp    800cea <vprintfmt+0x135>
  800cdb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cdf:	48 89 d0             	mov    %rdx,%rax
  800ce2:	48 83 c2 08          	add    $0x8,%rdx
  800ce6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cea:	8b 00                	mov    (%rax),%eax
  800cec:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800cef:	eb 23                	jmp    800d14 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800cf1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cf5:	79 0c                	jns    800d03 <vprintfmt+0x14e>
				width = 0;
  800cf7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800cfe:	e9 3b ff ff ff       	jmpq   800c3e <vprintfmt+0x89>
  800d03:	e9 36 ff ff ff       	jmpq   800c3e <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800d08:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800d0f:	e9 2a ff ff ff       	jmpq   800c3e <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800d14:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d18:	79 12                	jns    800d2c <vprintfmt+0x177>
				width = precision, precision = -1;
  800d1a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800d1d:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800d20:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800d27:	e9 12 ff ff ff       	jmpq   800c3e <vprintfmt+0x89>
  800d2c:	e9 0d ff ff ff       	jmpq   800c3e <vprintfmt+0x89>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d31:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800d35:	e9 04 ff ff ff       	jmpq   800c3e <vprintfmt+0x89>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800d3a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d3d:	83 f8 30             	cmp    $0x30,%eax
  800d40:	73 17                	jae    800d59 <vprintfmt+0x1a4>
  800d42:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d46:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d49:	89 c0                	mov    %eax,%eax
  800d4b:	48 01 d0             	add    %rdx,%rax
  800d4e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d51:	83 c2 08             	add    $0x8,%edx
  800d54:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d57:	eb 0f                	jmp    800d68 <vprintfmt+0x1b3>
  800d59:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d5d:	48 89 d0             	mov    %rdx,%rax
  800d60:	48 83 c2 08          	add    $0x8,%rdx
  800d64:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d68:	8b 10                	mov    (%rax),%edx
  800d6a:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800d6e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d72:	48 89 ce             	mov    %rcx,%rsi
  800d75:	89 d7                	mov    %edx,%edi
  800d77:	ff d0                	callq  *%rax
			break;
  800d79:	e9 40 03 00 00       	jmpq   8010be <vprintfmt+0x509>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800d7e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d81:	83 f8 30             	cmp    $0x30,%eax
  800d84:	73 17                	jae    800d9d <vprintfmt+0x1e8>
  800d86:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d8a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d8d:	89 c0                	mov    %eax,%eax
  800d8f:	48 01 d0             	add    %rdx,%rax
  800d92:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d95:	83 c2 08             	add    $0x8,%edx
  800d98:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d9b:	eb 0f                	jmp    800dac <vprintfmt+0x1f7>
  800d9d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800da1:	48 89 d0             	mov    %rdx,%rax
  800da4:	48 83 c2 08          	add    $0x8,%rdx
  800da8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800dac:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800dae:	85 db                	test   %ebx,%ebx
  800db0:	79 02                	jns    800db4 <vprintfmt+0x1ff>
				err = -err;
  800db2:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800db4:	83 fb 10             	cmp    $0x10,%ebx
  800db7:	7f 16                	jg     800dcf <vprintfmt+0x21a>
  800db9:	48 b8 80 40 80 00 00 	movabs $0x804080,%rax
  800dc0:	00 00 00 
  800dc3:	48 63 d3             	movslq %ebx,%rdx
  800dc6:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800dca:	4d 85 e4             	test   %r12,%r12
  800dcd:	75 2e                	jne    800dfd <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800dcf:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800dd3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dd7:	89 d9                	mov    %ebx,%ecx
  800dd9:	48 ba 19 41 80 00 00 	movabs $0x804119,%rdx
  800de0:	00 00 00 
  800de3:	48 89 c7             	mov    %rax,%rdi
  800de6:	b8 00 00 00 00       	mov    $0x0,%eax
  800deb:	49 b8 cd 10 80 00 00 	movabs $0x8010cd,%r8
  800df2:	00 00 00 
  800df5:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800df8:	e9 c1 02 00 00       	jmpq   8010be <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800dfd:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e01:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e05:	4c 89 e1             	mov    %r12,%rcx
  800e08:	48 ba 22 41 80 00 00 	movabs $0x804122,%rdx
  800e0f:	00 00 00 
  800e12:	48 89 c7             	mov    %rax,%rdi
  800e15:	b8 00 00 00 00       	mov    $0x0,%eax
  800e1a:	49 b8 cd 10 80 00 00 	movabs $0x8010cd,%r8
  800e21:	00 00 00 
  800e24:	41 ff d0             	callq  *%r8
			break;
  800e27:	e9 92 02 00 00       	jmpq   8010be <vprintfmt+0x509>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800e2c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e2f:	83 f8 30             	cmp    $0x30,%eax
  800e32:	73 17                	jae    800e4b <vprintfmt+0x296>
  800e34:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e38:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e3b:	89 c0                	mov    %eax,%eax
  800e3d:	48 01 d0             	add    %rdx,%rax
  800e40:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e43:	83 c2 08             	add    $0x8,%edx
  800e46:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e49:	eb 0f                	jmp    800e5a <vprintfmt+0x2a5>
  800e4b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e4f:	48 89 d0             	mov    %rdx,%rax
  800e52:	48 83 c2 08          	add    $0x8,%rdx
  800e56:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e5a:	4c 8b 20             	mov    (%rax),%r12
  800e5d:	4d 85 e4             	test   %r12,%r12
  800e60:	75 0a                	jne    800e6c <vprintfmt+0x2b7>
				p = "(null)";
  800e62:	49 bc 25 41 80 00 00 	movabs $0x804125,%r12
  800e69:	00 00 00 
			if (width > 0 && padc != '-')
  800e6c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e70:	7e 3f                	jle    800eb1 <vprintfmt+0x2fc>
  800e72:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800e76:	74 39                	je     800eb1 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e78:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800e7b:	48 98                	cltq   
  800e7d:	48 89 c6             	mov    %rax,%rsi
  800e80:	4c 89 e7             	mov    %r12,%rdi
  800e83:	48 b8 79 13 80 00 00 	movabs $0x801379,%rax
  800e8a:	00 00 00 
  800e8d:	ff d0                	callq  *%rax
  800e8f:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800e92:	eb 17                	jmp    800eab <vprintfmt+0x2f6>
					putch(padc, putdat);
  800e94:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800e98:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800e9c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ea0:	48 89 ce             	mov    %rcx,%rsi
  800ea3:	89 d7                	mov    %edx,%edi
  800ea5:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ea7:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800eab:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800eaf:	7f e3                	jg     800e94 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800eb1:	eb 37                	jmp    800eea <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800eb3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800eb7:	74 1e                	je     800ed7 <vprintfmt+0x322>
  800eb9:	83 fb 1f             	cmp    $0x1f,%ebx
  800ebc:	7e 05                	jle    800ec3 <vprintfmt+0x30e>
  800ebe:	83 fb 7e             	cmp    $0x7e,%ebx
  800ec1:	7e 14                	jle    800ed7 <vprintfmt+0x322>
					putch('?', putdat);
  800ec3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ec7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ecb:	48 89 d6             	mov    %rdx,%rsi
  800ece:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800ed3:	ff d0                	callq  *%rax
  800ed5:	eb 0f                	jmp    800ee6 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800ed7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800edb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800edf:	48 89 d6             	mov    %rdx,%rsi
  800ee2:	89 df                	mov    %ebx,%edi
  800ee4:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ee6:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800eea:	4c 89 e0             	mov    %r12,%rax
  800eed:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800ef1:	0f b6 00             	movzbl (%rax),%eax
  800ef4:	0f be d8             	movsbl %al,%ebx
  800ef7:	85 db                	test   %ebx,%ebx
  800ef9:	74 10                	je     800f0b <vprintfmt+0x356>
  800efb:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800eff:	78 b2                	js     800eb3 <vprintfmt+0x2fe>
  800f01:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800f05:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800f09:	79 a8                	jns    800eb3 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f0b:	eb 16                	jmp    800f23 <vprintfmt+0x36e>
				putch(' ', putdat);
  800f0d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f11:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f15:	48 89 d6             	mov    %rdx,%rsi
  800f18:	bf 20 00 00 00       	mov    $0x20,%edi
  800f1d:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f1f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800f23:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800f27:	7f e4                	jg     800f0d <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800f29:	e9 90 01 00 00       	jmpq   8010be <vprintfmt+0x509>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800f2e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f32:	be 03 00 00 00       	mov    $0x3,%esi
  800f37:	48 89 c7             	mov    %rax,%rdi
  800f3a:	48 b8 a5 0a 80 00 00 	movabs $0x800aa5,%rax
  800f41:	00 00 00 
  800f44:	ff d0                	callq  *%rax
  800f46:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800f4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f4e:	48 85 c0             	test   %rax,%rax
  800f51:	79 1d                	jns    800f70 <vprintfmt+0x3bb>
				putch('-', putdat);
  800f53:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f57:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f5b:	48 89 d6             	mov    %rdx,%rsi
  800f5e:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800f63:	ff d0                	callq  *%rax
				num = -(long long) num;
  800f65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f69:	48 f7 d8             	neg    %rax
  800f6c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800f70:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800f77:	e9 d5 00 00 00       	jmpq   801051 <vprintfmt+0x49c>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800f7c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f80:	be 03 00 00 00       	mov    $0x3,%esi
  800f85:	48 89 c7             	mov    %rax,%rdi
  800f88:	48 b8 95 09 80 00 00 	movabs $0x800995,%rax
  800f8f:	00 00 00 
  800f92:	ff d0                	callq  *%rax
  800f94:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800f98:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800f9f:	e9 ad 00 00 00       	jmpq   801051 <vprintfmt+0x49c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800fa4:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800fa7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800fab:	89 d6                	mov    %edx,%esi
  800fad:	48 89 c7             	mov    %rax,%rdi
  800fb0:	48 b8 a5 0a 80 00 00 	movabs $0x800aa5,%rax
  800fb7:	00 00 00 
  800fba:	ff d0                	callq  *%rax
  800fbc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800fc0:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800fc7:	e9 85 00 00 00       	jmpq   801051 <vprintfmt+0x49c>


		// pointer
		case 'p':
			putch('0', putdat);
  800fcc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fd0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fd4:	48 89 d6             	mov    %rdx,%rsi
  800fd7:	bf 30 00 00 00       	mov    $0x30,%edi
  800fdc:	ff d0                	callq  *%rax
			putch('x', putdat);
  800fde:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fe2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fe6:	48 89 d6             	mov    %rdx,%rsi
  800fe9:	bf 78 00 00 00       	mov    $0x78,%edi
  800fee:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800ff0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ff3:	83 f8 30             	cmp    $0x30,%eax
  800ff6:	73 17                	jae    80100f <vprintfmt+0x45a>
  800ff8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ffc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800fff:	89 c0                	mov    %eax,%eax
  801001:	48 01 d0             	add    %rdx,%rax
  801004:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801007:	83 c2 08             	add    $0x8,%edx
  80100a:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80100d:	eb 0f                	jmp    80101e <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  80100f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801013:	48 89 d0             	mov    %rdx,%rax
  801016:	48 83 c2 08          	add    $0x8,%rdx
  80101a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80101e:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801021:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801025:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  80102c:	eb 23                	jmp    801051 <vprintfmt+0x49c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  80102e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801032:	be 03 00 00 00       	mov    $0x3,%esi
  801037:	48 89 c7             	mov    %rax,%rdi
  80103a:	48 b8 95 09 80 00 00 	movabs $0x800995,%rax
  801041:	00 00 00 
  801044:	ff d0                	callq  *%rax
  801046:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  80104a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801051:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  801056:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801059:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80105c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801060:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801064:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801068:	45 89 c1             	mov    %r8d,%r9d
  80106b:	41 89 f8             	mov    %edi,%r8d
  80106e:	48 89 c7             	mov    %rax,%rdi
  801071:	48 b8 da 08 80 00 00 	movabs $0x8008da,%rax
  801078:	00 00 00 
  80107b:	ff d0                	callq  *%rax
			break;
  80107d:	eb 3f                	jmp    8010be <vprintfmt+0x509>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80107f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801083:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801087:	48 89 d6             	mov    %rdx,%rsi
  80108a:	89 df                	mov    %ebx,%edi
  80108c:	ff d0                	callq  *%rax
			break;
  80108e:	eb 2e                	jmp    8010be <vprintfmt+0x509>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801090:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801094:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801098:	48 89 d6             	mov    %rdx,%rsi
  80109b:	bf 25 00 00 00       	mov    $0x25,%edi
  8010a0:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010a2:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8010a7:	eb 05                	jmp    8010ae <vprintfmt+0x4f9>
  8010a9:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8010ae:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8010b2:	48 83 e8 01          	sub    $0x1,%rax
  8010b6:	0f b6 00             	movzbl (%rax),%eax
  8010b9:	3c 25                	cmp    $0x25,%al
  8010bb:	75 ec                	jne    8010a9 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  8010bd:	90                   	nop
		}
	}
  8010be:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8010bf:	e9 43 fb ff ff       	jmpq   800c07 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  8010c4:	48 83 c4 60          	add    $0x60,%rsp
  8010c8:	5b                   	pop    %rbx
  8010c9:	41 5c                	pop    %r12
  8010cb:	5d                   	pop    %rbp
  8010cc:	c3                   	retq   

00000000008010cd <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8010cd:	55                   	push   %rbp
  8010ce:	48 89 e5             	mov    %rsp,%rbp
  8010d1:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8010d8:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8010df:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8010e6:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8010ed:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8010f4:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8010fb:	84 c0                	test   %al,%al
  8010fd:	74 20                	je     80111f <printfmt+0x52>
  8010ff:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801103:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801107:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80110b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80110f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801113:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801117:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80111b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80111f:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801126:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80112d:	00 00 00 
  801130:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801137:	00 00 00 
  80113a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80113e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801145:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80114c:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801153:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  80115a:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801161:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801168:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80116f:	48 89 c7             	mov    %rax,%rdi
  801172:	48 b8 b5 0b 80 00 00 	movabs $0x800bb5,%rax
  801179:	00 00 00 
  80117c:	ff d0                	callq  *%rax
	va_end(ap);
}
  80117e:	c9                   	leaveq 
  80117f:	c3                   	retq   

0000000000801180 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801180:	55                   	push   %rbp
  801181:	48 89 e5             	mov    %rsp,%rbp
  801184:	48 83 ec 10          	sub    $0x10,%rsp
  801188:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80118b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  80118f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801193:	8b 40 10             	mov    0x10(%rax),%eax
  801196:	8d 50 01             	lea    0x1(%rax),%edx
  801199:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80119d:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8011a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011a4:	48 8b 10             	mov    (%rax),%rdx
  8011a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011ab:	48 8b 40 08          	mov    0x8(%rax),%rax
  8011af:	48 39 c2             	cmp    %rax,%rdx
  8011b2:	73 17                	jae    8011cb <sprintputch+0x4b>
		*b->buf++ = ch;
  8011b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011b8:	48 8b 00             	mov    (%rax),%rax
  8011bb:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8011bf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8011c3:	48 89 0a             	mov    %rcx,(%rdx)
  8011c6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8011c9:	88 10                	mov    %dl,(%rax)
}
  8011cb:	c9                   	leaveq 
  8011cc:	c3                   	retq   

00000000008011cd <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011cd:	55                   	push   %rbp
  8011ce:	48 89 e5             	mov    %rsp,%rbp
  8011d1:	48 83 ec 50          	sub    $0x50,%rsp
  8011d5:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8011d9:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8011dc:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8011e0:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8011e4:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8011e8:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8011ec:	48 8b 0a             	mov    (%rdx),%rcx
  8011ef:	48 89 08             	mov    %rcx,(%rax)
  8011f2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8011f6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8011fa:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8011fe:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801202:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801206:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80120a:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80120d:	48 98                	cltq   
  80120f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801213:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801217:	48 01 d0             	add    %rdx,%rax
  80121a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80121e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801225:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80122a:	74 06                	je     801232 <vsnprintf+0x65>
  80122c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801230:	7f 07                	jg     801239 <vsnprintf+0x6c>
		return -E_INVAL;
  801232:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801237:	eb 2f                	jmp    801268 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801239:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80123d:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801241:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801245:	48 89 c6             	mov    %rax,%rsi
  801248:	48 bf 80 11 80 00 00 	movabs $0x801180,%rdi
  80124f:	00 00 00 
  801252:	48 b8 b5 0b 80 00 00 	movabs $0x800bb5,%rax
  801259:	00 00 00 
  80125c:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80125e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801262:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801265:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801268:	c9                   	leaveq 
  801269:	c3                   	retq   

000000000080126a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80126a:	55                   	push   %rbp
  80126b:	48 89 e5             	mov    %rsp,%rbp
  80126e:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801275:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80127c:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801282:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801289:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801290:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801297:	84 c0                	test   %al,%al
  801299:	74 20                	je     8012bb <snprintf+0x51>
  80129b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80129f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8012a3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8012a7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8012ab:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8012af:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8012b3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8012b7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8012bb:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8012c2:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8012c9:	00 00 00 
  8012cc:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8012d3:	00 00 00 
  8012d6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8012da:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8012e1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8012e8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8012ef:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8012f6:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8012fd:	48 8b 0a             	mov    (%rdx),%rcx
  801300:	48 89 08             	mov    %rcx,(%rax)
  801303:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801307:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80130b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80130f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801313:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80131a:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801321:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801327:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80132e:	48 89 c7             	mov    %rax,%rdi
  801331:	48 b8 cd 11 80 00 00 	movabs $0x8011cd,%rax
  801338:	00 00 00 
  80133b:	ff d0                	callq  *%rax
  80133d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801343:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801349:	c9                   	leaveq 
  80134a:	c3                   	retq   

000000000080134b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80134b:	55                   	push   %rbp
  80134c:	48 89 e5             	mov    %rsp,%rbp
  80134f:	48 83 ec 18          	sub    $0x18,%rsp
  801353:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801357:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80135e:	eb 09                	jmp    801369 <strlen+0x1e>
		n++;
  801360:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801364:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801369:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80136d:	0f b6 00             	movzbl (%rax),%eax
  801370:	84 c0                	test   %al,%al
  801372:	75 ec                	jne    801360 <strlen+0x15>
		n++;
	return n;
  801374:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801377:	c9                   	leaveq 
  801378:	c3                   	retq   

0000000000801379 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801379:	55                   	push   %rbp
  80137a:	48 89 e5             	mov    %rsp,%rbp
  80137d:	48 83 ec 20          	sub    $0x20,%rsp
  801381:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801385:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801389:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801390:	eb 0e                	jmp    8013a0 <strnlen+0x27>
		n++;
  801392:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801396:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80139b:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8013a0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8013a5:	74 0b                	je     8013b2 <strnlen+0x39>
  8013a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ab:	0f b6 00             	movzbl (%rax),%eax
  8013ae:	84 c0                	test   %al,%al
  8013b0:	75 e0                	jne    801392 <strnlen+0x19>
		n++;
	return n;
  8013b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8013b5:	c9                   	leaveq 
  8013b6:	c3                   	retq   

00000000008013b7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8013b7:	55                   	push   %rbp
  8013b8:	48 89 e5             	mov    %rsp,%rbp
  8013bb:	48 83 ec 20          	sub    $0x20,%rsp
  8013bf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013c3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8013c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013cb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8013cf:	90                   	nop
  8013d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013d4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013d8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8013dc:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013e0:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8013e4:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8013e8:	0f b6 12             	movzbl (%rdx),%edx
  8013eb:	88 10                	mov    %dl,(%rax)
  8013ed:	0f b6 00             	movzbl (%rax),%eax
  8013f0:	84 c0                	test   %al,%al
  8013f2:	75 dc                	jne    8013d0 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8013f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013f8:	c9                   	leaveq 
  8013f9:	c3                   	retq   

00000000008013fa <strcat>:

char *
strcat(char *dst, const char *src)
{
  8013fa:	55                   	push   %rbp
  8013fb:	48 89 e5             	mov    %rsp,%rbp
  8013fe:	48 83 ec 20          	sub    $0x20,%rsp
  801402:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801406:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80140a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80140e:	48 89 c7             	mov    %rax,%rdi
  801411:	48 b8 4b 13 80 00 00 	movabs $0x80134b,%rax
  801418:	00 00 00 
  80141b:	ff d0                	callq  *%rax
  80141d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801420:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801423:	48 63 d0             	movslq %eax,%rdx
  801426:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80142a:	48 01 c2             	add    %rax,%rdx
  80142d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801431:	48 89 c6             	mov    %rax,%rsi
  801434:	48 89 d7             	mov    %rdx,%rdi
  801437:	48 b8 b7 13 80 00 00 	movabs $0x8013b7,%rax
  80143e:	00 00 00 
  801441:	ff d0                	callq  *%rax
	return dst;
  801443:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801447:	c9                   	leaveq 
  801448:	c3                   	retq   

0000000000801449 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801449:	55                   	push   %rbp
  80144a:	48 89 e5             	mov    %rsp,%rbp
  80144d:	48 83 ec 28          	sub    $0x28,%rsp
  801451:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801455:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801459:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80145d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801461:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801465:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80146c:	00 
  80146d:	eb 2a                	jmp    801499 <strncpy+0x50>
		*dst++ = *src;
  80146f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801473:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801477:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80147b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80147f:	0f b6 12             	movzbl (%rdx),%edx
  801482:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801484:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801488:	0f b6 00             	movzbl (%rax),%eax
  80148b:	84 c0                	test   %al,%al
  80148d:	74 05                	je     801494 <strncpy+0x4b>
			src++;
  80148f:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801494:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801499:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80149d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8014a1:	72 cc                	jb     80146f <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8014a7:	c9                   	leaveq 
  8014a8:	c3                   	retq   

00000000008014a9 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8014a9:	55                   	push   %rbp
  8014aa:	48 89 e5             	mov    %rsp,%rbp
  8014ad:	48 83 ec 28          	sub    $0x28,%rsp
  8014b1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014b5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014b9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8014bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014c1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8014c5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8014ca:	74 3d                	je     801509 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8014cc:	eb 1d                	jmp    8014eb <strlcpy+0x42>
			*dst++ = *src++;
  8014ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014d2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014d6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8014da:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8014de:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8014e2:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8014e6:	0f b6 12             	movzbl (%rdx),%edx
  8014e9:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014eb:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8014f0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8014f5:	74 0b                	je     801502 <strlcpy+0x59>
  8014f7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014fb:	0f b6 00             	movzbl (%rax),%eax
  8014fe:	84 c0                	test   %al,%al
  801500:	75 cc                	jne    8014ce <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801502:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801506:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801509:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80150d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801511:	48 29 c2             	sub    %rax,%rdx
  801514:	48 89 d0             	mov    %rdx,%rax
}
  801517:	c9                   	leaveq 
  801518:	c3                   	retq   

0000000000801519 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801519:	55                   	push   %rbp
  80151a:	48 89 e5             	mov    %rsp,%rbp
  80151d:	48 83 ec 10          	sub    $0x10,%rsp
  801521:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801525:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801529:	eb 0a                	jmp    801535 <strcmp+0x1c>
		p++, q++;
  80152b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801530:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801535:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801539:	0f b6 00             	movzbl (%rax),%eax
  80153c:	84 c0                	test   %al,%al
  80153e:	74 12                	je     801552 <strcmp+0x39>
  801540:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801544:	0f b6 10             	movzbl (%rax),%edx
  801547:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80154b:	0f b6 00             	movzbl (%rax),%eax
  80154e:	38 c2                	cmp    %al,%dl
  801550:	74 d9                	je     80152b <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801552:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801556:	0f b6 00             	movzbl (%rax),%eax
  801559:	0f b6 d0             	movzbl %al,%edx
  80155c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801560:	0f b6 00             	movzbl (%rax),%eax
  801563:	0f b6 c0             	movzbl %al,%eax
  801566:	29 c2                	sub    %eax,%edx
  801568:	89 d0                	mov    %edx,%eax
}
  80156a:	c9                   	leaveq 
  80156b:	c3                   	retq   

000000000080156c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80156c:	55                   	push   %rbp
  80156d:	48 89 e5             	mov    %rsp,%rbp
  801570:	48 83 ec 18          	sub    $0x18,%rsp
  801574:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801578:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80157c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801580:	eb 0f                	jmp    801591 <strncmp+0x25>
		n--, p++, q++;
  801582:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801587:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80158c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801591:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801596:	74 1d                	je     8015b5 <strncmp+0x49>
  801598:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80159c:	0f b6 00             	movzbl (%rax),%eax
  80159f:	84 c0                	test   %al,%al
  8015a1:	74 12                	je     8015b5 <strncmp+0x49>
  8015a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015a7:	0f b6 10             	movzbl (%rax),%edx
  8015aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015ae:	0f b6 00             	movzbl (%rax),%eax
  8015b1:	38 c2                	cmp    %al,%dl
  8015b3:	74 cd                	je     801582 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8015b5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015ba:	75 07                	jne    8015c3 <strncmp+0x57>
		return 0;
  8015bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c1:	eb 18                	jmp    8015db <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8015c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015c7:	0f b6 00             	movzbl (%rax),%eax
  8015ca:	0f b6 d0             	movzbl %al,%edx
  8015cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015d1:	0f b6 00             	movzbl (%rax),%eax
  8015d4:	0f b6 c0             	movzbl %al,%eax
  8015d7:	29 c2                	sub    %eax,%edx
  8015d9:	89 d0                	mov    %edx,%eax
}
  8015db:	c9                   	leaveq 
  8015dc:	c3                   	retq   

00000000008015dd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8015dd:	55                   	push   %rbp
  8015de:	48 89 e5             	mov    %rsp,%rbp
  8015e1:	48 83 ec 0c          	sub    $0xc,%rsp
  8015e5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015e9:	89 f0                	mov    %esi,%eax
  8015eb:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8015ee:	eb 17                	jmp    801607 <strchr+0x2a>
		if (*s == c)
  8015f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015f4:	0f b6 00             	movzbl (%rax),%eax
  8015f7:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8015fa:	75 06                	jne    801602 <strchr+0x25>
			return (char *) s;
  8015fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801600:	eb 15                	jmp    801617 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801602:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801607:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80160b:	0f b6 00             	movzbl (%rax),%eax
  80160e:	84 c0                	test   %al,%al
  801610:	75 de                	jne    8015f0 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801612:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801617:	c9                   	leaveq 
  801618:	c3                   	retq   

0000000000801619 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801619:	55                   	push   %rbp
  80161a:	48 89 e5             	mov    %rsp,%rbp
  80161d:	48 83 ec 0c          	sub    $0xc,%rsp
  801621:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801625:	89 f0                	mov    %esi,%eax
  801627:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80162a:	eb 13                	jmp    80163f <strfind+0x26>
		if (*s == c)
  80162c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801630:	0f b6 00             	movzbl (%rax),%eax
  801633:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801636:	75 02                	jne    80163a <strfind+0x21>
			break;
  801638:	eb 10                	jmp    80164a <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80163a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80163f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801643:	0f b6 00             	movzbl (%rax),%eax
  801646:	84 c0                	test   %al,%al
  801648:	75 e2                	jne    80162c <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80164a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80164e:	c9                   	leaveq 
  80164f:	c3                   	retq   

0000000000801650 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801650:	55                   	push   %rbp
  801651:	48 89 e5             	mov    %rsp,%rbp
  801654:	48 83 ec 18          	sub    $0x18,%rsp
  801658:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80165c:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80165f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801663:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801668:	75 06                	jne    801670 <memset+0x20>
		return v;
  80166a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80166e:	eb 69                	jmp    8016d9 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801670:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801674:	83 e0 03             	and    $0x3,%eax
  801677:	48 85 c0             	test   %rax,%rax
  80167a:	75 48                	jne    8016c4 <memset+0x74>
  80167c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801680:	83 e0 03             	and    $0x3,%eax
  801683:	48 85 c0             	test   %rax,%rax
  801686:	75 3c                	jne    8016c4 <memset+0x74>
		c &= 0xFF;
  801688:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80168f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801692:	c1 e0 18             	shl    $0x18,%eax
  801695:	89 c2                	mov    %eax,%edx
  801697:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80169a:	c1 e0 10             	shl    $0x10,%eax
  80169d:	09 c2                	or     %eax,%edx
  80169f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016a2:	c1 e0 08             	shl    $0x8,%eax
  8016a5:	09 d0                	or     %edx,%eax
  8016a7:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8016aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016ae:	48 c1 e8 02          	shr    $0x2,%rax
  8016b2:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8016b5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016b9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016bc:	48 89 d7             	mov    %rdx,%rdi
  8016bf:	fc                   	cld    
  8016c0:	f3 ab                	rep stos %eax,%es:(%rdi)
  8016c2:	eb 11                	jmp    8016d5 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8016c4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016c8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016cb:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8016cf:	48 89 d7             	mov    %rdx,%rdi
  8016d2:	fc                   	cld    
  8016d3:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  8016d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8016d9:	c9                   	leaveq 
  8016da:	c3                   	retq   

00000000008016db <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8016db:	55                   	push   %rbp
  8016dc:	48 89 e5             	mov    %rsp,%rbp
  8016df:	48 83 ec 28          	sub    $0x28,%rsp
  8016e3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016e7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8016eb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8016ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016f3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8016f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016fb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8016ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801703:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801707:	0f 83 88 00 00 00    	jae    801795 <memmove+0xba>
  80170d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801711:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801715:	48 01 d0             	add    %rdx,%rax
  801718:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80171c:	76 77                	jbe    801795 <memmove+0xba>
		s += n;
  80171e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801722:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801726:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80172a:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80172e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801732:	83 e0 03             	and    $0x3,%eax
  801735:	48 85 c0             	test   %rax,%rax
  801738:	75 3b                	jne    801775 <memmove+0x9a>
  80173a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80173e:	83 e0 03             	and    $0x3,%eax
  801741:	48 85 c0             	test   %rax,%rax
  801744:	75 2f                	jne    801775 <memmove+0x9a>
  801746:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80174a:	83 e0 03             	and    $0x3,%eax
  80174d:	48 85 c0             	test   %rax,%rax
  801750:	75 23                	jne    801775 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801752:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801756:	48 83 e8 04          	sub    $0x4,%rax
  80175a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80175e:	48 83 ea 04          	sub    $0x4,%rdx
  801762:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801766:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80176a:	48 89 c7             	mov    %rax,%rdi
  80176d:	48 89 d6             	mov    %rdx,%rsi
  801770:	fd                   	std    
  801771:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801773:	eb 1d                	jmp    801792 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801775:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801779:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80177d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801781:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801785:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801789:	48 89 d7             	mov    %rdx,%rdi
  80178c:	48 89 c1             	mov    %rax,%rcx
  80178f:	fd                   	std    
  801790:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801792:	fc                   	cld    
  801793:	eb 57                	jmp    8017ec <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801795:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801799:	83 e0 03             	and    $0x3,%eax
  80179c:	48 85 c0             	test   %rax,%rax
  80179f:	75 36                	jne    8017d7 <memmove+0xfc>
  8017a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017a5:	83 e0 03             	and    $0x3,%eax
  8017a8:	48 85 c0             	test   %rax,%rax
  8017ab:	75 2a                	jne    8017d7 <memmove+0xfc>
  8017ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b1:	83 e0 03             	and    $0x3,%eax
  8017b4:	48 85 c0             	test   %rax,%rax
  8017b7:	75 1e                	jne    8017d7 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8017b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017bd:	48 c1 e8 02          	shr    $0x2,%rax
  8017c1:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8017c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017c8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017cc:	48 89 c7             	mov    %rax,%rdi
  8017cf:	48 89 d6             	mov    %rdx,%rsi
  8017d2:	fc                   	cld    
  8017d3:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8017d5:	eb 15                	jmp    8017ec <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8017d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017db:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017df:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8017e3:	48 89 c7             	mov    %rax,%rdi
  8017e6:	48 89 d6             	mov    %rdx,%rsi
  8017e9:	fc                   	cld    
  8017ea:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8017ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8017f0:	c9                   	leaveq 
  8017f1:	c3                   	retq   

00000000008017f2 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8017f2:	55                   	push   %rbp
  8017f3:	48 89 e5             	mov    %rsp,%rbp
  8017f6:	48 83 ec 18          	sub    $0x18,%rsp
  8017fa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8017fe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801802:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801806:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80180a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80180e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801812:	48 89 ce             	mov    %rcx,%rsi
  801815:	48 89 c7             	mov    %rax,%rdi
  801818:	48 b8 db 16 80 00 00 	movabs $0x8016db,%rax
  80181f:	00 00 00 
  801822:	ff d0                	callq  *%rax
}
  801824:	c9                   	leaveq 
  801825:	c3                   	retq   

0000000000801826 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801826:	55                   	push   %rbp
  801827:	48 89 e5             	mov    %rsp,%rbp
  80182a:	48 83 ec 28          	sub    $0x28,%rsp
  80182e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801832:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801836:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80183a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80183e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801842:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801846:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80184a:	eb 36                	jmp    801882 <memcmp+0x5c>
		if (*s1 != *s2)
  80184c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801850:	0f b6 10             	movzbl (%rax),%edx
  801853:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801857:	0f b6 00             	movzbl (%rax),%eax
  80185a:	38 c2                	cmp    %al,%dl
  80185c:	74 1a                	je     801878 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80185e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801862:	0f b6 00             	movzbl (%rax),%eax
  801865:	0f b6 d0             	movzbl %al,%edx
  801868:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80186c:	0f b6 00             	movzbl (%rax),%eax
  80186f:	0f b6 c0             	movzbl %al,%eax
  801872:	29 c2                	sub    %eax,%edx
  801874:	89 d0                	mov    %edx,%eax
  801876:	eb 20                	jmp    801898 <memcmp+0x72>
		s1++, s2++;
  801878:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80187d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801882:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801886:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80188a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80188e:	48 85 c0             	test   %rax,%rax
  801891:	75 b9                	jne    80184c <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801893:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801898:	c9                   	leaveq 
  801899:	c3                   	retq   

000000000080189a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80189a:	55                   	push   %rbp
  80189b:	48 89 e5             	mov    %rsp,%rbp
  80189e:	48 83 ec 28          	sub    $0x28,%rsp
  8018a2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018a6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8018a9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8018ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018b5:	48 01 d0             	add    %rdx,%rax
  8018b8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8018bc:	eb 15                	jmp    8018d3 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8018be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018c2:	0f b6 10             	movzbl (%rax),%edx
  8018c5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8018c8:	38 c2                	cmp    %al,%dl
  8018ca:	75 02                	jne    8018ce <memfind+0x34>
			break;
  8018cc:	eb 0f                	jmp    8018dd <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8018ce:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8018d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018d7:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8018db:	72 e1                	jb     8018be <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8018dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018e1:	c9                   	leaveq 
  8018e2:	c3                   	retq   

00000000008018e3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8018e3:	55                   	push   %rbp
  8018e4:	48 89 e5             	mov    %rsp,%rbp
  8018e7:	48 83 ec 34          	sub    $0x34,%rsp
  8018eb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018ef:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8018f3:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8018f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8018fd:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801904:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801905:	eb 05                	jmp    80190c <strtol+0x29>
		s++;
  801907:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80190c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801910:	0f b6 00             	movzbl (%rax),%eax
  801913:	3c 20                	cmp    $0x20,%al
  801915:	74 f0                	je     801907 <strtol+0x24>
  801917:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80191b:	0f b6 00             	movzbl (%rax),%eax
  80191e:	3c 09                	cmp    $0x9,%al
  801920:	74 e5                	je     801907 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801922:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801926:	0f b6 00             	movzbl (%rax),%eax
  801929:	3c 2b                	cmp    $0x2b,%al
  80192b:	75 07                	jne    801934 <strtol+0x51>
		s++;
  80192d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801932:	eb 17                	jmp    80194b <strtol+0x68>
	else if (*s == '-')
  801934:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801938:	0f b6 00             	movzbl (%rax),%eax
  80193b:	3c 2d                	cmp    $0x2d,%al
  80193d:	75 0c                	jne    80194b <strtol+0x68>
		s++, neg = 1;
  80193f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801944:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80194b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80194f:	74 06                	je     801957 <strtol+0x74>
  801951:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801955:	75 28                	jne    80197f <strtol+0x9c>
  801957:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80195b:	0f b6 00             	movzbl (%rax),%eax
  80195e:	3c 30                	cmp    $0x30,%al
  801960:	75 1d                	jne    80197f <strtol+0x9c>
  801962:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801966:	48 83 c0 01          	add    $0x1,%rax
  80196a:	0f b6 00             	movzbl (%rax),%eax
  80196d:	3c 78                	cmp    $0x78,%al
  80196f:	75 0e                	jne    80197f <strtol+0x9c>
		s += 2, base = 16;
  801971:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801976:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80197d:	eb 2c                	jmp    8019ab <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80197f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801983:	75 19                	jne    80199e <strtol+0xbb>
  801985:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801989:	0f b6 00             	movzbl (%rax),%eax
  80198c:	3c 30                	cmp    $0x30,%al
  80198e:	75 0e                	jne    80199e <strtol+0xbb>
		s++, base = 8;
  801990:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801995:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80199c:	eb 0d                	jmp    8019ab <strtol+0xc8>
	else if (base == 0)
  80199e:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019a2:	75 07                	jne    8019ab <strtol+0xc8>
		base = 10;
  8019a4:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8019ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019af:	0f b6 00             	movzbl (%rax),%eax
  8019b2:	3c 2f                	cmp    $0x2f,%al
  8019b4:	7e 1d                	jle    8019d3 <strtol+0xf0>
  8019b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019ba:	0f b6 00             	movzbl (%rax),%eax
  8019bd:	3c 39                	cmp    $0x39,%al
  8019bf:	7f 12                	jg     8019d3 <strtol+0xf0>
			dig = *s - '0';
  8019c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019c5:	0f b6 00             	movzbl (%rax),%eax
  8019c8:	0f be c0             	movsbl %al,%eax
  8019cb:	83 e8 30             	sub    $0x30,%eax
  8019ce:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8019d1:	eb 4e                	jmp    801a21 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8019d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019d7:	0f b6 00             	movzbl (%rax),%eax
  8019da:	3c 60                	cmp    $0x60,%al
  8019dc:	7e 1d                	jle    8019fb <strtol+0x118>
  8019de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019e2:	0f b6 00             	movzbl (%rax),%eax
  8019e5:	3c 7a                	cmp    $0x7a,%al
  8019e7:	7f 12                	jg     8019fb <strtol+0x118>
			dig = *s - 'a' + 10;
  8019e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019ed:	0f b6 00             	movzbl (%rax),%eax
  8019f0:	0f be c0             	movsbl %al,%eax
  8019f3:	83 e8 57             	sub    $0x57,%eax
  8019f6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8019f9:	eb 26                	jmp    801a21 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8019fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019ff:	0f b6 00             	movzbl (%rax),%eax
  801a02:	3c 40                	cmp    $0x40,%al
  801a04:	7e 48                	jle    801a4e <strtol+0x16b>
  801a06:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a0a:	0f b6 00             	movzbl (%rax),%eax
  801a0d:	3c 5a                	cmp    $0x5a,%al
  801a0f:	7f 3d                	jg     801a4e <strtol+0x16b>
			dig = *s - 'A' + 10;
  801a11:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a15:	0f b6 00             	movzbl (%rax),%eax
  801a18:	0f be c0             	movsbl %al,%eax
  801a1b:	83 e8 37             	sub    $0x37,%eax
  801a1e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801a21:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a24:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801a27:	7c 02                	jl     801a2b <strtol+0x148>
			break;
  801a29:	eb 23                	jmp    801a4e <strtol+0x16b>
		s++, val = (val * base) + dig;
  801a2b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a30:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801a33:	48 98                	cltq   
  801a35:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801a3a:	48 89 c2             	mov    %rax,%rdx
  801a3d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a40:	48 98                	cltq   
  801a42:	48 01 d0             	add    %rdx,%rax
  801a45:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801a49:	e9 5d ff ff ff       	jmpq   8019ab <strtol+0xc8>

	if (endptr)
  801a4e:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801a53:	74 0b                	je     801a60 <strtol+0x17d>
		*endptr = (char *) s;
  801a55:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a59:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801a5d:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801a60:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a64:	74 09                	je     801a6f <strtol+0x18c>
  801a66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a6a:	48 f7 d8             	neg    %rax
  801a6d:	eb 04                	jmp    801a73 <strtol+0x190>
  801a6f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801a73:	c9                   	leaveq 
  801a74:	c3                   	retq   

0000000000801a75 <strstr>:

char * strstr(const char *in, const char *str)
{
  801a75:	55                   	push   %rbp
  801a76:	48 89 e5             	mov    %rsp,%rbp
  801a79:	48 83 ec 30          	sub    $0x30,%rsp
  801a7d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801a81:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801a85:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a89:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a8d:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801a91:	0f b6 00             	movzbl (%rax),%eax
  801a94:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  801a97:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801a9b:	75 06                	jne    801aa3 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  801a9d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aa1:	eb 6b                	jmp    801b0e <strstr+0x99>

    len = strlen(str);
  801aa3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801aa7:	48 89 c7             	mov    %rax,%rdi
  801aaa:	48 b8 4b 13 80 00 00 	movabs $0x80134b,%rax
  801ab1:	00 00 00 
  801ab4:	ff d0                	callq  *%rax
  801ab6:	48 98                	cltq   
  801ab8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801abc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ac0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801ac4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801ac8:	0f b6 00             	movzbl (%rax),%eax
  801acb:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  801ace:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801ad2:	75 07                	jne    801adb <strstr+0x66>
                return (char *) 0;
  801ad4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ad9:	eb 33                	jmp    801b0e <strstr+0x99>
        } while (sc != c);
  801adb:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801adf:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801ae2:	75 d8                	jne    801abc <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  801ae4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ae8:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801aec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801af0:	48 89 ce             	mov    %rcx,%rsi
  801af3:	48 89 c7             	mov    %rax,%rdi
  801af6:	48 b8 6c 15 80 00 00 	movabs $0x80156c,%rax
  801afd:	00 00 00 
  801b00:	ff d0                	callq  *%rax
  801b02:	85 c0                	test   %eax,%eax
  801b04:	75 b6                	jne    801abc <strstr+0x47>

    return (char *) (in - 1);
  801b06:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b0a:	48 83 e8 01          	sub    $0x1,%rax
}
  801b0e:	c9                   	leaveq 
  801b0f:	c3                   	retq   

0000000000801b10 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801b10:	55                   	push   %rbp
  801b11:	48 89 e5             	mov    %rsp,%rbp
  801b14:	53                   	push   %rbx
  801b15:	48 83 ec 48          	sub    $0x48,%rsp
  801b19:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801b1c:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801b1f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801b23:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801b27:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801b2b:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b2f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801b32:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801b36:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801b3a:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801b3e:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801b42:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801b46:	4c 89 c3             	mov    %r8,%rbx
  801b49:	cd 30                	int    $0x30
  801b4b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801b4f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801b53:	74 3e                	je     801b93 <syscall+0x83>
  801b55:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801b5a:	7e 37                	jle    801b93 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801b5c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801b60:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801b63:	49 89 d0             	mov    %rdx,%r8
  801b66:	89 c1                	mov    %eax,%ecx
  801b68:	48 ba e0 43 80 00 00 	movabs $0x8043e0,%rdx
  801b6f:	00 00 00 
  801b72:	be 23 00 00 00       	mov    $0x23,%esi
  801b77:	48 bf fd 43 80 00 00 	movabs $0x8043fd,%rdi
  801b7e:	00 00 00 
  801b81:	b8 00 00 00 00       	mov    $0x0,%eax
  801b86:	49 b9 c9 05 80 00 00 	movabs $0x8005c9,%r9
  801b8d:	00 00 00 
  801b90:	41 ff d1             	callq  *%r9

	return ret;
  801b93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801b97:	48 83 c4 48          	add    $0x48,%rsp
  801b9b:	5b                   	pop    %rbx
  801b9c:	5d                   	pop    %rbp
  801b9d:	c3                   	retq   

0000000000801b9e <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801b9e:	55                   	push   %rbp
  801b9f:	48 89 e5             	mov    %rsp,%rbp
  801ba2:	48 83 ec 20          	sub    $0x20,%rsp
  801ba6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801baa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801bae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bb2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bb6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bbd:	00 
  801bbe:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bc4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bca:	48 89 d1             	mov    %rdx,%rcx
  801bcd:	48 89 c2             	mov    %rax,%rdx
  801bd0:	be 00 00 00 00       	mov    $0x0,%esi
  801bd5:	bf 00 00 00 00       	mov    $0x0,%edi
  801bda:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  801be1:	00 00 00 
  801be4:	ff d0                	callq  *%rax
}
  801be6:	c9                   	leaveq 
  801be7:	c3                   	retq   

0000000000801be8 <sys_cgetc>:

int
sys_cgetc(void)
{
  801be8:	55                   	push   %rbp
  801be9:	48 89 e5             	mov    %rsp,%rbp
  801bec:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801bf0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bf7:	00 
  801bf8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bfe:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c04:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c09:	ba 00 00 00 00       	mov    $0x0,%edx
  801c0e:	be 00 00 00 00       	mov    $0x0,%esi
  801c13:	bf 01 00 00 00       	mov    $0x1,%edi
  801c18:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  801c1f:	00 00 00 
  801c22:	ff d0                	callq  *%rax
}
  801c24:	c9                   	leaveq 
  801c25:	c3                   	retq   

0000000000801c26 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801c26:	55                   	push   %rbp
  801c27:	48 89 e5             	mov    %rsp,%rbp
  801c2a:	48 83 ec 10          	sub    $0x10,%rsp
  801c2e:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801c31:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c34:	48 98                	cltq   
  801c36:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c3d:	00 
  801c3e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c44:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c4a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c4f:	48 89 c2             	mov    %rax,%rdx
  801c52:	be 01 00 00 00       	mov    $0x1,%esi
  801c57:	bf 03 00 00 00       	mov    $0x3,%edi
  801c5c:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  801c63:	00 00 00 
  801c66:	ff d0                	callq  *%rax
}
  801c68:	c9                   	leaveq 
  801c69:	c3                   	retq   

0000000000801c6a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801c6a:	55                   	push   %rbp
  801c6b:	48 89 e5             	mov    %rsp,%rbp
  801c6e:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801c72:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c79:	00 
  801c7a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c80:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c86:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c8b:	ba 00 00 00 00       	mov    $0x0,%edx
  801c90:	be 00 00 00 00       	mov    $0x0,%esi
  801c95:	bf 02 00 00 00       	mov    $0x2,%edi
  801c9a:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  801ca1:	00 00 00 
  801ca4:	ff d0                	callq  *%rax
}
  801ca6:	c9                   	leaveq 
  801ca7:	c3                   	retq   

0000000000801ca8 <sys_yield>:

void
sys_yield(void)
{
  801ca8:	55                   	push   %rbp
  801ca9:	48 89 e5             	mov    %rsp,%rbp
  801cac:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801cb0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cb7:	00 
  801cb8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cbe:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cc4:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cc9:	ba 00 00 00 00       	mov    $0x0,%edx
  801cce:	be 00 00 00 00       	mov    $0x0,%esi
  801cd3:	bf 0b 00 00 00       	mov    $0xb,%edi
  801cd8:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  801cdf:	00 00 00 
  801ce2:	ff d0                	callq  *%rax
}
  801ce4:	c9                   	leaveq 
  801ce5:	c3                   	retq   

0000000000801ce6 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801ce6:	55                   	push   %rbp
  801ce7:	48 89 e5             	mov    %rsp,%rbp
  801cea:	48 83 ec 20          	sub    $0x20,%rsp
  801cee:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cf1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801cf5:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801cf8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801cfb:	48 63 c8             	movslq %eax,%rcx
  801cfe:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d05:	48 98                	cltq   
  801d07:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d0e:	00 
  801d0f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d15:	49 89 c8             	mov    %rcx,%r8
  801d18:	48 89 d1             	mov    %rdx,%rcx
  801d1b:	48 89 c2             	mov    %rax,%rdx
  801d1e:	be 01 00 00 00       	mov    $0x1,%esi
  801d23:	bf 04 00 00 00       	mov    $0x4,%edi
  801d28:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  801d2f:	00 00 00 
  801d32:	ff d0                	callq  *%rax
}
  801d34:	c9                   	leaveq 
  801d35:	c3                   	retq   

0000000000801d36 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801d36:	55                   	push   %rbp
  801d37:	48 89 e5             	mov    %rsp,%rbp
  801d3a:	48 83 ec 30          	sub    $0x30,%rsp
  801d3e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d41:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d45:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801d48:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d4c:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801d50:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801d53:	48 63 c8             	movslq %eax,%rcx
  801d56:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d5a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d5d:	48 63 f0             	movslq %eax,%rsi
  801d60:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d67:	48 98                	cltq   
  801d69:	48 89 0c 24          	mov    %rcx,(%rsp)
  801d6d:	49 89 f9             	mov    %rdi,%r9
  801d70:	49 89 f0             	mov    %rsi,%r8
  801d73:	48 89 d1             	mov    %rdx,%rcx
  801d76:	48 89 c2             	mov    %rax,%rdx
  801d79:	be 01 00 00 00       	mov    $0x1,%esi
  801d7e:	bf 05 00 00 00       	mov    $0x5,%edi
  801d83:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  801d8a:	00 00 00 
  801d8d:	ff d0                	callq  *%rax
}
  801d8f:	c9                   	leaveq 
  801d90:	c3                   	retq   

0000000000801d91 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801d91:	55                   	push   %rbp
  801d92:	48 89 e5             	mov    %rsp,%rbp
  801d95:	48 83 ec 20          	sub    $0x20,%rsp
  801d99:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d9c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801da0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801da4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801da7:	48 98                	cltq   
  801da9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801db0:	00 
  801db1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801db7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dbd:	48 89 d1             	mov    %rdx,%rcx
  801dc0:	48 89 c2             	mov    %rax,%rdx
  801dc3:	be 01 00 00 00       	mov    $0x1,%esi
  801dc8:	bf 06 00 00 00       	mov    $0x6,%edi
  801dcd:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  801dd4:	00 00 00 
  801dd7:	ff d0                	callq  *%rax
}
  801dd9:	c9                   	leaveq 
  801dda:	c3                   	retq   

0000000000801ddb <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801ddb:	55                   	push   %rbp
  801ddc:	48 89 e5             	mov    %rsp,%rbp
  801ddf:	48 83 ec 10          	sub    $0x10,%rsp
  801de3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801de6:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801de9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dec:	48 63 d0             	movslq %eax,%rdx
  801def:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801df2:	48 98                	cltq   
  801df4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dfb:	00 
  801dfc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e02:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e08:	48 89 d1             	mov    %rdx,%rcx
  801e0b:	48 89 c2             	mov    %rax,%rdx
  801e0e:	be 01 00 00 00       	mov    $0x1,%esi
  801e13:	bf 08 00 00 00       	mov    $0x8,%edi
  801e18:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  801e1f:	00 00 00 
  801e22:	ff d0                	callq  *%rax
}
  801e24:	c9                   	leaveq 
  801e25:	c3                   	retq   

0000000000801e26 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801e26:	55                   	push   %rbp
  801e27:	48 89 e5             	mov    %rsp,%rbp
  801e2a:	48 83 ec 20          	sub    $0x20,%rsp
  801e2e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e31:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801e35:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e39:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e3c:	48 98                	cltq   
  801e3e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e45:	00 
  801e46:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e4c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e52:	48 89 d1             	mov    %rdx,%rcx
  801e55:	48 89 c2             	mov    %rax,%rdx
  801e58:	be 01 00 00 00       	mov    $0x1,%esi
  801e5d:	bf 09 00 00 00       	mov    $0x9,%edi
  801e62:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  801e69:	00 00 00 
  801e6c:	ff d0                	callq  *%rax
}
  801e6e:	c9                   	leaveq 
  801e6f:	c3                   	retq   

0000000000801e70 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801e70:	55                   	push   %rbp
  801e71:	48 89 e5             	mov    %rsp,%rbp
  801e74:	48 83 ec 20          	sub    $0x20,%rsp
  801e78:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e7b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801e7f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e86:	48 98                	cltq   
  801e88:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e8f:	00 
  801e90:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e96:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e9c:	48 89 d1             	mov    %rdx,%rcx
  801e9f:	48 89 c2             	mov    %rax,%rdx
  801ea2:	be 01 00 00 00       	mov    $0x1,%esi
  801ea7:	bf 0a 00 00 00       	mov    $0xa,%edi
  801eac:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  801eb3:	00 00 00 
  801eb6:	ff d0                	callq  *%rax
}
  801eb8:	c9                   	leaveq 
  801eb9:	c3                   	retq   

0000000000801eba <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801eba:	55                   	push   %rbp
  801ebb:	48 89 e5             	mov    %rsp,%rbp
  801ebe:	48 83 ec 20          	sub    $0x20,%rsp
  801ec2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ec5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ec9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801ecd:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801ed0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ed3:	48 63 f0             	movslq %eax,%rsi
  801ed6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801eda:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801edd:	48 98                	cltq   
  801edf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ee3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801eea:	00 
  801eeb:	49 89 f1             	mov    %rsi,%r9
  801eee:	49 89 c8             	mov    %rcx,%r8
  801ef1:	48 89 d1             	mov    %rdx,%rcx
  801ef4:	48 89 c2             	mov    %rax,%rdx
  801ef7:	be 00 00 00 00       	mov    $0x0,%esi
  801efc:	bf 0c 00 00 00       	mov    $0xc,%edi
  801f01:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  801f08:	00 00 00 
  801f0b:	ff d0                	callq  *%rax
}
  801f0d:	c9                   	leaveq 
  801f0e:	c3                   	retq   

0000000000801f0f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801f0f:	55                   	push   %rbp
  801f10:	48 89 e5             	mov    %rsp,%rbp
  801f13:	48 83 ec 10          	sub    $0x10,%rsp
  801f17:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801f1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f1f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f26:	00 
  801f27:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f2d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f33:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f38:	48 89 c2             	mov    %rax,%rdx
  801f3b:	be 01 00 00 00       	mov    $0x1,%esi
  801f40:	bf 0d 00 00 00       	mov    $0xd,%edi
  801f45:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  801f4c:	00 00 00 
  801f4f:	ff d0                	callq  *%rax
}
  801f51:	c9                   	leaveq 
  801f52:	c3                   	retq   

0000000000801f53 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801f53:	55                   	push   %rbp
  801f54:	48 89 e5             	mov    %rsp,%rbp
  801f57:	48 83 ec 18          	sub    $0x18,%rsp
  801f5b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801f5f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f63:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	args->argc = argc;
  801f67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f6b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f6f:	48 89 10             	mov    %rdx,(%rax)
	args->argv = (const char **) argv;
  801f72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f76:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f7a:	48 89 50 08          	mov    %rdx,0x8(%rax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801f7e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f82:	8b 00                	mov    (%rax),%eax
  801f84:	83 f8 01             	cmp    $0x1,%eax
  801f87:	7e 13                	jle    801f9c <argstart+0x49>
  801f89:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  801f8e:	74 0c                	je     801f9c <argstart+0x49>
  801f90:	48 b8 0b 44 80 00 00 	movabs $0x80440b,%rax
  801f97:	00 00 00 
  801f9a:	eb 05                	jmp    801fa1 <argstart+0x4e>
  801f9c:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801fa5:	48 89 42 10          	mov    %rax,0x10(%rdx)
	args->argvalue = 0;
  801fa9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fad:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  801fb4:	00 
}
  801fb5:	c9                   	leaveq 
  801fb6:	c3                   	retq   

0000000000801fb7 <argnext>:

int
argnext(struct Argstate *args)
{
  801fb7:	55                   	push   %rbp
  801fb8:	48 89 e5             	mov    %rsp,%rbp
  801fbb:	48 83 ec 20          	sub    $0x20,%rsp
  801fbf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int arg;

	args->argvalue = 0;
  801fc3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fc7:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  801fce:	00 

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801fcf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fd3:	48 8b 40 10          	mov    0x10(%rax),%rax
  801fd7:	48 85 c0             	test   %rax,%rax
  801fda:	75 0a                	jne    801fe6 <argnext+0x2f>
		return -1;
  801fdc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801fe1:	e9 25 01 00 00       	jmpq   80210b <argnext+0x154>

	if (!*args->curarg) {
  801fe6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fea:	48 8b 40 10          	mov    0x10(%rax),%rax
  801fee:	0f b6 00             	movzbl (%rax),%eax
  801ff1:	84 c0                	test   %al,%al
  801ff3:	0f 85 d7 00 00 00    	jne    8020d0 <argnext+0x119>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801ff9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ffd:	48 8b 00             	mov    (%rax),%rax
  802000:	8b 00                	mov    (%rax),%eax
  802002:	83 f8 01             	cmp    $0x1,%eax
  802005:	0f 84 ef 00 00 00    	je     8020fa <argnext+0x143>
		    || args->argv[1][0] != '-'
  80200b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80200f:	48 8b 40 08          	mov    0x8(%rax),%rax
  802013:	48 83 c0 08          	add    $0x8,%rax
  802017:	48 8b 00             	mov    (%rax),%rax
  80201a:	0f b6 00             	movzbl (%rax),%eax
  80201d:	3c 2d                	cmp    $0x2d,%al
  80201f:	0f 85 d5 00 00 00    	jne    8020fa <argnext+0x143>
		    || args->argv[1][1] == '\0')
  802025:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802029:	48 8b 40 08          	mov    0x8(%rax),%rax
  80202d:	48 83 c0 08          	add    $0x8,%rax
  802031:	48 8b 00             	mov    (%rax),%rax
  802034:	48 83 c0 01          	add    $0x1,%rax
  802038:	0f b6 00             	movzbl (%rax),%eax
  80203b:	84 c0                	test   %al,%al
  80203d:	0f 84 b7 00 00 00    	je     8020fa <argnext+0x143>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  802043:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802047:	48 8b 40 08          	mov    0x8(%rax),%rax
  80204b:	48 83 c0 08          	add    $0x8,%rax
  80204f:	48 8b 00             	mov    (%rax),%rax
  802052:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802056:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80205a:	48 89 50 10          	mov    %rdx,0x10(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  80205e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802062:	48 8b 00             	mov    (%rax),%rax
  802065:	8b 00                	mov    (%rax),%eax
  802067:	83 e8 01             	sub    $0x1,%eax
  80206a:	48 98                	cltq   
  80206c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802073:	00 
  802074:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802078:	48 8b 40 08          	mov    0x8(%rax),%rax
  80207c:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802080:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802084:	48 8b 40 08          	mov    0x8(%rax),%rax
  802088:	48 83 c0 08          	add    $0x8,%rax
  80208c:	48 89 ce             	mov    %rcx,%rsi
  80208f:	48 89 c7             	mov    %rax,%rdi
  802092:	48 b8 db 16 80 00 00 	movabs $0x8016db,%rax
  802099:	00 00 00 
  80209c:	ff d0                	callq  *%rax
		(*args->argc)--;
  80209e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020a2:	48 8b 00             	mov    (%rax),%rax
  8020a5:	8b 10                	mov    (%rax),%edx
  8020a7:	83 ea 01             	sub    $0x1,%edx
  8020aa:	89 10                	mov    %edx,(%rax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  8020ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020b0:	48 8b 40 10          	mov    0x10(%rax),%rax
  8020b4:	0f b6 00             	movzbl (%rax),%eax
  8020b7:	3c 2d                	cmp    $0x2d,%al
  8020b9:	75 15                	jne    8020d0 <argnext+0x119>
  8020bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020bf:	48 8b 40 10          	mov    0x10(%rax),%rax
  8020c3:	48 83 c0 01          	add    $0x1,%rax
  8020c7:	0f b6 00             	movzbl (%rax),%eax
  8020ca:	84 c0                	test   %al,%al
  8020cc:	75 02                	jne    8020d0 <argnext+0x119>
			goto endofargs;
  8020ce:	eb 2a                	jmp    8020fa <argnext+0x143>
	}

	arg = (unsigned char) *args->curarg;
  8020d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020d4:	48 8b 40 10          	mov    0x10(%rax),%rax
  8020d8:	0f b6 00             	movzbl (%rax),%eax
  8020db:	0f b6 c0             	movzbl %al,%eax
  8020de:	89 45 fc             	mov    %eax,-0x4(%rbp)
	args->curarg++;
  8020e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020e5:	48 8b 40 10          	mov    0x10(%rax),%rax
  8020e9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8020ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020f1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	return arg;
  8020f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020f8:	eb 11                	jmp    80210b <argnext+0x154>

    endofargs:
	args->curarg = 0;
  8020fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020fe:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  802105:	00 
	return -1;
  802106:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  80210b:	c9                   	leaveq 
  80210c:	c3                   	retq   

000000000080210d <argvalue>:

char *
argvalue(struct Argstate *args)
{
  80210d:	55                   	push   %rbp
  80210e:	48 89 e5             	mov    %rsp,%rbp
  802111:	48 83 ec 10          	sub    $0x10,%rsp
  802115:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  802119:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80211d:	48 8b 40 18          	mov    0x18(%rax),%rax
  802121:	48 85 c0             	test   %rax,%rax
  802124:	74 0a                	je     802130 <argvalue+0x23>
  802126:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80212a:	48 8b 40 18          	mov    0x18(%rax),%rax
  80212e:	eb 13                	jmp    802143 <argvalue+0x36>
  802130:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802134:	48 89 c7             	mov    %rax,%rdi
  802137:	48 b8 45 21 80 00 00 	movabs $0x802145,%rax
  80213e:	00 00 00 
  802141:	ff d0                	callq  *%rax
}
  802143:	c9                   	leaveq 
  802144:	c3                   	retq   

0000000000802145 <argnextvalue>:

char *
argnextvalue(struct Argstate *args)
{
  802145:	55                   	push   %rbp
  802146:	48 89 e5             	mov    %rsp,%rbp
  802149:	53                   	push   %rbx
  80214a:	48 83 ec 18          	sub    $0x18,%rsp
  80214e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (!args->curarg)
  802152:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802156:	48 8b 40 10          	mov    0x10(%rax),%rax
  80215a:	48 85 c0             	test   %rax,%rax
  80215d:	75 0a                	jne    802169 <argnextvalue+0x24>
		return 0;
  80215f:	b8 00 00 00 00       	mov    $0x0,%eax
  802164:	e9 c8 00 00 00       	jmpq   802231 <argnextvalue+0xec>
	if (*args->curarg) {
  802169:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80216d:	48 8b 40 10          	mov    0x10(%rax),%rax
  802171:	0f b6 00             	movzbl (%rax),%eax
  802174:	84 c0                	test   %al,%al
  802176:	74 27                	je     80219f <argnextvalue+0x5a>
		args->argvalue = args->curarg;
  802178:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80217c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802180:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802184:	48 89 50 18          	mov    %rdx,0x18(%rax)
		args->curarg = "";
  802188:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80218c:	48 bb 0b 44 80 00 00 	movabs $0x80440b,%rbx
  802193:	00 00 00 
  802196:	48 89 58 10          	mov    %rbx,0x10(%rax)
  80219a:	e9 8a 00 00 00       	jmpq   802229 <argnextvalue+0xe4>
	} else if (*args->argc > 1) {
  80219f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021a3:	48 8b 00             	mov    (%rax),%rax
  8021a6:	8b 00                	mov    (%rax),%eax
  8021a8:	83 f8 01             	cmp    $0x1,%eax
  8021ab:	7e 64                	jle    802211 <argnextvalue+0xcc>
		args->argvalue = args->argv[1];
  8021ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021b1:	48 8b 40 08          	mov    0x8(%rax),%rax
  8021b5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8021b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021bd:	48 89 50 18          	mov    %rdx,0x18(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8021c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021c5:	48 8b 00             	mov    (%rax),%rax
  8021c8:	8b 00                	mov    (%rax),%eax
  8021ca:	83 e8 01             	sub    $0x1,%eax
  8021cd:	48 98                	cltq   
  8021cf:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8021d6:	00 
  8021d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021db:	48 8b 40 08          	mov    0x8(%rax),%rax
  8021df:	48 8d 48 10          	lea    0x10(%rax),%rcx
  8021e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021e7:	48 8b 40 08          	mov    0x8(%rax),%rax
  8021eb:	48 83 c0 08          	add    $0x8,%rax
  8021ef:	48 89 ce             	mov    %rcx,%rsi
  8021f2:	48 89 c7             	mov    %rax,%rdi
  8021f5:	48 b8 db 16 80 00 00 	movabs $0x8016db,%rax
  8021fc:	00 00 00 
  8021ff:	ff d0                	callq  *%rax
		(*args->argc)--;
  802201:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802205:	48 8b 00             	mov    (%rax),%rax
  802208:	8b 10                	mov    (%rax),%edx
  80220a:	83 ea 01             	sub    $0x1,%edx
  80220d:	89 10                	mov    %edx,(%rax)
  80220f:	eb 18                	jmp    802229 <argnextvalue+0xe4>
	} else {
		args->argvalue = 0;
  802211:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802215:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  80221c:	00 
		args->curarg = 0;
  80221d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802221:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  802228:	00 
	}
	return (char*) args->argvalue;
  802229:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80222d:	48 8b 40 18          	mov    0x18(%rax),%rax
}
  802231:	48 83 c4 18          	add    $0x18,%rsp
  802235:	5b                   	pop    %rbx
  802236:	5d                   	pop    %rbp
  802237:	c3                   	retq   

0000000000802238 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802238:	55                   	push   %rbp
  802239:	48 89 e5             	mov    %rsp,%rbp
  80223c:	48 83 ec 08          	sub    $0x8,%rsp
  802240:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802244:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802248:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80224f:	ff ff ff 
  802252:	48 01 d0             	add    %rdx,%rax
  802255:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802259:	c9                   	leaveq 
  80225a:	c3                   	retq   

000000000080225b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80225b:	55                   	push   %rbp
  80225c:	48 89 e5             	mov    %rsp,%rbp
  80225f:	48 83 ec 08          	sub    $0x8,%rsp
  802263:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802267:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80226b:	48 89 c7             	mov    %rax,%rdi
  80226e:	48 b8 38 22 80 00 00 	movabs $0x802238,%rax
  802275:	00 00 00 
  802278:	ff d0                	callq  *%rax
  80227a:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802280:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802284:	c9                   	leaveq 
  802285:	c3                   	retq   

0000000000802286 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802286:	55                   	push   %rbp
  802287:	48 89 e5             	mov    %rsp,%rbp
  80228a:	48 83 ec 18          	sub    $0x18,%rsp
  80228e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802292:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802299:	eb 6b                	jmp    802306 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80229b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80229e:	48 98                	cltq   
  8022a0:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8022a6:	48 c1 e0 0c          	shl    $0xc,%rax
  8022aa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8022ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022b2:	48 c1 e8 15          	shr    $0x15,%rax
  8022b6:	48 89 c2             	mov    %rax,%rdx
  8022b9:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8022c0:	01 00 00 
  8022c3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022c7:	83 e0 01             	and    $0x1,%eax
  8022ca:	48 85 c0             	test   %rax,%rax
  8022cd:	74 21                	je     8022f0 <fd_alloc+0x6a>
  8022cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022d3:	48 c1 e8 0c          	shr    $0xc,%rax
  8022d7:	48 89 c2             	mov    %rax,%rdx
  8022da:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022e1:	01 00 00 
  8022e4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022e8:	83 e0 01             	and    $0x1,%eax
  8022eb:	48 85 c0             	test   %rax,%rax
  8022ee:	75 12                	jne    802302 <fd_alloc+0x7c>
			*fd_store = fd;
  8022f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022f4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022f8:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8022fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802300:	eb 1a                	jmp    80231c <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802302:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802306:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80230a:	7e 8f                	jle    80229b <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80230c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802310:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802317:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80231c:	c9                   	leaveq 
  80231d:	c3                   	retq   

000000000080231e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80231e:	55                   	push   %rbp
  80231f:	48 89 e5             	mov    %rsp,%rbp
  802322:	48 83 ec 20          	sub    $0x20,%rsp
  802326:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802329:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80232d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802331:	78 06                	js     802339 <fd_lookup+0x1b>
  802333:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802337:	7e 07                	jle    802340 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802339:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80233e:	eb 6c                	jmp    8023ac <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802340:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802343:	48 98                	cltq   
  802345:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80234b:	48 c1 e0 0c          	shl    $0xc,%rax
  80234f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802353:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802357:	48 c1 e8 15          	shr    $0x15,%rax
  80235b:	48 89 c2             	mov    %rax,%rdx
  80235e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802365:	01 00 00 
  802368:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80236c:	83 e0 01             	and    $0x1,%eax
  80236f:	48 85 c0             	test   %rax,%rax
  802372:	74 21                	je     802395 <fd_lookup+0x77>
  802374:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802378:	48 c1 e8 0c          	shr    $0xc,%rax
  80237c:	48 89 c2             	mov    %rax,%rdx
  80237f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802386:	01 00 00 
  802389:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80238d:	83 e0 01             	and    $0x1,%eax
  802390:	48 85 c0             	test   %rax,%rax
  802393:	75 07                	jne    80239c <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802395:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80239a:	eb 10                	jmp    8023ac <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80239c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023a0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8023a4:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8023a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023ac:	c9                   	leaveq 
  8023ad:	c3                   	retq   

00000000008023ae <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8023ae:	55                   	push   %rbp
  8023af:	48 89 e5             	mov    %rsp,%rbp
  8023b2:	48 83 ec 30          	sub    $0x30,%rsp
  8023b6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8023ba:	89 f0                	mov    %esi,%eax
  8023bc:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8023bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023c3:	48 89 c7             	mov    %rax,%rdi
  8023c6:	48 b8 38 22 80 00 00 	movabs $0x802238,%rax
  8023cd:	00 00 00 
  8023d0:	ff d0                	callq  *%rax
  8023d2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023d6:	48 89 d6             	mov    %rdx,%rsi
  8023d9:	89 c7                	mov    %eax,%edi
  8023db:	48 b8 1e 23 80 00 00 	movabs $0x80231e,%rax
  8023e2:	00 00 00 
  8023e5:	ff d0                	callq  *%rax
  8023e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023ee:	78 0a                	js     8023fa <fd_close+0x4c>
	    || fd != fd2)
  8023f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023f4:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8023f8:	74 12                	je     80240c <fd_close+0x5e>
		return (must_exist ? r : 0);
  8023fa:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8023fe:	74 05                	je     802405 <fd_close+0x57>
  802400:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802403:	eb 05                	jmp    80240a <fd_close+0x5c>
  802405:	b8 00 00 00 00       	mov    $0x0,%eax
  80240a:	eb 69                	jmp    802475 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80240c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802410:	8b 00                	mov    (%rax),%eax
  802412:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802416:	48 89 d6             	mov    %rdx,%rsi
  802419:	89 c7                	mov    %eax,%edi
  80241b:	48 b8 77 24 80 00 00 	movabs $0x802477,%rax
  802422:	00 00 00 
  802425:	ff d0                	callq  *%rax
  802427:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80242a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80242e:	78 2a                	js     80245a <fd_close+0xac>
		if (dev->dev_close)
  802430:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802434:	48 8b 40 20          	mov    0x20(%rax),%rax
  802438:	48 85 c0             	test   %rax,%rax
  80243b:	74 16                	je     802453 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  80243d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802441:	48 8b 40 20          	mov    0x20(%rax),%rax
  802445:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802449:	48 89 d7             	mov    %rdx,%rdi
  80244c:	ff d0                	callq  *%rax
  80244e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802451:	eb 07                	jmp    80245a <fd_close+0xac>
		else
			r = 0;
  802453:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80245a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80245e:	48 89 c6             	mov    %rax,%rsi
  802461:	bf 00 00 00 00       	mov    $0x0,%edi
  802466:	48 b8 91 1d 80 00 00 	movabs $0x801d91,%rax
  80246d:	00 00 00 
  802470:	ff d0                	callq  *%rax
	return r;
  802472:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802475:	c9                   	leaveq 
  802476:	c3                   	retq   

0000000000802477 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802477:	55                   	push   %rbp
  802478:	48 89 e5             	mov    %rsp,%rbp
  80247b:	48 83 ec 20          	sub    $0x20,%rsp
  80247f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802482:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802486:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80248d:	eb 41                	jmp    8024d0 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80248f:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802496:	00 00 00 
  802499:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80249c:	48 63 d2             	movslq %edx,%rdx
  80249f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024a3:	8b 00                	mov    (%rax),%eax
  8024a5:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8024a8:	75 22                	jne    8024cc <dev_lookup+0x55>
			*dev = devtab[i];
  8024aa:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8024b1:	00 00 00 
  8024b4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8024b7:	48 63 d2             	movslq %edx,%rdx
  8024ba:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8024be:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024c2:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8024c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ca:	eb 60                	jmp    80252c <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8024cc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8024d0:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8024d7:	00 00 00 
  8024da:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8024dd:	48 63 d2             	movslq %edx,%rdx
  8024e0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024e4:	48 85 c0             	test   %rax,%rax
  8024e7:	75 a6                	jne    80248f <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8024e9:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  8024f0:	00 00 00 
  8024f3:	48 8b 00             	mov    (%rax),%rax
  8024f6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024fc:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8024ff:	89 c6                	mov    %eax,%esi
  802501:	48 bf 10 44 80 00 00 	movabs $0x804410,%rdi
  802508:	00 00 00 
  80250b:	b8 00 00 00 00       	mov    $0x0,%eax
  802510:	48 b9 02 08 80 00 00 	movabs $0x800802,%rcx
  802517:	00 00 00 
  80251a:	ff d1                	callq  *%rcx
	*dev = 0;
  80251c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802520:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802527:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80252c:	c9                   	leaveq 
  80252d:	c3                   	retq   

000000000080252e <close>:

int
close(int fdnum)
{
  80252e:	55                   	push   %rbp
  80252f:	48 89 e5             	mov    %rsp,%rbp
  802532:	48 83 ec 20          	sub    $0x20,%rsp
  802536:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802539:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80253d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802540:	48 89 d6             	mov    %rdx,%rsi
  802543:	89 c7                	mov    %eax,%edi
  802545:	48 b8 1e 23 80 00 00 	movabs $0x80231e,%rax
  80254c:	00 00 00 
  80254f:	ff d0                	callq  *%rax
  802551:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802554:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802558:	79 05                	jns    80255f <close+0x31>
		return r;
  80255a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80255d:	eb 18                	jmp    802577 <close+0x49>
	else
		return fd_close(fd, 1);
  80255f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802563:	be 01 00 00 00       	mov    $0x1,%esi
  802568:	48 89 c7             	mov    %rax,%rdi
  80256b:	48 b8 ae 23 80 00 00 	movabs $0x8023ae,%rax
  802572:	00 00 00 
  802575:	ff d0                	callq  *%rax
}
  802577:	c9                   	leaveq 
  802578:	c3                   	retq   

0000000000802579 <close_all>:

void
close_all(void)
{
  802579:	55                   	push   %rbp
  80257a:	48 89 e5             	mov    %rsp,%rbp
  80257d:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802581:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802588:	eb 15                	jmp    80259f <close_all+0x26>
		close(i);
  80258a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80258d:	89 c7                	mov    %eax,%edi
  80258f:	48 b8 2e 25 80 00 00 	movabs $0x80252e,%rax
  802596:	00 00 00 
  802599:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80259b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80259f:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8025a3:	7e e5                	jle    80258a <close_all+0x11>
		close(i);
}
  8025a5:	c9                   	leaveq 
  8025a6:	c3                   	retq   

00000000008025a7 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8025a7:	55                   	push   %rbp
  8025a8:	48 89 e5             	mov    %rsp,%rbp
  8025ab:	48 83 ec 40          	sub    $0x40,%rsp
  8025af:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8025b2:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8025b5:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8025b9:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8025bc:	48 89 d6             	mov    %rdx,%rsi
  8025bf:	89 c7                	mov    %eax,%edi
  8025c1:	48 b8 1e 23 80 00 00 	movabs $0x80231e,%rax
  8025c8:	00 00 00 
  8025cb:	ff d0                	callq  *%rax
  8025cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025d4:	79 08                	jns    8025de <dup+0x37>
		return r;
  8025d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025d9:	e9 70 01 00 00       	jmpq   80274e <dup+0x1a7>
	close(newfdnum);
  8025de:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8025e1:	89 c7                	mov    %eax,%edi
  8025e3:	48 b8 2e 25 80 00 00 	movabs $0x80252e,%rax
  8025ea:	00 00 00 
  8025ed:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8025ef:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8025f2:	48 98                	cltq   
  8025f4:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8025fa:	48 c1 e0 0c          	shl    $0xc,%rax
  8025fe:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802602:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802606:	48 89 c7             	mov    %rax,%rdi
  802609:	48 b8 5b 22 80 00 00 	movabs $0x80225b,%rax
  802610:	00 00 00 
  802613:	ff d0                	callq  *%rax
  802615:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802619:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80261d:	48 89 c7             	mov    %rax,%rdi
  802620:	48 b8 5b 22 80 00 00 	movabs $0x80225b,%rax
  802627:	00 00 00 
  80262a:	ff d0                	callq  *%rax
  80262c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802630:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802634:	48 c1 e8 15          	shr    $0x15,%rax
  802638:	48 89 c2             	mov    %rax,%rdx
  80263b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802642:	01 00 00 
  802645:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802649:	83 e0 01             	and    $0x1,%eax
  80264c:	48 85 c0             	test   %rax,%rax
  80264f:	74 73                	je     8026c4 <dup+0x11d>
  802651:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802655:	48 c1 e8 0c          	shr    $0xc,%rax
  802659:	48 89 c2             	mov    %rax,%rdx
  80265c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802663:	01 00 00 
  802666:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80266a:	83 e0 01             	and    $0x1,%eax
  80266d:	48 85 c0             	test   %rax,%rax
  802670:	74 52                	je     8026c4 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802672:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802676:	48 c1 e8 0c          	shr    $0xc,%rax
  80267a:	48 89 c2             	mov    %rax,%rdx
  80267d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802684:	01 00 00 
  802687:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80268b:	25 07 0e 00 00       	and    $0xe07,%eax
  802690:	89 c1                	mov    %eax,%ecx
  802692:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802696:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80269a:	41 89 c8             	mov    %ecx,%r8d
  80269d:	48 89 d1             	mov    %rdx,%rcx
  8026a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8026a5:	48 89 c6             	mov    %rax,%rsi
  8026a8:	bf 00 00 00 00       	mov    $0x0,%edi
  8026ad:	48 b8 36 1d 80 00 00 	movabs $0x801d36,%rax
  8026b4:	00 00 00 
  8026b7:	ff d0                	callq  *%rax
  8026b9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026c0:	79 02                	jns    8026c4 <dup+0x11d>
			goto err;
  8026c2:	eb 57                	jmp    80271b <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8026c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026c8:	48 c1 e8 0c          	shr    $0xc,%rax
  8026cc:	48 89 c2             	mov    %rax,%rdx
  8026cf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8026d6:	01 00 00 
  8026d9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026dd:	25 07 0e 00 00       	and    $0xe07,%eax
  8026e2:	89 c1                	mov    %eax,%ecx
  8026e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026e8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8026ec:	41 89 c8             	mov    %ecx,%r8d
  8026ef:	48 89 d1             	mov    %rdx,%rcx
  8026f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8026f7:	48 89 c6             	mov    %rax,%rsi
  8026fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8026ff:	48 b8 36 1d 80 00 00 	movabs $0x801d36,%rax
  802706:	00 00 00 
  802709:	ff d0                	callq  *%rax
  80270b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80270e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802712:	79 02                	jns    802716 <dup+0x16f>
		goto err;
  802714:	eb 05                	jmp    80271b <dup+0x174>

	return newfdnum;
  802716:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802719:	eb 33                	jmp    80274e <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  80271b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80271f:	48 89 c6             	mov    %rax,%rsi
  802722:	bf 00 00 00 00       	mov    $0x0,%edi
  802727:	48 b8 91 1d 80 00 00 	movabs $0x801d91,%rax
  80272e:	00 00 00 
  802731:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802733:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802737:	48 89 c6             	mov    %rax,%rsi
  80273a:	bf 00 00 00 00       	mov    $0x0,%edi
  80273f:	48 b8 91 1d 80 00 00 	movabs $0x801d91,%rax
  802746:	00 00 00 
  802749:	ff d0                	callq  *%rax
	return r;
  80274b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80274e:	c9                   	leaveq 
  80274f:	c3                   	retq   

0000000000802750 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802750:	55                   	push   %rbp
  802751:	48 89 e5             	mov    %rsp,%rbp
  802754:	48 83 ec 40          	sub    $0x40,%rsp
  802758:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80275b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80275f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802763:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802767:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80276a:	48 89 d6             	mov    %rdx,%rsi
  80276d:	89 c7                	mov    %eax,%edi
  80276f:	48 b8 1e 23 80 00 00 	movabs $0x80231e,%rax
  802776:	00 00 00 
  802779:	ff d0                	callq  *%rax
  80277b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80277e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802782:	78 24                	js     8027a8 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802784:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802788:	8b 00                	mov    (%rax),%eax
  80278a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80278e:	48 89 d6             	mov    %rdx,%rsi
  802791:	89 c7                	mov    %eax,%edi
  802793:	48 b8 77 24 80 00 00 	movabs $0x802477,%rax
  80279a:	00 00 00 
  80279d:	ff d0                	callq  *%rax
  80279f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027a6:	79 05                	jns    8027ad <read+0x5d>
		return r;
  8027a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027ab:	eb 76                	jmp    802823 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8027ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027b1:	8b 40 08             	mov    0x8(%rax),%eax
  8027b4:	83 e0 03             	and    $0x3,%eax
  8027b7:	83 f8 01             	cmp    $0x1,%eax
  8027ba:	75 3a                	jne    8027f6 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8027bc:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  8027c3:	00 00 00 
  8027c6:	48 8b 00             	mov    (%rax),%rax
  8027c9:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8027cf:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8027d2:	89 c6                	mov    %eax,%esi
  8027d4:	48 bf 2f 44 80 00 00 	movabs $0x80442f,%rdi
  8027db:	00 00 00 
  8027de:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e3:	48 b9 02 08 80 00 00 	movabs $0x800802,%rcx
  8027ea:	00 00 00 
  8027ed:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8027ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027f4:	eb 2d                	jmp    802823 <read+0xd3>
	}
	if (!dev->dev_read)
  8027f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027fa:	48 8b 40 10          	mov    0x10(%rax),%rax
  8027fe:	48 85 c0             	test   %rax,%rax
  802801:	75 07                	jne    80280a <read+0xba>
		return -E_NOT_SUPP;
  802803:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802808:	eb 19                	jmp    802823 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80280a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80280e:	48 8b 40 10          	mov    0x10(%rax),%rax
  802812:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802816:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80281a:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80281e:	48 89 cf             	mov    %rcx,%rdi
  802821:	ff d0                	callq  *%rax
}
  802823:	c9                   	leaveq 
  802824:	c3                   	retq   

0000000000802825 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802825:	55                   	push   %rbp
  802826:	48 89 e5             	mov    %rsp,%rbp
  802829:	48 83 ec 30          	sub    $0x30,%rsp
  80282d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802830:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802834:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802838:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80283f:	eb 49                	jmp    80288a <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802841:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802844:	48 98                	cltq   
  802846:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80284a:	48 29 c2             	sub    %rax,%rdx
  80284d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802850:	48 63 c8             	movslq %eax,%rcx
  802853:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802857:	48 01 c1             	add    %rax,%rcx
  80285a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80285d:	48 89 ce             	mov    %rcx,%rsi
  802860:	89 c7                	mov    %eax,%edi
  802862:	48 b8 50 27 80 00 00 	movabs $0x802750,%rax
  802869:	00 00 00 
  80286c:	ff d0                	callq  *%rax
  80286e:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802871:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802875:	79 05                	jns    80287c <readn+0x57>
			return m;
  802877:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80287a:	eb 1c                	jmp    802898 <readn+0x73>
		if (m == 0)
  80287c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802880:	75 02                	jne    802884 <readn+0x5f>
			break;
  802882:	eb 11                	jmp    802895 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802884:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802887:	01 45 fc             	add    %eax,-0x4(%rbp)
  80288a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80288d:	48 98                	cltq   
  80288f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802893:	72 ac                	jb     802841 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802895:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802898:	c9                   	leaveq 
  802899:	c3                   	retq   

000000000080289a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80289a:	55                   	push   %rbp
  80289b:	48 89 e5             	mov    %rsp,%rbp
  80289e:	48 83 ec 40          	sub    $0x40,%rsp
  8028a2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8028a5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8028a9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8028ad:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8028b1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8028b4:	48 89 d6             	mov    %rdx,%rsi
  8028b7:	89 c7                	mov    %eax,%edi
  8028b9:	48 b8 1e 23 80 00 00 	movabs $0x80231e,%rax
  8028c0:	00 00 00 
  8028c3:	ff d0                	callq  *%rax
  8028c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028cc:	78 24                	js     8028f2 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8028ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028d2:	8b 00                	mov    (%rax),%eax
  8028d4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028d8:	48 89 d6             	mov    %rdx,%rsi
  8028db:	89 c7                	mov    %eax,%edi
  8028dd:	48 b8 77 24 80 00 00 	movabs $0x802477,%rax
  8028e4:	00 00 00 
  8028e7:	ff d0                	callq  *%rax
  8028e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028f0:	79 05                	jns    8028f7 <write+0x5d>
		return r;
  8028f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028f5:	eb 75                	jmp    80296c <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8028f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028fb:	8b 40 08             	mov    0x8(%rax),%eax
  8028fe:	83 e0 03             	and    $0x3,%eax
  802901:	85 c0                	test   %eax,%eax
  802903:	75 3a                	jne    80293f <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802905:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  80290c:	00 00 00 
  80290f:	48 8b 00             	mov    (%rax),%rax
  802912:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802918:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80291b:	89 c6                	mov    %eax,%esi
  80291d:	48 bf 4b 44 80 00 00 	movabs $0x80444b,%rdi
  802924:	00 00 00 
  802927:	b8 00 00 00 00       	mov    $0x0,%eax
  80292c:	48 b9 02 08 80 00 00 	movabs $0x800802,%rcx
  802933:	00 00 00 
  802936:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802938:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80293d:	eb 2d                	jmp    80296c <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80293f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802943:	48 8b 40 18          	mov    0x18(%rax),%rax
  802947:	48 85 c0             	test   %rax,%rax
  80294a:	75 07                	jne    802953 <write+0xb9>
		return -E_NOT_SUPP;
  80294c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802951:	eb 19                	jmp    80296c <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802953:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802957:	48 8b 40 18          	mov    0x18(%rax),%rax
  80295b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80295f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802963:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802967:	48 89 cf             	mov    %rcx,%rdi
  80296a:	ff d0                	callq  *%rax
}
  80296c:	c9                   	leaveq 
  80296d:	c3                   	retq   

000000000080296e <seek>:

int
seek(int fdnum, off_t offset)
{
  80296e:	55                   	push   %rbp
  80296f:	48 89 e5             	mov    %rsp,%rbp
  802972:	48 83 ec 18          	sub    $0x18,%rsp
  802976:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802979:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80297c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802980:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802983:	48 89 d6             	mov    %rdx,%rsi
  802986:	89 c7                	mov    %eax,%edi
  802988:	48 b8 1e 23 80 00 00 	movabs $0x80231e,%rax
  80298f:	00 00 00 
  802992:	ff d0                	callq  *%rax
  802994:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802997:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80299b:	79 05                	jns    8029a2 <seek+0x34>
		return r;
  80299d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029a0:	eb 0f                	jmp    8029b1 <seek+0x43>
	fd->fd_offset = offset;
  8029a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029a6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8029a9:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8029ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029b1:	c9                   	leaveq 
  8029b2:	c3                   	retq   

00000000008029b3 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8029b3:	55                   	push   %rbp
  8029b4:	48 89 e5             	mov    %rsp,%rbp
  8029b7:	48 83 ec 30          	sub    $0x30,%rsp
  8029bb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8029be:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8029c1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029c5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029c8:	48 89 d6             	mov    %rdx,%rsi
  8029cb:	89 c7                	mov    %eax,%edi
  8029cd:	48 b8 1e 23 80 00 00 	movabs $0x80231e,%rax
  8029d4:	00 00 00 
  8029d7:	ff d0                	callq  *%rax
  8029d9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029e0:	78 24                	js     802a06 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8029e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029e6:	8b 00                	mov    (%rax),%eax
  8029e8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029ec:	48 89 d6             	mov    %rdx,%rsi
  8029ef:	89 c7                	mov    %eax,%edi
  8029f1:	48 b8 77 24 80 00 00 	movabs $0x802477,%rax
  8029f8:	00 00 00 
  8029fb:	ff d0                	callq  *%rax
  8029fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a00:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a04:	79 05                	jns    802a0b <ftruncate+0x58>
		return r;
  802a06:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a09:	eb 72                	jmp    802a7d <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802a0b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a0f:	8b 40 08             	mov    0x8(%rax),%eax
  802a12:	83 e0 03             	and    $0x3,%eax
  802a15:	85 c0                	test   %eax,%eax
  802a17:	75 3a                	jne    802a53 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802a19:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  802a20:	00 00 00 
  802a23:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802a26:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a2c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a2f:	89 c6                	mov    %eax,%esi
  802a31:	48 bf 68 44 80 00 00 	movabs $0x804468,%rdi
  802a38:	00 00 00 
  802a3b:	b8 00 00 00 00       	mov    $0x0,%eax
  802a40:	48 b9 02 08 80 00 00 	movabs $0x800802,%rcx
  802a47:	00 00 00 
  802a4a:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802a4c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a51:	eb 2a                	jmp    802a7d <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802a53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a57:	48 8b 40 30          	mov    0x30(%rax),%rax
  802a5b:	48 85 c0             	test   %rax,%rax
  802a5e:	75 07                	jne    802a67 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802a60:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a65:	eb 16                	jmp    802a7d <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802a67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a6b:	48 8b 40 30          	mov    0x30(%rax),%rax
  802a6f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a73:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802a76:	89 ce                	mov    %ecx,%esi
  802a78:	48 89 d7             	mov    %rdx,%rdi
  802a7b:	ff d0                	callq  *%rax
}
  802a7d:	c9                   	leaveq 
  802a7e:	c3                   	retq   

0000000000802a7f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802a7f:	55                   	push   %rbp
  802a80:	48 89 e5             	mov    %rsp,%rbp
  802a83:	48 83 ec 30          	sub    $0x30,%rsp
  802a87:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a8a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a8e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a92:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a95:	48 89 d6             	mov    %rdx,%rsi
  802a98:	89 c7                	mov    %eax,%edi
  802a9a:	48 b8 1e 23 80 00 00 	movabs $0x80231e,%rax
  802aa1:	00 00 00 
  802aa4:	ff d0                	callq  *%rax
  802aa6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aa9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802aad:	78 24                	js     802ad3 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802aaf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ab3:	8b 00                	mov    (%rax),%eax
  802ab5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ab9:	48 89 d6             	mov    %rdx,%rsi
  802abc:	89 c7                	mov    %eax,%edi
  802abe:	48 b8 77 24 80 00 00 	movabs $0x802477,%rax
  802ac5:	00 00 00 
  802ac8:	ff d0                	callq  *%rax
  802aca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802acd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ad1:	79 05                	jns    802ad8 <fstat+0x59>
		return r;
  802ad3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ad6:	eb 5e                	jmp    802b36 <fstat+0xb7>
	if (!dev->dev_stat)
  802ad8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802adc:	48 8b 40 28          	mov    0x28(%rax),%rax
  802ae0:	48 85 c0             	test   %rax,%rax
  802ae3:	75 07                	jne    802aec <fstat+0x6d>
		return -E_NOT_SUPP;
  802ae5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802aea:	eb 4a                	jmp    802b36 <fstat+0xb7>
	stat->st_name[0] = 0;
  802aec:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802af0:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802af3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802af7:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802afe:	00 00 00 
	stat->st_isdir = 0;
  802b01:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b05:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802b0c:	00 00 00 
	stat->st_dev = dev;
  802b0f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b13:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b17:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802b1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b22:	48 8b 40 28          	mov    0x28(%rax),%rax
  802b26:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b2a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802b2e:	48 89 ce             	mov    %rcx,%rsi
  802b31:	48 89 d7             	mov    %rdx,%rdi
  802b34:	ff d0                	callq  *%rax
}
  802b36:	c9                   	leaveq 
  802b37:	c3                   	retq   

0000000000802b38 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802b38:	55                   	push   %rbp
  802b39:	48 89 e5             	mov    %rsp,%rbp
  802b3c:	48 83 ec 20          	sub    $0x20,%rsp
  802b40:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b44:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802b48:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b4c:	be 00 00 00 00       	mov    $0x0,%esi
  802b51:	48 89 c7             	mov    %rax,%rdi
  802b54:	48 b8 26 2c 80 00 00 	movabs $0x802c26,%rax
  802b5b:	00 00 00 
  802b5e:	ff d0                	callq  *%rax
  802b60:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b63:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b67:	79 05                	jns    802b6e <stat+0x36>
		return fd;
  802b69:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b6c:	eb 2f                	jmp    802b9d <stat+0x65>
	r = fstat(fd, stat);
  802b6e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802b72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b75:	48 89 d6             	mov    %rdx,%rsi
  802b78:	89 c7                	mov    %eax,%edi
  802b7a:	48 b8 7f 2a 80 00 00 	movabs $0x802a7f,%rax
  802b81:	00 00 00 
  802b84:	ff d0                	callq  *%rax
  802b86:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802b89:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b8c:	89 c7                	mov    %eax,%edi
  802b8e:	48 b8 2e 25 80 00 00 	movabs $0x80252e,%rax
  802b95:	00 00 00 
  802b98:	ff d0                	callq  *%rax
	return r;
  802b9a:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802b9d:	c9                   	leaveq 
  802b9e:	c3                   	retq   

0000000000802b9f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802b9f:	55                   	push   %rbp
  802ba0:	48 89 e5             	mov    %rsp,%rbp
  802ba3:	48 83 ec 10          	sub    $0x10,%rsp
  802ba7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802baa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802bae:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802bb5:	00 00 00 
  802bb8:	8b 00                	mov    (%rax),%eax
  802bba:	85 c0                	test   %eax,%eax
  802bbc:	75 1d                	jne    802bdb <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802bbe:	bf 01 00 00 00       	mov    $0x1,%edi
  802bc3:	48 b8 49 3d 80 00 00 	movabs $0x803d49,%rax
  802bca:	00 00 00 
  802bcd:	ff d0                	callq  *%rax
  802bcf:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802bd6:	00 00 00 
  802bd9:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802bdb:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802be2:	00 00 00 
  802be5:	8b 00                	mov    (%rax),%eax
  802be7:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802bea:	b9 07 00 00 00       	mov    $0x7,%ecx
  802bef:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802bf6:	00 00 00 
  802bf9:	89 c7                	mov    %eax,%edi
  802bfb:	48 b8 e7 3c 80 00 00 	movabs $0x803ce7,%rax
  802c02:	00 00 00 
  802c05:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802c07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c0b:	ba 00 00 00 00       	mov    $0x0,%edx
  802c10:	48 89 c6             	mov    %rax,%rsi
  802c13:	bf 00 00 00 00       	mov    $0x0,%edi
  802c18:	48 b8 e1 3b 80 00 00 	movabs $0x803be1,%rax
  802c1f:	00 00 00 
  802c22:	ff d0                	callq  *%rax
}
  802c24:	c9                   	leaveq 
  802c25:	c3                   	retq   

0000000000802c26 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802c26:	55                   	push   %rbp
  802c27:	48 89 e5             	mov    %rsp,%rbp
  802c2a:	48 83 ec 30          	sub    $0x30,%rsp
  802c2e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802c32:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802c35:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802c3c:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802c43:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802c4a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802c4f:	75 08                	jne    802c59 <open+0x33>
	{
		return r;
  802c51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c54:	e9 f2 00 00 00       	jmpq   802d4b <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802c59:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c5d:	48 89 c7             	mov    %rax,%rdi
  802c60:	48 b8 4b 13 80 00 00 	movabs $0x80134b,%rax
  802c67:	00 00 00 
  802c6a:	ff d0                	callq  *%rax
  802c6c:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802c6f:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802c76:	7e 0a                	jle    802c82 <open+0x5c>
	{
		return -E_BAD_PATH;
  802c78:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802c7d:	e9 c9 00 00 00       	jmpq   802d4b <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802c82:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802c89:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802c8a:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802c8e:	48 89 c7             	mov    %rax,%rdi
  802c91:	48 b8 86 22 80 00 00 	movabs $0x802286,%rax
  802c98:	00 00 00 
  802c9b:	ff d0                	callq  *%rax
  802c9d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ca0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ca4:	78 09                	js     802caf <open+0x89>
  802ca6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802caa:	48 85 c0             	test   %rax,%rax
  802cad:	75 08                	jne    802cb7 <open+0x91>
		{
			return r;
  802caf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cb2:	e9 94 00 00 00       	jmpq   802d4b <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802cb7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802cbb:	ba 00 04 00 00       	mov    $0x400,%edx
  802cc0:	48 89 c6             	mov    %rax,%rsi
  802cc3:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802cca:	00 00 00 
  802ccd:	48 b8 49 14 80 00 00 	movabs $0x801449,%rax
  802cd4:	00 00 00 
  802cd7:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802cd9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ce0:	00 00 00 
  802ce3:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802ce6:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802cec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cf0:	48 89 c6             	mov    %rax,%rsi
  802cf3:	bf 01 00 00 00       	mov    $0x1,%edi
  802cf8:	48 b8 9f 2b 80 00 00 	movabs $0x802b9f,%rax
  802cff:	00 00 00 
  802d02:	ff d0                	callq  *%rax
  802d04:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d07:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d0b:	79 2b                	jns    802d38 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802d0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d11:	be 00 00 00 00       	mov    $0x0,%esi
  802d16:	48 89 c7             	mov    %rax,%rdi
  802d19:	48 b8 ae 23 80 00 00 	movabs $0x8023ae,%rax
  802d20:	00 00 00 
  802d23:	ff d0                	callq  *%rax
  802d25:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802d28:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802d2c:	79 05                	jns    802d33 <open+0x10d>
			{
				return d;
  802d2e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d31:	eb 18                	jmp    802d4b <open+0x125>
			}
			return r;
  802d33:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d36:	eb 13                	jmp    802d4b <open+0x125>
		}	
		return fd2num(fd_store);
  802d38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d3c:	48 89 c7             	mov    %rax,%rdi
  802d3f:	48 b8 38 22 80 00 00 	movabs $0x802238,%rax
  802d46:	00 00 00 
  802d49:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802d4b:	c9                   	leaveq 
  802d4c:	c3                   	retq   

0000000000802d4d <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802d4d:	55                   	push   %rbp
  802d4e:	48 89 e5             	mov    %rsp,%rbp
  802d51:	48 83 ec 10          	sub    $0x10,%rsp
  802d55:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802d59:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d5d:	8b 50 0c             	mov    0xc(%rax),%edx
  802d60:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d67:	00 00 00 
  802d6a:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802d6c:	be 00 00 00 00       	mov    $0x0,%esi
  802d71:	bf 06 00 00 00       	mov    $0x6,%edi
  802d76:	48 b8 9f 2b 80 00 00 	movabs $0x802b9f,%rax
  802d7d:	00 00 00 
  802d80:	ff d0                	callq  *%rax
}
  802d82:	c9                   	leaveq 
  802d83:	c3                   	retq   

0000000000802d84 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802d84:	55                   	push   %rbp
  802d85:	48 89 e5             	mov    %rsp,%rbp
  802d88:	48 83 ec 30          	sub    $0x30,%rsp
  802d8c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d90:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d94:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802d98:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802d9f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802da4:	74 07                	je     802dad <devfile_read+0x29>
  802da6:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802dab:	75 07                	jne    802db4 <devfile_read+0x30>
		return -E_INVAL;
  802dad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802db2:	eb 77                	jmp    802e2b <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802db4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802db8:	8b 50 0c             	mov    0xc(%rax),%edx
  802dbb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802dc2:	00 00 00 
  802dc5:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802dc7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802dce:	00 00 00 
  802dd1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802dd5:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802dd9:	be 00 00 00 00       	mov    $0x0,%esi
  802dde:	bf 03 00 00 00       	mov    $0x3,%edi
  802de3:	48 b8 9f 2b 80 00 00 	movabs $0x802b9f,%rax
  802dea:	00 00 00 
  802ded:	ff d0                	callq  *%rax
  802def:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802df2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802df6:	7f 05                	jg     802dfd <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802df8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dfb:	eb 2e                	jmp    802e2b <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802dfd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e00:	48 63 d0             	movslq %eax,%rdx
  802e03:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e07:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802e0e:	00 00 00 
  802e11:	48 89 c7             	mov    %rax,%rdi
  802e14:	48 b8 db 16 80 00 00 	movabs $0x8016db,%rax
  802e1b:	00 00 00 
  802e1e:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802e20:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e24:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802e28:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802e2b:	c9                   	leaveq 
  802e2c:	c3                   	retq   

0000000000802e2d <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802e2d:	55                   	push   %rbp
  802e2e:	48 89 e5             	mov    %rsp,%rbp
  802e31:	48 83 ec 30          	sub    $0x30,%rsp
  802e35:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e39:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e3d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802e41:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802e48:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802e4d:	74 07                	je     802e56 <devfile_write+0x29>
  802e4f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802e54:	75 08                	jne    802e5e <devfile_write+0x31>
		return r;
  802e56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e59:	e9 9a 00 00 00       	jmpq   802ef8 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802e5e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e62:	8b 50 0c             	mov    0xc(%rax),%edx
  802e65:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e6c:	00 00 00 
  802e6f:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802e71:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802e78:	00 
  802e79:	76 08                	jbe    802e83 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802e7b:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802e82:	00 
	}
	fsipcbuf.write.req_n = n;
  802e83:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e8a:	00 00 00 
  802e8d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e91:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802e95:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e99:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e9d:	48 89 c6             	mov    %rax,%rsi
  802ea0:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802ea7:	00 00 00 
  802eaa:	48 b8 db 16 80 00 00 	movabs $0x8016db,%rax
  802eb1:	00 00 00 
  802eb4:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802eb6:	be 00 00 00 00       	mov    $0x0,%esi
  802ebb:	bf 04 00 00 00       	mov    $0x4,%edi
  802ec0:	48 b8 9f 2b 80 00 00 	movabs $0x802b9f,%rax
  802ec7:	00 00 00 
  802eca:	ff d0                	callq  *%rax
  802ecc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ecf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ed3:	7f 20                	jg     802ef5 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802ed5:	48 bf 8e 44 80 00 00 	movabs $0x80448e,%rdi
  802edc:	00 00 00 
  802edf:	b8 00 00 00 00       	mov    $0x0,%eax
  802ee4:	48 ba 02 08 80 00 00 	movabs $0x800802,%rdx
  802eeb:	00 00 00 
  802eee:	ff d2                	callq  *%rdx
		return r;
  802ef0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ef3:	eb 03                	jmp    802ef8 <devfile_write+0xcb>
	}
	return r;
  802ef5:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802ef8:	c9                   	leaveq 
  802ef9:	c3                   	retq   

0000000000802efa <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802efa:	55                   	push   %rbp
  802efb:	48 89 e5             	mov    %rsp,%rbp
  802efe:	48 83 ec 20          	sub    $0x20,%rsp
  802f02:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f06:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802f0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f0e:	8b 50 0c             	mov    0xc(%rax),%edx
  802f11:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f18:	00 00 00 
  802f1b:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802f1d:	be 00 00 00 00       	mov    $0x0,%esi
  802f22:	bf 05 00 00 00       	mov    $0x5,%edi
  802f27:	48 b8 9f 2b 80 00 00 	movabs $0x802b9f,%rax
  802f2e:	00 00 00 
  802f31:	ff d0                	callq  *%rax
  802f33:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f36:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f3a:	79 05                	jns    802f41 <devfile_stat+0x47>
		return r;
  802f3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f3f:	eb 56                	jmp    802f97 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802f41:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f45:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802f4c:	00 00 00 
  802f4f:	48 89 c7             	mov    %rax,%rdi
  802f52:	48 b8 b7 13 80 00 00 	movabs $0x8013b7,%rax
  802f59:	00 00 00 
  802f5c:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802f5e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f65:	00 00 00 
  802f68:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802f6e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f72:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802f78:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f7f:	00 00 00 
  802f82:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802f88:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f8c:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802f92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f97:	c9                   	leaveq 
  802f98:	c3                   	retq   

0000000000802f99 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802f99:	55                   	push   %rbp
  802f9a:	48 89 e5             	mov    %rsp,%rbp
  802f9d:	48 83 ec 10          	sub    $0x10,%rsp
  802fa1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802fa5:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802fa8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fac:	8b 50 0c             	mov    0xc(%rax),%edx
  802faf:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fb6:	00 00 00 
  802fb9:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802fbb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fc2:	00 00 00 
  802fc5:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802fc8:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802fcb:	be 00 00 00 00       	mov    $0x0,%esi
  802fd0:	bf 02 00 00 00       	mov    $0x2,%edi
  802fd5:	48 b8 9f 2b 80 00 00 	movabs $0x802b9f,%rax
  802fdc:	00 00 00 
  802fdf:	ff d0                	callq  *%rax
}
  802fe1:	c9                   	leaveq 
  802fe2:	c3                   	retq   

0000000000802fe3 <remove>:

// Delete a file
int
remove(const char *path)
{
  802fe3:	55                   	push   %rbp
  802fe4:	48 89 e5             	mov    %rsp,%rbp
  802fe7:	48 83 ec 10          	sub    $0x10,%rsp
  802feb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802fef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ff3:	48 89 c7             	mov    %rax,%rdi
  802ff6:	48 b8 4b 13 80 00 00 	movabs $0x80134b,%rax
  802ffd:	00 00 00 
  803000:	ff d0                	callq  *%rax
  803002:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803007:	7e 07                	jle    803010 <remove+0x2d>
		return -E_BAD_PATH;
  803009:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80300e:	eb 33                	jmp    803043 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803010:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803014:	48 89 c6             	mov    %rax,%rsi
  803017:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80301e:	00 00 00 
  803021:	48 b8 b7 13 80 00 00 	movabs $0x8013b7,%rax
  803028:	00 00 00 
  80302b:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80302d:	be 00 00 00 00       	mov    $0x0,%esi
  803032:	bf 07 00 00 00       	mov    $0x7,%edi
  803037:	48 b8 9f 2b 80 00 00 	movabs $0x802b9f,%rax
  80303e:	00 00 00 
  803041:	ff d0                	callq  *%rax
}
  803043:	c9                   	leaveq 
  803044:	c3                   	retq   

0000000000803045 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803045:	55                   	push   %rbp
  803046:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803049:	be 00 00 00 00       	mov    $0x0,%esi
  80304e:	bf 08 00 00 00       	mov    $0x8,%edi
  803053:	48 b8 9f 2b 80 00 00 	movabs $0x802b9f,%rax
  80305a:	00 00 00 
  80305d:	ff d0                	callq  *%rax
}
  80305f:	5d                   	pop    %rbp
  803060:	c3                   	retq   

0000000000803061 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  803061:	55                   	push   %rbp
  803062:	48 89 e5             	mov    %rsp,%rbp
  803065:	48 83 ec 20          	sub    $0x20,%rsp
  803069:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  80306d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803071:	8b 40 0c             	mov    0xc(%rax),%eax
  803074:	85 c0                	test   %eax,%eax
  803076:	7e 67                	jle    8030df <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  803078:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80307c:	8b 40 04             	mov    0x4(%rax),%eax
  80307f:	48 63 d0             	movslq %eax,%rdx
  803082:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803086:	48 8d 48 10          	lea    0x10(%rax),%rcx
  80308a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80308e:	8b 00                	mov    (%rax),%eax
  803090:	48 89 ce             	mov    %rcx,%rsi
  803093:	89 c7                	mov    %eax,%edi
  803095:	48 b8 9a 28 80 00 00 	movabs $0x80289a,%rax
  80309c:	00 00 00 
  80309f:	ff d0                	callq  *%rax
  8030a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  8030a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030a8:	7e 13                	jle    8030bd <writebuf+0x5c>
			b->result += result;
  8030aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030ae:	8b 50 08             	mov    0x8(%rax),%edx
  8030b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030b4:	01 c2                	add    %eax,%edx
  8030b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030ba:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  8030bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030c1:	8b 40 04             	mov    0x4(%rax),%eax
  8030c4:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8030c7:	74 16                	je     8030df <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  8030c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8030ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030d2:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  8030d6:	89 c2                	mov    %eax,%edx
  8030d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030dc:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  8030df:	c9                   	leaveq 
  8030e0:	c3                   	retq   

00000000008030e1 <putch>:

static void
putch(int ch, void *thunk)
{
  8030e1:	55                   	push   %rbp
  8030e2:	48 89 e5             	mov    %rsp,%rbp
  8030e5:	48 83 ec 20          	sub    $0x20,%rsp
  8030e9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8030ec:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  8030f0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030f4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  8030f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030fc:	8b 40 04             	mov    0x4(%rax),%eax
  8030ff:	8d 48 01             	lea    0x1(%rax),%ecx
  803102:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803106:	89 4a 04             	mov    %ecx,0x4(%rdx)
  803109:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80310c:	89 d1                	mov    %edx,%ecx
  80310e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803112:	48 98                	cltq   
  803114:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  803118:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80311c:	8b 40 04             	mov    0x4(%rax),%eax
  80311f:	3d 00 01 00 00       	cmp    $0x100,%eax
  803124:	75 1e                	jne    803144 <putch+0x63>
		writebuf(b);
  803126:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80312a:	48 89 c7             	mov    %rax,%rdi
  80312d:	48 b8 61 30 80 00 00 	movabs $0x803061,%rax
  803134:	00 00 00 
  803137:	ff d0                	callq  *%rax
		b->idx = 0;
  803139:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80313d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  803144:	c9                   	leaveq 
  803145:	c3                   	retq   

0000000000803146 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  803146:	55                   	push   %rbp
  803147:	48 89 e5             	mov    %rsp,%rbp
  80314a:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  803151:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  803157:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  80315e:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  803165:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  80316b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  803171:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  803178:	00 00 00 
	b.result = 0;
  80317b:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  803182:	00 00 00 
	b.error = 1;
  803185:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  80318c:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  80318f:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  803196:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  80319d:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8031a4:	48 89 c6             	mov    %rax,%rsi
  8031a7:	48 bf e1 30 80 00 00 	movabs $0x8030e1,%rdi
  8031ae:	00 00 00 
  8031b1:	48 b8 b5 0b 80 00 00 	movabs $0x800bb5,%rax
  8031b8:	00 00 00 
  8031bb:	ff d0                	callq  *%rax
	if (b.idx > 0)
  8031bd:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  8031c3:	85 c0                	test   %eax,%eax
  8031c5:	7e 16                	jle    8031dd <vfprintf+0x97>
		writebuf(&b);
  8031c7:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8031ce:	48 89 c7             	mov    %rax,%rdi
  8031d1:	48 b8 61 30 80 00 00 	movabs $0x803061,%rax
  8031d8:	00 00 00 
  8031db:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  8031dd:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  8031e3:	85 c0                	test   %eax,%eax
  8031e5:	74 08                	je     8031ef <vfprintf+0xa9>
  8031e7:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  8031ed:	eb 06                	jmp    8031f5 <vfprintf+0xaf>
  8031ef:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  8031f5:	c9                   	leaveq 
  8031f6:	c3                   	retq   

00000000008031f7 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  8031f7:	55                   	push   %rbp
  8031f8:	48 89 e5             	mov    %rsp,%rbp
  8031fb:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  803202:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  803208:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80320f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803216:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80321d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803224:	84 c0                	test   %al,%al
  803226:	74 20                	je     803248 <fprintf+0x51>
  803228:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80322c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803230:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803234:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803238:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80323c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803240:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803244:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803248:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80324f:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  803256:	00 00 00 
  803259:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803260:	00 00 00 
  803263:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803267:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80326e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803275:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  80327c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803283:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  80328a:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803290:	48 89 ce             	mov    %rcx,%rsi
  803293:	89 c7                	mov    %eax,%edi
  803295:	48 b8 46 31 80 00 00 	movabs $0x803146,%rax
  80329c:	00 00 00 
  80329f:	ff d0                	callq  *%rax
  8032a1:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  8032a7:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8032ad:	c9                   	leaveq 
  8032ae:	c3                   	retq   

00000000008032af <printf>:

int
printf(const char *fmt, ...)
{
  8032af:	55                   	push   %rbp
  8032b0:	48 89 e5             	mov    %rsp,%rbp
  8032b3:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  8032ba:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8032c1:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8032c8:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8032cf:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8032d6:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8032dd:	84 c0                	test   %al,%al
  8032df:	74 20                	je     803301 <printf+0x52>
  8032e1:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8032e5:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8032e9:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8032ed:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8032f1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8032f5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8032f9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8032fd:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803301:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  803308:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80330f:	00 00 00 
  803312:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803319:	00 00 00 
  80331c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803320:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803327:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80332e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  803335:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80333c:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803343:	48 89 c6             	mov    %rax,%rsi
  803346:	bf 01 00 00 00       	mov    $0x1,%edi
  80334b:	48 b8 46 31 80 00 00 	movabs $0x803146,%rax
  803352:	00 00 00 
  803355:	ff d0                	callq  *%rax
  803357:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  80335d:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803363:	c9                   	leaveq 
  803364:	c3                   	retq   

0000000000803365 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803365:	55                   	push   %rbp
  803366:	48 89 e5             	mov    %rsp,%rbp
  803369:	53                   	push   %rbx
  80336a:	48 83 ec 38          	sub    $0x38,%rsp
  80336e:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803372:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803376:	48 89 c7             	mov    %rax,%rdi
  803379:	48 b8 86 22 80 00 00 	movabs $0x802286,%rax
  803380:	00 00 00 
  803383:	ff d0                	callq  *%rax
  803385:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803388:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80338c:	0f 88 bf 01 00 00    	js     803551 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803392:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803396:	ba 07 04 00 00       	mov    $0x407,%edx
  80339b:	48 89 c6             	mov    %rax,%rsi
  80339e:	bf 00 00 00 00       	mov    $0x0,%edi
  8033a3:	48 b8 e6 1c 80 00 00 	movabs $0x801ce6,%rax
  8033aa:	00 00 00 
  8033ad:	ff d0                	callq  *%rax
  8033af:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8033b2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8033b6:	0f 88 95 01 00 00    	js     803551 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8033bc:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8033c0:	48 89 c7             	mov    %rax,%rdi
  8033c3:	48 b8 86 22 80 00 00 	movabs $0x802286,%rax
  8033ca:	00 00 00 
  8033cd:	ff d0                	callq  *%rax
  8033cf:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8033d2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8033d6:	0f 88 5d 01 00 00    	js     803539 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8033dc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033e0:	ba 07 04 00 00       	mov    $0x407,%edx
  8033e5:	48 89 c6             	mov    %rax,%rsi
  8033e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8033ed:	48 b8 e6 1c 80 00 00 	movabs $0x801ce6,%rax
  8033f4:	00 00 00 
  8033f7:	ff d0                	callq  *%rax
  8033f9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8033fc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803400:	0f 88 33 01 00 00    	js     803539 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803406:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80340a:	48 89 c7             	mov    %rax,%rdi
  80340d:	48 b8 5b 22 80 00 00 	movabs $0x80225b,%rax
  803414:	00 00 00 
  803417:	ff d0                	callq  *%rax
  803419:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80341d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803421:	ba 07 04 00 00       	mov    $0x407,%edx
  803426:	48 89 c6             	mov    %rax,%rsi
  803429:	bf 00 00 00 00       	mov    $0x0,%edi
  80342e:	48 b8 e6 1c 80 00 00 	movabs $0x801ce6,%rax
  803435:	00 00 00 
  803438:	ff d0                	callq  *%rax
  80343a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80343d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803441:	79 05                	jns    803448 <pipe+0xe3>
		goto err2;
  803443:	e9 d9 00 00 00       	jmpq   803521 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803448:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80344c:	48 89 c7             	mov    %rax,%rdi
  80344f:	48 b8 5b 22 80 00 00 	movabs $0x80225b,%rax
  803456:	00 00 00 
  803459:	ff d0                	callq  *%rax
  80345b:	48 89 c2             	mov    %rax,%rdx
  80345e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803462:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803468:	48 89 d1             	mov    %rdx,%rcx
  80346b:	ba 00 00 00 00       	mov    $0x0,%edx
  803470:	48 89 c6             	mov    %rax,%rsi
  803473:	bf 00 00 00 00       	mov    $0x0,%edi
  803478:	48 b8 36 1d 80 00 00 	movabs $0x801d36,%rax
  80347f:	00 00 00 
  803482:	ff d0                	callq  *%rax
  803484:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803487:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80348b:	79 1b                	jns    8034a8 <pipe+0x143>
		goto err3;
  80348d:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  80348e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803492:	48 89 c6             	mov    %rax,%rsi
  803495:	bf 00 00 00 00       	mov    $0x0,%edi
  80349a:	48 b8 91 1d 80 00 00 	movabs $0x801d91,%rax
  8034a1:	00 00 00 
  8034a4:	ff d0                	callq  *%rax
  8034a6:	eb 79                	jmp    803521 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8034a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034ac:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  8034b3:	00 00 00 
  8034b6:	8b 12                	mov    (%rdx),%edx
  8034b8:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8034ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034be:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8034c5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034c9:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  8034d0:	00 00 00 
  8034d3:	8b 12                	mov    (%rdx),%edx
  8034d5:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8034d7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034db:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8034e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034e6:	48 89 c7             	mov    %rax,%rdi
  8034e9:	48 b8 38 22 80 00 00 	movabs $0x802238,%rax
  8034f0:	00 00 00 
  8034f3:	ff d0                	callq  *%rax
  8034f5:	89 c2                	mov    %eax,%edx
  8034f7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8034fb:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8034fd:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803501:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803505:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803509:	48 89 c7             	mov    %rax,%rdi
  80350c:	48 b8 38 22 80 00 00 	movabs $0x802238,%rax
  803513:	00 00 00 
  803516:	ff d0                	callq  *%rax
  803518:	89 03                	mov    %eax,(%rbx)
	return 0;
  80351a:	b8 00 00 00 00       	mov    $0x0,%eax
  80351f:	eb 33                	jmp    803554 <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  803521:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803525:	48 89 c6             	mov    %rax,%rsi
  803528:	bf 00 00 00 00       	mov    $0x0,%edi
  80352d:	48 b8 91 1d 80 00 00 	movabs $0x801d91,%rax
  803534:	00 00 00 
  803537:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  803539:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80353d:	48 89 c6             	mov    %rax,%rsi
  803540:	bf 00 00 00 00       	mov    $0x0,%edi
  803545:	48 b8 91 1d 80 00 00 	movabs $0x801d91,%rax
  80354c:	00 00 00 
  80354f:	ff d0                	callq  *%rax
    err:
	return r;
  803551:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803554:	48 83 c4 38          	add    $0x38,%rsp
  803558:	5b                   	pop    %rbx
  803559:	5d                   	pop    %rbp
  80355a:	c3                   	retq   

000000000080355b <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80355b:	55                   	push   %rbp
  80355c:	48 89 e5             	mov    %rsp,%rbp
  80355f:	53                   	push   %rbx
  803560:	48 83 ec 28          	sub    $0x28,%rsp
  803564:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803568:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80356c:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803573:	00 00 00 
  803576:	48 8b 00             	mov    (%rax),%rax
  803579:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80357f:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803582:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803586:	48 89 c7             	mov    %rax,%rdi
  803589:	48 b8 cb 3d 80 00 00 	movabs $0x803dcb,%rax
  803590:	00 00 00 
  803593:	ff d0                	callq  *%rax
  803595:	89 c3                	mov    %eax,%ebx
  803597:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80359b:	48 89 c7             	mov    %rax,%rdi
  80359e:	48 b8 cb 3d 80 00 00 	movabs $0x803dcb,%rax
  8035a5:	00 00 00 
  8035a8:	ff d0                	callq  *%rax
  8035aa:	39 c3                	cmp    %eax,%ebx
  8035ac:	0f 94 c0             	sete   %al
  8035af:	0f b6 c0             	movzbl %al,%eax
  8035b2:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8035b5:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  8035bc:	00 00 00 
  8035bf:	48 8b 00             	mov    (%rax),%rax
  8035c2:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8035c8:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8035cb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035ce:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8035d1:	75 05                	jne    8035d8 <_pipeisclosed+0x7d>
			return ret;
  8035d3:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8035d6:	eb 4f                	jmp    803627 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8035d8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035db:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8035de:	74 42                	je     803622 <_pipeisclosed+0xc7>
  8035e0:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8035e4:	75 3c                	jne    803622 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8035e6:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  8035ed:	00 00 00 
  8035f0:	48 8b 00             	mov    (%rax),%rax
  8035f3:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8035f9:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8035fc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035ff:	89 c6                	mov    %eax,%esi
  803601:	48 bf af 44 80 00 00 	movabs $0x8044af,%rdi
  803608:	00 00 00 
  80360b:	b8 00 00 00 00       	mov    $0x0,%eax
  803610:	49 b8 02 08 80 00 00 	movabs $0x800802,%r8
  803617:	00 00 00 
  80361a:	41 ff d0             	callq  *%r8
	}
  80361d:	e9 4a ff ff ff       	jmpq   80356c <_pipeisclosed+0x11>
  803622:	e9 45 ff ff ff       	jmpq   80356c <_pipeisclosed+0x11>
}
  803627:	48 83 c4 28          	add    $0x28,%rsp
  80362b:	5b                   	pop    %rbx
  80362c:	5d                   	pop    %rbp
  80362d:	c3                   	retq   

000000000080362e <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80362e:	55                   	push   %rbp
  80362f:	48 89 e5             	mov    %rsp,%rbp
  803632:	48 83 ec 30          	sub    $0x30,%rsp
  803636:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803639:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80363d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803640:	48 89 d6             	mov    %rdx,%rsi
  803643:	89 c7                	mov    %eax,%edi
  803645:	48 b8 1e 23 80 00 00 	movabs $0x80231e,%rax
  80364c:	00 00 00 
  80364f:	ff d0                	callq  *%rax
  803651:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803654:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803658:	79 05                	jns    80365f <pipeisclosed+0x31>
		return r;
  80365a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80365d:	eb 31                	jmp    803690 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80365f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803663:	48 89 c7             	mov    %rax,%rdi
  803666:	48 b8 5b 22 80 00 00 	movabs $0x80225b,%rax
  80366d:	00 00 00 
  803670:	ff d0                	callq  *%rax
  803672:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803676:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80367a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80367e:	48 89 d6             	mov    %rdx,%rsi
  803681:	48 89 c7             	mov    %rax,%rdi
  803684:	48 b8 5b 35 80 00 00 	movabs $0x80355b,%rax
  80368b:	00 00 00 
  80368e:	ff d0                	callq  *%rax
}
  803690:	c9                   	leaveq 
  803691:	c3                   	retq   

0000000000803692 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803692:	55                   	push   %rbp
  803693:	48 89 e5             	mov    %rsp,%rbp
  803696:	48 83 ec 40          	sub    $0x40,%rsp
  80369a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80369e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8036a2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8036a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036aa:	48 89 c7             	mov    %rax,%rdi
  8036ad:	48 b8 5b 22 80 00 00 	movabs $0x80225b,%rax
  8036b4:	00 00 00 
  8036b7:	ff d0                	callq  *%rax
  8036b9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8036bd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036c1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8036c5:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8036cc:	00 
  8036cd:	e9 92 00 00 00       	jmpq   803764 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8036d2:	eb 41                	jmp    803715 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8036d4:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8036d9:	74 09                	je     8036e4 <devpipe_read+0x52>
				return i;
  8036db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036df:	e9 92 00 00 00       	jmpq   803776 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8036e4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8036e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036ec:	48 89 d6             	mov    %rdx,%rsi
  8036ef:	48 89 c7             	mov    %rax,%rdi
  8036f2:	48 b8 5b 35 80 00 00 	movabs $0x80355b,%rax
  8036f9:	00 00 00 
  8036fc:	ff d0                	callq  *%rax
  8036fe:	85 c0                	test   %eax,%eax
  803700:	74 07                	je     803709 <devpipe_read+0x77>
				return 0;
  803702:	b8 00 00 00 00       	mov    $0x0,%eax
  803707:	eb 6d                	jmp    803776 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803709:	48 b8 a8 1c 80 00 00 	movabs $0x801ca8,%rax
  803710:	00 00 00 
  803713:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803715:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803719:	8b 10                	mov    (%rax),%edx
  80371b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80371f:	8b 40 04             	mov    0x4(%rax),%eax
  803722:	39 c2                	cmp    %eax,%edx
  803724:	74 ae                	je     8036d4 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803726:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80372a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80372e:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803732:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803736:	8b 00                	mov    (%rax),%eax
  803738:	99                   	cltd   
  803739:	c1 ea 1b             	shr    $0x1b,%edx
  80373c:	01 d0                	add    %edx,%eax
  80373e:	83 e0 1f             	and    $0x1f,%eax
  803741:	29 d0                	sub    %edx,%eax
  803743:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803747:	48 98                	cltq   
  803749:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80374e:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803750:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803754:	8b 00                	mov    (%rax),%eax
  803756:	8d 50 01             	lea    0x1(%rax),%edx
  803759:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80375d:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80375f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803764:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803768:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80376c:	0f 82 60 ff ff ff    	jb     8036d2 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803772:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803776:	c9                   	leaveq 
  803777:	c3                   	retq   

0000000000803778 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803778:	55                   	push   %rbp
  803779:	48 89 e5             	mov    %rsp,%rbp
  80377c:	48 83 ec 40          	sub    $0x40,%rsp
  803780:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803784:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803788:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80378c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803790:	48 89 c7             	mov    %rax,%rdi
  803793:	48 b8 5b 22 80 00 00 	movabs $0x80225b,%rax
  80379a:	00 00 00 
  80379d:	ff d0                	callq  *%rax
  80379f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8037a3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037a7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8037ab:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8037b2:	00 
  8037b3:	e9 8e 00 00 00       	jmpq   803846 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8037b8:	eb 31                	jmp    8037eb <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8037ba:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8037be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037c2:	48 89 d6             	mov    %rdx,%rsi
  8037c5:	48 89 c7             	mov    %rax,%rdi
  8037c8:	48 b8 5b 35 80 00 00 	movabs $0x80355b,%rax
  8037cf:	00 00 00 
  8037d2:	ff d0                	callq  *%rax
  8037d4:	85 c0                	test   %eax,%eax
  8037d6:	74 07                	je     8037df <devpipe_write+0x67>
				return 0;
  8037d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8037dd:	eb 79                	jmp    803858 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8037df:	48 b8 a8 1c 80 00 00 	movabs $0x801ca8,%rax
  8037e6:	00 00 00 
  8037e9:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8037eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037ef:	8b 40 04             	mov    0x4(%rax),%eax
  8037f2:	48 63 d0             	movslq %eax,%rdx
  8037f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037f9:	8b 00                	mov    (%rax),%eax
  8037fb:	48 98                	cltq   
  8037fd:	48 83 c0 20          	add    $0x20,%rax
  803801:	48 39 c2             	cmp    %rax,%rdx
  803804:	73 b4                	jae    8037ba <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803806:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80380a:	8b 40 04             	mov    0x4(%rax),%eax
  80380d:	99                   	cltd   
  80380e:	c1 ea 1b             	shr    $0x1b,%edx
  803811:	01 d0                	add    %edx,%eax
  803813:	83 e0 1f             	and    $0x1f,%eax
  803816:	29 d0                	sub    %edx,%eax
  803818:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80381c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803820:	48 01 ca             	add    %rcx,%rdx
  803823:	0f b6 0a             	movzbl (%rdx),%ecx
  803826:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80382a:	48 98                	cltq   
  80382c:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803830:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803834:	8b 40 04             	mov    0x4(%rax),%eax
  803837:	8d 50 01             	lea    0x1(%rax),%edx
  80383a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80383e:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803841:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803846:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80384a:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80384e:	0f 82 64 ff ff ff    	jb     8037b8 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803854:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803858:	c9                   	leaveq 
  803859:	c3                   	retq   

000000000080385a <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80385a:	55                   	push   %rbp
  80385b:	48 89 e5             	mov    %rsp,%rbp
  80385e:	48 83 ec 20          	sub    $0x20,%rsp
  803862:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803866:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80386a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80386e:	48 89 c7             	mov    %rax,%rdi
  803871:	48 b8 5b 22 80 00 00 	movabs $0x80225b,%rax
  803878:	00 00 00 
  80387b:	ff d0                	callq  *%rax
  80387d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803881:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803885:	48 be c2 44 80 00 00 	movabs $0x8044c2,%rsi
  80388c:	00 00 00 
  80388f:	48 89 c7             	mov    %rax,%rdi
  803892:	48 b8 b7 13 80 00 00 	movabs $0x8013b7,%rax
  803899:	00 00 00 
  80389c:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80389e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038a2:	8b 50 04             	mov    0x4(%rax),%edx
  8038a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038a9:	8b 00                	mov    (%rax),%eax
  8038ab:	29 c2                	sub    %eax,%edx
  8038ad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038b1:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8038b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038bb:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8038c2:	00 00 00 
	stat->st_dev = &devpipe;
  8038c5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038c9:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  8038d0:	00 00 00 
  8038d3:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8038da:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8038df:	c9                   	leaveq 
  8038e0:	c3                   	retq   

00000000008038e1 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8038e1:	55                   	push   %rbp
  8038e2:	48 89 e5             	mov    %rsp,%rbp
  8038e5:	48 83 ec 10          	sub    $0x10,%rsp
  8038e9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8038ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038f1:	48 89 c6             	mov    %rax,%rsi
  8038f4:	bf 00 00 00 00       	mov    $0x0,%edi
  8038f9:	48 b8 91 1d 80 00 00 	movabs $0x801d91,%rax
  803900:	00 00 00 
  803903:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803905:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803909:	48 89 c7             	mov    %rax,%rdi
  80390c:	48 b8 5b 22 80 00 00 	movabs $0x80225b,%rax
  803913:	00 00 00 
  803916:	ff d0                	callq  *%rax
  803918:	48 89 c6             	mov    %rax,%rsi
  80391b:	bf 00 00 00 00       	mov    $0x0,%edi
  803920:	48 b8 91 1d 80 00 00 	movabs $0x801d91,%rax
  803927:	00 00 00 
  80392a:	ff d0                	callq  *%rax
}
  80392c:	c9                   	leaveq 
  80392d:	c3                   	retq   

000000000080392e <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80392e:	55                   	push   %rbp
  80392f:	48 89 e5             	mov    %rsp,%rbp
  803932:	48 83 ec 20          	sub    $0x20,%rsp
  803936:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803939:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80393c:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80393f:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803943:	be 01 00 00 00       	mov    $0x1,%esi
  803948:	48 89 c7             	mov    %rax,%rdi
  80394b:	48 b8 9e 1b 80 00 00 	movabs $0x801b9e,%rax
  803952:	00 00 00 
  803955:	ff d0                	callq  *%rax
}
  803957:	c9                   	leaveq 
  803958:	c3                   	retq   

0000000000803959 <getchar>:

int
getchar(void)
{
  803959:	55                   	push   %rbp
  80395a:	48 89 e5             	mov    %rsp,%rbp
  80395d:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803961:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803965:	ba 01 00 00 00       	mov    $0x1,%edx
  80396a:	48 89 c6             	mov    %rax,%rsi
  80396d:	bf 00 00 00 00       	mov    $0x0,%edi
  803972:	48 b8 50 27 80 00 00 	movabs $0x802750,%rax
  803979:	00 00 00 
  80397c:	ff d0                	callq  *%rax
  80397e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803981:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803985:	79 05                	jns    80398c <getchar+0x33>
		return r;
  803987:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80398a:	eb 14                	jmp    8039a0 <getchar+0x47>
	if (r < 1)
  80398c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803990:	7f 07                	jg     803999 <getchar+0x40>
		return -E_EOF;
  803992:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803997:	eb 07                	jmp    8039a0 <getchar+0x47>
	return c;
  803999:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80399d:	0f b6 c0             	movzbl %al,%eax
}
  8039a0:	c9                   	leaveq 
  8039a1:	c3                   	retq   

00000000008039a2 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8039a2:	55                   	push   %rbp
  8039a3:	48 89 e5             	mov    %rsp,%rbp
  8039a6:	48 83 ec 20          	sub    $0x20,%rsp
  8039aa:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8039ad:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8039b1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039b4:	48 89 d6             	mov    %rdx,%rsi
  8039b7:	89 c7                	mov    %eax,%edi
  8039b9:	48 b8 1e 23 80 00 00 	movabs $0x80231e,%rax
  8039c0:	00 00 00 
  8039c3:	ff d0                	callq  *%rax
  8039c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039cc:	79 05                	jns    8039d3 <iscons+0x31>
		return r;
  8039ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039d1:	eb 1a                	jmp    8039ed <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8039d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039d7:	8b 10                	mov    (%rax),%edx
  8039d9:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  8039e0:	00 00 00 
  8039e3:	8b 00                	mov    (%rax),%eax
  8039e5:	39 c2                	cmp    %eax,%edx
  8039e7:	0f 94 c0             	sete   %al
  8039ea:	0f b6 c0             	movzbl %al,%eax
}
  8039ed:	c9                   	leaveq 
  8039ee:	c3                   	retq   

00000000008039ef <opencons>:

int
opencons(void)
{
  8039ef:	55                   	push   %rbp
  8039f0:	48 89 e5             	mov    %rsp,%rbp
  8039f3:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8039f7:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8039fb:	48 89 c7             	mov    %rax,%rdi
  8039fe:	48 b8 86 22 80 00 00 	movabs $0x802286,%rax
  803a05:	00 00 00 
  803a08:	ff d0                	callq  *%rax
  803a0a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a0d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a11:	79 05                	jns    803a18 <opencons+0x29>
		return r;
  803a13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a16:	eb 5b                	jmp    803a73 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803a18:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a1c:	ba 07 04 00 00       	mov    $0x407,%edx
  803a21:	48 89 c6             	mov    %rax,%rsi
  803a24:	bf 00 00 00 00       	mov    $0x0,%edi
  803a29:	48 b8 e6 1c 80 00 00 	movabs $0x801ce6,%rax
  803a30:	00 00 00 
  803a33:	ff d0                	callq  *%rax
  803a35:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a38:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a3c:	79 05                	jns    803a43 <opencons+0x54>
		return r;
  803a3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a41:	eb 30                	jmp    803a73 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803a43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a47:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803a4e:	00 00 00 
  803a51:	8b 12                	mov    (%rdx),%edx
  803a53:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803a55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a59:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803a60:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a64:	48 89 c7             	mov    %rax,%rdi
  803a67:	48 b8 38 22 80 00 00 	movabs $0x802238,%rax
  803a6e:	00 00 00 
  803a71:	ff d0                	callq  *%rax
}
  803a73:	c9                   	leaveq 
  803a74:	c3                   	retq   

0000000000803a75 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803a75:	55                   	push   %rbp
  803a76:	48 89 e5             	mov    %rsp,%rbp
  803a79:	48 83 ec 30          	sub    $0x30,%rsp
  803a7d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803a81:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a85:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803a89:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803a8e:	75 07                	jne    803a97 <devcons_read+0x22>
		return 0;
  803a90:	b8 00 00 00 00       	mov    $0x0,%eax
  803a95:	eb 4b                	jmp    803ae2 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803a97:	eb 0c                	jmp    803aa5 <devcons_read+0x30>
		sys_yield();
  803a99:	48 b8 a8 1c 80 00 00 	movabs $0x801ca8,%rax
  803aa0:	00 00 00 
  803aa3:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803aa5:	48 b8 e8 1b 80 00 00 	movabs $0x801be8,%rax
  803aac:	00 00 00 
  803aaf:	ff d0                	callq  *%rax
  803ab1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ab4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ab8:	74 df                	je     803a99 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803aba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803abe:	79 05                	jns    803ac5 <devcons_read+0x50>
		return c;
  803ac0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ac3:	eb 1d                	jmp    803ae2 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803ac5:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803ac9:	75 07                	jne    803ad2 <devcons_read+0x5d>
		return 0;
  803acb:	b8 00 00 00 00       	mov    $0x0,%eax
  803ad0:	eb 10                	jmp    803ae2 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803ad2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ad5:	89 c2                	mov    %eax,%edx
  803ad7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803adb:	88 10                	mov    %dl,(%rax)
	return 1;
  803add:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803ae2:	c9                   	leaveq 
  803ae3:	c3                   	retq   

0000000000803ae4 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803ae4:	55                   	push   %rbp
  803ae5:	48 89 e5             	mov    %rsp,%rbp
  803ae8:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803aef:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803af6:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803afd:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803b04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803b0b:	eb 76                	jmp    803b83 <devcons_write+0x9f>
		m = n - tot;
  803b0d:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803b14:	89 c2                	mov    %eax,%edx
  803b16:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b19:	29 c2                	sub    %eax,%edx
  803b1b:	89 d0                	mov    %edx,%eax
  803b1d:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803b20:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b23:	83 f8 7f             	cmp    $0x7f,%eax
  803b26:	76 07                	jbe    803b2f <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803b28:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803b2f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b32:	48 63 d0             	movslq %eax,%rdx
  803b35:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b38:	48 63 c8             	movslq %eax,%rcx
  803b3b:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803b42:	48 01 c1             	add    %rax,%rcx
  803b45:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803b4c:	48 89 ce             	mov    %rcx,%rsi
  803b4f:	48 89 c7             	mov    %rax,%rdi
  803b52:	48 b8 db 16 80 00 00 	movabs $0x8016db,%rax
  803b59:	00 00 00 
  803b5c:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803b5e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b61:	48 63 d0             	movslq %eax,%rdx
  803b64:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803b6b:	48 89 d6             	mov    %rdx,%rsi
  803b6e:	48 89 c7             	mov    %rax,%rdi
  803b71:	48 b8 9e 1b 80 00 00 	movabs $0x801b9e,%rax
  803b78:	00 00 00 
  803b7b:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803b7d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b80:	01 45 fc             	add    %eax,-0x4(%rbp)
  803b83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b86:	48 98                	cltq   
  803b88:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803b8f:	0f 82 78 ff ff ff    	jb     803b0d <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803b95:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803b98:	c9                   	leaveq 
  803b99:	c3                   	retq   

0000000000803b9a <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803b9a:	55                   	push   %rbp
  803b9b:	48 89 e5             	mov    %rsp,%rbp
  803b9e:	48 83 ec 08          	sub    $0x8,%rsp
  803ba2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803ba6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803bab:	c9                   	leaveq 
  803bac:	c3                   	retq   

0000000000803bad <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803bad:	55                   	push   %rbp
  803bae:	48 89 e5             	mov    %rsp,%rbp
  803bb1:	48 83 ec 10          	sub    $0x10,%rsp
  803bb5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803bb9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803bbd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bc1:	48 be ce 44 80 00 00 	movabs $0x8044ce,%rsi
  803bc8:	00 00 00 
  803bcb:	48 89 c7             	mov    %rax,%rdi
  803bce:	48 b8 b7 13 80 00 00 	movabs $0x8013b7,%rax
  803bd5:	00 00 00 
  803bd8:	ff d0                	callq  *%rax
	return 0;
  803bda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803bdf:	c9                   	leaveq 
  803be0:	c3                   	retq   

0000000000803be1 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803be1:	55                   	push   %rbp
  803be2:	48 89 e5             	mov    %rsp,%rbp
  803be5:	48 83 ec 30          	sub    $0x30,%rsp
  803be9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803bed:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803bf1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803bf5:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803bfc:	00 00 00 
  803bff:	48 8b 00             	mov    (%rax),%rax
  803c02:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803c08:	85 c0                	test   %eax,%eax
  803c0a:	75 3c                	jne    803c48 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  803c0c:	48 b8 6a 1c 80 00 00 	movabs $0x801c6a,%rax
  803c13:	00 00 00 
  803c16:	ff d0                	callq  *%rax
  803c18:	25 ff 03 00 00       	and    $0x3ff,%eax
  803c1d:	48 63 d0             	movslq %eax,%rdx
  803c20:	48 89 d0             	mov    %rdx,%rax
  803c23:	48 c1 e0 03          	shl    $0x3,%rax
  803c27:	48 01 d0             	add    %rdx,%rax
  803c2a:	48 c1 e0 05          	shl    $0x5,%rax
  803c2e:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803c35:	00 00 00 
  803c38:	48 01 c2             	add    %rax,%rdx
  803c3b:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803c42:	00 00 00 
  803c45:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803c48:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803c4d:	75 0e                	jne    803c5d <ipc_recv+0x7c>
		pg = (void*) UTOP;
  803c4f:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803c56:	00 00 00 
  803c59:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803c5d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c61:	48 89 c7             	mov    %rax,%rdi
  803c64:	48 b8 0f 1f 80 00 00 	movabs $0x801f0f,%rax
  803c6b:	00 00 00 
  803c6e:	ff d0                	callq  *%rax
  803c70:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803c73:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c77:	79 19                	jns    803c92 <ipc_recv+0xb1>
		*from_env_store = 0;
  803c79:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c7d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803c83:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c87:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803c8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c90:	eb 53                	jmp    803ce5 <ipc_recv+0x104>
	}
	if(from_env_store)
  803c92:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803c97:	74 19                	je     803cb2 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  803c99:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803ca0:	00 00 00 
  803ca3:	48 8b 00             	mov    (%rax),%rax
  803ca6:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803cac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cb0:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803cb2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803cb7:	74 19                	je     803cd2 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  803cb9:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803cc0:	00 00 00 
  803cc3:	48 8b 00             	mov    (%rax),%rax
  803cc6:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803ccc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cd0:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803cd2:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803cd9:	00 00 00 
  803cdc:	48 8b 00             	mov    (%rax),%rax
  803cdf:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803ce5:	c9                   	leaveq 
  803ce6:	c3                   	retq   

0000000000803ce7 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803ce7:	55                   	push   %rbp
  803ce8:	48 89 e5             	mov    %rsp,%rbp
  803ceb:	48 83 ec 30          	sub    $0x30,%rsp
  803cef:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803cf2:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803cf5:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803cf9:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803cfc:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803d01:	75 0e                	jne    803d11 <ipc_send+0x2a>
		pg = (void*)UTOP;
  803d03:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803d0a:	00 00 00 
  803d0d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  803d11:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803d14:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803d17:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803d1b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d1e:	89 c7                	mov    %eax,%edi
  803d20:	48 b8 ba 1e 80 00 00 	movabs $0x801eba,%rax
  803d27:	00 00 00 
  803d2a:	ff d0                	callq  *%rax
  803d2c:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  803d2f:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803d33:	75 0c                	jne    803d41 <ipc_send+0x5a>
			sys_yield();
  803d35:	48 b8 a8 1c 80 00 00 	movabs $0x801ca8,%rax
  803d3c:	00 00 00 
  803d3f:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  803d41:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803d45:	74 ca                	je     803d11 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  803d47:	c9                   	leaveq 
  803d48:	c3                   	retq   

0000000000803d49 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803d49:	55                   	push   %rbp
  803d4a:	48 89 e5             	mov    %rsp,%rbp
  803d4d:	48 83 ec 14          	sub    $0x14,%rsp
  803d51:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  803d54:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803d5b:	eb 5e                	jmp    803dbb <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803d5d:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803d64:	00 00 00 
  803d67:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d6a:	48 63 d0             	movslq %eax,%rdx
  803d6d:	48 89 d0             	mov    %rdx,%rax
  803d70:	48 c1 e0 03          	shl    $0x3,%rax
  803d74:	48 01 d0             	add    %rdx,%rax
  803d77:	48 c1 e0 05          	shl    $0x5,%rax
  803d7b:	48 01 c8             	add    %rcx,%rax
  803d7e:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803d84:	8b 00                	mov    (%rax),%eax
  803d86:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803d89:	75 2c                	jne    803db7 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803d8b:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803d92:	00 00 00 
  803d95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d98:	48 63 d0             	movslq %eax,%rdx
  803d9b:	48 89 d0             	mov    %rdx,%rax
  803d9e:	48 c1 e0 03          	shl    $0x3,%rax
  803da2:	48 01 d0             	add    %rdx,%rax
  803da5:	48 c1 e0 05          	shl    $0x5,%rax
  803da9:	48 01 c8             	add    %rcx,%rax
  803dac:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803db2:	8b 40 08             	mov    0x8(%rax),%eax
  803db5:	eb 12                	jmp    803dc9 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803db7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803dbb:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803dc2:	7e 99                	jle    803d5d <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803dc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803dc9:	c9                   	leaveq 
  803dca:	c3                   	retq   

0000000000803dcb <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803dcb:	55                   	push   %rbp
  803dcc:	48 89 e5             	mov    %rsp,%rbp
  803dcf:	48 83 ec 18          	sub    $0x18,%rsp
  803dd3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803dd7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ddb:	48 c1 e8 15          	shr    $0x15,%rax
  803ddf:	48 89 c2             	mov    %rax,%rdx
  803de2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803de9:	01 00 00 
  803dec:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803df0:	83 e0 01             	and    $0x1,%eax
  803df3:	48 85 c0             	test   %rax,%rax
  803df6:	75 07                	jne    803dff <pageref+0x34>
		return 0;
  803df8:	b8 00 00 00 00       	mov    $0x0,%eax
  803dfd:	eb 53                	jmp    803e52 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803dff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e03:	48 c1 e8 0c          	shr    $0xc,%rax
  803e07:	48 89 c2             	mov    %rax,%rdx
  803e0a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803e11:	01 00 00 
  803e14:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e18:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803e1c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e20:	83 e0 01             	and    $0x1,%eax
  803e23:	48 85 c0             	test   %rax,%rax
  803e26:	75 07                	jne    803e2f <pageref+0x64>
		return 0;
  803e28:	b8 00 00 00 00       	mov    $0x0,%eax
  803e2d:	eb 23                	jmp    803e52 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803e2f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e33:	48 c1 e8 0c          	shr    $0xc,%rax
  803e37:	48 89 c2             	mov    %rax,%rdx
  803e3a:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803e41:	00 00 00 
  803e44:	48 c1 e2 04          	shl    $0x4,%rdx
  803e48:	48 01 d0             	add    %rdx,%rax
  803e4b:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803e4f:	0f b7 c0             	movzwl %ax,%eax
}
  803e52:	c9                   	leaveq 
  803e53:	c3                   	retq   
