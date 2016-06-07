
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
  800070:	48 b8 02 2c 80 00 00 	movabs $0x802c02,%rax
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
  800095:	48 ba 20 49 80 00 00 	movabs $0x804920,%rdx
  80009c:	00 00 00 
  80009f:	be 0f 00 00 00       	mov    $0xf,%esi
  8000a4:	48 bf 2c 49 80 00 00 	movabs $0x80492c,%rdi
  8000ab:	00 00 00 
  8000ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b3:	49 b9 c9 05 80 00 00 	movabs $0x8005c9,%r9
  8000ba:	00 00 00 
  8000bd:	41 ff d1             	callq  *%r9
	if (st.st_isdir && !flag['d'])
  8000c0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8000c3:	85 c0                	test   %eax,%eax
  8000c5:	74 36                	je     8000fd <ls+0xba>
  8000c7:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
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
  80014f:	48 b8 f0 2c 80 00 00 	movabs $0x802cf0,%rax
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
  800174:	48 ba 36 49 80 00 00 	movabs $0x804936,%rdx
  80017b:	00 00 00 
  80017e:	be 1d 00 00 00       	mov    $0x1d,%esi
  800183:	48 bf 2c 49 80 00 00 	movabs $0x80492c,%rdi
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
  8001f2:	48 b8 ef 28 80 00 00 	movabs $0x8028ef,%rax
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
  80021a:	48 ba 42 49 80 00 00 	movabs $0x804942,%rdx
  800221:	00 00 00 
  800224:	be 22 00 00 00       	mov    $0x22,%esi
  800229:	48 bf 2c 49 80 00 00 	movabs $0x80492c,%rdi
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
  80025b:	48 ba 60 49 80 00 00 	movabs $0x804960,%rdx
  800262:	00 00 00 
  800265:	be 24 00 00 00       	mov    $0x24,%esi
  80026a:	48 bf 2c 49 80 00 00 	movabs $0x80492c,%rdi
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
  8002a0:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
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
  8002cd:	48 bf 7f 49 80 00 00 	movabs $0x80497f,%rdi
  8002d4:	00 00 00 
  8002d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8002dc:	48 b9 54 35 80 00 00 	movabs $0x803554,%rcx
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
  800321:	48 b8 88 49 80 00 00 	movabs $0x804988,%rax
  800328:	00 00 00 
  80032b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80032f:	eb 0e                	jmp    80033f <ls1+0xb7>
		else
			sep = "";
  800331:	48 b8 8a 49 80 00 00 	movabs $0x80498a,%rax
  800338:	00 00 00 
  80033b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		printf("%s%s", prefix, sep);
  80033f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800343:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800347:	48 89 c6             	mov    %rax,%rsi
  80034a:	48 bf 8b 49 80 00 00 	movabs $0x80498b,%rdi
  800351:	00 00 00 
  800354:	b8 00 00 00 00       	mov    $0x0,%eax
  800359:	48 b9 54 35 80 00 00 	movabs $0x803554,%rcx
  800360:	00 00 00 
  800363:	ff d1                	callq  *%rcx
	}
	printf("%s", name);
  800365:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800369:	48 89 c6             	mov    %rax,%rsi
  80036c:	48 bf 90 49 80 00 00 	movabs $0x804990,%rdi
  800373:	00 00 00 
  800376:	b8 00 00 00 00       	mov    $0x0,%eax
  80037b:	48 ba 54 35 80 00 00 	movabs $0x803554,%rdx
  800382:	00 00 00 
  800385:	ff d2                	callq  *%rdx
	if(flag['F'] && isdir)
  800387:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  80038e:	00 00 00 
  800391:	8b 80 18 01 00 00    	mov    0x118(%rax),%eax
  800397:	85 c0                	test   %eax,%eax
  800399:	74 21                	je     8003bc <ls1+0x134>
  80039b:	80 7d e4 00          	cmpb   $0x0,-0x1c(%rbp)
  80039f:	74 1b                	je     8003bc <ls1+0x134>
		printf("/");
  8003a1:	48 bf 88 49 80 00 00 	movabs $0x804988,%rdi
  8003a8:	00 00 00 
  8003ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8003b0:	48 ba 54 35 80 00 00 	movabs $0x803554,%rdx
  8003b7:	00 00 00 
  8003ba:	ff d2                	callq  *%rdx
	printf("\n");
  8003bc:	48 bf 93 49 80 00 00 	movabs $0x804993,%rdi
  8003c3:	00 00 00 
  8003c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8003cb:	48 ba 54 35 80 00 00 	movabs $0x803554,%rdx
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
  8003dd:	48 bf 95 49 80 00 00 	movabs $0x804995,%rdi
  8003e4:	00 00 00 
  8003e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ec:	48 ba 54 35 80 00 00 	movabs $0x803554,%rdx
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
  800427:	48 b8 1d 20 80 00 00 	movabs $0x80201d,%rax
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
  800447:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  80044e:	00 00 00 
  800451:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800454:	48 63 d2             	movslq %edx,%rdx
  800457:	8b 04 90             	mov    (%rax,%rdx,4),%eax
  80045a:	8d 48 01             	lea    0x1(%rax),%ecx
  80045d:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
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
  800485:	48 b8 81 20 80 00 00 	movabs $0x802081,%rax
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
  8004a2:	48 be 8a 49 80 00 00 	movabs $0x80498a,%rsi
  8004a9:	00 00 00 
  8004ac:	48 bf 88 49 80 00 00 	movabs $0x804988,%rdi
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
  800559:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
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
  800573:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
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
  8005aa:	48 b8 43 26 80 00 00 	movabs $0x802643,%rax
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
  800652:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
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
  800683:	48 bf c0 49 80 00 00 	movabs $0x8049c0,%rdi
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
  8006bf:	48 bf e3 49 80 00 00 	movabs $0x8049e3,%rdi
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
  80096e:	48 ba f0 4b 80 00 00 	movabs $0x804bf0,%rdx
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
  800c66:	48 b8 18 4c 80 00 00 	movabs $0x804c18,%rax
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
  800db4:	83 fb 15             	cmp    $0x15,%ebx
  800db7:	7f 16                	jg     800dcf <vprintfmt+0x21a>
  800db9:	48 b8 40 4b 80 00 00 	movabs $0x804b40,%rax
  800dc0:	00 00 00 
  800dc3:	48 63 d3             	movslq %ebx,%rdx
  800dc6:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800dca:	4d 85 e4             	test   %r12,%r12
  800dcd:	75 2e                	jne    800dfd <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800dcf:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800dd3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dd7:	89 d9                	mov    %ebx,%ecx
  800dd9:	48 ba 01 4c 80 00 00 	movabs $0x804c01,%rdx
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
  800e08:	48 ba 0a 4c 80 00 00 	movabs $0x804c0a,%rdx
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
  800e62:	49 bc 0d 4c 80 00 00 	movabs $0x804c0d,%r12
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
  801b68:	48 ba c8 4e 80 00 00 	movabs $0x804ec8,%rdx
  801b6f:	00 00 00 
  801b72:	be 23 00 00 00       	mov    $0x23,%esi
  801b77:	48 bf e5 4e 80 00 00 	movabs $0x804ee5,%rdi
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

0000000000801f53 <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801f53:	55                   	push   %rbp
  801f54:	48 89 e5             	mov    %rsp,%rbp
  801f57:	48 83 ec 20          	sub    $0x20,%rsp
  801f5b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801f5f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, (uint64_t)buf, len, 0, 0, 0, 0);
  801f63:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f67:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f6b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f72:	00 
  801f73:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f79:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f7f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f84:	89 c6                	mov    %eax,%esi
  801f86:	bf 0f 00 00 00       	mov    $0xf,%edi
  801f8b:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  801f92:	00 00 00 
  801f95:	ff d0                	callq  *%rax
}
  801f97:	c9                   	leaveq 
  801f98:	c3                   	retq   

0000000000801f99 <sys_net_rx>:

int
sys_net_rx(void *buf, size_t len)
{
  801f99:	55                   	push   %rbp
  801f9a:	48 89 e5             	mov    %rsp,%rbp
  801f9d:	48 83 ec 20          	sub    $0x20,%rsp
  801fa1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801fa5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_rx, (uint64_t)buf, len, 0, 0, 0, 0);
  801fa9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fb1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fb8:	00 
  801fb9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fbf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fc5:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fca:	89 c6                	mov    %eax,%esi
  801fcc:	bf 10 00 00 00       	mov    $0x10,%edi
  801fd1:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  801fd8:	00 00 00 
  801fdb:	ff d0                	callq  *%rax
}
  801fdd:	c9                   	leaveq 
  801fde:	c3                   	retq   

0000000000801fdf <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801fdf:	55                   	push   %rbp
  801fe0:	48 89 e5             	mov    %rsp,%rbp
  801fe3:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801fe7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fee:	00 
  801fef:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ff5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ffb:	b9 00 00 00 00       	mov    $0x0,%ecx
  802000:	ba 00 00 00 00       	mov    $0x0,%edx
  802005:	be 00 00 00 00       	mov    $0x0,%esi
  80200a:	bf 0e 00 00 00       	mov    $0xe,%edi
  80200f:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  802016:	00 00 00 
  802019:	ff d0                	callq  *%rax
}
  80201b:	c9                   	leaveq 
  80201c:	c3                   	retq   

000000000080201d <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  80201d:	55                   	push   %rbp
  80201e:	48 89 e5             	mov    %rsp,%rbp
  802021:	48 83 ec 18          	sub    $0x18,%rsp
  802025:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802029:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80202d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	args->argc = argc;
  802031:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802035:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802039:	48 89 10             	mov    %rdx,(%rax)
	args->argv = (const char **) argv;
  80203c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802040:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802044:	48 89 50 08          	mov    %rdx,0x8(%rax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  802048:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80204c:	8b 00                	mov    (%rax),%eax
  80204e:	83 f8 01             	cmp    $0x1,%eax
  802051:	7e 13                	jle    802066 <argstart+0x49>
  802053:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  802058:	74 0c                	je     802066 <argstart+0x49>
  80205a:	48 b8 f3 4e 80 00 00 	movabs $0x804ef3,%rax
  802061:	00 00 00 
  802064:	eb 05                	jmp    80206b <argstart+0x4e>
  802066:	b8 00 00 00 00       	mov    $0x0,%eax
  80206b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80206f:	48 89 42 10          	mov    %rax,0x10(%rdx)
	args->argvalue = 0;
  802073:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802077:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  80207e:	00 
}
  80207f:	c9                   	leaveq 
  802080:	c3                   	retq   

0000000000802081 <argnext>:

int
argnext(struct Argstate *args)
{
  802081:	55                   	push   %rbp
  802082:	48 89 e5             	mov    %rsp,%rbp
  802085:	48 83 ec 20          	sub    $0x20,%rsp
  802089:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int arg;

	args->argvalue = 0;
  80208d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802091:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  802098:	00 

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  802099:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80209d:	48 8b 40 10          	mov    0x10(%rax),%rax
  8020a1:	48 85 c0             	test   %rax,%rax
  8020a4:	75 0a                	jne    8020b0 <argnext+0x2f>
		return -1;
  8020a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8020ab:	e9 25 01 00 00       	jmpq   8021d5 <argnext+0x154>

	if (!*args->curarg) {
  8020b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020b4:	48 8b 40 10          	mov    0x10(%rax),%rax
  8020b8:	0f b6 00             	movzbl (%rax),%eax
  8020bb:	84 c0                	test   %al,%al
  8020bd:	0f 85 d7 00 00 00    	jne    80219a <argnext+0x119>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  8020c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020c7:	48 8b 00             	mov    (%rax),%rax
  8020ca:	8b 00                	mov    (%rax),%eax
  8020cc:	83 f8 01             	cmp    $0x1,%eax
  8020cf:	0f 84 ef 00 00 00    	je     8021c4 <argnext+0x143>
		    || args->argv[1][0] != '-'
  8020d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020d9:	48 8b 40 08          	mov    0x8(%rax),%rax
  8020dd:	48 83 c0 08          	add    $0x8,%rax
  8020e1:	48 8b 00             	mov    (%rax),%rax
  8020e4:	0f b6 00             	movzbl (%rax),%eax
  8020e7:	3c 2d                	cmp    $0x2d,%al
  8020e9:	0f 85 d5 00 00 00    	jne    8021c4 <argnext+0x143>
		    || args->argv[1][1] == '\0')
  8020ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020f3:	48 8b 40 08          	mov    0x8(%rax),%rax
  8020f7:	48 83 c0 08          	add    $0x8,%rax
  8020fb:	48 8b 00             	mov    (%rax),%rax
  8020fe:	48 83 c0 01          	add    $0x1,%rax
  802102:	0f b6 00             	movzbl (%rax),%eax
  802105:	84 c0                	test   %al,%al
  802107:	0f 84 b7 00 00 00    	je     8021c4 <argnext+0x143>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  80210d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802111:	48 8b 40 08          	mov    0x8(%rax),%rax
  802115:	48 83 c0 08          	add    $0x8,%rax
  802119:	48 8b 00             	mov    (%rax),%rax
  80211c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802120:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802124:	48 89 50 10          	mov    %rdx,0x10(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  802128:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80212c:	48 8b 00             	mov    (%rax),%rax
  80212f:	8b 00                	mov    (%rax),%eax
  802131:	83 e8 01             	sub    $0x1,%eax
  802134:	48 98                	cltq   
  802136:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80213d:	00 
  80213e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802142:	48 8b 40 08          	mov    0x8(%rax),%rax
  802146:	48 8d 48 10          	lea    0x10(%rax),%rcx
  80214a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80214e:	48 8b 40 08          	mov    0x8(%rax),%rax
  802152:	48 83 c0 08          	add    $0x8,%rax
  802156:	48 89 ce             	mov    %rcx,%rsi
  802159:	48 89 c7             	mov    %rax,%rdi
  80215c:	48 b8 db 16 80 00 00 	movabs $0x8016db,%rax
  802163:	00 00 00 
  802166:	ff d0                	callq  *%rax
		(*args->argc)--;
  802168:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80216c:	48 8b 00             	mov    (%rax),%rax
  80216f:	8b 10                	mov    (%rax),%edx
  802171:	83 ea 01             	sub    $0x1,%edx
  802174:	89 10                	mov    %edx,(%rax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  802176:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80217a:	48 8b 40 10          	mov    0x10(%rax),%rax
  80217e:	0f b6 00             	movzbl (%rax),%eax
  802181:	3c 2d                	cmp    $0x2d,%al
  802183:	75 15                	jne    80219a <argnext+0x119>
  802185:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802189:	48 8b 40 10          	mov    0x10(%rax),%rax
  80218d:	48 83 c0 01          	add    $0x1,%rax
  802191:	0f b6 00             	movzbl (%rax),%eax
  802194:	84 c0                	test   %al,%al
  802196:	75 02                	jne    80219a <argnext+0x119>
			goto endofargs;
  802198:	eb 2a                	jmp    8021c4 <argnext+0x143>
	}

	arg = (unsigned char) *args->curarg;
  80219a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80219e:	48 8b 40 10          	mov    0x10(%rax),%rax
  8021a2:	0f b6 00             	movzbl (%rax),%eax
  8021a5:	0f b6 c0             	movzbl %al,%eax
  8021a8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	args->curarg++;
  8021ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021af:	48 8b 40 10          	mov    0x10(%rax),%rax
  8021b3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8021b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021bb:	48 89 50 10          	mov    %rdx,0x10(%rax)
	return arg;
  8021bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021c2:	eb 11                	jmp    8021d5 <argnext+0x154>

endofargs:
	args->curarg = 0;
  8021c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021c8:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  8021cf:	00 
	return -1;
  8021d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  8021d5:	c9                   	leaveq 
  8021d6:	c3                   	retq   

00000000008021d7 <argvalue>:

char *
argvalue(struct Argstate *args)
{
  8021d7:	55                   	push   %rbp
  8021d8:	48 89 e5             	mov    %rsp,%rbp
  8021db:	48 83 ec 10          	sub    $0x10,%rsp
  8021df:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  8021e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021e7:	48 8b 40 18          	mov    0x18(%rax),%rax
  8021eb:	48 85 c0             	test   %rax,%rax
  8021ee:	74 0a                	je     8021fa <argvalue+0x23>
  8021f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021f4:	48 8b 40 18          	mov    0x18(%rax),%rax
  8021f8:	eb 13                	jmp    80220d <argvalue+0x36>
  8021fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021fe:	48 89 c7             	mov    %rax,%rdi
  802201:	48 b8 0f 22 80 00 00 	movabs $0x80220f,%rax
  802208:	00 00 00 
  80220b:	ff d0                	callq  *%rax
}
  80220d:	c9                   	leaveq 
  80220e:	c3                   	retq   

000000000080220f <argnextvalue>:

char *
argnextvalue(struct Argstate *args)
{
  80220f:	55                   	push   %rbp
  802210:	48 89 e5             	mov    %rsp,%rbp
  802213:	53                   	push   %rbx
  802214:	48 83 ec 18          	sub    $0x18,%rsp
  802218:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (!args->curarg)
  80221c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802220:	48 8b 40 10          	mov    0x10(%rax),%rax
  802224:	48 85 c0             	test   %rax,%rax
  802227:	75 0a                	jne    802233 <argnextvalue+0x24>
		return 0;
  802229:	b8 00 00 00 00       	mov    $0x0,%eax
  80222e:	e9 c8 00 00 00       	jmpq   8022fb <argnextvalue+0xec>
	if (*args->curarg) {
  802233:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802237:	48 8b 40 10          	mov    0x10(%rax),%rax
  80223b:	0f b6 00             	movzbl (%rax),%eax
  80223e:	84 c0                	test   %al,%al
  802240:	74 27                	je     802269 <argnextvalue+0x5a>
		args->argvalue = args->curarg;
  802242:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802246:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80224a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80224e:	48 89 50 18          	mov    %rdx,0x18(%rax)
		args->curarg = "";
  802252:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802256:	48 bb f3 4e 80 00 00 	movabs $0x804ef3,%rbx
  80225d:	00 00 00 
  802260:	48 89 58 10          	mov    %rbx,0x10(%rax)
  802264:	e9 8a 00 00 00       	jmpq   8022f3 <argnextvalue+0xe4>
	} else if (*args->argc > 1) {
  802269:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80226d:	48 8b 00             	mov    (%rax),%rax
  802270:	8b 00                	mov    (%rax),%eax
  802272:	83 f8 01             	cmp    $0x1,%eax
  802275:	7e 64                	jle    8022db <argnextvalue+0xcc>
		args->argvalue = args->argv[1];
  802277:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80227b:	48 8b 40 08          	mov    0x8(%rax),%rax
  80227f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802283:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802287:	48 89 50 18          	mov    %rdx,0x18(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  80228b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80228f:	48 8b 00             	mov    (%rax),%rax
  802292:	8b 00                	mov    (%rax),%eax
  802294:	83 e8 01             	sub    $0x1,%eax
  802297:	48 98                	cltq   
  802299:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8022a0:	00 
  8022a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022a5:	48 8b 40 08          	mov    0x8(%rax),%rax
  8022a9:	48 8d 48 10          	lea    0x10(%rax),%rcx
  8022ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022b1:	48 8b 40 08          	mov    0x8(%rax),%rax
  8022b5:	48 83 c0 08          	add    $0x8,%rax
  8022b9:	48 89 ce             	mov    %rcx,%rsi
  8022bc:	48 89 c7             	mov    %rax,%rdi
  8022bf:	48 b8 db 16 80 00 00 	movabs $0x8016db,%rax
  8022c6:	00 00 00 
  8022c9:	ff d0                	callq  *%rax
		(*args->argc)--;
  8022cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022cf:	48 8b 00             	mov    (%rax),%rax
  8022d2:	8b 10                	mov    (%rax),%edx
  8022d4:	83 ea 01             	sub    $0x1,%edx
  8022d7:	89 10                	mov    %edx,(%rax)
  8022d9:	eb 18                	jmp    8022f3 <argnextvalue+0xe4>
	} else {
		args->argvalue = 0;
  8022db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022df:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  8022e6:	00 
		args->curarg = 0;
  8022e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022eb:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  8022f2:	00 
	}
	return (char*) args->argvalue;
  8022f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022f7:	48 8b 40 18          	mov    0x18(%rax),%rax
}
  8022fb:	48 83 c4 18          	add    $0x18,%rsp
  8022ff:	5b                   	pop    %rbx
  802300:	5d                   	pop    %rbp
  802301:	c3                   	retq   

0000000000802302 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802302:	55                   	push   %rbp
  802303:	48 89 e5             	mov    %rsp,%rbp
  802306:	48 83 ec 08          	sub    $0x8,%rsp
  80230a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80230e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802312:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802319:	ff ff ff 
  80231c:	48 01 d0             	add    %rdx,%rax
  80231f:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802323:	c9                   	leaveq 
  802324:	c3                   	retq   

0000000000802325 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802325:	55                   	push   %rbp
  802326:	48 89 e5             	mov    %rsp,%rbp
  802329:	48 83 ec 08          	sub    $0x8,%rsp
  80232d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802331:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802335:	48 89 c7             	mov    %rax,%rdi
  802338:	48 b8 02 23 80 00 00 	movabs $0x802302,%rax
  80233f:	00 00 00 
  802342:	ff d0                	callq  *%rax
  802344:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80234a:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80234e:	c9                   	leaveq 
  80234f:	c3                   	retq   

0000000000802350 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802350:	55                   	push   %rbp
  802351:	48 89 e5             	mov    %rsp,%rbp
  802354:	48 83 ec 18          	sub    $0x18,%rsp
  802358:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80235c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802363:	eb 6b                	jmp    8023d0 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802365:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802368:	48 98                	cltq   
  80236a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802370:	48 c1 e0 0c          	shl    $0xc,%rax
  802374:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802378:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80237c:	48 c1 e8 15          	shr    $0x15,%rax
  802380:	48 89 c2             	mov    %rax,%rdx
  802383:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80238a:	01 00 00 
  80238d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802391:	83 e0 01             	and    $0x1,%eax
  802394:	48 85 c0             	test   %rax,%rax
  802397:	74 21                	je     8023ba <fd_alloc+0x6a>
  802399:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80239d:	48 c1 e8 0c          	shr    $0xc,%rax
  8023a1:	48 89 c2             	mov    %rax,%rdx
  8023a4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023ab:	01 00 00 
  8023ae:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023b2:	83 e0 01             	and    $0x1,%eax
  8023b5:	48 85 c0             	test   %rax,%rax
  8023b8:	75 12                	jne    8023cc <fd_alloc+0x7c>
			*fd_store = fd;
  8023ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023be:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023c2:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8023c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ca:	eb 1a                	jmp    8023e6 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8023cc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8023d0:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8023d4:	7e 8f                	jle    802365 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8023d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023da:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8023e1:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8023e6:	c9                   	leaveq 
  8023e7:	c3                   	retq   

00000000008023e8 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8023e8:	55                   	push   %rbp
  8023e9:	48 89 e5             	mov    %rsp,%rbp
  8023ec:	48 83 ec 20          	sub    $0x20,%rsp
  8023f0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023f3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8023f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8023fb:	78 06                	js     802403 <fd_lookup+0x1b>
  8023fd:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802401:	7e 07                	jle    80240a <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802403:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802408:	eb 6c                	jmp    802476 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80240a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80240d:	48 98                	cltq   
  80240f:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802415:	48 c1 e0 0c          	shl    $0xc,%rax
  802419:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80241d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802421:	48 c1 e8 15          	shr    $0x15,%rax
  802425:	48 89 c2             	mov    %rax,%rdx
  802428:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80242f:	01 00 00 
  802432:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802436:	83 e0 01             	and    $0x1,%eax
  802439:	48 85 c0             	test   %rax,%rax
  80243c:	74 21                	je     80245f <fd_lookup+0x77>
  80243e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802442:	48 c1 e8 0c          	shr    $0xc,%rax
  802446:	48 89 c2             	mov    %rax,%rdx
  802449:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802450:	01 00 00 
  802453:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802457:	83 e0 01             	and    $0x1,%eax
  80245a:	48 85 c0             	test   %rax,%rax
  80245d:	75 07                	jne    802466 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80245f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802464:	eb 10                	jmp    802476 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802466:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80246a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80246e:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802471:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802476:	c9                   	leaveq 
  802477:	c3                   	retq   

0000000000802478 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802478:	55                   	push   %rbp
  802479:	48 89 e5             	mov    %rsp,%rbp
  80247c:	48 83 ec 30          	sub    $0x30,%rsp
  802480:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802484:	89 f0                	mov    %esi,%eax
  802486:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802489:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80248d:	48 89 c7             	mov    %rax,%rdi
  802490:	48 b8 02 23 80 00 00 	movabs $0x802302,%rax
  802497:	00 00 00 
  80249a:	ff d0                	callq  *%rax
  80249c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024a0:	48 89 d6             	mov    %rdx,%rsi
  8024a3:	89 c7                	mov    %eax,%edi
  8024a5:	48 b8 e8 23 80 00 00 	movabs $0x8023e8,%rax
  8024ac:	00 00 00 
  8024af:	ff d0                	callq  *%rax
  8024b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024b8:	78 0a                	js     8024c4 <fd_close+0x4c>
	    || fd != fd2)
  8024ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024be:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8024c2:	74 12                	je     8024d6 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8024c4:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8024c8:	74 05                	je     8024cf <fd_close+0x57>
  8024ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024cd:	eb 05                	jmp    8024d4 <fd_close+0x5c>
  8024cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d4:	eb 69                	jmp    80253f <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8024d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024da:	8b 00                	mov    (%rax),%eax
  8024dc:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024e0:	48 89 d6             	mov    %rdx,%rsi
  8024e3:	89 c7                	mov    %eax,%edi
  8024e5:	48 b8 41 25 80 00 00 	movabs $0x802541,%rax
  8024ec:	00 00 00 
  8024ef:	ff d0                	callq  *%rax
  8024f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024f8:	78 2a                	js     802524 <fd_close+0xac>
		if (dev->dev_close)
  8024fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024fe:	48 8b 40 20          	mov    0x20(%rax),%rax
  802502:	48 85 c0             	test   %rax,%rax
  802505:	74 16                	je     80251d <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802507:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80250b:	48 8b 40 20          	mov    0x20(%rax),%rax
  80250f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802513:	48 89 d7             	mov    %rdx,%rdi
  802516:	ff d0                	callq  *%rax
  802518:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80251b:	eb 07                	jmp    802524 <fd_close+0xac>
		else
			r = 0;
  80251d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802524:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802528:	48 89 c6             	mov    %rax,%rsi
  80252b:	bf 00 00 00 00       	mov    $0x0,%edi
  802530:	48 b8 91 1d 80 00 00 	movabs $0x801d91,%rax
  802537:	00 00 00 
  80253a:	ff d0                	callq  *%rax
	return r;
  80253c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80253f:	c9                   	leaveq 
  802540:	c3                   	retq   

0000000000802541 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802541:	55                   	push   %rbp
  802542:	48 89 e5             	mov    %rsp,%rbp
  802545:	48 83 ec 20          	sub    $0x20,%rsp
  802549:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80254c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802550:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802557:	eb 41                	jmp    80259a <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802559:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802560:	00 00 00 
  802563:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802566:	48 63 d2             	movslq %edx,%rdx
  802569:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80256d:	8b 00                	mov    (%rax),%eax
  80256f:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802572:	75 22                	jne    802596 <dev_lookup+0x55>
			*dev = devtab[i];
  802574:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80257b:	00 00 00 
  80257e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802581:	48 63 d2             	movslq %edx,%rdx
  802584:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802588:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80258c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80258f:	b8 00 00 00 00       	mov    $0x0,%eax
  802594:	eb 60                	jmp    8025f6 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802596:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80259a:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8025a1:	00 00 00 
  8025a4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8025a7:	48 63 d2             	movslq %edx,%rdx
  8025aa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025ae:	48 85 c0             	test   %rax,%rax
  8025b1:	75 a6                	jne    802559 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8025b3:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  8025ba:	00 00 00 
  8025bd:	48 8b 00             	mov    (%rax),%rax
  8025c0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025c6:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8025c9:	89 c6                	mov    %eax,%esi
  8025cb:	48 bf f8 4e 80 00 00 	movabs $0x804ef8,%rdi
  8025d2:	00 00 00 
  8025d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8025da:	48 b9 02 08 80 00 00 	movabs $0x800802,%rcx
  8025e1:	00 00 00 
  8025e4:	ff d1                	callq  *%rcx
	*dev = 0;
  8025e6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025ea:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8025f1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8025f6:	c9                   	leaveq 
  8025f7:	c3                   	retq   

00000000008025f8 <close>:

int
close(int fdnum)
{
  8025f8:	55                   	push   %rbp
  8025f9:	48 89 e5             	mov    %rsp,%rbp
  8025fc:	48 83 ec 20          	sub    $0x20,%rsp
  802600:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802603:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802607:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80260a:	48 89 d6             	mov    %rdx,%rsi
  80260d:	89 c7                	mov    %eax,%edi
  80260f:	48 b8 e8 23 80 00 00 	movabs $0x8023e8,%rax
  802616:	00 00 00 
  802619:	ff d0                	callq  *%rax
  80261b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80261e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802622:	79 05                	jns    802629 <close+0x31>
		return r;
  802624:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802627:	eb 18                	jmp    802641 <close+0x49>
	else
		return fd_close(fd, 1);
  802629:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80262d:	be 01 00 00 00       	mov    $0x1,%esi
  802632:	48 89 c7             	mov    %rax,%rdi
  802635:	48 b8 78 24 80 00 00 	movabs $0x802478,%rax
  80263c:	00 00 00 
  80263f:	ff d0                	callq  *%rax
}
  802641:	c9                   	leaveq 
  802642:	c3                   	retq   

0000000000802643 <close_all>:

void
close_all(void)
{
  802643:	55                   	push   %rbp
  802644:	48 89 e5             	mov    %rsp,%rbp
  802647:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80264b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802652:	eb 15                	jmp    802669 <close_all+0x26>
		close(i);
  802654:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802657:	89 c7                	mov    %eax,%edi
  802659:	48 b8 f8 25 80 00 00 	movabs $0x8025f8,%rax
  802660:	00 00 00 
  802663:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802665:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802669:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80266d:	7e e5                	jle    802654 <close_all+0x11>
		close(i);
}
  80266f:	c9                   	leaveq 
  802670:	c3                   	retq   

0000000000802671 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802671:	55                   	push   %rbp
  802672:	48 89 e5             	mov    %rsp,%rbp
  802675:	48 83 ec 40          	sub    $0x40,%rsp
  802679:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80267c:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80267f:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802683:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802686:	48 89 d6             	mov    %rdx,%rsi
  802689:	89 c7                	mov    %eax,%edi
  80268b:	48 b8 e8 23 80 00 00 	movabs $0x8023e8,%rax
  802692:	00 00 00 
  802695:	ff d0                	callq  *%rax
  802697:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80269a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80269e:	79 08                	jns    8026a8 <dup+0x37>
		return r;
  8026a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026a3:	e9 70 01 00 00       	jmpq   802818 <dup+0x1a7>
	close(newfdnum);
  8026a8:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8026ab:	89 c7                	mov    %eax,%edi
  8026ad:	48 b8 f8 25 80 00 00 	movabs $0x8025f8,%rax
  8026b4:	00 00 00 
  8026b7:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8026b9:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8026bc:	48 98                	cltq   
  8026be:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8026c4:	48 c1 e0 0c          	shl    $0xc,%rax
  8026c8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8026cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026d0:	48 89 c7             	mov    %rax,%rdi
  8026d3:	48 b8 25 23 80 00 00 	movabs $0x802325,%rax
  8026da:	00 00 00 
  8026dd:	ff d0                	callq  *%rax
  8026df:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8026e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026e7:	48 89 c7             	mov    %rax,%rdi
  8026ea:	48 b8 25 23 80 00 00 	movabs $0x802325,%rax
  8026f1:	00 00 00 
  8026f4:	ff d0                	callq  *%rax
  8026f6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8026fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026fe:	48 c1 e8 15          	shr    $0x15,%rax
  802702:	48 89 c2             	mov    %rax,%rdx
  802705:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80270c:	01 00 00 
  80270f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802713:	83 e0 01             	and    $0x1,%eax
  802716:	48 85 c0             	test   %rax,%rax
  802719:	74 73                	je     80278e <dup+0x11d>
  80271b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80271f:	48 c1 e8 0c          	shr    $0xc,%rax
  802723:	48 89 c2             	mov    %rax,%rdx
  802726:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80272d:	01 00 00 
  802730:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802734:	83 e0 01             	and    $0x1,%eax
  802737:	48 85 c0             	test   %rax,%rax
  80273a:	74 52                	je     80278e <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80273c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802740:	48 c1 e8 0c          	shr    $0xc,%rax
  802744:	48 89 c2             	mov    %rax,%rdx
  802747:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80274e:	01 00 00 
  802751:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802755:	25 07 0e 00 00       	and    $0xe07,%eax
  80275a:	89 c1                	mov    %eax,%ecx
  80275c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802760:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802764:	41 89 c8             	mov    %ecx,%r8d
  802767:	48 89 d1             	mov    %rdx,%rcx
  80276a:	ba 00 00 00 00       	mov    $0x0,%edx
  80276f:	48 89 c6             	mov    %rax,%rsi
  802772:	bf 00 00 00 00       	mov    $0x0,%edi
  802777:	48 b8 36 1d 80 00 00 	movabs $0x801d36,%rax
  80277e:	00 00 00 
  802781:	ff d0                	callq  *%rax
  802783:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802786:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80278a:	79 02                	jns    80278e <dup+0x11d>
			goto err;
  80278c:	eb 57                	jmp    8027e5 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80278e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802792:	48 c1 e8 0c          	shr    $0xc,%rax
  802796:	48 89 c2             	mov    %rax,%rdx
  802799:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8027a0:	01 00 00 
  8027a3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027a7:	25 07 0e 00 00       	and    $0xe07,%eax
  8027ac:	89 c1                	mov    %eax,%ecx
  8027ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027b2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8027b6:	41 89 c8             	mov    %ecx,%r8d
  8027b9:	48 89 d1             	mov    %rdx,%rcx
  8027bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8027c1:	48 89 c6             	mov    %rax,%rsi
  8027c4:	bf 00 00 00 00       	mov    $0x0,%edi
  8027c9:	48 b8 36 1d 80 00 00 	movabs $0x801d36,%rax
  8027d0:	00 00 00 
  8027d3:	ff d0                	callq  *%rax
  8027d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027dc:	79 02                	jns    8027e0 <dup+0x16f>
		goto err;
  8027de:	eb 05                	jmp    8027e5 <dup+0x174>

	return newfdnum;
  8027e0:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8027e3:	eb 33                	jmp    802818 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8027e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027e9:	48 89 c6             	mov    %rax,%rsi
  8027ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8027f1:	48 b8 91 1d 80 00 00 	movabs $0x801d91,%rax
  8027f8:	00 00 00 
  8027fb:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8027fd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802801:	48 89 c6             	mov    %rax,%rsi
  802804:	bf 00 00 00 00       	mov    $0x0,%edi
  802809:	48 b8 91 1d 80 00 00 	movabs $0x801d91,%rax
  802810:	00 00 00 
  802813:	ff d0                	callq  *%rax
	return r;
  802815:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802818:	c9                   	leaveq 
  802819:	c3                   	retq   

000000000080281a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80281a:	55                   	push   %rbp
  80281b:	48 89 e5             	mov    %rsp,%rbp
  80281e:	48 83 ec 40          	sub    $0x40,%rsp
  802822:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802825:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802829:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80282d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802831:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802834:	48 89 d6             	mov    %rdx,%rsi
  802837:	89 c7                	mov    %eax,%edi
  802839:	48 b8 e8 23 80 00 00 	movabs $0x8023e8,%rax
  802840:	00 00 00 
  802843:	ff d0                	callq  *%rax
  802845:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802848:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80284c:	78 24                	js     802872 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80284e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802852:	8b 00                	mov    (%rax),%eax
  802854:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802858:	48 89 d6             	mov    %rdx,%rsi
  80285b:	89 c7                	mov    %eax,%edi
  80285d:	48 b8 41 25 80 00 00 	movabs $0x802541,%rax
  802864:	00 00 00 
  802867:	ff d0                	callq  *%rax
  802869:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80286c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802870:	79 05                	jns    802877 <read+0x5d>
		return r;
  802872:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802875:	eb 76                	jmp    8028ed <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802877:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80287b:	8b 40 08             	mov    0x8(%rax),%eax
  80287e:	83 e0 03             	and    $0x3,%eax
  802881:	83 f8 01             	cmp    $0x1,%eax
  802884:	75 3a                	jne    8028c0 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802886:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  80288d:	00 00 00 
  802890:	48 8b 00             	mov    (%rax),%rax
  802893:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802899:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80289c:	89 c6                	mov    %eax,%esi
  80289e:	48 bf 17 4f 80 00 00 	movabs $0x804f17,%rdi
  8028a5:	00 00 00 
  8028a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ad:	48 b9 02 08 80 00 00 	movabs $0x800802,%rcx
  8028b4:	00 00 00 
  8028b7:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8028b9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028be:	eb 2d                	jmp    8028ed <read+0xd3>
	}
	if (!dev->dev_read)
  8028c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028c4:	48 8b 40 10          	mov    0x10(%rax),%rax
  8028c8:	48 85 c0             	test   %rax,%rax
  8028cb:	75 07                	jne    8028d4 <read+0xba>
		return -E_NOT_SUPP;
  8028cd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8028d2:	eb 19                	jmp    8028ed <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8028d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028d8:	48 8b 40 10          	mov    0x10(%rax),%rax
  8028dc:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8028e0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8028e4:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8028e8:	48 89 cf             	mov    %rcx,%rdi
  8028eb:	ff d0                	callq  *%rax
}
  8028ed:	c9                   	leaveq 
  8028ee:	c3                   	retq   

00000000008028ef <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8028ef:	55                   	push   %rbp
  8028f0:	48 89 e5             	mov    %rsp,%rbp
  8028f3:	48 83 ec 30          	sub    $0x30,%rsp
  8028f7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8028fa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8028fe:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802902:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802909:	eb 49                	jmp    802954 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80290b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80290e:	48 98                	cltq   
  802910:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802914:	48 29 c2             	sub    %rax,%rdx
  802917:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80291a:	48 63 c8             	movslq %eax,%rcx
  80291d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802921:	48 01 c1             	add    %rax,%rcx
  802924:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802927:	48 89 ce             	mov    %rcx,%rsi
  80292a:	89 c7                	mov    %eax,%edi
  80292c:	48 b8 1a 28 80 00 00 	movabs $0x80281a,%rax
  802933:	00 00 00 
  802936:	ff d0                	callq  *%rax
  802938:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80293b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80293f:	79 05                	jns    802946 <readn+0x57>
			return m;
  802941:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802944:	eb 1c                	jmp    802962 <readn+0x73>
		if (m == 0)
  802946:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80294a:	75 02                	jne    80294e <readn+0x5f>
			break;
  80294c:	eb 11                	jmp    80295f <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80294e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802951:	01 45 fc             	add    %eax,-0x4(%rbp)
  802954:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802957:	48 98                	cltq   
  802959:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80295d:	72 ac                	jb     80290b <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80295f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802962:	c9                   	leaveq 
  802963:	c3                   	retq   

0000000000802964 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802964:	55                   	push   %rbp
  802965:	48 89 e5             	mov    %rsp,%rbp
  802968:	48 83 ec 40          	sub    $0x40,%rsp
  80296c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80296f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802973:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802977:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80297b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80297e:	48 89 d6             	mov    %rdx,%rsi
  802981:	89 c7                	mov    %eax,%edi
  802983:	48 b8 e8 23 80 00 00 	movabs $0x8023e8,%rax
  80298a:	00 00 00 
  80298d:	ff d0                	callq  *%rax
  80298f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802992:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802996:	78 24                	js     8029bc <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802998:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80299c:	8b 00                	mov    (%rax),%eax
  80299e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029a2:	48 89 d6             	mov    %rdx,%rsi
  8029a5:	89 c7                	mov    %eax,%edi
  8029a7:	48 b8 41 25 80 00 00 	movabs $0x802541,%rax
  8029ae:	00 00 00 
  8029b1:	ff d0                	callq  *%rax
  8029b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029ba:	79 05                	jns    8029c1 <write+0x5d>
		return r;
  8029bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029bf:	eb 75                	jmp    802a36 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8029c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029c5:	8b 40 08             	mov    0x8(%rax),%eax
  8029c8:	83 e0 03             	and    $0x3,%eax
  8029cb:	85 c0                	test   %eax,%eax
  8029cd:	75 3a                	jne    802a09 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8029cf:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  8029d6:	00 00 00 
  8029d9:	48 8b 00             	mov    (%rax),%rax
  8029dc:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029e2:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8029e5:	89 c6                	mov    %eax,%esi
  8029e7:	48 bf 33 4f 80 00 00 	movabs $0x804f33,%rdi
  8029ee:	00 00 00 
  8029f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f6:	48 b9 02 08 80 00 00 	movabs $0x800802,%rcx
  8029fd:	00 00 00 
  802a00:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802a02:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a07:	eb 2d                	jmp    802a36 <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  802a09:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a0d:	48 8b 40 18          	mov    0x18(%rax),%rax
  802a11:	48 85 c0             	test   %rax,%rax
  802a14:	75 07                	jne    802a1d <write+0xb9>
		return -E_NOT_SUPP;
  802a16:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a1b:	eb 19                	jmp    802a36 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802a1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a21:	48 8b 40 18          	mov    0x18(%rax),%rax
  802a25:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802a29:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a2d:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802a31:	48 89 cf             	mov    %rcx,%rdi
  802a34:	ff d0                	callq  *%rax
}
  802a36:	c9                   	leaveq 
  802a37:	c3                   	retq   

0000000000802a38 <seek>:

int
seek(int fdnum, off_t offset)
{
  802a38:	55                   	push   %rbp
  802a39:	48 89 e5             	mov    %rsp,%rbp
  802a3c:	48 83 ec 18          	sub    $0x18,%rsp
  802a40:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a43:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a46:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a4a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a4d:	48 89 d6             	mov    %rdx,%rsi
  802a50:	89 c7                	mov    %eax,%edi
  802a52:	48 b8 e8 23 80 00 00 	movabs $0x8023e8,%rax
  802a59:	00 00 00 
  802a5c:	ff d0                	callq  *%rax
  802a5e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a61:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a65:	79 05                	jns    802a6c <seek+0x34>
		return r;
  802a67:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a6a:	eb 0f                	jmp    802a7b <seek+0x43>
	fd->fd_offset = offset;
  802a6c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a70:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802a73:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802a76:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a7b:	c9                   	leaveq 
  802a7c:	c3                   	retq   

0000000000802a7d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802a7d:	55                   	push   %rbp
  802a7e:	48 89 e5             	mov    %rsp,%rbp
  802a81:	48 83 ec 30          	sub    $0x30,%rsp
  802a85:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a88:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a8b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a8f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a92:	48 89 d6             	mov    %rdx,%rsi
  802a95:	89 c7                	mov    %eax,%edi
  802a97:	48 b8 e8 23 80 00 00 	movabs $0x8023e8,%rax
  802a9e:	00 00 00 
  802aa1:	ff d0                	callq  *%rax
  802aa3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aa6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802aaa:	78 24                	js     802ad0 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802aac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ab0:	8b 00                	mov    (%rax),%eax
  802ab2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ab6:	48 89 d6             	mov    %rdx,%rsi
  802ab9:	89 c7                	mov    %eax,%edi
  802abb:	48 b8 41 25 80 00 00 	movabs $0x802541,%rax
  802ac2:	00 00 00 
  802ac5:	ff d0                	callq  *%rax
  802ac7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ace:	79 05                	jns    802ad5 <ftruncate+0x58>
		return r;
  802ad0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ad3:	eb 72                	jmp    802b47 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802ad5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ad9:	8b 40 08             	mov    0x8(%rax),%eax
  802adc:	83 e0 03             	and    $0x3,%eax
  802adf:	85 c0                	test   %eax,%eax
  802ae1:	75 3a                	jne    802b1d <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802ae3:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  802aea:	00 00 00 
  802aed:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802af0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802af6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802af9:	89 c6                	mov    %eax,%esi
  802afb:	48 bf 50 4f 80 00 00 	movabs $0x804f50,%rdi
  802b02:	00 00 00 
  802b05:	b8 00 00 00 00       	mov    $0x0,%eax
  802b0a:	48 b9 02 08 80 00 00 	movabs $0x800802,%rcx
  802b11:	00 00 00 
  802b14:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802b16:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b1b:	eb 2a                	jmp    802b47 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802b1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b21:	48 8b 40 30          	mov    0x30(%rax),%rax
  802b25:	48 85 c0             	test   %rax,%rax
  802b28:	75 07                	jne    802b31 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802b2a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b2f:	eb 16                	jmp    802b47 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802b31:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b35:	48 8b 40 30          	mov    0x30(%rax),%rax
  802b39:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b3d:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802b40:	89 ce                	mov    %ecx,%esi
  802b42:	48 89 d7             	mov    %rdx,%rdi
  802b45:	ff d0                	callq  *%rax
}
  802b47:	c9                   	leaveq 
  802b48:	c3                   	retq   

0000000000802b49 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802b49:	55                   	push   %rbp
  802b4a:	48 89 e5             	mov    %rsp,%rbp
  802b4d:	48 83 ec 30          	sub    $0x30,%rsp
  802b51:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b54:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b58:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b5c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b5f:	48 89 d6             	mov    %rdx,%rsi
  802b62:	89 c7                	mov    %eax,%edi
  802b64:	48 b8 e8 23 80 00 00 	movabs $0x8023e8,%rax
  802b6b:	00 00 00 
  802b6e:	ff d0                	callq  *%rax
  802b70:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b73:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b77:	78 24                	js     802b9d <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b79:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b7d:	8b 00                	mov    (%rax),%eax
  802b7f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b83:	48 89 d6             	mov    %rdx,%rsi
  802b86:	89 c7                	mov    %eax,%edi
  802b88:	48 b8 41 25 80 00 00 	movabs $0x802541,%rax
  802b8f:	00 00 00 
  802b92:	ff d0                	callq  *%rax
  802b94:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b97:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b9b:	79 05                	jns    802ba2 <fstat+0x59>
		return r;
  802b9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ba0:	eb 5e                	jmp    802c00 <fstat+0xb7>
	if (!dev->dev_stat)
  802ba2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ba6:	48 8b 40 28          	mov    0x28(%rax),%rax
  802baa:	48 85 c0             	test   %rax,%rax
  802bad:	75 07                	jne    802bb6 <fstat+0x6d>
		return -E_NOT_SUPP;
  802baf:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802bb4:	eb 4a                	jmp    802c00 <fstat+0xb7>
	stat->st_name[0] = 0;
  802bb6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bba:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802bbd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bc1:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802bc8:	00 00 00 
	stat->st_isdir = 0;
  802bcb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bcf:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802bd6:	00 00 00 
	stat->st_dev = dev;
  802bd9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802bdd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802be1:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802be8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bec:	48 8b 40 28          	mov    0x28(%rax),%rax
  802bf0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802bf4:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802bf8:	48 89 ce             	mov    %rcx,%rsi
  802bfb:	48 89 d7             	mov    %rdx,%rdi
  802bfe:	ff d0                	callq  *%rax
}
  802c00:	c9                   	leaveq 
  802c01:	c3                   	retq   

0000000000802c02 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802c02:	55                   	push   %rbp
  802c03:	48 89 e5             	mov    %rsp,%rbp
  802c06:	48 83 ec 20          	sub    $0x20,%rsp
  802c0a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c0e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802c12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c16:	be 00 00 00 00       	mov    $0x0,%esi
  802c1b:	48 89 c7             	mov    %rax,%rdi
  802c1e:	48 b8 f0 2c 80 00 00 	movabs $0x802cf0,%rax
  802c25:	00 00 00 
  802c28:	ff d0                	callq  *%rax
  802c2a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c2d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c31:	79 05                	jns    802c38 <stat+0x36>
		return fd;
  802c33:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c36:	eb 2f                	jmp    802c67 <stat+0x65>
	r = fstat(fd, stat);
  802c38:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c3f:	48 89 d6             	mov    %rdx,%rsi
  802c42:	89 c7                	mov    %eax,%edi
  802c44:	48 b8 49 2b 80 00 00 	movabs $0x802b49,%rax
  802c4b:	00 00 00 
  802c4e:	ff d0                	callq  *%rax
  802c50:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802c53:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c56:	89 c7                	mov    %eax,%edi
  802c58:	48 b8 f8 25 80 00 00 	movabs $0x8025f8,%rax
  802c5f:	00 00 00 
  802c62:	ff d0                	callq  *%rax
	return r;
  802c64:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802c67:	c9                   	leaveq 
  802c68:	c3                   	retq   

0000000000802c69 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802c69:	55                   	push   %rbp
  802c6a:	48 89 e5             	mov    %rsp,%rbp
  802c6d:	48 83 ec 10          	sub    $0x10,%rsp
  802c71:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802c74:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802c78:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c7f:	00 00 00 
  802c82:	8b 00                	mov    (%rax),%eax
  802c84:	85 c0                	test   %eax,%eax
  802c86:	75 1d                	jne    802ca5 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802c88:	bf 01 00 00 00       	mov    $0x1,%edi
  802c8d:	48 b8 fa 47 80 00 00 	movabs $0x8047fa,%rax
  802c94:	00 00 00 
  802c97:	ff d0                	callq  *%rax
  802c99:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802ca0:	00 00 00 
  802ca3:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802ca5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802cac:	00 00 00 
  802caf:	8b 00                	mov    (%rax),%eax
  802cb1:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802cb4:	b9 07 00 00 00       	mov    $0x7,%ecx
  802cb9:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  802cc0:	00 00 00 
  802cc3:	89 c7                	mov    %eax,%edi
  802cc5:	48 b8 98 47 80 00 00 	movabs $0x804798,%rax
  802ccc:	00 00 00 
  802ccf:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802cd1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cd5:	ba 00 00 00 00       	mov    $0x0,%edx
  802cda:	48 89 c6             	mov    %rax,%rsi
  802cdd:	bf 00 00 00 00       	mov    $0x0,%edi
  802ce2:	48 b8 92 46 80 00 00 	movabs $0x804692,%rax
  802ce9:	00 00 00 
  802cec:	ff d0                	callq  *%rax
}
  802cee:	c9                   	leaveq 
  802cef:	c3                   	retq   

0000000000802cf0 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802cf0:	55                   	push   %rbp
  802cf1:	48 89 e5             	mov    %rsp,%rbp
  802cf4:	48 83 ec 30          	sub    $0x30,%rsp
  802cf8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802cfc:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802cff:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802d06:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802d0d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802d14:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802d19:	75 08                	jne    802d23 <open+0x33>
	{
		return r;
  802d1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d1e:	e9 f2 00 00 00       	jmpq   802e15 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802d23:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d27:	48 89 c7             	mov    %rax,%rdi
  802d2a:	48 b8 4b 13 80 00 00 	movabs $0x80134b,%rax
  802d31:	00 00 00 
  802d34:	ff d0                	callq  *%rax
  802d36:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802d39:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802d40:	7e 0a                	jle    802d4c <open+0x5c>
	{
		return -E_BAD_PATH;
  802d42:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802d47:	e9 c9 00 00 00       	jmpq   802e15 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802d4c:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802d53:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802d54:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802d58:	48 89 c7             	mov    %rax,%rdi
  802d5b:	48 b8 50 23 80 00 00 	movabs $0x802350,%rax
  802d62:	00 00 00 
  802d65:	ff d0                	callq  *%rax
  802d67:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d6a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d6e:	78 09                	js     802d79 <open+0x89>
  802d70:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d74:	48 85 c0             	test   %rax,%rax
  802d77:	75 08                	jne    802d81 <open+0x91>
		{
			return r;
  802d79:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d7c:	e9 94 00 00 00       	jmpq   802e15 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802d81:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d85:	ba 00 04 00 00       	mov    $0x400,%edx
  802d8a:	48 89 c6             	mov    %rax,%rsi
  802d8d:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802d94:	00 00 00 
  802d97:	48 b8 49 14 80 00 00 	movabs $0x801449,%rax
  802d9e:	00 00 00 
  802da1:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802da3:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802daa:	00 00 00 
  802dad:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802db0:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802db6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dba:	48 89 c6             	mov    %rax,%rsi
  802dbd:	bf 01 00 00 00       	mov    $0x1,%edi
  802dc2:	48 b8 69 2c 80 00 00 	movabs $0x802c69,%rax
  802dc9:	00 00 00 
  802dcc:	ff d0                	callq  *%rax
  802dce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dd1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dd5:	79 2b                	jns    802e02 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802dd7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ddb:	be 00 00 00 00       	mov    $0x0,%esi
  802de0:	48 89 c7             	mov    %rax,%rdi
  802de3:	48 b8 78 24 80 00 00 	movabs $0x802478,%rax
  802dea:	00 00 00 
  802ded:	ff d0                	callq  *%rax
  802def:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802df2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802df6:	79 05                	jns    802dfd <open+0x10d>
			{
				return d;
  802df8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802dfb:	eb 18                	jmp    802e15 <open+0x125>
			}
			return r;
  802dfd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e00:	eb 13                	jmp    802e15 <open+0x125>
		}	
		return fd2num(fd_store);
  802e02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e06:	48 89 c7             	mov    %rax,%rdi
  802e09:	48 b8 02 23 80 00 00 	movabs $0x802302,%rax
  802e10:	00 00 00 
  802e13:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802e15:	c9                   	leaveq 
  802e16:	c3                   	retq   

0000000000802e17 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802e17:	55                   	push   %rbp
  802e18:	48 89 e5             	mov    %rsp,%rbp
  802e1b:	48 83 ec 10          	sub    $0x10,%rsp
  802e1f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802e23:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e27:	8b 50 0c             	mov    0xc(%rax),%edx
  802e2a:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802e31:	00 00 00 
  802e34:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802e36:	be 00 00 00 00       	mov    $0x0,%esi
  802e3b:	bf 06 00 00 00       	mov    $0x6,%edi
  802e40:	48 b8 69 2c 80 00 00 	movabs $0x802c69,%rax
  802e47:	00 00 00 
  802e4a:	ff d0                	callq  *%rax
}
  802e4c:	c9                   	leaveq 
  802e4d:	c3                   	retq   

0000000000802e4e <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802e4e:	55                   	push   %rbp
  802e4f:	48 89 e5             	mov    %rsp,%rbp
  802e52:	48 83 ec 30          	sub    $0x30,%rsp
  802e56:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e5a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e5e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802e62:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802e69:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802e6e:	74 07                	je     802e77 <devfile_read+0x29>
  802e70:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802e75:	75 07                	jne    802e7e <devfile_read+0x30>
		return -E_INVAL;
  802e77:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e7c:	eb 77                	jmp    802ef5 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802e7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e82:	8b 50 0c             	mov    0xc(%rax),%edx
  802e85:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802e8c:	00 00 00 
  802e8f:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802e91:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802e98:	00 00 00 
  802e9b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e9f:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802ea3:	be 00 00 00 00       	mov    $0x0,%esi
  802ea8:	bf 03 00 00 00       	mov    $0x3,%edi
  802ead:	48 b8 69 2c 80 00 00 	movabs $0x802c69,%rax
  802eb4:	00 00 00 
  802eb7:	ff d0                	callq  *%rax
  802eb9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ebc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ec0:	7f 05                	jg     802ec7 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802ec2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ec5:	eb 2e                	jmp    802ef5 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802ec7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eca:	48 63 d0             	movslq %eax,%rdx
  802ecd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ed1:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  802ed8:	00 00 00 
  802edb:	48 89 c7             	mov    %rax,%rdi
  802ede:	48 b8 db 16 80 00 00 	movabs $0x8016db,%rax
  802ee5:	00 00 00 
  802ee8:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802eea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802eee:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802ef2:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802ef5:	c9                   	leaveq 
  802ef6:	c3                   	retq   

0000000000802ef7 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802ef7:	55                   	push   %rbp
  802ef8:	48 89 e5             	mov    %rsp,%rbp
  802efb:	48 83 ec 30          	sub    $0x30,%rsp
  802eff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f03:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f07:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802f0b:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802f12:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802f17:	74 07                	je     802f20 <devfile_write+0x29>
  802f19:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802f1e:	75 08                	jne    802f28 <devfile_write+0x31>
		return r;
  802f20:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f23:	e9 9a 00 00 00       	jmpq   802fc2 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802f28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f2c:	8b 50 0c             	mov    0xc(%rax),%edx
  802f2f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802f36:	00 00 00 
  802f39:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802f3b:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802f42:	00 
  802f43:	76 08                	jbe    802f4d <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802f45:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802f4c:	00 
	}
	fsipcbuf.write.req_n = n;
  802f4d:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802f54:	00 00 00 
  802f57:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f5b:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802f5f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f63:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f67:	48 89 c6             	mov    %rax,%rsi
  802f6a:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  802f71:	00 00 00 
  802f74:	48 b8 db 16 80 00 00 	movabs $0x8016db,%rax
  802f7b:	00 00 00 
  802f7e:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802f80:	be 00 00 00 00       	mov    $0x0,%esi
  802f85:	bf 04 00 00 00       	mov    $0x4,%edi
  802f8a:	48 b8 69 2c 80 00 00 	movabs $0x802c69,%rax
  802f91:	00 00 00 
  802f94:	ff d0                	callq  *%rax
  802f96:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f99:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f9d:	7f 20                	jg     802fbf <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802f9f:	48 bf 76 4f 80 00 00 	movabs $0x804f76,%rdi
  802fa6:	00 00 00 
  802fa9:	b8 00 00 00 00       	mov    $0x0,%eax
  802fae:	48 ba 02 08 80 00 00 	movabs $0x800802,%rdx
  802fb5:	00 00 00 
  802fb8:	ff d2                	callq  *%rdx
		return r;
  802fba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fbd:	eb 03                	jmp    802fc2 <devfile_write+0xcb>
	}
	return r;
  802fbf:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802fc2:	c9                   	leaveq 
  802fc3:	c3                   	retq   

0000000000802fc4 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802fc4:	55                   	push   %rbp
  802fc5:	48 89 e5             	mov    %rsp,%rbp
  802fc8:	48 83 ec 20          	sub    $0x20,%rsp
  802fcc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802fd0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802fd4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fd8:	8b 50 0c             	mov    0xc(%rax),%edx
  802fdb:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802fe2:	00 00 00 
  802fe5:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802fe7:	be 00 00 00 00       	mov    $0x0,%esi
  802fec:	bf 05 00 00 00       	mov    $0x5,%edi
  802ff1:	48 b8 69 2c 80 00 00 	movabs $0x802c69,%rax
  802ff8:	00 00 00 
  802ffb:	ff d0                	callq  *%rax
  802ffd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803000:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803004:	79 05                	jns    80300b <devfile_stat+0x47>
		return r;
  803006:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803009:	eb 56                	jmp    803061 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80300b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80300f:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  803016:	00 00 00 
  803019:	48 89 c7             	mov    %rax,%rdi
  80301c:	48 b8 b7 13 80 00 00 	movabs $0x8013b7,%rax
  803023:	00 00 00 
  803026:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803028:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80302f:	00 00 00 
  803032:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803038:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80303c:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803042:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803049:	00 00 00 
  80304c:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803052:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803056:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80305c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803061:	c9                   	leaveq 
  803062:	c3                   	retq   

0000000000803063 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803063:	55                   	push   %rbp
  803064:	48 89 e5             	mov    %rsp,%rbp
  803067:	48 83 ec 10          	sub    $0x10,%rsp
  80306b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80306f:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803072:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803076:	8b 50 0c             	mov    0xc(%rax),%edx
  803079:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803080:	00 00 00 
  803083:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803085:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80308c:	00 00 00 
  80308f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803092:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803095:	be 00 00 00 00       	mov    $0x0,%esi
  80309a:	bf 02 00 00 00       	mov    $0x2,%edi
  80309f:	48 b8 69 2c 80 00 00 	movabs $0x802c69,%rax
  8030a6:	00 00 00 
  8030a9:	ff d0                	callq  *%rax
}
  8030ab:	c9                   	leaveq 
  8030ac:	c3                   	retq   

00000000008030ad <remove>:

// Delete a file
int
remove(const char *path)
{
  8030ad:	55                   	push   %rbp
  8030ae:	48 89 e5             	mov    %rsp,%rbp
  8030b1:	48 83 ec 10          	sub    $0x10,%rsp
  8030b5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8030b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030bd:	48 89 c7             	mov    %rax,%rdi
  8030c0:	48 b8 4b 13 80 00 00 	movabs $0x80134b,%rax
  8030c7:	00 00 00 
  8030ca:	ff d0                	callq  *%rax
  8030cc:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8030d1:	7e 07                	jle    8030da <remove+0x2d>
		return -E_BAD_PATH;
  8030d3:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8030d8:	eb 33                	jmp    80310d <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8030da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030de:	48 89 c6             	mov    %rax,%rsi
  8030e1:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8030e8:	00 00 00 
  8030eb:	48 b8 b7 13 80 00 00 	movabs $0x8013b7,%rax
  8030f2:	00 00 00 
  8030f5:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8030f7:	be 00 00 00 00       	mov    $0x0,%esi
  8030fc:	bf 07 00 00 00       	mov    $0x7,%edi
  803101:	48 b8 69 2c 80 00 00 	movabs $0x802c69,%rax
  803108:	00 00 00 
  80310b:	ff d0                	callq  *%rax
}
  80310d:	c9                   	leaveq 
  80310e:	c3                   	retq   

000000000080310f <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80310f:	55                   	push   %rbp
  803110:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803113:	be 00 00 00 00       	mov    $0x0,%esi
  803118:	bf 08 00 00 00       	mov    $0x8,%edi
  80311d:	48 b8 69 2c 80 00 00 	movabs $0x802c69,%rax
  803124:	00 00 00 
  803127:	ff d0                	callq  *%rax
}
  803129:	5d                   	pop    %rbp
  80312a:	c3                   	retq   

000000000080312b <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  80312b:	55                   	push   %rbp
  80312c:	48 89 e5             	mov    %rsp,%rbp
  80312f:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803136:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  80313d:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803144:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  80314b:	be 00 00 00 00       	mov    $0x0,%esi
  803150:	48 89 c7             	mov    %rax,%rdi
  803153:	48 b8 f0 2c 80 00 00 	movabs $0x802cf0,%rax
  80315a:	00 00 00 
  80315d:	ff d0                	callq  *%rax
  80315f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803162:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803166:	79 28                	jns    803190 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803168:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80316b:	89 c6                	mov    %eax,%esi
  80316d:	48 bf 92 4f 80 00 00 	movabs $0x804f92,%rdi
  803174:	00 00 00 
  803177:	b8 00 00 00 00       	mov    $0x0,%eax
  80317c:	48 ba 02 08 80 00 00 	movabs $0x800802,%rdx
  803183:	00 00 00 
  803186:	ff d2                	callq  *%rdx
		return fd_src;
  803188:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80318b:	e9 74 01 00 00       	jmpq   803304 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803190:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803197:	be 01 01 00 00       	mov    $0x101,%esi
  80319c:	48 89 c7             	mov    %rax,%rdi
  80319f:	48 b8 f0 2c 80 00 00 	movabs $0x802cf0,%rax
  8031a6:	00 00 00 
  8031a9:	ff d0                	callq  *%rax
  8031ab:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8031ae:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8031b2:	79 39                	jns    8031ed <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8031b4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031b7:	89 c6                	mov    %eax,%esi
  8031b9:	48 bf a8 4f 80 00 00 	movabs $0x804fa8,%rdi
  8031c0:	00 00 00 
  8031c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8031c8:	48 ba 02 08 80 00 00 	movabs $0x800802,%rdx
  8031cf:	00 00 00 
  8031d2:	ff d2                	callq  *%rdx
		close(fd_src);
  8031d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031d7:	89 c7                	mov    %eax,%edi
  8031d9:	48 b8 f8 25 80 00 00 	movabs $0x8025f8,%rax
  8031e0:	00 00 00 
  8031e3:	ff d0                	callq  *%rax
		return fd_dest;
  8031e5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031e8:	e9 17 01 00 00       	jmpq   803304 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8031ed:	eb 74                	jmp    803263 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8031ef:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8031f2:	48 63 d0             	movslq %eax,%rdx
  8031f5:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8031fc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031ff:	48 89 ce             	mov    %rcx,%rsi
  803202:	89 c7                	mov    %eax,%edi
  803204:	48 b8 64 29 80 00 00 	movabs $0x802964,%rax
  80320b:	00 00 00 
  80320e:	ff d0                	callq  *%rax
  803210:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803213:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803217:	79 4a                	jns    803263 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  803219:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80321c:	89 c6                	mov    %eax,%esi
  80321e:	48 bf c2 4f 80 00 00 	movabs $0x804fc2,%rdi
  803225:	00 00 00 
  803228:	b8 00 00 00 00       	mov    $0x0,%eax
  80322d:	48 ba 02 08 80 00 00 	movabs $0x800802,%rdx
  803234:	00 00 00 
  803237:	ff d2                	callq  *%rdx
			close(fd_src);
  803239:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80323c:	89 c7                	mov    %eax,%edi
  80323e:	48 b8 f8 25 80 00 00 	movabs $0x8025f8,%rax
  803245:	00 00 00 
  803248:	ff d0                	callq  *%rax
			close(fd_dest);
  80324a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80324d:	89 c7                	mov    %eax,%edi
  80324f:	48 b8 f8 25 80 00 00 	movabs $0x8025f8,%rax
  803256:	00 00 00 
  803259:	ff d0                	callq  *%rax
			return write_size;
  80325b:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80325e:	e9 a1 00 00 00       	jmpq   803304 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803263:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80326a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80326d:	ba 00 02 00 00       	mov    $0x200,%edx
  803272:	48 89 ce             	mov    %rcx,%rsi
  803275:	89 c7                	mov    %eax,%edi
  803277:	48 b8 1a 28 80 00 00 	movabs $0x80281a,%rax
  80327e:	00 00 00 
  803281:	ff d0                	callq  *%rax
  803283:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803286:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80328a:	0f 8f 5f ff ff ff    	jg     8031ef <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803290:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803294:	79 47                	jns    8032dd <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803296:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803299:	89 c6                	mov    %eax,%esi
  80329b:	48 bf d5 4f 80 00 00 	movabs $0x804fd5,%rdi
  8032a2:	00 00 00 
  8032a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8032aa:	48 ba 02 08 80 00 00 	movabs $0x800802,%rdx
  8032b1:	00 00 00 
  8032b4:	ff d2                	callq  *%rdx
		close(fd_src);
  8032b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032b9:	89 c7                	mov    %eax,%edi
  8032bb:	48 b8 f8 25 80 00 00 	movabs $0x8025f8,%rax
  8032c2:	00 00 00 
  8032c5:	ff d0                	callq  *%rax
		close(fd_dest);
  8032c7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8032ca:	89 c7                	mov    %eax,%edi
  8032cc:	48 b8 f8 25 80 00 00 	movabs $0x8025f8,%rax
  8032d3:	00 00 00 
  8032d6:	ff d0                	callq  *%rax
		return read_size;
  8032d8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8032db:	eb 27                	jmp    803304 <copy+0x1d9>
	}
	close(fd_src);
  8032dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032e0:	89 c7                	mov    %eax,%edi
  8032e2:	48 b8 f8 25 80 00 00 	movabs $0x8025f8,%rax
  8032e9:	00 00 00 
  8032ec:	ff d0                	callq  *%rax
	close(fd_dest);
  8032ee:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8032f1:	89 c7                	mov    %eax,%edi
  8032f3:	48 b8 f8 25 80 00 00 	movabs $0x8025f8,%rax
  8032fa:	00 00 00 
  8032fd:	ff d0                	callq  *%rax
	return 0;
  8032ff:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803304:	c9                   	leaveq 
  803305:	c3                   	retq   

0000000000803306 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  803306:	55                   	push   %rbp
  803307:	48 89 e5             	mov    %rsp,%rbp
  80330a:	48 83 ec 20          	sub    $0x20,%rsp
  80330e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  803312:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803316:	8b 40 0c             	mov    0xc(%rax),%eax
  803319:	85 c0                	test   %eax,%eax
  80331b:	7e 67                	jle    803384 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  80331d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803321:	8b 40 04             	mov    0x4(%rax),%eax
  803324:	48 63 d0             	movslq %eax,%rdx
  803327:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80332b:	48 8d 48 10          	lea    0x10(%rax),%rcx
  80332f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803333:	8b 00                	mov    (%rax),%eax
  803335:	48 89 ce             	mov    %rcx,%rsi
  803338:	89 c7                	mov    %eax,%edi
  80333a:	48 b8 64 29 80 00 00 	movabs $0x802964,%rax
  803341:	00 00 00 
  803344:	ff d0                	callq  *%rax
  803346:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  803349:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80334d:	7e 13                	jle    803362 <writebuf+0x5c>
			b->result += result;
  80334f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803353:	8b 50 08             	mov    0x8(%rax),%edx
  803356:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803359:	01 c2                	add    %eax,%edx
  80335b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80335f:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  803362:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803366:	8b 40 04             	mov    0x4(%rax),%eax
  803369:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  80336c:	74 16                	je     803384 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  80336e:	b8 00 00 00 00       	mov    $0x0,%eax
  803373:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803377:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  80337b:	89 c2                	mov    %eax,%edx
  80337d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803381:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  803384:	c9                   	leaveq 
  803385:	c3                   	retq   

0000000000803386 <putch>:

static void
putch(int ch, void *thunk)
{
  803386:	55                   	push   %rbp
  803387:	48 89 e5             	mov    %rsp,%rbp
  80338a:	48 83 ec 20          	sub    $0x20,%rsp
  80338e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803391:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  803395:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803399:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  80339d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033a1:	8b 40 04             	mov    0x4(%rax),%eax
  8033a4:	8d 48 01             	lea    0x1(%rax),%ecx
  8033a7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8033ab:	89 4a 04             	mov    %ecx,0x4(%rdx)
  8033ae:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8033b1:	89 d1                	mov    %edx,%ecx
  8033b3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8033b7:	48 98                	cltq   
  8033b9:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  8033bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033c1:	8b 40 04             	mov    0x4(%rax),%eax
  8033c4:	3d 00 01 00 00       	cmp    $0x100,%eax
  8033c9:	75 1e                	jne    8033e9 <putch+0x63>
		writebuf(b);
  8033cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033cf:	48 89 c7             	mov    %rax,%rdi
  8033d2:	48 b8 06 33 80 00 00 	movabs $0x803306,%rax
  8033d9:	00 00 00 
  8033dc:	ff d0                	callq  *%rax
		b->idx = 0;
  8033de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  8033e9:	c9                   	leaveq 
  8033ea:	c3                   	retq   

00000000008033eb <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8033eb:	55                   	push   %rbp
  8033ec:	48 89 e5             	mov    %rsp,%rbp
  8033ef:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  8033f6:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  8033fc:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  803403:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  80340a:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  803410:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  803416:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80341d:	00 00 00 
	b.result = 0;
  803420:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  803427:	00 00 00 
	b.error = 1;
  80342a:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  803431:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  803434:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  80343b:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  803442:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  803449:	48 89 c6             	mov    %rax,%rsi
  80344c:	48 bf 86 33 80 00 00 	movabs $0x803386,%rdi
  803453:	00 00 00 
  803456:	48 b8 b5 0b 80 00 00 	movabs $0x800bb5,%rax
  80345d:	00 00 00 
  803460:	ff d0                	callq  *%rax
	if (b.idx > 0)
  803462:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  803468:	85 c0                	test   %eax,%eax
  80346a:	7e 16                	jle    803482 <vfprintf+0x97>
		writebuf(&b);
  80346c:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  803473:	48 89 c7             	mov    %rax,%rdi
  803476:	48 b8 06 33 80 00 00 	movabs $0x803306,%rax
  80347d:	00 00 00 
  803480:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  803482:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  803488:	85 c0                	test   %eax,%eax
  80348a:	74 08                	je     803494 <vfprintf+0xa9>
  80348c:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  803492:	eb 06                	jmp    80349a <vfprintf+0xaf>
  803494:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  80349a:	c9                   	leaveq 
  80349b:	c3                   	retq   

000000000080349c <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  80349c:	55                   	push   %rbp
  80349d:	48 89 e5             	mov    %rsp,%rbp
  8034a0:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  8034a7:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  8034ad:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8034b4:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8034bb:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8034c2:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8034c9:	84 c0                	test   %al,%al
  8034cb:	74 20                	je     8034ed <fprintf+0x51>
  8034cd:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8034d1:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8034d5:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8034d9:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8034dd:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8034e1:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8034e5:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8034e9:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8034ed:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8034f4:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  8034fb:	00 00 00 
  8034fe:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803505:	00 00 00 
  803508:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80350c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803513:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80351a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  803521:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803528:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  80352f:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803535:	48 89 ce             	mov    %rcx,%rsi
  803538:	89 c7                	mov    %eax,%edi
  80353a:	48 b8 eb 33 80 00 00 	movabs $0x8033eb,%rax
  803541:	00 00 00 
  803544:	ff d0                	callq  *%rax
  803546:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  80354c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803552:	c9                   	leaveq 
  803553:	c3                   	retq   

0000000000803554 <printf>:

int
printf(const char *fmt, ...)
{
  803554:	55                   	push   %rbp
  803555:	48 89 e5             	mov    %rsp,%rbp
  803558:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  80355f:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  803566:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80356d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803574:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80357b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803582:	84 c0                	test   %al,%al
  803584:	74 20                	je     8035a6 <printf+0x52>
  803586:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80358a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80358e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803592:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803596:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80359a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80359e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8035a2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8035a6:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8035ad:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8035b4:	00 00 00 
  8035b7:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8035be:	00 00 00 
  8035c1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8035c5:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8035cc:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8035d3:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  8035da:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8035e1:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8035e8:	48 89 c6             	mov    %rax,%rsi
  8035eb:	bf 01 00 00 00       	mov    $0x1,%edi
  8035f0:	48 b8 eb 33 80 00 00 	movabs $0x8033eb,%rax
  8035f7:	00 00 00 
  8035fa:	ff d0                	callq  *%rax
  8035fc:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  803602:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803608:	c9                   	leaveq 
  803609:	c3                   	retq   

000000000080360a <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  80360a:	55                   	push   %rbp
  80360b:	48 89 e5             	mov    %rsp,%rbp
  80360e:	48 83 ec 20          	sub    $0x20,%rsp
  803612:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803615:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803619:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80361c:	48 89 d6             	mov    %rdx,%rsi
  80361f:	89 c7                	mov    %eax,%edi
  803621:	48 b8 e8 23 80 00 00 	movabs $0x8023e8,%rax
  803628:	00 00 00 
  80362b:	ff d0                	callq  *%rax
  80362d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803630:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803634:	79 05                	jns    80363b <fd2sockid+0x31>
		return r;
  803636:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803639:	eb 24                	jmp    80365f <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  80363b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80363f:	8b 10                	mov    (%rax),%edx
  803641:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  803648:	00 00 00 
  80364b:	8b 00                	mov    (%rax),%eax
  80364d:	39 c2                	cmp    %eax,%edx
  80364f:	74 07                	je     803658 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803651:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803656:	eb 07                	jmp    80365f <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803658:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80365c:	8b 40 0c             	mov    0xc(%rax),%eax
}
  80365f:	c9                   	leaveq 
  803660:	c3                   	retq   

0000000000803661 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803661:	55                   	push   %rbp
  803662:	48 89 e5             	mov    %rsp,%rbp
  803665:	48 83 ec 20          	sub    $0x20,%rsp
  803669:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  80366c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803670:	48 89 c7             	mov    %rax,%rdi
  803673:	48 b8 50 23 80 00 00 	movabs $0x802350,%rax
  80367a:	00 00 00 
  80367d:	ff d0                	callq  *%rax
  80367f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803682:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803686:	78 26                	js     8036ae <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803688:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80368c:	ba 07 04 00 00       	mov    $0x407,%edx
  803691:	48 89 c6             	mov    %rax,%rsi
  803694:	bf 00 00 00 00       	mov    $0x0,%edi
  803699:	48 b8 e6 1c 80 00 00 	movabs $0x801ce6,%rax
  8036a0:	00 00 00 
  8036a3:	ff d0                	callq  *%rax
  8036a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036ac:	79 16                	jns    8036c4 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8036ae:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036b1:	89 c7                	mov    %eax,%edi
  8036b3:	48 b8 6e 3b 80 00 00 	movabs $0x803b6e,%rax
  8036ba:	00 00 00 
  8036bd:	ff d0                	callq  *%rax
		return r;
  8036bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036c2:	eb 3a                	jmp    8036fe <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8036c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036c8:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  8036cf:	00 00 00 
  8036d2:	8b 12                	mov    (%rdx),%edx
  8036d4:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8036d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036da:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8036e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036e5:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8036e8:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8036eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036ef:	48 89 c7             	mov    %rax,%rdi
  8036f2:	48 b8 02 23 80 00 00 	movabs $0x802302,%rax
  8036f9:	00 00 00 
  8036fc:	ff d0                	callq  *%rax
}
  8036fe:	c9                   	leaveq 
  8036ff:	c3                   	retq   

0000000000803700 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803700:	55                   	push   %rbp
  803701:	48 89 e5             	mov    %rsp,%rbp
  803704:	48 83 ec 30          	sub    $0x30,%rsp
  803708:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80370b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80370f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803713:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803716:	89 c7                	mov    %eax,%edi
  803718:	48 b8 0a 36 80 00 00 	movabs $0x80360a,%rax
  80371f:	00 00 00 
  803722:	ff d0                	callq  *%rax
  803724:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803727:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80372b:	79 05                	jns    803732 <accept+0x32>
		return r;
  80372d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803730:	eb 3b                	jmp    80376d <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803732:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803736:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80373a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80373d:	48 89 ce             	mov    %rcx,%rsi
  803740:	89 c7                	mov    %eax,%edi
  803742:	48 b8 4b 3a 80 00 00 	movabs $0x803a4b,%rax
  803749:	00 00 00 
  80374c:	ff d0                	callq  *%rax
  80374e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803751:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803755:	79 05                	jns    80375c <accept+0x5c>
		return r;
  803757:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80375a:	eb 11                	jmp    80376d <accept+0x6d>
	return alloc_sockfd(r);
  80375c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80375f:	89 c7                	mov    %eax,%edi
  803761:	48 b8 61 36 80 00 00 	movabs $0x803661,%rax
  803768:	00 00 00 
  80376b:	ff d0                	callq  *%rax
}
  80376d:	c9                   	leaveq 
  80376e:	c3                   	retq   

000000000080376f <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80376f:	55                   	push   %rbp
  803770:	48 89 e5             	mov    %rsp,%rbp
  803773:	48 83 ec 20          	sub    $0x20,%rsp
  803777:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80377a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80377e:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803781:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803784:	89 c7                	mov    %eax,%edi
  803786:	48 b8 0a 36 80 00 00 	movabs $0x80360a,%rax
  80378d:	00 00 00 
  803790:	ff d0                	callq  *%rax
  803792:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803795:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803799:	79 05                	jns    8037a0 <bind+0x31>
		return r;
  80379b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80379e:	eb 1b                	jmp    8037bb <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8037a0:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8037a3:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8037a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037aa:	48 89 ce             	mov    %rcx,%rsi
  8037ad:	89 c7                	mov    %eax,%edi
  8037af:	48 b8 ca 3a 80 00 00 	movabs $0x803aca,%rax
  8037b6:	00 00 00 
  8037b9:	ff d0                	callq  *%rax
}
  8037bb:	c9                   	leaveq 
  8037bc:	c3                   	retq   

00000000008037bd <shutdown>:

int
shutdown(int s, int how)
{
  8037bd:	55                   	push   %rbp
  8037be:	48 89 e5             	mov    %rsp,%rbp
  8037c1:	48 83 ec 20          	sub    $0x20,%rsp
  8037c5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8037c8:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8037cb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037ce:	89 c7                	mov    %eax,%edi
  8037d0:	48 b8 0a 36 80 00 00 	movabs $0x80360a,%rax
  8037d7:	00 00 00 
  8037da:	ff d0                	callq  *%rax
  8037dc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037df:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037e3:	79 05                	jns    8037ea <shutdown+0x2d>
		return r;
  8037e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037e8:	eb 16                	jmp    803800 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8037ea:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8037ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037f0:	89 d6                	mov    %edx,%esi
  8037f2:	89 c7                	mov    %eax,%edi
  8037f4:	48 b8 2e 3b 80 00 00 	movabs $0x803b2e,%rax
  8037fb:	00 00 00 
  8037fe:	ff d0                	callq  *%rax
}
  803800:	c9                   	leaveq 
  803801:	c3                   	retq   

0000000000803802 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803802:	55                   	push   %rbp
  803803:	48 89 e5             	mov    %rsp,%rbp
  803806:	48 83 ec 10          	sub    $0x10,%rsp
  80380a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  80380e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803812:	48 89 c7             	mov    %rax,%rdi
  803815:	48 b8 7c 48 80 00 00 	movabs $0x80487c,%rax
  80381c:	00 00 00 
  80381f:	ff d0                	callq  *%rax
  803821:	83 f8 01             	cmp    $0x1,%eax
  803824:	75 17                	jne    80383d <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803826:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80382a:	8b 40 0c             	mov    0xc(%rax),%eax
  80382d:	89 c7                	mov    %eax,%edi
  80382f:	48 b8 6e 3b 80 00 00 	movabs $0x803b6e,%rax
  803836:	00 00 00 
  803839:	ff d0                	callq  *%rax
  80383b:	eb 05                	jmp    803842 <devsock_close+0x40>
	else
		return 0;
  80383d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803842:	c9                   	leaveq 
  803843:	c3                   	retq   

0000000000803844 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803844:	55                   	push   %rbp
  803845:	48 89 e5             	mov    %rsp,%rbp
  803848:	48 83 ec 20          	sub    $0x20,%rsp
  80384c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80384f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803853:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803856:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803859:	89 c7                	mov    %eax,%edi
  80385b:	48 b8 0a 36 80 00 00 	movabs $0x80360a,%rax
  803862:	00 00 00 
  803865:	ff d0                	callq  *%rax
  803867:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80386a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80386e:	79 05                	jns    803875 <connect+0x31>
		return r;
  803870:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803873:	eb 1b                	jmp    803890 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803875:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803878:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80387c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80387f:	48 89 ce             	mov    %rcx,%rsi
  803882:	89 c7                	mov    %eax,%edi
  803884:	48 b8 9b 3b 80 00 00 	movabs $0x803b9b,%rax
  80388b:	00 00 00 
  80388e:	ff d0                	callq  *%rax
}
  803890:	c9                   	leaveq 
  803891:	c3                   	retq   

0000000000803892 <listen>:

int
listen(int s, int backlog)
{
  803892:	55                   	push   %rbp
  803893:	48 89 e5             	mov    %rsp,%rbp
  803896:	48 83 ec 20          	sub    $0x20,%rsp
  80389a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80389d:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8038a0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038a3:	89 c7                	mov    %eax,%edi
  8038a5:	48 b8 0a 36 80 00 00 	movabs $0x80360a,%rax
  8038ac:	00 00 00 
  8038af:	ff d0                	callq  *%rax
  8038b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038b8:	79 05                	jns    8038bf <listen+0x2d>
		return r;
  8038ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038bd:	eb 16                	jmp    8038d5 <listen+0x43>
	return nsipc_listen(r, backlog);
  8038bf:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8038c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038c5:	89 d6                	mov    %edx,%esi
  8038c7:	89 c7                	mov    %eax,%edi
  8038c9:	48 b8 ff 3b 80 00 00 	movabs $0x803bff,%rax
  8038d0:	00 00 00 
  8038d3:	ff d0                	callq  *%rax
}
  8038d5:	c9                   	leaveq 
  8038d6:	c3                   	retq   

00000000008038d7 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8038d7:	55                   	push   %rbp
  8038d8:	48 89 e5             	mov    %rsp,%rbp
  8038db:	48 83 ec 20          	sub    $0x20,%rsp
  8038df:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8038e3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8038e7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8038eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038ef:	89 c2                	mov    %eax,%edx
  8038f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038f5:	8b 40 0c             	mov    0xc(%rax),%eax
  8038f8:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8038fc:	b9 00 00 00 00       	mov    $0x0,%ecx
  803901:	89 c7                	mov    %eax,%edi
  803903:	48 b8 3f 3c 80 00 00 	movabs $0x803c3f,%rax
  80390a:	00 00 00 
  80390d:	ff d0                	callq  *%rax
}
  80390f:	c9                   	leaveq 
  803910:	c3                   	retq   

0000000000803911 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803911:	55                   	push   %rbp
  803912:	48 89 e5             	mov    %rsp,%rbp
  803915:	48 83 ec 20          	sub    $0x20,%rsp
  803919:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80391d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803921:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803925:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803929:	89 c2                	mov    %eax,%edx
  80392b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80392f:	8b 40 0c             	mov    0xc(%rax),%eax
  803932:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803936:	b9 00 00 00 00       	mov    $0x0,%ecx
  80393b:	89 c7                	mov    %eax,%edi
  80393d:	48 b8 0b 3d 80 00 00 	movabs $0x803d0b,%rax
  803944:	00 00 00 
  803947:	ff d0                	callq  *%rax
}
  803949:	c9                   	leaveq 
  80394a:	c3                   	retq   

000000000080394b <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80394b:	55                   	push   %rbp
  80394c:	48 89 e5             	mov    %rsp,%rbp
  80394f:	48 83 ec 10          	sub    $0x10,%rsp
  803953:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803957:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  80395b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80395f:	48 be f0 4f 80 00 00 	movabs $0x804ff0,%rsi
  803966:	00 00 00 
  803969:	48 89 c7             	mov    %rax,%rdi
  80396c:	48 b8 b7 13 80 00 00 	movabs $0x8013b7,%rax
  803973:	00 00 00 
  803976:	ff d0                	callq  *%rax
	return 0;
  803978:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80397d:	c9                   	leaveq 
  80397e:	c3                   	retq   

000000000080397f <socket>:

int
socket(int domain, int type, int protocol)
{
  80397f:	55                   	push   %rbp
  803980:	48 89 e5             	mov    %rsp,%rbp
  803983:	48 83 ec 20          	sub    $0x20,%rsp
  803987:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80398a:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80398d:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803990:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803993:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803996:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803999:	89 ce                	mov    %ecx,%esi
  80399b:	89 c7                	mov    %eax,%edi
  80399d:	48 b8 c3 3d 80 00 00 	movabs $0x803dc3,%rax
  8039a4:	00 00 00 
  8039a7:	ff d0                	callq  *%rax
  8039a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039b0:	79 05                	jns    8039b7 <socket+0x38>
		return r;
  8039b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039b5:	eb 11                	jmp    8039c8 <socket+0x49>
	return alloc_sockfd(r);
  8039b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039ba:	89 c7                	mov    %eax,%edi
  8039bc:	48 b8 61 36 80 00 00 	movabs $0x803661,%rax
  8039c3:	00 00 00 
  8039c6:	ff d0                	callq  *%rax
}
  8039c8:	c9                   	leaveq 
  8039c9:	c3                   	retq   

00000000008039ca <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8039ca:	55                   	push   %rbp
  8039cb:	48 89 e5             	mov    %rsp,%rbp
  8039ce:	48 83 ec 10          	sub    $0x10,%rsp
  8039d2:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8039d5:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  8039dc:	00 00 00 
  8039df:	8b 00                	mov    (%rax),%eax
  8039e1:	85 c0                	test   %eax,%eax
  8039e3:	75 1d                	jne    803a02 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8039e5:	bf 02 00 00 00       	mov    $0x2,%edi
  8039ea:	48 b8 fa 47 80 00 00 	movabs $0x8047fa,%rax
  8039f1:	00 00 00 
  8039f4:	ff d0                	callq  *%rax
  8039f6:	48 ba 04 80 80 00 00 	movabs $0x808004,%rdx
  8039fd:	00 00 00 
  803a00:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803a02:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803a09:	00 00 00 
  803a0c:	8b 00                	mov    (%rax),%eax
  803a0e:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803a11:	b9 07 00 00 00       	mov    $0x7,%ecx
  803a16:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803a1d:	00 00 00 
  803a20:	89 c7                	mov    %eax,%edi
  803a22:	48 b8 98 47 80 00 00 	movabs $0x804798,%rax
  803a29:	00 00 00 
  803a2c:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803a2e:	ba 00 00 00 00       	mov    $0x0,%edx
  803a33:	be 00 00 00 00       	mov    $0x0,%esi
  803a38:	bf 00 00 00 00       	mov    $0x0,%edi
  803a3d:	48 b8 92 46 80 00 00 	movabs $0x804692,%rax
  803a44:	00 00 00 
  803a47:	ff d0                	callq  *%rax
}
  803a49:	c9                   	leaveq 
  803a4a:	c3                   	retq   

0000000000803a4b <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803a4b:	55                   	push   %rbp
  803a4c:	48 89 e5             	mov    %rsp,%rbp
  803a4f:	48 83 ec 30          	sub    $0x30,%rsp
  803a53:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a56:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a5a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803a5e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a65:	00 00 00 
  803a68:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803a6b:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803a6d:	bf 01 00 00 00       	mov    $0x1,%edi
  803a72:	48 b8 ca 39 80 00 00 	movabs $0x8039ca,%rax
  803a79:	00 00 00 
  803a7c:	ff d0                	callq  *%rax
  803a7e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a81:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a85:	78 3e                	js     803ac5 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803a87:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a8e:	00 00 00 
  803a91:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803a95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a99:	8b 40 10             	mov    0x10(%rax),%eax
  803a9c:	89 c2                	mov    %eax,%edx
  803a9e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803aa2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803aa6:	48 89 ce             	mov    %rcx,%rsi
  803aa9:	48 89 c7             	mov    %rax,%rdi
  803aac:	48 b8 db 16 80 00 00 	movabs $0x8016db,%rax
  803ab3:	00 00 00 
  803ab6:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803ab8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803abc:	8b 50 10             	mov    0x10(%rax),%edx
  803abf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ac3:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803ac5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803ac8:	c9                   	leaveq 
  803ac9:	c3                   	retq   

0000000000803aca <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803aca:	55                   	push   %rbp
  803acb:	48 89 e5             	mov    %rsp,%rbp
  803ace:	48 83 ec 10          	sub    $0x10,%rsp
  803ad2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ad5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803ad9:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803adc:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ae3:	00 00 00 
  803ae6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803ae9:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803aeb:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803aee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803af2:	48 89 c6             	mov    %rax,%rsi
  803af5:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803afc:	00 00 00 
  803aff:	48 b8 db 16 80 00 00 	movabs $0x8016db,%rax
  803b06:	00 00 00 
  803b09:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803b0b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b12:	00 00 00 
  803b15:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b18:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803b1b:	bf 02 00 00 00       	mov    $0x2,%edi
  803b20:	48 b8 ca 39 80 00 00 	movabs $0x8039ca,%rax
  803b27:	00 00 00 
  803b2a:	ff d0                	callq  *%rax
}
  803b2c:	c9                   	leaveq 
  803b2d:	c3                   	retq   

0000000000803b2e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803b2e:	55                   	push   %rbp
  803b2f:	48 89 e5             	mov    %rsp,%rbp
  803b32:	48 83 ec 10          	sub    $0x10,%rsp
  803b36:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803b39:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803b3c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b43:	00 00 00 
  803b46:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b49:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803b4b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b52:	00 00 00 
  803b55:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b58:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803b5b:	bf 03 00 00 00       	mov    $0x3,%edi
  803b60:	48 b8 ca 39 80 00 00 	movabs $0x8039ca,%rax
  803b67:	00 00 00 
  803b6a:	ff d0                	callq  *%rax
}
  803b6c:	c9                   	leaveq 
  803b6d:	c3                   	retq   

0000000000803b6e <nsipc_close>:

int
nsipc_close(int s)
{
  803b6e:	55                   	push   %rbp
  803b6f:	48 89 e5             	mov    %rsp,%rbp
  803b72:	48 83 ec 10          	sub    $0x10,%rsp
  803b76:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803b79:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b80:	00 00 00 
  803b83:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b86:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803b88:	bf 04 00 00 00       	mov    $0x4,%edi
  803b8d:	48 b8 ca 39 80 00 00 	movabs $0x8039ca,%rax
  803b94:	00 00 00 
  803b97:	ff d0                	callq  *%rax
}
  803b99:	c9                   	leaveq 
  803b9a:	c3                   	retq   

0000000000803b9b <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803b9b:	55                   	push   %rbp
  803b9c:	48 89 e5             	mov    %rsp,%rbp
  803b9f:	48 83 ec 10          	sub    $0x10,%rsp
  803ba3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ba6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803baa:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803bad:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bb4:	00 00 00 
  803bb7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803bba:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803bbc:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803bbf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bc3:	48 89 c6             	mov    %rax,%rsi
  803bc6:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803bcd:	00 00 00 
  803bd0:	48 b8 db 16 80 00 00 	movabs $0x8016db,%rax
  803bd7:	00 00 00 
  803bda:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803bdc:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803be3:	00 00 00 
  803be6:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803be9:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803bec:	bf 05 00 00 00       	mov    $0x5,%edi
  803bf1:	48 b8 ca 39 80 00 00 	movabs $0x8039ca,%rax
  803bf8:	00 00 00 
  803bfb:	ff d0                	callq  *%rax
}
  803bfd:	c9                   	leaveq 
  803bfe:	c3                   	retq   

0000000000803bff <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803bff:	55                   	push   %rbp
  803c00:	48 89 e5             	mov    %rsp,%rbp
  803c03:	48 83 ec 10          	sub    $0x10,%rsp
  803c07:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c0a:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803c0d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c14:	00 00 00 
  803c17:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c1a:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803c1c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c23:	00 00 00 
  803c26:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c29:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803c2c:	bf 06 00 00 00       	mov    $0x6,%edi
  803c31:	48 b8 ca 39 80 00 00 	movabs $0x8039ca,%rax
  803c38:	00 00 00 
  803c3b:	ff d0                	callq  *%rax
}
  803c3d:	c9                   	leaveq 
  803c3e:	c3                   	retq   

0000000000803c3f <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803c3f:	55                   	push   %rbp
  803c40:	48 89 e5             	mov    %rsp,%rbp
  803c43:	48 83 ec 30          	sub    $0x30,%rsp
  803c47:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803c4a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c4e:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803c51:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803c54:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c5b:	00 00 00 
  803c5e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803c61:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803c63:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c6a:	00 00 00 
  803c6d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803c70:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803c73:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c7a:	00 00 00 
  803c7d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803c80:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803c83:	bf 07 00 00 00       	mov    $0x7,%edi
  803c88:	48 b8 ca 39 80 00 00 	movabs $0x8039ca,%rax
  803c8f:	00 00 00 
  803c92:	ff d0                	callq  *%rax
  803c94:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c97:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c9b:	78 69                	js     803d06 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803c9d:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803ca4:	7f 08                	jg     803cae <nsipc_recv+0x6f>
  803ca6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ca9:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803cac:	7e 35                	jle    803ce3 <nsipc_recv+0xa4>
  803cae:	48 b9 f7 4f 80 00 00 	movabs $0x804ff7,%rcx
  803cb5:	00 00 00 
  803cb8:	48 ba 0c 50 80 00 00 	movabs $0x80500c,%rdx
  803cbf:	00 00 00 
  803cc2:	be 61 00 00 00       	mov    $0x61,%esi
  803cc7:	48 bf 21 50 80 00 00 	movabs $0x805021,%rdi
  803cce:	00 00 00 
  803cd1:	b8 00 00 00 00       	mov    $0x0,%eax
  803cd6:	49 b8 c9 05 80 00 00 	movabs $0x8005c9,%r8
  803cdd:	00 00 00 
  803ce0:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803ce3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ce6:	48 63 d0             	movslq %eax,%rdx
  803ce9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ced:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803cf4:	00 00 00 
  803cf7:	48 89 c7             	mov    %rax,%rdi
  803cfa:	48 b8 db 16 80 00 00 	movabs $0x8016db,%rax
  803d01:	00 00 00 
  803d04:	ff d0                	callq  *%rax
	}

	return r;
  803d06:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803d09:	c9                   	leaveq 
  803d0a:	c3                   	retq   

0000000000803d0b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803d0b:	55                   	push   %rbp
  803d0c:	48 89 e5             	mov    %rsp,%rbp
  803d0f:	48 83 ec 20          	sub    $0x20,%rsp
  803d13:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803d16:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803d1a:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803d1d:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803d20:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d27:	00 00 00 
  803d2a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803d2d:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803d2f:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803d36:	7e 35                	jle    803d6d <nsipc_send+0x62>
  803d38:	48 b9 2d 50 80 00 00 	movabs $0x80502d,%rcx
  803d3f:	00 00 00 
  803d42:	48 ba 0c 50 80 00 00 	movabs $0x80500c,%rdx
  803d49:	00 00 00 
  803d4c:	be 6c 00 00 00       	mov    $0x6c,%esi
  803d51:	48 bf 21 50 80 00 00 	movabs $0x805021,%rdi
  803d58:	00 00 00 
  803d5b:	b8 00 00 00 00       	mov    $0x0,%eax
  803d60:	49 b8 c9 05 80 00 00 	movabs $0x8005c9,%r8
  803d67:	00 00 00 
  803d6a:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803d6d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d70:	48 63 d0             	movslq %eax,%rdx
  803d73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d77:	48 89 c6             	mov    %rax,%rsi
  803d7a:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803d81:	00 00 00 
  803d84:	48 b8 db 16 80 00 00 	movabs $0x8016db,%rax
  803d8b:	00 00 00 
  803d8e:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803d90:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d97:	00 00 00 
  803d9a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803d9d:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803da0:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803da7:	00 00 00 
  803daa:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803dad:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803db0:	bf 08 00 00 00       	mov    $0x8,%edi
  803db5:	48 b8 ca 39 80 00 00 	movabs $0x8039ca,%rax
  803dbc:	00 00 00 
  803dbf:	ff d0                	callq  *%rax
}
  803dc1:	c9                   	leaveq 
  803dc2:	c3                   	retq   

0000000000803dc3 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803dc3:	55                   	push   %rbp
  803dc4:	48 89 e5             	mov    %rsp,%rbp
  803dc7:	48 83 ec 10          	sub    $0x10,%rsp
  803dcb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803dce:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803dd1:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803dd4:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ddb:	00 00 00 
  803dde:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803de1:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803de3:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803dea:	00 00 00 
  803ded:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803df0:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803df3:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803dfa:	00 00 00 
  803dfd:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803e00:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803e03:	bf 09 00 00 00       	mov    $0x9,%edi
  803e08:	48 b8 ca 39 80 00 00 	movabs $0x8039ca,%rax
  803e0f:	00 00 00 
  803e12:	ff d0                	callq  *%rax
}
  803e14:	c9                   	leaveq 
  803e15:	c3                   	retq   

0000000000803e16 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803e16:	55                   	push   %rbp
  803e17:	48 89 e5             	mov    %rsp,%rbp
  803e1a:	53                   	push   %rbx
  803e1b:	48 83 ec 38          	sub    $0x38,%rsp
  803e1f:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803e23:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803e27:	48 89 c7             	mov    %rax,%rdi
  803e2a:	48 b8 50 23 80 00 00 	movabs $0x802350,%rax
  803e31:	00 00 00 
  803e34:	ff d0                	callq  *%rax
  803e36:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e39:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e3d:	0f 88 bf 01 00 00    	js     804002 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803e43:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e47:	ba 07 04 00 00       	mov    $0x407,%edx
  803e4c:	48 89 c6             	mov    %rax,%rsi
  803e4f:	bf 00 00 00 00       	mov    $0x0,%edi
  803e54:	48 b8 e6 1c 80 00 00 	movabs $0x801ce6,%rax
  803e5b:	00 00 00 
  803e5e:	ff d0                	callq  *%rax
  803e60:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e63:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e67:	0f 88 95 01 00 00    	js     804002 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803e6d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803e71:	48 89 c7             	mov    %rax,%rdi
  803e74:	48 b8 50 23 80 00 00 	movabs $0x802350,%rax
  803e7b:	00 00 00 
  803e7e:	ff d0                	callq  *%rax
  803e80:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e83:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e87:	0f 88 5d 01 00 00    	js     803fea <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803e8d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e91:	ba 07 04 00 00       	mov    $0x407,%edx
  803e96:	48 89 c6             	mov    %rax,%rsi
  803e99:	bf 00 00 00 00       	mov    $0x0,%edi
  803e9e:	48 b8 e6 1c 80 00 00 	movabs $0x801ce6,%rax
  803ea5:	00 00 00 
  803ea8:	ff d0                	callq  *%rax
  803eaa:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ead:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803eb1:	0f 88 33 01 00 00    	js     803fea <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803eb7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ebb:	48 89 c7             	mov    %rax,%rdi
  803ebe:	48 b8 25 23 80 00 00 	movabs $0x802325,%rax
  803ec5:	00 00 00 
  803ec8:	ff d0                	callq  *%rax
  803eca:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ece:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ed2:	ba 07 04 00 00       	mov    $0x407,%edx
  803ed7:	48 89 c6             	mov    %rax,%rsi
  803eda:	bf 00 00 00 00       	mov    $0x0,%edi
  803edf:	48 b8 e6 1c 80 00 00 	movabs $0x801ce6,%rax
  803ee6:	00 00 00 
  803ee9:	ff d0                	callq  *%rax
  803eeb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803eee:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ef2:	79 05                	jns    803ef9 <pipe+0xe3>
		goto err2;
  803ef4:	e9 d9 00 00 00       	jmpq   803fd2 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ef9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803efd:	48 89 c7             	mov    %rax,%rdi
  803f00:	48 b8 25 23 80 00 00 	movabs $0x802325,%rax
  803f07:	00 00 00 
  803f0a:	ff d0                	callq  *%rax
  803f0c:	48 89 c2             	mov    %rax,%rdx
  803f0f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f13:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803f19:	48 89 d1             	mov    %rdx,%rcx
  803f1c:	ba 00 00 00 00       	mov    $0x0,%edx
  803f21:	48 89 c6             	mov    %rax,%rsi
  803f24:	bf 00 00 00 00       	mov    $0x0,%edi
  803f29:	48 b8 36 1d 80 00 00 	movabs $0x801d36,%rax
  803f30:	00 00 00 
  803f33:	ff d0                	callq  *%rax
  803f35:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f38:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f3c:	79 1b                	jns    803f59 <pipe+0x143>
		goto err3;
  803f3e:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803f3f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f43:	48 89 c6             	mov    %rax,%rsi
  803f46:	bf 00 00 00 00       	mov    $0x0,%edi
  803f4b:	48 b8 91 1d 80 00 00 	movabs $0x801d91,%rax
  803f52:	00 00 00 
  803f55:	ff d0                	callq  *%rax
  803f57:	eb 79                	jmp    803fd2 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803f59:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f5d:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803f64:	00 00 00 
  803f67:	8b 12                	mov    (%rdx),%edx
  803f69:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803f6b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f6f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803f76:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f7a:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803f81:	00 00 00 
  803f84:	8b 12                	mov    (%rdx),%edx
  803f86:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803f88:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f8c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803f93:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f97:	48 89 c7             	mov    %rax,%rdi
  803f9a:	48 b8 02 23 80 00 00 	movabs $0x802302,%rax
  803fa1:	00 00 00 
  803fa4:	ff d0                	callq  *%rax
  803fa6:	89 c2                	mov    %eax,%edx
  803fa8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803fac:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803fae:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803fb2:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803fb6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803fba:	48 89 c7             	mov    %rax,%rdi
  803fbd:	48 b8 02 23 80 00 00 	movabs $0x802302,%rax
  803fc4:	00 00 00 
  803fc7:	ff d0                	callq  *%rax
  803fc9:	89 03                	mov    %eax,(%rbx)
	return 0;
  803fcb:	b8 00 00 00 00       	mov    $0x0,%eax
  803fd0:	eb 33                	jmp    804005 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803fd2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803fd6:	48 89 c6             	mov    %rax,%rsi
  803fd9:	bf 00 00 00 00       	mov    $0x0,%edi
  803fde:	48 b8 91 1d 80 00 00 	movabs $0x801d91,%rax
  803fe5:	00 00 00 
  803fe8:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803fea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fee:	48 89 c6             	mov    %rax,%rsi
  803ff1:	bf 00 00 00 00       	mov    $0x0,%edi
  803ff6:	48 b8 91 1d 80 00 00 	movabs $0x801d91,%rax
  803ffd:	00 00 00 
  804000:	ff d0                	callq  *%rax
err:
	return r;
  804002:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804005:	48 83 c4 38          	add    $0x38,%rsp
  804009:	5b                   	pop    %rbx
  80400a:	5d                   	pop    %rbp
  80400b:	c3                   	retq   

000000000080400c <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80400c:	55                   	push   %rbp
  80400d:	48 89 e5             	mov    %rsp,%rbp
  804010:	53                   	push   %rbx
  804011:	48 83 ec 28          	sub    $0x28,%rsp
  804015:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804019:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80401d:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  804024:	00 00 00 
  804027:	48 8b 00             	mov    (%rax),%rax
  80402a:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804030:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  804033:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804037:	48 89 c7             	mov    %rax,%rdi
  80403a:	48 b8 7c 48 80 00 00 	movabs $0x80487c,%rax
  804041:	00 00 00 
  804044:	ff d0                	callq  *%rax
  804046:	89 c3                	mov    %eax,%ebx
  804048:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80404c:	48 89 c7             	mov    %rax,%rdi
  80404f:	48 b8 7c 48 80 00 00 	movabs $0x80487c,%rax
  804056:	00 00 00 
  804059:	ff d0                	callq  *%rax
  80405b:	39 c3                	cmp    %eax,%ebx
  80405d:	0f 94 c0             	sete   %al
  804060:	0f b6 c0             	movzbl %al,%eax
  804063:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  804066:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  80406d:	00 00 00 
  804070:	48 8b 00             	mov    (%rax),%rax
  804073:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804079:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80407c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80407f:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804082:	75 05                	jne    804089 <_pipeisclosed+0x7d>
			return ret;
  804084:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804087:	eb 4f                	jmp    8040d8 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  804089:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80408c:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80408f:	74 42                	je     8040d3 <_pipeisclosed+0xc7>
  804091:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  804095:	75 3c                	jne    8040d3 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804097:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  80409e:	00 00 00 
  8040a1:	48 8b 00             	mov    (%rax),%rax
  8040a4:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8040aa:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8040ad:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8040b0:	89 c6                	mov    %eax,%esi
  8040b2:	48 bf 3e 50 80 00 00 	movabs $0x80503e,%rdi
  8040b9:	00 00 00 
  8040bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8040c1:	49 b8 02 08 80 00 00 	movabs $0x800802,%r8
  8040c8:	00 00 00 
  8040cb:	41 ff d0             	callq  *%r8
	}
  8040ce:	e9 4a ff ff ff       	jmpq   80401d <_pipeisclosed+0x11>
  8040d3:	e9 45 ff ff ff       	jmpq   80401d <_pipeisclosed+0x11>
}
  8040d8:	48 83 c4 28          	add    $0x28,%rsp
  8040dc:	5b                   	pop    %rbx
  8040dd:	5d                   	pop    %rbp
  8040de:	c3                   	retq   

00000000008040df <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8040df:	55                   	push   %rbp
  8040e0:	48 89 e5             	mov    %rsp,%rbp
  8040e3:	48 83 ec 30          	sub    $0x30,%rsp
  8040e7:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8040ea:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8040ee:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8040f1:	48 89 d6             	mov    %rdx,%rsi
  8040f4:	89 c7                	mov    %eax,%edi
  8040f6:	48 b8 e8 23 80 00 00 	movabs $0x8023e8,%rax
  8040fd:	00 00 00 
  804100:	ff d0                	callq  *%rax
  804102:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804105:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804109:	79 05                	jns    804110 <pipeisclosed+0x31>
		return r;
  80410b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80410e:	eb 31                	jmp    804141 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  804110:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804114:	48 89 c7             	mov    %rax,%rdi
  804117:	48 b8 25 23 80 00 00 	movabs $0x802325,%rax
  80411e:	00 00 00 
  804121:	ff d0                	callq  *%rax
  804123:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804127:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80412b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80412f:	48 89 d6             	mov    %rdx,%rsi
  804132:	48 89 c7             	mov    %rax,%rdi
  804135:	48 b8 0c 40 80 00 00 	movabs $0x80400c,%rax
  80413c:	00 00 00 
  80413f:	ff d0                	callq  *%rax
}
  804141:	c9                   	leaveq 
  804142:	c3                   	retq   

0000000000804143 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804143:	55                   	push   %rbp
  804144:	48 89 e5             	mov    %rsp,%rbp
  804147:	48 83 ec 40          	sub    $0x40,%rsp
  80414b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80414f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804153:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804157:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80415b:	48 89 c7             	mov    %rax,%rdi
  80415e:	48 b8 25 23 80 00 00 	movabs $0x802325,%rax
  804165:	00 00 00 
  804168:	ff d0                	callq  *%rax
  80416a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80416e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804172:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804176:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80417d:	00 
  80417e:	e9 92 00 00 00       	jmpq   804215 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  804183:	eb 41                	jmp    8041c6 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804185:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80418a:	74 09                	je     804195 <devpipe_read+0x52>
				return i;
  80418c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804190:	e9 92 00 00 00       	jmpq   804227 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804195:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804199:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80419d:	48 89 d6             	mov    %rdx,%rsi
  8041a0:	48 89 c7             	mov    %rax,%rdi
  8041a3:	48 b8 0c 40 80 00 00 	movabs $0x80400c,%rax
  8041aa:	00 00 00 
  8041ad:	ff d0                	callq  *%rax
  8041af:	85 c0                	test   %eax,%eax
  8041b1:	74 07                	je     8041ba <devpipe_read+0x77>
				return 0;
  8041b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8041b8:	eb 6d                	jmp    804227 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8041ba:	48 b8 a8 1c 80 00 00 	movabs $0x801ca8,%rax
  8041c1:	00 00 00 
  8041c4:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8041c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041ca:	8b 10                	mov    (%rax),%edx
  8041cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041d0:	8b 40 04             	mov    0x4(%rax),%eax
  8041d3:	39 c2                	cmp    %eax,%edx
  8041d5:	74 ae                	je     804185 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8041d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041db:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8041df:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8041e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041e7:	8b 00                	mov    (%rax),%eax
  8041e9:	99                   	cltd   
  8041ea:	c1 ea 1b             	shr    $0x1b,%edx
  8041ed:	01 d0                	add    %edx,%eax
  8041ef:	83 e0 1f             	and    $0x1f,%eax
  8041f2:	29 d0                	sub    %edx,%eax
  8041f4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8041f8:	48 98                	cltq   
  8041fa:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8041ff:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804201:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804205:	8b 00                	mov    (%rax),%eax
  804207:	8d 50 01             	lea    0x1(%rax),%edx
  80420a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80420e:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804210:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804215:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804219:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80421d:	0f 82 60 ff ff ff    	jb     804183 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804223:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804227:	c9                   	leaveq 
  804228:	c3                   	retq   

0000000000804229 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804229:	55                   	push   %rbp
  80422a:	48 89 e5             	mov    %rsp,%rbp
  80422d:	48 83 ec 40          	sub    $0x40,%rsp
  804231:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804235:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804239:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80423d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804241:	48 89 c7             	mov    %rax,%rdi
  804244:	48 b8 25 23 80 00 00 	movabs $0x802325,%rax
  80424b:	00 00 00 
  80424e:	ff d0                	callq  *%rax
  804250:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804254:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804258:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80425c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804263:	00 
  804264:	e9 8e 00 00 00       	jmpq   8042f7 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804269:	eb 31                	jmp    80429c <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80426b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80426f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804273:	48 89 d6             	mov    %rdx,%rsi
  804276:	48 89 c7             	mov    %rax,%rdi
  804279:	48 b8 0c 40 80 00 00 	movabs $0x80400c,%rax
  804280:	00 00 00 
  804283:	ff d0                	callq  *%rax
  804285:	85 c0                	test   %eax,%eax
  804287:	74 07                	je     804290 <devpipe_write+0x67>
				return 0;
  804289:	b8 00 00 00 00       	mov    $0x0,%eax
  80428e:	eb 79                	jmp    804309 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804290:	48 b8 a8 1c 80 00 00 	movabs $0x801ca8,%rax
  804297:	00 00 00 
  80429a:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80429c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042a0:	8b 40 04             	mov    0x4(%rax),%eax
  8042a3:	48 63 d0             	movslq %eax,%rdx
  8042a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042aa:	8b 00                	mov    (%rax),%eax
  8042ac:	48 98                	cltq   
  8042ae:	48 83 c0 20          	add    $0x20,%rax
  8042b2:	48 39 c2             	cmp    %rax,%rdx
  8042b5:	73 b4                	jae    80426b <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8042b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042bb:	8b 40 04             	mov    0x4(%rax),%eax
  8042be:	99                   	cltd   
  8042bf:	c1 ea 1b             	shr    $0x1b,%edx
  8042c2:	01 d0                	add    %edx,%eax
  8042c4:	83 e0 1f             	and    $0x1f,%eax
  8042c7:	29 d0                	sub    %edx,%eax
  8042c9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8042cd:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8042d1:	48 01 ca             	add    %rcx,%rdx
  8042d4:	0f b6 0a             	movzbl (%rdx),%ecx
  8042d7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8042db:	48 98                	cltq   
  8042dd:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8042e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042e5:	8b 40 04             	mov    0x4(%rax),%eax
  8042e8:	8d 50 01             	lea    0x1(%rax),%edx
  8042eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042ef:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8042f2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8042f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042fb:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8042ff:	0f 82 64 ff ff ff    	jb     804269 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804305:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804309:	c9                   	leaveq 
  80430a:	c3                   	retq   

000000000080430b <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80430b:	55                   	push   %rbp
  80430c:	48 89 e5             	mov    %rsp,%rbp
  80430f:	48 83 ec 20          	sub    $0x20,%rsp
  804313:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804317:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80431b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80431f:	48 89 c7             	mov    %rax,%rdi
  804322:	48 b8 25 23 80 00 00 	movabs $0x802325,%rax
  804329:	00 00 00 
  80432c:	ff d0                	callq  *%rax
  80432e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804332:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804336:	48 be 51 50 80 00 00 	movabs $0x805051,%rsi
  80433d:	00 00 00 
  804340:	48 89 c7             	mov    %rax,%rdi
  804343:	48 b8 b7 13 80 00 00 	movabs $0x8013b7,%rax
  80434a:	00 00 00 
  80434d:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80434f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804353:	8b 50 04             	mov    0x4(%rax),%edx
  804356:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80435a:	8b 00                	mov    (%rax),%eax
  80435c:	29 c2                	sub    %eax,%edx
  80435e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804362:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804368:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80436c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804373:	00 00 00 
	stat->st_dev = &devpipe;
  804376:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80437a:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  804381:	00 00 00 
  804384:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80438b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804390:	c9                   	leaveq 
  804391:	c3                   	retq   

0000000000804392 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804392:	55                   	push   %rbp
  804393:	48 89 e5             	mov    %rsp,%rbp
  804396:	48 83 ec 10          	sub    $0x10,%rsp
  80439a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80439e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043a2:	48 89 c6             	mov    %rax,%rsi
  8043a5:	bf 00 00 00 00       	mov    $0x0,%edi
  8043aa:	48 b8 91 1d 80 00 00 	movabs $0x801d91,%rax
  8043b1:	00 00 00 
  8043b4:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8043b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043ba:	48 89 c7             	mov    %rax,%rdi
  8043bd:	48 b8 25 23 80 00 00 	movabs $0x802325,%rax
  8043c4:	00 00 00 
  8043c7:	ff d0                	callq  *%rax
  8043c9:	48 89 c6             	mov    %rax,%rsi
  8043cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8043d1:	48 b8 91 1d 80 00 00 	movabs $0x801d91,%rax
  8043d8:	00 00 00 
  8043db:	ff d0                	callq  *%rax
}
  8043dd:	c9                   	leaveq 
  8043de:	c3                   	retq   

00000000008043df <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8043df:	55                   	push   %rbp
  8043e0:	48 89 e5             	mov    %rsp,%rbp
  8043e3:	48 83 ec 20          	sub    $0x20,%rsp
  8043e7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8043ea:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8043ed:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8043f0:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8043f4:	be 01 00 00 00       	mov    $0x1,%esi
  8043f9:	48 89 c7             	mov    %rax,%rdi
  8043fc:	48 b8 9e 1b 80 00 00 	movabs $0x801b9e,%rax
  804403:	00 00 00 
  804406:	ff d0                	callq  *%rax
}
  804408:	c9                   	leaveq 
  804409:	c3                   	retq   

000000000080440a <getchar>:

int
getchar(void)
{
  80440a:	55                   	push   %rbp
  80440b:	48 89 e5             	mov    %rsp,%rbp
  80440e:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804412:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804416:	ba 01 00 00 00       	mov    $0x1,%edx
  80441b:	48 89 c6             	mov    %rax,%rsi
  80441e:	bf 00 00 00 00       	mov    $0x0,%edi
  804423:	48 b8 1a 28 80 00 00 	movabs $0x80281a,%rax
  80442a:	00 00 00 
  80442d:	ff d0                	callq  *%rax
  80442f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  804432:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804436:	79 05                	jns    80443d <getchar+0x33>
		return r;
  804438:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80443b:	eb 14                	jmp    804451 <getchar+0x47>
	if (r < 1)
  80443d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804441:	7f 07                	jg     80444a <getchar+0x40>
		return -E_EOF;
  804443:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804448:	eb 07                	jmp    804451 <getchar+0x47>
	return c;
  80444a:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80444e:	0f b6 c0             	movzbl %al,%eax
}
  804451:	c9                   	leaveq 
  804452:	c3                   	retq   

0000000000804453 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804453:	55                   	push   %rbp
  804454:	48 89 e5             	mov    %rsp,%rbp
  804457:	48 83 ec 20          	sub    $0x20,%rsp
  80445b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80445e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804462:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804465:	48 89 d6             	mov    %rdx,%rsi
  804468:	89 c7                	mov    %eax,%edi
  80446a:	48 b8 e8 23 80 00 00 	movabs $0x8023e8,%rax
  804471:	00 00 00 
  804474:	ff d0                	callq  *%rax
  804476:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804479:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80447d:	79 05                	jns    804484 <iscons+0x31>
		return r;
  80447f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804482:	eb 1a                	jmp    80449e <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804484:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804488:	8b 10                	mov    (%rax),%edx
  80448a:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  804491:	00 00 00 
  804494:	8b 00                	mov    (%rax),%eax
  804496:	39 c2                	cmp    %eax,%edx
  804498:	0f 94 c0             	sete   %al
  80449b:	0f b6 c0             	movzbl %al,%eax
}
  80449e:	c9                   	leaveq 
  80449f:	c3                   	retq   

00000000008044a0 <opencons>:

int
opencons(void)
{
  8044a0:	55                   	push   %rbp
  8044a1:	48 89 e5             	mov    %rsp,%rbp
  8044a4:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8044a8:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8044ac:	48 89 c7             	mov    %rax,%rdi
  8044af:	48 b8 50 23 80 00 00 	movabs $0x802350,%rax
  8044b6:	00 00 00 
  8044b9:	ff d0                	callq  *%rax
  8044bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8044be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044c2:	79 05                	jns    8044c9 <opencons+0x29>
		return r;
  8044c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044c7:	eb 5b                	jmp    804524 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8044c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044cd:	ba 07 04 00 00       	mov    $0x407,%edx
  8044d2:	48 89 c6             	mov    %rax,%rsi
  8044d5:	bf 00 00 00 00       	mov    $0x0,%edi
  8044da:	48 b8 e6 1c 80 00 00 	movabs $0x801ce6,%rax
  8044e1:	00 00 00 
  8044e4:	ff d0                	callq  *%rax
  8044e6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8044e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044ed:	79 05                	jns    8044f4 <opencons+0x54>
		return r;
  8044ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044f2:	eb 30                	jmp    804524 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8044f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044f8:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  8044ff:	00 00 00 
  804502:	8b 12                	mov    (%rdx),%edx
  804504:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804506:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80450a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804511:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804515:	48 89 c7             	mov    %rax,%rdi
  804518:	48 b8 02 23 80 00 00 	movabs $0x802302,%rax
  80451f:	00 00 00 
  804522:	ff d0                	callq  *%rax
}
  804524:	c9                   	leaveq 
  804525:	c3                   	retq   

0000000000804526 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804526:	55                   	push   %rbp
  804527:	48 89 e5             	mov    %rsp,%rbp
  80452a:	48 83 ec 30          	sub    $0x30,%rsp
  80452e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804532:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804536:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80453a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80453f:	75 07                	jne    804548 <devcons_read+0x22>
		return 0;
  804541:	b8 00 00 00 00       	mov    $0x0,%eax
  804546:	eb 4b                	jmp    804593 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  804548:	eb 0c                	jmp    804556 <devcons_read+0x30>
		sys_yield();
  80454a:	48 b8 a8 1c 80 00 00 	movabs $0x801ca8,%rax
  804551:	00 00 00 
  804554:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804556:	48 b8 e8 1b 80 00 00 	movabs $0x801be8,%rax
  80455d:	00 00 00 
  804560:	ff d0                	callq  *%rax
  804562:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804565:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804569:	74 df                	je     80454a <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  80456b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80456f:	79 05                	jns    804576 <devcons_read+0x50>
		return c;
  804571:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804574:	eb 1d                	jmp    804593 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  804576:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80457a:	75 07                	jne    804583 <devcons_read+0x5d>
		return 0;
  80457c:	b8 00 00 00 00       	mov    $0x0,%eax
  804581:	eb 10                	jmp    804593 <devcons_read+0x6d>
	*(char*)vbuf = c;
  804583:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804586:	89 c2                	mov    %eax,%edx
  804588:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80458c:	88 10                	mov    %dl,(%rax)
	return 1;
  80458e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804593:	c9                   	leaveq 
  804594:	c3                   	retq   

0000000000804595 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804595:	55                   	push   %rbp
  804596:	48 89 e5             	mov    %rsp,%rbp
  804599:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8045a0:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8045a7:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8045ae:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8045b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8045bc:	eb 76                	jmp    804634 <devcons_write+0x9f>
		m = n - tot;
  8045be:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8045c5:	89 c2                	mov    %eax,%edx
  8045c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045ca:	29 c2                	sub    %eax,%edx
  8045cc:	89 d0                	mov    %edx,%eax
  8045ce:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8045d1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8045d4:	83 f8 7f             	cmp    $0x7f,%eax
  8045d7:	76 07                	jbe    8045e0 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8045d9:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8045e0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8045e3:	48 63 d0             	movslq %eax,%rdx
  8045e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045e9:	48 63 c8             	movslq %eax,%rcx
  8045ec:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8045f3:	48 01 c1             	add    %rax,%rcx
  8045f6:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8045fd:	48 89 ce             	mov    %rcx,%rsi
  804600:	48 89 c7             	mov    %rax,%rdi
  804603:	48 b8 db 16 80 00 00 	movabs $0x8016db,%rax
  80460a:	00 00 00 
  80460d:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80460f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804612:	48 63 d0             	movslq %eax,%rdx
  804615:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80461c:	48 89 d6             	mov    %rdx,%rsi
  80461f:	48 89 c7             	mov    %rax,%rdi
  804622:	48 b8 9e 1b 80 00 00 	movabs $0x801b9e,%rax
  804629:	00 00 00 
  80462c:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80462e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804631:	01 45 fc             	add    %eax,-0x4(%rbp)
  804634:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804637:	48 98                	cltq   
  804639:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804640:	0f 82 78 ff ff ff    	jb     8045be <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804646:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804649:	c9                   	leaveq 
  80464a:	c3                   	retq   

000000000080464b <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80464b:	55                   	push   %rbp
  80464c:	48 89 e5             	mov    %rsp,%rbp
  80464f:	48 83 ec 08          	sub    $0x8,%rsp
  804653:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804657:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80465c:	c9                   	leaveq 
  80465d:	c3                   	retq   

000000000080465e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80465e:	55                   	push   %rbp
  80465f:	48 89 e5             	mov    %rsp,%rbp
  804662:	48 83 ec 10          	sub    $0x10,%rsp
  804666:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80466a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80466e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804672:	48 be 5d 50 80 00 00 	movabs $0x80505d,%rsi
  804679:	00 00 00 
  80467c:	48 89 c7             	mov    %rax,%rdi
  80467f:	48 b8 b7 13 80 00 00 	movabs $0x8013b7,%rax
  804686:	00 00 00 
  804689:	ff d0                	callq  *%rax
	return 0;
  80468b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804690:	c9                   	leaveq 
  804691:	c3                   	retq   

0000000000804692 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804692:	55                   	push   %rbp
  804693:	48 89 e5             	mov    %rsp,%rbp
  804696:	48 83 ec 30          	sub    $0x30,%rsp
  80469a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80469e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8046a2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  8046a6:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  8046ad:	00 00 00 
  8046b0:	48 8b 00             	mov    (%rax),%rax
  8046b3:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8046b9:	85 c0                	test   %eax,%eax
  8046bb:	75 3c                	jne    8046f9 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  8046bd:	48 b8 6a 1c 80 00 00 	movabs $0x801c6a,%rax
  8046c4:	00 00 00 
  8046c7:	ff d0                	callq  *%rax
  8046c9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8046ce:	48 63 d0             	movslq %eax,%rdx
  8046d1:	48 89 d0             	mov    %rdx,%rax
  8046d4:	48 c1 e0 03          	shl    $0x3,%rax
  8046d8:	48 01 d0             	add    %rdx,%rax
  8046db:	48 c1 e0 05          	shl    $0x5,%rax
  8046df:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8046e6:	00 00 00 
  8046e9:	48 01 c2             	add    %rax,%rdx
  8046ec:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  8046f3:	00 00 00 
  8046f6:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  8046f9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8046fe:	75 0e                	jne    80470e <ipc_recv+0x7c>
		pg = (void*) UTOP;
  804700:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804707:	00 00 00 
  80470a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  80470e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804712:	48 89 c7             	mov    %rax,%rdi
  804715:	48 b8 0f 1f 80 00 00 	movabs $0x801f0f,%rax
  80471c:	00 00 00 
  80471f:	ff d0                	callq  *%rax
  804721:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  804724:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804728:	79 19                	jns    804743 <ipc_recv+0xb1>
		*from_env_store = 0;
  80472a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80472e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  804734:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804738:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  80473e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804741:	eb 53                	jmp    804796 <ipc_recv+0x104>
	}
	if(from_env_store)
  804743:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804748:	74 19                	je     804763 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  80474a:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  804751:	00 00 00 
  804754:	48 8b 00             	mov    (%rax),%rax
  804757:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80475d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804761:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  804763:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804768:	74 19                	je     804783 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  80476a:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  804771:	00 00 00 
  804774:	48 8b 00             	mov    (%rax),%rax
  804777:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80477d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804781:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  804783:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  80478a:	00 00 00 
  80478d:	48 8b 00             	mov    (%rax),%rax
  804790:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  804796:	c9                   	leaveq 
  804797:	c3                   	retq   

0000000000804798 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804798:	55                   	push   %rbp
  804799:	48 89 e5             	mov    %rsp,%rbp
  80479c:	48 83 ec 30          	sub    $0x30,%rsp
  8047a0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8047a3:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8047a6:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8047aa:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  8047ad:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8047b2:	75 0e                	jne    8047c2 <ipc_send+0x2a>
		pg = (void*)UTOP;
  8047b4:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8047bb:	00 00 00 
  8047be:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  8047c2:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8047c5:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8047c8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8047cc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8047cf:	89 c7                	mov    %eax,%edi
  8047d1:	48 b8 ba 1e 80 00 00 	movabs $0x801eba,%rax
  8047d8:	00 00 00 
  8047db:	ff d0                	callq  *%rax
  8047dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  8047e0:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8047e4:	75 0c                	jne    8047f2 <ipc_send+0x5a>
			sys_yield();
  8047e6:	48 b8 a8 1c 80 00 00 	movabs $0x801ca8,%rax
  8047ed:	00 00 00 
  8047f0:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  8047f2:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8047f6:	74 ca                	je     8047c2 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  8047f8:	c9                   	leaveq 
  8047f9:	c3                   	retq   

00000000008047fa <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8047fa:	55                   	push   %rbp
  8047fb:	48 89 e5             	mov    %rsp,%rbp
  8047fe:	48 83 ec 14          	sub    $0x14,%rsp
  804802:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804805:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80480c:	eb 5e                	jmp    80486c <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  80480e:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804815:	00 00 00 
  804818:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80481b:	48 63 d0             	movslq %eax,%rdx
  80481e:	48 89 d0             	mov    %rdx,%rax
  804821:	48 c1 e0 03          	shl    $0x3,%rax
  804825:	48 01 d0             	add    %rdx,%rax
  804828:	48 c1 e0 05          	shl    $0x5,%rax
  80482c:	48 01 c8             	add    %rcx,%rax
  80482f:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804835:	8b 00                	mov    (%rax),%eax
  804837:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80483a:	75 2c                	jne    804868 <ipc_find_env+0x6e>
			return envs[i].env_id;
  80483c:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804843:	00 00 00 
  804846:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804849:	48 63 d0             	movslq %eax,%rdx
  80484c:	48 89 d0             	mov    %rdx,%rax
  80484f:	48 c1 e0 03          	shl    $0x3,%rax
  804853:	48 01 d0             	add    %rdx,%rax
  804856:	48 c1 e0 05          	shl    $0x5,%rax
  80485a:	48 01 c8             	add    %rcx,%rax
  80485d:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804863:	8b 40 08             	mov    0x8(%rax),%eax
  804866:	eb 12                	jmp    80487a <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804868:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80486c:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804873:	7e 99                	jle    80480e <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804875:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80487a:	c9                   	leaveq 
  80487b:	c3                   	retq   

000000000080487c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80487c:	55                   	push   %rbp
  80487d:	48 89 e5             	mov    %rsp,%rbp
  804880:	48 83 ec 18          	sub    $0x18,%rsp
  804884:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804888:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80488c:	48 c1 e8 15          	shr    $0x15,%rax
  804890:	48 89 c2             	mov    %rax,%rdx
  804893:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80489a:	01 00 00 
  80489d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8048a1:	83 e0 01             	and    $0x1,%eax
  8048a4:	48 85 c0             	test   %rax,%rax
  8048a7:	75 07                	jne    8048b0 <pageref+0x34>
		return 0;
  8048a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8048ae:	eb 53                	jmp    804903 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8048b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8048b4:	48 c1 e8 0c          	shr    $0xc,%rax
  8048b8:	48 89 c2             	mov    %rax,%rdx
  8048bb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8048c2:	01 00 00 
  8048c5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8048c9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8048cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048d1:	83 e0 01             	and    $0x1,%eax
  8048d4:	48 85 c0             	test   %rax,%rax
  8048d7:	75 07                	jne    8048e0 <pageref+0x64>
		return 0;
  8048d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8048de:	eb 23                	jmp    804903 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8048e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048e4:	48 c1 e8 0c          	shr    $0xc,%rax
  8048e8:	48 89 c2             	mov    %rax,%rdx
  8048eb:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8048f2:	00 00 00 
  8048f5:	48 c1 e2 04          	shl    $0x4,%rdx
  8048f9:	48 01 d0             	add    %rdx,%rax
  8048fc:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804900:	0f b7 c0             	movzwl %ax,%eax
}
  804903:	c9                   	leaveq 
  804904:	c3                   	retq   
