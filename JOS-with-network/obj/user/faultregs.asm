
obj/user/faultregs.debug:     file format elf64-x86-64


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
  80003c:	e8 f5 09 00 00       	callq  800a36 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <check_regs>:
static struct regs before, during, after;

static void
check_regs(struct regs* a, const char *an, struct regs* b, const char *bn,
	   const char *testname)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 40          	sub    $0x40,%rsp
  80004b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80004f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800053:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800057:	48 89 4d d0          	mov    %rcx,-0x30(%rbp)
  80005b:	4c 89 45 c8          	mov    %r8,-0x38(%rbp)
	int mismatch = 0;
  80005f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

	cprintf("%-6s %-8s %-8s\n", "", an, bn);
  800066:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80006a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80006e:	48 89 d1             	mov    %rdx,%rcx
  800071:	48 89 c2             	mov    %rax,%rdx
  800074:	48 be 80 49 80 00 00 	movabs $0x804980,%rsi
  80007b:	00 00 00 
  80007e:	48 bf 81 49 80 00 00 	movabs $0x804981,%rdi
  800085:	00 00 00 
  800088:	b8 00 00 00 00       	mov    $0x0,%eax
  80008d:	49 b8 1d 0d 80 00 00 	movabs $0x800d1d,%r8
  800094:	00 00 00 
  800097:	41 ff d0             	callq  *%r8
			cprintf("MISMATCH\n");				\
			mismatch = 1;					\
		}							\
	} while (0)

	CHECK(edi, regs.reg_rdi);
  80009a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80009e:	48 8b 50 48          	mov    0x48(%rax),%rdx
  8000a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8000a6:	48 8b 40 48          	mov    0x48(%rax),%rax
  8000aa:	48 89 d1             	mov    %rdx,%rcx
  8000ad:	48 89 c2             	mov    %rax,%rdx
  8000b0:	48 be 91 49 80 00 00 	movabs $0x804991,%rsi
  8000b7:	00 00 00 
  8000ba:	48 bf 95 49 80 00 00 	movabs $0x804995,%rdi
  8000c1:	00 00 00 
  8000c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c9:	49 b8 1d 0d 80 00 00 	movabs $0x800d1d,%r8
  8000d0:	00 00 00 
  8000d3:	41 ff d0             	callq  *%r8
  8000d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8000da:	48 8b 50 48          	mov    0x48(%rax),%rdx
  8000de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8000e2:	48 8b 40 48          	mov    0x48(%rax),%rax
  8000e6:	48 39 c2             	cmp    %rax,%rdx
  8000e9:	75 1d                	jne    800108 <check_regs+0xc5>
  8000eb:	48 bf a5 49 80 00 00 	movabs $0x8049a5,%rdi
  8000f2:	00 00 00 
  8000f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000fa:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  800101:	00 00 00 
  800104:	ff d2                	callq  *%rdx
  800106:	eb 22                	jmp    80012a <check_regs+0xe7>
  800108:	48 bf a9 49 80 00 00 	movabs $0x8049a9,%rdi
  80010f:	00 00 00 
  800112:	b8 00 00 00 00       	mov    $0x0,%eax
  800117:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  80011e:	00 00 00 
  800121:	ff d2                	callq  *%rdx
  800123:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(esi, regs.reg_rsi);
  80012a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80012e:	48 8b 50 40          	mov    0x40(%rax),%rdx
  800132:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800136:	48 8b 40 40          	mov    0x40(%rax),%rax
  80013a:	48 89 d1             	mov    %rdx,%rcx
  80013d:	48 89 c2             	mov    %rax,%rdx
  800140:	48 be b3 49 80 00 00 	movabs $0x8049b3,%rsi
  800147:	00 00 00 
  80014a:	48 bf 95 49 80 00 00 	movabs $0x804995,%rdi
  800151:	00 00 00 
  800154:	b8 00 00 00 00       	mov    $0x0,%eax
  800159:	49 b8 1d 0d 80 00 00 	movabs $0x800d1d,%r8
  800160:	00 00 00 
  800163:	41 ff d0             	callq  *%r8
  800166:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80016a:	48 8b 50 40          	mov    0x40(%rax),%rdx
  80016e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800172:	48 8b 40 40          	mov    0x40(%rax),%rax
  800176:	48 39 c2             	cmp    %rax,%rdx
  800179:	75 1d                	jne    800198 <check_regs+0x155>
  80017b:	48 bf a5 49 80 00 00 	movabs $0x8049a5,%rdi
  800182:	00 00 00 
  800185:	b8 00 00 00 00       	mov    $0x0,%eax
  80018a:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  800191:	00 00 00 
  800194:	ff d2                	callq  *%rdx
  800196:	eb 22                	jmp    8001ba <check_regs+0x177>
  800198:	48 bf a9 49 80 00 00 	movabs $0x8049a9,%rdi
  80019f:	00 00 00 
  8001a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a7:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  8001ae:	00 00 00 
  8001b1:	ff d2                	callq  *%rdx
  8001b3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(ebp, regs.reg_rbp);
  8001ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8001be:	48 8b 50 50          	mov    0x50(%rax),%rdx
  8001c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8001c6:	48 8b 40 50          	mov    0x50(%rax),%rax
  8001ca:	48 89 d1             	mov    %rdx,%rcx
  8001cd:	48 89 c2             	mov    %rax,%rdx
  8001d0:	48 be b7 49 80 00 00 	movabs $0x8049b7,%rsi
  8001d7:	00 00 00 
  8001da:	48 bf 95 49 80 00 00 	movabs $0x804995,%rdi
  8001e1:	00 00 00 
  8001e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e9:	49 b8 1d 0d 80 00 00 	movabs $0x800d1d,%r8
  8001f0:	00 00 00 
  8001f3:	41 ff d0             	callq  *%r8
  8001f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8001fa:	48 8b 50 50          	mov    0x50(%rax),%rdx
  8001fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800202:	48 8b 40 50          	mov    0x50(%rax),%rax
  800206:	48 39 c2             	cmp    %rax,%rdx
  800209:	75 1d                	jne    800228 <check_regs+0x1e5>
  80020b:	48 bf a5 49 80 00 00 	movabs $0x8049a5,%rdi
  800212:	00 00 00 
  800215:	b8 00 00 00 00       	mov    $0x0,%eax
  80021a:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  800221:	00 00 00 
  800224:	ff d2                	callq  *%rdx
  800226:	eb 22                	jmp    80024a <check_regs+0x207>
  800228:	48 bf a9 49 80 00 00 	movabs $0x8049a9,%rdi
  80022f:	00 00 00 
  800232:	b8 00 00 00 00       	mov    $0x0,%eax
  800237:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  80023e:	00 00 00 
  800241:	ff d2                	callq  *%rdx
  800243:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(ebx, regs.reg_rbx);
  80024a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80024e:	48 8b 50 68          	mov    0x68(%rax),%rdx
  800252:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800256:	48 8b 40 68          	mov    0x68(%rax),%rax
  80025a:	48 89 d1             	mov    %rdx,%rcx
  80025d:	48 89 c2             	mov    %rax,%rdx
  800260:	48 be bb 49 80 00 00 	movabs $0x8049bb,%rsi
  800267:	00 00 00 
  80026a:	48 bf 95 49 80 00 00 	movabs $0x804995,%rdi
  800271:	00 00 00 
  800274:	b8 00 00 00 00       	mov    $0x0,%eax
  800279:	49 b8 1d 0d 80 00 00 	movabs $0x800d1d,%r8
  800280:	00 00 00 
  800283:	41 ff d0             	callq  *%r8
  800286:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80028a:	48 8b 50 68          	mov    0x68(%rax),%rdx
  80028e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800292:	48 8b 40 68          	mov    0x68(%rax),%rax
  800296:	48 39 c2             	cmp    %rax,%rdx
  800299:	75 1d                	jne    8002b8 <check_regs+0x275>
  80029b:	48 bf a5 49 80 00 00 	movabs $0x8049a5,%rdi
  8002a2:	00 00 00 
  8002a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8002aa:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  8002b1:	00 00 00 
  8002b4:	ff d2                	callq  *%rdx
  8002b6:	eb 22                	jmp    8002da <check_regs+0x297>
  8002b8:	48 bf a9 49 80 00 00 	movabs $0x8049a9,%rdi
  8002bf:	00 00 00 
  8002c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c7:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  8002ce:	00 00 00 
  8002d1:	ff d2                	callq  *%rdx
  8002d3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(edx, regs.reg_rdx);
  8002da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8002de:	48 8b 50 58          	mov    0x58(%rax),%rdx
  8002e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002e6:	48 8b 40 58          	mov    0x58(%rax),%rax
  8002ea:	48 89 d1             	mov    %rdx,%rcx
  8002ed:	48 89 c2             	mov    %rax,%rdx
  8002f0:	48 be bf 49 80 00 00 	movabs $0x8049bf,%rsi
  8002f7:	00 00 00 
  8002fa:	48 bf 95 49 80 00 00 	movabs $0x804995,%rdi
  800301:	00 00 00 
  800304:	b8 00 00 00 00       	mov    $0x0,%eax
  800309:	49 b8 1d 0d 80 00 00 	movabs $0x800d1d,%r8
  800310:	00 00 00 
  800313:	41 ff d0             	callq  *%r8
  800316:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80031a:	48 8b 50 58          	mov    0x58(%rax),%rdx
  80031e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800322:	48 8b 40 58          	mov    0x58(%rax),%rax
  800326:	48 39 c2             	cmp    %rax,%rdx
  800329:	75 1d                	jne    800348 <check_regs+0x305>
  80032b:	48 bf a5 49 80 00 00 	movabs $0x8049a5,%rdi
  800332:	00 00 00 
  800335:	b8 00 00 00 00       	mov    $0x0,%eax
  80033a:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  800341:	00 00 00 
  800344:	ff d2                	callq  *%rdx
  800346:	eb 22                	jmp    80036a <check_regs+0x327>
  800348:	48 bf a9 49 80 00 00 	movabs $0x8049a9,%rdi
  80034f:	00 00 00 
  800352:	b8 00 00 00 00       	mov    $0x0,%eax
  800357:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  80035e:	00 00 00 
  800361:	ff d2                	callq  *%rdx
  800363:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(ecx, regs.reg_rcx);
  80036a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80036e:	48 8b 50 60          	mov    0x60(%rax),%rdx
  800372:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800376:	48 8b 40 60          	mov    0x60(%rax),%rax
  80037a:	48 89 d1             	mov    %rdx,%rcx
  80037d:	48 89 c2             	mov    %rax,%rdx
  800380:	48 be c3 49 80 00 00 	movabs $0x8049c3,%rsi
  800387:	00 00 00 
  80038a:	48 bf 95 49 80 00 00 	movabs $0x804995,%rdi
  800391:	00 00 00 
  800394:	b8 00 00 00 00       	mov    $0x0,%eax
  800399:	49 b8 1d 0d 80 00 00 	movabs $0x800d1d,%r8
  8003a0:	00 00 00 
  8003a3:	41 ff d0             	callq  *%r8
  8003a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003aa:	48 8b 50 60          	mov    0x60(%rax),%rdx
  8003ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8003b2:	48 8b 40 60          	mov    0x60(%rax),%rax
  8003b6:	48 39 c2             	cmp    %rax,%rdx
  8003b9:	75 1d                	jne    8003d8 <check_regs+0x395>
  8003bb:	48 bf a5 49 80 00 00 	movabs $0x8049a5,%rdi
  8003c2:	00 00 00 
  8003c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ca:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  8003d1:	00 00 00 
  8003d4:	ff d2                	callq  *%rdx
  8003d6:	eb 22                	jmp    8003fa <check_regs+0x3b7>
  8003d8:	48 bf a9 49 80 00 00 	movabs $0x8049a9,%rdi
  8003df:	00 00 00 
  8003e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8003e7:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  8003ee:	00 00 00 
  8003f1:	ff d2                	callq  *%rdx
  8003f3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(eax, regs.reg_rax);
  8003fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8003fe:	48 8b 50 70          	mov    0x70(%rax),%rdx
  800402:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800406:	48 8b 40 70          	mov    0x70(%rax),%rax
  80040a:	48 89 d1             	mov    %rdx,%rcx
  80040d:	48 89 c2             	mov    %rax,%rdx
  800410:	48 be c7 49 80 00 00 	movabs $0x8049c7,%rsi
  800417:	00 00 00 
  80041a:	48 bf 95 49 80 00 00 	movabs $0x804995,%rdi
  800421:	00 00 00 
  800424:	b8 00 00 00 00       	mov    $0x0,%eax
  800429:	49 b8 1d 0d 80 00 00 	movabs $0x800d1d,%r8
  800430:	00 00 00 
  800433:	41 ff d0             	callq  *%r8
  800436:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80043a:	48 8b 50 70          	mov    0x70(%rax),%rdx
  80043e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800442:	48 8b 40 70          	mov    0x70(%rax),%rax
  800446:	48 39 c2             	cmp    %rax,%rdx
  800449:	75 1d                	jne    800468 <check_regs+0x425>
  80044b:	48 bf a5 49 80 00 00 	movabs $0x8049a5,%rdi
  800452:	00 00 00 
  800455:	b8 00 00 00 00       	mov    $0x0,%eax
  80045a:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  800461:	00 00 00 
  800464:	ff d2                	callq  *%rdx
  800466:	eb 22                	jmp    80048a <check_regs+0x447>
  800468:	48 bf a9 49 80 00 00 	movabs $0x8049a9,%rdi
  80046f:	00 00 00 
  800472:	b8 00 00 00 00       	mov    $0x0,%eax
  800477:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  80047e:	00 00 00 
  800481:	ff d2                	callq  *%rdx
  800483:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(eip, eip);
  80048a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80048e:	48 8b 50 78          	mov    0x78(%rax),%rdx
  800492:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800496:	48 8b 40 78          	mov    0x78(%rax),%rax
  80049a:	48 89 d1             	mov    %rdx,%rcx
  80049d:	48 89 c2             	mov    %rax,%rdx
  8004a0:	48 be cb 49 80 00 00 	movabs $0x8049cb,%rsi
  8004a7:	00 00 00 
  8004aa:	48 bf 95 49 80 00 00 	movabs $0x804995,%rdi
  8004b1:	00 00 00 
  8004b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b9:	49 b8 1d 0d 80 00 00 	movabs $0x800d1d,%r8
  8004c0:	00 00 00 
  8004c3:	41 ff d0             	callq  *%r8
  8004c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ca:	48 8b 50 78          	mov    0x78(%rax),%rdx
  8004ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004d2:	48 8b 40 78          	mov    0x78(%rax),%rax
  8004d6:	48 39 c2             	cmp    %rax,%rdx
  8004d9:	75 1d                	jne    8004f8 <check_regs+0x4b5>
  8004db:	48 bf a5 49 80 00 00 	movabs $0x8049a5,%rdi
  8004e2:	00 00 00 
  8004e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ea:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  8004f1:	00 00 00 
  8004f4:	ff d2                	callq  *%rdx
  8004f6:	eb 22                	jmp    80051a <check_regs+0x4d7>
  8004f8:	48 bf a9 49 80 00 00 	movabs $0x8049a9,%rdi
  8004ff:	00 00 00 
  800502:	b8 00 00 00 00       	mov    $0x0,%eax
  800507:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  80050e:	00 00 00 
  800511:	ff d2                	callq  *%rdx
  800513:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(eflags, eflags);
  80051a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80051e:	48 8b 90 80 00 00 00 	mov    0x80(%rax),%rdx
  800525:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800529:	48 8b 80 80 00 00 00 	mov    0x80(%rax),%rax
  800530:	48 89 d1             	mov    %rdx,%rcx
  800533:	48 89 c2             	mov    %rax,%rdx
  800536:	48 be cf 49 80 00 00 	movabs $0x8049cf,%rsi
  80053d:	00 00 00 
  800540:	48 bf 95 49 80 00 00 	movabs $0x804995,%rdi
  800547:	00 00 00 
  80054a:	b8 00 00 00 00       	mov    $0x0,%eax
  80054f:	49 b8 1d 0d 80 00 00 	movabs $0x800d1d,%r8
  800556:	00 00 00 
  800559:	41 ff d0             	callq  *%r8
  80055c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800560:	48 8b 90 80 00 00 00 	mov    0x80(%rax),%rdx
  800567:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80056b:	48 8b 80 80 00 00 00 	mov    0x80(%rax),%rax
  800572:	48 39 c2             	cmp    %rax,%rdx
  800575:	75 1d                	jne    800594 <check_regs+0x551>
  800577:	48 bf a5 49 80 00 00 	movabs $0x8049a5,%rdi
  80057e:	00 00 00 
  800581:	b8 00 00 00 00       	mov    $0x0,%eax
  800586:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  80058d:	00 00 00 
  800590:	ff d2                	callq  *%rdx
  800592:	eb 22                	jmp    8005b6 <check_regs+0x573>
  800594:	48 bf a9 49 80 00 00 	movabs $0x8049a9,%rdi
  80059b:	00 00 00 
  80059e:	b8 00 00 00 00       	mov    $0x0,%eax
  8005a3:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  8005aa:	00 00 00 
  8005ad:	ff d2                	callq  *%rdx
  8005af:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(esp, esp);
  8005b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005ba:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  8005c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c5:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
  8005cc:	48 89 d1             	mov    %rdx,%rcx
  8005cf:	48 89 c2             	mov    %rax,%rdx
  8005d2:	48 be d6 49 80 00 00 	movabs $0x8049d6,%rsi
  8005d9:	00 00 00 
  8005dc:	48 bf 95 49 80 00 00 	movabs $0x804995,%rdi
  8005e3:	00 00 00 
  8005e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8005eb:	49 b8 1d 0d 80 00 00 	movabs $0x800d1d,%r8
  8005f2:	00 00 00 
  8005f5:	41 ff d0             	callq  *%r8
  8005f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005fc:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  800603:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800607:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
  80060e:	48 39 c2             	cmp    %rax,%rdx
  800611:	75 1d                	jne    800630 <check_regs+0x5ed>
  800613:	48 bf a5 49 80 00 00 	movabs $0x8049a5,%rdi
  80061a:	00 00 00 
  80061d:	b8 00 00 00 00       	mov    $0x0,%eax
  800622:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  800629:	00 00 00 
  80062c:	ff d2                	callq  *%rdx
  80062e:	eb 22                	jmp    800652 <check_regs+0x60f>
  800630:	48 bf a9 49 80 00 00 	movabs $0x8049a9,%rdi
  800637:	00 00 00 
  80063a:	b8 00 00 00 00       	mov    $0x0,%eax
  80063f:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  800646:	00 00 00 
  800649:	ff d2                	callq  *%rdx
  80064b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

#undef CHECK


	if (!mismatch)
  800652:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800656:	75 24                	jne    80067c <check_regs+0x639>
		cprintf("Registers %s OK\n", testname);
  800658:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80065c:	48 89 c6             	mov    %rax,%rsi
  80065f:	48 bf da 49 80 00 00 	movabs $0x8049da,%rdi
  800666:	00 00 00 
  800669:	b8 00 00 00 00       	mov    $0x0,%eax
  80066e:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  800675:	00 00 00 
  800678:	ff d2                	callq  *%rdx
  80067a:	eb 22                	jmp    80069e <check_regs+0x65b>
	else
		cprintf("Registers %s MISMATCH\n", testname);
  80067c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800680:	48 89 c6             	mov    %rax,%rsi
  800683:	48 bf eb 49 80 00 00 	movabs $0x8049eb,%rdi
  80068a:	00 00 00 
  80068d:	b8 00 00 00 00       	mov    $0x0,%eax
  800692:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  800699:	00 00 00 
  80069c:	ff d2                	callq  *%rdx
}
  80069e:	c9                   	leaveq 
  80069f:	c3                   	retq   

00000000008006a0 <pgfault>:

static void
pgfault(struct UTrapframe *utf)
{
  8006a0:	55                   	push   %rbp
  8006a1:	48 89 e5             	mov    %rsp,%rbp
  8006a4:	48 83 ec 20          	sub    $0x20,%rsp
  8006a8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (utf->utf_fault_va != (uint64_t)UTEMP)
  8006ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b0:	48 8b 00             	mov    (%rax),%rax
  8006b3:	48 3d 00 00 40 00    	cmp    $0x400000,%rax
  8006b9:	74 43                	je     8006fe <pgfault+0x5e>
		panic("pgfault expected at UTEMP, got 0x%08x (eip %08x)",
  8006bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006bf:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  8006c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ca:	48 8b 00             	mov    (%rax),%rax
  8006cd:	49 89 d0             	mov    %rdx,%r8
  8006d0:	48 89 c1             	mov    %rax,%rcx
  8006d3:	48 ba 08 4a 80 00 00 	movabs $0x804a08,%rdx
  8006da:	00 00 00 
  8006dd:	be 5f 00 00 00       	mov    $0x5f,%esi
  8006e2:	48 bf 39 4a 80 00 00 	movabs $0x804a39,%rdi
  8006e9:	00 00 00 
  8006ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f1:	49 b9 e4 0a 80 00 00 	movabs $0x800ae4,%r9
  8006f8:	00 00 00 
  8006fb:	41 ff d1             	callq  *%r9
		      utf->utf_fault_va, utf->utf_rip);

	// Check registers in UTrapframe
	during.regs = utf->utf_regs;
  8006fe:	48 b8 a0 80 80 00 00 	movabs $0x8080a0,%rax
  800705:	00 00 00 
  800708:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80070c:	48 8b 4a 10          	mov    0x10(%rdx),%rcx
  800710:	48 89 08             	mov    %rcx,(%rax)
  800713:	48 8b 4a 18          	mov    0x18(%rdx),%rcx
  800717:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80071b:	48 8b 4a 20          	mov    0x20(%rdx),%rcx
  80071f:	48 89 48 10          	mov    %rcx,0x10(%rax)
  800723:	48 8b 4a 28          	mov    0x28(%rdx),%rcx
  800727:	48 89 48 18          	mov    %rcx,0x18(%rax)
  80072b:	48 8b 4a 30          	mov    0x30(%rdx),%rcx
  80072f:	48 89 48 20          	mov    %rcx,0x20(%rax)
  800733:	48 8b 4a 38          	mov    0x38(%rdx),%rcx
  800737:	48 89 48 28          	mov    %rcx,0x28(%rax)
  80073b:	48 8b 4a 40          	mov    0x40(%rdx),%rcx
  80073f:	48 89 48 30          	mov    %rcx,0x30(%rax)
  800743:	48 8b 4a 48          	mov    0x48(%rdx),%rcx
  800747:	48 89 48 38          	mov    %rcx,0x38(%rax)
  80074b:	48 8b 4a 50          	mov    0x50(%rdx),%rcx
  80074f:	48 89 48 40          	mov    %rcx,0x40(%rax)
  800753:	48 8b 4a 58          	mov    0x58(%rdx),%rcx
  800757:	48 89 48 48          	mov    %rcx,0x48(%rax)
  80075b:	48 8b 4a 60          	mov    0x60(%rdx),%rcx
  80075f:	48 89 48 50          	mov    %rcx,0x50(%rax)
  800763:	48 8b 4a 68          	mov    0x68(%rdx),%rcx
  800767:	48 89 48 58          	mov    %rcx,0x58(%rax)
  80076b:	48 8b 4a 70          	mov    0x70(%rdx),%rcx
  80076f:	48 89 48 60          	mov    %rcx,0x60(%rax)
  800773:	48 8b 4a 78          	mov    0x78(%rdx),%rcx
  800777:	48 89 48 68          	mov    %rcx,0x68(%rax)
  80077b:	48 8b 92 80 00 00 00 	mov    0x80(%rdx),%rdx
  800782:	48 89 50 70          	mov    %rdx,0x70(%rax)
	during.eip = utf->utf_rip;
  800786:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078a:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  800791:	48 b8 a0 80 80 00 00 	movabs $0x8080a0,%rax
  800798:	00 00 00 
  80079b:	48 89 50 78          	mov    %rdx,0x78(%rax)
	during.eflags = utf->utf_eflags & 0xfff;
  80079f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a3:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
  8007aa:	25 ff 0f 00 00       	and    $0xfff,%eax
  8007af:	48 89 c2             	mov    %rax,%rdx
  8007b2:	48 b8 a0 80 80 00 00 	movabs $0x8080a0,%rax
  8007b9:	00 00 00 
  8007bc:	48 89 90 80 00 00 00 	mov    %rdx,0x80(%rax)
	during.esp = utf->utf_rsp;
  8007c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c7:	48 8b 90 98 00 00 00 	mov    0x98(%rax),%rdx
  8007ce:	48 b8 a0 80 80 00 00 	movabs $0x8080a0,%rax
  8007d5:	00 00 00 
  8007d8:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	check_regs(&before, "before", &during, "during", "in UTrapframe");
  8007df:	49 b8 4a 4a 80 00 00 	movabs $0x804a4a,%r8
  8007e6:	00 00 00 
  8007e9:	48 b9 58 4a 80 00 00 	movabs $0x804a58,%rcx
  8007f0:	00 00 00 
  8007f3:	48 ba a0 80 80 00 00 	movabs $0x8080a0,%rdx
  8007fa:	00 00 00 
  8007fd:	48 be 5f 4a 80 00 00 	movabs $0x804a5f,%rsi
  800804:	00 00 00 
  800807:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80080e:	00 00 00 
  800811:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800818:	00 00 00 
  80081b:	ff d0                	callq  *%rax

	// Map UTEMP so the write succeeds
	if ((r = sys_page_alloc(0, UTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  80081d:	ba 07 00 00 00       	mov    $0x7,%edx
  800822:	be 00 00 40 00       	mov    $0x400000,%esi
  800827:	bf 00 00 00 00       	mov    $0x0,%edi
  80082c:	48 b8 01 22 80 00 00 	movabs $0x802201,%rax
  800833:	00 00 00 
  800836:	ff d0                	callq  *%rax
  800838:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80083b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80083f:	79 30                	jns    800871 <pgfault+0x1d1>
		panic("sys_page_alloc: %e", r);
  800841:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800844:	89 c1                	mov    %eax,%ecx
  800846:	48 ba 66 4a 80 00 00 	movabs $0x804a66,%rdx
  80084d:	00 00 00 
  800850:	be 6a 00 00 00       	mov    $0x6a,%esi
  800855:	48 bf 39 4a 80 00 00 	movabs $0x804a39,%rdi
  80085c:	00 00 00 
  80085f:	b8 00 00 00 00       	mov    $0x0,%eax
  800864:	49 b8 e4 0a 80 00 00 	movabs $0x800ae4,%r8
  80086b:	00 00 00 
  80086e:	41 ff d0             	callq  *%r8
}
  800871:	c9                   	leaveq 
  800872:	c3                   	retq   

0000000000800873 <umain>:

void
umain(int argc, char **argv)
{
  800873:	55                   	push   %rbp
  800874:	48 89 e5             	mov    %rsp,%rbp
  800877:	48 83 ec 10          	sub    $0x10,%rsp
  80087b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80087e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	set_pgfault_handler(pgfault);
  800882:	48 bf a0 06 80 00 00 	movabs $0x8006a0,%rdi
  800889:	00 00 00 
  80088c:	48 b8 38 25 80 00 00 	movabs $0x802538,%rax
  800893:	00 00 00 
  800896:	ff d0                	callq  *%rax

	__asm __volatile(
  800898:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80089f:	00 00 00 
  8008a2:	48 ba 40 81 80 00 00 	movabs $0x808140,%rdx
  8008a9:	00 00 00 
  8008ac:	50                   	push   %rax
  8008ad:	52                   	push   %rdx
  8008ae:	50                   	push   %rax
  8008af:	9c                   	pushfq 
  8008b0:	58                   	pop    %rax
  8008b1:	48 0d d4 08 00 00    	or     $0x8d4,%rax
  8008b7:	50                   	push   %rax
  8008b8:	9d                   	popfq  
  8008b9:	4c 8b 7c 24 10       	mov    0x10(%rsp),%r15
  8008be:	49 89 87 80 00 00 00 	mov    %rax,0x80(%r15)
  8008c5:	48 8d 04 25 11 09 80 	lea    0x800911,%rax
  8008cc:	00 
  8008cd:	49 89 47 78          	mov    %rax,0x78(%r15)
  8008d1:	58                   	pop    %rax
  8008d2:	4d 89 77 08          	mov    %r14,0x8(%r15)
  8008d6:	4d 89 6f 10          	mov    %r13,0x10(%r15)
  8008da:	4d 89 67 18          	mov    %r12,0x18(%r15)
  8008de:	4d 89 5f 20          	mov    %r11,0x20(%r15)
  8008e2:	4d 89 57 28          	mov    %r10,0x28(%r15)
  8008e6:	4d 89 4f 30          	mov    %r9,0x30(%r15)
  8008ea:	4d 89 47 38          	mov    %r8,0x38(%r15)
  8008ee:	49 89 77 40          	mov    %rsi,0x40(%r15)
  8008f2:	49 89 7f 48          	mov    %rdi,0x48(%r15)
  8008f6:	49 89 6f 50          	mov    %rbp,0x50(%r15)
  8008fa:	49 89 57 58          	mov    %rdx,0x58(%r15)
  8008fe:	49 89 4f 60          	mov    %rcx,0x60(%r15)
  800902:	49 89 5f 68          	mov    %rbx,0x68(%r15)
  800906:	49 89 47 70          	mov    %rax,0x70(%r15)
  80090a:	49 89 a7 88 00 00 00 	mov    %rsp,0x88(%r15)
  800911:	c7 04 25 00 00 40 00 	movl   $0x2a,0x400000
  800918:	2a 00 00 00 
  80091c:	4c 8b 3c 24          	mov    (%rsp),%r15
  800920:	4d 89 77 08          	mov    %r14,0x8(%r15)
  800924:	4d 89 6f 10          	mov    %r13,0x10(%r15)
  800928:	4d 89 67 18          	mov    %r12,0x18(%r15)
  80092c:	4d 89 5f 20          	mov    %r11,0x20(%r15)
  800930:	4d 89 57 28          	mov    %r10,0x28(%r15)
  800934:	4d 89 4f 30          	mov    %r9,0x30(%r15)
  800938:	4d 89 47 38          	mov    %r8,0x38(%r15)
  80093c:	49 89 77 40          	mov    %rsi,0x40(%r15)
  800940:	49 89 7f 48          	mov    %rdi,0x48(%r15)
  800944:	49 89 6f 50          	mov    %rbp,0x50(%r15)
  800948:	49 89 57 58          	mov    %rdx,0x58(%r15)
  80094c:	49 89 4f 60          	mov    %rcx,0x60(%r15)
  800950:	49 89 5f 68          	mov    %rbx,0x68(%r15)
  800954:	49 89 47 70          	mov    %rax,0x70(%r15)
  800958:	49 89 a7 88 00 00 00 	mov    %rsp,0x88(%r15)
  80095f:	4c 8b 7c 24 08       	mov    0x8(%rsp),%r15
  800964:	4d 8b 77 08          	mov    0x8(%r15),%r14
  800968:	4d 8b 6f 10          	mov    0x10(%r15),%r13
  80096c:	4d 8b 67 18          	mov    0x18(%r15),%r12
  800970:	4d 8b 5f 20          	mov    0x20(%r15),%r11
  800974:	4d 8b 57 28          	mov    0x28(%r15),%r10
  800978:	4d 8b 4f 30          	mov    0x30(%r15),%r9
  80097c:	4d 8b 47 38          	mov    0x38(%r15),%r8
  800980:	49 8b 77 40          	mov    0x40(%r15),%rsi
  800984:	49 8b 7f 48          	mov    0x48(%r15),%rdi
  800988:	49 8b 6f 50          	mov    0x50(%r15),%rbp
  80098c:	49 8b 57 58          	mov    0x58(%r15),%rdx
  800990:	49 8b 4f 60          	mov    0x60(%r15),%rcx
  800994:	49 8b 5f 68          	mov    0x68(%r15),%rbx
  800998:	49 8b 47 70          	mov    0x70(%r15),%rax
  80099c:	49 8b a7 88 00 00 00 	mov    0x88(%r15),%rsp
  8009a3:	50                   	push   %rax
  8009a4:	9c                   	pushfq 
  8009a5:	58                   	pop    %rax
  8009a6:	4c 8b 7c 24 08       	mov    0x8(%rsp),%r15
  8009ab:	49 89 87 80 00 00 00 	mov    %rax,0x80(%r15)
  8009b2:	58                   	pop    %rax
		: : "r" (&before), "r" (&after) : "memory", "cc");

	// Check UTEMP to roughly determine that EIP was restored
	// correctly (of course, we probably wouldn't get this far if
	// it weren't)
	if (*(int*)UTEMP != 42)
  8009b3:	b8 00 00 40 00       	mov    $0x400000,%eax
  8009b8:	8b 00                	mov    (%rax),%eax
  8009ba:	83 f8 2a             	cmp    $0x2a,%eax
  8009bd:	74 1b                	je     8009da <umain+0x167>
		cprintf("EIP after page-fault MISMATCH\n");
  8009bf:	48 bf 80 4a 80 00 00 	movabs $0x804a80,%rdi
  8009c6:	00 00 00 
  8009c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ce:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  8009d5:	00 00 00 
  8009d8:	ff d2                	callq  *%rdx
	after.eip = before.eip;
  8009da:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8009e1:	00 00 00 
  8009e4:	48 8b 50 78          	mov    0x78(%rax),%rdx
  8009e8:	48 b8 40 81 80 00 00 	movabs $0x808140,%rax
  8009ef:	00 00 00 
  8009f2:	48 89 50 78          	mov    %rdx,0x78(%rax)

	check_regs(&before, "before", &after, "after", "after page-fault");
  8009f6:	49 b8 9f 4a 80 00 00 	movabs $0x804a9f,%r8
  8009fd:	00 00 00 
  800a00:	48 b9 b0 4a 80 00 00 	movabs $0x804ab0,%rcx
  800a07:	00 00 00 
  800a0a:	48 ba 40 81 80 00 00 	movabs $0x808140,%rdx
  800a11:	00 00 00 
  800a14:	48 be 5f 4a 80 00 00 	movabs $0x804a5f,%rsi
  800a1b:	00 00 00 
  800a1e:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  800a25:	00 00 00 
  800a28:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800a2f:	00 00 00 
  800a32:	ff d0                	callq  *%rax
}
  800a34:	c9                   	leaveq 
  800a35:	c3                   	retq   

0000000000800a36 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800a36:	55                   	push   %rbp
  800a37:	48 89 e5             	mov    %rsp,%rbp
  800a3a:	48 83 ec 10          	sub    $0x10,%rsp
  800a3e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800a41:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800a45:	48 b8 85 21 80 00 00 	movabs $0x802185,%rax
  800a4c:	00 00 00 
  800a4f:	ff d0                	callq  *%rax
  800a51:	25 ff 03 00 00       	and    $0x3ff,%eax
  800a56:	48 63 d0             	movslq %eax,%rdx
  800a59:	48 89 d0             	mov    %rdx,%rax
  800a5c:	48 c1 e0 03          	shl    $0x3,%rax
  800a60:	48 01 d0             	add    %rdx,%rax
  800a63:	48 c1 e0 05          	shl    $0x5,%rax
  800a67:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800a6e:	00 00 00 
  800a71:	48 01 c2             	add    %rax,%rdx
  800a74:	48 b8 d8 81 80 00 00 	movabs $0x8081d8,%rax
  800a7b:	00 00 00 
  800a7e:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a81:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800a85:	7e 14                	jle    800a9b <libmain+0x65>
		binaryname = argv[0];
  800a87:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a8b:	48 8b 10             	mov    (%rax),%rdx
  800a8e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800a95:	00 00 00 
  800a98:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800a9b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800aa2:	48 89 d6             	mov    %rdx,%rsi
  800aa5:	89 c7                	mov    %eax,%edi
  800aa7:	48 b8 73 08 80 00 00 	movabs $0x800873,%rax
  800aae:	00 00 00 
  800ab1:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  800ab3:	48 b8 c1 0a 80 00 00 	movabs $0x800ac1,%rax
  800aba:	00 00 00 
  800abd:	ff d0                	callq  *%rax
}
  800abf:	c9                   	leaveq 
  800ac0:	c3                   	retq   

0000000000800ac1 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800ac1:	55                   	push   %rbp
  800ac2:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800ac5:	48 b8 b9 29 80 00 00 	movabs $0x8029b9,%rax
  800acc:	00 00 00 
  800acf:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800ad1:	bf 00 00 00 00       	mov    $0x0,%edi
  800ad6:	48 b8 41 21 80 00 00 	movabs $0x802141,%rax
  800add:	00 00 00 
  800ae0:	ff d0                	callq  *%rax

}
  800ae2:	5d                   	pop    %rbp
  800ae3:	c3                   	retq   

0000000000800ae4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800ae4:	55                   	push   %rbp
  800ae5:	48 89 e5             	mov    %rsp,%rbp
  800ae8:	53                   	push   %rbx
  800ae9:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800af0:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800af7:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800afd:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800b04:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800b0b:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800b12:	84 c0                	test   %al,%al
  800b14:	74 23                	je     800b39 <_panic+0x55>
  800b16:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800b1d:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800b21:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800b25:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800b29:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800b2d:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800b31:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800b35:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800b39:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800b40:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800b47:	00 00 00 
  800b4a:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800b51:	00 00 00 
  800b54:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b58:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800b5f:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800b66:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800b6d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800b74:	00 00 00 
  800b77:	48 8b 18             	mov    (%rax),%rbx
  800b7a:	48 b8 85 21 80 00 00 	movabs $0x802185,%rax
  800b81:	00 00 00 
  800b84:	ff d0                	callq  *%rax
  800b86:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800b8c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800b93:	41 89 c8             	mov    %ecx,%r8d
  800b96:	48 89 d1             	mov    %rdx,%rcx
  800b99:	48 89 da             	mov    %rbx,%rdx
  800b9c:	89 c6                	mov    %eax,%esi
  800b9e:	48 bf c0 4a 80 00 00 	movabs $0x804ac0,%rdi
  800ba5:	00 00 00 
  800ba8:	b8 00 00 00 00       	mov    $0x0,%eax
  800bad:	49 b9 1d 0d 80 00 00 	movabs $0x800d1d,%r9
  800bb4:	00 00 00 
  800bb7:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800bba:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800bc1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800bc8:	48 89 d6             	mov    %rdx,%rsi
  800bcb:	48 89 c7             	mov    %rax,%rdi
  800bce:	48 b8 71 0c 80 00 00 	movabs $0x800c71,%rax
  800bd5:	00 00 00 
  800bd8:	ff d0                	callq  *%rax
	cprintf("\n");
  800bda:	48 bf e3 4a 80 00 00 	movabs $0x804ae3,%rdi
  800be1:	00 00 00 
  800be4:	b8 00 00 00 00       	mov    $0x0,%eax
  800be9:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  800bf0:	00 00 00 
  800bf3:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800bf5:	cc                   	int3   
  800bf6:	eb fd                	jmp    800bf5 <_panic+0x111>

0000000000800bf8 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800bf8:	55                   	push   %rbp
  800bf9:	48 89 e5             	mov    %rsp,%rbp
  800bfc:	48 83 ec 10          	sub    $0x10,%rsp
  800c00:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c03:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800c07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c0b:	8b 00                	mov    (%rax),%eax
  800c0d:	8d 48 01             	lea    0x1(%rax),%ecx
  800c10:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c14:	89 0a                	mov    %ecx,(%rdx)
  800c16:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c19:	89 d1                	mov    %edx,%ecx
  800c1b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c1f:	48 98                	cltq   
  800c21:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800c25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c29:	8b 00                	mov    (%rax),%eax
  800c2b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800c30:	75 2c                	jne    800c5e <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800c32:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c36:	8b 00                	mov    (%rax),%eax
  800c38:	48 98                	cltq   
  800c3a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c3e:	48 83 c2 08          	add    $0x8,%rdx
  800c42:	48 89 c6             	mov    %rax,%rsi
  800c45:	48 89 d7             	mov    %rdx,%rdi
  800c48:	48 b8 b9 20 80 00 00 	movabs $0x8020b9,%rax
  800c4f:	00 00 00 
  800c52:	ff d0                	callq  *%rax
        b->idx = 0;
  800c54:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c58:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800c5e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c62:	8b 40 04             	mov    0x4(%rax),%eax
  800c65:	8d 50 01             	lea    0x1(%rax),%edx
  800c68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c6c:	89 50 04             	mov    %edx,0x4(%rax)
}
  800c6f:	c9                   	leaveq 
  800c70:	c3                   	retq   

0000000000800c71 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800c71:	55                   	push   %rbp
  800c72:	48 89 e5             	mov    %rsp,%rbp
  800c75:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800c7c:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800c83:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800c8a:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800c91:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800c98:	48 8b 0a             	mov    (%rdx),%rcx
  800c9b:	48 89 08             	mov    %rcx,(%rax)
  800c9e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ca2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ca6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800caa:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800cae:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800cb5:	00 00 00 
    b.cnt = 0;
  800cb8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800cbf:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800cc2:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800cc9:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800cd0:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800cd7:	48 89 c6             	mov    %rax,%rsi
  800cda:	48 bf f8 0b 80 00 00 	movabs $0x800bf8,%rdi
  800ce1:	00 00 00 
  800ce4:	48 b8 d0 10 80 00 00 	movabs $0x8010d0,%rax
  800ceb:	00 00 00 
  800cee:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800cf0:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800cf6:	48 98                	cltq   
  800cf8:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800cff:	48 83 c2 08          	add    $0x8,%rdx
  800d03:	48 89 c6             	mov    %rax,%rsi
  800d06:	48 89 d7             	mov    %rdx,%rdi
  800d09:	48 b8 b9 20 80 00 00 	movabs $0x8020b9,%rax
  800d10:	00 00 00 
  800d13:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800d15:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800d1b:	c9                   	leaveq 
  800d1c:	c3                   	retq   

0000000000800d1d <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800d1d:	55                   	push   %rbp
  800d1e:	48 89 e5             	mov    %rsp,%rbp
  800d21:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800d28:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800d2f:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800d36:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d3d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d44:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d4b:	84 c0                	test   %al,%al
  800d4d:	74 20                	je     800d6f <cprintf+0x52>
  800d4f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d53:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d57:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d5b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d5f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d63:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d67:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d6b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d6f:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800d76:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800d7d:	00 00 00 
  800d80:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800d87:	00 00 00 
  800d8a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d8e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800d95:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d9c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800da3:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800daa:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800db1:	48 8b 0a             	mov    (%rdx),%rcx
  800db4:	48 89 08             	mov    %rcx,(%rax)
  800db7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800dbb:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800dbf:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800dc3:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800dc7:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800dce:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800dd5:	48 89 d6             	mov    %rdx,%rsi
  800dd8:	48 89 c7             	mov    %rax,%rdi
  800ddb:	48 b8 71 0c 80 00 00 	movabs $0x800c71,%rax
  800de2:	00 00 00 
  800de5:	ff d0                	callq  *%rax
  800de7:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800ded:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800df3:	c9                   	leaveq 
  800df4:	c3                   	retq   

0000000000800df5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800df5:	55                   	push   %rbp
  800df6:	48 89 e5             	mov    %rsp,%rbp
  800df9:	53                   	push   %rbx
  800dfa:	48 83 ec 38          	sub    $0x38,%rsp
  800dfe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e02:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800e06:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800e0a:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800e0d:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800e11:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800e15:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800e18:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800e1c:	77 3b                	ja     800e59 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800e1e:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800e21:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800e25:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800e28:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800e2c:	ba 00 00 00 00       	mov    $0x0,%edx
  800e31:	48 f7 f3             	div    %rbx
  800e34:	48 89 c2             	mov    %rax,%rdx
  800e37:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800e3a:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800e3d:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800e41:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e45:	41 89 f9             	mov    %edi,%r9d
  800e48:	48 89 c7             	mov    %rax,%rdi
  800e4b:	48 b8 f5 0d 80 00 00 	movabs $0x800df5,%rax
  800e52:	00 00 00 
  800e55:	ff d0                	callq  *%rax
  800e57:	eb 1e                	jmp    800e77 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800e59:	eb 12                	jmp    800e6d <printnum+0x78>
			putch(padc, putdat);
  800e5b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800e5f:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800e62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e66:	48 89 ce             	mov    %rcx,%rsi
  800e69:	89 d7                	mov    %edx,%edi
  800e6b:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800e6d:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800e71:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800e75:	7f e4                	jg     800e5b <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800e77:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800e7a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800e7e:	ba 00 00 00 00       	mov    $0x0,%edx
  800e83:	48 f7 f1             	div    %rcx
  800e86:	48 89 d0             	mov    %rdx,%rax
  800e89:	48 ba f0 4c 80 00 00 	movabs $0x804cf0,%rdx
  800e90:	00 00 00 
  800e93:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800e97:	0f be d0             	movsbl %al,%edx
  800e9a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800e9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea2:	48 89 ce             	mov    %rcx,%rsi
  800ea5:	89 d7                	mov    %edx,%edi
  800ea7:	ff d0                	callq  *%rax
}
  800ea9:	48 83 c4 38          	add    $0x38,%rsp
  800ead:	5b                   	pop    %rbx
  800eae:	5d                   	pop    %rbp
  800eaf:	c3                   	retq   

0000000000800eb0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800eb0:	55                   	push   %rbp
  800eb1:	48 89 e5             	mov    %rsp,%rbp
  800eb4:	48 83 ec 1c          	sub    $0x1c,%rsp
  800eb8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ebc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800ebf:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800ec3:	7e 52                	jle    800f17 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800ec5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec9:	8b 00                	mov    (%rax),%eax
  800ecb:	83 f8 30             	cmp    $0x30,%eax
  800ece:	73 24                	jae    800ef4 <getuint+0x44>
  800ed0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ed4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ed8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800edc:	8b 00                	mov    (%rax),%eax
  800ede:	89 c0                	mov    %eax,%eax
  800ee0:	48 01 d0             	add    %rdx,%rax
  800ee3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ee7:	8b 12                	mov    (%rdx),%edx
  800ee9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800eec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ef0:	89 0a                	mov    %ecx,(%rdx)
  800ef2:	eb 17                	jmp    800f0b <getuint+0x5b>
  800ef4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ef8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800efc:	48 89 d0             	mov    %rdx,%rax
  800eff:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800f03:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f07:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800f0b:	48 8b 00             	mov    (%rax),%rax
  800f0e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800f12:	e9 a3 00 00 00       	jmpq   800fba <getuint+0x10a>
	else if (lflag)
  800f17:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800f1b:	74 4f                	je     800f6c <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800f1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f21:	8b 00                	mov    (%rax),%eax
  800f23:	83 f8 30             	cmp    $0x30,%eax
  800f26:	73 24                	jae    800f4c <getuint+0x9c>
  800f28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f2c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800f30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f34:	8b 00                	mov    (%rax),%eax
  800f36:	89 c0                	mov    %eax,%eax
  800f38:	48 01 d0             	add    %rdx,%rax
  800f3b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f3f:	8b 12                	mov    (%rdx),%edx
  800f41:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800f44:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f48:	89 0a                	mov    %ecx,(%rdx)
  800f4a:	eb 17                	jmp    800f63 <getuint+0xb3>
  800f4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f50:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800f54:	48 89 d0             	mov    %rdx,%rax
  800f57:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800f5b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f5f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800f63:	48 8b 00             	mov    (%rax),%rax
  800f66:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800f6a:	eb 4e                	jmp    800fba <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800f6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f70:	8b 00                	mov    (%rax),%eax
  800f72:	83 f8 30             	cmp    $0x30,%eax
  800f75:	73 24                	jae    800f9b <getuint+0xeb>
  800f77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f7b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800f7f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f83:	8b 00                	mov    (%rax),%eax
  800f85:	89 c0                	mov    %eax,%eax
  800f87:	48 01 d0             	add    %rdx,%rax
  800f8a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f8e:	8b 12                	mov    (%rdx),%edx
  800f90:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800f93:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f97:	89 0a                	mov    %ecx,(%rdx)
  800f99:	eb 17                	jmp    800fb2 <getuint+0x102>
  800f9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f9f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800fa3:	48 89 d0             	mov    %rdx,%rax
  800fa6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800faa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fae:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800fb2:	8b 00                	mov    (%rax),%eax
  800fb4:	89 c0                	mov    %eax,%eax
  800fb6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800fba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800fbe:	c9                   	leaveq 
  800fbf:	c3                   	retq   

0000000000800fc0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800fc0:	55                   	push   %rbp
  800fc1:	48 89 e5             	mov    %rsp,%rbp
  800fc4:	48 83 ec 1c          	sub    $0x1c,%rsp
  800fc8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fcc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800fcf:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800fd3:	7e 52                	jle    801027 <getint+0x67>
		x=va_arg(*ap, long long);
  800fd5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fd9:	8b 00                	mov    (%rax),%eax
  800fdb:	83 f8 30             	cmp    $0x30,%eax
  800fde:	73 24                	jae    801004 <getint+0x44>
  800fe0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fe4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800fe8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fec:	8b 00                	mov    (%rax),%eax
  800fee:	89 c0                	mov    %eax,%eax
  800ff0:	48 01 d0             	add    %rdx,%rax
  800ff3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ff7:	8b 12                	mov    (%rdx),%edx
  800ff9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ffc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801000:	89 0a                	mov    %ecx,(%rdx)
  801002:	eb 17                	jmp    80101b <getint+0x5b>
  801004:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801008:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80100c:	48 89 d0             	mov    %rdx,%rax
  80100f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801013:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801017:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80101b:	48 8b 00             	mov    (%rax),%rax
  80101e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801022:	e9 a3 00 00 00       	jmpq   8010ca <getint+0x10a>
	else if (lflag)
  801027:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80102b:	74 4f                	je     80107c <getint+0xbc>
		x=va_arg(*ap, long);
  80102d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801031:	8b 00                	mov    (%rax),%eax
  801033:	83 f8 30             	cmp    $0x30,%eax
  801036:	73 24                	jae    80105c <getint+0x9c>
  801038:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80103c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801040:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801044:	8b 00                	mov    (%rax),%eax
  801046:	89 c0                	mov    %eax,%eax
  801048:	48 01 d0             	add    %rdx,%rax
  80104b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80104f:	8b 12                	mov    (%rdx),%edx
  801051:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801054:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801058:	89 0a                	mov    %ecx,(%rdx)
  80105a:	eb 17                	jmp    801073 <getint+0xb3>
  80105c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801060:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801064:	48 89 d0             	mov    %rdx,%rax
  801067:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80106b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80106f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801073:	48 8b 00             	mov    (%rax),%rax
  801076:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80107a:	eb 4e                	jmp    8010ca <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80107c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801080:	8b 00                	mov    (%rax),%eax
  801082:	83 f8 30             	cmp    $0x30,%eax
  801085:	73 24                	jae    8010ab <getint+0xeb>
  801087:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80108b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80108f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801093:	8b 00                	mov    (%rax),%eax
  801095:	89 c0                	mov    %eax,%eax
  801097:	48 01 d0             	add    %rdx,%rax
  80109a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80109e:	8b 12                	mov    (%rdx),%edx
  8010a0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8010a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010a7:	89 0a                	mov    %ecx,(%rdx)
  8010a9:	eb 17                	jmp    8010c2 <getint+0x102>
  8010ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010af:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8010b3:	48 89 d0             	mov    %rdx,%rax
  8010b6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8010ba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010be:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8010c2:	8b 00                	mov    (%rax),%eax
  8010c4:	48 98                	cltq   
  8010c6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8010ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010ce:	c9                   	leaveq 
  8010cf:	c3                   	retq   

00000000008010d0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8010d0:	55                   	push   %rbp
  8010d1:	48 89 e5             	mov    %rsp,%rbp
  8010d4:	41 54                	push   %r12
  8010d6:	53                   	push   %rbx
  8010d7:	48 83 ec 60          	sub    $0x60,%rsp
  8010db:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8010df:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8010e3:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8010e7:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8010eb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8010ef:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8010f3:	48 8b 0a             	mov    (%rdx),%rcx
  8010f6:	48 89 08             	mov    %rcx,(%rax)
  8010f9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8010fd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801101:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801105:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801109:	eb 17                	jmp    801122 <vprintfmt+0x52>
			if (ch == '\0')
  80110b:	85 db                	test   %ebx,%ebx
  80110d:	0f 84 cc 04 00 00    	je     8015df <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  801113:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801117:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80111b:	48 89 d6             	mov    %rdx,%rsi
  80111e:	89 df                	mov    %ebx,%edi
  801120:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801122:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801126:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80112a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80112e:	0f b6 00             	movzbl (%rax),%eax
  801131:	0f b6 d8             	movzbl %al,%ebx
  801134:	83 fb 25             	cmp    $0x25,%ebx
  801137:	75 d2                	jne    80110b <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801139:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80113d:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  801144:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80114b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  801152:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801159:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80115d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801161:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801165:	0f b6 00             	movzbl (%rax),%eax
  801168:	0f b6 d8             	movzbl %al,%ebx
  80116b:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80116e:	83 f8 55             	cmp    $0x55,%eax
  801171:	0f 87 34 04 00 00    	ja     8015ab <vprintfmt+0x4db>
  801177:	89 c0                	mov    %eax,%eax
  801179:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801180:	00 
  801181:	48 b8 18 4d 80 00 00 	movabs $0x804d18,%rax
  801188:	00 00 00 
  80118b:	48 01 d0             	add    %rdx,%rax
  80118e:	48 8b 00             	mov    (%rax),%rax
  801191:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  801193:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  801197:	eb c0                	jmp    801159 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801199:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80119d:	eb ba                	jmp    801159 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80119f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8011a6:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8011a9:	89 d0                	mov    %edx,%eax
  8011ab:	c1 e0 02             	shl    $0x2,%eax
  8011ae:	01 d0                	add    %edx,%eax
  8011b0:	01 c0                	add    %eax,%eax
  8011b2:	01 d8                	add    %ebx,%eax
  8011b4:	83 e8 30             	sub    $0x30,%eax
  8011b7:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8011ba:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8011be:	0f b6 00             	movzbl (%rax),%eax
  8011c1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8011c4:	83 fb 2f             	cmp    $0x2f,%ebx
  8011c7:	7e 0c                	jle    8011d5 <vprintfmt+0x105>
  8011c9:	83 fb 39             	cmp    $0x39,%ebx
  8011cc:	7f 07                	jg     8011d5 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011ce:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8011d3:	eb d1                	jmp    8011a6 <vprintfmt+0xd6>
			goto process_precision;
  8011d5:	eb 58                	jmp    80122f <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8011d7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8011da:	83 f8 30             	cmp    $0x30,%eax
  8011dd:	73 17                	jae    8011f6 <vprintfmt+0x126>
  8011df:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8011e3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8011e6:	89 c0                	mov    %eax,%eax
  8011e8:	48 01 d0             	add    %rdx,%rax
  8011eb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8011ee:	83 c2 08             	add    $0x8,%edx
  8011f1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8011f4:	eb 0f                	jmp    801205 <vprintfmt+0x135>
  8011f6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8011fa:	48 89 d0             	mov    %rdx,%rax
  8011fd:	48 83 c2 08          	add    $0x8,%rdx
  801201:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801205:	8b 00                	mov    (%rax),%eax
  801207:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80120a:	eb 23                	jmp    80122f <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80120c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801210:	79 0c                	jns    80121e <vprintfmt+0x14e>
				width = 0;
  801212:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  801219:	e9 3b ff ff ff       	jmpq   801159 <vprintfmt+0x89>
  80121e:	e9 36 ff ff ff       	jmpq   801159 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  801223:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80122a:	e9 2a ff ff ff       	jmpq   801159 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80122f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801233:	79 12                	jns    801247 <vprintfmt+0x177>
				width = precision, precision = -1;
  801235:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801238:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80123b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  801242:	e9 12 ff ff ff       	jmpq   801159 <vprintfmt+0x89>
  801247:	e9 0d ff ff ff       	jmpq   801159 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  80124c:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  801250:	e9 04 ff ff ff       	jmpq   801159 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  801255:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801258:	83 f8 30             	cmp    $0x30,%eax
  80125b:	73 17                	jae    801274 <vprintfmt+0x1a4>
  80125d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801261:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801264:	89 c0                	mov    %eax,%eax
  801266:	48 01 d0             	add    %rdx,%rax
  801269:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80126c:	83 c2 08             	add    $0x8,%edx
  80126f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801272:	eb 0f                	jmp    801283 <vprintfmt+0x1b3>
  801274:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801278:	48 89 d0             	mov    %rdx,%rax
  80127b:	48 83 c2 08          	add    $0x8,%rdx
  80127f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801283:	8b 10                	mov    (%rax),%edx
  801285:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  801289:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80128d:	48 89 ce             	mov    %rcx,%rsi
  801290:	89 d7                	mov    %edx,%edi
  801292:	ff d0                	callq  *%rax
			break;
  801294:	e9 40 03 00 00       	jmpq   8015d9 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  801299:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80129c:	83 f8 30             	cmp    $0x30,%eax
  80129f:	73 17                	jae    8012b8 <vprintfmt+0x1e8>
  8012a1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8012a5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8012a8:	89 c0                	mov    %eax,%eax
  8012aa:	48 01 d0             	add    %rdx,%rax
  8012ad:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8012b0:	83 c2 08             	add    $0x8,%edx
  8012b3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8012b6:	eb 0f                	jmp    8012c7 <vprintfmt+0x1f7>
  8012b8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8012bc:	48 89 d0             	mov    %rdx,%rax
  8012bf:	48 83 c2 08          	add    $0x8,%rdx
  8012c3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8012c7:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8012c9:	85 db                	test   %ebx,%ebx
  8012cb:	79 02                	jns    8012cf <vprintfmt+0x1ff>
				err = -err;
  8012cd:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8012cf:	83 fb 15             	cmp    $0x15,%ebx
  8012d2:	7f 16                	jg     8012ea <vprintfmt+0x21a>
  8012d4:	48 b8 40 4c 80 00 00 	movabs $0x804c40,%rax
  8012db:	00 00 00 
  8012de:	48 63 d3             	movslq %ebx,%rdx
  8012e1:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8012e5:	4d 85 e4             	test   %r12,%r12
  8012e8:	75 2e                	jne    801318 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8012ea:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8012ee:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8012f2:	89 d9                	mov    %ebx,%ecx
  8012f4:	48 ba 01 4d 80 00 00 	movabs $0x804d01,%rdx
  8012fb:	00 00 00 
  8012fe:	48 89 c7             	mov    %rax,%rdi
  801301:	b8 00 00 00 00       	mov    $0x0,%eax
  801306:	49 b8 e8 15 80 00 00 	movabs $0x8015e8,%r8
  80130d:	00 00 00 
  801310:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801313:	e9 c1 02 00 00       	jmpq   8015d9 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801318:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80131c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801320:	4c 89 e1             	mov    %r12,%rcx
  801323:	48 ba 0a 4d 80 00 00 	movabs $0x804d0a,%rdx
  80132a:	00 00 00 
  80132d:	48 89 c7             	mov    %rax,%rdi
  801330:	b8 00 00 00 00       	mov    $0x0,%eax
  801335:	49 b8 e8 15 80 00 00 	movabs $0x8015e8,%r8
  80133c:	00 00 00 
  80133f:	41 ff d0             	callq  *%r8
			break;
  801342:	e9 92 02 00 00       	jmpq   8015d9 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  801347:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80134a:	83 f8 30             	cmp    $0x30,%eax
  80134d:	73 17                	jae    801366 <vprintfmt+0x296>
  80134f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801353:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801356:	89 c0                	mov    %eax,%eax
  801358:	48 01 d0             	add    %rdx,%rax
  80135b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80135e:	83 c2 08             	add    $0x8,%edx
  801361:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801364:	eb 0f                	jmp    801375 <vprintfmt+0x2a5>
  801366:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80136a:	48 89 d0             	mov    %rdx,%rax
  80136d:	48 83 c2 08          	add    $0x8,%rdx
  801371:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801375:	4c 8b 20             	mov    (%rax),%r12
  801378:	4d 85 e4             	test   %r12,%r12
  80137b:	75 0a                	jne    801387 <vprintfmt+0x2b7>
				p = "(null)";
  80137d:	49 bc 0d 4d 80 00 00 	movabs $0x804d0d,%r12
  801384:	00 00 00 
			if (width > 0 && padc != '-')
  801387:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80138b:	7e 3f                	jle    8013cc <vprintfmt+0x2fc>
  80138d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  801391:	74 39                	je     8013cc <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  801393:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801396:	48 98                	cltq   
  801398:	48 89 c6             	mov    %rax,%rsi
  80139b:	4c 89 e7             	mov    %r12,%rdi
  80139e:	48 b8 94 18 80 00 00 	movabs $0x801894,%rax
  8013a5:	00 00 00 
  8013a8:	ff d0                	callq  *%rax
  8013aa:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8013ad:	eb 17                	jmp    8013c6 <vprintfmt+0x2f6>
					putch(padc, putdat);
  8013af:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8013b3:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8013b7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013bb:	48 89 ce             	mov    %rcx,%rsi
  8013be:	89 d7                	mov    %edx,%edi
  8013c0:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8013c2:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8013c6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8013ca:	7f e3                	jg     8013af <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8013cc:	eb 37                	jmp    801405 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8013ce:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8013d2:	74 1e                	je     8013f2 <vprintfmt+0x322>
  8013d4:	83 fb 1f             	cmp    $0x1f,%ebx
  8013d7:	7e 05                	jle    8013de <vprintfmt+0x30e>
  8013d9:	83 fb 7e             	cmp    $0x7e,%ebx
  8013dc:	7e 14                	jle    8013f2 <vprintfmt+0x322>
					putch('?', putdat);
  8013de:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8013e2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013e6:	48 89 d6             	mov    %rdx,%rsi
  8013e9:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8013ee:	ff d0                	callq  *%rax
  8013f0:	eb 0f                	jmp    801401 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  8013f2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8013f6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013fa:	48 89 d6             	mov    %rdx,%rsi
  8013fd:	89 df                	mov    %ebx,%edi
  8013ff:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801401:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801405:	4c 89 e0             	mov    %r12,%rax
  801408:	4c 8d 60 01          	lea    0x1(%rax),%r12
  80140c:	0f b6 00             	movzbl (%rax),%eax
  80140f:	0f be d8             	movsbl %al,%ebx
  801412:	85 db                	test   %ebx,%ebx
  801414:	74 10                	je     801426 <vprintfmt+0x356>
  801416:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80141a:	78 b2                	js     8013ce <vprintfmt+0x2fe>
  80141c:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  801420:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801424:	79 a8                	jns    8013ce <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801426:	eb 16                	jmp    80143e <vprintfmt+0x36e>
				putch(' ', putdat);
  801428:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80142c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801430:	48 89 d6             	mov    %rdx,%rsi
  801433:	bf 20 00 00 00       	mov    $0x20,%edi
  801438:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80143a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80143e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801442:	7f e4                	jg     801428 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  801444:	e9 90 01 00 00       	jmpq   8015d9 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801449:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80144d:	be 03 00 00 00       	mov    $0x3,%esi
  801452:	48 89 c7             	mov    %rax,%rdi
  801455:	48 b8 c0 0f 80 00 00 	movabs $0x800fc0,%rax
  80145c:	00 00 00 
  80145f:	ff d0                	callq  *%rax
  801461:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  801465:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801469:	48 85 c0             	test   %rax,%rax
  80146c:	79 1d                	jns    80148b <vprintfmt+0x3bb>
				putch('-', putdat);
  80146e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801472:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801476:	48 89 d6             	mov    %rdx,%rsi
  801479:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80147e:	ff d0                	callq  *%rax
				num = -(long long) num;
  801480:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801484:	48 f7 d8             	neg    %rax
  801487:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  80148b:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801492:	e9 d5 00 00 00       	jmpq   80156c <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  801497:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80149b:	be 03 00 00 00       	mov    $0x3,%esi
  8014a0:	48 89 c7             	mov    %rax,%rdi
  8014a3:	48 b8 b0 0e 80 00 00 	movabs $0x800eb0,%rax
  8014aa:	00 00 00 
  8014ad:	ff d0                	callq  *%rax
  8014af:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8014b3:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8014ba:	e9 ad 00 00 00       	jmpq   80156c <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  8014bf:	8b 55 e0             	mov    -0x20(%rbp),%edx
  8014c2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8014c6:	89 d6                	mov    %edx,%esi
  8014c8:	48 89 c7             	mov    %rax,%rdi
  8014cb:	48 b8 c0 0f 80 00 00 	movabs $0x800fc0,%rax
  8014d2:	00 00 00 
  8014d5:	ff d0                	callq  *%rax
  8014d7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  8014db:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  8014e2:	e9 85 00 00 00       	jmpq   80156c <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  8014e7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8014eb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8014ef:	48 89 d6             	mov    %rdx,%rsi
  8014f2:	bf 30 00 00 00       	mov    $0x30,%edi
  8014f7:	ff d0                	callq  *%rax
			putch('x', putdat);
  8014f9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8014fd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801501:	48 89 d6             	mov    %rdx,%rsi
  801504:	bf 78 00 00 00       	mov    $0x78,%edi
  801509:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  80150b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80150e:	83 f8 30             	cmp    $0x30,%eax
  801511:	73 17                	jae    80152a <vprintfmt+0x45a>
  801513:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801517:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80151a:	89 c0                	mov    %eax,%eax
  80151c:	48 01 d0             	add    %rdx,%rax
  80151f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801522:	83 c2 08             	add    $0x8,%edx
  801525:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801528:	eb 0f                	jmp    801539 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  80152a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80152e:	48 89 d0             	mov    %rdx,%rax
  801531:	48 83 c2 08          	add    $0x8,%rdx
  801535:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801539:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80153c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801540:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801547:	eb 23                	jmp    80156c <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801549:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80154d:	be 03 00 00 00       	mov    $0x3,%esi
  801552:	48 89 c7             	mov    %rax,%rdi
  801555:	48 b8 b0 0e 80 00 00 	movabs $0x800eb0,%rax
  80155c:	00 00 00 
  80155f:	ff d0                	callq  *%rax
  801561:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801565:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80156c:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  801571:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801574:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801577:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80157b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80157f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801583:	45 89 c1             	mov    %r8d,%r9d
  801586:	41 89 f8             	mov    %edi,%r8d
  801589:	48 89 c7             	mov    %rax,%rdi
  80158c:	48 b8 f5 0d 80 00 00 	movabs $0x800df5,%rax
  801593:	00 00 00 
  801596:	ff d0                	callq  *%rax
			break;
  801598:	eb 3f                	jmp    8015d9 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  80159a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80159e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8015a2:	48 89 d6             	mov    %rdx,%rsi
  8015a5:	89 df                	mov    %ebx,%edi
  8015a7:	ff d0                	callq  *%rax
			break;
  8015a9:	eb 2e                	jmp    8015d9 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8015ab:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8015af:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8015b3:	48 89 d6             	mov    %rdx,%rsi
  8015b6:	bf 25 00 00 00       	mov    $0x25,%edi
  8015bb:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8015bd:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8015c2:	eb 05                	jmp    8015c9 <vprintfmt+0x4f9>
  8015c4:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8015c9:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8015cd:	48 83 e8 01          	sub    $0x1,%rax
  8015d1:	0f b6 00             	movzbl (%rax),%eax
  8015d4:	3c 25                	cmp    $0x25,%al
  8015d6:	75 ec                	jne    8015c4 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  8015d8:	90                   	nop
		}
	}
  8015d9:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8015da:	e9 43 fb ff ff       	jmpq   801122 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  8015df:	48 83 c4 60          	add    $0x60,%rsp
  8015e3:	5b                   	pop    %rbx
  8015e4:	41 5c                	pop    %r12
  8015e6:	5d                   	pop    %rbp
  8015e7:	c3                   	retq   

00000000008015e8 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8015e8:	55                   	push   %rbp
  8015e9:	48 89 e5             	mov    %rsp,%rbp
  8015ec:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8015f3:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8015fa:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801601:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801608:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80160f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801616:	84 c0                	test   %al,%al
  801618:	74 20                	je     80163a <printfmt+0x52>
  80161a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80161e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801622:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801626:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80162a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80162e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801632:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801636:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80163a:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801641:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801648:	00 00 00 
  80164b:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801652:	00 00 00 
  801655:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801659:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801660:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801667:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  80166e:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801675:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80167c:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801683:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80168a:	48 89 c7             	mov    %rax,%rdi
  80168d:	48 b8 d0 10 80 00 00 	movabs $0x8010d0,%rax
  801694:	00 00 00 
  801697:	ff d0                	callq  *%rax
	va_end(ap);
}
  801699:	c9                   	leaveq 
  80169a:	c3                   	retq   

000000000080169b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80169b:	55                   	push   %rbp
  80169c:	48 89 e5             	mov    %rsp,%rbp
  80169f:	48 83 ec 10          	sub    $0x10,%rsp
  8016a3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8016a6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8016aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016ae:	8b 40 10             	mov    0x10(%rax),%eax
  8016b1:	8d 50 01             	lea    0x1(%rax),%edx
  8016b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016b8:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8016bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016bf:	48 8b 10             	mov    (%rax),%rdx
  8016c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016c6:	48 8b 40 08          	mov    0x8(%rax),%rax
  8016ca:	48 39 c2             	cmp    %rax,%rdx
  8016cd:	73 17                	jae    8016e6 <sprintputch+0x4b>
		*b->buf++ = ch;
  8016cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016d3:	48 8b 00             	mov    (%rax),%rax
  8016d6:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8016da:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016de:	48 89 0a             	mov    %rcx,(%rdx)
  8016e1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8016e4:	88 10                	mov    %dl,(%rax)
}
  8016e6:	c9                   	leaveq 
  8016e7:	c3                   	retq   

00000000008016e8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8016e8:	55                   	push   %rbp
  8016e9:	48 89 e5             	mov    %rsp,%rbp
  8016ec:	48 83 ec 50          	sub    $0x50,%rsp
  8016f0:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8016f4:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8016f7:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8016fb:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8016ff:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801703:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801707:	48 8b 0a             	mov    (%rdx),%rcx
  80170a:	48 89 08             	mov    %rcx,(%rax)
  80170d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801711:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801715:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801719:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80171d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801721:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801725:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801728:	48 98                	cltq   
  80172a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80172e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801732:	48 01 d0             	add    %rdx,%rax
  801735:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801739:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801740:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801745:	74 06                	je     80174d <vsnprintf+0x65>
  801747:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80174b:	7f 07                	jg     801754 <vsnprintf+0x6c>
		return -E_INVAL;
  80174d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801752:	eb 2f                	jmp    801783 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801754:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801758:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80175c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801760:	48 89 c6             	mov    %rax,%rsi
  801763:	48 bf 9b 16 80 00 00 	movabs $0x80169b,%rdi
  80176a:	00 00 00 
  80176d:	48 b8 d0 10 80 00 00 	movabs $0x8010d0,%rax
  801774:	00 00 00 
  801777:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801779:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80177d:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801780:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801783:	c9                   	leaveq 
  801784:	c3                   	retq   

0000000000801785 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801785:	55                   	push   %rbp
  801786:	48 89 e5             	mov    %rsp,%rbp
  801789:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801790:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801797:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  80179d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8017a4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8017ab:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8017b2:	84 c0                	test   %al,%al
  8017b4:	74 20                	je     8017d6 <snprintf+0x51>
  8017b6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8017ba:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8017be:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8017c2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8017c6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8017ca:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8017ce:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8017d2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8017d6:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8017dd:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8017e4:	00 00 00 
  8017e7:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8017ee:	00 00 00 
  8017f1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8017f5:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8017fc:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801803:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80180a:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801811:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801818:	48 8b 0a             	mov    (%rdx),%rcx
  80181b:	48 89 08             	mov    %rcx,(%rax)
  80181e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801822:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801826:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80182a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80182e:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801835:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80183c:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801842:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801849:	48 89 c7             	mov    %rax,%rdi
  80184c:	48 b8 e8 16 80 00 00 	movabs $0x8016e8,%rax
  801853:	00 00 00 
  801856:	ff d0                	callq  *%rax
  801858:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80185e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801864:	c9                   	leaveq 
  801865:	c3                   	retq   

0000000000801866 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801866:	55                   	push   %rbp
  801867:	48 89 e5             	mov    %rsp,%rbp
  80186a:	48 83 ec 18          	sub    $0x18,%rsp
  80186e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801872:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801879:	eb 09                	jmp    801884 <strlen+0x1e>
		n++;
  80187b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80187f:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801884:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801888:	0f b6 00             	movzbl (%rax),%eax
  80188b:	84 c0                	test   %al,%al
  80188d:	75 ec                	jne    80187b <strlen+0x15>
		n++;
	return n;
  80188f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801892:	c9                   	leaveq 
  801893:	c3                   	retq   

0000000000801894 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801894:	55                   	push   %rbp
  801895:	48 89 e5             	mov    %rsp,%rbp
  801898:	48 83 ec 20          	sub    $0x20,%rsp
  80189c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018a0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8018ab:	eb 0e                	jmp    8018bb <strnlen+0x27>
		n++;
  8018ad:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018b1:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8018b6:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8018bb:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8018c0:	74 0b                	je     8018cd <strnlen+0x39>
  8018c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018c6:	0f b6 00             	movzbl (%rax),%eax
  8018c9:	84 c0                	test   %al,%al
  8018cb:	75 e0                	jne    8018ad <strnlen+0x19>
		n++;
	return n;
  8018cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8018d0:	c9                   	leaveq 
  8018d1:	c3                   	retq   

00000000008018d2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8018d2:	55                   	push   %rbp
  8018d3:	48 89 e5             	mov    %rsp,%rbp
  8018d6:	48 83 ec 20          	sub    $0x20,%rsp
  8018da:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018de:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8018e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018e6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8018ea:	90                   	nop
  8018eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018ef:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018f3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8018f7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8018fb:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8018ff:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801903:	0f b6 12             	movzbl (%rdx),%edx
  801906:	88 10                	mov    %dl,(%rax)
  801908:	0f b6 00             	movzbl (%rax),%eax
  80190b:	84 c0                	test   %al,%al
  80190d:	75 dc                	jne    8018eb <strcpy+0x19>
		/* do nothing */;
	return ret;
  80190f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801913:	c9                   	leaveq 
  801914:	c3                   	retq   

0000000000801915 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801915:	55                   	push   %rbp
  801916:	48 89 e5             	mov    %rsp,%rbp
  801919:	48 83 ec 20          	sub    $0x20,%rsp
  80191d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801921:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801925:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801929:	48 89 c7             	mov    %rax,%rdi
  80192c:	48 b8 66 18 80 00 00 	movabs $0x801866,%rax
  801933:	00 00 00 
  801936:	ff d0                	callq  *%rax
  801938:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80193b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80193e:	48 63 d0             	movslq %eax,%rdx
  801941:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801945:	48 01 c2             	add    %rax,%rdx
  801948:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80194c:	48 89 c6             	mov    %rax,%rsi
  80194f:	48 89 d7             	mov    %rdx,%rdi
  801952:	48 b8 d2 18 80 00 00 	movabs $0x8018d2,%rax
  801959:	00 00 00 
  80195c:	ff d0                	callq  *%rax
	return dst;
  80195e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801962:	c9                   	leaveq 
  801963:	c3                   	retq   

0000000000801964 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801964:	55                   	push   %rbp
  801965:	48 89 e5             	mov    %rsp,%rbp
  801968:	48 83 ec 28          	sub    $0x28,%rsp
  80196c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801970:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801974:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801978:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80197c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801980:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801987:	00 
  801988:	eb 2a                	jmp    8019b4 <strncpy+0x50>
		*dst++ = *src;
  80198a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80198e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801992:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801996:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80199a:	0f b6 12             	movzbl (%rdx),%edx
  80199d:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80199f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8019a3:	0f b6 00             	movzbl (%rax),%eax
  8019a6:	84 c0                	test   %al,%al
  8019a8:	74 05                	je     8019af <strncpy+0x4b>
			src++;
  8019aa:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8019af:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8019b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019b8:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8019bc:	72 cc                	jb     80198a <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8019be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8019c2:	c9                   	leaveq 
  8019c3:	c3                   	retq   

00000000008019c4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8019c4:	55                   	push   %rbp
  8019c5:	48 89 e5             	mov    %rsp,%rbp
  8019c8:	48 83 ec 28          	sub    $0x28,%rsp
  8019cc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8019d0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8019d4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8019d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019dc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8019e0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8019e5:	74 3d                	je     801a24 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8019e7:	eb 1d                	jmp    801a06 <strlcpy+0x42>
			*dst++ = *src++;
  8019e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019ed:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019f1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8019f5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8019f9:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8019fd:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801a01:	0f b6 12             	movzbl (%rdx),%edx
  801a04:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801a06:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801a0b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801a10:	74 0b                	je     801a1d <strlcpy+0x59>
  801a12:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a16:	0f b6 00             	movzbl (%rax),%eax
  801a19:	84 c0                	test   %al,%al
  801a1b:	75 cc                	jne    8019e9 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801a1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a21:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801a24:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801a28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a2c:	48 29 c2             	sub    %rax,%rdx
  801a2f:	48 89 d0             	mov    %rdx,%rax
}
  801a32:	c9                   	leaveq 
  801a33:	c3                   	retq   

0000000000801a34 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801a34:	55                   	push   %rbp
  801a35:	48 89 e5             	mov    %rsp,%rbp
  801a38:	48 83 ec 10          	sub    $0x10,%rsp
  801a3c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a40:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801a44:	eb 0a                	jmp    801a50 <strcmp+0x1c>
		p++, q++;
  801a46:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801a4b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801a50:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a54:	0f b6 00             	movzbl (%rax),%eax
  801a57:	84 c0                	test   %al,%al
  801a59:	74 12                	je     801a6d <strcmp+0x39>
  801a5b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a5f:	0f b6 10             	movzbl (%rax),%edx
  801a62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a66:	0f b6 00             	movzbl (%rax),%eax
  801a69:	38 c2                	cmp    %al,%dl
  801a6b:	74 d9                	je     801a46 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801a6d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a71:	0f b6 00             	movzbl (%rax),%eax
  801a74:	0f b6 d0             	movzbl %al,%edx
  801a77:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a7b:	0f b6 00             	movzbl (%rax),%eax
  801a7e:	0f b6 c0             	movzbl %al,%eax
  801a81:	29 c2                	sub    %eax,%edx
  801a83:	89 d0                	mov    %edx,%eax
}
  801a85:	c9                   	leaveq 
  801a86:	c3                   	retq   

0000000000801a87 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801a87:	55                   	push   %rbp
  801a88:	48 89 e5             	mov    %rsp,%rbp
  801a8b:	48 83 ec 18          	sub    $0x18,%rsp
  801a8f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a93:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a97:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801a9b:	eb 0f                	jmp    801aac <strncmp+0x25>
		n--, p++, q++;
  801a9d:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801aa2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801aa7:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801aac:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801ab1:	74 1d                	je     801ad0 <strncmp+0x49>
  801ab3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ab7:	0f b6 00             	movzbl (%rax),%eax
  801aba:	84 c0                	test   %al,%al
  801abc:	74 12                	je     801ad0 <strncmp+0x49>
  801abe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ac2:	0f b6 10             	movzbl (%rax),%edx
  801ac5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ac9:	0f b6 00             	movzbl (%rax),%eax
  801acc:	38 c2                	cmp    %al,%dl
  801ace:	74 cd                	je     801a9d <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801ad0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801ad5:	75 07                	jne    801ade <strncmp+0x57>
		return 0;
  801ad7:	b8 00 00 00 00       	mov    $0x0,%eax
  801adc:	eb 18                	jmp    801af6 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801ade:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ae2:	0f b6 00             	movzbl (%rax),%eax
  801ae5:	0f b6 d0             	movzbl %al,%edx
  801ae8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801aec:	0f b6 00             	movzbl (%rax),%eax
  801aef:	0f b6 c0             	movzbl %al,%eax
  801af2:	29 c2                	sub    %eax,%edx
  801af4:	89 d0                	mov    %edx,%eax
}
  801af6:	c9                   	leaveq 
  801af7:	c3                   	retq   

0000000000801af8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801af8:	55                   	push   %rbp
  801af9:	48 89 e5             	mov    %rsp,%rbp
  801afc:	48 83 ec 0c          	sub    $0xc,%rsp
  801b00:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b04:	89 f0                	mov    %esi,%eax
  801b06:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801b09:	eb 17                	jmp    801b22 <strchr+0x2a>
		if (*s == c)
  801b0b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b0f:	0f b6 00             	movzbl (%rax),%eax
  801b12:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801b15:	75 06                	jne    801b1d <strchr+0x25>
			return (char *) s;
  801b17:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b1b:	eb 15                	jmp    801b32 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801b1d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801b22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b26:	0f b6 00             	movzbl (%rax),%eax
  801b29:	84 c0                	test   %al,%al
  801b2b:	75 de                	jne    801b0b <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801b2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b32:	c9                   	leaveq 
  801b33:	c3                   	retq   

0000000000801b34 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801b34:	55                   	push   %rbp
  801b35:	48 89 e5             	mov    %rsp,%rbp
  801b38:	48 83 ec 0c          	sub    $0xc,%rsp
  801b3c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b40:	89 f0                	mov    %esi,%eax
  801b42:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801b45:	eb 13                	jmp    801b5a <strfind+0x26>
		if (*s == c)
  801b47:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b4b:	0f b6 00             	movzbl (%rax),%eax
  801b4e:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801b51:	75 02                	jne    801b55 <strfind+0x21>
			break;
  801b53:	eb 10                	jmp    801b65 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801b55:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801b5a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b5e:	0f b6 00             	movzbl (%rax),%eax
  801b61:	84 c0                	test   %al,%al
  801b63:	75 e2                	jne    801b47 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801b65:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801b69:	c9                   	leaveq 
  801b6a:	c3                   	retq   

0000000000801b6b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801b6b:	55                   	push   %rbp
  801b6c:	48 89 e5             	mov    %rsp,%rbp
  801b6f:	48 83 ec 18          	sub    $0x18,%rsp
  801b73:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b77:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801b7a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801b7e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801b83:	75 06                	jne    801b8b <memset+0x20>
		return v;
  801b85:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b89:	eb 69                	jmp    801bf4 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801b8b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b8f:	83 e0 03             	and    $0x3,%eax
  801b92:	48 85 c0             	test   %rax,%rax
  801b95:	75 48                	jne    801bdf <memset+0x74>
  801b97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b9b:	83 e0 03             	and    $0x3,%eax
  801b9e:	48 85 c0             	test   %rax,%rax
  801ba1:	75 3c                	jne    801bdf <memset+0x74>
		c &= 0xFF;
  801ba3:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801baa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bad:	c1 e0 18             	shl    $0x18,%eax
  801bb0:	89 c2                	mov    %eax,%edx
  801bb2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bb5:	c1 e0 10             	shl    $0x10,%eax
  801bb8:	09 c2                	or     %eax,%edx
  801bba:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bbd:	c1 e0 08             	shl    $0x8,%eax
  801bc0:	09 d0                	or     %edx,%eax
  801bc2:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801bc5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bc9:	48 c1 e8 02          	shr    $0x2,%rax
  801bcd:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801bd0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801bd4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bd7:	48 89 d7             	mov    %rdx,%rdi
  801bda:	fc                   	cld    
  801bdb:	f3 ab                	rep stos %eax,%es:(%rdi)
  801bdd:	eb 11                	jmp    801bf0 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801bdf:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801be3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801be6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801bea:	48 89 d7             	mov    %rdx,%rdi
  801bed:	fc                   	cld    
  801bee:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801bf0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801bf4:	c9                   	leaveq 
  801bf5:	c3                   	retq   

0000000000801bf6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801bf6:	55                   	push   %rbp
  801bf7:	48 89 e5             	mov    %rsp,%rbp
  801bfa:	48 83 ec 28          	sub    $0x28,%rsp
  801bfe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801c02:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801c06:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801c0a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c0e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801c12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c16:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801c1a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c1e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801c22:	0f 83 88 00 00 00    	jae    801cb0 <memmove+0xba>
  801c28:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c2c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c30:	48 01 d0             	add    %rdx,%rax
  801c33:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801c37:	76 77                	jbe    801cb0 <memmove+0xba>
		s += n;
  801c39:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c3d:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801c41:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c45:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801c49:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c4d:	83 e0 03             	and    $0x3,%eax
  801c50:	48 85 c0             	test   %rax,%rax
  801c53:	75 3b                	jne    801c90 <memmove+0x9a>
  801c55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c59:	83 e0 03             	and    $0x3,%eax
  801c5c:	48 85 c0             	test   %rax,%rax
  801c5f:	75 2f                	jne    801c90 <memmove+0x9a>
  801c61:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c65:	83 e0 03             	and    $0x3,%eax
  801c68:	48 85 c0             	test   %rax,%rax
  801c6b:	75 23                	jne    801c90 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801c6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c71:	48 83 e8 04          	sub    $0x4,%rax
  801c75:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c79:	48 83 ea 04          	sub    $0x4,%rdx
  801c7d:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801c81:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801c85:	48 89 c7             	mov    %rax,%rdi
  801c88:	48 89 d6             	mov    %rdx,%rsi
  801c8b:	fd                   	std    
  801c8c:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801c8e:	eb 1d                	jmp    801cad <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801c90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c94:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801c98:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c9c:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801ca0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ca4:	48 89 d7             	mov    %rdx,%rdi
  801ca7:	48 89 c1             	mov    %rax,%rcx
  801caa:	fd                   	std    
  801cab:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801cad:	fc                   	cld    
  801cae:	eb 57                	jmp    801d07 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801cb0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cb4:	83 e0 03             	and    $0x3,%eax
  801cb7:	48 85 c0             	test   %rax,%rax
  801cba:	75 36                	jne    801cf2 <memmove+0xfc>
  801cbc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cc0:	83 e0 03             	and    $0x3,%eax
  801cc3:	48 85 c0             	test   %rax,%rax
  801cc6:	75 2a                	jne    801cf2 <memmove+0xfc>
  801cc8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ccc:	83 e0 03             	and    $0x3,%eax
  801ccf:	48 85 c0             	test   %rax,%rax
  801cd2:	75 1e                	jne    801cf2 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801cd4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cd8:	48 c1 e8 02          	shr    $0x2,%rax
  801cdc:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801cdf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ce3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ce7:	48 89 c7             	mov    %rax,%rdi
  801cea:	48 89 d6             	mov    %rdx,%rsi
  801ced:	fc                   	cld    
  801cee:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801cf0:	eb 15                	jmp    801d07 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801cf2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cf6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801cfa:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801cfe:	48 89 c7             	mov    %rax,%rdi
  801d01:	48 89 d6             	mov    %rdx,%rsi
  801d04:	fc                   	cld    
  801d05:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801d07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801d0b:	c9                   	leaveq 
  801d0c:	c3                   	retq   

0000000000801d0d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801d0d:	55                   	push   %rbp
  801d0e:	48 89 e5             	mov    %rsp,%rbp
  801d11:	48 83 ec 18          	sub    $0x18,%rsp
  801d15:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d19:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d1d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801d21:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801d25:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801d29:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d2d:	48 89 ce             	mov    %rcx,%rsi
  801d30:	48 89 c7             	mov    %rax,%rdi
  801d33:	48 b8 f6 1b 80 00 00 	movabs $0x801bf6,%rax
  801d3a:	00 00 00 
  801d3d:	ff d0                	callq  *%rax
}
  801d3f:	c9                   	leaveq 
  801d40:	c3                   	retq   

0000000000801d41 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801d41:	55                   	push   %rbp
  801d42:	48 89 e5             	mov    %rsp,%rbp
  801d45:	48 83 ec 28          	sub    $0x28,%rsp
  801d49:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801d4d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801d51:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801d55:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d59:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801d5d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d61:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801d65:	eb 36                	jmp    801d9d <memcmp+0x5c>
		if (*s1 != *s2)
  801d67:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d6b:	0f b6 10             	movzbl (%rax),%edx
  801d6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d72:	0f b6 00             	movzbl (%rax),%eax
  801d75:	38 c2                	cmp    %al,%dl
  801d77:	74 1a                	je     801d93 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801d79:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d7d:	0f b6 00             	movzbl (%rax),%eax
  801d80:	0f b6 d0             	movzbl %al,%edx
  801d83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d87:	0f b6 00             	movzbl (%rax),%eax
  801d8a:	0f b6 c0             	movzbl %al,%eax
  801d8d:	29 c2                	sub    %eax,%edx
  801d8f:	89 d0                	mov    %edx,%eax
  801d91:	eb 20                	jmp    801db3 <memcmp+0x72>
		s1++, s2++;
  801d93:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801d98:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801d9d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801da1:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801da5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801da9:	48 85 c0             	test   %rax,%rax
  801dac:	75 b9                	jne    801d67 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801dae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801db3:	c9                   	leaveq 
  801db4:	c3                   	retq   

0000000000801db5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801db5:	55                   	push   %rbp
  801db6:	48 89 e5             	mov    %rsp,%rbp
  801db9:	48 83 ec 28          	sub    $0x28,%rsp
  801dbd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801dc1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801dc4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801dc8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dcc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801dd0:	48 01 d0             	add    %rdx,%rax
  801dd3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801dd7:	eb 15                	jmp    801dee <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801dd9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ddd:	0f b6 10             	movzbl (%rax),%edx
  801de0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801de3:	38 c2                	cmp    %al,%dl
  801de5:	75 02                	jne    801de9 <memfind+0x34>
			break;
  801de7:	eb 0f                	jmp    801df8 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801de9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801dee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801df2:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801df6:	72 e1                	jb     801dd9 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801df8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801dfc:	c9                   	leaveq 
  801dfd:	c3                   	retq   

0000000000801dfe <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801dfe:	55                   	push   %rbp
  801dff:	48 89 e5             	mov    %rsp,%rbp
  801e02:	48 83 ec 34          	sub    $0x34,%rsp
  801e06:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e0a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801e0e:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801e11:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801e18:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801e1f:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801e20:	eb 05                	jmp    801e27 <strtol+0x29>
		s++;
  801e22:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801e27:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e2b:	0f b6 00             	movzbl (%rax),%eax
  801e2e:	3c 20                	cmp    $0x20,%al
  801e30:	74 f0                	je     801e22 <strtol+0x24>
  801e32:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e36:	0f b6 00             	movzbl (%rax),%eax
  801e39:	3c 09                	cmp    $0x9,%al
  801e3b:	74 e5                	je     801e22 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801e3d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e41:	0f b6 00             	movzbl (%rax),%eax
  801e44:	3c 2b                	cmp    $0x2b,%al
  801e46:	75 07                	jne    801e4f <strtol+0x51>
		s++;
  801e48:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801e4d:	eb 17                	jmp    801e66 <strtol+0x68>
	else if (*s == '-')
  801e4f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e53:	0f b6 00             	movzbl (%rax),%eax
  801e56:	3c 2d                	cmp    $0x2d,%al
  801e58:	75 0c                	jne    801e66 <strtol+0x68>
		s++, neg = 1;
  801e5a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801e5f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e66:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801e6a:	74 06                	je     801e72 <strtol+0x74>
  801e6c:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801e70:	75 28                	jne    801e9a <strtol+0x9c>
  801e72:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e76:	0f b6 00             	movzbl (%rax),%eax
  801e79:	3c 30                	cmp    $0x30,%al
  801e7b:	75 1d                	jne    801e9a <strtol+0x9c>
  801e7d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e81:	48 83 c0 01          	add    $0x1,%rax
  801e85:	0f b6 00             	movzbl (%rax),%eax
  801e88:	3c 78                	cmp    $0x78,%al
  801e8a:	75 0e                	jne    801e9a <strtol+0x9c>
		s += 2, base = 16;
  801e8c:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801e91:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801e98:	eb 2c                	jmp    801ec6 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801e9a:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801e9e:	75 19                	jne    801eb9 <strtol+0xbb>
  801ea0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ea4:	0f b6 00             	movzbl (%rax),%eax
  801ea7:	3c 30                	cmp    $0x30,%al
  801ea9:	75 0e                	jne    801eb9 <strtol+0xbb>
		s++, base = 8;
  801eab:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801eb0:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801eb7:	eb 0d                	jmp    801ec6 <strtol+0xc8>
	else if (base == 0)
  801eb9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801ebd:	75 07                	jne    801ec6 <strtol+0xc8>
		base = 10;
  801ebf:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801ec6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eca:	0f b6 00             	movzbl (%rax),%eax
  801ecd:	3c 2f                	cmp    $0x2f,%al
  801ecf:	7e 1d                	jle    801eee <strtol+0xf0>
  801ed1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ed5:	0f b6 00             	movzbl (%rax),%eax
  801ed8:	3c 39                	cmp    $0x39,%al
  801eda:	7f 12                	jg     801eee <strtol+0xf0>
			dig = *s - '0';
  801edc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ee0:	0f b6 00             	movzbl (%rax),%eax
  801ee3:	0f be c0             	movsbl %al,%eax
  801ee6:	83 e8 30             	sub    $0x30,%eax
  801ee9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801eec:	eb 4e                	jmp    801f3c <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801eee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ef2:	0f b6 00             	movzbl (%rax),%eax
  801ef5:	3c 60                	cmp    $0x60,%al
  801ef7:	7e 1d                	jle    801f16 <strtol+0x118>
  801ef9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801efd:	0f b6 00             	movzbl (%rax),%eax
  801f00:	3c 7a                	cmp    $0x7a,%al
  801f02:	7f 12                	jg     801f16 <strtol+0x118>
			dig = *s - 'a' + 10;
  801f04:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f08:	0f b6 00             	movzbl (%rax),%eax
  801f0b:	0f be c0             	movsbl %al,%eax
  801f0e:	83 e8 57             	sub    $0x57,%eax
  801f11:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801f14:	eb 26                	jmp    801f3c <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801f16:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f1a:	0f b6 00             	movzbl (%rax),%eax
  801f1d:	3c 40                	cmp    $0x40,%al
  801f1f:	7e 48                	jle    801f69 <strtol+0x16b>
  801f21:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f25:	0f b6 00             	movzbl (%rax),%eax
  801f28:	3c 5a                	cmp    $0x5a,%al
  801f2a:	7f 3d                	jg     801f69 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801f2c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f30:	0f b6 00             	movzbl (%rax),%eax
  801f33:	0f be c0             	movsbl %al,%eax
  801f36:	83 e8 37             	sub    $0x37,%eax
  801f39:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801f3c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f3f:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801f42:	7c 02                	jl     801f46 <strtol+0x148>
			break;
  801f44:	eb 23                	jmp    801f69 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801f46:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801f4b:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801f4e:	48 98                	cltq   
  801f50:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801f55:	48 89 c2             	mov    %rax,%rdx
  801f58:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f5b:	48 98                	cltq   
  801f5d:	48 01 d0             	add    %rdx,%rax
  801f60:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801f64:	e9 5d ff ff ff       	jmpq   801ec6 <strtol+0xc8>

	if (endptr)
  801f69:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801f6e:	74 0b                	je     801f7b <strtol+0x17d>
		*endptr = (char *) s;
  801f70:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f74:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801f78:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801f7b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f7f:	74 09                	je     801f8a <strtol+0x18c>
  801f81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f85:	48 f7 d8             	neg    %rax
  801f88:	eb 04                	jmp    801f8e <strtol+0x190>
  801f8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801f8e:	c9                   	leaveq 
  801f8f:	c3                   	retq   

0000000000801f90 <strstr>:

char * strstr(const char *in, const char *str)
{
  801f90:	55                   	push   %rbp
  801f91:	48 89 e5             	mov    %rsp,%rbp
  801f94:	48 83 ec 30          	sub    $0x30,%rsp
  801f98:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801f9c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801fa0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fa4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801fa8:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801fac:	0f b6 00             	movzbl (%rax),%eax
  801faf:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801fb2:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801fb6:	75 06                	jne    801fbe <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801fb8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fbc:	eb 6b                	jmp    802029 <strstr+0x99>

	len = strlen(str);
  801fbe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fc2:	48 89 c7             	mov    %rax,%rdi
  801fc5:	48 b8 66 18 80 00 00 	movabs $0x801866,%rax
  801fcc:	00 00 00 
  801fcf:	ff d0                	callq  *%rax
  801fd1:	48 98                	cltq   
  801fd3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801fd7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fdb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801fdf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801fe3:	0f b6 00             	movzbl (%rax),%eax
  801fe6:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801fe9:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801fed:	75 07                	jne    801ff6 <strstr+0x66>
				return (char *) 0;
  801fef:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff4:	eb 33                	jmp    802029 <strstr+0x99>
		} while (sc != c);
  801ff6:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801ffa:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801ffd:	75 d8                	jne    801fd7 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801fff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802003:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802007:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80200b:	48 89 ce             	mov    %rcx,%rsi
  80200e:	48 89 c7             	mov    %rax,%rdi
  802011:	48 b8 87 1a 80 00 00 	movabs $0x801a87,%rax
  802018:	00 00 00 
  80201b:	ff d0                	callq  *%rax
  80201d:	85 c0                	test   %eax,%eax
  80201f:	75 b6                	jne    801fd7 <strstr+0x47>

	return (char *) (in - 1);
  802021:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802025:	48 83 e8 01          	sub    $0x1,%rax
}
  802029:	c9                   	leaveq 
  80202a:	c3                   	retq   

000000000080202b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80202b:	55                   	push   %rbp
  80202c:	48 89 e5             	mov    %rsp,%rbp
  80202f:	53                   	push   %rbx
  802030:	48 83 ec 48          	sub    $0x48,%rsp
  802034:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802037:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80203a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80203e:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  802042:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  802046:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80204a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80204d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802051:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  802055:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  802059:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80205d:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  802061:	4c 89 c3             	mov    %r8,%rbx
  802064:	cd 30                	int    $0x30
  802066:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80206a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80206e:	74 3e                	je     8020ae <syscall+0x83>
  802070:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802075:	7e 37                	jle    8020ae <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  802077:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80207b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80207e:	49 89 d0             	mov    %rdx,%r8
  802081:	89 c1                	mov    %eax,%ecx
  802083:	48 ba c8 4f 80 00 00 	movabs $0x804fc8,%rdx
  80208a:	00 00 00 
  80208d:	be 23 00 00 00       	mov    $0x23,%esi
  802092:	48 bf e5 4f 80 00 00 	movabs $0x804fe5,%rdi
  802099:	00 00 00 
  80209c:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a1:	49 b9 e4 0a 80 00 00 	movabs $0x800ae4,%r9
  8020a8:	00 00 00 
  8020ab:	41 ff d1             	callq  *%r9

	return ret;
  8020ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8020b2:	48 83 c4 48          	add    $0x48,%rsp
  8020b6:	5b                   	pop    %rbx
  8020b7:	5d                   	pop    %rbp
  8020b8:	c3                   	retq   

00000000008020b9 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8020b9:	55                   	push   %rbp
  8020ba:	48 89 e5             	mov    %rsp,%rbp
  8020bd:	48 83 ec 20          	sub    $0x20,%rsp
  8020c1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8020c5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8020c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020cd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020d1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8020d8:	00 
  8020d9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020df:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020e5:	48 89 d1             	mov    %rdx,%rcx
  8020e8:	48 89 c2             	mov    %rax,%rdx
  8020eb:	be 00 00 00 00       	mov    $0x0,%esi
  8020f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8020f5:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  8020fc:	00 00 00 
  8020ff:	ff d0                	callq  *%rax
}
  802101:	c9                   	leaveq 
  802102:	c3                   	retq   

0000000000802103 <sys_cgetc>:

int
sys_cgetc(void)
{
  802103:	55                   	push   %rbp
  802104:	48 89 e5             	mov    %rsp,%rbp
  802107:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80210b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802112:	00 
  802113:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802119:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80211f:	b9 00 00 00 00       	mov    $0x0,%ecx
  802124:	ba 00 00 00 00       	mov    $0x0,%edx
  802129:	be 00 00 00 00       	mov    $0x0,%esi
  80212e:	bf 01 00 00 00       	mov    $0x1,%edi
  802133:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  80213a:	00 00 00 
  80213d:	ff d0                	callq  *%rax
}
  80213f:	c9                   	leaveq 
  802140:	c3                   	retq   

0000000000802141 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  802141:	55                   	push   %rbp
  802142:	48 89 e5             	mov    %rsp,%rbp
  802145:	48 83 ec 10          	sub    $0x10,%rsp
  802149:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80214c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80214f:	48 98                	cltq   
  802151:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802158:	00 
  802159:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80215f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802165:	b9 00 00 00 00       	mov    $0x0,%ecx
  80216a:	48 89 c2             	mov    %rax,%rdx
  80216d:	be 01 00 00 00       	mov    $0x1,%esi
  802172:	bf 03 00 00 00       	mov    $0x3,%edi
  802177:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  80217e:	00 00 00 
  802181:	ff d0                	callq  *%rax
}
  802183:	c9                   	leaveq 
  802184:	c3                   	retq   

0000000000802185 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  802185:	55                   	push   %rbp
  802186:	48 89 e5             	mov    %rsp,%rbp
  802189:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80218d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802194:	00 
  802195:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80219b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021a1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8021a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8021ab:	be 00 00 00 00       	mov    $0x0,%esi
  8021b0:	bf 02 00 00 00       	mov    $0x2,%edi
  8021b5:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  8021bc:	00 00 00 
  8021bf:	ff d0                	callq  *%rax
}
  8021c1:	c9                   	leaveq 
  8021c2:	c3                   	retq   

00000000008021c3 <sys_yield>:

void
sys_yield(void)
{
  8021c3:	55                   	push   %rbp
  8021c4:	48 89 e5             	mov    %rsp,%rbp
  8021c7:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8021cb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8021d2:	00 
  8021d3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021d9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021df:	b9 00 00 00 00       	mov    $0x0,%ecx
  8021e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8021e9:	be 00 00 00 00       	mov    $0x0,%esi
  8021ee:	bf 0b 00 00 00       	mov    $0xb,%edi
  8021f3:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  8021fa:	00 00 00 
  8021fd:	ff d0                	callq  *%rax
}
  8021ff:	c9                   	leaveq 
  802200:	c3                   	retq   

0000000000802201 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802201:	55                   	push   %rbp
  802202:	48 89 e5             	mov    %rsp,%rbp
  802205:	48 83 ec 20          	sub    $0x20,%rsp
  802209:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80220c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802210:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  802213:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802216:	48 63 c8             	movslq %eax,%rcx
  802219:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80221d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802220:	48 98                	cltq   
  802222:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802229:	00 
  80222a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802230:	49 89 c8             	mov    %rcx,%r8
  802233:	48 89 d1             	mov    %rdx,%rcx
  802236:	48 89 c2             	mov    %rax,%rdx
  802239:	be 01 00 00 00       	mov    $0x1,%esi
  80223e:	bf 04 00 00 00       	mov    $0x4,%edi
  802243:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  80224a:	00 00 00 
  80224d:	ff d0                	callq  *%rax
}
  80224f:	c9                   	leaveq 
  802250:	c3                   	retq   

0000000000802251 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802251:	55                   	push   %rbp
  802252:	48 89 e5             	mov    %rsp,%rbp
  802255:	48 83 ec 30          	sub    $0x30,%rsp
  802259:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80225c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802260:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802263:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802267:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80226b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80226e:	48 63 c8             	movslq %eax,%rcx
  802271:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802275:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802278:	48 63 f0             	movslq %eax,%rsi
  80227b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80227f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802282:	48 98                	cltq   
  802284:	48 89 0c 24          	mov    %rcx,(%rsp)
  802288:	49 89 f9             	mov    %rdi,%r9
  80228b:	49 89 f0             	mov    %rsi,%r8
  80228e:	48 89 d1             	mov    %rdx,%rcx
  802291:	48 89 c2             	mov    %rax,%rdx
  802294:	be 01 00 00 00       	mov    $0x1,%esi
  802299:	bf 05 00 00 00       	mov    $0x5,%edi
  80229e:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  8022a5:	00 00 00 
  8022a8:	ff d0                	callq  *%rax
}
  8022aa:	c9                   	leaveq 
  8022ab:	c3                   	retq   

00000000008022ac <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8022ac:	55                   	push   %rbp
  8022ad:	48 89 e5             	mov    %rsp,%rbp
  8022b0:	48 83 ec 20          	sub    $0x20,%rsp
  8022b4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8022b7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8022bb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022c2:	48 98                	cltq   
  8022c4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8022cb:	00 
  8022cc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8022d2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8022d8:	48 89 d1             	mov    %rdx,%rcx
  8022db:	48 89 c2             	mov    %rax,%rdx
  8022de:	be 01 00 00 00       	mov    $0x1,%esi
  8022e3:	bf 06 00 00 00       	mov    $0x6,%edi
  8022e8:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  8022ef:	00 00 00 
  8022f2:	ff d0                	callq  *%rax
}
  8022f4:	c9                   	leaveq 
  8022f5:	c3                   	retq   

00000000008022f6 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8022f6:	55                   	push   %rbp
  8022f7:	48 89 e5             	mov    %rsp,%rbp
  8022fa:	48 83 ec 10          	sub    $0x10,%rsp
  8022fe:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802301:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  802304:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802307:	48 63 d0             	movslq %eax,%rdx
  80230a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80230d:	48 98                	cltq   
  80230f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802316:	00 
  802317:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80231d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802323:	48 89 d1             	mov    %rdx,%rcx
  802326:	48 89 c2             	mov    %rax,%rdx
  802329:	be 01 00 00 00       	mov    $0x1,%esi
  80232e:	bf 08 00 00 00       	mov    $0x8,%edi
  802333:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  80233a:	00 00 00 
  80233d:	ff d0                	callq  *%rax
}
  80233f:	c9                   	leaveq 
  802340:	c3                   	retq   

0000000000802341 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802341:	55                   	push   %rbp
  802342:	48 89 e5             	mov    %rsp,%rbp
  802345:	48 83 ec 20          	sub    $0x20,%rsp
  802349:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80234c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  802350:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802354:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802357:	48 98                	cltq   
  802359:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802360:	00 
  802361:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802367:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80236d:	48 89 d1             	mov    %rdx,%rcx
  802370:	48 89 c2             	mov    %rax,%rdx
  802373:	be 01 00 00 00       	mov    $0x1,%esi
  802378:	bf 09 00 00 00       	mov    $0x9,%edi
  80237d:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  802384:	00 00 00 
  802387:	ff d0                	callq  *%rax
}
  802389:	c9                   	leaveq 
  80238a:	c3                   	retq   

000000000080238b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80238b:	55                   	push   %rbp
  80238c:	48 89 e5             	mov    %rsp,%rbp
  80238f:	48 83 ec 20          	sub    $0x20,%rsp
  802393:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802396:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80239a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80239e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023a1:	48 98                	cltq   
  8023a3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8023aa:	00 
  8023ab:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8023b1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8023b7:	48 89 d1             	mov    %rdx,%rcx
  8023ba:	48 89 c2             	mov    %rax,%rdx
  8023bd:	be 01 00 00 00       	mov    $0x1,%esi
  8023c2:	bf 0a 00 00 00       	mov    $0xa,%edi
  8023c7:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  8023ce:	00 00 00 
  8023d1:	ff d0                	callq  *%rax
}
  8023d3:	c9                   	leaveq 
  8023d4:	c3                   	retq   

00000000008023d5 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8023d5:	55                   	push   %rbp
  8023d6:	48 89 e5             	mov    %rsp,%rbp
  8023d9:	48 83 ec 20          	sub    $0x20,%rsp
  8023dd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8023e0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8023e4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8023e8:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8023eb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023ee:	48 63 f0             	movslq %eax,%rsi
  8023f1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8023f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023f8:	48 98                	cltq   
  8023fa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023fe:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802405:	00 
  802406:	49 89 f1             	mov    %rsi,%r9
  802409:	49 89 c8             	mov    %rcx,%r8
  80240c:	48 89 d1             	mov    %rdx,%rcx
  80240f:	48 89 c2             	mov    %rax,%rdx
  802412:	be 00 00 00 00       	mov    $0x0,%esi
  802417:	bf 0c 00 00 00       	mov    $0xc,%edi
  80241c:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  802423:	00 00 00 
  802426:	ff d0                	callq  *%rax
}
  802428:	c9                   	leaveq 
  802429:	c3                   	retq   

000000000080242a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80242a:	55                   	push   %rbp
  80242b:	48 89 e5             	mov    %rsp,%rbp
  80242e:	48 83 ec 10          	sub    $0x10,%rsp
  802432:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  802436:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80243a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802441:	00 
  802442:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802448:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80244e:	b9 00 00 00 00       	mov    $0x0,%ecx
  802453:	48 89 c2             	mov    %rax,%rdx
  802456:	be 01 00 00 00       	mov    $0x1,%esi
  80245b:	bf 0d 00 00 00       	mov    $0xd,%edi
  802460:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  802467:	00 00 00 
  80246a:	ff d0                	callq  *%rax
}
  80246c:	c9                   	leaveq 
  80246d:	c3                   	retq   

000000000080246e <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  80246e:	55                   	push   %rbp
  80246f:	48 89 e5             	mov    %rsp,%rbp
  802472:	48 83 ec 20          	sub    $0x20,%rsp
  802476:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80247a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, (uint64_t)buf, len, 0, 0, 0, 0);
  80247e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802482:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802486:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80248d:	00 
  80248e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802494:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80249a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80249f:	89 c6                	mov    %eax,%esi
  8024a1:	bf 0f 00 00 00       	mov    $0xf,%edi
  8024a6:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  8024ad:	00 00 00 
  8024b0:	ff d0                	callq  *%rax
}
  8024b2:	c9                   	leaveq 
  8024b3:	c3                   	retq   

00000000008024b4 <sys_net_rx>:

int
sys_net_rx(void *buf, size_t len)
{
  8024b4:	55                   	push   %rbp
  8024b5:	48 89 e5             	mov    %rsp,%rbp
  8024b8:	48 83 ec 20          	sub    $0x20,%rsp
  8024bc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8024c0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_rx, (uint64_t)buf, len, 0, 0, 0, 0);
  8024c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024c8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8024cc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8024d3:	00 
  8024d4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8024da:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8024e0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8024e5:	89 c6                	mov    %eax,%esi
  8024e7:	bf 10 00 00 00       	mov    $0x10,%edi
  8024ec:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  8024f3:	00 00 00 
  8024f6:	ff d0                	callq  *%rax
}
  8024f8:	c9                   	leaveq 
  8024f9:	c3                   	retq   

00000000008024fa <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  8024fa:	55                   	push   %rbp
  8024fb:	48 89 e5             	mov    %rsp,%rbp
  8024fe:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  802502:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802509:	00 
  80250a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802510:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802516:	b9 00 00 00 00       	mov    $0x0,%ecx
  80251b:	ba 00 00 00 00       	mov    $0x0,%edx
  802520:	be 00 00 00 00       	mov    $0x0,%esi
  802525:	bf 0e 00 00 00       	mov    $0xe,%edi
  80252a:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  802531:	00 00 00 
  802534:	ff d0                	callq  *%rax
}
  802536:	c9                   	leaveq 
  802537:	c3                   	retq   

0000000000802538 <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802538:	55                   	push   %rbp
  802539:	48 89 e5             	mov    %rsp,%rbp
  80253c:	48 83 ec 10          	sub    $0x10,%rsp
  802540:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  802544:	48 b8 e0 81 80 00 00 	movabs $0x8081e0,%rax
  80254b:	00 00 00 
  80254e:	48 8b 00             	mov    (%rax),%rax
  802551:	48 85 c0             	test   %rax,%rax
  802554:	0f 85 84 00 00 00    	jne    8025de <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  80255a:	48 b8 d8 81 80 00 00 	movabs $0x8081d8,%rax
  802561:	00 00 00 
  802564:	48 8b 00             	mov    (%rax),%rax
  802567:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80256d:	ba 07 00 00 00       	mov    $0x7,%edx
  802572:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802577:	89 c7                	mov    %eax,%edi
  802579:	48 b8 01 22 80 00 00 	movabs $0x802201,%rax
  802580:	00 00 00 
  802583:	ff d0                	callq  *%rax
  802585:	85 c0                	test   %eax,%eax
  802587:	79 2a                	jns    8025b3 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  802589:	48 ba f8 4f 80 00 00 	movabs $0x804ff8,%rdx
  802590:	00 00 00 
  802593:	be 23 00 00 00       	mov    $0x23,%esi
  802598:	48 bf 1f 50 80 00 00 	movabs $0x80501f,%rdi
  80259f:	00 00 00 
  8025a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a7:	48 b9 e4 0a 80 00 00 	movabs $0x800ae4,%rcx
  8025ae:	00 00 00 
  8025b1:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  8025b3:	48 b8 d8 81 80 00 00 	movabs $0x8081d8,%rax
  8025ba:	00 00 00 
  8025bd:	48 8b 00             	mov    (%rax),%rax
  8025c0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025c6:	48 be f1 25 80 00 00 	movabs $0x8025f1,%rsi
  8025cd:	00 00 00 
  8025d0:	89 c7                	mov    %eax,%edi
  8025d2:	48 b8 8b 23 80 00 00 	movabs $0x80238b,%rax
  8025d9:	00 00 00 
  8025dc:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  8025de:	48 b8 e0 81 80 00 00 	movabs $0x8081e0,%rax
  8025e5:	00 00 00 
  8025e8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8025ec:	48 89 10             	mov    %rdx,(%rax)
}
  8025ef:	c9                   	leaveq 
  8025f0:	c3                   	retq   

00000000008025f1 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  8025f1:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  8025f4:	48 a1 e0 81 80 00 00 	movabs 0x8081e0,%rax
  8025fb:	00 00 00 
call *%rax
  8025fe:	ff d0                	callq  *%rax
    // LAB 4: Your code here.

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.

	movq 136(%rsp), %rbx  //Load RIP 
  802600:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  802607:	00 
	movq 152(%rsp), %rcx  //Load RSP
  802608:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  80260f:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  802610:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  802614:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  802617:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  80261e:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  80261f:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  802623:	4c 8b 3c 24          	mov    (%rsp),%r15
  802627:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  80262c:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  802631:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  802636:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  80263b:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  802640:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  802645:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80264a:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  80264f:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  802654:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  802659:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  80265e:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  802663:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  802668:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  80266d:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  802671:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  802675:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  802676:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802677:	c3                   	retq   

0000000000802678 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802678:	55                   	push   %rbp
  802679:	48 89 e5             	mov    %rsp,%rbp
  80267c:	48 83 ec 08          	sub    $0x8,%rsp
  802680:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802684:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802688:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80268f:	ff ff ff 
  802692:	48 01 d0             	add    %rdx,%rax
  802695:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802699:	c9                   	leaveq 
  80269a:	c3                   	retq   

000000000080269b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80269b:	55                   	push   %rbp
  80269c:	48 89 e5             	mov    %rsp,%rbp
  80269f:	48 83 ec 08          	sub    $0x8,%rsp
  8026a3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8026a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026ab:	48 89 c7             	mov    %rax,%rdi
  8026ae:	48 b8 78 26 80 00 00 	movabs $0x802678,%rax
  8026b5:	00 00 00 
  8026b8:	ff d0                	callq  *%rax
  8026ba:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8026c0:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8026c4:	c9                   	leaveq 
  8026c5:	c3                   	retq   

00000000008026c6 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8026c6:	55                   	push   %rbp
  8026c7:	48 89 e5             	mov    %rsp,%rbp
  8026ca:	48 83 ec 18          	sub    $0x18,%rsp
  8026ce:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8026d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8026d9:	eb 6b                	jmp    802746 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8026db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026de:	48 98                	cltq   
  8026e0:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8026e6:	48 c1 e0 0c          	shl    $0xc,%rax
  8026ea:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8026ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026f2:	48 c1 e8 15          	shr    $0x15,%rax
  8026f6:	48 89 c2             	mov    %rax,%rdx
  8026f9:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802700:	01 00 00 
  802703:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802707:	83 e0 01             	and    $0x1,%eax
  80270a:	48 85 c0             	test   %rax,%rax
  80270d:	74 21                	je     802730 <fd_alloc+0x6a>
  80270f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802713:	48 c1 e8 0c          	shr    $0xc,%rax
  802717:	48 89 c2             	mov    %rax,%rdx
  80271a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802721:	01 00 00 
  802724:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802728:	83 e0 01             	and    $0x1,%eax
  80272b:	48 85 c0             	test   %rax,%rax
  80272e:	75 12                	jne    802742 <fd_alloc+0x7c>
			*fd_store = fd;
  802730:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802734:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802738:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80273b:	b8 00 00 00 00       	mov    $0x0,%eax
  802740:	eb 1a                	jmp    80275c <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802742:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802746:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80274a:	7e 8f                	jle    8026db <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80274c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802750:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802757:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80275c:	c9                   	leaveq 
  80275d:	c3                   	retq   

000000000080275e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80275e:	55                   	push   %rbp
  80275f:	48 89 e5             	mov    %rsp,%rbp
  802762:	48 83 ec 20          	sub    $0x20,%rsp
  802766:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802769:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80276d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802771:	78 06                	js     802779 <fd_lookup+0x1b>
  802773:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802777:	7e 07                	jle    802780 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802779:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80277e:	eb 6c                	jmp    8027ec <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802780:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802783:	48 98                	cltq   
  802785:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80278b:	48 c1 e0 0c          	shl    $0xc,%rax
  80278f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802793:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802797:	48 c1 e8 15          	shr    $0x15,%rax
  80279b:	48 89 c2             	mov    %rax,%rdx
  80279e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8027a5:	01 00 00 
  8027a8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027ac:	83 e0 01             	and    $0x1,%eax
  8027af:	48 85 c0             	test   %rax,%rax
  8027b2:	74 21                	je     8027d5 <fd_lookup+0x77>
  8027b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027b8:	48 c1 e8 0c          	shr    $0xc,%rax
  8027bc:	48 89 c2             	mov    %rax,%rdx
  8027bf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8027c6:	01 00 00 
  8027c9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027cd:	83 e0 01             	and    $0x1,%eax
  8027d0:	48 85 c0             	test   %rax,%rax
  8027d3:	75 07                	jne    8027dc <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8027d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027da:	eb 10                	jmp    8027ec <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8027dc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027e0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8027e4:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8027e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027ec:	c9                   	leaveq 
  8027ed:	c3                   	retq   

00000000008027ee <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8027ee:	55                   	push   %rbp
  8027ef:	48 89 e5             	mov    %rsp,%rbp
  8027f2:	48 83 ec 30          	sub    $0x30,%rsp
  8027f6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8027fa:	89 f0                	mov    %esi,%eax
  8027fc:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8027ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802803:	48 89 c7             	mov    %rax,%rdi
  802806:	48 b8 78 26 80 00 00 	movabs $0x802678,%rax
  80280d:	00 00 00 
  802810:	ff d0                	callq  *%rax
  802812:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802816:	48 89 d6             	mov    %rdx,%rsi
  802819:	89 c7                	mov    %eax,%edi
  80281b:	48 b8 5e 27 80 00 00 	movabs $0x80275e,%rax
  802822:	00 00 00 
  802825:	ff d0                	callq  *%rax
  802827:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80282a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80282e:	78 0a                	js     80283a <fd_close+0x4c>
	    || fd != fd2)
  802830:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802834:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802838:	74 12                	je     80284c <fd_close+0x5e>
		return (must_exist ? r : 0);
  80283a:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80283e:	74 05                	je     802845 <fd_close+0x57>
  802840:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802843:	eb 05                	jmp    80284a <fd_close+0x5c>
  802845:	b8 00 00 00 00       	mov    $0x0,%eax
  80284a:	eb 69                	jmp    8028b5 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80284c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802850:	8b 00                	mov    (%rax),%eax
  802852:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802856:	48 89 d6             	mov    %rdx,%rsi
  802859:	89 c7                	mov    %eax,%edi
  80285b:	48 b8 b7 28 80 00 00 	movabs $0x8028b7,%rax
  802862:	00 00 00 
  802865:	ff d0                	callq  *%rax
  802867:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80286a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80286e:	78 2a                	js     80289a <fd_close+0xac>
		if (dev->dev_close)
  802870:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802874:	48 8b 40 20          	mov    0x20(%rax),%rax
  802878:	48 85 c0             	test   %rax,%rax
  80287b:	74 16                	je     802893 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  80287d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802881:	48 8b 40 20          	mov    0x20(%rax),%rax
  802885:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802889:	48 89 d7             	mov    %rdx,%rdi
  80288c:	ff d0                	callq  *%rax
  80288e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802891:	eb 07                	jmp    80289a <fd_close+0xac>
		else
			r = 0;
  802893:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80289a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80289e:	48 89 c6             	mov    %rax,%rsi
  8028a1:	bf 00 00 00 00       	mov    $0x0,%edi
  8028a6:	48 b8 ac 22 80 00 00 	movabs $0x8022ac,%rax
  8028ad:	00 00 00 
  8028b0:	ff d0                	callq  *%rax
	return r;
  8028b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8028b5:	c9                   	leaveq 
  8028b6:	c3                   	retq   

00000000008028b7 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8028b7:	55                   	push   %rbp
  8028b8:	48 89 e5             	mov    %rsp,%rbp
  8028bb:	48 83 ec 20          	sub    $0x20,%rsp
  8028bf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8028c2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8028c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8028cd:	eb 41                	jmp    802910 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8028cf:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8028d6:	00 00 00 
  8028d9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8028dc:	48 63 d2             	movslq %edx,%rdx
  8028df:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028e3:	8b 00                	mov    (%rax),%eax
  8028e5:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8028e8:	75 22                	jne    80290c <dev_lookup+0x55>
			*dev = devtab[i];
  8028ea:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8028f1:	00 00 00 
  8028f4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8028f7:	48 63 d2             	movslq %edx,%rdx
  8028fa:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8028fe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802902:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802905:	b8 00 00 00 00       	mov    $0x0,%eax
  80290a:	eb 60                	jmp    80296c <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80290c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802910:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802917:	00 00 00 
  80291a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80291d:	48 63 d2             	movslq %edx,%rdx
  802920:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802924:	48 85 c0             	test   %rax,%rax
  802927:	75 a6                	jne    8028cf <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802929:	48 b8 d8 81 80 00 00 	movabs $0x8081d8,%rax
  802930:	00 00 00 
  802933:	48 8b 00             	mov    (%rax),%rax
  802936:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80293c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80293f:	89 c6                	mov    %eax,%esi
  802941:	48 bf 30 50 80 00 00 	movabs $0x805030,%rdi
  802948:	00 00 00 
  80294b:	b8 00 00 00 00       	mov    $0x0,%eax
  802950:	48 b9 1d 0d 80 00 00 	movabs $0x800d1d,%rcx
  802957:	00 00 00 
  80295a:	ff d1                	callq  *%rcx
	*dev = 0;
  80295c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802960:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802967:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80296c:	c9                   	leaveq 
  80296d:	c3                   	retq   

000000000080296e <close>:

int
close(int fdnum)
{
  80296e:	55                   	push   %rbp
  80296f:	48 89 e5             	mov    %rsp,%rbp
  802972:	48 83 ec 20          	sub    $0x20,%rsp
  802976:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802979:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80297d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802980:	48 89 d6             	mov    %rdx,%rsi
  802983:	89 c7                	mov    %eax,%edi
  802985:	48 b8 5e 27 80 00 00 	movabs $0x80275e,%rax
  80298c:	00 00 00 
  80298f:	ff d0                	callq  *%rax
  802991:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802994:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802998:	79 05                	jns    80299f <close+0x31>
		return r;
  80299a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80299d:	eb 18                	jmp    8029b7 <close+0x49>
	else
		return fd_close(fd, 1);
  80299f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029a3:	be 01 00 00 00       	mov    $0x1,%esi
  8029a8:	48 89 c7             	mov    %rax,%rdi
  8029ab:	48 b8 ee 27 80 00 00 	movabs $0x8027ee,%rax
  8029b2:	00 00 00 
  8029b5:	ff d0                	callq  *%rax
}
  8029b7:	c9                   	leaveq 
  8029b8:	c3                   	retq   

00000000008029b9 <close_all>:

void
close_all(void)
{
  8029b9:	55                   	push   %rbp
  8029ba:	48 89 e5             	mov    %rsp,%rbp
  8029bd:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8029c1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8029c8:	eb 15                	jmp    8029df <close_all+0x26>
		close(i);
  8029ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029cd:	89 c7                	mov    %eax,%edi
  8029cf:	48 b8 6e 29 80 00 00 	movabs $0x80296e,%rax
  8029d6:	00 00 00 
  8029d9:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8029db:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8029df:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8029e3:	7e e5                	jle    8029ca <close_all+0x11>
		close(i);
}
  8029e5:	c9                   	leaveq 
  8029e6:	c3                   	retq   

00000000008029e7 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8029e7:	55                   	push   %rbp
  8029e8:	48 89 e5             	mov    %rsp,%rbp
  8029eb:	48 83 ec 40          	sub    $0x40,%rsp
  8029ef:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8029f2:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8029f5:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8029f9:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8029fc:	48 89 d6             	mov    %rdx,%rsi
  8029ff:	89 c7                	mov    %eax,%edi
  802a01:	48 b8 5e 27 80 00 00 	movabs $0x80275e,%rax
  802a08:	00 00 00 
  802a0b:	ff d0                	callq  *%rax
  802a0d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a10:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a14:	79 08                	jns    802a1e <dup+0x37>
		return r;
  802a16:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a19:	e9 70 01 00 00       	jmpq   802b8e <dup+0x1a7>
	close(newfdnum);
  802a1e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a21:	89 c7                	mov    %eax,%edi
  802a23:	48 b8 6e 29 80 00 00 	movabs $0x80296e,%rax
  802a2a:	00 00 00 
  802a2d:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802a2f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a32:	48 98                	cltq   
  802a34:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802a3a:	48 c1 e0 0c          	shl    $0xc,%rax
  802a3e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802a42:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a46:	48 89 c7             	mov    %rax,%rdi
  802a49:	48 b8 9b 26 80 00 00 	movabs $0x80269b,%rax
  802a50:	00 00 00 
  802a53:	ff d0                	callq  *%rax
  802a55:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802a59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a5d:	48 89 c7             	mov    %rax,%rdi
  802a60:	48 b8 9b 26 80 00 00 	movabs $0x80269b,%rax
  802a67:	00 00 00 
  802a6a:	ff d0                	callq  *%rax
  802a6c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802a70:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a74:	48 c1 e8 15          	shr    $0x15,%rax
  802a78:	48 89 c2             	mov    %rax,%rdx
  802a7b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802a82:	01 00 00 
  802a85:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a89:	83 e0 01             	and    $0x1,%eax
  802a8c:	48 85 c0             	test   %rax,%rax
  802a8f:	74 73                	je     802b04 <dup+0x11d>
  802a91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a95:	48 c1 e8 0c          	shr    $0xc,%rax
  802a99:	48 89 c2             	mov    %rax,%rdx
  802a9c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802aa3:	01 00 00 
  802aa6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802aaa:	83 e0 01             	and    $0x1,%eax
  802aad:	48 85 c0             	test   %rax,%rax
  802ab0:	74 52                	je     802b04 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802ab2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ab6:	48 c1 e8 0c          	shr    $0xc,%rax
  802aba:	48 89 c2             	mov    %rax,%rdx
  802abd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ac4:	01 00 00 
  802ac7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802acb:	25 07 0e 00 00       	and    $0xe07,%eax
  802ad0:	89 c1                	mov    %eax,%ecx
  802ad2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802ad6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ada:	41 89 c8             	mov    %ecx,%r8d
  802add:	48 89 d1             	mov    %rdx,%rcx
  802ae0:	ba 00 00 00 00       	mov    $0x0,%edx
  802ae5:	48 89 c6             	mov    %rax,%rsi
  802ae8:	bf 00 00 00 00       	mov    $0x0,%edi
  802aed:	48 b8 51 22 80 00 00 	movabs $0x802251,%rax
  802af4:	00 00 00 
  802af7:	ff d0                	callq  *%rax
  802af9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802afc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b00:	79 02                	jns    802b04 <dup+0x11d>
			goto err;
  802b02:	eb 57                	jmp    802b5b <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802b04:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b08:	48 c1 e8 0c          	shr    $0xc,%rax
  802b0c:	48 89 c2             	mov    %rax,%rdx
  802b0f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b16:	01 00 00 
  802b19:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b1d:	25 07 0e 00 00       	and    $0xe07,%eax
  802b22:	89 c1                	mov    %eax,%ecx
  802b24:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b28:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b2c:	41 89 c8             	mov    %ecx,%r8d
  802b2f:	48 89 d1             	mov    %rdx,%rcx
  802b32:	ba 00 00 00 00       	mov    $0x0,%edx
  802b37:	48 89 c6             	mov    %rax,%rsi
  802b3a:	bf 00 00 00 00       	mov    $0x0,%edi
  802b3f:	48 b8 51 22 80 00 00 	movabs $0x802251,%rax
  802b46:	00 00 00 
  802b49:	ff d0                	callq  *%rax
  802b4b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b4e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b52:	79 02                	jns    802b56 <dup+0x16f>
		goto err;
  802b54:	eb 05                	jmp    802b5b <dup+0x174>

	return newfdnum;
  802b56:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802b59:	eb 33                	jmp    802b8e <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802b5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b5f:	48 89 c6             	mov    %rax,%rsi
  802b62:	bf 00 00 00 00       	mov    $0x0,%edi
  802b67:	48 b8 ac 22 80 00 00 	movabs $0x8022ac,%rax
  802b6e:	00 00 00 
  802b71:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802b73:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b77:	48 89 c6             	mov    %rax,%rsi
  802b7a:	bf 00 00 00 00       	mov    $0x0,%edi
  802b7f:	48 b8 ac 22 80 00 00 	movabs $0x8022ac,%rax
  802b86:	00 00 00 
  802b89:	ff d0                	callq  *%rax
	return r;
  802b8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802b8e:	c9                   	leaveq 
  802b8f:	c3                   	retq   

0000000000802b90 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802b90:	55                   	push   %rbp
  802b91:	48 89 e5             	mov    %rsp,%rbp
  802b94:	48 83 ec 40          	sub    $0x40,%rsp
  802b98:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b9b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802b9f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ba3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ba7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802baa:	48 89 d6             	mov    %rdx,%rsi
  802bad:	89 c7                	mov    %eax,%edi
  802baf:	48 b8 5e 27 80 00 00 	movabs $0x80275e,%rax
  802bb6:	00 00 00 
  802bb9:	ff d0                	callq  *%rax
  802bbb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bbe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bc2:	78 24                	js     802be8 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802bc4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bc8:	8b 00                	mov    (%rax),%eax
  802bca:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802bce:	48 89 d6             	mov    %rdx,%rsi
  802bd1:	89 c7                	mov    %eax,%edi
  802bd3:	48 b8 b7 28 80 00 00 	movabs $0x8028b7,%rax
  802bda:	00 00 00 
  802bdd:	ff d0                	callq  *%rax
  802bdf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802be2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802be6:	79 05                	jns    802bed <read+0x5d>
		return r;
  802be8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802beb:	eb 76                	jmp    802c63 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802bed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bf1:	8b 40 08             	mov    0x8(%rax),%eax
  802bf4:	83 e0 03             	and    $0x3,%eax
  802bf7:	83 f8 01             	cmp    $0x1,%eax
  802bfa:	75 3a                	jne    802c36 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802bfc:	48 b8 d8 81 80 00 00 	movabs $0x8081d8,%rax
  802c03:	00 00 00 
  802c06:	48 8b 00             	mov    (%rax),%rax
  802c09:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c0f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c12:	89 c6                	mov    %eax,%esi
  802c14:	48 bf 4f 50 80 00 00 	movabs $0x80504f,%rdi
  802c1b:	00 00 00 
  802c1e:	b8 00 00 00 00       	mov    $0x0,%eax
  802c23:	48 b9 1d 0d 80 00 00 	movabs $0x800d1d,%rcx
  802c2a:	00 00 00 
  802c2d:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802c2f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c34:	eb 2d                	jmp    802c63 <read+0xd3>
	}
	if (!dev->dev_read)
  802c36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c3a:	48 8b 40 10          	mov    0x10(%rax),%rax
  802c3e:	48 85 c0             	test   %rax,%rax
  802c41:	75 07                	jne    802c4a <read+0xba>
		return -E_NOT_SUPP;
  802c43:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c48:	eb 19                	jmp    802c63 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802c4a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c4e:	48 8b 40 10          	mov    0x10(%rax),%rax
  802c52:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802c56:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802c5a:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802c5e:	48 89 cf             	mov    %rcx,%rdi
  802c61:	ff d0                	callq  *%rax
}
  802c63:	c9                   	leaveq 
  802c64:	c3                   	retq   

0000000000802c65 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802c65:	55                   	push   %rbp
  802c66:	48 89 e5             	mov    %rsp,%rbp
  802c69:	48 83 ec 30          	sub    $0x30,%rsp
  802c6d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c70:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c74:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802c78:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802c7f:	eb 49                	jmp    802cca <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802c81:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c84:	48 98                	cltq   
  802c86:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802c8a:	48 29 c2             	sub    %rax,%rdx
  802c8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c90:	48 63 c8             	movslq %eax,%rcx
  802c93:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c97:	48 01 c1             	add    %rax,%rcx
  802c9a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c9d:	48 89 ce             	mov    %rcx,%rsi
  802ca0:	89 c7                	mov    %eax,%edi
  802ca2:	48 b8 90 2b 80 00 00 	movabs $0x802b90,%rax
  802ca9:	00 00 00 
  802cac:	ff d0                	callq  *%rax
  802cae:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802cb1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802cb5:	79 05                	jns    802cbc <readn+0x57>
			return m;
  802cb7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cba:	eb 1c                	jmp    802cd8 <readn+0x73>
		if (m == 0)
  802cbc:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802cc0:	75 02                	jne    802cc4 <readn+0x5f>
			break;
  802cc2:	eb 11                	jmp    802cd5 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802cc4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cc7:	01 45 fc             	add    %eax,-0x4(%rbp)
  802cca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ccd:	48 98                	cltq   
  802ccf:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802cd3:	72 ac                	jb     802c81 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802cd5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802cd8:	c9                   	leaveq 
  802cd9:	c3                   	retq   

0000000000802cda <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802cda:	55                   	push   %rbp
  802cdb:	48 89 e5             	mov    %rsp,%rbp
  802cde:	48 83 ec 40          	sub    $0x40,%rsp
  802ce2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ce5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802ce9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ced:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802cf1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802cf4:	48 89 d6             	mov    %rdx,%rsi
  802cf7:	89 c7                	mov    %eax,%edi
  802cf9:	48 b8 5e 27 80 00 00 	movabs $0x80275e,%rax
  802d00:	00 00 00 
  802d03:	ff d0                	callq  *%rax
  802d05:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d08:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d0c:	78 24                	js     802d32 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d0e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d12:	8b 00                	mov    (%rax),%eax
  802d14:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d18:	48 89 d6             	mov    %rdx,%rsi
  802d1b:	89 c7                	mov    %eax,%edi
  802d1d:	48 b8 b7 28 80 00 00 	movabs $0x8028b7,%rax
  802d24:	00 00 00 
  802d27:	ff d0                	callq  *%rax
  802d29:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d2c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d30:	79 05                	jns    802d37 <write+0x5d>
		return r;
  802d32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d35:	eb 75                	jmp    802dac <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802d37:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d3b:	8b 40 08             	mov    0x8(%rax),%eax
  802d3e:	83 e0 03             	and    $0x3,%eax
  802d41:	85 c0                	test   %eax,%eax
  802d43:	75 3a                	jne    802d7f <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802d45:	48 b8 d8 81 80 00 00 	movabs $0x8081d8,%rax
  802d4c:	00 00 00 
  802d4f:	48 8b 00             	mov    (%rax),%rax
  802d52:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d58:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802d5b:	89 c6                	mov    %eax,%esi
  802d5d:	48 bf 6b 50 80 00 00 	movabs $0x80506b,%rdi
  802d64:	00 00 00 
  802d67:	b8 00 00 00 00       	mov    $0x0,%eax
  802d6c:	48 b9 1d 0d 80 00 00 	movabs $0x800d1d,%rcx
  802d73:	00 00 00 
  802d76:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802d78:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d7d:	eb 2d                	jmp    802dac <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  802d7f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d83:	48 8b 40 18          	mov    0x18(%rax),%rax
  802d87:	48 85 c0             	test   %rax,%rax
  802d8a:	75 07                	jne    802d93 <write+0xb9>
		return -E_NOT_SUPP;
  802d8c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d91:	eb 19                	jmp    802dac <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802d93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d97:	48 8b 40 18          	mov    0x18(%rax),%rax
  802d9b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802d9f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802da3:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802da7:	48 89 cf             	mov    %rcx,%rdi
  802daa:	ff d0                	callq  *%rax
}
  802dac:	c9                   	leaveq 
  802dad:	c3                   	retq   

0000000000802dae <seek>:

int
seek(int fdnum, off_t offset)
{
  802dae:	55                   	push   %rbp
  802daf:	48 89 e5             	mov    %rsp,%rbp
  802db2:	48 83 ec 18          	sub    $0x18,%rsp
  802db6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802db9:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802dbc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802dc0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802dc3:	48 89 d6             	mov    %rdx,%rsi
  802dc6:	89 c7                	mov    %eax,%edi
  802dc8:	48 b8 5e 27 80 00 00 	movabs $0x80275e,%rax
  802dcf:	00 00 00 
  802dd2:	ff d0                	callq  *%rax
  802dd4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dd7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ddb:	79 05                	jns    802de2 <seek+0x34>
		return r;
  802ddd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802de0:	eb 0f                	jmp    802df1 <seek+0x43>
	fd->fd_offset = offset;
  802de2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802de6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802de9:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802dec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802df1:	c9                   	leaveq 
  802df2:	c3                   	retq   

0000000000802df3 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802df3:	55                   	push   %rbp
  802df4:	48 89 e5             	mov    %rsp,%rbp
  802df7:	48 83 ec 30          	sub    $0x30,%rsp
  802dfb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802dfe:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e01:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e05:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e08:	48 89 d6             	mov    %rdx,%rsi
  802e0b:	89 c7                	mov    %eax,%edi
  802e0d:	48 b8 5e 27 80 00 00 	movabs $0x80275e,%rax
  802e14:	00 00 00 
  802e17:	ff d0                	callq  *%rax
  802e19:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e1c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e20:	78 24                	js     802e46 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e26:	8b 00                	mov    (%rax),%eax
  802e28:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e2c:	48 89 d6             	mov    %rdx,%rsi
  802e2f:	89 c7                	mov    %eax,%edi
  802e31:	48 b8 b7 28 80 00 00 	movabs $0x8028b7,%rax
  802e38:	00 00 00 
  802e3b:	ff d0                	callq  *%rax
  802e3d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e40:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e44:	79 05                	jns    802e4b <ftruncate+0x58>
		return r;
  802e46:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e49:	eb 72                	jmp    802ebd <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802e4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e4f:	8b 40 08             	mov    0x8(%rax),%eax
  802e52:	83 e0 03             	and    $0x3,%eax
  802e55:	85 c0                	test   %eax,%eax
  802e57:	75 3a                	jne    802e93 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802e59:	48 b8 d8 81 80 00 00 	movabs $0x8081d8,%rax
  802e60:	00 00 00 
  802e63:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802e66:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802e6c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802e6f:	89 c6                	mov    %eax,%esi
  802e71:	48 bf 88 50 80 00 00 	movabs $0x805088,%rdi
  802e78:	00 00 00 
  802e7b:	b8 00 00 00 00       	mov    $0x0,%eax
  802e80:	48 b9 1d 0d 80 00 00 	movabs $0x800d1d,%rcx
  802e87:	00 00 00 
  802e8a:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802e8c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e91:	eb 2a                	jmp    802ebd <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802e93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e97:	48 8b 40 30          	mov    0x30(%rax),%rax
  802e9b:	48 85 c0             	test   %rax,%rax
  802e9e:	75 07                	jne    802ea7 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802ea0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ea5:	eb 16                	jmp    802ebd <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802ea7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eab:	48 8b 40 30          	mov    0x30(%rax),%rax
  802eaf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802eb3:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802eb6:	89 ce                	mov    %ecx,%esi
  802eb8:	48 89 d7             	mov    %rdx,%rdi
  802ebb:	ff d0                	callq  *%rax
}
  802ebd:	c9                   	leaveq 
  802ebe:	c3                   	retq   

0000000000802ebf <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802ebf:	55                   	push   %rbp
  802ec0:	48 89 e5             	mov    %rsp,%rbp
  802ec3:	48 83 ec 30          	sub    $0x30,%rsp
  802ec7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802eca:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ece:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ed2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ed5:	48 89 d6             	mov    %rdx,%rsi
  802ed8:	89 c7                	mov    %eax,%edi
  802eda:	48 b8 5e 27 80 00 00 	movabs $0x80275e,%rax
  802ee1:	00 00 00 
  802ee4:	ff d0                	callq  *%rax
  802ee6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ee9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802eed:	78 24                	js     802f13 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802eef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ef3:	8b 00                	mov    (%rax),%eax
  802ef5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ef9:	48 89 d6             	mov    %rdx,%rsi
  802efc:	89 c7                	mov    %eax,%edi
  802efe:	48 b8 b7 28 80 00 00 	movabs $0x8028b7,%rax
  802f05:	00 00 00 
  802f08:	ff d0                	callq  *%rax
  802f0a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f0d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f11:	79 05                	jns    802f18 <fstat+0x59>
		return r;
  802f13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f16:	eb 5e                	jmp    802f76 <fstat+0xb7>
	if (!dev->dev_stat)
  802f18:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f1c:	48 8b 40 28          	mov    0x28(%rax),%rax
  802f20:	48 85 c0             	test   %rax,%rax
  802f23:	75 07                	jne    802f2c <fstat+0x6d>
		return -E_NOT_SUPP;
  802f25:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f2a:	eb 4a                	jmp    802f76 <fstat+0xb7>
	stat->st_name[0] = 0;
  802f2c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f30:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802f33:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f37:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802f3e:	00 00 00 
	stat->st_isdir = 0;
  802f41:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f45:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802f4c:	00 00 00 
	stat->st_dev = dev;
  802f4f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f53:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f57:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802f5e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f62:	48 8b 40 28          	mov    0x28(%rax),%rax
  802f66:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802f6a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802f6e:	48 89 ce             	mov    %rcx,%rsi
  802f71:	48 89 d7             	mov    %rdx,%rdi
  802f74:	ff d0                	callq  *%rax
}
  802f76:	c9                   	leaveq 
  802f77:	c3                   	retq   

0000000000802f78 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802f78:	55                   	push   %rbp
  802f79:	48 89 e5             	mov    %rsp,%rbp
  802f7c:	48 83 ec 20          	sub    $0x20,%rsp
  802f80:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f84:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802f88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f8c:	be 00 00 00 00       	mov    $0x0,%esi
  802f91:	48 89 c7             	mov    %rax,%rdi
  802f94:	48 b8 66 30 80 00 00 	movabs $0x803066,%rax
  802f9b:	00 00 00 
  802f9e:	ff d0                	callq  *%rax
  802fa0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fa3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fa7:	79 05                	jns    802fae <stat+0x36>
		return fd;
  802fa9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fac:	eb 2f                	jmp    802fdd <stat+0x65>
	r = fstat(fd, stat);
  802fae:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802fb2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fb5:	48 89 d6             	mov    %rdx,%rsi
  802fb8:	89 c7                	mov    %eax,%edi
  802fba:	48 b8 bf 2e 80 00 00 	movabs $0x802ebf,%rax
  802fc1:	00 00 00 
  802fc4:	ff d0                	callq  *%rax
  802fc6:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802fc9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fcc:	89 c7                	mov    %eax,%edi
  802fce:	48 b8 6e 29 80 00 00 	movabs $0x80296e,%rax
  802fd5:	00 00 00 
  802fd8:	ff d0                	callq  *%rax
	return r;
  802fda:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802fdd:	c9                   	leaveq 
  802fde:	c3                   	retq   

0000000000802fdf <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802fdf:	55                   	push   %rbp
  802fe0:	48 89 e5             	mov    %rsp,%rbp
  802fe3:	48 83 ec 10          	sub    $0x10,%rsp
  802fe7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802fea:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802fee:	48 b8 d0 81 80 00 00 	movabs $0x8081d0,%rax
  802ff5:	00 00 00 
  802ff8:	8b 00                	mov    (%rax),%eax
  802ffa:	85 c0                	test   %eax,%eax
  802ffc:	75 1d                	jne    80301b <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802ffe:	bf 01 00 00 00       	mov    $0x1,%edi
  803003:	48 b8 6c 48 80 00 00 	movabs $0x80486c,%rax
  80300a:	00 00 00 
  80300d:	ff d0                	callq  *%rax
  80300f:	48 ba d0 81 80 00 00 	movabs $0x8081d0,%rdx
  803016:	00 00 00 
  803019:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80301b:	48 b8 d0 81 80 00 00 	movabs $0x8081d0,%rax
  803022:	00 00 00 
  803025:	8b 00                	mov    (%rax),%eax
  803027:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80302a:	b9 07 00 00 00       	mov    $0x7,%ecx
  80302f:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  803036:	00 00 00 
  803039:	89 c7                	mov    %eax,%edi
  80303b:	48 b8 0a 48 80 00 00 	movabs $0x80480a,%rax
  803042:	00 00 00 
  803045:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  803047:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80304b:	ba 00 00 00 00       	mov    $0x0,%edx
  803050:	48 89 c6             	mov    %rax,%rsi
  803053:	bf 00 00 00 00       	mov    $0x0,%edi
  803058:	48 b8 04 47 80 00 00 	movabs $0x804704,%rax
  80305f:	00 00 00 
  803062:	ff d0                	callq  *%rax
}
  803064:	c9                   	leaveq 
  803065:	c3                   	retq   

0000000000803066 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  803066:	55                   	push   %rbp
  803067:	48 89 e5             	mov    %rsp,%rbp
  80306a:	48 83 ec 30          	sub    $0x30,%rsp
  80306e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803072:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  803075:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  80307c:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  803083:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  80308a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80308f:	75 08                	jne    803099 <open+0x33>
	{
		return r;
  803091:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803094:	e9 f2 00 00 00       	jmpq   80318b <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  803099:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80309d:	48 89 c7             	mov    %rax,%rdi
  8030a0:	48 b8 66 18 80 00 00 	movabs $0x801866,%rax
  8030a7:	00 00 00 
  8030aa:	ff d0                	callq  *%rax
  8030ac:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8030af:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  8030b6:	7e 0a                	jle    8030c2 <open+0x5c>
	{
		return -E_BAD_PATH;
  8030b8:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8030bd:	e9 c9 00 00 00       	jmpq   80318b <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  8030c2:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8030c9:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  8030ca:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8030ce:	48 89 c7             	mov    %rax,%rdi
  8030d1:	48 b8 c6 26 80 00 00 	movabs $0x8026c6,%rax
  8030d8:	00 00 00 
  8030db:	ff d0                	callq  *%rax
  8030dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030e4:	78 09                	js     8030ef <open+0x89>
  8030e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030ea:	48 85 c0             	test   %rax,%rax
  8030ed:	75 08                	jne    8030f7 <open+0x91>
		{
			return r;
  8030ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030f2:	e9 94 00 00 00       	jmpq   80318b <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  8030f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030fb:	ba 00 04 00 00       	mov    $0x400,%edx
  803100:	48 89 c6             	mov    %rax,%rsi
  803103:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  80310a:	00 00 00 
  80310d:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  803114:	00 00 00 
  803117:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  803119:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803120:	00 00 00 
  803123:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  803126:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  80312c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803130:	48 89 c6             	mov    %rax,%rsi
  803133:	bf 01 00 00 00       	mov    $0x1,%edi
  803138:	48 b8 df 2f 80 00 00 	movabs $0x802fdf,%rax
  80313f:	00 00 00 
  803142:	ff d0                	callq  *%rax
  803144:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803147:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80314b:	79 2b                	jns    803178 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  80314d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803151:	be 00 00 00 00       	mov    $0x0,%esi
  803156:	48 89 c7             	mov    %rax,%rdi
  803159:	48 b8 ee 27 80 00 00 	movabs $0x8027ee,%rax
  803160:	00 00 00 
  803163:	ff d0                	callq  *%rax
  803165:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803168:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80316c:	79 05                	jns    803173 <open+0x10d>
			{
				return d;
  80316e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803171:	eb 18                	jmp    80318b <open+0x125>
			}
			return r;
  803173:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803176:	eb 13                	jmp    80318b <open+0x125>
		}	
		return fd2num(fd_store);
  803178:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80317c:	48 89 c7             	mov    %rax,%rdi
  80317f:	48 b8 78 26 80 00 00 	movabs $0x802678,%rax
  803186:	00 00 00 
  803189:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  80318b:	c9                   	leaveq 
  80318c:	c3                   	retq   

000000000080318d <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80318d:	55                   	push   %rbp
  80318e:	48 89 e5             	mov    %rsp,%rbp
  803191:	48 83 ec 10          	sub    $0x10,%rsp
  803195:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803199:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80319d:	8b 50 0c             	mov    0xc(%rax),%edx
  8031a0:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8031a7:	00 00 00 
  8031aa:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8031ac:	be 00 00 00 00       	mov    $0x0,%esi
  8031b1:	bf 06 00 00 00       	mov    $0x6,%edi
  8031b6:	48 b8 df 2f 80 00 00 	movabs $0x802fdf,%rax
  8031bd:	00 00 00 
  8031c0:	ff d0                	callq  *%rax
}
  8031c2:	c9                   	leaveq 
  8031c3:	c3                   	retq   

00000000008031c4 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8031c4:	55                   	push   %rbp
  8031c5:	48 89 e5             	mov    %rsp,%rbp
  8031c8:	48 83 ec 30          	sub    $0x30,%rsp
  8031cc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031d0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8031d4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  8031d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  8031df:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8031e4:	74 07                	je     8031ed <devfile_read+0x29>
  8031e6:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8031eb:	75 07                	jne    8031f4 <devfile_read+0x30>
		return -E_INVAL;
  8031ed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8031f2:	eb 77                	jmp    80326b <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8031f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031f8:	8b 50 0c             	mov    0xc(%rax),%edx
  8031fb:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803202:	00 00 00 
  803205:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  803207:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80320e:	00 00 00 
  803211:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803215:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  803219:	be 00 00 00 00       	mov    $0x0,%esi
  80321e:	bf 03 00 00 00       	mov    $0x3,%edi
  803223:	48 b8 df 2f 80 00 00 	movabs $0x802fdf,%rax
  80322a:	00 00 00 
  80322d:	ff d0                	callq  *%rax
  80322f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803232:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803236:	7f 05                	jg     80323d <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  803238:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80323b:	eb 2e                	jmp    80326b <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  80323d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803240:	48 63 d0             	movslq %eax,%rdx
  803243:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803247:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  80324e:	00 00 00 
  803251:	48 89 c7             	mov    %rax,%rdi
  803254:	48 b8 f6 1b 80 00 00 	movabs $0x801bf6,%rax
  80325b:	00 00 00 
  80325e:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  803260:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803264:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  803268:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  80326b:	c9                   	leaveq 
  80326c:	c3                   	retq   

000000000080326d <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80326d:	55                   	push   %rbp
  80326e:	48 89 e5             	mov    %rsp,%rbp
  803271:	48 83 ec 30          	sub    $0x30,%rsp
  803275:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803279:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80327d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  803281:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  803288:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80328d:	74 07                	je     803296 <devfile_write+0x29>
  80328f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803294:	75 08                	jne    80329e <devfile_write+0x31>
		return r;
  803296:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803299:	e9 9a 00 00 00       	jmpq   803338 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80329e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032a2:	8b 50 0c             	mov    0xc(%rax),%edx
  8032a5:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8032ac:	00 00 00 
  8032af:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  8032b1:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8032b8:	00 
  8032b9:	76 08                	jbe    8032c3 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  8032bb:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8032c2:	00 
	}
	fsipcbuf.write.req_n = n;
  8032c3:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8032ca:	00 00 00 
  8032cd:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8032d1:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  8032d5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8032d9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032dd:	48 89 c6             	mov    %rax,%rsi
  8032e0:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  8032e7:	00 00 00 
  8032ea:	48 b8 f6 1b 80 00 00 	movabs $0x801bf6,%rax
  8032f1:	00 00 00 
  8032f4:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  8032f6:	be 00 00 00 00       	mov    $0x0,%esi
  8032fb:	bf 04 00 00 00       	mov    $0x4,%edi
  803300:	48 b8 df 2f 80 00 00 	movabs $0x802fdf,%rax
  803307:	00 00 00 
  80330a:	ff d0                	callq  *%rax
  80330c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80330f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803313:	7f 20                	jg     803335 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  803315:	48 bf ae 50 80 00 00 	movabs $0x8050ae,%rdi
  80331c:	00 00 00 
  80331f:	b8 00 00 00 00       	mov    $0x0,%eax
  803324:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  80332b:	00 00 00 
  80332e:	ff d2                	callq  *%rdx
		return r;
  803330:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803333:	eb 03                	jmp    803338 <devfile_write+0xcb>
	}
	return r;
  803335:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  803338:	c9                   	leaveq 
  803339:	c3                   	retq   

000000000080333a <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80333a:	55                   	push   %rbp
  80333b:	48 89 e5             	mov    %rsp,%rbp
  80333e:	48 83 ec 20          	sub    $0x20,%rsp
  803342:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803346:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80334a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80334e:	8b 50 0c             	mov    0xc(%rax),%edx
  803351:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803358:	00 00 00 
  80335b:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80335d:	be 00 00 00 00       	mov    $0x0,%esi
  803362:	bf 05 00 00 00       	mov    $0x5,%edi
  803367:	48 b8 df 2f 80 00 00 	movabs $0x802fdf,%rax
  80336e:	00 00 00 
  803371:	ff d0                	callq  *%rax
  803373:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803376:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80337a:	79 05                	jns    803381 <devfile_stat+0x47>
		return r;
  80337c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80337f:	eb 56                	jmp    8033d7 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803381:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803385:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  80338c:	00 00 00 
  80338f:	48 89 c7             	mov    %rax,%rdi
  803392:	48 b8 d2 18 80 00 00 	movabs $0x8018d2,%rax
  803399:	00 00 00 
  80339c:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80339e:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8033a5:	00 00 00 
  8033a8:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8033ae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033b2:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8033b8:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8033bf:	00 00 00 
  8033c2:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8033c8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033cc:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8033d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033d7:	c9                   	leaveq 
  8033d8:	c3                   	retq   

00000000008033d9 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8033d9:	55                   	push   %rbp
  8033da:	48 89 e5             	mov    %rsp,%rbp
  8033dd:	48 83 ec 10          	sub    $0x10,%rsp
  8033e1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8033e5:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8033e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033ec:	8b 50 0c             	mov    0xc(%rax),%edx
  8033ef:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8033f6:	00 00 00 
  8033f9:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8033fb:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803402:	00 00 00 
  803405:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803408:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80340b:	be 00 00 00 00       	mov    $0x0,%esi
  803410:	bf 02 00 00 00       	mov    $0x2,%edi
  803415:	48 b8 df 2f 80 00 00 	movabs $0x802fdf,%rax
  80341c:	00 00 00 
  80341f:	ff d0                	callq  *%rax
}
  803421:	c9                   	leaveq 
  803422:	c3                   	retq   

0000000000803423 <remove>:

// Delete a file
int
remove(const char *path)
{
  803423:	55                   	push   %rbp
  803424:	48 89 e5             	mov    %rsp,%rbp
  803427:	48 83 ec 10          	sub    $0x10,%rsp
  80342b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  80342f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803433:	48 89 c7             	mov    %rax,%rdi
  803436:	48 b8 66 18 80 00 00 	movabs $0x801866,%rax
  80343d:	00 00 00 
  803440:	ff d0                	callq  *%rax
  803442:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803447:	7e 07                	jle    803450 <remove+0x2d>
		return -E_BAD_PATH;
  803449:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80344e:	eb 33                	jmp    803483 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803450:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803454:	48 89 c6             	mov    %rax,%rsi
  803457:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  80345e:	00 00 00 
  803461:	48 b8 d2 18 80 00 00 	movabs $0x8018d2,%rax
  803468:	00 00 00 
  80346b:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80346d:	be 00 00 00 00       	mov    $0x0,%esi
  803472:	bf 07 00 00 00       	mov    $0x7,%edi
  803477:	48 b8 df 2f 80 00 00 	movabs $0x802fdf,%rax
  80347e:	00 00 00 
  803481:	ff d0                	callq  *%rax
}
  803483:	c9                   	leaveq 
  803484:	c3                   	retq   

0000000000803485 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803485:	55                   	push   %rbp
  803486:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803489:	be 00 00 00 00       	mov    $0x0,%esi
  80348e:	bf 08 00 00 00       	mov    $0x8,%edi
  803493:	48 b8 df 2f 80 00 00 	movabs $0x802fdf,%rax
  80349a:	00 00 00 
  80349d:	ff d0                	callq  *%rax
}
  80349f:	5d                   	pop    %rbp
  8034a0:	c3                   	retq   

00000000008034a1 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8034a1:	55                   	push   %rbp
  8034a2:	48 89 e5             	mov    %rsp,%rbp
  8034a5:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8034ac:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8034b3:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8034ba:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8034c1:	be 00 00 00 00       	mov    $0x0,%esi
  8034c6:	48 89 c7             	mov    %rax,%rdi
  8034c9:	48 b8 66 30 80 00 00 	movabs $0x803066,%rax
  8034d0:	00 00 00 
  8034d3:	ff d0                	callq  *%rax
  8034d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8034d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034dc:	79 28                	jns    803506 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8034de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034e1:	89 c6                	mov    %eax,%esi
  8034e3:	48 bf ca 50 80 00 00 	movabs $0x8050ca,%rdi
  8034ea:	00 00 00 
  8034ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8034f2:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  8034f9:	00 00 00 
  8034fc:	ff d2                	callq  *%rdx
		return fd_src;
  8034fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803501:	e9 74 01 00 00       	jmpq   80367a <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803506:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  80350d:	be 01 01 00 00       	mov    $0x101,%esi
  803512:	48 89 c7             	mov    %rax,%rdi
  803515:	48 b8 66 30 80 00 00 	movabs $0x803066,%rax
  80351c:	00 00 00 
  80351f:	ff d0                	callq  *%rax
  803521:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803524:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803528:	79 39                	jns    803563 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80352a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80352d:	89 c6                	mov    %eax,%esi
  80352f:	48 bf e0 50 80 00 00 	movabs $0x8050e0,%rdi
  803536:	00 00 00 
  803539:	b8 00 00 00 00       	mov    $0x0,%eax
  80353e:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  803545:	00 00 00 
  803548:	ff d2                	callq  *%rdx
		close(fd_src);
  80354a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80354d:	89 c7                	mov    %eax,%edi
  80354f:	48 b8 6e 29 80 00 00 	movabs $0x80296e,%rax
  803556:	00 00 00 
  803559:	ff d0                	callq  *%rax
		return fd_dest;
  80355b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80355e:	e9 17 01 00 00       	jmpq   80367a <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803563:	eb 74                	jmp    8035d9 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  803565:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803568:	48 63 d0             	movslq %eax,%rdx
  80356b:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803572:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803575:	48 89 ce             	mov    %rcx,%rsi
  803578:	89 c7                	mov    %eax,%edi
  80357a:	48 b8 da 2c 80 00 00 	movabs $0x802cda,%rax
  803581:	00 00 00 
  803584:	ff d0                	callq  *%rax
  803586:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803589:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80358d:	79 4a                	jns    8035d9 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  80358f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803592:	89 c6                	mov    %eax,%esi
  803594:	48 bf fa 50 80 00 00 	movabs $0x8050fa,%rdi
  80359b:	00 00 00 
  80359e:	b8 00 00 00 00       	mov    $0x0,%eax
  8035a3:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  8035aa:	00 00 00 
  8035ad:	ff d2                	callq  *%rdx
			close(fd_src);
  8035af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035b2:	89 c7                	mov    %eax,%edi
  8035b4:	48 b8 6e 29 80 00 00 	movabs $0x80296e,%rax
  8035bb:	00 00 00 
  8035be:	ff d0                	callq  *%rax
			close(fd_dest);
  8035c0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035c3:	89 c7                	mov    %eax,%edi
  8035c5:	48 b8 6e 29 80 00 00 	movabs $0x80296e,%rax
  8035cc:	00 00 00 
  8035cf:	ff d0                	callq  *%rax
			return write_size;
  8035d1:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8035d4:	e9 a1 00 00 00       	jmpq   80367a <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8035d9:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8035e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035e3:	ba 00 02 00 00       	mov    $0x200,%edx
  8035e8:	48 89 ce             	mov    %rcx,%rsi
  8035eb:	89 c7                	mov    %eax,%edi
  8035ed:	48 b8 90 2b 80 00 00 	movabs $0x802b90,%rax
  8035f4:	00 00 00 
  8035f7:	ff d0                	callq  *%rax
  8035f9:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8035fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803600:	0f 8f 5f ff ff ff    	jg     803565 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803606:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80360a:	79 47                	jns    803653 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  80360c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80360f:	89 c6                	mov    %eax,%esi
  803611:	48 bf 0d 51 80 00 00 	movabs $0x80510d,%rdi
  803618:	00 00 00 
  80361b:	b8 00 00 00 00       	mov    $0x0,%eax
  803620:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  803627:	00 00 00 
  80362a:	ff d2                	callq  *%rdx
		close(fd_src);
  80362c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80362f:	89 c7                	mov    %eax,%edi
  803631:	48 b8 6e 29 80 00 00 	movabs $0x80296e,%rax
  803638:	00 00 00 
  80363b:	ff d0                	callq  *%rax
		close(fd_dest);
  80363d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803640:	89 c7                	mov    %eax,%edi
  803642:	48 b8 6e 29 80 00 00 	movabs $0x80296e,%rax
  803649:	00 00 00 
  80364c:	ff d0                	callq  *%rax
		return read_size;
  80364e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803651:	eb 27                	jmp    80367a <copy+0x1d9>
	}
	close(fd_src);
  803653:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803656:	89 c7                	mov    %eax,%edi
  803658:	48 b8 6e 29 80 00 00 	movabs $0x80296e,%rax
  80365f:	00 00 00 
  803662:	ff d0                	callq  *%rax
	close(fd_dest);
  803664:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803667:	89 c7                	mov    %eax,%edi
  803669:	48 b8 6e 29 80 00 00 	movabs $0x80296e,%rax
  803670:	00 00 00 
  803673:	ff d0                	callq  *%rax
	return 0;
  803675:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  80367a:	c9                   	leaveq 
  80367b:	c3                   	retq   

000000000080367c <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  80367c:	55                   	push   %rbp
  80367d:	48 89 e5             	mov    %rsp,%rbp
  803680:	48 83 ec 20          	sub    $0x20,%rsp
  803684:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803687:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80368b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80368e:	48 89 d6             	mov    %rdx,%rsi
  803691:	89 c7                	mov    %eax,%edi
  803693:	48 b8 5e 27 80 00 00 	movabs $0x80275e,%rax
  80369a:	00 00 00 
  80369d:	ff d0                	callq  *%rax
  80369f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036a6:	79 05                	jns    8036ad <fd2sockid+0x31>
		return r;
  8036a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036ab:	eb 24                	jmp    8036d1 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8036ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036b1:	8b 10                	mov    (%rax),%edx
  8036b3:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  8036ba:	00 00 00 
  8036bd:	8b 00                	mov    (%rax),%eax
  8036bf:	39 c2                	cmp    %eax,%edx
  8036c1:	74 07                	je     8036ca <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  8036c3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8036c8:	eb 07                	jmp    8036d1 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8036ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036ce:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8036d1:	c9                   	leaveq 
  8036d2:	c3                   	retq   

00000000008036d3 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8036d3:	55                   	push   %rbp
  8036d4:	48 89 e5             	mov    %rsp,%rbp
  8036d7:	48 83 ec 20          	sub    $0x20,%rsp
  8036db:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8036de:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8036e2:	48 89 c7             	mov    %rax,%rdi
  8036e5:	48 b8 c6 26 80 00 00 	movabs $0x8026c6,%rax
  8036ec:	00 00 00 
  8036ef:	ff d0                	callq  *%rax
  8036f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036f8:	78 26                	js     803720 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8036fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036fe:	ba 07 04 00 00       	mov    $0x407,%edx
  803703:	48 89 c6             	mov    %rax,%rsi
  803706:	bf 00 00 00 00       	mov    $0x0,%edi
  80370b:	48 b8 01 22 80 00 00 	movabs $0x802201,%rax
  803712:	00 00 00 
  803715:	ff d0                	callq  *%rax
  803717:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80371a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80371e:	79 16                	jns    803736 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803720:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803723:	89 c7                	mov    %eax,%edi
  803725:	48 b8 e0 3b 80 00 00 	movabs $0x803be0,%rax
  80372c:	00 00 00 
  80372f:	ff d0                	callq  *%rax
		return r;
  803731:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803734:	eb 3a                	jmp    803770 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803736:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80373a:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  803741:	00 00 00 
  803744:	8b 12                	mov    (%rdx),%edx
  803746:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803748:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80374c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803753:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803757:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80375a:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  80375d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803761:	48 89 c7             	mov    %rax,%rdi
  803764:	48 b8 78 26 80 00 00 	movabs $0x802678,%rax
  80376b:	00 00 00 
  80376e:	ff d0                	callq  *%rax
}
  803770:	c9                   	leaveq 
  803771:	c3                   	retq   

0000000000803772 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803772:	55                   	push   %rbp
  803773:	48 89 e5             	mov    %rsp,%rbp
  803776:	48 83 ec 30          	sub    $0x30,%rsp
  80377a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80377d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803781:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803785:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803788:	89 c7                	mov    %eax,%edi
  80378a:	48 b8 7c 36 80 00 00 	movabs $0x80367c,%rax
  803791:	00 00 00 
  803794:	ff d0                	callq  *%rax
  803796:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803799:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80379d:	79 05                	jns    8037a4 <accept+0x32>
		return r;
  80379f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037a2:	eb 3b                	jmp    8037df <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8037a4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8037a8:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8037ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037af:	48 89 ce             	mov    %rcx,%rsi
  8037b2:	89 c7                	mov    %eax,%edi
  8037b4:	48 b8 bd 3a 80 00 00 	movabs $0x803abd,%rax
  8037bb:	00 00 00 
  8037be:	ff d0                	callq  *%rax
  8037c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037c7:	79 05                	jns    8037ce <accept+0x5c>
		return r;
  8037c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037cc:	eb 11                	jmp    8037df <accept+0x6d>
	return alloc_sockfd(r);
  8037ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037d1:	89 c7                	mov    %eax,%edi
  8037d3:	48 b8 d3 36 80 00 00 	movabs $0x8036d3,%rax
  8037da:	00 00 00 
  8037dd:	ff d0                	callq  *%rax
}
  8037df:	c9                   	leaveq 
  8037e0:	c3                   	retq   

00000000008037e1 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8037e1:	55                   	push   %rbp
  8037e2:	48 89 e5             	mov    %rsp,%rbp
  8037e5:	48 83 ec 20          	sub    $0x20,%rsp
  8037e9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8037ec:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8037f0:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8037f3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037f6:	89 c7                	mov    %eax,%edi
  8037f8:	48 b8 7c 36 80 00 00 	movabs $0x80367c,%rax
  8037ff:	00 00 00 
  803802:	ff d0                	callq  *%rax
  803804:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803807:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80380b:	79 05                	jns    803812 <bind+0x31>
		return r;
  80380d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803810:	eb 1b                	jmp    80382d <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803812:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803815:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803819:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80381c:	48 89 ce             	mov    %rcx,%rsi
  80381f:	89 c7                	mov    %eax,%edi
  803821:	48 b8 3c 3b 80 00 00 	movabs $0x803b3c,%rax
  803828:	00 00 00 
  80382b:	ff d0                	callq  *%rax
}
  80382d:	c9                   	leaveq 
  80382e:	c3                   	retq   

000000000080382f <shutdown>:

int
shutdown(int s, int how)
{
  80382f:	55                   	push   %rbp
  803830:	48 89 e5             	mov    %rsp,%rbp
  803833:	48 83 ec 20          	sub    $0x20,%rsp
  803837:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80383a:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80383d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803840:	89 c7                	mov    %eax,%edi
  803842:	48 b8 7c 36 80 00 00 	movabs $0x80367c,%rax
  803849:	00 00 00 
  80384c:	ff d0                	callq  *%rax
  80384e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803851:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803855:	79 05                	jns    80385c <shutdown+0x2d>
		return r;
  803857:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80385a:	eb 16                	jmp    803872 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  80385c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80385f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803862:	89 d6                	mov    %edx,%esi
  803864:	89 c7                	mov    %eax,%edi
  803866:	48 b8 a0 3b 80 00 00 	movabs $0x803ba0,%rax
  80386d:	00 00 00 
  803870:	ff d0                	callq  *%rax
}
  803872:	c9                   	leaveq 
  803873:	c3                   	retq   

0000000000803874 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803874:	55                   	push   %rbp
  803875:	48 89 e5             	mov    %rsp,%rbp
  803878:	48 83 ec 10          	sub    $0x10,%rsp
  80387c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803880:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803884:	48 89 c7             	mov    %rax,%rdi
  803887:	48 b8 ee 48 80 00 00 	movabs $0x8048ee,%rax
  80388e:	00 00 00 
  803891:	ff d0                	callq  *%rax
  803893:	83 f8 01             	cmp    $0x1,%eax
  803896:	75 17                	jne    8038af <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803898:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80389c:	8b 40 0c             	mov    0xc(%rax),%eax
  80389f:	89 c7                	mov    %eax,%edi
  8038a1:	48 b8 e0 3b 80 00 00 	movabs $0x803be0,%rax
  8038a8:	00 00 00 
  8038ab:	ff d0                	callq  *%rax
  8038ad:	eb 05                	jmp    8038b4 <devsock_close+0x40>
	else
		return 0;
  8038af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8038b4:	c9                   	leaveq 
  8038b5:	c3                   	retq   

00000000008038b6 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8038b6:	55                   	push   %rbp
  8038b7:	48 89 e5             	mov    %rsp,%rbp
  8038ba:	48 83 ec 20          	sub    $0x20,%rsp
  8038be:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8038c1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8038c5:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8038c8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038cb:	89 c7                	mov    %eax,%edi
  8038cd:	48 b8 7c 36 80 00 00 	movabs $0x80367c,%rax
  8038d4:	00 00 00 
  8038d7:	ff d0                	callq  *%rax
  8038d9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038e0:	79 05                	jns    8038e7 <connect+0x31>
		return r;
  8038e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038e5:	eb 1b                	jmp    803902 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8038e7:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8038ea:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8038ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038f1:	48 89 ce             	mov    %rcx,%rsi
  8038f4:	89 c7                	mov    %eax,%edi
  8038f6:	48 b8 0d 3c 80 00 00 	movabs $0x803c0d,%rax
  8038fd:	00 00 00 
  803900:	ff d0                	callq  *%rax
}
  803902:	c9                   	leaveq 
  803903:	c3                   	retq   

0000000000803904 <listen>:

int
listen(int s, int backlog)
{
  803904:	55                   	push   %rbp
  803905:	48 89 e5             	mov    %rsp,%rbp
  803908:	48 83 ec 20          	sub    $0x20,%rsp
  80390c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80390f:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803912:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803915:	89 c7                	mov    %eax,%edi
  803917:	48 b8 7c 36 80 00 00 	movabs $0x80367c,%rax
  80391e:	00 00 00 
  803921:	ff d0                	callq  *%rax
  803923:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803926:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80392a:	79 05                	jns    803931 <listen+0x2d>
		return r;
  80392c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80392f:	eb 16                	jmp    803947 <listen+0x43>
	return nsipc_listen(r, backlog);
  803931:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803934:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803937:	89 d6                	mov    %edx,%esi
  803939:	89 c7                	mov    %eax,%edi
  80393b:	48 b8 71 3c 80 00 00 	movabs $0x803c71,%rax
  803942:	00 00 00 
  803945:	ff d0                	callq  *%rax
}
  803947:	c9                   	leaveq 
  803948:	c3                   	retq   

0000000000803949 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803949:	55                   	push   %rbp
  80394a:	48 89 e5             	mov    %rsp,%rbp
  80394d:	48 83 ec 20          	sub    $0x20,%rsp
  803951:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803955:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803959:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80395d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803961:	89 c2                	mov    %eax,%edx
  803963:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803967:	8b 40 0c             	mov    0xc(%rax),%eax
  80396a:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80396e:	b9 00 00 00 00       	mov    $0x0,%ecx
  803973:	89 c7                	mov    %eax,%edi
  803975:	48 b8 b1 3c 80 00 00 	movabs $0x803cb1,%rax
  80397c:	00 00 00 
  80397f:	ff d0                	callq  *%rax
}
  803981:	c9                   	leaveq 
  803982:	c3                   	retq   

0000000000803983 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803983:	55                   	push   %rbp
  803984:	48 89 e5             	mov    %rsp,%rbp
  803987:	48 83 ec 20          	sub    $0x20,%rsp
  80398b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80398f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803993:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803997:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80399b:	89 c2                	mov    %eax,%edx
  80399d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039a1:	8b 40 0c             	mov    0xc(%rax),%eax
  8039a4:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8039a8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8039ad:	89 c7                	mov    %eax,%edi
  8039af:	48 b8 7d 3d 80 00 00 	movabs $0x803d7d,%rax
  8039b6:	00 00 00 
  8039b9:	ff d0                	callq  *%rax
}
  8039bb:	c9                   	leaveq 
  8039bc:	c3                   	retq   

00000000008039bd <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8039bd:	55                   	push   %rbp
  8039be:	48 89 e5             	mov    %rsp,%rbp
  8039c1:	48 83 ec 10          	sub    $0x10,%rsp
  8039c5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8039c9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8039cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039d1:	48 be 28 51 80 00 00 	movabs $0x805128,%rsi
  8039d8:	00 00 00 
  8039db:	48 89 c7             	mov    %rax,%rdi
  8039de:	48 b8 d2 18 80 00 00 	movabs $0x8018d2,%rax
  8039e5:	00 00 00 
  8039e8:	ff d0                	callq  *%rax
	return 0;
  8039ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8039ef:	c9                   	leaveq 
  8039f0:	c3                   	retq   

00000000008039f1 <socket>:

int
socket(int domain, int type, int protocol)
{
  8039f1:	55                   	push   %rbp
  8039f2:	48 89 e5             	mov    %rsp,%rbp
  8039f5:	48 83 ec 20          	sub    $0x20,%rsp
  8039f9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8039fc:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8039ff:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803a02:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803a05:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803a08:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a0b:	89 ce                	mov    %ecx,%esi
  803a0d:	89 c7                	mov    %eax,%edi
  803a0f:	48 b8 35 3e 80 00 00 	movabs $0x803e35,%rax
  803a16:	00 00 00 
  803a19:	ff d0                	callq  *%rax
  803a1b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a1e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a22:	79 05                	jns    803a29 <socket+0x38>
		return r;
  803a24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a27:	eb 11                	jmp    803a3a <socket+0x49>
	return alloc_sockfd(r);
  803a29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a2c:	89 c7                	mov    %eax,%edi
  803a2e:	48 b8 d3 36 80 00 00 	movabs $0x8036d3,%rax
  803a35:	00 00 00 
  803a38:	ff d0                	callq  *%rax
}
  803a3a:	c9                   	leaveq 
  803a3b:	c3                   	retq   

0000000000803a3c <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803a3c:	55                   	push   %rbp
  803a3d:	48 89 e5             	mov    %rsp,%rbp
  803a40:	48 83 ec 10          	sub    $0x10,%rsp
  803a44:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803a47:	48 b8 d4 81 80 00 00 	movabs $0x8081d4,%rax
  803a4e:	00 00 00 
  803a51:	8b 00                	mov    (%rax),%eax
  803a53:	85 c0                	test   %eax,%eax
  803a55:	75 1d                	jne    803a74 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803a57:	bf 02 00 00 00       	mov    $0x2,%edi
  803a5c:	48 b8 6c 48 80 00 00 	movabs $0x80486c,%rax
  803a63:	00 00 00 
  803a66:	ff d0                	callq  *%rax
  803a68:	48 ba d4 81 80 00 00 	movabs $0x8081d4,%rdx
  803a6f:	00 00 00 
  803a72:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803a74:	48 b8 d4 81 80 00 00 	movabs $0x8081d4,%rax
  803a7b:	00 00 00 
  803a7e:	8b 00                	mov    (%rax),%eax
  803a80:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803a83:	b9 07 00 00 00       	mov    $0x7,%ecx
  803a88:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803a8f:	00 00 00 
  803a92:	89 c7                	mov    %eax,%edi
  803a94:	48 b8 0a 48 80 00 00 	movabs $0x80480a,%rax
  803a9b:	00 00 00 
  803a9e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803aa0:	ba 00 00 00 00       	mov    $0x0,%edx
  803aa5:	be 00 00 00 00       	mov    $0x0,%esi
  803aaa:	bf 00 00 00 00       	mov    $0x0,%edi
  803aaf:	48 b8 04 47 80 00 00 	movabs $0x804704,%rax
  803ab6:	00 00 00 
  803ab9:	ff d0                	callq  *%rax
}
  803abb:	c9                   	leaveq 
  803abc:	c3                   	retq   

0000000000803abd <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803abd:	55                   	push   %rbp
  803abe:	48 89 e5             	mov    %rsp,%rbp
  803ac1:	48 83 ec 30          	sub    $0x30,%rsp
  803ac5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803ac8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803acc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803ad0:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ad7:	00 00 00 
  803ada:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803add:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803adf:	bf 01 00 00 00       	mov    $0x1,%edi
  803ae4:	48 b8 3c 3a 80 00 00 	movabs $0x803a3c,%rax
  803aeb:	00 00 00 
  803aee:	ff d0                	callq  *%rax
  803af0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803af3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803af7:	78 3e                	js     803b37 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803af9:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b00:	00 00 00 
  803b03:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803b07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b0b:	8b 40 10             	mov    0x10(%rax),%eax
  803b0e:	89 c2                	mov    %eax,%edx
  803b10:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803b14:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b18:	48 89 ce             	mov    %rcx,%rsi
  803b1b:	48 89 c7             	mov    %rax,%rdi
  803b1e:	48 b8 f6 1b 80 00 00 	movabs $0x801bf6,%rax
  803b25:	00 00 00 
  803b28:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803b2a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b2e:	8b 50 10             	mov    0x10(%rax),%edx
  803b31:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b35:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803b37:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803b3a:	c9                   	leaveq 
  803b3b:	c3                   	retq   

0000000000803b3c <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803b3c:	55                   	push   %rbp
  803b3d:	48 89 e5             	mov    %rsp,%rbp
  803b40:	48 83 ec 10          	sub    $0x10,%rsp
  803b44:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803b47:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803b4b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803b4e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b55:	00 00 00 
  803b58:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b5b:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803b5d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b60:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b64:	48 89 c6             	mov    %rax,%rsi
  803b67:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803b6e:	00 00 00 
  803b71:	48 b8 f6 1b 80 00 00 	movabs $0x801bf6,%rax
  803b78:	00 00 00 
  803b7b:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803b7d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b84:	00 00 00 
  803b87:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b8a:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803b8d:	bf 02 00 00 00       	mov    $0x2,%edi
  803b92:	48 b8 3c 3a 80 00 00 	movabs $0x803a3c,%rax
  803b99:	00 00 00 
  803b9c:	ff d0                	callq  *%rax
}
  803b9e:	c9                   	leaveq 
  803b9f:	c3                   	retq   

0000000000803ba0 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803ba0:	55                   	push   %rbp
  803ba1:	48 89 e5             	mov    %rsp,%rbp
  803ba4:	48 83 ec 10          	sub    $0x10,%rsp
  803ba8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803bab:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803bae:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bb5:	00 00 00 
  803bb8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803bbb:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803bbd:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bc4:	00 00 00 
  803bc7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803bca:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803bcd:	bf 03 00 00 00       	mov    $0x3,%edi
  803bd2:	48 b8 3c 3a 80 00 00 	movabs $0x803a3c,%rax
  803bd9:	00 00 00 
  803bdc:	ff d0                	callq  *%rax
}
  803bde:	c9                   	leaveq 
  803bdf:	c3                   	retq   

0000000000803be0 <nsipc_close>:

int
nsipc_close(int s)
{
  803be0:	55                   	push   %rbp
  803be1:	48 89 e5             	mov    %rsp,%rbp
  803be4:	48 83 ec 10          	sub    $0x10,%rsp
  803be8:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803beb:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bf2:	00 00 00 
  803bf5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803bf8:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803bfa:	bf 04 00 00 00       	mov    $0x4,%edi
  803bff:	48 b8 3c 3a 80 00 00 	movabs $0x803a3c,%rax
  803c06:	00 00 00 
  803c09:	ff d0                	callq  *%rax
}
  803c0b:	c9                   	leaveq 
  803c0c:	c3                   	retq   

0000000000803c0d <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803c0d:	55                   	push   %rbp
  803c0e:	48 89 e5             	mov    %rsp,%rbp
  803c11:	48 83 ec 10          	sub    $0x10,%rsp
  803c15:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c18:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803c1c:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803c1f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c26:	00 00 00 
  803c29:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c2c:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803c2e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c31:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c35:	48 89 c6             	mov    %rax,%rsi
  803c38:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803c3f:	00 00 00 
  803c42:	48 b8 f6 1b 80 00 00 	movabs $0x801bf6,%rax
  803c49:	00 00 00 
  803c4c:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803c4e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c55:	00 00 00 
  803c58:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c5b:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803c5e:	bf 05 00 00 00       	mov    $0x5,%edi
  803c63:	48 b8 3c 3a 80 00 00 	movabs $0x803a3c,%rax
  803c6a:	00 00 00 
  803c6d:	ff d0                	callq  *%rax
}
  803c6f:	c9                   	leaveq 
  803c70:	c3                   	retq   

0000000000803c71 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803c71:	55                   	push   %rbp
  803c72:	48 89 e5             	mov    %rsp,%rbp
  803c75:	48 83 ec 10          	sub    $0x10,%rsp
  803c79:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c7c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803c7f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c86:	00 00 00 
  803c89:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c8c:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803c8e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c95:	00 00 00 
  803c98:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c9b:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803c9e:	bf 06 00 00 00       	mov    $0x6,%edi
  803ca3:	48 b8 3c 3a 80 00 00 	movabs $0x803a3c,%rax
  803caa:	00 00 00 
  803cad:	ff d0                	callq  *%rax
}
  803caf:	c9                   	leaveq 
  803cb0:	c3                   	retq   

0000000000803cb1 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803cb1:	55                   	push   %rbp
  803cb2:	48 89 e5             	mov    %rsp,%rbp
  803cb5:	48 83 ec 30          	sub    $0x30,%rsp
  803cb9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803cbc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803cc0:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803cc3:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803cc6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ccd:	00 00 00 
  803cd0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803cd3:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803cd5:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cdc:	00 00 00 
  803cdf:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803ce2:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803ce5:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cec:	00 00 00 
  803cef:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803cf2:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803cf5:	bf 07 00 00 00       	mov    $0x7,%edi
  803cfa:	48 b8 3c 3a 80 00 00 	movabs $0x803a3c,%rax
  803d01:	00 00 00 
  803d04:	ff d0                	callq  *%rax
  803d06:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d09:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d0d:	78 69                	js     803d78 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803d0f:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803d16:	7f 08                	jg     803d20 <nsipc_recv+0x6f>
  803d18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d1b:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803d1e:	7e 35                	jle    803d55 <nsipc_recv+0xa4>
  803d20:	48 b9 2f 51 80 00 00 	movabs $0x80512f,%rcx
  803d27:	00 00 00 
  803d2a:	48 ba 44 51 80 00 00 	movabs $0x805144,%rdx
  803d31:	00 00 00 
  803d34:	be 61 00 00 00       	mov    $0x61,%esi
  803d39:	48 bf 59 51 80 00 00 	movabs $0x805159,%rdi
  803d40:	00 00 00 
  803d43:	b8 00 00 00 00       	mov    $0x0,%eax
  803d48:	49 b8 e4 0a 80 00 00 	movabs $0x800ae4,%r8
  803d4f:	00 00 00 
  803d52:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803d55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d58:	48 63 d0             	movslq %eax,%rdx
  803d5b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d5f:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803d66:	00 00 00 
  803d69:	48 89 c7             	mov    %rax,%rdi
  803d6c:	48 b8 f6 1b 80 00 00 	movabs $0x801bf6,%rax
  803d73:	00 00 00 
  803d76:	ff d0                	callq  *%rax
	}

	return r;
  803d78:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803d7b:	c9                   	leaveq 
  803d7c:	c3                   	retq   

0000000000803d7d <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803d7d:	55                   	push   %rbp
  803d7e:	48 89 e5             	mov    %rsp,%rbp
  803d81:	48 83 ec 20          	sub    $0x20,%rsp
  803d85:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803d88:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803d8c:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803d8f:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803d92:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d99:	00 00 00 
  803d9c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803d9f:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803da1:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803da8:	7e 35                	jle    803ddf <nsipc_send+0x62>
  803daa:	48 b9 65 51 80 00 00 	movabs $0x805165,%rcx
  803db1:	00 00 00 
  803db4:	48 ba 44 51 80 00 00 	movabs $0x805144,%rdx
  803dbb:	00 00 00 
  803dbe:	be 6c 00 00 00       	mov    $0x6c,%esi
  803dc3:	48 bf 59 51 80 00 00 	movabs $0x805159,%rdi
  803dca:	00 00 00 
  803dcd:	b8 00 00 00 00       	mov    $0x0,%eax
  803dd2:	49 b8 e4 0a 80 00 00 	movabs $0x800ae4,%r8
  803dd9:	00 00 00 
  803ddc:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803ddf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803de2:	48 63 d0             	movslq %eax,%rdx
  803de5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803de9:	48 89 c6             	mov    %rax,%rsi
  803dec:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803df3:	00 00 00 
  803df6:	48 b8 f6 1b 80 00 00 	movabs $0x801bf6,%rax
  803dfd:	00 00 00 
  803e00:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803e02:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e09:	00 00 00 
  803e0c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803e0f:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803e12:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e19:	00 00 00 
  803e1c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803e1f:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803e22:	bf 08 00 00 00       	mov    $0x8,%edi
  803e27:	48 b8 3c 3a 80 00 00 	movabs $0x803a3c,%rax
  803e2e:	00 00 00 
  803e31:	ff d0                	callq  *%rax
}
  803e33:	c9                   	leaveq 
  803e34:	c3                   	retq   

0000000000803e35 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803e35:	55                   	push   %rbp
  803e36:	48 89 e5             	mov    %rsp,%rbp
  803e39:	48 83 ec 10          	sub    $0x10,%rsp
  803e3d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803e40:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803e43:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803e46:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e4d:	00 00 00 
  803e50:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803e53:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803e55:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e5c:	00 00 00 
  803e5f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803e62:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803e65:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e6c:	00 00 00 
  803e6f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803e72:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803e75:	bf 09 00 00 00       	mov    $0x9,%edi
  803e7a:	48 b8 3c 3a 80 00 00 	movabs $0x803a3c,%rax
  803e81:	00 00 00 
  803e84:	ff d0                	callq  *%rax
}
  803e86:	c9                   	leaveq 
  803e87:	c3                   	retq   

0000000000803e88 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803e88:	55                   	push   %rbp
  803e89:	48 89 e5             	mov    %rsp,%rbp
  803e8c:	53                   	push   %rbx
  803e8d:	48 83 ec 38          	sub    $0x38,%rsp
  803e91:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803e95:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803e99:	48 89 c7             	mov    %rax,%rdi
  803e9c:	48 b8 c6 26 80 00 00 	movabs $0x8026c6,%rax
  803ea3:	00 00 00 
  803ea6:	ff d0                	callq  *%rax
  803ea8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803eab:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803eaf:	0f 88 bf 01 00 00    	js     804074 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803eb5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803eb9:	ba 07 04 00 00       	mov    $0x407,%edx
  803ebe:	48 89 c6             	mov    %rax,%rsi
  803ec1:	bf 00 00 00 00       	mov    $0x0,%edi
  803ec6:	48 b8 01 22 80 00 00 	movabs $0x802201,%rax
  803ecd:	00 00 00 
  803ed0:	ff d0                	callq  *%rax
  803ed2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ed5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ed9:	0f 88 95 01 00 00    	js     804074 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803edf:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803ee3:	48 89 c7             	mov    %rax,%rdi
  803ee6:	48 b8 c6 26 80 00 00 	movabs $0x8026c6,%rax
  803eed:	00 00 00 
  803ef0:	ff d0                	callq  *%rax
  803ef2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ef5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ef9:	0f 88 5d 01 00 00    	js     80405c <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803eff:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f03:	ba 07 04 00 00       	mov    $0x407,%edx
  803f08:	48 89 c6             	mov    %rax,%rsi
  803f0b:	bf 00 00 00 00       	mov    $0x0,%edi
  803f10:	48 b8 01 22 80 00 00 	movabs $0x802201,%rax
  803f17:	00 00 00 
  803f1a:	ff d0                	callq  *%rax
  803f1c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f1f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f23:	0f 88 33 01 00 00    	js     80405c <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803f29:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f2d:	48 89 c7             	mov    %rax,%rdi
  803f30:	48 b8 9b 26 80 00 00 	movabs $0x80269b,%rax
  803f37:	00 00 00 
  803f3a:	ff d0                	callq  *%rax
  803f3c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803f40:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f44:	ba 07 04 00 00       	mov    $0x407,%edx
  803f49:	48 89 c6             	mov    %rax,%rsi
  803f4c:	bf 00 00 00 00       	mov    $0x0,%edi
  803f51:	48 b8 01 22 80 00 00 	movabs $0x802201,%rax
  803f58:	00 00 00 
  803f5b:	ff d0                	callq  *%rax
  803f5d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f60:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f64:	79 05                	jns    803f6b <pipe+0xe3>
		goto err2;
  803f66:	e9 d9 00 00 00       	jmpq   804044 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803f6b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f6f:	48 89 c7             	mov    %rax,%rdi
  803f72:	48 b8 9b 26 80 00 00 	movabs $0x80269b,%rax
  803f79:	00 00 00 
  803f7c:	ff d0                	callq  *%rax
  803f7e:	48 89 c2             	mov    %rax,%rdx
  803f81:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f85:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803f8b:	48 89 d1             	mov    %rdx,%rcx
  803f8e:	ba 00 00 00 00       	mov    $0x0,%edx
  803f93:	48 89 c6             	mov    %rax,%rsi
  803f96:	bf 00 00 00 00       	mov    $0x0,%edi
  803f9b:	48 b8 51 22 80 00 00 	movabs $0x802251,%rax
  803fa2:	00 00 00 
  803fa5:	ff d0                	callq  *%rax
  803fa7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803faa:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803fae:	79 1b                	jns    803fcb <pipe+0x143>
		goto err3;
  803fb0:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803fb1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fb5:	48 89 c6             	mov    %rax,%rsi
  803fb8:	bf 00 00 00 00       	mov    $0x0,%edi
  803fbd:	48 b8 ac 22 80 00 00 	movabs $0x8022ac,%rax
  803fc4:	00 00 00 
  803fc7:	ff d0                	callq  *%rax
  803fc9:	eb 79                	jmp    804044 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803fcb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fcf:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803fd6:	00 00 00 
  803fd9:	8b 12                	mov    (%rdx),%edx
  803fdb:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803fdd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fe1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803fe8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803fec:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803ff3:	00 00 00 
  803ff6:	8b 12                	mov    (%rdx),%edx
  803ff8:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803ffa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ffe:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  804005:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804009:	48 89 c7             	mov    %rax,%rdi
  80400c:	48 b8 78 26 80 00 00 	movabs $0x802678,%rax
  804013:	00 00 00 
  804016:	ff d0                	callq  *%rax
  804018:	89 c2                	mov    %eax,%edx
  80401a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80401e:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  804020:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804024:	48 8d 58 04          	lea    0x4(%rax),%rbx
  804028:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80402c:	48 89 c7             	mov    %rax,%rdi
  80402f:	48 b8 78 26 80 00 00 	movabs $0x802678,%rax
  804036:	00 00 00 
  804039:	ff d0                	callq  *%rax
  80403b:	89 03                	mov    %eax,(%rbx)
	return 0;
  80403d:	b8 00 00 00 00       	mov    $0x0,%eax
  804042:	eb 33                	jmp    804077 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  804044:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804048:	48 89 c6             	mov    %rax,%rsi
  80404b:	bf 00 00 00 00       	mov    $0x0,%edi
  804050:	48 b8 ac 22 80 00 00 	movabs $0x8022ac,%rax
  804057:	00 00 00 
  80405a:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80405c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804060:	48 89 c6             	mov    %rax,%rsi
  804063:	bf 00 00 00 00       	mov    $0x0,%edi
  804068:	48 b8 ac 22 80 00 00 	movabs $0x8022ac,%rax
  80406f:	00 00 00 
  804072:	ff d0                	callq  *%rax
err:
	return r;
  804074:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804077:	48 83 c4 38          	add    $0x38,%rsp
  80407b:	5b                   	pop    %rbx
  80407c:	5d                   	pop    %rbp
  80407d:	c3                   	retq   

000000000080407e <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80407e:	55                   	push   %rbp
  80407f:	48 89 e5             	mov    %rsp,%rbp
  804082:	53                   	push   %rbx
  804083:	48 83 ec 28          	sub    $0x28,%rsp
  804087:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80408b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80408f:	48 b8 d8 81 80 00 00 	movabs $0x8081d8,%rax
  804096:	00 00 00 
  804099:	48 8b 00             	mov    (%rax),%rax
  80409c:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8040a2:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8040a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040a9:	48 89 c7             	mov    %rax,%rdi
  8040ac:	48 b8 ee 48 80 00 00 	movabs $0x8048ee,%rax
  8040b3:	00 00 00 
  8040b6:	ff d0                	callq  *%rax
  8040b8:	89 c3                	mov    %eax,%ebx
  8040ba:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040be:	48 89 c7             	mov    %rax,%rdi
  8040c1:	48 b8 ee 48 80 00 00 	movabs $0x8048ee,%rax
  8040c8:	00 00 00 
  8040cb:	ff d0                	callq  *%rax
  8040cd:	39 c3                	cmp    %eax,%ebx
  8040cf:	0f 94 c0             	sete   %al
  8040d2:	0f b6 c0             	movzbl %al,%eax
  8040d5:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8040d8:	48 b8 d8 81 80 00 00 	movabs $0x8081d8,%rax
  8040df:	00 00 00 
  8040e2:	48 8b 00             	mov    (%rax),%rax
  8040e5:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8040eb:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8040ee:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8040f1:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8040f4:	75 05                	jne    8040fb <_pipeisclosed+0x7d>
			return ret;
  8040f6:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8040f9:	eb 4f                	jmp    80414a <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8040fb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8040fe:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804101:	74 42                	je     804145 <_pipeisclosed+0xc7>
  804103:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  804107:	75 3c                	jne    804145 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804109:	48 b8 d8 81 80 00 00 	movabs $0x8081d8,%rax
  804110:	00 00 00 
  804113:	48 8b 00             	mov    (%rax),%rax
  804116:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80411c:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80411f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804122:	89 c6                	mov    %eax,%esi
  804124:	48 bf 76 51 80 00 00 	movabs $0x805176,%rdi
  80412b:	00 00 00 
  80412e:	b8 00 00 00 00       	mov    $0x0,%eax
  804133:	49 b8 1d 0d 80 00 00 	movabs $0x800d1d,%r8
  80413a:	00 00 00 
  80413d:	41 ff d0             	callq  *%r8
	}
  804140:	e9 4a ff ff ff       	jmpq   80408f <_pipeisclosed+0x11>
  804145:	e9 45 ff ff ff       	jmpq   80408f <_pipeisclosed+0x11>
}
  80414a:	48 83 c4 28          	add    $0x28,%rsp
  80414e:	5b                   	pop    %rbx
  80414f:	5d                   	pop    %rbp
  804150:	c3                   	retq   

0000000000804151 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  804151:	55                   	push   %rbp
  804152:	48 89 e5             	mov    %rsp,%rbp
  804155:	48 83 ec 30          	sub    $0x30,%rsp
  804159:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80415c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804160:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804163:	48 89 d6             	mov    %rdx,%rsi
  804166:	89 c7                	mov    %eax,%edi
  804168:	48 b8 5e 27 80 00 00 	movabs $0x80275e,%rax
  80416f:	00 00 00 
  804172:	ff d0                	callq  *%rax
  804174:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804177:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80417b:	79 05                	jns    804182 <pipeisclosed+0x31>
		return r;
  80417d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804180:	eb 31                	jmp    8041b3 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  804182:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804186:	48 89 c7             	mov    %rax,%rdi
  804189:	48 b8 9b 26 80 00 00 	movabs $0x80269b,%rax
  804190:	00 00 00 
  804193:	ff d0                	callq  *%rax
  804195:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804199:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80419d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8041a1:	48 89 d6             	mov    %rdx,%rsi
  8041a4:	48 89 c7             	mov    %rax,%rdi
  8041a7:	48 b8 7e 40 80 00 00 	movabs $0x80407e,%rax
  8041ae:	00 00 00 
  8041b1:	ff d0                	callq  *%rax
}
  8041b3:	c9                   	leaveq 
  8041b4:	c3                   	retq   

00000000008041b5 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8041b5:	55                   	push   %rbp
  8041b6:	48 89 e5             	mov    %rsp,%rbp
  8041b9:	48 83 ec 40          	sub    $0x40,%rsp
  8041bd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8041c1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8041c5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8041c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041cd:	48 89 c7             	mov    %rax,%rdi
  8041d0:	48 b8 9b 26 80 00 00 	movabs $0x80269b,%rax
  8041d7:	00 00 00 
  8041da:	ff d0                	callq  *%rax
  8041dc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8041e0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041e4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8041e8:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8041ef:	00 
  8041f0:	e9 92 00 00 00       	jmpq   804287 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8041f5:	eb 41                	jmp    804238 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8041f7:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8041fc:	74 09                	je     804207 <devpipe_read+0x52>
				return i;
  8041fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804202:	e9 92 00 00 00       	jmpq   804299 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804207:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80420b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80420f:	48 89 d6             	mov    %rdx,%rsi
  804212:	48 89 c7             	mov    %rax,%rdi
  804215:	48 b8 7e 40 80 00 00 	movabs $0x80407e,%rax
  80421c:	00 00 00 
  80421f:	ff d0                	callq  *%rax
  804221:	85 c0                	test   %eax,%eax
  804223:	74 07                	je     80422c <devpipe_read+0x77>
				return 0;
  804225:	b8 00 00 00 00       	mov    $0x0,%eax
  80422a:	eb 6d                	jmp    804299 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80422c:	48 b8 c3 21 80 00 00 	movabs $0x8021c3,%rax
  804233:	00 00 00 
  804236:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  804238:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80423c:	8b 10                	mov    (%rax),%edx
  80423e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804242:	8b 40 04             	mov    0x4(%rax),%eax
  804245:	39 c2                	cmp    %eax,%edx
  804247:	74 ae                	je     8041f7 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804249:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80424d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804251:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804255:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804259:	8b 00                	mov    (%rax),%eax
  80425b:	99                   	cltd   
  80425c:	c1 ea 1b             	shr    $0x1b,%edx
  80425f:	01 d0                	add    %edx,%eax
  804261:	83 e0 1f             	and    $0x1f,%eax
  804264:	29 d0                	sub    %edx,%eax
  804266:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80426a:	48 98                	cltq   
  80426c:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804271:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804273:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804277:	8b 00                	mov    (%rax),%eax
  804279:	8d 50 01             	lea    0x1(%rax),%edx
  80427c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804280:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804282:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804287:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80428b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80428f:	0f 82 60 ff ff ff    	jb     8041f5 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804295:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804299:	c9                   	leaveq 
  80429a:	c3                   	retq   

000000000080429b <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80429b:	55                   	push   %rbp
  80429c:	48 89 e5             	mov    %rsp,%rbp
  80429f:	48 83 ec 40          	sub    $0x40,%rsp
  8042a3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8042a7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8042ab:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8042af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042b3:	48 89 c7             	mov    %rax,%rdi
  8042b6:	48 b8 9b 26 80 00 00 	movabs $0x80269b,%rax
  8042bd:	00 00 00 
  8042c0:	ff d0                	callq  *%rax
  8042c2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8042c6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8042ca:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8042ce:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8042d5:	00 
  8042d6:	e9 8e 00 00 00       	jmpq   804369 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8042db:	eb 31                	jmp    80430e <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8042dd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8042e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042e5:	48 89 d6             	mov    %rdx,%rsi
  8042e8:	48 89 c7             	mov    %rax,%rdi
  8042eb:	48 b8 7e 40 80 00 00 	movabs $0x80407e,%rax
  8042f2:	00 00 00 
  8042f5:	ff d0                	callq  *%rax
  8042f7:	85 c0                	test   %eax,%eax
  8042f9:	74 07                	je     804302 <devpipe_write+0x67>
				return 0;
  8042fb:	b8 00 00 00 00       	mov    $0x0,%eax
  804300:	eb 79                	jmp    80437b <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804302:	48 b8 c3 21 80 00 00 	movabs $0x8021c3,%rax
  804309:	00 00 00 
  80430c:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80430e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804312:	8b 40 04             	mov    0x4(%rax),%eax
  804315:	48 63 d0             	movslq %eax,%rdx
  804318:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80431c:	8b 00                	mov    (%rax),%eax
  80431e:	48 98                	cltq   
  804320:	48 83 c0 20          	add    $0x20,%rax
  804324:	48 39 c2             	cmp    %rax,%rdx
  804327:	73 b4                	jae    8042dd <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804329:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80432d:	8b 40 04             	mov    0x4(%rax),%eax
  804330:	99                   	cltd   
  804331:	c1 ea 1b             	shr    $0x1b,%edx
  804334:	01 d0                	add    %edx,%eax
  804336:	83 e0 1f             	and    $0x1f,%eax
  804339:	29 d0                	sub    %edx,%eax
  80433b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80433f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804343:	48 01 ca             	add    %rcx,%rdx
  804346:	0f b6 0a             	movzbl (%rdx),%ecx
  804349:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80434d:	48 98                	cltq   
  80434f:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804353:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804357:	8b 40 04             	mov    0x4(%rax),%eax
  80435a:	8d 50 01             	lea    0x1(%rax),%edx
  80435d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804361:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804364:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804369:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80436d:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804371:	0f 82 64 ff ff ff    	jb     8042db <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804377:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80437b:	c9                   	leaveq 
  80437c:	c3                   	retq   

000000000080437d <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80437d:	55                   	push   %rbp
  80437e:	48 89 e5             	mov    %rsp,%rbp
  804381:	48 83 ec 20          	sub    $0x20,%rsp
  804385:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804389:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80438d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804391:	48 89 c7             	mov    %rax,%rdi
  804394:	48 b8 9b 26 80 00 00 	movabs $0x80269b,%rax
  80439b:	00 00 00 
  80439e:	ff d0                	callq  *%rax
  8043a0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8043a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043a8:	48 be 89 51 80 00 00 	movabs $0x805189,%rsi
  8043af:	00 00 00 
  8043b2:	48 89 c7             	mov    %rax,%rdi
  8043b5:	48 b8 d2 18 80 00 00 	movabs $0x8018d2,%rax
  8043bc:	00 00 00 
  8043bf:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8043c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043c5:	8b 50 04             	mov    0x4(%rax),%edx
  8043c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043cc:	8b 00                	mov    (%rax),%eax
  8043ce:	29 c2                	sub    %eax,%edx
  8043d0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043d4:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8043da:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043de:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8043e5:	00 00 00 
	stat->st_dev = &devpipe;
  8043e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043ec:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  8043f3:	00 00 00 
  8043f6:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8043fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804402:	c9                   	leaveq 
  804403:	c3                   	retq   

0000000000804404 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804404:	55                   	push   %rbp
  804405:	48 89 e5             	mov    %rsp,%rbp
  804408:	48 83 ec 10          	sub    $0x10,%rsp
  80440c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  804410:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804414:	48 89 c6             	mov    %rax,%rsi
  804417:	bf 00 00 00 00       	mov    $0x0,%edi
  80441c:	48 b8 ac 22 80 00 00 	movabs $0x8022ac,%rax
  804423:	00 00 00 
  804426:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  804428:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80442c:	48 89 c7             	mov    %rax,%rdi
  80442f:	48 b8 9b 26 80 00 00 	movabs $0x80269b,%rax
  804436:	00 00 00 
  804439:	ff d0                	callq  *%rax
  80443b:	48 89 c6             	mov    %rax,%rsi
  80443e:	bf 00 00 00 00       	mov    $0x0,%edi
  804443:	48 b8 ac 22 80 00 00 	movabs $0x8022ac,%rax
  80444a:	00 00 00 
  80444d:	ff d0                	callq  *%rax
}
  80444f:	c9                   	leaveq 
  804450:	c3                   	retq   

0000000000804451 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804451:	55                   	push   %rbp
  804452:	48 89 e5             	mov    %rsp,%rbp
  804455:	48 83 ec 20          	sub    $0x20,%rsp
  804459:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80445c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80445f:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804462:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804466:	be 01 00 00 00       	mov    $0x1,%esi
  80446b:	48 89 c7             	mov    %rax,%rdi
  80446e:	48 b8 b9 20 80 00 00 	movabs $0x8020b9,%rax
  804475:	00 00 00 
  804478:	ff d0                	callq  *%rax
}
  80447a:	c9                   	leaveq 
  80447b:	c3                   	retq   

000000000080447c <getchar>:

int
getchar(void)
{
  80447c:	55                   	push   %rbp
  80447d:	48 89 e5             	mov    %rsp,%rbp
  804480:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804484:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804488:	ba 01 00 00 00       	mov    $0x1,%edx
  80448d:	48 89 c6             	mov    %rax,%rsi
  804490:	bf 00 00 00 00       	mov    $0x0,%edi
  804495:	48 b8 90 2b 80 00 00 	movabs $0x802b90,%rax
  80449c:	00 00 00 
  80449f:	ff d0                	callq  *%rax
  8044a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8044a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044a8:	79 05                	jns    8044af <getchar+0x33>
		return r;
  8044aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044ad:	eb 14                	jmp    8044c3 <getchar+0x47>
	if (r < 1)
  8044af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044b3:	7f 07                	jg     8044bc <getchar+0x40>
		return -E_EOF;
  8044b5:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8044ba:	eb 07                	jmp    8044c3 <getchar+0x47>
	return c;
  8044bc:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8044c0:	0f b6 c0             	movzbl %al,%eax
}
  8044c3:	c9                   	leaveq 
  8044c4:	c3                   	retq   

00000000008044c5 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8044c5:	55                   	push   %rbp
  8044c6:	48 89 e5             	mov    %rsp,%rbp
  8044c9:	48 83 ec 20          	sub    $0x20,%rsp
  8044cd:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8044d0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8044d4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8044d7:	48 89 d6             	mov    %rdx,%rsi
  8044da:	89 c7                	mov    %eax,%edi
  8044dc:	48 b8 5e 27 80 00 00 	movabs $0x80275e,%rax
  8044e3:	00 00 00 
  8044e6:	ff d0                	callq  *%rax
  8044e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8044eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044ef:	79 05                	jns    8044f6 <iscons+0x31>
		return r;
  8044f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044f4:	eb 1a                	jmp    804510 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8044f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044fa:	8b 10                	mov    (%rax),%edx
  8044fc:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  804503:	00 00 00 
  804506:	8b 00                	mov    (%rax),%eax
  804508:	39 c2                	cmp    %eax,%edx
  80450a:	0f 94 c0             	sete   %al
  80450d:	0f b6 c0             	movzbl %al,%eax
}
  804510:	c9                   	leaveq 
  804511:	c3                   	retq   

0000000000804512 <opencons>:

int
opencons(void)
{
  804512:	55                   	push   %rbp
  804513:	48 89 e5             	mov    %rsp,%rbp
  804516:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80451a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80451e:	48 89 c7             	mov    %rax,%rdi
  804521:	48 b8 c6 26 80 00 00 	movabs $0x8026c6,%rax
  804528:	00 00 00 
  80452b:	ff d0                	callq  *%rax
  80452d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804530:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804534:	79 05                	jns    80453b <opencons+0x29>
		return r;
  804536:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804539:	eb 5b                	jmp    804596 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80453b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80453f:	ba 07 04 00 00       	mov    $0x407,%edx
  804544:	48 89 c6             	mov    %rax,%rsi
  804547:	bf 00 00 00 00       	mov    $0x0,%edi
  80454c:	48 b8 01 22 80 00 00 	movabs $0x802201,%rax
  804553:	00 00 00 
  804556:	ff d0                	callq  *%rax
  804558:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80455b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80455f:	79 05                	jns    804566 <opencons+0x54>
		return r;
  804561:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804564:	eb 30                	jmp    804596 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804566:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80456a:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  804571:	00 00 00 
  804574:	8b 12                	mov    (%rdx),%edx
  804576:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804578:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80457c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804583:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804587:	48 89 c7             	mov    %rax,%rdi
  80458a:	48 b8 78 26 80 00 00 	movabs $0x802678,%rax
  804591:	00 00 00 
  804594:	ff d0                	callq  *%rax
}
  804596:	c9                   	leaveq 
  804597:	c3                   	retq   

0000000000804598 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804598:	55                   	push   %rbp
  804599:	48 89 e5             	mov    %rsp,%rbp
  80459c:	48 83 ec 30          	sub    $0x30,%rsp
  8045a0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8045a4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8045a8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8045ac:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8045b1:	75 07                	jne    8045ba <devcons_read+0x22>
		return 0;
  8045b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8045b8:	eb 4b                	jmp    804605 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8045ba:	eb 0c                	jmp    8045c8 <devcons_read+0x30>
		sys_yield();
  8045bc:	48 b8 c3 21 80 00 00 	movabs $0x8021c3,%rax
  8045c3:	00 00 00 
  8045c6:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8045c8:	48 b8 03 21 80 00 00 	movabs $0x802103,%rax
  8045cf:	00 00 00 
  8045d2:	ff d0                	callq  *%rax
  8045d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8045d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045db:	74 df                	je     8045bc <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8045dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045e1:	79 05                	jns    8045e8 <devcons_read+0x50>
		return c;
  8045e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045e6:	eb 1d                	jmp    804605 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8045e8:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8045ec:	75 07                	jne    8045f5 <devcons_read+0x5d>
		return 0;
  8045ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8045f3:	eb 10                	jmp    804605 <devcons_read+0x6d>
	*(char*)vbuf = c;
  8045f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045f8:	89 c2                	mov    %eax,%edx
  8045fa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8045fe:	88 10                	mov    %dl,(%rax)
	return 1;
  804600:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804605:	c9                   	leaveq 
  804606:	c3                   	retq   

0000000000804607 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804607:	55                   	push   %rbp
  804608:	48 89 e5             	mov    %rsp,%rbp
  80460b:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804612:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804619:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804620:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804627:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80462e:	eb 76                	jmp    8046a6 <devcons_write+0x9f>
		m = n - tot;
  804630:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804637:	89 c2                	mov    %eax,%edx
  804639:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80463c:	29 c2                	sub    %eax,%edx
  80463e:	89 d0                	mov    %edx,%eax
  804640:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804643:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804646:	83 f8 7f             	cmp    $0x7f,%eax
  804649:	76 07                	jbe    804652 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80464b:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804652:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804655:	48 63 d0             	movslq %eax,%rdx
  804658:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80465b:	48 63 c8             	movslq %eax,%rcx
  80465e:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804665:	48 01 c1             	add    %rax,%rcx
  804668:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80466f:	48 89 ce             	mov    %rcx,%rsi
  804672:	48 89 c7             	mov    %rax,%rdi
  804675:	48 b8 f6 1b 80 00 00 	movabs $0x801bf6,%rax
  80467c:	00 00 00 
  80467f:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804681:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804684:	48 63 d0             	movslq %eax,%rdx
  804687:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80468e:	48 89 d6             	mov    %rdx,%rsi
  804691:	48 89 c7             	mov    %rax,%rdi
  804694:	48 b8 b9 20 80 00 00 	movabs $0x8020b9,%rax
  80469b:	00 00 00 
  80469e:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8046a0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8046a3:	01 45 fc             	add    %eax,-0x4(%rbp)
  8046a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046a9:	48 98                	cltq   
  8046ab:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8046b2:	0f 82 78 ff ff ff    	jb     804630 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8046b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8046bb:	c9                   	leaveq 
  8046bc:	c3                   	retq   

00000000008046bd <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8046bd:	55                   	push   %rbp
  8046be:	48 89 e5             	mov    %rsp,%rbp
  8046c1:	48 83 ec 08          	sub    $0x8,%rsp
  8046c5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8046c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8046ce:	c9                   	leaveq 
  8046cf:	c3                   	retq   

00000000008046d0 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8046d0:	55                   	push   %rbp
  8046d1:	48 89 e5             	mov    %rsp,%rbp
  8046d4:	48 83 ec 10          	sub    $0x10,%rsp
  8046d8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8046dc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8046e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046e4:	48 be 95 51 80 00 00 	movabs $0x805195,%rsi
  8046eb:	00 00 00 
  8046ee:	48 89 c7             	mov    %rax,%rdi
  8046f1:	48 b8 d2 18 80 00 00 	movabs $0x8018d2,%rax
  8046f8:	00 00 00 
  8046fb:	ff d0                	callq  *%rax
	return 0;
  8046fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804702:	c9                   	leaveq 
  804703:	c3                   	retq   

0000000000804704 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804704:	55                   	push   %rbp
  804705:	48 89 e5             	mov    %rsp,%rbp
  804708:	48 83 ec 30          	sub    $0x30,%rsp
  80470c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804710:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804714:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  804718:	48 b8 d8 81 80 00 00 	movabs $0x8081d8,%rax
  80471f:	00 00 00 
  804722:	48 8b 00             	mov    (%rax),%rax
  804725:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  80472b:	85 c0                	test   %eax,%eax
  80472d:	75 3c                	jne    80476b <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  80472f:	48 b8 85 21 80 00 00 	movabs $0x802185,%rax
  804736:	00 00 00 
  804739:	ff d0                	callq  *%rax
  80473b:	25 ff 03 00 00       	and    $0x3ff,%eax
  804740:	48 63 d0             	movslq %eax,%rdx
  804743:	48 89 d0             	mov    %rdx,%rax
  804746:	48 c1 e0 03          	shl    $0x3,%rax
  80474a:	48 01 d0             	add    %rdx,%rax
  80474d:	48 c1 e0 05          	shl    $0x5,%rax
  804751:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804758:	00 00 00 
  80475b:	48 01 c2             	add    %rax,%rdx
  80475e:	48 b8 d8 81 80 00 00 	movabs $0x8081d8,%rax
  804765:	00 00 00 
  804768:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  80476b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804770:	75 0e                	jne    804780 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  804772:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804779:	00 00 00 
  80477c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  804780:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804784:	48 89 c7             	mov    %rax,%rdi
  804787:	48 b8 2a 24 80 00 00 	movabs $0x80242a,%rax
  80478e:	00 00 00 
  804791:	ff d0                	callq  *%rax
  804793:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  804796:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80479a:	79 19                	jns    8047b5 <ipc_recv+0xb1>
		*from_env_store = 0;
  80479c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8047a0:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  8047a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8047aa:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  8047b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047b3:	eb 53                	jmp    804808 <ipc_recv+0x104>
	}
	if(from_env_store)
  8047b5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8047ba:	74 19                	je     8047d5 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  8047bc:	48 b8 d8 81 80 00 00 	movabs $0x8081d8,%rax
  8047c3:	00 00 00 
  8047c6:	48 8b 00             	mov    (%rax),%rax
  8047c9:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8047cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8047d3:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  8047d5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8047da:	74 19                	je     8047f5 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  8047dc:	48 b8 d8 81 80 00 00 	movabs $0x8081d8,%rax
  8047e3:	00 00 00 
  8047e6:	48 8b 00             	mov    (%rax),%rax
  8047e9:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8047ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8047f3:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  8047f5:	48 b8 d8 81 80 00 00 	movabs $0x8081d8,%rax
  8047fc:	00 00 00 
  8047ff:	48 8b 00             	mov    (%rax),%rax
  804802:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  804808:	c9                   	leaveq 
  804809:	c3                   	retq   

000000000080480a <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80480a:	55                   	push   %rbp
  80480b:	48 89 e5             	mov    %rsp,%rbp
  80480e:	48 83 ec 30          	sub    $0x30,%rsp
  804812:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804815:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804818:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80481c:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  80481f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804824:	75 0e                	jne    804834 <ipc_send+0x2a>
		pg = (void*)UTOP;
  804826:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80482d:	00 00 00 
  804830:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  804834:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804837:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80483a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80483e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804841:	89 c7                	mov    %eax,%edi
  804843:	48 b8 d5 23 80 00 00 	movabs $0x8023d5,%rax
  80484a:	00 00 00 
  80484d:	ff d0                	callq  *%rax
  80484f:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  804852:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804856:	75 0c                	jne    804864 <ipc_send+0x5a>
			sys_yield();
  804858:	48 b8 c3 21 80 00 00 	movabs $0x8021c3,%rax
  80485f:	00 00 00 
  804862:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  804864:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804868:	74 ca                	je     804834 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  80486a:	c9                   	leaveq 
  80486b:	c3                   	retq   

000000000080486c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80486c:	55                   	push   %rbp
  80486d:	48 89 e5             	mov    %rsp,%rbp
  804870:	48 83 ec 14          	sub    $0x14,%rsp
  804874:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804877:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80487e:	eb 5e                	jmp    8048de <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  804880:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804887:	00 00 00 
  80488a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80488d:	48 63 d0             	movslq %eax,%rdx
  804890:	48 89 d0             	mov    %rdx,%rax
  804893:	48 c1 e0 03          	shl    $0x3,%rax
  804897:	48 01 d0             	add    %rdx,%rax
  80489a:	48 c1 e0 05          	shl    $0x5,%rax
  80489e:	48 01 c8             	add    %rcx,%rax
  8048a1:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8048a7:	8b 00                	mov    (%rax),%eax
  8048a9:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8048ac:	75 2c                	jne    8048da <ipc_find_env+0x6e>
			return envs[i].env_id;
  8048ae:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8048b5:	00 00 00 
  8048b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048bb:	48 63 d0             	movslq %eax,%rdx
  8048be:	48 89 d0             	mov    %rdx,%rax
  8048c1:	48 c1 e0 03          	shl    $0x3,%rax
  8048c5:	48 01 d0             	add    %rdx,%rax
  8048c8:	48 c1 e0 05          	shl    $0x5,%rax
  8048cc:	48 01 c8             	add    %rcx,%rax
  8048cf:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8048d5:	8b 40 08             	mov    0x8(%rax),%eax
  8048d8:	eb 12                	jmp    8048ec <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8048da:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8048de:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8048e5:	7e 99                	jle    804880 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8048e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8048ec:	c9                   	leaveq 
  8048ed:	c3                   	retq   

00000000008048ee <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8048ee:	55                   	push   %rbp
  8048ef:	48 89 e5             	mov    %rsp,%rbp
  8048f2:	48 83 ec 18          	sub    $0x18,%rsp
  8048f6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8048fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8048fe:	48 c1 e8 15          	shr    $0x15,%rax
  804902:	48 89 c2             	mov    %rax,%rdx
  804905:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80490c:	01 00 00 
  80490f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804913:	83 e0 01             	and    $0x1,%eax
  804916:	48 85 c0             	test   %rax,%rax
  804919:	75 07                	jne    804922 <pageref+0x34>
		return 0;
  80491b:	b8 00 00 00 00       	mov    $0x0,%eax
  804920:	eb 53                	jmp    804975 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804922:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804926:	48 c1 e8 0c          	shr    $0xc,%rax
  80492a:	48 89 c2             	mov    %rax,%rdx
  80492d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804934:	01 00 00 
  804937:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80493b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80493f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804943:	83 e0 01             	and    $0x1,%eax
  804946:	48 85 c0             	test   %rax,%rax
  804949:	75 07                	jne    804952 <pageref+0x64>
		return 0;
  80494b:	b8 00 00 00 00       	mov    $0x0,%eax
  804950:	eb 23                	jmp    804975 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804952:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804956:	48 c1 e8 0c          	shr    $0xc,%rax
  80495a:	48 89 c2             	mov    %rax,%rdx
  80495d:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804964:	00 00 00 
  804967:	48 c1 e2 04          	shl    $0x4,%rdx
  80496b:	48 01 d0             	add    %rdx,%rax
  80496e:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804972:	0f b7 c0             	movzwl %ax,%eax
}
  804975:	c9                   	leaveq 
  804976:	c3                   	retq   
