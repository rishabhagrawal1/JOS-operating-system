
obj/user/sh.debug:     file format elf64-x86-64


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
  80003c:	e8 35 11 00 00       	callq  801176 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <runcmd>:
// runcmd() is called in a forked child,
// so it's OK to manipulate file descriptor state.
#define MAXARGS 16
void
runcmd(char* s)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 81 ec 60 05 00 00 	sub    $0x560,%rsp
  80004e:	48 89 bd a8 fa ff ff 	mov    %rdi,-0x558(%rbp)
	char *argv[MAXARGS], *t, argv0buf[BUFSIZ];
	int argc, c, i, r, p[2], fd, pipe_child;

	pipe_child = 0;
  800055:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	gettoken(s, 0);
  80005c:	48 8b 85 a8 fa ff ff 	mov    -0x558(%rbp),%rax
  800063:	be 00 00 00 00       	mov    $0x0,%esi
  800068:	48 89 c7             	mov    %rax,%rdi
  80006b:	48 b8 5b 0a 80 00 00 	movabs $0x800a5b,%rax
  800072:	00 00 00 
  800075:	ff d0                	callq  *%rax

again:
	argc = 0;
  800077:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	while (1) {
		switch ((c = gettoken(0, &t))) {
  80007e:	48 8d 85 58 ff ff ff 	lea    -0xa8(%rbp),%rax
  800085:	48 89 c6             	mov    %rax,%rsi
  800088:	bf 00 00 00 00       	mov    $0x0,%edi
  80008d:	48 b8 5b 0a 80 00 00 	movabs $0x800a5b,%rax
  800094:	00 00 00 
  800097:	ff d0                	callq  *%rax
  800099:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80009c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80009f:	83 f8 3e             	cmp    $0x3e,%eax
  8000a2:	0f 84 4c 01 00 00    	je     8001f4 <runcmd+0x1b1>
  8000a8:	83 f8 3e             	cmp    $0x3e,%eax
  8000ab:	7f 12                	jg     8000bf <runcmd+0x7c>
  8000ad:	85 c0                	test   %eax,%eax
  8000af:	0f 84 b9 03 00 00    	je     80046e <runcmd+0x42b>
  8000b5:	83 f8 3c             	cmp    $0x3c,%eax
  8000b8:	74 64                	je     80011e <runcmd+0xdb>
  8000ba:	e9 7a 03 00 00       	jmpq   800439 <runcmd+0x3f6>
  8000bf:	83 f8 77             	cmp    $0x77,%eax
  8000c2:	74 0e                	je     8000d2 <runcmd+0x8f>
  8000c4:	83 f8 7c             	cmp    $0x7c,%eax
  8000c7:	0f 84 fd 01 00 00    	je     8002ca <runcmd+0x287>
  8000cd:	e9 67 03 00 00       	jmpq   800439 <runcmd+0x3f6>

		case 'w':	// Add an argument
			if (argc == MAXARGS) {
  8000d2:	83 7d fc 10          	cmpl   $0x10,-0x4(%rbp)
  8000d6:	75 27                	jne    8000ff <runcmd+0xbc>
				cprintf("too many arguments\n");
  8000d8:	48 bf e8 67 80 00 00 	movabs $0x8067e8,%rdi
  8000df:	00 00 00 
  8000e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e7:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  8000ee:	00 00 00 
  8000f1:	ff d2                	callq  *%rdx
				exit();
  8000f3:	48 b8 01 12 80 00 00 	movabs $0x801201,%rax
  8000fa:	00 00 00 
  8000fd:	ff d0                	callq  *%rax
			}
			argv[argc++] = t;
  8000ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800102:	8d 50 01             	lea    0x1(%rax),%edx
  800105:	89 55 fc             	mov    %edx,-0x4(%rbp)
  800108:	48 8b 95 58 ff ff ff 	mov    -0xa8(%rbp),%rdx
  80010f:	48 98                	cltq   
  800111:	48 89 94 c5 60 ff ff 	mov    %rdx,-0xa0(%rbp,%rax,8)
  800118:	ff 
			break;
  800119:	e9 4b 03 00 00       	jmpq   800469 <runcmd+0x426>

		case '<':	// Input redirection
			// Grab the filename from the argument list
			if (gettoken(0, &t) != 'w') {
  80011e:	48 8d 85 58 ff ff ff 	lea    -0xa8(%rbp),%rax
  800125:	48 89 c6             	mov    %rax,%rsi
  800128:	bf 00 00 00 00       	mov    $0x0,%edi
  80012d:	48 b8 5b 0a 80 00 00 	movabs $0x800a5b,%rax
  800134:	00 00 00 
  800137:	ff d0                	callq  *%rax
  800139:	83 f8 77             	cmp    $0x77,%eax
  80013c:	74 27                	je     800165 <runcmd+0x122>
				cprintf("syntax error: < not followed by word\n");
  80013e:	48 bf 00 68 80 00 00 	movabs $0x806800,%rdi
  800145:	00 00 00 
  800148:	b8 00 00 00 00       	mov    $0x0,%eax
  80014d:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  800154:	00 00 00 
  800157:	ff d2                	callq  *%rdx
				exit();
  800159:	48 b8 01 12 80 00 00 	movabs $0x801201,%rax
  800160:	00 00 00 
  800163:	ff d0                	callq  *%rax
			}
			if ((fd = open(t, O_RDONLY)) < 0) {
  800165:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80016c:	be 00 00 00 00       	mov    $0x0,%esi
  800171:	48 89 c7             	mov    %rax,%rdi
  800174:	48 b8 3f 41 80 00 00 	movabs $0x80413f,%rax
  80017b:	00 00 00 
  80017e:	ff d0                	callq  *%rax
  800180:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800183:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800187:	79 34                	jns    8001bd <runcmd+0x17a>
				cprintf("open %s for read: %e", t, fd);
  800189:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800190:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800193:	48 89 c6             	mov    %rax,%rsi
  800196:	48 bf 26 68 80 00 00 	movabs $0x806826,%rdi
  80019d:	00 00 00 
  8001a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a5:	48 b9 5d 14 80 00 00 	movabs $0x80145d,%rcx
  8001ac:	00 00 00 
  8001af:	ff d1                	callq  *%rcx
				exit();
  8001b1:	48 b8 01 12 80 00 00 	movabs $0x801201,%rax
  8001b8:	00 00 00 
  8001bb:	ff d0                	callq  *%rax
			}
			if (fd != 0) {
  8001bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8001c1:	74 2c                	je     8001ef <runcmd+0x1ac>
				dup(fd, 0);
  8001c3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001c6:	be 00 00 00 00       	mov    $0x0,%esi
  8001cb:	89 c7                	mov    %eax,%edi
  8001cd:	48 b8 c0 3a 80 00 00 	movabs $0x803ac0,%rax
  8001d4:	00 00 00 
  8001d7:	ff d0                	callq  *%rax
				close(fd);
  8001d9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001dc:	89 c7                	mov    %eax,%edi
  8001de:	48 b8 47 3a 80 00 00 	movabs $0x803a47,%rax
  8001e5:	00 00 00 
  8001e8:	ff d0                	callq  *%rax
			}
			break;
  8001ea:	e9 7a 02 00 00       	jmpq   800469 <runcmd+0x426>
  8001ef:	e9 75 02 00 00       	jmpq   800469 <runcmd+0x426>

		case '>':	// Output redirection
			// Grab the filename from the argument list
			if (gettoken(0, &t) != 'w') {
  8001f4:	48 8d 85 58 ff ff ff 	lea    -0xa8(%rbp),%rax
  8001fb:	48 89 c6             	mov    %rax,%rsi
  8001fe:	bf 00 00 00 00       	mov    $0x0,%edi
  800203:	48 b8 5b 0a 80 00 00 	movabs $0x800a5b,%rax
  80020a:	00 00 00 
  80020d:	ff d0                	callq  *%rax
  80020f:	83 f8 77             	cmp    $0x77,%eax
  800212:	74 27                	je     80023b <runcmd+0x1f8>
				cprintf("syntax error: > not followed by word\n");
  800214:	48 bf 40 68 80 00 00 	movabs $0x806840,%rdi
  80021b:	00 00 00 
  80021e:	b8 00 00 00 00       	mov    $0x0,%eax
  800223:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  80022a:	00 00 00 
  80022d:	ff d2                	callq  *%rdx
				exit();
  80022f:	48 b8 01 12 80 00 00 	movabs $0x801201,%rax
  800236:	00 00 00 
  800239:	ff d0                	callq  *%rax
			}
			if ((fd = open(t, O_WRONLY|O_CREAT|O_TRUNC)) < 0) {
  80023b:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800242:	be 01 03 00 00       	mov    $0x301,%esi
  800247:	48 89 c7             	mov    %rax,%rdi
  80024a:	48 b8 3f 41 80 00 00 	movabs $0x80413f,%rax
  800251:	00 00 00 
  800254:	ff d0                	callq  *%rax
  800256:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800259:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80025d:	79 34                	jns    800293 <runcmd+0x250>
				cprintf("open %s for write: %e", t, fd);
  80025f:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800266:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800269:	48 89 c6             	mov    %rax,%rsi
  80026c:	48 bf 66 68 80 00 00 	movabs $0x806866,%rdi
  800273:	00 00 00 
  800276:	b8 00 00 00 00       	mov    $0x0,%eax
  80027b:	48 b9 5d 14 80 00 00 	movabs $0x80145d,%rcx
  800282:	00 00 00 
  800285:	ff d1                	callq  *%rcx
				exit();
  800287:	48 b8 01 12 80 00 00 	movabs $0x801201,%rax
  80028e:	00 00 00 
  800291:	ff d0                	callq  *%rax
			}
			if (fd != 1) {
  800293:	83 7d ec 01          	cmpl   $0x1,-0x14(%rbp)
  800297:	74 2c                	je     8002c5 <runcmd+0x282>
				dup(fd, 1);
  800299:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80029c:	be 01 00 00 00       	mov    $0x1,%esi
  8002a1:	89 c7                	mov    %eax,%edi
  8002a3:	48 b8 c0 3a 80 00 00 	movabs $0x803ac0,%rax
  8002aa:	00 00 00 
  8002ad:	ff d0                	callq  *%rax
				close(fd);
  8002af:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8002b2:	89 c7                	mov    %eax,%edi
  8002b4:	48 b8 47 3a 80 00 00 	movabs $0x803a47,%rax
  8002bb:	00 00 00 
  8002be:	ff d0                	callq  *%rax
			}
			break;
  8002c0:	e9 a4 01 00 00       	jmpq   800469 <runcmd+0x426>
  8002c5:	e9 9f 01 00 00       	jmpq   800469 <runcmd+0x426>

		case '|':	// Pipe
			if ((r = pipe(p)) < 0) {
  8002ca:	48 8d 85 40 fb ff ff 	lea    -0x4c0(%rbp),%rax
  8002d1:	48 89 c7             	mov    %rax,%rdi
  8002d4:	48 b8 b9 5d 80 00 00 	movabs $0x805db9,%rax
  8002db:	00 00 00 
  8002de:	ff d0                	callq  *%rax
  8002e0:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8002e3:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8002e7:	79 2c                	jns    800315 <runcmd+0x2d2>
				cprintf("pipe: %e", r);
  8002e9:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8002ec:	89 c6                	mov    %eax,%esi
  8002ee:	48 bf 7c 68 80 00 00 	movabs $0x80687c,%rdi
  8002f5:	00 00 00 
  8002f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fd:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  800304:	00 00 00 
  800307:	ff d2                	callq  *%rdx
				exit();
  800309:	48 b8 01 12 80 00 00 	movabs $0x801201,%rax
  800310:	00 00 00 
  800313:	ff d0                	callq  *%rax
			}
			if (debug)
  800315:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80031c:	00 00 00 
  80031f:	8b 00                	mov    (%rax),%eax
  800321:	85 c0                	test   %eax,%eax
  800323:	74 29                	je     80034e <runcmd+0x30b>
				cprintf("PIPE: %d %d\n", p[0], p[1]);
  800325:	8b 95 44 fb ff ff    	mov    -0x4bc(%rbp),%edx
  80032b:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  800331:	89 c6                	mov    %eax,%esi
  800333:	48 bf 85 68 80 00 00 	movabs $0x806885,%rdi
  80033a:	00 00 00 
  80033d:	b8 00 00 00 00       	mov    $0x0,%eax
  800342:	48 b9 5d 14 80 00 00 	movabs $0x80145d,%rcx
  800349:	00 00 00 
  80034c:	ff d1                	callq  *%rcx
			if ((r = fork()) < 0) {
  80034e:	48 b8 bb 31 80 00 00 	movabs $0x8031bb,%rax
  800355:	00 00 00 
  800358:	ff d0                	callq  *%rax
  80035a:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80035d:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800361:	79 2c                	jns    80038f <runcmd+0x34c>
				cprintf("fork: %e", r);
  800363:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800366:	89 c6                	mov    %eax,%esi
  800368:	48 bf 92 68 80 00 00 	movabs $0x806892,%rdi
  80036f:	00 00 00 
  800372:	b8 00 00 00 00       	mov    $0x0,%eax
  800377:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  80037e:	00 00 00 
  800381:	ff d2                	callq  *%rdx
				exit();
  800383:	48 b8 01 12 80 00 00 	movabs $0x801201,%rax
  80038a:	00 00 00 
  80038d:	ff d0                	callq  *%rax
			}
			if (r == 0) {
  80038f:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800393:	75 50                	jne    8003e5 <runcmd+0x3a2>
				if (p[0] != 0) {
  800395:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  80039b:	85 c0                	test   %eax,%eax
  80039d:	74 2d                	je     8003cc <runcmd+0x389>
					dup(p[0], 0);
  80039f:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  8003a5:	be 00 00 00 00       	mov    $0x0,%esi
  8003aa:	89 c7                	mov    %eax,%edi
  8003ac:	48 b8 c0 3a 80 00 00 	movabs $0x803ac0,%rax
  8003b3:	00 00 00 
  8003b6:	ff d0                	callq  *%rax
					close(p[0]);
  8003b8:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  8003be:	89 c7                	mov    %eax,%edi
  8003c0:	48 b8 47 3a 80 00 00 	movabs $0x803a47,%rax
  8003c7:	00 00 00 
  8003ca:	ff d0                	callq  *%rax
				}
				close(p[1]);
  8003cc:	8b 85 44 fb ff ff    	mov    -0x4bc(%rbp),%eax
  8003d2:	89 c7                	mov    %eax,%edi
  8003d4:	48 b8 47 3a 80 00 00 	movabs $0x803a47,%rax
  8003db:	00 00 00 
  8003de:	ff d0                	callq  *%rax
				goto again;
  8003e0:	e9 92 fc ff ff       	jmpq   800077 <runcmd+0x34>
			} else {
				pipe_child = r;
  8003e5:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8003e8:	89 45 f4             	mov    %eax,-0xc(%rbp)
				if (p[1] != 1) {
  8003eb:	8b 85 44 fb ff ff    	mov    -0x4bc(%rbp),%eax
  8003f1:	83 f8 01             	cmp    $0x1,%eax
  8003f4:	74 2d                	je     800423 <runcmd+0x3e0>
					dup(p[1], 1);
  8003f6:	8b 85 44 fb ff ff    	mov    -0x4bc(%rbp),%eax
  8003fc:	be 01 00 00 00       	mov    $0x1,%esi
  800401:	89 c7                	mov    %eax,%edi
  800403:	48 b8 c0 3a 80 00 00 	movabs $0x803ac0,%rax
  80040a:	00 00 00 
  80040d:	ff d0                	callq  *%rax
					close(p[1]);
  80040f:	8b 85 44 fb ff ff    	mov    -0x4bc(%rbp),%eax
  800415:	89 c7                	mov    %eax,%edi
  800417:	48 b8 47 3a 80 00 00 	movabs $0x803a47,%rax
  80041e:	00 00 00 
  800421:	ff d0                	callq  *%rax
				}
				close(p[0]);
  800423:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  800429:	89 c7                	mov    %eax,%edi
  80042b:	48 b8 47 3a 80 00 00 	movabs $0x803a47,%rax
  800432:	00 00 00 
  800435:	ff d0                	callq  *%rax
				goto runit;
  800437:	eb 36                	jmp    80046f <runcmd+0x42c>
		case 0:		// String is complete
			// Run the current command!
			goto runit;

		default:
			panic("bad return %d from gettoken", c);
  800439:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80043c:	89 c1                	mov    %eax,%ecx
  80043e:	48 ba 9b 68 80 00 00 	movabs $0x80689b,%rdx
  800445:	00 00 00 
  800448:	be 6f 00 00 00       	mov    $0x6f,%esi
  80044d:	48 bf b7 68 80 00 00 	movabs $0x8068b7,%rdi
  800454:	00 00 00 
  800457:	b8 00 00 00 00       	mov    $0x0,%eax
  80045c:	49 b8 24 12 80 00 00 	movabs $0x801224,%r8
  800463:	00 00 00 
  800466:	41 ff d0             	callq  *%r8
			break;

		}
	}
  800469:	e9 10 fc ff ff       	jmpq   80007e <runcmd+0x3b>
			panic("| not implemented");
			break;

		case 0:		// String is complete
			// Run the current command!
			goto runit;
  80046e:	90                   	nop
		}
	}

runit:
	// Return immediately if command line was empty.
	if(argc == 0) {
  80046f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800473:	75 34                	jne    8004a9 <runcmd+0x466>
		if (debug)
  800475:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80047c:	00 00 00 
  80047f:	8b 00                	mov    (%rax),%eax
  800481:	85 c0                	test   %eax,%eax
  800483:	0f 84 79 03 00 00    	je     800802 <runcmd+0x7bf>
			cprintf("EMPTY COMMAND\n");
  800489:	48 bf c1 68 80 00 00 	movabs $0x8068c1,%rdi
  800490:	00 00 00 
  800493:	b8 00 00 00 00       	mov    $0x0,%eax
  800498:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  80049f:	00 00 00 
  8004a2:	ff d2                	callq  *%rdx
		return;
  8004a4:	e9 59 03 00 00       	jmpq   800802 <runcmd+0x7bf>
	}

	//Search in all the PATH's for the binary
	struct Stat st;
	for(i=0;i<npaths;i++) {
  8004a9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8004b0:	e9 8a 00 00 00       	jmpq   80053f <runcmd+0x4fc>
		strcpy(argv0buf, PATH[i]);
  8004b5:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8004bc:	00 00 00 
  8004bf:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8004c2:	48 63 d2             	movslq %edx,%rdx
  8004c5:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8004c9:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  8004d0:	48 89 d6             	mov    %rdx,%rsi
  8004d3:	48 89 c7             	mov    %rax,%rdi
  8004d6:	48 b8 6c 21 80 00 00 	movabs $0x80216c,%rax
  8004dd:	00 00 00 
  8004e0:	ff d0                	callq  *%rax
		strcat(argv0buf, argv[0]);
  8004e2:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  8004e9:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  8004f0:	48 89 d6             	mov    %rdx,%rsi
  8004f3:	48 89 c7             	mov    %rax,%rdi
  8004f6:	48 b8 af 21 80 00 00 	movabs $0x8021af,%rax
  8004fd:	00 00 00 
  800500:	ff d0                	callq  *%rax
		r = stat(argv0buf, &st);
  800502:	48 8d 95 b0 fa ff ff 	lea    -0x550(%rbp),%rdx
  800509:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  800510:	48 89 d6             	mov    %rdx,%rsi
  800513:	48 89 c7             	mov    %rax,%rdi
  800516:	48 b8 51 40 80 00 00 	movabs $0x804051,%rax
  80051d:	00 00 00 
  800520:	ff d0                	callq  *%rax
  800522:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r==0) {
  800525:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800529:	75 10                	jne    80053b <runcmd+0x4f8>
			argv[0] = argv0buf;
  80052b:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  800532:	48 89 85 60 ff ff ff 	mov    %rax,-0xa0(%rbp)
			break; 
  800539:	eb 19                	jmp    800554 <runcmd+0x511>
		return;
	}

	//Search in all the PATH's for the binary
	struct Stat st;
	for(i=0;i<npaths;i++) {
  80053b:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  80053f:	48 b8 10 90 80 00 00 	movabs $0x809010,%rax
  800546:	00 00 00 
  800549:	8b 00                	mov    (%rax),%eax
  80054b:	39 45 f8             	cmp    %eax,-0x8(%rbp)
  80054e:	0f 8c 61 ff ff ff    	jl     8004b5 <runcmd+0x472>

	// Clean up command line.
	// Read all commands from the filesystem: add an initial '/' to
	// the command name.
	// This essentially acts like 'PATH=/'.
	if (argv[0][0] != '/') {
  800554:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80055b:	0f b6 00             	movzbl (%rax),%eax
  80055e:	3c 2f                	cmp    $0x2f,%al
  800560:	74 39                	je     80059b <runcmd+0x558>
		argv0buf[0] = '/';
  800562:	c6 85 50 fb ff ff 2f 	movb   $0x2f,-0x4b0(%rbp)
		strcpy(argv0buf + 1, argv[0]);
  800569:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  800570:	48 8d 95 50 fb ff ff 	lea    -0x4b0(%rbp),%rdx
  800577:	48 83 c2 01          	add    $0x1,%rdx
  80057b:	48 89 c6             	mov    %rax,%rsi
  80057e:	48 89 d7             	mov    %rdx,%rdi
  800581:	48 b8 6c 21 80 00 00 	movabs $0x80216c,%rax
  800588:	00 00 00 
  80058b:	ff d0                	callq  *%rax
		argv[0] = argv0buf;
  80058d:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  800594:	48 89 85 60 ff ff ff 	mov    %rax,-0xa0(%rbp)
	}
	argv[argc] = 0;
  80059b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80059e:	48 98                	cltq   
  8005a0:	48 c7 84 c5 60 ff ff 	movq   $0x0,-0xa0(%rbp,%rax,8)
  8005a7:	ff 00 00 00 00 

	// Print the command.
	if (debug) {
  8005ac:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8005b3:	00 00 00 
  8005b6:	8b 00                	mov    (%rax),%eax
  8005b8:	85 c0                	test   %eax,%eax
  8005ba:	0f 84 95 00 00 00    	je     800655 <runcmd+0x612>
		cprintf("[%08x] SPAWN:", thisenv->env_id);
  8005c0:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  8005c7:	00 00 00 
  8005ca:	48 8b 00             	mov    (%rax),%rax
  8005cd:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8005d3:	89 c6                	mov    %eax,%esi
  8005d5:	48 bf d0 68 80 00 00 	movabs $0x8068d0,%rdi
  8005dc:	00 00 00 
  8005df:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e4:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  8005eb:	00 00 00 
  8005ee:	ff d2                	callq  *%rdx
		for (i = 0; argv[i]; i++)
  8005f0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8005f7:	eb 2f                	jmp    800628 <runcmd+0x5e5>
			cprintf(" %s", argv[i]);
  8005f9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8005fc:	48 98                	cltq   
  8005fe:	48 8b 84 c5 60 ff ff 	mov    -0xa0(%rbp,%rax,8),%rax
  800605:	ff 
  800606:	48 89 c6             	mov    %rax,%rsi
  800609:	48 bf de 68 80 00 00 	movabs $0x8068de,%rdi
  800610:	00 00 00 
  800613:	b8 00 00 00 00       	mov    $0x0,%eax
  800618:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  80061f:	00 00 00 
  800622:	ff d2                	callq  *%rdx
	argv[argc] = 0;

	// Print the command.
	if (debug) {
		cprintf("[%08x] SPAWN:", thisenv->env_id);
		for (i = 0; argv[i]; i++)
  800624:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  800628:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80062b:	48 98                	cltq   
  80062d:	48 8b 84 c5 60 ff ff 	mov    -0xa0(%rbp,%rax,8),%rax
  800634:	ff 
  800635:	48 85 c0             	test   %rax,%rax
  800638:	75 bf                	jne    8005f9 <runcmd+0x5b6>
			cprintf(" %s", argv[i]);
		cprintf("\n");
  80063a:	48 bf e2 68 80 00 00 	movabs $0x8068e2,%rdi
  800641:	00 00 00 
  800644:	b8 00 00 00 00       	mov    $0x0,%eax
  800649:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  800650:	00 00 00 
  800653:	ff d2                	callq  *%rdx
	}

	// Spawn the command!
	if ((r = spawn(argv[0], (const char**) argv)) < 0)
  800655:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80065c:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  800663:	48 89 d6             	mov    %rdx,%rsi
  800666:	48 89 c7             	mov    %rax,%rdi
  800669:	48 b8 59 4a 80 00 00 	movabs $0x804a59,%rax
  800670:	00 00 00 
  800673:	ff d0                	callq  *%rax
  800675:	89 45 e8             	mov    %eax,-0x18(%rbp)
  800678:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80067c:	79 28                	jns    8006a6 <runcmd+0x663>
		cprintf("spawn %s: %e\n", argv[0], r);
  80067e:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  800685:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800688:	48 89 c6             	mov    %rax,%rsi
  80068b:	48 bf e4 68 80 00 00 	movabs $0x8068e4,%rdi
  800692:	00 00 00 
  800695:	b8 00 00 00 00       	mov    $0x0,%eax
  80069a:	48 b9 5d 14 80 00 00 	movabs $0x80145d,%rcx
  8006a1:	00 00 00 
  8006a4:	ff d1                	callq  *%rcx

	// In the parent, close all file descriptors and wait for the
	// spawned command to exit.
	close_all();
  8006a6:	48 b8 92 3a 80 00 00 	movabs $0x803a92,%rax
  8006ad:	00 00 00 
  8006b0:	ff d0                	callq  *%rax
	if (r >= 0) {
  8006b2:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8006b6:	0f 88 9c 00 00 00    	js     800758 <runcmd+0x715>
		if (debug)
  8006bc:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8006c3:	00 00 00 
  8006c6:	8b 00                	mov    (%rax),%eax
  8006c8:	85 c0                	test   %eax,%eax
  8006ca:	74 3b                	je     800707 <runcmd+0x6c4>
			cprintf("[%08x] WAIT %s %08x\n", thisenv->env_id, argv[0], r);
  8006cc:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  8006d3:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  8006da:	00 00 00 
  8006dd:	48 8b 00             	mov    (%rax),%rax
  8006e0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8006e6:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8006e9:	89 c6                	mov    %eax,%esi
  8006eb:	48 bf f2 68 80 00 00 	movabs $0x8068f2,%rdi
  8006f2:	00 00 00 
  8006f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8006fa:	49 b8 5d 14 80 00 00 	movabs $0x80145d,%r8
  800701:	00 00 00 
  800704:	41 ff d0             	callq  *%r8
		wait(r);
  800707:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80070a:	89 c7                	mov    %eax,%edi
  80070c:	48 b8 82 63 80 00 00 	movabs $0x806382,%rax
  800713:	00 00 00 
  800716:	ff d0                	callq  *%rax
		if (debug)
  800718:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80071f:	00 00 00 
  800722:	8b 00                	mov    (%rax),%eax
  800724:	85 c0                	test   %eax,%eax
  800726:	74 30                	je     800758 <runcmd+0x715>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  800728:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  80072f:	00 00 00 
  800732:	48 8b 00             	mov    (%rax),%rax
  800735:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80073b:	89 c6                	mov    %eax,%esi
  80073d:	48 bf 07 69 80 00 00 	movabs $0x806907,%rdi
  800744:	00 00 00 
  800747:	b8 00 00 00 00       	mov    $0x0,%eax
  80074c:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  800753:	00 00 00 
  800756:	ff d2                	callq  *%rdx
	}

	// If we were the left-hand part of a pipe,
	// wait for the right-hand part to finish.
	if (pipe_child) {
  800758:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80075c:	0f 84 94 00 00 00    	je     8007f6 <runcmd+0x7b3>
		if (debug)
  800762:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800769:	00 00 00 
  80076c:	8b 00                	mov    (%rax),%eax
  80076e:	85 c0                	test   %eax,%eax
  800770:	74 33                	je     8007a5 <runcmd+0x762>
			cprintf("[%08x] WAIT pipe_child %08x\n", thisenv->env_id, pipe_child);
  800772:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  800779:	00 00 00 
  80077c:	48 8b 00             	mov    (%rax),%rax
  80077f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800785:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800788:	89 c6                	mov    %eax,%esi
  80078a:	48 bf 1d 69 80 00 00 	movabs $0x80691d,%rdi
  800791:	00 00 00 
  800794:	b8 00 00 00 00       	mov    $0x0,%eax
  800799:	48 b9 5d 14 80 00 00 	movabs $0x80145d,%rcx
  8007a0:	00 00 00 
  8007a3:	ff d1                	callq  *%rcx
		wait(pipe_child);
  8007a5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8007a8:	89 c7                	mov    %eax,%edi
  8007aa:	48 b8 82 63 80 00 00 	movabs $0x806382,%rax
  8007b1:	00 00 00 
  8007b4:	ff d0                	callq  *%rax
		if (debug)
  8007b6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8007bd:	00 00 00 
  8007c0:	8b 00                	mov    (%rax),%eax
  8007c2:	85 c0                	test   %eax,%eax
  8007c4:	74 30                	je     8007f6 <runcmd+0x7b3>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  8007c6:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  8007cd:	00 00 00 
  8007d0:	48 8b 00             	mov    (%rax),%rax
  8007d3:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8007d9:	89 c6                	mov    %eax,%esi
  8007db:	48 bf 07 69 80 00 00 	movabs $0x806907,%rdi
  8007e2:	00 00 00 
  8007e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ea:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  8007f1:	00 00 00 
  8007f4:	ff d2                	callq  *%rdx
	}

	// Done!
	exit();
  8007f6:	48 b8 01 12 80 00 00 	movabs $0x801201,%rax
  8007fd:	00 00 00 
  800800:	ff d0                	callq  *%rax
}
  800802:	c9                   	leaveq 
  800803:	c3                   	retq   

0000000000800804 <_gettoken>:
#define WHITESPACE " \t\r\n"
#define SYMBOLS "<|>&;()"

int
_gettoken(char *s, char **p1, char **p2)
{
  800804:	55                   	push   %rbp
  800805:	48 89 e5             	mov    %rsp,%rbp
  800808:	48 83 ec 30          	sub    $0x30,%rsp
  80080c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800810:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800814:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int t;

	if (s == 0) {
  800818:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80081d:	75 36                	jne    800855 <_gettoken+0x51>
		if (debug > 1)
  80081f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800826:	00 00 00 
  800829:	8b 00                	mov    (%rax),%eax
  80082b:	83 f8 01             	cmp    $0x1,%eax
  80082e:	7e 1b                	jle    80084b <_gettoken+0x47>
			cprintf("GETTOKEN NULL\n");
  800830:	48 bf 3a 69 80 00 00 	movabs $0x80693a,%rdi
  800837:	00 00 00 
  80083a:	b8 00 00 00 00       	mov    $0x0,%eax
  80083f:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  800846:	00 00 00 
  800849:	ff d2                	callq  *%rdx
		return 0;
  80084b:	b8 00 00 00 00       	mov    $0x0,%eax
  800850:	e9 04 02 00 00       	jmpq   800a59 <_gettoken+0x255>
	}

	if (debug > 1)
  800855:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80085c:	00 00 00 
  80085f:	8b 00                	mov    (%rax),%eax
  800861:	83 f8 01             	cmp    $0x1,%eax
  800864:	7e 22                	jle    800888 <_gettoken+0x84>
		cprintf("GETTOKEN: %s\n", s);
  800866:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80086a:	48 89 c6             	mov    %rax,%rsi
  80086d:	48 bf 49 69 80 00 00 	movabs $0x806949,%rdi
  800874:	00 00 00 
  800877:	b8 00 00 00 00       	mov    $0x0,%eax
  80087c:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  800883:	00 00 00 
  800886:	ff d2                	callq  *%rdx

	*p1 = 0;
  800888:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80088c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	*p2 = 0;
  800893:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800897:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	while (strchr(WHITESPACE, *s))
  80089e:	eb 0f                	jmp    8008af <_gettoken+0xab>
		*s++ = 0;
  8008a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008a8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8008ac:	c6 00 00             	movb   $0x0,(%rax)
		cprintf("GETTOKEN: %s\n", s);

	*p1 = 0;
	*p2 = 0;

	while (strchr(WHITESPACE, *s))
  8008af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b3:	0f b6 00             	movzbl (%rax),%eax
  8008b6:	0f be c0             	movsbl %al,%eax
  8008b9:	89 c6                	mov    %eax,%esi
  8008bb:	48 bf 57 69 80 00 00 	movabs $0x806957,%rdi
  8008c2:	00 00 00 
  8008c5:	48 b8 92 23 80 00 00 	movabs $0x802392,%rax
  8008cc:	00 00 00 
  8008cf:	ff d0                	callq  *%rax
  8008d1:	48 85 c0             	test   %rax,%rax
  8008d4:	75 ca                	jne    8008a0 <_gettoken+0x9c>
		*s++ = 0;
	if (*s == 0) {
  8008d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008da:	0f b6 00             	movzbl (%rax),%eax
  8008dd:	84 c0                	test   %al,%al
  8008df:	75 36                	jne    800917 <_gettoken+0x113>
		if (debug > 1)
  8008e1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8008e8:	00 00 00 
  8008eb:	8b 00                	mov    (%rax),%eax
  8008ed:	83 f8 01             	cmp    $0x1,%eax
  8008f0:	7e 1b                	jle    80090d <_gettoken+0x109>
			cprintf("EOL\n");
  8008f2:	48 bf 5c 69 80 00 00 	movabs $0x80695c,%rdi
  8008f9:	00 00 00 
  8008fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800901:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  800908:	00 00 00 
  80090b:	ff d2                	callq  *%rdx
		return 0;
  80090d:	b8 00 00 00 00       	mov    $0x0,%eax
  800912:	e9 42 01 00 00       	jmpq   800a59 <_gettoken+0x255>
	}
	if (strchr(SYMBOLS, *s)) {
  800917:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80091b:	0f b6 00             	movzbl (%rax),%eax
  80091e:	0f be c0             	movsbl %al,%eax
  800921:	89 c6                	mov    %eax,%esi
  800923:	48 bf 61 69 80 00 00 	movabs $0x806961,%rdi
  80092a:	00 00 00 
  80092d:	48 b8 92 23 80 00 00 	movabs $0x802392,%rax
  800934:	00 00 00 
  800937:	ff d0                	callq  *%rax
  800939:	48 85 c0             	test   %rax,%rax
  80093c:	74 6b                	je     8009a9 <_gettoken+0x1a5>
		t = *s;
  80093e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800942:	0f b6 00             	movzbl (%rax),%eax
  800945:	0f be c0             	movsbl %al,%eax
  800948:	89 45 fc             	mov    %eax,-0x4(%rbp)
		*p1 = s;
  80094b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80094f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800953:	48 89 10             	mov    %rdx,(%rax)
		*s++ = 0;
  800956:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80095a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80095e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800962:	c6 00 00             	movb   $0x0,(%rax)
		*p2 = s;
  800965:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800969:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80096d:	48 89 10             	mov    %rdx,(%rax)
		if (debug > 1)
  800970:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800977:	00 00 00 
  80097a:	8b 00                	mov    (%rax),%eax
  80097c:	83 f8 01             	cmp    $0x1,%eax
  80097f:	7e 20                	jle    8009a1 <_gettoken+0x19d>
			cprintf("TOK %c\n", t);
  800981:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800984:	89 c6                	mov    %eax,%esi
  800986:	48 bf 69 69 80 00 00 	movabs $0x806969,%rdi
  80098d:	00 00 00 
  800990:	b8 00 00 00 00       	mov    $0x0,%eax
  800995:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  80099c:	00 00 00 
  80099f:	ff d2                	callq  *%rdx
		return t;
  8009a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8009a4:	e9 b0 00 00 00       	jmpq   800a59 <_gettoken+0x255>
	}
	*p1 = s;
  8009a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8009ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b1:	48 89 10             	mov    %rdx,(%rax)
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  8009b4:	eb 05                	jmp    8009bb <_gettoken+0x1b7>
		s++;
  8009b6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		if (debug > 1)
			cprintf("TOK %c\n", t);
		return t;
	}
	*p1 = s;
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  8009bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009bf:	0f b6 00             	movzbl (%rax),%eax
  8009c2:	84 c0                	test   %al,%al
  8009c4:	74 27                	je     8009ed <_gettoken+0x1e9>
  8009c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ca:	0f b6 00             	movzbl (%rax),%eax
  8009cd:	0f be c0             	movsbl %al,%eax
  8009d0:	89 c6                	mov    %eax,%esi
  8009d2:	48 bf 71 69 80 00 00 	movabs $0x806971,%rdi
  8009d9:	00 00 00 
  8009dc:	48 b8 92 23 80 00 00 	movabs $0x802392,%rax
  8009e3:	00 00 00 
  8009e6:	ff d0                	callq  *%rax
  8009e8:	48 85 c0             	test   %rax,%rax
  8009eb:	74 c9                	je     8009b6 <_gettoken+0x1b2>
		s++;
	*p2 = s;
  8009ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009f5:	48 89 10             	mov    %rdx,(%rax)
	if (debug > 1) {
  8009f8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8009ff:	00 00 00 
  800a02:	8b 00                	mov    (%rax),%eax
  800a04:	83 f8 01             	cmp    $0x1,%eax
  800a07:	7e 4b                	jle    800a54 <_gettoken+0x250>
		t = **p2;
  800a09:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a0d:	48 8b 00             	mov    (%rax),%rax
  800a10:	0f b6 00             	movzbl (%rax),%eax
  800a13:	0f be c0             	movsbl %al,%eax
  800a16:	89 45 fc             	mov    %eax,-0x4(%rbp)
		**p2 = 0;
  800a19:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a1d:	48 8b 00             	mov    (%rax),%rax
  800a20:	c6 00 00             	movb   $0x0,(%rax)
		cprintf("WORD: %s\n", *p1);
  800a23:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800a27:	48 8b 00             	mov    (%rax),%rax
  800a2a:	48 89 c6             	mov    %rax,%rsi
  800a2d:	48 bf 7d 69 80 00 00 	movabs $0x80697d,%rdi
  800a34:	00 00 00 
  800a37:	b8 00 00 00 00       	mov    $0x0,%eax
  800a3c:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  800a43:	00 00 00 
  800a46:	ff d2                	callq  *%rdx
		**p2 = t;
  800a48:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a4c:	48 8b 00             	mov    (%rax),%rax
  800a4f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800a52:	88 10                	mov    %dl,(%rax)
	}
	return 'w';
  800a54:	b8 77 00 00 00       	mov    $0x77,%eax
}
  800a59:	c9                   	leaveq 
  800a5a:	c3                   	retq   

0000000000800a5b <gettoken>:

int
gettoken(char *s, char **p1)
{
  800a5b:	55                   	push   %rbp
  800a5c:	48 89 e5             	mov    %rsp,%rbp
  800a5f:	48 83 ec 10          	sub    $0x10,%rsp
  800a63:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800a67:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static int c, nc;
	static char* np1, *np2;

	if (s) {
  800a6b:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  800a70:	74 3a                	je     800aac <gettoken+0x51>
		nc = _gettoken(s, &np1, &np2);
  800a72:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800a76:	48 ba 10 a0 80 00 00 	movabs $0x80a010,%rdx
  800a7d:	00 00 00 
  800a80:	48 be 08 a0 80 00 00 	movabs $0x80a008,%rsi
  800a87:	00 00 00 
  800a8a:	48 89 c7             	mov    %rax,%rdi
  800a8d:	48 b8 04 08 80 00 00 	movabs $0x800804,%rax
  800a94:	00 00 00 
  800a97:	ff d0                	callq  *%rax
  800a99:	48 ba 18 a0 80 00 00 	movabs $0x80a018,%rdx
  800aa0:	00 00 00 
  800aa3:	89 02                	mov    %eax,(%rdx)
		return 0;
  800aa5:	b8 00 00 00 00       	mov    $0x0,%eax
  800aaa:	eb 74                	jmp    800b20 <gettoken+0xc5>
	}
	c = nc;
  800aac:	48 b8 18 a0 80 00 00 	movabs $0x80a018,%rax
  800ab3:	00 00 00 
  800ab6:	8b 10                	mov    (%rax),%edx
  800ab8:	48 b8 1c a0 80 00 00 	movabs $0x80a01c,%rax
  800abf:	00 00 00 
  800ac2:	89 10                	mov    %edx,(%rax)
	*p1 = np1;
  800ac4:	48 b8 08 a0 80 00 00 	movabs $0x80a008,%rax
  800acb:	00 00 00 
  800ace:	48 8b 10             	mov    (%rax),%rdx
  800ad1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ad5:	48 89 10             	mov    %rdx,(%rax)
	nc = _gettoken(np2, &np1, &np2);
  800ad8:	48 b8 10 a0 80 00 00 	movabs $0x80a010,%rax
  800adf:	00 00 00 
  800ae2:	48 8b 00             	mov    (%rax),%rax
  800ae5:	48 ba 10 a0 80 00 00 	movabs $0x80a010,%rdx
  800aec:	00 00 00 
  800aef:	48 be 08 a0 80 00 00 	movabs $0x80a008,%rsi
  800af6:	00 00 00 
  800af9:	48 89 c7             	mov    %rax,%rdi
  800afc:	48 b8 04 08 80 00 00 	movabs $0x800804,%rax
  800b03:	00 00 00 
  800b06:	ff d0                	callq  *%rax
  800b08:	48 ba 18 a0 80 00 00 	movabs $0x80a018,%rdx
  800b0f:	00 00 00 
  800b12:	89 02                	mov    %eax,(%rdx)
	return c;
  800b14:	48 b8 1c a0 80 00 00 	movabs $0x80a01c,%rax
  800b1b:	00 00 00 
  800b1e:	8b 00                	mov    (%rax),%eax
}
  800b20:	c9                   	leaveq 
  800b21:	c3                   	retq   

0000000000800b22 <usage>:


void
usage(void)
{
  800b22:	55                   	push   %rbp
  800b23:	48 89 e5             	mov    %rsp,%rbp
	cprintf("usage: sh [-dix] [command-file]\n");
  800b26:	48 bf 88 69 80 00 00 	movabs $0x806988,%rdi
  800b2d:	00 00 00 
  800b30:	b8 00 00 00 00       	mov    $0x0,%eax
  800b35:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  800b3c:	00 00 00 
  800b3f:	ff d2                	callq  *%rdx
	exit();
  800b41:	48 b8 01 12 80 00 00 	movabs $0x801201,%rax
  800b48:	00 00 00 
  800b4b:	ff d0                	callq  *%rax
}
  800b4d:	5d                   	pop    %rbp
  800b4e:	c3                   	retq   

0000000000800b4f <umain>:

void
umain(int argc, char **argv)
{
  800b4f:	55                   	push   %rbp
  800b50:	48 89 e5             	mov    %rsp,%rbp
  800b53:	48 83 ec 50          	sub    $0x50,%rsp
  800b57:	89 7d bc             	mov    %edi,-0x44(%rbp)
  800b5a:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
	int r, interactive, echocmds;
	struct Argstate args;
	interactive = '?';
  800b5e:	c7 45 fc 3f 00 00 00 	movl   $0x3f,-0x4(%rbp)
	echocmds = 0;
  800b65:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	argstart(&argc, argv, &args);
  800b6c:	48 8d 55 c0          	lea    -0x40(%rbp),%rdx
  800b70:	48 8b 4d b0          	mov    -0x50(%rbp),%rcx
  800b74:	48 8d 45 bc          	lea    -0x44(%rbp),%rax
  800b78:	48 89 ce             	mov    %rcx,%rsi
  800b7b:	48 89 c7             	mov    %rax,%rdi
  800b7e:	48 b8 6c 34 80 00 00 	movabs $0x80346c,%rax
  800b85:	00 00 00 
  800b88:	ff d0                	callq  *%rax
	while ((r = argnext(&args)) >= 0)
  800b8a:	eb 4d                	jmp    800bd9 <umain+0x8a>
		switch (r) {
  800b8c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800b8f:	83 f8 69             	cmp    $0x69,%eax
  800b92:	74 27                	je     800bbb <umain+0x6c>
  800b94:	83 f8 78             	cmp    $0x78,%eax
  800b97:	74 2b                	je     800bc4 <umain+0x75>
  800b99:	83 f8 64             	cmp    $0x64,%eax
  800b9c:	75 2f                	jne    800bcd <umain+0x7e>
		case 'd':
			debug++;
  800b9e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800ba5:	00 00 00 
  800ba8:	8b 00                	mov    (%rax),%eax
  800baa:	8d 50 01             	lea    0x1(%rax),%edx
  800bad:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800bb4:	00 00 00 
  800bb7:	89 10                	mov    %edx,(%rax)
			break;
  800bb9:	eb 1e                	jmp    800bd9 <umain+0x8a>
		case 'i':
			interactive = 1;
  800bbb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
			break;
  800bc2:	eb 15                	jmp    800bd9 <umain+0x8a>
		case 'x':
			echocmds = 1;
  800bc4:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
			break;
  800bcb:	eb 0c                	jmp    800bd9 <umain+0x8a>
		default:
			usage();
  800bcd:	48 b8 22 0b 80 00 00 	movabs $0x800b22,%rax
  800bd4:	00 00 00 
  800bd7:	ff d0                	callq  *%rax
	int r, interactive, echocmds;
	struct Argstate args;
	interactive = '?';
	echocmds = 0;
	argstart(&argc, argv, &args);
	while ((r = argnext(&args)) >= 0)
  800bd9:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  800bdd:	48 89 c7             	mov    %rax,%rdi
  800be0:	48 b8 d0 34 80 00 00 	movabs $0x8034d0,%rax
  800be7:	00 00 00 
  800bea:	ff d0                	callq  *%rax
  800bec:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800bef:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800bf3:	79 97                	jns    800b8c <umain+0x3d>
			echocmds = 1;
			break;
		default:
			usage();
		}
	if (argc > 2)
  800bf5:	8b 45 bc             	mov    -0x44(%rbp),%eax
  800bf8:	83 f8 02             	cmp    $0x2,%eax
  800bfb:	7e 0c                	jle    800c09 <umain+0xba>
		usage();
  800bfd:	48 b8 22 0b 80 00 00 	movabs $0x800b22,%rax
  800c04:	00 00 00 
  800c07:	ff d0                	callq  *%rax
	if (argc == 2) {
  800c09:	8b 45 bc             	mov    -0x44(%rbp),%eax
  800c0c:	83 f8 02             	cmp    $0x2,%eax
  800c0f:	0f 85 b3 00 00 00    	jne    800cc8 <umain+0x179>
		close(0);
  800c15:	bf 00 00 00 00       	mov    $0x0,%edi
  800c1a:	48 b8 47 3a 80 00 00 	movabs $0x803a47,%rax
  800c21:	00 00 00 
  800c24:	ff d0                	callq  *%rax
		if ((r = open(argv[1], O_RDONLY)) < 0)
  800c26:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800c2a:	48 83 c0 08          	add    $0x8,%rax
  800c2e:	48 8b 00             	mov    (%rax),%rax
  800c31:	be 00 00 00 00       	mov    $0x0,%esi
  800c36:	48 89 c7             	mov    %rax,%rdi
  800c39:	48 b8 3f 41 80 00 00 	movabs $0x80413f,%rax
  800c40:	00 00 00 
  800c43:	ff d0                	callq  *%rax
  800c45:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800c48:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800c4c:	79 3f                	jns    800c8d <umain+0x13e>
			panic("open %s: %e", argv[1], r);
  800c4e:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800c52:	48 83 c0 08          	add    $0x8,%rax
  800c56:	48 8b 00             	mov    (%rax),%rax
  800c59:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800c5c:	41 89 d0             	mov    %edx,%r8d
  800c5f:	48 89 c1             	mov    %rax,%rcx
  800c62:	48 ba a9 69 80 00 00 	movabs $0x8069a9,%rdx
  800c69:	00 00 00 
  800c6c:	be 29 01 00 00       	mov    $0x129,%esi
  800c71:	48 bf b7 68 80 00 00 	movabs $0x8068b7,%rdi
  800c78:	00 00 00 
  800c7b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c80:	49 b9 24 12 80 00 00 	movabs $0x801224,%r9
  800c87:	00 00 00 
  800c8a:	41 ff d1             	callq  *%r9
		assert(r == 0);
  800c8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800c91:	74 35                	je     800cc8 <umain+0x179>
  800c93:	48 b9 b5 69 80 00 00 	movabs $0x8069b5,%rcx
  800c9a:	00 00 00 
  800c9d:	48 ba bc 69 80 00 00 	movabs $0x8069bc,%rdx
  800ca4:	00 00 00 
  800ca7:	be 2a 01 00 00       	mov    $0x12a,%esi
  800cac:	48 bf b7 68 80 00 00 	movabs $0x8068b7,%rdi
  800cb3:	00 00 00 
  800cb6:	b8 00 00 00 00       	mov    $0x0,%eax
  800cbb:	49 b8 24 12 80 00 00 	movabs $0x801224,%r8
  800cc2:	00 00 00 
  800cc5:	41 ff d0             	callq  *%r8
	}
	if (interactive == '?')
  800cc8:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%rbp)
  800ccc:	75 14                	jne    800ce2 <umain+0x193>
		interactive = iscons(0);
  800cce:	bf 00 00 00 00       	mov    $0x0,%edi
  800cd3:	48 b8 37 0f 80 00 00 	movabs $0x800f37,%rax
  800cda:	00 00 00 
  800cdd:	ff d0                	callq  *%rax
  800cdf:	89 45 fc             	mov    %eax,-0x4(%rbp)

	while (1) {
		char *buf;
		buf = readline(interactive ? "$ " : NULL);
  800ce2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ce6:	74 0c                	je     800cf4 <umain+0x1a5>
  800ce8:	48 b8 d1 69 80 00 00 	movabs $0x8069d1,%rax
  800cef:	00 00 00 
  800cf2:	eb 05                	jmp    800cf9 <umain+0x1aa>
  800cf4:	b8 00 00 00 00       	mov    $0x0,%eax
  800cf9:	48 89 c7             	mov    %rax,%rdi
  800cfc:	48 b8 a6 1f 80 00 00 	movabs $0x801fa6,%rax
  800d03:	00 00 00 
  800d06:	ff d0                	callq  *%rax
  800d08:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		if (buf == NULL) {
  800d0c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800d11:	75 37                	jne    800d4a <umain+0x1fb>
			if (debug)
  800d13:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800d1a:	00 00 00 
  800d1d:	8b 00                	mov    (%rax),%eax
  800d1f:	85 c0                	test   %eax,%eax
  800d21:	74 1b                	je     800d3e <umain+0x1ef>
				cprintf("EXITING\n");
  800d23:	48 bf d4 69 80 00 00 	movabs $0x8069d4,%rdi
  800d2a:	00 00 00 
  800d2d:	b8 00 00 00 00       	mov    $0x0,%eax
  800d32:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  800d39:	00 00 00 
  800d3c:	ff d2                	callq  *%rdx
			exit();	// end of file
  800d3e:	48 b8 01 12 80 00 00 	movabs $0x801201,%rax
  800d45:	00 00 00 
  800d48:	ff d0                	callq  *%rax
		}
		if(strcmp(buf, "quit")==0)
  800d4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d4e:	48 be dd 69 80 00 00 	movabs $0x8069dd,%rsi
  800d55:	00 00 00 
  800d58:	48 89 c7             	mov    %rax,%rdi
  800d5b:	48 b8 ce 22 80 00 00 	movabs $0x8022ce,%rax
  800d62:	00 00 00 
  800d65:	ff d0                	callq  *%rax
  800d67:	85 c0                	test   %eax,%eax
  800d69:	75 0c                	jne    800d77 <umain+0x228>
			exit();
  800d6b:	48 b8 01 12 80 00 00 	movabs $0x801201,%rax
  800d72:	00 00 00 
  800d75:	ff d0                	callq  *%rax
		if (debug)
  800d77:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800d7e:	00 00 00 
  800d81:	8b 00                	mov    (%rax),%eax
  800d83:	85 c0                	test   %eax,%eax
  800d85:	74 22                	je     800da9 <umain+0x25a>
			cprintf("LINE: %s\n", buf);
  800d87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d8b:	48 89 c6             	mov    %rax,%rsi
  800d8e:	48 bf e2 69 80 00 00 	movabs $0x8069e2,%rdi
  800d95:	00 00 00 
  800d98:	b8 00 00 00 00       	mov    $0x0,%eax
  800d9d:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  800da4:	00 00 00 
  800da7:	ff d2                	callq  *%rdx
		if (buf[0] == '#')
  800da9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dad:	0f b6 00             	movzbl (%rax),%eax
  800db0:	3c 23                	cmp    $0x23,%al
  800db2:	75 05                	jne    800db9 <umain+0x26a>
			continue;
  800db4:	e9 05 01 00 00       	jmpq   800ebe <umain+0x36f>
		if (echocmds)
  800db9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800dbd:	74 22                	je     800de1 <umain+0x292>
			printf("# %s\n", buf);
  800dbf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dc3:	48 89 c6             	mov    %rax,%rsi
  800dc6:	48 bf ec 69 80 00 00 	movabs $0x8069ec,%rdi
  800dcd:	00 00 00 
  800dd0:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd5:	48 ba a3 49 80 00 00 	movabs $0x8049a3,%rdx
  800ddc:	00 00 00 
  800ddf:	ff d2                	callq  *%rdx
			//fprintf(1, "# %s\n", buf);
		if (debug)
  800de1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800de8:	00 00 00 
  800deb:	8b 00                	mov    (%rax),%eax
  800ded:	85 c0                	test   %eax,%eax
  800def:	74 1b                	je     800e0c <umain+0x2bd>
			cprintf("BEFORE FORK\n");
  800df1:	48 bf f2 69 80 00 00 	movabs $0x8069f2,%rdi
  800df8:	00 00 00 
  800dfb:	b8 00 00 00 00       	mov    $0x0,%eax
  800e00:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  800e07:	00 00 00 
  800e0a:	ff d2                	callq  *%rdx
		if ((r = fork()) < 0)
  800e0c:	48 b8 bb 31 80 00 00 	movabs $0x8031bb,%rax
  800e13:	00 00 00 
  800e16:	ff d0                	callq  *%rax
  800e18:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800e1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800e1f:	79 30                	jns    800e51 <umain+0x302>
			panic("fork: %e", r);
  800e21:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800e24:	89 c1                	mov    %eax,%ecx
  800e26:	48 ba 92 68 80 00 00 	movabs $0x806892,%rdx
  800e2d:	00 00 00 
  800e30:	be 43 01 00 00       	mov    $0x143,%esi
  800e35:	48 bf b7 68 80 00 00 	movabs $0x8068b7,%rdi
  800e3c:	00 00 00 
  800e3f:	b8 00 00 00 00       	mov    $0x0,%eax
  800e44:	49 b8 24 12 80 00 00 	movabs $0x801224,%r8
  800e4b:	00 00 00 
  800e4e:	41 ff d0             	callq  *%r8
		if (debug)
  800e51:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800e58:	00 00 00 
  800e5b:	8b 00                	mov    (%rax),%eax
  800e5d:	85 c0                	test   %eax,%eax
  800e5f:	74 20                	je     800e81 <umain+0x332>
			cprintf("FORK: %d\n", r);
  800e61:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800e64:	89 c6                	mov    %eax,%esi
  800e66:	48 bf ff 69 80 00 00 	movabs $0x8069ff,%rdi
  800e6d:	00 00 00 
  800e70:	b8 00 00 00 00       	mov    $0x0,%eax
  800e75:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  800e7c:	00 00 00 
  800e7f:	ff d2                	callq  *%rdx
		if (r == 0) {
  800e81:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800e85:	75 21                	jne    800ea8 <umain+0x359>
			runcmd(buf);
  800e87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e8b:	48 89 c7             	mov    %rax,%rdi
  800e8e:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800e95:	00 00 00 
  800e98:	ff d0                	callq  *%rax
			exit();
  800e9a:	48 b8 01 12 80 00 00 	movabs $0x801201,%rax
  800ea1:	00 00 00 
  800ea4:	ff d0                	callq  *%rax
  800ea6:	eb 16                	jmp    800ebe <umain+0x36f>
		} else {
			wait(r);
  800ea8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800eab:	89 c7                	mov    %eax,%edi
  800ead:	48 b8 82 63 80 00 00 	movabs $0x806382,%rax
  800eb4:	00 00 00 
  800eb7:	ff d0                	callq  *%rax
		}
	}
  800eb9:	e9 24 fe ff ff       	jmpq   800ce2 <umain+0x193>
  800ebe:	e9 1f fe ff ff       	jmpq   800ce2 <umain+0x193>

0000000000800ec3 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800ec3:	55                   	push   %rbp
  800ec4:	48 89 e5             	mov    %rsp,%rbp
  800ec7:	48 83 ec 20          	sub    $0x20,%rsp
  800ecb:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  800ece:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800ed1:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800ed4:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  800ed8:	be 01 00 00 00       	mov    $0x1,%esi
  800edd:	48 89 c7             	mov    %rax,%rdi
  800ee0:	48 b8 53 29 80 00 00 	movabs $0x802953,%rax
  800ee7:	00 00 00 
  800eea:	ff d0                	callq  *%rax
}
  800eec:	c9                   	leaveq 
  800eed:	c3                   	retq   

0000000000800eee <getchar>:

int
getchar(void)
{
  800eee:	55                   	push   %rbp
  800eef:	48 89 e5             	mov    %rsp,%rbp
  800ef2:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  800ef6:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  800efa:	ba 01 00 00 00       	mov    $0x1,%edx
  800eff:	48 89 c6             	mov    %rax,%rsi
  800f02:	bf 00 00 00 00       	mov    $0x0,%edi
  800f07:	48 b8 69 3c 80 00 00 	movabs $0x803c69,%rax
  800f0e:	00 00 00 
  800f11:	ff d0                	callq  *%rax
  800f13:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  800f16:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f1a:	79 05                	jns    800f21 <getchar+0x33>
		return r;
  800f1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f1f:	eb 14                	jmp    800f35 <getchar+0x47>
	if (r < 1)
  800f21:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f25:	7f 07                	jg     800f2e <getchar+0x40>
		return -E_EOF;
  800f27:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  800f2c:	eb 07                	jmp    800f35 <getchar+0x47>
	return c;
  800f2e:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  800f32:	0f b6 c0             	movzbl %al,%eax
}
  800f35:	c9                   	leaveq 
  800f36:	c3                   	retq   

0000000000800f37 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  800f37:	55                   	push   %rbp
  800f38:	48 89 e5             	mov    %rsp,%rbp
  800f3b:	48 83 ec 20          	sub    $0x20,%rsp
  800f3f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f42:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800f46:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800f49:	48 89 d6             	mov    %rdx,%rsi
  800f4c:	89 c7                	mov    %eax,%edi
  800f4e:	48 b8 37 38 80 00 00 	movabs $0x803837,%rax
  800f55:	00 00 00 
  800f58:	ff d0                	callq  *%rax
  800f5a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800f5d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f61:	79 05                	jns    800f68 <iscons+0x31>
		return r;
  800f63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f66:	eb 1a                	jmp    800f82 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  800f68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f6c:	8b 10                	mov    (%rax),%edx
  800f6e:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  800f75:	00 00 00 
  800f78:	8b 00                	mov    (%rax),%eax
  800f7a:	39 c2                	cmp    %eax,%edx
  800f7c:	0f 94 c0             	sete   %al
  800f7f:	0f b6 c0             	movzbl %al,%eax
}
  800f82:	c9                   	leaveq 
  800f83:	c3                   	retq   

0000000000800f84 <opencons>:

int
opencons(void)
{
  800f84:	55                   	push   %rbp
  800f85:	48 89 e5             	mov    %rsp,%rbp
  800f88:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800f8c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800f90:	48 89 c7             	mov    %rax,%rdi
  800f93:	48 b8 9f 37 80 00 00 	movabs $0x80379f,%rax
  800f9a:	00 00 00 
  800f9d:	ff d0                	callq  *%rax
  800f9f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800fa2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800fa6:	79 05                	jns    800fad <opencons+0x29>
		return r;
  800fa8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fab:	eb 5b                	jmp    801008 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800fad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fb1:	ba 07 04 00 00       	mov    $0x407,%edx
  800fb6:	48 89 c6             	mov    %rax,%rsi
  800fb9:	bf 00 00 00 00       	mov    $0x0,%edi
  800fbe:	48 b8 9b 2a 80 00 00 	movabs $0x802a9b,%rax
  800fc5:	00 00 00 
  800fc8:	ff d0                	callq  *%rax
  800fca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800fcd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800fd1:	79 05                	jns    800fd8 <opencons+0x54>
		return r;
  800fd3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fd6:	eb 30                	jmp    801008 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  800fd8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fdc:	48 ba 20 90 80 00 00 	movabs $0x809020,%rdx
  800fe3:	00 00 00 
  800fe6:	8b 12                	mov    (%rdx),%edx
  800fe8:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  800fea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fee:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  800ff5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ff9:	48 89 c7             	mov    %rax,%rdi
  800ffc:	48 b8 51 37 80 00 00 	movabs $0x803751,%rax
  801003:	00 00 00 
  801006:	ff d0                	callq  *%rax
}
  801008:	c9                   	leaveq 
  801009:	c3                   	retq   

000000000080100a <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80100a:	55                   	push   %rbp
  80100b:	48 89 e5             	mov    %rsp,%rbp
  80100e:	48 83 ec 30          	sub    $0x30,%rsp
  801012:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801016:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80101a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80101e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801023:	75 07                	jne    80102c <devcons_read+0x22>
		return 0;
  801025:	b8 00 00 00 00       	mov    $0x0,%eax
  80102a:	eb 4b                	jmp    801077 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  80102c:	eb 0c                	jmp    80103a <devcons_read+0x30>
		sys_yield();
  80102e:	48 b8 5d 2a 80 00 00 	movabs $0x802a5d,%rax
  801035:	00 00 00 
  801038:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80103a:	48 b8 9d 29 80 00 00 	movabs $0x80299d,%rax
  801041:	00 00 00 
  801044:	ff d0                	callq  *%rax
  801046:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801049:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80104d:	74 df                	je     80102e <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  80104f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801053:	79 05                	jns    80105a <devcons_read+0x50>
		return c;
  801055:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801058:	eb 1d                	jmp    801077 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80105a:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80105e:	75 07                	jne    801067 <devcons_read+0x5d>
		return 0;
  801060:	b8 00 00 00 00       	mov    $0x0,%eax
  801065:	eb 10                	jmp    801077 <devcons_read+0x6d>
	*(char*)vbuf = c;
  801067:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80106a:	89 c2                	mov    %eax,%edx
  80106c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801070:	88 10                	mov    %dl,(%rax)
	return 1;
  801072:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801077:	c9                   	leaveq 
  801078:	c3                   	retq   

0000000000801079 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801079:	55                   	push   %rbp
  80107a:	48 89 e5             	mov    %rsp,%rbp
  80107d:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  801084:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80108b:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  801092:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801099:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010a0:	eb 76                	jmp    801118 <devcons_write+0x9f>
		m = n - tot;
  8010a2:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8010a9:	89 c2                	mov    %eax,%edx
  8010ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010ae:	29 c2                	sub    %eax,%edx
  8010b0:	89 d0                	mov    %edx,%eax
  8010b2:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8010b5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8010b8:	83 f8 7f             	cmp    $0x7f,%eax
  8010bb:	76 07                	jbe    8010c4 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8010bd:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8010c4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8010c7:	48 63 d0             	movslq %eax,%rdx
  8010ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010cd:	48 63 c8             	movslq %eax,%rcx
  8010d0:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8010d7:	48 01 c1             	add    %rax,%rcx
  8010da:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8010e1:	48 89 ce             	mov    %rcx,%rsi
  8010e4:	48 89 c7             	mov    %rax,%rdi
  8010e7:	48 b8 90 24 80 00 00 	movabs $0x802490,%rax
  8010ee:	00 00 00 
  8010f1:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8010f3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8010f6:	48 63 d0             	movslq %eax,%rdx
  8010f9:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801100:	48 89 d6             	mov    %rdx,%rsi
  801103:	48 89 c7             	mov    %rax,%rdi
  801106:	48 b8 53 29 80 00 00 	movabs $0x802953,%rax
  80110d:	00 00 00 
  801110:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801112:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801115:	01 45 fc             	add    %eax,-0x4(%rbp)
  801118:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80111b:	48 98                	cltq   
  80111d:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  801124:	0f 82 78 ff ff ff    	jb     8010a2 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80112a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80112d:	c9                   	leaveq 
  80112e:	c3                   	retq   

000000000080112f <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80112f:	55                   	push   %rbp
  801130:	48 89 e5             	mov    %rsp,%rbp
  801133:	48 83 ec 08          	sub    $0x8,%rsp
  801137:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80113b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801140:	c9                   	leaveq 
  801141:	c3                   	retq   

0000000000801142 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801142:	55                   	push   %rbp
  801143:	48 89 e5             	mov    %rsp,%rbp
  801146:	48 83 ec 10          	sub    $0x10,%rsp
  80114a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80114e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  801152:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801156:	48 be 0e 6a 80 00 00 	movabs $0x806a0e,%rsi
  80115d:	00 00 00 
  801160:	48 89 c7             	mov    %rax,%rdi
  801163:	48 b8 6c 21 80 00 00 	movabs $0x80216c,%rax
  80116a:	00 00 00 
  80116d:	ff d0                	callq  *%rax
	return 0;
  80116f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801174:	c9                   	leaveq 
  801175:	c3                   	retq   

0000000000801176 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  801176:	55                   	push   %rbp
  801177:	48 89 e5             	mov    %rsp,%rbp
  80117a:	48 83 ec 10          	sub    $0x10,%rsp
  80117e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801181:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  801185:	48 b8 1f 2a 80 00 00 	movabs $0x802a1f,%rax
  80118c:	00 00 00 
  80118f:	ff d0                	callq  *%rax
  801191:	25 ff 03 00 00       	and    $0x3ff,%eax
  801196:	48 63 d0             	movslq %eax,%rdx
  801199:	48 89 d0             	mov    %rdx,%rax
  80119c:	48 c1 e0 03          	shl    $0x3,%rax
  8011a0:	48 01 d0             	add    %rdx,%rax
  8011a3:	48 c1 e0 05          	shl    $0x5,%rax
  8011a7:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8011ae:	00 00 00 
  8011b1:	48 01 c2             	add    %rax,%rdx
  8011b4:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  8011bb:	00 00 00 
  8011be:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8011c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8011c5:	7e 14                	jle    8011db <libmain+0x65>
		binaryname = argv[0];
  8011c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011cb:	48 8b 10             	mov    (%rax),%rdx
  8011ce:	48 b8 58 90 80 00 00 	movabs $0x809058,%rax
  8011d5:	00 00 00 
  8011d8:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8011db:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8011df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011e2:	48 89 d6             	mov    %rdx,%rsi
  8011e5:	89 c7                	mov    %eax,%edi
  8011e7:	48 b8 4f 0b 80 00 00 	movabs $0x800b4f,%rax
  8011ee:	00 00 00 
  8011f1:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8011f3:	48 b8 01 12 80 00 00 	movabs $0x801201,%rax
  8011fa:	00 00 00 
  8011fd:	ff d0                	callq  *%rax
}
  8011ff:	c9                   	leaveq 
  801200:	c3                   	retq   

0000000000801201 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  801201:	55                   	push   %rbp
  801202:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  801205:	48 b8 92 3a 80 00 00 	movabs $0x803a92,%rax
  80120c:	00 00 00 
  80120f:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  801211:	bf 00 00 00 00       	mov    $0x0,%edi
  801216:	48 b8 db 29 80 00 00 	movabs $0x8029db,%rax
  80121d:	00 00 00 
  801220:	ff d0                	callq  *%rax

}
  801222:	5d                   	pop    %rbp
  801223:	c3                   	retq   

0000000000801224 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801224:	55                   	push   %rbp
  801225:	48 89 e5             	mov    %rsp,%rbp
  801228:	53                   	push   %rbx
  801229:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801230:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  801237:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80123d:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  801244:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80124b:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801252:	84 c0                	test   %al,%al
  801254:	74 23                	je     801279 <_panic+0x55>
  801256:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80125d:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  801261:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  801265:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  801269:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80126d:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  801271:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  801275:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  801279:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801280:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  801287:	00 00 00 
  80128a:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  801291:	00 00 00 
  801294:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801298:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80129f:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8012a6:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8012ad:	48 b8 58 90 80 00 00 	movabs $0x809058,%rax
  8012b4:	00 00 00 
  8012b7:	48 8b 18             	mov    (%rax),%rbx
  8012ba:	48 b8 1f 2a 80 00 00 	movabs $0x802a1f,%rax
  8012c1:	00 00 00 
  8012c4:	ff d0                	callq  *%rax
  8012c6:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8012cc:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8012d3:	41 89 c8             	mov    %ecx,%r8d
  8012d6:	48 89 d1             	mov    %rdx,%rcx
  8012d9:	48 89 da             	mov    %rbx,%rdx
  8012dc:	89 c6                	mov    %eax,%esi
  8012de:	48 bf 20 6a 80 00 00 	movabs $0x806a20,%rdi
  8012e5:	00 00 00 
  8012e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ed:	49 b9 5d 14 80 00 00 	movabs $0x80145d,%r9
  8012f4:	00 00 00 
  8012f7:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8012fa:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  801301:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801308:	48 89 d6             	mov    %rdx,%rsi
  80130b:	48 89 c7             	mov    %rax,%rdi
  80130e:	48 b8 b1 13 80 00 00 	movabs $0x8013b1,%rax
  801315:	00 00 00 
  801318:	ff d0                	callq  *%rax
	cprintf("\n");
  80131a:	48 bf 43 6a 80 00 00 	movabs $0x806a43,%rdi
  801321:	00 00 00 
  801324:	b8 00 00 00 00       	mov    $0x0,%eax
  801329:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  801330:	00 00 00 
  801333:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801335:	cc                   	int3   
  801336:	eb fd                	jmp    801335 <_panic+0x111>

0000000000801338 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  801338:	55                   	push   %rbp
  801339:	48 89 e5             	mov    %rsp,%rbp
  80133c:	48 83 ec 10          	sub    $0x10,%rsp
  801340:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801343:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  801347:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80134b:	8b 00                	mov    (%rax),%eax
  80134d:	8d 48 01             	lea    0x1(%rax),%ecx
  801350:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801354:	89 0a                	mov    %ecx,(%rdx)
  801356:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801359:	89 d1                	mov    %edx,%ecx
  80135b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80135f:	48 98                	cltq   
  801361:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  801365:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801369:	8b 00                	mov    (%rax),%eax
  80136b:	3d ff 00 00 00       	cmp    $0xff,%eax
  801370:	75 2c                	jne    80139e <putch+0x66>
        sys_cputs(b->buf, b->idx);
  801372:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801376:	8b 00                	mov    (%rax),%eax
  801378:	48 98                	cltq   
  80137a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80137e:	48 83 c2 08          	add    $0x8,%rdx
  801382:	48 89 c6             	mov    %rax,%rsi
  801385:	48 89 d7             	mov    %rdx,%rdi
  801388:	48 b8 53 29 80 00 00 	movabs $0x802953,%rax
  80138f:	00 00 00 
  801392:	ff d0                	callq  *%rax
        b->idx = 0;
  801394:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801398:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80139e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013a2:	8b 40 04             	mov    0x4(%rax),%eax
  8013a5:	8d 50 01             	lea    0x1(%rax),%edx
  8013a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013ac:	89 50 04             	mov    %edx,0x4(%rax)
}
  8013af:	c9                   	leaveq 
  8013b0:	c3                   	retq   

00000000008013b1 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8013b1:	55                   	push   %rbp
  8013b2:	48 89 e5             	mov    %rsp,%rbp
  8013b5:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8013bc:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8013c3:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8013ca:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8013d1:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8013d8:	48 8b 0a             	mov    (%rdx),%rcx
  8013db:	48 89 08             	mov    %rcx,(%rax)
  8013de:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8013e2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8013e6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8013ea:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8013ee:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8013f5:	00 00 00 
    b.cnt = 0;
  8013f8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8013ff:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  801402:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  801409:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  801410:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  801417:	48 89 c6             	mov    %rax,%rsi
  80141a:	48 bf 38 13 80 00 00 	movabs $0x801338,%rdi
  801421:	00 00 00 
  801424:	48 b8 10 18 80 00 00 	movabs $0x801810,%rax
  80142b:	00 00 00 
  80142e:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  801430:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  801436:	48 98                	cltq   
  801438:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80143f:	48 83 c2 08          	add    $0x8,%rdx
  801443:	48 89 c6             	mov    %rax,%rsi
  801446:	48 89 d7             	mov    %rdx,%rdi
  801449:	48 b8 53 29 80 00 00 	movabs $0x802953,%rax
  801450:	00 00 00 
  801453:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  801455:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80145b:	c9                   	leaveq 
  80145c:	c3                   	retq   

000000000080145d <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80145d:	55                   	push   %rbp
  80145e:	48 89 e5             	mov    %rsp,%rbp
  801461:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  801468:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80146f:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  801476:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80147d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801484:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80148b:	84 c0                	test   %al,%al
  80148d:	74 20                	je     8014af <cprintf+0x52>
  80148f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801493:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801497:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80149b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80149f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8014a3:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8014a7:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8014ab:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8014af:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8014b6:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8014bd:	00 00 00 
  8014c0:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8014c7:	00 00 00 
  8014ca:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8014ce:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8014d5:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8014dc:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8014e3:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8014ea:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8014f1:	48 8b 0a             	mov    (%rdx),%rcx
  8014f4:	48 89 08             	mov    %rcx,(%rax)
  8014f7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8014fb:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8014ff:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801503:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  801507:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80150e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801515:	48 89 d6             	mov    %rdx,%rsi
  801518:	48 89 c7             	mov    %rax,%rdi
  80151b:	48 b8 b1 13 80 00 00 	movabs $0x8013b1,%rax
  801522:	00 00 00 
  801525:	ff d0                	callq  *%rax
  801527:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80152d:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801533:	c9                   	leaveq 
  801534:	c3                   	retq   

0000000000801535 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801535:	55                   	push   %rbp
  801536:	48 89 e5             	mov    %rsp,%rbp
  801539:	53                   	push   %rbx
  80153a:	48 83 ec 38          	sub    $0x38,%rsp
  80153e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801542:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801546:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80154a:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80154d:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  801551:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801555:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801558:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80155c:	77 3b                	ja     801599 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80155e:	8b 45 d0             	mov    -0x30(%rbp),%eax
  801561:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  801565:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  801568:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80156c:	ba 00 00 00 00       	mov    $0x0,%edx
  801571:	48 f7 f3             	div    %rbx
  801574:	48 89 c2             	mov    %rax,%rdx
  801577:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80157a:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80157d:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  801581:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801585:	41 89 f9             	mov    %edi,%r9d
  801588:	48 89 c7             	mov    %rax,%rdi
  80158b:	48 b8 35 15 80 00 00 	movabs $0x801535,%rax
  801592:	00 00 00 
  801595:	ff d0                	callq  *%rax
  801597:	eb 1e                	jmp    8015b7 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801599:	eb 12                	jmp    8015ad <printnum+0x78>
			putch(padc, putdat);
  80159b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80159f:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8015a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015a6:	48 89 ce             	mov    %rcx,%rsi
  8015a9:	89 d7                	mov    %edx,%edi
  8015ab:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8015ad:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8015b1:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8015b5:	7f e4                	jg     80159b <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8015b7:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8015ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015be:	ba 00 00 00 00       	mov    $0x0,%edx
  8015c3:	48 f7 f1             	div    %rcx
  8015c6:	48 89 d0             	mov    %rdx,%rax
  8015c9:	48 ba 50 6c 80 00 00 	movabs $0x806c50,%rdx
  8015d0:	00 00 00 
  8015d3:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8015d7:	0f be d0             	movsbl %al,%edx
  8015da:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8015de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015e2:	48 89 ce             	mov    %rcx,%rsi
  8015e5:	89 d7                	mov    %edx,%edi
  8015e7:	ff d0                	callq  *%rax
}
  8015e9:	48 83 c4 38          	add    $0x38,%rsp
  8015ed:	5b                   	pop    %rbx
  8015ee:	5d                   	pop    %rbp
  8015ef:	c3                   	retq   

00000000008015f0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8015f0:	55                   	push   %rbp
  8015f1:	48 89 e5             	mov    %rsp,%rbp
  8015f4:	48 83 ec 1c          	sub    $0x1c,%rsp
  8015f8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015fc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8015ff:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  801603:	7e 52                	jle    801657 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  801605:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801609:	8b 00                	mov    (%rax),%eax
  80160b:	83 f8 30             	cmp    $0x30,%eax
  80160e:	73 24                	jae    801634 <getuint+0x44>
  801610:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801614:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801618:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80161c:	8b 00                	mov    (%rax),%eax
  80161e:	89 c0                	mov    %eax,%eax
  801620:	48 01 d0             	add    %rdx,%rax
  801623:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801627:	8b 12                	mov    (%rdx),%edx
  801629:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80162c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801630:	89 0a                	mov    %ecx,(%rdx)
  801632:	eb 17                	jmp    80164b <getuint+0x5b>
  801634:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801638:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80163c:	48 89 d0             	mov    %rdx,%rax
  80163f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801643:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801647:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80164b:	48 8b 00             	mov    (%rax),%rax
  80164e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801652:	e9 a3 00 00 00       	jmpq   8016fa <getuint+0x10a>
	else if (lflag)
  801657:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80165b:	74 4f                	je     8016ac <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80165d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801661:	8b 00                	mov    (%rax),%eax
  801663:	83 f8 30             	cmp    $0x30,%eax
  801666:	73 24                	jae    80168c <getuint+0x9c>
  801668:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80166c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801670:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801674:	8b 00                	mov    (%rax),%eax
  801676:	89 c0                	mov    %eax,%eax
  801678:	48 01 d0             	add    %rdx,%rax
  80167b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80167f:	8b 12                	mov    (%rdx),%edx
  801681:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801684:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801688:	89 0a                	mov    %ecx,(%rdx)
  80168a:	eb 17                	jmp    8016a3 <getuint+0xb3>
  80168c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801690:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801694:	48 89 d0             	mov    %rdx,%rax
  801697:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80169b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80169f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8016a3:	48 8b 00             	mov    (%rax),%rax
  8016a6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8016aa:	eb 4e                	jmp    8016fa <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8016ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016b0:	8b 00                	mov    (%rax),%eax
  8016b2:	83 f8 30             	cmp    $0x30,%eax
  8016b5:	73 24                	jae    8016db <getuint+0xeb>
  8016b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016bb:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8016bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016c3:	8b 00                	mov    (%rax),%eax
  8016c5:	89 c0                	mov    %eax,%eax
  8016c7:	48 01 d0             	add    %rdx,%rax
  8016ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016ce:	8b 12                	mov    (%rdx),%edx
  8016d0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8016d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016d7:	89 0a                	mov    %ecx,(%rdx)
  8016d9:	eb 17                	jmp    8016f2 <getuint+0x102>
  8016db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016df:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8016e3:	48 89 d0             	mov    %rdx,%rax
  8016e6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8016ea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016ee:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8016f2:	8b 00                	mov    (%rax),%eax
  8016f4:	89 c0                	mov    %eax,%eax
  8016f6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8016fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8016fe:	c9                   	leaveq 
  8016ff:	c3                   	retq   

0000000000801700 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801700:	55                   	push   %rbp
  801701:	48 89 e5             	mov    %rsp,%rbp
  801704:	48 83 ec 1c          	sub    $0x1c,%rsp
  801708:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80170c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80170f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  801713:	7e 52                	jle    801767 <getint+0x67>
		x=va_arg(*ap, long long);
  801715:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801719:	8b 00                	mov    (%rax),%eax
  80171b:	83 f8 30             	cmp    $0x30,%eax
  80171e:	73 24                	jae    801744 <getint+0x44>
  801720:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801724:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801728:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80172c:	8b 00                	mov    (%rax),%eax
  80172e:	89 c0                	mov    %eax,%eax
  801730:	48 01 d0             	add    %rdx,%rax
  801733:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801737:	8b 12                	mov    (%rdx),%edx
  801739:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80173c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801740:	89 0a                	mov    %ecx,(%rdx)
  801742:	eb 17                	jmp    80175b <getint+0x5b>
  801744:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801748:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80174c:	48 89 d0             	mov    %rdx,%rax
  80174f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801753:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801757:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80175b:	48 8b 00             	mov    (%rax),%rax
  80175e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801762:	e9 a3 00 00 00       	jmpq   80180a <getint+0x10a>
	else if (lflag)
  801767:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80176b:	74 4f                	je     8017bc <getint+0xbc>
		x=va_arg(*ap, long);
  80176d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801771:	8b 00                	mov    (%rax),%eax
  801773:	83 f8 30             	cmp    $0x30,%eax
  801776:	73 24                	jae    80179c <getint+0x9c>
  801778:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80177c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801780:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801784:	8b 00                	mov    (%rax),%eax
  801786:	89 c0                	mov    %eax,%eax
  801788:	48 01 d0             	add    %rdx,%rax
  80178b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80178f:	8b 12                	mov    (%rdx),%edx
  801791:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801794:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801798:	89 0a                	mov    %ecx,(%rdx)
  80179a:	eb 17                	jmp    8017b3 <getint+0xb3>
  80179c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017a0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8017a4:	48 89 d0             	mov    %rdx,%rax
  8017a7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8017ab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017af:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8017b3:	48 8b 00             	mov    (%rax),%rax
  8017b6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8017ba:	eb 4e                	jmp    80180a <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8017bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017c0:	8b 00                	mov    (%rax),%eax
  8017c2:	83 f8 30             	cmp    $0x30,%eax
  8017c5:	73 24                	jae    8017eb <getint+0xeb>
  8017c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017cb:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8017cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017d3:	8b 00                	mov    (%rax),%eax
  8017d5:	89 c0                	mov    %eax,%eax
  8017d7:	48 01 d0             	add    %rdx,%rax
  8017da:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017de:	8b 12                	mov    (%rdx),%edx
  8017e0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8017e3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017e7:	89 0a                	mov    %ecx,(%rdx)
  8017e9:	eb 17                	jmp    801802 <getint+0x102>
  8017eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017ef:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8017f3:	48 89 d0             	mov    %rdx,%rax
  8017f6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8017fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017fe:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801802:	8b 00                	mov    (%rax),%eax
  801804:	48 98                	cltq   
  801806:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80180a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80180e:	c9                   	leaveq 
  80180f:	c3                   	retq   

0000000000801810 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801810:	55                   	push   %rbp
  801811:	48 89 e5             	mov    %rsp,%rbp
  801814:	41 54                	push   %r12
  801816:	53                   	push   %rbx
  801817:	48 83 ec 60          	sub    $0x60,%rsp
  80181b:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80181f:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  801823:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801827:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80182b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80182f:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  801833:	48 8b 0a             	mov    (%rdx),%rcx
  801836:	48 89 08             	mov    %rcx,(%rax)
  801839:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80183d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801841:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801845:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801849:	eb 17                	jmp    801862 <vprintfmt+0x52>
			if (ch == '\0')
  80184b:	85 db                	test   %ebx,%ebx
  80184d:	0f 84 cc 04 00 00    	je     801d1f <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  801853:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801857:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80185b:	48 89 d6             	mov    %rdx,%rsi
  80185e:	89 df                	mov    %ebx,%edi
  801860:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801862:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801866:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80186a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80186e:	0f b6 00             	movzbl (%rax),%eax
  801871:	0f b6 d8             	movzbl %al,%ebx
  801874:	83 fb 25             	cmp    $0x25,%ebx
  801877:	75 d2                	jne    80184b <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801879:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80187d:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  801884:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80188b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  801892:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801899:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80189d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018a1:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8018a5:	0f b6 00             	movzbl (%rax),%eax
  8018a8:	0f b6 d8             	movzbl %al,%ebx
  8018ab:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8018ae:	83 f8 55             	cmp    $0x55,%eax
  8018b1:	0f 87 34 04 00 00    	ja     801ceb <vprintfmt+0x4db>
  8018b7:	89 c0                	mov    %eax,%eax
  8018b9:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8018c0:	00 
  8018c1:	48 b8 78 6c 80 00 00 	movabs $0x806c78,%rax
  8018c8:	00 00 00 
  8018cb:	48 01 d0             	add    %rdx,%rax
  8018ce:	48 8b 00             	mov    (%rax),%rax
  8018d1:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8018d3:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8018d7:	eb c0                	jmp    801899 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8018d9:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8018dd:	eb ba                	jmp    801899 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8018df:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8018e6:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8018e9:	89 d0                	mov    %edx,%eax
  8018eb:	c1 e0 02             	shl    $0x2,%eax
  8018ee:	01 d0                	add    %edx,%eax
  8018f0:	01 c0                	add    %eax,%eax
  8018f2:	01 d8                	add    %ebx,%eax
  8018f4:	83 e8 30             	sub    $0x30,%eax
  8018f7:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8018fa:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8018fe:	0f b6 00             	movzbl (%rax),%eax
  801901:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801904:	83 fb 2f             	cmp    $0x2f,%ebx
  801907:	7e 0c                	jle    801915 <vprintfmt+0x105>
  801909:	83 fb 39             	cmp    $0x39,%ebx
  80190c:	7f 07                	jg     801915 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80190e:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801913:	eb d1                	jmp    8018e6 <vprintfmt+0xd6>
			goto process_precision;
  801915:	eb 58                	jmp    80196f <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  801917:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80191a:	83 f8 30             	cmp    $0x30,%eax
  80191d:	73 17                	jae    801936 <vprintfmt+0x126>
  80191f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801923:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801926:	89 c0                	mov    %eax,%eax
  801928:	48 01 d0             	add    %rdx,%rax
  80192b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80192e:	83 c2 08             	add    $0x8,%edx
  801931:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801934:	eb 0f                	jmp    801945 <vprintfmt+0x135>
  801936:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80193a:	48 89 d0             	mov    %rdx,%rax
  80193d:	48 83 c2 08          	add    $0x8,%rdx
  801941:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801945:	8b 00                	mov    (%rax),%eax
  801947:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80194a:	eb 23                	jmp    80196f <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80194c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801950:	79 0c                	jns    80195e <vprintfmt+0x14e>
				width = 0;
  801952:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  801959:	e9 3b ff ff ff       	jmpq   801899 <vprintfmt+0x89>
  80195e:	e9 36 ff ff ff       	jmpq   801899 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  801963:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80196a:	e9 2a ff ff ff       	jmpq   801899 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80196f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801973:	79 12                	jns    801987 <vprintfmt+0x177>
				width = precision, precision = -1;
  801975:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801978:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80197b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  801982:	e9 12 ff ff ff       	jmpq   801899 <vprintfmt+0x89>
  801987:	e9 0d ff ff ff       	jmpq   801899 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  80198c:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  801990:	e9 04 ff ff ff       	jmpq   801899 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  801995:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801998:	83 f8 30             	cmp    $0x30,%eax
  80199b:	73 17                	jae    8019b4 <vprintfmt+0x1a4>
  80199d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8019a1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8019a4:	89 c0                	mov    %eax,%eax
  8019a6:	48 01 d0             	add    %rdx,%rax
  8019a9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8019ac:	83 c2 08             	add    $0x8,%edx
  8019af:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8019b2:	eb 0f                	jmp    8019c3 <vprintfmt+0x1b3>
  8019b4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8019b8:	48 89 d0             	mov    %rdx,%rax
  8019bb:	48 83 c2 08          	add    $0x8,%rdx
  8019bf:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8019c3:	8b 10                	mov    (%rax),%edx
  8019c5:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8019c9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8019cd:	48 89 ce             	mov    %rcx,%rsi
  8019d0:	89 d7                	mov    %edx,%edi
  8019d2:	ff d0                	callq  *%rax
			break;
  8019d4:	e9 40 03 00 00       	jmpq   801d19 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8019d9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8019dc:	83 f8 30             	cmp    $0x30,%eax
  8019df:	73 17                	jae    8019f8 <vprintfmt+0x1e8>
  8019e1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8019e5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8019e8:	89 c0                	mov    %eax,%eax
  8019ea:	48 01 d0             	add    %rdx,%rax
  8019ed:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8019f0:	83 c2 08             	add    $0x8,%edx
  8019f3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8019f6:	eb 0f                	jmp    801a07 <vprintfmt+0x1f7>
  8019f8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8019fc:	48 89 d0             	mov    %rdx,%rax
  8019ff:	48 83 c2 08          	add    $0x8,%rdx
  801a03:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801a07:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  801a09:	85 db                	test   %ebx,%ebx
  801a0b:	79 02                	jns    801a0f <vprintfmt+0x1ff>
				err = -err;
  801a0d:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801a0f:	83 fb 15             	cmp    $0x15,%ebx
  801a12:	7f 16                	jg     801a2a <vprintfmt+0x21a>
  801a14:	48 b8 a0 6b 80 00 00 	movabs $0x806ba0,%rax
  801a1b:	00 00 00 
  801a1e:	48 63 d3             	movslq %ebx,%rdx
  801a21:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  801a25:	4d 85 e4             	test   %r12,%r12
  801a28:	75 2e                	jne    801a58 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  801a2a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801a2e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801a32:	89 d9                	mov    %ebx,%ecx
  801a34:	48 ba 61 6c 80 00 00 	movabs $0x806c61,%rdx
  801a3b:	00 00 00 
  801a3e:	48 89 c7             	mov    %rax,%rdi
  801a41:	b8 00 00 00 00       	mov    $0x0,%eax
  801a46:	49 b8 28 1d 80 00 00 	movabs $0x801d28,%r8
  801a4d:	00 00 00 
  801a50:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801a53:	e9 c1 02 00 00       	jmpq   801d19 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801a58:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801a5c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801a60:	4c 89 e1             	mov    %r12,%rcx
  801a63:	48 ba 6a 6c 80 00 00 	movabs $0x806c6a,%rdx
  801a6a:	00 00 00 
  801a6d:	48 89 c7             	mov    %rax,%rdi
  801a70:	b8 00 00 00 00       	mov    $0x0,%eax
  801a75:	49 b8 28 1d 80 00 00 	movabs $0x801d28,%r8
  801a7c:	00 00 00 
  801a7f:	41 ff d0             	callq  *%r8
			break;
  801a82:	e9 92 02 00 00       	jmpq   801d19 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  801a87:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801a8a:	83 f8 30             	cmp    $0x30,%eax
  801a8d:	73 17                	jae    801aa6 <vprintfmt+0x296>
  801a8f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801a93:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801a96:	89 c0                	mov    %eax,%eax
  801a98:	48 01 d0             	add    %rdx,%rax
  801a9b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801a9e:	83 c2 08             	add    $0x8,%edx
  801aa1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801aa4:	eb 0f                	jmp    801ab5 <vprintfmt+0x2a5>
  801aa6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801aaa:	48 89 d0             	mov    %rdx,%rax
  801aad:	48 83 c2 08          	add    $0x8,%rdx
  801ab1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801ab5:	4c 8b 20             	mov    (%rax),%r12
  801ab8:	4d 85 e4             	test   %r12,%r12
  801abb:	75 0a                	jne    801ac7 <vprintfmt+0x2b7>
				p = "(null)";
  801abd:	49 bc 6d 6c 80 00 00 	movabs $0x806c6d,%r12
  801ac4:	00 00 00 
			if (width > 0 && padc != '-')
  801ac7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801acb:	7e 3f                	jle    801b0c <vprintfmt+0x2fc>
  801acd:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  801ad1:	74 39                	je     801b0c <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  801ad3:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801ad6:	48 98                	cltq   
  801ad8:	48 89 c6             	mov    %rax,%rsi
  801adb:	4c 89 e7             	mov    %r12,%rdi
  801ade:	48 b8 2e 21 80 00 00 	movabs $0x80212e,%rax
  801ae5:	00 00 00 
  801ae8:	ff d0                	callq  *%rax
  801aea:	29 45 dc             	sub    %eax,-0x24(%rbp)
  801aed:	eb 17                	jmp    801b06 <vprintfmt+0x2f6>
					putch(padc, putdat);
  801aef:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  801af3:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  801af7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801afb:	48 89 ce             	mov    %rcx,%rsi
  801afe:	89 d7                	mov    %edx,%edi
  801b00:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801b02:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801b06:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801b0a:	7f e3                	jg     801aef <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801b0c:	eb 37                	jmp    801b45 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  801b0e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  801b12:	74 1e                	je     801b32 <vprintfmt+0x322>
  801b14:	83 fb 1f             	cmp    $0x1f,%ebx
  801b17:	7e 05                	jle    801b1e <vprintfmt+0x30e>
  801b19:	83 fb 7e             	cmp    $0x7e,%ebx
  801b1c:	7e 14                	jle    801b32 <vprintfmt+0x322>
					putch('?', putdat);
  801b1e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801b22:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801b26:	48 89 d6             	mov    %rdx,%rsi
  801b29:	bf 3f 00 00 00       	mov    $0x3f,%edi
  801b2e:	ff d0                	callq  *%rax
  801b30:	eb 0f                	jmp    801b41 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  801b32:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801b36:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801b3a:	48 89 d6             	mov    %rdx,%rsi
  801b3d:	89 df                	mov    %ebx,%edi
  801b3f:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801b41:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801b45:	4c 89 e0             	mov    %r12,%rax
  801b48:	4c 8d 60 01          	lea    0x1(%rax),%r12
  801b4c:	0f b6 00             	movzbl (%rax),%eax
  801b4f:	0f be d8             	movsbl %al,%ebx
  801b52:	85 db                	test   %ebx,%ebx
  801b54:	74 10                	je     801b66 <vprintfmt+0x356>
  801b56:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801b5a:	78 b2                	js     801b0e <vprintfmt+0x2fe>
  801b5c:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  801b60:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801b64:	79 a8                	jns    801b0e <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801b66:	eb 16                	jmp    801b7e <vprintfmt+0x36e>
				putch(' ', putdat);
  801b68:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801b6c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801b70:	48 89 d6             	mov    %rdx,%rsi
  801b73:	bf 20 00 00 00       	mov    $0x20,%edi
  801b78:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801b7a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801b7e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801b82:	7f e4                	jg     801b68 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  801b84:	e9 90 01 00 00       	jmpq   801d19 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801b89:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801b8d:	be 03 00 00 00       	mov    $0x3,%esi
  801b92:	48 89 c7             	mov    %rax,%rdi
  801b95:	48 b8 00 17 80 00 00 	movabs $0x801700,%rax
  801b9c:	00 00 00 
  801b9f:	ff d0                	callq  *%rax
  801ba1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  801ba5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ba9:	48 85 c0             	test   %rax,%rax
  801bac:	79 1d                	jns    801bcb <vprintfmt+0x3bb>
				putch('-', putdat);
  801bae:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801bb2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801bb6:	48 89 d6             	mov    %rdx,%rsi
  801bb9:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801bbe:	ff d0                	callq  *%rax
				num = -(long long) num;
  801bc0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bc4:	48 f7 d8             	neg    %rax
  801bc7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  801bcb:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801bd2:	e9 d5 00 00 00       	jmpq   801cac <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  801bd7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801bdb:	be 03 00 00 00       	mov    $0x3,%esi
  801be0:	48 89 c7             	mov    %rax,%rdi
  801be3:	48 b8 f0 15 80 00 00 	movabs $0x8015f0,%rax
  801bea:	00 00 00 
  801bed:	ff d0                	callq  *%rax
  801bef:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  801bf3:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801bfa:	e9 ad 00 00 00       	jmpq   801cac <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  801bff:	8b 55 e0             	mov    -0x20(%rbp),%edx
  801c02:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801c06:	89 d6                	mov    %edx,%esi
  801c08:	48 89 c7             	mov    %rax,%rdi
  801c0b:	48 b8 00 17 80 00 00 	movabs $0x801700,%rax
  801c12:	00 00 00 
  801c15:	ff d0                	callq  *%rax
  801c17:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  801c1b:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  801c22:	e9 85 00 00 00       	jmpq   801cac <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  801c27:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801c2b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801c2f:	48 89 d6             	mov    %rdx,%rsi
  801c32:	bf 30 00 00 00       	mov    $0x30,%edi
  801c37:	ff d0                	callq  *%rax
			putch('x', putdat);
  801c39:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801c3d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801c41:	48 89 d6             	mov    %rdx,%rsi
  801c44:	bf 78 00 00 00       	mov    $0x78,%edi
  801c49:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801c4b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801c4e:	83 f8 30             	cmp    $0x30,%eax
  801c51:	73 17                	jae    801c6a <vprintfmt+0x45a>
  801c53:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801c57:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801c5a:	89 c0                	mov    %eax,%eax
  801c5c:	48 01 d0             	add    %rdx,%rax
  801c5f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801c62:	83 c2 08             	add    $0x8,%edx
  801c65:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801c68:	eb 0f                	jmp    801c79 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  801c6a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801c6e:	48 89 d0             	mov    %rdx,%rax
  801c71:	48 83 c2 08          	add    $0x8,%rdx
  801c75:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801c79:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801c7c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801c80:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801c87:	eb 23                	jmp    801cac <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801c89:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801c8d:	be 03 00 00 00       	mov    $0x3,%esi
  801c92:	48 89 c7             	mov    %rax,%rdi
  801c95:	48 b8 f0 15 80 00 00 	movabs $0x8015f0,%rax
  801c9c:	00 00 00 
  801c9f:	ff d0                	callq  *%rax
  801ca1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801ca5:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801cac:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  801cb1:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801cb4:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801cb7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801cbb:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801cbf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801cc3:	45 89 c1             	mov    %r8d,%r9d
  801cc6:	41 89 f8             	mov    %edi,%r8d
  801cc9:	48 89 c7             	mov    %rax,%rdi
  801ccc:	48 b8 35 15 80 00 00 	movabs $0x801535,%rax
  801cd3:	00 00 00 
  801cd6:	ff d0                	callq  *%rax
			break;
  801cd8:	eb 3f                	jmp    801d19 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  801cda:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801cde:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801ce2:	48 89 d6             	mov    %rdx,%rsi
  801ce5:	89 df                	mov    %ebx,%edi
  801ce7:	ff d0                	callq  *%rax
			break;
  801ce9:	eb 2e                	jmp    801d19 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801ceb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801cef:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801cf3:	48 89 d6             	mov    %rdx,%rsi
  801cf6:	bf 25 00 00 00       	mov    $0x25,%edi
  801cfb:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  801cfd:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801d02:	eb 05                	jmp    801d09 <vprintfmt+0x4f9>
  801d04:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801d09:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801d0d:	48 83 e8 01          	sub    $0x1,%rax
  801d11:	0f b6 00             	movzbl (%rax),%eax
  801d14:	3c 25                	cmp    $0x25,%al
  801d16:	75 ec                	jne    801d04 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  801d18:	90                   	nop
		}
	}
  801d19:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801d1a:	e9 43 fb ff ff       	jmpq   801862 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  801d1f:	48 83 c4 60          	add    $0x60,%rsp
  801d23:	5b                   	pop    %rbx
  801d24:	41 5c                	pop    %r12
  801d26:	5d                   	pop    %rbp
  801d27:	c3                   	retq   

0000000000801d28 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801d28:	55                   	push   %rbp
  801d29:	48 89 e5             	mov    %rsp,%rbp
  801d2c:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801d33:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801d3a:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801d41:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801d48:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801d4f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801d56:	84 c0                	test   %al,%al
  801d58:	74 20                	je     801d7a <printfmt+0x52>
  801d5a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801d5e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801d62:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801d66:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801d6a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801d6e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801d72:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801d76:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801d7a:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801d81:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801d88:	00 00 00 
  801d8b:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801d92:	00 00 00 
  801d95:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801d99:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801da0:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801da7:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801dae:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801db5:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801dbc:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801dc3:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801dca:	48 89 c7             	mov    %rax,%rdi
  801dcd:	48 b8 10 18 80 00 00 	movabs $0x801810,%rax
  801dd4:	00 00 00 
  801dd7:	ff d0                	callq  *%rax
	va_end(ap);
}
  801dd9:	c9                   	leaveq 
  801dda:	c3                   	retq   

0000000000801ddb <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801ddb:	55                   	push   %rbp
  801ddc:	48 89 e5             	mov    %rsp,%rbp
  801ddf:	48 83 ec 10          	sub    $0x10,%rsp
  801de3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801de6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801dea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dee:	8b 40 10             	mov    0x10(%rax),%eax
  801df1:	8d 50 01             	lea    0x1(%rax),%edx
  801df4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801df8:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801dfb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dff:	48 8b 10             	mov    (%rax),%rdx
  801e02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e06:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e0a:	48 39 c2             	cmp    %rax,%rdx
  801e0d:	73 17                	jae    801e26 <sprintputch+0x4b>
		*b->buf++ = ch;
  801e0f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e13:	48 8b 00             	mov    (%rax),%rax
  801e16:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801e1a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e1e:	48 89 0a             	mov    %rcx,(%rdx)
  801e21:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801e24:	88 10                	mov    %dl,(%rax)
}
  801e26:	c9                   	leaveq 
  801e27:	c3                   	retq   

0000000000801e28 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801e28:	55                   	push   %rbp
  801e29:	48 89 e5             	mov    %rsp,%rbp
  801e2c:	48 83 ec 50          	sub    $0x50,%rsp
  801e30:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801e34:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801e37:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801e3b:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801e3f:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801e43:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801e47:	48 8b 0a             	mov    (%rdx),%rcx
  801e4a:	48 89 08             	mov    %rcx,(%rax)
  801e4d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801e51:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801e55:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801e59:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801e5d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801e61:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801e65:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801e68:	48 98                	cltq   
  801e6a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801e6e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801e72:	48 01 d0             	add    %rdx,%rax
  801e75:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801e79:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801e80:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801e85:	74 06                	je     801e8d <vsnprintf+0x65>
  801e87:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801e8b:	7f 07                	jg     801e94 <vsnprintf+0x6c>
		return -E_INVAL;
  801e8d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e92:	eb 2f                	jmp    801ec3 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801e94:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801e98:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801e9c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801ea0:	48 89 c6             	mov    %rax,%rsi
  801ea3:	48 bf db 1d 80 00 00 	movabs $0x801ddb,%rdi
  801eaa:	00 00 00 
  801ead:	48 b8 10 18 80 00 00 	movabs $0x801810,%rax
  801eb4:	00 00 00 
  801eb7:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801eb9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ebd:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801ec0:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801ec3:	c9                   	leaveq 
  801ec4:	c3                   	retq   

0000000000801ec5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801ec5:	55                   	push   %rbp
  801ec6:	48 89 e5             	mov    %rsp,%rbp
  801ec9:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801ed0:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801ed7:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801edd:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801ee4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801eeb:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801ef2:	84 c0                	test   %al,%al
  801ef4:	74 20                	je     801f16 <snprintf+0x51>
  801ef6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801efa:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801efe:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801f02:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801f06:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801f0a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801f0e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801f12:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801f16:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801f1d:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801f24:	00 00 00 
  801f27:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801f2e:	00 00 00 
  801f31:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801f35:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801f3c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801f43:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801f4a:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801f51:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801f58:	48 8b 0a             	mov    (%rdx),%rcx
  801f5b:	48 89 08             	mov    %rcx,(%rax)
  801f5e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801f62:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801f66:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801f6a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801f6e:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801f75:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801f7c:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801f82:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801f89:	48 89 c7             	mov    %rax,%rdi
  801f8c:	48 b8 28 1e 80 00 00 	movabs $0x801e28,%rax
  801f93:	00 00 00 
  801f96:	ff d0                	callq  *%rax
  801f98:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801f9e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801fa4:	c9                   	leaveq 
  801fa5:	c3                   	retq   

0000000000801fa6 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  801fa6:	55                   	push   %rbp
  801fa7:	48 89 e5             	mov    %rsp,%rbp
  801faa:	48 83 ec 20          	sub    $0x20,%rsp
  801fae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  801fb2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801fb7:	74 27                	je     801fe0 <readline+0x3a>
		fprintf(1, "%s", prompt);
  801fb9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fbd:	48 89 c2             	mov    %rax,%rdx
  801fc0:	48 be 28 6f 80 00 00 	movabs $0x806f28,%rsi
  801fc7:	00 00 00 
  801fca:	bf 01 00 00 00       	mov    $0x1,%edi
  801fcf:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd4:	48 b9 eb 48 80 00 00 	movabs $0x8048eb,%rcx
  801fdb:	00 00 00 
  801fde:	ff d1                	callq  *%rcx
#endif

	i = 0;
  801fe0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	echoing = iscons(0);
  801fe7:	bf 00 00 00 00       	mov    $0x0,%edi
  801fec:	48 b8 37 0f 80 00 00 	movabs $0x800f37,%rax
  801ff3:	00 00 00 
  801ff6:	ff d0                	callq  *%rax
  801ff8:	89 45 f8             	mov    %eax,-0x8(%rbp)
	while (1) {
		c = getchar();
  801ffb:	48 b8 ee 0e 80 00 00 	movabs $0x800eee,%rax
  802002:	00 00 00 
  802005:	ff d0                	callq  *%rax
  802007:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if (c < 0) {
  80200a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80200e:	79 30                	jns    802040 <readline+0x9a>
			if (c != -E_EOF)
  802010:	83 7d f4 f7          	cmpl   $0xfffffff7,-0xc(%rbp)
  802014:	74 20                	je     802036 <readline+0x90>
				cprintf("read error: %e\n", c);
  802016:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802019:	89 c6                	mov    %eax,%esi
  80201b:	48 bf 2b 6f 80 00 00 	movabs $0x806f2b,%rdi
  802022:	00 00 00 
  802025:	b8 00 00 00 00       	mov    $0x0,%eax
  80202a:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  802031:	00 00 00 
  802034:	ff d2                	callq  *%rdx
			return NULL;
  802036:	b8 00 00 00 00       	mov    $0x0,%eax
  80203b:	e9 be 00 00 00       	jmpq   8020fe <readline+0x158>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  802040:	83 7d f4 08          	cmpl   $0x8,-0xc(%rbp)
  802044:	74 06                	je     80204c <readline+0xa6>
  802046:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%rbp)
  80204a:	75 26                	jne    802072 <readline+0xcc>
  80204c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802050:	7e 20                	jle    802072 <readline+0xcc>
			if (echoing)
  802052:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802056:	74 11                	je     802069 <readline+0xc3>
				cputchar('\b');
  802058:	bf 08 00 00 00       	mov    $0x8,%edi
  80205d:	48 b8 c3 0e 80 00 00 	movabs $0x800ec3,%rax
  802064:	00 00 00 
  802067:	ff d0                	callq  *%rax
			i--;
  802069:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
  80206d:	e9 87 00 00 00       	jmpq   8020f9 <readline+0x153>
		} else if (c >= ' ' && i < BUFLEN-1) {
  802072:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%rbp)
  802076:	7e 3f                	jle    8020b7 <readline+0x111>
  802078:	81 7d fc fe 03 00 00 	cmpl   $0x3fe,-0x4(%rbp)
  80207f:	7f 36                	jg     8020b7 <readline+0x111>
			if (echoing)
  802081:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802085:	74 11                	je     802098 <readline+0xf2>
				cputchar(c);
  802087:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80208a:	89 c7                	mov    %eax,%edi
  80208c:	48 b8 c3 0e 80 00 00 	movabs $0x800ec3,%rax
  802093:	00 00 00 
  802096:	ff d0                	callq  *%rax
			buf[i++] = c;
  802098:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80209b:	8d 50 01             	lea    0x1(%rax),%edx
  80209e:	89 55 fc             	mov    %edx,-0x4(%rbp)
  8020a1:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8020a4:	89 d1                	mov    %edx,%ecx
  8020a6:	48 ba 20 a0 80 00 00 	movabs $0x80a020,%rdx
  8020ad:	00 00 00 
  8020b0:	48 98                	cltq   
  8020b2:	88 0c 02             	mov    %cl,(%rdx,%rax,1)
  8020b5:	eb 42                	jmp    8020f9 <readline+0x153>
		} else if (c == '\n' || c == '\r') {
  8020b7:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  8020bb:	74 06                	je     8020c3 <readline+0x11d>
  8020bd:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  8020c1:	75 36                	jne    8020f9 <readline+0x153>
			if (echoing)
  8020c3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8020c7:	74 11                	je     8020da <readline+0x134>
				cputchar('\n');
  8020c9:	bf 0a 00 00 00       	mov    $0xa,%edi
  8020ce:	48 b8 c3 0e 80 00 00 	movabs $0x800ec3,%rax
  8020d5:	00 00 00 
  8020d8:	ff d0                	callq  *%rax
			buf[i] = 0;
  8020da:	48 ba 20 a0 80 00 00 	movabs $0x80a020,%rdx
  8020e1:	00 00 00 
  8020e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020e7:	48 98                	cltq   
  8020e9:	c6 04 02 00          	movb   $0x0,(%rdx,%rax,1)
			return buf;
  8020ed:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  8020f4:	00 00 00 
  8020f7:	eb 05                	jmp    8020fe <readline+0x158>
		}
	}
  8020f9:	e9 fd fe ff ff       	jmpq   801ffb <readline+0x55>
}
  8020fe:	c9                   	leaveq 
  8020ff:	c3                   	retq   

0000000000802100 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  802100:	55                   	push   %rbp
  802101:	48 89 e5             	mov    %rsp,%rbp
  802104:	48 83 ec 18          	sub    $0x18,%rsp
  802108:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80210c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802113:	eb 09                	jmp    80211e <strlen+0x1e>
		n++;
  802115:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  802119:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80211e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802122:	0f b6 00             	movzbl (%rax),%eax
  802125:	84 c0                	test   %al,%al
  802127:	75 ec                	jne    802115 <strlen+0x15>
		n++;
	return n;
  802129:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80212c:	c9                   	leaveq 
  80212d:	c3                   	retq   

000000000080212e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80212e:	55                   	push   %rbp
  80212f:	48 89 e5             	mov    %rsp,%rbp
  802132:	48 83 ec 20          	sub    $0x20,%rsp
  802136:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80213a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80213e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802145:	eb 0e                	jmp    802155 <strnlen+0x27>
		n++;
  802147:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80214b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802150:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  802155:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80215a:	74 0b                	je     802167 <strnlen+0x39>
  80215c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802160:	0f b6 00             	movzbl (%rax),%eax
  802163:	84 c0                	test   %al,%al
  802165:	75 e0                	jne    802147 <strnlen+0x19>
		n++;
	return n;
  802167:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80216a:	c9                   	leaveq 
  80216b:	c3                   	retq   

000000000080216c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80216c:	55                   	push   %rbp
  80216d:	48 89 e5             	mov    %rsp,%rbp
  802170:	48 83 ec 20          	sub    $0x20,%rsp
  802174:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802178:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80217c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802180:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  802184:	90                   	nop
  802185:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802189:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80218d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802191:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802195:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802199:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80219d:	0f b6 12             	movzbl (%rdx),%edx
  8021a0:	88 10                	mov    %dl,(%rax)
  8021a2:	0f b6 00             	movzbl (%rax),%eax
  8021a5:	84 c0                	test   %al,%al
  8021a7:	75 dc                	jne    802185 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8021a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8021ad:	c9                   	leaveq 
  8021ae:	c3                   	retq   

00000000008021af <strcat>:

char *
strcat(char *dst, const char *src)
{
  8021af:	55                   	push   %rbp
  8021b0:	48 89 e5             	mov    %rsp,%rbp
  8021b3:	48 83 ec 20          	sub    $0x20,%rsp
  8021b7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8021bb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8021bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021c3:	48 89 c7             	mov    %rax,%rdi
  8021c6:	48 b8 00 21 80 00 00 	movabs $0x802100,%rax
  8021cd:	00 00 00 
  8021d0:	ff d0                	callq  *%rax
  8021d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8021d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021d8:	48 63 d0             	movslq %eax,%rdx
  8021db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021df:	48 01 c2             	add    %rax,%rdx
  8021e2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021e6:	48 89 c6             	mov    %rax,%rsi
  8021e9:	48 89 d7             	mov    %rdx,%rdi
  8021ec:	48 b8 6c 21 80 00 00 	movabs $0x80216c,%rax
  8021f3:	00 00 00 
  8021f6:	ff d0                	callq  *%rax
	return dst;
  8021f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8021fc:	c9                   	leaveq 
  8021fd:	c3                   	retq   

00000000008021fe <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8021fe:	55                   	push   %rbp
  8021ff:	48 89 e5             	mov    %rsp,%rbp
  802202:	48 83 ec 28          	sub    $0x28,%rsp
  802206:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80220a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80220e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  802212:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802216:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80221a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802221:	00 
  802222:	eb 2a                	jmp    80224e <strncpy+0x50>
		*dst++ = *src;
  802224:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802228:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80222c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802230:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802234:	0f b6 12             	movzbl (%rdx),%edx
  802237:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  802239:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80223d:	0f b6 00             	movzbl (%rax),%eax
  802240:	84 c0                	test   %al,%al
  802242:	74 05                	je     802249 <strncpy+0x4b>
			src++;
  802244:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802249:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80224e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802252:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802256:	72 cc                	jb     802224 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  802258:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80225c:	c9                   	leaveq 
  80225d:	c3                   	retq   

000000000080225e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80225e:	55                   	push   %rbp
  80225f:	48 89 e5             	mov    %rsp,%rbp
  802262:	48 83 ec 28          	sub    $0x28,%rsp
  802266:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80226a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80226e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  802272:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802276:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80227a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80227f:	74 3d                	je     8022be <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  802281:	eb 1d                	jmp    8022a0 <strlcpy+0x42>
			*dst++ = *src++;
  802283:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802287:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80228b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80228f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802293:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802297:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80229b:	0f b6 12             	movzbl (%rdx),%edx
  80229e:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8022a0:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8022a5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8022aa:	74 0b                	je     8022b7 <strlcpy+0x59>
  8022ac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022b0:	0f b6 00             	movzbl (%rax),%eax
  8022b3:	84 c0                	test   %al,%al
  8022b5:	75 cc                	jne    802283 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8022b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022bb:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8022be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022c6:	48 29 c2             	sub    %rax,%rdx
  8022c9:	48 89 d0             	mov    %rdx,%rax
}
  8022cc:	c9                   	leaveq 
  8022cd:	c3                   	retq   

00000000008022ce <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8022ce:	55                   	push   %rbp
  8022cf:	48 89 e5             	mov    %rsp,%rbp
  8022d2:	48 83 ec 10          	sub    $0x10,%rsp
  8022d6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8022da:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8022de:	eb 0a                	jmp    8022ea <strcmp+0x1c>
		p++, q++;
  8022e0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8022e5:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8022ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022ee:	0f b6 00             	movzbl (%rax),%eax
  8022f1:	84 c0                	test   %al,%al
  8022f3:	74 12                	je     802307 <strcmp+0x39>
  8022f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022f9:	0f b6 10             	movzbl (%rax),%edx
  8022fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802300:	0f b6 00             	movzbl (%rax),%eax
  802303:	38 c2                	cmp    %al,%dl
  802305:	74 d9                	je     8022e0 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802307:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80230b:	0f b6 00             	movzbl (%rax),%eax
  80230e:	0f b6 d0             	movzbl %al,%edx
  802311:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802315:	0f b6 00             	movzbl (%rax),%eax
  802318:	0f b6 c0             	movzbl %al,%eax
  80231b:	29 c2                	sub    %eax,%edx
  80231d:	89 d0                	mov    %edx,%eax
}
  80231f:	c9                   	leaveq 
  802320:	c3                   	retq   

0000000000802321 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802321:	55                   	push   %rbp
  802322:	48 89 e5             	mov    %rsp,%rbp
  802325:	48 83 ec 18          	sub    $0x18,%rsp
  802329:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80232d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802331:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  802335:	eb 0f                	jmp    802346 <strncmp+0x25>
		n--, p++, q++;
  802337:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80233c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802341:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  802346:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80234b:	74 1d                	je     80236a <strncmp+0x49>
  80234d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802351:	0f b6 00             	movzbl (%rax),%eax
  802354:	84 c0                	test   %al,%al
  802356:	74 12                	je     80236a <strncmp+0x49>
  802358:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80235c:	0f b6 10             	movzbl (%rax),%edx
  80235f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802363:	0f b6 00             	movzbl (%rax),%eax
  802366:	38 c2                	cmp    %al,%dl
  802368:	74 cd                	je     802337 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80236a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80236f:	75 07                	jne    802378 <strncmp+0x57>
		return 0;
  802371:	b8 00 00 00 00       	mov    $0x0,%eax
  802376:	eb 18                	jmp    802390 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802378:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80237c:	0f b6 00             	movzbl (%rax),%eax
  80237f:	0f b6 d0             	movzbl %al,%edx
  802382:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802386:	0f b6 00             	movzbl (%rax),%eax
  802389:	0f b6 c0             	movzbl %al,%eax
  80238c:	29 c2                	sub    %eax,%edx
  80238e:	89 d0                	mov    %edx,%eax
}
  802390:	c9                   	leaveq 
  802391:	c3                   	retq   

0000000000802392 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802392:	55                   	push   %rbp
  802393:	48 89 e5             	mov    %rsp,%rbp
  802396:	48 83 ec 0c          	sub    $0xc,%rsp
  80239a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80239e:	89 f0                	mov    %esi,%eax
  8023a0:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8023a3:	eb 17                	jmp    8023bc <strchr+0x2a>
		if (*s == c)
  8023a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023a9:	0f b6 00             	movzbl (%rax),%eax
  8023ac:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8023af:	75 06                	jne    8023b7 <strchr+0x25>
			return (char *) s;
  8023b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023b5:	eb 15                	jmp    8023cc <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8023b7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8023bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023c0:	0f b6 00             	movzbl (%rax),%eax
  8023c3:	84 c0                	test   %al,%al
  8023c5:	75 de                	jne    8023a5 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8023c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023cc:	c9                   	leaveq 
  8023cd:	c3                   	retq   

00000000008023ce <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8023ce:	55                   	push   %rbp
  8023cf:	48 89 e5             	mov    %rsp,%rbp
  8023d2:	48 83 ec 0c          	sub    $0xc,%rsp
  8023d6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8023da:	89 f0                	mov    %esi,%eax
  8023dc:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8023df:	eb 13                	jmp    8023f4 <strfind+0x26>
		if (*s == c)
  8023e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023e5:	0f b6 00             	movzbl (%rax),%eax
  8023e8:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8023eb:	75 02                	jne    8023ef <strfind+0x21>
			break;
  8023ed:	eb 10                	jmp    8023ff <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8023ef:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8023f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023f8:	0f b6 00             	movzbl (%rax),%eax
  8023fb:	84 c0                	test   %al,%al
  8023fd:	75 e2                	jne    8023e1 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8023ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802403:	c9                   	leaveq 
  802404:	c3                   	retq   

0000000000802405 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802405:	55                   	push   %rbp
  802406:	48 89 e5             	mov    %rsp,%rbp
  802409:	48 83 ec 18          	sub    $0x18,%rsp
  80240d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802411:	89 75 f4             	mov    %esi,-0xc(%rbp)
  802414:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  802418:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80241d:	75 06                	jne    802425 <memset+0x20>
		return v;
  80241f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802423:	eb 69                	jmp    80248e <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  802425:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802429:	83 e0 03             	and    $0x3,%eax
  80242c:	48 85 c0             	test   %rax,%rax
  80242f:	75 48                	jne    802479 <memset+0x74>
  802431:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802435:	83 e0 03             	and    $0x3,%eax
  802438:	48 85 c0             	test   %rax,%rax
  80243b:	75 3c                	jne    802479 <memset+0x74>
		c &= 0xFF;
  80243d:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802444:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802447:	c1 e0 18             	shl    $0x18,%eax
  80244a:	89 c2                	mov    %eax,%edx
  80244c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80244f:	c1 e0 10             	shl    $0x10,%eax
  802452:	09 c2                	or     %eax,%edx
  802454:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802457:	c1 e0 08             	shl    $0x8,%eax
  80245a:	09 d0                	or     %edx,%eax
  80245c:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80245f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802463:	48 c1 e8 02          	shr    $0x2,%rax
  802467:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80246a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80246e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802471:	48 89 d7             	mov    %rdx,%rdi
  802474:	fc                   	cld    
  802475:	f3 ab                	rep stos %eax,%es:(%rdi)
  802477:	eb 11                	jmp    80248a <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802479:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80247d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802480:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802484:	48 89 d7             	mov    %rdx,%rdi
  802487:	fc                   	cld    
  802488:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80248a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80248e:	c9                   	leaveq 
  80248f:	c3                   	retq   

0000000000802490 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802490:	55                   	push   %rbp
  802491:	48 89 e5             	mov    %rsp,%rbp
  802494:	48 83 ec 28          	sub    $0x28,%rsp
  802498:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80249c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8024a0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8024a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024a8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8024ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024b0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8024b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024b8:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8024bc:	0f 83 88 00 00 00    	jae    80254a <memmove+0xba>
  8024c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024c6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8024ca:	48 01 d0             	add    %rdx,%rax
  8024cd:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8024d1:	76 77                	jbe    80254a <memmove+0xba>
		s += n;
  8024d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024d7:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8024db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024df:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8024e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024e7:	83 e0 03             	and    $0x3,%eax
  8024ea:	48 85 c0             	test   %rax,%rax
  8024ed:	75 3b                	jne    80252a <memmove+0x9a>
  8024ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024f3:	83 e0 03             	and    $0x3,%eax
  8024f6:	48 85 c0             	test   %rax,%rax
  8024f9:	75 2f                	jne    80252a <memmove+0x9a>
  8024fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024ff:	83 e0 03             	and    $0x3,%eax
  802502:	48 85 c0             	test   %rax,%rax
  802505:	75 23                	jne    80252a <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  802507:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80250b:	48 83 e8 04          	sub    $0x4,%rax
  80250f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802513:	48 83 ea 04          	sub    $0x4,%rdx
  802517:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80251b:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80251f:	48 89 c7             	mov    %rax,%rdi
  802522:	48 89 d6             	mov    %rdx,%rsi
  802525:	fd                   	std    
  802526:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  802528:	eb 1d                	jmp    802547 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80252a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80252e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802532:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802536:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80253a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80253e:	48 89 d7             	mov    %rdx,%rdi
  802541:	48 89 c1             	mov    %rax,%rcx
  802544:	fd                   	std    
  802545:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  802547:	fc                   	cld    
  802548:	eb 57                	jmp    8025a1 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80254a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80254e:	83 e0 03             	and    $0x3,%eax
  802551:	48 85 c0             	test   %rax,%rax
  802554:	75 36                	jne    80258c <memmove+0xfc>
  802556:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80255a:	83 e0 03             	and    $0x3,%eax
  80255d:	48 85 c0             	test   %rax,%rax
  802560:	75 2a                	jne    80258c <memmove+0xfc>
  802562:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802566:	83 e0 03             	and    $0x3,%eax
  802569:	48 85 c0             	test   %rax,%rax
  80256c:	75 1e                	jne    80258c <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80256e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802572:	48 c1 e8 02          	shr    $0x2,%rax
  802576:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  802579:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80257d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802581:	48 89 c7             	mov    %rax,%rdi
  802584:	48 89 d6             	mov    %rdx,%rsi
  802587:	fc                   	cld    
  802588:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80258a:	eb 15                	jmp    8025a1 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80258c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802590:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802594:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  802598:	48 89 c7             	mov    %rax,%rdi
  80259b:	48 89 d6             	mov    %rdx,%rsi
  80259e:	fc                   	cld    
  80259f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8025a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8025a5:	c9                   	leaveq 
  8025a6:	c3                   	retq   

00000000008025a7 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8025a7:	55                   	push   %rbp
  8025a8:	48 89 e5             	mov    %rsp,%rbp
  8025ab:	48 83 ec 18          	sub    $0x18,%rsp
  8025af:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8025b3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8025b7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8025bb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8025bf:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8025c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025c7:	48 89 ce             	mov    %rcx,%rsi
  8025ca:	48 89 c7             	mov    %rax,%rdi
  8025cd:	48 b8 90 24 80 00 00 	movabs $0x802490,%rax
  8025d4:	00 00 00 
  8025d7:	ff d0                	callq  *%rax
}
  8025d9:	c9                   	leaveq 
  8025da:	c3                   	retq   

00000000008025db <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8025db:	55                   	push   %rbp
  8025dc:	48 89 e5             	mov    %rsp,%rbp
  8025df:	48 83 ec 28          	sub    $0x28,%rsp
  8025e3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8025e7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8025eb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8025ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025f3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8025f7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025fb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8025ff:	eb 36                	jmp    802637 <memcmp+0x5c>
		if (*s1 != *s2)
  802601:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802605:	0f b6 10             	movzbl (%rax),%edx
  802608:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80260c:	0f b6 00             	movzbl (%rax),%eax
  80260f:	38 c2                	cmp    %al,%dl
  802611:	74 1a                	je     80262d <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  802613:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802617:	0f b6 00             	movzbl (%rax),%eax
  80261a:	0f b6 d0             	movzbl %al,%edx
  80261d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802621:	0f b6 00             	movzbl (%rax),%eax
  802624:	0f b6 c0             	movzbl %al,%eax
  802627:	29 c2                	sub    %eax,%edx
  802629:	89 d0                	mov    %edx,%eax
  80262b:	eb 20                	jmp    80264d <memcmp+0x72>
		s1++, s2++;
  80262d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802632:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  802637:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80263b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80263f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  802643:	48 85 c0             	test   %rax,%rax
  802646:	75 b9                	jne    802601 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  802648:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80264d:	c9                   	leaveq 
  80264e:	c3                   	retq   

000000000080264f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80264f:	55                   	push   %rbp
  802650:	48 89 e5             	mov    %rsp,%rbp
  802653:	48 83 ec 28          	sub    $0x28,%rsp
  802657:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80265b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80265e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  802662:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802666:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80266a:	48 01 d0             	add    %rdx,%rax
  80266d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  802671:	eb 15                	jmp    802688 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  802673:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802677:	0f b6 10             	movzbl (%rax),%edx
  80267a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80267d:	38 c2                	cmp    %al,%dl
  80267f:	75 02                	jne    802683 <memfind+0x34>
			break;
  802681:	eb 0f                	jmp    802692 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802683:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802688:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80268c:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  802690:	72 e1                	jb     802673 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  802692:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802696:	c9                   	leaveq 
  802697:	c3                   	retq   

0000000000802698 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802698:	55                   	push   %rbp
  802699:	48 89 e5             	mov    %rsp,%rbp
  80269c:	48 83 ec 34          	sub    $0x34,%rsp
  8026a0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8026a4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8026a8:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8026ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8026b2:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8026b9:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8026ba:	eb 05                	jmp    8026c1 <strtol+0x29>
		s++;
  8026bc:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8026c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026c5:	0f b6 00             	movzbl (%rax),%eax
  8026c8:	3c 20                	cmp    $0x20,%al
  8026ca:	74 f0                	je     8026bc <strtol+0x24>
  8026cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026d0:	0f b6 00             	movzbl (%rax),%eax
  8026d3:	3c 09                	cmp    $0x9,%al
  8026d5:	74 e5                	je     8026bc <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8026d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026db:	0f b6 00             	movzbl (%rax),%eax
  8026de:	3c 2b                	cmp    $0x2b,%al
  8026e0:	75 07                	jne    8026e9 <strtol+0x51>
		s++;
  8026e2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8026e7:	eb 17                	jmp    802700 <strtol+0x68>
	else if (*s == '-')
  8026e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026ed:	0f b6 00             	movzbl (%rax),%eax
  8026f0:	3c 2d                	cmp    $0x2d,%al
  8026f2:	75 0c                	jne    802700 <strtol+0x68>
		s++, neg = 1;
  8026f4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8026f9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802700:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  802704:	74 06                	je     80270c <strtol+0x74>
  802706:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80270a:	75 28                	jne    802734 <strtol+0x9c>
  80270c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802710:	0f b6 00             	movzbl (%rax),%eax
  802713:	3c 30                	cmp    $0x30,%al
  802715:	75 1d                	jne    802734 <strtol+0x9c>
  802717:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80271b:	48 83 c0 01          	add    $0x1,%rax
  80271f:	0f b6 00             	movzbl (%rax),%eax
  802722:	3c 78                	cmp    $0x78,%al
  802724:	75 0e                	jne    802734 <strtol+0x9c>
		s += 2, base = 16;
  802726:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80272b:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  802732:	eb 2c                	jmp    802760 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  802734:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  802738:	75 19                	jne    802753 <strtol+0xbb>
  80273a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80273e:	0f b6 00             	movzbl (%rax),%eax
  802741:	3c 30                	cmp    $0x30,%al
  802743:	75 0e                	jne    802753 <strtol+0xbb>
		s++, base = 8;
  802745:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80274a:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  802751:	eb 0d                	jmp    802760 <strtol+0xc8>
	else if (base == 0)
  802753:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  802757:	75 07                	jne    802760 <strtol+0xc8>
		base = 10;
  802759:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802760:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802764:	0f b6 00             	movzbl (%rax),%eax
  802767:	3c 2f                	cmp    $0x2f,%al
  802769:	7e 1d                	jle    802788 <strtol+0xf0>
  80276b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80276f:	0f b6 00             	movzbl (%rax),%eax
  802772:	3c 39                	cmp    $0x39,%al
  802774:	7f 12                	jg     802788 <strtol+0xf0>
			dig = *s - '0';
  802776:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80277a:	0f b6 00             	movzbl (%rax),%eax
  80277d:	0f be c0             	movsbl %al,%eax
  802780:	83 e8 30             	sub    $0x30,%eax
  802783:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802786:	eb 4e                	jmp    8027d6 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  802788:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80278c:	0f b6 00             	movzbl (%rax),%eax
  80278f:	3c 60                	cmp    $0x60,%al
  802791:	7e 1d                	jle    8027b0 <strtol+0x118>
  802793:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802797:	0f b6 00             	movzbl (%rax),%eax
  80279a:	3c 7a                	cmp    $0x7a,%al
  80279c:	7f 12                	jg     8027b0 <strtol+0x118>
			dig = *s - 'a' + 10;
  80279e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027a2:	0f b6 00             	movzbl (%rax),%eax
  8027a5:	0f be c0             	movsbl %al,%eax
  8027a8:	83 e8 57             	sub    $0x57,%eax
  8027ab:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8027ae:	eb 26                	jmp    8027d6 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8027b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027b4:	0f b6 00             	movzbl (%rax),%eax
  8027b7:	3c 40                	cmp    $0x40,%al
  8027b9:	7e 48                	jle    802803 <strtol+0x16b>
  8027bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027bf:	0f b6 00             	movzbl (%rax),%eax
  8027c2:	3c 5a                	cmp    $0x5a,%al
  8027c4:	7f 3d                	jg     802803 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8027c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027ca:	0f b6 00             	movzbl (%rax),%eax
  8027cd:	0f be c0             	movsbl %al,%eax
  8027d0:	83 e8 37             	sub    $0x37,%eax
  8027d3:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8027d6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027d9:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8027dc:	7c 02                	jl     8027e0 <strtol+0x148>
			break;
  8027de:	eb 23                	jmp    802803 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8027e0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8027e5:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8027e8:	48 98                	cltq   
  8027ea:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8027ef:	48 89 c2             	mov    %rax,%rdx
  8027f2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027f5:	48 98                	cltq   
  8027f7:	48 01 d0             	add    %rdx,%rax
  8027fa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8027fe:	e9 5d ff ff ff       	jmpq   802760 <strtol+0xc8>

	if (endptr)
  802803:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  802808:	74 0b                	je     802815 <strtol+0x17d>
		*endptr = (char *) s;
  80280a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80280e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802812:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  802815:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802819:	74 09                	je     802824 <strtol+0x18c>
  80281b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80281f:	48 f7 d8             	neg    %rax
  802822:	eb 04                	jmp    802828 <strtol+0x190>
  802824:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  802828:	c9                   	leaveq 
  802829:	c3                   	retq   

000000000080282a <strstr>:

char * strstr(const char *in, const char *str)
{
  80282a:	55                   	push   %rbp
  80282b:	48 89 e5             	mov    %rsp,%rbp
  80282e:	48 83 ec 30          	sub    $0x30,%rsp
  802832:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802836:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80283a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80283e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802842:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  802846:	0f b6 00             	movzbl (%rax),%eax
  802849:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80284c:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  802850:	75 06                	jne    802858 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  802852:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802856:	eb 6b                	jmp    8028c3 <strstr+0x99>

	len = strlen(str);
  802858:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80285c:	48 89 c7             	mov    %rax,%rdi
  80285f:	48 b8 00 21 80 00 00 	movabs $0x802100,%rax
  802866:	00 00 00 
  802869:	ff d0                	callq  *%rax
  80286b:	48 98                	cltq   
  80286d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  802871:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802875:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802879:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80287d:	0f b6 00             	movzbl (%rax),%eax
  802880:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  802883:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  802887:	75 07                	jne    802890 <strstr+0x66>
				return (char *) 0;
  802889:	b8 00 00 00 00       	mov    $0x0,%eax
  80288e:	eb 33                	jmp    8028c3 <strstr+0x99>
		} while (sc != c);
  802890:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  802894:	3a 45 ff             	cmp    -0x1(%rbp),%al
  802897:	75 d8                	jne    802871 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  802899:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80289d:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8028a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028a5:	48 89 ce             	mov    %rcx,%rsi
  8028a8:	48 89 c7             	mov    %rax,%rdi
  8028ab:	48 b8 21 23 80 00 00 	movabs $0x802321,%rax
  8028b2:	00 00 00 
  8028b5:	ff d0                	callq  *%rax
  8028b7:	85 c0                	test   %eax,%eax
  8028b9:	75 b6                	jne    802871 <strstr+0x47>

	return (char *) (in - 1);
  8028bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028bf:	48 83 e8 01          	sub    $0x1,%rax
}
  8028c3:	c9                   	leaveq 
  8028c4:	c3                   	retq   

00000000008028c5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8028c5:	55                   	push   %rbp
  8028c6:	48 89 e5             	mov    %rsp,%rbp
  8028c9:	53                   	push   %rbx
  8028ca:	48 83 ec 48          	sub    $0x48,%rsp
  8028ce:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8028d1:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8028d4:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8028d8:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8028dc:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8028e0:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8028e4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8028e7:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8028eb:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8028ef:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8028f3:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8028f7:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8028fb:	4c 89 c3             	mov    %r8,%rbx
  8028fe:	cd 30                	int    $0x30
  802900:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  802904:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802908:	74 3e                	je     802948 <syscall+0x83>
  80290a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80290f:	7e 37                	jle    802948 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  802911:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802915:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802918:	49 89 d0             	mov    %rdx,%r8
  80291b:	89 c1                	mov    %eax,%ecx
  80291d:	48 ba 3b 6f 80 00 00 	movabs $0x806f3b,%rdx
  802924:	00 00 00 
  802927:	be 23 00 00 00       	mov    $0x23,%esi
  80292c:	48 bf 58 6f 80 00 00 	movabs $0x806f58,%rdi
  802933:	00 00 00 
  802936:	b8 00 00 00 00       	mov    $0x0,%eax
  80293b:	49 b9 24 12 80 00 00 	movabs $0x801224,%r9
  802942:	00 00 00 
  802945:	41 ff d1             	callq  *%r9

	return ret;
  802948:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80294c:	48 83 c4 48          	add    $0x48,%rsp
  802950:	5b                   	pop    %rbx
  802951:	5d                   	pop    %rbp
  802952:	c3                   	retq   

0000000000802953 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  802953:	55                   	push   %rbp
  802954:	48 89 e5             	mov    %rsp,%rbp
  802957:	48 83 ec 20          	sub    $0x20,%rsp
  80295b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80295f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  802963:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802967:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80296b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802972:	00 
  802973:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802979:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80297f:	48 89 d1             	mov    %rdx,%rcx
  802982:	48 89 c2             	mov    %rax,%rdx
  802985:	be 00 00 00 00       	mov    $0x0,%esi
  80298a:	bf 00 00 00 00       	mov    $0x0,%edi
  80298f:	48 b8 c5 28 80 00 00 	movabs $0x8028c5,%rax
  802996:	00 00 00 
  802999:	ff d0                	callq  *%rax
}
  80299b:	c9                   	leaveq 
  80299c:	c3                   	retq   

000000000080299d <sys_cgetc>:

int
sys_cgetc(void)
{
  80299d:	55                   	push   %rbp
  80299e:	48 89 e5             	mov    %rsp,%rbp
  8029a1:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8029a5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8029ac:	00 
  8029ad:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8029b3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8029b9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8029be:	ba 00 00 00 00       	mov    $0x0,%edx
  8029c3:	be 00 00 00 00       	mov    $0x0,%esi
  8029c8:	bf 01 00 00 00       	mov    $0x1,%edi
  8029cd:	48 b8 c5 28 80 00 00 	movabs $0x8028c5,%rax
  8029d4:	00 00 00 
  8029d7:	ff d0                	callq  *%rax
}
  8029d9:	c9                   	leaveq 
  8029da:	c3                   	retq   

00000000008029db <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8029db:	55                   	push   %rbp
  8029dc:	48 89 e5             	mov    %rsp,%rbp
  8029df:	48 83 ec 10          	sub    $0x10,%rsp
  8029e3:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8029e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029e9:	48 98                	cltq   
  8029eb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8029f2:	00 
  8029f3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8029f9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8029ff:	b9 00 00 00 00       	mov    $0x0,%ecx
  802a04:	48 89 c2             	mov    %rax,%rdx
  802a07:	be 01 00 00 00       	mov    $0x1,%esi
  802a0c:	bf 03 00 00 00       	mov    $0x3,%edi
  802a11:	48 b8 c5 28 80 00 00 	movabs $0x8028c5,%rax
  802a18:	00 00 00 
  802a1b:	ff d0                	callq  *%rax
}
  802a1d:	c9                   	leaveq 
  802a1e:	c3                   	retq   

0000000000802a1f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  802a1f:	55                   	push   %rbp
  802a20:	48 89 e5             	mov    %rsp,%rbp
  802a23:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  802a27:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802a2e:	00 
  802a2f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802a35:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802a3b:	b9 00 00 00 00       	mov    $0x0,%ecx
  802a40:	ba 00 00 00 00       	mov    $0x0,%edx
  802a45:	be 00 00 00 00       	mov    $0x0,%esi
  802a4a:	bf 02 00 00 00       	mov    $0x2,%edi
  802a4f:	48 b8 c5 28 80 00 00 	movabs $0x8028c5,%rax
  802a56:	00 00 00 
  802a59:	ff d0                	callq  *%rax
}
  802a5b:	c9                   	leaveq 
  802a5c:	c3                   	retq   

0000000000802a5d <sys_yield>:

void
sys_yield(void)
{
  802a5d:	55                   	push   %rbp
  802a5e:	48 89 e5             	mov    %rsp,%rbp
  802a61:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  802a65:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802a6c:	00 
  802a6d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802a73:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802a79:	b9 00 00 00 00       	mov    $0x0,%ecx
  802a7e:	ba 00 00 00 00       	mov    $0x0,%edx
  802a83:	be 00 00 00 00       	mov    $0x0,%esi
  802a88:	bf 0b 00 00 00       	mov    $0xb,%edi
  802a8d:	48 b8 c5 28 80 00 00 	movabs $0x8028c5,%rax
  802a94:	00 00 00 
  802a97:	ff d0                	callq  *%rax
}
  802a99:	c9                   	leaveq 
  802a9a:	c3                   	retq   

0000000000802a9b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802a9b:	55                   	push   %rbp
  802a9c:	48 89 e5             	mov    %rsp,%rbp
  802a9f:	48 83 ec 20          	sub    $0x20,%rsp
  802aa3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802aa6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802aaa:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  802aad:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ab0:	48 63 c8             	movslq %eax,%rcx
  802ab3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ab7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aba:	48 98                	cltq   
  802abc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802ac3:	00 
  802ac4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802aca:	49 89 c8             	mov    %rcx,%r8
  802acd:	48 89 d1             	mov    %rdx,%rcx
  802ad0:	48 89 c2             	mov    %rax,%rdx
  802ad3:	be 01 00 00 00       	mov    $0x1,%esi
  802ad8:	bf 04 00 00 00       	mov    $0x4,%edi
  802add:	48 b8 c5 28 80 00 00 	movabs $0x8028c5,%rax
  802ae4:	00 00 00 
  802ae7:	ff d0                	callq  *%rax
}
  802ae9:	c9                   	leaveq 
  802aea:	c3                   	retq   

0000000000802aeb <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802aeb:	55                   	push   %rbp
  802aec:	48 89 e5             	mov    %rsp,%rbp
  802aef:	48 83 ec 30          	sub    $0x30,%rsp
  802af3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802af6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802afa:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802afd:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802b01:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  802b05:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802b08:	48 63 c8             	movslq %eax,%rcx
  802b0b:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802b0f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b12:	48 63 f0             	movslq %eax,%rsi
  802b15:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b19:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b1c:	48 98                	cltq   
  802b1e:	48 89 0c 24          	mov    %rcx,(%rsp)
  802b22:	49 89 f9             	mov    %rdi,%r9
  802b25:	49 89 f0             	mov    %rsi,%r8
  802b28:	48 89 d1             	mov    %rdx,%rcx
  802b2b:	48 89 c2             	mov    %rax,%rdx
  802b2e:	be 01 00 00 00       	mov    $0x1,%esi
  802b33:	bf 05 00 00 00       	mov    $0x5,%edi
  802b38:	48 b8 c5 28 80 00 00 	movabs $0x8028c5,%rax
  802b3f:	00 00 00 
  802b42:	ff d0                	callq  *%rax
}
  802b44:	c9                   	leaveq 
  802b45:	c3                   	retq   

0000000000802b46 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  802b46:	55                   	push   %rbp
  802b47:	48 89 e5             	mov    %rsp,%rbp
  802b4a:	48 83 ec 20          	sub    $0x20,%rsp
  802b4e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802b51:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  802b55:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b5c:	48 98                	cltq   
  802b5e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802b65:	00 
  802b66:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802b6c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802b72:	48 89 d1             	mov    %rdx,%rcx
  802b75:	48 89 c2             	mov    %rax,%rdx
  802b78:	be 01 00 00 00       	mov    $0x1,%esi
  802b7d:	bf 06 00 00 00       	mov    $0x6,%edi
  802b82:	48 b8 c5 28 80 00 00 	movabs $0x8028c5,%rax
  802b89:	00 00 00 
  802b8c:	ff d0                	callq  *%rax
}
  802b8e:	c9                   	leaveq 
  802b8f:	c3                   	retq   

0000000000802b90 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  802b90:	55                   	push   %rbp
  802b91:	48 89 e5             	mov    %rsp,%rbp
  802b94:	48 83 ec 10          	sub    $0x10,%rsp
  802b98:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802b9b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  802b9e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ba1:	48 63 d0             	movslq %eax,%rdx
  802ba4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ba7:	48 98                	cltq   
  802ba9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802bb0:	00 
  802bb1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802bb7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802bbd:	48 89 d1             	mov    %rdx,%rcx
  802bc0:	48 89 c2             	mov    %rax,%rdx
  802bc3:	be 01 00 00 00       	mov    $0x1,%esi
  802bc8:	bf 08 00 00 00       	mov    $0x8,%edi
  802bcd:	48 b8 c5 28 80 00 00 	movabs $0x8028c5,%rax
  802bd4:	00 00 00 
  802bd7:	ff d0                	callq  *%rax
}
  802bd9:	c9                   	leaveq 
  802bda:	c3                   	retq   

0000000000802bdb <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802bdb:	55                   	push   %rbp
  802bdc:	48 89 e5             	mov    %rsp,%rbp
  802bdf:	48 83 ec 20          	sub    $0x20,%rsp
  802be3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802be6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  802bea:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802bee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bf1:	48 98                	cltq   
  802bf3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802bfa:	00 
  802bfb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802c01:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802c07:	48 89 d1             	mov    %rdx,%rcx
  802c0a:	48 89 c2             	mov    %rax,%rdx
  802c0d:	be 01 00 00 00       	mov    $0x1,%esi
  802c12:	bf 09 00 00 00       	mov    $0x9,%edi
  802c17:	48 b8 c5 28 80 00 00 	movabs $0x8028c5,%rax
  802c1e:	00 00 00 
  802c21:	ff d0                	callq  *%rax
}
  802c23:	c9                   	leaveq 
  802c24:	c3                   	retq   

0000000000802c25 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802c25:	55                   	push   %rbp
  802c26:	48 89 e5             	mov    %rsp,%rbp
  802c29:	48 83 ec 20          	sub    $0x20,%rsp
  802c2d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802c30:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  802c34:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c38:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c3b:	48 98                	cltq   
  802c3d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802c44:	00 
  802c45:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802c4b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802c51:	48 89 d1             	mov    %rdx,%rcx
  802c54:	48 89 c2             	mov    %rax,%rdx
  802c57:	be 01 00 00 00       	mov    $0x1,%esi
  802c5c:	bf 0a 00 00 00       	mov    $0xa,%edi
  802c61:	48 b8 c5 28 80 00 00 	movabs $0x8028c5,%rax
  802c68:	00 00 00 
  802c6b:	ff d0                	callq  *%rax
}
  802c6d:	c9                   	leaveq 
  802c6e:	c3                   	retq   

0000000000802c6f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  802c6f:	55                   	push   %rbp
  802c70:	48 89 e5             	mov    %rsp,%rbp
  802c73:	48 83 ec 20          	sub    $0x20,%rsp
  802c77:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802c7a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802c7e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802c82:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  802c85:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c88:	48 63 f0             	movslq %eax,%rsi
  802c8b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802c8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c92:	48 98                	cltq   
  802c94:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c98:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802c9f:	00 
  802ca0:	49 89 f1             	mov    %rsi,%r9
  802ca3:	49 89 c8             	mov    %rcx,%r8
  802ca6:	48 89 d1             	mov    %rdx,%rcx
  802ca9:	48 89 c2             	mov    %rax,%rdx
  802cac:	be 00 00 00 00       	mov    $0x0,%esi
  802cb1:	bf 0c 00 00 00       	mov    $0xc,%edi
  802cb6:	48 b8 c5 28 80 00 00 	movabs $0x8028c5,%rax
  802cbd:	00 00 00 
  802cc0:	ff d0                	callq  *%rax
}
  802cc2:	c9                   	leaveq 
  802cc3:	c3                   	retq   

0000000000802cc4 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802cc4:	55                   	push   %rbp
  802cc5:	48 89 e5             	mov    %rsp,%rbp
  802cc8:	48 83 ec 10          	sub    $0x10,%rsp
  802ccc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  802cd0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cd4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802cdb:	00 
  802cdc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802ce2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802ce8:	b9 00 00 00 00       	mov    $0x0,%ecx
  802ced:	48 89 c2             	mov    %rax,%rdx
  802cf0:	be 01 00 00 00       	mov    $0x1,%esi
  802cf5:	bf 0d 00 00 00       	mov    $0xd,%edi
  802cfa:	48 b8 c5 28 80 00 00 	movabs $0x8028c5,%rax
  802d01:	00 00 00 
  802d04:	ff d0                	callq  *%rax
}
  802d06:	c9                   	leaveq 
  802d07:	c3                   	retq   

0000000000802d08 <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  802d08:	55                   	push   %rbp
  802d09:	48 89 e5             	mov    %rsp,%rbp
  802d0c:	48 83 ec 20          	sub    $0x20,%rsp
  802d10:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802d14:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, (uint64_t)buf, len, 0, 0, 0, 0);
  802d18:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d1c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d20:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802d27:	00 
  802d28:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802d2e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802d34:	b9 00 00 00 00       	mov    $0x0,%ecx
  802d39:	89 c6                	mov    %eax,%esi
  802d3b:	bf 0f 00 00 00       	mov    $0xf,%edi
  802d40:	48 b8 c5 28 80 00 00 	movabs $0x8028c5,%rax
  802d47:	00 00 00 
  802d4a:	ff d0                	callq  *%rax
}
  802d4c:	c9                   	leaveq 
  802d4d:	c3                   	retq   

0000000000802d4e <sys_net_rx>:

int
sys_net_rx(void *buf, size_t len)
{
  802d4e:	55                   	push   %rbp
  802d4f:	48 89 e5             	mov    %rsp,%rbp
  802d52:	48 83 ec 20          	sub    $0x20,%rsp
  802d56:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802d5a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_rx, (uint64_t)buf, len, 0, 0, 0, 0);
  802d5e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d62:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d66:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802d6d:	00 
  802d6e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802d74:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802d7a:	b9 00 00 00 00       	mov    $0x0,%ecx
  802d7f:	89 c6                	mov    %eax,%esi
  802d81:	bf 10 00 00 00       	mov    $0x10,%edi
  802d86:	48 b8 c5 28 80 00 00 	movabs $0x8028c5,%rax
  802d8d:	00 00 00 
  802d90:	ff d0                	callq  *%rax
}
  802d92:	c9                   	leaveq 
  802d93:	c3                   	retq   

0000000000802d94 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  802d94:	55                   	push   %rbp
  802d95:	48 89 e5             	mov    %rsp,%rbp
  802d98:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  802d9c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802da3:	00 
  802da4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802daa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802db0:	b9 00 00 00 00       	mov    $0x0,%ecx
  802db5:	ba 00 00 00 00       	mov    $0x0,%edx
  802dba:	be 00 00 00 00       	mov    $0x0,%esi
  802dbf:	bf 0e 00 00 00       	mov    $0xe,%edi
  802dc4:	48 b8 c5 28 80 00 00 	movabs $0x8028c5,%rax
  802dcb:	00 00 00 
  802dce:	ff d0                	callq  *%rax
}
  802dd0:	c9                   	leaveq 
  802dd1:	c3                   	retq   

0000000000802dd2 <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  802dd2:	55                   	push   %rbp
  802dd3:	48 89 e5             	mov    %rsp,%rbp
  802dd6:	48 83 ec 30          	sub    $0x30,%rsp
  802dda:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  802dde:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802de2:	48 8b 00             	mov    (%rax),%rax
  802de5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  802de9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ded:	48 8b 40 08          	mov    0x8(%rax),%rax
  802df1:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  802df4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802df7:	83 e0 02             	and    $0x2,%eax
  802dfa:	85 c0                	test   %eax,%eax
  802dfc:	75 4d                	jne    802e4b <pgfault+0x79>
  802dfe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e02:	48 c1 e8 0c          	shr    $0xc,%rax
  802e06:	48 89 c2             	mov    %rax,%rdx
  802e09:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802e10:	01 00 00 
  802e13:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e17:	25 00 08 00 00       	and    $0x800,%eax
  802e1c:	48 85 c0             	test   %rax,%rax
  802e1f:	74 2a                	je     802e4b <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  802e21:	48 ba 68 6f 80 00 00 	movabs $0x806f68,%rdx
  802e28:	00 00 00 
  802e2b:	be 23 00 00 00       	mov    $0x23,%esi
  802e30:	48 bf 9d 6f 80 00 00 	movabs $0x806f9d,%rdi
  802e37:	00 00 00 
  802e3a:	b8 00 00 00 00       	mov    $0x0,%eax
  802e3f:	48 b9 24 12 80 00 00 	movabs $0x801224,%rcx
  802e46:	00 00 00 
  802e49:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  802e4b:	ba 07 00 00 00       	mov    $0x7,%edx
  802e50:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802e55:	bf 00 00 00 00       	mov    $0x0,%edi
  802e5a:	48 b8 9b 2a 80 00 00 	movabs $0x802a9b,%rax
  802e61:	00 00 00 
  802e64:	ff d0                	callq  *%rax
  802e66:	85 c0                	test   %eax,%eax
  802e68:	0f 85 cd 00 00 00    	jne    802f3b <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  802e6e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e72:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802e76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e7a:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802e80:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  802e84:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e88:	ba 00 10 00 00       	mov    $0x1000,%edx
  802e8d:	48 89 c6             	mov    %rax,%rsi
  802e90:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802e95:	48 b8 90 24 80 00 00 	movabs $0x802490,%rax
  802e9c:	00 00 00 
  802e9f:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  802ea1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ea5:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802eab:	48 89 c1             	mov    %rax,%rcx
  802eae:	ba 00 00 00 00       	mov    $0x0,%edx
  802eb3:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802eb8:	bf 00 00 00 00       	mov    $0x0,%edi
  802ebd:	48 b8 eb 2a 80 00 00 	movabs $0x802aeb,%rax
  802ec4:	00 00 00 
  802ec7:	ff d0                	callq  *%rax
  802ec9:	85 c0                	test   %eax,%eax
  802ecb:	79 2a                	jns    802ef7 <pgfault+0x125>
				panic("Page map at temp address failed");
  802ecd:	48 ba a8 6f 80 00 00 	movabs $0x806fa8,%rdx
  802ed4:	00 00 00 
  802ed7:	be 30 00 00 00       	mov    $0x30,%esi
  802edc:	48 bf 9d 6f 80 00 00 	movabs $0x806f9d,%rdi
  802ee3:	00 00 00 
  802ee6:	b8 00 00 00 00       	mov    $0x0,%eax
  802eeb:	48 b9 24 12 80 00 00 	movabs $0x801224,%rcx
  802ef2:	00 00 00 
  802ef5:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  802ef7:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802efc:	bf 00 00 00 00       	mov    $0x0,%edi
  802f01:	48 b8 46 2b 80 00 00 	movabs $0x802b46,%rax
  802f08:	00 00 00 
  802f0b:	ff d0                	callq  *%rax
  802f0d:	85 c0                	test   %eax,%eax
  802f0f:	79 54                	jns    802f65 <pgfault+0x193>
				panic("Page unmap from temp location failed");
  802f11:	48 ba c8 6f 80 00 00 	movabs $0x806fc8,%rdx
  802f18:	00 00 00 
  802f1b:	be 32 00 00 00       	mov    $0x32,%esi
  802f20:	48 bf 9d 6f 80 00 00 	movabs $0x806f9d,%rdi
  802f27:	00 00 00 
  802f2a:	b8 00 00 00 00       	mov    $0x0,%eax
  802f2f:	48 b9 24 12 80 00 00 	movabs $0x801224,%rcx
  802f36:	00 00 00 
  802f39:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  802f3b:	48 ba f0 6f 80 00 00 	movabs $0x806ff0,%rdx
  802f42:	00 00 00 
  802f45:	be 34 00 00 00       	mov    $0x34,%esi
  802f4a:	48 bf 9d 6f 80 00 00 	movabs $0x806f9d,%rdi
  802f51:	00 00 00 
  802f54:	b8 00 00 00 00       	mov    $0x0,%eax
  802f59:	48 b9 24 12 80 00 00 	movabs $0x801224,%rcx
  802f60:	00 00 00 
  802f63:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  802f65:	c9                   	leaveq 
  802f66:	c3                   	retq   

0000000000802f67 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  802f67:	55                   	push   %rbp
  802f68:	48 89 e5             	mov    %rsp,%rbp
  802f6b:	48 83 ec 20          	sub    $0x20,%rsp
  802f6f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f72:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  802f75:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802f7c:	01 00 00 
  802f7f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f82:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802f86:	25 07 0e 00 00       	and    $0xe07,%eax
  802f8b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  802f8e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802f91:	48 c1 e0 0c          	shl    $0xc,%rax
  802f95:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  802f99:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f9c:	25 00 04 00 00       	and    $0x400,%eax
  802fa1:	85 c0                	test   %eax,%eax
  802fa3:	74 57                	je     802ffc <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  802fa5:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802fa8:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802fac:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802faf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fb3:	41 89 f0             	mov    %esi,%r8d
  802fb6:	48 89 c6             	mov    %rax,%rsi
  802fb9:	bf 00 00 00 00       	mov    $0x0,%edi
  802fbe:	48 b8 eb 2a 80 00 00 	movabs $0x802aeb,%rax
  802fc5:	00 00 00 
  802fc8:	ff d0                	callq  *%rax
  802fca:	85 c0                	test   %eax,%eax
  802fcc:	0f 8e 52 01 00 00    	jle    803124 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  802fd2:	48 ba 22 70 80 00 00 	movabs $0x807022,%rdx
  802fd9:	00 00 00 
  802fdc:	be 4e 00 00 00       	mov    $0x4e,%esi
  802fe1:	48 bf 9d 6f 80 00 00 	movabs $0x806f9d,%rdi
  802fe8:	00 00 00 
  802feb:	b8 00 00 00 00       	mov    $0x0,%eax
  802ff0:	48 b9 24 12 80 00 00 	movabs $0x801224,%rcx
  802ff7:	00 00 00 
  802ffa:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  802ffc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fff:	83 e0 02             	and    $0x2,%eax
  803002:	85 c0                	test   %eax,%eax
  803004:	75 10                	jne    803016 <duppage+0xaf>
  803006:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803009:	25 00 08 00 00       	and    $0x800,%eax
  80300e:	85 c0                	test   %eax,%eax
  803010:	0f 84 bb 00 00 00    	je     8030d1 <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  803016:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803019:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  80301e:	80 cc 08             	or     $0x8,%ah
  803021:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  803024:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803027:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80302b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80302e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803032:	41 89 f0             	mov    %esi,%r8d
  803035:	48 89 c6             	mov    %rax,%rsi
  803038:	bf 00 00 00 00       	mov    $0x0,%edi
  80303d:	48 b8 eb 2a 80 00 00 	movabs $0x802aeb,%rax
  803044:	00 00 00 
  803047:	ff d0                	callq  *%rax
  803049:	85 c0                	test   %eax,%eax
  80304b:	7e 2a                	jle    803077 <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  80304d:	48 ba 22 70 80 00 00 	movabs $0x807022,%rdx
  803054:	00 00 00 
  803057:	be 55 00 00 00       	mov    $0x55,%esi
  80305c:	48 bf 9d 6f 80 00 00 	movabs $0x806f9d,%rdi
  803063:	00 00 00 
  803066:	b8 00 00 00 00       	mov    $0x0,%eax
  80306b:	48 b9 24 12 80 00 00 	movabs $0x801224,%rcx
  803072:	00 00 00 
  803075:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  803077:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  80307a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80307e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803082:	41 89 c8             	mov    %ecx,%r8d
  803085:	48 89 d1             	mov    %rdx,%rcx
  803088:	ba 00 00 00 00       	mov    $0x0,%edx
  80308d:	48 89 c6             	mov    %rax,%rsi
  803090:	bf 00 00 00 00       	mov    $0x0,%edi
  803095:	48 b8 eb 2a 80 00 00 	movabs $0x802aeb,%rax
  80309c:	00 00 00 
  80309f:	ff d0                	callq  *%rax
  8030a1:	85 c0                	test   %eax,%eax
  8030a3:	7e 2a                	jle    8030cf <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  8030a5:	48 ba 22 70 80 00 00 	movabs $0x807022,%rdx
  8030ac:	00 00 00 
  8030af:	be 57 00 00 00       	mov    $0x57,%esi
  8030b4:	48 bf 9d 6f 80 00 00 	movabs $0x806f9d,%rdi
  8030bb:	00 00 00 
  8030be:	b8 00 00 00 00       	mov    $0x0,%eax
  8030c3:	48 b9 24 12 80 00 00 	movabs $0x801224,%rcx
  8030ca:	00 00 00 
  8030cd:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  8030cf:	eb 53                	jmp    803124 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  8030d1:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8030d4:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8030d8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8030db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030df:	41 89 f0             	mov    %esi,%r8d
  8030e2:	48 89 c6             	mov    %rax,%rsi
  8030e5:	bf 00 00 00 00       	mov    $0x0,%edi
  8030ea:	48 b8 eb 2a 80 00 00 	movabs $0x802aeb,%rax
  8030f1:	00 00 00 
  8030f4:	ff d0                	callq  *%rax
  8030f6:	85 c0                	test   %eax,%eax
  8030f8:	7e 2a                	jle    803124 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  8030fa:	48 ba 22 70 80 00 00 	movabs $0x807022,%rdx
  803101:	00 00 00 
  803104:	be 5b 00 00 00       	mov    $0x5b,%esi
  803109:	48 bf 9d 6f 80 00 00 	movabs $0x806f9d,%rdi
  803110:	00 00 00 
  803113:	b8 00 00 00 00       	mov    $0x0,%eax
  803118:	48 b9 24 12 80 00 00 	movabs $0x801224,%rcx
  80311f:	00 00 00 
  803122:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  803124:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803129:	c9                   	leaveq 
  80312a:	c3                   	retq   

000000000080312b <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  80312b:	55                   	push   %rbp
  80312c:	48 89 e5             	mov    %rsp,%rbp
  80312f:	48 83 ec 18          	sub    $0x18,%rsp
  803133:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  803137:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80313b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  80313f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803143:	48 c1 e8 27          	shr    $0x27,%rax
  803147:	48 89 c2             	mov    %rax,%rdx
  80314a:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  803151:	01 00 00 
  803154:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803158:	83 e0 01             	and    $0x1,%eax
  80315b:	48 85 c0             	test   %rax,%rax
  80315e:	74 51                	je     8031b1 <pt_is_mapped+0x86>
  803160:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803164:	48 c1 e0 0c          	shl    $0xc,%rax
  803168:	48 c1 e8 1e          	shr    $0x1e,%rax
  80316c:	48 89 c2             	mov    %rax,%rdx
  80316f:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  803176:	01 00 00 
  803179:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80317d:	83 e0 01             	and    $0x1,%eax
  803180:	48 85 c0             	test   %rax,%rax
  803183:	74 2c                	je     8031b1 <pt_is_mapped+0x86>
  803185:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803189:	48 c1 e0 0c          	shl    $0xc,%rax
  80318d:	48 c1 e8 15          	shr    $0x15,%rax
  803191:	48 89 c2             	mov    %rax,%rdx
  803194:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80319b:	01 00 00 
  80319e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8031a2:	83 e0 01             	and    $0x1,%eax
  8031a5:	48 85 c0             	test   %rax,%rax
  8031a8:	74 07                	je     8031b1 <pt_is_mapped+0x86>
  8031aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8031af:	eb 05                	jmp    8031b6 <pt_is_mapped+0x8b>
  8031b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8031b6:	83 e0 01             	and    $0x1,%eax
}
  8031b9:	c9                   	leaveq 
  8031ba:	c3                   	retq   

00000000008031bb <fork>:

envid_t
fork(void)
{
  8031bb:	55                   	push   %rbp
  8031bc:	48 89 e5             	mov    %rsp,%rbp
  8031bf:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  8031c3:	48 bf d2 2d 80 00 00 	movabs $0x802dd2,%rdi
  8031ca:	00 00 00 
  8031cd:	48 b8 1f 64 80 00 00 	movabs $0x80641f,%rax
  8031d4:	00 00 00 
  8031d7:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8031d9:	b8 07 00 00 00       	mov    $0x7,%eax
  8031de:	cd 30                	int    $0x30
  8031e0:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8031e3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  8031e6:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  8031e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8031ed:	79 30                	jns    80321f <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  8031ef:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8031f2:	89 c1                	mov    %eax,%ecx
  8031f4:	48 ba 40 70 80 00 00 	movabs $0x807040,%rdx
  8031fb:	00 00 00 
  8031fe:	be 86 00 00 00       	mov    $0x86,%esi
  803203:	48 bf 9d 6f 80 00 00 	movabs $0x806f9d,%rdi
  80320a:	00 00 00 
  80320d:	b8 00 00 00 00       	mov    $0x0,%eax
  803212:	49 b8 24 12 80 00 00 	movabs $0x801224,%r8
  803219:	00 00 00 
  80321c:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  80321f:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803223:	75 46                	jne    80326b <fork+0xb0>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  803225:	48 b8 1f 2a 80 00 00 	movabs $0x802a1f,%rax
  80322c:	00 00 00 
  80322f:	ff d0                	callq  *%rax
  803231:	25 ff 03 00 00       	and    $0x3ff,%eax
  803236:	48 63 d0             	movslq %eax,%rdx
  803239:	48 89 d0             	mov    %rdx,%rax
  80323c:	48 c1 e0 03          	shl    $0x3,%rax
  803240:	48 01 d0             	add    %rdx,%rax
  803243:	48 c1 e0 05          	shl    $0x5,%rax
  803247:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80324e:	00 00 00 
  803251:	48 01 c2             	add    %rax,%rdx
  803254:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  80325b:	00 00 00 
  80325e:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  803261:	b8 00 00 00 00       	mov    $0x0,%eax
  803266:	e9 d1 01 00 00       	jmpq   80343c <fork+0x281>
	}
	uint64_t ad = 0;
  80326b:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  803272:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  803273:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  803278:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80327c:	e9 df 00 00 00       	jmpq   803360 <fork+0x1a5>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  803281:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803285:	48 c1 e8 27          	shr    $0x27,%rax
  803289:	48 89 c2             	mov    %rax,%rdx
  80328c:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  803293:	01 00 00 
  803296:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80329a:	83 e0 01             	and    $0x1,%eax
  80329d:	48 85 c0             	test   %rax,%rax
  8032a0:	0f 84 9e 00 00 00    	je     803344 <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  8032a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032aa:	48 c1 e8 1e          	shr    $0x1e,%rax
  8032ae:	48 89 c2             	mov    %rax,%rdx
  8032b1:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8032b8:	01 00 00 
  8032bb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8032bf:	83 e0 01             	and    $0x1,%eax
  8032c2:	48 85 c0             	test   %rax,%rax
  8032c5:	74 73                	je     80333a <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  8032c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032cb:	48 c1 e8 15          	shr    $0x15,%rax
  8032cf:	48 89 c2             	mov    %rax,%rdx
  8032d2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8032d9:	01 00 00 
  8032dc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8032e0:	83 e0 01             	and    $0x1,%eax
  8032e3:	48 85 c0             	test   %rax,%rax
  8032e6:	74 48                	je     803330 <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  8032e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032ec:	48 c1 e8 0c          	shr    $0xc,%rax
  8032f0:	48 89 c2             	mov    %rax,%rdx
  8032f3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8032fa:	01 00 00 
  8032fd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803301:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803305:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803309:	83 e0 01             	and    $0x1,%eax
  80330c:	48 85 c0             	test   %rax,%rax
  80330f:	74 47                	je     803358 <fork+0x19d>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  803311:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803315:	48 c1 e8 0c          	shr    $0xc,%rax
  803319:	89 c2                	mov    %eax,%edx
  80331b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80331e:	89 d6                	mov    %edx,%esi
  803320:	89 c7                	mov    %eax,%edi
  803322:	48 b8 67 2f 80 00 00 	movabs $0x802f67,%rax
  803329:	00 00 00 
  80332c:	ff d0                	callq  *%rax
  80332e:	eb 28                	jmp    803358 <fork+0x19d>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  803330:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  803337:	00 
  803338:	eb 1e                	jmp    803358 <fork+0x19d>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  80333a:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  803341:	40 
  803342:	eb 14                	jmp    803358 <fork+0x19d>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  803344:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803348:	48 c1 e8 27          	shr    $0x27,%rax
  80334c:	48 83 c0 01          	add    $0x1,%rax
  803350:	48 c1 e0 27          	shl    $0x27,%rax
  803354:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  803358:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  80335f:	00 
  803360:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  803367:	00 
  803368:	0f 87 13 ff ff ff    	ja     803281 <fork+0xc6>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  80336e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803371:	ba 07 00 00 00       	mov    $0x7,%edx
  803376:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80337b:	89 c7                	mov    %eax,%edi
  80337d:	48 b8 9b 2a 80 00 00 	movabs $0x802a9b,%rax
  803384:	00 00 00 
  803387:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  803389:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80338c:	ba 07 00 00 00       	mov    $0x7,%edx
  803391:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  803396:	89 c7                	mov    %eax,%edi
  803398:	48 b8 9b 2a 80 00 00 	movabs $0x802a9b,%rax
  80339f:	00 00 00 
  8033a2:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  8033a4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8033a7:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8033ad:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  8033b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8033b7:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8033bc:	89 c7                	mov    %eax,%edi
  8033be:	48 b8 eb 2a 80 00 00 	movabs $0x802aeb,%rax
  8033c5:	00 00 00 
  8033c8:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  8033ca:	ba 00 10 00 00       	mov    $0x1000,%edx
  8033cf:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8033d4:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  8033d9:	48 b8 90 24 80 00 00 	movabs $0x802490,%rax
  8033e0:	00 00 00 
  8033e3:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  8033e5:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8033ea:	bf 00 00 00 00       	mov    $0x0,%edi
  8033ef:	48 b8 46 2b 80 00 00 	movabs $0x802b46,%rax
  8033f6:	00 00 00 
  8033f9:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  8033fb:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  803402:	00 00 00 
  803405:	48 8b 00             	mov    (%rax),%rax
  803408:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  80340f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803412:	48 89 d6             	mov    %rdx,%rsi
  803415:	89 c7                	mov    %eax,%edi
  803417:	48 b8 25 2c 80 00 00 	movabs $0x802c25,%rax
  80341e:	00 00 00 
  803421:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  803423:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803426:	be 02 00 00 00       	mov    $0x2,%esi
  80342b:	89 c7                	mov    %eax,%edi
  80342d:	48 b8 90 2b 80 00 00 	movabs $0x802b90,%rax
  803434:	00 00 00 
  803437:	ff d0                	callq  *%rax

	return envid;
  803439:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  80343c:	c9                   	leaveq 
  80343d:	c3                   	retq   

000000000080343e <sfork>:

	
// Challenge!
int
sfork(void)
{
  80343e:	55                   	push   %rbp
  80343f:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  803442:	48 ba 58 70 80 00 00 	movabs $0x807058,%rdx
  803449:	00 00 00 
  80344c:	be bf 00 00 00       	mov    $0xbf,%esi
  803451:	48 bf 9d 6f 80 00 00 	movabs $0x806f9d,%rdi
  803458:	00 00 00 
  80345b:	b8 00 00 00 00       	mov    $0x0,%eax
  803460:	48 b9 24 12 80 00 00 	movabs $0x801224,%rcx
  803467:	00 00 00 
  80346a:	ff d1                	callq  *%rcx

000000000080346c <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  80346c:	55                   	push   %rbp
  80346d:	48 89 e5             	mov    %rsp,%rbp
  803470:	48 83 ec 18          	sub    $0x18,%rsp
  803474:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803478:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80347c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	args->argc = argc;
  803480:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803484:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803488:	48 89 10             	mov    %rdx,(%rax)
	args->argv = (const char **) argv;
  80348b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80348f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803493:	48 89 50 08          	mov    %rdx,0x8(%rax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  803497:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80349b:	8b 00                	mov    (%rax),%eax
  80349d:	83 f8 01             	cmp    $0x1,%eax
  8034a0:	7e 13                	jle    8034b5 <argstart+0x49>
  8034a2:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  8034a7:	74 0c                	je     8034b5 <argstart+0x49>
  8034a9:	48 b8 6e 70 80 00 00 	movabs $0x80706e,%rax
  8034b0:	00 00 00 
  8034b3:	eb 05                	jmp    8034ba <argstart+0x4e>
  8034b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8034ba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8034be:	48 89 42 10          	mov    %rax,0x10(%rdx)
	args->argvalue = 0;
  8034c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034c6:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  8034cd:	00 
}
  8034ce:	c9                   	leaveq 
  8034cf:	c3                   	retq   

00000000008034d0 <argnext>:

int
argnext(struct Argstate *args)
{
  8034d0:	55                   	push   %rbp
  8034d1:	48 89 e5             	mov    %rsp,%rbp
  8034d4:	48 83 ec 20          	sub    $0x20,%rsp
  8034d8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int arg;

	args->argvalue = 0;
  8034dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034e0:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  8034e7:	00 

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  8034e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034ec:	48 8b 40 10          	mov    0x10(%rax),%rax
  8034f0:	48 85 c0             	test   %rax,%rax
  8034f3:	75 0a                	jne    8034ff <argnext+0x2f>
		return -1;
  8034f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8034fa:	e9 25 01 00 00       	jmpq   803624 <argnext+0x154>

	if (!*args->curarg) {
  8034ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803503:	48 8b 40 10          	mov    0x10(%rax),%rax
  803507:	0f b6 00             	movzbl (%rax),%eax
  80350a:	84 c0                	test   %al,%al
  80350c:	0f 85 d7 00 00 00    	jne    8035e9 <argnext+0x119>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  803512:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803516:	48 8b 00             	mov    (%rax),%rax
  803519:	8b 00                	mov    (%rax),%eax
  80351b:	83 f8 01             	cmp    $0x1,%eax
  80351e:	0f 84 ef 00 00 00    	je     803613 <argnext+0x143>
		    || args->argv[1][0] != '-'
  803524:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803528:	48 8b 40 08          	mov    0x8(%rax),%rax
  80352c:	48 83 c0 08          	add    $0x8,%rax
  803530:	48 8b 00             	mov    (%rax),%rax
  803533:	0f b6 00             	movzbl (%rax),%eax
  803536:	3c 2d                	cmp    $0x2d,%al
  803538:	0f 85 d5 00 00 00    	jne    803613 <argnext+0x143>
		    || args->argv[1][1] == '\0')
  80353e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803542:	48 8b 40 08          	mov    0x8(%rax),%rax
  803546:	48 83 c0 08          	add    $0x8,%rax
  80354a:	48 8b 00             	mov    (%rax),%rax
  80354d:	48 83 c0 01          	add    $0x1,%rax
  803551:	0f b6 00             	movzbl (%rax),%eax
  803554:	84 c0                	test   %al,%al
  803556:	0f 84 b7 00 00 00    	je     803613 <argnext+0x143>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  80355c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803560:	48 8b 40 08          	mov    0x8(%rax),%rax
  803564:	48 83 c0 08          	add    $0x8,%rax
  803568:	48 8b 00             	mov    (%rax),%rax
  80356b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80356f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803573:	48 89 50 10          	mov    %rdx,0x10(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  803577:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80357b:	48 8b 00             	mov    (%rax),%rax
  80357e:	8b 00                	mov    (%rax),%eax
  803580:	83 e8 01             	sub    $0x1,%eax
  803583:	48 98                	cltq   
  803585:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80358c:	00 
  80358d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803591:	48 8b 40 08          	mov    0x8(%rax),%rax
  803595:	48 8d 48 10          	lea    0x10(%rax),%rcx
  803599:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80359d:	48 8b 40 08          	mov    0x8(%rax),%rax
  8035a1:	48 83 c0 08          	add    $0x8,%rax
  8035a5:	48 89 ce             	mov    %rcx,%rsi
  8035a8:	48 89 c7             	mov    %rax,%rdi
  8035ab:	48 b8 90 24 80 00 00 	movabs $0x802490,%rax
  8035b2:	00 00 00 
  8035b5:	ff d0                	callq  *%rax
		(*args->argc)--;
  8035b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035bb:	48 8b 00             	mov    (%rax),%rax
  8035be:	8b 10                	mov    (%rax),%edx
  8035c0:	83 ea 01             	sub    $0x1,%edx
  8035c3:	89 10                	mov    %edx,(%rax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  8035c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035c9:	48 8b 40 10          	mov    0x10(%rax),%rax
  8035cd:	0f b6 00             	movzbl (%rax),%eax
  8035d0:	3c 2d                	cmp    $0x2d,%al
  8035d2:	75 15                	jne    8035e9 <argnext+0x119>
  8035d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035d8:	48 8b 40 10          	mov    0x10(%rax),%rax
  8035dc:	48 83 c0 01          	add    $0x1,%rax
  8035e0:	0f b6 00             	movzbl (%rax),%eax
  8035e3:	84 c0                	test   %al,%al
  8035e5:	75 02                	jne    8035e9 <argnext+0x119>
			goto endofargs;
  8035e7:	eb 2a                	jmp    803613 <argnext+0x143>
	}

	arg = (unsigned char) *args->curarg;
  8035e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035ed:	48 8b 40 10          	mov    0x10(%rax),%rax
  8035f1:	0f b6 00             	movzbl (%rax),%eax
  8035f4:	0f b6 c0             	movzbl %al,%eax
  8035f7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	args->curarg++;
  8035fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035fe:	48 8b 40 10          	mov    0x10(%rax),%rax
  803602:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803606:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80360a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	return arg;
  80360e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803611:	eb 11                	jmp    803624 <argnext+0x154>

endofargs:
	args->curarg = 0;
  803613:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803617:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  80361e:	00 
	return -1;
  80361f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  803624:	c9                   	leaveq 
  803625:	c3                   	retq   

0000000000803626 <argvalue>:

char *
argvalue(struct Argstate *args)
{
  803626:	55                   	push   %rbp
  803627:	48 89 e5             	mov    %rsp,%rbp
  80362a:	48 83 ec 10          	sub    $0x10,%rsp
  80362e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  803632:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803636:	48 8b 40 18          	mov    0x18(%rax),%rax
  80363a:	48 85 c0             	test   %rax,%rax
  80363d:	74 0a                	je     803649 <argvalue+0x23>
  80363f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803643:	48 8b 40 18          	mov    0x18(%rax),%rax
  803647:	eb 13                	jmp    80365c <argvalue+0x36>
  803649:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80364d:	48 89 c7             	mov    %rax,%rdi
  803650:	48 b8 5e 36 80 00 00 	movabs $0x80365e,%rax
  803657:	00 00 00 
  80365a:	ff d0                	callq  *%rax
}
  80365c:	c9                   	leaveq 
  80365d:	c3                   	retq   

000000000080365e <argnextvalue>:

char *
argnextvalue(struct Argstate *args)
{
  80365e:	55                   	push   %rbp
  80365f:	48 89 e5             	mov    %rsp,%rbp
  803662:	53                   	push   %rbx
  803663:	48 83 ec 18          	sub    $0x18,%rsp
  803667:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (!args->curarg)
  80366b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80366f:	48 8b 40 10          	mov    0x10(%rax),%rax
  803673:	48 85 c0             	test   %rax,%rax
  803676:	75 0a                	jne    803682 <argnextvalue+0x24>
		return 0;
  803678:	b8 00 00 00 00       	mov    $0x0,%eax
  80367d:	e9 c8 00 00 00       	jmpq   80374a <argnextvalue+0xec>
	if (*args->curarg) {
  803682:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803686:	48 8b 40 10          	mov    0x10(%rax),%rax
  80368a:	0f b6 00             	movzbl (%rax),%eax
  80368d:	84 c0                	test   %al,%al
  80368f:	74 27                	je     8036b8 <argnextvalue+0x5a>
		args->argvalue = args->curarg;
  803691:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803695:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803699:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80369d:	48 89 50 18          	mov    %rdx,0x18(%rax)
		args->curarg = "";
  8036a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036a5:	48 bb 6e 70 80 00 00 	movabs $0x80706e,%rbx
  8036ac:	00 00 00 
  8036af:	48 89 58 10          	mov    %rbx,0x10(%rax)
  8036b3:	e9 8a 00 00 00       	jmpq   803742 <argnextvalue+0xe4>
	} else if (*args->argc > 1) {
  8036b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036bc:	48 8b 00             	mov    (%rax),%rax
  8036bf:	8b 00                	mov    (%rax),%eax
  8036c1:	83 f8 01             	cmp    $0x1,%eax
  8036c4:	7e 64                	jle    80372a <argnextvalue+0xcc>
		args->argvalue = args->argv[1];
  8036c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036ca:	48 8b 40 08          	mov    0x8(%rax),%rax
  8036ce:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8036d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036d6:	48 89 50 18          	mov    %rdx,0x18(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8036da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036de:	48 8b 00             	mov    (%rax),%rax
  8036e1:	8b 00                	mov    (%rax),%eax
  8036e3:	83 e8 01             	sub    $0x1,%eax
  8036e6:	48 98                	cltq   
  8036e8:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8036ef:	00 
  8036f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036f4:	48 8b 40 08          	mov    0x8(%rax),%rax
  8036f8:	48 8d 48 10          	lea    0x10(%rax),%rcx
  8036fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803700:	48 8b 40 08          	mov    0x8(%rax),%rax
  803704:	48 83 c0 08          	add    $0x8,%rax
  803708:	48 89 ce             	mov    %rcx,%rsi
  80370b:	48 89 c7             	mov    %rax,%rdi
  80370e:	48 b8 90 24 80 00 00 	movabs $0x802490,%rax
  803715:	00 00 00 
  803718:	ff d0                	callq  *%rax
		(*args->argc)--;
  80371a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80371e:	48 8b 00             	mov    (%rax),%rax
  803721:	8b 10                	mov    (%rax),%edx
  803723:	83 ea 01             	sub    $0x1,%edx
  803726:	89 10                	mov    %edx,(%rax)
  803728:	eb 18                	jmp    803742 <argnextvalue+0xe4>
	} else {
		args->argvalue = 0;
  80372a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80372e:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  803735:	00 
		args->curarg = 0;
  803736:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80373a:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  803741:	00 
	}
	return (char*) args->argvalue;
  803742:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803746:	48 8b 40 18          	mov    0x18(%rax),%rax
}
  80374a:	48 83 c4 18          	add    $0x18,%rsp
  80374e:	5b                   	pop    %rbx
  80374f:	5d                   	pop    %rbp
  803750:	c3                   	retq   

0000000000803751 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  803751:	55                   	push   %rbp
  803752:	48 89 e5             	mov    %rsp,%rbp
  803755:	48 83 ec 08          	sub    $0x8,%rsp
  803759:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80375d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803761:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  803768:	ff ff ff 
  80376b:	48 01 d0             	add    %rdx,%rax
  80376e:	48 c1 e8 0c          	shr    $0xc,%rax
}
  803772:	c9                   	leaveq 
  803773:	c3                   	retq   

0000000000803774 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  803774:	55                   	push   %rbp
  803775:	48 89 e5             	mov    %rsp,%rbp
  803778:	48 83 ec 08          	sub    $0x8,%rsp
  80377c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  803780:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803784:	48 89 c7             	mov    %rax,%rdi
  803787:	48 b8 51 37 80 00 00 	movabs $0x803751,%rax
  80378e:	00 00 00 
  803791:	ff d0                	callq  *%rax
  803793:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  803799:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80379d:	c9                   	leaveq 
  80379e:	c3                   	retq   

000000000080379f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80379f:	55                   	push   %rbp
  8037a0:	48 89 e5             	mov    %rsp,%rbp
  8037a3:	48 83 ec 18          	sub    $0x18,%rsp
  8037a7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8037ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8037b2:	eb 6b                	jmp    80381f <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8037b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037b7:	48 98                	cltq   
  8037b9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8037bf:	48 c1 e0 0c          	shl    $0xc,%rax
  8037c3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8037c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037cb:	48 c1 e8 15          	shr    $0x15,%rax
  8037cf:	48 89 c2             	mov    %rax,%rdx
  8037d2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8037d9:	01 00 00 
  8037dc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8037e0:	83 e0 01             	and    $0x1,%eax
  8037e3:	48 85 c0             	test   %rax,%rax
  8037e6:	74 21                	je     803809 <fd_alloc+0x6a>
  8037e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037ec:	48 c1 e8 0c          	shr    $0xc,%rax
  8037f0:	48 89 c2             	mov    %rax,%rdx
  8037f3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8037fa:	01 00 00 
  8037fd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803801:	83 e0 01             	and    $0x1,%eax
  803804:	48 85 c0             	test   %rax,%rax
  803807:	75 12                	jne    80381b <fd_alloc+0x7c>
			*fd_store = fd;
  803809:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80380d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803811:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  803814:	b8 00 00 00 00       	mov    $0x0,%eax
  803819:	eb 1a                	jmp    803835 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80381b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80381f:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  803823:	7e 8f                	jle    8037b4 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  803825:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803829:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  803830:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  803835:	c9                   	leaveq 
  803836:	c3                   	retq   

0000000000803837 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  803837:	55                   	push   %rbp
  803838:	48 89 e5             	mov    %rsp,%rbp
  80383b:	48 83 ec 20          	sub    $0x20,%rsp
  80383f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803842:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  803846:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80384a:	78 06                	js     803852 <fd_lookup+0x1b>
  80384c:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  803850:	7e 07                	jle    803859 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  803852:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803857:	eb 6c                	jmp    8038c5 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  803859:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80385c:	48 98                	cltq   
  80385e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  803864:	48 c1 e0 0c          	shl    $0xc,%rax
  803868:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80386c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803870:	48 c1 e8 15          	shr    $0x15,%rax
  803874:	48 89 c2             	mov    %rax,%rdx
  803877:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80387e:	01 00 00 
  803881:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803885:	83 e0 01             	and    $0x1,%eax
  803888:	48 85 c0             	test   %rax,%rax
  80388b:	74 21                	je     8038ae <fd_lookup+0x77>
  80388d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803891:	48 c1 e8 0c          	shr    $0xc,%rax
  803895:	48 89 c2             	mov    %rax,%rdx
  803898:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80389f:	01 00 00 
  8038a2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8038a6:	83 e0 01             	and    $0x1,%eax
  8038a9:	48 85 c0             	test   %rax,%rax
  8038ac:	75 07                	jne    8038b5 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8038ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8038b3:	eb 10                	jmp    8038c5 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8038b5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038b9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8038bd:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8038c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8038c5:	c9                   	leaveq 
  8038c6:	c3                   	retq   

00000000008038c7 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8038c7:	55                   	push   %rbp
  8038c8:	48 89 e5             	mov    %rsp,%rbp
  8038cb:	48 83 ec 30          	sub    $0x30,%rsp
  8038cf:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8038d3:	89 f0                	mov    %esi,%eax
  8038d5:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8038d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038dc:	48 89 c7             	mov    %rax,%rdi
  8038df:	48 b8 51 37 80 00 00 	movabs $0x803751,%rax
  8038e6:	00 00 00 
  8038e9:	ff d0                	callq  *%rax
  8038eb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8038ef:	48 89 d6             	mov    %rdx,%rsi
  8038f2:	89 c7                	mov    %eax,%edi
  8038f4:	48 b8 37 38 80 00 00 	movabs $0x803837,%rax
  8038fb:	00 00 00 
  8038fe:	ff d0                	callq  *%rax
  803900:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803903:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803907:	78 0a                	js     803913 <fd_close+0x4c>
	    || fd != fd2)
  803909:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80390d:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  803911:	74 12                	je     803925 <fd_close+0x5e>
		return (must_exist ? r : 0);
  803913:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  803917:	74 05                	je     80391e <fd_close+0x57>
  803919:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80391c:	eb 05                	jmp    803923 <fd_close+0x5c>
  80391e:	b8 00 00 00 00       	mov    $0x0,%eax
  803923:	eb 69                	jmp    80398e <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  803925:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803929:	8b 00                	mov    (%rax),%eax
  80392b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80392f:	48 89 d6             	mov    %rdx,%rsi
  803932:	89 c7                	mov    %eax,%edi
  803934:	48 b8 90 39 80 00 00 	movabs $0x803990,%rax
  80393b:	00 00 00 
  80393e:	ff d0                	callq  *%rax
  803940:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803943:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803947:	78 2a                	js     803973 <fd_close+0xac>
		if (dev->dev_close)
  803949:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80394d:	48 8b 40 20          	mov    0x20(%rax),%rax
  803951:	48 85 c0             	test   %rax,%rax
  803954:	74 16                	je     80396c <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  803956:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80395a:	48 8b 40 20          	mov    0x20(%rax),%rax
  80395e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803962:	48 89 d7             	mov    %rdx,%rdi
  803965:	ff d0                	callq  *%rax
  803967:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80396a:	eb 07                	jmp    803973 <fd_close+0xac>
		else
			r = 0;
  80396c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  803973:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803977:	48 89 c6             	mov    %rax,%rsi
  80397a:	bf 00 00 00 00       	mov    $0x0,%edi
  80397f:	48 b8 46 2b 80 00 00 	movabs $0x802b46,%rax
  803986:	00 00 00 
  803989:	ff d0                	callq  *%rax
	return r;
  80398b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80398e:	c9                   	leaveq 
  80398f:	c3                   	retq   

0000000000803990 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  803990:	55                   	push   %rbp
  803991:	48 89 e5             	mov    %rsp,%rbp
  803994:	48 83 ec 20          	sub    $0x20,%rsp
  803998:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80399b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80399f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8039a6:	eb 41                	jmp    8039e9 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8039a8:	48 b8 60 90 80 00 00 	movabs $0x809060,%rax
  8039af:	00 00 00 
  8039b2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8039b5:	48 63 d2             	movslq %edx,%rdx
  8039b8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8039bc:	8b 00                	mov    (%rax),%eax
  8039be:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8039c1:	75 22                	jne    8039e5 <dev_lookup+0x55>
			*dev = devtab[i];
  8039c3:	48 b8 60 90 80 00 00 	movabs $0x809060,%rax
  8039ca:	00 00 00 
  8039cd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8039d0:	48 63 d2             	movslq %edx,%rdx
  8039d3:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8039d7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039db:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8039de:	b8 00 00 00 00       	mov    $0x0,%eax
  8039e3:	eb 60                	jmp    803a45 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8039e5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8039e9:	48 b8 60 90 80 00 00 	movabs $0x809060,%rax
  8039f0:	00 00 00 
  8039f3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8039f6:	48 63 d2             	movslq %edx,%rdx
  8039f9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8039fd:	48 85 c0             	test   %rax,%rax
  803a00:	75 a6                	jne    8039a8 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  803a02:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  803a09:	00 00 00 
  803a0c:	48 8b 00             	mov    (%rax),%rax
  803a0f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803a15:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803a18:	89 c6                	mov    %eax,%esi
  803a1a:	48 bf 70 70 80 00 00 	movabs $0x807070,%rdi
  803a21:	00 00 00 
  803a24:	b8 00 00 00 00       	mov    $0x0,%eax
  803a29:	48 b9 5d 14 80 00 00 	movabs $0x80145d,%rcx
  803a30:	00 00 00 
  803a33:	ff d1                	callq  *%rcx
	*dev = 0;
  803a35:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a39:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  803a40:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  803a45:	c9                   	leaveq 
  803a46:	c3                   	retq   

0000000000803a47 <close>:

int
close(int fdnum)
{
  803a47:	55                   	push   %rbp
  803a48:	48 89 e5             	mov    %rsp,%rbp
  803a4b:	48 83 ec 20          	sub    $0x20,%rsp
  803a4f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803a52:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803a56:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a59:	48 89 d6             	mov    %rdx,%rsi
  803a5c:	89 c7                	mov    %eax,%edi
  803a5e:	48 b8 37 38 80 00 00 	movabs $0x803837,%rax
  803a65:	00 00 00 
  803a68:	ff d0                	callq  *%rax
  803a6a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a6d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a71:	79 05                	jns    803a78 <close+0x31>
		return r;
  803a73:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a76:	eb 18                	jmp    803a90 <close+0x49>
	else
		return fd_close(fd, 1);
  803a78:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a7c:	be 01 00 00 00       	mov    $0x1,%esi
  803a81:	48 89 c7             	mov    %rax,%rdi
  803a84:	48 b8 c7 38 80 00 00 	movabs $0x8038c7,%rax
  803a8b:	00 00 00 
  803a8e:	ff d0                	callq  *%rax
}
  803a90:	c9                   	leaveq 
  803a91:	c3                   	retq   

0000000000803a92 <close_all>:

void
close_all(void)
{
  803a92:	55                   	push   %rbp
  803a93:	48 89 e5             	mov    %rsp,%rbp
  803a96:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  803a9a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803aa1:	eb 15                	jmp    803ab8 <close_all+0x26>
		close(i);
  803aa3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803aa6:	89 c7                	mov    %eax,%edi
  803aa8:	48 b8 47 3a 80 00 00 	movabs $0x803a47,%rax
  803aaf:	00 00 00 
  803ab2:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  803ab4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803ab8:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  803abc:	7e e5                	jle    803aa3 <close_all+0x11>
		close(i);
}
  803abe:	c9                   	leaveq 
  803abf:	c3                   	retq   

0000000000803ac0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  803ac0:	55                   	push   %rbp
  803ac1:	48 89 e5             	mov    %rsp,%rbp
  803ac4:	48 83 ec 40          	sub    $0x40,%rsp
  803ac8:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803acb:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  803ace:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  803ad2:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803ad5:	48 89 d6             	mov    %rdx,%rsi
  803ad8:	89 c7                	mov    %eax,%edi
  803ada:	48 b8 37 38 80 00 00 	movabs $0x803837,%rax
  803ae1:	00 00 00 
  803ae4:	ff d0                	callq  *%rax
  803ae6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ae9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803aed:	79 08                	jns    803af7 <dup+0x37>
		return r;
  803aef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803af2:	e9 70 01 00 00       	jmpq   803c67 <dup+0x1a7>
	close(newfdnum);
  803af7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  803afa:	89 c7                	mov    %eax,%edi
  803afc:	48 b8 47 3a 80 00 00 	movabs $0x803a47,%rax
  803b03:	00 00 00 
  803b06:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  803b08:	8b 45 c8             	mov    -0x38(%rbp),%eax
  803b0b:	48 98                	cltq   
  803b0d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  803b13:	48 c1 e0 0c          	shl    $0xc,%rax
  803b17:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  803b1b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b1f:	48 89 c7             	mov    %rax,%rdi
  803b22:	48 b8 74 37 80 00 00 	movabs $0x803774,%rax
  803b29:	00 00 00 
  803b2c:	ff d0                	callq  *%rax
  803b2e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  803b32:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b36:	48 89 c7             	mov    %rax,%rdi
  803b39:	48 b8 74 37 80 00 00 	movabs $0x803774,%rax
  803b40:	00 00 00 
  803b43:	ff d0                	callq  *%rax
  803b45:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  803b49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b4d:	48 c1 e8 15          	shr    $0x15,%rax
  803b51:	48 89 c2             	mov    %rax,%rdx
  803b54:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803b5b:	01 00 00 
  803b5e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803b62:	83 e0 01             	and    $0x1,%eax
  803b65:	48 85 c0             	test   %rax,%rax
  803b68:	74 73                	je     803bdd <dup+0x11d>
  803b6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b6e:	48 c1 e8 0c          	shr    $0xc,%rax
  803b72:	48 89 c2             	mov    %rax,%rdx
  803b75:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803b7c:	01 00 00 
  803b7f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803b83:	83 e0 01             	and    $0x1,%eax
  803b86:	48 85 c0             	test   %rax,%rax
  803b89:	74 52                	je     803bdd <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  803b8b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b8f:	48 c1 e8 0c          	shr    $0xc,%rax
  803b93:	48 89 c2             	mov    %rax,%rdx
  803b96:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803b9d:	01 00 00 
  803ba0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803ba4:	25 07 0e 00 00       	and    $0xe07,%eax
  803ba9:	89 c1                	mov    %eax,%ecx
  803bab:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803baf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bb3:	41 89 c8             	mov    %ecx,%r8d
  803bb6:	48 89 d1             	mov    %rdx,%rcx
  803bb9:	ba 00 00 00 00       	mov    $0x0,%edx
  803bbe:	48 89 c6             	mov    %rax,%rsi
  803bc1:	bf 00 00 00 00       	mov    $0x0,%edi
  803bc6:	48 b8 eb 2a 80 00 00 	movabs $0x802aeb,%rax
  803bcd:	00 00 00 
  803bd0:	ff d0                	callq  *%rax
  803bd2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bd5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bd9:	79 02                	jns    803bdd <dup+0x11d>
			goto err;
  803bdb:	eb 57                	jmp    803c34 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  803bdd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803be1:	48 c1 e8 0c          	shr    $0xc,%rax
  803be5:	48 89 c2             	mov    %rax,%rdx
  803be8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803bef:	01 00 00 
  803bf2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803bf6:	25 07 0e 00 00       	and    $0xe07,%eax
  803bfb:	89 c1                	mov    %eax,%ecx
  803bfd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c01:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803c05:	41 89 c8             	mov    %ecx,%r8d
  803c08:	48 89 d1             	mov    %rdx,%rcx
  803c0b:	ba 00 00 00 00       	mov    $0x0,%edx
  803c10:	48 89 c6             	mov    %rax,%rsi
  803c13:	bf 00 00 00 00       	mov    $0x0,%edi
  803c18:	48 b8 eb 2a 80 00 00 	movabs $0x802aeb,%rax
  803c1f:	00 00 00 
  803c22:	ff d0                	callq  *%rax
  803c24:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c27:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c2b:	79 02                	jns    803c2f <dup+0x16f>
		goto err;
  803c2d:	eb 05                	jmp    803c34 <dup+0x174>

	return newfdnum;
  803c2f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  803c32:	eb 33                	jmp    803c67 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  803c34:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c38:	48 89 c6             	mov    %rax,%rsi
  803c3b:	bf 00 00 00 00       	mov    $0x0,%edi
  803c40:	48 b8 46 2b 80 00 00 	movabs $0x802b46,%rax
  803c47:	00 00 00 
  803c4a:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  803c4c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c50:	48 89 c6             	mov    %rax,%rsi
  803c53:	bf 00 00 00 00       	mov    $0x0,%edi
  803c58:	48 b8 46 2b 80 00 00 	movabs $0x802b46,%rax
  803c5f:	00 00 00 
  803c62:	ff d0                	callq  *%rax
	return r;
  803c64:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803c67:	c9                   	leaveq 
  803c68:	c3                   	retq   

0000000000803c69 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  803c69:	55                   	push   %rbp
  803c6a:	48 89 e5             	mov    %rsp,%rbp
  803c6d:	48 83 ec 40          	sub    $0x40,%rsp
  803c71:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803c74:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803c78:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  803c7c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803c80:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803c83:	48 89 d6             	mov    %rdx,%rsi
  803c86:	89 c7                	mov    %eax,%edi
  803c88:	48 b8 37 38 80 00 00 	movabs $0x803837,%rax
  803c8f:	00 00 00 
  803c92:	ff d0                	callq  *%rax
  803c94:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c97:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c9b:	78 24                	js     803cc1 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803c9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ca1:	8b 00                	mov    (%rax),%eax
  803ca3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803ca7:	48 89 d6             	mov    %rdx,%rsi
  803caa:	89 c7                	mov    %eax,%edi
  803cac:	48 b8 90 39 80 00 00 	movabs $0x803990,%rax
  803cb3:	00 00 00 
  803cb6:	ff d0                	callq  *%rax
  803cb8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cbb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cbf:	79 05                	jns    803cc6 <read+0x5d>
		return r;
  803cc1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cc4:	eb 76                	jmp    803d3c <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  803cc6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cca:	8b 40 08             	mov    0x8(%rax),%eax
  803ccd:	83 e0 03             	and    $0x3,%eax
  803cd0:	83 f8 01             	cmp    $0x1,%eax
  803cd3:	75 3a                	jne    803d0f <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  803cd5:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  803cdc:	00 00 00 
  803cdf:	48 8b 00             	mov    (%rax),%rax
  803ce2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803ce8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803ceb:	89 c6                	mov    %eax,%esi
  803ced:	48 bf 8f 70 80 00 00 	movabs $0x80708f,%rdi
  803cf4:	00 00 00 
  803cf7:	b8 00 00 00 00       	mov    $0x0,%eax
  803cfc:	48 b9 5d 14 80 00 00 	movabs $0x80145d,%rcx
  803d03:	00 00 00 
  803d06:	ff d1                	callq  *%rcx
		return -E_INVAL;
  803d08:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803d0d:	eb 2d                	jmp    803d3c <read+0xd3>
	}
	if (!dev->dev_read)
  803d0f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d13:	48 8b 40 10          	mov    0x10(%rax),%rax
  803d17:	48 85 c0             	test   %rax,%rax
  803d1a:	75 07                	jne    803d23 <read+0xba>
		return -E_NOT_SUPP;
  803d1c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803d21:	eb 19                	jmp    803d3c <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  803d23:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d27:	48 8b 40 10          	mov    0x10(%rax),%rax
  803d2b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803d2f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803d33:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803d37:	48 89 cf             	mov    %rcx,%rdi
  803d3a:	ff d0                	callq  *%rax
}
  803d3c:	c9                   	leaveq 
  803d3d:	c3                   	retq   

0000000000803d3e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  803d3e:	55                   	push   %rbp
  803d3f:	48 89 e5             	mov    %rsp,%rbp
  803d42:	48 83 ec 30          	sub    $0x30,%rsp
  803d46:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d49:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d4d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803d51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803d58:	eb 49                	jmp    803da3 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  803d5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d5d:	48 98                	cltq   
  803d5f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803d63:	48 29 c2             	sub    %rax,%rdx
  803d66:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d69:	48 63 c8             	movslq %eax,%rcx
  803d6c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d70:	48 01 c1             	add    %rax,%rcx
  803d73:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d76:	48 89 ce             	mov    %rcx,%rsi
  803d79:	89 c7                	mov    %eax,%edi
  803d7b:	48 b8 69 3c 80 00 00 	movabs $0x803c69,%rax
  803d82:	00 00 00 
  803d85:	ff d0                	callq  *%rax
  803d87:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  803d8a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803d8e:	79 05                	jns    803d95 <readn+0x57>
			return m;
  803d90:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d93:	eb 1c                	jmp    803db1 <readn+0x73>
		if (m == 0)
  803d95:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803d99:	75 02                	jne    803d9d <readn+0x5f>
			break;
  803d9b:	eb 11                	jmp    803dae <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803d9d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803da0:	01 45 fc             	add    %eax,-0x4(%rbp)
  803da3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803da6:	48 98                	cltq   
  803da8:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803dac:	72 ac                	jb     803d5a <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  803dae:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803db1:	c9                   	leaveq 
  803db2:	c3                   	retq   

0000000000803db3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  803db3:	55                   	push   %rbp
  803db4:	48 89 e5             	mov    %rsp,%rbp
  803db7:	48 83 ec 40          	sub    $0x40,%rsp
  803dbb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803dbe:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803dc2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  803dc6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803dca:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803dcd:	48 89 d6             	mov    %rdx,%rsi
  803dd0:	89 c7                	mov    %eax,%edi
  803dd2:	48 b8 37 38 80 00 00 	movabs $0x803837,%rax
  803dd9:	00 00 00 
  803ddc:	ff d0                	callq  *%rax
  803dde:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803de1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803de5:	78 24                	js     803e0b <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803de7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803deb:	8b 00                	mov    (%rax),%eax
  803ded:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803df1:	48 89 d6             	mov    %rdx,%rsi
  803df4:	89 c7                	mov    %eax,%edi
  803df6:	48 b8 90 39 80 00 00 	movabs $0x803990,%rax
  803dfd:	00 00 00 
  803e00:	ff d0                	callq  *%rax
  803e02:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e05:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e09:	79 05                	jns    803e10 <write+0x5d>
		return r;
  803e0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e0e:	eb 75                	jmp    803e85 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803e10:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e14:	8b 40 08             	mov    0x8(%rax),%eax
  803e17:	83 e0 03             	and    $0x3,%eax
  803e1a:	85 c0                	test   %eax,%eax
  803e1c:	75 3a                	jne    803e58 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  803e1e:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  803e25:	00 00 00 
  803e28:	48 8b 00             	mov    (%rax),%rax
  803e2b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803e31:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803e34:	89 c6                	mov    %eax,%esi
  803e36:	48 bf ab 70 80 00 00 	movabs $0x8070ab,%rdi
  803e3d:	00 00 00 
  803e40:	b8 00 00 00 00       	mov    $0x0,%eax
  803e45:	48 b9 5d 14 80 00 00 	movabs $0x80145d,%rcx
  803e4c:	00 00 00 
  803e4f:	ff d1                	callq  *%rcx
		return -E_INVAL;
  803e51:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803e56:	eb 2d                	jmp    803e85 <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  803e58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e5c:	48 8b 40 18          	mov    0x18(%rax),%rax
  803e60:	48 85 c0             	test   %rax,%rax
  803e63:	75 07                	jne    803e6c <write+0xb9>
		return -E_NOT_SUPP;
  803e65:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803e6a:	eb 19                	jmp    803e85 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  803e6c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e70:	48 8b 40 18          	mov    0x18(%rax),%rax
  803e74:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803e78:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803e7c:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803e80:	48 89 cf             	mov    %rcx,%rdi
  803e83:	ff d0                	callq  *%rax
}
  803e85:	c9                   	leaveq 
  803e86:	c3                   	retq   

0000000000803e87 <seek>:

int
seek(int fdnum, off_t offset)
{
  803e87:	55                   	push   %rbp
  803e88:	48 89 e5             	mov    %rsp,%rbp
  803e8b:	48 83 ec 18          	sub    $0x18,%rsp
  803e8f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803e92:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803e95:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803e99:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e9c:	48 89 d6             	mov    %rdx,%rsi
  803e9f:	89 c7                	mov    %eax,%edi
  803ea1:	48 b8 37 38 80 00 00 	movabs $0x803837,%rax
  803ea8:	00 00 00 
  803eab:	ff d0                	callq  *%rax
  803ead:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803eb0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803eb4:	79 05                	jns    803ebb <seek+0x34>
		return r;
  803eb6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803eb9:	eb 0f                	jmp    803eca <seek+0x43>
	fd->fd_offset = offset;
  803ebb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ebf:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803ec2:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  803ec5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803eca:	c9                   	leaveq 
  803ecb:	c3                   	retq   

0000000000803ecc <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  803ecc:	55                   	push   %rbp
  803ecd:	48 89 e5             	mov    %rsp,%rbp
  803ed0:	48 83 ec 30          	sub    $0x30,%rsp
  803ed4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803ed7:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  803eda:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803ede:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803ee1:	48 89 d6             	mov    %rdx,%rsi
  803ee4:	89 c7                	mov    %eax,%edi
  803ee6:	48 b8 37 38 80 00 00 	movabs $0x803837,%rax
  803eed:	00 00 00 
  803ef0:	ff d0                	callq  *%rax
  803ef2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ef5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ef9:	78 24                	js     803f1f <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803efb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803eff:	8b 00                	mov    (%rax),%eax
  803f01:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803f05:	48 89 d6             	mov    %rdx,%rsi
  803f08:	89 c7                	mov    %eax,%edi
  803f0a:	48 b8 90 39 80 00 00 	movabs $0x803990,%rax
  803f11:	00 00 00 
  803f14:	ff d0                	callq  *%rax
  803f16:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f19:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f1d:	79 05                	jns    803f24 <ftruncate+0x58>
		return r;
  803f1f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f22:	eb 72                	jmp    803f96 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803f24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f28:	8b 40 08             	mov    0x8(%rax),%eax
  803f2b:	83 e0 03             	and    $0x3,%eax
  803f2e:	85 c0                	test   %eax,%eax
  803f30:	75 3a                	jne    803f6c <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  803f32:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  803f39:	00 00 00 
  803f3c:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  803f3f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803f45:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803f48:	89 c6                	mov    %eax,%esi
  803f4a:	48 bf c8 70 80 00 00 	movabs $0x8070c8,%rdi
  803f51:	00 00 00 
  803f54:	b8 00 00 00 00       	mov    $0x0,%eax
  803f59:	48 b9 5d 14 80 00 00 	movabs $0x80145d,%rcx
  803f60:	00 00 00 
  803f63:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  803f65:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803f6a:	eb 2a                	jmp    803f96 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  803f6c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f70:	48 8b 40 30          	mov    0x30(%rax),%rax
  803f74:	48 85 c0             	test   %rax,%rax
  803f77:	75 07                	jne    803f80 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  803f79:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803f7e:	eb 16                	jmp    803f96 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  803f80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f84:	48 8b 40 30          	mov    0x30(%rax),%rax
  803f88:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803f8c:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  803f8f:	89 ce                	mov    %ecx,%esi
  803f91:	48 89 d7             	mov    %rdx,%rdi
  803f94:	ff d0                	callq  *%rax
}
  803f96:	c9                   	leaveq 
  803f97:	c3                   	retq   

0000000000803f98 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  803f98:	55                   	push   %rbp
  803f99:	48 89 e5             	mov    %rsp,%rbp
  803f9c:	48 83 ec 30          	sub    $0x30,%rsp
  803fa0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803fa3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803fa7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803fab:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803fae:	48 89 d6             	mov    %rdx,%rsi
  803fb1:	89 c7                	mov    %eax,%edi
  803fb3:	48 b8 37 38 80 00 00 	movabs $0x803837,%rax
  803fba:	00 00 00 
  803fbd:	ff d0                	callq  *%rax
  803fbf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fc2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fc6:	78 24                	js     803fec <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803fc8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fcc:	8b 00                	mov    (%rax),%eax
  803fce:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803fd2:	48 89 d6             	mov    %rdx,%rsi
  803fd5:	89 c7                	mov    %eax,%edi
  803fd7:	48 b8 90 39 80 00 00 	movabs $0x803990,%rax
  803fde:	00 00 00 
  803fe1:	ff d0                	callq  *%rax
  803fe3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fe6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fea:	79 05                	jns    803ff1 <fstat+0x59>
		return r;
  803fec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fef:	eb 5e                	jmp    80404f <fstat+0xb7>
	if (!dev->dev_stat)
  803ff1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ff5:	48 8b 40 28          	mov    0x28(%rax),%rax
  803ff9:	48 85 c0             	test   %rax,%rax
  803ffc:	75 07                	jne    804005 <fstat+0x6d>
		return -E_NOT_SUPP;
  803ffe:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  804003:	eb 4a                	jmp    80404f <fstat+0xb7>
	stat->st_name[0] = 0;
  804005:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804009:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80400c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804010:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  804017:	00 00 00 
	stat->st_isdir = 0;
  80401a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80401e:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804025:	00 00 00 
	stat->st_dev = dev;
  804028:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80402c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804030:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  804037:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80403b:	48 8b 40 28          	mov    0x28(%rax),%rax
  80403f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804043:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  804047:	48 89 ce             	mov    %rcx,%rsi
  80404a:	48 89 d7             	mov    %rdx,%rdi
  80404d:	ff d0                	callq  *%rax
}
  80404f:	c9                   	leaveq 
  804050:	c3                   	retq   

0000000000804051 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  804051:	55                   	push   %rbp
  804052:	48 89 e5             	mov    %rsp,%rbp
  804055:	48 83 ec 20          	sub    $0x20,%rsp
  804059:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80405d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  804061:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804065:	be 00 00 00 00       	mov    $0x0,%esi
  80406a:	48 89 c7             	mov    %rax,%rdi
  80406d:	48 b8 3f 41 80 00 00 	movabs $0x80413f,%rax
  804074:	00 00 00 
  804077:	ff d0                	callq  *%rax
  804079:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80407c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804080:	79 05                	jns    804087 <stat+0x36>
		return fd;
  804082:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804085:	eb 2f                	jmp    8040b6 <stat+0x65>
	r = fstat(fd, stat);
  804087:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80408b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80408e:	48 89 d6             	mov    %rdx,%rsi
  804091:	89 c7                	mov    %eax,%edi
  804093:	48 b8 98 3f 80 00 00 	movabs $0x803f98,%rax
  80409a:	00 00 00 
  80409d:	ff d0                	callq  *%rax
  80409f:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8040a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040a5:	89 c7                	mov    %eax,%edi
  8040a7:	48 b8 47 3a 80 00 00 	movabs $0x803a47,%rax
  8040ae:	00 00 00 
  8040b1:	ff d0                	callq  *%rax
	return r;
  8040b3:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8040b6:	c9                   	leaveq 
  8040b7:	c3                   	retq   

00000000008040b8 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8040b8:	55                   	push   %rbp
  8040b9:	48 89 e5             	mov    %rsp,%rbp
  8040bc:	48 83 ec 10          	sub    $0x10,%rsp
  8040c0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8040c3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8040c7:	48 b8 20 a4 80 00 00 	movabs $0x80a420,%rax
  8040ce:	00 00 00 
  8040d1:	8b 00                	mov    (%rax),%eax
  8040d3:	85 c0                	test   %eax,%eax
  8040d5:	75 1d                	jne    8040f4 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8040d7:	bf 01 00 00 00       	mov    $0x1,%edi
  8040dc:	48 b8 c7 66 80 00 00 	movabs $0x8066c7,%rax
  8040e3:	00 00 00 
  8040e6:	ff d0                	callq  *%rax
  8040e8:	48 ba 20 a4 80 00 00 	movabs $0x80a420,%rdx
  8040ef:	00 00 00 
  8040f2:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8040f4:	48 b8 20 a4 80 00 00 	movabs $0x80a420,%rax
  8040fb:	00 00 00 
  8040fe:	8b 00                	mov    (%rax),%eax
  804100:	8b 75 fc             	mov    -0x4(%rbp),%esi
  804103:	b9 07 00 00 00       	mov    $0x7,%ecx
  804108:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  80410f:	00 00 00 
  804112:	89 c7                	mov    %eax,%edi
  804114:	48 b8 65 66 80 00 00 	movabs $0x806665,%rax
  80411b:	00 00 00 
  80411e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  804120:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804124:	ba 00 00 00 00       	mov    $0x0,%edx
  804129:	48 89 c6             	mov    %rax,%rsi
  80412c:	bf 00 00 00 00       	mov    $0x0,%edi
  804131:	48 b8 5f 65 80 00 00 	movabs $0x80655f,%rax
  804138:	00 00 00 
  80413b:	ff d0                	callq  *%rax
}
  80413d:	c9                   	leaveq 
  80413e:	c3                   	retq   

000000000080413f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80413f:	55                   	push   %rbp
  804140:	48 89 e5             	mov    %rsp,%rbp
  804143:	48 83 ec 30          	sub    $0x30,%rsp
  804147:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80414b:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  80414e:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  804155:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  80415c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  804163:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804168:	75 08                	jne    804172 <open+0x33>
	{
		return r;
  80416a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80416d:	e9 f2 00 00 00       	jmpq   804264 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  804172:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804176:	48 89 c7             	mov    %rax,%rdi
  804179:	48 b8 00 21 80 00 00 	movabs $0x802100,%rax
  804180:	00 00 00 
  804183:	ff d0                	callq  *%rax
  804185:	89 45 f4             	mov    %eax,-0xc(%rbp)
  804188:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  80418f:	7e 0a                	jle    80419b <open+0x5c>
	{
		return -E_BAD_PATH;
  804191:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  804196:	e9 c9 00 00 00       	jmpq   804264 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  80419b:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8041a2:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  8041a3:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8041a7:	48 89 c7             	mov    %rax,%rdi
  8041aa:	48 b8 9f 37 80 00 00 	movabs $0x80379f,%rax
  8041b1:	00 00 00 
  8041b4:	ff d0                	callq  *%rax
  8041b6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8041b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041bd:	78 09                	js     8041c8 <open+0x89>
  8041bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041c3:	48 85 c0             	test   %rax,%rax
  8041c6:	75 08                	jne    8041d0 <open+0x91>
		{
			return r;
  8041c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041cb:	e9 94 00 00 00       	jmpq   804264 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  8041d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041d4:	ba 00 04 00 00       	mov    $0x400,%edx
  8041d9:	48 89 c6             	mov    %rax,%rsi
  8041dc:	48 bf 00 b0 80 00 00 	movabs $0x80b000,%rdi
  8041e3:	00 00 00 
  8041e6:	48 b8 fe 21 80 00 00 	movabs $0x8021fe,%rax
  8041ed:	00 00 00 
  8041f0:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  8041f2:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8041f9:	00 00 00 
  8041fc:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  8041ff:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  804205:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804209:	48 89 c6             	mov    %rax,%rsi
  80420c:	bf 01 00 00 00       	mov    $0x1,%edi
  804211:	48 b8 b8 40 80 00 00 	movabs $0x8040b8,%rax
  804218:	00 00 00 
  80421b:	ff d0                	callq  *%rax
  80421d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804220:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804224:	79 2b                	jns    804251 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  804226:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80422a:	be 00 00 00 00       	mov    $0x0,%esi
  80422f:	48 89 c7             	mov    %rax,%rdi
  804232:	48 b8 c7 38 80 00 00 	movabs $0x8038c7,%rax
  804239:	00 00 00 
  80423c:	ff d0                	callq  *%rax
  80423e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  804241:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  804245:	79 05                	jns    80424c <open+0x10d>
			{
				return d;
  804247:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80424a:	eb 18                	jmp    804264 <open+0x125>
			}
			return r;
  80424c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80424f:	eb 13                	jmp    804264 <open+0x125>
		}	
		return fd2num(fd_store);
  804251:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804255:	48 89 c7             	mov    %rax,%rdi
  804258:	48 b8 51 37 80 00 00 	movabs $0x803751,%rax
  80425f:	00 00 00 
  804262:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  804264:	c9                   	leaveq 
  804265:	c3                   	retq   

0000000000804266 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  804266:	55                   	push   %rbp
  804267:	48 89 e5             	mov    %rsp,%rbp
  80426a:	48 83 ec 10          	sub    $0x10,%rsp
  80426e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  804272:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804276:	8b 50 0c             	mov    0xc(%rax),%edx
  804279:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804280:	00 00 00 
  804283:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  804285:	be 00 00 00 00       	mov    $0x0,%esi
  80428a:	bf 06 00 00 00       	mov    $0x6,%edi
  80428f:	48 b8 b8 40 80 00 00 	movabs $0x8040b8,%rax
  804296:	00 00 00 
  804299:	ff d0                	callq  *%rax
}
  80429b:	c9                   	leaveq 
  80429c:	c3                   	retq   

000000000080429d <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80429d:	55                   	push   %rbp
  80429e:	48 89 e5             	mov    %rsp,%rbp
  8042a1:	48 83 ec 30          	sub    $0x30,%rsp
  8042a5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8042a9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8042ad:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  8042b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  8042b8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8042bd:	74 07                	je     8042c6 <devfile_read+0x29>
  8042bf:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8042c4:	75 07                	jne    8042cd <devfile_read+0x30>
		return -E_INVAL;
  8042c6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8042cb:	eb 77                	jmp    804344 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8042cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042d1:	8b 50 0c             	mov    0xc(%rax),%edx
  8042d4:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8042db:	00 00 00 
  8042de:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8042e0:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8042e7:	00 00 00 
  8042ea:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8042ee:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  8042f2:	be 00 00 00 00       	mov    $0x0,%esi
  8042f7:	bf 03 00 00 00       	mov    $0x3,%edi
  8042fc:	48 b8 b8 40 80 00 00 	movabs $0x8040b8,%rax
  804303:	00 00 00 
  804306:	ff d0                	callq  *%rax
  804308:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80430b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80430f:	7f 05                	jg     804316 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  804311:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804314:	eb 2e                	jmp    804344 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  804316:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804319:	48 63 d0             	movslq %eax,%rdx
  80431c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804320:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  804327:	00 00 00 
  80432a:	48 89 c7             	mov    %rax,%rdi
  80432d:	48 b8 90 24 80 00 00 	movabs $0x802490,%rax
  804334:	00 00 00 
  804337:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  804339:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80433d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  804341:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  804344:	c9                   	leaveq 
  804345:	c3                   	retq   

0000000000804346 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  804346:	55                   	push   %rbp
  804347:	48 89 e5             	mov    %rsp,%rbp
  80434a:	48 83 ec 30          	sub    $0x30,%rsp
  80434e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804352:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804356:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  80435a:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  804361:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804366:	74 07                	je     80436f <devfile_write+0x29>
  804368:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80436d:	75 08                	jne    804377 <devfile_write+0x31>
		return r;
  80436f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804372:	e9 9a 00 00 00       	jmpq   804411 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  804377:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80437b:	8b 50 0c             	mov    0xc(%rax),%edx
  80437e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804385:	00 00 00 
  804388:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  80438a:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  804391:	00 
  804392:	76 08                	jbe    80439c <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  804394:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  80439b:	00 
	}
	fsipcbuf.write.req_n = n;
  80439c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8043a3:	00 00 00 
  8043a6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8043aa:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  8043ae:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8043b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043b6:	48 89 c6             	mov    %rax,%rsi
  8043b9:	48 bf 10 b0 80 00 00 	movabs $0x80b010,%rdi
  8043c0:	00 00 00 
  8043c3:	48 b8 90 24 80 00 00 	movabs $0x802490,%rax
  8043ca:	00 00 00 
  8043cd:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  8043cf:	be 00 00 00 00       	mov    $0x0,%esi
  8043d4:	bf 04 00 00 00       	mov    $0x4,%edi
  8043d9:	48 b8 b8 40 80 00 00 	movabs $0x8040b8,%rax
  8043e0:	00 00 00 
  8043e3:	ff d0                	callq  *%rax
  8043e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8043e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043ec:	7f 20                	jg     80440e <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  8043ee:	48 bf ee 70 80 00 00 	movabs $0x8070ee,%rdi
  8043f5:	00 00 00 
  8043f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8043fd:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  804404:	00 00 00 
  804407:	ff d2                	callq  *%rdx
		return r;
  804409:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80440c:	eb 03                	jmp    804411 <devfile_write+0xcb>
	}
	return r;
  80440e:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  804411:	c9                   	leaveq 
  804412:	c3                   	retq   

0000000000804413 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  804413:	55                   	push   %rbp
  804414:	48 89 e5             	mov    %rsp,%rbp
  804417:	48 83 ec 20          	sub    $0x20,%rsp
  80441b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80441f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  804423:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804427:	8b 50 0c             	mov    0xc(%rax),%edx
  80442a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804431:	00 00 00 
  804434:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  804436:	be 00 00 00 00       	mov    $0x0,%esi
  80443b:	bf 05 00 00 00       	mov    $0x5,%edi
  804440:	48 b8 b8 40 80 00 00 	movabs $0x8040b8,%rax
  804447:	00 00 00 
  80444a:	ff d0                	callq  *%rax
  80444c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80444f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804453:	79 05                	jns    80445a <devfile_stat+0x47>
		return r;
  804455:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804458:	eb 56                	jmp    8044b0 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80445a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80445e:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  804465:	00 00 00 
  804468:	48 89 c7             	mov    %rax,%rdi
  80446b:	48 b8 6c 21 80 00 00 	movabs $0x80216c,%rax
  804472:	00 00 00 
  804475:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  804477:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80447e:	00 00 00 
  804481:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  804487:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80448b:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  804491:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804498:	00 00 00 
  80449b:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8044a1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8044a5:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8044ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8044b0:	c9                   	leaveq 
  8044b1:	c3                   	retq   

00000000008044b2 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8044b2:	55                   	push   %rbp
  8044b3:	48 89 e5             	mov    %rsp,%rbp
  8044b6:	48 83 ec 10          	sub    $0x10,%rsp
  8044ba:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8044be:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8044c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044c5:	8b 50 0c             	mov    0xc(%rax),%edx
  8044c8:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8044cf:	00 00 00 
  8044d2:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8044d4:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8044db:	00 00 00 
  8044de:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8044e1:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8044e4:	be 00 00 00 00       	mov    $0x0,%esi
  8044e9:	bf 02 00 00 00       	mov    $0x2,%edi
  8044ee:	48 b8 b8 40 80 00 00 	movabs $0x8040b8,%rax
  8044f5:	00 00 00 
  8044f8:	ff d0                	callq  *%rax
}
  8044fa:	c9                   	leaveq 
  8044fb:	c3                   	retq   

00000000008044fc <remove>:

// Delete a file
int
remove(const char *path)
{
  8044fc:	55                   	push   %rbp
  8044fd:	48 89 e5             	mov    %rsp,%rbp
  804500:	48 83 ec 10          	sub    $0x10,%rsp
  804504:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  804508:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80450c:	48 89 c7             	mov    %rax,%rdi
  80450f:	48 b8 00 21 80 00 00 	movabs $0x802100,%rax
  804516:	00 00 00 
  804519:	ff d0                	callq  *%rax
  80451b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  804520:	7e 07                	jle    804529 <remove+0x2d>
		return -E_BAD_PATH;
  804522:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  804527:	eb 33                	jmp    80455c <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  804529:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80452d:	48 89 c6             	mov    %rax,%rsi
  804530:	48 bf 00 b0 80 00 00 	movabs $0x80b000,%rdi
  804537:	00 00 00 
  80453a:	48 b8 6c 21 80 00 00 	movabs $0x80216c,%rax
  804541:	00 00 00 
  804544:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  804546:	be 00 00 00 00       	mov    $0x0,%esi
  80454b:	bf 07 00 00 00       	mov    $0x7,%edi
  804550:	48 b8 b8 40 80 00 00 	movabs $0x8040b8,%rax
  804557:	00 00 00 
  80455a:	ff d0                	callq  *%rax
}
  80455c:	c9                   	leaveq 
  80455d:	c3                   	retq   

000000000080455e <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80455e:	55                   	push   %rbp
  80455f:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  804562:	be 00 00 00 00       	mov    $0x0,%esi
  804567:	bf 08 00 00 00       	mov    $0x8,%edi
  80456c:	48 b8 b8 40 80 00 00 	movabs $0x8040b8,%rax
  804573:	00 00 00 
  804576:	ff d0                	callq  *%rax
}
  804578:	5d                   	pop    %rbp
  804579:	c3                   	retq   

000000000080457a <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  80457a:	55                   	push   %rbp
  80457b:	48 89 e5             	mov    %rsp,%rbp
  80457e:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  804585:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  80458c:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  804593:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  80459a:	be 00 00 00 00       	mov    $0x0,%esi
  80459f:	48 89 c7             	mov    %rax,%rdi
  8045a2:	48 b8 3f 41 80 00 00 	movabs $0x80413f,%rax
  8045a9:	00 00 00 
  8045ac:	ff d0                	callq  *%rax
  8045ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8045b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045b5:	79 28                	jns    8045df <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8045b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045ba:	89 c6                	mov    %eax,%esi
  8045bc:	48 bf 0a 71 80 00 00 	movabs $0x80710a,%rdi
  8045c3:	00 00 00 
  8045c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8045cb:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  8045d2:	00 00 00 
  8045d5:	ff d2                	callq  *%rdx
		return fd_src;
  8045d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045da:	e9 74 01 00 00       	jmpq   804753 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8045df:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8045e6:	be 01 01 00 00       	mov    $0x101,%esi
  8045eb:	48 89 c7             	mov    %rax,%rdi
  8045ee:	48 b8 3f 41 80 00 00 	movabs $0x80413f,%rax
  8045f5:	00 00 00 
  8045f8:	ff d0                	callq  *%rax
  8045fa:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8045fd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  804601:	79 39                	jns    80463c <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  804603:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804606:	89 c6                	mov    %eax,%esi
  804608:	48 bf 20 71 80 00 00 	movabs $0x807120,%rdi
  80460f:	00 00 00 
  804612:	b8 00 00 00 00       	mov    $0x0,%eax
  804617:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  80461e:	00 00 00 
  804621:	ff d2                	callq  *%rdx
		close(fd_src);
  804623:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804626:	89 c7                	mov    %eax,%edi
  804628:	48 b8 47 3a 80 00 00 	movabs $0x803a47,%rax
  80462f:	00 00 00 
  804632:	ff d0                	callq  *%rax
		return fd_dest;
  804634:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804637:	e9 17 01 00 00       	jmpq   804753 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80463c:	eb 74                	jmp    8046b2 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  80463e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804641:	48 63 d0             	movslq %eax,%rdx
  804644:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80464b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80464e:	48 89 ce             	mov    %rcx,%rsi
  804651:	89 c7                	mov    %eax,%edi
  804653:	48 b8 b3 3d 80 00 00 	movabs $0x803db3,%rax
  80465a:	00 00 00 
  80465d:	ff d0                	callq  *%rax
  80465f:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  804662:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  804666:	79 4a                	jns    8046b2 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  804668:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80466b:	89 c6                	mov    %eax,%esi
  80466d:	48 bf 3a 71 80 00 00 	movabs $0x80713a,%rdi
  804674:	00 00 00 
  804677:	b8 00 00 00 00       	mov    $0x0,%eax
  80467c:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  804683:	00 00 00 
  804686:	ff d2                	callq  *%rdx
			close(fd_src);
  804688:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80468b:	89 c7                	mov    %eax,%edi
  80468d:	48 b8 47 3a 80 00 00 	movabs $0x803a47,%rax
  804694:	00 00 00 
  804697:	ff d0                	callq  *%rax
			close(fd_dest);
  804699:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80469c:	89 c7                	mov    %eax,%edi
  80469e:	48 b8 47 3a 80 00 00 	movabs $0x803a47,%rax
  8046a5:	00 00 00 
  8046a8:	ff d0                	callq  *%rax
			return write_size;
  8046aa:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8046ad:	e9 a1 00 00 00       	jmpq   804753 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8046b2:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8046b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046bc:	ba 00 02 00 00       	mov    $0x200,%edx
  8046c1:	48 89 ce             	mov    %rcx,%rsi
  8046c4:	89 c7                	mov    %eax,%edi
  8046c6:	48 b8 69 3c 80 00 00 	movabs $0x803c69,%rax
  8046cd:	00 00 00 
  8046d0:	ff d0                	callq  *%rax
  8046d2:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8046d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8046d9:	0f 8f 5f ff ff ff    	jg     80463e <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  8046df:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8046e3:	79 47                	jns    80472c <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8046e5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8046e8:	89 c6                	mov    %eax,%esi
  8046ea:	48 bf 4d 71 80 00 00 	movabs $0x80714d,%rdi
  8046f1:	00 00 00 
  8046f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8046f9:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  804700:	00 00 00 
  804703:	ff d2                	callq  *%rdx
		close(fd_src);
  804705:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804708:	89 c7                	mov    %eax,%edi
  80470a:	48 b8 47 3a 80 00 00 	movabs $0x803a47,%rax
  804711:	00 00 00 
  804714:	ff d0                	callq  *%rax
		close(fd_dest);
  804716:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804719:	89 c7                	mov    %eax,%edi
  80471b:	48 b8 47 3a 80 00 00 	movabs $0x803a47,%rax
  804722:	00 00 00 
  804725:	ff d0                	callq  *%rax
		return read_size;
  804727:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80472a:	eb 27                	jmp    804753 <copy+0x1d9>
	}
	close(fd_src);
  80472c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80472f:	89 c7                	mov    %eax,%edi
  804731:	48 b8 47 3a 80 00 00 	movabs $0x803a47,%rax
  804738:	00 00 00 
  80473b:	ff d0                	callq  *%rax
	close(fd_dest);
  80473d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804740:	89 c7                	mov    %eax,%edi
  804742:	48 b8 47 3a 80 00 00 	movabs $0x803a47,%rax
  804749:	00 00 00 
  80474c:	ff d0                	callq  *%rax
	return 0;
  80474e:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  804753:	c9                   	leaveq 
  804754:	c3                   	retq   

0000000000804755 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  804755:	55                   	push   %rbp
  804756:	48 89 e5             	mov    %rsp,%rbp
  804759:	48 83 ec 20          	sub    $0x20,%rsp
  80475d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  804761:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804765:	8b 40 0c             	mov    0xc(%rax),%eax
  804768:	85 c0                	test   %eax,%eax
  80476a:	7e 67                	jle    8047d3 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  80476c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804770:	8b 40 04             	mov    0x4(%rax),%eax
  804773:	48 63 d0             	movslq %eax,%rdx
  804776:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80477a:	48 8d 48 10          	lea    0x10(%rax),%rcx
  80477e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804782:	8b 00                	mov    (%rax),%eax
  804784:	48 89 ce             	mov    %rcx,%rsi
  804787:	89 c7                	mov    %eax,%edi
  804789:	48 b8 b3 3d 80 00 00 	movabs $0x803db3,%rax
  804790:	00 00 00 
  804793:	ff d0                	callq  *%rax
  804795:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  804798:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80479c:	7e 13                	jle    8047b1 <writebuf+0x5c>
			b->result += result;
  80479e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8047a2:	8b 50 08             	mov    0x8(%rax),%edx
  8047a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047a8:	01 c2                	add    %eax,%edx
  8047aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8047ae:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  8047b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8047b5:	8b 40 04             	mov    0x4(%rax),%eax
  8047b8:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8047bb:	74 16                	je     8047d3 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  8047bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8047c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8047c6:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  8047ca:	89 c2                	mov    %eax,%edx
  8047cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8047d0:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  8047d3:	c9                   	leaveq 
  8047d4:	c3                   	retq   

00000000008047d5 <putch>:

static void
putch(int ch, void *thunk)
{
  8047d5:	55                   	push   %rbp
  8047d6:	48 89 e5             	mov    %rsp,%rbp
  8047d9:	48 83 ec 20          	sub    $0x20,%rsp
  8047dd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8047e0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  8047e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8047e8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  8047ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8047f0:	8b 40 04             	mov    0x4(%rax),%eax
  8047f3:	8d 48 01             	lea    0x1(%rax),%ecx
  8047f6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8047fa:	89 4a 04             	mov    %ecx,0x4(%rdx)
  8047fd:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804800:	89 d1                	mov    %edx,%ecx
  804802:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804806:	48 98                	cltq   
  804808:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  80480c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804810:	8b 40 04             	mov    0x4(%rax),%eax
  804813:	3d 00 01 00 00       	cmp    $0x100,%eax
  804818:	75 1e                	jne    804838 <putch+0x63>
		writebuf(b);
  80481a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80481e:	48 89 c7             	mov    %rax,%rdi
  804821:	48 b8 55 47 80 00 00 	movabs $0x804755,%rax
  804828:	00 00 00 
  80482b:	ff d0                	callq  *%rax
		b->idx = 0;
  80482d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804831:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  804838:	c9                   	leaveq 
  804839:	c3                   	retq   

000000000080483a <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  80483a:	55                   	push   %rbp
  80483b:	48 89 e5             	mov    %rsp,%rbp
  80483e:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  804845:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  80484b:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  804852:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  804859:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  80485f:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  804865:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80486c:	00 00 00 
	b.result = 0;
  80486f:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  804876:	00 00 00 
	b.error = 1;
  804879:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  804880:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  804883:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  80488a:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  804891:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  804898:	48 89 c6             	mov    %rax,%rsi
  80489b:	48 bf d5 47 80 00 00 	movabs $0x8047d5,%rdi
  8048a2:	00 00 00 
  8048a5:	48 b8 10 18 80 00 00 	movabs $0x801810,%rax
  8048ac:	00 00 00 
  8048af:	ff d0                	callq  *%rax
	if (b.idx > 0)
  8048b1:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  8048b7:	85 c0                	test   %eax,%eax
  8048b9:	7e 16                	jle    8048d1 <vfprintf+0x97>
		writebuf(&b);
  8048bb:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8048c2:	48 89 c7             	mov    %rax,%rdi
  8048c5:	48 b8 55 47 80 00 00 	movabs $0x804755,%rax
  8048cc:	00 00 00 
  8048cf:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  8048d1:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  8048d7:	85 c0                	test   %eax,%eax
  8048d9:	74 08                	je     8048e3 <vfprintf+0xa9>
  8048db:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  8048e1:	eb 06                	jmp    8048e9 <vfprintf+0xaf>
  8048e3:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  8048e9:	c9                   	leaveq 
  8048ea:	c3                   	retq   

00000000008048eb <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  8048eb:	55                   	push   %rbp
  8048ec:	48 89 e5             	mov    %rsp,%rbp
  8048ef:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  8048f6:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  8048fc:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  804903:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80490a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  804911:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  804918:	84 c0                	test   %al,%al
  80491a:	74 20                	je     80493c <fprintf+0x51>
  80491c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  804920:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  804924:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  804928:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80492c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  804930:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  804934:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  804938:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80493c:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  804943:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  80494a:	00 00 00 
  80494d:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  804954:	00 00 00 
  804957:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80495b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  804962:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  804969:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  804970:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  804977:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  80497e:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  804984:	48 89 ce             	mov    %rcx,%rsi
  804987:	89 c7                	mov    %eax,%edi
  804989:	48 b8 3a 48 80 00 00 	movabs $0x80483a,%rax
  804990:	00 00 00 
  804993:	ff d0                	callq  *%rax
  804995:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  80499b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8049a1:	c9                   	leaveq 
  8049a2:	c3                   	retq   

00000000008049a3 <printf>:

int
printf(const char *fmt, ...)
{
  8049a3:	55                   	push   %rbp
  8049a4:	48 89 e5             	mov    %rsp,%rbp
  8049a7:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  8049ae:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8049b5:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8049bc:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8049c3:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8049ca:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8049d1:	84 c0                	test   %al,%al
  8049d3:	74 20                	je     8049f5 <printf+0x52>
  8049d5:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8049d9:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8049dd:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8049e1:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8049e5:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8049e9:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8049ed:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8049f1:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8049f5:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8049fc:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  804a03:	00 00 00 
  804a06:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  804a0d:	00 00 00 
  804a10:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804a14:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  804a1b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  804a22:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  804a29:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  804a30:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  804a37:	48 89 c6             	mov    %rax,%rsi
  804a3a:	bf 01 00 00 00       	mov    $0x1,%edi
  804a3f:	48 b8 3a 48 80 00 00 	movabs $0x80483a,%rax
  804a46:	00 00 00 
  804a49:	ff d0                	callq  *%rax
  804a4b:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  804a51:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  804a57:	c9                   	leaveq 
  804a58:	c3                   	retq   

0000000000804a59 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  804a59:	55                   	push   %rbp
  804a5a:	48 89 e5             	mov    %rsp,%rbp
  804a5d:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  804a64:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  804a6b:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  804a72:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  804a79:	be 00 00 00 00       	mov    $0x0,%esi
  804a7e:	48 89 c7             	mov    %rax,%rdi
  804a81:	48 b8 3f 41 80 00 00 	movabs $0x80413f,%rax
  804a88:	00 00 00 
  804a8b:	ff d0                	callq  *%rax
  804a8d:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804a90:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804a94:	79 08                	jns    804a9e <spawn+0x45>
		return r;
  804a96:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804a99:	e9 14 03 00 00       	jmpq   804db2 <spawn+0x359>
	fd = r;
  804a9e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804aa1:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  804aa4:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  804aab:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  804aaf:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  804ab6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804ab9:	ba 00 02 00 00       	mov    $0x200,%edx
  804abe:	48 89 ce             	mov    %rcx,%rsi
  804ac1:	89 c7                	mov    %eax,%edi
  804ac3:	48 b8 3e 3d 80 00 00 	movabs $0x803d3e,%rax
  804aca:	00 00 00 
  804acd:	ff d0                	callq  *%rax
  804acf:	3d 00 02 00 00       	cmp    $0x200,%eax
  804ad4:	75 0d                	jne    804ae3 <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  804ad6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804ada:	8b 00                	mov    (%rax),%eax
  804adc:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  804ae1:	74 43                	je     804b26 <spawn+0xcd>
		close(fd);
  804ae3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804ae6:	89 c7                	mov    %eax,%edi
  804ae8:	48 b8 47 3a 80 00 00 	movabs $0x803a47,%rax
  804aef:	00 00 00 
  804af2:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  804af4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804af8:	8b 00                	mov    (%rax),%eax
  804afa:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  804aff:	89 c6                	mov    %eax,%esi
  804b01:	48 bf 68 71 80 00 00 	movabs $0x807168,%rdi
  804b08:	00 00 00 
  804b0b:	b8 00 00 00 00       	mov    $0x0,%eax
  804b10:	48 b9 5d 14 80 00 00 	movabs $0x80145d,%rcx
  804b17:	00 00 00 
  804b1a:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  804b1c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  804b21:	e9 8c 02 00 00       	jmpq   804db2 <spawn+0x359>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  804b26:	b8 07 00 00 00       	mov    $0x7,%eax
  804b2b:	cd 30                	int    $0x30
  804b2d:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  804b30:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  804b33:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804b36:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804b3a:	79 08                	jns    804b44 <spawn+0xeb>
		return r;
  804b3c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804b3f:	e9 6e 02 00 00       	jmpq   804db2 <spawn+0x359>
	child = r;
  804b44:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804b47:	89 45 d4             	mov    %eax,-0x2c(%rbp)
	//thisenv = &envs[ENVX(sys_getenvid())];
	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  804b4a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804b4d:	25 ff 03 00 00       	and    $0x3ff,%eax
  804b52:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804b59:	00 00 00 
  804b5c:	48 63 d0             	movslq %eax,%rdx
  804b5f:	48 89 d0             	mov    %rdx,%rax
  804b62:	48 c1 e0 03          	shl    $0x3,%rax
  804b66:	48 01 d0             	add    %rdx,%rax
  804b69:	48 c1 e0 05          	shl    $0x5,%rax
  804b6d:	48 01 c8             	add    %rcx,%rax
  804b70:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  804b77:	48 89 c6             	mov    %rax,%rsi
  804b7a:	b8 18 00 00 00       	mov    $0x18,%eax
  804b7f:	48 89 d7             	mov    %rdx,%rdi
  804b82:	48 89 c1             	mov    %rax,%rcx
  804b85:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  804b88:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804b8c:	48 8b 40 18          	mov    0x18(%rax),%rax
  804b90:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  804b97:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  804b9e:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  804ba5:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  804bac:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804baf:	48 89 ce             	mov    %rcx,%rsi
  804bb2:	89 c7                	mov    %eax,%edi
  804bb4:	48 b8 1c 50 80 00 00 	movabs $0x80501c,%rax
  804bbb:	00 00 00 
  804bbe:	ff d0                	callq  *%rax
  804bc0:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804bc3:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804bc7:	79 08                	jns    804bd1 <spawn+0x178>
		return r;
  804bc9:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804bcc:	e9 e1 01 00 00       	jmpq   804db2 <spawn+0x359>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  804bd1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804bd5:	48 8b 40 20          	mov    0x20(%rax),%rax
  804bd9:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  804be0:	48 01 d0             	add    %rdx,%rax
  804be3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  804be7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804bee:	e9 a3 00 00 00       	jmpq   804c96 <spawn+0x23d>
		if (ph->p_type != ELF_PROG_LOAD)
  804bf3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804bf7:	8b 00                	mov    (%rax),%eax
  804bf9:	83 f8 01             	cmp    $0x1,%eax
  804bfc:	74 05                	je     804c03 <spawn+0x1aa>
			continue;
  804bfe:	e9 8a 00 00 00       	jmpq   804c8d <spawn+0x234>
		perm = PTE_P | PTE_U;
  804c03:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  804c0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c0e:	8b 40 04             	mov    0x4(%rax),%eax
  804c11:	83 e0 02             	and    $0x2,%eax
  804c14:	85 c0                	test   %eax,%eax
  804c16:	74 04                	je     804c1c <spawn+0x1c3>
			perm |= PTE_W;
  804c18:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  804c1c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c20:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  804c24:	41 89 c1             	mov    %eax,%r9d
  804c27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c2b:	4c 8b 40 20          	mov    0x20(%rax),%r8
  804c2f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c33:	48 8b 50 28          	mov    0x28(%rax),%rdx
  804c37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c3b:	48 8b 70 10          	mov    0x10(%rax),%rsi
  804c3f:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  804c42:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804c45:	8b 7d ec             	mov    -0x14(%rbp),%edi
  804c48:	89 3c 24             	mov    %edi,(%rsp)
  804c4b:	89 c7                	mov    %eax,%edi
  804c4d:	48 b8 c5 52 80 00 00 	movabs $0x8052c5,%rax
  804c54:	00 00 00 
  804c57:	ff d0                	callq  *%rax
  804c59:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804c5c:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804c60:	79 2b                	jns    804c8d <spawn+0x234>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  804c62:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  804c63:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804c66:	89 c7                	mov    %eax,%edi
  804c68:	48 b8 db 29 80 00 00 	movabs $0x8029db,%rax
  804c6f:	00 00 00 
  804c72:	ff d0                	callq  *%rax
	close(fd);
  804c74:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804c77:	89 c7                	mov    %eax,%edi
  804c79:	48 b8 47 3a 80 00 00 	movabs $0x803a47,%rax
  804c80:	00 00 00 
  804c83:	ff d0                	callq  *%rax
	return r;
  804c85:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804c88:	e9 25 01 00 00       	jmpq   804db2 <spawn+0x359>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  804c8d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804c91:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  804c96:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804c9a:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  804c9e:	0f b7 c0             	movzwl %ax,%eax
  804ca1:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  804ca4:	0f 8f 49 ff ff ff    	jg     804bf3 <spawn+0x19a>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  804caa:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804cad:	89 c7                	mov    %eax,%edi
  804caf:	48 b8 47 3a 80 00 00 	movabs $0x803a47,%rax
  804cb6:	00 00 00 
  804cb9:	ff d0                	callq  *%rax
	fd = -1;
  804cbb:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  804cc2:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804cc5:	89 c7                	mov    %eax,%edi
  804cc7:	48 b8 b1 54 80 00 00 	movabs $0x8054b1,%rax
  804cce:	00 00 00 
  804cd1:	ff d0                	callq  *%rax
  804cd3:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804cd6:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804cda:	79 30                	jns    804d0c <spawn+0x2b3>
		panic("copy_shared_pages: %e", r);
  804cdc:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804cdf:	89 c1                	mov    %eax,%ecx
  804ce1:	48 ba 82 71 80 00 00 	movabs $0x807182,%rdx
  804ce8:	00 00 00 
  804ceb:	be 82 00 00 00       	mov    $0x82,%esi
  804cf0:	48 bf 98 71 80 00 00 	movabs $0x807198,%rdi
  804cf7:	00 00 00 
  804cfa:	b8 00 00 00 00       	mov    $0x0,%eax
  804cff:	49 b8 24 12 80 00 00 	movabs $0x801224,%r8
  804d06:	00 00 00 
  804d09:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  804d0c:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  804d13:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804d16:	48 89 d6             	mov    %rdx,%rsi
  804d19:	89 c7                	mov    %eax,%edi
  804d1b:	48 b8 db 2b 80 00 00 	movabs $0x802bdb,%rax
  804d22:	00 00 00 
  804d25:	ff d0                	callq  *%rax
  804d27:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804d2a:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804d2e:	79 30                	jns    804d60 <spawn+0x307>
		panic("sys_env_set_trapframe: %e", r);
  804d30:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804d33:	89 c1                	mov    %eax,%ecx
  804d35:	48 ba a4 71 80 00 00 	movabs $0x8071a4,%rdx
  804d3c:	00 00 00 
  804d3f:	be 85 00 00 00       	mov    $0x85,%esi
  804d44:	48 bf 98 71 80 00 00 	movabs $0x807198,%rdi
  804d4b:	00 00 00 
  804d4e:	b8 00 00 00 00       	mov    $0x0,%eax
  804d53:	49 b8 24 12 80 00 00 	movabs $0x801224,%r8
  804d5a:	00 00 00 
  804d5d:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  804d60:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804d63:	be 02 00 00 00       	mov    $0x2,%esi
  804d68:	89 c7                	mov    %eax,%edi
  804d6a:	48 b8 90 2b 80 00 00 	movabs $0x802b90,%rax
  804d71:	00 00 00 
  804d74:	ff d0                	callq  *%rax
  804d76:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804d79:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804d7d:	79 30                	jns    804daf <spawn+0x356>
		panic("sys_env_set_status: %e", r);
  804d7f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804d82:	89 c1                	mov    %eax,%ecx
  804d84:	48 ba be 71 80 00 00 	movabs $0x8071be,%rdx
  804d8b:	00 00 00 
  804d8e:	be 88 00 00 00       	mov    $0x88,%esi
  804d93:	48 bf 98 71 80 00 00 	movabs $0x807198,%rdi
  804d9a:	00 00 00 
  804d9d:	b8 00 00 00 00       	mov    $0x0,%eax
  804da2:	49 b8 24 12 80 00 00 	movabs $0x801224,%r8
  804da9:	00 00 00 
  804dac:	41 ff d0             	callq  *%r8

	return child;
  804daf:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  804db2:	c9                   	leaveq 
  804db3:	c3                   	retq   

0000000000804db4 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  804db4:	55                   	push   %rbp
  804db5:	48 89 e5             	mov    %rsp,%rbp
  804db8:	41 55                	push   %r13
  804dba:	41 54                	push   %r12
  804dbc:	53                   	push   %rbx
  804dbd:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  804dc4:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  804dcb:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  804dd2:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  804dd9:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  804de0:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  804de7:	84 c0                	test   %al,%al
  804de9:	74 26                	je     804e11 <spawnl+0x5d>
  804deb:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  804df2:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  804df9:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  804dfd:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  804e01:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  804e05:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  804e09:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  804e0d:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  804e11:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  804e18:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  804e1f:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  804e22:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  804e29:	00 00 00 
  804e2c:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  804e33:	00 00 00 
  804e36:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804e3a:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  804e41:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  804e48:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  804e4f:	eb 07                	jmp    804e58 <spawnl+0xa4>
		argc++;
  804e51:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  804e58:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  804e5e:	83 f8 30             	cmp    $0x30,%eax
  804e61:	73 23                	jae    804e86 <spawnl+0xd2>
  804e63:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  804e6a:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  804e70:	89 c0                	mov    %eax,%eax
  804e72:	48 01 d0             	add    %rdx,%rax
  804e75:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  804e7b:	83 c2 08             	add    $0x8,%edx
  804e7e:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  804e84:	eb 15                	jmp    804e9b <spawnl+0xe7>
  804e86:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  804e8d:	48 89 d0             	mov    %rdx,%rax
  804e90:	48 83 c2 08          	add    $0x8,%rdx
  804e94:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  804e9b:	48 8b 00             	mov    (%rax),%rax
  804e9e:	48 85 c0             	test   %rax,%rax
  804ea1:	75 ae                	jne    804e51 <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  804ea3:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  804ea9:	83 c0 02             	add    $0x2,%eax
  804eac:	48 89 e2             	mov    %rsp,%rdx
  804eaf:	48 89 d3             	mov    %rdx,%rbx
  804eb2:	48 63 d0             	movslq %eax,%rdx
  804eb5:	48 83 ea 01          	sub    $0x1,%rdx
  804eb9:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  804ec0:	48 63 d0             	movslq %eax,%rdx
  804ec3:	49 89 d4             	mov    %rdx,%r12
  804ec6:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  804ecc:	48 63 d0             	movslq %eax,%rdx
  804ecf:	49 89 d2             	mov    %rdx,%r10
  804ed2:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  804ed8:	48 98                	cltq   
  804eda:	48 c1 e0 03          	shl    $0x3,%rax
  804ede:	48 8d 50 07          	lea    0x7(%rax),%rdx
  804ee2:	b8 10 00 00 00       	mov    $0x10,%eax
  804ee7:	48 83 e8 01          	sub    $0x1,%rax
  804eeb:	48 01 d0             	add    %rdx,%rax
  804eee:	bf 10 00 00 00       	mov    $0x10,%edi
  804ef3:	ba 00 00 00 00       	mov    $0x0,%edx
  804ef8:	48 f7 f7             	div    %rdi
  804efb:	48 6b c0 10          	imul   $0x10,%rax,%rax
  804eff:	48 29 c4             	sub    %rax,%rsp
  804f02:	48 89 e0             	mov    %rsp,%rax
  804f05:	48 83 c0 07          	add    $0x7,%rax
  804f09:	48 c1 e8 03          	shr    $0x3,%rax
  804f0d:	48 c1 e0 03          	shl    $0x3,%rax
  804f11:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  804f18:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  804f1f:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  804f26:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  804f29:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  804f2f:	8d 50 01             	lea    0x1(%rax),%edx
  804f32:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  804f39:	48 63 d2             	movslq %edx,%rdx
  804f3c:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  804f43:	00 

	va_start(vl, arg0);
  804f44:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  804f4b:	00 00 00 
  804f4e:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  804f55:	00 00 00 
  804f58:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804f5c:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  804f63:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  804f6a:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  804f71:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  804f78:	00 00 00 
  804f7b:	eb 63                	jmp    804fe0 <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  804f7d:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  804f83:	8d 70 01             	lea    0x1(%rax),%esi
  804f86:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  804f8c:	83 f8 30             	cmp    $0x30,%eax
  804f8f:	73 23                	jae    804fb4 <spawnl+0x200>
  804f91:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  804f98:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  804f9e:	89 c0                	mov    %eax,%eax
  804fa0:	48 01 d0             	add    %rdx,%rax
  804fa3:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  804fa9:	83 c2 08             	add    $0x8,%edx
  804fac:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  804fb2:	eb 15                	jmp    804fc9 <spawnl+0x215>
  804fb4:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  804fbb:	48 89 d0             	mov    %rdx,%rax
  804fbe:	48 83 c2 08          	add    $0x8,%rdx
  804fc2:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  804fc9:	48 8b 08             	mov    (%rax),%rcx
  804fcc:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  804fd3:	89 f2                	mov    %esi,%edx
  804fd5:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  804fd9:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  804fe0:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  804fe6:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  804fec:	77 8f                	ja     804f7d <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  804fee:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  804ff5:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  804ffc:	48 89 d6             	mov    %rdx,%rsi
  804fff:	48 89 c7             	mov    %rax,%rdi
  805002:	48 b8 59 4a 80 00 00 	movabs $0x804a59,%rax
  805009:	00 00 00 
  80500c:	ff d0                	callq  *%rax
  80500e:	48 89 dc             	mov    %rbx,%rsp
}
  805011:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  805015:	5b                   	pop    %rbx
  805016:	41 5c                	pop    %r12
  805018:	41 5d                	pop    %r13
  80501a:	5d                   	pop    %rbp
  80501b:	c3                   	retq   

000000000080501c <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  80501c:	55                   	push   %rbp
  80501d:	48 89 e5             	mov    %rsp,%rbp
  805020:	48 83 ec 50          	sub    $0x50,%rsp
  805024:	89 7d cc             	mov    %edi,-0x34(%rbp)
  805027:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  80502b:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  80502f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  805036:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  805037:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  80503e:	eb 33                	jmp    805073 <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  805040:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805043:	48 98                	cltq   
  805045:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80504c:	00 
  80504d:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  805051:	48 01 d0             	add    %rdx,%rax
  805054:	48 8b 00             	mov    (%rax),%rax
  805057:	48 89 c7             	mov    %rax,%rdi
  80505a:	48 b8 00 21 80 00 00 	movabs $0x802100,%rax
  805061:	00 00 00 
  805064:	ff d0                	callq  *%rax
  805066:	83 c0 01             	add    $0x1,%eax
  805069:	48 98                	cltq   
  80506b:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  80506f:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  805073:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805076:	48 98                	cltq   
  805078:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80507f:	00 
  805080:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  805084:	48 01 d0             	add    %rdx,%rax
  805087:	48 8b 00             	mov    (%rax),%rax
  80508a:	48 85 c0             	test   %rax,%rax
  80508d:	75 b1                	jne    805040 <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  80508f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805093:	48 f7 d8             	neg    %rax
  805096:	48 05 00 10 40 00    	add    $0x401000,%rax
  80509c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  8050a0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8050a4:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8050a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8050ac:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  8050b0:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8050b3:	83 c2 01             	add    $0x1,%edx
  8050b6:	c1 e2 03             	shl    $0x3,%edx
  8050b9:	48 63 d2             	movslq %edx,%rdx
  8050bc:	48 f7 da             	neg    %rdx
  8050bf:	48 01 d0             	add    %rdx,%rax
  8050c2:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8050c6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8050ca:	48 83 e8 10          	sub    $0x10,%rax
  8050ce:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  8050d4:	77 0a                	ja     8050e0 <init_stack+0xc4>
		return -E_NO_MEM;
  8050d6:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  8050db:	e9 e3 01 00 00       	jmpq   8052c3 <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8050e0:	ba 07 00 00 00       	mov    $0x7,%edx
  8050e5:	be 00 00 40 00       	mov    $0x400000,%esi
  8050ea:	bf 00 00 00 00       	mov    $0x0,%edi
  8050ef:	48 b8 9b 2a 80 00 00 	movabs $0x802a9b,%rax
  8050f6:	00 00 00 
  8050f9:	ff d0                	callq  *%rax
  8050fb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8050fe:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805102:	79 08                	jns    80510c <init_stack+0xf0>
		return r;
  805104:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805107:	e9 b7 01 00 00       	jmpq   8052c3 <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  80510c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  805113:	e9 8a 00 00 00       	jmpq   8051a2 <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  805118:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80511b:	48 98                	cltq   
  80511d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  805124:	00 
  805125:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805129:	48 01 c2             	add    %rax,%rdx
  80512c:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  805131:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805135:	48 01 c8             	add    %rcx,%rax
  805138:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  80513e:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  805141:	8b 45 f0             	mov    -0x10(%rbp),%eax
  805144:	48 98                	cltq   
  805146:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80514d:	00 
  80514e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  805152:	48 01 d0             	add    %rdx,%rax
  805155:	48 8b 10             	mov    (%rax),%rdx
  805158:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80515c:	48 89 d6             	mov    %rdx,%rsi
  80515f:	48 89 c7             	mov    %rax,%rdi
  805162:	48 b8 6c 21 80 00 00 	movabs $0x80216c,%rax
  805169:	00 00 00 
  80516c:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  80516e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  805171:	48 98                	cltq   
  805173:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80517a:	00 
  80517b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80517f:	48 01 d0             	add    %rdx,%rax
  805182:	48 8b 00             	mov    (%rax),%rax
  805185:	48 89 c7             	mov    %rax,%rdi
  805188:	48 b8 00 21 80 00 00 	movabs $0x802100,%rax
  80518f:	00 00 00 
  805192:	ff d0                	callq  *%rax
  805194:	48 98                	cltq   
  805196:	48 83 c0 01          	add    $0x1,%rax
  80519a:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  80519e:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  8051a2:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8051a5:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8051a8:	0f 8c 6a ff ff ff    	jl     805118 <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  8051ae:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8051b1:	48 98                	cltq   
  8051b3:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8051ba:	00 
  8051bb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8051bf:	48 01 d0             	add    %rdx,%rax
  8051c2:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8051c9:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  8051d0:	00 
  8051d1:	74 35                	je     805208 <init_stack+0x1ec>
  8051d3:	48 b9 d8 71 80 00 00 	movabs $0x8071d8,%rcx
  8051da:	00 00 00 
  8051dd:	48 ba fe 71 80 00 00 	movabs $0x8071fe,%rdx
  8051e4:	00 00 00 
  8051e7:	be f1 00 00 00       	mov    $0xf1,%esi
  8051ec:	48 bf 98 71 80 00 00 	movabs $0x807198,%rdi
  8051f3:	00 00 00 
  8051f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8051fb:	49 b8 24 12 80 00 00 	movabs $0x801224,%r8
  805202:	00 00 00 
  805205:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  805208:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80520c:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  805210:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  805215:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805219:	48 01 c8             	add    %rcx,%rax
  80521c:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  805222:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  805225:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805229:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  80522d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805230:	48 98                	cltq   
  805232:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  805235:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  80523a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80523e:	48 01 d0             	add    %rdx,%rax
  805241:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  805247:	48 89 c2             	mov    %rax,%rdx
  80524a:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  80524e:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  805251:	8b 45 cc             	mov    -0x34(%rbp),%eax
  805254:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80525a:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  80525f:	89 c2                	mov    %eax,%edx
  805261:	be 00 00 40 00       	mov    $0x400000,%esi
  805266:	bf 00 00 00 00       	mov    $0x0,%edi
  80526b:	48 b8 eb 2a 80 00 00 	movabs $0x802aeb,%rax
  805272:	00 00 00 
  805275:	ff d0                	callq  *%rax
  805277:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80527a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80527e:	79 02                	jns    805282 <init_stack+0x266>
		goto error;
  805280:	eb 28                	jmp    8052aa <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  805282:	be 00 00 40 00       	mov    $0x400000,%esi
  805287:	bf 00 00 00 00       	mov    $0x0,%edi
  80528c:	48 b8 46 2b 80 00 00 	movabs $0x802b46,%rax
  805293:	00 00 00 
  805296:	ff d0                	callq  *%rax
  805298:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80529b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80529f:	79 02                	jns    8052a3 <init_stack+0x287>
		goto error;
  8052a1:	eb 07                	jmp    8052aa <init_stack+0x28e>

	return 0;
  8052a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8052a8:	eb 19                	jmp    8052c3 <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  8052aa:	be 00 00 40 00       	mov    $0x400000,%esi
  8052af:	bf 00 00 00 00       	mov    $0x0,%edi
  8052b4:	48 b8 46 2b 80 00 00 	movabs $0x802b46,%rax
  8052bb:	00 00 00 
  8052be:	ff d0                	callq  *%rax
	return r;
  8052c0:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8052c3:	c9                   	leaveq 
  8052c4:	c3                   	retq   

00000000008052c5 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  8052c5:	55                   	push   %rbp
  8052c6:	48 89 e5             	mov    %rsp,%rbp
  8052c9:	48 83 ec 50          	sub    $0x50,%rsp
  8052cd:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8052d0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8052d4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8052d8:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  8052db:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8052df:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  8052e3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8052e7:	25 ff 0f 00 00       	and    $0xfff,%eax
  8052ec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8052ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8052f3:	74 21                	je     805316 <map_segment+0x51>
		va -= i;
  8052f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8052f8:	48 98                	cltq   
  8052fa:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  8052fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805301:	48 98                	cltq   
  805303:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  805307:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80530a:	48 98                	cltq   
  80530c:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  805310:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805313:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  805316:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80531d:	e9 79 01 00 00       	jmpq   80549b <map_segment+0x1d6>
		if (i >= filesz) {
  805322:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805325:	48 98                	cltq   
  805327:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  80532b:	72 3c                	jb     805369 <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  80532d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805330:	48 63 d0             	movslq %eax,%rdx
  805333:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805337:	48 01 d0             	add    %rdx,%rax
  80533a:	48 89 c1             	mov    %rax,%rcx
  80533d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805340:	8b 55 10             	mov    0x10(%rbp),%edx
  805343:	48 89 ce             	mov    %rcx,%rsi
  805346:	89 c7                	mov    %eax,%edi
  805348:	48 b8 9b 2a 80 00 00 	movabs $0x802a9b,%rax
  80534f:	00 00 00 
  805352:	ff d0                	callq  *%rax
  805354:	89 45 f8             	mov    %eax,-0x8(%rbp)
  805357:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80535b:	0f 89 33 01 00 00    	jns    805494 <map_segment+0x1cf>
				return r;
  805361:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805364:	e9 46 01 00 00       	jmpq   8054af <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  805369:	ba 07 00 00 00       	mov    $0x7,%edx
  80536e:	be 00 00 40 00       	mov    $0x400000,%esi
  805373:	bf 00 00 00 00       	mov    $0x0,%edi
  805378:	48 b8 9b 2a 80 00 00 	movabs $0x802a9b,%rax
  80537f:	00 00 00 
  805382:	ff d0                	callq  *%rax
  805384:	89 45 f8             	mov    %eax,-0x8(%rbp)
  805387:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80538b:	79 08                	jns    805395 <map_segment+0xd0>
				return r;
  80538d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805390:	e9 1a 01 00 00       	jmpq   8054af <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  805395:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805398:	8b 55 bc             	mov    -0x44(%rbp),%edx
  80539b:	01 c2                	add    %eax,%edx
  80539d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8053a0:	89 d6                	mov    %edx,%esi
  8053a2:	89 c7                	mov    %eax,%edi
  8053a4:	48 b8 87 3e 80 00 00 	movabs $0x803e87,%rax
  8053ab:	00 00 00 
  8053ae:	ff d0                	callq  *%rax
  8053b0:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8053b3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8053b7:	79 08                	jns    8053c1 <map_segment+0xfc>
				return r;
  8053b9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8053bc:	e9 ee 00 00 00       	jmpq   8054af <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8053c1:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  8053c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8053cb:	48 98                	cltq   
  8053cd:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8053d1:	48 29 c2             	sub    %rax,%rdx
  8053d4:	48 89 d0             	mov    %rdx,%rax
  8053d7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8053db:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8053de:	48 63 d0             	movslq %eax,%rdx
  8053e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8053e5:	48 39 c2             	cmp    %rax,%rdx
  8053e8:	48 0f 47 d0          	cmova  %rax,%rdx
  8053ec:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8053ef:	be 00 00 40 00       	mov    $0x400000,%esi
  8053f4:	89 c7                	mov    %eax,%edi
  8053f6:	48 b8 3e 3d 80 00 00 	movabs $0x803d3e,%rax
  8053fd:	00 00 00 
  805400:	ff d0                	callq  *%rax
  805402:	89 45 f8             	mov    %eax,-0x8(%rbp)
  805405:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  805409:	79 08                	jns    805413 <map_segment+0x14e>
				return r;
  80540b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80540e:	e9 9c 00 00 00       	jmpq   8054af <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  805413:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805416:	48 63 d0             	movslq %eax,%rdx
  805419:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80541d:	48 01 d0             	add    %rdx,%rax
  805420:	48 89 c2             	mov    %rax,%rdx
  805423:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805426:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  80542a:	48 89 d1             	mov    %rdx,%rcx
  80542d:	89 c2                	mov    %eax,%edx
  80542f:	be 00 00 40 00       	mov    $0x400000,%esi
  805434:	bf 00 00 00 00       	mov    $0x0,%edi
  805439:	48 b8 eb 2a 80 00 00 	movabs $0x802aeb,%rax
  805440:	00 00 00 
  805443:	ff d0                	callq  *%rax
  805445:	89 45 f8             	mov    %eax,-0x8(%rbp)
  805448:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80544c:	79 30                	jns    80547e <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  80544e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805451:	89 c1                	mov    %eax,%ecx
  805453:	48 ba 13 72 80 00 00 	movabs $0x807213,%rdx
  80545a:	00 00 00 
  80545d:	be 24 01 00 00       	mov    $0x124,%esi
  805462:	48 bf 98 71 80 00 00 	movabs $0x807198,%rdi
  805469:	00 00 00 
  80546c:	b8 00 00 00 00       	mov    $0x0,%eax
  805471:	49 b8 24 12 80 00 00 	movabs $0x801224,%r8
  805478:	00 00 00 
  80547b:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  80547e:	be 00 00 40 00       	mov    $0x400000,%esi
  805483:	bf 00 00 00 00       	mov    $0x0,%edi
  805488:	48 b8 46 2b 80 00 00 	movabs $0x802b46,%rax
  80548f:	00 00 00 
  805492:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  805494:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  80549b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80549e:	48 98                	cltq   
  8054a0:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8054a4:	0f 82 78 fe ff ff    	jb     805322 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  8054aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8054af:	c9                   	leaveq 
  8054b0:	c3                   	retq   

00000000008054b1 <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  8054b1:	55                   	push   %rbp
  8054b2:	48 89 e5             	mov    %rsp,%rbp
  8054b5:	48 83 ec 20          	sub    $0x20,%rsp
  8054b9:	89 7d ec             	mov    %edi,-0x14(%rbp)
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  8054bc:	48 c7 45 f8 00 00 80 	movq   $0x800000,-0x8(%rbp)
  8054c3:	00 
  8054c4:	e9 c9 00 00 00       	jmpq   805592 <copy_shared_pages+0xe1>
        {
            if(!((uvpml4e[VPML4E(addr)])&&(uvpde[VPDPE(addr)]) && (uvpd[VPD(addr)]  )))
  8054c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8054cd:	48 c1 e8 27          	shr    $0x27,%rax
  8054d1:	48 89 c2             	mov    %rax,%rdx
  8054d4:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8054db:	01 00 00 
  8054de:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8054e2:	48 85 c0             	test   %rax,%rax
  8054e5:	74 3c                	je     805523 <copy_shared_pages+0x72>
  8054e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8054eb:	48 c1 e8 1e          	shr    $0x1e,%rax
  8054ef:	48 89 c2             	mov    %rax,%rdx
  8054f2:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8054f9:	01 00 00 
  8054fc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805500:	48 85 c0             	test   %rax,%rax
  805503:	74 1e                	je     805523 <copy_shared_pages+0x72>
  805505:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805509:	48 c1 e8 15          	shr    $0x15,%rax
  80550d:	48 89 c2             	mov    %rax,%rdx
  805510:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  805517:	01 00 00 
  80551a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80551e:	48 85 c0             	test   %rax,%rax
  805521:	75 02                	jne    805525 <copy_shared_pages+0x74>
                continue;
  805523:	eb 65                	jmp    80558a <copy_shared_pages+0xd9>

            if((uvpt[VPN(addr)] & PTE_SHARE) != 0)
  805525:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805529:	48 c1 e8 0c          	shr    $0xc,%rax
  80552d:	48 89 c2             	mov    %rax,%rdx
  805530:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805537:	01 00 00 
  80553a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80553e:	25 00 04 00 00       	and    $0x400,%eax
  805543:	48 85 c0             	test   %rax,%rax
  805546:	74 42                	je     80558a <copy_shared_pages+0xd9>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);
  805548:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80554c:	48 c1 e8 0c          	shr    $0xc,%rax
  805550:	48 89 c2             	mov    %rax,%rdx
  805553:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80555a:	01 00 00 
  80555d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805561:	25 07 0e 00 00       	and    $0xe07,%eax
  805566:	89 c6                	mov    %eax,%esi
  805568:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80556c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805570:	8b 55 ec             	mov    -0x14(%rbp),%edx
  805573:	41 89 f0             	mov    %esi,%r8d
  805576:	48 89 c6             	mov    %rax,%rsi
  805579:	bf 00 00 00 00       	mov    $0x0,%edi
  80557e:	48 b8 eb 2a 80 00 00 	movabs $0x802aeb,%rax
  805585:	00 00 00 
  805588:	ff d0                	callq  *%rax
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  80558a:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  805591:	00 
  805592:	48 b8 ff ff 7f 00 80 	movabs $0x80007fffff,%rax
  805599:	00 00 00 
  80559c:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  8055a0:	0f 86 23 ff ff ff    	jbe    8054c9 <copy_shared_pages+0x18>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);

            }
        }
     return 0;
  8055a6:	b8 00 00 00 00       	mov    $0x0,%eax
 }
  8055ab:	c9                   	leaveq 
  8055ac:	c3                   	retq   

00000000008055ad <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8055ad:	55                   	push   %rbp
  8055ae:	48 89 e5             	mov    %rsp,%rbp
  8055b1:	48 83 ec 20          	sub    $0x20,%rsp
  8055b5:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8055b8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8055bc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8055bf:	48 89 d6             	mov    %rdx,%rsi
  8055c2:	89 c7                	mov    %eax,%edi
  8055c4:	48 b8 37 38 80 00 00 	movabs $0x803837,%rax
  8055cb:	00 00 00 
  8055ce:	ff d0                	callq  *%rax
  8055d0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8055d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8055d7:	79 05                	jns    8055de <fd2sockid+0x31>
		return r;
  8055d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8055dc:	eb 24                	jmp    805602 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8055de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8055e2:	8b 10                	mov    (%rax),%edx
  8055e4:	48 b8 e0 90 80 00 00 	movabs $0x8090e0,%rax
  8055eb:	00 00 00 
  8055ee:	8b 00                	mov    (%rax),%eax
  8055f0:	39 c2                	cmp    %eax,%edx
  8055f2:	74 07                	je     8055fb <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  8055f4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8055f9:	eb 07                	jmp    805602 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8055fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8055ff:	8b 40 0c             	mov    0xc(%rax),%eax
}
  805602:	c9                   	leaveq 
  805603:	c3                   	retq   

0000000000805604 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  805604:	55                   	push   %rbp
  805605:	48 89 e5             	mov    %rsp,%rbp
  805608:	48 83 ec 20          	sub    $0x20,%rsp
  80560c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  80560f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  805613:	48 89 c7             	mov    %rax,%rdi
  805616:	48 b8 9f 37 80 00 00 	movabs $0x80379f,%rax
  80561d:	00 00 00 
  805620:	ff d0                	callq  *%rax
  805622:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805625:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805629:	78 26                	js     805651 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80562b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80562f:	ba 07 04 00 00       	mov    $0x407,%edx
  805634:	48 89 c6             	mov    %rax,%rsi
  805637:	bf 00 00 00 00       	mov    $0x0,%edi
  80563c:	48 b8 9b 2a 80 00 00 	movabs $0x802a9b,%rax
  805643:	00 00 00 
  805646:	ff d0                	callq  *%rax
  805648:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80564b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80564f:	79 16                	jns    805667 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  805651:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805654:	89 c7                	mov    %eax,%edi
  805656:	48 b8 11 5b 80 00 00 	movabs $0x805b11,%rax
  80565d:	00 00 00 
  805660:	ff d0                	callq  *%rax
		return r;
  805662:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805665:	eb 3a                	jmp    8056a1 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  805667:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80566b:	48 ba e0 90 80 00 00 	movabs $0x8090e0,%rdx
  805672:	00 00 00 
  805675:	8b 12                	mov    (%rdx),%edx
  805677:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  805679:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80567d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  805684:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805688:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80568b:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  80568e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805692:	48 89 c7             	mov    %rax,%rdi
  805695:	48 b8 51 37 80 00 00 	movabs $0x803751,%rax
  80569c:	00 00 00 
  80569f:	ff d0                	callq  *%rax
}
  8056a1:	c9                   	leaveq 
  8056a2:	c3                   	retq   

00000000008056a3 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8056a3:	55                   	push   %rbp
  8056a4:	48 89 e5             	mov    %rsp,%rbp
  8056a7:	48 83 ec 30          	sub    $0x30,%rsp
  8056ab:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8056ae:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8056b2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8056b6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8056b9:	89 c7                	mov    %eax,%edi
  8056bb:	48 b8 ad 55 80 00 00 	movabs $0x8055ad,%rax
  8056c2:	00 00 00 
  8056c5:	ff d0                	callq  *%rax
  8056c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8056ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8056ce:	79 05                	jns    8056d5 <accept+0x32>
		return r;
  8056d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8056d3:	eb 3b                	jmp    805710 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8056d5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8056d9:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8056dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8056e0:	48 89 ce             	mov    %rcx,%rsi
  8056e3:	89 c7                	mov    %eax,%edi
  8056e5:	48 b8 ee 59 80 00 00 	movabs $0x8059ee,%rax
  8056ec:	00 00 00 
  8056ef:	ff d0                	callq  *%rax
  8056f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8056f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8056f8:	79 05                	jns    8056ff <accept+0x5c>
		return r;
  8056fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8056fd:	eb 11                	jmp    805710 <accept+0x6d>
	return alloc_sockfd(r);
  8056ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805702:	89 c7                	mov    %eax,%edi
  805704:	48 b8 04 56 80 00 00 	movabs $0x805604,%rax
  80570b:	00 00 00 
  80570e:	ff d0                	callq  *%rax
}
  805710:	c9                   	leaveq 
  805711:	c3                   	retq   

0000000000805712 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  805712:	55                   	push   %rbp
  805713:	48 89 e5             	mov    %rsp,%rbp
  805716:	48 83 ec 20          	sub    $0x20,%rsp
  80571a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80571d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805721:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  805724:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805727:	89 c7                	mov    %eax,%edi
  805729:	48 b8 ad 55 80 00 00 	movabs $0x8055ad,%rax
  805730:	00 00 00 
  805733:	ff d0                	callq  *%rax
  805735:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805738:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80573c:	79 05                	jns    805743 <bind+0x31>
		return r;
  80573e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805741:	eb 1b                	jmp    80575e <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  805743:	8b 55 e8             	mov    -0x18(%rbp),%edx
  805746:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80574a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80574d:	48 89 ce             	mov    %rcx,%rsi
  805750:	89 c7                	mov    %eax,%edi
  805752:	48 b8 6d 5a 80 00 00 	movabs $0x805a6d,%rax
  805759:	00 00 00 
  80575c:	ff d0                	callq  *%rax
}
  80575e:	c9                   	leaveq 
  80575f:	c3                   	retq   

0000000000805760 <shutdown>:

int
shutdown(int s, int how)
{
  805760:	55                   	push   %rbp
  805761:	48 89 e5             	mov    %rsp,%rbp
  805764:	48 83 ec 20          	sub    $0x20,%rsp
  805768:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80576b:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80576e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805771:	89 c7                	mov    %eax,%edi
  805773:	48 b8 ad 55 80 00 00 	movabs $0x8055ad,%rax
  80577a:	00 00 00 
  80577d:	ff d0                	callq  *%rax
  80577f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805782:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805786:	79 05                	jns    80578d <shutdown+0x2d>
		return r;
  805788:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80578b:	eb 16                	jmp    8057a3 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  80578d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  805790:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805793:	89 d6                	mov    %edx,%esi
  805795:	89 c7                	mov    %eax,%edi
  805797:	48 b8 d1 5a 80 00 00 	movabs $0x805ad1,%rax
  80579e:	00 00 00 
  8057a1:	ff d0                	callq  *%rax
}
  8057a3:	c9                   	leaveq 
  8057a4:	c3                   	retq   

00000000008057a5 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8057a5:	55                   	push   %rbp
  8057a6:	48 89 e5             	mov    %rsp,%rbp
  8057a9:	48 83 ec 10          	sub    $0x10,%rsp
  8057ad:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8057b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8057b5:	48 89 c7             	mov    %rax,%rdi
  8057b8:	48 b8 49 67 80 00 00 	movabs $0x806749,%rax
  8057bf:	00 00 00 
  8057c2:	ff d0                	callq  *%rax
  8057c4:	83 f8 01             	cmp    $0x1,%eax
  8057c7:	75 17                	jne    8057e0 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8057c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8057cd:	8b 40 0c             	mov    0xc(%rax),%eax
  8057d0:	89 c7                	mov    %eax,%edi
  8057d2:	48 b8 11 5b 80 00 00 	movabs $0x805b11,%rax
  8057d9:	00 00 00 
  8057dc:	ff d0                	callq  *%rax
  8057de:	eb 05                	jmp    8057e5 <devsock_close+0x40>
	else
		return 0;
  8057e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8057e5:	c9                   	leaveq 
  8057e6:	c3                   	retq   

00000000008057e7 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8057e7:	55                   	push   %rbp
  8057e8:	48 89 e5             	mov    %rsp,%rbp
  8057eb:	48 83 ec 20          	sub    $0x20,%rsp
  8057ef:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8057f2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8057f6:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8057f9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8057fc:	89 c7                	mov    %eax,%edi
  8057fe:	48 b8 ad 55 80 00 00 	movabs $0x8055ad,%rax
  805805:	00 00 00 
  805808:	ff d0                	callq  *%rax
  80580a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80580d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805811:	79 05                	jns    805818 <connect+0x31>
		return r;
  805813:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805816:	eb 1b                	jmp    805833 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  805818:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80581b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80581f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805822:	48 89 ce             	mov    %rcx,%rsi
  805825:	89 c7                	mov    %eax,%edi
  805827:	48 b8 3e 5b 80 00 00 	movabs $0x805b3e,%rax
  80582e:	00 00 00 
  805831:	ff d0                	callq  *%rax
}
  805833:	c9                   	leaveq 
  805834:	c3                   	retq   

0000000000805835 <listen>:

int
listen(int s, int backlog)
{
  805835:	55                   	push   %rbp
  805836:	48 89 e5             	mov    %rsp,%rbp
  805839:	48 83 ec 20          	sub    $0x20,%rsp
  80583d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805840:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  805843:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805846:	89 c7                	mov    %eax,%edi
  805848:	48 b8 ad 55 80 00 00 	movabs $0x8055ad,%rax
  80584f:	00 00 00 
  805852:	ff d0                	callq  *%rax
  805854:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805857:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80585b:	79 05                	jns    805862 <listen+0x2d>
		return r;
  80585d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805860:	eb 16                	jmp    805878 <listen+0x43>
	return nsipc_listen(r, backlog);
  805862:	8b 55 e8             	mov    -0x18(%rbp),%edx
  805865:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805868:	89 d6                	mov    %edx,%esi
  80586a:	89 c7                	mov    %eax,%edi
  80586c:	48 b8 a2 5b 80 00 00 	movabs $0x805ba2,%rax
  805873:	00 00 00 
  805876:	ff d0                	callq  *%rax
}
  805878:	c9                   	leaveq 
  805879:	c3                   	retq   

000000000080587a <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80587a:	55                   	push   %rbp
  80587b:	48 89 e5             	mov    %rsp,%rbp
  80587e:	48 83 ec 20          	sub    $0x20,%rsp
  805882:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  805886:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80588a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80588e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805892:	89 c2                	mov    %eax,%edx
  805894:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805898:	8b 40 0c             	mov    0xc(%rax),%eax
  80589b:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80589f:	b9 00 00 00 00       	mov    $0x0,%ecx
  8058a4:	89 c7                	mov    %eax,%edi
  8058a6:	48 b8 e2 5b 80 00 00 	movabs $0x805be2,%rax
  8058ad:	00 00 00 
  8058b0:	ff d0                	callq  *%rax
}
  8058b2:	c9                   	leaveq 
  8058b3:	c3                   	retq   

00000000008058b4 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8058b4:	55                   	push   %rbp
  8058b5:	48 89 e5             	mov    %rsp,%rbp
  8058b8:	48 83 ec 20          	sub    $0x20,%rsp
  8058bc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8058c0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8058c4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8058c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8058cc:	89 c2                	mov    %eax,%edx
  8058ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8058d2:	8b 40 0c             	mov    0xc(%rax),%eax
  8058d5:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8058d9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8058de:	89 c7                	mov    %eax,%edi
  8058e0:	48 b8 ae 5c 80 00 00 	movabs $0x805cae,%rax
  8058e7:	00 00 00 
  8058ea:	ff d0                	callq  *%rax
}
  8058ec:	c9                   	leaveq 
  8058ed:	c3                   	retq   

00000000008058ee <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8058ee:	55                   	push   %rbp
  8058ef:	48 89 e5             	mov    %rsp,%rbp
  8058f2:	48 83 ec 10          	sub    $0x10,%rsp
  8058f6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8058fa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8058fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805902:	48 be 35 72 80 00 00 	movabs $0x807235,%rsi
  805909:	00 00 00 
  80590c:	48 89 c7             	mov    %rax,%rdi
  80590f:	48 b8 6c 21 80 00 00 	movabs $0x80216c,%rax
  805916:	00 00 00 
  805919:	ff d0                	callq  *%rax
	return 0;
  80591b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805920:	c9                   	leaveq 
  805921:	c3                   	retq   

0000000000805922 <socket>:

int
socket(int domain, int type, int protocol)
{
  805922:	55                   	push   %rbp
  805923:	48 89 e5             	mov    %rsp,%rbp
  805926:	48 83 ec 20          	sub    $0x20,%rsp
  80592a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80592d:	89 75 e8             	mov    %esi,-0x18(%rbp)
  805930:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  805933:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  805936:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  805939:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80593c:	89 ce                	mov    %ecx,%esi
  80593e:	89 c7                	mov    %eax,%edi
  805940:	48 b8 66 5d 80 00 00 	movabs $0x805d66,%rax
  805947:	00 00 00 
  80594a:	ff d0                	callq  *%rax
  80594c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80594f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805953:	79 05                	jns    80595a <socket+0x38>
		return r;
  805955:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805958:	eb 11                	jmp    80596b <socket+0x49>
	return alloc_sockfd(r);
  80595a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80595d:	89 c7                	mov    %eax,%edi
  80595f:	48 b8 04 56 80 00 00 	movabs $0x805604,%rax
  805966:	00 00 00 
  805969:	ff d0                	callq  *%rax
}
  80596b:	c9                   	leaveq 
  80596c:	c3                   	retq   

000000000080596d <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80596d:	55                   	push   %rbp
  80596e:	48 89 e5             	mov    %rsp,%rbp
  805971:	48 83 ec 10          	sub    $0x10,%rsp
  805975:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  805978:	48 b8 24 a4 80 00 00 	movabs $0x80a424,%rax
  80597f:	00 00 00 
  805982:	8b 00                	mov    (%rax),%eax
  805984:	85 c0                	test   %eax,%eax
  805986:	75 1d                	jne    8059a5 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  805988:	bf 02 00 00 00       	mov    $0x2,%edi
  80598d:	48 b8 c7 66 80 00 00 	movabs $0x8066c7,%rax
  805994:	00 00 00 
  805997:	ff d0                	callq  *%rax
  805999:	48 ba 24 a4 80 00 00 	movabs $0x80a424,%rdx
  8059a0:	00 00 00 
  8059a3:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8059a5:	48 b8 24 a4 80 00 00 	movabs $0x80a424,%rax
  8059ac:	00 00 00 
  8059af:	8b 00                	mov    (%rax),%eax
  8059b1:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8059b4:	b9 07 00 00 00       	mov    $0x7,%ecx
  8059b9:	48 ba 00 d0 80 00 00 	movabs $0x80d000,%rdx
  8059c0:	00 00 00 
  8059c3:	89 c7                	mov    %eax,%edi
  8059c5:	48 b8 65 66 80 00 00 	movabs $0x806665,%rax
  8059cc:	00 00 00 
  8059cf:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8059d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8059d6:	be 00 00 00 00       	mov    $0x0,%esi
  8059db:	bf 00 00 00 00       	mov    $0x0,%edi
  8059e0:	48 b8 5f 65 80 00 00 	movabs $0x80655f,%rax
  8059e7:	00 00 00 
  8059ea:	ff d0                	callq  *%rax
}
  8059ec:	c9                   	leaveq 
  8059ed:	c3                   	retq   

00000000008059ee <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8059ee:	55                   	push   %rbp
  8059ef:	48 89 e5             	mov    %rsp,%rbp
  8059f2:	48 83 ec 30          	sub    $0x30,%rsp
  8059f6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8059f9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8059fd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  805a01:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805a08:	00 00 00 
  805a0b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  805a0e:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  805a10:	bf 01 00 00 00       	mov    $0x1,%edi
  805a15:	48 b8 6d 59 80 00 00 	movabs $0x80596d,%rax
  805a1c:	00 00 00 
  805a1f:	ff d0                	callq  *%rax
  805a21:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805a24:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805a28:	78 3e                	js     805a68 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  805a2a:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805a31:	00 00 00 
  805a34:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  805a38:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805a3c:	8b 40 10             	mov    0x10(%rax),%eax
  805a3f:	89 c2                	mov    %eax,%edx
  805a41:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  805a45:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805a49:	48 89 ce             	mov    %rcx,%rsi
  805a4c:	48 89 c7             	mov    %rax,%rdi
  805a4f:	48 b8 90 24 80 00 00 	movabs $0x802490,%rax
  805a56:	00 00 00 
  805a59:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  805a5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805a5f:	8b 50 10             	mov    0x10(%rax),%edx
  805a62:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805a66:	89 10                	mov    %edx,(%rax)
	}
	return r;
  805a68:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  805a6b:	c9                   	leaveq 
  805a6c:	c3                   	retq   

0000000000805a6d <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  805a6d:	55                   	push   %rbp
  805a6e:	48 89 e5             	mov    %rsp,%rbp
  805a71:	48 83 ec 10          	sub    $0x10,%rsp
  805a75:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805a78:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  805a7c:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  805a7f:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805a86:	00 00 00 
  805a89:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805a8c:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  805a8e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805a91:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805a95:	48 89 c6             	mov    %rax,%rsi
  805a98:	48 bf 04 d0 80 00 00 	movabs $0x80d004,%rdi
  805a9f:	00 00 00 
  805aa2:	48 b8 90 24 80 00 00 	movabs $0x802490,%rax
  805aa9:	00 00 00 
  805aac:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  805aae:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805ab5:	00 00 00 
  805ab8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805abb:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  805abe:	bf 02 00 00 00       	mov    $0x2,%edi
  805ac3:	48 b8 6d 59 80 00 00 	movabs $0x80596d,%rax
  805aca:	00 00 00 
  805acd:	ff d0                	callq  *%rax
}
  805acf:	c9                   	leaveq 
  805ad0:	c3                   	retq   

0000000000805ad1 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  805ad1:	55                   	push   %rbp
  805ad2:	48 89 e5             	mov    %rsp,%rbp
  805ad5:	48 83 ec 10          	sub    $0x10,%rsp
  805ad9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805adc:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  805adf:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805ae6:	00 00 00 
  805ae9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805aec:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  805aee:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805af5:	00 00 00 
  805af8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805afb:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  805afe:	bf 03 00 00 00       	mov    $0x3,%edi
  805b03:	48 b8 6d 59 80 00 00 	movabs $0x80596d,%rax
  805b0a:	00 00 00 
  805b0d:	ff d0                	callq  *%rax
}
  805b0f:	c9                   	leaveq 
  805b10:	c3                   	retq   

0000000000805b11 <nsipc_close>:

int
nsipc_close(int s)
{
  805b11:	55                   	push   %rbp
  805b12:	48 89 e5             	mov    %rsp,%rbp
  805b15:	48 83 ec 10          	sub    $0x10,%rsp
  805b19:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  805b1c:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805b23:	00 00 00 
  805b26:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805b29:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  805b2b:	bf 04 00 00 00       	mov    $0x4,%edi
  805b30:	48 b8 6d 59 80 00 00 	movabs $0x80596d,%rax
  805b37:	00 00 00 
  805b3a:	ff d0                	callq  *%rax
}
  805b3c:	c9                   	leaveq 
  805b3d:	c3                   	retq   

0000000000805b3e <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  805b3e:	55                   	push   %rbp
  805b3f:	48 89 e5             	mov    %rsp,%rbp
  805b42:	48 83 ec 10          	sub    $0x10,%rsp
  805b46:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805b49:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  805b4d:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  805b50:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805b57:	00 00 00 
  805b5a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805b5d:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  805b5f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805b62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805b66:	48 89 c6             	mov    %rax,%rsi
  805b69:	48 bf 04 d0 80 00 00 	movabs $0x80d004,%rdi
  805b70:	00 00 00 
  805b73:	48 b8 90 24 80 00 00 	movabs $0x802490,%rax
  805b7a:	00 00 00 
  805b7d:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  805b7f:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805b86:	00 00 00 
  805b89:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805b8c:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  805b8f:	bf 05 00 00 00       	mov    $0x5,%edi
  805b94:	48 b8 6d 59 80 00 00 	movabs $0x80596d,%rax
  805b9b:	00 00 00 
  805b9e:	ff d0                	callq  *%rax
}
  805ba0:	c9                   	leaveq 
  805ba1:	c3                   	retq   

0000000000805ba2 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  805ba2:	55                   	push   %rbp
  805ba3:	48 89 e5             	mov    %rsp,%rbp
  805ba6:	48 83 ec 10          	sub    $0x10,%rsp
  805baa:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805bad:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  805bb0:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805bb7:	00 00 00 
  805bba:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805bbd:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  805bbf:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805bc6:	00 00 00 
  805bc9:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805bcc:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  805bcf:	bf 06 00 00 00       	mov    $0x6,%edi
  805bd4:	48 b8 6d 59 80 00 00 	movabs $0x80596d,%rax
  805bdb:	00 00 00 
  805bde:	ff d0                	callq  *%rax
}
  805be0:	c9                   	leaveq 
  805be1:	c3                   	retq   

0000000000805be2 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  805be2:	55                   	push   %rbp
  805be3:	48 89 e5             	mov    %rsp,%rbp
  805be6:	48 83 ec 30          	sub    $0x30,%rsp
  805bea:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805bed:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805bf1:	89 55 e8             	mov    %edx,-0x18(%rbp)
  805bf4:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  805bf7:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805bfe:	00 00 00 
  805c01:	8b 55 ec             	mov    -0x14(%rbp),%edx
  805c04:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  805c06:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805c0d:	00 00 00 
  805c10:	8b 55 e8             	mov    -0x18(%rbp),%edx
  805c13:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  805c16:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805c1d:	00 00 00 
  805c20:	8b 55 dc             	mov    -0x24(%rbp),%edx
  805c23:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  805c26:	bf 07 00 00 00       	mov    $0x7,%edi
  805c2b:	48 b8 6d 59 80 00 00 	movabs $0x80596d,%rax
  805c32:	00 00 00 
  805c35:	ff d0                	callq  *%rax
  805c37:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805c3a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805c3e:	78 69                	js     805ca9 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  805c40:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  805c47:	7f 08                	jg     805c51 <nsipc_recv+0x6f>
  805c49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805c4c:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  805c4f:	7e 35                	jle    805c86 <nsipc_recv+0xa4>
  805c51:	48 b9 3c 72 80 00 00 	movabs $0x80723c,%rcx
  805c58:	00 00 00 
  805c5b:	48 ba 51 72 80 00 00 	movabs $0x807251,%rdx
  805c62:	00 00 00 
  805c65:	be 61 00 00 00       	mov    $0x61,%esi
  805c6a:	48 bf 66 72 80 00 00 	movabs $0x807266,%rdi
  805c71:	00 00 00 
  805c74:	b8 00 00 00 00       	mov    $0x0,%eax
  805c79:	49 b8 24 12 80 00 00 	movabs $0x801224,%r8
  805c80:	00 00 00 
  805c83:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  805c86:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805c89:	48 63 d0             	movslq %eax,%rdx
  805c8c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805c90:	48 be 00 d0 80 00 00 	movabs $0x80d000,%rsi
  805c97:	00 00 00 
  805c9a:	48 89 c7             	mov    %rax,%rdi
  805c9d:	48 b8 90 24 80 00 00 	movabs $0x802490,%rax
  805ca4:	00 00 00 
  805ca7:	ff d0                	callq  *%rax
	}

	return r;
  805ca9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  805cac:	c9                   	leaveq 
  805cad:	c3                   	retq   

0000000000805cae <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  805cae:	55                   	push   %rbp
  805caf:	48 89 e5             	mov    %rsp,%rbp
  805cb2:	48 83 ec 20          	sub    $0x20,%rsp
  805cb6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805cb9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  805cbd:	89 55 f8             	mov    %edx,-0x8(%rbp)
  805cc0:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  805cc3:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805cca:	00 00 00 
  805ccd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805cd0:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  805cd2:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  805cd9:	7e 35                	jle    805d10 <nsipc_send+0x62>
  805cdb:	48 b9 72 72 80 00 00 	movabs $0x807272,%rcx
  805ce2:	00 00 00 
  805ce5:	48 ba 51 72 80 00 00 	movabs $0x807251,%rdx
  805cec:	00 00 00 
  805cef:	be 6c 00 00 00       	mov    $0x6c,%esi
  805cf4:	48 bf 66 72 80 00 00 	movabs $0x807266,%rdi
  805cfb:	00 00 00 
  805cfe:	b8 00 00 00 00       	mov    $0x0,%eax
  805d03:	49 b8 24 12 80 00 00 	movabs $0x801224,%r8
  805d0a:	00 00 00 
  805d0d:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  805d10:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805d13:	48 63 d0             	movslq %eax,%rdx
  805d16:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805d1a:	48 89 c6             	mov    %rax,%rsi
  805d1d:	48 bf 0c d0 80 00 00 	movabs $0x80d00c,%rdi
  805d24:	00 00 00 
  805d27:	48 b8 90 24 80 00 00 	movabs $0x802490,%rax
  805d2e:	00 00 00 
  805d31:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  805d33:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805d3a:	00 00 00 
  805d3d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805d40:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  805d43:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805d4a:	00 00 00 
  805d4d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  805d50:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  805d53:	bf 08 00 00 00       	mov    $0x8,%edi
  805d58:	48 b8 6d 59 80 00 00 	movabs $0x80596d,%rax
  805d5f:	00 00 00 
  805d62:	ff d0                	callq  *%rax
}
  805d64:	c9                   	leaveq 
  805d65:	c3                   	retq   

0000000000805d66 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  805d66:	55                   	push   %rbp
  805d67:	48 89 e5             	mov    %rsp,%rbp
  805d6a:	48 83 ec 10          	sub    $0x10,%rsp
  805d6e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805d71:	89 75 f8             	mov    %esi,-0x8(%rbp)
  805d74:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  805d77:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805d7e:	00 00 00 
  805d81:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805d84:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  805d86:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805d8d:	00 00 00 
  805d90:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805d93:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  805d96:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805d9d:	00 00 00 
  805da0:	8b 55 f4             	mov    -0xc(%rbp),%edx
  805da3:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  805da6:	bf 09 00 00 00       	mov    $0x9,%edi
  805dab:	48 b8 6d 59 80 00 00 	movabs $0x80596d,%rax
  805db2:	00 00 00 
  805db5:	ff d0                	callq  *%rax
}
  805db7:	c9                   	leaveq 
  805db8:	c3                   	retq   

0000000000805db9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  805db9:	55                   	push   %rbp
  805dba:	48 89 e5             	mov    %rsp,%rbp
  805dbd:	53                   	push   %rbx
  805dbe:	48 83 ec 38          	sub    $0x38,%rsp
  805dc2:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  805dc6:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  805dca:	48 89 c7             	mov    %rax,%rdi
  805dcd:	48 b8 9f 37 80 00 00 	movabs $0x80379f,%rax
  805dd4:	00 00 00 
  805dd7:	ff d0                	callq  *%rax
  805dd9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805ddc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805de0:	0f 88 bf 01 00 00    	js     805fa5 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  805de6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805dea:	ba 07 04 00 00       	mov    $0x407,%edx
  805def:	48 89 c6             	mov    %rax,%rsi
  805df2:	bf 00 00 00 00       	mov    $0x0,%edi
  805df7:	48 b8 9b 2a 80 00 00 	movabs $0x802a9b,%rax
  805dfe:	00 00 00 
  805e01:	ff d0                	callq  *%rax
  805e03:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805e06:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805e0a:	0f 88 95 01 00 00    	js     805fa5 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  805e10:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  805e14:	48 89 c7             	mov    %rax,%rdi
  805e17:	48 b8 9f 37 80 00 00 	movabs $0x80379f,%rax
  805e1e:	00 00 00 
  805e21:	ff d0                	callq  *%rax
  805e23:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805e26:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805e2a:	0f 88 5d 01 00 00    	js     805f8d <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  805e30:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805e34:	ba 07 04 00 00       	mov    $0x407,%edx
  805e39:	48 89 c6             	mov    %rax,%rsi
  805e3c:	bf 00 00 00 00       	mov    $0x0,%edi
  805e41:	48 b8 9b 2a 80 00 00 	movabs $0x802a9b,%rax
  805e48:	00 00 00 
  805e4b:	ff d0                	callq  *%rax
  805e4d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805e50:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805e54:	0f 88 33 01 00 00    	js     805f8d <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  805e5a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805e5e:	48 89 c7             	mov    %rax,%rdi
  805e61:	48 b8 74 37 80 00 00 	movabs $0x803774,%rax
  805e68:	00 00 00 
  805e6b:	ff d0                	callq  *%rax
  805e6d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  805e71:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805e75:	ba 07 04 00 00       	mov    $0x407,%edx
  805e7a:	48 89 c6             	mov    %rax,%rsi
  805e7d:	bf 00 00 00 00       	mov    $0x0,%edi
  805e82:	48 b8 9b 2a 80 00 00 	movabs $0x802a9b,%rax
  805e89:	00 00 00 
  805e8c:	ff d0                	callq  *%rax
  805e8e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805e91:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805e95:	79 05                	jns    805e9c <pipe+0xe3>
		goto err2;
  805e97:	e9 d9 00 00 00       	jmpq   805f75 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  805e9c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805ea0:	48 89 c7             	mov    %rax,%rdi
  805ea3:	48 b8 74 37 80 00 00 	movabs $0x803774,%rax
  805eaa:	00 00 00 
  805ead:	ff d0                	callq  *%rax
  805eaf:	48 89 c2             	mov    %rax,%rdx
  805eb2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805eb6:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  805ebc:	48 89 d1             	mov    %rdx,%rcx
  805ebf:	ba 00 00 00 00       	mov    $0x0,%edx
  805ec4:	48 89 c6             	mov    %rax,%rsi
  805ec7:	bf 00 00 00 00       	mov    $0x0,%edi
  805ecc:	48 b8 eb 2a 80 00 00 	movabs $0x802aeb,%rax
  805ed3:	00 00 00 
  805ed6:	ff d0                	callq  *%rax
  805ed8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805edb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805edf:	79 1b                	jns    805efc <pipe+0x143>
		goto err3;
  805ee1:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  805ee2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805ee6:	48 89 c6             	mov    %rax,%rsi
  805ee9:	bf 00 00 00 00       	mov    $0x0,%edi
  805eee:	48 b8 46 2b 80 00 00 	movabs $0x802b46,%rax
  805ef5:	00 00 00 
  805ef8:	ff d0                	callq  *%rax
  805efa:	eb 79                	jmp    805f75 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  805efc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805f00:	48 ba 20 91 80 00 00 	movabs $0x809120,%rdx
  805f07:	00 00 00 
  805f0a:	8b 12                	mov    (%rdx),%edx
  805f0c:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  805f0e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805f12:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  805f19:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805f1d:	48 ba 20 91 80 00 00 	movabs $0x809120,%rdx
  805f24:	00 00 00 
  805f27:	8b 12                	mov    (%rdx),%edx
  805f29:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  805f2b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805f2f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  805f36:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805f3a:	48 89 c7             	mov    %rax,%rdi
  805f3d:	48 b8 51 37 80 00 00 	movabs $0x803751,%rax
  805f44:	00 00 00 
  805f47:	ff d0                	callq  *%rax
  805f49:	89 c2                	mov    %eax,%edx
  805f4b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  805f4f:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  805f51:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  805f55:	48 8d 58 04          	lea    0x4(%rax),%rbx
  805f59:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805f5d:	48 89 c7             	mov    %rax,%rdi
  805f60:	48 b8 51 37 80 00 00 	movabs $0x803751,%rax
  805f67:	00 00 00 
  805f6a:	ff d0                	callq  *%rax
  805f6c:	89 03                	mov    %eax,(%rbx)
	return 0;
  805f6e:	b8 00 00 00 00       	mov    $0x0,%eax
  805f73:	eb 33                	jmp    805fa8 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  805f75:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805f79:	48 89 c6             	mov    %rax,%rsi
  805f7c:	bf 00 00 00 00       	mov    $0x0,%edi
  805f81:	48 b8 46 2b 80 00 00 	movabs $0x802b46,%rax
  805f88:	00 00 00 
  805f8b:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  805f8d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805f91:	48 89 c6             	mov    %rax,%rsi
  805f94:	bf 00 00 00 00       	mov    $0x0,%edi
  805f99:	48 b8 46 2b 80 00 00 	movabs $0x802b46,%rax
  805fa0:	00 00 00 
  805fa3:	ff d0                	callq  *%rax
err:
	return r;
  805fa5:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  805fa8:	48 83 c4 38          	add    $0x38,%rsp
  805fac:	5b                   	pop    %rbx
  805fad:	5d                   	pop    %rbp
  805fae:	c3                   	retq   

0000000000805faf <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  805faf:	55                   	push   %rbp
  805fb0:	48 89 e5             	mov    %rsp,%rbp
  805fb3:	53                   	push   %rbx
  805fb4:	48 83 ec 28          	sub    $0x28,%rsp
  805fb8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  805fbc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  805fc0:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  805fc7:	00 00 00 
  805fca:	48 8b 00             	mov    (%rax),%rax
  805fcd:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  805fd3:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  805fd6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805fda:	48 89 c7             	mov    %rax,%rdi
  805fdd:	48 b8 49 67 80 00 00 	movabs $0x806749,%rax
  805fe4:	00 00 00 
  805fe7:	ff d0                	callq  *%rax
  805fe9:	89 c3                	mov    %eax,%ebx
  805feb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805fef:	48 89 c7             	mov    %rax,%rdi
  805ff2:	48 b8 49 67 80 00 00 	movabs $0x806749,%rax
  805ff9:	00 00 00 
  805ffc:	ff d0                	callq  *%rax
  805ffe:	39 c3                	cmp    %eax,%ebx
  806000:	0f 94 c0             	sete   %al
  806003:	0f b6 c0             	movzbl %al,%eax
  806006:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  806009:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  806010:	00 00 00 
  806013:	48 8b 00             	mov    (%rax),%rax
  806016:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80601c:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80601f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806022:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  806025:	75 05                	jne    80602c <_pipeisclosed+0x7d>
			return ret;
  806027:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80602a:	eb 4f                	jmp    80607b <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80602c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80602f:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  806032:	74 42                	je     806076 <_pipeisclosed+0xc7>
  806034:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  806038:	75 3c                	jne    806076 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80603a:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  806041:	00 00 00 
  806044:	48 8b 00             	mov    (%rax),%rax
  806047:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80604d:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  806050:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806053:	89 c6                	mov    %eax,%esi
  806055:	48 bf 83 72 80 00 00 	movabs $0x807283,%rdi
  80605c:	00 00 00 
  80605f:	b8 00 00 00 00       	mov    $0x0,%eax
  806064:	49 b8 5d 14 80 00 00 	movabs $0x80145d,%r8
  80606b:	00 00 00 
  80606e:	41 ff d0             	callq  *%r8
	}
  806071:	e9 4a ff ff ff       	jmpq   805fc0 <_pipeisclosed+0x11>
  806076:	e9 45 ff ff ff       	jmpq   805fc0 <_pipeisclosed+0x11>
}
  80607b:	48 83 c4 28          	add    $0x28,%rsp
  80607f:	5b                   	pop    %rbx
  806080:	5d                   	pop    %rbp
  806081:	c3                   	retq   

0000000000806082 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  806082:	55                   	push   %rbp
  806083:	48 89 e5             	mov    %rsp,%rbp
  806086:	48 83 ec 30          	sub    $0x30,%rsp
  80608a:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80608d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  806091:	8b 45 dc             	mov    -0x24(%rbp),%eax
  806094:	48 89 d6             	mov    %rdx,%rsi
  806097:	89 c7                	mov    %eax,%edi
  806099:	48 b8 37 38 80 00 00 	movabs $0x803837,%rax
  8060a0:	00 00 00 
  8060a3:	ff d0                	callq  *%rax
  8060a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8060a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8060ac:	79 05                	jns    8060b3 <pipeisclosed+0x31>
		return r;
  8060ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8060b1:	eb 31                	jmp    8060e4 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8060b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8060b7:	48 89 c7             	mov    %rax,%rdi
  8060ba:	48 b8 74 37 80 00 00 	movabs $0x803774,%rax
  8060c1:	00 00 00 
  8060c4:	ff d0                	callq  *%rax
  8060c6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8060ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8060ce:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8060d2:	48 89 d6             	mov    %rdx,%rsi
  8060d5:	48 89 c7             	mov    %rax,%rdi
  8060d8:	48 b8 af 5f 80 00 00 	movabs $0x805faf,%rax
  8060df:	00 00 00 
  8060e2:	ff d0                	callq  *%rax
}
  8060e4:	c9                   	leaveq 
  8060e5:	c3                   	retq   

00000000008060e6 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8060e6:	55                   	push   %rbp
  8060e7:	48 89 e5             	mov    %rsp,%rbp
  8060ea:	48 83 ec 40          	sub    $0x40,%rsp
  8060ee:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8060f2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8060f6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8060fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8060fe:	48 89 c7             	mov    %rax,%rdi
  806101:	48 b8 74 37 80 00 00 	movabs $0x803774,%rax
  806108:	00 00 00 
  80610b:	ff d0                	callq  *%rax
  80610d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  806111:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806115:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  806119:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  806120:	00 
  806121:	e9 92 00 00 00       	jmpq   8061b8 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  806126:	eb 41                	jmp    806169 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  806128:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80612d:	74 09                	je     806138 <devpipe_read+0x52>
				return i;
  80612f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806133:	e9 92 00 00 00       	jmpq   8061ca <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  806138:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80613c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806140:	48 89 d6             	mov    %rdx,%rsi
  806143:	48 89 c7             	mov    %rax,%rdi
  806146:	48 b8 af 5f 80 00 00 	movabs $0x805faf,%rax
  80614d:	00 00 00 
  806150:	ff d0                	callq  *%rax
  806152:	85 c0                	test   %eax,%eax
  806154:	74 07                	je     80615d <devpipe_read+0x77>
				return 0;
  806156:	b8 00 00 00 00       	mov    $0x0,%eax
  80615b:	eb 6d                	jmp    8061ca <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80615d:	48 b8 5d 2a 80 00 00 	movabs $0x802a5d,%rax
  806164:	00 00 00 
  806167:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  806169:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80616d:	8b 10                	mov    (%rax),%edx
  80616f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806173:	8b 40 04             	mov    0x4(%rax),%eax
  806176:	39 c2                	cmp    %eax,%edx
  806178:	74 ae                	je     806128 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80617a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80617e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  806182:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  806186:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80618a:	8b 00                	mov    (%rax),%eax
  80618c:	99                   	cltd   
  80618d:	c1 ea 1b             	shr    $0x1b,%edx
  806190:	01 d0                	add    %edx,%eax
  806192:	83 e0 1f             	and    $0x1f,%eax
  806195:	29 d0                	sub    %edx,%eax
  806197:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80619b:	48 98                	cltq   
  80619d:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8061a2:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8061a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8061a8:	8b 00                	mov    (%rax),%eax
  8061aa:	8d 50 01             	lea    0x1(%rax),%edx
  8061ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8061b1:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8061b3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8061b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8061bc:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8061c0:	0f 82 60 ff ff ff    	jb     806126 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8061c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8061ca:	c9                   	leaveq 
  8061cb:	c3                   	retq   

00000000008061cc <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8061cc:	55                   	push   %rbp
  8061cd:	48 89 e5             	mov    %rsp,%rbp
  8061d0:	48 83 ec 40          	sub    $0x40,%rsp
  8061d4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8061d8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8061dc:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8061e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8061e4:	48 89 c7             	mov    %rax,%rdi
  8061e7:	48 b8 74 37 80 00 00 	movabs $0x803774,%rax
  8061ee:	00 00 00 
  8061f1:	ff d0                	callq  *%rax
  8061f3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8061f7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8061fb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8061ff:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  806206:	00 
  806207:	e9 8e 00 00 00       	jmpq   80629a <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80620c:	eb 31                	jmp    80623f <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80620e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  806212:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806216:	48 89 d6             	mov    %rdx,%rsi
  806219:	48 89 c7             	mov    %rax,%rdi
  80621c:	48 b8 af 5f 80 00 00 	movabs $0x805faf,%rax
  806223:	00 00 00 
  806226:	ff d0                	callq  *%rax
  806228:	85 c0                	test   %eax,%eax
  80622a:	74 07                	je     806233 <devpipe_write+0x67>
				return 0;
  80622c:	b8 00 00 00 00       	mov    $0x0,%eax
  806231:	eb 79                	jmp    8062ac <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  806233:	48 b8 5d 2a 80 00 00 	movabs $0x802a5d,%rax
  80623a:	00 00 00 
  80623d:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80623f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806243:	8b 40 04             	mov    0x4(%rax),%eax
  806246:	48 63 d0             	movslq %eax,%rdx
  806249:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80624d:	8b 00                	mov    (%rax),%eax
  80624f:	48 98                	cltq   
  806251:	48 83 c0 20          	add    $0x20,%rax
  806255:	48 39 c2             	cmp    %rax,%rdx
  806258:	73 b4                	jae    80620e <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80625a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80625e:	8b 40 04             	mov    0x4(%rax),%eax
  806261:	99                   	cltd   
  806262:	c1 ea 1b             	shr    $0x1b,%edx
  806265:	01 d0                	add    %edx,%eax
  806267:	83 e0 1f             	and    $0x1f,%eax
  80626a:	29 d0                	sub    %edx,%eax
  80626c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  806270:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  806274:	48 01 ca             	add    %rcx,%rdx
  806277:	0f b6 0a             	movzbl (%rdx),%ecx
  80627a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80627e:	48 98                	cltq   
  806280:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  806284:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806288:	8b 40 04             	mov    0x4(%rax),%eax
  80628b:	8d 50 01             	lea    0x1(%rax),%edx
  80628e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806292:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  806295:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80629a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80629e:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8062a2:	0f 82 64 ff ff ff    	jb     80620c <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8062a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8062ac:	c9                   	leaveq 
  8062ad:	c3                   	retq   

00000000008062ae <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8062ae:	55                   	push   %rbp
  8062af:	48 89 e5             	mov    %rsp,%rbp
  8062b2:	48 83 ec 20          	sub    $0x20,%rsp
  8062b6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8062ba:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8062be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8062c2:	48 89 c7             	mov    %rax,%rdi
  8062c5:	48 b8 74 37 80 00 00 	movabs $0x803774,%rax
  8062cc:	00 00 00 
  8062cf:	ff d0                	callq  *%rax
  8062d1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8062d5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8062d9:	48 be 96 72 80 00 00 	movabs $0x807296,%rsi
  8062e0:	00 00 00 
  8062e3:	48 89 c7             	mov    %rax,%rdi
  8062e6:	48 b8 6c 21 80 00 00 	movabs $0x80216c,%rax
  8062ed:	00 00 00 
  8062f0:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8062f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8062f6:	8b 50 04             	mov    0x4(%rax),%edx
  8062f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8062fd:	8b 00                	mov    (%rax),%eax
  8062ff:	29 c2                	sub    %eax,%edx
  806301:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806305:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80630b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80630f:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  806316:	00 00 00 
	stat->st_dev = &devpipe;
  806319:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80631d:	48 b9 20 91 80 00 00 	movabs $0x809120,%rcx
  806324:	00 00 00 
  806327:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80632e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  806333:	c9                   	leaveq 
  806334:	c3                   	retq   

0000000000806335 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  806335:	55                   	push   %rbp
  806336:	48 89 e5             	mov    %rsp,%rbp
  806339:	48 83 ec 10          	sub    $0x10,%rsp
  80633d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  806341:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806345:	48 89 c6             	mov    %rax,%rsi
  806348:	bf 00 00 00 00       	mov    $0x0,%edi
  80634d:	48 b8 46 2b 80 00 00 	movabs $0x802b46,%rax
  806354:	00 00 00 
  806357:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  806359:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80635d:	48 89 c7             	mov    %rax,%rdi
  806360:	48 b8 74 37 80 00 00 	movabs $0x803774,%rax
  806367:	00 00 00 
  80636a:	ff d0                	callq  *%rax
  80636c:	48 89 c6             	mov    %rax,%rsi
  80636f:	bf 00 00 00 00       	mov    $0x0,%edi
  806374:	48 b8 46 2b 80 00 00 	movabs $0x802b46,%rax
  80637b:	00 00 00 
  80637e:	ff d0                	callq  *%rax
}
  806380:	c9                   	leaveq 
  806381:	c3                   	retq   

0000000000806382 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  806382:	55                   	push   %rbp
  806383:	48 89 e5             	mov    %rsp,%rbp
  806386:	48 83 ec 20          	sub    $0x20,%rsp
  80638a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  80638d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  806391:	75 35                	jne    8063c8 <wait+0x46>
  806393:	48 b9 9d 72 80 00 00 	movabs $0x80729d,%rcx
  80639a:	00 00 00 
  80639d:	48 ba a8 72 80 00 00 	movabs $0x8072a8,%rdx
  8063a4:	00 00 00 
  8063a7:	be 09 00 00 00       	mov    $0x9,%esi
  8063ac:	48 bf bd 72 80 00 00 	movabs $0x8072bd,%rdi
  8063b3:	00 00 00 
  8063b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8063bb:	49 b8 24 12 80 00 00 	movabs $0x801224,%r8
  8063c2:	00 00 00 
  8063c5:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  8063c8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8063cb:	25 ff 03 00 00       	and    $0x3ff,%eax
  8063d0:	48 63 d0             	movslq %eax,%rdx
  8063d3:	48 89 d0             	mov    %rdx,%rax
  8063d6:	48 c1 e0 03          	shl    $0x3,%rax
  8063da:	48 01 d0             	add    %rdx,%rax
  8063dd:	48 c1 e0 05          	shl    $0x5,%rax
  8063e1:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8063e8:	00 00 00 
  8063eb:	48 01 d0             	add    %rdx,%rax
  8063ee:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE){
  8063f2:	eb 0c                	jmp    806400 <wait+0x7e>
	//cprintf("envid is [%d]",envid);
		sys_yield();
  8063f4:	48 b8 5d 2a 80 00 00 	movabs $0x802a5d,%rax
  8063fb:	00 00 00 
  8063fe:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE){
  806400:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806404:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80640a:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80640d:	75 0e                	jne    80641d <wait+0x9b>
  80640f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806413:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  806419:	85 c0                	test   %eax,%eax
  80641b:	75 d7                	jne    8063f4 <wait+0x72>
	//cprintf("envid is [%d]",envid);
		sys_yield();
	}
}
  80641d:	c9                   	leaveq 
  80641e:	c3                   	retq   

000000000080641f <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80641f:	55                   	push   %rbp
  806420:	48 89 e5             	mov    %rsp,%rbp
  806423:	48 83 ec 10          	sub    $0x10,%rsp
  806427:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  80642b:	48 b8 00 e0 80 00 00 	movabs $0x80e000,%rax
  806432:	00 00 00 
  806435:	48 8b 00             	mov    (%rax),%rax
  806438:	48 85 c0             	test   %rax,%rax
  80643b:	0f 85 84 00 00 00    	jne    8064c5 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  806441:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  806448:	00 00 00 
  80644b:	48 8b 00             	mov    (%rax),%rax
  80644e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  806454:	ba 07 00 00 00       	mov    $0x7,%edx
  806459:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80645e:	89 c7                	mov    %eax,%edi
  806460:	48 b8 9b 2a 80 00 00 	movabs $0x802a9b,%rax
  806467:	00 00 00 
  80646a:	ff d0                	callq  *%rax
  80646c:	85 c0                	test   %eax,%eax
  80646e:	79 2a                	jns    80649a <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  806470:	48 ba c8 72 80 00 00 	movabs $0x8072c8,%rdx
  806477:	00 00 00 
  80647a:	be 23 00 00 00       	mov    $0x23,%esi
  80647f:	48 bf ef 72 80 00 00 	movabs $0x8072ef,%rdi
  806486:	00 00 00 
  806489:	b8 00 00 00 00       	mov    $0x0,%eax
  80648e:	48 b9 24 12 80 00 00 	movabs $0x801224,%rcx
  806495:	00 00 00 
  806498:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  80649a:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  8064a1:	00 00 00 
  8064a4:	48 8b 00             	mov    (%rax),%rax
  8064a7:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8064ad:	48 be d8 64 80 00 00 	movabs $0x8064d8,%rsi
  8064b4:	00 00 00 
  8064b7:	89 c7                	mov    %eax,%edi
  8064b9:	48 b8 25 2c 80 00 00 	movabs $0x802c25,%rax
  8064c0:	00 00 00 
  8064c3:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  8064c5:	48 b8 00 e0 80 00 00 	movabs $0x80e000,%rax
  8064cc:	00 00 00 
  8064cf:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8064d3:	48 89 10             	mov    %rdx,(%rax)
}
  8064d6:	c9                   	leaveq 
  8064d7:	c3                   	retq   

00000000008064d8 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  8064d8:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  8064db:	48 a1 00 e0 80 00 00 	movabs 0x80e000,%rax
  8064e2:	00 00 00 
call *%rax
  8064e5:	ff d0                	callq  *%rax
    // LAB 4: Your code here.

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.

	movq 136(%rsp), %rbx  //Load RIP 
  8064e7:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8064ee:	00 
	movq 152(%rsp), %rcx  //Load RSP
  8064ef:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  8064f6:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  8064f7:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  8064fb:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  8064fe:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  806505:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  806506:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  80650a:	4c 8b 3c 24          	mov    (%rsp),%r15
  80650e:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  806513:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  806518:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  80651d:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  806522:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  806527:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  80652c:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  806531:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  806536:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  80653b:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  806540:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  806545:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  80654a:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  80654f:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  806554:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  806558:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  80655c:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  80655d:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  80655e:	c3                   	retq   

000000000080655f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80655f:	55                   	push   %rbp
  806560:	48 89 e5             	mov    %rsp,%rbp
  806563:	48 83 ec 30          	sub    $0x30,%rsp
  806567:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80656b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80656f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  806573:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  80657a:	00 00 00 
  80657d:	48 8b 00             	mov    (%rax),%rax
  806580:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  806586:	85 c0                	test   %eax,%eax
  806588:	75 3c                	jne    8065c6 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  80658a:	48 b8 1f 2a 80 00 00 	movabs $0x802a1f,%rax
  806591:	00 00 00 
  806594:	ff d0                	callq  *%rax
  806596:	25 ff 03 00 00       	and    $0x3ff,%eax
  80659b:	48 63 d0             	movslq %eax,%rdx
  80659e:	48 89 d0             	mov    %rdx,%rax
  8065a1:	48 c1 e0 03          	shl    $0x3,%rax
  8065a5:	48 01 d0             	add    %rdx,%rax
  8065a8:	48 c1 e0 05          	shl    $0x5,%rax
  8065ac:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8065b3:	00 00 00 
  8065b6:	48 01 c2             	add    %rax,%rdx
  8065b9:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  8065c0:	00 00 00 
  8065c3:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  8065c6:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8065cb:	75 0e                	jne    8065db <ipc_recv+0x7c>
		pg = (void*) UTOP;
  8065cd:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8065d4:	00 00 00 
  8065d7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  8065db:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8065df:	48 89 c7             	mov    %rax,%rdi
  8065e2:	48 b8 c4 2c 80 00 00 	movabs $0x802cc4,%rax
  8065e9:	00 00 00 
  8065ec:	ff d0                	callq  *%rax
  8065ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  8065f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8065f5:	79 19                	jns    806610 <ipc_recv+0xb1>
		*from_env_store = 0;
  8065f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8065fb:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  806601:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806605:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  80660b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80660e:	eb 53                	jmp    806663 <ipc_recv+0x104>
	}
	if(from_env_store)
  806610:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  806615:	74 19                	je     806630 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  806617:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  80661e:	00 00 00 
  806621:	48 8b 00             	mov    (%rax),%rax
  806624:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80662a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80662e:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  806630:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  806635:	74 19                	je     806650 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  806637:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  80663e:	00 00 00 
  806641:	48 8b 00             	mov    (%rax),%rax
  806644:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80664a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80664e:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  806650:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  806657:	00 00 00 
  80665a:	48 8b 00             	mov    (%rax),%rax
  80665d:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  806663:	c9                   	leaveq 
  806664:	c3                   	retq   

0000000000806665 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  806665:	55                   	push   %rbp
  806666:	48 89 e5             	mov    %rsp,%rbp
  806669:	48 83 ec 30          	sub    $0x30,%rsp
  80666d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  806670:	89 75 e8             	mov    %esi,-0x18(%rbp)
  806673:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  806677:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  80667a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80667f:	75 0e                	jne    80668f <ipc_send+0x2a>
		pg = (void*)UTOP;
  806681:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  806688:	00 00 00 
  80668b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  80668f:	8b 75 e8             	mov    -0x18(%rbp),%esi
  806692:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  806695:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  806699:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80669c:	89 c7                	mov    %eax,%edi
  80669e:	48 b8 6f 2c 80 00 00 	movabs $0x802c6f,%rax
  8066a5:	00 00 00 
  8066a8:	ff d0                	callq  *%rax
  8066aa:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  8066ad:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8066b1:	75 0c                	jne    8066bf <ipc_send+0x5a>
			sys_yield();
  8066b3:	48 b8 5d 2a 80 00 00 	movabs $0x802a5d,%rax
  8066ba:	00 00 00 
  8066bd:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  8066bf:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8066c3:	74 ca                	je     80668f <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  8066c5:	c9                   	leaveq 
  8066c6:	c3                   	retq   

00000000008066c7 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8066c7:	55                   	push   %rbp
  8066c8:	48 89 e5             	mov    %rsp,%rbp
  8066cb:	48 83 ec 14          	sub    $0x14,%rsp
  8066cf:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8066d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8066d9:	eb 5e                	jmp    806739 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8066db:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8066e2:	00 00 00 
  8066e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8066e8:	48 63 d0             	movslq %eax,%rdx
  8066eb:	48 89 d0             	mov    %rdx,%rax
  8066ee:	48 c1 e0 03          	shl    $0x3,%rax
  8066f2:	48 01 d0             	add    %rdx,%rax
  8066f5:	48 c1 e0 05          	shl    $0x5,%rax
  8066f9:	48 01 c8             	add    %rcx,%rax
  8066fc:	48 05 d0 00 00 00    	add    $0xd0,%rax
  806702:	8b 00                	mov    (%rax),%eax
  806704:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  806707:	75 2c                	jne    806735 <ipc_find_env+0x6e>
			return envs[i].env_id;
  806709:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  806710:	00 00 00 
  806713:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806716:	48 63 d0             	movslq %eax,%rdx
  806719:	48 89 d0             	mov    %rdx,%rax
  80671c:	48 c1 e0 03          	shl    $0x3,%rax
  806720:	48 01 d0             	add    %rdx,%rax
  806723:	48 c1 e0 05          	shl    $0x5,%rax
  806727:	48 01 c8             	add    %rcx,%rax
  80672a:	48 05 c0 00 00 00    	add    $0xc0,%rax
  806730:	8b 40 08             	mov    0x8(%rax),%eax
  806733:	eb 12                	jmp    806747 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  806735:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  806739:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  806740:	7e 99                	jle    8066db <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  806742:	b8 00 00 00 00       	mov    $0x0,%eax
}
  806747:	c9                   	leaveq 
  806748:	c3                   	retq   

0000000000806749 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  806749:	55                   	push   %rbp
  80674a:	48 89 e5             	mov    %rsp,%rbp
  80674d:	48 83 ec 18          	sub    $0x18,%rsp
  806751:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  806755:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806759:	48 c1 e8 15          	shr    $0x15,%rax
  80675d:	48 89 c2             	mov    %rax,%rdx
  806760:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  806767:	01 00 00 
  80676a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80676e:	83 e0 01             	and    $0x1,%eax
  806771:	48 85 c0             	test   %rax,%rax
  806774:	75 07                	jne    80677d <pageref+0x34>
		return 0;
  806776:	b8 00 00 00 00       	mov    $0x0,%eax
  80677b:	eb 53                	jmp    8067d0 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80677d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806781:	48 c1 e8 0c          	shr    $0xc,%rax
  806785:	48 89 c2             	mov    %rax,%rdx
  806788:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80678f:	01 00 00 
  806792:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  806796:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80679a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80679e:	83 e0 01             	and    $0x1,%eax
  8067a1:	48 85 c0             	test   %rax,%rax
  8067a4:	75 07                	jne    8067ad <pageref+0x64>
		return 0;
  8067a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8067ab:	eb 23                	jmp    8067d0 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8067ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8067b1:	48 c1 e8 0c          	shr    $0xc,%rax
  8067b5:	48 89 c2             	mov    %rax,%rdx
  8067b8:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8067bf:	00 00 00 
  8067c2:	48 c1 e2 04          	shl    $0x4,%rdx
  8067c6:	48 01 d0             	add    %rdx,%rax
  8067c9:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8067cd:	0f b7 c0             	movzwl %ax,%eax
}
  8067d0:	c9                   	leaveq 
  8067d1:	c3                   	retq   
