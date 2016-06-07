
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
  80005c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800063:	00 00 00 
  800066:	48 bb 04 4c 80 00 00 	movabs $0x804c04,%rbx
  80006d:	00 00 00 
  800070:	48 89 18             	mov    %rbx,(%rax)

	if ((i = pipe(p)) < 0)
  800073:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80007a:	48 89 c7             	mov    %rax,%rdi
  80007d:	48 b8 eb 3e 80 00 00 	movabs $0x803eeb,%rax
  800084:	00 00 00 
  800087:	ff d0                	callq  *%rax
  800089:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80008c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800090:	79 30                	jns    8000c2 <umain+0x7f>
		panic("pipe: %e", i);
  800092:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800095:	89 c1                	mov    %eax,%ecx
  800097:	48 ba 10 4c 80 00 00 	movabs $0x804c10,%rdx
  80009e:	00 00 00 
  8000a1:	be 0e 00 00 00       	mov    $0xe,%esi
  8000a6:	48 bf 19 4c 80 00 00 	movabs $0x804c19,%rdi
  8000ad:	00 00 00 
  8000b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b5:	49 b8 ed 05 80 00 00 	movabs $0x8005ed,%r8
  8000bc:	00 00 00 
  8000bf:	41 ff d0             	callq  *%r8

	if ((pid = fork()) < 0)
  8000c2:	48 b8 2a 24 80 00 00 	movabs $0x80242a,%rax
  8000c9:	00 00 00 
  8000cc:	ff d0                	callq  *%rax
  8000ce:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8000d1:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8000d5:	79 30                	jns    800107 <umain+0xc4>
		panic("fork: %e", i);
  8000d7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000da:	89 c1                	mov    %eax,%ecx
  8000dc:	48 ba 29 4c 80 00 00 	movabs $0x804c29,%rdx
  8000e3:	00 00 00 
  8000e6:	be 11 00 00 00       	mov    $0x11,%esi
  8000eb:	48 bf 19 4c 80 00 00 	movabs $0x804c19,%rdi
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
  800117:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80011e:	00 00 00 
  800121:	48 8b 00             	mov    (%rax),%rax
  800124:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80012a:	89 c6                	mov    %eax,%esi
  80012c:	48 bf 32 4c 80 00 00 	movabs $0x804c32,%rdi
  800133:	00 00 00 
  800136:	b8 00 00 00 00       	mov    $0x0,%eax
  80013b:	48 b9 26 08 80 00 00 	movabs $0x800826,%rcx
  800142:	00 00 00 
  800145:	ff d1                	callq  *%rcx
		close(p[1]);
  800147:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  80014d:	89 c7                	mov    %eax,%edi
  80014f:	48 b8 d1 29 80 00 00 	movabs $0x8029d1,%rax
  800156:	00 00 00 
  800159:	ff d0                	callq  *%rax
		cprintf("[%08x] pipereadeof readn %d\n", thisenv->env_id, p[0]);
  80015b:	8b 95 70 ff ff ff    	mov    -0x90(%rbp),%edx
  800161:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  800168:	00 00 00 
  80016b:	48 8b 00             	mov    (%rax),%rax
  80016e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800174:	89 c6                	mov    %eax,%esi
  800176:	48 bf 4f 4c 80 00 00 	movabs $0x804c4f,%rdi
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
  8001a5:	48 b8 c8 2c 80 00 00 	movabs $0x802cc8,%rax
  8001ac:	00 00 00 
  8001af:	ff d0                	callq  *%rax
  8001b1:	89 45 ec             	mov    %eax,-0x14(%rbp)
		if (i < 0)
  8001b4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8001b8:	79 30                	jns    8001ea <umain+0x1a7>
			panic("read: %e", i);
  8001ba:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001bd:	89 c1                	mov    %eax,%ecx
  8001bf:	48 ba 6c 4c 80 00 00 	movabs $0x804c6c,%rdx
  8001c6:	00 00 00 
  8001c9:	be 19 00 00 00       	mov    $0x19,%esi
  8001ce:	48 bf 19 4c 80 00 00 	movabs $0x804c19,%rdi
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
  8001f4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
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
  80021b:	48 bf 75 4c 80 00 00 	movabs $0x804c75,%rdi
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
  800241:	48 bf 91 4c 80 00 00 	movabs $0x804c91,%rdi
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
  800273:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80027a:	00 00 00 
  80027d:	48 8b 00             	mov    (%rax),%rax
  800280:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800286:	89 c6                	mov    %eax,%esi
  800288:	48 bf 32 4c 80 00 00 	movabs $0x804c32,%rdi
  80028f:	00 00 00 
  800292:	b8 00 00 00 00       	mov    $0x0,%eax
  800297:	48 b9 26 08 80 00 00 	movabs $0x800826,%rcx
  80029e:	00 00 00 
  8002a1:	ff d1                	callq  *%rcx
		close(p[0]);
  8002a3:	8b 85 70 ff ff ff    	mov    -0x90(%rbp),%eax
  8002a9:	89 c7                	mov    %eax,%edi
  8002ab:	48 b8 d1 29 80 00 00 	movabs $0x8029d1,%rax
  8002b2:	00 00 00 
  8002b5:	ff d0                	callq  *%rax
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
  8002b7:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  8002bd:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8002c4:	00 00 00 
  8002c7:	48 8b 00             	mov    (%rax),%rax
  8002ca:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8002d0:	89 c6                	mov    %eax,%esi
  8002d2:	48 bf a4 4c 80 00 00 	movabs $0x804ca4,%rdi
  8002d9:	00 00 00 
  8002dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8002e1:	48 b9 26 08 80 00 00 	movabs $0x800826,%rcx
  8002e8:	00 00 00 
  8002eb:	ff d1                	callq  *%rcx
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
  8002ed:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8002f4:	00 00 00 
  8002f7:	48 8b 00             	mov    (%rax),%rax
  8002fa:	48 89 c7             	mov    %rax,%rdi
  8002fd:	48 b8 6f 13 80 00 00 	movabs $0x80136f,%rax
  800304:	00 00 00 
  800307:	ff d0                	callq  *%rax
  800309:	48 63 d0             	movslq %eax,%rdx
  80030c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800313:	00 00 00 
  800316:	48 8b 08             	mov    (%rax),%rcx
  800319:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  80031f:	48 89 ce             	mov    %rcx,%rsi
  800322:	89 c7                	mov    %eax,%edi
  800324:	48 b8 3d 2d 80 00 00 	movabs $0x802d3d,%rax
  80032b:	00 00 00 
  80032e:	ff d0                	callq  *%rax
  800330:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800333:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
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
  800359:	48 ba c1 4c 80 00 00 	movabs $0x804cc1,%rdx
  800360:	00 00 00 
  800363:	be 25 00 00 00       	mov    $0x25,%esi
  800368:	48 bf 19 4c 80 00 00 	movabs $0x804c19,%rdi
  80036f:	00 00 00 
  800372:	b8 00 00 00 00       	mov    $0x0,%eax
  800377:	49 b8 ed 05 80 00 00 	movabs $0x8005ed,%r8
  80037e:	00 00 00 
  800381:	41 ff d0             	callq  *%r8
		close(p[1]);
  800384:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  80038a:	89 c7                	mov    %eax,%edi
  80038c:	48 b8 d1 29 80 00 00 	movabs $0x8029d1,%rax
  800393:	00 00 00 
  800396:	ff d0                	callq  *%rax
	}
	wait(pid);
  800398:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80039b:	89 c7                	mov    %eax,%edi
  80039d:	48 b8 b4 44 80 00 00 	movabs $0x8044b4,%rax
  8003a4:	00 00 00 
  8003a7:	ff d0                	callq  *%rax

	binaryname = "pipewriteeof";
  8003a9:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8003b0:	00 00 00 
  8003b3:	48 bb cb 4c 80 00 00 	movabs $0x804ccb,%rbx
  8003ba:	00 00 00 
  8003bd:	48 89 18             	mov    %rbx,(%rax)
	if ((i = pipe(p)) < 0)
  8003c0:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8003c7:	48 89 c7             	mov    %rax,%rdi
  8003ca:	48 b8 eb 3e 80 00 00 	movabs $0x803eeb,%rax
  8003d1:	00 00 00 
  8003d4:	ff d0                	callq  *%rax
  8003d6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8003d9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8003dd:	79 30                	jns    80040f <umain+0x3cc>
		panic("pipe: %e", i);
  8003df:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8003e2:	89 c1                	mov    %eax,%ecx
  8003e4:	48 ba 10 4c 80 00 00 	movabs $0x804c10,%rdx
  8003eb:	00 00 00 
  8003ee:	be 2c 00 00 00       	mov    $0x2c,%esi
  8003f3:	48 bf 19 4c 80 00 00 	movabs $0x804c19,%rdi
  8003fa:	00 00 00 
  8003fd:	b8 00 00 00 00       	mov    $0x0,%eax
  800402:	49 b8 ed 05 80 00 00 	movabs $0x8005ed,%r8
  800409:	00 00 00 
  80040c:	41 ff d0             	callq  *%r8

	if ((pid = fork()) < 0)
  80040f:	48 b8 2a 24 80 00 00 	movabs $0x80242a,%rax
  800416:	00 00 00 
  800419:	ff d0                	callq  *%rax
  80041b:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80041e:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800422:	79 30                	jns    800454 <umain+0x411>
		panic("fork: %e", i);
  800424:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800427:	89 c1                	mov    %eax,%ecx
  800429:	48 ba 29 4c 80 00 00 	movabs $0x804c29,%rdx
  800430:	00 00 00 
  800433:	be 2f 00 00 00       	mov    $0x2f,%esi
  800438:	48 bf 19 4c 80 00 00 	movabs $0x804c19,%rdi
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
  800466:	48 b8 d1 29 80 00 00 	movabs $0x8029d1,%rax
  80046d:	00 00 00 
  800470:	ff d0                	callq  *%rax
		while (1) {
			cprintf(".");
  800472:	48 bf d8 4c 80 00 00 	movabs $0x804cd8,%rdi
  800479:	00 00 00 
  80047c:	b8 00 00 00 00       	mov    $0x0,%eax
  800481:	48 ba 26 08 80 00 00 	movabs $0x800826,%rdx
  800488:	00 00 00 
  80048b:	ff d2                	callq  *%rdx
			if (write(p[1], "x", 1) != 1)
  80048d:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  800493:	ba 01 00 00 00       	mov    $0x1,%edx
  800498:	48 be da 4c 80 00 00 	movabs $0x804cda,%rsi
  80049f:	00 00 00 
  8004a2:	89 c7                	mov    %eax,%edi
  8004a4:	48 b8 3d 2d 80 00 00 	movabs $0x802d3d,%rax
  8004ab:	00 00 00 
  8004ae:	ff d0                	callq  *%rax
  8004b0:	83 f8 01             	cmp    $0x1,%eax
  8004b3:	74 2a                	je     8004df <umain+0x49c>
				break;
  8004b5:	90                   	nop
		}
		cprintf("\npipe write closed properly\n");
  8004b6:	48 bf dc 4c 80 00 00 	movabs $0x804cdc,%rdi
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
  8004e9:	48 b8 d1 29 80 00 00 	movabs $0x8029d1,%rax
  8004f0:	00 00 00 
  8004f3:	ff d0                	callq  *%rax
	close(p[1]);
  8004f5:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  8004fb:	89 c7                	mov    %eax,%edi
  8004fd:	48 b8 d1 29 80 00 00 	movabs $0x8029d1,%rax
  800504:	00 00 00 
  800507:	ff d0                	callq  *%rax
	wait(pid);
  800509:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80050c:	89 c7                	mov    %eax,%edi
  80050e:	48 b8 b4 44 80 00 00 	movabs $0x8044b4,%rax
  800515:	00 00 00 
  800518:	ff d0                	callq  *%rax

	cprintf("pipe tests passed\n");
  80051a:	48 bf f9 4c 80 00 00 	movabs $0x804cf9,%rdi
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
  80057d:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
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
  800597:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
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
  8005ce:	48 b8 1c 2a 80 00 00 	movabs $0x802a1c,%rax
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
  800676:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
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
  8006a7:	48 bf 18 4d 80 00 00 	movabs $0x804d18,%rdi
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
  8006e3:	48 bf 3b 4d 80 00 00 	movabs $0x804d3b,%rdi
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
  800992:	48 ba 30 4f 80 00 00 	movabs $0x804f30,%rdx
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
  800c8a:	48 b8 58 4f 80 00 00 	movabs $0x804f58,%rax
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
  800dd8:	83 fb 15             	cmp    $0x15,%ebx
  800ddb:	7f 16                	jg     800df3 <vprintfmt+0x21a>
  800ddd:	48 b8 80 4e 80 00 00 	movabs $0x804e80,%rax
  800de4:	00 00 00 
  800de7:	48 63 d3             	movslq %ebx,%rdx
  800dea:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800dee:	4d 85 e4             	test   %r12,%r12
  800df1:	75 2e                	jne    800e21 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800df3:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800df7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dfb:	89 d9                	mov    %ebx,%ecx
  800dfd:	48 ba 41 4f 80 00 00 	movabs $0x804f41,%rdx
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
  800e2c:	48 ba 4a 4f 80 00 00 	movabs $0x804f4a,%rdx
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
  800e86:	49 bc 4d 4f 80 00 00 	movabs $0x804f4d,%r12
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
  801b8c:	48 ba 08 52 80 00 00 	movabs $0x805208,%rdx
  801b93:	00 00 00 
  801b96:	be 23 00 00 00       	mov    $0x23,%esi
  801b9b:	48 bf 25 52 80 00 00 	movabs $0x805225,%rdi
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

0000000000801f77 <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801f77:	55                   	push   %rbp
  801f78:	48 89 e5             	mov    %rsp,%rbp
  801f7b:	48 83 ec 20          	sub    $0x20,%rsp
  801f7f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801f83:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, (uint64_t)buf, len, 0, 0, 0, 0);
  801f87:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f8b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f8f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f96:	00 
  801f97:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f9d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fa3:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fa8:	89 c6                	mov    %eax,%esi
  801faa:	bf 0f 00 00 00       	mov    $0xf,%edi
  801faf:	48 b8 34 1b 80 00 00 	movabs $0x801b34,%rax
  801fb6:	00 00 00 
  801fb9:	ff d0                	callq  *%rax
}
  801fbb:	c9                   	leaveq 
  801fbc:	c3                   	retq   

0000000000801fbd <sys_net_rx>:

int
sys_net_rx(void *buf, size_t len)
{
  801fbd:	55                   	push   %rbp
  801fbe:	48 89 e5             	mov    %rsp,%rbp
  801fc1:	48 83 ec 20          	sub    $0x20,%rsp
  801fc5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801fc9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_rx, (uint64_t)buf, len, 0, 0, 0, 0);
  801fcd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fd1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fd5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fdc:	00 
  801fdd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fe3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fe9:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fee:	89 c6                	mov    %eax,%esi
  801ff0:	bf 10 00 00 00       	mov    $0x10,%edi
  801ff5:	48 b8 34 1b 80 00 00 	movabs $0x801b34,%rax
  801ffc:	00 00 00 
  801fff:	ff d0                	callq  *%rax
}
  802001:	c9                   	leaveq 
  802002:	c3                   	retq   

0000000000802003 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  802003:	55                   	push   %rbp
  802004:	48 89 e5             	mov    %rsp,%rbp
  802007:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  80200b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802012:	00 
  802013:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802019:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80201f:	b9 00 00 00 00       	mov    $0x0,%ecx
  802024:	ba 00 00 00 00       	mov    $0x0,%edx
  802029:	be 00 00 00 00       	mov    $0x0,%esi
  80202e:	bf 0e 00 00 00       	mov    $0xe,%edi
  802033:	48 b8 34 1b 80 00 00 	movabs $0x801b34,%rax
  80203a:	00 00 00 
  80203d:	ff d0                	callq  *%rax
}
  80203f:	c9                   	leaveq 
  802040:	c3                   	retq   

0000000000802041 <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  802041:	55                   	push   %rbp
  802042:	48 89 e5             	mov    %rsp,%rbp
  802045:	48 83 ec 30          	sub    $0x30,%rsp
  802049:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  80204d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802051:	48 8b 00             	mov    (%rax),%rax
  802054:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  802058:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80205c:	48 8b 40 08          	mov    0x8(%rax),%rax
  802060:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  802063:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802066:	83 e0 02             	and    $0x2,%eax
  802069:	85 c0                	test   %eax,%eax
  80206b:	75 4d                	jne    8020ba <pgfault+0x79>
  80206d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802071:	48 c1 e8 0c          	shr    $0xc,%rax
  802075:	48 89 c2             	mov    %rax,%rdx
  802078:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80207f:	01 00 00 
  802082:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802086:	25 00 08 00 00       	and    $0x800,%eax
  80208b:	48 85 c0             	test   %rax,%rax
  80208e:	74 2a                	je     8020ba <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  802090:	48 ba 38 52 80 00 00 	movabs $0x805238,%rdx
  802097:	00 00 00 
  80209a:	be 23 00 00 00       	mov    $0x23,%esi
  80209f:	48 bf 6d 52 80 00 00 	movabs $0x80526d,%rdi
  8020a6:	00 00 00 
  8020a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ae:	48 b9 ed 05 80 00 00 	movabs $0x8005ed,%rcx
  8020b5:	00 00 00 
  8020b8:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  8020ba:	ba 07 00 00 00       	mov    $0x7,%edx
  8020bf:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8020c4:	bf 00 00 00 00       	mov    $0x0,%edi
  8020c9:	48 b8 0a 1d 80 00 00 	movabs $0x801d0a,%rax
  8020d0:	00 00 00 
  8020d3:	ff d0                	callq  *%rax
  8020d5:	85 c0                	test   %eax,%eax
  8020d7:	0f 85 cd 00 00 00    	jne    8021aa <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  8020dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020e1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8020e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020e9:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8020ef:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  8020f3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020f7:	ba 00 10 00 00       	mov    $0x1000,%edx
  8020fc:	48 89 c6             	mov    %rax,%rsi
  8020ff:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802104:	48 b8 ff 16 80 00 00 	movabs $0x8016ff,%rax
  80210b:	00 00 00 
  80210e:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  802110:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802114:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80211a:	48 89 c1             	mov    %rax,%rcx
  80211d:	ba 00 00 00 00       	mov    $0x0,%edx
  802122:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802127:	bf 00 00 00 00       	mov    $0x0,%edi
  80212c:	48 b8 5a 1d 80 00 00 	movabs $0x801d5a,%rax
  802133:	00 00 00 
  802136:	ff d0                	callq  *%rax
  802138:	85 c0                	test   %eax,%eax
  80213a:	79 2a                	jns    802166 <pgfault+0x125>
				panic("Page map at temp address failed");
  80213c:	48 ba 78 52 80 00 00 	movabs $0x805278,%rdx
  802143:	00 00 00 
  802146:	be 30 00 00 00       	mov    $0x30,%esi
  80214b:	48 bf 6d 52 80 00 00 	movabs $0x80526d,%rdi
  802152:	00 00 00 
  802155:	b8 00 00 00 00       	mov    $0x0,%eax
  80215a:	48 b9 ed 05 80 00 00 	movabs $0x8005ed,%rcx
  802161:	00 00 00 
  802164:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  802166:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80216b:	bf 00 00 00 00       	mov    $0x0,%edi
  802170:	48 b8 b5 1d 80 00 00 	movabs $0x801db5,%rax
  802177:	00 00 00 
  80217a:	ff d0                	callq  *%rax
  80217c:	85 c0                	test   %eax,%eax
  80217e:	79 54                	jns    8021d4 <pgfault+0x193>
				panic("Page unmap from temp location failed");
  802180:	48 ba 98 52 80 00 00 	movabs $0x805298,%rdx
  802187:	00 00 00 
  80218a:	be 32 00 00 00       	mov    $0x32,%esi
  80218f:	48 bf 6d 52 80 00 00 	movabs $0x80526d,%rdi
  802196:	00 00 00 
  802199:	b8 00 00 00 00       	mov    $0x0,%eax
  80219e:	48 b9 ed 05 80 00 00 	movabs $0x8005ed,%rcx
  8021a5:	00 00 00 
  8021a8:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  8021aa:	48 ba c0 52 80 00 00 	movabs $0x8052c0,%rdx
  8021b1:	00 00 00 
  8021b4:	be 34 00 00 00       	mov    $0x34,%esi
  8021b9:	48 bf 6d 52 80 00 00 	movabs $0x80526d,%rdi
  8021c0:	00 00 00 
  8021c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c8:	48 b9 ed 05 80 00 00 	movabs $0x8005ed,%rcx
  8021cf:	00 00 00 
  8021d2:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  8021d4:	c9                   	leaveq 
  8021d5:	c3                   	retq   

00000000008021d6 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8021d6:	55                   	push   %rbp
  8021d7:	48 89 e5             	mov    %rsp,%rbp
  8021da:	48 83 ec 20          	sub    $0x20,%rsp
  8021de:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8021e1:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  8021e4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021eb:	01 00 00 
  8021ee:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8021f1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021f5:	25 07 0e 00 00       	and    $0xe07,%eax
  8021fa:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  8021fd:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802200:	48 c1 e0 0c          	shl    $0xc,%rax
  802204:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  802208:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80220b:	25 00 04 00 00       	and    $0x400,%eax
  802210:	85 c0                	test   %eax,%eax
  802212:	74 57                	je     80226b <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  802214:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802217:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80221b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80221e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802222:	41 89 f0             	mov    %esi,%r8d
  802225:	48 89 c6             	mov    %rax,%rsi
  802228:	bf 00 00 00 00       	mov    $0x0,%edi
  80222d:	48 b8 5a 1d 80 00 00 	movabs $0x801d5a,%rax
  802234:	00 00 00 
  802237:	ff d0                	callq  *%rax
  802239:	85 c0                	test   %eax,%eax
  80223b:	0f 8e 52 01 00 00    	jle    802393 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  802241:	48 ba f2 52 80 00 00 	movabs $0x8052f2,%rdx
  802248:	00 00 00 
  80224b:	be 4e 00 00 00       	mov    $0x4e,%esi
  802250:	48 bf 6d 52 80 00 00 	movabs $0x80526d,%rdi
  802257:	00 00 00 
  80225a:	b8 00 00 00 00       	mov    $0x0,%eax
  80225f:	48 b9 ed 05 80 00 00 	movabs $0x8005ed,%rcx
  802266:	00 00 00 
  802269:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  80226b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80226e:	83 e0 02             	and    $0x2,%eax
  802271:	85 c0                	test   %eax,%eax
  802273:	75 10                	jne    802285 <duppage+0xaf>
  802275:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802278:	25 00 08 00 00       	and    $0x800,%eax
  80227d:	85 c0                	test   %eax,%eax
  80227f:	0f 84 bb 00 00 00    	je     802340 <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  802285:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802288:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  80228d:	80 cc 08             	or     $0x8,%ah
  802290:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  802293:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802296:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80229a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80229d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022a1:	41 89 f0             	mov    %esi,%r8d
  8022a4:	48 89 c6             	mov    %rax,%rsi
  8022a7:	bf 00 00 00 00       	mov    $0x0,%edi
  8022ac:	48 b8 5a 1d 80 00 00 	movabs $0x801d5a,%rax
  8022b3:	00 00 00 
  8022b6:	ff d0                	callq  *%rax
  8022b8:	85 c0                	test   %eax,%eax
  8022ba:	7e 2a                	jle    8022e6 <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  8022bc:	48 ba f2 52 80 00 00 	movabs $0x8052f2,%rdx
  8022c3:	00 00 00 
  8022c6:	be 55 00 00 00       	mov    $0x55,%esi
  8022cb:	48 bf 6d 52 80 00 00 	movabs $0x80526d,%rdi
  8022d2:	00 00 00 
  8022d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8022da:	48 b9 ed 05 80 00 00 	movabs $0x8005ed,%rcx
  8022e1:	00 00 00 
  8022e4:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  8022e6:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  8022e9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022f1:	41 89 c8             	mov    %ecx,%r8d
  8022f4:	48 89 d1             	mov    %rdx,%rcx
  8022f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8022fc:	48 89 c6             	mov    %rax,%rsi
  8022ff:	bf 00 00 00 00       	mov    $0x0,%edi
  802304:	48 b8 5a 1d 80 00 00 	movabs $0x801d5a,%rax
  80230b:	00 00 00 
  80230e:	ff d0                	callq  *%rax
  802310:	85 c0                	test   %eax,%eax
  802312:	7e 2a                	jle    80233e <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  802314:	48 ba f2 52 80 00 00 	movabs $0x8052f2,%rdx
  80231b:	00 00 00 
  80231e:	be 57 00 00 00       	mov    $0x57,%esi
  802323:	48 bf 6d 52 80 00 00 	movabs $0x80526d,%rdi
  80232a:	00 00 00 
  80232d:	b8 00 00 00 00       	mov    $0x0,%eax
  802332:	48 b9 ed 05 80 00 00 	movabs $0x8005ed,%rcx
  802339:	00 00 00 
  80233c:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  80233e:	eb 53                	jmp    802393 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  802340:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802343:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802347:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80234a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80234e:	41 89 f0             	mov    %esi,%r8d
  802351:	48 89 c6             	mov    %rax,%rsi
  802354:	bf 00 00 00 00       	mov    $0x0,%edi
  802359:	48 b8 5a 1d 80 00 00 	movabs $0x801d5a,%rax
  802360:	00 00 00 
  802363:	ff d0                	callq  *%rax
  802365:	85 c0                	test   %eax,%eax
  802367:	7e 2a                	jle    802393 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  802369:	48 ba f2 52 80 00 00 	movabs $0x8052f2,%rdx
  802370:	00 00 00 
  802373:	be 5b 00 00 00       	mov    $0x5b,%esi
  802378:	48 bf 6d 52 80 00 00 	movabs $0x80526d,%rdi
  80237f:	00 00 00 
  802382:	b8 00 00 00 00       	mov    $0x0,%eax
  802387:	48 b9 ed 05 80 00 00 	movabs $0x8005ed,%rcx
  80238e:	00 00 00 
  802391:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  802393:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802398:	c9                   	leaveq 
  802399:	c3                   	retq   

000000000080239a <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  80239a:	55                   	push   %rbp
  80239b:	48 89 e5             	mov    %rsp,%rbp
  80239e:	48 83 ec 18          	sub    $0x18,%rsp
  8023a2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  8023a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023aa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  8023ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023b2:	48 c1 e8 27          	shr    $0x27,%rax
  8023b6:	48 89 c2             	mov    %rax,%rdx
  8023b9:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8023c0:	01 00 00 
  8023c3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023c7:	83 e0 01             	and    $0x1,%eax
  8023ca:	48 85 c0             	test   %rax,%rax
  8023cd:	74 51                	je     802420 <pt_is_mapped+0x86>
  8023cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023d3:	48 c1 e0 0c          	shl    $0xc,%rax
  8023d7:	48 c1 e8 1e          	shr    $0x1e,%rax
  8023db:	48 89 c2             	mov    %rax,%rdx
  8023de:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8023e5:	01 00 00 
  8023e8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023ec:	83 e0 01             	and    $0x1,%eax
  8023ef:	48 85 c0             	test   %rax,%rax
  8023f2:	74 2c                	je     802420 <pt_is_mapped+0x86>
  8023f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023f8:	48 c1 e0 0c          	shl    $0xc,%rax
  8023fc:	48 c1 e8 15          	shr    $0x15,%rax
  802400:	48 89 c2             	mov    %rax,%rdx
  802403:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80240a:	01 00 00 
  80240d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802411:	83 e0 01             	and    $0x1,%eax
  802414:	48 85 c0             	test   %rax,%rax
  802417:	74 07                	je     802420 <pt_is_mapped+0x86>
  802419:	b8 01 00 00 00       	mov    $0x1,%eax
  80241e:	eb 05                	jmp    802425 <pt_is_mapped+0x8b>
  802420:	b8 00 00 00 00       	mov    $0x0,%eax
  802425:	83 e0 01             	and    $0x1,%eax
}
  802428:	c9                   	leaveq 
  802429:	c3                   	retq   

000000000080242a <fork>:

envid_t
fork(void)
{
  80242a:	55                   	push   %rbp
  80242b:	48 89 e5             	mov    %rsp,%rbp
  80242e:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  802432:	48 bf 41 20 80 00 00 	movabs $0x802041,%rdi
  802439:	00 00 00 
  80243c:	48 b8 04 48 80 00 00 	movabs $0x804804,%rax
  802443:	00 00 00 
  802446:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802448:	b8 07 00 00 00       	mov    $0x7,%eax
  80244d:	cd 30                	int    $0x30
  80244f:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802452:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  802455:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  802458:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80245c:	79 30                	jns    80248e <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  80245e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802461:	89 c1                	mov    %eax,%ecx
  802463:	48 ba 10 53 80 00 00 	movabs $0x805310,%rdx
  80246a:	00 00 00 
  80246d:	be 86 00 00 00       	mov    $0x86,%esi
  802472:	48 bf 6d 52 80 00 00 	movabs $0x80526d,%rdi
  802479:	00 00 00 
  80247c:	b8 00 00 00 00       	mov    $0x0,%eax
  802481:	49 b8 ed 05 80 00 00 	movabs $0x8005ed,%r8
  802488:	00 00 00 
  80248b:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  80248e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802492:	75 46                	jne    8024da <fork+0xb0>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  802494:	48 b8 8e 1c 80 00 00 	movabs $0x801c8e,%rax
  80249b:	00 00 00 
  80249e:	ff d0                	callq  *%rax
  8024a0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8024a5:	48 63 d0             	movslq %eax,%rdx
  8024a8:	48 89 d0             	mov    %rdx,%rax
  8024ab:	48 c1 e0 03          	shl    $0x3,%rax
  8024af:	48 01 d0             	add    %rdx,%rax
  8024b2:	48 c1 e0 05          	shl    $0x5,%rax
  8024b6:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8024bd:	00 00 00 
  8024c0:	48 01 c2             	add    %rax,%rdx
  8024c3:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8024ca:	00 00 00 
  8024cd:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8024d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d5:	e9 d1 01 00 00       	jmpq   8026ab <fork+0x281>
	}
	uint64_t ad = 0;
  8024da:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8024e1:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8024e2:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  8024e7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8024eb:	e9 df 00 00 00       	jmpq   8025cf <fork+0x1a5>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  8024f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024f4:	48 c1 e8 27          	shr    $0x27,%rax
  8024f8:	48 89 c2             	mov    %rax,%rdx
  8024fb:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802502:	01 00 00 
  802505:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802509:	83 e0 01             	and    $0x1,%eax
  80250c:	48 85 c0             	test   %rax,%rax
  80250f:	0f 84 9e 00 00 00    	je     8025b3 <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  802515:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802519:	48 c1 e8 1e          	shr    $0x1e,%rax
  80251d:	48 89 c2             	mov    %rax,%rdx
  802520:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802527:	01 00 00 
  80252a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80252e:	83 e0 01             	and    $0x1,%eax
  802531:	48 85 c0             	test   %rax,%rax
  802534:	74 73                	je     8025a9 <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  802536:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80253a:	48 c1 e8 15          	shr    $0x15,%rax
  80253e:	48 89 c2             	mov    %rax,%rdx
  802541:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802548:	01 00 00 
  80254b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80254f:	83 e0 01             	and    $0x1,%eax
  802552:	48 85 c0             	test   %rax,%rax
  802555:	74 48                	je     80259f <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  802557:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80255b:	48 c1 e8 0c          	shr    $0xc,%rax
  80255f:	48 89 c2             	mov    %rax,%rdx
  802562:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802569:	01 00 00 
  80256c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802570:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802574:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802578:	83 e0 01             	and    $0x1,%eax
  80257b:	48 85 c0             	test   %rax,%rax
  80257e:	74 47                	je     8025c7 <fork+0x19d>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  802580:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802584:	48 c1 e8 0c          	shr    $0xc,%rax
  802588:	89 c2                	mov    %eax,%edx
  80258a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80258d:	89 d6                	mov    %edx,%esi
  80258f:	89 c7                	mov    %eax,%edi
  802591:	48 b8 d6 21 80 00 00 	movabs $0x8021d6,%rax
  802598:	00 00 00 
  80259b:	ff d0                	callq  *%rax
  80259d:	eb 28                	jmp    8025c7 <fork+0x19d>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  80259f:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  8025a6:	00 
  8025a7:	eb 1e                	jmp    8025c7 <fork+0x19d>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  8025a9:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  8025b0:	40 
  8025b1:	eb 14                	jmp    8025c7 <fork+0x19d>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  8025b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025b7:	48 c1 e8 27          	shr    $0x27,%rax
  8025bb:	48 83 c0 01          	add    $0x1,%rax
  8025bf:	48 c1 e0 27          	shl    $0x27,%rax
  8025c3:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8025c7:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  8025ce:	00 
  8025cf:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  8025d6:	00 
  8025d7:	0f 87 13 ff ff ff    	ja     8024f0 <fork+0xc6>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8025dd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8025e0:	ba 07 00 00 00       	mov    $0x7,%edx
  8025e5:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8025ea:	89 c7                	mov    %eax,%edi
  8025ec:	48 b8 0a 1d 80 00 00 	movabs $0x801d0a,%rax
  8025f3:	00 00 00 
  8025f6:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8025f8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8025fb:	ba 07 00 00 00       	mov    $0x7,%edx
  802600:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802605:	89 c7                	mov    %eax,%edi
  802607:	48 b8 0a 1d 80 00 00 	movabs $0x801d0a,%rax
  80260e:	00 00 00 
  802611:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  802613:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802616:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80261c:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  802621:	ba 00 00 00 00       	mov    $0x0,%edx
  802626:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80262b:	89 c7                	mov    %eax,%edi
  80262d:	48 b8 5a 1d 80 00 00 	movabs $0x801d5a,%rax
  802634:	00 00 00 
  802637:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  802639:	ba 00 10 00 00       	mov    $0x1000,%edx
  80263e:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802643:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802648:	48 b8 ff 16 80 00 00 	movabs $0x8016ff,%rax
  80264f:	00 00 00 
  802652:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  802654:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802659:	bf 00 00 00 00       	mov    $0x0,%edi
  80265e:	48 b8 b5 1d 80 00 00 	movabs $0x801db5,%rax
  802665:	00 00 00 
  802668:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  80266a:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802671:	00 00 00 
  802674:	48 8b 00             	mov    (%rax),%rax
  802677:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  80267e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802681:	48 89 d6             	mov    %rdx,%rsi
  802684:	89 c7                	mov    %eax,%edi
  802686:	48 b8 94 1e 80 00 00 	movabs $0x801e94,%rax
  80268d:	00 00 00 
  802690:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  802692:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802695:	be 02 00 00 00       	mov    $0x2,%esi
  80269a:	89 c7                	mov    %eax,%edi
  80269c:	48 b8 ff 1d 80 00 00 	movabs $0x801dff,%rax
  8026a3:	00 00 00 
  8026a6:	ff d0                	callq  *%rax

	return envid;
  8026a8:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  8026ab:	c9                   	leaveq 
  8026ac:	c3                   	retq   

00000000008026ad <sfork>:

	
// Challenge!
int
sfork(void)
{
  8026ad:	55                   	push   %rbp
  8026ae:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8026b1:	48 ba 28 53 80 00 00 	movabs $0x805328,%rdx
  8026b8:	00 00 00 
  8026bb:	be bf 00 00 00       	mov    $0xbf,%esi
  8026c0:	48 bf 6d 52 80 00 00 	movabs $0x80526d,%rdi
  8026c7:	00 00 00 
  8026ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8026cf:	48 b9 ed 05 80 00 00 	movabs $0x8005ed,%rcx
  8026d6:	00 00 00 
  8026d9:	ff d1                	callq  *%rcx

00000000008026db <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8026db:	55                   	push   %rbp
  8026dc:	48 89 e5             	mov    %rsp,%rbp
  8026df:	48 83 ec 08          	sub    $0x8,%rsp
  8026e3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8026e7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8026eb:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8026f2:	ff ff ff 
  8026f5:	48 01 d0             	add    %rdx,%rax
  8026f8:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8026fc:	c9                   	leaveq 
  8026fd:	c3                   	retq   

00000000008026fe <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8026fe:	55                   	push   %rbp
  8026ff:	48 89 e5             	mov    %rsp,%rbp
  802702:	48 83 ec 08          	sub    $0x8,%rsp
  802706:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80270a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80270e:	48 89 c7             	mov    %rax,%rdi
  802711:	48 b8 db 26 80 00 00 	movabs $0x8026db,%rax
  802718:	00 00 00 
  80271b:	ff d0                	callq  *%rax
  80271d:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802723:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802727:	c9                   	leaveq 
  802728:	c3                   	retq   

0000000000802729 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802729:	55                   	push   %rbp
  80272a:	48 89 e5             	mov    %rsp,%rbp
  80272d:	48 83 ec 18          	sub    $0x18,%rsp
  802731:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802735:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80273c:	eb 6b                	jmp    8027a9 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80273e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802741:	48 98                	cltq   
  802743:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802749:	48 c1 e0 0c          	shl    $0xc,%rax
  80274d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802751:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802755:	48 c1 e8 15          	shr    $0x15,%rax
  802759:	48 89 c2             	mov    %rax,%rdx
  80275c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802763:	01 00 00 
  802766:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80276a:	83 e0 01             	and    $0x1,%eax
  80276d:	48 85 c0             	test   %rax,%rax
  802770:	74 21                	je     802793 <fd_alloc+0x6a>
  802772:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802776:	48 c1 e8 0c          	shr    $0xc,%rax
  80277a:	48 89 c2             	mov    %rax,%rdx
  80277d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802784:	01 00 00 
  802787:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80278b:	83 e0 01             	and    $0x1,%eax
  80278e:	48 85 c0             	test   %rax,%rax
  802791:	75 12                	jne    8027a5 <fd_alloc+0x7c>
			*fd_store = fd;
  802793:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802797:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80279b:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80279e:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a3:	eb 1a                	jmp    8027bf <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8027a5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8027a9:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8027ad:	7e 8f                	jle    80273e <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8027af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027b3:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8027ba:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8027bf:	c9                   	leaveq 
  8027c0:	c3                   	retq   

00000000008027c1 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8027c1:	55                   	push   %rbp
  8027c2:	48 89 e5             	mov    %rsp,%rbp
  8027c5:	48 83 ec 20          	sub    $0x20,%rsp
  8027c9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8027cc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8027d0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8027d4:	78 06                	js     8027dc <fd_lookup+0x1b>
  8027d6:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8027da:	7e 07                	jle    8027e3 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8027dc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027e1:	eb 6c                	jmp    80284f <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8027e3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027e6:	48 98                	cltq   
  8027e8:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8027ee:	48 c1 e0 0c          	shl    $0xc,%rax
  8027f2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8027f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027fa:	48 c1 e8 15          	shr    $0x15,%rax
  8027fe:	48 89 c2             	mov    %rax,%rdx
  802801:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802808:	01 00 00 
  80280b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80280f:	83 e0 01             	and    $0x1,%eax
  802812:	48 85 c0             	test   %rax,%rax
  802815:	74 21                	je     802838 <fd_lookup+0x77>
  802817:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80281b:	48 c1 e8 0c          	shr    $0xc,%rax
  80281f:	48 89 c2             	mov    %rax,%rdx
  802822:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802829:	01 00 00 
  80282c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802830:	83 e0 01             	and    $0x1,%eax
  802833:	48 85 c0             	test   %rax,%rax
  802836:	75 07                	jne    80283f <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802838:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80283d:	eb 10                	jmp    80284f <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80283f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802843:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802847:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80284a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80284f:	c9                   	leaveq 
  802850:	c3                   	retq   

0000000000802851 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802851:	55                   	push   %rbp
  802852:	48 89 e5             	mov    %rsp,%rbp
  802855:	48 83 ec 30          	sub    $0x30,%rsp
  802859:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80285d:	89 f0                	mov    %esi,%eax
  80285f:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802862:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802866:	48 89 c7             	mov    %rax,%rdi
  802869:	48 b8 db 26 80 00 00 	movabs $0x8026db,%rax
  802870:	00 00 00 
  802873:	ff d0                	callq  *%rax
  802875:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802879:	48 89 d6             	mov    %rdx,%rsi
  80287c:	89 c7                	mov    %eax,%edi
  80287e:	48 b8 c1 27 80 00 00 	movabs $0x8027c1,%rax
  802885:	00 00 00 
  802888:	ff d0                	callq  *%rax
  80288a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80288d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802891:	78 0a                	js     80289d <fd_close+0x4c>
	    || fd != fd2)
  802893:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802897:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80289b:	74 12                	je     8028af <fd_close+0x5e>
		return (must_exist ? r : 0);
  80289d:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8028a1:	74 05                	je     8028a8 <fd_close+0x57>
  8028a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028a6:	eb 05                	jmp    8028ad <fd_close+0x5c>
  8028a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ad:	eb 69                	jmp    802918 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8028af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028b3:	8b 00                	mov    (%rax),%eax
  8028b5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8028b9:	48 89 d6             	mov    %rdx,%rsi
  8028bc:	89 c7                	mov    %eax,%edi
  8028be:	48 b8 1a 29 80 00 00 	movabs $0x80291a,%rax
  8028c5:	00 00 00 
  8028c8:	ff d0                	callq  *%rax
  8028ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028d1:	78 2a                	js     8028fd <fd_close+0xac>
		if (dev->dev_close)
  8028d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028d7:	48 8b 40 20          	mov    0x20(%rax),%rax
  8028db:	48 85 c0             	test   %rax,%rax
  8028de:	74 16                	je     8028f6 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8028e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028e4:	48 8b 40 20          	mov    0x20(%rax),%rax
  8028e8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028ec:	48 89 d7             	mov    %rdx,%rdi
  8028ef:	ff d0                	callq  *%rax
  8028f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028f4:	eb 07                	jmp    8028fd <fd_close+0xac>
		else
			r = 0;
  8028f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8028fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802901:	48 89 c6             	mov    %rax,%rsi
  802904:	bf 00 00 00 00       	mov    $0x0,%edi
  802909:	48 b8 b5 1d 80 00 00 	movabs $0x801db5,%rax
  802910:	00 00 00 
  802913:	ff d0                	callq  *%rax
	return r;
  802915:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802918:	c9                   	leaveq 
  802919:	c3                   	retq   

000000000080291a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80291a:	55                   	push   %rbp
  80291b:	48 89 e5             	mov    %rsp,%rbp
  80291e:	48 83 ec 20          	sub    $0x20,%rsp
  802922:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802925:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802929:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802930:	eb 41                	jmp    802973 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802932:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802939:	00 00 00 
  80293c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80293f:	48 63 d2             	movslq %edx,%rdx
  802942:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802946:	8b 00                	mov    (%rax),%eax
  802948:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80294b:	75 22                	jne    80296f <dev_lookup+0x55>
			*dev = devtab[i];
  80294d:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802954:	00 00 00 
  802957:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80295a:	48 63 d2             	movslq %edx,%rdx
  80295d:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802961:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802965:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802968:	b8 00 00 00 00       	mov    $0x0,%eax
  80296d:	eb 60                	jmp    8029cf <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80296f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802973:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80297a:	00 00 00 
  80297d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802980:	48 63 d2             	movslq %edx,%rdx
  802983:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802987:	48 85 c0             	test   %rax,%rax
  80298a:	75 a6                	jne    802932 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80298c:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802993:	00 00 00 
  802996:	48 8b 00             	mov    (%rax),%rax
  802999:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80299f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8029a2:	89 c6                	mov    %eax,%esi
  8029a4:	48 bf 40 53 80 00 00 	movabs $0x805340,%rdi
  8029ab:	00 00 00 
  8029ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b3:	48 b9 26 08 80 00 00 	movabs $0x800826,%rcx
  8029ba:	00 00 00 
  8029bd:	ff d1                	callq  *%rcx
	*dev = 0;
  8029bf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029c3:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8029ca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8029cf:	c9                   	leaveq 
  8029d0:	c3                   	retq   

00000000008029d1 <close>:

int
close(int fdnum)
{
  8029d1:	55                   	push   %rbp
  8029d2:	48 89 e5             	mov    %rsp,%rbp
  8029d5:	48 83 ec 20          	sub    $0x20,%rsp
  8029d9:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8029dc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029e0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029e3:	48 89 d6             	mov    %rdx,%rsi
  8029e6:	89 c7                	mov    %eax,%edi
  8029e8:	48 b8 c1 27 80 00 00 	movabs $0x8027c1,%rax
  8029ef:	00 00 00 
  8029f2:	ff d0                	callq  *%rax
  8029f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029fb:	79 05                	jns    802a02 <close+0x31>
		return r;
  8029fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a00:	eb 18                	jmp    802a1a <close+0x49>
	else
		return fd_close(fd, 1);
  802a02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a06:	be 01 00 00 00       	mov    $0x1,%esi
  802a0b:	48 89 c7             	mov    %rax,%rdi
  802a0e:	48 b8 51 28 80 00 00 	movabs $0x802851,%rax
  802a15:	00 00 00 
  802a18:	ff d0                	callq  *%rax
}
  802a1a:	c9                   	leaveq 
  802a1b:	c3                   	retq   

0000000000802a1c <close_all>:

void
close_all(void)
{
  802a1c:	55                   	push   %rbp
  802a1d:	48 89 e5             	mov    %rsp,%rbp
  802a20:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802a24:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a2b:	eb 15                	jmp    802a42 <close_all+0x26>
		close(i);
  802a2d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a30:	89 c7                	mov    %eax,%edi
  802a32:	48 b8 d1 29 80 00 00 	movabs $0x8029d1,%rax
  802a39:	00 00 00 
  802a3c:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802a3e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802a42:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802a46:	7e e5                	jle    802a2d <close_all+0x11>
		close(i);
}
  802a48:	c9                   	leaveq 
  802a49:	c3                   	retq   

0000000000802a4a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802a4a:	55                   	push   %rbp
  802a4b:	48 89 e5             	mov    %rsp,%rbp
  802a4e:	48 83 ec 40          	sub    $0x40,%rsp
  802a52:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802a55:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802a58:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802a5c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802a5f:	48 89 d6             	mov    %rdx,%rsi
  802a62:	89 c7                	mov    %eax,%edi
  802a64:	48 b8 c1 27 80 00 00 	movabs $0x8027c1,%rax
  802a6b:	00 00 00 
  802a6e:	ff d0                	callq  *%rax
  802a70:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a73:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a77:	79 08                	jns    802a81 <dup+0x37>
		return r;
  802a79:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a7c:	e9 70 01 00 00       	jmpq   802bf1 <dup+0x1a7>
	close(newfdnum);
  802a81:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a84:	89 c7                	mov    %eax,%edi
  802a86:	48 b8 d1 29 80 00 00 	movabs $0x8029d1,%rax
  802a8d:	00 00 00 
  802a90:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802a92:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a95:	48 98                	cltq   
  802a97:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802a9d:	48 c1 e0 0c          	shl    $0xc,%rax
  802aa1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802aa5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802aa9:	48 89 c7             	mov    %rax,%rdi
  802aac:	48 b8 fe 26 80 00 00 	movabs $0x8026fe,%rax
  802ab3:	00 00 00 
  802ab6:	ff d0                	callq  *%rax
  802ab8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802abc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ac0:	48 89 c7             	mov    %rax,%rdi
  802ac3:	48 b8 fe 26 80 00 00 	movabs $0x8026fe,%rax
  802aca:	00 00 00 
  802acd:	ff d0                	callq  *%rax
  802acf:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802ad3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ad7:	48 c1 e8 15          	shr    $0x15,%rax
  802adb:	48 89 c2             	mov    %rax,%rdx
  802ade:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802ae5:	01 00 00 
  802ae8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802aec:	83 e0 01             	and    $0x1,%eax
  802aef:	48 85 c0             	test   %rax,%rax
  802af2:	74 73                	je     802b67 <dup+0x11d>
  802af4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802af8:	48 c1 e8 0c          	shr    $0xc,%rax
  802afc:	48 89 c2             	mov    %rax,%rdx
  802aff:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b06:	01 00 00 
  802b09:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b0d:	83 e0 01             	and    $0x1,%eax
  802b10:	48 85 c0             	test   %rax,%rax
  802b13:	74 52                	je     802b67 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802b15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b19:	48 c1 e8 0c          	shr    $0xc,%rax
  802b1d:	48 89 c2             	mov    %rax,%rdx
  802b20:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b27:	01 00 00 
  802b2a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b2e:	25 07 0e 00 00       	and    $0xe07,%eax
  802b33:	89 c1                	mov    %eax,%ecx
  802b35:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802b39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b3d:	41 89 c8             	mov    %ecx,%r8d
  802b40:	48 89 d1             	mov    %rdx,%rcx
  802b43:	ba 00 00 00 00       	mov    $0x0,%edx
  802b48:	48 89 c6             	mov    %rax,%rsi
  802b4b:	bf 00 00 00 00       	mov    $0x0,%edi
  802b50:	48 b8 5a 1d 80 00 00 	movabs $0x801d5a,%rax
  802b57:	00 00 00 
  802b5a:	ff d0                	callq  *%rax
  802b5c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b5f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b63:	79 02                	jns    802b67 <dup+0x11d>
			goto err;
  802b65:	eb 57                	jmp    802bbe <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802b67:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b6b:	48 c1 e8 0c          	shr    $0xc,%rax
  802b6f:	48 89 c2             	mov    %rax,%rdx
  802b72:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b79:	01 00 00 
  802b7c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b80:	25 07 0e 00 00       	and    $0xe07,%eax
  802b85:	89 c1                	mov    %eax,%ecx
  802b87:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b8b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b8f:	41 89 c8             	mov    %ecx,%r8d
  802b92:	48 89 d1             	mov    %rdx,%rcx
  802b95:	ba 00 00 00 00       	mov    $0x0,%edx
  802b9a:	48 89 c6             	mov    %rax,%rsi
  802b9d:	bf 00 00 00 00       	mov    $0x0,%edi
  802ba2:	48 b8 5a 1d 80 00 00 	movabs $0x801d5a,%rax
  802ba9:	00 00 00 
  802bac:	ff d0                	callq  *%rax
  802bae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bb1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bb5:	79 02                	jns    802bb9 <dup+0x16f>
		goto err;
  802bb7:	eb 05                	jmp    802bbe <dup+0x174>

	return newfdnum;
  802bb9:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802bbc:	eb 33                	jmp    802bf1 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802bbe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bc2:	48 89 c6             	mov    %rax,%rsi
  802bc5:	bf 00 00 00 00       	mov    $0x0,%edi
  802bca:	48 b8 b5 1d 80 00 00 	movabs $0x801db5,%rax
  802bd1:	00 00 00 
  802bd4:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802bd6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bda:	48 89 c6             	mov    %rax,%rsi
  802bdd:	bf 00 00 00 00       	mov    $0x0,%edi
  802be2:	48 b8 b5 1d 80 00 00 	movabs $0x801db5,%rax
  802be9:	00 00 00 
  802bec:	ff d0                	callq  *%rax
	return r;
  802bee:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802bf1:	c9                   	leaveq 
  802bf2:	c3                   	retq   

0000000000802bf3 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802bf3:	55                   	push   %rbp
  802bf4:	48 89 e5             	mov    %rsp,%rbp
  802bf7:	48 83 ec 40          	sub    $0x40,%rsp
  802bfb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802bfe:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802c02:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c06:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c0a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c0d:	48 89 d6             	mov    %rdx,%rsi
  802c10:	89 c7                	mov    %eax,%edi
  802c12:	48 b8 c1 27 80 00 00 	movabs $0x8027c1,%rax
  802c19:	00 00 00 
  802c1c:	ff d0                	callq  *%rax
  802c1e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c21:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c25:	78 24                	js     802c4b <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c2b:	8b 00                	mov    (%rax),%eax
  802c2d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c31:	48 89 d6             	mov    %rdx,%rsi
  802c34:	89 c7                	mov    %eax,%edi
  802c36:	48 b8 1a 29 80 00 00 	movabs $0x80291a,%rax
  802c3d:	00 00 00 
  802c40:	ff d0                	callq  *%rax
  802c42:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c45:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c49:	79 05                	jns    802c50 <read+0x5d>
		return r;
  802c4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c4e:	eb 76                	jmp    802cc6 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802c50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c54:	8b 40 08             	mov    0x8(%rax),%eax
  802c57:	83 e0 03             	and    $0x3,%eax
  802c5a:	83 f8 01             	cmp    $0x1,%eax
  802c5d:	75 3a                	jne    802c99 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802c5f:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802c66:	00 00 00 
  802c69:	48 8b 00             	mov    (%rax),%rax
  802c6c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c72:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c75:	89 c6                	mov    %eax,%esi
  802c77:	48 bf 5f 53 80 00 00 	movabs $0x80535f,%rdi
  802c7e:	00 00 00 
  802c81:	b8 00 00 00 00       	mov    $0x0,%eax
  802c86:	48 b9 26 08 80 00 00 	movabs $0x800826,%rcx
  802c8d:	00 00 00 
  802c90:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802c92:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c97:	eb 2d                	jmp    802cc6 <read+0xd3>
	}
	if (!dev->dev_read)
  802c99:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c9d:	48 8b 40 10          	mov    0x10(%rax),%rax
  802ca1:	48 85 c0             	test   %rax,%rax
  802ca4:	75 07                	jne    802cad <read+0xba>
		return -E_NOT_SUPP;
  802ca6:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802cab:	eb 19                	jmp    802cc6 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802cad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cb1:	48 8b 40 10          	mov    0x10(%rax),%rax
  802cb5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802cb9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802cbd:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802cc1:	48 89 cf             	mov    %rcx,%rdi
  802cc4:	ff d0                	callq  *%rax
}
  802cc6:	c9                   	leaveq 
  802cc7:	c3                   	retq   

0000000000802cc8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802cc8:	55                   	push   %rbp
  802cc9:	48 89 e5             	mov    %rsp,%rbp
  802ccc:	48 83 ec 30          	sub    $0x30,%rsp
  802cd0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802cd3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802cd7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802cdb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802ce2:	eb 49                	jmp    802d2d <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802ce4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ce7:	48 98                	cltq   
  802ce9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ced:	48 29 c2             	sub    %rax,%rdx
  802cf0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cf3:	48 63 c8             	movslq %eax,%rcx
  802cf6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cfa:	48 01 c1             	add    %rax,%rcx
  802cfd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d00:	48 89 ce             	mov    %rcx,%rsi
  802d03:	89 c7                	mov    %eax,%edi
  802d05:	48 b8 f3 2b 80 00 00 	movabs $0x802bf3,%rax
  802d0c:	00 00 00 
  802d0f:	ff d0                	callq  *%rax
  802d11:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802d14:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802d18:	79 05                	jns    802d1f <readn+0x57>
			return m;
  802d1a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d1d:	eb 1c                	jmp    802d3b <readn+0x73>
		if (m == 0)
  802d1f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802d23:	75 02                	jne    802d27 <readn+0x5f>
			break;
  802d25:	eb 11                	jmp    802d38 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802d27:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d2a:	01 45 fc             	add    %eax,-0x4(%rbp)
  802d2d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d30:	48 98                	cltq   
  802d32:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802d36:	72 ac                	jb     802ce4 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802d38:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802d3b:	c9                   	leaveq 
  802d3c:	c3                   	retq   

0000000000802d3d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802d3d:	55                   	push   %rbp
  802d3e:	48 89 e5             	mov    %rsp,%rbp
  802d41:	48 83 ec 40          	sub    $0x40,%rsp
  802d45:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d48:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802d4c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d50:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d54:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d57:	48 89 d6             	mov    %rdx,%rsi
  802d5a:	89 c7                	mov    %eax,%edi
  802d5c:	48 b8 c1 27 80 00 00 	movabs $0x8027c1,%rax
  802d63:	00 00 00 
  802d66:	ff d0                	callq  *%rax
  802d68:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d6b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d6f:	78 24                	js     802d95 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d75:	8b 00                	mov    (%rax),%eax
  802d77:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d7b:	48 89 d6             	mov    %rdx,%rsi
  802d7e:	89 c7                	mov    %eax,%edi
  802d80:	48 b8 1a 29 80 00 00 	movabs $0x80291a,%rax
  802d87:	00 00 00 
  802d8a:	ff d0                	callq  *%rax
  802d8c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d8f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d93:	79 05                	jns    802d9a <write+0x5d>
		return r;
  802d95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d98:	eb 75                	jmp    802e0f <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802d9a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d9e:	8b 40 08             	mov    0x8(%rax),%eax
  802da1:	83 e0 03             	and    $0x3,%eax
  802da4:	85 c0                	test   %eax,%eax
  802da6:	75 3a                	jne    802de2 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802da8:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802daf:	00 00 00 
  802db2:	48 8b 00             	mov    (%rax),%rax
  802db5:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802dbb:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802dbe:	89 c6                	mov    %eax,%esi
  802dc0:	48 bf 7b 53 80 00 00 	movabs $0x80537b,%rdi
  802dc7:	00 00 00 
  802dca:	b8 00 00 00 00       	mov    $0x0,%eax
  802dcf:	48 b9 26 08 80 00 00 	movabs $0x800826,%rcx
  802dd6:	00 00 00 
  802dd9:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802ddb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802de0:	eb 2d                	jmp    802e0f <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  802de2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802de6:	48 8b 40 18          	mov    0x18(%rax),%rax
  802dea:	48 85 c0             	test   %rax,%rax
  802ded:	75 07                	jne    802df6 <write+0xb9>
		return -E_NOT_SUPP;
  802def:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802df4:	eb 19                	jmp    802e0f <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802df6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dfa:	48 8b 40 18          	mov    0x18(%rax),%rax
  802dfe:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802e02:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802e06:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802e0a:	48 89 cf             	mov    %rcx,%rdi
  802e0d:	ff d0                	callq  *%rax
}
  802e0f:	c9                   	leaveq 
  802e10:	c3                   	retq   

0000000000802e11 <seek>:

int
seek(int fdnum, off_t offset)
{
  802e11:	55                   	push   %rbp
  802e12:	48 89 e5             	mov    %rsp,%rbp
  802e15:	48 83 ec 18          	sub    $0x18,%rsp
  802e19:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e1c:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802e1f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e23:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e26:	48 89 d6             	mov    %rdx,%rsi
  802e29:	89 c7                	mov    %eax,%edi
  802e2b:	48 b8 c1 27 80 00 00 	movabs $0x8027c1,%rax
  802e32:	00 00 00 
  802e35:	ff d0                	callq  *%rax
  802e37:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e3a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e3e:	79 05                	jns    802e45 <seek+0x34>
		return r;
  802e40:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e43:	eb 0f                	jmp    802e54 <seek+0x43>
	fd->fd_offset = offset;
  802e45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e49:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802e4c:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802e4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e54:	c9                   	leaveq 
  802e55:	c3                   	retq   

0000000000802e56 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802e56:	55                   	push   %rbp
  802e57:	48 89 e5             	mov    %rsp,%rbp
  802e5a:	48 83 ec 30          	sub    $0x30,%rsp
  802e5e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e61:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e64:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e68:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e6b:	48 89 d6             	mov    %rdx,%rsi
  802e6e:	89 c7                	mov    %eax,%edi
  802e70:	48 b8 c1 27 80 00 00 	movabs $0x8027c1,%rax
  802e77:	00 00 00 
  802e7a:	ff d0                	callq  *%rax
  802e7c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e7f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e83:	78 24                	js     802ea9 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e89:	8b 00                	mov    (%rax),%eax
  802e8b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e8f:	48 89 d6             	mov    %rdx,%rsi
  802e92:	89 c7                	mov    %eax,%edi
  802e94:	48 b8 1a 29 80 00 00 	movabs $0x80291a,%rax
  802e9b:	00 00 00 
  802e9e:	ff d0                	callq  *%rax
  802ea0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ea3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ea7:	79 05                	jns    802eae <ftruncate+0x58>
		return r;
  802ea9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eac:	eb 72                	jmp    802f20 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802eae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eb2:	8b 40 08             	mov    0x8(%rax),%eax
  802eb5:	83 e0 03             	and    $0x3,%eax
  802eb8:	85 c0                	test   %eax,%eax
  802eba:	75 3a                	jne    802ef6 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802ebc:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802ec3:	00 00 00 
  802ec6:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802ec9:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ecf:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802ed2:	89 c6                	mov    %eax,%esi
  802ed4:	48 bf 98 53 80 00 00 	movabs $0x805398,%rdi
  802edb:	00 00 00 
  802ede:	b8 00 00 00 00       	mov    $0x0,%eax
  802ee3:	48 b9 26 08 80 00 00 	movabs $0x800826,%rcx
  802eea:	00 00 00 
  802eed:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802eef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ef4:	eb 2a                	jmp    802f20 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802ef6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802efa:	48 8b 40 30          	mov    0x30(%rax),%rax
  802efe:	48 85 c0             	test   %rax,%rax
  802f01:	75 07                	jne    802f0a <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802f03:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f08:	eb 16                	jmp    802f20 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802f0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f0e:	48 8b 40 30          	mov    0x30(%rax),%rax
  802f12:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802f16:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802f19:	89 ce                	mov    %ecx,%esi
  802f1b:	48 89 d7             	mov    %rdx,%rdi
  802f1e:	ff d0                	callq  *%rax
}
  802f20:	c9                   	leaveq 
  802f21:	c3                   	retq   

0000000000802f22 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802f22:	55                   	push   %rbp
  802f23:	48 89 e5             	mov    %rsp,%rbp
  802f26:	48 83 ec 30          	sub    $0x30,%rsp
  802f2a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802f2d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f31:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802f35:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f38:	48 89 d6             	mov    %rdx,%rsi
  802f3b:	89 c7                	mov    %eax,%edi
  802f3d:	48 b8 c1 27 80 00 00 	movabs $0x8027c1,%rax
  802f44:	00 00 00 
  802f47:	ff d0                	callq  *%rax
  802f49:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f4c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f50:	78 24                	js     802f76 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f56:	8b 00                	mov    (%rax),%eax
  802f58:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f5c:	48 89 d6             	mov    %rdx,%rsi
  802f5f:	89 c7                	mov    %eax,%edi
  802f61:	48 b8 1a 29 80 00 00 	movabs $0x80291a,%rax
  802f68:	00 00 00 
  802f6b:	ff d0                	callq  *%rax
  802f6d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f70:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f74:	79 05                	jns    802f7b <fstat+0x59>
		return r;
  802f76:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f79:	eb 5e                	jmp    802fd9 <fstat+0xb7>
	if (!dev->dev_stat)
  802f7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f7f:	48 8b 40 28          	mov    0x28(%rax),%rax
  802f83:	48 85 c0             	test   %rax,%rax
  802f86:	75 07                	jne    802f8f <fstat+0x6d>
		return -E_NOT_SUPP;
  802f88:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f8d:	eb 4a                	jmp    802fd9 <fstat+0xb7>
	stat->st_name[0] = 0;
  802f8f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f93:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802f96:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f9a:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802fa1:	00 00 00 
	stat->st_isdir = 0;
  802fa4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fa8:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802faf:	00 00 00 
	stat->st_dev = dev;
  802fb2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802fb6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fba:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802fc1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fc5:	48 8b 40 28          	mov    0x28(%rax),%rax
  802fc9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802fcd:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802fd1:	48 89 ce             	mov    %rcx,%rsi
  802fd4:	48 89 d7             	mov    %rdx,%rdi
  802fd7:	ff d0                	callq  *%rax
}
  802fd9:	c9                   	leaveq 
  802fda:	c3                   	retq   

0000000000802fdb <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802fdb:	55                   	push   %rbp
  802fdc:	48 89 e5             	mov    %rsp,%rbp
  802fdf:	48 83 ec 20          	sub    $0x20,%rsp
  802fe3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802fe7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802feb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fef:	be 00 00 00 00       	mov    $0x0,%esi
  802ff4:	48 89 c7             	mov    %rax,%rdi
  802ff7:	48 b8 c9 30 80 00 00 	movabs $0x8030c9,%rax
  802ffe:	00 00 00 
  803001:	ff d0                	callq  *%rax
  803003:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803006:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80300a:	79 05                	jns    803011 <stat+0x36>
		return fd;
  80300c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80300f:	eb 2f                	jmp    803040 <stat+0x65>
	r = fstat(fd, stat);
  803011:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803015:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803018:	48 89 d6             	mov    %rdx,%rsi
  80301b:	89 c7                	mov    %eax,%edi
  80301d:	48 b8 22 2f 80 00 00 	movabs $0x802f22,%rax
  803024:	00 00 00 
  803027:	ff d0                	callq  *%rax
  803029:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80302c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80302f:	89 c7                	mov    %eax,%edi
  803031:	48 b8 d1 29 80 00 00 	movabs $0x8029d1,%rax
  803038:	00 00 00 
  80303b:	ff d0                	callq  *%rax
	return r;
  80303d:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  803040:	c9                   	leaveq 
  803041:	c3                   	retq   

0000000000803042 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  803042:	55                   	push   %rbp
  803043:	48 89 e5             	mov    %rsp,%rbp
  803046:	48 83 ec 10          	sub    $0x10,%rsp
  80304a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80304d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  803051:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803058:	00 00 00 
  80305b:	8b 00                	mov    (%rax),%eax
  80305d:	85 c0                	test   %eax,%eax
  80305f:	75 1d                	jne    80307e <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  803061:	bf 01 00 00 00       	mov    $0x1,%edi
  803066:	48 b8 ac 4a 80 00 00 	movabs $0x804aac,%rax
  80306d:	00 00 00 
  803070:	ff d0                	callq  *%rax
  803072:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  803079:	00 00 00 
  80307c:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80307e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803085:	00 00 00 
  803088:	8b 00                	mov    (%rax),%eax
  80308a:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80308d:	b9 07 00 00 00       	mov    $0x7,%ecx
  803092:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  803099:	00 00 00 
  80309c:	89 c7                	mov    %eax,%edi
  80309e:	48 b8 4a 4a 80 00 00 	movabs $0x804a4a,%rax
  8030a5:	00 00 00 
  8030a8:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8030aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8030b3:	48 89 c6             	mov    %rax,%rsi
  8030b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8030bb:	48 b8 44 49 80 00 00 	movabs $0x804944,%rax
  8030c2:	00 00 00 
  8030c5:	ff d0                	callq  *%rax
}
  8030c7:	c9                   	leaveq 
  8030c8:	c3                   	retq   

00000000008030c9 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8030c9:	55                   	push   %rbp
  8030ca:	48 89 e5             	mov    %rsp,%rbp
  8030cd:	48 83 ec 30          	sub    $0x30,%rsp
  8030d1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8030d5:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  8030d8:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  8030df:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  8030e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  8030ed:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8030f2:	75 08                	jne    8030fc <open+0x33>
	{
		return r;
  8030f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030f7:	e9 f2 00 00 00       	jmpq   8031ee <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  8030fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803100:	48 89 c7             	mov    %rax,%rdi
  803103:	48 b8 6f 13 80 00 00 	movabs $0x80136f,%rax
  80310a:	00 00 00 
  80310d:	ff d0                	callq  *%rax
  80310f:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803112:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  803119:	7e 0a                	jle    803125 <open+0x5c>
	{
		return -E_BAD_PATH;
  80311b:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803120:	e9 c9 00 00 00       	jmpq   8031ee <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  803125:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80312c:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  80312d:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  803131:	48 89 c7             	mov    %rax,%rdi
  803134:	48 b8 29 27 80 00 00 	movabs $0x802729,%rax
  80313b:	00 00 00 
  80313e:	ff d0                	callq  *%rax
  803140:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803143:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803147:	78 09                	js     803152 <open+0x89>
  803149:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80314d:	48 85 c0             	test   %rax,%rax
  803150:	75 08                	jne    80315a <open+0x91>
		{
			return r;
  803152:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803155:	e9 94 00 00 00       	jmpq   8031ee <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  80315a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80315e:	ba 00 04 00 00       	mov    $0x400,%edx
  803163:	48 89 c6             	mov    %rax,%rsi
  803166:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  80316d:	00 00 00 
  803170:	48 b8 6d 14 80 00 00 	movabs $0x80146d,%rax
  803177:	00 00 00 
  80317a:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  80317c:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803183:	00 00 00 
  803186:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  803189:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  80318f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803193:	48 89 c6             	mov    %rax,%rsi
  803196:	bf 01 00 00 00       	mov    $0x1,%edi
  80319b:	48 b8 42 30 80 00 00 	movabs $0x803042,%rax
  8031a2:	00 00 00 
  8031a5:	ff d0                	callq  *%rax
  8031a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031ae:	79 2b                	jns    8031db <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  8031b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031b4:	be 00 00 00 00       	mov    $0x0,%esi
  8031b9:	48 89 c7             	mov    %rax,%rdi
  8031bc:	48 b8 51 28 80 00 00 	movabs $0x802851,%rax
  8031c3:	00 00 00 
  8031c6:	ff d0                	callq  *%rax
  8031c8:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8031cb:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8031cf:	79 05                	jns    8031d6 <open+0x10d>
			{
				return d;
  8031d1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031d4:	eb 18                	jmp    8031ee <open+0x125>
			}
			return r;
  8031d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031d9:	eb 13                	jmp    8031ee <open+0x125>
		}	
		return fd2num(fd_store);
  8031db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031df:	48 89 c7             	mov    %rax,%rdi
  8031e2:	48 b8 db 26 80 00 00 	movabs $0x8026db,%rax
  8031e9:	00 00 00 
  8031ec:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  8031ee:	c9                   	leaveq 
  8031ef:	c3                   	retq   

00000000008031f0 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8031f0:	55                   	push   %rbp
  8031f1:	48 89 e5             	mov    %rsp,%rbp
  8031f4:	48 83 ec 10          	sub    $0x10,%rsp
  8031f8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8031fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803200:	8b 50 0c             	mov    0xc(%rax),%edx
  803203:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80320a:	00 00 00 
  80320d:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80320f:	be 00 00 00 00       	mov    $0x0,%esi
  803214:	bf 06 00 00 00       	mov    $0x6,%edi
  803219:	48 b8 42 30 80 00 00 	movabs $0x803042,%rax
  803220:	00 00 00 
  803223:	ff d0                	callq  *%rax
}
  803225:	c9                   	leaveq 
  803226:	c3                   	retq   

0000000000803227 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803227:	55                   	push   %rbp
  803228:	48 89 e5             	mov    %rsp,%rbp
  80322b:	48 83 ec 30          	sub    $0x30,%rsp
  80322f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803233:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803237:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  80323b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  803242:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803247:	74 07                	je     803250 <devfile_read+0x29>
  803249:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80324e:	75 07                	jne    803257 <devfile_read+0x30>
		return -E_INVAL;
  803250:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803255:	eb 77                	jmp    8032ce <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  803257:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80325b:	8b 50 0c             	mov    0xc(%rax),%edx
  80325e:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803265:	00 00 00 
  803268:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80326a:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803271:	00 00 00 
  803274:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803278:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  80327c:	be 00 00 00 00       	mov    $0x0,%esi
  803281:	bf 03 00 00 00       	mov    $0x3,%edi
  803286:	48 b8 42 30 80 00 00 	movabs $0x803042,%rax
  80328d:	00 00 00 
  803290:	ff d0                	callq  *%rax
  803292:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803295:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803299:	7f 05                	jg     8032a0 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  80329b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80329e:	eb 2e                	jmp    8032ce <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  8032a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032a3:	48 63 d0             	movslq %eax,%rdx
  8032a6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032aa:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8032b1:	00 00 00 
  8032b4:	48 89 c7             	mov    %rax,%rdi
  8032b7:	48 b8 ff 16 80 00 00 	movabs $0x8016ff,%rax
  8032be:	00 00 00 
  8032c1:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  8032c3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032c7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  8032cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8032ce:	c9                   	leaveq 
  8032cf:	c3                   	retq   

00000000008032d0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8032d0:	55                   	push   %rbp
  8032d1:	48 89 e5             	mov    %rsp,%rbp
  8032d4:	48 83 ec 30          	sub    $0x30,%rsp
  8032d8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8032dc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8032e0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  8032e4:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  8032eb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8032f0:	74 07                	je     8032f9 <devfile_write+0x29>
  8032f2:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8032f7:	75 08                	jne    803301 <devfile_write+0x31>
		return r;
  8032f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032fc:	e9 9a 00 00 00       	jmpq   80339b <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  803301:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803305:	8b 50 0c             	mov    0xc(%rax),%edx
  803308:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80330f:	00 00 00 
  803312:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  803314:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  80331b:	00 
  80331c:	76 08                	jbe    803326 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  80331e:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  803325:	00 
	}
	fsipcbuf.write.req_n = n;
  803326:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80332d:	00 00 00 
  803330:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803334:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  803338:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80333c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803340:	48 89 c6             	mov    %rax,%rsi
  803343:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  80334a:	00 00 00 
  80334d:	48 b8 ff 16 80 00 00 	movabs $0x8016ff,%rax
  803354:	00 00 00 
  803357:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  803359:	be 00 00 00 00       	mov    $0x0,%esi
  80335e:	bf 04 00 00 00       	mov    $0x4,%edi
  803363:	48 b8 42 30 80 00 00 	movabs $0x803042,%rax
  80336a:	00 00 00 
  80336d:	ff d0                	callq  *%rax
  80336f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803372:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803376:	7f 20                	jg     803398 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  803378:	48 bf be 53 80 00 00 	movabs $0x8053be,%rdi
  80337f:	00 00 00 
  803382:	b8 00 00 00 00       	mov    $0x0,%eax
  803387:	48 ba 26 08 80 00 00 	movabs $0x800826,%rdx
  80338e:	00 00 00 
  803391:	ff d2                	callq  *%rdx
		return r;
  803393:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803396:	eb 03                	jmp    80339b <devfile_write+0xcb>
	}
	return r;
  803398:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  80339b:	c9                   	leaveq 
  80339c:	c3                   	retq   

000000000080339d <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80339d:	55                   	push   %rbp
  80339e:	48 89 e5             	mov    %rsp,%rbp
  8033a1:	48 83 ec 20          	sub    $0x20,%rsp
  8033a5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8033a9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8033ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033b1:	8b 50 0c             	mov    0xc(%rax),%edx
  8033b4:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8033bb:	00 00 00 
  8033be:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8033c0:	be 00 00 00 00       	mov    $0x0,%esi
  8033c5:	bf 05 00 00 00       	mov    $0x5,%edi
  8033ca:	48 b8 42 30 80 00 00 	movabs $0x803042,%rax
  8033d1:	00 00 00 
  8033d4:	ff d0                	callq  *%rax
  8033d6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033dd:	79 05                	jns    8033e4 <devfile_stat+0x47>
		return r;
  8033df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033e2:	eb 56                	jmp    80343a <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8033e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033e8:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8033ef:	00 00 00 
  8033f2:	48 89 c7             	mov    %rax,%rdi
  8033f5:	48 b8 db 13 80 00 00 	movabs $0x8013db,%rax
  8033fc:	00 00 00 
  8033ff:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803401:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803408:	00 00 00 
  80340b:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803411:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803415:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80341b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803422:	00 00 00 
  803425:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80342b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80342f:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803435:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80343a:	c9                   	leaveq 
  80343b:	c3                   	retq   

000000000080343c <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80343c:	55                   	push   %rbp
  80343d:	48 89 e5             	mov    %rsp,%rbp
  803440:	48 83 ec 10          	sub    $0x10,%rsp
  803444:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803448:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80344b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80344f:	8b 50 0c             	mov    0xc(%rax),%edx
  803452:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803459:	00 00 00 
  80345c:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80345e:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803465:	00 00 00 
  803468:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80346b:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80346e:	be 00 00 00 00       	mov    $0x0,%esi
  803473:	bf 02 00 00 00       	mov    $0x2,%edi
  803478:	48 b8 42 30 80 00 00 	movabs $0x803042,%rax
  80347f:	00 00 00 
  803482:	ff d0                	callq  *%rax
}
  803484:	c9                   	leaveq 
  803485:	c3                   	retq   

0000000000803486 <remove>:

// Delete a file
int
remove(const char *path)
{
  803486:	55                   	push   %rbp
  803487:	48 89 e5             	mov    %rsp,%rbp
  80348a:	48 83 ec 10          	sub    $0x10,%rsp
  80348e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803492:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803496:	48 89 c7             	mov    %rax,%rdi
  803499:	48 b8 6f 13 80 00 00 	movabs $0x80136f,%rax
  8034a0:	00 00 00 
  8034a3:	ff d0                	callq  *%rax
  8034a5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8034aa:	7e 07                	jle    8034b3 <remove+0x2d>
		return -E_BAD_PATH;
  8034ac:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8034b1:	eb 33                	jmp    8034e6 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8034b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034b7:	48 89 c6             	mov    %rax,%rsi
  8034ba:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8034c1:	00 00 00 
  8034c4:	48 b8 db 13 80 00 00 	movabs $0x8013db,%rax
  8034cb:	00 00 00 
  8034ce:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8034d0:	be 00 00 00 00       	mov    $0x0,%esi
  8034d5:	bf 07 00 00 00       	mov    $0x7,%edi
  8034da:	48 b8 42 30 80 00 00 	movabs $0x803042,%rax
  8034e1:	00 00 00 
  8034e4:	ff d0                	callq  *%rax
}
  8034e6:	c9                   	leaveq 
  8034e7:	c3                   	retq   

00000000008034e8 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8034e8:	55                   	push   %rbp
  8034e9:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8034ec:	be 00 00 00 00       	mov    $0x0,%esi
  8034f1:	bf 08 00 00 00       	mov    $0x8,%edi
  8034f6:	48 b8 42 30 80 00 00 	movabs $0x803042,%rax
  8034fd:	00 00 00 
  803500:	ff d0                	callq  *%rax
}
  803502:	5d                   	pop    %rbp
  803503:	c3                   	retq   

0000000000803504 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803504:	55                   	push   %rbp
  803505:	48 89 e5             	mov    %rsp,%rbp
  803508:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80350f:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803516:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  80351d:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803524:	be 00 00 00 00       	mov    $0x0,%esi
  803529:	48 89 c7             	mov    %rax,%rdi
  80352c:	48 b8 c9 30 80 00 00 	movabs $0x8030c9,%rax
  803533:	00 00 00 
  803536:	ff d0                	callq  *%rax
  803538:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  80353b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80353f:	79 28                	jns    803569 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803541:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803544:	89 c6                	mov    %eax,%esi
  803546:	48 bf da 53 80 00 00 	movabs $0x8053da,%rdi
  80354d:	00 00 00 
  803550:	b8 00 00 00 00       	mov    $0x0,%eax
  803555:	48 ba 26 08 80 00 00 	movabs $0x800826,%rdx
  80355c:	00 00 00 
  80355f:	ff d2                	callq  *%rdx
		return fd_src;
  803561:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803564:	e9 74 01 00 00       	jmpq   8036dd <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803569:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803570:	be 01 01 00 00       	mov    $0x101,%esi
  803575:	48 89 c7             	mov    %rax,%rdi
  803578:	48 b8 c9 30 80 00 00 	movabs $0x8030c9,%rax
  80357f:	00 00 00 
  803582:	ff d0                	callq  *%rax
  803584:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803587:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80358b:	79 39                	jns    8035c6 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80358d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803590:	89 c6                	mov    %eax,%esi
  803592:	48 bf f0 53 80 00 00 	movabs $0x8053f0,%rdi
  803599:	00 00 00 
  80359c:	b8 00 00 00 00       	mov    $0x0,%eax
  8035a1:	48 ba 26 08 80 00 00 	movabs $0x800826,%rdx
  8035a8:	00 00 00 
  8035ab:	ff d2                	callq  *%rdx
		close(fd_src);
  8035ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035b0:	89 c7                	mov    %eax,%edi
  8035b2:	48 b8 d1 29 80 00 00 	movabs $0x8029d1,%rax
  8035b9:	00 00 00 
  8035bc:	ff d0                	callq  *%rax
		return fd_dest;
  8035be:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035c1:	e9 17 01 00 00       	jmpq   8036dd <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8035c6:	eb 74                	jmp    80363c <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8035c8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8035cb:	48 63 d0             	movslq %eax,%rdx
  8035ce:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8035d5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035d8:	48 89 ce             	mov    %rcx,%rsi
  8035db:	89 c7                	mov    %eax,%edi
  8035dd:	48 b8 3d 2d 80 00 00 	movabs $0x802d3d,%rax
  8035e4:	00 00 00 
  8035e7:	ff d0                	callq  *%rax
  8035e9:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8035ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8035f0:	79 4a                	jns    80363c <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8035f2:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8035f5:	89 c6                	mov    %eax,%esi
  8035f7:	48 bf 0a 54 80 00 00 	movabs $0x80540a,%rdi
  8035fe:	00 00 00 
  803601:	b8 00 00 00 00       	mov    $0x0,%eax
  803606:	48 ba 26 08 80 00 00 	movabs $0x800826,%rdx
  80360d:	00 00 00 
  803610:	ff d2                	callq  *%rdx
			close(fd_src);
  803612:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803615:	89 c7                	mov    %eax,%edi
  803617:	48 b8 d1 29 80 00 00 	movabs $0x8029d1,%rax
  80361e:	00 00 00 
  803621:	ff d0                	callq  *%rax
			close(fd_dest);
  803623:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803626:	89 c7                	mov    %eax,%edi
  803628:	48 b8 d1 29 80 00 00 	movabs $0x8029d1,%rax
  80362f:	00 00 00 
  803632:	ff d0                	callq  *%rax
			return write_size;
  803634:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803637:	e9 a1 00 00 00       	jmpq   8036dd <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80363c:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803643:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803646:	ba 00 02 00 00       	mov    $0x200,%edx
  80364b:	48 89 ce             	mov    %rcx,%rsi
  80364e:	89 c7                	mov    %eax,%edi
  803650:	48 b8 f3 2b 80 00 00 	movabs $0x802bf3,%rax
  803657:	00 00 00 
  80365a:	ff d0                	callq  *%rax
  80365c:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80365f:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803663:	0f 8f 5f ff ff ff    	jg     8035c8 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803669:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80366d:	79 47                	jns    8036b6 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  80366f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803672:	89 c6                	mov    %eax,%esi
  803674:	48 bf 1d 54 80 00 00 	movabs $0x80541d,%rdi
  80367b:	00 00 00 
  80367e:	b8 00 00 00 00       	mov    $0x0,%eax
  803683:	48 ba 26 08 80 00 00 	movabs $0x800826,%rdx
  80368a:	00 00 00 
  80368d:	ff d2                	callq  *%rdx
		close(fd_src);
  80368f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803692:	89 c7                	mov    %eax,%edi
  803694:	48 b8 d1 29 80 00 00 	movabs $0x8029d1,%rax
  80369b:	00 00 00 
  80369e:	ff d0                	callq  *%rax
		close(fd_dest);
  8036a0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036a3:	89 c7                	mov    %eax,%edi
  8036a5:	48 b8 d1 29 80 00 00 	movabs $0x8029d1,%rax
  8036ac:	00 00 00 
  8036af:	ff d0                	callq  *%rax
		return read_size;
  8036b1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8036b4:	eb 27                	jmp    8036dd <copy+0x1d9>
	}
	close(fd_src);
  8036b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036b9:	89 c7                	mov    %eax,%edi
  8036bb:	48 b8 d1 29 80 00 00 	movabs $0x8029d1,%rax
  8036c2:	00 00 00 
  8036c5:	ff d0                	callq  *%rax
	close(fd_dest);
  8036c7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036ca:	89 c7                	mov    %eax,%edi
  8036cc:	48 b8 d1 29 80 00 00 	movabs $0x8029d1,%rax
  8036d3:	00 00 00 
  8036d6:	ff d0                	callq  *%rax
	return 0;
  8036d8:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8036dd:	c9                   	leaveq 
  8036de:	c3                   	retq   

00000000008036df <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8036df:	55                   	push   %rbp
  8036e0:	48 89 e5             	mov    %rsp,%rbp
  8036e3:	48 83 ec 20          	sub    $0x20,%rsp
  8036e7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8036ea:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8036ee:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036f1:	48 89 d6             	mov    %rdx,%rsi
  8036f4:	89 c7                	mov    %eax,%edi
  8036f6:	48 b8 c1 27 80 00 00 	movabs $0x8027c1,%rax
  8036fd:	00 00 00 
  803700:	ff d0                	callq  *%rax
  803702:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803705:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803709:	79 05                	jns    803710 <fd2sockid+0x31>
		return r;
  80370b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80370e:	eb 24                	jmp    803734 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803710:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803714:	8b 10                	mov    (%rax),%edx
  803716:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  80371d:	00 00 00 
  803720:	8b 00                	mov    (%rax),%eax
  803722:	39 c2                	cmp    %eax,%edx
  803724:	74 07                	je     80372d <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803726:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80372b:	eb 07                	jmp    803734 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  80372d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803731:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803734:	c9                   	leaveq 
  803735:	c3                   	retq   

0000000000803736 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803736:	55                   	push   %rbp
  803737:	48 89 e5             	mov    %rsp,%rbp
  80373a:	48 83 ec 20          	sub    $0x20,%rsp
  80373e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803741:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803745:	48 89 c7             	mov    %rax,%rdi
  803748:	48 b8 29 27 80 00 00 	movabs $0x802729,%rax
  80374f:	00 00 00 
  803752:	ff d0                	callq  *%rax
  803754:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803757:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80375b:	78 26                	js     803783 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80375d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803761:	ba 07 04 00 00       	mov    $0x407,%edx
  803766:	48 89 c6             	mov    %rax,%rsi
  803769:	bf 00 00 00 00       	mov    $0x0,%edi
  80376e:	48 b8 0a 1d 80 00 00 	movabs $0x801d0a,%rax
  803775:	00 00 00 
  803778:	ff d0                	callq  *%rax
  80377a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80377d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803781:	79 16                	jns    803799 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803783:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803786:	89 c7                	mov    %eax,%edi
  803788:	48 b8 43 3c 80 00 00 	movabs $0x803c43,%rax
  80378f:	00 00 00 
  803792:	ff d0                	callq  *%rax
		return r;
  803794:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803797:	eb 3a                	jmp    8037d3 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803799:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80379d:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  8037a4:	00 00 00 
  8037a7:	8b 12                	mov    (%rdx),%edx
  8037a9:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8037ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037af:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8037b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037ba:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8037bd:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8037c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037c4:	48 89 c7             	mov    %rax,%rdi
  8037c7:	48 b8 db 26 80 00 00 	movabs $0x8026db,%rax
  8037ce:	00 00 00 
  8037d1:	ff d0                	callq  *%rax
}
  8037d3:	c9                   	leaveq 
  8037d4:	c3                   	retq   

00000000008037d5 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8037d5:	55                   	push   %rbp
  8037d6:	48 89 e5             	mov    %rsp,%rbp
  8037d9:	48 83 ec 30          	sub    $0x30,%rsp
  8037dd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8037e0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8037e4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8037e8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037eb:	89 c7                	mov    %eax,%edi
  8037ed:	48 b8 df 36 80 00 00 	movabs $0x8036df,%rax
  8037f4:	00 00 00 
  8037f7:	ff d0                	callq  *%rax
  8037f9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803800:	79 05                	jns    803807 <accept+0x32>
		return r;
  803802:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803805:	eb 3b                	jmp    803842 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803807:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80380b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80380f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803812:	48 89 ce             	mov    %rcx,%rsi
  803815:	89 c7                	mov    %eax,%edi
  803817:	48 b8 20 3b 80 00 00 	movabs $0x803b20,%rax
  80381e:	00 00 00 
  803821:	ff d0                	callq  *%rax
  803823:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803826:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80382a:	79 05                	jns    803831 <accept+0x5c>
		return r;
  80382c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80382f:	eb 11                	jmp    803842 <accept+0x6d>
	return alloc_sockfd(r);
  803831:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803834:	89 c7                	mov    %eax,%edi
  803836:	48 b8 36 37 80 00 00 	movabs $0x803736,%rax
  80383d:	00 00 00 
  803840:	ff d0                	callq  *%rax
}
  803842:	c9                   	leaveq 
  803843:	c3                   	retq   

0000000000803844 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
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
  80385b:	48 b8 df 36 80 00 00 	movabs $0x8036df,%rax
  803862:	00 00 00 
  803865:	ff d0                	callq  *%rax
  803867:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80386a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80386e:	79 05                	jns    803875 <bind+0x31>
		return r;
  803870:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803873:	eb 1b                	jmp    803890 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803875:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803878:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80387c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80387f:	48 89 ce             	mov    %rcx,%rsi
  803882:	89 c7                	mov    %eax,%edi
  803884:	48 b8 9f 3b 80 00 00 	movabs $0x803b9f,%rax
  80388b:	00 00 00 
  80388e:	ff d0                	callq  *%rax
}
  803890:	c9                   	leaveq 
  803891:	c3                   	retq   

0000000000803892 <shutdown>:

int
shutdown(int s, int how)
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
  8038a5:	48 b8 df 36 80 00 00 	movabs $0x8036df,%rax
  8038ac:	00 00 00 
  8038af:	ff d0                	callq  *%rax
  8038b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038b8:	79 05                	jns    8038bf <shutdown+0x2d>
		return r;
  8038ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038bd:	eb 16                	jmp    8038d5 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8038bf:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8038c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038c5:	89 d6                	mov    %edx,%esi
  8038c7:	89 c7                	mov    %eax,%edi
  8038c9:	48 b8 03 3c 80 00 00 	movabs $0x803c03,%rax
  8038d0:	00 00 00 
  8038d3:	ff d0                	callq  *%rax
}
  8038d5:	c9                   	leaveq 
  8038d6:	c3                   	retq   

00000000008038d7 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8038d7:	55                   	push   %rbp
  8038d8:	48 89 e5             	mov    %rsp,%rbp
  8038db:	48 83 ec 10          	sub    $0x10,%rsp
  8038df:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8038e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038e7:	48 89 c7             	mov    %rax,%rdi
  8038ea:	48 b8 2e 4b 80 00 00 	movabs $0x804b2e,%rax
  8038f1:	00 00 00 
  8038f4:	ff d0                	callq  *%rax
  8038f6:	83 f8 01             	cmp    $0x1,%eax
  8038f9:	75 17                	jne    803912 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8038fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038ff:	8b 40 0c             	mov    0xc(%rax),%eax
  803902:	89 c7                	mov    %eax,%edi
  803904:	48 b8 43 3c 80 00 00 	movabs $0x803c43,%rax
  80390b:	00 00 00 
  80390e:	ff d0                	callq  *%rax
  803910:	eb 05                	jmp    803917 <devsock_close+0x40>
	else
		return 0;
  803912:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803917:	c9                   	leaveq 
  803918:	c3                   	retq   

0000000000803919 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803919:	55                   	push   %rbp
  80391a:	48 89 e5             	mov    %rsp,%rbp
  80391d:	48 83 ec 20          	sub    $0x20,%rsp
  803921:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803924:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803928:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80392b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80392e:	89 c7                	mov    %eax,%edi
  803930:	48 b8 df 36 80 00 00 	movabs $0x8036df,%rax
  803937:	00 00 00 
  80393a:	ff d0                	callq  *%rax
  80393c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80393f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803943:	79 05                	jns    80394a <connect+0x31>
		return r;
  803945:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803948:	eb 1b                	jmp    803965 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80394a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80394d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803951:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803954:	48 89 ce             	mov    %rcx,%rsi
  803957:	89 c7                	mov    %eax,%edi
  803959:	48 b8 70 3c 80 00 00 	movabs $0x803c70,%rax
  803960:	00 00 00 
  803963:	ff d0                	callq  *%rax
}
  803965:	c9                   	leaveq 
  803966:	c3                   	retq   

0000000000803967 <listen>:

int
listen(int s, int backlog)
{
  803967:	55                   	push   %rbp
  803968:	48 89 e5             	mov    %rsp,%rbp
  80396b:	48 83 ec 20          	sub    $0x20,%rsp
  80396f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803972:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803975:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803978:	89 c7                	mov    %eax,%edi
  80397a:	48 b8 df 36 80 00 00 	movabs $0x8036df,%rax
  803981:	00 00 00 
  803984:	ff d0                	callq  *%rax
  803986:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803989:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80398d:	79 05                	jns    803994 <listen+0x2d>
		return r;
  80398f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803992:	eb 16                	jmp    8039aa <listen+0x43>
	return nsipc_listen(r, backlog);
  803994:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803997:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80399a:	89 d6                	mov    %edx,%esi
  80399c:	89 c7                	mov    %eax,%edi
  80399e:	48 b8 d4 3c 80 00 00 	movabs $0x803cd4,%rax
  8039a5:	00 00 00 
  8039a8:	ff d0                	callq  *%rax
}
  8039aa:	c9                   	leaveq 
  8039ab:	c3                   	retq   

00000000008039ac <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8039ac:	55                   	push   %rbp
  8039ad:	48 89 e5             	mov    %rsp,%rbp
  8039b0:	48 83 ec 20          	sub    $0x20,%rsp
  8039b4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8039b8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8039bc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8039c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039c4:	89 c2                	mov    %eax,%edx
  8039c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039ca:	8b 40 0c             	mov    0xc(%rax),%eax
  8039cd:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8039d1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8039d6:	89 c7                	mov    %eax,%edi
  8039d8:	48 b8 14 3d 80 00 00 	movabs $0x803d14,%rax
  8039df:	00 00 00 
  8039e2:	ff d0                	callq  *%rax
}
  8039e4:	c9                   	leaveq 
  8039e5:	c3                   	retq   

00000000008039e6 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8039e6:	55                   	push   %rbp
  8039e7:	48 89 e5             	mov    %rsp,%rbp
  8039ea:	48 83 ec 20          	sub    $0x20,%rsp
  8039ee:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8039f2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8039f6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8039fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039fe:	89 c2                	mov    %eax,%edx
  803a00:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a04:	8b 40 0c             	mov    0xc(%rax),%eax
  803a07:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803a0b:	b9 00 00 00 00       	mov    $0x0,%ecx
  803a10:	89 c7                	mov    %eax,%edi
  803a12:	48 b8 e0 3d 80 00 00 	movabs $0x803de0,%rax
  803a19:	00 00 00 
  803a1c:	ff d0                	callq  *%rax
}
  803a1e:	c9                   	leaveq 
  803a1f:	c3                   	retq   

0000000000803a20 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803a20:	55                   	push   %rbp
  803a21:	48 89 e5             	mov    %rsp,%rbp
  803a24:	48 83 ec 10          	sub    $0x10,%rsp
  803a28:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803a2c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803a30:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a34:	48 be 38 54 80 00 00 	movabs $0x805438,%rsi
  803a3b:	00 00 00 
  803a3e:	48 89 c7             	mov    %rax,%rdi
  803a41:	48 b8 db 13 80 00 00 	movabs $0x8013db,%rax
  803a48:	00 00 00 
  803a4b:	ff d0                	callq  *%rax
	return 0;
  803a4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a52:	c9                   	leaveq 
  803a53:	c3                   	retq   

0000000000803a54 <socket>:

int
socket(int domain, int type, int protocol)
{
  803a54:	55                   	push   %rbp
  803a55:	48 89 e5             	mov    %rsp,%rbp
  803a58:	48 83 ec 20          	sub    $0x20,%rsp
  803a5c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a5f:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803a62:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803a65:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803a68:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803a6b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a6e:	89 ce                	mov    %ecx,%esi
  803a70:	89 c7                	mov    %eax,%edi
  803a72:	48 b8 98 3e 80 00 00 	movabs $0x803e98,%rax
  803a79:	00 00 00 
  803a7c:	ff d0                	callq  *%rax
  803a7e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a81:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a85:	79 05                	jns    803a8c <socket+0x38>
		return r;
  803a87:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a8a:	eb 11                	jmp    803a9d <socket+0x49>
	return alloc_sockfd(r);
  803a8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a8f:	89 c7                	mov    %eax,%edi
  803a91:	48 b8 36 37 80 00 00 	movabs $0x803736,%rax
  803a98:	00 00 00 
  803a9b:	ff d0                	callq  *%rax
}
  803a9d:	c9                   	leaveq 
  803a9e:	c3                   	retq   

0000000000803a9f <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803a9f:	55                   	push   %rbp
  803aa0:	48 89 e5             	mov    %rsp,%rbp
  803aa3:	48 83 ec 10          	sub    $0x10,%rsp
  803aa7:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803aaa:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803ab1:	00 00 00 
  803ab4:	8b 00                	mov    (%rax),%eax
  803ab6:	85 c0                	test   %eax,%eax
  803ab8:	75 1d                	jne    803ad7 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803aba:	bf 02 00 00 00       	mov    $0x2,%edi
  803abf:	48 b8 ac 4a 80 00 00 	movabs $0x804aac,%rax
  803ac6:	00 00 00 
  803ac9:	ff d0                	callq  *%rax
  803acb:	48 ba 04 80 80 00 00 	movabs $0x808004,%rdx
  803ad2:	00 00 00 
  803ad5:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803ad7:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803ade:	00 00 00 
  803ae1:	8b 00                	mov    (%rax),%eax
  803ae3:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803ae6:	b9 07 00 00 00       	mov    $0x7,%ecx
  803aeb:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803af2:	00 00 00 
  803af5:	89 c7                	mov    %eax,%edi
  803af7:	48 b8 4a 4a 80 00 00 	movabs $0x804a4a,%rax
  803afe:	00 00 00 
  803b01:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803b03:	ba 00 00 00 00       	mov    $0x0,%edx
  803b08:	be 00 00 00 00       	mov    $0x0,%esi
  803b0d:	bf 00 00 00 00       	mov    $0x0,%edi
  803b12:	48 b8 44 49 80 00 00 	movabs $0x804944,%rax
  803b19:	00 00 00 
  803b1c:	ff d0                	callq  *%rax
}
  803b1e:	c9                   	leaveq 
  803b1f:	c3                   	retq   

0000000000803b20 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803b20:	55                   	push   %rbp
  803b21:	48 89 e5             	mov    %rsp,%rbp
  803b24:	48 83 ec 30          	sub    $0x30,%rsp
  803b28:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b2b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803b2f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803b33:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b3a:	00 00 00 
  803b3d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803b40:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803b42:	bf 01 00 00 00       	mov    $0x1,%edi
  803b47:	48 b8 9f 3a 80 00 00 	movabs $0x803a9f,%rax
  803b4e:	00 00 00 
  803b51:	ff d0                	callq  *%rax
  803b53:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b56:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b5a:	78 3e                	js     803b9a <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803b5c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b63:	00 00 00 
  803b66:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803b6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b6e:	8b 40 10             	mov    0x10(%rax),%eax
  803b71:	89 c2                	mov    %eax,%edx
  803b73:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803b77:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b7b:	48 89 ce             	mov    %rcx,%rsi
  803b7e:	48 89 c7             	mov    %rax,%rdi
  803b81:	48 b8 ff 16 80 00 00 	movabs $0x8016ff,%rax
  803b88:	00 00 00 
  803b8b:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803b8d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b91:	8b 50 10             	mov    0x10(%rax),%edx
  803b94:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b98:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803b9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803b9d:	c9                   	leaveq 
  803b9e:	c3                   	retq   

0000000000803b9f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803b9f:	55                   	push   %rbp
  803ba0:	48 89 e5             	mov    %rsp,%rbp
  803ba3:	48 83 ec 10          	sub    $0x10,%rsp
  803ba7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803baa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803bae:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803bb1:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bb8:	00 00 00 
  803bbb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803bbe:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803bc0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803bc3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bc7:	48 89 c6             	mov    %rax,%rsi
  803bca:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803bd1:	00 00 00 
  803bd4:	48 b8 ff 16 80 00 00 	movabs $0x8016ff,%rax
  803bdb:	00 00 00 
  803bde:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803be0:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803be7:	00 00 00 
  803bea:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803bed:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803bf0:	bf 02 00 00 00       	mov    $0x2,%edi
  803bf5:	48 b8 9f 3a 80 00 00 	movabs $0x803a9f,%rax
  803bfc:	00 00 00 
  803bff:	ff d0                	callq  *%rax
}
  803c01:	c9                   	leaveq 
  803c02:	c3                   	retq   

0000000000803c03 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803c03:	55                   	push   %rbp
  803c04:	48 89 e5             	mov    %rsp,%rbp
  803c07:	48 83 ec 10          	sub    $0x10,%rsp
  803c0b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c0e:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803c11:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c18:	00 00 00 
  803c1b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c1e:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803c20:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c27:	00 00 00 
  803c2a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c2d:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803c30:	bf 03 00 00 00       	mov    $0x3,%edi
  803c35:	48 b8 9f 3a 80 00 00 	movabs $0x803a9f,%rax
  803c3c:	00 00 00 
  803c3f:	ff d0                	callq  *%rax
}
  803c41:	c9                   	leaveq 
  803c42:	c3                   	retq   

0000000000803c43 <nsipc_close>:

int
nsipc_close(int s)
{
  803c43:	55                   	push   %rbp
  803c44:	48 89 e5             	mov    %rsp,%rbp
  803c47:	48 83 ec 10          	sub    $0x10,%rsp
  803c4b:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803c4e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c55:	00 00 00 
  803c58:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c5b:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803c5d:	bf 04 00 00 00       	mov    $0x4,%edi
  803c62:	48 b8 9f 3a 80 00 00 	movabs $0x803a9f,%rax
  803c69:	00 00 00 
  803c6c:	ff d0                	callq  *%rax
}
  803c6e:	c9                   	leaveq 
  803c6f:	c3                   	retq   

0000000000803c70 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803c70:	55                   	push   %rbp
  803c71:	48 89 e5             	mov    %rsp,%rbp
  803c74:	48 83 ec 10          	sub    $0x10,%rsp
  803c78:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c7b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803c7f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803c82:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c89:	00 00 00 
  803c8c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c8f:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803c91:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c94:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c98:	48 89 c6             	mov    %rax,%rsi
  803c9b:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803ca2:	00 00 00 
  803ca5:	48 b8 ff 16 80 00 00 	movabs $0x8016ff,%rax
  803cac:	00 00 00 
  803caf:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803cb1:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cb8:	00 00 00 
  803cbb:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803cbe:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803cc1:	bf 05 00 00 00       	mov    $0x5,%edi
  803cc6:	48 b8 9f 3a 80 00 00 	movabs $0x803a9f,%rax
  803ccd:	00 00 00 
  803cd0:	ff d0                	callq  *%rax
}
  803cd2:	c9                   	leaveq 
  803cd3:	c3                   	retq   

0000000000803cd4 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803cd4:	55                   	push   %rbp
  803cd5:	48 89 e5             	mov    %rsp,%rbp
  803cd8:	48 83 ec 10          	sub    $0x10,%rsp
  803cdc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803cdf:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803ce2:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ce9:	00 00 00 
  803cec:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803cef:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803cf1:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cf8:	00 00 00 
  803cfb:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803cfe:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803d01:	bf 06 00 00 00       	mov    $0x6,%edi
  803d06:	48 b8 9f 3a 80 00 00 	movabs $0x803a9f,%rax
  803d0d:	00 00 00 
  803d10:	ff d0                	callq  *%rax
}
  803d12:	c9                   	leaveq 
  803d13:	c3                   	retq   

0000000000803d14 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803d14:	55                   	push   %rbp
  803d15:	48 89 e5             	mov    %rsp,%rbp
  803d18:	48 83 ec 30          	sub    $0x30,%rsp
  803d1c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d1f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d23:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803d26:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803d29:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d30:	00 00 00 
  803d33:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803d36:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803d38:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d3f:	00 00 00 
  803d42:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803d45:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803d48:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d4f:	00 00 00 
  803d52:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803d55:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803d58:	bf 07 00 00 00       	mov    $0x7,%edi
  803d5d:	48 b8 9f 3a 80 00 00 	movabs $0x803a9f,%rax
  803d64:	00 00 00 
  803d67:	ff d0                	callq  *%rax
  803d69:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d6c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d70:	78 69                	js     803ddb <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803d72:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803d79:	7f 08                	jg     803d83 <nsipc_recv+0x6f>
  803d7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d7e:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803d81:	7e 35                	jle    803db8 <nsipc_recv+0xa4>
  803d83:	48 b9 3f 54 80 00 00 	movabs $0x80543f,%rcx
  803d8a:	00 00 00 
  803d8d:	48 ba 54 54 80 00 00 	movabs $0x805454,%rdx
  803d94:	00 00 00 
  803d97:	be 61 00 00 00       	mov    $0x61,%esi
  803d9c:	48 bf 69 54 80 00 00 	movabs $0x805469,%rdi
  803da3:	00 00 00 
  803da6:	b8 00 00 00 00       	mov    $0x0,%eax
  803dab:	49 b8 ed 05 80 00 00 	movabs $0x8005ed,%r8
  803db2:	00 00 00 
  803db5:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803db8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dbb:	48 63 d0             	movslq %eax,%rdx
  803dbe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803dc2:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803dc9:	00 00 00 
  803dcc:	48 89 c7             	mov    %rax,%rdi
  803dcf:	48 b8 ff 16 80 00 00 	movabs $0x8016ff,%rax
  803dd6:	00 00 00 
  803dd9:	ff d0                	callq  *%rax
	}

	return r;
  803ddb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803dde:	c9                   	leaveq 
  803ddf:	c3                   	retq   

0000000000803de0 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803de0:	55                   	push   %rbp
  803de1:	48 89 e5             	mov    %rsp,%rbp
  803de4:	48 83 ec 20          	sub    $0x20,%rsp
  803de8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803deb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803def:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803df2:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803df5:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803dfc:	00 00 00 
  803dff:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803e02:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803e04:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803e0b:	7e 35                	jle    803e42 <nsipc_send+0x62>
  803e0d:	48 b9 75 54 80 00 00 	movabs $0x805475,%rcx
  803e14:	00 00 00 
  803e17:	48 ba 54 54 80 00 00 	movabs $0x805454,%rdx
  803e1e:	00 00 00 
  803e21:	be 6c 00 00 00       	mov    $0x6c,%esi
  803e26:	48 bf 69 54 80 00 00 	movabs $0x805469,%rdi
  803e2d:	00 00 00 
  803e30:	b8 00 00 00 00       	mov    $0x0,%eax
  803e35:	49 b8 ed 05 80 00 00 	movabs $0x8005ed,%r8
  803e3c:	00 00 00 
  803e3f:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803e42:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e45:	48 63 d0             	movslq %eax,%rdx
  803e48:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e4c:	48 89 c6             	mov    %rax,%rsi
  803e4f:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803e56:	00 00 00 
  803e59:	48 b8 ff 16 80 00 00 	movabs $0x8016ff,%rax
  803e60:	00 00 00 
  803e63:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803e65:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e6c:	00 00 00 
  803e6f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803e72:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803e75:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e7c:	00 00 00 
  803e7f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803e82:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803e85:	bf 08 00 00 00       	mov    $0x8,%edi
  803e8a:	48 b8 9f 3a 80 00 00 	movabs $0x803a9f,%rax
  803e91:	00 00 00 
  803e94:	ff d0                	callq  *%rax
}
  803e96:	c9                   	leaveq 
  803e97:	c3                   	retq   

0000000000803e98 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803e98:	55                   	push   %rbp
  803e99:	48 89 e5             	mov    %rsp,%rbp
  803e9c:	48 83 ec 10          	sub    $0x10,%rsp
  803ea0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ea3:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803ea6:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803ea9:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803eb0:	00 00 00 
  803eb3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803eb6:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803eb8:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ebf:	00 00 00 
  803ec2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803ec5:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803ec8:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ecf:	00 00 00 
  803ed2:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803ed5:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803ed8:	bf 09 00 00 00       	mov    $0x9,%edi
  803edd:	48 b8 9f 3a 80 00 00 	movabs $0x803a9f,%rax
  803ee4:	00 00 00 
  803ee7:	ff d0                	callq  *%rax
}
  803ee9:	c9                   	leaveq 
  803eea:	c3                   	retq   

0000000000803eeb <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803eeb:	55                   	push   %rbp
  803eec:	48 89 e5             	mov    %rsp,%rbp
  803eef:	53                   	push   %rbx
  803ef0:	48 83 ec 38          	sub    $0x38,%rsp
  803ef4:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803ef8:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803efc:	48 89 c7             	mov    %rax,%rdi
  803eff:	48 b8 29 27 80 00 00 	movabs $0x802729,%rax
  803f06:	00 00 00 
  803f09:	ff d0                	callq  *%rax
  803f0b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f0e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f12:	0f 88 bf 01 00 00    	js     8040d7 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803f18:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f1c:	ba 07 04 00 00       	mov    $0x407,%edx
  803f21:	48 89 c6             	mov    %rax,%rsi
  803f24:	bf 00 00 00 00       	mov    $0x0,%edi
  803f29:	48 b8 0a 1d 80 00 00 	movabs $0x801d0a,%rax
  803f30:	00 00 00 
  803f33:	ff d0                	callq  *%rax
  803f35:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f38:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f3c:	0f 88 95 01 00 00    	js     8040d7 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803f42:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803f46:	48 89 c7             	mov    %rax,%rdi
  803f49:	48 b8 29 27 80 00 00 	movabs $0x802729,%rax
  803f50:	00 00 00 
  803f53:	ff d0                	callq  *%rax
  803f55:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f58:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f5c:	0f 88 5d 01 00 00    	js     8040bf <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803f62:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f66:	ba 07 04 00 00       	mov    $0x407,%edx
  803f6b:	48 89 c6             	mov    %rax,%rsi
  803f6e:	bf 00 00 00 00       	mov    $0x0,%edi
  803f73:	48 b8 0a 1d 80 00 00 	movabs $0x801d0a,%rax
  803f7a:	00 00 00 
  803f7d:	ff d0                	callq  *%rax
  803f7f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f82:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f86:	0f 88 33 01 00 00    	js     8040bf <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803f8c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f90:	48 89 c7             	mov    %rax,%rdi
  803f93:	48 b8 fe 26 80 00 00 	movabs $0x8026fe,%rax
  803f9a:	00 00 00 
  803f9d:	ff d0                	callq  *%rax
  803f9f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803fa3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fa7:	ba 07 04 00 00       	mov    $0x407,%edx
  803fac:	48 89 c6             	mov    %rax,%rsi
  803faf:	bf 00 00 00 00       	mov    $0x0,%edi
  803fb4:	48 b8 0a 1d 80 00 00 	movabs $0x801d0a,%rax
  803fbb:	00 00 00 
  803fbe:	ff d0                	callq  *%rax
  803fc0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803fc3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803fc7:	79 05                	jns    803fce <pipe+0xe3>
		goto err2;
  803fc9:	e9 d9 00 00 00       	jmpq   8040a7 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803fce:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803fd2:	48 89 c7             	mov    %rax,%rdi
  803fd5:	48 b8 fe 26 80 00 00 	movabs $0x8026fe,%rax
  803fdc:	00 00 00 
  803fdf:	ff d0                	callq  *%rax
  803fe1:	48 89 c2             	mov    %rax,%rdx
  803fe4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fe8:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803fee:	48 89 d1             	mov    %rdx,%rcx
  803ff1:	ba 00 00 00 00       	mov    $0x0,%edx
  803ff6:	48 89 c6             	mov    %rax,%rsi
  803ff9:	bf 00 00 00 00       	mov    $0x0,%edi
  803ffe:	48 b8 5a 1d 80 00 00 	movabs $0x801d5a,%rax
  804005:	00 00 00 
  804008:	ff d0                	callq  *%rax
  80400a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80400d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804011:	79 1b                	jns    80402e <pipe+0x143>
		goto err3;
  804013:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  804014:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804018:	48 89 c6             	mov    %rax,%rsi
  80401b:	bf 00 00 00 00       	mov    $0x0,%edi
  804020:	48 b8 b5 1d 80 00 00 	movabs $0x801db5,%rax
  804027:	00 00 00 
  80402a:	ff d0                	callq  *%rax
  80402c:	eb 79                	jmp    8040a7 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80402e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804032:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  804039:	00 00 00 
  80403c:	8b 12                	mov    (%rdx),%edx
  80403e:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  804040:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804044:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80404b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80404f:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  804056:	00 00 00 
  804059:	8b 12                	mov    (%rdx),%edx
  80405b:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80405d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804061:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  804068:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80406c:	48 89 c7             	mov    %rax,%rdi
  80406f:	48 b8 db 26 80 00 00 	movabs $0x8026db,%rax
  804076:	00 00 00 
  804079:	ff d0                	callq  *%rax
  80407b:	89 c2                	mov    %eax,%edx
  80407d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804081:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  804083:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804087:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80408b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80408f:	48 89 c7             	mov    %rax,%rdi
  804092:	48 b8 db 26 80 00 00 	movabs $0x8026db,%rax
  804099:	00 00 00 
  80409c:	ff d0                	callq  *%rax
  80409e:	89 03                	mov    %eax,(%rbx)
	return 0;
  8040a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8040a5:	eb 33                	jmp    8040da <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8040a7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040ab:	48 89 c6             	mov    %rax,%rsi
  8040ae:	bf 00 00 00 00       	mov    $0x0,%edi
  8040b3:	48 b8 b5 1d 80 00 00 	movabs $0x801db5,%rax
  8040ba:	00 00 00 
  8040bd:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8040bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040c3:	48 89 c6             	mov    %rax,%rsi
  8040c6:	bf 00 00 00 00       	mov    $0x0,%edi
  8040cb:	48 b8 b5 1d 80 00 00 	movabs $0x801db5,%rax
  8040d2:	00 00 00 
  8040d5:	ff d0                	callq  *%rax
err:
	return r;
  8040d7:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8040da:	48 83 c4 38          	add    $0x38,%rsp
  8040de:	5b                   	pop    %rbx
  8040df:	5d                   	pop    %rbp
  8040e0:	c3                   	retq   

00000000008040e1 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8040e1:	55                   	push   %rbp
  8040e2:	48 89 e5             	mov    %rsp,%rbp
  8040e5:	53                   	push   %rbx
  8040e6:	48 83 ec 28          	sub    $0x28,%rsp
  8040ea:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8040ee:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8040f2:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8040f9:	00 00 00 
  8040fc:	48 8b 00             	mov    (%rax),%rax
  8040ff:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804105:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  804108:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80410c:	48 89 c7             	mov    %rax,%rdi
  80410f:	48 b8 2e 4b 80 00 00 	movabs $0x804b2e,%rax
  804116:	00 00 00 
  804119:	ff d0                	callq  *%rax
  80411b:	89 c3                	mov    %eax,%ebx
  80411d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804121:	48 89 c7             	mov    %rax,%rdi
  804124:	48 b8 2e 4b 80 00 00 	movabs $0x804b2e,%rax
  80412b:	00 00 00 
  80412e:	ff d0                	callq  *%rax
  804130:	39 c3                	cmp    %eax,%ebx
  804132:	0f 94 c0             	sete   %al
  804135:	0f b6 c0             	movzbl %al,%eax
  804138:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80413b:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804142:	00 00 00 
  804145:	48 8b 00             	mov    (%rax),%rax
  804148:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80414e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  804151:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804154:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804157:	75 05                	jne    80415e <_pipeisclosed+0x7d>
			return ret;
  804159:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80415c:	eb 4f                	jmp    8041ad <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80415e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804161:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804164:	74 42                	je     8041a8 <_pipeisclosed+0xc7>
  804166:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80416a:	75 3c                	jne    8041a8 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80416c:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804173:	00 00 00 
  804176:	48 8b 00             	mov    (%rax),%rax
  804179:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80417f:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804182:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804185:	89 c6                	mov    %eax,%esi
  804187:	48 bf 86 54 80 00 00 	movabs $0x805486,%rdi
  80418e:	00 00 00 
  804191:	b8 00 00 00 00       	mov    $0x0,%eax
  804196:	49 b8 26 08 80 00 00 	movabs $0x800826,%r8
  80419d:	00 00 00 
  8041a0:	41 ff d0             	callq  *%r8
	}
  8041a3:	e9 4a ff ff ff       	jmpq   8040f2 <_pipeisclosed+0x11>
  8041a8:	e9 45 ff ff ff       	jmpq   8040f2 <_pipeisclosed+0x11>
}
  8041ad:	48 83 c4 28          	add    $0x28,%rsp
  8041b1:	5b                   	pop    %rbx
  8041b2:	5d                   	pop    %rbp
  8041b3:	c3                   	retq   

00000000008041b4 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8041b4:	55                   	push   %rbp
  8041b5:	48 89 e5             	mov    %rsp,%rbp
  8041b8:	48 83 ec 30          	sub    $0x30,%rsp
  8041bc:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8041bf:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8041c3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8041c6:	48 89 d6             	mov    %rdx,%rsi
  8041c9:	89 c7                	mov    %eax,%edi
  8041cb:	48 b8 c1 27 80 00 00 	movabs $0x8027c1,%rax
  8041d2:	00 00 00 
  8041d5:	ff d0                	callq  *%rax
  8041d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8041da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041de:	79 05                	jns    8041e5 <pipeisclosed+0x31>
		return r;
  8041e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041e3:	eb 31                	jmp    804216 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8041e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041e9:	48 89 c7             	mov    %rax,%rdi
  8041ec:	48 b8 fe 26 80 00 00 	movabs $0x8026fe,%rax
  8041f3:	00 00 00 
  8041f6:	ff d0                	callq  *%rax
  8041f8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8041fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804200:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804204:	48 89 d6             	mov    %rdx,%rsi
  804207:	48 89 c7             	mov    %rax,%rdi
  80420a:	48 b8 e1 40 80 00 00 	movabs $0x8040e1,%rax
  804211:	00 00 00 
  804214:	ff d0                	callq  *%rax
}
  804216:	c9                   	leaveq 
  804217:	c3                   	retq   

0000000000804218 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804218:	55                   	push   %rbp
  804219:	48 89 e5             	mov    %rsp,%rbp
  80421c:	48 83 ec 40          	sub    $0x40,%rsp
  804220:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804224:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804228:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80422c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804230:	48 89 c7             	mov    %rax,%rdi
  804233:	48 b8 fe 26 80 00 00 	movabs $0x8026fe,%rax
  80423a:	00 00 00 
  80423d:	ff d0                	callq  *%rax
  80423f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804243:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804247:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80424b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804252:	00 
  804253:	e9 92 00 00 00       	jmpq   8042ea <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  804258:	eb 41                	jmp    80429b <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80425a:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80425f:	74 09                	je     80426a <devpipe_read+0x52>
				return i;
  804261:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804265:	e9 92 00 00 00       	jmpq   8042fc <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80426a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80426e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804272:	48 89 d6             	mov    %rdx,%rsi
  804275:	48 89 c7             	mov    %rax,%rdi
  804278:	48 b8 e1 40 80 00 00 	movabs $0x8040e1,%rax
  80427f:	00 00 00 
  804282:	ff d0                	callq  *%rax
  804284:	85 c0                	test   %eax,%eax
  804286:	74 07                	je     80428f <devpipe_read+0x77>
				return 0;
  804288:	b8 00 00 00 00       	mov    $0x0,%eax
  80428d:	eb 6d                	jmp    8042fc <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80428f:	48 b8 cc 1c 80 00 00 	movabs $0x801ccc,%rax
  804296:	00 00 00 
  804299:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80429b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80429f:	8b 10                	mov    (%rax),%edx
  8042a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042a5:	8b 40 04             	mov    0x4(%rax),%eax
  8042a8:	39 c2                	cmp    %eax,%edx
  8042aa:	74 ae                	je     80425a <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8042ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042b0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8042b4:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8042b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042bc:	8b 00                	mov    (%rax),%eax
  8042be:	99                   	cltd   
  8042bf:	c1 ea 1b             	shr    $0x1b,%edx
  8042c2:	01 d0                	add    %edx,%eax
  8042c4:	83 e0 1f             	and    $0x1f,%eax
  8042c7:	29 d0                	sub    %edx,%eax
  8042c9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8042cd:	48 98                	cltq   
  8042cf:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8042d4:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8042d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042da:	8b 00                	mov    (%rax),%eax
  8042dc:	8d 50 01             	lea    0x1(%rax),%edx
  8042df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042e3:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8042e5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8042ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042ee:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8042f2:	0f 82 60 ff ff ff    	jb     804258 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8042f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8042fc:	c9                   	leaveq 
  8042fd:	c3                   	retq   

00000000008042fe <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8042fe:	55                   	push   %rbp
  8042ff:	48 89 e5             	mov    %rsp,%rbp
  804302:	48 83 ec 40          	sub    $0x40,%rsp
  804306:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80430a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80430e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804312:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804316:	48 89 c7             	mov    %rax,%rdi
  804319:	48 b8 fe 26 80 00 00 	movabs $0x8026fe,%rax
  804320:	00 00 00 
  804323:	ff d0                	callq  *%rax
  804325:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804329:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80432d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804331:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804338:	00 
  804339:	e9 8e 00 00 00       	jmpq   8043cc <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80433e:	eb 31                	jmp    804371 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804340:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804344:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804348:	48 89 d6             	mov    %rdx,%rsi
  80434b:	48 89 c7             	mov    %rax,%rdi
  80434e:	48 b8 e1 40 80 00 00 	movabs $0x8040e1,%rax
  804355:	00 00 00 
  804358:	ff d0                	callq  *%rax
  80435a:	85 c0                	test   %eax,%eax
  80435c:	74 07                	je     804365 <devpipe_write+0x67>
				return 0;
  80435e:	b8 00 00 00 00       	mov    $0x0,%eax
  804363:	eb 79                	jmp    8043de <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804365:	48 b8 cc 1c 80 00 00 	movabs $0x801ccc,%rax
  80436c:	00 00 00 
  80436f:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804371:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804375:	8b 40 04             	mov    0x4(%rax),%eax
  804378:	48 63 d0             	movslq %eax,%rdx
  80437b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80437f:	8b 00                	mov    (%rax),%eax
  804381:	48 98                	cltq   
  804383:	48 83 c0 20          	add    $0x20,%rax
  804387:	48 39 c2             	cmp    %rax,%rdx
  80438a:	73 b4                	jae    804340 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80438c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804390:	8b 40 04             	mov    0x4(%rax),%eax
  804393:	99                   	cltd   
  804394:	c1 ea 1b             	shr    $0x1b,%edx
  804397:	01 d0                	add    %edx,%eax
  804399:	83 e0 1f             	and    $0x1f,%eax
  80439c:	29 d0                	sub    %edx,%eax
  80439e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8043a2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8043a6:	48 01 ca             	add    %rcx,%rdx
  8043a9:	0f b6 0a             	movzbl (%rdx),%ecx
  8043ac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8043b0:	48 98                	cltq   
  8043b2:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8043b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043ba:	8b 40 04             	mov    0x4(%rax),%eax
  8043bd:	8d 50 01             	lea    0x1(%rax),%edx
  8043c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043c4:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8043c7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8043cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043d0:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8043d4:	0f 82 64 ff ff ff    	jb     80433e <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8043da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8043de:	c9                   	leaveq 
  8043df:	c3                   	retq   

00000000008043e0 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8043e0:	55                   	push   %rbp
  8043e1:	48 89 e5             	mov    %rsp,%rbp
  8043e4:	48 83 ec 20          	sub    $0x20,%rsp
  8043e8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8043ec:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8043f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8043f4:	48 89 c7             	mov    %rax,%rdi
  8043f7:	48 b8 fe 26 80 00 00 	movabs $0x8026fe,%rax
  8043fe:	00 00 00 
  804401:	ff d0                	callq  *%rax
  804403:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804407:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80440b:	48 be 99 54 80 00 00 	movabs $0x805499,%rsi
  804412:	00 00 00 
  804415:	48 89 c7             	mov    %rax,%rdi
  804418:	48 b8 db 13 80 00 00 	movabs $0x8013db,%rax
  80441f:	00 00 00 
  804422:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804424:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804428:	8b 50 04             	mov    0x4(%rax),%edx
  80442b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80442f:	8b 00                	mov    (%rax),%eax
  804431:	29 c2                	sub    %eax,%edx
  804433:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804437:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80443d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804441:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804448:	00 00 00 
	stat->st_dev = &devpipe;
  80444b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80444f:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  804456:	00 00 00 
  804459:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804460:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804465:	c9                   	leaveq 
  804466:	c3                   	retq   

0000000000804467 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804467:	55                   	push   %rbp
  804468:	48 89 e5             	mov    %rsp,%rbp
  80446b:	48 83 ec 10          	sub    $0x10,%rsp
  80446f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  804473:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804477:	48 89 c6             	mov    %rax,%rsi
  80447a:	bf 00 00 00 00       	mov    $0x0,%edi
  80447f:	48 b8 b5 1d 80 00 00 	movabs $0x801db5,%rax
  804486:	00 00 00 
  804489:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80448b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80448f:	48 89 c7             	mov    %rax,%rdi
  804492:	48 b8 fe 26 80 00 00 	movabs $0x8026fe,%rax
  804499:	00 00 00 
  80449c:	ff d0                	callq  *%rax
  80449e:	48 89 c6             	mov    %rax,%rsi
  8044a1:	bf 00 00 00 00       	mov    $0x0,%edi
  8044a6:	48 b8 b5 1d 80 00 00 	movabs $0x801db5,%rax
  8044ad:	00 00 00 
  8044b0:	ff d0                	callq  *%rax
}
  8044b2:	c9                   	leaveq 
  8044b3:	c3                   	retq   

00000000008044b4 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8044b4:	55                   	push   %rbp
  8044b5:	48 89 e5             	mov    %rsp,%rbp
  8044b8:	48 83 ec 20          	sub    $0x20,%rsp
  8044bc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  8044bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8044c3:	75 35                	jne    8044fa <wait+0x46>
  8044c5:	48 b9 a0 54 80 00 00 	movabs $0x8054a0,%rcx
  8044cc:	00 00 00 
  8044cf:	48 ba ab 54 80 00 00 	movabs $0x8054ab,%rdx
  8044d6:	00 00 00 
  8044d9:	be 09 00 00 00       	mov    $0x9,%esi
  8044de:	48 bf c0 54 80 00 00 	movabs $0x8054c0,%rdi
  8044e5:	00 00 00 
  8044e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8044ed:	49 b8 ed 05 80 00 00 	movabs $0x8005ed,%r8
  8044f4:	00 00 00 
  8044f7:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  8044fa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8044fd:	25 ff 03 00 00       	and    $0x3ff,%eax
  804502:	48 63 d0             	movslq %eax,%rdx
  804505:	48 89 d0             	mov    %rdx,%rax
  804508:	48 c1 e0 03          	shl    $0x3,%rax
  80450c:	48 01 d0             	add    %rdx,%rax
  80450f:	48 c1 e0 05          	shl    $0x5,%rax
  804513:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80451a:	00 00 00 
  80451d:	48 01 d0             	add    %rdx,%rax
  804520:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE){
  804524:	eb 0c                	jmp    804532 <wait+0x7e>
	//cprintf("envid is [%d]",envid);
		sys_yield();
  804526:	48 b8 cc 1c 80 00 00 	movabs $0x801ccc,%rax
  80452d:	00 00 00 
  804530:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE){
  804532:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804536:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80453c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80453f:	75 0e                	jne    80454f <wait+0x9b>
  804541:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804545:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  80454b:	85 c0                	test   %eax,%eax
  80454d:	75 d7                	jne    804526 <wait+0x72>
	//cprintf("envid is [%d]",envid);
		sys_yield();
	}
}
  80454f:	c9                   	leaveq 
  804550:	c3                   	retq   

0000000000804551 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804551:	55                   	push   %rbp
  804552:	48 89 e5             	mov    %rsp,%rbp
  804555:	48 83 ec 20          	sub    $0x20,%rsp
  804559:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80455c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80455f:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804562:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804566:	be 01 00 00 00       	mov    $0x1,%esi
  80456b:	48 89 c7             	mov    %rax,%rdi
  80456e:	48 b8 c2 1b 80 00 00 	movabs $0x801bc2,%rax
  804575:	00 00 00 
  804578:	ff d0                	callq  *%rax
}
  80457a:	c9                   	leaveq 
  80457b:	c3                   	retq   

000000000080457c <getchar>:

int
getchar(void)
{
  80457c:	55                   	push   %rbp
  80457d:	48 89 e5             	mov    %rsp,%rbp
  804580:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804584:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804588:	ba 01 00 00 00       	mov    $0x1,%edx
  80458d:	48 89 c6             	mov    %rax,%rsi
  804590:	bf 00 00 00 00       	mov    $0x0,%edi
  804595:	48 b8 f3 2b 80 00 00 	movabs $0x802bf3,%rax
  80459c:	00 00 00 
  80459f:	ff d0                	callq  *%rax
  8045a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8045a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045a8:	79 05                	jns    8045af <getchar+0x33>
		return r;
  8045aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045ad:	eb 14                	jmp    8045c3 <getchar+0x47>
	if (r < 1)
  8045af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045b3:	7f 07                	jg     8045bc <getchar+0x40>
		return -E_EOF;
  8045b5:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8045ba:	eb 07                	jmp    8045c3 <getchar+0x47>
	return c;
  8045bc:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8045c0:	0f b6 c0             	movzbl %al,%eax
}
  8045c3:	c9                   	leaveq 
  8045c4:	c3                   	retq   

00000000008045c5 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8045c5:	55                   	push   %rbp
  8045c6:	48 89 e5             	mov    %rsp,%rbp
  8045c9:	48 83 ec 20          	sub    $0x20,%rsp
  8045cd:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8045d0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8045d4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8045d7:	48 89 d6             	mov    %rdx,%rsi
  8045da:	89 c7                	mov    %eax,%edi
  8045dc:	48 b8 c1 27 80 00 00 	movabs $0x8027c1,%rax
  8045e3:	00 00 00 
  8045e6:	ff d0                	callq  *%rax
  8045e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8045eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045ef:	79 05                	jns    8045f6 <iscons+0x31>
		return r;
  8045f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045f4:	eb 1a                	jmp    804610 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8045f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045fa:	8b 10                	mov    (%rax),%edx
  8045fc:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  804603:	00 00 00 
  804606:	8b 00                	mov    (%rax),%eax
  804608:	39 c2                	cmp    %eax,%edx
  80460a:	0f 94 c0             	sete   %al
  80460d:	0f b6 c0             	movzbl %al,%eax
}
  804610:	c9                   	leaveq 
  804611:	c3                   	retq   

0000000000804612 <opencons>:

int
opencons(void)
{
  804612:	55                   	push   %rbp
  804613:	48 89 e5             	mov    %rsp,%rbp
  804616:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80461a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80461e:	48 89 c7             	mov    %rax,%rdi
  804621:	48 b8 29 27 80 00 00 	movabs $0x802729,%rax
  804628:	00 00 00 
  80462b:	ff d0                	callq  *%rax
  80462d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804630:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804634:	79 05                	jns    80463b <opencons+0x29>
		return r;
  804636:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804639:	eb 5b                	jmp    804696 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80463b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80463f:	ba 07 04 00 00       	mov    $0x407,%edx
  804644:	48 89 c6             	mov    %rax,%rsi
  804647:	bf 00 00 00 00       	mov    $0x0,%edi
  80464c:	48 b8 0a 1d 80 00 00 	movabs $0x801d0a,%rax
  804653:	00 00 00 
  804656:	ff d0                	callq  *%rax
  804658:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80465b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80465f:	79 05                	jns    804666 <opencons+0x54>
		return r;
  804661:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804664:	eb 30                	jmp    804696 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804666:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80466a:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  804671:	00 00 00 
  804674:	8b 12                	mov    (%rdx),%edx
  804676:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804678:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80467c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804683:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804687:	48 89 c7             	mov    %rax,%rdi
  80468a:	48 b8 db 26 80 00 00 	movabs $0x8026db,%rax
  804691:	00 00 00 
  804694:	ff d0                	callq  *%rax
}
  804696:	c9                   	leaveq 
  804697:	c3                   	retq   

0000000000804698 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804698:	55                   	push   %rbp
  804699:	48 89 e5             	mov    %rsp,%rbp
  80469c:	48 83 ec 30          	sub    $0x30,%rsp
  8046a0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8046a4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8046a8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8046ac:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8046b1:	75 07                	jne    8046ba <devcons_read+0x22>
		return 0;
  8046b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8046b8:	eb 4b                	jmp    804705 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8046ba:	eb 0c                	jmp    8046c8 <devcons_read+0x30>
		sys_yield();
  8046bc:	48 b8 cc 1c 80 00 00 	movabs $0x801ccc,%rax
  8046c3:	00 00 00 
  8046c6:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8046c8:	48 b8 0c 1c 80 00 00 	movabs $0x801c0c,%rax
  8046cf:	00 00 00 
  8046d2:	ff d0                	callq  *%rax
  8046d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8046d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8046db:	74 df                	je     8046bc <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8046dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8046e1:	79 05                	jns    8046e8 <devcons_read+0x50>
		return c;
  8046e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046e6:	eb 1d                	jmp    804705 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8046e8:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8046ec:	75 07                	jne    8046f5 <devcons_read+0x5d>
		return 0;
  8046ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8046f3:	eb 10                	jmp    804705 <devcons_read+0x6d>
	*(char*)vbuf = c;
  8046f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046f8:	89 c2                	mov    %eax,%edx
  8046fa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8046fe:	88 10                	mov    %dl,(%rax)
	return 1;
  804700:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804705:	c9                   	leaveq 
  804706:	c3                   	retq   

0000000000804707 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804707:	55                   	push   %rbp
  804708:	48 89 e5             	mov    %rsp,%rbp
  80470b:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804712:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804719:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804720:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804727:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80472e:	eb 76                	jmp    8047a6 <devcons_write+0x9f>
		m = n - tot;
  804730:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804737:	89 c2                	mov    %eax,%edx
  804739:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80473c:	29 c2                	sub    %eax,%edx
  80473e:	89 d0                	mov    %edx,%eax
  804740:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804743:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804746:	83 f8 7f             	cmp    $0x7f,%eax
  804749:	76 07                	jbe    804752 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80474b:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804752:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804755:	48 63 d0             	movslq %eax,%rdx
  804758:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80475b:	48 63 c8             	movslq %eax,%rcx
  80475e:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804765:	48 01 c1             	add    %rax,%rcx
  804768:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80476f:	48 89 ce             	mov    %rcx,%rsi
  804772:	48 89 c7             	mov    %rax,%rdi
  804775:	48 b8 ff 16 80 00 00 	movabs $0x8016ff,%rax
  80477c:	00 00 00 
  80477f:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804781:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804784:	48 63 d0             	movslq %eax,%rdx
  804787:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80478e:	48 89 d6             	mov    %rdx,%rsi
  804791:	48 89 c7             	mov    %rax,%rdi
  804794:	48 b8 c2 1b 80 00 00 	movabs $0x801bc2,%rax
  80479b:	00 00 00 
  80479e:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8047a0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8047a3:	01 45 fc             	add    %eax,-0x4(%rbp)
  8047a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047a9:	48 98                	cltq   
  8047ab:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8047b2:	0f 82 78 ff ff ff    	jb     804730 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8047b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8047bb:	c9                   	leaveq 
  8047bc:	c3                   	retq   

00000000008047bd <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8047bd:	55                   	push   %rbp
  8047be:	48 89 e5             	mov    %rsp,%rbp
  8047c1:	48 83 ec 08          	sub    $0x8,%rsp
  8047c5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8047c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8047ce:	c9                   	leaveq 
  8047cf:	c3                   	retq   

00000000008047d0 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8047d0:	55                   	push   %rbp
  8047d1:	48 89 e5             	mov    %rsp,%rbp
  8047d4:	48 83 ec 10          	sub    $0x10,%rsp
  8047d8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8047dc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8047e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047e4:	48 be d0 54 80 00 00 	movabs $0x8054d0,%rsi
  8047eb:	00 00 00 
  8047ee:	48 89 c7             	mov    %rax,%rdi
  8047f1:	48 b8 db 13 80 00 00 	movabs $0x8013db,%rax
  8047f8:	00 00 00 
  8047fb:	ff d0                	callq  *%rax
	return 0;
  8047fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804802:	c9                   	leaveq 
  804803:	c3                   	retq   

0000000000804804 <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804804:	55                   	push   %rbp
  804805:	48 89 e5             	mov    %rsp,%rbp
  804808:	48 83 ec 10          	sub    $0x10,%rsp
  80480c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  804810:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804817:	00 00 00 
  80481a:	48 8b 00             	mov    (%rax),%rax
  80481d:	48 85 c0             	test   %rax,%rax
  804820:	0f 85 84 00 00 00    	jne    8048aa <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  804826:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80482d:	00 00 00 
  804830:	48 8b 00             	mov    (%rax),%rax
  804833:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804839:	ba 07 00 00 00       	mov    $0x7,%edx
  80483e:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  804843:	89 c7                	mov    %eax,%edi
  804845:	48 b8 0a 1d 80 00 00 	movabs $0x801d0a,%rax
  80484c:	00 00 00 
  80484f:	ff d0                	callq  *%rax
  804851:	85 c0                	test   %eax,%eax
  804853:	79 2a                	jns    80487f <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  804855:	48 ba d8 54 80 00 00 	movabs $0x8054d8,%rdx
  80485c:	00 00 00 
  80485f:	be 23 00 00 00       	mov    $0x23,%esi
  804864:	48 bf ff 54 80 00 00 	movabs $0x8054ff,%rdi
  80486b:	00 00 00 
  80486e:	b8 00 00 00 00       	mov    $0x0,%eax
  804873:	48 b9 ed 05 80 00 00 	movabs $0x8005ed,%rcx
  80487a:	00 00 00 
  80487d:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  80487f:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804886:	00 00 00 
  804889:	48 8b 00             	mov    (%rax),%rax
  80488c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804892:	48 be bd 48 80 00 00 	movabs $0x8048bd,%rsi
  804899:	00 00 00 
  80489c:	89 c7                	mov    %eax,%edi
  80489e:	48 b8 94 1e 80 00 00 	movabs $0x801e94,%rax
  8048a5:	00 00 00 
  8048a8:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  8048aa:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8048b1:	00 00 00 
  8048b4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8048b8:	48 89 10             	mov    %rdx,(%rax)
}
  8048bb:	c9                   	leaveq 
  8048bc:	c3                   	retq   

00000000008048bd <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  8048bd:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  8048c0:	48 a1 00 c0 80 00 00 	movabs 0x80c000,%rax
  8048c7:	00 00 00 
call *%rax
  8048ca:	ff d0                	callq  *%rax
    // LAB 4: Your code here.

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.

	movq 136(%rsp), %rbx  //Load RIP 
  8048cc:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8048d3:	00 
	movq 152(%rsp), %rcx  //Load RSP
  8048d4:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  8048db:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  8048dc:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  8048e0:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  8048e3:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  8048ea:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  8048eb:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  8048ef:	4c 8b 3c 24          	mov    (%rsp),%r15
  8048f3:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8048f8:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8048fd:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804902:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804907:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  80490c:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804911:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  804916:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  80491b:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804920:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804925:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  80492a:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  80492f:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804934:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804939:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  80493d:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  804941:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  804942:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  804943:	c3                   	retq   

0000000000804944 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804944:	55                   	push   %rbp
  804945:	48 89 e5             	mov    %rsp,%rbp
  804948:	48 83 ec 30          	sub    $0x30,%rsp
  80494c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804950:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804954:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  804958:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80495f:	00 00 00 
  804962:	48 8b 00             	mov    (%rax),%rax
  804965:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  80496b:	85 c0                	test   %eax,%eax
  80496d:	75 3c                	jne    8049ab <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  80496f:	48 b8 8e 1c 80 00 00 	movabs $0x801c8e,%rax
  804976:	00 00 00 
  804979:	ff d0                	callq  *%rax
  80497b:	25 ff 03 00 00       	and    $0x3ff,%eax
  804980:	48 63 d0             	movslq %eax,%rdx
  804983:	48 89 d0             	mov    %rdx,%rax
  804986:	48 c1 e0 03          	shl    $0x3,%rax
  80498a:	48 01 d0             	add    %rdx,%rax
  80498d:	48 c1 e0 05          	shl    $0x5,%rax
  804991:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804998:	00 00 00 
  80499b:	48 01 c2             	add    %rax,%rdx
  80499e:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8049a5:	00 00 00 
  8049a8:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  8049ab:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8049b0:	75 0e                	jne    8049c0 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  8049b2:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8049b9:	00 00 00 
  8049bc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  8049c0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8049c4:	48 89 c7             	mov    %rax,%rdi
  8049c7:	48 b8 33 1f 80 00 00 	movabs $0x801f33,%rax
  8049ce:	00 00 00 
  8049d1:	ff d0                	callq  *%rax
  8049d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  8049d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8049da:	79 19                	jns    8049f5 <ipc_recv+0xb1>
		*from_env_store = 0;
  8049dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8049e0:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  8049e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8049ea:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  8049f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8049f3:	eb 53                	jmp    804a48 <ipc_recv+0x104>
	}
	if(from_env_store)
  8049f5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8049fa:	74 19                	je     804a15 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  8049fc:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804a03:	00 00 00 
  804a06:	48 8b 00             	mov    (%rax),%rax
  804a09:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804a0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804a13:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  804a15:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804a1a:	74 19                	je     804a35 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  804a1c:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804a23:	00 00 00 
  804a26:	48 8b 00             	mov    (%rax),%rax
  804a29:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804a2f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a33:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  804a35:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804a3c:	00 00 00 
  804a3f:	48 8b 00             	mov    (%rax),%rax
  804a42:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  804a48:	c9                   	leaveq 
  804a49:	c3                   	retq   

0000000000804a4a <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804a4a:	55                   	push   %rbp
  804a4b:	48 89 e5             	mov    %rsp,%rbp
  804a4e:	48 83 ec 30          	sub    $0x30,%rsp
  804a52:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804a55:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804a58:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804a5c:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  804a5f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804a64:	75 0e                	jne    804a74 <ipc_send+0x2a>
		pg = (void*)UTOP;
  804a66:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804a6d:	00 00 00 
  804a70:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  804a74:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804a77:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804a7a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804a7e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804a81:	89 c7                	mov    %eax,%edi
  804a83:	48 b8 de 1e 80 00 00 	movabs $0x801ede,%rax
  804a8a:	00 00 00 
  804a8d:	ff d0                	callq  *%rax
  804a8f:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  804a92:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804a96:	75 0c                	jne    804aa4 <ipc_send+0x5a>
			sys_yield();
  804a98:	48 b8 cc 1c 80 00 00 	movabs $0x801ccc,%rax
  804a9f:	00 00 00 
  804aa2:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  804aa4:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804aa8:	74 ca                	je     804a74 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  804aaa:	c9                   	leaveq 
  804aab:	c3                   	retq   

0000000000804aac <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804aac:	55                   	push   %rbp
  804aad:	48 89 e5             	mov    %rsp,%rbp
  804ab0:	48 83 ec 14          	sub    $0x14,%rsp
  804ab4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804ab7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804abe:	eb 5e                	jmp    804b1e <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  804ac0:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804ac7:	00 00 00 
  804aca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804acd:	48 63 d0             	movslq %eax,%rdx
  804ad0:	48 89 d0             	mov    %rdx,%rax
  804ad3:	48 c1 e0 03          	shl    $0x3,%rax
  804ad7:	48 01 d0             	add    %rdx,%rax
  804ada:	48 c1 e0 05          	shl    $0x5,%rax
  804ade:	48 01 c8             	add    %rcx,%rax
  804ae1:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804ae7:	8b 00                	mov    (%rax),%eax
  804ae9:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804aec:	75 2c                	jne    804b1a <ipc_find_env+0x6e>
			return envs[i].env_id;
  804aee:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804af5:	00 00 00 
  804af8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804afb:	48 63 d0             	movslq %eax,%rdx
  804afe:	48 89 d0             	mov    %rdx,%rax
  804b01:	48 c1 e0 03          	shl    $0x3,%rax
  804b05:	48 01 d0             	add    %rdx,%rax
  804b08:	48 c1 e0 05          	shl    $0x5,%rax
  804b0c:	48 01 c8             	add    %rcx,%rax
  804b0f:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804b15:	8b 40 08             	mov    0x8(%rax),%eax
  804b18:	eb 12                	jmp    804b2c <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804b1a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804b1e:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804b25:	7e 99                	jle    804ac0 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804b27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804b2c:	c9                   	leaveq 
  804b2d:	c3                   	retq   

0000000000804b2e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804b2e:	55                   	push   %rbp
  804b2f:	48 89 e5             	mov    %rsp,%rbp
  804b32:	48 83 ec 18          	sub    $0x18,%rsp
  804b36:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804b3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804b3e:	48 c1 e8 15          	shr    $0x15,%rax
  804b42:	48 89 c2             	mov    %rax,%rdx
  804b45:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804b4c:	01 00 00 
  804b4f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804b53:	83 e0 01             	and    $0x1,%eax
  804b56:	48 85 c0             	test   %rax,%rax
  804b59:	75 07                	jne    804b62 <pageref+0x34>
		return 0;
  804b5b:	b8 00 00 00 00       	mov    $0x0,%eax
  804b60:	eb 53                	jmp    804bb5 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804b62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804b66:	48 c1 e8 0c          	shr    $0xc,%rax
  804b6a:	48 89 c2             	mov    %rax,%rdx
  804b6d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804b74:	01 00 00 
  804b77:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804b7b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804b7f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b83:	83 e0 01             	and    $0x1,%eax
  804b86:	48 85 c0             	test   %rax,%rax
  804b89:	75 07                	jne    804b92 <pageref+0x64>
		return 0;
  804b8b:	b8 00 00 00 00       	mov    $0x0,%eax
  804b90:	eb 23                	jmp    804bb5 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804b92:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b96:	48 c1 e8 0c          	shr    $0xc,%rax
  804b9a:	48 89 c2             	mov    %rax,%rdx
  804b9d:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804ba4:	00 00 00 
  804ba7:	48 c1 e2 04          	shl    $0x4,%rdx
  804bab:	48 01 d0             	add    %rdx,%rax
  804bae:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804bb2:	0f b7 c0             	movzwl %ax,%eax
}
  804bb5:	c9                   	leaveq 
  804bb6:	c3                   	retq   
