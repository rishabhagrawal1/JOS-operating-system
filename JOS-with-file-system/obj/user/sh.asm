
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
  80003c:	e8 08 11 00 00       	callq  801149 <libmain>
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
  8000d8:	48 bf 08 5d 80 00 00 	movabs $0x805d08,%rdi
  8000df:	00 00 00 
  8000e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e7:	48 ba 30 14 80 00 00 	movabs $0x801430,%rdx
  8000ee:	00 00 00 
  8000f1:	ff d2                	callq  *%rdx
				exit();
  8000f3:	48 b8 d4 11 80 00 00 	movabs $0x8011d4,%rax
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
  80013e:	48 bf 20 5d 80 00 00 	movabs $0x805d20,%rdi
  800145:	00 00 00 
  800148:	b8 00 00 00 00       	mov    $0x0,%eax
  80014d:	48 ba 30 14 80 00 00 	movabs $0x801430,%rdx
  800154:	00 00 00 
  800157:	ff d2                	callq  *%rdx
				exit();
  800159:	48 b8 d4 11 80 00 00 	movabs $0x8011d4,%rax
  800160:	00 00 00 
  800163:	ff d0                	callq  *%rax
			}
			if ((fd = open(t, O_RDONLY)) < 0) {
  800165:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80016c:	be 00 00 00 00       	mov    $0x0,%esi
  800171:	48 89 c7             	mov    %rax,%rdi
  800174:	48 b8 48 40 80 00 00 	movabs $0x804048,%rax
  80017b:	00 00 00 
  80017e:	ff d0                	callq  *%rax
  800180:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800183:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800187:	79 34                	jns    8001bd <runcmd+0x17a>
				cprintf("open %s for read: %e", t, fd);
  800189:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800190:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800193:	48 89 c6             	mov    %rax,%rsi
  800196:	48 bf 46 5d 80 00 00 	movabs $0x805d46,%rdi
  80019d:	00 00 00 
  8001a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a5:	48 b9 30 14 80 00 00 	movabs $0x801430,%rcx
  8001ac:	00 00 00 
  8001af:	ff d1                	callq  *%rcx
				exit();
  8001b1:	48 b8 d4 11 80 00 00 	movabs $0x8011d4,%rax
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
  8001cd:	48 b8 c9 39 80 00 00 	movabs $0x8039c9,%rax
  8001d4:	00 00 00 
  8001d7:	ff d0                	callq  *%rax
				close(fd);
  8001d9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001dc:	89 c7                	mov    %eax,%edi
  8001de:	48 b8 50 39 80 00 00 	movabs $0x803950,%rax
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
  800214:	48 bf 60 5d 80 00 00 	movabs $0x805d60,%rdi
  80021b:	00 00 00 
  80021e:	b8 00 00 00 00       	mov    $0x0,%eax
  800223:	48 ba 30 14 80 00 00 	movabs $0x801430,%rdx
  80022a:	00 00 00 
  80022d:	ff d2                	callq  *%rdx
				exit();
  80022f:	48 b8 d4 11 80 00 00 	movabs $0x8011d4,%rax
  800236:	00 00 00 
  800239:	ff d0                	callq  *%rax
			}
			if ((fd = open(t, O_WRONLY|O_CREAT|O_TRUNC)) < 0) {
  80023b:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800242:	be 01 03 00 00       	mov    $0x301,%esi
  800247:	48 89 c7             	mov    %rax,%rdi
  80024a:	48 b8 48 40 80 00 00 	movabs $0x804048,%rax
  800251:	00 00 00 
  800254:	ff d0                	callq  *%rax
  800256:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800259:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80025d:	79 34                	jns    800293 <runcmd+0x250>
				cprintf("open %s for write: %e", t, fd);
  80025f:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800266:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800269:	48 89 c6             	mov    %rax,%rsi
  80026c:	48 bf 86 5d 80 00 00 	movabs $0x805d86,%rdi
  800273:	00 00 00 
  800276:	b8 00 00 00 00       	mov    $0x0,%eax
  80027b:	48 b9 30 14 80 00 00 	movabs $0x801430,%rcx
  800282:	00 00 00 
  800285:	ff d1                	callq  *%rcx
				exit();
  800287:	48 b8 d4 11 80 00 00 	movabs $0x8011d4,%rax
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
  8002a3:	48 b8 c9 39 80 00 00 	movabs $0x8039c9,%rax
  8002aa:	00 00 00 
  8002ad:	ff d0                	callq  *%rax
				close(fd);
  8002af:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8002b2:	89 c7                	mov    %eax,%edi
  8002b4:	48 b8 50 39 80 00 00 	movabs $0x803950,%rax
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
  8002d4:	48 b8 db 52 80 00 00 	movabs $0x8052db,%rax
  8002db:	00 00 00 
  8002de:	ff d0                	callq  *%rax
  8002e0:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8002e3:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8002e7:	79 2c                	jns    800315 <runcmd+0x2d2>
				cprintf("pipe: %e", r);
  8002e9:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8002ec:	89 c6                	mov    %eax,%esi
  8002ee:	48 bf 9c 5d 80 00 00 	movabs $0x805d9c,%rdi
  8002f5:	00 00 00 
  8002f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fd:	48 ba 30 14 80 00 00 	movabs $0x801430,%rdx
  800304:	00 00 00 
  800307:	ff d2                	callq  *%rdx
				exit();
  800309:	48 b8 d4 11 80 00 00 	movabs $0x8011d4,%rax
  800310:	00 00 00 
  800313:	ff d0                	callq  *%rax
			}
			if (debug)
  800315:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80031c:	00 00 00 
  80031f:	8b 00                	mov    (%rax),%eax
  800321:	85 c0                	test   %eax,%eax
  800323:	74 29                	je     80034e <runcmd+0x30b>
				cprintf("PIPE: %d %d\n", p[0], p[1]);
  800325:	8b 95 44 fb ff ff    	mov    -0x4bc(%rbp),%edx
  80032b:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  800331:	89 c6                	mov    %eax,%esi
  800333:	48 bf a5 5d 80 00 00 	movabs $0x805da5,%rdi
  80033a:	00 00 00 
  80033d:	b8 00 00 00 00       	mov    $0x0,%eax
  800342:	48 b9 30 14 80 00 00 	movabs $0x801430,%rcx
  800349:	00 00 00 
  80034c:	ff d1                	callq  *%rcx
			if ((r = fork()) < 0) {
  80034e:	48 b8 c4 30 80 00 00 	movabs $0x8030c4,%rax
  800355:	00 00 00 
  800358:	ff d0                	callq  *%rax
  80035a:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80035d:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800361:	79 2c                	jns    80038f <runcmd+0x34c>
				cprintf("fork: %e", r);
  800363:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800366:	89 c6                	mov    %eax,%esi
  800368:	48 bf b2 5d 80 00 00 	movabs $0x805db2,%rdi
  80036f:	00 00 00 
  800372:	b8 00 00 00 00       	mov    $0x0,%eax
  800377:	48 ba 30 14 80 00 00 	movabs $0x801430,%rdx
  80037e:	00 00 00 
  800381:	ff d2                	callq  *%rdx
				exit();
  800383:	48 b8 d4 11 80 00 00 	movabs $0x8011d4,%rax
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
  8003ac:	48 b8 c9 39 80 00 00 	movabs $0x8039c9,%rax
  8003b3:	00 00 00 
  8003b6:	ff d0                	callq  *%rax
					close(p[0]);
  8003b8:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  8003be:	89 c7                	mov    %eax,%edi
  8003c0:	48 b8 50 39 80 00 00 	movabs $0x803950,%rax
  8003c7:	00 00 00 
  8003ca:	ff d0                	callq  *%rax
				}
				close(p[1]);
  8003cc:	8b 85 44 fb ff ff    	mov    -0x4bc(%rbp),%eax
  8003d2:	89 c7                	mov    %eax,%edi
  8003d4:	48 b8 50 39 80 00 00 	movabs $0x803950,%rax
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
  800403:	48 b8 c9 39 80 00 00 	movabs $0x8039c9,%rax
  80040a:	00 00 00 
  80040d:	ff d0                	callq  *%rax
					close(p[1]);
  80040f:	8b 85 44 fb ff ff    	mov    -0x4bc(%rbp),%eax
  800415:	89 c7                	mov    %eax,%edi
  800417:	48 b8 50 39 80 00 00 	movabs $0x803950,%rax
  80041e:	00 00 00 
  800421:	ff d0                	callq  *%rax
				}
				close(p[0]);
  800423:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  800429:	89 c7                	mov    %eax,%edi
  80042b:	48 b8 50 39 80 00 00 	movabs $0x803950,%rax
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
  80043e:	48 ba bb 5d 80 00 00 	movabs $0x805dbb,%rdx
  800445:	00 00 00 
  800448:	be 6f 00 00 00       	mov    $0x6f,%esi
  80044d:	48 bf d7 5d 80 00 00 	movabs $0x805dd7,%rdi
  800454:	00 00 00 
  800457:	b8 00 00 00 00       	mov    $0x0,%eax
  80045c:	49 b8 f7 11 80 00 00 	movabs $0x8011f7,%r8
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
  800475:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80047c:	00 00 00 
  80047f:	8b 00                	mov    (%rax),%eax
  800481:	85 c0                	test   %eax,%eax
  800483:	0f 84 79 03 00 00    	je     800802 <runcmd+0x7bf>
			cprintf("EMPTY COMMAND\n");
  800489:	48 bf e1 5d 80 00 00 	movabs $0x805de1,%rdi
  800490:	00 00 00 
  800493:	b8 00 00 00 00       	mov    $0x0,%eax
  800498:	48 ba 30 14 80 00 00 	movabs $0x801430,%rdx
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
  8004b5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8004bc:	00 00 00 
  8004bf:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8004c2:	48 63 d2             	movslq %edx,%rdx
  8004c5:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8004c9:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  8004d0:	48 89 d6             	mov    %rdx,%rsi
  8004d3:	48 89 c7             	mov    %rax,%rdi
  8004d6:	48 b8 3f 21 80 00 00 	movabs $0x80213f,%rax
  8004dd:	00 00 00 
  8004e0:	ff d0                	callq  *%rax
        strcat(argv0buf, argv[0]);
  8004e2:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  8004e9:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  8004f0:	48 89 d6             	mov    %rdx,%rsi
  8004f3:	48 89 c7             	mov    %rax,%rdi
  8004f6:	48 b8 82 21 80 00 00 	movabs $0x802182,%rax
  8004fd:	00 00 00 
  800500:	ff d0                	callq  *%rax
        r = stat(argv0buf, &st);
  800502:	48 8d 95 b0 fa ff ff 	lea    -0x550(%rbp),%rdx
  800509:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  800510:	48 89 d6             	mov    %rdx,%rsi
  800513:	48 89 c7             	mov    %rax,%rdi
  800516:	48 b8 5a 3f 80 00 00 	movabs $0x803f5a,%rax
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
  80053f:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
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
  800581:	48 b8 3f 21 80 00 00 	movabs $0x80213f,%rax
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
  8005ac:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8005b3:	00 00 00 
  8005b6:	8b 00                	mov    (%rax),%eax
  8005b8:	85 c0                	test   %eax,%eax
  8005ba:	0f 84 95 00 00 00    	je     800655 <runcmd+0x612>
		cprintf("[%08x] SPAWN:", thisenv->env_id);
  8005c0:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  8005c7:	00 00 00 
  8005ca:	48 8b 00             	mov    (%rax),%rax
  8005cd:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8005d3:	89 c6                	mov    %eax,%esi
  8005d5:	48 bf f0 5d 80 00 00 	movabs $0x805df0,%rdi
  8005dc:	00 00 00 
  8005df:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e4:	48 ba 30 14 80 00 00 	movabs $0x801430,%rdx
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
  800609:	48 bf fe 5d 80 00 00 	movabs $0x805dfe,%rdi
  800610:	00 00 00 
  800613:	b8 00 00 00 00       	mov    $0x0,%eax
  800618:	48 ba 30 14 80 00 00 	movabs $0x801430,%rdx
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
  80063a:	48 bf 02 5e 80 00 00 	movabs $0x805e02,%rdi
  800641:	00 00 00 
  800644:	b8 00 00 00 00       	mov    $0x0,%eax
  800649:	48 ba 30 14 80 00 00 	movabs $0x801430,%rdx
  800650:	00 00 00 
  800653:	ff d2                	callq  *%rdx
	}

	// Spawn the command!
	if ((r = spawn(argv[0], (const char**) argv)) < 0)
  800655:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80065c:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  800663:	48 89 d6             	mov    %rdx,%rsi
  800666:	48 89 c7             	mov    %rax,%rdi
  800669:	48 b8 87 47 80 00 00 	movabs $0x804787,%rax
  800670:	00 00 00 
  800673:	ff d0                	callq  *%rax
  800675:	89 45 e8             	mov    %eax,-0x18(%rbp)
  800678:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80067c:	79 28                	jns    8006a6 <runcmd+0x663>
		cprintf("spawn %s: %e\n", argv[0], r);
  80067e:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  800685:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800688:	48 89 c6             	mov    %rax,%rsi
  80068b:	48 bf 04 5e 80 00 00 	movabs $0x805e04,%rdi
  800692:	00 00 00 
  800695:	b8 00 00 00 00       	mov    $0x0,%eax
  80069a:	48 b9 30 14 80 00 00 	movabs $0x801430,%rcx
  8006a1:	00 00 00 
  8006a4:	ff d1                	callq  *%rcx

	// In the parent, close all file descriptors and wait for the
	// spawned command to exit.
	close_all();
  8006a6:	48 b8 9b 39 80 00 00 	movabs $0x80399b,%rax
  8006ad:	00 00 00 
  8006b0:	ff d0                	callq  *%rax
	if (r >= 0) {
  8006b2:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8006b6:	0f 88 9c 00 00 00    	js     800758 <runcmd+0x715>
		if (debug)
  8006bc:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8006c3:	00 00 00 
  8006c6:	8b 00                	mov    (%rax),%eax
  8006c8:	85 c0                	test   %eax,%eax
  8006ca:	74 3b                	je     800707 <runcmd+0x6c4>
			cprintf("[%08x] WAIT %s %08x\n", thisenv->env_id, argv[0], r);
  8006cc:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  8006d3:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  8006da:	00 00 00 
  8006dd:	48 8b 00             	mov    (%rax),%rax
  8006e0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8006e6:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8006e9:	89 c6                	mov    %eax,%esi
  8006eb:	48 bf 12 5e 80 00 00 	movabs $0x805e12,%rdi
  8006f2:	00 00 00 
  8006f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8006fa:	49 b8 30 14 80 00 00 	movabs $0x801430,%r8
  800701:	00 00 00 
  800704:	41 ff d0             	callq  *%r8
		wait(r);
  800707:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80070a:	89 c7                	mov    %eax,%edi
  80070c:	48 b8 a4 58 80 00 00 	movabs $0x8058a4,%rax
  800713:	00 00 00 
  800716:	ff d0                	callq  *%rax
		if (debug)
  800718:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80071f:	00 00 00 
  800722:	8b 00                	mov    (%rax),%eax
  800724:	85 c0                	test   %eax,%eax
  800726:	74 30                	je     800758 <runcmd+0x715>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  800728:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  80072f:	00 00 00 
  800732:	48 8b 00             	mov    (%rax),%rax
  800735:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80073b:	89 c6                	mov    %eax,%esi
  80073d:	48 bf 27 5e 80 00 00 	movabs $0x805e27,%rdi
  800744:	00 00 00 
  800747:	b8 00 00 00 00       	mov    $0x0,%eax
  80074c:	48 ba 30 14 80 00 00 	movabs $0x801430,%rdx
  800753:	00 00 00 
  800756:	ff d2                	callq  *%rdx
	}

	// If we were the left-hand part of a pipe,
	// wait for the right-hand part to finish.
	if (pipe_child) {
  800758:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80075c:	0f 84 94 00 00 00    	je     8007f6 <runcmd+0x7b3>
		if (debug)
  800762:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800769:	00 00 00 
  80076c:	8b 00                	mov    (%rax),%eax
  80076e:	85 c0                	test   %eax,%eax
  800770:	74 33                	je     8007a5 <runcmd+0x762>
			cprintf("[%08x] WAIT pipe_child %08x\n", thisenv->env_id, pipe_child);
  800772:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  800779:	00 00 00 
  80077c:	48 8b 00             	mov    (%rax),%rax
  80077f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800785:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800788:	89 c6                	mov    %eax,%esi
  80078a:	48 bf 3d 5e 80 00 00 	movabs $0x805e3d,%rdi
  800791:	00 00 00 
  800794:	b8 00 00 00 00       	mov    $0x0,%eax
  800799:	48 b9 30 14 80 00 00 	movabs $0x801430,%rcx
  8007a0:	00 00 00 
  8007a3:	ff d1                	callq  *%rcx
		wait(pipe_child);
  8007a5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8007a8:	89 c7                	mov    %eax,%edi
  8007aa:	48 b8 a4 58 80 00 00 	movabs $0x8058a4,%rax
  8007b1:	00 00 00 
  8007b4:	ff d0                	callq  *%rax
		if (debug)
  8007b6:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8007bd:	00 00 00 
  8007c0:	8b 00                	mov    (%rax),%eax
  8007c2:	85 c0                	test   %eax,%eax
  8007c4:	74 30                	je     8007f6 <runcmd+0x7b3>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  8007c6:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  8007cd:	00 00 00 
  8007d0:	48 8b 00             	mov    (%rax),%rax
  8007d3:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8007d9:	89 c6                	mov    %eax,%esi
  8007db:	48 bf 27 5e 80 00 00 	movabs $0x805e27,%rdi
  8007e2:	00 00 00 
  8007e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ea:	48 ba 30 14 80 00 00 	movabs $0x801430,%rdx
  8007f1:	00 00 00 
  8007f4:	ff d2                	callq  *%rdx
	}

	// Done!
	exit();
  8007f6:	48 b8 d4 11 80 00 00 	movabs $0x8011d4,%rax
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
  80081f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800826:	00 00 00 
  800829:	8b 00                	mov    (%rax),%eax
  80082b:	83 f8 01             	cmp    $0x1,%eax
  80082e:	7e 1b                	jle    80084b <_gettoken+0x47>
			cprintf("GETTOKEN NULL\n");
  800830:	48 bf 5a 5e 80 00 00 	movabs $0x805e5a,%rdi
  800837:	00 00 00 
  80083a:	b8 00 00 00 00       	mov    $0x0,%eax
  80083f:	48 ba 30 14 80 00 00 	movabs $0x801430,%rdx
  800846:	00 00 00 
  800849:	ff d2                	callq  *%rdx
		return 0;
  80084b:	b8 00 00 00 00       	mov    $0x0,%eax
  800850:	e9 04 02 00 00       	jmpq   800a59 <_gettoken+0x255>
	}

	if (debug > 1)
  800855:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80085c:	00 00 00 
  80085f:	8b 00                	mov    (%rax),%eax
  800861:	83 f8 01             	cmp    $0x1,%eax
  800864:	7e 22                	jle    800888 <_gettoken+0x84>
		cprintf("GETTOKEN: %s\n", s);
  800866:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80086a:	48 89 c6             	mov    %rax,%rsi
  80086d:	48 bf 69 5e 80 00 00 	movabs $0x805e69,%rdi
  800874:	00 00 00 
  800877:	b8 00 00 00 00       	mov    $0x0,%eax
  80087c:	48 ba 30 14 80 00 00 	movabs $0x801430,%rdx
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
  8008bb:	48 bf 77 5e 80 00 00 	movabs $0x805e77,%rdi
  8008c2:	00 00 00 
  8008c5:	48 b8 65 23 80 00 00 	movabs $0x802365,%rax
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
  8008e1:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8008e8:	00 00 00 
  8008eb:	8b 00                	mov    (%rax),%eax
  8008ed:	83 f8 01             	cmp    $0x1,%eax
  8008f0:	7e 1b                	jle    80090d <_gettoken+0x109>
			cprintf("EOL\n");
  8008f2:	48 bf 7c 5e 80 00 00 	movabs $0x805e7c,%rdi
  8008f9:	00 00 00 
  8008fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800901:	48 ba 30 14 80 00 00 	movabs $0x801430,%rdx
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
  800923:	48 bf 81 5e 80 00 00 	movabs $0x805e81,%rdi
  80092a:	00 00 00 
  80092d:	48 b8 65 23 80 00 00 	movabs $0x802365,%rax
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
  800970:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800977:	00 00 00 
  80097a:	8b 00                	mov    (%rax),%eax
  80097c:	83 f8 01             	cmp    $0x1,%eax
  80097f:	7e 20                	jle    8009a1 <_gettoken+0x19d>
			cprintf("TOK %c\n", t);
  800981:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800984:	89 c6                	mov    %eax,%esi
  800986:	48 bf 89 5e 80 00 00 	movabs $0x805e89,%rdi
  80098d:	00 00 00 
  800990:	b8 00 00 00 00       	mov    $0x0,%eax
  800995:	48 ba 30 14 80 00 00 	movabs $0x801430,%rdx
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
  8009d2:	48 bf 91 5e 80 00 00 	movabs $0x805e91,%rdi
  8009d9:	00 00 00 
  8009dc:	48 b8 65 23 80 00 00 	movabs $0x802365,%rax
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
  8009f8:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
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
  800a2d:	48 bf 9d 5e 80 00 00 	movabs $0x805e9d,%rdi
  800a34:	00 00 00 
  800a37:	b8 00 00 00 00       	mov    $0x0,%eax
  800a3c:	48 ba 30 14 80 00 00 	movabs $0x801430,%rdx
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
  800a76:	48 ba 10 90 80 00 00 	movabs $0x809010,%rdx
  800a7d:	00 00 00 
  800a80:	48 be 08 90 80 00 00 	movabs $0x809008,%rsi
  800a87:	00 00 00 
  800a8a:	48 89 c7             	mov    %rax,%rdi
  800a8d:	48 b8 04 08 80 00 00 	movabs $0x800804,%rax
  800a94:	00 00 00 
  800a97:	ff d0                	callq  *%rax
  800a99:	48 ba 18 90 80 00 00 	movabs $0x809018,%rdx
  800aa0:	00 00 00 
  800aa3:	89 02                	mov    %eax,(%rdx)
		return 0;
  800aa5:	b8 00 00 00 00       	mov    $0x0,%eax
  800aaa:	eb 74                	jmp    800b20 <gettoken+0xc5>
	}
	c = nc;
  800aac:	48 b8 18 90 80 00 00 	movabs $0x809018,%rax
  800ab3:	00 00 00 
  800ab6:	8b 10                	mov    (%rax),%edx
  800ab8:	48 b8 1c 90 80 00 00 	movabs $0x80901c,%rax
  800abf:	00 00 00 
  800ac2:	89 10                	mov    %edx,(%rax)
	*p1 = np1;
  800ac4:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  800acb:	00 00 00 
  800ace:	48 8b 10             	mov    (%rax),%rdx
  800ad1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ad5:	48 89 10             	mov    %rdx,(%rax)
	nc = _gettoken(np2, &np1, &np2);
  800ad8:	48 b8 10 90 80 00 00 	movabs $0x809010,%rax
  800adf:	00 00 00 
  800ae2:	48 8b 00             	mov    (%rax),%rax
  800ae5:	48 ba 10 90 80 00 00 	movabs $0x809010,%rdx
  800aec:	00 00 00 
  800aef:	48 be 08 90 80 00 00 	movabs $0x809008,%rsi
  800af6:	00 00 00 
  800af9:	48 89 c7             	mov    %rax,%rdi
  800afc:	48 b8 04 08 80 00 00 	movabs $0x800804,%rax
  800b03:	00 00 00 
  800b06:	ff d0                	callq  *%rax
  800b08:	48 ba 18 90 80 00 00 	movabs $0x809018,%rdx
  800b0f:	00 00 00 
  800b12:	89 02                	mov    %eax,(%rdx)
	return c;
  800b14:	48 b8 1c 90 80 00 00 	movabs $0x80901c,%rax
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
  800b26:	48 bf a8 5e 80 00 00 	movabs $0x805ea8,%rdi
  800b2d:	00 00 00 
  800b30:	b8 00 00 00 00       	mov    $0x0,%eax
  800b35:	48 ba 30 14 80 00 00 	movabs $0x801430,%rdx
  800b3c:	00 00 00 
  800b3f:	ff d2                	callq  *%rdx
	exit();
  800b41:	48 b8 d4 11 80 00 00 	movabs $0x8011d4,%rax
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
  800b7e:	48 b8 75 33 80 00 00 	movabs $0x803375,%rax
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
  800b9e:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800ba5:	00 00 00 
  800ba8:	8b 00                	mov    (%rax),%eax
  800baa:	8d 50 01             	lea    0x1(%rax),%edx
  800bad:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
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
	struct Argstate args;

	interactive = '?';
	echocmds = 0;
	argstart(&argc, argv, &args);
	while ((r = argnext(&args)) >= 0)
  800bd9:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  800bdd:	48 89 c7             	mov    %rax,%rdi
  800be0:	48 b8 d9 33 80 00 00 	movabs $0x8033d9,%rax
  800be7:	00 00 00 
  800bea:	ff d0                	callq  *%rax
  800bec:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800bef:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800bf3:	79 97                	jns    800b8c <umain+0x3d>
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
  800c1a:	48 b8 50 39 80 00 00 	movabs $0x803950,%rax
  800c21:	00 00 00 
  800c24:	ff d0                	callq  *%rax
		if ((r = open(argv[1], O_RDONLY)) < 0)
  800c26:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800c2a:	48 83 c0 08          	add    $0x8,%rax
  800c2e:	48 8b 00             	mov    (%rax),%rax
  800c31:	be 00 00 00 00       	mov    $0x0,%esi
  800c36:	48 89 c7             	mov    %rax,%rdi
  800c39:	48 b8 48 40 80 00 00 	movabs $0x804048,%rax
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
  800c62:	48 ba c9 5e 80 00 00 	movabs $0x805ec9,%rdx
  800c69:	00 00 00 
  800c6c:	be 2b 01 00 00       	mov    $0x12b,%esi
  800c71:	48 bf d7 5d 80 00 00 	movabs $0x805dd7,%rdi
  800c78:	00 00 00 
  800c7b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c80:	49 b9 f7 11 80 00 00 	movabs $0x8011f7,%r9
  800c87:	00 00 00 
  800c8a:	41 ff d1             	callq  *%r9
		assert(r == 0);
  800c8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800c91:	74 35                	je     800cc8 <umain+0x179>
  800c93:	48 b9 d5 5e 80 00 00 	movabs $0x805ed5,%rcx
  800c9a:	00 00 00 
  800c9d:	48 ba dc 5e 80 00 00 	movabs $0x805edc,%rdx
  800ca4:	00 00 00 
  800ca7:	be 2c 01 00 00       	mov    $0x12c,%esi
  800cac:	48 bf d7 5d 80 00 00 	movabs $0x805dd7,%rdi
  800cb3:	00 00 00 
  800cb6:	b8 00 00 00 00       	mov    $0x0,%eax
  800cbb:	49 b8 f7 11 80 00 00 	movabs $0x8011f7,%r8
  800cc2:	00 00 00 
  800cc5:	41 ff d0             	callq  *%r8
	}
	if (interactive == '?')
  800cc8:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%rbp)
  800ccc:	75 14                	jne    800ce2 <umain+0x193>
		interactive = iscons(0);
  800cce:	bf 00 00 00 00       	mov    $0x0,%edi
  800cd3:	48 b8 0a 0f 80 00 00 	movabs $0x800f0a,%rax
  800cda:	00 00 00 
  800cdd:	ff d0                	callq  *%rax
  800cdf:	89 45 fc             	mov    %eax,-0x4(%rbp)

	while (1) {
		char *buf;

		buf = readline(interactive ? "$ " : NULL);
  800ce2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ce6:	74 0c                	je     800cf4 <umain+0x1a5>
  800ce8:	48 b8 f1 5e 80 00 00 	movabs $0x805ef1,%rax
  800cef:	00 00 00 
  800cf2:	eb 05                	jmp    800cf9 <umain+0x1aa>
  800cf4:	b8 00 00 00 00       	mov    $0x0,%eax
  800cf9:	48 89 c7             	mov    %rax,%rdi
  800cfc:	48 b8 79 1f 80 00 00 	movabs $0x801f79,%rax
  800d03:	00 00 00 
  800d06:	ff d0                	callq  *%rax
  800d08:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		if (buf == NULL) {
  800d0c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800d11:	75 37                	jne    800d4a <umain+0x1fb>
			if (debug)
  800d13:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800d1a:	00 00 00 
  800d1d:	8b 00                	mov    (%rax),%eax
  800d1f:	85 c0                	test   %eax,%eax
  800d21:	74 1b                	je     800d3e <umain+0x1ef>
				cprintf("EXITING\n");
  800d23:	48 bf f4 5e 80 00 00 	movabs $0x805ef4,%rdi
  800d2a:	00 00 00 
  800d2d:	b8 00 00 00 00       	mov    $0x0,%eax
  800d32:	48 ba 30 14 80 00 00 	movabs $0x801430,%rdx
  800d39:	00 00 00 
  800d3c:	ff d2                	callq  *%rdx
			exit();	// end of file
  800d3e:	48 b8 d4 11 80 00 00 	movabs $0x8011d4,%rax
  800d45:	00 00 00 
  800d48:	ff d0                	callq  *%rax
		}
		if (debug)
  800d4a:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800d51:	00 00 00 
  800d54:	8b 00                	mov    (%rax),%eax
  800d56:	85 c0                	test   %eax,%eax
  800d58:	74 22                	je     800d7c <umain+0x22d>
			cprintf("LINE: %s\n", buf);
  800d5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d5e:	48 89 c6             	mov    %rax,%rsi
  800d61:	48 bf fd 5e 80 00 00 	movabs $0x805efd,%rdi
  800d68:	00 00 00 
  800d6b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d70:	48 ba 30 14 80 00 00 	movabs $0x801430,%rdx
  800d77:	00 00 00 
  800d7a:	ff d2                	callq  *%rdx
		if (buf[0] == '#')
  800d7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d80:	0f b6 00             	movzbl (%rax),%eax
  800d83:	3c 23                	cmp    $0x23,%al
  800d85:	75 05                	jne    800d8c <umain+0x23d>
			continue;
  800d87:	e9 05 01 00 00       	jmpq   800e91 <umain+0x342>
		if (echocmds)
  800d8c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800d90:	74 22                	je     800db4 <umain+0x265>
			printf("# %s\n", buf);
  800d92:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d96:	48 89 c6             	mov    %rax,%rsi
  800d99:	48 bf 07 5f 80 00 00 	movabs $0x805f07,%rdi
  800da0:	00 00 00 
  800da3:	b8 00 00 00 00       	mov    $0x0,%eax
  800da8:	48 ba d1 46 80 00 00 	movabs $0x8046d1,%rdx
  800daf:	00 00 00 
  800db2:	ff d2                	callq  *%rdx
			//fprintf(1, "# %s\n", buf);
		if (debug)
  800db4:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800dbb:	00 00 00 
  800dbe:	8b 00                	mov    (%rax),%eax
  800dc0:	85 c0                	test   %eax,%eax
  800dc2:	74 1b                	je     800ddf <umain+0x290>
			cprintf("BEFORE FORK\n");
  800dc4:	48 bf 0d 5f 80 00 00 	movabs $0x805f0d,%rdi
  800dcb:	00 00 00 
  800dce:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd3:	48 ba 30 14 80 00 00 	movabs $0x801430,%rdx
  800dda:	00 00 00 
  800ddd:	ff d2                	callq  *%rdx
		if ((r = fork()) < 0)
  800ddf:	48 b8 c4 30 80 00 00 	movabs $0x8030c4,%rax
  800de6:	00 00 00 
  800de9:	ff d0                	callq  *%rax
  800deb:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800dee:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800df2:	79 30                	jns    800e24 <umain+0x2d5>
			panic("fork: %e", r);
  800df4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800df7:	89 c1                	mov    %eax,%ecx
  800df9:	48 ba b2 5d 80 00 00 	movabs $0x805db2,%rdx
  800e00:	00 00 00 
  800e03:	be 44 01 00 00       	mov    $0x144,%esi
  800e08:	48 bf d7 5d 80 00 00 	movabs $0x805dd7,%rdi
  800e0f:	00 00 00 
  800e12:	b8 00 00 00 00       	mov    $0x0,%eax
  800e17:	49 b8 f7 11 80 00 00 	movabs $0x8011f7,%r8
  800e1e:	00 00 00 
  800e21:	41 ff d0             	callq  *%r8
		if (debug)
  800e24:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800e2b:	00 00 00 
  800e2e:	8b 00                	mov    (%rax),%eax
  800e30:	85 c0                	test   %eax,%eax
  800e32:	74 20                	je     800e54 <umain+0x305>
			cprintf("FORK: %d\n", r);
  800e34:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800e37:	89 c6                	mov    %eax,%esi
  800e39:	48 bf 1a 5f 80 00 00 	movabs $0x805f1a,%rdi
  800e40:	00 00 00 
  800e43:	b8 00 00 00 00       	mov    $0x0,%eax
  800e48:	48 ba 30 14 80 00 00 	movabs $0x801430,%rdx
  800e4f:	00 00 00 
  800e52:	ff d2                	callq  *%rdx
		if (r == 0) {
  800e54:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800e58:	75 21                	jne    800e7b <umain+0x32c>
			runcmd(buf);
  800e5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e5e:	48 89 c7             	mov    %rax,%rdi
  800e61:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800e68:	00 00 00 
  800e6b:	ff d0                	callq  *%rax
			exit();
  800e6d:	48 b8 d4 11 80 00 00 	movabs $0x8011d4,%rax
  800e74:	00 00 00 
  800e77:	ff d0                	callq  *%rax
  800e79:	eb 16                	jmp    800e91 <umain+0x342>
		} else
			wait(r);
  800e7b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800e7e:	89 c7                	mov    %eax,%edi
  800e80:	48 b8 a4 58 80 00 00 	movabs $0x8058a4,%rax
  800e87:	00 00 00 
  800e8a:	ff d0                	callq  *%rax
	}
  800e8c:	e9 51 fe ff ff       	jmpq   800ce2 <umain+0x193>
  800e91:	e9 4c fe ff ff       	jmpq   800ce2 <umain+0x193>

0000000000800e96 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800e96:	55                   	push   %rbp
  800e97:	48 89 e5             	mov    %rsp,%rbp
  800e9a:	48 83 ec 20          	sub    $0x20,%rsp
  800e9e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  800ea1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800ea4:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800ea7:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  800eab:	be 01 00 00 00       	mov    $0x1,%esi
  800eb0:	48 89 c7             	mov    %rax,%rdi
  800eb3:	48 b8 26 29 80 00 00 	movabs $0x802926,%rax
  800eba:	00 00 00 
  800ebd:	ff d0                	callq  *%rax
}
  800ebf:	c9                   	leaveq 
  800ec0:	c3                   	retq   

0000000000800ec1 <getchar>:

int
getchar(void)
{
  800ec1:	55                   	push   %rbp
  800ec2:	48 89 e5             	mov    %rsp,%rbp
  800ec5:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  800ec9:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  800ecd:	ba 01 00 00 00       	mov    $0x1,%edx
  800ed2:	48 89 c6             	mov    %rax,%rsi
  800ed5:	bf 00 00 00 00       	mov    $0x0,%edi
  800eda:	48 b8 72 3b 80 00 00 	movabs $0x803b72,%rax
  800ee1:	00 00 00 
  800ee4:	ff d0                	callq  *%rax
  800ee6:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  800ee9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800eed:	79 05                	jns    800ef4 <getchar+0x33>
		return r;
  800eef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ef2:	eb 14                	jmp    800f08 <getchar+0x47>
	if (r < 1)
  800ef4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ef8:	7f 07                	jg     800f01 <getchar+0x40>
		return -E_EOF;
  800efa:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  800eff:	eb 07                	jmp    800f08 <getchar+0x47>
	return c;
  800f01:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  800f05:	0f b6 c0             	movzbl %al,%eax
}
  800f08:	c9                   	leaveq 
  800f09:	c3                   	retq   

0000000000800f0a <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  800f0a:	55                   	push   %rbp
  800f0b:	48 89 e5             	mov    %rsp,%rbp
  800f0e:	48 83 ec 20          	sub    $0x20,%rsp
  800f12:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f15:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800f19:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800f1c:	48 89 d6             	mov    %rdx,%rsi
  800f1f:	89 c7                	mov    %eax,%edi
  800f21:	48 b8 40 37 80 00 00 	movabs $0x803740,%rax
  800f28:	00 00 00 
  800f2b:	ff d0                	callq  *%rax
  800f2d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800f30:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f34:	79 05                	jns    800f3b <iscons+0x31>
		return r;
  800f36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f39:	eb 1a                	jmp    800f55 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  800f3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f3f:	8b 10                	mov    (%rax),%edx
  800f41:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  800f48:	00 00 00 
  800f4b:	8b 00                	mov    (%rax),%eax
  800f4d:	39 c2                	cmp    %eax,%edx
  800f4f:	0f 94 c0             	sete   %al
  800f52:	0f b6 c0             	movzbl %al,%eax
}
  800f55:	c9                   	leaveq 
  800f56:	c3                   	retq   

0000000000800f57 <opencons>:

int
opencons(void)
{
  800f57:	55                   	push   %rbp
  800f58:	48 89 e5             	mov    %rsp,%rbp
  800f5b:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800f5f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800f63:	48 89 c7             	mov    %rax,%rdi
  800f66:	48 b8 a8 36 80 00 00 	movabs $0x8036a8,%rax
  800f6d:	00 00 00 
  800f70:	ff d0                	callq  *%rax
  800f72:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800f75:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f79:	79 05                	jns    800f80 <opencons+0x29>
		return r;
  800f7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f7e:	eb 5b                	jmp    800fdb <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800f80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f84:	ba 07 04 00 00       	mov    $0x407,%edx
  800f89:	48 89 c6             	mov    %rax,%rsi
  800f8c:	bf 00 00 00 00       	mov    $0x0,%edi
  800f91:	48 b8 6e 2a 80 00 00 	movabs $0x802a6e,%rax
  800f98:	00 00 00 
  800f9b:	ff d0                	callq  *%rax
  800f9d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800fa0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800fa4:	79 05                	jns    800fab <opencons+0x54>
		return r;
  800fa6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fa9:	eb 30                	jmp    800fdb <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  800fab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800faf:	48 ba 20 80 80 00 00 	movabs $0x808020,%rdx
  800fb6:	00 00 00 
  800fb9:	8b 12                	mov    (%rdx),%edx
  800fbb:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  800fbd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fc1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  800fc8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fcc:	48 89 c7             	mov    %rax,%rdi
  800fcf:	48 b8 5a 36 80 00 00 	movabs $0x80365a,%rax
  800fd6:	00 00 00 
  800fd9:	ff d0                	callq  *%rax
}
  800fdb:	c9                   	leaveq 
  800fdc:	c3                   	retq   

0000000000800fdd <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  800fdd:	55                   	push   %rbp
  800fde:	48 89 e5             	mov    %rsp,%rbp
  800fe1:	48 83 ec 30          	sub    $0x30,%rsp
  800fe5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fe9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800fed:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  800ff1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800ff6:	75 07                	jne    800fff <devcons_read+0x22>
		return 0;
  800ff8:	b8 00 00 00 00       	mov    $0x0,%eax
  800ffd:	eb 4b                	jmp    80104a <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  800fff:	eb 0c                	jmp    80100d <devcons_read+0x30>
		sys_yield();
  801001:	48 b8 30 2a 80 00 00 	movabs $0x802a30,%rax
  801008:	00 00 00 
  80100b:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80100d:	48 b8 70 29 80 00 00 	movabs $0x802970,%rax
  801014:	00 00 00 
  801017:	ff d0                	callq  *%rax
  801019:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80101c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801020:	74 df                	je     801001 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  801022:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801026:	79 05                	jns    80102d <devcons_read+0x50>
		return c;
  801028:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80102b:	eb 1d                	jmp    80104a <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80102d:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  801031:	75 07                	jne    80103a <devcons_read+0x5d>
		return 0;
  801033:	b8 00 00 00 00       	mov    $0x0,%eax
  801038:	eb 10                	jmp    80104a <devcons_read+0x6d>
	*(char*)vbuf = c;
  80103a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80103d:	89 c2                	mov    %eax,%edx
  80103f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801043:	88 10                	mov    %dl,(%rax)
	return 1;
  801045:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80104a:	c9                   	leaveq 
  80104b:	c3                   	retq   

000000000080104c <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80104c:	55                   	push   %rbp
  80104d:	48 89 e5             	mov    %rsp,%rbp
  801050:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  801057:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80105e:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  801065:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80106c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801073:	eb 76                	jmp    8010eb <devcons_write+0x9f>
		m = n - tot;
  801075:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80107c:	89 c2                	mov    %eax,%edx
  80107e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801081:	29 c2                	sub    %eax,%edx
  801083:	89 d0                	mov    %edx,%eax
  801085:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  801088:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80108b:	83 f8 7f             	cmp    $0x7f,%eax
  80108e:	76 07                	jbe    801097 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  801090:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  801097:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80109a:	48 63 d0             	movslq %eax,%rdx
  80109d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010a0:	48 63 c8             	movslq %eax,%rcx
  8010a3:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8010aa:	48 01 c1             	add    %rax,%rcx
  8010ad:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8010b4:	48 89 ce             	mov    %rcx,%rsi
  8010b7:	48 89 c7             	mov    %rax,%rdi
  8010ba:	48 b8 63 24 80 00 00 	movabs $0x802463,%rax
  8010c1:	00 00 00 
  8010c4:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8010c6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8010c9:	48 63 d0             	movslq %eax,%rdx
  8010cc:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8010d3:	48 89 d6             	mov    %rdx,%rsi
  8010d6:	48 89 c7             	mov    %rax,%rdi
  8010d9:	48 b8 26 29 80 00 00 	movabs $0x802926,%rax
  8010e0:	00 00 00 
  8010e3:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8010e5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8010e8:	01 45 fc             	add    %eax,-0x4(%rbp)
  8010eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010ee:	48 98                	cltq   
  8010f0:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8010f7:	0f 82 78 ff ff ff    	jb     801075 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8010fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801100:	c9                   	leaveq 
  801101:	c3                   	retq   

0000000000801102 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  801102:	55                   	push   %rbp
  801103:	48 89 e5             	mov    %rsp,%rbp
  801106:	48 83 ec 08          	sub    $0x8,%rsp
  80110a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80110e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801113:	c9                   	leaveq 
  801114:	c3                   	retq   

0000000000801115 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801115:	55                   	push   %rbp
  801116:	48 89 e5             	mov    %rsp,%rbp
  801119:	48 83 ec 10          	sub    $0x10,%rsp
  80111d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801121:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  801125:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801129:	48 be 29 5f 80 00 00 	movabs $0x805f29,%rsi
  801130:	00 00 00 
  801133:	48 89 c7             	mov    %rax,%rdi
  801136:	48 b8 3f 21 80 00 00 	movabs $0x80213f,%rax
  80113d:	00 00 00 
  801140:	ff d0                	callq  *%rax
	return 0;
  801142:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801147:	c9                   	leaveq 
  801148:	c3                   	retq   

0000000000801149 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  801149:	55                   	push   %rbp
  80114a:	48 89 e5             	mov    %rsp,%rbp
  80114d:	48 83 ec 10          	sub    $0x10,%rsp
  801151:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801154:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  801158:	48 b8 f2 29 80 00 00 	movabs $0x8029f2,%rax
  80115f:	00 00 00 
  801162:	ff d0                	callq  *%rax
  801164:	25 ff 03 00 00       	and    $0x3ff,%eax
  801169:	48 63 d0             	movslq %eax,%rdx
  80116c:	48 89 d0             	mov    %rdx,%rax
  80116f:	48 c1 e0 03          	shl    $0x3,%rax
  801173:	48 01 d0             	add    %rdx,%rax
  801176:	48 c1 e0 05          	shl    $0x5,%rax
  80117a:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801181:	00 00 00 
  801184:	48 01 c2             	add    %rax,%rdx
  801187:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  80118e:	00 00 00 
  801191:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  801194:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801198:	7e 14                	jle    8011ae <libmain+0x65>
		binaryname = argv[0];
  80119a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80119e:	48 8b 10             	mov    (%rax),%rdx
  8011a1:	48 b8 58 80 80 00 00 	movabs $0x808058,%rax
  8011a8:	00 00 00 
  8011ab:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8011ae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8011b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011b5:	48 89 d6             	mov    %rdx,%rsi
  8011b8:	89 c7                	mov    %eax,%edi
  8011ba:	48 b8 4f 0b 80 00 00 	movabs $0x800b4f,%rax
  8011c1:	00 00 00 
  8011c4:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8011c6:	48 b8 d4 11 80 00 00 	movabs $0x8011d4,%rax
  8011cd:	00 00 00 
  8011d0:	ff d0                	callq  *%rax
}
  8011d2:	c9                   	leaveq 
  8011d3:	c3                   	retq   

00000000008011d4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8011d4:	55                   	push   %rbp
  8011d5:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8011d8:	48 b8 9b 39 80 00 00 	movabs $0x80399b,%rax
  8011df:	00 00 00 
  8011e2:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8011e4:	bf 00 00 00 00       	mov    $0x0,%edi
  8011e9:	48 b8 ae 29 80 00 00 	movabs $0x8029ae,%rax
  8011f0:	00 00 00 
  8011f3:	ff d0                	callq  *%rax

}
  8011f5:	5d                   	pop    %rbp
  8011f6:	c3                   	retq   

00000000008011f7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8011f7:	55                   	push   %rbp
  8011f8:	48 89 e5             	mov    %rsp,%rbp
  8011fb:	53                   	push   %rbx
  8011fc:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801203:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80120a:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  801210:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  801217:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80121e:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801225:	84 c0                	test   %al,%al
  801227:	74 23                	je     80124c <_panic+0x55>
  801229:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  801230:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  801234:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  801238:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80123c:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  801240:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  801244:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  801248:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80124c:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801253:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80125a:	00 00 00 
  80125d:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  801264:	00 00 00 
  801267:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80126b:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  801272:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  801279:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801280:	48 b8 58 80 80 00 00 	movabs $0x808058,%rax
  801287:	00 00 00 
  80128a:	48 8b 18             	mov    (%rax),%rbx
  80128d:	48 b8 f2 29 80 00 00 	movabs $0x8029f2,%rax
  801294:	00 00 00 
  801297:	ff d0                	callq  *%rax
  801299:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80129f:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8012a6:	41 89 c8             	mov    %ecx,%r8d
  8012a9:	48 89 d1             	mov    %rdx,%rcx
  8012ac:	48 89 da             	mov    %rbx,%rdx
  8012af:	89 c6                	mov    %eax,%esi
  8012b1:	48 bf 40 5f 80 00 00 	movabs $0x805f40,%rdi
  8012b8:	00 00 00 
  8012bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8012c0:	49 b9 30 14 80 00 00 	movabs $0x801430,%r9
  8012c7:	00 00 00 
  8012ca:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8012cd:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8012d4:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8012db:	48 89 d6             	mov    %rdx,%rsi
  8012de:	48 89 c7             	mov    %rax,%rdi
  8012e1:	48 b8 84 13 80 00 00 	movabs $0x801384,%rax
  8012e8:	00 00 00 
  8012eb:	ff d0                	callq  *%rax
	cprintf("\n");
  8012ed:	48 bf 63 5f 80 00 00 	movabs $0x805f63,%rdi
  8012f4:	00 00 00 
  8012f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8012fc:	48 ba 30 14 80 00 00 	movabs $0x801430,%rdx
  801303:	00 00 00 
  801306:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801308:	cc                   	int3   
  801309:	eb fd                	jmp    801308 <_panic+0x111>

000000000080130b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80130b:	55                   	push   %rbp
  80130c:	48 89 e5             	mov    %rsp,%rbp
  80130f:	48 83 ec 10          	sub    $0x10,%rsp
  801313:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801316:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  80131a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80131e:	8b 00                	mov    (%rax),%eax
  801320:	8d 48 01             	lea    0x1(%rax),%ecx
  801323:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801327:	89 0a                	mov    %ecx,(%rdx)
  801329:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80132c:	89 d1                	mov    %edx,%ecx
  80132e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801332:	48 98                	cltq   
  801334:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  801338:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80133c:	8b 00                	mov    (%rax),%eax
  80133e:	3d ff 00 00 00       	cmp    $0xff,%eax
  801343:	75 2c                	jne    801371 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  801345:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801349:	8b 00                	mov    (%rax),%eax
  80134b:	48 98                	cltq   
  80134d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801351:	48 83 c2 08          	add    $0x8,%rdx
  801355:	48 89 c6             	mov    %rax,%rsi
  801358:	48 89 d7             	mov    %rdx,%rdi
  80135b:	48 b8 26 29 80 00 00 	movabs $0x802926,%rax
  801362:	00 00 00 
  801365:	ff d0                	callq  *%rax
		b->idx = 0;
  801367:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80136b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  801371:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801375:	8b 40 04             	mov    0x4(%rax),%eax
  801378:	8d 50 01             	lea    0x1(%rax),%edx
  80137b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80137f:	89 50 04             	mov    %edx,0x4(%rax)
}
  801382:	c9                   	leaveq 
  801383:	c3                   	retq   

0000000000801384 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801384:	55                   	push   %rbp
  801385:	48 89 e5             	mov    %rsp,%rbp
  801388:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80138f:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  801396:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  80139d:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8013a4:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8013ab:	48 8b 0a             	mov    (%rdx),%rcx
  8013ae:	48 89 08             	mov    %rcx,(%rax)
  8013b1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8013b5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8013b9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8013bd:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8013c1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8013c8:	00 00 00 
	b.cnt = 0;
  8013cb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8013d2:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8013d5:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8013dc:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8013e3:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8013ea:	48 89 c6             	mov    %rax,%rsi
  8013ed:	48 bf 0b 13 80 00 00 	movabs $0x80130b,%rdi
  8013f4:	00 00 00 
  8013f7:	48 b8 e3 17 80 00 00 	movabs $0x8017e3,%rax
  8013fe:	00 00 00 
  801401:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  801403:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  801409:	48 98                	cltq   
  80140b:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  801412:	48 83 c2 08          	add    $0x8,%rdx
  801416:	48 89 c6             	mov    %rax,%rsi
  801419:	48 89 d7             	mov    %rdx,%rdi
  80141c:	48 b8 26 29 80 00 00 	movabs $0x802926,%rax
  801423:	00 00 00 
  801426:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  801428:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80142e:	c9                   	leaveq 
  80142f:	c3                   	retq   

0000000000801430 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801430:	55                   	push   %rbp
  801431:	48 89 e5             	mov    %rsp,%rbp
  801434:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80143b:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  801442:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  801449:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801450:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801457:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80145e:	84 c0                	test   %al,%al
  801460:	74 20                	je     801482 <cprintf+0x52>
  801462:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801466:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80146a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80146e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801472:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801476:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80147a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80147e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801482:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  801489:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  801490:	00 00 00 
  801493:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80149a:	00 00 00 
  80149d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8014a1:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8014a8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8014af:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8014b6:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8014bd:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8014c4:	48 8b 0a             	mov    (%rdx),%rcx
  8014c7:	48 89 08             	mov    %rcx,(%rax)
  8014ca:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8014ce:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8014d2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8014d6:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8014da:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8014e1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8014e8:	48 89 d6             	mov    %rdx,%rsi
  8014eb:	48 89 c7             	mov    %rax,%rdi
  8014ee:	48 b8 84 13 80 00 00 	movabs $0x801384,%rax
  8014f5:	00 00 00 
  8014f8:	ff d0                	callq  *%rax
  8014fa:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  801500:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801506:	c9                   	leaveq 
  801507:	c3                   	retq   

0000000000801508 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801508:	55                   	push   %rbp
  801509:	48 89 e5             	mov    %rsp,%rbp
  80150c:	53                   	push   %rbx
  80150d:	48 83 ec 38          	sub    $0x38,%rsp
  801511:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801515:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801519:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80151d:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  801520:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  801524:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801528:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80152b:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80152f:	77 3b                	ja     80156c <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801531:	8b 45 d0             	mov    -0x30(%rbp),%eax
  801534:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  801538:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80153b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80153f:	ba 00 00 00 00       	mov    $0x0,%edx
  801544:	48 f7 f3             	div    %rbx
  801547:	48 89 c2             	mov    %rax,%rdx
  80154a:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80154d:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  801550:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  801554:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801558:	41 89 f9             	mov    %edi,%r9d
  80155b:	48 89 c7             	mov    %rax,%rdi
  80155e:	48 b8 08 15 80 00 00 	movabs $0x801508,%rax
  801565:	00 00 00 
  801568:	ff d0                	callq  *%rax
  80156a:	eb 1e                	jmp    80158a <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80156c:	eb 12                	jmp    801580 <printnum+0x78>
			putch(padc, putdat);
  80156e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  801572:	8b 55 cc             	mov    -0x34(%rbp),%edx
  801575:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801579:	48 89 ce             	mov    %rcx,%rsi
  80157c:	89 d7                	mov    %edx,%edi
  80157e:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801580:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  801584:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  801588:	7f e4                	jg     80156e <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80158a:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80158d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801591:	ba 00 00 00 00       	mov    $0x0,%edx
  801596:	48 f7 f1             	div    %rcx
  801599:	48 89 d0             	mov    %rdx,%rax
  80159c:	48 ba 48 61 80 00 00 	movabs $0x806148,%rdx
  8015a3:	00 00 00 
  8015a6:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8015aa:	0f be d0             	movsbl %al,%edx
  8015ad:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8015b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015b5:	48 89 ce             	mov    %rcx,%rsi
  8015b8:	89 d7                	mov    %edx,%edi
  8015ba:	ff d0                	callq  *%rax
}
  8015bc:	48 83 c4 38          	add    $0x38,%rsp
  8015c0:	5b                   	pop    %rbx
  8015c1:	5d                   	pop    %rbp
  8015c2:	c3                   	retq   

00000000008015c3 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8015c3:	55                   	push   %rbp
  8015c4:	48 89 e5             	mov    %rsp,%rbp
  8015c7:	48 83 ec 1c          	sub    $0x1c,%rsp
  8015cb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015cf:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8015d2:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8015d6:	7e 52                	jle    80162a <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8015d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015dc:	8b 00                	mov    (%rax),%eax
  8015de:	83 f8 30             	cmp    $0x30,%eax
  8015e1:	73 24                	jae    801607 <getuint+0x44>
  8015e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015e7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8015eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015ef:	8b 00                	mov    (%rax),%eax
  8015f1:	89 c0                	mov    %eax,%eax
  8015f3:	48 01 d0             	add    %rdx,%rax
  8015f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015fa:	8b 12                	mov    (%rdx),%edx
  8015fc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8015ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801603:	89 0a                	mov    %ecx,(%rdx)
  801605:	eb 17                	jmp    80161e <getuint+0x5b>
  801607:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80160b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80160f:	48 89 d0             	mov    %rdx,%rax
  801612:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801616:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80161a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80161e:	48 8b 00             	mov    (%rax),%rax
  801621:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801625:	e9 a3 00 00 00       	jmpq   8016cd <getuint+0x10a>
	else if (lflag)
  80162a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80162e:	74 4f                	je     80167f <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  801630:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801634:	8b 00                	mov    (%rax),%eax
  801636:	83 f8 30             	cmp    $0x30,%eax
  801639:	73 24                	jae    80165f <getuint+0x9c>
  80163b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80163f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801643:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801647:	8b 00                	mov    (%rax),%eax
  801649:	89 c0                	mov    %eax,%eax
  80164b:	48 01 d0             	add    %rdx,%rax
  80164e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801652:	8b 12                	mov    (%rdx),%edx
  801654:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801657:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80165b:	89 0a                	mov    %ecx,(%rdx)
  80165d:	eb 17                	jmp    801676 <getuint+0xb3>
  80165f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801663:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801667:	48 89 d0             	mov    %rdx,%rax
  80166a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80166e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801672:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801676:	48 8b 00             	mov    (%rax),%rax
  801679:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80167d:	eb 4e                	jmp    8016cd <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80167f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801683:	8b 00                	mov    (%rax),%eax
  801685:	83 f8 30             	cmp    $0x30,%eax
  801688:	73 24                	jae    8016ae <getuint+0xeb>
  80168a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80168e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801692:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801696:	8b 00                	mov    (%rax),%eax
  801698:	89 c0                	mov    %eax,%eax
  80169a:	48 01 d0             	add    %rdx,%rax
  80169d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016a1:	8b 12                	mov    (%rdx),%edx
  8016a3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8016a6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016aa:	89 0a                	mov    %ecx,(%rdx)
  8016ac:	eb 17                	jmp    8016c5 <getuint+0x102>
  8016ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016b2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8016b6:	48 89 d0             	mov    %rdx,%rax
  8016b9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8016bd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016c1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8016c5:	8b 00                	mov    (%rax),%eax
  8016c7:	89 c0                	mov    %eax,%eax
  8016c9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8016cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8016d1:	c9                   	leaveq 
  8016d2:	c3                   	retq   

00000000008016d3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8016d3:	55                   	push   %rbp
  8016d4:	48 89 e5             	mov    %rsp,%rbp
  8016d7:	48 83 ec 1c          	sub    $0x1c,%rsp
  8016db:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016df:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8016e2:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8016e6:	7e 52                	jle    80173a <getint+0x67>
		x=va_arg(*ap, long long);
  8016e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016ec:	8b 00                	mov    (%rax),%eax
  8016ee:	83 f8 30             	cmp    $0x30,%eax
  8016f1:	73 24                	jae    801717 <getint+0x44>
  8016f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016f7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8016fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016ff:	8b 00                	mov    (%rax),%eax
  801701:	89 c0                	mov    %eax,%eax
  801703:	48 01 d0             	add    %rdx,%rax
  801706:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80170a:	8b 12                	mov    (%rdx),%edx
  80170c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80170f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801713:	89 0a                	mov    %ecx,(%rdx)
  801715:	eb 17                	jmp    80172e <getint+0x5b>
  801717:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80171b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80171f:	48 89 d0             	mov    %rdx,%rax
  801722:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801726:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80172a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80172e:	48 8b 00             	mov    (%rax),%rax
  801731:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801735:	e9 a3 00 00 00       	jmpq   8017dd <getint+0x10a>
	else if (lflag)
  80173a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80173e:	74 4f                	je     80178f <getint+0xbc>
		x=va_arg(*ap, long);
  801740:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801744:	8b 00                	mov    (%rax),%eax
  801746:	83 f8 30             	cmp    $0x30,%eax
  801749:	73 24                	jae    80176f <getint+0x9c>
  80174b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80174f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801753:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801757:	8b 00                	mov    (%rax),%eax
  801759:	89 c0                	mov    %eax,%eax
  80175b:	48 01 d0             	add    %rdx,%rax
  80175e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801762:	8b 12                	mov    (%rdx),%edx
  801764:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801767:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80176b:	89 0a                	mov    %ecx,(%rdx)
  80176d:	eb 17                	jmp    801786 <getint+0xb3>
  80176f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801773:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801777:	48 89 d0             	mov    %rdx,%rax
  80177a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80177e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801782:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801786:	48 8b 00             	mov    (%rax),%rax
  801789:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80178d:	eb 4e                	jmp    8017dd <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80178f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801793:	8b 00                	mov    (%rax),%eax
  801795:	83 f8 30             	cmp    $0x30,%eax
  801798:	73 24                	jae    8017be <getint+0xeb>
  80179a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80179e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8017a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017a6:	8b 00                	mov    (%rax),%eax
  8017a8:	89 c0                	mov    %eax,%eax
  8017aa:	48 01 d0             	add    %rdx,%rax
  8017ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017b1:	8b 12                	mov    (%rdx),%edx
  8017b3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8017b6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017ba:	89 0a                	mov    %ecx,(%rdx)
  8017bc:	eb 17                	jmp    8017d5 <getint+0x102>
  8017be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017c2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8017c6:	48 89 d0             	mov    %rdx,%rax
  8017c9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8017cd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017d1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8017d5:	8b 00                	mov    (%rax),%eax
  8017d7:	48 98                	cltq   
  8017d9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8017dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8017e1:	c9                   	leaveq 
  8017e2:	c3                   	retq   

00000000008017e3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8017e3:	55                   	push   %rbp
  8017e4:	48 89 e5             	mov    %rsp,%rbp
  8017e7:	41 54                	push   %r12
  8017e9:	53                   	push   %rbx
  8017ea:	48 83 ec 60          	sub    $0x60,%rsp
  8017ee:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8017f2:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8017f6:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8017fa:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8017fe:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801802:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  801806:	48 8b 0a             	mov    (%rdx),%rcx
  801809:	48 89 08             	mov    %rcx,(%rax)
  80180c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801810:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801814:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801818:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80181c:	eb 17                	jmp    801835 <vprintfmt+0x52>
			if (ch == '\0')
  80181e:	85 db                	test   %ebx,%ebx
  801820:	0f 84 cc 04 00 00    	je     801cf2 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  801826:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80182a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80182e:	48 89 d6             	mov    %rdx,%rsi
  801831:	89 df                	mov    %ebx,%edi
  801833:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801835:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801839:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80183d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801841:	0f b6 00             	movzbl (%rax),%eax
  801844:	0f b6 d8             	movzbl %al,%ebx
  801847:	83 fb 25             	cmp    $0x25,%ebx
  80184a:	75 d2                	jne    80181e <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80184c:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  801850:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  801857:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80185e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  801865:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80186c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801870:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801874:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801878:	0f b6 00             	movzbl (%rax),%eax
  80187b:	0f b6 d8             	movzbl %al,%ebx
  80187e:	8d 43 dd             	lea    -0x23(%rbx),%eax
  801881:	83 f8 55             	cmp    $0x55,%eax
  801884:	0f 87 34 04 00 00    	ja     801cbe <vprintfmt+0x4db>
  80188a:	89 c0                	mov    %eax,%eax
  80188c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801893:	00 
  801894:	48 b8 70 61 80 00 00 	movabs $0x806170,%rax
  80189b:	00 00 00 
  80189e:	48 01 d0             	add    %rdx,%rax
  8018a1:	48 8b 00             	mov    (%rax),%rax
  8018a4:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  8018a6:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8018aa:	eb c0                	jmp    80186c <vprintfmt+0x89>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8018ac:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8018b0:	eb ba                	jmp    80186c <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8018b2:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8018b9:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8018bc:	89 d0                	mov    %edx,%eax
  8018be:	c1 e0 02             	shl    $0x2,%eax
  8018c1:	01 d0                	add    %edx,%eax
  8018c3:	01 c0                	add    %eax,%eax
  8018c5:	01 d8                	add    %ebx,%eax
  8018c7:	83 e8 30             	sub    $0x30,%eax
  8018ca:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8018cd:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8018d1:	0f b6 00             	movzbl (%rax),%eax
  8018d4:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8018d7:	83 fb 2f             	cmp    $0x2f,%ebx
  8018da:	7e 0c                	jle    8018e8 <vprintfmt+0x105>
  8018dc:	83 fb 39             	cmp    $0x39,%ebx
  8018df:	7f 07                	jg     8018e8 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8018e1:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8018e6:	eb d1                	jmp    8018b9 <vprintfmt+0xd6>
			goto process_precision;
  8018e8:	eb 58                	jmp    801942 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8018ea:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8018ed:	83 f8 30             	cmp    $0x30,%eax
  8018f0:	73 17                	jae    801909 <vprintfmt+0x126>
  8018f2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8018f6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8018f9:	89 c0                	mov    %eax,%eax
  8018fb:	48 01 d0             	add    %rdx,%rax
  8018fe:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801901:	83 c2 08             	add    $0x8,%edx
  801904:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801907:	eb 0f                	jmp    801918 <vprintfmt+0x135>
  801909:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80190d:	48 89 d0             	mov    %rdx,%rax
  801910:	48 83 c2 08          	add    $0x8,%rdx
  801914:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801918:	8b 00                	mov    (%rax),%eax
  80191a:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80191d:	eb 23                	jmp    801942 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80191f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801923:	79 0c                	jns    801931 <vprintfmt+0x14e>
				width = 0;
  801925:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80192c:	e9 3b ff ff ff       	jmpq   80186c <vprintfmt+0x89>
  801931:	e9 36 ff ff ff       	jmpq   80186c <vprintfmt+0x89>

		case '#':
			altflag = 1;
  801936:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80193d:	e9 2a ff ff ff       	jmpq   80186c <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  801942:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801946:	79 12                	jns    80195a <vprintfmt+0x177>
				width = precision, precision = -1;
  801948:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80194b:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80194e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  801955:	e9 12 ff ff ff       	jmpq   80186c <vprintfmt+0x89>
  80195a:	e9 0d ff ff ff       	jmpq   80186c <vprintfmt+0x89>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80195f:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  801963:	e9 04 ff ff ff       	jmpq   80186c <vprintfmt+0x89>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  801968:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80196b:	83 f8 30             	cmp    $0x30,%eax
  80196e:	73 17                	jae    801987 <vprintfmt+0x1a4>
  801970:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801974:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801977:	89 c0                	mov    %eax,%eax
  801979:	48 01 d0             	add    %rdx,%rax
  80197c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80197f:	83 c2 08             	add    $0x8,%edx
  801982:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801985:	eb 0f                	jmp    801996 <vprintfmt+0x1b3>
  801987:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80198b:	48 89 d0             	mov    %rdx,%rax
  80198e:	48 83 c2 08          	add    $0x8,%rdx
  801992:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801996:	8b 10                	mov    (%rax),%edx
  801998:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80199c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8019a0:	48 89 ce             	mov    %rcx,%rsi
  8019a3:	89 d7                	mov    %edx,%edi
  8019a5:	ff d0                	callq  *%rax
			break;
  8019a7:	e9 40 03 00 00       	jmpq   801cec <vprintfmt+0x509>

		// error message
		case 'e':
			err = va_arg(aq, int);
  8019ac:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8019af:	83 f8 30             	cmp    $0x30,%eax
  8019b2:	73 17                	jae    8019cb <vprintfmt+0x1e8>
  8019b4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8019b8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8019bb:	89 c0                	mov    %eax,%eax
  8019bd:	48 01 d0             	add    %rdx,%rax
  8019c0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8019c3:	83 c2 08             	add    $0x8,%edx
  8019c6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8019c9:	eb 0f                	jmp    8019da <vprintfmt+0x1f7>
  8019cb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8019cf:	48 89 d0             	mov    %rdx,%rax
  8019d2:	48 83 c2 08          	add    $0x8,%rdx
  8019d6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8019da:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8019dc:	85 db                	test   %ebx,%ebx
  8019de:	79 02                	jns    8019e2 <vprintfmt+0x1ff>
				err = -err;
  8019e0:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8019e2:	83 fb 10             	cmp    $0x10,%ebx
  8019e5:	7f 16                	jg     8019fd <vprintfmt+0x21a>
  8019e7:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  8019ee:	00 00 00 
  8019f1:	48 63 d3             	movslq %ebx,%rdx
  8019f4:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8019f8:	4d 85 e4             	test   %r12,%r12
  8019fb:	75 2e                	jne    801a2b <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8019fd:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801a01:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801a05:	89 d9                	mov    %ebx,%ecx
  801a07:	48 ba 59 61 80 00 00 	movabs $0x806159,%rdx
  801a0e:	00 00 00 
  801a11:	48 89 c7             	mov    %rax,%rdi
  801a14:	b8 00 00 00 00       	mov    $0x0,%eax
  801a19:	49 b8 fb 1c 80 00 00 	movabs $0x801cfb,%r8
  801a20:	00 00 00 
  801a23:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801a26:	e9 c1 02 00 00       	jmpq   801cec <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801a2b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801a2f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801a33:	4c 89 e1             	mov    %r12,%rcx
  801a36:	48 ba 62 61 80 00 00 	movabs $0x806162,%rdx
  801a3d:	00 00 00 
  801a40:	48 89 c7             	mov    %rax,%rdi
  801a43:	b8 00 00 00 00       	mov    $0x0,%eax
  801a48:	49 b8 fb 1c 80 00 00 	movabs $0x801cfb,%r8
  801a4f:	00 00 00 
  801a52:	41 ff d0             	callq  *%r8
			break;
  801a55:	e9 92 02 00 00       	jmpq   801cec <vprintfmt+0x509>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  801a5a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801a5d:	83 f8 30             	cmp    $0x30,%eax
  801a60:	73 17                	jae    801a79 <vprintfmt+0x296>
  801a62:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801a66:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801a69:	89 c0                	mov    %eax,%eax
  801a6b:	48 01 d0             	add    %rdx,%rax
  801a6e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801a71:	83 c2 08             	add    $0x8,%edx
  801a74:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801a77:	eb 0f                	jmp    801a88 <vprintfmt+0x2a5>
  801a79:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801a7d:	48 89 d0             	mov    %rdx,%rax
  801a80:	48 83 c2 08          	add    $0x8,%rdx
  801a84:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801a88:	4c 8b 20             	mov    (%rax),%r12
  801a8b:	4d 85 e4             	test   %r12,%r12
  801a8e:	75 0a                	jne    801a9a <vprintfmt+0x2b7>
				p = "(null)";
  801a90:	49 bc 65 61 80 00 00 	movabs $0x806165,%r12
  801a97:	00 00 00 
			if (width > 0 && padc != '-')
  801a9a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801a9e:	7e 3f                	jle    801adf <vprintfmt+0x2fc>
  801aa0:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  801aa4:	74 39                	je     801adf <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  801aa6:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801aa9:	48 98                	cltq   
  801aab:	48 89 c6             	mov    %rax,%rsi
  801aae:	4c 89 e7             	mov    %r12,%rdi
  801ab1:	48 b8 01 21 80 00 00 	movabs $0x802101,%rax
  801ab8:	00 00 00 
  801abb:	ff d0                	callq  *%rax
  801abd:	29 45 dc             	sub    %eax,-0x24(%rbp)
  801ac0:	eb 17                	jmp    801ad9 <vprintfmt+0x2f6>
					putch(padc, putdat);
  801ac2:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  801ac6:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  801aca:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801ace:	48 89 ce             	mov    %rcx,%rsi
  801ad1:	89 d7                	mov    %edx,%edi
  801ad3:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801ad5:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801ad9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801add:	7f e3                	jg     801ac2 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801adf:	eb 37                	jmp    801b18 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  801ae1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  801ae5:	74 1e                	je     801b05 <vprintfmt+0x322>
  801ae7:	83 fb 1f             	cmp    $0x1f,%ebx
  801aea:	7e 05                	jle    801af1 <vprintfmt+0x30e>
  801aec:	83 fb 7e             	cmp    $0x7e,%ebx
  801aef:	7e 14                	jle    801b05 <vprintfmt+0x322>
					putch('?', putdat);
  801af1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801af5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801af9:	48 89 d6             	mov    %rdx,%rsi
  801afc:	bf 3f 00 00 00       	mov    $0x3f,%edi
  801b01:	ff d0                	callq  *%rax
  801b03:	eb 0f                	jmp    801b14 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  801b05:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801b09:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801b0d:	48 89 d6             	mov    %rdx,%rsi
  801b10:	89 df                	mov    %ebx,%edi
  801b12:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801b14:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801b18:	4c 89 e0             	mov    %r12,%rax
  801b1b:	4c 8d 60 01          	lea    0x1(%rax),%r12
  801b1f:	0f b6 00             	movzbl (%rax),%eax
  801b22:	0f be d8             	movsbl %al,%ebx
  801b25:	85 db                	test   %ebx,%ebx
  801b27:	74 10                	je     801b39 <vprintfmt+0x356>
  801b29:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801b2d:	78 b2                	js     801ae1 <vprintfmt+0x2fe>
  801b2f:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  801b33:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801b37:	79 a8                	jns    801ae1 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801b39:	eb 16                	jmp    801b51 <vprintfmt+0x36e>
				putch(' ', putdat);
  801b3b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801b3f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801b43:	48 89 d6             	mov    %rdx,%rsi
  801b46:	bf 20 00 00 00       	mov    $0x20,%edi
  801b4b:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801b4d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801b51:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801b55:	7f e4                	jg     801b3b <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  801b57:	e9 90 01 00 00       	jmpq   801cec <vprintfmt+0x509>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801b5c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801b60:	be 03 00 00 00       	mov    $0x3,%esi
  801b65:	48 89 c7             	mov    %rax,%rdi
  801b68:	48 b8 d3 16 80 00 00 	movabs $0x8016d3,%rax
  801b6f:	00 00 00 
  801b72:	ff d0                	callq  *%rax
  801b74:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  801b78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b7c:	48 85 c0             	test   %rax,%rax
  801b7f:	79 1d                	jns    801b9e <vprintfmt+0x3bb>
				putch('-', putdat);
  801b81:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801b85:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801b89:	48 89 d6             	mov    %rdx,%rsi
  801b8c:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801b91:	ff d0                	callq  *%rax
				num = -(long long) num;
  801b93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b97:	48 f7 d8             	neg    %rax
  801b9a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  801b9e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801ba5:	e9 d5 00 00 00       	jmpq   801c7f <vprintfmt+0x49c>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  801baa:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801bae:	be 03 00 00 00       	mov    $0x3,%esi
  801bb3:	48 89 c7             	mov    %rax,%rdi
  801bb6:	48 b8 c3 15 80 00 00 	movabs $0x8015c3,%rax
  801bbd:	00 00 00 
  801bc0:	ff d0                	callq  *%rax
  801bc2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  801bc6:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801bcd:	e9 ad 00 00 00       	jmpq   801c7f <vprintfmt+0x49c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  801bd2:	8b 55 e0             	mov    -0x20(%rbp),%edx
  801bd5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801bd9:	89 d6                	mov    %edx,%esi
  801bdb:	48 89 c7             	mov    %rax,%rdi
  801bde:	48 b8 d3 16 80 00 00 	movabs $0x8016d3,%rax
  801be5:	00 00 00 
  801be8:	ff d0                	callq  *%rax
  801bea:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  801bee:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  801bf5:	e9 85 00 00 00       	jmpq   801c7f <vprintfmt+0x49c>


		// pointer
		case 'p':
			putch('0', putdat);
  801bfa:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801bfe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801c02:	48 89 d6             	mov    %rdx,%rsi
  801c05:	bf 30 00 00 00       	mov    $0x30,%edi
  801c0a:	ff d0                	callq  *%rax
			putch('x', putdat);
  801c0c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801c10:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801c14:	48 89 d6             	mov    %rdx,%rsi
  801c17:	bf 78 00 00 00       	mov    $0x78,%edi
  801c1c:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801c1e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801c21:	83 f8 30             	cmp    $0x30,%eax
  801c24:	73 17                	jae    801c3d <vprintfmt+0x45a>
  801c26:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801c2a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801c2d:	89 c0                	mov    %eax,%eax
  801c2f:	48 01 d0             	add    %rdx,%rax
  801c32:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801c35:	83 c2 08             	add    $0x8,%edx
  801c38:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801c3b:	eb 0f                	jmp    801c4c <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  801c3d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801c41:	48 89 d0             	mov    %rdx,%rax
  801c44:	48 83 c2 08          	add    $0x8,%rdx
  801c48:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801c4c:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801c4f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801c53:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801c5a:	eb 23                	jmp    801c7f <vprintfmt+0x49c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801c5c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801c60:	be 03 00 00 00       	mov    $0x3,%esi
  801c65:	48 89 c7             	mov    %rax,%rdi
  801c68:	48 b8 c3 15 80 00 00 	movabs $0x8015c3,%rax
  801c6f:	00 00 00 
  801c72:	ff d0                	callq  *%rax
  801c74:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801c78:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801c7f:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  801c84:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801c87:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801c8a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801c8e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801c92:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801c96:	45 89 c1             	mov    %r8d,%r9d
  801c99:	41 89 f8             	mov    %edi,%r8d
  801c9c:	48 89 c7             	mov    %rax,%rdi
  801c9f:	48 b8 08 15 80 00 00 	movabs $0x801508,%rax
  801ca6:	00 00 00 
  801ca9:	ff d0                	callq  *%rax
			break;
  801cab:	eb 3f                	jmp    801cec <vprintfmt+0x509>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801cad:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801cb1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801cb5:	48 89 d6             	mov    %rdx,%rsi
  801cb8:	89 df                	mov    %ebx,%edi
  801cba:	ff d0                	callq  *%rax
			break;
  801cbc:	eb 2e                	jmp    801cec <vprintfmt+0x509>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801cbe:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801cc2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801cc6:	48 89 d6             	mov    %rdx,%rsi
  801cc9:	bf 25 00 00 00       	mov    $0x25,%edi
  801cce:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  801cd0:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801cd5:	eb 05                	jmp    801cdc <vprintfmt+0x4f9>
  801cd7:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801cdc:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801ce0:	48 83 e8 01          	sub    $0x1,%rax
  801ce4:	0f b6 00             	movzbl (%rax),%eax
  801ce7:	3c 25                	cmp    $0x25,%al
  801ce9:	75 ec                	jne    801cd7 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  801ceb:	90                   	nop
		}
	}
  801cec:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801ced:	e9 43 fb ff ff       	jmpq   801835 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  801cf2:	48 83 c4 60          	add    $0x60,%rsp
  801cf6:	5b                   	pop    %rbx
  801cf7:	41 5c                	pop    %r12
  801cf9:	5d                   	pop    %rbp
  801cfa:	c3                   	retq   

0000000000801cfb <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801cfb:	55                   	push   %rbp
  801cfc:	48 89 e5             	mov    %rsp,%rbp
  801cff:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801d06:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801d0d:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801d14:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801d1b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801d22:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801d29:	84 c0                	test   %al,%al
  801d2b:	74 20                	je     801d4d <printfmt+0x52>
  801d2d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801d31:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801d35:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801d39:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801d3d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801d41:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801d45:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801d49:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801d4d:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801d54:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801d5b:	00 00 00 
  801d5e:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801d65:	00 00 00 
  801d68:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801d6c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801d73:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801d7a:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801d81:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801d88:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801d8f:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801d96:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801d9d:	48 89 c7             	mov    %rax,%rdi
  801da0:	48 b8 e3 17 80 00 00 	movabs $0x8017e3,%rax
  801da7:	00 00 00 
  801daa:	ff d0                	callq  *%rax
	va_end(ap);
}
  801dac:	c9                   	leaveq 
  801dad:	c3                   	retq   

0000000000801dae <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801dae:	55                   	push   %rbp
  801daf:	48 89 e5             	mov    %rsp,%rbp
  801db2:	48 83 ec 10          	sub    $0x10,%rsp
  801db6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801db9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801dbd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dc1:	8b 40 10             	mov    0x10(%rax),%eax
  801dc4:	8d 50 01             	lea    0x1(%rax),%edx
  801dc7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dcb:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801dce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dd2:	48 8b 10             	mov    (%rax),%rdx
  801dd5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dd9:	48 8b 40 08          	mov    0x8(%rax),%rax
  801ddd:	48 39 c2             	cmp    %rax,%rdx
  801de0:	73 17                	jae    801df9 <sprintputch+0x4b>
		*b->buf++ = ch;
  801de2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801de6:	48 8b 00             	mov    (%rax),%rax
  801de9:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801ded:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801df1:	48 89 0a             	mov    %rcx,(%rdx)
  801df4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801df7:	88 10                	mov    %dl,(%rax)
}
  801df9:	c9                   	leaveq 
  801dfa:	c3                   	retq   

0000000000801dfb <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801dfb:	55                   	push   %rbp
  801dfc:	48 89 e5             	mov    %rsp,%rbp
  801dff:	48 83 ec 50          	sub    $0x50,%rsp
  801e03:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801e07:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801e0a:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801e0e:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801e12:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801e16:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801e1a:	48 8b 0a             	mov    (%rdx),%rcx
  801e1d:	48 89 08             	mov    %rcx,(%rax)
  801e20:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801e24:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801e28:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801e2c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801e30:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801e34:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801e38:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801e3b:	48 98                	cltq   
  801e3d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801e41:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801e45:	48 01 d0             	add    %rdx,%rax
  801e48:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801e4c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801e53:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801e58:	74 06                	je     801e60 <vsnprintf+0x65>
  801e5a:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801e5e:	7f 07                	jg     801e67 <vsnprintf+0x6c>
		return -E_INVAL;
  801e60:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e65:	eb 2f                	jmp    801e96 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801e67:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801e6b:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801e6f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801e73:	48 89 c6             	mov    %rax,%rsi
  801e76:	48 bf ae 1d 80 00 00 	movabs $0x801dae,%rdi
  801e7d:	00 00 00 
  801e80:	48 b8 e3 17 80 00 00 	movabs $0x8017e3,%rax
  801e87:	00 00 00 
  801e8a:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801e8c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801e90:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801e93:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801e96:	c9                   	leaveq 
  801e97:	c3                   	retq   

0000000000801e98 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801e98:	55                   	push   %rbp
  801e99:	48 89 e5             	mov    %rsp,%rbp
  801e9c:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801ea3:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801eaa:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801eb0:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801eb7:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801ebe:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801ec5:	84 c0                	test   %al,%al
  801ec7:	74 20                	je     801ee9 <snprintf+0x51>
  801ec9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801ecd:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801ed1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801ed5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801ed9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801edd:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801ee1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801ee5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801ee9:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801ef0:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801ef7:	00 00 00 
  801efa:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801f01:	00 00 00 
  801f04:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801f08:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801f0f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801f16:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801f1d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801f24:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801f2b:	48 8b 0a             	mov    (%rdx),%rcx
  801f2e:	48 89 08             	mov    %rcx,(%rax)
  801f31:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801f35:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801f39:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801f3d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801f41:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801f48:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801f4f:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801f55:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801f5c:	48 89 c7             	mov    %rax,%rdi
  801f5f:	48 b8 fb 1d 80 00 00 	movabs $0x801dfb,%rax
  801f66:	00 00 00 
  801f69:	ff d0                	callq  *%rax
  801f6b:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801f71:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801f77:	c9                   	leaveq 
  801f78:	c3                   	retq   

0000000000801f79 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  801f79:	55                   	push   %rbp
  801f7a:	48 89 e5             	mov    %rsp,%rbp
  801f7d:	48 83 ec 20          	sub    $0x20,%rsp
  801f81:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  801f85:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801f8a:	74 27                	je     801fb3 <readline+0x3a>
		fprintf(1, "%s", prompt);
  801f8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f90:	48 89 c2             	mov    %rax,%rdx
  801f93:	48 be 20 64 80 00 00 	movabs $0x806420,%rsi
  801f9a:	00 00 00 
  801f9d:	bf 01 00 00 00       	mov    $0x1,%edi
  801fa2:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa7:	48 b9 19 46 80 00 00 	movabs $0x804619,%rcx
  801fae:	00 00 00 
  801fb1:	ff d1                	callq  *%rcx
#endif

	i = 0;
  801fb3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	echoing = iscons(0);
  801fba:	bf 00 00 00 00       	mov    $0x0,%edi
  801fbf:	48 b8 0a 0f 80 00 00 	movabs $0x800f0a,%rax
  801fc6:	00 00 00 
  801fc9:	ff d0                	callq  *%rax
  801fcb:	89 45 f8             	mov    %eax,-0x8(%rbp)
	while (1) {
		c = getchar();
  801fce:	48 b8 c1 0e 80 00 00 	movabs $0x800ec1,%rax
  801fd5:	00 00 00 
  801fd8:	ff d0                	callq  *%rax
  801fda:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if (c < 0) {
  801fdd:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801fe1:	79 30                	jns    802013 <readline+0x9a>
			if (c != -E_EOF)
  801fe3:	83 7d f4 f7          	cmpl   $0xfffffff7,-0xc(%rbp)
  801fe7:	74 20                	je     802009 <readline+0x90>
				cprintf("read error: %e\n", c);
  801fe9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801fec:	89 c6                	mov    %eax,%esi
  801fee:	48 bf 23 64 80 00 00 	movabs $0x806423,%rdi
  801ff5:	00 00 00 
  801ff8:	b8 00 00 00 00       	mov    $0x0,%eax
  801ffd:	48 ba 30 14 80 00 00 	movabs $0x801430,%rdx
  802004:	00 00 00 
  802007:	ff d2                	callq  *%rdx
			return NULL;
  802009:	b8 00 00 00 00       	mov    $0x0,%eax
  80200e:	e9 be 00 00 00       	jmpq   8020d1 <readline+0x158>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  802013:	83 7d f4 08          	cmpl   $0x8,-0xc(%rbp)
  802017:	74 06                	je     80201f <readline+0xa6>
  802019:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%rbp)
  80201d:	75 26                	jne    802045 <readline+0xcc>
  80201f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802023:	7e 20                	jle    802045 <readline+0xcc>
			if (echoing)
  802025:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802029:	74 11                	je     80203c <readline+0xc3>
				cputchar('\b');
  80202b:	bf 08 00 00 00       	mov    $0x8,%edi
  802030:	48 b8 96 0e 80 00 00 	movabs $0x800e96,%rax
  802037:	00 00 00 
  80203a:	ff d0                	callq  *%rax
			i--;
  80203c:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
  802040:	e9 87 00 00 00       	jmpq   8020cc <readline+0x153>
		} else if (c >= ' ' && i < BUFLEN-1) {
  802045:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%rbp)
  802049:	7e 3f                	jle    80208a <readline+0x111>
  80204b:	81 7d fc fe 03 00 00 	cmpl   $0x3fe,-0x4(%rbp)
  802052:	7f 36                	jg     80208a <readline+0x111>
			if (echoing)
  802054:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802058:	74 11                	je     80206b <readline+0xf2>
				cputchar(c);
  80205a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80205d:	89 c7                	mov    %eax,%edi
  80205f:	48 b8 96 0e 80 00 00 	movabs $0x800e96,%rax
  802066:	00 00 00 
  802069:	ff d0                	callq  *%rax
			buf[i++] = c;
  80206b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80206e:	8d 50 01             	lea    0x1(%rax),%edx
  802071:	89 55 fc             	mov    %edx,-0x4(%rbp)
  802074:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802077:	89 d1                	mov    %edx,%ecx
  802079:	48 ba 20 90 80 00 00 	movabs $0x809020,%rdx
  802080:	00 00 00 
  802083:	48 98                	cltq   
  802085:	88 0c 02             	mov    %cl,(%rdx,%rax,1)
  802088:	eb 42                	jmp    8020cc <readline+0x153>
		} else if (c == '\n' || c == '\r') {
  80208a:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  80208e:	74 06                	je     802096 <readline+0x11d>
  802090:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  802094:	75 36                	jne    8020cc <readline+0x153>
			if (echoing)
  802096:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80209a:	74 11                	je     8020ad <readline+0x134>
				cputchar('\n');
  80209c:	bf 0a 00 00 00       	mov    $0xa,%edi
  8020a1:	48 b8 96 0e 80 00 00 	movabs $0x800e96,%rax
  8020a8:	00 00 00 
  8020ab:	ff d0                	callq  *%rax
			buf[i] = 0;
  8020ad:	48 ba 20 90 80 00 00 	movabs $0x809020,%rdx
  8020b4:	00 00 00 
  8020b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020ba:	48 98                	cltq   
  8020bc:	c6 04 02 00          	movb   $0x0,(%rdx,%rax,1)
			return buf;
  8020c0:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  8020c7:	00 00 00 
  8020ca:	eb 05                	jmp    8020d1 <readline+0x158>
		}
	}
  8020cc:	e9 fd fe ff ff       	jmpq   801fce <readline+0x55>
}
  8020d1:	c9                   	leaveq 
  8020d2:	c3                   	retq   

00000000008020d3 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8020d3:	55                   	push   %rbp
  8020d4:	48 89 e5             	mov    %rsp,%rbp
  8020d7:	48 83 ec 18          	sub    $0x18,%rsp
  8020db:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8020df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020e6:	eb 09                	jmp    8020f1 <strlen+0x1e>
		n++;
  8020e8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8020ec:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8020f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020f5:	0f b6 00             	movzbl (%rax),%eax
  8020f8:	84 c0                	test   %al,%al
  8020fa:	75 ec                	jne    8020e8 <strlen+0x15>
		n++;
	return n;
  8020fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8020ff:	c9                   	leaveq 
  802100:	c3                   	retq   

0000000000802101 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  802101:	55                   	push   %rbp
  802102:	48 89 e5             	mov    %rsp,%rbp
  802105:	48 83 ec 20          	sub    $0x20,%rsp
  802109:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80210d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802111:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802118:	eb 0e                	jmp    802128 <strnlen+0x27>
		n++;
  80211a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80211e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802123:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  802128:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80212d:	74 0b                	je     80213a <strnlen+0x39>
  80212f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802133:	0f b6 00             	movzbl (%rax),%eax
  802136:	84 c0                	test   %al,%al
  802138:	75 e0                	jne    80211a <strnlen+0x19>
		n++;
	return n;
  80213a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80213d:	c9                   	leaveq 
  80213e:	c3                   	retq   

000000000080213f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80213f:	55                   	push   %rbp
  802140:	48 89 e5             	mov    %rsp,%rbp
  802143:	48 83 ec 20          	sub    $0x20,%rsp
  802147:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80214b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80214f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802153:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  802157:	90                   	nop
  802158:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80215c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802160:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802164:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802168:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80216c:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802170:	0f b6 12             	movzbl (%rdx),%edx
  802173:	88 10                	mov    %dl,(%rax)
  802175:	0f b6 00             	movzbl (%rax),%eax
  802178:	84 c0                	test   %al,%al
  80217a:	75 dc                	jne    802158 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80217c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802180:	c9                   	leaveq 
  802181:	c3                   	retq   

0000000000802182 <strcat>:

char *
strcat(char *dst, const char *src)
{
  802182:	55                   	push   %rbp
  802183:	48 89 e5             	mov    %rsp,%rbp
  802186:	48 83 ec 20          	sub    $0x20,%rsp
  80218a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80218e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  802192:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802196:	48 89 c7             	mov    %rax,%rdi
  802199:	48 b8 d3 20 80 00 00 	movabs $0x8020d3,%rax
  8021a0:	00 00 00 
  8021a3:	ff d0                	callq  *%rax
  8021a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8021a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021ab:	48 63 d0             	movslq %eax,%rdx
  8021ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021b2:	48 01 c2             	add    %rax,%rdx
  8021b5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021b9:	48 89 c6             	mov    %rax,%rsi
  8021bc:	48 89 d7             	mov    %rdx,%rdi
  8021bf:	48 b8 3f 21 80 00 00 	movabs $0x80213f,%rax
  8021c6:	00 00 00 
  8021c9:	ff d0                	callq  *%rax
	return dst;
  8021cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8021cf:	c9                   	leaveq 
  8021d0:	c3                   	retq   

00000000008021d1 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8021d1:	55                   	push   %rbp
  8021d2:	48 89 e5             	mov    %rsp,%rbp
  8021d5:	48 83 ec 28          	sub    $0x28,%rsp
  8021d9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8021dd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8021e1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8021e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021e9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8021ed:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8021f4:	00 
  8021f5:	eb 2a                	jmp    802221 <strncpy+0x50>
		*dst++ = *src;
  8021f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021fb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8021ff:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802203:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802207:	0f b6 12             	movzbl (%rdx),%edx
  80220a:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80220c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802210:	0f b6 00             	movzbl (%rax),%eax
  802213:	84 c0                	test   %al,%al
  802215:	74 05                	je     80221c <strncpy+0x4b>
			src++;
  802217:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80221c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802221:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802225:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802229:	72 cc                	jb     8021f7 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80222b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80222f:	c9                   	leaveq 
  802230:	c3                   	retq   

0000000000802231 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  802231:	55                   	push   %rbp
  802232:	48 89 e5             	mov    %rsp,%rbp
  802235:	48 83 ec 28          	sub    $0x28,%rsp
  802239:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80223d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802241:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  802245:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802249:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80224d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802252:	74 3d                	je     802291 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  802254:	eb 1d                	jmp    802273 <strlcpy+0x42>
			*dst++ = *src++;
  802256:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80225a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80225e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802262:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802266:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80226a:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80226e:	0f b6 12             	movzbl (%rdx),%edx
  802271:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802273:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  802278:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80227d:	74 0b                	je     80228a <strlcpy+0x59>
  80227f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802283:	0f b6 00             	movzbl (%rax),%eax
  802286:	84 c0                	test   %al,%al
  802288:	75 cc                	jne    802256 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80228a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80228e:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  802291:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802295:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802299:	48 29 c2             	sub    %rax,%rdx
  80229c:	48 89 d0             	mov    %rdx,%rax
}
  80229f:	c9                   	leaveq 
  8022a0:	c3                   	retq   

00000000008022a1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8022a1:	55                   	push   %rbp
  8022a2:	48 89 e5             	mov    %rsp,%rbp
  8022a5:	48 83 ec 10          	sub    $0x10,%rsp
  8022a9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8022ad:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8022b1:	eb 0a                	jmp    8022bd <strcmp+0x1c>
		p++, q++;
  8022b3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8022b8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8022bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022c1:	0f b6 00             	movzbl (%rax),%eax
  8022c4:	84 c0                	test   %al,%al
  8022c6:	74 12                	je     8022da <strcmp+0x39>
  8022c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022cc:	0f b6 10             	movzbl (%rax),%edx
  8022cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022d3:	0f b6 00             	movzbl (%rax),%eax
  8022d6:	38 c2                	cmp    %al,%dl
  8022d8:	74 d9                	je     8022b3 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8022da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022de:	0f b6 00             	movzbl (%rax),%eax
  8022e1:	0f b6 d0             	movzbl %al,%edx
  8022e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022e8:	0f b6 00             	movzbl (%rax),%eax
  8022eb:	0f b6 c0             	movzbl %al,%eax
  8022ee:	29 c2                	sub    %eax,%edx
  8022f0:	89 d0                	mov    %edx,%eax
}
  8022f2:	c9                   	leaveq 
  8022f3:	c3                   	retq   

00000000008022f4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8022f4:	55                   	push   %rbp
  8022f5:	48 89 e5             	mov    %rsp,%rbp
  8022f8:	48 83 ec 18          	sub    $0x18,%rsp
  8022fc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802300:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802304:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  802308:	eb 0f                	jmp    802319 <strncmp+0x25>
		n--, p++, q++;
  80230a:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80230f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802314:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  802319:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80231e:	74 1d                	je     80233d <strncmp+0x49>
  802320:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802324:	0f b6 00             	movzbl (%rax),%eax
  802327:	84 c0                	test   %al,%al
  802329:	74 12                	je     80233d <strncmp+0x49>
  80232b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80232f:	0f b6 10             	movzbl (%rax),%edx
  802332:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802336:	0f b6 00             	movzbl (%rax),%eax
  802339:	38 c2                	cmp    %al,%dl
  80233b:	74 cd                	je     80230a <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80233d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802342:	75 07                	jne    80234b <strncmp+0x57>
		return 0;
  802344:	b8 00 00 00 00       	mov    $0x0,%eax
  802349:	eb 18                	jmp    802363 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80234b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80234f:	0f b6 00             	movzbl (%rax),%eax
  802352:	0f b6 d0             	movzbl %al,%edx
  802355:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802359:	0f b6 00             	movzbl (%rax),%eax
  80235c:	0f b6 c0             	movzbl %al,%eax
  80235f:	29 c2                	sub    %eax,%edx
  802361:	89 d0                	mov    %edx,%eax
}
  802363:	c9                   	leaveq 
  802364:	c3                   	retq   

0000000000802365 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802365:	55                   	push   %rbp
  802366:	48 89 e5             	mov    %rsp,%rbp
  802369:	48 83 ec 0c          	sub    $0xc,%rsp
  80236d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802371:	89 f0                	mov    %esi,%eax
  802373:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802376:	eb 17                	jmp    80238f <strchr+0x2a>
		if (*s == c)
  802378:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80237c:	0f b6 00             	movzbl (%rax),%eax
  80237f:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802382:	75 06                	jne    80238a <strchr+0x25>
			return (char *) s;
  802384:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802388:	eb 15                	jmp    80239f <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80238a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80238f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802393:	0f b6 00             	movzbl (%rax),%eax
  802396:	84 c0                	test   %al,%al
  802398:	75 de                	jne    802378 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80239a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80239f:	c9                   	leaveq 
  8023a0:	c3                   	retq   

00000000008023a1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8023a1:	55                   	push   %rbp
  8023a2:	48 89 e5             	mov    %rsp,%rbp
  8023a5:	48 83 ec 0c          	sub    $0xc,%rsp
  8023a9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8023ad:	89 f0                	mov    %esi,%eax
  8023af:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8023b2:	eb 13                	jmp    8023c7 <strfind+0x26>
		if (*s == c)
  8023b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023b8:	0f b6 00             	movzbl (%rax),%eax
  8023bb:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8023be:	75 02                	jne    8023c2 <strfind+0x21>
			break;
  8023c0:	eb 10                	jmp    8023d2 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8023c2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8023c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023cb:	0f b6 00             	movzbl (%rax),%eax
  8023ce:	84 c0                	test   %al,%al
  8023d0:	75 e2                	jne    8023b4 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8023d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8023d6:	c9                   	leaveq 
  8023d7:	c3                   	retq   

00000000008023d8 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8023d8:	55                   	push   %rbp
  8023d9:	48 89 e5             	mov    %rsp,%rbp
  8023dc:	48 83 ec 18          	sub    $0x18,%rsp
  8023e0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8023e4:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8023e7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8023eb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8023f0:	75 06                	jne    8023f8 <memset+0x20>
		return v;
  8023f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023f6:	eb 69                	jmp    802461 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8023f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023fc:	83 e0 03             	and    $0x3,%eax
  8023ff:	48 85 c0             	test   %rax,%rax
  802402:	75 48                	jne    80244c <memset+0x74>
  802404:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802408:	83 e0 03             	and    $0x3,%eax
  80240b:	48 85 c0             	test   %rax,%rax
  80240e:	75 3c                	jne    80244c <memset+0x74>
		c &= 0xFF;
  802410:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802417:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80241a:	c1 e0 18             	shl    $0x18,%eax
  80241d:	89 c2                	mov    %eax,%edx
  80241f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802422:	c1 e0 10             	shl    $0x10,%eax
  802425:	09 c2                	or     %eax,%edx
  802427:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80242a:	c1 e0 08             	shl    $0x8,%eax
  80242d:	09 d0                	or     %edx,%eax
  80242f:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  802432:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802436:	48 c1 e8 02          	shr    $0x2,%rax
  80243a:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80243d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802441:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802444:	48 89 d7             	mov    %rdx,%rdi
  802447:	fc                   	cld    
  802448:	f3 ab                	rep stos %eax,%es:(%rdi)
  80244a:	eb 11                	jmp    80245d <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80244c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802450:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802453:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802457:	48 89 d7             	mov    %rdx,%rdi
  80245a:	fc                   	cld    
  80245b:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  80245d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802461:	c9                   	leaveq 
  802462:	c3                   	retq   

0000000000802463 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802463:	55                   	push   %rbp
  802464:	48 89 e5             	mov    %rsp,%rbp
  802467:	48 83 ec 28          	sub    $0x28,%rsp
  80246b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80246f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802473:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  802477:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80247b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80247f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802483:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  802487:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80248b:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80248f:	0f 83 88 00 00 00    	jae    80251d <memmove+0xba>
  802495:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802499:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80249d:	48 01 d0             	add    %rdx,%rax
  8024a0:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8024a4:	76 77                	jbe    80251d <memmove+0xba>
		s += n;
  8024a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024aa:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8024ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024b2:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8024b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024ba:	83 e0 03             	and    $0x3,%eax
  8024bd:	48 85 c0             	test   %rax,%rax
  8024c0:	75 3b                	jne    8024fd <memmove+0x9a>
  8024c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024c6:	83 e0 03             	and    $0x3,%eax
  8024c9:	48 85 c0             	test   %rax,%rax
  8024cc:	75 2f                	jne    8024fd <memmove+0x9a>
  8024ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024d2:	83 e0 03             	and    $0x3,%eax
  8024d5:	48 85 c0             	test   %rax,%rax
  8024d8:	75 23                	jne    8024fd <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8024da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024de:	48 83 e8 04          	sub    $0x4,%rax
  8024e2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8024e6:	48 83 ea 04          	sub    $0x4,%rdx
  8024ea:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8024ee:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8024f2:	48 89 c7             	mov    %rax,%rdi
  8024f5:	48 89 d6             	mov    %rdx,%rsi
  8024f8:	fd                   	std    
  8024f9:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8024fb:	eb 1d                	jmp    80251a <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8024fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802501:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802505:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802509:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80250d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802511:	48 89 d7             	mov    %rdx,%rdi
  802514:	48 89 c1             	mov    %rax,%rcx
  802517:	fd                   	std    
  802518:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80251a:	fc                   	cld    
  80251b:	eb 57                	jmp    802574 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80251d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802521:	83 e0 03             	and    $0x3,%eax
  802524:	48 85 c0             	test   %rax,%rax
  802527:	75 36                	jne    80255f <memmove+0xfc>
  802529:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80252d:	83 e0 03             	and    $0x3,%eax
  802530:	48 85 c0             	test   %rax,%rax
  802533:	75 2a                	jne    80255f <memmove+0xfc>
  802535:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802539:	83 e0 03             	and    $0x3,%eax
  80253c:	48 85 c0             	test   %rax,%rax
  80253f:	75 1e                	jne    80255f <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  802541:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802545:	48 c1 e8 02          	shr    $0x2,%rax
  802549:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80254c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802550:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802554:	48 89 c7             	mov    %rax,%rdi
  802557:	48 89 d6             	mov    %rdx,%rsi
  80255a:	fc                   	cld    
  80255b:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80255d:	eb 15                	jmp    802574 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80255f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802563:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802567:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80256b:	48 89 c7             	mov    %rax,%rdi
  80256e:	48 89 d6             	mov    %rdx,%rsi
  802571:	fc                   	cld    
  802572:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  802574:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802578:	c9                   	leaveq 
  802579:	c3                   	retq   

000000000080257a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80257a:	55                   	push   %rbp
  80257b:	48 89 e5             	mov    %rsp,%rbp
  80257e:	48 83 ec 18          	sub    $0x18,%rsp
  802582:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802586:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80258a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80258e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802592:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802596:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80259a:	48 89 ce             	mov    %rcx,%rsi
  80259d:	48 89 c7             	mov    %rax,%rdi
  8025a0:	48 b8 63 24 80 00 00 	movabs $0x802463,%rax
  8025a7:	00 00 00 
  8025aa:	ff d0                	callq  *%rax
}
  8025ac:	c9                   	leaveq 
  8025ad:	c3                   	retq   

00000000008025ae <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8025ae:	55                   	push   %rbp
  8025af:	48 89 e5             	mov    %rsp,%rbp
  8025b2:	48 83 ec 28          	sub    $0x28,%rsp
  8025b6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8025ba:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8025be:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8025c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025c6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8025ca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025ce:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8025d2:	eb 36                	jmp    80260a <memcmp+0x5c>
		if (*s1 != *s2)
  8025d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025d8:	0f b6 10             	movzbl (%rax),%edx
  8025db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025df:	0f b6 00             	movzbl (%rax),%eax
  8025e2:	38 c2                	cmp    %al,%dl
  8025e4:	74 1a                	je     802600 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8025e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025ea:	0f b6 00             	movzbl (%rax),%eax
  8025ed:	0f b6 d0             	movzbl %al,%edx
  8025f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025f4:	0f b6 00             	movzbl (%rax),%eax
  8025f7:	0f b6 c0             	movzbl %al,%eax
  8025fa:	29 c2                	sub    %eax,%edx
  8025fc:	89 d0                	mov    %edx,%eax
  8025fe:	eb 20                	jmp    802620 <memcmp+0x72>
		s1++, s2++;
  802600:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802605:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80260a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80260e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802612:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  802616:	48 85 c0             	test   %rax,%rax
  802619:	75 b9                	jne    8025d4 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80261b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802620:	c9                   	leaveq 
  802621:	c3                   	retq   

0000000000802622 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  802622:	55                   	push   %rbp
  802623:	48 89 e5             	mov    %rsp,%rbp
  802626:	48 83 ec 28          	sub    $0x28,%rsp
  80262a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80262e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  802631:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  802635:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802639:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80263d:	48 01 d0             	add    %rdx,%rax
  802640:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  802644:	eb 15                	jmp    80265b <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  802646:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80264a:	0f b6 10             	movzbl (%rax),%edx
  80264d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802650:	38 c2                	cmp    %al,%dl
  802652:	75 02                	jne    802656 <memfind+0x34>
			break;
  802654:	eb 0f                	jmp    802665 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802656:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80265b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80265f:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  802663:	72 e1                	jb     802646 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  802665:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802669:	c9                   	leaveq 
  80266a:	c3                   	retq   

000000000080266b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80266b:	55                   	push   %rbp
  80266c:	48 89 e5             	mov    %rsp,%rbp
  80266f:	48 83 ec 34          	sub    $0x34,%rsp
  802673:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802677:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80267b:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80267e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  802685:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80268c:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80268d:	eb 05                	jmp    802694 <strtol+0x29>
		s++;
  80268f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802694:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802698:	0f b6 00             	movzbl (%rax),%eax
  80269b:	3c 20                	cmp    $0x20,%al
  80269d:	74 f0                	je     80268f <strtol+0x24>
  80269f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026a3:	0f b6 00             	movzbl (%rax),%eax
  8026a6:	3c 09                	cmp    $0x9,%al
  8026a8:	74 e5                	je     80268f <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8026aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026ae:	0f b6 00             	movzbl (%rax),%eax
  8026b1:	3c 2b                	cmp    $0x2b,%al
  8026b3:	75 07                	jne    8026bc <strtol+0x51>
		s++;
  8026b5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8026ba:	eb 17                	jmp    8026d3 <strtol+0x68>
	else if (*s == '-')
  8026bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026c0:	0f b6 00             	movzbl (%rax),%eax
  8026c3:	3c 2d                	cmp    $0x2d,%al
  8026c5:	75 0c                	jne    8026d3 <strtol+0x68>
		s++, neg = 1;
  8026c7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8026cc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8026d3:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8026d7:	74 06                	je     8026df <strtol+0x74>
  8026d9:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8026dd:	75 28                	jne    802707 <strtol+0x9c>
  8026df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026e3:	0f b6 00             	movzbl (%rax),%eax
  8026e6:	3c 30                	cmp    $0x30,%al
  8026e8:	75 1d                	jne    802707 <strtol+0x9c>
  8026ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026ee:	48 83 c0 01          	add    $0x1,%rax
  8026f2:	0f b6 00             	movzbl (%rax),%eax
  8026f5:	3c 78                	cmp    $0x78,%al
  8026f7:	75 0e                	jne    802707 <strtol+0x9c>
		s += 2, base = 16;
  8026f9:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8026fe:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  802705:	eb 2c                	jmp    802733 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  802707:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80270b:	75 19                	jne    802726 <strtol+0xbb>
  80270d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802711:	0f b6 00             	movzbl (%rax),%eax
  802714:	3c 30                	cmp    $0x30,%al
  802716:	75 0e                	jne    802726 <strtol+0xbb>
		s++, base = 8;
  802718:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80271d:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  802724:	eb 0d                	jmp    802733 <strtol+0xc8>
	else if (base == 0)
  802726:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80272a:	75 07                	jne    802733 <strtol+0xc8>
		base = 10;
  80272c:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802733:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802737:	0f b6 00             	movzbl (%rax),%eax
  80273a:	3c 2f                	cmp    $0x2f,%al
  80273c:	7e 1d                	jle    80275b <strtol+0xf0>
  80273e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802742:	0f b6 00             	movzbl (%rax),%eax
  802745:	3c 39                	cmp    $0x39,%al
  802747:	7f 12                	jg     80275b <strtol+0xf0>
			dig = *s - '0';
  802749:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80274d:	0f b6 00             	movzbl (%rax),%eax
  802750:	0f be c0             	movsbl %al,%eax
  802753:	83 e8 30             	sub    $0x30,%eax
  802756:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802759:	eb 4e                	jmp    8027a9 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80275b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80275f:	0f b6 00             	movzbl (%rax),%eax
  802762:	3c 60                	cmp    $0x60,%al
  802764:	7e 1d                	jle    802783 <strtol+0x118>
  802766:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80276a:	0f b6 00             	movzbl (%rax),%eax
  80276d:	3c 7a                	cmp    $0x7a,%al
  80276f:	7f 12                	jg     802783 <strtol+0x118>
			dig = *s - 'a' + 10;
  802771:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802775:	0f b6 00             	movzbl (%rax),%eax
  802778:	0f be c0             	movsbl %al,%eax
  80277b:	83 e8 57             	sub    $0x57,%eax
  80277e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802781:	eb 26                	jmp    8027a9 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  802783:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802787:	0f b6 00             	movzbl (%rax),%eax
  80278a:	3c 40                	cmp    $0x40,%al
  80278c:	7e 48                	jle    8027d6 <strtol+0x16b>
  80278e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802792:	0f b6 00             	movzbl (%rax),%eax
  802795:	3c 5a                	cmp    $0x5a,%al
  802797:	7f 3d                	jg     8027d6 <strtol+0x16b>
			dig = *s - 'A' + 10;
  802799:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80279d:	0f b6 00             	movzbl (%rax),%eax
  8027a0:	0f be c0             	movsbl %al,%eax
  8027a3:	83 e8 37             	sub    $0x37,%eax
  8027a6:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8027a9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027ac:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8027af:	7c 02                	jl     8027b3 <strtol+0x148>
			break;
  8027b1:	eb 23                	jmp    8027d6 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8027b3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8027b8:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8027bb:	48 98                	cltq   
  8027bd:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8027c2:	48 89 c2             	mov    %rax,%rdx
  8027c5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027c8:	48 98                	cltq   
  8027ca:	48 01 d0             	add    %rdx,%rax
  8027cd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8027d1:	e9 5d ff ff ff       	jmpq   802733 <strtol+0xc8>

	if (endptr)
  8027d6:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8027db:	74 0b                	je     8027e8 <strtol+0x17d>
		*endptr = (char *) s;
  8027dd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027e1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027e5:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8027e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027ec:	74 09                	je     8027f7 <strtol+0x18c>
  8027ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027f2:	48 f7 d8             	neg    %rax
  8027f5:	eb 04                	jmp    8027fb <strtol+0x190>
  8027f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8027fb:	c9                   	leaveq 
  8027fc:	c3                   	retq   

00000000008027fd <strstr>:

char * strstr(const char *in, const char *str)
{
  8027fd:	55                   	push   %rbp
  8027fe:	48 89 e5             	mov    %rsp,%rbp
  802801:	48 83 ec 30          	sub    $0x30,%rsp
  802805:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802809:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  80280d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802811:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802815:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  802819:	0f b6 00             	movzbl (%rax),%eax
  80281c:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  80281f:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  802823:	75 06                	jne    80282b <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  802825:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802829:	eb 6b                	jmp    802896 <strstr+0x99>

    len = strlen(str);
  80282b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80282f:	48 89 c7             	mov    %rax,%rdi
  802832:	48 b8 d3 20 80 00 00 	movabs $0x8020d3,%rax
  802839:	00 00 00 
  80283c:	ff d0                	callq  *%rax
  80283e:	48 98                	cltq   
  802840:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  802844:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802848:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80284c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  802850:	0f b6 00             	movzbl (%rax),%eax
  802853:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  802856:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80285a:	75 07                	jne    802863 <strstr+0x66>
                return (char *) 0;
  80285c:	b8 00 00 00 00       	mov    $0x0,%eax
  802861:	eb 33                	jmp    802896 <strstr+0x99>
        } while (sc != c);
  802863:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  802867:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80286a:	75 d8                	jne    802844 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  80286c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802870:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802874:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802878:	48 89 ce             	mov    %rcx,%rsi
  80287b:	48 89 c7             	mov    %rax,%rdi
  80287e:	48 b8 f4 22 80 00 00 	movabs $0x8022f4,%rax
  802885:	00 00 00 
  802888:	ff d0                	callq  *%rax
  80288a:	85 c0                	test   %eax,%eax
  80288c:	75 b6                	jne    802844 <strstr+0x47>

    return (char *) (in - 1);
  80288e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802892:	48 83 e8 01          	sub    $0x1,%rax
}
  802896:	c9                   	leaveq 
  802897:	c3                   	retq   

0000000000802898 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  802898:	55                   	push   %rbp
  802899:	48 89 e5             	mov    %rsp,%rbp
  80289c:	53                   	push   %rbx
  80289d:	48 83 ec 48          	sub    $0x48,%rsp
  8028a1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8028a4:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8028a7:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8028ab:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8028af:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8028b3:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8028b7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8028ba:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8028be:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8028c2:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8028c6:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8028ca:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8028ce:	4c 89 c3             	mov    %r8,%rbx
  8028d1:	cd 30                	int    $0x30
  8028d3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8028d7:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8028db:	74 3e                	je     80291b <syscall+0x83>
  8028dd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8028e2:	7e 37                	jle    80291b <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8028e4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028e8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8028eb:	49 89 d0             	mov    %rdx,%r8
  8028ee:	89 c1                	mov    %eax,%ecx
  8028f0:	48 ba 33 64 80 00 00 	movabs $0x806433,%rdx
  8028f7:	00 00 00 
  8028fa:	be 23 00 00 00       	mov    $0x23,%esi
  8028ff:	48 bf 50 64 80 00 00 	movabs $0x806450,%rdi
  802906:	00 00 00 
  802909:	b8 00 00 00 00       	mov    $0x0,%eax
  80290e:	49 b9 f7 11 80 00 00 	movabs $0x8011f7,%r9
  802915:	00 00 00 
  802918:	41 ff d1             	callq  *%r9

	return ret;
  80291b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80291f:	48 83 c4 48          	add    $0x48,%rsp
  802923:	5b                   	pop    %rbx
  802924:	5d                   	pop    %rbp
  802925:	c3                   	retq   

0000000000802926 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  802926:	55                   	push   %rbp
  802927:	48 89 e5             	mov    %rsp,%rbp
  80292a:	48 83 ec 20          	sub    $0x20,%rsp
  80292e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802932:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  802936:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80293a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80293e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802945:	00 
  802946:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80294c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802952:	48 89 d1             	mov    %rdx,%rcx
  802955:	48 89 c2             	mov    %rax,%rdx
  802958:	be 00 00 00 00       	mov    $0x0,%esi
  80295d:	bf 00 00 00 00       	mov    $0x0,%edi
  802962:	48 b8 98 28 80 00 00 	movabs $0x802898,%rax
  802969:	00 00 00 
  80296c:	ff d0                	callq  *%rax
}
  80296e:	c9                   	leaveq 
  80296f:	c3                   	retq   

0000000000802970 <sys_cgetc>:

int
sys_cgetc(void)
{
  802970:	55                   	push   %rbp
  802971:	48 89 e5             	mov    %rsp,%rbp
  802974:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  802978:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80297f:	00 
  802980:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802986:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80298c:	b9 00 00 00 00       	mov    $0x0,%ecx
  802991:	ba 00 00 00 00       	mov    $0x0,%edx
  802996:	be 00 00 00 00       	mov    $0x0,%esi
  80299b:	bf 01 00 00 00       	mov    $0x1,%edi
  8029a0:	48 b8 98 28 80 00 00 	movabs $0x802898,%rax
  8029a7:	00 00 00 
  8029aa:	ff d0                	callq  *%rax
}
  8029ac:	c9                   	leaveq 
  8029ad:	c3                   	retq   

00000000008029ae <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8029ae:	55                   	push   %rbp
  8029af:	48 89 e5             	mov    %rsp,%rbp
  8029b2:	48 83 ec 10          	sub    $0x10,%rsp
  8029b6:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8029b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029bc:	48 98                	cltq   
  8029be:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8029c5:	00 
  8029c6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8029cc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8029d2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8029d7:	48 89 c2             	mov    %rax,%rdx
  8029da:	be 01 00 00 00       	mov    $0x1,%esi
  8029df:	bf 03 00 00 00       	mov    $0x3,%edi
  8029e4:	48 b8 98 28 80 00 00 	movabs $0x802898,%rax
  8029eb:	00 00 00 
  8029ee:	ff d0                	callq  *%rax
}
  8029f0:	c9                   	leaveq 
  8029f1:	c3                   	retq   

00000000008029f2 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8029f2:	55                   	push   %rbp
  8029f3:	48 89 e5             	mov    %rsp,%rbp
  8029f6:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8029fa:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802a01:	00 
  802a02:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802a08:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802a0e:	b9 00 00 00 00       	mov    $0x0,%ecx
  802a13:	ba 00 00 00 00       	mov    $0x0,%edx
  802a18:	be 00 00 00 00       	mov    $0x0,%esi
  802a1d:	bf 02 00 00 00       	mov    $0x2,%edi
  802a22:	48 b8 98 28 80 00 00 	movabs $0x802898,%rax
  802a29:	00 00 00 
  802a2c:	ff d0                	callq  *%rax
}
  802a2e:	c9                   	leaveq 
  802a2f:	c3                   	retq   

0000000000802a30 <sys_yield>:

void
sys_yield(void)
{
  802a30:	55                   	push   %rbp
  802a31:	48 89 e5             	mov    %rsp,%rbp
  802a34:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  802a38:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802a3f:	00 
  802a40:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802a46:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802a4c:	b9 00 00 00 00       	mov    $0x0,%ecx
  802a51:	ba 00 00 00 00       	mov    $0x0,%edx
  802a56:	be 00 00 00 00       	mov    $0x0,%esi
  802a5b:	bf 0b 00 00 00       	mov    $0xb,%edi
  802a60:	48 b8 98 28 80 00 00 	movabs $0x802898,%rax
  802a67:	00 00 00 
  802a6a:	ff d0                	callq  *%rax
}
  802a6c:	c9                   	leaveq 
  802a6d:	c3                   	retq   

0000000000802a6e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802a6e:	55                   	push   %rbp
  802a6f:	48 89 e5             	mov    %rsp,%rbp
  802a72:	48 83 ec 20          	sub    $0x20,%rsp
  802a76:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802a79:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802a7d:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  802a80:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a83:	48 63 c8             	movslq %eax,%rcx
  802a86:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a8d:	48 98                	cltq   
  802a8f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802a96:	00 
  802a97:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802a9d:	49 89 c8             	mov    %rcx,%r8
  802aa0:	48 89 d1             	mov    %rdx,%rcx
  802aa3:	48 89 c2             	mov    %rax,%rdx
  802aa6:	be 01 00 00 00       	mov    $0x1,%esi
  802aab:	bf 04 00 00 00       	mov    $0x4,%edi
  802ab0:	48 b8 98 28 80 00 00 	movabs $0x802898,%rax
  802ab7:	00 00 00 
  802aba:	ff d0                	callq  *%rax
}
  802abc:	c9                   	leaveq 
  802abd:	c3                   	retq   

0000000000802abe <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802abe:	55                   	push   %rbp
  802abf:	48 89 e5             	mov    %rsp,%rbp
  802ac2:	48 83 ec 30          	sub    $0x30,%rsp
  802ac6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802ac9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802acd:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802ad0:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802ad4:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  802ad8:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802adb:	48 63 c8             	movslq %eax,%rcx
  802ade:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802ae2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ae5:	48 63 f0             	movslq %eax,%rsi
  802ae8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802aec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aef:	48 98                	cltq   
  802af1:	48 89 0c 24          	mov    %rcx,(%rsp)
  802af5:	49 89 f9             	mov    %rdi,%r9
  802af8:	49 89 f0             	mov    %rsi,%r8
  802afb:	48 89 d1             	mov    %rdx,%rcx
  802afe:	48 89 c2             	mov    %rax,%rdx
  802b01:	be 01 00 00 00       	mov    $0x1,%esi
  802b06:	bf 05 00 00 00       	mov    $0x5,%edi
  802b0b:	48 b8 98 28 80 00 00 	movabs $0x802898,%rax
  802b12:	00 00 00 
  802b15:	ff d0                	callq  *%rax
}
  802b17:	c9                   	leaveq 
  802b18:	c3                   	retq   

0000000000802b19 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  802b19:	55                   	push   %rbp
  802b1a:	48 89 e5             	mov    %rsp,%rbp
  802b1d:	48 83 ec 20          	sub    $0x20,%rsp
  802b21:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802b24:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  802b28:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b2c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b2f:	48 98                	cltq   
  802b31:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802b38:	00 
  802b39:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802b3f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802b45:	48 89 d1             	mov    %rdx,%rcx
  802b48:	48 89 c2             	mov    %rax,%rdx
  802b4b:	be 01 00 00 00       	mov    $0x1,%esi
  802b50:	bf 06 00 00 00       	mov    $0x6,%edi
  802b55:	48 b8 98 28 80 00 00 	movabs $0x802898,%rax
  802b5c:	00 00 00 
  802b5f:	ff d0                	callq  *%rax
}
  802b61:	c9                   	leaveq 
  802b62:	c3                   	retq   

0000000000802b63 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  802b63:	55                   	push   %rbp
  802b64:	48 89 e5             	mov    %rsp,%rbp
  802b67:	48 83 ec 10          	sub    $0x10,%rsp
  802b6b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802b6e:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  802b71:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b74:	48 63 d0             	movslq %eax,%rdx
  802b77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b7a:	48 98                	cltq   
  802b7c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802b83:	00 
  802b84:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802b8a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802b90:	48 89 d1             	mov    %rdx,%rcx
  802b93:	48 89 c2             	mov    %rax,%rdx
  802b96:	be 01 00 00 00       	mov    $0x1,%esi
  802b9b:	bf 08 00 00 00       	mov    $0x8,%edi
  802ba0:	48 b8 98 28 80 00 00 	movabs $0x802898,%rax
  802ba7:	00 00 00 
  802baa:	ff d0                	callq  *%rax
}
  802bac:	c9                   	leaveq 
  802bad:	c3                   	retq   

0000000000802bae <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802bae:	55                   	push   %rbp
  802baf:	48 89 e5             	mov    %rsp,%rbp
  802bb2:	48 83 ec 20          	sub    $0x20,%rsp
  802bb6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802bb9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  802bbd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802bc1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bc4:	48 98                	cltq   
  802bc6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802bcd:	00 
  802bce:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802bd4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802bda:	48 89 d1             	mov    %rdx,%rcx
  802bdd:	48 89 c2             	mov    %rax,%rdx
  802be0:	be 01 00 00 00       	mov    $0x1,%esi
  802be5:	bf 09 00 00 00       	mov    $0x9,%edi
  802bea:	48 b8 98 28 80 00 00 	movabs $0x802898,%rax
  802bf1:	00 00 00 
  802bf4:	ff d0                	callq  *%rax
}
  802bf6:	c9                   	leaveq 
  802bf7:	c3                   	retq   

0000000000802bf8 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802bf8:	55                   	push   %rbp
  802bf9:	48 89 e5             	mov    %rsp,%rbp
  802bfc:	48 83 ec 20          	sub    $0x20,%rsp
  802c00:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802c03:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  802c07:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c0e:	48 98                	cltq   
  802c10:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802c17:	00 
  802c18:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802c1e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802c24:	48 89 d1             	mov    %rdx,%rcx
  802c27:	48 89 c2             	mov    %rax,%rdx
  802c2a:	be 01 00 00 00       	mov    $0x1,%esi
  802c2f:	bf 0a 00 00 00       	mov    $0xa,%edi
  802c34:	48 b8 98 28 80 00 00 	movabs $0x802898,%rax
  802c3b:	00 00 00 
  802c3e:	ff d0                	callq  *%rax
}
  802c40:	c9                   	leaveq 
  802c41:	c3                   	retq   

0000000000802c42 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  802c42:	55                   	push   %rbp
  802c43:	48 89 e5             	mov    %rsp,%rbp
  802c46:	48 83 ec 20          	sub    $0x20,%rsp
  802c4a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802c4d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802c51:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802c55:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  802c58:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c5b:	48 63 f0             	movslq %eax,%rsi
  802c5e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802c62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c65:	48 98                	cltq   
  802c67:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c6b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802c72:	00 
  802c73:	49 89 f1             	mov    %rsi,%r9
  802c76:	49 89 c8             	mov    %rcx,%r8
  802c79:	48 89 d1             	mov    %rdx,%rcx
  802c7c:	48 89 c2             	mov    %rax,%rdx
  802c7f:	be 00 00 00 00       	mov    $0x0,%esi
  802c84:	bf 0c 00 00 00       	mov    $0xc,%edi
  802c89:	48 b8 98 28 80 00 00 	movabs $0x802898,%rax
  802c90:	00 00 00 
  802c93:	ff d0                	callq  *%rax
}
  802c95:	c9                   	leaveq 
  802c96:	c3                   	retq   

0000000000802c97 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802c97:	55                   	push   %rbp
  802c98:	48 89 e5             	mov    %rsp,%rbp
  802c9b:	48 83 ec 10          	sub    $0x10,%rsp
  802c9f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  802ca3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ca7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802cae:	00 
  802caf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802cb5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802cbb:	b9 00 00 00 00       	mov    $0x0,%ecx
  802cc0:	48 89 c2             	mov    %rax,%rdx
  802cc3:	be 01 00 00 00       	mov    $0x1,%esi
  802cc8:	bf 0d 00 00 00       	mov    $0xd,%edi
  802ccd:	48 b8 98 28 80 00 00 	movabs $0x802898,%rax
  802cd4:	00 00 00 
  802cd7:	ff d0                	callq  *%rax
}
  802cd9:	c9                   	leaveq 
  802cda:	c3                   	retq   

0000000000802cdb <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  802cdb:	55                   	push   %rbp
  802cdc:	48 89 e5             	mov    %rsp,%rbp
  802cdf:	48 83 ec 30          	sub    $0x30,%rsp
  802ce3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  802ce7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ceb:	48 8b 00             	mov    (%rax),%rax
  802cee:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  802cf2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802cf6:	48 8b 40 08          	mov    0x8(%rax),%rax
  802cfa:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  802cfd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d00:	83 e0 02             	and    $0x2,%eax
  802d03:	85 c0                	test   %eax,%eax
  802d05:	75 4d                	jne    802d54 <pgfault+0x79>
  802d07:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d0b:	48 c1 e8 0c          	shr    $0xc,%rax
  802d0f:	48 89 c2             	mov    %rax,%rdx
  802d12:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802d19:	01 00 00 
  802d1c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d20:	25 00 08 00 00       	and    $0x800,%eax
  802d25:	48 85 c0             	test   %rax,%rax
  802d28:	74 2a                	je     802d54 <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  802d2a:	48 ba 60 64 80 00 00 	movabs $0x806460,%rdx
  802d31:	00 00 00 
  802d34:	be 23 00 00 00       	mov    $0x23,%esi
  802d39:	48 bf 95 64 80 00 00 	movabs $0x806495,%rdi
  802d40:	00 00 00 
  802d43:	b8 00 00 00 00       	mov    $0x0,%eax
  802d48:	48 b9 f7 11 80 00 00 	movabs $0x8011f7,%rcx
  802d4f:	00 00 00 
  802d52:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  802d54:	ba 07 00 00 00       	mov    $0x7,%edx
  802d59:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802d5e:	bf 00 00 00 00       	mov    $0x0,%edi
  802d63:	48 b8 6e 2a 80 00 00 	movabs $0x802a6e,%rax
  802d6a:	00 00 00 
  802d6d:	ff d0                	callq  *%rax
  802d6f:	85 c0                	test   %eax,%eax
  802d71:	0f 85 cd 00 00 00    	jne    802e44 <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  802d77:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d7b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802d7f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d83:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802d89:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  802d8d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d91:	ba 00 10 00 00       	mov    $0x1000,%edx
  802d96:	48 89 c6             	mov    %rax,%rsi
  802d99:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802d9e:	48 b8 63 24 80 00 00 	movabs $0x802463,%rax
  802da5:	00 00 00 
  802da8:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  802daa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802dae:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802db4:	48 89 c1             	mov    %rax,%rcx
  802db7:	ba 00 00 00 00       	mov    $0x0,%edx
  802dbc:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802dc1:	bf 00 00 00 00       	mov    $0x0,%edi
  802dc6:	48 b8 be 2a 80 00 00 	movabs $0x802abe,%rax
  802dcd:	00 00 00 
  802dd0:	ff d0                	callq  *%rax
  802dd2:	85 c0                	test   %eax,%eax
  802dd4:	79 2a                	jns    802e00 <pgfault+0x125>
				panic("Page map at temp address failed");
  802dd6:	48 ba a0 64 80 00 00 	movabs $0x8064a0,%rdx
  802ddd:	00 00 00 
  802de0:	be 30 00 00 00       	mov    $0x30,%esi
  802de5:	48 bf 95 64 80 00 00 	movabs $0x806495,%rdi
  802dec:	00 00 00 
  802def:	b8 00 00 00 00       	mov    $0x0,%eax
  802df4:	48 b9 f7 11 80 00 00 	movabs $0x8011f7,%rcx
  802dfb:	00 00 00 
  802dfe:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  802e00:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802e05:	bf 00 00 00 00       	mov    $0x0,%edi
  802e0a:	48 b8 19 2b 80 00 00 	movabs $0x802b19,%rax
  802e11:	00 00 00 
  802e14:	ff d0                	callq  *%rax
  802e16:	85 c0                	test   %eax,%eax
  802e18:	79 54                	jns    802e6e <pgfault+0x193>
				panic("Page unmap from temp location failed");
  802e1a:	48 ba c0 64 80 00 00 	movabs $0x8064c0,%rdx
  802e21:	00 00 00 
  802e24:	be 32 00 00 00       	mov    $0x32,%esi
  802e29:	48 bf 95 64 80 00 00 	movabs $0x806495,%rdi
  802e30:	00 00 00 
  802e33:	b8 00 00 00 00       	mov    $0x0,%eax
  802e38:	48 b9 f7 11 80 00 00 	movabs $0x8011f7,%rcx
  802e3f:	00 00 00 
  802e42:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  802e44:	48 ba e8 64 80 00 00 	movabs $0x8064e8,%rdx
  802e4b:	00 00 00 
  802e4e:	be 34 00 00 00       	mov    $0x34,%esi
  802e53:	48 bf 95 64 80 00 00 	movabs $0x806495,%rdi
  802e5a:	00 00 00 
  802e5d:	b8 00 00 00 00       	mov    $0x0,%eax
  802e62:	48 b9 f7 11 80 00 00 	movabs $0x8011f7,%rcx
  802e69:	00 00 00 
  802e6c:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  802e6e:	c9                   	leaveq 
  802e6f:	c3                   	retq   

0000000000802e70 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  802e70:	55                   	push   %rbp
  802e71:	48 89 e5             	mov    %rsp,%rbp
  802e74:	48 83 ec 20          	sub    $0x20,%rsp
  802e78:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e7b:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  802e7e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802e85:	01 00 00 
  802e88:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802e8b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e8f:	25 07 0e 00 00       	and    $0xe07,%eax
  802e94:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  802e97:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802e9a:	48 c1 e0 0c          	shl    $0xc,%rax
  802e9e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  802ea2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ea5:	25 00 04 00 00       	and    $0x400,%eax
  802eaa:	85 c0                	test   %eax,%eax
  802eac:	74 57                	je     802f05 <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  802eae:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802eb1:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802eb5:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802eb8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ebc:	41 89 f0             	mov    %esi,%r8d
  802ebf:	48 89 c6             	mov    %rax,%rsi
  802ec2:	bf 00 00 00 00       	mov    $0x0,%edi
  802ec7:	48 b8 be 2a 80 00 00 	movabs $0x802abe,%rax
  802ece:	00 00 00 
  802ed1:	ff d0                	callq  *%rax
  802ed3:	85 c0                	test   %eax,%eax
  802ed5:	0f 8e 52 01 00 00    	jle    80302d <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  802edb:	48 ba 1a 65 80 00 00 	movabs $0x80651a,%rdx
  802ee2:	00 00 00 
  802ee5:	be 4e 00 00 00       	mov    $0x4e,%esi
  802eea:	48 bf 95 64 80 00 00 	movabs $0x806495,%rdi
  802ef1:	00 00 00 
  802ef4:	b8 00 00 00 00       	mov    $0x0,%eax
  802ef9:	48 b9 f7 11 80 00 00 	movabs $0x8011f7,%rcx
  802f00:	00 00 00 
  802f03:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  802f05:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f08:	83 e0 02             	and    $0x2,%eax
  802f0b:	85 c0                	test   %eax,%eax
  802f0d:	75 10                	jne    802f1f <duppage+0xaf>
  802f0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f12:	25 00 08 00 00       	and    $0x800,%eax
  802f17:	85 c0                	test   %eax,%eax
  802f19:	0f 84 bb 00 00 00    	je     802fda <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  802f1f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f22:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  802f27:	80 cc 08             	or     $0x8,%ah
  802f2a:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  802f2d:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802f30:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802f34:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802f37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f3b:	41 89 f0             	mov    %esi,%r8d
  802f3e:	48 89 c6             	mov    %rax,%rsi
  802f41:	bf 00 00 00 00       	mov    $0x0,%edi
  802f46:	48 b8 be 2a 80 00 00 	movabs $0x802abe,%rax
  802f4d:	00 00 00 
  802f50:	ff d0                	callq  *%rax
  802f52:	85 c0                	test   %eax,%eax
  802f54:	7e 2a                	jle    802f80 <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  802f56:	48 ba 1a 65 80 00 00 	movabs $0x80651a,%rdx
  802f5d:	00 00 00 
  802f60:	be 55 00 00 00       	mov    $0x55,%esi
  802f65:	48 bf 95 64 80 00 00 	movabs $0x806495,%rdi
  802f6c:	00 00 00 
  802f6f:	b8 00 00 00 00       	mov    $0x0,%eax
  802f74:	48 b9 f7 11 80 00 00 	movabs $0x8011f7,%rcx
  802f7b:	00 00 00 
  802f7e:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  802f80:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  802f83:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f87:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f8b:	41 89 c8             	mov    %ecx,%r8d
  802f8e:	48 89 d1             	mov    %rdx,%rcx
  802f91:	ba 00 00 00 00       	mov    $0x0,%edx
  802f96:	48 89 c6             	mov    %rax,%rsi
  802f99:	bf 00 00 00 00       	mov    $0x0,%edi
  802f9e:	48 b8 be 2a 80 00 00 	movabs $0x802abe,%rax
  802fa5:	00 00 00 
  802fa8:	ff d0                	callq  *%rax
  802faa:	85 c0                	test   %eax,%eax
  802fac:	7e 2a                	jle    802fd8 <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  802fae:	48 ba 1a 65 80 00 00 	movabs $0x80651a,%rdx
  802fb5:	00 00 00 
  802fb8:	be 57 00 00 00       	mov    $0x57,%esi
  802fbd:	48 bf 95 64 80 00 00 	movabs $0x806495,%rdi
  802fc4:	00 00 00 
  802fc7:	b8 00 00 00 00       	mov    $0x0,%eax
  802fcc:	48 b9 f7 11 80 00 00 	movabs $0x8011f7,%rcx
  802fd3:	00 00 00 
  802fd6:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  802fd8:	eb 53                	jmp    80302d <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  802fda:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802fdd:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802fe1:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802fe4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fe8:	41 89 f0             	mov    %esi,%r8d
  802feb:	48 89 c6             	mov    %rax,%rsi
  802fee:	bf 00 00 00 00       	mov    $0x0,%edi
  802ff3:	48 b8 be 2a 80 00 00 	movabs $0x802abe,%rax
  802ffa:	00 00 00 
  802ffd:	ff d0                	callq  *%rax
  802fff:	85 c0                	test   %eax,%eax
  803001:	7e 2a                	jle    80302d <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  803003:	48 ba 1a 65 80 00 00 	movabs $0x80651a,%rdx
  80300a:	00 00 00 
  80300d:	be 5b 00 00 00       	mov    $0x5b,%esi
  803012:	48 bf 95 64 80 00 00 	movabs $0x806495,%rdi
  803019:	00 00 00 
  80301c:	b8 00 00 00 00       	mov    $0x0,%eax
  803021:	48 b9 f7 11 80 00 00 	movabs $0x8011f7,%rcx
  803028:	00 00 00 
  80302b:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  80302d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803032:	c9                   	leaveq 
  803033:	c3                   	retq   

0000000000803034 <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  803034:	55                   	push   %rbp
  803035:	48 89 e5             	mov    %rsp,%rbp
  803038:	48 83 ec 18          	sub    $0x18,%rsp
  80303c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  803040:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803044:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  803048:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80304c:	48 c1 e8 27          	shr    $0x27,%rax
  803050:	48 89 c2             	mov    %rax,%rdx
  803053:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80305a:	01 00 00 
  80305d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803061:	83 e0 01             	and    $0x1,%eax
  803064:	48 85 c0             	test   %rax,%rax
  803067:	74 51                	je     8030ba <pt_is_mapped+0x86>
  803069:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80306d:	48 c1 e0 0c          	shl    $0xc,%rax
  803071:	48 c1 e8 1e          	shr    $0x1e,%rax
  803075:	48 89 c2             	mov    %rax,%rdx
  803078:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80307f:	01 00 00 
  803082:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803086:	83 e0 01             	and    $0x1,%eax
  803089:	48 85 c0             	test   %rax,%rax
  80308c:	74 2c                	je     8030ba <pt_is_mapped+0x86>
  80308e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803092:	48 c1 e0 0c          	shl    $0xc,%rax
  803096:	48 c1 e8 15          	shr    $0x15,%rax
  80309a:	48 89 c2             	mov    %rax,%rdx
  80309d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8030a4:	01 00 00 
  8030a7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8030ab:	83 e0 01             	and    $0x1,%eax
  8030ae:	48 85 c0             	test   %rax,%rax
  8030b1:	74 07                	je     8030ba <pt_is_mapped+0x86>
  8030b3:	b8 01 00 00 00       	mov    $0x1,%eax
  8030b8:	eb 05                	jmp    8030bf <pt_is_mapped+0x8b>
  8030ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8030bf:	83 e0 01             	and    $0x1,%eax
}
  8030c2:	c9                   	leaveq 
  8030c3:	c3                   	retq   

00000000008030c4 <fork>:

envid_t
fork(void)
{
  8030c4:	55                   	push   %rbp
  8030c5:	48 89 e5             	mov    %rsp,%rbp
  8030c8:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  8030cc:	48 bf db 2c 80 00 00 	movabs $0x802cdb,%rdi
  8030d3:	00 00 00 
  8030d6:	48 b8 41 59 80 00 00 	movabs $0x805941,%rax
  8030dd:	00 00 00 
  8030e0:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8030e2:	b8 07 00 00 00       	mov    $0x7,%eax
  8030e7:	cd 30                	int    $0x30
  8030e9:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8030ec:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  8030ef:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  8030f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8030f6:	79 30                	jns    803128 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  8030f8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8030fb:	89 c1                	mov    %eax,%ecx
  8030fd:	48 ba 38 65 80 00 00 	movabs $0x806538,%rdx
  803104:	00 00 00 
  803107:	be 86 00 00 00       	mov    $0x86,%esi
  80310c:	48 bf 95 64 80 00 00 	movabs $0x806495,%rdi
  803113:	00 00 00 
  803116:	b8 00 00 00 00       	mov    $0x0,%eax
  80311b:	49 b8 f7 11 80 00 00 	movabs $0x8011f7,%r8
  803122:	00 00 00 
  803125:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  803128:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80312c:	75 46                	jne    803174 <fork+0xb0>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  80312e:	48 b8 f2 29 80 00 00 	movabs $0x8029f2,%rax
  803135:	00 00 00 
  803138:	ff d0                	callq  *%rax
  80313a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80313f:	48 63 d0             	movslq %eax,%rdx
  803142:	48 89 d0             	mov    %rdx,%rax
  803145:	48 c1 e0 03          	shl    $0x3,%rax
  803149:	48 01 d0             	add    %rdx,%rax
  80314c:	48 c1 e0 05          	shl    $0x5,%rax
  803150:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803157:	00 00 00 
  80315a:	48 01 c2             	add    %rax,%rdx
  80315d:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  803164:	00 00 00 
  803167:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  80316a:	b8 00 00 00 00       	mov    $0x0,%eax
  80316f:	e9 d1 01 00 00       	jmpq   803345 <fork+0x281>
	}
	uint64_t ad = 0;
  803174:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80317b:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  80317c:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  803181:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803185:	e9 df 00 00 00       	jmpq   803269 <fork+0x1a5>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  80318a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80318e:	48 c1 e8 27          	shr    $0x27,%rax
  803192:	48 89 c2             	mov    %rax,%rdx
  803195:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80319c:	01 00 00 
  80319f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8031a3:	83 e0 01             	and    $0x1,%eax
  8031a6:	48 85 c0             	test   %rax,%rax
  8031a9:	0f 84 9e 00 00 00    	je     80324d <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  8031af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031b3:	48 c1 e8 1e          	shr    $0x1e,%rax
  8031b7:	48 89 c2             	mov    %rax,%rdx
  8031ba:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8031c1:	01 00 00 
  8031c4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8031c8:	83 e0 01             	and    $0x1,%eax
  8031cb:	48 85 c0             	test   %rax,%rax
  8031ce:	74 73                	je     803243 <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  8031d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031d4:	48 c1 e8 15          	shr    $0x15,%rax
  8031d8:	48 89 c2             	mov    %rax,%rdx
  8031db:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8031e2:	01 00 00 
  8031e5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8031e9:	83 e0 01             	and    $0x1,%eax
  8031ec:	48 85 c0             	test   %rax,%rax
  8031ef:	74 48                	je     803239 <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  8031f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031f5:	48 c1 e8 0c          	shr    $0xc,%rax
  8031f9:	48 89 c2             	mov    %rax,%rdx
  8031fc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803203:	01 00 00 
  803206:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80320a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80320e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803212:	83 e0 01             	and    $0x1,%eax
  803215:	48 85 c0             	test   %rax,%rax
  803218:	74 47                	je     803261 <fork+0x19d>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  80321a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80321e:	48 c1 e8 0c          	shr    $0xc,%rax
  803222:	89 c2                	mov    %eax,%edx
  803224:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803227:	89 d6                	mov    %edx,%esi
  803229:	89 c7                	mov    %eax,%edi
  80322b:	48 b8 70 2e 80 00 00 	movabs $0x802e70,%rax
  803232:	00 00 00 
  803235:	ff d0                	callq  *%rax
  803237:	eb 28                	jmp    803261 <fork+0x19d>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  803239:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  803240:	00 
  803241:	eb 1e                	jmp    803261 <fork+0x19d>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  803243:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  80324a:	40 
  80324b:	eb 14                	jmp    803261 <fork+0x19d>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  80324d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803251:	48 c1 e8 27          	shr    $0x27,%rax
  803255:	48 83 c0 01          	add    $0x1,%rax
  803259:	48 c1 e0 27          	shl    $0x27,%rax
  80325d:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  803261:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  803268:	00 
  803269:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  803270:	00 
  803271:	0f 87 13 ff ff ff    	ja     80318a <fork+0xc6>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  803277:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80327a:	ba 07 00 00 00       	mov    $0x7,%edx
  80327f:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803284:	89 c7                	mov    %eax,%edi
  803286:	48 b8 6e 2a 80 00 00 	movabs $0x802a6e,%rax
  80328d:	00 00 00 
  803290:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  803292:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803295:	ba 07 00 00 00       	mov    $0x7,%edx
  80329a:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80329f:	89 c7                	mov    %eax,%edi
  8032a1:	48 b8 6e 2a 80 00 00 	movabs $0x802a6e,%rax
  8032a8:	00 00 00 
  8032ab:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  8032ad:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8032b0:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8032b6:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  8032bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8032c0:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8032c5:	89 c7                	mov    %eax,%edi
  8032c7:	48 b8 be 2a 80 00 00 	movabs $0x802abe,%rax
  8032ce:	00 00 00 
  8032d1:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  8032d3:	ba 00 10 00 00       	mov    $0x1000,%edx
  8032d8:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8032dd:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  8032e2:	48 b8 63 24 80 00 00 	movabs $0x802463,%rax
  8032e9:	00 00 00 
  8032ec:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  8032ee:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8032f3:	bf 00 00 00 00       	mov    $0x0,%edi
  8032f8:	48 b8 19 2b 80 00 00 	movabs $0x802b19,%rax
  8032ff:	00 00 00 
  803302:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  803304:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  80330b:	00 00 00 
  80330e:	48 8b 00             	mov    (%rax),%rax
  803311:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  803318:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80331b:	48 89 d6             	mov    %rdx,%rsi
  80331e:	89 c7                	mov    %eax,%edi
  803320:	48 b8 f8 2b 80 00 00 	movabs $0x802bf8,%rax
  803327:	00 00 00 
  80332a:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  80332c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80332f:	be 02 00 00 00       	mov    $0x2,%esi
  803334:	89 c7                	mov    %eax,%edi
  803336:	48 b8 63 2b 80 00 00 	movabs $0x802b63,%rax
  80333d:	00 00 00 
  803340:	ff d0                	callq  *%rax

	return envid;
  803342:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  803345:	c9                   	leaveq 
  803346:	c3                   	retq   

0000000000803347 <sfork>:

	
// Challenge!
int
sfork(void)
{
  803347:	55                   	push   %rbp
  803348:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  80334b:	48 ba 50 65 80 00 00 	movabs $0x806550,%rdx
  803352:	00 00 00 
  803355:	be bf 00 00 00       	mov    $0xbf,%esi
  80335a:	48 bf 95 64 80 00 00 	movabs $0x806495,%rdi
  803361:	00 00 00 
  803364:	b8 00 00 00 00       	mov    $0x0,%eax
  803369:	48 b9 f7 11 80 00 00 	movabs $0x8011f7,%rcx
  803370:	00 00 00 
  803373:	ff d1                	callq  *%rcx

0000000000803375 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  803375:	55                   	push   %rbp
  803376:	48 89 e5             	mov    %rsp,%rbp
  803379:	48 83 ec 18          	sub    $0x18,%rsp
  80337d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803381:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803385:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	args->argc = argc;
  803389:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80338d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803391:	48 89 10             	mov    %rdx,(%rax)
	args->argv = (const char **) argv;
  803394:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803398:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80339c:	48 89 50 08          	mov    %rdx,0x8(%rax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  8033a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033a4:	8b 00                	mov    (%rax),%eax
  8033a6:	83 f8 01             	cmp    $0x1,%eax
  8033a9:	7e 13                	jle    8033be <argstart+0x49>
  8033ab:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  8033b0:	74 0c                	je     8033be <argstart+0x49>
  8033b2:	48 b8 66 65 80 00 00 	movabs $0x806566,%rax
  8033b9:	00 00 00 
  8033bc:	eb 05                	jmp    8033c3 <argstart+0x4e>
  8033be:	b8 00 00 00 00       	mov    $0x0,%eax
  8033c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8033c7:	48 89 42 10          	mov    %rax,0x10(%rdx)
	args->argvalue = 0;
  8033cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033cf:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  8033d6:	00 
}
  8033d7:	c9                   	leaveq 
  8033d8:	c3                   	retq   

00000000008033d9 <argnext>:

int
argnext(struct Argstate *args)
{
  8033d9:	55                   	push   %rbp
  8033da:	48 89 e5             	mov    %rsp,%rbp
  8033dd:	48 83 ec 20          	sub    $0x20,%rsp
  8033e1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int arg;

	args->argvalue = 0;
  8033e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033e9:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  8033f0:	00 

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  8033f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033f5:	48 8b 40 10          	mov    0x10(%rax),%rax
  8033f9:	48 85 c0             	test   %rax,%rax
  8033fc:	75 0a                	jne    803408 <argnext+0x2f>
		return -1;
  8033fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  803403:	e9 25 01 00 00       	jmpq   80352d <argnext+0x154>

	if (!*args->curarg) {
  803408:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80340c:	48 8b 40 10          	mov    0x10(%rax),%rax
  803410:	0f b6 00             	movzbl (%rax),%eax
  803413:	84 c0                	test   %al,%al
  803415:	0f 85 d7 00 00 00    	jne    8034f2 <argnext+0x119>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  80341b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80341f:	48 8b 00             	mov    (%rax),%rax
  803422:	8b 00                	mov    (%rax),%eax
  803424:	83 f8 01             	cmp    $0x1,%eax
  803427:	0f 84 ef 00 00 00    	je     80351c <argnext+0x143>
		    || args->argv[1][0] != '-'
  80342d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803431:	48 8b 40 08          	mov    0x8(%rax),%rax
  803435:	48 83 c0 08          	add    $0x8,%rax
  803439:	48 8b 00             	mov    (%rax),%rax
  80343c:	0f b6 00             	movzbl (%rax),%eax
  80343f:	3c 2d                	cmp    $0x2d,%al
  803441:	0f 85 d5 00 00 00    	jne    80351c <argnext+0x143>
		    || args->argv[1][1] == '\0')
  803447:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80344b:	48 8b 40 08          	mov    0x8(%rax),%rax
  80344f:	48 83 c0 08          	add    $0x8,%rax
  803453:	48 8b 00             	mov    (%rax),%rax
  803456:	48 83 c0 01          	add    $0x1,%rax
  80345a:	0f b6 00             	movzbl (%rax),%eax
  80345d:	84 c0                	test   %al,%al
  80345f:	0f 84 b7 00 00 00    	je     80351c <argnext+0x143>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  803465:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803469:	48 8b 40 08          	mov    0x8(%rax),%rax
  80346d:	48 83 c0 08          	add    $0x8,%rax
  803471:	48 8b 00             	mov    (%rax),%rax
  803474:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803478:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80347c:	48 89 50 10          	mov    %rdx,0x10(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  803480:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803484:	48 8b 00             	mov    (%rax),%rax
  803487:	8b 00                	mov    (%rax),%eax
  803489:	83 e8 01             	sub    $0x1,%eax
  80348c:	48 98                	cltq   
  80348e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803495:	00 
  803496:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80349a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80349e:	48 8d 48 10          	lea    0x10(%rax),%rcx
  8034a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034a6:	48 8b 40 08          	mov    0x8(%rax),%rax
  8034aa:	48 83 c0 08          	add    $0x8,%rax
  8034ae:	48 89 ce             	mov    %rcx,%rsi
  8034b1:	48 89 c7             	mov    %rax,%rdi
  8034b4:	48 b8 63 24 80 00 00 	movabs $0x802463,%rax
  8034bb:	00 00 00 
  8034be:	ff d0                	callq  *%rax
		(*args->argc)--;
  8034c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034c4:	48 8b 00             	mov    (%rax),%rax
  8034c7:	8b 10                	mov    (%rax),%edx
  8034c9:	83 ea 01             	sub    $0x1,%edx
  8034cc:	89 10                	mov    %edx,(%rax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  8034ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034d2:	48 8b 40 10          	mov    0x10(%rax),%rax
  8034d6:	0f b6 00             	movzbl (%rax),%eax
  8034d9:	3c 2d                	cmp    $0x2d,%al
  8034db:	75 15                	jne    8034f2 <argnext+0x119>
  8034dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034e1:	48 8b 40 10          	mov    0x10(%rax),%rax
  8034e5:	48 83 c0 01          	add    $0x1,%rax
  8034e9:	0f b6 00             	movzbl (%rax),%eax
  8034ec:	84 c0                	test   %al,%al
  8034ee:	75 02                	jne    8034f2 <argnext+0x119>
			goto endofargs;
  8034f0:	eb 2a                	jmp    80351c <argnext+0x143>
	}

	arg = (unsigned char) *args->curarg;
  8034f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034f6:	48 8b 40 10          	mov    0x10(%rax),%rax
  8034fa:	0f b6 00             	movzbl (%rax),%eax
  8034fd:	0f b6 c0             	movzbl %al,%eax
  803500:	89 45 fc             	mov    %eax,-0x4(%rbp)
	args->curarg++;
  803503:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803507:	48 8b 40 10          	mov    0x10(%rax),%rax
  80350b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80350f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803513:	48 89 50 10          	mov    %rdx,0x10(%rax)
	return arg;
  803517:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80351a:	eb 11                	jmp    80352d <argnext+0x154>

    endofargs:
	args->curarg = 0;
  80351c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803520:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  803527:	00 
	return -1;
  803528:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  80352d:	c9                   	leaveq 
  80352e:	c3                   	retq   

000000000080352f <argvalue>:

char *
argvalue(struct Argstate *args)
{
  80352f:	55                   	push   %rbp
  803530:	48 89 e5             	mov    %rsp,%rbp
  803533:	48 83 ec 10          	sub    $0x10,%rsp
  803537:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  80353b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80353f:	48 8b 40 18          	mov    0x18(%rax),%rax
  803543:	48 85 c0             	test   %rax,%rax
  803546:	74 0a                	je     803552 <argvalue+0x23>
  803548:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80354c:	48 8b 40 18          	mov    0x18(%rax),%rax
  803550:	eb 13                	jmp    803565 <argvalue+0x36>
  803552:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803556:	48 89 c7             	mov    %rax,%rdi
  803559:	48 b8 67 35 80 00 00 	movabs $0x803567,%rax
  803560:	00 00 00 
  803563:	ff d0                	callq  *%rax
}
  803565:	c9                   	leaveq 
  803566:	c3                   	retq   

0000000000803567 <argnextvalue>:

char *
argnextvalue(struct Argstate *args)
{
  803567:	55                   	push   %rbp
  803568:	48 89 e5             	mov    %rsp,%rbp
  80356b:	53                   	push   %rbx
  80356c:	48 83 ec 18          	sub    $0x18,%rsp
  803570:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (!args->curarg)
  803574:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803578:	48 8b 40 10          	mov    0x10(%rax),%rax
  80357c:	48 85 c0             	test   %rax,%rax
  80357f:	75 0a                	jne    80358b <argnextvalue+0x24>
		return 0;
  803581:	b8 00 00 00 00       	mov    $0x0,%eax
  803586:	e9 c8 00 00 00       	jmpq   803653 <argnextvalue+0xec>
	if (*args->curarg) {
  80358b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80358f:	48 8b 40 10          	mov    0x10(%rax),%rax
  803593:	0f b6 00             	movzbl (%rax),%eax
  803596:	84 c0                	test   %al,%al
  803598:	74 27                	je     8035c1 <argnextvalue+0x5a>
		args->argvalue = args->curarg;
  80359a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80359e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8035a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035a6:	48 89 50 18          	mov    %rdx,0x18(%rax)
		args->curarg = "";
  8035aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035ae:	48 bb 66 65 80 00 00 	movabs $0x806566,%rbx
  8035b5:	00 00 00 
  8035b8:	48 89 58 10          	mov    %rbx,0x10(%rax)
  8035bc:	e9 8a 00 00 00       	jmpq   80364b <argnextvalue+0xe4>
	} else if (*args->argc > 1) {
  8035c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035c5:	48 8b 00             	mov    (%rax),%rax
  8035c8:	8b 00                	mov    (%rax),%eax
  8035ca:	83 f8 01             	cmp    $0x1,%eax
  8035cd:	7e 64                	jle    803633 <argnextvalue+0xcc>
		args->argvalue = args->argv[1];
  8035cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035d3:	48 8b 40 08          	mov    0x8(%rax),%rax
  8035d7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8035db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035df:	48 89 50 18          	mov    %rdx,0x18(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8035e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035e7:	48 8b 00             	mov    (%rax),%rax
  8035ea:	8b 00                	mov    (%rax),%eax
  8035ec:	83 e8 01             	sub    $0x1,%eax
  8035ef:	48 98                	cltq   
  8035f1:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8035f8:	00 
  8035f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035fd:	48 8b 40 08          	mov    0x8(%rax),%rax
  803601:	48 8d 48 10          	lea    0x10(%rax),%rcx
  803605:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803609:	48 8b 40 08          	mov    0x8(%rax),%rax
  80360d:	48 83 c0 08          	add    $0x8,%rax
  803611:	48 89 ce             	mov    %rcx,%rsi
  803614:	48 89 c7             	mov    %rax,%rdi
  803617:	48 b8 63 24 80 00 00 	movabs $0x802463,%rax
  80361e:	00 00 00 
  803621:	ff d0                	callq  *%rax
		(*args->argc)--;
  803623:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803627:	48 8b 00             	mov    (%rax),%rax
  80362a:	8b 10                	mov    (%rax),%edx
  80362c:	83 ea 01             	sub    $0x1,%edx
  80362f:	89 10                	mov    %edx,(%rax)
  803631:	eb 18                	jmp    80364b <argnextvalue+0xe4>
	} else {
		args->argvalue = 0;
  803633:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803637:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  80363e:	00 
		args->curarg = 0;
  80363f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803643:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  80364a:	00 
	}
	return (char*) args->argvalue;
  80364b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80364f:	48 8b 40 18          	mov    0x18(%rax),%rax
}
  803653:	48 83 c4 18          	add    $0x18,%rsp
  803657:	5b                   	pop    %rbx
  803658:	5d                   	pop    %rbp
  803659:	c3                   	retq   

000000000080365a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80365a:	55                   	push   %rbp
  80365b:	48 89 e5             	mov    %rsp,%rbp
  80365e:	48 83 ec 08          	sub    $0x8,%rsp
  803662:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  803666:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80366a:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  803671:	ff ff ff 
  803674:	48 01 d0             	add    %rdx,%rax
  803677:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80367b:	c9                   	leaveq 
  80367c:	c3                   	retq   

000000000080367d <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80367d:	55                   	push   %rbp
  80367e:	48 89 e5             	mov    %rsp,%rbp
  803681:	48 83 ec 08          	sub    $0x8,%rsp
  803685:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  803689:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80368d:	48 89 c7             	mov    %rax,%rdi
  803690:	48 b8 5a 36 80 00 00 	movabs $0x80365a,%rax
  803697:	00 00 00 
  80369a:	ff d0                	callq  *%rax
  80369c:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8036a2:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8036a6:	c9                   	leaveq 
  8036a7:	c3                   	retq   

00000000008036a8 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8036a8:	55                   	push   %rbp
  8036a9:	48 89 e5             	mov    %rsp,%rbp
  8036ac:	48 83 ec 18          	sub    $0x18,%rsp
  8036b0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8036b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8036bb:	eb 6b                	jmp    803728 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8036bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036c0:	48 98                	cltq   
  8036c2:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8036c8:	48 c1 e0 0c          	shl    $0xc,%rax
  8036cc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8036d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036d4:	48 c1 e8 15          	shr    $0x15,%rax
  8036d8:	48 89 c2             	mov    %rax,%rdx
  8036db:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8036e2:	01 00 00 
  8036e5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8036e9:	83 e0 01             	and    $0x1,%eax
  8036ec:	48 85 c0             	test   %rax,%rax
  8036ef:	74 21                	je     803712 <fd_alloc+0x6a>
  8036f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036f5:	48 c1 e8 0c          	shr    $0xc,%rax
  8036f9:	48 89 c2             	mov    %rax,%rdx
  8036fc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803703:	01 00 00 
  803706:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80370a:	83 e0 01             	and    $0x1,%eax
  80370d:	48 85 c0             	test   %rax,%rax
  803710:	75 12                	jne    803724 <fd_alloc+0x7c>
			*fd_store = fd;
  803712:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803716:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80371a:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80371d:	b8 00 00 00 00       	mov    $0x0,%eax
  803722:	eb 1a                	jmp    80373e <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  803724:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803728:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80372c:	7e 8f                	jle    8036bd <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80372e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803732:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  803739:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80373e:	c9                   	leaveq 
  80373f:	c3                   	retq   

0000000000803740 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  803740:	55                   	push   %rbp
  803741:	48 89 e5             	mov    %rsp,%rbp
  803744:	48 83 ec 20          	sub    $0x20,%rsp
  803748:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80374b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80374f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803753:	78 06                	js     80375b <fd_lookup+0x1b>
  803755:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  803759:	7e 07                	jle    803762 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80375b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803760:	eb 6c                	jmp    8037ce <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  803762:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803765:	48 98                	cltq   
  803767:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80376d:	48 c1 e0 0c          	shl    $0xc,%rax
  803771:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  803775:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803779:	48 c1 e8 15          	shr    $0x15,%rax
  80377d:	48 89 c2             	mov    %rax,%rdx
  803780:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803787:	01 00 00 
  80378a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80378e:	83 e0 01             	and    $0x1,%eax
  803791:	48 85 c0             	test   %rax,%rax
  803794:	74 21                	je     8037b7 <fd_lookup+0x77>
  803796:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80379a:	48 c1 e8 0c          	shr    $0xc,%rax
  80379e:	48 89 c2             	mov    %rax,%rdx
  8037a1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8037a8:	01 00 00 
  8037ab:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8037af:	83 e0 01             	and    $0x1,%eax
  8037b2:	48 85 c0             	test   %rax,%rax
  8037b5:	75 07                	jne    8037be <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8037b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8037bc:	eb 10                	jmp    8037ce <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8037be:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037c2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8037c6:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8037c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037ce:	c9                   	leaveq 
  8037cf:	c3                   	retq   

00000000008037d0 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8037d0:	55                   	push   %rbp
  8037d1:	48 89 e5             	mov    %rsp,%rbp
  8037d4:	48 83 ec 30          	sub    $0x30,%rsp
  8037d8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8037dc:	89 f0                	mov    %esi,%eax
  8037de:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8037e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037e5:	48 89 c7             	mov    %rax,%rdi
  8037e8:	48 b8 5a 36 80 00 00 	movabs $0x80365a,%rax
  8037ef:	00 00 00 
  8037f2:	ff d0                	callq  *%rax
  8037f4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8037f8:	48 89 d6             	mov    %rdx,%rsi
  8037fb:	89 c7                	mov    %eax,%edi
  8037fd:	48 b8 40 37 80 00 00 	movabs $0x803740,%rax
  803804:	00 00 00 
  803807:	ff d0                	callq  *%rax
  803809:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80380c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803810:	78 0a                	js     80381c <fd_close+0x4c>
	    || fd != fd2)
  803812:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803816:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80381a:	74 12                	je     80382e <fd_close+0x5e>
		return (must_exist ? r : 0);
  80381c:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  803820:	74 05                	je     803827 <fd_close+0x57>
  803822:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803825:	eb 05                	jmp    80382c <fd_close+0x5c>
  803827:	b8 00 00 00 00       	mov    $0x0,%eax
  80382c:	eb 69                	jmp    803897 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80382e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803832:	8b 00                	mov    (%rax),%eax
  803834:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803838:	48 89 d6             	mov    %rdx,%rsi
  80383b:	89 c7                	mov    %eax,%edi
  80383d:	48 b8 99 38 80 00 00 	movabs $0x803899,%rax
  803844:	00 00 00 
  803847:	ff d0                	callq  *%rax
  803849:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80384c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803850:	78 2a                	js     80387c <fd_close+0xac>
		if (dev->dev_close)
  803852:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803856:	48 8b 40 20          	mov    0x20(%rax),%rax
  80385a:	48 85 c0             	test   %rax,%rax
  80385d:	74 16                	je     803875 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  80385f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803863:	48 8b 40 20          	mov    0x20(%rax),%rax
  803867:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80386b:	48 89 d7             	mov    %rdx,%rdi
  80386e:	ff d0                	callq  *%rax
  803870:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803873:	eb 07                	jmp    80387c <fd_close+0xac>
		else
			r = 0;
  803875:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80387c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803880:	48 89 c6             	mov    %rax,%rsi
  803883:	bf 00 00 00 00       	mov    $0x0,%edi
  803888:	48 b8 19 2b 80 00 00 	movabs $0x802b19,%rax
  80388f:	00 00 00 
  803892:	ff d0                	callq  *%rax
	return r;
  803894:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803897:	c9                   	leaveq 
  803898:	c3                   	retq   

0000000000803899 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  803899:	55                   	push   %rbp
  80389a:	48 89 e5             	mov    %rsp,%rbp
  80389d:	48 83 ec 20          	sub    $0x20,%rsp
  8038a1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8038a4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8038a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8038af:	eb 41                	jmp    8038f2 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8038b1:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  8038b8:	00 00 00 
  8038bb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8038be:	48 63 d2             	movslq %edx,%rdx
  8038c1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8038c5:	8b 00                	mov    (%rax),%eax
  8038c7:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8038ca:	75 22                	jne    8038ee <dev_lookup+0x55>
			*dev = devtab[i];
  8038cc:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  8038d3:	00 00 00 
  8038d6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8038d9:	48 63 d2             	movslq %edx,%rdx
  8038dc:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8038e0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038e4:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8038e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8038ec:	eb 60                	jmp    80394e <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8038ee:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8038f2:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  8038f9:	00 00 00 
  8038fc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8038ff:	48 63 d2             	movslq %edx,%rdx
  803902:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803906:	48 85 c0             	test   %rax,%rax
  803909:	75 a6                	jne    8038b1 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80390b:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  803912:	00 00 00 
  803915:	48 8b 00             	mov    (%rax),%rax
  803918:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80391e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803921:	89 c6                	mov    %eax,%esi
  803923:	48 bf 68 65 80 00 00 	movabs $0x806568,%rdi
  80392a:	00 00 00 
  80392d:	b8 00 00 00 00       	mov    $0x0,%eax
  803932:	48 b9 30 14 80 00 00 	movabs $0x801430,%rcx
  803939:	00 00 00 
  80393c:	ff d1                	callq  *%rcx
	*dev = 0;
  80393e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803942:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  803949:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80394e:	c9                   	leaveq 
  80394f:	c3                   	retq   

0000000000803950 <close>:

int
close(int fdnum)
{
  803950:	55                   	push   %rbp
  803951:	48 89 e5             	mov    %rsp,%rbp
  803954:	48 83 ec 20          	sub    $0x20,%rsp
  803958:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80395b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80395f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803962:	48 89 d6             	mov    %rdx,%rsi
  803965:	89 c7                	mov    %eax,%edi
  803967:	48 b8 40 37 80 00 00 	movabs $0x803740,%rax
  80396e:	00 00 00 
  803971:	ff d0                	callq  *%rax
  803973:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803976:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80397a:	79 05                	jns    803981 <close+0x31>
		return r;
  80397c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80397f:	eb 18                	jmp    803999 <close+0x49>
	else
		return fd_close(fd, 1);
  803981:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803985:	be 01 00 00 00       	mov    $0x1,%esi
  80398a:	48 89 c7             	mov    %rax,%rdi
  80398d:	48 b8 d0 37 80 00 00 	movabs $0x8037d0,%rax
  803994:	00 00 00 
  803997:	ff d0                	callq  *%rax
}
  803999:	c9                   	leaveq 
  80399a:	c3                   	retq   

000000000080399b <close_all>:

void
close_all(void)
{
  80399b:	55                   	push   %rbp
  80399c:	48 89 e5             	mov    %rsp,%rbp
  80399f:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8039a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8039aa:	eb 15                	jmp    8039c1 <close_all+0x26>
		close(i);
  8039ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039af:	89 c7                	mov    %eax,%edi
  8039b1:	48 b8 50 39 80 00 00 	movabs $0x803950,%rax
  8039b8:	00 00 00 
  8039bb:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8039bd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8039c1:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8039c5:	7e e5                	jle    8039ac <close_all+0x11>
		close(i);
}
  8039c7:	c9                   	leaveq 
  8039c8:	c3                   	retq   

00000000008039c9 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8039c9:	55                   	push   %rbp
  8039ca:	48 89 e5             	mov    %rsp,%rbp
  8039cd:	48 83 ec 40          	sub    $0x40,%rsp
  8039d1:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8039d4:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8039d7:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8039db:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8039de:	48 89 d6             	mov    %rdx,%rsi
  8039e1:	89 c7                	mov    %eax,%edi
  8039e3:	48 b8 40 37 80 00 00 	movabs $0x803740,%rax
  8039ea:	00 00 00 
  8039ed:	ff d0                	callq  *%rax
  8039ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039f6:	79 08                	jns    803a00 <dup+0x37>
		return r;
  8039f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039fb:	e9 70 01 00 00       	jmpq   803b70 <dup+0x1a7>
	close(newfdnum);
  803a00:	8b 45 c8             	mov    -0x38(%rbp),%eax
  803a03:	89 c7                	mov    %eax,%edi
  803a05:	48 b8 50 39 80 00 00 	movabs $0x803950,%rax
  803a0c:	00 00 00 
  803a0f:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  803a11:	8b 45 c8             	mov    -0x38(%rbp),%eax
  803a14:	48 98                	cltq   
  803a16:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  803a1c:	48 c1 e0 0c          	shl    $0xc,%rax
  803a20:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  803a24:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a28:	48 89 c7             	mov    %rax,%rdi
  803a2b:	48 b8 7d 36 80 00 00 	movabs $0x80367d,%rax
  803a32:	00 00 00 
  803a35:	ff d0                	callq  *%rax
  803a37:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  803a3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a3f:	48 89 c7             	mov    %rax,%rdi
  803a42:	48 b8 7d 36 80 00 00 	movabs $0x80367d,%rax
  803a49:	00 00 00 
  803a4c:	ff d0                	callq  *%rax
  803a4e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  803a52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a56:	48 c1 e8 15          	shr    $0x15,%rax
  803a5a:	48 89 c2             	mov    %rax,%rdx
  803a5d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803a64:	01 00 00 
  803a67:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803a6b:	83 e0 01             	and    $0x1,%eax
  803a6e:	48 85 c0             	test   %rax,%rax
  803a71:	74 73                	je     803ae6 <dup+0x11d>
  803a73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a77:	48 c1 e8 0c          	shr    $0xc,%rax
  803a7b:	48 89 c2             	mov    %rax,%rdx
  803a7e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803a85:	01 00 00 
  803a88:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803a8c:	83 e0 01             	and    $0x1,%eax
  803a8f:	48 85 c0             	test   %rax,%rax
  803a92:	74 52                	je     803ae6 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  803a94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a98:	48 c1 e8 0c          	shr    $0xc,%rax
  803a9c:	48 89 c2             	mov    %rax,%rdx
  803a9f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803aa6:	01 00 00 
  803aa9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803aad:	25 07 0e 00 00       	and    $0xe07,%eax
  803ab2:	89 c1                	mov    %eax,%ecx
  803ab4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803ab8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803abc:	41 89 c8             	mov    %ecx,%r8d
  803abf:	48 89 d1             	mov    %rdx,%rcx
  803ac2:	ba 00 00 00 00       	mov    $0x0,%edx
  803ac7:	48 89 c6             	mov    %rax,%rsi
  803aca:	bf 00 00 00 00       	mov    $0x0,%edi
  803acf:	48 b8 be 2a 80 00 00 	movabs $0x802abe,%rax
  803ad6:	00 00 00 
  803ad9:	ff d0                	callq  *%rax
  803adb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ade:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ae2:	79 02                	jns    803ae6 <dup+0x11d>
			goto err;
  803ae4:	eb 57                	jmp    803b3d <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  803ae6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803aea:	48 c1 e8 0c          	shr    $0xc,%rax
  803aee:	48 89 c2             	mov    %rax,%rdx
  803af1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803af8:	01 00 00 
  803afb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803aff:	25 07 0e 00 00       	and    $0xe07,%eax
  803b04:	89 c1                	mov    %eax,%ecx
  803b06:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b0a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b0e:	41 89 c8             	mov    %ecx,%r8d
  803b11:	48 89 d1             	mov    %rdx,%rcx
  803b14:	ba 00 00 00 00       	mov    $0x0,%edx
  803b19:	48 89 c6             	mov    %rax,%rsi
  803b1c:	bf 00 00 00 00       	mov    $0x0,%edi
  803b21:	48 b8 be 2a 80 00 00 	movabs $0x802abe,%rax
  803b28:	00 00 00 
  803b2b:	ff d0                	callq  *%rax
  803b2d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b30:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b34:	79 02                	jns    803b38 <dup+0x16f>
		goto err;
  803b36:	eb 05                	jmp    803b3d <dup+0x174>

	return newfdnum;
  803b38:	8b 45 c8             	mov    -0x38(%rbp),%eax
  803b3b:	eb 33                	jmp    803b70 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  803b3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b41:	48 89 c6             	mov    %rax,%rsi
  803b44:	bf 00 00 00 00       	mov    $0x0,%edi
  803b49:	48 b8 19 2b 80 00 00 	movabs $0x802b19,%rax
  803b50:	00 00 00 
  803b53:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  803b55:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b59:	48 89 c6             	mov    %rax,%rsi
  803b5c:	bf 00 00 00 00       	mov    $0x0,%edi
  803b61:	48 b8 19 2b 80 00 00 	movabs $0x802b19,%rax
  803b68:	00 00 00 
  803b6b:	ff d0                	callq  *%rax
	return r;
  803b6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803b70:	c9                   	leaveq 
  803b71:	c3                   	retq   

0000000000803b72 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  803b72:	55                   	push   %rbp
  803b73:	48 89 e5             	mov    %rsp,%rbp
  803b76:	48 83 ec 40          	sub    $0x40,%rsp
  803b7a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803b7d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803b81:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803b85:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803b89:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803b8c:	48 89 d6             	mov    %rdx,%rsi
  803b8f:	89 c7                	mov    %eax,%edi
  803b91:	48 b8 40 37 80 00 00 	movabs $0x803740,%rax
  803b98:	00 00 00 
  803b9b:	ff d0                	callq  *%rax
  803b9d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ba0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ba4:	78 24                	js     803bca <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803ba6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803baa:	8b 00                	mov    (%rax),%eax
  803bac:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803bb0:	48 89 d6             	mov    %rdx,%rsi
  803bb3:	89 c7                	mov    %eax,%edi
  803bb5:	48 b8 99 38 80 00 00 	movabs $0x803899,%rax
  803bbc:	00 00 00 
  803bbf:	ff d0                	callq  *%rax
  803bc1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bc4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bc8:	79 05                	jns    803bcf <read+0x5d>
		return r;
  803bca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bcd:	eb 76                	jmp    803c45 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  803bcf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bd3:	8b 40 08             	mov    0x8(%rax),%eax
  803bd6:	83 e0 03             	and    $0x3,%eax
  803bd9:	83 f8 01             	cmp    $0x1,%eax
  803bdc:	75 3a                	jne    803c18 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  803bde:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  803be5:	00 00 00 
  803be8:	48 8b 00             	mov    (%rax),%rax
  803beb:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803bf1:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803bf4:	89 c6                	mov    %eax,%esi
  803bf6:	48 bf 87 65 80 00 00 	movabs $0x806587,%rdi
  803bfd:	00 00 00 
  803c00:	b8 00 00 00 00       	mov    $0x0,%eax
  803c05:	48 b9 30 14 80 00 00 	movabs $0x801430,%rcx
  803c0c:	00 00 00 
  803c0f:	ff d1                	callq  *%rcx
		return -E_INVAL;
  803c11:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803c16:	eb 2d                	jmp    803c45 <read+0xd3>
	}
	if (!dev->dev_read)
  803c18:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c1c:	48 8b 40 10          	mov    0x10(%rax),%rax
  803c20:	48 85 c0             	test   %rax,%rax
  803c23:	75 07                	jne    803c2c <read+0xba>
		return -E_NOT_SUPP;
  803c25:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803c2a:	eb 19                	jmp    803c45 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  803c2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c30:	48 8b 40 10          	mov    0x10(%rax),%rax
  803c34:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803c38:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803c3c:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803c40:	48 89 cf             	mov    %rcx,%rdi
  803c43:	ff d0                	callq  *%rax
}
  803c45:	c9                   	leaveq 
  803c46:	c3                   	retq   

0000000000803c47 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  803c47:	55                   	push   %rbp
  803c48:	48 89 e5             	mov    %rsp,%rbp
  803c4b:	48 83 ec 30          	sub    $0x30,%rsp
  803c4f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803c52:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c56:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803c5a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803c61:	eb 49                	jmp    803cac <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  803c63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c66:	48 98                	cltq   
  803c68:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803c6c:	48 29 c2             	sub    %rax,%rdx
  803c6f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c72:	48 63 c8             	movslq %eax,%rcx
  803c75:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c79:	48 01 c1             	add    %rax,%rcx
  803c7c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c7f:	48 89 ce             	mov    %rcx,%rsi
  803c82:	89 c7                	mov    %eax,%edi
  803c84:	48 b8 72 3b 80 00 00 	movabs $0x803b72,%rax
  803c8b:	00 00 00 
  803c8e:	ff d0                	callq  *%rax
  803c90:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  803c93:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803c97:	79 05                	jns    803c9e <readn+0x57>
			return m;
  803c99:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c9c:	eb 1c                	jmp    803cba <readn+0x73>
		if (m == 0)
  803c9e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803ca2:	75 02                	jne    803ca6 <readn+0x5f>
			break;
  803ca4:	eb 11                	jmp    803cb7 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803ca6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ca9:	01 45 fc             	add    %eax,-0x4(%rbp)
  803cac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803caf:	48 98                	cltq   
  803cb1:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803cb5:	72 ac                	jb     803c63 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  803cb7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803cba:	c9                   	leaveq 
  803cbb:	c3                   	retq   

0000000000803cbc <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  803cbc:	55                   	push   %rbp
  803cbd:	48 89 e5             	mov    %rsp,%rbp
  803cc0:	48 83 ec 40          	sub    $0x40,%rsp
  803cc4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803cc7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803ccb:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803ccf:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803cd3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803cd6:	48 89 d6             	mov    %rdx,%rsi
  803cd9:	89 c7                	mov    %eax,%edi
  803cdb:	48 b8 40 37 80 00 00 	movabs $0x803740,%rax
  803ce2:	00 00 00 
  803ce5:	ff d0                	callq  *%rax
  803ce7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cee:	78 24                	js     803d14 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803cf0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cf4:	8b 00                	mov    (%rax),%eax
  803cf6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803cfa:	48 89 d6             	mov    %rdx,%rsi
  803cfd:	89 c7                	mov    %eax,%edi
  803cff:	48 b8 99 38 80 00 00 	movabs $0x803899,%rax
  803d06:	00 00 00 
  803d09:	ff d0                	callq  *%rax
  803d0b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d0e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d12:	79 05                	jns    803d19 <write+0x5d>
		return r;
  803d14:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d17:	eb 75                	jmp    803d8e <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803d19:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d1d:	8b 40 08             	mov    0x8(%rax),%eax
  803d20:	83 e0 03             	and    $0x3,%eax
  803d23:	85 c0                	test   %eax,%eax
  803d25:	75 3a                	jne    803d61 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  803d27:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  803d2e:	00 00 00 
  803d31:	48 8b 00             	mov    (%rax),%rax
  803d34:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803d3a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803d3d:	89 c6                	mov    %eax,%esi
  803d3f:	48 bf a3 65 80 00 00 	movabs $0x8065a3,%rdi
  803d46:	00 00 00 
  803d49:	b8 00 00 00 00       	mov    $0x0,%eax
  803d4e:	48 b9 30 14 80 00 00 	movabs $0x801430,%rcx
  803d55:	00 00 00 
  803d58:	ff d1                	callq  *%rcx
		return -E_INVAL;
  803d5a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803d5f:	eb 2d                	jmp    803d8e <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  803d61:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d65:	48 8b 40 18          	mov    0x18(%rax),%rax
  803d69:	48 85 c0             	test   %rax,%rax
  803d6c:	75 07                	jne    803d75 <write+0xb9>
		return -E_NOT_SUPP;
  803d6e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803d73:	eb 19                	jmp    803d8e <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  803d75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d79:	48 8b 40 18          	mov    0x18(%rax),%rax
  803d7d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803d81:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803d85:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803d89:	48 89 cf             	mov    %rcx,%rdi
  803d8c:	ff d0                	callq  *%rax
}
  803d8e:	c9                   	leaveq 
  803d8f:	c3                   	retq   

0000000000803d90 <seek>:

int
seek(int fdnum, off_t offset)
{
  803d90:	55                   	push   %rbp
  803d91:	48 89 e5             	mov    %rsp,%rbp
  803d94:	48 83 ec 18          	sub    $0x18,%rsp
  803d98:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d9b:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803d9e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803da2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803da5:	48 89 d6             	mov    %rdx,%rsi
  803da8:	89 c7                	mov    %eax,%edi
  803daa:	48 b8 40 37 80 00 00 	movabs $0x803740,%rax
  803db1:	00 00 00 
  803db4:	ff d0                	callq  *%rax
  803db6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803db9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dbd:	79 05                	jns    803dc4 <seek+0x34>
		return r;
  803dbf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dc2:	eb 0f                	jmp    803dd3 <seek+0x43>
	fd->fd_offset = offset;
  803dc4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dc8:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803dcb:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  803dce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803dd3:	c9                   	leaveq 
  803dd4:	c3                   	retq   

0000000000803dd5 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  803dd5:	55                   	push   %rbp
  803dd6:	48 89 e5             	mov    %rsp,%rbp
  803dd9:	48 83 ec 30          	sub    $0x30,%rsp
  803ddd:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803de0:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  803de3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803de7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803dea:	48 89 d6             	mov    %rdx,%rsi
  803ded:	89 c7                	mov    %eax,%edi
  803def:	48 b8 40 37 80 00 00 	movabs $0x803740,%rax
  803df6:	00 00 00 
  803df9:	ff d0                	callq  *%rax
  803dfb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803dfe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e02:	78 24                	js     803e28 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803e04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e08:	8b 00                	mov    (%rax),%eax
  803e0a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803e0e:	48 89 d6             	mov    %rdx,%rsi
  803e11:	89 c7                	mov    %eax,%edi
  803e13:	48 b8 99 38 80 00 00 	movabs $0x803899,%rax
  803e1a:	00 00 00 
  803e1d:	ff d0                	callq  *%rax
  803e1f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e22:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e26:	79 05                	jns    803e2d <ftruncate+0x58>
		return r;
  803e28:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e2b:	eb 72                	jmp    803e9f <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803e2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e31:	8b 40 08             	mov    0x8(%rax),%eax
  803e34:	83 e0 03             	and    $0x3,%eax
  803e37:	85 c0                	test   %eax,%eax
  803e39:	75 3a                	jne    803e75 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  803e3b:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  803e42:	00 00 00 
  803e45:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  803e48:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803e4e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803e51:	89 c6                	mov    %eax,%esi
  803e53:	48 bf c0 65 80 00 00 	movabs $0x8065c0,%rdi
  803e5a:	00 00 00 
  803e5d:	b8 00 00 00 00       	mov    $0x0,%eax
  803e62:	48 b9 30 14 80 00 00 	movabs $0x801430,%rcx
  803e69:	00 00 00 
  803e6c:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  803e6e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803e73:	eb 2a                	jmp    803e9f <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  803e75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e79:	48 8b 40 30          	mov    0x30(%rax),%rax
  803e7d:	48 85 c0             	test   %rax,%rax
  803e80:	75 07                	jne    803e89 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  803e82:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803e87:	eb 16                	jmp    803e9f <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  803e89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e8d:	48 8b 40 30          	mov    0x30(%rax),%rax
  803e91:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803e95:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  803e98:	89 ce                	mov    %ecx,%esi
  803e9a:	48 89 d7             	mov    %rdx,%rdi
  803e9d:	ff d0                	callq  *%rax
}
  803e9f:	c9                   	leaveq 
  803ea0:	c3                   	retq   

0000000000803ea1 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  803ea1:	55                   	push   %rbp
  803ea2:	48 89 e5             	mov    %rsp,%rbp
  803ea5:	48 83 ec 30          	sub    $0x30,%rsp
  803ea9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803eac:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803eb0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803eb4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803eb7:	48 89 d6             	mov    %rdx,%rsi
  803eba:	89 c7                	mov    %eax,%edi
  803ebc:	48 b8 40 37 80 00 00 	movabs $0x803740,%rax
  803ec3:	00 00 00 
  803ec6:	ff d0                	callq  *%rax
  803ec8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ecb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ecf:	78 24                	js     803ef5 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803ed1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ed5:	8b 00                	mov    (%rax),%eax
  803ed7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803edb:	48 89 d6             	mov    %rdx,%rsi
  803ede:	89 c7                	mov    %eax,%edi
  803ee0:	48 b8 99 38 80 00 00 	movabs $0x803899,%rax
  803ee7:	00 00 00 
  803eea:	ff d0                	callq  *%rax
  803eec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803eef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ef3:	79 05                	jns    803efa <fstat+0x59>
		return r;
  803ef5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ef8:	eb 5e                	jmp    803f58 <fstat+0xb7>
	if (!dev->dev_stat)
  803efa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803efe:	48 8b 40 28          	mov    0x28(%rax),%rax
  803f02:	48 85 c0             	test   %rax,%rax
  803f05:	75 07                	jne    803f0e <fstat+0x6d>
		return -E_NOT_SUPP;
  803f07:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803f0c:	eb 4a                	jmp    803f58 <fstat+0xb7>
	stat->st_name[0] = 0;
  803f0e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f12:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  803f15:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f19:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  803f20:	00 00 00 
	stat->st_isdir = 0;
  803f23:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f27:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803f2e:	00 00 00 
	stat->st_dev = dev;
  803f31:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803f35:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f39:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  803f40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f44:	48 8b 40 28          	mov    0x28(%rax),%rax
  803f48:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803f4c:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803f50:	48 89 ce             	mov    %rcx,%rsi
  803f53:	48 89 d7             	mov    %rdx,%rdi
  803f56:	ff d0                	callq  *%rax
}
  803f58:	c9                   	leaveq 
  803f59:	c3                   	retq   

0000000000803f5a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  803f5a:	55                   	push   %rbp
  803f5b:	48 89 e5             	mov    %rsp,%rbp
  803f5e:	48 83 ec 20          	sub    $0x20,%rsp
  803f62:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803f66:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  803f6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f6e:	be 00 00 00 00       	mov    $0x0,%esi
  803f73:	48 89 c7             	mov    %rax,%rdi
  803f76:	48 b8 48 40 80 00 00 	movabs $0x804048,%rax
  803f7d:	00 00 00 
  803f80:	ff d0                	callq  *%rax
  803f82:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f85:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f89:	79 05                	jns    803f90 <stat+0x36>
		return fd;
  803f8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f8e:	eb 2f                	jmp    803fbf <stat+0x65>
	r = fstat(fd, stat);
  803f90:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803f94:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f97:	48 89 d6             	mov    %rdx,%rsi
  803f9a:	89 c7                	mov    %eax,%edi
  803f9c:	48 b8 a1 3e 80 00 00 	movabs $0x803ea1,%rax
  803fa3:	00 00 00 
  803fa6:	ff d0                	callq  *%rax
  803fa8:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  803fab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fae:	89 c7                	mov    %eax,%edi
  803fb0:	48 b8 50 39 80 00 00 	movabs $0x803950,%rax
  803fb7:	00 00 00 
  803fba:	ff d0                	callq  *%rax
	return r;
  803fbc:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  803fbf:	c9                   	leaveq 
  803fc0:	c3                   	retq   

0000000000803fc1 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  803fc1:	55                   	push   %rbp
  803fc2:	48 89 e5             	mov    %rsp,%rbp
  803fc5:	48 83 ec 10          	sub    $0x10,%rsp
  803fc9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803fcc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  803fd0:	48 b8 20 94 80 00 00 	movabs $0x809420,%rax
  803fd7:	00 00 00 
  803fda:	8b 00                	mov    (%rax),%eax
  803fdc:	85 c0                	test   %eax,%eax
  803fde:	75 1d                	jne    803ffd <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  803fe0:	bf 01 00 00 00       	mov    $0x1,%edi
  803fe5:	48 b8 e9 5b 80 00 00 	movabs $0x805be9,%rax
  803fec:	00 00 00 
  803fef:	ff d0                	callq  *%rax
  803ff1:	48 ba 20 94 80 00 00 	movabs $0x809420,%rdx
  803ff8:	00 00 00 
  803ffb:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803ffd:	48 b8 20 94 80 00 00 	movabs $0x809420,%rax
  804004:	00 00 00 
  804007:	8b 00                	mov    (%rax),%eax
  804009:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80400c:	b9 07 00 00 00       	mov    $0x7,%ecx
  804011:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  804018:	00 00 00 
  80401b:	89 c7                	mov    %eax,%edi
  80401d:	48 b8 87 5b 80 00 00 	movabs $0x805b87,%rax
  804024:	00 00 00 
  804027:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  804029:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80402d:	ba 00 00 00 00       	mov    $0x0,%edx
  804032:	48 89 c6             	mov    %rax,%rsi
  804035:	bf 00 00 00 00       	mov    $0x0,%edi
  80403a:	48 b8 81 5a 80 00 00 	movabs $0x805a81,%rax
  804041:	00 00 00 
  804044:	ff d0                	callq  *%rax
}
  804046:	c9                   	leaveq 
  804047:	c3                   	retq   

0000000000804048 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  804048:	55                   	push   %rbp
  804049:	48 89 e5             	mov    %rsp,%rbp
  80404c:	48 83 ec 30          	sub    $0x30,%rsp
  804050:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804054:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  804057:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  80405e:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  804065:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  80406c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804071:	75 08                	jne    80407b <open+0x33>
	{
		return r;
  804073:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804076:	e9 f2 00 00 00       	jmpq   80416d <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  80407b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80407f:	48 89 c7             	mov    %rax,%rdi
  804082:	48 b8 d3 20 80 00 00 	movabs $0x8020d3,%rax
  804089:	00 00 00 
  80408c:	ff d0                	callq  *%rax
  80408e:	89 45 f4             	mov    %eax,-0xc(%rbp)
  804091:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  804098:	7e 0a                	jle    8040a4 <open+0x5c>
	{
		return -E_BAD_PATH;
  80409a:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80409f:	e9 c9 00 00 00       	jmpq   80416d <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  8040a4:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8040ab:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  8040ac:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8040b0:	48 89 c7             	mov    %rax,%rdi
  8040b3:	48 b8 a8 36 80 00 00 	movabs $0x8036a8,%rax
  8040ba:	00 00 00 
  8040bd:	ff d0                	callq  *%rax
  8040bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040c6:	78 09                	js     8040d1 <open+0x89>
  8040c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040cc:	48 85 c0             	test   %rax,%rax
  8040cf:	75 08                	jne    8040d9 <open+0x91>
		{
			return r;
  8040d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040d4:	e9 94 00 00 00       	jmpq   80416d <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  8040d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040dd:	ba 00 04 00 00       	mov    $0x400,%edx
  8040e2:	48 89 c6             	mov    %rax,%rsi
  8040e5:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  8040ec:	00 00 00 
  8040ef:	48 b8 d1 21 80 00 00 	movabs $0x8021d1,%rax
  8040f6:	00 00 00 
  8040f9:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  8040fb:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  804102:	00 00 00 
  804105:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  804108:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  80410e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804112:	48 89 c6             	mov    %rax,%rsi
  804115:	bf 01 00 00 00       	mov    $0x1,%edi
  80411a:	48 b8 c1 3f 80 00 00 	movabs $0x803fc1,%rax
  804121:	00 00 00 
  804124:	ff d0                	callq  *%rax
  804126:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804129:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80412d:	79 2b                	jns    80415a <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  80412f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804133:	be 00 00 00 00       	mov    $0x0,%esi
  804138:	48 89 c7             	mov    %rax,%rdi
  80413b:	48 b8 d0 37 80 00 00 	movabs $0x8037d0,%rax
  804142:	00 00 00 
  804145:	ff d0                	callq  *%rax
  804147:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80414a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80414e:	79 05                	jns    804155 <open+0x10d>
			{
				return d;
  804150:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804153:	eb 18                	jmp    80416d <open+0x125>
			}
			return r;
  804155:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804158:	eb 13                	jmp    80416d <open+0x125>
		}	
		return fd2num(fd_store);
  80415a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80415e:	48 89 c7             	mov    %rax,%rdi
  804161:	48 b8 5a 36 80 00 00 	movabs $0x80365a,%rax
  804168:	00 00 00 
  80416b:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  80416d:	c9                   	leaveq 
  80416e:	c3                   	retq   

000000000080416f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80416f:	55                   	push   %rbp
  804170:	48 89 e5             	mov    %rsp,%rbp
  804173:	48 83 ec 10          	sub    $0x10,%rsp
  804177:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80417b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80417f:	8b 50 0c             	mov    0xc(%rax),%edx
  804182:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  804189:	00 00 00 
  80418c:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80418e:	be 00 00 00 00       	mov    $0x0,%esi
  804193:	bf 06 00 00 00       	mov    $0x6,%edi
  804198:	48 b8 c1 3f 80 00 00 	movabs $0x803fc1,%rax
  80419f:	00 00 00 
  8041a2:	ff d0                	callq  *%rax
}
  8041a4:	c9                   	leaveq 
  8041a5:	c3                   	retq   

00000000008041a6 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8041a6:	55                   	push   %rbp
  8041a7:	48 89 e5             	mov    %rsp,%rbp
  8041aa:	48 83 ec 30          	sub    $0x30,%rsp
  8041ae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8041b2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8041b6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  8041ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  8041c1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8041c6:	74 07                	je     8041cf <devfile_read+0x29>
  8041c8:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8041cd:	75 07                	jne    8041d6 <devfile_read+0x30>
		return -E_INVAL;
  8041cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8041d4:	eb 77                	jmp    80424d <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8041d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041da:	8b 50 0c             	mov    0xc(%rax),%edx
  8041dd:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8041e4:	00 00 00 
  8041e7:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8041e9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8041f0:	00 00 00 
  8041f3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8041f7:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  8041fb:	be 00 00 00 00       	mov    $0x0,%esi
  804200:	bf 03 00 00 00       	mov    $0x3,%edi
  804205:	48 b8 c1 3f 80 00 00 	movabs $0x803fc1,%rax
  80420c:	00 00 00 
  80420f:	ff d0                	callq  *%rax
  804211:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804214:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804218:	7f 05                	jg     80421f <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  80421a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80421d:	eb 2e                	jmp    80424d <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  80421f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804222:	48 63 d0             	movslq %eax,%rdx
  804225:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804229:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  804230:	00 00 00 
  804233:	48 89 c7             	mov    %rax,%rdi
  804236:	48 b8 63 24 80 00 00 	movabs $0x802463,%rax
  80423d:	00 00 00 
  804240:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  804242:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804246:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  80424a:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  80424d:	c9                   	leaveq 
  80424e:	c3                   	retq   

000000000080424f <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80424f:	55                   	push   %rbp
  804250:	48 89 e5             	mov    %rsp,%rbp
  804253:	48 83 ec 30          	sub    $0x30,%rsp
  804257:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80425b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80425f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  804263:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  80426a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80426f:	74 07                	je     804278 <devfile_write+0x29>
  804271:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804276:	75 08                	jne    804280 <devfile_write+0x31>
		return r;
  804278:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80427b:	e9 9a 00 00 00       	jmpq   80431a <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  804280:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804284:	8b 50 0c             	mov    0xc(%rax),%edx
  804287:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80428e:	00 00 00 
  804291:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  804293:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  80429a:	00 
  80429b:	76 08                	jbe    8042a5 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  80429d:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8042a4:	00 
	}
	fsipcbuf.write.req_n = n;
  8042a5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8042ac:	00 00 00 
  8042af:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8042b3:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  8042b7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8042bb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8042bf:	48 89 c6             	mov    %rax,%rsi
  8042c2:	48 bf 10 a0 80 00 00 	movabs $0x80a010,%rdi
  8042c9:	00 00 00 
  8042cc:	48 b8 63 24 80 00 00 	movabs $0x802463,%rax
  8042d3:	00 00 00 
  8042d6:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  8042d8:	be 00 00 00 00       	mov    $0x0,%esi
  8042dd:	bf 04 00 00 00       	mov    $0x4,%edi
  8042e2:	48 b8 c1 3f 80 00 00 	movabs $0x803fc1,%rax
  8042e9:	00 00 00 
  8042ec:	ff d0                	callq  *%rax
  8042ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8042f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042f5:	7f 20                	jg     804317 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  8042f7:	48 bf e6 65 80 00 00 	movabs $0x8065e6,%rdi
  8042fe:	00 00 00 
  804301:	b8 00 00 00 00       	mov    $0x0,%eax
  804306:	48 ba 30 14 80 00 00 	movabs $0x801430,%rdx
  80430d:	00 00 00 
  804310:	ff d2                	callq  *%rdx
		return r;
  804312:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804315:	eb 03                	jmp    80431a <devfile_write+0xcb>
	}
	return r;
  804317:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  80431a:	c9                   	leaveq 
  80431b:	c3                   	retq   

000000000080431c <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80431c:	55                   	push   %rbp
  80431d:	48 89 e5             	mov    %rsp,%rbp
  804320:	48 83 ec 20          	sub    $0x20,%rsp
  804324:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804328:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80432c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804330:	8b 50 0c             	mov    0xc(%rax),%edx
  804333:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80433a:	00 00 00 
  80433d:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80433f:	be 00 00 00 00       	mov    $0x0,%esi
  804344:	bf 05 00 00 00       	mov    $0x5,%edi
  804349:	48 b8 c1 3f 80 00 00 	movabs $0x803fc1,%rax
  804350:	00 00 00 
  804353:	ff d0                	callq  *%rax
  804355:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804358:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80435c:	79 05                	jns    804363 <devfile_stat+0x47>
		return r;
  80435e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804361:	eb 56                	jmp    8043b9 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  804363:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804367:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  80436e:	00 00 00 
  804371:	48 89 c7             	mov    %rax,%rdi
  804374:	48 b8 3f 21 80 00 00 	movabs $0x80213f,%rax
  80437b:	00 00 00 
  80437e:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  804380:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  804387:	00 00 00 
  80438a:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  804390:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804394:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80439a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8043a1:	00 00 00 
  8043a4:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8043aa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043ae:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8043b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8043b9:	c9                   	leaveq 
  8043ba:	c3                   	retq   

00000000008043bb <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8043bb:	55                   	push   %rbp
  8043bc:	48 89 e5             	mov    %rsp,%rbp
  8043bf:	48 83 ec 10          	sub    $0x10,%rsp
  8043c3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8043c7:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8043ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043ce:	8b 50 0c             	mov    0xc(%rax),%edx
  8043d1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8043d8:	00 00 00 
  8043db:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8043dd:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8043e4:	00 00 00 
  8043e7:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8043ea:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8043ed:	be 00 00 00 00       	mov    $0x0,%esi
  8043f2:	bf 02 00 00 00       	mov    $0x2,%edi
  8043f7:	48 b8 c1 3f 80 00 00 	movabs $0x803fc1,%rax
  8043fe:	00 00 00 
  804401:	ff d0                	callq  *%rax
}
  804403:	c9                   	leaveq 
  804404:	c3                   	retq   

0000000000804405 <remove>:

// Delete a file
int
remove(const char *path)
{
  804405:	55                   	push   %rbp
  804406:	48 89 e5             	mov    %rsp,%rbp
  804409:	48 83 ec 10          	sub    $0x10,%rsp
  80440d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  804411:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804415:	48 89 c7             	mov    %rax,%rdi
  804418:	48 b8 d3 20 80 00 00 	movabs $0x8020d3,%rax
  80441f:	00 00 00 
  804422:	ff d0                	callq  *%rax
  804424:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  804429:	7e 07                	jle    804432 <remove+0x2d>
		return -E_BAD_PATH;
  80442b:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  804430:	eb 33                	jmp    804465 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  804432:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804436:	48 89 c6             	mov    %rax,%rsi
  804439:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  804440:	00 00 00 
  804443:	48 b8 3f 21 80 00 00 	movabs $0x80213f,%rax
  80444a:	00 00 00 
  80444d:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80444f:	be 00 00 00 00       	mov    $0x0,%esi
  804454:	bf 07 00 00 00       	mov    $0x7,%edi
  804459:	48 b8 c1 3f 80 00 00 	movabs $0x803fc1,%rax
  804460:	00 00 00 
  804463:	ff d0                	callq  *%rax
}
  804465:	c9                   	leaveq 
  804466:	c3                   	retq   

0000000000804467 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  804467:	55                   	push   %rbp
  804468:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80446b:	be 00 00 00 00       	mov    $0x0,%esi
  804470:	bf 08 00 00 00       	mov    $0x8,%edi
  804475:	48 b8 c1 3f 80 00 00 	movabs $0x803fc1,%rax
  80447c:	00 00 00 
  80447f:	ff d0                	callq  *%rax
}
  804481:	5d                   	pop    %rbp
  804482:	c3                   	retq   

0000000000804483 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  804483:	55                   	push   %rbp
  804484:	48 89 e5             	mov    %rsp,%rbp
  804487:	48 83 ec 20          	sub    $0x20,%rsp
  80448b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  80448f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804493:	8b 40 0c             	mov    0xc(%rax),%eax
  804496:	85 c0                	test   %eax,%eax
  804498:	7e 67                	jle    804501 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  80449a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80449e:	8b 40 04             	mov    0x4(%rax),%eax
  8044a1:	48 63 d0             	movslq %eax,%rdx
  8044a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044a8:	48 8d 48 10          	lea    0x10(%rax),%rcx
  8044ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044b0:	8b 00                	mov    (%rax),%eax
  8044b2:	48 89 ce             	mov    %rcx,%rsi
  8044b5:	89 c7                	mov    %eax,%edi
  8044b7:	48 b8 bc 3c 80 00 00 	movabs $0x803cbc,%rax
  8044be:	00 00 00 
  8044c1:	ff d0                	callq  *%rax
  8044c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  8044c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044ca:	7e 13                	jle    8044df <writebuf+0x5c>
			b->result += result;
  8044cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044d0:	8b 50 08             	mov    0x8(%rax),%edx
  8044d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044d6:	01 c2                	add    %eax,%edx
  8044d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044dc:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  8044df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044e3:	8b 40 04             	mov    0x4(%rax),%eax
  8044e6:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8044e9:	74 16                	je     804501 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  8044eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8044f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044f4:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  8044f8:	89 c2                	mov    %eax,%edx
  8044fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044fe:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  804501:	c9                   	leaveq 
  804502:	c3                   	retq   

0000000000804503 <putch>:

static void
putch(int ch, void *thunk)
{
  804503:	55                   	push   %rbp
  804504:	48 89 e5             	mov    %rsp,%rbp
  804507:	48 83 ec 20          	sub    $0x20,%rsp
  80450b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80450e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  804512:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804516:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  80451a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80451e:	8b 40 04             	mov    0x4(%rax),%eax
  804521:	8d 48 01             	lea    0x1(%rax),%ecx
  804524:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804528:	89 4a 04             	mov    %ecx,0x4(%rdx)
  80452b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80452e:	89 d1                	mov    %edx,%ecx
  804530:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804534:	48 98                	cltq   
  804536:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  80453a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80453e:	8b 40 04             	mov    0x4(%rax),%eax
  804541:	3d 00 01 00 00       	cmp    $0x100,%eax
  804546:	75 1e                	jne    804566 <putch+0x63>
		writebuf(b);
  804548:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80454c:	48 89 c7             	mov    %rax,%rdi
  80454f:	48 b8 83 44 80 00 00 	movabs $0x804483,%rax
  804556:	00 00 00 
  804559:	ff d0                	callq  *%rax
		b->idx = 0;
  80455b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80455f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  804566:	c9                   	leaveq 
  804567:	c3                   	retq   

0000000000804568 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  804568:	55                   	push   %rbp
  804569:	48 89 e5             	mov    %rsp,%rbp
  80456c:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  804573:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  804579:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  804580:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  804587:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  80458d:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  804593:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80459a:	00 00 00 
	b.result = 0;
  80459d:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  8045a4:	00 00 00 
	b.error = 1;
  8045a7:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  8045ae:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8045b1:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  8045b8:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  8045bf:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8045c6:	48 89 c6             	mov    %rax,%rsi
  8045c9:	48 bf 03 45 80 00 00 	movabs $0x804503,%rdi
  8045d0:	00 00 00 
  8045d3:	48 b8 e3 17 80 00 00 	movabs $0x8017e3,%rax
  8045da:	00 00 00 
  8045dd:	ff d0                	callq  *%rax
	if (b.idx > 0)
  8045df:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  8045e5:	85 c0                	test   %eax,%eax
  8045e7:	7e 16                	jle    8045ff <vfprintf+0x97>
		writebuf(&b);
  8045e9:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8045f0:	48 89 c7             	mov    %rax,%rdi
  8045f3:	48 b8 83 44 80 00 00 	movabs $0x804483,%rax
  8045fa:	00 00 00 
  8045fd:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  8045ff:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  804605:	85 c0                	test   %eax,%eax
  804607:	74 08                	je     804611 <vfprintf+0xa9>
  804609:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  80460f:	eb 06                	jmp    804617 <vfprintf+0xaf>
  804611:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  804617:	c9                   	leaveq 
  804618:	c3                   	retq   

0000000000804619 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  804619:	55                   	push   %rbp
  80461a:	48 89 e5             	mov    %rsp,%rbp
  80461d:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  804624:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  80462a:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  804631:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  804638:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80463f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  804646:	84 c0                	test   %al,%al
  804648:	74 20                	je     80466a <fprintf+0x51>
  80464a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80464e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  804652:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  804656:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80465a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80465e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  804662:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  804666:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80466a:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  804671:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  804678:	00 00 00 
  80467b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  804682:	00 00 00 
  804685:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804689:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  804690:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  804697:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  80469e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8046a5:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  8046ac:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8046b2:	48 89 ce             	mov    %rcx,%rsi
  8046b5:	89 c7                	mov    %eax,%edi
  8046b7:	48 b8 68 45 80 00 00 	movabs $0x804568,%rax
  8046be:	00 00 00 
  8046c1:	ff d0                	callq  *%rax
  8046c3:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  8046c9:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8046cf:	c9                   	leaveq 
  8046d0:	c3                   	retq   

00000000008046d1 <printf>:

int
printf(const char *fmt, ...)
{
  8046d1:	55                   	push   %rbp
  8046d2:	48 89 e5             	mov    %rsp,%rbp
  8046d5:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  8046dc:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8046e3:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8046ea:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8046f1:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8046f8:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8046ff:	84 c0                	test   %al,%al
  804701:	74 20                	je     804723 <printf+0x52>
  804703:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  804707:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80470b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80470f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  804713:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  804717:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80471b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80471f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  804723:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80472a:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  804731:	00 00 00 
  804734:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80473b:	00 00 00 
  80473e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804742:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  804749:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  804750:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  804757:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80475e:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  804765:	48 89 c6             	mov    %rax,%rsi
  804768:	bf 01 00 00 00       	mov    $0x1,%edi
  80476d:	48 b8 68 45 80 00 00 	movabs $0x804568,%rax
  804774:	00 00 00 
  804777:	ff d0                	callq  *%rax
  804779:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  80477f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  804785:	c9                   	leaveq 
  804786:	c3                   	retq   

0000000000804787 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  804787:	55                   	push   %rbp
  804788:	48 89 e5             	mov    %rsp,%rbp
  80478b:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  804792:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  804799:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8047a0:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  8047a7:	be 00 00 00 00       	mov    $0x0,%esi
  8047ac:	48 89 c7             	mov    %rax,%rdi
  8047af:	48 b8 48 40 80 00 00 	movabs $0x804048,%rax
  8047b6:	00 00 00 
  8047b9:	ff d0                	callq  *%rax
  8047bb:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8047be:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8047c2:	79 08                	jns    8047cc <spawn+0x45>
		return r;
  8047c4:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8047c7:	e9 14 03 00 00       	jmpq   804ae0 <spawn+0x359>
	fd = r;
  8047cc:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8047cf:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  8047d2:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  8047d9:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8047dd:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  8047e4:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8047e7:	ba 00 02 00 00       	mov    $0x200,%edx
  8047ec:	48 89 ce             	mov    %rcx,%rsi
  8047ef:	89 c7                	mov    %eax,%edi
  8047f1:	48 b8 47 3c 80 00 00 	movabs $0x803c47,%rax
  8047f8:	00 00 00 
  8047fb:	ff d0                	callq  *%rax
  8047fd:	3d 00 02 00 00       	cmp    $0x200,%eax
  804802:	75 0d                	jne    804811 <spawn+0x8a>
	    || elf->e_magic != ELF_MAGIC) {
  804804:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804808:	8b 00                	mov    (%rax),%eax
  80480a:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  80480f:	74 43                	je     804854 <spawn+0xcd>
		close(fd);
  804811:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804814:	89 c7                	mov    %eax,%edi
  804816:	48 b8 50 39 80 00 00 	movabs $0x803950,%rax
  80481d:	00 00 00 
  804820:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  804822:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804826:	8b 00                	mov    (%rax),%eax
  804828:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  80482d:	89 c6                	mov    %eax,%esi
  80482f:	48 bf 08 66 80 00 00 	movabs $0x806608,%rdi
  804836:	00 00 00 
  804839:	b8 00 00 00 00       	mov    $0x0,%eax
  80483e:	48 b9 30 14 80 00 00 	movabs $0x801430,%rcx
  804845:	00 00 00 
  804848:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  80484a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80484f:	e9 8c 02 00 00       	jmpq   804ae0 <spawn+0x359>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  804854:	b8 07 00 00 00       	mov    $0x7,%eax
  804859:	cd 30                	int    $0x30
  80485b:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  80485e:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  804861:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804864:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804868:	79 08                	jns    804872 <spawn+0xeb>
		return r;
  80486a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80486d:	e9 6e 02 00 00       	jmpq   804ae0 <spawn+0x359>
	child = r;
  804872:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804875:	89 45 d4             	mov    %eax,-0x2c(%rbp)
	//thisenv = &envs[ENVX(sys_getenvid())];
	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  804878:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80487b:	25 ff 03 00 00       	and    $0x3ff,%eax
  804880:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804887:	00 00 00 
  80488a:	48 63 d0             	movslq %eax,%rdx
  80488d:	48 89 d0             	mov    %rdx,%rax
  804890:	48 c1 e0 03          	shl    $0x3,%rax
  804894:	48 01 d0             	add    %rdx,%rax
  804897:	48 c1 e0 05          	shl    $0x5,%rax
  80489b:	48 01 c8             	add    %rcx,%rax
  80489e:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  8048a5:	48 89 c6             	mov    %rax,%rsi
  8048a8:	b8 18 00 00 00       	mov    $0x18,%eax
  8048ad:	48 89 d7             	mov    %rdx,%rdi
  8048b0:	48 89 c1             	mov    %rax,%rcx
  8048b3:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  8048b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048ba:	48 8b 40 18          	mov    0x18(%rax),%rax
  8048be:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  8048c5:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  8048cc:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  8048d3:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  8048da:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8048dd:	48 89 ce             	mov    %rcx,%rsi
  8048e0:	89 c7                	mov    %eax,%edi
  8048e2:	48 b8 4a 4d 80 00 00 	movabs $0x804d4a,%rax
  8048e9:	00 00 00 
  8048ec:	ff d0                	callq  *%rax
  8048ee:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8048f1:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8048f5:	79 08                	jns    8048ff <spawn+0x178>
		return r;
  8048f7:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8048fa:	e9 e1 01 00 00       	jmpq   804ae0 <spawn+0x359>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8048ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804903:	48 8b 40 20          	mov    0x20(%rax),%rax
  804907:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  80490e:	48 01 d0             	add    %rdx,%rax
  804911:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  804915:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80491c:	e9 a3 00 00 00       	jmpq   8049c4 <spawn+0x23d>
		if (ph->p_type != ELF_PROG_LOAD)
  804921:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804925:	8b 00                	mov    (%rax),%eax
  804927:	83 f8 01             	cmp    $0x1,%eax
  80492a:	74 05                	je     804931 <spawn+0x1aa>
			continue;
  80492c:	e9 8a 00 00 00       	jmpq   8049bb <spawn+0x234>
		perm = PTE_P | PTE_U;
  804931:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  804938:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80493c:	8b 40 04             	mov    0x4(%rax),%eax
  80493f:	83 e0 02             	and    $0x2,%eax
  804942:	85 c0                	test   %eax,%eax
  804944:	74 04                	je     80494a <spawn+0x1c3>
			perm |= PTE_W;
  804946:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  80494a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80494e:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  804952:	41 89 c1             	mov    %eax,%r9d
  804955:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804959:	4c 8b 40 20          	mov    0x20(%rax),%r8
  80495d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804961:	48 8b 50 28          	mov    0x28(%rax),%rdx
  804965:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804969:	48 8b 70 10          	mov    0x10(%rax),%rsi
  80496d:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  804970:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804973:	8b 7d ec             	mov    -0x14(%rbp),%edi
  804976:	89 3c 24             	mov    %edi,(%rsp)
  804979:	89 c7                	mov    %eax,%edi
  80497b:	48 b8 f3 4f 80 00 00 	movabs $0x804ff3,%rax
  804982:	00 00 00 
  804985:	ff d0                	callq  *%rax
  804987:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80498a:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80498e:	79 2b                	jns    8049bb <spawn+0x234>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  804990:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  804991:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804994:	89 c7                	mov    %eax,%edi
  804996:	48 b8 ae 29 80 00 00 	movabs $0x8029ae,%rax
  80499d:	00 00 00 
  8049a0:	ff d0                	callq  *%rax
	close(fd);
  8049a2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8049a5:	89 c7                	mov    %eax,%edi
  8049a7:	48 b8 50 39 80 00 00 	movabs $0x803950,%rax
  8049ae:	00 00 00 
  8049b1:	ff d0                	callq  *%rax
	return r;
  8049b3:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8049b6:	e9 25 01 00 00       	jmpq   804ae0 <spawn+0x359>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8049bb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8049bf:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  8049c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8049c8:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  8049cc:	0f b7 c0             	movzwl %ax,%eax
  8049cf:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8049d2:	0f 8f 49 ff ff ff    	jg     804921 <spawn+0x19a>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  8049d8:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8049db:	89 c7                	mov    %eax,%edi
  8049dd:	48 b8 50 39 80 00 00 	movabs $0x803950,%rax
  8049e4:	00 00 00 
  8049e7:	ff d0                	callq  *%rax
	fd = -1;
  8049e9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  8049f0:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8049f3:	89 c7                	mov    %eax,%edi
  8049f5:	48 b8 df 51 80 00 00 	movabs $0x8051df,%rax
  8049fc:	00 00 00 
  8049ff:	ff d0                	callq  *%rax
  804a01:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804a04:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804a08:	79 30                	jns    804a3a <spawn+0x2b3>
		panic("copy_shared_pages: %e", r);
  804a0a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804a0d:	89 c1                	mov    %eax,%ecx
  804a0f:	48 ba 22 66 80 00 00 	movabs $0x806622,%rdx
  804a16:	00 00 00 
  804a19:	be 82 00 00 00       	mov    $0x82,%esi
  804a1e:	48 bf 38 66 80 00 00 	movabs $0x806638,%rdi
  804a25:	00 00 00 
  804a28:	b8 00 00 00 00       	mov    $0x0,%eax
  804a2d:	49 b8 f7 11 80 00 00 	movabs $0x8011f7,%r8
  804a34:	00 00 00 
  804a37:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  804a3a:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  804a41:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804a44:	48 89 d6             	mov    %rdx,%rsi
  804a47:	89 c7                	mov    %eax,%edi
  804a49:	48 b8 ae 2b 80 00 00 	movabs $0x802bae,%rax
  804a50:	00 00 00 
  804a53:	ff d0                	callq  *%rax
  804a55:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804a58:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804a5c:	79 30                	jns    804a8e <spawn+0x307>
		panic("sys_env_set_trapframe: %e", r);
  804a5e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804a61:	89 c1                	mov    %eax,%ecx
  804a63:	48 ba 44 66 80 00 00 	movabs $0x806644,%rdx
  804a6a:	00 00 00 
  804a6d:	be 85 00 00 00       	mov    $0x85,%esi
  804a72:	48 bf 38 66 80 00 00 	movabs $0x806638,%rdi
  804a79:	00 00 00 
  804a7c:	b8 00 00 00 00       	mov    $0x0,%eax
  804a81:	49 b8 f7 11 80 00 00 	movabs $0x8011f7,%r8
  804a88:	00 00 00 
  804a8b:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  804a8e:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804a91:	be 02 00 00 00       	mov    $0x2,%esi
  804a96:	89 c7                	mov    %eax,%edi
  804a98:	48 b8 63 2b 80 00 00 	movabs $0x802b63,%rax
  804a9f:	00 00 00 
  804aa2:	ff d0                	callq  *%rax
  804aa4:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804aa7:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804aab:	79 30                	jns    804add <spawn+0x356>
		panic("sys_env_set_status: %e", r);
  804aad:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804ab0:	89 c1                	mov    %eax,%ecx
  804ab2:	48 ba 5e 66 80 00 00 	movabs $0x80665e,%rdx
  804ab9:	00 00 00 
  804abc:	be 88 00 00 00       	mov    $0x88,%esi
  804ac1:	48 bf 38 66 80 00 00 	movabs $0x806638,%rdi
  804ac8:	00 00 00 
  804acb:	b8 00 00 00 00       	mov    $0x0,%eax
  804ad0:	49 b8 f7 11 80 00 00 	movabs $0x8011f7,%r8
  804ad7:	00 00 00 
  804ada:	41 ff d0             	callq  *%r8

	return child;
  804add:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  804ae0:	c9                   	leaveq 
  804ae1:	c3                   	retq   

0000000000804ae2 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  804ae2:	55                   	push   %rbp
  804ae3:	48 89 e5             	mov    %rsp,%rbp
  804ae6:	41 55                	push   %r13
  804ae8:	41 54                	push   %r12
  804aea:	53                   	push   %rbx
  804aeb:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  804af2:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  804af9:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  804b00:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  804b07:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  804b0e:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  804b15:	84 c0                	test   %al,%al
  804b17:	74 26                	je     804b3f <spawnl+0x5d>
  804b19:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  804b20:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  804b27:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  804b2b:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  804b2f:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  804b33:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  804b37:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  804b3b:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  804b3f:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  804b46:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  804b4d:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  804b50:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  804b57:	00 00 00 
  804b5a:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  804b61:	00 00 00 
  804b64:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804b68:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  804b6f:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  804b76:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  804b7d:	eb 07                	jmp    804b86 <spawnl+0xa4>
		argc++;
  804b7f:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  804b86:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  804b8c:	83 f8 30             	cmp    $0x30,%eax
  804b8f:	73 23                	jae    804bb4 <spawnl+0xd2>
  804b91:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  804b98:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  804b9e:	89 c0                	mov    %eax,%eax
  804ba0:	48 01 d0             	add    %rdx,%rax
  804ba3:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  804ba9:	83 c2 08             	add    $0x8,%edx
  804bac:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  804bb2:	eb 15                	jmp    804bc9 <spawnl+0xe7>
  804bb4:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  804bbb:	48 89 d0             	mov    %rdx,%rax
  804bbe:	48 83 c2 08          	add    $0x8,%rdx
  804bc2:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  804bc9:	48 8b 00             	mov    (%rax),%rax
  804bcc:	48 85 c0             	test   %rax,%rax
  804bcf:	75 ae                	jne    804b7f <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  804bd1:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  804bd7:	83 c0 02             	add    $0x2,%eax
  804bda:	48 89 e2             	mov    %rsp,%rdx
  804bdd:	48 89 d3             	mov    %rdx,%rbx
  804be0:	48 63 d0             	movslq %eax,%rdx
  804be3:	48 83 ea 01          	sub    $0x1,%rdx
  804be7:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  804bee:	48 63 d0             	movslq %eax,%rdx
  804bf1:	49 89 d4             	mov    %rdx,%r12
  804bf4:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  804bfa:	48 63 d0             	movslq %eax,%rdx
  804bfd:	49 89 d2             	mov    %rdx,%r10
  804c00:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  804c06:	48 98                	cltq   
  804c08:	48 c1 e0 03          	shl    $0x3,%rax
  804c0c:	48 8d 50 07          	lea    0x7(%rax),%rdx
  804c10:	b8 10 00 00 00       	mov    $0x10,%eax
  804c15:	48 83 e8 01          	sub    $0x1,%rax
  804c19:	48 01 d0             	add    %rdx,%rax
  804c1c:	bf 10 00 00 00       	mov    $0x10,%edi
  804c21:	ba 00 00 00 00       	mov    $0x0,%edx
  804c26:	48 f7 f7             	div    %rdi
  804c29:	48 6b c0 10          	imul   $0x10,%rax,%rax
  804c2d:	48 29 c4             	sub    %rax,%rsp
  804c30:	48 89 e0             	mov    %rsp,%rax
  804c33:	48 83 c0 07          	add    $0x7,%rax
  804c37:	48 c1 e8 03          	shr    $0x3,%rax
  804c3b:	48 c1 e0 03          	shl    $0x3,%rax
  804c3f:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  804c46:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  804c4d:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  804c54:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  804c57:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  804c5d:	8d 50 01             	lea    0x1(%rax),%edx
  804c60:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  804c67:	48 63 d2             	movslq %edx,%rdx
  804c6a:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  804c71:	00 

	va_start(vl, arg0);
  804c72:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  804c79:	00 00 00 
  804c7c:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  804c83:	00 00 00 
  804c86:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804c8a:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  804c91:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  804c98:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  804c9f:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  804ca6:	00 00 00 
  804ca9:	eb 63                	jmp    804d0e <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  804cab:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  804cb1:	8d 70 01             	lea    0x1(%rax),%esi
  804cb4:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  804cba:	83 f8 30             	cmp    $0x30,%eax
  804cbd:	73 23                	jae    804ce2 <spawnl+0x200>
  804cbf:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  804cc6:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  804ccc:	89 c0                	mov    %eax,%eax
  804cce:	48 01 d0             	add    %rdx,%rax
  804cd1:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  804cd7:	83 c2 08             	add    $0x8,%edx
  804cda:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  804ce0:	eb 15                	jmp    804cf7 <spawnl+0x215>
  804ce2:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  804ce9:	48 89 d0             	mov    %rdx,%rax
  804cec:	48 83 c2 08          	add    $0x8,%rdx
  804cf0:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  804cf7:	48 8b 08             	mov    (%rax),%rcx
  804cfa:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  804d01:	89 f2                	mov    %esi,%edx
  804d03:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  804d07:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  804d0e:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  804d14:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  804d1a:	77 8f                	ja     804cab <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  804d1c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  804d23:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  804d2a:	48 89 d6             	mov    %rdx,%rsi
  804d2d:	48 89 c7             	mov    %rax,%rdi
  804d30:	48 b8 87 47 80 00 00 	movabs $0x804787,%rax
  804d37:	00 00 00 
  804d3a:	ff d0                	callq  *%rax
  804d3c:	48 89 dc             	mov    %rbx,%rsp
}
  804d3f:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  804d43:	5b                   	pop    %rbx
  804d44:	41 5c                	pop    %r12
  804d46:	41 5d                	pop    %r13
  804d48:	5d                   	pop    %rbp
  804d49:	c3                   	retq   

0000000000804d4a <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  804d4a:	55                   	push   %rbp
  804d4b:	48 89 e5             	mov    %rsp,%rbp
  804d4e:	48 83 ec 50          	sub    $0x50,%rsp
  804d52:	89 7d cc             	mov    %edi,-0x34(%rbp)
  804d55:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  804d59:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  804d5d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804d64:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  804d65:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  804d6c:	eb 33                	jmp    804da1 <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  804d6e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804d71:	48 98                	cltq   
  804d73:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804d7a:	00 
  804d7b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  804d7f:	48 01 d0             	add    %rdx,%rax
  804d82:	48 8b 00             	mov    (%rax),%rax
  804d85:	48 89 c7             	mov    %rax,%rdi
  804d88:	48 b8 d3 20 80 00 00 	movabs $0x8020d3,%rax
  804d8f:	00 00 00 
  804d92:	ff d0                	callq  *%rax
  804d94:	83 c0 01             	add    $0x1,%eax
  804d97:	48 98                	cltq   
  804d99:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  804d9d:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  804da1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804da4:	48 98                	cltq   
  804da6:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804dad:	00 
  804dae:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  804db2:	48 01 d0             	add    %rdx,%rax
  804db5:	48 8b 00             	mov    (%rax),%rax
  804db8:	48 85 c0             	test   %rax,%rax
  804dbb:	75 b1                	jne    804d6e <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  804dbd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804dc1:	48 f7 d8             	neg    %rax
  804dc4:	48 05 00 10 40 00    	add    $0x401000,%rax
  804dca:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  804dce:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804dd2:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  804dd6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804dda:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  804dde:	8b 55 f4             	mov    -0xc(%rbp),%edx
  804de1:	83 c2 01             	add    $0x1,%edx
  804de4:	c1 e2 03             	shl    $0x3,%edx
  804de7:	48 63 d2             	movslq %edx,%rdx
  804dea:	48 f7 da             	neg    %rdx
  804ded:	48 01 d0             	add    %rdx,%rax
  804df0:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  804df4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804df8:	48 83 e8 10          	sub    $0x10,%rax
  804dfc:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  804e02:	77 0a                	ja     804e0e <init_stack+0xc4>
		return -E_NO_MEM;
  804e04:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  804e09:	e9 e3 01 00 00       	jmpq   804ff1 <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  804e0e:	ba 07 00 00 00       	mov    $0x7,%edx
  804e13:	be 00 00 40 00       	mov    $0x400000,%esi
  804e18:	bf 00 00 00 00       	mov    $0x0,%edi
  804e1d:	48 b8 6e 2a 80 00 00 	movabs $0x802a6e,%rax
  804e24:	00 00 00 
  804e27:	ff d0                	callq  *%rax
  804e29:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804e2c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804e30:	79 08                	jns    804e3a <init_stack+0xf0>
		return r;
  804e32:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804e35:	e9 b7 01 00 00       	jmpq   804ff1 <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  804e3a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  804e41:	e9 8a 00 00 00       	jmpq   804ed0 <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  804e46:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804e49:	48 98                	cltq   
  804e4b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804e52:	00 
  804e53:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804e57:	48 01 c2             	add    %rax,%rdx
  804e5a:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  804e5f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804e63:	48 01 c8             	add    %rcx,%rax
  804e66:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  804e6c:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  804e6f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804e72:	48 98                	cltq   
  804e74:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804e7b:	00 
  804e7c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  804e80:	48 01 d0             	add    %rdx,%rax
  804e83:	48 8b 10             	mov    (%rax),%rdx
  804e86:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804e8a:	48 89 d6             	mov    %rdx,%rsi
  804e8d:	48 89 c7             	mov    %rax,%rdi
  804e90:	48 b8 3f 21 80 00 00 	movabs $0x80213f,%rax
  804e97:	00 00 00 
  804e9a:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  804e9c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804e9f:	48 98                	cltq   
  804ea1:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804ea8:	00 
  804ea9:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  804ead:	48 01 d0             	add    %rdx,%rax
  804eb0:	48 8b 00             	mov    (%rax),%rax
  804eb3:	48 89 c7             	mov    %rax,%rdi
  804eb6:	48 b8 d3 20 80 00 00 	movabs $0x8020d3,%rax
  804ebd:	00 00 00 
  804ec0:	ff d0                	callq  *%rax
  804ec2:	48 98                	cltq   
  804ec4:	48 83 c0 01          	add    $0x1,%rax
  804ec8:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  804ecc:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  804ed0:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804ed3:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  804ed6:	0f 8c 6a ff ff ff    	jl     804e46 <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  804edc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804edf:	48 98                	cltq   
  804ee1:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804ee8:	00 
  804ee9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804eed:	48 01 d0             	add    %rdx,%rax
  804ef0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  804ef7:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  804efe:	00 
  804eff:	74 35                	je     804f36 <init_stack+0x1ec>
  804f01:	48 b9 78 66 80 00 00 	movabs $0x806678,%rcx
  804f08:	00 00 00 
  804f0b:	48 ba 9e 66 80 00 00 	movabs $0x80669e,%rdx
  804f12:	00 00 00 
  804f15:	be f1 00 00 00       	mov    $0xf1,%esi
  804f1a:	48 bf 38 66 80 00 00 	movabs $0x806638,%rdi
  804f21:	00 00 00 
  804f24:	b8 00 00 00 00       	mov    $0x0,%eax
  804f29:	49 b8 f7 11 80 00 00 	movabs $0x8011f7,%r8
  804f30:	00 00 00 
  804f33:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  804f36:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804f3a:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  804f3e:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  804f43:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804f47:	48 01 c8             	add    %rcx,%rax
  804f4a:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  804f50:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  804f53:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804f57:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  804f5b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804f5e:	48 98                	cltq   
  804f60:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  804f63:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  804f68:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804f6c:	48 01 d0             	add    %rdx,%rax
  804f6f:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  804f75:	48 89 c2             	mov    %rax,%rdx
  804f78:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  804f7c:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  804f7f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  804f82:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  804f88:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  804f8d:	89 c2                	mov    %eax,%edx
  804f8f:	be 00 00 40 00       	mov    $0x400000,%esi
  804f94:	bf 00 00 00 00       	mov    $0x0,%edi
  804f99:	48 b8 be 2a 80 00 00 	movabs $0x802abe,%rax
  804fa0:	00 00 00 
  804fa3:	ff d0                	callq  *%rax
  804fa5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804fa8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804fac:	79 02                	jns    804fb0 <init_stack+0x266>
		goto error;
  804fae:	eb 28                	jmp    804fd8 <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  804fb0:	be 00 00 40 00       	mov    $0x400000,%esi
  804fb5:	bf 00 00 00 00       	mov    $0x0,%edi
  804fba:	48 b8 19 2b 80 00 00 	movabs $0x802b19,%rax
  804fc1:	00 00 00 
  804fc4:	ff d0                	callq  *%rax
  804fc6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804fc9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804fcd:	79 02                	jns    804fd1 <init_stack+0x287>
		goto error;
  804fcf:	eb 07                	jmp    804fd8 <init_stack+0x28e>

	return 0;
  804fd1:	b8 00 00 00 00       	mov    $0x0,%eax
  804fd6:	eb 19                	jmp    804ff1 <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  804fd8:	be 00 00 40 00       	mov    $0x400000,%esi
  804fdd:	bf 00 00 00 00       	mov    $0x0,%edi
  804fe2:	48 b8 19 2b 80 00 00 	movabs $0x802b19,%rax
  804fe9:	00 00 00 
  804fec:	ff d0                	callq  *%rax
	return r;
  804fee:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804ff1:	c9                   	leaveq 
  804ff2:	c3                   	retq   

0000000000804ff3 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	int fd, size_t filesz, off_t fileoffset, int perm)
{
  804ff3:	55                   	push   %rbp
  804ff4:	48 89 e5             	mov    %rsp,%rbp
  804ff7:	48 83 ec 50          	sub    $0x50,%rsp
  804ffb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  804ffe:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  805002:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  805006:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  805009:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80500d:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  805011:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805015:	25 ff 0f 00 00       	and    $0xfff,%eax
  80501a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80501d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805021:	74 21                	je     805044 <map_segment+0x51>
		va -= i;
  805023:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805026:	48 98                	cltq   
  805028:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  80502c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80502f:	48 98                	cltq   
  805031:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  805035:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805038:	48 98                	cltq   
  80503a:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  80503e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805041:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  805044:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80504b:	e9 79 01 00 00       	jmpq   8051c9 <map_segment+0x1d6>
		if (i >= filesz) {
  805050:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805053:	48 98                	cltq   
  805055:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  805059:	72 3c                	jb     805097 <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  80505b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80505e:	48 63 d0             	movslq %eax,%rdx
  805061:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805065:	48 01 d0             	add    %rdx,%rax
  805068:	48 89 c1             	mov    %rax,%rcx
  80506b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80506e:	8b 55 10             	mov    0x10(%rbp),%edx
  805071:	48 89 ce             	mov    %rcx,%rsi
  805074:	89 c7                	mov    %eax,%edi
  805076:	48 b8 6e 2a 80 00 00 	movabs $0x802a6e,%rax
  80507d:	00 00 00 
  805080:	ff d0                	callq  *%rax
  805082:	89 45 f8             	mov    %eax,-0x8(%rbp)
  805085:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  805089:	0f 89 33 01 00 00    	jns    8051c2 <map_segment+0x1cf>
				return r;
  80508f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805092:	e9 46 01 00 00       	jmpq   8051dd <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  805097:	ba 07 00 00 00       	mov    $0x7,%edx
  80509c:	be 00 00 40 00       	mov    $0x400000,%esi
  8050a1:	bf 00 00 00 00       	mov    $0x0,%edi
  8050a6:	48 b8 6e 2a 80 00 00 	movabs $0x802a6e,%rax
  8050ad:	00 00 00 
  8050b0:	ff d0                	callq  *%rax
  8050b2:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8050b5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8050b9:	79 08                	jns    8050c3 <map_segment+0xd0>
				return r;
  8050bb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8050be:	e9 1a 01 00 00       	jmpq   8051dd <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  8050c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8050c6:	8b 55 bc             	mov    -0x44(%rbp),%edx
  8050c9:	01 c2                	add    %eax,%edx
  8050cb:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8050ce:	89 d6                	mov    %edx,%esi
  8050d0:	89 c7                	mov    %eax,%edi
  8050d2:	48 b8 90 3d 80 00 00 	movabs $0x803d90,%rax
  8050d9:	00 00 00 
  8050dc:	ff d0                	callq  *%rax
  8050de:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8050e1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8050e5:	79 08                	jns    8050ef <map_segment+0xfc>
				return r;
  8050e7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8050ea:	e9 ee 00 00 00       	jmpq   8051dd <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8050ef:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  8050f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8050f9:	48 98                	cltq   
  8050fb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8050ff:	48 29 c2             	sub    %rax,%rdx
  805102:	48 89 d0             	mov    %rdx,%rax
  805105:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  805109:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80510c:	48 63 d0             	movslq %eax,%rdx
  80510f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805113:	48 39 c2             	cmp    %rax,%rdx
  805116:	48 0f 47 d0          	cmova  %rax,%rdx
  80511a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80511d:	be 00 00 40 00       	mov    $0x400000,%esi
  805122:	89 c7                	mov    %eax,%edi
  805124:	48 b8 47 3c 80 00 00 	movabs $0x803c47,%rax
  80512b:	00 00 00 
  80512e:	ff d0                	callq  *%rax
  805130:	89 45 f8             	mov    %eax,-0x8(%rbp)
  805133:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  805137:	79 08                	jns    805141 <map_segment+0x14e>
				return r;
  805139:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80513c:	e9 9c 00 00 00       	jmpq   8051dd <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  805141:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805144:	48 63 d0             	movslq %eax,%rdx
  805147:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80514b:	48 01 d0             	add    %rdx,%rax
  80514e:	48 89 c2             	mov    %rax,%rdx
  805151:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805154:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  805158:	48 89 d1             	mov    %rdx,%rcx
  80515b:	89 c2                	mov    %eax,%edx
  80515d:	be 00 00 40 00       	mov    $0x400000,%esi
  805162:	bf 00 00 00 00       	mov    $0x0,%edi
  805167:	48 b8 be 2a 80 00 00 	movabs $0x802abe,%rax
  80516e:	00 00 00 
  805171:	ff d0                	callq  *%rax
  805173:	89 45 f8             	mov    %eax,-0x8(%rbp)
  805176:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80517a:	79 30                	jns    8051ac <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  80517c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80517f:	89 c1                	mov    %eax,%ecx
  805181:	48 ba b3 66 80 00 00 	movabs $0x8066b3,%rdx
  805188:	00 00 00 
  80518b:	be 24 01 00 00       	mov    $0x124,%esi
  805190:	48 bf 38 66 80 00 00 	movabs $0x806638,%rdi
  805197:	00 00 00 
  80519a:	b8 00 00 00 00       	mov    $0x0,%eax
  80519f:	49 b8 f7 11 80 00 00 	movabs $0x8011f7,%r8
  8051a6:	00 00 00 
  8051a9:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  8051ac:	be 00 00 40 00       	mov    $0x400000,%esi
  8051b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8051b6:	48 b8 19 2b 80 00 00 	movabs $0x802b19,%rax
  8051bd:	00 00 00 
  8051c0:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8051c2:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  8051c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8051cc:	48 98                	cltq   
  8051ce:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8051d2:	0f 82 78 fe ff ff    	jb     805050 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  8051d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8051dd:	c9                   	leaveq 
  8051de:	c3                   	retq   

00000000008051df <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  8051df:	55                   	push   %rbp
  8051e0:	48 89 e5             	mov    %rsp,%rbp
  8051e3:	48 83 ec 20          	sub    $0x20,%rsp
  8051e7:	89 7d ec             	mov    %edi,-0x14(%rbp)
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  8051ea:	48 c7 45 f8 00 00 80 	movq   $0x800000,-0x8(%rbp)
  8051f1:	00 
  8051f2:	e9 c9 00 00 00       	jmpq   8052c0 <copy_shared_pages+0xe1>
        {
            if(!((uvpml4e[VPML4E(addr)])&&(uvpde[VPDPE(addr)]) && (uvpd[VPD(addr)]  )))
  8051f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8051fb:	48 c1 e8 27          	shr    $0x27,%rax
  8051ff:	48 89 c2             	mov    %rax,%rdx
  805202:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  805209:	01 00 00 
  80520c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805210:	48 85 c0             	test   %rax,%rax
  805213:	74 3c                	je     805251 <copy_shared_pages+0x72>
  805215:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805219:	48 c1 e8 1e          	shr    $0x1e,%rax
  80521d:	48 89 c2             	mov    %rax,%rdx
  805220:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  805227:	01 00 00 
  80522a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80522e:	48 85 c0             	test   %rax,%rax
  805231:	74 1e                	je     805251 <copy_shared_pages+0x72>
  805233:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805237:	48 c1 e8 15          	shr    $0x15,%rax
  80523b:	48 89 c2             	mov    %rax,%rdx
  80523e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  805245:	01 00 00 
  805248:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80524c:	48 85 c0             	test   %rax,%rax
  80524f:	75 02                	jne    805253 <copy_shared_pages+0x74>
                continue;
  805251:	eb 65                	jmp    8052b8 <copy_shared_pages+0xd9>

            if((uvpt[VPN(addr)] & PTE_SHARE) != 0)
  805253:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805257:	48 c1 e8 0c          	shr    $0xc,%rax
  80525b:	48 89 c2             	mov    %rax,%rdx
  80525e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805265:	01 00 00 
  805268:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80526c:	25 00 04 00 00       	and    $0x400,%eax
  805271:	48 85 c0             	test   %rax,%rax
  805274:	74 42                	je     8052b8 <copy_shared_pages+0xd9>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);
  805276:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80527a:	48 c1 e8 0c          	shr    $0xc,%rax
  80527e:	48 89 c2             	mov    %rax,%rdx
  805281:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805288:	01 00 00 
  80528b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80528f:	25 07 0e 00 00       	and    $0xe07,%eax
  805294:	89 c6                	mov    %eax,%esi
  805296:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80529a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80529e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8052a1:	41 89 f0             	mov    %esi,%r8d
  8052a4:	48 89 c6             	mov    %rax,%rsi
  8052a7:	bf 00 00 00 00       	mov    $0x0,%edi
  8052ac:	48 b8 be 2a 80 00 00 	movabs $0x802abe,%rax
  8052b3:	00 00 00 
  8052b6:	ff d0                	callq  *%rax
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  8052b8:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  8052bf:	00 
  8052c0:	48 b8 ff ff 7f 00 80 	movabs $0x80007fffff,%rax
  8052c7:	00 00 00 
  8052ca:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  8052ce:	0f 86 23 ff ff ff    	jbe    8051f7 <copy_shared_pages+0x18>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);

            }
        }
     return 0;
  8052d4:	b8 00 00 00 00       	mov    $0x0,%eax
 }
  8052d9:	c9                   	leaveq 
  8052da:	c3                   	retq   

00000000008052db <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8052db:	55                   	push   %rbp
  8052dc:	48 89 e5             	mov    %rsp,%rbp
  8052df:	53                   	push   %rbx
  8052e0:	48 83 ec 38          	sub    $0x38,%rsp
  8052e4:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8052e8:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8052ec:	48 89 c7             	mov    %rax,%rdi
  8052ef:	48 b8 a8 36 80 00 00 	movabs $0x8036a8,%rax
  8052f6:	00 00 00 
  8052f9:	ff d0                	callq  *%rax
  8052fb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8052fe:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805302:	0f 88 bf 01 00 00    	js     8054c7 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  805308:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80530c:	ba 07 04 00 00       	mov    $0x407,%edx
  805311:	48 89 c6             	mov    %rax,%rsi
  805314:	bf 00 00 00 00       	mov    $0x0,%edi
  805319:	48 b8 6e 2a 80 00 00 	movabs $0x802a6e,%rax
  805320:	00 00 00 
  805323:	ff d0                	callq  *%rax
  805325:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805328:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80532c:	0f 88 95 01 00 00    	js     8054c7 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  805332:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  805336:	48 89 c7             	mov    %rax,%rdi
  805339:	48 b8 a8 36 80 00 00 	movabs $0x8036a8,%rax
  805340:	00 00 00 
  805343:	ff d0                	callq  *%rax
  805345:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805348:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80534c:	0f 88 5d 01 00 00    	js     8054af <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  805352:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805356:	ba 07 04 00 00       	mov    $0x407,%edx
  80535b:	48 89 c6             	mov    %rax,%rsi
  80535e:	bf 00 00 00 00       	mov    $0x0,%edi
  805363:	48 b8 6e 2a 80 00 00 	movabs $0x802a6e,%rax
  80536a:	00 00 00 
  80536d:	ff d0                	callq  *%rax
  80536f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805372:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805376:	0f 88 33 01 00 00    	js     8054af <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80537c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805380:	48 89 c7             	mov    %rax,%rdi
  805383:	48 b8 7d 36 80 00 00 	movabs $0x80367d,%rax
  80538a:	00 00 00 
  80538d:	ff d0                	callq  *%rax
  80538f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  805393:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805397:	ba 07 04 00 00       	mov    $0x407,%edx
  80539c:	48 89 c6             	mov    %rax,%rsi
  80539f:	bf 00 00 00 00       	mov    $0x0,%edi
  8053a4:	48 b8 6e 2a 80 00 00 	movabs $0x802a6e,%rax
  8053ab:	00 00 00 
  8053ae:	ff d0                	callq  *%rax
  8053b0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8053b3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8053b7:	79 05                	jns    8053be <pipe+0xe3>
		goto err2;
  8053b9:	e9 d9 00 00 00       	jmpq   805497 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8053be:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8053c2:	48 89 c7             	mov    %rax,%rdi
  8053c5:	48 b8 7d 36 80 00 00 	movabs $0x80367d,%rax
  8053cc:	00 00 00 
  8053cf:	ff d0                	callq  *%rax
  8053d1:	48 89 c2             	mov    %rax,%rdx
  8053d4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8053d8:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8053de:	48 89 d1             	mov    %rdx,%rcx
  8053e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8053e6:	48 89 c6             	mov    %rax,%rsi
  8053e9:	bf 00 00 00 00       	mov    $0x0,%edi
  8053ee:	48 b8 be 2a 80 00 00 	movabs $0x802abe,%rax
  8053f5:	00 00 00 
  8053f8:	ff d0                	callq  *%rax
  8053fa:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8053fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805401:	79 1b                	jns    80541e <pipe+0x143>
		goto err3;
  805403:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  805404:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805408:	48 89 c6             	mov    %rax,%rsi
  80540b:	bf 00 00 00 00       	mov    $0x0,%edi
  805410:	48 b8 19 2b 80 00 00 	movabs $0x802b19,%rax
  805417:	00 00 00 
  80541a:	ff d0                	callq  *%rax
  80541c:	eb 79                	jmp    805497 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80541e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805422:	48 ba c0 80 80 00 00 	movabs $0x8080c0,%rdx
  805429:	00 00 00 
  80542c:	8b 12                	mov    (%rdx),%edx
  80542e:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  805430:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805434:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80543b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80543f:	48 ba c0 80 80 00 00 	movabs $0x8080c0,%rdx
  805446:	00 00 00 
  805449:	8b 12                	mov    (%rdx),%edx
  80544b:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80544d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805451:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  805458:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80545c:	48 89 c7             	mov    %rax,%rdi
  80545f:	48 b8 5a 36 80 00 00 	movabs $0x80365a,%rax
  805466:	00 00 00 
  805469:	ff d0                	callq  *%rax
  80546b:	89 c2                	mov    %eax,%edx
  80546d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  805471:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  805473:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  805477:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80547b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80547f:	48 89 c7             	mov    %rax,%rdi
  805482:	48 b8 5a 36 80 00 00 	movabs $0x80365a,%rax
  805489:	00 00 00 
  80548c:	ff d0                	callq  *%rax
  80548e:	89 03                	mov    %eax,(%rbx)
	return 0;
  805490:	b8 00 00 00 00       	mov    $0x0,%eax
  805495:	eb 33                	jmp    8054ca <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  805497:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80549b:	48 89 c6             	mov    %rax,%rsi
  80549e:	bf 00 00 00 00       	mov    $0x0,%edi
  8054a3:	48 b8 19 2b 80 00 00 	movabs $0x802b19,%rax
  8054aa:	00 00 00 
  8054ad:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  8054af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8054b3:	48 89 c6             	mov    %rax,%rsi
  8054b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8054bb:	48 b8 19 2b 80 00 00 	movabs $0x802b19,%rax
  8054c2:	00 00 00 
  8054c5:	ff d0                	callq  *%rax
    err:
	return r;
  8054c7:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8054ca:	48 83 c4 38          	add    $0x38,%rsp
  8054ce:	5b                   	pop    %rbx
  8054cf:	5d                   	pop    %rbp
  8054d0:	c3                   	retq   

00000000008054d1 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8054d1:	55                   	push   %rbp
  8054d2:	48 89 e5             	mov    %rsp,%rbp
  8054d5:	53                   	push   %rbx
  8054d6:	48 83 ec 28          	sub    $0x28,%rsp
  8054da:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8054de:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8054e2:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  8054e9:	00 00 00 
  8054ec:	48 8b 00             	mov    (%rax),%rax
  8054ef:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8054f5:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8054f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8054fc:	48 89 c7             	mov    %rax,%rdi
  8054ff:	48 b8 6b 5c 80 00 00 	movabs $0x805c6b,%rax
  805506:	00 00 00 
  805509:	ff d0                	callq  *%rax
  80550b:	89 c3                	mov    %eax,%ebx
  80550d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805511:	48 89 c7             	mov    %rax,%rdi
  805514:	48 b8 6b 5c 80 00 00 	movabs $0x805c6b,%rax
  80551b:	00 00 00 
  80551e:	ff d0                	callq  *%rax
  805520:	39 c3                	cmp    %eax,%ebx
  805522:	0f 94 c0             	sete   %al
  805525:	0f b6 c0             	movzbl %al,%eax
  805528:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80552b:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  805532:	00 00 00 
  805535:	48 8b 00             	mov    (%rax),%rax
  805538:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80553e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  805541:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805544:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  805547:	75 05                	jne    80554e <_pipeisclosed+0x7d>
			return ret;
  805549:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80554c:	eb 4f                	jmp    80559d <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80554e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805551:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  805554:	74 42                	je     805598 <_pipeisclosed+0xc7>
  805556:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80555a:	75 3c                	jne    805598 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80555c:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  805563:	00 00 00 
  805566:	48 8b 00             	mov    (%rax),%rax
  805569:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80556f:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  805572:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805575:	89 c6                	mov    %eax,%esi
  805577:	48 bf d5 66 80 00 00 	movabs $0x8066d5,%rdi
  80557e:	00 00 00 
  805581:	b8 00 00 00 00       	mov    $0x0,%eax
  805586:	49 b8 30 14 80 00 00 	movabs $0x801430,%r8
  80558d:	00 00 00 
  805590:	41 ff d0             	callq  *%r8
	}
  805593:	e9 4a ff ff ff       	jmpq   8054e2 <_pipeisclosed+0x11>
  805598:	e9 45 ff ff ff       	jmpq   8054e2 <_pipeisclosed+0x11>
}
  80559d:	48 83 c4 28          	add    $0x28,%rsp
  8055a1:	5b                   	pop    %rbx
  8055a2:	5d                   	pop    %rbp
  8055a3:	c3                   	retq   

00000000008055a4 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8055a4:	55                   	push   %rbp
  8055a5:	48 89 e5             	mov    %rsp,%rbp
  8055a8:	48 83 ec 30          	sub    $0x30,%rsp
  8055ac:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8055af:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8055b3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8055b6:	48 89 d6             	mov    %rdx,%rsi
  8055b9:	89 c7                	mov    %eax,%edi
  8055bb:	48 b8 40 37 80 00 00 	movabs $0x803740,%rax
  8055c2:	00 00 00 
  8055c5:	ff d0                	callq  *%rax
  8055c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8055ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8055ce:	79 05                	jns    8055d5 <pipeisclosed+0x31>
		return r;
  8055d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8055d3:	eb 31                	jmp    805606 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8055d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8055d9:	48 89 c7             	mov    %rax,%rdi
  8055dc:	48 b8 7d 36 80 00 00 	movabs $0x80367d,%rax
  8055e3:	00 00 00 
  8055e6:	ff d0                	callq  *%rax
  8055e8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8055ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8055f0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8055f4:	48 89 d6             	mov    %rdx,%rsi
  8055f7:	48 89 c7             	mov    %rax,%rdi
  8055fa:	48 b8 d1 54 80 00 00 	movabs $0x8054d1,%rax
  805601:	00 00 00 
  805604:	ff d0                	callq  *%rax
}
  805606:	c9                   	leaveq 
  805607:	c3                   	retq   

0000000000805608 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  805608:	55                   	push   %rbp
  805609:	48 89 e5             	mov    %rsp,%rbp
  80560c:	48 83 ec 40          	sub    $0x40,%rsp
  805610:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  805614:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  805618:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80561c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805620:	48 89 c7             	mov    %rax,%rdi
  805623:	48 b8 7d 36 80 00 00 	movabs $0x80367d,%rax
  80562a:	00 00 00 
  80562d:	ff d0                	callq  *%rax
  80562f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  805633:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805637:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80563b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  805642:	00 
  805643:	e9 92 00 00 00       	jmpq   8056da <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  805648:	eb 41                	jmp    80568b <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80564a:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80564f:	74 09                	je     80565a <devpipe_read+0x52>
				return i;
  805651:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805655:	e9 92 00 00 00       	jmpq   8056ec <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80565a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80565e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805662:	48 89 d6             	mov    %rdx,%rsi
  805665:	48 89 c7             	mov    %rax,%rdi
  805668:	48 b8 d1 54 80 00 00 	movabs $0x8054d1,%rax
  80566f:	00 00 00 
  805672:	ff d0                	callq  *%rax
  805674:	85 c0                	test   %eax,%eax
  805676:	74 07                	je     80567f <devpipe_read+0x77>
				return 0;
  805678:	b8 00 00 00 00       	mov    $0x0,%eax
  80567d:	eb 6d                	jmp    8056ec <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80567f:	48 b8 30 2a 80 00 00 	movabs $0x802a30,%rax
  805686:	00 00 00 
  805689:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80568b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80568f:	8b 10                	mov    (%rax),%edx
  805691:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805695:	8b 40 04             	mov    0x4(%rax),%eax
  805698:	39 c2                	cmp    %eax,%edx
  80569a:	74 ae                	je     80564a <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80569c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8056a0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8056a4:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8056a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8056ac:	8b 00                	mov    (%rax),%eax
  8056ae:	99                   	cltd   
  8056af:	c1 ea 1b             	shr    $0x1b,%edx
  8056b2:	01 d0                	add    %edx,%eax
  8056b4:	83 e0 1f             	and    $0x1f,%eax
  8056b7:	29 d0                	sub    %edx,%eax
  8056b9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8056bd:	48 98                	cltq   
  8056bf:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8056c4:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8056c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8056ca:	8b 00                	mov    (%rax),%eax
  8056cc:	8d 50 01             	lea    0x1(%rax),%edx
  8056cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8056d3:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8056d5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8056da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8056de:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8056e2:	0f 82 60 ff ff ff    	jb     805648 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8056e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8056ec:	c9                   	leaveq 
  8056ed:	c3                   	retq   

00000000008056ee <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8056ee:	55                   	push   %rbp
  8056ef:	48 89 e5             	mov    %rsp,%rbp
  8056f2:	48 83 ec 40          	sub    $0x40,%rsp
  8056f6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8056fa:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8056fe:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  805702:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805706:	48 89 c7             	mov    %rax,%rdi
  805709:	48 b8 7d 36 80 00 00 	movabs $0x80367d,%rax
  805710:	00 00 00 
  805713:	ff d0                	callq  *%rax
  805715:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  805719:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80571d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  805721:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  805728:	00 
  805729:	e9 8e 00 00 00       	jmpq   8057bc <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80572e:	eb 31                	jmp    805761 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  805730:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805734:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805738:	48 89 d6             	mov    %rdx,%rsi
  80573b:	48 89 c7             	mov    %rax,%rdi
  80573e:	48 b8 d1 54 80 00 00 	movabs $0x8054d1,%rax
  805745:	00 00 00 
  805748:	ff d0                	callq  *%rax
  80574a:	85 c0                	test   %eax,%eax
  80574c:	74 07                	je     805755 <devpipe_write+0x67>
				return 0;
  80574e:	b8 00 00 00 00       	mov    $0x0,%eax
  805753:	eb 79                	jmp    8057ce <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  805755:	48 b8 30 2a 80 00 00 	movabs $0x802a30,%rax
  80575c:	00 00 00 
  80575f:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  805761:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805765:	8b 40 04             	mov    0x4(%rax),%eax
  805768:	48 63 d0             	movslq %eax,%rdx
  80576b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80576f:	8b 00                	mov    (%rax),%eax
  805771:	48 98                	cltq   
  805773:	48 83 c0 20          	add    $0x20,%rax
  805777:	48 39 c2             	cmp    %rax,%rdx
  80577a:	73 b4                	jae    805730 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80577c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805780:	8b 40 04             	mov    0x4(%rax),%eax
  805783:	99                   	cltd   
  805784:	c1 ea 1b             	shr    $0x1b,%edx
  805787:	01 d0                	add    %edx,%eax
  805789:	83 e0 1f             	and    $0x1f,%eax
  80578c:	29 d0                	sub    %edx,%eax
  80578e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  805792:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  805796:	48 01 ca             	add    %rcx,%rdx
  805799:	0f b6 0a             	movzbl (%rdx),%ecx
  80579c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8057a0:	48 98                	cltq   
  8057a2:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8057a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8057aa:	8b 40 04             	mov    0x4(%rax),%eax
  8057ad:	8d 50 01             	lea    0x1(%rax),%edx
  8057b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8057b4:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8057b7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8057bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8057c0:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8057c4:	0f 82 64 ff ff ff    	jb     80572e <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8057ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8057ce:	c9                   	leaveq 
  8057cf:	c3                   	retq   

00000000008057d0 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8057d0:	55                   	push   %rbp
  8057d1:	48 89 e5             	mov    %rsp,%rbp
  8057d4:	48 83 ec 20          	sub    $0x20,%rsp
  8057d8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8057dc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8057e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8057e4:	48 89 c7             	mov    %rax,%rdi
  8057e7:	48 b8 7d 36 80 00 00 	movabs $0x80367d,%rax
  8057ee:	00 00 00 
  8057f1:	ff d0                	callq  *%rax
  8057f3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8057f7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8057fb:	48 be e8 66 80 00 00 	movabs $0x8066e8,%rsi
  805802:	00 00 00 
  805805:	48 89 c7             	mov    %rax,%rdi
  805808:	48 b8 3f 21 80 00 00 	movabs $0x80213f,%rax
  80580f:	00 00 00 
  805812:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  805814:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805818:	8b 50 04             	mov    0x4(%rax),%edx
  80581b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80581f:	8b 00                	mov    (%rax),%eax
  805821:	29 c2                	sub    %eax,%edx
  805823:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805827:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80582d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805831:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  805838:	00 00 00 
	stat->st_dev = &devpipe;
  80583b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80583f:	48 b9 c0 80 80 00 00 	movabs $0x8080c0,%rcx
  805846:	00 00 00 
  805849:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  805850:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805855:	c9                   	leaveq 
  805856:	c3                   	retq   

0000000000805857 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  805857:	55                   	push   %rbp
  805858:	48 89 e5             	mov    %rsp,%rbp
  80585b:	48 83 ec 10          	sub    $0x10,%rsp
  80585f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  805863:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805867:	48 89 c6             	mov    %rax,%rsi
  80586a:	bf 00 00 00 00       	mov    $0x0,%edi
  80586f:	48 b8 19 2b 80 00 00 	movabs $0x802b19,%rax
  805876:	00 00 00 
  805879:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80587b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80587f:	48 89 c7             	mov    %rax,%rdi
  805882:	48 b8 7d 36 80 00 00 	movabs $0x80367d,%rax
  805889:	00 00 00 
  80588c:	ff d0                	callq  *%rax
  80588e:	48 89 c6             	mov    %rax,%rsi
  805891:	bf 00 00 00 00       	mov    $0x0,%edi
  805896:	48 b8 19 2b 80 00 00 	movabs $0x802b19,%rax
  80589d:	00 00 00 
  8058a0:	ff d0                	callq  *%rax
}
  8058a2:	c9                   	leaveq 
  8058a3:	c3                   	retq   

00000000008058a4 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8058a4:	55                   	push   %rbp
  8058a5:	48 89 e5             	mov    %rsp,%rbp
  8058a8:	48 83 ec 20          	sub    $0x20,%rsp
  8058ac:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  8058af:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8058b3:	75 35                	jne    8058ea <wait+0x46>
  8058b5:	48 b9 ef 66 80 00 00 	movabs $0x8066ef,%rcx
  8058bc:	00 00 00 
  8058bf:	48 ba fa 66 80 00 00 	movabs $0x8066fa,%rdx
  8058c6:	00 00 00 
  8058c9:	be 09 00 00 00       	mov    $0x9,%esi
  8058ce:	48 bf 0f 67 80 00 00 	movabs $0x80670f,%rdi
  8058d5:	00 00 00 
  8058d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8058dd:	49 b8 f7 11 80 00 00 	movabs $0x8011f7,%r8
  8058e4:	00 00 00 
  8058e7:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  8058ea:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8058ed:	25 ff 03 00 00       	and    $0x3ff,%eax
  8058f2:	48 63 d0             	movslq %eax,%rdx
  8058f5:	48 89 d0             	mov    %rdx,%rax
  8058f8:	48 c1 e0 03          	shl    $0x3,%rax
  8058fc:	48 01 d0             	add    %rdx,%rax
  8058ff:	48 c1 e0 05          	shl    $0x5,%rax
  805903:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80590a:	00 00 00 
  80590d:	48 01 d0             	add    %rdx,%rax
  805910:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE){
  805914:	eb 0c                	jmp    805922 <wait+0x7e>
	//cprintf("envid is [%d]",envid);
		sys_yield();
  805916:	48 b8 30 2a 80 00 00 	movabs $0x802a30,%rax
  80591d:	00 00 00 
  805920:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE){
  805922:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805926:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80592c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80592f:	75 0e                	jne    80593f <wait+0x9b>
  805931:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805935:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  80593b:	85 c0                	test   %eax,%eax
  80593d:	75 d7                	jne    805916 <wait+0x72>
	//cprintf("envid is [%d]",envid);
		sys_yield();
	}
}
  80593f:	c9                   	leaveq 
  805940:	c3                   	retq   

0000000000805941 <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  805941:	55                   	push   %rbp
  805942:	48 89 e5             	mov    %rsp,%rbp
  805945:	48 83 ec 10          	sub    $0x10,%rsp
  805949:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  80594d:	48 b8 08 b0 80 00 00 	movabs $0x80b008,%rax
  805954:	00 00 00 
  805957:	48 8b 00             	mov    (%rax),%rax
  80595a:	48 85 c0             	test   %rax,%rax
  80595d:	0f 85 84 00 00 00    	jne    8059e7 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  805963:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  80596a:	00 00 00 
  80596d:	48 8b 00             	mov    (%rax),%rax
  805970:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  805976:	ba 07 00 00 00       	mov    $0x7,%edx
  80597b:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  805980:	89 c7                	mov    %eax,%edi
  805982:	48 b8 6e 2a 80 00 00 	movabs $0x802a6e,%rax
  805989:	00 00 00 
  80598c:	ff d0                	callq  *%rax
  80598e:	85 c0                	test   %eax,%eax
  805990:	79 2a                	jns    8059bc <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  805992:	48 ba 20 67 80 00 00 	movabs $0x806720,%rdx
  805999:	00 00 00 
  80599c:	be 23 00 00 00       	mov    $0x23,%esi
  8059a1:	48 bf 47 67 80 00 00 	movabs $0x806747,%rdi
  8059a8:	00 00 00 
  8059ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8059b0:	48 b9 f7 11 80 00 00 	movabs $0x8011f7,%rcx
  8059b7:	00 00 00 
  8059ba:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  8059bc:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  8059c3:	00 00 00 
  8059c6:	48 8b 00             	mov    (%rax),%rax
  8059c9:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8059cf:	48 be fa 59 80 00 00 	movabs $0x8059fa,%rsi
  8059d6:	00 00 00 
  8059d9:	89 c7                	mov    %eax,%edi
  8059db:	48 b8 f8 2b 80 00 00 	movabs $0x802bf8,%rax
  8059e2:	00 00 00 
  8059e5:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  8059e7:	48 b8 08 b0 80 00 00 	movabs $0x80b008,%rax
  8059ee:	00 00 00 
  8059f1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8059f5:	48 89 10             	mov    %rdx,(%rax)
}
  8059f8:	c9                   	leaveq 
  8059f9:	c3                   	retq   

00000000008059fa <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  8059fa:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  8059fd:	48 a1 08 b0 80 00 00 	movabs 0x80b008,%rax
  805a04:	00 00 00 
	call *%rax
  805a07:	ff d0                	callq  *%rax


	/*This code is to be removed*/

	// LAB 4: Your code here.
	movq 136(%rsp), %rbx  //Load RIP 
  805a09:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  805a10:	00 
	movq 152(%rsp), %rcx  //Load RSP
  805a11:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  805a18:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  805a19:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  805a1d:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  805a20:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  805a27:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  805a28:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  805a2c:	4c 8b 3c 24          	mov    (%rsp),%r15
  805a30:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  805a35:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  805a3a:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  805a3f:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  805a44:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  805a49:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  805a4e:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  805a53:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  805a58:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  805a5d:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  805a62:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  805a67:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  805a6c:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  805a71:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  805a76:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  805a7a:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  805a7e:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  805a7f:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  805a80:	c3                   	retq   

0000000000805a81 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  805a81:	55                   	push   %rbp
  805a82:	48 89 e5             	mov    %rsp,%rbp
  805a85:	48 83 ec 30          	sub    $0x30,%rsp
  805a89:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805a8d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805a91:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  805a95:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  805a9c:	00 00 00 
  805a9f:	48 8b 00             	mov    (%rax),%rax
  805aa2:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  805aa8:	85 c0                	test   %eax,%eax
  805aaa:	75 3c                	jne    805ae8 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  805aac:	48 b8 f2 29 80 00 00 	movabs $0x8029f2,%rax
  805ab3:	00 00 00 
  805ab6:	ff d0                	callq  *%rax
  805ab8:	25 ff 03 00 00       	and    $0x3ff,%eax
  805abd:	48 63 d0             	movslq %eax,%rdx
  805ac0:	48 89 d0             	mov    %rdx,%rax
  805ac3:	48 c1 e0 03          	shl    $0x3,%rax
  805ac7:	48 01 d0             	add    %rdx,%rax
  805aca:	48 c1 e0 05          	shl    $0x5,%rax
  805ace:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  805ad5:	00 00 00 
  805ad8:	48 01 c2             	add    %rax,%rdx
  805adb:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  805ae2:	00 00 00 
  805ae5:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  805ae8:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  805aed:	75 0e                	jne    805afd <ipc_recv+0x7c>
		pg = (void*) UTOP;
  805aef:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  805af6:	00 00 00 
  805af9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  805afd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805b01:	48 89 c7             	mov    %rax,%rdi
  805b04:	48 b8 97 2c 80 00 00 	movabs $0x802c97,%rax
  805b0b:	00 00 00 
  805b0e:	ff d0                	callq  *%rax
  805b10:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  805b13:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805b17:	79 19                	jns    805b32 <ipc_recv+0xb1>
		*from_env_store = 0;
  805b19:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805b1d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  805b23:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805b27:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  805b2d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805b30:	eb 53                	jmp    805b85 <ipc_recv+0x104>
	}
	if(from_env_store)
  805b32:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  805b37:	74 19                	je     805b52 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  805b39:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  805b40:	00 00 00 
  805b43:	48 8b 00             	mov    (%rax),%rax
  805b46:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  805b4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805b50:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  805b52:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  805b57:	74 19                	je     805b72 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  805b59:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  805b60:	00 00 00 
  805b63:	48 8b 00             	mov    (%rax),%rax
  805b66:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  805b6c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805b70:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  805b72:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  805b79:	00 00 00 
  805b7c:	48 8b 00             	mov    (%rax),%rax
  805b7f:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  805b85:	c9                   	leaveq 
  805b86:	c3                   	retq   

0000000000805b87 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  805b87:	55                   	push   %rbp
  805b88:	48 89 e5             	mov    %rsp,%rbp
  805b8b:	48 83 ec 30          	sub    $0x30,%rsp
  805b8f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805b92:	89 75 e8             	mov    %esi,-0x18(%rbp)
  805b95:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  805b99:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  805b9c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  805ba1:	75 0e                	jne    805bb1 <ipc_send+0x2a>
		pg = (void*)UTOP;
  805ba3:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  805baa:	00 00 00 
  805bad:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  805bb1:	8b 75 e8             	mov    -0x18(%rbp),%esi
  805bb4:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  805bb7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  805bbb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805bbe:	89 c7                	mov    %eax,%edi
  805bc0:	48 b8 42 2c 80 00 00 	movabs $0x802c42,%rax
  805bc7:	00 00 00 
  805bca:	ff d0                	callq  *%rax
  805bcc:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  805bcf:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  805bd3:	75 0c                	jne    805be1 <ipc_send+0x5a>
			sys_yield();
  805bd5:	48 b8 30 2a 80 00 00 	movabs $0x802a30,%rax
  805bdc:	00 00 00 
  805bdf:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  805be1:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  805be5:	74 ca                	je     805bb1 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  805be7:	c9                   	leaveq 
  805be8:	c3                   	retq   

0000000000805be9 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  805be9:	55                   	push   %rbp
  805bea:	48 89 e5             	mov    %rsp,%rbp
  805bed:	48 83 ec 14          	sub    $0x14,%rsp
  805bf1:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  805bf4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  805bfb:	eb 5e                	jmp    805c5b <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  805bfd:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  805c04:	00 00 00 
  805c07:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805c0a:	48 63 d0             	movslq %eax,%rdx
  805c0d:	48 89 d0             	mov    %rdx,%rax
  805c10:	48 c1 e0 03          	shl    $0x3,%rax
  805c14:	48 01 d0             	add    %rdx,%rax
  805c17:	48 c1 e0 05          	shl    $0x5,%rax
  805c1b:	48 01 c8             	add    %rcx,%rax
  805c1e:	48 05 d0 00 00 00    	add    $0xd0,%rax
  805c24:	8b 00                	mov    (%rax),%eax
  805c26:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  805c29:	75 2c                	jne    805c57 <ipc_find_env+0x6e>
			return envs[i].env_id;
  805c2b:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  805c32:	00 00 00 
  805c35:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805c38:	48 63 d0             	movslq %eax,%rdx
  805c3b:	48 89 d0             	mov    %rdx,%rax
  805c3e:	48 c1 e0 03          	shl    $0x3,%rax
  805c42:	48 01 d0             	add    %rdx,%rax
  805c45:	48 c1 e0 05          	shl    $0x5,%rax
  805c49:	48 01 c8             	add    %rcx,%rax
  805c4c:	48 05 c0 00 00 00    	add    $0xc0,%rax
  805c52:	8b 40 08             	mov    0x8(%rax),%eax
  805c55:	eb 12                	jmp    805c69 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  805c57:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  805c5b:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  805c62:	7e 99                	jle    805bfd <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  805c64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805c69:	c9                   	leaveq 
  805c6a:	c3                   	retq   

0000000000805c6b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  805c6b:	55                   	push   %rbp
  805c6c:	48 89 e5             	mov    %rsp,%rbp
  805c6f:	48 83 ec 18          	sub    $0x18,%rsp
  805c73:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  805c77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805c7b:	48 c1 e8 15          	shr    $0x15,%rax
  805c7f:	48 89 c2             	mov    %rax,%rdx
  805c82:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  805c89:	01 00 00 
  805c8c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805c90:	83 e0 01             	and    $0x1,%eax
  805c93:	48 85 c0             	test   %rax,%rax
  805c96:	75 07                	jne    805c9f <pageref+0x34>
		return 0;
  805c98:	b8 00 00 00 00       	mov    $0x0,%eax
  805c9d:	eb 53                	jmp    805cf2 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  805c9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805ca3:	48 c1 e8 0c          	shr    $0xc,%rax
  805ca7:	48 89 c2             	mov    %rax,%rdx
  805caa:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805cb1:	01 00 00 
  805cb4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805cb8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  805cbc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805cc0:	83 e0 01             	and    $0x1,%eax
  805cc3:	48 85 c0             	test   %rax,%rax
  805cc6:	75 07                	jne    805ccf <pageref+0x64>
		return 0;
  805cc8:	b8 00 00 00 00       	mov    $0x0,%eax
  805ccd:	eb 23                	jmp    805cf2 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  805ccf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805cd3:	48 c1 e8 0c          	shr    $0xc,%rax
  805cd7:	48 89 c2             	mov    %rax,%rdx
  805cda:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  805ce1:	00 00 00 
  805ce4:	48 c1 e2 04          	shl    $0x4,%rdx
  805ce8:	48 01 d0             	add    %rdx,%rax
  805ceb:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  805cef:	0f b7 c0             	movzwl %ax,%eax
}
  805cf2:	c9                   	leaveq 
  805cf3:	c3                   	retq   
