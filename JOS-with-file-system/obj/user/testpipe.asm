
obj/user/testpipe.debug:     file format elf64-x86-64


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
  80003c:	e8 fe 04 00 00       	callq  80053f <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

char *msg = "Now is the time for all good men to come to the aid of their party.";

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	53                   	push   %rbx
  800048:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  80004f:	89 bd 6c ff ff ff    	mov    %edi,-0x94(%rbp)
  800055:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
	char buf[100];
	int i, pid, p[2];

	binaryname = "pipereadeof";
  80005c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800063:	00 00 00 
  800066:	48 bb 64 41 80 00 00 	movabs $0x804164,%rbx
  80006d:	00 00 00 
  800070:	48 89 18             	mov    %rbx,(%rax)

	if ((i = pipe(p)) < 0)
  800073:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80007a:	48 89 c7             	mov    %rax,%rdi
  80007d:	48 b8 3a 34 80 00 00 	movabs $0x80343a,%rax
  800084:	00 00 00 
  800087:	ff d0                	callq  *%rax
  800089:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80008c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800090:	79 30                	jns    8000c2 <umain+0x7f>
		panic("pipe: %e", i);
  800092:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800095:	89 c1                	mov    %eax,%ecx
  800097:	48 ba 70 41 80 00 00 	movabs $0x804170,%rdx
  80009e:	00 00 00 
  8000a1:	be 0e 00 00 00       	mov    $0xe,%esi
  8000a6:	48 bf 79 41 80 00 00 	movabs $0x804179,%rdi
  8000ad:	00 00 00 
  8000b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b5:	49 b8 ed 05 80 00 00 	movabs $0x8005ed,%r8
  8000bc:	00 00 00 
  8000bf:	41 ff d0             	callq  *%r8

	if ((pid = fork()) < 0)
  8000c2:	48 b8 60 23 80 00 00 	movabs $0x802360,%rax
  8000c9:	00 00 00 
  8000cc:	ff d0                	callq  *%rax
  8000ce:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8000d1:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8000d5:	79 30                	jns    800107 <umain+0xc4>
		panic("fork: %e", i);
  8000d7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000da:	89 c1                	mov    %eax,%ecx
  8000dc:	48 ba 89 41 80 00 00 	movabs $0x804189,%rdx
  8000e3:	00 00 00 
  8000e6:	be 11 00 00 00       	mov    $0x11,%esi
  8000eb:	48 bf 79 41 80 00 00 	movabs $0x804179,%rdi
  8000f2:	00 00 00 
  8000f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000fa:	49 b8 ed 05 80 00 00 	movabs $0x8005ed,%r8
  800101:	00 00 00 
  800104:	41 ff d0             	callq  *%r8

	if (pid == 0) {
  800107:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80010b:	0f 85 5c 01 00 00    	jne    80026d <umain+0x22a>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[1]);
  800111:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  800117:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80011e:	00 00 00 
  800121:	48 8b 00             	mov    (%rax),%rax
  800124:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80012a:	89 c6                	mov    %eax,%esi
  80012c:	48 bf 92 41 80 00 00 	movabs $0x804192,%rdi
  800133:	00 00 00 
  800136:	b8 00 00 00 00       	mov    $0x0,%eax
  80013b:	48 b9 26 08 80 00 00 	movabs $0x800826,%rcx
  800142:	00 00 00 
  800145:	ff d1                	callq  *%rcx
		close(p[1]);
  800147:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  80014d:	89 c7                	mov    %eax,%edi
  80014f:	48 b8 07 29 80 00 00 	movabs $0x802907,%rax
  800156:	00 00 00 
  800159:	ff d0                	callq  *%rax
		cprintf("[%08x] pipereadeof readn %d\n", thisenv->env_id, p[0]);
  80015b:	8b 95 70 ff ff ff    	mov    -0x90(%rbp),%edx
  800161:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800168:	00 00 00 
  80016b:	48 8b 00             	mov    (%rax),%rax
  80016e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800174:	89 c6                	mov    %eax,%esi
  800176:	48 bf af 41 80 00 00 	movabs $0x8041af,%rdi
  80017d:	00 00 00 
  800180:	b8 00 00 00 00       	mov    $0x0,%eax
  800185:	48 b9 26 08 80 00 00 	movabs $0x800826,%rcx
  80018c:	00 00 00 
  80018f:	ff d1                	callq  *%rcx
		i = readn(p[0], buf, sizeof buf-1);
  800191:	8b 85 70 ff ff ff    	mov    -0x90(%rbp),%eax
  800197:	48 8d 4d 80          	lea    -0x80(%rbp),%rcx
  80019b:	ba 63 00 00 00       	mov    $0x63,%edx
  8001a0:	48 89 ce             	mov    %rcx,%rsi
  8001a3:	89 c7                	mov    %eax,%edi
  8001a5:	48 b8 fe 2b 80 00 00 	movabs $0x802bfe,%rax
  8001ac:	00 00 00 
  8001af:	ff d0                	callq  *%rax
  8001b1:	89 45 ec             	mov    %eax,-0x14(%rbp)
		if (i < 0)
  8001b4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8001b8:	79 30                	jns    8001ea <umain+0x1a7>
			panic("read: %e", i);
  8001ba:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001bd:	89 c1                	mov    %eax,%ecx
  8001bf:	48 ba cc 41 80 00 00 	movabs $0x8041cc,%rdx
  8001c6:	00 00 00 
  8001c9:	be 19 00 00 00       	mov    $0x19,%esi
  8001ce:	48 bf 79 41 80 00 00 	movabs $0x804179,%rdi
  8001d5:	00 00 00 
  8001d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8001dd:	49 b8 ed 05 80 00 00 	movabs $0x8005ed,%r8
  8001e4:	00 00 00 
  8001e7:	41 ff d0             	callq  *%r8
		buf[i] = 0;
  8001ea:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001ed:	48 98                	cltq   
  8001ef:	c6 44 05 80 00       	movb   $0x0,-0x80(%rbp,%rax,1)
		if (strcmp(buf, msg) == 0)
  8001f4:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8001fb:	00 00 00 
  8001fe:	48 8b 10             	mov    (%rax),%rdx
  800201:	48 8d 45 80          	lea    -0x80(%rbp),%rax
  800205:	48 89 d6             	mov    %rdx,%rsi
  800208:	48 89 c7             	mov    %rax,%rdi
  80020b:	48 b8 3d 15 80 00 00 	movabs $0x80153d,%rax
  800212:	00 00 00 
  800215:	ff d0                	callq  *%rax
  800217:	85 c0                	test   %eax,%eax
  800219:	75 1d                	jne    800238 <umain+0x1f5>
			cprintf("\npipe read closed properly\n");
  80021b:	48 bf d5 41 80 00 00 	movabs $0x8041d5,%rdi
  800222:	00 00 00 
  800225:	b8 00 00 00 00       	mov    $0x0,%eax
  80022a:	48 ba 26 08 80 00 00 	movabs $0x800826,%rdx
  800231:	00 00 00 
  800234:	ff d2                	callq  *%rdx
  800236:	eb 24                	jmp    80025c <umain+0x219>
		else
			cprintf("\ngot %d bytes: %s\n", i, buf);
  800238:	48 8d 55 80          	lea    -0x80(%rbp),%rdx
  80023c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80023f:	89 c6                	mov    %eax,%esi
  800241:	48 bf f1 41 80 00 00 	movabs $0x8041f1,%rdi
  800248:	00 00 00 
  80024b:	b8 00 00 00 00       	mov    $0x0,%eax
  800250:	48 b9 26 08 80 00 00 	movabs $0x800826,%rcx
  800257:	00 00 00 
  80025a:	ff d1                	callq  *%rcx
		exit();
  80025c:	48 b8 ca 05 80 00 00 	movabs $0x8005ca,%rax
  800263:	00 00 00 
  800266:	ff d0                	callq  *%rax
  800268:	e9 2b 01 00 00       	jmpq   800398 <umain+0x355>
	} else {
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[0]);
  80026d:	8b 95 70 ff ff ff    	mov    -0x90(%rbp),%edx
  800273:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80027a:	00 00 00 
  80027d:	48 8b 00             	mov    (%rax),%rax
  800280:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800286:	89 c6                	mov    %eax,%esi
  800288:	48 bf 92 41 80 00 00 	movabs $0x804192,%rdi
  80028f:	00 00 00 
  800292:	b8 00 00 00 00       	mov    $0x0,%eax
  800297:	48 b9 26 08 80 00 00 	movabs $0x800826,%rcx
  80029e:	00 00 00 
  8002a1:	ff d1                	callq  *%rcx
		close(p[0]);
  8002a3:	8b 85 70 ff ff ff    	mov    -0x90(%rbp),%eax
  8002a9:	89 c7                	mov    %eax,%edi
  8002ab:	48 b8 07 29 80 00 00 	movabs $0x802907,%rax
  8002b2:	00 00 00 
  8002b5:	ff d0                	callq  *%rax
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
  8002b7:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  8002bd:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8002c4:	00 00 00 
  8002c7:	48 8b 00             	mov    (%rax),%rax
  8002ca:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8002d0:	89 c6                	mov    %eax,%esi
  8002d2:	48 bf 04 42 80 00 00 	movabs $0x804204,%rdi
  8002d9:	00 00 00 
  8002dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8002e1:	48 b9 26 08 80 00 00 	movabs $0x800826,%rcx
  8002e8:	00 00 00 
  8002eb:	ff d1                	callq  *%rcx
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
  8002ed:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002f4:	00 00 00 
  8002f7:	48 8b 00             	mov    (%rax),%rax
  8002fa:	48 89 c7             	mov    %rax,%rdi
  8002fd:	48 b8 6f 13 80 00 00 	movabs $0x80136f,%rax
  800304:	00 00 00 
  800307:	ff d0                	callq  *%rax
  800309:	48 63 d0             	movslq %eax,%rdx
  80030c:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800313:	00 00 00 
  800316:	48 8b 08             	mov    (%rax),%rcx
  800319:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  80031f:	48 89 ce             	mov    %rcx,%rsi
  800322:	89 c7                	mov    %eax,%edi
  800324:	48 b8 73 2c 80 00 00 	movabs $0x802c73,%rax
  80032b:	00 00 00 
  80032e:	ff d0                	callq  *%rax
  800330:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800333:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80033a:	00 00 00 
  80033d:	48 8b 00             	mov    (%rax),%rax
  800340:	48 89 c7             	mov    %rax,%rdi
  800343:	48 b8 6f 13 80 00 00 	movabs $0x80136f,%rax
  80034a:	00 00 00 
  80034d:	ff d0                	callq  *%rax
  80034f:	39 45 ec             	cmp    %eax,-0x14(%rbp)
  800352:	74 30                	je     800384 <umain+0x341>
			panic("write: %e", i);
  800354:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800357:	89 c1                	mov    %eax,%ecx
  800359:	48 ba 21 42 80 00 00 	movabs $0x804221,%rdx
  800360:	00 00 00 
  800363:	be 25 00 00 00       	mov    $0x25,%esi
  800368:	48 bf 79 41 80 00 00 	movabs $0x804179,%rdi
  80036f:	00 00 00 
  800372:	b8 00 00 00 00       	mov    $0x0,%eax
  800377:	49 b8 ed 05 80 00 00 	movabs $0x8005ed,%r8
  80037e:	00 00 00 
  800381:	41 ff d0             	callq  *%r8
		close(p[1]);
  800384:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  80038a:	89 c7                	mov    %eax,%edi
  80038c:	48 b8 07 29 80 00 00 	movabs $0x802907,%rax
  800393:	00 00 00 
  800396:	ff d0                	callq  *%rax
	}
	wait(pid);
  800398:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80039b:	89 c7                	mov    %eax,%edi
  80039d:	48 b8 03 3a 80 00 00 	movabs $0x803a03,%rax
  8003a4:	00 00 00 
  8003a7:	ff d0                	callq  *%rax

	binaryname = "pipewriteeof";
  8003a9:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8003b0:	00 00 00 
  8003b3:	48 bb 2b 42 80 00 00 	movabs $0x80422b,%rbx
  8003ba:	00 00 00 
  8003bd:	48 89 18             	mov    %rbx,(%rax)
	if ((i = pipe(p)) < 0)
  8003c0:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8003c7:	48 89 c7             	mov    %rax,%rdi
  8003ca:	48 b8 3a 34 80 00 00 	movabs $0x80343a,%rax
  8003d1:	00 00 00 
  8003d4:	ff d0                	callq  *%rax
  8003d6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8003d9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8003dd:	79 30                	jns    80040f <umain+0x3cc>
		panic("pipe: %e", i);
  8003df:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8003e2:	89 c1                	mov    %eax,%ecx
  8003e4:	48 ba 70 41 80 00 00 	movabs $0x804170,%rdx
  8003eb:	00 00 00 
  8003ee:	be 2c 00 00 00       	mov    $0x2c,%esi
  8003f3:	48 bf 79 41 80 00 00 	movabs $0x804179,%rdi
  8003fa:	00 00 00 
  8003fd:	b8 00 00 00 00       	mov    $0x0,%eax
  800402:	49 b8 ed 05 80 00 00 	movabs $0x8005ed,%r8
  800409:	00 00 00 
  80040c:	41 ff d0             	callq  *%r8

	if ((pid = fork()) < 0)
  80040f:	48 b8 60 23 80 00 00 	movabs $0x802360,%rax
  800416:	00 00 00 
  800419:	ff d0                	callq  *%rax
  80041b:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80041e:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800422:	79 30                	jns    800454 <umain+0x411>
		panic("fork: %e", i);
  800424:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800427:	89 c1                	mov    %eax,%ecx
  800429:	48 ba 89 41 80 00 00 	movabs $0x804189,%rdx
  800430:	00 00 00 
  800433:	be 2f 00 00 00       	mov    $0x2f,%esi
  800438:	48 bf 79 41 80 00 00 	movabs $0x804179,%rdi
  80043f:	00 00 00 
  800442:	b8 00 00 00 00       	mov    $0x0,%eax
  800447:	49 b8 ed 05 80 00 00 	movabs $0x8005ed,%r8
  80044e:	00 00 00 
  800451:	41 ff d0             	callq  *%r8

	if (pid == 0) {
  800454:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800458:	0f 85 83 00 00 00    	jne    8004e1 <umain+0x49e>
		close(p[0]);
  80045e:	8b 85 70 ff ff ff    	mov    -0x90(%rbp),%eax
  800464:	89 c7                	mov    %eax,%edi
  800466:	48 b8 07 29 80 00 00 	movabs $0x802907,%rax
  80046d:	00 00 00 
  800470:	ff d0                	callq  *%rax
		while (1) {
			cprintf(".");
  800472:	48 bf 38 42 80 00 00 	movabs $0x804238,%rdi
  800479:	00 00 00 
  80047c:	b8 00 00 00 00       	mov    $0x0,%eax
  800481:	48 ba 26 08 80 00 00 	movabs $0x800826,%rdx
  800488:	00 00 00 
  80048b:	ff d2                	callq  *%rdx
			if (write(p[1], "x", 1) != 1)
  80048d:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  800493:	ba 01 00 00 00       	mov    $0x1,%edx
  800498:	48 be 3a 42 80 00 00 	movabs $0x80423a,%rsi
  80049f:	00 00 00 
  8004a2:	89 c7                	mov    %eax,%edi
  8004a4:	48 b8 73 2c 80 00 00 	movabs $0x802c73,%rax
  8004ab:	00 00 00 
  8004ae:	ff d0                	callq  *%rax
  8004b0:	83 f8 01             	cmp    $0x1,%eax
  8004b3:	74 2a                	je     8004df <umain+0x49c>
				break;
  8004b5:	90                   	nop
		}
		cprintf("\npipe write closed properly\n");
  8004b6:	48 bf 3c 42 80 00 00 	movabs $0x80423c,%rdi
  8004bd:	00 00 00 
  8004c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c5:	48 ba 26 08 80 00 00 	movabs $0x800826,%rdx
  8004cc:	00 00 00 
  8004cf:	ff d2                	callq  *%rdx
		exit();
  8004d1:	48 b8 ca 05 80 00 00 	movabs $0x8005ca,%rax
  8004d8:	00 00 00 
  8004db:	ff d0                	callq  *%rax
  8004dd:	eb 02                	jmp    8004e1 <umain+0x49e>
		close(p[0]);
		while (1) {
			cprintf(".");
			if (write(p[1], "x", 1) != 1)
				break;
		}
  8004df:	eb 91                	jmp    800472 <umain+0x42f>
		cprintf("\npipe write closed properly\n");
		exit();
	}
	close(p[0]);
  8004e1:	8b 85 70 ff ff ff    	mov    -0x90(%rbp),%eax
  8004e7:	89 c7                	mov    %eax,%edi
  8004e9:	48 b8 07 29 80 00 00 	movabs $0x802907,%rax
  8004f0:	00 00 00 
  8004f3:	ff d0                	callq  *%rax
	close(p[1]);
  8004f5:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  8004fb:	89 c7                	mov    %eax,%edi
  8004fd:	48 b8 07 29 80 00 00 	movabs $0x802907,%rax
  800504:	00 00 00 
  800507:	ff d0                	callq  *%rax
	wait(pid);
  800509:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80050c:	89 c7                	mov    %eax,%edi
  80050e:	48 b8 03 3a 80 00 00 	movabs $0x803a03,%rax
  800515:	00 00 00 
  800518:	ff d0                	callq  *%rax

	cprintf("pipe tests passed\n");
  80051a:	48 bf 59 42 80 00 00 	movabs $0x804259,%rdi
  800521:	00 00 00 
  800524:	b8 00 00 00 00       	mov    $0x0,%eax
  800529:	48 ba 26 08 80 00 00 	movabs $0x800826,%rdx
  800530:	00 00 00 
  800533:	ff d2                	callq  *%rdx
}
  800535:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  80053c:	5b                   	pop    %rbx
  80053d:	5d                   	pop    %rbp
  80053e:	c3                   	retq   

000000000080053f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80053f:	55                   	push   %rbp
  800540:	48 89 e5             	mov    %rsp,%rbp
  800543:	48 83 ec 10          	sub    $0x10,%rsp
  800547:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80054a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80054e:	48 b8 8e 1c 80 00 00 	movabs $0x801c8e,%rax
  800555:	00 00 00 
  800558:	ff d0                	callq  *%rax
  80055a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80055f:	48 63 d0             	movslq %eax,%rdx
  800562:	48 89 d0             	mov    %rdx,%rax
  800565:	48 c1 e0 03          	shl    $0x3,%rax
  800569:	48 01 d0             	add    %rdx,%rax
  80056c:	48 c1 e0 05          	shl    $0x5,%rax
  800570:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800577:	00 00 00 
  80057a:	48 01 c2             	add    %rax,%rdx
  80057d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800584:	00 00 00 
  800587:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  80058a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80058e:	7e 14                	jle    8005a4 <libmain+0x65>
		binaryname = argv[0];
  800590:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800594:	48 8b 10             	mov    (%rax),%rdx
  800597:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80059e:	00 00 00 
  8005a1:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8005a4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8005a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005ab:	48 89 d6             	mov    %rdx,%rsi
  8005ae:	89 c7                	mov    %eax,%edi
  8005b0:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8005b7:	00 00 00 
  8005ba:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8005bc:	48 b8 ca 05 80 00 00 	movabs $0x8005ca,%rax
  8005c3:	00 00 00 
  8005c6:	ff d0                	callq  *%rax
}
  8005c8:	c9                   	leaveq 
  8005c9:	c3                   	retq   

00000000008005ca <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8005ca:	55                   	push   %rbp
  8005cb:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8005ce:	48 b8 52 29 80 00 00 	movabs $0x802952,%rax
  8005d5:	00 00 00 
  8005d8:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8005da:	bf 00 00 00 00       	mov    $0x0,%edi
  8005df:	48 b8 4a 1c 80 00 00 	movabs $0x801c4a,%rax
  8005e6:	00 00 00 
  8005e9:	ff d0                	callq  *%rax

}
  8005eb:	5d                   	pop    %rbp
  8005ec:	c3                   	retq   

00000000008005ed <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8005ed:	55                   	push   %rbp
  8005ee:	48 89 e5             	mov    %rsp,%rbp
  8005f1:	53                   	push   %rbx
  8005f2:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8005f9:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800600:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800606:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80060d:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800614:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80061b:	84 c0                	test   %al,%al
  80061d:	74 23                	je     800642 <_panic+0x55>
  80061f:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800626:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80062a:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80062e:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800632:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800636:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80063a:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80063e:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800642:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800649:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800650:	00 00 00 
  800653:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80065a:	00 00 00 
  80065d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800661:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800668:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80066f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800676:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80067d:	00 00 00 
  800680:	48 8b 18             	mov    (%rax),%rbx
  800683:	48 b8 8e 1c 80 00 00 	movabs $0x801c8e,%rax
  80068a:	00 00 00 
  80068d:	ff d0                	callq  *%rax
  80068f:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800695:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80069c:	41 89 c8             	mov    %ecx,%r8d
  80069f:	48 89 d1             	mov    %rdx,%rcx
  8006a2:	48 89 da             	mov    %rbx,%rdx
  8006a5:	89 c6                	mov    %eax,%esi
  8006a7:	48 bf 78 42 80 00 00 	movabs $0x804278,%rdi
  8006ae:	00 00 00 
  8006b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8006b6:	49 b9 26 08 80 00 00 	movabs $0x800826,%r9
  8006bd:	00 00 00 
  8006c0:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8006c3:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8006ca:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8006d1:	48 89 d6             	mov    %rdx,%rsi
  8006d4:	48 89 c7             	mov    %rax,%rdi
  8006d7:	48 b8 7a 07 80 00 00 	movabs $0x80077a,%rax
  8006de:	00 00 00 
  8006e1:	ff d0                	callq  *%rax
	cprintf("\n");
  8006e3:	48 bf 9b 42 80 00 00 	movabs $0x80429b,%rdi
  8006ea:	00 00 00 
  8006ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f2:	48 ba 26 08 80 00 00 	movabs $0x800826,%rdx
  8006f9:	00 00 00 
  8006fc:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8006fe:	cc                   	int3   
  8006ff:	eb fd                	jmp    8006fe <_panic+0x111>

0000000000800701 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800701:	55                   	push   %rbp
  800702:	48 89 e5             	mov    %rsp,%rbp
  800705:	48 83 ec 10          	sub    $0x10,%rsp
  800709:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80070c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800710:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800714:	8b 00                	mov    (%rax),%eax
  800716:	8d 48 01             	lea    0x1(%rax),%ecx
  800719:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80071d:	89 0a                	mov    %ecx,(%rdx)
  80071f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800722:	89 d1                	mov    %edx,%ecx
  800724:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800728:	48 98                	cltq   
  80072a:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  80072e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800732:	8b 00                	mov    (%rax),%eax
  800734:	3d ff 00 00 00       	cmp    $0xff,%eax
  800739:	75 2c                	jne    800767 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  80073b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80073f:	8b 00                	mov    (%rax),%eax
  800741:	48 98                	cltq   
  800743:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800747:	48 83 c2 08          	add    $0x8,%rdx
  80074b:	48 89 c6             	mov    %rax,%rsi
  80074e:	48 89 d7             	mov    %rdx,%rdi
  800751:	48 b8 c2 1b 80 00 00 	movabs $0x801bc2,%rax
  800758:	00 00 00 
  80075b:	ff d0                	callq  *%rax
		b->idx = 0;
  80075d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800761:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800767:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80076b:	8b 40 04             	mov    0x4(%rax),%eax
  80076e:	8d 50 01             	lea    0x1(%rax),%edx
  800771:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800775:	89 50 04             	mov    %edx,0x4(%rax)
}
  800778:	c9                   	leaveq 
  800779:	c3                   	retq   

000000000080077a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80077a:	55                   	push   %rbp
  80077b:	48 89 e5             	mov    %rsp,%rbp
  80077e:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800785:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80078c:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  800793:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80079a:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8007a1:	48 8b 0a             	mov    (%rdx),%rcx
  8007a4:	48 89 08             	mov    %rcx,(%rax)
  8007a7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007ab:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007af:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007b3:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8007b7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8007be:	00 00 00 
	b.cnt = 0;
  8007c1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8007c8:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8007cb:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8007d2:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8007d9:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8007e0:	48 89 c6             	mov    %rax,%rsi
  8007e3:	48 bf 01 07 80 00 00 	movabs $0x800701,%rdi
  8007ea:	00 00 00 
  8007ed:	48 b8 d9 0b 80 00 00 	movabs $0x800bd9,%rax
  8007f4:	00 00 00 
  8007f7:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  8007f9:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8007ff:	48 98                	cltq   
  800801:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800808:	48 83 c2 08          	add    $0x8,%rdx
  80080c:	48 89 c6             	mov    %rax,%rsi
  80080f:	48 89 d7             	mov    %rdx,%rdi
  800812:	48 b8 c2 1b 80 00 00 	movabs $0x801bc2,%rax
  800819:	00 00 00 
  80081c:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  80081e:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800824:	c9                   	leaveq 
  800825:	c3                   	retq   

0000000000800826 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800826:	55                   	push   %rbp
  800827:	48 89 e5             	mov    %rsp,%rbp
  80082a:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800831:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800838:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80083f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800846:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80084d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800854:	84 c0                	test   %al,%al
  800856:	74 20                	je     800878 <cprintf+0x52>
  800858:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80085c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800860:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800864:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800868:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80086c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800870:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800874:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800878:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  80087f:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800886:	00 00 00 
  800889:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800890:	00 00 00 
  800893:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800897:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80089e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8008a5:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8008ac:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8008b3:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8008ba:	48 8b 0a             	mov    (%rdx),%rcx
  8008bd:	48 89 08             	mov    %rcx,(%rax)
  8008c0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8008c4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8008c8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8008cc:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8008d0:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8008d7:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8008de:	48 89 d6             	mov    %rdx,%rsi
  8008e1:	48 89 c7             	mov    %rax,%rdi
  8008e4:	48 b8 7a 07 80 00 00 	movabs $0x80077a,%rax
  8008eb:	00 00 00 
  8008ee:	ff d0                	callq  *%rax
  8008f0:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  8008f6:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8008fc:	c9                   	leaveq 
  8008fd:	c3                   	retq   

00000000008008fe <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008fe:	55                   	push   %rbp
  8008ff:	48 89 e5             	mov    %rsp,%rbp
  800902:	53                   	push   %rbx
  800903:	48 83 ec 38          	sub    $0x38,%rsp
  800907:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80090b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80090f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800913:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800916:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80091a:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80091e:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800921:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800925:	77 3b                	ja     800962 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800927:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80092a:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80092e:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800931:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800935:	ba 00 00 00 00       	mov    $0x0,%edx
  80093a:	48 f7 f3             	div    %rbx
  80093d:	48 89 c2             	mov    %rax,%rdx
  800940:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800943:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800946:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80094a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80094e:	41 89 f9             	mov    %edi,%r9d
  800951:	48 89 c7             	mov    %rax,%rdi
  800954:	48 b8 fe 08 80 00 00 	movabs $0x8008fe,%rax
  80095b:	00 00 00 
  80095e:	ff d0                	callq  *%rax
  800960:	eb 1e                	jmp    800980 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800962:	eb 12                	jmp    800976 <printnum+0x78>
			putch(padc, putdat);
  800964:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800968:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80096b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80096f:	48 89 ce             	mov    %rcx,%rsi
  800972:	89 d7                	mov    %edx,%edi
  800974:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800976:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80097a:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80097e:	7f e4                	jg     800964 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800980:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800983:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800987:	ba 00 00 00 00       	mov    $0x0,%edx
  80098c:	48 f7 f1             	div    %rcx
  80098f:	48 89 d0             	mov    %rdx,%rax
  800992:	48 ba 68 44 80 00 00 	movabs $0x804468,%rdx
  800999:	00 00 00 
  80099c:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8009a0:	0f be d0             	movsbl %al,%edx
  8009a3:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8009a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ab:	48 89 ce             	mov    %rcx,%rsi
  8009ae:	89 d7                	mov    %edx,%edi
  8009b0:	ff d0                	callq  *%rax
}
  8009b2:	48 83 c4 38          	add    $0x38,%rsp
  8009b6:	5b                   	pop    %rbx
  8009b7:	5d                   	pop    %rbp
  8009b8:	c3                   	retq   

00000000008009b9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8009b9:	55                   	push   %rbp
  8009ba:	48 89 e5             	mov    %rsp,%rbp
  8009bd:	48 83 ec 1c          	sub    $0x1c,%rsp
  8009c1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8009c5:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8009c8:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8009cc:	7e 52                	jle    800a20 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8009ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d2:	8b 00                	mov    (%rax),%eax
  8009d4:	83 f8 30             	cmp    $0x30,%eax
  8009d7:	73 24                	jae    8009fd <getuint+0x44>
  8009d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009dd:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009e5:	8b 00                	mov    (%rax),%eax
  8009e7:	89 c0                	mov    %eax,%eax
  8009e9:	48 01 d0             	add    %rdx,%rax
  8009ec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009f0:	8b 12                	mov    (%rdx),%edx
  8009f2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009f5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009f9:	89 0a                	mov    %ecx,(%rdx)
  8009fb:	eb 17                	jmp    800a14 <getuint+0x5b>
  8009fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a01:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a05:	48 89 d0             	mov    %rdx,%rax
  800a08:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a0c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a10:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a14:	48 8b 00             	mov    (%rax),%rax
  800a17:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a1b:	e9 a3 00 00 00       	jmpq   800ac3 <getuint+0x10a>
	else if (lflag)
  800a20:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a24:	74 4f                	je     800a75 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800a26:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a2a:	8b 00                	mov    (%rax),%eax
  800a2c:	83 f8 30             	cmp    $0x30,%eax
  800a2f:	73 24                	jae    800a55 <getuint+0x9c>
  800a31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a35:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a3d:	8b 00                	mov    (%rax),%eax
  800a3f:	89 c0                	mov    %eax,%eax
  800a41:	48 01 d0             	add    %rdx,%rax
  800a44:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a48:	8b 12                	mov    (%rdx),%edx
  800a4a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a4d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a51:	89 0a                	mov    %ecx,(%rdx)
  800a53:	eb 17                	jmp    800a6c <getuint+0xb3>
  800a55:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a59:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a5d:	48 89 d0             	mov    %rdx,%rax
  800a60:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a64:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a68:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a6c:	48 8b 00             	mov    (%rax),%rax
  800a6f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a73:	eb 4e                	jmp    800ac3 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800a75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a79:	8b 00                	mov    (%rax),%eax
  800a7b:	83 f8 30             	cmp    $0x30,%eax
  800a7e:	73 24                	jae    800aa4 <getuint+0xeb>
  800a80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a84:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a8c:	8b 00                	mov    (%rax),%eax
  800a8e:	89 c0                	mov    %eax,%eax
  800a90:	48 01 d0             	add    %rdx,%rax
  800a93:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a97:	8b 12                	mov    (%rdx),%edx
  800a99:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a9c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aa0:	89 0a                	mov    %ecx,(%rdx)
  800aa2:	eb 17                	jmp    800abb <getuint+0x102>
  800aa4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aa8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800aac:	48 89 d0             	mov    %rdx,%rax
  800aaf:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800ab3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ab7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800abb:	8b 00                	mov    (%rax),%eax
  800abd:	89 c0                	mov    %eax,%eax
  800abf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800ac3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800ac7:	c9                   	leaveq 
  800ac8:	c3                   	retq   

0000000000800ac9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ac9:	55                   	push   %rbp
  800aca:	48 89 e5             	mov    %rsp,%rbp
  800acd:	48 83 ec 1c          	sub    $0x1c,%rsp
  800ad1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ad5:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800ad8:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800adc:	7e 52                	jle    800b30 <getint+0x67>
		x=va_arg(*ap, long long);
  800ade:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ae2:	8b 00                	mov    (%rax),%eax
  800ae4:	83 f8 30             	cmp    $0x30,%eax
  800ae7:	73 24                	jae    800b0d <getint+0x44>
  800ae9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aed:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800af1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800af5:	8b 00                	mov    (%rax),%eax
  800af7:	89 c0                	mov    %eax,%eax
  800af9:	48 01 d0             	add    %rdx,%rax
  800afc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b00:	8b 12                	mov    (%rdx),%edx
  800b02:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b05:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b09:	89 0a                	mov    %ecx,(%rdx)
  800b0b:	eb 17                	jmp    800b24 <getint+0x5b>
  800b0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b11:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b15:	48 89 d0             	mov    %rdx,%rax
  800b18:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b1c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b20:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b24:	48 8b 00             	mov    (%rax),%rax
  800b27:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b2b:	e9 a3 00 00 00       	jmpq   800bd3 <getint+0x10a>
	else if (lflag)
  800b30:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800b34:	74 4f                	je     800b85 <getint+0xbc>
		x=va_arg(*ap, long);
  800b36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b3a:	8b 00                	mov    (%rax),%eax
  800b3c:	83 f8 30             	cmp    $0x30,%eax
  800b3f:	73 24                	jae    800b65 <getint+0x9c>
  800b41:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b45:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b4d:	8b 00                	mov    (%rax),%eax
  800b4f:	89 c0                	mov    %eax,%eax
  800b51:	48 01 d0             	add    %rdx,%rax
  800b54:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b58:	8b 12                	mov    (%rdx),%edx
  800b5a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b5d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b61:	89 0a                	mov    %ecx,(%rdx)
  800b63:	eb 17                	jmp    800b7c <getint+0xb3>
  800b65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b69:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b6d:	48 89 d0             	mov    %rdx,%rax
  800b70:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b74:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b78:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b7c:	48 8b 00             	mov    (%rax),%rax
  800b7f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b83:	eb 4e                	jmp    800bd3 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800b85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b89:	8b 00                	mov    (%rax),%eax
  800b8b:	83 f8 30             	cmp    $0x30,%eax
  800b8e:	73 24                	jae    800bb4 <getint+0xeb>
  800b90:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b94:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b9c:	8b 00                	mov    (%rax),%eax
  800b9e:	89 c0                	mov    %eax,%eax
  800ba0:	48 01 d0             	add    %rdx,%rax
  800ba3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ba7:	8b 12                	mov    (%rdx),%edx
  800ba9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800bac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bb0:	89 0a                	mov    %ecx,(%rdx)
  800bb2:	eb 17                	jmp    800bcb <getint+0x102>
  800bb4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bb8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800bbc:	48 89 d0             	mov    %rdx,%rax
  800bbf:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800bc3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bc7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800bcb:	8b 00                	mov    (%rax),%eax
  800bcd:	48 98                	cltq   
  800bcf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800bd3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800bd7:	c9                   	leaveq 
  800bd8:	c3                   	retq   

0000000000800bd9 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bd9:	55                   	push   %rbp
  800bda:	48 89 e5             	mov    %rsp,%rbp
  800bdd:	41 54                	push   %r12
  800bdf:	53                   	push   %rbx
  800be0:	48 83 ec 60          	sub    $0x60,%rsp
  800be4:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800be8:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800bec:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800bf0:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800bf4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bf8:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800bfc:	48 8b 0a             	mov    (%rdx),%rcx
  800bff:	48 89 08             	mov    %rcx,(%rax)
  800c02:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c06:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800c0a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800c0e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c12:	eb 17                	jmp    800c2b <vprintfmt+0x52>
			if (ch == '\0')
  800c14:	85 db                	test   %ebx,%ebx
  800c16:	0f 84 cc 04 00 00    	je     8010e8 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800c1c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c20:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c24:	48 89 d6             	mov    %rdx,%rsi
  800c27:	89 df                	mov    %ebx,%edi
  800c29:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c2b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c2f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800c33:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800c37:	0f b6 00             	movzbl (%rax),%eax
  800c3a:	0f b6 d8             	movzbl %al,%ebx
  800c3d:	83 fb 25             	cmp    $0x25,%ebx
  800c40:	75 d2                	jne    800c14 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c42:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800c46:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800c4d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800c54:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800c5b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c62:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c66:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800c6a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800c6e:	0f b6 00             	movzbl (%rax),%eax
  800c71:	0f b6 d8             	movzbl %al,%ebx
  800c74:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800c77:	83 f8 55             	cmp    $0x55,%eax
  800c7a:	0f 87 34 04 00 00    	ja     8010b4 <vprintfmt+0x4db>
  800c80:	89 c0                	mov    %eax,%eax
  800c82:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800c89:	00 
  800c8a:	48 b8 90 44 80 00 00 	movabs $0x804490,%rax
  800c91:	00 00 00 
  800c94:	48 01 d0             	add    %rdx,%rax
  800c97:	48 8b 00             	mov    (%rax),%rax
  800c9a:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c9c:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800ca0:	eb c0                	jmp    800c62 <vprintfmt+0x89>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ca2:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800ca6:	eb ba                	jmp    800c62 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ca8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800caf:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800cb2:	89 d0                	mov    %edx,%eax
  800cb4:	c1 e0 02             	shl    $0x2,%eax
  800cb7:	01 d0                	add    %edx,%eax
  800cb9:	01 c0                	add    %eax,%eax
  800cbb:	01 d8                	add    %ebx,%eax
  800cbd:	83 e8 30             	sub    $0x30,%eax
  800cc0:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800cc3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800cc7:	0f b6 00             	movzbl (%rax),%eax
  800cca:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ccd:	83 fb 2f             	cmp    $0x2f,%ebx
  800cd0:	7e 0c                	jle    800cde <vprintfmt+0x105>
  800cd2:	83 fb 39             	cmp    $0x39,%ebx
  800cd5:	7f 07                	jg     800cde <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cd7:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cdc:	eb d1                	jmp    800caf <vprintfmt+0xd6>
			goto process_precision;
  800cde:	eb 58                	jmp    800d38 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800ce0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ce3:	83 f8 30             	cmp    $0x30,%eax
  800ce6:	73 17                	jae    800cff <vprintfmt+0x126>
  800ce8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cec:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cef:	89 c0                	mov    %eax,%eax
  800cf1:	48 01 d0             	add    %rdx,%rax
  800cf4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cf7:	83 c2 08             	add    $0x8,%edx
  800cfa:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cfd:	eb 0f                	jmp    800d0e <vprintfmt+0x135>
  800cff:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d03:	48 89 d0             	mov    %rdx,%rax
  800d06:	48 83 c2 08          	add    $0x8,%rdx
  800d0a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d0e:	8b 00                	mov    (%rax),%eax
  800d10:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800d13:	eb 23                	jmp    800d38 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800d15:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d19:	79 0c                	jns    800d27 <vprintfmt+0x14e>
				width = 0;
  800d1b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800d22:	e9 3b ff ff ff       	jmpq   800c62 <vprintfmt+0x89>
  800d27:	e9 36 ff ff ff       	jmpq   800c62 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800d2c:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800d33:	e9 2a ff ff ff       	jmpq   800c62 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800d38:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d3c:	79 12                	jns    800d50 <vprintfmt+0x177>
				width = precision, precision = -1;
  800d3e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800d41:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800d44:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800d4b:	e9 12 ff ff ff       	jmpq   800c62 <vprintfmt+0x89>
  800d50:	e9 0d ff ff ff       	jmpq   800c62 <vprintfmt+0x89>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d55:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800d59:	e9 04 ff ff ff       	jmpq   800c62 <vprintfmt+0x89>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800d5e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d61:	83 f8 30             	cmp    $0x30,%eax
  800d64:	73 17                	jae    800d7d <vprintfmt+0x1a4>
  800d66:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d6a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d6d:	89 c0                	mov    %eax,%eax
  800d6f:	48 01 d0             	add    %rdx,%rax
  800d72:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d75:	83 c2 08             	add    $0x8,%edx
  800d78:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d7b:	eb 0f                	jmp    800d8c <vprintfmt+0x1b3>
  800d7d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d81:	48 89 d0             	mov    %rdx,%rax
  800d84:	48 83 c2 08          	add    $0x8,%rdx
  800d88:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d8c:	8b 10                	mov    (%rax),%edx
  800d8e:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800d92:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d96:	48 89 ce             	mov    %rcx,%rsi
  800d99:	89 d7                	mov    %edx,%edi
  800d9b:	ff d0                	callq  *%rax
			break;
  800d9d:	e9 40 03 00 00       	jmpq   8010e2 <vprintfmt+0x509>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800da2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800da5:	83 f8 30             	cmp    $0x30,%eax
  800da8:	73 17                	jae    800dc1 <vprintfmt+0x1e8>
  800daa:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800dae:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800db1:	89 c0                	mov    %eax,%eax
  800db3:	48 01 d0             	add    %rdx,%rax
  800db6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800db9:	83 c2 08             	add    $0x8,%edx
  800dbc:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800dbf:	eb 0f                	jmp    800dd0 <vprintfmt+0x1f7>
  800dc1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800dc5:	48 89 d0             	mov    %rdx,%rax
  800dc8:	48 83 c2 08          	add    $0x8,%rdx
  800dcc:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800dd0:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800dd2:	85 db                	test   %ebx,%ebx
  800dd4:	79 02                	jns    800dd8 <vprintfmt+0x1ff>
				err = -err;
  800dd6:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800dd8:	83 fb 10             	cmp    $0x10,%ebx
  800ddb:	7f 16                	jg     800df3 <vprintfmt+0x21a>
  800ddd:	48 b8 e0 43 80 00 00 	movabs $0x8043e0,%rax
  800de4:	00 00 00 
  800de7:	48 63 d3             	movslq %ebx,%rdx
  800dea:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800dee:	4d 85 e4             	test   %r12,%r12
  800df1:	75 2e                	jne    800e21 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800df3:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800df7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dfb:	89 d9                	mov    %ebx,%ecx
  800dfd:	48 ba 79 44 80 00 00 	movabs $0x804479,%rdx
  800e04:	00 00 00 
  800e07:	48 89 c7             	mov    %rax,%rdi
  800e0a:	b8 00 00 00 00       	mov    $0x0,%eax
  800e0f:	49 b8 f1 10 80 00 00 	movabs $0x8010f1,%r8
  800e16:	00 00 00 
  800e19:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e1c:	e9 c1 02 00 00       	jmpq   8010e2 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e21:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e25:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e29:	4c 89 e1             	mov    %r12,%rcx
  800e2c:	48 ba 82 44 80 00 00 	movabs $0x804482,%rdx
  800e33:	00 00 00 
  800e36:	48 89 c7             	mov    %rax,%rdi
  800e39:	b8 00 00 00 00       	mov    $0x0,%eax
  800e3e:	49 b8 f1 10 80 00 00 	movabs $0x8010f1,%r8
  800e45:	00 00 00 
  800e48:	41 ff d0             	callq  *%r8
			break;
  800e4b:	e9 92 02 00 00       	jmpq   8010e2 <vprintfmt+0x509>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800e50:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e53:	83 f8 30             	cmp    $0x30,%eax
  800e56:	73 17                	jae    800e6f <vprintfmt+0x296>
  800e58:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e5c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e5f:	89 c0                	mov    %eax,%eax
  800e61:	48 01 d0             	add    %rdx,%rax
  800e64:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e67:	83 c2 08             	add    $0x8,%edx
  800e6a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e6d:	eb 0f                	jmp    800e7e <vprintfmt+0x2a5>
  800e6f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e73:	48 89 d0             	mov    %rdx,%rax
  800e76:	48 83 c2 08          	add    $0x8,%rdx
  800e7a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e7e:	4c 8b 20             	mov    (%rax),%r12
  800e81:	4d 85 e4             	test   %r12,%r12
  800e84:	75 0a                	jne    800e90 <vprintfmt+0x2b7>
				p = "(null)";
  800e86:	49 bc 85 44 80 00 00 	movabs $0x804485,%r12
  800e8d:	00 00 00 
			if (width > 0 && padc != '-')
  800e90:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e94:	7e 3f                	jle    800ed5 <vprintfmt+0x2fc>
  800e96:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800e9a:	74 39                	je     800ed5 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e9c:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800e9f:	48 98                	cltq   
  800ea1:	48 89 c6             	mov    %rax,%rsi
  800ea4:	4c 89 e7             	mov    %r12,%rdi
  800ea7:	48 b8 9d 13 80 00 00 	movabs $0x80139d,%rax
  800eae:	00 00 00 
  800eb1:	ff d0                	callq  *%rax
  800eb3:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800eb6:	eb 17                	jmp    800ecf <vprintfmt+0x2f6>
					putch(padc, putdat);
  800eb8:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800ebc:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800ec0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ec4:	48 89 ce             	mov    %rcx,%rsi
  800ec7:	89 d7                	mov    %edx,%edi
  800ec9:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ecb:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ecf:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ed3:	7f e3                	jg     800eb8 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ed5:	eb 37                	jmp    800f0e <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800ed7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800edb:	74 1e                	je     800efb <vprintfmt+0x322>
  800edd:	83 fb 1f             	cmp    $0x1f,%ebx
  800ee0:	7e 05                	jle    800ee7 <vprintfmt+0x30e>
  800ee2:	83 fb 7e             	cmp    $0x7e,%ebx
  800ee5:	7e 14                	jle    800efb <vprintfmt+0x322>
					putch('?', putdat);
  800ee7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800eeb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eef:	48 89 d6             	mov    %rdx,%rsi
  800ef2:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800ef7:	ff d0                	callq  *%rax
  800ef9:	eb 0f                	jmp    800f0a <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800efb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800eff:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f03:	48 89 d6             	mov    %rdx,%rsi
  800f06:	89 df                	mov    %ebx,%edi
  800f08:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f0a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800f0e:	4c 89 e0             	mov    %r12,%rax
  800f11:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800f15:	0f b6 00             	movzbl (%rax),%eax
  800f18:	0f be d8             	movsbl %al,%ebx
  800f1b:	85 db                	test   %ebx,%ebx
  800f1d:	74 10                	je     800f2f <vprintfmt+0x356>
  800f1f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800f23:	78 b2                	js     800ed7 <vprintfmt+0x2fe>
  800f25:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800f29:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800f2d:	79 a8                	jns    800ed7 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f2f:	eb 16                	jmp    800f47 <vprintfmt+0x36e>
				putch(' ', putdat);
  800f31:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f35:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f39:	48 89 d6             	mov    %rdx,%rsi
  800f3c:	bf 20 00 00 00       	mov    $0x20,%edi
  800f41:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f43:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800f47:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800f4b:	7f e4                	jg     800f31 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800f4d:	e9 90 01 00 00       	jmpq   8010e2 <vprintfmt+0x509>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800f52:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f56:	be 03 00 00 00       	mov    $0x3,%esi
  800f5b:	48 89 c7             	mov    %rax,%rdi
  800f5e:	48 b8 c9 0a 80 00 00 	movabs $0x800ac9,%rax
  800f65:	00 00 00 
  800f68:	ff d0                	callq  *%rax
  800f6a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800f6e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f72:	48 85 c0             	test   %rax,%rax
  800f75:	79 1d                	jns    800f94 <vprintfmt+0x3bb>
				putch('-', putdat);
  800f77:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f7b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f7f:	48 89 d6             	mov    %rdx,%rsi
  800f82:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800f87:	ff d0                	callq  *%rax
				num = -(long long) num;
  800f89:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f8d:	48 f7 d8             	neg    %rax
  800f90:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800f94:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800f9b:	e9 d5 00 00 00       	jmpq   801075 <vprintfmt+0x49c>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800fa0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800fa4:	be 03 00 00 00       	mov    $0x3,%esi
  800fa9:	48 89 c7             	mov    %rax,%rdi
  800fac:	48 b8 b9 09 80 00 00 	movabs $0x8009b9,%rax
  800fb3:	00 00 00 
  800fb6:	ff d0                	callq  *%rax
  800fb8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800fbc:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800fc3:	e9 ad 00 00 00       	jmpq   801075 <vprintfmt+0x49c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800fc8:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800fcb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800fcf:	89 d6                	mov    %edx,%esi
  800fd1:	48 89 c7             	mov    %rax,%rdi
  800fd4:	48 b8 c9 0a 80 00 00 	movabs $0x800ac9,%rax
  800fdb:	00 00 00 
  800fde:	ff d0                	callq  *%rax
  800fe0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800fe4:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800feb:	e9 85 00 00 00       	jmpq   801075 <vprintfmt+0x49c>


		// pointer
		case 'p':
			putch('0', putdat);
  800ff0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ff4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ff8:	48 89 d6             	mov    %rdx,%rsi
  800ffb:	bf 30 00 00 00       	mov    $0x30,%edi
  801000:	ff d0                	callq  *%rax
			putch('x', putdat);
  801002:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801006:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80100a:	48 89 d6             	mov    %rdx,%rsi
  80100d:	bf 78 00 00 00       	mov    $0x78,%edi
  801012:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801014:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801017:	83 f8 30             	cmp    $0x30,%eax
  80101a:	73 17                	jae    801033 <vprintfmt+0x45a>
  80101c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801020:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801023:	89 c0                	mov    %eax,%eax
  801025:	48 01 d0             	add    %rdx,%rax
  801028:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80102b:	83 c2 08             	add    $0x8,%edx
  80102e:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801031:	eb 0f                	jmp    801042 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  801033:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801037:	48 89 d0             	mov    %rdx,%rax
  80103a:	48 83 c2 08          	add    $0x8,%rdx
  80103e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801042:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801045:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801049:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801050:	eb 23                	jmp    801075 <vprintfmt+0x49c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801052:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801056:	be 03 00 00 00       	mov    $0x3,%esi
  80105b:	48 89 c7             	mov    %rax,%rdi
  80105e:	48 b8 b9 09 80 00 00 	movabs $0x8009b9,%rax
  801065:	00 00 00 
  801068:	ff d0                	callq  *%rax
  80106a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  80106e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801075:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  80107a:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80107d:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801080:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801084:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801088:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80108c:	45 89 c1             	mov    %r8d,%r9d
  80108f:	41 89 f8             	mov    %edi,%r8d
  801092:	48 89 c7             	mov    %rax,%rdi
  801095:	48 b8 fe 08 80 00 00 	movabs $0x8008fe,%rax
  80109c:	00 00 00 
  80109f:	ff d0                	callq  *%rax
			break;
  8010a1:	eb 3f                	jmp    8010e2 <vprintfmt+0x509>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010a3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010a7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010ab:	48 89 d6             	mov    %rdx,%rsi
  8010ae:	89 df                	mov    %ebx,%edi
  8010b0:	ff d0                	callq  *%rax
			break;
  8010b2:	eb 2e                	jmp    8010e2 <vprintfmt+0x509>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010b4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010b8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010bc:	48 89 d6             	mov    %rdx,%rsi
  8010bf:	bf 25 00 00 00       	mov    $0x25,%edi
  8010c4:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010c6:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8010cb:	eb 05                	jmp    8010d2 <vprintfmt+0x4f9>
  8010cd:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8010d2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8010d6:	48 83 e8 01          	sub    $0x1,%rax
  8010da:	0f b6 00             	movzbl (%rax),%eax
  8010dd:	3c 25                	cmp    $0x25,%al
  8010df:	75 ec                	jne    8010cd <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  8010e1:	90                   	nop
		}
	}
  8010e2:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8010e3:	e9 43 fb ff ff       	jmpq   800c2b <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  8010e8:	48 83 c4 60          	add    $0x60,%rsp
  8010ec:	5b                   	pop    %rbx
  8010ed:	41 5c                	pop    %r12
  8010ef:	5d                   	pop    %rbp
  8010f0:	c3                   	retq   

00000000008010f1 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8010f1:	55                   	push   %rbp
  8010f2:	48 89 e5             	mov    %rsp,%rbp
  8010f5:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8010fc:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801103:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80110a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801111:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801118:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80111f:	84 c0                	test   %al,%al
  801121:	74 20                	je     801143 <printfmt+0x52>
  801123:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801127:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80112b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80112f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801133:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801137:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80113b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80113f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801143:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80114a:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801151:	00 00 00 
  801154:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80115b:	00 00 00 
  80115e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801162:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801169:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801170:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801177:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  80117e:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801185:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  80118c:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801193:	48 89 c7             	mov    %rax,%rdi
  801196:	48 b8 d9 0b 80 00 00 	movabs $0x800bd9,%rax
  80119d:	00 00 00 
  8011a0:	ff d0                	callq  *%rax
	va_end(ap);
}
  8011a2:	c9                   	leaveq 
  8011a3:	c3                   	retq   

00000000008011a4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8011a4:	55                   	push   %rbp
  8011a5:	48 89 e5             	mov    %rsp,%rbp
  8011a8:	48 83 ec 10          	sub    $0x10,%rsp
  8011ac:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8011af:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8011b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011b7:	8b 40 10             	mov    0x10(%rax),%eax
  8011ba:	8d 50 01             	lea    0x1(%rax),%edx
  8011bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011c1:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8011c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011c8:	48 8b 10             	mov    (%rax),%rdx
  8011cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011cf:	48 8b 40 08          	mov    0x8(%rax),%rax
  8011d3:	48 39 c2             	cmp    %rax,%rdx
  8011d6:	73 17                	jae    8011ef <sprintputch+0x4b>
		*b->buf++ = ch;
  8011d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011dc:	48 8b 00             	mov    (%rax),%rax
  8011df:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8011e3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8011e7:	48 89 0a             	mov    %rcx,(%rdx)
  8011ea:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8011ed:	88 10                	mov    %dl,(%rax)
}
  8011ef:	c9                   	leaveq 
  8011f0:	c3                   	retq   

00000000008011f1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011f1:	55                   	push   %rbp
  8011f2:	48 89 e5             	mov    %rsp,%rbp
  8011f5:	48 83 ec 50          	sub    $0x50,%rsp
  8011f9:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8011fd:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801200:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801204:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801208:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80120c:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801210:	48 8b 0a             	mov    (%rdx),%rcx
  801213:	48 89 08             	mov    %rcx,(%rax)
  801216:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80121a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80121e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801222:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801226:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80122a:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80122e:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801231:	48 98                	cltq   
  801233:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801237:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80123b:	48 01 d0             	add    %rdx,%rax
  80123e:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801242:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801249:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80124e:	74 06                	je     801256 <vsnprintf+0x65>
  801250:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801254:	7f 07                	jg     80125d <vsnprintf+0x6c>
		return -E_INVAL;
  801256:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80125b:	eb 2f                	jmp    80128c <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80125d:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801261:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801265:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801269:	48 89 c6             	mov    %rax,%rsi
  80126c:	48 bf a4 11 80 00 00 	movabs $0x8011a4,%rdi
  801273:	00 00 00 
  801276:	48 b8 d9 0b 80 00 00 	movabs $0x800bd9,%rax
  80127d:	00 00 00 
  801280:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801282:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801286:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801289:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80128c:	c9                   	leaveq 
  80128d:	c3                   	retq   

000000000080128e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80128e:	55                   	push   %rbp
  80128f:	48 89 e5             	mov    %rsp,%rbp
  801292:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801299:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8012a0:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8012a6:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8012ad:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8012b4:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8012bb:	84 c0                	test   %al,%al
  8012bd:	74 20                	je     8012df <snprintf+0x51>
  8012bf:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8012c3:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8012c7:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8012cb:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8012cf:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8012d3:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8012d7:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8012db:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8012df:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8012e6:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8012ed:	00 00 00 
  8012f0:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8012f7:	00 00 00 
  8012fa:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8012fe:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801305:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80130c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801313:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80131a:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801321:	48 8b 0a             	mov    (%rdx),%rcx
  801324:	48 89 08             	mov    %rcx,(%rax)
  801327:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80132b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80132f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801333:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801337:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80133e:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801345:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80134b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801352:	48 89 c7             	mov    %rax,%rdi
  801355:	48 b8 f1 11 80 00 00 	movabs $0x8011f1,%rax
  80135c:	00 00 00 
  80135f:	ff d0                	callq  *%rax
  801361:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801367:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80136d:	c9                   	leaveq 
  80136e:	c3                   	retq   

000000000080136f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80136f:	55                   	push   %rbp
  801370:	48 89 e5             	mov    %rsp,%rbp
  801373:	48 83 ec 18          	sub    $0x18,%rsp
  801377:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80137b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801382:	eb 09                	jmp    80138d <strlen+0x1e>
		n++;
  801384:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801388:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80138d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801391:	0f b6 00             	movzbl (%rax),%eax
  801394:	84 c0                	test   %al,%al
  801396:	75 ec                	jne    801384 <strlen+0x15>
		n++;
	return n;
  801398:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80139b:	c9                   	leaveq 
  80139c:	c3                   	retq   

000000000080139d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80139d:	55                   	push   %rbp
  80139e:	48 89 e5             	mov    %rsp,%rbp
  8013a1:	48 83 ec 20          	sub    $0x20,%rsp
  8013a5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013a9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8013b4:	eb 0e                	jmp    8013c4 <strnlen+0x27>
		n++;
  8013b6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013ba:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013bf:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8013c4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8013c9:	74 0b                	je     8013d6 <strnlen+0x39>
  8013cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013cf:	0f b6 00             	movzbl (%rax),%eax
  8013d2:	84 c0                	test   %al,%al
  8013d4:	75 e0                	jne    8013b6 <strnlen+0x19>
		n++;
	return n;
  8013d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8013d9:	c9                   	leaveq 
  8013da:	c3                   	retq   

00000000008013db <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8013db:	55                   	push   %rbp
  8013dc:	48 89 e5             	mov    %rsp,%rbp
  8013df:	48 83 ec 20          	sub    $0x20,%rsp
  8013e3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013e7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8013eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ef:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8013f3:	90                   	nop
  8013f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013f8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013fc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801400:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801404:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801408:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80140c:	0f b6 12             	movzbl (%rdx),%edx
  80140f:	88 10                	mov    %dl,(%rax)
  801411:	0f b6 00             	movzbl (%rax),%eax
  801414:	84 c0                	test   %al,%al
  801416:	75 dc                	jne    8013f4 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801418:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80141c:	c9                   	leaveq 
  80141d:	c3                   	retq   

000000000080141e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80141e:	55                   	push   %rbp
  80141f:	48 89 e5             	mov    %rsp,%rbp
  801422:	48 83 ec 20          	sub    $0x20,%rsp
  801426:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80142a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80142e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801432:	48 89 c7             	mov    %rax,%rdi
  801435:	48 b8 6f 13 80 00 00 	movabs $0x80136f,%rax
  80143c:	00 00 00 
  80143f:	ff d0                	callq  *%rax
  801441:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801444:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801447:	48 63 d0             	movslq %eax,%rdx
  80144a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80144e:	48 01 c2             	add    %rax,%rdx
  801451:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801455:	48 89 c6             	mov    %rax,%rsi
  801458:	48 89 d7             	mov    %rdx,%rdi
  80145b:	48 b8 db 13 80 00 00 	movabs $0x8013db,%rax
  801462:	00 00 00 
  801465:	ff d0                	callq  *%rax
	return dst;
  801467:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80146b:	c9                   	leaveq 
  80146c:	c3                   	retq   

000000000080146d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80146d:	55                   	push   %rbp
  80146e:	48 89 e5             	mov    %rsp,%rbp
  801471:	48 83 ec 28          	sub    $0x28,%rsp
  801475:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801479:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80147d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801481:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801485:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801489:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801490:	00 
  801491:	eb 2a                	jmp    8014bd <strncpy+0x50>
		*dst++ = *src;
  801493:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801497:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80149b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80149f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8014a3:	0f b6 12             	movzbl (%rdx),%edx
  8014a6:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8014a8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014ac:	0f b6 00             	movzbl (%rax),%eax
  8014af:	84 c0                	test   %al,%al
  8014b1:	74 05                	je     8014b8 <strncpy+0x4b>
			src++;
  8014b3:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8014b8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c1:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8014c5:	72 cc                	jb     801493 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8014cb:	c9                   	leaveq 
  8014cc:	c3                   	retq   

00000000008014cd <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8014cd:	55                   	push   %rbp
  8014ce:	48 89 e5             	mov    %rsp,%rbp
  8014d1:	48 83 ec 28          	sub    $0x28,%rsp
  8014d5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014d9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014dd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8014e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014e5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8014e9:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8014ee:	74 3d                	je     80152d <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8014f0:	eb 1d                	jmp    80150f <strlcpy+0x42>
			*dst++ = *src++;
  8014f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014f6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014fa:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8014fe:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801502:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801506:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80150a:	0f b6 12             	movzbl (%rdx),%edx
  80150d:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80150f:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801514:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801519:	74 0b                	je     801526 <strlcpy+0x59>
  80151b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80151f:	0f b6 00             	movzbl (%rax),%eax
  801522:	84 c0                	test   %al,%al
  801524:	75 cc                	jne    8014f2 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801526:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80152a:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80152d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801531:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801535:	48 29 c2             	sub    %rax,%rdx
  801538:	48 89 d0             	mov    %rdx,%rax
}
  80153b:	c9                   	leaveq 
  80153c:	c3                   	retq   

000000000080153d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80153d:	55                   	push   %rbp
  80153e:	48 89 e5             	mov    %rsp,%rbp
  801541:	48 83 ec 10          	sub    $0x10,%rsp
  801545:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801549:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80154d:	eb 0a                	jmp    801559 <strcmp+0x1c>
		p++, q++;
  80154f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801554:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801559:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80155d:	0f b6 00             	movzbl (%rax),%eax
  801560:	84 c0                	test   %al,%al
  801562:	74 12                	je     801576 <strcmp+0x39>
  801564:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801568:	0f b6 10             	movzbl (%rax),%edx
  80156b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80156f:	0f b6 00             	movzbl (%rax),%eax
  801572:	38 c2                	cmp    %al,%dl
  801574:	74 d9                	je     80154f <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801576:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80157a:	0f b6 00             	movzbl (%rax),%eax
  80157d:	0f b6 d0             	movzbl %al,%edx
  801580:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801584:	0f b6 00             	movzbl (%rax),%eax
  801587:	0f b6 c0             	movzbl %al,%eax
  80158a:	29 c2                	sub    %eax,%edx
  80158c:	89 d0                	mov    %edx,%eax
}
  80158e:	c9                   	leaveq 
  80158f:	c3                   	retq   

0000000000801590 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801590:	55                   	push   %rbp
  801591:	48 89 e5             	mov    %rsp,%rbp
  801594:	48 83 ec 18          	sub    $0x18,%rsp
  801598:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80159c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8015a0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8015a4:	eb 0f                	jmp    8015b5 <strncmp+0x25>
		n--, p++, q++;
  8015a6:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8015ab:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015b0:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8015b5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015ba:	74 1d                	je     8015d9 <strncmp+0x49>
  8015bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015c0:	0f b6 00             	movzbl (%rax),%eax
  8015c3:	84 c0                	test   %al,%al
  8015c5:	74 12                	je     8015d9 <strncmp+0x49>
  8015c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015cb:	0f b6 10             	movzbl (%rax),%edx
  8015ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015d2:	0f b6 00             	movzbl (%rax),%eax
  8015d5:	38 c2                	cmp    %al,%dl
  8015d7:	74 cd                	je     8015a6 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8015d9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015de:	75 07                	jne    8015e7 <strncmp+0x57>
		return 0;
  8015e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8015e5:	eb 18                	jmp    8015ff <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8015e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015eb:	0f b6 00             	movzbl (%rax),%eax
  8015ee:	0f b6 d0             	movzbl %al,%edx
  8015f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015f5:	0f b6 00             	movzbl (%rax),%eax
  8015f8:	0f b6 c0             	movzbl %al,%eax
  8015fb:	29 c2                	sub    %eax,%edx
  8015fd:	89 d0                	mov    %edx,%eax
}
  8015ff:	c9                   	leaveq 
  801600:	c3                   	retq   

0000000000801601 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801601:	55                   	push   %rbp
  801602:	48 89 e5             	mov    %rsp,%rbp
  801605:	48 83 ec 0c          	sub    $0xc,%rsp
  801609:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80160d:	89 f0                	mov    %esi,%eax
  80160f:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801612:	eb 17                	jmp    80162b <strchr+0x2a>
		if (*s == c)
  801614:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801618:	0f b6 00             	movzbl (%rax),%eax
  80161b:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80161e:	75 06                	jne    801626 <strchr+0x25>
			return (char *) s;
  801620:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801624:	eb 15                	jmp    80163b <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801626:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80162b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80162f:	0f b6 00             	movzbl (%rax),%eax
  801632:	84 c0                	test   %al,%al
  801634:	75 de                	jne    801614 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801636:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80163b:	c9                   	leaveq 
  80163c:	c3                   	retq   

000000000080163d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80163d:	55                   	push   %rbp
  80163e:	48 89 e5             	mov    %rsp,%rbp
  801641:	48 83 ec 0c          	sub    $0xc,%rsp
  801645:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801649:	89 f0                	mov    %esi,%eax
  80164b:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80164e:	eb 13                	jmp    801663 <strfind+0x26>
		if (*s == c)
  801650:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801654:	0f b6 00             	movzbl (%rax),%eax
  801657:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80165a:	75 02                	jne    80165e <strfind+0x21>
			break;
  80165c:	eb 10                	jmp    80166e <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80165e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801663:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801667:	0f b6 00             	movzbl (%rax),%eax
  80166a:	84 c0                	test   %al,%al
  80166c:	75 e2                	jne    801650 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80166e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801672:	c9                   	leaveq 
  801673:	c3                   	retq   

0000000000801674 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801674:	55                   	push   %rbp
  801675:	48 89 e5             	mov    %rsp,%rbp
  801678:	48 83 ec 18          	sub    $0x18,%rsp
  80167c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801680:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801683:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801687:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80168c:	75 06                	jne    801694 <memset+0x20>
		return v;
  80168e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801692:	eb 69                	jmp    8016fd <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801694:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801698:	83 e0 03             	and    $0x3,%eax
  80169b:	48 85 c0             	test   %rax,%rax
  80169e:	75 48                	jne    8016e8 <memset+0x74>
  8016a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016a4:	83 e0 03             	and    $0x3,%eax
  8016a7:	48 85 c0             	test   %rax,%rax
  8016aa:	75 3c                	jne    8016e8 <memset+0x74>
		c &= 0xFF;
  8016ac:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8016b3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016b6:	c1 e0 18             	shl    $0x18,%eax
  8016b9:	89 c2                	mov    %eax,%edx
  8016bb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016be:	c1 e0 10             	shl    $0x10,%eax
  8016c1:	09 c2                	or     %eax,%edx
  8016c3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016c6:	c1 e0 08             	shl    $0x8,%eax
  8016c9:	09 d0                	or     %edx,%eax
  8016cb:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8016ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016d2:	48 c1 e8 02          	shr    $0x2,%rax
  8016d6:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8016d9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016dd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016e0:	48 89 d7             	mov    %rdx,%rdi
  8016e3:	fc                   	cld    
  8016e4:	f3 ab                	rep stos %eax,%es:(%rdi)
  8016e6:	eb 11                	jmp    8016f9 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8016e8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016ec:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016ef:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8016f3:	48 89 d7             	mov    %rdx,%rdi
  8016f6:	fc                   	cld    
  8016f7:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  8016f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8016fd:	c9                   	leaveq 
  8016fe:	c3                   	retq   

00000000008016ff <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8016ff:	55                   	push   %rbp
  801700:	48 89 e5             	mov    %rsp,%rbp
  801703:	48 83 ec 28          	sub    $0x28,%rsp
  801707:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80170b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80170f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801713:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801717:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80171b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80171f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801723:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801727:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80172b:	0f 83 88 00 00 00    	jae    8017b9 <memmove+0xba>
  801731:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801735:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801739:	48 01 d0             	add    %rdx,%rax
  80173c:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801740:	76 77                	jbe    8017b9 <memmove+0xba>
		s += n;
  801742:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801746:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80174a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80174e:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801752:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801756:	83 e0 03             	and    $0x3,%eax
  801759:	48 85 c0             	test   %rax,%rax
  80175c:	75 3b                	jne    801799 <memmove+0x9a>
  80175e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801762:	83 e0 03             	and    $0x3,%eax
  801765:	48 85 c0             	test   %rax,%rax
  801768:	75 2f                	jne    801799 <memmove+0x9a>
  80176a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80176e:	83 e0 03             	and    $0x3,%eax
  801771:	48 85 c0             	test   %rax,%rax
  801774:	75 23                	jne    801799 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801776:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80177a:	48 83 e8 04          	sub    $0x4,%rax
  80177e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801782:	48 83 ea 04          	sub    $0x4,%rdx
  801786:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80178a:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80178e:	48 89 c7             	mov    %rax,%rdi
  801791:	48 89 d6             	mov    %rdx,%rsi
  801794:	fd                   	std    
  801795:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801797:	eb 1d                	jmp    8017b6 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801799:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80179d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8017a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017a5:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8017a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ad:	48 89 d7             	mov    %rdx,%rdi
  8017b0:	48 89 c1             	mov    %rax,%rcx
  8017b3:	fd                   	std    
  8017b4:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8017b6:	fc                   	cld    
  8017b7:	eb 57                	jmp    801810 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8017b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017bd:	83 e0 03             	and    $0x3,%eax
  8017c0:	48 85 c0             	test   %rax,%rax
  8017c3:	75 36                	jne    8017fb <memmove+0xfc>
  8017c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017c9:	83 e0 03             	and    $0x3,%eax
  8017cc:	48 85 c0             	test   %rax,%rax
  8017cf:	75 2a                	jne    8017fb <memmove+0xfc>
  8017d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d5:	83 e0 03             	and    $0x3,%eax
  8017d8:	48 85 c0             	test   %rax,%rax
  8017db:	75 1e                	jne    8017fb <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8017dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e1:	48 c1 e8 02          	shr    $0x2,%rax
  8017e5:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8017e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017ec:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017f0:	48 89 c7             	mov    %rax,%rdi
  8017f3:	48 89 d6             	mov    %rdx,%rsi
  8017f6:	fc                   	cld    
  8017f7:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8017f9:	eb 15                	jmp    801810 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8017fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017ff:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801803:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801807:	48 89 c7             	mov    %rax,%rdi
  80180a:	48 89 d6             	mov    %rdx,%rsi
  80180d:	fc                   	cld    
  80180e:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801810:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801814:	c9                   	leaveq 
  801815:	c3                   	retq   

0000000000801816 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801816:	55                   	push   %rbp
  801817:	48 89 e5             	mov    %rsp,%rbp
  80181a:	48 83 ec 18          	sub    $0x18,%rsp
  80181e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801822:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801826:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80182a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80182e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801832:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801836:	48 89 ce             	mov    %rcx,%rsi
  801839:	48 89 c7             	mov    %rax,%rdi
  80183c:	48 b8 ff 16 80 00 00 	movabs $0x8016ff,%rax
  801843:	00 00 00 
  801846:	ff d0                	callq  *%rax
}
  801848:	c9                   	leaveq 
  801849:	c3                   	retq   

000000000080184a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80184a:	55                   	push   %rbp
  80184b:	48 89 e5             	mov    %rsp,%rbp
  80184e:	48 83 ec 28          	sub    $0x28,%rsp
  801852:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801856:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80185a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80185e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801862:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801866:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80186a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80186e:	eb 36                	jmp    8018a6 <memcmp+0x5c>
		if (*s1 != *s2)
  801870:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801874:	0f b6 10             	movzbl (%rax),%edx
  801877:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80187b:	0f b6 00             	movzbl (%rax),%eax
  80187e:	38 c2                	cmp    %al,%dl
  801880:	74 1a                	je     80189c <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801882:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801886:	0f b6 00             	movzbl (%rax),%eax
  801889:	0f b6 d0             	movzbl %al,%edx
  80188c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801890:	0f b6 00             	movzbl (%rax),%eax
  801893:	0f b6 c0             	movzbl %al,%eax
  801896:	29 c2                	sub    %eax,%edx
  801898:	89 d0                	mov    %edx,%eax
  80189a:	eb 20                	jmp    8018bc <memcmp+0x72>
		s1++, s2++;
  80189c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8018a1:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8018a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018aa:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8018ae:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8018b2:	48 85 c0             	test   %rax,%rax
  8018b5:	75 b9                	jne    801870 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8018b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018bc:	c9                   	leaveq 
  8018bd:	c3                   	retq   

00000000008018be <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8018be:	55                   	push   %rbp
  8018bf:	48 89 e5             	mov    %rsp,%rbp
  8018c2:	48 83 ec 28          	sub    $0x28,%rsp
  8018c6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018ca:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8018cd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8018d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018d5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018d9:	48 01 d0             	add    %rdx,%rax
  8018dc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8018e0:	eb 15                	jmp    8018f7 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8018e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018e6:	0f b6 10             	movzbl (%rax),%edx
  8018e9:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8018ec:	38 c2                	cmp    %al,%dl
  8018ee:	75 02                	jne    8018f2 <memfind+0x34>
			break;
  8018f0:	eb 0f                	jmp    801901 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8018f2:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8018f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018fb:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8018ff:	72 e1                	jb     8018e2 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801901:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801905:	c9                   	leaveq 
  801906:	c3                   	retq   

0000000000801907 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801907:	55                   	push   %rbp
  801908:	48 89 e5             	mov    %rsp,%rbp
  80190b:	48 83 ec 34          	sub    $0x34,%rsp
  80190f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801913:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801917:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80191a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801921:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801928:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801929:	eb 05                	jmp    801930 <strtol+0x29>
		s++;
  80192b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801930:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801934:	0f b6 00             	movzbl (%rax),%eax
  801937:	3c 20                	cmp    $0x20,%al
  801939:	74 f0                	je     80192b <strtol+0x24>
  80193b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80193f:	0f b6 00             	movzbl (%rax),%eax
  801942:	3c 09                	cmp    $0x9,%al
  801944:	74 e5                	je     80192b <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801946:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80194a:	0f b6 00             	movzbl (%rax),%eax
  80194d:	3c 2b                	cmp    $0x2b,%al
  80194f:	75 07                	jne    801958 <strtol+0x51>
		s++;
  801951:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801956:	eb 17                	jmp    80196f <strtol+0x68>
	else if (*s == '-')
  801958:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80195c:	0f b6 00             	movzbl (%rax),%eax
  80195f:	3c 2d                	cmp    $0x2d,%al
  801961:	75 0c                	jne    80196f <strtol+0x68>
		s++, neg = 1;
  801963:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801968:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80196f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801973:	74 06                	je     80197b <strtol+0x74>
  801975:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801979:	75 28                	jne    8019a3 <strtol+0x9c>
  80197b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80197f:	0f b6 00             	movzbl (%rax),%eax
  801982:	3c 30                	cmp    $0x30,%al
  801984:	75 1d                	jne    8019a3 <strtol+0x9c>
  801986:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80198a:	48 83 c0 01          	add    $0x1,%rax
  80198e:	0f b6 00             	movzbl (%rax),%eax
  801991:	3c 78                	cmp    $0x78,%al
  801993:	75 0e                	jne    8019a3 <strtol+0x9c>
		s += 2, base = 16;
  801995:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80199a:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8019a1:	eb 2c                	jmp    8019cf <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8019a3:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019a7:	75 19                	jne    8019c2 <strtol+0xbb>
  8019a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019ad:	0f b6 00             	movzbl (%rax),%eax
  8019b0:	3c 30                	cmp    $0x30,%al
  8019b2:	75 0e                	jne    8019c2 <strtol+0xbb>
		s++, base = 8;
  8019b4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019b9:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8019c0:	eb 0d                	jmp    8019cf <strtol+0xc8>
	else if (base == 0)
  8019c2:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019c6:	75 07                	jne    8019cf <strtol+0xc8>
		base = 10;
  8019c8:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8019cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019d3:	0f b6 00             	movzbl (%rax),%eax
  8019d6:	3c 2f                	cmp    $0x2f,%al
  8019d8:	7e 1d                	jle    8019f7 <strtol+0xf0>
  8019da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019de:	0f b6 00             	movzbl (%rax),%eax
  8019e1:	3c 39                	cmp    $0x39,%al
  8019e3:	7f 12                	jg     8019f7 <strtol+0xf0>
			dig = *s - '0';
  8019e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019e9:	0f b6 00             	movzbl (%rax),%eax
  8019ec:	0f be c0             	movsbl %al,%eax
  8019ef:	83 e8 30             	sub    $0x30,%eax
  8019f2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8019f5:	eb 4e                	jmp    801a45 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8019f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019fb:	0f b6 00             	movzbl (%rax),%eax
  8019fe:	3c 60                	cmp    $0x60,%al
  801a00:	7e 1d                	jle    801a1f <strtol+0x118>
  801a02:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a06:	0f b6 00             	movzbl (%rax),%eax
  801a09:	3c 7a                	cmp    $0x7a,%al
  801a0b:	7f 12                	jg     801a1f <strtol+0x118>
			dig = *s - 'a' + 10;
  801a0d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a11:	0f b6 00             	movzbl (%rax),%eax
  801a14:	0f be c0             	movsbl %al,%eax
  801a17:	83 e8 57             	sub    $0x57,%eax
  801a1a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801a1d:	eb 26                	jmp    801a45 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801a1f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a23:	0f b6 00             	movzbl (%rax),%eax
  801a26:	3c 40                	cmp    $0x40,%al
  801a28:	7e 48                	jle    801a72 <strtol+0x16b>
  801a2a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a2e:	0f b6 00             	movzbl (%rax),%eax
  801a31:	3c 5a                	cmp    $0x5a,%al
  801a33:	7f 3d                	jg     801a72 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801a35:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a39:	0f b6 00             	movzbl (%rax),%eax
  801a3c:	0f be c0             	movsbl %al,%eax
  801a3f:	83 e8 37             	sub    $0x37,%eax
  801a42:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801a45:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a48:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801a4b:	7c 02                	jl     801a4f <strtol+0x148>
			break;
  801a4d:	eb 23                	jmp    801a72 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801a4f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a54:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801a57:	48 98                	cltq   
  801a59:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801a5e:	48 89 c2             	mov    %rax,%rdx
  801a61:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a64:	48 98                	cltq   
  801a66:	48 01 d0             	add    %rdx,%rax
  801a69:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801a6d:	e9 5d ff ff ff       	jmpq   8019cf <strtol+0xc8>

	if (endptr)
  801a72:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801a77:	74 0b                	je     801a84 <strtol+0x17d>
		*endptr = (char *) s;
  801a79:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a7d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801a81:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801a84:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a88:	74 09                	je     801a93 <strtol+0x18c>
  801a8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a8e:	48 f7 d8             	neg    %rax
  801a91:	eb 04                	jmp    801a97 <strtol+0x190>
  801a93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801a97:	c9                   	leaveq 
  801a98:	c3                   	retq   

0000000000801a99 <strstr>:

char * strstr(const char *in, const char *str)
{
  801a99:	55                   	push   %rbp
  801a9a:	48 89 e5             	mov    %rsp,%rbp
  801a9d:	48 83 ec 30          	sub    $0x30,%rsp
  801aa1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801aa5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801aa9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801aad:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801ab1:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801ab5:	0f b6 00             	movzbl (%rax),%eax
  801ab8:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  801abb:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801abf:	75 06                	jne    801ac7 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  801ac1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ac5:	eb 6b                	jmp    801b32 <strstr+0x99>

    len = strlen(str);
  801ac7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801acb:	48 89 c7             	mov    %rax,%rdi
  801ace:	48 b8 6f 13 80 00 00 	movabs $0x80136f,%rax
  801ad5:	00 00 00 
  801ad8:	ff d0                	callq  *%rax
  801ada:	48 98                	cltq   
  801adc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801ae0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ae4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801ae8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801aec:	0f b6 00             	movzbl (%rax),%eax
  801aef:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  801af2:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801af6:	75 07                	jne    801aff <strstr+0x66>
                return (char *) 0;
  801af8:	b8 00 00 00 00       	mov    $0x0,%eax
  801afd:	eb 33                	jmp    801b32 <strstr+0x99>
        } while (sc != c);
  801aff:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801b03:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801b06:	75 d8                	jne    801ae0 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  801b08:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b0c:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801b10:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b14:	48 89 ce             	mov    %rcx,%rsi
  801b17:	48 89 c7             	mov    %rax,%rdi
  801b1a:	48 b8 90 15 80 00 00 	movabs $0x801590,%rax
  801b21:	00 00 00 
  801b24:	ff d0                	callq  *%rax
  801b26:	85 c0                	test   %eax,%eax
  801b28:	75 b6                	jne    801ae0 <strstr+0x47>

    return (char *) (in - 1);
  801b2a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b2e:	48 83 e8 01          	sub    $0x1,%rax
}
  801b32:	c9                   	leaveq 
  801b33:	c3                   	retq   

0000000000801b34 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801b34:	55                   	push   %rbp
  801b35:	48 89 e5             	mov    %rsp,%rbp
  801b38:	53                   	push   %rbx
  801b39:	48 83 ec 48          	sub    $0x48,%rsp
  801b3d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801b40:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801b43:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801b47:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801b4b:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801b4f:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b53:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801b56:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801b5a:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801b5e:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801b62:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801b66:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801b6a:	4c 89 c3             	mov    %r8,%rbx
  801b6d:	cd 30                	int    $0x30
  801b6f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801b73:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801b77:	74 3e                	je     801bb7 <syscall+0x83>
  801b79:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801b7e:	7e 37                	jle    801bb7 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801b80:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801b84:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801b87:	49 89 d0             	mov    %rdx,%r8
  801b8a:	89 c1                	mov    %eax,%ecx
  801b8c:	48 ba 40 47 80 00 00 	movabs $0x804740,%rdx
  801b93:	00 00 00 
  801b96:	be 23 00 00 00       	mov    $0x23,%esi
  801b9b:	48 bf 5d 47 80 00 00 	movabs $0x80475d,%rdi
  801ba2:	00 00 00 
  801ba5:	b8 00 00 00 00       	mov    $0x0,%eax
  801baa:	49 b9 ed 05 80 00 00 	movabs $0x8005ed,%r9
  801bb1:	00 00 00 
  801bb4:	41 ff d1             	callq  *%r9

	return ret;
  801bb7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801bbb:	48 83 c4 48          	add    $0x48,%rsp
  801bbf:	5b                   	pop    %rbx
  801bc0:	5d                   	pop    %rbp
  801bc1:	c3                   	retq   

0000000000801bc2 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801bc2:	55                   	push   %rbp
  801bc3:	48 89 e5             	mov    %rsp,%rbp
  801bc6:	48 83 ec 20          	sub    $0x20,%rsp
  801bca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801bce:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801bd2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bd6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bda:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801be1:	00 
  801be2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801be8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bee:	48 89 d1             	mov    %rdx,%rcx
  801bf1:	48 89 c2             	mov    %rax,%rdx
  801bf4:	be 00 00 00 00       	mov    $0x0,%esi
  801bf9:	bf 00 00 00 00       	mov    $0x0,%edi
  801bfe:	48 b8 34 1b 80 00 00 	movabs $0x801b34,%rax
  801c05:	00 00 00 
  801c08:	ff d0                	callq  *%rax
}
  801c0a:	c9                   	leaveq 
  801c0b:	c3                   	retq   

0000000000801c0c <sys_cgetc>:

int
sys_cgetc(void)
{
  801c0c:	55                   	push   %rbp
  801c0d:	48 89 e5             	mov    %rsp,%rbp
  801c10:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801c14:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c1b:	00 
  801c1c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c22:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c28:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c2d:	ba 00 00 00 00       	mov    $0x0,%edx
  801c32:	be 00 00 00 00       	mov    $0x0,%esi
  801c37:	bf 01 00 00 00       	mov    $0x1,%edi
  801c3c:	48 b8 34 1b 80 00 00 	movabs $0x801b34,%rax
  801c43:	00 00 00 
  801c46:	ff d0                	callq  *%rax
}
  801c48:	c9                   	leaveq 
  801c49:	c3                   	retq   

0000000000801c4a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801c4a:	55                   	push   %rbp
  801c4b:	48 89 e5             	mov    %rsp,%rbp
  801c4e:	48 83 ec 10          	sub    $0x10,%rsp
  801c52:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801c55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c58:	48 98                	cltq   
  801c5a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c61:	00 
  801c62:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c68:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c6e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c73:	48 89 c2             	mov    %rax,%rdx
  801c76:	be 01 00 00 00       	mov    $0x1,%esi
  801c7b:	bf 03 00 00 00       	mov    $0x3,%edi
  801c80:	48 b8 34 1b 80 00 00 	movabs $0x801b34,%rax
  801c87:	00 00 00 
  801c8a:	ff d0                	callq  *%rax
}
  801c8c:	c9                   	leaveq 
  801c8d:	c3                   	retq   

0000000000801c8e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801c8e:	55                   	push   %rbp
  801c8f:	48 89 e5             	mov    %rsp,%rbp
  801c92:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801c96:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c9d:	00 
  801c9e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ca4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801caa:	b9 00 00 00 00       	mov    $0x0,%ecx
  801caf:	ba 00 00 00 00       	mov    $0x0,%edx
  801cb4:	be 00 00 00 00       	mov    $0x0,%esi
  801cb9:	bf 02 00 00 00       	mov    $0x2,%edi
  801cbe:	48 b8 34 1b 80 00 00 	movabs $0x801b34,%rax
  801cc5:	00 00 00 
  801cc8:	ff d0                	callq  *%rax
}
  801cca:	c9                   	leaveq 
  801ccb:	c3                   	retq   

0000000000801ccc <sys_yield>:

void
sys_yield(void)
{
  801ccc:	55                   	push   %rbp
  801ccd:	48 89 e5             	mov    %rsp,%rbp
  801cd0:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801cd4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cdb:	00 
  801cdc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ce2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ce8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ced:	ba 00 00 00 00       	mov    $0x0,%edx
  801cf2:	be 00 00 00 00       	mov    $0x0,%esi
  801cf7:	bf 0b 00 00 00       	mov    $0xb,%edi
  801cfc:	48 b8 34 1b 80 00 00 	movabs $0x801b34,%rax
  801d03:	00 00 00 
  801d06:	ff d0                	callq  *%rax
}
  801d08:	c9                   	leaveq 
  801d09:	c3                   	retq   

0000000000801d0a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801d0a:	55                   	push   %rbp
  801d0b:	48 89 e5             	mov    %rsp,%rbp
  801d0e:	48 83 ec 20          	sub    $0x20,%rsp
  801d12:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d15:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d19:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801d1c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d1f:	48 63 c8             	movslq %eax,%rcx
  801d22:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d29:	48 98                	cltq   
  801d2b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d32:	00 
  801d33:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d39:	49 89 c8             	mov    %rcx,%r8
  801d3c:	48 89 d1             	mov    %rdx,%rcx
  801d3f:	48 89 c2             	mov    %rax,%rdx
  801d42:	be 01 00 00 00       	mov    $0x1,%esi
  801d47:	bf 04 00 00 00       	mov    $0x4,%edi
  801d4c:	48 b8 34 1b 80 00 00 	movabs $0x801b34,%rax
  801d53:	00 00 00 
  801d56:	ff d0                	callq  *%rax
}
  801d58:	c9                   	leaveq 
  801d59:	c3                   	retq   

0000000000801d5a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801d5a:	55                   	push   %rbp
  801d5b:	48 89 e5             	mov    %rsp,%rbp
  801d5e:	48 83 ec 30          	sub    $0x30,%rsp
  801d62:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d65:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d69:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801d6c:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d70:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801d74:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801d77:	48 63 c8             	movslq %eax,%rcx
  801d7a:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d7e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d81:	48 63 f0             	movslq %eax,%rsi
  801d84:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d88:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d8b:	48 98                	cltq   
  801d8d:	48 89 0c 24          	mov    %rcx,(%rsp)
  801d91:	49 89 f9             	mov    %rdi,%r9
  801d94:	49 89 f0             	mov    %rsi,%r8
  801d97:	48 89 d1             	mov    %rdx,%rcx
  801d9a:	48 89 c2             	mov    %rax,%rdx
  801d9d:	be 01 00 00 00       	mov    $0x1,%esi
  801da2:	bf 05 00 00 00       	mov    $0x5,%edi
  801da7:	48 b8 34 1b 80 00 00 	movabs $0x801b34,%rax
  801dae:	00 00 00 
  801db1:	ff d0                	callq  *%rax
}
  801db3:	c9                   	leaveq 
  801db4:	c3                   	retq   

0000000000801db5 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801db5:	55                   	push   %rbp
  801db6:	48 89 e5             	mov    %rsp,%rbp
  801db9:	48 83 ec 20          	sub    $0x20,%rsp
  801dbd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801dc0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801dc4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dcb:	48 98                	cltq   
  801dcd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dd4:	00 
  801dd5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ddb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801de1:	48 89 d1             	mov    %rdx,%rcx
  801de4:	48 89 c2             	mov    %rax,%rdx
  801de7:	be 01 00 00 00       	mov    $0x1,%esi
  801dec:	bf 06 00 00 00       	mov    $0x6,%edi
  801df1:	48 b8 34 1b 80 00 00 	movabs $0x801b34,%rax
  801df8:	00 00 00 
  801dfb:	ff d0                	callq  *%rax
}
  801dfd:	c9                   	leaveq 
  801dfe:	c3                   	retq   

0000000000801dff <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801dff:	55                   	push   %rbp
  801e00:	48 89 e5             	mov    %rsp,%rbp
  801e03:	48 83 ec 10          	sub    $0x10,%rsp
  801e07:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e0a:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801e0d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e10:	48 63 d0             	movslq %eax,%rdx
  801e13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e16:	48 98                	cltq   
  801e18:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e1f:	00 
  801e20:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e26:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e2c:	48 89 d1             	mov    %rdx,%rcx
  801e2f:	48 89 c2             	mov    %rax,%rdx
  801e32:	be 01 00 00 00       	mov    $0x1,%esi
  801e37:	bf 08 00 00 00       	mov    $0x8,%edi
  801e3c:	48 b8 34 1b 80 00 00 	movabs $0x801b34,%rax
  801e43:	00 00 00 
  801e46:	ff d0                	callq  *%rax
}
  801e48:	c9                   	leaveq 
  801e49:	c3                   	retq   

0000000000801e4a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801e4a:	55                   	push   %rbp
  801e4b:	48 89 e5             	mov    %rsp,%rbp
  801e4e:	48 83 ec 20          	sub    $0x20,%rsp
  801e52:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e55:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801e59:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e60:	48 98                	cltq   
  801e62:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e69:	00 
  801e6a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e70:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e76:	48 89 d1             	mov    %rdx,%rcx
  801e79:	48 89 c2             	mov    %rax,%rdx
  801e7c:	be 01 00 00 00       	mov    $0x1,%esi
  801e81:	bf 09 00 00 00       	mov    $0x9,%edi
  801e86:	48 b8 34 1b 80 00 00 	movabs $0x801b34,%rax
  801e8d:	00 00 00 
  801e90:	ff d0                	callq  *%rax
}
  801e92:	c9                   	leaveq 
  801e93:	c3                   	retq   

0000000000801e94 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801e94:	55                   	push   %rbp
  801e95:	48 89 e5             	mov    %rsp,%rbp
  801e98:	48 83 ec 20          	sub    $0x20,%rsp
  801e9c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e9f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801ea3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ea7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801eaa:	48 98                	cltq   
  801eac:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801eb3:	00 
  801eb4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801eba:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ec0:	48 89 d1             	mov    %rdx,%rcx
  801ec3:	48 89 c2             	mov    %rax,%rdx
  801ec6:	be 01 00 00 00       	mov    $0x1,%esi
  801ecb:	bf 0a 00 00 00       	mov    $0xa,%edi
  801ed0:	48 b8 34 1b 80 00 00 	movabs $0x801b34,%rax
  801ed7:	00 00 00 
  801eda:	ff d0                	callq  *%rax
}
  801edc:	c9                   	leaveq 
  801edd:	c3                   	retq   

0000000000801ede <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801ede:	55                   	push   %rbp
  801edf:	48 89 e5             	mov    %rsp,%rbp
  801ee2:	48 83 ec 20          	sub    $0x20,%rsp
  801ee6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ee9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801eed:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801ef1:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801ef4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ef7:	48 63 f0             	movslq %eax,%rsi
  801efa:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801efe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f01:	48 98                	cltq   
  801f03:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f07:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f0e:	00 
  801f0f:	49 89 f1             	mov    %rsi,%r9
  801f12:	49 89 c8             	mov    %rcx,%r8
  801f15:	48 89 d1             	mov    %rdx,%rcx
  801f18:	48 89 c2             	mov    %rax,%rdx
  801f1b:	be 00 00 00 00       	mov    $0x0,%esi
  801f20:	bf 0c 00 00 00       	mov    $0xc,%edi
  801f25:	48 b8 34 1b 80 00 00 	movabs $0x801b34,%rax
  801f2c:	00 00 00 
  801f2f:	ff d0                	callq  *%rax
}
  801f31:	c9                   	leaveq 
  801f32:	c3                   	retq   

0000000000801f33 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801f33:	55                   	push   %rbp
  801f34:	48 89 e5             	mov    %rsp,%rbp
  801f37:	48 83 ec 10          	sub    $0x10,%rsp
  801f3b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801f3f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f43:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f4a:	00 
  801f4b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f51:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f57:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f5c:	48 89 c2             	mov    %rax,%rdx
  801f5f:	be 01 00 00 00       	mov    $0x1,%esi
  801f64:	bf 0d 00 00 00       	mov    $0xd,%edi
  801f69:	48 b8 34 1b 80 00 00 	movabs $0x801b34,%rax
  801f70:	00 00 00 
  801f73:	ff d0                	callq  *%rax
}
  801f75:	c9                   	leaveq 
  801f76:	c3                   	retq   

0000000000801f77 <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  801f77:	55                   	push   %rbp
  801f78:	48 89 e5             	mov    %rsp,%rbp
  801f7b:	48 83 ec 30          	sub    $0x30,%rsp
  801f7f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801f83:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f87:	48 8b 00             	mov    (%rax),%rax
  801f8a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801f8e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f92:	48 8b 40 08          	mov    0x8(%rax),%rax
  801f96:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801f99:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f9c:	83 e0 02             	and    $0x2,%eax
  801f9f:	85 c0                	test   %eax,%eax
  801fa1:	75 4d                	jne    801ff0 <pgfault+0x79>
  801fa3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fa7:	48 c1 e8 0c          	shr    $0xc,%rax
  801fab:	48 89 c2             	mov    %rax,%rdx
  801fae:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fb5:	01 00 00 
  801fb8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fbc:	25 00 08 00 00       	and    $0x800,%eax
  801fc1:	48 85 c0             	test   %rax,%rax
  801fc4:	74 2a                	je     801ff0 <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  801fc6:	48 ba 70 47 80 00 00 	movabs $0x804770,%rdx
  801fcd:	00 00 00 
  801fd0:	be 23 00 00 00       	mov    $0x23,%esi
  801fd5:	48 bf a5 47 80 00 00 	movabs $0x8047a5,%rdi
  801fdc:	00 00 00 
  801fdf:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe4:	48 b9 ed 05 80 00 00 	movabs $0x8005ed,%rcx
  801feb:	00 00 00 
  801fee:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  801ff0:	ba 07 00 00 00       	mov    $0x7,%edx
  801ff5:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801ffa:	bf 00 00 00 00       	mov    $0x0,%edi
  801fff:	48 b8 0a 1d 80 00 00 	movabs $0x801d0a,%rax
  802006:	00 00 00 
  802009:	ff d0                	callq  *%rax
  80200b:	85 c0                	test   %eax,%eax
  80200d:	0f 85 cd 00 00 00    	jne    8020e0 <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  802013:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802017:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80201b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80201f:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802025:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  802029:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80202d:	ba 00 10 00 00       	mov    $0x1000,%edx
  802032:	48 89 c6             	mov    %rax,%rsi
  802035:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  80203a:	48 b8 ff 16 80 00 00 	movabs $0x8016ff,%rax
  802041:	00 00 00 
  802044:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  802046:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80204a:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802050:	48 89 c1             	mov    %rax,%rcx
  802053:	ba 00 00 00 00       	mov    $0x0,%edx
  802058:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80205d:	bf 00 00 00 00       	mov    $0x0,%edi
  802062:	48 b8 5a 1d 80 00 00 	movabs $0x801d5a,%rax
  802069:	00 00 00 
  80206c:	ff d0                	callq  *%rax
  80206e:	85 c0                	test   %eax,%eax
  802070:	79 2a                	jns    80209c <pgfault+0x125>
				panic("Page map at temp address failed");
  802072:	48 ba b0 47 80 00 00 	movabs $0x8047b0,%rdx
  802079:	00 00 00 
  80207c:	be 30 00 00 00       	mov    $0x30,%esi
  802081:	48 bf a5 47 80 00 00 	movabs $0x8047a5,%rdi
  802088:	00 00 00 
  80208b:	b8 00 00 00 00       	mov    $0x0,%eax
  802090:	48 b9 ed 05 80 00 00 	movabs $0x8005ed,%rcx
  802097:	00 00 00 
  80209a:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  80209c:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8020a1:	bf 00 00 00 00       	mov    $0x0,%edi
  8020a6:	48 b8 b5 1d 80 00 00 	movabs $0x801db5,%rax
  8020ad:	00 00 00 
  8020b0:	ff d0                	callq  *%rax
  8020b2:	85 c0                	test   %eax,%eax
  8020b4:	79 54                	jns    80210a <pgfault+0x193>
				panic("Page unmap from temp location failed");
  8020b6:	48 ba d0 47 80 00 00 	movabs $0x8047d0,%rdx
  8020bd:	00 00 00 
  8020c0:	be 32 00 00 00       	mov    $0x32,%esi
  8020c5:	48 bf a5 47 80 00 00 	movabs $0x8047a5,%rdi
  8020cc:	00 00 00 
  8020cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d4:	48 b9 ed 05 80 00 00 	movabs $0x8005ed,%rcx
  8020db:	00 00 00 
  8020de:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  8020e0:	48 ba f8 47 80 00 00 	movabs $0x8047f8,%rdx
  8020e7:	00 00 00 
  8020ea:	be 34 00 00 00       	mov    $0x34,%esi
  8020ef:	48 bf a5 47 80 00 00 	movabs $0x8047a5,%rdi
  8020f6:	00 00 00 
  8020f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020fe:	48 b9 ed 05 80 00 00 	movabs $0x8005ed,%rcx
  802105:	00 00 00 
  802108:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  80210a:	c9                   	leaveq 
  80210b:	c3                   	retq   

000000000080210c <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80210c:	55                   	push   %rbp
  80210d:	48 89 e5             	mov    %rsp,%rbp
  802110:	48 83 ec 20          	sub    $0x20,%rsp
  802114:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802117:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  80211a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802121:	01 00 00 
  802124:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802127:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80212b:	25 07 0e 00 00       	and    $0xe07,%eax
  802130:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  802133:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802136:	48 c1 e0 0c          	shl    $0xc,%rax
  80213a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  80213e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802141:	25 00 04 00 00       	and    $0x400,%eax
  802146:	85 c0                	test   %eax,%eax
  802148:	74 57                	je     8021a1 <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  80214a:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80214d:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802151:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802154:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802158:	41 89 f0             	mov    %esi,%r8d
  80215b:	48 89 c6             	mov    %rax,%rsi
  80215e:	bf 00 00 00 00       	mov    $0x0,%edi
  802163:	48 b8 5a 1d 80 00 00 	movabs $0x801d5a,%rax
  80216a:	00 00 00 
  80216d:	ff d0                	callq  *%rax
  80216f:	85 c0                	test   %eax,%eax
  802171:	0f 8e 52 01 00 00    	jle    8022c9 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  802177:	48 ba 2a 48 80 00 00 	movabs $0x80482a,%rdx
  80217e:	00 00 00 
  802181:	be 4e 00 00 00       	mov    $0x4e,%esi
  802186:	48 bf a5 47 80 00 00 	movabs $0x8047a5,%rdi
  80218d:	00 00 00 
  802190:	b8 00 00 00 00       	mov    $0x0,%eax
  802195:	48 b9 ed 05 80 00 00 	movabs $0x8005ed,%rcx
  80219c:	00 00 00 
  80219f:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  8021a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021a4:	83 e0 02             	and    $0x2,%eax
  8021a7:	85 c0                	test   %eax,%eax
  8021a9:	75 10                	jne    8021bb <duppage+0xaf>
  8021ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021ae:	25 00 08 00 00       	and    $0x800,%eax
  8021b3:	85 c0                	test   %eax,%eax
  8021b5:	0f 84 bb 00 00 00    	je     802276 <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  8021bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021be:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  8021c3:	80 cc 08             	or     $0x8,%ah
  8021c6:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  8021c9:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8021cc:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8021d0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8021d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021d7:	41 89 f0             	mov    %esi,%r8d
  8021da:	48 89 c6             	mov    %rax,%rsi
  8021dd:	bf 00 00 00 00       	mov    $0x0,%edi
  8021e2:	48 b8 5a 1d 80 00 00 	movabs $0x801d5a,%rax
  8021e9:	00 00 00 
  8021ec:	ff d0                	callq  *%rax
  8021ee:	85 c0                	test   %eax,%eax
  8021f0:	7e 2a                	jle    80221c <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  8021f2:	48 ba 2a 48 80 00 00 	movabs $0x80482a,%rdx
  8021f9:	00 00 00 
  8021fc:	be 55 00 00 00       	mov    $0x55,%esi
  802201:	48 bf a5 47 80 00 00 	movabs $0x8047a5,%rdi
  802208:	00 00 00 
  80220b:	b8 00 00 00 00       	mov    $0x0,%eax
  802210:	48 b9 ed 05 80 00 00 	movabs $0x8005ed,%rcx
  802217:	00 00 00 
  80221a:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  80221c:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  80221f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802223:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802227:	41 89 c8             	mov    %ecx,%r8d
  80222a:	48 89 d1             	mov    %rdx,%rcx
  80222d:	ba 00 00 00 00       	mov    $0x0,%edx
  802232:	48 89 c6             	mov    %rax,%rsi
  802235:	bf 00 00 00 00       	mov    $0x0,%edi
  80223a:	48 b8 5a 1d 80 00 00 	movabs $0x801d5a,%rax
  802241:	00 00 00 
  802244:	ff d0                	callq  *%rax
  802246:	85 c0                	test   %eax,%eax
  802248:	7e 2a                	jle    802274 <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  80224a:	48 ba 2a 48 80 00 00 	movabs $0x80482a,%rdx
  802251:	00 00 00 
  802254:	be 57 00 00 00       	mov    $0x57,%esi
  802259:	48 bf a5 47 80 00 00 	movabs $0x8047a5,%rdi
  802260:	00 00 00 
  802263:	b8 00 00 00 00       	mov    $0x0,%eax
  802268:	48 b9 ed 05 80 00 00 	movabs $0x8005ed,%rcx
  80226f:	00 00 00 
  802272:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  802274:	eb 53                	jmp    8022c9 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  802276:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802279:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80227d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802280:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802284:	41 89 f0             	mov    %esi,%r8d
  802287:	48 89 c6             	mov    %rax,%rsi
  80228a:	bf 00 00 00 00       	mov    $0x0,%edi
  80228f:	48 b8 5a 1d 80 00 00 	movabs $0x801d5a,%rax
  802296:	00 00 00 
  802299:	ff d0                	callq  *%rax
  80229b:	85 c0                	test   %eax,%eax
  80229d:	7e 2a                	jle    8022c9 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  80229f:	48 ba 2a 48 80 00 00 	movabs $0x80482a,%rdx
  8022a6:	00 00 00 
  8022a9:	be 5b 00 00 00       	mov    $0x5b,%esi
  8022ae:	48 bf a5 47 80 00 00 	movabs $0x8047a5,%rdi
  8022b5:	00 00 00 
  8022b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8022bd:	48 b9 ed 05 80 00 00 	movabs $0x8005ed,%rcx
  8022c4:	00 00 00 
  8022c7:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  8022c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022ce:	c9                   	leaveq 
  8022cf:	c3                   	retq   

00000000008022d0 <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  8022d0:	55                   	push   %rbp
  8022d1:	48 89 e5             	mov    %rsp,%rbp
  8022d4:	48 83 ec 18          	sub    $0x18,%rsp
  8022d8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  8022dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022e0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  8022e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022e8:	48 c1 e8 27          	shr    $0x27,%rax
  8022ec:	48 89 c2             	mov    %rax,%rdx
  8022ef:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8022f6:	01 00 00 
  8022f9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022fd:	83 e0 01             	and    $0x1,%eax
  802300:	48 85 c0             	test   %rax,%rax
  802303:	74 51                	je     802356 <pt_is_mapped+0x86>
  802305:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802309:	48 c1 e0 0c          	shl    $0xc,%rax
  80230d:	48 c1 e8 1e          	shr    $0x1e,%rax
  802311:	48 89 c2             	mov    %rax,%rdx
  802314:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80231b:	01 00 00 
  80231e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802322:	83 e0 01             	and    $0x1,%eax
  802325:	48 85 c0             	test   %rax,%rax
  802328:	74 2c                	je     802356 <pt_is_mapped+0x86>
  80232a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80232e:	48 c1 e0 0c          	shl    $0xc,%rax
  802332:	48 c1 e8 15          	shr    $0x15,%rax
  802336:	48 89 c2             	mov    %rax,%rdx
  802339:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802340:	01 00 00 
  802343:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802347:	83 e0 01             	and    $0x1,%eax
  80234a:	48 85 c0             	test   %rax,%rax
  80234d:	74 07                	je     802356 <pt_is_mapped+0x86>
  80234f:	b8 01 00 00 00       	mov    $0x1,%eax
  802354:	eb 05                	jmp    80235b <pt_is_mapped+0x8b>
  802356:	b8 00 00 00 00       	mov    $0x0,%eax
  80235b:	83 e0 01             	and    $0x1,%eax
}
  80235e:	c9                   	leaveq 
  80235f:	c3                   	retq   

0000000000802360 <fork>:

envid_t
fork(void)
{
  802360:	55                   	push   %rbp
  802361:	48 89 e5             	mov    %rsp,%rbp
  802364:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  802368:	48 bf 77 1f 80 00 00 	movabs $0x801f77,%rdi
  80236f:	00 00 00 
  802372:	48 b8 53 3d 80 00 00 	movabs $0x803d53,%rax
  802379:	00 00 00 
  80237c:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80237e:	b8 07 00 00 00       	mov    $0x7,%eax
  802383:	cd 30                	int    $0x30
  802385:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802388:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  80238b:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  80238e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802392:	79 30                	jns    8023c4 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  802394:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802397:	89 c1                	mov    %eax,%ecx
  802399:	48 ba 48 48 80 00 00 	movabs $0x804848,%rdx
  8023a0:	00 00 00 
  8023a3:	be 86 00 00 00       	mov    $0x86,%esi
  8023a8:	48 bf a5 47 80 00 00 	movabs $0x8047a5,%rdi
  8023af:	00 00 00 
  8023b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b7:	49 b8 ed 05 80 00 00 	movabs $0x8005ed,%r8
  8023be:	00 00 00 
  8023c1:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  8023c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8023c8:	75 46                	jne    802410 <fork+0xb0>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  8023ca:	48 b8 8e 1c 80 00 00 	movabs $0x801c8e,%rax
  8023d1:	00 00 00 
  8023d4:	ff d0                	callq  *%rax
  8023d6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8023db:	48 63 d0             	movslq %eax,%rdx
  8023de:	48 89 d0             	mov    %rdx,%rax
  8023e1:	48 c1 e0 03          	shl    $0x3,%rax
  8023e5:	48 01 d0             	add    %rdx,%rax
  8023e8:	48 c1 e0 05          	shl    $0x5,%rax
  8023ec:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8023f3:	00 00 00 
  8023f6:	48 01 c2             	add    %rax,%rdx
  8023f9:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802400:	00 00 00 
  802403:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  802406:	b8 00 00 00 00       	mov    $0x0,%eax
  80240b:	e9 d1 01 00 00       	jmpq   8025e1 <fork+0x281>
	}
	uint64_t ad = 0;
  802410:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802417:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  802418:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  80241d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802421:	e9 df 00 00 00       	jmpq   802505 <fork+0x1a5>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  802426:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80242a:	48 c1 e8 27          	shr    $0x27,%rax
  80242e:	48 89 c2             	mov    %rax,%rdx
  802431:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802438:	01 00 00 
  80243b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80243f:	83 e0 01             	and    $0x1,%eax
  802442:	48 85 c0             	test   %rax,%rax
  802445:	0f 84 9e 00 00 00    	je     8024e9 <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  80244b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80244f:	48 c1 e8 1e          	shr    $0x1e,%rax
  802453:	48 89 c2             	mov    %rax,%rdx
  802456:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80245d:	01 00 00 
  802460:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802464:	83 e0 01             	and    $0x1,%eax
  802467:	48 85 c0             	test   %rax,%rax
  80246a:	74 73                	je     8024df <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  80246c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802470:	48 c1 e8 15          	shr    $0x15,%rax
  802474:	48 89 c2             	mov    %rax,%rdx
  802477:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80247e:	01 00 00 
  802481:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802485:	83 e0 01             	and    $0x1,%eax
  802488:	48 85 c0             	test   %rax,%rax
  80248b:	74 48                	je     8024d5 <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  80248d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802491:	48 c1 e8 0c          	shr    $0xc,%rax
  802495:	48 89 c2             	mov    %rax,%rdx
  802498:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80249f:	01 00 00 
  8024a2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024a6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8024aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024ae:	83 e0 01             	and    $0x1,%eax
  8024b1:	48 85 c0             	test   %rax,%rax
  8024b4:	74 47                	je     8024fd <fork+0x19d>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  8024b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024ba:	48 c1 e8 0c          	shr    $0xc,%rax
  8024be:	89 c2                	mov    %eax,%edx
  8024c0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8024c3:	89 d6                	mov    %edx,%esi
  8024c5:	89 c7                	mov    %eax,%edi
  8024c7:	48 b8 0c 21 80 00 00 	movabs $0x80210c,%rax
  8024ce:	00 00 00 
  8024d1:	ff d0                	callq  *%rax
  8024d3:	eb 28                	jmp    8024fd <fork+0x19d>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  8024d5:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  8024dc:	00 
  8024dd:	eb 1e                	jmp    8024fd <fork+0x19d>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  8024df:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  8024e6:	40 
  8024e7:	eb 14                	jmp    8024fd <fork+0x19d>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  8024e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024ed:	48 c1 e8 27          	shr    $0x27,%rax
  8024f1:	48 83 c0 01          	add    $0x1,%rax
  8024f5:	48 c1 e0 27          	shl    $0x27,%rax
  8024f9:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8024fd:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  802504:	00 
  802505:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  80250c:	00 
  80250d:	0f 87 13 ff ff ff    	ja     802426 <fork+0xc6>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  802513:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802516:	ba 07 00 00 00       	mov    $0x7,%edx
  80251b:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802520:	89 c7                	mov    %eax,%edi
  802522:	48 b8 0a 1d 80 00 00 	movabs $0x801d0a,%rax
  802529:	00 00 00 
  80252c:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  80252e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802531:	ba 07 00 00 00       	mov    $0x7,%edx
  802536:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80253b:	89 c7                	mov    %eax,%edi
  80253d:	48 b8 0a 1d 80 00 00 	movabs $0x801d0a,%rax
  802544:	00 00 00 
  802547:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  802549:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80254c:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802552:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  802557:	ba 00 00 00 00       	mov    $0x0,%edx
  80255c:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802561:	89 c7                	mov    %eax,%edi
  802563:	48 b8 5a 1d 80 00 00 	movabs $0x801d5a,%rax
  80256a:	00 00 00 
  80256d:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  80256f:	ba 00 10 00 00       	mov    $0x1000,%edx
  802574:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802579:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  80257e:	48 b8 ff 16 80 00 00 	movabs $0x8016ff,%rax
  802585:	00 00 00 
  802588:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  80258a:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80258f:	bf 00 00 00 00       	mov    $0x0,%edi
  802594:	48 b8 b5 1d 80 00 00 	movabs $0x801db5,%rax
  80259b:	00 00 00 
  80259e:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  8025a0:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8025a7:	00 00 00 
  8025aa:	48 8b 00             	mov    (%rax),%rax
  8025ad:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  8025b4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8025b7:	48 89 d6             	mov    %rdx,%rsi
  8025ba:	89 c7                	mov    %eax,%edi
  8025bc:	48 b8 94 1e 80 00 00 	movabs $0x801e94,%rax
  8025c3:	00 00 00 
  8025c6:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  8025c8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8025cb:	be 02 00 00 00       	mov    $0x2,%esi
  8025d0:	89 c7                	mov    %eax,%edi
  8025d2:	48 b8 ff 1d 80 00 00 	movabs $0x801dff,%rax
  8025d9:	00 00 00 
  8025dc:	ff d0                	callq  *%rax

	return envid;
  8025de:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  8025e1:	c9                   	leaveq 
  8025e2:	c3                   	retq   

00000000008025e3 <sfork>:

	
// Challenge!
int
sfork(void)
{
  8025e3:	55                   	push   %rbp
  8025e4:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8025e7:	48 ba 60 48 80 00 00 	movabs $0x804860,%rdx
  8025ee:	00 00 00 
  8025f1:	be bf 00 00 00       	mov    $0xbf,%esi
  8025f6:	48 bf a5 47 80 00 00 	movabs $0x8047a5,%rdi
  8025fd:	00 00 00 
  802600:	b8 00 00 00 00       	mov    $0x0,%eax
  802605:	48 b9 ed 05 80 00 00 	movabs $0x8005ed,%rcx
  80260c:	00 00 00 
  80260f:	ff d1                	callq  *%rcx

0000000000802611 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802611:	55                   	push   %rbp
  802612:	48 89 e5             	mov    %rsp,%rbp
  802615:	48 83 ec 08          	sub    $0x8,%rsp
  802619:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80261d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802621:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802628:	ff ff ff 
  80262b:	48 01 d0             	add    %rdx,%rax
  80262e:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802632:	c9                   	leaveq 
  802633:	c3                   	retq   

0000000000802634 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802634:	55                   	push   %rbp
  802635:	48 89 e5             	mov    %rsp,%rbp
  802638:	48 83 ec 08          	sub    $0x8,%rsp
  80263c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802640:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802644:	48 89 c7             	mov    %rax,%rdi
  802647:	48 b8 11 26 80 00 00 	movabs $0x802611,%rax
  80264e:	00 00 00 
  802651:	ff d0                	callq  *%rax
  802653:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802659:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80265d:	c9                   	leaveq 
  80265e:	c3                   	retq   

000000000080265f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80265f:	55                   	push   %rbp
  802660:	48 89 e5             	mov    %rsp,%rbp
  802663:	48 83 ec 18          	sub    $0x18,%rsp
  802667:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80266b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802672:	eb 6b                	jmp    8026df <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802674:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802677:	48 98                	cltq   
  802679:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80267f:	48 c1 e0 0c          	shl    $0xc,%rax
  802683:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802687:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80268b:	48 c1 e8 15          	shr    $0x15,%rax
  80268f:	48 89 c2             	mov    %rax,%rdx
  802692:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802699:	01 00 00 
  80269c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026a0:	83 e0 01             	and    $0x1,%eax
  8026a3:	48 85 c0             	test   %rax,%rax
  8026a6:	74 21                	je     8026c9 <fd_alloc+0x6a>
  8026a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026ac:	48 c1 e8 0c          	shr    $0xc,%rax
  8026b0:	48 89 c2             	mov    %rax,%rdx
  8026b3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8026ba:	01 00 00 
  8026bd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026c1:	83 e0 01             	and    $0x1,%eax
  8026c4:	48 85 c0             	test   %rax,%rax
  8026c7:	75 12                	jne    8026db <fd_alloc+0x7c>
			*fd_store = fd;
  8026c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026cd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8026d1:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8026d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d9:	eb 1a                	jmp    8026f5 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8026db:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8026df:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8026e3:	7e 8f                	jle    802674 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8026e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026e9:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8026f0:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8026f5:	c9                   	leaveq 
  8026f6:	c3                   	retq   

00000000008026f7 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8026f7:	55                   	push   %rbp
  8026f8:	48 89 e5             	mov    %rsp,%rbp
  8026fb:	48 83 ec 20          	sub    $0x20,%rsp
  8026ff:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802702:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802706:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80270a:	78 06                	js     802712 <fd_lookup+0x1b>
  80270c:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802710:	7e 07                	jle    802719 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802712:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802717:	eb 6c                	jmp    802785 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802719:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80271c:	48 98                	cltq   
  80271e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802724:	48 c1 e0 0c          	shl    $0xc,%rax
  802728:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80272c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802730:	48 c1 e8 15          	shr    $0x15,%rax
  802734:	48 89 c2             	mov    %rax,%rdx
  802737:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80273e:	01 00 00 
  802741:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802745:	83 e0 01             	and    $0x1,%eax
  802748:	48 85 c0             	test   %rax,%rax
  80274b:	74 21                	je     80276e <fd_lookup+0x77>
  80274d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802751:	48 c1 e8 0c          	shr    $0xc,%rax
  802755:	48 89 c2             	mov    %rax,%rdx
  802758:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80275f:	01 00 00 
  802762:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802766:	83 e0 01             	and    $0x1,%eax
  802769:	48 85 c0             	test   %rax,%rax
  80276c:	75 07                	jne    802775 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80276e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802773:	eb 10                	jmp    802785 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802775:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802779:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80277d:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802780:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802785:	c9                   	leaveq 
  802786:	c3                   	retq   

0000000000802787 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802787:	55                   	push   %rbp
  802788:	48 89 e5             	mov    %rsp,%rbp
  80278b:	48 83 ec 30          	sub    $0x30,%rsp
  80278f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802793:	89 f0                	mov    %esi,%eax
  802795:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802798:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80279c:	48 89 c7             	mov    %rax,%rdi
  80279f:	48 b8 11 26 80 00 00 	movabs $0x802611,%rax
  8027a6:	00 00 00 
  8027a9:	ff d0                	callq  *%rax
  8027ab:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027af:	48 89 d6             	mov    %rdx,%rsi
  8027b2:	89 c7                	mov    %eax,%edi
  8027b4:	48 b8 f7 26 80 00 00 	movabs $0x8026f7,%rax
  8027bb:	00 00 00 
  8027be:	ff d0                	callq  *%rax
  8027c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027c7:	78 0a                	js     8027d3 <fd_close+0x4c>
	    || fd != fd2)
  8027c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027cd:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8027d1:	74 12                	je     8027e5 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8027d3:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8027d7:	74 05                	je     8027de <fd_close+0x57>
  8027d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027dc:	eb 05                	jmp    8027e3 <fd_close+0x5c>
  8027de:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e3:	eb 69                	jmp    80284e <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8027e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027e9:	8b 00                	mov    (%rax),%eax
  8027eb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8027ef:	48 89 d6             	mov    %rdx,%rsi
  8027f2:	89 c7                	mov    %eax,%edi
  8027f4:	48 b8 50 28 80 00 00 	movabs $0x802850,%rax
  8027fb:	00 00 00 
  8027fe:	ff d0                	callq  *%rax
  802800:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802803:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802807:	78 2a                	js     802833 <fd_close+0xac>
		if (dev->dev_close)
  802809:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80280d:	48 8b 40 20          	mov    0x20(%rax),%rax
  802811:	48 85 c0             	test   %rax,%rax
  802814:	74 16                	je     80282c <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802816:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80281a:	48 8b 40 20          	mov    0x20(%rax),%rax
  80281e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802822:	48 89 d7             	mov    %rdx,%rdi
  802825:	ff d0                	callq  *%rax
  802827:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80282a:	eb 07                	jmp    802833 <fd_close+0xac>
		else
			r = 0;
  80282c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802833:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802837:	48 89 c6             	mov    %rax,%rsi
  80283a:	bf 00 00 00 00       	mov    $0x0,%edi
  80283f:	48 b8 b5 1d 80 00 00 	movabs $0x801db5,%rax
  802846:	00 00 00 
  802849:	ff d0                	callq  *%rax
	return r;
  80284b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80284e:	c9                   	leaveq 
  80284f:	c3                   	retq   

0000000000802850 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802850:	55                   	push   %rbp
  802851:	48 89 e5             	mov    %rsp,%rbp
  802854:	48 83 ec 20          	sub    $0x20,%rsp
  802858:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80285b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80285f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802866:	eb 41                	jmp    8028a9 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802868:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80286f:	00 00 00 
  802872:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802875:	48 63 d2             	movslq %edx,%rdx
  802878:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80287c:	8b 00                	mov    (%rax),%eax
  80287e:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802881:	75 22                	jne    8028a5 <dev_lookup+0x55>
			*dev = devtab[i];
  802883:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80288a:	00 00 00 
  80288d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802890:	48 63 d2             	movslq %edx,%rdx
  802893:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802897:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80289b:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80289e:	b8 00 00 00 00       	mov    $0x0,%eax
  8028a3:	eb 60                	jmp    802905 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8028a5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8028a9:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8028b0:	00 00 00 
  8028b3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8028b6:	48 63 d2             	movslq %edx,%rdx
  8028b9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028bd:	48 85 c0             	test   %rax,%rax
  8028c0:	75 a6                	jne    802868 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8028c2:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8028c9:	00 00 00 
  8028cc:	48 8b 00             	mov    (%rax),%rax
  8028cf:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8028d5:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8028d8:	89 c6                	mov    %eax,%esi
  8028da:	48 bf 78 48 80 00 00 	movabs $0x804878,%rdi
  8028e1:	00 00 00 
  8028e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e9:	48 b9 26 08 80 00 00 	movabs $0x800826,%rcx
  8028f0:	00 00 00 
  8028f3:	ff d1                	callq  *%rcx
	*dev = 0;
  8028f5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028f9:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802900:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802905:	c9                   	leaveq 
  802906:	c3                   	retq   

0000000000802907 <close>:

int
close(int fdnum)
{
  802907:	55                   	push   %rbp
  802908:	48 89 e5             	mov    %rsp,%rbp
  80290b:	48 83 ec 20          	sub    $0x20,%rsp
  80290f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802912:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802916:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802919:	48 89 d6             	mov    %rdx,%rsi
  80291c:	89 c7                	mov    %eax,%edi
  80291e:	48 b8 f7 26 80 00 00 	movabs $0x8026f7,%rax
  802925:	00 00 00 
  802928:	ff d0                	callq  *%rax
  80292a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80292d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802931:	79 05                	jns    802938 <close+0x31>
		return r;
  802933:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802936:	eb 18                	jmp    802950 <close+0x49>
	else
		return fd_close(fd, 1);
  802938:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80293c:	be 01 00 00 00       	mov    $0x1,%esi
  802941:	48 89 c7             	mov    %rax,%rdi
  802944:	48 b8 87 27 80 00 00 	movabs $0x802787,%rax
  80294b:	00 00 00 
  80294e:	ff d0                	callq  *%rax
}
  802950:	c9                   	leaveq 
  802951:	c3                   	retq   

0000000000802952 <close_all>:

void
close_all(void)
{
  802952:	55                   	push   %rbp
  802953:	48 89 e5             	mov    %rsp,%rbp
  802956:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80295a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802961:	eb 15                	jmp    802978 <close_all+0x26>
		close(i);
  802963:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802966:	89 c7                	mov    %eax,%edi
  802968:	48 b8 07 29 80 00 00 	movabs $0x802907,%rax
  80296f:	00 00 00 
  802972:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802974:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802978:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80297c:	7e e5                	jle    802963 <close_all+0x11>
		close(i);
}
  80297e:	c9                   	leaveq 
  80297f:	c3                   	retq   

0000000000802980 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802980:	55                   	push   %rbp
  802981:	48 89 e5             	mov    %rsp,%rbp
  802984:	48 83 ec 40          	sub    $0x40,%rsp
  802988:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80298b:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80298e:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802992:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802995:	48 89 d6             	mov    %rdx,%rsi
  802998:	89 c7                	mov    %eax,%edi
  80299a:	48 b8 f7 26 80 00 00 	movabs $0x8026f7,%rax
  8029a1:	00 00 00 
  8029a4:	ff d0                	callq  *%rax
  8029a6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029a9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029ad:	79 08                	jns    8029b7 <dup+0x37>
		return r;
  8029af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029b2:	e9 70 01 00 00       	jmpq   802b27 <dup+0x1a7>
	close(newfdnum);
  8029b7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8029ba:	89 c7                	mov    %eax,%edi
  8029bc:	48 b8 07 29 80 00 00 	movabs $0x802907,%rax
  8029c3:	00 00 00 
  8029c6:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8029c8:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8029cb:	48 98                	cltq   
  8029cd:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8029d3:	48 c1 e0 0c          	shl    $0xc,%rax
  8029d7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8029db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029df:	48 89 c7             	mov    %rax,%rdi
  8029e2:	48 b8 34 26 80 00 00 	movabs $0x802634,%rax
  8029e9:	00 00 00 
  8029ec:	ff d0                	callq  *%rax
  8029ee:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8029f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029f6:	48 89 c7             	mov    %rax,%rdi
  8029f9:	48 b8 34 26 80 00 00 	movabs $0x802634,%rax
  802a00:	00 00 00 
  802a03:	ff d0                	callq  *%rax
  802a05:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802a09:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a0d:	48 c1 e8 15          	shr    $0x15,%rax
  802a11:	48 89 c2             	mov    %rax,%rdx
  802a14:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802a1b:	01 00 00 
  802a1e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a22:	83 e0 01             	and    $0x1,%eax
  802a25:	48 85 c0             	test   %rax,%rax
  802a28:	74 73                	je     802a9d <dup+0x11d>
  802a2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a2e:	48 c1 e8 0c          	shr    $0xc,%rax
  802a32:	48 89 c2             	mov    %rax,%rdx
  802a35:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a3c:	01 00 00 
  802a3f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a43:	83 e0 01             	and    $0x1,%eax
  802a46:	48 85 c0             	test   %rax,%rax
  802a49:	74 52                	je     802a9d <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802a4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a4f:	48 c1 e8 0c          	shr    $0xc,%rax
  802a53:	48 89 c2             	mov    %rax,%rdx
  802a56:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a5d:	01 00 00 
  802a60:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a64:	25 07 0e 00 00       	and    $0xe07,%eax
  802a69:	89 c1                	mov    %eax,%ecx
  802a6b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802a6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a73:	41 89 c8             	mov    %ecx,%r8d
  802a76:	48 89 d1             	mov    %rdx,%rcx
  802a79:	ba 00 00 00 00       	mov    $0x0,%edx
  802a7e:	48 89 c6             	mov    %rax,%rsi
  802a81:	bf 00 00 00 00       	mov    $0x0,%edi
  802a86:	48 b8 5a 1d 80 00 00 	movabs $0x801d5a,%rax
  802a8d:	00 00 00 
  802a90:	ff d0                	callq  *%rax
  802a92:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a95:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a99:	79 02                	jns    802a9d <dup+0x11d>
			goto err;
  802a9b:	eb 57                	jmp    802af4 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802a9d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802aa1:	48 c1 e8 0c          	shr    $0xc,%rax
  802aa5:	48 89 c2             	mov    %rax,%rdx
  802aa8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802aaf:	01 00 00 
  802ab2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ab6:	25 07 0e 00 00       	and    $0xe07,%eax
  802abb:	89 c1                	mov    %eax,%ecx
  802abd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ac1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ac5:	41 89 c8             	mov    %ecx,%r8d
  802ac8:	48 89 d1             	mov    %rdx,%rcx
  802acb:	ba 00 00 00 00       	mov    $0x0,%edx
  802ad0:	48 89 c6             	mov    %rax,%rsi
  802ad3:	bf 00 00 00 00       	mov    $0x0,%edi
  802ad8:	48 b8 5a 1d 80 00 00 	movabs $0x801d5a,%rax
  802adf:	00 00 00 
  802ae2:	ff d0                	callq  *%rax
  802ae4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ae7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802aeb:	79 02                	jns    802aef <dup+0x16f>
		goto err;
  802aed:	eb 05                	jmp    802af4 <dup+0x174>

	return newfdnum;
  802aef:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802af2:	eb 33                	jmp    802b27 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802af4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802af8:	48 89 c6             	mov    %rax,%rsi
  802afb:	bf 00 00 00 00       	mov    $0x0,%edi
  802b00:	48 b8 b5 1d 80 00 00 	movabs $0x801db5,%rax
  802b07:	00 00 00 
  802b0a:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802b0c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b10:	48 89 c6             	mov    %rax,%rsi
  802b13:	bf 00 00 00 00       	mov    $0x0,%edi
  802b18:	48 b8 b5 1d 80 00 00 	movabs $0x801db5,%rax
  802b1f:	00 00 00 
  802b22:	ff d0                	callq  *%rax
	return r;
  802b24:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802b27:	c9                   	leaveq 
  802b28:	c3                   	retq   

0000000000802b29 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802b29:	55                   	push   %rbp
  802b2a:	48 89 e5             	mov    %rsp,%rbp
  802b2d:	48 83 ec 40          	sub    $0x40,%rsp
  802b31:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b34:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802b38:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b3c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b40:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b43:	48 89 d6             	mov    %rdx,%rsi
  802b46:	89 c7                	mov    %eax,%edi
  802b48:	48 b8 f7 26 80 00 00 	movabs $0x8026f7,%rax
  802b4f:	00 00 00 
  802b52:	ff d0                	callq  *%rax
  802b54:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b57:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b5b:	78 24                	js     802b81 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b61:	8b 00                	mov    (%rax),%eax
  802b63:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b67:	48 89 d6             	mov    %rdx,%rsi
  802b6a:	89 c7                	mov    %eax,%edi
  802b6c:	48 b8 50 28 80 00 00 	movabs $0x802850,%rax
  802b73:	00 00 00 
  802b76:	ff d0                	callq  *%rax
  802b78:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b7b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b7f:	79 05                	jns    802b86 <read+0x5d>
		return r;
  802b81:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b84:	eb 76                	jmp    802bfc <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802b86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b8a:	8b 40 08             	mov    0x8(%rax),%eax
  802b8d:	83 e0 03             	and    $0x3,%eax
  802b90:	83 f8 01             	cmp    $0x1,%eax
  802b93:	75 3a                	jne    802bcf <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802b95:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802b9c:	00 00 00 
  802b9f:	48 8b 00             	mov    (%rax),%rax
  802ba2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ba8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802bab:	89 c6                	mov    %eax,%esi
  802bad:	48 bf 97 48 80 00 00 	movabs $0x804897,%rdi
  802bb4:	00 00 00 
  802bb7:	b8 00 00 00 00       	mov    $0x0,%eax
  802bbc:	48 b9 26 08 80 00 00 	movabs $0x800826,%rcx
  802bc3:	00 00 00 
  802bc6:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802bc8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802bcd:	eb 2d                	jmp    802bfc <read+0xd3>
	}
	if (!dev->dev_read)
  802bcf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bd3:	48 8b 40 10          	mov    0x10(%rax),%rax
  802bd7:	48 85 c0             	test   %rax,%rax
  802bda:	75 07                	jne    802be3 <read+0xba>
		return -E_NOT_SUPP;
  802bdc:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802be1:	eb 19                	jmp    802bfc <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802be3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802be7:	48 8b 40 10          	mov    0x10(%rax),%rax
  802beb:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802bef:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802bf3:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802bf7:	48 89 cf             	mov    %rcx,%rdi
  802bfa:	ff d0                	callq  *%rax
}
  802bfc:	c9                   	leaveq 
  802bfd:	c3                   	retq   

0000000000802bfe <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802bfe:	55                   	push   %rbp
  802bff:	48 89 e5             	mov    %rsp,%rbp
  802c02:	48 83 ec 30          	sub    $0x30,%rsp
  802c06:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c09:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c0d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802c11:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802c18:	eb 49                	jmp    802c63 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802c1a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c1d:	48 98                	cltq   
  802c1f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802c23:	48 29 c2             	sub    %rax,%rdx
  802c26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c29:	48 63 c8             	movslq %eax,%rcx
  802c2c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c30:	48 01 c1             	add    %rax,%rcx
  802c33:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c36:	48 89 ce             	mov    %rcx,%rsi
  802c39:	89 c7                	mov    %eax,%edi
  802c3b:	48 b8 29 2b 80 00 00 	movabs $0x802b29,%rax
  802c42:	00 00 00 
  802c45:	ff d0                	callq  *%rax
  802c47:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802c4a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c4e:	79 05                	jns    802c55 <readn+0x57>
			return m;
  802c50:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c53:	eb 1c                	jmp    802c71 <readn+0x73>
		if (m == 0)
  802c55:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c59:	75 02                	jne    802c5d <readn+0x5f>
			break;
  802c5b:	eb 11                	jmp    802c6e <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802c5d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c60:	01 45 fc             	add    %eax,-0x4(%rbp)
  802c63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c66:	48 98                	cltq   
  802c68:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802c6c:	72 ac                	jb     802c1a <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802c6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c71:	c9                   	leaveq 
  802c72:	c3                   	retq   

0000000000802c73 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802c73:	55                   	push   %rbp
  802c74:	48 89 e5             	mov    %rsp,%rbp
  802c77:	48 83 ec 40          	sub    $0x40,%rsp
  802c7b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c7e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802c82:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c86:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c8a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c8d:	48 89 d6             	mov    %rdx,%rsi
  802c90:	89 c7                	mov    %eax,%edi
  802c92:	48 b8 f7 26 80 00 00 	movabs $0x8026f7,%rax
  802c99:	00 00 00 
  802c9c:	ff d0                	callq  *%rax
  802c9e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ca1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ca5:	78 24                	js     802ccb <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ca7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cab:	8b 00                	mov    (%rax),%eax
  802cad:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802cb1:	48 89 d6             	mov    %rdx,%rsi
  802cb4:	89 c7                	mov    %eax,%edi
  802cb6:	48 b8 50 28 80 00 00 	movabs $0x802850,%rax
  802cbd:	00 00 00 
  802cc0:	ff d0                	callq  *%rax
  802cc2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cc5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cc9:	79 05                	jns    802cd0 <write+0x5d>
		return r;
  802ccb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cce:	eb 75                	jmp    802d45 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802cd0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cd4:	8b 40 08             	mov    0x8(%rax),%eax
  802cd7:	83 e0 03             	and    $0x3,%eax
  802cda:	85 c0                	test   %eax,%eax
  802cdc:	75 3a                	jne    802d18 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802cde:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802ce5:	00 00 00 
  802ce8:	48 8b 00             	mov    (%rax),%rax
  802ceb:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802cf1:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802cf4:	89 c6                	mov    %eax,%esi
  802cf6:	48 bf b3 48 80 00 00 	movabs $0x8048b3,%rdi
  802cfd:	00 00 00 
  802d00:	b8 00 00 00 00       	mov    $0x0,%eax
  802d05:	48 b9 26 08 80 00 00 	movabs $0x800826,%rcx
  802d0c:	00 00 00 
  802d0f:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802d11:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d16:	eb 2d                	jmp    802d45 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802d18:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d1c:	48 8b 40 18          	mov    0x18(%rax),%rax
  802d20:	48 85 c0             	test   %rax,%rax
  802d23:	75 07                	jne    802d2c <write+0xb9>
		return -E_NOT_SUPP;
  802d25:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d2a:	eb 19                	jmp    802d45 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802d2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d30:	48 8b 40 18          	mov    0x18(%rax),%rax
  802d34:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802d38:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802d3c:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802d40:	48 89 cf             	mov    %rcx,%rdi
  802d43:	ff d0                	callq  *%rax
}
  802d45:	c9                   	leaveq 
  802d46:	c3                   	retq   

0000000000802d47 <seek>:

int
seek(int fdnum, off_t offset)
{
  802d47:	55                   	push   %rbp
  802d48:	48 89 e5             	mov    %rsp,%rbp
  802d4b:	48 83 ec 18          	sub    $0x18,%rsp
  802d4f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d52:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802d55:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d59:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d5c:	48 89 d6             	mov    %rdx,%rsi
  802d5f:	89 c7                	mov    %eax,%edi
  802d61:	48 b8 f7 26 80 00 00 	movabs $0x8026f7,%rax
  802d68:	00 00 00 
  802d6b:	ff d0                	callq  *%rax
  802d6d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d70:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d74:	79 05                	jns    802d7b <seek+0x34>
		return r;
  802d76:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d79:	eb 0f                	jmp    802d8a <seek+0x43>
	fd->fd_offset = offset;
  802d7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d7f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802d82:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802d85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d8a:	c9                   	leaveq 
  802d8b:	c3                   	retq   

0000000000802d8c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802d8c:	55                   	push   %rbp
  802d8d:	48 89 e5             	mov    %rsp,%rbp
  802d90:	48 83 ec 30          	sub    $0x30,%rsp
  802d94:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d97:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d9a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d9e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802da1:	48 89 d6             	mov    %rdx,%rsi
  802da4:	89 c7                	mov    %eax,%edi
  802da6:	48 b8 f7 26 80 00 00 	movabs $0x8026f7,%rax
  802dad:	00 00 00 
  802db0:	ff d0                	callq  *%rax
  802db2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802db5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802db9:	78 24                	js     802ddf <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802dbb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dbf:	8b 00                	mov    (%rax),%eax
  802dc1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802dc5:	48 89 d6             	mov    %rdx,%rsi
  802dc8:	89 c7                	mov    %eax,%edi
  802dca:	48 b8 50 28 80 00 00 	movabs $0x802850,%rax
  802dd1:	00 00 00 
  802dd4:	ff d0                	callq  *%rax
  802dd6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dd9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ddd:	79 05                	jns    802de4 <ftruncate+0x58>
		return r;
  802ddf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802de2:	eb 72                	jmp    802e56 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802de4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802de8:	8b 40 08             	mov    0x8(%rax),%eax
  802deb:	83 e0 03             	and    $0x3,%eax
  802dee:	85 c0                	test   %eax,%eax
  802df0:	75 3a                	jne    802e2c <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802df2:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802df9:	00 00 00 
  802dfc:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802dff:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802e05:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802e08:	89 c6                	mov    %eax,%esi
  802e0a:	48 bf d0 48 80 00 00 	movabs $0x8048d0,%rdi
  802e11:	00 00 00 
  802e14:	b8 00 00 00 00       	mov    $0x0,%eax
  802e19:	48 b9 26 08 80 00 00 	movabs $0x800826,%rcx
  802e20:	00 00 00 
  802e23:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802e25:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e2a:	eb 2a                	jmp    802e56 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802e2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e30:	48 8b 40 30          	mov    0x30(%rax),%rax
  802e34:	48 85 c0             	test   %rax,%rax
  802e37:	75 07                	jne    802e40 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802e39:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e3e:	eb 16                	jmp    802e56 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802e40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e44:	48 8b 40 30          	mov    0x30(%rax),%rax
  802e48:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802e4c:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802e4f:	89 ce                	mov    %ecx,%esi
  802e51:	48 89 d7             	mov    %rdx,%rdi
  802e54:	ff d0                	callq  *%rax
}
  802e56:	c9                   	leaveq 
  802e57:	c3                   	retq   

0000000000802e58 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802e58:	55                   	push   %rbp
  802e59:	48 89 e5             	mov    %rsp,%rbp
  802e5c:	48 83 ec 30          	sub    $0x30,%rsp
  802e60:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e63:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e67:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e6b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e6e:	48 89 d6             	mov    %rdx,%rsi
  802e71:	89 c7                	mov    %eax,%edi
  802e73:	48 b8 f7 26 80 00 00 	movabs $0x8026f7,%rax
  802e7a:	00 00 00 
  802e7d:	ff d0                	callq  *%rax
  802e7f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e82:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e86:	78 24                	js     802eac <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e8c:	8b 00                	mov    (%rax),%eax
  802e8e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e92:	48 89 d6             	mov    %rdx,%rsi
  802e95:	89 c7                	mov    %eax,%edi
  802e97:	48 b8 50 28 80 00 00 	movabs $0x802850,%rax
  802e9e:	00 00 00 
  802ea1:	ff d0                	callq  *%rax
  802ea3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ea6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802eaa:	79 05                	jns    802eb1 <fstat+0x59>
		return r;
  802eac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eaf:	eb 5e                	jmp    802f0f <fstat+0xb7>
	if (!dev->dev_stat)
  802eb1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eb5:	48 8b 40 28          	mov    0x28(%rax),%rax
  802eb9:	48 85 c0             	test   %rax,%rax
  802ebc:	75 07                	jne    802ec5 <fstat+0x6d>
		return -E_NOT_SUPP;
  802ebe:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ec3:	eb 4a                	jmp    802f0f <fstat+0xb7>
	stat->st_name[0] = 0;
  802ec5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ec9:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802ecc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ed0:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802ed7:	00 00 00 
	stat->st_isdir = 0;
  802eda:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ede:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802ee5:	00 00 00 
	stat->st_dev = dev;
  802ee8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802eec:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ef0:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802ef7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802efb:	48 8b 40 28          	mov    0x28(%rax),%rax
  802eff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802f03:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802f07:	48 89 ce             	mov    %rcx,%rsi
  802f0a:	48 89 d7             	mov    %rdx,%rdi
  802f0d:	ff d0                	callq  *%rax
}
  802f0f:	c9                   	leaveq 
  802f10:	c3                   	retq   

0000000000802f11 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802f11:	55                   	push   %rbp
  802f12:	48 89 e5             	mov    %rsp,%rbp
  802f15:	48 83 ec 20          	sub    $0x20,%rsp
  802f19:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f1d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802f21:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f25:	be 00 00 00 00       	mov    $0x0,%esi
  802f2a:	48 89 c7             	mov    %rax,%rdi
  802f2d:	48 b8 ff 2f 80 00 00 	movabs $0x802fff,%rax
  802f34:	00 00 00 
  802f37:	ff d0                	callq  *%rax
  802f39:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f3c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f40:	79 05                	jns    802f47 <stat+0x36>
		return fd;
  802f42:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f45:	eb 2f                	jmp    802f76 <stat+0x65>
	r = fstat(fd, stat);
  802f47:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802f4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f4e:	48 89 d6             	mov    %rdx,%rsi
  802f51:	89 c7                	mov    %eax,%edi
  802f53:	48 b8 58 2e 80 00 00 	movabs $0x802e58,%rax
  802f5a:	00 00 00 
  802f5d:	ff d0                	callq  *%rax
  802f5f:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802f62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f65:	89 c7                	mov    %eax,%edi
  802f67:	48 b8 07 29 80 00 00 	movabs $0x802907,%rax
  802f6e:	00 00 00 
  802f71:	ff d0                	callq  *%rax
	return r;
  802f73:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802f76:	c9                   	leaveq 
  802f77:	c3                   	retq   

0000000000802f78 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802f78:	55                   	push   %rbp
  802f79:	48 89 e5             	mov    %rsp,%rbp
  802f7c:	48 83 ec 10          	sub    $0x10,%rsp
  802f80:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802f83:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802f87:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802f8e:	00 00 00 
  802f91:	8b 00                	mov    (%rax),%eax
  802f93:	85 c0                	test   %eax,%eax
  802f95:	75 1d                	jne    802fb4 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802f97:	bf 01 00 00 00       	mov    $0x1,%edi
  802f9c:	48 b8 fb 3f 80 00 00 	movabs $0x803ffb,%rax
  802fa3:	00 00 00 
  802fa6:	ff d0                	callq  *%rax
  802fa8:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802faf:	00 00 00 
  802fb2:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802fb4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802fbb:	00 00 00 
  802fbe:	8b 00                	mov    (%rax),%eax
  802fc0:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802fc3:	b9 07 00 00 00       	mov    $0x7,%ecx
  802fc8:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802fcf:	00 00 00 
  802fd2:	89 c7                	mov    %eax,%edi
  802fd4:	48 b8 99 3f 80 00 00 	movabs $0x803f99,%rax
  802fdb:	00 00 00 
  802fde:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802fe0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fe4:	ba 00 00 00 00       	mov    $0x0,%edx
  802fe9:	48 89 c6             	mov    %rax,%rsi
  802fec:	bf 00 00 00 00       	mov    $0x0,%edi
  802ff1:	48 b8 93 3e 80 00 00 	movabs $0x803e93,%rax
  802ff8:	00 00 00 
  802ffb:	ff d0                	callq  *%rax
}
  802ffd:	c9                   	leaveq 
  802ffe:	c3                   	retq   

0000000000802fff <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802fff:	55                   	push   %rbp
  803000:	48 89 e5             	mov    %rsp,%rbp
  803003:	48 83 ec 30          	sub    $0x30,%rsp
  803007:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80300b:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  80300e:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  803015:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  80301c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  803023:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803028:	75 08                	jne    803032 <open+0x33>
	{
		return r;
  80302a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80302d:	e9 f2 00 00 00       	jmpq   803124 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  803032:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803036:	48 89 c7             	mov    %rax,%rdi
  803039:	48 b8 6f 13 80 00 00 	movabs $0x80136f,%rax
  803040:	00 00 00 
  803043:	ff d0                	callq  *%rax
  803045:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803048:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  80304f:	7e 0a                	jle    80305b <open+0x5c>
	{
		return -E_BAD_PATH;
  803051:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803056:	e9 c9 00 00 00       	jmpq   803124 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  80305b:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  803062:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  803063:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  803067:	48 89 c7             	mov    %rax,%rdi
  80306a:	48 b8 5f 26 80 00 00 	movabs $0x80265f,%rax
  803071:	00 00 00 
  803074:	ff d0                	callq  *%rax
  803076:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803079:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80307d:	78 09                	js     803088 <open+0x89>
  80307f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803083:	48 85 c0             	test   %rax,%rax
  803086:	75 08                	jne    803090 <open+0x91>
		{
			return r;
  803088:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80308b:	e9 94 00 00 00       	jmpq   803124 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  803090:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803094:	ba 00 04 00 00       	mov    $0x400,%edx
  803099:	48 89 c6             	mov    %rax,%rsi
  80309c:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8030a3:	00 00 00 
  8030a6:	48 b8 6d 14 80 00 00 	movabs $0x80146d,%rax
  8030ad:	00 00 00 
  8030b0:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  8030b2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030b9:	00 00 00 
  8030bc:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  8030bf:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  8030c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030c9:	48 89 c6             	mov    %rax,%rsi
  8030cc:	bf 01 00 00 00       	mov    $0x1,%edi
  8030d1:	48 b8 78 2f 80 00 00 	movabs $0x802f78,%rax
  8030d8:	00 00 00 
  8030db:	ff d0                	callq  *%rax
  8030dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030e4:	79 2b                	jns    803111 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  8030e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030ea:	be 00 00 00 00       	mov    $0x0,%esi
  8030ef:	48 89 c7             	mov    %rax,%rdi
  8030f2:	48 b8 87 27 80 00 00 	movabs $0x802787,%rax
  8030f9:	00 00 00 
  8030fc:	ff d0                	callq  *%rax
  8030fe:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803101:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803105:	79 05                	jns    80310c <open+0x10d>
			{
				return d;
  803107:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80310a:	eb 18                	jmp    803124 <open+0x125>
			}
			return r;
  80310c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80310f:	eb 13                	jmp    803124 <open+0x125>
		}	
		return fd2num(fd_store);
  803111:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803115:	48 89 c7             	mov    %rax,%rdi
  803118:	48 b8 11 26 80 00 00 	movabs $0x802611,%rax
  80311f:	00 00 00 
  803122:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  803124:	c9                   	leaveq 
  803125:	c3                   	retq   

0000000000803126 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  803126:	55                   	push   %rbp
  803127:	48 89 e5             	mov    %rsp,%rbp
  80312a:	48 83 ec 10          	sub    $0x10,%rsp
  80312e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803132:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803136:	8b 50 0c             	mov    0xc(%rax),%edx
  803139:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803140:	00 00 00 
  803143:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  803145:	be 00 00 00 00       	mov    $0x0,%esi
  80314a:	bf 06 00 00 00       	mov    $0x6,%edi
  80314f:	48 b8 78 2f 80 00 00 	movabs $0x802f78,%rax
  803156:	00 00 00 
  803159:	ff d0                	callq  *%rax
}
  80315b:	c9                   	leaveq 
  80315c:	c3                   	retq   

000000000080315d <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80315d:	55                   	push   %rbp
  80315e:	48 89 e5             	mov    %rsp,%rbp
  803161:	48 83 ec 30          	sub    $0x30,%rsp
  803165:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803169:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80316d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  803171:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  803178:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80317d:	74 07                	je     803186 <devfile_read+0x29>
  80317f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803184:	75 07                	jne    80318d <devfile_read+0x30>
		return -E_INVAL;
  803186:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80318b:	eb 77                	jmp    803204 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80318d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803191:	8b 50 0c             	mov    0xc(%rax),%edx
  803194:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80319b:	00 00 00 
  80319e:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8031a0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031a7:	00 00 00 
  8031aa:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8031ae:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  8031b2:	be 00 00 00 00       	mov    $0x0,%esi
  8031b7:	bf 03 00 00 00       	mov    $0x3,%edi
  8031bc:	48 b8 78 2f 80 00 00 	movabs $0x802f78,%rax
  8031c3:	00 00 00 
  8031c6:	ff d0                	callq  *%rax
  8031c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031cf:	7f 05                	jg     8031d6 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  8031d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031d4:	eb 2e                	jmp    803204 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  8031d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031d9:	48 63 d0             	movslq %eax,%rdx
  8031dc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031e0:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8031e7:	00 00 00 
  8031ea:	48 89 c7             	mov    %rax,%rdi
  8031ed:	48 b8 ff 16 80 00 00 	movabs $0x8016ff,%rax
  8031f4:	00 00 00 
  8031f7:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  8031f9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031fd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  803201:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  803204:	c9                   	leaveq 
  803205:	c3                   	retq   

0000000000803206 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803206:	55                   	push   %rbp
  803207:	48 89 e5             	mov    %rsp,%rbp
  80320a:	48 83 ec 30          	sub    $0x30,%rsp
  80320e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803212:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803216:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  80321a:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  803221:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803226:	74 07                	je     80322f <devfile_write+0x29>
  803228:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80322d:	75 08                	jne    803237 <devfile_write+0x31>
		return r;
  80322f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803232:	e9 9a 00 00 00       	jmpq   8032d1 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  803237:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80323b:	8b 50 0c             	mov    0xc(%rax),%edx
  80323e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803245:	00 00 00 
  803248:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  80324a:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  803251:	00 
  803252:	76 08                	jbe    80325c <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  803254:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  80325b:	00 
	}
	fsipcbuf.write.req_n = n;
  80325c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803263:	00 00 00 
  803266:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80326a:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  80326e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803272:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803276:	48 89 c6             	mov    %rax,%rsi
  803279:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  803280:	00 00 00 
  803283:	48 b8 ff 16 80 00 00 	movabs $0x8016ff,%rax
  80328a:	00 00 00 
  80328d:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  80328f:	be 00 00 00 00       	mov    $0x0,%esi
  803294:	bf 04 00 00 00       	mov    $0x4,%edi
  803299:	48 b8 78 2f 80 00 00 	movabs $0x802f78,%rax
  8032a0:	00 00 00 
  8032a3:	ff d0                	callq  *%rax
  8032a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032ac:	7f 20                	jg     8032ce <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  8032ae:	48 bf f6 48 80 00 00 	movabs $0x8048f6,%rdi
  8032b5:	00 00 00 
  8032b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8032bd:	48 ba 26 08 80 00 00 	movabs $0x800826,%rdx
  8032c4:	00 00 00 
  8032c7:	ff d2                	callq  *%rdx
		return r;
  8032c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032cc:	eb 03                	jmp    8032d1 <devfile_write+0xcb>
	}
	return r;
  8032ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  8032d1:	c9                   	leaveq 
  8032d2:	c3                   	retq   

00000000008032d3 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8032d3:	55                   	push   %rbp
  8032d4:	48 89 e5             	mov    %rsp,%rbp
  8032d7:	48 83 ec 20          	sub    $0x20,%rsp
  8032db:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8032df:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8032e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032e7:	8b 50 0c             	mov    0xc(%rax),%edx
  8032ea:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8032f1:	00 00 00 
  8032f4:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8032f6:	be 00 00 00 00       	mov    $0x0,%esi
  8032fb:	bf 05 00 00 00       	mov    $0x5,%edi
  803300:	48 b8 78 2f 80 00 00 	movabs $0x802f78,%rax
  803307:	00 00 00 
  80330a:	ff d0                	callq  *%rax
  80330c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80330f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803313:	79 05                	jns    80331a <devfile_stat+0x47>
		return r;
  803315:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803318:	eb 56                	jmp    803370 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80331a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80331e:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803325:	00 00 00 
  803328:	48 89 c7             	mov    %rax,%rdi
  80332b:	48 b8 db 13 80 00 00 	movabs $0x8013db,%rax
  803332:	00 00 00 
  803335:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803337:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80333e:	00 00 00 
  803341:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803347:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80334b:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803351:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803358:	00 00 00 
  80335b:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803361:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803365:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80336b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803370:	c9                   	leaveq 
  803371:	c3                   	retq   

0000000000803372 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803372:	55                   	push   %rbp
  803373:	48 89 e5             	mov    %rsp,%rbp
  803376:	48 83 ec 10          	sub    $0x10,%rsp
  80337a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80337e:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803381:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803385:	8b 50 0c             	mov    0xc(%rax),%edx
  803388:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80338f:	00 00 00 
  803392:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803394:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80339b:	00 00 00 
  80339e:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8033a1:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8033a4:	be 00 00 00 00       	mov    $0x0,%esi
  8033a9:	bf 02 00 00 00       	mov    $0x2,%edi
  8033ae:	48 b8 78 2f 80 00 00 	movabs $0x802f78,%rax
  8033b5:	00 00 00 
  8033b8:	ff d0                	callq  *%rax
}
  8033ba:	c9                   	leaveq 
  8033bb:	c3                   	retq   

00000000008033bc <remove>:

// Delete a file
int
remove(const char *path)
{
  8033bc:	55                   	push   %rbp
  8033bd:	48 89 e5             	mov    %rsp,%rbp
  8033c0:	48 83 ec 10          	sub    $0x10,%rsp
  8033c4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8033c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033cc:	48 89 c7             	mov    %rax,%rdi
  8033cf:	48 b8 6f 13 80 00 00 	movabs $0x80136f,%rax
  8033d6:	00 00 00 
  8033d9:	ff d0                	callq  *%rax
  8033db:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8033e0:	7e 07                	jle    8033e9 <remove+0x2d>
		return -E_BAD_PATH;
  8033e2:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8033e7:	eb 33                	jmp    80341c <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8033e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033ed:	48 89 c6             	mov    %rax,%rsi
  8033f0:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8033f7:	00 00 00 
  8033fa:	48 b8 db 13 80 00 00 	movabs $0x8013db,%rax
  803401:	00 00 00 
  803404:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803406:	be 00 00 00 00       	mov    $0x0,%esi
  80340b:	bf 07 00 00 00       	mov    $0x7,%edi
  803410:	48 b8 78 2f 80 00 00 	movabs $0x802f78,%rax
  803417:	00 00 00 
  80341a:	ff d0                	callq  *%rax
}
  80341c:	c9                   	leaveq 
  80341d:	c3                   	retq   

000000000080341e <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80341e:	55                   	push   %rbp
  80341f:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803422:	be 00 00 00 00       	mov    $0x0,%esi
  803427:	bf 08 00 00 00       	mov    $0x8,%edi
  80342c:	48 b8 78 2f 80 00 00 	movabs $0x802f78,%rax
  803433:	00 00 00 
  803436:	ff d0                	callq  *%rax
}
  803438:	5d                   	pop    %rbp
  803439:	c3                   	retq   

000000000080343a <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80343a:	55                   	push   %rbp
  80343b:	48 89 e5             	mov    %rsp,%rbp
  80343e:	53                   	push   %rbx
  80343f:	48 83 ec 38          	sub    $0x38,%rsp
  803443:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803447:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80344b:	48 89 c7             	mov    %rax,%rdi
  80344e:	48 b8 5f 26 80 00 00 	movabs $0x80265f,%rax
  803455:	00 00 00 
  803458:	ff d0                	callq  *%rax
  80345a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80345d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803461:	0f 88 bf 01 00 00    	js     803626 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803467:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80346b:	ba 07 04 00 00       	mov    $0x407,%edx
  803470:	48 89 c6             	mov    %rax,%rsi
  803473:	bf 00 00 00 00       	mov    $0x0,%edi
  803478:	48 b8 0a 1d 80 00 00 	movabs $0x801d0a,%rax
  80347f:	00 00 00 
  803482:	ff d0                	callq  *%rax
  803484:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803487:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80348b:	0f 88 95 01 00 00    	js     803626 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803491:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803495:	48 89 c7             	mov    %rax,%rdi
  803498:	48 b8 5f 26 80 00 00 	movabs $0x80265f,%rax
  80349f:	00 00 00 
  8034a2:	ff d0                	callq  *%rax
  8034a4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034a7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8034ab:	0f 88 5d 01 00 00    	js     80360e <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8034b1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034b5:	ba 07 04 00 00       	mov    $0x407,%edx
  8034ba:	48 89 c6             	mov    %rax,%rsi
  8034bd:	bf 00 00 00 00       	mov    $0x0,%edi
  8034c2:	48 b8 0a 1d 80 00 00 	movabs $0x801d0a,%rax
  8034c9:	00 00 00 
  8034cc:	ff d0                	callq  *%rax
  8034ce:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8034d5:	0f 88 33 01 00 00    	js     80360e <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8034db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034df:	48 89 c7             	mov    %rax,%rdi
  8034e2:	48 b8 34 26 80 00 00 	movabs $0x802634,%rax
  8034e9:	00 00 00 
  8034ec:	ff d0                	callq  *%rax
  8034ee:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8034f2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034f6:	ba 07 04 00 00       	mov    $0x407,%edx
  8034fb:	48 89 c6             	mov    %rax,%rsi
  8034fe:	bf 00 00 00 00       	mov    $0x0,%edi
  803503:	48 b8 0a 1d 80 00 00 	movabs $0x801d0a,%rax
  80350a:	00 00 00 
  80350d:	ff d0                	callq  *%rax
  80350f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803512:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803516:	79 05                	jns    80351d <pipe+0xe3>
		goto err2;
  803518:	e9 d9 00 00 00       	jmpq   8035f6 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80351d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803521:	48 89 c7             	mov    %rax,%rdi
  803524:	48 b8 34 26 80 00 00 	movabs $0x802634,%rax
  80352b:	00 00 00 
  80352e:	ff d0                	callq  *%rax
  803530:	48 89 c2             	mov    %rax,%rdx
  803533:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803537:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80353d:	48 89 d1             	mov    %rdx,%rcx
  803540:	ba 00 00 00 00       	mov    $0x0,%edx
  803545:	48 89 c6             	mov    %rax,%rsi
  803548:	bf 00 00 00 00       	mov    $0x0,%edi
  80354d:	48 b8 5a 1d 80 00 00 	movabs $0x801d5a,%rax
  803554:	00 00 00 
  803557:	ff d0                	callq  *%rax
  803559:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80355c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803560:	79 1b                	jns    80357d <pipe+0x143>
		goto err3;
  803562:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  803563:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803567:	48 89 c6             	mov    %rax,%rsi
  80356a:	bf 00 00 00 00       	mov    $0x0,%edi
  80356f:	48 b8 b5 1d 80 00 00 	movabs $0x801db5,%rax
  803576:	00 00 00 
  803579:	ff d0                	callq  *%rax
  80357b:	eb 79                	jmp    8035f6 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80357d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803581:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803588:	00 00 00 
  80358b:	8b 12                	mov    (%rdx),%edx
  80358d:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80358f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803593:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80359a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80359e:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  8035a5:	00 00 00 
  8035a8:	8b 12                	mov    (%rdx),%edx
  8035aa:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8035ac:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035b0:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8035b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035bb:	48 89 c7             	mov    %rax,%rdi
  8035be:	48 b8 11 26 80 00 00 	movabs $0x802611,%rax
  8035c5:	00 00 00 
  8035c8:	ff d0                	callq  *%rax
  8035ca:	89 c2                	mov    %eax,%edx
  8035cc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8035d0:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8035d2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8035d6:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8035da:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035de:	48 89 c7             	mov    %rax,%rdi
  8035e1:	48 b8 11 26 80 00 00 	movabs $0x802611,%rax
  8035e8:	00 00 00 
  8035eb:	ff d0                	callq  *%rax
  8035ed:	89 03                	mov    %eax,(%rbx)
	return 0;
  8035ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8035f4:	eb 33                	jmp    803629 <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  8035f6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035fa:	48 89 c6             	mov    %rax,%rsi
  8035fd:	bf 00 00 00 00       	mov    $0x0,%edi
  803602:	48 b8 b5 1d 80 00 00 	movabs $0x801db5,%rax
  803609:	00 00 00 
  80360c:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  80360e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803612:	48 89 c6             	mov    %rax,%rsi
  803615:	bf 00 00 00 00       	mov    $0x0,%edi
  80361a:	48 b8 b5 1d 80 00 00 	movabs $0x801db5,%rax
  803621:	00 00 00 
  803624:	ff d0                	callq  *%rax
    err:
	return r;
  803626:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803629:	48 83 c4 38          	add    $0x38,%rsp
  80362d:	5b                   	pop    %rbx
  80362e:	5d                   	pop    %rbp
  80362f:	c3                   	retq   

0000000000803630 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803630:	55                   	push   %rbp
  803631:	48 89 e5             	mov    %rsp,%rbp
  803634:	53                   	push   %rbx
  803635:	48 83 ec 28          	sub    $0x28,%rsp
  803639:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80363d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803641:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803648:	00 00 00 
  80364b:	48 8b 00             	mov    (%rax),%rax
  80364e:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803654:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803657:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80365b:	48 89 c7             	mov    %rax,%rdi
  80365e:	48 b8 7d 40 80 00 00 	movabs $0x80407d,%rax
  803665:	00 00 00 
  803668:	ff d0                	callq  *%rax
  80366a:	89 c3                	mov    %eax,%ebx
  80366c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803670:	48 89 c7             	mov    %rax,%rdi
  803673:	48 b8 7d 40 80 00 00 	movabs $0x80407d,%rax
  80367a:	00 00 00 
  80367d:	ff d0                	callq  *%rax
  80367f:	39 c3                	cmp    %eax,%ebx
  803681:	0f 94 c0             	sete   %al
  803684:	0f b6 c0             	movzbl %al,%eax
  803687:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80368a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803691:	00 00 00 
  803694:	48 8b 00             	mov    (%rax),%rax
  803697:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80369d:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8036a0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036a3:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8036a6:	75 05                	jne    8036ad <_pipeisclosed+0x7d>
			return ret;
  8036a8:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8036ab:	eb 4f                	jmp    8036fc <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8036ad:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036b0:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8036b3:	74 42                	je     8036f7 <_pipeisclosed+0xc7>
  8036b5:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8036b9:	75 3c                	jne    8036f7 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8036bb:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8036c2:	00 00 00 
  8036c5:	48 8b 00             	mov    (%rax),%rax
  8036c8:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8036ce:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8036d1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036d4:	89 c6                	mov    %eax,%esi
  8036d6:	48 bf 17 49 80 00 00 	movabs $0x804917,%rdi
  8036dd:	00 00 00 
  8036e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8036e5:	49 b8 26 08 80 00 00 	movabs $0x800826,%r8
  8036ec:	00 00 00 
  8036ef:	41 ff d0             	callq  *%r8
	}
  8036f2:	e9 4a ff ff ff       	jmpq   803641 <_pipeisclosed+0x11>
  8036f7:	e9 45 ff ff ff       	jmpq   803641 <_pipeisclosed+0x11>
}
  8036fc:	48 83 c4 28          	add    $0x28,%rsp
  803700:	5b                   	pop    %rbx
  803701:	5d                   	pop    %rbp
  803702:	c3                   	retq   

0000000000803703 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803703:	55                   	push   %rbp
  803704:	48 89 e5             	mov    %rsp,%rbp
  803707:	48 83 ec 30          	sub    $0x30,%rsp
  80370b:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80370e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803712:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803715:	48 89 d6             	mov    %rdx,%rsi
  803718:	89 c7                	mov    %eax,%edi
  80371a:	48 b8 f7 26 80 00 00 	movabs $0x8026f7,%rax
  803721:	00 00 00 
  803724:	ff d0                	callq  *%rax
  803726:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803729:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80372d:	79 05                	jns    803734 <pipeisclosed+0x31>
		return r;
  80372f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803732:	eb 31                	jmp    803765 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803734:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803738:	48 89 c7             	mov    %rax,%rdi
  80373b:	48 b8 34 26 80 00 00 	movabs $0x802634,%rax
  803742:	00 00 00 
  803745:	ff d0                	callq  *%rax
  803747:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80374b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80374f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803753:	48 89 d6             	mov    %rdx,%rsi
  803756:	48 89 c7             	mov    %rax,%rdi
  803759:	48 b8 30 36 80 00 00 	movabs $0x803630,%rax
  803760:	00 00 00 
  803763:	ff d0                	callq  *%rax
}
  803765:	c9                   	leaveq 
  803766:	c3                   	retq   

0000000000803767 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803767:	55                   	push   %rbp
  803768:	48 89 e5             	mov    %rsp,%rbp
  80376b:	48 83 ec 40          	sub    $0x40,%rsp
  80376f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803773:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803777:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80377b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80377f:	48 89 c7             	mov    %rax,%rdi
  803782:	48 b8 34 26 80 00 00 	movabs $0x802634,%rax
  803789:	00 00 00 
  80378c:	ff d0                	callq  *%rax
  80378e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803792:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803796:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80379a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8037a1:	00 
  8037a2:	e9 92 00 00 00       	jmpq   803839 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8037a7:	eb 41                	jmp    8037ea <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8037a9:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8037ae:	74 09                	je     8037b9 <devpipe_read+0x52>
				return i;
  8037b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037b4:	e9 92 00 00 00       	jmpq   80384b <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8037b9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8037bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037c1:	48 89 d6             	mov    %rdx,%rsi
  8037c4:	48 89 c7             	mov    %rax,%rdi
  8037c7:	48 b8 30 36 80 00 00 	movabs $0x803630,%rax
  8037ce:	00 00 00 
  8037d1:	ff d0                	callq  *%rax
  8037d3:	85 c0                	test   %eax,%eax
  8037d5:	74 07                	je     8037de <devpipe_read+0x77>
				return 0;
  8037d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8037dc:	eb 6d                	jmp    80384b <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8037de:	48 b8 cc 1c 80 00 00 	movabs $0x801ccc,%rax
  8037e5:	00 00 00 
  8037e8:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8037ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037ee:	8b 10                	mov    (%rax),%edx
  8037f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037f4:	8b 40 04             	mov    0x4(%rax),%eax
  8037f7:	39 c2                	cmp    %eax,%edx
  8037f9:	74 ae                	je     8037a9 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8037fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803803:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803807:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80380b:	8b 00                	mov    (%rax),%eax
  80380d:	99                   	cltd   
  80380e:	c1 ea 1b             	shr    $0x1b,%edx
  803811:	01 d0                	add    %edx,%eax
  803813:	83 e0 1f             	and    $0x1f,%eax
  803816:	29 d0                	sub    %edx,%eax
  803818:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80381c:	48 98                	cltq   
  80381e:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803823:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803825:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803829:	8b 00                	mov    (%rax),%eax
  80382b:	8d 50 01             	lea    0x1(%rax),%edx
  80382e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803832:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803834:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803839:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80383d:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803841:	0f 82 60 ff ff ff    	jb     8037a7 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803847:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80384b:	c9                   	leaveq 
  80384c:	c3                   	retq   

000000000080384d <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80384d:	55                   	push   %rbp
  80384e:	48 89 e5             	mov    %rsp,%rbp
  803851:	48 83 ec 40          	sub    $0x40,%rsp
  803855:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803859:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80385d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803861:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803865:	48 89 c7             	mov    %rax,%rdi
  803868:	48 b8 34 26 80 00 00 	movabs $0x802634,%rax
  80386f:	00 00 00 
  803872:	ff d0                	callq  *%rax
  803874:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803878:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80387c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803880:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803887:	00 
  803888:	e9 8e 00 00 00       	jmpq   80391b <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80388d:	eb 31                	jmp    8038c0 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80388f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803893:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803897:	48 89 d6             	mov    %rdx,%rsi
  80389a:	48 89 c7             	mov    %rax,%rdi
  80389d:	48 b8 30 36 80 00 00 	movabs $0x803630,%rax
  8038a4:	00 00 00 
  8038a7:	ff d0                	callq  *%rax
  8038a9:	85 c0                	test   %eax,%eax
  8038ab:	74 07                	je     8038b4 <devpipe_write+0x67>
				return 0;
  8038ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8038b2:	eb 79                	jmp    80392d <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8038b4:	48 b8 cc 1c 80 00 00 	movabs $0x801ccc,%rax
  8038bb:	00 00 00 
  8038be:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8038c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038c4:	8b 40 04             	mov    0x4(%rax),%eax
  8038c7:	48 63 d0             	movslq %eax,%rdx
  8038ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038ce:	8b 00                	mov    (%rax),%eax
  8038d0:	48 98                	cltq   
  8038d2:	48 83 c0 20          	add    $0x20,%rax
  8038d6:	48 39 c2             	cmp    %rax,%rdx
  8038d9:	73 b4                	jae    80388f <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8038db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038df:	8b 40 04             	mov    0x4(%rax),%eax
  8038e2:	99                   	cltd   
  8038e3:	c1 ea 1b             	shr    $0x1b,%edx
  8038e6:	01 d0                	add    %edx,%eax
  8038e8:	83 e0 1f             	and    $0x1f,%eax
  8038eb:	29 d0                	sub    %edx,%eax
  8038ed:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8038f1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8038f5:	48 01 ca             	add    %rcx,%rdx
  8038f8:	0f b6 0a             	movzbl (%rdx),%ecx
  8038fb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8038ff:	48 98                	cltq   
  803901:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803905:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803909:	8b 40 04             	mov    0x4(%rax),%eax
  80390c:	8d 50 01             	lea    0x1(%rax),%edx
  80390f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803913:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803916:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80391b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80391f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803923:	0f 82 64 ff ff ff    	jb     80388d <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803929:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80392d:	c9                   	leaveq 
  80392e:	c3                   	retq   

000000000080392f <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80392f:	55                   	push   %rbp
  803930:	48 89 e5             	mov    %rsp,%rbp
  803933:	48 83 ec 20          	sub    $0x20,%rsp
  803937:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80393b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80393f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803943:	48 89 c7             	mov    %rax,%rdi
  803946:	48 b8 34 26 80 00 00 	movabs $0x802634,%rax
  80394d:	00 00 00 
  803950:	ff d0                	callq  *%rax
  803952:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803956:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80395a:	48 be 2a 49 80 00 00 	movabs $0x80492a,%rsi
  803961:	00 00 00 
  803964:	48 89 c7             	mov    %rax,%rdi
  803967:	48 b8 db 13 80 00 00 	movabs $0x8013db,%rax
  80396e:	00 00 00 
  803971:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803973:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803977:	8b 50 04             	mov    0x4(%rax),%edx
  80397a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80397e:	8b 00                	mov    (%rax),%eax
  803980:	29 c2                	sub    %eax,%edx
  803982:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803986:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80398c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803990:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803997:	00 00 00 
	stat->st_dev = &devpipe;
  80399a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80399e:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  8039a5:	00 00 00 
  8039a8:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8039af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8039b4:	c9                   	leaveq 
  8039b5:	c3                   	retq   

00000000008039b6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8039b6:	55                   	push   %rbp
  8039b7:	48 89 e5             	mov    %rsp,%rbp
  8039ba:	48 83 ec 10          	sub    $0x10,%rsp
  8039be:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8039c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039c6:	48 89 c6             	mov    %rax,%rsi
  8039c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8039ce:	48 b8 b5 1d 80 00 00 	movabs $0x801db5,%rax
  8039d5:	00 00 00 
  8039d8:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8039da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039de:	48 89 c7             	mov    %rax,%rdi
  8039e1:	48 b8 34 26 80 00 00 	movabs $0x802634,%rax
  8039e8:	00 00 00 
  8039eb:	ff d0                	callq  *%rax
  8039ed:	48 89 c6             	mov    %rax,%rsi
  8039f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8039f5:	48 b8 b5 1d 80 00 00 	movabs $0x801db5,%rax
  8039fc:	00 00 00 
  8039ff:	ff d0                	callq  *%rax
}
  803a01:	c9                   	leaveq 
  803a02:	c3                   	retq   

0000000000803a03 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  803a03:	55                   	push   %rbp
  803a04:	48 89 e5             	mov    %rsp,%rbp
  803a07:	48 83 ec 20          	sub    $0x20,%rsp
  803a0b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  803a0e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a12:	75 35                	jne    803a49 <wait+0x46>
  803a14:	48 b9 31 49 80 00 00 	movabs $0x804931,%rcx
  803a1b:	00 00 00 
  803a1e:	48 ba 3c 49 80 00 00 	movabs $0x80493c,%rdx
  803a25:	00 00 00 
  803a28:	be 09 00 00 00       	mov    $0x9,%esi
  803a2d:	48 bf 51 49 80 00 00 	movabs $0x804951,%rdi
  803a34:	00 00 00 
  803a37:	b8 00 00 00 00       	mov    $0x0,%eax
  803a3c:	49 b8 ed 05 80 00 00 	movabs $0x8005ed,%r8
  803a43:	00 00 00 
  803a46:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  803a49:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a4c:	25 ff 03 00 00       	and    $0x3ff,%eax
  803a51:	48 63 d0             	movslq %eax,%rdx
  803a54:	48 89 d0             	mov    %rdx,%rax
  803a57:	48 c1 e0 03          	shl    $0x3,%rax
  803a5b:	48 01 d0             	add    %rdx,%rax
  803a5e:	48 c1 e0 05          	shl    $0x5,%rax
  803a62:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803a69:	00 00 00 
  803a6c:	48 01 d0             	add    %rdx,%rax
  803a6f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE){
  803a73:	eb 0c                	jmp    803a81 <wait+0x7e>
	//cprintf("envid is [%d]",envid);
		sys_yield();
  803a75:	48 b8 cc 1c 80 00 00 	movabs $0x801ccc,%rax
  803a7c:	00 00 00 
  803a7f:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE){
  803a81:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a85:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803a8b:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803a8e:	75 0e                	jne    803a9e <wait+0x9b>
  803a90:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a94:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803a9a:	85 c0                	test   %eax,%eax
  803a9c:	75 d7                	jne    803a75 <wait+0x72>
	//cprintf("envid is [%d]",envid);
		sys_yield();
	}
}
  803a9e:	c9                   	leaveq 
  803a9f:	c3                   	retq   

0000000000803aa0 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803aa0:	55                   	push   %rbp
  803aa1:	48 89 e5             	mov    %rsp,%rbp
  803aa4:	48 83 ec 20          	sub    $0x20,%rsp
  803aa8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803aab:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803aae:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803ab1:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803ab5:	be 01 00 00 00       	mov    $0x1,%esi
  803aba:	48 89 c7             	mov    %rax,%rdi
  803abd:	48 b8 c2 1b 80 00 00 	movabs $0x801bc2,%rax
  803ac4:	00 00 00 
  803ac7:	ff d0                	callq  *%rax
}
  803ac9:	c9                   	leaveq 
  803aca:	c3                   	retq   

0000000000803acb <getchar>:

int
getchar(void)
{
  803acb:	55                   	push   %rbp
  803acc:	48 89 e5             	mov    %rsp,%rbp
  803acf:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803ad3:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803ad7:	ba 01 00 00 00       	mov    $0x1,%edx
  803adc:	48 89 c6             	mov    %rax,%rsi
  803adf:	bf 00 00 00 00       	mov    $0x0,%edi
  803ae4:	48 b8 29 2b 80 00 00 	movabs $0x802b29,%rax
  803aeb:	00 00 00 
  803aee:	ff d0                	callq  *%rax
  803af0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803af3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803af7:	79 05                	jns    803afe <getchar+0x33>
		return r;
  803af9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803afc:	eb 14                	jmp    803b12 <getchar+0x47>
	if (r < 1)
  803afe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b02:	7f 07                	jg     803b0b <getchar+0x40>
		return -E_EOF;
  803b04:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803b09:	eb 07                	jmp    803b12 <getchar+0x47>
	return c;
  803b0b:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803b0f:	0f b6 c0             	movzbl %al,%eax
}
  803b12:	c9                   	leaveq 
  803b13:	c3                   	retq   

0000000000803b14 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803b14:	55                   	push   %rbp
  803b15:	48 89 e5             	mov    %rsp,%rbp
  803b18:	48 83 ec 20          	sub    $0x20,%rsp
  803b1c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803b1f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803b23:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b26:	48 89 d6             	mov    %rdx,%rsi
  803b29:	89 c7                	mov    %eax,%edi
  803b2b:	48 b8 f7 26 80 00 00 	movabs $0x8026f7,%rax
  803b32:	00 00 00 
  803b35:	ff d0                	callq  *%rax
  803b37:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b3a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b3e:	79 05                	jns    803b45 <iscons+0x31>
		return r;
  803b40:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b43:	eb 1a                	jmp    803b5f <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803b45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b49:	8b 10                	mov    (%rax),%edx
  803b4b:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  803b52:	00 00 00 
  803b55:	8b 00                	mov    (%rax),%eax
  803b57:	39 c2                	cmp    %eax,%edx
  803b59:	0f 94 c0             	sete   %al
  803b5c:	0f b6 c0             	movzbl %al,%eax
}
  803b5f:	c9                   	leaveq 
  803b60:	c3                   	retq   

0000000000803b61 <opencons>:

int
opencons(void)
{
  803b61:	55                   	push   %rbp
  803b62:	48 89 e5             	mov    %rsp,%rbp
  803b65:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803b69:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803b6d:	48 89 c7             	mov    %rax,%rdi
  803b70:	48 b8 5f 26 80 00 00 	movabs $0x80265f,%rax
  803b77:	00 00 00 
  803b7a:	ff d0                	callq  *%rax
  803b7c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b7f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b83:	79 05                	jns    803b8a <opencons+0x29>
		return r;
  803b85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b88:	eb 5b                	jmp    803be5 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803b8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b8e:	ba 07 04 00 00       	mov    $0x407,%edx
  803b93:	48 89 c6             	mov    %rax,%rsi
  803b96:	bf 00 00 00 00       	mov    $0x0,%edi
  803b9b:	48 b8 0a 1d 80 00 00 	movabs $0x801d0a,%rax
  803ba2:	00 00 00 
  803ba5:	ff d0                	callq  *%rax
  803ba7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803baa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bae:	79 05                	jns    803bb5 <opencons+0x54>
		return r;
  803bb0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bb3:	eb 30                	jmp    803be5 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803bb5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bb9:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803bc0:	00 00 00 
  803bc3:	8b 12                	mov    (%rdx),%edx
  803bc5:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803bc7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bcb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803bd2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bd6:	48 89 c7             	mov    %rax,%rdi
  803bd9:	48 b8 11 26 80 00 00 	movabs $0x802611,%rax
  803be0:	00 00 00 
  803be3:	ff d0                	callq  *%rax
}
  803be5:	c9                   	leaveq 
  803be6:	c3                   	retq   

0000000000803be7 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803be7:	55                   	push   %rbp
  803be8:	48 89 e5             	mov    %rsp,%rbp
  803beb:	48 83 ec 30          	sub    $0x30,%rsp
  803bef:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803bf3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803bf7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803bfb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803c00:	75 07                	jne    803c09 <devcons_read+0x22>
		return 0;
  803c02:	b8 00 00 00 00       	mov    $0x0,%eax
  803c07:	eb 4b                	jmp    803c54 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803c09:	eb 0c                	jmp    803c17 <devcons_read+0x30>
		sys_yield();
  803c0b:	48 b8 cc 1c 80 00 00 	movabs $0x801ccc,%rax
  803c12:	00 00 00 
  803c15:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803c17:	48 b8 0c 1c 80 00 00 	movabs $0x801c0c,%rax
  803c1e:	00 00 00 
  803c21:	ff d0                	callq  *%rax
  803c23:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c26:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c2a:	74 df                	je     803c0b <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803c2c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c30:	79 05                	jns    803c37 <devcons_read+0x50>
		return c;
  803c32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c35:	eb 1d                	jmp    803c54 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803c37:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803c3b:	75 07                	jne    803c44 <devcons_read+0x5d>
		return 0;
  803c3d:	b8 00 00 00 00       	mov    $0x0,%eax
  803c42:	eb 10                	jmp    803c54 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803c44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c47:	89 c2                	mov    %eax,%edx
  803c49:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c4d:	88 10                	mov    %dl,(%rax)
	return 1;
  803c4f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803c54:	c9                   	leaveq 
  803c55:	c3                   	retq   

0000000000803c56 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803c56:	55                   	push   %rbp
  803c57:	48 89 e5             	mov    %rsp,%rbp
  803c5a:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803c61:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803c68:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803c6f:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803c76:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803c7d:	eb 76                	jmp    803cf5 <devcons_write+0x9f>
		m = n - tot;
  803c7f:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803c86:	89 c2                	mov    %eax,%edx
  803c88:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c8b:	29 c2                	sub    %eax,%edx
  803c8d:	89 d0                	mov    %edx,%eax
  803c8f:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803c92:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c95:	83 f8 7f             	cmp    $0x7f,%eax
  803c98:	76 07                	jbe    803ca1 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803c9a:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803ca1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ca4:	48 63 d0             	movslq %eax,%rdx
  803ca7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803caa:	48 63 c8             	movslq %eax,%rcx
  803cad:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803cb4:	48 01 c1             	add    %rax,%rcx
  803cb7:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803cbe:	48 89 ce             	mov    %rcx,%rsi
  803cc1:	48 89 c7             	mov    %rax,%rdi
  803cc4:	48 b8 ff 16 80 00 00 	movabs $0x8016ff,%rax
  803ccb:	00 00 00 
  803cce:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803cd0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803cd3:	48 63 d0             	movslq %eax,%rdx
  803cd6:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803cdd:	48 89 d6             	mov    %rdx,%rsi
  803ce0:	48 89 c7             	mov    %rax,%rdi
  803ce3:	48 b8 c2 1b 80 00 00 	movabs $0x801bc2,%rax
  803cea:	00 00 00 
  803ced:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803cef:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803cf2:	01 45 fc             	add    %eax,-0x4(%rbp)
  803cf5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cf8:	48 98                	cltq   
  803cfa:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803d01:	0f 82 78 ff ff ff    	jb     803c7f <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803d07:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803d0a:	c9                   	leaveq 
  803d0b:	c3                   	retq   

0000000000803d0c <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803d0c:	55                   	push   %rbp
  803d0d:	48 89 e5             	mov    %rsp,%rbp
  803d10:	48 83 ec 08          	sub    $0x8,%rsp
  803d14:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803d18:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d1d:	c9                   	leaveq 
  803d1e:	c3                   	retq   

0000000000803d1f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803d1f:	55                   	push   %rbp
  803d20:	48 89 e5             	mov    %rsp,%rbp
  803d23:	48 83 ec 10          	sub    $0x10,%rsp
  803d27:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803d2b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803d2f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d33:	48 be 61 49 80 00 00 	movabs $0x804961,%rsi
  803d3a:	00 00 00 
  803d3d:	48 89 c7             	mov    %rax,%rdi
  803d40:	48 b8 db 13 80 00 00 	movabs $0x8013db,%rax
  803d47:	00 00 00 
  803d4a:	ff d0                	callq  *%rax
	return 0;
  803d4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d51:	c9                   	leaveq 
  803d52:	c3                   	retq   

0000000000803d53 <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803d53:	55                   	push   %rbp
  803d54:	48 89 e5             	mov    %rsp,%rbp
  803d57:	48 83 ec 10          	sub    $0x10,%rsp
  803d5b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  803d5f:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803d66:	00 00 00 
  803d69:	48 8b 00             	mov    (%rax),%rax
  803d6c:	48 85 c0             	test   %rax,%rax
  803d6f:	0f 85 84 00 00 00    	jne    803df9 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  803d75:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803d7c:	00 00 00 
  803d7f:	48 8b 00             	mov    (%rax),%rax
  803d82:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803d88:	ba 07 00 00 00       	mov    $0x7,%edx
  803d8d:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803d92:	89 c7                	mov    %eax,%edi
  803d94:	48 b8 0a 1d 80 00 00 	movabs $0x801d0a,%rax
  803d9b:	00 00 00 
  803d9e:	ff d0                	callq  *%rax
  803da0:	85 c0                	test   %eax,%eax
  803da2:	79 2a                	jns    803dce <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  803da4:	48 ba 68 49 80 00 00 	movabs $0x804968,%rdx
  803dab:	00 00 00 
  803dae:	be 23 00 00 00       	mov    $0x23,%esi
  803db3:	48 bf 8f 49 80 00 00 	movabs $0x80498f,%rdi
  803dba:	00 00 00 
  803dbd:	b8 00 00 00 00       	mov    $0x0,%eax
  803dc2:	48 b9 ed 05 80 00 00 	movabs $0x8005ed,%rcx
  803dc9:	00 00 00 
  803dcc:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  803dce:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803dd5:	00 00 00 
  803dd8:	48 8b 00             	mov    (%rax),%rax
  803ddb:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803de1:	48 be 0c 3e 80 00 00 	movabs $0x803e0c,%rsi
  803de8:	00 00 00 
  803deb:	89 c7                	mov    %eax,%edi
  803ded:	48 b8 94 1e 80 00 00 	movabs $0x801e94,%rax
  803df4:	00 00 00 
  803df7:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  803df9:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803e00:	00 00 00 
  803e03:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803e07:	48 89 10             	mov    %rdx,(%rax)
}
  803e0a:	c9                   	leaveq 
  803e0b:	c3                   	retq   

0000000000803e0c <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  803e0c:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  803e0f:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  803e16:	00 00 00 
	call *%rax
  803e19:	ff d0                	callq  *%rax


	/*This code is to be removed*/

	// LAB 4: Your code here.
	movq 136(%rsp), %rbx  //Load RIP 
  803e1b:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  803e22:	00 
	movq 152(%rsp), %rcx  //Load RSP
  803e23:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  803e2a:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  803e2b:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  803e2f:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  803e32:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  803e39:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  803e3a:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  803e3e:	4c 8b 3c 24          	mov    (%rsp),%r15
  803e42:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803e47:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803e4c:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803e51:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803e56:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803e5b:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803e60:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803e65:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803e6a:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803e6f:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803e74:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803e79:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803e7e:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803e83:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803e88:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  803e8c:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  803e90:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  803e91:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  803e92:	c3                   	retq   

0000000000803e93 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803e93:	55                   	push   %rbp
  803e94:	48 89 e5             	mov    %rsp,%rbp
  803e97:	48 83 ec 30          	sub    $0x30,%rsp
  803e9b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803e9f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803ea3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803ea7:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803eae:	00 00 00 
  803eb1:	48 8b 00             	mov    (%rax),%rax
  803eb4:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803eba:	85 c0                	test   %eax,%eax
  803ebc:	75 3c                	jne    803efa <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  803ebe:	48 b8 8e 1c 80 00 00 	movabs $0x801c8e,%rax
  803ec5:	00 00 00 
  803ec8:	ff d0                	callq  *%rax
  803eca:	25 ff 03 00 00       	and    $0x3ff,%eax
  803ecf:	48 63 d0             	movslq %eax,%rdx
  803ed2:	48 89 d0             	mov    %rdx,%rax
  803ed5:	48 c1 e0 03          	shl    $0x3,%rax
  803ed9:	48 01 d0             	add    %rdx,%rax
  803edc:	48 c1 e0 05          	shl    $0x5,%rax
  803ee0:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803ee7:	00 00 00 
  803eea:	48 01 c2             	add    %rax,%rdx
  803eed:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803ef4:	00 00 00 
  803ef7:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803efa:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803eff:	75 0e                	jne    803f0f <ipc_recv+0x7c>
		pg = (void*) UTOP;
  803f01:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803f08:	00 00 00 
  803f0b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803f0f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f13:	48 89 c7             	mov    %rax,%rdi
  803f16:	48 b8 33 1f 80 00 00 	movabs $0x801f33,%rax
  803f1d:	00 00 00 
  803f20:	ff d0                	callq  *%rax
  803f22:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803f25:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f29:	79 19                	jns    803f44 <ipc_recv+0xb1>
		*from_env_store = 0;
  803f2b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f2f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803f35:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f39:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803f3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f42:	eb 53                	jmp    803f97 <ipc_recv+0x104>
	}
	if(from_env_store)
  803f44:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803f49:	74 19                	je     803f64 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  803f4b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f52:	00 00 00 
  803f55:	48 8b 00             	mov    (%rax),%rax
  803f58:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803f5e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f62:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803f64:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803f69:	74 19                	je     803f84 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  803f6b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f72:	00 00 00 
  803f75:	48 8b 00             	mov    (%rax),%rax
  803f78:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803f7e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f82:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803f84:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f8b:	00 00 00 
  803f8e:	48 8b 00             	mov    (%rax),%rax
  803f91:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803f97:	c9                   	leaveq 
  803f98:	c3                   	retq   

0000000000803f99 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803f99:	55                   	push   %rbp
  803f9a:	48 89 e5             	mov    %rsp,%rbp
  803f9d:	48 83 ec 30          	sub    $0x30,%rsp
  803fa1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803fa4:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803fa7:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803fab:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803fae:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803fb3:	75 0e                	jne    803fc3 <ipc_send+0x2a>
		pg = (void*)UTOP;
  803fb5:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803fbc:	00 00 00 
  803fbf:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  803fc3:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803fc6:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803fc9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803fcd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fd0:	89 c7                	mov    %eax,%edi
  803fd2:	48 b8 de 1e 80 00 00 	movabs $0x801ede,%rax
  803fd9:	00 00 00 
  803fdc:	ff d0                	callq  *%rax
  803fde:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  803fe1:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803fe5:	75 0c                	jne    803ff3 <ipc_send+0x5a>
			sys_yield();
  803fe7:	48 b8 cc 1c 80 00 00 	movabs $0x801ccc,%rax
  803fee:	00 00 00 
  803ff1:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  803ff3:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803ff7:	74 ca                	je     803fc3 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  803ff9:	c9                   	leaveq 
  803ffa:	c3                   	retq   

0000000000803ffb <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803ffb:	55                   	push   %rbp
  803ffc:	48 89 e5             	mov    %rsp,%rbp
  803fff:	48 83 ec 14          	sub    $0x14,%rsp
  804003:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  804006:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80400d:	eb 5e                	jmp    80406d <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  80400f:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804016:	00 00 00 
  804019:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80401c:	48 63 d0             	movslq %eax,%rdx
  80401f:	48 89 d0             	mov    %rdx,%rax
  804022:	48 c1 e0 03          	shl    $0x3,%rax
  804026:	48 01 d0             	add    %rdx,%rax
  804029:	48 c1 e0 05          	shl    $0x5,%rax
  80402d:	48 01 c8             	add    %rcx,%rax
  804030:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804036:	8b 00                	mov    (%rax),%eax
  804038:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80403b:	75 2c                	jne    804069 <ipc_find_env+0x6e>
			return envs[i].env_id;
  80403d:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804044:	00 00 00 
  804047:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80404a:	48 63 d0             	movslq %eax,%rdx
  80404d:	48 89 d0             	mov    %rdx,%rax
  804050:	48 c1 e0 03          	shl    $0x3,%rax
  804054:	48 01 d0             	add    %rdx,%rax
  804057:	48 c1 e0 05          	shl    $0x5,%rax
  80405b:	48 01 c8             	add    %rcx,%rax
  80405e:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804064:	8b 40 08             	mov    0x8(%rax),%eax
  804067:	eb 12                	jmp    80407b <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  804069:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80406d:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804074:	7e 99                	jle    80400f <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  804076:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80407b:	c9                   	leaveq 
  80407c:	c3                   	retq   

000000000080407d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80407d:	55                   	push   %rbp
  80407e:	48 89 e5             	mov    %rsp,%rbp
  804081:	48 83 ec 18          	sub    $0x18,%rsp
  804085:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804089:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80408d:	48 c1 e8 15          	shr    $0x15,%rax
  804091:	48 89 c2             	mov    %rax,%rdx
  804094:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80409b:	01 00 00 
  80409e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8040a2:	83 e0 01             	and    $0x1,%eax
  8040a5:	48 85 c0             	test   %rax,%rax
  8040a8:	75 07                	jne    8040b1 <pageref+0x34>
		return 0;
  8040aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8040af:	eb 53                	jmp    804104 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8040b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040b5:	48 c1 e8 0c          	shr    $0xc,%rax
  8040b9:	48 89 c2             	mov    %rax,%rdx
  8040bc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8040c3:	01 00 00 
  8040c6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8040ca:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8040ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040d2:	83 e0 01             	and    $0x1,%eax
  8040d5:	48 85 c0             	test   %rax,%rax
  8040d8:	75 07                	jne    8040e1 <pageref+0x64>
		return 0;
  8040da:	b8 00 00 00 00       	mov    $0x0,%eax
  8040df:	eb 23                	jmp    804104 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8040e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040e5:	48 c1 e8 0c          	shr    $0xc,%rax
  8040e9:	48 89 c2             	mov    %rax,%rdx
  8040ec:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8040f3:	00 00 00 
  8040f6:	48 c1 e2 04          	shl    $0x4,%rdx
  8040fa:	48 01 d0             	add    %rdx,%rax
  8040fd:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804101:	0f b7 c0             	movzwl %ax,%eax
}
  804104:	c9                   	leaveq 
  804105:	c3                   	retq   
