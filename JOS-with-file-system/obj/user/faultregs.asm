
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
  800074:	48 be e0 3e 80 00 00 	movabs $0x803ee0,%rsi
  80007b:	00 00 00 
  80007e:	48 bf e1 3e 80 00 00 	movabs $0x803ee1,%rdi
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
  8000b0:	48 be f1 3e 80 00 00 	movabs $0x803ef1,%rsi
  8000b7:	00 00 00 
  8000ba:	48 bf f5 3e 80 00 00 	movabs $0x803ef5,%rdi
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
  8000eb:	48 bf 05 3f 80 00 00 	movabs $0x803f05,%rdi
  8000f2:	00 00 00 
  8000f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000fa:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  800101:	00 00 00 
  800104:	ff d2                	callq  *%rdx
  800106:	eb 22                	jmp    80012a <check_regs+0xe7>
  800108:	48 bf 09 3f 80 00 00 	movabs $0x803f09,%rdi
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
  800140:	48 be 13 3f 80 00 00 	movabs $0x803f13,%rsi
  800147:	00 00 00 
  80014a:	48 bf f5 3e 80 00 00 	movabs $0x803ef5,%rdi
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
  80017b:	48 bf 05 3f 80 00 00 	movabs $0x803f05,%rdi
  800182:	00 00 00 
  800185:	b8 00 00 00 00       	mov    $0x0,%eax
  80018a:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  800191:	00 00 00 
  800194:	ff d2                	callq  *%rdx
  800196:	eb 22                	jmp    8001ba <check_regs+0x177>
  800198:	48 bf 09 3f 80 00 00 	movabs $0x803f09,%rdi
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
  8001d0:	48 be 17 3f 80 00 00 	movabs $0x803f17,%rsi
  8001d7:	00 00 00 
  8001da:	48 bf f5 3e 80 00 00 	movabs $0x803ef5,%rdi
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
  80020b:	48 bf 05 3f 80 00 00 	movabs $0x803f05,%rdi
  800212:	00 00 00 
  800215:	b8 00 00 00 00       	mov    $0x0,%eax
  80021a:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  800221:	00 00 00 
  800224:	ff d2                	callq  *%rdx
  800226:	eb 22                	jmp    80024a <check_regs+0x207>
  800228:	48 bf 09 3f 80 00 00 	movabs $0x803f09,%rdi
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
  800260:	48 be 1b 3f 80 00 00 	movabs $0x803f1b,%rsi
  800267:	00 00 00 
  80026a:	48 bf f5 3e 80 00 00 	movabs $0x803ef5,%rdi
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
  80029b:	48 bf 05 3f 80 00 00 	movabs $0x803f05,%rdi
  8002a2:	00 00 00 
  8002a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8002aa:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  8002b1:	00 00 00 
  8002b4:	ff d2                	callq  *%rdx
  8002b6:	eb 22                	jmp    8002da <check_regs+0x297>
  8002b8:	48 bf 09 3f 80 00 00 	movabs $0x803f09,%rdi
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
  8002f0:	48 be 1f 3f 80 00 00 	movabs $0x803f1f,%rsi
  8002f7:	00 00 00 
  8002fa:	48 bf f5 3e 80 00 00 	movabs $0x803ef5,%rdi
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
  80032b:	48 bf 05 3f 80 00 00 	movabs $0x803f05,%rdi
  800332:	00 00 00 
  800335:	b8 00 00 00 00       	mov    $0x0,%eax
  80033a:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  800341:	00 00 00 
  800344:	ff d2                	callq  *%rdx
  800346:	eb 22                	jmp    80036a <check_regs+0x327>
  800348:	48 bf 09 3f 80 00 00 	movabs $0x803f09,%rdi
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
  800380:	48 be 23 3f 80 00 00 	movabs $0x803f23,%rsi
  800387:	00 00 00 
  80038a:	48 bf f5 3e 80 00 00 	movabs $0x803ef5,%rdi
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
  8003bb:	48 bf 05 3f 80 00 00 	movabs $0x803f05,%rdi
  8003c2:	00 00 00 
  8003c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ca:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  8003d1:	00 00 00 
  8003d4:	ff d2                	callq  *%rdx
  8003d6:	eb 22                	jmp    8003fa <check_regs+0x3b7>
  8003d8:	48 bf 09 3f 80 00 00 	movabs $0x803f09,%rdi
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
  800410:	48 be 27 3f 80 00 00 	movabs $0x803f27,%rsi
  800417:	00 00 00 
  80041a:	48 bf f5 3e 80 00 00 	movabs $0x803ef5,%rdi
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
  80044b:	48 bf 05 3f 80 00 00 	movabs $0x803f05,%rdi
  800452:	00 00 00 
  800455:	b8 00 00 00 00       	mov    $0x0,%eax
  80045a:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  800461:	00 00 00 
  800464:	ff d2                	callq  *%rdx
  800466:	eb 22                	jmp    80048a <check_regs+0x447>
  800468:	48 bf 09 3f 80 00 00 	movabs $0x803f09,%rdi
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
  8004a0:	48 be 2b 3f 80 00 00 	movabs $0x803f2b,%rsi
  8004a7:	00 00 00 
  8004aa:	48 bf f5 3e 80 00 00 	movabs $0x803ef5,%rdi
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
  8004db:	48 bf 05 3f 80 00 00 	movabs $0x803f05,%rdi
  8004e2:	00 00 00 
  8004e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ea:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  8004f1:	00 00 00 
  8004f4:	ff d2                	callq  *%rdx
  8004f6:	eb 22                	jmp    80051a <check_regs+0x4d7>
  8004f8:	48 bf 09 3f 80 00 00 	movabs $0x803f09,%rdi
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
  800536:	48 be 2f 3f 80 00 00 	movabs $0x803f2f,%rsi
  80053d:	00 00 00 
  800540:	48 bf f5 3e 80 00 00 	movabs $0x803ef5,%rdi
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
  800577:	48 bf 05 3f 80 00 00 	movabs $0x803f05,%rdi
  80057e:	00 00 00 
  800581:	b8 00 00 00 00       	mov    $0x0,%eax
  800586:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  80058d:	00 00 00 
  800590:	ff d2                	callq  *%rdx
  800592:	eb 22                	jmp    8005b6 <check_regs+0x573>
  800594:	48 bf 09 3f 80 00 00 	movabs $0x803f09,%rdi
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
  8005d2:	48 be 36 3f 80 00 00 	movabs $0x803f36,%rsi
  8005d9:	00 00 00 
  8005dc:	48 bf f5 3e 80 00 00 	movabs $0x803ef5,%rdi
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
  800613:	48 bf 05 3f 80 00 00 	movabs $0x803f05,%rdi
  80061a:	00 00 00 
  80061d:	b8 00 00 00 00       	mov    $0x0,%eax
  800622:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  800629:	00 00 00 
  80062c:	ff d2                	callq  *%rdx
  80062e:	eb 22                	jmp    800652 <check_regs+0x60f>
  800630:	48 bf 09 3f 80 00 00 	movabs $0x803f09,%rdi
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
  80065f:	48 bf 3a 3f 80 00 00 	movabs $0x803f3a,%rdi
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
  800683:	48 bf 4b 3f 80 00 00 	movabs $0x803f4b,%rdi
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
  8006d3:	48 ba 68 3f 80 00 00 	movabs $0x803f68,%rdx
  8006da:	00 00 00 
  8006dd:	be 5f 00 00 00       	mov    $0x5f,%esi
  8006e2:	48 bf 99 3f 80 00 00 	movabs $0x803f99,%rdi
  8006e9:	00 00 00 
  8006ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f1:	49 b9 e4 0a 80 00 00 	movabs $0x800ae4,%r9
  8006f8:	00 00 00 
  8006fb:	41 ff d1             	callq  *%r9
		      utf->utf_fault_va, utf->utf_rip);

	// Check registers in UTrapframe
	during.regs = utf->utf_regs;
  8006fe:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
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
  800791:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  800798:	00 00 00 
  80079b:	48 89 50 78          	mov    %rdx,0x78(%rax)
	during.eflags = utf->utf_eflags & 0xfff;
  80079f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a3:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
  8007aa:	25 ff 0f 00 00       	and    $0xfff,%eax
  8007af:	48 89 c2             	mov    %rax,%rdx
  8007b2:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  8007b9:	00 00 00 
  8007bc:	48 89 90 80 00 00 00 	mov    %rdx,0x80(%rax)
	during.esp = utf->utf_rsp;
  8007c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c7:	48 8b 90 98 00 00 00 	mov    0x98(%rax),%rdx
  8007ce:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  8007d5:	00 00 00 
  8007d8:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	check_regs(&before, "before", &during, "during", "in UTrapframe");
  8007df:	49 b8 aa 3f 80 00 00 	movabs $0x803faa,%r8
  8007e6:	00 00 00 
  8007e9:	48 b9 b8 3f 80 00 00 	movabs $0x803fb8,%rcx
  8007f0:	00 00 00 
  8007f3:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  8007fa:	00 00 00 
  8007fd:	48 be bf 3f 80 00 00 	movabs $0x803fbf,%rsi
  800804:	00 00 00 
  800807:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
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
  800846:	48 ba c6 3f 80 00 00 	movabs $0x803fc6,%rdx
  80084d:	00 00 00 
  800850:	be 6a 00 00 00       	mov    $0x6a,%esi
  800855:	48 bf 99 3f 80 00 00 	movabs $0x803f99,%rdi
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
  80088c:	48 b8 6e 24 80 00 00 	movabs $0x80246e,%rax
  800893:	00 00 00 
  800896:	ff d0                	callq  *%rax

	__asm __volatile(
  800898:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80089f:	00 00 00 
  8008a2:	48 ba 40 71 80 00 00 	movabs $0x807140,%rdx
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
  8009bf:	48 bf e0 3f 80 00 00 	movabs $0x803fe0,%rdi
  8009c6:	00 00 00 
  8009c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ce:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  8009d5:	00 00 00 
  8009d8:	ff d2                	callq  *%rdx
	after.eip = before.eip;
  8009da:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8009e1:	00 00 00 
  8009e4:	48 8b 50 78          	mov    0x78(%rax),%rdx
  8009e8:	48 b8 40 71 80 00 00 	movabs $0x807140,%rax
  8009ef:	00 00 00 
  8009f2:	48 89 50 78          	mov    %rdx,0x78(%rax)

	check_regs(&before, "before", &after, "after", "after page-fault");
  8009f6:	49 b8 ff 3f 80 00 00 	movabs $0x803fff,%r8
  8009fd:	00 00 00 
  800a00:	48 b9 10 40 80 00 00 	movabs $0x804010,%rcx
  800a07:	00 00 00 
  800a0a:	48 ba 40 71 80 00 00 	movabs $0x807140,%rdx
  800a11:	00 00 00 
  800a14:	48 be bf 3f 80 00 00 	movabs $0x803fbf,%rsi
  800a1b:	00 00 00 
  800a1e:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
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
  800a74:	48 b8 d8 71 80 00 00 	movabs $0x8071d8,%rax
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
  800a8e:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
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
  800ac5:	48 b8 ef 28 80 00 00 	movabs $0x8028ef,%rax
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
  800b6d:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
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
  800b9e:	48 bf 20 40 80 00 00 	movabs $0x804020,%rdi
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
  800bda:	48 bf 43 40 80 00 00 	movabs $0x804043,%rdi
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
  800e89:	48 ba 28 42 80 00 00 	movabs $0x804228,%rdx
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
  801181:	48 b8 50 42 80 00 00 	movabs $0x804250,%rax
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
  8012cf:	83 fb 10             	cmp    $0x10,%ebx
  8012d2:	7f 16                	jg     8012ea <vprintfmt+0x21a>
  8012d4:	48 b8 a0 41 80 00 00 	movabs $0x8041a0,%rax
  8012db:	00 00 00 
  8012de:	48 63 d3             	movslq %ebx,%rdx
  8012e1:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8012e5:	4d 85 e4             	test   %r12,%r12
  8012e8:	75 2e                	jne    801318 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8012ea:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8012ee:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8012f2:	89 d9                	mov    %ebx,%ecx
  8012f4:	48 ba 39 42 80 00 00 	movabs $0x804239,%rdx
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
  801323:	48 ba 42 42 80 00 00 	movabs $0x804242,%rdx
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
  80137d:	49 bc 45 42 80 00 00 	movabs $0x804245,%r12
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
  802083:	48 ba 00 45 80 00 00 	movabs $0x804500,%rdx
  80208a:	00 00 00 
  80208d:	be 23 00 00 00       	mov    $0x23,%esi
  802092:	48 bf 1d 45 80 00 00 	movabs $0x80451d,%rdi
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

000000000080246e <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80246e:	55                   	push   %rbp
  80246f:	48 89 e5             	mov    %rsp,%rbp
  802472:	48 83 ec 10          	sub    $0x10,%rsp
  802476:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  80247a:	48 b8 e0 71 80 00 00 	movabs $0x8071e0,%rax
  802481:	00 00 00 
  802484:	48 8b 00             	mov    (%rax),%rax
  802487:	48 85 c0             	test   %rax,%rax
  80248a:	0f 85 84 00 00 00    	jne    802514 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  802490:	48 b8 d8 71 80 00 00 	movabs $0x8071d8,%rax
  802497:	00 00 00 
  80249a:	48 8b 00             	mov    (%rax),%rax
  80249d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024a3:	ba 07 00 00 00       	mov    $0x7,%edx
  8024a8:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8024ad:	89 c7                	mov    %eax,%edi
  8024af:	48 b8 01 22 80 00 00 	movabs $0x802201,%rax
  8024b6:	00 00 00 
  8024b9:	ff d0                	callq  *%rax
  8024bb:	85 c0                	test   %eax,%eax
  8024bd:	79 2a                	jns    8024e9 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  8024bf:	48 ba 30 45 80 00 00 	movabs $0x804530,%rdx
  8024c6:	00 00 00 
  8024c9:	be 23 00 00 00       	mov    $0x23,%esi
  8024ce:	48 bf 57 45 80 00 00 	movabs $0x804557,%rdi
  8024d5:	00 00 00 
  8024d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8024dd:	48 b9 e4 0a 80 00 00 	movabs $0x800ae4,%rcx
  8024e4:	00 00 00 
  8024e7:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  8024e9:	48 b8 d8 71 80 00 00 	movabs $0x8071d8,%rax
  8024f0:	00 00 00 
  8024f3:	48 8b 00             	mov    (%rax),%rax
  8024f6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024fc:	48 be 27 25 80 00 00 	movabs $0x802527,%rsi
  802503:	00 00 00 
  802506:	89 c7                	mov    %eax,%edi
  802508:	48 b8 8b 23 80 00 00 	movabs $0x80238b,%rax
  80250f:	00 00 00 
  802512:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  802514:	48 b8 e0 71 80 00 00 	movabs $0x8071e0,%rax
  80251b:	00 00 00 
  80251e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802522:	48 89 10             	mov    %rdx,(%rax)
}
  802525:	c9                   	leaveq 
  802526:	c3                   	retq   

0000000000802527 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  802527:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  80252a:	48 a1 e0 71 80 00 00 	movabs 0x8071e0,%rax
  802531:	00 00 00 
	call *%rax
  802534:	ff d0                	callq  *%rax


	/*This code is to be removed*/

	// LAB 4: Your code here.
	movq 136(%rsp), %rbx  //Load RIP 
  802536:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  80253d:	00 
	movq 152(%rsp), %rcx  //Load RSP
  80253e:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  802545:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  802546:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  80254a:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  80254d:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  802554:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  802555:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  802559:	4c 8b 3c 24          	mov    (%rsp),%r15
  80255d:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  802562:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  802567:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  80256c:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  802571:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  802576:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  80257b:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  802580:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  802585:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  80258a:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  80258f:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  802594:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  802599:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  80259e:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8025a3:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  8025a7:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  8025ab:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  8025ac:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8025ad:	c3                   	retq   

00000000008025ae <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8025ae:	55                   	push   %rbp
  8025af:	48 89 e5             	mov    %rsp,%rbp
  8025b2:	48 83 ec 08          	sub    $0x8,%rsp
  8025b6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8025ba:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8025be:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8025c5:	ff ff ff 
  8025c8:	48 01 d0             	add    %rdx,%rax
  8025cb:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8025cf:	c9                   	leaveq 
  8025d0:	c3                   	retq   

00000000008025d1 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8025d1:	55                   	push   %rbp
  8025d2:	48 89 e5             	mov    %rsp,%rbp
  8025d5:	48 83 ec 08          	sub    $0x8,%rsp
  8025d9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8025dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025e1:	48 89 c7             	mov    %rax,%rdi
  8025e4:	48 b8 ae 25 80 00 00 	movabs $0x8025ae,%rax
  8025eb:	00 00 00 
  8025ee:	ff d0                	callq  *%rax
  8025f0:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8025f6:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8025fa:	c9                   	leaveq 
  8025fb:	c3                   	retq   

00000000008025fc <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8025fc:	55                   	push   %rbp
  8025fd:	48 89 e5             	mov    %rsp,%rbp
  802600:	48 83 ec 18          	sub    $0x18,%rsp
  802604:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802608:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80260f:	eb 6b                	jmp    80267c <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802611:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802614:	48 98                	cltq   
  802616:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80261c:	48 c1 e0 0c          	shl    $0xc,%rax
  802620:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802624:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802628:	48 c1 e8 15          	shr    $0x15,%rax
  80262c:	48 89 c2             	mov    %rax,%rdx
  80262f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802636:	01 00 00 
  802639:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80263d:	83 e0 01             	and    $0x1,%eax
  802640:	48 85 c0             	test   %rax,%rax
  802643:	74 21                	je     802666 <fd_alloc+0x6a>
  802645:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802649:	48 c1 e8 0c          	shr    $0xc,%rax
  80264d:	48 89 c2             	mov    %rax,%rdx
  802650:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802657:	01 00 00 
  80265a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80265e:	83 e0 01             	and    $0x1,%eax
  802661:	48 85 c0             	test   %rax,%rax
  802664:	75 12                	jne    802678 <fd_alloc+0x7c>
			*fd_store = fd;
  802666:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80266a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80266e:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802671:	b8 00 00 00 00       	mov    $0x0,%eax
  802676:	eb 1a                	jmp    802692 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802678:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80267c:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802680:	7e 8f                	jle    802611 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802682:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802686:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80268d:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802692:	c9                   	leaveq 
  802693:	c3                   	retq   

0000000000802694 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802694:	55                   	push   %rbp
  802695:	48 89 e5             	mov    %rsp,%rbp
  802698:	48 83 ec 20          	sub    $0x20,%rsp
  80269c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80269f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8026a3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8026a7:	78 06                	js     8026af <fd_lookup+0x1b>
  8026a9:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8026ad:	7e 07                	jle    8026b6 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8026af:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026b4:	eb 6c                	jmp    802722 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8026b6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026b9:	48 98                	cltq   
  8026bb:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8026c1:	48 c1 e0 0c          	shl    $0xc,%rax
  8026c5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8026c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026cd:	48 c1 e8 15          	shr    $0x15,%rax
  8026d1:	48 89 c2             	mov    %rax,%rdx
  8026d4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8026db:	01 00 00 
  8026de:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026e2:	83 e0 01             	and    $0x1,%eax
  8026e5:	48 85 c0             	test   %rax,%rax
  8026e8:	74 21                	je     80270b <fd_lookup+0x77>
  8026ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026ee:	48 c1 e8 0c          	shr    $0xc,%rax
  8026f2:	48 89 c2             	mov    %rax,%rdx
  8026f5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8026fc:	01 00 00 
  8026ff:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802703:	83 e0 01             	and    $0x1,%eax
  802706:	48 85 c0             	test   %rax,%rax
  802709:	75 07                	jne    802712 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80270b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802710:	eb 10                	jmp    802722 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802712:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802716:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80271a:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80271d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802722:	c9                   	leaveq 
  802723:	c3                   	retq   

0000000000802724 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802724:	55                   	push   %rbp
  802725:	48 89 e5             	mov    %rsp,%rbp
  802728:	48 83 ec 30          	sub    $0x30,%rsp
  80272c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802730:	89 f0                	mov    %esi,%eax
  802732:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802735:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802739:	48 89 c7             	mov    %rax,%rdi
  80273c:	48 b8 ae 25 80 00 00 	movabs $0x8025ae,%rax
  802743:	00 00 00 
  802746:	ff d0                	callq  *%rax
  802748:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80274c:	48 89 d6             	mov    %rdx,%rsi
  80274f:	89 c7                	mov    %eax,%edi
  802751:	48 b8 94 26 80 00 00 	movabs $0x802694,%rax
  802758:	00 00 00 
  80275b:	ff d0                	callq  *%rax
  80275d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802760:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802764:	78 0a                	js     802770 <fd_close+0x4c>
	    || fd != fd2)
  802766:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80276a:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80276e:	74 12                	je     802782 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802770:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802774:	74 05                	je     80277b <fd_close+0x57>
  802776:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802779:	eb 05                	jmp    802780 <fd_close+0x5c>
  80277b:	b8 00 00 00 00       	mov    $0x0,%eax
  802780:	eb 69                	jmp    8027eb <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802782:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802786:	8b 00                	mov    (%rax),%eax
  802788:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80278c:	48 89 d6             	mov    %rdx,%rsi
  80278f:	89 c7                	mov    %eax,%edi
  802791:	48 b8 ed 27 80 00 00 	movabs $0x8027ed,%rax
  802798:	00 00 00 
  80279b:	ff d0                	callq  *%rax
  80279d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027a4:	78 2a                	js     8027d0 <fd_close+0xac>
		if (dev->dev_close)
  8027a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027aa:	48 8b 40 20          	mov    0x20(%rax),%rax
  8027ae:	48 85 c0             	test   %rax,%rax
  8027b1:	74 16                	je     8027c9 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8027b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027b7:	48 8b 40 20          	mov    0x20(%rax),%rax
  8027bb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027bf:	48 89 d7             	mov    %rdx,%rdi
  8027c2:	ff d0                	callq  *%rax
  8027c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027c7:	eb 07                	jmp    8027d0 <fd_close+0xac>
		else
			r = 0;
  8027c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8027d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027d4:	48 89 c6             	mov    %rax,%rsi
  8027d7:	bf 00 00 00 00       	mov    $0x0,%edi
  8027dc:	48 b8 ac 22 80 00 00 	movabs $0x8022ac,%rax
  8027e3:	00 00 00 
  8027e6:	ff d0                	callq  *%rax
	return r;
  8027e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8027eb:	c9                   	leaveq 
  8027ec:	c3                   	retq   

00000000008027ed <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8027ed:	55                   	push   %rbp
  8027ee:	48 89 e5             	mov    %rsp,%rbp
  8027f1:	48 83 ec 20          	sub    $0x20,%rsp
  8027f5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8027f8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8027fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802803:	eb 41                	jmp    802846 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802805:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80280c:	00 00 00 
  80280f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802812:	48 63 d2             	movslq %edx,%rdx
  802815:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802819:	8b 00                	mov    (%rax),%eax
  80281b:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80281e:	75 22                	jne    802842 <dev_lookup+0x55>
			*dev = devtab[i];
  802820:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802827:	00 00 00 
  80282a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80282d:	48 63 d2             	movslq %edx,%rdx
  802830:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802834:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802838:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80283b:	b8 00 00 00 00       	mov    $0x0,%eax
  802840:	eb 60                	jmp    8028a2 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802842:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802846:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80284d:	00 00 00 
  802850:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802853:	48 63 d2             	movslq %edx,%rdx
  802856:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80285a:	48 85 c0             	test   %rax,%rax
  80285d:	75 a6                	jne    802805 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80285f:	48 b8 d8 71 80 00 00 	movabs $0x8071d8,%rax
  802866:	00 00 00 
  802869:	48 8b 00             	mov    (%rax),%rax
  80286c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802872:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802875:	89 c6                	mov    %eax,%esi
  802877:	48 bf 68 45 80 00 00 	movabs $0x804568,%rdi
  80287e:	00 00 00 
  802881:	b8 00 00 00 00       	mov    $0x0,%eax
  802886:	48 b9 1d 0d 80 00 00 	movabs $0x800d1d,%rcx
  80288d:	00 00 00 
  802890:	ff d1                	callq  *%rcx
	*dev = 0;
  802892:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802896:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80289d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8028a2:	c9                   	leaveq 
  8028a3:	c3                   	retq   

00000000008028a4 <close>:

int
close(int fdnum)
{
  8028a4:	55                   	push   %rbp
  8028a5:	48 89 e5             	mov    %rsp,%rbp
  8028a8:	48 83 ec 20          	sub    $0x20,%rsp
  8028ac:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028af:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028b3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028b6:	48 89 d6             	mov    %rdx,%rsi
  8028b9:	89 c7                	mov    %eax,%edi
  8028bb:	48 b8 94 26 80 00 00 	movabs $0x802694,%rax
  8028c2:	00 00 00 
  8028c5:	ff d0                	callq  *%rax
  8028c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028ce:	79 05                	jns    8028d5 <close+0x31>
		return r;
  8028d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028d3:	eb 18                	jmp    8028ed <close+0x49>
	else
		return fd_close(fd, 1);
  8028d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028d9:	be 01 00 00 00       	mov    $0x1,%esi
  8028de:	48 89 c7             	mov    %rax,%rdi
  8028e1:	48 b8 24 27 80 00 00 	movabs $0x802724,%rax
  8028e8:	00 00 00 
  8028eb:	ff d0                	callq  *%rax
}
  8028ed:	c9                   	leaveq 
  8028ee:	c3                   	retq   

00000000008028ef <close_all>:

void
close_all(void)
{
  8028ef:	55                   	push   %rbp
  8028f0:	48 89 e5             	mov    %rsp,%rbp
  8028f3:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8028f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8028fe:	eb 15                	jmp    802915 <close_all+0x26>
		close(i);
  802900:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802903:	89 c7                	mov    %eax,%edi
  802905:	48 b8 a4 28 80 00 00 	movabs $0x8028a4,%rax
  80290c:	00 00 00 
  80290f:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802911:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802915:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802919:	7e e5                	jle    802900 <close_all+0x11>
		close(i);
}
  80291b:	c9                   	leaveq 
  80291c:	c3                   	retq   

000000000080291d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80291d:	55                   	push   %rbp
  80291e:	48 89 e5             	mov    %rsp,%rbp
  802921:	48 83 ec 40          	sub    $0x40,%rsp
  802925:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802928:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80292b:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80292f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802932:	48 89 d6             	mov    %rdx,%rsi
  802935:	89 c7                	mov    %eax,%edi
  802937:	48 b8 94 26 80 00 00 	movabs $0x802694,%rax
  80293e:	00 00 00 
  802941:	ff d0                	callq  *%rax
  802943:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802946:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80294a:	79 08                	jns    802954 <dup+0x37>
		return r;
  80294c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80294f:	e9 70 01 00 00       	jmpq   802ac4 <dup+0x1a7>
	close(newfdnum);
  802954:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802957:	89 c7                	mov    %eax,%edi
  802959:	48 b8 a4 28 80 00 00 	movabs $0x8028a4,%rax
  802960:	00 00 00 
  802963:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802965:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802968:	48 98                	cltq   
  80296a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802970:	48 c1 e0 0c          	shl    $0xc,%rax
  802974:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802978:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80297c:	48 89 c7             	mov    %rax,%rdi
  80297f:	48 b8 d1 25 80 00 00 	movabs $0x8025d1,%rax
  802986:	00 00 00 
  802989:	ff d0                	callq  *%rax
  80298b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80298f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802993:	48 89 c7             	mov    %rax,%rdi
  802996:	48 b8 d1 25 80 00 00 	movabs $0x8025d1,%rax
  80299d:	00 00 00 
  8029a0:	ff d0                	callq  *%rax
  8029a2:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8029a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029aa:	48 c1 e8 15          	shr    $0x15,%rax
  8029ae:	48 89 c2             	mov    %rax,%rdx
  8029b1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8029b8:	01 00 00 
  8029bb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029bf:	83 e0 01             	and    $0x1,%eax
  8029c2:	48 85 c0             	test   %rax,%rax
  8029c5:	74 73                	je     802a3a <dup+0x11d>
  8029c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029cb:	48 c1 e8 0c          	shr    $0xc,%rax
  8029cf:	48 89 c2             	mov    %rax,%rdx
  8029d2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8029d9:	01 00 00 
  8029dc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029e0:	83 e0 01             	and    $0x1,%eax
  8029e3:	48 85 c0             	test   %rax,%rax
  8029e6:	74 52                	je     802a3a <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8029e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029ec:	48 c1 e8 0c          	shr    $0xc,%rax
  8029f0:	48 89 c2             	mov    %rax,%rdx
  8029f3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8029fa:	01 00 00 
  8029fd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a01:	25 07 0e 00 00       	and    $0xe07,%eax
  802a06:	89 c1                	mov    %eax,%ecx
  802a08:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802a0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a10:	41 89 c8             	mov    %ecx,%r8d
  802a13:	48 89 d1             	mov    %rdx,%rcx
  802a16:	ba 00 00 00 00       	mov    $0x0,%edx
  802a1b:	48 89 c6             	mov    %rax,%rsi
  802a1e:	bf 00 00 00 00       	mov    $0x0,%edi
  802a23:	48 b8 51 22 80 00 00 	movabs $0x802251,%rax
  802a2a:	00 00 00 
  802a2d:	ff d0                	callq  *%rax
  802a2f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a32:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a36:	79 02                	jns    802a3a <dup+0x11d>
			goto err;
  802a38:	eb 57                	jmp    802a91 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802a3a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a3e:	48 c1 e8 0c          	shr    $0xc,%rax
  802a42:	48 89 c2             	mov    %rax,%rdx
  802a45:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a4c:	01 00 00 
  802a4f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a53:	25 07 0e 00 00       	and    $0xe07,%eax
  802a58:	89 c1                	mov    %eax,%ecx
  802a5a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a5e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a62:	41 89 c8             	mov    %ecx,%r8d
  802a65:	48 89 d1             	mov    %rdx,%rcx
  802a68:	ba 00 00 00 00       	mov    $0x0,%edx
  802a6d:	48 89 c6             	mov    %rax,%rsi
  802a70:	bf 00 00 00 00       	mov    $0x0,%edi
  802a75:	48 b8 51 22 80 00 00 	movabs $0x802251,%rax
  802a7c:	00 00 00 
  802a7f:	ff d0                	callq  *%rax
  802a81:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a84:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a88:	79 02                	jns    802a8c <dup+0x16f>
		goto err;
  802a8a:	eb 05                	jmp    802a91 <dup+0x174>

	return newfdnum;
  802a8c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a8f:	eb 33                	jmp    802ac4 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802a91:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a95:	48 89 c6             	mov    %rax,%rsi
  802a98:	bf 00 00 00 00       	mov    $0x0,%edi
  802a9d:	48 b8 ac 22 80 00 00 	movabs $0x8022ac,%rax
  802aa4:	00 00 00 
  802aa7:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802aa9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802aad:	48 89 c6             	mov    %rax,%rsi
  802ab0:	bf 00 00 00 00       	mov    $0x0,%edi
  802ab5:	48 b8 ac 22 80 00 00 	movabs $0x8022ac,%rax
  802abc:	00 00 00 
  802abf:	ff d0                	callq  *%rax
	return r;
  802ac1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802ac4:	c9                   	leaveq 
  802ac5:	c3                   	retq   

0000000000802ac6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802ac6:	55                   	push   %rbp
  802ac7:	48 89 e5             	mov    %rsp,%rbp
  802aca:	48 83 ec 40          	sub    $0x40,%rsp
  802ace:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ad1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802ad5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ad9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802add:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ae0:	48 89 d6             	mov    %rdx,%rsi
  802ae3:	89 c7                	mov    %eax,%edi
  802ae5:	48 b8 94 26 80 00 00 	movabs $0x802694,%rax
  802aec:	00 00 00 
  802aef:	ff d0                	callq  *%rax
  802af1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802af4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802af8:	78 24                	js     802b1e <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802afa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802afe:	8b 00                	mov    (%rax),%eax
  802b00:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b04:	48 89 d6             	mov    %rdx,%rsi
  802b07:	89 c7                	mov    %eax,%edi
  802b09:	48 b8 ed 27 80 00 00 	movabs $0x8027ed,%rax
  802b10:	00 00 00 
  802b13:	ff d0                	callq  *%rax
  802b15:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b18:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b1c:	79 05                	jns    802b23 <read+0x5d>
		return r;
  802b1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b21:	eb 76                	jmp    802b99 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802b23:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b27:	8b 40 08             	mov    0x8(%rax),%eax
  802b2a:	83 e0 03             	and    $0x3,%eax
  802b2d:	83 f8 01             	cmp    $0x1,%eax
  802b30:	75 3a                	jne    802b6c <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802b32:	48 b8 d8 71 80 00 00 	movabs $0x8071d8,%rax
  802b39:	00 00 00 
  802b3c:	48 8b 00             	mov    (%rax),%rax
  802b3f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b45:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b48:	89 c6                	mov    %eax,%esi
  802b4a:	48 bf 87 45 80 00 00 	movabs $0x804587,%rdi
  802b51:	00 00 00 
  802b54:	b8 00 00 00 00       	mov    $0x0,%eax
  802b59:	48 b9 1d 0d 80 00 00 	movabs $0x800d1d,%rcx
  802b60:	00 00 00 
  802b63:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802b65:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b6a:	eb 2d                	jmp    802b99 <read+0xd3>
	}
	if (!dev->dev_read)
  802b6c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b70:	48 8b 40 10          	mov    0x10(%rax),%rax
  802b74:	48 85 c0             	test   %rax,%rax
  802b77:	75 07                	jne    802b80 <read+0xba>
		return -E_NOT_SUPP;
  802b79:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b7e:	eb 19                	jmp    802b99 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802b80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b84:	48 8b 40 10          	mov    0x10(%rax),%rax
  802b88:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802b8c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b90:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802b94:	48 89 cf             	mov    %rcx,%rdi
  802b97:	ff d0                	callq  *%rax
}
  802b99:	c9                   	leaveq 
  802b9a:	c3                   	retq   

0000000000802b9b <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802b9b:	55                   	push   %rbp
  802b9c:	48 89 e5             	mov    %rsp,%rbp
  802b9f:	48 83 ec 30          	sub    $0x30,%rsp
  802ba3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ba6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802baa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802bae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802bb5:	eb 49                	jmp    802c00 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802bb7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bba:	48 98                	cltq   
  802bbc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802bc0:	48 29 c2             	sub    %rax,%rdx
  802bc3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bc6:	48 63 c8             	movslq %eax,%rcx
  802bc9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bcd:	48 01 c1             	add    %rax,%rcx
  802bd0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bd3:	48 89 ce             	mov    %rcx,%rsi
  802bd6:	89 c7                	mov    %eax,%edi
  802bd8:	48 b8 c6 2a 80 00 00 	movabs $0x802ac6,%rax
  802bdf:	00 00 00 
  802be2:	ff d0                	callq  *%rax
  802be4:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802be7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802beb:	79 05                	jns    802bf2 <readn+0x57>
			return m;
  802bed:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bf0:	eb 1c                	jmp    802c0e <readn+0x73>
		if (m == 0)
  802bf2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802bf6:	75 02                	jne    802bfa <readn+0x5f>
			break;
  802bf8:	eb 11                	jmp    802c0b <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802bfa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bfd:	01 45 fc             	add    %eax,-0x4(%rbp)
  802c00:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c03:	48 98                	cltq   
  802c05:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802c09:	72 ac                	jb     802bb7 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802c0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c0e:	c9                   	leaveq 
  802c0f:	c3                   	retq   

0000000000802c10 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802c10:	55                   	push   %rbp
  802c11:	48 89 e5             	mov    %rsp,%rbp
  802c14:	48 83 ec 40          	sub    $0x40,%rsp
  802c18:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c1b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802c1f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c23:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c27:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c2a:	48 89 d6             	mov    %rdx,%rsi
  802c2d:	89 c7                	mov    %eax,%edi
  802c2f:	48 b8 94 26 80 00 00 	movabs $0x802694,%rax
  802c36:	00 00 00 
  802c39:	ff d0                	callq  *%rax
  802c3b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c3e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c42:	78 24                	js     802c68 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c48:	8b 00                	mov    (%rax),%eax
  802c4a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c4e:	48 89 d6             	mov    %rdx,%rsi
  802c51:	89 c7                	mov    %eax,%edi
  802c53:	48 b8 ed 27 80 00 00 	movabs $0x8027ed,%rax
  802c5a:	00 00 00 
  802c5d:	ff d0                	callq  *%rax
  802c5f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c62:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c66:	79 05                	jns    802c6d <write+0x5d>
		return r;
  802c68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c6b:	eb 75                	jmp    802ce2 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802c6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c71:	8b 40 08             	mov    0x8(%rax),%eax
  802c74:	83 e0 03             	and    $0x3,%eax
  802c77:	85 c0                	test   %eax,%eax
  802c79:	75 3a                	jne    802cb5 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802c7b:	48 b8 d8 71 80 00 00 	movabs $0x8071d8,%rax
  802c82:	00 00 00 
  802c85:	48 8b 00             	mov    (%rax),%rax
  802c88:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c8e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c91:	89 c6                	mov    %eax,%esi
  802c93:	48 bf a3 45 80 00 00 	movabs $0x8045a3,%rdi
  802c9a:	00 00 00 
  802c9d:	b8 00 00 00 00       	mov    $0x0,%eax
  802ca2:	48 b9 1d 0d 80 00 00 	movabs $0x800d1d,%rcx
  802ca9:	00 00 00 
  802cac:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802cae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802cb3:	eb 2d                	jmp    802ce2 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802cb5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cb9:	48 8b 40 18          	mov    0x18(%rax),%rax
  802cbd:	48 85 c0             	test   %rax,%rax
  802cc0:	75 07                	jne    802cc9 <write+0xb9>
		return -E_NOT_SUPP;
  802cc2:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802cc7:	eb 19                	jmp    802ce2 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802cc9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ccd:	48 8b 40 18          	mov    0x18(%rax),%rax
  802cd1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802cd5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802cd9:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802cdd:	48 89 cf             	mov    %rcx,%rdi
  802ce0:	ff d0                	callq  *%rax
}
  802ce2:	c9                   	leaveq 
  802ce3:	c3                   	retq   

0000000000802ce4 <seek>:

int
seek(int fdnum, off_t offset)
{
  802ce4:	55                   	push   %rbp
  802ce5:	48 89 e5             	mov    %rsp,%rbp
  802ce8:	48 83 ec 18          	sub    $0x18,%rsp
  802cec:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802cef:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802cf2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802cf6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cf9:	48 89 d6             	mov    %rdx,%rsi
  802cfc:	89 c7                	mov    %eax,%edi
  802cfe:	48 b8 94 26 80 00 00 	movabs $0x802694,%rax
  802d05:	00 00 00 
  802d08:	ff d0                	callq  *%rax
  802d0a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d0d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d11:	79 05                	jns    802d18 <seek+0x34>
		return r;
  802d13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d16:	eb 0f                	jmp    802d27 <seek+0x43>
	fd->fd_offset = offset;
  802d18:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d1c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802d1f:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802d22:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d27:	c9                   	leaveq 
  802d28:	c3                   	retq   

0000000000802d29 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802d29:	55                   	push   %rbp
  802d2a:	48 89 e5             	mov    %rsp,%rbp
  802d2d:	48 83 ec 30          	sub    $0x30,%rsp
  802d31:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d34:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d37:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d3b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d3e:	48 89 d6             	mov    %rdx,%rsi
  802d41:	89 c7                	mov    %eax,%edi
  802d43:	48 b8 94 26 80 00 00 	movabs $0x802694,%rax
  802d4a:	00 00 00 
  802d4d:	ff d0                	callq  *%rax
  802d4f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d52:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d56:	78 24                	js     802d7c <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d5c:	8b 00                	mov    (%rax),%eax
  802d5e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d62:	48 89 d6             	mov    %rdx,%rsi
  802d65:	89 c7                	mov    %eax,%edi
  802d67:	48 b8 ed 27 80 00 00 	movabs $0x8027ed,%rax
  802d6e:	00 00 00 
  802d71:	ff d0                	callq  *%rax
  802d73:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d76:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d7a:	79 05                	jns    802d81 <ftruncate+0x58>
		return r;
  802d7c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d7f:	eb 72                	jmp    802df3 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802d81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d85:	8b 40 08             	mov    0x8(%rax),%eax
  802d88:	83 e0 03             	and    $0x3,%eax
  802d8b:	85 c0                	test   %eax,%eax
  802d8d:	75 3a                	jne    802dc9 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802d8f:	48 b8 d8 71 80 00 00 	movabs $0x8071d8,%rax
  802d96:	00 00 00 
  802d99:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802d9c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802da2:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802da5:	89 c6                	mov    %eax,%esi
  802da7:	48 bf c0 45 80 00 00 	movabs $0x8045c0,%rdi
  802dae:	00 00 00 
  802db1:	b8 00 00 00 00       	mov    $0x0,%eax
  802db6:	48 b9 1d 0d 80 00 00 	movabs $0x800d1d,%rcx
  802dbd:	00 00 00 
  802dc0:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802dc2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802dc7:	eb 2a                	jmp    802df3 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802dc9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dcd:	48 8b 40 30          	mov    0x30(%rax),%rax
  802dd1:	48 85 c0             	test   %rax,%rax
  802dd4:	75 07                	jne    802ddd <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802dd6:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ddb:	eb 16                	jmp    802df3 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802ddd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802de1:	48 8b 40 30          	mov    0x30(%rax),%rax
  802de5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802de9:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802dec:	89 ce                	mov    %ecx,%esi
  802dee:	48 89 d7             	mov    %rdx,%rdi
  802df1:	ff d0                	callq  *%rax
}
  802df3:	c9                   	leaveq 
  802df4:	c3                   	retq   

0000000000802df5 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802df5:	55                   	push   %rbp
  802df6:	48 89 e5             	mov    %rsp,%rbp
  802df9:	48 83 ec 30          	sub    $0x30,%rsp
  802dfd:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e00:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e04:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e08:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e0b:	48 89 d6             	mov    %rdx,%rsi
  802e0e:	89 c7                	mov    %eax,%edi
  802e10:	48 b8 94 26 80 00 00 	movabs $0x802694,%rax
  802e17:	00 00 00 
  802e1a:	ff d0                	callq  *%rax
  802e1c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e1f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e23:	78 24                	js     802e49 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e29:	8b 00                	mov    (%rax),%eax
  802e2b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e2f:	48 89 d6             	mov    %rdx,%rsi
  802e32:	89 c7                	mov    %eax,%edi
  802e34:	48 b8 ed 27 80 00 00 	movabs $0x8027ed,%rax
  802e3b:	00 00 00 
  802e3e:	ff d0                	callq  *%rax
  802e40:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e43:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e47:	79 05                	jns    802e4e <fstat+0x59>
		return r;
  802e49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e4c:	eb 5e                	jmp    802eac <fstat+0xb7>
	if (!dev->dev_stat)
  802e4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e52:	48 8b 40 28          	mov    0x28(%rax),%rax
  802e56:	48 85 c0             	test   %rax,%rax
  802e59:	75 07                	jne    802e62 <fstat+0x6d>
		return -E_NOT_SUPP;
  802e5b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e60:	eb 4a                	jmp    802eac <fstat+0xb7>
	stat->st_name[0] = 0;
  802e62:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e66:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802e69:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e6d:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802e74:	00 00 00 
	stat->st_isdir = 0;
  802e77:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e7b:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802e82:	00 00 00 
	stat->st_dev = dev;
  802e85:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e89:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e8d:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802e94:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e98:	48 8b 40 28          	mov    0x28(%rax),%rax
  802e9c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ea0:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802ea4:	48 89 ce             	mov    %rcx,%rsi
  802ea7:	48 89 d7             	mov    %rdx,%rdi
  802eaa:	ff d0                	callq  *%rax
}
  802eac:	c9                   	leaveq 
  802ead:	c3                   	retq   

0000000000802eae <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802eae:	55                   	push   %rbp
  802eaf:	48 89 e5             	mov    %rsp,%rbp
  802eb2:	48 83 ec 20          	sub    $0x20,%rsp
  802eb6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802eba:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802ebe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ec2:	be 00 00 00 00       	mov    $0x0,%esi
  802ec7:	48 89 c7             	mov    %rax,%rdi
  802eca:	48 b8 9c 2f 80 00 00 	movabs $0x802f9c,%rax
  802ed1:	00 00 00 
  802ed4:	ff d0                	callq  *%rax
  802ed6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ed9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802edd:	79 05                	jns    802ee4 <stat+0x36>
		return fd;
  802edf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ee2:	eb 2f                	jmp    802f13 <stat+0x65>
	r = fstat(fd, stat);
  802ee4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802ee8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eeb:	48 89 d6             	mov    %rdx,%rsi
  802eee:	89 c7                	mov    %eax,%edi
  802ef0:	48 b8 f5 2d 80 00 00 	movabs $0x802df5,%rax
  802ef7:	00 00 00 
  802efa:	ff d0                	callq  *%rax
  802efc:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802eff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f02:	89 c7                	mov    %eax,%edi
  802f04:	48 b8 a4 28 80 00 00 	movabs $0x8028a4,%rax
  802f0b:	00 00 00 
  802f0e:	ff d0                	callq  *%rax
	return r;
  802f10:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802f13:	c9                   	leaveq 
  802f14:	c3                   	retq   

0000000000802f15 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802f15:	55                   	push   %rbp
  802f16:	48 89 e5             	mov    %rsp,%rbp
  802f19:	48 83 ec 10          	sub    $0x10,%rsp
  802f1d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802f20:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802f24:	48 b8 d0 71 80 00 00 	movabs $0x8071d0,%rax
  802f2b:	00 00 00 
  802f2e:	8b 00                	mov    (%rax),%eax
  802f30:	85 c0                	test   %eax,%eax
  802f32:	75 1d                	jne    802f51 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802f34:	bf 01 00 00 00       	mov    $0x1,%edi
  802f39:	48 b8 bb 3d 80 00 00 	movabs $0x803dbb,%rax
  802f40:	00 00 00 
  802f43:	ff d0                	callq  *%rax
  802f45:	48 ba d0 71 80 00 00 	movabs $0x8071d0,%rdx
  802f4c:	00 00 00 
  802f4f:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802f51:	48 b8 d0 71 80 00 00 	movabs $0x8071d0,%rax
  802f58:	00 00 00 
  802f5b:	8b 00                	mov    (%rax),%eax
  802f5d:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802f60:	b9 07 00 00 00       	mov    $0x7,%ecx
  802f65:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802f6c:	00 00 00 
  802f6f:	89 c7                	mov    %eax,%edi
  802f71:	48 b8 59 3d 80 00 00 	movabs $0x803d59,%rax
  802f78:	00 00 00 
  802f7b:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802f7d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f81:	ba 00 00 00 00       	mov    $0x0,%edx
  802f86:	48 89 c6             	mov    %rax,%rsi
  802f89:	bf 00 00 00 00       	mov    $0x0,%edi
  802f8e:	48 b8 53 3c 80 00 00 	movabs $0x803c53,%rax
  802f95:	00 00 00 
  802f98:	ff d0                	callq  *%rax
}
  802f9a:	c9                   	leaveq 
  802f9b:	c3                   	retq   

0000000000802f9c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802f9c:	55                   	push   %rbp
  802f9d:	48 89 e5             	mov    %rsp,%rbp
  802fa0:	48 83 ec 30          	sub    $0x30,%rsp
  802fa4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802fa8:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802fab:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802fb2:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802fb9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802fc0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802fc5:	75 08                	jne    802fcf <open+0x33>
	{
		return r;
  802fc7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fca:	e9 f2 00 00 00       	jmpq   8030c1 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802fcf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fd3:	48 89 c7             	mov    %rax,%rdi
  802fd6:	48 b8 66 18 80 00 00 	movabs $0x801866,%rax
  802fdd:	00 00 00 
  802fe0:	ff d0                	callq  *%rax
  802fe2:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802fe5:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802fec:	7e 0a                	jle    802ff8 <open+0x5c>
	{
		return -E_BAD_PATH;
  802fee:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802ff3:	e9 c9 00 00 00       	jmpq   8030c1 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802ff8:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802fff:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  803000:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  803004:	48 89 c7             	mov    %rax,%rdi
  803007:	48 b8 fc 25 80 00 00 	movabs $0x8025fc,%rax
  80300e:	00 00 00 
  803011:	ff d0                	callq  *%rax
  803013:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803016:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80301a:	78 09                	js     803025 <open+0x89>
  80301c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803020:	48 85 c0             	test   %rax,%rax
  803023:	75 08                	jne    80302d <open+0x91>
		{
			return r;
  803025:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803028:	e9 94 00 00 00       	jmpq   8030c1 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  80302d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803031:	ba 00 04 00 00       	mov    $0x400,%edx
  803036:	48 89 c6             	mov    %rax,%rsi
  803039:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  803040:	00 00 00 
  803043:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  80304a:	00 00 00 
  80304d:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  80304f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803056:	00 00 00 
  803059:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  80305c:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  803062:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803066:	48 89 c6             	mov    %rax,%rsi
  803069:	bf 01 00 00 00       	mov    $0x1,%edi
  80306e:	48 b8 15 2f 80 00 00 	movabs $0x802f15,%rax
  803075:	00 00 00 
  803078:	ff d0                	callq  *%rax
  80307a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80307d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803081:	79 2b                	jns    8030ae <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  803083:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803087:	be 00 00 00 00       	mov    $0x0,%esi
  80308c:	48 89 c7             	mov    %rax,%rdi
  80308f:	48 b8 24 27 80 00 00 	movabs $0x802724,%rax
  803096:	00 00 00 
  803099:	ff d0                	callq  *%rax
  80309b:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80309e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8030a2:	79 05                	jns    8030a9 <open+0x10d>
			{
				return d;
  8030a4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030a7:	eb 18                	jmp    8030c1 <open+0x125>
			}
			return r;
  8030a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030ac:	eb 13                	jmp    8030c1 <open+0x125>
		}	
		return fd2num(fd_store);
  8030ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030b2:	48 89 c7             	mov    %rax,%rdi
  8030b5:	48 b8 ae 25 80 00 00 	movabs $0x8025ae,%rax
  8030bc:	00 00 00 
  8030bf:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  8030c1:	c9                   	leaveq 
  8030c2:	c3                   	retq   

00000000008030c3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8030c3:	55                   	push   %rbp
  8030c4:	48 89 e5             	mov    %rsp,%rbp
  8030c7:	48 83 ec 10          	sub    $0x10,%rsp
  8030cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8030cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030d3:	8b 50 0c             	mov    0xc(%rax),%edx
  8030d6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030dd:	00 00 00 
  8030e0:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8030e2:	be 00 00 00 00       	mov    $0x0,%esi
  8030e7:	bf 06 00 00 00       	mov    $0x6,%edi
  8030ec:	48 b8 15 2f 80 00 00 	movabs $0x802f15,%rax
  8030f3:	00 00 00 
  8030f6:	ff d0                	callq  *%rax
}
  8030f8:	c9                   	leaveq 
  8030f9:	c3                   	retq   

00000000008030fa <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8030fa:	55                   	push   %rbp
  8030fb:	48 89 e5             	mov    %rsp,%rbp
  8030fe:	48 83 ec 30          	sub    $0x30,%rsp
  803102:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803106:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80310a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  80310e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  803115:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80311a:	74 07                	je     803123 <devfile_read+0x29>
  80311c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803121:	75 07                	jne    80312a <devfile_read+0x30>
		return -E_INVAL;
  803123:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803128:	eb 77                	jmp    8031a1 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80312a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80312e:	8b 50 0c             	mov    0xc(%rax),%edx
  803131:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803138:	00 00 00 
  80313b:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80313d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803144:	00 00 00 
  803147:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80314b:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  80314f:	be 00 00 00 00       	mov    $0x0,%esi
  803154:	bf 03 00 00 00       	mov    $0x3,%edi
  803159:	48 b8 15 2f 80 00 00 	movabs $0x802f15,%rax
  803160:	00 00 00 
  803163:	ff d0                	callq  *%rax
  803165:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803168:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80316c:	7f 05                	jg     803173 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  80316e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803171:	eb 2e                	jmp    8031a1 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  803173:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803176:	48 63 d0             	movslq %eax,%rdx
  803179:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80317d:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803184:	00 00 00 
  803187:	48 89 c7             	mov    %rax,%rdi
  80318a:	48 b8 f6 1b 80 00 00 	movabs $0x801bf6,%rax
  803191:	00 00 00 
  803194:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  803196:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80319a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  80319e:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8031a1:	c9                   	leaveq 
  8031a2:	c3                   	retq   

00000000008031a3 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8031a3:	55                   	push   %rbp
  8031a4:	48 89 e5             	mov    %rsp,%rbp
  8031a7:	48 83 ec 30          	sub    $0x30,%rsp
  8031ab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031af:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8031b3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  8031b7:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  8031be:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8031c3:	74 07                	je     8031cc <devfile_write+0x29>
  8031c5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8031ca:	75 08                	jne    8031d4 <devfile_write+0x31>
		return r;
  8031cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031cf:	e9 9a 00 00 00       	jmpq   80326e <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8031d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031d8:	8b 50 0c             	mov    0xc(%rax),%edx
  8031db:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031e2:	00 00 00 
  8031e5:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  8031e7:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8031ee:	00 
  8031ef:	76 08                	jbe    8031f9 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  8031f1:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8031f8:	00 
	}
	fsipcbuf.write.req_n = n;
  8031f9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803200:	00 00 00 
  803203:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803207:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  80320b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80320f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803213:	48 89 c6             	mov    %rax,%rsi
  803216:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  80321d:	00 00 00 
  803220:	48 b8 f6 1b 80 00 00 	movabs $0x801bf6,%rax
  803227:	00 00 00 
  80322a:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  80322c:	be 00 00 00 00       	mov    $0x0,%esi
  803231:	bf 04 00 00 00       	mov    $0x4,%edi
  803236:	48 b8 15 2f 80 00 00 	movabs $0x802f15,%rax
  80323d:	00 00 00 
  803240:	ff d0                	callq  *%rax
  803242:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803245:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803249:	7f 20                	jg     80326b <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  80324b:	48 bf e6 45 80 00 00 	movabs $0x8045e6,%rdi
  803252:	00 00 00 
  803255:	b8 00 00 00 00       	mov    $0x0,%eax
  80325a:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  803261:	00 00 00 
  803264:	ff d2                	callq  *%rdx
		return r;
  803266:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803269:	eb 03                	jmp    80326e <devfile_write+0xcb>
	}
	return r;
  80326b:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  80326e:	c9                   	leaveq 
  80326f:	c3                   	retq   

0000000000803270 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803270:	55                   	push   %rbp
  803271:	48 89 e5             	mov    %rsp,%rbp
  803274:	48 83 ec 20          	sub    $0x20,%rsp
  803278:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80327c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803280:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803284:	8b 50 0c             	mov    0xc(%rax),%edx
  803287:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80328e:	00 00 00 
  803291:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803293:	be 00 00 00 00       	mov    $0x0,%esi
  803298:	bf 05 00 00 00       	mov    $0x5,%edi
  80329d:	48 b8 15 2f 80 00 00 	movabs $0x802f15,%rax
  8032a4:	00 00 00 
  8032a7:	ff d0                	callq  *%rax
  8032a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032b0:	79 05                	jns    8032b7 <devfile_stat+0x47>
		return r;
  8032b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032b5:	eb 56                	jmp    80330d <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8032b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032bb:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8032c2:	00 00 00 
  8032c5:	48 89 c7             	mov    %rax,%rdi
  8032c8:	48 b8 d2 18 80 00 00 	movabs $0x8018d2,%rax
  8032cf:	00 00 00 
  8032d2:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8032d4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8032db:	00 00 00 
  8032de:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8032e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032e8:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8032ee:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8032f5:	00 00 00 
  8032f8:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8032fe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803302:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803308:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80330d:	c9                   	leaveq 
  80330e:	c3                   	retq   

000000000080330f <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80330f:	55                   	push   %rbp
  803310:	48 89 e5             	mov    %rsp,%rbp
  803313:	48 83 ec 10          	sub    $0x10,%rsp
  803317:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80331b:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80331e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803322:	8b 50 0c             	mov    0xc(%rax),%edx
  803325:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80332c:	00 00 00 
  80332f:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803331:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803338:	00 00 00 
  80333b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80333e:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803341:	be 00 00 00 00       	mov    $0x0,%esi
  803346:	bf 02 00 00 00       	mov    $0x2,%edi
  80334b:	48 b8 15 2f 80 00 00 	movabs $0x802f15,%rax
  803352:	00 00 00 
  803355:	ff d0                	callq  *%rax
}
  803357:	c9                   	leaveq 
  803358:	c3                   	retq   

0000000000803359 <remove>:

// Delete a file
int
remove(const char *path)
{
  803359:	55                   	push   %rbp
  80335a:	48 89 e5             	mov    %rsp,%rbp
  80335d:	48 83 ec 10          	sub    $0x10,%rsp
  803361:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803365:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803369:	48 89 c7             	mov    %rax,%rdi
  80336c:	48 b8 66 18 80 00 00 	movabs $0x801866,%rax
  803373:	00 00 00 
  803376:	ff d0                	callq  *%rax
  803378:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80337d:	7e 07                	jle    803386 <remove+0x2d>
		return -E_BAD_PATH;
  80337f:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803384:	eb 33                	jmp    8033b9 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803386:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80338a:	48 89 c6             	mov    %rax,%rsi
  80338d:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  803394:	00 00 00 
  803397:	48 b8 d2 18 80 00 00 	movabs $0x8018d2,%rax
  80339e:	00 00 00 
  8033a1:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8033a3:	be 00 00 00 00       	mov    $0x0,%esi
  8033a8:	bf 07 00 00 00       	mov    $0x7,%edi
  8033ad:	48 b8 15 2f 80 00 00 	movabs $0x802f15,%rax
  8033b4:	00 00 00 
  8033b7:	ff d0                	callq  *%rax
}
  8033b9:	c9                   	leaveq 
  8033ba:	c3                   	retq   

00000000008033bb <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8033bb:	55                   	push   %rbp
  8033bc:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8033bf:	be 00 00 00 00       	mov    $0x0,%esi
  8033c4:	bf 08 00 00 00       	mov    $0x8,%edi
  8033c9:	48 b8 15 2f 80 00 00 	movabs $0x802f15,%rax
  8033d0:	00 00 00 
  8033d3:	ff d0                	callq  *%rax
}
  8033d5:	5d                   	pop    %rbp
  8033d6:	c3                   	retq   

00000000008033d7 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8033d7:	55                   	push   %rbp
  8033d8:	48 89 e5             	mov    %rsp,%rbp
  8033db:	53                   	push   %rbx
  8033dc:	48 83 ec 38          	sub    $0x38,%rsp
  8033e0:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8033e4:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8033e8:	48 89 c7             	mov    %rax,%rdi
  8033eb:	48 b8 fc 25 80 00 00 	movabs $0x8025fc,%rax
  8033f2:	00 00 00 
  8033f5:	ff d0                	callq  *%rax
  8033f7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8033fa:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8033fe:	0f 88 bf 01 00 00    	js     8035c3 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803404:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803408:	ba 07 04 00 00       	mov    $0x407,%edx
  80340d:	48 89 c6             	mov    %rax,%rsi
  803410:	bf 00 00 00 00       	mov    $0x0,%edi
  803415:	48 b8 01 22 80 00 00 	movabs $0x802201,%rax
  80341c:	00 00 00 
  80341f:	ff d0                	callq  *%rax
  803421:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803424:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803428:	0f 88 95 01 00 00    	js     8035c3 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80342e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803432:	48 89 c7             	mov    %rax,%rdi
  803435:	48 b8 fc 25 80 00 00 	movabs $0x8025fc,%rax
  80343c:	00 00 00 
  80343f:	ff d0                	callq  *%rax
  803441:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803444:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803448:	0f 88 5d 01 00 00    	js     8035ab <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80344e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803452:	ba 07 04 00 00       	mov    $0x407,%edx
  803457:	48 89 c6             	mov    %rax,%rsi
  80345a:	bf 00 00 00 00       	mov    $0x0,%edi
  80345f:	48 b8 01 22 80 00 00 	movabs $0x802201,%rax
  803466:	00 00 00 
  803469:	ff d0                	callq  *%rax
  80346b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80346e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803472:	0f 88 33 01 00 00    	js     8035ab <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803478:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80347c:	48 89 c7             	mov    %rax,%rdi
  80347f:	48 b8 d1 25 80 00 00 	movabs $0x8025d1,%rax
  803486:	00 00 00 
  803489:	ff d0                	callq  *%rax
  80348b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80348f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803493:	ba 07 04 00 00       	mov    $0x407,%edx
  803498:	48 89 c6             	mov    %rax,%rsi
  80349b:	bf 00 00 00 00       	mov    $0x0,%edi
  8034a0:	48 b8 01 22 80 00 00 	movabs $0x802201,%rax
  8034a7:	00 00 00 
  8034aa:	ff d0                	callq  *%rax
  8034ac:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034af:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8034b3:	79 05                	jns    8034ba <pipe+0xe3>
		goto err2;
  8034b5:	e9 d9 00 00 00       	jmpq   803593 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8034ba:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034be:	48 89 c7             	mov    %rax,%rdi
  8034c1:	48 b8 d1 25 80 00 00 	movabs $0x8025d1,%rax
  8034c8:	00 00 00 
  8034cb:	ff d0                	callq  *%rax
  8034cd:	48 89 c2             	mov    %rax,%rdx
  8034d0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034d4:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8034da:	48 89 d1             	mov    %rdx,%rcx
  8034dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8034e2:	48 89 c6             	mov    %rax,%rsi
  8034e5:	bf 00 00 00 00       	mov    $0x0,%edi
  8034ea:	48 b8 51 22 80 00 00 	movabs $0x802251,%rax
  8034f1:	00 00 00 
  8034f4:	ff d0                	callq  *%rax
  8034f6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034f9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8034fd:	79 1b                	jns    80351a <pipe+0x143>
		goto err3;
  8034ff:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  803500:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803504:	48 89 c6             	mov    %rax,%rsi
  803507:	bf 00 00 00 00       	mov    $0x0,%edi
  80350c:	48 b8 ac 22 80 00 00 	movabs $0x8022ac,%rax
  803513:	00 00 00 
  803516:	ff d0                	callq  *%rax
  803518:	eb 79                	jmp    803593 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80351a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80351e:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803525:	00 00 00 
  803528:	8b 12                	mov    (%rdx),%edx
  80352a:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80352c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803530:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803537:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80353b:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803542:	00 00 00 
  803545:	8b 12                	mov    (%rdx),%edx
  803547:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803549:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80354d:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803554:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803558:	48 89 c7             	mov    %rax,%rdi
  80355b:	48 b8 ae 25 80 00 00 	movabs $0x8025ae,%rax
  803562:	00 00 00 
  803565:	ff d0                	callq  *%rax
  803567:	89 c2                	mov    %eax,%edx
  803569:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80356d:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80356f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803573:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803577:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80357b:	48 89 c7             	mov    %rax,%rdi
  80357e:	48 b8 ae 25 80 00 00 	movabs $0x8025ae,%rax
  803585:	00 00 00 
  803588:	ff d0                	callq  *%rax
  80358a:	89 03                	mov    %eax,(%rbx)
	return 0;
  80358c:	b8 00 00 00 00       	mov    $0x0,%eax
  803591:	eb 33                	jmp    8035c6 <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  803593:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803597:	48 89 c6             	mov    %rax,%rsi
  80359a:	bf 00 00 00 00       	mov    $0x0,%edi
  80359f:	48 b8 ac 22 80 00 00 	movabs $0x8022ac,%rax
  8035a6:	00 00 00 
  8035a9:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  8035ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035af:	48 89 c6             	mov    %rax,%rsi
  8035b2:	bf 00 00 00 00       	mov    $0x0,%edi
  8035b7:	48 b8 ac 22 80 00 00 	movabs $0x8022ac,%rax
  8035be:	00 00 00 
  8035c1:	ff d0                	callq  *%rax
    err:
	return r;
  8035c3:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8035c6:	48 83 c4 38          	add    $0x38,%rsp
  8035ca:	5b                   	pop    %rbx
  8035cb:	5d                   	pop    %rbp
  8035cc:	c3                   	retq   

00000000008035cd <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8035cd:	55                   	push   %rbp
  8035ce:	48 89 e5             	mov    %rsp,%rbp
  8035d1:	53                   	push   %rbx
  8035d2:	48 83 ec 28          	sub    $0x28,%rsp
  8035d6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8035da:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8035de:	48 b8 d8 71 80 00 00 	movabs $0x8071d8,%rax
  8035e5:	00 00 00 
  8035e8:	48 8b 00             	mov    (%rax),%rax
  8035eb:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8035f1:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8035f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035f8:	48 89 c7             	mov    %rax,%rdi
  8035fb:	48 b8 3d 3e 80 00 00 	movabs $0x803e3d,%rax
  803602:	00 00 00 
  803605:	ff d0                	callq  *%rax
  803607:	89 c3                	mov    %eax,%ebx
  803609:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80360d:	48 89 c7             	mov    %rax,%rdi
  803610:	48 b8 3d 3e 80 00 00 	movabs $0x803e3d,%rax
  803617:	00 00 00 
  80361a:	ff d0                	callq  *%rax
  80361c:	39 c3                	cmp    %eax,%ebx
  80361e:	0f 94 c0             	sete   %al
  803621:	0f b6 c0             	movzbl %al,%eax
  803624:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803627:	48 b8 d8 71 80 00 00 	movabs $0x8071d8,%rax
  80362e:	00 00 00 
  803631:	48 8b 00             	mov    (%rax),%rax
  803634:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80363a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80363d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803640:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803643:	75 05                	jne    80364a <_pipeisclosed+0x7d>
			return ret;
  803645:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803648:	eb 4f                	jmp    803699 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80364a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80364d:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803650:	74 42                	je     803694 <_pipeisclosed+0xc7>
  803652:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803656:	75 3c                	jne    803694 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803658:	48 b8 d8 71 80 00 00 	movabs $0x8071d8,%rax
  80365f:	00 00 00 
  803662:	48 8b 00             	mov    (%rax),%rax
  803665:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80366b:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80366e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803671:	89 c6                	mov    %eax,%esi
  803673:	48 bf 07 46 80 00 00 	movabs $0x804607,%rdi
  80367a:	00 00 00 
  80367d:	b8 00 00 00 00       	mov    $0x0,%eax
  803682:	49 b8 1d 0d 80 00 00 	movabs $0x800d1d,%r8
  803689:	00 00 00 
  80368c:	41 ff d0             	callq  *%r8
	}
  80368f:	e9 4a ff ff ff       	jmpq   8035de <_pipeisclosed+0x11>
  803694:	e9 45 ff ff ff       	jmpq   8035de <_pipeisclosed+0x11>
}
  803699:	48 83 c4 28          	add    $0x28,%rsp
  80369d:	5b                   	pop    %rbx
  80369e:	5d                   	pop    %rbp
  80369f:	c3                   	retq   

00000000008036a0 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8036a0:	55                   	push   %rbp
  8036a1:	48 89 e5             	mov    %rsp,%rbp
  8036a4:	48 83 ec 30          	sub    $0x30,%rsp
  8036a8:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8036ab:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8036af:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8036b2:	48 89 d6             	mov    %rdx,%rsi
  8036b5:	89 c7                	mov    %eax,%edi
  8036b7:	48 b8 94 26 80 00 00 	movabs $0x802694,%rax
  8036be:	00 00 00 
  8036c1:	ff d0                	callq  *%rax
  8036c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036ca:	79 05                	jns    8036d1 <pipeisclosed+0x31>
		return r;
  8036cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036cf:	eb 31                	jmp    803702 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8036d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036d5:	48 89 c7             	mov    %rax,%rdi
  8036d8:	48 b8 d1 25 80 00 00 	movabs $0x8025d1,%rax
  8036df:	00 00 00 
  8036e2:	ff d0                	callq  *%rax
  8036e4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8036e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036ec:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8036f0:	48 89 d6             	mov    %rdx,%rsi
  8036f3:	48 89 c7             	mov    %rax,%rdi
  8036f6:	48 b8 cd 35 80 00 00 	movabs $0x8035cd,%rax
  8036fd:	00 00 00 
  803700:	ff d0                	callq  *%rax
}
  803702:	c9                   	leaveq 
  803703:	c3                   	retq   

0000000000803704 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803704:	55                   	push   %rbp
  803705:	48 89 e5             	mov    %rsp,%rbp
  803708:	48 83 ec 40          	sub    $0x40,%rsp
  80370c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803710:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803714:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803718:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80371c:	48 89 c7             	mov    %rax,%rdi
  80371f:	48 b8 d1 25 80 00 00 	movabs $0x8025d1,%rax
  803726:	00 00 00 
  803729:	ff d0                	callq  *%rax
  80372b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80372f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803733:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803737:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80373e:	00 
  80373f:	e9 92 00 00 00       	jmpq   8037d6 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803744:	eb 41                	jmp    803787 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803746:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80374b:	74 09                	je     803756 <devpipe_read+0x52>
				return i;
  80374d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803751:	e9 92 00 00 00       	jmpq   8037e8 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803756:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80375a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80375e:	48 89 d6             	mov    %rdx,%rsi
  803761:	48 89 c7             	mov    %rax,%rdi
  803764:	48 b8 cd 35 80 00 00 	movabs $0x8035cd,%rax
  80376b:	00 00 00 
  80376e:	ff d0                	callq  *%rax
  803770:	85 c0                	test   %eax,%eax
  803772:	74 07                	je     80377b <devpipe_read+0x77>
				return 0;
  803774:	b8 00 00 00 00       	mov    $0x0,%eax
  803779:	eb 6d                	jmp    8037e8 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80377b:	48 b8 c3 21 80 00 00 	movabs $0x8021c3,%rax
  803782:	00 00 00 
  803785:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803787:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80378b:	8b 10                	mov    (%rax),%edx
  80378d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803791:	8b 40 04             	mov    0x4(%rax),%eax
  803794:	39 c2                	cmp    %eax,%edx
  803796:	74 ae                	je     803746 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803798:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80379c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8037a0:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8037a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037a8:	8b 00                	mov    (%rax),%eax
  8037aa:	99                   	cltd   
  8037ab:	c1 ea 1b             	shr    $0x1b,%edx
  8037ae:	01 d0                	add    %edx,%eax
  8037b0:	83 e0 1f             	and    $0x1f,%eax
  8037b3:	29 d0                	sub    %edx,%eax
  8037b5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8037b9:	48 98                	cltq   
  8037bb:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8037c0:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8037c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037c6:	8b 00                	mov    (%rax),%eax
  8037c8:	8d 50 01             	lea    0x1(%rax),%edx
  8037cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037cf:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8037d1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8037d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037da:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8037de:	0f 82 60 ff ff ff    	jb     803744 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8037e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8037e8:	c9                   	leaveq 
  8037e9:	c3                   	retq   

00000000008037ea <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8037ea:	55                   	push   %rbp
  8037eb:	48 89 e5             	mov    %rsp,%rbp
  8037ee:	48 83 ec 40          	sub    $0x40,%rsp
  8037f2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8037f6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8037fa:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8037fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803802:	48 89 c7             	mov    %rax,%rdi
  803805:	48 b8 d1 25 80 00 00 	movabs $0x8025d1,%rax
  80380c:	00 00 00 
  80380f:	ff d0                	callq  *%rax
  803811:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803815:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803819:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80381d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803824:	00 
  803825:	e9 8e 00 00 00       	jmpq   8038b8 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80382a:	eb 31                	jmp    80385d <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80382c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803830:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803834:	48 89 d6             	mov    %rdx,%rsi
  803837:	48 89 c7             	mov    %rax,%rdi
  80383a:	48 b8 cd 35 80 00 00 	movabs $0x8035cd,%rax
  803841:	00 00 00 
  803844:	ff d0                	callq  *%rax
  803846:	85 c0                	test   %eax,%eax
  803848:	74 07                	je     803851 <devpipe_write+0x67>
				return 0;
  80384a:	b8 00 00 00 00       	mov    $0x0,%eax
  80384f:	eb 79                	jmp    8038ca <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803851:	48 b8 c3 21 80 00 00 	movabs $0x8021c3,%rax
  803858:	00 00 00 
  80385b:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80385d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803861:	8b 40 04             	mov    0x4(%rax),%eax
  803864:	48 63 d0             	movslq %eax,%rdx
  803867:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80386b:	8b 00                	mov    (%rax),%eax
  80386d:	48 98                	cltq   
  80386f:	48 83 c0 20          	add    $0x20,%rax
  803873:	48 39 c2             	cmp    %rax,%rdx
  803876:	73 b4                	jae    80382c <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803878:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80387c:	8b 40 04             	mov    0x4(%rax),%eax
  80387f:	99                   	cltd   
  803880:	c1 ea 1b             	shr    $0x1b,%edx
  803883:	01 d0                	add    %edx,%eax
  803885:	83 e0 1f             	and    $0x1f,%eax
  803888:	29 d0                	sub    %edx,%eax
  80388a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80388e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803892:	48 01 ca             	add    %rcx,%rdx
  803895:	0f b6 0a             	movzbl (%rdx),%ecx
  803898:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80389c:	48 98                	cltq   
  80389e:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8038a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038a6:	8b 40 04             	mov    0x4(%rax),%eax
  8038a9:	8d 50 01             	lea    0x1(%rax),%edx
  8038ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038b0:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8038b3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8038b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038bc:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8038c0:	0f 82 64 ff ff ff    	jb     80382a <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8038c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8038ca:	c9                   	leaveq 
  8038cb:	c3                   	retq   

00000000008038cc <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8038cc:	55                   	push   %rbp
  8038cd:	48 89 e5             	mov    %rsp,%rbp
  8038d0:	48 83 ec 20          	sub    $0x20,%rsp
  8038d4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8038d8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8038dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038e0:	48 89 c7             	mov    %rax,%rdi
  8038e3:	48 b8 d1 25 80 00 00 	movabs $0x8025d1,%rax
  8038ea:	00 00 00 
  8038ed:	ff d0                	callq  *%rax
  8038ef:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8038f3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038f7:	48 be 1a 46 80 00 00 	movabs $0x80461a,%rsi
  8038fe:	00 00 00 
  803901:	48 89 c7             	mov    %rax,%rdi
  803904:	48 b8 d2 18 80 00 00 	movabs $0x8018d2,%rax
  80390b:	00 00 00 
  80390e:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803910:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803914:	8b 50 04             	mov    0x4(%rax),%edx
  803917:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80391b:	8b 00                	mov    (%rax),%eax
  80391d:	29 c2                	sub    %eax,%edx
  80391f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803923:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803929:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80392d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803934:	00 00 00 
	stat->st_dev = &devpipe;
  803937:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80393b:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  803942:	00 00 00 
  803945:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80394c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803951:	c9                   	leaveq 
  803952:	c3                   	retq   

0000000000803953 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803953:	55                   	push   %rbp
  803954:	48 89 e5             	mov    %rsp,%rbp
  803957:	48 83 ec 10          	sub    $0x10,%rsp
  80395b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80395f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803963:	48 89 c6             	mov    %rax,%rsi
  803966:	bf 00 00 00 00       	mov    $0x0,%edi
  80396b:	48 b8 ac 22 80 00 00 	movabs $0x8022ac,%rax
  803972:	00 00 00 
  803975:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803977:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80397b:	48 89 c7             	mov    %rax,%rdi
  80397e:	48 b8 d1 25 80 00 00 	movabs $0x8025d1,%rax
  803985:	00 00 00 
  803988:	ff d0                	callq  *%rax
  80398a:	48 89 c6             	mov    %rax,%rsi
  80398d:	bf 00 00 00 00       	mov    $0x0,%edi
  803992:	48 b8 ac 22 80 00 00 	movabs $0x8022ac,%rax
  803999:	00 00 00 
  80399c:	ff d0                	callq  *%rax
}
  80399e:	c9                   	leaveq 
  80399f:	c3                   	retq   

00000000008039a0 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8039a0:	55                   	push   %rbp
  8039a1:	48 89 e5             	mov    %rsp,%rbp
  8039a4:	48 83 ec 20          	sub    $0x20,%rsp
  8039a8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8039ab:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039ae:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8039b1:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8039b5:	be 01 00 00 00       	mov    $0x1,%esi
  8039ba:	48 89 c7             	mov    %rax,%rdi
  8039bd:	48 b8 b9 20 80 00 00 	movabs $0x8020b9,%rax
  8039c4:	00 00 00 
  8039c7:	ff d0                	callq  *%rax
}
  8039c9:	c9                   	leaveq 
  8039ca:	c3                   	retq   

00000000008039cb <getchar>:

int
getchar(void)
{
  8039cb:	55                   	push   %rbp
  8039cc:	48 89 e5             	mov    %rsp,%rbp
  8039cf:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8039d3:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8039d7:	ba 01 00 00 00       	mov    $0x1,%edx
  8039dc:	48 89 c6             	mov    %rax,%rsi
  8039df:	bf 00 00 00 00       	mov    $0x0,%edi
  8039e4:	48 b8 c6 2a 80 00 00 	movabs $0x802ac6,%rax
  8039eb:	00 00 00 
  8039ee:	ff d0                	callq  *%rax
  8039f0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8039f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039f7:	79 05                	jns    8039fe <getchar+0x33>
		return r;
  8039f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039fc:	eb 14                	jmp    803a12 <getchar+0x47>
	if (r < 1)
  8039fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a02:	7f 07                	jg     803a0b <getchar+0x40>
		return -E_EOF;
  803a04:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803a09:	eb 07                	jmp    803a12 <getchar+0x47>
	return c;
  803a0b:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803a0f:	0f b6 c0             	movzbl %al,%eax
}
  803a12:	c9                   	leaveq 
  803a13:	c3                   	retq   

0000000000803a14 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803a14:	55                   	push   %rbp
  803a15:	48 89 e5             	mov    %rsp,%rbp
  803a18:	48 83 ec 20          	sub    $0x20,%rsp
  803a1c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803a1f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803a23:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a26:	48 89 d6             	mov    %rdx,%rsi
  803a29:	89 c7                	mov    %eax,%edi
  803a2b:	48 b8 94 26 80 00 00 	movabs $0x802694,%rax
  803a32:	00 00 00 
  803a35:	ff d0                	callq  *%rax
  803a37:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a3a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a3e:	79 05                	jns    803a45 <iscons+0x31>
		return r;
  803a40:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a43:	eb 1a                	jmp    803a5f <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803a45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a49:	8b 10                	mov    (%rax),%edx
  803a4b:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  803a52:	00 00 00 
  803a55:	8b 00                	mov    (%rax),%eax
  803a57:	39 c2                	cmp    %eax,%edx
  803a59:	0f 94 c0             	sete   %al
  803a5c:	0f b6 c0             	movzbl %al,%eax
}
  803a5f:	c9                   	leaveq 
  803a60:	c3                   	retq   

0000000000803a61 <opencons>:

int
opencons(void)
{
  803a61:	55                   	push   %rbp
  803a62:	48 89 e5             	mov    %rsp,%rbp
  803a65:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803a69:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803a6d:	48 89 c7             	mov    %rax,%rdi
  803a70:	48 b8 fc 25 80 00 00 	movabs $0x8025fc,%rax
  803a77:	00 00 00 
  803a7a:	ff d0                	callq  *%rax
  803a7c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a7f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a83:	79 05                	jns    803a8a <opencons+0x29>
		return r;
  803a85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a88:	eb 5b                	jmp    803ae5 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803a8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a8e:	ba 07 04 00 00       	mov    $0x407,%edx
  803a93:	48 89 c6             	mov    %rax,%rsi
  803a96:	bf 00 00 00 00       	mov    $0x0,%edi
  803a9b:	48 b8 01 22 80 00 00 	movabs $0x802201,%rax
  803aa2:	00 00 00 
  803aa5:	ff d0                	callq  *%rax
  803aa7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803aaa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803aae:	79 05                	jns    803ab5 <opencons+0x54>
		return r;
  803ab0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ab3:	eb 30                	jmp    803ae5 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803ab5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ab9:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803ac0:	00 00 00 
  803ac3:	8b 12                	mov    (%rdx),%edx
  803ac5:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803ac7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803acb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803ad2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ad6:	48 89 c7             	mov    %rax,%rdi
  803ad9:	48 b8 ae 25 80 00 00 	movabs $0x8025ae,%rax
  803ae0:	00 00 00 
  803ae3:	ff d0                	callq  *%rax
}
  803ae5:	c9                   	leaveq 
  803ae6:	c3                   	retq   

0000000000803ae7 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803ae7:	55                   	push   %rbp
  803ae8:	48 89 e5             	mov    %rsp,%rbp
  803aeb:	48 83 ec 30          	sub    $0x30,%rsp
  803aef:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803af3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803af7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803afb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803b00:	75 07                	jne    803b09 <devcons_read+0x22>
		return 0;
  803b02:	b8 00 00 00 00       	mov    $0x0,%eax
  803b07:	eb 4b                	jmp    803b54 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803b09:	eb 0c                	jmp    803b17 <devcons_read+0x30>
		sys_yield();
  803b0b:	48 b8 c3 21 80 00 00 	movabs $0x8021c3,%rax
  803b12:	00 00 00 
  803b15:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803b17:	48 b8 03 21 80 00 00 	movabs $0x802103,%rax
  803b1e:	00 00 00 
  803b21:	ff d0                	callq  *%rax
  803b23:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b26:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b2a:	74 df                	je     803b0b <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803b2c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b30:	79 05                	jns    803b37 <devcons_read+0x50>
		return c;
  803b32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b35:	eb 1d                	jmp    803b54 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803b37:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803b3b:	75 07                	jne    803b44 <devcons_read+0x5d>
		return 0;
  803b3d:	b8 00 00 00 00       	mov    $0x0,%eax
  803b42:	eb 10                	jmp    803b54 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803b44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b47:	89 c2                	mov    %eax,%edx
  803b49:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b4d:	88 10                	mov    %dl,(%rax)
	return 1;
  803b4f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803b54:	c9                   	leaveq 
  803b55:	c3                   	retq   

0000000000803b56 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803b56:	55                   	push   %rbp
  803b57:	48 89 e5             	mov    %rsp,%rbp
  803b5a:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803b61:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803b68:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803b6f:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803b76:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803b7d:	eb 76                	jmp    803bf5 <devcons_write+0x9f>
		m = n - tot;
  803b7f:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803b86:	89 c2                	mov    %eax,%edx
  803b88:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b8b:	29 c2                	sub    %eax,%edx
  803b8d:	89 d0                	mov    %edx,%eax
  803b8f:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803b92:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b95:	83 f8 7f             	cmp    $0x7f,%eax
  803b98:	76 07                	jbe    803ba1 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803b9a:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803ba1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ba4:	48 63 d0             	movslq %eax,%rdx
  803ba7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803baa:	48 63 c8             	movslq %eax,%rcx
  803bad:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803bb4:	48 01 c1             	add    %rax,%rcx
  803bb7:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803bbe:	48 89 ce             	mov    %rcx,%rsi
  803bc1:	48 89 c7             	mov    %rax,%rdi
  803bc4:	48 b8 f6 1b 80 00 00 	movabs $0x801bf6,%rax
  803bcb:	00 00 00 
  803bce:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803bd0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803bd3:	48 63 d0             	movslq %eax,%rdx
  803bd6:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803bdd:	48 89 d6             	mov    %rdx,%rsi
  803be0:	48 89 c7             	mov    %rax,%rdi
  803be3:	48 b8 b9 20 80 00 00 	movabs $0x8020b9,%rax
  803bea:	00 00 00 
  803bed:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803bef:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803bf2:	01 45 fc             	add    %eax,-0x4(%rbp)
  803bf5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bf8:	48 98                	cltq   
  803bfa:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803c01:	0f 82 78 ff ff ff    	jb     803b7f <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803c07:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803c0a:	c9                   	leaveq 
  803c0b:	c3                   	retq   

0000000000803c0c <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803c0c:	55                   	push   %rbp
  803c0d:	48 89 e5             	mov    %rsp,%rbp
  803c10:	48 83 ec 08          	sub    $0x8,%rsp
  803c14:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803c18:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c1d:	c9                   	leaveq 
  803c1e:	c3                   	retq   

0000000000803c1f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803c1f:	55                   	push   %rbp
  803c20:	48 89 e5             	mov    %rsp,%rbp
  803c23:	48 83 ec 10          	sub    $0x10,%rsp
  803c27:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803c2b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803c2f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c33:	48 be 26 46 80 00 00 	movabs $0x804626,%rsi
  803c3a:	00 00 00 
  803c3d:	48 89 c7             	mov    %rax,%rdi
  803c40:	48 b8 d2 18 80 00 00 	movabs $0x8018d2,%rax
  803c47:	00 00 00 
  803c4a:	ff d0                	callq  *%rax
	return 0;
  803c4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c51:	c9                   	leaveq 
  803c52:	c3                   	retq   

0000000000803c53 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803c53:	55                   	push   %rbp
  803c54:	48 89 e5             	mov    %rsp,%rbp
  803c57:	48 83 ec 30          	sub    $0x30,%rsp
  803c5b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803c5f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c63:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803c67:	48 b8 d8 71 80 00 00 	movabs $0x8071d8,%rax
  803c6e:	00 00 00 
  803c71:	48 8b 00             	mov    (%rax),%rax
  803c74:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803c7a:	85 c0                	test   %eax,%eax
  803c7c:	75 3c                	jne    803cba <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  803c7e:	48 b8 85 21 80 00 00 	movabs $0x802185,%rax
  803c85:	00 00 00 
  803c88:	ff d0                	callq  *%rax
  803c8a:	25 ff 03 00 00       	and    $0x3ff,%eax
  803c8f:	48 63 d0             	movslq %eax,%rdx
  803c92:	48 89 d0             	mov    %rdx,%rax
  803c95:	48 c1 e0 03          	shl    $0x3,%rax
  803c99:	48 01 d0             	add    %rdx,%rax
  803c9c:	48 c1 e0 05          	shl    $0x5,%rax
  803ca0:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803ca7:	00 00 00 
  803caa:	48 01 c2             	add    %rax,%rdx
  803cad:	48 b8 d8 71 80 00 00 	movabs $0x8071d8,%rax
  803cb4:	00 00 00 
  803cb7:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803cba:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803cbf:	75 0e                	jne    803ccf <ipc_recv+0x7c>
		pg = (void*) UTOP;
  803cc1:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803cc8:	00 00 00 
  803ccb:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803ccf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cd3:	48 89 c7             	mov    %rax,%rdi
  803cd6:	48 b8 2a 24 80 00 00 	movabs $0x80242a,%rax
  803cdd:	00 00 00 
  803ce0:	ff d0                	callq  *%rax
  803ce2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803ce5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ce9:	79 19                	jns    803d04 <ipc_recv+0xb1>
		*from_env_store = 0;
  803ceb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cef:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803cf5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cf9:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803cff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d02:	eb 53                	jmp    803d57 <ipc_recv+0x104>
	}
	if(from_env_store)
  803d04:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803d09:	74 19                	je     803d24 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  803d0b:	48 b8 d8 71 80 00 00 	movabs $0x8071d8,%rax
  803d12:	00 00 00 
  803d15:	48 8b 00             	mov    (%rax),%rax
  803d18:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803d1e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d22:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803d24:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803d29:	74 19                	je     803d44 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  803d2b:	48 b8 d8 71 80 00 00 	movabs $0x8071d8,%rax
  803d32:	00 00 00 
  803d35:	48 8b 00             	mov    (%rax),%rax
  803d38:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803d3e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d42:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803d44:	48 b8 d8 71 80 00 00 	movabs $0x8071d8,%rax
  803d4b:	00 00 00 
  803d4e:	48 8b 00             	mov    (%rax),%rax
  803d51:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803d57:	c9                   	leaveq 
  803d58:	c3                   	retq   

0000000000803d59 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803d59:	55                   	push   %rbp
  803d5a:	48 89 e5             	mov    %rsp,%rbp
  803d5d:	48 83 ec 30          	sub    $0x30,%rsp
  803d61:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d64:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803d67:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803d6b:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803d6e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803d73:	75 0e                	jne    803d83 <ipc_send+0x2a>
		pg = (void*)UTOP;
  803d75:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803d7c:	00 00 00 
  803d7f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  803d83:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803d86:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803d89:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803d8d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d90:	89 c7                	mov    %eax,%edi
  803d92:	48 b8 d5 23 80 00 00 	movabs $0x8023d5,%rax
  803d99:	00 00 00 
  803d9c:	ff d0                	callq  *%rax
  803d9e:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  803da1:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803da5:	75 0c                	jne    803db3 <ipc_send+0x5a>
			sys_yield();
  803da7:	48 b8 c3 21 80 00 00 	movabs $0x8021c3,%rax
  803dae:	00 00 00 
  803db1:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  803db3:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803db7:	74 ca                	je     803d83 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  803db9:	c9                   	leaveq 
  803dba:	c3                   	retq   

0000000000803dbb <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803dbb:	55                   	push   %rbp
  803dbc:	48 89 e5             	mov    %rsp,%rbp
  803dbf:	48 83 ec 14          	sub    $0x14,%rsp
  803dc3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  803dc6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803dcd:	eb 5e                	jmp    803e2d <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803dcf:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803dd6:	00 00 00 
  803dd9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ddc:	48 63 d0             	movslq %eax,%rdx
  803ddf:	48 89 d0             	mov    %rdx,%rax
  803de2:	48 c1 e0 03          	shl    $0x3,%rax
  803de6:	48 01 d0             	add    %rdx,%rax
  803de9:	48 c1 e0 05          	shl    $0x5,%rax
  803ded:	48 01 c8             	add    %rcx,%rax
  803df0:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803df6:	8b 00                	mov    (%rax),%eax
  803df8:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803dfb:	75 2c                	jne    803e29 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803dfd:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803e04:	00 00 00 
  803e07:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e0a:	48 63 d0             	movslq %eax,%rdx
  803e0d:	48 89 d0             	mov    %rdx,%rax
  803e10:	48 c1 e0 03          	shl    $0x3,%rax
  803e14:	48 01 d0             	add    %rdx,%rax
  803e17:	48 c1 e0 05          	shl    $0x5,%rax
  803e1b:	48 01 c8             	add    %rcx,%rax
  803e1e:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803e24:	8b 40 08             	mov    0x8(%rax),%eax
  803e27:	eb 12                	jmp    803e3b <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803e29:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803e2d:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803e34:	7e 99                	jle    803dcf <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803e36:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e3b:	c9                   	leaveq 
  803e3c:	c3                   	retq   

0000000000803e3d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803e3d:	55                   	push   %rbp
  803e3e:	48 89 e5             	mov    %rsp,%rbp
  803e41:	48 83 ec 18          	sub    $0x18,%rsp
  803e45:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803e49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e4d:	48 c1 e8 15          	shr    $0x15,%rax
  803e51:	48 89 c2             	mov    %rax,%rdx
  803e54:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803e5b:	01 00 00 
  803e5e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e62:	83 e0 01             	and    $0x1,%eax
  803e65:	48 85 c0             	test   %rax,%rax
  803e68:	75 07                	jne    803e71 <pageref+0x34>
		return 0;
  803e6a:	b8 00 00 00 00       	mov    $0x0,%eax
  803e6f:	eb 53                	jmp    803ec4 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803e71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e75:	48 c1 e8 0c          	shr    $0xc,%rax
  803e79:	48 89 c2             	mov    %rax,%rdx
  803e7c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803e83:	01 00 00 
  803e86:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e8a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803e8e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e92:	83 e0 01             	and    $0x1,%eax
  803e95:	48 85 c0             	test   %rax,%rax
  803e98:	75 07                	jne    803ea1 <pageref+0x64>
		return 0;
  803e9a:	b8 00 00 00 00       	mov    $0x0,%eax
  803e9f:	eb 23                	jmp    803ec4 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803ea1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ea5:	48 c1 e8 0c          	shr    $0xc,%rax
  803ea9:	48 89 c2             	mov    %rax,%rdx
  803eac:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803eb3:	00 00 00 
  803eb6:	48 c1 e2 04          	shl    $0x4,%rdx
  803eba:	48 01 d0             	add    %rdx,%rax
  803ebd:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803ec1:	0f b7 c0             	movzwl %ax,%eax
}
  803ec4:	c9                   	leaveq 
  803ec5:	c3                   	retq   
